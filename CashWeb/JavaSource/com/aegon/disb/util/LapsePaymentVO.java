package com.aegon.disb.util;

/**
 * System   : CashWeb
 * 
 * Function : 失效給付通知書工作檔Value Object
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.1 $$
 * 
 * Author   : MISSALLY
 * 
 * Create Date : 2013/03/13
 * 
 * Request ID : R10190-P10011
 * 
 * CVS History:
 * 
 * $$Log: LapsePaymentVO.java,v $
 * $Revision 1.1  2013/05/02 11:07:05  MISSALLY
 * $R10190 美元失效保單作業
 * $$
 *  
 */

public class LapsePaymentVO {

	/* 支付序號 */
	private String PNO = "";
	/* 保單號碼 */
	private String PolicyNo = "";
	/* 受款人ID */
	private String ReceiverId = "";
	/* 受款人姓名 */
	private String ReceiverName = "";
	/* 給付金額 */
	private double PaymentAmt = 0;
	/* 出納確認日 */
	private int RemitDate = 0;
	/* 是否寄送 */
	private String SendSwitch = "";
	/* 已寄送，但退匯 */
	private String RemitFailed = "";
	/* 寄送日期 */
	private int SendDate = 0;
	/* 異動者 */
	private String UpdatedUser = "";
	/* 異動日期 */
	private int UpdatedDate = 0;

	public String getPNO() {
		return PNO;
	}
	public void setPNO(String pNO) {
		PNO = pNO;
	}
	public String getPolicyNo() {
		return PolicyNo;
	}
	public void setPolicyNo(String policyNo) {
		PolicyNo = policyNo;
	}
	public String getReceiverId() {
		return ReceiverId;
	}
	public void setReceiverId(String receiverId) {
		ReceiverId = receiverId;
	}
	public String getReceiverName() {
		return ReceiverName;
	}
	public void setReceiverName(String receiverName) {
		ReceiverName = receiverName;
	}
	public double getPaymentAmt() {
		return PaymentAmt;
	}
	public void setPaymentAmt(double paymentAmt) {
		PaymentAmt = paymentAmt;
	}
	public int getRemitDate() {
		return RemitDate;
	}
	public void setRemitDate(int remitDate) {
		RemitDate = remitDate;
	}
	public String getSendSwitch() {
		return SendSwitch;
	}
	public void setSendSwitch(String sendSwitch) {
		SendSwitch = sendSwitch;
	}
	public String getRemitFailed() {
		return RemitFailed;
	}
	public void setRemitFailed(String RemitFailed) {
		this.RemitFailed = RemitFailed;
	}
	public int getSendDate() {
		return SendDate;
	}
	public void setSendDate(int sendDate) {
		SendDate = sendDate;
	}
	public String getUpdatedUser() {
		return UpdatedUser;
	}
	public void setUpdatedUser(String updatedUser) {
		UpdatedUser = updatedUser;
	}
	public int getUpdatedDate() {
		return UpdatedDate;
	}
	public void setUpdatedDate(int updatedDate) {
		UpdatedDate = updatedDate;
	}

}
