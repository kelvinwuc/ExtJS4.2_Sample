package com.aegon.entCroInq;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import com.aegon.comlib.DbFactory;

public class EntCroInqDAO {
	private DbFactory dbFactory = null;

	private final String QUERY = "select EBKCD, EATNO, EBKRMD, ENTAMT, EAEGDT, ECRDAY,EUSREM,EUSREM2,CSHFCURR,CROTYPE from CAPCSHF where 1=1 ";

	public EntCroInqDAO(DbFactory factory) {
		this.dbFactory = factory;
	}

	public Vector query(EntCroInqVO vo) {
		Vector retVector = new Vector();
		Connection conn = null;
		PreparedStatement preStmt = null;
		ResultSet rs = null;
		try {
			String sql = "select EBKCD, EATNO, EBKRMD, ENTAMT, EAEGDT, ECRDAY,EUSREM,EUSREM2,CSHFCURR,CROTYPE from CAPCSHF where 1=1 ";

			if (vo.getEBKCD() != null && !"".equals(vo.getEBKCD()))
				sql = sql + " and EBKCD='" + vo.getEBKCD() + "'";
			if (vo.getEATNO() != null && !"".equals(vo.getEATNO()))
				sql = sql + " and EATNO='" + vo.getEATNO() + "'";
			if (vo.getEBKRMD() != null && !"".equals(vo.getEBKRMD()))
				sql = sql + " and EBKRMD >=" + removeChar(vo.getEBKRMD(), '/');
			if (vo.getEBKRMD2() != null && !"".equals(vo.getEBKRMD2()))
				sql = sql + " and EBKRMD <=" + removeChar(vo.getEBKRMD2(), '/');
			if (vo.getENTAMT() > 0)
				sql = sql + " and ENTAMT=" + vo.getENTAMT();
			if (vo.getCSHFCURR() != null && !"".equals(vo.getCSHFCURR()))
				sql = sql + " and CSHFCURR='" + vo.getCSHFCURR() + "'";

			sql = sql + " order by EBKCD, EATNO,CSHFCURR, EBKRMD, ENTAMT";
			System.out.println("EntCroInqDAO.query=" + sql);

			conn = dbFactory.getAS400Connection("EntCroInqDAO.query");
			preStmt = conn.prepareStatement(sql);
			for (rs = preStmt.executeQuery(); rs.next(); retVector.add(new EntCroInqVO(rs)));
		} catch (Exception e) {
			System.err.println(e.getMessage());
			dbFactory.releaseAS400Connection(conn);
		} finally {
			try { if (rs != null) rs.close(); } catch (SQLException e) {}
			try { if (preStmt != null) preStmt.close(); } catch (SQLException e) {}
			try { if (conn != null) dbFactory.releaseAS400Connection(conn); } catch (Exception e) {}
		}
		return retVector;
	}

	public String querySummary(EntCroInqVO vo) {
		Vector retVector = new Vector();
		Connection conn = null;
		PreparedStatement preStmt = null;
		ResultSet rs = null;
		String ret = "";
		try {
			String sql = "select sum(ENTAMT) as SUMAMT from CAPCSHF where 1=1 ";
			if (vo.getEBKCD() != null && !"".equals(vo.getEBKCD()))
				sql = sql + " and EBKCD='" + vo.getEBKCD() + "'";
			if (vo.getEATNO() != null && !"".equals(vo.getEATNO()))
				sql = sql + " and EATNO='" + vo.getEATNO() + "'";
			if (vo.getEBKRMD() != null && !"".equals(vo.getEBKRMD()))
				sql = sql + " and EBKRMD >=" + removeChar(vo.getEBKRMD(), '/');
			if (vo.getEBKRMD2() != null && !"".equals(vo.getEBKRMD2()))
				sql = sql + " and EBKRMD <=" + removeChar(vo.getEBKRMD2(), '/');
			if (vo.getENTAMT() > 0)
				sql = sql + " and ENTAMT=" + vo.getENTAMT();
			if (vo.getCSHFCURR() != null && !"".equals(vo.getCSHFCURR()))
				sql = sql + " and CSHFCURR='" + vo.getCSHFCURR() + "'";
			System.out.println("EntCroInqDAO.querySummary=" + sql);

			conn = dbFactory.getAS400Connection("EntCroInqDAO.querySummary");
			preStmt = conn.prepareStatement(sql);
			rs = preStmt.executeQuery();
			if (rs.next())
				ret = rs.getString("SUMAMT");
		} catch (Exception e) {
			System.err.println(e.getMessage());
			dbFactory.releaseAS400Connection(conn);
		} finally {
			try { if (rs != null) rs.close(); } catch (SQLException e) {}
			try { if (preStmt != null) preStmt.close(); } catch (SQLException e) {}
			try { if (conn != null) dbFactory.releaseAS400Connection(conn); } catch (Exception e) {}
		}
		return ret;
	}

	public String removeChar(String str, char c) {
		while (str.indexOf(String.valueOf(c)) > 0) {
			int k = str.indexOf(String.valueOf(c));
			str = str.substring(0, k) + str.substring(k + 1, str.length());
		}
		return str;
	}

	public static void main(String[] args) {
		EntCroInqDAO e = new EntCroInqDAO(null);
		System.err.println(e.removeChar("093/09/03", '/'));

	}

}