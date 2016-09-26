package com.aegon.disb.disbreports;

import java.sql.ResultSet;

import com.aegon.disb.disbremit.CAPPaymentVO;

/**
 * System   : CasdhWeb
 * 
 * Function : ���I�q����Value Object
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
 * $EB0536-BC264 �K�Q�h�Q�v�ܰʫ��i�ѫO�ISIE
 * $
 * $Revision 1.5  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255�Q�v�ܰʫ��Y���~���O�I�M��
 * $
 * $Revision 1.4  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE�����ͦs�����q�H�b��ε��I
 * $
 * $Revision 1.3  2009/11/11 06:19:08  missteven
 * $R90474 �ק�CASH�\��
 * $
 * $Revision 1.2  2006/12/05 10:22:27  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.1  2006/06/29 09:40:39  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.3  2005/04/04 07:02:19  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

public class CAPPAYReportVO {

	private String PNO = ""; // COLHDG('��I�Ǹ�')

	private String POLICYNO = ""; // COLHDG('�O�渹�X')

	private String APPNM = ""; // COLHDG('�n�O�H�m�W')

	private String INSNM = ""; // COLHDG('�Q�O�H�m�W')

	private String RECEIVER = ""; // COLHDG('����H')

	private String MAILZIP = ""; // COLHDG('�l���ϸ�')

	private String MAILAD = ""; // COLHDG('�l���a�}')

	private String HMZIP = ""; // COLHDG('��Ұϸ�')

	private String HMAD = ""; // COLHDG('��Ҧa�}')

	private String SRVNM = ""; // COLHDG('�A�ȤH��')

	private String SRVBH = ""; // COLHDG('�A�ȳ��')

	/**
	 * ���I���� A: �ɴ� B: �פ���M�P C: �ܧ�h�O D:�h�ٷ���O�O E:��ú�h�O
	 **/
	private String ITEM = ""; // COLHDG('���I����')

	private double DEFAMT = 0; // 2 COLHDG('�Ѭ���')

	private double DIVAMT = 0; // 2 COLHDG('�O����Q')

	private double LOAN = 0; // 2 COLHDG('�O��U��')

	private double UNPRDPRM = 0; // 2 COLHDG('������O�O')

	private double REVPRM = 0; // 2 COLHDG('�M�P�O�O')

	private double CURPRM = 0; // 2 COLHDG('����O�O')

	private String PEWD = ""; // COLHDG('���I��L����')

	private double PEAMT = 0; // 2 COLHDG('���I��L���B')

	private double LANCAP = 0; // 2 COLHDG('�ɴڥ���')

	private double LANINT = 0; // 2 COLHDG('�ɴڧQ��')

	private double APL = 0; // 2 COLHDG('�۰ʹ�ú')

	private double APLINT = 0; // 2 COLHDG('��ú�Q��')

	private String OFFWD = ""; // COLHDG('���ڨ�L����')

	private double OFFAMT = 0; // 2 COLHDG('���ڨ�L���B')

	private String OFFWD1 = ""; // R90474

	private double OFFAMT1 = 0; // R90474

	private String OFFWD2 = ""; // R90474

	private double OFFAMT2 = 0; // R90474

	private String OFFWD3 = ""; // R90474

	private double OFFAMT3 = 0; // R90474

	private String SNDNM = ""; // COLHDG('�H��')

	private int UPDDT = 0; // 0 COLHDG('������')

	private int UPDTM = 0; // 0 COLHDG('����ɶ�')

	private String UPDUSR = ""; // COLHDG('����H��')

	private double OVRRTN = 0; // 2 OVRRTN('��ú�h�O') -�[��

	private double ANNAMT = 0; // ANNAMT('�~�����e���I���B') -�[��
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
	 * ���I����
	 * 
	 * @return A: �ɴ� B: �פ���M�P C: �ܧ�h�O D: �h�ٷ���O�O
	 */
	public String getItemDesc() {
		if ("A".equals(this.ITEM)) {
			return "�ɴ�";
		} else if ("B".equals(this.ITEM)) {
			return "�פ���M�P";
		} else if ("C".equals(this.ITEM)) {
			return "�ܧ�h�O";
		} else if ("D".equals(this.ITEM)) {
			return "�h�ٷ���O�O";
		} else if ("E".equals(this.ITEM)) {
			return "��ú�h�O";
		} else if ("G".equals(this.ITEM)) {
			return "�~�����e���I";
		} else {
			return "";
		}
	}

	/* EB0536 */
	public String getDIVDesc() {
		if ("4".equals(this.DIVTYPE)) {
			return "�^�X��";
		} else {
			return "�O����Q";
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