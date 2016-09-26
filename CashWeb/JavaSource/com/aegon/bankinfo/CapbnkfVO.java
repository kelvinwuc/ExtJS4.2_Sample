package com.aegon.bankinfo;

/**
 * System   : CashWeb
 * 
 * Function : 金融單位資料維護 Value Object
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : MISSALLY
 * 
 * Create Date : 2013/6/13
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * $Log: CapbnkfVO.java,v $
 * Revision 1.1  2013/12/24 02:14:03  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */

public class CapbnkfVO {

	private String BankCode = "";
	private String BankName = "";
	private String BankAccount = "";
	private String BankCurr = "";
	private String BankGlAct = "";
	private String BankAlat = "";
	private String BankCred = "";
	private String BankPacb = "";
	private String BankBatc = "";
	private String BankGpCd = "";
	private String BankSpec = "";
	private String BankStatus = "";
	private String BankMemo = "";

	private String CreateDate = "";
	private String CreateTime = "";
	private String CreateUser = "";

	private String UpdatedDate = "";
	private String UpdatedTime = "";
	private String UpdatedUser = "";

	public String getBankCode() {
		return BankCode;
	}
	public void setBankCode(String bankCode) {
		BankCode = bankCode;
	}

	public String getBankName() {
		return BankName;
	}
	public void setBankName(String bankName) {
		BankName = bankName;
	}

	public String getBankAccount() {
		return BankAccount;
	}
	public void setBankAccount(String bankAccount) {
		BankAccount = bankAccount;
	}

	public String getBankCurr() {
		return BankCurr;
	}
	public void setBankCurr(String bankCurr) {
		BankCurr = bankCurr;
	}

	public String getBankGlAct() {
		return BankGlAct;
	}
	public void setBankGlAct(String bankGlAct) {
		BankGlAct = bankGlAct;
	}

	public String getBankAlat() {
		return BankAlat;
	}
	public void setBankAlat(String bankAlat) {
		BankAlat = bankAlat;
	}

	public String getBankCred() {
		return BankCred;
	}
	public void setBankCred(String bankCred) {
		BankCred = bankCred;
	}

	public String getBankPacb() {
		return BankPacb;
	}
	public void setBankPacb(String bankPacb) {
		BankPacb = bankPacb;
	}

	public String getBankBatc() {
		return BankBatc;
	}
	public void setBankBatc(String bankBatc) {
		BankBatc = bankBatc;
	}

	public String getBankGpCd() {
		return BankGpCd;
	}
	public void setBankGpCd(String bankGpCd) {
		BankGpCd = bankGpCd;
	}

	public String getBankSpec() {
		return BankSpec;
	}
	public void setBankSpec(String bankSpec) {
		BankSpec = bankSpec;
	}

	public String getBankStatus() {
		return BankStatus;
	}
	public void setBankStatus(String bankStatus) {
		BankStatus = bankStatus;
	}

	public String getBankMemo() {
		return BankMemo;
	}
	public void setBankMemo(String bankMemo) {
		BankMemo = bankMemo;
	}

	public String getCreateDate() {
		return CreateDate;
	}
	public void setCreateDate(String createDate) {
		CreateDate = createDate;
	}

	public String getCreateTime() {
		return CreateTime;
	}
	public void setCreateTime(String createTime) {
		CreateTime = createTime;
	}

	public String getCreateUser() {
		return CreateUser;
	}
	public void setCreateUser(String createUser) {
		CreateUser = createUser;
	}

	public String getUpdatedDate() {
		return UpdatedDate;
	}
	public void setUpdatedDate(String updatedDate) {
		UpdatedDate = updatedDate;
	}

	public String getUpdatedTime() {
		return UpdatedTime;
	}
	public void setUpdatedTime(String updatedTime) {
		UpdatedTime = updatedTime;
	}

	public String getUpdatedUser() {
		return UpdatedUser;
	}
	public void setUpdatedUser(String updatedUser) {
		UpdatedUser = updatedUser;
	}
	
}

