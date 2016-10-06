package com.aegon.disb.disbremit;

import java.sql.ResultSet;

import com.aegon.comlib.CommonUtil;

public class CaprmtfVO implements java.io.Serializable {

	
	/*批號 BATNO*/
	private String BATNO = "";

	/*序號 SEQNO*/
	private String SEQNO = "";

	/*付款銀行 RBK*/
	private String PBK = "";
		
	/*付款帳號 RACCT*/
	private String PACCT = "";

	/*收款人ID RID*/
	private String RID = "";
	
	/*匯款類別 RTYPE*/
	private String RTYPE = "";
	
	/*匯款行 RBK*/
	private String RBK = "";
		
	/*匯款帳號 RACCT*/
	private String RACCT = "";
	
	/*支付金額 RAMT*/
    private double RAMT = 0;

	/*RC0036-3 RAMTS*/
    private String RAMTS = "";
    
	/*戶名 RNAME*/
	private String RNAME = "";
	
	/*附言 RMEMO*/
	private String RMEMO = "";
	
	/*匯款日期 RMTDT */
	private String RMTDT = "";
	
	/*交易檢核碼 RTRNCDE*/
	private String RTRNCDE ="";
	
	/*傳送次數 RTRNTM*/
	private String RTRNTM = "";
	
	/*客戶傳票號碼 CSTNO*/
	private String CSTNO = "";
	
	/*匯費負擔碼 RMTCDE*/
	private String RMTCDE = "";
	
	/*匯費 RMTFEE*/
	private int RMTFEE = 0;

	/*輸入日期 ENTRYDT*/
	private int ENTRYDT = 0;
	
	/*輸入時間*/
	private int ENTRYTM = 0;
	
	/*輸入人員 ENTRYUSR*/
	private String ENTRYUSR = "";
	
	/*備註 MEMO*/
	private String MEMO = "";
	
	/* R60550	CAPRMTF 擴檔6個欄位*/
	/*外幣匯出金額 RPAYAMT*/
	private double RPAYAMT = 0;
	
	/*外幣匯出幣別 RPAYCURR*/
	private String RPAYCURR = "";
	
	/*後收手續費幣別 RPAYMIDCUR*/
	private String RPAYMIDCUR = "";
	
	/*後收手續費 RPAYMIDFEE*/
	private double RPAYMIDFEE = 0;
	
	/*後收手續費日期 RPAYMIDDT*/
	private int RPAYMIDDT = 0;
	
	/*手續費支付方式 RPAYFEEWAY*/
	private String RPAYFEEWAY = "";
	
	/*R60550 FOR CAPSWIFT外國銀行代碼 SWIFTCODE*/
	private String SWIFTCODE = "";

	/*FOR CAPSWIFT外國銀行名稱 SWBKNAME*/
	private String SWBKNAME = "";

	/*FOR CAPSWIFT外國銀行住址 SWBKADDR*/
	/* RA0074 替換ORCHSWFT檔 不存在銀行地址欄位
	private String SWBKADDR = "";*/

	/*FOR CAPPAYF外國姓名 PENGNAME*/
	private String PENGNAME = "";
	
	/*城市(英文) RBKCITY*/
	private String RBKCITY = "";
	
	/*分行(英文) RBKBRCH*/
	private String RBKBRCH = "";
	
	/*國別 RBKCOUNTRY*/
	private String RBKCOUNTRY = "";
	
	/*客戶負擔手續費 RBENFEE R70088*/
	private double RBENFEE = 0;

	/*外幣匯率 RPAYRATE R70088*/
	private double RPAYRATE = 0;	

	/*保單幣別 RPCURR*/
	private String RPCURR = "";
	
	/*RC0036 承辦單位 Dept*/
	private String DEPT;
	
	//RD0382:OIU,受款人地址
	private String payAddr = "";
	
	//RD0382:OIU,受款銀行檢核碼
	private String payBkVerifyNumber = "";	
	
	//RD0382:OIU,受款銀行SORTCODE
	private String payBkSortCode = "";
	
	//RD0382:OIU,CAPPAYF的PAY_SOURCE_CODE
	private String paySourceCode = "";

	public String getPaySourceCode() {
		return paySourceCode;
	}

	public void setPaySourceCode(String paySourceCode) {
		this.paySourceCode = paySourceCode;
	}

	//RD0382:OIU,受款人地址
	public String getPayAddr() {
		return payAddr;
	}

	//RD0382:OIU,受款人地址
	public void setPayAddr(String payAddr) {
		this.payAddr = payAddr;
	}
	
	//RD0382:OIU,受款銀行檢核碼
	public String getPayBkVerifyNumber() {
		return payBkVerifyNumber;
	}

	//RD0382:OIU,受款銀行檢核碼
	public void setPayBkVerifyNumber(String payBkVerifyNumber) {
		this.payBkVerifyNumber = payBkVerifyNumber;
	}
	
	//RD0382:OIU,受款銀行SORTCODE
	public String getPayBkSortCode() {
		return payBkSortCode;
	}

	//RD0382:OIU,受款銀行SORTCODE
	public void setPayBkSortCode(String payBkSortCode) {
		this.payBkSortCode = payBkSortCode;
	}

	public CaprmtfVO(ResultSet rs) {
		setResultSet(rs);
	}

	public CaprmtfVO() {
	}

	public String getBATNO() {
		return BATNO;
	}

	public String getSEQNO() {
		return SEQNO;
	}

	public String getPBK() {
		return PBK;
	}

	public String getPACCT() {
		return PACCT;
	}

	public String getRID() {
		return RID;
	}

	public String getRTYPE() {
		return RTYPE;
	}

	public String getRBK() {
		return RBK;
	}

	public String getRACCT() {
		return RACCT;
	}

	public double getRAMT() {
    	return RAMT;
	}
	//RC0036-3
	public String getRAMTS() {
    	return RAMTS;
	}

	public String getRNAME() {
		return RNAME;
	}

	public String getRMEMO() {
		return RMEMO;
	}

	public String getRMTDT() {
		return RMTDT;
	}

	public String getRTRNCDE() {
		return RTRNCDE;
	}

	public String getRTRNTM() {
		return RTRNTM;
	}

	public String getCSTNO() {
		return CSTNO;
	}

	public String getRMTCDE() {
		return RMTCDE;
	}

	public int getRMTFEE() {
		return RMTFEE;
	}

	public int getENTRYDT() {
		return ENTRYDT;
	}

	public int getENTRYTM() {
		return ENTRYTM;
	}

	public String getENTRYUSR() {
		return ENTRYUSR;
	}

	public String getMEMO() {
		return MEMO;
	}

	public double getRPAYAMT() {
		return RPAYAMT;
	}

	public String getRPAYCURR() {
		return RPAYCURR;
	}

	public String getRPAYMIDCUR() {
		return RPAYMIDCUR;
	}

	public double getRPAYMIDFEE() {
		return RPAYMIDFEE;
	}

	public int getRPAYMIDDT() {
		return RPAYMIDDT;
	}

	public String getRPAYFEEWAY() {
		return RPAYFEEWAY;
	}

	public String getSWIFTCODE() {
		return SWIFTCODE;
	}

	public String getSWBKNAME() {
		return SWBKNAME;
	}

	/* RA0074 替換ORCHSWFT檔 不存在銀行地址欄位
	public String getSWBKADDR() {
		return SWBKADDR;
	}
	 */

	public String getPENGNAME() {
		return CommonUtil.AllTrim(PENGNAME);
	}

	public double getRBENFEE() {
		return RBENFEE;
	}	

	public double getRPAYRATE() {
		return RPAYRATE;
	}

	public String getRPCURR() {
		return RPCURR;
	}
	
	//RC0036
	public String getUsrDept() {
		return DEPT;
	}

	public void setBATNO(String string) {
		BATNO = string;
	}

	public void setSEQNO(String string) {
		SEQNO = string;
	}

	public void setPBK(String string) {
		PBK = string;
	}

	public void setPACCT(String string) {
		PACCT = string;
	}

	public void setRID(String string) {
		RID = string;
	}

	public void setRTYPE(String string) {
		RTYPE = string;
	}

	public void setRBK(String string) {
		RBK = string;
	}

	public void setRACCT(String string) {
		RACCT = string;
	}

	public void setRAMT(double i) {
		RAMT = i;
	}
    //RC0036-3
	public void setRAMTS(String string) {
		RAMTS = string;
	}
	public void setRNAME(String string) {
		RNAME = string;
	}

	public void setRMEMO(String string) {
		RMEMO = string;
	}

	public void setRMTDT(String string) {
		RMTDT = string;
	}

	public void setRTRNCDE(String string) {
		RTRNCDE = string;
	}

	public void setRTRNTM(String string) {
		RTRNTM = string;
	}

	public void setCSTNO(String string) {
		CSTNO = string;
	}

	public void setRMTCDE(String string) {
		RMTCDE = string;
	}

	public void setRMTFEE(int i) {
		RMTFEE = i;
	}

	public void setENTRYDT(int i) {
		ENTRYDT = i;
	}

	public void setENTRYTM(int i) {
		ENTRYTM = i;
	}

	public void setENTRYUSR(String string) {
		ENTRYUSR = string;
	}

	public void setMEMO(String string) {
		MEMO = string;
	}
 
	public void setRPAYAMT(double i) {
		RPAYAMT = i;
	}

	public void setRPAYCURR(String string) {
		RPAYCURR = string;
	}

	public void setRPAYMIDCUR(String string) {
		RPAYMIDCUR = string;
	}

	public void setRPAYMIDFEE(double i) {
		RPAYMIDFEE = i;
	}

	public void setRPAYMIDDT(int i) {
		RPAYMIDDT = i;
	}

	public void setRPAYFEEWAY(String string) {
		RPAYFEEWAY = string;
	}

	public void setSWIFTCODE(String string) {
		SWIFTCODE = string;
	}

	public void setSWBKNAME(String string) {
		SWBKNAME = string;
	}

	/* RA0074 替換ORCHSWFT檔 不存在銀行地址欄位
	public void setSWBKADDR(String string) {
		SWBKADDR = string;
	}*/

	public void setPENGNAME(String string) {
		PENGNAME = CommonUtil.AllTrim(string);
	}

	public void setRBENFEE(double i) {
		RBENFEE = i;
	}

	public void setRPAYRATE(double i) {
		RPAYRATE = i;
	}

	public void setRPCURR(String string) {
		RPCURR = string;
	}

	//RC0036
	public void setDept(String string) {
		DEPT = string;
	}
	
	public void setResultSet(ResultSet rs) {
		try{ this.BATNO = rs.getString("BATNO"); }catch(Exception e){}
		try{ this.SEQNO = rs.getString("SEQNO"); }catch(Exception e){}
		try{ this.PBK = rs.getString("PBK"); }catch(Exception e){}
		try{ this.PACCT = rs.getString("PACCT"); }catch(Exception e){}
		try{ this.RID = rs.getString("RID"); }catch(Exception e){}
		try{ this.RTYPE = rs.getString("RTYPE"); }catch(Exception e){}
		try{ this.RBK = rs.getString("RBK"); }catch(Exception e){}
		try{ this.RACCT = rs.getString("RACCT"); }catch(Exception e){}
		try{ this.RAMT = rs.getInt("RAMT"); }catch(Exception e){}
		try{ this.RAMTS = rs.getString("RAMT"); }catch(Exception e){}//RC0036-3
		try{ this.RNAME = rs.getString("RNAME"); }catch(Exception e){}
		try{ this.RMEMO = rs.getString("RMEMO"); }catch(Exception e){}
		try{ this.RMTDT = rs.getString("RMTDT"); }catch(Exception e){}
		try{ this.RTRNCDE = rs.getString("RTRNCDE"); }catch(Exception e){}
		try{ this.RTRNTM = rs.getString("RTRNTM"); }catch(Exception e){}
		try{ this.CSTNO = rs.getString("CSTNO"); }catch(Exception e){}
		try{ this.RMTCDE = rs.getString("RMTCDE"); }catch(Exception e){}
		try{ this.RMTFEE = rs.getInt("RMTFEE"); }catch(Exception e){}
		try{ this.ENTRYDT = rs.getInt("ENTRYDT"); }catch(Exception e){}
		try{ this.ENTRYTM = rs.getInt("ENTRYTM"); }catch(Exception e){}
		try{ this.ENTRYUSR = rs.getString("ENTRYUSR"); }catch(Exception e){}
		try{ this.MEMO = rs.getString("MEMO"); }catch(Exception e){}
		/*R60550 CAPRMTF 擴檔6個欄位*/
		try{ this.RPAYAMT = rs.getDouble("RPAYAMT"); }catch(Exception e){}
		try{ this.RPAYCURR = rs.getString("RPAYCURR"); }catch(Exception e){}
		try{ this.RPAYMIDCUR = rs.getString("RPAYMIDCUR"); }catch(Exception e){}
		try{ this.RPAYMIDFEE = rs.getDouble("RPAYMIDFEE"); }catch(Exception e){}
		try{ this.RPAYMIDDT = rs.getInt("RPAYMIDDT"); }catch(Exception e){}
		try{ this.RPAYFEEWAY = rs.getString("RPAYFEEWAY"); }catch(Exception e){}
		/*R60550 CAPSWIFT 外國帳號資料*/
		try{ this.SWIFTCODE = rs.getString("SWIFTCODE"); }catch(Exception e){}
		try{ this.SWBKNAME = rs.getString("SWBKNAME"); }catch(Exception e){}
		/* RA0074 替換ORCHSWFT檔 不存在銀行地址欄位
		try{ this.SWBKADDR = rs.getString("SWBKADDR"); }catch(Exception e){} */
		try{ this.PENGNAME = CommonUtil.AllTrim(rs.getString("PENGNAME")); }catch(Exception e){}
		try{ this.RBENFEE = rs.getDouble("RBENFEE"); }catch(Exception e){}
		try{ this.RPAYRATE = rs.getDouble("RPAYRATE"); }catch(Exception e){}
		// R70477 保單幣別
		try{ this.RPCURR = rs.getString("RPCURR"); }catch(Exception e){}
		// RC0036 承辦單位
		try{ this.DEPT = rs.getString("DEPT"); }catch(Exception e){}
	}

	public String getRBKBRCH() {
		return RBKBRCH;
	}

	public String getRBKCITY() {
		return RBKCITY;
	}

	public void setRBKBRCH(String string) {
		RBKBRCH = string;
	}

	public void setRBKCITY(String string) {
		RBKCITY = string;
	}

	public String getRBKCOUNTRY() {
		return RBKCOUNTRY;
	}

	public void setRBKCOUNTRY(String string) {
		RBKCOUNTRY = string;
	}

}