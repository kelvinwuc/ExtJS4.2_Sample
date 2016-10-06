package com.aegon.bankinfo;

import java.io.IOException;
import java.sql.Connection;
import java.util.Calendar;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;

/**
 * System   : CashWeb
 * 
 * Function : 金融單位資料維護
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.1 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $$Date: 2013/12/24 02:14:03 $$
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * RD0382-OIU專案:20150909,Kelvin Wu,新增【帳戶所屬公司別】
 * 
 * $$Log: BankInfoServlet.java,v $
 * $Revision 1.1  2013/12/24 02:14:03  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $$
 *  
 */

public class BankInfoServlet extends InitDBServlet {

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		HttpSession session = request.getSession(true);

		String strAction = CommonUtil.AllTrim(request.getParameter("txtAction"));
		RequestDispatcher dispatcher = null;
		Connection conn = null;

		String returnMsg = "";

		try {

			String BankCode = CommonUtil.AllTrim(request.getParameter("txtBkCode"));
			String BankAccount = CommonUtil.AllTrim(request.getParameter("txtBkAtNo"));
			String BankGlAct = CommonUtil.AllTrim(request.getParameter("txtGlAct"));
			String BankCurr = CommonUtil.AllTrim(request.getParameter("txtBkCurr"));

			String BankName = CommonUtil.AllTrim(request.getParameter("txtBkName"));
			String BankAlat = CommonUtil.AllTrim(request.getParameter("txtBkAlat"));
			String BankCred = CommonUtil.AllTrim(request.getParameter("txtBkCred"));
			String BankPacb = CommonUtil.AllTrim(request.getParameter("txtBkPacb"));
			String BankBatc = CommonUtil.AllTrim(request.getParameter("txtBkBatc"));
			String BankGpCd = CommonUtil.AllTrim(request.getParameter("txtBkGpCd"));
			String BankSpec = CommonUtil.AllTrim(request.getParameter("txtBkSpEc"));
			String BankStatus = CommonUtil.AllTrim(request.getParameter("txtBkStAt"));
			String BankMemo = CommonUtil.AllTrim(request.getParameter("txtBkMeMo"));
			String companyType = CommonUtil.AllTrim(request.getParameter("txtCompanyType"));

			CapbnkfVO vo = new CapbnkfVO();
			vo.setBankCode(BankCode);
			vo.setBankAccount(BankAccount);
			vo.setBankGlAct(BankGlAct); 
			vo.setBankCurr(BankCurr);

			conn = dbFactory.getAS400Connection("BankInfoServlet");
			BankInfoDAO dao = new BankInfoDAO();
			dao.setConnection(conn);

			String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
			String strUpdDate = strDateTime.substring(0, 7);
			String strUpdTime = strDateTime.substring(7);
			String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

			if (strAction.equals("A")) {

				vo = dao.query(vo);
				if(vo != null) {
					returnMsg = "金融單位代碼:" + BankCode + ", 金融單位帳號:" + BankAccount + ", 會計科目:" + BankGlAct + ", 幣別:" + BankCurr + " 已存在於資料庫中!!";
				} else {
					vo = new CapbnkfVO();
					vo.setBankCode(BankCode);
					vo.setBankAccount(BankAccount);
					vo.setBankGlAct(BankGlAct); 
					vo.setBankCurr(BankCurr);
					vo.setBankName(BankName);
					vo.setBankAlat(BankAlat);
					vo.setBankCred(BankCred);
					vo.setBankPacb(BankPacb);
					vo.setBankBatc(BankBatc);
					vo.setBankGpCd(BankGpCd);
					vo.setBankSpec(BankSpec);
					vo.setBankStatus(BankStatus);
					vo.setBankMemo(BankMemo);
					vo.setCreateDate(strUpdDate);
					vo.setCreateTime(strUpdTime);
					vo.setCreateUser(strLogonUser);
					vo.setCompanyType(companyType);//RD0382

					if(dao.insert(vo)) {
						returnMsg = "'" + BankCode + "' '" + BankAccount + "' '" + BankCurr + "' '" + BankGlAct + "' '" + "新增完成";
						request.removeAttribute("bankVo");
						request.setAttribute("bankVo", vo);
					} else {
						returnMsg = "新增失敗";
					}
				}

			} else if (strAction.equals("U")) {

				vo = dao.query(vo);
				if(vo == null) {
					returnMsg = "金融單位代碼:" + BankCode + ", 金融單位帳號:" + BankAccount + ", 會計科目:" + BankGlAct + ", 幣別:" + BankCurr + " 未存在於資料庫中!!";
				} else {
					vo.setBankName(BankName);
					vo.setBankAlat(BankAlat);
					vo.setBankCred(BankCred);
					vo.setBankPacb(BankPacb);
					vo.setBankBatc(BankBatc);
					vo.setBankGpCd(BankGpCd);
					vo.setBankSpec(BankSpec);
					vo.setBankStatus(BankStatus);
					vo.setBankMemo(BankMemo);
					vo.setUpdatedDate(strUpdDate);
					vo.setUpdatedTime(strUpdTime);
					vo.setUpdatedUser(strLogonUser);
					vo.setCompanyType(companyType);//RD0382

					if(dao.update(vo)) {
						returnMsg = "'" + BankCode + "' '" + BankAccount + "' '" + BankCurr + "' '" + BankGlAct + "' '" + "修改完成";
						request.removeAttribute("bankVo");
						request.setAttribute("bankVo", vo);
					} else {
						returnMsg = "修改失敗";
					}
				}

			} else if (strAction.equals("D")) {

				vo = dao.query(vo);
				if(vo == null) {
					returnMsg = "金融單位代碼:" + BankCode + ", 金融單位帳號:" + BankAccount + ", 會計科目:" + BankGlAct + ", 幣別:" + BankCurr + " 未存在於資料庫中!!";
				} else {
					if(dao.delete(vo)) {
						returnMsg = "'" + BankCode + "' '" + BankAccount + "' '" + BankCurr + "' '" + BankGlAct + "' '" + "刪除完成";
						request.removeAttribute("bankVo");
						request.setAttribute("bankVo", vo);
					} else {
						returnMsg = "刪除失敗";
					}
				}

			} else {
				System.err.println("BankInfoServlet, that's not a valid UseCase!");
			}
		} catch (Exception e) {
			System.err.println("BankInfoServlet Application Exception >>> " + e);
			if(conn != null) dbFactory.releaseAS400Connection(conn);
		} finally {
			if(conn != null) dbFactory.releaseAS400Connection(conn);

			request.setAttribute("txtMsg", returnMsg);
			dispatcher = request.getRequestDispatcher("/BankInfo/BankInfoC.jsp");
			dispatcher.forward(request, response);
		}
	}

}