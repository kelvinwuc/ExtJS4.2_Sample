package com.aegon.disb.disbquery;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBCheckDetailVO;

/**
 * System   : CashWeb
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.5 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : 2005/04/04
 * 
 * Request ID  : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCDetailServlet.java,v $
 * $Revision 1.5  2013/12/24 03:04:34  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.4  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.2  2010/11/23 06:48:00  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.1  2006/06/29 09:40:52  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.1  2005/12/29 01:16:35  misangel
 * $R50845:票據統計資料
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:22  Angel
 * $R30530 支付系統
 * $$
 *  
 */
public class DISBCDetailServlet extends InitDBServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		System.out.println("~~~~strAction=" + strAction);
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		try {
			if (strAction.equals("I"))
				inquiryDB(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} catch (Exception e) {
			System.err.println("DISBCDetailServlet Application Exception >>> " + e);
		}

		return;
	}

	private void inquiryDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Connection con = dbFactory.getAS400Connection("DISBCDetailServlet.inquiryDB()");

		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String

		List alCControll = new ArrayList();

		/* 接收前端欄位定義 */
		String strOption = ""; // Query A:票據狀態統計
		String strDateType = ""; // 日期別 A.開立日 B.到期日 C.狀態日
		String strChkDateS = ""; // 票據起始日
		String strChkDateE = ""; // 票據終止日
		String strBank = "";

		/* 取得前端欄位資料 */
		strOption = request.getParameter("rdReport");
		if (strOption != null)
			strOption = strOption.trim();
		else
			strOption = "";

		strDateType = request.getParameter("para_DateType");
		if (strDateType != null)
			strDateType = strDateType.trim();
		else
			strDateType = "";

		strChkDateS = request.getParameter("para_ChkDateS");
		if (strChkDateS != null)
			strChkDateS = strChkDateS.trim();
		else
			strChkDateS = "";

		strChkDateE = request.getParameter("para_ChkDateE");
		if (strChkDateE != null)
			strChkDateE = strChkDateE.trim();
		else
			strChkDateE = "";

		strSql = " SELECT BKNM,CBKNO,CACCOUNT,CSTATUS,COUNT(CNO) AS RECCNT,SUM(CAMT) AS SUMAMT ";
		// QUERY類別
		if (strOption.equals("A")) {
			strSql += " FROM  CAPCHKF A LEFT OUTER JOIN CAPCCBF B ON A.CBKNO=B.BKNO";
		} else if (strOption.equals("B")) {
			strSql += " FROM  CAPCHKFHI A LEFT OUTER JOIN CAPCCBF B ON A.CBKNO=B.BKNO";
		}

		strSql += " WHERE  1=1 ";
		// 日期別 A.開立日 B.到期日 C.狀態日
		if (strDateType.equals("A")) {
			if (!strChkDateS.equals("") && strChkDateE.equals("")) {
				strSql += " AND CUSEDT >=" + strChkDateS + "";
			} else if (strChkDateS.equals("") && !strChkDateE.equals("")) {
				strSql += " AND CUSEDT <=" + strChkDateE + "";
			} else if (!strChkDateS.equals("") && !strChkDateE.equals("")) {
				strSql += " AND CUSEDT BETWEEN " + strChkDateS + " AND " + strChkDateE;
			}
		} else if (strDateType.equals("B")) {
			if (!strChkDateS.equals("") && strChkDateE.equals("")) {
				strSql += " AND CHEQUEDT >=" + strChkDateS + "";
			} else if (strChkDateS.equals("") && !strChkDateE.equals("")) {
				strSql += " AND CHEQUEDT <=" + strChkDateE + "";
			} else if (!strChkDateS.equals("") && !strChkDateE.equals("")) {
				strSql += " AND CHEQUEDT BETWEEN " + strChkDateS + " AND " + strChkDateE;
			}
		} else if (strDateType.equals("C")) {
			if (!strChkDateS.equals("") && strChkDateE.equals("")) {
				strSql += " AND CASHDT >=" + strChkDateS + "";
			} else if (strChkDateS.equals("") && !strChkDateE.equals("")) {
				strSql += " AND CASHDT <=" + strChkDateE + "";
			} else if (!strChkDateS.equals("") && !strChkDateE.equals("")) {
				strSql += " AND CASHDT BETWEEN " + strChkDateS + " AND " + strChkDateE;
			}
		}

		strSql += "  GROUP BY BKNM,CBKNO,CACCOUNT,CSTATUS ORDER BY CBKNO,CACCOUNT,CSTATUS";
		System.out.println(" inside DISBCDetailServlet.inquiryDB()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			while (rs.next()) {
				DISBCheckDetailVO vo = new DISBCheckDetailVO();
				strBank = rs.getString("CBKNO") + rs.getString("BKNM");
				vo.setStrCBKNo(strBank); // 銀行行庫
				vo.setStrCAccount(rs.getString("CACCOUNT")); // 銀行帳號
				vo.setStrCStatus(rs.getString("CSTATUS"));
				vo.setStrCNo(rs.getString("RECCNT"));
				vo.setICAmt(rs.getDouble("SUMAMT"));
				alCControll.add(vo);
			}

			if (alCControll.size() > 0) {
				session.setAttribute("CheckControlList", alCControll);
				request.setAttribute("txtMsg", "");

			} else {
				request.setAttribute("txtMsg", "查無相符資料");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alCControll = null;

		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (stmt != null) {
					stmt.close();
				}
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			} catch (Exception ex1) {
			}
		}

		request.setAttribute("txtAction", "I");
		request.setAttribute("rdReport", strOption);
		request.setAttribute("para_DateType", strDateType);

		if (!strChkDateS.equals("") && strChkDateS != null) {
			if (strChkDateS.length() == 6) {
				request.setAttribute("para_ChkDateS", "0" + strChkDateS.substring(0, 2) + "/" + strChkDateS.substring(2, 4) + "/" + strChkDateS.substring(4));
			} else {
				request.setAttribute("para_ChkDateS", strChkDateS.substring(0, 3) + "/" + strChkDateS.substring(3, 5) + "/" + strChkDateS.substring(5));
			}
		}
		if (!strChkDateE.equals("") && strChkDateE != null) {
			if (strChkDateE.length() == 6) {
				request.setAttribute("para_ChkDateS", "0" + strChkDateE.substring(0, 2) + "/" + strChkDateE.substring(2, 4) + "/" + strChkDateE.substring(4));
			} else {
				request.setAttribute("para_ChkDateE", strChkDateE.substring(0, 3) + "/" + strChkDateE.substring(3, 5) + "/" + strChkDateE.substring(5));
			}
		}

		dispatcher = request.getRequestDispatcher("/DISB/DISBQuery/DISBCDetailsQry.jsp");
		dispatcher.forward(request, response);

		return;
	}

	public void init() throws ServletException {
		super.init();
	}
}
