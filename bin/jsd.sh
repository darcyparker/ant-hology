#!/usr/bin/env sh

#See https://developer.mozilla.org/en-US/docs/Rhino_documentation

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_rhinoDir="$_libDir/rhino-1.7R4"

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

#Execute rhino js debugger using its command line intereface.
java \
  -cp \
"$_rhinoDir/js.jar"\
  org.mozilla.javascript.tools.debugger.Main \
  "$@"
