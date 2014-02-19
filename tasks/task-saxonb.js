/* jshint rhino: true, unused: false */
/* global project,self,attributes,elements,net,org,javax */
/* The directives above tell jshint about globals provided by ant and rhino */

(function(project, self, attributes, elements) {
  'use strict';

  //Creating echo task instead of using self.log() so messages are aligned with other tasks
  var echoTask = project.createTask('echo');
  var echoMessage = function(message) {
    echoTask.setMessage(message);
    echoTask.perform();
  };

  //See http://docs.oracle.com/javase/7/docs/api/java/io/File.html
  var File = java.io.File;

  //Get attributes and elements passed into task
  //Note: ant converts attributes to lowercase!
  var xsl = attributes.get('xsl');

  var srcdir = attributes.get('srcdir');
  var srcfile = attributes.get('srcfile');
  var destfile = attributes.get('destfile');
  var destdir = attributes.get('destdir');

  var initialtemplate = attributes.get('initialtemplate');
  var initialmode = attributes.get('initialmode');
  var parametersString = attributes.get('parameters');

  var inputOutputPairs = [];

  var srcFile;
  var destFile;
  var destFileParentFile;
  var xslFile;

  var fileSets = elements.get('fileset');
  var mappers = elements.get('mapper');
  var currentFile;
  var targetFile;
  var targetFileParentFile;

  //self.log('Attributes:');
  //self.log('===========');

  //Must specific an existing xsl file
  if (xsl) {
    xslFile = new File(xsl);
    if (!xslFile.exists()) {
      self.fail('Error: xsl file \'' + String(xslFile.getAbsoluteFile()) + '\' does not exist.');
    }
    //self.log('xslFile=' + String(xslFile));
  } else {
    self.fail('No xsl provided.');
  }

  //construct srcFile and destFile pair if necessary
  if (srcfile) {
    if (srcdir) {
      srcFile = new File(srcdir, srcfile);
      //self.log('srcFile='+srcFile);
      if (!srcFile.exists()) {
        self.log('srcdir=' + srcdir);
        self.log('srcfile=' + srcfile);
        self.fail('srcdir/srcfile provided does not exists. \'' + String(srcFile) + '\'');
      }
    } else {
      //Note: It is not necessarily relative to project.getBaseDir()
      //An absolute file path could have been provided
      srcFile = new File(srcfile);
      self.log('srcFile=' + srcFile);
      if (!srcFile.exists()) {
        self.log('srcdir=' + srcdir);
        self.log('srcfile=' + srcfile);
        self.fail('srcfile provided does not exists. \'' + String(srcFile) + '\'');
      }
    }
  }
  //construct destFile if necessary
  if (destfile) {
    if (destdir) {
      destFile = new File(destdir, destfile);
      //self.log('destFile='+destFile);
    } else {
      //Note: It is not necessarily relative to project.getBaseDir()
      //An absolute file path could have been provided
      destFile = new File(destfile);
      //self.log('destFile='+destFile);
    }
    //destFile doesn't have to exist, but its parent should
    destFileParentFile = destFile.getParentFile();
    if (!destFileParentFile.exists()) {
      //Make the destination's parent directory and its parents
      if (!destFileParentFile.mkdirs()) {
        self.log('destdir=' + destdir);
        self.log('destfile=' + destfile);
        self.fail('Destination\'s parent directory does not exist and could not be created. Destination=\'' + String(destFile) + '\'');
      }
    } else if (!destFileParentFile.isDirectory()) {
      self.log('destdir=' + destdir);
      self.log('destfile=' + destfile);
      self.fail('Destination\'s parent is not a directory. Destination=\'' + String(destFile) + '\'');
    }
  }
  if (srcFile && srcFile.exists() && destFile) {
    //self.log('srcFile=' + String(srcFile));
    //self.log('destFile=' + String(destFile));
    //Add srcFile and destFile pair to inputOutputPairs[]
    inputOutputPairs.push({
      input: srcFile,
      output: destFile
    });
  }

  //if fileSet and mapper is provided
  //construct add their source/target pairs
  if (fileSets) {
    if (mappers) {
      var fileSet = fileSets.get(0); //the first fileset
      var sourceBaseDir = fileSet.getDir();
      var directoryScanner = fileSet.getDirectoryScanner(project);
      var includedFiles = directoryScanner.getIncludedFiles();
      var includedFilesCount = directoryScanner.getIncludedFilesCount();
      var mapper = mappers.get(0); //the first inputToOutputMapper
      var targetFileMappers;
      for (var i = 0; i < includedFilesCount; i++) {
        currentFile = new File(sourceBaseDir, includedFiles[i]);
        //self.log('currentFile=' + String(currentFile));
        //Mapper is a composite of many mappers,
        //so select last mapped item with slice(-1)[0] or pop();
        targetFileMappers = mapper.mapFileName(includedFiles[i]);

        if (targetFileMappers) {
          targetFile = new File(targetFileMappers[targetFileMappers.length - 1]);
          //self.log('targetFile=' + String(targetFile));
          //targetFile doesn't have to exist, but its parent should
          targetFileParentFile = targetFile.getParentFile();
          if (!targetFileParentFile.exists()) {
            //Make the destination's parent directory and its parents
            if (!targetFileParentFile.mkdirs()) {
              self.log('source=\'' + String(currentFile) + '\'');
              self.fail('Target\'s parent directory does not exist and could not be created. target=\'' + String(targetFile) + '\'');
            }
          } else if (!targetFileParentFile.isDirectory()) {
            self.log('source=\'' + String(currentFile) + '\'');
            self.fail('Target\'s parent is not a directory. target=\'' + String(targetFile) + '\'');
          }
          //Add currentFile and targetFile pair to inputOutputPairs[]
          inputOutputPairs.push({
            input: currentFile,
            output: targetFile
          });
        } else {
          self.log('Warning: Mapping rule does not apply for file: \'' + String(currentFile) + '\'');
        }
      }
    } //end if mappers
  } //end if filesets

  //self.log('FilesToTransform=' + inputOutputPairs.length);

  //See http://docs.oracle.com/javase/6/docs/api/javax/xml/transform/stream/StreamSource.html
  var StreamSource = javax.xml.transform.stream.StreamSource;
  //See http://docs.oracle.com/javase/6/docs/api/javax/xml/transform/stream/StreamResult.html
  var StreamResult = javax.xml.transform.stream.StreamResult;
  //http://docs.oracle.com/javase/7/docs/api/java/lang/System.html
  var System = java.lang.System;

  System.setProperty('org.xml.sax.driver',
    org.apache.xml.resolver.tools.ResolvingXMLReader);
  System.setProperty('javax.xml.parsers.DocumentBuilderFactory',
    org.apache.xerces.jaxp.DocumentBuilderFactoryImpl);

  //s9api for transforing
  //s9api is preferred for saxon because it allows greater configuration
  //for example, initialtemplate and initialmode can be used

  //See http://www.saxonica.com/html/documentation/javadoc/net/sf/saxon/s9api/Processor.html
  var Processor = net.sf.saxon.s9api.Processor;
  //See http://www.saxonica.com/html/documentation/javadoc/net/sf/saxon/s9api/QName.html
  var QName = net.sf.saxon.s9api.QName;
  //See http://www.saxonica.com/html/documentation/javadoc/net/sf/saxon/s9api/XdmAtomicValue.html
  var XdmAtomicValue = net.sf.saxon.s9api.XdmAtomicValue;
  //See http://www.saxonica.com/html/documentation/javadoc/net/sf/saxon/s9api/XdmNode.html
  var XdmNode = net.sf.saxon.s9api.XdmNode;
  //See http://www.saxonica.com/html/documentation/javadoc/net/sf/saxon/s9api/Serializer.html
  var Serializer = net.sf.saxon.s9api.Serializer;

  var proc = new Processor(false); //create saxon processor (licensedEdition===false)
  var comp = proc.newXsltCompiler(); //create an xslt compiler
  var exp = comp.compile(new StreamSource(xslFile)); //compile xslFile
  var trans = exp.load(); //create the transformer by loading compiled xslFile
  //Set initialtemplate if applicable
  if (initialtemplate) {
    trans.setInitialTemplate(new QName(initialtemplate));
  }
  //Set initialmode if applicable
  if (initialmode) {
    trans.setInitialMode(new QName(initialmode));
  }
  //Set parameters
  if (parametersString) {
    //self.log('parametersString=' + parametersString);
    if (!parametersString.contains(';')) {
      if (parametersString.contains('=')) {
        //then only a single parameter was passed
        //self.log('adding parameter:' + parametersString.substring(0, parametersString.indexOf('=')) + ' = ' +
          //parametersString.substring(parametersString.indexOf('=') + 1));
        trans.setParameter(
          new QName(parametersString.substring(0, parametersString.indexOf('='))),
          new XdmAtomicValue(parametersString.substring(parametersString.indexOf('=') + 1))
        );
      }
    } else {
      //then multiple parameters were passed
      var keyvalues = parametersString.split(';');
      for (var currentParameter = 0; currentParameter < keyvalues.length; currentParameter++) {
        if (keyvalues.contains('=')) {
          //self.log('adding parameter:' + keyvalues.substring(0, keyvalues.indexOf('=')) + '=' +
            //keyvalues.substring(keyvalues.indexOf('=') + 1));
          trans.setParameter(
            new QName(keyvalues.substring(0, keyvalues.indexOf('='))),
            new XdmAtomicValue(keyvalues.substring(keyvalues.indexOf('=') + 1))
          );
        }
      }
    }
  }

  var currentSource;
  var currentDestination;

  //Transform each input
  if (inputOutputPairs.length > 0) {
    for (var items = 0; items < inputOutputPairs.length; items++) {
      // Transform the source to output
      //self.log('Transforming input: ' + String(inputOutputPairs[items].input));
      //self.log('to output: ' + String(inputOutputPairs[items].output));
      currentSource = proc.newDocumentBuilder().build(new StreamSource(inputOutputPairs[items].input));
      trans.setInitialContextNode(currentSource);
      currentDestination = new Serializer();
      currentDestination.setOutputFile(inputOutputPairs[items].output);
      trans.setDestination(currentDestination);
      trans.transform();
      //close??
    }
  } else {
    //No input provided... Therefore there must be an initialtemplate
    if (initialtemplate) {
      currentDestination = new Serializer();
      currentDestination.setOutputFile(destFile);
      trans.setDestination(currentDestination);
      trans.transform();
      //close??
    } else {
      self.fail('Error: No initialtemplate provided. When no input srcfile and destfile is provided AND no fileset and mapper is provided, an initialtemplate is expected.');
    }
  }

  //JAXP (trax) for transforming
  //http://docs.oracle.com/javase/6/docs/api/javax/xml/transform/package-summary.html
  //Currently commented out. s9api is used instead.
  //var TransformerFactory = net.sf.saxon.TransformerFactoryImpl;

  //// Create a transform factory instance.
  //var tfactory = TransformerFactory.newInstance();

  //System.setProperty('org.xml.sax.driver',
  //org.apache.xml.resolver.tools.ResolvingXMLReader);
  //System.setProperty('javax.xml.parsers.DocumentBuilderFactory',
  //org.apache.xerces.jaxp.DocumentBuilderFactoryImpl);
  ////System.setProperty('org.apache.xerces.xni.parser.XMLParserConfiguration',
  ////org.apache.xerces.parsers.XIncludeParserConfiguration);

  ////sourceParserClass corresponds to command line -x option
  //tfactory.setAttribute('http://saxon.sf.net/feature/sourceParserClass',
  //'org.apache.xml.resolver.tools.ResolvingXMLReader');
  ////styleParserClass corresponds to command line -y option
  //tfactory.setAttribute('http://saxon.sf.net/feature/styleParserClass',
  //'org.apache.xml.resolver.tools.ResolvingXMLReader');
  ////version-warning corresponds to the command line -versionmsg option
  //tfactory.setAttribute('http://saxon.sf.net/feature/version-warning',
  //false);
  ////No validation
  //tfactory.setAttribute('http://saxon.sf.net/feature/validation',
  //false);
  ////allow-external-functions corresponds to the command line -ext option
  //tfactory.setAttribute('http://saxon.sf.net/feature/allow-external-functions',
  //true);
  ////linenumbering corresponds to the command line -l option
  //tfactory.setAttribute('http://saxon.sf.net/feature/linenumbering',
  //true);

  //// Create a transformer for the stylesheet.
  //var transformer = tfactory.newTransformer(new StreamSource(xslFile));

  ////Set parameters
  //if (parametersString) {
  //var keyvalues = String(parametersString).split(';');
  //for (var currentParameter = 0; currentParameter < keyvalues.length; currentParameter++) {
  //var keyvalue = currentParameter.split('=');
  //if (keyvalue.length === 2) {
  //transformer.setParameter(new java.lang.String(keyvalue[0]), new java.lang.String(keyvalue[1]));
  //}
  //}
  //}

  //if (inputOutputPairs.length !== 0) {
  //for (var items = 0; items < inputOutputPairs.length; items++) {
  //// Transform the source to output
  //self.log('Transforming input: ' + String(inputOutputPairs[items].input));
  //self.log('to output: ' + String(inputOutputPairs[items].output));
  //transformer.transform(
  //new StreamSource(inputOutputPairs[items].input),
  //new StreamResult(inputOutputPairs[items].output));
  //}
  //} else {
  ////jaxp doesn't allow transforms using initialtemplate or initialmode
  //}

})(project, self, attributes, elements);
