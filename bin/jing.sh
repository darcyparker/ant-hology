#!/usr/bin/env sh

#See https://code.google.com/p/jing-trang
#See http://www.thaiopensource.com/relaxng/jing.html

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_jingDir="$_libDir/jing-20091111/bin"
_xercesDir="$_libDir/apache-xerces-2.11.0"
_resolverDir="$_libDir/apache-commons-xmlresolver-1.2"
_XMLCatalogDir=$( cd "$_thisDir/../../XMLCatalog" ; pwd )
_XMLCommonsDir="$_libDir/apache-commons-xml-external-1.4.01"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_jingDir" ] || [ ! -s "$_jingDir/jing.jar" ]; then
  echo "Error: Could not find \"$_jingDir/jing.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_jingDir" ] || [ ! -s "$_jingDir/isorelax.jar" ]; then
  echo "Error: Could not find \"$_jingDir/isorelax.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_XMLCommonsDir" ] || [ ! -s "$_XMLCommonsDir/xml-apis.jar" ]; then
  echo "Error: Could not find \"$_XMLCommonsDir/xml-apis.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_XMLCommonsDir" ] || [ ! -s "$_XMLCommonsDir/xml-apis-ext.jar" ]; then
  echo "Error: Could not find \"$_XMLCommonsDir/xml-apis-ext.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_xercesDir" ] || [ ! -s "$_xercesDir/xercesImpl.jar" ]; then
  echo "Error: Could not find \"$_xercesDir/xercesImpl.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_resolverDir" ] || [ ! -s "$_resolverDir/resolver.jar" ]; then
  echo "Error: Could not find \"$_resolverDir/resolver.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_XMLCatalogDir" ] || [ ! -s "$_XMLCatalogDir/catalog.xml" ]; then
  echo "Error: Could not find \"$_XMLCatalogDir/catalog.xml\"" > /dev/stderr
  return
fi

#Execute jing using its command line intereface.
#Example execution
#jing.sh -C XMLCatalog/catalog.xml -I rnc -O xsd XMLCatalog/schematron/iso/iso-schematron.rnc XMLCatalog/schematron/iso/iso-schematron.xsd
if [ -z "$*" ]; then
  java \
    -jar "$_jingDir/jing.jar"
else
  java \
    -cp \
"$_xercesDir/xercesImpl.jar":\
"$_resolverDir/resolver.jar":\
"$_XMLCatalogDir":\
"$_jingDir/jing.jar":\
"$_jingDir/isorelax.jar":\
    '-Dorg.xml.sax.driver=org.apache.xml.resolver.tools.ResolvingXMLReader' \
    '-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl' \
    '-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl' \
    '-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration' \
    com.thaiopensource.relaxng.util.Driver \
    -C XMLCatalog/catalog.xml \
    "$@"
fi
