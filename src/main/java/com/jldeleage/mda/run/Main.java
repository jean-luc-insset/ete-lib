/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run;

import com.jldeleage.mda.transfo.ExceptionTransformation;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import org.xml.sax.SAXException;

/**
 *
 * @author jldeleage
 */
public class Main {
    

    public static void main(String[] a) throws ParserConfigurationException, SAXException, IOException, FileNotFoundException, TransformerException, TransformerConfigurationException, ExceptionTransformation {
        String nomFichier = null;
        Map<String, String> parametres = new HashMap<>();
        Contexte ctx = new Contexte(parametres);
        for (int i=0 ; i<a.length ; i++) {
            
        }
        if (nomFichier == null) {
            nomFichier = "config-ete.xml";
        }
        Runner runner = new Runner();
        runner.run(nomFichier, ctx);
    }       // main


}
