package com.aegon.disb.disbcheck;

/**
 * System   :
 * 
 * Function : 票據開立
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.8 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckOpenServlet.java,v $
 * $Revision 1.8  2013/12/24 02:17:18  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.7  2013/01/08 04:24:05  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.6.4.1  2012/12/06 06:28:26  MISSALLY
 * $RA0102　PA0041
 * $配合法令修改酬佣支付作業
 * $
 * $Revision 1.6  2011/10/21 10:04:37  MISSALLY
 * $R10260---外幣傳統型保單生存金給付作業
 * $
 * $Revision 1.5  2011/08/29 06:56:47  MISSALLY
 * $Q10183
 * $票據開立時若遇到要換票據批號時需人工勾選, 修正為系統自動作業
 * $
 * $Revision 1.4  2011/07/14 11:34:05  MISSALLY
 * $Q10183
 * $票據開立時若遇到要換票據批號時需人工勾選, 修正為系統自動作業
 * $
 * $Revision 1.3  2010/11/23 06:27:42  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.2  2009/12/03 04:10:42  missteven
 * $R90628 票據庫存新增
 * $
 * $Revision 1.1  2006/06/29 09:40:37  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.12  2005/06/01 10:40:33  miselsa
 * $R30530依部門 輸入者及保單號碼排序
 * $
 * $Revision 1.1.2.11  2005/04/28 08:56:24  miselsa
 * $R30530平行測試的修改
 * $
 * $Revision 1.1.2.10  2005/04/04 07:02:22  miselsa
 * $R30530 支付系統
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
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBCheckControlInfoVO;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.DISBCheckDetailVO;

public class DISBCheckOpenServlet extends InitDBServlet {

	private int iChecked = 0;

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = CommonUtil.AllTrim(strAction);
		else
			strAction = "";

		try {
			if (strAction.equals("I"))
				inquiryDBProcess(request, response);
			else if (strAction.equals("DISBCheckOpen"))
				checkOpenProcess(request, response);
			else
				System.err.println("Hello, that's not a valid UseCase!");
		} catch (Exception e) {
			System.err.println("Application Exception >>> " + e);
		}
		return;
	}

	/** 票據開立 */
	private synchronized void checkOpenProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckOpenServlet.checkOpenProcess()");
		String strReturnMsg = "";
		List alEmptyCheckBook = new ArrayList();
		List alCheckInfo = new ArrayList(); //存放票據明細資料
		DISBCheckControlInfoVO objCControlVO = null;

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* 接收前端欄位定義 */
		String strOCBNo = "";	//原始票據批號
		String strOCSNo = "";	//原始支票起始號
		String strOCount = "";	//原始可用件數
		int iOCount = 0;		//原始可用件數

		strOCBNo = request.getParameter("txtOCBNo");
		if (strOCBNo != null)
			strOCBNo = CommonUtil.AllTrim(strOCBNo);
		else
			strOCBNo = "";

		strOCSNo = request.getParameter("txtOCSNo");
		if (strOCSNo != null)
			strOCSNo = CommonUtil.AllTrim(strOCSNo);
		else
			strOCSNo = "";

		strOCount = request.getParameter("txtOCount");
		if (strOCount != null)
			strOCount = CommonUtil.AllTrim(strOCount);
		else
			strOCount = "";
		if (!strOCount.equals(""))
			iOCount = Integer.parseInt(strOCount);

		/*  判斷是否有空白支票可用及可用張數及支票本是否相符 */
		alEmptyCheckBook = getEmptyCheckBook(request, response);
		if (alEmptyCheckBook.size() > 0) {
			/*判斷原來的資料是否相同*/
			strReturnMsg = (String) alEmptyCheckBook.get(0);
			if (strReturnMsg.equals("")) {

				String strNCBNo = "";
				String strNCSNo = "";
				int iNCount = 0;
				for(int i=1; i<alEmptyCheckBook.size(); i++) {
					objCControlVO = (DISBCheckControlInfoVO) alEmptyCheckBook.get(i);

					strNCBNo += "/" + CommonUtil.AllTrim(objCControlVO.getStrCBNo());
					strNCSNo += "/" + CommonUtil.AllTrim(objCControlVO.getStrCSNo());
					iNCount += objCControlVO.getIEmptyCheck();
				}
				strNCBNo = (strNCBNo.length()>0)?strNCBNo.substring(1):"";
				strNCSNo = (strNCSNo.length()>0)?strNCSNo.substring(1):"";

				System.out.println("strOCBNo=" + strOCBNo);
				System.out.println("strNCBNo=" + strNCBNo);
				System.out.println("strOCSNo=" + strOCSNo);
				System.out.println("strNCSNo=" + strNCSNo);
				System.out.println("iOCount=" + iOCount);
				System.out.println("iNCount=" + iNCount);

				if (!(strOCBNo.equals(strNCBNo) && strOCSNo.equals(strNCSNo) && iOCount == iNCount)) {
					strReturnMsg = "可用空白支票資料不符, 請重新查詢";
				}
			}
		} else {
			strReturnMsg = "呼叫查詢空白支票失敗";
		}

		try {
			if (strReturnMsg.equals("")) {
				/*將支票分配給支付案件*/
				alCheckInfo = maintainPList(request, response, alEmptyCheckBook);
				/*更新資料庫*/
				if (alCheckInfo.size() > 0) {
					/*更新票據明細檔 */
					strReturnMsg = updateCheckInfo(alCheckInfo, iUpdDate, con);
					if (strReturnMsg.equals("")) {
						/*更新支付主檔*/
						strReturnMsg = updatePDetails(alCheckInfo, iUpdDate, iUpdTime, strLogonUser, con);
					}
				} else {
					strReturnMsg = "資料有誤, 請重試";
				}
			}
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
			}
		} catch (SQLException e) {
			strReturnMsg = "確認失敗-->" + e;
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		//如果strReturnMsg為空白, 則代表票據開立程式成功, 需執行報表
		if (!strReturnMsg.equals("")) {
			request.setAttribute("txtMsg", strReturnMsg);
			session.removeAttribute("PDetailListTemp");
			session.removeAttribute("PDetailList");
			session.removeAttribute("CheckControlList");
			request.setAttribute("txtAction", "DISBCheckOpen");
		} else {
			//執行票據列印
			request.setAttribute("ReportName", "ChequeRpt.rpt");
			request.setAttribute("OutputFileName", "ChequeRpt.rpt");
			request.setAttribute("OutputType", "TXT");

			//找出要列印的票號
			String strCheckNo = "";
			String strCheckNoS = "";
			String strCheckNoE = "";
			DISBCheckDetailVO tempVO = null;
			for(int i=0; i<alCheckInfo.size(); i++) {
				tempVO = (DISBCheckDetailVO) alCheckInfo.get(i);
				strCheckNo += "'" + tempVO.getStrCNo() + "',";

				if(i == 0)
					strCheckNoS = tempVO.getStrCNo();
				if(i == (alCheckInfo.size()-1))
					strCheckNoE = tempVO.getStrCNo();
			}
			strCheckNo = (strCheckNo.length() > 0)?strCheckNo.substring(0, strCheckNo.length()-1):"";

			System.out.println("起號 : " + strCheckNoS);
			System.out.println("件數 : " + iChecked);
			System.out.println("迄號 : " + strCheckNoE);

			request.setAttribute("para_Cheque", strCheckNo);
			request.setAttribute("para_rePrtFlag", "N");
			request.setAttribute("txtAction", "CheckReport");
		}

		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckOpen.jsp");
		dispatcher.forward(request, response);
		return;
	}

	/**	查詢 */
	private void inquiryDBProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		List alEmptyCheckBook = new ArrayList();
		List alPDetail = new ArrayList();

		String strReturnMsg = "";

		session.removeAttribute("PDetailListTemp");
		session.removeAttribute("PDetailList");
		session.removeAttribute("CheckControlList");

		/*  先取得有空白支票票號的支票本-->可用張數 */
		alEmptyCheckBook = getEmptyCheckBook(request, response);
		if (alEmptyCheckBook.size() > 0) {
			strReturnMsg = (String) alEmptyCheckBook.get(0);
			alEmptyCheckBook.remove(0);
		} else {
			strReturnMsg = "呼叫查詢空白資料失敗";
		}
		if (strReturnMsg.equals("")) {
			/* 取得未執行過支票開立的支付主檔資料 */
			alPDetail = inquiryPDetails(request, response);
			if (alPDetail.size() > 0) {
				strReturnMsg = (String) alPDetail.get(0);
				alPDetail.remove(0);
			} else {
				strReturnMsg = "呼叫查詢支付主檔失敗";
			}
		}
		if (!strReturnMsg.equals("")) {
			request.setAttribute("txtMsg", strReturnMsg);
		} else {
			session.setAttribute("PDetailListTemp", alPDetail);
			session.setAttribute("PDetailList", alPDetail);
			session.setAttribute("CheckControlList", alEmptyCheckBook);
		}

		request.setAttribute("txtAction", "I");
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckOpen.jsp");
		dispatcher.forward(request, response);
		return;
	}

	/**	取得未執行過支票開立的支付主檔資料 */
	private List inquiryPDetails(HttpServletRequest request, HttpServletResponse response) {
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;

		String strSql = ""; //SQL String
		String strReturnMsg = "";

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* 接收前端欄位定義 */
		String strPStartDate = "";	//支付確認日期起日
		String strPEndDate = "";	//支付確認日期迄日
		String strDispatch = "";	//急件否

		strPStartDate = request.getParameter("txtPStartDate");
		if (strPStartDate != null)
			strPStartDate = CommonUtil.AllTrim(strPStartDate);
		else
			strPStartDate = "";

		strPEndDate = request.getParameter("txtPEndDate");
		if (strPEndDate != null)
			strPEndDate = CommonUtil.AllTrim(strPEndDate);
		else
			strPEndDate = "";

		strDispatch = request.getParameter("selDispatch");
		if (strDispatch != null)
			strDispatch = CommonUtil.AllTrim(strDispatch);
		else
			strDispatch = "";

		strSql = "select A.ENTRYDT,A.PAMT,A.PCFMDT1,A.PCFMTM1,A.PCFMDT2,A.PCFMTM2,A.PDATE,A.UPDDT,A.UPDTM,";
		strSql += "A.APPNO,A.POLICYNO,A.ENTRYUSR,A.PAUTHCODE,A.PBACCOUNT,A.PBBANK,A.PCFMUSR1,A.PCFMUSR2,";
		strSql += "A.PCHECKNO,A.PCRDEFFMY,A.PCRDNO,A.PCRDTYPE,A.PDESC,A.PDISPATCH,A.PID,A.PMETHOD,A.PNAME,";
		strSql += "A.PNO,A.PNOH,A.PRACCOUNT,A.PRBANK,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,";
		strSql += "A.BRANCH,B.DEPT ";
		strSql += " from CAPPAYF A ";
		strSql += " left outer join USER B  on B.USRID=A.ENTRYUSR "; //單位排序 
		strSql += " WHERE A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>'' ";
		strSql += " AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>''  AND A.PSTATUS=''  AND A.PCHECKNO='' ";
		strSql += " AND A.PVOIDABLE<>'Y'  AND A.PMETHOD='A'  ";

		if (!strPStartDate.equals("") && !strPEndDate.equals("")) {
			strSql += " and A.PCFMDT2  between " + strPStartDate + "  and " + strPEndDate;
		} else if (!strPStartDate.equals("") && strPEndDate.equals("")) {
			strSql += " and A.PCFMDT2 >= " + strPStartDate;
		} else if (strPStartDate.equals("") && !strPEndDate.equals("")) {
			strSql += " and A.PCFMDT2 <= " + strPEndDate;
		}

		if (strDispatch.equals("Y")) {
			strSql += "  and A.PDISPATCH= '" + strDispatch + "' ";
		} else if (strDispatch.equals("N")) {
			strSql += "  and A.PDISPATCH='' ";
		}

		// 依部門 輸入者及保單號碼排序  RA0102 增加支付序號
		strSql += " order by B.DEPT,A.ENTRYUSR,A.POLICYNO,A.PNO ";

		System.out.println("DISBCheckOpenServlet.inqueryDB()--> strSql =" + strSql);

		try {
			con = dbFactory.getAS400Connection("DISBCheckOpenServlet.inqueryDB()");
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	//支付金額
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		//付款日期
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));//要保書號碼
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	//保單號碼
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));//支付描述
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));//急件否
				objPDetailVO.setStrPId(rs.getString("PID"));	//受款人ID
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));	//付款方式
				objPDetailVO.setStrPName(rs.getString("PNAME"));//受款人姓名
				objPDetailVO.setStrPNO(rs.getString("PNO"));	//支付序號
				objPDetailVO.setStrPNoH(rs.getString("PNOH"));	//原支付序號
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS"));	//付款狀態
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		//保單所屬單位
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));//作廢否
				alPDetail.add(objPDetailVO);
			}
			rs.close();
			stmt.close();
			if (alPDetail.size() > 0) {
				strReturnMsg = "";
			} else {
				strReturnMsg = "查無相關資料";
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alPDetail = null;
		} finally {
			dbFactory.releaseAS400Connection(con);
		}
		alPDetail.add(0, strReturnMsg);
		return alPDetail;
	}

	/**	取得空白支票本 */
	private synchronized List getEmptyCheckBook(HttpServletRequest request, HttpServletResponse response) {

		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; //SQL String

		DISBCheckControlInfoVO objCControlVOTemp = null;
		DISBCheckControlInfoVO objCControlVO = null;
		List alReturnInfo = new ArrayList();
		List alCControll = new ArrayList();
		String strReturnMsg = "";

		/* 接收前端欄位定義 */
		String strCBKNo = "";	//銀行行庫
		String strCAccount = "";//銀行帳號

		/*取得前端欄位資料*/
		strCBKNo = request.getParameter("txtPBBank");
		if (strCBKNo != null)
			strCBKNo = CommonUtil.AllTrim(strCBKNo);
		else
			strCBKNo = "";
		request.setAttribute("PBBank", strCBKNo);

		strCAccount = request.getParameter("txtPBAccount");
		if (strCAccount != null)
			strCAccount = CommonUtil.AllTrim(strCAccount);
		else
			strCAccount = "";
		request.setAttribute("PBAccount", strCAccount);

		try {
			con = dbFactory.getAS400Connection("DISBCheckStockServlet.inquiryDB()");
			stmt = con.createStatement();

			/*1.取得目前仍有空白支票的支票本*/
			strSql = "SELECT DISTINCT A.CBNO,A.CACCOUNT,A.CBKNO,A.CHKSNO,A.CHKENO,A.APPROVSTA ";
			strSql += "FROM CAPCKNOF A ";
			strSql += "LEFT OUTER JOIN CAPCHKF B ON A.CBKNO = B.CBKNO AND A.CACCOUNT=B.CACCOUNT AND A.CBNO = B.CBNO ";
			strSql += "WHERE B.CSTATUS = '' AND B.CHNDFLG<>'Y' AND A.CBKNO='" + strCBKNo + "' ";
			strSql += "AND A.CACCOUNT='" + strCAccount + "'  AND A.APPROVSTA <> 'E' ";
			System.out.println(" inside DISBCheckOpenServlet.inquiryDB() 1--> strSql =" + strSql);
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objCControlVOTemp = new DISBCheckControlInfoVO();
				objCControlVOTemp.setStrCBKNo(rs.getString("CBKNO"));		//銀行行庫	
				objCControlVOTemp.setStrCAccount(rs.getString("CACCOUNT"));	//銀行帳號
				objCControlVOTemp.setStrCBNo(rs.getString("CBNO"));		//票據批號
				objCControlVOTemp.setStrCSNo(rs.getString("CHKSNO"));	//票據起號
				objCControlVOTemp.setStrCENo(rs.getString("CHKENO"));	//票據訖號
				objCControlVOTemp.setStrApprovStat(rs.getString("APPROVSTA"));	//票據狀態R90628
				alCControll.add(objCControlVOTemp);
			}
			rs.close();

			if (alCControll.size() > 0) {
				for (int i = 0; i < alCControll.size(); i++) 
				{ //for 1
					objCControlVOTemp = (DISBCheckControlInfoVO) alCControll.get(i);
					if (!"N".equals(objCControlVOTemp.getStrApprovStat())) 
					{
						/*2.判斷是否完全被用過*/
//						int iCSNoTemp = Integer.parseInt(CommonUtil.AllTrim(objCControlVOTemp.getStrCSNo()).substring(2));
//						int iCENoTemp = Integer.parseInt(CommonUtil.AllTrim(objCControlVOTemp.getStrCENo()).substring(2));
//						int iCheckCount = (iCENoTemp - iCSNoTemp) + 1;
						strSql = " select count(CNO) AS CNOCOUNT ";
						strSql += " from  CAPCHKF ";
						strSql += " WHERE  1=1 AND  CBKNO='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBKNo()) + "' ";
						strSql += " AND CACCOUNT='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCAccount()) + "' ";
						strSql += " AND CBNO='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBNo()) + "'  AND CSTATUS='' ";
						System.out.println(" inside DISBCheckOpenServlet.inquiryDB() 2--> strSql =" + strSql);
						rs = stmt.executeQuery(strSql);
						if (rs.next()) 
						{ // if2
//							if (rs.getInt("CNOCOUNT") < iCheckCount) 
//							{ //if 3
								/*3.找出尚未被用過的*/
								strSql = "select a.CNO AS CNO ";
								strSql += "from CAPCHKF a ";
								strSql += "where CBKNO='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBKNo()) + "' ";
								strSql += "AND CACCOUNT='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCAccount()) + "' ";
								strSql += "AND CBNO='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBNo()) + "'  ";
								strSql += "AND CSTATUS='' ";
								System.out.println(" inside DISBCheckOpenServlet.inquiryDB() 3--> strSql =" + strSql);
								rs.close();
								rs = stmt.executeQuery(strSql);
								objCControlVO = new DISBCheckControlInfoVO();
								List alTemp = new ArrayList();
								Set emptyCheckNo = new TreeSet();
								while (rs.next()) {
									alTemp.add(rs.getString("CNO"));
									emptyCheckNo.add(rs.getString("CNO"));
								}
								rs.close();
								if (alTemp.size() > 0) {
									//有資料
									objCControlVO.setIEmptyCheck(alTemp.size());
									objCControlVO.setStrCAccount(objCControlVOTemp.getStrCAccount());
									objCControlVO.setStrCBKNo(objCControlVOTemp.getStrCBKNo());
									objCControlVO.setStrCBNo(objCControlVOTemp.getStrCBNo());
									objCControlVO.setEmptyCheckNo(emptyCheckNo);
									if (alTemp.size() == 1) {
										objCControlVO.setStrCSNo((String) alTemp.get(0));
										objCControlVO.setStrCENo((String) alTemp.get(0));
									} else {
										for (int j = 0; j < alTemp.size(); j++) {
											if (j == 0)
												objCControlVO.setStrCSNo((String) alTemp.get(0));
											else if (j == alTemp.size() - 1)
												objCControlVO.setStrCENo((String) alTemp.get(j));
										}
									}
									alReturnInfo.add(objCControlVO);
//									break;
								} //有資料
//							} //if 3
//							else {
								//該本尚未完全用過
//								objCControlVOTemp.setIEmptyCheck(iCheckCount);
//								alReturnInfo.add(objCControlVOTemp);
//								break;
//							} //if 3
						} //if 2
					} else {
						strReturnMsg = "票據批號：" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBNo()) + "，狀態為核准申請中。\n請完成核准申請作業，重新執行開票作業!";
					}
					rs.close();
				} //for 1	
			} else {
				strReturnMsg = "庫存中無可用空白支票本";
			}
		} catch (SQLException ex) {
			strReturnMsg = "查詢失敗:" + ex;
			alCControll = null;
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception ex1) { }
			try { if (stmt != null) stmt.close(); } catch (Exception ex1) { }
			try { if (con != null) dbFactory.releaseAS400Connection(con); } catch (Exception ex1) { }
		}
		alReturnInfo.add(0, strReturnMsg);
		return alReturnInfo;
	}

	/** 分配支票 */
	private List maintainPList(HttpServletRequest request, HttpServletResponse response, List emptyCheckBook) {
		List alReturn = new ArrayList();

		HttpSession session = request.getSession(true);
		List alPDetail = (List) session.getAttribute("PDetailListTemp");
		int iSize = (alPDetail != null)?alPDetail.size():0;

		iChecked = 0;

		DISBCheckControlInfoVO objCControlVO = null;
		DISBCheckDetailVO objCDetailVO = null;
		String strIsChecked = "";
		String strCBKNo = "";		//銀行行庫
		String strCAccount = "";	//銀行帳號
		String strCBNo = "";		//票據批號
		String strCNo = "";			//支票號碼

		int preCount = 0;
		boolean isNextNo = false;
		boolean isBreak = false;
		for(int i=1; i<emptyCheckBook.size(); i++) 
		{
			objCControlVO = (DISBCheckControlInfoVO) emptyCheckBook.get(i);

			strCBKNo = objCControlVO.getStrCBKNo();
			if (strCBKNo != null)
				strCBKNo = CommonUtil.AllTrim(strCBKNo);
			else
				strCBKNo = "";

			strCAccount = objCControlVO.getStrCAccount();
			if (strCAccount != null)
				strCAccount = CommonUtil.AllTrim(strCAccount);
			else
				strCAccount = "";

			strCBNo = objCControlVO.getStrCBNo();
			if (strCBNo != null)
				strCBNo = CommonUtil.AllTrim(strCBNo);
			else
				strCBNo = "";

			for(Iterator it=objCControlVO.getEmptyCheckNo().iterator(); it.hasNext(); ) 
			{
				strCNo = CommonUtil.AllTrim((String) it.next());

				for (int j = 0; j < iSize; j++) 
				{
					if(isNextNo) {
						isNextNo = false;
						j = preCount + 1;
					}
					strIsChecked = request.getParameter("ch" + j);
					if (strIsChecked != null && strIsChecked.equalsIgnoreCase("Y")) {
						objCDetailVO = new DISBCheckDetailVO();
						DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(j);
						objCDetailVO.setStrPNO(objPDetailVO.getStrPNO());
						objCDetailVO.setStrCNm(objPDetailVO.getStrPName());
						objCDetailVO.setICAmt(objPDetailVO.getIPAMT());
						objCDetailVO.setIChequeDt(objPDetailVO.getIPDate());
						objCDetailVO.setStrCAccount(strCAccount);
						objCDetailVO.setStrCBKNo(strCBKNo);
						objCDetailVO.setStrCBNo(strCBNo);
						objCDetailVO.setStrCNo(strCNo);
						alReturn.add(objCDetailVO);
						iChecked++;
						isNextNo = true;
					}
					preCount = j;
					if(isNextNo)
						break;

				}  //end request checkbox loop
				if((preCount +1) == iSize) {
					isBreak = true;
					break;
				}

				if(isNextNo)
					continue;

			}  //end empty checkno loop
			if(isBreak)
				break;

		}  //end empty book loop

		return alReturn;
	}

	/**	更新票據檔 */
	private String updateCheckInfo(List alCheckInfo, int iUpdDate, Connection con) throws ServletException, IOException {
		System.out.println("@@@@@inside updateCheckInfo");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; //SQL String
		String strReturnMsg = "";

		try {
			if (alCheckInfo != null) 
			{ //0
				if (alCheckInfo.size() > 0) 
				{ //1
					for (int i = 0; i < alCheckInfo.size(); i++) 
					{ //2
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo.get(i);
						String strPNO = (String) objCDetailVO.getStrPNO();
						if (strPNO != null)
							strPNO = CommonUtil.AllTrim(strPNO);
						else
							strPNO = "";

						strSql = " update CAPCHKF  set CNM='" + CommonUtil.AllTrim(objCDetailVO.getStrCNm()) + "'";
						strSql += ",CAMT=" + objCDetailVO.getICAmt() + " ";
						strSql += ",CHEQUEDT=" + objCDetailVO.getIChequeDt() + " ";
						strSql += ",CUSEDT=" + iUpdDate + " ";
						strSql += ",PNO='" + CommonUtil.AllTrim(objCDetailVO.getStrPNO()) + "' ";
						strSql += ",CSTATUS='D' ";
						strSql += " where CNO ='" + CommonUtil.AllTrim(objCDetailVO.getStrCNo()) + "'  ";
						strSql += " AND CBKNO='" + CommonUtil.AllTrim(objCDetailVO.getStrCBKNo()) + "' ";
						strSql += " AND CACCOUNT='" + CommonUtil.AllTrim(objCDetailVO.getStrCAccount()) + "' ";
						strSql += " AND CBNO='" + CommonUtil.AllTrim(objCDetailVO.getStrCBNo()) + "' ";

						System.out.println(" inside DISBCheckCreateServlet.updateCheckInfo()--> strSql =" + strSql + "_" + CommonUtil.AllTrim(objCDetailVO.getStrCNm()) + "_" + objCDetailVO.getICAmt() + "_" + objCDetailVO.getIChequeDt() + "_" + iUpdDate + "_" + objCDetailVO.getStrPNO() + "_" + objCDetailVO.getStrCNo() + "_" + objCDetailVO.getStrCBKNo() + "_" + objCDetailVO.getStrCAccount() + "_" + objCDetailVO.getStrCBNo());

						pstmtTmp = con.prepareStatement(strSql);
						int iupdate = pstmtTmp.executeUpdate();
						if (iupdate == 1) {
							System.out.println("updateCheckInfo_executeUpdate成功");
						} else {
							strReturnMsg = "更新票據明細檔失敗";
							return strReturnMsg;
						}
						pstmtTmp.close();
					} //2 END OF FOR
				} //1
			} //0
		} catch (SQLException ex) {
			strReturnMsg = "更新票據明細檔失敗:ex=" + ex;
		}
		return strReturnMsg;
	}

	/**	更新支付檔 */
	private String updatePDetails(List alCheckInfo, int iUpdDate, int iUpdTime, String strLogonUser, Connection con) throws ServletException, IOException {
		System.out.println("@@@@@inside updatePConfirmed");
		PreparedStatement pstmtTmp = null;

		String strSql = ""; //SQL String
		String strReturnMsg = "";
		DISBBean disbBean = new DISBBean(dbFactory);

		try {
			if (alCheckInfo != null) {
				if (alCheckInfo.size() > 0) {

					for (int i = 0; i < alCheckInfo.size(); i++) {
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo.get(i);

						strSql = " update CAPPAYF set PBBANK = ?, PBACCOUNT = ?, PCHECKNO = ?, PCSHDT = ? ";
						strSql += ",PSTATUS = 'B', UPDDT = ?, UPDTM = ?, UPDUSR = ?  where PNO = ?";

						//下log
						strReturnMsg = disbBean.insertCAPPAYFLOG(CommonUtil.AllTrim(objCDetailVO.getStrPNO()), strLogonUser, iUpdDate, iUpdTime, con);
						if (strReturnMsg.equals("")) {
							pstmtTmp = con.prepareStatement(strSql);
							pstmtTmp.setString(1, CommonUtil.AllTrim(objCDetailVO.getStrCBKNo()));
							pstmtTmp.setString(2, CommonUtil.AllTrim(objCDetailVO.getStrCAccount()));
							pstmtTmp.setString(3, CommonUtil.AllTrim(objCDetailVO.getStrCNo()));
							pstmtTmp.setInt(4, iUpdDate);
							pstmtTmp.setInt(5, iUpdDate);
							pstmtTmp.setInt(6, iUpdTime);
							pstmtTmp.setString(7, strLogonUser);
							pstmtTmp.setString(8,CommonUtil.AllTrim(objCDetailVO.getStrPNO()));

							if (pstmtTmp.executeUpdate() < 1) {
								strReturnMsg = "更新支付主檔失敗";
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
			strReturnMsg = "更新支付主檔失敗: e=" + e;
		}
		return strReturnMsg;
	}

}
