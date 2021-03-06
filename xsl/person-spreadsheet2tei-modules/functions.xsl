<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:functx="http://www.functx.com">
    <xd:doc>
        <xd:desc>
            <xd:p>Escapes characters with special meaning in regex (regular expressions) 
                so that strings containing these characters can be processed as text (rather than as regex).</xd:p>
        </xd:desc>
        <xd:param name="arg">The string containing regex characters to be escaped</xd:param>
        <xd:return>The string with regex characters escaped.</xd:return>
    </xd:doc>
    <xsl:function name="functx:escape-for-regex" as="xs:string" 
        xmlns:functx="http://www.functx.com" >
        <xsl:param name="arg" as="xs:string?"/> 
        
        <xsl:sequence select=" 
            replace($arg,
            '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
            "/>
        
    </xsl:function>
</xsl:stylesheet>