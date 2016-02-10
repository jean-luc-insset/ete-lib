/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run.factories;

import com.jldeleage.mda.run.Contexte;
import com.jldeleage.mda.run.PasComplexe;
import com.jldeleage.mda.run.PasModule;
import com.jldeleage.mda.run.Runner;
import com.jldeleage.mda.transfo.Transformation;
import org.w3c.dom.Element;
import sun.security.pkcs11.Secmod.Module;

/**
 *
 * @author jldeleage
 */
public class ModuleFactory extends AbstractFactory {


    @Override
    public Transformation creeTransformation() {
        return new PasModule();
    }


    /**
     * Les param&egrave;tres sont d&eacute;j&agrave; lus et mis dans la
     * transformation, y compris ceux h&eacute;rit&eacute;s du contexte
     * parent.
     */
    @Override
    public void lisSpecificites(Transformation inoutTransformation, Element elt, Contexte inContexte) {
        // Lire l'URL du fichier de configuration du module
        String url = elt.getAttribute("href");
        // Eventuellement, lire l'ancienne version
        if (null == url) {
            url = elt.getAttribute("nom");
        }
        // Charger la lecture de ce fichier
        PasModule module = (PasModule) inoutTransformation;
        
    }


}

