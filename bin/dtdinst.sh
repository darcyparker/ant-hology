#!/usr/bin/env sh

#See http://www.thaiopensource.com/dtdinst/
#See https://code.google.com/p/jing-trang/

#Internal variables
_thisDir=`dirname "$0"`
_libDir=$( cd "$_thisDir/../lib"; pwd )
_dtdinstDir="$_libDir/dtdinst-20091111"

#Check setup
if [ ! `which java 2> /dev/null` ]; then
  echo "Error: Could not find java" > /dev/stderr
  return
fi
if [ ! -d "$_libDir" ]; then
  echo "Error: Could not find \"$_libDir\"" > /dev/stderr
  return
fi
if [ ! -d "$_dtdinstDir" ] || [ ! -s "$_dtdinstDir/dtdinst.jar" ]; then
  echo "Error: Could not find \"$_dtdinstDir/dtdinst.jar\"" > /dev/stderr
  return
fi

#Execute dtdinst using its command line intereface.
if [ -z "$*" ]; then
  echo "Usage with this script: dtdinst.sh [-i] [-r dir] DTD"
  echo "DTD argument can be a file or URL"
  echo
  echo "If the -r option is not specified, DTDinst writes an XML representation of the DTD in DTDinst format to the standard output. For example, the command"
  echo "  java -jar dtdinst.jar http://www.w3.org/XML/1998/06/xmlspec-v21.dtd >xmlspec.xml"
  echo "would write an XML representation of the W3C xmlspec DTD to the file xmlspec.xml."
  echo
  echo "With the -r option, DTDinst writes one or more files containing a RELAX NG schema to the directory dir. For example, the commanda"
  echo "  java -jar dtdinst.jar -r relax http://www.xml.gr.jp/relax/relaxCore.dtd"
  echo "would write a RELAX NG schema for RELAX Core to the directory relax. The directory would contain a relaxCore.rng file corresponding to relaxCore.dtd, and would also contain a datatypes.rng file corresponding to datatypes.dtd, which is referenced by relaxCore.dtd."
  echo
  echo "The -i option tells DTDinst to inline ATTLIST declarations. Without this option, DTDinst will generate a define in the RELAX NG schema for each ATTLIST declaration in the DTD. With this option, DTDinst will move the patterns generated from ATTLIST declarations into the corresponding element pattern."
  echo
else
  java \
    -cp \
"$_dtdinstDir/dtdinst.jar":\
    com.thaiopensource.dtd.app.Driver \
    "$@"
fi
