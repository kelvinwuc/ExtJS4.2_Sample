package com.aegon.disb.disbreports;

import java.sql.ResultSet;

import com.aegon.disb.disbremit.CAPPaymentVO;

/**
 * System   : CasdhWeb
 * 
 * Function : 給付通知書Value Object
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.6 $$
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: CAPPAYReportVO.java,v $
 * $Revision 1.6  2014/02/26 07:16:11  misariel
 * $EB0536-BC264 沛利多利率變動型養老保險SIE
 * $
 * $Revision 1.5  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255利率變動型即期年金保險專案
 * $
 * $Revision 1.4  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.3  2009/11/11 06:19:08  missteven
 * $R90474 修改CASH功能
 * $
 * $Revision 1.2  2006/12/05 10:22:27  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.1  2006/06/29 09:40:39  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.3  2005/04/04 07:02:19  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class CAPPAYReportVO {

	private String PNO = ""; // COLHDG('支付序號')

	private String POLICYNO = ""; // COLHDG('保單號碼')

	private String APPNM = ""; // COLHDG('要保人姓名')

	private String INSNM = ""; // COLHDG('被保人姓名')

	private String RECEIVER = ""; // COLHDG('收件人')

	private String MAILZIP = ""; // COLHDG('郵遞區號')

	private String MAILAD = ""; // COLHDG('郵遞地址')

	private String HMZIP = ""; // COLHDG('住所區號')

	private String HMAD = ""; // COLHDG('住所地址')

	private String SRVNM = ""; // COLHDG('服務人員')

	private String SRVBH = ""; // COLHDG('服務單位')

	/**
	 * 給付項目 A: 借款 B: 終止／撤銷 C: 變更退費 D:退還當期保費 E:溢繳退費
	 **/
	private String ITEM = ""; // COLHDG('給付項目')

	private double DEFAMT = 0; // 2 COLHDG('解約金')

	private double DIVAMT = 0; // 2 COLHDG('保單紅利')

	private double LOAN = 0; // 2 COLHDG('保單貸款')

	private double UNPRDPRM = 0; // 2 COLHDG('未到期保費')

	private double REVPRM = 0; // 2 COLHDG('撤銷保費')

	private double CURPRM = 0; // 2 COLHDG('當期保費')

	private String PEWD = ""; // COLHDG('給付其他說明')

	private double PEAMT = 0; // 2 COLHDG('給付其他金額')

	private double LANCAP = 0; // 2 COLHDG('借款本金')

	private double LANINT = 0; // 2 COLHDG('借款利息')

	private double APL = 0; // 2 COLHDG('自動墊繳')

	private double APLINT = 0; // 2 COLHDG('墊繳利息')

	private String OFFWD = ""; // COLHDG('扣款其他說明')

	private double OFFAMT = 0; // 2 COLHDG('扣款其他金額')

	private String OFFWD1 = ""; // R90474

	private double OFFAMT1 = 0; // R90474

	private String OFFWD2 = ""; // R90474

	private double OFFAMT2 = 0; // R90474

	private String OFFWD3 = ""; // R90474

	private double OFFAMT3 = 0; // R90474

	private String SNDNM = ""; // COLHDG('寄交')

	private int UPDDT = 0; // 0 COLHDG('執行日期')

	private int UPDTM = 0; // 0 COLHDG('執行時間')

	private String UPDUSR = ""; // COLHDG('執行人員')

	private double OVRRTN = 0; // 2 OVRRTN('溢繳退費') -加項

	private double ANNAMT = 0; // ANNAMT('年金提前給付金額') -加項
	/* EB0536 */
	private String DIVDesc = ""; // DIVDesc    
	private String DIVTYPE = ""; // DIVTYPE

	private CAPPaymentVO payment = null;

	public CAPPAYReportVO() {
	}

	public CAPPAYReportVO(ResultSet rs) {
		this.setResultSet(rs);
	}

	public double getAPL() {
		return APL;
	}

	public double getAPLINT() {
		return APLINT;
	}

	public String getAPPNM() {
		return APPNM;
	}

	public double getCURPRM() {
		return CURPRM;
	}

	public double getDEFAMT() {
		return DEFAMT;
	}

	public double getDIVAMT() {
		return DIVAMT;
	}

	public String getHMAD() {
		return HMAD;
	}

	public String getHMZIP() {
		return HMZIP;
	}

	public String getINSNM() {
		return INSNM;
	}

	public String getITEM() {
		return ITEM;
	}

/*****/

	public String getDIVTYPE() {
		return DIVTYPE;
	}

	/**
	 * 給付項目
	 * 
	 * @return A: 借款 B: 終止／撤銷 C: 變更退費 D: 退還當期保費
	 */
	public String getItemDesc() {
		if ("A".equals(this.ITEM)) {
			return "借款";
		} else if ("B".equals(this.ITEM)) {
			return "終止／撤銷";
		} else if ("C".equals(this.ITEM)) {
			return "變更退費";
		} else if ("D".equals(this.ITEM)) {
			return "退還當期保費";
		} else if ("E".equals(this.ITEM)) {
			return "溢繳退費";
		} else if ("G".equals(this.ITEM)) {
			return "年金提前給付";
		} else {
			return "";
		}
	}

	/* EB0536 */
	public String getDIVDesc() {
		if ("4".equals(this.DIVTYPE)) {
			return "回饋金";
		} else {
			return "保單紅利";
		}
	}

	public double getLANCAP() {
		return LANCAP;
	}

	public double getLANINT() {
		return LANINT;
	}

	public double getLOAN() {
		return LOAN;
	}

	public String getMAILAD() {
		return MAILAD;
	}

	public String getMAILZIP() {
		return MAILZIP;
	}

	public double getOFFAMT() {
		return OFFAMT;
	}

	public String getOFFWD() {
		return OFFWD;
	}

	public double getPEAMT() {
		return PEAMT;
	}

	public String getPEWD() {
		return PEWD;
	}

	public String getPNO() {
		return PNO;
	}

	public String getPOLICYNO() {
		return POLICYNO;
	}

	public String getRECEIVER() {
		return RECEIVER;
	}

	public double getREVPRM() {
		return REVPRM;
	}

	public String getSNDNM() {
		return SNDNM;
	}

	public String getSRVBH() {
		return SRVBH;
	}

	public String getSRVNM() {
		return SRVNM;
	}

	public double getUNPRDPRM() {
		return UNPRDPRM;
	}

	public int getUPDDT() {
		return UPDDT;
	}

	public int getUPDTM() {
		return UPDTM;
	}

	public String getUPDUSR() {
		return UPDUSR;
	}

	public void setAPL(double i) {
		APL = i;
	}

	public void setAPLINT(double i) {
		APLINT = i;
	}

	public void setAPPNM(String string) {
		APPNM = string;
	}

	public void setCURPRM(double i) {
		CURPRM = i;
	}

	public void setDEFAMT(double i) {
		DEFAMT = i;
	}

	public void setDIVAMT(double i) {
		DIVAMT = i;
	}

	public void setHMAD(String string) {
		HMAD = string;
	}

	public void setHMZIP(String string) {
		HMZIP = string;
	}

	public void setINSNM(String string) {
		INSNM = string;
	}

	public void setITEM(String string) {
		ITEM = string;
	}

	public void setLANCAP(double i) {
		LANCAP = i;
	}

	public void setLANINT(double i) {
		LANINT = i;
	}

	public void setLOAN(double i) {
		LOAN = i;
	}

	public void setMAILAD(String string) {
		MAILAD = string;
	}

	public void setMAILZIP(String string) {
		MAILZIP = string;
	}

	public void setOFFAMT(double i) {
		OFFAMT = i;
	}

	public void setOFFWD(String string) {
		OFFWD = string;
	}

	public void setPEAMT(double i) {
		PEAMT = i;
	}

	public void setPEWD(String string) {
		PEWD = string;
	}

	public void setPNO(String string) {
		PNO = string;
	}

	public void setPOLICYNO(String string) {
		POLICYNO = string;
	}

	public void setRECEIVER(String string) {
		RECEIVER = string;
	}

	public void setREVPRM(double i) {
		REVPRM = i;
	}

	public void setSNDNM(String string) {
		SNDNM = string;
	}

	public void setSRVBH(String string) {
		SRVBH = string;
	}

	public void setSRVNM(String string) {
		SRVNM = string;
	}

	public void setUNPRDPRM(double i) {
		UNPRDPRM = i;
	}

	public void setUPDDT(int i) {
		UPDDT = i;
	}

	public void setUPDTM(int i) {
		UPDTM = i;
	}

	public void setUPDUSR(String string) {
		UPDUSR = string;
	}


	public CAPPaymentVO getPayment() {
		return payment;
	}

	public void setPayment(CAPPaymentVO paymentVO) {
		payment = paymentVO;
	}

	private void setResultSet(ResultSet rs) {
		try { this.PNO = rs.getString("PNO"); } catch (Exception e) {}
		try { this.POLICYNO = rs.getString("POLICYNO"); } catch (Exception e) {}
		try { this.APPNM = rs.getString("APPNM"); } catch (Exception e) {}
		try { this.INSNM = rs.getString("INSNM"); } catch (Exception e) {}
		try { this.RECEIVER = rs.getString("RECEIVER"); } catch (Exception e) {}
		try { this.MAILZIP = rs.getString("MAILZIP"); } catch (Exception e) {}
		try { this.MAILAD = rs.getString("MAILAD"); } catch (Exception e) {}
		try { this.HMZIP = rs.getString("HMZIP"); } catch (Exception e) {}
		try { this.HMAD = rs.getString("HMAD"); } catch (Exception e) {}
		try { this.SRVNM = rs.getString("SRVNM"); } catch (Exception e) {}
		try { this.SRVBH = rs.getString("SRVBH"); } catch (Exception e) {}
		try { this.ITEM = rs.getString("ITEM"); } catch (Exception e) {}
		try { this.DEFAMT = rs.getDouble("DEFAMT"); } catch (Exception e) {}
		try { this.DIVAMT = rs.getDouble("DIVAMT"); } catch (Exception e) {}
		try { this.LOAN = rs.getDouble("LOAN"); } catch (Exception e) {}
		try { this.UNPRDPRM = rs.getDouble("UNPRDPRM"); } catch (Exception e) {}
		try { this.REVPRM = rs.getDouble("REVPRM"); } catch (Exception e) {}
		try { this.CURPRM = rs.getDouble("CURPRM"); } catch (Exception e) {}
		try { this.PEWD = rs.getString("PEWD"); } catch (Exception e) {}
		try { this.PEAMT = rs.getDouble("PEAMT"); } catch (Exception e) {}
		try { this.LANCAP = rs.getDouble("LANCAP"); } catch (Exception e) {}
		try { this.LANINT = rs.getDouble("LANINT"); } catch (Exception e) {}
		try { this.APL = rs.getDouble("APL"); } catch (Exception e) {}
		try { this.APLINT = rs.getDouble("APLINT"); } catch (Exception e) {}
		try { this.OFFWD = rs.getString("OFFWD"); } catch (Exception e) {}
		try { this.OFFAMT = rs.getDouble("OFFAMT"); } catch (Exception e) {}
		try { this.OFFWD1 = rs.getString("OFFWD1"); } catch (Exception e) {}
		try { this.OFFAMT1 = rs.getDouble("OFFAMT1"); } catch (Exception e) {}
		try { this.OFFWD2 = rs.getString("OFFWD2"); } catch (Exception e) {}
		try { this.OFFAMT2 = rs.getDouble("OFFAMT2"); } catch (Exception e) {}
		try { this.OFFWD3 = rs.getString("OFFWD3"); } catch (Exception e) {}
		try { this.OFFAMT3 = rs.getDouble("OFFAMT3"); } catch (Exception e) {}
		try { this.SNDNM = rs.getString("SNDNM"); } catch (Exception e) {}
		try { this.UPDDT = rs.getInt("UPDDT"); } catch (Exception e) {}
		try { this.UPDTM = rs.getInt("UPDTM"); } catch (Exception e) {}
		try { this.UPDUSR = rs.getString("UPDUSR"); } catch (Exception e) {}
		try { this.OVRRTN = rs.getDouble("OVRRTN"); } catch (Exception e) {}
		try { this.ANNAMT = rs.getDouble("ANNAMT"); } catch (Exception e) {} 
/*****/  
		try { this.DIVTYPE = rs.getString("DIVTYPE"); } catch (Exception e) {} 
	}

	public double getOVRRTN() {
		return OVRRTN;
	}

	public void setOVRRTN(double i) {
		OVRRTN = i;
	}

	public double getOFFAMT1() {
		return OFFAMT1;
	}

	public double getOFFAMT2() {
		return OFFAMT2;
	}

	public double getOFFAMT3() {
		return OFFAMT3;
	}

	public String getOFFWD1() {
		return OFFWD1;
	}

	public String getOFFWD2() {
		return OFFWD2;
	}

	public String getOFFWD3() {
		return OFFWD3;
	}

	public void setOFFAMT1(double d) {
		OFFAMT1 = d;
	}

	public void setOFFAMT2(double d) {
		OFFAMT2 = d;
	}

	public void setOFFAMT3(double d) {
		OFFAMT3 = d;
	}

	public void setOFFWD1(String string) {
		OFFWD1 = string;
	}

	public void setOFFWD2(String string) {
		OFFWD2 = string;
	}

	public void setOFFWD3(String string) {
		OFFWD3 = string;
	}

	public double getANNAMT() {
		return ANNAMT;
	}

	public void setANNAMT(double d) {
		ANNAMT = d;
	}
/*****/	
	public void setDIVTYPE(String string) {
		DIVTYPE = string;
	}

/*****/	
	public void setDIVDesc(String string) {
		DIVDesc = string;
	}


}