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
    
    <!-- Modules -->
    <!-- HTML index for easily viewing result TEI files -->
    <xsl:include href="person-spreadsheet2tei-modules/index.xsl"/>
    <!-- TEI Header -->
    <xsl:include href="person-spreadsheet2tei-modules/header.xsl"/>
    <!-- Language tags -->
    <xsl:include href="person-spreadsheet2tei-modules/language.xsl"/>
    <!-- Source tags -->
    <xsl:include href="person-spreadsheet2tei-modules/source.xsl"/>
    <!-- Personal name elements -->
    <xsl:include href="person-spreadsheet2tei-modules/names.xsl"/>
    <!-- Events or other date-related elements -->
    <xsl:include href="person-spreadsheet2tei-modules/events.xsl"/>
    
    <!-- Functions -->
    <xsl:include href="person-spreadsheet2tei-modules/functions.xsl"/> 
    
    <xsl:template match="/root">
        <xsl:apply-templates/>
        <xsl:call-template name="index"/>
    </xsl:template>
    
    <xsl:template name="main" match="row">
        <!-- Variables -->
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
        
        <!-- Creates a variable to use as the base for the xml:id for bib elements -->
        <!-- Should this be bibl- instead of bib? (If changed, need to change in places records too.) -->
        <xsl:variable name="bib-id">bib<xsl:value-of select="SRP_ID"/></xsl:variable>
        
        <xsl:variable name="bib-ids">
            <xsl:for-each select="$sourced-columns/*">
                
                    <xsl:variable name="name" select="name()"/>
                    <xsl:element name="{name()}"><xsl:value-of select="concat($bib-id, '-', replace($ids-base/*[contains(name(), $name)], 'a|b', ''))"/></xsl:element>
                
            </xsl:for-each>
        </xsl:variable>
                    
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
                <!-- Adds header -->
                <xsl:apply-templates select="SRP_ID"/>
                <text>
                    <body>
                        <listPerson>
                            <!-- Is there any additional way we should mark anonymous writers, other than in the format of the name? -->
                                <person xml:id="{$person-id}">
                                    <xsl:call-template name="names">
                                        <xsl:with-param name="name-ids" select="$name-ids"/>
                                        <xsl:with-param name="name-links" select="$name-links"/>
                                        <xsl:with-param name="bib-ids" select="$bib-ids"/>
                                        <xsl:with-param name="sort" select="$sort"/>
                                    </xsl:call-template>
                                    
                                    
                                    
                                    <!-- Adds VIAF URLs. -->
                                    <!--What will our VIAF source ID be? SRP?-->
                                    <idno type="URI">http://viaf.org/viaf/sourceID/SRP|<xsl:value-of select="SRP_ID"/></idno>
                                    
                                    <xsl:for-each select="URL[string-length(normalize-space()) > 0]">
                                        <idno type="URI">
                                            <xsl:value-of select="."/>
                                        </idno>
                                    </xsl:for-each>
                                  
                                  <!-- Adds date elements -->
                                    <xsl:for-each 
                                        select="*[ends-with(name(),'Floruit') or ends-with(name(),'DOB') or ends-with(name(),'DOD')]">
                                        <xsl:call-template name="events">
                                            <xsl:with-param name="bib-ids" select="$bib-ids"/>     
                                        </xsl:call-template>
                                    </xsl:for-each>
                                    <xsl:if test="exists(*[contains(name(), 'Reign') and string-length(normalize-space(node()))])">
                                        <listEvent>
                                            <xsl:for-each 
                                                select="*[ends-with(name(),'Reign')]">
                                                    <xsl:call-template name="events">
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
    </xsl:template>
    
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
    
    <xsl:template match="*"/>
    
</xsl:stylesheet>
