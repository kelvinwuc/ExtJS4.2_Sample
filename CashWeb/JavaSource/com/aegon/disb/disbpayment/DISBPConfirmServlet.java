package com.aegon.disb.disbpayment;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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

/**
 * System   :
 * 
 * Function : ��I�T�{
 * 
 * Remark   : ��I�\��
 * 
 * Revision : $$Revision: 1.16 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID  : R30530
 * 
 * CVS History :
 * 
 * $$Log: DISBPConfirmServlet.java,v $
 * $Revision 1.16  2013/12/18 07:22:52  MISSALLY
 * $RB0302---�s�W�I�ڤ覡�{��
 * $
 * $Revision 1.15  2013/05/30 02:03:54  MISSALLY
 * $RA0064-CMP�M��CASH�t�X�ק�
 * $
 * $Revision 1.14  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE�����ͦs�����q�H�b��ε��I
 * $
 * $Revision 1.12  2013/01/08 04:24:05  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.10.4.1  2012/12/06 06:28:29  MISSALLY
 * $RA0102�@PA0041
 * $�t�X�k�O�ק�S����I�@�~
 * $
 * $Revision 1.10  2011/05/12 06:20:19  MISJIMMY
 * $R00440 SN������
 * $
 * $Revision 1.9  2010/11/23 06:45:20  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.8  2009/08/31 01:59:32  missteven
 * $R90380 �s�WCASH����ζǲ��\��
 * $
 * $Revision 1.7  2009/04/01 08:19:55  missteven
 * $R90274_��I�T�{�L�ݿ�ܨӷ��s�աA�Y�i�a�XFF��I����
 * $
 * $Revision 1.6  2007/09/07 10:20:26  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.5  2007/04/13 09:43:15  MISVANESSA
 * $R70292_�t���䲼��W�h����
 * $
 * $Revision 1.4  2007/03/06 01:40:49  MISVANESSA
 * $R70088_SPUL�t���䲼��ݦP��״�,��I�ڤ�~��T�{
 * $
 * $Revision 1.3  2007/01/04 03:12:43  MISVANESSA
 * $R60550_�s�WSHOW�~�����O.���B
 * $
 * $Revision 1.2  2006/12/07 10:11:39  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.1  2006/06/29 09:40:15  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.15  2006/04/27 09:16:11  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.14  2005/08/02 02:31:58  misangel
 * $Q50285: 
 * $�I�ڤ���W�h:
 * $1.���:�Y��l�I�ڤ���p��I�ڤ��(�Ѽ�),�h�H�I�ڤ�� = �I�ڤ��(�Ѽ�)
 * $2.�D���:�Y��l�I�ڤ���p���J����(�Ѽ�),�h�H�I�ڤ�� = ��J����(�Ѽ�)
 * $
 * $Revision 1.1.2.12  2005/04/28 08:56:25  miselsa
 * $R30530������ժ��ק�
 * $
 * $Revision 1.1.2.11  2005/04/25 07:27:49  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.10  2005/04/04 07:02:24  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */
 
public class DISBPConfirmServlet extends HttpServlet {

	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private DISBBean disbBean = null;
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
		// R00393
		commonUtil = new CommonUtil(globalEnviron);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String strAction = request.getParameter("txtAction");

		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		try {
			if (strAction.equals("I"))
				inquiryDB(request, response);
			else if (strAction.equals("DISBPaymentConfirm"))
				updatePayments(request, response);
			else if (strAction.equals("CSC"))
				inquiryCSCDB(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} catch (Exception e) {
			System.err.println("DISBPConfirmServlet Application Exception >>> " + e);
		}

	}

	public List maintainPList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		int iSize = 0;

		String strIsChecked = "";
		boolean bIsChecked = false;
		DISBPaymentDetailVO objPaymentDetailVO = null;
		List alCheckPnoList = new ArrayList();
		List alPDetail = (List) session.getAttribute("PDetailListTemp");

		if (alPDetail != null)
			iSize = alPDetail.size();

		for (int i = 0; i < iSize; i++) {
			strIsChecked = request.getParameter("ch" + i);
			if ("Y".equalsIgnoreCase(strIsChecked)) {
				bIsChecked = true;
				((DISBPaymentDetailVO) alPDetail.get(i)).setChecked(bIsChecked);
				objPaymentDetailVO = new DISBPaymentDetailVO();
				objPaymentDetailVO.setStrPNO(((DISBPaymentDetailVO) alPDetail.get(i)).getStrPNO());
				objPaymentDetailVO.setIPDate(((DISBPaymentDetailVO) alPDetail.get(i)).getIPDate());
				objPaymentDetailVO.setStrPDispatch(((DISBPaymentDetailVO) alPDetail.get(i)).getStrPDispatch());
				alCheckPnoList.add(objPaymentDetailVO);
			}
		}
		session.removeAttribute("PDetailList");
		session.setAttribute("PDetailList", alPDetail);

		return alCheckPnoList;
	} // end of maintainPList method....

	private void updatePayments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("@@@@@ updatePConfirmed");
		HttpSession session = request.getSession(true);
		session.removeAttribute("PDetailList");
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();

		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory.getAS400Connection("DISBPMaintainServlet.updatePayments()");
		PreparedStatement pstmtTmp = null;
		String strReturnMsg = "";

		String strSql = ""; // SQL String
		List alCheckPnoList = new ArrayList();
		alCheckPnoList = (List) maintainPList(request, response);

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));
		disbBean = new DISBBean(dbFactory);

		/* �����e�����w�q */
		int intEntryPDate = 0; // �e�ݿ�J:�I�ڤ�
		int intEntryEEDate = 0; // �e�ݿ�J:��J����

		intEntryPDate = Integer.parseInt((String) request.getParameter("txtPDateHold"));
		intEntryEEDate = Integer.parseInt((String) request.getParameter("txtEEDateHold"));

		try {
			if (alCheckPnoList != null) {
				if (alCheckPnoList.size() > 0) {

					for (int i = 0; i < alCheckPnoList.size(); i++) {
						DISBPaymentDetailVO objPaymentDetailVO = (DISBPaymentDetailVO) alCheckPnoList.get(i);
						String strPNO = ""; // ��I�Ǹ�
						strPNO = objPaymentDetailVO.getStrPNO();
						if (strPNO != null)
							strPNO = strPNO.trim();
						else
							strPNO = "";
						/*
						 * �I�ڤ���W�h: 
						 * 1.���     :�Y��l�I�ڤ���p��I�ڤ��(�Ѽ�),�h�H�I�ڤ�� = �I�ڤ��(�Ѽ�)
						 * 2.�D���:�Y��l�I�ڤ���p���J����(�Ѽ�),�h�H�I�ڤ�� = ��J����(�Ѽ�)
						 */
						int intPdate = 0; // �I�ڤ��
						intPdate = objPaymentDetailVO.getIPDate();
						String strPDispatch = objPaymentDetailVO.getStrPDispatch(); // ���_
						if (strPDispatch.equals("Y")) {
							if (intPdate < intEntryPDate) {
								intPdate = intEntryPDate;
							}
						} else {
							if (intPdate < intEntryEEDate) {
								intPdate = intEntryEEDate;
							}
						}

						strSql = " update CAPPAYF set PDATE = ?, PCFMDT2 = ?, PCFMTM2 = ?, PCFMUSR2=?, ";
						strSql += "UPDDT= ?, UPDTM = ?, UPDUSR =?  where PNO =? ";

						// �Ulog
						strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
						if (strReturnMsg.equals("")) {
							pstmtTmp = con.prepareStatement(strSql);
							pstmtTmp.setInt(1, intPdate);
							pstmtTmp.setInt(2, iUpdDate);
							pstmtTmp.setInt(3, iUpdTime);
							pstmtTmp.setString(4, strLogonUser);
							pstmtTmp.setInt(5, iUpdDate);
							pstmtTmp.setInt(6, iUpdTime);
							pstmtTmp.setString(7, strLogonUser);
							pstmtTmp.setString(8, strPNO);

							if (pstmtTmp.executeUpdate() != 1) {
								strReturnMsg = "�T�{����";
							} else {
								request.setAttribute("txtMsg", "�T�{���\");

								//RA0064 ��s ORGNPCNF(�T�w���I�Ȧs��)
								disbBean.callCAPDISB09(con, strPNO, String.valueOf(iUpdDate));
							}
							pstmtTmp.close();
						}
						if (!strReturnMsg.equals("")) {
							request.setAttribute("txtMsg", strReturnMsg);
							if (isAEGON400) {
								con.rollback();
							}
						}
					}
				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�T�{����-->" + e);
		} finally {
			try {
				if (pstmtTmp != null)
					pstmtTmp.close();
				if (con != null)
					dbFactory.releaseAS400Connection(con);
			} catch (Exception ex1) {
			}
		}

		request.setAttribute("txtAction", "DISBPaymentConfirm");
		if ("Y".equals(request.getParameter("FNP") != null ? request.getParameter("FNP") : ""))
			dispatcher = request.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentConfirmT2.jsp");
		else
			dispatcher = request.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentConfirm.jsp");

		dispatcher.forward(request, response);
		return;
	}

	private void inquiryDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("DISBPConfirmServlet.inquiryDB");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Connection con = dbFactory.getAS400Connection("DISBPConfirmServlet.inquiryDB()");
		Statement stmt = null;
		ResultSet rs = null;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);// R70292
		String strSql = ""; // SQL String
		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* �����e�����w�q */
		String strPDate = ""; // �I�ڤ��
		String strEntryStartDate = ""; // ��J����_��
		String strEntryEndDate = ""; // ��J�������
		String strDispatch = ""; // ���_
		String strPSrcGp = ""; // �ӷ��s�եN�X
		String strDept = ""; // ����
		String strEntryUsr = ""; // ��J��
		String strCurrency = ""; // ���O
		String strPMETHOD = ""; // �I�ڤ覡R60550
		int iNextDT = 0; // �U�@�ӥI�ڤ�R70292

		strPDate = request.getParameter("txtPDate");
		if (strPDate != null) {
			strPDate = strPDate.trim();
			iNextDT = disbBean.GetNextWorkDay(strPDate);// R70292
		} else
			strPDate = "";

		strEntryStartDate = request.getParameter("txtEntryStartDate");
		if (strEntryStartDate != null)
			strEntryStartDate = strEntryStartDate.trim();
		else
			strEntryStartDate = "";

		strEntryEndDate = request.getParameter("txtEntryEndDate");
		if (strEntryEndDate != null)
			strEntryEndDate = strEntryEndDate.trim();
		else
			strEntryEndDate = "";

		strDispatch = request.getParameter("selDispatch");
		if (strDispatch != null)
			strDispatch = strDispatch.trim();
		else
			strDispatch = "";

		strPSrcGp = request.getParameter("selPSrcGp");
		if (strPSrcGp != null)
			strPSrcGp = strPSrcGp.trim();
		else
			strPSrcGp = "";

		strDept = request.getParameter("selDEPT");
		if (strDept != null)
			strDept = strDept.trim();
		else
			strDept = "";

		strEntryUsr = request.getParameter("txtEntryUsr");
		if (strEntryUsr != null)
			strEntryUsr = strEntryUsr.trim();
		else
			strEntryUsr = "";

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";
		// R60550
		strPMETHOD = request.getParameter("selPMETHOD");
		if (strPMETHOD != null)
			strPMETHOD = strPMETHOD.trim();
		else
			strPMETHOD = "";

		strSql = "select A.ENTRYDT,A.PAMT,A.PCFMDT1,A.PCFMTM1,A.PCFMDT2,A.PCFMTM2,A.PDATE,A.UPDDT,A.UPDTM,A.APPNO,A.POLICYNO,A.ENTRYUSR,A.PAUTHCODE,A.PBACCOUNT,A.PBBANK,A.PCFMUSR1,A.PCFMUSR2,A.PCHECKNO,A.PCRDEFFMY,A.PCRDNO,A.PCRDTYPE,A.PDESC,A.PDISPATCH,A.PID,A.PMETHOD,A.PNAME,A.PNO,A.PNOH,A.PRACCOUNT,A.PRBANK,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.BRANCH,B.DEPT,A.PCURR";
		strSql += ",A.PPAYCURR,A.PPAYAMT ";// R60550
		strSql += "from CAPPAYF A ";
		strSql += "left outer join USER B  on B.USRID=A.ENTRYUSR   ";
		strSql += "WHERE A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  ";
		strSql += "and A.PCFMDT2=0 AND A.PCFMTM2=0 AND A.PCFMUSR2 =''   ";
		strSql += "AND A.PSTATUS=''  AND A.PVOIDABLE<>'Y' and A.PAMT>0  ";

		/*
		 * �ק���o��I����(��CAPSIL���I���) 
		 * 1.�pPMETHOD IN('A','C') -->��J����n�ŦX�e�ݩҿ餧��J���
		 *   �pPMETHOD ='B' -->�I�ڤ���n�ŦX�e�ݩҿ餧�I�ڤ�� R70088 SPUL�t���䲼��ݦP��״�,��I�ڤ�~��T�{
		 *   R70292 �䲼��n�H�U�@�u�@�鬰������� 
		 * 2.���B > 0
		 */

		if (strPSrcGp.equals("CP") || strPSrcGp.equals("")) {
			if (!strPDate.equals("")) {
				if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
					strSql += " and ((A.PMETHOD IN ('B','D')  and A.PDATE <= " + strPDate;// R60550
					strSql += "   and A.ENTRYDT <= " + strEntryEndDate + " ) ";
					strSql += "     or (A.PMETHOD IN('A','C','E') and A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate + " AND A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN������
					strSql += "     or (A.PMETHOD IN('A','C') AND A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT;// R00440 SN������
					strSql += "       and A.ENTRYDT <= " + strEntryEndDate + " ))";
				} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
					strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ")  ";// R60550
					strSql += "  or (A.PMETHOD IN ('A','C','E') and A.ENTRYDT >= " + strEntryStartDate + " and A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN������
					strSql += "  or (A.PMETHOD IN ('A','C') and A.PDATE <= " + iNextDT + " and A.PSRCCODE IN ('B8','B9','BB')) ) ";// R00440 SN������
				} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
					strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN ('A','C') and A.PSRCCODE NOT IN ('B8','B9','BB'))";// /R00440 SN������
					strSql += " or (A.PMETHOD IN ('A','C','E') and A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT + "))";// /R00440 SN������
					strSql += "   and A.ENTRYDT <= " + strEntryEndDate;
				} else {
					strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN('A','C','E') and A.PSRCCODE NOT IN ('BB','B8','B9'))";// R00440 SN������
					strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT + "))";// R00440 SN������
				}
			} else {
				if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
					strSql += " and  A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate;
				} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
					strSql += " and A.ENTRYDT >= " + strEntryStartDate;
				} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
					strSql += " and  A.ENTRYDT <= " + strEntryEndDate;
				}
			}
		} else {
			// �D capsil��
			if (!strPDate.equals("")) {
				strSql += " and A.PDATE <= " + strPDate;
			}
			if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and  A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate;
			} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
				strSql += " and A.ENTRYDT >= " + strEntryStartDate;
			} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and  A.ENTRYDT <= " + strEntryEndDate;
			}
		}

		if (strDispatch.equals("Y")) {
			strSql += "  and A.PDISPATCH= '" + strDispatch + "' ";
		} else if (strDispatch.equals("N")) {
			strSql += "  and A.PDISPATCH='' ";
		}

		if (!strPSrcGp.equals("")) {
			strSql += "  and A.PSRCGP= '" + strPSrcGp + "' ";
		}

		if (!strDept.equals("")) {
			strSql += "  and B.DEPT = '" + strDept + "' ";
		}

		if (!strEntryUsr.equals("")) {
			strSql += "  and A.ENTRYUSR = '" + strEntryUsr + "' ";
		}
		if (!strCurrency.equals("")) {
			strSql += " and A.PCURR = '" + strCurrency + "'";
		} else {
			strSql += " and A.PCURR in ('NT','US')";
		}
		// R60550
		if (!strPMETHOD.equals("")) {
			strSql += " and A.PMETHOD = '" + strPMETHOD + "'";
		}

		// �̳��� ��J�̤ΫO�渹�X�Ƨ�
		strSql += " order by B.DEPT,A.ENTRYUSR,A.POLICYNO ";

		System.out.println("DISBPConfirmServlet.inquiryDB()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
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
				objPDetailVO.setStrPDesc(rs.getString("PDESC")); // ��I�y�z
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));// ���_
				objPDetailVO.setStrPId(rs.getString("PID")); // ���ڤHID
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));// �I�ڤ覡
				objPDetailVO.setStrPName(rs.getString("PNAME"));// ���ڤH�m�W
				objPDetailVO.setStrPNO(rs.getString("PNO")); // ��I�Ǹ�
				objPDetailVO.setStrPNoH(rs.getString("PNOH")); // ���I�Ǹ�
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));// �״ڱb��
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));// �״ڻȦ�
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));// �ӷ��ոs
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE"));// ��I��]�N�X
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS"));// �I�ڪ��A
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));// �O����ݳ��
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
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));// ���O
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));// R60550�~�����O
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));// R60550�~�����B

				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "�d�L�������");
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
		request.setAttribute("txtPDateHold", strPDate);
		request.setAttribute("txtEEDateHold", strEntryEndDate);

		if ("Y".equals(request.getParameter("FNP") != null ? request.getParameter("FNP") : ""))
			dispatcher = request.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentConfirmT2.jsp");
		else
			dispatcher = request.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentConfirm.jsp");

		dispatcher.forward(request, response);
	}

	// R90380
	private void inquiryCSCDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		session.removeAttribute("PDetailList");
		RequestDispatcher dispatcher = null;

		System.out.println("DISBPConfirmServlet.inquiryCSCDB");
		Connection con = dbFactory.getAS400Connection("DISBPConfirmServlet.inquiryCSCDB()");
		Statement stmt = null;
		ResultSet rs = null;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);// R70292
		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* �����e�����w�q */
		String strPDate = ""; // �I�ڤ��
		String strEntryStartDate = ""; // ��J����_��
		String strEntryEndDate = ""; // ��J�������
		String strDispatch = ""; // ���_
		String strDept = ""; // ����
		String strEntryUsr = ""; // ��J��
		String strCurrency = ""; // ���O
		String strPMETHOD = ""; // �I�ڤ覡R60550
		int iNextDT = 0; // �U�@�ӥI�ڤ�R70292

		strPDate = request.getParameter("txtPDate");
		if (strPDate != null) {
			strPDate = strPDate.trim();
			iNextDT = disbBean.GetNextWorkDay(strPDate);// R70292
		} else
			strPDate = "";
		strEntryStartDate = request.getParameter("txtEntryStartDate") != null ? request.getParameter("txtEntryStartDate").trim() : "";
		strEntryEndDate = request.getParameter("txtEntryEndDate") != null ? request.getParameter("txtEntryEndDate").trim() : "";
		strDispatch = request.getParameter("selDispatch") != null ? request.getParameter("selDispatch").trim() : "";
		// strDept = request.getParameter("selDEPT")!=null?request.getParameter("selDEPT").trim():"";
		strEntryUsr = request.getParameter("txtEntryUsr") != null ? request.getParameter("txtEntryUsr").trim() : "";
		strCurrency = request.getParameter("selCurrency") != null ? request.getParameter("selCurrency").trim() : "";
		strPMETHOD = request.getParameter("selPMETHOD") != null ? request.getParameter("selPMETHOD").trim() : "";

		String strSql = "select count(A.PNO) as ROWCOUNT,sum(A.PAMT) as PAMT,A.ENTRYUSR "
				+ "from CAPPAYF A "
				+ "left outer join USER B  on B.USRID=A.ENTRYUSR  "
				+ "WHERE A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  "
				+ "and A.PCFMDT2=0 AND A.PCFMTM2=0 AND A.PCFMUSR2 =''  "
				+ "AND A.PSTATUS=''  AND A.PVOIDABLE<>'Y' and A.PAMT>0 ";

		if (!strPDate.equals("")) {
			if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and ((A.PMETHOD IN ('B','D')  and A.PDATE <= " + strPDate;
				strSql += "   and A.ENTRYDT <= " + strEntryEndDate + " ) ";
				// R00440 SN������ strSql += "   or  (A.PMETHOD IN('A','C') and A.ENTRYDT between "+ strEntryStartDate+ "  and "+ strEntryEndDate + AND A.PSRCCODE NOT IN ('B8','B9'))";
				strSql += "   or  (A.PMETHOD IN('A','C','E') and A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate + " AND A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN������
				// R00440 SN������ strSql += " or (A.PMETHOD IN('A','C') AND A.PSRCCODE IN ('B8','B9') and A.PDATE <= " + iNextDT;
				strSql += " or (A.PMETHOD IN('A','C') AND A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT;// R00440 SN������
				strSql += " and A.ENTRYDT <= " + strEntryEndDate + " ))";
			} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
				strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ")  ";
				// R00440 SN������strSql += "  or (A.PMETHOD IN ('A','C') and A.ENTRYDT >= " + strEntryStartDate + " and A.PSRCCODE NOT IN ('B8','B9'))";
				strSql += "  or (A.PMETHOD IN ('A','C','E') and A.ENTRYDT >= " + strEntryStartDate + " and A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN������
				// R00440 SN������ strSql += "  or (A.PMETHOD IN ('A','C') and A.PDATE <= " + iNextDT + " and A.PSRCCODE IN ('B8','B9')) ) ";
				strSql += "  or (A.PMETHOD IN ('A','C') and A.PDATE <= " + iNextDT + " and A.PSRCCODE IN ('B8','B9','BB')) ) ";
			} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				// R00440 SN������strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN ('A','C') and A.PSRCCODE NOT IN ('B8','B9'))";
				strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN ('A','C','E') and A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN������
				// R00440 SN������ strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9') and A.PDATE <= " + iNextDT + "))";
				strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT + "))";// R00440 SN������
				strSql += "   and A.ENTRYDT <= " + strEntryEndDate;
			} else {
				// R00440 SN������ strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN('A','C') and A.PSRCCODE NOT IN ('B8','B9'))";
				strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN('A','C','E') and A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN������
				// R00440 SN������ strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9') and A.PDATE <= " + iNextDT + "))";
				strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT + "))";// R00440 SN������
			}
		} else {
			if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and  A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate;
			} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
				strSql += " and A.ENTRYDT >= " + strEntryStartDate;
			} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and  A.ENTRYDT <= " + strEntryEndDate;
			} else {
				// �D capsil��
				if (!strPDate.equals("")) {
					strSql += " and A.PDATE <= " + strPDate;
				}
				if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
					strSql += " and  A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate;
				} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
					strSql += " and A.ENTRYDT >= " + strEntryStartDate;
				} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
					strSql += " and  A.ENTRYDT <= " + strEntryEndDate;
				}
			}
		}

		if (strDispatch.equals("Y")) {
			strSql += "  and A.PDISPATCH= '" + strDispatch + "' ";
		} else if (strDispatch.equals("N")) {
			strSql += "  and A.PDISPATCH='' ";
		}

		// if (!strDept.equals("")) {
		// strSql += "  and B.DEPT = '" + strDept + "' ";
		// }

		strSql += "  and B.DEPT = 'CSC' ";

		if (!strEntryUsr.equals("")) {
			strSql += "  and A.ENTRYUSR = '" + strEntryUsr + "' ";
		}

		if (!strCurrency.equals("")) {
			strSql += " and A.PCURR = '" + strCurrency + "'";
		} else {
			strSql += " and A.PCURR in ('NT','US')";
		}

		// R60550
		if (!strPMETHOD.equals("")) {
			strSql += " and A.PMETHOD = '" + strPMETHOD + "'";
		}

		// �̳��� ��J�̤ΫO�渹�X�Ƨ�
		strSql += "group by A.ENTRYUSR order by A.ENTRYUSR ";

		System.out.println(" inside DISBPConfirmServlet.inquiryCSCDB()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setRowCount(rs.getInt("ROWCOUNT"));// �`����
				objPDetailVO.setTPAMT(rs.getBigDecimal("PAMT")); // �`��I���B
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));// ��J�H��
				objPDetailVO.setEntryStartDate(strEntryStartDate);// ��J�_��
				objPDetailVO.setEntryEndDate(strEntryEndDate);// ��J����
				objPDetailVO.setStrPDate(strPDate);// �I�ڤ��
				objPDetailVO.setSelPSrcGp("");// �ӷ��s��
				objPDetailVO.setStrDispatch(strDispatch);// ���
				objPDetailVO.setStrDept(strDept);// ����
				objPDetailVO.setStrPMETHOD(strPMETHOD);// �I�ڤ覡
				objPDetailVO.setStrCurrency(strCurrency);// �O����O
				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				// session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "�d�L�������");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			alPDetail = null;
		} finally {
			try {
				if (con != null)
					dbFactory.releaseAS400Connection(con);
			} catch (Exception ex1) {
			}
		}
		request.setAttribute("txtAction", "Q");
		request.setAttribute("txtPDateHold", strPDate);
		request.setAttribute("txtEEDateHold", strEntryEndDate);
		dispatcher = request.getRequestDispatcher("/DISB/DISBPayment/DISBPaymentConfirmT.jsp");
		dispatcher.forward(request, response);
	}
}
