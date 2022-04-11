<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8"/>
    
    <!-- roottext permet de ne récupérer que le texte à la racine d'un elt -->

    <xsl:template match="TEI">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="teiHeader"/>
    
    <xsl:template match="body//ab">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="body//app[not(lem/*)]"/>
    
    <xsl:template match="body//app[lem/*]" name="yes">
        <xsl:variable name="roottext">
            <xsl:variable name="src">
            <xsl:value-of select="./lem/text()"/>
        </xsl:variable>
            <xsl:copy-of select="replace($src, '\s+', ' ')"/>    
        </xsl:variable>
        <xsl:value-of select="$roottext"/>
        AAAAAAAAAAAAAAAAA
    </xsl:template>
    
    
    
</xsl:stylesheet>