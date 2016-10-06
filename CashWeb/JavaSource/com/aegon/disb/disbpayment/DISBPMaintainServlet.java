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
import org.apache.log4j.Logger;

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
 * $$Log: DISBPMaintainServlet.java,v $
 * $Revision 1.14  2013/12/24 03:03:31  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.13  2013/05/30 02:03:54  MISSALLY
 * $RA0064-CMP�M��CASH�t�X�ק�
 * $
 * $Revision 1.12  2013/02/26 10:22:58  ODCWilliam
 * $william wu
 * $RA0074
 * $
 * $Revision 1.11  2012/05/18 09:47:37  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�
 * $
 * $Revision 1.10  2010/11/23 06:45:21  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.9  2008/08/21 09:17:32  misvanessa
 * $R80631_�s�W��l�I�ڤ覡 (FOR FF)
 * $
 * $Revision 1.8  2008/05/02 10:17:41  misvanessa
 * $R80300_�������x�s,�s�W�U���ɮפγ��� �~���s��fix
 * $
 * $Revision 1.7  2008/04/30 07:47:50  misvanessa
 * $R80300_�������x�s,�s�W�U���ɮפγ���
 * $
 * $Revision 1.6  2007/11/13 06:43:57  MISVANESSA
 * $Q70581_�u�W�s�W�~���״ڤ�I����(BUGFIX)
 * $
 * $Revision 1.5  2007/01/31 03:55:50  MISVANESSA
 * $R70088_SPUL�t��_�s�WMETHOD
 * $
 * $Revision 1.4  2007/01/05 10:09:33  MISVANESSA
 * $R60550_�װh��I�覡
 * $
 * $Revision 1.3  2007/01/04 03:13:54  MISVANESSA
 * $R60550_�s�WSHOW�װh����O
 * $
 * $Revision 1.2  2006/11/30 09:11:51  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.1  2006/06/29 09:40:15  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.14  2006/05/19 07:21:10  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.13  2006/04/27 09:16:11  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.12  2005/07/19 04:12:03  MISANGEL
 * $Q50274 : �ˮֶ״ڻȦ�-�x�s���ˮֶ״ڻȦ�O�_�s�b,�Y���s�b,�h�L�k�x�s
 * $
 * $Revision 1.1.2.11  2005/04/28 08:56:25  miselsa
 * $R30530������ժ��ק�
 * $
 * $Revision 1.1.2.10  2005/04/04 07:02:24  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

public class DISBPMaintainServlet extends HttpServlet {
	
	private Logger logger = Logger.getLogger(getClass());

	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private DISBBean disbBean = null;
	private boolean isAEGON400 = false;

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String strAction = new String("");
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		try {
			if (strAction.equals("A"))
				insertDB(request, response);
			else if (strAction.equals("U"))
				updateDB(request, response);
			else if (strAction.equals("INQ"))
				inquiryD(request, response);// R60550
			else if (strAction.equals("DISBCancelConfirm"))
				canConfirmedDB(request, response);
			else if (strAction.equals("DISBPVoidable"))
				updPVoidable(request, response);
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
	private void insertDB(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		System.out.println("inside insert	DB");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session
				.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory
				.getAS400Connection("DISBPMaintainServlet.insertDB()");
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		Hashtable htReturnInfo = new Hashtable();
		List alBankCode = new ArrayList();

		if (session.getAttribute("BankCodeList") == null) {
			alBankCode = (List) disbBean.getBankList();
			session.setAttribute("BankCodeList", alBankCode);
		} else {
			alBankCode = (List) session.getAttribute("BankCodeList");
		}

		/* �����e�����w�q */
		String strPolNo = ""; // �O�渹�X
		String strAPPNo = ""; // �n�O�Ѹ��X
		String strPName = ""; // ���ڤH�m�W
		String strPId = ""; // ���ڤHID
		String strPAMT = ""; // ��I���B
		String strPDate = ""; // �I�ڤ��
		String strPMethod = ""; // �I�ڤ覡
		String strPDesc = ""; // ��I�y�z
		String strPSrcCode = ""; // ��I��]�N�X
		String strPRBank = ""; // �״ڻȦ�
		String strPRAccount = ""; // �״ڱb��
		String strPCrdNo = ""; // �H�Υd�d��
		String strPCrdType = ""; // �d�O
		String strPCrdEffMY = ""; // ���Ħ~��
		String strPCHKM1 = ""; // �䲼�T�I
		String strPCHKM2 = ""; // �䲼���u
		String strBranch = "";// ���
		String strServiceBranch = "";	//�����q
		int iEntryDate = 0; // ��J���
		int iEntryTime = 0; // ��J�ɶ�
		double iPAMT = 0; // ��I���B
		int iPDate = 0;// �I�ڤ��
		int iPAuthDt = 0;// ���v�����
		String strPAuthDt = "";// ���v�����
		String strUDispatch = ""; // ���_
		String strCurrency = ""; // ���O
		// R60550�s�W�~���״����
		String strINVDTC = "";
		int iINVDT = 0;
		String strPAYCURR = "";
		String strPAYAMT = "";
		double iPAYAMT = 0;
		// R10314
		String strPAYAMTNT = "";
		double iPAYAMTNT = 0;

		String strPAYRATE = "";
		double iPAYRATE = 0;
		String strPFEEWAY = "";
		String strPSWIFT = "";
		String strPBKBRCH = "";
		String strPBKCITY = "";
		String strPBKCOTRY = "";
		String strPENGNAME = "";
		String strSYMBOL = "";
		double iPOrgAMT = 0; // R80300 �����B
		String strPOrgCrdNo = "";// R80300 ���d��
		String strPOrgAMT = ""; // R80300 �����B

		iEntryDate = Integer.parseInt((String) commonUtil
				.convertWesten2ROCDate1(cldToday.getTime()));
		iEntryTime = Integer.parseInt((String) sdfFormatter.format(cldToday
				.getTime()));
		String strPNO = ""; // ��I�Ǹ�

		/* ���o�e������� */
		strPolNo = request.getParameter("txtUPolNo");
		if (strPolNo != null)
			strPolNo = strPolNo.trim();
		else
			strPolNo = "";
		request.setAttribute("txtUPolNo", strPolNo);

		strAPPNo = request.getParameter("txtUAppNo");
		if (strAPPNo != null)
			strAPPNo = strAPPNo.trim();
		else
			strAPPNo = "";
		request.setAttribute("txtUAppNo", strAPPNo);

		strPName = request.getParameter("txtUPName");
		if (strPName != null)
			strPName = strPName.trim();
		else
			strPName = "";
		request.setAttribute("txtUPName", strPName);

		strPId = request.getParameter("txtUPId");
		if (strPId != null)
			strPId = strPId.trim();
		else
			strPId = "";
		request.setAttribute("txtUPId", strPId);

		strPMethod = request.getParameter("selUPMethod");
		if (strPMethod != null)
			strPMethod = strPMethod.trim();
		else
			strPMethod = "";
		request.setAttribute("txtUPMethod", strPMethod);

		strPCHKM1 = request.getParameter("rdUPCHKM1");
		if (strPCHKM1 != null)
			strPCHKM1 = strPCHKM1.trim();
		else
			strPCHKM1 = "";
		request.setAttribute("txtUPCHKM1", strPCHKM1);

		strPCHKM2 = request.getParameter("rdUPCHKM2");
		if (strPCHKM2 != null)
			strPCHKM2 = strPCHKM2.trim();
		else
			strPCHKM2 = "";
		request.setAttribute("txtPCHKM2", strPCHKM2);

		strPDesc = request.getParameter("txtUPDesc");
		if (strPDesc != null)
			strPDesc = strPDesc.trim();
		else
			strPDesc = "";
		request.setAttribute("txtUPDesc", strPDesc);

		strPSrcCode = request.getParameter("selUPSrcCode");
		if (strPSrcCode != null)
			strPSrcCode = strPSrcCode.trim();
		else
			strPSrcCode = "";
		request.setAttribute("txtUPSrcCode", strPSrcCode);

		strPRBank = request.getParameter("txtUPRBank");
		if (strPRBank != null)
			strPRBank = strPRBank.trim();
		else
			strPRBank = "";
		request.setAttribute("txtUPRBank", strPRBank);

		strPRAccount = request.getParameter("txtUPRAccount");
		if (strPRAccount != null)
			strPRAccount = strPRAccount.trim();
		else
			strPRAccount = "";
		request.setAttribute("txtUPRAccount", strPRAccount);

		strPCrdNo = request.getParameter("txtUPCrdNo");
		if (strPCrdNo != null)
			strPCrdNo = strPCrdNo.trim();
		else
			strPCrdNo = "";
		request.setAttribute("txtUPCrdNo", strPCrdNo);

		strPCrdType = request.getParameter("txtPUCrdType");
		if (strPCrdType != null)
			strPCrdType = strPCrdType.trim();
		else
			strPCrdType = "";
		request.setAttribute("txtPUCrdType", strPCrdType);

		strPCrdEffMY = request.getParameter("txtUPCrdEffMY");
		if (strPCrdEffMY != null)
			strPCrdEffMY = strPCrdEffMY.trim();
		else
			strPCrdEffMY = "";
		request.setAttribute("txtUPCrdEffMY", strPCrdEffMY);

		strPAMT = request.getParameter("txtUPAMT");
		if (strPAMT != null)
			strPAMT = strPAMT.trim();
		else
			strPAMT = "";

		if (!strPAMT.equals(""))
			iPAMT = Double.parseDouble(strPAMT.trim());
		request.setAttribute("txtUPAMT", strPAMT);

		strPDate = request.getParameter("txtUPDate");
		if (strPDate != null) {
			strPDate = strPDate.trim();
		}
		if (!strPDate.equals(""))
			iPDate = Integer.parseInt(strPDate);
		request.setAttribute("txtUPDate", strPDate);

		strPAuthDt = request.getParameter("txtUPAuthDt");
		if (strPAuthDt != null) {
			strPAuthDt = strPAuthDt.trim();
		}
		if (!strPAuthDt.equals(""))
			iPAuthDt = Integer.parseInt(strPAuthDt);
		request.setAttribute("txtUPAuthDt", strPAuthDt);

		strUDispatch = request.getParameter("rdUDispatch");
		if (strUDispatch != null)
			strUDispatch = strUDispatch.trim();
		else
			strUDispatch = "";
		request.setAttribute("txtUDispatch", strUDispatch);

		strCurrency = request.getParameter("selUCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";
		request.setAttribute("txtCurrency", strCurrency);
		if (strCurrency.equals("")) {
			strCurrency = "NT";
		}
		// R60550
		strINVDTC = request.getParameter("txtINVDT");
		if (strINVDTC != null) {
			strINVDTC = strINVDTC.trim();
		}
		if (!strINVDTC.equals("")) {
			iINVDT = Integer.parseInt(strINVDTC);
		}

		strPAYCURR = request.getParameter("txtPAYCURR");
		if (strPAYCURR != null) {
			strPAYCURR = strPAYCURR.trim().toUpperCase();
		}

		strPAYAMT = request.getParameter("txtPAYAMT");
		if (strPAYAMT != null)
			strPAYAMT = strPAYAMT.trim();
		else
			strPAYAMT = "";
		if (!strPAYAMT.equals(""))
			iPAYAMT = Double.parseDouble(strPAYAMT.trim());

		// R10314
		strPAYAMTNT = request.getParameter("txtPAYAMTNT");
		if (strPAYAMTNT != null)
			strPAYAMTNT = strPAYAMTNT.trim();
		else
			strPAYAMTNT = "";

		if (!strPAYAMTNT.equals(""))
			iPAYAMTNT = Double.parseDouble(strPAYAMTNT.trim());

		strPAYRATE = request.getParameter("txtPAYRATE");
		if (strPAYRATE != null)
			strPAYRATE = strPAYRATE.trim();
		else
			strPAYRATE = "";
		if (!strPAYRATE.equals(""))
			iPAYRATE = Double.parseDouble(strPAYRATE.trim());

		strPFEEWAY = request.getParameter("selFEEWAY");
		if (strPFEEWAY != null) {
			strPFEEWAY = strPFEEWAY.trim();
		}
		strPSWIFT = request.getParameter("selPSWIFT");
		if (strPSWIFT != null) {
			strPSWIFT = strPSWIFT.trim();
		} else {
			strPSWIFT = "";// R70088
		}
		strPBKBRCH = request.getParameter("txtPBKBRCH");
		if (strPBKBRCH != null) {
			strPBKBRCH = strPBKBRCH.trim().toUpperCase();
		}
		strPBKCITY = request.getParameter("txtPBKCITY");
		if (strPBKCITY != null) {
			strPBKCITY = strPBKCITY.trim().toUpperCase();
		}
		strPBKCOTRY = request.getParameter("selPBKCOTRY");
		if (strPBKCOTRY != null) {
			strPBKCOTRY = strPBKCOTRY.trim();
		}
		strPENGNAME = request.getParameter("txtPENGNAME");
		if (strPENGNAME != null) {
			strPENGNAME = strPENGNAME.trim().toUpperCase();
		}
		strSYMBOL = request.getParameter("txtSYMBOL");
		if (strSYMBOL != null) {
			strSYMBOL = strSYMBOL.trim().toUpperCase();
		}
		// R80300 �H�Υd���d��
		strPOrgCrdNo = request.getParameter("txtUPOrgCrdNo");
		if (strPOrgCrdNo != null) {
			strPOrgCrdNo = strPOrgCrdNo.trim();
		}
		strPOrgAMT = request.getParameter("txtUPOrgAMT");
		// R80300 �H�Υd�����B
		if (strPOrgAMT != null)
			strPOrgAMT = strPOrgAMT.trim();
		else
			strPOrgAMT = "";
		if (!strPOrgAMT.equals(""))
			iPOrgAMT = Double.parseDouble(strPOrgAMT.trim());

		boolean bBankExist = true;
		if (strPMethod.equals("B") && strCurrency.equals("NT")) {
			bBankExist = false;
			if (alBankCode.size() > 0) {
				// System.out.println("strPRBank :" + strPRBank ) ;
				for (int i = 0; i < alBankCode.size(); i++) {
					Hashtable htBkCdTemp = (Hashtable) alBankCode.get(i);
					String strBKNO = (String) htBkCdTemp.get("BKNO");
					// System.out.println("strBKNO :" + strBKNO ) ;
					if (strBKNO.equals(strPRBank)) {
						bBankExist = true;
					}
				}
			}
			if (bBankExist == false) {
				request.setAttribute("txtMsg", "�״ڻȦ���~,�нT�{");
				strReturnMsg = inquiryDB(request, response);
			}
		}

		/* �s�W���I�D�� */
		if (bBankExist == true) {
			strSql = " insert into  CAPPAYF "
					+ " (PNO,POLICYNO,APPNO,PDATE,PNAME,PSNAME,PID,PAMT,PMETHOD,PCFMDT1,PCFMTM1,PCFMUSR1,PDESC"
					+ " ,PRBANK,PRACCOUNT,PCRDNO,PCRDTYPE,PCRDEFFMY"
					+ ",PCHKM1,PCHKM2,ENTRYDT,ENTRYTM,ENTRYUSR,BRANCH,UPDDT,UPDTM,UPDUSR,PAUTHDT,PCURR,PSRCGP,PSRCCODE,PDISPATCH,BATSEQ";
			if (strPMethod.equals("D"))// Q70581
				strSql += ",PPAYCURR,PPAYAMT,PPAYRATE,PFEEWAY,PSYMBOL,PINVDT,PSWIFT,PBKCOTRY,PBKCITY,PBKBRCH,PENGNAME";// R60550
			strSql += ",PORGAMT,PORGCRDNO,PAMTNT,SRVBH";// R80300 R10314
			strSql += ")";
			strSql += " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'WB',?,?,''";

			if (strPMethod.equals("D"))// Q70581
				strSql += ",?,?,?,?,?,?,?,?,?,?,?";
			strSql += ",?,?,?,?";// R80300 R10314
			strSql += ")";

			System.out.println(" inside DISBPMaintainServlet.insertDB()--> strSql =" + strSql);

			disbBean = new DISBBean(dbFactory);

			try {
				/* ���o��I�Ǹ� */
				//
				htReturnInfo = (Hashtable) disbBean.getDISBSeqNo("DISB", strLogonUser, con);
				strReturnMsg = (String) htReturnInfo.get("ReturnMsg");
				if (strReturnMsg.equals("")) {
					strPNO = (String) htReturnInfo.get("ReturnValue");
					request.setAttribute("txtPNo", strPNO);
					/* ���o�O���� */
					htReturnInfo = null;
					if (!strPolNo.equals("")) {
						htReturnInfo = (Hashtable) disbBean.getPolDiv(strPolNo, con);
						strReturnMsg = (String) htReturnInfo.get("ReturnMsg");
						if (strReturnMsg.equals("")) {
							strBranch = (String) htReturnInfo.get("ReturnValue");
							strServiceBranch = (String) htReturnInfo.get("RVSRVBH");
						}
					}
					if (strReturnMsg.equals("")) {
						PreparedStatement pstmtTmp = con.prepareStatement(strSql);
						pstmtTmp.setString(1, strPNO);
						pstmtTmp.setString(2, strPolNo);
						pstmtTmp.setString(3, strAPPNo);
						pstmtTmp.setInt(4, iPDate);
						pstmtTmp.setString(5, strPName);
						pstmtTmp.setString(6, strPName);
						pstmtTmp.setString(7, strPId);
						pstmtTmp.setDouble(8, iPAMT);
						pstmtTmp.setString(9, strPMethod);
						pstmtTmp.setInt(10, iEntryDate);
						pstmtTmp.setInt(11, iEntryTime);
						pstmtTmp.setString(12, strLogonUser);
						pstmtTmp.setString(13, strPDesc);
						pstmtTmp.setString(14, strPRBank);
						pstmtTmp.setString(15, strPRAccount);
						pstmtTmp.setString(16, strPCrdNo);
						pstmtTmp.setString(17, strPCrdType);
						pstmtTmp.setString(18, strPCrdEffMY);
						pstmtTmp.setString(19, strPCHKM1);
						pstmtTmp.setString(20, strPCHKM2);
						pstmtTmp.setInt(21, iEntryDate);
						pstmtTmp.setInt(22, iEntryTime);
						pstmtTmp.setString(23, strLogonUser);
						pstmtTmp.setString(24, strBranch);
						pstmtTmp.setInt(25, iEntryDate);
						pstmtTmp.setInt(26, iEntryTime);
						pstmtTmp.setString(27, strLogonUser);
						pstmtTmp.setInt(28, iPAuthDt);
						pstmtTmp.setString(29, strCurrency);
						pstmtTmp.setString(30, strPSrcCode);
						pstmtTmp.setString(31, strUDispatch);

						if (!strPMethod.equals("D")) {
							pstmtTmp.setDouble(32, iPOrgAMT);
							pstmtTmp.setString(33, strPOrgCrdNo);
							pstmtTmp.setDouble(34, iPAYAMTNT);// R10314
							pstmtTmp.setString(35, strServiceBranch);
						} else {
							pstmtTmp.setString(32, strPAYCURR);
							pstmtTmp.setDouble(33, iPAYAMT);
							pstmtTmp.setDouble(34, iPAYRATE);
							pstmtTmp.setString(35, strPFEEWAY);
							pstmtTmp.setString(36, strSYMBOL);
							pstmtTmp.setInt(37, iINVDT);
							pstmtTmp.setString(38, strPSWIFT);
							pstmtTmp.setString(39, strPBKCOTRY);
							pstmtTmp.setString(40, strPBKCITY);
							pstmtTmp.setString(41, strPBKBRCH);
							pstmtTmp.setString(42, strPENGNAME);
							pstmtTmp.setDouble(43, iPOrgAMT);
							pstmtTmp.setString(44, strPOrgCrdNo);
							pstmtTmp.setDouble(45, iPAYAMTNT);// R10314
							pstmtTmp.setString(46, strServiceBranch);
						}
						if (pstmtTmp.executeUpdate() != 1) {
							strReturnMsg = "�s�W����";
						} else {
							request.setAttribute("txtMsg", "�s�W���\, ��I�Ǹ���:" + strPNO);
							request.setAttribute("isErr", "");
						}
						pstmtTmp.close();
					}
				}
				if (!strReturnMsg.equals("")) {
					request.setAttribute("isErr", "Y");
					request.setAttribute("txtMsg", strReturnMsg);
					if (isAEGON400) {
						con.rollback();
					}
				} else {
					strReturnMsg = inquiryDB(request, response);
					if (!strReturnMsg.equals("")) {
						request.setAttribute("txtMsg", strReturnMsg);
						request.setAttribute("isErr", "Y");
					}
				}
			} catch (SQLException e) {
				request.setAttribute("txtMsg", "�s�W����:" + e);
				request.setAttribute("isErr", "Y");
				if (con != null)
					dbFactory.releaseAS400Connection(con);
			} finally {
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			}
		}
		request.setAttribute("txtAction", "A");
		dispatcher = request.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentMaintain.jsp");
		dispatcher.forward(request, response);
	}

	private void canConfirmedDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("@@@@@inside canConfirmedDB");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();

		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session
				.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory
				.getAS400Connection("DISBPMaintainServlet.canConfirmedDB()");
		PreparedStatement pstmtTmp = null;
		String strReturnMsg = "";
		String strSql = ""; // SQL String
		int iUpdDate = Integer.parseInt((String) commonUtil
				.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday
				.getTime()));
		/* �����e�����w�q */
		String strPNO = ""; // ��I�Ǹ�
		strPNO = request.getParameter("txtUPNO");
		if (strPNO != null)
			strPNO = strPNO.trim();
		else
			strPNO = "";

		strSql = " update CAPPAYF ";
		strSql += " set PCFMDT2 = 0 , PCFMTM2 = 0 , PCFMUSR2='' ";
		strSql += " , UPDUSR ='" + strLogonUser + "' , UPDDT= " + iUpdDate;
		strSql += " , UPDTM = " + iUpdTime;
		strSql += " where PNO ='" + strPNO + "'";

		try {
			// �Ulog
			disbBean = new DISBBean(dbFactory);
			strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser,
					iUpdDate, iUpdTime, con);
			if (strReturnMsg.equals("")) {
				pstmtTmp = con.prepareStatement(strSql);
				if (pstmtTmp.executeUpdate() != 1) {
					strReturnMsg = "�����T�{����";
				} else {
					request.setAttribute("txtMsg", "�����T�{���\");
					request.setAttribute("isErr", "");
				}
			}
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtMsg", strReturnMsg);
				request.setAttribute("isErr", "Y");
			} else {
				strReturnMsg = inquiryDB(request, response);
				if (!strReturnMsg.equals("")) {
					request.setAttribute("txtMsg", strReturnMsg);
					request.setAttribute("isErr", "Y");
				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�����T�{����:" + e);
			request.setAttribute("isErr", "Y");
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			try {
				if (pstmtTmp != null)
					pstmtTmp.close();
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			} catch (Exception ex1) {
			}
		}
		request.setAttribute("txtAction", "DISBCancelConfirm");
		dispatcher = request
				.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentMaintain.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 * @see javax.servlet.GenericServlet#void ()
	 */
	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON) != null) {
			globalEnviron = (GlobalEnviron) getServletContext().getAttribute(
					Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory = (DbFactory) getServletContext().getAttribute(
					Constant.DB_FACTORY);
		}

		if (globalEnviron.getActiveAS400DataSource().equals(
				Constant.AS400_DATA_SOURCE_NAME_AEGON400)) {
			isAEGON400 = true;
		}
		// R00393
		commonUtil = new CommonUtil(globalEnviron);
	}

	/**
	 * @param request
	 * @param response
	 */
	private void updPVoidable(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		System.out.println("@@@@@inside updPVoidable");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();

		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session
				.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory
				.getAS400Connection("DISBPMaintainServlet.updPVoidable()");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		int iUpdDate = Integer.parseInt((String) commonUtil
				.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday
				.getTime()));
		/* �����e�����w�q */
		String strPNO = ""; // ��I�Ǹ�
		strPNO = request.getParameter("txtUPNO");
		if (strPNO != null)
			strPNO = strPNO.trim();
		else
			strPNO = "";

		strSql = " update CAPPAYF ";
		strSql += " set PVOIDABLE = 'Y', UPDUSR ='" + strLogonUser
				+ "' , UPDDT= " + iUpdDate;
		strSql += " , UPDTM = " + iUpdTime;
		strSql += " where PNO ='" + strPNO + "'";

		try {
			disbBean = new DISBBean(dbFactory);
			strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser,
					iUpdDate, iUpdTime, con);
			if (strReturnMsg.equals("")) {
				pstmtTmp = con.prepareStatement(strSql);
				if (pstmtTmp.executeUpdate() != 1) {
					strReturnMsg = "����@�o����";
				} else {
					request.setAttribute("txtMsg", "����@�o���\");
					request.setAttribute("isErr", "");
				}
				pstmtTmp.close();
			}
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtMsg", strReturnMsg);
				request.setAttribute("isErr", "Y");
			} else {
				strReturnMsg = inquiryDB(request, response);
				if (!strReturnMsg.equals("")) {
					request.setAttribute("isErr", "Y");
					request.setAttribute("txtMsg", strReturnMsg);
				}
			}
		} catch (SQLException e) {
			request.setAttribute("isErr", "Y");
			request.setAttribute("txtMsg", "����@�o����:" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			try {
				if (pstmtTmp != null)
					pstmtTmp.close();
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			} catch (Exception ex1) {
			}
		}
		request.setAttribute("txtAction", "DISBPVoidable");
		dispatcher = request
				.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentMaintain.jsp");
		dispatcher.forward(request, response);

	}

	/**
	 * @param request
	 * @param response
	 */
	private void updateDB(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();

		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory.getAS400Connection("DISBPMaintainServlet.updateDB()");
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

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strPNO = ""; // ��I�Ǹ�
		String strPName = ""; // ���ڤH�m�W
		String strPId = "";// ���ڤHId
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
		String strCurrency = "";
		// R60550�s�W�~���״����
		String strPFEEWAY = "";
		String strPSWIFT = "";
		String strPBKBRCH = "";
		String strPBKCITY = "";
		String strPBKCOTRY = "";
		String strPENGNAME = "";
		String strSYMBOL = "";
		double iPOrgAMT = 0; // R80300 �����B
		String strPOrgCrdNo = "";// R80300 ���d��
		String strPOrgAMT = ""; // R80300 �����B
		double iPAYAMTNT = 0;	//R10314
		String strPAYAMTNT = "";//R10314

		/* ���o�e������� */
		strPNO = request.getParameter("txtUPNO");
		if (strPNO != null)
			strPNO = strPNO.trim();
		else
			strPNO = "";

		strPName = request.getParameter("txtUPName");
		if (strPName != null)
			strPName = strPName.trim();
		else
			strPName = "";

		strPId = request.getParameter("txtUPId");
		if (strPId != null)
			strPId = strPId.trim();
		else
			strPId = "";

		strPMethod = request.getParameter("selUPMethod");
		if (strPMethod != null)
			strPMethod = strPMethod.trim();
		else
			strPMethod = "";

		strPDesc = request.getParameter("txtUPDesc");
		if (strPDesc != null)
			strPDesc = strPDesc.trim();
		else
			strPDesc = "";

		strPRBank = request.getParameter("txtUPRBank");
		if (strPRBank != null)
			strPRBank = strPRBank.trim();
		else
			strPRBank = "";

		strPRAccount = request.getParameter("txtUPRAccount");
		if (strPRAccount != null)
			strPRAccount = strPRAccount.trim();
		else
			strPRAccount = "";

		strPCrdNo = request.getParameter("txtUPCrdNo");
		if (strPCrdNo != null)
			strPCrdNo = strPCrdNo.trim();
		else
			strPCrdNo = "";

		strPCrdType = request.getParameter("txtPUCrdType");
		if (strPCrdType != null)
			strPCrdType = strPCrdType.trim();
		else
			strPCrdType = "";

		strPCrdEffMY = request.getParameter("txtUPCrdEffMY");
		if (strPCrdEffMY != null)
			strPCrdEffMY = strPCrdEffMY.trim();
		else
			strPCrdEffMY = "";

		strUPAuthCode = request.getParameter("txtUPAuthCode");
		if (strUPAuthCode != null)
			strUPAuthCode = strUPAuthCode.trim();
		else
			strUPAuthCode = "";

		strUDispatch = request.getParameter("rdUDispatch");
		if (strUDispatch != null)
			strUDispatch = strUDispatch.trim();
		else
			strUDispatch = "";

		strUPCHKM1 = request.getParameter("rdUPCHKM1");
		if (strUPCHKM1 != null)
			strUPCHKM1 = strUPCHKM1.trim();
		else
			strUPCHKM1 = "";

		strUPCHKM2 = request.getParameter("rdUPCHKM2");
		if (strUPCHKM2 != null)
			strUPCHKM2 = strUPCHKM2.trim();
		else
			strUPCHKM2 = "";

		strPDate = request.getParameter("txtUPDate");
		if (strPDate != null) {
			strPDate = strPDate.trim();
		}
		if (!strPDate.equals("")) {
			iPDate = Integer.parseInt(strPDate);
		}

		strPAuthDt = request.getParameter("txtUPAuthDt");
		if (strPAuthDt != null) {
			strPAuthDt = strPAuthDt.trim();
		}
		if (!strPAuthDt.equals("")) {
			iPAuthDt = Integer.parseInt(strPAuthDt);
		}
		strPSrcCode = request.getParameter("selUPSrcCode");
		if (strPSrcCode != null) {
			strPSrcCode = strPSrcCode.trim();
		}

		strCurrency = request.getParameter("selUCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";
		// R60550
		strSYMBOL = request.getParameter("txtSYMBOL");
		if (strSYMBOL != null) {
			strSYMBOL = strSYMBOL.trim();
		}
		strPFEEWAY = request.getParameter("selFEEWAY");
		if (strPFEEWAY != null) {
			strPFEEWAY = strPFEEWAY.trim();
		}
		strPSWIFT = request.getParameter("selPSWIFT");
		if (strPSWIFT != null) {
			strPSWIFT = strPSWIFT.trim().toUpperCase();
		} else {
			strPSWIFT = "";// R70088
		}
		strPBKBRCH = request.getParameter("txtPBKBRCH");
		if (strPBKBRCH != null) {
			strPBKBRCH = strPBKBRCH.trim().toUpperCase();
		}
		strPBKCITY = request.getParameter("txtPBKCITY");
		if (strPBKCITY != null) {
			strPBKCITY = strPBKCITY.trim().toUpperCase();
		}
		strPBKCOTRY = request.getParameter("selPBKCOTRY");
		if (strPBKCOTRY != null) {
			strPBKCOTRY = strPBKCOTRY.trim();
		}
		strPENGNAME = request.getParameter("txtPENGNAME");
		if (strPENGNAME != null) {
			strPENGNAME = strPENGNAME.trim().toUpperCase();
		}
		// R80300 �H�Υd���d��
		strPOrgCrdNo = request.getParameter("txtUPOrgCrdNo");
		if (strPOrgCrdNo != null) {
			strPOrgCrdNo = strPOrgCrdNo.trim();
		}
		strPOrgAMT = request.getParameter("txtUPOrgAMT");
		// R80300 �H�Υd�����B
		if (strPOrgAMT != null)
			strPOrgAMT = strPOrgAMT.trim();
		else
			strPOrgAMT = "";
		if (!strPOrgAMT.equals(""))
			iPOrgAMT = Double.parseDouble(strPOrgAMT.trim());

		//R10314
		strPAYAMTNT = request.getParameter("txtPAYAMTNT");
		if (strPAYAMTNT != null)
			strPAYAMTNT = strPAYAMTNT.trim();
		else
			strPAYAMTNT = "";
		if(!strPAYAMTNT.equals(""))
			iPAYAMTNT = Double.parseDouble(strPAYAMTNT);

		boolean bBankExist = true;
		if (strPMethod.equals("B")) {
			bBankExist = false;
			if (alBankCode.size() > 0) {

				for (int i = 0; i < alBankCode.size(); i++) {
					Hashtable htBkCdTemp = (Hashtable) alBankCode.get(i);
					String strBKNO = (String) htBkCdTemp.get("BKNO");

					if (strBKNO.equals(strPRBank)) {
						bBankExist = true;
					}
				}
			}
			if (bBankExist == false) {
				request.setAttribute("txtMsg", "�״ڻȦ���~");
				request.setAttribute("isErr", "Y");
			}
		}

		/* ��s���I�D�� */
		if (bBankExist == true) {
			strSql = " update CAPPAYF ";
			strSql += " set  PNAME=?,PID=?,PDATE=?,PMETHOD=?,PDESC=? ,PRBANK=?,PRACCOUNT=?,PCRDNO=?,PCRDTYPE=?,PCRDEFFMY=? "
					+ ",PAUTHCODE=?,PDISPATCH=?,PCHKM1=?,PCHKM2=?,PSRCCODE=? "
					+ ",UPDDT=?,UPDTM=?,UPDUSR=?,PAUTHDT=?,PCURR=?";
			// R60550
			if (strPMethod.equals("D"))
				strSql += ",PFEEWAY=?,PSWIFT=?,PBKCOTRY=?,PBKCITY=?,PBKBRCH=?,PENGNAME=?";

			strSql += ",PORGCRDNO=?,PORGAMT=?,PAMTNT=?";
			strSql += " where PNO =? ";

			try {
				disbBean = new DISBBean(dbFactory);
				strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
				if (strReturnMsg.equals("")) {
					pstmtTmp = con.prepareStatement(strSql);

					pstmtTmp.setString(1, strPName);
					pstmtTmp.setString(2, strPId);
					pstmtTmp.setInt(3, iPDate);
					pstmtTmp.setString(4, strPMethod);
					pstmtTmp.setString(5, strPDesc);
					pstmtTmp.setString(6, strPRBank);
					pstmtTmp.setString(7, strPRAccount);
					pstmtTmp.setString(8, strPCrdNo);
					pstmtTmp.setString(9, strPCrdType);
					pstmtTmp.setString(10, strPCrdEffMY);
					pstmtTmp.setString(11, strUPAuthCode);
					pstmtTmp.setString(12, strUDispatch);
					pstmtTmp.setString(13, strUPCHKM1);
					pstmtTmp.setString(14, strUPCHKM2);
					pstmtTmp.setString(15, strPSrcCode);
					pstmtTmp.setInt(16, iUpdDate);
					pstmtTmp.setInt(17, iUpdTime);
					pstmtTmp.setString(18, strLogonUser);
					pstmtTmp.setInt(19, iPAuthDt);
					pstmtTmp.setString(20, strCurrency);
					if (!strPMethod.equals("D")) {
						pstmtTmp.setString(21, strPOrgCrdNo);
						pstmtTmp.setDouble(22, iPOrgAMT);
						pstmtTmp.setDouble(23, iPAYAMTNT);
						pstmtTmp.setString(24, strPNO);
					} else {
						pstmtTmp.setString(21, strPFEEWAY);
						pstmtTmp.setString(22, strPSWIFT);
						pstmtTmp.setString(23, strPBKCOTRY);
						pstmtTmp.setString(24, strPBKCITY);
						pstmtTmp.setString(25, strPBKBRCH);
						pstmtTmp.setString(26, strPENGNAME);
						pstmtTmp.setString(27, strPOrgCrdNo);
						pstmtTmp.setDouble(28, iPOrgAMT);
						pstmtTmp.setDouble(29, iPAYAMTNT);
						pstmtTmp.setString(30, strPNO);
					}
					if (pstmtTmp.executeUpdate() != 1) {
						if (isAEGON400) {
							con.rollback();
						}
						strReturnMsg = "�ק異��";
					} else {
						request.setAttribute("txtMsg", "�ק令�\");
						request.setAttribute("isErr", "");

						//RA0064 ��s ORGNPCNF(�T�w���I�Ȧs��)
						disbBean.callCAPDISB09(con, strPNO, String.valueOf(iUpdDate));
					}
					pstmtTmp.close();
				}
				if (!strReturnMsg.equals("")) {
					if (isAEGON400) {
						con.rollback();
					}
					request.setAttribute("txtMsg", strReturnMsg);
					request.setAttribute("isErr", "Y");
				} else {
					strReturnMsg = inquiryDB(request, response);
					if (!strReturnMsg.equals("")) {
						request.setAttribute("txtMsg", strReturnMsg);
						request.setAttribute("isErr", "Y");
					}
				}
			} catch (SQLException e) {
				request.setAttribute("isErr", "Y");
				request.setAttribute("txtMsg", "�ק異��" + e);
				if (con != null)
					dbFactory.releaseAS400Connection(con);
			} finally {
				try {
					if (pstmtTmp != null)
						pstmtTmp.close();
					if (con != null) {
						dbFactory.releaseAS400Connection(con);
					}
				} catch (Exception ex1) {
				}
			}
		}
		request.setAttribute("txtAction", "U");
		dispatcher = request
				.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	/**
	 * R60550
	 * 
	 * @param request
	 * @param response
	 */
	private void inquiryD(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = null;
		String strReturnMsg = "";
		strReturnMsg = inquiryDB(request, response);
		request.setAttribute("txtMsg", strReturnMsg);

		request.setAttribute("txtAction", "I");
		dispatcher = request
				.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	/**
	 * @param request
	 * @param response
	 */
	private String inquiryDB(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);

		Connection con = dbFactory
				.getAS400Connection("DISBPMaintainServlet.inquiryDB()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* �����e�����w�q */
		String strPNo = ""; // �I�ڤ��

		strPNo = (String) request.getAttribute("txtPNo");
		if (strPNo != null)
			strPNo = strPNo.trim();
		else
			strPNo = "";

		if (strPNo.equals("")) {
			strPNo = request.getParameter("txtUPNO");
			if (strPNo != null)
				strPNo = strPNo.trim();
			else
				strPNo = "";
		}

		strSql = "select A.ENTRYDT,A.PAMT,A.PCFMDT1,A.PCFMTM1,A.PCFMDT2,A.PCFMTM2,A.PDATE,A.UPDDT,A.UPDTM,A.APPNO,A.POLICYNO,A.ENTRYUSR,A.PAUTHCODE,A.PBACCOUNT,A.PBBANK,A.PCFMUSR1,A.PCFMUSR2,A.PCHECKNO,A.PCRDEFFMY,A.PCRDNO,A.PCRDTYPE,A.PDESC,A.PDISPATCH,A.PID,A.PMETHOD,A.PNAME,A.PNO,A.PNOH,A.PRACCOUNT,A.PRBANK,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.BRANCH,MEMO,A.PCHKM1,A.PCHKM2,A.PAUTHCODE,A.PAUTHDT,C.FLD0004 AS PSRCGPDESC,A.PCURR ";
		strSql += " ,A.PPAYCURR,A.PPAYAMT,A.PPAYRATE,A.PFEEWAY,A.PSYMBOL,A.PINVDT,A.PSWIFT,A.PBKCOTRY,A.PBKCITY,A.PBKBRCH,A.PENGNAME,S.BANK_NAME AS SWBKNAME,R.FPAYAMT AS FPAYAMT,R.FFEEWAY AS FFEEWAY";// R60550
		strSql += " ,A.PORGAMT, A.PORGCRDNO,A.PMETHODO,A.PAMTNT";
		strSql += " from CAPPAYF A ";

		strSql += " left outer join ORDUET C on C.FLD0001='  ' AND C.FLD0002='SRCGP' AND C.FLD0003 = A.PAY_SOURCE_GROUP ";
		strSql += " left outer join ORCHSWFT S ON A.PSWIFT = S.SWIFT_CODE";// R60550
		strSql += " left outer join CAPRFEF R ON A.PNO = R.FPNO";// R60550

		strSql += " WHERE A.PNO='" + strPNo + "'";

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			if (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrMemo("MEMO");// �Ƶ�
				objPDetailVO.setIEntryDt(rs.getInt("ENTRYDT")); // ��J���
				objPDetailVO.setIPAMT(rs.getDouble("PAMT")); // ��I���B
				objPDetailVO.setIPCfmDt1(rs.getInt("PCFMDT1"));// ��I�T�{��@
				objPDetailVO.setIPCfmTm1(rs.getInt("PCFMTM1"));// ��I�T�{�ɤ@
				objPDetailVO.setIPCfmDt2(rs.getInt("PCFMDT2"));// ��I�T�{��G
				objPDetailVO.setIPCfmTm2(rs.getInt("PCFMTM2"));// ��I�T�{�ɤG
				objPDetailVO.setIPDate(rs.getInt("PDATE")); // �I�ڤ��
				objPDetailVO.setIUpdDt(rs.getInt("UPDDT")); // ���ʤ��
				objPDetailVO.setIUpdTm(rs.getInt("UPDTM")); // ���ʮɶ�
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
				objPDetailVO.setStrPChkm1(rs.getString("PCHKM1")); // �䲼�T�I
				objPDetailVO.setStrPChkm2(rs.getString("PCHKM2")); // �䲼���u
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));// �O����ݳ��
				objPDetailVO.setIPAuthDt(rs.getInt("PAUTHDT"));// ���v�����

				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));// �@�o�_
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
				objPDetailVO.setStrPCurr(rs.getString("PCurr"));// ���_
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
				objPDetailVO.setFFEEWAY(rs.getString("FFEEWAY"));// �װh����O
				// R80300 2�����
				objPDetailVO.setStrPOrgCrdNo(rs.getString("PORGCRDNO"));// ���d��
				objPDetailVO.setIPOrgAMT(rs.getDouble("PORGAMT"));// ���d��
				objPDetailVO.setStrPMETHODO(rs.getString("PMETHODO"));// R80631��l�I�ڤ覡
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));	//R10314��I���B�x���Ѧҭ�

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