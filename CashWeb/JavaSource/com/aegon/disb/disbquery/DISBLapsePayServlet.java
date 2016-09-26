package com.aegon.disb.disbquery;


import java.io.IOException;
import java.sql.Connection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.LapsePaymentVO;

/**
 * System   : CashWeb
 * 
 * Function : 失效給付通知書工作檔維護
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.1 $$
 * 
 * Author   : zhejun.he
 * 
 * Create Date : 2013/03/13
 * 
 * Request ID : R10190-P10011
 * 
 * CVS History:
 * 
 * $$Log: DISBLapsePayServlet.java,v $
 * $Revision 1.1  2013/05/02 11:07:05  MISSALLY
 * $R10190 美元失效保單作業
 * $$
 *  
 */

public class DISBLapsePayServlet extends InitDBServlet {

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

	private String path = "";

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		String strAction = request.getParameter("txtAction"); // 取得頁面動作

		if (strAction.equals("S")) { // 儲存
			save(request, response);
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	private void save(HttpServletRequest request, HttpServletResponse response) 
	{
		path = "/DISB/DISBQuery/DISBLapsePayMaintain.jsp";

		String strPno = (request.getParameter("txtUPno") != null) ? CommonUtil.AllTrim(request.getParameter("txtUPno")) : "";
		String strPono = (request.getParameter("txtUPoid") != null) ? CommonUtil.AllTrim(request.getParameter("txtUPoid")) : "";
		String strRecId = (request.getParameter("txtUPbenid") != null) ? CommonUtil.AllTrim(request.getParameter("txtUPbenid")) : "";
		String strRecNM = (request.getParameter("txtUPbenName") != null) ? CommonUtil.AllTrim(request.getParameter("txtUPbenName")) : "";
		String strAmt = (request.getParameter("txtUPamt") != null) ? CommonUtil.AllTrim(request.getParameter("txtUPamt")) : "";
		String strRDT = (request.getParameter("txtUProcDate") != null) ? CommonUtil.AllTrim(request.getParameter("txtUProcDate")) : "";
		String strSDT = (request.getParameter("txtUSendDate") != null) ? CommonUtil.AllTrim(request.getParameter("txtUSendDate")) : "";
		String strRF = (request.getParameter("txtURercv") != null) ? CommonUtil.AllTrim(request.getParameter("txtURercv")) : "";
		String strSend = (request.getParameter("txtUSend") != null) ? CommonUtil.AllTrim(request.getParameter("txtUSend")) : "";
		String strUserId = (request.getParameter("txtUserId") != null) ? CommonUtil.AllTrim(request.getParameter("txtUserId")) : "";

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(commonUtil.getBizDateByRCalendar().getTime()));
		
		String strMsg = "";
		Connection conn = null;
		try {
			LapsePaymentVO lapsePayVO = new LapsePaymentVO();
			lapsePayVO.setPNO(strPno);			//支付序號
			lapsePayVO.setPolicyNo(strPono);	//保單號碼
			lapsePayVO.setReceiverId(strRecId);	//受款人ID
			lapsePayVO.setReceiverName(strRecNM);//受款人姓名
			lapsePayVO.setPaymentAmt(Double.parseDouble(strAmt));//給付金額
			lapsePayVO.setRemitDate(Integer.parseInt(strRDT));	//出納確認日
			lapsePayVO.setSendSwitch(strSend);					//是否寄送
			lapsePayVO.setRemitFailed(strRF);					//已寄送，但退匯
			lapsePayVO.setSendDate(Integer.parseInt(strSDT));	//寄送日期
			lapsePayVO.setUpdatedUser(strUserId);				//異動者
			lapsePayVO.setUpdatedDate(iUpdDate);				//異動日期

			DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
			conn = dbFactory.getAS400Connection("DISBLapsePayServlet.save");
			disbBean.callCAP0314O(conn, lapsePayVO);

			strMsg = "更新成功.";
		} catch (Exception e) {
			strMsg = "更新失敗.";
			e.printStackTrace();
		} finally {
			if(conn != null) dbFactory.releaseAS400Connection(conn);
			request.setAttribute("txtMsg", strMsg);
		}
	}

}
