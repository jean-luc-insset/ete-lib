/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run;

import com.jldeleage.mda.transfo.ExceptionTransformation;
import java.io.File;
import java.util.LinkedList;
import java.util.List;
import org.w3c.dom.Document;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Target;
import org.apache.tools.ant.taskdefs.Copy;
import java.io.File;
/**
 * Une "transformation" de ce type est idempotente sur le mod&egrave;le et
 * copie une ou des ressources.<br/>
 * TODO : pour le moment, l'action est impl&eacute;ment&eacute;e directement.
 * Il pourrait &ecirc;tre int&eacute;ressant de reprendre la t&acirc;che
 * ant.
 *
 * @author jldeleage
 */
public class Copie extends IdemPotente {


    @Override
    public void run(Document doc) throws ExceptionTransformation {
        copy.execute();
    }


    //========================================================================//


    @Override
    public String getNomTransfo() {
        return "Copie";
    }


    //========================================================================//
    // M E T H O D E S   D E L E G U E E S                                    //
    //========================================================================//
    // Ces méthodes sont invoquées par la factory qui lit le document de      //
    // configuration                                                          //
    //========================================================================//


    public void setFile(File file) {
        copy.setFile(file);
    }

    public void setTofile(File destFile) {
        copy.setTofile(destFile);
    }

    public void setTodir(File destDir) {
        copy.setTodir(destDir);
    }

    public void setPreserveLastModified(boolean preserve) {
        copy.setPreserveLastModified(preserve);
    }

    public void setFiltering(boolean filtering) {
        copy.setFiltering(filtering);
    }

    public void setOverwrite(boolean overwrite) {
        copy.setOverwrite(overwrite);
    }

    public void setForce(boolean f) {
        copy.setForce(f);
    }

    public void setFlatten(boolean flatten) {
        copy.setFlatten(flatten);
    }

    public void setVerbose(boolean verbose) {
        copy.setVerbose(verbose);
    }

    public void setIncludeEmptyDirs(boolean includeEmpty) {
        copy.setIncludeEmptyDirs(includeEmpty);
    }

    public void setQuiet(boolean quiet) {
        copy.setQuiet(quiet);
    }

    public void setEnableMultipleMappings(boolean enableMultipleMappings) {
        copy.setEnableMultipleMappings(enableMultipleMappings);
    }

    public void setFailOnError(boolean failonerror) {
        copy.setFailOnError(failonerror);
    }

    public void setEncoding(String encoding) {
        copy.setEncoding(encoding);
    }

    public void setOutputEncoding(String encoding) {
        copy.setOutputEncoding(encoding);
    }

    public void setGranularity(long granularity) {
        copy.setGranularity(granularity);
    }


    //========================================================================//

    Copy        copy = new Copy();

}

