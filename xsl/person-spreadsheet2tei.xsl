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
            <!-- Create a variable to use as the xml:id for the person element -->
            <xsl:variable name="person-id">person-<xsl:value-of select="SRP_ID"
            /></xsl:variable>
            <!-- Create a variable to use as the base for the xml:id for bib elements -->
            <xsl:variable name="bib-id">bib<xsl:value-of select="SRP_ID"
            /></xsl:variable>
            <!-- Create variables to use as xml:id for bib elements -->
            <xsl:variable name="gedsh-id"><xsl:value-of select="concat($bib-id, '-1')"/></xsl:variable>
            <!-- Write the file to the subdirectory "persons-authorities-spreadsheet-output" and give it the name of the record's SRP ID. -->
            <xsl:variable name="filename" select="concat('persons-authorities-spreadsheet-output/',SRP_ID,'.xml')"/>
            <xsl:result-document href="{$filename}" format="xml">
                <TEI xmlns="http://www.tei-c.org/ns/1.0">
                    <!-- Need to decide what header should look like. -->
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>Title</title>
                            </titleStmt>
                            <publicationStmt>
                                <p>Publication Information</p>
                            </publicationStmt>
                            <sourceDesc>
                                <p>Information about the source</p>
                            </sourceDesc>
                        </fileDesc>
                        <profileDesc>
                            <particDesc>
                                <!-- Did we decide to put persons in header or body? -->
                                <listPerson>
                                    <person xml:id="{$person-id}">
                                        <xsl:if test="string-length(normalize-space(Authorized_Sy_Full)) > 0">
                                            <!-- Should we use syr-Syrc for unvocalized Syriac, or simply syr? -->
                                            <persName xml:lang="syr-Syrc" source="#{$gedsh-id}" type="sic">
                                                <xsl:value-of select="Authorized_Sy_Full"/>
                                            </persName>
                                        </xsl:if>
                                        <bibl xml:id="{$gedsh-id}">
                                            <title xml:lang="en">The Gorgias Encyclopedic Dictionary of the Syriac
                                                Heritage</title>
                                            <ptr target="http://syriaca.org/bibl/1"/>
                                            <citedRange unit="entry"><xsl:value-of select="GEDSH_Entry_Num"/></citedRange>
                                            <citedRange unit="pp"><xsl:value-of select="GEDSH_Start_Pg"/></citedRange>
                                        </bibl>
                                    </person>
                                </listPerson>
                            </particDesc>
                        </profileDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <p>Some text here.</p>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
        
        <!-- Create an index file that links to all of the EAC files.
        Index does not work for rows lacking a Calculated_Name.-->
        <xsl:result-document href="persons-authorities-spreadsheet-output/index.html" format="html">
            <html>
                <head>
                    <title>Index</title>
                </head>
                <body>
                    <xsl:for-each select="row">
                        <a href="{SRP_ID}.xml">
                            <xsl:value-of select="Calculated_Name"/>
                        </a>
                        <br/>
                    </xsl:for-each>
                </body>
            </html>
            
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>