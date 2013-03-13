<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd"
    xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output method="text"/>
    <xsl:output method="xml" indent="yes" name="xml"/>
    <xsl:output method="html" indent="yes" name="html"/>

    <xsl:template match="/root">

        <!-- Create an EAC file for each row. -->
        <xsl:for-each select="row">
            <!-- TO DO: Make sure to filter out non-authors. -->
            <!-- Write the file to the subdirectory "output2" and give it the name of the record's SRP ID. -->
            <xsl:variable name="filename" select="concat('output2/',SRP_ID,'.xml')"/>
            <xsl:result-document href="{$filename}" format="xml">
                <eac-cpf xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd"
                    xmlns="urn:isbn:1-931666-33-4" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <control>
                        <recordId>
                            <xsl:value-of select="SRP_ID"/>
                        </recordId>
                        <xsl:if test="string-length(normalize-space(VIAF_URL)) > 0">
                            <!-- This needs a forEach statement once we have multiple VIAF URL's to include. -->
                            <otherRecordId>
                                <xsl:value-of select="VIAF_URL"/>/
                            </otherRecordId>
                        </xsl:if>
                        <maintenanceStatus>new</maintenanceStatus>
                        <maintenanceAgency>
                            <agencyName>Syriac Reference Portal</agencyName>
                        </maintenanceAgency>
                        <!-- localTypeDeclaration needs tweaking. -->                        
                        <localTypeDeclaration>
                            <abbreviation>syriaca</abbreviation>
                            <citation xlink:href="http://syriaca.org/vocab/eac/localType" xlink:type="simple">Some sort of citation</citation>
                            <descriptiveNote>
                                <p>Some sort of description.</p>
                            </descriptiveNote>
                        </localTypeDeclaration>
                        <maintenanceHistory>
                            <maintenanceEvent>
                                <eventType>created</eventType>
                                <eventDateTime>
                                    <xsl:attribute name="standardDateTime"
                                        select="current-dateTime()"> </xsl:attribute>
                                </eventDateTime>
                                <agentType>machine</agentType>
                                <agent>Syriac Reference Portal</agent>
                            </maintenanceEvent>
                        </maintenanceHistory>
                        <sources>
                            <source xlink:href="http://syriaca.org">
                                <sourceEntry xml:id="syriaca.org">The Syriac Reference Portal
                                    (syriaca.org)</sourceEntry>
                            </source>
                            <xsl:if test="string-length(normalize-space(GEDSH_Full)) > 0">
                                <!-- Need to also test for "None," etc. or remove from source data -->
                                <source xml:id="GEDSH">
                                    <sourceEntry>Gorgias Encyclopedic Dictionary of the Syriac
                                        Heritage</sourceEntry>
                                    <descriptiveNote>
                                        <p>Entry <xsl:value-of select="GEDSH_Entry_Num"/></p>
                                    </descriptiveNote>
                                </source>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(Barsoum_Sy_NV_Full)) > 0">
                                <source xml:id="Barsoum-SY">
                                    <sourceEntry>Barsoum (Syriac)</sourceEntry>
                                    <descriptiveNote>
                                        <p>Page <xsl:value-of select="Barsoum_Sy_Page_Num"/></p>
                                    </descriptiveNote>
                                </source>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(Barsoum_Ar_Full)) > 0">
                                <source xml:id="Barsoum-AR">
                                    <sourceEntry>Barsoum (Arabic)</sourceEntry>
                                    <descriptiveNote>
                                        <p>Page <xsl:value-of select="Barsoum_Ar_Page_Num"/></p>
                                    </descriptiveNote>
                                </source>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(Barsoum_En_Full)) > 0">
                                <source xml:id="Barsoum-EN">
                                    <sourceEntry>Barsoum (English)</sourceEntry>
                                    <descriptiveNote>
                                        <p>
                                            <!-- Is the entry num the same for all versions of Barsoum or does it apply to English only? -->
                                            <xsl:if test="string-length(normalize-space(Barsoum_En_Entry_Num)) > 0">
                                                Entry <xsl:value-of select="Barsoum_En_Entry_Num"/>, 
                                            </xsl:if>
                                                Page <xsl:value-of select="Barsoum_En_Page_Num"/></p>
                                    </descriptiveNote>
                                </source>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Full)) > 0">
                                <source xml:id="Abdisho-YDQ">
                                    <sourceEntry>Abdisho (YDQ)</sourceEntry>
                                    <descriptiveNote>
                                        <p>Page <xsl:value-of select="Abdisho_YdQ_Sy_Page_Num"/></p>
                                    </descriptiveNote>
                                </source>
                            </xsl:if>
                            <xsl:if
                                test="string-length(normalize-space(Abdisho_BO_Sy_NV_Full)) > 0">
                                <!-- Need OR test for vocalized also -->
                                <source xml:id="Abdisho-BO">
                                    <sourceEntry>Abdisho (BO III)</sourceEntry>
                                    <descriptiveNote>
                                        <p>Page <xsl:value-of select="Abdisho_BO_Sy_Page_Num"/></p>
                                    </descriptiveNote>
                                </source>
                            </xsl:if>
                            <xsl:if test="string-length(normalize-space(CBSC_En)) > 0">
                                <source xlink:href="http://www.csc.org.il/db/db.aspx?db=SB"
                                    xml:id="CBSC">
                                    <sourceEntry>Comprehensive Bibliography of Syriac
                                        Christianity</sourceEntry>
                                </source>
                            </xsl:if>
                        </sources>
                    </control>
                    <cpfDescription>
                        <identity>
                            <entityId>http://syriaca.org/person/<xsl:value-of select="SRP_ID"/></entityId>
                            <!-- This needs a forEach statement once we have multiple VIAF URL's to include. -->
                            <entityId><xsl:value-of select="VIAF_URL"/></entityId>
                            <entityType>person</entityType>
                            <!-- Need to create columns in source data for syriaca.org authorized forms. -->
                            <!-- Give GEDSH name in decomposed name parts. -->
                            <xsl:if
                                test="string-length(normalize-space(concat(GEDSH_Given,GEDSH_Family,GEDSH_Titles))) > 0">
                                <nameEntry localType="#GEDSH" scriptCode="Latn"
                                    transliteration="GEDSH" xml:lang="eng">
                                    <xsl:if
                                        test="string-length(normalize-space(GEDSH_Given)) > 0">
                                        <part localType="http://syriaca.org/vocab/eac/localType#given">
                                            <xsl:value-of select="GEDSH_Given"/>
                                        </part>
                                    </xsl:if>
                                    <xsl:if
                                        test="string-length(normalize-space(GEDSH_Family)) > 0">
                                        <part localType="http://syriaca.org/vocab/eac/localType#family">
                                            <xsl:value-of select="GEDSH_Family"/>
                                        </part>
                                    </xsl:if>
                                    <xsl:if test="string-length(normalize-space(GEDSH_Titles)) > 0">
                                        <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                            <xsl:value-of select="GEDSH_Titles"/>
                                        </part>
                                    </xsl:if>
                                    <alternativeForm>syriaca.org</alternativeForm>
                                </nameEntry>
                            </xsl:if>
                            <!-- Give GEDSH name in a single name part. -->
                            <xsl:if test="string-length(normalize-space(GEDSH_Full)) > 0">
                                <nameEntry localType="#GEDSH" scriptCode="Latn"
                                    transliteration="GEDSH" xml:lang="eng">
                                    <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                        <xsl:value-of select="GEDSH_Full"/>
                                    </part>
                                    <alternativeForm>syriaca.org</alternativeForm>
                                </nameEntry>
                            </xsl:if>
                            <!-- Give Barsoum names as parallel name entries in decomposed name parts. -->
                            <!-- Test whether input data has the names split. -->
                            <xsl:if
                                test="string-length(normalize-space(concat(Barsoum_En_Given,Barsoum_En_Family,Barsoum_En_Titles,Barsoum_Ar_Given,Barsoum_Ar_Family,Barsoum_Ar_Titles,Barsoum_Sy_NV_Given,Barsoum_Sy_NV_Family,Barsoum_Syriac_NV_Titles))) > 0">
                                <nameEntryParallel localType="http://syriaca.org/vocab/eac/localType#Barsoum">
                                    <!-- Test for split English names. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Barsoum_En_Given,Barsoum_En_Family,Barsoum_En_Titles))) > 0">
                                        <nameEntry scriptCode="Latn"
                                            transliteration="Barsoum-Anglicized" xml:lang="eng"
                                            localType="#Barsoum-EN">
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_En_Given)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                  <xsl:value-of select="Barsoum_En_Given"
                                                  />
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_En_Family)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                  <xsl:value-of
                                                  select="Barsoum_En_Family"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_En_Titles)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                  <xsl:value-of select="Barsoum_En_Titles"/>
                                                </part>
                                            </xsl:if>
                                        </nameEntry>
                                    </xsl:if>
                                    <!-- Test for split Arabic names. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Barsoum_Ar_Given,Barsoum_Ar_Family,Barsoum_Ar_Titles))) > 0">
                                        <nameEntry scriptCode="Arab" xml:lang="ara"
                                            localType="#Barsoum-AR">
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Ar_Given)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                  <xsl:value-of select="Barsoum_Ar_Given"
                                                  />
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Ar_Family)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                  <xsl:value-of select="Barsoum_Ar_Family"
                                                  />
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Ar_Titles)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                  <xsl:value-of select="Barsoum_Ar_Titles"/>
                                                </part>
                                            </xsl:if>
                                        </nameEntry>
                                    </xsl:if>
                                    <!-- Test for split non-vocalized Syriac names. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Barsoum_Sy_NV_Given,Barsoum_Sy_NV_Family,Barsoum_Syriac_NV_Titles))) > 0">
                                        <nameEntry scriptCode="Syrc" xml:lang="syr"
                                            localType="#Barsoum-SY">
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Sy_NV_Given)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                  <xsl:value-of
                                                  select="Barsoum_Sy_NV_Given"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Sy_NV_Family)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                  <xsl:value-of
                                                  select="Barsoum_Sy_NV_Family"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Syriac_NV_Titles)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                  <xsl:value-of select="Barsoum_Syriac_NV_Titles"/>
                                                </part>
                                            </xsl:if>
                                        </nameEntry>
                                    </xsl:if>
                                    <!-- Test for split vocalized Syriac names. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Barsoum_Sy_V_Given,Barsoum_Sy_V_Family,Barsoum_Sy_V_Titles))) > 0">
                                        <nameEntry scriptCode="Syrj" xml:lang="syr"
                                            localType="#Barsoum-SY">
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Sy_V_Given)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                  <xsl:value-of
                                                  select="Barsoum_Sy_V_Given"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Sy_V_Family)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                  <xsl:value-of
                                                  select="Barsoum_Sy_V_Family"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Barsoum_Sy_V_Titles)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                  <xsl:value-of select="Barsoum_Sy_V_Titles"/>
                                                </part>
                                            </xsl:if>
                                        </nameEntry>
                                    </xsl:if>
                                    <alternativeForm>syriaca.org</alternativeForm>
                                </nameEntryParallel>
                            </xsl:if>
                            <!-- Give Barsoum names as parallel name entries in single name parts. -->
                            <!-- Test whether input data has the names. -->
                            <xsl:if
                                test="string-length(normalize-space(concat(Barsoum_En_Full,Barsoum_Ar_Full,Barsoum_Sy_NV_Full))) > 0">
                                <nameEntryParallel localType="http://syriaca.org/vocab/eac/localType#Barsoum">
                                    <!-- Test for English name. -->
                                    <xsl:if test="string-length(normalize-space(Barsoum_En_Full)) > 0">
                                        <nameEntry scriptCode="Latn"
                                            transliteration="Barsoum-Anglicized" xml:lang="eng"
                                            localType="#Barsoum-EN">
                                            <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                                <xsl:value-of select="Barsoum_En_Full"/>
                                            </part>
                                        </nameEntry>
                                    </xsl:if>
                                    <!-- Test for Arabic name. -->
                                    <xsl:if test="string-length(normalize-space(Barsoum_Ar_Full)) > 0">
                                        <nameEntry scriptCode="Arab" xml:lang="ara"
                                            localType="#Barsoum-AR">
                                            <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                                <xsl:value-of select="Barsoum_Ar_Full"/>
                                            </part>
                                        </nameEntry>
                                    </xsl:if>
                                    <!-- Test for non-vocalized Syriac name. -->
                                    <xsl:if
                                        test="string-length(normalize-space(Barsoum_Sy_NV_Full)) > 0">
                                        <nameEntry scriptCode="Syrc" xml:lang="syr"
                                            localType="#Barsoum-SY">
                                            <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                                <xsl:value-of select="Barsoum_Sy_NV_Full"/>
                                            </part>
                                        </nameEntry>
                                    </xsl:if>
                                    <!-- Test for vocalized Syriac name. -->
                                    <xsl:if test="string-length(normalize-space(Barsoum_Sy_V_Full)) > 0">
                                        <nameEntry scriptCode="Syrj" xml:lang="syr"
                                            localType="#Barsoum-SY">
                                            <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                                <xsl:value-of select="Barsoum_Sy_V_Full"/>
                                            </part>
                                        </nameEntry>
                                    </xsl:if>
                                    <alternativeForm>syriaca.org</alternativeForm>
                                </nameEntryParallel>
                            </xsl:if>
                            <!-- Give Abdisho YdQ names as parallel name entries. -->
                            <xsl:choose>
                                <!-- Test whether both vocalized and non-vocalized are present, and if so use nameEntryParallel. -->
                                <xsl:when
                                    test="(string-length(normalize-space(Abdisho_YdQ_Sy_NV_Full)) > 0) and (string-length(normalize-space(Abdisho_YdQ_Sy_V_Full)) > 0)">
                                    <!-- Test whether names are split, and if so include them in multiple name parts. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Abdisho_YdQ_Sy_NV_Given,Abdisho_YdQ_Sy_NV_Family,Abdisho_YdQ_Sy_NV_Titles,Abdisho_YdQ_Sy_V_Given,Abdisho_YdQ_Sy_V_Family,Abdisho_YdQ_Sy_V_Titles))) > 0">
                                        <nameEntryParallel localType="#Abdisho-YDQ">
                                            <nameEntry scriptCode="Syrc" xml:lang="syr"
                                                localType="#Abdisho-YDQ">
                                                <xsl:if
                                                  test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Given)) > 0">
                                                  <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                  <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_NV_Given"/>
                                                  </part>
                                                </xsl:if>
                                                <xsl:if
                                                  test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Family)) > 0">
                                                  <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                  <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_NV_Family"/>
                                                  </part>
                                                </xsl:if>
                                                <xsl:if
                                                  test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Titles)) > 0">
                                                  <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                  <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_NV_Titles"/>
                                                  </part>
                                                </xsl:if>
                                            </nameEntry>
                                            <nameEntry scriptCode="Syre" xml:lang="syr"
                                                localType="#Abdisho-YDQ">
                                                <xsl:if
                                                  test="string-length(normalize-space(Abdisho_YdQ_Sy_V_Given)) > 0">
                                                  <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                  <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_V_Given"/>
                                                  </part>
                                                </xsl:if>
                                                <xsl:if
                                                  test="string-length(normalize-space(Abdisho_YdQ_Sy_V_Family)) > 0">
                                                  <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                  <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_V_Family"/>
                                                  </part>
                                                </xsl:if>
                                                <xsl:if
                                                  test="string-length(normalize-space(Abdisho_YdQ_Sy_V_Titles)) > 0">
                                                  <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                  <xsl:value-of select="Abdisho_YdQ_Sy_V_Titles"
                                                  />
                                                  </part>
                                                </xsl:if>
                                            </nameEntry>
                                            <alternativeForm>syriaca.org</alternativeForm>
                                        </nameEntryParallel>
                                    </xsl:if>
                                    <!-- Include vocalized and non-vocalized name forms in parallel. -->
                                    <nameEntryParallel localType="#Abdisho-YDQ">
                                        <nameEntry scriptCode="Syrc" xml:lang="syr"
                                            localType="#Abdisho-YDQ">
                                            <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                                <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_NV_Full"/>
                                            </part>
                                        </nameEntry>
                                        <nameEntry scriptCode="Syre" xml:lang="syr"
                                            localType="#Abdisho-YDQ">
                                            <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                                <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_V_Full"/>
                                            </part>
                                        </nameEntry>
                                        <alternativeForm>syriaca.org</alternativeForm>
                                    </nameEntryParallel>
                                </xsl:when>
                                <!-- If only non-vocalized present, do not use nameEntryParallel. -->
                                <xsl:when
                                    test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Full)) > 0">
                                    <!-- Test whether name is split, and if so include name in multiple parts. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Abdisho_YdQ_Sy_NV_Given,Abdisho_YdQ_Sy_NV_Family,Abdisho_YdQ_Sy_NV_Titles))) > 0">
                                        <nameEntry scriptCode="Syrc" xml:lang="syr"
                                            localType="#Abdisho-YDQ">
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Given)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                  <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_NV_Given"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Family)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                  <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_NV_Family"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_YdQ_Sy_NV_Titles)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                  <xsl:value-of
                                                  select="Abdisho_YdQ_Sy_NV_Titles"/>
                                                </part>
                                            </xsl:if>
                                        </nameEntry>
                                    </xsl:if>
                                    <nameEntry scriptCode="Syrc" xml:lang="syr"
                                        localType="#Abdisho-YDQ">
                                        <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                            <xsl:value-of
                                                select="Abdisho_YdQ_Sy_NV_Full"/>
                                        </part>
                                    </nameEntry>
                                </xsl:when>
                                <!-- If only vocalized present, do not use nameEntryParallel. -->
                                <xsl:when
                                    test="string-length(normalize-space(Abdisho_YdQ_Sy_V_Full)) > 0">
                                    <!-- Test whether name is split, and if so include name in multiple parts. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Abdisho_YdQ_Sy_V_Given,Abdisho_YdQ_Sy_V_Family,Abdisho_YdQ_Sy_V_Titles))) > 0">
                                        <nameEntry scriptCode="Syre" xml:lang="syr" localType="#Abdisho-YDQ">
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_YdQ_Sy_V_Given)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                    <xsl:value-of
                                                        select="Abdisho_YdQ_Sy_V_Given"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_YdQ_Sy_V_Family)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                    <xsl:value-of
                                                        select="Abdisho_YdQ_Sy_V_Family"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_YdQ_Sy_V_Titles)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                    <xsl:value-of
                                                        select="Abdisho_YdQ_Sy_V_Titles"/>
                                                </part>
                                            </xsl:if>
                                        </nameEntry>
                                    </xsl:if>
                                    <nameEntry scriptCode="Syre" xml:lang="syr" localType="#Abdisho-YDQ">
                                        <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                            <xsl:value-of
                                                select="Abdisho_YdQ_Sy_V_Full"/>
                                        </part>
                                    </nameEntry>
                                </xsl:when>
                            </xsl:choose>
                            <!-- Give Abdisho BO names as parallel name entries. -->
                            <xsl:choose>
                                <!-- Test whether both vocalized and non-vocalized are present, and if so use nameEntryParallel. -->
                                <xsl:when
                                    test="(string-length(normalize-space(Abdisho_BO_Sy_NV_Full)) > 0) and (string-length(normalize-space(Abdisho_BO_Sy_V_Full)) > 0)">
                                    <!-- Test whether names are split, and if so include them in multiple name parts. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Abdisho_Syriac_BO_NV_Given,Abdisho_BO_Sy_NV_Family,Abdisho_BO_Sy_NV_Titles,Abdisho_BO_Sy_V_Given,Abdisho_BO_Sy_V_Family,Abdisho_BO_Sy_V_Titles))) > 0">
                                        <nameEntryParallel localType="#Abdisho-YDQ">
                                            <nameEntry scriptCode="Syrc" xml:lang="syr"
                                                localType="#Abdisho-YDQ">
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_Syriac_BO_NV_Given)) > 0">
                                                    <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                        <xsl:value-of
                                                            select="Abdisho_Syriac_BO_NV_Given"/>
                                                    </part>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_BO_Sy_NV_Family)) > 0">
                                                    <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                        <xsl:value-of
                                                            select="Abdisho_BO_Sy_NV_Family"/>
                                                    </part>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_BO_Sy_NV_Titles)) > 0">
                                                    <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                        <xsl:value-of
                                                            select="Abdisho_BO_Sy_NV_Titles"/>
                                                    </part>
                                                </xsl:if>
                                            </nameEntry>
                                            <nameEntry scriptCode="Syre" xml:lang="syr"
                                                localType="#Abdisho-YDQ">
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_BO_Sy_V_Given)) > 0">
                                                    <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                        <xsl:value-of
                                                            select="Abdisho_BO_Sy_V_Given"/>
                                                    </part>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_BO_Sy_V_Family)) > 0">
                                                    <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                        <xsl:value-of
                                                            select="Abdisho_BO_Sy_V_Family"/>
                                                    </part>
                                                </xsl:if>
                                                <xsl:if
                                                    test="string-length(normalize-space(Abdisho_BO_Sy_V_Titles)) > 0">
                                                    <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                        <xsl:value-of select="Abdisho_BO_Sy_V_Titles"
                                                        />
                                                    </part>
                                                </xsl:if>
                                            </nameEntry>
                                            <alternativeForm>syriaca.org</alternativeForm>
                                        </nameEntryParallel>
                                    </xsl:if>
                                    <!-- Include vocalized and non-vocalized name forms in parallel. -->
                                    <nameEntryParallel localType="#Abdisho-YDQ">
                                        <nameEntry scriptCode="Syrc" xml:lang="syr"
                                            localType="#Abdisho-YDQ">
                                            <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                                <xsl:value-of
                                                    select="Abdisho_BO_Sy_NV_Full"/>
                                            </part>
                                        </nameEntry>
                                        <nameEntry scriptCode="Syre" xml:lang="syr"
                                            localType="#Abdisho-YDQ">
                                            <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                                <xsl:value-of
                                                    select="Abdisho_BO_Sy_V_Full"/>
                                            </part>
                                        </nameEntry>
                                        <alternativeForm>syriaca.org</alternativeForm>
                                    </nameEntryParallel>
                                </xsl:when>
                                <!-- If only non-vocalized present, do not use nameEntryParallel. -->
                                <xsl:when
                                    test="string-length(normalize-space(Abdisho_BO_Sy_NV_Full)) > 0">
                                    <!-- Test whether name is split, and if so include name in multiple parts. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Abdisho_Syriac_BO_NV_Given,Abdisho_BO_Sy_NV_Family,Abdisho_BO_Sy_NV_Titles))) > 0">
                                        <nameEntry scriptCode="Syrc" xml:lang="syr"
                                            localType="#Abdisho-YDQ">
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_Syriac_BO_NV_Given)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                    <xsl:value-of
                                                        select="Abdisho_Syriac_BO_NV_Given"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_BO_Sy_NV_Family)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                    <xsl:value-of
                                                        select="Abdisho_BO_Sy_NV_Family"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_BO_Sy_NV_Titles)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                    <xsl:value-of
                                                        select="Abdisho_BO_Sy_NV_Titles"/>
                                                </part>
                                            </xsl:if>
                                        </nameEntry>
                                    </xsl:if>
                                    <nameEntry scriptCode="Syrc" xml:lang="syr"
                                        localType="#Abdisho-YDQ">
                                        <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                            <xsl:value-of
                                                select="Abdisho_BO_Sy_NV_Full"/>
                                        </part>
                                    </nameEntry>
                                </xsl:when>
                                <!-- If only vocalized present, do not use nameEntryParallel. -->
                                <xsl:when
                                    test="string-length(normalize-space(Abdisho_BO_Sy_V_Full)) > 0">
                                    <!-- Test whether name is split, and if so include name in multiple parts. -->
                                    <xsl:if
                                        test="string-length(normalize-space(concat(Abdisho_BO_Sy_V_Given,Abdisho_BO_Sy_V_Family,Abdisho_BO_Sy_V_Titles))) > 0">
                                        <nameEntry scriptCode="Syre" xml:lang="syr" localType="#Abdisho-YDQ">
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_BO_Sy_V_Given)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#given">
                                                    <xsl:value-of
                                                        select="Abdisho_BO_Sy_V_Given"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_BO_Sy_V_Family)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#family">
                                                    <xsl:value-of
                                                        select="Abdisho_BO_Sy_V_Family"/>
                                                </part>
                                            </xsl:if>
                                            <xsl:if
                                                test="string-length(normalize-space(Abdisho_BO_Sy_V_Titles)) > 0">
                                                <part localType="http://syriaca.org/vocab/eac/localType#termsOfAddress">
                                                    <xsl:value-of
                                                        select="Abdisho_BO_Sy_V_Titles"/>
                                                </part>
                                            </xsl:if>
                                        </nameEntry>
                                    </xsl:if>
                                    <nameEntry scriptCode="Syre" xml:lang="syr" localType="#Abdisho-YDQ">
                                        <part localType="http://syriaca.org/vocab/eac/localType#verbatim">
                                            <xsl:value-of
                                                select="Abdisho_BO_Sy_V_Full"/>
                                        </part>
                                    </nameEntry>
                                </xsl:when>
                            </xsl:choose>
                        </identity>                        
                    </cpfDescription>
                </eac-cpf>
            </xsl:result-document>
        </xsl:for-each>

        <!-- Create an index file that links to all of the EAC files. -->
        <xsl:result-document href="output2/index.html" format="html">
            <html>
                <head>
                    <title>Index</title>
                </head>
                <body>
                    <xsl:for-each select="row">
                        <a href="{SRP_ID}.xml">
                            <xsl:value-of select="Name__calculated_Barsoum_GEDSH_"/>
                        </a>
                        <br/>
                    </xsl:for-each>
                </body>
            </html>

        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
