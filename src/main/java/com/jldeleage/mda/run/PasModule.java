/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run;

/**
 *
 * @author jldeleage
 */
public class PasModule extends PasComplexe {

    public void setNomTransfo(String nomTransfo) {
        this.nomTransfo = nomTransfo;
    }

    @Override
    public String getNomTransfo() {
        return nomTransfo;
    }

    private String nomTransfo;
}
