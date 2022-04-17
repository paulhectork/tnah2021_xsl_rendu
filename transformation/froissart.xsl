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
            % paramétrage général
            \documentclass[12pt, a4paper]{report}
            \usepackage[utf8x]{inputenc}
            \usepackage[T1]{fontenc}
            \usepackage{fontspec}
            \usepackage{lmodern}
            \usepackage{graphicx}
            \usepackage[french]{babel}
            \usepackage{reledmac}
            \usepackage[switch, modulo]{lineno}
            
            % définition de commandes spécifiques pour l'apparat
            % variation de 1er degré
            \newcommandx{\variant}[2][1,usedefault]{\Afootnote[#1]{#2}}
            % groupe de témoins
            \newcommandx{\group}[2][1,usedefault]{\Bfootnote[#1]{#2}}
            % sous-variation (un rdg dans un apparat interne)
            \newcommandx{\subvariant}[2][1,usedefault]{\Cfootnote[#1]{#2}}
            % détails non textuels sur le témoin
            \newcommandx{\explan}[2][1,usedefault]{\Dfootnote[#1]{#2}}
            
            \Xarrangement[A]{paragraph}
            \Xparafootsep{$\parallel$~}
            
            <!-- IL FAUDRA DEF DES METADONNEES DANS LE LATEX -->
            
            \begin{document}
            
            <!-- header -->
            <xsl:call-template name="header"/>
            
            <!-- corps de texte -->
            \beginnumbering
            \linenumbers
            \pstart
            <!-- nettoyer le latex produit à grands coups de regex -->
            <xsl:variable name="body">
                <xsl:call-template name="body"/>
            </xsl:variable>
            <xsl:variable name="clean1">
                <xsl:value-of select="replace($body, '\s{2,}', ' ')"/>
            </xsl:variable>
            <xsl:variable name="clean2">
                <xsl:value-of select="replace($clean1, '\}([a-zA-Z])', '} $1')"/>
            </xsl:variable>
            <xsl:variable name="clean3">
                <xsl:value-of select="replace($clean2, '(\w|[0-9])\\edtext\{([^(,\.;?!)])', '$1 \\edtext{$2')"/>
            </xsl:variable>
            <xsl:variable name="clean4">
                <xsl:value-of select="replace($clean3, '(\}?) ((\\edtext\{)?(\.|,))', '$1$2')"/>
            </xsl:variable>
            <xsl:variable name="clean5">
                <xsl:value-of select="replace($clean4, '(\w)\s+(,|\.)', '$1$2')"/>
            </xsl:variable>
            <xsl:variable name="clean6">
                <xsl:value-of select="replace($clean5, '(,|\.)(\\edtext\{)?([\w])', '$1 $2$3')"/>
            </xsl:variable>
            <xsl:variable name="clean7">
                <xsl:value-of select="replace($clean6, '([a-z])([A-Z])', '$1 $2')"/>
            </xsl:variable>
            <xsl:value-of select="$clean7"/>
            \pend
            \endnumbering
            \end{document}
        </xsl:result-document>
        
    </xsl:template>
    
    <!-- 
        documentation REDELMAC
        https://texlive.mycozy.space/macros/latex/contrib/reledmac/reledmac.pdf
        
        
        structure pour les nested footnotes :
        - pour les \group
        \edtext{\edtext{<txt>}{\variant{<txt> <wit>}}}{\group{<txt>}}
        - pour les \explan
        \edtext{\edtext{<txt>}{\variant{<txt> <wit>}}}{\explan{<txt>}}
        - pour les \subvariant
        \edtext{<txt> \edtext{<txt>}{\subvariant{<txt> <wit>}}\edtext{<txt>}{\subvariant{<txt> <wit>}}}{\variant{<txt>}}
    -->    
    
    
    <!-- ########################################################## -->
    <!-- ################ RÈGLES POUR LE TEIHEADER ################ -->
    <!-- ########################################################## -->
    <xsl:template name="header" match="teiHeader"/>
    
    
    
    
    <!-- ########################################################## -->
    <!-- ############# RÈGLES POUR LE CORPS DU TEXTE ############## -->
    <!-- ########################################################## -->
    
    <!-- copier le conteneur ab et le texte à la racine -->
    <xsl:template name="body" match="body/ab">
        <!-- copier ab et le texte à la racine -->
        <xsl-copy select=".">
            <xsl:apply-templates/>
        </xsl-copy>
    </xsl:template>
    
    
    <!-- règles pour construire l'apparat critique --> <!-- A COMPLETER -->
    <xsl:template match="body//app">
        <xsl:choose>
            
            <!-- sélectionner les lem qui contiennent du texte mais qui 
                n'ont pas d'enfants, ne sont pas dans un apparat interne et
                dont le app parent ne contient pas de rdgGrp -->
            <xsl:when test="lem[not(./*)][not(ancestor::*/rdgGrp)][not(ancestor::app//app)]">
                <xsl:text>\edtext{</xsl:text>
                <xsl:apply-templates select="lem"/>
                <xsl:text>}{\variant{</xsl:text>
                <xsl:call-template name="notinternal"/>
                <xsl:text>}}</xsl:text>
            </xsl:when>
            
            <!-- règle pour les lem dont qui sont dans un app avec un rdgGrp ;
                y inclure des règles spécifiques si le lem contient un saut de page -->
            <xsl:when test=".//rdgGrp">
                <xsl:if test=".//lem//pb">
                    <xsl:text>\edtext{</xsl:text>
                </xsl:if>
                <xsl:text>\edtext{</xsl:text>
                <xsl:apply-templates select="lem"/>
                <xsl:text>}{\group{</xsl:text>
                <xsl:call-template name="grp"/>
                <xsl:text>}}</xsl:text>
                <xsl:if test=".//lem//pb">
                    <xsl:text>}{\explan{Changement de page dans la leçon principale : 
                        passage au folio </xsl:text>
                    <xsl:value-of select="lem//pb/@n"/>
                    <xsl:text>.}}</xsl:text>   
                </xsl:if>
            </xsl:when>
            
            <!-- règle pour les lem contenant un apparat interne -->
            <xsl:when test="lem//app">
                <xsl:text>\edtext{</xsl:text>
                <xsl:copy select=".">
                    <xsl:apply-templates/>
                </xsl:copy>
                <xsl:text>}</xsl:text>
                <xsl:text>{\variant{</xsl:text>
                <xsl:call-template name="notinternal"/>
                <xsl:text>}}</xsl:text>
            </xsl:when>
            
            <!-- règle pour  lem contenant des noms de lieux et de personnes -->
            <xsl:when test="lem[.//persName | .//placeName]">
                <xsl:text>\edtext{</xsl:text>
                <xsl:apply-templates select="lem"/>
                <xsl:apply-templates select="placeName | persName"/>
                <xsl:text>}{\variant{</xsl:text>
                <xsl:call-template name="notinternal"/>
                <xsl:text>}}</xsl:text>    
            </xsl:when>
            
            <!-- récupérer les witDetail et de les mettre dans un \explan -->
            <xsl:when test="lem[witDetail]">
                <xsl:text>\edtext{</xsl:text>
                <xsl:text>\edtext{</xsl:text>
                <xsl:apply-templates select="lem/text()"/>
                <xsl:text>}{\variant{</xsl:text>
                <xsl:call-template name="notinternal"/>
                <xsl:text>}}}{\explan{</xsl:text>
                <xsl:value-of select="lem/witDetail"/>
                <xsl:text>}}</xsl:text>    
            </xsl:when>
            
            <!-- sélectionner les lem qui contiennent un changement de paragraphe -->
            <xsl:when test="lem//milestone">
                <xsl:text> \pend\pstart \edtext{</xsl:text>
                <xsl:apply-templates select="lem"/>
                <xsl:text>}{\explan{</xsl:text>
                <xsl:text>Changement de paragraphe dans le témoin principal</xsl:text>
                <xsl:text>.}}</xsl:text>
            </xsl:when>
            
            <!-- récupérer les indications pour le premier saut de page du lem et 
                l'inclure dans un \explan (le premier saut de page ne contient 
                pas de texte et est le seul saut de page dans un apparat qui ne contient 
                pas de rdgGrp) -->
            <xsl:when test="lem[.//pb][not(parent::app//rdgGrp)]">
                <xsl:text>\edtext{</xsl:text>
                <xsl:apply-templates select="lem/text()"/>
                <xsl:text>}</xsl:text>
                <xsl:text>{\explan{</xsl:text>
                <xsl:text>La leçon principale débute au folio </xsl:text>
                <xsl:value-of select="lem//pb/@n"/>
                <xsl:text>.}}</xsl:text>    
            </xsl:when>
            
        </xsl:choose>  
    </xsl:template>    
    
    
    <!-- règle pour les lem contenant des apparats internes -->
    <xsl:template match="lem//app" name="leminternal">
        <xsl:text>\edtext{</xsl:text>
        <xsl:value-of select=".//lem"/>
        <xsl:text>}{\subvariant{</xsl:text>
        <xsl:call-template name="internal"/>
        <xsl:text>}}</xsl:text>
    </xsl:template>
    
    
    <!-- règle pour les rdg qui ne sont pas contenus dans des app internes -->
    <xsl:template match="body//rdg[not(ancestor::rdgGrp)][not(ancestor::app//app)]" name="notinternal">
        
        <!-- règle pour les leçons n'ayant pas d'enfants (à part placeName et persName)
            et n'étant pas dans un rdgGrp -->
        <xsl:for-each select="rdg[not(./*)] | rdg[.//placeName] | rdg[.//persName]">
            <!-- si ils contiennent du texte, le recopier; sinon, symbole vide -->
            <xsl:choose>
                <xsl:when test="./matches(., '(\w+|,|\.)+')">
                    <xsl:value-of select="."/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test=".//persName | .//placeName">
                    <xsl:apply-templates select="rdg"/><xsl:text> </xsl:text>
                    <xsl:apply-templates select="persName | placeName"/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>$\phi$</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:value-of select="./replace(@wit, '#', ' ')"/>
            <xsl:choose>
                <xsl:when test="position() != last()">; </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>  
        </xsl:for-each>
        
    </xsl:template>
    
    
    <!-- règle pour les rdg dans des apparats internes -->
    <xsl:template match="body//app//app/rdg" name="internal">
        
        <!-- règle pour les leçons n'ayant pas d'enfants -->
        <xsl:for-each select="rdg">
            <!-- si ils contiennent du texte, le recopier; sinon, symbole vide -->
            <xsl:choose>
                <xsl:when test="matches(., '(\w+|,|\.)+')">
                    <xsl:value-of select="."/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>$\phi$</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:value-of select="./replace(@wit, '#', ' ')"/>
            <xsl:choose>
                <xsl:when test="position() != last()">; </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            
        </xsl:for-each>
        
    </xsl:template>
    
    
    <!-- règle pour les rdgGrp -->
    <xsl:template match="body//rdgGrp" name="grp">
        <xsl:for-each select=".//rdg">
            <!-- si ils contiennent du texte ou un nom de personne/lieu, le recopier; sinon, symbole vide -->
            <xsl:choose>
                <xsl:when test="matches(., '(\w+|,|\.)+')">
                    <xsl:value-of select="."/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test=".//persName | .//placeName">
                    <xsl:apply-templates select="rdg"/><xsl:text> </xsl:text>
                    <xsl:apply-templates select="persName | placeName"/><xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>$\phi$</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:value-of select="./replace(@wit, '#', ' ')"/>
            <xsl:choose>
                <xsl:when test="position() != last()">; </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each> 
    </xsl:template>
    
    
    <!-- règles pour gérer les espaces autour des placeName et persName -->
    <xsl:template match="body//placeName">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="body//persName">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>
    
    
</xsl:stylesheet>