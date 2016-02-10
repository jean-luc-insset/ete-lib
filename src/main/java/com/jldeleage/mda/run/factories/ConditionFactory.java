/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run.factories;

import com.jldeleage.mda.run.Contexte;
import com.jldeleage.mda.run.PasConditionnel;
import com.jldeleage.mda.transfo.Transformation;
import org.w3c.dom.Element;

/**
 *
 * @author jldeleage
 */
public class ConditionFactory extends AbstractFactory {

    @Override
    public Transformation creeTransformation() {
        return new PasConditionnel();
    }

    @Override
    public void lisSpecificites(Transformation inoutTransformation, Element elt, Contexte inContextes) {
        String condition = elt.getAttribute("test");
        PasConditionnel pas = (PasConditionnel) inoutTransformation;
        pas.setCondition(condition);
    }
    
}   // ConditionFactory
