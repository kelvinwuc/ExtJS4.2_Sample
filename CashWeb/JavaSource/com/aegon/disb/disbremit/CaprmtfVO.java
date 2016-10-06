package com.aegon.disb.disbremit;

import java.sql.ResultSet;

import com.aegon.comlib.CommonUtil;

public class CaprmtfVO implements java.io.Serializable {

	
	/*�帹 BATNO*/
	private String BATNO = "";

	/*�Ǹ� SEQNO*/
	private String SEQNO = "";

	/*�I�ڻȦ� RBK*/
	private String PBK = "";
		
	/*�I�ڱb�� RACCT*/
	private String PACCT = "";

	/*���ڤHID RID*/
	private String RID = "";
	
	/*�״����O RTYPE*/
	private String RTYPE = "";
	
	/*�״ڦ� RBK*/
	private String RBK = "";
		
	/*�״ڱb�� RACCT*/
	private String RACCT = "";
	
	/*��I���B RAMT*/
    private double RAMT = 0;

	/*RC0036-3 RAMTS*/
    private String RAMTS = "";
    
	/*��W RNAME*/
	private String RNAME = "";
	
	/*���� RMEMO*/
	private String RMEMO = "";
	
	/*�״ڤ�� RMTDT */
	private String RMTDT = "";
	
	/*����ˮֽX RTRNCDE*/
	private String RTRNCDE ="";
	
	/*�ǰe���� RTRNTM*/
	private String RTRNTM = "";
	
	/*�Ȥ�ǲ����X CSTNO*/
	private String CSTNO = "";
	
	/*�׶O�t��X RMTCDE*/
	private String RMTCDE = "";
	
	/*�׶O RMTFEE*/
	private int RMTFEE = 0;

	/*��J��� ENTRYDT*/
	private int ENTRYDT = 0;
	
	/*��J�ɶ�*/
	private int ENTRYTM = 0;
	
	/*��J�H�� ENTRYUSR*/
	private String ENTRYUSR = "";
	
	/*�Ƶ� MEMO*/
	private String MEMO = "";
	
	/* R60550	CAPRMTF �X��6�����*/
	/*�~���ץX���B RPAYAMT*/
	private double RPAYAMT = 0;
	
	/*�~���ץX���O RPAYCURR*/
	private String RPAYCURR = "";
	
	/*�᦬����O���O RPAYMIDCUR*/
	private String RPAYMIDCUR = "";
	
	/*�᦬����O RPAYMIDFEE*/
	private double RPAYMIDFEE = 0;
	
	/*�᦬����O��� RPAYMIDDT*/
	private int RPAYMIDDT = 0;
	
	/*����O��I�覡 RPAYFEEWAY*/
	private String RPAYFEEWAY = "";
	
	/*R60550 FOR CAPSWIFT�~��Ȧ�N�X SWIFTCODE*/
	private String SWIFTCODE = "";

	/*FOR CAPSWIFT�~��Ȧ�W�� SWBKNAME*/
	private String SWBKNAME = "";

	/*FOR CAPSWIFT�~��Ȧ��} SWBKADDR*/
	/* RA0074 ����ORCHSWFT�� ���s�b�Ȧ�a�}���
	private String SWBKADDR = "";*/

	/*FOR CAPPAYF�~��m�W PENGNAME*/
	private String PENGNAME = "";
	
	/*����(�^��) RBKCITY*/
	private String RBKCITY = "";
	
	/*����(�^��) RBKBRCH*/
	private String RBKBRCH = "";
	
	/*��O RBKCOUNTRY*/
	private String RBKCOUNTRY = "";
	
	/*�Ȥ�t�����O RBENFEE R70088*/
	private double RBENFEE = 0;

	/*�~���ײv RPAYRATE R70088*/
	private double RPAYRATE = 0;	

	/*�O����O RPCURR*/
	private String RPCURR = "";
	
	/*RC0036 �ӿ��� Dept*/
	private String DEPT;
	
	//RD0382:OIU,���ڤH�a�}
	private String payAddr = "";
	
	//RD0382:OIU,���ڻȦ��ˮֽX
	private String payBkVerifyNumber = "";	
	
	//RD0382:OIU,���ڻȦ�SORTCODE
	private String payBkSortCode = "";
	
	//RD0382:OIU,CAPPAYF��PAY_SOURCE_CODE
	private String paySourceCode = "";

	public String getPaySourceCode() {
		return paySourceCode;
	}

	public void setPaySourceCode(String paySourceCode) {
		this.paySourceCode = paySourceCode;
	}

	//RD0382:OIU,���ڤH�a�}
	public String getPayAddr() {
		return payAddr;
	}

	//RD0382:OIU,���ڤH�a�}
	public void setPayAddr(String payAddr) {
		this.payAddr = payAddr;
	}
	
	//RD0382:OIU,���ڻȦ��ˮֽX
	public String getPayBkVerifyNumber() {
		return payBkVerifyNumber;
	}

	//RD0382:OIU,���ڻȦ��ˮֽX
	public void setPayBkVerifyNumber(String payBkVerifyNumber) {
		this.payBkVerifyNumber = payBkVerifyNumber;
	}
	
	//RD0382:OIU,���ڻȦ�SORTCODE
	public String getPayBkSortCode() {
		return payBkSortCode;
	}

	//RD0382:OIU,���ڻȦ�SORTCODE
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

	/* RA0074 ����ORCHSWFT�� ���s�b�Ȧ�a�}���
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

	/* RA0074 ����ORCHSWFT�� ���s�b�Ȧ�a�}���
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
		/*R60550 CAPRMTF �X��6�����*/
		try{ this.RPAYAMT = rs.getDouble("RPAYAMT"); }catch(Exception e){}
		try{ this.RPAYCURR = rs.getString("RPAYCURR"); }catch(Exception e){}
		try{ this.RPAYMIDCUR = rs.getString("RPAYMIDCUR"); }catch(Exception e){}
		try{ this.RPAYMIDFEE = rs.getDouble("RPAYMIDFEE"); }catch(Exception e){}
		try{ this.RPAYMIDDT = rs.getInt("RPAYMIDDT"); }catch(Exception e){}
		try{ this.RPAYFEEWAY = rs.getString("RPAYFEEWAY"); }catch(Exception e){}
		/*R60550 CAPSWIFT �~��b�����*/
		try{ this.SWIFTCODE = rs.getString("SWIFTCODE"); }catch(Exception e){}
		try{ this.SWBKNAME = rs.getString("SWBKNAME"); }catch(Exception e){}
		/* RA0074 ����ORCHSWFT�� ���s�b�Ȧ�a�}���
		try{ this.SWBKADDR = rs.getString("SWBKADDR"); }catch(Exception e){} */
		try{ this.PENGNAME = CommonUtil.AllTrim(rs.getString("PENGNAME")); }catch(Exception e){}
		try{ this.RBENFEE = rs.getDouble("RBENFEE"); }catch(Exception e){}
		try{ this.RPAYRATE = rs.getDouble("RPAYRATE"); }catch(Exception e){}
		// R70477 �O����O
		try{ this.RPCURR = rs.getString("RPCURR"); }catch(Exception e){}
		// RC0036 �ӿ���
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