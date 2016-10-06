package com.aegon.entactbat;

/**
 * System   : CashWeb
 * 
 * Function : 登帳檔
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date :
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: CapcshfDTO.java,v $
 * Revision 1.3  2013/12/24 06:16:27  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */

public class CapcshfDTO {
	
	//CAPCSHF,登帳核銷檔資料
	private String EBKCD = "";//銀行代碼

	private String EATNO = "";//銀行帳號

	private int EBKRMD = 0;//銀行匯款日

	private int EAEGDT = 0;//全球入帳日

	private double ENTAMT = 0;//核銷金額

	private String ECRSRC = "2";//核銷來源

	private String ECRDAY = "0";//核銷帳作業日

	private String EUSREM = "";//使用者登帳備註

	private String EUSREM2 = "";//登帳備註２

	private String CSHFAU = "EntActBatS";//資料產生者

	private int CSHFAD = 0;//資料產生日期

	private int CSHFAT = 0;//資料產生時間

	private String CSHFUU = "";//資料更新者

	private int CSHFUD = 0;//資料更新日期

	private int CSHFUT = 0;//資料更新時間

	private String CSHFCURR = "";//幣別

	private String CROTYPE = "0";//資料類別

	private String CSHFPOCURR = "";//保單幣別

	private double CERRATE = 0;//匯率

	private double CENTAMTNT = 0;//台幣金額

	public String getEBKCD() {
		return EBKCD;
	}

	public void setEBKCD(String eBKCD) {
		EBKCD = eBKCD;
	}

	public String getEATNO() {
		return EATNO;
	}

	public void setEATNO(String eATNO) {
		EATNO = eATNO;
	}

	public int getEBKRMD() {
		return EBKRMD;
	}

	public void setEBKRMD(int eBKRMD) {
		EBKRMD = eBKRMD;
	}

	public int getEAEGDT() {
		return EAEGDT;
	}

	public void setEAEGDT(int eAEGDT) {
		EAEGDT = eAEGDT;
	}

	public double getENTAMT() {
		return ENTAMT;
	}

	public void setENTAMT(double eNTAMT) {
		ENTAMT = eNTAMT;
	}

	public String getECRSRC() {
		return ECRSRC;
	}

	public void setECRSRC(String eCRSRC) {
		ECRSRC = eCRSRC;
	}

	public String getECRDAY() {
		return ECRDAY;
	}

	public void setECRDAY(String eCRDAY) {
		ECRDAY = eCRDAY;
	}

	public String getEUSREM() {
		return EUSREM;
	}

	public void setEUSREM(String eUSREM) {
		EUSREM = eUSREM;
	}

	public String getCSHFAU() {
		return CSHFAU;
	}

	public void setCSHFAU(String cSHFAU) {
		CSHFAU = cSHFAU;
	}

	public int getCSHFAD() {
		return CSHFAD;
	}

	public void setCSHFAD(int cSHFAD) {
		CSHFAD = cSHFAD;
	}

	public int getCSHFAT() {
		return CSHFAT;
	}

	public void setCSHFAT(int cSHFAT) {
		CSHFAT = cSHFAT;
	}

	public String getCSHFUU() {
		return CSHFUU;
	}

	public void setCSHFUU(String cSHFUU) {
		CSHFUU = cSHFUU;
	}

	public int getCSHFUD() {
		return CSHFUD;
	}

	public void setCSHFUD(int cSHFUD) {
		CSHFUD = cSHFUD;
	}

	public int getCSHFUT() {
		return CSHFUT;
	}

	public void setCSHFUT(int cSHFUT) {
		CSHFUT = cSHFUT;
	}

	public String getCSHFCURR() {
		return CSHFCURR;
	}

	public void setCSHFCURR(String cSHFCURR) {
		CSHFCURR = cSHFCURR;
	}

	public String getEUSREM2() {
		return EUSREM2;
	}

	public void setEUSREM2(String eUSREM2) {
		EUSREM2 = eUSREM2;
	}

	public String getCROTYPE() {
		return CROTYPE;
	}

	public void setCROTYPE(String cROTYPE) {
		CROTYPE = cROTYPE;
	}

	public String getCSHFPOCURR() {
		return CSHFPOCURR;
	}

	public void setCSHFPOCURR(String cSHFPOCURR) {
		CSHFPOCURR = cSHFPOCURR;
	}

	public double getCERRATE() {
		return CERRATE;
	}

	public void setCERRATE(double cERRATE) {
		CERRATE = cERRATE;
	}

	public double getCENTAMTNT() {
		return CENTAMTNT;
	}

	public void setCENTAMTNT(double cENTAMTNT) {
		CENTAMTNT = cENTAMTNT;
	}

}
