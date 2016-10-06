package com.aegon.bankinfo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * System   : CashWeb
 * 
 * Function : 金融單位資料維護 DAO
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : MISSALLY
 * 
 * Create Date : 2013/6/13
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * RD0382-OIU專案:20150909,Kelvin Wu,新增【帳戶所屬公司別】
 * 
 * $Log: BankInfoDAO.java,v $
 * Revision 1.1  2013/12/24 02:14:03  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */

public class BankInfoDAO {
	private ResultSet rst = null;
	private PreparedStatement preStmt = null;
	private Connection conn = null;

	private final String querySql = "SELECT * FROM CAPBNKF WHERE BKCODE=? and BKATNO=? and GLACT=? and BKCURR=? ";

	private final String insertSql = "INSERT INTO CAPBNKF (BKCODE, BKNAME, BkAtNo, BKCURR, GlAct, BkAlat, BkCred, BkPacb, BkBatc, BkAdUs, BkAdDt, BkAdTm, BkGpCd, BKSpec, BKStat, BKMemo, COMPANY) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";//RD0382

	private final String updateSql = "UPDATE CAPBNKF SET BKNAME=?, BkAlat=?, BkCred=?, BkPacb=?, BkBatc=?, BkUpUs=?, BkUpDt=?, BkUpTm=?, BkGpCd=?, BKSpec=?, BKStat=?, BKMemo =? ,COMPANY=? WHERE BKCODE=? and BKATNO=? and GLACT=? and BKCURR=? ";//RD0382

	private final String deleteSql = "DELETE FROM CAPBNKF WHERE BKCODE=? and BKATNO=? and GLACT=? and BKCURR=? ";

	protected CapbnkfVO query(CapbnkfVO vo) throws SQLException {

		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(querySql);
			preStmt.setString(1, vo.getBankCode());
			preStmt.setString(2, vo.getBankAccount());
			preStmt.setString(3, vo.getBankGlAct());
			preStmt.setString(4, vo.getBankCurr());

			rst = preStmt.executeQuery();
			if(rst.next()) {
				vo.setBankName(rst.getString("BKNAME"));
				vo.setBankAlat(rst.getString("BKALAT"));
				vo.setBankCred(rst.getString("BKCRED"));
				vo.setBankPacb(rst.getString("BKPACB"));
				vo.setBankBatc(rst.getString("BKBATC"));
				vo.setBankGpCd(rst.getString("BKGPCD"));
				vo.setBankSpec(rst.getString("BKSPEC"));
				vo.setBankStatus(rst.getString("BKSTAT"));
				vo.setBankMemo(rst.getString("BKMEMO"));
			} else {
				vo = null;
			}

		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (rst != null) rst.close(); } catch (Exception ex1) { }
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}

		return vo;
	}
	
	protected boolean insert(CapbnkfVO vo) throws SQLException {
		boolean bReturn = false;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(insertSql);
			preStmt.setString(1, vo.getBankCode());
			preStmt.setString(2, vo.getBankName());
			preStmt.setString(3, vo.getBankAccount());
			preStmt.setString(4, vo.getBankCurr());
			preStmt.setString(5, vo.getBankGlAct());
			preStmt.setString(6, vo.getBankAlat());
			preStmt.setString(7, vo.getBankCred());
			preStmt.setString(8, vo.getBankPacb());
			preStmt.setString(9, vo.getBankBatc());
			preStmt.setString(10, vo.getCreateUser());
			preStmt.setString(11, vo.getCreateDate());
			preStmt.setString(12, vo.getCreateTime());
			preStmt.setString(13, vo.getBankGpCd());
			preStmt.setString(14, vo.getBankSpec());
			preStmt.setString(15, vo.getBankStatus());
			preStmt.setString(16, vo.getBankMemo());
			preStmt.setString(17, vo.getCompanyType());//RD0382
			
			int ret = preStmt.executeUpdate();

			bReturn = (ret == 1);
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}

		return bReturn;
	}

	protected boolean update(CapbnkfVO vo) throws SQLException {
		boolean bReturn = false;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(updateSql);
			preStmt.setString(1, vo.getBankName());
			preStmt.setString(2, vo.getBankAlat());
			preStmt.setString(3, vo.getBankCred());
			preStmt.setString(4, vo.getBankPacb());
			preStmt.setString(5, vo.getBankBatc());
			preStmt.setString(6, vo.getUpdatedUser());
			preStmt.setString(7, vo.getUpdatedDate());
			preStmt.setString(8, vo.getUpdatedTime());
			preStmt.setString(9, vo.getBankGpCd());
			preStmt.setString(10, vo.getBankSpec());
			preStmt.setString(11, vo.getBankStatus());
			preStmt.setString(12, vo.getBankMemo());
			preStmt.setString(13, vo.getCompanyType());//RD0382
			preStmt.setString(14, vo.getBankCode());
			preStmt.setString(15, vo.getBankAccount());
			preStmt.setString(16, vo.getBankGlAct());
			preStmt.setString(17, vo.getBankCurr());
			

			int ret = preStmt.executeUpdate();

			bReturn = (ret == 1);
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}

		return bReturn;
	}

	protected boolean delete(CapbnkfVO vo) throws SQLException {
		boolean bReturn = false;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(deleteSql);
			preStmt.setString(1, vo.getBankCode());
			preStmt.setString(2, vo.getBankAccount());
			preStmt.setString(3, vo.getBankGlAct());
			preStmt.setString(4, vo.getBankCurr());

			int ret = preStmt.executeUpdate();

			bReturn = (ret == 1);
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}

		return bReturn;
	}
	
	public void setConnection(Connection c) {
		conn = c;
	}

	private Connection getConnection() throws SQLException {
		return conn;
	}
}

