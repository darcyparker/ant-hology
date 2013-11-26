<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:sch="http://www.ascc.net/xml/schematron"
  queryBinding='xslt2'
  schemaVersion="ISO19757-3"
  >
  <!--Example based on http://www.dpawson.co.uk/schematron/running.html#ex3.7 -->
  <iso:title>Test ISO schematron file. Introduction mode </iso:title> 1

  <iso:pattern id="doc.checks">
    <iso:title>checking an XXX document</iso:title> 2
    <iso:rule context="doc">
      <iso:report test="chapter">Report date.
        <iso:value-of select="current-dateTime()"/></iso:report>   3
    </iso:rule>
  </iso:pattern>

  <iso:pattern id="chapter.checks">
    <iso:title>Basic Chapter checks</iso:title>            4
    <iso:p>All chapter level checks. </iso:p>              5
    <iso:rule context="chapter">
      <iso:assert test="title">Chapter should have  a title</iso:assert>
      <iso:report test="count(para)"><iso:value-of select="count(para)"/> paragraphs</iso:report>
      <iso:assert test="count(para) >= 1">A chapter must have one or more paragraphs</iso:assert>
      <iso:assert test="*[1][self::title]">Title must be first child of chapter</iso:assert>
      <iso:assert test="@id">All chapters must have an ID attribute</iso:assert>
    </iso:rule>
  </iso:pattern>
</iso:schema>
