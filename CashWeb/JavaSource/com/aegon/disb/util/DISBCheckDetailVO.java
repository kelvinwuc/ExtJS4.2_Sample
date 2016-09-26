/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckDetailVO.java,v $
 * $Revision 1.2  2014/07/18 07:18:36  misariel
 * $EC0342-RC0036新增分公司行政人員使用CAPSIL
 * $
 * $Revision 1.1  2006/06/29 09:40:13  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:26  miselsa
 * $R30530 支付系統
 * $$
 *  
 */
package com.aegon.disb.util;


public class DISBCheckDetailVO implements java.io.Serializable {

	/*銀行行庫 CBKNO*/
	private String strCBKNo;

	/*銀行帳號 CACCOUNT */
	private String strCAccount;

	/* 票據批號 CBNO*/
	private String strCBNo;
	
	/*票據號碼 CNO*/
	private String strCNo;

	/*票據抬頭 CNM*/
	private String strCNm;

	/*票面金額 CAMT*/
	private double  iCAmt=0;

	/*到期日 CHEQUEDT*/
	private int iChequeDt = 0;

	/*兌現日 CASHDT*/
	private int iCashDt = 0;

	/*回銷日期 CRTNDT*/
	private int iCrtnDt = 0;

	/*開立日期 CUSEDT*/
	private int iCUseDt = 0;

	/*退回日期CBCKDT*/
	private int iCBckDt = 0;

	/*支票狀態 CSTATUS*/
	private String strCStatus;

	/*支付序號 PNO*/
	private String strPNO;

	/*傳票號碼 CNUMBER*/
	private String strCNumber;

	/*問題票據 CERFLAG*/
	private String strCerFlag;

	/*人工開票用否 CHNDFLG*/
	private String strChndFlg;

	/*輸入日期 EntryDate*/
	private int iEntryDt = 0;

	/*輸入時間 EntruTime*/
	private int iEntryTm = 0;

	/*輸入人員 EntruUsr*/
	private String strEntryUsr;

	/*輸入程式 EntruPgm*/
	private String strEntryPgm;
	
	/*RC0036*/
	private String strUsrDept;
	
	/*RC0036*/
	private String strPMethod;

	/*RC0036*/
	private String strUsrArea;
	/**
	 * @return
	 */
	public int getICashDt() {
		return iCashDt;
	}

	/**
	 * @return
	 */
	public int getICBckDt() {
		return iCBckDt;
	}

	/**
	 * @return
	 */
	public int getIChequeDt() {
		return iChequeDt;
	}

	/**
	 * @return
	 */
	public int getICrtnDt() {
		return iCrtnDt;
	}

	/**
	 * @return
	 */
	public int getICUseDt() {
		return iCUseDt;
	}

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
	public String getStrCerFlag() {
		return strCerFlag;
	}

	/**
	 * @return
	 */
	public String getStrChndFlg() {
		return strChndFlg;
	}

	/**
	 * @return
	 */
	public String getStrCNo() {
		return strCNo;
	}

	/**
	 * @return
	 */
	public String getStrCNumber() {
		return strCNumber;
	}

	/**
	 * @return
	 */
	public String getStrCStatus() {
		return strCStatus;
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
	 * @return
	 */
	public String getStrPNO() {
		return strPNO;
	}

	/**
	 * @param i
	 */
	public void setICashDt(int i) {
		iCashDt = i;
	}

	/**
	 * @param i
	 */
	public void setICBckDt(int i) {
		iCBckDt = i;
	}

	/**
	 * @param i
	 */
	public void setIChequeDt(int i) {
		iChequeDt = i;
	}

	/**
	 * @param i
	 */
	public void setICrtnDt(int i) {
		iCrtnDt = i;
	}

	/**
	 * @param i
	 */
	public void setICUseDt(int i) {
		iCUseDt = i;
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
	public void setStrCerFlag(String string) {
		strCerFlag = string;
	}

	/**
	 * @param string
	 */
	public void setStrChndFlg(String string) {
		strChndFlg = string;
	}

	/**
	 * @param string
	 */
	public void setStrCNo(String string) {
		strCNo = string;
	}

	/**
	 * @param string
	 */
	public void setStrCNumber(String string) {
		strCNumber = string;
	}

	/**
	 * @param string
	 */
	public void setStrCStatus(String string) {
		strCStatus = string;
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
	 * @param string
	 */
	public void setStrPNO(String string) {
		strPNO = string;
	}

	/**
	 * @return
	 */
	public String getStrCNm() {
		return strCNm;
	}

	/**
	 * @param string
	 */
	public void setStrCNm(String string) {
		strCNm = string;
	}

	/**
	 * @return
	 */
	public double getICAmt() {
		return iCAmt;
	}

	/**
	 * @param i
	 */
	public void setICAmt(double i) {
		iCAmt = i;
	}
	//RC0036
	public String getStrUsrDept() {
		return strUsrDept;
	}
	public void setStrUsrDept(String string) {
		strUsrDept = string;
	}
	//RC0036
	public String getStrUsrArea() {
		return strUsrArea;
	}
	public void setStrUsrArea(String string) {
		strUsrArea = string;
	}
	public String getStrPMethod() {
		return strPMethod;
	}
	public void setStrPMethod(String string) {
		strPMethod = string;
	}
}