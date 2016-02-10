package com.jldeleage.mda.run;


import com.jldeleage.mda.run.factories.AbstractFactory;
import com.jldeleage.mda.run.factories.ConditionFactory;
import com.jldeleage.mda.run.factories.DumpFactory;
import com.jldeleage.mda.run.factories.FactoryRegistry;
import com.jldeleage.mda.run.factories.ModuleFactory;
import com.jldeleage.mda.run.factories.TemplateFactory;
import java.util.HashMap;
import java.util.Map;



/**
 * Les contextes sont "empil&eacute;s". Chaque contexte contient des
 * param&egrave;tres.
 *
 * @author jldeleage
 */
public class Contexte {


    /**
     * Ce constructeur n'est appel&eacute; que pour le premier contexte.<br/>
     * Il enregistre les factories standard.<br/>
     * TODO : faut-il rendre ce constructeur priv&eacute; pour garantir
     * que le contexte initial est unique&nbsp;?
     */
    public Contexte() {
        FactoryRegistry registry = FactoryRegistry.getRegistry();
        registry.register("module", new ModuleFactory());
        registry.register("if", new ConditionFactory());
        registry.register("template", new TemplateFactory());
        registry.register("dump", new DumpFactory());
    }


    /**
     * Ce constructeur 
     */
    public Contexte(Contexte inParent) {
        this(new HashMap<String, String>(), inParent);
    }


    public Contexte(Map<String, String> parametres, Contexte parent) {
        this(parametres);
        this.parent = parent;
    }


    public Contexte(Map<String, String> parametres) {
        this.parametresLocaux = parametres;
    }


    public Map<String, String> getParametresLocaux() {
        return parametresLocaux;
    }


    public void setParametresLocaux(Map<String, String> parametres) {
        this.parametresLocaux = parametres;
    }


    /**
     * Construit une Map de tous les param&egrave;tres, y compris ceux
     * h&eacute;rit&eacute;s du parent &eacute;ventuel.
     * 
     * @return 
     */
    public Map<String, String> getParametres() {
        Map<String, String> resultat = new HashMap<>();
        if (parent != null) {
            resultat = parent.getParametres();
        }
        else {
            resultat = new HashMap<>();
        }
        for (String clef : parametresLocaux.keySet()) {
            resultat.put(clef, parametresLocaux.get(clef));
        }
        return resultat;
    }


    public String getParametre(String inNom) {
        String resultat = parametresLocaux.get(inNom);
        if (resultat == null && parent != null) {
            return parent.getParametre(inNom);
        }
        return resultat;
    }


    private Map<String, String> parametresLocaux;
    private Contexte            parent;


}
