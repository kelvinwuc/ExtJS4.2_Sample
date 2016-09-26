/*
 * System   : CashWeb
 * 
 * Function : 外幣匯款付款規則
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : $Author: MISJIMMY $
 * 
 * Create Date : $Date: 2010/11/18 12:21:14 $
 * 
 * Request ID : R00365 - P00026
 * 
 * CVS History:
 * 
 * $Log: RemittancePayRule.java,v $
 * Revision 1.1  2010/11/18 12:21:14  MISJIMMY
 * R00386 美元保單
 *
 *  
 */


package com.aegon.codeAttr;

public class RemittancePayRule extends SimpleCodeAttr {

    public static final RemittancePayRule PLANV_DIV = new RemittancePayRule( "B01T01F", "投資型-配息" );
    public static final RemittancePayRule PLANV_NODIV = new RemittancePayRule( "B01T01B", "投資型-非配息" );
    public static final RemittancePayRule PLANT = new RemittancePayRule( "B03T01M", "傳統型" );
    
    public static final CodeAttr[] ALL_ATTR = { PLANV_DIV, PLANV_NODIV, PLANT };
    
    public static CodeAttr[] getAllCodeAttr() {
        return ALL_ATTR;
    }
    
    
    public RemittancePayRule(String code, String name, String desc) {
        super( code, name, desc );
    }

    public RemittancePayRule(String code, String name) {
        super( code, name );
    }

    
}
