#!/usr/bin/env sh

#See http://mercury.ccil.org/~cowan/XML/tagsoup/

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_tagsoupDir="$_libDir/tagsoup-1.2.1"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_tagsoupDir" ] || [ ! -s "$_tagsoupDir/tagsoup-1.2.1.jar" ]; then
  echo "Error: Could not find \"$_tagsoupDir/tagsoup-1.2.1.jar\"" > /dev/stderr
  return
fi

#Execute tagsoup using its command line intereface.
#If no parameters passed, then execute with -h so help can be viewed
#Otherwise,execute with parameters passed
if [ -z "$*" ]; then
  java \
    -jar "$_tagsoupDir/tagsoup-1.2.1.jar" \
    --help
else
  java \
    -jar "$_tagsoupDir/tagsoup-1.2.1.jar" \
    "$@"
fi
