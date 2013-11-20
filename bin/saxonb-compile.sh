#!/usr/bin/env sh

#See http://saxon.sourceforge.net

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_saxonbDir="$_libDir/saxonb-9.1.0.8j"
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
if [ ! -d "$_saxonbDir" ] || [ ! -s "$_saxonbDir/saxon9.jar" ]; then
  echo "Error: Could not find \"$_saxonbDir/saxon9.jar\"" > /dev/stderr
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

#Execute saxon compile command with classpath and XMLCatalog setup
#Note saxonHE doesn't have saxon compile command
#Note, the -y and -r parameters for net.sf.saxon.Compile do not use the
#":" separator instead the value is the following arg
java \
  -cp \
"$_saxonbDir/saxon9.jar":\
"$_xercesDir/xercesImpl.jar":\
"$_resolverDir/resolver.jar":\
"$_XMLCatalogDir" \
  '-Dorg.xml.sax.driver=org.apache.xml.resolver.tools.ResolvingXMLReader' \
  '-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl' \
  '-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl' \
  '-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration' \
  net.sf.saxon.Compile \
  -y org.apache.xml.resolver.tools.ResolvingXMLReader \
  -r org.apache.xml.resolver.tools.CatalogResolver \
  "$@"
