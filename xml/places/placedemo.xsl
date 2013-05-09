<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:t="http://www.tei-c.org/ns/1.0">
    
    <xsl:output encoding="UTF-8" indent="no" method="xml" name="html5" />
    
    <xsl:variable name="n">
        <xsl:text>
</xsl:text>
    </xsl:variable> 
    <xsl:variable name="bibprefix">#bib<xsl:value-of select="substring-after(//t:idno[contains(.,'syriaca.org')],'place/')"/>-</xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates select="t:TEI"/>
    </xsl:template>
    
    <xsl:template match="t:TEI">
     <xsl:result-document href="{substring-after(//t:idno[contains(.,'syriaca.org')],'place/')}.html">
            <xsl:value-of select="$n"/>
            <xsl:processing-instruction name="DOCTYPE">html</xsl:processing-instruction>
            <xsl:value-of select="$n"/>
            <html>
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                    <title>
                        <xsl:value-of select="t:teiHeader/t:fileDesc/t:titleStmt/t:title"/>
                    </title>
                    <link rel="stylesheet" href="../../css/yui/reset-fonts-grids.css" type="text/css" media="screen" />
                    <link rel="stylesheet" href="../../css/srp-screen.css" type="text/css" media="screen" />
                    <link rel="stylesheet" href="../../css/srp-trees-screen.css" type="text/css" media="screen" />
                    
                </head>
                <body>
                    <div id="outercontainer">
                        <div id="innercontainer">
                            <div id="header">
                                <div id="branding">
                                    <img src="../images/logo.png" alt="Syriaca.org logo"/>
                                    <h1>Syriaca.org Demo</h1>
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
                                            <li ><a href="../authors.html">authors</a></li>
                                            <li>titles</li>
                                            <li>abbreviations</li>
                                            <li>artifacts</li>
                                            <li class="selected">places</li>
                                            <li><a href="../about.html">about</a></li>
                                        </ul>
                                    </div>
                                    <div id="activetab">
                                        <div id="tabcontent">
                                            <xsl:apply-templates select="t:text/t:body/t:listPlace/t:place"></xsl:apply-templates>
                                            <div id="notes">
                                                <h3>Syriaca.org Notes</h3>
                                                <xsl:for-each select="t:teiHeader/t:fileDesc/t:titleStmt/t:respStmt">
                                                    <p><xsl:value-of select="t:name"/>, <xsl:value-of select="t:resp"/></p>
                                                </xsl:for-each>
                                                <p>Last Modified <xsl:value-of select="t:teiHeader/t:fileDesc/t:publicationStmt/t:date"/></p>
                                                <p>Copyright © The Creators.  
                                                <xsl:value-of select="t:teiHeader/t:fileDesc/t:publicationStmt/t:availability/t:licence"/></p>
                                            </div>
                                            <div id="citation">
                                                <h3>How to cite this article:</h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="//t:place">
        <xsl:value-of select="$n"/>
        <div id="title">
            <xsl:value-of select="$n"/>
            <h2>
                <xsl:choose>
                    <xsl:when test="t:placeName[@xml:lang='syr']">
                        <xsl:attribute name="dir">rtl</xsl:attribute>
                        <xsl:value-of select="t:placeName[@xml:lang='syr' and contains(@resp,'syriaca.org')]"/> -
                        <xsl:value-of select="t:placeName[@xml:lang='en' and contains(@resp,'syriaca.org')]"/>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="t:placeName[@xml:lang='en' and contains(@resp,'syriaca.org')]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </h2>
        </div>
        <div id="names">
                    <p><xsl:for-each select="t:placeName[@source]">
                        <xsl:value-of select="current()"/>
                            &#x200F;&#x200E; <!-- RLM makes any parenthesis in Syriac/Arabic name work well; LRM makes citation parenthesis work well -->
                            (<xsl:value-of select="replace(replace(@source, $bibprefix,''),' ', ', ')"/>) 
                    </xsl:for-each></p>
            <p>Place Type: <xsl:value-of select="@type"/> </p>
            <p>Confessions:
                <xsl:for-each select="t:state[@type='confession']">
                    <xsl:value-of select="current()"/>
                    <xsl:choose>
                        <xsl:when test="@when">
                            (<xsl:value-of select="@when"/>) 
                        </xsl:when>
                        <xsl:when test="@from">
                            (<xsl:value-of select="@from"/> - <xsl:if test="@to"><xsl:value-of select="@to"/></xsl:if>)
                        </xsl:when>
                    </xsl:choose>
                    (<xsl:value-of select="replace(replace(@source, $bibprefix,''),' ', ', ')"/>)
                    <xsl:if test="position() &lt; last()">, </xsl:if>
                </xsl:for-each>
            </p>
        </div>
        <div id="abstract">
            <h3>Abstract</h3>
            <xsl:apply-templates select="t:desc[contains(@xml:id,'abstract-en')]"></xsl:apply-templates>
        </div>
        <div id="location">
            <h3>Location</h3>
            <xsl:if test="t:location/t:geo">
                <xsl:apply-templates select="t:location[t:geo]"/>
            </xsl:if>
            <!-- If there is a location without a <geo>, then Location heading and information -->
            <xsl:if test="t:location[not(t:geo)]">
                <ul class="bulleted">
                    <xsl:apply-templates select="t:location[not(t:geo)]"/>
                </ul>
            </xsl:if>
        </div>
        <div id="events">
            <h3>Events</h3>
            <ul class="bulleted">
                <xsl:apply-templates select="t:event"/>
            </ul>
        </div>
        <div id="places">
            <h3>Related Places</h3>
            <!-- Pull related places -->
        </div>
        <div id="people">
            <h3>Related People</h3>
            <!-- Pull related people -->
        </div>
        <div id="objects">
            <h3>Related Objects</h3>
            <!-- Pull related objects, incl. manuscripts -->
        </div>
        <div id="subjects">
            <h3>Related Subjects</h3>
            <!-- Pull related subjects -->
        </div>
        <div id="descriptions">
            <xsl:apply-templates select="t:desc[not(contains(@xml:id,'abstract'))]"/>
        </div>
        <div id="idnos">
            <h3>Additional Links</h3>
            <ul class="bulleted">
                <xsl:apply-templates select="//t:idno"/>
            </ul>
        </div>
        <div id="canonical-URI">
            <h3>Canonical URI</h3>
            <xsl:value-of select="t:idno[contains(.,'syriaca.org')]"/>
        </div>
        <div id="sources">
            <h3>Sources</h3>
            <ul>
                <xsl:apply-templates select="t:bibl"/>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="t:location[t:geo]">
        <!-- If there is a location with a <geo>, then google maps mashup -->
            <h1>GOOGLE MAPS MASH-UP</h1> 
            <h1><xsl:value-of select="t:geo"/></h1>
            (<xsl:value-of select="replace(replace(@source, $bibprefix,''),' ', ', ')"/>)
            <!-- (<xsl:value-of select="substring-after(t:location/@source,'-')"/>)  -->
    </xsl:template>
    
    <xsl:template match="t:location[not(t:geo)]">
        <li>
            <!-- <xsl:for-each select="child::node()">
                <xsl:choose>
                    <xsl:when test="@ref">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                </xsl:choose>
            </xsl:for-each> -->
            <xsl:apply-templates select="child::node()"/>
            (<xsl:value-of select="replace(replace(@source, $bibprefix,''),' ', ', ')"/>)
            <!-- (<xsl:value-of select="substring-after(@source,'-')"/>)  -->
        </li>
    </xsl:template>
    
    <xsl:template match="//t:event">
        <xsl:if test="not(contains(@type,'attestation'))">
        <li>
            <xsl:choose>
                <xsl:when test="@when">
                    <xsl:value-of select="@when"/>: 
                </xsl:when>
                <xsl:when test="@from">
                    <xsl:value-of select="@from"/> - <xsl:if test="@to"><xsl:value-of select="@to"/></xsl:if>:
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="t:desc/child::node()"/>
            <!-- <xsl:value-of select="."/> -->
            (<xsl:value-of select="replace(replace(@source, $bibprefix,''),' ', ', ')"/>)
            <!-- (<xsl:value-of select="substring-after(@source,'-')"/>)  -->
        </li>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="//t:desc">
        <xsl:if test="contains(@xml:id,'abstract')">
            <xsl:apply-templates select="child::node()"/>
        </xsl:if>
        
        <!-- If there is a GEDSH desc, i.e. if there is a bibl entry for GEDSH whose @xml:id is contained in the @source of the quote of this desc -->
        <xsl:if test="t:quote/@source">
            <xsl:variable name="citation"><xsl:value-of select="substring-after(t:quote/@source,'#')"/></xsl:variable>
            <xsl:if test="//t:bibl[contains(t:ptr/@target,'http://syriaca.org/bibl/1') and contains(@xml:id,$citation)]">
                <h3>GEDSH Entry</h3>
                <p><xsl:apply-templates select="t:quote/child::node()"/>... (read more)
                    (<xsl:value-of select="replace(replace(t:quote/@source, $bibprefix,''),' ', ', ')"/>)
                    <!-- (<xsl:value-of select="substring-after(t:quote/@source,'-')"/>)  -->
                </p>
            </xsl:if>
        
            <!-- If Barsoum description, Description heading and "(Read in Syriac or Arabic)" -->
            <xsl:if test="//t:bibl[contains(t:ptr/@target,'http://syriaca.org/bibl/4') and contains(@xml:id,$citation)]">
                <h3>Description</h3>
                <p><xsl:apply-templates select="t:quote/child::node()"/>  (Read in Syriac or Arabic)
                    (<xsl:value-of select="replace(replace(t:quote/@source, $bibprefix,''),' ', ', ')"/>)
                    <!-- (<xsl:value-of select="substring-after(t:quote/@source,'-')"/>)  -->
                </p>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="//t:idno">
        <xsl:if test="contains(@type,'URI') and not(contains(.,'syriaca.org'))">
            <li><a><xsl:attribute name="href"><xsl:value-of select="current()"/></xsl:attribute><xsl:value-of select="current()"/></a></li>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="t:bibl">
        <li>
            <xsl:value-of select="substring-after(@xml:id,'-')"/>. 
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="t:ptr/@target"/>
                </xsl:attribute>
                <xsl:value-of select="t:title"/>
            </a>&#x200E;<xsl:if test="t:citedRange">, <xsl:value-of select="t:citedRange"/></xsl:if>. <!-- LRM makes citation comma work well -->
        </li>
    </xsl:template>
    
    <xsl:template match="text()">
        <!-- Deal with text while adding links to place names surrounded by <placeName ref="http://syriaca.org/place/##"/> -->
        <xsl:choose>
            <xsl:when test="contains(../@ref,'syriaca.org')">
                <a><xsl:attribute name="href"><xsl:value-of select="../@ref"/></xsl:attribute><xsl:value-of select="."/></a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>