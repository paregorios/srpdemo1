<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:output method="xml" indent="yes" name="xml"/>
    <xsl:output method="html" indent="yes" name="html"/>
    
    <xsl:template match="/root">
        
        <!-- Create a TEI file for each row. -->
        <xsl:for-each select="row">
            <!-- Write the file to the subdirectory "persons-authorities-spreadsheet-output" and give it the name of the record's SRP ID. -->
            <xsl:variable name="filename" select="concat('persons-authorities-spreadsheet-output/',SRP_ID,'.xml')"/>
            <xsl:result-document href="{$filename}" format="xml">
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>