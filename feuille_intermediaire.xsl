<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ete="http://www.jldeleage.com/mda/ns/jld.html"
                xmlns:javaee="http://xmlns.jcp.org/xml/ns/javaee"
                version="2.0"
                exclude-result-prefixes="ete">
   <xsl:param name="nomModele"/>
   <xsl:variable name="modele" select="document($nomModele)/*/*/model"/>
   <xsl:template match="/">
      <xsl:message>
         <xsl:text>NOM DU MODELE PARAMETRE </xsl:text>
         <xsl:copy-of select="$nomModele"/>
         <xsl:text> -&gt;</xsl:text>
      </xsl:message>
      <xsl:message>
         <xsl:copy-of select="$modele"/>
      </xsl:message>
      <xsl:message>
         <xsl:text>Nombre d'éléments de $modele </xsl:text>
         <xsl:value-of select="count($modele/*)"/>
         <xsl:text> dont </xsl:text>
         <xsl:value-of select="count($modele/Actor)"/>
         <xsl:text> acteur(s)</xsl:text>
      </xsl:message>
      <xsl:message>
         <xsl:text>Dernier element du modele </xsl:text>
         <xsl:copy-of select="$modele/*[last()]"/>
      </xsl:message>
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="* | @*">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>
   <xsl:template match="javaee:web-app">
      <xsl:copy>
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates/>
         <security-constraint xmlns:uml="http://www.omg.org/spec/UML/20131001"
                              xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                              xmlns:eteMD="http://www.magicdraw.com/schemas/ete.xmi"
                              xmlns:Validation_Profile="http://www.magicdraw.com/schemas/Validation_Profile.xmi"
                              xmlns:DSL_Customization="http://www.magicdraw.com/schemas/DSL_Customization.xmi"
                              xmlns:MagicDraw_Profile="http://www.omg.org/spec/UML/20131001/MagicDrawProfile"
                              xmlns:StandardProfile="http://www.omg.org/spec/UML/20131001/StandardProfile"
                              xmlns="http://xmlns.jcp.org/xml/ns/javaee">
            <xsl:text disable-output-escaping="yes">
            </xsl:text>
            <display-name>
               <xsl:text disable-output-escaping="yes">administration generale</xsl:text>
            </display-name>
            <xsl:text disable-output-escaping="yes">
            </xsl:text>
            <web-resource-collection>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <web-resource-name>
                  <xsl:text disable-output-escaping="yes">back office</xsl:text>
               </web-resource-name>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <description>
                  <xsl:text disable-output-escaping="yes">Pages d'administration CRUD</xsl:text>
               </description>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <url-pattern>
                  <xsl:text disable-output-escaping="yes">/admin/*</xsl:text>
               </url-pattern>
               <xsl:text disable-output-escaping="yes">
            </xsl:text>
            </web-resource-collection>
            <xsl:text disable-output-escaping="yes">
            </xsl:text>
            <auth-constraint>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <description>
                  <xsl:text disable-output-escaping="yes">Rôle "admin" standard</xsl:text>
               </description>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <role-name>
                  <xsl:text disable-output-escaping="yes">admin</xsl:text>
               </role-name>
               <xsl:text disable-output-escaping="yes">
            </xsl:text>
            </auth-constraint>
            <xsl:text disable-output-escaping="yes">
        </xsl:text>
         </security-constraint>
         <xsl:for-each select="$modele/Actor">
            <xsl:text disable-output-escaping="yes">
            </xsl:text>
            <security-constraint xmlns:uml="http://www.omg.org/spec/UML/20131001"
                                 xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                                 xmlns:eteMD="http://www.magicdraw.com/schemas/ete.xmi"
                                 xmlns:Validation_Profile="http://www.magicdraw.com/schemas/Validation_Profile.xmi"
                                 xmlns:DSL_Customization="http://www.magicdraw.com/schemas/DSL_Customization.xmi"
                                 xmlns:MagicDraw_Profile="http://www.omg.org/spec/UML/20131001/MagicDrawProfile"
                                 xmlns:StandardProfile="http://www.omg.org/spec/UML/20131001/StandardProfile"
                                 xmlns="http://xmlns.jcp.org/xml/ns/javaee">
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <display-name>
                  <xsl:value-of select="name"/>
               </display-name>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <web-resource-collection>
                  <xsl:text disable-output-escaping="yes">
                    </xsl:text>
                  <web-resource-name>
                     <xsl:text disable-output-escaping="yes">back office</xsl:text>
                  </web-resource-name>
                  <xsl:text disable-output-escaping="yes">
                    </xsl:text>
                  <description>
                     <xsl:text disable-output-escaping="yes">Pages à accès réservé au rôle </xsl:text>
                     <xsl:value-of select=" name "/>
                  </description>
                  <xsl:text disable-output-escaping="yes">
                    </xsl:text>
                  <url-pattern>
                     <xsl:text disable-output-escaping="yes">/</xsl:text>
                     <xsl:value-of select="name"/>
                     <xsl:text disable-output-escaping="yes">/*</xsl:text>
                  </url-pattern>
                  <xsl:text disable-output-escaping="yes">
                </xsl:text>
               </web-resource-collection>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <auth-constraint>
                  <xsl:text disable-output-escaping="yes">
                    </xsl:text>
                  <description>
                     <xsl:text disable-output-escaping="yes">Rôle accepté pour ces pages</xsl:text>
                  </description>
                  <xsl:text disable-output-escaping="yes">
                    </xsl:text>
                  <role-name>
                     <xsl:value-of select="name"/>
                  </role-name>
                  <xsl:text disable-output-escaping="yes">
                </xsl:text>
               </auth-constraint>
               <xsl:text disable-output-escaping="yes">
            </xsl:text>
            </security-constraint>
            <xsl:text disable-output-escaping="yes">
        </xsl:text>
            <xsl:if test="position() lt last()"/>
         </xsl:for-each>
         <login-config xmlns:uml="http://www.omg.org/spec/UML/20131001"
                       xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                       xmlns:eteMD="http://www.magicdraw.com/schemas/ete.xmi"
                       xmlns:Validation_Profile="http://www.magicdraw.com/schemas/Validation_Profile.xmi"
                       xmlns:DSL_Customization="http://www.magicdraw.com/schemas/DSL_Customization.xmi"
                       xmlns:MagicDraw_Profile="http://www.omg.org/spec/UML/20131001/MagicDrawProfile"
                       xmlns:StandardProfile="http://www.omg.org/spec/UML/20131001/StandardProfile"
                       xmlns="http://xmlns.jcp.org/xml/ns/javaee">
            <xsl:text disable-output-escaping="yes">
            </xsl:text>
            <auth-method>
               <xsl:text disable-output-escaping="yes">FORM</xsl:text>
            </auth-method>
            <xsl:text disable-output-escaping="yes">
            </xsl:text>
            <realm-name>
               <xsl:text disable-output-escaping="yes">secu</xsl:text>
            </realm-name>
            <xsl:text disable-output-escaping="yes">
            </xsl:text>
            <form-login-config>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <form-login-page>
                  <xsl:text disable-output-escaping="yes">login.xhtml</xsl:text>
               </form-login-page>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <form-error-page>
                  <xsl:text disable-output-escaping="yes">accesRefuse.xhtml</xsl:text>
               </form-error-page>
               <xsl:text disable-output-escaping="yes">
            </xsl:text>
            </form-login-config>
            <xsl:text disable-output-escaping="yes">
        </xsl:text>
         </login-config>
         <xsl:for-each select="$modele/Actor">
            <xsl:text disable-output-escaping="yes">
            </xsl:text>
            <security-role xmlns:uml="http://www.omg.org/spec/UML/20131001"
                           xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
                           xmlns:eteMD="http://www.magicdraw.com/schemas/ete.xmi"
                           xmlns:Validation_Profile="http://www.magicdraw.com/schemas/Validation_Profile.xmi"
                           xmlns:DSL_Customization="http://www.magicdraw.com/schemas/DSL_Customization.xmi"
                           xmlns:MagicDraw_Profile="http://www.omg.org/spec/UML/20131001/MagicDrawProfile"
                           xmlns:StandardProfile="http://www.omg.org/spec/UML/20131001/StandardProfile"
                           xmlns="http://xmlns.jcp.org/xml/ns/javaee">
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <description>
                  <xsl:text disable-output-escaping="yes">Role de </xsl:text>
                  <xsl:value-of select="name"/>
               </description>
               <xsl:text disable-output-escaping="yes">
                </xsl:text>
               <role-name>
                  <xsl:value-of select=" name "/>
               </role-name>
               <xsl:text disable-output-escaping="yes">
            </xsl:text>
            </security-role>
            <xsl:text disable-output-escaping="yes">
        </xsl:text>
            <xsl:if test="position() lt last()"/>
         </xsl:for-each>
      </xsl:copy>
   </xsl:template>
   <xsl:function name="ete:getController">
      <xsl:param name="node"/>
      <xsl:choose>
         <xsl:when test="local-name($node) = 'boundary'">
            <xsl:value-of select="ete:initMin($node/name)"/>Controller</xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="ete:getController($node/..)"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <!--Construit une chaîne à partir d'une collection
        en insérant le séparateur entre deux items.
        Séparateur par défaut : ", "-->
   <xsl:template name="liste">
      <xsl:param name="collection"/>
      <xsl:param name="separateur" select="', '"/>
      <xsl:param name="indice" select="1"/>
      <xsl:value-of select="$collection[$indice]"/>
      <xsl:if test="count($collection) &gt; $indice">
         <xsl:value-of select="$separateur"/>
         <xsl:call-template name="liste">
            <xsl:with-param name="collection" select="$collection"/>
            <xsl:with-param name="separateur" select="$separateur"/>
            <xsl:with-param name="indice" select="$indice+1"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
            
        <xsl:function name="ete:initMaj">
      <xsl:param name="chaine"/>
      <xsl:value-of select="translate(substring($chaine,1,1),                         'abcdefghijklmnopqrstuvwxyz',                         'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      <xsl:value-of select="substring($chaine, 2)"/>
   </xsl:function>
            
        <xsl:function name="ete:initMin">
      <xsl:param name="chaine"/>
      <xsl:value-of select="translate(substring($chaine,1,1),                         'ABCDEFGHIJKLMNOPQRSTUVWXYZ',                         'abcdefghijklmnopqrstuvwxyz')"/>
      <xsl:value-of select="substring($chaine, 2)"/>
   </xsl:function>
            
        <xsl:function name="ete:mots">
      <xsl:param name="chaine"/>
      <xsl:value-of select="translate(substring($chaine,1,1),                         'abcdefghijklmnopqrstuvwxyz',                         'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      <xsl:analyze-string select="substring($chaine, 2)" regex="[A-Z]">
         <xsl:matching-substring>
            <xsl:text> </xsl:text>
            <xsl:value-of select="translate(.,                         'ABCDEFGHIJKLMNOPQRSTUVWXYZ',                         'abcdefghijklmnopqrstuvwxyz')"/>
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:value-of select="."/>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:function>
            
        
            
        <xsl:function name="ete:package">
      <xsl:param name="entite"/>
      <xsl:param name="doc"/>
      <xsl:value-of select="$doc//entity[name = $entite]/package"/>
   </xsl:function>
            
        <!--
            Extrait le dernier identifiant d'un chemin de paquetage.
            Utilisé pour déterminer le dossier dans lequel ranger les
            "boundary components". Le contrôle d'accès se fait par ces
            dossiers. Il faut donc ranger les composants par paquetages
            de profils fonctionnels, le dernier identifiant de paquetage
            servant de nom de rôle dans l'ACL.
        -->
            
        <xsl:function name="ete:dernierId">
      <xsl:param name="chemin"/>
      <xsl:variable name="indice" select="1"/>
      <xsl:value-of select="substring($chemin, $indice)"/>
   </xsl:function>
   <xsl:function name="ete:typeUtilisateur">
      <xsl:param name="type"/>
      <xsl:choose>
         <xsl:when test="$type='String'">0</xsl:when>
         <xsl:when test="$type='int'">0</xsl:when>
         <xsl:when test="$type='integer'">0</xsl:when>
         <xsl:when test="$type='date'">0</xsl:when>
         <xsl:when test="$type='Date'">0</xsl:when>
         <xsl:when test="$type='java.util.Date'">0</xsl:when>
         <xsl:when test="$type='float'">0</xsl:when>
         <xsl:when test="$type='double'">0</xsl:when>
         <xsl:when test="$type='void'">0</xsl:when>
         <xsl:when test="$type='boolean'">0</xsl:when>
         <xsl:when test="$type='char'">0</xsl:when>
         <xsl:otherwise>
            <xsl:text>1</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
            
        
            
        <xsl:function name="ete:type">
      <xsl:param name="t"/>
      <xsl:choose>
         <xsl:when test="$t='time'">
            <xsl:text>String</xsl:text>
         </xsl:when>
         <xsl:when test="$t='Real'">
            <xsl:text>double</xsl:text>
         </xsl:when>
         <xsl:when test="string-length($t/package) &gt; 0">
            <xsl:value-of select="$t/package"/>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="$t/name"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$t"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <!--Construit une chaîne à partir d'une collection
        en insérant le séparateur entre deux items-->
   <xsl:function name="ete:liste">
      <xsl:param name="collection"/>
      <xsl:param name="separateur"/>
      <xsl:call-template name="liste">
         <xsl:with-param name="collection" select="$collection"/>
         <xsl:with-param name="separateur" select="$separateur"/>
         <xsl:with-param name="indice" select="1"/>
      </xsl:call-template>
   </xsl:function>
   <!--Construit une chaîne à partir d'une collection
        en insérant le séparateur avant chaque majuscule interne.
        Séparateur par défaut : " ".
        La majuscule est remplacée par une minuscule-->
   <xsl:function name="ete:decamelisation">
      <xsl:param name="chaine"/>
      <xsl:variable name="resultat">
         <xsl:analyze-string regex="[A-Z]" select="$chaine">
            <xsl:matching-substring>
               <xsl:text> </xsl:text>
               <xsl:value-of select="translate(.,                                 'ABCDEFGHIJKLMNOPQRESTUVWXYZ',                                 'abcdefghijklmnopqrstuvwxyz')"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
               <xsl:value-of select="."/>
            </xsl:non-matching-substring>
         </xsl:analyze-string>
      </xsl:variable>
      <xsl:value-of select="$resultat"/>
   </xsl:function>
   <xsl:function name="ete:versAscii">
      <xsl:param name="chaine"/>
      <xsl:value-of select="translate($chaine, 'àâäéèêëîïôöùûü', 'aaaeeeeiioouuu')"/>
   </xsl:function>
   <xsl:function name="ete:camel2el">
      <xsl:param name="chaine"/>
      <xsl:value-of select="translate($chaine, '_', '.')"/>
   </xsl:function>
</xsl:stylesheet>