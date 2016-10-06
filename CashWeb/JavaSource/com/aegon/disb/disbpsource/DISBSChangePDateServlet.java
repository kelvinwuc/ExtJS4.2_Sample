package com.aegon.disb.disbpsource;

/**
 * System   : CASHWEB
 * 
 * Function : 因應農曆過年假期較長，付款日為假期期間的支付案件提早給付
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.5 $$
 * 
 * Author   : Sally
 * 
 * Create Date : 2012/01/06
 * 
 * Request ID : E10210
 * 
 * CVS History:
 * 
 * $$Log: DISBSChangePDateServlet.java,v $
 * $Revision 1.5  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.3  2013/01/08 04:24:04  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.1.4.1  2012/10/31 06:07:23  MISSALLY
 * $EA0152 --- VFL PHASE 4
 * $
 * $Revision 1.1  2012/01/11 07:02:38  MISSALLY
 * $E10210
 * $修改CASH系統，因BATCH所產生各項給付金的付款日
 * $$
 *  
 */

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

public class DISBSChangePDateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private String path = "";

	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON) != null) {
			globalEnviron = (GlobalEnviron) getServletContext().getAttribute(Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
		}
		commonUtil = new CommonUtil(globalEnviron);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strUserRight = (String) session.getAttribute(Constant.LOGON_USER_RIGHT);

		/* 權限控管 */
		if(strUserRight.equals("79"))
		{
			request.setAttribute("txtMsg", "無執行此功能權限!!");
			path = "/DISB/DISBPSource/DISBChangePDateC.jsp";
		}
		else
		{
			String strAction = (request.getParameter("action") != null) ? CommonUtil.AllTrim(request.getParameter("action")) : "";

			try {
				if(strAction.equalsIgnoreCase("query")) {
					inquery(request, response);
				} else if(strAction.equalsIgnoreCase("update")) {
					update(request, response);
				} else {
					System.err.println("Unknow action!!");
				}

			} catch(Exception ex) {
				System.err.println(ex);
			}
		}
		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	private void inquery(HttpServletRequest request, HttpServletResponse response) {
		/* 接參數 */
		String strFromBatch = (request.getParameter("rdFromBatch") != null) ? CommonUtil.AllTrim(request.getParameter("rdFromBatch")) : "";
		String strPMethod = (request.getParameter("selPMethod") != null) ? CommonUtil.AllTrim(request.getParameter("selPMethod")) : "";
		String strPDateS = (request.getParameter("txtPStartDate") != null) ? CommonUtil.AllTrim(request.getParameter("txtPStartDate")) : "";
		String strPDateE = (request.getParameter("txtPEndDate") != null) ? CommonUtil.AllTrim(request.getParameter("txtPEndDate")) : "";

		int iPDateS = (!strPDateS.equals("")) ? Integer.parseInt(strPDateS) : 0;
		int iPDateE = (!strPDateE.equals("")) ? Integer.parseInt(strPDateE) : 0;
		
		String strSql = "SELECT PNO,PMETHOD,PDATE,PNAME,PID,PCURR,PAMT,PSRCCODE,PDESC,POLICYNO ";
		strSql += "FROM CAPPAYF ";
		strSql += "WHERE PCFMDT2=0 AND PCFMTM2=0 AND PCFMUSR2='' AND ";		//支付尚未確認
		strSql += "PVOIDABLE='' AND ";										//未作廢
		if(!strFromBatch.equals("")) {
			//BATCH作業
			if(strFromBatch.equalsIgnoreCase("Y")) {
				strSql += "PSRCCODE IN (" + Constant.Batch_PAY_SRCCODE + ",'BK') AND ";
			} else {
			//線上作業
				strSql += "PSRCCODE NOT IN (" + Constant.Batch_PAY_SRCCODE + ",'BK') AND ";
			}
		}
		strSql += "PMETHOD=? AND PDATE BETWEEN ? AND ? ";
		strSql += "ORDER BY PDATE,PID,PNAME,POLICYNO,PSRCCODE ";
		System.out.println(strSql);

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rst = null;

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();
		try {
			con = dbFactory.getAS400Connection("DISBSChangePDateServlet.inquery");
			pstmt = con.prepareStatement(strSql);
			pstmt.setString(1, strPMethod);
			pstmt.setInt(2, iPDateS);
			pstmt.setInt(3, iPDateE);
			rst = pstmt.executeQuery();

			while(rst.next()) 
			{
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(CommonUtil.AllTrim(rst.getString("PNO")));			//支付序號
				objPDetailVO.setStrPMethod(CommonUtil.AllTrim(rst.getString("PMETHOD")));	//付款方式
				objPDetailVO.setStrPDate(CommonUtil.AllTrim(rst.getString("PDATE")));		//付款日期
				objPDetailVO.setStrPName(CommonUtil.AllTrim(rst.getString("PNAME")));		//受款人姓名
				objPDetailVO.setStrPId(CommonUtil.AllTrim(rst.getString("PID")));			//受款人ID
				objPDetailVO.setStrPCurr(CommonUtil.AllTrim(rst.getString("PCURR")));		//幣別
				objPDetailVO.setIPAMT(rst.getDouble("PAMT"));								//支付金額
				objPDetailVO.setStrPSrcCode(CommonUtil.AllTrim(rst.getString("PSRCCODE")));	//支付原因代碼
				objPDetailVO.setStrPDesc(CommonUtil.AllTrim(rst.getString("PDESC")));		//支付描述
				objPDetailVO.setStrPolicyNo(CommonUtil.AllTrim(rst.getString("POLICYNO")));	//保單號碼

				alPDetail.add(objPDetailVO);
			}

			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				request.setAttribute("PDetailList", alPDetail);
				path = "/DISB/DISBPSource/DISBChangePDateS.jsp";
			} else {
				request.setAttribute("txtMsg", "查無相關資料");
				path = "/DISB/DISBPSource/DISBChangePDateC.jsp";
			}

		} catch(Exception ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			path = "/DISB/DISBPSource/DISBChangePDateC.jsp";
			System.err.println(ex);
		} finally {
			try { if(rst != null) rst.close(); } catch(Exception ex) { }
			try { if(pstmt != null) pstmt.close(); } catch(Exception ex) { }
			try { if(con != null) dbFactory.releaseAS400Connection(con); } catch(Exception ex) { }
		}

	}

	private void update(HttpServletRequest request, HttpServletResponse response) {
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		int updateDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int updateTime = Integer.parseInt((new SimpleDateFormat("HHmmss")).format(cldToday.getTime()));
		String logonUser = (String) request.getSession().getAttribute(Constant.LOGON_USER_ID);

		DISBBean disbBean = new DISBBean(dbFactory);

		/* 接參數 */
		String strPayDate = (request.getParameter("txtPayDate") != null) ? CommonUtil.AllTrim(request.getParameter("txtPayDate")) : "";
		String[] aryPNO = request.getParameterValues("PNO");

		String strSql = "UPDATE CAPPAYF SET PDATE=?,UPDDT=?,UPDTM =?,UPDUSR=? WHERE PNO=? ";

		if(aryPNO != null)
		{
			Connection con = null;
			PreparedStatement pstmt = null;

			String strMsg = "";
			String strPNO = "";

			try {
				con = dbFactory.getAS400Connection("DISBSChangePDateServlet.update");
				pstmt = con.prepareStatement(strSql);

				String tmpPNO = "";
				for(int i=0; i<aryPNO.length; i++) {
					tmpPNO = aryPNO[i];
					try {
						/* 寫入LOG檔 */
						strMsg = disbBean.insertCAPPAYFLOG(tmpPNO, logonUser, updateDate, updateTime, con);
						if(strMsg.equals("")) {
							/* 更新欄位 */
							pstmt.clearParameters();
							pstmt.setString(1, strPayDate);
							pstmt.setInt(2, updateDate);
							pstmt.setInt(3, updateTime);
							pstmt.setString(4, logonUser);
							pstmt.setString(5, tmpPNO);
							pstmt.executeUpdate();
						}
					} catch(Exception ex) {
						System.err.println(ex);
						strMsg += "支付序號["+tmpPNO+"]更新失敗!/n/r";
					}
					strPNO += ",'" + tmpPNO + "'";
				}
			} catch(Exception ex) {
				System.err.println(ex);
			} finally {
				try { if(pstmt != null) pstmt.close(); } catch(Exception ex) { }
				try { if(con != null) dbFactory.releaseAS400Connection(con); } catch(Exception ex) { }
			}

			request.setAttribute("txtMsg", strMsg);
			request.setAttribute("txtAction", "Report");
			request.setAttribute("aryPNO", strPNO);
			path = "/DISB/DISBPSource/DISBChangePDateC.jsp";
		} else {
			request.setAttribute("txtMsg", "請勾選欲修改的保單!");
			path = "/DISB/DISBPSource/DISBChangePDateC.jsp";
		}
	}
}
