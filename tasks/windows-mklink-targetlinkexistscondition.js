/* jshint rhino: true, unused: false */
/* global project,self */
/* The directives above tell jshint about globals provided by ant and rhino */

//This script tests if MS Windows [SYMLINK] defined in ${_target} exists yet
//AND if it points to ${_source}
//This is used by: windows-mklink.xml.

//See https://ant.apache.org/manual/Tasks/conditions.html#scriptcondition
(function(project, self) {
  'use strict';

  //Creating echo task instead of using self.log() so messages are aligned with other tasks
  var echoTask=project.createTask('echo');
  var echoMessage=function(message){
    echoTask.setMessage(message);
    echoTask.perform();
  };

  //See http://docs.oracle.com/javase/7/docs/api/java/io/File.html
  var File = java.io.File;
  //See http://docs.oracle.com/javase/7/docs/api/java/nio/file/Files.html
  var isSymbolicLink = java.nio.file.Files.isSymbolicLink;
  var readSymbolicLink = java.nio.file.Files.readSymbolicLink;

  //Note: Values that will be compared are converted to JS String!
  //      Must not confuse java string vs javascript string. Otherwise
  //      comparison will always be false
  var targetPathString = project.getProperty('_targetPath');
  var targetFile = new File(targetPathString);
  var targetFilePath = targetFile.toPath();
  var targetFilePathJSString = String(targetFilePath.toString());

  var sourcePathString = project.getProperty('_sourcePath');
  var sourceFile = new File(sourcePathString);
  var sourceFilePath = sourceFile.toPath();
  var sourceFilePathJSString = String(sourceFilePath.toString());

  if (isSymbolicLink(targetFilePath)) {
    //Symbolic link exists. Now test what it points to.
    echoMessage('Good: [SYMLINK]: \"' + targetFilePathJSString + '\" exists.');
    var targetFilePathSymbolicLinkJSString=String(readSymbolicLink(targetFilePath).toString());
    if (targetFilePathSymbolicLinkJSString === sourceFilePathJSString) {
      echoMessage('Good: Points to: \"' + targetFilePathSymbolicLinkJSString + '\"');
      self.setValue(true);
    } else {
      echoMessage('Error: Points to: \"' + targetFilePathSymbolicLinkJSString + '\"');
      echoMessage('       Expected : \"' + targetFilePathJSString + '\"');
      self.setValue(false);
    }
  } else {
    echoMessage('[SYMLINK] \"' + targetFilePathJSString + '\" does not exist yet.');
    self.setValue(false);
  }
})(project, self);
