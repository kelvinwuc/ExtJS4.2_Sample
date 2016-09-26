package com.aegon.disb.disbmaintain;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import org.apache.log4j.Logger;


/**
 * System   : CashWeb
 * 
 * Function : 急件會計分錄
 * 
 * Remark   : 管理系統─財務
 * 
 * Revision : $$Revision: 1.14 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
* $$Log: DISBAccCdDpServlet.java,v $
* $Revision 1.14  2015/10/26 08:24:56  001946
* $*** empty log message ***
* $
* $Revision 1.13  2014/08/05 03:15:28  missteven
* $RC0036
* $
* $Revision 1.12  2013/12/18 07:22:52  MISSALLY
* $RB0302---新增付款方式現金
* $
* $Revision 1.11  2012/05/18 09:47:36  MISSALLY
* $R10314 CASH系統會計作業修改
* $
* $Revision 1.10  2010/11/23 06:31:02  MISJIMMY
* $R00226-百年專案
* $
* $Revision 1.9  2010/10/25 07:09:58  MISJIMMY
* $R00308 ORACLE上傳檔案格式變更
* $
* $Revision 1.9  2010/09/02 12:08:00  misjimmy
* $R00308-Oracle上傳檔案格式變更
* $
* $Revision 1.8  2008/08/15 04:08:15  misvanessa
* $R80620_會計科目下傳檔案新增3欄位
* $
* $Revision 1.7  2007/10/05 09:10:30  MISVANESSA
* $R70770_ACTCD2 擴至 11 碼
* $
* $Revision 1.6  2007/02/26 10:05:35  MISVANESSA
* $R70175_急件會計科目271001改為271000
* $
* $Revision 1.5  2007/01/31 03:50:13  MISVANESSA
* $R70088_SPUL配息_新增METHOD
* $
* $Revision 1.4  2006/12/29 02:29:21  miselsa
* $R60463及R60550_增加外幣件的匯退會計分錄
* $
* $Revision 1.3  2006/11/24 08:52:08  miselsa
* $R61017_ActCd5由13擴為26碼
* $
* $Revision 1.2  2006/11/07 07:53:54  miselsa
* $R61017_ActCd5由13擴為26碼
* $
* $Revision 1.1  2006/06/29 09:40:15  MISangel
* $Init Project
* $
* $Revision 1.1.2.4  2006/04/27 09:19:31  misangel
* $R50891:VA美元保單-顯示幣別
* $
* $Revision 1.1.2.2  2005/04/28 08:56:27  miselsa
* $R30530平行測試的修改
* $
* $Revision 1.1.2.1  2005/04/25 07:25:28  miselsa
* $R30530_新增急件會計分錄功能
* $
* $Revision 1.1.2.3  2005/04/04 07:02:27  miselsa
* $R30530 支付系統
* $$
*  
*/

public class DISBAccCdDpServlet extends InitDBServlet {
	
	private Logger log = Logger.getLogger(getClass());

	private static final long serialVersionUID = -2327760296109829287L;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private DecimalFormat df = new DecimalFormat("0");

	public void init() throws ServletException {
		super.init();
	}

	//Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	//Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		try {
			this.downloadProcess(request, response);
		} catch(Exception e) {
			System.err.println(e.toString());
			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg",e.getMessage());
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccCdDispatch.jsp");
			dispatcher.forward(request, response);
		}
	}

	private void downloadProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {

		System.out.println("inside downloadProcess");
		List alDwnDetails = new ArrayList();
		String strPCfmDt = null;// R10314
		String strSlipNo = null;// R10314

		/**
		 * 1. 為急件者取得符合支付確認日2 及 輸入日期不符合前端輸入日期區間的支付明細資料 -->支票/匯款/信用卡, 依各個付款方式,小計成一筆(貸方)
		 * 2. 列出1的明細(借方)
		 *  
		 **/

		alDwnDetails = (List) getUnNormalPayments(request, response, alDwnDetails);
		if (alDwnDetails.size() > 0) {
			ServletOutputStream os = response.getOutputStream();
			try {

				/* ConvertData */
				response.setContentType("text/plain");// text/plain
				response.setHeader("Content-Disposition", "attachment; filename=AccCdDpDetails.txt");

				String export = "";
				DISBBean disbBean = new DISBBean(dbFactory);
				String strCheckDt = null;
				String strActCd2 = null;
				String strDesc = null;
				String strDAmt = null;
				String strCAmt = null;
				String strCurrency = null;
				String strLedger = null;

				for (int i = 0; i < alDwnDetails.size(); i++) {
					DISBAccCodeDetailVO objAccCodeDetail = (DISBAccCodeDetailVO) alDwnDetails.get(i);

					strCurrency = objAccCodeDetail.getStrCurr();

					strLedger = disbBean.getLedger(CommonUtil.AllTrim(disbBean.getETableDesc("CURRC", strCurrency)));

					strActCd2 = objAccCodeDetail.getStrActCd2();
					for (int count = strActCd2.length(); count < 11; count++) {// 10->11
						strActCd2 += " ";
					}

					strPCfmDt = objAccCodeDetail.getStrDate1();
					for (int count = strPCfmDt.length(); count < 10; count++) {
						strPCfmDt += " ";
					}

					strDAmt = objAccCodeDetail.getStrDAmt();
					if (strDAmt.equals("0")) {
						strDAmt = " ";
					}
					for (int count = strDAmt.length(); count < 13; count++) {
						strDAmt = " " + strDAmt;
					}

					strCAmt = objAccCodeDetail.getStrCAmt();
					if (strCAmt.equals("0")) {
						strCAmt = " ";
					}
					for (int count = strCAmt.length(); count < 13; count++) {
						strCAmt = " " + strCAmt;
					}

					// DESCRIPTION,x(30) 因為全形 所以strDesc.length()*2
					strDesc = objAccCodeDetail.getStrDesc() == null ? "" : objAccCodeDetail.getStrDesc();
					strDesc = CommonUtil.AllTrim(strDesc);
					if (strDesc.length() > 15) {
						strDesc = strDesc.substring(0, 15);
					}
					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}

					strCheckDt = objAccCodeDetail.getStrCheckDate();
					for (int count = strCheckDt.length(); count < 8; count++) {
						strCheckDt += " ";
					}
					strSlipNo = objAccCodeDetail.getStrSlipNo();
					for (int count = strSlipNo.length(); count < 15; count++) { // R80620
																				// 9->15
						strSlipNo += " ";
					}

					// R00308
					String count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) { // R80132 由9 -->12 R80620 12-15
						count1 = "0" + count1;
					}

					if (!strDAmt.trim().equals("") || !strCAmt.trim().equals("")) {

						export += strLedger + ",";
						export += "Manual" + ",";// Category, x(6)
						export += "Spreadsheet" + ",";// Source,x(11)
						export += strCurrency + ","; // Currency,x(3),
						export += "0" + ",";// COMPANY
						export += strActCd2.substring(0, 6) + ",";// MAIN ACCOUNT
						export += strActCd2.substring(6, 7) + ",";// CHANNEL
						export += strActCd2.substring(7, 8) + ",";// LOB
						export += strActCd2.substring(8, 9) + ",";// PERIOD
						export += strActCd2.substring(9, 11) + ",";// PLAN CODE
						export += "000" + ",";// INVESTMENT
						export += "0" + ","; // INVESTMENT SEQ
						export += "00" + ",";// DEPARTMENT
						export += "00" + ",";// PARTNER
						export += "000000000000000" + ",";// FUTURE1
						export += "000" + ",";// FUTURE2
						export += "0" + ",";// FUTURE3
						export += "00" + ",";// FUTURE4
						export += "000" + ",";// FUTURE5
						export += strPCfmDt.trim() + ",";// Accounting Date
						export += strCAmt.trim() + ",";// Debit 借方金額,x(13),預設為0,不足前補空白, 000,000
						export += strDAmt.trim() + ",";// Credit 貸方金額,x(13),預設為0,不足前補空白, 000,000
						export += strSlipNo.trim() + ",";// Journal Name, 支付確認日迄日之西元年後二碼+MMDD + 3個特定碼
						export += strDesc.trim() + ",";// Description ,x(30),不足後補空白
						export += "User" + ","; // R80620 Conversion Type
						export += "1" + ","; // R80620 Conversion Rate
						export += strPCfmDt.trim() + ",";// Conversion Date
						export += "BATCH,";
						export += count1;
						export += "\r\n";
					}
				}

				// 急件會計分錄最後固定增列如下三行資料列：
				int aldd = alDwnDetails.size();
				//RC0036 - 刪除下列資料
				//export += "TransGlobe Life Insurance Inc.,Manual,Spreadsheet,TWD,0,825500,9,0,Z,ZZ,000,0,43,00,000000000000000,000,0,00,000," + strPCfmDt.trim() + ",,," + strSlipNo.trim().substring(0, 6) + "302TWD,CSC急件匯費,User,1," + strPCfmDt.trim().trim() + ",BATCH," + ConvertIntToString(aldd + 1) + "\r\n";
				//export += "TransGlobe Life Insurance Inc.,Manual,Spreadsheet,TWD,0,825500,9,0,Z,ZZ,000,0,62,00,000000000000000,000,0,00,000," + strPCfmDt.trim() + ",,," + strSlipNo.trim().substring(0, 6) + "302TWD,CLM急件匯費,User,1," + strPCfmDt.trim().trim() + ",BATCH," + ConvertIntToString(aldd + 2) + "\r\n";
				//export += "TransGlobe Life Insurance Inc.,Manual,Spreadsheet,TWD,0,825500,9,0,Z,ZZ,000,0,61,00,000000000000000,000,0,00,000," + strPCfmDt.trim() + ",,," + strSlipNo.trim().substring(0, 6) + "302TWD, NB急件匯費,User,1," + strPCfmDt.trim().trim() + ",BATCH," + ConvertIntToString(aldd + 3) + "\r\n";

				ByteArrayInputStream is = new ByteArrayInputStream(export.getBytes());
				int reader = 0;
				byte[] buffer = new byte[1 * 1024];
				while ((reader = is.read(buffer)) > 0) {
					os.write(buffer, 0, reader);
				}
			} finally {
				os.flush();
				os.close();
			}
		} else {
			// 查無資料回傳錯誤訊息
			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg", "查無可下載資料,請重新查明!");
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccCdDispatch.jsp");
			dispatcher.forward(request, response);
		}
	}

	//R10314
	private String ConvertIntToString(int i) {
		String count1 = String.valueOf(i) ;
		for (int count = count1.length() ;  count < 5 ; count++){ 
			count1 = "0" + count1;
		}
		return count1 ;
	}

	private List getUnNormalPayments(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) {

		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.inquiryDB()");
		// R00231 CommonUtil commonUtil = new CommonUtil();
		DISBBean disbBean = new DISBBean(dbFactory);// R70088新增METHOD
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		List alReturn = new ArrayList();
		String strPStartDate = ""; // 付款日期起日
		String strCurrency = ""; // 幣別
		strPStartDate = request.getParameter("txtPStartDate");
		if (strPStartDate != null)
			strPStartDate = strPStartDate.trim();
		else
			strPStartDate = "";

		// R10314
		String strPStartDateTemp = null;
		if (strPStartDate.length() < 7)
			strPStartDateTemp = "0" + strPStartDate;
		else
			strPStartDateTemp = strPStartDate;

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";

		String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDateTemp.substring(0, 3))) + "/" + strPStartDateTemp.substring(3, 5) + "/" + strPStartDateTemp.substring(5, 7);
		String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDateTemp.substring(0, 3))) + strPStartDateTemp.substring(3, 5) + strPStartDateTemp.substring(5, 7);

		/*
		 * 4. 取得符合支付確認日2 及 輸入日期不符合前端輸入日期區間的支付明細資料 -->支票/匯款/信用卡,
		 * 依各個付款方式,小計成一筆(貸方),為急件者
		 */
		/* 5.列出4的明細(借方),為急件者 */
		try {
			/*
			 * 4. 取得符合支付確認日2 及 輸入日期不符合前端輸入日期區間的支付明細資料 -->支票/匯款/信用卡,
			 * 依各個付款方式,小計成一筆(貸方),為急件者
			 */
			strSql = "select SUM(PAMT) AS SPAMT,PMETHOD,PCURR ";
			strSql += " from CAPPAYF ";
			strSql += "WHERE 1=1 and PCFMDT1<>0 AND PCFMTM1<>0 AND PCFMUSR1 <>''   AND PCFMTM2<>0 AND PCFMUSR2 <>''  and PDispatch = 'Y'  ";
			strSql += " AND PAMT<>0 AND PMETHOD <> 'E' "; // 金額不為0者, 不帶入
			// R10314 strSql += " and PCFMDT2 between " + strPStartDate + "  and " + strPEndDate ;
			strSql += " and PCFMDT2 = " + strPStartDate;
			strSql += " and PCURR='" + strCurrency + "'";

			strSql += " GROUP BY PMETHOD,PCURR ORDER BY PMETHOD ";
			System.out.println("strSql_5" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			// R70770以下ZZ改為ZZZ
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				if (rs.getString("PMETHOD").trim().equals("A")) {
					objAccCodeDetail.setStrActCd2("27100000ZZZ");
					objAccCodeDetail.setStrDesc("急件支票");
				} else if (rs.getString("PMETHOD").trim().equals("B")) {
					objAccCodeDetail.setStrActCd2("27100000ZZZ");// R70175科目271001修改為271000
					objAccCodeDetail.setStrDesc("急件匯款");
				} else if (rs.getString("PMETHOD").trim().equals("C")) {
					objAccCodeDetail.setStrActCd2("11100000ZZZ");
					objAccCodeDetail.setStrDesc("急件信用卡");
				} else if (rs.getString("PMETHOD").trim().equals("D"))// R60550 加上外幣匯款
				{
					objAccCodeDetail.setStrActCd2("27100000ZZZ");// R70175科目271001修改為271000
					objAccCodeDetail.setStrDesc("急件外幣匯款");
				}
				
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("SPAMT")));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));// R80620
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "302" + disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			
			//RC0036 -- 急件現金總公司
			//RD0460已取代此功能
			/*strSql = null;
			strSql = "select SUM(A.PAMT) AS SPAMT,A.PMETHOD,A.PCURR ";
			strSql += " from CAPPAYF A left join USER  B on B.USRID = A.ENTRY_USER ";
			strSql += " WHERE 1=1 and A.PCFMDT1 <> 0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <> '' ";
			strSql += " AND A.PCFMTM2 <> 0 AND A.PCFMUSR2 <> '' and A.PDispatch = 'Y'  ";
			strSql += " AND A.PAMT <> 0 AND A.PMETHOD = 'E' "; 
			strSql += " and A.PCFMDT2 = " + strPStartDate;
			strSql += " and A.PCURR='" + strCurrency + "'";
			strSql += " and B.DEPT NOT IN ('PCD','TYB','TCB','TNB','KHB') ";
            strSql += " GROUP BY PMETHOD,PCURR ORDER BY PMETHOD ";
			System.out.println("strSql_5.2" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("27100200ZZZ");
				objAccCodeDetail.setStrDesc("急件CSC付現");
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("SPAMT")));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));// R80620
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "302" + disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));
				alReturn.add(objAccCodeDetail);
			}*/
			
			//RC0036 -- 急件現金分公司
			//RD0460已取代此功能
			/*strSql = null;
			strSql = "select SUM(A.PAMT) AS SPAMT,A.PMETHOD,A.PCURR ";
			strSql += " from CAPPAYF A left join USER  B on B.USRID = A.ENTRY_USER ";
			strSql += " WHERE 1=1 and A.PCFMDT1 <> 0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <> '' ";
			strSql += " AND A.PCFMTM2 <> 0 AND A.PCFMUSR2 <> '' and A.PDispatch = 'Y'  ";
			strSql += " AND A.PAMT <> 0 AND A.PMETHOD = 'E' "; 
			strSql += " and A.PCFMDT2 = " + strPStartDate;
			strSql += " and A.PCURR='" + strCurrency + "'";
			strSql += " and B.DEPT IN ('PCD','TYB','TCB','TNB','KHB') ";
            strSql += " GROUP BY PMETHOD,PCURR ORDER BY PMETHOD ";
			System.out.println("strSql_5.1" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("27100300ZZZ");
				objAccCodeDetail.setStrDesc("急件分公司付現");
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("SPAMT")));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));// R80620
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "302" + disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));
				alReturn.add(objAccCodeDetail);
			}*/
			
			//RD0460-整合總-分公司週管金撥補作業:Kelvin Wu,2015/10/23
			strSql = null;
			strSql = "select SUM(A.PAMT) AS SPAMT,A.PMETHOD,A.PCURR ";
			strSql += " from CAPPAYF A left join USER  B on B.USRID = A.ENTRY_USER ";
			strSql += " WHERE 1=1 and A.PCFMDT1 <> 0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <> '' ";
			strSql += " AND A.PCFMTM2 <> 0 AND A.PCFMUSR2 <> '' and A.PDispatch = 'Y'  ";
			strSql += " AND A.PAMT <> 0 AND A.PMETHOD = 'E' "; 
			strSql += " and A.PCFMDT2 = " + strPStartDate;
			strSql += " and A.PCURR='" + strCurrency + "'";
			//strSql += " and B.DEPT NOT IN ('PCD','TYB','TCB','TNB','KHB') ";
            strSql += " GROUP BY PMETHOD,PCURR ORDER BY PMETHOD ";
			System.out.println("strSql_5.1-5.2:" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("27100200ZZZ");
				objAccCodeDetail.setStrDesc("急件付現");
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("SPAMT")));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));// R80620
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "302" + disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));
				alReturn.add(objAccCodeDetail);
				log.info("急件付現Kelvin");
			}
			
			strSql = null;

			/* 取前次暫不發資料,,為急件者 */
			strSql = "select PAMT ,PMETHOD,PNAME,PCURR ";
			strSql += " from CAPPAYF ";
			strSql += "WHERE 1=1 and PCFMDT1<>0 AND PCFMTM1<>0 AND PCFMUSR1 <>''   AND PCFMTM2<>0 AND PCFMUSR2 <>''  and PDispatch ='Y'  ";
			strSql += " AND PAMT<>0 "; // 金額不為0者, 不帶入
			// R10314 strSql += " and PCFMDT2 between " + strPStartDate + "  and " + strPEndDate ;
			strSql += " and PCFMDT2 = " + strPStartDate;
			strSql += " and PCURR = '" + strCurrency + "'";
			strSql += " ORDER BY PMETHOD ";
			System.out.println("strSql_6" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				// System.out.println(rs.getString("PNAME")+"="+rs.getBytes("PNAME").length);
				objAccCodeDetail.setStrDesc("急件" + rs.getString("PNAME").trim());
				objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("PAMT")));
				objAccCodeDetail.setStrDAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));// R80620
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "302" + disbBean.getETableDesc("CURRA", rs.getString("PCURR").trim()));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;
			// System.out.println("4.alReturn.size()"+alReturn.size());
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alReturn = null;
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
		return alReturn;
	}

}
