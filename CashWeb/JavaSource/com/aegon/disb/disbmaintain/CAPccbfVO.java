package com.aegon.disb.disbmaintain;

/**
 * System   : CashWeb
 * 
 * Function : 國內金資碼Value Object
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 
 * 
 * Request ID : R50329
 * 
 * CVS History:
 * 
 * $$Log: CAPccbfVO.java,v $
 * $Revision 1.2  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $$
 *  
 */

public class CAPccbfVO {
	
	/*銀行行庫 BKNO*/
	private String BKNO = "";

	/*銀行簡稱 BKNM */
	private String BKNM = "";

	/*銀行全名 BKFNM */
	private String BKFNM = "";

	/*輸入日期 ENTRYDATE*/
	private int ENTRYDT = 0;

	/*輸入時間 ENTRYTIME*/
	private int ENTRYTM = 0;

	/*輸入人員 ENTRYUSR*/
	private String ENTRYUSR= "";

	public String getBKNO() {
		return BKNO;
	}

	public String getBKNM() {
		return BKNM;
	}

	public String getBKFNM() {
		return BKFNM;
	}

	public int getENTRYDT() {
		return ENTRYDT;
	}

	public int getENTRYTM() {
		return ENTRYTM;
	}

	public String getENTRYUSR() {
		return ENTRYUSR;
	}

	public void setBKNO(String string) {
		BKNO = string;
	}

	public void setBKNM(String string) {
		BKNM = string;
	}

	public void setBKFNM(String string) {
		BKFNM = string;
	}

	public void setENTRYDT(int i) {
		ENTRYDT = i;
	}

	public void setENTRYTM(int i) {
		ENTRYTM = i;
	}

	public void setENTRYUSR(String string) {
		ENTRYUSR = string;
	}

}