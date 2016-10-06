package com.aegon.disb.disbpsource;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.11 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBSConfirmServlet.java,v $
 * $Revision 1.11  2014/07/18 07:13:34  misariel
 * $EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 * $
 * $Revision 1.10  2013/12/24 03:04:02  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.9  2011/10/21 10:04:36  MISSALLY
 * $R10260---�~���ǲΫ��O��ͦs�����I�@�~
 * $
 * $Revision 1.8  2011/05/12 06:17:20  MISJIMMY
 * $R00440 SN������
 * $
 * $Revision 1.7  2010/11/23 06:46:23  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.6  2008/08/12 06:57:28  misvanessa
 * $R80480_�W���Ȧ�~�������s�ɮ�
 * $
 * $Revision 1.5  2008/08/06 05:56:04  MISODIN
 * $R80132 �վ�CASH�t��for 6�ع��O
 * $
 * $Revision 1.4  2008/04/30 07:48:09  misvanessa
 * $R80300_�������x�s,�s�W�U���ɮפγ���
 * $
 * $Revision 1.3  2007/09/07 10:21:05  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.2  2007/01/31 03:57:21  MISVANESSA
 * $R70088_SPUL�t��
 * $
 * $Revision 1.1  2006/06/29 09:40:51  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.16  2006/04/27 09:13:57  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.15  2005/08/23 08:51:43  misangel
 * $*** empty log message ***
 * $
 * $Revision 1.1.2.13  2005/04/28 08:56:26  miselsa
 * $R30530������ժ��ק�
 * $
 * $Revision 1.1.2.12  2005/04/25 07:23:52  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.11  2005/04/12 03:13:38  miselsa
 * $R30530_�ק�����ݳ�����ƪ�JOIN SQL
 * $
 * $Revision 1.1.2.10  2005/04/04 07:02:21  miselsa
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
import org.apache.log4j.Logger;

public class DISBSConfirmServlet extends HttpServlet {
	
	private Logger log = Logger.getLogger(getClass());

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
		String strAction = "";
		strAction = request.getParameter("txtAction");
		// System.out.println("~~~~strAction=" + strAction);
		strAction = (strAction != null) ? CommonUtil.AllTrim(strAction) : "" ;

		try {
			if (strAction.equals("I"))
				inquiryDB(request, response);
			else if (strAction.equals("DISBPSourceConfirm"))
				updatePayments(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} catch (Exception e) {
			System.err.println("Application Exception >>> " + e);
		}
	}

	public List maintainPList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		int iSize = 0;

		String strIsChecked = "";
		boolean bIsChecked = false;
		List alCheckPnoList = new ArrayList();
		List alPDetail = (List) session.getAttribute("PDetailListTemp");

		if (alPDetail != null)
			iSize = alPDetail.size();

		for (int i = 0; i < iSize; i++) {
			strIsChecked = request.getParameter("ch" + i);
			if ("Y".equalsIgnoreCase(strIsChecked)) {
				bIsChecked = true;
				((DISBPaymentDetailVO) alPDetail.get(i)).setChecked(bIsChecked);
				String checkPno = (String) ((DISBPaymentDetailVO) alPDetail.get(i)).getStrPNO();
				alCheckPnoList.add(checkPno);
			}
		} // end of for loop........
		session.removeAttribute("PDetailList");
		session.setAttribute("PDetailList", alPDetail);
		// return alPDetail;
		return alCheckPnoList;
	} // end of maintainPList method....

	private void updatePayments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("@@@@@inside updatePayments");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory.getAS400Connection("DISBSConfirmServlet.updatePayments()");
		PreparedStatement pstmtTmp = null;
		String strReturnMsg = "";

		String strSql = ""; // SQL String
		List alCheckPnoList = new ArrayList();
		alCheckPnoList = (List) maintainPList(request, response);

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		try {
			if (alCheckPnoList != null) {
				if (alCheckPnoList.size() > 0) {

					for (int i = 0; i < alCheckPnoList.size(); i++) {
						String strPNO = ""; // ��I�Ǹ�
						strPNO = (String) alCheckPnoList.get(i);
						strPNO = (strPNO != null) ? CommonUtil.AllTrim(strPNO) : "";

						strSql = " update CAPPAYF  set PCFMDT1 = ?, PCFMTM1 = ?, PCFMUSR1=? ";
						strSql += ", UPDDT = ?, UPDTM = ?, UPDUSR = ?  where PNO = ? ";

						// �Ulog
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

							if (pstmtTmp.executeUpdate() != 1) {
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
						}
					}

				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�T�{����-->" + e);
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		} finally {
			session.removeAttribute("PDetailList");
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}

		request.setAttribute("txtAction", "DISBPSourceConfirm");
		dispatcher = request.getRequestDispatcher("/DISB/DISBPSource/DISBPSourceConfirm.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private void inquiryDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		String strUserDept = (String) session.getAttribute(Constant.LOGON_USER_DEPT);
		String strUserRight = (String) session.getAttribute(Constant.LOGON_USER_RIGHT);
		String strUserBrch = (String) session.getAttribute(Constant.LOGON_USER_BRCH);
		//System.out.println("~~~strLogonUser=" + strLogonUser);

		Connection con = dbFactory.getAS400Connection("DISBSConfirmServlet.inqueryDB()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* �����e�����w�q */
		String strPDate = ""; // �I�ڤ��
		String strEntryStartDate = ""; // ��J����_��
		String strEntryEndDate = ""; // ��J�������
		String strDispatch = ""; // ���_
		String strPSrcCode = ""; // ��I��]�N�X
		String strCurrency = "";// ���O
		String strEntryUser = "";	//��J�̥N��

		if (request.getParameter("txtParent") != null && request.getParameter("txtParent").equals("DISBPSourceConfirm")) {// �ѳ浧���Ӻ��@�Ө�
			// System.out.println("�ѳ浧���Ӻ��@�Ө�");
			strPDate = (String) session.getAttribute("strPDate");
			strPDate = (strPDate != null) ? CommonUtil.AllTrim(strPDate) : "" ;

			strEntryStartDate = (String) session.getAttribute("strEntryStartDate");
			strEntryStartDate = (strEntryStartDate != null) ? CommonUtil.AllTrim(strEntryStartDate) : "" ;

			strEntryEndDate = (String) session.getAttribute("strEntryEndDate");
			strEntryEndDate = (strEntryEndDate != null) ? CommonUtil.AllTrim(strEntryEndDate) : "" ;

			strDispatch = (String) session.getAttribute("selDispatch");
			strDispatch = (strDispatch != null) ? CommonUtil.AllTrim(strDispatch) : "" ;

			strPSrcCode = (String) session.getAttribute("selPSrcCode");
			strPSrcCode = (strPSrcCode != null) ? CommonUtil.AllTrim(strPSrcCode) : "" ;

			strCurrency = (String) session.getAttribute("selCurrency");
			strCurrency = (strCurrency != null) ? CommonUtil.AllTrim(strCurrency) : "" ;

			strEntryUser = (String) session.getAttribute("strEntryUser");
			strEntryUser = (strEntryUser != null) ? CommonUtil.AllTrim(strEntryUser).toUpperCase() : "" ;
		} else {
			// System.out.println("���T�{");
			session.removeAttribute("strPDate");
			session.removeAttribute("strEntryStartDate");
			session.removeAttribute("strEntryEndDate");
			session.removeAttribute("selDispatch");
			session.removeAttribute("selPSrcCode");
			session.removeAttribute("selCurrency");
			session.removeAttribute("strEntryUser");
			strPDate = request.getParameter("txtPDate");
			strPDate = (strPDate != null) ? CommonUtil.AllTrim(strPDate) : "" ;
			session.setAttribute("strPDate", strPDate);

			strEntryStartDate = request.getParameter("txtEntryStartDate");
			strEntryStartDate = (strEntryStartDate != null) ? CommonUtil.AllTrim(strEntryStartDate) : "" ;
			session.setAttribute("strEntryStartDate", strEntryStartDate);

			strEntryEndDate = request.getParameter("txtEntryEndDate");
			strEntryEndDate = (strEntryEndDate != null) ? CommonUtil.AllTrim(strEntryEndDate) : "" ;
			session.setAttribute("strEntryEndDate", strEntryEndDate);

			strDispatch = request.getParameter("selDispatch");
			strDispatch = (strDispatch != null) ? CommonUtil.AllTrim(strDispatch) : "" ;
			session.setAttribute("selDispatch", strDispatch);

			strPSrcCode = request.getParameter("selPSrcCode");
			strPSrcCode = (strPSrcCode != null) ? CommonUtil.AllTrim(strPSrcCode) : "" ;
			session.setAttribute("selPSrcCode", strPSrcCode);

			strCurrency = request.getParameter("selCurrency");
			strCurrency = (strCurrency != null) ? CommonUtil.AllTrim(strCurrency) : "" ;
			session.setAttribute("selCurrency", strCurrency);

			strEntryUser = request.getParameter("txtEntryUser");
			strEntryUser = (strEntryUser != null) ? CommonUtil.AllTrim(strEntryUser).toUpperCase() : "" ;
			session.setAttribute("strEntryUser", strEntryUser);
		}

		strSql = "select A.ENTRYDT,A.PAMT,A.PCFMDT1,A.PCFMTM1,A.PCFMDT2,A.PCFMTM2,A.PDATE,A.UPDDT,A.UPDTM,";
		strSql += "A.APPNO,A.POLICYNO,A.ENTRYUSR,A.PAUTHCODE,A.PBACCOUNT,A.PBBANK,A.PCFMUSR1,A.PCFMUSR2,";
		strSql += "A.PCHECKNO,A.PCRDEFFMY,A.PCRDNO,A.PCRDTYPE,A.PDESC,A.PDISPATCH,A.PID,A.PMETHOD,A.PNAME,";
		strSql += "A.PNO,A.PNOH,A.PRACCOUNT,A.PRBANK,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,";
		strSql += "A.BRANCH,A.PCURR,A.PAUTHDT ";
		strSql += " from CAPPAYF A ";
		strSql += " join USER B ON B.USRID=A.ENTRY_USER ";
		strSql += " WHERE A.PAY_CONFIRM_DATE1=0 AND A.PAY_CONFIRM_TIME1=0 AND A.PAY_CONFIRM_USER1='' ";
		strSql += " AND A.PAY_CONFIRM_DATE2=0 AND A.PAY_CONFIRM_TIME2=0 AND A.PAY_CONFIRM_USER2='' ";
		strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <>0 ";

		// ����v������
		// �v����99��, �i�d�Ҧ����
		if (strUserRight.equals("99")) {
		// �u��d�������Ҧ����
		} else if (Integer.parseInt(strUserRight) >= Integer.parseInt("89") && Integer.parseInt(strUserRight) < Integer.parseInt("99")) {
/*RC0036*/	if (strUserDept.equals("CSC")){
/*RC0036*/		strSql += "  AND B.DEPT IN ('CSC','PCD','TYB','TCB','TNB','KHB')";
/*RC0036*/	}else{
/*RC0036*/	   if(strUserBrch.equals("")){   
/*RC0036*/		  strSql += "  AND B.DEPT='" + strUserDept + "' ";
/*RC0036*/	   }else{
/*RC0036*/	      strSql += "  AND B.DEPT='" + strUserDept + "' ";
/*RC0036*/	      strSql += "  AND B.USRBRCH='" + strUserBrch + "' ";
/*RC0036*/    }
/*RC0036*/	}    
		// �u��d�ۤv�ҿ�J�����
		} else {
			strSql += " AND A.ENTRY_USER= '" + strLogonUser + "' ";
		}	
		if (!strPDate.equals("")) {
			strSql += " and A.PDATE <= " + strPDate;

			if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate;
			} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
				strSql += " and A.ENTRYDT >= " + strEntryStartDate;
			} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and A.ENTRYDT <= " + strEntryEndDate;
			}

			if (strDispatch.equals("Y")) {
				strSql += "  and A.PDISPATCH= '" + strDispatch + "' ";
			} else if (strDispatch.equals("N")) {
				strSql += "  and A.PDISPATCH='' ";
			}

			if (!strPSrcCode.equals("")) {
				strSql += "  and A.PSRCCODE= '" + strPSrcCode + "' ";
			}

			if (!strCurrency.equals("")) {
				strSql += "  and A.PCURR= '" + strCurrency + "' ";
			} else {
				strSql += "  and A.PCURR in ('NT','US','AU','EU','HK','JP','NZ') ";
			}

			if (!strEntryUser.equals("")) {
				strSql += "  and A.ENTRYUSR = '" + strEntryUser + "' ";
			}

			System.out.println(" inside DISBSConfirmServlet.inqueryDB()--> strSql =" + strSql);
			log.info(" inside DISBSConfirmServlet.inqueryDB()--> strSql =" + strSql);

			try {
				stmt = con.createStatement();
				rs = stmt.executeQuery(strSql);

				while (rs.next()) {
					if (rs.getString("PMETHOD").trim().equals("A")
						|| (rs.getString("PMETHOD").trim().equals("B") 
								&& rs.getString("PCURR").trim().equals("NT")
								&& !rs.getString("PRBANK").trim().equals("") 
								&& !rs.getString("PRACCOUNT").trim().equals(""))
						|| (rs.getString("PMETHOD").trim().equals("B")
								&& rs.getString("PCURR").trim().equals("US") 
								&& !rs.getString("PRACCOUNT").trim().equals(""))
						|| (rs.getString("PMETHOD").trim().equals("D")
								&& rs.getString("PCURR").trim().equals("NT")
								&& !rs.getString("PRBANK").trim().equals("")
								&& !rs.getString("PRACCOUNT").trim().equals("")
								&& !rs.getString("PID").trim().equals("")
								&& (rs.getString("PSRCCODE").trim().equals("BB")
									|| rs.getString("PSRCCODE").trim().equals("B8") 
									|| rs.getString("PSRCCODE").trim().equals("B9")))
						|| (rs.getString("PMETHOD").trim().equals("C")
								&& !rs.getString("PCRDNO").trim().equals("")
								&& !rs.getString("PCRDEFFMY").trim().equals("") && rs.getInt("PAUTHDT") != 0))
					{
						// System.out.println(rs.getString("PNO")+"=="+rs.getString("PMETHOD").trim());
						objPDetailVO = new DISBPaymentDetailVO();
						// System.out.println("ENTRYDT="+rs.getInt("ENTRYDT"));
						objPDetailVO.setIEntryDt(rs.getInt("ENTRYDT")); // ��J���
						objPDetailVO.setIPAMT(rs.getDouble("PAMT")); // ��I���B
						objPDetailVO.setIPCfmDt1(rs.getInt("PCFMDT1")); // ��I�T�{��@
						objPDetailVO.setIPCfmTm1(rs.getInt("PCFMTM1")); // ��I�T�{�ɤ@
						objPDetailVO.setIPCfmDt2(rs.getInt("PCFMDT2")); // ��I�T�{��G
						objPDetailVO.setIPCfmTm2(rs.getInt("PCFMTM2")); // ��I�T�{�ɤG
						objPDetailVO.setIPDate(rs.getInt("PDATE")); // �I�ڤ��
						objPDetailVO.setIUpdDt(rs.getInt("UPDDT")); // ���ʤ��
						objPDetailVO.setIUpdTm(rs.getInt("UPDTM")); // ���ʮɶ�
						objPDetailVO.setStrAppNo(rs.getString("APPNO")); // �n�O�Ѹ��X
						objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO")); // �O�渹�X
						objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR")); // ��J�H��
						objPDetailVO.setStrPAuthCode(rs.getString("PAUTHCODE")); // ���v�X
						objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT")); // �I�ڻȦ�
						objPDetailVO.setStrPBBank(rs.getString("PBBANK")); // �I�ڱb��
						objPDetailVO.setStrPCfmUsr1(rs.getString("PCFMUSR1")); // ��I�T�{�̤@
						objPDetailVO.setStrPCfmUsr2(rs.getString("PCFMUSR2")); // ��I�T�{�̤G
						objPDetailVO.setStrPCheckNO(rs.getString("PCHECKNO")); // �䲼���X
						objPDetailVO.setStrPCrdEffMY(rs.getString("PCRDEFFMY")); // ���Ħ~��
						objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO")); // �H�Υd�d��
						objPDetailVO.setStrPCrdType(rs.getString("PCRDTYPE")); // �d�O
						objPDetailVO.setStrPDesc(rs.getString("PDESC")); // ��I�y�z
						objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH")); // ���_
						objPDetailVO.setStrPId(rs.getString("PID")); // ���ڤHID
						objPDetailVO.setStrPMethod(rs.getString("PMETHOD")); // �I�ڤ覡
						objPDetailVO.setStrPName(rs.getString("PNAME")); // ���ڤH�m�W
						objPDetailVO.setStrPNO(rs.getString("PNO")); // ��I�Ǹ�
						objPDetailVO.setStrPNoH(rs.getString("PNOH")); // ���I�Ǹ�
						objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT")); // �״ڱb��
						objPDetailVO.setStrPRBank(rs.getString("PRBANK")); // �״ڻȦ�
						objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP")); // �ӷ��ոs
						objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE")); // ��I��]�N�X
						objPDetailVO.setStrPStatus(rs.getString("PSTATUS")); // �I�ڪ��A
						objPDetailVO.setStrPCurr(rs.getString("PCURR")); // ���O
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
						// System.out.println("objPDetailVO.getStrBranch()="+objPDetailVO.getStrBranch());
						alPDetail.add(objPDetailVO);
					}
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
				try { if (rs != null) { rs.close(); } } catch (Exception ex1) {}
				try { if (stmt != null) { stmt.close(); } } catch (Exception ex1) {}
				try { if (con != null) { dbFactory.releaseAS400Connection(con); } } catch (Exception ex1) {}
			}
			request.setAttribute("txtAction", "I");
			dispatcher = request.getRequestDispatcher("/DISB/DISBPSource/DISBPSourceConfirm.jsp");
			dispatcher.forward(request, response);

			return;
		}

	}

}