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
            <xsl:variable name="barsoum-en-id">
                <xsl:value-of select="concat($bib-id, '-2')"/>
            </xsl:variable>
            <xsl:variable name="barsoum-ar-id">
                <xsl:value-of select="concat($bib-id, '-3')"/>
            </xsl:variable>
            <xsl:variable name="barsoum-sy-id">
                <xsl:value-of select="concat($bib-id, '-4')"/>
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
                    </teiHeader>
                    <text>
                        <body>
                            <listPerson>
                                    <person xml:id="{$person-id}">
                                        <!-- Standard Syriaca.org names, unsplit -->
                                        <!-- Syriaca.org authorized name forms are designated using @subtype="syriaca-authorized".
                                        (I'm using subtype rather than type because type needs to be used for sic/split.)-->
                                        <!-- Experimenting with for-each. Need to add more attributes, as well as split names. -->
                                        
                                        <!-- Selects any non-empty fields ending with "_Full" (i.e., full names) -->
                                        <xsl:for-each select="*[ends-with(name(),'_Full') and string-length(normalize-space(node()))]">
                                            <persName>
                                                <!-- Applies language attributes specific to fields -->
                                                <xsl:choose>
                                                    <!-- Should English entries be @xml:lang="en" or @xml:lang="syr-Latn" plus a transcription scheme? -->
                                                    <xsl:when test="(contains(name(),'GEDSH')) or (contains(name(),'GS_En'))">
                                                        <xsl:attribute name="xml:lang" select="'syr-Latn-x-gedsh'"/>
                                                    </xsl:when>
                                                    <xsl:when test="contains(name(),'Barsoum_En')">
                                                        <xsl:attribute name="xml:lang" select="'syr-Latn-x-barsoum'"/>
                                                    </xsl:when>
                                                    <xsl:when test="contains(name(),'CBSC_En')">
                                                        <xsl:attribute name="xml:lang" select="'syr-Latn-x-barsoum'"/>
                                                    </xsl:when>
                                                    <xsl:when test="(contains(name(),'Sy_NV')) or (contains(name(),'Authorized_Sy'))">
                                                        <xsl:attribute name="xml:lang" select="'syr'"/>
                                                    </xsl:when>
                                                    <xsl:when test="(contains(name(),'Barsoum_Sy_V')) or (contains(name(),'BO_Sy_V'))">
                                                        <xsl:attribute name="xml:lang" select="'syr-Syrj'"/>
                                                    </xsl:when>
                                                    <xsl:when test="contains(name(),'YdQ_Sy_V')">
                                                        <xsl:attribute name="xml:lang" select="'syr-Syrn'"/>
                                                    </xsl:when>
                                                    <xsl:when test="contains(name(),'_Ar')">
                                                        <xsl:attribute name="xml:lang" select="'ar'"/>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:attribute name="type" select="'sic'"/>
                                                <xsl:if test="(contains(name(),'GEDSH')) or (contains(name(),'GS_En')) or (contains(name(),'Authorized_Sy'))">
                                                    <xsl:attribute name="resp" select="'http://syriaca.org'"/>
                                                </xsl:if>
                                                <xsl:value-of select="node()"/>
                                            </persName>
                                        </xsl:for-each>
                                        
                                       <!-- The <persName> below may be irrelevant if my above experiment with for-each works. -->
                                        <persName type="sic" subtype="syriaca-authorized">
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
                                        
                                        <!-- Standard Syriaca.org names, split -->
                                        <persName type="split" subtype="syriaca-authorized">
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
                                        
                                        <!-- GEDSH names, unsplit -->
                                        <!-- Should split and unsplit versions be given as choice/seg? -->
                                        <xsl:if
                                            test="string-length(normalize-space(GEDSH_Full)) > 0">
                                            <persName xml:lang="syr-Latn-x-gedsh"
                                                    source="#{$gedsh-id}" type="sic">
                                                    <xsl:value-of select="GEDSH_Full"/>
                                            </persName>
                                        </xsl:if>
                                        
                                        <!-- GEDSH names, split -->
                                        <xsl:if
                                            test="string-length(normalize-space(GEDSH_Full)) > 0">
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
                                        </xsl:if>
                                        
                                        <!-- Barsoum names, unsplit -->
                                        <!-- Test whether any Barsoum names exist -->
                                        <xsl:if test="string-length(normalize-space(concat(Barsoum_Sy_NV_Full,Barsoum_En_Full,Barsoum_Ar_Full))) > 0">
                                        <!-- If using <choice> for Barsoum <bibl> citations, may be able to cite parent <bibl> as @source here. -->
                                            <persName type="sic">
                                            <choice>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_Sy_NV_Full)) > 0">
                                                    <seg>
                                                        <persName xml:lang="syr-Syrc" source="#{$barsoum-sy-id}" type="sic">
                                                            <xsl:value-of select="Barsoum_Sy_NV_Full"/>
                                                        </persName>
                                                    </seg>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_Sy_V_Full)) > 0">
                                                    <seg>
                                                        <persName xml:lang="syr-Syrj" source="#{$barsoum-sy-id}" type="sic">
                                                            <xsl:value-of select="Barsoum_Sy_V_Full"/>
                                                        </persName>
                                                    </seg>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_Ar_Full)) > 0">
                                                    <seg>
                                                        <!-- Should language be "ar" or "syr-Arab-x-barsoum"? -->
                                                        <persName xml:lang="ar" source="#{$barsoum-ar-id}" type="sic">
                                                            <xsl:value-of select="Barsoum_Ar_Full"/>
                                                        </persName>
                                                    </seg>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_En_Full)) > 0">
                                                    <seg>
                                                        <!-- Should language be "en" or "syr-Latn-x-barsoum"? -->
                                                        <persName xml:lang="en" source="#{$barsoum-en-id}" type="sic">
                                                            <xsl:value-of select="Barsoum_En_Full"/>
                                                        </persName>
                                                    </seg>
                                                </xsl:if>
                                            </choice>
                                        </persName>
                                            <!-- If using <choice> for Barsoum <bibl> citations, may be able to cite parent <bibl> as @source here. -->
                                            <persName type="split">
                                                <choice>
                                                    <!-- Assumes all Barsoum names are split -->
                                                    <xsl:if
                                                        test="string-length(normalize-space(Barsoum_Sy_NV_Full)) > 0">
                                                        <seg>
                                                            <persName xml:lang="syr-Syrc" source="#{$barsoum-sy-id}" type="split">
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Sy_NV_Given)) > 0">
                                                                    <forename><xsl:value-of select="Barsoum_Sy_NV_Given"/></forename>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Sy_NV_Family)) > 0">
                                                                    <surname><xsl:value-of select="Barsoum_Sy_NV_Family"/></surname>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Sy_NV_Titles)) > 0">
                                                                    <addName type="untagged-title"><xsl:value-of select="Barsoum_Sy_NV_Titles"/></addName>
                                                                </xsl:if>
                                                            </persName>
                                                        </seg>
                                                    </xsl:if>
                                                    <!-- Assumes all Barsoum names are split -->
                                                    <xsl:if
                                                        test="string-length(normalize-space(Barsoum_Sy_V_Full)) > 0">
                                                        <seg>
                                                            <persName xml:lang="syr-Syrj" source="#{$barsoum-sy-id}" type="split">
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Sy_V_Given)) > 0">
                                                                    <forename><xsl:value-of select="Barsoum_Sy_V_Given"/></forename>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Sy_V_Family)) > 0">
                                                                    <surname><xsl:value-of select="Barsoum_Sy_V_Family"/></surname>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Sy_V_Titles)) > 0">
                                                                    <addName type="untagged-title"><xsl:value-of select="Barsoum_Sy_V_Titles"/></addName>
                                                                </xsl:if>
                                                            </persName>
                                                        </seg>
                                                    </xsl:if>
                                                    <!-- Assumes all Barsoum names are split -->
                                                    <xsl:if
                                                        test="string-length(normalize-space(Barsoum_Ar_Full)) > 0">
                                                        <seg>
                                                            <!-- Should language be "ar" or "syr-Arab-x-barsoum"? -->
                                                            <persName xml:lang="ar" source="#{$barsoum-ar-id}" type="split">
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Ar_Given)) > 0">
                                                                    <forename><xsl:value-of select="Barsoum_Ar_Given"/></forename>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Ar_Family)) > 0">
                                                                    <surname><xsl:value-of select="Barsoum_Ar_Family"/></surname>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(Barsoum_Ar_Titles)) > 0">
                                                                    <addName type="untagged-title"><xsl:value-of select="Barsoum_Ar_Titles"/></addName>
                                                                </xsl:if>
                                                            </persName>
                                                        </seg>
                                                    </xsl:if>
                                                    <!-- Assumes all Barsoum names are split -->
                                                    <xsl:if
                                                        test="string-length(normalize-space(Barsoum_En_Full)) > 0">
                                                        <seg>
                                                            <!-- Should language be "en" or "syr-Latn-x-barsoum"? -->
                                                            <persName xml:lang="en" source="#{$barsoum-en-id}" type="split">
                                                                <xsl:if test="string-length(normalize-space(Barsoum_En_Given)) > 0">
                                                                    <forename><xsl:value-of select="Barsoum_En_Given"/></forename>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(Barsoum_En_Family)) > 0">
                                                                    <surname><xsl:value-of select="Barsoum_En_Family"/></surname>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(normalize-space(Barsoum_En_Titles)) > 0">
                                                                    <addName type="untagged-title"><xsl:value-of select="Barsoum_En_Titles"/></addName>
                                                                </xsl:if>
                                                            </persName>
                                                        </seg>
                                                    </xsl:if>
                                                </choice>
                                            </persName>
                                        </xsl:if>
                                        
                                        
                                        <!-- Citation for GEDSH -->
                                        <xsl:if
                                            test="string-length(normalize-space(concat(GEDSH_Start_Pg,GEDSH_Entry_Num,GEDSH_Full))) > 0">
                                            <bibl xml:id="{$gedsh-id}">
                                                <title xml:lang="en">The Gorgias Encyclopedic
                                                  Dictionary of the Syriac Heritage</title>
                                                <abbr>GEDSH</abbr>
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
                                        
                                        <!-- Citations for Barsoum-->
                                        <!-- Does the order matter here? -->
                                        <!-- Should we use <choice> here to put versions in parallel? -->
                                        <xsl:if
                                            test="string-length(normalize-space(Barsoum_En_Full)) > 0">
                                            <bibl xml:id="{$barsoum-en-id}">
                                                <title xml:lang="en">The Scattered Pearls: A History of Syriac Literature and
                                                    Sciences</title>
                                                <abbr>Barsoum (English)</abbr>
                                                <ptr target="http://syriaca.org/bibl/4"/>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_En_Entry_Num)) > 0">
                                                    <citedRange unit="entry">
                                                        <xsl:value-of select="Barsoum_En_Entry_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_En_Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Barsoum_En_Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(Barsoum_Ar_Full)) > 0">
                                            <bibl xml:id="{$barsoum-ar-id}">
                                                <title xml:lang="ar">كتاب اللؤلؤ المنثور في تاريخ العلوم والأداب
                                                    السريانية</title>
                                                <abbr>Barsoum (Arabic)</abbr>
                                                <ptr target="http://syriaca.org/bibl/2"/>
                                                <!-- Are entry nums the same for Arabic as for English? -->
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_En_Entry_Num)) > 0">
                                                    <citedRange unit="entry">
                                                        <xsl:value-of select="Barsoum_En_Entry_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_Ar_Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Barsoum_Ar_Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(Barsoum_Sy_NV_Full)) > 0">
                                            <bibl xml:id="{$barsoum-sy-id}">
                                                <!-- Is this the actual title? -->
                                                <title>The Scattered Pearls: A History of Syriac
                                                    Literature and Sciences</title>
                                                <abbr>Barsoum (Syriac)</abbr>
                                                <ptr target="http://syriaca.org/bibl/3"/>
                                                <!-- Are entry nums the same for Syriac as for English? -->
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_En_Entry_Num)) > 0">
                                                    <citedRange unit="entry">
                                                        <xsl:value-of select="Barsoum_En_Entry_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_Sy_Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Barsoum_Sy_Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        
                                    </person>
                                </listPerson>
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
