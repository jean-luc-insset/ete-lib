/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run.factories;

import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author jldeleage
 */
public class FactoryRegistry {

    private FactoryRegistry() {
        
    }

    public void register(String inNom, AbstractFactory inFactory) {
        factories.put(inNom, inFactory);
    }


    public AbstractFactory get(String inNom) {
        return factories.get(inNom);
    }


    public static FactoryRegistry getRegistry() {
        return registry;
    }


    private Map<String, AbstractFactory>    factories = new HashMap<>();

    private static FactoryRegistry registry = new FactoryRegistry();


}       // FactoryRegistry

