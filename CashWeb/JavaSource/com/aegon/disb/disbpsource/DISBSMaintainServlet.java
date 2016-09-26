package com.aegon.disb.disbpsource;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.14 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBSMaintainServlet.java,v $
 * $Revision 1.14  2014/07/18 07:14:21  misariel
 * $EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 * $
 * $Revision 1.13  2013/12/18 07:22:52  MISSALLY
 * $RB0302---�s�W�I�ڤ覡�{��
 * $
 * $Revision 1.12  2013/02/26 10:22:31  ODCWilliam
 * $william wu
 * $RA0074
 * $
 * $Revision 1.11  2011/10/21 10:04:36  MISSALLY
 * $R10260---�~���ǲΫ��O��ͦs�����I�@�~
 * $
 * $Revision 1.10  2010/11/23 06:46:23  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.9  2009/11/11 06:04:56  missteven
 * $R90474 �ק�CASH�\��
 * $
 * $Revision 1.8  2008/08/12 06:57:16  misvanessa
 * $R80480_�W���Ȧ�~�������s�ɮ�
 * $
 * $Revision 1.7  2008/05/02 10:17:48  misvanessa
 * $R80300_�������x�s,�s�W�U���ɮפγ��� �~���s��fix
 * $
 * $Revision 1.6  2008/04/30 07:48:22  misvanessa
 * $R80300_�������x�s,�s�W�U���ɮפγ���
 * $
 * $Revision 1.5  2007/01/31 07:57:10  MISVANESSA
 * $R70088_SPUL�t��
 * $
 * $Revision 1.4  2007/01/05 10:10:15  MISVANESSA
 * $R60550_�װh��I�覡
 * $
 * $Revision 1.3  2007/01/04 03:14:34  MISVANESSA
 * $R60550_�s�WSHOW�װh����O
 * $
 * $Revision 1.2  2006/11/30 09:16:06  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.1  2006/06/29 09:40:51  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.14  2006/04/27 09:13:56  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.13  2005/07/19 04:08:48  MISANGEL
 * $Q50274 : �ˮֶ״ڻȦ�-�x�s���ˮֶ״ڻȦ�O�_�s�b,�Y���s�b,�h�L�k�x�s
 * $
 * $Revision 1.1.2.12  2005/04/28 08:56:26  miselsa
 * $R30530������ժ��ק�
 * $
 * $Revision 1.1.2.11  2005/04/04 07:02:22  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.GlobalEnviron;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;

public class DISBSMaintainServlet extends HttpServlet {

	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private boolean isAEGON400 = false;

	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON) != null) {
			globalEnviron = (GlobalEnviron) getServletContext().getAttribute(Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
		}

		if (globalEnviron.getActiveAS400DataSource().equals(Constant.AS400_DATA_SOURCE_NAME_AEGON400)) {
			isAEGON400 = true;
		}
		commonUtil = new CommonUtil(globalEnviron);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String strAction = "";
		strAction = request.getParameter("txtAction");
		strAction = (strAction != null) ? CommonUtil.AllTrim(strAction) : "" ;

		try {
			if (strAction.equals("DISBPSourceConfirm"))
				updatePayments(request, response);
			else if (strAction.equals("U"))
				updateDB(request, response);
			else if (strAction.equals("INQ"))
				inquiryD(request, response);// R60550
			else if (strAction.equals("IDetails"))
				inquiryDetails(request, response);
			else if (strAction.equals("DISBCancelConfirm"))
				cancelConfirm(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} // end of try
		catch (Exception e) 
		{
			System.err.println("Application Exception >>> " + e);
		}
	}

	private void updateDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		Connection con = dbFactory.getAS400Connection("DISBSMaintainServlet.updateDB()");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

		List alBankCode = new ArrayList();

		if (session.getAttribute("BankCodeList") == null) {
			alBankCode = (List) disbBean.getBankList();
			session.setAttribute("BankCodeList", alBankCode);
		} else {
			alBankCode = (List) session.getAttribute("BankCodeList");
		}

		boolean bContinue = false;
		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strPNO = ""; // ��I�Ǹ�
		String strPName = ""; // ���ڤH�m�W

		String strPMethod = ""; // �I�ڤ覡
		String strPDesc = ""; // ��I�y�z
		String strPRBank = ""; // �״ڻȦ�
		String strPRAccount = ""; // �״ڱb��
		String strPCrdNo = ""; // �H�Υd�d��
		String strPCrdType = ""; // �d�O
		String strPCrdEffMY = ""; // ���Ħ~��
		String strUPAuthCode = ""; // ���v�X
		String strUDispatch = ""; // ���_
		String strUPCHKM1 = ""; // �䲼�T�I
		String strUPCHKM2 = ""; // �䲼���u
		String strPDate = ""; // �I�ڤ��
		int iPDate = 0;// �I�ڤ��
		int iPAuthDt = 0;// ���v�����
		String strPAuthDt = "";// ���v�����
		String strPSrcCode = "";// ��I�ӷ�
		String strCurrency = "";// ���O
		// R60550�s�W�~���״����
		String strPFEEWAY = "";
		String strPSWIFT = "";
		String strPBKBRCH = "";
		String strPBKCITY = "";
		String strPBKCOTRY = "";
		String strPENGNAME = "";
		String strSYMBOL = "";
		String strINVDT = "";
		int iINVDT = 0;
		String strENTRYDT = "";// R70088
		int iENTRYDT = 0;// R70088
		double iPOrgAMT = 0; // R80300 �����B
		String strPOrgCrdNo = "";// R80300 ���d��
		String strPOrgAMT = ""; // R80300 �����B
		String strPID = ""; // R80480���ڤHID

		/* ���o�e������� */
		strPNO = request.getParameter("txtUPNO");
		strPNO = (strPNO != null) ? CommonUtil.AllTrim(strPNO) : "" ;

		strPName = request.getParameter("txtUPName");
		strPName = (strPName != null) ? CommonUtil.AllTrim(strPName) : "" ;

		strPMethod = request.getParameter("selUPMethod");
		strPMethod = (strPMethod != null) ? CommonUtil.AllTrim(strPMethod) : "" ;

		strPDesc = request.getParameter("txtUPDesc");
		strPDesc = (strPDesc != null) ? CommonUtil.AllTrim(strPDesc) : "" ;

		strPRBank = request.getParameter("txtUPRBank");
		strPRBank = (strPRBank != null) ? CommonUtil.AllTrim(strPRBank) : "" ;

		strPRAccount = request.getParameter("txtUPRAccount");
		strPRAccount = (strPRAccount != null) ? CommonUtil.AllTrim(strPRAccount) : "" ;

		strPCrdNo = request.getParameter("txtUPCrdNo");
		strPCrdNo = (strPCrdNo != null) ? CommonUtil.AllTrim(strPCrdNo) : "" ;

		strPCrdType = request.getParameter("txtPUCrdType");
		strPCrdType = (strPCrdType != null) ? CommonUtil.AllTrim(strPCrdType) : "" ;

		strPCrdEffMY = request.getParameter("txtUPCrdEffMY");
		strPCrdEffMY = (strPCrdEffMY != null) ? CommonUtil.AllTrim(strPCrdEffMY) : "" ;

		strUPAuthCode = request.getParameter("txtUPAuthCode");
		strUPAuthCode = (strUPAuthCode != null) ? CommonUtil.AllTrim(strUPAuthCode) : "" ;

		strUDispatch = request.getParameter("rdUDispatch");
		strUDispatch = (strUDispatch != null) ? CommonUtil.AllTrim(strUDispatch) : "" ;

		strUPCHKM1 = request.getParameter("rdUPCHKM1");
		strUPCHKM1 = (strUPCHKM1 != null) ? CommonUtil.AllTrim(strUPCHKM1) : "" ;

		strUPCHKM2 = request.getParameter("rdUPCHKM2");
		strUPCHKM2 = (strUPCHKM2 != null) ? CommonUtil.AllTrim(strUPCHKM2) : "" ;

		strPDate = request.getParameter("txtUPDate");
		strPDate = (strPDate != null) ? CommonUtil.AllTrim(strPDate) : "" ;
		iPDate = (!strPDate.equals("")) ? Integer.parseInt(strPDate) : 0;

		strPAuthDt = request.getParameter("txtUPAuthDt");
		strPAuthDt = (strPAuthDt != null) ? CommonUtil.AllTrim(strPAuthDt) : "";
		iPAuthDt = (!strPAuthDt.equals("")) ? Integer.parseInt(strPAuthDt) : 0;

		strPSrcCode = request.getParameter("selUPSrcCode");
		strPSrcCode = (strPSrcCode != null) ? CommonUtil.AllTrim(strPSrcCode) : "" ;

		strCurrency = request.getParameter("txtCurrency");
		strCurrency = (strCurrency != null) ? CommonUtil.AllTrim(strCurrency) : "" ;

		// R60550
		strINVDT = request.getParameter("txtINVDT");
		strINVDT = (strINVDT != null) ? CommonUtil.AllTrim(strINVDT) : "" ;
		iINVDT = (!strINVDT.equals("")) ? Integer.parseInt(strINVDT) : 0;

		strSYMBOL = request.getParameter("txtSYMBOL");
		strSYMBOL = (strSYMBOL != null) ? CommonUtil.AllTrim(strSYMBOL) : "" ;

		strPFEEWAY = request.getParameter("selFEEWAY");
		strPFEEWAY = (strPFEEWAY != null) ? CommonUtil.AllTrim(strPFEEWAY) : "" ;

		strPSWIFT = request.getParameter("selPSWIFT");
		strPSWIFT = (strPSWIFT != null) ? CommonUtil.AllTrim(strPSWIFT) : "" ;

		strPBKBRCH = request.getParameter("txtPBKBRCH");
		strPBKBRCH = (strPBKBRCH != null) ? CommonUtil.AllTrim(strPBKBRCH).toUpperCase() : "" ;

		strPBKCITY = request.getParameter("txtPBKCITY");
		strPBKCITY = (strPBKCITY != null) ? CommonUtil.AllTrim(strPBKCITY).toUpperCase() : "" ;

		strPBKCOTRY = request.getParameter("selPBKCOTRY");
		strPBKCOTRY = (strPBKCOTRY != null) ? CommonUtil.AllTrim(strPBKCOTRY).toUpperCase() : "" ;

		strPENGNAME = request.getParameter("txtPENGNAME");
		strPENGNAME = (strPENGNAME != null) ? CommonUtil.AllTrim(strPENGNAME).toUpperCase() : "" ;

		// R70088 ���_�l��O�P��J�鰵���
		strENTRYDT = request.getParameter("hidENTRYDT");
		strENTRYDT = (strENTRYDT != null) ? CommonUtil.AllTrim(strENTRYDT) : "" ;
		iENTRYDT = (!strENTRYDT.equals("")) ? Integer.parseInt(strENTRYDT) : 0 ;

		// R80300 �H�Υd���d��
		strPOrgCrdNo = request.getParameter("txtUPOrgCrdNo");
		strPOrgCrdNo = (strPOrgCrdNo != null) ? CommonUtil.AllTrim(strPOrgCrdNo) : "" ;

		// R80300 �H�Υd�����B
		strPOrgAMT = request.getParameter("txtUPOrgAMT");
		strPOrgAMT = (strPOrgAMT != null) ? CommonUtil.AllTrim(strPOrgAMT) : "" ;
		iPOrgAMT = (!strPOrgAMT.equals("")) ? Double.parseDouble(strPOrgAMT.trim()) : 0 ;

		// R80480 ���ڤHID
		strPID = request.getParameter("txtUPId");
		strPID = (strPID != null) ? CommonUtil.AllTrim(strPID) : "" ;

		boolean bBankExist = true;
		Hashtable htBkCdTemp = null;
		if (strPMethod.equals("B") && strCurrency.equals("NT")) {
			bBankExist = false;
			if (alBankCode.size() > 0) {
				// System.out.println("strPRBank :" + strPRBank ) ;
				for (int i = 0; i < alBankCode.size(); i++) {
					htBkCdTemp = (Hashtable) alBankCode.get(i);
					String strBKNO = (String) htBkCdTemp.get("BKNO");
					// System.out.println("strBKNO :" + strBKNO ) ;
					if (strBKNO.equals(strPRBank)) {
						bBankExist = true;
					}
				}
			}
			if (bBankExist == false) {
				bContinue = false;
				request.setAttribute("txtMsg", "�״ڻȦ���~,�нT�{");
				strReturnMsg = inquiryDB(request, response);
			}
		}

		if (bBankExist == true) {
			/* ��s���I�D�� */
			strSql = " update CAPPAYF ";
			strSql += " set PNAME=?,PDATE=?,PMETHOD=?,PDESC=? ,PRBANK=?,PRACCOUNT=?,PCRDNO=?,PCRDTYPE=?,PCRDEFFMY=? "
					+ ",PAUTHCODE=?,PDISPATCH=?,PCHKM1=?,PCHKM2=?,PSRCCODE=?,UPDDT=?,UPDTM=?,UPDUSR=?,PAUTHDT=? ";
			// R60550
			if (strPMethod.equals("D"))
				strSql += ",PFEEWAY=?,PSWIFT=?,PBKCOTRY=?,PBKCITY=?,PBKBRCH=?,PENGNAME=? ";

			strSql += ",PORGCRDNO=?,PORGAMT=?";// R80300
			strSql += ",PID=?";// R80480

			strSql += " where PNO=? ";
			System.out.println(" inside DISBPMaintainServlet.upddataDB()--> strSql =" + strSql);

			try {
				disbBean = new DISBBean(dbFactory);
				strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
				if (strReturnMsg.equals("")) {
					pstmtTmp = con.prepareStatement(strSql);

					pstmtTmp.setString(1, strPName);
					pstmtTmp.setInt(2, iPDate);
					pstmtTmp.setString(3, strPMethod);
					pstmtTmp.setString(4, strPDesc);
					pstmtTmp.setString(5, strPRBank);
					pstmtTmp.setString(6, strPRAccount);
					pstmtTmp.setString(7, strPCrdNo);
					pstmtTmp.setString(8, strPCrdType);
					pstmtTmp.setString(9, strPCrdEffMY);
					pstmtTmp.setString(10, strUPAuthCode);
					pstmtTmp.setString(11, strUDispatch);
					pstmtTmp.setString(12, strUPCHKM1);
					pstmtTmp.setString(13, strUPCHKM2);
					pstmtTmp.setString(14, strPSrcCode);
					pstmtTmp.setInt(15, iUpdDate);
					pstmtTmp.setInt(16, iUpdTime);
					pstmtTmp.setString(17, strLogonUser);
					pstmtTmp.setInt(18, iPAuthDt);

					if (!strPMethod.equals("D"))
					// R80300pstmtTmp.setString(19, strPNO);
					{
						pstmtTmp.setString(19, strPOrgCrdNo);
						pstmtTmp.setDouble(20, iPOrgAMT);
						// R80480 pstmtTmp.setString(21, strPNO);
						pstmtTmp.setString(21, strPID);// R80480 ���ڤHID
						pstmtTmp.setString(22, strPNO);
					} else {
						pstmtTmp.setString(19, strPFEEWAY);
						pstmtTmp.setString(20, strPSWIFT);
						pstmtTmp.setString(21, strPBKCOTRY);
						pstmtTmp.setString(22, strPBKCITY);
						pstmtTmp.setString(23, strPBKBRCH);
						pstmtTmp.setString(24, strPENGNAME);
						// R80300 pstmtTmp.setString(25, strPNO);
						pstmtTmp.setString(25, strPOrgCrdNo);
						pstmtTmp.setDouble(26, iPOrgAMT);
						// R80480 pstmtTmp.setString(27, strPNO);
						pstmtTmp.setString(27, strPID);// R80480 ���ڤHID
						pstmtTmp.setString(28, strPNO);
					}
					if (pstmtTmp.executeUpdate() != 1) {
						bContinue = false;
						request.setAttribute("txtMsg", "�ק異��");
					} else {
						String rm = "";
						bContinue = true;
						// R90474
						if ("DISBPSourceConfirm".equals(request.getParameter("nextAction") != null ? request.getParameter("nextAction") : "")) {
							updatePayments(request, response);
							rm = "\n\n�T�{�ӵ���I�ӷ����\";
						}
						// R60550 spul���_�l�餧�e�B�~�׶״ڪ�show�T��
						// R70088 if(strSYMBOL.equals("S") &&
						// strPMethod.equals("D") && iPDate < iINVDT)
						if (strSYMBOL.equals("S") && strPMethod.equals("D") && iENTRYDT <= iINVDT)
							request.setAttribute("txtMsg", "�ק令�\" + rm + "\r\n�ж�g�ץX�״ڥӽЮѨ��˪����w��!");
						else
							request.setAttribute("txtMsg", "�ק令�\" + rm);

						strReturnMsg = inquiryDB(request, response);
						if (!strReturnMsg.equals("")) {
							request.setAttribute("txtMsg", strReturnMsg);
						}
					}
					pstmtTmp.close();
				} else {
					bContinue = false;
					request.setAttribute("txtMsg", strReturnMsg);
				}
				if (!bContinue) {
					if (isAEGON400) {
						con.rollback();
					}
				}
			} catch (SQLException e) {
				request.setAttribute("txtMsg", "�ק異��" + e);
				if (con != null)
					dbFactory.releaseAS400Connection(con);
			} finally {
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			}
		}

		// �ѳ浧���Ӻ��@�Ө�
		if (request.getParameter("txtParent") != null && request.getParameter("txtParent").equals("DISBPSourceConfirm")) {
			request.setAttribute("txtAction", "I");
			request.setAttribute("txtParent", "DISBPSourceConfirm");
			dispatcher = request.getRequestDispatcher("/DISB/DISBPSource/DISBPSourceDetails.jsp");
			dispatcher.forward(request, response);
		} else {
			request.setAttribute("txtAction", "U");
			dispatcher = request.getRequestDispatcher("/DISB/DISBPSource/DISBPSourceMaintain.jsp");
			dispatcher.forward(request, response);
		}

		return;
	}

	private void updatePayments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory.getAS400Connection("DISBSMaintainServlet.updatePayments()");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strPNO = ""; // ��I�Ǹ�

		/* ���o�e������� */
		strPNO = request.getParameter("txtUPNO");
		strPNO = (strPNO != null) ? CommonUtil.AllTrim(strPNO) : "" ;

		/* ��s���I�D�� */
		strSql = " update CAPPAYF ";
		strSql += " set PCFMDT1 = ?, PCFMTM1 = ?, PCFMUSR1=?, UPDDT=?, UPDTM=?, UPDUSR=? ";
		strSql += " where PNO =? ";

		try {
			disbBean = new DISBBean(dbFactory);
			strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
			if (strReturnMsg.equals("")) {
				pstmtTmp = con.prepareStatement(strSql);

				pstmtTmp.setInt(1, iUpdDate);
				pstmtTmp.setInt(2, iUpdTime);
				pstmtTmp.setString(3, strLogonUser);
				pstmtTmp.setInt(4, iUpdDate);
				pstmtTmp.setInt(5, iUpdTime);
				pstmtTmp.setString(6, strLogonUser);
				pstmtTmp.setString(7, strPNO);
				if (pstmtTmp.executeUpdate() < 1) {
					request.setAttribute("txtMsg", "�T�{����");
				} else {
					request.setAttribute("txtMsg", "�T�{���\");
				}
				pstmtTmp.close();
			} else {
				request.setAttribute("txtMsg", strReturnMsg);
			}
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
			} else {
				strReturnMsg = inquiryDB(request, response);
				if (!strReturnMsg.equals("")) {
					request.setAttribute("txtMsg", strReturnMsg);
				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�T�{����-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		// R90474
		if (!"DISBPSourceConfirm".equals(request.getParameter("nextAction") != null ? request.getParameter("nextAction") : "")) {
			request.setAttribute("txtAction", "DISBPSourceConfirm");
			dispatcher = request.getRequestDispatcher("/DISB/DISBPSource/DISBPSourceMaintain.jsp");
			dispatcher.forward(request, response);
			return;
		}
	}

	private void cancelConfirm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();

		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory.getAS400Connection("DISBSMaintainServlet.cancelConfirm()");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strPNO = ""; // ��I�Ǹ�

		/* ���o�e������� */
		strPNO = request.getParameter("txtUPNO");
		strPNO = (strPNO != null) ? CommonUtil.AllTrim(strPNO) : "" ;

		/* ��s���I�D�� */
		strSql = " update CAPPAYF ";
		strSql += " set PCFMDT1 = 0, PCFMTM1 = 0, PCFMUSR1='', UPDDT=?, UPDTM=?, UPDUSR=? ";
		strSql += " where PNO =? ";

		try {
			disbBean = new DISBBean(dbFactory);
			strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
			if (strReturnMsg.equals("")) {
				pstmtTmp = con.prepareStatement(strSql);

				pstmtTmp.setInt(1, iUpdDate);
				pstmtTmp.setInt(2, iUpdTime);
				pstmtTmp.setString(3, strLogonUser);
				pstmtTmp.setString(4, strPNO);
				if (pstmtTmp.executeUpdate() < 1) {
					request.setAttribute("txtMsg", "�����T�{����");
				} else {
					request.setAttribute("txtMsg", "�����T�{���\");
				}
				pstmtTmp.close();
			} else {
				request.setAttribute("txtMsg", strReturnMsg);
			}
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
			} else {
				strReturnMsg = inquiryDB(request, response);
				if (!strReturnMsg.equals("")) {
					request.setAttribute("txtMsg", strReturnMsg);
				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�����T�{����-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}

		request.setAttribute("txtAction", "DISBCancelConfirm");
		dispatcher = request.getRequestDispatcher("/DISB/DISBPSource/DISBPSourceMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private void inquiryDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = null;
		String strReturnMsg = "";
		strReturnMsg = inquiryDB(request, response);
		request.setAttribute("txtMsg", strReturnMsg);

		request.setAttribute("txtAction", "I");
		dispatcher = request.getRequestDispatcher("/DISB/DISBPSource/DISBPSourceDetails.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private void inquiryD(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = null;
		String strReturnMsg = "";
		strReturnMsg = inquiryDB(request, response);
		request.setAttribute("txtMsg", strReturnMsg);

		request.setAttribute("txtAction", "I");
		dispatcher = request.getRequestDispatcher("/DISB/DISBPSource/DISBPSourceMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private String inquiryDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);

		Connection con = dbFactory.getAS400Connection("DISBPMaintainServlet.inquiryDB()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* �����e�����w�q */
		String strPNo = ""; // �I�ڤ��

		strPNo = request.getParameter("txtPNo");
		strPNo = (strPNo != null) ? CommonUtil.AllTrim(strPNo) : "" ;

		if (strPNo.equals("")) {
			strPNo = request.getParameter("txtUPNO");
			strPNo = (strPNo != null) ? CommonUtil.AllTrim(strPNo) : "" ;
		}

		strSql = "select A.ENTRYDT,A.PAMT,A.PCFMDT1,A.PCFMTM1,A.PCFMDT2,A.PCFMTM2,A.PDATE,A.UPDDT,A.UPDTM,A.APPNO,A.POLICYNO,A.ENTRYUSR,A.PAUTHCODE,A.PBACCOUNT,A.PBBANK,A.PCFMUSR1,A.PCFMUSR2,A.PCHECKNO,A.PCRDEFFMY,A.PCRDNO,A.PCRDTYPE,A.PDESC,A.PDISPATCH,A.PID,A.PMETHOD,A.PNAME,A.PNO,A.PNOH,A.PRACCOUNT,A.PRBANK,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.BRANCH,MEMO,A.PCHKM1,A.PCHKM2,A.PAUTHCODE,A.PAUTHDT,A.PCURR,C.FLD0004 AS PSRCGPDESC";
		strSql += ",A.PPAYCURR,A.PPAYAMT,A.PPAYRATE,A.PFEEWAY,A.PSYMBOL,A.PINVDT,A.PSWIFT,A.PBKCOTRY,A.PBKCITY,A.PBKBRCH,A.PENGNAME,S.BANK_NAME AS SWBKNAME,R.FPAYAMT AS FPAYAMT,R.FFEEWAY AS FFEEWAY";// R60550
		strSql += ",CAST(U.USRNAM AS CHAR(14))||CAST(T2.FLD0003 AS CHAR(4))||CAST(T1.FLD0003 AS CHAR(4))||CAST(T2.FLD0004 AS CHAR(16))||CAST(T1.FLD0004 AS CHAR(12)) AS USRINFO";// RC0036
		strSql += ",A.PORGAMT, A.PORGCRDNO, A.PPLANT";// R80300
		strSql += " from CAPPAYF A ";
		strSql += " left outer join ORDUET C on C.FLD0003 = A.PAY_SOURCE_GROUP ";
		strSql += " left outer join ORCHSWFT S ON A.PSWIFT = S.SWIFT_CODE";// R60550
		strSql += " left outer join CAPRFEF R ON A.PNO = R.FPNO";// R60550
        strSql += " left outer join USER U ON A.ENTRYUSR = U.USRID "; //RC0036
		strSql += " left outer join ORDUET T1 ON  T1.FLD0003 = U.USRBRCH";   //RC0036 
		strSql += " left outer join ORDUET T2 ON  T2.FLD0003 = U.DEPT  ";//RC0036
		strSql += " WHERE 1=1  AND C.FLD0002='SRCGP'  and A.PNO='" + strPNo + "'";
		strSql += "   AND T1.FLD0002 = 'DEPT'  AND T2.FLD0002 = 'DEPT'"; //RC0036

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			if (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrMemo("MEMO");// �Ƶ�
				objPDetailVO.setIEntryDt(rs.getInt("ENTRYDT"));	// ��J���
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	// ��I���B
				objPDetailVO.setIPCfmDt1(rs.getInt("PCFMDT1"));	// ��I�T�{��@
				objPDetailVO.setIPCfmTm1(rs.getInt("PCFMTM1")); // ��I�T�{�ɤ@
				objPDetailVO.setIPCfmDt2(rs.getInt("PCFMDT2")); // ��I�T�{��G
				objPDetailVO.setIPCfmTm2(rs.getInt("PCFMTM2")); // ��I�T�{�ɤG
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		// �I�ڤ��
				objPDetailVO.setIUpdDt(rs.getInt("UPDDT"));		// ���ʤ��
				objPDetailVO.setIUpdTm(rs.getInt("UPDTM"));		// ���ʮɶ�
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));// �n�O�Ѹ��X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));// �O�渹�X
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));// ��J�H��
				objPDetailVO.setStrPAuthCode(rs.getString("PAUTHCODE"));// ���v�X
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));// �I�ڻȦ�
				objPDetailVO.setStrPBBank(rs.getString("PBBANK"));// �I�ڱb��
				objPDetailVO.setStrPCfmUsr1(rs.getString("PCFMUSR1"));// ��I�T�{�̤@
				objPDetailVO.setStrPCfmUsr2(rs.getString("PCFMUSR2"));// ��I�T�{�̤G
				objPDetailVO.setStrPCheckNO(rs.getString("PCHECKNO"));// �䲼���X
				objPDetailVO.setStrPCrdEffMY(rs.getString("PCRDEFFMY"));// ���Ħ~��
				objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO"));// �H�Υd�d��
				objPDetailVO.setStrPCrdType(rs.getString("PCRDTYPE"));// �d�O
				objPDetailVO.setStrPAuthCode(rs.getString("PAUTHCODE"));// ���v�X
				objPDetailVO.setStrPDesc(rs.getString("PDESC")); // ��I�y�z
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));// ���_
				objPDetailVO.setStrPId(rs.getString("PID")); // ���ڤHID
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));// �I�ڤ覡
				objPDetailVO.setStrPName(rs.getString("PNAME"));// ���ڤH�m�W
				objPDetailVO.setStrPNO(rs.getString("PNO")); // ��I�Ǹ�
				objPDetailVO.setStrPNoH(rs.getString("PNOH")); // ���I�Ǹ�
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));// �״ڱb��
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));// �״ڻȦ�
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP") + "--" + rs.getString("PSRCGPDESC"));// �ӷ��ոs
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE"));// ��I��]�N�X
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS"));// �I�ڪ��A
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));// ���O
				objPDetailVO.setStrPChkm1(rs.getString("PCHKM1")); // �䲼�T�I
				objPDetailVO.setStrPChkm2(rs.getString("PCHKM2")); // �䲼���u
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));// �O����ݳ��
				objPDetailVO.setIPAuthDt(rs.getInt("PAUTHDT"));// ���v�����
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));// �@�o�_
				objPDetailVO.setStrUsrInfo(rs.getString("USRINFO"));// RC0036
				if (rs.getString("PVOIDABLE") != null || !rs.getString("PVOIDABLE").equals("")) // �M�w���O�_�Ŀ�
				{
					if (rs.getString("PVOIDABLE").equals("Y")) {
						objPDetailVO.setChecked(false);
						objPDetailVO.setDisabled(true);
					}
				}
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));// ���_
				if (rs.getString("PDISPATCH") != null || !rs.getString("PDISPATCH").equals("")) // �M�w���O�_Disable
				{
					if (rs.getString("PDISPATCH").equals("Y")) {
						objPDetailVO.setChecked(false);
					}
				}
				// R60550 12�����
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));// �~���ץX���O
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));// �~���ץX���B
				objPDetailVO.setIPPAYRATE(rs.getDouble("PPAYRATE"));// �~���ץX�ײv
				objPDetailVO.setStrPFEEWAY(rs.getString("PFEEWAY"));// ����O��I�覡
				objPDetailVO.setStrPSYMBOL(rs.getString("PSYMBOL"));// ���O
				objPDetailVO.setIPINVDT(rs.getInt("PINVDT"));// ���_�l��
				objPDetailVO.setStrPSWIFT(rs.getString("PSWIFT"));// SWIFT CODE
				objPDetailVO.setStrPBKCOTRY(rs.getString("PBKCOTRY"));// �Ȧ��O
				objPDetailVO.setStrPBKCITY(rs.getString("PBKCITY"));// �Ȧ櫰��
				objPDetailVO.setStrPBKBRCH(rs.getString("PBKBRCH"));// �Ȧ����
				objPDetailVO.setStrPENGNAME(rs.getString("PENGNAME"));// ���ڤH�^��m�W
				objPDetailVO.setSWBKNAME(rs.getString("SWBKNAME"));// �Ȧ�W��
				objPDetailVO.setFPAYAMT(rs.getDouble("FPAYAMT"));// �װh����O
				objPDetailVO.setFFEEWAY(rs.getString("FFEEWAY"));// �װh��I�覡
				// R80300 2�����
				objPDetailVO.setStrPOrgCrdNo(rs.getString("PORGCRDNO"));// ���d��
				objPDetailVO.setIPOrgAMT(rs.getDouble("PORGAMT"));// ���d��
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));

				alPDetail.add(objPDetailVO);
				strReturnMsg = "";
			} else {
				strReturnMsg = "�d�L��I�Ǹ�[" + strPNo + "]���������";
			}
			session.removeAttribute("PDetailListTemp");
			session.removeAttribute("PDetailList");
			session.setAttribute("PDetailListTemp", alPDetail);
			session.setAttribute("PDetailList", alPDetail);
		} catch (SQLException ex) {
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
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			} catch (Exception ex1) {
			}
		}
		return strReturnMsg;
	}
}