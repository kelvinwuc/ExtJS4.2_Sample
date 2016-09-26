package com.aegon.disb.disbremit;

/**
 * System   :
 * 
 * Function : 出納功能-整批匯款
 * 
 * Remark   : DAO
 * 
 * Revision : $$Revision: 1.27 $$
 * 
 * Author   : Vicky Hsu
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBRemitDisposeDAO.java,v $
 * $Revision 1.27  2014/08/25 01:51:48  missteven
 * $RC0036-3
 * $
 * $Revision 1.26  2014/08/05 03:05:58  missteven
 * $RC0036
 * $
 * $Revision 1.24  2014/01/07 04:09:41  MISSALLY
 * $BugFix---remove connection導致資料錯誤!!
 * $
 * $Revision 1.23  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $
 * $Revision 1.22  2013/05/02 11:07:05  MISSALLY
 * $R10190 美元失效保單作業
 * $
 * $Revision 1.21  2013/01/08 04:24:03  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.20.4.1  2012/08/31 01:21:30  MISSALLY
 * $RA0140---新增兆豐為外幣指定行
 * $
 * $Revision 1.20  2011/11/08 09:16:38  MISSALLY
 * $Q10312
 * $匯款功能-整批匯款作業
 * $1.修正銀行帳號不一致
 * $2.調整兆豐匯款檔
 * $
 * $Revision 1.19  2011/06/07 07:22:24  MISJIMMY
 * $Q10107-請復原中信匯款檔備註欄位格式
 * $
 * $Revision 1.18  2011/05/12 06:08:39  MISJIMMY
 * $R00440 SN滿期金
 * $
 * $Revision 1.17  2010/11/23 06:59:53  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.16  2010/11/18 12:23:23  MISJIMMY
 * $R00386 美元保單
 * $
 * $Revision 1.15  2010/05/04 07:10:39  missteven
 * $R90735
 * $
 * $Revision 1.14  2008/08/06 06:52:37  MISODIN
 * $R80338 調整CASH系統 for 出納外幣一對一需求
 * $
 * $Revision 1.13  2007/09/07 10:24:17  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.12  2007/08/03 09:56:22  MISODIN
 * $R70477 外幣保單匯款手續費
 * $
 * $Revision 1.11  2007/03/16 01:53:27  MISVANESSA
 * $R70088_SPUL配息修改手續費rule
 * $
 * $Revision 1.10  2007/03/06 01:38:54  MISVANESSA
 * $R70088_SPUL配息新增客戶負擔手續費
 * $
 * $Revision 1.9  2007/01/31 04:02:19  MISVANESSA
 * $R70088_SPUL配息
 * $
 * $Revision 1.8  2007/01/05 01:46:03  miselsa
 * $R60550_外幣匯款件始須特別篩選是否為SPUL
 * $
 * $Revision 1.7  2007/01/03 08:32:51  miselsa
 * $R60550_SPUL 投資起始日之前 增加 客戶匯出銀行條件
 * $
 * $Revision 1.6  2006/12/27 09:51:17  miselsa
 * $R60463及R60550_SPUL保單投資起始日前的匯費
 * $
 * $Revision 1.5  2006/12/07 22:00:34  miselsa
 * $R60463及R60550外幣及SPUL保單
 * $
 * $Revision 1.4  2006/11/30 09:16:45  miselsa
 * $R60463及R60550外幣及SPUL保單
 * $
 * $Revision 1.3  2006/10/31 09:45:00  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.2  2006/09/04 09:43:35  miselsa
 * $R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.11  2006/04/27 09:25:45  misangel
 * $R50891:VA美元保單-顯示幣別
 * $
 * $Revision 1.1.2.10  2005/08/19 06:56:04  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併
 * $
 * $Revision 1.1.2.9  2005/04/28 08:56:26  miselsa
 * $R30530平行測試的修改
 * $
 * $Revision 1.1.2.8  2005/04/18 08:51:14  MISANGEL
 * $R30530:支付系統-修改查詢條件為支付確認日
 * $
 * $Revision 1.1.2.7  2005/04/08 02:56:54  MISANGEL
 * $R30530:支付系統
 * $
 * $Revision 1.1.2.6  2005/04/04 07:02:27  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import com.aegon.codeAttr.RemittancePayRule;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.WorkingDay;
import com.aegon.disb.util.DISBPaymentDetailVO;

public class DISBRemitDisposeDAO {
	private PreparedStatement preStmt;
	private ResultSet rs = null;
	private DbFactory dbFactory = null;
	Connection conn2 = null;
	// R70477
	// private final String QUERY =
	// "SELECT PNAME,PID,PAMT,PRBANK,PRACCOUNT,PCSHDT,ENTRYUSR,PFEEWAY,PSWIFT,PPAYCURR,PENGNAME,PBKBRCH,PBKCITY,PBKCOTRY,PPAYAMT,ENTRYDT,PINVDT,PSYMBOL,PPAYRATE,PSRCCODE FROM CAPPAYF "//外幣匯款加入手續費付款方式//R70088SPUL配息PID,PPAYRATE,PSRCCODE
	private final String QUERY = "SELECT PNAME,PID,PAMT,PRBANK,PRACCOUNT,PCSHDT,ENTRYUSR,PFEEWAY,PSWIFT,PPAYCURR,"
			+ "PENGNAME,PBKBRCH,PBKCITY,PBKCOTRY,PPAYAMT,ENTRYDT,PINVDT,PSYMBOL,PPAYRATE,PSRCCODE,PCURR,SUBSTRING(FLD0004,17,8) AS PDESC,PPLANT,POLICYNO "// R90735
/*RC0036*/	+ ", DEPT"
			// Q10107+ "PENGNAME,PBKBRCH,PBKCITY,PBKCOTRY,PPAYAMT,ENTRYDT,PINVDT,PSYMBOL,PPAYRATE,PSRCCODE,PCURR,SUBSTRING(FLD0004,11) AS PDESC,PPLANT "
			+ " FROM CAPPAYF LEFT OUTER JOIN ORDUET ON FLD0001= '' AND FLD0002 = 'PAYCD' AND  PSRCCODE = FLD0003 "
/*RC0036*/	+ " LEFT OUTER JOIN USER ON ENTRYUSR = USRID"
			+ " WHERE PNO=?";

	private final String QUERY_LOT = "SELECT PNO,PID,APPNO,POLICYNO,PMETHOD,PDATE,PNAME,PRBANK,PRACCOUNT,PDESC,PCFMDT1,PCFMDT2,PAMT,PDISPATCH,DEPT ,PCURR "
			+ ",PPAYCURR,PPAYAMT,PPLANT,PINVDT,ENTRYDT,PSRCCODE,PRBANK" // 增加外幣幣別及金額
			+ " FROM CAPPAYF A "
			+ " LEFT OUTER JOIN USER B ON A.ENTRYUSR = B.USRID"
			+ " WHERE PSTATUS ='' AND PCFMDT1 >0 AND PCFMDT2 >0 AND PVOIDABLE<>'Y' "
			+ " AND PMETHOD =? AND PCFMDT2 >=? AND PCFMDT2 <=? AND PDISPATCH=? AND PCURR=? "
/*RC0036*/	+ " ORDER BY PCFMDT2,PCFMTM2,DEPT,PNAME,PRBANK,PRACCOUNT ";
			// + " AND PSYMBOL='N' " //取一般保單資料,不含SPUL保單
			//RC0036+ "ORDER BY DEPT,PNAME,PRBANK,PRACCOUNT ";

	private final String QUERY_LOT_D = "SELECT PNO,PID,APPNO,POLICYNO,PMETHOD,PDATE,PNAME,PRBANK,PRACCOUNT,PDESC,PCFMDT1,PCFMDT2,PAMT,PDISPATCH,DEPT ,PCURR"
			+ ",PPAYCURR,PPAYAMT,PSWIFT,PFEEWAY,PENGNAME,PBKBRCH,PBKCITY,PBKCOTRY,PPLANT,PINVDT,ENTRYDT,PSRCCODE,PRBANK" // 增加外幣幣別及金額
			// R00440 SN滿期金 +
			// ",CASE WHEN A.PPLANT = ' ' THEN '3' WHEN A.PSRCCODE IN ('B8','B9') OR A.ENTRYDT <= A.PINVDT THEN '1' WHEN A.PSRCCODE NOT IN ('B8','B9') AND A.ENTRYDT > A.PINVDT THEN '2' END PAYRULECODE"
			// // R00386
			+ ",CASE WHEN A.PPLANT = ' ' THEN '3' WHEN A.PSRCCODE IN ('B8','B9','BB') OR A.ENTRYDT <= A.PINVDT THEN '1' WHEN A.PSRCCODE NOT IN ('B8','B9','BB') AND A.ENTRYDT > A.PINVDT THEN '2' END PAYRULECODE" // R00440
			+ " FROM CAPPAYF A "
			+ " LEFT OUTER JOIN USER B ON A.ENTRYUSR = B.USRID"
			+ " WHERE PSTATUS ='' AND PCFMDT1 >0 AND PCFMDT2 >0 AND PVOIDABLE<>'Y' "
			+ " AND PMETHOD =? AND PCFMDT2 >=? AND PCFMDT2 <=? AND PDISPATCH=? AND PCURR=? ";
			// + " AND PSYMBOL='S' " ;//取SPUL保單
			// + "ORDER BY DEPT,PNAME,PRBANK,PRACCOUNT ";

	private final String UPDATE = "UPDATE CAPPAYF "
			+ " SET PSTATUS =? , PBBANK =? , PBACCOUNT=? , RMTFEE=? , PBATNO=?, PCSHDT=?, UPDDT=?, UPDTM =?, UPDUSR=?,BATSEQ=?,PCSHCM=?,PCHECKNO=? " // R60747增加出納確認日 RC0036
			+ " WHERE PNO=?";

	private final String UPDATE_FEEWAY = "UPDATE CAPPAYF SET PFEEWAY =? WHERE PNO=?";

	private final String INSERT_RMTF = "INSERT INTO CAPRMTF "
			+ "(BATNO,SEQNO,PBK,PACCT,RID,RTYPE,RBK,RACCT,RAMT,RNAME,RMEMO,RMTDT,RTRNCDE,RTRNTM,CSTNO,RMTCDE"
			+ ",RMTFEE,ENTRYDT,ENTRYTM,ENTRYUSR,MEMO,RPAYAMT,RPAYCURR,RPAYFEEWAY,RBKSWIFT,RENGNAME,RBKBRCH,RBKCITY,RBKCOUNTRY,RBENFEE,RPAYRATE,RPCURR) "// R70088新增RBENFEE,PAYRATE欄位
			+ "VALUES  "
			+ " (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

	private final String QUERY_RMTF = "SELECT SEQNO,RID,RTYPE,RBK,RACCT,RAMT,RNAME,RMEMO,RMTDT,RTRNCDE,RTRNTM,CSTNO,RMTCDE FROM CAPRMTF"
			+ " WHERE BATNO=?";

	public DISBRemitDisposeDAO(DbFactory factory) {
		this.dbFactory = factory;
	}

	public int update(DISBPaymentDetailVO payment, String SEQ) throws SQLException {
		int ret = 0;
		Connection conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(UPDATE);
			preStmt.setString(1, "B");
			preStmt.setString(2, payment.getStrPBBank());
			preStmt.setString(3, payment.getStrPBAccount());
			preStmt.setInt(4, payment.getIRmtFee());
			preStmt.setString(5, payment.getStrBatNo());
			preStmt.setInt(6, payment.getIPCshDt());
			preStmt.setInt(7, payment.getIUpdDt());
			preStmt.setInt(8, payment.getIUpdTm());
			preStmt.setString(9, payment.getStrUpdUsr());
			preStmt.setString(10, SEQ);
			preStmt.setInt(11, payment.getIPCSHCM());
			preStmt.setString(12, payment.getStrPCheckNO());
			preStmt.setString(13, payment.getStrPNO());
			ret = preStmt.executeUpdate();
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (preStmt != null) {
					preStmt.close();
				}
			} catch (Exception ex1) {
			}
		}
		return ret;
	}

	public void removeConn() {
		if (conn2 != null) {
			dbFactory.releaseAS400Connection(conn2);
		}
	}

	public int updateFeeWay(String strFeeway, String strPno) throws Exception {
		Connection conn = this.getConnection();
		int ret = 0;
		try {
			preStmt = conn.prepareStatement(UPDATE_FEEWAY);
			preStmt.setString(1, strFeeway);
			preStmt.setString(2, strPno);
			ret = preStmt.executeUpdate();
		} catch (Exception e) {
			System.err.println(e.getMessage());
			throw new Exception(e.getMessage());
		} finally {
			try {
				if (preStmt != null) {
					preStmt.close();
				}
			} catch (Exception ex1) {
			}
		}
		return ret;
	}

	/**
	 * 
	 * @param payMethod  付款方式
	 * @param pDate1 	  付款日起
	 * @param pDate2 	  付款日迄
	 * @param pDispatch  急件否
	 * @return
	 */
	// R80338 public Vector query(String payMethod, int pDate1, int pDate2,
	// String pDispatch,String strCurrency,String SYMBOL,String
	// BeforePINVDT,String PRBank)
	/*
	 * public Vector query(String payMethod, int pDate1, int pDate2, String
	 * pDispatch,String strCurrency,String SYMBOL,String BeforePINVDT,String
	 * PRBank,String ProjectCode) //R80338 throws Exception{ Vector retVector =
	 * new Vector(); Connection conn = this.getConnection(); String strSql =
	 * null; try{ if(payMethod.equals("D")){ strSql = QUERY_LOT_D ; } else{
	 * strSql =QUERY_LOT; }
	 * 
	 * if(SYMBOL.equals("S")){//付款方式為外幣匯款且保單幣別為NT //R80338 strSql
	 * +=" AND PSYMBOL='S' "; strSql +=" AND PSYMBOL IN('S','D') "; //R80338
	 * if(!BeforePINVDT.equals("")) { if(BeforePINVDT.equals("Y")){//投資起始日之前的資料
	 * //R70455 strSql +=" and (entrydt <= PINVDT or PSRCCODE='B8') ";//R70088配息
	 * strSql +=" and (entrydt <= PINVDT or PSRCCODE IN ('B8','B9')) ";//R70455
	 * if(!PRBank.equals("")){ strSql +=" and PRBank like '" +
	 * PRBank.substring(0,3) + "%'";//客戶匯出銀行 } } else{ strSql
	 * +=" and entrydt > PINVDT"; //R70455 strSql
	 * +=" and PSRCCODE<>'B8' ";//R70088配息 strSql
	 * +=" and PSRCCODE NOT IN ('B8','B9') ";//R70455 } }
	 * 
	 * if(ProjectCode.equals("UBS")){ //R80338 專案碼 strSql +=
	 * " AND PROJECTCD = 'UBS' "; //R80338 } else
	 * if(ProjectCode.equals("OTHERS")){ //R80338 專案碼 strSql +=
	 * " AND PROJECTCD <> 'UBS' "; //R80338 } strSql +=
	 * " ORDER BY DEPT,PNAME,PRBANK,PRACCOUNT "; } // R70477 FIX BUG // else{ //
	 * strSql =QUERY_LOT; // } System.out.println("strSql="+strSql); preStmt =
	 * conn.prepareStatement(strSql); preStmt.setString(1,payMethod);
	 * preStmt.setInt(2,pDate1); preStmt.setInt(3,pDate2);
	 * preStmt.setString(4,pDispatch); preStmt.setString(5,strCurrency); rs =
	 * preStmt.executeQuery(); retVector.addAll(setValueObject(rs,payMethod));
	 * }catch(Exception e){ System.err.println(e.getMessage()); throw new
	 * Exception(e.getMessage()); }finally{ if (rs != null) try { rs.close(); }
	 * catch (Exception ex1) {} if (preStmt != null) try { preStmt.close(); }
	 * catch (Exception ex1) {} } return retVector; }
	 */
	/**
	 * R00386 新增, 使用付款規則來查詢
	 * 
	 * @param payMethod  付款方式
	 * @param pDate1    付款日起
	 * @param pDate2    付款日迄
	 * @param pDispatch  急件否
	 * @param strCurrency 保單幣別
	 * @param PRBank  匯款銀行
	 * @param payRule  付款規則
	 * @return
	 */
	public Vector<DISBPaymentDetailVO> query(String payMethod, int pDate1, int pDate2, String pDispatch, String strCurrency, String SYMBOL, String PRBank, String payRule) throws Exception {

		Vector<DISBPaymentDetailVO> retList = new Vector<DISBPaymentDetailVO>();
		Connection conn = null;
		String strSql = null;

		try {

			conn = this.getConnection();

			if (payMethod.equals("D")) {
				strSql = QUERY_LOT_D;
			} else {
				strSql = QUERY_LOT;
			}
			System.out.println("strSql@@=" + strSql);
			// 外幣匯款時, 改依付款規則查詢
			if (payMethod.equals("D") && payRule != null && payRule.length() > 0) {

				boolean appendBank = true;

				if (payRule.equals(RemittancePayRule.PLANV_DIV.getCode())) {
					// R00440 SN滿期金 strSql += " and (entrydt <= PINVDT or PSRCCODE IN ('B8','B9')) AND PPLANT = 'V' ";
					strSql += " and (entrydt <= PINVDT or PSRCCODE IN ('B8','B9','BB')) AND PPLANT = 'V' ";// R00440 SN滿期金
				} else if (payRule.equals(RemittancePayRule.PLANV_NODIV.getCode())) {
					strSql += " and entrydt > PINVDT";
					// R00440 SN滿期金 strSql += " and PSRCCODE NOT IN ('B8','B9') AND PPLANT = 'V'  ";
					strSql += " and PSRCCODE NOT IN ('B8','B9','BB') AND PPLANT = 'V'  ";// R00440 SN滿期金
					appendBank = false; // 只有一家銀行, 不用加條件了, 少做少錯
				} else if (payRule.equals(RemittancePayRule.PLANT.getCode())) {
					// 傳統型外幣
					strSql += " AND PPLANT = ' ' AND PCURR <> 'NT' ";
				}

/*RC0036          if (appendBank && PRBank != null && PRBank.length() > 0) {
					strSql += " and PRBank like '" + PRBank.substring(0, 3) + "%'";// 客戶收款的銀行
				}
*/
			}
			// RC0036 若付款方式為外幣匯款且僅輸入會出銀行而不限定付款規則
 			if (payMethod.equals("D") && PRBank != null && PRBank.length() > 0 && !PRBank.substring(0, 3).equals("822") ) {
				strSql += " and PRBank like '" + PRBank.substring(0, 3) + "%'";// 客戶收款的銀行
			}
			// 付款方式為外幣匯款且保單幣別為NT
			if (SYMBOL.equals("S")
					&& (payRule.equals(RemittancePayRule.PLANV_DIV.getCode()) 
							|| payRule.equals(RemittancePayRule.PLANV_NODIV.getCode()))) 
				strSql += " AND PSYMBOL IN('S','D') "; // R80338

			if (payMethod.equals("D"))
/*RC0036*/		strSql += " ORDER BY PCFMDT2,PCFMTM2,DEPT,PNAME,PRBANK,PRACCOUNT ";
				//RC0036		strSql += " ORDER BY DEPT,PNAME,PRBANK,PRACCOUNT,PAYRULECODE ";

			System.out.println("strSqlxx=" + strSql);
			preStmt = conn.prepareStatement(strSql);
			preStmt.setString(1, payMethod);
			preStmt.setInt(2, pDate1);
			preStmt.setInt(3, pDate2);
			preStmt.setString(4, pDispatch);
			preStmt.setString(5, strCurrency);
			rs = preStmt.executeQuery();
			
			retList.addAll(setValueObject(rs, payMethod , payRule ,PRBank));
			return retList;

		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception ex1) {
				}
			if (preStmt != null)
				try {
					preStmt.close();
				} catch (Exception ex1) {
				}
		}
	}

	public void query(DISBPaymentDetailVO vo) throws Exception {
		Connection conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(QUERY);
			System.out.println(QUERY);
			preStmt.setString(1, vo.getStrPNO());
			rs = preStmt.executeQuery();
			if (rs.next()) {
				vo.setIPAMT(rs.getDouble("PAMT"));
				vo.setStrPRBank(rs.getString("PRBANK").trim());
				vo.setStrPName(rs.getString("PNAME").trim());
				vo.setStrPId(rs.getString("PID").trim());// 受款人ID R70088 SPUL配息
				vo.setStrPRAccount(rs.getString("PRACCOUNT").trim());
				vo.setIPCshDt(rs.getInt("PCSHDT"));
				vo.setStrEntryUsr(rs.getString("ENTRYUSR"));
				vo.setStrPSWIFT(rs.getString("PSWIFT"));// SWIFT CODE
				vo.setStrPFEEWAY(rs.getString("PFEEWAY"));// 外幣加入收續費支付方式
				vo.setStrPPAYCURR(rs.getString("PPAYCURR")); // 匯出幣別
				vo.setStrPENGNAME(rs.getString("PENGNAME"));// 英文姓名
				vo.setStrPBKBRCH(rs.getString("PBKBRCH"));// 分行
				vo.setStrPBKCITY(rs.getString("PBKCITY")); // 城市
				vo.setStrPBKCOTRY(rs.getString("PBKCOTRY"));// 國別
				vo.setIPPAYAMT(rs.getDouble("PPAYAMT"));// 外幣金額
				vo.setIPPAYRATE(rs.getDouble("PPAYRATE"));// 外幣匯率R70088
				vo.setStrPSrcCode(rs.getString("PSRCCODE"));// 支付原因碼R70088
				vo.setIEntryDt(rs.getInt("ENTRYDT"));// 輸入日期R70088
				vo.setIPINVDT(rs.getInt("PINVDT"));// 投資起始日
				vo.setStrPSYMBOL(rs.getString("PSYMBOL"));// 是否為SPUL
				vo.setStrPCurr(rs.getString("PCURR"));// R70477 保單幣別
				vo.setStrPDesc(rs.getString("PDESC"));// R90735 支付描述
				vo.setStrPPlant(rs.getString("PPLANT"));// R00386險種類別
				vo.setStrPolicyNo(rs.getString("POLICYNO"));//R10190
				vo.setStrUsrDept(rs.getString("DEPT"));//RC0036
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			throw new Exception(e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (preStmt != null) {
					preStmt.close();
				}
			} catch (Exception ex1) {
			}
		}
	}

	/**
	 * @param pcshdt
	 *            匯款批號
	 * @return
	 * @throws Exception
	 */
	public Object[] queryRMTF(String batno) throws Exception {
		Vector<CaprmtfVO> ret = new Vector<CaprmtfVO>();
		Connection conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(QUERY_RMTF);
			preStmt.setString(1, batno);
			rs = preStmt.executeQuery();

			while (rs.next()) {
				CaprmtfVO vo = new CaprmtfVO();
				vo.setSEQNO(rs.getString("SEQNO"));
				vo.setPBK(rs.getString("PBK"));
				vo.setPACCT(rs.getString("PACCT"));
				vo.setRID(rs.getString("RID"));
				vo.setRTYPE(rs.getString("RTYPE"));
				vo.setRBK(rs.getString("RBK"));
				vo.setRACCT(rs.getString("RACCT"));
				vo.setRAMT(rs.getInt("RAMT"));
				vo.setRNAME(rs.getString("RNAME"));
				vo.setMEMO(rs.getString("MEMO"));
				vo.setRMTDT(rs.getString("RMTDT"));
				vo.setRTRNCDE(rs.getString("RTRNCDE"));
				vo.setRTRNTM(rs.getString("RTRNTM"));
				vo.setCSTNO(rs.getString("CSTNO"));
				vo.setRMTFEE(rs.getInt("RMTFEE"));
				ret.add(vo);
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			throw new Exception(e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (preStmt != null) {
					preStmt.close();
				}
			} catch (Exception ex1) {
			}
		}
		return ret.toArray();
	}

	/**
	 * @param
	 * @return
	 * @throws Exception
	 */
	public int insertRMTF(CaprmtfVO rmtfVo) throws SQLException {
		int ret = 0;
		Connection conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(INSERT_RMTF);
			preStmt.setString(1, rmtfVo.getBATNO());
			preStmt.setString(2, rmtfVo.getSEQNO());
			preStmt.setString(3, rmtfVo.getPBK());
			preStmt.setString(4, rmtfVo.getPACCT());
			preStmt.setString(5, rmtfVo.getRID());
			preStmt.setString(6, rmtfVo.getRTYPE());
			preStmt.setString(7, rmtfVo.getRBK());
			preStmt.setString(8, rmtfVo.getRACCT());
			preStmt.setDouble(9, rmtfVo.getRAMT());
			preStmt.setString(10, rmtfVo.getRNAME());
			preStmt.setString(11, rmtfVo.getRMEMO());
			preStmt.setString(12, rmtfVo.getRMTDT());
			preStmt.setString(13, rmtfVo.getRMTCDE());
			preStmt.setString(14, rmtfVo.getRTRNTM());
			preStmt.setString(15, rmtfVo.getCSTNO());
			preStmt.setString(16, rmtfVo.getRMTCDE());
			preStmt.setInt(17, rmtfVo.getRMTFEE());
			preStmt.setInt(18, rmtfVo.getENTRYDT());
			preStmt.setInt(19, rmtfVo.getENTRYTM());
			preStmt.setString(20, rmtfVo.getENTRYUSR().trim());
			preStmt.setString(21, rmtfVo.getMEMO());
			/* R60550 新增2個欄位 */
			preStmt.setDouble(22, rmtfVo.getRPAYAMT());
			preStmt.setString(23, rmtfVo.getRPAYCURR());// 匯出幣別
			/* 手續費支付方式 */
			preStmt.setString(24, rmtfVo.getRPAYFEEWAY().trim());
			preStmt.setString(25, rmtfVo.getSWIFTCODE().trim());
			preStmt.setString(26, rmtfVo.getPENGNAME().trim());// 英文姓名
			preStmt.setString(27, rmtfVo.getRBKBRCH().trim());// 分行
			preStmt.setString(28, rmtfVo.getRBKCITY().trim()); // 城市
			preStmt.setString(29, rmtfVo.getRBKCOUNTRY().trim()); // 國別
			preStmt.setDouble(30, rmtfVo.getRBENFEE());// R70088
			preStmt.setDouble(31, rmtfVo.getRPAYRATE());// R70088]
			preStmt.setString(32, rmtfVo.getRPCURR());// R70477
			/*
			 * System.out.println("getBATNO="+rmtfVo.getBATNO());
			 * System.out.println("getRPAYAMT="+rmtfVo.getRPAYAMT());
			 * System.out.println("getRPAYCURR="+rmtfVo.getRPAYCURR());
			 * System.out.println("getRPAYFEEWAY="+rmtfVo.getRPAYFEEWAY());
			 * System.out.println("getSWIFTCODE="+rmtfVo.getSWIFTCODE());
			 * System.out.println("getPENGNAME="+rmtfVo.getPENGNAME());
			 * System.out.println("getRBKBRCH="+rmtfVo.getRBKBRCH());
			 * System.out.println("getRBKCITY="+rmtfVo.getRBKCITY());
			 * System.out.println("getRBKCOUNTRY="+rmtfVo.getRBKCOUNTRY());
			 */
			ret = preStmt.executeUpdate();
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try {
				if (preStmt != null) {
					preStmt.close();
				}
			} catch (Exception ex1) {
			}
		}
		return ret;
	}

	// 自 DbFactory 中取得一個 Connection
	public Connection getConnection() throws SQLException {
		// 先取得資料庫連結及準備SQL
		if (conn2 == null) {
			conn2 = dbFactory.getConnection(DISBRemitDisposeDAO.class + ".DataClass.getConnection()");
		}
		return this.conn2;
	}

	private Vector<DISBPaymentDetailVO> setValueObject(ResultSet rs, String PMethod, String payRule, String PRBank) throws SQLException {
		Vector<DISBPaymentDetailVO> ret = new Vector<DISBPaymentDetailVO>();
		DISBPaymentDetailVO vo;

		WorkingDay workingDay = new WorkingDay(dbFactory);

		while (rs.next()) {
			if (PMethod.equals("D")){
				if (rs.getString("PAYRULECODE").equals("1")){//規則1
					if (!PRBank.equals("") && !PRBank.substring(0,3).equals(rs.getString("PRBANK").substring(0,3))) continue ;
				}else if (rs.getString("PAYRULECODE").equals("3")){//規則3
					if (!PRBank.equals("") && !PRBank.substring(0,3).equals(rs.getString("PRBANK").substring(0,3))) continue ;
				}
			}
			vo = new DISBPaymentDetailVO();
			// System.err.println(rs.getString("PAY_NO"));
			// System.err.println(rs.getString("PNO"));
			vo.setStrPNO(rs.getString("PNO"));
			vo.setStrPolicyNo(rs.getString("POLICYNO"));
			vo.setStrAppNo(rs.getString("APPNO"));
			vo.setStrPName(rs.getString("PNAME"));
			vo.setStrPId(rs.getString("PID"));
			vo.setIPAMT(rs.getDouble("PAMT"));
			vo.setStrPDesc(rs.getString("PDESC"));
			vo.setIPDate(rs.getInt("PDATE"));
			vo.setStrPMethod(rs.getString("PMETHOD"));
			vo.setStrPDispatch(rs.getString("PDISPATCH"));
			vo.setStrPCurr(rs.getString("PCURR"));
			if (PMethod.equals("D")) {
				vo.setStrPPAYCURR(rs.getString("PPAYCURR"));
				vo.setIPPAYAMT(rs.getDouble("PPAYAMT"));// 外幣金額
				vo.setStrPSWIFT(rs.getString("PSWIFT"));
				vo.setStrPFEEWAY(rs.getString("PFEEWAY"));// 外幣加入收續費支付方式
				vo.setStrPPAYCURR(rs.getString("PPAYCURR")); // 匯出幣別
				vo.setStrPENGNAME(rs.getString("PENGNAME"));// 英文姓名
				vo.setStrPBKBRCH(rs.getString("PBKBRCH"));// 分行
				vo.setStrPBKCITY(rs.getString("PBKCITY")); // 城市
				vo.setStrPBKCOTRY(rs.getString("PBKCOTRY"));// 國別

				// R00386
				// if( rs.getString("PPLANT").equals( " " ) &&
				// !rs.getString("PCURR").equals( "NT" ) ) {
				// vo.setCheckedPayDate( workingDay.nextDay( rs.getInt(
				// "PCFMDT2" ) + 19110000, 3 ) - 19110000);

				// } else
				vo.setCheckedPayDate(workingDay.nextDay(rs.getInt("PCFMDT2") + 19110000, 1) - 19110000);
			}
			System.out.println("DISBRemitDisposeDAO.setValueObject");
			ret.add(vo);
		}
		return ret;
	}

}