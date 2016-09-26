package com.aegon.disb.util;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.3 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckControlInfoVO.java,v $
 * $Revision 1.3  2011/07/14 11:34:05  MISSALLY
 * $Q10183
 * $票據開立時若遇到要換票據批號時需人工勾選, 修正為系統自動作業
 * $
 * $Revision 1.2  2009/12/03 10:31:53  missteven
 * $R90628 票據庫存新增
 * $
 * $Revision 1.1  2006/06/29 09:40:13  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.2  2005/04/04 07:02:26  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

import java.util.Set;

public class DISBCheckControlInfoVO implements java.io.Serializable {

	/*銀行行庫 CBKNO*/
	private String strCBKNo;

	/*銀行帳號 CACCOUNT */
	private String strCAccount;

	/* 票據批號 CBNO*/
	private String strCBNo;
	
	/*票據起碼 CSNO*/
	private String strCSNo;
	
	/*票據迄碼 CENO*/
	private String strCENo;

	/*輸入日期 EntryDate*/
	private int iEntryDt = 0;

	/*輸入時間 EntruTime*/
	private int iEntryTm = 0;

	/*輸入人員 EntruUsr*/
	private String strEntryUsr;

	/*輸入程式 EntruPgm*/
	private String strEntryPgm;
	
	/*該支票本是否被用過*/
	private boolean isUsed = false;
	
	/*可用的空白支票張數*/
	private int iEmptyCheck = 0;
	
	private String strApprovStat ;
	
	private String strApprovUser ;
	
	private String strMemo ;

	/* 尚未被使用的支票號碼 */
	private Set emptyCheckNo = null;

	/**
	 * @return
	 */
	public int getIEntryDt() {
		return iEntryDt;
	}

	/**
	 * @return
	 */
	public int getIEntryTm() {
		return iEntryTm;
	}

	/**
	 * @return
	 */
	public boolean isUsed() {
		return isUsed;
	}

	/**
	 * @return
	 */
	public String getStrCAccount() {
		return strCAccount;
	}

	/**
	 * @return
	 */
	public String getStrCBKNo() {
		return strCBKNo;
	}

	/**
	 * @return
	 */
	public String getStrCBNo() {
		return strCBNo;
	}

	/**
	 * @return
	 */
	public String getStrCENo() {
		return strCENo;
	}

	/**
	 * @return
	 */
	public String getStrCSNo() {
		return strCSNo;
	}

	/**
	 * @return
	 */
	public String getStrEntryPgm() {
		return strEntryPgm;
	}

	/**
	 * @return
	 */
	public String getStrEntryUsr() {
		return strEntryUsr;
	}

	/**
	 * @param i
	 */
	public void setIEntryDt(int i) {
		iEntryDt = i;
	}

	/**
	 * @param i
	 */
	public void setIEntryTm(int i) {
		iEntryTm = i;
	}

	/**
	 * @param b
	 */
	public void setUsed(boolean b) {
		isUsed = b;
	}

	/**
	 * @param string
	 */
	public void setStrCAccount(String string) {
		strCAccount = string;
	}

	/**
	 * @param string
	 */
	public void setStrCBKNo(String string) {
		strCBKNo = string;
	}

	/**
	 * @param string
	 */
	public void setStrCBNo(String string) {
		strCBNo = string;
	}

	/**
	 * @param string
	 */
	public void setStrCENo(String string) {
		strCENo = string;
	}

	/**
	 * @param string
	 */
	public void setStrCSNo(String string) {
		strCSNo = string;
	}

	/**
	 * @param string
	 */
	public void setStrEntryPgm(String string) {
		strEntryPgm = string;
	}

	/**
	 * @param string
	 */
	public void setStrEntryUsr(String string) {
		strEntryUsr = string;
	}

	/**
	 * @return
	 */
	public int getIEmptyCheck() {
		return iEmptyCheck;
	}

	/**
	 * @param i
	 */
	public void setIEmptyCheck(int i) {
		iEmptyCheck = i;
	}

	/**
	 * @return
	 */
	public String getStrApprovStat() {
		return strApprovStat;
	}

	/**
	 * @return
	 */
	public String getStrApprovUser() {
		return strApprovUser;
	}

	/**
	 * @param string
	 */
	public void setStrApprovStat(String string) {
		strApprovStat = string;
	}

	/**
	 * @param string
	 */
	public void setStrApprovUser(String string) {
		strApprovUser = string;
	}

	/**
	 * @return
	 */
	public String getStrMemo() {
		return strMemo;
	}

	/**
	 * @param string
	 */
	public void setStrMemo(String string) {
		strMemo = string;
	}

	/**
	 * @return 尚未被使用的支票號碼
	 */
	public Set getEmptyCheckNo() {
		return emptyCheckNo;
	}

	/**
	 * @param set
	 */
	public void setEmptyCheckNo(Set set) {
		emptyCheckNo = set;
	}

}