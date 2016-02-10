package com.jldeleage.mda.run;



import com.jldeleage.mda.modele.LecteurXmi;
import com.jldeleage.mda.run.factories.AbstractFactory;
import com.jldeleage.mda.run.factories.FactoryRegistry;
import com.jldeleage.mda.transfo.ExceptionTransformation;
import com.jldeleage.mda.transfo.Transformation;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;



/**
 * Lit un fichier et ex&eacute;cute chacune des transformations contenues
 * dans le fichier.<br/>
 *
 * @author jldeleage
 */
public class Runner extends PasComplexe {


    public void run(String inNomFichier, Contexte inContexte) throws FileNotFoundException, ParserConfigurationException, SAXException, IOException, TransformerException, TransformerConfigurationException, ExceptionTransformation {
        run(new File(inNomFichier), inContexte);
    }


    public void run(File inFichierConfig, Contexte inContexte) throws FileNotFoundException, ParserConfigurationException, SAXException, IOException, TransformerException, TransformerConfigurationException, ExceptionTransformation {
        run(new FileInputStream(inFichierConfig), inContexte);
    }


    public void run(InputStream inStream, Contexte inContexte) throws ParserConfigurationException, SAXException, IOException, FileNotFoundException, TransformerException, TransformerConfigurationException, ExceptionTransformation {
        // 1- Analyser le flot et extraire la liste des transformations
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document config = builder.parse(inStream);
        Element documentElement = config.getDocumentElement();
        // Effectuer chacune des transformations.
        Map<String, String> parametres = new HashMap<>();
        // TODO : initiailiser les paramètres
        runTransformations(documentElement, parametres);        
    }


    /**
     * 
     * @param inElement : description XML de la transformation : mod&egrave;le,
     * param&egrave;tres locaux, pas.
     * @param inParametres : param&egrave;tres h&eacute;rit&eacute;s transmis
     * pas l'appelant.
     */
    public void runTransformations(Element inElement, Map<String, String> inParametres) throws ParserConfigurationException, SAXException, IOException, FileNotFoundException, TransformerException, TransformerConfigurationException, ExceptionTransformation {
        NodeList listeDesTransformations = inElement.getElementsByTagName("transformation-set");
        for (int i=0 ; i<listeDesTransformations.getLength() ; i++) {
            runATransformation((Element)listeDesTransformations.item(i), inParametres);
        }
    }       // runTransformation


    /**
     * L'&eacute;l&eacute;ment contient un mod&egrave;le
     * 
     * @param inElement
     * @param inParametres 
     */
    public void runATransformation(Element inElement, Map<String, String> inParametres) throws ParserConfigurationException, SAXException, IOException, FileNotFoundException, TransformerException, TransformerConfigurationException, ExceptionTransformation {
        Contexte contexte = new Contexte();
        runATransformation(inElement, contexte);
    }

    public void runATransformation(Element inElement, Contexte inContexte) throws ParserConfigurationException, SAXException, IOException, FileNotFoundException, TransformerException, TransformerConfigurationException, ExceptionTransformation {
        // Une tranformation porte sur un modele, peut contenir des parametres
        // et des pas
        Element eltModele = (Element) inElement.getElementsByTagName("modele").item(0);
        Node contenu = eltModele.getChildNodes().item(0);
        String nomModele = contenu.getNodeValue();
        LecteurXmi lecteurXmi = new LecteurXmi();
        Document lisXmi = lecteurXmi.lisXmi(nomModele);
        Element noeudPas = (Element) inElement.getElementsByTagName("pas").item(0);
        runPas(lisXmi, noeudPas, inContexte);
    }


    /**
     * 
     * @param inDoc
     * @param inElement
     * @param inParametres
     * @return 
     */
    public Document runPas(Document inDoc, Element inElement, Contexte inContexte) throws ExceptionTransformation {
        Document resultat = inDoc;
        NodeList noeuds = inElement.getChildNodes();
        for (int i=0 ; i<noeuds.getLength() ; i++) {
            Node item = noeuds.item(i);
            if (item instanceof Element) {
                executeUnPas(inDoc, (Element)item, inContexte);
            }
        }
        return resultat;
    }


    /**
     * Instancie la transformation indiqu&eacute;e par l'&eacute;l&eacute;ment
     * XML.
     * 
     * @param inDoc
     * @param inElement
     * @param inParemetres
     * @return
     * @throws ExceptionTransformation 
     */
    public Document executeUnPas(Document inDoc, Element inElement, Contexte inContexte) throws ExceptionTransformation {
        Document resultat = inDoc;
        FactoryRegistry registry = FactoryRegistry.getRegistry();
        String nodeName = inElement.getNodeName();
        System.out.print("Pas à exécuter : " + nodeName);
        AbstractFactory factory = registry.get(nodeName);
        if (factory != null) {
            System.out.println(" factory présente");
            Transformation transformation = factory.nouvelleTransformation(inElement, inContexte);
            resultat = transformation.transforme(inDoc);
        }
        else {
            System.out.println(" - PAS DE FACTORY CORRESPONDANTE");
        }
        return resultat;
    }



    @Override
    public String getNomTransfo() {
        return "Runner";
    }


}

