package com.aegon.disb.disbcheck;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.3 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckRejectedServlet.java,v $
 * $Revision 1.3  2013/12/24 02:17:18  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.2  2010/11/23 06:27:42  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.1  2006/06/29 09:40:38  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.4  2005/04/25 10:13:57  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.3  2005/04/04 07:02:22  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBCheckRejectedServlet extends InitDBServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see javax.servlet.http.HttpServlet#void
	 *      (javax.servlet.http.HttpServletRequest,
	 *      javax.servlet.http.HttpServletResponse)
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		// System.out.println("~~~~strAction=" + strAction);
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";
		try {
			if (strAction.equals("DISBCRejected"))
				updateStatusProcess(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");

		} // end of try
		catch (Exception e) {
			System.out.println("Application Exception >>> " + e);

		}
		return;
	}

	/**
	 * @param request
	 * @param response
	 */
	private void updateStatusProcess(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckRejectedServlet.updateStatusProcess()");
		PreparedStatement pstmtTmp = null;
		String strReturnMsg = "";
		List alEmptyCheckBook = new ArrayList();
		List alCheckInfo = new ArrayList(); // 存放票據明資料
		String strSql = ""; // SQL String

		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		int iUpdDate = Integer.parseInt((String) commonUtil
				.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday
				.getTime()));

		/* 接收前端欄位定義 */
		String strCNo = ""; // 票據號碼
		String strCBNo = ""; // 票據批號
		String strCBkNo = ""; // 銀行行庫
		String strCAccount = ""; // 銀行帳號
		String strCStatus = ""; // 欲更新之狀態

		strCNo = request.getParameter("txtCNO");
		if (strCNo != null)
			strCNo = strCNo.trim();
		else
			strCNo = "";

		strCBNo = request.getParameter("txtCBNo");
		if (strCBNo != null)
			strCBNo = strCBNo.trim();
		else
			strCBNo = "";

		strCBkNo = request.getParameter("txtCBKNo");
		if (strCBkNo != null)
			strCBkNo = strCBkNo.trim();
		else
			strCBkNo = "";

		strCAccount = request.getParameter("txtCAccount");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCStatus = "R";

		/* 更新資料庫 */
		/* 更新票據明細檔 */
		// strSql =
		// " update CAPCHKF  set CSTATUS=?,CASHDT=?,ENTRYDT=?,ENTRYTM=?,ENTRYUSR=? ";
		// strSql += " where CNO =?  AND CBKNO=? AND CACCOUNT=? AND CBNO=? ";
		strSql = "update CAPCHKF set ";
		strSql += " CSTATUS='" + strCStatus + "', CASHDT=" + iUpdDate
				+ ",ENTRYDT=" + iUpdDate + ",ENTRYTM=" + iUpdTime
				+ ",ENTRYUSR='" + strLogonUser + "' ";
		strSql += " where CNO='" + strCNo + "' AND CBKNO='" + strCBkNo
				+ "'  AND CACCOUNT='" + strCAccount + "'  AND CBNO='" + strCBNo
				+ "'";
		System.out.println("updateStatusProcess_strSql = " + strSql);
		try {
			pstmtTmp = con.prepareStatement(strSql);
			/*
			 * pstmtTmp.setString(1, strCStatus); pstmtTmp.setInt(2, iUpdDate);
			 * pstmtTmp.setInt(3, iUpdDate); pstmtTmp.setInt(4, iUpdTime);
			 * pstmtTmp.setString(5, strLogonUser); pstmtTmp.setString(6,
			 * strCNo); pstmtTmp.setString(7, strCBkNo); pstmtTmp.setString(8,
			 * strCAccount); pstmtTmp.setString(9, strCBNo);
			 */
			if (pstmtTmp.executeUpdate() != 1) {
				if (isAEGON400) {
					con.rollback();
				}
				strReturnMsg = "修改失敗";
			} else {
				request.setAttribute("txtMsg", "修改成功");
			}
			pstmtTmp.close();
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtMsg", strReturnMsg);
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "修改失敗" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}

		request.setAttribute("txtAction", "");
		dispatcher = request
				.getRequestDispatcher("/DISB/DISBCheck/DISBCheckRejected.jsp");
		dispatcher.forward(request, response);
		return;
	}

	public void init() throws ServletException {
		super.init();
	}

}