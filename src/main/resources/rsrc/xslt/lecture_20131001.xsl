<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : lectureMD.xsl
    Created on : 1 novembre 2010, 22:32
    Author     : jldeleage
    Description:
        Lit un document MagicDraw (ou plus généralement UML 2.x / XMI 2.y)
        et produit un modèle "ete".
        Les espaces de noms traités par cette feuille sont :
        UML : http://www.omg.org/spec/UML/20131001
        XMI : http://www.omg.org/spec/XMI/20131001
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
        xmlns:fete="http://www.insset.u-picardie.fr/jeanluc/ete.html"
        xmlns:ete='http://www.magicdraw.com/schemas/ete.xmi'
        xmlns:uml-2-3='http://www.omg.org/spec/UML/20131001'
        xmlns:xmi-2-2='http://www.omg.org/spec/XMI/20131001'
        xmlns:StandardProfile='http://www.omg.org/spec/UML/20131001/StandardProfile'
        xmlns:uml='http://www.omg.org/spec/UML/20131001'
        xmlns:xmi='http://www.omg.org/XMI'
        xmlns:xmi-gen="http://www.omg.org/XMI"
>


<!--<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
 xmlns:uml_2_2='http://schema.omg.org/spec/UML/2.2'
 xmlns:xmi='http://www.omg.org/spec/XMI/20131001'
 xmlns:ete="http://www.magicdraw.com/schemas/ete.xmi"
 xmlns:MagicDraw_Profile='http://www.magicdraw.com/schemas/MagicDraw_Profile.xmi'
 xmlns:Validation_Profile='http://www.magicdraw.com/schemas/Validation_Profile.xmi'
 xmlns:DSL_Customization='http://www.magicdraw.com/schemas/DSL_Customization.xmi'
 xmlns:UML_Standard_Profile='http://www.magicdraw.com/schemas/UML_Standard_Profile.xmi'
 xmlns:stéréotypes='http://www.magicdraw.com/schemas/stéréotypes.xmi'>-->


    <xsl:output method="xml" indent="yes"/>


    <xsl:key name="byId" match="*" use="@*[local-name()='id']"  />
    <xsl:key name="entitesEsseulees"
             match="StandardProfile:Entity" use="@base_Class"/>
    <xsl:key name="boundariesEsseulees"
             match="StandardProfile:Boundary" use="@base_Class"/>


    <!-- Normalement, cette feuille est importée ou incluse
     Cependant, la règle "match /" est fournie pour permettre une
     utilisation autonome.
     Elle a une priorité faible au cas où la feuille serait incluse.
     -->
    <xsl:template match="/" priority="-10">
        <xsl:message>
            <xsl:text>TODO : écrire la règle principale de la feuille
                lecture_20131001.xsl</xsl:text>
        </xsl:message>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="xmi-2-2:XMI" mode="info">
        <xsl:message>Document UML-2.3 et XMI-2.2. Versions du 01/10/2013</xsl:message>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- F I L T R A G E   des classes, attributs, opérations                -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="uml-2-3:Model[@*='uml:Model']"
                  mode="select-ete-model">
<!--        <xsl:message>Modele été : </xsl:message>-->
        <xsl:apply-templates select="." mode="ete-model"/>
    </xsl:template>


    <xsl:template match="packagedElement[@*='uml:Class']" mode="select-classes">
        <xsl:apply-templates select="." mode="selected-class"/>
    </xsl:template>

    <xsl:template match="packagedElement[@*='uml:Enumeration']" mode="select-enumerations">
        <xsl:apply-templates select="." mode="selected-enumeration"/>
    </xsl:template>

    <xsl:template match="packagedElement[@*='uml:Actor']" mode="select-actors">
        <xsl:message>Détection d'un acteur : <xsl:value-of select="@name"/></xsl:message>
        <xsl:apply-templates select="." mode="selected-actor"/>
    </xsl:template>

    <xsl:template match="ownedAttribute" mode="select-attributes">
        <xsl:if test="not(@association)">
            <xsl:apply-templates select="." mode="selected-attribute"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ownedOperation" mode="select-operations">
        <xsl:apply-templates select="." mode="selected-operation"/>
    </xsl:template>


    <xsl:template match="ownedAttribute" mode="select-associations">
        <xsl:if test="@association">
<!--            <xsl:message>
                <xsl:text>ASSOCIATION</xsl:text>
            </xsl:message>-->
            <xsl:apply-templates select="." mode="selected-association"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="packagedElement" mode="does-it-have-subclasses">
<!--        <xsl:if test="@name='Operation'">
            <xsl:message>
                <xsl:text>Recherche des sous-classes de "Operation"</xsl:text>
            </xsl:message>
        </xsl:if>-->
        <xsl:if test="//generalization/@general=current()/@id">
<!--            <xsl:message>Sous-classes trouvees</xsl:message>-->
            <xsl:apply-templates select="." mode="selected-class"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="select-superclasses">
        <xsl:if test="generalization/@general">
            <xsl:apply-templates select="//*[@id=current()/generalization/@general]"
                    mode="selected-superclass"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="packagedElement/ownedRule" mode="select-invariants">
        <xsl:apply-templates select="." mode="selected-invariant"/>
    </xsl:template>


<!--    <xsl:template match="*" mode="select-invariants">
    </xsl:template>-->




    <xsl:template match="postcondition" mode="select-postconditions">
        <xsl:apply-templates select="../ownedRule/@*[.=current()/@idref]/.."
                    mode="select-postconditions-2"/>
    </xsl:template>


    <xsl:template match="ownedRule[specification/language='OCL2.0']" mode="select-postconditions-2">
        <xsl:variable name="body" select="normalize-space(specification/body)"/>
        <xsl:variable name="apres-result" select="normalize-space(substring-after($body, 'result'))"/>
        <xsl:choose>
            <xsl:when test="not(starts-with($body, 'result'))">
                <xsl:apply-templates select="." mode="selected-postcondition"/>
            </xsl:when>
            <xsl:when test="not(starts-with($apres-result, '='))">
                <xsl:apply-templates select="." mode="selected-postcondition"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="precondition" mode="select-preconditions">
        <xsl:apply-templates select="../ownedRule/@*[.=current()/@*]/.."
                    mode="select-preconditions-2"/>
    </xsl:template>



    <xsl:template match="ownedRule[specification/language='OCL2.0']" mode="select-preconditions-2">
        <xsl:variable name="body" select="normalize-space(specification/body)"/>
        <xsl:variable name="apres-result" select="normalize-space(substring-after($body, 'result'))"/>
        <xsl:choose>
            <xsl:when test="not(starts-with($body, 'result'))">
                <xsl:apply-templates select="." mode="selected-precondition"/>
            </xsl:when>
            <xsl:when test="not(starts-with($apres-result, '='))">
                <xsl:apply-templates select="." mode="selected-precondition"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ownedRule" mode="get-expression-of-condition">
        <xsl:apply-templates select="specification" mode="get-expression-of-condition">
        </xsl:apply-templates>
    </xsl:template>


    <xsl:template match="specification[language='OCL2.0']" mode="get-expression-of-condition">
        <xsl:value-of select="body"/>
    </xsl:template>


    <xsl:template match="specification[language='OCL2.0']" mode="select-result-specification">
        <xsl:if test="starts-with(normalize-space(body), 'result')">
            <xsl:variable name="sans-result" select="substring-after(body, 'result')"/>
            <xsl:if test="starts-with(normalize-space($sans-result),'=')">
                <xsl:apply-templates select="body" mode="selected-result-specification"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>


    <xsl:template match="*" mode="get-result-specification">
        <xsl:value-of select="normalize-space(substring-after(., '='))"/>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- D E T E C T I O N   D E S   S T E R E O T Y P E S                   -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <xsl:template match="*" mode="is-entity">
        <xsl:param name="classe"/>
        <xsl:choose>
            <xsl:when test="key('entitesEsseulees', @*[local-name(.)='id'])">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="is-in-entity-package"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="* | /" mode="is-in-entity-package">
        <xsl:choose>
            <xsl:when test="//ete:entity_package/@base_Package=current()/@*[local-name()='id']">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select=".." mode="is-in-entity-package"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*" mode="is-boundary">
        <xsl:param name="classe"/>
        <xsl:choose>
            <xsl:when test="key('boundariesEsseulees', @*[local-name(.)='id'])">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="is-in-boundary-package"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="* | /" mode="is-in-boundary-package">
        <xsl:choose>
            <xsl:when test="not(@name)">
<!--                <xsl:message>
                    <xsl:text>Pas de nom => false</xsl:text>
                </xsl:message>-->
                <xsl:value-of select="false()"/>
            </xsl:when>
            <xsl:when test="//ete:boundary_package/@base_Package=current()/@*[local-name()='id']">
                <xsl:message>
                    <xsl:value-of select="@name"/>
                    <xsl:text> est marqué "boundary"</xsl:text>
                </xsl:message>
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:when test="..">
                <xsl:apply-templates select=".." mode="is-in-boundary-package"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Ce n'est pas un boundary</xsl:message>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <!-- A C C E S S E U R S                                                 -->
    <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


    <!--
      - Renvoie l'élément <packagedElement[@type='uml:Association']>
      - correspondant à l'attribut @association
      -->
    <xsl:template match="ownedAttribute" mode="get-association"
                xmlns:xmi='http://www.omg.org/XMI'>
<!--        <xsl:copy-of select="//*[@*[local-name()='id']=current()/@association]"/>-->
        <xsl:copy-of select="key('byId', @association)"/>
    </xsl:template>


    <!-- Le noeud de contexte est l'attribut au départ de l'association ou
         un "ownedEnd" pour une extrêmité non navigable
    -->
    <xsl:template match="ownedAttribute | ownedEnd" mode="get-cardinality-assoc">
        <xsl:choose>
<!--            <xsl:when test="qualifier">
                <xsl:text>Many</xsl:text>
            </xsl:when>-->
            <xsl:when test="upperValue/@value='*'">
                <xsl:text>Many</xsl:text>
            </xsl:when>
            <xsl:when test="*/*/upperValue/@value='*'">
                <xsl:text>Many</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>One</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ownedAttribute" mode="select-mappedBy">
        <xsl:variable name="self" select="@*[local-name()='id']"/>
        <xsl:variable name="assoc">
            <xsl:copy-of select="key('byId', @association)"/>
        </xsl:variable>
        <xsl:variable name="id-oppose">
            <xsl:for-each select="$assoc/*/*/@*[local-name()='idref']">
                <xsl:if test="not (. = $self)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$assoc/*/*">
             <xsl:apply-templates select="key('byId', $id-oppose)" mode="selected-mappedBy">
                 <xsl:with-param tunnel="yes"
                     name="mappedBy"
                     select="$id-oppose"/>
             </xsl:apply-templates>
        </xsl:if>
    </xsl:template>


    <xsl:template match="ownedAttribute" mode="get-both-cardinalities">
        <xsl:variable name="self" select="@*[local-name()='id']"/>
        <xsl:variable name="assoc">
            <xsl:copy-of select="key('byId', @association)"/>
        </xsl:variable>
<!--        <xsl:message>
            <xsl:text>SELF</xsl:text>
            <xsl:copy-of select="."/>
        </xsl:message>-->
        <xsl:variable name="id-oppose">
            <xsl:for-each select="$assoc/*/*/@*[local-name()='idref']">
<!--                <xsl:message>
                    <xsl:text>Test de </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:message>-->
                <xsl:if test="not (. = $self)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
<!--        <xsl:message>
            <xsl:text>Id de l'oppose : </xsl:text>
            <xsl:value-of select="$id-oppose"/>
        </xsl:message>-->
        <!-- Si l'association est navigable dans l'autre sens, on prend la
             cardinalité indiquée.
             Sinon, on prend Many
          -->
        <xsl:variable name="from">
            <xsl:choose>
                <xsl:when test="key('byId', $id-oppose)">
<!--                    <xsl:message>
                        <xsl:text>Examen de la cardinalité de l'association opposée </xsl:text>
                        <xsl:copy-of select="key('byId', $id-oppose)"/>
                    </xsl:message>-->
                    <xsl:variable name="res">
                        <xsl:apply-templates select="key('byId', $id-oppose)" mode="get-cardinality-assoc"/>
                    </xsl:variable>
<!--                    <xsl:message>
                        <xsl:value-of select="$res"/>
                    </xsl:message>-->
                    <xsl:value-of select="$res"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Many</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="to">
            <xsl:apply-templates select="." mode="get-cardinality-assoc"/>
        </xsl:variable>
        <xsl:value-of select="concat($from, 'To', $to)"/>
    </xsl:template>


    <xsl:template match="ownedAttribute" mode="get-type">
        <xsl:choose>
            <xsl:when test="@association">
                <name>
                    <xsl:value-of select="key('byId', @type)/@name"/>
                </name>
                <package>
                    <xsl:apply-templates select="key('byId', @type)" mode="get-package"/>
                </package>
                <xsl:copy-of select="key('byId', @type)/stereotypes"/>
            </xsl:when>
            <!-- Type scalaire -->
            <xsl:otherwise>
                <xsl:variable name="intermediaire">
                <xsl:value-of select=
                        "key('byId', substring-after(current()/type/@href, '#'))[1]/@name"/>
                </xsl:variable>
<!--                <xsl:message>
                    <xsl:text>Type extrait : </xsl:text>
                    <xsl:value-of select="$intermediaire"/>
                </xsl:message>-->
                <xsl:choose>
                    <xsl:when test="$intermediaire = 'date'">
                        <name>
                        <xsl:text>Date</xsl:text>
                        </name>
                        <package>
                            <xsl:text>java.util</xsl:text>
                        </package>
                    </xsl:when>
                    <xsl:when test="not(type)">
                        <name>Object</name>
                    </xsl:when>
                    <xsl:when test="string-length($intermediaire) = 0">
                        <name>String</name>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- type scalaire ou String -->
                        <name>
                        <xsl:value-of select="$intermediaire"/>
                        </name>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!--    <xsl:template match="qualifier" mode="get-type">
        <name>
            <xsl:value-of select="key('byId', @type)/@name"/>
        </name>
        <package>
            <xsl:apply-templates select="key('byId', @type)" mode="get-package"/>
        </package>
    </xsl:template>-->


    <xsl:template name="extrais-type">
        <xsl:param name="chaine"/>
<!--        <xsl:message>
            <xsl:text>Extraction du type de </xsl:text>
            <xsl:value-of select="$chaine"/>
        </xsl:message>-->
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


</xsl:stylesheet>
