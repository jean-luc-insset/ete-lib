/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.jldeleage.mda.run;

import com.jldeleage.mda.transfo.ExceptionTransformation;
import java.beans.FeatureDescriptor;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.el.ArrayELResolver;
import javax.el.BeanELResolver;
import javax.el.CompositeELResolver;
import javax.el.ELContext;
import javax.el.ELResolver;
import javax.el.ExpressionFactory;
import javax.el.FunctionMapper;
import javax.el.ListELResolver;
import javax.el.MapELResolver;
import javax.el.ValueExpression;
import javax.el.VariableMapper;
import org.w3c.dom.Document;

/**
 *
 * @author jldeleage
 */
public class PasConditionnel extends PasComplexe {

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    @Override
    public String getNomTransfo() {
        return "si " + condition;
    }

    @Override
    public Document transforme(Document doc) throws ExceptionTransformation {
        if (evalueCondition()) {
            return super.transforme(doc);
        }
        else {
            return doc;
        }
    }

    protected boolean evalueCondition() {
        Map<String, String> parametres = this.getParametres();
        ExpressionFactory factory = ExpressionFactory.newInstance();
        final CompositeELResolver compositeELResolver = new CompositeELResolver();
        compositeELResolver.add(new ArrayELResolver());
        compositeELResolver.add(new ListELResolver());
        compositeELResolver.add(new BeanELResolver());
        compositeELResolver.add(new MapELResolver());
        final ELResolver      monELResolver = new EteELResolver();
        final FunctionMapper  monFunctionMapper = new EteFunctionMapper();
        final VariableMapper  monVariableMapper = new EteVariableMapper();
        ELContext contexte = new ELContext() {

            @Override
            public ELResolver getELResolver() {
                return monELResolver;
            }

            // TODO : ajouter eventuellement des fonctions helpers...
            @Override
            public FunctionMapper getFunctionMapper() {
                throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
            }

            @Override
            public VariableMapper getVariableMapper() {
                return monVariableMapper;
            }

        };      // EteELContext
        ValueExpression expression = factory.createValueExpression(contexte, condition, Boolean.class);
        Boolean resultat = (Boolean) expression.getValue(contexte);
        return resultat;
    }



    private class EteELResolver extends ELResolver {

        @Override
        public Object getValue(ELContext elc, Object base, Object property) {
            if (base == null) {
                return getParametres().get(property);
            }
            else {
                return delegue.getValue(elc, base, property);
            }
        }

        @Override
        public Class<?> getType(ELContext elc, Object o, Object o1) {
            throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        }

        /**
         * Ne devrait jamais &ecirc;tre invoqu&eacute;e.
         */
        @Override
        public void setValue(ELContext elc, Object o, Object o1, Object o2) {
            throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        }

        @Override
        public boolean isReadOnly(ELContext elc, Object o, Object o1) {
            return true;
        }

        @Override
        public Iterator<FeatureDescriptor> getFeatureDescriptors(ELContext elc, Object o) {
            throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        }

        @Override
        public Class<?> getCommonPropertyType(ELContext elc, Object o) {
            throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        }

        ELResolver delegue = new MapELResolver();
    }       // EteResolver


    private class EteFunctionMapper extends FunctionMapper {

        @Override
        public Method resolveFunction(String prefix, String localName) {
            return null;
        }
        
    }       // FunctionResolver

    private class EteVariableMapper extends VariableMapper {

        @Override
        public ValueExpression resolveVariable(String string) {
            return expressions.get(string);
        }

        @Override
        public ValueExpression setVariable(String string, ValueExpression ve) {
            ValueExpression ancienne = expressions.get(string);
            expressions.put(string, ve);
            return ancienne;
        }

        private Map<String, ValueExpression> expressions = new HashMap<>();

    }

    private String      condition;

}       // PasConditionnel
