/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run.factories;

import com.jldeleage.mda.run.Contexte;
import com.jldeleage.mda.run.Copie;
import com.jldeleage.mda.transfo.ExceptionTransformation;
import com.jldeleage.mda.transfo.Transformation;
import java.io.File;
import org.w3c.dom.Element;

/**
 *
 * @author jldeleage
 */
public class CopieFactory extends AbstractFactory {


    @Override
    public Transformation creeTransformation() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }


    /**
     * Lit les fichiers &agrave; copier et les inst&egrave;re dans le pas.
     */
    @Override
    public void lisSpecificites(Transformation inoutTransformation, Element elt, Contexte inContextes) throws ExceptionTransformation {
        Copie copie = (Copie) inoutTransformation;
        String file = elt.getAttribute("file");
        if (file != null) {
            copie.setFile(new File(file));
        }
        String toDir = elt.getAttribute("todir");
        if (toDir != null) {
            copie.setTodir(new File(toDir));
        }
        String toFile = elt.getAttribute("tofile");
        if (toFile != null) {
            copie.setTofile(new File(toFile));
        }

    }

    

}
