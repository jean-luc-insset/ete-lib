/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run;

import com.jldeleage.mda.transfo.ExceptionTransformation;
import com.jldeleage.mda.transfo.TransformationAbstraite;
import org.w3c.dom.Document;

/**
 * Une "transformation" de ce type est idempotente sur le mod&egrave;le et
 * copie une ou des ressources.
 *
 * @author jldeleage
 */
public abstract class IdemPotente extends TransformationAbstraite {

    @Override
    public final Document transforme(Document doc) throws ExceptionTransformation {
        run(doc);
        return doc;
    }

    public abstract void run(Document doc) throws ExceptionTransformation;

}

