package com.aegon.entactbat;

/**
 * System   : CashWeb
 * 
 * Function : �Ȧ�ҪO�ǿ��H
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
 * $Log: BankTemplateDTO.java,v $
 * Revision 1.3  2013/12/24 06:16:27  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */

public class BankTemplateDTO {
	// �Ȧ�N�X
	private String bankCode;
	// �W�Ǥ������ TXT CSV DAT FLT
	private String fileType;
	// ���Τ������ �w�� �r�����j �������j
	private String splitFileType;
	// �ɶ����� �褸 ����~
	private String dateTpye;
	// �ɶ��O�_����/�����β�
	private String isSlant;
	// �ɶ��_��
	private String dateStart;
	// �ɶ�������
	private String dateEnd;
	// ���B�_��
	private String feeStart;
	// ���B������
	private String feeEnd;
	// �O�_�k�a����0
	private String isLeftZero;
	// �O�_���p���I
	private String isPoint;
	// �O�_�����p��
	private String isTwoNum;
	// �O�_���d����
	private String isPermille;
	// �O�_�k�a���ɪ�
	private String isLeftSpace;
	// �O�_�k��1�X�����t��
	private String isFristNum;
	// �O�_�̫�1�X�t���Ϊť�
	private String islastNum;
	// ��������
	private String splitNum;
	// �Ƶ��_��
	private String conStart;
	// �Ƶ�������
	private String conEnd;
	// ����ǦC��
	private String dateIndex;
	// ���B�ǦC��
	private String feeIndex;
	// �Ƶ��ǦC��
	private String conIndex;

	public String getConStart() {
		return conStart;
	}

	public void setConStart(String conStart) {
		this.conStart = conStart;
	}

	public String getConEnd() {
		return conEnd;
	}

	public void setConEnd(String conEnd) {
		this.conEnd = conEnd;
	}

	public String getDateIndex() {
		return dateIndex;
	}

	public void setDateIndex(String dateIndex) {
		this.dateIndex = dateIndex;
	}

	public String getFeeIndex() {
		return feeIndex;
	}

	public void setFeeIndex(String feeIndex) {
		this.feeIndex = feeIndex;
	}

	public String getConIndex() {
		return conIndex;
	}

	public void setConIndex(String conIndex) {
		this.conIndex = conIndex;
	}

	public String getSplitNum() {
		return splitNum;
	}

	public void setSplitNum(String splitNum) {
		this.splitNum = splitNum;
	}

	public String getBankCode() {
		return bankCode;
	}

	public void setBankCode(String bankCode) {
		this.bankCode = bankCode;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getSplitFileType() {
		return splitFileType;
	}

	public void setSplitFileType(String splitFileType) {
		this.splitFileType = splitFileType;
	}

	public String getDateTpye() {
		return dateTpye;
	}

	public void setDateTpye(String dateTpye) {
		this.dateTpye = dateTpye;
	}

	public String getIsSlant() {
		return isSlant;
	}

	public void setIsSlant(String isSlant) {
		this.isSlant = isSlant;
	}

	public String getDateStart() {
		return dateStart;
	}

	public void setDateStart(String dateStart) {
		this.dateStart = dateStart;
	}

	public String getDateEnd() {
		return dateEnd;
	}

	public void setDateEnd(String dateEnd) {
		this.dateEnd = dateEnd;
	}

	public String getFeeStart() {
		return feeStart;
	}

	public void setFeeStart(String feeStart) {
		this.feeStart = feeStart;
	}

	public String getFeeEnd() {
		return feeEnd;
	}

	public void setFeeEnd(String feeEnd) {
		this.feeEnd = feeEnd;
	}

	public String getIsLeftZero() {
		return isLeftZero;
	}

	public void setIsLeftZero(String isLeftZero) {
		this.isLeftZero = isLeftZero;
	}

	public String getIsPoint() {
		return isPoint;
	}

	public void setIsPoint(String isPoint) {
		this.isPoint = isPoint;
	}

	public String getIsTwoNum() {
		return isTwoNum;
	}

	public void setIsTwoNum(String isTwoNum) {
		this.isTwoNum = isTwoNum;
	}

	public String getIsPermille() {
		return isPermille;
	}

	public void setIsPermille(String isPermille) {
		this.isPermille = isPermille;
	}

	public String getIsLeftSpace() {
		return isLeftSpace;
	}

	public void setIsLeftSpace(String isLeftSpace) {
		this.isLeftSpace = isLeftSpace;
	}

	public String getIsFristNum() {
		return isFristNum;
	}

	public void setIsFristNum(String isFristNum) {
		this.isFristNum = isFristNum;
	}

	public String getIslastNum() {
		return islastNum;
	}

	public void setIslastNum(String islastNum) {
		this.islastNum = islastNum;
	}

}
