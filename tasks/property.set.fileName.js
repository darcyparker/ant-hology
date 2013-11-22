/* jshint rhino: true, unused: false */
/* global project,self,attributes,elements */
/* The directives above tell jshint about globals provided by ant and rhino */

(function(project, self, attributes, elements) {
  'use strict';

  //Get attributes passed into task
  //Note: ant converts attributes to lowercase!
  var propertyNameToSet = attributes.get('property');
  var filePathString = attributes.get('filepath');

  //Only proceed if propertyName not already set
  if (project.getProperty(propertyNameToSet) === null) {

    var File = java.io.File;
    var file = new File(filePathString);
    var fileName = file.getName();

    var fileNameProperty = project.createTask('property');
    fileNameProperty.setName(propertyNameToSet);
    fileNameProperty.setValue(fileName);
    fileNameProperty.perform();
  }


})(project, self, attributes, elements);
