package com.aegon.balchkrpt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import com.aegon.comlib.DbFactory;

public class BalanceRptDAO {

	private DbFactory dbFactory = null;

	private final String QUERY_BANK = "select BKCODE,BKATNO,BKNAME,BKCURR,BKADDT from CAPBNKF where 1=1 ";//Q60326 加入幣別欄位
	private final String QUERY_SUM_SUS = "select sum(ENTAMT) as SUMAMT from CAPCSHF where EAEGDT=0 and ECRDAY=0 ";
	private final String QUERY_SUM_REC = "select sum(ENTAMT) as SUMAMT from CAPCSHF where EAEGDT>0 ";

	public BalanceRptDAO(DbFactory factory) {
		this.dbFactory = factory;
	}

	public Vector query_bank(BalanceRptVO vo) {
		Vector retVector = new Vector();

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rst = null;
		try {
			String sql = QUERY_BANK;
			if (vo.getBKCODE() != null && !"".equals(vo.getBKCODE())) {
				sql += " and BKCODE='" + vo.getBKCODE() + "'";
			}
			if (vo.getBKATNO() != null && !"".equals(vo.getBKATNO())) {
				sql += " and BKATNO='" + vo.getBKATNO() + "'";
			}
			if (vo.getBKCURR() != null && !"".equals(vo.getBKCURR())) {
				sql += " and BKCURR='" + vo.getBKCURR() + "'";
			}
			sql += " order by BKCODE,BKATNO,BKADDT";

			conn = dbFactory.getAS400Connection("BalanceRptDAO");
			pstmt = conn.prepareStatement(sql);
			rst = pstmt.executeQuery();
			while (rst.next()) {
				retVector.add(new BalanceRptVO(rst));
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			if (conn != null) {
				dbFactory.releaseAS400Connection(conn);
			}
		} finally {
			if (conn != null) {
				dbFactory.releaseAS400Connection(conn);
			}
		}
		return retVector;
	}

	public double querySummary(String BKCD, String ATNO, String BKRMD_S, String BKRMD_E, String AEGDT_S, String AEGDT_E, String type, String Currency) {

		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rst = null;
		double ret = 0;
		String sql = "";
		try {
			if (type.equals("1")) {
				sql = QUERY_SUM_SUS;
			} else {
				sql = QUERY_SUM_REC;
			}
			if (BKCD != null && !"".equals(BKCD)) {
				sql += " and EBKCD ='" + BKCD + "'";
			}
			if (ATNO != null && !"".equals(ATNO)) {
				sql += " and EATNO='" + ATNO + "'";
			}
			if (BKRMD_S != null && !"".equals(BKRMD_S)) {
				sql += " and EBKRMD >=" + BKRMD_S;
			}
			if (BKRMD_E != null && !"".equals(BKRMD_E)) {
				sql += " and EBKRMD <=" + BKRMD_E;
			}

			if (AEGDT_S != null && !"".equals(AEGDT_S)) {
				sql += " and EAEGDT >=" + AEGDT_S;
			}
			if (AEGDT_E != null && !"".equals(AEGDT_E)) {
				sql += " and EAEGDT <=" + AEGDT_E;
			}
			if (Currency != null && !Currency.equals("")) {
				sql += " and CSHFCURR ='" + Currency + "'";
			}

			conn = dbFactory.getAS400Connection("BalanceRptDAO");
			pstmt = conn.prepareStatement(sql);
			rst = pstmt.executeQuery();
			if (rst.next()) {
				ret = rst.getDouble("SUMAMT");
			}

		} catch (Exception e) {
			System.err.println(e.getMessage());
			if (conn != null) {
				dbFactory.releaseAS400Connection(conn);
			}
		} finally {
			if (conn != null) {
				dbFactory.releaseAS400Connection(conn);
			}
		}
		return ret;
	}
}