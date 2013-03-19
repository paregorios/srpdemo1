<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.tei-c.org/ns/1.0"
    version="1.0">
    <xsl:template match="/">
        <html>
            <body>
                <h2>SRP Places</h2>
                <table border="1">
                    <tr bgcolor="#cccccc">
                        <th>SRP Name</th>
                        <th>SRP Type</th>
                        <th>SRP URI</th>
                    </tr>
                    <xsl:for-each select="//t:place">
                        <xsl:sort select="t:placeName[2]"/>
                        <tr>
                            <td><xsl:value-of select="t:placeName[1]"/></td>
                            <td><xsl:value-of select="@type"/></td>
                            <td><xsl:value-of select="t:idno[1]"/></td>
                        </tr>                               
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>