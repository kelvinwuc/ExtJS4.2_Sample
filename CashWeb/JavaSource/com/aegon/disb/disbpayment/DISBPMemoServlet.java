/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *      R00393           Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
 *  =============================================================================
 */
package com.aegon.disb.disbpayment;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.aegon.comlib.*;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;

/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.3 $$
 * 
 * Author   : Angel Chen
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBPMemoServlet.java,v $
 * $Revision 1.3  2013/12/24 03:03:31  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.2  2010/11/23 06:45:20  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.1  2006/06/29 09:40:15  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.3  2005/04/04 07:02:24  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */
public class DISBPMemoServlet extends HttpServlet {

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
		System.out.println(
			"~~~~txtAction=" + request.getParameter("txtAction"));
		strAction = request.getParameter("txtAction");
		System.out.println("~~~~strAction=" + strAction);
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		try {
            if (strAction.equals("U"))
				upddateDB(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} // end of try
		catch (Exception e) {
			System.out.println("Application Exception >>> " + e);

		}

	}

	/**
	 * @param request
	 * @param response
	 */
	private void upddateDB(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {	
		HttpSession session = request.getSession(true);
		//R00393		Edit by Leo Huang (EASONTECH) Start
//		Calendar cldToday = Calendar.getInstance(Constant.CURRENT_LOCALE);
			 
			  Calendar cldToday = commonUtil.getBizDateByRCalendar();
//R00393		Edit by Leo Huang (EASONTECH) End
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser =
			(String) session.getAttribute(Constant.LOGON_USER_ID);		
		Connection con =
			dbFactory.getAS400Connection("DISBPMemoServlet.inqueryDB()");
		PreparedStatement pstmtTmp = null;
		String strReturnMsg = "";
		String strSql = ""; //SQL String
		String strReturnMessage = "";
		//R00393  Edit by Leo Huang (EASONTECH) Start
	   //CommonUtil commonUtil = new CommonUtil();
//R00393	  Edit by Leo Huang (EASONTECH) End
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		boolean bContinue = false;
		int iUpdDate =
			Integer.parseInt(
				(String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime =
			Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strPNO = "";  //��I�Ǹ�
		String strMEMO = ""; //��I�Ƶ�

		/*���o�e�������*/
		strPNO = request.getParameter("txtUPNO");
		if (strPNO != null)
			strPNO = strPNO.trim();
		else
			strPNO = "";
			
		strMEMO = request.getParameter("txtUPMEMO");
		if (strMEMO != null)
		    strMEMO = strMEMO.trim();
		else
		    strMEMO = "";
			
		/*��s���I�D��*/
		strSql = " update CAPPAYF ";
		strSql
			+= " set MEMO='" +strMEMO + "'";
		strSql += " where PNO ='" + strPNO + "'";

		System.out.println(
			" --> strSql =" + strSql);

		try {

			disbBean = new DISBBean(dbFactory);
			strReturnMsg =
				disbBean.insertCAPPAYFLOG(
					strPNO,
					strLogonUser,
					iUpdDate,
					iUpdTime,
					con);
					
			if (strReturnMsg.equals("")) {
				pstmtTmp = con.prepareStatement(strSql);
				if (pstmtTmp.executeUpdate() != 1) {
					bContinue = false;
					request.setAttribute("txtMsg", "�x�s����");
					System.out.println("DISB: Save failed. ");
				} else {
					bContinue = true;
					request.setAttribute("txtMsg", "�x�s���\");
					System.out.println("DISB: Save successfully.");
				}
				pstmtTmp.close();
			} else {
				bContinue = false;
				request.setAttribute("txtMsg", strReturnMsg);
			}
			if (!bContinue)
			{
				if (isAEGON400) {
								con.rollback();
							}
			}
		} catch (SQLException e) {
			strReturnMessage = "" + e;
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		System.out.println("strReturnMessage=" + strReturnMessage);
		session.setAttribute("ActionNo", "U");
		response.sendRedirect(
			"/CashWeb/DISB/DISBPayment/DISBPMemo.jsp?txtMsg="
				+ strReturnMessage
				+ "&txtAction=U");

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
