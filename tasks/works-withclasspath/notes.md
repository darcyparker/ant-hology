#Notes:

1. Ant's xslt task ignores the classpath it is told to use. This can be worked
around by expliciting passing libs in command line for ant to add to classpath.
  * Libraries to pass include `apache-commons-xmlresolver` and `xmlcatalog`
  * For more information see:
      * http://ant.apache.org/faq.html#delegating-classloader-1.5
      * http://ant.apache.org/faq.html#delegating-classloader-1.6
2. As well, some versions of ant do not work correctly. I find I have to use ant
   1.9.2 which is installed in `${ant-hology.lib.dir}` (With the default
   configuration, you can access a symbolic link to ant binary here:
   `ant-hology/bin/ant`) 

Examples:

```bash
#In the examples below, `test-xslt-oraxsl`, `test-xslt-saxonb`,
#`test-xslt-xalan` and `test-xslt-xt` are targets that use the macrodefs
#`xslt-oraxsl`, `xslt-saxonb`, `xslt-xalan`, and `xslt-xt` respectively
../ant-hology/bin/ant -lib ../ant-hology/lib/apache-commons-xmlresolver-1.2/resolver.jar -lib ../XMLCatalog/ test-xslt-oraxsl
../ant-hology/bin/ant -lib ../ant-hology/lib/apache-commons-xmlresolver-1.2/resolver.jar -lib ../XMLCatalog/ test-xslt-saxonb
../ant-hology/bin/ant -lib ../ant-hology/lib/apache-commons-xmlresolver-1.2/resolver.jar -lib ../XMLCatalog/ test-xslt-xalan
../ant-hology/bin/ant -lib ../ant-hology/lib/apache-commons-xmlresolver-1.2/resolver.jar -lib ../XMLCatalog/ test-xslt-xt
```

