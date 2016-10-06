package com.aegon.disb.disbreports;

import java.sql.*;
import java.util.Vector;

import com.aegon.comlib.*;
import com.aegon.disb.disbcheck.CAPCheckVO;
import com.aegon.disb.disbremit.CAPPaymentVO;
import com.aegon.disb.util.DISBPaymentDetailVO;
/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.9 $$
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBPaymentNoticeDAO.java,v $
 * $Revision 1.9  2014/02/26 07:16:11  misariel
 * $EB0536-BC264 沛利多利率變動型養老保險SIE
 * $
 * $Revision 1.8  2013/12/27 03:42:50  MISSALLY
 * $EB0194-PB0016---新增可修改給付通知書的收件人
 * $
 * $Revision 1.7  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255利率變動型即期年金保險專案
 * $
 * $Revision 1.2  2013/04/15 01:13:24  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.6  2013/02/26 10:19:12  ODCWilliam
 * $william wu
 * $RA0074
 * $
 * $Revision 1.5  2009/11/11 06:20:13  missteven
 * $R90474 修改CASH功能
 * $
 * $Revision 1.4  2007/04/20 03:13:00  MISODIN
 * $R60713 FOR AWD
 * $
 * $Revision 1.3  2007/01/04 03:17:35  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.2  2006/12/05 10:21:04  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.1  2006/06/29 09:40:39  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.11  2006/04/27 09:27:21  misangel
 * $R50891:VA美元保單-顯示幣別
 * $
 * $Revision 1.1.2.10  2005/10/14 07:49:34  misangel
 * $R50820:支付功能提升
 * $
 * $Revision 1.1.2.8  2005/04/12 10:08:05  miselsa
 * $R30530_支付通知書
 * $
 * $Revision 1.1.2.7  2005/04/12 07:50:18  miselsa
 * $R30530_支付通知書
 * $
 * $Revision 1.1.2.6  2005/04/12 03:14:12  miselsa
 * $R30530_修改取所屬部門資料的JOIN SQL
 * $
 * $Revision 1.1.2.5  2005/04/04 07:02:19  miselsa
 * $R30530 支付系統
 * $$
 *  
 */
public class DISBPaymentNoticeDAO {
	private PreparedStatement preStmt;
	private ResultSet rs = null;
	private DbFactory dbFactory = null ;
  
	private final String QUERY = "SELECT PNO,PMETHOD,POLICYNO,APPNO,PNAME,PID,PAMT,PDESC,PSTATUS,PVOIDABLE,PDISPATCH,ENTRYDT,ENTRYUSR,PCURR" 
								+" FROM CAPPAYF  "
								+" WHERE " 
								+" PAY_CONFIRM_DATE1 <>0 "
								+" AND POLICYNO =? order by ENTRYDT DESC";
																
	private final String QUERYDept = "SELECT A.PNO,A.PMETHOD,A.POLICYNO,A.APPNO,A.PNAME,A.PID,A.PAMT,A.PDESC,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.ENTRYDT,A.ENTRYUSR,A.PCURR" 
								+" FROM CAPPAYF  A"
								//+ "  join CAPDEPF B  on B.PAY_SOURCE_CODE=A.PAY_SOURCE_CODE "
             	                + "  join USER B  on B.USRID=A.ENTRY_USER  "
								+" WHERE " 
								+" A.PAY_CONFIRM_DATE1 <>0 "
	                            +" AND A.POLICYNO =?  AND B.DEPT=? order by A.ENTRYDT DESC";
								//+" AND A.POLICYNO =?  AND B.PAY_DEPT=? order by A.ENTRYDT DESC";
		// R60713														
	private final String QUERYDeptZ = "SELECT A.PNO,A.POLICYNO,A.APPNM,A.INSNM,A.UPDDT,A.UPDUSR" 
								+" FROM CAPPAYRF  A"
								+ "  join USER B  on B.USRID=A.UPDUSR  "
								+" WHERE A.PNO NOT IN(SELECT PNO FROM CAPPAYF) " 
	                            +" AND A.POLICYNO =?  AND B.DEPT=? order by A.UPDDT ";
								
	private final String QUERYUser = "SELECT PNO,PMETHOD,POLICYNO,APPNO,PNAME,PID,PAMT,PDESC,PSTATUS,PVOIDABLE,PDISPATCH,ENTRYDT,ENTRYUSR,PCURR" 
								+" FROM CAPPAYF  "
								+" WHERE " 
								+" PAY_CONFIRM_DATE1 <>0 "
								+" AND POLICYNO =?  AND ENTRY_USER=? order by ENTRYDT DESC";
																							
	private final String QUERY_NOTICE = "SELECT A.PNO,A.POLICYNO,A.APPNM,A.INSNM,A.RECEIVER,A.MAILZIP,A.MAILAD,A.HMZIP,A.HMAD,A.SRVNM,A.SNDNM, "
									+" A.SRVBH,A.ITEM,A.DEFAMT,A.DIVAMT,A.LOAN,A.UNPRDPRM,A.REVPRM,A.CURPRM,A.PEWD,A.PEAMT,A.LANCAP,A.LANINT,"
									+" A.APL,A.APLINT,A.OFFWD,A.OFFAMT,A.OFFWD1,A.OFFAMT1,A.OFFWD2,A.OFFAMT2,A.OFFWD3,A.OFFAMT3,A.UPDUSR,A.ANNAMT,"
									+" B.PMETHOD,B.PAMT,B.PCHECKNO,B.PCRDNO,B.PRBANK,B.PRACCOUNT,B.PCFMDT1,A.OVRRTN,B.PCURR,"
/*****/           +" IFNULL(ph.FLD0154,'') as DIVTYPE,"  
									+" C.CUSEDT,D.BKFNM,D.BKNM,B.PPAYCURR,B.PPAYAMT,S.BANK_NAME AS PBKNAME,A.UPDDT"
									+" FROM CAPPAYRF A" 
									+" LEFT OUTER JOIN CAPPAYF B on B.PNO = A.PNO"
									+" LEFT OUTER JOIN CAPCHKF C ON B.PCHECKNO = C.CNO"		
									+" LEFT OUTER JOIN CAPCCBF  D ON D.BKNO = B.PRBANK"
									+" LEFT OUTER JOIN ORCHSWFT S ON B.PSWIFT = S.SWIFT_CODE"//R60550
/*****/           +" LEFT OUTER JOIN ORDUPO PO ON PO.FLD0001='  ' AND PO.FLD0002 = B.POLICYNO"
/*****/           +" LEFT OUTER JOIN ORDUPH PH ON PH.FLD0001='  ' AND PH.FLD0002=PO.FLD0015 AND PH.FLD0003=PO.FLD0016"
									+" WHERE A.PNO=?"; 
	// R60713
	private final String QUERY_NOTICE_Z = "SELECT A.PNO,A.POLICYNO,A.APPNM,A.INSNM,A.RECEIVER,A.MAILZIP,A.MAILAD,A.HMZIP,A.HMAD,A.SRVNM,A.SNDNM, "
									+" A.SRVBH,A.ITEM,A.DEFAMT,A.DIVAMT,A.LOAN,A.UNPRDPRM,A.REVPRM,A.CURPRM,A.PEWD,A.PEAMT,A.LANCAP,A.LANINT,"
									+" A.APL,A.APLINT,A.OFFWD,A.OFFAMT,A.OFFWD1,A.OFFAMT1,A.OFFWD2,A.OFFAMT2,A.OFFWD3,A.OFFAMT3,A.UPDUSR,A.ANNAMT,"
									+" A.OVRRTN,A.UPDDT,A.SNDNM,B.FLD0055" 
									+" FROM CAPPAYRF A "
									+" LEFT OUTER JOIN ORDUPO B ON B.FLD0001='  ' and B.FLD0002=A.POLICYNO "
									+" WHERE PNO=?";
									 																									 																
	private final String UPDATE = "UPDATE CAPPAYRF "
								+" SET   "
								+" MAILZIP =?,"
								+" MAILAD  =?,"    
								+" HMZIP   =?,"     
								+" HMAD    =?,"
								+" ITEM  =?,"
								+" DEFAMT=?,"
								+" DIVAMT=? ,"     
								+" LOAN  =?,"
								+" UNPRDPRM=?,"       
								+" REVPRM  =?,"
								+" CURPRM  =?,"
								+" PEWD    =?,"
								+" PEAMT   =?,"
								+" LANCAP  =?,"
								+" LANINT  =?,"
								+" APL     =?,"
								+" APLINT =?,"
								+" OFFWD  =? ,"      
								+" OFFAMT =?, "
								+" OFFWD1  =? ,"//R90474      
								+" OFFAMT1 =?, "//R90474
								+" OFFWD2  =? ,"//R90474      
								+" OFFAMT2 =?, "//R90474
								+" OFFWD3  =? ,"//R90474      
								+" OFFAMT3 =?, "//R90474
	                            +" OVRRTN =?, "
								+" SNDNM=?, "
								+" UPDUSR=?, "
								+" RECEIVER=?,"
								+" ANNAMT=? "
								+" WHERE PNO=? ";

	public DISBPaymentNoticeDAO(DbFactory factory){
		this.dbFactory = factory;
	}
	/**
	 * 
	 * @param POLICYNO
	 * @return
	 * @throws SQLException
	 */
	public Vector query(String POLICYNO)throws SQLException{
		Connection conn = this.getConnection();		
		Vector ret = new Vector();
		try{
			preStmt = conn.prepareStatement(QUERY);
			preStmt.setString(1, POLICYNO);
			rs = preStmt.executeQuery();
			while(rs.next()){
				ret.add(new CAPPaymentVO(rs));
			}		
		}catch(SQLException e){
			System.err.println(e.getMessage());
			throw new SQLException(e.getMessage());
		}finally{
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
	/**
	 * 
	 * @param PNO
	 * @return
	 * @throws SQLException
	 */
	public CAPPAYReportVO queryNotice(String PNO)throws SQLException{
		Connection conn = this.getConnection();		
		CAPPAYReportVO ret = null;
		try{
			System.out.println("QUERY_NOTICE="+QUERY_NOTICE);
			preStmt = conn.prepareStatement(QUERY_NOTICE);
			preStmt.setString(1, PNO);
			rs = preStmt.executeQuery();
			if(rs.next()){
				ret = new CAPPAYReportVO(rs);
				CAPPaymentVO payment = new CAPPaymentVO();
				payment.setPMethod(rs.getString("PMETHOD"));
				payment.setPCurr(rs.getString("PCURR"));
				payment.setPAMT(rs.getInt("PAMT"));
				payment.setPCheckNO(rs.getString("PCHECKNO"));
				payment.setPCrdNo(rs.getString("PCRDNO"));
				payment.setPRBank(rs.getString("PRBANK") + rs.getString("BKFNM"));
//				payment.setPRBank(rs.getString("PRBANK") + rs.getString("BKNM"));
//				System.out.println("PRBANK="+rs.getString("PRBANK") + rs.getString("BKFNM"));
				payment.setPRAccount(rs.getString("PRACCOUNT"));
				payment.setPCfmDt1(rs.getInt("PCFMDT1"));
				//R60550
				payment.setPPAYAMT(rs.getDouble("PPAYAMT"));
				payment.setPPAYCURR(rs.getString("PPAYCURR"));
				payment.setPBKNAME(rs.getString("PBKNAME"));
				//R60550END			
				CAPCheckVO checkVO = new CAPCheckVO();
				checkVO.setCUSEDT(rs.getInt("CUSEDT"));
				payment.setPaymentCheck(checkVO);
				ret.setPayment(payment);
			}		
		}catch(SQLException e){
			System.err.println(e.getMessage());
			throw new SQLException(e.getMessage());
		}finally{
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
	/**
	 * 
	 * @param PNO
	 * @return
	 * @throws SQLException
	 */
	// R60713
	public CAPPAYReportVO queryNoticeZ(String PNO)throws SQLException{
		Connection conn = this.getConnection();		
		CAPPAYReportVO ret = null;
		try{
			System.out.println("QUERY_NOTICE_Z="+QUERY_NOTICE_Z);
			preStmt = conn.prepareStatement(QUERY_NOTICE_Z);
			preStmt.setString(1, PNO);
			rs = preStmt.executeQuery();
			if(rs.next()){
				ret = new CAPPAYReportVO(rs);
				CAPPaymentVO payment = new CAPPaymentVO();
				payment.setPCurr(rs.getString("FLD0055"));
				ret.setPayment(payment);
			}		
		}catch(SQLException e){
			System.err.println(e.getMessage());
			throw new SQLException(e.getMessage());
		}finally{
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
	/**
	 * 
	 * @param vo
	 * @return  
	 * @throws SQLException
	 */
	public int update(CAPPAYReportVO vo)throws SQLException{
		int ret = 0;
		Connection conn = this.getConnection();
		try{
			preStmt = conn.prepareStatement(UPDATE);
			System.out.println("DISBPaymenNoticeDAO_update_sql="+UPDATE + "--vo.getITEM()="+vo.getITEM());
			preStmt.setString(1,vo.getMAILZIP());
			preStmt.setString(2,vo.getMAILAD());
			preStmt.setString(3,vo.getHMZIP());
			preStmt.setString(4,vo.getHMAD());
			preStmt.setString(5,vo.getITEM());
			preStmt.setDouble(6,vo.getDEFAMT());
			preStmt.setDouble(7,vo.getDIVAMT());
			preStmt.setDouble(8,vo.getLOAN());
			preStmt.setDouble(9,vo.getUNPRDPRM());
			preStmt.setDouble(10,vo.getREVPRM());
			preStmt.setDouble(11,vo.getCURPRM());
			preStmt.setString(12,vo.getPEWD());
			preStmt.setDouble(13,vo.getPEAMT());
			preStmt.setDouble(14,vo.getLANCAP());
			preStmt.setDouble(15,vo.getLANINT());
			preStmt.setDouble(16,vo.getAPL());
			preStmt.setDouble(17,vo.getAPLINT());
			preStmt.setString(18,vo.getOFFWD());
			preStmt.setDouble(19,vo.getOFFAMT());
			preStmt.setString(20,vo.getOFFWD1());
			preStmt.setDouble(21,vo.getOFFAMT1());
			preStmt.setString(22,vo.getOFFWD2());
			preStmt.setDouble(23,vo.getOFFAMT2());
			preStmt.setString(24,vo.getOFFWD3());
			preStmt.setDouble(25,vo.getOFFAMT3());			
			preStmt.setDouble(26,vo.getOVRRTN());
			preStmt.setString(27,vo.getSNDNM());	
			preStmt.setString(28,vo.getUPDUSR());
			preStmt.setString(29,vo.getRECEIVER());
			preStmt.setDouble(30,vo.getANNAMT());
			preStmt.setString(31,vo.getPNO());
			ret = preStmt.executeUpdate();

		}catch(SQLException e){
			System.err.println(e.getMessage());
			throw new SQLException(e.getMessage());
		}finally{
			try {
			
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
	private Connection getConnection()throws SQLException{
		
		//先取得資料庫連結及準備SQL
    	return dbFactory.getConnection(DISBPaymentNoticeDAO.class+".DataClass.getConnection()");
	}

	public Vector query(String POLICYNO, String LogonUser, String UserDept, String UserRight) throws SQLException {
		Connection conn = this.getConnection();
		Vector ret = new Vector();
		try {
			System.out.println("UserRight=" + Integer.parseInt(UserRight.trim()));
			System.out.println("QUERYDept=" + QUERYDept);
			preStmt = conn.prepareStatement(QUERYDept);
			preStmt.setString(1, POLICYNO);
			preStmt.setString(2, UserDept);
			rs = preStmt.executeQuery();
			while (rs.next()) {
				ret.add(new CAPPaymentVO(rs));
			}
		} catch (SQLException e) {
			System.err.println(e.getMessage());
			throw new SQLException(e.getMessage());
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

	public Vector queryZ(String POLICYNO, String LogonUser, String UserDept, String UserRight) throws SQLException {
		Connection conn = this.getConnection();
		Vector ret = new Vector();
		try {
			System.out.println("QUERYDeptZ=" + QUERYDeptZ);
			preStmt = conn.prepareStatement(QUERYDeptZ);
			preStmt.setString(1, POLICYNO);
			preStmt.setString(2, UserDept);

			rs = preStmt.executeQuery();
			while (rs.next()) {
				ret.add(new CAPPAYReportVO(rs));
			}
		} catch (SQLException e) {
			System.err.println(e.getMessage());
			throw new SQLException(e.getMessage());
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
		
}
