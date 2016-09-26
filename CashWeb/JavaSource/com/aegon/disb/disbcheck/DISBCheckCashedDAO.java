package com.aegon.disb.disbcheck;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.aegon.comlib.DbFactory;
import com.aegon.disb.disbremit.CAPPaymentVO;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckCashedDAO.java,v $
 * $Revision 1.2  2013/12/24 02:17:18  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.1  2006/06/29 09:40:38  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:23  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBCheckCashedDAO {
	private PreparedStatement preStmt;
	private ResultSet rs = null;
	private DbFactory dbFactory = null;

	private final String QUERY = "SELECT POLICYNO,APPNO,PNAME,PID,PAMT,PDESC,PDATE,PMETHOD,PDISPATCH,PCHECKNO "
			+ " FROM CAPPAYF,capchkf "
			+ " WHERE CAPPAYF.PNO = capchkf.PNO AND CBKNO=? AND CACCOUNT=? AND CNO=? ";

	private final String UPDATE = "UPDATE CAPCHKF "
			+ " SET CSTATUS =?, CASHDT =?, CRTNDT=?, CCASHDT=? "
			+ " WHERE CBKNO=? AND CACCOUNT=? AND int(trim(substr(CNO,3,16)))=? AND CAMT=? AND CSTATUS=?";

	private final String UPDATE_FAILCHK = "UPDATE CAPCHKF " + " SET CERFLG =? "
			+ " WHERE CBKNO=? AND CACCOUNT=? AND CNO=? ";

	public DISBCheckCashedDAO(DbFactory factory) {
		this.dbFactory = factory;
	}

	public CAPPaymentVO query(CAPCheckVO vo) throws SQLException {
		Connection conn = this.getConnection();
		CAPPaymentVO ret = new CAPPaymentVO();
		try {
			preStmt = conn.prepareStatement(QUERY);
			preStmt.setString(1, vo.getCBKNO());
			preStmt.setString(2, vo.getCACCOUNT());
			preStmt.setString(3, vo.getCNO());
			rs = preStmt.executeQuery();
			if (rs.next()) {
				ret.setPolicyNo(rs.getString("POLICYNO"));
				ret.setPolicyNo(rs.getString("APPNO"));
				ret.setPName(rs.getString("PNAME"));
				ret.setPId(rs.getString("PID"));
				ret.setPAMT(rs.getInt("PAMT"));
				ret.setPDesc(rs.getString("PDESC"));
				ret.setPDate(rs.getInt("PDATE"));
				ret.setPMethod(rs.getString("PMETHOD"));
				ret.setPDispatch(rs.getString("PDISPATCH"));
				ret.setPCheckNO(rs.getString("PCHECKNO"));
			} else {
				ret.setPCheckNO(vo.getCNO());
				ret.setPAMT(vo.getCAMT());
			}
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
				if (conn != null) {
					dbFactory.releaseAS400Connection(conn);
				}
			} catch (Exception ex1) {
			}
		}
		return ret;
	}

	public int update(CAPCheckVO checkVo) throws SQLException {
		int ret = 0;
		Connection conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(UPDATE);
			preStmt.setString(1, "C");
			preStmt.setInt(2, checkVo.getCASHDT());
			preStmt.setInt(3, checkVo.getCRTNDT());
			preStmt.setInt(4, checkVo.getCCASHDT());
			preStmt.setString(5, checkVo.getCBKNO());
			preStmt.setString(6, checkVo.getCACCOUNT());
			preStmt.setString(7, checkVo.getCNO());
			preStmt.setDouble(8, checkVo.getCAMT());
			preStmt.setString(9, "D");
			ret = preStmt.executeUpdate();
			if (ret < 1) {
				preStmt = conn.prepareStatement(UPDATE_FAILCHK);
				preStmt.setString(1, "Y");
				preStmt.setString(2, checkVo.getCBKNO());
				preStmt.setString(3, checkVo.getCACCOUNT());
				preStmt.setInt(4, Integer.parseInt(checkVo.getCNO()));
				preStmt.executeUpdate();
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
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

	// 自 DbFactory 中取得一個 Connection
	private Connection getConnection() throws SQLException {

		// 先取得資料庫連結及準備SQL
		return dbFactory.getConnection(DISBCheckCashedDAO.class + ".DataClass.getConnection()");
	}

}