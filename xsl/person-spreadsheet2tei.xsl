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
            <!-- Creates variable to use for displaying the name in titles, headers, etc. -->
            <xsl:variable name="display-name-english">
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(GEDSH_Full))">
                        <xsl:value-of select="GEDSH_Full"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(GS_En_Full))">
                        <xsl:value-of select="GS_En_Full"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(Barsoum_En_Full))">
                        <xsl:value-of select="Barsoum_En_Full"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(CBSC_En_Full))">
                        <xsl:value-of select="CBSC_En_Full"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(Other_En_Full))">
                        <xsl:value-of select="Other_En_Full"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <!-- Creates a variable to use as the xml:id for the person element -->
            <xsl:variable name="person-id">person-<xsl:value-of select="SRP_ID"/></xsl:variable>
            <!-- Creates a variable to use as the base for the xml:id for bib elements -->
            <xsl:variable name="bib-id">bib<xsl:value-of select="SRP_ID"/></xsl:variable>
            <!-- Creates variables to use as xml:id for bib elements -->
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
            <!-- Writes the file to the subdirectory "persons-authorities-spreadsheet-output" and give it the name of the record's SRP ID. -->
            <xsl:variable name="filename"
                select="concat('persons-authorities-spreadsheet-output/',SRP_ID,'.xml')"/>
            <xsl:result-document href="{$filename}" format="xml">
                <TEI xmlns="http://www.tei-c.org/ns/1.0">
                    <!-- Need to decide what header should look like. -->
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title xml:lang="en"><xsl:value-of select="$display-name-english"/> | The Syriac Prosopography</title>
                                <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                                <!-- Which funders do we include here? -->
                                <funder>The National Endowment for the Humanities</funder>
                                <funder>The International Balzan Prize Foundation</funder>
                                <principal>David A. Michelson</principal>
                                <!-- Are the following correct? -->
                                <respStmt>
                                    <name ref="http://syriaca.org/editors.xml#jwalters">James E. Walters</name>
                                    <resp>English name entry, matching with viaf.org records</resp>
                                </respStmt>
                                <respStmt>
                                    <name ref="http://syriaca.org/editors.xml#ngibson">Nathan P. Gibson</name>
                                    <resp>creator</resp>
                                </respStmt>
                                <respStmt>
                                    <name ref="http://syriaca.org/editors.xml#tcarlson">Thomas A. Carlson</name>
                                    <resp>editing, Syriac name entry, disambiguation research</resp>
                                </respStmt>
                                <respStmt>
                                    <name ref="http://syriaca.org/editors.xml#raydin">Robert Aydin</name>
                                    <resp>Syriac name entry</resp>
                                </respStmt>
                                <respStmt>
                                    <name ref="http://syriaca.org/editors.xml#jkaado">Jad Kaado</name>
                                    <resp>Arabic name entry</resp>
                                </respStmt>
                                <respStmt>
                                    <name ref="http://syriaca.org/editors.xml#avawter">Alex Vawter</name>
                                    <resp>normalization, matching with viaf.org records</resp>
                                </respStmt>
                                <respStmt>
                                    <name ref="http://syriaca.org/editors.xml#rsingh-bischofberger">Ralf Singh-Bischofberger</name>
                                    <resp>date entry</resp>
                                </respStmt>
                                <!-- Should anybody from VIAF or ISAW be added here? -->
                            </titleStmt>
                            <editionStmt>
                                <edition n="1.0"/>
                            </editionStmt>
                            <publicationStmt>
                                <authority>Syriaca.org: The Syriac Reference Portal</authority>
                                <idno type="URI">http://syriaca.org/person/<xsl:value-of select="$person-id"/>/source</idno>
                                <availability>
                                    <licence
                                        target="http://creativecommons.org/licenses/by/3.0/">
                                        Distributed under a Creative Commons
                                        Attribution 3.0 Unported License
                                    </licence>
                                </availability>
                                <!-- Is this the publication date for the entire data set or this record? Is the date is was converted to XML good enough? -->
                                <date><xsl:value-of select="current-date()"/></date>
                            </publicationStmt>
                            <sourceDesc>
                                <p>Born digital.</p>
                            </sourceDesc>
                        </fileDesc>
                        <encodingDesc>
                            <editorialDecl>
                                <p>Normalization of capitalization in encoded names.</p>
                                <!-- Are there other editorial decisions we need to record here? -->
                            </editorialDecl>
                            <classDecl>
                                <taxonomy>
                                    <category xml:id="syriaca-authorized">
                                        <catDesc>
                                            <!-- Check whether the following is acceptable. -->
                                            The name considered authoritative by Syriaca.org for cataloging purposes
                                            <!-- Do name types "sic" and "split" go here or in ODD file or both?-->
                                        </catDesc>
                                    </category>
                                </taxonomy>
                            </classDecl>
                        </encodingDesc>
                        <profileDesc>
                            <langUsage>
                                <language ident="syr">Unvocalized Syriac of any variety or period</language>
                                <language ident="syr-Syrj">Vocalized West Syriac</language>
                                <language ident="syr-Syrn">Vocalized East Syriac</language>
                                <language ident="en">English</language>
                                <language ident="ar">Arabic</language>
                                <language ident="fr">French</language>
                                <language ident="de">German</language>
                                <language ident="lat">Latin</language>
                            </langUsage>
                        </profileDesc>
                        <revisionDesc>
                            <change who="http://syriaca.org/editors.xml#ngibson"
                                n="1.0">
                                <xsl:attribute name="when" select="current-date()"/>
                                CREATED: person
                            </change>
                            <xsl:if test="string-length(normalize-space(For_Post-Publication_Review))">
                                <change type="planned">
                                    <xsl:value-of select="For_Post-Publication_Review"/>
                                </change>
                            </xsl:if>
                        </revisionDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <listPerson>
                                    <person xml:id="{$person-id}">
                                        <!-- Standard Syriaca.org names, unsplit -->
                                        <!-- Experimenting with for-each. Need to add more attributes. -->
                                        
                                        <!-- Selects any non-empty fields ending with "_Full" (i.e., full names) -->
                                        <xsl:for-each select="*[ends-with(name(),'_Full') and string-length(normalize-space(node()))]">
                                            <persName type="sic">
                                                <!-- Adds xml:id attribute. -->
                                                <xsl:call-template name="perName-id">
                                                    <xsl:with-param name="split-id" select="'-0'"/>
                                                </xsl:call-template>
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
                                                    <xsl:attribute name="syriaca-tags" select="'syriaca-authorized'"/>
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
                                                <!-- Adds xml:id attribute. -->
                                                <xsl:call-template name="perName-id">
                                                    <xsl:with-param name="split-id" select="'-1'"/>
                                                </xsl:call-template>
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
                                                    <xsl:attribute name="syriaca-tags" select="'syriaca-authorized'"/>
                                                </xsl:if>
                                                <!-- Adds name parts -->
                                                <xsl:call-template name="name-parts">
                                                    <xsl:with-param name="group" select="replace(replace(replace(replace(replace(replace(replace(name(), '_Given', ''), '_Family', ''), '_Titles', ''), '_Office', ''), '_Saint_Title', ''), '_Numeric_Title', ''), '_Terms_of_Address', '')"/>
                                                    <xsl:with-param name="same-group" select="1"/>
                                                    <xsl:with-param name="next-element-name" select="name()"/>
                                                    <xsl:with-param name="next-element" select="."/>
                                                    <xsl:with-param name="count" select="0"/>
                                                </xsl:call-template>
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
                                        
                                        
                                        <xsl:if test="string-length(normalize-space(Record_Description))">
                                            <note type="record-description">
                                                <xsl:value-of select="Record_Description"/>
                                            </note>
                                        </xsl:if>
                                       
                                        
                                    </person>
                                
                                <!-- Should disambiguation be done as a relation or a note? -->
                                <xsl:if test="string-length(normalize-space(Disambiguation_URLs))">
                                    <relation 
                                        type="disambiguation" 
                                        name="different-from" 
                                        active="{$person-id} Disambiguation_URLs" 
                                        mutual="{$person-id} Disambiguation_URLs">
                                        <xsl:if test="string-length(normalize-space(Disambiguation))">
                                            <desc>
                                                <xsl:value-of select="Disambiguation"/>
                                            </desc>
                                        </xsl:if>
                                    </relation>
                                </xsl:if>
                                
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
        
    <xsl:template name="language" xmlns="http://www.tei-c.org/ns/1.0">
        <!-- Applies language attributes specific to fields -->
        <xsl:choose>
            <!-- Should English entries be @xml:lang="en" or @xml:lang="syr-Latn" plus a transcription scheme? -->
            <xsl:when test="(contains(name(),'GEDSH')) or (contains(name(),'GS_En'))">
                <xsl:attribute name="xml:lang" select="'syr-Latn-x-gedsh'"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_En')">
                <xsl:attribute name="xml:lang" select="'syr-Latn-x-barsoum'"/>
            </xsl:when>
            <xsl:when test="contains(name(),'CBSC_En_Full')">
                <xsl:attribute name="xml:lang" select="'syr-Latn-x-cbsc'"/>
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
            <xsl:when test="contains(name(),'Barsoum_Ar')">
                <xsl:attribute name="source">#<xsl:value-of select="$barsoum-ar-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Sy')">
                <xsl:attribute name="source">#<xsl:value-of select="$barsoum-sy-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_YdQ')">
                <xsl:attribute name="source">#<xsl:value-of select="$abdisho-ydq-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_BO')">
                <xsl:attribute name="source">#<xsl:value-of select="$abdisho-bo-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'CBSC_En_Full')">
                <xsl:attribute name="source">#<xsl:value-of select="$cbsc-id"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Adds @xml-id and @corresp to persName elements. -->
    <!-- The following @corresp doesn't test for whether the referenced persName fields actually exist. Does it need to? -->
    <xsl:template name="perName-id" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="split-id"/>
        <xsl:variable name="person-name-id">name<xsl:value-of select="../SRP_ID"/>-</xsl:variable>
        <xsl:choose>
            <xsl:when test="contains(name(),'GEDSH')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>1<xsl:value-of select="$split-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_En')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>2<xsl:value-of select="$split-id"/></xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '3', $split-id,' #', $person-name-id, '4a', $split-id,' #', $person-name-id, '4b', $split-id, ' #', $person-name-id, '2', '-', number(not(number(replace($split-id, '-', '')))))"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Ar')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>3<xsl:value-of select="$split-id"/></xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '2', $split-id,' #', $person-name-id, '4a', $split-id,' #', $person-name-id, '4b', $split-id, ' #', $person-name-id, '3', '-', number(not(number(replace($split-id, '-', '')))))"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Sy_NV')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>4a<xsl:value-of select="$split-id"/></xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '2', $split-id,' #', $person-name-id, '3', $split-id,' #', $person-name-id, '4b', $split-id, ' #', $person-name-id, '4a', '-', number(not(number(replace($split-id, '-', '')))))"/>
            </xsl:when>
            <xsl:when test="contains(name(), 'Barsoum_Sy_V')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>4b<xsl:value-of select="$split-id"/></xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '2', $split-id,' #', $person-name-id, '3', $split-id,' #', $person-name-id, '4a', $split-id, ' #', $person-name-id, '4b', '-', number(not(number(replace($split-id, '-', '')))))"/>        
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_YdQ_NV')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>5a<xsl:value-of select="$split-id"/></xsl:attribute>
                <!-- Should Abdisho YdQ and BO be in parallel to each other too (as here and below) since different editions of same name? -->
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '5b', $split-id,' #', $person-name-id, '6a', $split-id,' #', $person-name-id, '5a', '-', number(not(number(replace($split-id, '-', '')))))"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_YdQ_V')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>5b<xsl:value-of select="$split-id"/></xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '5a', $split-id,' #', $person-name-id, '6b', $split-id,' #', $person-name-id, '5b', '-', number(not(number(replace($split-id, '-', '')))))"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_BO_NV')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>6a<xsl:value-of select="$split-id"/></xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '6b', $split-id,' #', $person-name-id, '5a', $split-id,' #', $person-name-id, '6a', '-', number(not(number(replace($split-id, '-', '')))))"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_BO_V')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>6b<xsl:value-of select="$split-id"/></xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '6a', $split-id,' #', $person-name-id, '5b', $split-id,' #', $person-name-id, '6b', '-', number(not(number(replace($split-id, '-', '')))))"/>
            </xsl:when>
            <xsl:when test="contains(name(),'CBSC_En_Full')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>7<xsl:value-of select="$split-id"/></xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="name-parts" xmlns="http://www.tei-c.org/ns/1.0">
        <!-- Field name without the name part on the end (e.g., "GEDSH" is group for "GEDSH_Given"). Used to make sure this template loop doesn't proceed to a different set of fields. -->
        <xsl:param name="group"/>
        <!-- Boolean to test whether the next element is in the same group/fieldset. -->
        <xsl:param name="same-group"/>
        <!-- The name of the next element being processed, which is the element immediately following in the source XML. -->
        <xsl:param name="next-element-name"/>
        <!-- Content of the next element being processed, which is the element immediately following in the source XML. -->
        <xsl:param name="next-element"/>
        <!-- A counter to use for determining the next element to process.  -->
        <xsl:param name="count"/>
        <xsl:if test="(contains(name(),'_Given') or contains(name(),'_Family') or contains(name(),'_Titles') or contains(name(),'_Office') or contains(name(),'_Saint_Title') or contains(name(),'_Numeric_Title') or contains(name(),'_Terms_of_Address')) and $same-group">
            <xsl:if test="string-length(normalize-space($next-element))">
                <xsl:choose>
                    <xsl:when test="ends-with($next-element-name, '_Given')">
                        <forename><xsl:value-of select="$next-element"/></forename>
                    </xsl:when>
                    <xsl:when test="ends-with($next-element-name, '_Family')">
                        <surname><xsl:value-of select="$next-element"/></surname>
                    </xsl:when>
                    <xsl:when test="ends-with($next-element-name, '_Titles')">
                        <addName type="untagged-title"><xsl:value-of select="$next-element"/></addName>
                    </xsl:when>
                    <xsl:when test="ends-with($next-element-name, '_Office')">
                        <addName type="office"><xsl:value-of select="$next-element"/></addName>
                    </xsl:when>
                    <xsl:when test="ends-with($next-element-name, '_Saint_Title')">
                        <addName type="saint-title"><xsl:value-of select="$next-element"/></addName>
                    </xsl:when>
                    <xsl:when test="ends-with($next-element-name, '_Numeric_Title')">
                        <addName type="numeric-title"><xsl:value-of select="$next-element"/></addName>
                    </xsl:when>
                    <xsl:when test="ends-with($next-element-name, '_Terms_of_Address')">
                        <addName type="terms-of-address"><xsl:value-of select="$next-element"/></addName>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            <xsl:call-template name="name-parts">
                <xsl:with-param name="group" select="$group"/>
                <xsl:with-param name="same-group" select="matches(replace(replace(replace(replace(replace(replace(replace(name(following-sibling::*[$count + 1]), '_Given', ''), '_Family', ''), '_Titles', ''), '_Office', ''), '_Saint_Title', ''), '_Numeric_Title', ''), '_Terms_of_Address', ''), $group)"/>
                <xsl:with-param name="next-element-name" select="name(following-sibling::*[$count + 1])"/>
                <xsl:with-param name="next-element" select="following-sibling::*[$count + 1]"/>
                <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
