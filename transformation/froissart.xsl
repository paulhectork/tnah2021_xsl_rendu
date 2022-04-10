<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="TEI">
        <xsl:variable name="appfile">
            <xsl:value-of select="replace(base-uri(.), '.xml', '')"/> 
        </xsl:variable>
        
        <xsl:result-document href="{concat($appfile, '.tex')}"> 
            \documentclass[12pt, a4paper]{report}
            \usepackage[utf8x]{inputenc}
            \usepackage[T1]{fontenc}
            \usepackage{lmodern}
            \usepackage{graphicx}
            \usepackage[french]{babel}
            \usepackage{reledmac}
            \usepackage[switch, modulo]{lineno}
            
            % définition de commandes spécifiques pour l'apparat
            \newcommandx{\variant}[2][1,usedefault]{\Afootnote[#1]{#2}}
            \newcommandx{\explanation}[2][1,usedefault]{\Bfootnote[#1]{#2}}
            
            \Xarrangement[A]{paragraph}
            \Xparafootsep{$\parallel$~}
            
            \begin{document}
            
            <!-- header -->
            <xsl:call-template name="header"/>
            
            <!-- numérotation
                \firstlinenum{5}
                \linenumincrement{5}
                \linenummargin{right} -->
            <!-- \setline{<xsl:value-of select="//lg/l[1]/@n"/>} -->
            
            
            <!-- corps de texte -->
            \beginnumbering
            \linenumbers
            \pstart
            <xsl:call-template name="body"/>
            \pend
            \endnumbering
            \end{document}
        </xsl:result-document>
        
    </xsl:template>
    
    <!-- 
        documentation REDELMAC
        https://texlive.mycozy.space/macros/latex/contrib/reledmac/reledmac.pdf
    -->    
    <!-- 
        Le package fonctionne sur un système d’étage de note : 
        \Afootnote \Bfootnote \Cfootnote 
        qui permette de créer différents étages d’apparat. 
    -->
    
    <xsl:template name="header" match="teiHeader"/>
    
    <xsl:template name="body" match="body/ab">
        <!-- copier ab et le texte à la racine -->
        <xsl-copy select=".">
            <xsl:apply-templates/>
        </xsl-copy>
    </xsl:template>
    
    <xsl:template match="body//app">
        
        <!-- sélectionner les lem qui contiennent du texte -->
        <xsl:if test="lem[matches(., '(\w+|,|\.)+')]">
            <xsl:text>\edtext{</xsl:text>
            <xsl:apply-templates select="lem[matches(., '(\w+|,|\.)+')]"/>
            <xsl:text>}{\variant{</xsl:text>
            
            <!-- sélectionner les rdg qui n'ont pas d'enfants -->
            <xsl:for-each select="rdg[not(./*)]">
                
                <!-- si ils contiennent du texte, le recopier; sinon, symbole vide -->
                <xsl:choose>
                    <xsl:when test="./matches(., '(\w+|,|\.)+')">
                        <xsl:value-of select="."/><xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>$\phi$</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:value-of select="./replace(@wit, '#', ' ')"/>
                <xsl:choose>
                    <xsl:when test="position() != last()">, </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>   
                
            </xsl:for-each>
            
            <xsl:text>}}</xsl:text>
        </xsl:if>
        
        <!--
        <xsl:if test="lem[./witDetail]">
            <xsl:text>\edtext{</xsl:text>
            <xsl:apply-templates select="lem[./witDetail]"/>
            <xsl:text>}{\explanation{</xsl:text>
            <xsl:value-of select="witDetail"/>
            <xsl:text>}</xsl:text>
        </xsl:if> -->
        
    </xsl:template>

    
    <!-- pour le texte ne contenant pas d'éléments dans le ab
        <xsl:value-of select=".//ab/text()"/> -->
    
    <!-- pour tout ce qui est dans le ab 
        <xsl:choose> -->
    
    <!-- si c'est un texte
        <xsl:when test="./text()">
        </xsl:when> -->
    
    <!-- si c'est un élément
        <xsl:otherwise><xsl:apply-templates/></xsl:otherwise> -->
    <!-- <xsl:choose> -->
    
    <!-- si l'élément est un app
        <xsl:when test="app">
        <xsl:choose>
        <xsl:when test="//lem">
        <xsl:text>\edtext{</xsl:text>
        <xsl:copy-of select="."/><xsl:text>}\{Afootnote{</xsl:text>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        </xsl:when> -->
    
    <!-- si il n'est pas un app
        <xsl:otherwise></xsl:otherwise>
        
        </xsl:choose>
        </xsl:otherwise> -->
    
    <!--</xsl:choose>-->
    
    <!-- <xsl:for-each select="//text//ab/app">
        <xsl:choose>
        <xsl:when test="./lem">
        <xsl:value-of select="."/>
        </xsl:when>
        </xsl:choose>
        <xsl:value-of select="."/>
        </xsl:for-each> -->
    
    
</xsl:stylesheet>