#!/usr/bin/env sh

#See https://projects.apache.org/projects/xml_commons_resolver.html

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
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
if [ ! -d "$_resolverDir" ] || [ ! -s "$_resolverDir/resolver.jar" ]; then
  echo "Error: Could not find \"$_resolverDir/resolver.jar\"" > /dev/stderr
  return
fi
if [ ! -d "$_XMLCatalogDir" ] || [ ! -s "$_XMLCatalogDir/catalog.xml" ]; then
  echo "Error: Could not find \"$_XMLCatalogDir/catalog.xml\"" > /dev/stderr
  return
fi
#Execute xml resolver command with classpath and XMLCatalog setup
java \
  -cp "$_resolverDir/resolver.jar":"$_XMLCatalogDir" \
  org.apache.xml.resolver.apps.resolver \
  "$@"

#Example:
#./bin/xmlresolver.sh -p "-//W3C//DTD XHTML 1.1//EN" public
