package com.aegon.disb.disbmaintain;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.4 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBAccCodeDetailVO.java,v $
 * $Revision 1.4  2014/01/02 08:25:46  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.3  2012/05/18 09:47:36  MISSALLY
 * $R10314 CASH系統會計作業修改
 * $
 * $Revision 1.2  2008/09/17 01:50:06  MISODIN
 * $R80338 讀取匯率for出納匯款分錄
 * $
 * $Revision 1.1  2006/06/29 09:40:15  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.2  2005/04/04 07:02:27  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBAccCodeDetailVO implements java.io.Serializable {

	/* LEDGER */
	private String strLedger = "";

	/*Category*/
	private String strCategory = "";

	/*Source*/
	private String strSource = "";

	/*Currency*/
	private String strCurr = "";
	
	/*ACTCD1*/
	private String strActCd1 = "";
	
	/*ACTCD2*/
	private String strActCd2 = "";
	
	/*strActCd3*/
	private String strActCd3 = "";
	
	/*strActCd4*/
	private String strActCd4 = "";
	
	/*strActCd5*/
	private String strActCd5 = "";
	
	/*Date1*/
	private String strDate1 = "";
	
	/*Credit-Amount*/
	private String strCAmt = "";
	
	/*Debit-Amount*/
	private String strDAmt = "";
	
	/*SlipNo*/
	private String strSlipNo = "";
	
	/*Description*/
	private String strDesc = "";
	
	/*CheckDate*/
	private String strCheckDate = "";
	
	/*Conversion Rate R80338 */
	private String strConverRate = "";
	
	//R10314
	private String conversionDebit = "0";
	
	private String conversionCredit = "0";
	
	private String sort = "";
	
	private String payCompany = "";

	public String getPayCompany() {
		return payCompany;
	}

	public void setPayCompany(String payCompany) {
		this.payCompany = payCompany;
	}

	public String getStrActCd1() {
		return strActCd1;
	}

	public String getStrActCd2() {
		return strActCd2;
	}

	public String getStrActCd3() {
		return strActCd3;
	}

	public String getStrActCd4() {
		return strActCd4;
	}

	public String getStrActCd5() {
		return strActCd5;
	}

	public String getStrCAmt() {
		return strCAmt;
	}

	public String getStrCategory() {
		return strCategory;
	}

	public String getStrCheckDate() {
		return strCheckDate;
	}

	public String getStrCurr() {
		return strCurr;
	}

	public String getStrDAmt() {
		return strDAmt;
	}

	public String getStrDate1() {
		return strDate1;
	}

	public String getStrDesc() {
		return strDesc;
	}

	public String getStrSlipNo() {
		return strSlipNo;
	}

	public String getStrSource() {
		return strSource;
	}

	public String getStrConverRate() {
		return strConverRate;
	}

	public void setStrActCd1(String string) {
		strActCd1 = string;
	}

	public void setStrActCd2(String string) {
		strActCd2 = string;
	}

	public void setStrActCd3(String string) {
		strActCd3 = string;
	}

	public void setStrActCd4(String string) {
		strActCd4 = string;
	}

	public void setStrActCd5(String string) {
		strActCd5 = string;
	}

	public void setStrCAmt(String string) {
		strCAmt = string;
	}

	public void setStrCategory(String string) {
		strCategory = string;
	}

	public void setStrCheckDate(String string) {
		strCheckDate = string;
	}

	public void setStrCurr(String string) {
		strCurr = string;
	}

	public void setStrDAmt(String string) {
		strDAmt = string;
	}

	public void setStrDate1(String string) {
		strDate1 = string;
	}

	public void setStrDesc(String string) {
		strDesc = string;
	}

	public void setStrSlipNo(String string) {
		strSlipNo = string;
	}

	public void setStrSource(String string) {
		strSource = string;
	}
	
	public void setStrConverRate(String string) {
		strConverRate = string;
	}

	public String getConversionCredit() {
		return conversionCredit;
	}

	public String getConversionDebit() {
		return conversionDebit;
	}

	public void setConversionCredit(String string) {
		conversionCredit = string;
	}

	public void setConversionDebit(String string) {
		conversionDebit = string;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String string) {
		sort = string;
	}

	public String getLedger() {
		return strLedger;
	}

	public void setLedger(String string) {
		this.strLedger = string;
	}

}