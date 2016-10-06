package com.aegon.disb.disbquery;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
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

/**
 * System   : CashWeb
 * 
 * Function : 歷史票據維護
 * 
 * Remark   : 支付查詢
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : ODCZHEJUN
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R00135(PA0024)
 * 
 * CVS History:
 * 
 * $$Log: DISBQryChkHIServlet.java,v $
 * $Revision 1.2  2013/12/24 03:04:34  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $$
 *  
 */

public class DISBQryChkHIServlet extends InitDBServlet {

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

	private DISBBean disbBean = null;
    
	public void init() throws ServletException {
		super.init();

		disbBean = new DISBBean(globalEnviron, dbFactory);
	}

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	doPost(request, response);
    }

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);

		RequestDispatcher dispatcher = null;

		HttpSession session = request.getSession(true);
		String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";

		if(!strUserDept.equals("FIN")) {
			request.setAttribute("txtMsg", "您沒有權限執行此功能!!");
		} else{
			String strAction = (request.getParameter("txtAction") != null)?request.getParameter("txtAction"):"";

			if(strAction.equals("UpdateData")) { //更新票據狀態
				updateCheckData(request, response);
			} else if (strAction.equals("Update4")) {
				updateReopenStatus(request, response);
			}
		}

		dispatcher = request.getRequestDispatcher("/DISB/DISBQuery/DISBQryChkHI.jsp");
		dispatcher.forward(request, response);
	}

	private void updateCheckData(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);

		Connection con = dbFactory.getAS400Connection("DISBQryChkHIServlet.updateCheckData()");
		Statement stmtTmp = null;
		String strSql = ""; // SQL String
		
		String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
		int iUpdDate = Integer.parseInt(strDateTime.substring(0, 7)); //異動日期
		int iUpdTime = Integer.parseInt(strDateTime.substring(7)); //異動時間
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID); //取得登入ID

		/* 接收前端欄位定義 */
		String strCBNo = "";	// 票據批號
		String strCNo = "";		// 票據號碼
		String strCBkNo = "";	// 銀行行庫
		String strCAccount = "";// 銀行帳號
		String strCMEMO = "";	// 支票備註

		strCNo = (request.getParameter("txtCHEQUE_NO") != null)?CommonUtil.AllTrim(request.getParameter("txtCHEQUE_NO")):"";
		strCBkNo = (request.getParameter("txtUBKNO") != null)?CommonUtil.AllTrim(request.getParameter("txtUBKNO")):"";
		strCAccount = (request.getParameter("txtUACCOUNT") != null)?CommonUtil.AllTrim(request.getParameter("txtUACCOUNT")):"";
		strCMEMO = (request.getParameter("txtChequeMEMO") != null)?CommonUtil.AllTrim(request.getParameter("txtChequeMEMO")):"";
		strCBNo = (request.getParameter("txtCBNO") != null)?CommonUtil.AllTrim(request.getParameter("txtCBNO")):"";

		/* 更新資料庫 */
		try {
			strSql = " update CAPCHKFHI  set MEMO='"+strCMEMO+"',ENTRYUSR='"+strLogonUser+"',ENTRYDT='"+iUpdDate+"',ENTRYTM='"+iUpdTime+"'";
			strSql += " where CNO ='"+strCNo+"'  AND CBKNO='"+strCBkNo+"' AND CACCOUNT='"+strCAccount+"' AND CBNO='"+strCBNo+"' ";
			System.out.println("updateHICheckData Sql=" + strSql);

			stmtTmp = con.createStatement();

			if (stmtTmp.executeUpdate(strSql) < 1) {
				request.setAttribute("txtMsg", "更新票據備註失敗");
			} else {
				request.setAttribute("txtMsg", "更新票據備註成功");
			}
			stmtTmp.close();
		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("txtMsg", "更新票據備註失敗-->" + e);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
	}

	private void updateReopenStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);

		Connection con = dbFactory.getAS400Connection("DISBQryChkHIServlet.updateStatusTo4()");
		String strReturnMsg = "";
		List alReturnInfo = new ArrayList();

		String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
		int iUpdDate = Integer.parseInt(strDateTime.substring(0, 7)); //異動日期
		int iUpdTime = Integer.parseInt(strDateTime.substring(7)); //異動時間
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		/* 接收前端欄位定義 */
		String strCNo = "";		// 票據號碼
		String strCBNo = "";	// 票據批號
		String strCBkNo = ""; 	// 銀行行庫
		String strCAccount = ""; // 銀行帳號
		String strCMEMO = "";	// 支票備註
		String strC4User =""; //申請重開USER
		String strCStatus = ""; //票據狀態

		String strUPName = ""; //受款人姓名
		String strUPAMT = ""; //支付金額
		String strCHEQUE_DATE = ""; //到期日
		String strCHEQUE_STATUS = "";

		String strServiceBranch = "";
		String strPlant = "";

		strCNo = (request.getParameter("txtCHEQUE_NO") != null)?CommonUtil.AllTrim(request.getParameter("txtCHEQUE_NO")):"";
		strCBkNo = (request.getParameter("txtUBKNO") != null)?CommonUtil.AllTrim(request.getParameter("txtUBKNO")):"";
		strCAccount = (request.getParameter("txtUACCOUNT") != null)?CommonUtil.AllTrim(request.getParameter("txtUACCOUNT")):"";
		strCMEMO = (request.getParameter("txtChequeMEMO") != null)?CommonUtil.AllTrim(request.getParameter("txtChequeMEMO")):"";
		strCBNo = (request.getParameter("txtCBNO") != null)?CommonUtil.AllTrim(request.getParameter("txtCBNO")):"";
		strC4User = (request.getParameter("txtC4User") != null)?CommonUtil.AllTrim(request.getParameter("txtC4User")):"";
		strCStatus = (request.getParameter("txtUpdateStatus") != null)?CommonUtil.AllTrim(request.getParameter("txtUpdateStatus")):"";
		strUPName = (request.getParameter("txtUPName") != null)?CommonUtil.AllTrim(request.getParameter("txtUPName")):"";
		strUPAMT = (request.getParameter("txtUPAMT") != null)?CommonUtil.AllTrim(request.getParameter("txtUPAMT")):"";
		strCHEQUE_DATE = (request.getParameter("txtCHEQUE_DATE") != null)?CommonUtil.AllTrim(request.getParameter("txtCHEQUE_DATE")):"";
		strCHEQUE_STATUS = (request.getParameter("txtCHEQUE_STATUS_HIDE") !=null)?CommonUtil.AllTrim(request.getParameter("txtCHEQUE_STATUS_HIDE")):"";

		/* 更新資料庫 */
		try {
			if (strReturnMsg.equals("")) 
				/* 更新票據明細檔 */
				strReturnMsg = updateCheckStatus(strCNo, strCBkNo, strCAccount, strCBNo, strCStatus, strCMEMO, iUpdDate, con, strC4User, strLogonUser, iUpdTime);
			if (strReturnMsg.equals("")) 
				/* 新增支付明細到支付主檔 */
				strReturnMsg = createNewPayment(iUpdDate, iUpdTime, strLogonUser,strUPName,strUPAMT,strCNo,strC4User,con);
			if (strReturnMsg.equals("")) 
				/* 產生異動分錄 */
				strReturnMsg = insertCapchaf(strCNo, strCHEQUE_STATUS, strCStatus, strCBkNo, strCHEQUE_DATE, strUPAMT, strLogonUser, "HS", iUpdDate, iUpdTime, con, strServiceBranch, strPlant);

			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
				request.setAttribute("txtMsg", "更新票據狀態為重開-->" + strReturnMsg + "(票號為" + strCNo + ")");
			} else {
				request.setAttribute("txtMsg", "更新票據狀態為重開成功(票號為" + strCNo + ")");
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("txtMsg", "更新票據狀態為重開失敗(票號為" + strCNo + ")-->" + e);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
	}
	
	private String updateCheckStatus(String strCNo, String strCBkNo, String strCAccount, String strCBNo, String strCStatus, String strCMEMO, int iUpdDate, Connection con, String strC4User, String strLogonUser, int iUpdTime) throws ServletException, IOException, SQLException {
		System.out.println("@@@inside updateCheckStatus");

		Statement stmtTmp = null;
		String strSql = ""; // SQL String
		String strReturnMsg = "";

		strSql = " update CAPCHKFHI  set CSTATUS='"+strCStatus+"',CASHDT="+iUpdDate+",CHG4USER='"+strC4User+"'";
		strSql += " where CNO ='"+strCNo+"'  AND CBKNO='"+strCBkNo+"' AND CACCOUNT='"+strCAccount+"' AND CBNO='"+strCBNo+"' ";
		System.out.println("updateHICheckStatus strSql=" + strSql);
		stmtTmp = con.createStatement();

		if (stmtTmp.executeUpdate(strSql) < 1) {
			strReturnMsg = "更新票據狀態失敗";
		}
		stmtTmp.close();

		return strReturnMsg;
	}

	private String createNewPayment(int iUpdDate, int iUpdTime, String strLogonUser,String strUPName,String strPAMT,String strCNo,String strC4User, Connection con) throws ServletException, IOException, SQLException {
		System.out.println("inside createNewPayment");

		String strSql = ""; // SQL String
		String strReturnMsg = "";

		Hashtable htReturnInfo = new Hashtable();
		String strNewPNo = ""; //支付序號
		String strPMEMO = "歷史票據號碼="+strCNo;
		String strPDESC = CommonUtil.AllTrim(disbBean.getETableDesc("PAYCD", "HS")).substring(0, 7);

		/* 新增到支付主檔 */
		strSql = " insert into  CAPPAYF "
				+ " (PNO,PMETHOD,PDATE,PNAME,PSNAME,PCURR,PAMT,PDESC,PSRCGP,PSRCCODE,PCHKM1,PCHKM2,ENTRYDT,ENTRYTM,ENTRYUSR,MEMO,PAMTNT) "
				+ " VALUES (?,'A',?,?,?,'NT',?,?,'WB','HS','Y','Y',?,?,?,?,?)";

		
		htReturnInfo = (Hashtable) disbBean.getDISBSeqNo("DISB", strLogonUser, con);/* 取得新的支付序號 */
		strReturnMsg = (String) htReturnInfo.get("ReturnMsg");
		if (strReturnMsg.equals("")) {
			strNewPNo = (String) htReturnInfo.get("ReturnValue");
			PreparedStatement pstmtTmp = con.prepareStatement(strSql);
			pstmtTmp.setString(1, strNewPNo);
			pstmtTmp.setInt(2, iUpdDate);
			pstmtTmp.setString(3, strUPName);
			pstmtTmp.setString(4, strUPName);
			pstmtTmp.setDouble(5, Double.parseDouble(strPAMT));
			pstmtTmp.setString(6, strPDESC);
			pstmtTmp.setInt(7, iUpdDate);
			pstmtTmp.setInt(8, iUpdTime);
			pstmtTmp.setString(9, strC4User);
			pstmtTmp.setString(10, strPMEMO);
			pstmtTmp.setDouble(11, Double.parseDouble(strPAMT));

			if (pstmtTmp.executeUpdate() != 1) {
				strReturnMsg = "新增支付資料到支付主檔失敗";
			}

			pstmtTmp.close();
			htReturnInfo = null;
		}

		return strReturnMsg;
	}

	private String insertCapchaf(String strCNo, String strOldStatus, String strNewStatus, String strBankCode, String strChequeDtU, String strCAmt, String strLogonUser, String PsrCd, int iUpdDate, int iUpdTime, Connection con, String ServiceBranch, String strPlant) throws Exception {
		System.out.println("inside insertCapchaf");
		String strSql = ""; // SQL String
		String strReturnMsg = "";
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("yyyyMMdd");

		String strACTCD2D = "";
		String strACTCD2C = "";
		String strACTCD3D = "0000";
		String strACTCD3C = "0000";
		String strACTCD4D = "00";
		String strACTCD4C = "00";
		String strDesc = strCNo + "(" + strOldStatus + "-->" + strNewStatus + ")";

		double dCAmt = Double.parseDouble(strCAmt);
		String strCheqDtTemp = strChequeDtU;
		if (strCheqDtTemp.length() < 7)
			strCheqDtTemp = "0" + strCheqDtTemp;

		int iStatusDT = iUpdDate + 19110000;
		String strStatusDT = Integer.toString(iStatusDT);
		String DateTemp1 = strStatusDT.substring(0, 4) + "/" + strStatusDT.substring(4, 6) + "/" + strStatusDT.substring(6, 8);

		if (strOldStatus.equals("2")) {
			if (strNewStatus.equals("4")) {
				strACTCD2D = "79440190ZZZ";
				strACTCD2C = "29004000ZZZ";
			}

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

			//R00135 支票到期日≧民國98/3/1且逾二年 依支付原因代碼對應會計科目
			if(monthDif >= 24 && Integer.parseInt(strCheqDtTemp) >= 980301 )
			{
				try {
					strEtabTemp = disbBean.getETableDesc("ORAL4", ServiceBranch);
					strDept = strEtabTemp.substring(2, 4);
					strChannel = strEtabTemp.substring(0, 1);
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

				if(strNewStatus.equals("4") || strNewStatus.equals("V")) {
					strACTCD2D = strMainAcct + strChannel + strLOB + "ZZZ";
					strACTCD4D = strDept;
				} else {
					strACTCD2C = strMainAcct + strChannel + strLOB + "ZZZ";
					strACTCD4C = strDept;
				}
			}
		}

		strSql = " insert into  CAPCHAF "
				+ " (CATEG,ACNTSOUR,ACNTCURR,ACTCD1,ACTCD2,ACTCD3,ACTCD4,ACTCD5,DATE1,CREAMT,DEBAMT,SLIPNO,DESPTXT1,ENTRYDT,"
				+ "ENTRYTM,ENTRYUSR,CONVTYPE,CONVRATE,BATCHNAME)"
				+ " VALUES ('Manual','Spreadsheet','TWD','0',?,?,?,'00000000000000000000000000',?,?,?,?,?,?,?,?,'User','1      ',?)";

		disbBean = new DISBBean(dbFactory);

		try {
			/* 新增一筆借方資料 */

			PreparedStatement pstmtTmpD = con.prepareStatement(strSql);
			pstmtTmpD.setString(1, strACTCD2D);
			pstmtTmpD.setString(2, strACTCD3D);
			pstmtTmpD.setString(3, strACTCD4D);
			pstmtTmpD.setString(4, DateTemp1);
			pstmtTmpD.setDouble(5, 0);
			pstmtTmpD.setDouble(6, dCAmt);
			pstmtTmpD.setString(7, DateTemp1.substring(2, 4) + DateTemp1.substring(5, 7) + DateTemp1.substring(8) + "002" + "TWD   ");
			pstmtTmpD.setString(8, strDesc);
			pstmtTmpD.setInt(9, iUpdDate);
			pstmtTmpD.setInt(10, iUpdTime);
			pstmtTmpD.setString(11, strLogonUser);
			pstmtTmpD.setString(12, DateTemp1.substring(2, 4) + DateTemp1.substring(5, 7) + DateTemp1.substring(8) + "002" + "TWD   ");

			if (pstmtTmpD.executeUpdate() != 1) {
				strReturnMsg = "新增借方資料失敗";
			} else {
				/* 新增一筆貸方資料 */
				PreparedStatement pstmtTmpC = con.prepareStatement(strSql);
				pstmtTmpC.setString(1, strACTCD2C);
				pstmtTmpC.setString(2, strACTCD3C);
				pstmtTmpC.setString(3, strACTCD4C);
				pstmtTmpC.setString(4, DateTemp1);
				pstmtTmpC.setDouble(5, dCAmt);
				pstmtTmpC.setDouble(6, 0);
				pstmtTmpC.setString(7, DateTemp1.substring(2, 4) + DateTemp1.substring(5, 7) + DateTemp1.substring(8) + "002" + "TWD   ");
				pstmtTmpC.setString(8, strDesc);
				pstmtTmpC.setInt(9, iUpdDate);
				pstmtTmpC.setInt(10, iUpdTime);
				pstmtTmpC.setString(11, strLogonUser);
				pstmtTmpC.setString(12, DateTemp1.substring(2, 4) + DateTemp1.substring(5, 7) + DateTemp1.substring(8) + "002" + "TWD   ");

				if (pstmtTmpC.executeUpdate() != 1) {
					strReturnMsg = "新增貸方資料失敗";
				}
				pstmtTmpC.close();
			}
			pstmtTmpD.close();
		} catch (SQLException e) {
			strReturnMsg += e;
			System.err.println("strReturnMsg=" + strReturnMsg);
		} catch (Exception ex) {
			strReturnMsg = "新增借貸方資料失敗:" + ex;
		}
		return strReturnMsg;
	}

}
