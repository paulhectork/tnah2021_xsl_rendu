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
        
        
        
        <!-- ################ STRUCTURE D'ACCUEIL ################ -->
        
        <xsl:result-document href="{concat($appfile, '.tex')}">
            <!-- paramétrage du latex -->
            % métadonnées
            \author{Paul, Hector KERVEGAN}
            \title{Transformation XSL d'une édition critique en XML-TEI vers LaTeX: les Chroniques de Jean Froissart, SHF 306: "La négociation du mariage du duc de Berry"}
            \date{25.04.2022}
            
            
            % chouettes paquets utilisés
            \documentclass[12pt, a4paper]{article}
            \usepackage[utf8x]{inputenc}
            \usepackage[T1]{fontenc}
            \usepackage{fontspec}
            \usepackage{lmodern}
            \usepackage{graphicx}
            \usepackage[french]{babel}
            \usepackage{reledmac}
            \usepackage[switch, modulo]{lineno}
            \usepackage[toc]{appendix}
            
            % hyperref
            \usepackage{hyperref}
            \hypersetup{pdfauthor={Paul, Hector KERVEGAN}, pdftitle={Transformation XSL d'une édition critique en XML-TEI vers LaTeX: les Chroniques de Jean Froissart, SHF 306: "La négociation du mariage du duc de Berry"}, pdfsubject={Transformation XSL vers LaTeX}, pdfkeywords={édition critique}{XSL}{XML-TEI}{LaTeX}{Jean Froissart}}
            
            
            <!-- définition de commandes spécifiques pour l'apparat -->
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
            
            \begin{document}
            
            <!-- page de titre -->
            \begin{titlepage}
            \begin{center}
            \large
            Paul, Hector KERVEGAN
            
            \Large
            \vfill
            \textbf{Transformation XSL d'une édition critique en XML-TEI vers \LaTeX}
            \\~\\
            \textbf{\textit{CHRONIQUES} DE JEAN FROISSART, SHF 3A-306 : "LA NÉGOCIATION DU MARIAGE DU DUC DE BERRY"}
            \vfill
            
            \large	
            \vfill Devoir réalisé pour le master 2 TNAH de l'École nationale des Chartes - Avril 2022
            \end{center}
            \end{titlepage}
            
            <!-- header -->
            <xsl:variable name="header">
                \section{Présentation du projet}
                \subsection{Présentation de l'encodage XML-TEI et de sa source en ligne: l'Online Froissart}
                <xsl:call-template name="titlestmt"/>
                \subsection{Principes suivis pour l'encodage}
                \subsubsection{Principes suivis pour l'édition en XML-TEI}
                <xsl:call-template name="encodingdesc"/>
                \subsubsection{Principes suivis pour l'édition \LaTeX}
                <xsl:call-template name="latex"/>
                \subsection{Description des témoins}
                <xsl:call-template name="sourcedesc"/>
                \subsection{Présentation du texte encodé}
                <xsl:call-template name="profiledesc"/>
                \pagebreak
            </xsl:variable>
            <!-- nettoyage de la présentation à grands coups de regex -->
            <xsl:variable name="hdr1">
                <xsl:value-of select="replace($header, '\s+', ' ')"/>
            </xsl:variable>
            <xsl:variable name="hdr2">
                <xsl:value-of select="replace($header, '\.+', '.')"/>
            </xsl:variable>
            <xsl:value-of select="$hdr2"/>
            
            <!-- corps de texte -->
            \section{Édition critique}
            \beginnumbering
            \linenumbers
            \pstart    
            <!-- nettoyer le corps de l'édition latex à grands coups de regex -->
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
            
            \pagebreak
            \tableofcontents
            \end{document}
        </xsl:result-document>
        
    </xsl:template>
    
    
    
    <!-- ################ RÈGLES POUR LE TEIHEADER ################ -->
    
    <!-- règle pour le titleStmt qui appelle une règle pour le publicationStmt 
        (informations bibliographiques sur l'édition TEI) : construire des paragraphes
        descriptifs -->
    <xsl:template name="titlestmt" match="titleStmt">
        
        <!-- informations biblio sur l'encodage XML TEI -->
        \subsubsection{À propos du présent encodage}
        <xsl:text>La présente édition critique d'un chapitre des \textit{</xsl:text>
        <xsl:value-of select=".//titleStmt//title"/>
        <xsl:text>} de </xsl:text>
        <xsl:value-of select=".//titleStmt//author"/>
        <xsl:text> a été encodée en XML-TEI par </xsl:text>
        <xsl:value-of select=".//titleStmt//principal"/>
        <xsl:text>. L'encodage s'appuie sur une édition en ligne des \textit{Chroniques} 
            réalisée dans le cadre du projet Online Froissart.\\ \indent L'encodage en XML-TEI a été 
            réalisé dans le cadre l'évaluation du cours de TEI du master 2 TNAH de l'</xsl:text>
        <xsl:call-template name="pubstmt"/>
        <xsl:text> Le présent document résulte d'une transformation XSL vers \LaTeX  réalisée
            en avril 2022 dans le cadre de l'évaluation du cours d'XSLT de ce master.</xsl:text>
        
        <!-- informations sur le Online Froissart -->
        \subsubsection{À propos du projet Online Froissart}
        <xsl:value-of select="//titleStmt//respStmt[1]/resp"/>
        <xsl:text> \href{</xsl:text>
        <xsl:value-of select="//titleStmt//respStmt[1]//@target"/>
        <xsl:text>}{\textit{</xsl:text>
        <xsl:value-of select="//titleStmt//respStmt[1]//ref"/>
        <xsl:text>}}. La source de l'encodage est disponible à \href{https://www.dhi.ac.uk/onlinefroissart/browsey.jsp?f=b&amp;pb2=Ber-3_SHF_3A-307&amp;disp2=shf&amp;GlobalWord=0&amp;div2=ms.f.transc.Ber-3&amp;div1=ms.f.transc.Bre-3&amp;div0=ms.f.transc.Ant-3&amp;panes=3&amp;GlobalMode=shf&amp;img0=&amp;disp0=shf&amp;disp1=shf&amp;pb1=Bre-3_SHF_3A-307&amp;img2=&amp;GlobalShf=3A-306&amp;pb0=Ant-3_SHF_3A-307&amp;img1=}{cette adresse}.\\~\\
        </xsl:text>
        
        <xsl:text>\noindent </xsl:text>
        <xsl:value-of select="//titleStmt//respStmt[2]/resp"/>
        <xsl:text> : \begin{itemize}</xsl:text>
        <xsl:for-each select="//titleStmt//persName">
            <xsl:text>\item{</xsl:text>
            <xsl:call-template name="hdrpersname"/>
            <xsl:text>} </xsl:text>
        </xsl:for-each>
        <xsl:text>\end{itemize} </xsl:text>
        
        <xsl:text>\noindent </xsl:text>
        <xsl:value-of select=".//titleStmt//respStmt[3]/resp"/>
        <xsl:text> : \begin{itemize}</xsl:text>
        <xsl:for-each select=".//titleStmt//respStmt[3]/orgName">
            <xsl:text>\item{</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>} </xsl:text>
        </xsl:for-each>
        <xsl:text>\end{itemize} </xsl:text>
        
    </xsl:template>
    
    
    <!-- règle pour le publicationStmt (informations bibliographiques sur l'édition TEI) -->
    <xsl:template match="publicationStmt" name="pubstmt">
        <xsl:value-of select=".//publisher"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select=".//pubPlace"/>
        <xsl:text>). L'encodage a été finalisé le </xsl:text>
        <xsl:value-of select=".//publicationStmt//date"/>
        <xsl:text>.</xsl:text>
    </xsl:template>
    
    
    <!-- règle pour le sourceDesc (information sur les témoins encodés) :
        construire 3 paragraphes descriptifs (un pour chaque témoin) -->
    <xsl:template name="sourcedesc" match="sourceDesc">
        <xsl:apply-templates select=".//witness[@xml:id='brl']"/>
        <xsl:text>\\~\\</xsl:text>
        <xsl:apply-templates select=".//witness[@xml:id='atw']"/>
        <xsl:text>\\~\\</xsl:text>
        <xsl:apply-templates select=".//witness[@xml:id='brn']"/>
    </xsl:template>
    
    
    <!-- règle pour le encodingDesc (principes d'encodages suivis en TEI) :
        récupérer le texte du encoding desc et ajouter à chaque type de variation
        un décompte du nombre de variations de ce type dans l'encodage -->
    <xsl:template name="encodingdesc" match="encodingDesc">
        <xsl:variable name="enc">
            <xsl:apply-templates select=".//p[not(parent::projectDesc)][not(parent::abstract)]"/>
        </xsl:variable>
        <xsl:value-of select="replace($enc, '((&lt;[^(&lt;|&gt;)]+&gt;)|(@[^\s]+))', '\\texttt{$1}')"/>
    </xsl:template>
    
    
    <!-- règle pour le profileDesc (aspects non bibliographiques des textes encodés) : 
        récupérer une présentation des Chroniques et du passage encodé, faire un index 
        des personnages, de leurs relations et des lieux. Pour l'index des personnages et des
        lieux, faire le décompte du nombre de mentions dans chaque témoin -->
    <xsl:template name="profiledesc" match="profileDesc">
        
        \subsubsection{À propos des \textit{Chroniques} de Froissart}
        <xsl:text>Datant du </xsl:text>
        <xsl:value-of select=".//profileDesc//origDate"/>
        <xsl:text>, les \textit{</xsl:text>
        <xsl:value-of select=".//profileDesc//title"/>
        <xsl:text>} de Froissart sont écrites en </xsl:text>
        <xsl:value-of select="replace(.//profileDesc//lang, 'M', 'm')"/>
        <xsl:text>. </xsl:text>
        <xsl:value-of select="replace(.//profileDesc//abstract/p, 'Les Chroniques de Froissart', 'Elles')"/>
        <xsl:text>\\ \indent </xsl:text>
        
        \subsubsection{À propos de l'extrait encodé}
        <xsl:value-of select="document('../odd_documentation/ODD_froissart.xml')//div3[contains(./head, 'Le second')]/p//text()"/>
        
        \subsubsection{Index des personnages}
        <xsl:call-template name="person"/>
        
        \subsubsection{Liste des relations dans l'extrait encodé}
        <xsl:call-template name="listrel"/>
        
        \subsubsection{Index des lieux}
        <xsl:call-template name="place"/>
        
    </xsl:template> 
    
    
    <!-- règle pour les witness -->
    <xsl:template match="witness">
        <!-- titre -->
        <xsl:text>\noindent \textbf{Manuscrit </xsl:text>
        <xsl:choose>
            <xsl:when test="matches(.//settlement, 'A.+')">
                <xsl:text>d' </xsl:text>
            </xsl:when>
            <xsl:otherwise>de </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select=".//settlement"/>
        <xsl:text> (\texttt{</xsl:text>
        <xsl:value-of select="./@xml:id"/>
        <xsl:text>})}\\
            
        </xsl:text>
        <!-- construire un paragraphe descriptif pour chaque manuscrit -->
        <xsl:text> \indent Le manuscrit </xsl:text>
        <xsl:choose>
            <xsl:when test="matches(.//settlement, 'A.+')">
                <xsl:text>d'</xsl:text>
            </xsl:when>
            <xsl:otherwise>de </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select=".//settlement"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select=".//country"/>
        <xsl:text>) a pour identifiant \textbf{\texttt{</xsl:text>
        <xsl:value-of select="./@xml:id"/>
        <xsl:text>}}. Il est conservé dans </xsl:text>
        <!-- définir un pronom -->
        <xsl:choose>
            <xsl:when test="matches(.//repository, 'C.+')">
                <xsl:text>la </xsl:text>
            </xsl:when>
            <xsl:when test="matches(.//repository, 'D.+')">
                <xsl:text>le </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>les </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select=".//repository"/>
        <xsl:choose>
            <xsl:when test="matches(.//institution, 'M.+')">
                <xsl:text> du </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> de la </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:value-of select=".//institution"/>
        <xsl:text>. Il a pour cote "</xsl:text>
        <xsl:value-of select=".//idno"/>
        <xsl:choose>
            <xsl:when test=".//msName">
                <xsl:text>" et est également connu sous le nom de \textit{</xsl:text>
                <xsl:value-of select=".//msName"/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>. Il est écrit en </xsl:text>
        <xsl:value-of select=".//textLang"/>
        <xsl:text> en </xsl:text>
        <xsl:value-of select=".//origDate"/>
        <xsl:if test=".//provenance">
            <xsl:text>. </xsl:text>
            <xsl:value-of select=".//provenance"/>
        </xsl:if>
        <xsl:if test=".//note">
            <xsl:text>. </xsl:text>
            <xsl:value-of select=".//note"/>
            <xsl:text>. Il est donc retenu comme présentant la \textbf{leçon principale}.
                Son contenu constitue le corps de texte de l'édition \LaTeX, et
                le \texttt{lem} de l'édition TEI</xsl:text>
        </xsl:if>
        <xsl:text>.\\ \indent Le manuscrit est écrit sur </xsl:text>
        <xsl:value-of select=".//support"/>
        <xsl:text>. Il est d'une longueur de </xsl:text>
        <xsl:value-of select=".//extent/text()"/>
        <xsl:text>.</xsl:text>
        <xsl:if test=".//dimensions">
            <xsl:text> Il mesure </xsl:text>
            <xsl:value-of select=".//height"/>
            <xsl:text> centimètres de hauteur, </xsl:text>
            <xsl:value-of select=".//width"/>
            <xsl:text> cm de largeur et </xsl:text>
            <xsl:value-of select=".//depth"/>
            <xsl:text> cm de profondeur.</xsl:text>
        </xsl:if>
        <xsl:text> Ces informations ont été proviennent de </xsl:text>
        <xsl:if test="matches(.//additional//ref, '(B|A).+')">
            <xsl:text>la </xsl:text>
        </xsl:if>
        <xsl:text>\href{</xsl:text>
        <xsl:value-of select=".//additional//@target"/>
        <xsl:text>}{</xsl:text>
        <xsl:value-of select=".//additional//ref/text()"/>
        <xsl:text>}.</xsl:text>
    </xsl:template>
    
    
    <!-- règle pour les paragraphes du encodingDesc : récupérer le texte, construire une
        \footnote à partir de l'élément bibl -->
    <xsl:template match="encodingDesc//p">
        <xsl:choose>
            <xsl:when test='.//list'>
                <xsl:copy select=".">
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test=".//bibl">
                <xsl:value-of select="./text()"/>
                <xsl:text>\footnote{</xsl:text>
                <xsl:variable name="auth">
                    <xsl:value-of select="./bibl//author"/>
                </xsl:variable>
                <xsl:value-of select="replace($auth, '([a-z])\s+([A-Z])', '$1, $2')"/>
                <xsl:text>, "</xsl:text>
                <xsl:value-of select="./bibl//title"/>
                <xsl:text>". \href{</xsl:text>
                <xsl:value-of select="./bibl//@target"/>
                <xsl:text>}{Disponible en ligne} (consulté le 18.04.22).}</xsl:text>
            </xsl:when>
            <xsl:when test=".//ref">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- règle pour les listes du encodingDesc -->
    <xsl:template match="encodingDesc//list">
        <xsl:text> \begin{itemize} </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> \end{itemize} </xsl:text>
    </xsl:template>
    
    
    <!-- règle pour les <item> du encoding desc : récupérer les types de variations et
        le nombre d'occurences de chacune -->
    <xsl:template match="encodingDesc//list//item">
        <xsl:choose>
            <xsl:when test="not(./@xml:id)">
                <xsl:text> \item{</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>} </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> \item{\textbf{\texttt{</xsl:text>
                <xsl:variable name="xmlid" select="./@xml:id"/>
                <xsl:value-of select="$xmlid"/>
                <xsl:text>}} : </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>} \begin{itemize} \item{</xsl:text>
                <!-- nombre d'occurences de chaque type de variation -->
                <xsl:value-of select="count(ancestor::TEI//body//(app|rdgGrp)[contains(@corresp, concat('#', $xmlid))])"/>
                <xsl:text> variations de ce type figurent dans le chapitre encodé.} \end{itemize} </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- règle pour le listPerson -->
    <xsl:template match="encodingDesc//listPerson" name="person">
        <!-- faire une liste de personnages incluant leur nom et une description si elle existe -->
        <xsl:text>\begin{itemize}</xsl:text>
        <xsl:for-each select=".//person">
            <xsl:variable name="id" select="@xml:id"/>
            <xsl:text> \item{\textbf{</xsl:text>
            <xsl:apply-templates select=".//persName"/>
            <xsl:text>.} </xsl:text>
            <xsl:if test=".//note">
                <xsl:value-of select=".//note"/>
            </xsl:if>
            <xsl:text> \begin{itemize} \item{</xsl:text>
            
            <!-- compter le nombre d'occurences des personnages dans les trois témoins -->
            <xsl:variable name="cntbrl">
                <xsl:value-of select="count(ancestor::TEI//body//(ab|lem)/persName[@ref=concat('#', $id)])"/>
            </xsl:variable>
            <xsl:variable name="cntatw">
                <xsl:value-of select="count(ancestor::TEI//body//(ab|rdg[contains(@wit, '#atw')])/persName[@ref=concat('#', $id)])"/>
            </xsl:variable>
            <xsl:variable name="cntbrn">
                <xsl:value-of select="count(ancestor::TEI//body//(ab|rdg[contains(@wit, '#brn')])/persName[@ref=concat('#', $id)])"/>
            </xsl:variable>
            
            <xsl:choose>
                <xsl:when test="($cntbrl = $cntatw) and ($cntatw = $cntbrn)">
                    <xsl:value-of select="$cntbrl"/>
                    <xsl:choose>
                        <xsl:when test="$cntbrl='1'">
                            <xsl:text> mention dans les trois leçons.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> mentions les trois leçons.} </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>  
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$cntbrl"/>
                    <xsl:choose>
                        <xsl:when test="$cntbrl='1'">
                            <xsl:text> mention dans la leçon principale (témoin de Berlin).} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> mentions dans la leçon principale (témoin de Berlin).} </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>  
                    <xsl:text> \item{</xsl:text>
                    <xsl:value-of select="$cntatw"/>
                    <xsl:choose>
                        <xsl:when test="$cntatw='1'">
                            <xsl:text> mention dans le témoin d'Anvers.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> mentions dans le témoin d'Anvers.} </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>  
                    <xsl:text> \item{</xsl:text>
                    <xsl:value-of select="$cntbrn"/>
                    <xsl:choose>
                        <xsl:when test="$cntbrn='1'">
                            <xsl:text> mention dans le témoin de Berne.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> mentions dans le témoin de Berne.} </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:text> \end{itemize}} </xsl:text>
        </xsl:for-each>
        <xsl:text>\end{itemize}</xsl:text>
    </xsl:template>
    
    
    <!-- règle pour le listRelation -->
    <xsl:template match="encodingDesc//listRelation" name="listrel">
        <xsl:text> \begin{itemize}</xsl:text>
        <xsl:apply-templates select=".//relation//desc"/>
        <xsl:text> \end{itemize} </xsl:text>
    </xsl:template>
    
    
    <!-- règle pour le listPlace -->
    <xsl:template match="encodingDesc//listPlace" name="place">
        <!-- faire une liste de lieux -->
        <xsl:text>\begin{itemize}</xsl:text>
        <xsl:for-each select=".//place">
            <xsl:variable name="id" select="@xml:id"/>
            <xsl:text> \item{\textbf{</xsl:text>
            <xsl:call-template name="hdrplacename"/>
            <xsl:text>.} </xsl:text>
            <xsl:text> \begin{itemize} \item{</xsl:text>
            
            <!-- compter le nombre d'occurences des lieux dans les trois témoins -->
            <xsl:variable name="cntbrl">
                <xsl:value-of select="count(ancestor::TEI//body//(ab|lem)/placeName[@ref=concat('#', $id)])"/>
            </xsl:variable>
            <xsl:variable name="cntatw">
                <xsl:value-of select="count(ancestor::TEI//body//(ab|rdg[contains(@wit, '#atw')])/placeName[@ref=concat('#', $id)])"/>
            </xsl:variable>
            <xsl:variable name="cntbrn">
                <xsl:value-of select="count(ancestor::TEI//body//(ab|rdg[contains(@wit, '#brn')])/placeName[@ref=concat('#', $id)])"/>
            </xsl:variable>
            
            <xsl:choose>
                <xsl:when test="($cntbrl = $cntatw) and ($cntatw = $cntbrn)">
                    <xsl:value-of select="$cntbrl"/>
                    <xsl:choose>
                        <xsl:when test="$cntbrl='1'">
                            <xsl:text> mention dans les trois leçons.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> mentions les trois leçons.} </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>  
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$cntbrl"/>
                    <xsl:choose>
                        <xsl:when test="$cntbrl='1'">
                            <xsl:text> mention dans la leçon principale (témoin de Berlin).} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> mentions dans la leçon principale (témoin de Berlin).} </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>  
                    <xsl:text> \item{</xsl:text>
                    <xsl:value-of select="$cntatw"/>
                    <xsl:choose>
                        <xsl:when test="$cntatw='1'">
                            <xsl:text> mention dans le témoin d'Anvers.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> mentions dans le témoin d'Anvers.} </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>  
                    <xsl:text> \item{</xsl:text>
                    <xsl:value-of select="$cntbrn"/>
                    <xsl:choose>
                        <xsl:when test="$cntbrn='1'">
                            <xsl:text> mention dans le témoin de Berne.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> mentions dans le témoin de Berne.} </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:text> \end{itemize}} </xsl:text>
        </xsl:for-each>
        <xsl:text>\end{itemize}</xsl:text>
    </xsl:template>
    
    
    <!-- règle pour les descriptions des relations entre personnages: 
        créer un item de liste -->
    <xsl:template match="relation//desc">
        <xsl:text> \item{ </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>.} </xsl:text>
    </xsl:template>
    
    
    <!-- règle pour les hyperliens ; ne fonctionne pas toujours, donc pas toujours utilisée -->
    <xsl:template match="teiHeader//ref">
        <xsl:text> \href{</xsl:text>
        <xsl:value-of select="./@target"/>
        <xsl:text>}{</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>} </xsl:text>
    </xsl:template>
    
    
    <!-- règle pour les persName dans le teiHeader -->
    <xsl:template match="teiHeader//persName" name="hdrpersname">
        <!-- récupérer soit le nom complet de la personne, soit (pour les personnages du texte)
            l'écriture contemporaine de leur nom -->
        <xsl:choose>
            <xsl:when test="not(./@type)">
                <xsl:copy-of select=".//text()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select=".[@type='contemporary-name']//text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- règle pour les placeName dans le teiHeader -->
    <xsl:template match="teiHeader//place" name="hdrplacename">
        <!-- récupérer le nom d'un lieu : le contemporary-name ou le text-name si aucun
            contemporary-name n'est indiqué -->
        <xsl:choose>
            <xsl:when test="./placeName[@type='contemporary-name']">
                <xsl:copy-of select=".//placeName[@type='contemporary-name']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select=".//placeName[@type='text-name']"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- normes d'encodage latex -->
    <xsl:template name="latex">
        <xsl:text>
            L'édition critique en XML-TEI qui est ici transformée est très (trop ?) 
            détaillée: j'ai choisi de documenter toutes les variations entre les trois 
            témoins : changements au niveau du texte, de la structure du texte 
            (paragraphes et sauts de page) et changements dans la décoration des 
            manuscrits. Tous ces éléments peuvent difficilement être traduits 
            dans une édition critique "traditionnelle" (papier) ; les principes 
            suivants ont donc été suivis :
            \begin{itemize}
            	\item{L'apparat critique est construit avec la leçon principale (témoin de 
            		Berlin) en corps de texte ; en notes de bas de page, les variations et 
            		autres détails sont signalés avec un système de notes à quatres étages :}
            		\begin{itemize}
            			\item{\textbf{\texttt{\textbackslash variant}} correspond à \texttt{\textbackslash Afootnote} et 
            				permet d'encoder les variations "simples" entre les leçons.}
            			\item{\textbf{\texttt{\textbackslash group}} correspond à \texttt{\textbackslash Bfootnote} et 
            				permet d'encoder les groupes de temoins (\texttt{&lt;rdgGrp&gt;} 
            				en TEI).}
            			\item{\textbf{\texttt{\textbackslash subvariant}} correspond à \texttt{\textbackslash Cfootnote} 
            			et permet d'encoder les sous-variations dans des apparats internes 
            			(en termes TEI : les \texttt{&lt;rdg&gt;} qui sont dans des 
            			\texttt{&lt;app&gt;} dans des \texttt{&lt;app&gt;}).}
            			\item{\textbf{\texttt{\textbackslash explan}} correspond à \texttt{\textbackslash Dfootnote} et 
            				permet d'encoder les éléments "non textuels" du témoin principal 
            				(décorations et sauts de page encodés dans des \texttt{&lt;witDetail&gt;},
            				changements de paragraphes).}
            		\end{itemize}
            	\item{Au sein d'un apparat critique (\texttt{&lt;app&gt;}) les groupes de 
            		témoins qui ne contiennent pas la leçon principale (en langage TEI 
            		les \texttt{&lt;rdgGrp&gt;} qui contiennent seulement des 
            		\texttt{&lt;rdg&gt;}, mais pas de \texttt{&lt;lem&gt;}) se trouvent 
            		dans une note de deuxième niveau (\texttt{\textbackslash group}, en \LaTeX). Si un 
            		\texttt{&lt;rdgGrp&gt;} contient une partie du témoin principal, il n'est 
            		pas retranscrit en \LaTeX.}
            	\item{Les apparats internes (un \texttt{&lt;app&gt;} dans un 
            		\texttt{&lt;app&gt;}) sont retranscrits en bas de page grâce à un 
            		\texttt{\textbackslash subvariant} (note de 3e degré).}
            	\item{Pour la leçon principale (le manuscrit de Berlin), la structure du 
            		texte est retranscrite:}
            		\begin{itemize}
            			\item{Les sauts de paragraphe sont reportés en note de 
            				bas de page dans un \texttt{\textbackslash explan} correspondant à une note de 4e niveau 
            				et signifiés dans le corps du texte par un saut de paragraphe 
            				(\texttt{\textbackslash pend \textbackslash pstart}, avec \texttt{reledmac}).} 
            			\item{Les sauts de page sont également reportés en bas de page dans un 
            				\texttt{\textbackslash explan} ; le numéro de page est également mentionné. Il n'y a 
            				pas de saut de page dans le corps du texte pour éviter d'avoir un résultat 
            				trop morcelé.}
            			\item{Les détails sur la décoration du texte sont mentionnés en notes de 
            				bas de page, dans un \texttt{\textbackslash explan}.}
            			\item{Pour les autres leçons (témoins d'Anvers et de Berne), ces 
            				détails ne sont pas mentionnés.}
            	\end{itemize}
            \end{itemize} 
            
            \indent Le fichier XSL produit a été visualisé et fonctionne sur TeXstudio 
            avec un compilateur \texttt{XeLaTeX}. Des fois, des erreurs de compilation 
            peuvent avoir lieu (toutes les notes de bas de page renvoient à la ligne 0 
            ou se trouvent à la fin du document). Dans ce cas, relancer la compilation.
        </xsl:text>
    </xsl:template>
    
    
    
    <!-- ############# RÈGLES POUR LE CORPS DU TEXTE ############## -->
    
    <!-- copier le conteneur ab et le texte à la racine ; appliquer les templates pour 
        le corps du texte-->
    <xsl:template name="body" match="body">
        <!-- copier ab et le texte à la racine -->
        <xsl:copy select=".">
            <xsl:apply-templates select=".//ab"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- règles pour construire les apparats critiques externes -->
    <xsl:template match="body//app[not(ancestor::app)]" name="app">
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
                pas de rdgGrp) ; c'est pourquoi il est ciblé aussi spécifiquement -->
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
    
    
    <!-- règle pour les rdg qui ne sont pas contenus dans des app internes ou des rdgGrp -->
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
            
            <xsl:text> \textit{\textsc{</xsl:text>
            <xsl:value-of select="./replace(@wit, '#', ' ')"/>
            <xsl:text>}}</xsl:text>
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
            
            <xsl:text> \textit{\textsc{</xsl:text>
            <xsl:value-of select="./replace(@wit, '#', ' ')"/>
            <xsl:text>}}</xsl:text>
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
            
            <xsl:text> \textit{\textsc{</xsl:text>
            <xsl:value-of select="./replace(@wit, '#', ' ')"/>
            <xsl:text>}}</xsl:text>
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
    
</xsl:stylesheet>