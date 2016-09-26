package com.aegon.disb.disbmaintain;

/**
 * System   : CashWeb
 * 
 * Function : �ꤺ����XValue Object
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
 * $RA0074 FNE�����ͦs�����q�H�b��ε��I
 * $$
 *  
 */

public class CAPccbfVO {
	
	/*�Ȧ��w BKNO*/
	private String BKNO = "";

	/*�Ȧ�²�� BKNM */
	private String BKNM = "";

	/*�Ȧ���W BKFNM */
	private String BKFNM = "";

	/*��J��� ENTRYDATE*/
	private int ENTRYDT = 0;

	/*��J�ɶ� ENTRYTIME*/
	private int ENTRYTM = 0;

	/*��J�H�� ENTRYUSR*/
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