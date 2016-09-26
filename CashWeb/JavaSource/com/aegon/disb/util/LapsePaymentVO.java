package com.aegon.disb.util;

/**
 * System   : CashWeb
 * 
 * Function : ���ĵ��I�q���Ѥu�@��Value Object
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
 * $R10190 �������īO��@�~
 * $$
 *  
 */

public class LapsePaymentVO {

	/* ��I�Ǹ� */
	private String PNO = "";
	/* �O�渹�X */
	private String PolicyNo = "";
	/* ���ڤHID */
	private String ReceiverId = "";
	/* ���ڤH�m�W */
	private String ReceiverName = "";
	/* ���I���B */
	private double PaymentAmt = 0;
	/* �X�ǽT�{�� */
	private int RemitDate = 0;
	/* �O�_�H�e */
	private String SendSwitch = "";
	/* �w�H�e�A���h�� */
	private String RemitFailed = "";
	/* �H�e��� */
	private int SendDate = 0;
	/* ���ʪ� */
	private String UpdatedUser = "";
	/* ���ʤ�� */
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
