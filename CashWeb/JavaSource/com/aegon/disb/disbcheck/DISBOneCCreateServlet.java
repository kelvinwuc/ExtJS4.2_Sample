/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393            Leo Huang    			2010/09/15           現在時間取Capsil營運時間
 *  =============================================================================
 */
package com.aegon.disb.disbcheck;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.aegon.comlib.*;
/*
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
 * $$Log: DISBOneCCreateServlet.java,v $
 * $Revision 1.3  2013/02/22 03:37:42  ODCWilliam
 * $william wu
 * $PA0024
 * $bill cash day
 * $
 * $Revision 1.2  2010/11/23 06:27:42  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.1  2006/06/29 09:40:38  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.2  2005/04/04 07:02:22  miselsa
 * $R30530 支付系統
 * $$
 *  
 */
public class DISBOneCCreateServlet extends HttpServlet {

	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private boolean isAEGON400 = false;
	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void doPost(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		ServletContext sc = getServletContext();

		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		//System.out.println("~~~~strAction=" + strAction);
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		try {
			updateCheckInfo(request, response);
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
	private void updateCheckInfo(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		//R00393  Edit by Leo Huang (EASONTECH) Start
		//Calendar cldToday = Calendar.getInstance(Constant.CURRENT_LOCALE);
//		R00393  Edit by Leo Huang (EASONTECH) Start
	 
	  Calendar cldToday =commonUtil.getBizDateByRCalendar();
//		 R00393  Edit by Leo Huang (EASONTECH) End
//	R00393	Edit by Leo Huang (EASONTECH) End
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser =
			(String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con =
			dbFactory.getAS400Connection("DISBOneCCreateServlet.updateCheckInfo()");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; //SQL String
		String strReturnMsg = "";
		//R00393  Edit by Leo Huang (EASONTECH) Start
		//CommonUtil commonUtil = new CommonUtil();
//		R00393	Edit by Leo Huang (EASONTECH) End
		int iUpdDate =
			Integer.parseInt(
				(String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime =
			Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* 接收前端欄位定義 */
		String strCBKNO = ""; //銀行行庫
		String strCACCOUNT = ""; //銀行帳號		
		String strCBNO = ""; //票據批號
		String strCNO = ""; //票據號碼
		String strCASHDT = ""; //兌現日
		int iCASHDT = 0;//兌現日
	
		/*取得前端欄位資料*/
		strCBKNO = request.getParameter("txtUCBKNO");
		if (strCBKNO != null)
			strCBKNO = strCBKNO.trim();
		else
			strCBKNO = "";
	    
		strCACCOUNT = request.getParameter("txtUCACCOUNT");
		if (strCACCOUNT != null)
			strCACCOUNT = strCACCOUNT.trim();
		else
			strCACCOUNT = "";	
			
		strCBNO = request.getParameter("txtUCBNO");
		if (strCBNO != null)
			strCBNO = strCBNO.trim();
		else
			strCBNO = "";
			
		strCNO= request.getParameter("txtUCNO");
		if (strCNO!= null)
			strCNO= strCNO.trim();
		else
			strCNO= "";
	
			strCASHDT = request.getParameter("txtCashDT");
		if (strCASHDT != null)
		{
			strCASHDT = strCASHDT.trim();			
		}
		else
		{
			strCASHDT="";
		}
		if(!strCASHDT.equals(""))
		{
			iCASHDT = Integer.parseInt(strCASHDT);
		}
		
	
	
		/*更新到支付主檔*/
		//William wu 2012/12/25 PA0024 票據兌現日
		strSql = " update CAPCHKF  set CSTATUS='C',CCASHDT=?,CRTNDT=?,ENTRYDT=?,ENTRYTM=? ,ENTRYUSR=? ";
	    strSql	+= " where CNO =?  AND CBKNO=? AND CACCOUNT=? AND CBNO=? ";
	//	System.out.println(
	//		" inside DISBPMaintainServlet.upddataDB()--> strSql =" + strSql);
	//		System.out.println(iCASHDT+","+iUpdDate+","+iUpdTime+","+strLogonUser+","+strCNO+","+strCBKNO+","+strCACCOUNT+","+strCBNO);

		try {
				pstmtTmp = con.prepareStatement(strSql);

				pstmtTmp.setInt(1, iCASHDT);
			    pstmtTmp.setInt(2, iUpdDate);
				pstmtTmp.setInt(3, iUpdDate);
				pstmtTmp.setInt(4, iUpdTime);
				pstmtTmp.setString(5, strLogonUser);
				pstmtTmp.setString(6, strCNO);
				pstmtTmp.setString(7, strCBKNO);
				pstmtTmp.setString(8, strCACCOUNT);
				pstmtTmp.setString(9, strCBNO);
				
				if (pstmtTmp.executeUpdate() != 1) {
					request.setAttribute("txtMsg", "單筆回銷失敗");
				} else {
					request.setAttribute("txtMsg", "單筆回銷成功");
				}
			pstmtTmp.close();
		} catch (SQLException e) {
			
			request.setAttribute("txtMsg", "單筆回銷失敗" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
	    request.setAttribute("txtAction", "DISBCheckCashed");
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBOneCheckCashed.jsp");
		dispatcher.forward(request, response);
		return;		

	
	}

	/**
	* @see javax.servlet.GenericServlet#void ()
	*/
	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON)
			!= null) {
			globalEnviron =
				(GlobalEnviron) getServletContext().getAttribute(
					Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory =
				(DbFactory) getServletContext().getAttribute(
					Constant.DB_FACTORY);
		}

		if (globalEnviron
			.getActiveAS400DataSource()
			.equals(Constant.AS400_DATA_SOURCE_NAME_AEGON400)) {
			isAEGON400 = true;
		}
		//R00393 
			commonUtil = new CommonUtil(globalEnviron);
	}
}

 