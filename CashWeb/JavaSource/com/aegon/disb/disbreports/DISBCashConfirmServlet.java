package com.aegon.disb.disbreports;

import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * System   : CashWeb
 * 
 * Function : 現金支付
 * 
 * Remark   : 出納功能
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $$Date: 2014/07/18 07:17:51 $$
 * 
 * Request ID : RB0302
 * 
 * CVS History:
 * 
 * $$Log: DISBCashConfirmServlet.java,v $
 * $Revision 1.2  2014/07/18 07:17:51  misariel
 * $EC0342-RC0036新增分公司行政人員使用CAPSIL
 * $
 * $Revision 1.1  2013/12/18 07:22:52  MISSALLY
 * $RB0302---新增付款方式現金
 * $$
 *  
 */

public class DISBCashConfirmServlet extends InitDBServlet {

	private static final long serialVersionUID = 6004644124210565207L;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

	private String path = "";

	public DISBCashConfirmServlet() {
        super();
    }

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);

		if ("I".equals(request.getParameter("txtAction"))) {
			query(request, response);
		} else if ("H".equals(request.getParameter("txtAction"))) {
			update(request, response);
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	private void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String strDateS = request.getParameter("txtStartDate");
		String strDateE = request.getParameter("txtEndDate");
		String strDispatch = request.getParameter("pDispatch");
		String strCurrency = request.getParameter("selCurrency");
		String strUsrDept = request.getParameter("selUsrDept");//RC0036		

//RC0036		String strSql = "SELECT a.PNO,a.PMETHOD,a.PDATE,a.PNAME,a.PID,a.PCURR,a.PAMT,a.PSRCCODE,a.POLICYNO,a.APPNO,a.PDISPATCH,a.PVOIDABLE,substring(et.FLD0004,8,6) as PDESC ";
/*RC0036*/
		String strSql = "SELECT a.PNO,a.PMETHOD,a.PDATE,a.PNAME,a.PID,a.PCURR,a.PAMT,a.PSRCCODE,a.POLICYNO,a.APPNO,a.PDISPATCH,a.PVOIDABLE,substring(et.FLD0004,8,6) as PDESC,USR.DEPT as USRDEPT ";
		strSql += "FROM CAPPAYF a ";
		strSql += "JOIN ORDUET et on et.FLD0001='  ' and et.FLD0002='PAYCD' and et.FLD0003=a.PSRCCODE ";
		strSql += "JOIN USER USR on USR.USRID = a.PAY_CONFIRM_USER1 ";//RC0036
		strSql += "WHERE a.PMETHOD='E' and a.PCFMDT1>0 and a.PCFMUSR1<>'' and a.PCFMDT2>0 and a.PCFMUSR2<>'' ";
		strSql += " and a.PSTATUS='' and a.PVOIDABLE<>'Y' and a.PAMT>0 ";
		strSql += " and a.PCFMDT2 between " + strDateS + " and " + strDateE + " ";
		strSql += " and a.PDISPATCH='" + strDispatch + "' ";
		strSql += " and a.PCURR='" + strCurrency + "' ";
		strSql += " and USR.DEPT='" + strUsrDept + "' ";//RC0036		
		strSql += " ORDER BY a.POLICYNO ";
		System.out.println("DISBCashConfirmServlet.querySql=" + strSql);

		Connection con = null;
		Statement stmt = null;
		ResultSet rst = null;
		DISBPaymentDetailVO objPDetailVO = null;
		List<DISBPaymentDetailVO> alPDetail = new ArrayList<DISBPaymentDetailVO>();

		try {
			con = dbFactory.getAS400Connection("DISBCashConfirmServlet.query");
			stmt = con.createStatement();
			rst = stmt.executeQuery(strSql);

			while(rst.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rst.getString("PNO")); // 支付序號
				objPDetailVO.setStrPMethod(rst.getString("PMETHOD"));// 付款方式
				objPDetailVO.setIPDate(rst.getInt("PDATE")); // 付款日期
				objPDetailVO.setStrPName(rst.getString("PNAME"));// 受款人姓名
				objPDetailVO.setStrPId(rst.getString("PID")); // 受款人ID
				objPDetailVO.setStrPCurr(rst.getString("PCURR"));
				objPDetailVO.setIPAMT(rst.getDouble("PAMT")); // 支付金額
				objPDetailVO.setStrPSrcCode(rst.getString("PSRCCODE"));// 支付原因代碼
				objPDetailVO.setStrPolicyNo(rst.getString("POLICYNO"));// 保單號碼
				objPDetailVO.setStrAppNo(rst.getString("APPNO"));// 要保書號碼
				objPDetailVO.setStrPDispatch(rst.getString("PDISPATCH"));// 急件否
				objPDetailVO.setStrPVoidable(rst.getString("PVOIDABLE"));// 作廢否
				objPDetailVO.setStrPDesc(rst.getString("PDESC")); // 支付描述
				objPDetailVO.setStrUsrDept(rst.getString("USRDEPT")); // RC0036 承辦單位
				alPDetail.add(objPDetailVO);
			}

			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				request.setAttribute("PDetailListTemp", alPDetail);
				path = "/DISB/DISBReports/DISBCashConfirmList.jsp";
			} else {
				request.setAttribute("txtMsg", "查無相關資料");
				path = "/DISB/DISBReports/DISBCashConfirmInq.jsp";
			}

		} catch (Exception ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alPDetail = null;
		} finally {
			try {
				if (rst != null) {
					rst.close();
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
	}

	private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		path = "/DISB/DISBReports/DISBCashConfirmInq.jsp";

		String strDate = request.getParameter("txtPCSHCM");
		String strBank = request.getParameter("txtPBBank");
		String strAccount = request.getParameter("txtPBAccount");

		String[] strPNO = request.getParameterValues("PNO");
		String strPAmt = request.getParameter("PAMT");

		//step 1:更新CAPPAYF的付款狀態PSTATUS='B'
		String strSql = "UPDATE CAPPAYF SET PSTATUS='B',PBBANK=?,PBACCOUNT=?,PCSHDT=?,PCSHCM=?,UPDDT=?,UPDTM=?,UPDUSR=? WHERE PNO=? ";
		System.out.println("DISBCashConfirmServlet.updateSql=" + strSql);

		Connection con = null;
		PreparedStatement pstmt = null;

		HttpSession session = request.getSession(true);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdf = new SimpleDateFormat("HHmmss");
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

		int rowCount = 0;
		double totalAmt = Double.parseDouble(strPAmt);

		try {
			int iUpdDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
			int iUpdTime = Integer.parseInt(sdf.format(cldToday.getTime()));
			String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

			con = dbFactory.getAS400Connection("DISBCashConfirmServlet.update");
			pstmt = con.prepareStatement(strSql);

			String strMsg = "";
			for(int index=0; index<strPNO.length; index++) {

				strMsg = disbBean.insertCAPPAYFLOG(strPNO[index],strLogonUser,iUpdDate,iUpdTime,con);
				if(strMsg.equals("")) {
					pstmt.clearParameters();
					pstmt.setString(1, strBank);
					pstmt.setString(2, strAccount);
					pstmt.setInt(3, iUpdDate);
					pstmt.setInt(4, Integer.parseInt(strDate));
					pstmt.setInt(5, iUpdDate);
					pstmt.setInt(6, iUpdTime);
					pstmt.setString(7, strLogonUser);
					pstmt.setString(8, strPNO[index]);
					pstmt.executeUpdate();

					rowCount++;
					strMsg = "資料更新成功!!";
				} else {
					strMsg = "資料更新失敗!!";
				}
			}

			request.setAttribute("txtMsg", strMsg);
			request.setAttribute("rowCount", String.valueOf(rowCount));
			request.setAttribute("totalAmt", String.valueOf(totalAmt));

		} catch (Exception ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			} catch (Exception ex1) {
			}
		}
	}
}
