/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : $Author: MISJIMMY $
 * 
 * Create Date : $Date: 2010/11/18 12:21:14 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: SimpleCodeAttr.java,v $
 * Revision 1.1  2010/11/18 12:21:14  MISJIMMY
 * R00386 美元保單
 *
 *  
 */

package com.aegon.codeAttr;

public class SimpleCodeAttr implements CodeAttr {

    private String code;
    private String name;
    private String desc;
    
    public SimpleCodeAttr(String code, String name) {
        this( code, name, null );
    }
    
    public SimpleCodeAttr(String code, String name, String desc) {
        this.code = code;
        this.name = name;
        this.desc = desc;
    }
    
    public String getCode() {
        return code;
    }
    public void setCode(String code) {
        this.code = code;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getDesc() {
        if( desc == null )
            return "";
        return desc;
    }
    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String toString() {
        
        StringBuffer s = new StringBuffer();
        s.append( getClass().getName() );
        s.append( '{' );
        s.append( "code=" ).append( code );
        s.append( ",name=" ).append( name );
        s.append( ",desc=" ).append( desc );
        s.append( '}' );
        return s.toString();
    }
}
