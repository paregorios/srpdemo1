<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:t="http://www.tei-c.org/ns/1.0">
        <xsl:template match="/">
            <html>
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                    <title>
                        <xsl:value-of select="//t:title"/>
                    </title>
                </head>
                <body>
                    <h1>
                        <xsl:choose>
                            <xsl:when test="//t:place/t:placeName[@xml:lang='syr']">
                                <xsl:value-of select="//t:place/t:placeName[@xml:lang='syr']"/>
                                (<xsl:value-of select="//t:place/t:placeName[@xml:lang='en']"/>)
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="//t:place/t:placeName[@xml:lang='en']"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </h1>
                    <table cellpadding="10">
                        <tr>
                            <xsl:for-each select="//t:place/t:placeName">
                                <td><xsl:value-of select="current()"/></td> 
                            </xsl:for-each>
                        </tr>
                    </table>
                </body>
            </html>
        </xsl:template>
</xsl:stylesheet>