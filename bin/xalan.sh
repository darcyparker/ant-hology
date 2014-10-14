#!/usr/bin/env sh

#See http://xalan.apache.org/xalan-j/index.html

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_xalanDir="$_libDir/apache-xalan-2.7.2"
_xercesDir="$_libDir/apache-xerces-2.11.0"
_resolverDir="$_libDir/apache-commons-xmlresolver-1.2"
_XMLCatalogDir=$( cd "$_thisDir/../../XMLCatalog" ; pwd )
_rhinoDir="$_libDir/rhino-1.7R4"
_bsf24Dir="$_libDir/apache-commons-bsf-2.4.0/lib"
_commonsLoggingDir="$_libDir/apache-commons-logging-1.1.3"
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
if [ ! -d "$_xalanDir" ] || [ ! -s "$_xalanDir/xalan.jar" ]; then
  echo "Error: Could not find \"$_xalanDir/xalan.jar\"" > /dev/stderr
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
if [ ! -d "$_rhinoDir" ] || [ ! -s "$_rhinoDir/js.jar" ]; then
  echo "Error: Could not find \"$_rhinoDir/js.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_bsf24Dir" ] || [ ! -s "$_bsf24Dir/bsf.jar" ]; then
  echo "Error: Could not find \"$_bsf24Dir/bsf.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_commonsLoggingDir" ] || [ ! -s "$_commonsLoggingDir/commons-logging-1.1.3.jar" ]; then
  echo "Error: Could not find \"$_commonsLoggingDir/commons-logging-1.1.3.jar\"" > /dev/stderr
  return
fi

#Execute xalan command with classpath and XMLCatalog setup
#If no parameters passed, then execute without parameters so help can be seen.
#Otherwise, set boilerplate options before passed options
if [ -z "$*" ]; then
  java \
    -cp "$_xalanDir/xalan.jar":\
"$_XMLCommons/xml-apis.jar":"$_XMLCommonsDir/xml-apis-ext.jar":\
"$_xercesDir/serializier.jar":"$_xercesDir/xercesImpl.jar":\
"$_resolverDir/resolver.jar":\
"$_XMLCatalogDir":\
"$_rhinoDir/js.jar":\
"$_bsf24Dir/bsf.jar":\
"$_commonsLoggingDir/commons-logging-1.1.3.jar"\
    org.apache.xalan.xslt.Process
else
  java \
    -cp "$_xalanDir/xalan.jar":\
"$_XMLCommons/xml-apis.jar":"$_XMLCommonsDir/xml-apis-ext.jar":\
"$_xercesDir/serializier.jar":"$_xercesDir/xercesImpl.jar":\
"$_resolverDir/resolver.jar":\
"$_XMLCatalogDir":\
"$_rhinoDir/js.jar":\
"$_bsf24Dir/bsf.jar":\
"$_commonsLoggingDir/commons-logging-1.1.3.jar"\
    '-Dorg.xml.sax.driver=org.apache.xml.resolver.tools.ResolvingXMLReader' \
    '-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl' \
    '-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl' \
    '-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration' \
    org.apache.xalan.xslt.Process \
    -L \
    -ENTITYRESOLVER org.apache.xml.resolver.tools.CatalogResolver \
    -URIRESOLVER org.apache.xml.resolver.tools.CatalogResolver \
    "$@"
fi
