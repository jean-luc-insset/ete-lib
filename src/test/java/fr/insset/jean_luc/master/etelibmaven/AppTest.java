package fr.insset.jean_luc.master.etelibmaven;


import com.jldeleage.mda.transfo.ApplicateurTemplate;
import com.jldeleage.mda.transfo.EnrichissementXml;
import com.jldeleage.mda.transfo.ExceptionTransformation;
import com.jldeleage.mda.modele.LecteurXmi;
import com.jldeleage.mda.util.Dump;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.junit.Test;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

/**
 * Unit test for simple App.
 */
public class AppTest {


    public final static String DOSSIER_TARGET             = "target/test/java";
    public final static String DOSSIER_CIBLE              = "target/test-classes/generated-sources/mda/";

    public final static String NOM_FICHIER_MODELE         = "src/test/resources/xmlunit/OrigamiAirLines.xml";
//    public final static String NOM_FICHIER_MODELE         = "src/test/java/MMORPG.xml";
    public final static String NOM_MODELE_LU             = "target/test/java/modele.xml";
//    public final static String NOM_FICHIER_MODELE = "src/test/java/modele.xml"; 
    public final static String NOM_FICHIER_TEMPLATE       = "src/test/java/toutesclasses2java.xml";

    public final static String NOM_FICHIER_A_MODIFIER     = "src/test/java/web.xml";
    public final static String NOM_FICHIER_MODIFIE        = "target/test/java/transfo.xml";
    public final static String NOM_FEUILLE_ENRICHISSEMENT = "src/test/java/amelioreModele.xml";


    /**
     * Lit un mod&egrave;le et applique un template.<br/>
     * Cela produit des sources Java (bugg&eacute;s si le mod&egrave;le
     * n'est pas consistent).
     * 
     * @throws com.jldeleage.mda.transfo.ExceptionTransformation
     */
    @Test
    public void testApp() throws ExceptionTransformation,
                                 ParserConfigurationException, SAXException,
                                 IOException, FileNotFoundException,
                                 TransformerException {
        // A Préparation des tests : lecture du document
        System.out.println("PWD : " + new File(".").getAbsolutePath());
        LecteurXmi lecteurXmi = new LecteurXmi();
        File fichierModele = new File(NOM_FICHIER_MODELE);
        System.out.println(fichierModele.getAbsolutePath());
        Document doc = lecteurXmi.lisXmi(fichierModele);
        File target = new File(DOSSIER_TARGET);
        target.mkdirs();
        Dump dump = new Dump();
        dump.dump(doc, NOM_MODELE_LU);

//        // B Test de l'application de template
//        ApplicateurTemplate applicateurTemplate = new ApplicateurTemplate();
//        applicateurTemplate.setParameter("template", NOM_FICHIER_TEMPLATE);
//        applicateurTemplate.setParameter("dossier_cible", DOSSIER_CIBLE);
//        applicateurTemplate.transforme(doc);
//        TransformerFactory factory = TransformerFactory.newInstance();
//        Transformer dump = factory.newTransformer(new StreamSource("src/main/resources/rsrc/xslt/identite.xsl"));
//        dump.transform(new DOMSource(doc), new StreamResult(System.out));

        // C Test de la modification d'un fichier
        // 1- préparation : copie d'un fichier
        //    ici on copie le fichier web.xml en transfo.xml
        byte[]  buffer = new byte[4096];
        InputStream input = new FileInputStream(NOM_FICHIER_A_MODIFIER);
        File fichierTransformie = new File(NOM_FICHIER_MODIFIE);
        OutputStream output = new FileOutputStream(fichierTransformie);
        int nbLus = 0;
        while ((nbLus = input.read(buffer))>0) {
            output.write(buffer, 0, nbLus);
        }
        output.flush();
        output.close();
        // 2- Enrichissement
        EnrichissementXml enrichissementXml = new EnrichissementXml();
        enrichissementXml.setParameter("template", NOM_FEUILLE_ENRICHISSEMENT);
        enrichissementXml.setParameter("file", NOM_FICHIER_MODIFIE);
        enrichissementXml.setParameter("nomModele", NOM_MODELE_LU);
        enrichissementXml.transforme(doc);
        // 3- Remplacement du fichier
        Dump dumper = new Dump();
        dumper.dump(new File(NOM_FICHIER_A_MODIFIER), System.out);
    }                                                                                                                                                                                                                                                                                                                                                                                                                                               
}
