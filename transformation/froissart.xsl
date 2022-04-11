<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    <xsl:output method="text" encoding="UTF-8"/>
    
    <!-- roottext permet de ne récupérer que le texte à la racine d'un elt -->
    <xsl:variable name="roottext">
        <xsl:variable name="src">
            <xsl:copy-of select="./lem/text()"/>
        </xsl:variable>
        <xsl:value-of select="$src"/>    
    </xsl:variable>
    
    
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
            \newcommandx{\subvariant}[2][1,usedefault]{\Bfootnote[#1]{#2}}
            \newcommandx{\explan}[2][1,usedefault]{\Cfootnote[#1]{#2}}
            
            \Xarrangement[A]{paragraph}
            \Xparafootsep{$\parallel$~}
            
            \begin{document}
            
            <!-- header -->
            <xsl:call-template name="header"/>
            
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
        
        <!-- sélectionner les lem qui contiennent du texte 
            mais qui n'ont pas d'enfants -->
        <xsl:choose>
            <xsl:when test="lem[matches(., '(\w+|,|\.)+')][not(./*)]">
                <xsl:text>\edtext{</xsl:text>
                <xsl:apply-templates select="lem[matches(., '(\w+|,|\.)+')]"/>
                <xsl:text>}{\variant{</xsl:text>
                <xsl:call-template name="rdgnochild"/>
                <xsl:text>}}</xsl:text>
            </xsl:when>
            
            <!-- règles pour les autres lem ... -->
            
            <!-- règle pour les apparats critiques dans des lem -->
            <xsl:when test="lem[.//app]">
                <xsl:text>\edtext{</xsl:text>
                <xsl:text>\edtext{</xsl:text>
                <xsl:copy-of select="./lem[//app]/text()"/>
                <xsl:text>}{\variant{</xsl:text>
                <xsl:call-template name="rdgnochild"/>
                <xsl:text>}}}{\subvariant{</xsl:text>
                <!-- faire une règle pour choper les sous-variations dans rdg 
                PEUT-ÊTRE UTILISER DES VARIABLES pour capturer les différentes variations ??? -->
                <xsl:text>}}</xsl:text>    
            </xsl:when>
            
            <!-- récupérer les witDetail et de les mettre dans un \explan -->
            <!-- ETENDRE POUR CONTENIR LES AUTRES DÉTAILLS ?? -->
            <xsl:when test="lem[witDetail]">
                <xsl:text>\edtext{</xsl:text>
                <xsl:text>\edtext{</xsl:text>
                <xsl:copy-of select="./lem[witDetail]/text()"/>
                <xsl:text>}{\variant{</xsl:text>
                <xsl:call-template name="rdgnochild"/>
                <xsl:text>}}}{\explan{</xsl:text>
                <xsl:value-of select="lem/witDetail"/>
                <xsl:text>}}</xsl:text>    
            </xsl:when>
            
            <!-- 
                structure pour les nested footnotes 
                \edtext{\edtext{<txt>}{\variant{<txt> <wit>}}}{\explan{<txt>}}
            -->
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="body//app/rdg" name="rdgnochild">
        
        <!-- règle pour les leçons n'ayant pas d'enfants -->
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
        
        <!-- règles pour les autres rdg ... -->
        
    </xsl:template>
    
</xsl:stylesheet>