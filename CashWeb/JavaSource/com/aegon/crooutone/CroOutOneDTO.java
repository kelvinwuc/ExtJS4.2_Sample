package com.aegon.crooutone;

/**
 * System : CashWeb
 * 
 * Function : �浧�P�b
 * 
 * Remark :
 * 
 * Revision : $$Revision: 1.4 $$
 * 
 * Author : MISSALLY * 
 * Create Date : $$Date: 2014/01/27 07:43:44 $$
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * $$Log: CroOutOneDTO.java,v $
 * $Revision 1.4  2014/01/27 07:43:44  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��-02
 * $BugFix
 * $
 * $Revision 1.2  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��-02
 * $$
 * 
 */

public class CroOutOneDTO {

	// �Ǹ�
	private int index = 0;
	// ���ĳ��
	private String strBkCode = "";
	// �Ȧ�b��
	private String strAccount = "";
	// ���ĳ��״ڤ�
	private int iRmtDt = 0;
	// ���O
	private String currency = "";
	// �O����O
	private String strPoCurr = "";

	// �״ڪ��B
	private double dFAMT = 0.00;
	// �I�ڪ��B
	private double dFBAMT = 0.00;

	// ���y�H�ؤJ�b���
	private int iAEGDate = 0;
	//�־P�@�~��
	private int iECRDay = 0;
	//CAPSIL�J�b��
	private int iCapsilDate = 0;

	// �K�n
	private String strBankRemark = "";
	// �Ƶ�
	private String strUserRemark = "";

	// �e���渹�X
	private String strReceiptNo = "";
	// �e����Ǹ�
	private int iReceiptSeq = 0;

	// �O�渹�X
	private String strPono = "";

	//������O
	private String strCROType = "";

	private String strCSHFAU = "";

	private int iCSHFAD = 0;

	private int iCSHFAT = 0;

	private String strCSFBAU = "";

	private int iCSFBAD = 0;

	private int iCSFBAT = 0;

	public int getIndex() {
		return index;
	}

	public void setIndex(int i) {
		this.index = i;
	}

	public String getBkCode() {
		return strBkCode;
	}

	public void setBkCode(String string) {
		this.strBkCode = string;
	}

	public String getAccount() {
		return strAccount;
	}

	public void setAccount(String string) {
		this.strAccount = string;
	}

	public int getRmtDt() {
		return iRmtDt;
	}

	public void setRmtDt(int i) {
		this.iRmtDt = i;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String string) {
		this.currency = string;
	}

	public double getFAMT() {
		return dFAMT;
	}

	public void setFAMT(double d) {
		this.dFAMT = d;
	}

	public double getFBAMT() {
		return dFBAMT;
	}

	public void setFBAMT(double d) {
		this.dFBAMT = d;
	}

	public int getAEGDt() {
		return iAEGDate;
	}

	public void setAEGDt(int i) {
		this.iAEGDate = i;
	}

	public String getBankRemark() {
		return strBankRemark;
	}

	public void setBankRemark(String string) {
		this.strBankRemark = string;
	}

	public String getUserRemark() {
		return strUserRemark;
	}

	public void setUserRemark(String string) {
		this.strUserRemark = string;
	}

	public String getPoCurr() {
		return strPoCurr;
	}

	public void setPoCurr(String string) {
		this.strPoCurr = string;
	}

	public String getReceiptNo() {
		return strReceiptNo;
	}

	public void setReceiptNo(String string) {
		this.strReceiptNo = string;
	}

	public int getReceiptSeq() {
		return iReceiptSeq;
	}

	public void setReceiptSeq(int i) {
		this.iReceiptSeq = i;
	}

	public String getPono() {
		return strPono;
	}

	public void setPono(String string) {
		this.strPono = string;
	}

	public int getCRDay() {
		return iECRDay;
	}

	public void setCRDay(int i) {
		this.iECRDay = i;
	}

	public String getCROType() {
		return strCROType;
	}

	public void setCROType(String string) {
		this.strCROType = string;
	}

	public int getCapsilDate() {
		return iCapsilDate;
	}

	public void setCapsilDate(int i) {
		this.iCapsilDate = i;
	}

	public String getCSHFAU() {
		return strCSHFAU;
	}

	public void setCSHFAU(String string) {
		this.strCSHFAU = string;
	}

	public int getCSHFAD() {
		return iCSHFAD;
	}

	public void setCSHFAD(int i) {
		this.iCSHFAD = i;
	}

	public int getCSHFAT() {
		return iCSHFAT;
	}

	public void setCSHFAT(int i) {
		this.iCSHFAT = i;
	}

	public String getCSFBAU() {
		return strCSFBAU;
	}

	public void setCSFBAU(String string) {
		this.strCSFBAU = string;
	}

	public int getCSFBAD() {
		return iCSFBAD;
	}

	public void setCSFBAD(int i) {
		this.iCSFBAD = i;
	}

	public int getCSFBAT() {
		return iCSFBAT;
	}

	public void setCSFBAT(int i) {
		this.iCSFBAT = i;
	}

	public boolean equals(Object obj) {
		if(!(obj instanceof CroOutOneDTO)) {
            return false;
        } else {
        	CroOutOneDTO thisObj = (CroOutOneDTO)obj;
        	return ((this.iCSFBAD*1000000 + this.iCSFBAT) - (thisObj.iCSFBAD*1000000 + thisObj.iCSFBAT) == 0);
        }
    }
}
