#!/usr/bin/env sh

#See https://developers.google.com/closure/compiler/
#See https://code.google.com/p/closure-compiler/
#See https://code.google.com/p/closure-compiler/wiki/BuildingWithAnt

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_googleClosureCompilerDir="$_libDir/google-closure-compiler-latest"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_googleClosureCompilerDir" ] || [ ! -s "$_googleClosureCompilerDir/compiler.jar" ]; then
  echo "Error: Could not find \"$_googleClosureCompilerDir/compiler.jar\"" > /dev/stderr
  return
fi

#Execute using its command line intereface.
if [ -z "$*" ]; then
java \
  -server -XX:+TieredCompilation \
  -jar "$_googleClosureCompilerDir/compiler.jar" \
  --help
else
java \
  -server -XX:+TieredCompilation \
  -jar "$_googleClosureCompilerDir/compiler.jar" \
  "$@"
fi
