/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run.factories;

import com.jldeleage.mda.run.Contexte;
import com.jldeleage.mda.transfo.ExceptionTransformation;
import com.jldeleage.mda.transfo.Transformation;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;



/**
 *
 * @author jldeleage
 */
public abstract class AbstractFactory {

    public final Transformation nouvelleTransformation(Element elt, Contexte inContexte) throws ExceptionTransformation {
        Transformation resultat = creeTransformation();
        Map<String, String> params = lisParametres(elt);
        Contexte nouveauContexte = new Contexte(inContexte);
        nouveauContexte.setParametresLocaux(params);
        lisSpecificites(resultat, elt, nouveauContexte);
        return resultat;
    }


    /**
     * Chaque Factory concr&egrave;te renvoie une transformation "ad hoc".
     * 
     * @return 
     */
    protected abstract Transformation creeTransformation();


    /**
     * Chaque Factory initialise la transformation &agrave; l'aide d'un
     * &eacute;l&eacute;ment XML.
     */
    public void lisSpecificites(Transformation inoutTransformation, Element elt, Contexte inContextes)
            throws ExceptionTransformation {
        Logger.getLogger(getClass().getName()).log(Level.INFO, "La transformation {0} n''a pas d''items sp\u00e9cifiques", getClass().getName());
    }


    /**
     * Lit les param&egrave;tres internes &agrave; l'&eacute;l&eacute;ment.<br/>
     * L'ex&eacute;cution du pas ajoute ces param&egrave;tres au contexte
     * courant.
     * 
     * @param elt
     * @return
     * @throws ExceptionTransformation 
     */
    private Map<String, String> lisParametres(Element elt) throws ExceptionTransformation {
        Map<String, String> resultat = new HashMap<>();
        NodeList elementsParams = elt.getElementsByTagName("param");
        for (int i=0 ; i<elementsParams.getLength() ; i++) {
            Element suivant = (Element) elementsParams.item(i);
            String nomParam = suivant.getAttribute("name");
            String valeur = suivant.getAttribute("value");
            resultat.put(nomParam, valeur);
        }
        return resultat;
    }


    protected String lisValeurSousElement(Element elt, String inNomSousElement) {
        NodeList sousElements = elt.getElementsByTagName(inNomSousElement);
        for (int i=0 ; i<sousElements.getLength() ; i++) {
            Node sousElement = sousElements.item(i);
            if (sousElement instanceof Element) {
                Node texte = sousElement.getFirstChild();
                if (texte != null) {
                    return texte.getNodeValue().trim();
                }
            }
        }
        return null;
    }


}
