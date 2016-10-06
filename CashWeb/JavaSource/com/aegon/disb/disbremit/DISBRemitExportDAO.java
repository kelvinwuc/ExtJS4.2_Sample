package com.aegon.disb.disbremit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.DbFactory;
import com.aegon.disb.util.DISBPaymentDetailVO;

import org.apache.log4j.Logger;

/**
 * System   : CashWeb
 * 
 * Function : 整批匯款DAO
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.20 $$
 * 
 * Author   : Vicky Hsu
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBRemitExportDAO.java,v $
 * $Revision 1.20  2015/11/24 04:14:23  001946
 * $*** empty log message ***
 * $
 * $Revision 1.19  2015/06/04 09:01:46  001946
 * $*** empty log message ***
 * $
 * $Revision 1.18  2014/10/07 06:24:21  misariel
 * $RC0036-修正科學符號的問題
 * $
 * $Revision 1.17  2014/08/05 03:08:39  missteven
 * $RC0036
 * $
 * $Revision 1.15  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.14  2013/03/29 09:55:05  MISSALLY
 * $RB0062 PA0047 - 新增指定銀行 彰化銀行
 * $
 * $Revision 1.12  2008/10/23 02:28:34  MISODIN
 * $Q80628 資料重覆問題之修正
 * $
 * $Revision 1.11  2008/07/02 02:38:40  misvanessa
 * $Q80408_中信銀外幣匯款同行相轉條件修正
 * $
 * $Revision 1.10  2008/04/30 07:48:37  misvanessa
 * $R80300_收單行轉台新,新增下載檔案及報表
 * $
 * $Revision 1.9  2007/09/07 10:25:03  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.8  2007/08/28 01:44:09  MISVANESSA
 * $R70574_SPUL配息新增匯出檔案
 * $
 * $Revision 1.7  2007/03/06 01:34:23  MISVANESSA
 * $R70088_SPUL配息新增客戶負擔手續費
 * $
 * $Revision 1.6  2007/01/31 08:00:34  MISVANESSA
 * $R70088_SPUL配息
 * $
 * $Revision 1.5  2007/01/05 07:23:17  MISVANESSA
 * $R60550_匯出檔案.報表修改
 * $
 * $Revision 1.4  2006/11/30 09:15:00  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.3  2006/10/31 09:43:17  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.2  2006/09/04 09:43:35  miselsa
 * $R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.8  2006/04/27 09:25:45  misangel
 * $R50891:VA美元保單-顯示幣別
 * $
 * $Revision 1.1.2.7  2005/08/26 08:35:33  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併
 * $
 * $Revision 1.1.2.6  2005/08/19 06:56:18  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併
 * $
 * $Revision 1.1.2.5  2005/04/28 08:56:26  miselsa
 * $R30530平行測試的修改
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:26  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBRemitExportDAO {
	
	Logger log = Logger.getLogger(getClass());
	
	private PreparedStatement preStmt;
	private PreparedStatement preStmt2;
	private ResultSet rs = null;
	private ResultSet rs2 = null;
	private DbFactory dbFactory = null ;

	private final String QUERY_BATNO = "SELECT  DISTINCT PBATNO,PCURR FROM CAPPAYF " 
							+" WHERE PCFMDT1 >0 AND PCFMDT2 >0  AND PCSHCM=?"; //R60747將PCSHDT 改為 PCSHCM  

	private final String QUERY_BY_BATNO = "SELECT BATNO,SEQNO,RID,RTYPE,RBK,RACCT,RAMT,RNAME,RMEMO "
			                +",USR.DEPT,PBK,USR.DEPT"//RC0036
			             	+",RMTDT,RTRNCDE,RTRNTM,CSTNO,RMTCDE,RMTFEE FROM CAPRMTF"
			             	+" LEFT OUTER JOIN USER USR on USR.USRID = ENTRYUSR"           //RC0036
							+" WHERE BATNO=?  ORDER BY SEQNO ";

	//R60550
	private final String QUERY_BY_BATNOD = "SELECT A.BATNO,A.SEQNO,A.RID,A.RTYPE,A.RBK,A.RACCT,A.RAMT,A.RNAME,A.RMEMO"
							+ ",A.RMTDT,A.RTRNCDE,A.RTRNTM,A.CSTNO,A.RMTCDE,A.RMTFEE,A.PACCT,A.RPAYAMT,A.RPAYCURR,A.RPAYFEEWAY"
							+ ",A.RBKSWIFT as SWIFTCODE,A.RENGNAME AS PENGNAME,S.BANK_NAME AS SWBKNAME"
							+ ",A.RBENFEE,A.PBK,RBKCOUNTRY,USR.DEPT"//R70088 R70574
							+ " FROM CAPRMTF A"
							+ " left outer join ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE AND SUBSTR(A.PBK,1,3) = S.BANK_NO" //RD0144
							+ " LEFT OUTER JOIN USER USR on USR.USRID = A.ENTRYUSR"           //RC0036
							+ " WHERE A.BATNO=? AND A.RPAYCURR=?"
							+ " ORDER BY A.RACCT,A.RNAME,A.SEQNO";

	private final String QUERY_BY_BATNOC = "SELECT A.PNO,A.PDATE,A.PAMT,A.PCRDNO,A.PCRDTYPE,A.PAUTHDT,A.PAUTHCODE"
							+ ",A.PCRDEFFMY,A.POLICYNO,A.PBATNO,A.BATSEQ,A.PCSHDT,A.PORGAMT,A.PORGCRDNO,USR.DEPT "
							+ " FROM CAPPAYF A "
							+ " LEFT OUTER JOIN USER USR on USR.USRID = A.ENTRYUSR"           //RC0036
							+ " WHERE A.PAUTHDT >= 970501 AND A.PSTATUS <> 'C' AND A.PBATNO=? "
							+ " ORDER BY A.BATSEQ ";

	//匯款檔
	private final String QUERY_BY_BATNO_Remit = "SELECT A.BATNO,A.SEQNO,A.RID,A.RTYPE,A.RBK,A.RACCT,A.RAMT,A.RNAME,A.RMEMO" +
								",A.RMTDT,A.RTRNCDE,A.RTRNTM,A.CSTNO,A.RMTCDE,A.RMTFEE,A.PACCT,A.RPAYAMT,A.RPAYCURR,A.RPAYFEEWAY" +
								",A.RBKSWIFT as SWIFTCODE,A.RENGNAME AS PENGNAME,S.BANK_NAME AS SWBKNAME" +
								",A.RBENFEE,A.PBK,RBKCOUNTRY" +
								",USR.DEPT" +//RC0036
								" FROM CAPRMTF A" +
								" LEFT OUTER JOIN ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE " +
								" LEFT OUTER JOIN USER USR on USR.USRID = A.ENTRYUSR"  +          //RC0036
								" WHERE " +
								"SUBSTR(A.RBK,1,3)<>? AND " +
								"A.BATNO=? AND " +
								"A.RPAYCURR=? " +
								" RDER BY A.RACCT,A.RNAME,A.SEQNO";
	
	//RD0382-配合OIU業務系統功能調整,新增兆豐017匯款檔(跨行)的產生,判斷SWIFT CODE的第5及6碼不可為TW
	//RE0189:該匯款批號只要不是兆豐-轉帳檔的資料即是該放進兆豐-匯款檔,故維持原RD0382的做法, 20160825-done
	//兆豐-匯款檔:(1)受款帳號是兆豐及他行(不含凱基及台新)DBU帳號; (2)受款帳號是兆豐及他行境外OBU帳號
	private final String QUERY_BY_BATNO_Remit017 = "SELECT A.BATNO,A.SEQNO,A.RID,A.RTYPE,A.RBK,A.RACCT,A.RAMT,A.RNAME,A.RMEMO" + 
			",A.RMTDT,A.RTRNCDE,A.RTRNTM,A.CSTNO,A.RMTCDE,A.RMTFEE,A.PACCT,A.RPAYAMT,A.RPAYCURR,A.RPAYFEEWAY" +
			",A.RBKSWIFT as SWIFTCODE,A.RENGNAME AS PENGNAME,S.BANK_NAME AS SWBKNAME" +
			",A.RBENFEE,A.PBK,RBKCOUNTRY" +
			",USR.DEPT" +
			" FROM CAPRMTF A" +
			" LEFT OUTER JOIN ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE " +
			" LEFT OUTER JOIN USER USR on USR.USRID = A.ENTRYUSR"   +         
			" WHERE " +
			"SUBSTR(A.PBK,1,3)=? AND " +
			"CONCAT(SUBSTRING(RBK,1,3),SUBSTRING(RBKSWIFT,5,2))<>'017TW' AND " + //RE0189:只要不是兆豐OBU境內受款帳號
			"A.BATNO=? AND " +
			"A.RPAYCURR=? " +
			"ORDER BY A.RACCT,A.RNAME,A.SEQNO";
	
	//RE0189:
	//凱基-匯款檔:受款帳號凱基DBU帳號須產生本檔案,20160824-done
	//20161004,出納Sophia與凱基確認無此英文帳號,但Cash系統要保留此判斷
	private final String QUERY_BY_BATNO_Remit809 = "SELECT A.BATNO,A.SEQNO,A.RID,A.RTYPE,A.RBK,A.RACCT,A.RAMT,A.RNAME,A.RMEMO" + 
			",A.RMTDT,A.RTRNCDE,A.RTRNTM,A.CSTNO,A.RMTCDE,A.RMTFEE,A.PACCT,A.RPAYAMT,A.RPAYCURR,A.RPAYFEEWAY" +
			",A.RBKSWIFT as SWIFTCODE,A.RENGNAME AS PENGNAME,S.BANK_NAME AS SWBKNAME" +
			",A.RBENFEE,A.PBK,RBKCOUNTRY" +
			",USR.DEPT" +
			" FROM CAPRMTF A" +
			" LEFT OUTER JOIN ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE " +
			" LEFT OUTER JOIN USER USR on USR.USRID = A.ENTRYUSR"   +         
			" WHERE " +
			"SUBSTR(A.PBK,1,3)=? AND " +
			"( " +
			"SUBSTRING(RBK,1,3)='809' AND " +
			"SUBSTRING(RACCT,1,3)<>'018' AND " +
			"(SUBSTRING(RACCT,1,1) BETWEEN '0' AND '9') AND " +
			"(SUBSTRING(RACCT,2,1) BETWEEN '0' AND '9') AND " +
			"(SUBSTRING(RACCT,3,1) BETWEEN '0' AND '9') AND " +
			"(SUBSTRING(RACCT,4,1) BETWEEN '0' AND '9') " +
			") AND " +
			"A.BATNO=? AND " +
			"A.RPAYCURR=? " +
			"ORDER BY A.RACCT,A.RNAME,A.SEQNO";

	//轉帳檔
	private final String QUERY_BY_BATNO_Trans = "SELECT A.BATNO,A.SEQNO,A.RID,A.RTYPE,A.RBK,A.RACCT,A.RAMT,A.RNAME,A.RMEMO" + 
								",A.RMTDT,A.RTRNCDE,A.RTRNTM,A.CSTNO,A.RMTCDE,A.RMTFEE,A.PACCT,A.RPAYAMT,A.RPAYCURR,A.RPAYFEEWAY" +
								",A.RBKSWIFT as SWIFTCODE,A.RENGNAME AS PENGNAME,S.BANK_NAME AS SWBKNAME" +
								" ,A.RBENFEE,A.PBK,RBKCOUNTRY,USR.DEPT" +
								" FROM CAPRMTF A" +
								" LEFT OUTER JOIN ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE" +
								" LEFT OUTER JOIN USER USR on USR.USRID = A.ENTRYUSR" +           //RC0036
								" WHERE " +
								"SUBSTRING(A.RBKSWIFT,5,2)='TW' AND " + //RD0382:OIU,新增判斷RBK的SWIFT CODE的第5及6碼須為TW
								"SUBSTR(A.RBK,1,3)=? AND " +
								"A.BATNO=? AND " +
								"A.RPAYCURR=? " + 
								"ORDER BY A.RACCT,A.RNAME,A.SEQNO";
	
	//RE0189:只有809-OBU --> 809-OBU (只要判斷受款帳戶是否為OBU)才產生該檔案
	//凱基-轉帳檔:只有受款帳號是凱基境內OBU帳號,20160824-done
	//20161004,出納Sophia與凱基確認無此英文帳號,但Cash系統要保留此判斷
	private final String QUERY_BY_BATNO_Trans809 = "SELECT A.BATNO,A.SEQNO,A.RID,A.RTYPE,A.RBK,A.RACCT,A.RAMT,A.RNAME,A.RMEMO" + 
			",A.RMTDT,A.RTRNCDE,A.RTRNTM,A.CSTNO,A.RMTCDE,A.RMTFEE,A.PACCT,A.RPAYAMT,A.RPAYCURR,A.RPAYFEEWAY" +
			",A.RBKSWIFT as SWIFTCODE,A.RENGNAME AS PENGNAME,S.BANK_NAME AS SWBKNAME" +
			" ,A.RBENFEE,A.PBK,RBKCOUNTRY,USR.DEPT" +
			" FROM CAPRMTF A" +
			" LEFT OUTER JOIN ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE" +
			" LEFT OUTER JOIN USER USR on USR.USRID = A.ENTRYUSR" +           //RC0036
			" WHERE " +
			"SUBSTRING(A.RBKSWIFT,5,2)='TW' AND " + //RD0382:OIU,新增判斷RBK的SWIFT CODE的第5及6碼須為TW
			"SUBSTR(A.RBK,1,3)=? AND " +
			"A.BATNO=? AND " +
			"A.RPAYCURR=? AND " + 
			"SUBSTRING(RBK,1,3)='809' AND " +
			"(" +
			"SUBSTRING(RACCT,1,3)='018' OR " + //凱基OBU判斷
			"( (UPPER(SUBSTRING(RACCT,1,1))>='A' AND UPPER(SUBSTRING(RACCT,1,1))<='Z') AND " +//凱基OBU判斷
			"(UPPER(SUBSTRING(RACCT,2,1))>='A' AND UPPER(SUBSTRING(RACCT,2,1))<='Z') AND " +//凱基OBU判斷
			"(UPPER(SUBSTRING(RACCT,3,1))>='A' AND UPPER(SUBSTRING(RACCT,3,1) )<='Z') AND " +//凱基OBU判斷
			"(UPPER(SUBSTRING(RACCT,4,1))>='A' AND UPPER(SUBSTRING(RACCT,4,1))<='Z') ) " +//凱基OBU判斷
			") " +
			"ORDER BY A.RACCT,A.RNAME,A.SEQNO";
	
	//RE0189:兆豐轉帳檔新增"不可為"兆豐OBU轉至兆豐DBU的限縮條件
	//兆豐-轉帳檔:只有受款帳號是兆豐境內OBU帳號, 20160825-done
	private final String QUERY_BY_BATNO_Trans017 = "SELECT A.BATNO,A.SEQNO,A.RID,A.RTYPE,A.RBK,A.RACCT,A.RAMT,A.RNAME,A.RMEMO" + 
			",A.RMTDT,A.RTRNCDE,A.RTRNTM,A.CSTNO,A.RMTCDE,A.RMTFEE,A.PACCT,A.RPAYAMT,A.RPAYCURR,A.RPAYFEEWAY" +
			",A.RBKSWIFT as SWIFTCODE,A.RENGNAME AS PENGNAME,S.BANK_NAME AS SWBKNAME" +
			" ,A.RBENFEE,A.PBK,RBKCOUNTRY,USR.DEPT" +
			" FROM CAPRMTF A" +
			" LEFT OUTER JOIN ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE" +
			" LEFT OUTER JOIN USER USR on USR.USRID = A.ENTRYUSR" +           //RC0036
			" WHERE " +
			"SUBSTRING(A.RBKSWIFT,5,2)='TW' AND " + //RD0382:OIU,新增判斷RBK的SWIFT CODE的第5及6碼須為TW
			"(SUBSTRING(RBK,1,3)='017' AND SUBSTRING(RACCT,4,2) IN('17','57','58')) AND " + //RE0189:只有受款帳號是兆豐境內OBU帳號
			"SUBSTR(A.RBK,1,3)=? AND " +
			"A.BATNO=? AND " +
			"A.RPAYCURR=? " + 
			"ORDER BY A.RACCT,A.RNAME,A.SEQNO";

	public DISBRemitExportDAO(DbFactory factory) {
		this.dbFactory = factory;
	}

	/**
	 * @param pcshcm 出納確認日期
	 * @return 匯款批號
	 * @throws Exception
	 */	
	public Vector query(int pcshcm) throws Exception {
		Vector ret = new Vector();	
		Connection conn = this.getConnection();
		try{							
			System.out.println("Query by PCSHCM="+QUERY_BATNO);
			preStmt = conn.prepareStatement(QUERY_BATNO);
			preStmt.setInt(1, pcshcm);
			rs = preStmt.executeQuery();
			DISBPaymentDetailVO vo = null;
			while(rs.next()) {
				vo = new DISBPaymentDetailVO();
				vo.setStrPCurr(rs.getString("PCURR"));
				vo.setStrBatNo(rs.getString("PBATNO"));
				ret.add(vo);
			}
		} catch(Exception e) {
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
				if (conn != null) {
					dbFactory.releaseAS400Connection(conn);
				}
			} catch (Exception ex1) {
			}
		}
		return ret;		
	}
	
	//RD0382:OIU
	public Vector query(int pcshcm, String company) throws Exception {
		Vector ret = new Vector();	
		Connection conn = this.getConnection();
		String QUERY_BATNO = "SELECT  DISTINCT PBATNO,PCURR,CASE WHEN PAY_COMPANY ='OIU' THEN 'OIU' ELSE '總公司' END AS PAY_COMPANY FROM CAPPAYF " 
				+" WHERE PCFMDT1 >0 AND PCFMDT2 >0  AND PCSHCM=" + pcshcm;
		
		if(!"".equals(company)){
			if("6".equals(company)){
				QUERY_BATNO += " AND PAY_COMPANY='OIU' ";
			}else if("0".equals(company)){
				QUERY_BATNO += " AND PAY_COMPANY<>'OIU' ";
			}
		}
		
		try{							
			System.out.println("Query by PCSHCM="+QUERY_BATNO);
			preStmt = conn.prepareStatement(QUERY_BATNO);
			//preStmt.setInt(1, pcshcm);
			rs = preStmt.executeQuery();
			DISBPaymentDetailVO vo = null;
			while(rs.next()) {
				vo = new DISBPaymentDetailVO();
				vo.setStrPCurr(rs.getString("PCURR"));
				vo.setStrBatNo(rs.getString("PBATNO"));
				vo.setCompany(rs.getString("PAY_COMPANY"));
				ret.add(vo);
			}
		} catch(Exception e) {
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
				if (conn != null) {
					dbFactory.releaseAS400Connection(conn);
				}
			} catch (Exception ex1) {
			}
		}
		return ret;		
	}

	public Vector queryByBatNo(String batNo,String selCURR,String remitKind) throws Exception {
		Vector ret = new Vector();	
		Connection conn = this.getConnection();
		Connection conn2 = this.getConnection();
		String sql = "SELECT IFNULL(PAY_BK_SORTCODE,'') AS PAY_BK_SORTCODE,IFNULL(PAY_BK_VERIFYNUMBER,'') AS PAY_BK_VERIFYNUMBER,IFNULL(PAY_ADDR1,'') AS PAY_ADDR1,IFNULL(PAY_SOURCE_CODE,'') AS PAY_SOURCE_CODE,B.SWIFT_CODE AS SWIFTCODE ";
		sql += "FROM CAPPAYF A ";
		sql += "LEFT OUTER JOIN ORCHSWFT B ON B.BANK_NO = SUBSTRING(A.PAY_REMIT_BANK,1,3) ";//RE0189:順便解決SWIFT CODE老是有誤的問題
		sql += "WHERE PBATNO=? AND PAY_REMIT_ACCOUNT LIKE ?";
		try{
			if(batNo.substring(0,1).equals("D"))
			{
				//RD0440-新增外幣指定銀行-台灣銀行
				//RE0189-OIU新增外幣指定銀行-凱基。台新OIU的匯款及轉帳為同一檔案,且只有在台新境內DBU/OBU帳號才需產生,故只有使用queryByBatNo的t來查詢資料
				if(batNo.substring(8,11).equals("822") || batNo.substring(8,11).equals("009") || batNo.substring(8,11).equals("004") || batNo.substring(8,11).equals("017") || batNo.substring(8,11).equals("809"))
				{
					if(remitKind.equals("r")) {
						//D:外幣匯款,跨行匯款						
						if(batNo.substring(8,11).equals("017")) {//RD0382-配合OIU業務系統功能調整,新增兆豐017匯款檔(跨行)的產生
							System.out.println("QUERY_BY_BATNO_Remit017:" + QUERY_BY_BATNO_Remit017);
							log.info("QUERY_BY_BATNO_Remit017:" + QUERY_BY_BATNO_Remit017);
							preStmt = conn.prepareStatement(QUERY_BY_BATNO_Remit017);
						} else if(batNo.substring(8,11).equals("809")) { //RE0189:新增凱基
							System.out.println("QUERY_BY_BATNO_Remit809:" + QUERY_BY_BATNO_Remit809);
							log.info("QUERY_BY_BATNO_Remit017:" + QUERY_BY_BATNO_Remit809);
							preStmt = conn.prepareStatement(QUERY_BY_BATNO_Remit809);
						} else {
							System.out.println("QUERY_BY_BATNO_Remit:" + QUERY_BY_BATNO_Remit);
							log.info("QUERY_BY_BATNO_Remit:" + QUERY_BY_BATNO_Remit);
							preStmt = conn.prepareStatement(QUERY_BY_BATNO_Remit);
						}						
					} else {
						//D:外幣匯款,轉帳(同行相存,限RBK的SWIFT CODE第5及6碼為TW)						
						if(batNo.substring(8,11).equals("017")){
							System.out.println("QUERY_BY_BATNO_Trans017:" + QUERY_BY_BATNO_Trans017);
							log.info("QUERY_BY_BATNO_Trans017:" + QUERY_BY_BATNO_Trans017);
							preStmt = conn.prepareStatement(QUERY_BY_BATNO_Trans017);
						} else if(batNo.substring(8,11).equals("809")) { //RE0189:新增凱基
							System.out.println("QUERY_BY_BATNO_Trans809:" + QUERY_BY_BATNO_Trans809);
							log.info("QUERY_BY_BATNO_Trans809:" + QUERY_BY_BATNO_Trans809);
							preStmt = conn.prepareStatement(QUERY_BY_BATNO_Trans809);
						} else {
							System.out.println("QUERY_BY_BATNO_Trans:" + QUERY_BY_BATNO_Trans);
							log.info("QUERY_BY_BATNO_Trans:" + QUERY_BY_BATNO_Trans);
							preStmt = conn.prepareStatement(QUERY_BY_BATNO_Trans);
						}						
					}
					preStmt.setString(1, batNo.substring(8,11));
					preStmt.setString(2, batNo);
					preStmt.setString(3, selCURR);
				}
				else
				{
					System.out.println("QUERY_BY_BATNOD:" + QUERY_BY_BATNOD + ",batNo:" + batNo + ",selCURR:" + selCURR);
					preStmt = conn.prepareStatement(QUERY_BY_BATNOD);
					preStmt.setString(1, batNo);
					preStmt.setString(2, selCURR);
				}
			}
			else
			{	
				System.out.println("QUERY_BY_BATNO:" + QUERY_BY_BATNO);
				preStmt = conn.prepareStatement(QUERY_BY_BATNO);
				preStmt.setString(1,batNo);
			}

			rs = preStmt.executeQuery();

			CaprmtfVO vo = null;
			while(rs.next()) {
				vo = new CaprmtfVO();
                vo.setBATNO(CommonUtil.AllTrim(rs.getString("BATNO")));
				vo.setSEQNO(CommonUtil.AllTrim(rs.getString("SEQNO")));
				vo.setRID(CommonUtil.AllTrim(rs.getString("RID")));
				vo.setRTYPE(CommonUtil.AllTrim(rs.getString("RTYPE")));
				vo.setRBK(CommonUtil.AllTrim(rs.getString("RBK")));
				vo.setRACCT(CommonUtil.AllTrim(rs.getString("RACCT")));
				vo.setRAMT(rs.getInt("RAMT"));
				vo.setRAMTS(CommonUtil.AllTrim(rs.getString("RAMT")));//RC0036-3
				vo.setRNAME(CommonUtil.AllTrim(rs.getString("RNAME")));
				vo.setRMEMO(CommonUtil.AllTrim(rs.getString("RMEMO")));
				vo.setRMTDT(CommonUtil.AllTrim(rs.getString("RMTDT")));
				vo.setRTRNCDE(CommonUtil.AllTrim(rs.getString("RTRNCDE")));
				vo.setRTRNTM(CommonUtil.AllTrim(rs.getString("RTRNTM")));
				vo.setCSTNO(CommonUtil.AllTrim(rs.getString("CSTNO")));
				vo.setRMTCDE(CommonUtil.AllTrim(rs.getString("RMTCDE")));
				vo.setRMTFEE(rs.getInt("RMTFEE"));
				vo.setDept(CommonUtil.AllTrim(rs.getString("DEPT")));//RC0036
				vo.setPBK(CommonUtil.AllTrim(rs.getString("PBK")));//RC0036
				
				if (batNo.substring(0,1).equals("D"))
				{
					vo.setPACCT(CommonUtil.AllTrim(rs.getString("PACCT")));
					vo.setRPAYCURR(CommonUtil.AllTrim(rs.getString("RPAYCURR")));
					vo.setRPAYFEEWAY(CommonUtil.AllTrim(rs.getString("RPAYFEEWAY")));
					vo.setRPAYAMT(rs.getDouble("RPAYAMT"));
					vo.setPENGNAME(CommonUtil.AllTrim(rs.getString("PENGNAME")));
					//vo.setSWIFTCODE(CommonUtil.AllTrim(rs.getString("SWIFTCODE")));//RE0189:順便解決SWIFT CODE老是有誤的問題
					vo.setSWBKNAME(CommonUtil.AllTrim(rs.getString("SWBKNAME")));
					vo.setRBENFEE(rs.getDouble("RBENFEE"));
					vo.setPBK(CommonUtil.AllTrim(rs.getString("PBK")));//R70574
					vo.setRBKCOUNTRY(CommonUtil.AllTrim(rs.getString("RBKCOUNTRY")));
					
					//RD0382:OIU
					try{
						preStmt2 = conn2.prepareStatement(sql);
						preStmt2.setString(1, batNo);
						preStmt2.setString(2, CommonUtil.AllTrim(rs.getString("RACCT")) + "%");
						rs2 = preStmt2.executeQuery();
						if(rs2.next()){
							vo.setPayAddr(CommonUtil.AllTrim(rs2.getString("PAY_ADDR1")));
							vo.setPayBkVerifyNumber(CommonUtil.AllTrim(rs2.getString("PAY_BK_VERIFYNUMBER")));
							vo.setPaySourceCode(CommonUtil.AllTrim(rs2.getString("PAY_SOURCE_CODE")));
							vo.setSWIFTCODE(CommonUtil.AllTrim(rs2.getString("SWIFTCODE")));//RE0189:順便解決SWIFT CODE老是有誤的問題
						}
					} catch(Exception e){
						System.err.println(e.getMessage());
						throw new Exception(e.getMessage());
					} finally {
						try {
							if (rs2 != null) {
								rs2.close();
							}
							if (preStmt2 != null) {
								preStmt2.close();
							}
						} catch (Exception ex1) {
						}
					}
				}
				ret.add(vo);
			}//END While
		} catch(Exception e) {
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
				if (conn != null) {
					dbFactory.releaseAS400Connection(conn);				
				}
				if (conn2 != null) {
					dbFactory.releaseAS400Connection(conn2);				
				}
			} catch (Exception ex1) {
			}
		}
		return ret;
	}	

	//R80300 信用卡新增下載檔案
	public Vector queryByBatNoC(String batNo,String selCURR,String remitKind) throws Exception {
		Vector ret = new Vector();	
		Connection conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(QUERY_BY_BATNOC); 
			preStmt.setString(1, batNo);
			rs = preStmt.executeQuery();
			DISBPaymentDetailVO vo = null;
			while(rs.next()) {
				vo = new DISBPaymentDetailVO();
				vo.setStrPNO(CommonUtil.AllTrim(rs.getString("PNO")));
				vo.setIPDate(rs.getInt("PDATE"));
				vo.setIPAMT(rs.getDouble("PAMT"));
				vo.setStrPCrdNo(CommonUtil.AllTrim(rs.getString("PCRDNO")));
				vo.setStrPCrdType(CommonUtil.AllTrim(rs.getString("PCRDTYPE")));
				vo.setIPAuthDt(rs.getInt("PAUTHDT"));
				vo.setStrPAuthCode(CommonUtil.AllTrim(rs.getString("PAUTHCODE")));
				vo.setStrPCrdEffMY(CommonUtil.AllTrim(rs.getString("PCRDEFFMY")));
				vo.setStrPolicyNo(CommonUtil.AllTrim(rs.getString("POLICYNO")));
				vo.setStrBatNo(CommonUtil.AllTrim(rs.getString("PBATNO")));
				vo.setIPCshDt(rs.getInt("PCSHDT"));
				vo.setIPOrgAMT(rs.getDouble("PORGAMT"));
				vo.setStrPOrgCrdNo(CommonUtil.AllTrim(rs.getString("PORGCRDNO")));
				ret.add(vo);
			}
		} catch(Exception e) {
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
				if (conn != null) {
					dbFactory.releaseAS400Connection(conn);				
				}
			} catch (Exception ex1) {
			}
		}
		return ret;
	}

	//自 DbFactory 中取得一個 Connection
	private Connection getConnection() throws SQLException {
		//先取得資料庫連結及準備SQL
    	return dbFactory.getConnection(DISBRemitDisposeDAO.class+".getConnection()");
	}

}