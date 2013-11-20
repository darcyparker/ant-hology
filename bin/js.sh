#!/usr/bin/env sh

#See https://developer.mozilla.org/en-US/docs/Rhino_documentation

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_rhinoDir="$_libDir/rhino-1.7R4"
_jlineDir="$_libDir/jline-1.0"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_rhinoDir" ] || [ ! -s "$_rhinoDir/js.jar" ]; then
  echo "Error: Could not find \"$_rhinoDir/js.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_jlineDir" ] || [ ! -s "$_jlineDir/jline-1.0.jar" ]; then
  echo "Error: Could not find \"$_jlineDir/jline-1.0.jar\"" > /dev/stderr
  return
fi

#Execute rhino js shell using its command line intereface.
java \
  -cp \
"$_rhinoDir/js.jar":\
"$_jlineDir/jline-1.0.jar"\
  jline.ConsoleRunner org.mozilla.javascript.tools.shell.Main \
  -opt -1 \
  "$@"
