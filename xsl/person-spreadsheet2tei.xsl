<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 21, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b>Nathan Gibson</xd:p>
            <xd:p>Transforms XML data imported from the Google Spreadsheet "Author Names from Barsoum..." into Syriaca.org TEI.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="text"/>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>Defines an XML format for the transformed data.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="xml" indent="yes" name="xml"/>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>Defines an HTML format for the transformed data.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:output method="html" indent="yes" name="html"/>

    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>This template generates the overall structure of each TEI document and calls other templates at the relevant points. It creates 2 kinds of files:
            <xd:ul>
                <xd:li>Individual TEI files for each row of the source XML, named by SRP ID.</xd:li>
                <xd:li>An HTML index file displaying the names of all records as links to their TEI XML files</xd:li>
            </xd:ul>
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="main" match="/root">
        <!-- Creates a TEI document for each row (person record). -->
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
            <!-- Should this be bibl- instead of bib? (If changed, need to change in places records too.) -->
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
            <!-- Determines which name part should be used first in alphabetical lists by consulting the order in GEDSH. -->
            <xsl:variable name="sort">
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(GEDSH_Full)) and string-length(normalize-space(concat(GEDSH_Given, GEDSH_Family, GEDSH_Titles)))">
                        <xsl:choose>
                            <xsl:when test="starts-with(GEDSH_Full, GEDSH_Given)">forename</xsl:when>
                            <xsl:when test="starts-with(GEDSH_Full, GEDSH_Family)">surname</xsl:when>
                            <xsl:when test="starts-with(GEDSH_Full, GEDSH_Titles)">title</xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
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
                                <idno type="URI">http://syriaca.org/person/<xsl:value-of select="SRP_ID"/>/source</idno>
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
                                <!-- Should this be inside a normalization tag? -->
                                <!-- Need to add how we've done dates, such as "early 8th cent.", etc. -->
                                <p>Names marked with the type "split" do not include the commas that originally separated the parts of the name. For example, "de Halleux, André" has been split into the parts "de Halleux" and "André" leaving out the comma.</p>
                                <p>The capitalization of names marked with the type "split" has been normalized.</p>
                                <!-- Are there other editorial decisions we need to record here? -->
                            </editorialDecl>
                            <classDecl>
                                <taxonomy>
                                    <category xml:id="syriaca-authorized">
                                        <!-- Check whether the following is acceptable. -->
                                        <!-- Do name types "sic" and "split" go here or in ODD file or both?-->
                                        <catDesc>The name considered authoritative by Syriaca.org for cataloging purposes</catDesc>
                                    </category>
                                </taxonomy>
                            </classDecl>
                        </encodingDesc>
                        <profileDesc>
                            <!-- Need to add transliteration codes if we'll be using syr-Latn-x-gedsh etc. -->
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
                                <!-- Is there any additional way we should mark anonymous writers, other than in the format of the name? -->
                                    <person xml:id="{$person-id}">
                                        <!-- Selects any non-empty fields ending with "_Full" (i.e., full names) -->
                                        <xsl:for-each select="*[ends-with(name(),'_Full') and string-length(normalize-space(node()))]">
                                            <persName type="sic">
                                                <!-- Adds xml:id attribute. -->
                                                <xsl:call-template name="perName-id"/>                                                
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
                                                <!-- This will need to be changed if capitalization needs to be altered in GEDSH forms. -->
                                                <xsl:if test="(contains(name(),'GEDSH')) or (contains(name(),'GS_En')) or (contains(name(),'Authorized_Sy'))">
                                                    <xsl:attribute name="syriaca-tags" select="'#syriaca-headword'"/>
                                                </xsl:if>
                                                <!--A variable to hold the first part of the column name, which must be the same for all name columns from that source. 
                                                E.g., "Barsoum_En" for the columns "Barsoum_En_Full", "Barsoum_En_Given", etc.-->
                                                <xsl:variable name="group" select="replace(name(), '_Full', '')"/>
                                                <!-- Adds name parts -->
                                                <xsl:call-template name="name-parts">
                                                    <xsl:with-param name="name" select="."/>
                                                    <xsl:with-param name="count" select="1"/>
                                                    <xsl:with-param name="all-name-parts" select="following-sibling::*[contains(name(), $group)]"/>
                                                </xsl:call-template>
                                            </persName>
                                        </xsl:for-each>
                                        
                                        
                                        
                                        <!-- Adds VIAF URLs. -->
                                        <xsl:for-each select="URL[string-length(normalize-space()) > 0]">
                                            <idno type="URI">
                                                <xsl:value-of select="."/>
                                            </idno>
                                        </xsl:for-each>
                                      
                                      <!-- Adds date elements -->
                                        <xsl:for-each 
                                            select="*[ends-with(name(),'Floruit') and string-length(normalize-space(node()))]">
                                            <floruit>
                                                <xsl:call-template name="event-or-date">
                                                    <xsl:with-param name="gedsh-id" select="$gedsh-id"/>
                                                    <xsl:with-param name="barsoum-en-id" select="$barsoum-en-id"/>
                                                    <xsl:with-param name="barsoum-sy-id" select="$barsoum-sy-id"/>
                                                    <xsl:with-param name="barsoum-ar-id" select="$barsoum-ar-id"/>
                                                    <xsl:with-param name="cbsc-id" select="$cbsc-id"/>
                                                    <xsl:with-param name="abdisho-ydq-id" select="$abdisho-ydq-id"/>
                                                    <xsl:with-param name="abdisho-bo-id" select="$abdisho-bo-id"/>
                                                </xsl:call-template>
                                            </floruit>
                                        </xsl:for-each>
                                        <xsl:for-each 
                                            select="*[ends-with(name(),'DOB') and string-length(normalize-space(node()))]">
                                            <birth>
                                                <xsl:call-template name="event-or-date">
                                                    <xsl:with-param name="gedsh-id" select="$gedsh-id"/>
                                                    <xsl:with-param name="barsoum-en-id" select="$barsoum-en-id"/>
                                                    <xsl:with-param name="barsoum-sy-id" select="$barsoum-sy-id"/>
                                                    <xsl:with-param name="barsoum-ar-id" select="$barsoum-ar-id"/>
                                                    <xsl:with-param name="cbsc-id" select="$cbsc-id"/>
                                                    <xsl:with-param name="abdisho-ydq-id" select="$abdisho-ydq-id"/>
                                                    <xsl:with-param name="abdisho-bo-id" select="$abdisho-bo-id"/>
                                                </xsl:call-template>
                                            </birth>
                                        </xsl:for-each>
                                        <xsl:for-each 
                                            select="*[ends-with(name(),'DOD') and string-length(normalize-space(node()))]">
                                            <death>
                                                <xsl:call-template name="event-or-date">
                                                    <xsl:with-param name="gedsh-id" select="$gedsh-id"/>
                                                    <xsl:with-param name="barsoum-en-id" select="$barsoum-en-id"/>
                                                    <xsl:with-param name="barsoum-sy-id" select="$barsoum-sy-id"/>
                                                    <xsl:with-param name="barsoum-ar-id" select="$barsoum-ar-id"/>
                                                    <xsl:with-param name="cbsc-id" select="$cbsc-id"/>
                                                    <xsl:with-param name="abdisho-ydq-id" select="$abdisho-ydq-id"/>
                                                    <xsl:with-param name="abdisho-bo-id" select="$abdisho-bo-id"/>
                                                </xsl:call-template>
                                            </death>
                                        </xsl:for-each>
                                        <xsl:if test="string-length(normalize-space(GEDSH_Reign_Begin)) or string-length(normalize-space(GEDSH_Reign_End)) or string-length(normalize-space(Barsoum_En_Other_Date))">
                                            <listEvent>
                                                <!-- Will we always have both begin and end value for reigns? If not, how do we handle the following so that it creates only one event element for each Begin and End sequence? -->
                                                <xsl:for-each 
                                                    select="*[(ends-with(name(),'_Begin') or ends-with(name(),'_Other_Date')) and string-length(normalize-space(node()))]">
                                                    <event>
                                                        <xsl:call-template name="event-or-date">
                                                            <xsl:with-param name="gedsh-id" select="$gedsh-id"/>
                                                            <xsl:with-param name="barsoum-en-id" select="$barsoum-en-id"/>
                                                            <xsl:with-param name="barsoum-sy-id" select="$barsoum-sy-id"/>
                                                            <xsl:with-param name="barsoum-ar-id" select="$barsoum-ar-id"/>
                                                            <xsl:with-param name="cbsc-id" select="$cbsc-id"/>
                                                            <xsl:with-param name="abdisho-ydq-id" select="$abdisho-ydq-id"/>
                                                            <xsl:with-param name="abdisho-bo-id" select="$abdisho-bo-id"/>
                                                        </xsl:call-template>
                                                    </event>
                                                </xsl:for-each>
                                            </listEvent>
                                        </xsl:if>
                                        
                                        <!-- Bibl elements -->
                                        <!-- Should languages be declared for English titles or only non-English? -->
                                        <!-- Citation for GEDSH -->
                                        <xsl:if
                                            test="string-length(normalize-space(concat(GEDSH_Start_Pg,GEDSH_Entry_Num,GEDSH_Full))) > 0">
                                            <bibl xml:id="{$gedsh-id}">
                                                <title>The Gorgias Encyclopedic Dictionary of the Syriac Heritage</title>
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
                                        <xsl:if
                                            test="string-length(normalize-space(Barsoum_En_Full)) > 0">
                                            <bibl xml:id="{$barsoum-en-id}">
                                                <title xml:lang="en">The Scattered Pearls: A History of Syriac Literature and Sciences</title>
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
                                                <title>The Scattered Pearls: A History of Syriac Literature and Sciences</title>
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
                                        
                                        <!-- Need Abdisho titles -->
                                        <xsl:if
                                            test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Full)) > 0">
                                            <bibl xml:id="{$abdisho-ydq-id}">
                                                <title>Abdisho (YdQ)</title>
                                                <abbr>Abdisho (YdQ)</abbr>
                                                <ptr target="http://syriaca.org/bibl/6"/>
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_YdQ_Sy_Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Abdisho_YdQ_Sy_Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        <xsl:if
                                            test="(string-length(normalize-space(Abdisho_BO_Sy_NV_Full)) > 0) or (string-length(normalize-space(Abdisho_BO_Sy_V_Full)) > 0)">
                                            <bibl xml:id="{$abdisho-bo-id}">
                                                <title>Abdisho (BO)</title>
                                                <abbr>Abdisho (BO)</abbr>
                                                <ptr target="http://syriaca.org/bibl/7"/>
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_BO_Sy_Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Abdisho_BO_Sy_Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(CBSC_En_Full)) > 0">
                                            <!-- Should we include the link to CBSC as an additional @target on the pointer?-->
                                            <!-- Should CBSC link go directly to the tag on the CBSC system? 
                                            If so, we'll need to have some way to discern whether it is a  subject heading or an author heading in CBSC.
                                            And should that go under citedRange?-->
                                            <bibl xml:id="{$cbsc-id}">
                                                <title>A Comprehensive Bibliography on Syriac Christianity</title>
                                                <abbr>CBSC</abbr>
                                                <ptr target="http://syriaca.org/bibl/5 http://www.csc.org.il/db/db.aspx?db=SB"/>
                                            </bibl>
                                        </xsl:if>
                                        
                                        
                                        <!-- Adds Record Description field as a note. -->
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
                                        mutual="#{$person-id} {Disambiguation_URLs}">
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
        
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>This template applies @xml:lang attributes to an element, based on the text strings in their field names.</xd:p>
        </xd:desc>
    </xd:doc>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="language" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:choose>
            <!-- Should English entries be @xml:lang="en" or @xml:lang="syr-Latn" plus a transcription scheme? -->
            <xsl:when test="(contains(name(),'GEDSH')) or (contains(name(),'GS_En'))">
                <xsl:attribute name="xml:lang" select="'syr-Latn-x-gedsh'"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_En')">
                <xsl:attribute name="xml:lang" select="'syr-Latn-x-barsoum'"/>
            </xsl:when>
            <xsl:when test="contains(name(),'CBSC_En')">
                <xsl:attribute name="xml:lang" select="'syr-Latn-x-cbsc'"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Other_En')">
                <xsl:attribute name="xml:lang" select="'en'"/>
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
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>This template applies the @source attribute to an element, based on text strings contained in the element's name.</xd:p>
            <xd:p>The @source links to a bibl element using an xml:id.</xd:p>
        </xd:desc>
        <xd:param name="gedsh-id">The xml:id for the GEDSH bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="barsoum-en-id">The xml:id for the Barsoum English bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="barsoum-sy-id">The xml:id for the Barsoum Syriac bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="barsoum-ar-id">The xml:id for the Barsoum Arabic bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="cbsc-id">The xml:id for the CBSC bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="abdisho-ydq-id">The xml:id for the Abidsho YdQ bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="abdisho-bo-id">The xml:id for the Abdisho BO bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
    </xd:doc>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p></xd:p>
        </xd:desc>
        <xd:param name="gedsh-id"></xd:param>
        <xd:param name="barsoum-en-id"></xd:param>
        <xd:param name="barsoum-sy-id"></xd:param>
        <xd:param name="barsoum-ar-id"></xd:param>
        <xd:param name="cbsc-id"></xd:param>
        <xd:param name="abdisho-ydq-id"></xd:param>
        <xd:param name="abdisho-bo-id"></xd:param>
    </xd:doc>
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
            <xsl:when test="contains(name(),'Barsoum_Ar')">
                <xsl:attribute name="source">#<xsl:value-of select="$barsoum-ar-id"/></xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Sy')">
                <xsl:attribute name="source">#<xsl:value-of select="$barsoum-sy-id"/></xsl:attribute>
            </xsl:when>
            <!-- Since Barsoum_Ar and Barsoum_Sy are matched above, anything else with Barsoum is assumed to be from the English version,
            whether or not marked specifically "EN" (e.g., dates).-->
            <xsl:when test="contains(name(),'Barsoum')">
                <xsl:attribute name="source">#<xsl:value-of select="$barsoum-en-id"/></xsl:attribute>
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
    
    <!-- The following @corresp doesn't test for whether the referenced persName fields actually exist. Does it need to? -->
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>This template does the following:
                <xd:ul>
                    <xd:li>Creates xml:id attributes for persName elements, generating the ID's by stringing together the SRP ID, a number corresponding to the source, an "a" or "b" for unvocalized/vocalized, and a 0 or 1 for split/unsplit.</xd:li>
                    <xd:li>Links the persName to other language/vocalization versions of the name using @corresp.</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
        <xd:param name="split-id">Designates whether the persName is a split ("-1") or unsplit ("-0") version of the name.</xd:param>
    </xd:doc>
    <!-- Will we use @corresp or linkGrp to show parallel names? -->
    <xsl:template name="perName-id" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:variable name="person-name-id">name<xsl:value-of select="../SRP_ID"/>-</xsl:variable>
        <xsl:choose>
            <xsl:when test="contains(name(),'GEDSH')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>1</xsl:attribute>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_En')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>2</xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '3', ' #', $person-name-id, '4a', ' #', $person-name-id, '4b')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Ar')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>3</xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '2', ' #', $person-name-id, '4a', ' #', $person-name-id, '4b')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Sy_NV')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>4a</xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '2', ' #', $person-name-id, '3', ' #', $person-name-id, '4b')"/>
            </xsl:when>
            <xsl:when test="contains(name(), 'Barsoum_Sy_V')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>4b</xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '2', ' #', $person-name-id, '3', ' #', $person-name-id, '4a')"/>        
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_YdQ_Sy_NV')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>5a</xsl:attribute>
                <!-- Should Abdisho YdQ and BO be in parallel to each other too (as here and below) since different editions of same name? -->
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '5b', ' #', $person-name-id, '6a')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_YdQ_Sy_V')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>5b</xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '5a', ' #', $person-name-id, '6b')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_BO_Sy_NV')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>6a</xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '6b', ' #', $person-name-id, '5a')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_BO_Sy_V')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>6b</xsl:attribute>
                <xsl:attribute name="corresp" select="concat('#', $person-name-id, '6a', ' #', $person-name-id, '5b')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'CBSC_En_Full')">
                <xsl:attribute name="xml:id"><xsl:value-of select="$person-name-id"/>7</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>Cycles through the fields containing the individual parts of a name, creating and populating the appropriate TEI name fields.
            Name fields using this template should end in one of the following:
                <xd:ul>
                    <xd:li>_Given</xd:li>
                    <xd:li>_Family</xd:li>
                    <xd:li>_Titles</xd:li>
                    <xd:li>_Office</xd:li>
                    <xd:li>_Saint_Title</xd:li>
                    <xd:li>_Numeric_Title</xd:li>
                    <xd:li>_Terms_of_Address</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
        <xd:param name="group">Field name without the name part on the end (e.g., "GEDSH" is group for "GEDSH_Given"). Used to make sure this template loop doesn't proceed to a different set of fields.</xd:param>
        <xd:param name="same-group">Boolean to test whether the next element is in the same group/fieldset.</xd:param>
        <xd:param name="next-element-name">The name of the next element being processed, which is the element immediately following in the source XML.</xd:param>
        <xd:param name="next-element">Content of the next element being processed, which is the element immediately following in the source XML.</xd:param>
        <xd:param name="count">A counter to use for determining the next element to process.</xd:param>
        <xd:param name="sort">Contains the name of the TEI name part element that should be used first in alphabetical lists.</xd:param>
    </xd:doc>
    <!-- What to do about comma-separated titles? -->
    <xsl:template name="name-parts" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="name"/>
        <xsl:param name="count"/>
        <xsl:param name="all-name-parts"/>
        <xsl:param name="next-column" select="$all-name-parts[$count]"/>
        <xsl:param name="next-column-name" select="name($next-column)"/>
        <xsl:choose>
            <xsl:when test="$all-name-parts">
                <xsl:choose>
                    <xsl:when test="$next-column-name">
                        <xsl:variable name="name-element-name">
                            <xsl:choose>
                                <xsl:when test="contains($next-column-name,'_Given')">forename</xsl:when>
                                <xsl:when test="contains($next-column-name,'_Family')">surname</xsl:when>
                                <xsl:when test="contains($next-column-name,'_Titles') or contains($next-column-name,'_Saint_Title') or contains($next-column-name,'_Terms_of_Address')">addName</xsl:when>
                                <xsl:when test="contains($next-column-name,'_Office')">roleName</xsl:when>
                                <xsl:when test="contains($next-column-name,'_Numeric_Title')">genName</xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <!-- Might be able to machine-generate title types based on content (e.g., "bishop," "III", etc.) -->
                        <xsl:variable name="name-element-type">
                            <xsl:choose>
                                <xsl:when test="contains($next-column-name,'_Titles')">untagged-title</xsl:when>
                                <xsl:when test="contains($next-column-name,'_Saint_Title')">saint-title</xsl:when>
                                <xsl:when test="contains($next-column-name,'_Terms_of_Address')">terms-of-address</xsl:when>
                                <xsl:when test="contains($next-column-name,'_Office')">office</xsl:when>
                                <xsl:when test="contains($next-column-name,'_Numeric_Title')">numeric-title</xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="string-length($name-element-name) and string-length(normalize-space($next-column))">
                                <xsl:analyze-string select="$name" regex="{$next-column}" flags="i">
                                    <xsl:matching-substring>
                                        <xsl:element name="{$name-element-name}">
                                            <xsl:if test="string-length($name-element-type)">
                                                <xsl:attribute name="type" select="$name-element-type"/>
                                            </xsl:if>
                                            <xsl:copy-of select="."/>
                                        </xsl:element>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:call-template name="name-parts">
                                            <xsl:with-param name="name" select="."/>
                                            <xsl:with-param name="count" select="$count + 1"/>
                                            <xsl:with-param name="all-name-parts" select="$all-name-parts"/>
                                        </xsl:call-template>
                                    </xsl:non-matching-substring>
                                    <xsl:fallback></xsl:fallback>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="name-parts">
                                    <xsl:with-param name="name" select="$name"/>
                                    <xsl:with-param name="count" select="$count + 1"/>
                                    <xsl:with-param name="all-name-parts" select="$all-name-parts"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$name"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template name="name-part-element" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="name"/>
        <xsl:param name="next-column"/>
        <xsl:param name="name-element-name"/>
        <xsl:param name="name-element-type"/>
        <xsl:param name="delim" select="',\s+'"/>
        <xsl:choose>
            <xsl:when test="contains($next-column, $delim)">
                <xsl:variable name="substring" select="substring-before($next-column, $delim)"/>
                <xsl:variable name="before" select="substring-before($name, $substring)"/>
                <xsl:variable name="after" select="substring-after($name, $substring)"/>
                <xsl:variable name="name-part-string"
                    select="substring($name, string-length($before) + 1, string-length($name) - string-length($before) - string-length($after))"/>
                <xsl:call-template name="name-part-element">
                    <xsl:with-param name="name">
                        <xsl:value-of select="$before"/><forename>
                            <xsl:choose>
                                <xsl:when test="(string-length($before) = 0) and (string-length($after) > 0)">
                                    <xsl:attribute name="sort" select="1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="sort" select="2"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="string-length($name-element-type)">
                                <xsl:attribute name="type" select="$name-element-type"/>
                            </xsl:if>
                            <xsl:value-of select="$name-part-string"/>
                        </forename><xsl:value-of select="$after"/>
                    </xsl:with-param>
                    <xsl:with-param name="next-column" select="substring-after($next-column, $delim)"/>
                    <xsl:with-param name="name-element-name" select="$name-element-name"/>
                    <!--For now -->
                    <xsl:with-param name="name-element-type" select="$name-element-type"/>
                    <xsl:with-param name="delim" select="$delim"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="substring" select="$next-column"/>
                <xsl:variable name="before" select="substring-before($name, $substring)"/>
                <xsl:variable name="after" select="substring-after($name, $substring)"/>
                <xsl:variable name="name-element" as="xs:string"><xsl:element name="{$name-element-name}"><xsl:value-of select="$next-column"/></xsl:element></xsl:variable>
                <xsl:if test="string-length($name) and string-length($next-column)">
                    <xsl:copy-of select="replace($name, $next-column, $name-element)"/>
                </xsl:if>
                    <!--<xsl:copy-of select="substring-before($full-name, $next-column)"/><xsl:element name="{$name-element-name}">
                    <xsl:choose>
                        <xsl:when test="(string-length(substring-before($full-name, $next-column)) = 0) and (string-length(substring-after($full-name, $next-column)) > 0)">
                            <xsl:attribute name="sort" select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="sort" select="2"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="string-length($name-element-type)">
                        <xsl:attribute name="type" select="$name-element-type"/>
                    </xsl:if>
                    <xsl:copy-of select="substring($full-name, string-length(substring-before($full-name, $next-column)) + 1, string-length($full-name) - string-length(substring-before($full-name, $next-column)) - string-length(substring-after($full-name, $next-column)))"/>
                </xsl:element><xsl:copy-of select="substring-after($full-name, $next-column)"/>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--Deprecate this?-->
    <xd:doc>
        <xd:desc>
            <xd:p>Determines which name part should be given precedence in alphabetic lists, using GEDSH, if present.</xd:p>
        </xd:desc>
        <xd:param name="sort">Shows which name part should be given precedence in alphabetic lists. Contains "forename", "surname", "title", or empty string.</xd:param>
        <xd:param name="name-part">Passes in the current name part being processed from the <xd:ref name="name-parts" type="template">name-parts template</xd:ref>.</xd:param>
    </xd:doc>
    <xsl:template name="name-parts-sort">
        <xsl:param name="sort"/>
        <xsl:param name="name-part"/>
        <xsl:if test="string-length(normalize-space($sort))">
            <xsl:attribute name="sort">
                <xsl:choose>
                    <xsl:when test="matches($sort, $name-part)">0</xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>This template processes elements that contain date information, including the following:<xd:ul>
                <xd:li>floruit</xd:li>
                <xd:li>birth</xd:li>
                <xd:li>death</xd:li>
                <xd:li>event</xd:li>
            </xd:ul>
                The template other templates to add date and source attributes, then determines whether and how to add a human-readable value to the element, and which (if any) custom type attribute to use. 
            </xd:p>
        </xd:desc>
        <xd:param name="gedsh-id">The xml:id for the GEDSH bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="barsoum-en-id">The xml:id for the Barsoum English bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="barsoum-sy-id">The xml:id for the Barsoum Syriac bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="barsoum-ar-id">The xml:id for the Barsoum Arabic bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="cbsc-id">The xml:id for the CBSC bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="abdisho-ydq-id">The xml:id for the Abidsho YdQ bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
        <xd:param name="abdisho-bo-id">The xml:id for the Abdisho BO bibl element, passed in from the variable in the <xd:ref name="main" type="template">main template</xd:ref>.</xd:param>
    </xd:doc>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p></xd:p>
        </xd:desc>
        <xd:param name="gedsh-id"></xd:param>
        <xd:param name="barsoum-en-id"></xd:param>
        <xd:param name="barsoum-sy-id"></xd:param>
        <xd:param name="barsoum-ar-id"></xd:param>
        <xd:param name="cbsc-id"></xd:param>
        <xd:param name="abdisho-ydq-id"></xd:param>
        <xd:param name="abdisho-bo-id"></xd:param>
    </xd:doc>
    <xsl:template name="event-or-date" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="gedsh-id"/>
        <xsl:param name="barsoum-en-id"/>
        <xsl:param name="barsoum-sy-id"/>
        <xsl:param name="barsoum-ar-id"/>
        <xsl:param name="cbsc-id"/>
        <xsl:param name="abdisho-ydq-id"/>
        <xsl:param name="abdisho-bo-id"/>
        
        <!-- Adds machine-readable attributes to date. -->
        <xsl:call-template name="date-attributes">
            <xsl:with-param name="date-type" select="replace(replace(name(), '_Begin', ''), '_End', '')"/>
            <xsl:with-param name="next-element-name" select="name()"/>
            <xsl:with-param name="next-element" select="node()"/>
            <xsl:with-param name="count" select="0"/>
        </xsl:call-template>

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
        
        <!-- Adds custom type and, if relevant, human-readable date as content of element-->
        <xsl:choose>
            <xsl:when test="contains(name(), 'Reign')">
                <!-- Is "incumbency" or "term-of-office" better for this? -->
                <xsl:attribute name="type" select="'reign'"/>
                <xsl:value-of select="."/>-<xsl:value-of select="following-sibling::*[ends-with(name(), '_End')]"/>
            </xsl:when>
            <xsl:when test="contains(name(), '_Other_Date')">
                <!-- What about using this type? -->
                <xsl:attribute name="type" select="'untagged'"/>
                <desc>An event for which no description has been logged.</desc>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>This template adds machine-readable date attributes to an element, based on text strings contained in the source XML element's name.
            <xd:ul>
                <xd:li>_Begin_Standard --> @from</xd:li>
                <xd:li>_End_Standard --> @to</xd:li>
                <xd:li>_Standard --> @when</xd:li>
                <xd:li>_Not_Before --> @notBefore</xd:li>
                <xd:li>_Not_After --> @notAfter</xd:li>
            </xd:ul>
            </xd:p>
        </xd:desc>
        <xd:param name="date-type">Uses the name of the human-readable field, except in fields that have "_Begin" and "_End",
            which it replaces so that @from and @to attributes can be added to the same element. Fields should be named in such a way that machine-readable fields contain the name of the field that has human-readable date data. If the template is called and the <xd:ref name="next-element-name" type="parameter">next element name</xd:ref> does not contain this date-type, the template will be exited.</xd:param>
        <xd:param name="next-element-name">The name of the next element to be processed. This is used in combination with the <xd:ref name="count" type="parameter">count param</xd:ref> to cycle through the set of fields used to create an element with dates.</xd:param>
        <xd:param name="next-element">The content of the next element to be processed. This is used in combination with the <xd:ref name="count" type="parameter">count param</xd:ref> to cycle through the set of fields used to create an element with dates.</xd:param>
        <xd:param name="count">A counter to facilitate cycling through fields recursively.</xd:param>
    </xd:doc>
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p></xd:p>
        </xd:desc>
        <xd:param name="date-type"></xd:param>
        <xd:param name="next-element-name"></xd:param>
        <xd:param name="next-element"></xd:param>
        <xd:param name="count"></xd:param>
    </xd:doc>
    <xsl:template name="date-attributes" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="date-type"/>
        <xsl:param name="next-element-name"/>
        <xsl:param name="next-element"/>
        <xsl:param name="count"/>
        <!-- Tests whether the beginning of the field name matches the name of the human-readable field. 
        For this to work, machine-readable date fields need to start with the field name of the corresponding human-readable field.
        For example, GEDSH_DOB and GEDSH_DOB_Standard -->
        <!-- What should be done if a _Begin field or an _End field have notBefore/notAfter attributes? -->
        <xsl:if test="contains($next-element-name, $date-type)">
            <xsl:if test="string-length(normalize-space($next-element))">
                <xsl:choose>
                    <xsl:when test="contains($next-element-name, '_Begin_Standard')">
                        <xsl:attribute name="from" select="$next-element"/>
                    </xsl:when>
                    <xsl:when test="contains($next-element-name, '_End_Standard')">
                        <xsl:attribute name="to" select="$next-element"/>
                    </xsl:when>
                    <xsl:when test="contains($next-element-name, '_Standard')">
                        <xsl:attribute name="when" select="$next-element"/>
                    </xsl:when>
                    <xsl:when test="contains($next-element-name, '_Not_Before')">
                        <xsl:attribute name="notBefore" select="$next-element"/>
                    </xsl:when>
                    <xsl:when test="contains($next-element-name, '_Not_After')">
                        <xsl:attribute name="notAfter" select="$next-element"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        <xsl:call-template name="date-attributes">
            <xsl:with-param name="date-type" select="$date-type"/>
            <xsl:with-param name="next-element-name" select="name(following-sibling::*[$count + 1])"/>
            <xsl:with-param name="next-element" select="following-sibling::*[$count + 1]"/>
            <xsl:with-param name="count" select="$count + 1"/>
        </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
