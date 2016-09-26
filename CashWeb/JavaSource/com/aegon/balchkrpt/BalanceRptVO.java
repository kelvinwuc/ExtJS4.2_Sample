package com.aegon.balchkrpt;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

public class BalanceRptVO {

	private String BKCODE = "";
	private String BKNAME = "";
	private String BKATNO = "";
	private String BKCURR = "";

	private String strRmtStartDate = "";
	private String strRmtEndDate = "";
	private String strAegStartDate = "";
	private String strAegEndDate = "";

	private String AMT1 = "";
	private String AMT2 = "";
	private String AMT3 = "";

	public BalanceRptVO(HttpServletRequest request) {
		this.setValues(request);
	}

	public BalanceRptVO(ResultSet rs) throws SQLException {
		this.setValues(rs);
	}

	public void setBKCODE(String string) {
		this.BKCODE = string;
	}

	public String getBKCODE() {
		return this.BKCODE;
	}

	public void setBKNAME(String string) {
		this.BKNAME = string;
	}

	public String getBKNAME() {
		return this.BKNAME;
	}

	public void setBKATNO(String string) {
		this.BKATNO = string;
	}

	public String getBKATNO() {
		return this.BKATNO;
	}

	public String getBKCURR() {
		return BKCURR;
	}
	public void setBKCURR(String string) {
		BKCURR = string;
	}

	public String getRmtStartDate() {
		return strRmtStartDate;
	}

	public void setRmtStartDate(String string) {
		this.strRmtStartDate = string;
	}

	public String getRmtEndDate() {
		return strRmtEndDate;
	}

	public void setRmtEndDate(String string) {
		this.strRmtEndDate = string;
	}

	public String getAegStartDate() {
		return strAegStartDate;
	}

	public void setAegStartDate(String string) {
		this.strAegStartDate = string;
	}

	public String getAegEndDate() {
		return strAegEndDate;
	}

	public void setAegEndDate(String string) {
		this.strAegEndDate = string;
	}

	public void setAMT1(String string) {
		this.AMT1 = string;
	}

	public String getAMT1() {
		return this.AMT1;
	}

	public void setAMT2(String string) {
		this.AMT2 = string;
	}

	public String getAMT2() {
		return this.AMT2;
	}

	public void setAMT3(String string) {
		this.AMT3 = string;
	}

	public String getAMT3() {
		return this.AMT3;
	}

	private void setValues(ResultSet rs) throws SQLException {
		setBKCODE(rs.getString("BKCODE"));
		setBKATNO(rs.getString("BKATNO"));
		setBKNAME(rs.getString("BKNAME"));
		setBKCURR(rs.getString("BKCURR"));

	}

	private void setValues(HttpServletRequest request) {
		if (request.getParameter("EBKCD") != null) {
			setBKCODE(request.getParameter("EBKCD"));
		}
		if (request.getParameter("EATNO") != null) {
			setBKATNO(request.getParameter("EATNO"));
		}
		if (request.getParameter("CURRENCY") != null) {
			setBKCURR(request.getParameter("CURRENCY"));
		}
	}

}
