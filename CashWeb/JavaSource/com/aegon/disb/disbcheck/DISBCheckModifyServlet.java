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
 * Revision : $$Revision: 1.4 $$
 * 
 * Author   : Angel Chen
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 */

public class DISBCheckModifyServlet extends InitDBServlet {

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
			if (strAction.equals("I"))
				inquiryDB(request, response);
			else if (strAction.equals("DISBCheckModify"))
				checkCreateProcess(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} // end of try
		catch (Exception e) {
			System.out.println("Application Exception >>> " + e);

		}
		return;
	}

	private void checkCreateProcess(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		// System.out.println("@@@@@inside checkModify");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory.getAS400Connection("DISBCheckMoifyServlet.checkCreation()");
		String strReturnMsg = "";
		boolean bContinue = true;
		List alReturnInfo = new ArrayList();
		List alCheckList = new ArrayList();
		List alCheckInfo = new ArrayList();

		alCheckList = (List) maintainPList(request, response);
		List alPDetail = (List) session.getAttribute("PDetailListTemp");
		int iUpdDate = Integer.parseInt((String) commonUtil
				.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday
				.getTime()));
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
						strReturnMsg = updateCheckInfo(alCheckInfo, alPDetail, iUpdDate, iUpdTime, strLogonUser, con);
						if (strReturnMsg.equals("")) {
							/* ��s��I�D�ɤΤULOG */
							strReturnMsg = updatePDetails(alCheckInfo,alPDetail, iUpdDate, iUpdTime, strLogonUser, con);
							if (strReturnMsg.equals("")) {
								request.setAttribute("txtMsg", "�����٭즨�\");
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
						request.setAttribute("txtAction", "DISBCheckModify");
						dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckModify.jsp");
						dispatcher.forward(request, response);
						return;
					}

				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�����٭쥢��-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", "DISBCheckModify");
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckModify.jsp");
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
		DISBCheckDetailVO objCDetailVO = null;
		List alCheckList = new ArrayList();
		List alPDetail = (List) session.getAttribute("PDetailListTemp");
		// (List) session.getAttribute("PDetailList");

		if (alPDetail != null)
			iSize = alPDetail.size();

		for (int i = 0; i < iSize; i++) {
			strCNoTemp = request.getParameter("txtCNo" + i);
			if (!strCNoTemp.equals("")) {
				objCDetailVO = new DISBCheckDetailVO();
				DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(i);
				objCDetailVO.setStrPNO(objPDetailVO.getStrPNO());
				objCDetailVO.setStrCNo(strCNoTemp);
				alCheckList.add(objCDetailVO);
			}
		} // end of for loop........
		return alCheckList;
	} // end of maintainPList method....

	private void inquiryDB(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckModifyServlet.inqueryDB()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* �����e�����w�q */
		String strChequeNo = ""; // �䲼���X
		strChequeNo = request.getParameter("txtChequeNo");
		if (strChequeNo != null)
			strChequeNo = strChequeNo.trim().toUpperCase();
		else
			strChequeNo = "";

		strSql = "select A.PNO,A.PAMT,A.PNAME,A.POLICYNO,A.RMTFEE,A.PCSHDT,A.PCHECKNO,A.PDESC";
		strSql += " from CAPPAYF A ";
		strSql += " WHERE 1=1 and A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  and A.PCFMDT2<>0 ";
		strSql += " AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>''  AND A.PCSHDT <> 0 AND A.PMETHOD in('A','B')  ";
		strSql += " AND A.PVOIDABLE<>'Y' AND A.PDISPATCH='Y' ";
		if (!strChequeNo.equals("")) {
			strSql += " and A.PCHECKNO = '" + strChequeNo + "'";
		}

		// System.out.println(" inside DISBCheckModifyServlet.inquiryDB()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rs.getString("PNO"));// ��I�Ǹ�
				objPDetailVO.setIPAMT(rs.getDouble("PAMT")); // ��I���B
				objPDetailVO.setStrPName(rs.getString("PNAME"));// ���ڤH�m�W
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));
				objPDetailVO.setIPCshDt(rs.getInt("PCSHDT"));// �X�Ǥ��
				objPDetailVO.setStrPCheckNO(rs.getString("PCHECKNO"));// �䲼���X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));// �O�渹�X
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));
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
		request.setAttribute("txtChequeNo", strChequeNo);
		dispatcher = request
				.getRequestDispatcher("/DISB/DISBCheck/DISBCheckModify.jsp");
		dispatcher.forward(request, response);

		return;
	}

	private List getCheckInfo(DISBCheckDetailVO objCDetailVO)
			throws ServletException, IOException {

		Connection con = dbFactory
				.getAS400Connection("DISBPMaintainServlet.getCheckInfo()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String

		List alReturnInfo = new ArrayList();
		Hashtable htCheckInfo = new Hashtable();
		String strReturnFlag = "";
		String strReturnMsg = "";
		String strCNo = (String) objCDetailVO.getStrCNo().trim();

		strSql = "select A.CBKNO,A.CACCOUNT,A.CBNO,A.CNO,A.CSTATUS,A.PNO,A.CHNDFLG ";
		strSql += " from CAPCHKF A ";
		strSql += "WHERE CNO ='" + strCNo + "'";

		// System.out.println(" inside DISBCheckCreateServlet.getCheckInfo()--> strSql =" + strSql);
		try {
			stmt = con.createStatement();

			rs = stmt.executeQuery(strSql);
			if (rs.next()) {
				if (rs.getString("CHNDFLG").equals("Y")) {// �H�u����
					if (!rs.getString("CSTATUS").trim().equals("D")) {// �u���٭쪬�A"�w�}��"������
						strReturnFlag = "1";
						strReturnMsg = "�䲼���X[" + strCNo + "]���A:�D<�w�}��>\n";
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

	private String updateCheckInfo(List alCheckInfo, List alPDetail,
			int iUpdDate, int iUpdTime, String strLogonUser, Connection con)
			throws ServletException, IOException {
		// System.out.println("@@@@@inside updateCheckInfo");
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

						// �U����LOG��

						strSql = "insert into capchkflog (LOGDT,LOGTM,LOGUSR,CBKNO,CACCOUNT,CBNO,CNO,CNM,CAMT,CHEQUEDT, ";
						// R60420 strSql
						// +=" CASHDT,CRTNDT,CUSEDT,CBCKDT,CSTATUS,PNO,CNUMBER,CERFLG,CHNDFLG,ENTRYDT,ENTRYTM,ENTRYUSR,MEMO	)";
						strSql += " CASHDT,CRTNDT,CUSEDT,CBCKDT,CSTATUS,PNO,CNUMBER,CERFLG,CHNDFLG,ENTRYDT,ENTRYTM,ENTRYUSR,MEMO,CHG4USER)";
						strSql += " select "
								+ iUpdDate
								+ ","
								+ iUpdTime
								+ ",'"
								+ strLogonUser
								+ "',CBKNO,CACCOUNT,CBNO,CNO,CNM,CAMT,CHEQUEDT,";
						// R60420 strSql
						// +=" CASHDT,CRTNDT,CUSEDT,CBCKDT,CSTATUS,PNO,CNUMBER,CERFLG,CHNDFLG,ENTRYDT,ENTRYTM,ENTRYUSR,MEMO";
						strSql += " CASHDT,CRTNDT,CUSEDT,CBCKDT,CSTATUS,PNO,CNUMBER,CERFLG,CHNDFLG,ENTRYDT,ENTRYTM,ENTRYUSR,MEMO,CHG4USER ";
						strSql += " from capchkf where 1=1 and CNO =?  AND CBKNO=? AND CACCOUNT=? AND CBNO=? ";

						// System.out.println(
						// " inside DISBCheckCreateServlet.updatePDetails()--> "
						// + strSql);

						pstmtTmp = con.prepareStatement(strSql);
						pstmtTmp.setString(1, strCNo);
						pstmtTmp.setString(2, strCBKNo);
						pstmtTmp.setString(3, strCAccount);
						pstmtTmp.setString(4, strCBNo);

						if (pstmtTmp.executeUpdate() < 1) {
							strReturnMsg = "�U���ک�����log����";
							return strReturnMsg;
						} else {
							strSql = " update CAPCHKF  set CNM='',CAMT=0,CHEQUEDT=0,CUSEDT=0,PNO='' ,CSTATUS='' ";
							strSql += " where CNO =?  AND CBKNO=? AND CACCOUNT=? AND CBNO=? ";
							pstmtTmp = con.prepareStatement(strSql);
							pstmtTmp.setString(1, strCNo);
							pstmtTmp.setString(2, strCBKNo);
							pstmtTmp.setString(3, strCAccount);
							pstmtTmp.setString(4, strCBNo);

							if (pstmtTmp.executeUpdate() < 1) {// 3
								strReturnMsg = "�٭첼�ک����ɥ���";
								return strReturnMsg;
							}// 3
						}
						pstmtTmp.close();
					}// 2 END OF FOR
				}// 1
			}// 0
		} catch (SQLException ex) {
			strReturnMsg = "�٭첼�ک����ɥ���:ex=" + ex;
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
		// System.out.println("@@@@@inside updatePConfirmed");
		PreparedStatement pstmtTmp = null;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		try {
			if (alCheckInfo != null) {
				if (alCheckInfo.size() > 0) {

					for (int i = 0; i < alCheckInfo.size(); i++) {
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo
								.get(i);
						DISBPaymentDetailVO paymentVO = (DISBPaymentDetailVO) alPDetail
								.get(i);

						strSql = " update CAPPAYF  set PBBANK =''  , PBACCOUNT =''  , PCHECKNO='' ,PCSHDT=0,PSTATUS='' ";
						strSql += "  , UPDDT= ? , UPDTM = ?, UPDUSR =?, REMIT_FEE=0  where PNO =?";

						// System.out.println(" inside DISBCheckCreateServlet.updatePDetails()--> " + strSql);

						// �Ulog
						strReturnMsg = disbBean.insertCAPPAYFLOG(objCDetailVO.getStrPNO().trim(), strLogonUser, iUpdDate, iUpdTime, con);
						if (strReturnMsg.equals("")) {
							pstmtTmp = con.prepareStatement(strSql);
							pstmtTmp.setInt(1, iUpdDate);
							pstmtTmp.setInt(2, iUpdTime);
							pstmtTmp.setString(3, strLogonUser);
							pstmtTmp.setString(4, objCDetailVO.getStrPNO().trim());

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

 