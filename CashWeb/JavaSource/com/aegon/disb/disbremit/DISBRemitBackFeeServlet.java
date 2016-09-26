/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393             Leo Huang    			2010/09/17           現在時間取Capsil營運時間
 *  =============================================================================
 */
package com.aegon.disb.disbremit;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.aegon.comlib.*;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;

import javax.servlet.ServletContext;
/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : Vanessa Liao
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R60550
 * 
 * CVS History:
 * 
 * $$Log: DISBRemitBackFeeServlet.java,v $
 * $Revision 1.2  2010/11/23 06:50:41  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.1  2006/11/30 09:14:08  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $$
 *  
 */
public class DISBRemitBackFeeServlet extends HttpServlet {

	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private DISBBean disbBean = null;
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
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";
		try {
			if (strAction.equals("U"))
			   updateDB(request, response);
		   else
			   System.out.println("Hello, that's not a valid UseCase!");
			
		}
		catch (Exception e) {
			System.out.println("Application Exception >>> " + e);

		}
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
	
	/**
	 * @param request
	 * @param response
	 */
	private void updateDB(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
		System.out.println("@@@@@inside updateDB");
		HttpSession session = request.getSession(true);
		String strLogonUser =
			(String) session.getAttribute(Constant.LOGON_USER_ID);
		//	R00393	Edit by Leo Huang (EASONTECH) Start
//		Calendar cldToday = Calendar.getInstance(Constant.CURRENT_LOCALE);
			 
			  Calendar cldToday = commonUtil.getBizDateByRCalendar();
//R00393		Edit by Leo Huang (EASONTECH) End
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		//R00393   Edit by Leo Huang (EASONTECH) Start
   //CommonUtil commonUtil = new CommonUtil();
// R00393   Edit by Leo Huang (EASONTECH) End
		Connection con =
		dbFactory.getAS400Connection("DISBRemitBackFeeServlet.updateDB()");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; //SQL String
	
		int iUpdDate =
			Integer.parseInt(
				(String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime =
			Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));
			
		/* 接收前端欄位定義 */
		String strCMFEEDT = ""; //
		String strCMFEEAMT = "";
		double iCMFEEAMT = 0; //
		String strCMFEECURR = ""; //
		String strCBATNO= ""; //
		String strCSEQNO = "";//
		
		strCMFEEDT = request.getParameter("txtMFEEDT");
		if (strCMFEEDT != null)
			strCMFEEDT = strCMFEEDT.trim();
		else
			strCMFEEDT = "";
		
		strCMFEEAMT = request.getParameter("txtMFEEAMT");
		if (strCMFEEAMT != null)
			strCMFEEAMT = strCMFEEAMT.trim();
		else
			strCMFEEAMT = "";

		if (!strCMFEEAMT.equals(""))
			iCMFEEAMT = Double.parseDouble(strCMFEEAMT.trim());
			
		strCMFEECURR = request.getParameter("selMFEECURR");
		if (strCMFEECURR != null)
			strCMFEECURR = strCMFEECURR.trim();
		else
			strCMFEECURR = "";		
		
		strCBATNO = request.getParameter("txtBATNO");
		if (strCBATNO != null)
			strCBATNO = strCBATNO.trim();
		else
			strCBATNO = "";	
			
		strCSEQNO = request.getParameter("txtSEQNO");
		if (strCSEQNO != null)
			strCSEQNO = strCSEQNO.trim();
		else
			strCSEQNO = "";		
	   
			
	/*更新資料庫*/		
	try {	
		strSql =   " update CAPRMTF ";
		strSql += " set RPAYMIDDT =? , RPAYMIDFEE=? , RPAYMIDCUR=?";
		strSql += " where BATNO =? AND SEQNO=?";
		System.out.println("strSql="+strSql);
		pstmtTmp = con.prepareStatement(strSql);
		pstmtTmp.setString(1, strCMFEEDT);
		pstmtTmp.setDouble(2, iCMFEEAMT);
		pstmtTmp.setString(3, strCMFEECURR);
		pstmtTmp.setString(4, strCBATNO);
		pstmtTmp.setString(5, strCSEQNO);

		if (pstmtTmp.executeUpdate() < 1) {//3
			request.setAttribute("txtMsg", "更新後收手續費失敗");
		}
		else
		{
			request.setAttribute("txtMsg", "更新後收手續費成功");
		}
		pstmtTmp.close();		
  	} catch (SQLException e) {
		request.setAttribute("txtMsg", "更新後收手續費失敗-->"+e);
		if (con != null)
			dbFactory.releaseAS400Connection(con);
	} finally {
		if (con != null) {
			dbFactory.releaseAS400Connection(con);
		}
	}
		request.setAttribute("txtAction","U");
		dispatcher = request.getRequestDispatcher("/DISB/DISBRemit/DISBRemitBackFee.jsp");
		dispatcher.forward(request, response);
		return;		
	}
}
