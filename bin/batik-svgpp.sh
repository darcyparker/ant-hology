#!/usr/bin/env sh

#See http://xmlgraphics.apache.org/batik/tools/pretty-printer.html

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_batikDir="$_libDir/apache-batik-1.8"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_batikDir" ] || [ ! -s "$_batikDir/batik-1.8.jar" ]; then
  echo "Error: Could not find \"$_batikDir/batik-1.8.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_batikDir" ] || [ ! -s "$_batikDir/batik-svgpp-1.8.jar" ]; then
  echo "Error: Could not find \"$_batikDir/batik-svgpp-1.8.jar\"" > /dev/stderr
  return
fi

#Execute batik-svgpp (SVG pretty printer)
#To do: Replace jar with main class and setup classpath
java \
  -jar "$_batikDir/batik-svgpp-1.8.jar" \
  "$@"
