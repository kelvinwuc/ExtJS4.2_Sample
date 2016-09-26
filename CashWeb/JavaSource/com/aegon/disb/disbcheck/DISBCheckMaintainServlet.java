package com.aegon.disb.disbcheck;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBCSubjectTool;
import com.aegon.disb.util.DISBCheckDetailVO;
import com.aegon.disb.util.DISBPaymentDetailVO;


/**
 * System   :
 * 
 * Function : ���ں��@
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.20 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckMaintainServlet.java,v $
 * $Revision 1.20  2014/10/22 03:50:04  misariel
 * $QC0272-�䲼�@�o�B���L���D
 * $
 * $Revision 1.19  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255�Q�v�ܰʫ��Y���~���O�I�M��
 * $
 * $Revision 1.18  2013/02/26 03:17:13  ODCZheJun
 * $R00135 BRD5-5----5-9
 * $
 * $Revision 1.17  2013/02/22 03:37:43  ODCWilliam
 * $william wu
 * $PA0024
 * $bill cash day
 * $
 * $Revision 1.16  2012/07/17 02:50:31  MISSALLY
 * $RA0043 / RA0081
 * $1.�@�ȥx�s�U���ɮ榡�վ�
 * $2.���ڮw�s���֭��v����Ū�]�w
 * $
 * $Revision 1.15  2012/06/26 06:35:25  MISSALLY
 * $BUG FIX --- �z�߽s��������
 * $
 * $Revision 1.14  2012/06/22 06:16:41  MISSALLY
 * $QA0215---����h�ק@�~���N�z�߽s���a�J�s��I���
 * $
 * $Revision 1.13  2010/11/23 06:27:42  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.12  2009/04/23 06:32:32  missteven
 * $R90164 �t�ξ�岼�ڭ��L
 * $
 * $Revision 1.11  2009/02/18 06:44:22  misodin
 * $R90080 ��ե󤣥i�@�o���}
 * $R70339 �ӽЭ��}User���s�ӿ�H
 * $
 * $Revision 1.10  2008/08/15 04:07:03  misvanessa
 * $R80620_�|�p��ؤU���ɮ׷s�W3���
 * $
 * $Revision 1.9  2007/10/05 09:05:35  MISVANESSA
 * $R70770_ACTCD2 �X�� 11 �X
 * $
 * $Revision 1.8  2007/08/28 01:41:20  MISVANESSA
 * $R70574_SPUL�t���s�W�ץX�ɮ�
 * $
 * $Revision 1.7  2006/11/07 07:53:55  miselsa
 * $R61017_ActCd5��13�X��26�X
 * $
 * $Revision 1.6  2006/10/31 09:00:39  MISVANESSA
 * $R60420_���ڲ��ʬ�"4"���},�ݿ�J�ӽЭ��}USER
 * $
 * $Revision 1.5  2006/09/01 08:45:53  miselsa
 * $Q60159_1.���ڪ��AC->5 �|�p��حק�
 * $       2.���ڪ��A5->6 �|�p��حק�
 * $       3.�ɬ�101T�M101720�����,�~�|�a�Ȧ�N�X,�_�h��0000
 * $         ,���p���ڪ��A5->6�ɻȦ�N�X�T�w��8223
 * $       4.�s�W�Ȧ�N�X8083
 * $       5.D->V,D->4,1->4,2->4�|�p����ܧ�
 * $       6.�s�W��ղ��|�p����
 * $
 * $Revision 1.4  2006/08/25 05:57:15  miselsa
 * $Q60159_�W�[ 2-> V ,R->V,R->4�|�p����
 * $
 * $Revision 1.3  2006/08/17 07:59:32  miselsa
 * $Q60159_1.���ڪ��AC->5 �|�p��حק�
 * $       2.���ڪ��A5->6 �|�p��حק�
 * $       3.�ɬ�101T�M101720�����,�~�|�a�Ȧ�N�X,�_�h��0000
 * $         ,���p���ڪ��A5->6�ɻȦ�N�X�T�w��8223
 * $       4.�s�W�Ȧ�N�X8083
 * $       5.D->V,D->4,1->4,2->4�|�p����ܧ�
 * $       6.�s�W��ղ��|�p����
 * $
 * $Revision 1.2  2006/08/14 08:13:41  miselsa
 * $Q60159_�|�p�����ɶU��V���~�ηs�W��ղ��@�o���|�p����
 * $
 * $Revision 1.1  2006/06/29 09:40:37  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.13  2006/04/10 05:39:44  misangel
 * $R60200:�X�ǥ\�ണ��
 * $
 * $Revision 1.1.2.12  2005/10/31 03:33:33  misangel
 * $R50820:��I�\�ണ��
 * $
 * $Revision 1.1.2.11  2005/08/08 01:50:54  misangel
 * $�w�s���i�@�o
 * $
 * $Revision 1.1.2.9  2005/04/28 08:56:25  miselsa
 * $R30530������ժ��ק�
 * $
 * $Revision 1.1.2.8  2005/04/25 07:23:52  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.7  2005/04/22 01:56:35  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.6  2005/04/20 03:29:00  miselsa
 * $R30530_�קﲼ�ڳƵ�
 * $
 * $Revision 1.1.2.5  2005/04/04 07:02:22  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

public class DISBCheckMaintainServlet extends InitDBServlet {

	private DISBBean disbBean = null;

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String strAction = new String("");
		strAction = request.getParameter("txtAction");

		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		try {
			if (strAction.equals("Query"))
				queryStatus(request, response);
			else if (strAction.equals("UpdateV"))
				updateStatusToV(request, response);
			else if (strAction.equals("Update3"))
				updateStatusTo3(request, response);
			else if (strAction.equals("Update4"))
				updateStatusTo4(request, response);
			else if (strAction.equals("Update5"))
				updateStatusTo5(request, response);
			else if (strAction.equals("UpdateR") 
					|| strAction.equals("Update1")
					|| strAction.equals("Update2")
					|| strAction.equals("Update6"))
				updateStatusProcess(request, response);
			else if (strAction.equals("UpdateData"))
				updateCheckData(request, response);
			else if (strAction.equals("UpdateBatch"))
				updateBatchStatusTo3(request, response);
			else
				System.err.println("Hello, that's not a valid UseCase!");

		} catch (Exception e) {
			System.err.println("DISBCheckMaintainServlet Exception >>> " + e);
			e.printStackTrace();
		}
		return;
	}
	
	private void queryStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
		Connection connBean = dbFactory.getAS400Connection("DISBCheckMaintainServlet.queryStatus()");
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			//william wu 2012/12/25 PA0024 ���ڧI�{��
			stmt = connBean.prepareStatement("SELECT TRIM(CNO) AS CNO,TRIM(CBNO) AS CBNO,TRIM(CBKNO) AS CBKNO,TRIM(CACCOUNT) AS CACCOUNT,CNM,CAMT,CAST(CCASHDT AS CHAR(7)) AS CHEQUEDT,CAST(CUSEDT AS CHAR(7)) AS CUSEDT,PNO,MEMO "
							+ "FROM CAPCHKF "
							+ "WHERE CNO BETWEEN ? AND ? AND CSTATUS ='D' ");

			stmt.setString(1, request.getParameter("txtSNo"));
			stmt.setString(2, request.getParameter("txtENo"));
			rs = stmt.executeQuery();
			request.setAttribute("data", rs);
			RequestDispatcher callPage = getServletContext().getRequestDispatcher("/DISB/DISBCheck/DISBCheckReprintBatch.jsp");
			callPage.forward(request, response);
			return;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (connBean != null)
				dbFactory.releaseAS400Connection(connBean);
		}
	}

	private void updateStatusTo5(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckMaintainServlet.updateStatusTo5()");
		String strReturnMsg = "";
		List alReturnInfo = new ArrayList();

		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strCNo = "";		// ���ڸ��X
		String strCBNo = "";	// ���ڧ帹
		String strCBkNo = "";	// �Ȧ��w
		String strCAccount = "";// �Ȧ�b��
		String strCStatus = ""; // ����s�����A
		String strPNo = "";		// ��I�Ǹ�
		String strCMEMO = "";
		String strOCStatus = "";// �ܧ�e�����A
		String strCAmt = "";	// ���ڪ��B
		String strChequeDtU = "";// ���ڨ����
		String strC4User = "";	// �ӽЭ��}USER R60420

		String strServiceBranch = "";
		String strPlant = "";

		strCNo = request.getParameter("txtCNoU");
		if (strCNo != null)
			strCNo = strCNo.trim();
		else
			strCNo = "";

		strCBNo = request.getParameter("txtCBNoU");
		if (strCBNo != null)
			strCBNo = strCBNo.trim();
		else
			strCBNo = "";

		strCBkNo = request.getParameter("txtCBkNoU");
		if (strCBkNo != null)
			strCBkNo = strCBkNo.trim();
		else
			strCBkNo = "";

		strCAccount = request.getParameter("txtCAccountU");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCStatus = request.getParameter("txtUpdateStatus");
		if (strCStatus != null)
			strCStatus = strCStatus.trim();
		else
			strCStatus = "";

		strPNo = request.getParameter("txtPNoU");
		if (strPNo != null)
			strPNo = strPNo.trim();
		else
			strPNo = "";

		strCMEMO = request.getParameter("txtCMEMO");
		if (strCMEMO != null)
			strCMEMO = strCMEMO.trim();
		else
			strCMEMO = "";

		strOCStatus = request.getParameter("txtCStatusU");
		if (strOCStatus != null)
			strOCStatus = strOCStatus.trim();
		else
			strOCStatus = "";

		strChequeDtU = request.getParameter("txtChequeDtU");
		if (strChequeDtU != null)
			strChequeDtU = strChequeDtU.trim();
		else
			strChequeDtU = "";

		strCAmt = request.getParameter("txtCAMTU");
		if (strCAmt != null)
			strCAmt = strCAmt.trim();
		else
			strCAmt = "0";

		// R60420 �ӽЭ��}USER
		strC4User = request.getParameter("txtC4User");
		if (strC4User != null)
			strC4User = strC4User.trim();
		else
			strC4User = "";

		/* ��s��Ʈw */
		try {
			/* �d�ߤ�I�D�ɸ�� */
			alReturnInfo = inquiryPDetails(strPNo, con);
			strReturnMsg = (String) alReturnInfo.get(0);

			String PsrCd = null;/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� */
			if (strReturnMsg.equals("")) {
				alReturnInfo.remove(0);
				/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� Start */
				DISBPaymentDetailVO PDobj = (DISBPaymentDetailVO) alReturnInfo.get(0);
				PsrCd = (String) PDobj.getStrPSrcCode().trim();
				/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� End */

				strServiceBranch = PDobj.getServicingBranch();
				strPlant = PDobj.getStrPPlant();
				
				/* ��s���ک����� */
				strReturnMsg = updateCheckStatus(strCNo, strCBkNo, strCAccount, strCBNo, strCStatus, strCMEMO, iUpdDate, con, strC4User);
				List alReturnInfoByCNo = (List) inquiryPDetailsByCNo(strCNo, con);//QC0272
				if (strReturnMsg.equals("")) {
					/* ��s�D�I�D�ɤ���I���A��������A, �@�o�X��Y */
					//QC0272			
					for (int i = 0; i < alReturnInfoByCNo.size(); i++)  {
						DISBPaymentDetailVO objCDetailVO = (DISBPaymentDetailVO) alReturnInfoByCNo.get(i);
						strPNo = objCDetailVO.getStrPNO();			 
					    strReturnMsg = updatePStatus(strPNo, "A", iUpdDate, iUpdTime, strLogonUser, con);
					    if (strReturnMsg.equals("")) {
							/* �N�ª���I��Ʒs�W�@�����I�D�ɤ�, �pstrReturnMsg���ťժ��\ */
							strReturnMsg = createNewPayment((DISBPaymentDetailVO) alReturnInfo.get(i), strLogonUser, iUpdDate, iUpdTime, con, strC4User); // R70339
							
						}
					}
					if (strReturnMsg.equals("")) {
						// �s�W�@���ɶU��ƨ�CAPCHAF��
						if (strOCStatus.equals("C")) {
							/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p����,�[�J��I�ӷ����Ѽ� */
							strReturnMsg = insertCapchaf(strCNo, strOCStatus, strCStatus, strCBkNo, strChequeDtU, strCAmt, strLogonUser, PsrCd, iUpdDate, iUpdTime, con, strServiceBranch, strPlant);
						}
					}
					
				}
			}

			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtMsg", "��s���ڪ��A������-->" + strReturnMsg + "(������" + strCNo + ")");
			} else {
				request.setAttribute("txtMsg", "��s���ڪ��A���������\(������" + strCNo + ")" + strReturnMsg);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("txtMsg", "��s���ڪ��A����������(������" + strCNo + ")-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", strAction);
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	/**
	 * @param request
	 * @param response
	 */
	private void updateStatusTo4(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckMaintainServlet.updateStatusTo4()");
		String strReturnMsg = "";
		List alReturnInfo = new ArrayList();

		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strCNo = "";		// ���ڸ��X
		String strCBNo = "";	// ���ڧ帹
		String strCBkNo = "";	// �Ȧ��w
		String strCAccount = "";// �Ȧ�b��
		String strCStatus = ""; // ����s�����A
		String strPNo = "";		// ��I�Ǹ�
		String strCMEMO = "";
		String strOCStatus = "";// �ܧ�e�����A
		String strCAmt = "";	// ���ڪ��B
		String strChequeDtU = "";// ���ڨ����
		String strC4User = "";	// �ӽЭ��}USER R60420

		String strServiceBranch = "";
		String strPlant = "";

		strCNo = request.getParameter("txtCNoU");
		if (strCNo != null)
			strCNo = strCNo.trim();
		else
			strCNo = "";

		strCBNo = request.getParameter("txtCBNoU");
		if (strCBNo != null)
			strCBNo = strCBNo.trim();
		else
			strCBNo = "";

		strCBkNo = request.getParameter("txtCBkNoU");
		if (strCBkNo != null)
			strCBkNo = strCBkNo.trim();
		else
			strCBkNo = "";

		strCAccount = request.getParameter("txtCAccountU");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCStatus = request.getParameter("txtUpdateStatus");
		if (strCStatus != null)
			strCStatus = strCStatus.trim();
		else
			strCStatus = "";

		strPNo = request.getParameter("txtPNoU");
		if (strPNo != null)
			strPNo = strPNo.trim();
		else
			strPNo = "";

		strCMEMO = request.getParameter("txtCMEMO");
		if (strCMEMO != null)
			strCMEMO = strCMEMO.trim();
		else
			strCMEMO = "";

		strOCStatus = request.getParameter("txtCStatusU");
		if (strOCStatus != null)
			strOCStatus = strOCStatus.trim();
		else
			strOCStatus = "";

		strChequeDtU = request.getParameter("txtChequeDtU");
		if (strChequeDtU != null)
			strChequeDtU = strChequeDtU.trim();
		else
			strChequeDtU = "";

		strCAmt = request.getParameter("txtCAMTU");
		if (strCAmt != null)
			strCAmt = strCAmt.trim();
		else
			strCAmt = "0";

		// R60420 �ӽЭ��}USER
		strC4User = request.getParameter("txtC4User");
		if (strC4User != null)
			strC4User = strC4User.trim();
		else
			strC4User = "";
		/* ��s��Ʈw */
		try {
			/* �d�ߤ�I�D�ɸ�� */
			alReturnInfo = inquiryPDetails(strPNo, con);
			strReturnMsg = (String) alReturnInfo.get(0);

			String PsrCd = null;/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� */
			if (strReturnMsg.equals("")) {
				alReturnInfo.remove(0);
				/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� Start */
				DISBPaymentDetailVO PDobj = (DISBPaymentDetailVO) alReturnInfo.get(0);
				PsrCd = (String) PDobj.getStrPSrcCode().trim();
				/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� End */
				// R90080 ��ե󤣥i�@�o���}
				if (PsrCd.equals("D2")) {
					strReturnMsg = "��ե󤣥i�@�o���}";
				}

				strServiceBranch = PDobj.getServicingBranch();
				strPlant = PDobj.getStrPPlant();

				/* ��s���ک����� */
				strReturnMsg = updateCheckStatus(strCNo, strCBkNo, strCAccount, strCBNo, strCStatus, strCMEMO, iUpdDate, con, strC4User);
				List alReturnInfoByCNo = (List) inquiryPDetailsByCNo(strCNo, con);//QC0272 
				if (strReturnMsg.equals("")) {
					/* ��s�D�I�D�ɤ��@�o�X��Y �Τ�I���A������(A) */
					//QC0272
					for (int i = 0; i < alReturnInfoByCNo.size(); i++)  {                                    
						DISBPaymentDetailVO objCDetailVO = (DISBPaymentDetailVO) alReturnInfoByCNo.get(i);     
						strPNo = objCDetailVO.getStrPNO();			                                         
						strReturnMsg = updatePStatus(strPNo, "A", iUpdDate, iUpdTime, strLogonUser, con);
					                                                                                        
					    if (strReturnMsg.equals("")) {
						/* �N�ª���I��Ʒs�W�@�����I�D�ɤ�, �pstrReturnMsg���ťժ��\ */
						    strReturnMsg = createNewPayment((DISBPaymentDetailVO) alReturnInfoByCNo.get(i), strLogonUser, iUpdDate, iUpdTime, con, strC4User); // R70339
						    
					   }
					}
					if (strReturnMsg.equals("")) {
						// �s�W�@���ɶU��ƨ�CAPCHAF��
				            if (strOCStatus.equals("D")
								|| strOCStatus.equals("1")
								|| strOCStatus.equals("2")
								|| strOCStatus.equals("R")){  // Q60159 20060821�W�[R���|�p����
							/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p����,�[�J��I�ӷ����Ѽ� */
							   strReturnMsg = insertCapchaf(strCNo, strOCStatus, strCStatus, strCBkNo, strChequeDtU, strCAmt, strLogonUser, PsrCd, iUpdDate, iUpdTime, con, strServiceBranch, strPlant);
						    }
					    }
				}
			}

			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtMsg", "��s���ڪ��A�����}-->" + strReturnMsg + "(������" + strCNo + ")");
			} else {
				request.setAttribute("txtMsg", "��s���ڪ��A�����}���\(������" + strCNo + ")" + strReturnMsg);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("txtMsg", "��s���ڪ��A�����}����(������" + strCNo + ")-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", strAction);
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}
	
	/**
	 * @param request
	 * @param response
	 */
	private void updateBatchStatusTo3(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckMaintainServlet.updateBatchStatusTo3()");
		String strReturnMsg = "";
		List alReturnInfo = new ArrayList();

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String[] strCNo = request.getParameterValues("txtCNoU");			// ���ڸ��X
		String[] strCBNo = request.getParameterValues("txtCBNoU");			// ���ڧ帹
		String[] strCBkNo = request.getParameterValues("txtCBkNoU");		// �Ȧ��w
		String[] strCAccount = request.getParameterValues("txtCAccountU");	// �Ȧ�b��
		String strCStatus = request.getParameter("txtUpdateStatus");		// ����s�����A�G���L
		String[] strPNo = request.getParameterValues("txtPNoU");			// ��I�Ǹ�
		String[] strCMEMO = request.getParameterValues("txtCMEMO");			// �Ƶ�
		String strAction = request.getParameter("txtAction") != null ? request.getParameter("txtAction") : "";

		/* ��s��Ʈw */
		try {
			/* �d�ߤ�I�D�ɸ�� */
			for (int index = 0; index < strCNo.length; index++) {
				alReturnInfo = inquiryPDetails(strPNo[index], con);
				strReturnMsg = (String) alReturnInfo.get(0);
				if (strReturnMsg.equals("")) {
					alReturnInfo.remove(0);
					/* ��s���ک����� */
					strReturnMsg = updateCheckStatus(strCNo[index], strCBkNo[index], strCAccount[index], strCBNo[index], strCStatus, strCMEMO[index], iUpdDate, con, strLogonUser);
					if (strReturnMsg.equals("")) {
						List alReturnInfoByCNo = (List) inquiryPDetailsByCNo(strCNo[index], con);//QC0272
						/* ��s�D�I�D�ɤ���I���A���ť�,�������ť�,�}�ߤ鬰0 */
						//QC0272					    
						for (int i = 0; i < alReturnInfoByCNo.size(); i++)  {
							DISBPaymentDetailVO objCDetailVO = (DISBPaymentDetailVO) alReturnInfoByCNo.get(i);
							strPNo[index] = objCDetailVO.getStrPNO();
							strReturnMsg = updatePDetails(strPNo[index], iUpdDate, iUpdTime, strLogonUser, con);
						}
					}
				}
				if (!strReturnMsg.equals("")) {
					if (isAEGON400)
						con.rollback();
					request.setAttribute("txtMsg", "��s��岼�ڪ��A�����L-->" + strReturnMsg);
				} else {
					request.setAttribute("txtMsg", "��s��岼�ڪ��A�����L���\");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("txtMsg", "��s��岼�ڪ��A�����L����-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		}
		request.setAttribute("txtAction", strAction);
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckReprintBatch.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private void updateStatusTo3(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckMaintainServlet.updateStatusTo3()");
		String strReturnMsg = "";
		List alReturnInfo = new ArrayList();

		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strCNo = "";			// ���ڸ��X
		String strCBNo = "";		// ���ڧ帹
		String strCBkNo = "";		// �Ȧ��w
		String strCAccount = "";	// �Ȧ�b��
		String strCStatus = "";		// ����s�����A
		String strPNo = "";			// ��I�Ǹ�
		String strCMEMO = "";
		String strC4User = "";		// �ӽЭ��}USER R60420

		strCNo = request.getParameter("txtCNoU");
		if (strCNo != null)
			strCNo = strCNo.trim();
		else
			strCNo = "";

		strCBNo = request.getParameter("txtCBNoU");
		if (strCBNo != null)
			strCBNo = strCBNo.trim();
		else
			strCBNo = "";

		strCBkNo = request.getParameter("txtCBkNoU");
		if (strCBkNo != null)
			strCBkNo = strCBkNo.trim();
		else
			strCBkNo = "";

		strCAccount = request.getParameter("txtCAccountU");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCStatus = request.getParameter("txtUpdateStatus");
		if (strCStatus != null)
			strCStatus = strCStatus.trim();
		else
			strCStatus = "";
		
		strPNo = request.getParameter("txtPNoU");
		if (strPNo != null)
			strPNo = strPNo.trim();
		else
			strPNo = "";

		strCMEMO = request.getParameter("txtCMEMO");
		if (strCMEMO != null)
			strCMEMO = strCMEMO.trim();
		else
			strCMEMO = "";

		// R60420 �ӽЭ��}USER
		strC4User = request.getParameter("txtC4User");
		if (strC4User != null)
			strC4User = strC4User.trim();
		else
			strC4User = "";

		/* ��s��Ʈw */
		try {
			/* �d�ߤ�I�D�ɸ�� */
			alReturnInfo = inquiryPDetails(strPNo, con);
			strReturnMsg = (String) alReturnInfo.get(0);
			if (strReturnMsg.equals("")) {
				alReturnInfo.remove(0);
				/* ��s���ک����� */
				strReturnMsg = updateCheckStatus(strCNo, strCBkNo, strCAccount, strCBNo, strCStatus, strCMEMO, iUpdDate, con, strC4User);
				List alReturnInfoByCNo = (List) inquiryPDetailsByCNo(strCNo, con);//QC0272
				if (strReturnMsg.equals("")) {
					/* ��s�D�I�D�ɤ���I���A���ť�,�������ť�,�}�ߤ鬰0 */
					//QC0272			
					for (int i = 0; i < alReturnInfoByCNo.size(); i++)  {
						DISBPaymentDetailVO objCDetailVO = (DISBPaymentDetailVO) alReturnInfoByCNo.get(i);
						strPNo = objCDetailVO.getStrPNO();			 
					    strReturnMsg = updatePDetails(strPNo, iUpdDate, iUpdTime, strLogonUser, con);
					}
				}
			}
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtMsg", "��s���ڪ��A�����L-->" + strReturnMsg + "(������" + strCNo + ")");
			} else {
				request.setAttribute("txtMsg", "��s���ڪ��A�����L���\(������" + strCNo + ")");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("txtMsg", "��s���ڪ��A�����L����(������" + strCNo + ")-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", strAction);
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private void updateStatusToV(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckMaintainServlet.updateStatusProcess()");
		String strReturnMsg = "";

		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strCNo = "";		// ���ڸ��X
		String strCBNo = "";		// ���ڧ帹
		String strCBkNo = "";		// �Ȧ��w
		String strCAccount = "";	// �Ȧ�b��
		String strCStatus = "";		// ����s�����A
		String strPNo = "";			// ��I�Ǹ�
		String strCMEMO = "";		// �䲼�Ƶ�
		String strOCStatus = "";	// �ܧ�e�����A
		String strCAmt = "";		// ���ڪ��B
		String strChequeDtU = "";	// ���ڨ����
		String strC4User = "";		// �ӽЭ��}USER R60420

		String strServiceBranch = "";
		String strPlant = "";
		
		strCNo = request.getParameter("txtCNoU");
		if (strCNo != null)
			strCNo = strCNo.trim();
		else
			strCNo = "";

		strCBNo = request.getParameter("txtCBNoU");
		if (strCBNo != null)
			strCBNo = strCBNo.trim();
		else
			strCBNo = "";

		strCBkNo = request.getParameter("txtCBkNoU");
		if (strCBkNo != null)
			strCBkNo = strCBkNo.trim();
		else
			strCBkNo = "";

		strCAccount = request.getParameter("txtCAccountU");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCStatus = request.getParameter("txtUpdateStatus");
		if (strCStatus != null)
			strCStatus = strCStatus.trim();
		else
			strCStatus = "";
		
		strPNo = request.getParameter("txtPNoU");
		if (strPNo != null)
		strPNo = strPNo.trim();
		else
		strPNo = "";
      

		strCMEMO = request.getParameter("txtCMEMO");
		if (strCMEMO != null)
			strCMEMO = strCMEMO.trim();
		else
			strCMEMO = "";

		strOCStatus = request.getParameter("txtCStatusU");
		if (strOCStatus != null)
			strOCStatus = strOCStatus.trim();
		else
			strOCStatus = "";

		strChequeDtU = request.getParameter("txtChequeDtU");
		if (strChequeDtU != null)
			strChequeDtU = strChequeDtU.trim();
		else
			strChequeDtU = "";

		strCAmt = request.getParameter("txtCAMTU");
		if (strCAmt != null)
			strCAmt = strCAmt.trim();
		else
			strCAmt = "0";

		strC4User = request.getParameter("txtC4User");
		if (strC4User != null)
			strC4User = strC4User.trim();
		else
			strC4User = "";


		try {
			/* ��s���ک����� */
			strReturnMsg = updateCheckStatus(strCNo, strCBkNo, strCAccount, strCBNo, strCStatus, strCMEMO, iUpdDate, con, strC4User);
			List alReturnInfoByCNo = (List) inquiryPDetailsByCNo(strCNo, con);//QC0272

			if (strReturnMsg.equals("")) {
				if (!strOCStatus.equals("")) { // �w�s���@�o�L���ڧ�s��I��
					/* ��s�D�I�D�ɤ��@�o�X��Y �Τ�I���A������(A) */
 					//QC0272			
					for (int i = 0; i < alReturnInfoByCNo.size(); i++)  {
						DISBPaymentDetailVO objCDetailVO = (DISBPaymentDetailVO) alReturnInfoByCNo.get(i);
						strPNo = objCDetailVO.getStrPNO();			 
					    strReturnMsg = updatePStatus(strPNo, "A", "Y", iUpdDate, iUpdTime, strLogonUser, con);					    
				    }//QC0272
					if (strReturnMsg.equals("")) {
						    // �s�W�@���ɶU��ƨ�CAPCHAF��
						    if (strOCStatus.equals("D") || strOCStatus.equals("1") || strOCStatus.equals("2") || strOCStatus.equals("R")) // Q60159�쪬�A��2��R�]�n
					     	{
							/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� Start */
						    	List alReturnInfo = inquiryPDetails(strPNo, con);
						    	strReturnMsg = (String) alReturnInfo.get(0);
						    	String PsrCd = null;/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� */
						    	if (strReturnMsg.equals("")) {
							    	alReturnInfo.remove(0);
							    	DISBPaymentDetailVO PDobj = (DISBPaymentDetailVO) alReturnInfo.get(0);
							    	PsrCd = (String) PDobj.getStrPSrcCode().trim();
							    	strServiceBranch = PDobj.getServicingBranch();
								    strPlant = PDobj.getStrPPlant();
							    }
							/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p���� End */
							/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p����,�[�J��I�ӷ����Ѽ� */
							strReturnMsg = insertCapchaf(strCNo, strOCStatus, strCStatus, strCBkNo, strChequeDtU, strCAmt, strLogonUser, PsrCd, iUpdDate, iUpdTime, con, strServiceBranch, strPlant);
						}
					}
				} 
			}
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtMsg", "��s���ڪ��A���@�o-->" + strReturnMsg + "(������" + strCNo + ")");
			} else {
				request.setAttribute("txtMsg", "��s���ڪ��A���@�o���\(������" + strCNo + ")");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("txtMsg", "��s���ڪ��A���@�o����(������" + strCNo + ")-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", strAction);
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private void updateStatusProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckMaintainServlet.updateStatusProcess()");
		String strReturnMsg = "";

		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strCNo = ""; 		// ���ڸ��X
		String strCBNo = ""; 		// ���ڧ帹
		String strCBkNo = ""; 		// �Ȧ��w
		String strCAccount = ""; 	// �Ȧ�b��
		String strCStatus = ""; 	// ����s�����A
		String strCStatusDesc = "";	// ���A���廡��
		String strCMEMO = "";
		String strOCStatus = "";	// �ܧ�e�����A
		String strCAmt = "";		// ���ڪ��B
		String strChequeDtU = "";	// ���ڨ����
		String strPNo = "";			// ��I�Ǹ�
		String strC4User = "";		// �ӽЭ��}USER R60420

		String strServiceBranch = "";
		String strPlant = "";

		strCNo = request.getParameter("txtCNoU");
		if (strCNo != null)
			strCNo = strCNo.trim();
		else
			strCNo = "";

		strCBNo = request.getParameter("txtCBNoU");
		if (strCBNo != null)
			strCBNo = strCBNo.trim();
		else
			strCBNo = "";

		strCBkNo = request.getParameter("txtCBkNoU");
		if (strCBkNo != null)
			strCBkNo = strCBkNo.trim();
		else
			strCBkNo = "";

		strCAccount = request.getParameter("txtCAccountU");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCStatus = request.getParameter("txtUpdateStatus");
		if (strCStatus != null)
			strCStatus = strCStatus.trim();
		else
			strCStatus = "";

		if (strCStatus.equals("R"))
			strCStatusDesc = "�h�^";
		else if (strCStatus.equals("1"))
			strCStatusDesc = "�O�@�~��";
		else if (strCStatus.equals("2"))
			strCStatusDesc = "�O�G�~��";
		else if (strCStatus.equals("6"))
			strCStatusDesc = "���v�P�M";

		strCMEMO = request.getParameter("txtCMEMO");
		if (strCMEMO != null)
			strCMEMO = strCMEMO.trim();
		else
			strCMEMO = "";

		strOCStatus = request.getParameter("txtCStatusU");
		if (strOCStatus != null)
			strOCStatus = strOCStatus.trim();
		else
			strOCStatus = "";

		strChequeDtU = request.getParameter("txtChequeDtU");
		if (strChequeDtU != null)
			strChequeDtU = strChequeDtU.trim();
		else
			strChequeDtU = "";

		strCAmt = request.getParameter("txtCAMTU");
		if (strCAmt != null)
			strCAmt = strCAmt.trim();
		else
			strCAmt = "0";

		strPNo = request.getParameter("txtPNoU");
		if (strPNo != null)
			strPNo = strPNo.trim();
		else
			strPNo = "";

		// R60420 �ӽЭ��}USER
		strC4User = request.getParameter("txtC4User");
		if (strC4User != null)
			strC4User = strC4User.trim();
		else
			strC4User = "";

		/* ��s��Ʈw */

		List alReturnInfo = inquiryPDetails(strPNo, con);
		strReturnMsg = (String) alReturnInfo.get(0);
		String PsrCd = null;
		if (strReturnMsg.equals("")) {
			alReturnInfo.remove(0);

			DISBPaymentDetailVO PDobj = (DISBPaymentDetailVO) alReturnInfo.get(0);
			PsrCd = (String) PDobj.getStrPSrcCode().trim();

			strServiceBranch = PDobj.getServicingBranch();
			strPlant = PDobj.getStrPPlant();
			/* ��s���ک����� */
			strReturnMsg = updateCheckStatus(strCNo, strCBkNo, strCAccount, strCBNo, strCStatus, strCMEMO, iUpdDate, con, strC4User);
			if (strReturnMsg.equals("")) {
				// �s�W�@���ɶU��ƨ�CAPCHAF��
				if ((strOCStatus.equals("D") && strCStatus.equals("1"))
						|| (strOCStatus.equals("R") && strCStatus.equals("1"))
						|| (strOCStatus.equals("1") && strCStatus.equals("2"))
						|| (strOCStatus.equals("R") && strCStatus.equals("2"))
						|| (strOCStatus.equals("5") && strCStatus.equals("6"))) 
				{
					/* Q60159 ��I�ӷ�����ե�n���ͤ��P���|�p����,�[�J��I�ӷ����Ѽ� */
					strReturnMsg = insertCapchaf(strCNo, strOCStatus, strCStatus, strCBkNo, strChequeDtU, strCAmt, strLogonUser, PsrCd, iUpdDate, iUpdTime, con, strServiceBranch, strPlant);
				}
			}
		}

		if (con != null) {
			dbFactory.releaseAS400Connection(con);
		}

		if (strReturnMsg.equals("")) {
			request.setAttribute("txtMsg", "��s���ڪ��A��" + strCStatusDesc + "���\(������" + strCNo + ")");
		} else {
			request.setAttribute("txtMsg", "��s���ڪ��A��" + strCStatusDesc + strReturnMsg + "(������" + strCNo + ")");
		}
		request.setAttribute("txtAction", strAction);
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private List inquiryPDetails(String strPNo, Connection con) {
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		strSql = "select A.ENTRYDT,A.PAMT,A.PCFMDT1,A.PCFMTM1,A.PCFMDT2,A.PCFMTM2,A.PDATE,A.UPDDT,A.UPDTM,A.APPNO,A.POLICYNO,A.ENTRYUSR,A.PAUTHCODE,A.PBACCOUNT,A.PBBANK,A.PCFMUSR1,A.PCFMUSR2,A.PCHECKNO,A.PCRDEFFMY,A.PCRDNO,A.PCRDTYPE,A.PDESC,A.PDISPATCH,A.PID,A.PMETHOD,A.PNAME,A.PSNAME,A.PNO,A.PNOH,A.PRACCOUNT,A.PRBANK,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.BRANCH,A.PCURR,A.RMTFEE,A.MEMO,A.ENTRYPGM,A.PPLANT ";
		strSql += ",PAMTNT,PCLMNUM,SRVBH,PPLANT,ANNPDATE "; // R70339
		strSql += " from CAPPAYF A ";
		strSql += "WHERE A.PNO='" + strPNo + "' ";

		System.out.println(" inside DISBCheckMaintainServlet.inquiryPDetails()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			if (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rs.getString("PNO"));	// ��I�Ǹ�
				if (rs.getString("PNOH").trim().equals(""))	{	// �n�O���Ĥ@������I�Ǹ�
					objPDetailVO.setStrPNoH(rs.getString("PNO"));	// ���I�Ǹ�
				} else {
					objPDetailVO.setStrPNoH(rs.getString("PNOH")); // ���I�Ǹ�
				}
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	// ��I���B
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		// �I�ڤ��
				objPDetailVO.setStrPName(rs.getString("PNAME"));// �I�ڤH�m�W
				objPDetailVO.setStrPSName(rs.getString("PSNAME"));	// �I�ڤH��l�m�W
				objPDetailVO.setStrPId(rs.getString("PID"));	// �I�ڤHID
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));// ���O
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));// �I�ڤ覡
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));// ��I�y�z
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));	// �ӷ��ոs
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE"));// ��I��]�N�X
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS"));	// �I�ڪ��A
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));// �@�o�_
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));// ���_
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));// �I�ڻȦ�
				objPDetailVO.setStrPBBank(rs.getString("PBBANK")); 		// �I�ڱb��
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));// �״ڱb��
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));		// �״ڻȦ�
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));		// �n�O�Ѹ��X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	// �O�渹�X
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		// �O����ݳ��
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));			// �׶O(����O)
				objPDetailVO.setStrMemo(rs.getString("MEMO"));			// �Ƶ�
				objPDetailVO.setStrEntryPgm(rs.getString("ENTRYPGM")); 	// ��J�{��
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));		// �I�����O
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));	// ��J��
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));		// R70339 ��I���B�x���Ѧ�
				objPDetailVO.setClaimNumber(rs.getString("PCLMNUM"));
				objPDetailVO.setServicingBranch(rs.getString("SRVBH"));
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));
				objPDetailVO.setAnnuityPayDate(rs.getInt("ANNPDATE"));
				alPDetail.add(objPDetailVO);
			}
			rs.close();
			stmt.close();
			if (alPDetail.size() > 0) {
				strReturnMsg = "";
			} else {
				strReturnMsg = "�d�L�������";
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
			strReturnMsg = "�d�ߥ���" + ex;
			alPDetail = null;
		}
		alPDetail.add(0, strReturnMsg);
		return alPDetail;
	}
	
	//QC0272:�H�������o��I���(�i��h��)
	private List inquiryPDetailsByCNo(String strCNo, Connection con) {
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; 
		String strReturnMsg = "";

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		strSql = "select A.PNO,A.ENTRYDT,A.PAMT,A.PCFMDT1,A.PCFMTM1,A.PCFMDT2,A.PCFMTM2,A.PDATE,A.UPDDT,A.UPDTM,A.APPNO,A.POLICYNO,A.ENTRYUSR,A.PAUTHCODE,A.PBACCOUNT,A.PBBANK,A.PCFMUSR1,A.PCFMUSR2,A.PCHECKNO,A.PCRDEFFMY,A.PCRDNO,A.PCRDTYPE,A.PDESC,A.PDISPATCH,A.PID,A.PMETHOD,A.PNAME,A.PSNAME,A.PNOH,A.PRACCOUNT,A.PRBANK,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.BRANCH,A.PCURR,A.RMTFEE,A.MEMO,A.ENTRYPGM,A.PPLANT ";
		strSql += ",PAMTNT,PCLMNUM,SRVBH,PPLANT,ANNPDATE "; 
		strSql += " from CAPPAYFK5 A ";
		strSql += "WHERE A.PCHECKNO='" + strCNo + "' ";
		strSql += "ORDER BY A.PNO";
		
		System.out.println(" inside DISBCheckMaintainServlet.inquiryPDetails()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			while(rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rs.getString("PNO"));	// ��I�Ǹ�
				if (rs.getString("PNOH").trim().equals(""))	{	// �n�O���Ĥ@������I�Ǹ�
					objPDetailVO.setStrPNoH(rs.getString("PNO"));	// ���I�Ǹ�
				} else {
					objPDetailVO.setStrPNoH(rs.getString("PNOH")); // ���I�Ǹ�
				}
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	// ��I���B
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		// �I�ڤ��
				objPDetailVO.setStrPName(rs.getString("PNAME"));// �I�ڤH�m�W
				objPDetailVO.setStrPSName(rs.getString("PSNAME"));	// �I�ڤH��l�m�W
				objPDetailVO.setStrPId(rs.getString("PID"));	// �I�ڤHID
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));// ���O
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));// �I�ڤ覡
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));// ��I�y�z
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));	// �ӷ��ոs
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE"));// ��I��]�N�X
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS"));	// �I�ڪ��A
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));// �@�o�_
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));// ���_
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));// �I�ڻȦ�
				objPDetailVO.setStrPBBank(rs.getString("PBBANK")); 		// �I�ڱb��
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));// �״ڱb��
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));		// �״ڻȦ�
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));		// �n�O�Ѹ��X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	// �O�渹�X
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		// �O����ݳ��
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));			// �׶O(����O)
				objPDetailVO.setStrMemo(rs.getString("MEMO"));			// �Ƶ�
				objPDetailVO.setStrEntryPgm(rs.getString("ENTRYPGM")); 	// ��J�{��
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));		// �I�����O
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));	// ��J��
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));		// R70339 ��I���B�x���Ѧ�
				objPDetailVO.setClaimNumber(rs.getString("PCLMNUM"));
				objPDetailVO.setServicingBranch(rs.getString("SRVBH"));
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));
				objPDetailVO.setAnnuityPayDate(rs.getInt("ANNPDATE"));
				alPDetail.add(objPDetailVO);
			}

			if (alPDetail.size() > 0) {
				strReturnMsg = "";
			} else {
				strReturnMsg = "�d�L�������";
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
			strReturnMsg = "�d�ߥ���" + ex;
			alPDetail = null;
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (stmt != null) {
					stmt.close();
				}
			} catch (Exception ex1) {
			}
		}
		return alPDetail;
	}

	private void updateCheckData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckMaintainServlet.updateCheckData()");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String

		/* �����e�����w�q */
		String strCNo = "";		// ���ڸ��X
		String strCBNo = "";	// ���ڧ帹
		String strCBkNo = ""; 	// �Ȧ��w
		String strCAccount = ""; // �Ȧ�b��
		String strCMEMO = "";	// �䲼�Ƶ�

		strCNo = request.getParameter("txtCNoU");
		if (strCNo != null)
			strCNo = strCNo.trim();
		else
			strCNo = "";

		strCBNo = request.getParameter("txtCBNoU");
		if (strCBNo != null)
			strCBNo = strCBNo.trim();
		else
			strCBNo = "";

		strCBkNo = request.getParameter("txtCBkNoU");
		if (strCBkNo != null)
			strCBkNo = strCBkNo.trim();
		else
			strCBkNo = "";

		strCAccount = request.getParameter("txtCAccountU");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCMEMO = request.getParameter("txtCMEMO");
		if (strCMEMO != null)
			strCMEMO = strCMEMO.trim();
		else
			strCMEMO = "";

		/* ��s��Ʈw */
		try {
			strSql = " update CAPCHKF  set MEMO=?";
			strSql += " where CNO =?  AND CBKNO=? AND CACCOUNT=? AND CBNO=? ";
			System.out.println("strSql=" + strSql);
			pstmtTmp = con.prepareStatement(strSql);
			pstmtTmp.setString(1, strCMEMO);
			pstmtTmp.setString(2, strCNo);
			pstmtTmp.setString(3, strCBkNo);
			pstmtTmp.setString(4, strCAccount);
			pstmtTmp.setString(5, strCBNo);

			if (pstmtTmp.executeUpdate() < 1) {// 3
				request.setAttribute("txtMsg", "��s���ڳƵ�����");
			} else {
				request.setAttribute("txtMsg", "��s���ڳƵ����\");
			}
			pstmtTmp.close();
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("txtMsg", "��s���ڳƵ�����-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", "UpdateData");
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private String updateCheckStatus(String strCNo, String strCBkNo, String strCAccount, String strCBNo, String strCStatus, String strCMEMO, int iUpdDate, Connection con, String strC4User) throws ServletException, IOException {
		System.out.println("@@@@@inside updateCheckStatus");

		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		try {
			strSql = " update CAPCHKF  set CSTATUS=? ,MEMO=? ,CASHDT=?,CHG4USER=?"; // R60420
			strSql += " where CNO =?  AND CBKNO=? AND CACCOUNT=? AND CBNO=? ";
			pstmtTmp = con.prepareStatement(strSql);
			pstmtTmp.setString(1, strCStatus);
			pstmtTmp.setString(2, strCMEMO);
			pstmtTmp.setInt(3, iUpdDate);
			pstmtTmp.setString(4, strC4User);
			pstmtTmp.setString(5, strCNo);
			pstmtTmp.setString(6, strCBkNo);
			pstmtTmp.setString(7, strCAccount);
			pstmtTmp.setString(8, strCBNo);

			if (pstmtTmp.executeUpdate() < 1) {// 3
				strReturnMsg = "����";
				return strReturnMsg;
			}
			pstmtTmp.close();
		} catch (SQLException ex) {
			ex.printStackTrace();
			strReturnMsg = "����:ex=" + ex;
		}
		return strReturnMsg;
	}

	private String updatePStatus(String strPNo, String strPStatus, int iUpdDate, int iUpdTime, String strLogonUser, Connection con) throws ServletException, IOException {
		return updatePStatus(strPNo, strPStatus, "", iUpdDate, iUpdTime, strLogonUser, con);
	}

	private String updatePStatus(String strPNo, String strPStatus, String strPVoidabled, int iUpdDate, int iUpdTime, String strLogonUser, Connection con) throws ServletException, IOException {
		System.out.println("@@@@@inside updatePStatus");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		disbBean = new DISBBean(dbFactory);

		try {
			strSql = " update CAPPAYF  set PSTATUS=? ,PVOIDABLE=?";
			strSql += "  , UPDDT= ? , UPDTM = ?, UPDUSR =?  where PNO =?";
			System.out.println(" inside DISBCheckmaintainServlet.updatePStatus()--> strSql =" + strSql);

			// �Ulog
			//strReturnMsg = disbBean.insertCAPPAYFLOG(strPNo, strLogonUser, iUpdDate, iUpdTime, con);
			if (strReturnMsg.equals("")) {
				pstmtTmp = con.prepareStatement(strSql);
				pstmtTmp.setString(1, strPStatus);
				pstmtTmp.setString(2, strPVoidabled);
				pstmtTmp.setInt(3, iUpdDate);
				pstmtTmp.setInt(4, iUpdTime);
				pstmtTmp.setString(5, strLogonUser);
				pstmtTmp.setString(6, strPNo);

				if (pstmtTmp.executeUpdate() < 1) {
					strReturnMsg = "��s��I�D�ɥ���";
					return strReturnMsg;
				}
				pstmtTmp.close();
			} else {
				return strReturnMsg;
			}

		} catch (SQLException e) {
			e.printStackTrace();
			strReturnMsg = "��s��I�D�ɥ���: e=" + e;
		}
		return strReturnMsg;
	}

	private String updatePDetails(String strPNo, int iUpdDate, int iUpdTime, String strLogonUser, Connection con) throws ServletException, IOException {
		System.out.println("@@@@@inside updatePDetails");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		disbBean = new DISBBean(dbFactory);
		try {
			strSql = " update CAPPAYF  set PBBANK = '' , PBACCOUNT = '' , PCHECKNO='' ,PCSHDT=0,PSTATUS='' ";
            strSql += " ,PCSHCM =0"; //QC0272
			strSql += "  , UPDDT= ? , UPDTM = ?, UPDUSR =?  where PNO =?";

			// �Ulog
			strReturnMsg = disbBean.insertCAPPAYFLOG(strPNo, strLogonUser, iUpdDate, iUpdTime, con);
			if (strReturnMsg.equals("")) {
				pstmtTmp = con.prepareStatement(strSql);
				pstmtTmp.setInt(1, iUpdDate);
				pstmtTmp.setInt(2, iUpdTime);
				pstmtTmp.setString(3, strLogonUser);
				pstmtTmp.setString(4, strPNo);

				if (pstmtTmp.executeUpdate() < 1) {
					strReturnMsg = "��s��I�D�ɥ���";
					return strReturnMsg;
				}
				pstmtTmp.close();
			} else {
				return strReturnMsg;
			}

		} catch (SQLException e) {
			e.printStackTrace();
			strReturnMsg = "��s��I�D�ɥ���: e=" + e;
		}
		return strReturnMsg;
	}

	private String createNewPayment(DISBPaymentDetailVO objPDetailVO, String strLogonUser, int iEntryDate, int iEntryTime, Connection con, String strC4User) throws ServletException, IOException {
		System.out.println("inside createNewPayment");

		String strSql = ""; // SQL String
		String strReturnMsg = "";

		Hashtable htReturnInfo = new Hashtable();
		String strNewPNo = "";
		/* �s�W���I�D�� */
		strSql = " insert into  CAPPAYF "
				+ " (PNO,PNOH,PAMT,PSNAME,PDATE,PNAME,PID,PCURR,PMETHOD,PDESC,PSRCGP,PSRCCODE,PVOIDABLE,PDISPATCH,"
				+ "PCHKM1,PCHKM2,PRACCOUNT,PRBANK,APPNO,POLICYNO,BRANCH,RMTFEE,MEMO,ENTRYPGM,PPLANT,PCFMDT1,PCFMTM1,PCFMUSR1,ENTRYDT,ENTRYTM,ENTRYUSR,UPDDT,UPDTM,UPDUSR" // R70339
				+ ",PAMTNT,PCLMNUM,SRVBH,ANNPDATE) "
				+ " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,'Y','Y',?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		/* ���o�s����I�Ǹ� */
		disbBean = new DISBBean(dbFactory);

		try {
			htReturnInfo = (Hashtable) disbBean.getDISBSeqNo("DISB", strLogonUser, con);
			strReturnMsg = (String) htReturnInfo.get("ReturnMsg");
			if (strReturnMsg.equals("")) {
				strNewPNo = (String) htReturnInfo.get("ReturnValue");
				PreparedStatement pstmtTmp = con.prepareStatement(strSql);
				pstmtTmp.setString(1, strNewPNo);
				pstmtTmp.setString(2, objPDetailVO.getStrPNoH().trim()); // �Ĥ@������I�Ǹ�
				pstmtTmp.setDouble(3, objPDetailVO.getIPAMT());
				pstmtTmp.setString(4, objPDetailVO.getStrPSName().trim());
				pstmtTmp.setInt(5, iEntryDate);
				pstmtTmp.setString(6, objPDetailVO.getStrPName().trim());
				pstmtTmp.setString(7, objPDetailVO.getStrPId().trim());
				pstmtTmp.setString(8, objPDetailVO.getStrPCurr().trim());
				pstmtTmp.setString(9, objPDetailVO.getStrPMethod().trim());
				pstmtTmp.setString(10, objPDetailVO.getStrPDesc().trim());
				pstmtTmp.setString(11, objPDetailVO.getStrPSrcGp().trim());
				pstmtTmp.setString(12, objPDetailVO.getStrPSrcCode().trim());
				pstmtTmp.setString(13, objPDetailVO.getStrPVoidable().trim());
				pstmtTmp.setString(14, objPDetailVO.getStrPDispatch().trim());
				pstmtTmp.setString(15, objPDetailVO.getStrPRAccount().trim());
				pstmtTmp.setString(16, objPDetailVO.getStrPRBank().trim());
				pstmtTmp.setString(17, objPDetailVO.getStrAppNo().trim());
				pstmtTmp.setString(18, objPDetailVO.getStrPolicyNo().trim());
				pstmtTmp.setString(19, objPDetailVO.getStrBranch().trim());
				pstmtTmp.setInt(20, objPDetailVO.getIRmtFee());
				pstmtTmp.setString(21, objPDetailVO.getStrMemo().trim());
				pstmtTmp.setString(22, objPDetailVO.getStrEntryPgm().trim());
				pstmtTmp.setString(23, objPDetailVO.getStrPPlant().trim());
				pstmtTmp.setInt(24, iEntryDate);
				pstmtTmp.setInt(25, iEntryTime);
				pstmtTmp.setString(26, strC4User); // R70339
				pstmtTmp.setInt(27, iEntryDate);
				pstmtTmp.setInt(28, iEntryTime);
				pstmtTmp.setString(29, strC4User); // R70339
				pstmtTmp.setInt(30, iEntryDate);
				pstmtTmp.setInt(31, iEntryTime);
				pstmtTmp.setString(32, strC4User); // R70339
				pstmtTmp.setDouble(33, objPDetailVO.getIPAMTNT()); // R70339
				pstmtTmp.setString(34, objPDetailVO.getClaimNumber());
				pstmtTmp.setString(35, objPDetailVO.getServicingBranch());
				pstmtTmp.setInt(36, objPDetailVO.getAnnuityPayDate());

				if (pstmtTmp.executeUpdate() != 1) {
					strReturnMsg = "�s�W���I��ƨ��I�D�ɥ���";
				}
				pstmtTmp.close();
				htReturnInfo = null;
			}
		} catch (SQLException e) {
			strReturnMsg = "�s�W���I��ƨ��I�D�ɥ���:" + e;
		} catch (Exception ex) {
			strReturnMsg = "�s�W���I��ƨ��I�D�ɥ���:" + ex;
		}
		return strReturnMsg;
	}

	private String insertCapchaf(String strCNo, String strOldStatus, String strNewStatus, String strBankCode, String strChequeDtU, String strCAmt, String strLogonUser, String PsrCd, int iUpdDate, int iUpdTime, Connection con, String ServiceBranch, String strPlant) throws ServletException, IOException {
		System.out.println("inside insertCapchaf");
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("yyyyMMdd");

		String strACTCD2D = "";
		String strACTCD2C = "";
		String strACTCD3D = "0000";// Q60159�u���U���ج�101T1000ZZ,10172000ZZ�ɤ~�n�I�sdisbBean.getACTCD3,�_�h��0000
		String strACTCD3C = "0000";
		String strACTCD4D = "00";
		String strACTCD4C = "00";
		String strDesc = strCNo + " (" + strOldStatus + "-->" + strNewStatus + ")";
		String strJournalName = "";
		// System.out.println("inside insertCapchaf" + strDesc);
		double dCAmt = Double.parseDouble(strCAmt);
		String strCheqDtTemp = strChequeDtU;
		if (strCheqDtTemp.length() < 7)
			strCheqDtTemp = "0" + strCheqDtTemp;

		int iStatusDT = iUpdDate + 19110000;
		String strStatusDT = Integer.toString(iStatusDT);
		String DateTemp1 = strStatusDT.substring(0, 4) + "/" + strStatusDT.substring(4, 6) + "/" + strStatusDT.substring(6, 8);
		/* get Data */
		// R70770 �H�UZZ�אּZZZ
		if (strOldStatus.equals("D")) {
			if (strNewStatus.equals("V")) {
				strACTCD2D = "101T1000ZZZ";
				if (PsrCd.equals("D2")) { // Q60159��ե� ���ͤ��P���|�p����
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";
				}
				strACTCD3D = disbBean.getACTCD3(strBankCode);// Q60159�u���U���ج�101T1000ZZ,10172000ZZ�ɤ~�n�I�sdisbBean.getACTCD3,�_�h��0000
			} else if (strNewStatus.equals("1")) {
				strACTCD2D = "101T1000ZZZ";
				strACTCD2C = "29900000ZZZ";
				strACTCD3D = disbBean.getACTCD3(strBankCode);// Q60159�u���U���ج�101T1000ZZ,10172000ZZ�ɤ~�n�I�sdisbBean.getACTCD3,�_�h��0000
			} else if (strNewStatus.equals("4")) {
				strACTCD2D = "101T1000ZZZ";
				if (PsrCd.equals("D2")) { // Q60159��ե� ���ͤ��P���|�p����
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";// Q60159 20060809 �N 79440190ZZ �אּ 29004000ZZ
				}
				strACTCD3D = disbBean.getACTCD3(strBankCode);// Q60159�u���U���ج�101T1000ZZ,10172000ZZ�ɤ~�n�I�sdisbBean.getACTCD3,�_�h��0000
			}
		} else if (strOldStatus.equals("1")) {
			if (strNewStatus.equals("2")) {
				strACTCD2D = "29900000ZZZ";
				strACTCD2C = "79440190ZZZ";
			} else if (strNewStatus.equals("4")) {
				strACTCD2D = "29900000ZZZ";
				if (PsrCd.equals("D2")) { // Q60159��ե� ���ͤ��P���|�p����
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";// Q60159 20060809 �N 79440190ZZ �אּ 29004000ZZ
				}
			} else if (strNewStatus.equals("V")) {
				strACTCD2D = "29900000ZZZ";
				if (PsrCd.equals("D2")) { // Q60159 20060821 ��ե� ���ͤ��P���|�p����
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";// Q60159 20060809 �N 79440190ZZ �אּ 29004000ZZ
				}
			}
		} else if (strOldStatus.equals("R")) {
			if (strNewStatus.equals("1")) {
				strACTCD2D = "101T1000ZZZ";
				strACTCD2C = "29900000ZZZ";
				strACTCD3D = disbBean.getACTCD3(strBankCode);// Q60159�u���U���ج�101T1000ZZ,10172000ZZ�ɤ~�n�I�sdisbBean.getACTCD3,�_�h��0000
			} else if (strNewStatus.equals("2")) {
				strACTCD2D = "101T1000ZZZ";
				strACTCD2C = "79440190ZZZ";
				strACTCD3D = disbBean.getACTCD3(strBankCode);// Q60159�u���U���ج�101T1000ZZ,10172000ZZ�ɤ~�n�I�sdisbBean.getACTCD3,�_�h��0000
			} else if (strNewStatus.equals("V")) {	// Q60159 20060821 �W�[�@������ե� R-->V���|�p����
				strACTCD2D = "101T1000ZZZ";
				if (PsrCd.equals("D2")) {
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";// Q60159 20060809 �N 79440190ZZ �אּ 29004000ZZ
				}
				strACTCD3D = disbBean.getACTCD3(strBankCode);// Q60159�u���U���ج�101T1000ZZ,10172000ZZ�ɤ~�n�I�sdisbBean.getACTCD3,�_�h��0000
			} else if (strNewStatus.equals("4")) { // Q60159 20060821 �W�[�@������ե� R-->4���|�p����
				strACTCD2D = "101T1000ZZZ";
				if (PsrCd.equals("D2")) {
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";
				}
				strACTCD3D = disbBean.getACTCD3(strBankCode);// Q60159�u���U���ج�101T1000ZZ,10172000ZZ�ɤ~�n�I�sdisbBean.getACTCD3,�_�h��0000
			}
		} else if (strOldStatus.equals("2")) {
			if (strNewStatus.equals("4")) {
				strACTCD2D = "79440190ZZZ";
				if (PsrCd.equals("D2")) { // Q60159��ե� ���ͤ��P���|�p����
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";// Q60159 20060809 �N 27100000ZZ �אּ 29004000ZZ
				}
			} else if (strNewStatus.equals("V")) { // Q60159 20060821�W�[�@������ե� 2-->V���|�p����
				strACTCD2D = "79440190ZZZ";
				if (PsrCd.equals("D2")) {
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";// Q60159 20060809 �N 79440190ZZ �אּ 29004000ZZ
				}
			}
		} else if (strOldStatus.equals("C")) {
			if (strNewStatus.equals("5")) {
				strACTCD2D = "12000000ZZZ";
				strACTCD2C = "27100000ZZZ";
				if (PsrCd.equals("D2")) { // Q60159��ե� ���ͤ��P���|�p����
					strACTCD2C = "82211190ZZZ";
					strACTCD4C = "62";
				} else {
					strACTCD2C = "29004000ZZZ";// Q60159 20060809 �N 27100000ZZ �אּ 29004000ZZ
				}
			}
		} else if (strOldStatus.equals("5")) {
			if (strNewStatus.equals("6")) {
				strACTCD3D = "8223";// Q60159 ���ɪ��Ȧ�X �n�� 8223
				strACTCD2D = "10172000ZZZ";
				strACTCD2C = "19002000ZZZ";// Q60159 20060809 �N 12000000ZZ �אּ 19002000ZZ
			}
		}

		if(strNewStatus.equals("2") || strNewStatus.equals("4") || strNewStatus.equals("V")) {

			String strMainAcct = "";
			String strChannel = "";
			String strLOB = "";
			String strDept = "";
			String strEtabTemp = "";

			Calendar chkCal = Calendar.getInstance();
			chkCal.set((Integer.parseInt(strCheqDtTemp.substring(0, 3)) + 1911), (Integer.parseInt(strCheqDtTemp.substring(3, 5)) - 1), Integer.parseInt(strCheqDtTemp.substring(5)));
			long monthDif = 0;
			try {
				monthDif = DISBCSubjectTool.getMonthDiff(chkCal, commonUtil.getBizDateByRCalendar());
			} catch (Exception ex) {
			}

			//R00135 �䲼�����٥���98/3/1�B�O�G�~ �̤�I��]�N�X�����|�p���
			if(monthDif >= 24 && Integer.parseInt(strCheqDtTemp) >= 980301 )
			{
				try {
					if(!CommonUtil.AllTrim(ServiceBranch).equals("")) {
						strEtabTemp = disbBean.getETableDesc("ORAL4", ServiceBranch);
						strDept = strEtabTemp.substring(2, 4);
						strChannel = strEtabTemp.substring(0, 1);
					} else {
						strChannel = " ";
						strDept = "  ";
					}
					if(strPlant.equalsIgnoreCase("V"))
						strLOB = "1";
					else
						strLOB = "0";

					strMainAcct = DISBCSubjectTool.dealWithOverTwoYear(chkCal, PsrCd,  DISBCSubjectTool.getProperties());
					if(strMainAcct.startsWith("7")) {
						if(PsrCd.equals("HS"))
						{
							strChannel = " ";
							strLOB = " ";
							strDept = "  ";
						}
					} else if(strMainAcct.equals("822111")) {
						strChannel = "9";
						strLOB = "0";
						strDept = "62";
					} else {
						strChannel = "0";
						strLOB = "0";
						strDept = "00";
					}
				} catch (Exception ex) {
					strMainAcct = "      ";
				}

				if(strMainAcct.equals("")) {
					strMainAcct = "      ";
				}
				if(strChannel.equals("")) {
					strChannel = " ";
				}
				if(strLOB.equals("")) {
					strLOB = " ";
				}
				if(strDept.equals("")) {
					strDept = "  ";
				}
				if(strNewStatus.equals("4") || strNewStatus.equals("V")) {
					strACTCD2D = strMainAcct + strChannel + strLOB + "ZZZ";
					strACTCD4D = strDept;
				} else {
					strACTCD2C = strMainAcct + strChannel + strLOB + "ZZZ";
					strACTCD4C = strDept;
				}
			}
		}
		
		strJournalName = DateTemp1.substring(2, 4) + DateTemp1.substring(5, 7) + DateTemp1.substring(8);
		if(strNewStatus.equals("1")) {
			strJournalName +=  "228";
		} else if(strNewStatus.equals("2")) {
			strJournalName +=  "229";
		} else {
			strJournalName +=  "002TWD";
		}

		strSql = " insert into  CAPCHAF "
				+ " (CATEG,ACNTSOUR,ACNTCURR,ACTCD1,ACTCD2,ACTCD3,ACTCD4,ACTCD5,DATE1,CREAMT,DEBAMT,SLIPNO,DESPTXT1,ENTRYDT,"
				+ "ENTRYTM,ENTRYUSR,CONVTYPE,CONVRATE,BATCHNAME)"// R80620�[�JCONVTYPE,CONVRATE,BATCHNAME
				// ACTCD5��13�X�X�� 26�X
				+ " VALUES ('Manual','Spreadsheet','TWD','0',?,?,?,'00000000000000000000000000',?,?,?,?,?,?,?,?,'User','1      ',?)"; // R80620

		disbBean = new DISBBean(dbFactory);

		try {
			/* �s�W�@���ɤ��� */

			PreparedStatement pstmtTmpD = con.prepareStatement(strSql);
			pstmtTmpD.setString(1, strACTCD2D);
			pstmtTmpD.setString(2, strACTCD3D); // �Ĥ@������I�Ǹ�
			pstmtTmpD.setString(3, strACTCD4D); // Q60159��ե� ���ͤ��P���|�p����
			pstmtTmpD.setString(4, DateTemp1);
			pstmtTmpD.setDouble(5, 0);
			pstmtTmpD.setDouble(6, dCAmt);
			pstmtTmpD.setString(7, strJournalName);
			pstmtTmpD.setString(8, strDesc);
			pstmtTmpD.setInt(9, iUpdDate);
			pstmtTmpD.setInt(10, iUpdTime);
			pstmtTmpD.setString(11, strLogonUser);
			pstmtTmpD.setString(12, strJournalName);

			if (pstmtTmpD.executeUpdate() != 1) {
				strReturnMsg = "�s�W�ɤ��ƥ���";
			} else {
				/* �s�W�@���U���� */
				PreparedStatement pstmtTmpC = con.prepareStatement(strSql);
				pstmtTmpC.setString(1, strACTCD2C);
				pstmtTmpC.setString(2, strACTCD3C); // �Ĥ@������I�Ǹ�
				pstmtTmpC.setString(3, strACTCD4C); // Q60159��ե� ���ͤ��P���|�p����
				pstmtTmpC.setString(4, DateTemp1);
				pstmtTmpC.setDouble(5, dCAmt);
				pstmtTmpC.setDouble(6, 0);
				pstmtTmpC.setString(7, strJournalName);
				pstmtTmpC.setString(8, strDesc);
				pstmtTmpC.setInt(9, iUpdDate);
				pstmtTmpC.setInt(10, iUpdTime);
				pstmtTmpC.setString(11, strLogonUser);
				pstmtTmpC.setString(12, strJournalName);

				if (pstmtTmpC.executeUpdate() != 1) {
					strReturnMsg = "�s�W�U���ƥ���";
				}
				pstmtTmpC.close();
			}
			pstmtTmpD.close();

		} catch (SQLException e) {
			strReturnMsg += e;
			System.out.println("strReturnMsg=" + strReturnMsg);
		} catch (Exception ex) {
			strReturnMsg = "�s�W�ɶU���ƥ���:" + ex;
		}
		return strReturnMsg;
	}

}
