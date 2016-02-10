/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run.factories;

import com.jldeleage.mda.run.Contexte;
import com.jldeleage.mda.transfo.ExceptionTransformation;
import com.jldeleage.mda.transfo.Transformation;
import com.jldeleage.mda.util.Dump;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.w3c.dom.Element;

/**
 *
 * @author jldeleage
 */
public class DumpFactory extends AbstractFactory {

    @Override
    protected Transformation creeTransformation() {
        try {
            return new Dump();
        } catch (ExceptionTransformation ex) {
            throw new RuntimeException("Exception imprévue", ex);
        }
    }

    @Override
    public void lisSpecificites(Transformation inoutTransformation, Element elt, Contexte inContextes) throws ExceptionTransformation {
        String file = elt.getAttribute("fichier");
        Dump dump = (Dump) inoutTransformation;
        if (null != file && file.length() > 0) {
            dump.setParameter("fichier", file);
        }
    }

}
