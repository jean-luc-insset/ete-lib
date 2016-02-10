<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : lectureMD.xsl
    Created on : 1 novembre 2010, 22:32
    Author     : jldeleage
    Description:
        Lit un document MagicDraw (ou plus généralement UML 2.2 / XMI 2.1)
        et produit un modèle "ete".

        Mise en place d'une sorte de pattern visitor :
        quand la feuille cherche à produire un certain types d'éléments à
        partir du document source, elle invoque les règles avec un mode
        "select-xxx" ou "get-xxx".
        Par exemple :
        <xsl:apply-templates select="//*" mode="select-classes"/>

        Chaque feuille importée doit implémenter l'interface correspondante
        ou plutôt la classe abstraite car des implémentations par défaut sont
        fournies dans la feuille "feuille-abstraite.xsl".

        Pour cela, elle définit une règle pour chaque mode "select-xxx" qui
        filtre les nœuds cherchés (par l'attribut "match" ou par des
        instructions de test).
        Pour chaque nœud acceptable, la règle invoque les règles sur le nœud
        de contexte dans le mode xxx.
        Suite de l'exemple :
        <xsl:template match="..." mode="select-classes">
            <xsl:apply-templates select="." mode="class"/>
        </xsl:template>

        La feuille principale a ensuite une règle particulière de traitement
        de ce mode.
        Dans l'exemple, on a donc la règle qui traite les classes de la forme :
        <xsl:template match="*" mode="class">
        </xsl:template>.
        Cette règle ne sera donc invoquée que pour les nœuds considérés comme
        des classes par la feuille importée.

        Les "méthodes" get-xxx renvoient directement la valeur demandée :

        <xsl:template match="..." mode="get-name">
            <xsl:value-of select="@name"/>
        </xsl:template>

        TODO : les "méthodes" select-xxx ne s'appliquent qu'à des éléments.
        Peut-il y avoir des termes à sélectionner qui soient des attibuts ?
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
         xmlns:fete="http://www.insset.u-picardie.fr/jeanluc/ete.html"
         xmlns:uml='http://www.omg.org/spec/UML/20110701'
         xmlns:uml_2_2='http://www.omg.org/spec/UML/20110701'
         xmlns:xmi='http://www.omg.org/spec/XMI/20110701'
         xmlns:MagicDraw_Profile='http://www.omg.org/spec/UML/20110701/MagicDrawProfile'
         xmlns:Validation_Profile='http://www.magicdraw.com/schemas/Validation_Profile.xmi'
         xmlns:DSL_Customization='http://www.magicdraw.com/schemas/DSL_Customization.xmi'
         xmlns:UML_Standard_Profile='http://www.omg.org/spec/UML/20110701/StandardProfileL2'
         xmlns:stéréotypes='http://www.magicdraw.com/schemas/stéréotypes.xmi'>


    <!-- Fonctions utilitaires et comportements par défaut ("super-classe"
         des pilotes spécifiques aux différentes versions UML/XMI)
      -->
    <xsl:import href="feuille_abstraite.xsl"/>

    <!-- Feuilles spécifiques aux différentes versions UML/XMI -->
    <xsl:include href="lecture_20110701.xsl" />
    <xsl:include href="lecture_20131001.xsl" />

   <xsl:param name="copie-modele-initial" select="false()"/>


    <xsl:output method="xml" indent="yes"/>



    <xsl:template match="/">
        <xsl:message>
------------------------------------------------------------------------
Lecture MD 17.0.2 et 18.0
Version 2.2
Cette version de lecture.xsl est architecturée par le contenu du modèle
plutôt que par les stéréotypes : la feuille parcourt le document en
cherchant les éléments de type classe, interface. Ensuite elle recommence
en cherchant les éléments de type acteur. Puis elle parcourt le document
en cherchant les éléments de type cas d'utilisation. Enfin elle parcourt
le document à la recherche des diagrammes d'états, d'activité, de séquence
et de communication.
Les seuls éléments pris en compte sont ceux se trouvant dans un modèle
marqué par le stéréotype "ete".
------------------------------------------------------------------------</xsl:message>
        <!--
            Il y a plusieurs espaces de noms possibles. De ce fait, on ne
            connaît pas l'espace de noms exact de l'élément racine.
            On traite tout, comme ça on est tranquille
          -->
        <xsl:apply-templates select="*" mode="racineXmi"/>
        <xsl:message>------------------------------------------------------------------------</xsl:message>
    </xsl:template>


    <!-- Construit le document
      -->
    <xsl:template match="*" mode="racineXmi">
        <!-- La feuille dédiée à l'espace de noms du document affiche des
             informations la concernant (versions XMI et UML)
          -->
        <xsl:apply-templates select="." mode="info"/>
        <xsl:message>------------------------------------------------------------------------</xsl:message>
        <!-- Copie de l'élément racine... -->
        <xsl:copy>
            <!-- ...et de ses attributs -->
            <xsl:copy-of select="@*"/>
            <!-- Copie du contenu du document initial -->
            <xsl:apply-templates select="." mode="copie-modele-initial"/>
            <!-- Creation du modele ete -->
            <!-- Il faut générer un élément d'extension dans le même
                espace de noms que  le document initial car on a copié l'élément
                racine de ce document.
                Sinon, on risque alors d'avoir des documents hétérogènes,
                difficiles à relire.
                Ce template est redéfini dans les feuilles d'adaptation aux
                espaces de noms et doit appeler l'instruction
                <xsl:apply-templates select="." mode="callback-extension-element/>
              -->
            <xsl:apply-templates select="." mode="create-extension-element">
                <xsl:with-param name="action" tunnel="yes"
                                select="'callback-extension-element'"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- Copie du modele initial                                             -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="node()" mode="copie-modele-initial">
        <xsl:choose>
            <xsl:when test="$copie-modele-initial">
                <xsl:copy-of select="node()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>Copie du modèle initial désactivée</xsl:comment>
                <xsl:message>Copie du modèle initial désactivée</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- Contenu de l'élément extension                                      -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <!-- Appelé sur l'élément racine -->
    <xsl:template match="*" mode="callback-extension-element">
        <xsl:apply-templates select="* | */*" mode="select-ete-model">
            <xsl:with-param name="action" tunnel="yes" select="'ete-model'"/>
        </xsl:apply-templates>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- Parcours du document initial à la recherche d'éléments à traiter    -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <!-- Remplissage de l'extension spécifique ete
         Cette règle est invoquée par une feuille d'adaptation à l'espace
         de noms.
      -->
    <xsl:template match="*" mode="ete-model">
        <!-- TODO : ne traiter que les modèles portant le stéréotype "ete" -->
        <!-- Traitements des éléments "modèle" 'top-level' et portant le
             stéréotype "ete".
             Chaque feuille correspondant à une version UML/XMI définit ses
             propres règles.
          -->
        <model>
        <!-- Traite chacune des classes. Pour chacune, un stéréotype principal
           - est cherché : Entity, Boundary, Service.
           - Si un de ces stéréotypes est trouvé, l'élément correspondant est
           - généré.
           - Si la classe ne possède aucun de ces stéréotypes, un élément
           - <Plain> est généré.
           - L'élément généré contient un sous-élément <stereotypes> qui
           - contient tous les stéréotypes non standard appliqués à la classe.
          -->
        <xsl:apply-templates select=".//*" mode="select-classes">
            <xsl:with-param name="action" tunnel="yes" select="'process-class'"/>
        </xsl:apply-templates>

        <xsl:apply-templates select=".//*" mode="select-enumerations">
            <xsl:with-param name="action" tunnel="yes" select="'process-enumeration'"/>
        </xsl:apply-templates>
        <!-- Générer la table des rôles -->
        <xsl:apply-templates select=".//*" mode="select-actors"/>
        <!-- Générer les ACL -->
        <!--<xsl:apply-templates select=".//*" mode="select-scenario"/>-->
        </model>
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="*" mode="package">
        
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- C L A S S E S                                                       -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <!-- Le nœud de contexte représente une classe dans le document du
         modèle.
         Si la classe porte un des stéréotypes "de base" (Entity, Boundary,
         Component) alors l'élément produit est homonyme à ce stéréotype.
         Tous les stéréotypes sont copiés dans l'élément <stereotypes>
      -->
    <xsl:template match="* | @*" mode="process-class">
<!--        <xsl:message>
            <xsl:text>GENERATION DE LA CLASSE : </xsl:text>
            <xsl:value-of select="@name"/>
        </xsl:message>-->
        <!-- Détermine s'il faut générer un élément Entity, Boundary, Class
             ou autre
             TODO : remplacer par l'invocation d'une règle, comme pour
             le traitement des attributs en propriété ou association
        -->
        <xsl:variable name="is-entity">
            <xsl:apply-templates select="." mode="is-entity"/>
        </xsl:variable>
        <xsl:variable name="is-boundary">
            <xsl:apply-templates select="." mode="is-boundary"/>
        </xsl:variable>
        <xsl:variable name="nom-element">
            <xsl:choose>
                <xsl:when test="$is-entity = 'true'">
                    <xsl:text>Entity</xsl:text>
                </xsl:when>
                <xsl:when test="$is-boundary = 'true'">
                    <xsl:text>Boundary</xsl:text>
                </xsl:when>
                <xsl:when test="fete:isService(.)='true'">
                    <xsl:text>Service</xsl:text>
                </xsl:when>
                <xsl:when test="fete:isComponent(.)='true'">
                    <xsl:text>Component</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Class</xsl:text>
                    <!--<xsl:text>Plain</xsl:text>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{ $nom-element}">
            <xsl:attribute name="xmi-id"
                select="@*[local-name()='id']" />
            <package>
                <xsl:apply-templates select="." mode="get-package"/>
            </package>
            <name>
                <xsl:apply-templates select="." mode="get-name">
                    <xsl:with-param name="action"
                            select="'get-name'" tunnel="yes"/>
                </xsl:apply-templates>
            </name>
            <xsl:if test="@isAbstract='true'">
                <abstract>true</abstract>
            </xsl:if>
            <xsl:apply-templates select="." mode="does-it-have-subclasses">
                <xsl:with-param name="action" tunnel="yes"
                    select="'has-subclasses'"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="." mode="select-superclasses">
                <xsl:with-param name="action" tunnel="yes" select="'process-superclass'"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="." mode="get-stereotypes"/>
            <xsl:apply-templates select="*" mode="select-attributes">
                <xsl:with-param name="action"
                            select="'process-attribute'"
                            tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="*" mode="select-operations">
                <xsl:with-param name="action"
                            select="'process-operation'"
                            tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="*" mode="select-associations">
                <xsl:with-param name="action" select="'process-association'"
                            tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="*" mode="select-invariants">
                <xsl:with-param name="action" select="'process-invariant'"
                            tunnel="yes"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>


    <xsl:template match="*" mode="has-subclasses">
        <hasSubclasses/>
    </xsl:template>


    <!-- Le nœud de contexte est le nœud définissant la super-classe -->
    <xsl:template match="*" mode="process-superclass">
        <superclass>
            <package>
                <xsl:apply-templates select="." mode="get-package"/>
            </package>
            <name>
                <xsl:apply-templates select="." mode="get-name"/>
            </name>
        </superclass>
    </xsl:template>


    <xsl:template match="*" mode="process-invariant">
        <invariant xmi-id="{@*[local-name()='id']}">
            <name>
                <xsl:value-of select="@name"/>
            </name>
            <expression>
                <xsl:value-of select="specification/body"/>
            </expression>
        </invariant>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="*" mode="process-operation">
        <operation xmi-id="{@*[local-name()='id']}">
            <name>
                <xsl:apply-templates select="." mode="get-name"/>
            </name>
            <type>
                <xsl:apply-templates select="." mode="get-type-of-operation"/>
            </type>
            <xsl:if test="@isAbstract">
                <abstract>true</abstract>
            </xsl:if>
            <xsl:apply-templates select=".//*" mode="select-params">
                <xsl:with-param name="action" select="'process-param'" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select=".//*" mode="select-preconditions">
                <xsl:with-param name="action" select="'process-precondition'" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select=".//*" mode="select-result-specification">
                <xsl:with-param name="action" select="process-result-specification" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select=".//*" mode="select-postconditions">
                <xsl:with-param name="action" select="'process-postcondition'" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates select=".//*" mode="select-body">
                <xsl:with-param name="action" select="'process-body'" tunnel="yes"/>
            </xsl:apply-templates>
            <!--<xsl:apply-templates select="ownedRule/specification/body" mode="process-body"/>-->
        </operation>
    </xsl:template>


    <xsl:template match="* | @*" mode="process-param">
        <param>
            <name>
            <xsl:apply-templates select="." mode="get-name"/>
            </name>
            <type>
                <xsl:apply-templates select="." mode="get-type-param"/>
            </type>
        </param>
    </xsl:template>


    <xsl:template match="* | @*" mode="process-result-specification">
        <result xmi-id="{@*[local-name()='id']}">
            <xsl:apply-templates select="." mode="get-result-specification"/>
        </result>
    </xsl:template>

    <xsl:template match="* | @*" mode="process-precondition">
        <precondition xmi-id="{@*[local-name()='id']}">
            <name>
                <xsl:apply-templates select="." mode="get-name-of-condition"/>
            </name>
            <expression>
                <xsl:apply-templates select="." mode="get-expression-of-condition"/>
            </expression>
        </precondition>
    </xsl:template>


    <xsl:template match="* | @*" mode="process-postcondition">
        <postcondition xmi-id="{@*[local-name()='id']}">
            <name>
                <xsl:apply-templates select="." mode="get-name-of-condition"/>
            </name>
            <expression>
                <xsl:apply-templates select="." mode="get-expression-of-condition"/>
            </expression>
        </postcondition>
    </xsl:template>


    <xsl:template match="*" mode="process-body">
        <specification xmi-id="{../../@*[local-name()='id']}">
            <xsl:copy-of select="text()"/>
        </specification>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="* | @*" mode="process-attribute">
        <property xmi-id="{@*[local-name()='id']}">
            <name>
                <xsl:apply-templates select="." mode="get-name"/>
            </name>
            <type>
                <xsl:apply-templates select="." mode="get-type">
                    <xsl:with-param name="level" select="10" tunnel="yes"/>
                </xsl:apply-templates>
            </type>
            <cardinality>
                <xsl:apply-templates select="." mode="get-cardinality"/>
            </cardinality>
            <xsl:if test="@isDerived='true'">
                <derived>true</derived>
            </xsl:if>
            <!-- On n'a pas forcément de "reverse-cardinality", ce n'est
                donc pas un mode get-xxx -->
            <xsl:apply-templates select="." mode="reverse-cardinality"/>
            <!-- On na pas forcément d'élément "mappedBy", ce n'est donc
                pas un mode "get-xxx" mais "select-xxx" -->
<!--            <xsl:apply-templates select="." mode="select-mappedBy">
                <xsl:with-param name="action" select="'process-mappedBy'"/>
            </xsl:apply-templates>-->
        </property>
    </xsl:template>


    <!-- Le contexte est un attribut -->
    <xsl:template match="ownedAttribute" mode="process-association">
        <xsl:variable name="assoc">
            <xsl:apply-templates select="." mode="get-association"/>
        </xsl:variable>
        <xsl:variable name="nom-assoc">
            <xsl:choose>
                <xsl:when test="@aggregation='composite'">
                    <xsl:text>composition</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>association</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$nom-assoc}">
            <xsl:attribute name="xmi-id" select="@*[local-name()='id']"/>
            <name>
            <!-- Nom de l'association -->
            <!-- en priorite : le nom du role
                 sinon, le nom de l'association
                 sinon, le nom de la classe opposee
              -->
                <xsl:choose>
                    <xsl:when test="@name">
                        <xsl:value-of select="@name"/>
                    </xsl:when>
                    <xsl:when test="$assoc/*/@name">
                        <!-- Utiliser le nom de l'association
                          -->
                        <xsl:value-of select="$assoc/*/@name"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Utiliser le nom de la classe de destination -->
                        <xsl:value-of select="fete:initMin(key('byId', @type)/@name)"/>
                        <!--<xsl:value-of select="count(preceding::*)"/>-->
                    </xsl:otherwise>
                </xsl:choose>
            </name>
            <!--
             Selon la cardinalite des deux extremites, on genere
             <manyToOne>, <oneToMany>, <oneToOne> ou <manyToMany>
             On peut aussi ajouter l'element mappedBy
            -->
            <xsl:variable name="m2oo2mm2m">
                <xsl:apply-templates select="." mode="get-both-cardinalities"/>
            </xsl:variable>
            <type>
                <xsl:apply-templates select="." mode="get-type"/>
            </type>
            <!-- Il y a une certaine redondance entre le type et
               l'élément suivant car tous deux contiennent la cardinalité
               de l'association
              -->
            <kind>
                <xsl:value-of select="substring-after(key('byId', @type)/@*[local-name()='type'], 'uml:')"/>
            </kind>
            <both-cardinalities>
                <xsl:value-of select="$m2oo2mm2m"/>
            </both-cardinalities>
            <xsl:choose>
                <xsl:when test="ends-with($m2oo2mm2m, 'Many')">
                    <cardinality>*</cardinality>
                    <!-- TODO : si c'est une cardinalité OneToMany ou ManyToMany, il
                        faut regarder s'il y a une réciproque et marquer éventuellement
                        cette extrêmité par "mappedBy"
                      -->
                </xsl:when>
                <xsl:otherwise>
                    <cardinality>1</cardinality>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="starts-with($m2oo2mm2m, 'One')">
                    <xsl:apply-templates select="." mode="select-mappedBy">
                        <xsl:with-param name="action" select="'process-mappedBy'" tunnel="yes"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$m2oo2mm2m='ManyToMany' and count(preceding::ownedAttribute[@association = current()/@association])=0">
                    <!-- TODO : ne generer MappedBy que si c'est le premier
                         terme de l'association -->
                    <xsl:apply-templates select="." mode="select-mappedBy">
                        <xsl:with-param name="action" select="'process-mappedBy'" tunnel="yes"/>
                    </xsl:apply-templates>
                </xsl:when>                
            </xsl:choose>
            <xsl:if test="qualifier">
                <qualifier>
                    <name>
                        <xsl:value-of select="@name"/>
                    </name>
                    <key>
                        <xsl:value-of select="qualifier/@name"/>
                    </key>
                    <type>
                        <xsl:apply-templates select="qualifier" mode="get-type"/>
                    </type>
                    <!-- Ce qualificateur est-il stéréotypé avec une spécification ? -->
                    <xsl:for-each select="//*[@base_Element=current()/@*[local-name(.)='id']]">
                        <spec>
                            <xsl:value-of select="@spec"/>
                        </spec>
                    </xsl:for-each>
                </qualifier>
            </xsl:if>
        </xsl:element>
    </xsl:template>


    <xsl:template match="*" mode="process-reverse-cardinality">
        <xsl:param name="reverseCardinality" tunnel="yes"/>
        <reverseCardinality>
            <xsl:value-of select="$reverseCardinality"/>
        </reverseCardinality>
    </xsl:template>


    <xsl:template match="* | @*" mode="process-mappedBy">
        <xsl:param name="mappedBy" tunnel="yes"/>
        <xsl:variable name="oppose" select="key('byId', $mappedBy)"/>
        <xsl:if test="key('byId', $mappedBy)/@name">
            <mappedBy xmi-id="{@*[local-name()='id']}">
                <xsl:value-of select="key('byId', $mappedBy)/@name"/>
            </mappedBy>
        </xsl:if>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--                       E N U M E R A T I O N S                       -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="*" mode="process-enumeration">
        <Enumeration xmi-id="{@*[local-name()='id']}">
            <name>
                <xsl:apply-templates select="." mode="get-name"/>
            </name>
            <package>
                <xsl:apply-templates select="." mode="get-package"/>
            </package>
            <xsl:for-each select="ownedLiteral">
                <value>
                    <xsl:value-of select="@name"/>
                </value>
            </xsl:for-each>
        </Enumeration>
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--                            A C T E U R S                            -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="*" mode="selected-actor">
        <Actor xmi-id="{@*[local-name()='id']}">
            <xsl:variable name="id">
                <xsl:value-of select="@*[local-name()='id']"/>
            </xsl:variable>
            <name>
                <xsl:apply-templates select="." mode="get-name"/>
            </name>
            <!-- Ajouter les associations de cet acteur. Cela donnera
                 éventuellement les liens figurant sur sa page d'accueil
              -->
            <xsl:for-each select="//ownedAttribute[@type=current()/@*[local-name()='id']]">
                <association>
                    <xsl:comment>
                        Le type est-il un type défini dans un profil ? :
                        <xsl:value-of select="type/@ref"/>
                    </xsl:comment>
                    <xsl:choose>
                        <xsl:when test="type/@ref">
                            <!-- Référence à un type importé de ete ou d'un autre profil : le type
                            est décrit par l'élément référencé
                            -->
                            <xsl:variable name="typeProfil">
                                <xsl:value-of select="*/*/referenceExtension/@referentPath"/>
                            </xsl:variable>
                            <xsl:variable name="sansEte">
                                <xsl:value-of select="substring($typeProfil, 5)"/>
                            </xsl:variable>
                            <xsl:message>
                                <xsl:text>REFERENCE D'UN TYPE DANS UN PROFIL : </xsl:text>
                                <xsl:value-of select="$typeProfil"/>
                                <xsl:text> -&gt; </xsl:text>
                                <xsl:value-of select="$sansEte"/>
                            </xsl:message>
                        </xsl:when>
                        <xsl:otherwise>
                            <type>
                                <name>
                                    <xsl:value-of select="../@name"/>
                                </name>
                                <package>
                                    <xsl:apply-templates select=".." mode="get-package"/>
                                </package>
                            </type>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- On ne remet pas l'association vers l'acteur par le test not(@type=$id) -->
                    <xsl:apply-templates select="../ownedAttribute[@association and not(@type=$id)]" mode="process-association"/>
                    <!-- Ajouter les stéréotypes, pour les contrôles d'accès par exemple -->
                    <xsl:apply-templates select="." mode="get-stereotypes"/>
                </association>
            </xsl:for-each>
        </Actor>
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:function name="fete:initMin">
        <xsl:param name="chaine"/>
        <xsl:value-of select="
                concat(translate(
                            substring($chaine,1,1),
                            'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                            'abcdefghijklmnopqrstuvwxyz'),
                    substring($chaine,2))"/>
    </xsl:function>

</xsl:stylesheet>
