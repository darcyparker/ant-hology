#!/usr/bin/env sh

#See http://www.blnz.com/xt/xt-20051206/index.html
#See http://www.blnz.com/xt/xt-20051206/docs/api/index.html

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_xercesDir="$_libDir/apache-xerces-2.11.0"
_resolverDir="$_libDir/apache-commons-xmlresolver-1.2"
_xpDir="$_libDir/xp"
_xtDir="$_libDir/xt"
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
if [ ! -d "$_xtDir" ] || [ ! -s "$_xtDir/xt.jar" ]; then
  echo "Error: Could not find \"$_xtDir/xt.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_xpDir" ] || [ ! -s "$_xpDir/xp.jar" ]; then
  echo "Error: Could not find \"$_xpDir/xp.jar\"" > /dev/stderr
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

#Execute xt XSL transform command
#http://www.blnz.com/xt/xt-20051206/docs/api/index.html
#note xerces and xp are not required in classpath in order to use ResolvingParser
  #'-Dcom.jclark.xsl.sax.parser=org.apache.xml.resolver.tools.ResolvingParser' \
java \
  -cp \
"$_xtDir/xt.jar":\
"$_xpDir/xp.jar":\
"$_XMLCommons/xml-apis.jar":"$_XMLCommonsDir/xml-apis-ext.jar":\
"$_xercesDir/serializier.jar":"$_xercesDir/xercesImpl.jar":\
"$_resolverDir/resolver.jar":\
"$_XMLCatalogDir" \
  '-Dorg.xml.sax.driver=org.apache.xml.resolver.tools.ResolvingXMLReader' \
  '-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl' \
  '-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl' \
  '-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration' \
  com.jclark.xsl.sax.Driver \
  "$@"
