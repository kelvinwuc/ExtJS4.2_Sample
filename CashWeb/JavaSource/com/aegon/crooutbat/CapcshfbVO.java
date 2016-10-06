package com.aegon.crooutbat;

/**
 * System   : CashWeb
 * 
 * Function : �w�Ʈ־P��Value Object
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : MISSALLY
 * 
 * Create Date : 2013/8/7
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * $Log: CapcshfbVO.java,v $
 * Revision 1.1  2014/01/03 02:49:52  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */

public class CapcshfbVO {

	//CAPCSHFB,�w�Ʈ־P�ɸ��
	private String strCBKCD = "";//�Ȧ�N�X
	private String strCATNO = "";//�Ȧ�b��
	private String strCCURR = "";//CAPCSHFB.CSFBCURR��CAPCSHFBK1.CSFBCURR
	private int iCBKRMD = 0;//�Ȧ�״ڤ�
	private int iCAEGDT = 0;//���y�J�b��
	private double iCROAMT = 0.00;//�־P���B
	private String strCROSRC = "";//�־P�ӷ�
	private String strCROTYPE = "";//CroOutOneV.jsp���־P�ӷ�-->C:Capsil, G:GTMS, F:FF, T:�O�G�~, O:Others
	private String strPOCURR = "";//���ϥ�
	private int iCRODAY = 0; //CRODAY,�־P�b�@�~��
	private String strCSFBAU = "";//��Ʋ��ͪ�
	private int iCSFBAD = 0;//��Ʋ��ͤ��
	private int iCSFBAT = 0;//��Ʋ��ͮɶ�
	private String strCSFBUU = "";//��Ƨ�s��
	private int iCSFBUD = 0;//��Ƨ�s���
	private int iCSFBUT = 0;//��Ƨ�s�ɶ�
	private String strCSFBRECTNO = "";//�e���渹�X
	private int iCSFBRECSEQ = 0;//�e����Ǹ�
	private String strCSFBPONO = "";//�O�渹�X

	public String getCBKCD() {
		return strCBKCD;
	}
	public void setCBKCD(String string) {
		this.strCBKCD = string;
	}
	public String getCATNO() {
		return strCATNO;
	}
	public void setCATNO(String string) {
		this.strCATNO = string;
	}
	public String getCCURR() {
		return strCCURR;
	}
	public void setCCURR(String string) {
		this.strCCURR = string;
	}
	public int getCBKRMD() {
		return iCBKRMD;
	}
	public void setCBKRMD(int i) {
		this.iCBKRMD = i;
	}
	public int getCAEGDT() {
		return iCAEGDT;
	}
	public void setCAEGDT(int i) {
		this.iCAEGDT = i;
	}
	public double getCROAMT() {
		return iCROAMT;
	}
	public void setCROAMT(double d) {
		this.iCROAMT = d;
	}
	public String getCROSRC() {
		return strCROSRC;
	}
	public void setCROSRC(String string) {
		this.strCROSRC = string;
	}
	public String getCROTYPE() {
		return strCROTYPE;
	}
	public void setCROTYPE(String string) {
		this.strCROTYPE = string;
	}
	public String getPOCURR() {
		return strPOCURR;
	}
	public void setPOCURR(String string) {
		this.strPOCURR = string;
	}
	public int getCRODAY() {
		return iCRODAY;
	}
	public void setCRODAY(int i) {
		this.iCRODAY = i;
	}
	public String getCSFBUU() {
		return strCSFBUU;
	}
	public void setCSFBUU(String string) {
		this.strCSFBUU = string;
	}
	public int getCSFBUD() {
		return iCSFBUD;
	}
	public void setCSFBUD(int i) {
		this.iCSFBUD = i;
	}
	public int getCSFBUT() {
		return iCSFBUT;
	}
	public void setCSFBUT(int i) {
		this.iCSFBUT = i;
	}
	public String getCSFBRECTNO() {
		return strCSFBRECTNO;
	}
	public void setCSFBRECTNO(String string) {
		this.strCSFBRECTNO = string;
	}
	public int getCSFBRECSEQ() {
		return iCSFBRECSEQ;
	}
	public void setCSFBRECSEQ(int i) {
		this.iCSFBRECSEQ = i;
	}
	public String getCSFBPONO() {
		return strCSFBPONO;
	}
	public void setCSFBPONO(String string) {
		this.strCSFBPONO = string;
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

}