# ÉDITION CRITIQUE DES *CHRONIQUES* DE JEAN FROISSART EN XML-TEI

![Froissart bloublou](froissart.jpg)

Transformation XSL vers LaTeX d'une édition critique encodée en XML-TEI du chapitre 
**SHF 306** : *la négogiation du mariage du Duc de Berry*.

---

### Structure du dépôt
- **`dossier racine`**:
	- `froissart.xml` : l'encodage des trois témoins en XML-TEI
	- `froissart_xquery_createlem.xq` : la requête xquery utilisée pour transformer les éléments `rdg` en `lem` en fonction de la valeur de leur attribut `@wit`
	- `froissart.jpg` : une petite image pour décorer le présent README
	- `LICENSE` : la licence MIT sous laquelle est ce projet
	- `README.md` : le présent document
- **`attributs_valeurs`** : trois tableaux listant les valeurs possibles pour des attributs fréquemment utilisés : `persName`, `placeName` et `corresp`.
- **`collatex`** : les collations effectuées avec Collatex : script utilisé et collation produite par Collatex, utilisée comme base de la présente édition critique
- **`odd_documentation`** : l'ODD au format `.xml` et sa transformation aux formats `.rng`, `.dtd` et `.html`.
- **`textes`** : le contenu textuel des trois témoins, utilisés comme source pour la collation effectuée avec Collatex.

---

### Modifications faites par rapport à l'encodage originel

L'encodage a été réalisé pour l'évaluation du cours de TEI donné par S. Albouy, sans prendre en
compte une future transformation XSL. Des modifications ont donc du être apportées pour 
permettre la transformation :
- les `app` contenus dans des `rdg` ont été transformés en `rdgGrp` : ils ne pourraient pas
être retranscrits en latex.

---

### Choix d'encodage retenus pour la transformation

L'édition critique en XML-TEI qui est ici transformée est très (trop ?) détaillée: j'ai choisi 
de documenter toutes les variations entre les trois témoins : changements au niveau du texte,
de la structure du texte (paragraphes et sauts de page) et changements dans la décoration des
manuscrits. Tous ces éléments peuvent difficilement être traduits dans une édition critique
"traditionnelle" (papier) ; les principes suivants ont donc été suivis :
- Pour la leçon principale (le manuscrit de Berlin), la structure du texte est traduite:
	- les sauts de paragraphe sont reportés en note de bas de page dans un `\explan` 
(correspondant) à une note de 4e niveau et signifiés dans le corps du texte par un saut 
de paragraphe (`\pend \pstart`, avec `redelmac`).
	- les sauts de page sont également reportés en bas de page dans un `\explan` ; le
numéro de page est également mentionné. Il n'y a pas de saut de page dans le corps du texte 
pour éviter d'avoir un résultat trop morcelé.
	- les détails sur la décoration du texte sont mentionnés en 
notes de bas de page, dans un `\explan`
- Pour les autres leçons (témoins d'Anvers et de Berne), ces détails ne sont pas mentionnés.
- Au sein d'un apparat critique (`<app>`) les groupes qui ne contiennent pas la
leçon principale (en langage TEI les `<rdgGrp>` qui contiennent deux `<rdg>`, mais pas de
 `<lem>`) sont encodés dans une note de deuxième niveau (`\group`), en latex. Si un `<rdgGrp>`
contient une partie du témoin principal, il n'est pas retranscrit en latex. 
- Les apparats internes (un `<app>` dans un `<app>`) sont retranscrits en bas de base grâce à 
un `\subvariant` (note de 3e degré).
