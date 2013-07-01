<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:syriaca="http://syriaca.org">
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="xml" />
    
    <xsl:variable name="n">
        <xsl:text>
</xsl:text>
    </xsl:variable>
    <xsl:variable name="s"><xsl:text> </xsl:text></xsl:variable>

    <xsl:function name="syriaca:normalizeYear" as="xs:string">
        <!-- The spreadsheet presents years normally, but datable attributes need 4-digit years -->
        <xsl:param name="year" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="starts-with($year,'-')">
                <xsl:value-of select="concat('-',syriaca:normalizeYear(substring($year,2)))"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="string-length($year) &gt; 3">
                        <xsl:value-of select="$year"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="syriaca:normalizeYear(concat('0',$year))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <xsl:for-each select="//row">
            <xsl:variable name="filename" select="concat(Place_ID,'.xml')"/>
            <xsl:result-document href="{$filename}" format="xml">
                <xsl:processing-instruction name="xml-model">
                    <xsl:text>href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
                </xsl:processing-instruction>
                <xsl:value-of select="$n"/>
                <xsl:processing-instruction name="xml-stylesheet">
                    <xsl:text>type="text/xsl" href="placedemo.xsl"</xsl:text>
                </xsl:processing-instruction>
                <xsl:value-of select="$n"/>
                <TEI
                    xml:lang="en"
                    xmlns:xi="http://www.w3.org/2001/XInclude"
                    xmlns:svg="http://www.w3.org/2000/svg"
                    xmlns:math="http://www.w3.org/1998/Math/MathML"
                    xmlns="http://www.tei-c.org/ns/1.0">
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title xml:lang="en"><xsl:value-of select="Name"/></title>
                                <sponsor>Syriaca.org: The Syriac Reference Portal</sponsor>
                                <funder>The National Endowment for the Humanities</funder>
                                <funder>The International Balzan Prize Foundation</funder>
                                <principal>David A. Michelson</principal>
                                <editor role="general-editor" ref="http://syriaca.org/editors.xml#tcarlson">Thomas A. Carlson</editor>
                                <editor role="general-editor" ref="http://syriaca.org/editors.xml#dmichelson">David A. Michelson</editor>
                                <editor role="creator" ref="http://syriaca.org/editors.xml#tcarlson">Thomas A. Carlson</editor>
                                <!-- Add Luk van Rompay for GEDSH?  Check with him -->
                                <xsl:if test="(Barsoum_English_Name != '' or Barsoum_Arabic_Name != '') and Place_ID &lt; 470">
                                    <editor role="creator" ref="http://syriaca.org/editors.xml#dmichelson">David A. Michelson</editor>
                                    <respStmt>
                                        <resp>Initial Barsoum entry creation by</resp>
                                        <name ref="http://syriaca.org/editors.xml#dmichelson">David A. Michelson</name>
                                    </respStmt>
                                </xsl:if>
                                <respStmt>
                                    <resp>Data merging, Pleiades and Wikipedia linking, and XML by</resp>
                                    <name ref="http://syriaca.org/editors.xml#tcarlson">Thomas A. Carlson</name>
                                </respStmt>
                                <xsl:if test="Barsoum_Syriac_Description != ''">
                                    <respStmt>
                                        <resp>Syriac description entry by</resp>
                                        <name ref="http://syriaca.org/editors.xml#raydin">Robert Aydin</name>
                                    </respStmt>
                                </xsl:if>
                                <xsl:if test="Barsoum_Arabic_Description != '' and Barsoum_Arabic_Page[number(text()) &gt; 511]">
                                    <respStmt>
                                        <resp>Arabic description entry by</resp>
                                        <name  ref="http://syriaca.org/editors.xml#rakhrass">Dayroyo Roger-Youssef Akhrass</name>
                                    </respStmt>
                                </xsl:if>
                                <xsl:if test="Wilmshurst_Names != ''">
                                    <respStmt>
                                        <resp>Wilmshurst index information entry by</resp>
                                        <name ref="http://syriaca.org/editors.xml#adavis">Anthony Davis</name>
                                    </respStmt>
                                </xsl:if>
                            </titleStmt>
                            <editionStmt>
                                <edition n="1.0"/>
                            </editionStmt>
                            <publicationStmt>
                                <authority>Syriaca.org: The Syriac Reference Portal</authority>
                                <idno type="URI">http://syriaca.org/place/<xsl:value-of select="Place_ID"/>/source</idno>
                                <availability>
                                    <licence target="http://creativecommons.org/licenses/by/3.0/">
                                        Distributed under a Creative Commons Attribution 3.0 Unported License
                                    </licence>
                                </availability>
                                <date><xsl:value-of select="current-date()"></xsl:value-of></date>
                            </publicationStmt>
                            <sourceDesc>
                                <p>Born digital.</p>
                            </sourceDesc>
                        </fileDesc>
                        <encodingDesc>
                            <editorialDecl>
                                <p>This record created following the Syriaca.org guidelines. Documentation available at: <ref target="http://syriaca.org/documentation">http://syriaca.org/documentation</ref>.</p>
                                <p>The capitalization of names from GEDSH (<idno type="URI">http://syriaca.org/bibl/1</idno>) was normalized (i.e. names in ALL-CAPS were replaced by Proper-noun capitalization).</p>
                                <p>The unchanging parts of alternate names from Barsoum (<idno type="URI">http://syriaca.org/bibl/2</idno>, <idno type="URI">http://syriaca.org/bibl/3</idno>, or <idno type="URI">http://syriaca.org/bibl/4</idno>) have been supplied to each alternate.</p>
                                <p>Names from the English translation of Barsoum (<idno type="URI">http://syriaca.org/bibl/4</idno>) were put in sentence word order rather than fronting a dictionary headword.  Any commas in the Barsoum name in English were removed.</p>
                                <p>The <gi>state</gi> element of @type="existence" indicates the period for which this place was in use as a place of its indicated type (e.g. an inhabited settlement, a functioning monastery or church, an administrative province).  Natural features always in existence have no <gi>state</gi> element of @type="existence".</p>
                            </editorialDecl>
                            <classDecl>
                                <taxonomy>
                                    <category xml:id="syriaca-headword">
                                        <catDesc>The form of a name preferred by Syriaca.org</catDesc>
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
                            </langUsage>
                        </profileDesc>
                        <revisionDesc>
                            <change who="http://syriaca.org/editors.xml#tcarlson"><xsl:attribute name="when"><xsl:value-of select="current-date()"></xsl:value-of></xsl:attribute>CREATED: place</change>
                        </revisionDesc>
                    </teiHeader>
                    <text>
                        <body>
                            <listPlace>
                                <place>
                                    <xsl:attribute name="xml:id">place-<xsl:value-of select="Place_ID"/></xsl:attribute>
                                    <xsl:attribute name="type"><xsl:value-of select="Category"/></xsl:attribute>
                                    
                                    <!-- determine which sources will need to be cited -->
                                    <xsl:variable name="bib-prefix">bib<xsl:value-of select="Place_ID"/>-</xsl:variable>
                                    <xsl:variable name="sources" as="xs:string*">
                                        <xsl:if test="GEDSH_Name != ''">
                                            <xsl:sequence select="('GEDSH')"/>
                                        </xsl:if>
                                        <xsl:if test="Barsoum_Syriac_Name != ''">
                                            <xsl:sequence select="('Barsoum-Syriac')"/>
                                        </xsl:if>
                                        <xsl:if test="Barsoum_Arabic_Name != ''">
                                            <xsl:sequence select="('Barsoum-Arabic')"/>
                                        </xsl:if>
                                        <xsl:if test="Barsoum_English_Name != ''">
                                            <xsl:sequence select="('Barsoum-English')"/>
                                        </xsl:if>
                                        <xsl:if test="CBSC_Keyword != ''">
                                            <xsl:sequence select="('CBSC-Keyword')"/>
                                        </xsl:if>
                                        <xsl:if test="Wilmshurst_Names != ''">
                                            <xsl:sequence select="('Wilmshurst')"/>
                                        </xsl:if>
                                    </xsl:variable>
                                    <!-- therefore the xml:id of the <bibl> element representing a source is $bib-prefix followed by the index of the source name in the $sources sequence -->
                                    <!-- and the citation format is #<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'GEDSH')"/> for GEDSH, etc. -->
                                    
                                    <!-- DEAL WITH PLACE NAMES -->
                                    <!-- create one <placeName> per name form, with @source citing multiple sources as necessary -->
                                    <!-- to do that, first we need to create a sequence of all name forms, then remove duplicates -->
                                    <xsl:variable name="names-with-duplicates" as="xs:string*">
                                        <xsl:sequence select="(Name)"/>
                                        <xsl:if test="GEDSH_Name != ''">
                                            <xsl:sequence select="tokenize(GEDSH_Name,'/')"/>
                                        </xsl:if>
                                        <xsl:if test="Barsoum_Syriac_Name != ''">
                                            <xsl:sequence select="(Barsoum_Syriac_Name)"/>
                                        </xsl:if>
                                        <xsl:if test="Barsoum_Syriac_Name_Vocalized != ''">
                                            <xsl:sequence select="tokenize(Barsoum_Syriac_Name_Vocalized,'.\s')"/>
                                        </xsl:if>
                                        <xsl:if test="Barsoum_Arabic_Name != ''">
                                            <xsl:sequence select="tokenize(Barsoum_Arabic_Name,'،\s')"/>
                                        </xsl:if>
                                        <xsl:if test="Barsoum_English_Name != ''">
                                            <xsl:sequence select="tokenize(Barsoum_English_Name,',\s')"/>
                                        </xsl:if>
                                        <xsl:if test="CBSC_Keyword != ''">
                                            <xsl:sequence select="tokenize(CBSC_Keyword,'; ')"/>
                                        </xsl:if>
                                        <xsl:if test="Wilmshurst_Names != ''">
                                            <xsl:sequence select="tokenize(Wilmshurst_Names,'; ')"/>
                                        </xsl:if>
                                    </xsl:variable>
                                    <xsl:variable name="names" as="xs:string*"><xsl:sequence select="distinct-values($names-with-duplicates)"/></xsl:variable>
                                    
                                    <!-- for each name, we create a <placeName> element -->
                                    <xsl:variable name="this_row" select="."/>    <!-- Used to permit reference to the current row within nested for-each statements -->
                                    <xsl:variable name="name-prefix">name<xsl:value-of select="Place_ID"/>-</xsl:variable>
                                    <xsl:for-each select="$names">
                                        <placeName>
                                            <xsl:attribute name="xml:id"><xsl:value-of select="$name-prefix"/><xsl:value-of select="index-of($names,.)"/></xsl:attribute>
                                            
                                            <!-- needs @xml:lang: options are 'ar', 'syr', 'syr-Syrj', or default 'en' -->
                                            <xsl:attribute name="xml:lang">
                                                <xsl:choose>
                                                    <xsl:when test="$this_row/Barsoum_Syriac_Name = .">syr</xsl:when>
                                                    <xsl:when test="exists(index-of(tokenize($this_row/Barsoum_Syriac_Name_Vocalized,'.\s'), .))">syr-Syrj</xsl:when>  <!-- when "vocalized" form equals unvocalized, use 'syr' -->
                                                    <xsl:when test="exists(index-of(tokenize($this_row/Barsoum_Arabic_Name,'،\s'), .))">ar</xsl:when>
                                                    <xsl:otherwise>en</xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                            
                                            <!-- if it is the <Name> value or the <Barsoum_Syriac_Name> value, then it needs a @syriaca-tags attribute to indicate it is a Syriaca.org authorized form -->
                                            <xsl:if test="$this_row/Name = . or $this_row/Barsoum_Syriac_Name = .">
                                                <xsl:attribute name="syriaca-tags">#syriaca-headword</xsl:attribute>
                                            </xsl:if>
                                            
                                            <!-- if it is from a print source, it needs a @source attribute -->
                                            <!-- to achieve space-separated xml:id references, we create a sequence of references and then print it -->
                                            <xsl:if test="exists(index-of(tokenize($this_row/GEDSH_Name,'/'),.)) or exists(index-of(tokenize($this_row/Barsoum_Syriac_Name_Vocalized,'.\s'), .)) or exists(index-of(tokenize($this_row/Barsoum_Arabic_Name,'،\s'), .)) or exists(index-of(tokenize($this_row/Barsoum_English_Name,',\s'), .)) or exists(index-of(tokenize($this_row/CBSC_Keyword,'; '),.)) or exists(index-of(tokenize($this_row/Wilmshurst_Names,'; '), .))">
                                                <xsl:variable name="this_source_attribute" as="xs:string*">
                                                    <xsl:if test="exists(index-of(tokenize($this_row/GEDSH_Name,'/'),.))">
                                                        <xsl:sequence select="(concat('#',$bib-prefix,index-of($sources,'GEDSH')))"/>
                                                    </xsl:if>
                                                    <xsl:if test="exists(index-of(tokenize($this_row/Barsoum_Syriac_Name_Vocalized,'.\s'), .))">
                                                        <xsl:sequence select="(concat('#',$bib-prefix,index-of($sources,'Barsoum-Syriac')))"/>
                                                    </xsl:if>
                                                    <xsl:if test="exists(index-of(tokenize($this_row/Barsoum_Arabic_Name,'،\s'), .))">
                                                        <xsl:sequence select="(concat('#',$bib-prefix,index-of($sources,'Barsoum-Arabic')))"/>
                                                    </xsl:if>
                                                    <xsl:if test="exists(index-of(tokenize($this_row/Barsoum_English_Name,',\s'), .))">
                                                        <xsl:sequence select="(concat('#',$bib-prefix,index-of($sources,'Barsoum-English')))"/>
                                                    </xsl:if>
                                                    <xsl:if test="exists(index-of(tokenize($this_row/CBSC_Keyword,'; '), .))">
                                                        <xsl:sequence select="(concat('#',$bib-prefix,index-of($sources,'CBSC-Keyword')))"/>
                                                    </xsl:if>
                                                    <xsl:if test="exists(index-of(tokenize($this_row/Wilmshurst_Names,'; '), .))">
                                                        <xsl:sequence select="(concat('#',$bib-prefix,index-of($sources,'Wilmshurst')))"/>
                                                    </xsl:if>
                                                </xsl:variable>
                                                <xsl:attribute name="source"><xsl:value-of select="$this_source_attribute"/></xsl:attribute>
                                            </xsl:if>

                                            <!-- DEPRECATED: we no longer use @corresp for corresponding place names -->
                                            <!-- finally, if it is a Barsoum name, it needs a @corresp attribute pointing to the other Barsoum names -->
                                            <!-- NOTE: this @corresp generator DOES NOT WORK wherever there is more than one Barsoum name -->
                                            <!-- <xsl:if test="$this_row/Barsoum_Syriac_Name_Vocalized = . or $this_row/Barsoum_Arabic_Name = . or $this_row/Barsoum_English_Name = .">
                                                <xsl:variable name="this_corresp_attribute" as="xs:string*">
                                                    <xsl:choose>
                                                        <xsl:when test="$this_row/Barsoum_Syriac_Name_Vocalized = .">
                                                            <xsl:sequence select="(concat('#',$name-prefix,index-of($names,$this_row/Barsoum_Arabic_Name)),concat('#',$name-prefix,index-of($names,$this_row/Barsoum_English_Name)))"></xsl:sequence>
                                                        </xsl:when>
                                                        <xsl:when test="$this_row/Barsoum_Arabic_Name = .">
                                                            <xsl:sequence select="(concat('#',$name-prefix,index-of($names,$this_row/Barsoum_Syriac_Name_Vocalized)),concat('#',$name-prefix,index-of($names,$this_row/Barsoum_English_Name)))"></xsl:sequence>
                                                        </xsl:when>
                                                        <xsl:when test="$this_row/Barsoum_English_Name = .">
                                                            <xsl:sequence select="(concat('#',$name-prefix,index-of($names,$this_row/Barsoum_Syriac_Name_Vocalized)),concat('#',$name-prefix,index-of($names,$this_row/Barsoum_Arabic_Name)))"></xsl:sequence>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </xsl:variable> -->
                                                <!-- but some Barsoum names might be missing from the record, so figure out which and omit -->
                                                <!-- a missing Barsoum name will correspond to a $this_corresp_attribute entry ending in '-' -->
                                                <!-- <xsl:choose>
                                                    <xsl:when test="ends-with($this_corresp_attribute[1],'-') and ends-with($this_corresp_attribute[2],'-')"> -->
                                                        <!-- NO @corresp attribute, because no corresponding Barsoum names exist -->
                                                    <!-- </xsl:when>
                                                    <xsl:when test="ends-with($this_corresp_attribute[1],'-')">
                                                        <xsl:attribute name="corresp"><xsl:value-of select="$this_corresp_attribute[2]"/></xsl:attribute>
                                                    </xsl:when>
                                                    <xsl:when test="ends-with($this_corresp_attribute[2],'-')">
                                                        <xsl:attribute name="corresp"><xsl:value-of select="$this_corresp_attribute[1]"/></xsl:attribute>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:attribute name="corresp"><xsl:value-of select="$this_corresp_attribute"/></xsl:attribute>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:if> -->
                                            
                                            <!-- finally output the value of the <placeName> element, the name form itself -->
                                            <xsl:value-of select="."/>
                                        </placeName>
                                    </xsl:for-each>
                                    
                                    <!-- old method, just create a separate <placeName> for each source -->
                                    <!-- <placeName>
                                        <xsl:attribute name="xml:lang">en</xsl:attribute>
                                        <xsl:attribute name="resp">http://syriaca.org</xsl:attribute>
                                        <xsl:value-of select="Name"/>
                                    </placeName>
                                    <xsl:if test="GEDSH_Name != ''">
                                        <placeName>
                                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                                            <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'GEDSH')"/></xsl:attribute>
                                            <xsl:value-of select="GEDSH_Name"/>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Barsoum_Syriac_Name != ''"> 
                                        <placeName>
                                            <xsl:attribute name="xml:lang">syr</xsl:attribute>
                                            <xsl:attribute name="resp">http://syriaca.org</xsl:attribute>
                                            <xsl:value-of select="Barsoum_Syriac_Name"/>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Barsoum_Syriac_Name_Vocalized != ''">
                                        <placeName>
                                            <xsl:attribute name="xml:lang">syr-Syrj</xsl:attribute>
                                            <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-Syriac')"/></xsl:attribute>
                                            <xsl:value-of select="Barsoum_Syriac_Name_Vocalized"/>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Barsoum_Arabic_Name != ''"> <!- FUTURE: split alternate names on او (affects 28 entries) ->
                                        <placeName>
                                            <xsl:attribute name="xml:lang">ar</xsl:attribute>
                                            <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-Arabic')"/></xsl:attribute>
                                            <xsl:value-of select="Barsoum_Arabic_Name"/>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="Barsoum_English_Name != ''">
                                        <placeName>
                                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                                            <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-English')"/></xsl:attribute>
                                            <xsl:value-of select="Barsoum_English_Name"/>
                                        </placeName>
                                    </xsl:if>
                                    <xsl:if test="CBSC_Keyword != ''">
                                        <placeName>
                                            <xsl:attribute name="xml:lang">en</xsl:attribute>
                                            <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'CBSC-Keyword')"/></xsl:attribute>
                                            <xsl:value-of select="CBSC_Keyword"/>
                                        </placeName>
                                    </xsl:if>
                                    -->
                                    
                                    <!-- insert the descriptions, starting with the abstract, which should always be present -->
                                    <desc>
                                        <xsl:attribute name="xml:id">abstract-en-<xsl:value-of select="Place_ID"/></xsl:attribute>
                                        <xsl:value-of select="Abstract"/>
                                    </desc>
                                    <xsl:if test="GEDSH_Entry_Heading != ''">
                                        <desc xml:lang="en">
                                            <quote>
                                                <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'GEDSH')"/></xsl:attribute>
                                                <xsl:value-of select="GEDSH_Entry_Heading"/>
                                            </quote>
                                        </desc>
                                    </xsl:if>
                                    <xsl:if test="Barsoum_Syriac_Description != ''">
                                        <desc xml:lang="syr-Syrj">
                                            <quote>
                                                <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-Syriac')"/></xsl:attribute>
                                                <xsl:value-of select="Barsoum_Syriac_Description"/>
                                            </quote>
                                        </desc>
                                    </xsl:if>
                                    <xsl:if test="Barsoum_Arabic_Description != ''">
                                        <desc xml:lang="ar">
                                            <quote>
                                                <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-Arabic')"/></xsl:attribute>
                                                <xsl:value-of select="Barsoum_Arabic_Description"/>
                                            </quote>
                                        </desc>
                                    </xsl:if>
                                    <xsl:if test="Barsoum_English_Description != ''">
                                        <desc xml:lang="en">
                                            <quote>
                                                <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-English')"/></xsl:attribute>
                                                <xsl:value-of select="Barsoum_English_Description"/>
                                            </quote>
                                        </desc>
                                    </xsl:if>
                                    
                                    <!-- deal with GPS coordinates if we have them -->
                                    <xsl:if test="Latitude != '' and Longitude != ''">
                                        <location type="gps">
                                            <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'GEDSH')"/></xsl:attribute>
                                            <geo><xsl:value-of select="Latitude"/><xsl:value-of select="$s"></xsl:value-of><xsl:value-of select="Longitude"/></geo>
                                        </location>
                                    </xsl:if>
                                    
                                    <!-- Deal with nested Wilmshurst locations -->
                                    <xsl:if test="Containing_Town != '' or Containing_District != '' or Containing_Region != ''">
                                        <location type="geopolitical">
                                            <xsl:attribute name="source">#<xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Wilmshurst')"/></xsl:attribute>
                                            <xsl:if test="Containing_Region != ''">
                                                <region>
                                                    <xsl:variable name="this_region"><xsl:value-of select="Containing_Region"/></xsl:variable>
                                                    <xsl:attribute name="ref">http://syriaca.org/place/<xsl:value-of select="substring-after(Containing_Region,'-')"/></xsl:attribute>
                                                    <xsl:value-of select="substring-before(Containing_Region,'-')"/>
                                                </region>
                                            </xsl:if>
                                            <xsl:if test="Containing_District != ''">
                                                <region>
                                                    <xsl:variable name="this_district"><xsl:value-of select="Containing_District"/></xsl:variable>
                                                    <xsl:attribute name="ref">http://syriaca.org/place/<xsl:value-of select="substring-after(Containing_District,'-')"/></xsl:attribute>
                                                    <xsl:value-of select="substring-before(Containing_District,'-')"/>
                                                </region>
                                            </xsl:if>
                                            <xsl:if test="Containing_Town != ''">
                                                <settlement>
                                                    <xsl:variable name="this_town"><xsl:value-of select="Containing_Town"/></xsl:variable>
                                                    <xsl:attribute name="ref">http://syriaca.org/place/<xsl:value-of select="substring-after(Containing_Town,'-')"/></xsl:attribute>
                                                    <xsl:value-of select="substring-before(Containing_Town,'-')"/>
                                                </settlement>
                                            </xsl:if>
                                        </location>
                                    </xsl:if>
                                    
                                    <!-- spreadsheet does not have relative locations, events, or confessions, so we can ignore those -->
                                    
                                    <!-- create existence <state> element if type is not a natural feature -->
                                    <xsl:if test="Category != 'river' and Category != 'open-water' and Category != 'mountain'">
                                        <state type="existence">
                                            <xsl:if test="Existence_From != ''">
                                                <xsl:attribute name="from"><xsl:value-of select="syriaca:normalizeYear(Existence_From)"/></xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="Existence_To != ''">
                                                <xsl:attribute name="to"><xsl:value-of select="syriaca:normalizeYear(Existence_To)"/></xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="Existence_NotBefore != ''">
                                                <xsl:attribute name="notBefore"><xsl:value-of select="syriaca:normalizeYear(Existence_NotBefore)"/></xsl:attribute>
                                            </xsl:if>
                                            <xsl:if test="Existence_NotAfter != ''">
                                                <xsl:attribute name="notAfter"><xsl:value-of select="syriaca:normalizeYear(Existence_NotAfter)"/></xsl:attribute>
                                            </xsl:if>
                                        </state>
                                    </xsl:if>
                                    
                                    <!-- Insert the ID numbers for Syriaca.org and, if they exist, for Pleiades, Wikipedia, and DBpedia -->
                                    <idno type="URI">http://syriaca.org/place/<xsl:value-of select="Place_ID"/></idno>
                                    <xsl:if test="Pleiades_URI != ''">
                                        <idno type="URI"><xsl:value-of select="Pleiades_URI"/></idno>
                                    </xsl:if>
                                    <xsl:if test="Wikipedia_URI != ''">
                                        <xsl:for-each select="tokenize(Wikipedia_URI,'\s\|\s')">
                                            <idno type="URI"><xsl:value-of select="current()"/></idno>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <xsl:if test="DBpedia_URI != ''">
                                        <idno type="URI"><xsl:value-of select="DBpedia_URI"/></idno>
                                    </xsl:if>
                                    
                                    <!-- Insert the <bibl> elements -->
                                    <xsl:if test="exists(index-of($sources,'GEDSH'))">
                                        <bibl>
                                            <xsl:attribute name="xml:id"><xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'GEDSH')"/></xsl:attribute>
                                            <title xml:lang="en">The Gorgias Encyclopedic Dictionary of the Syriac Heritage</title>
                                            <ptr target="http://syriaca.org/bibl/1"/>
                                            <xsl:if test="GEDSH_Page != ''">
                                                <citedRange unit="pp"><xsl:value-of select="GEDSH_Page"/></citedRange>
                                            </xsl:if>
                                            <xsl:if test="GEDSH_Maps != ''">
                                                <citedRange unit="maps"><xsl:value-of select="concat('Map ',GEDSH_Maps)"/></citedRange>
                                            </xsl:if>
                                        </bibl>
                                    </xsl:if>
                                    <xsl:if test="exists(index-of($sources,'Barsoum-Syriac'))">
                                        <bibl>
                                            <xsl:attribute name="xml:id"><xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-Syriac')"/></xsl:attribute>
                                            <title xml:lang="syr">ܒܪ̈ܘܠܐ ܒܕܝܪ̈ܐ ܕܥܠ ܡܪܕܘܬ ܝܘܠܦܢ̈ܐ ܣܘܪ̈ܝܝܐ ܗܕܝܪ̈ܐ</title>
                                            <ptr target="http://syriaca.org/bibl/3"/>
                                            <citedRange unit="pp"><xsl:value-of select="Barsoum_Syriac_Page"/></citedRange>
                                        </bibl>
                                    </xsl:if>
                                    <xsl:if test="exists(index-of($sources,'Barsoum-Arabic'))">
                                        <bibl>
                                            <xsl:attribute name="xml:id"><xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-Arabic')"/></xsl:attribute>
                                            <title xml:lang="ar">كتاب اللؤلؤ المنثور في تاريخ العلوم والأداب السريانية</title>
                                            <ptr target="http://syriaca.org/bibl/2"/>
                                            <citedRange unit="pp"><xsl:value-of select="Barsoum_Arabic_Page"/></citedRange>
                                        </bibl>
                                    </xsl:if>
                                    <xsl:if test="exists(index-of($sources,'Barsoum-English'))">
                                        <bibl>
                                            <xsl:attribute name="xml:id"><xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Barsoum-English')"/></xsl:attribute>
                                            <title xml:lang="en">The Scattered Pearls: A History of Syriac Literature and Sciences</title>
                                            <ptr target="http://syriaca.org/bibl/4"/>
                                            <citedRange unit="pp"><xsl:value-of select="Barsoum_English_Page"/></citedRange>
                                        </bibl>
                                    </xsl:if>
                                    <xsl:if test="exists(index-of($sources,'CBSC-Keyword'))">
                                        <bibl>
                                            <xsl:attribute name="xml:id"><xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'CBSC-Keyword')"/></xsl:attribute>
                                            <title xml:lang="en">The Comprehensive Bibliography on Syriac Christianity</title>
                                            <ptr target="http://syriaca.org/bibl/5"/>
                                        </bibl>
                                    </xsl:if>
                                    <xsl:if test="exists(index-of($sources,'Wilmshurst'))">
                                        <bibl>
                                            <xsl:attribute name="xml:id"><xsl:value-of select="$bib-prefix"/><xsl:value-of select="index-of($sources,'Wilmshurst')"/></xsl:attribute>
                                            <author>David Wilmshurst</author>
                                            <title xml:lang="en">The Ecclesiastical Organisation of the Church of the East, 1318-1913</title>
                                            <citedRange unit="pp"><xsl:value-of select="Wilmshurst_Pages"/></citedRange>
                                            <ptr target="http://syriaca.org/bibl/9"/>
                                        </bibl>
                                    </xsl:if>
                                </place>                                
                            </listPlace>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>