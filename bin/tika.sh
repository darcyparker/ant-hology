#!/usr/bin/env sh

#See https://tika.apache.org/

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_tikaDir="$_libDir/apache-tika-app-1.6"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_tikaDir" ] || [ ! -s "$_tikaDir/tika-app-1.6.jar" ]; then
  echo "Error: Could not find \"$_tikaDir/tika-app-1.6.jar\"" > /dev/stderr
  return
fi

#Execute tika-app using its command line intereface.
#If no parameters passed, then execute with -h so help can be viewed
#Otherwise,execute with parameters passed
if [ -z "$*" ]; then
  java \
    -jar "$_tikaDir/tika-app-1.6.jar" \
    -?
else
  java \
    '-Dorg.xml.sax.driver=org.apache.xml.resolver.tools.ResolvingXMLReader' \
    '-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl' \
    '-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl' \
    '-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration' \
    -jar "$_tikaDir/tika-app-1.6.jar" \
    "$@"
fi
