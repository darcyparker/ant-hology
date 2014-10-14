#!/usr/bin/env sh

#See https://code.google.com/p/jing-calabash
#See http://www.thaiopensource.com/relaxng/calabash.html

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_calabashDir="$_libDir/calabash-1.0.13-95"
_saxonheDir="$_libDir/saxonHE-9.5.1.2"
_xalanDir="$_libDir/apache-xalan-2.7.2"
_xercesDir="$_libDir/apache-xerces-2.11.0"
_resolverDir="$_libDir/apache-commons-xmlresolver-1.2"
_XMLCatalogDir=$( cd "$_thisDir/../../XMLCatalog" ; pwd )
_commonsCodecDir="$_libDir/apache-commons-codec-1.9"
_commonsLoggingDir="$_libDir/apache-commons-logging-1.1.3"
_commonsCLIDir="$_libDir/apache-commons-cli-1.2"
_commonsHttpComponentsDir="$_libDir/apache-commons-httpcomponents-4.3.3"
_commonsIODir="$_libDir/apache-commons-io-2.4"
_XMLGraphicsDir="$_libDir/apache-commons-xmlgraphics-1.5/build"
_XMLCommonsDir="$_libDir/apache-commons-xml-external-1.4.01"
_AvalonFrameworkDir="$_libDir/apache-avalon-framework-4.2.0/jars"
_tagsoupDir="$_libDir/tagsoup-1.2.1"
_jingDir="$_libDir/jing-20091111/bin"
_xmlUnitDir="$_libDir/xmlunit-1.5/lib"
_metadataExtractorDir="$_libDir/metadata-extractor-2.6.4"
_htmlparserDir="$_libDir/htmlparser-1.4"
_icu4jDir="$_libDir/icu4j-51.2"
_jchardetDir="$_libDir/jchardet-1.1/dist/lib"
_XOMDir="$_libDir/xom-1.2.10"
_batikDir="$_libDir/apache-batik-1.7"
_rhinoDir="$_libDir/rhino-1.7R4"
_bsf24Dir="$_libDir/apache-commons-bsf-2.4.0/lib"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_calabashDir" ] || [ ! -s "$_calabashDir/calabash.jar" ]; then
  echo "Error: Could not find \"$_calabashDir/calabash.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_saxonheDir" ] || [ ! -s "$_saxonheDir/saxon9he.jar" ]; then
  echo "Error: Could not find \"$_saxonheDir/saxon9he.jar\"" > /dev/stderr
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
if [ ! -d "$_commonsCodecDir" ] || [ ! -s "$_commonsCodecDir/commons-codec-1.9.jar" ]; then
  echo "Error: Could not find \"$_commonsCodecDir/commons-codec-1.9.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_commonsLoggingDir" ] || [ ! -s "$_commonsLoggingDir/commons-logging-1.1.3.jar" ]; then
  echo "Error: Could not find \"$_commonsLoggingDir/commons-logging-1.1.3.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_commonsCLIDir" ] || [ ! -s "$_commonsCLIDir/commons-cli-1.2.jar" ]; then
  echo "Error: Could not find \"$_commonsCLIDir/commons-cli-1.2.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_commonsHttpComponentsDir" ] || [ ! -s "$_commonsHttpComponentsDir/lib/httpcore-4.3.2.jar" ]; then
  echo "Error: Could not find \"$_commonsHttpComponentsDir/lib/httpcore-4.3.2.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_commonsHttpComponentsDir" ] || [ ! -s "$_commonsHttpComponentsDir/lib/httpclient-4.3.3.jar" ]; then
  echo "Error: Could not find \"$_commonsHttpComponentsDir/lib/httpclient-4.3.3.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_commonsHttpComponentsDir" ] || [ ! -s "$_commonsHttpComponentsDir/lib/httpmime-4.3.3.jar" ]; then
  echo "Error: Could not find \"$_commonsHttpComponentsDir/lib/httpmime-4.3.3.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_commonsHttpComponentsDir" ] || [ ! -s "$_commonsHttpComponentsDir/lib/fluent-hc-4.3.3.jar" ]; then
  echo "Error: Could not find \"$_commonsHttpComponentsDir/lib/fluent-hc-4.3.3.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_commonsIODir" ] || [ ! -s "$_commonsIODir/commons-io-2.4.jar" ]; then
  echo "Error: Could not find \"$_commonsIODir/commons-io-2.4.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_XMLGraphicsDir" ] || [ ! -s "$_XMLGraphicsDir/xmlgraphics-commons-1.5.jar" ]; then
  echo "Error: Could not find \"$_XMLGraphicsDir/xmlgraphics-commons-1.5.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_AvalonFrameworkDir" ] || [ ! -s "$_AvalonFrameworkDir/avalon-framework-4.2.0.jar" ]; then
  echo "Error: Could not find \"$_AvalonFrameworkDir/avalon-framework-4.2.0.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_AvalonFrameworkDir" ] || [ ! -s "$_AvalonFrameworkDir/avalon-framework-api-4.2.0.jar" ]; then
  echo "Error: Could not find \"$_AvalonFrameworkDir/avalon-framework-api-4.2.0.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_AvalonFrameworkDir" ] || [ ! -s "$_AvalonFrameworkDir/avalon-framework-impl-4.2.0.jar" ]; then
  echo "Error: Could not find \"$_AvalonFrameworkDir/avalon-framework-impl-4.2.0.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_tagsoupDir" ] || [ ! -s "$_tagsoupDir/tagsoup-1.2.1.jar" ]; then
  echo "Error: Could not find \"$_tagsoupDir/tagsoup-1.2.1.jar\"" > /dev/stderr
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
if [ ! -d "$_xmlUnitDir" ] || [ ! -s "$_xmlUnitDir/xmlunit-1.5.jar" ]; then
  echo "Error: Could not find \"$_xmlUnitDir/xmlunit-1.5.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_metadataExtractorDir" ] || [ ! -s "$_metadataExtractorDir/metadata-extractor-2.6.4.jar" ]; then
  echo "Error: Could not find \"$_metadataExtractorDir/metadata-extractor-2.6.4.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_metadataExtractorDir" ] || [ ! -s "$_metadataExtractorDir/xmpcore.jar" ]; then
  echo "Error: Could not find \"$_metadataExtractorDir/xmpcore.jar\"" > /dev/stderr
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
if [ ! -d "$_rhinoDir" ] || [ ! -s "$_rhinoDir/js.jar" ]; then
  echo "Error: Could not find \"$_rhinoDir/js.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_bsf24Dir" ] || [ ! -s "$_bsf24Dir/bsf.jar" ]; then
  echo "Error: Could not find \"$_bsf24Dir/bsf.jar\"" > /dev/stderr
  return
fi

#Execute calabash using its command line intereface.
java \
  -cp \
"$_calabashDir/calabash.jar":\
"$_commonsCodecDir/commons-codec-1.9.jar":\
"$_commonsLoggingDir/commons-logging-1.1.3.jar":\
"$_commonsCLIDir/commons-cli-1.2.jar":\
"$_commonsIODir/commons-io-2.4.jar":\
"$_commonsHttpComponentsDir/lib/httpclient-4.3.3.jar":\
"$_commonsHttpComponentsDir/lib/httpcore-4.3.3.jar":\
"$_commonsHttpComponentsDir/lib/httpmime-4.3.3.jar":\
"$_commonsHttpComponentsDir/lib/fluent-hc-4.3.3.jar":\
"$_XMLCommons/xml-apis.jar":"$_XMLCommonsDir/xml-apis-ext.jar":\
"$_xercesDir/serializier.jar":"$_xercesDir/xercesImpl.jar":\
"$_resolverDir/resolver.jar":"$_XMLCatalogDir":\
"$_saxonheDir/saxon9he.jar":\
"$_tagsoupDir/tagsoup-1.2.1.jar":\
"$_XMLGraphicsDir/xmlgraphics-commons-1.5.jar":\
"$_jingDir/jing.jar":\
"$_jingDir/isorelax.jar":\
"$_xmlUnitDir/xmlunit-1.5.jar":\
"$_metadataExtractorDir/metadata-extractor-2.6.4.jar":\
"$_metadataExtractorDir/xmpcore.jar":\
"$_htmlparserDir/htmlparser-1.4.jar":\
"$_icu4jDir/icu4j-51_2.jar":\
"$_icu4jDir/icu4j-charset-51_2.jar":\
"$_icu4jDir/icu4j-localespi-51_2.jar":\
"$_jchardetDir/chardet.jar":\
"$_XOMDir/xom-1.2.10.jar":\
"$_rhinoDir/js.jar":\
"$_bsf24Dir/bsf.jar":\
  '-Dorg.xml.sax.driver=org.apache.xml.resolver.tools.ResolvingXMLReader' \
  '-Djavax.xml.parsers.DocumentBuilderFactory=org.apache.xerces.jaxp.DocumentBuilderFactoryImpl' \
  '-Djavax.xml.parsers.SAXParserFactory=org.apache.xerces.jaxp.SAXParserFactoryImpl' \
  '-Dorg.apache.xerces.xni.parser.XMLParserConfiguration=org.apache.xerces.parsers.XIncludeParserConfiguration' \
  com.xmlcalabash.drivers.Main \
  "$@"
