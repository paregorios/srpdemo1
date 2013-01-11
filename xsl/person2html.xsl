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
                                <div id="activetab">
                                    <div id="tabcontent">
                                        <xsl:value-of select="$n"/>
                                        <div id="title">
                                            <xsl:value-of select="$n"/>
                                            <h3>
                                                <span xml:lang="{$personnamepreflang}">
                                                    <xsl:value-of select="$personnamepref"/>
                                                </span>
                                                <xsl:text/>
                                                <xsl:text> (</xsl:text>
                                                <xsl:value-of select="$personnameprefgloss"/>
                                                <xsl:text>)</xsl:text>
                                            </h3>
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
                                            
                                        </div>
                                        <div id="geography">
                                            
                                        </div>
                                        <div id="biography">
                                            
                                        </div>
                                        <div id="additional">
                                            
                                        </div>
                                        <div id="provenance">
                                            
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
    
    <xsl:template match="e:*">
        <xsl:message>No handler in xslt for eac element <xsl:value-of select="local-name()"/></xsl:message>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:message>No handler in xslt for non-eac element <xsl:value-of select="name()"/></xsl:message>
    </xsl:template>
    
    
</xsl:stylesheet>