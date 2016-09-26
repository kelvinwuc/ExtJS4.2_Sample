package com.aegon.disb.disbmaintain;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * System   : CashWeb
 * 
 * Function : 國外SWIFT CODE
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.1 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date : 2013/03/07 
 * 
 * Request ID : RA0074
 * 
 * CVS History:
 * 
 * $$Log: DISBSwiftCodeDAO.java,v $
 * $Revision 1.1  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $$
 *  
 */

public class DISBSwiftCodeDAO {

	private ResultSet rst = null;
	private PreparedStatement preStmt = null;
	private Connection conn = null;

	private final String DELETE_ALL = "DELETE FROM ORCHSWFT ";

	private final String DELETE = "DELETE FROM ORCHSWFT WHERE BANK_NO = ? ";

	private final String UPDATE = "UPDATE ORCHSWFT "
			+ " SET SWIFT_CODE = ?, BANK_NAME = ?,UPDATE_DATE = ?,UPDATE_ID = ? "
			+ " WHERE BANK_NO = ? ";

	private final String INSERT = "INSERT INTO ORCHSWFT VALUES (?,?,?,?,?,'0','') ";

	private final String QUERY = "SELECT * FROM ORCHSWFT WHERE BANK_NO = ? ";
	
	public DISBSwiftCodeDAO() {
	}

	public int insert(CAPswiftVO swiftVo) throws SQLException {
		int ret = 0;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(INSERT);
			preStmt.setString(1, swiftVo.getBankNo());
			preStmt.setString(2, swiftVo.getSwiftCode());
			preStmt.setString(3, swiftVo.getBankName());
			preStmt.setString(4, swiftVo.getEntryDate());
			preStmt.setString(5, swiftVo.getEntryID());
			ret = preStmt.executeUpdate();
			System.out.println("INSERT ORCHSWFT (" + swiftVo.getBankNo() + ") 共" + ret + "筆.");
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}
		return ret;
	}

	public int update(CAPswiftVO swiftVo) throws SQLException {
		int ret = 0;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(UPDATE);
			preStmt.setString(1, swiftVo.getSwiftCode());
			preStmt.setString(2, swiftVo.getBankName());
			preStmt.setString(3, swiftVo.getUpdateDate());
			preStmt.setString(4, swiftVo.getUpdateID());
			preStmt.setString(5, swiftVo.getBankNo());
			ret = preStmt.executeUpdate();
			System.out.println("UPDATE ORCHSWFT (" + swiftVo.getBankNo() + ") 共" + ret + "筆.");
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}
		return ret;
	}

	public int delete(CAPswiftVO swiftVo) throws SQLException {
		int ret = 0;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(DELETE);
			preStmt.setString(1, swiftVo.getBankNo());
			ret = preStmt.executeUpdate();
			System.out.println("DELETE ORCHSWFT (" + swiftVo.getBankNo() + ") 共" + ret + "筆.");
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}
		return ret;
	}

	public int deleteAll() throws SQLException {
		int ret = 0;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(DELETE_ALL);
			ret = preStmt.executeUpdate();
			System.out.println("DELETE ORCHSWFT 共" + ret + "筆.");
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}
		return ret;
	}

	public boolean query(String bkno) throws SQLException {
		boolean ret = false;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(QUERY);
			preStmt.setString(1, bkno);
			rst = preStmt.executeQuery();
			ret = rst.next();
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (rst != null) rst.close(); } catch (Exception ex1) { }
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}
		return ret;
	}

	public void setConnection(Connection c) {
		conn = c;
	}

	private Connection getConnection() throws SQLException {
		return conn;
	}

}