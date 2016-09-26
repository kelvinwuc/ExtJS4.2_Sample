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
 * Function : 支付確認
 * 
 * Remark   : 支付功能
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
 * $RB0302---新增付款方式現金
 * $
 * $Revision 1.15  2013/05/30 02:03:54  MISSALLY
 * $RA0064-CMP專案CASH配合修改
 * $
 * $Revision 1.14  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.12  2013/01/08 04:24:05  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.10.4.1  2012/12/06 06:28:29  MISSALLY
 * $RA0102　PA0041
 * $配合法令修改酬佣支付作業
 * $
 * $Revision 1.10  2011/05/12 06:20:19  MISJIMMY
 * $R00440 SN滿期金
 * $
 * $Revision 1.9  2010/11/23 06:45:20  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.8  2009/08/31 01:59:32  missteven
 * $R90380 新增CASH報表及傳票功能
 * $
 * $Revision 1.7  2009/04/01 08:19:55  missteven
 * $R90274_支付確認無需選擇來源群組，即可帶出FF支付明細
 * $
 * $Revision 1.6  2007/09/07 10:20:26  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.5  2007/04/13 09:43:15  MISVANESSA
 * $R70292_配息支票件規則改變
 * $
 * $Revision 1.4  2007/03/06 01:40:49  MISVANESSA
 * $R70088_SPUL配息支票件需同於匯款,於付款日才能確認
 * $
 * $Revision 1.3  2007/01/04 03:12:43  MISVANESSA
 * $R60550_新增SHOW外幣幣別.金額
 * $
 * $Revision 1.2  2006/12/07 10:11:39  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.1  2006/06/29 09:40:15  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.15  2006/04/27 09:16:11  misangel
 * $R50891:VA美元保單-顯示幣別
 * $
 * $Revision 1.1.2.14  2005/08/02 02:31:58  misangel
 * $Q50285: 
 * $付款日期規則:
 * $1.急件:若原始付款日期小於付款日期(參數),則以付款日期 = 付款日期(參數)
 * $2.非急件:若原始付款日期小於輸入迄日(參數),則以付款日期 = 輸入迄日(參數)
 * $
 * $Revision 1.1.2.12  2005/04/28 08:56:25  miselsa
 * $R30530平行測試的修改
 * $
 * $Revision 1.1.2.11  2005/04/25 07:27:49  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.10  2005/04/04 07:02:24  miselsa
 * $R30530 支付系統
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

		/* 接收前端欄位定義 */
		int intEntryPDate = 0; // 前端輸入:付款日
		int intEntryEEDate = 0; // 前端輸入:輸入迄日

		intEntryPDate = Integer.parseInt((String) request.getParameter("txtPDateHold"));
		intEntryEEDate = Integer.parseInt((String) request.getParameter("txtEEDateHold"));

		try {
			if (alCheckPnoList != null) {
				if (alCheckPnoList.size() > 0) {

					for (int i = 0; i < alCheckPnoList.size(); i++) {
						DISBPaymentDetailVO objPaymentDetailVO = (DISBPaymentDetailVO) alCheckPnoList.get(i);
						String strPNO = ""; // 支付序號
						strPNO = objPaymentDetailVO.getStrPNO();
						if (strPNO != null)
							strPNO = strPNO.trim();
						else
							strPNO = "";
						/*
						 * 付款日期規則: 
						 * 1.急件     :若原始付款日期小於付款日期(參數),則以付款日期 = 付款日期(參數)
						 * 2.非急件:若原始付款日期小於輸入迄日(參數),則以付款日期 = 輸入迄日(參數)
						 */
						int intPdate = 0; // 付款日期
						intPdate = objPaymentDetailVO.getIPDate();
						String strPDispatch = objPaymentDetailVO.getStrPDispatch(); // 急件否
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

						// 下log
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
								strReturnMsg = "確認失敗";
							} else {
								request.setAttribute("txtMsg", "確認成功");

								//RA0064 更新 ORGNPCNF(確定給付暫存檔)
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
			request.setAttribute("txtMsg", "確認失敗-->" + e);
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

		/* 接收前端欄位定義 */
		String strPDate = ""; // 付款日期
		String strEntryStartDate = ""; // 輸入日期起日
		String strEntryEndDate = ""; // 輸入日期迄日
		String strDispatch = ""; // 急件否
		String strPSrcGp = ""; // 來源群組代碼
		String strDept = ""; // 部門
		String strEntryUsr = ""; // 輸入者
		String strCurrency = ""; // 幣別
		String strPMETHOD = ""; // 付款方式R60550
		int iNextDT = 0; // 下一個付款日R70292

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
		 * 修改取得支付條件(限CAPSIL壽險資料) 
		 * 1.如PMETHOD IN('A','C') -->輸入日期要符合前端所輸之輸入日期
		 *   如PMETHOD ='B' -->付款日期要符合前端所輸之付款日期 R70088 SPUL配息支票件需同於匯款,於付款日才能確認
		 *   R70292 支票件要以下一工作日為抓取條件 
		 * 2.金額 > 0
		 */

		if (strPSrcGp.equals("CP") || strPSrcGp.equals("")) {
			if (!strPDate.equals("")) {
				if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
					strSql += " and ((A.PMETHOD IN ('B','D')  and A.PDATE <= " + strPDate;// R60550
					strSql += "   and A.ENTRYDT <= " + strEntryEndDate + " ) ";
					strSql += "     or (A.PMETHOD IN('A','C','E') and A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate + " AND A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN滿期金
					strSql += "     or (A.PMETHOD IN('A','C') AND A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT;// R00440 SN滿期金
					strSql += "       and A.ENTRYDT <= " + strEntryEndDate + " ))";
				} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
					strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ")  ";// R60550
					strSql += "  or (A.PMETHOD IN ('A','C','E') and A.ENTRYDT >= " + strEntryStartDate + " and A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN滿期金
					strSql += "  or (A.PMETHOD IN ('A','C') and A.PDATE <= " + iNextDT + " and A.PSRCCODE IN ('B8','B9','BB')) ) ";// R00440 SN滿期金
				} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
					strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN ('A','C') and A.PSRCCODE NOT IN ('B8','B9','BB'))";// /R00440 SN滿期金
					strSql += " or (A.PMETHOD IN ('A','C','E') and A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT + "))";// /R00440 SN滿期金
					strSql += "   and A.ENTRYDT <= " + strEntryEndDate;
				} else {
					strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN('A','C','E') and A.PSRCCODE NOT IN ('BB','B8','B9'))";// R00440 SN滿期金
					strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT + "))";// R00440 SN滿期金
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
			// 非 capsil件
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

		// 依部門 輸入者及保單號碼排序
		strSql += " order by B.DEPT,A.ENTRYUSR,A.POLICYNO ";

		System.out.println("DISBPConfirmServlet.inquiryDB()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setIEntryDt(rs.getInt("ENTRYDT")); // 輸入日期
				objPDetailVO.setIPAMT(rs.getDouble("PAMT")); // 支付金額
				objPDetailVO.setIPCfmDt1(rs.getInt("PCFMDT1"));// 支付確認日一
				objPDetailVO.setIPCfmTm1(rs.getInt("PCFMTM1"));// 支付確認時一
				objPDetailVO.setIPCfmDt2(rs.getInt("PCFMDT2"));// 支付確認日二
				objPDetailVO.setIPCfmTm2(rs.getInt("PCFMTM2"));// 支付確認時二
				objPDetailVO.setIPDate(rs.getInt("PDATE")); // 付款日期
				objPDetailVO.setIUpdDt(rs.getInt("UPDDT")); // 異動日期
				objPDetailVO.setIUpdTm(rs.getInt("UPDTM")); // 異動時間
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));// 要保書號碼
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));// 保單號碼
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));// 輸入人員
				objPDetailVO.setStrPAuthCode(rs.getString("PAUTHCODE"));// 授權碼
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));// 付款銀行
				objPDetailVO.setStrPBBank(rs.getString("PBBANK"));// 付款帳號
				objPDetailVO.setStrPCfmUsr1(rs.getString("PCFMUSR1"));// 支付確認者一
				objPDetailVO.setStrPCfmUsr2(rs.getString("PCFMUSR2"));// 支付確認者二
				objPDetailVO.setStrPCheckNO(rs.getString("PCHECKNO"));// 支票號碼
				objPDetailVO.setStrPCrdEffMY(rs.getString("PCRDEFFMY"));// 有效年月
				objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO"));// 信用卡卡號
				objPDetailVO.setStrPCrdType(rs.getString("PCRDTYPE"));// 卡別
				objPDetailVO.setStrPDesc(rs.getString("PDESC")); // 支付描述
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));// 急件否
				objPDetailVO.setStrPId(rs.getString("PID")); // 受款人ID
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));// 付款方式
				objPDetailVO.setStrPName(rs.getString("PNAME"));// 受款人姓名
				objPDetailVO.setStrPNO(rs.getString("PNO")); // 支付序號
				objPDetailVO.setStrPNoH(rs.getString("PNOH")); // 原支付序號
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));// 匯款帳號
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));// 匯款銀行
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));// 來源組群
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE"));// 支付原因代碼
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS"));// 付款狀態
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));// 保單所屬單位
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));// 作廢否

				if (rs.getString("PVOIDABLE") != null || !rs.getString("PVOIDABLE").equals("")) // 決定欄位是否勾選
				{
					if (rs.getString("PVOIDABLE").equals("Y")) {
						objPDetailVO.setChecked(false);
						objPDetailVO.setDisabled(true);
					}
				}

				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));// 急件否
				if (rs.getString("PDISPATCH") != null || !rs.getString("PDISPATCH").equals("")) // 決定欄位是否Disable
				{
					if (rs.getString("PDISPATCH").equals("Y")) {
						objPDetailVO.setChecked(false);
					}
				}
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));// 幣別
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));// R60550外幣幣別
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));// R60550外幣金額

				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "查無相關資料");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
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

		/* 接收前端欄位定義 */
		String strPDate = ""; // 付款日期
		String strEntryStartDate = ""; // 輸入日期起日
		String strEntryEndDate = ""; // 輸入日期迄日
		String strDispatch = ""; // 急件否
		String strDept = ""; // 部門
		String strEntryUsr = ""; // 輸入者
		String strCurrency = ""; // 幣別
		String strPMETHOD = ""; // 付款方式R60550
		int iNextDT = 0; // 下一個付款日R70292

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
				// R00440 SN滿期金 strSql += "   or  (A.PMETHOD IN('A','C') and A.ENTRYDT between "+ strEntryStartDate+ "  and "+ strEntryEndDate + AND A.PSRCCODE NOT IN ('B8','B9'))";
				strSql += "   or  (A.PMETHOD IN('A','C','E') and A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate + " AND A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN滿期金
				// R00440 SN滿期金 strSql += " or (A.PMETHOD IN('A','C') AND A.PSRCCODE IN ('B8','B9') and A.PDATE <= " + iNextDT;
				strSql += " or (A.PMETHOD IN('A','C') AND A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT;// R00440 SN滿期金
				strSql += " and A.ENTRYDT <= " + strEntryEndDate + " ))";
			} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
				strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ")  ";
				// R00440 SN滿期金strSql += "  or (A.PMETHOD IN ('A','C') and A.ENTRYDT >= " + strEntryStartDate + " and A.PSRCCODE NOT IN ('B8','B9'))";
				strSql += "  or (A.PMETHOD IN ('A','C','E') and A.ENTRYDT >= " + strEntryStartDate + " and A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN滿期金
				// R00440 SN滿期金 strSql += "  or (A.PMETHOD IN ('A','C') and A.PDATE <= " + iNextDT + " and A.PSRCCODE IN ('B8','B9')) ) ";
				strSql += "  or (A.PMETHOD IN ('A','C') and A.PDATE <= " + iNextDT + " and A.PSRCCODE IN ('B8','B9','BB')) ) ";
			} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				// R00440 SN滿期金strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN ('A','C') and A.PSRCCODE NOT IN ('B8','B9'))";
				strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN ('A','C','E') and A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN滿期金
				// R00440 SN滿期金 strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9') and A.PDATE <= " + iNextDT + "))";
				strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT + "))";// R00440 SN滿期金
				strSql += "   and A.ENTRYDT <= " + strEntryEndDate;
			} else {
				// R00440 SN滿期金 strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN('A','C') and A.PSRCCODE NOT IN ('B8','B9'))";
				strSql += " and ((A.PMETHOD IN ('B','D') and A.PDATE <= " + strPDate + ") or (A.PMETHOD IN('A','C','E') and A.PSRCCODE NOT IN ('B8','B9','BB'))";// R00440 SN滿期金
				// R00440 SN滿期金 strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9') and A.PDATE <= " + iNextDT + "))";
				strSql += " or (A.PMETHOD IN ('A','C') and A.PSRCCODE IN ('B8','B9','BB') and A.PDATE <= " + iNextDT + "))";// R00440 SN滿期金
			}
		} else {
			if (!strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and  A.ENTRYDT between " + strEntryStartDate + "  and " + strEntryEndDate;
			} else if (!strEntryStartDate.equals("") && strEntryEndDate.equals("")) {
				strSql += " and A.ENTRYDT >= " + strEntryStartDate;
			} else if (strEntryStartDate.equals("") && !strEntryEndDate.equals("")) {
				strSql += " and  A.ENTRYDT <= " + strEntryEndDate;
			} else {
				// 非 capsil件
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

		// 依部門 輸入者及保單號碼排序
		strSql += "group by A.ENTRYUSR order by A.ENTRYUSR ";

		System.out.println(" inside DISBPConfirmServlet.inquiryCSCDB()--> strSql =" + strSql);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setRowCount(rs.getInt("ROWCOUNT"));// 總筆數
				objPDetailVO.setTPAMT(rs.getBigDecimal("PAMT")); // 總支付金額
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));// 輸入人員
				objPDetailVO.setEntryStartDate(strEntryStartDate);// 輸入起日
				objPDetailVO.setEntryEndDate(strEntryEndDate);// 輸入迄日
				objPDetailVO.setStrPDate(strPDate);// 付款日期
				objPDetailVO.setSelPSrcGp("");// 來源群組
				objPDetailVO.setStrDispatch(strDispatch);// 急件
				objPDetailVO.setStrDept(strDept);// 部門
				objPDetailVO.setStrPMETHOD(strPMETHOD);// 付款方式
				objPDetailVO.setStrCurrency(strCurrency);// 保單幣別
				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				// session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "查無相關資料");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
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
