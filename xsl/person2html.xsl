<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:e="urn:isbn:1-931666-33-4"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs e"
    version="2.0">
    
    <xsl:output encoding="UTF-8" indent="no" method="xml" name="html5" />
    
    <xsl:variable name="n">
        <xsl:text>
</xsl:text>
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates select="e:eac-cpf"/>
    </xsl:template>
    
    <xsl:template match="e:eac-cpf">
        <xsl:variable name="personid">person-<xsl:value-of select="./descendant::e:recordId"></xsl:value-of></xsl:variable>
        <xsl:variable name="persontitle" select="./descendant::e:nameEntry[following-sibling::e:authorizedForm='syriaca.org' and @xml:lang='eng'][1]/e:part[1]"/>
        <xsl:variable name="persontitlelang" select="./descendant::e:nameEntry[following-sibling::e:authorizedForm='syriaca.org' and @xml:lang='eng'][1]/@xml:lang"/>
        <xsl:variable name="personnamepref" select="./descendant::e:nameEntry[following-sibling::e:authorizedForm='syriaca.org' and @xml:lang='syc'][1]/e:part[1]"/>
        <xsl:variable name="personnamepreflang" select="./descendant::e:nameEntry[following-sibling::e:authorizedForm='syriaca.org' and @xml:lang='syc'][1]/@xml:lang"/>
        <xsl:variable name="personnameprefgloss" select="../descendant::e:nameEntry[following-sibling::e:authorizedForm='syriaca.org' and @xml:lang='eng'][1]/e:part[1]"/>
        
        <xsl:value-of select="$n"/>
        <xsl:processing-instruction name="DOCTYPE">html</xsl:processing-instruction>
        <xsl:value-of select="$n"/>
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title><xsl:value-of select="$persontitle"/> an SRP Person</title>
                <link rel="stylesheet" href="../css/yui/reset-fonts-grids.css" type="text/css" media="screen" />
                <link rel="stylesheet" href="../css/srp-screen.css" type="text/css" media="screen" />
                <link rel="stylesheet" href="../css/srp-trees-screen.css" type="text/css" media="screen" />
            </head>
            <body>
                <div id="outercontainer">
                    <div id="innercontainer">
                        <div id="header">
                            <div id="branding">
                                <img src="../images/logo.png" alt="syriac reference portal logo"/>
                                <h1>Syriac Reference Portal Demo 1</h1>
                            </div>
                            <div id="semweb">
                                <div><a href="" title="SPARQL is not yet implemented"><img src="../images/sparql-logo.png" alt="sparql logo"/></a></div>
                            </div>
                            <div id="search">
                                <form>
                                    <input type="search" name="search" placeholder="search"/>
                                    <input type="submit" name="find" label="go"/>
                                </form>
                            </div>
                        </div>
                        <div id="mainbody">
                            <div id="nascar">
                                <h2>powered by:</h2>
                                <div id="nascar-logos">
                                    foo
                                </div>
                            </div>
                            <div id="content">
                                <div id="mainnav">
                                    <ul>
                                        <li class="selected">authors</li>
                                        <li>titles</li>
                                        <li>abbreviations</li>
                                        <li>artifacts</li>
                                        <li>places</li>
                                        <li>about</li>
                                    </ul>
                                </div>
                                <div id="subnav">
                                    <p>&gt;&gt;&gt;
                                        <span xml:lang="{$persontitlelang}"><xsl:value-of select="$persontitle"/></span></p>
                                </div>
                                <div id="activetab">
                                    <div id="tabcontent">
                                        <xsl:value-of select="$n"/>
                                        <div id="title">
                                            <xsl:value-of select="$n"/>
                                            <h2>
                                                <span xml:lang="{$personnamepreflang}">
                                                    <xsl:value-of select="$personnamepref"/>
                                                </span>
                                                <xsl:text/>
                                                <xsl:text> (</xsl:text>
                                                <xsl:value-of select="$personnameprefgloss"/>
                                                <xsl:text>)</xsl:text>
                                            </h2>
                                            <xsl:value-of select="$n"/>
                                            <xsl:apply-templates select="./descendant::e:existDates"/>
                                            <p>
                                                <xsl:value-of
                                                    select="normalize-space(./descendant::e:biogHist/e:abstract)"
                                                />
                                            </p>
                                            <xsl:value-of select="$n"/>
                                        </div>
                                        <div id="names">
                                            <h3>Names</h3>
                                            <xsl:apply-templates select="./descendant::e:identity"/>
                                        </div>
                                        <div id="geography">
                                            <h3>Geography</h3>
                                            <xsl:apply-templates select="./descendant::e:places"/>
                                        </div>
                                        <div id="biography">
                                            <h3>Biography</h3>
                                            <xsl:apply-templates select="./descendant::e:biogHist"/>
                                        </div>
                                        <div id="additional">
                                            <h3>Other information and identifiers</h3>
                                            <ul class="bulleted">
                                                <xsl:for-each select="./descendant::e:control/e:otherRecordId">
                                                    <li><xsl:apply-templates select="."/></li>
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                        <div id="provenance">
                                            <h3>About this information</h3>
                                            <p>This information is maintained by <xsl:apply-templates select="./descendant::e:maintenanceAgency"/>.</p>
                                            <xsl:apply-templates select="./descendant::e:sources"/>
                                            <xsl:apply-templates select="./descendant::e:maintenanceHistory"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="footer">
                            
                        </div>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="e:existDates">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="e:dateRange[e:fromDate and e:toDate]">
        <xsl:text></xsl:text><xsl:value-of select="e:fromDate"/>-<xsl:value-of select="e:toDate"/><xsl:text></xsl:text>
    </xsl:template>
    
    <xsl:template match="e:date"><xsl:apply-templates/></xsl:template>
    
    <xsl:template match="e:identity">
        <ul class="bulleted">
            <xsl:for-each select="e:nameEntryParallel | e:nameEntry">
                <li>
                    <xsl:choose>
                        <xsl:when test="self::e:nameEntry">
                            <xsl:apply-templates select="."/>
                        </xsl:when>
                        <xsl:when test="self::e:nameEntryParallel">
                            <xsl:choose>
                                <xsl:when test="e:nameEntry[e:preferredForm='syriaca.org']">
                                    <xsl:apply-templates select="e:nameEntry[e:preferredForm='syriaca.org']"/>
                                    <ul class="bulleted">
                                        <xsl:for-each select="e:nameEntry[not(e:preferredForm='syriaca.org')]">
                                            <li><xsl:apply-templates select="."/></li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="e:nameEntry[1]"/>
                                    <ul>
                                        <xsl:for-each select="e:nameEntry[1]/following-sibling::e:nameEntry">
                                            <li><xsl:apply-templates select="."/></li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                    
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="e:nameEntry">
        <xsl:choose>
            <xsl:when test="xml:lang='eng'"><xsl:apply-templates select="e:part"/></xsl:when>
            <xsl:otherwise>
                <span xml:lang="{@xml:lang}"><xsl:apply-templates select="e:part"/></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
    <xsl:template match="e:places">
        <ul class="bulleted">
            <xsl:for-each select="e:place">
                <li><xsl:apply-templates/></li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="e:placeRole">
        <strong><xsl:value-of select="."/>:</strong><xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="e:placeEntry[@vocabularySource]">
        <a href="{@vocabularySource}"><xsl:value-of select="."/></a>
    </xsl:template>
        
    <xsl:template match="e:date[ancestor::e:place]">
        <xsl:text> (</xsl:text><xsl:value-of select="."/><xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="e:biogHist">
        <xsl:apply-templates select="e:p[not(contains('Detailed biographical history can go here.', .))]"/>
        <xsl:apply-templates select="e:chronList"/>
    </xsl:template>
    
    <xsl:template match="e:chronList">
        <ul class="bulleted">
            <xsl:for-each select="e:chronItem">
                <li>
                    <xsl:text></xsl:text><xsl:apply-templates select="e:date | e:dateRange"/><xsl:text></xsl:text>
                    <xsl:if test="e:place">
                        <xsl:text> (</xsl:text><xsl:apply-templates select="e:place"/><xsl:text>)</xsl:text>
                    </xsl:if>
                    <xsl:text>: </xsl:text>
                    <xsl:apply-templates select="e:event"/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="e:otherRecordId[starts-with(., 'http://')]">
        <a href="{.}"><xsl:value-of select="."/></a>
    </xsl:template>
    
    <xsl:template match="e:sources">
        <h4>Sources:</h4>
        <ul class="bulleted">
            <xsl:for-each select="e:source">
                <li><xsl:apply-templates/></li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="e:maintenanceHistory">
        <h4>History of changes:</h4>
        <ul class="bulleted">
            <xsl:for-each select="e:maintenanceEvent">
                <li><xsl:apply-templates select="."/></li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="e:maintenanceEvent">
        <xsl:text></xsl:text><xsl:apply-templates select="e:eventType"/><xsl:text></xsl:text>
        <xsl:if test="e:eventDateTime">
            <xsl:text> (</xsl:text><xsl:apply-templates select="e:eventDateTime"/><xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:if test="e:agent">
            <xsl:text> by </xsl:text><xsl:apply-templates select="e:agent"/><xsl:text></xsl:text>
        </xsl:if>
        <xsl:text>.</xsl:text>
    </xsl:template>
    
    <xsl:template match="e:eventDateTime[@standardDateTime]">
        <xsl:text></xsl:text><xsl:value-of select="format-dateTime(@standardDateTime,'[M01]/[D01]/[Y0001] at [H01]:[m01]:[s01]')"/><xsl:text></xsl:text>
    </xsl:template>

    <xsl:template match="e:eventType[ancestor::e:*[1]/self::e:maintenanceEvent]">
        <xsl:text></xsl:text><xsl:sequence select="concat(upper-case(substring(.,1,1)),substring(., 2),' '[not(last())])"/><xsl:text></xsl:text>
    </xsl:template>
    
    <xsl:template match="e:agent | e:event | e:maintenanceAgency | e:agencyName | e:sourceEntry | e:part | e:placeEntry[not(@vocabularySource)]"><xsl:apply-templates/></xsl:template>
    
    <xsl:template match="e:*">
        <xsl:message>No handler in xslt for eac element <xsl:value-of select="local-name()"/></xsl:message>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:message>No handler in xslt for non-eac element <xsl:value-of select="name()"/></xsl:message>
    </xsl:template>
    
    
</xsl:stylesheet>