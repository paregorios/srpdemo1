<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math xd"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 16, 2013</xd:p>
            <xd:p><xd:b>Author:</xd:b> Tom Elliott</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:param name="uribase">http://syriaca.org/place/</xsl:param>
    <xsl:param name="agenturi">https://github.com/paregorios/srpdemo1/blob/master/xsl/place2ttl.xsl</xsl:param>
    
    <xsl:output method="text" encoding="UTF-8" indent="no"/>

    <xsl:variable name="n">
        <xsl:text>
</xsl:text>
    </xsl:variable>
    <xsl:variable name="t">
        <xsl:text>  </xsl:text>
    </xsl:variable>
    <xsl:variable name="s">
        <xsl:text>;</xsl:text>
    </xsl:variable>   
    <xsl:variable name="p">
        <xsl:text>.</xsl:text>
    </xsl:variable>
    <xsl:variable name="c">
        <xsl:text>,</xsl:text>
    </xsl:variable>
    <xsl:variable name="nt"><xsl:value-of select="$n"/><xsl:value-of select="$t"/></xsl:variable>
    <xsl:variable name="snt"><xsl:text> </xsl:text><xsl:value-of select="$s"/><xsl:value-of select="$nt"/></xsl:variable>
    <xsl:variable name="sntt"><xsl:text> </xsl:text><xsl:value-of select="$s"/><xsl:value-of select="$nt"/><xsl:value-of select="$t"/></xsl:variable>
    <xsl:variable name="cntt"><xsl:text> </xsl:text><xsl:value-of select="$c"/><xsl:value-of select="$nt"/><xsl:value-of select="$t"/></xsl:variable>
    <xsl:variable name="pn"><xsl:text> </xsl:text><xsl:value-of select="$p"/><xsl:value-of select="$n"/></xsl:variable>
    <xsl:variable name="srpuri" select="//t:idno[starts-with(., $uribase)][1]"/>
    <xsl:variable name="docroot" select="/"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="//t:text/t:body/t:listPlace/t:place[1]"/>
    </xsl:template>
    
    <xsl:template match="t:place">
        
        <!-- URI#this identifies a spatial feature, has a title and description, and is primary topic of the page -->
        <xsl:text>&lt;</xsl:text><xsl:value-of select="$srpuri"/><xsl:text>&gt; a &lt;http://geovocab.org/spatial#Feature&gt;</xsl:text>
        <xsl:apply-templates select="//t:titleStmt"/>
        <xsl:apply-templates select="t:desc"/>
        <xsl:value-of select="$snt"/>
        <xsl:text>foaf:primaryTopicOf &lt;</xsl:text><xsl:value-of select="$srpuri"/>/html<xsl:text>&gt;</xsl:text>
        
        <xsl:if test="t:idno[@type='URI' and starts-with(., 'http://en.wikipedia.org')]">
            <xsl:for-each select="t:idno[@type='URI' and starts-with(., 'http://en.wikipedia.org')]">
                    <xsl:value-of select="$cntt"/>
                <xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>&gt;</xsl:text>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="t:idno[@type='URI' and (starts-with(., 'http://en.wikipedia.org') or starts-with(., 'http://pleiades.stoa.org/places/'))]">
            <xsl:variable name="first" select="t:idno[@type='URI' and (starts-with(., 'http://en.wikipedia.org') or starts-with(., 'http://pleiades.stoa.org/places/'))][1]"/>
            <xsl:value-of select="$snt"/>
            <xsl:text>owl:sameAs </xsl:text>
            <xsl:for-each select="t:idno[@type='URI' and starts-with(., 'http://en.wikipedia.org')]">
                <xsl:if test="$first != .">
                    <xsl:value-of select="$cntt"/>
                </xsl:if>
                <xsl:text>&lt;http://dbpedia.org/resource/</xsl:text><xsl:value-of select="substring-after(., 'wiki/')"/><xsl:text>&gt;</xsl:text>
            </xsl:for-each> 
            <xsl:for-each select="t:idno[@type='URI' and starts-with(., 'http://pleiades.stoa.org/places')]">
                <xsl:if test="$first != .">
                    <xsl:value-of select="$cntt"/>
                </xsl:if>
                <xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>#this&gt;</xsl:text>
            </xsl:for-each>
        </xsl:if> 
        
        
        
        <xsl:value-of select="$pn"/>
        <xsl:value-of select="$n"/>
        <xsl:if test="t:idno[@type='URI' and not(starts-with(., 'http://syriaca.org'))]">
            <xsl:variable name="first" select="t:idno[@type='URI' and not(starts-with(., 'http://syriaca.org'))][1]"/>
            <xsl:text>&lt;</xsl:text><xsl:value-of select="$srpuri"/>/html<xsl:text>&gt; </xsl:text>
            <xsl:text>a foaf:Document, bibo:Webpage</xsl:text>
            <xsl:value-of select="$snt"/>
            <xsl:text>cito:citesForInformation </xsl:text>
            <xsl:for-each select="t:idno[@type='URI' and not(starts-with(., 'http://syriaca.org'))]">
                <xsl:if test="$first != .">
                    <xsl:value-of select="$cntt"/>
                 </xsl:if>
                <xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>&gt;</xsl:text>                
            </xsl:for-each>
            <xsl:call-template name="contributors">
                <xsl:with-param name="term">dcterms:contributor</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:value-of select="$pn"/>
        
        <!-- annotations about placenames -->
        <xsl:apply-templates select="t:placeName"/>
        
        <xsl:value-of select="$n"/>
        <xsl:text>&lt;</xsl:text><xsl:value-of select="$agenturi"/><xsl:text>&gt; a prov:SoftwareAgent</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>foaf:homepage &lt;</xsl:text><xsl:value-of select="$agenturi"/><xsl:text>&gt;</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>foaf:name "place2ttl"</xsl:text>
        <xsl:value-of select="$pn"/>
    </xsl:template>
    
    <xsl:template match="t:titleStmt">
        <xsl:value-of select="$snt"/>
        <xsl:text>rdfs:label "</xsl:text><xsl:value-of select="normalize-space(t:title)"/><xsl:text>"</xsl:text>
        <xsl:call-template name="lang">
            <xsl:with-param name="langcontext" select="t:title"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="t:desc">
        <xsl:value-of select="$snt"/>
        <xsl:text>rdfs:comment "</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text>
        <xsl:call-template name="lang"/>
    </xsl:template>
    
    <xsl:template match="t:idno[@type='URI']" mode="wikipedia">
        <xsl:value-of select="$snt"/>
        <xsl:text>foaf:primaryTopicOf </xsl:text>
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template match="t:placeName">
        <!-- serialize the basic annotation -->
        <xsl:value-of select="$n"/>
        <xsl:variable name="annoid"><xsl:call-template name="getAnnoID"/></xsl:variable>
        <xsl:variable name="bodyid"><xsl:value-of select="$annoid"/>/body</xsl:variable>
        <xsl:text>&lt;</xsl:text><xsl:value-of select="$annoid"/><xsl:text>&gt; a oa:Annotation</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>oa:hasBody &lt;</xsl:text><xsl:value-of select="$bodyid"/><xsl:text>&gt;</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>oa:hasTarget &lt;</xsl:text><xsl:value-of select="$srpuri"/><xsl:text>&gt;</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>oa:motivatedBy oa:identifying</xsl:text>
        <xsl:call-template name="contributors"/>
        <xsl:value-of select="$snt"/>
        <xsl:text>oa:annotatedAt "</xsl:text>
        <xsl:value-of select="$docroot/descendant::t:publicationStmt/t:date"/><xsl:text>T00:00:01Z"</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>oa:serializedBy &lt;</xsl:text>
        <xsl:value-of select="$agenturi"/>
        <xsl:text>&gt;</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>oa:serializedAt "</xsl:text>
        <xsl:value-of select="current-dateTime()"/><xsl:text>"</xsl:text>
        
        
        
        
        <!-- serialize the annotation body (i.e., the placename itself -->
        <xsl:value-of select="$pn"/>
        <xsl:value-of select="$n"/>
        <xsl:text>&lt;</xsl:text><xsl:value-of select="$bodyid"/><xsl:text>&gt; a cnt:ContentAsText, dctypes:Text</xsl:text>
        <xsl:value-of select="$snt"/>
        <xsl:text>cnt:chars "</xsl:text><xsl:value-of select="normalize-space()"/><xsl:text>"</xsl:text>
        <xsl:call-template name="lang"/>
        <xsl:value-of select="$snt"/>
        <xsl:text>dc:format "text/plain"</xsl:text>
        <xsl:if test="@source">
            <xsl:variable name="sources" select="tokenize(@source, ' ')"/>
            <!-- serialize sources as citesAsSourceDocument --> 
            <xsl:for-each select="$sources">
                <xsl:value-of select="$snt"/>
                <xsl:text>cito:citesAsSourceDocument </xsl:text>
                <xsl:choose>
                    <xsl:when test="starts-with(., '#')">
                        <xsl:variable name="tgt" select="substring-after(., '#')"/>
                        <xsl:apply-templates select="$docroot/descendant-or-self::t:*[@xml:id=$tgt]" mode="citesource"/>
                    </xsl:when>
                    <xsl:when test="starts-with(., 'http://syriaca.org')">
                        <xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>/html&gt;</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with(., 'http://')">
                        <xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>failwhale</xsl:text>
                        <xsl:message>FAIL</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
        <xsl:value-of select="$pn"/>
    </xsl:template>
    
    
    <xsl:template name="getAnnoID">
        <xsl:value-of select="$srpuri"/>/anno/<xsl:value-of select="lower-case(local-name(.))"/><xsl:value-of select="count(preceding::*[name(current())=name(.)])+1"/><xsl:text></xsl:text>
    </xsl:template>
    
    <xsl:template name="lang">
        <xsl:param name="langcontext" select="."/>

        <xsl:text>@</xsl:text>
        <xsl:choose>
            <xsl:when test="$langcontext/@lang">
                <xsl:text></xsl:text><xsl:value-of select="$langcontext/@lang"/><xsl:text></xsl:text>
            </xsl:when>
            <xsl:when test="$langcontext/@xml:lang">
                <xsl:text></xsl:text><xsl:value-of select="$langcontext/@xml:lang"/><xsl:text></xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>en</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>  
    
    <xsl:template match="t:*" mode="citesource">
        <xsl:if test="self::t:bibl and t:ptr[starts-with(@target, 'http://')]">
            <xsl:text>&lt;</xsl:text><xsl:value-of select="t:ptr/@target"/><xsl:text>&gt;</xsl:text>
        </xsl:if>
        <xsl:if test="self::t:bibl">
            <xsl:value-of select="$snt"/>
            <xsl:text>dcterms:biblographicCitation </xsl:text>
            <xsl:text> "</xsl:text><xsl:value-of select="t:title"/><xsl:text></xsl:text>
            <xsl:choose>
                <xsl:when test="t:citedRange">
                    <xsl:choose>
                        <xsl:when test="t:citedRange/@unit='pp' and contains(t:citedRange, '-')">
                            <xsl:text>, pp. </xsl:text>
                        </xsl:when>
                        <xsl:when test="t:citedRange/@unit='pp'">
                            <xsl:text>, p. </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="t:citedRange/@unit"/><xsl:text>. </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>                    
                    <xsl:value-of select="t:citedRange"/><xsl:text>"</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>"</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="lang">
                <xsl:with-param name="langcontext" select="t:title"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="contributors">
        <xsl:param name="term">oa:annotatedBy</xsl:param>
        <xsl:if test="$docroot/descendant::t:revisionDesc/t:change">
            <xsl:value-of select="$snt"/>
            <xsl:value-of select="$term"/><xsl:text> </xsl:text>
            <xsl:variable name="first" select="$docroot/descendant::t:revisionDesc/t:change[last()]"/>
            <xsl:for-each-group select="$docroot/descendant::t:revisionDesc/t:change" group-by="@who">   
                <xsl:sort select="@when"/>
                <xsl:if test="$first/@who != current-grouping-key()">
                    <xsl:value-of select="$cntt"/>
                </xsl:if>
                <xsl:text>&lt;</xsl:text><xsl:value-of select="@who"/><xsl:text>&gt;</xsl:text>
            </xsl:for-each-group>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="t:*"/>
    
    
</xsl:stylesheet>