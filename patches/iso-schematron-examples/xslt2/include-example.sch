<?xml version="1.0" encoding="iso-8859-1"?>
<!-- The main Schematron file -->
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:sch="http://www.ascc.net/xml/schematron"
  queryBinding='xslt2'
  schemaVersion="ISO19757-3"
  >
  <!--Example based on http://www.dpawson.co.uk/schematron/abstract.html#abstract.include.ex1 -->
  <iso:title>Test ISO schematron file. Introduction mode </iso:title>

  <iso:pattern id="doc.checks">
    <iso:title>checking an XXX document</iso:title>
    <iso:rule context="doc">
      <iso:report test="chapter">Report date.<iso:value-of select="current-dateTime()"/></iso:report>
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="chapter.checks">
    <iso:title>Basic Chapter checks</iso:title>
    <iso:p>All chapter level checks. </iso:p>

    <iso:include href='input.incl.xml'/>

  </iso:pattern>
</iso:schema>
