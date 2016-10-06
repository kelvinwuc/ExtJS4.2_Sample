package com.aegon.disb.disbmaintain;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.apache.log4j.Logger;

/**
 * System   : CashWeb
 * 
 * Function : �ꤺ������
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.4 $$
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCAPccbfDAO.java,v $
 * $Revision 1.4  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE�����ͦs�����q�H�b��ε��I
 * $
 * $Revision 1.3  2012/06/18 09:35:41  MISSALLY
 * $QA0132-�����ɮפ� SWIFT CODE�ɮ׺��@
 * $1.�\��u�s�W����X�v�W�[�ˮ֤��o���ŭȡC
 * $2.�\��u����Ȧ��ɡv
 * $   2.1��~SWIFT CODE�e�����áC
 * $   2.2�W�[�ˮ֤��o�W�Ǫ��ɡC
 * $   2.3�W�[�ˮ֪���N�X���ץ�����7��Ʀr�A�_�h��ܥ��Ѫ��O���F�Y����ɦ����~�T���h��������s�A�B��ܥ��Ѫ��O���C
 * $$
 *  
 */

public class DISBCAPccbfDAO {
	
	private Logger log = Logger.getLogger(getClass());
	
	private PreparedStatement preStmt = null;
	private Connection conn = null;

	private final String DELETE_ALL = "DELETE FROM CAPCCBF ";

	private final String DELETE = "DELETE FROM CAPCCBF WHERE BKNO=? ";

	private final String UPDATE = "UPDATE CAPCCBF "
			+ " SET BKNM =? , BKFNM =? ,ENTRYDT=?,ENTRYTM=?,ENTRYUSR=? "
			+ " WHERE BKNO=? ";

	private final String INSERT = "INSERT INTO CAPCCBF VALUES (?,?,?,?,?,?) ";

	public DISBCAPccbfDAO() {
	}
	
	public int update(CAPccbfVO ccbfVo) throws SQLException {
		int ret = 0;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(UPDATE);
			preStmt.setString(1, ccbfVo.getBKNM());
			preStmt.setString(2, ccbfVo.getBKFNM());
			preStmt.setString(6, ccbfVo.getBKNO());
			preStmt.setInt(3, ccbfVo.getENTRYDT());
			preStmt.setInt(4, ccbfVo.getENTRYTM());
			preStmt.setString(5, ccbfVo.getENTRYUSR());
			ret = preStmt.executeUpdate();
			System.out.println("UPDATE CAPCCBF (" + ccbfVo.getBKNO() + ") �@" + ret + "��.");
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}
		return ret;
	}

	public int insert(CAPccbfVO ccbfVo) throws SQLException {
		int ret = 0;
		conn = this.getConnection();
		try {
			log.info("sql:" + INSERT + "," + ccbfVo.getBKNO() + "," + ccbfVo.getBKNM() + "," + ccbfVo.getBKFNM() + "," + ccbfVo.getENTRYDT() + "," + ccbfVo.getENTRYTM() + "," + ccbfVo.getENTRYUSR());
			//ccbfVo.setBKNM("");
			preStmt = conn.prepareStatement(INSERT);
			preStmt.setString(1, ccbfVo.getBKNO());
			preStmt.setString(2, ccbfVo.getBKNM());
			preStmt.setString(3, ccbfVo.getBKFNM());
			preStmt.setInt(4, ccbfVo.getENTRYDT());
			preStmt.setInt(5, ccbfVo.getENTRYTM());
			preStmt.setString(6, ccbfVo.getENTRYUSR());			
			ret = preStmt.executeUpdate();
			System.out.println("INSERT CAPCCBF (" + ccbfVo.getBKNO() + ") �@" + ret + "��.");
			log.info("INSERT CAPCCBF (" + ccbfVo.getBKNO() + ") �@" + ret + "��.");
		} catch (Exception e) {
			System.err.println(e.getMessage());
			log.error(e.getMessage(), e);
		} finally {
			try { if (preStmt != null) preStmt.close(); } catch (Exception ex1) { }
		}
		return ret;
	}

	public int delete(CAPccbfVO ccbfVo) throws SQLException {
		int ret = 0;
		conn = this.getConnection();
		try {
			preStmt = conn.prepareStatement(DELETE);
			preStmt.setString(1, ccbfVo.getBKNO());			
			ret = preStmt.executeUpdate();
			System.out.println("DELETE CAPCCBF (" + ccbfVo.getBKNO() + ") �@" + ret + "��.");
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
			System.out.println("DELETE CAPCCBF �@" + ret + "��.");
		} catch (Exception e) {
			System.err.println(e.getMessage());
		} finally {
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