/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run.factories;

import com.jldeleage.mda.run.Contexte;
import com.jldeleage.mda.transfo.ApplicateurTemplate;
import com.jldeleage.mda.transfo.ExceptionTransformation;
import com.jldeleage.mda.transfo.Transformation;
import java.net.MalformedURLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.crypto.dsig.TransformException;
import org.w3c.dom.Element;

/**
 *
 * @author jldeleage
 */
public class TemplateFactory extends AbstractFactory {

    @Override
    public Transformation creeTransformation() {
        ApplicateurTemplate applicateurTemplate = new ApplicateurTemplate();
        return applicateurTemplate;
    }

    @Override
    public void lisSpecificites(Transformation inoutTransformation, Element elt, Contexte inContextes) throws ExceptionTransformation {
        ApplicateurTemplate applicateur = (ApplicateurTemplate) inoutTransformation;
        String nomTemplate = elt.getAttribute("template");
        try {
            applicateur.setTemplate(nomTemplate);
        } catch (MalformedURLException ex) {
            Logger.getLogger(TemplateFactory.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
