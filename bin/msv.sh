#!/usr/bin/env sh

#See https://msv.java.net/  (msv and xsdlib)

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_msvDir="$_libDir/msv-20090415"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_msvDir" ] || [ ! -s "$_msvDir/msv.jar" ]; then
  echo "Error: Could not find \"$_msvDir/msv.jar\"" > /dev/stderr
  return
fi

#Execute using its command line intereface.
#See https://msv.java.net/  (msv and xsdlib)
java \
  -jar "$_msvDir/msv.jar" \
  "$@"
