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
 * $EB0194-PB0016-BC255利率變動型即期年金保險專案
 * $
 * $Revision 1.17  2012/05/18 09:47:35  MISSALLY
 * $R10314 CASH系統會計作業修改
 * $
 * $Revision 1.16  2012/03/23 02:48:22  MISSALLY
 * $R10285-P10025
 * $因應犯防專案於支付主檔新增理賠受理編號
 * $
 * $Revision 1.15  2011/06/02 10:28:07  MISSALLY
 * $Q90585 / R90884 / R90989
 * $CASH系統匯退處理作業新增匯退原因欄位並修正退匯明細表
 * $
 * $Revision 1.14  2010/11/23 07:02:28  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.13  2009/08/31 02:00:56  missteven
 * $R90380 新增CASH報表及傳票功能
 * $
 * $Revision 1.12  2008/11/18 02:21:49  MISODIN
 * $R80824
 * $
 * $Revision 1.11  2008/08/21 09:16:49  misvanessa
 * $R80631_新增原始付款方式 (FOR FF)
 * $
 * $Revision 1.10  2008/06/06 03:33:14  misvanessa
 * $R80391_請新增CASH系統信用卡退回
 * $
 * $Revision 1.9  2008/04/30 07:49:35  misvanessa
 * $R80300_收單行轉台新,新增下載檔案及報表
 * $
 * $Revision 1.8  2007/08/03 10:01:39  MISODIN
 * $R70477 外幣保單匯款手續費
 * $
 * $Revision 1.7  2006/11/30 09:11:08  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.6  2006/11/27 04:20:30  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.5  2006/11/24 03:09:05  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.3  2006/09/25 06:38:35  miselsa
 * $R60747付款金額小數點
 * $
 * $Revision 1.2  2006/09/04 09:43:36  miselsa
 * $R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 * $
 * $Revision 1.1  2006/06/29 09:40:13  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.5  2005/08/19 07:10:43  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:26  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

import java.io.Serializable;
import java.math.BigDecimal;

public class DISBPaymentDetailVO implements Serializable {

	private static final long serialVersionUID = -7373815096738637885L;

	/*支付序號 PNO*/
	private String strPNO;

	/*付款方式 PMethod*/
	private String strPMethod;

	/*付款日期 PDate*/
	private int iPDate = 0;

	/*受款人姓名 PName*/
	private String strPName;

	/*原始受款人姓名 PSNAME*/
	private String strPSName;

	/*受款人ID PId*/
	private String strPId;

	/*幣別 PCurr*/
	private String strPCurr;

	/*支付金額 PAMT*/
	private double iPAMT = 0.00;

	/*付款狀態 PStatus*/
	private String strPStatus;

	/*支付確認日一 PCfmDt1*/
	private int iPCfmDt1 = 0;

	/*支付確認時一 PCfmTm1*/
	private int iPCfmTm1 = 0;

	/*支付確認者一 PCfmUsr1*/
	private String strPCfmUsr1;

	public String getStrCQDate() {
		return strCQDate;
	}

	public void setStrCQDate(String strCQDate) {
		this.strCQDate = strCQDate;
	}

	/*支付確認日二 PCfmDt2*/
	private int iPCfmDt2 = 0;

	/*支付確認時二 PCfmTm2*/
	private int iPCfmTm2 = 0;

	/*支付確認者二 PCfmUsr2*/
	private String strPCfmUsr2;

	/*支付描述 PDesc*/
	private String strPDesc;

	/*RC0036 承辦單位 UsrDept*/
	private String strUsrDept;

	/*RC0036 承辦職域 UsrArea*/
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

	/*來源組群 PSrcGp*/
	private String strPSrcGp;

	/*支付原因代碼*/
	private String strPSrcCode;

	/*險種類別 PPLANT*/
	private String strPPlant;

	/*程式代碼 PSrcPgm*/
	private String strPSrcPgm;

	/*作廢否 PVoidable*/
	private String strPVoidable;

	/*急件否 PDispatch*/
	private String strPDispatch;

	/*支付銀行 PBBank*/
	private String strPBBank;

	/*支付帳號 PBAccount*/
	private String strPBAccount;

	/*支票號碼 PCheckNo*/
	private String strPCheckNO;

	/*支票禁背 PChkm1*/
	private String strPChkm1;

	/*支票劃線 PChkm2*/
	private String strPChkm2;

	/*匯款銀行 PRBank*/
	private String strPRBank;

	/*匯款帳號 PRAccount*/
	private String strPRAccount;

	/*信用卡卡號 PCrdNo*/
	private String strPCrdNo;

	/*卡別 PCrdType*/
	private String strPCrdType;

	/*授權碼 PAuthCode*/
	private String strPAuthCode;

	/*有效年月 PCrdEffMY*/
	private String strPCrdEffMY;

	/*保單號碼 PolicyNo*/
	private String strPolicyNo;

	/*要保書號碼 AppNo*/
	private String strAppNo;

	/*單位 Branch*/
	private String strBranch;

	/*匯費 RmtFee*/
	private int iRmtFee = 0;

	/*原始支付序號 PNoH*/
	private String strPNoH;

	/*匯款批號BatNo*/
	private String strBatNo;

	/*出納日期心PCSHDT*/
	private int iPCshDt = 0;

	/*輸入日期 EntryDate*/
	private int iEntryDt = 0;

	/*輸入時間 EntruTime*/
	private int iEntryTm = 0;

	/*輸入人員 EntruUsr*/
	private String strEntryUsr;

	/*輸入程式 EntruPgm*/
	private String strEntryPgm;

	/*異動日期 UpdDt*/
	private int iUpdDt = 0;

	/*異動時間 UpdTm*/
	private int iUpdTm = 0;

	/*異動者 UpdUsr*/
	private String strUpdUsr;

	/* 備註*/
	private String strMemo;

	/* 是否勾選*/
	private boolean isChecked = false;

	/* 是否disable*/
	private boolean isDisabled = false;

	/*授權交易日PAUTHDT*/
	private int iPAuthDt = 0;

	/*匯款序號*/
	private String strBATSEQ;

	/*R60747 出納確認日 PCSHCM*/
	private int iPCSHCM = 0;

	/*R60550 新增6個欄位*/
	/*外幣匯出幣別*/
	private String strPPAYCURR;

	/*外幣匯出金額*/
	private double iPPAYAMT = 0.0000;

	/*外幣匯率*/
	private double iPPAYRATE = 0.0000;

	/*手續費支付方式*/
	private String strPFEEWAY;

	/*註記 S:SPUL*/
	private String strPSYMBOL;

	/*投資起始日*/
	private int iPINVDT = 0;

	/*受款人-英文*/
	private String strPENGNAME;

	/*受款銀行-SWIFTCODE*/
	private String strPSWIFT;

	/*受款銀行-國別*/
	private String strPBKCOTRY;

	/*受款銀行-城市*/
	private String strPBKCITY;

	/*受款銀行-分行*/
	private String strPBKBRCH;

	/*R80631 原始付款方式*/
	private String strPMETHODO;

	/*FOR受款銀行名稱SWBKNAME(CAPSWIFT)*/
	private String SWBKNAME;

	/*FOR退匯手續費金額FPAYAMT(CAPRFEF)*/
	private double FPAYAMT = 0;

	/*FOR退匯手續費支付方式FFEEWAY(CAPRFEF)*/
	private String FFEEWAY = "";

	/*R70477 保單幣別 FOR CAPRMTF*/
	private String strRPCURR;

	/*R80300新增二個欄位 */
	private String strPOrgCrdNo;
	private double iPOrgAMT = 0.00;

	/*R80391新增匯款金額 CAPRMTF*/
	private double iRAMT = 0.00;

	/*R80338 專案碼 */
	private String strProjectCode;
	/*R80338 退件否 */
	private String strRemitBack;
	/*R80338 退件原因 */
	private String strBackRemark;

	/* 退匯日期 REMITFAILD */
	private int RemitFailDate = 0;

	/* 退匯時間 REMITFAILT */
	private int RemitFailTime = 0;

	/* 退匯代碼 REMITFCODE */
	private String RemitFailCode = "";

	/* 退匯原因 REMITFDESC */
	private String RemitFailDesc = "";

	/* 理賠受理編號 PCLMNUM */
	private String ClaimNumber = "";
	
	/* 銀行退匯回存日期 PBNKRFDT */
	private int BankRemitBackDate = 0;

	/* 分公司代碼 SRVBH */
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

	/*R70600  支付金額台幣參考 */
	private double iPAMTNT = 0;
	
	// R00386
	private int checkedPayDate;
	
	//RD0382:OIU,業務所屬公司別
	private String company = "";
	
	//RD0382:OIU,受款人電話
	private String phone = "";
	
	//RD0382:OIU,受款人地址1
	private String addr1 = "";
	
	//RD0382:OIU,受款人地址2
	private String addr2 = "";
		
	//RD0382:OIU,受款人地址3
	private String addr3 = "";
	
	//RD0382:OIU,受款銀行檢核碼
	private String payBankVerifyNumber = "";
	
	//RD0382:OIU,受款銀行SORTCODE
	private String payBankSortCode = "";
	
	//RD0382:OIU,受款銀行分行
	private String payBankBranch = "";		
	
	//RD0382:OIU,受款銀行地址1
	private String payBankAddr1 = "";
	
	//RD0382:OIU,受款銀行地址2
	private String payBankAddr2 = "";
		
	//RD0382:OIU,受款銀行地址3
	private String payBankAddr3 = "";
	
	//RD0382:OIU,匯款銀行名稱
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
	 * @return 理賠受理編號
	 */
	public String getClaimNumber() {
		return ClaimNumber;
	}
	
	/**
	 * @return 銀行退匯回存日期
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
	/**@returnFOR受款銀行名稱SWBKNAME(CAPSWIFT)*/
	public String getSWBKNAME() {
		return SWBKNAME;
	}
	/**@returnFOR退匯手續費(CAPRFEF)*/
	public double getFPAYAMT() {
		return FPAYAMT;
	}
	/**@returnFOR退匯手續費(CAPRFEF)*/
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
	/**@paramFOR受款銀行名稱SWBKNAME(CAPSWIFT)*/
	public void setSWBKNAME(String string) {
		SWBKNAME = string;
	}
	/**@paramFOR退匯手續費(CAPRFEF)*/
	public void setFPAYAMT(double i) {
		FPAYAMT = i;
	}

	/**@paramFOR退匯手續費(CAPRFEF)*/
	public void setFFEEWAY(String string) {
		FFEEWAY = string;
	}

	/**
	 * R70477 保單幣別 FOR CAPRMTF
	 */
	public String getStrRPCURR() {
		return strRPCURR;
	}

	public void setStrRPCURR(String string) {
		strRPCURR = string;
	}

	/**
	 * R80300 新增原刷卡號
	 */
	public String getStrPOrgCrdNo() {
		return strPOrgCrdNo;
	}

	public void setStrPOrgCrdNo(String string) {
		strPOrgCrdNo = string;
	}

	/** R80300 新增原刷金額*/
	public double getIPOrgAMT() {
		return iPOrgAMT;
	}
	public void setIPOrgAMT(double i) {
		iPOrgAMT = i;
	}

	/** R80391 新增匯款金額CAPRMTF*/
	public double getIRAMT() {
		return iRAMT;
	}
	public void setIRAMT(double i) {
		iRAMT = i;
	}

	/**
	 * R80338  專案碼
	 */
	public String getStrProjectCode() {
		return strProjectCode;
	}

	public void setStrProjectCode(String string) {
		strProjectCode = string;
	}

	/**
	 * R80338  退件否
	 */
	public String getStrRemitBack() {
		return strRemitBack;
	}

	public void setStrRemitBack(String string) {
		strRemitBack = string;
	}

	/**
	 * R80338  退件原因
	 */
	public String getStrBackRemark() {
		return strBackRemark;
	}

	public void setStrBackRemark(String string) {
		strBackRemark = string;
	}

	/**
	 * R70600  支付金額台幣參考
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
	 * @return 退匯日期
	 */
	public int getRemitFailDate() {
		return RemitFailDate;
	}

	/**
	 * @return 退匯時間
	 */
	public int getRemitFailTime() {
		return RemitFailTime;
	}

	/**
	 * @return 退匯代碼
	 */
	public String getRemitFailCode() {
		return RemitFailCode;
	}

	/**
	 * @return 退匯原因
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