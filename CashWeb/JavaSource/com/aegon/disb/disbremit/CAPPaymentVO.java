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
 * $R10314 CASH系統會計作業修改
 * $
 * $Revision 1.8  2012/03/23 02:48:23  MISSALLY
 * $R10285-P10025
 * $因應犯防專案於支付主檔新增理賠受理編號
 * $
 * $Revision 1.7  2011/06/02 10:28:09  MISSALLY
 * $Q90585 / R90884 / R90989
 * $CASH系統匯退處理作業新增匯退原因欄位並修正退匯明細表
 * $
 * $Revision 1.6  2007/01/05 07:29:08  MISVANESSA
 * $R60550_抓取方式修改
 * $
 * $Revision 1.5  2006/12/07 11:20:56  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.4  2006/11/30 09:16:45  miselsa
 * $R60463及R60550外幣及SPUL保單
 * $
 * $Revision 1.3  2006/11/24 07:37:17  miselsa
 * $R60550_新增國外匯款相關欄位
 * $
 * $Revision 1.2  2006/11/24 05:40:57  miselsa
 * $R60550_新增國外匯款相關欄位
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.3  2005/08/19 06:53:51  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併
 * $
 * $Revision 1.1.2.2  2005/04/04 07:02:26  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

import java.io.Serializable;
import java.sql.ResultSet;

import com.aegon.disb.disbcheck.CAPCheckVO;

public class CAPPaymentVO implements Serializable {

	private static final long serialVersionUID = 4034487021933127531L;

	/*支付序號 PNO*/
	private String PNO = "";

	/*付款方式 PMethod*/
	private String PMethod = "";

	/*付款日期 PDate*/
	private int PDate = 0;

	/*受款人姓名 PName*/
	private String PName = "";

	/*原始受款人姓名 PSNAME*/
	private String PSName = "";

	/*受款人ID PId*/
	private String PId = "";

	/*幣別 PCurr*/
	private String PCurr = "";

	/*支付金額 PAMT*/
	private int PAMT = 0;

	/*付款狀態 PStatus*/
	private String PStatus = "";

	/*支付確認日一 PCfmDt1*/
	private int PCfmDt1 = 0;

	/*支付確認時一 PCfmTm1*/
	private int PCfmTm1 = 0;

	/*支付確認者一 PCfmUsr1*/
	private String PCfmUsr1;

	/*支付確認日二 PCfmDt2*/
	private int PCfmDt2 = 0;

	/*支付確認時二 PCfmTm2*/
	private int PCfmTm2 = 0;

	/*支付確認者二 PCfmUsr2*/
	private String PCfmUsr2;

	/*支付描述 PDesc*/
	private String PDesc = "";

	/*來源組群 PSrcGp*/
	private String PSrcGp = "";

	/*支付原因代碼*/
	private String PSrcCode = "";

	/*險種類別 PPLANT*/
	private String PPLANT = "";

	/*程式代碼 PSrcPgm*/
	private String PSrcPgm = "";

	/*作廢否 PVoidable*/
	private String PVoidable = "";

	/*急件否 PDispatch*/
	private String PDispatch = "";

	/*支付銀行 PBBank*/
	private String PBBank = "";

	/*支付帳號 PBAccount*/
	private String PBAccount = "";

	/*支票號碼 PCheckNo*/
	private String PCheckNO = "";

	/*支票禁背 PChkm1*/
	private String PChkm1 = "";

	/*支票劃線 PChkm2*/
	private String PChkm2 = "";

	/*匯款銀行 PRBank*/
	private String PRBank = "";

	/*匯款帳號 PRAccount*/
	private String PRAccount = "";

	/*信用卡卡號 PCrdNo*/
	private String PCrdNo = "";

	/*卡別 PCrdType*/
	private String PCrdType = "";

	/*授權碼 PAuthCode*/
	private String PAuthCode = "";

	/*有效年月 PCrdEffMY*/
	private String PCrdEffMY = "";

	/*保單號碼 PolicyNo*/
	private String PolicyNo = "";

	/*要保書號碼 AppNo*/
	private String AppNo = "";

	/*單位 Branch*/
	private String Branch = "";

	/*匯費 RmtFee*/
	private int RmtFee = 0;

	/*原始支付序號 PNoH*/
	private String PNoH = "";

	/*匯款批號BatNo*/
	private String BatNo = "";

	/*出納日期PCSHDT*/
	private int PCshDt = 0;

	/*輸入日期 EntryDate*/
	private int EntryDt = 0;

	/*輸入時間 EntruTime*/
	private int EntryTm = 0;

	/*輸入人員 EntruUsr*/
	private String EntryUsr = "";

	/*輸入程式 EntruPgm*/
	private String EntryPgm = "";

	/*異動日期 UpdDt*/
	private int UpdDt = 0;

	/*異動時間 UpdTm*/
	private int UpdTm = 0;

	/*異動者 UpdUsr*/
	private String UpdUsr = "";

	/* 備註*/
	private String Memo = "";

	/*匯款序號*/
	private String BatSeq = "";

	/*出納確認日 PCSHCM*/
	private String PCSHCM = "";

	/*外幣匯出幣別 PPAYCURR*/
	private String PPAYCURR = "";

	/*外幣匯出金額 PPAYAMT*/
	private double PPAYAMT = 0;

	/*外幣匯率 PPAYRATE*/
	private String PPAYRATE = "";

	/*手續費支付方式 PFEEWAY*/
	private String PFEEWAY = "";

	/*投資起始日 PINVDT*/
	private int PINVDT = 0;

	/*SWIFTCODE  PSWIFT*/
	private String PSWIFT = "";

	/*受款銀行國別 PBKCOTRY*/
	private String PBKCOTRY = "";

	/*受款銀行城市 PBKCITY*/
	private String PBKCITY = "";

	/*受款銀行分行 PBKBRCH*/
	private String PBKBRCH = "";

	/*受款人－英文 PENGNAME*/
	private String PENGNAME = "";

	/*銀行名稱PBKNAME*/
	private String PBKNAME = "";

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

	private CAPCheckVO paymentCheck = null;

	public CAPPaymentVO(ResultSet rs) {
		setResultSet(rs);
	}
	public CAPPaymentVO() {
	}

	/**
	 * @return 要保書號碼
	 */
	public String getAppNo() {
		return AppNo;
	}

	/**
	 * @return 匯款批號
	 */
	public String getBatNo() {
		return BatNo;
	}

	/**
	 * @return 單位
	 */
	public String getBranch() {
		return Branch;
	}

	/**
	 * @return 輸入日期
	 */
	public int getEntryDt() {
		return EntryDt;
	}

	/**
	 * @return 輸入程式
	 */
	public String getEntryPgm() {
		return EntryPgm;
	}

	/**
	 * @return 輸入時間
	 */
	public int getEntryTm() {
		return EntryTm;
	}

	/**
	 * @return 輸入人員
	 */
	public String getEntryUsr() {
		return EntryUsr;
	}

	/**
	 * @return 備註
	 */
	public String getMemo() {
		return Memo;
	}

	/**
	 * @return 匯款序號
	 */
	public String getBatSeq() {
		return BatSeq;
	}

	/**
	 * @return 支付金額
	 */
	public int getPAMT() {
		return PAMT;
	}

	/**
	 * @return 授權碼
	 */
	public String getPAuthCode() {
		return PAuthCode;
	}

	/**
	 * @return 支付確認日一
	 */
	public int getPCfmDt1() {
		return PCfmDt1;
	}

	/**
	 * @return 支付確認日二
	 */
	public int getPCfmDt2() {
		return PCfmDt2;
	}

	/**
	 * @return 支付確認時一
	 */
	public int getPCfmTm1() {
		return PCfmTm1;
	}

	/**
	 * @return 支付確認時二
	 */
	public int getPCfmTm2() {
		return PCfmTm2;
	}

	/**
	 * @return 支付確認者一
	 */
	public String getPCfmUsr1() {
		return PCfmUsr1;
	}

	/**
	 * @return 支付確認者二
	 */
	public String getPCfmUsr2() {
		return PCfmUsr2;
	}

	/**
	 * @return 支票號碼
	 */
	public String getPCheckNO() {
		return PCheckNO;
	}

	/**
	 * @return 支票禁背
	 */
	public String getPChkm1() {
		return PChkm1;
	}

	/**
	 * @return 支票劃線
	 */
	public String getPChkm2() {
		return PChkm2;
	}

	/**
	 * @return 有效年月
	 */
	public String getPCrdEffMY() {
		return PCrdEffMY;
	}

	/**
	 * @return 信用卡卡號
	 */
	public String getPCrdNo() {
		return PCrdNo;
	}

	/**
	 * @return 卡別
	 */
	public String getPCrdType() {
		return PCrdType;
	}

	/**
	 * @return 出納日期
	 */
	public int getPCshDt() {
		return PCshDt;
	}

	/**
	 * @return 幣別
	 */
	public String getPCurr() {
		return PCurr;
	}

	/**
	 * @return 付款日期
	 */
	public int getPDate() {
		return PDate;
	}

	/**
	 * @return 支付描述
	 */
	public String getPDesc() {
		return PDesc;
	}

	/**
	 * @return 急件否
	 */
	public String getPDispatch() {
		return PDispatch;
	}

	/**
	 * @return 受款人ID
	 */
	public String getPId() {
		return PId;
	}

	/**
	 * @return 付款方式
	 */
	public String getPMethod() {
		return PMethod;
	}

	/**
	 * @return 受款人姓名
	 */
	public String getPName() {
		return PName;
	}

	/**
	 * @return 支付序號
	 */
	public String getPNO() {
		return PNO;
	}

	/**
	 * @return 原始支付序號
	 */
	public String getPNoH() {
		return PNoH;
	}

	/**
	 * @return 保單號碼
	 */
	public String getPolicyNo() {
		return PolicyNo;
	}

	/**
	 * @return 險種類別
	 */
	public String getPPLANT() {
		return PPLANT;
	}

	/**
	 * @return 匯款帳號
	 */
	public String getPRAccount() {
		return PRAccount;
	}

	/**
	 * @return 匯款銀行
	 */
	public String getPRBank() {
		return PRBank;
	}

	/**
	 * @return 原始受款人姓名
	 */
	public String getPSName() {
		return PSName;
	}

	/**
	 * @return 支付原因代碼
	 */
	public String getPSrcCode() {
		return PSrcCode;
	}

	/**
	 * @return 來源組群
	 */
	public String getPSrcGp() {
		return PSrcGp;
	}

	/**
	 * @return 程式代碼
	 */
	public String getPSrcPgm() {
		return PSrcPgm;
	}

	/**
	 * @return 付款狀態
	 */
	public String getPStatus() {
		return PStatus;
	}

	/**
	 * @return 作廢否
	 */
	public String getPVoidable() {
		return PVoidable;
	}

	/**
	 * @return 匯費
	 */
	public int getRmtFee() {
		return RmtFee;
	}

	/**
	 * @return 支付帳號
	 */
	public String getPBAccount() {
		return PBAccount;
	}

	/**
	 * @return 支付銀行
	 */
	public String getPBBank() {
		return PBBank;
	}

	/**
	 * @return 異動日期
	 */
	public int getUpdDt() {
		return UpdDt;
	}

	/**
	 * @return 異動時間
	 */
	public int getUpdTm() {
		return UpdTm;
	}

	/**
	 * @return 異動者
	 */
	public String getUpdUsr() {
		return UpdUsr;
	}

	/**
	 * @return 手續費支付方式
	 */
	public String getPFEEWAY() {
		return PFEEWAY;
	}

	/**
	 * @return 投資起始日
	 */
	public int getPINVDT() {
		return PINVDT;
	}

	/**
	 * @return 外幣匯出金額
	 */
	public double getPPAYAMT() {
		return PPAYAMT;
	}

	/**
	 * @return 外幣匯出幣別
	 */
	public String getPPAYCURR() {
		return PPAYCURR;
	}

	/**
	 * @return 外幣匯率
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
	 * @return 受款銀行分行
	 */
	public String getPBKBRCH() {
		return PBKBRCH;
	}

	/**
	 * @return 受款銀行城市
	 */
	public String getPBKCITY() {
		return PBKCITY;
	}

	/**
	 * @return 受款銀行國別
	 */
	public String getPBKCOTRY() {
		return PBKCOTRY;
	}

	/**
	 * @return 受款人－英文
	 */
	public String getPENGNAME() {
		return PENGNAME;
	}
	/**
	 * @return 銀行名稱
	 */
	public String getPBKNAME() {
		return PBKNAME;
	}

	/**
	 * @return 出納確認日
	 */
	public String getPCSHCM() {
		return PCSHCM;
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