package com.aegon.crooutone;

/**
 * System : CashWeb
 * 
 * Function : 單筆銷帳
 * 
 * Remark :
 * 
 * Revision : $$Revision: 1.4 $$
 * 
 * Author : MISSALLY
 * 
 * Create Date : $$Date: 2014/01/28 06:37:34 $$
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * $$Log: CroOutOneConditionDTO.java,v $
 * $Revision 1.4  2014/01/28 06:37:34  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.3  2014/01/14 01:49:43  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $非保費帳處理
 * $
 * $Revision 1.2  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $$
 * 
 */

public class CroOutOneConditionDTO {

	public static final String NORMAL = "0";
	public static final String SPECIAL_I = "1";
	public static final String NONE_PREM_CASE = "2";
	
	private String strBkCode = "";
	private String strAccount = "";
	private String currency = "";
	private int iRmtDate = 0;
	private double iRmtAmt = 0;
	private int iAegDate = 0;

	private String strType = "";
	
	public String getBkCode() {
		return strBkCode;
	}

	public void setBkCode(String strBkCode) {
		this.strBkCode = strBkCode;
	}

	public String getAccount() {
		return strAccount;
	}

	public void setAccount(String strAccount) {
		this.strAccount = strAccount;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

	public int getRmtDate() {
		return iRmtDate;
	}

	public void setRmtDate(int iRmtDate) {
		this.iRmtDate = iRmtDate;
	}

	public double getRmtAmt() {
		return iRmtAmt;
	}

	public void setRmtAmt(double d) {
		this.iRmtAmt = d;
	}

	public int getAegDate() {
		return iAegDate;
	}

	public void setAegDate(int iAegDate) {
		this.iAegDate = iAegDate;
	}

	public String getType() {
		return strType;
	}

	public void setType(String string) {
		this.strType = string;
	}

}
