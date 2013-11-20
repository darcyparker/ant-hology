#!/usr/bin/env sh

#See http://about.validator.nu/htmlparser/

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_htmlparserDir="$_libDir/htmlparser-1.4"
_icu4jDir="$_libDir/icu4j-51.2"
_jchardetDir="$_libDir/jchardet-1.1/dist/lib"
_XOMDir="$_libDir/xom-1.2.10"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_htmlparserDir" ] || [ ! -s "$_htmlparserDir/htmlparser-1.4.jar" ]; then
  echo "Error: Could not find \"$_htmlparserDir/htmlparser-1.4.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_icu4jDir" ] || [ ! -s "$_icu4jDir/icu4j-51_2.jar" ]; then
  echo "Error: Could not find \"$_icu4jDir/icu4j-51_2.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_icu4jDir" ] || [ ! -s "$_icu4jDir/icu4j-charset-51_2.jar" ]; then
  echo "Error: Could not find \"$_icu4jDir/icu4j-charset-51_2.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_icu4jDir" ] || [ ! -s "$_icu4jDir/icu4j-localespi-51_2.jar" ]; then
  echo "Error: Could not find \"$_icu4jDir/icu4j-localespi-51_2.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_jchardetDir" ] || [ ! -s "$_jchardetDir/chardet.jar" ]; then
  echo "Error: Could not find \"$_jchardetDir/chardet.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_XOMDir" ] || [ ! -s "$_XOMDir/xom-1.2.10.jar" ]; then
  echo "Error: Could not find \"$_XOMDir/xom-1.2.10.jar\"" > /dev/stderr
  return
fi

#Execute using its command line intereface.
if [ -z "$*" ]; then
  echo Usage: html5_to_xml.sh input output
  echo
else
  java \
  -cp \
"$_htmlparserDir/htmlparser-1.4.jar":\
"$_icu4jDir/icu4j-51_2.jar":\
"$_icu4jDir/icu4j-charset-51_2.jar":\
"$_icu4jDir/icu4j-localespi-51_2.jar":\
"$_jchardetDir/chardet.jar":\
"$_XOMDir/xom-1.2.10.jar":\
  nu.validator.htmlparser.tools.HTML2XML \
  "$@"
fi
