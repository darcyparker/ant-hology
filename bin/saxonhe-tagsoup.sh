#!/usr/bin/env sh

#See http://saxon.sourceforge.net
#See http://mercury.ccil.org/~cowan/XML/tagsoup/

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_saxonheDir="$_libDir/saxonHE-9.5.1.2"
_xercesDir="$_libDir/apache-xerces-2.11.0"
_tagsoupDir="$_libDir/tagsoup-1.2.1"
_XMLCommonsDir="$_libDir/apache-commons-xml-external-1.4.01"
_resolverDir="$_libDir/apache-commons-xmlresolver-1.2"
_XMLCatalogDir=$( cd "$_thisDir/../../XMLCatalog" ; pwd )

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_saxonheDir" ] || [ ! -s "$_saxonheDir/saxon9he.jar" ]; then
  echo "Error: Could not find \"$_saxonheDir/saxon9he.jar\"" > /dev/stderr
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
if [ ! -d "$_tagsoupDir" ] || [ ! -s "$_tagsoupDir/tagsoup-1.2.1.jar" ]; then
  echo "Error: Could not find \"$_tagsoupDir/tagsoup-1.2.1.jar\"" > /dev/stderr
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

#Execute saxon command configured to use tagsoup html sax parser
#See http://mercury.ccil.org/~cowan/XML/tagsoup/
java \
  -cp \
"$_saxonheDir/saxon9he.jar":\
"$_XMLCommons/xml-apis.jar":"$_XMLCommonsDir/xml-apis-ext.jar":\
"$_xercesDir/xercesImpl.jar":\
"$_resolverDir/resolver.jar":\
"$_tagsoupDir/tagsoup-1.2.1.jar"\
  '-Dorg.xml.sax.driver=org.apache.xml.resolver.tools.ResolvingXMLReader' \
  '-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl' \
  '-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl' \
  '-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration' \
  net.sf.saxon.Transform \
  -versionmsg:off \
  -l:on \
  -x:org.ccil.cowan.tagsoup.Parser \
  -y:org.apache.xml.resolver.tools.ResolvingXMLReader \
  -r:org.apache.xml.resolver.tools.CatalogResolver \
  "$@"
