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
 * Function : ���ĵ��I�q���Ѥu�@�ɺ��@
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
 * $R10190 �������īO��@�~
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
		String strAction = request.getParameter("txtAction"); // ���o�����ʧ@

		if (strAction.equals("S")) { // �x�s
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
			lapsePayVO.setPNO(strPno);			//��I�Ǹ�
			lapsePayVO.setPolicyNo(strPono);	//�O�渹�X
			lapsePayVO.setReceiverId(strRecId);	//���ڤHID
			lapsePayVO.setReceiverName(strRecNM);//���ڤH�m�W
			lapsePayVO.setPaymentAmt(Double.parseDouble(strAmt));//���I���B
			lapsePayVO.setRemitDate(Integer.parseInt(strRDT));	//�X�ǽT�{��
			lapsePayVO.setSendSwitch(strSend);					//�O�_�H�e
			lapsePayVO.setRemitFailed(strRF);					//�w�H�e�A���h��
			lapsePayVO.setSendDate(Integer.parseInt(strSDT));	//�H�e���
			lapsePayVO.setUpdatedUser(strUserId);				//���ʪ�
			lapsePayVO.setUpdatedDate(iUpdDate);				//���ʤ��

			DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
			conn = dbFactory.getAS400Connection("DISBLapsePayServlet.save");
			disbBean.callCAP0314O(conn, lapsePayVO);

			strMsg = "��s���\.";
		} catch (Exception e) {
			strMsg = "��s����.";
			e.printStackTrace();
		} finally {
			if(conn != null) dbFactory.releaseAS400Connection(conn);
			request.setAttribute("txtMsg", strMsg);
		}
	}

}
