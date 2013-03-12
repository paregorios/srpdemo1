<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="/">
        <html>
            <body>
                <h2>SRP Places</h2>
                <table border="1">
                    <tr bgcolor="#cccccc">
                        <th>SRP Name</th>
                    </tr>
                    <xsl:for-each select="//place">
                        <tr>
                            <td><xsl:value-of select="placeName[1]"/></td>
                        </tr>                               
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>