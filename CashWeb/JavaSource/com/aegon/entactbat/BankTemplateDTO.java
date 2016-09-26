package com.aegon.entactbat;

/**
 * System   : CashWeb
 * 
 * Function : 銀行模板傳輸對象
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
 * R00135---PA0024---CASH年度專案
 *
 *  
 */

public class BankTemplateDTO {
	// 銀行代碼
	private String bankCode;
	// 上傳文件類型 TXT CSV DAT FLT
	private String fileType;
	// 分割文件類型 定長 逗號分隔 分號分隔
	private String splitFileType;
	// 時間類型 西元 民國年
	private String dateTpye;
	// 時間是否有“/”分割符
	private String isSlant;
	// 時間起位
	private String dateStart;
	// 時間結束位
	private String dateEnd;
	// 金額起位
	private String feeStart;
	// 金額結束位
	private String feeEnd;
	// 是否右靠左補0
	private String isLeftZero;
	// 是否有小數點
	private String isPoint;
	// 是否有兩位小數
	private String isTwoNum;
	// 是否有千分號
	private String isPermille;
	// 是否右靠左補空
	private String isLeftSpace;
	// 是否右第1碼為正負號
	private String isFristNum;
	// 是否最後1碼負號或空白
	private String islastNum;
	// 分割欄位數
	private String splitNum;
	// 備註起位
	private String conStart;
	// 備註結束位
	private String conEnd;
	// 日期序列位
	private String dateIndex;
	// 金額序列位
	private String feeIndex;
	// 備註序列位
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
