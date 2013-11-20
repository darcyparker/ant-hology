#!/usr/bin/env sh

#See https://code.google.com/p/jing-trang
#See http://www.thaiopensource.com/relaxng/trang.html

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_trangDir="$_libDir/trang-20091111"
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
if [ ! -d "$_trangDir" ] || [ ! -s "$_trangDir/trang.jar" ]; then
  echo "Error: Could not find \"$_trangDir/trang.jar\"" > /dev/stderr
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

#Execute trang using its command line intereface.
#Example execution
#trang.sh -C XMLCatalog/catalog.xml -I rnc -O xsd XMLCatalog/schematron/iso/iso-schematron.rnc XMLCatalog/schematron/iso/iso-schematron.xsd
if [ -z "$*" ]; then
  java \
    -jar "$_trangDir/trang.jar"
else
  java \
    -cp \
"$_XMLCommons/xml-apis.jar":\
"$_XMLCommonsDir/xml-apis-ext.jar":\
"$_xercesDir/serializier.jar":\
"$_xercesDir/xercesImpl.jar":\
"$_resolverDir/resolver.jar":\
"$_XMLCatalogDir":\
"$_trangDir/trang.jar"\
    '-Dorg.xml.sax.driver=org.apache.xml.resolver.tools.ResolvingXMLReader' \
    '-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl' \
    '-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl' \
    '-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration' \
    com.thaiopensource.relaxng.translate.Driver \
    -C XMLCatalog/catalog.xml \
    "$@"
fi
