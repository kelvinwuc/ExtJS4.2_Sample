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
 * $$Log: DISBPNoticeDetailVO.java,v $
 * $Revision 1.2  2008/11/18 02:22:31  MISODIN
 * $R80824
 * $
 * $Revision 1.1  2006/06/29 09:40:13  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:26  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */
package com.aegon.disb.util;

public class DISBPNoticeDetailVO implements java.io.Serializable {

	/*��I�Ǹ� PNO*/
	private String strPNO;

	/*�O�渹�X PolicyNo*/
	private String strPolicyNo;

	/*APPNM	�n�O�H�m�W*/
	private String strAppNm;

	/*INSNM	�Q�O�H�m�W*/
	private String strInsNm;

	/*RECEIVER	����H*/
	private String strReceiver;

	/*MAILZIP	�H�e�l���ϸ�*/
	private String strMailZip;

	/*MAILAD	�H�e�a�}*/
	private String strMailAd;

	/*HMZIP	��Ҷl���ϸ�*/
	private String strHmZip;

	/*HMAD	��Ҧa�}*/
	private String strHmAd;

	/*SRVNM	�A�ȤH��*/
	private String strSrvNm;

	/*SRVBH	�A�ȳ��*/
	private String strSrvBh;

	/*ITEM	���I����*/
	private String strItem;

	/*DEFAMT	�Ѭ���*/
	private double iDefAmt = 0;

	/*DIVAMT	�O����Q*/
	private double iDivAmt = 0;

	/*LOAN	�O��ɴ�*/
	private int iLoan;

	/*UNPRDPRM	������O�O*/
	private int iUnPrdPrm = 0;

	/*REVPRM	�M�P�h�O*/
	private int iRevPrm = 0;

	/*CURPRM	����O�O*/
	private int iCurPrm;
	
	/*OVRRTN	��ú�h�O*/
	private int iOVRRTN;

	/*PEWD	���I��L��-��r����*/
	private String strPewD;

	/*PEAMT	���I��L��-���B*/
	private String strPeAmt;

	/*LANCAP	�ɴڥ���(-)*/
	private int iLanCap = 0;

	/*LANINT	�ɴڧQ��(-)*/
	private int iLanInt = 0;

	/*APL	�۰ʹ�ú(-)*/
	private int iApl = 0;

	/*APLINT	��ú�Q��(-)*/
	private int iAplInt = 0;

	/*OFFWD	���ڨ�L-��r����*/
	private String strOffWd;

	/*OFFAMT	���ڨ�L-���B(-)*/
	private String strOffAmt;

	/*���ʤ�� UpdDt*/
	private int iUpdDt = 0;

	/*���ʮɶ� UpdTm*/
	private int iUpdTm = 0;

	/*���ʪ� UpdUsr*/
	private String strUpdUsr;

	/*R80824�n�O�HID APPID*/
	private String strAppID;
	
	/*R80824�n�O�H�ʧO APPSEX*/
	private String strAppSex;	
	
	/**
	 * @return
	 */
	public int getIApl() {
		return iApl;
	}

	/**
	 * @return
	 */
	public int getIAplInt() {
		return iAplInt;
	}

	/**
	 * @return
	 */
	public int getICurPrm() {
		return iCurPrm;
	}

	/**
	 * @return
	 */
	public double getIDefAmt() {
		return iDefAmt;
	}

	/**
	 * @return
	 */
	public double getIDivAmt() {
		return iDivAmt;
	}

	/**
	 * @return
	 */
	public int getILanCap() {
		return iLanCap;
	}

	/**
	 * @return
	 */
	public int getILanInt() {
		return iLanInt;
	}

	/**
	 * @return
	 */
	public int getILoan() {
		return iLoan;
	}

	/**
	 * @return
	 */
	public int getIRevPrm() {
		return iRevPrm;
	}

	/**
	 * @return
	 */
	public int getIUnPrdPrm() {
		return iUnPrdPrm;
	}

	/**
	 * @return
	 */
	public int getIUpdDt() {
		return iUpdDt;
	}

	/**
	 * @return
	 */
	public int getIUpdTm() {
		return iUpdTm;
	}

	/**
	 * @return
	 */
	public String getStrAppNm() {
		return strAppNm;
	}

	/**
	 * @return
	 */
	public String getStrHmAd() {
		return strHmAd;
	}

	/**
	 * @return
	 */
	public String getStrHmZip() {
		return strHmZip;
	}

	/**
	 * @return
	 */
	public String getStrInsNm() {
		return strInsNm;
	}

	/**
	 * @return
	 */
	public String getStrItem() {
		return strItem;
	}

	/**
	 * @return
	 */
	public String getStrMailAd() {
		return strMailAd;
	}

	/**
	 * @return
	 */
	public String getStrMailZip() {
		return strMailZip;
	}

	/**
	 * @return
	 */
	public String getStrOffAmt() {
		return strOffAmt;
	}

	/**
	 * @return
	 */
	public String getStrOffWd() {
		return strOffWd;
	}

	/**
	 * @return
	 */
	public String getStrPeAmt() {
		return strPeAmt;
	}

	/**
	 * @return
	 */
	public String getStrPewD() {
		return strPewD;
	}

	/**
	 * @return
	 */
	public String getStrPNO() {
		return strPNO;
	}

	/**
	 * @return
	 */
	public String getStrPolicyNo() {
		return strPolicyNo;
	}

	/**
	 * @return
	 */
	public String getStrReceiver() {
		return strReceiver;
	}

	/**
	 * @return
	 */
	public String getStrSrvBh() {
		return strSrvBh;
	}

	/**
	 * @return
	 */
	public String getStrSrvNm() {
		return strSrvNm;
	}

	/**
	 * @return
	 */
	public String getStrUpdUsr() {
		return strUpdUsr;
	}

	/**
	 * @param i
	 */
	public void setIApl(int i) {
		iApl = i;
	}

	/**
	 * @param i
	 */
	public void setIAplInt(int i) {
		iAplInt = i;
	}

	/**
	 * @param i
	 */
	public void setICurPrm(int i) {
		iCurPrm = i;
	}

	/**
	 * @param i
	 */
	public void setIDefAmt(double i) {
		iDefAmt = i;
	}

	/**
	 * @param i
	 */
	public void setIDivAmt(double i) {
		iDivAmt = i;
	}

	/**
	 * @param i
	 */
	public void setILanCap(int i) {
		iLanCap = i;
	}

	/**
	 * @param i
	 */
	public void setILanInt(int i) {
		iLanInt = i;
	}

	/**
	 * @param i
	 */
	public void setILoan(int i) {
		iLoan = i;
	}

	/**
	 * @param i
	 */
	public void setIRevPrm(int i) {
		iRevPrm = i;
	}

	/**
	 * @param i
	 */
	public void setIUnPrdPrm(int i) {
		iUnPrdPrm = i;
	}

	/**
	 * @param i
	 */
	public void setIUpdDt(int i) {
		iUpdDt = i;
	}

	/**
	 * @param i
	 */
	public void setIUpdTm(int i) {
		iUpdTm = i;
	}

	/**
	 * @param string
	 */
	public void setStrAppNm(String string) {
		strAppNm = string;
	}

	/**
	 * @param string
	 */
	public void setStrHmAd(String string) {
		strHmAd = string;
	}

	/**
	 * @param string
	 */
	public void setStrHmZip(String string) {
		strHmZip = string;
	}

	/**
	 * @param string
	 */
	public void setStrInsNm(String string) {
		strInsNm = string;
	}

	/**
	 * @param string
	 */
	public void setStrItem(String string) {
		strItem = string;
	}

	/**
	 * @param string
	 */
	public void setStrMailAd(String string) {
		strMailAd = string;
	}

	/**
	 * @param string
	 */
	public void setStrMailZip(String string) {
		strMailZip = string;
	}

	/**
	 * @param string
	 */
	public void setStrOffAmt(String string) {
		strOffAmt = string;
	}

	/**
	 * @param string
	 */
	public void setStrOffWd(String string) {
		strOffWd = string;
	}

	/**
	 * @param string
	 */
	public void setStrPeAmt(String string) {
		strPeAmt = string;
	}

	/**
	 * @param string
	 */
	public void setStrPewD(String string) {
		strPewD = string;
	}

	/**
	 * @param string
	 */
	public void setStrPNO(String string) {
		strPNO = string;
	}

	/**
	 * @param string
	 */
	public void setStrPolicyNo(String string) {
		strPolicyNo = string;
	}

	/**
	 * @param string
	 */
	public void setStrReceiver(String string) {
		strReceiver = string;
	}

	/**
	 * @param string
	 */
	public void setStrSrvBh(String string) {
		strSrvBh = string;
	}

	/**
	 * @param string
	 */
	public void setStrSrvNm(String string) {
		strSrvNm = string;
	}

	/**
	 * @param string
	 */
	public void setStrUpdUsr(String string) {
		strUpdUsr = string;
	}

	/**
	 * @return
	 */
	public int getIOVRRTN() {
		return iOVRRTN;
	}

	/**
	 * @param i
	 */
	public void setIOVRRTN(int i) {
		iOVRRTN = i;
	}
    //R80824  APPID ,APPSEX
	/**
	 * @return
	 */
	public String getStrAppID() {
		return strAppID;
	}

	public void setStrAppID(String string) {
		strAppID = string;
	}

	public String getStrAppSex() {
		return strAppSex;
	}
	
	public void setStrAppSex(String string) {
		strAppSex = string;
	}


}