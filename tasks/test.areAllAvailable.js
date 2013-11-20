/* jshint rhino: true, unused: false */
/* global project,self,attributes,elements */
/* The directives above tell jshint about globals provided by ant and rhino */

(function(project, self, attributes, elements) {
  'use strict';

  //Creating echo task instead of using self.log() so messages are aligned with other tasks
  var echoTask=project.createTask('echo');
  var echoMessage=function(message){
    echoTask.setMessage(message);
    echoTask.perform();
  };

  //Get attributes passed into task
  //Note: ant converts attributes to lowercase!
  var propertyNameToSet = attributes.get('property');
  var pathsRefIdString = attributes.get('pathrefid');

  //Only proceed if propertyName not already set
  if (project.getProperty(propertyNameToSet) === null) {
    //Look up file paths to search for
    var antFiles, filesList;
    antFiles = project.getReference(pathsRefIdString);
    if (antFiles === null) {
      self.fail('Error: Could not find reference \'' + pathsRefIdString + '\'.');
    }

    //echoMessage('antfiles.size='+antFiles.size());
    if (antFiles.size() > 0) {
      var pathSeparator = project.getProperty('path.separator');
      //Convert to java string and then javascript string before splitting
      //filesList is a javascript array
      filesList = String(antFiles.toString()).split(pathSeparator);
      //echoMessage('Is filesList an array?=' + (Object.prototype.toString.call(filesList) === '[object Array]'));

      var File = java.io.File;
      var currentFile, currentFileExists;
      var fileListPosition = filesList.length;
      //echoMessage('length=' + fileListPosition);

      //Iterate of each file to check if it exists
      do {
        fileListPosition--;
        currentFile = new File(filesList[fileListPosition]);
        //echoMessage('item=' + fileListPosition + ' currentFile=' + currentFile);
        currentFileExists = currentFile.exists();
        if (!currentFileExists) {
          echoMessage('Warning: ' + filesList[fileListPosition] + ' does not exist.');
        }
      } while (fileListPosition > 0 && currentFileExists);

      //Only set the property if all files exist
      if (fileListPosition === 0 && currentFileExists) {
        var areAllAvailableProperty = project.createTask('property');
        areAllAvailableProperty.setName(propertyNameToSet);
        areAllAvailableProperty.setValue(true);
        areAllAvailableProperty.perform();
      } else {
        echoMessage('Warning: Some files in \'' + pathsRefIdString +
          '\' do not exist. Property \'' +
          propertyNameToSet + '\' was not set.');
      }
    }
  }


})(project, self, attributes, elements);
