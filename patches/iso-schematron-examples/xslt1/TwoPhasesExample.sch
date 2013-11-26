<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema
  xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:sch="http://www.ascc.net/xml/schematron"
  queryBinding="xslt"
  schemaVersion="ISO19757-3"
  defaultPhase="#ALL"
  >
  <!--Example based on http://www.dpawson.co.uk/schematron/phases.html#phases.ex1 -->
  <iso:title>Test ISO schematron file. Introduction mode </iso:title>

  <phase id="docs" >
    <active pattern="doc.checks"/>
  </phase>

  <phase id="chaps">
    <active pattern="chap.checks"/>
  </phase>

  <iso:pattern id="doc.checks" >
    <iso:title>checking an XXX document</iso:title>
    <iso:rule context="doc">
      <!--Commenting this out because current-dateTime() is not available in xslt1-->
      <!--<iso:report test="chapter">Report date.<iso:value-of-->
          <!--select="current-dateTime()"/></iso:report>-->
      <iso:report test="title and isbn">Report for book with ISBN <iso:value-of select="isbn"/></iso:report>
    </iso:rule>
  </iso:pattern>

  <iso:pattern   id="chap.checks">
    <iso:title>Basic Chapter checks</iso:title>
    <iso:p>All chapter level checks. </iso:p>
    <iso:rule context="chapter">
      <iso:assert test="title">Chapter should have  a title</iso:assert>
      <iso:assert test="count(para) >= 1">A chapter must have one or more paragraphs</iso:assert>
      <iso:assert test="*[1][self::title]"><iso:name/>  must be have title as first child </iso:assert>
      <iso:assert test="@id">All chapters must have an ID attribute</iso:assert>
    </iso:rule>
  </iso:pattern>
</iso:schema>
