package com.aegon.disb.disbcheck;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.DISBCheckDetailVO;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.8 $$
e * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckCreateServlet.java,v $
 * $Revision 1.8  2015/04/24 09:03:39  001946
 * $*** empty log message ***
 * $
 * $Revision 1.7  2014/08/05 02:59:42  missteven
 * $RC0036
 * $
 * $Revision 1.6  2014/07/18 07:12:44  misariel
 * $EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 * $
 * $Revision 1.5  2013/12/24 02:17:18  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.4  2010/11/23 06:27:42  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.3  2009/12/03 04:13:50  missteven
 * $R90628 ���ڮw�s�s�W
 * $
 * $Revision 1.2  2008/07/10 03:42:33  misvanessa
 * $R80518_�H�u�}�����ڨ����ק�
 * $
 * $Revision 1.1  2006/06/29 09:40:37  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.10  2006/04/10 05:39:07  misangel
 * $R60200:�X�ǥ\�ണ��
 * $
 * $Revision 1.1.2.9  2005/12/23 07:41:51  misangel
 * $R50820:��I�\�ണ��
 * $
 * $Revision 1.1.2.8  2005/04/28 08:56:25  miselsa
 * $R30530������ժ��ק�
 * $
 * $Revision 1.1.2.7  2005/04/04 07:02:22  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */
public class DISBCheckCreateServlet extends InitDBServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

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
			else if (strAction.equals("DISBCheckCreate"))
				checkCreateProcess(request, response);
			else if (strAction.equals("ChequeCheck"))
				ChequeCheckProcess(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} // end of try
		catch (Exception e) {
			System.out.println("Application Exception >>> " + e);

		}
		return;
	}

	private void ChequeCheckProcess(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		System.out.println("@@@@@inside Chequecheck");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		// R00393
		// CommonUtil commonUtil = new CommonUtil();
		boolean bFlag = true;
		String strReturnMsg = "";
		String strCNoTemp = "";
		int iFee = 0;
		int iSize = 0;
		List alReturnInfo = new ArrayList();
		List alChequeList = new ArrayList();
		List alPayList = new ArrayList();
		List alCheckList = new ArrayList();

		List alPDetail = (List) KeepDataList(request, response);
		// List alPDetail =(List) session.getAttribute("PDetailListTemp");

		DISBCheckDetailVO objCDetailVO;
		if (alPDetail != null)
			iSize = alPDetail.size();

		for (int i = 0; i < iSize; i++) { // loop1
			// System.out.println("Inside for : " + i );
			DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail
					.get(i);
			
			strCNoTemp = objPDetailVO.getStrPCheckNO();
			iFee = objPDetailVO.getIRmtFee();
			//TEST
			/*strCNoTemp = objPDetailVO.getStrUsrDept();
			strCNoTemp = objPDetailVO.getStrPMethod();	*/	 
			 
			bFlag = false;
			for (int j = 0; j < alChequeList.size(); j++) {// loop2
				objCDetailVO = (DISBCheckDetailVO) alChequeList.get(j);
				if (strCNoTemp.equals(objCDetailVO.getStrCNo())) {
					objCDetailVO.setICAmt(objCDetailVO.getICAmt() + iFee
							+ objPDetailVO.getIPAMT());
					// System.out.println(strCNoTemp + ":" +
					// objPDetailVO.getIPAMT() +";" +objCDetailVO.getICAmt());
					alChequeList.set(j, objCDetailVO);
					bFlag = true;
				}
			}// end of for loop2
			if (bFlag == false) {
				objCDetailVO = new DISBCheckDetailVO();
				objCDetailVO.setICAmt(iFee + objCDetailVO.getICAmt()
						+ objPDetailVO.getIPAMT());
				objCDetailVO.setStrCNo(strCNoTemp);
				alChequeList.add(objCDetailVO);
			}
		}// end of for loop1........

		if (alChequeList != null) {
			for (int i = 0; i < alChequeList.size(); i++) {
				objCDetailVO = (DISBCheckDetailVO) alChequeList.get(i);
				strReturnMsg += "�䲼���X" + objCDetailVO.getStrCNo() + " = "
						+ objCDetailVO.getICAmt() + "\n";
			}
		} else
			strReturnMsg = "";

		session.setAttribute("PDetailList", alPDetail);
		session.setAttribute("PDetailListTemp", alPDetail);
		request.setAttribute("txtMsg", strReturnMsg);
		request.setAttribute("txtAction", "ChequeCheck");
		dispatcher = request
				.getRequestDispatcher("/DISB/DISBCheck/DISBCheckCreate.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private List KeepDataList(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);

		int iSize = 0;

		String strCNoTemp = "";
		String strPCshDtTemp = "";
		String strFee = "";
		DISBPaymentDetailVO objPDetailVO = null;
		List alPayList = new ArrayList();
		List alPDetail = (List) session.getAttribute("PDetailListTemp");

		if (alPDetail != null)
			iSize = alPDetail.size();

		for (int i = 0; i < iSize; i++) {
			strCNoTemp = request.getParameter("txtCNo" + i);
			strPCshDtTemp = request.getParameter("txtUPCshDt" + i);
			if (strPCshDtTemp.equals("")) {
				strPCshDtTemp = "0";
			}
			strFee = request.getParameter("txtFee" + i);
			// if (!strCNoTemp.equals("") && !strPCshDtTemp.equals("")) {
			// objCDetailVO = new DISBCheckDetailVO();
			// objPDetailVO = new DISBPaymentDetailVO();
			objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(i);
			objPDetailVO.setIRmtFee(Integer.parseInt(strFee));

			objPDetailVO.setIPCshDt(Integer.parseInt(strPCshDtTemp));
			objPDetailVO.setStrPCheckNO(strCNoTemp);
			alPayList.add(objPDetailVO);
			// }
		} // end of for loop........
		session.removeAttribute("PDetailListTemp");
		return alPayList;
	} // end of maintainPList method....

	private void checkCreateProcess(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		System.out.println("@@@@@inside checkCreation");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		
		//2015.3.17,Kelvin Wu,�s�WstrLogonUser���s�b���P�_
		if(strLogonUser == null){
			String logonPage = "/Logon/Logon.jsp";
			dispatcher = request.getRequestDispatcher(logonPage);
			dispatcher.forward(request, response);
		}
		
		Connection con = dbFactory.getAS400Connection("DISBCheckCreateServlet.checkCreation()");
		String strReturnMsg = "";
		String strCHKEDT = "";// R80518
		int iCHKEDT = 0;// R80518
		boolean bContinue = true;
		List alReturnInfo = new ArrayList();
		List alCheckList = new ArrayList();
		List alCheckInfo = new ArrayList();
		List alPayList = new ArrayList();
		alCheckList = (List) maintainPList(request, response);
		alPayList = (List) maintainFeeList(request, response);

		List alPDetail = (List) session.getAttribute("PDetailListTemp");
		int iUpdDate = Integer.parseInt((String) commonUtil
				.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday
				.getTime()));

		// R80518 ���ڨ����
		strCHKEDT = request.getParameter("txtCHKEDT");
		if (strCHKEDT != null) {
			strCHKEDT = strCHKEDT.trim();
		}
		if (!strCHKEDT.equals("")) {
			iCHKEDT = Integer.parseInt(strCHKEDT);
		}

		try {
			if (alCheckList != null) {
				if (alCheckList.size() > 0) {

					for (int i = 0; i < alCheckList.size(); i++) {
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckList
								.get(i);
						/* �P�_�����O�_�s�b / �O�_���H�u�� / �O�_�w�Q�ϥ� */
						alReturnInfo = (List) this.getCheckInfo(objCDetailVO);
						String strReturnFlag = (String) alReturnInfo.get(0);
						String strReturnMsgTemp = (String) alReturnInfo.get(1);
						if (!strReturnFlag.equals("0")) {
							strReturnMsg += strReturnMsgTemp;
							bContinue = false;
						} else {
							alCheckInfo.add((DISBCheckDetailVO) alReturnInfo.get(2));
							bContinue = true;
						}
					}
					if (bContinue) {
						/* ��s�䲼������ */
						// strReturnMsg = updateCheckInfo(alCheckInfo,alPDetail,iUpdDate,con);
						// R80518 strReturnMsg = updateCheckInfo(alCheckInfo,alPayList,iUpdDate,con);
						strReturnMsg = updateCheckInfo(alCheckInfo, alPayList, iUpdDate, con, iCHKEDT);
							if (strReturnMsg.equals("")) {
							/* ��s��I�D�ɤΤULOG */

							// strReturnMsg = updatePDetails(alCheckInfo, alPDetail, iUpdDate, iUpdTime, strLogonUser, con);
							strReturnMsg = updatePDetails(alCheckInfo, alPayList, iUpdDate, iUpdTime, strLogonUser, con);
							if (strReturnMsg.equals("")) {
								request.setAttribute("txtMsg", "�H�u�}�����\");
								bContinue = true;
							} else {// ��s��I�D�ɤΤULOG����
								bContinue = false;
							}
						} else {// ��s�䲼�����ɥ���
							bContinue = false;
						}
					}// bContinue
					if (!bContinue) // �p�����~�ɫh roll back
					{
						request.setAttribute("txtMsg", strReturnMsg);
						if (isAEGON400) {
							con.rollback();
						}
						request.setAttribute("txtAction", "DISBCheckCreate");
						dispatcher = request
								.getRequestDispatcher("/DISB/DISBCheck/DISBCheckCreate.jsp");
						dispatcher.forward(request, response);
						return;
					}

				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�H�u�}������-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", "DISBCheckCreate");
		dispatcher = request
				.getRequestDispatcher("/DISB/DISBCheck/DISBCheckCreate.jsp");
		dispatcher.forward(request, response);
		return;
	}

	public void init() throws ServletException {
		super.init();
	}

	private List maintainPList(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		int iSize = 0;

		String strCNoTemp = "";
		String strPCshDtTemp = "";
		String strFee = "";
		DISBCheckDetailVO objCDetailVO = null;
		List alCheckList = new ArrayList();
		List alPDetail = (List) session.getAttribute("PDetailListTemp");
		// (List) session.getAttribute("PDetailList");

		if (alPDetail != null)
			iSize = alPDetail.size();

		for (int i = 0; i < iSize; i++) {
			// System.out.println("Inside for : " + i );
			strCNoTemp = request.getParameter("txtCNo" + i);
			strPCshDtTemp = request.getParameter("txtUPCshDt" + i);
			strFee = request.getParameter("txtFee" + i);
			if (!strCNoTemp.equals("") && !strPCshDtTemp.equals("")) {
				objCDetailVO = new DISBCheckDetailVO();
				DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail
						.get(i);
				objPDetailVO.setIRmtFee(Integer.parseInt(strFee));
				objCDetailVO.setStrPNO(objPDetailVO.getStrPNO());
				objCDetailVO.setStrCNm(objPDetailVO.getStrPName());
				objCDetailVO.setICAmt(objPDetailVO.getIPAMT());
				objCDetailVO.setIChequeDt(objPDetailVO.getIPDate());
				objCDetailVO.setICUseDt(Integer.parseInt(strPCshDtTemp));
				//RC0036
				objCDetailVO.setStrPMethod(objPDetailVO.getStrPMethod());
				objCDetailVO.setStrUsrDept(objPDetailVO.getStrUsrDept());			
				objCDetailVO.setStrUsrArea(objPDetailVO.getStrUsrArea());	
				objCDetailVO.setStrCNo(strCNoTemp);
				alCheckList.add(objCDetailVO);

			}
		} // end of for loop........
		return alCheckList;
	} // end of maintainPList method....

	private List maintainFeeList(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		int iSize = 0;

		String strCNoTemp = "";
		String strPCshDtTemp = "";
		String strFee = "";
		DISBPaymentDetailVO objPDetailVO = null;
		// List alCheckList = new ArrayList();
		List alPayList = new ArrayList();
		List alPDetail = (List) session.getAttribute("PDetailListTemp");
		// (List) session.getAttribute("PDetailList");

		if (alPDetail != null)
			iSize = alPDetail.size();

		for (int i = 0; i < iSize; i++) {
			strCNoTemp = request.getParameter("txtCNo" + i);
			strPCshDtTemp = request.getParameter("txtUPCshDt" + i);
			strFee = request.getParameter("txtFee" + i);
			if (!strCNoTemp.equals("") && !strPCshDtTemp.equals("")) {
				// objCDetailVO = new DISBCheckDetailVO();
				objPDetailVO = new DISBPaymentDetailVO();
				// DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)alPDetail.get(i);
				objPDetailVO.setIRmtFee(Integer.parseInt(strFee));

				// objCDetailVO.setStrPNO(objPDetailVO.getStrPNO());
				// objCDetailVO.setStrCNm(objPDetailVO.getStrPName());
				// objCDetailVO.setICAmt(objPDetailVO.getIPAMT());
				// objCDetailVO.setIChequeDt(objPDetailVO.getIPDate());
				// objCDetailVO.setICUseDt(Integer.parseInt(strPCshDtTemp));
				// objCDetailVO.setStrCNo(strCNoTemp);
				// alCheckList.add(objCDetailVO);

				alPayList.add(objPDetailVO);
			}
		} // end of for loop........
		return alPayList;
	} // end of maintainPList method....

	/**
	 * @param request
	 * @param response
	 */
	private void inquiryDB(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Connection con = dbFactory.getAS400Connection("DISBPMaintainServlet.inqueryDB()");
		Statement stmt = null;
		ResultSet rs = null;
        String strSql = ""; // SQL String

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* �����e�����w�q */
		String strPDate = ""; // ��I�T�{��2
		String strDispatch = ""; // ���_

		strPDate = request.getParameter("txtPDate");
		if (strPDate != null)
			strPDate = strPDate.trim();
		else
			strPDate = "";

		strDispatch = request.getParameter("selDispatch");
		if (strDispatch != null)
			strDispatch = strDispatch.trim();
		else
			strDispatch = "";

/*RC0036        strSql = "select A.PNO,A.PNOH,A.PAMT,A.PSNAME,A.PDATE,A.PNAME,A.PID,A.PCURR,A.PMETHOD,A.PDESC,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.PBACCOUNT,A.PBBANK,A.PRACCOUNT,A.PRBANK,A.APPNO,A.POLICYNO,A.BRANCH,A.RMTFEE,A.MEMO,A.ENTRYPGM,A.PPLANT";
	        	strSql += " from CAPPAYF A ";
	            strSql += "WHERE 1=1 and A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  and A.PCFMDT2<>0 AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>''  AND A.PCSHDT = 0 AND A.PMETHOD in('A','B')  AND A.PVOIDABLE<>'Y'  ";
*/
		
/*RC0036*/
		strSql = "select A.PNO,A.PNOH,A.PAMT,A.PSNAME,A.PDATE,A.PNAME,A.PID,A.PCURR,A.PMETHOD,A.PDESC,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.PBACCOUNT,A.PBBANK,A.PRACCOUNT,A.PRBANK,A.APPNO,A.POLICYNO,A.BRANCH,A.RMTFEE,A.MEMO,A.ENTRYPGM,A.PPLANT,B.DEPT,B.USRAREA";
        strSql += " from CAPPAYF A, USER B ";
		strSql += "WHERE 1=1 and A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  and A.PCFMDT2<>0 AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>'' AND A.PCFMUSR1 = B.USRID AND A.PCSHDT = 0 AND A.PVOIDABLE<>'Y'  ";
		strSql += "AND (A.PMETHOD in('A','B') OR (B.DEPT IN ('PCD','TYB','TCB','TNB','KHB') AND A.PMETHOD = 'E')) ";

		if (!strPDate.equals("")) {
			strSql += " and A.PCFMDT2 = " + strPDate;
		}
		if (strDispatch.equals("Y")) {
			strSql += "  and A.PDISPATCH= '" + strDispatch + "' ";
		} else if (strDispatch.equals("N")) {
			strSql += "  and A.PDISPATCH='' ";
		}

		System.out.println(" inside DISBCheckCreateServlet.inquiryDB()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rs.getString("PNO"));// ��I�Ǹ�
				objPDetailVO.setIPAMT(rs.getDouble("PAMT")); // ��I���B
				objPDetailVO.setIPDate(rs.getInt("PDATE")); // �I�ڤ��
				objPDetailVO.setStrPName(rs.getString("PNAME"));// �I�ڤH�m�W
				objPDetailVO.setStrPSName(rs.getString("PSNAME"));// �I�ڤH��l�m�W
				objPDetailVO.setStrPId(rs.getString("PID"));// �I�ڤHID
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));// �I�ڤ覡
				objPDetailVO.setStrPDesc(rs.getString("PDESC")); // ��I�y�z
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS"));// �I�ڪ��A
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));// �@�o�_
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));// ���_
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));// �I�ڻȦ�
				objPDetailVO.setStrPBBank(rs.getString("PBBANK")); // �I�ڱb��
				objPDetailVO.setStrAppNo(rs.getString("APPNO")); // �n�O�Ѹ��X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));// �O�渹�X
				objPDetailVO.setStrBranch(rs.getString("BRANCH")); // �O����ݳ��
				objPDetailVO.setStrUsrDept(rs.getString("DEPT")); // RC0036 �ӿ쳡��
				objPDetailVO.setStrUsrArea(rs.getString("USRAREA")); // RC0036 �ӿ�¾��
				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "�d�L���");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			alPDetail = null;
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
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckCreate.jsp");
		dispatcher.forward(request, response);

		return;
	}

	/**
	 * @param request
	 * @param response
	 */
	private List getCheckInfo(DISBCheckDetailVO objCDetailVO)
			throws ServletException, IOException {

		Connection con = dbFactory.getAS400Connection("DISBPMaintainServlet.getCheckInfo()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String

		List alReturnInfo = new ArrayList();
		Hashtable htCheckInfo = new Hashtable();
		String strReturnFlag = "";
		String strReturnMsg = "";
		String strCNo = (String) objCDetailVO.getStrCNo().trim();

		strSql = "select A.CBKNO,A.CACCOUNT,A.CBNO,A.CNO,A.CSTATUS,A.PNO,A.CHNDFLG,B.APPROVSTA ";
		strSql += " from CAPCHKF A,CAPCKNOF B ";
		strSql += "WHERE CNO ='" + strCNo + "' AND A.CBKNO = B.CBKNO AND A.CACCOUNT = B.CACCOUNT AND A.CBNO = B.CBNO AND B.APPROVSTA <> 'E' ";// R90628

		try {
			stmt = con.createStatement();

			rs = stmt.executeQuery(strSql);
			if (rs.next()) {
				// R90628
				if ("N".equals(rs.getString("APPROVSTA"))) {
					strReturnFlag = "5";
					strReturnMsg = "�䲼���X[" + strCNo
							+ "]�A���A���֭�ӽФ��C�Ч����֭�ӽЧ@�~��A���s����H�u�}���@�~!\n";
					alReturnInfo.add(0, strReturnFlag);
					alReturnInfo.add(1, strReturnMsg);
				} else {
					if (rs.getString("CHNDFLG").equals("Y")) {// �H�u����
						if (!rs.getString("CSTATUS").trim().equals("")) {// �����w�Q�ϥ�
							strReturnFlag = "1";
							strReturnMsg = "�䲼���X[" + strCNo + "]�w�Q�ϥ�\n";
							alReturnInfo.add(0, strReturnFlag);
							alReturnInfo.add(1, strReturnMsg);
						} else {// �d�ߦ��\
							strReturnFlag = "0";
							strReturnMsg = "";
							objCDetailVO.setStrCBKNo(rs.getString("CBKNO")); // �Ȧ��w
							objCDetailVO.setStrCAccount(rs.getString("CACCOUNT")); // �Ȧ�b��
							objCDetailVO.setStrCBNo(rs.getString("CBNO")); // ���ڧ帹
							objCDetailVO.setStrCStatus(rs.getString("CSTATUS")); // �䲼���A
							objCDetailVO.setStrChndFlg(rs.getString("CHNDFLG")); // �H�u�}���_
							alReturnInfo.add(0, strReturnFlag);
							alReturnInfo.add(1, strReturnMsg);
							alReturnInfo.add(2, objCDetailVO);
						}
					} else {
						strReturnFlag = "2";
						strReturnMsg = "�䲼���X[" + strCNo + "]�D�H�u�}���β�\n";
						alReturnInfo.add(0, strReturnFlag);
						alReturnInfo.add(1, strReturnMsg);
					}
				}
			} else {// �������s�b
				strReturnFlag = "3";
				strReturnMsg = "�䲼���X[" + strCNo + "]���s�b\n";
				alReturnInfo.add(0, strReturnFlag);
				alReturnInfo.add(1, strReturnMsg);
			}
		} catch (SQLException ex) {
			alReturnInfo.add(0, "4");
			alReturnInfo.add(1, ex);
			// System.out.println("ex="+ex);

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

		return alReturnInfo;
	}

	/**
	 * @param request
	 * @param response
	 */
	// R80518 private String updateCheckInfo(List alCheckInfo,List alPDetail,int
	// iUpdDate,Connection con)
	private String updateCheckInfo(List alCheckInfo, List alPDetail,
			int iUpdDate, Connection con, int iCHKEDT) throws ServletException,
			IOException {
		System.out.println("@@@@@inside updateCheckInfo");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		List alReturnInfo = new ArrayList();

		try {
			if (alCheckInfo != null) {// 0
				if (alCheckInfo.size() > 0) {// 1
					for (int i = 0; i < alCheckInfo.size(); i++) {// 2
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo
								.get(i);
						String strPNO = (String) objCDetailVO.getStrPNO();
						if (strPNO != null)
							strPNO = strPNO.trim();
						else
							strPNO = "";

						String strCNm = (String) objCDetailVO.getStrCNm();
						if (strCNm != null)
							strCNm = strCNm.trim();
						else
							strCNm = "";
						String strCNo = (String) objCDetailVO.getStrCNo();
						if (strCNo != null)
							strCNo = strCNo.trim();
						else
							strCNo = "";
						String strCBKNo = (String) objCDetailVO.getStrCBKNo();
						if (strCBKNo != null)
							strCBKNo = strCBKNo.trim();
						else
							strCBKNo = "";

						String strCAccount = (String) objCDetailVO
								.getStrCAccount();
						if (strCAccount != null)
							strCAccount = strCAccount.trim();
						else
							strCAccount = "";

						String strCBNo = (String) objCDetailVO.getStrCBNo();
						if (strCBNo != null)
							strCBNo = strCBNo.trim();
						else
							strCBNo = "";

						double iCAmt = objCDetailVO.getICAmt();
						int iCUseDt = objCDetailVO.getICUseDt();
						String UsrDept = (String) objCDetailVO.getStrUsrDept();//RC0036
						String PMethod = (String) objCDetailVO.getStrPMethod();//RC0036
						String UsrArea = (String) objCDetailVO.getStrUsrArea();//RC0036
						
						strSql = " update CAPCHKF  set CNM=?,CAMT=CAMT+?,CHEQUEDT=?,CUSEDT=?,PNO=? ,CSTATUS='D' ";
						strSql += " where CNO =?  AND CBKNO=? AND CACCOUNT=? AND CBNO=? ";
						
						

						// System.out.println(
						// " inside DISBCheckCreateServlet.updateCheckInfo()--> strSql ="
						// + strSql);
						
						//RC0036
						if (!UsrArea.trim().equals("") && PMethod.trim().equals("E")){
							strCNm = "���y�H�ثO�I�ѥ��������q";
						}
						
						pstmtTmp = con.prepareStatement(strSql);					
						pstmtTmp.setString(1, strCNm);
						System.out.println(
						" UsrDept ="+ UsrDept);
						System.out.println(
								" UsrArea ="+ UsrArea);
						System.out.println(
								" PMethod ="+ PMethod);
						
						pstmtTmp.setDouble(2, iCAmt + ((DISBPaymentDetailVO) alPDetail.get(i)).getIRmtFee());
						// R80518 pstmtTmp.setInt(3, iChequeDt);
						pstmtTmp.setInt(3, iCHKEDT);// R80518
						// pstmtTmp.setInt(4, iUpdDate);
						pstmtTmp.setInt(4, iCUseDt);
						pstmtTmp.setString(5, strPNO);
						pstmtTmp.setString(6, strCNo);
						pstmtTmp.setString(7, strCBKNo);
						pstmtTmp.setString(8, strCAccount);
						pstmtTmp.setString(9, strCBNo);

						if (pstmtTmp.executeUpdate() < 1) {// 3
							strReturnMsg = "��s���ک����ɥ���";
							return strReturnMsg;
						}// 3
						pstmtTmp.close();
					}// 2 END OF FOR
				}// 1
			}// 0
		} catch (SQLException ex) {
			strReturnMsg = "��s���ک����ɥ���:ex=" + ex;
		}
		return strReturnMsg;
	}

	/**
	 * @param request
	 * @param response
	 */
	private String updatePDetails(List alCheckInfo, List alPDetail,
			int iUpdDate, int iUpdTime, String strLogonUser, Connection con)
			throws ServletException, IOException {
		System.out.println("@@@@@inside updatePConfirmed");
		PreparedStatement pstmtTmp = null;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		try {
			if (alCheckInfo != null) {
				if (alCheckInfo.size() > 0) {

					for (int i = 0; i < alCheckInfo.size(); i++) {
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo.get(i);
						DISBPaymentDetailVO paymentVO = (DISBPaymentDetailVO) alPDetail.get(i);

						strSql = " update CAPPAYF  set PBBANK = ? , PBACCOUNT = ? , PCHECKNO=? ,PCSHDT=?,PSTATUS='B' ";
						strSql += "  , UPDDT= ? , UPDTM = ?, UPDUSR =?, REMIT_FEE=?  where PNO =?";

						// System.out.println(" inside DISBCheckCreateServlet.updatePDetails()--> " + strSql);

						// �Ulog
						strReturnMsg = disbBean.insertCAPPAYFLOG(objCDetailVO.getStrPNO().trim(), strLogonUser, iUpdDate, iUpdTime, con);
						if (strReturnMsg.equals("")) {
							pstmtTmp = con.prepareStatement(strSql);
							pstmtTmp.setString(1, objCDetailVO.getStrCBKNo().trim());
							pstmtTmp.setString(2, objCDetailVO.getStrCAccount().trim());
							pstmtTmp.setString(3, objCDetailVO.getStrCNo().trim());
							// pstmtTmp.setInt(4, iUpdDate);
							pstmtTmp.setInt(4, objCDetailVO.getICUseDt());
							pstmtTmp.setInt(5, iUpdDate);
							pstmtTmp.setInt(6, iUpdTime);
							pstmtTmp.setString(7, strLogonUser);
							pstmtTmp.setInt(8, paymentVO.getIRmtFee());
							pstmtTmp.setString(9, objCDetailVO.getStrPNO().trim());

							if (pstmtTmp.executeUpdate() < 1) {
								strReturnMsg = "��s��I�D�ɥ���";
								return strReturnMsg;
							}
							pstmtTmp.close();
						} else {
							return strReturnMsg;
						}
					}

				}
			}
		} catch (SQLException e) {
			strReturnMsg = "��s��I�D�ɥ���: e=" + e;

		}
		return strReturnMsg;
	}
}
 