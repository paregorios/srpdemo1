<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:functx="http://www.functx.com">
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
    
    <xsl:function name="functx:escape-for-regex" as="xs:string" 
        xmlns:functx="http://www.functx.com" >
        <xsl:param name="arg" as="xs:string?"/> 
        
        <xsl:sequence select=" 
            replace($arg,
            '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
            "/>
        
    </xsl:function>
        
    
    <xsl:template name="main" match="/root">
        <!-- Creates a TEI document for each row (person record). -->
        <xsl:for-each select="row">
            <!-- Creates variable to use for displaying the name in titles, headers, etc. -->
            <xsl:variable name="display-name-english">
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(GEDSH_en-Full))">
                        <xsl:value-of select="GEDSH_en-Full"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(GS_en-Full))">
                        <xsl:value-of select="GS_en-Full"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(Barsoum_en-Full))">
                        <xsl:value-of select="Barsoum_en-Full"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(CBSC_en-Full))">
                        <xsl:value-of select="CBSC_en-Full"/>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(Other_en-Full))">
                        <xsl:value-of select="Other_en-Full"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <!-- Creates a variable to use as the xml:id for the person element -->
            <xsl:variable name="person-id">person-<xsl:value-of select="SRP_ID"/></xsl:variable>
            
            <xsl:variable name="person-name-id">name<xsl:value-of select="SRP_ID"/></xsl:variable>
            <!-- Assigns numbers to each source to use as base for ids, such as xml:id elements for bib and persName -->
            
            <!-- Creates sequence containing all full name elements for the row, so that variables can be created by processing this only once. -->
            <xsl:variable name="all-full-names">
                <xsl:copy-of select="*[matches(name(), '(_|-)Full')]"/>
            </xsl:variable>
            
            <!-- A sequence of one column per source (or two for vocalized/non-vocalized), using full name if available 
            or another column if information other than a name is derived from the source. -->
            <!-- Any sources need to have a column represented here. -->
            <xsl:variable name="sourced-columns">
                <xsl:copy-of select="$all-full-names"/>
                <xsl:copy-of select="VIAF-Dates_Raw"/>
            </xsl:variable>
            
            <xsl:variable name="ids-base">
                <xsl:call-template name="ids-base">
                    <xsl:with-param name="sourced-columns" select="$sourced-columns"/>
                    <xsl:with-param name="count" select="1"/>
                    <xsl:with-param name="same-source-adjustment" select="0"/>
                </xsl:call-template>
            </xsl:variable>
            
            <!-- Names that will be put in parallel (using @corresp) need variables for their ids? -->
            <!--<xsl:variable name="gedsh-id-base" select="$ids-base/*[contains(name(), 'GEDSH')]"/>
            <xsl:variable name="barsoum-en-id-base" select="$ids-base/*[contains(name(), 'Barsoum_En')]"/>
            <xsl:variable name="barsoum-ar-id-base" select="$ids-base/*[contains(name(), 'Barsoum_Ar')]"/>
            <xsl:variable name="barsoum-sy-id-base" select="$ids-base/*[contains(name(), 'Barsoum_Sy_NV')]"/>
            <xsl:variable name="abdisho-ydq-id-base" select="$ids-base/*[contains(name(), 'Abdisho_YdQ_Sy_NV')]"/>
            <xsl:variable name="abdisho-bo-id-base" select="$ids-base/*[contains(name(), 'Abdisho_BO_Sy_NV')]"/>
            <xsl:variable name="cbsc-id-base" select="$ids-base/*[contains(name(), 'CBSC')]"/>-->
            
            <xsl:variable name="name-ids">
                <xsl:for-each select="$all-full-names/*">
                    
                        <xsl:variable name="name" select="name()"/>
                        <xsl:element name="{name()}"><xsl:value-of select="concat($person-name-id, '-', $ids-base/*[contains(name(), $name)])"/></xsl:element>
                    
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="name-links">
                <xsl:for-each select="$name-ids/*">
                    <xsl:variable name="name" select="name()"/>
                    <!-- If the corresponding full name has content ... -->
                    <xsl:if test="string-length(normalize-space($all-full-names/*[contains(name(), $name)]))">
                        <!-- ... create a link to the name id by adding a hash tag to it. -->
                        <xsl:element name="{name()}">#<xsl:value-of select="."/></xsl:element>
                    </xsl:if>
                 </xsl:for-each>
            </xsl:variable>
            <!--
            <!-\- Creates xml:id for persName elements, including # on beginning to use for links. -\->
            <xsl:variable name="gedsh-name-link" select="$name-links/*[contains(name(), 'GEDSH')]"/>
            
            <xsl:variable name="barsoum-en-name-link">
                <xsl:if test="normalize-space($all-full-names/*[contains(name(), 'Barsoum_En')])">#<xsl:value-of select="$person-name-id"/><xsl:value-of select="$barsoum-en-id-base"/></xsl:if>
            </xsl:variable>
            <xsl:variable name="barsoum-ar-name-link">
                <xsl:if test="normalize-space($all-full-names/*[contains(name(), 'Barsoum_Ar')])">#<xsl:value-of select="$person-name-id"/><xsl:value-of select="$barsoum-ar-id-base"/></xsl:if>
            </xsl:variable>
            <xsl:variable name="barsoum-sy-nv-name-link" select="$name-links/*[contains(name(), 'Barsoum_Sy_NV')]"/>
            <xsl:variable name="barsoum-sy-v-name-link">
                <xsl:if test="normalize-space($all-full-names/*[contains(name(), 'Barsoum_Sy_V')])">#<xsl:value-of select="$person-name-id"/><xsl:value-of select="$barsoum-sy-id-base"/>b</xsl:if>
            </xsl:variable>
            <xsl:variable name="abdisho-ydq-sy-nv-name-link">
                <xsl:if test="normalize-space($all-full-names/*[contains(name(), 'Abdisho_YdQ_Sy_NV')])">#<xsl:value-of select="$person-name-id"/><xsl:value-of select="$abdisho-ydq-id-base"/>a</xsl:if>
            </xsl:variable>
            <xsl:variable name="abdisho-ydq-sy-v-name-link">
                <xsl:if test="normalize-space($all-full-names/*[contains(name(), 'Abdisho_YdQ_Sy_V')])">#<xsl:value-of select="$person-name-id"/><xsl:value-of select="$abdisho-ydq-id-base"/>b</xsl:if>
            </xsl:variable>
            <xsl:variable name="abdisho-bo-sy-nv-name-link">
                <xsl:if test="normalize-space($all-full-names/*[contains(name(), 'Abdisho_BO_Sy_NV')])">#<xsl:value-of select="$person-name-id"/><xsl:value-of select="$abdisho-bo-id-base"/>a</xsl:if>
            </xsl:variable>
            <xsl:variable name="abdisho-bo-sy-v-name-link">
                <xsl:if test="normalize-space($all-full-names/*[contains(name(), 'Abdisho_BO_Sy_V')])">#<xsl:value-of select="$person-name-id"/><xsl:value-of select="$abdisho-bo-id-base"/>b</xsl:if>
            </xsl:variable>
            <xsl:variable name="cbsc-name-link">
                <xsl:if test="normalize-space($all-full-names/*[contains(name(), 'CBSC')])">#<xsl:value-of select="$person-name-id"/><xsl:value-of select="$cbsc-id-base"/></xsl:if>
            </xsl:variable>-->
            
            <!-- Creates a variable to use as the base for the xml:id for bib elements -->
            <!-- Should this be bibl- instead of bib? (If changed, need to change in places records too.) -->
            <xsl:variable name="bib-id">bib<xsl:value-of select="SRP_ID"/></xsl:variable>
            
            <xsl:variable name="bib-ids">
                <xsl:for-each select="$sourced-columns/*">
                    
                        <xsl:variable name="name" select="name()"/>
                        <xsl:element name="{name()}"><xsl:value-of select="concat($bib-id, '-', replace($ids-base/*[contains(name(), $name)], 'a|b', ''))"/></xsl:element>
                    
                </xsl:for-each>
            </xsl:variable>
            
            <!-- Creates variables to use as xml:id for bib elements -->
            <!--<xsl:variable name="gedsh-id">
                <xsl:value-of select="concat($bib-id, $gedsh-id-base)"/>
            </xsl:variable>
            <xsl:variable name="barsoum-en-id">
                <xsl:value-of select="concat($bib-id, $barsoum-en-id-base)"/>
            </xsl:variable>
            <xsl:variable name="barsoum-ar-id">
                <xsl:value-of select="concat($bib-id, $barsoum-ar-id-base)"/>
            </xsl:variable>
            <xsl:variable name="barsoum-sy-id">
                <xsl:value-of select="concat($bib-id, $barsoum-sy-id-base)"/>
            </xsl:variable>
            <xsl:variable name="abdisho-ydq-id">
                <xsl:value-of select="concat($bib-id, $abdisho-ydq-id-base)"/>
            </xsl:variable>
            <xsl:variable name="abdisho-bo-id">
                <xsl:value-of select="concat($bib-id, $abdisho-bo-id-base)"/>
            </xsl:variable>
            <xsl:variable name="cbsc-id">
                <xsl:value-of select="concat($bib-id, $cbsc-id-base)"/>
            </xsl:variable>-->
            
            <!-- Determines which name part should be used first in alphabetical lists by consulting the order in GEDSH or GEDSH-style.
            Doesn't work for comma-separated name parts that should be sorted as first. 
            If no name part can be matched with beginning of full name, defaults to given, then family, then titles, if they exist.
            If no GEDSH or GEDSH-style name exists, defaults to given. -->
            <xsl:variable name="sort">
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(GEDSH_en-Full)) and string-length(normalize-space(concat(GEDSH_en-Given, GEDSH_en-Family, GEDSH_en-Titles)))">
                        <xsl:choose>
                            <xsl:when test="starts-with(GEDSH_en-Full, GEDSH_en-Given)">given</xsl:when>
                            <xsl:when test="starts-with(GEDSH_en-Full, GEDSH_en-Family)">family</xsl:when>
                            <xsl:when test="starts-with(GEDSH_en-Full, GEDSH_en-Titles)">titles</xsl:when>
                            <xsl:when test="string-length(normalize-space(GEDSH_en-Given))">given</xsl:when>
                            <xsl:when test="string-length(normalize-space(GEDSH_en-Family))">family</xsl:when>
                            <xsl:when test="string-length(normalize-space(GEDSH_en-Titles))">titles</xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="string-length(normalize-space(GS_en-Full)) and string-length(normalize-space(concat(GS_en-Given, GS_en-Family, GS_en-Titles)))">
                        <xsl:choose>
                            <xsl:when test="starts-with(GS_en-Full, GS_en-Given)">given</xsl:when>
                            <xsl:when test="starts-with(GS_en-Full, GS_en-Family)">family</xsl:when>
                            <xsl:when test="starts-with(GS_en-Full, GS_en-Titles)">titles</xsl:when>
                            <xsl:when test="string-length(normalize-space(GS_en-Given))">given</xsl:when>
                            <xsl:when test="string-length(normalize-space(GS_en-Family))">family</xsl:when>
                            <xsl:when test="string-length(normalize-space(GS_en-Titles))">titles</xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>given</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            
            
            <xsl:variable name="filename"
                select="concat('persons-authorities-spreadsheet-output/',SRP_ID,'.xml')"/>
            <!-- Writes the file to the subdirectory "persons-authorities-spreadsheet-output" and give it the name of the record's SRP ID. -->
            <xsl:result-document href="{$filename}" format="xml">
                <TEI xml:lang="en" xmlns="http://www.tei-c.org/ns/1.0">
                    <!-- Need to decide what header should look like. -->
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title xml:lang="en"><xsl:value-of select="$display-name-english"/></title>
                                <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                                <!-- Which funders do we include here? -->
                                <funder>The Andrew W. Mellon Foundation</funder>
                                <funder>The National Endowment for the Humanities</funder>
                                <funder>The International Balzan Prize Foundation</funder>
                                <principal><name ref="http://syriaca.org/editors.xml#dmichelson">David A. Michelson</name></principal>
                                <editor role="creator"><name ref="http://syriaca.org/editors.xml#dmichelson">David A. Michelson</name></editor>
                                    <editor role="creator"><name ref="http://syriaca.org/editors.xml#ngibson">Nathan P. Gibson</name></editor>
                                        <!-- Put these in alphabetical order -->
                                        <respStmt>
                                            <resp>Editing, document design, proofreading, data entry by</resp>
                                            <name ref="http://syriaca.org/editors.xml#dmichelson">David A. Michelson</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>Editing, proofreading, data entry by</resp>
                                            <name ref="http://syriaca.org/editors.xml#jnsaint-laurent">Jeanne-Nicole Saint-Laurent</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>English name entry, matching with viaf.org records by</resp>
                                            <name ref="http://syriaca.org/editors.xml#jwalters">James E. Walters</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>Matching with viaf.org records, data entry, data transformation, conversion to XML by</resp>
                                            <name ref="http://syriaca.org/editors.xml#ngibson">Nathan P. Gibson</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>editing, Syriac name entry, disambiguation research by</resp>
                                            <name ref="http://syriaca.org/editors.xml#tcarlson">Thomas A. Carlson</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>Syriac name entry by</resp>
                                            <name ref="http://syriaca.org/editors.xml#raydin">Robert Aydin</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>Arabic name entry by</resp>
                                            <name ref="http://syriaca.org/editors.xml#pkirlles">Philemon Kirlles</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>Arabic name entry by</resp>
                                            <name ref="http://syriaca.org/editors.xml#jkaado">Jad Kaado</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>Normalization, matching with viaf.org records by</resp>
                                            <name ref="http://syriaca.org/editors.xml#avawter">Alex Vawter</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>Date entry by</resp>
                                            <name ref="http://syriaca.org/editors.xml#rsingh-bischofberger">Ralf Singh-Bischofberger</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>Project managament, english text entry, and proofreading by</resp>
                                            <name type="person" ref="http://syriaca.org/editors.xml#cjohnson">
                                                Christopher Johnson</name>
                                        </respStmt>
                                        <respStmt>
                                            <resp>English text entry and proofreading by</resp>
                                            <name type="org"
                                                ref="http://syriaca.org/editors.xml#uasyriacresearchgroup">
                                                the Syriac Research Group, University of Alabama</name>
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
                            <p>This record created following the Syriaca.org guidelines. Documentation available at: <ptr target="http://syriaca.org/documentation">
                                http://syriaca.org/documentation</ptr>.</p>
                            <p>Headwords or names without source attributes may not be attested in extant sources. They are included only to aid the reader for the purpose of disambiguation. These names have been created according to the Syriac.org guidelines for headwords: <ptr target="http://syriaca.org/documentation/headwords">
                                http://syriaca.org/documentation/headwords</ptr>.</p>
                            <editorialDecl>
                                <interpretation>
                                    <p>Approximate dates described in terms of centuries or partial centuries have been interpreted as in the following example:
                                    "4th cent." - notBefore="300" notAfter="399".
                                    "Early 4th cent." - notBefore="300" notAfter="349". 
                                    "Late 4th cent." - notBefore="350" notAfter="399". 
                                    "Mid-4th cent." - notBefore="325" notAfter="374". 
                                    Etc.</p>
                                </interpretation>                                
                                <!-- Are there other editorial decisions we need to record here? -->
                            </editorialDecl>
                            <classDecl>
                                <taxonomy>
                                    <category xml:id="syriaca-headword">
                                        <catDesc>The name used by Syriaca.org for document titles, citation, and disambiguation. While headwords are usually created from primary source citations, those without source attributes may not be attested in extant sources. They are included only to aid the reader for the purpose of disambiguation. These names have been created according to the Syriac.org guidelines for headwords: <ptr target="http://syriaca.org/documentation/headwords">
                                            http://syriaca.org/documentation/headwords</ptr>.</catDesc>
                                        <!-- Need to include more types, such as addName types. -->
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
                                <language ident="en-x-gedsh">Names or terms Romanized into English according to the standards adopted by the Gorgias Encyclopedic Dictionary of the Syriac Heritage</language>
                                <language ident="ar">Arabic</language>
                                <language ident="fr">French</language>
                                <language ident="de">German</language>
                                <language ident="la">Latin</language>
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
                                        <!-- Selects any non-empty fields ending with "_Full" or "-Full" (i.e., full names) -->
                                        <xsl:for-each select="*[matches(name(),'(_|-)Full') and string-length(normalize-space(node()))]">
                                            <persName>
                                                <!-- Adds xml:id attribute. -->
                                                <xsl:call-template name="perName-id">
                                                    <xsl:with-param name="name-ids" select="$name-ids"/>
                                                    <xsl:with-param name="name-links" select="$name-links"/>
                                                </xsl:call-template>                                                
                                                <!-- Adds language attributes. -->
                                                <xsl:call-template name="language"/>
                                                <!-- Adds source attributes. -->
                                                <xsl:call-template name="source">
                                                    <xsl:with-param name="bib-ids" select="$bib-ids"/>
                                                </xsl:call-template>
                                                <!-- Shows which name forms are authorized. -->
                                                <!-- Need to test whether this properly overrides GEDSH with GS as headword. -->
                                                <xsl:if test="contains(name(),'GS_en') or (contains(name(),'GEDSH') and not(string-length(normalize-space(*[contains(name(), 'GS_en')])))) or contains(name(),'Authorized_syr')">
                                                    <xsl:attribute name="syriaca-tags" select="'#syriaca-headword'"/>
                                                </xsl:if>
                                                <!--A variable to hold the first part of the column name, which must be the same for all name columns from that source. 
                                                E.g., "Barsoum_en" for the columns "Barsoum_en", "Barsoum_en-Given", etc.-->
                                                <xsl:variable name="group" select="replace(name(), '(_|-)Full', '')"/>
                                                <!-- Adds name parts -->
                                                <xsl:call-template name="name-parts">
                                                    <xsl:with-param name="name" select="."/>
                                                    <xsl:with-param name="count" select="1"/>
                                                    <xsl:with-param name="all-name-parts" select="following-sibling::*[contains(name(), $group)]"/>
                                                    <xsl:with-param name="sort" select="$sort"/>
                                                </xsl:call-template>
                                            </persName>
                                        </xsl:for-each>
                                        
                                        
                                        
                                        <!-- Adds VIAF URLs. -->
                                        <!--What will our VIAF source ID be? SRP?-->
                                        <idno type="URI">http://viaf.org/viaf/sourceID/SRP|<xsl:value-of select="SRP_ID"/></idno>
                                        
                                        <xsl:for-each select="URL[string-length(normalize-space()) > 0]">
                                            <idno type="URI">
                                                <xsl:value-of select="."/>
                                            </idno>
                                        </xsl:for-each>
                                      
                                      <!-- Adds date elements -->
                                        <xsl:for-each select="*[ends-with(name(), 'Floruit') or ends-with(name(), 'DOB') or ends-with(name(), 'DOD')]">
                                            <xsl:call-template name="date-or-event">
                                                <xsl:with-param name="bib-ids" select="$bib-ids"/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <!-- Add anything that should be processed as an event to the following. -->
                                        <xsl:if test="string-length(normalize-space(GEDSH_en-Reign))">
                                            <listEvent>
                                                <xsl:for-each 
                                                    select="*[ends-with(name(),'Reign')]">
                                                    
                                                        <xsl:call-template name="date-or-event">
                                                            <xsl:with-param name="bib-ids" select="$bib-ids"/>
                                                        </xsl:call-template>
                                                    
                                                </xsl:for-each>
                                            </listEvent>
                                        </xsl:if>
                                        
                                        <!-- Bibl elements -->
                                        <!-- Should languages be declared for English titles or only non-English? -->
                                        <!-- Citation for GEDSH -->
                                        <xsl:if
                                            test="string-length(normalize-space(concat(GEDSH_en-Start_Pg,GEDSH_en-Entry_Num,GEDSH_en-Full))) > 0">
                                            <bibl xml:id="{$bib-ids/*[contains(name(), 'GEDSH')]}">
                                                <title>The Gorgias Encyclopedic Dictionary of the Syriac Heritage</title>
                                                <abbr>GEDSH</abbr>
                                                <ptr target="http://syriaca.org/bibl/1"/>
                                                <xsl:if
                                                  test="string-length(normalize-space(GEDSH_en-Entry_Num)) > 0">
                                                  <citedRange unit="entry">
                                                  <xsl:value-of select="GEDSH_en-Entry_Num"/>
                                                  </citedRange>
                                                </xsl:if>
                                                <xsl:if
                                                  test="string-length(normalize-space(GEDSH_en-Start_Pg)) > 0">
                                                  <citedRange unit="pp">
                                                  <xsl:value-of select="GEDSH_en-Start_Pg"/>
                                                  </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        
                                        <!-- Citations for Barsoum-->
                                        <!-- Does the order matter here? -->
                                        <xsl:if
                                            test="string-length(normalize-space(Barsoum_en-Full)) > 0">
                                            <bibl xml:id="{$bib-ids/*[contains(name(), 'Barsoum_en')]}">
                                                <title xml:lang="en">The Scattered Pearls: A History of Syriac Literature and Sciences</title>
                                                <abbr>Barsoum (English)</abbr>
                                                <ptr target="http://syriaca.org/bibl/4"/>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_en-Entry_Num)) > 0">
                                                    <citedRange unit="entry">
                                                        <xsl:value-of select="Barsoum_en-Entry_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_en-Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Barsoum_en-Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(Barsoum_ar-Full)) > 0">
                                            <bibl xml:id="{$bib-ids/*[contains(name(), 'Barsoum_ar')]}">
                                                <title xml:lang="ar">كتاب اللؤلؤ المنثور في تاريخ العلوم والأداب
                                                    السريانية</title>
                                                <abbr>Barsoum (Arabic)</abbr>
                                                <ptr target="http://syriaca.org/bibl/2"/>
                                                <!-- Are entry nums the same for Arabic as for English? -->
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_en-Entry_Num)) > 0">
                                                    <citedRange unit="entry">
                                                        <xsl:value-of select="Barsoum_en-Entry_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_ar-Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Barsoum_ar-Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(Barsoum_syr-NV_Full)) > 0">
                                            <bibl xml:id="{$bib-ids/*[contains(name(), 'Barsoum_syr-NV')]}">
                                                <!-- Is this the actual title? -->
                                                <title>The Scattered Pearls: A History of Syriac Literature and Sciences</title>
                                                <abbr>Barsoum (Syriac)</abbr>
                                                <ptr target="http://syriaca.org/bibl/3"/>
                                                <!-- Are entry nums the same for Syriac as for English? -->
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_en-Entry_Num)) > 0">
                                                    <citedRange unit="entry">
                                                        <xsl:value-of select="Barsoum_en-Entry_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Barsoum_syr-Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Barsoum_syr-Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        
                                        <!-- Need Abdisho titles -->
                                        <xsl:if
                                            test="string-length(normalize-space(Abdisho_YdQ_syr-NV_Full)) > 0">
                                            <bibl xml:id="{$bib-ids/*[contains(name(), 'Abdisho_YdQ_syr-NV')]}">
                                                <title>Abdisho (YdQ)</title>
                                                <abbr>Abdisho (YdQ)</abbr>
                                                <ptr target="http://syriaca.org/bibl/6"/>
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_YdQ_syr-Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Abdisho_YdQ_syr-Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        <xsl:if
                                            test="(string-length(normalize-space(Abdisho_BO_syr-NV_Full)) > 0) or (string-length(normalize-space(Abdisho_BO_syr-V_Full)) > 0)">
                                            <bibl xml:id="{$bib-ids/*[contains(name(), 'Abdisho_BO_syr-NV')]}">
                                                <title>Abdisho (BO)</title>
                                                <abbr>Abdisho (BO)</abbr>
                                                <ptr target="http://syriaca.org/bibl/7"/>
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_BO_syr-Page_Num)) > 0">
                                                    <citedRange unit="pp">
                                                        <xsl:value-of select="Abdisho_BO_syr-Page_Num"/>
                                                    </citedRange>
                                                </xsl:if>
                                            </bibl>
                                        </xsl:if>
                                        <xsl:if
                                            test="string-length(normalize-space(CBSC_en-Full)) > 0">
                                            <!-- Should we include the link to CBSC as an additional @target on the pointer?-->
                                            <!-- Should CBSC link go directly to the tag on the CBSC system? 
                                            If so, we'll need to have some way to discern whether it is a  subject heading or an author heading in CBSC.
                                            And should that go under citedRange?-->
                                            <bibl xml:id="{$bib-ids/*[contains(name(), 'CBSC')]}">
                                                <title>A Comprehensive Bibliography on Syriac Christianity</title>
                                                <abbr>CBSC</abbr>
                                                <ptr target="http://syriaca.org/bibl/5 http://www.csc.org.il/db/db.aspx?db=SB"/>
                                            </bibl>
                                        </xsl:if>
                                        <!-- Should we put the link to the extended VIAF record as a pointer? -->
                                        <xsl:if
                                            test="string-length(normalize-space(VIAF-Dates_Raw)) > 0">
                                            <bibl xml:id="{$bib-ids/*[contains(name(), 'VIAF')]}">
                                                <title>Virtual International Authority File</title>
                                                <abbr>VIAF</abbr>
                                                <ptr target="http://viaf.org"/>
                                                <span>Information cited from VIAF may come from any library or agency participating with VIAF.</span>
                                            </bibl>
                                        </xsl:if>                                        
                                        
                                        <!-- Adds Record Description field as a note. -->
                                        <xsl:if test="string-length(normalize-space(Record_Description))">
                                            <note type="record-description">
                                                <xsl:value-of select="Record_Description"/>
                                            </note>
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

        <!-- Create an index file that links to all of the TEI files.
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
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Cycles through all the full names, assigning each a number that will be used as an id. Vocalized and non-vocalized versions of full-names are given "a" and "b" suffixes.</xd:p>
        </xd:desc>
        <xd:param name="all-full-names">All columns ending in "_Full"</xd:param>
        <xd:param name="count">A counter to cycle through all the columns in all-full-names</xd:param>
        <xd:param name="same-source-adjustment">Adjusts the number assigned to reflect that vocalized and non-vocalized versions of names from the same source have the same number (but an added suffix).</xd:param>
        <xd:param name="next-column-name">Gets the name of the column to be processed out of the group of columns in all-full-names</xd:param>
    </xd:doc>
    <xsl:template name="ids-base">
        <xsl:param name="sourced-columns"/>
        <xsl:param name="count"/>
        <xsl:param name="same-source-adjustment"/>
        <xsl:param name="next-column-name" select="name($sourced-columns/*[$count])"/>
        <xsl:if test="$next-column-name">
            <xsl:element name="{$next-column-name}">
                <xsl:value-of select="$count - $same-source-adjustment"/>
                <xsl:choose>
                    <xsl:when test="matches($next-column-name, '(_|-)NV_')">a</xsl:when>
                    <xsl:when test="matches($next-column-name, '(_|-)V_')">b</xsl:when>
                </xsl:choose>
            </xsl:element>
            <xsl:call-template name="ids-base">
                <xsl:with-param name="sourced-columns" select="$sourced-columns"/>
                <xsl:with-param name="count" select="$count + 1"/>
                <xsl:with-param name="same-source-adjustment">
                    <xsl:choose>
                        <!-- This test assumes non-vocalized and vocalized columns coming from the same source do not have any intervening columns containing full names from a different source -->
                        <xsl:when test="matches(replace($next-column-name, '(_|-)NV_|(_|-)V_', ''), replace(name($sourced-columns/*[$count + 1]), '(_|-)NV_|(_|-)V_', ''))"><xsl:value-of select="$same-source-adjustment + 1"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$same-source-adjustment"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="language" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="column-name" select="name()"/>
        <!-- If any other language codes are used in the input spreadsheet, add them below. -->
        <xsl:analyze-string select="name()" regex="_(syr|en|ar|de|fr|lat)-">
            <xsl:matching-substring>
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="replace(replace(., '_', ''), '-', '')"/>
                    <!-- Adds script code to vocalized names. -->
                    <xsl:if test="matches($column-name, '(-|_)V_')">
                        <xsl:choose>
                            <xsl:when test="contains($column-name, 'Barsoum_syr-')">-Syrj</xsl:when>
                            <xsl:when test="contains($column-name, 'Abdisho')">-Syrn</xsl:when>
                        </xsl:choose>
                    </xsl:if>
                    <xsl:if test="matches($column-name, 'GEDSH_en-|GS_en-')">-x-gedsh</xsl:if>
                </xsl:attribute>
            </xsl:matching-substring>
        </xsl:analyze-string>
        
        <!--<xsl:choose>
            <!-\- Should English entries be @xml:lang="en" or @xml:lang="syr-Latn" plus a transcription scheme? -\->
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
        </xsl:choose>-->
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
    <xsl:template name="source" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="bib-ids"/>
        <xsl:param name="column-name" select="name(.)"/>
        <!-- Adds @source if the column is from a source external to syriaca.org. -->
        <xsl:if test="not(matches(name(), 'GS_|Authorized_'))">
            <xsl:attribute name="source" select="concat('#', $bib-ids/*[contains(name(), $column-name)])"/>
        </xsl:if>
   </xsl:template>
    
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
        <xd:desc>
            <xd:p>This template does the following:
                <xd:ul>
                    <xd:li>Creates xml:id attributes for persName elements, generating the ID's by stringing together the SRP ID, a number corresponding to the source column, an "a" or "b" for unvocalized/vocalized, and a 0 or 1 for split/unsplit.</xd:li>
                    <xd:li>Links the persName to other language/vocalization versions of the name using @corresp.</xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
        <xd:param name="split-id">Designates whether the persName is a split ("-1") or unsplit ("-0") version of the name.</xd:param>
    </xd:doc>
    <xsl:template name="perName-id" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="name-ids"/>
        <xsl:param name="name-links"/>
        <xsl:param name="current-column-name" select="name()"/>
        <!--<xsl:param name="barsoum-en-name-link" select="$name-links/*[contains(name(), 'Barsoum_En']"/>
        <xsl:param name="barsoum-ar-name-link"/>
        <xsl:param name="barsoum-sy-nv-name-link"/>
        <xsl:param name="barsoum-sy-v-name-link"/>
        <xsl:param name="abdisho-ydq-sy-nv-name-link"/>
        <xsl:param name="abdisho-ydq-sy-v-name-link"/>
        <xsl:param name="abdisho-bo-sy-nv-name-link"/>
        <xsl:param name="abdisho-bo-sy-v-name-link"/>
        <xsl:param name="cbsc-name-link"/>-->
        
        <xsl:attribute name="xml:id" select="$name-ids/*[contains(name(), $current-column-name)]"/>
        <!-- Gets all other name links whose column names start with the same word (e.g., "Barsoum", "Abdisho").
        Requires that names that should be parallel have column names starting with same word (before underscore)
        and that names that should not be parallel do not.-->
        <!-- Is it OK that vocalized and non-vocalized names from different editions are parallel to each other or should I weed these out? -->
        <xsl:if test="exists($name-links/*[matches(substring-before($current-column-name, '_'), substring-before(name(), '_')) and not(contains(name(), $current-column-name))])">
            <xsl:attribute name="corresp" select="$name-links/*[matches(substring-before($current-column-name, '_'), substring-before(name(), '_')) and not(contains(name(), $current-column-name))]"/>
        </xsl:if>
        
        <!--<xsl:choose>
            <xsl:when test="contains(name(),'GEDSH')">
                <xsl:attribute name="xml:id" select="replace($gedsh-name-link, '#', '')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_En')">
                <xsl:attribute name="xml:id" select="replace($barsoum-en-name-link, '#', '')"/>
                <!-\- Puts all corresponding name ids into a single attribute separated by a space, but removes extra spaces if some are blank. -\->
                <xsl:attribute name="corresp" select="replace(string-join(($barsoum-ar-name-link, $barsoum-sy-nv-name-link, $barsoum-sy-v-name-link), ' '), '^s|\s\s|\s$', '')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Ar')">
                <xsl:attribute name="xml:id" select="replace($barsoum-ar-name-link, '#', '')"/>
                <xsl:attribute name="corresp" select="replace(string-join(($barsoum-en-name-link, $barsoum-sy-nv-name-link, $barsoum-sy-v-name-link), ' '), '^s|\s\s|\s$', '')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Barsoum_Sy_NV')">
                <xsl:attribute name="xml:id" select="replace($barsoum-sy-nv-name-link, '#', '')"/>
                <xsl:attribute name="corresp" select="replace(string-join(($barsoum-ar-name-link, $barsoum-en-name-link, $barsoum-sy-v-name-link), ' '), '^s|\s\s|\s$', '')"/>
            </xsl:when>
            <xsl:when test="contains(name(), 'Barsoum_Sy_V')">
                <xsl:attribute name="xml:id" select="replace($barsoum-sy-v-name-link, '#', '')"/>
                <xsl:attribute name="corresp" select="replace(string-join(($barsoum-ar-name-link, $barsoum-en-name-link, $barsoum-sy-nv-name-link), ' '), '^s|\s\s|\s$', '')"/>        
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_YdQ_Sy_NV')">
                <xsl:attribute name="xml:id" select="replace($abdisho-ydq-sy-nv-name-link, '#', '')"/>
                <!-\- Should Abdisho YdQ and BO be in parallel to each other too (as here and below) since different editions of same name? -\->
                <xsl:attribute name="corresp" select="replace(string-join(($abdisho-ydq-sy-v-name-link, $abdisho-bo-sy-nv-name-link, $abdisho-bo-sy-v-name-link), ' '), '^s|\s\s|\s$', '')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_YdQ_Sy_V')">
                <xsl:attribute name="xml:id" select="replace($abdisho-ydq-sy-v-name-link, '#', '')"/>
                <xsl:attribute name="corresp" select="replace(string-join(($abdisho-ydq-sy-nv-name-link, $abdisho-bo-sy-nv-name-link, $abdisho-bo-sy-v-name-link), ' '), '^s|\s\s|\s$', '')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_BO_Sy_NV')">
                <xsl:attribute name="xml:id" select="replace($abdisho-bo-sy-nv-name-link, '#', '')"/>
                <xsl:attribute name="corresp" select="replace(string-join(($abdisho-bo-sy-v-name-link, $abdisho-ydq-sy-nv-name-link, $abdisho-ydq-sy-v-name-link), ' '), '^s|\s\s|\s$', '')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'Abdisho_BO_Sy_V')">
                <xsl:attribute name="xml:id" select="replace($abdisho-bo-sy-v-name-link, '#', '')"/>
                <xsl:attribute name="corresp" select="replace(string-join(($abdisho-bo-sy-nv-name-link, $abdisho-ydq-sy-nv-name-link, $abdisho-ydq-sy-v-name-link), ' '), '^s|\s\s|\s$', '')"/>
            </xsl:when>
            <xsl:when test="contains(name(),'CBSC_En_Full')">
                <xsl:attribute name="xml:id" select="replace($cbsc-name-link, '#', '')"/>
            </xsl:when>
        </xsl:choose>-->
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
        <xd:param name="group">Field name without the name part on the end (e.g., "GEDSH" is group for "GEDSH_en-Given"). Used to make sure this template loop doesn't proceed to a different set of fields.</xd:param>
        <xd:param name="same-group">Boolean to test whether the next element is in the same group/fieldset.</xd:param>
        <xd:param name="next-element-name">The name of the next element being processed, which is the element immediately following in the source XML.</xd:param>
        <xd:param name="next-element">Content of the next element being processed, which is the element immediately following in the source XML.</xd:param>
        <xd:param name="count">A counter to use for determining the next element to process.</xd:param>
        <xd:param name="sort">Contains the name of the TEI name part element that should be used first in alphabetical lists.</xd:param>
    </xd:doc>
    <xsl:template name="name-parts" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="name"/>
        <xsl:param name="count"/>
        <xsl:param name="all-name-parts"/>
        <xsl:param name="sort"/>
        <xsl:param name="next-column" select="$all-name-parts[$count]"/>
        <xsl:param name="next-column-name" select="name($all-name-parts[$count])"/>
        <xsl:choose>
            <xsl:when test="count($all-name-parts)">
                <xsl:variable name="name-element-name">
                    <xsl:choose>
                        <xsl:when test="matches($next-column-name,'(_|-)Given')">forename</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Family')">addName</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Titles') or matches($next-column-name,'(_|-)Saint_Title') or matches($next-column-name,'(_|-)Terms_of_Address')">addName</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Office')">roleName</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Numeric_Title')">genName</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <!-- Might be able to machine-generate title types based on content (e.g., "bishop," "III", etc.) -->
                <xsl:variable name="name-element-type">
                    <xsl:choose>
                        <xsl:when test="matches($next-column-name,'(_|-)Family')">family</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Titles')">untagged-title</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Saint_Title')">saint-title</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Terms_of_Address')">terms-of-address</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Office')">office</xsl:when>
                        <xsl:when test="matches($next-column-name,'(_|-)Numeric_Title')">numeric-title</xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($next-column, ', ') or contains($next-column, '، ')">
                        <xsl:call-template name="name-parts">
                            <xsl:with-param name="name">
                                <xsl:call-template name="name-part-comma-separated">
                                    <xsl:with-param name="name" select="$name"/>
                                    <xsl:with-param name="count" select="1"/>
                                    <!-- The token for splitting comma-separated values doesn't work well for commas inside parentheses. (See SRP 224) -->
                                    <xsl:with-param name="all-name-parts" select="tokenize($next-column, ',\s|،\s')"/>
                                    <xsl:with-param name="name-element-name" select="$name-element-name"/>
                                    <xsl:with-param name="name-element-type" select="$name-element-type"/>
                                    <xsl:with-param name="sort" select="$sort"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="all-name-parts" select="$all-name-parts"/>
                            <xsl:with-param name="sort" select="$sort"/>
                        </xsl:call-template>                    
                    </xsl:when>
                    <xsl:when test="string-length($next-column-name)">
                        <xsl:choose>
                            <xsl:when test="string-length($name-element-name) and string-length(normalize-space($next-column))">
                                <xsl:analyze-string select="$name" regex="{functx:escape-for-regex($next-column)}" flags="i">
                                    <xsl:matching-substring>
                                        <xsl:call-template name="name-part-element">
                                            <xsl:with-param name="name-element-name" select="$name-element-name"/>
                                            <xsl:with-param name="name-element-type" select="$name-element-type"/>
                                            <xsl:with-param name="sort" select="$sort"/>
                                        </xsl:call-template>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:call-template name="name-parts">
                                            <xsl:with-param name="name" select="."/>
                                            <xsl:with-param name="count" select="$count + 1"/>
                                            <xsl:with-param name="all-name-parts" select="$all-name-parts"/>
                                            <xsl:with-param name="sort" select="$sort"/>
                                        </xsl:call-template>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="name-parts">
                                    <xsl:with-param name="name" select="$name"/>
                                    <xsl:with-param name="count" select="$count + 1"/>
                                    <xsl:with-param name="all-name-parts" select="$all-name-parts"/>
                                    <xsl:with-param name="sort" select="$sort"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$name"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="name-part-comma-separated" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="name"/>
        <xsl:param name="count"/>
        <xsl:param name="all-name-parts"/>
        <xsl:param name="name-element-name"/>
        <xsl:param name="name-element-type"/>
        <xsl:param name="next-column" select="$all-name-parts[$count]"/>
        <xsl:param name="sort"/>
        <xsl:choose>
            <xsl:when test="count($all-name-parts) >= $count">
                <xsl:choose>
                    <xsl:when test="string-length($name-element-name) and string-length(normalize-space($next-column))">
                        <xsl:analyze-string select="$name" regex="{functx:escape-for-regex($next-column)}" flags="i">
                            <xsl:matching-substring>
                                <xsl:call-template name="name-part-element">
                                    <xsl:with-param name="name-element-name" select="$name-element-name"/>
                                    <xsl:with-param name="name-element-type" select="$name-element-type"/>
                                    <xsl:with-param name="sort" select="$sort"/>
                                </xsl:call-template>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:call-template name="name-part-comma-separated">
                                    <xsl:with-param name="name" select="."/>
                                    <xsl:with-param name="count" select="$count + 1"/>
                                    <xsl:with-param name="all-name-parts" select="$all-name-parts"/>
                                    <xsl:with-param name="name-element-name" select="$name-element-name"/>
                                    <xsl:with-param name="name-element-type" select="$name-element-type"/>
                                    <xsl:with-param name="sort" select="$sort"/>
                                </xsl:call-template>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="name-part-comma-separated">
                            <xsl:with-param name="name" select="$name"/>
                            <xsl:with-param name="count" select="$count + 1"/>
                            <xsl:with-param name="all-name-parts" select="$all-name-parts"/>
                            <xsl:with-param name="name-element-name" select="$name-element-name"/>
                            <xsl:with-param name="name-element-type" select="$name-element-type"/>
                            <xsl:with-param name="sort" select="$sort"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$name"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="name-part-element" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="name-element-name"/>
        <xsl:param name="name-element-type"/>
        <xsl:param name="sort"/>
        <xsl:element name="{$name-element-name}">
            <xsl:if test="string-length($name-element-type)">
                <xsl:attribute name="type" select="$name-element-type"/>
            </xsl:if>
            <xsl:if test="string-length(normalize-space($sort))">
                <xsl:attribute name="sort">
                    <xsl:choose>
                        <xsl:when test="($name-element-name = 'forename') and ($sort = 'given')">1</xsl:when>
                        <xsl:when test="($name-element-name = 'addName')">
                            <xsl:choose>
                                <xsl:when test="($name-element-type = 'family') and ($sort = 'family')">1</xsl:when>
                                <xsl:when test="$sort = 'titles'">1</xsl:when>
                                <xsl:otherwise>2</xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>2</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="."/>
        </xsl:element>
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
    </xd:doc>
    
    <!-- Do we need human readable content on all dates (including VIAF)? -->
    <xsl:template name="date-or-event" xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:param name="bib-ids"/>
        <xsl:param name="column-name" select="name()"/>
        <xsl:param name="element-name">
            <xsl:choose>
                <xsl:when test="ends-with(name(), 'Floruit')">floruit</xsl:when>
                <xsl:when test="ends-with(name(), 'DOB')">birth</xsl:when>
                <xsl:when test="ends-with(name(), 'DOD')">death</xsl:when>
                <xsl:when test="ends-with(name(), 'Reign')">event</xsl:when>
            </xsl:choose>
        </xsl:param>
        
        <xsl:if test="string-length(normalize-space(.)) or exists(following-sibling::*[contains(name(), $column-name) and string-length(normalize-space(node()))])">
            <xsl:element name="{$element-name}">
                <!-- Adds machine-readable attributes to date. -->
                <xsl:call-template name="date-attributes">
                    <xsl:with-param name="date-type" select="replace(replace(name(), '_Begin', ''), '_End', '')"/>
                    <xsl:with-param name="next-element-name" select="name()"/>
                    <xsl:with-param name="next-element" select="node()"/>
                    <xsl:with-param name="count" select="0"/>
                </xsl:call-template>
        
                <!-- Adds source attributes. -->
                <xsl:call-template name="source">
                    <xsl:with-param name="bib-ids" select="$bib-ids"/>
                    <xsl:with-param name="column-name" select="substring-before(name(.), '-')"/>
                </xsl:call-template>
                
                <!-- Adds custom type and, if relevant, human-readable date as content of element
                Can add more custom types here based on column name. -->
                <xsl:choose>
                    <xsl:when test="contains(name(), 'Reign')">
                        <!-- Is "incumbency" or "term-of-office" better for this? -->
                        <xsl:attribute name="type" select="'reign'"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
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
        For example, GEDSH_en-DOB and GEDSH_en-DOB_Standard -->
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
