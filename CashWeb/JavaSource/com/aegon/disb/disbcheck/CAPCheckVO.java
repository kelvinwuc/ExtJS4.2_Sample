package com.aegon.disb.disbcheck;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.3 $$
 * 
 * Author   : Vicky Hsu
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: CAPCheckVO.java,v $
 * $Revision 1.3  2013/12/24 02:17:18  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.2  2013/02/22 03:37:43  ODCWilliam
 * $william wu
 * $PA0024
 * $bill cash day
 * $
 * $Revision 1.1  2006/06/29 09:40:37  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.2  2005/04/04 07:02:22  miselsa
 * $R30530 支付系統
 * $$
 *  
 */
public class CAPCheckVO {
	
	/*銀行行庫 CBKNO*/
	private String CBKNO = "";

	/*銀行帳號 CACCOUNT */
	private String CACCOUNT = "";

	/* 票據批號 CBNO*/
	private String CBNO = "";

	/*票據號碼 CNO*/
	private String CNO= "";

	/*票面金額 CAMT*/
	private int CAMT = 0;

	/*到期日 CHEQUEDT*/
	private int CHEQUEDT = 0;

	/*兌現日 CASHDT*/
	private int CASHDT = 0;

	/*回銷日期 CRTNDT*/
	private int CRTNDT = 0;

	/*開立日期 CUSEDT*/
	private int CUSEDT = 0;

	/*退回日期 CBCKDT*/
	private int CBCKDT = 0;

	/*支票狀態 CSTATUS*/
	private String CSTATUS = "";

	/*支付序號 PNO*/
	private String PNO = "";

	/*傳票號碼 CNUMBER*/
	private String CNUMBER = "";

	/*問題票據 CERFLAG*/
	private String CERFLAG = "";

	/*人工開票用否 CHNDFLG*/
	private String CHNDFLG = "";

	/*輸入日期 ENTRYDATE*/
	private int ENTRYDATE = 0;

	/*輸入時間 ENTRYTIME*/
	private int ENTRYTIME = 0;

	/*輸入人員 ENTRYUSR*/
	private String ENTRYUSR = "";

	/*票據兌現日*/ //William 2012/12/20/ 更改票據對現日欄位
	private int CCASHDT = 0;

	public int getCCASHDT() {
		return CCASHDT;
	}

	public String getCACCOUNT() {
		return CACCOUNT;
	}

	public int getCAMT() {
		return CAMT;
	}

	public int getCASHDT() {
		return CASHDT;
	}

	public int getCBCKDT() {
		return CBCKDT;
	}

	public String getCBKNO() {
		return CBKNO;
	}

	public String getCBNO() {
		return CBNO;
	}

	public String getCERFLAG() {
		return CERFLAG;
	}

	public int getCHEQUEDT() {
		return CHEQUEDT;
	}

	public String getCHNDFLG() {
		return CHNDFLG;
	}

	public String getCNO() {
		return CNO;
	}

	public String getCNUMBER() {
		return CNUMBER;
	}

	public int getCRTNDT() {
		return CRTNDT;
	}

	public String getCSTATUS() {
		return CSTATUS;
	}

	public int getCUSEDT() {
		return CUSEDT;
	}

	public int getENTRYDATE() {
		return ENTRYDATE;
	}

	public int getENTRYTIME() {
		return ENTRYTIME;
	}

	public String getENTRYUSR() {
		return ENTRYUSR;
	}

	public String getPNO() {
		return PNO;
	}

	public void setCACCOUNT(String string) {
		CACCOUNT = string;
	}

	public void setCAMT(int i) {
		CAMT = i;
	}

	public void setCASHDT(int i) {
		CASHDT = i;
	}

	public void setCBCKDT(int i) {
		CBCKDT = i;
	}

	public void setCBKNO(String string) {
		CBKNO = string;
	}

	public void setCBNO(String string) {
		CBNO = string;
	}

	public void setCERFLAG(String string) {
		CERFLAG = string;
	}

	public void setCHEQUEDT(int i) {
		CHEQUEDT = i;
	}

	public void setCHNDFLG(String string) {
		CHNDFLG = string;
	}

	public void setCNO(String string) {
		CNO = string;
	}

	public void setCNUMBER(String string) {
		CNUMBER = string;
	}

	public void setCRTNDT(int i) {
		CRTNDT = i;
	}

	public void setCSTATUS(String string) {
		CSTATUS = string;
	}

	public void setCUSEDT(int i) {
		CUSEDT = i;
	}

	public void setENTRYDATE(int i) {
		ENTRYDATE = i;
	}

	public void setENTRYTIME(int i) {
		ENTRYTIME = i;
	}

	public void setENTRYUSR(String string) {
		ENTRYUSR = string;
	}

	public void setPNO(String string) {
		PNO = string;
	}

	public void setCCASHDT(int i) {
		CCASHDT = i;
	}

}