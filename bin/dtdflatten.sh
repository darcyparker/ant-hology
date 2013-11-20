#!/usr/bin/env sh

#http://wiki.fasterxml.com/DtdFlattenHome

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_dtdflattenDir="$_libDir/dtd-flatten-3.2.9"
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
if [ ! -d "$_dtdflattenDir" ] || [ ! -s "$_dtdflattenDir/dtd-flatten-3.2.9.jar" ]; then
  echo "Error: Could not find \"$_dtdflattenDir/dtd-flatten-3.2.9.jar\"" > /dev/stderr
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

#Execute dtdflatten using its command line intereface.
#To do: See if a java system property etc... can be passed to configure
#       org.apache.xml.resolver.tools.CatalogResolver
#       Some DTDs may reference other files by public id... so the catalog resolver
#       may be necessary to find these files
java -jar "$_dtdflattenDir/dtd-flatten-3.2.9.jar" "$@"
