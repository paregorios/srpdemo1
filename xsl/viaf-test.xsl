<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd" xmlns:xlink="http://www.w3.org/1999/xlink">
    <xsl:template match="/root">
        <xsl:for-each select="row">
            <eac-cpf>
                <!-- Schema declarations should be inserted. -->
                <control>
                    <recordId>
                        <xsl:value-of select="SRP_ID"/>
                    </recordId>
                    <xsl:if test="string-length(normalize-space(VIAF_URL)) > 0">
                        <otherRecordId>
                            <xsl:value-of select="VIAF_URL"/>
                        </otherRecordId>
                    </xsl:if>
                    <maintenanceStatus>new</maintenanceStatus>
                    <maintenanceAgency>
                        <agencyName>Syriac Reference Portal</agencyName>
                    </maintenanceAgency>
                    <maintenanceHistory>
                        <maintenanceEvent>
                            <eventType>created</eventType>
                            <eventDateTime>
                                <xsl:attribute name="standardDateTime" select="current-dateTime()">
                                </xsl:attribute>
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
                        <xsl:if test="string-length(normalize-space(GEDSH_Entry)) > 0">
                            <!-- Need to also test for "None," etc. or remove from source data -->
                        <source xml:id="GEDSH">
                            <sourceEntry>Gorgias Encyclopedic Dictionary of the Syriac Heritage</sourceEntry>
                            <descriptiveNote>
                                <p>Entry <xsl:value-of select="GEDSH_Entry_Number"/></p>
                            </descriptiveNote>
                        </source>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(Syriac_Name_Non_Vocalized)) > 0">
                        <source xml:id="Barsoum-SY">
                            <sourceEntry>Barsoum (Syriac)</sourceEntry>
                            <descriptiveNote>
                                <p>Page <xsl:value-of select="Syriac_Page_Number"/></p>
                            </descriptiveNote>
                        </source>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(Arabic_Name)) > 0">
                        <source xml:id="Barsoum-AR">
                            <sourceEntry>Barsoum (Arabic)</sourceEntry>
                            <descriptiveNote>
                                <p>Page <xsl:value-of select="Arabic_Page_Number"/></p>
                            </descriptiveNote>
                        </source>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(EnglishName)) > 0">
                        <source xml:id="Barsoum-EN">
                            <sourceEntry>Barsoum (English)</sourceEntry>
                            <descriptiveNote>
                                <p>Page <xsl:value-of select="EnglishPageNumber"/></p>
                            </descriptiveNote>
                        </source>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(Syriac_from_Abdisho_YdQ_non-vocalized)) > 0">
                        <source xml:id="Abdisho-YDQ">
                            <sourceEntry>Abdisho (YDQ)</sourceEntry>
                            <descriptiveNote>
                                <p>Page <xsl:value-of select="YdQ_Page"/></p>
                            </descriptiveNote>
                        </source>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(Syriac_from_Abdisho_BO_non-vocalized)) > 0">
                            <!-- Need OR test for vocalized also -->
                        <source xml:id="Abdisho-BO">
                            <sourceEntry>Abdisho (BO III)</sourceEntry>
                            <descriptiveNote>
                                <p>Page <xsl:value-of select="BO_Page"/></p>
                            </descriptiveNote>
                        </source>
                        </xsl:if>
                        <xsl:if test="string-length(normalize-space(CBSC_Keyword)) > 0">
                        <source xlink:href="http://www.csc.org.il/db/db.aspx?db=SB" xml:id="CBSC">
                            <sourceEntry>Comprehensive Bibliography of Syriac Christianity</sourceEntry>
                        </source>
                        </xsl:if>
                    </sources>
                </control>
            </eac-cpf>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
