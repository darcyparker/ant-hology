#!/usr/bin/env sh

#See http://jtidy.sourceforge.net/apidocs/org/w3c/tidy/ant/JTidyTask.html
#See http://jtidy.sourceforge.net/apidocs/org/w3c/tidy/Configuration.html for properties

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_jtidyDir="$_libDir/jtidy-r938"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_jtidyDir" ] || [ ! -s "$_jtidyDir/jtidy-r938.jar" ]; then
  echo "Error: Could not find \"$_jtidyDir/jtidy-r938.jar\"" > /dev/stderr
  return
fi

#Execute jtidy using its command line intereface.
#If no parameters passed, then execute with -h so help can be viewed
#Otherwise,execute with parameters passed
if [ -z "$*" ]; then
  java \
    -jar "$_jtidyDir/jtidy-r938.jar" \
    -h
else
  java \
    -jar "$_jtidyDir/jtidy-r938.jar" \
    "$@"
fi
