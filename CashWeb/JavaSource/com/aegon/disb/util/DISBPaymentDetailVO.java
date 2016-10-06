package com.aegon.disb.util;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.20 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBPaymentDetailVO.java,v $
 * $Revision 1.20  2014/08/05 03:12:04  missteven
 * $RC0036
 * $
 * $Revision 1.18  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255�Q�v�ܰʫ��Y���~���O�I�M��
 * $
 * $Revision 1.17  2012/05/18 09:47:35  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�
 * $
 * $Revision 1.16  2012/03/23 02:48:22  MISSALLY
 * $R10285-P10025
 * $�]���Ǩ��M�ש��I�D�ɷs�W�z�ߨ��z�s��
 * $
 * $Revision 1.15  2011/06/02 10:28:07  MISSALLY
 * $Q90585 / R90884 / R90989
 * $CASH�t�ζװh�B�z�@�~�s�W�װh��]���íץ��h�ש��Ӫ�
 * $
 * $Revision 1.14  2010/11/23 07:02:28  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.13  2009/08/31 02:00:56  missteven
 * $R90380 �s�WCASH����ζǲ��\��
 * $
 * $Revision 1.12  2008/11/18 02:21:49  MISODIN
 * $R80824
 * $
 * $Revision 1.11  2008/08/21 09:16:49  misvanessa
 * $R80631_�s�W��l�I�ڤ覡 (FOR FF)
 * $
 * $Revision 1.10  2008/06/06 03:33:14  misvanessa
 * $R80391_�зs�WCASH�t�ΫH�Υd�h�^
 * $
 * $Revision 1.9  2008/04/30 07:49:35  misvanessa
 * $R80300_�������x�s,�s�W�U���ɮפγ���
 * $
 * $Revision 1.8  2007/08/03 10:01:39  MISODIN
 * $R70477 �~���O��״ڤ���O
 * $
 * $Revision 1.7  2006/11/30 09:11:08  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.6  2006/11/27 04:20:30  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.5  2006/11/24 03:09:05  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.3  2006/09/25 06:38:35  miselsa
 * $R60747�I�ڪ��B�p���I
 * $
 * $Revision 1.2  2006/09/04 09:43:36  miselsa
 * $R60747_1.���״ڼW�[�X�ǽT�{�� 2.�ץX����״ڤ���אּ�X�ǽT�{�� 3.��I�d�ߥI�ڤ�����X�ǽT�{��
 * $
 * $Revision 1.1  2006/06/29 09:40:13  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.5  2005/08/19 07:10:43  misangel
 * $R50427 : �״ڥ�̳���+�m�W+�b���X��
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:26  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

import java.io.Serializable;
import java.math.BigDecimal;

public class DISBPaymentDetailVO implements Serializable {

	private static final long serialVersionUID = -7373815096738637885L;

	/*��I�Ǹ� PNO*/
	private String strPNO;

	/*�I�ڤ覡 PMethod*/
	private String strPMethod;

	/*�I�ڤ�� PDate*/
	private int iPDate = 0;

	/*���ڤH�m�W PName*/
	private String strPName;

	/*��l���ڤH�m�W PSNAME*/
	private String strPSName;

	/*���ڤHID PId*/
	private String strPId;

	/*���O PCurr*/
	private String strPCurr;

	/*��I���B PAMT*/
	private double iPAMT = 0.00;

	/*�I�ڪ��A PStatus*/
	private String strPStatus;

	/*��I�T�{��@ PCfmDt1*/
	private int iPCfmDt1 = 0;

	/*��I�T�{�ɤ@ PCfmTm1*/
	private int iPCfmTm1 = 0;

	/*��I�T�{�̤@ PCfmUsr1*/
	private String strPCfmUsr1;

	public String getStrCQDate() {
		return strCQDate;
	}

	public void setStrCQDate(String strCQDate) {
		this.strCQDate = strCQDate;
	}

	/*��I�T�{��G PCfmDt2*/
	private int iPCfmDt2 = 0;

	/*��I�T�{�ɤG PCfmTm2*/
	private int iPCfmTm2 = 0;

	/*��I�T�{�̤G PCfmUsr2*/
	private String strPCfmUsr2;

	/*��I�y�z PDesc*/
	private String strPDesc;

	/*RC0036 �ӿ��� UsrDept*/
	private String strUsrDept;

	/*RC0036 �ӿ�¾�� UsrArea*/
	private String strUsrArea;

	
	/*RC0036*/
	private String strUsrInfo;
	
	private String strCQDate;
	
	private int ICQDate = 0;
	
	
	public int getICQDate() {
		return ICQDate;
	}

	public void setICQDate(int ICQDate) {
		this.ICQDate = ICQDate;
	}

	/*�ӷ��ոs PSrcGp*/
	private String strPSrcGp;

	/*��I��]�N�X*/
	private String strPSrcCode;

	/*�I�����O PPLANT*/
	private String strPPlant;

	/*�{���N�X PSrcPgm*/
	private String strPSrcPgm;

	/*�@�o�_ PVoidable*/
	private String strPVoidable;

	/*���_ PDispatch*/
	private String strPDispatch;

	/*��I�Ȧ� PBBank*/
	private String strPBBank;

	/*��I�b�� PBAccount*/
	private String strPBAccount;

	/*�䲼���X PCheckNo*/
	private String strPCheckNO;

	/*�䲼�T�I PChkm1*/
	private String strPChkm1;

	/*�䲼���u PChkm2*/
	private String strPChkm2;

	/*�״ڻȦ� PRBank*/
	private String strPRBank;

	/*�״ڱb�� PRAccount*/
	private String strPRAccount;

	/*�H�Υd�d�� PCrdNo*/
	private String strPCrdNo;

	/*�d�O PCrdType*/
	private String strPCrdType;

	/*���v�X PAuthCode*/
	private String strPAuthCode;

	/*���Ħ~�� PCrdEffMY*/
	private String strPCrdEffMY;

	/*�O�渹�X PolicyNo*/
	private String strPolicyNo;

	/*�n�O�Ѹ��X AppNo*/
	private String strAppNo;

	/*��� Branch*/
	private String strBranch;

	/*�׶O RmtFee*/
	private int iRmtFee = 0;

	/*��l��I�Ǹ� PNoH*/
	private String strPNoH;

	/*�״ڧ帹BatNo*/
	private String strBatNo;

	/*�X�Ǥ����PCSHDT*/
	private int iPCshDt = 0;

	/*��J��� EntryDate*/
	private int iEntryDt = 0;

	/*��J�ɶ� EntruTime*/
	private int iEntryTm = 0;

	/*��J�H�� EntruUsr*/
	private String strEntryUsr;

	/*��J�{�� EntruPgm*/
	private String strEntryPgm;

	/*���ʤ�� UpdDt*/
	private int iUpdDt = 0;

	/*���ʮɶ� UpdTm*/
	private int iUpdTm = 0;

	/*���ʪ� UpdUsr*/
	private String strUpdUsr;

	/* �Ƶ�*/
	private String strMemo;

	/* �O�_�Ŀ�*/
	private boolean isChecked = false;

	/* �O�_disable*/
	private boolean isDisabled = false;

	/*���v�����PAUTHDT*/
	private int iPAuthDt = 0;

	/*�״ڧǸ�*/
	private String strBATSEQ;

	/*R60747 �X�ǽT�{�� PCSHCM*/
	private int iPCSHCM = 0;

	/*R60550 �s�W6�����*/
	/*�~���ץX���O*/
	private String strPPAYCURR;

	/*�~���ץX���B*/
	private double iPPAYAMT = 0.0000;

	/*�~���ײv*/
	private double iPPAYRATE = 0.0000;

	/*����O��I�覡*/
	private String strPFEEWAY;

	/*���O S:SPUL*/
	private String strPSYMBOL;

	/*���_�l��*/
	private int iPINVDT = 0;

	/*���ڤH-�^��*/
	private String strPENGNAME;

	/*���ڻȦ�-SWIFTCODE*/
	private String strPSWIFT;

	/*���ڻȦ�-��O*/
	private String strPBKCOTRY;

	/*���ڻȦ�-����*/
	private String strPBKCITY;

	/*���ڻȦ�-����*/
	private String strPBKBRCH;

	/*R80631 ��l�I�ڤ覡*/
	private String strPMETHODO;

	/*FOR���ڻȦ�W��SWBKNAME(CAPSWIFT)*/
	private String SWBKNAME;

	/*FOR�h�פ���O���BFPAYAMT(CAPRFEF)*/
	private double FPAYAMT = 0;

	/*FOR�h�פ���O��I�覡FFEEWAY(CAPRFEF)*/
	private String FFEEWAY = "";

	/*R70477 �O����O FOR CAPRMTF*/
	private String strRPCURR;

	/*R80300�s�W�G����� */
	private String strPOrgCrdNo;
	private double iPOrgAMT = 0.00;

	/*R80391�s�W�״ڪ��B CAPRMTF*/
	private double iRAMT = 0.00;

	/*R80338 �M�׽X */
	private String strProjectCode;
	/*R80338 �h��_ */
	private String strRemitBack;
	/*R80338 �h���] */
	private String strBackRemark;

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

	/* �����q�N�X SRVBH */
	private String ServicingBranch = "";

	/*  */
	private int AnnuityPayDate = 0;
	
	private int rowCount = 0;

	private BigDecimal tPAMT = new BigDecimal("0");

	private String entryStartDate = "";

	private String entryEndDate = "";

	private String strPDate = "";

	private String selPSrcGp = "";

	private String strDispatch = "";

	private String strDept = "";

	private String strCurrency = "";

	private String strPMETHOD = "";

	/*R70600  ��I���B�x���Ѧ� */
	private double iPAMTNT = 0;
	
	// R00386
	private int checkedPayDate;
	
	//RD0382:OIU,�~�ȩ��ݤ��q�O
	private String company = "";
	
	//RD0382:OIU,���ڤH�q��
	private String phone = "";
	
	//RD0382:OIU,���ڤH�a�}1
	private String addr1 = "";
	
	//RD0382:OIU,���ڤH�a�}2
	private String addr2 = "";
		
	//RD0382:OIU,���ڤH�a�}3
	private String addr3 = "";
	
	//RD0382:OIU,���ڻȦ��ˮֽX
	private String payBankVerifyNumber = "";
	
	//RD0382:OIU,���ڻȦ�SORTCODE
	private String payBankSortCode = "";
	
	//RD0382:OIU,���ڻȦ����
	private String payBankBranch = "";		
	
	//RD0382:OIU,���ڻȦ�a�}1
	private String payBankAddr1 = "";
	
	//RD0382:OIU,���ڻȦ�a�}2
	private String payBankAddr2 = "";
		
	//RD0382:OIU,���ڻȦ�a�}3
	private String payBankAddr3 = "";
	
	//RD0382:OIU,�״ڻȦ�W��
	private String payRemitBankName = "";

	public double getIPAMT() {
		return iPAMT;
	}

	public int getIPDate() {
		return iPDate;
	}

	public int getIRmtFee() {
		return iRmtFee;
	}

	public String getStrAppNo() {
		return strAppNo;
	}

	public String getStrEntryPgm() {
		return strEntryPgm;
	}

	public String getStrEntryUsr() {
		return strEntryUsr;
	}

	public String getStrPAuthCode() {
		return strPAuthCode;
	}

	public String getStrPBAccount() {
		return strPBAccount;
	}

	public String getStrPBBank() {
		return strPBBank;
	}

	public String getStrPCfmUsr2() {
		return strPCfmUsr2;
	}

	public String getStrPCheckNO() {
		return strPCheckNO;
	}

	public String getStrPCrdEffMY() {
		return strPCrdEffMY;
	}

	public String getStrPCrdNo() {
		return strPCrdNo;
	}

	public String getStrPCrdType() {
		return strPCrdType;
	}

	public String getStrPCurr() {
		return strPCurr;
	}

	public String getStrPDesc() {
		return strPDesc;
	}
	
//RC0036
	public String getStrUsrDept() {
		return strUsrDept;
	}
//RC0036
	public String getStrUsrArea() {
			return strUsrArea;
	}
	
//RC0036
	public String getStrUsrInfo() {
		return strUsrInfo;
	}
	
	public String getStrPDispatch() {
		return strPDispatch;
	}

	public String getStrPId() {
		return strPId;
	}

	public String getStrPMethod() {
		return strPMethod;
	}

	public String getStrPName() {
		return strPName;
	}

	public String getStrPNO() {
		return strPNO;
	}

	public String getStrPNoH() {
		return strPNoH;
	}

	public String getStrPolicyNo() {
		return strPolicyNo;
	}

	public String getStrPRAccount() {
		return strPRAccount;
	}

	public String getStrPRBank() {
		return strPRBank;
	}

	public String getStrPSrcGp() {
		return strPSrcGp;
	}

	public String getStrPSrcPgm() {
		return strPSrcPgm;
	}

	public String getStrPStatus() {
		return strPStatus;
	}

	public String getStrPVoidable() {
		return strPVoidable;
	}

	public String getStrUpdUsr() {
		return strUpdUsr;
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

	public void setIPAMT(double i) {
		iPAMT = i;
	}

	public void setIPDate(int i) {
		iPDate = i;
	}

	public void setIRmtFee(int i) {
		iRmtFee = i;
	}

	public void setStrAppNo(String string) {
		strAppNo = string;
	}

	public void setStrEntryPgm(String string) {
		strEntryPgm = string;
	}

	public void setStrEntryUsr(String string) {
		strEntryUsr = string;
	}

	public void setStrPAuthCode(String string) {
		strPAuthCode = string;
	}

	public void setStrPBAccount(String string) {
		strPBAccount = string;
	}

	public void setStrPBBank(String string) {
		strPBBank = string;
	}

	public void setStrPCfmUsr2(String string) {
		strPCfmUsr2 = string;
	}

	public void setStrPCheckNO(String string) {
		strPCheckNO = string;
	}

	public void setStrPCrdEffMY(String string) {
		strPCrdEffMY = string;
	}

	public void setStrPCrdNo(String string) {
		strPCrdNo = string;
	}

	public void setStrPCrdType(String string) {
		strPCrdType = string;
	}

	public void setStrPCurr(String string) {
		strPCurr = string;
	}

	public void setStrPDesc(String string) {
		strPDesc = string;
	}
//RC0036
	public void setStrUsrDept(String string) {
		strUsrDept = string;
	}
//RC0036
	public void setStrUsrArea(String string) {
		strUsrArea = string;
	}

//RC0036
	public void setStrUsrInfo(String string) {
		strUsrInfo = string;
	}
	
	public void setStrPDispatch(String string) {
		strPDispatch = string;
	}

	public void setStrPId(String string) {
		strPId = string;
	}

	public void setStrPMethod(String string) {
		strPMethod = string;
	}

	public void setStrPName(String string) {
		strPName = string;
	}

	public void setStrPNO(String string) {
		strPNO = string;
	}

	public void setStrPNoH(String string) {
		strPNoH = string;
	}

	public void setStrPolicyNo(String string) {
		strPolicyNo = string;
	}

	public void setStrPRAccount(String string) {
		strPRAccount = string;
	}

	public void setStrPRBank(String string) {
		strPRBank = string;
	}

	public void setStrPSrcGp(String string) {
		strPSrcGp = string;
	}

	public void setStrPSrcPgm(String string) {
		strPSrcPgm = string;
	}

	public void setStrPStatus(String string) {
		strPStatus = string;
	}

	public void setStrPVoidable(String string) {
		strPVoidable = string;
	}

	public void setStrUpdUsr(String string) {
		strUpdUsr = string;
	}

	public void setStrBATSEQ(String string) {
		strBATSEQ = string;
	}

	public int getIPCfmDt1() {
		return iPCfmDt1;
	}

	public int getIPCfmDt2() {
		return iPCfmDt2;
	}

	public int getIPCfmTm1() {
		return iPCfmTm1;
	}

	public int getIPCfmTm2() {
		return iPCfmTm2;
	}

	public String getStrPCfmUsr1() {
		return strPCfmUsr1;
	}

	public void setIPCfmDt1(int i) {
		iPCfmDt1 = i;
	}

	public void setIPCfmDt2(int i) {
		iPCfmDt2 = i;
	}

	public void setIPCfmTm1(int i) {
		iPCfmTm1 = i;
	}

	public void setIPCfmTm2(int i) {
		iPCfmTm2 = i;
	}

	public void setStrPCfmUsr1(String string) {
		strPCfmUsr1 = string;
	}

	public int getIEntryDt() {
		return iEntryDt;
	}

	public int getIEntryTm() {
		return iEntryTm;
	}

	public int getIUpdDt() {
		return iUpdDt;
	}

	public int getIUpdTm() {
		return iUpdTm;
	}

	public void setIEntryDt(int i) {
		iEntryDt = i;
	}

	public void setIEntryTm(int i) {
		iEntryTm = i;
	}

	public void setIUpdDt(int i) {
		iUpdDt = i;
	}

	public void setIUpdTm(int i) {
		iUpdTm = i;
	}

	public int getIPCshDt() {
		return iPCshDt;
	}

	public boolean isChecked() {
		return isChecked;
	}

	public boolean isDisabled() {
		return isDisabled;
	}

	public String getStrBatNo() {
		return strBatNo;
	}

	public String getStrBranch() {
		return strBranch;
	}

	public String getStrMemo() {
		return strMemo;
	}

	public String getStrPChkm1() {
		return strPChkm1;
	}

	public String getStrPChkm2() {
		return strPChkm2;
	}

	public String getStrPPlant() {
		return strPPlant;
	}

	public String getStrPSName() {
		return strPSName;
	}

	public String getStrPSrcCode() {
		return strPSrcCode;
	}

	public void setIPCshDt(int i) {
		iPCshDt = i;
	}

	public void setChecked(boolean b) {
		isChecked = b;
	}

	public void setDisabled(boolean b) {
		isDisabled = b;
	}

	public void setStrBatNo(String string) {
		strBatNo = string;
	}

	public void setStrBranch(String string) {
		strBranch = string;
	}

	public void setStrMemo(String string) {
		strMemo = string;
	}

	public void setStrPChkm1(String string) {
		strPChkm1 = string;
	}

	public void setStrPChkm2(String string) {
		strPChkm2 = string;
	}

	public void setStrPPlant(String string) {
		strPPlant = string;
	}

	public void setStrPSName(String string) {
		strPSName = string;
	}

	public void setStrPSrcCode(String string) {
		strPSrcCode = string;
	}

	public int getIPAuthDt() {
		return iPAuthDt;
	}

	public void setIPAuthDt(int i) {
		iPAuthDt = i;
	}

	public String getStrBATSEQ() {
		return strBATSEQ;
	}

	public int getIPCSHCM() {
		return iPCSHCM;
	}

	public void setIPCSHCM(int i) {
		iPCSHCM = i;
	}

	public String getStrPPAYCURR() {
		return strPPAYCURR;
	}

	public void setStrPPAYCURR(String string) {
		strPPAYCURR = string;
	}

	public double getIPPAYAMT() {
		return iPPAYAMT;
	}

	public void setIPPAYAMT(double i) {
		iPPAYAMT = i;
	}

	public double getIPPAYRATE() {
		return iPPAYRATE;
	}

	public void setIPPAYRATE(double i) {
		iPPAYRATE = i;
	}

	public String getStrPFEEWAY() {
		return strPFEEWAY;
	}

	public String getStrPSYMBOL() {
		return strPSYMBOL;
	}

	public int getIPINVDT() {
		return iPINVDT;
	}

	public String getStrPENGNAME() {
		return strPENGNAME;
	}

	public String getStrPSWIFT() {
		return strPSWIFT;
	}

	public String getStrPBKCOTRY() {
		return strPBKCOTRY;
	}

	public String getStrPBKCITY() {
		return strPBKCITY;
	}

	public String getStrPBKBRCH() {
		return strPBKBRCH;
	}

	public String getStrPMETHODO() {
		return strPMETHODO;
	}
	/**@returnFOR���ڻȦ�W��SWBKNAME(CAPSWIFT)*/
	public String getSWBKNAME() {
		return SWBKNAME;
	}
	/**@returnFOR�h�פ���O(CAPRFEF)*/
	public double getFPAYAMT() {
		return FPAYAMT;
	}
	/**@returnFOR�h�פ���O(CAPRFEF)*/
	public String getFFEEWAY() {
		return FFEEWAY;
	}

	public void setStrPFEEWAY(String string) {
		strPFEEWAY = string;
	}

	public void setStrPSYMBOL(String string) {
		strPSYMBOL = string;
	}

	public void setIPINVDT(int i) {
		iPINVDT = i;
	}

	public void setStrPENGNAME(String string) {
		strPENGNAME = string;
	}

	public void setStrPSWIFT(String string) {
		strPSWIFT = string;
	}

	public void setStrPBKCOTRY(String string) {
		strPBKCOTRY = string;
	}

	public void setStrPBKCITY(String string) {
		strPBKCITY = string;
	}

	public void setStrPBKBRCH(String string) {
		strPBKBRCH = string;
	}

	public void setStrPMETHODO(String string) {
		strPMETHODO = string;
	}
	/**@paramFOR���ڻȦ�W��SWBKNAME(CAPSWIFT)*/
	public void setSWBKNAME(String string) {
		SWBKNAME = string;
	}
	/**@paramFOR�h�פ���O(CAPRFEF)*/
	public void setFPAYAMT(double i) {
		FPAYAMT = i;
	}

	/**@paramFOR�h�פ���O(CAPRFEF)*/
	public void setFFEEWAY(String string) {
		FFEEWAY = string;
	}

	/**
	 * R70477 �O����O FOR CAPRMTF
	 */
	public String getStrRPCURR() {
		return strRPCURR;
	}

	public void setStrRPCURR(String string) {
		strRPCURR = string;
	}

	/**
	 * R80300 �s�W���d��
	 */
	public String getStrPOrgCrdNo() {
		return strPOrgCrdNo;
	}

	public void setStrPOrgCrdNo(String string) {
		strPOrgCrdNo = string;
	}

	/** R80300 �s�W�����B*/
	public double getIPOrgAMT() {
		return iPOrgAMT;
	}
	public void setIPOrgAMT(double i) {
		iPOrgAMT = i;
	}

	/** R80391 �s�W�״ڪ��BCAPRMTF*/
	public double getIRAMT() {
		return iRAMT;
	}
	public void setIRAMT(double i) {
		iRAMT = i;
	}

	/**
	 * R80338  �M�׽X
	 */
	public String getStrProjectCode() {
		return strProjectCode;
	}

	public void setStrProjectCode(String string) {
		strProjectCode = string;
	}

	/**
	 * R80338  �h��_
	 */
	public String getStrRemitBack() {
		return strRemitBack;
	}

	public void setStrRemitBack(String string) {
		strRemitBack = string;
	}

	/**
	 * R80338  �h���]
	 */
	public String getStrBackRemark() {
		return strBackRemark;
	}

	public void setStrBackRemark(String string) {
		strBackRemark = string;
	}

	/**
	 * R70600  ��I���B�x���Ѧ�
	 */
	public double getIPAMTNT() {
		return iPAMTNT;
	}

	public void setIPAMTNT(double i) {
		iPAMTNT = i;
	}

	public int getRowCount() {
		return rowCount;
	}

	public void setRowCount(int i) {
		rowCount = i;
	}

	public String getEntryEndDate() {
		return entryEndDate;
	}

	public String getEntryStartDate() {
		return entryStartDate;
	}

	public void setEntryEndDate(String string) {
		entryEndDate = string;
	}

	public void setEntryStartDate(String string) {
		entryStartDate = string;
	}

	public String getStrCurrency() {
		return strCurrency;
	}

	public String getStrDept() {
		return strDept;
	}

	public String getStrDispatch() {
		return strDispatch;
	}

	public String getStrPMETHOD() {
		return strPMETHOD;
	}

	public void setStrCurrency(String string) {
		strCurrency = string;
	}

	public void setStrDept(String string) {
		strDept = string;
	}

	public void setStrDispatch(String string) {
		strDispatch = string;
	}

	public void setStrPMETHOD(String string) {
		strPMETHOD = string;
	}

	public String getStrPDate() {
		return strPDate;
	}

	public void setStrPDate(String string) {
		strPDate = string;
	}

	public String getSelPSrcGp() {
		return selPSrcGp;
	}

	public void setSelPSrcGp(String string) {
		selPSrcGp = string;
	}

	public java.math.BigDecimal getTPAMT() {
		return tPAMT;
	}

	public void setTPAMT(java.math.BigDecimal decimal) {
		tPAMT = decimal;
	}

	public int getCheckedPayDate() {
		return checkedPayDate;
	}

	public void setCheckedPayDate(int checkedPayDate) {
		this.checkedPayDate = checkedPayDate;
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

	public void setRemitFailDate(int i) {
		RemitFailDate = i;
	}

	public void setRemitFailTime(int i) {
		RemitFailTime = i;
	}

	public void setRemitFailCode(String string) {
		RemitFailCode = string;
	}

	public void setRemitFailDesc(String string) {
		RemitFailDesc = string;
	}

	public void setClaimNumber(String string) {
		ClaimNumber = string;
	}
	
	public void setBankRemitFailDate(int i) {
		BankRemitBackDate = i;
	}

	public String getServicingBranch() {
		return ServicingBranch;
	}

	public void setServicingBranch(String string) {
		ServicingBranch = string;
	}

	public int getAnnuityPayDate() {
		return AnnuityPayDate;
	}

	public void setAnnuityPayDate(int i) {
		AnnuityPayDate = i;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddr1() {
		return addr1;
	}

	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}
	
	public String getAddr2() {
		return addr2;
	}

	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
	
	public String getAddr3() {
		return addr3;
	}

	public void setAddr3(String addr3) {
		this.addr3 = addr3;
	}

	public String getPayBankVerifyNumber() {
		return payBankVerifyNumber;
	}

	public void setPayBankVerifyNumber(String payBankVerifyNumber) {
		this.payBankVerifyNumber = payBankVerifyNumber;
	}

	public String getPayBankSortCode() {
		return payBankSortCode;
	}

	public void setPayBankSortCode(String payBankSortCode) {
		this.payBankSortCode = payBankSortCode;
	}

	public String getPayBankBranch() {
		return payBankBranch;
	}

	public void setPayBankBranch(String payBankBranch) {
		this.payBankBranch = payBankBranch;
	}

	public String getPayBankAddr1() {
		return payBankAddr1;
	}

	public void setPayBankAddr1(String payBankAddr1) {
		this.payBankAddr1 = payBankAddr1;
	}

	public String getPayBankAddr2() {
		return payBankAddr2;
	}

	public void setPayBankAddr2(String payBankAddr2) {
		this.payBankAddr2 = payBankAddr2;
	}

	public String getPayBankAddr3() {
		return payBankAddr3;
	}

	public void setPayBankAddr3(String payBankAddr3) {
		this.payBankAddr3 = payBankAddr3;
	}

	public String getPayRemitBankName() {
		return payRemitBankName;
	}

	public void setPayRemitBankName(String payRemitBankName) {
		this.payRemitBankName = payRemitBankName;
	}	

}