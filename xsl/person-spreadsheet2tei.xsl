<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:saxon="http://saxon.sf.net/">
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
            <xsl:variable name="abdisho-ydq-id">
                <xsl:value-of select="concat($bib-id, '-5')"/>
            </xsl:variable>
            <xsl:variable name="abdisho-bo-id">
                <xsl:value-of select="concat($bib-id, '-6')"/>
            </xsl:variable>
            <xsl:variable name="cbsc-id">
                <xsl:value-of select="concat($bib-id, '-7')"/>
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
                                            <persName type="sic">
                                                <!-- Adds language attributes. -->
                                                <xsl:call-template name="language"/>
                                                <!-- Adds source attributes. -->
                                                <xsl:call-template name="source">
                                                    <xsl:with-param name="gedsh-id" select="$gedsh-id"/>
                                                    <xsl:with-param name="barsoum-en-id" select="$barsoum-en-id"/>
                                                    <xsl:with-param name="barsoum-sy-id" select="$barsoum-sy-id"/>
                                                    <xsl:with-param name="barsoum-ar-id" select="$barsoum-ar-id"/>
                                                    <xsl:with-param name="cbsc-id" select="$cbsc-id"/>
                                                    <xsl:with-param name="abdisho-ydq-id" select="$abdisho-ydq-id"/>
                                                    <xsl:with-param name="abdisho-bo-id" select="$abdisho-bo-id"/>
                                                </xsl:call-template>
                                                <!-- Shows which name forms are authorized. -->
                                                <xsl:if test="(contains(name(),'GEDSH')) or (contains(name(),'GS_En')) or (contains(name(),'Authorized_Sy'))">
                                                    <xsl:attribute name="resp" select="'http://syriaca.org'"/>
                                                </xsl:if>
                                                <xsl:value-of select="node()"/>
                                            </persName>
                                        </xsl:for-each>
                                        
                                        <!-- Adds split persName elements. -->
                                        <!-- Groups together split name fields by the first part of the field name (e.g., "GEDSH"). -->
                                        <xsl:for-each-group
                                            select="*[(contains(name(),'_Given') or contains(name(),'_Family') or contains(name(),'_Titles') or contains(name(),'_Office') or contains(name(),'_Saint_Title') or contains(name(),'_Numeric_Title') or contains(name(),'_Terms_of_Address')) and string-length(normalize-space(node()))]"
                                            group-by="replace(replace(replace(replace(replace(replace(replace(name(), '_Given', ''), '_Family', ''), '_Titles', ''), '_Office', ''), '_Saint_Title', ''), '_Numeric_Title', ''), '_Terms_of_Address', '')">
                                            <persName type="split">
                                                <!-- Adds language attributes. -->
                                                <xsl:call-template name="language"/>
                                                <!-- Adds source attributes. -->
                                                <xsl:call-template name="source">
                                                    <xsl:with-param name="gedsh-id" select="$gedsh-id"/>
                                                    <xsl:with-param name="barsoum-en-id" select="$barsoum-en-id"/>
                                                    <xsl:with-param name="barsoum-sy-id" select="$barsoum-sy-id"/>
                                                    <xsl:with-param name="barsoum-ar-id" select="$barsoum-ar-id"/>
                                                    <xsl:with-param name="cbsc-id" select="$cbsc-id"/>
                                                    <xsl:with-param name="abdisho-ydq-id" select="$abdisho-ydq-id"/>
                                                    <xsl:with-param name="abdisho-bo-id" select="$abdisho-bo-id"/>
                                                </xsl:call-template>
                                                <!-- Shows which name forms are authorized. -->
                                                <xsl:if test="(contains(name(),'GEDSH')) or (contains(name(),'GS_En')) or (contains(name(),'Authorized_Sy'))">
                                                    <xsl:attribute name="resp" select="'http://syriaca.org'"/>
                                                </xsl:if>
                                                <!-- Assumes name parts are in the order Given, Family, Title or the order Given, Family, Office, Saint Title, Numeric Title, Terms of Address. -->
                                                <xsl:if test="ends-with(name(), '_Given')">
                                                    <forename><xsl:value-of select="."/></forename>
                                                </xsl:if>
                                                <xsl:choose>
                                                    <xsl:when test="ends-with(name(), '_Family')">
                                                        <surname><xsl:value-of select="."/></surname>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(normalize-space(following-sibling::*[1])) and ends-with(name(following-sibling::*[1]), '_Family')">
                                                        <surname><xsl:value-of select="following-sibling::*[ends-with(name(), '_Family')][1]"/></surname>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <!-- The following does not work. Revise! -->
                                                <xsl:choose>
                                                    <xsl:when test="ends-with(name(), '_Titles')">
                                                        <addName type="untagged-title"><xsl:value-of select="."/></addName>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(normalize-space(following-sibling::*[1])) and ends-with(name(following-sibling::*[1]), '_Titles')">
                                                        <addName type="untagged-title"><xsl:value-of select="following-sibling::*[ends-with(name(), '_Titles')][1]"/></addName>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:choose>
                                                    <xsl:when test="ends-with(name(), '_Office')">
                                                        <addName type="office"><xsl:value-of select="."/></addName>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(normalize-space(following-sibling::*[1])) and ends-with(name(following-sibling::*[1]), '_Office')">
                                                        <addName type="office"><xsl:value-of select="following-sibling::*[ends-with(name(), '_Office')][1]"/></addName>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:choose>
                                                    <xsl:when test="ends-with(name(), '_Saint_Title')">
                                                        <addName type="saint-title"><xsl:value-of select="."/></addName>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(normalize-space(following-sibling::*[1])) and ends-with(name(following-sibling::*[1]), '_Saint_Title')">
                                                        <addName type="saint-title"><xsl:value-of select="following-sibling::*[ends-with(name(), '_Saint_Title')][1]"/></addName>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:choose>
                                                    <xsl:when test="ends-with(name(), '_Numeric_Title')">
                                                        <addName type="numeric-title"><xsl:value-of select="."/></addName>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(normalize-space(following-sibling::*[1])) and ends-with(name(following-sibling::*[1]), '_Numeric_Title')">
                                                        <addName type="numeric-title"><xsl:value-of select="following-sibling::*[ends-with(name(), '_Numeric_Title')][1]"/></addName>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:choose>
                                                    <xsl:when test="ends-with(name(), '_Terms_of_Address')">
                                                        <addName type="terms-of-address"><xsl:value-of select="."/></addName>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(normalize-space(following-sibling::*[1])) and ends-with(name(following-sibling::*[1]), '_Terms_of_Address')">
                                                        <addName type="terms-of-address"><xsl:value-of select="following-sibling::*[ends-with(name(), '_Terms_of_Address')][1]"/></addName>
                                                    </xsl:when>
                                                </xsl:choose>
                                                
                                            </persName>
                                        </xsl:for-each-group>
                                      
                                        
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
                                        
                                        <!-- Add Abdisho citations -->
                                        
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
        
    <xsl:template match="*" name="language">
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
    </xsl:template>
    
    <xsl:template name="source" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="gedsh-id"/>
        <xsl:param name="barsoum-en-id"/>
        <xsl:param name="barsoum-sy-id"/>
        <xsl:param name="barsoum-ar-id"/>
        <xsl:param name="cbsc-id"/>
        <xsl:param name="abdisho-ydq-id"/>
        <xsl:param name="abdisho-bo-id"/>
        <xsl:choose>
            <xsl:when test="contains(name(),'GEDSH')">
                <xsl:attribute name="source">#<xsl:value-of select="$gedsh-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_En')">
                <xsl:attribute name="source">#<xsl:value-of select="$barsoum-en-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Sy')">
                <xsl:attribute name="source">#<xsl:value-of select="$barsoum-sy-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Ar')">
                <xsl:attribute name="source">#<xsl:value-of select="$barsoum-ar-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'CBSC_En')">
                <xsl:attribute name="source">#<xsl:value-of select="$cbsc-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_YdQ')">
                <xsl:attribute name="source">#<xsl:value-of select="$abdisho-ydq-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_BO')">
                <xsl:attribute name="source">#<xsl:value-of select="$abdisho-bo-id"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
