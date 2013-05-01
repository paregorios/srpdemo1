<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text"/>
    <xsl:output method="xml" indent="yes" name="xml"/>
    <xsl:output method="html" indent="yes" name="html"/>

    <xsl:template match="/root">

        <!-- Create a TEI file for each row. -->
        <xsl:for-each select="row">
            <!-- Create a variable to use as the xml:id for the person element -->
            <xsl:variable name="person-id">person-<xsl:value-of select="SRP_ID"/></xsl:variable>
            <!-- Create a variable to use as the base for the xml:id for bib elements -->
            <xsl:variable name="bib-id">bib<xsl:value-of select="SRP_ID"/></xsl:variable>
            <!-- Create variables to use as xml:id for bib elements -->
            <xsl:variable name="gedsh-id">
                <xsl:value-of select="concat($bib-id, '-1')"/>
            </xsl:variable>
            <!-- Write the file to the subdirectory "persons-authorities-spreadsheet-output" and give it the name of the record's SRP ID. -->
            <xsl:variable name="filename"
                select="concat('persons-authorities-spreadsheet-output/',SRP_ID,'.xml')"/>
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
                                        <!-- Should we use @resp to indicate syriaca.org standard names? EAC could then use @resp="syriaca.org" and @type="sic" to pull unsplit authorized Syriaca.org names in parallel.-->
                                        <persName resp="syriaca.org" type="sic">
                                            <choice>
                                                <xsl:if
                                                  test="string-length(normalize-space(Authorized_Sy_Full)) > 0">
                                                  <!-- Should we use syr-Syrc for unvocalized Syriac, or simply syr? -->
                                                  <!-- Should we put in SRP as @source or @resp? -->
                                                  <seg>
                                                  <persName xml:lang="syr-Syrc" type="sic">
                                                  <xsl:value-of select="Authorized_Sy_Full"/>
                                                  </persName>
                                                  </seg>
                                                </xsl:if>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="string-length(normalize-space(GEDSH_Full)) > 0">
                                                  <seg>
                                                  <persName xml:lang="syr-Latn-x-gedsh"
                                                  source="#{$gedsh-id}" type="sic">
                                                  <xsl:value-of select="GEDSH_Full"/>
                                                  </persName>
                                                  </seg>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="string-length(normalize-space(GS_En_Full)) > 0">
                                                  <seg>
                                                  <persName xml:lang="syr-Latn-x-gedsh" type="sic">
                                                  <xsl:value-of select="GS_En_Full"/>
                                                  </persName>
                                                  </seg>
                                                  </xsl:when>
                                                  <xsl:otherwise/>
                                                </xsl:choose>
                                            </choice>
                                        </persName>
                                        <persName resp="syriaca.org" type="split">
                                            <choice>
                                                <xsl:if
                                                    test="string-length(normalize-space(Authorized_Sy_Full)) > 0">
                                                    <!-- Should we use syr-Syrc for unvocalized Syriac, or simply syr? -->
                                                    <!-- Should we put in SRP as @source or @resp? -->
                                                    <seg>
                                                        <persName xml:lang="syr-Syrc" type="split">
                                                            <xsl:if test="string-length(normalize-space(Authorized_Sy_Given)) > 0">
                                                            <forename><xsl:value-of select="Authorized_Sy_Given"/></forename>
                                                            </xsl:if>
                                                            <xsl:if test="string-length(normalize-space(Authorized_Sy_Family)) > 0">
                                                                <surname><xsl:value-of select="Authorized_Sy_Family"/></surname>
                                                            </xsl:if>
                                                            <!-- Need to discuss order and types of following titles. -->
                                                            <xsl:if test="string-length(normalize-space(Authorized_Sy_Office)) > 0">
                                                                <addName type="office"><xsl:value-of select="Authorized_Sy_Office"/></addName>
                                                            </xsl:if>
                                                            <xsl:if test="string-length(normalize-space(Authorized_Sy_Saint_Title)) > 0">
                                                                <addName type="saint"><xsl:value-of select="Authorized_Sy_Saint_Title"/></addName>
                                                            </xsl:if>
                                                            <xsl:if test="string-length(normalize-space(Authorized_Sy_Numeric_Title)) > 0">
                                                                <genName type="numeric"><xsl:value-of select="Authorized_Sy_Numeric_Title"/></genName>
                                                            </xsl:if>
                                                            <xsl:if test="string-length(normalize-space(Authorized_Sy_Terms_of_Address)) > 0">
                                                                <addName type="terms-of-address"><xsl:value-of select="Authorized_Sy_Terms_of_Address"/></addName>
                                                            </xsl:if>
                                                        </persName>
                                                    </seg>
                                                </xsl:if>
                                                <xsl:choose>
                                                    <!-- Assumes all GEDSH names are split. -->
                                                    <xsl:when
                                                        test="string-length(normalize-space(GEDSH_Full)) > 0">
                                                        <seg>
                                                            <persName xml:lang="syr-Latn-x-gedsh"
                                                                source="#{$gedsh-id}" type="split">
                                                                <xsl:if test="string-length(normalize-space(GEDSH_Given)) > 0">
                                                                    <forename><xsl:value-of select="GEDSH_Given"/></forename>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(GEDSH_Family)) > 0">
                                                                    <surname><xsl:value-of select="GEDSH_Family"/></surname>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(GEDSH_Titles)) > 0">
                                                                    <addName type="untagged-title"><xsl:value-of select="GEDSH_Titles"/></addName>
                                                                </xsl:if>
                                                            </persName>
                                                        </seg>
                                                    </xsl:when>
                                                    <!-- Assumes all GEDSH-style names are split. -->
                                                    <xsl:when
                                                        test="string-length(normalize-space(GS_En_Full)) > 0">
                                                        <seg>
                                                            <persName xml:lang="syr-Latn-x-gedsh" type="split">
                                                                <xsl:if test="string-length(normalize-space(GS_En_Given)) > 0">
                                                                    <forename><xsl:value-of select="GS_En_Given"/></forename>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(GS_En_Family)) > 0">
                                                                    <surname><xsl:value-of select="GS_En_Family"/></surname>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(GS_En_Titles)) > 0">
                                                                    <addName type="untagged-title"><xsl:value-of select="GS_En_Titles"/></addName>
                                                                </xsl:if>
                                                            </persName>
                                                        </seg>
                                                    </xsl:when>
                                                    <xsl:otherwise/>
                                                </xsl:choose>
                                            </choice>
                                        </persName>
                                        <xsl:if
                                            test="string-length(normalize-space(concat(GEDSH_Start_Pg,GEDSH_Entry_Num,GEDSH_Full))) > 0">
                                            <bibl xml:id="{$gedsh-id}">
                                                <title xml:lang="en">The Gorgias Encyclopedic
                                                  Dictionary of the Syriac Heritage</title>
                                                <ptr target="http://syriaca.org/bibl/1"/>
                                                <xsl:if
                                                  test="string-length(normalize-space(GEDSH_Entry_Num)) > 0">
                                                  <citedRange unit="entry">
                                                  <xsl:value-of select="GEDSH_Entry_Num"/>
                                                  </citedRange>
                                                </xsl:if>
                                                <xsl:if
                                                  test="string-length(normalize-space(GEDSH_Start_Pg)) > 0">
                                                  <citedRange unit="pp">
                                                  <xsl:value-of select="GEDSH_Start_Pg"/>
                                                  </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
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
