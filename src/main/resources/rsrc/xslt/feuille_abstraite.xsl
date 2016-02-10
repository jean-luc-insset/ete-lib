<?xml version="1.0" encoding="UTF-8"?>


<!--
    Document   : identite.xsl
    Created on : 3 octobre 2010, 18:59
    Author     : jldeleage
    Description:
        "Super-classe" des feuilles de lecture des différentes versions
        de XMI/UML.
        Contient des règles par défaut et des règles utilitaires
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ete="http://www.magicdraw.com/schemas/ete.xmi"
                xmlns:xmi='http://www.omg.org/spec/XMI/20110701'
                xmlns:fete="http://www.insset.u-picardie.fr/jeanluc/ete.html"
                version="2.0">

    <xsl:output method="xml" indent="yes"/>

    <!-- 0 : tout
         1 : tout sauf finest
         2 : finer et au-dessus
         3 : fine et au-dessus
         4 : info
         5 : warning
         6 : severe
      -->
    <xsl:param name="niveau-log" select="5"/>
    

    <xsl:template match="*" mode="select-ete-model" priority="-20">
        <xsl:if test="2 &gt;= $niveau-log">
            <xsl:message>
                <xsl:text>Ceci n'est pas un modele ete : </xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text> : </xsl:text>
                <xsl:value-of select="namespace-uri()"/>
                <xsl:text> - </xsl:text>
                <xsl:value-of select="@name"/>
            </xsl:message>
        </xsl:if>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--                        G E N E R A L I T E S                        -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <!-- La feuille principale invoque cette règle pour avoir produire un
         log indiquant les informations spécifiques à la version traitée
      -->
    <xsl:template match="*" mode="info">
        <xsl:message>Pas de version spécifique de XMI</xsl:message>
    </xsl:template>

    <!--
          Le document traité est dans l'espace de noms
          Il faut que l'élément d'extension XMI soit dans le même espace de
          noms.
          La feuille principale demande donc le nom de l'élément à créer,
          ou plutôt son espace de noms.
      -->
    <xsl:template match="*" mode="create-extension-element">
        <xmi:Extension extender="ete">
            <xsl:apply-templates select="." mode="callback-extension-element"/>
        </xmi:Extension>
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--             T R A I T E M E N T S   P A R   D E F A U T             -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <!-- La feuille principale demande à la feuille spécifique de retrouver
         les classes, les acteurs, etc.
         Chacune de ces règles doit être redéfinie dans les feuilles
         spécifiques et contenir uniquement l'invocation de la règle
         process-xxx correspondante sur les éléments ad-hoc.
         Exemple :
         <xsl:template match="packagedElement[@xmi:type='uml:Class']
                        mode="select-classes">
             <xsl:apply-templates select="." mode="selected-class"/>
         </xsl:template>
         Les méthodes ne sont placées ici qu'à titre d'information, elles
         sont d'ailleurs mises en commentaire, car la règle suivante par
         défaut intercepte toutes les invocations non traitées en ne faisant
         rien.
      -->
<!--    <xsl:template match="*" mode="select-classes" priority="-10"/>
    <xsl:template match="*" mode="select-actors" priority="-10"/>
    <xsl:template match="*" mode="select-scenarios" priority="-10"/>
    <xsl:template match="*" mode="select-attributes" priority="-10"/>
    <xsl:template match="*" mode="select-superclasses" priority="-10"/>
    <xsl:template match="*" mode="select-interfaces" priority="-10"/>-->
 

    <xsl:template match="*" mode="#all" priority="-1000">
        <!-- Ne rien faire -->
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--                        S T E R E O T Y P E S                        -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <!--
      - Produit l'element <stereotypes> qui contient un élément par
      - stereotype appliqué à l'élément de contexte.
      - Ne s'applique qu'aux stéréotypes standard sur Class et aux
      - stéréotypes "ete".
      -->
    <xsl:template match="*" mode="get-stereotypes">
        <stereotypes>
            <xsl:for-each select="//*[@base_Class=current()/@id]">
                <xsl:element name="{local-name()}">
                    <!-- copie des attributs (dont les tag values) -->
                    <xsl:for-each select="@*">
                        <xsl:element name="{local-name()}">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="//*[@base_Element=current()/@id]">
                <xsl:element name="{local-name()}">
                    <xsl:for-each select="@*">
                        <xsl:element name="{local-name()}">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
            <!-- Rechercher les stéréotypes "hérités" des paquetages englobants -->
            <xsl:apply-templates select=".." mode="recherche-stereotypes"/>
        </stereotypes>
    </xsl:template>


    <xsl:template match="* | /" mode="recherche-stereotypes">
        <xsl:message>
            <xsl:text>Recherche de stereotypes de </xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text> id=</xsl:text>
            <xsl:value-of select="@*[local-name(.)='id']"/>
        </xsl:message>
        <xsl:for-each select="//*[@base_Element=current()/@*[local-name(.)='id']]">
            <xsl:message>
                <xsl:text>   TROUVE : </xsl:text>
                <xsl:value-of select="local-name(.)"/>
            </xsl:message>
            <xsl:element name="{local-name(.)}">
                    <xsl:for-each select="@*">
                        <xsl:element name="{local-name()}">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
            </xsl:element>
        </xsl:for-each>
        <xsl:apply-templates select=".." mode="recherche-stereotypes"/>
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--                            C L A S S E S                            -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <!-- Cette méthode sert d'aiguillage pour les méthodes définies dans
         les sous-classes.
         Cela permet d'effectuer des traitements différents sur une même
         sélection sans que la feuille appelée ait à gérer les différences :
         elle se contente de filtrer les éléments et d'invoquer une règle
         sur chaque élément filtré.
         Si le mode de la règle n'est pas traité explicitement, la
         règle d'aiguillage ci-dessous invoque la règle définie par le
         pramètre tunnel "action".
         Donc si on appelle deux fois la même règle de sélection en passant
         des valeurs différentes au paramètre "action", on obtient la même
         sélection mais on applique des règles différentes.
         Par exemple pour faire un traitement x sur les classes, la feuille
         principale écrit :
         <xsl:apply-templates select=".//*" mode="select-classes">
            <xsl:with-param name="action" select="'x'"/>
         </xsl:apply-templates>
      -->
    <xsl:template match="*" mode="selected-class" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:choose>
            <xsl:when test="$action='process-class'">
                <xsl:apply-templates select="." mode="process-class"/>
            </xsl:when>
            <xsl:when test="$action='has-subclasses'">
<!--                <xsl:message>Aiguillage vers has-subclasses</xsl:message>-->
                <xsl:apply-templates select="." mode="has-subclasses"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*" mode="selected-enumeration" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:if test="$action='process-enumeration'">
            <xsl:apply-templates select="." mode="process-enumeration"/>
        </xsl:if>
    </xsl:template>
    

    <xsl:template match="* | @*" mode="selected-superclass" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:choose>
            <xsl:when test="$action='process-superclass'">
                <xsl:apply-templates select="." mode="process-superclass"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

  
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- A T T R I B U T S                                                   -->
    <!-- ( P R O P R I E T E S   E T   A S S O C I A T I O N S )             -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    
    <xsl:template match="* | @*" mode="selected-attribute" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>

        <xsl:choose>
            <xsl:when test="$action='process-attribute'">
                <xsl:apply-templates select="." mode="process-attribute"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- Renvoie "property" ou "association" -->
    <xsl:template match="*" mode="get-nature-of-attribute">
        <xsl:choose>
            <xsl:when test="@association">
                <xsl:text>association</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>property</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Renvoie la cardinalité. La méthode par défaut renvoie 1
         Redéfinir dans les feuilles spécifiques.
         TODO : essayer de fournir une méthode par défaut plus précise.
      -->
    <xsl:template match="* | @*" mode="get-cardinality">
        <xsl:text>1</xsl:text>
    </xsl:template>


    <!-- Ceci ne fonctionne que pour les types primitifs -->
    <xsl:template match="*" mode="get-type">
        <param name="level" tunnel="yes" select="0"/>
        <!--<xsl:message>******************** APPEL DE get-type ******************** </xsl:message>-->
        <xsl:message>
            <xsl:text>Recherche du type correspondant à :</xsl:text>
            <xsl:value-of select="@type"/>
        </xsl:message>
        <xsl:choose>
            <xsl:when test="key('byId', @type)">
                <xsl:message>
                    <xsl:text>PASSAGE DANS UNE RECHERCHE DE TYPE UTILISATEUR DANS get-type pour</xsl:text>
                    <xsl:value-of select="@name"/>
                </xsl:message>
                <name>
                    <xsl:value-of select="key('byId', @type)/@name"/>
                </name>
                <package>
                    <xsl:apply-templates select="key('byId', @type)" mode="get-package"/>
                </package>
            </xsl:when>
            <xsl:otherwise>
                <name>
                    <xsl:if test="local-name() = 'qualifier'">
                        <xsl:message>Type present : <xsl:value-of select="count(@type)&gt;0"/></xsl:message>
                        <xsl:message>
                            <xsl:text> chaine : </xsl:text>
                            <xsl:value-of select="type/*/*/@referentPath"/>
                        </xsl:message>
                    </xsl:if>
                    <xsl:call-template
                        name="extrais-type">
                        <xsl:with-param name="chaine"
                            select="type/*/*/@referentPath"
                        />
                    </xsl:call-template>
                </name>
                <package></package>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*" mode="get-type-param">
        <xsl:choose>
            <xsl:when test="key('byId', @type)">
                <name>
                    <xsl:value-of select="key('byId', @type)/@name"/>
                </name>
                <package>
                    <xsl:apply-templates select="key('byId', @type)" mode="get-package"/>
                </package>
            </xsl:when>
            <xsl:when test="not(type)">
                <name>Object</name>
            </xsl:when>
            <xsl:otherwise>
                <name>
                <xsl:call-template
                    name="extrais-type">
                    <xsl:with-param name="chaine"
                        select="type/*/*/@referentPath"
                    />
                </xsl:call-template>
                </name>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Méthode "privée". Ne devrait pas être invoquée directement par une
         autre feuille.
      -->
    <xsl:template name="extrais-type">
        <xsl:param name="chaine"/>
        <xsl:choose>
            <xsl:when test="contains($chaine, '::')">
                <xsl:call-template name="extrais-type">
                    <xsl:with-param name="chaine"
                        select="substring-after($chaine, '::')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$chaine"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


<!--    <xsl:template match="* | @*" mode="selected-association" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>

        <xsl:choose>
            <xsl:when test="$action='process-association'">
                <xsl:message>    traitement de l'association...</xsl:message>
                <xsl:apply-templates select="." mode="process-association"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->

    <xsl:template match="*" mode="selected-association" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:choose>
            <xsl:when test="$action='process-association'">
                <xsl:apply-templates select="." mode="process-association"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*" mode="selected-mappedBy" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:param name="mappedBy" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="$action='process-mappedBy'">
                <xsl:comment> *** Appel de process-mappedBy *** </xsl:comment>
                <xsl:apply-templates select="." mode="process-mappedBy"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="* | @*" mode="selected-reverse-cardinality" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:choose>
            <xsl:when test="$action='process-reverse-cardinality'">
                <xsl:apply-templates select="." mode="process-reverse-cardinality"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>




    <xsl:template match="ownedRule" mode="selected-invariant" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:choose>
            <xsl:when test="$action='process-invariant'">
                <xsl:apply-templates select="." mode="process-invariant"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- O P E R A T I O N S                                                 -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="* | @*" mode="selected-operation" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>

        <xsl:choose>
            <xsl:when test="$action='process-operation'">
                <xsl:apply-templates select="." mode="process-operation"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*" mode="selected-result-specification" priority="-200">
        <xsl:apply-templates select="." mode="process-result-specification"/>
    </xsl:template>


    <xsl:template match="*" mode="selected-param" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:choose>
            <xsl:when test="$action='process-param'">
                <xsl:apply-templates select="." mode="process-param"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="* | @*" mode="selected-precondition" priority="-200">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>
        <xsl:choose>
            <xsl:when test="$action='process-precondition'">
                <xsl:apply-templates select="." mode="process-precondition"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="* | @*" mode="selected-postcondition">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>

        <xsl:choose>
            <xsl:when test="$action='process-postcondition'">
                <xsl:apply-templates select="." mode="process-postcondition"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="* | @*" mode="get-name-of-condition">
        <xsl:text>ConditionAnonyme</xsl:text>
    </xsl:template>


    <xsl:template match="* | @*" mode="get-expression-of-condition"/>


    <xsl:template match="*" mode="get-name">
        <xsl:value-of select="@name"/>
    </xsl:template>


    <xsl:template match="ownedOperation" mode="get-type-of-operation">
        <xsl:choose>
            <xsl:when test="ownedParameter[@direction='return']">
                <xsl:apply-templates select="ownedParameter[@direction='return']" mode="get-type-param"/>
            </xsl:when>
            <xsl:otherwise>
                <name>
                    <xsl:text>void</xsl:text>
                </name>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ownedParameter" mode="select-params">
<!--        <xsl:message>
            <xsl:text>Evaluation du paramètre </xsl:text>
            <xsl:value-of select="@name"/>
        </xsl:message>-->
        <xsl:if test="not(@direction='return')">
<!--            <xsl:message>
                <xsl:text>C'est bien un paramètre...</xsl:text>
            </xsl:message>-->
            <xsl:apply-templates select="." mode="selected-param"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="* | @*" mode="selected-body">
        <xsl:param name="action" tunnel="yes" select="'no-action'"/>

        <xsl:choose>
            <xsl:when test="$action='process-body'">
                <xsl:apply-templates select="." mode="process-body"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="body" mode="select-body">
        <xsl:if test="../../@name='body'">
        <xsl:apply-templates select="." mode="selected-body"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="*" mode="has-stereotype">
        <xsl:param name="element"/>
        <xsl:value-of select="true()"/>
    </xsl:template>


    <xsl:template match="*" mode="get-package">
<!--        <xsl:message>
            <xsl:text>Dans get-package </xsl:text>
            <xsl:value-of select="@name"/>
        </xsl:message>-->
        <xsl:if test="../@*[local-name()='type']='uml:Package'">
            <xsl:apply-templates select=".." mode="_get-package"/>
        </xsl:if>
    </xsl:template>


    <!-- 
      - Méthode interne. Ne devrait être appelée que sur un package.
      -->
    <xsl:template match="*" mode="_get-package">
<!--        <xsl:message>
            <xsl:text>Dans _get-package </xsl:text>
            <xsl:value-of select="@name"/>
        </xsl:message>-->
        <xsl:if test="../@*[local-name()='type']='uml:Package'">
            <xsl:apply-templates select=".." mode="_get-package"/>
            <xsl:text>.</xsl:text>
        </xsl:if>
        <xsl:value-of select="@name"/>
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- D E T E C T I O N   D E   L ' H E R I T A G E                       -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="*" mode="select-superclasses">
        <xsl:if test="generalization/@general">
            <xsl:apply-templates select="id(generalization/@general)"/>
        </xsl:if>
    </xsl:template>



    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- N A T U R E   D E   L ' E L E M E N T                               -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <!-- Une classe est une entité si elle porte le stéréotype standard entity
         ou si elle est dans un paquet portant le stéréotype entity-package.
         L'inclusion est récursive.
         Ce stéréotype est non standard.
      -->
    <xsl:function name="fete:isEntity">
        <xsl:param name="classe"/>
        <xsl:value-of select="true()"/>
    </xsl:function>

    <xsl:function name="fete:isBoundary">
        <xsl:param name="classe"/>
        <xsl:value-of select="true()"/>
    </xsl:function>

    <xsl:function name="fete:isService">
        <xsl:param name="classe"/>
        <xsl:value-of select="false()"/>
    </xsl:function>

    <xsl:function name="fete:isComponent">
        <xsl:param name="classe"/>
        <xsl:value-of select="true()"/>
    </xsl:function>

    <xsl:function name="fete:isPackage">
        <xsl:param name="packagedElement"/>
        <xsl:value-of select="$packagedElement/@*[local-name()='type']='uml:Package'"/>
    </xsl:function>

    <xsl:function name="fete:hasStereotype">
        <xsl:param name="stereotype"/>
        <xsl:value-of select="false()"/>
    </xsl:function>

  
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!--             P A R C O U R S   D ' A S S O C I A T I O N             -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:function name="fete:opposee">
        <xsl:param name="attribute"/>
        <xsl:param name="association"/>
        <xsl:for-each select="memberEnd">
            <xsl:if test="not(@xmi:idref = $attribute/@xmi:id)">
<!--                <xsl:message>
                    <xsl:text>Opposee : </xsl:text>
                    <xsl:value-of select="@xmi:idref"/>
                </xsl:message>-->
                <xsl:copy-of select="id(@xmi:idref)"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- U T I L I T A I R E S   D E   L O G                                 -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="*" mode="dump">
        <xsl:message>
            <xsl:value-of select="name()"/>
            <xsl:text> : </xsl:text>
        </xsl:message>
        <xsl:for-each select="@*">
            <xsl:message>
                <xsl:text>    </xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>=</xsl:text>
                <xsl:value-of select="."/>
            </xsl:message>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="@*" mode="dump">
        <xsl:message>
            <xsl:value-of select="name()"/>
            <xsl:text> : </xsl:text>
            <xsl:value-of select="."/>
        </xsl:message>
    </xsl:template>

    <xsl:template match="* | /" mode="xpath">
        <xsl:apply-templates select=".." mode="xpath"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[local-name() = local-name(current())])+1"/>
        <xsl:text>]</xsl:text>
    </xsl:template>

</xsl:stylesheet>
