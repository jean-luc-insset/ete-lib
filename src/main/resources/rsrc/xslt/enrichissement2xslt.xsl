<?xml version="1.0" encoding="UTF-8"?>


<!--
    Document   : template2xslt.xsl
    Created on : 1 octobre 2010, 18:29
    Author     : jldeleage
    Description:
        Transforme un "template d'enrichissement" en transformation XSLT
        Exemple :
            un template de gestion de sécurité qui enrichit un document
            web.xml en ajoutant les contraintes de sécurité
        MODES :
            - copie : copie les paramètres et variables dans la feuille cible
            - copie-import : copie les instructions d'importation dans la feuille cible
            - exp : construit une expression XPath à partir d'une expression ete ou JSTL
        Instructions ete spécifiques :
            - add (sous-éléments where et what)
            - remove (sous-éléments where et what)
            - replace (sous-élément where, what, with)
-->



<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0"
        xmlns:xx="sans-valeur"
        xmlns:ete="http://www.jldeleage.com/mda/ns/jld.html"
        >

    <xsl:output method="xml" indent="yes"/>
    <xsl:output method="xml" name="xml" indent="yes"/>

    <xsl:param name="items" select="''"/>

   <xsl:namespace-alias stylesheet-prefix="xx" result-prefix="xsl"/>


    <!-- Dossier dans lequel on génère tous les fichiers. Les templates
      -  peuvent préciser des chemins relatifs à ce dossier
      -  TODO : valeur par défaut de l'url du dossier cible.
      -->
    <xsl:param name="dossier_cible"/>
    <!-- Dossier dans lequel générer les fichiers temporaires -->
    <xsl:param name="tempdir" select="'.'"/>
    <!-- Dossier de la feuille en cours de traitement -->
    <xsl:param name="workingdir" select="'src/main/mda'"/>



    <xsl:template match="/">
        <xx:stylesheet version="2.0" exclude-result-prefixes="ete">
            <xsl:for-each select="ete:root/ete:namespace">
                <xsl:namespace name="{ete:prefix}" select="ete:uri"/>
            </xsl:for-each>

            <xx:param name="nomModele"/>
            <!-- Pour avoir les entités, acteurs et autres fils directs de la
               - variable, il faut "descendre" jusqu'aux enfants du modèle
               -->
            <xx:variable name="modele" select="document($nomModele)/*/*/model"/>

            <xx:template match="/">
        <xx:message>
            <xx:text>NOM DU MODELE PARAMETRE </xx:text>
            <xx:copy-of select="$nomModele"/>
            <xx:text> -&gt;</xx:text>
        </xx:message>
        <xx:message>
            <xx:copy-of select="$modele"/>
        </xx:message>
        <xx:message>
            <xx:text>Nombre d'éléments de $modele </xx:text>
            <xx:value-of select="count($modele/*)"/>
            <xx:text> dont </xx:text>
            <xx:value-of select="count($modele/Actor)"/>
            <xx:text> acteur(s)</xx:text>
        </xx:message>
        <xx:message>
            <xx:text>Dernier element du modele </xx:text>
            <xx:copy-of select="$modele/*[last()]"/>
        </xx:message>
            <xx:apply-templates/>
        </xx:template>

            <!-- Generer la regle de copie par defaut -->
            <xx:template match="* | @*">
                <xx:copy>
                    <xx:apply-templates select="@* | node()"/>
                </xx:copy>
            </xx:template>
            <!-- Generer les regles de transformation, en fonction du contenu
               - du template
              -->
            <xsl:apply-templates select="ete:root"/>
            <!-- TODO : ajouter les fonctions utilitaires ete -->
        </xx:stylesheet>
    </xsl:template>

   <xsl:template match="ete:root">
        <xsl:message>Debut de l'analyse...</xsl:message>

        <xsl:apply-templates select="*"/>


        <!-- TODO : transférer cette fonction dans une feuille d'utilitaires
             et non dans ce générateur
             -->
        <xx:function name="ete:getController">
            <xx:param name="node"/>
            <xx:choose>
                <xx:when test="local-name($node) = 'boundary'"><xx:value-of
                        select="ete:initMin($node/name)"/>Controller</xx:when>
                <xx:otherwise>
                    <xx:value-of select="ete:getController($node/..)"/>
                </xx:otherwise>
            </xx:choose>
        </xx:function>


        <xsl:comment>Construit une chaîne à partir d'une collection
        en insérant le séparateur entre deux items.
        Séparateur par défaut : ", "</xsl:comment>
        <xx:template name="liste">
            <xx:param name="collection"/>
            <xx:param name="separateur" select="', '"/>
            <xx:param name="indice" select="1"/>
            <xx:value-of select="$collection[$indice]"/>
            <xx:if test="count($collection) &gt; $indice">
                <xx:value-of select="$separateur"/>
                <xx:call-template name="liste">
                    <xx:with-param name="collection" select="$collection"/>
                    <xx:with-param name="separateur" select="$separateur"/>
                    <xx:with-param name="indice" select="$indice+1"/>
                </xx:call-template>
            </xx:if>
        </xx:template>

        <xsl:text>
            
        </xsl:text>

        <!-- TODO : transférer cette fonction dans une feuille d'utilitaires
             et non dans ce générateur.
             Idem pour les nombreuses fonctions qui suivent.
             -->
        <xx:function name="ete:initMaj">
            <xx:param name="chaine"/>
            <xx:value-of select="translate(substring($chaine,1,1),
                        'abcdefghijklmnopqrstuvwxyz',
                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            <xx:value-of select="substring($chaine, 2)"/>
        </xx:function>

        <xsl:text>
            
        </xsl:text>

        <xx:function name="ete:initMin">
            <xx:param name="chaine"/>
            <xx:value-of select="translate(substring($chaine,1,1),
                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                        'abcdefghijklmnopqrstuvwxyz')"/>
            <xx:value-of select="substring($chaine, 2)"/>
        </xx:function>

        <xsl:text>
            
        </xsl:text>

        <xx:function name="ete:mots">
            <xx:param name="chaine"/>
            <xx:value-of select="translate(substring($chaine,1,1),
                        'abcdefghijklmnopqrstuvwxyz',
                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            <xx:analyze-string select="substring($chaine, 2)" regex="[A-Z]">
                <xx:matching-substring>
                    <xx:text><xsl:text> </xsl:text></xx:text>
                    <xx:value-of select="translate(.,
                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                        'abcdefghijklmnopqrstuvwxyz')"/>
                </xx:matching-substring>
                <xx:non-matching-substring>
                    <xx:value-of select="."/>
                </xx:non-matching-substring>
            </xx:analyze-string>
        </xx:function>

        <xsl:text>
            
        </xsl:text>

        <!-- Renvoie le paquetage de l'entité dont le nom est passé en
             paramètre -->
        <xsl:text>
            
        </xsl:text>

        <xx:function name="ete:package">
            <xx:param name="entite"/>
            <xx:param name="doc"/>
            <xx:value-of select="$doc//entity[name = $entite]/package"/>
        </xx:function>

        <xsl:text>
            
        </xsl:text>

        <xsl:comment>
            Extrait le dernier identifiant d'un chemin de paquetage.
            Utilisé pour déterminer le dossier dans lequel ranger les
            "boundary components". Le contrôle d'accès se fait par ces
            dossiers. Il faut donc ranger les composants par paquetages
            de profils fonctionnels, le dernier identifiant de paquetage
            servant de nom de rôle dans l'ACL.
        </xsl:comment>        <xsl:text>
            
        </xsl:text><xx:function name="ete:dernierId">
            <xx:param name="chemin"/>
            <xx:variable name="indice" select="1"/>
            <xx:value-of select="substring($chemin, $indice)"/>
        </xx:function>
        <xx:function name="ete:typeUtilisateur">
            <xx:param name="type"/>
            <xx:choose>
            <xx:when test="$type='String'">0</xx:when>
            <xx:when test="$type='int'">0</xx:when>
            <xx:when test="$type='integer'">0</xx:when>
            <xx:when test="$type='date'">0</xx:when>
            <xx:when test="$type='Date'">0</xx:when>
            <xx:when test="$type='java.util.Date'">0</xx:when>
            <xx:when test="$type='float'">0</xx:when>
            <xx:when test="$type='double'">0</xx:when>
            <xx:when test="$type='void'">0</xx:when>
            <xx:when test="$type='boolean'">0</xx:when>
            <xx:when test="$type='char'">0</xx:when>
            <xx:otherwise>
                <xx:text>1</xx:text>
            </xx:otherwise>
            </xx:choose>
        </xx:function>


        <xsl:text>
            
        </xsl:text>

        <xsl:text>
            
        </xsl:text>


        <xx:function name="ete:type">
            <xx:param name="t"/>
<!--            <xx:message>
                <xx:text>Recherche de la representation textuelle de </xx:text>
                <xx:value-of select="$t"/>
            </xx:message>-->
<!--            <xx:message>
                <xx:text>resolution du type </xx:text>
                <xx:value-of select="$t"/>
            </xx:message>-->
<!--            <xx:message>Appel de la fonction type pour <xx:value-of select="$t"/></xx:message>-->
            <xx:choose>
                <xx:when test="$t='time'">
                    <xx:text>String</xx:text>
                </xx:when>
                <xx:when test="$t='Real'">
                    <xx:text>double</xx:text>
                </xx:when>
                <xx:when test="string-length($t/package) &gt; 0">
                    <xx:value-of select="$t/package"/>
                    <xx:text>.</xx:text>
                    <xx:value-of select="$t/name"/>
                </xx:when>
                <xx:otherwise>
                    <xx:value-of select="$t"/>
                </xx:otherwise>
            </xx:choose>
        </xx:function>



        <xsl:comment>Construit une chaîne à partir d'une collection
        en insérant le séparateur entre deux items</xsl:comment>
        <xx:function name="ete:liste">
            <xx:param name="collection"/>
            <xx:param name="separateur"/>
            <xx:call-template name="liste">
                <xx:with-param name="collection" select="$collection"/>
                <xx:with-param name="separateur" select="$separateur"/>
                <xx:with-param name="indice" select="1"/>
            </xx:call-template>
        </xx:function>


        <xsl:comment>Construit une chaîne à partir d'une collection
        en insérant le séparateur avant chaque majuscule interne.
        Séparateur par défaut : " ".
        La majuscule est remplacée par une minuscule</xsl:comment>

        <xx:function name="ete:decamelisation">
            <xx:param name="chaine"/>
            <xx:variable name="resultat">
                <xx:analyze-string regex="[A-Z]" select="$chaine">
                    <xx:matching-substring>
                        <xx:text><xsl:text> </xsl:text></xx:text>
                        <xx:value-of select="translate(.,
                                'ABCDEFGHIJKLMNOPQRESTUVWXYZ',
                                'abcdefghijklmnopqrstuvwxyz')"/>
                    </xx:matching-substring>
                    <xx:non-matching-substring>
                        <xx:value-of select="."/>
                    </xx:non-matching-substring>
                </xx:analyze-string>
            </xx:variable>
            <xx:value-of select="$resultat"/>
        </xx:function>



        <xx:function name="ete:versAscii">
            <xx:param name="chaine"/>
            <xx:value-of select="translate($chaine, 'àâäéèêëîïôöùûü', 'aaaeeeeiioouuu')"/>
        </xx:function>

        <xx:function name="ete:camel2el">
            <xx:param name="chaine"/>
            <xx:value-of select="translate($chaine, '_', '.')"/>
        </xx:function>
    </xsl:template>

    <xsl:template match="ete:namespace"/>
 

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <!-- Traitement des paramètres du template (items sur lesquels appliquer
      -  le template par exemple).
      -->
    <xsl:template match="ete:root/@*">
        <xsl:message>Traitement de l'attribut <xsl:value-of select="name()"/></xsl:message>
        <xsl:if test="starts-with(name(), 'xmlns')">
            <xsl:attribute name="{ name() }">
                <xsl:apply-templates select="." mode="exp"/>
                <!--
                <xsl:value-of select="ete:exp(.)"/>
                -->
            </xsl:attribute>
        </xsl:if>
    </xsl:template>


    <xsl:template match="ete:param" mode="copie">
<!--        <xsl:message>Copie du parametre <xsl:value-of select="."/></xsl:message>-->
        <xx:param name="{ @name }">
            <xsl:if test="@select">
                <!-- TODO : effectuer une évaluation des expressions ete-->
                <xsl:attribute name="select" select="@select"/>
            </xsl:if>
        </xx:param>
    </xsl:template>


    <xsl:template match="ete:variable" mode="copie">
        <xx:variable name="{ @name }">
            <xsl:if test="@select">
            <!-- TODO : effectuer une évaluation des expressions ete-->
                <xsl:attribute name="select" select="@select"/>
            </xsl:if>
            <!-- ??? -->
            <xsl:apply-templates/>
        </xx:variable>
    </xsl:template>


    <!-- Il faut créer un règle qui
       - 1- sélectionne et copie l'élément où il faut ajouter quelque chose
       - 2- invoque les copies résursives
       - 3- insède le contenu de l'élément "what" de la règle du template
      -->
    <xsl:template match="ete:add">
        <xsl:message>Traitement de add</xsl:message>
        <!-- 1-a : sélection de l'élément auquel il faut ajouter du contenu -->
        <xx:template match="{ ete:where }">
            <!-- 1-b : copie de cet élément et de ses attributs -->
            <xx:copy>
                <xx:apply-templates select="@*"/>
                <!-- 2 : copie de son contenu -->
                <xx:apply-templates/>
                <!-- 3 : ajout du nouveau contenu -->
                <xsl:apply-templates select="ete:what/*"/>
            </xx:copy>
        </xx:template>
    </xsl:template>


<!--    <xsl:template match="ete:remove">
        <xx:template>
            <xsl:attribute name="match">
                <xsl:apply-templates select="what"/>
            </xsl:attribute>
        </xx:template>
    </xsl:template>


    <xsl:template match="ete:replace">
    </xsl:template>-->



    <xsl:template match="ete:variable | ete:param"/>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--                         M O D U L A R I T E                         -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--
      - Un template peut contenir des instructions d'importation. Une telle
      - instruction est traduite par une instruction <xsl:import> dans la
      - feuille XSLT générée à partir du template.
      - Il faut que le template importé soit lui aussi traduit en XSLT.
      -->

    <!--
      - Effectue deux actions :
      - 1- ajoute une clause d'importation (doit donc être appelée en début de
      - processus)
      - 2- crée le fichier importé en suffixant ".xsl" à la valeur de l'attribut
      - href de l'élément traité. Ce fichier est obtenu en traitant le fichier
      - indiqué par l'attribut href. Typiquement, ce fichier est un "template"
      - contenant un attribut "items" indiquant à quels items il s'applique.
      - Voir les exemples de champ.xml et champText.xml
      -->
    <xsl:template match="ete:import" mode="copie_import">
        <xsl:variable name="ch" select="ete:chemin(@href)"/>
        <xsl:variable name="fichier" select="ete:fichier(@href)"/>
<!--        <xsl:variable name="chGenere" select="concat($ch, 'genere/', $fichier)"/>-->
        <xsl:variable name="chGenere" select="concat($tempdir, $fichier)"/>
        <xsl:message>Chemin du fichier temporaire : <xsl:value-of select="$chGenere"/></xsl:message>
        <xsl:variable name="href" select="$chGenere"/>

        <!-- insérer l'instruction d'importation -->
        <xx:import>
            <xsl:attribute name="href" select="ete:dernierPas(@href)"/>
        </xx:import>

        <!-- construire la feuille correspondante -->
        <xsl:message>
            <xsl:text>Création du fichier </xsl:text>
            <xsl:value-of select="$href"/>
        </xsl:message>

        <xsl:variable name="fichier-importe" select="concat($workingdir, $fichier)"/>


        <xsl:message>
Fichier importé : <xsl:value-of select="$fichier-importe" /> importé dans <xsl:value-of select="$href"/>
La clause d'importation contient <xsl:value-of select="ete:dernierPas(@href)"/>
Dossier de travail : <xsl:value-of select="$workingdir"/>
        </xsl:message>


        <!-- Traduction du template en XSLT. Le résultat est placé dans un
             fichier temporaire à l'adresse $href
          -->
        <xsl:result-document format="xml" href="{ $href }">
            <xsl:variable name="match-value">
                <xsl:choose>
                    <xsl:when test="document($fichier-importe)/*/@items">
                        <xsl:value-of select="document($fichier-importe)/*/@items"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>/</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xx:stylesheet version="2.0"
                           exclude-result-prefixes="ete"
                    >
                <xx:template match="{ $match-value }">
                    <xsl:if test="document($fichier-importe)/*/@mode">
                        <xsl:attribute name="mode" select="document($fichier-importe)/*/@mode"/>
                    </xsl:if>
                    <xsl:if test="document($fichier-importe)/*/@priority">
                        <xsl:attribute name="priority" select="document($fichier-importe)/*/@priority"/>
                    </xsl:if>
                    <xsl:apply-templates select="document($fichier-importe)/*/node()"/>
                </xx:template>
            </xx:stylesheet>
        </xsl:result-document>

    </xsl:template>


    <!-- L'importation ne doit pas être copiée dans la règle principale -->
    <xsl:template match="ete:import"/>


    <xsl:template match="ete:apply-imports">
        <xx:apply-imports>
            <xsl:copy-of select="@*"/>
        </xx:apply-imports>
    </xsl:template>


    <xsl:template match="ete:result-document">
        <xx:message>
            <xx:text>Dossier cible :</xx:text>
            <xsl:value-of select="$dossier_cible"/>
            <xx:text>
href : </xx:text>
            <xsl:value-of select="@href"/>
        </xx:message>
        <xx:result-document href="{ $dossier_cible}/{ @href }">
            <xsl:apply-templates/>
        </xx:result-document>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <!--
        L'objectif de ce template est la définition de sous-templates pour
        faire du polymorphisme
      -->
    <xsl:template match="ete:generation-for-each-child">
        <xx:apply-templates>
            <xsl:if test="@mode">
                <xsl:attribute name="mode" select="@mode"/>
            </xsl:if>
        </xx:apply-templates>
    </xsl:template>



    <xsl:template match="ete:apply-templates | ete:apply">
        <xx:apply-templates>
            <xsl:if test="@mode">
                <xsl:attribute name="mode" select="@mode"/>
            </xsl:if>
            <xsl:if test="@select | @items">
                <xsl:attribute name="select" select="concat(@select, @items)"/>
            </xsl:if>
            <xsl:for-each select="@*">
                <xsl:attribute name="{ name() }">
                    <xsl:apply-templates select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates select="*"/>
        </xx:apply-templates>
    </xsl:template>

    <xsl:template match="ete:message">
        <xx:message>
            <xsl:apply-templates/>
        </xx:message>
    </xsl:template>

    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--    T R A I T E M E N T   D E S   I N S T R U C T I O N S   E T E    -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <!--
      -  Ete utilise les syntaxes xslt, JSTL et Obeo, au choix. On peut
      -  mélanger les trois syntaxes sans problème, on peut même dans certains
      -  cas mélanger ces syntaxes dans une même balise (par exemple utiliser
      -  l'attribut "items" avec "for-each" ou "select" avec "forEach"...
      -  Attention, "for" a une syntaxe spécifique et utilise l'attribut
      -  "each".
      -->

    <xsl:template match="ete:choose">
        <xx:choose>
            <xsl:apply-templates select="ete:when | ete:otherwise"/>
        </xx:choose>
    </xsl:template>


    <xsl:template match="ete:when">
        <xx:when test="{ @test }">
            <xsl:apply-templates/>
        </xx:when>
    </xsl:template>


    <xsl:template match="ete:otherwise">
        <xx:otherwise>
            <xsl:apply-templates/>
        </xx:otherwise>
    </xsl:template>

    <xsl:template match="ete:if">
        <xx:if test="{ @test }">
            <xsl:apply-templates/>
        </xx:if>
    </xsl:template>


    <xsl:template match="ete:for-each | ete:forEach">
        <xx:for-each>
            <xsl:attribute name="select">
                <xsl:value-of select="@select"/>
                <xsl:value-of select="@items"/>
            </xsl:attribute>
            <xsl:if test="@var">
                <xx:variable name="{ @var }" select="."/>
            </xsl:if>
            <xsl:apply-templates/>
            <xx:if test="position() lt last()">
            <xsl:value-of select="@sep"/>
            </xx:if>
        </xx:for-each>
    </xsl:template>


    <!--
      -  Autre syntaxe pour construire une boucle avec une variable :
      -  <for each="auteur in livre.auteurs">
      -      ...
      -  </for>
      -  Cette instruction génère une variable nommée "auteur"
      -->
    <xsl:template match="ete:for">
        <xx:for-each>
            <xsl:attribute name="select">
                <xsl:choose>
                    <xsl:when test="contains(@each, 'in')">
                        <!-- Todo : déclarer une variable -->
                        <xsl:variable name="name" select="normalize-space(substring-before(@each, 'in'))"
                                />                        
                        <xx:variable name="{ $name }" select="."/>
                        <xsl:value-of select="normalize-space(substring-after(@each, 'in'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(@each)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
            <xx:if test="position() &lt; last()">
                <xsl:value-of select="@sep"/>
                <xsl:text> </xsl:text>
            </xx:if>
        </xx:for-each>
    </xsl:template>


    <xsl:template match="ete:attribute">

        <xx:attribute>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="* | text()"/>
        </xx:attribute>

<!--    <ATTENTION>ICI ATTRIBUT : <xsl:value-of select="."/></ATTENTION>
        <xx:message>Génération d'un attribut</xx:message>
        <xsl:message>GENERATION D'UN ATTRIBUT</xsl:message>-->
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--           C O P I E   R E C U R S I V E   D E   L ' X M L           -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <!-- Les éléments sont copiés tels quels, avec leurs attributs, mais les
        expressions ete sont évaluées.
        Ainsi, un template qui contient :
        <c:forEach items="${ elts }">
        produit exactement cela.
        En revanche, un template qui contient
        <c:forEach items="${ €[elts] }">
        produit
        <c:forEach items="${ xxx }">
        où xxx est la valeur de elts dans le modèle.
      -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>


    <!-- Il faut traiter les expression €[ ] -->
    <xsl:template match="@*">
<!--        <xsl:message>
            <xsl:text>Traitement de l'attribut </xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text> qui vaut [</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>]</xsl:text>
        </xsl:message>-->
        <xx:attribute name="{ name() }">
            <xsl:apply-templates select="." mode="exp"/>
            <!--
            <xsl:value-of select="ete:exp(.)"/>
            -->
        </xx:attribute>
    </xsl:template>




    <!-- Il faut traiter les expression €[ ] -->
    <xsl:template match="text()">
        <xsl:apply-templates select="." mode="exp"/>
    </xsl:template>


    <xsl:template match="ete:text">
        <xsl:analyze-string regex="€\[(w*?)\]" select=".">
            <xsl:matching-substring>
                <!--
                <xsl:message>
                    <xsl:text>Expression reconnue : </xsl:text>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:message>
                -->
                <xx:value-of>
                    <xsl:attribute name="select">
                    <xsl:value-of select="regex-group(1)"/>
                    </xsl:attribute>
                </xx:value-of>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xx:text disable-output-escaping="yes">
                <xsl:value-of select="."/>
                </xx:text>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>


    <xsl:template match="@*" mode="exp">
        <xsl:analyze-string regex="€\[(.*?)\]" select=".">
            <xsl:matching-substring>
<!--                <xsl:message>
                    <xsl:text>Expression Ete : </xsl:text>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:message>-->
                <xx:value-of>
                <xsl:attribute name="select">
                <xsl:value-of select="regex-group(1)"/>
                </xsl:attribute>
                </xx:value-of>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xx:text disable-output-escaping="yes">
                <xsl:value-of select="."/>
                </xx:text>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>


    <xsl:template match="text()" mode="exp">
        <xsl:analyze-string regex="€\[(.*?)\]" select=".">
            <xsl:matching-substring>
                <!--
                <xsl:message>
                    <xsl:text>Expression reconnue : </xsl:text>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:message>
                -->
                <xx:value-of>
                    <xsl:attribute name="select">
                    <xsl:value-of select="regex-group(1)"/>
                    </xsl:attribute>
                </xx:value-of>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xx:text disable-output-escaping="yes">
                <xsl:value-of select="."/>
                </xx:text>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>




    <xsl:function name="ete:exp">
        <xsl:param name="chaine"/>
        <xsl:analyze-string regex="€\[(.*?)\]" select="$chaine">
            <xsl:matching-substring>
                <xsl:message>
                    <xsl:text>Expression reconnue : </xsl:text>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:message>
                <xx:value-of>
                    <xsl:attribute name="select">
                    <xsl:value-of select="regex-group(1)"/>
                    </xsl:attribute>
                </xx:value-of>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>


    <xsl:function name="ete:chemin">
        <xsl:param name="cheminComplet"/>
        <xsl:variable name="ch">
            <xsl:choose>
                <xsl:when test="substring($cheminComplet, 1,1)='/'">
                    <xsl:value-of select="substring($cheminComplet, 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$cheminComplet"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="debut" select="substring-before($ch, '/')"/>
        <xsl:choose>
            <xsl:when test="$debut != ''">
            <xsl:value-of select="concat($debut,'/',ete:chemin(substring-after($ch, '/')))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="ete:fichier">
        <xsl:param name="cheminComplet"/>
        <xsl:variable name="ch">
            <xsl:choose>
                <xsl:when test="substring($cheminComplet, 1,1)='/'">
                    <xsl:value-of select="substring($cheminComplet, 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$cheminComplet"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="debut" select="substring-before($ch, '/')"/>
        <xsl:choose>
            <xsl:when test="$debut != ''">
            <xsl:value-of select="ete:fichier(substring-after($ch, '/'))"/>
        </xsl:when>
        <xsl:otherwise>
<!--            <xsl:variable name="nom" select="substring-before($ch, '.')"/>
            <xsl:value-of select="concat($nom, '.xsl')"/>-->
            <xsl:value-of select="$ch"/>
        </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    <xsl:function name="ete:dernierPas">
        <xsl:param name="chemin"/>
        <xsl:choose>
            <xsl:when test="contains($chemin, '/')">
                <xsl:value-of select="ete:dernierPas(substring-after($chemin, '/'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$chemin"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


</xsl:stylesheet>
