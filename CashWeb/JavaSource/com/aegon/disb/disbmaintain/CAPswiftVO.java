package com.aegon.disb.disbmaintain;

/**
 * System   : CashWeb
 * 
 * Function : 國外SWIFT CODE Value Object
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : Odin Tsai
 * 
 * Create Date : 
 * 
 * Request ID : R60463
 * 
 * CVS History:
 * 
 * $$Log: CAPswiftVO.java,v $
 * $Revision 1.2  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $$
 *  
 */

public class CAPswiftVO {
	
	/* 金融機構代碼 */
	private String bankNo = "";
	
	/* SWIFT CODE */
	private String swiftCode = "";
	
	/* 銀行名稱 */
	private String bankName = "";
	
	/* 輸入日期 */
	private String entryDate = "";
	
	/* 輸入人員 */
	private String entryID = "";
	
	/* 異動日期 */
	private String updateDate = "";
	
	/* 異動人員 */
	private String updateID = "";

	public String getBankNo() {
		return bankNo;
	}

	public String getSwiftCode() {
		return swiftCode;
	}

	public String getBankName() {
		return bankName;
	}

	public String getEntryDate() {
		return entryDate;
	}

	public String getEntryID() {
		return entryID;
	}

	public String getUpdateDate() {
		return updateDate;
	}

	public String getUpdateID() {
		return updateID;
	}

	public void setBankNo(String bankNo) {
		this.bankNo = bankNo;
	}

	public void setSwiftCode(String swiftCode) {
		this.swiftCode = swiftCode;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public void setEntryDate(String entryDate) {
		this.entryDate = entryDate;
	}

	public void setEntryID(String entryID) {
		this.entryID = entryID;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}

	public void setUpdateID(String updateID) {
		this.updateID = updateID;
	}

}
	
