/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.transfo;

/**
 *
 * @author jldeleage
 */
public class ExceptionTransformation extends Exception {

    public ExceptionTransformation(Throwable cause) {
        super(cause);
    }

    public ExceptionTransformation(String message, Throwable cause) {
        super(message, cause);
    }


}
