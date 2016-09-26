package com.aegon.entCroInq;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

public class EntCroInqVO implements Comparable<EntCroInqVO> {

	private String EBKCD = "";
	private String EATNO = "";
	private String EBKRMD = "";
	private String EBKRMD2 = "";
	private int EAEGDT = 0;
	private double ENTAMT = 0;
	private String ECRSRC = "";
	private int ECRDAY = 0;
	private String EUSREM = "";
	private String CSHFAU = "";
	private int CSHFAD = 0;
	private int CSHFAT = 0;
	private String EUSREM2 = "";
	private String CSHFCURR = "";// Q60236¼W¥[¹ô§O
	private String CROTYPE = "";// R80413

	public EntCroInqVO(HttpServletRequest request) {
		EBKCD = "";
		EATNO = "";
		EBKRMD = "";
		EBKRMD2 = "";
		EAEGDT = 0;
		ENTAMT = 0;
		ECRSRC = "";
		ECRDAY = 0;
		EUSREM = "";
		CSHFAU = "";
		CSHFAD = 0;
		CSHFAT = 0;
		EUSREM2 = "";
		CSHFCURR = "";
		CROTYPE = "";
		setValues(request);
	}

	public EntCroInqVO(ResultSet rs) throws SQLException {
		EBKCD = "";
		EATNO = "";
		EBKRMD = "";
		EBKRMD2 = "";
		EAEGDT = 0;
		ENTAMT = 0;
		ECRSRC = "";
		ECRDAY = 0;
		EUSREM = "";
		CSHFAU = "";
		CSHFAD = 0;
		CSHFAT = 0;
		EUSREM2 = "";
		CSHFCURR = "";
		CROTYPE = "";
		setValues(rs);
	}

	public void setEBKCD(String str) {
		this.EBKCD = str;
	}

	public String getEBKCD() {
		return EBKCD;
	}

	public void setEATNO(String str) {
		EBKCD = str;
	}

	public String getEATNO() {
		return EATNO;
	}

	public void setEBKRMD(String str) {
		this.EBKRMD = str;
	}

	public String getEBKRMD() {
		return EBKRMD;
	}

	public void setEUSREM2(String str) {
		this.EUSREM2 = str;
	}

	public String getEUSREM2() {
		return EUSREM2;
	}

	public void setEBKRMD2(String str) {
		this.EBKRMD2 = str;
	}

	public String getEBKRMD2() {
		return EBKRMD2;
	}

	public void setEAEGDT(int i) {
		this.EAEGDT = i;
	}

	public int getEAEGDT() {
		return EAEGDT;
	}

	public void setENTAMT(double d) {
		this.ENTAMT = d;
	}

	public double getENTAMT() {
		return ENTAMT;
	}

	public void setECRSRC(String str) {
		this.ECRSRC = str;
	}

	public String getECRSRC() {
		return ECRSRC;
	}

	public void setECRDAY(int i) {
		this.ECRDAY = i;
	}

	public int getECRDAY() {
		return ECRDAY;
	}

	public void setEUSREM(String EUSREM) {
		this.EUSREM = EUSREM;
	}

	public String getEUSREM() {
		return EUSREM;
	}

	public void setCSHFAU(String CSHFAU) {
		this.CSHFAU = CSHFAU;
	}

	public String getCSHFAU() {
		return CSHFAU;
	}

	public void setCSHFAD(int i) {
		this.CSHFAD = i;
	}

	public int getCSHFAD() {
		return CSHFAD;
	}

	public void setCSHFAT(int i) {
		this.CSHFAT = i;
	}

	public int getCSHFAT() {
		return CSHFAT;
	}

	public void setCROTYPE(String str) {
		this.CROTYPE = str;
	}

	public String getCROTYPE() {
		return CROTYPE;
	}

	public String getCSHFCURR() {
		return CSHFCURR;
	}

	public void setCSHFCURR(String str) {
		CSHFCURR = str;
	}

	private void setValues(HttpServletRequest request) {
		if (request.getParameter("EBKCD") != null)
			EBKCD = request.getParameter("EBKCD");
		if (request.getParameter("EATNO") != null)
			EATNO = request.getParameter("EATNO");
		if (request.getParameter("EBKRMD") != null)
			EBKRMD = request.getParameter("EBKRMD");
		if (request.getParameter("EBKRMD2") != null)
			EBKRMD2 = request.getParameter("EBKRMD2");
		if (request.getParameter("EUSREM2") != null)
			EUSREM2 = request.getParameter("EUSREM2");
		if (request.getParameter("EAEGDT") != null) {
			String str = request.getParameter("EAEGDT");
			EAEGDT = str.equals("")?0:Integer.parseInt(str);
		}
		if (request.getParameter("ENTAMT") != null) {
			String str = request.getParameter("ENTAMT");
			ENTAMT = str.equals("")?0:Double.parseDouble(str);
		}
		if (request.getParameter("ECRSRC") != null)
			ECRSRC = request.getParameter("ECRSRC");
		if (request.getParameter("ECRDAY") != null) {
			String str = request.getParameter("ECRDAY");
			ECRDAY = str.equals("")?0:Integer.parseInt(str);
		}
		if (request.getParameter("EUSREM") != null)
			EUSREM = request.getParameter("EUSREM");
		if (request.getParameter("CSHFAU") != null)
			CSHFAU = request.getParameter("CSHFAU");
		if (request.getParameter("CSHFAD") != null) {
			String str = request.getParameter("CSHFAD");
			CSHFAD = str.equals("")?0:Integer.parseInt(str);
		}
		if (request.getParameter("CSHFAT") != null) {
			String str = request.getParameter("CSHFAT");
			CSHFAT = str.equals("")?0:Integer.parseInt(str);
		}
		if (request.getParameter("CROTYPE") != null)
			CROTYPE = request.getParameter("CROTYPE");
		if (request.getParameter("CSHFCURR") != null)
			CSHFCURR = request.getParameter("CSHFCURR");
	}

	private void setValues(ResultSet rs) throws SQLException {
		EBKCD = rs.getString("EBKCD");
		EATNO = rs.getString("EATNO");
		EBKRMD = rs.getString("EBKRMD");
		ENTAMT = rs.getDouble("ENTAMT");
		ECRDAY = rs.getInt("ECRDAY");
		EAEGDT = rs.getInt("EAEGDT");
		EUSREM = rs.getString("EUSREM");
		EUSREM2 = rs.getString("EUSREM2");
		CSHFCURR = rs.getString("CSHFCURR");
		CROTYPE = rs.getString("CROTYPE");
	}

	public int compareTo(EntCroInqVO o) {

		int i = this.EBKCD.compareTo(o.EBKCD);

		if (i != 0)
			return i;

		return this.CSHFCURR.compareToIgnoreCase(o.CSHFCURR);
	}

}