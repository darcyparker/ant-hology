#!/usr/bin/env sh

#See http://docs.oracle.com/cd/B28359_01/appdev.111/b28391/oracle/xml/parser/v2/oraxml.html

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_oracleDir="$_libDir/oracle-xml"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_oracleDir" ] || [ ! -s "$_oracleDir/xmlparserv2.jar" ]; then
  echo "Error: Could not find \"$_oracleDir/xmlparserv2.jar\"" > /dev/stderr
  return
fi

# The oraxml class provides a command-line interface to validate XML files
#Doesn't work offline
#Haven't figured out how to use xmlcatalog with oraxml command line
java \
  -cp "$_oracleDir/xmlparserv2.jar" \
  oracle.xml.parser.v2.oraxml \
  "$@"
