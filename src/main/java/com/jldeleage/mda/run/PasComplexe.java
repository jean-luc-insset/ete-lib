package com.jldeleage.mda.run;


import com.jldeleage.mda.transfo.ExceptionTransformation;
import com.jldeleage.mda.transfo.Transformation;
import com.jldeleage.mda.transfo.TransformationAbstraite;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * Il y a trois sortes de pas complexes : les transformations globales, les
 * modules et les blocs conditionnels.
 * <ul>
 * <li>Une transformation globale contient un mod&egrave;le, des
 * param&egrave;tres locaux et des pas
 * <li>Un module lit sa d&eacute;finition dans un fichier externe. Il peut
 * contenir des param&egrave;tres locaux dans l'appel comme dans la
 * d&eacute;finition.</li>
 * <li>Un bloc conditionnel contient des param&egrave;tres locaux et des pas
 * </ul>
 *
 * @author jldeleage
 */
public abstract class PasComplexe extends TransformationAbstraite implements Transformation {



    public Document executeLesPas(Document inoutDocument, Element inElement) {
        Document resultat = inoutDocument;
        NodeList enfants = inElement.getChildNodes();
        for (int i=0 ; i<enfants.getLength() ; i++) {
            Node suivant = enfants.item(i);
            if (suivant instanceof Element) {
                
            }
        }
        return resultat;
    }

    @Override
    public Document transforme(Document doc) throws ExceptionTransformation {
        Document resultat = doc;
        Map<String, String> parametres = this.getParametres();
        for (Transformation t : transformations) {
            t.setParametres(parametres);
            resultat = t.transforme(doc);
        }
        return resultat;
    }


    private List<Transformation>    transformations = new LinkedList<>();


}
