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
import com.aegon.disb.util.DISBCheckControlInfoVO;

/**
 * System   : CashWeb
 * 
 * Function : ���ڮw�s
 * 
 * Remark   : �޲z�t��-�]��
 * 
 * Revision : $$Revision: 1.7 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckStockServlet.java,v $
 * $Revision 1.7  2013/12/24 02:17:18  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.6  2012/07/17 02:50:31  MISSALLY
 * $RA0043 / RA0081
 * $1.�@�ȥx�s�U���ɮ榡�վ�
 * $2.���ڮw�s���֭��v����Ū�]�w
 * $
 * $Revision 1.5  2010/11/23 06:27:42  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.4  2010/03/11 03:13:01  missteven
 * $change wokflow
 * $
 * $Revision 1.3  2009/12/03 04:09:44  missteven
 * $R90628 ���ڮw�s�s�W
 * $
 * $Revision 1.2  2006/07/24 02:49:42  MISangel
 * $�ץ�bug
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:22  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

public class DISBCheckStockServlet extends HttpServlet {

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
		// R00393 edit by Leo Huang
		commonUtil = new CommonUtil(globalEnviron);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));

		String strAction = "";
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";

		try {
			if (strAction.equals("I"))
				inquiryDB(request, response);
			else if (strAction.equals("D"))
				deleteDB(request, response);
			else if (strAction.equals("A"))
				createNewCheck(request, response);
			else if (strAction.equals("AU"))
				approvNewCheck(request, response, strLogonUser, iUpdDate);
			else if (strAction.equals("AD"))
				approvDeleteCheck(request, response, strLogonUser, iUpdDate);
			else if (strAction.equals("AR"))
				approvRDeleteCheck(request, response, strLogonUser, iUpdDate);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} // end of try
		catch (Exception e) {
			System.err.println("Application Exception >>> " + e);
		}
		return;
	}

	private void createNewCheck(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("@@@@@inside createNewCheck");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.createNewCheck()");
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String strReturnMsg = "";
		boolean bFlag = true;
		DISBCheckControlInfoVO objCControlVO = null;

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strCBKNo = "";		// �Ȧ��w
		String strCAccount = "";	// �Ȧ�b��
		String strCSNo = "";		// ���ڰ_��
		String strCENo = "";		// ���ڨ���
		String strBatNo = "";		// ���ڧ帹
		String strChdFlg = "";		// �H�u�β��_

		/* ���o�e������� */
		strCBKNo = request.getParameter("txtCBank");
		if (strCBKNo != null)
			strCBKNo = strCBKNo.trim();
		else
			strCBKNo = "";

		strCAccount = request.getParameter("txtCAccount");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCSNo = request.getParameter("txtUCSNo");
		if (strCSNo != null)
			strCSNo = strCSNo.trim();
		else
			strCSNo = "";

		strCENo = request.getParameter("txtUCENo");
		if (strCENo != null)
			strCENo = strCENo.trim();
		else
			strCENo = "";

		strChdFlg = request.getParameter("chUChdFlg");
		if (strChdFlg != null)
			strChdFlg = strChdFlg.trim();
		else
			strChdFlg = "";

		try {
			/* �A���P�_�Ӥ䲼�����϶��O�_�Q�s�b */
			bFlag = disbBean.isValidCheckNo(strCSNo, strCENo);
			if (!bFlag) {
				/* ���o���ڧ帹 */
				strBatNo = getCheckBatNo(strCBKNo, strCAccount, con);
				if (!strBatNo.equals("")) {
					/* �s�W��ƨ첼�ڱ����ɤ� */
					objCControlVO = new DISBCheckControlInfoVO();
					objCControlVO.setIEntryDt(iUpdDate);
					objCControlVO.setIEntryTm(iUpdTime);
					objCControlVO.setStrEntryUsr(strLogonUser);
					objCControlVO.setStrCAccount(strCAccount);
					objCControlVO.setStrCBKNo(strCBKNo);
					objCControlVO.setStrCBNo(strBatNo);
					objCControlVO.setStrCENo(strCENo);
					objCControlVO.setStrCSNo(strCSNo);

					strReturnMsg = insertCheckControl(objCControlVO, con);
					if (strReturnMsg.equals("")) {
						/* �s�W�h����ƨ첼�ک����ɤ� */
						strReturnMsg = insertCheckDetails(objCControlVO, strChdFlg, con);
					}
				}
			}

			if (!strReturnMsg.equals("")) // �p�����~�ɫh roll back
			{
				request.setAttribute("txtMsg", strReturnMsg);
				if (isAEGON400) {
					con.rollback();
				}
			} else {
				request.setAttribute("txtMsg", "���ڮw�s�s�W���\");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", ex);
		} catch (Exception e) {
			request.setAttribute("txtMsg", e);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", "A");
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckStock.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private String getCheckBatNo(String strCBKNo, String strCAccount, Connection con) {
		int iCBNo = 0;
		String strCBNo = "";
		String strSql = "";

		try {
			strSql = "select COUNT(CBNO) as CBNO from CAPCKNOF";
			strSql += " where CBKNO ='" + strCBKNo + "' and CACCOUNT='" + strCAccount + "'";
			System.out.println("inside getCheckBatNo()_strSql="+strSql);
			if (con != null) {
				Statement stmtStatement = con.createStatement();
				ResultSet rstResultSet = stmtStatement.executeQuery(strSql);
				if (rstResultSet.next()) {
					if (rstResultSet.getString("CBNO") != null) {
						if (!rstResultSet.getString("CBNO").trim().equals("")) {
							iCBNo = Integer.parseInt(rstResultSet.getString("CBNO").trim());
						}
					} else {
						iCBNo = 0;
					}
				}

				rstResultSet.close();

				iCBNo = iCBNo + 1;
				strCBNo = Integer.toString(iCBNo);

			}
		} catch (SQLException e) {
			strCBNo = "";
			System.err.println(e.getMessage());
		}
		System.out.println("strCBNo=" + strCBNo);
		return strCBNo;
	}

	private String insertCheckDetails(DISBCheckControlInfoVO objCControlVO, String strChdFlg, Connection con) {
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		try {
			String strCSNo = objCControlVO.getStrCSNo().trim(); // ���ڰ_��
			String strCENo = objCControlVO.getStrCENo().trim(); // ���ڨ���
			String strCNo = "";
			String strPreFix = strCSNo.substring(0, 2);

			int iCSNoTemp = Integer.parseInt(strCSNo.substring(2));
			int iCENoTemp = Integer.parseInt(strCENo.substring(2));
			int iCheckCount = (iCENoTemp - iCSNoTemp) + 1;
			int iCLength = strCENo.substring(2).length();
			// CommonUtil.padLeadingZero(strDISBSeqNoTemp,iCLength);

			strSql = " insert into CAPCHKF(CBKNO,CACCOUNT,CBNO,CNO,ENTRYDT,ENTRYTM,ENTRYUSR,CHNDFLG,MEMO)  ";
			strSql += " values(?,?,?,?,?,?,?,?,?) ";

			int batchNo = 500;

			pstmtTmp = con.prepareStatement(strSql);
			for (int i = 0; i < iCheckCount; i++) {
				System.out.println("i=" + i);
				strCNo = strPreFix + CommonUtil.padLeadingZero(Integer.toString(iCSNoTemp + i), iCLength);
				pstmtTmp.setString(1, objCControlVO.getStrCBKNo());
				pstmtTmp.setString(2, objCControlVO.getStrCAccount());
				pstmtTmp.setString(3, objCControlVO.getStrCBNo());
				pstmtTmp.setString(4, strCNo);
				pstmtTmp.setInt(5, objCControlVO.getIEntryDt());
				pstmtTmp.setInt(6, objCControlVO.getIEntryTm());
				pstmtTmp.setString(7, objCControlVO.getStrEntryUsr());
				pstmtTmp.setString(8, strChdFlg);
				pstmtTmp.setString(9, "");
				pstmtTmp.addBatch();
				if ((i % batchNo == 0) || (i % batchNo != 0 && i == (iCheckCount - 1))) {
					pstmtTmp.executeBatch();
				}

				/*
				 * if (pstmtTmp.executeUpdate() != 1) { strReturnMsg
				 * ="�s�W���ک����ɥ���"; return strReturnMsg; }
				 */
			}
			// int[] row = pstmtTmp.executeBatch();
			// System.out.println("row="+row.length);

			// pstmtTmp.close();
		} catch (SQLException e) {
			strReturnMsg = "�s�W���ک����ɥ���: e=" + e;
			System.err.println(e.getMessage());
		} finally {
			try { if (pstmtTmp != null) pstmtTmp.close(); } catch (Exception ex1) {}
		}
		return strReturnMsg;
	}

	private String insertCheckControl(DISBCheckControlInfoVO objCControlVO, Connection con) {
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		try {

			strSql = " insert into CAPCKNOF(CBKNO,CACCOUNT,CBNO,CHKSNO,CHKENO,ENTRYDT,ENTRYTM,ENTRYUSR,APPROVSTA)  ";
			strSql += " values(?,?,?,?,?,?,?,?,'N') ";

			pstmtTmp = con.prepareStatement(strSql);
			pstmtTmp.setString(1, objCControlVO.getStrCBKNo());
			pstmtTmp.setString(2, objCControlVO.getStrCAccount());
			pstmtTmp.setString(3, objCControlVO.getStrCBNo());
			pstmtTmp.setString(4, objCControlVO.getStrCSNo());
			pstmtTmp.setString(5, objCControlVO.getStrCENo());
			pstmtTmp.setInt(6, objCControlVO.getIEntryDt());
			pstmtTmp.setInt(7, objCControlVO.getIEntryTm());
			pstmtTmp.setString(8, objCControlVO.getStrEntryUsr());

			if (pstmtTmp.executeUpdate() != 1) {
				strReturnMsg = "�s�W���ڱ����ɥ���";
				return strReturnMsg;
			}
			pstmtTmp.close();

		} catch (SQLException e) {
			strReturnMsg = "�s�W���ڱ����ɥ���: e=" + e;
			System.err.println(e.getMessage());
		} finally {
			try { if (pstmtTmp != null) pstmtTmp.close(); } catch (Exception ex1) {}
		}

		return strReturnMsg;
	}

	private void deleteDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("@@@@@inside deleteDB");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.deleteDB()");
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String strReturnMsg = "";

		/* �����e�����w�q */
		String strCBKNo = ""; // �Ȧ��w
		String strCAccount = ""; // �Ȧ�b��
		String strCBNo = ""; // ���ڧ帹
		String strCSNo = ""; // ���ڰ_��
		String strCENo = ""; // ���ڨ���

		/* ���o�e������� */
		strCBKNo = request.getParameter("txtDCBKNo");
		if (strCBKNo != null)
			strCBKNo = strCBKNo.trim();
		else
			strCBKNo = "";

		strCAccount = request.getParameter("txtDCAccount");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strCBNo = request.getParameter("txtDCBNo");
		if (strCBNo != null)
			strCBNo = strCBNo.trim();
		else
			strCBNo = "";

		strCSNo = request.getParameter("txtDCSNo");
		if (strCSNo != null)
			strCSNo = strCSNo.trim();
		else
			strCSNo = "";

		strCENo = request.getParameter("txtDCENo");
		if (strCENo != null)
			strCENo = strCENo.trim();
		else
			strCENo = "";

		try {
			/* �A���P�_�Ӥ䲼���O�_�Q�ϥ� */
			strReturnMsg = disbBean.isCheckBookUsed(strCBKNo, strCAccount, strCBNo, strCSNo, strCENo);

			if (strReturnMsg.equals("")) {
				/* �R�����ڥD�� */
				strReturnMsg = deleteCheckControl(strCBKNo, strCAccount, strCBNo, con);
				if (strReturnMsg.equals("")) {
					/* �R�����ک����� */
					strReturnMsg = deleteCheckDetails(strCBKNo, strCAccount, strCBNo, con);
					if (strReturnMsg.equals("")) {
						request.setAttribute("txtMsg", "�R�����\");
					}
				}
			}
			if (!strReturnMsg.equals("")) {
				request.setAttribute("txtMsg", strReturnMsg);
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtAction", "D");
				dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckStock.jsp");
				dispatcher.forward(request, response);
				return;
			}
		} catch (Exception e) {
			request.setAttribute("txtMsg", "���ڮw�s�R������-->" + e);
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
			System.err.println(e.getMessage());
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", "D");
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckStock.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private String deleteCheckDetails(String strCBKNo, String strCAccount, String strCBNo, Connection con) {
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		try {
			strSql = " Delete from  CAPCHKF  ";
			strSql += " where CBKNO =? and CACCOUNT=? and CBNO=? ";

			pstmtTmp = con.prepareStatement(strSql);
			pstmtTmp.setString(1, strCBKNo);
			pstmtTmp.setString(2, strCAccount);
			pstmtTmp.setString(3, strCBNo);

			if (pstmtTmp.executeUpdate() < 1) {
				strReturnMsg = "�R�����ک����ɥ���";
				return strReturnMsg;
			}
			pstmtTmp.close();

		} catch (SQLException e) {
			strReturnMsg = "�R�����ک����ɥ���: e=" + e;
			System.err.println(e.getMessage());
		} finally {
			try { if (pstmtTmp != null) pstmtTmp.close(); } catch (Exception ex1) { }
		}
		return strReturnMsg;
	}

	private String deleteCheckControl(String strCBKNo, String strCAccount, String strCBNo, Connection con) {
		PreparedStatement pstmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		try {
			strSql = "UPDATE CAPCKNOF  SET APPROVSTA = 'E' ";
			strSql += " where CBKNO =? and CACCOUNT=? and CBNO=? ";

			pstmtTmp = con.prepareStatement(strSql);
			pstmtTmp.setString(1, strCBKNo);
			pstmtTmp.setString(2, strCAccount);
			pstmtTmp.setString(3, strCBNo);
			if (pstmtTmp.executeUpdate() < 1) {
				strReturnMsg = "�R�����ڱ����ɥ���";
				return strReturnMsg;
			}

			pstmtTmp.close();
		} catch (SQLException e) {
			strReturnMsg = "�R�����ڱ����ɥ���: e=" + e;
			System.err.println(e.getMessage());
		} finally {
			try { if (pstmtTmp != null) pstmtTmp.close(); } catch (Exception ex1) { }
		}
		return strReturnMsg;
	}

	// R90628
	private void approvNewCheck(HttpServletRequest request, HttpServletResponse response, String strLogonUser, int iUpdDate) throws ServletException, IOException {
		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.deleteDB()");
		PreparedStatement pstmtTmp = null;
		String strCBKNo = request.getParameter("txtDCBKNo") != null ? request.getParameter("txtDCBKNo").trim() : "";
		String strCAccount = request.getParameter("txtDCAccount") != null ? request.getParameter("txtDCAccount").trim() : "";
		String strCBNo = request.getParameter("txtDCBNo") != null ? request.getParameter("txtDCBNo").trim() : "";
		String strCSNo = request.getParameter("txtDCSNo") != null ? request.getParameter("txtDCSNo").trim() : "";
		String strCENo = request.getParameter("txtDCENo") != null ? request.getParameter("txtDCENo").trim() : "";
		String strReturnMsg = "";
		try {
			pstmtTmp = con.prepareStatement("UPDATE CAPCKNOF SET APPROVSTA = 'A',APPROVUSR=?,APPROVDT=? WHERE CBKNO = ? AND CACCOUNT = ? AND CBNO = ? ");
			pstmtTmp.setString(1, strLogonUser);
			pstmtTmp.setInt(2, iUpdDate);
			pstmtTmp.setString(3, strCBKNo);
			pstmtTmp.setString(4, strCAccount);
			pstmtTmp.setString(5, strCBNo);
			if (pstmtTmp.executeUpdate() < 1)
				strReturnMsg = "�֭�s�W���ڱ����ɥ���";
			else
				strReturnMsg = "�֭�s�W���ڱ����ɦ��\";
			pstmtTmp.close();
			request.setAttribute("txtMsg", strReturnMsg);
			request.setAttribute("txtAction", "D");
			request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckStock.jsp").forward(request, response);
		} catch (SQLException e) {
			strReturnMsg = "�֭�s�W���ڱ����ɥ���: e=" + e;
			System.err.println(e.getMessage());
		} finally {
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		}
	}

	// R90628
	private void approvRDeleteCheck(HttpServletRequest request, HttpServletResponse response, String strLogonUser, int iUpdDate) throws ServletException, IOException {
		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.deleteDB()");
		PreparedStatement pstmtTmp = null;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String strCBKNo = request.getParameter("txtDCBKNo") != null ? request.getParameter("txtDCBKNo").trim() : "";
		String strCAccount = request.getParameter("txtDCAccount") != null ? request.getParameter("txtDCAccount").trim() : "";
		String strCBNo = request.getParameter("txtDCBNo") != null ? request.getParameter("txtDCBNo").trim() : "";
		String strCSNo = request.getParameter("txtDCSNo") != null ? request.getParameter("txtDCSNo").trim() : "";
		String strCENo = request.getParameter("txtDCENo") != null ? request.getParameter("txtDCENo").trim() : "";
		String strReturnMsg = "";
		try {
			/* �A���P�_�Ӥ䲼���O�_�Q�ϥ� */
			strReturnMsg = disbBean.isCheckBookUsed(strCBKNo, strCAccount, strCBNo, strCSNo, strCENo);

			if (strReturnMsg.equals("")) {
				pstmtTmp = con.prepareStatement("UPDATE CAPCKNOF SET APPROVSTA = 'R',APPROVUSR=?,APPROVDT=? WHERE CBKNO = ? AND CACCOUNT = ? AND CBNO = ? ");
				pstmtTmp.setString(1, strLogonUser);
				pstmtTmp.setInt(2, iUpdDate);
				pstmtTmp.setString(3, strCBKNo);
				pstmtTmp.setString(4, strCAccount);
				pstmtTmp.setString(5, strCBNo);
				if (pstmtTmp.executeUpdate() < 1)
					strReturnMsg = "�ӽЧR�����ڱ����ɥ���";
				else
					strReturnMsg = "�ӽЧR�����ڱ����ɦ��\";
				pstmtTmp.close();
			}
			request.setAttribute("txtMsg", strReturnMsg);
			request.setAttribute("txtAction", "D");
			request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckStock.jsp").forward(request, response);
		} catch (SQLException e) {
			strReturnMsg = "�ӽЧR�����ڱ����ɥ���: e=" + e;
			System.err.println(e.getMessage());
		} finally {
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		}
	}

	// R90628
	private void approvDeleteCheck(HttpServletRequest request, HttpServletResponse response, String strLogonUser, int iUpdDate) throws ServletException, IOException {
		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.deleteDB()");
		PreparedStatement pstmtTmp = null;
		String strCBKNo = request.getParameter("txtDCBKNo") != null ? request.getParameter("txtDCBKNo").trim() : "";
		String strCAccount = request.getParameter("txtDCAccount") != null ? request.getParameter("txtDCAccount").trim() : "";
		String strCBNo = request.getParameter("txtDCBNo") != null ? request.getParameter("txtDCBNo").trim() : "";
		String strCSNo = request.getParameter("txtDCSNo") != null ? request.getParameter("txtDCSNo").trim() : "";
		String strCENo = request.getParameter("txtDCENo") != null ? request.getParameter("txtDCENo").trim() : "";
		String strReturnMsg = "";
		try {
			pstmtTmp = con.prepareStatement("UPDATE CAPCKNOF SET APPROVSTA = 'D',APPROVUSR=?,APPROVDT=? WHERE CBKNO = ? AND CACCOUNT = ? AND CBNO = ? ");
			pstmtTmp.setString(1, strLogonUser);
			pstmtTmp.setInt(2, iUpdDate);
			pstmtTmp.setString(3, strCBKNo);
			pstmtTmp.setString(4, strCAccount);
			pstmtTmp.setString(5, strCBNo);
			if (pstmtTmp.executeUpdate() < 1)
				strReturnMsg = "�֭�R�����ڱ����ɥ���";
			else
				strReturnMsg = "�֭�R�����ڱ����ɦ��\";
			pstmtTmp.close();
			request.setAttribute("txtMsg", strReturnMsg);
			request.setAttribute("txtAction", "D");
			request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckStock.jsp").forward(request, response);
		} catch (SQLException e) {
			strReturnMsg = "�֭�R�����ڱ����ɥ���: e=" + e;
			System.err.println(e.getMessage());
		} finally {
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		}
	}

	private void inquiryDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.inquiryDB()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String

		DISBCheckControlInfoVO objCControlVO = null;
		List alCControll = new ArrayList();
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);// R90628

		/* �����e�����w�q */
		String strCBKNo = ""; // �Ȧ��w
		String strCAccount = ""; // �Ȧ�b��

		/* ���o�e������� */
		strCBKNo = request.getParameter("txtCBank");
		if (strCBKNo != null)
			strCBKNo = strCBKNo.trim();
		else
			strCBKNo = "";

		strCAccount = request.getParameter("txtCAccount");
		if (strCAccount != null)
			strCAccount = strCAccount.trim();
		else
			strCAccount = "";

		strSql = " select CBKNO,CACCOUNT,CBNO,CHKSNO,CHKENO,ENTRYDT,ENTRYTM,ENTRYUSR,APPROVSTA,APPROVUSR ";
		strSql += " from  CAPCKNOF ";
		strSql += " WHERE CBKNO='" + strCBKNo + "' AND CACCOUNT='" + strCAccount
				+ "'  AND APPROVSTA NOT IN ('E','T') ";
		strSql += " ORDER BY CAST(TRIM(CBNO) AS INT) ASC ";

		System.out.println(" inside DISBCheckStockServlet.inquiryDB()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objCControlVO = new DISBCheckControlInfoVO();
				objCControlVO.setStrCBKNo(rs.getString("CBKNO")); // �Ȧ��w
				objCControlVO.setStrCAccount(rs.getString("CACCOUNT")); // �Ȧ�b��
				objCControlVO.setStrCBNo(rs.getString("CBNO"));// ���ڧ帹
				objCControlVO.setStrCSNo(rs.getString("CHKSNO"));// ���ڰ_��
				objCControlVO.setStrCENo(rs.getString("CHKENO"));// ���ڰW��
				objCControlVO.setIEntryDt(rs.getInt("ENTRYDT"));// ��J���
				objCControlVO.setIEntryTm(rs.getInt("ENTRYTM"));// ��J�ɶ�
				objCControlVO.setStrEntryUsr(rs.getString("ENTRYUSR"));// ��J�H��
				objCControlVO.setStrApprovStat(rs.getString("APPROVSTA"));// �֭㪬�A
				objCControlVO.setStrApprovUser(rs.getString("APPROVUSR"));// �ַǤH��
				int useCount = disbBean.isCheckBookUseCount(rs.getString("CBKNO"), rs.getString("CACCOUNT"), rs.getString("CBNO"), rs.getString("CHKSNO"), rs.getString("CHKENO"));
				objCControlVO.setIEmptyCheck(useCount);
				String strReturnMsg = disbBean.isCheckBookUsed(rs.getString("CBKNO"), rs.getString("CACCOUNT"), rs.getString("CBNO"), rs.getString("CHKSNO"), rs.getString("CHKENO"));
				objCControlVO.setStrMemo(getAPPDISC(rs.getString("APPROVSTA"), useCount, strReturnMsg));
				alCControll.add(objCControlVO);
			}
			if (alCControll.size() > 0) {
				session.setAttribute("CheckControlList", alCControll);
				session.setAttribute("SelectedBank", strCBKNo + "/" + strCAccount);
				request.setAttribute("txtMsg", "");
			} else {
				request.setAttribute("txtMsg", "�d�L�۲Ÿ��");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			alCControll = null;
			System.err.println(ex.getMessage());
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
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckStock.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private String getAPPDISC(String status, int count, String strReturnMsg) {
		String strMsg = "";
		if ("N".equals(status)) {
			strMsg = "�֭�ӽФ�";
		} else if ("A".equals(status) && "".equals(strReturnMsg)) {
			strMsg = "�w�֭�ϥ�";
		} else if ("A".equals(status) && !"".equals(strReturnMsg) && count > 0) {
			strMsg = "�ϥΤ�";
		} else if ("A".equals(status) && !"".equals(strReturnMsg) && count == 0) {
			strMsg = "�ϥΧ���";
		} else if ("R".equals(status)) {
			strMsg = "�ӽЧR����";
		} else if ("D".equals(status)) {
			strMsg = "�w�֭�R��";
		}
		return strMsg;
	}

}
