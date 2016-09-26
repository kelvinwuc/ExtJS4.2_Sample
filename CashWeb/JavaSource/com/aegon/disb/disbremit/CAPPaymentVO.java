package com.aegon.disb.disbremit;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.9 $$
 * 
 * Author   : Vicky Hsu
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: CAPPaymentVO.java,v $
 * $Revision 1.9  2012/05/18 09:47:37  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�
 * $
 * $Revision 1.8  2012/03/23 02:48:23  MISSALLY
 * $R10285-P10025
 * $�]���Ǩ��M�ש��I�D�ɷs�W�z�ߨ��z�s��
 * $
 * $Revision 1.7  2011/06/02 10:28:09  MISSALLY
 * $Q90585 / R90884 / R90989
 * $CASH�t�ζװh�B�z�@�~�s�W�װh��]���íץ��h�ש��Ӫ�
 * $
 * $Revision 1.6  2007/01/05 07:29:08  MISVANESSA
 * $R60550_����覡�ק�
 * $
 * $Revision 1.5  2006/12/07 11:20:56  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.4  2006/11/30 09:16:45  miselsa
 * $R60463��R60550�~����SPUL�O��
 * $
 * $Revision 1.3  2006/11/24 07:37:17  miselsa
 * $R60550_�s�W��~�״ڬ������
 * $
 * $Revision 1.2  2006/11/24 05:40:57  miselsa
 * $R60550_�s�W��~�״ڬ������
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.3  2005/08/19 06:53:51  misangel
 * $R50427 : �״ڥ�̳���+�m�W+�b���X��
 * $
 * $Revision 1.1.2.2  2005/04/04 07:02:26  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

import java.io.Serializable;
import java.sql.ResultSet;

import com.aegon.disb.disbcheck.CAPCheckVO;

public class CAPPaymentVO implements Serializable {

	private static final long serialVersionUID = 4034487021933127531L;

	/*��I�Ǹ� PNO*/
	private String PNO = "";

	/*�I�ڤ覡 PMethod*/
	private String PMethod = "";

	/*�I�ڤ�� PDate*/
	private int PDate = 0;

	/*���ڤH�m�W PName*/
	private String PName = "";

	/*��l���ڤH�m�W PSNAME*/
	private String PSName = "";

	/*���ڤHID PId*/
	private String PId = "";

	/*���O PCurr*/
	private String PCurr = "";

	/*��I���B PAMT*/
	private int PAMT = 0;

	/*�I�ڪ��A PStatus*/
	private String PStatus = "";

	/*��I�T�{��@ PCfmDt1*/
	private int PCfmDt1 = 0;

	/*��I�T�{�ɤ@ PCfmTm1*/
	private int PCfmTm1 = 0;

	/*��I�T�{�̤@ PCfmUsr1*/
	private String PCfmUsr1;

	/*��I�T�{��G PCfmDt2*/
	private int PCfmDt2 = 0;

	/*��I�T�{�ɤG PCfmTm2*/
	private int PCfmTm2 = 0;

	/*��I�T�{�̤G PCfmUsr2*/
	private String PCfmUsr2;

	/*��I�y�z PDesc*/
	private String PDesc = "";

	/*�ӷ��ոs PSrcGp*/
	private String PSrcGp = "";

	/*��I��]�N�X*/
	private String PSrcCode = "";

	/*�I�����O PPLANT*/
	private String PPLANT = "";

	/*�{���N�X PSrcPgm*/
	private String PSrcPgm = "";

	/*�@�o�_ PVoidable*/
	private String PVoidable = "";

	/*���_ PDispatch*/
	private String PDispatch = "";

	/*��I�Ȧ� PBBank*/
	private String PBBank = "";

	/*��I�b�� PBAccount*/
	private String PBAccount = "";

	/*�䲼���X PCheckNo*/
	private String PCheckNO = "";

	/*�䲼�T�I PChkm1*/
	private String PChkm1 = "";

	/*�䲼���u PChkm2*/
	private String PChkm2 = "";

	/*�״ڻȦ� PRBank*/
	private String PRBank = "";

	/*�״ڱb�� PRAccount*/
	private String PRAccount = "";

	/*�H�Υd�d�� PCrdNo*/
	private String PCrdNo = "";

	/*�d�O PCrdType*/
	private String PCrdType = "";

	/*���v�X PAuthCode*/
	private String PAuthCode = "";

	/*���Ħ~�� PCrdEffMY*/
	private String PCrdEffMY = "";

	/*�O�渹�X PolicyNo*/
	private String PolicyNo = "";

	/*�n�O�Ѹ��X AppNo*/
	private String AppNo = "";

	/*��� Branch*/
	private String Branch = "";

	/*�׶O RmtFee*/
	private int RmtFee = 0;

	/*��l��I�Ǹ� PNoH*/
	private String PNoH = "";

	/*�״ڧ帹BatNo*/
	private String BatNo = "";

	/*�X�Ǥ��PCSHDT*/
	private int PCshDt = 0;

	/*��J��� EntryDate*/
	private int EntryDt = 0;

	/*��J�ɶ� EntruTime*/
	private int EntryTm = 0;

	/*��J�H�� EntruUsr*/
	private String EntryUsr = "";

	/*��J�{�� EntruPgm*/
	private String EntryPgm = "";

	/*���ʤ�� UpdDt*/
	private int UpdDt = 0;

	/*���ʮɶ� UpdTm*/
	private int UpdTm = 0;

	/*���ʪ� UpdUsr*/
	private String UpdUsr = "";

	/* �Ƶ�*/
	private String Memo = "";

	/*�״ڧǸ�*/
	private String BatSeq = "";

	/*�X�ǽT�{�� PCSHCM*/
	private String PCSHCM = "";

	/*�~���ץX���O PPAYCURR*/
	private String PPAYCURR = "";

	/*�~���ץX���B PPAYAMT*/
	private double PPAYAMT = 0;

	/*�~���ײv PPAYRATE*/
	private String PPAYRATE = "";

	/*����O��I�覡 PFEEWAY*/
	private String PFEEWAY = "";

	/*���_�l�� PINVDT*/
	private int PINVDT = 0;

	/*SWIFTCODE  PSWIFT*/
	private String PSWIFT = "";

	/*���ڻȦ��O PBKCOTRY*/
	private String PBKCOTRY = "";

	/*���ڻȦ櫰�� PBKCITY*/
	private String PBKCITY = "";

	/*���ڻȦ���� PBKBRCH*/
	private String PBKBRCH = "";

	/*���ڤH�Э^�� PENGNAME*/
	private String PENGNAME = "";

	/*�Ȧ�W��PBKNAME*/
	private String PBKNAME = "";

	/* �h�פ�� REMITFAILD */
	private int RemitFailDate = 0;

	/* �h�׮ɶ� REMITFAILT */
	private int RemitFailTime = 0;

	/* �h�ץN�X REMITFCODE */
	private String RemitFailCode = "";

	/* �h�׭�] REMITFDESC */
	private String RemitFailDesc = "";

	/* �z�ߨ��z�s�� PCLMNUM */
	private String ClaimNumber = "";
	
	/* �Ȧ�h�צ^�s��� PBNKRFDT */
	private int BankRemitBackDate = 0;

	private CAPCheckVO paymentCheck = null;

	public CAPPaymentVO(ResultSet rs) {
		setResultSet(rs);
	}
	public CAPPaymentVO() {
	}

	/**
	 * @return �n�O�Ѹ��X
	 */
	public String getAppNo() {
		return AppNo;
	}

	/**
	 * @return �״ڧ帹
	 */
	public String getBatNo() {
		return BatNo;
	}

	/**
	 * @return ���
	 */
	public String getBranch() {
		return Branch;
	}

	/**
	 * @return ��J���
	 */
	public int getEntryDt() {
		return EntryDt;
	}

	/**
	 * @return ��J�{��
	 */
	public String getEntryPgm() {
		return EntryPgm;
	}

	/**
	 * @return ��J�ɶ�
	 */
	public int getEntryTm() {
		return EntryTm;
	}

	/**
	 * @return ��J�H��
	 */
	public String getEntryUsr() {
		return EntryUsr;
	}

	/**
	 * @return �Ƶ�
	 */
	public String getMemo() {
		return Memo;
	}

	/**
	 * @return �״ڧǸ�
	 */
	public String getBatSeq() {
		return BatSeq;
	}

	/**
	 * @return ��I���B
	 */
	public int getPAMT() {
		return PAMT;
	}

	/**
	 * @return ���v�X
	 */
	public String getPAuthCode() {
		return PAuthCode;
	}

	/**
	 * @return ��I�T�{��@
	 */
	public int getPCfmDt1() {
		return PCfmDt1;
	}

	/**
	 * @return ��I�T�{��G
	 */
	public int getPCfmDt2() {
		return PCfmDt2;
	}

	/**
	 * @return ��I�T�{�ɤ@
	 */
	public int getPCfmTm1() {
		return PCfmTm1;
	}

	/**
	 * @return ��I�T�{�ɤG
	 */
	public int getPCfmTm2() {
		return PCfmTm2;
	}

	/**
	 * @return ��I�T�{�̤@
	 */
	public String getPCfmUsr1() {
		return PCfmUsr1;
	}

	/**
	 * @return ��I�T�{�̤G
	 */
	public String getPCfmUsr2() {
		return PCfmUsr2;
	}

	/**
	 * @return �䲼���X
	 */
	public String getPCheckNO() {
		return PCheckNO;
	}

	/**
	 * @return �䲼�T�I
	 */
	public String getPChkm1() {
		return PChkm1;
	}

	/**
	 * @return �䲼���u
	 */
	public String getPChkm2() {
		return PChkm2;
	}

	/**
	 * @return ���Ħ~��
	 */
	public String getPCrdEffMY() {
		return PCrdEffMY;
	}

	/**
	 * @return �H�Υd�d��
	 */
	public String getPCrdNo() {
		return PCrdNo;
	}

	/**
	 * @return �d�O
	 */
	public String getPCrdType() {
		return PCrdType;
	}

	/**
	 * @return �X�Ǥ��
	 */
	public int getPCshDt() {
		return PCshDt;
	}

	/**
	 * @return ���O
	 */
	public String getPCurr() {
		return PCurr;
	}

	/**
	 * @return �I�ڤ��
	 */
	public int getPDate() {
		return PDate;
	}

	/**
	 * @return ��I�y�z
	 */
	public String getPDesc() {
		return PDesc;
	}

	/**
	 * @return ���_
	 */
	public String getPDispatch() {
		return PDispatch;
	}

	/**
	 * @return ���ڤHID
	 */
	public String getPId() {
		return PId;
	}

	/**
	 * @return �I�ڤ覡
	 */
	public String getPMethod() {
		return PMethod;
	}

	/**
	 * @return ���ڤH�m�W
	 */
	public String getPName() {
		return PName;
	}

	/**
	 * @return ��I�Ǹ�
	 */
	public String getPNO() {
		return PNO;
	}

	/**
	 * @return ��l��I�Ǹ�
	 */
	public String getPNoH() {
		return PNoH;
	}

	/**
	 * @return �O�渹�X
	 */
	public String getPolicyNo() {
		return PolicyNo;
	}

	/**
	 * @return �I�����O
	 */
	public String getPPLANT() {
		return PPLANT;
	}

	/**
	 * @return �״ڱb��
	 */
	public String getPRAccount() {
		return PRAccount;
	}

	/**
	 * @return �״ڻȦ�
	 */
	public String getPRBank() {
		return PRBank;
	}

	/**
	 * @return ��l���ڤH�m�W
	 */
	public String getPSName() {
		return PSName;
	}

	/**
	 * @return ��I��]�N�X
	 */
	public String getPSrcCode() {
		return PSrcCode;
	}

	/**
	 * @return �ӷ��ոs
	 */
	public String getPSrcGp() {
		return PSrcGp;
	}

	/**
	 * @return �{���N�X
	 */
	public String getPSrcPgm() {
		return PSrcPgm;
	}

	/**
	 * @return �I�ڪ��A
	 */
	public String getPStatus() {
		return PStatus;
	}

	/**
	 * @return �@�o�_
	 */
	public String getPVoidable() {
		return PVoidable;
	}

	/**
	 * @return �׶O
	 */
	public int getRmtFee() {
		return RmtFee;
	}

	/**
	 * @return ��I�b��
	 */
	public String getPBAccount() {
		return PBAccount;
	}

	/**
	 * @return ��I�Ȧ�
	 */
	public String getPBBank() {
		return PBBank;
	}

	/**
	 * @return ���ʤ��
	 */
	public int getUpdDt() {
		return UpdDt;
	}

	/**
	 * @return ���ʮɶ�
	 */
	public int getUpdTm() {
		return UpdTm;
	}

	/**
	 * @return ���ʪ�
	 */
	public String getUpdUsr() {
		return UpdUsr;
	}

	/**
	 * @return ����O��I�覡
	 */
	public String getPFEEWAY() {
		return PFEEWAY;
	}

	/**
	 * @return ���_�l��
	 */
	public int getPINVDT() {
		return PINVDT;
	}

	/**
	 * @return �~���ץX���B
	 */
	public double getPPAYAMT() {
		return PPAYAMT;
	}

	/**
	 * @return �~���ץX���O
	 */
	public String getPPAYCURR() {
		return PPAYCURR;
	}

	/**
	 * @return �~���ײv
	 */
	public String getPPAYRATE() {
		return PPAYRATE;
	}

	/**
	 * @return SWIFTCODE
	 */
	public String getPSWIFT() {
		return PSWIFT;
	}

	/**
	 * @return ���ڻȦ����
	 */
	public String getPBKBRCH() {
		return PBKBRCH;
	}

	/**
	 * @return ���ڻȦ櫰��
	 */
	public String getPBKCITY() {
		return PBKCITY;
	}

	/**
	 * @return ���ڻȦ��O
	 */
	public String getPBKCOTRY() {
		return PBKCOTRY;
	}

	/**
	 * @return ���ڤH�Э^��
	 */
	public String getPENGNAME() {
		return PENGNAME;
	}
	/**
	 * @return �Ȧ�W��
	 */
	public String getPBKNAME() {
		return PBKNAME;
	}

	/**
	 * @return �X�ǽT�{��
	 */
	public String getPCSHCM() {
		return PCSHCM;
	}

	/**
	 * @return �h�פ��
	 */
	public int getRemitFailDate() {
		return RemitFailDate;
	}

	/**
	 * @return �h�׮ɶ�
	 */
	public int getRemitFailTime() {
		return RemitFailTime;
	}

	/**
	 * @return �h�ץN�X
	 */
	public String getRemitFailCode() {
		return RemitFailCode;
	}

	/**
	 * @return �h�׭�]
	 */
	public String getRemitFailDesc() {
		return RemitFailDesc;
	}

	/**
	 * @return �z�ߨ��z�s��
	 */
	public String getClaimNumber() {
		return ClaimNumber;
	}
	
	/**
	 * @return �Ȧ�h�צ^�s���
	 */
	public int getBankRemitFailDate() {
		return BankRemitBackDate;
	}

	/**
	 * @param string
	 */
	public void setAppNo(String string) {
		AppNo = string;
	}

	/**
	 * @param string
	 */
	public void setBatNo(String string) {
		BatNo = string;
	}

	/**
	 * @param string
	 */
	public void setBranch(String string) {
		Branch = string;
	}

	/**
	 * @param i
	 */
	public void setEntryDt(int i) {
		EntryDt = i;
	}

	/**
	 * @param string
	 */
	public void setEntryPgm(String string) {
		EntryPgm = string;
	}

	/**
	 * @param i
	 */
	public void setEntryTm(int i) {
		EntryTm = i;
	}

	/**
	 * @param string
	 */
	public void setEntryUsr(String string) {
		EntryUsr = string;
	}

	/**
	 * @param string
	 */
	public void setMemo(String string) {
		Memo = string;
	}
	/**
	 * @param string
	 */
	public void setBatSeq(String string) {
		BatSeq = string;
	}

	/**
	 * @param i
	 */
	public void setPAMT(int i) {
		PAMT = i;
	}

	/**
	 * @param string
	 */
	public void setPAuthCode(String string) {
		PAuthCode = string;
	}

	/**
	 * @param i
	 */
	public void setPCfmDt1(int i) {
		PCfmDt1 = i;
	}

	/**
	 * @param i
	 */
	public void setPCfmDt2(int i) {
		PCfmDt2 = i;
	}

	/**
	 * @param i
	 */
	public void setPCfmTm1(int i) {
		PCfmTm1 = i;
	}

	/**
	 * @param i
	 */
	public void setPCfmTm2(int i) {
		PCfmTm2 = i;
	}

	/**
	 * @param string
	 */
	public void setPCfmUsr1(String string) {
		PCfmUsr1 = string;
	}

	/**
	 * @param string
	 */
	public void setPCfmUsr2(String string) {
		PCfmUsr2 = string;
	}

	/**
	 * @param string
	 */
	public void setPCheckNO(String string) {
		PCheckNO = string;
	}

	/**
	 * @param string
	 */
	public void setPChkm1(String string) {
		PChkm1 = string;
	}

	/**
	 * @param string
	 */
	public void setPChkm2(String string) {
		PChkm2 = string;
	}

	/**
	 * @param string
	 */
	public void setPCrdEffMY(String string) {
		PCrdEffMY = string;
	}

	/**
	 * @param string
	 */
	public void setPCrdNo(String string) {
		PCrdNo = string;
	}

	/**
	 * @param string
	 */
	public void setPCrdType(String string) {
		PCrdType = string;
	}

	/**
	 * @param i
	 */
	public void setPCshDt(int i) {
		PCshDt = i;
	}

	/**
	 * @param string
	 */
	public void setPCurr(String string) {
		PCurr = string;
	}

	/**
	 * @param i
	 */
	public void setPDate(int i) {
		PDate = i;
	}

	/**
	 * @param string
	 */
	public void setPDesc(String string) {
		PDesc = string;
	}

	/**
	 * @param string
	 */
	public void setPDispatch(String string) {
		PDispatch = string;
	}

	/**
	 * @param string
	 */
	public void setPId(String string) {
		PId = string;
	}

	/**
	 * @param string
	 */
	public void setPMethod(String string) {
		PMethod = string;
	}

	/**
	 * @param string
	 */
	public void setPName(String string) {
		PName = string;
	}

	/**
	 * @param string
	 */
	public void setPNO(String string) {
		PNO = string;
	}

	/**
	 * @param string
	 */
	public void setPNoH(String string) {
		PNoH = string;
	}

	/**
	 * @param string
	 */
	public void setPolicyNo(String string) {
		PolicyNo = string;
	}

	/**
	 * @param string
	 */
	public void setPPLANT(String string) {
		PPLANT = string;
	}

	/**
	 * @param string
	 */
	public void setPRAccount(String string) {
		PRAccount = string;
	}

	/**
	 * @param string
	 */
	public void setPRBank(String string) {
		PRBank = string;
	}

	/**
	 * @param string
	 */
	public void setPSName(String string) {
		PSName = string;
	}

	/**
	 * @param string
	 */
	public void setPSrcCode(String string) {
		PSrcCode = string;
	}

	/**
	 * @param string
	 */
	public void setPSrcGp(String string) {
		PSrcGp = string;
	}

	/**
	 * @param string
	 */
	public void setPSrcPgm(String string) {
		PSrcPgm = string;
	}

	/**
	 * @param string
	 */
	public void setPStatus(String string) {
		PStatus = string;
	}

	/**
	 * @param string
	 */
	public void setPVoidable(String string) {
		PVoidable = string;
	}

	/**
	 * @param i
	 */
	public void setRmtFee(int i) {
		RmtFee = i;
	}

	/**
	 * @param i
	 */
	public void setUpdDt(int i) {
		UpdDt = i;
	}

	/**
	 * @param i
	 */
	public void setUpdTm(int i) {
		UpdTm = i;
	}

	/**
	 * @param string
	 */
	public void setUpdUsr(String string) {
		UpdUsr = string;
	}

	/**
	 * @param string
	 */
	public void setPBAccount(String string) {
		PBAccount = string;
	}

	/**
	 * @param string
	 */
	public void setPBBank(String string) {
		PBBank = string;
	}

	/**
	 * @param string
	 */
	public void setPBKBRCH(String string) {
		PBKBRCH = string;
	}

	/**
	 * @param string
	 */
	public void setPBKCITY(String string) {
		PBKCITY = string;
	}

	/**
	 * @param string
	 */
	public void setPBKCOTRY(String string) {
		PBKCOTRY = string;
	}

	/**
	 * @param string
	 */
	public void setPCSHCM(String string) {
		PCSHCM = string;
	}

	/**
	 * @param string
	 */
	public void setPBKNAME(String string) {
		PBKNAME = string;
	}

	/**
	 * @param string
	 */
	public void setPFEEWAY(String string) {
		PFEEWAY = string;
	}

	/**
	 * @param i
	 */
	public void setPINVDT(int i) {
		PINVDT = i;
	}

	/**
	 * @param d
	 */
	public void setPPAYAMT(double d) {
		PPAYAMT = d;
	}

	/**
	 * @param string
	 */
	public void setPPAYCURR(String string) {
		PPAYCURR = string;
	}

	/**
	 * @param string
	 */
	public void setPPAYRATE(String string) {
		PPAYRATE = string;
	}

	/**
	 * @param string
	 */
	public void setPSWIFT(String string) {
		PSWIFT = string;
	}

	/**
	 * @param int
	 */
	public void setRemitFailDate(int i) {
		RemitFailDate = i;
	}

	/**
	 * @param int
	 */
	public void setRemitFailTime(int i) {
		RemitFailTime = i;
	}

	/**
	 * @param string
	 */
	public void setRemitFailCode(String string) {
		RemitFailCode = string;
	}

	/**
	 * @param string
	 */
	public void setRemitFailDesc(String string) {
		RemitFailDesc = string;
	}

	public void setClaimNumber(String claimNum) {
		ClaimNumber = claimNum;
	}
	
	/**
	 * @param int
	 */
	public void setBankRemitFailDate(int i) {
		BankRemitBackDate = i;
	}

	public void setResultSet(ResultSet rs) {
		try { this.PNO = rs.getString("PNO"); } catch (Exception e) {}
		try { this.PolicyNo = rs.getString("PMETHOD"); } catch (Exception e) {}
		try { this.PDate = rs.getInt("PDATE"); } catch (Exception e) {}
		try { this.PName = rs.getString("PNAME"); } catch (Exception e) {}
		try { this.PSName = rs.getString("PSNAME"); } catch (Exception e) {}
		try { this.PId = rs.getString("PID"); } catch (Exception e) {}
		try { this.PCurr = rs.getString("PCURR"); } catch (Exception e) {}
		try { this.PAMT = rs.getInt("PAMT"); } catch (Exception e) {}
		try { this.PStatus = rs.getString("PSTATUS"); } catch (Exception e) {}
		try { this.PCfmDt1 = rs.getInt("PCFMDT1"); } catch (Exception e) {}
		try { this.PCfmTm1 = rs.getInt("PCFMTM1"); } catch (Exception e) {}
		try { this.PCfmUsr1 = rs.getString("PCFMUSR1"); } catch (Exception e) {}
		try { this.PCfmDt2 = rs.getInt("PCFMDT2"); } catch (Exception e) {}
		try { this.PCfmTm2 = rs.getInt("PCFMTM2"); } catch (Exception e) {}
		try { this.PCfmUsr2 = rs.getString("PCFMUSR2"); } catch (Exception e) {}
		try { this.PDesc = rs.getString("PDESC"); } catch (Exception e) {}
		try { this.PSrcGp = rs.getString("PSRCGP"); } catch (Exception e) {}
		try { this.PSrcCode = rs.getString("PSRCCODE"); } catch (Exception e) {}
		try { this.PPLANT = rs.getString("PPLANT"); } catch (Exception e) {}
		try { this.PSrcPgm = rs.getString("PSRCPGM"); } catch (Exception e) {}
		try { this.PVoidable = rs.getString("PVOIDABLE"); } catch (Exception e) {}
		try { this.PDispatch = rs.getString("PDISPATCH"); } catch (Exception e) {}
		try { this.PBBank = rs.getString("PBBANK"); } catch (Exception e) {}
		try { this.PBAccount = rs.getString("PBACCOUNT"); } catch (Exception e) {}
		try { this.PCheckNO = rs.getString("PCHECKNO"); } catch (Exception e) {}
		try { this.PChkm1 = rs.getString("PCHKM1"); } catch (Exception e) {}
		try { this.PChkm2 = rs.getString("PCHKM2"); } catch (Exception e) {}
		try { this.PRBank = rs.getString("PRBANK"); } catch (Exception e) {}
		try { this.PRAccount = rs.getString("PRACCOUNT"); } catch (Exception e) {}
		try { this.PCrdNo = rs.getString("PCRDNO"); } catch (Exception e) {}
		try { this.PCrdType = rs.getString("PCRDTYPE"); } catch (Exception e) {}
		try { this.PAuthCode = rs.getString("PAUTHCODE"); } catch (Exception e) {}
		try { this.PCrdEffMY = rs.getString("PCRDEFFMY"); } catch (Exception e) {}
		try { this.PolicyNo = rs.getString("POLICYNO"); } catch (Exception e) {}
		try { this.AppNo = rs.getString("APPNO"); } catch (Exception e) {}
		try { this.Branch = rs.getString("BRANCH"); } catch (Exception e) {}
		try { this.RmtFee = rs.getInt("RMTFEE"); } catch (Exception e) {}
		try { this.PCshDt = rs.getInt("PCSHDT"); } catch (Exception e) {}
		try { this.BatNo = rs.getString("PBATNO"); } catch (Exception e) {}
		try { this.PNoH = rs.getString("PNOH"); } catch (Exception e) {}
		try { this.EntryDt = rs.getInt("ENTRYDT"); } catch (Exception e) {}
		try { this.EntryTm = rs.getInt("ENTRYTM"); } catch (Exception e) {}
		try { this.EntryUsr = rs.getString("ENTRYUSR"); } catch (Exception e) {}
		try { this.EntryPgm = rs.getString("ENTRYPGM"); } catch (Exception e) {}
		try { this.UpdDt = rs.getInt("UPDDT"); } catch (Exception e) {}
		try { this.UpdTm = rs.getInt("UPDTM"); } catch (Exception e) {}
		try { this.UpdUsr = rs.getString("UPDUSR"); } catch (Exception e) {}
		try { this.Memo = rs.getString("MEMO"); } catch (Exception e) {}
		try { this.BatSeq = rs.getString("BatSeq"); } catch (Exception e) {}
		try { this.PPAYCURR = rs.getString("PPAYCURR"); } catch (Exception e) {}
		try { this.PPAYAMT = rs.getDouble("PPAYAMT"); } catch (Exception e) {}
		try { this.PPAYRATE = rs.getString("PPAYRATE"); } catch (Exception e) {}
		try { this.PFEEWAY = rs.getString("PFEEWAY"); } catch (Exception e) { }
		try { this.PINVDT = rs.getInt("PINVDT"); } catch (Exception e) {}
		try { this.PSWIFT = rs.getString("PSWIFT"); } catch (Exception e) {}
		try { this.PBKCOTRY = rs.getString("PBKCOTRY"); } catch (Exception e) {}
		try { this.PBKCITY = rs.getString("PSPBKCITYWIFT"); } catch (Exception e) {}
		try { this.PBKBRCH = rs.getString("PBKBRCH"); } catch (Exception e) {}
		try { this.PENGNAME = rs.getString("PENGNAME"); } catch (Exception e) {}
		try { this.PBKNAME = rs.getString("PBKNAME"); } catch (Exception e) {}
		try { this.RemitFailDate = rs.getInt("REMITFAILD"); } catch (Exception e) {}
		try { this.RemitFailTime = rs.getInt("REMITFAILT"); } catch (Exception e) {}
		try { this.RemitFailCode = rs.getString("REMITFCODE"); } catch (Exception e) {}
		try { this.RemitFailDesc = rs.getString("REMITFDESC"); } catch (Exception e) {}
		try { this.ClaimNumber = rs.getString("PCLMNUM"); } catch (Exception e) {}
		try { this.BankRemitBackDate = rs.getInt("PBNKRFDT"); } catch (Exception e) {}//R10314
	}

	/**
	 * @return
	 */
	public CAPCheckVO getPaymentCheck() {
		return paymentCheck;
	}

	/**
	 * @param checkVO
	 */
	public void setPaymentCheck(CAPCheckVO checkVO) {
		paymentCheck = checkVO;
	}

}