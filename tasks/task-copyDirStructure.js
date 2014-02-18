/* jshint rhino: true, unused: false */
/* global project,self,attributes,elements */
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

  //Get attribute and element passed into task
  //Note: ant converts attributes to lowercase!
  var toDir = attributes.get('todir');
  var fileSet = elements.get('fileset').get(0); //the first fileset
  var sourceBaseDir = fileSet.getDir();
  var directoryScanner = fileSet.getDirectoryScanner(project);
  var includedDirs = directoryScanner.getIncludedDirectories();
  var includedDirsCount = directoryScanner.getIncludedDirsCount();
  var includedFiles = directoryScanner.getIncludedFiles();
  var includedFilesCount = directoryScanner.getIncludedFilesCount();
  var currentDir;

  //self.log('toDir=' + String(toDir));
  //self.log('sourceBaseDir=' + String(sourceBaseDir));
  //self.log('dircount=' + includedDirsCount);
  //self.log('Filescount=' + includedFilesCount);
  for (var i = 0; i < includedDirsCount; i++) {
    currentDir = new File(toDir, includedDirs[i]);
    if (!currentDir.exists()) {
      if (!currentDir.mkdirs()) {
        self.fail('Error: Could not make dir: ' + String(currentDir));
      }
    }
  }
  for (i = 0; i < includedFilesCount; i++) {
    currentDir = (new File(toDir, includedFiles[i])).getParentFile();
    if (!currentDir.exists()) {
      if (!currentDir.mkdirs()) {
        self.fail('Error: Could not make dir: ' + String(currentDir));
      }
    }
  }
})(project, self, attributes, elements);
