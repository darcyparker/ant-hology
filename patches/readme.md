# apache-batik-1.7-patch.txt

This patch is patch is necessary so the ant rasterizer task can be build on
windows and unix-like systems.

* Note: This patch is similar to [https://issues.apache.org/bugzilla/attachment.cgi?id=22944](https://issues.apache.org/bugzilla/attachment.cgi?id=22944)
* This patch expands on noted patch by making it work with newer ant versions and
  also updated to work with windows.

```bash
# Patch is created without the <CR> endings> because I don't want/allow <CR> endings
# in my git repo.
diff -rupN --strip-trailing-cr apache-batik-1.7/ apache-batik-1.7-new/ > apache-batik-1.7-patch.txt
```

# apache-batik-1.8-patch.txt

This patch is patch is necessary so the ant rasterizer task can be build on
windows and unix-like systems. (Similar to apache-batik-1.7-patch.txt.)

#Files added to libraries

The following aren't really patches. Instead they are extra files that are being
added to libraries.

##schematron-basic.xsl

This file is normally available from
http://www.ascc.net/xml/schematron/1.5/basic1-5/schematron-basic.xsl however the
URL is sometimes broken, so this backup is used.

##schematron-message.xsl

This file is normally available from
http://www.ascc.net/xml/schematron/1.5/message1-5/schematron-message.xsl however the
URL is sometimes broken, so this backup is used.

##iso_schematron_terminator_xsl\*.xsl

Implementation of Schematron validation that terminates with the first error
detected.

##iso_schematron_text_xslt\*.xsl
Implementation of Schematron validation that reports in text only, optionally
with paths in a prefix form.

##Combining Schematron with other XML Schema languages.html

This is useful documentation that is no longer online.

##iso-schematron-examples directory

Examples iso-schematron schemas for query bindings xslt1 and xslt2.
