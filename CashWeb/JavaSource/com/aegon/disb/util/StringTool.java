package com.aegon.disb.util;
import java.util.*;

/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.1 $$
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: StringTool.java,v $
 * $Revision 1.1  2006/06/29 09:40:13  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.2  2005/04/04 07:02:26  miselsa
 * $R30530 ¤ä¥I¨t²Î
 * $$
 *  
 */
public class StringTool{

	/**
	 * 093/09/05 ---> 0930905
	 * @param str
	 * @param substr
	 * @return newStr
	 */
	public static String removeChar(String str , char c){
		while(str.indexOf(String.valueOf(c))>0){
			int k = str.indexOf(String.valueOf(c));
			str = str.substring(0,k)+str.substring(k+1, str.length());
		}
		return str;
	}
	
}