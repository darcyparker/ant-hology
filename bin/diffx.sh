#!/usr/bin/env sh

#See http://weborganic.org/diffx.html
#See https://code.google.com/p/wo-diffx/
#See http://pageseeder.org/apidocs/diffx/latest/index.html
#See https://code.google.com/p/wo-diffx/w/list

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_diffxDir="$_libDir/diffx-0.7.4"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_diffxDir" ] || [ ! -s "$_diffxDir/diffx-0.7.4.jar" ]; then
  echo "Error: Could not find \"$_diffxDir/diffx-0.7.4.jar\"" > /dev/stderr
  return
fi

#Execute diffX using its command line intereface.
#Using guano algorithm because default fisty has bugs with some xml files.. divide by zero
#Note bug and workaround mentioned here:
#https://code.google.com/p/wo-diffx/issues/detail?id=3
#Algorithms include: fitsy* | guano | fitopsy | kumar | wesyma
if [ -z "$*" ]; then
java -jar "$_diffxDir/diffx-0.7.4.jar" "$@"
else
java -jar "$_diffxDir/diffx-0.7.4.jar" -A guano "$@"
fi
