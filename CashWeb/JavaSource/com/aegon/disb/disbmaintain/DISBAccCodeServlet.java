package com.aegon.disb.disbmaintain;

import javax.servlet.*;
import javax.servlet.http.*;
   
import java.io.*;
import java.text.DecimalFormat;
import java.util.*;

import com.aegon.comlib.*;
import com.aegon.disb.util.DISBBean;

import java.sql.*;
import org.apache.log4j.Logger;

/**
 * System   :
 * 
 * Function : 財務會計分錄
 * 
 * Remark   : 管理系統 - 會計
 * 
 * Revision : $$Revision: 1.21 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:   
 * 
 * $$Log: DISBAccCodeServlet.java,v $
 * $Revision 1.21  2014/01/02 08:26:43  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.20.1.3  2013/08/13 04:10:27  MISSALLY
 * $QB0216 美元保單退匯扣除退匯手續費問題 --- 取到小數第四位
 * $
 * $Revision 1.20.1.2  2013/08/09 09:21:32  MISSALLY
 * $QB0216 美元保單退匯扣除退匯手續費問題
 * $
 * $Revision 1.20.1.1  2013/07/19 08:22:43  MISSALLY
 * $EB0070 - 人民幣投資型年金商品
 * $
 * $Revision 1.20  2013/01/08 04:24:03  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.19.4.1  2012/12/06 06:28:25  MISSALLY
 * $RA0102　PA0041
 * $配合法令修改酬佣支付作業
 * $
 * $Revision 1.19  2012/06/29 08:48:26  MISSALLY
 * $QA0221---將前次暫不付款不等於輸入日條件改為小於輸入日
 * $
 * $Revision 1.18  2012/05/18 09:47:36  MISSALLY
 * $R10314 CASH系統會計作業修改
 * $
 * $Revision 1.17  2010/11/23 06:31:02  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.16  2010/10/25 07:12:03  MISJIMMY
 * $R00308 ORACLE上傳檔案格式變更
 * $
 * $Revision 1.16  2010/09/02 09:00:00  MISJIMMY
 * $R00308 Oracle 上傳格式變更 
 * $
 * $Revision 1.14  2009/04/20 05:40:00  misodin
 * $R80822 新增作費明細與當日急件
 * $
 * $Revision 1.13  2008/12/22 06:48:48  misvanessa
 * $R80799_新增酬佣上傳
 * $
 * $Revision 1.12  2008/10/27 08:03:00  MISODIN
 * $R70600 前次暫不開票總計
 * $
 * $Revision 1.11  2008/08/15 04:09:16  misvanessa
 * $R80620_會計科目下傳檔案新增3欄位
 * $
 * $Revision 1.10  2008/08/06 05:53:51  MISODIN
 * $R80132 調整CASH系統for 6種幣別
 * $
 * $Revision 1.9  2007/10/05 09:10:51  MISVANESSA
 * $R70770_ACTCD2 擴至 11 碼
 * $
 * $Revision 1.8  2007/06/08 07:57:28  MISVANESSA
 * $R70366_會計科目和匯退會計科目修改
 * $
 * $Revision 1.7  2007/01/31 03:51:29  MISVANESSA
 * $R70088_SPUL配息_新增METHOD
 * $
 * $Revision 1.6  2007/01/04 03:09:37  MISVANESSA
 * $R60550_新增外幣財務會計科目.匯退會計科目
 * $
 * $Revision 1.5  2006/12/29 02:29:21  miselsa
 * $R60463及R60550_增加外幣件的匯退會計分錄
 * $
 * $Revision 1.4  2006/11/24 08:52:08  miselsa
 * $R61017_ActCd5由13擴為26碼
 * $
 * $Revision 1.3  2006/11/07 07:53:54  miselsa
 * $R61017_ActCd5由13擴為26碼
 * $
 * $Revision 1.2  2006/10/24 03:07:12  MISVANESSA
 * $R60834_CASH系統傳票轉檔修改
 * $
 * $Revision 1.1  2006/06/29 09:40:15  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.11  2006/04/28 03:40:43  misangel
 * $R50891:VA美元保單-顯示幣別(NTD -->TWD)
 * $
 * $Revision 1.1.2.10  2006/04/27 09:19:31  misangel
 * $R50891:VA美元保單-顯示幣別
 * $
 * $Revision 1.1.2.9  2006/04/10 09:48:40  misangel
 * $*** empty log message ***
 * $
 * $Revision 1.1.2.8  2005/06/06 08:41:56  miselsa
 * $R30530_會計科目規格變更
 * $
 * $Revision 1.1.2.7  2005/06/03 02:53:24  miselsa
 * $R30530_會計科目
 * $
 * $Revision 1.1.2.6  2005/05/11 07:02:10  miselsa
 * $R30530_修改會計科目
 * $
 * $Revision 1.1.2.5  2005/04/28 08:56:27  miselsa
 * $R30530平行測試的修改
 * $
 * $Revision 1.1.2.4  2005/04/25 07:23:51  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.3  2005/04/04 07:02:27  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBAccCodeServlet extends HttpServlet {
	
	private Logger log = Logger.getLogger(getClass());
	
	private DbFactory dbFactory = null;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private DecimalFormat df = new DecimalFormat("0");
	private DecimalFormat df1 = new DecimalFormat("#.0000");

	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory = (DbFactory) getServletContext().getAttribute(
					Constant.DB_FACTORY);
		}
	}

	// Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	// Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		try {
			this.downloadProcess(request, response);
		} catch (Exception e) {
			System.err.println(e.toString());

			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg", e.getMessage());
			dispatcher = request
					.getRequestDispatcher("/DISB/DISBMaintain/DISBAccountingCode.jsp");
			dispatcher.forward(request, response);
		}
	}

	/**
	 * @param request
	 * @param response
	 */
	private void downloadProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
		System.out.println("inside downloadProcess");

		List alDwnDetails = new ArrayList();

		/* 1.取得符合輸入日期, 且已被確認2的支付明細資料 -->支票/匯款/信用卡, 依各個付款方式,小計成一筆(貸方) */
		/* 2.取得符合輸入日期, 且已未被確認2的支付明細資料 -->不分付款方式,列出各筆明細(貸方) */
		/* 3.加總1及2, 成一筆資料(借方) */
		alDwnDetails = (List) getNormalPayments(request, response, alDwnDetails);

		/* 4. 取得符合支付確認日2 及 輸入日期不符合前端輸入日期區間的支付明細資料 -->支票/匯款/信用卡, 依各個付款方式,小計成一筆(貸方) */
		/* 5.列出4的明細(借方) */
		alDwnDetails = (List) getUnNormalPayments(request, response, alDwnDetails);

		if (alDwnDetails.size() > 0) {
			ServletOutputStream os = response.getOutputStream();
			try {
				// System.out.println(System.getProperty("file.encoding"));
				/* ConvertData */
				response.setContentType("text/plain");// text/plain
				response.setHeader("Content-Disposition", "attachment; filename=AccCodeDetails.txt");
				String export = "";
				DISBBean disbBean = new DISBBean(dbFactory);
				String strCheckDt = null;
				String strActCd2 = null;
				String strActCd5 = null; // 信用卡科目不同
				String strDesc = null;
				String strSlipNo = null;
				String strDAmt = null;
				String strCAmt = null;
				String strPCfmDt = null;
				String strCurrency = null;
				String strLedger = null;
				String company = "";//RD0382:OIU
				
				//RD0382:OIU
				company = request.getParameter("selCompany");
				if (company != null){
					company = company.trim();
				}else{
					company = "";
				}

				for (int i = 0; i < alDwnDetails.size(); i++) {
					DISBAccCodeDetailVO objAccCodeDetail = (DISBAccCodeDetailVO) alDwnDetails.get(i);

					strCurrency = objAccCodeDetail.getStrCurr();

					strLedger = disbBean.getLedger(CommonUtil.AllTrim(disbBean.getETableDesc("CURRC", strCurrency)));
					
					if("6".equals(company)){
						if("TWD".equals(strCurrency)){
							strLedger += " OIU";
						}else{
							strLedger = strLedger.substring(0, strLedger.length()-3) + " OIU " + strLedger.substring(strLedger.length()-3);
						}
					}					
					log.info("strLedger:" + strLedger + ",strCurrency:" + strCurrency);

					strActCd2 = objAccCodeDetail.getStrActCd2();
					for (int count = strActCd2.length(); count < 11; count++) { // 10->11
						strActCd2 += " ";
					}
					// 增加信用卡科目不同
					strActCd5 = objAccCodeDetail.getStrActCd5();
					for (int count = strActCd5.length(); count < 26; count++) {// R61017  ActCd5由13碼擴為26碼
						strActCd5 += " ";
					}
					// System.out.println("strActCd5="+strActCd5);
					strPCfmDt = objAccCodeDetail.getStrDate1();
					for (int count = strPCfmDt.length(); count < 10; count++) {
						strPCfmDt += " ";
					}

					strDAmt = objAccCodeDetail.getStrDAmt();
					if (strDAmt.equals("0") || strDAmt.equals(".0000")) {
						strDAmt = " ";
					}
					for (int count = strDAmt.length(); count < 13; count++) {
						strDAmt = " " + strDAmt;
					}

					strCAmt = objAccCodeDetail.getStrCAmt();

					if (strCAmt.equals("0") || strCAmt.equals(".0000")) {
						strCAmt = " ";
					}
					for (int count = strCAmt.length(); count < 13; count++) {
						strCAmt = " " + strCAmt;
					}

					// DESCRIPTION,x(30) 因為會中文的問題,
					// 所以長度需用strDesc.getBytes().length取得
					strDesc = objAccCodeDetail.getStrDesc() == null ? "" : objAccCodeDetail.getStrDesc();
					strDesc = CommonUtil.AllTrim(strDesc);
					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}
					// System.out.println("strDesc="+strDesc);
					strCheckDt = objAccCodeDetail.getStrCheckDate();
					for (int count = strCheckDt.length(); count < 8; count++) {
						strCheckDt += " ";
					}
					strSlipNo = objAccCodeDetail.getStrSlipNo();
					for (int count = strSlipNo.length(); count < 15; count++) {
						strSlipNo += " ";
					}
					log.info("strSlipNo:" + strSlipNo);

					// R00308 oracle 升級
					String count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) {
						count1 = "0" + count1;
					}

					if (!strDAmt.trim().equals("") || !strCAmt.trim().equals("")) {

						export += strLedger + ",";
						export += "Manual" + ",";// Category, x(6)
						export += "Spreadsheet" + ",";// Source,x(11)
						export += strCurrency + ",";// Currency,x(3),
						
						if("6".equals(company)){
							export += "6" + ",";// ACTCD1,x(1)
						}else {
							export += "0" + ",";// ACTCD1,x(1)
						}
						
						export += strActCd2.substring(0, 6) + ",";// ACTCD2,x(10)
						export += strActCd2.substring(6, 7) + ",";
						export += strActCd2.substring(7, 8) + ",";
						export += strActCd2.substring(8, 9) + ",";
						export += strActCd2.substring(9, 11) + ",";
						export += "000" + ",";// ACTCD3,x(4)
						export += "0" + ",";// ACTCD3,x(4)
						export += "00" + ",";// ACTCD4,x(2)
						export += strActCd5.substring(0, 2) + ",";// ACTCD5,x(26) ,R61017 ActCd5由13擴為26碼
						export += strActCd5.substring(2, 17) + ",";
						export += strActCd5.substring(17, 20) + ",";
						export += strActCd5.substring(20, 21) + ",";
						export += strActCd5.substring(21, 23) + ",";
						export += strActCd5.substring(23, 26) + ",";
						export += strPCfmDt.trim() + ",";// 支付確認日迄日,YYYY/MM/DD,x(10)
						export += strCAmt.trim() + ",";// 借方金額,x(12),預設為0,不足前補空白, 000,000
						export += strDAmt.trim() + ",";// 貸方金額,x(12),預設為0,不足前補空白, 000,000
						export += strSlipNo.trim() + ",";// SlipNo,x(11), 支付確認日迄日之西元年後二碼+MMDD + 3個特定碼 R80132 由9 -->12 + 幣別
						export += strDesc.trim() + ",";// Description,x(30),不足後補空白
						export += "User" + ","; // R80620 Conversion Type
						export += "1" + ","; // R80620 Conversion Rate
						export += strPCfmDt.trim() + ",";// 支付確認日迄日,YYYY/MM/DD,x(10)
						export += "BATCH,";
						export += count1;
						export += "\r\n";
					}
				}

				ByteArrayInputStream is = new ByteArrayInputStream(export.getBytes());
				int reader = 0;
				byte[] buffer = new byte[1 * 1024];
				while ((reader = is.read(buffer)) > 0) {
					os.write(buffer, 0, reader);
				}
			} catch (Exception e) {
				System.err.println(e.toString());
				throw e;
			} finally {
				os.flush();
				os.close();
			}
		} else {
			// 查無資料回傳錯誤訊息
			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg", "查無可下載資料,請重新查明!");
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccountingCode.jsp");
			dispatcher.forward(request, response);
		}
	}

	/**
	 * @param request
	 * @param response
	 * @return
	 */
	private List getUnNormalPayments(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) {

		Connection con = dbFactory.getAS400Connection("DISBAccCodeServlet.getUnNormalPayments()");
		DISBBean disbBean = new DISBBean(dbFactory);// R70088
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		List alReturn = new ArrayList();
		String strEntryStartDate = ""; // 輸入日期起日
		String strPStartDate = ""; // 付款日期起日
		String strCurrency = "";
		String company = "";//RD0382:OIU
		
		double iAmtD2 = 0; // 醫調總計
		double iAmtH1 = 0; // 債權扣押總計
		double iAmtSum1 = 0; // R70600 前次暫不開票總計
		double iAmtS1 = 0; // R80799酬佣支付總計

		strEntryStartDate = request.getParameter("txtEntryStartDate");
		if (strEntryStartDate != null)
			strEntryStartDate = strEntryStartDate.trim();
		else
			strEntryStartDate = "";

		strPStartDate = request.getParameter("txtPStartDate");
		if (strPStartDate != null)
			strPStartDate = strPStartDate.trim();
		else
			strPStartDate = "";

		// R10314
		String strPStartDateTemp = null;
		if (strEntryStartDate.length() < 7)
			strPStartDateTemp = "0" + strEntryStartDate;
		else
			strPStartDateTemp = strEntryStartDate;

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";
		
		//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}		

		// R10314
		String DateTemp = Integer.toString(1911 + Integer
				.parseInt(strPStartDateTemp.substring(0, 3)))
				+ "/"
				+ strPStartDateTemp.substring(3, 5)
				+ "/"
				+ strPStartDateTemp.substring(5, 7);
		String DateTemp1 = Integer.toString(1911 + Integer
				.parseInt(strPStartDateTemp.substring(0, 3)))
				+ strPStartDateTemp.substring(3, 5)
				+ strPStartDateTemp.substring(5, 7);

		/*
		 * 4. 取得符合支付確認日2 及 輸入日期不符合前端輸入日期區間的支付明細資料 -->支票/匯款/信用卡,
		 * 依各個付款方式,小計成一筆(貸方),為非急件者
		 */
		/* 5.列出4的明細(借方),為非急件者 */
		try {
			alReturn = alDwnDetails;
			/*
			 * 4. 取得符合支付確認日2 及 輸入日期不符合前端輸入日期區間的支付明細資料 -->支票/匯款/信用卡,
			 * 依各個付款方式,小計成一筆(貸方),為非急件者
			 */
			/* 取前次暫不發資料,為非急件者 */
			strSql = "select PAMT ,PMETHOD,PNAME,PCURR ";
			strSql += " from CAPPAYF ";
			strSql += "WHERE PCFMDT1<>0 AND PCFMTM1<>0 AND PCFMUSR1<>''   AND PCFMDT2<>0 AND PCFMTM2<>0 AND PCFMUSR2<>''   AND PDispatch<>'Y'  ";
			// strSql += " AND PSRCGP<>'WB' "; R10314
			strSql += " and PNO NOT IN (SELECT A.PNOH FROM CAPPAYF A WHERE A.PNOH <> '')"; // 20050603 added by Alice's request 排除匯退件的原始件
			strSql += " AND PAMT<>0 "; // 金額不為0者, 不帶入
			// R10314 strSql += " and PCFMDT2 between " + strPStartDate + "  and " +  strPEndDate ;
			strSql += " and PCFMDT2 = " + strPStartDate;
			// strSql += " and ( ENTRYDT < " + strEntryStartDate + " or ENTRYDT > " + strEntryEndDate + " )";
			strSql += " and ENTRYDT < " + strEntryStartDate;
			// R50891 VA美元保單
			strSql += " and PCURR ='" + strCurrency + "'";
			strSql += " AND PSRCCODE NOT IN ('D2','H1','S1') "; // R80799加入S1
			
			if("6".equals(company)){
				strSql += " AND PAY_COMPANY='OIU' ";
			}else if("0".equals(company)){
				strSql += " AND PAY_COMPANY<>'OIU' ";
			}
			
			strSql += " ORDER BY PMETHOD ";
			System.out.println("strSql_4:" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			// R70770 以下ZZ改為ZZZ
			while (rs.next()) {
				iAmtSum1 = iAmtSum1 + rs.getDouble("PAMT"); // R70600
			}
			System.out.println("iAmtSum1=" + iAmtSum1);
			// R70600 前次暫不開票加總成一筆
			if (iAmtSum1 > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("00000000000000000000000000");// R61017 由 13擴到26碼
				objAccCodeDetail.setStrDesc("前次暫不付款");
				objAccCodeDetail.setStrCAmt(df.format(iAmtSum1));
				if(!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrCAmt(df1.format(iAmtSum1));
				}
				objAccCodeDetail.setStrDAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;
			// System.out.println("4.alReturn.size()"+alReturn.size());

			// R60834 醫調及債權扣押各加總為一筆
			strSql = "select SUM(PAMT) AS SPAMT,PSRCGP,PSRCCODE,PCURR ";
			strSql += " from CAPPAYF ";
			strSql += "WHERE 1=1 and PCFMDT1<>0 AND PCFMTM1<>0 AND PCFMUSR1 <>''   AND PCFMTM2<>0 AND PCFMUSR2 <>''  and PDispatch <>'Y'  ";
			// strSql += " AND PSRCGP<>'WB' "; R10314：產生借方分錄時不排除人工輸入件
			strSql += " and PNO NOT IN (SELECT A.PNOH FROM CAPPAYF A WHERE A.PNOH <> '')";
			strSql += " AND PAMT<>0 AND PSRCCODE IN ('D2','H1','S1')";// R80799加入S1
			// strSql += " and PCFMDT2 between " + strPStartDate + " and " + strPEndDate ;
			strSql += " and PCFMDT2 = " + strPStartDate;// R10314
			strSql += " and PCURR ='" + strCurrency + "'  ";
			
			if("6".equals(company)){
				strSql += " AND PAY_COMPANY='OIU' ";
			}else if("0".equals(company)){
				strSql += " AND PAY_COMPANY<>'OIU' ";
			}
			
			strSql += " GROUP BY PSRCGP,PSRCCODE,PCURR ORDER BY PSRCGP,PSRCCODE ";

			System.out.println("strSql_5:" + strSql);
			rs = stmt.executeQuery(strSql);

			while (rs.next()) {
				if (rs.getString("PSRCCODE").trim().equals("D2")) {
					iAmtD2 = iAmtD2 + rs.getDouble("SPAMT");
				} else if (rs.getString("PSRCCODE").trim().equals("H1")) {
					iAmtH1 = iAmtH1 + rs.getDouble("SPAMT");
				}
				// R80799酬佣支付
				else if (rs.getString("PSRCCODE").trim().equals("S1")) {
					iAmtS1 = iAmtS1 + rs.getDouble("SPAMT");
				}
			}
			// 醫調加總一筆貸方金額
			System.out.println("iAmtD2=" + iAmtD2);
			System.out.println("iAmtH1=" + iAmtH1);
			System.out.println("iAmtS1=" + iAmtS1);
			if (iAmtD2 > 0) {
				DISBAccCodeDetailVO objAccCodeDetailD2 = new DISBAccCodeDetailVO();
				objAccCodeDetailD2.setStrActCd2("29004000ZZZ");
				objAccCodeDetailD2.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴到26碼
				objAccCodeDetailD2.setStrDesc("醫調");
				objAccCodeDetailD2.setStrCAmt(df.format(iAmtD2));
				objAccCodeDetailD2.setStrDAmt("0");
				objAccCodeDetailD2.setStrCheckDate(DateTemp1);
				objAccCodeDetailD2.setStrDate1(DateTemp);
				// R80132 objAccCodeDetailD2.setStrCurr(disbBean.getCurr(strCurrency.trim(),1));//R70088
				objAccCodeDetailD2.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					objAccCodeDetailD2.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailD2.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailD2.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				// R80132 END
				alReturn.add(objAccCodeDetailD2);
			}
			// 債權扣押加總一筆貸方金額
			if (iAmtH1 > 0) {
				DISBAccCodeDetailVO objAccCodeDetailH1 = new DISBAccCodeDetailVO();
				objAccCodeDetailH1.setStrActCd2("29004000ZZZ");
				objAccCodeDetailH1.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailH1.setStrDesc("債權扣押");
				objAccCodeDetailH1.setStrCAmt(df.format(iAmtH1));
				objAccCodeDetailH1.setStrDAmt("0");
				objAccCodeDetailH1.setStrCheckDate(DateTemp1);
				objAccCodeDetailH1.setStrDate1(DateTemp);
				// R80132
				// objAccCodeDetailH1.setStrCurr(disbBean.getCurr(strCurrency.trim(),1));
				objAccCodeDetailH1.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					objAccCodeDetailH1.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailH1.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailH1.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				} 
				// R80132 END
				alReturn.add(objAccCodeDetailH1);
			}
			// R80799酬佣支付加總一筆貸方金額
			if (iAmtS1 > 0) {
				DISBAccCodeDetailVO objAccCodeDetailS1 = new DISBAccCodeDetailVO();
				objAccCodeDetailS1.setStrActCd2("29004000ZZZ");
				objAccCodeDetailS1.setStrActCd5("00000000000000000000000000");
				objAccCodeDetailS1.setStrDesc("酬佣支付");
				objAccCodeDetailS1.setStrCAmt(df.format(iAmtS1));
				objAccCodeDetailS1.setStrDAmt("0");
				objAccCodeDetailS1.setStrCheckDate(DateTemp1);
				objAccCodeDetailS1.setStrDate1(DateTemp);
				objAccCodeDetailS1.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetailS1.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailS1.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}				
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailS1.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetailS1);
			}
			rs.close();
			strSql = null;

		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alReturn = null;
			log.error(ex.getMessage(), ex);
		} catch(Exception e){
			log.error(e.getMessage(), e);
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

	/**
	 * @param request
	 * @param response
	 * @return
	 */
	private List getNormalPayments(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) {

		Connection con = dbFactory.getAS400Connection("DISBAccCodeServlet.getNormalPayments()");
		DISBBean disbBean = new DISBBean(dbFactory);// R70088
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		List alReturn = new ArrayList();
		String strEntryStartDate = ""; // 輸入日期起日
		String strPStartDate = ""; // 付款日期起日
		String strCurrency = "";// 幣別
		String company = "";//RD0382:OIU

		double iAmtC = 0;// 非VPS總計(不含人工件) 20050603 FOR Alice's request
		double iAmtV = 0;// VPS總計(不含人工件、不含FF件) 20050603 FOR Alice's request
		double iAmtFV = 0;// VPS總計(不含人工件、含FF件) 20090512 For Megan's request
		double iAmtR = 0;// 匯退件總計 20050603 FOR Alice's request
		double iAmtRbyA = 0;// 支票作廢總計
		double iAmtRbyC = 0;// 信用卡失敗總計
		double iAmtRbyD = 0;// 外幣匯退總計 R70366
		double iAmtW = 0;// 人工件總計(不含匯退件) 20050603 FOR Alice's request

		double iAmtCD = 0;// 前次暫不開非VPS總計(不含人工件) 20050603 FOR Alice's request
		double iAmtVD = 0;// 前次暫不開VPS總計(不含人工件、不含FF件) 20050603 FOR Alice's
							// request
		double iAmtFVD = 0;// VPS總計(不含人工件、含FF件) 20090512 For Megan's request
		double iAmtRD = 0;// 前次暫不開匯退件總計 20050603 FOR Alice's request
		double iAmtRDbyA = 0;// 前次支票作廢總計
		double iAmtRDbyC = 0;// 前次信用卡失敗總計
		double iAmtRDbyD = 0;// 前次外幣匯退總計 R70366
		double iAmtWD = 0;// 前次暫不開人工件總計(不含匯退件) 20050603 FOR Alice's request

		double iAmtByA = 0;// 付款類別總金額 支票 20050603 FOR Alice's request
		double iAmtByB = 0;// 付款類別總金額 匯款 20050603 FOR Alice's request
		double iAmtByC = 0;// 付款類別總金額 信用卡 20050603 FOR Alice's request
		double iAmtByD = 0;// 付款類別總金額 外幣匯款 R60550

		double iAmtG = 0; // GTMS總計(不含人工件)
		double iAmtGD = 0; // 前次暫不開GTMS總計(不含人工件)
		// double iSubAmt=0;//暫不開非VPS小計 //拿掉暫不開小計資料 的小計
		// double iSubAmtV=0;// 暫不開VPS計計 //拿掉暫不開小計資料 的小計
		double iAmtSum2A = 0; // R70600 暫不開票總計
		double iAmtSum2B = 0; // R70600 暫不開票總計 GT
		double iAmtSum3A = 0; // R70600 急件已開票總計
		double iAmtSum3B = 0; // R70600 急件已開票總計 GT
		double iAmtSum4A = 0; // R70600 當日急件總計
		double iAmtSum4B = 0; // R70600 當日急件總計 GT
		double iAmtSum5A = 0; // R70600 作廢總計
		double iAmtSum5B = 0; // R70600 作廢總計 GT

		int iPCFMDate = 0;// R80822

		strEntryStartDate = request.getParameter("txtEntryStartDate");
		if (strEntryStartDate != null)
			strEntryStartDate = strEntryStartDate.trim();
		else
			strEntryStartDate = "";

		strPStartDate = request.getParameter("txtPStartDate");
		if (strPStartDate != null)
		{
			strPStartDate = strPStartDate.trim();
			iPCFMDate = Integer.parseInt(strPStartDate);
		}
		else
		{
			strPStartDate = "";
			iPCFMDate = 0;
		}

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";
		
		//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}

		// R10314
		String strPStartDateTemp = null;
		if (strPStartDate.length() < 7)
			strPStartDateTemp = "0" + strEntryStartDate;
		else
			strPStartDateTemp = strEntryStartDate;

		// R10314
		String DateTemp = Integer.toString(1911 + Integer
				.parseInt(strPStartDateTemp.substring(0, 3)))
				+ "/"
				+ strPStartDateTemp.substring(3, 5)
				+ "/"
				+ strPStartDateTemp.substring(5, 7);
		String DateTemp1 = Integer.toString(1911 + Integer
				.parseInt(strPStartDateTemp.substring(0, 3)))
				+ strPStartDateTemp.substring(3, 5)
				+ strPStartDateTemp.substring(5, 7);

		/* 1.取得符合輸入日期, 且已被確認2的支付明細資料 -->支票/匯款/信用卡, 依各個付款方式,小計成一筆(貸方) */
		/* 2.取得符合輸入日期, 且已未被確認2的支付明細資料 -->不分付款方式,列出各筆明細(貸方) */
		/* 3.加總1及2, 成一筆資料(借方) */
		try {
			stmt = con.createStatement();

			/* 1.取得符合輸入日期, 且已被確認2的支付明細資料 -->支票/匯款/信用卡, 依各個付款方式,小計成一筆(貸方),為非急件者 */
			// R60834退匯拆:退匯和支票作廢和信用卡失敗
			strSql = "select SUM(F.PAMT) AS SPAMT,F.PMETHOD AS PMETHOD,F.PPLANT AS PPLANT,F.PCURR AS PCURR,F.PSRCCODE AS PSRCCODE,H.PMETHOD AS HPMETHOD";
			strSql += ",CASE ";
			strSql += " WHEN F.PNOH <> '' THEN 'R' ";
			strSql += " WHEN  (F.PPLANT ='V' AND F.PSRCGP NOT IN('WB','GT')) then 'V' ";
			strSql += " WHEN  (F.PPLANT <>'V' AND F.PSRCGP NOT IN('WB','GT'))then 'C' ";
			strSql += " WHEN (F.PSRCGP = 'GT') THEN 'G'";
			strSql += " ELSE 'W' END AMTTYPE,F.PSRCGP AS PSRCGP ";
			strSql += " from CAPPAYF F ";
			strSql += "LEFT OUTER JOIN CAPPAYF H ON F.PNOH = H.PNO";
			strSql += " WHERE 1=1 and F.PCFMDT1<>0 AND F.PCFMTM1<>0 AND F.PCFMUSR1 <>''  and F.PCFMDT2<>0 AND F.PCFMTM2<>0 AND F.PCFMUSR2 <>''  and F.PDispatch <>'Y' ";
			strSql += " AND F.PAMT<>0 ";
			strSql += " AND F.PMETHOD IN ('A','C')";
			// R10314 strSql += " and F.PCFMDT2 between "+ strPStartDate+ "  and " + strPEndDate;
			strSql += " and F.PCFMDT2 = " + strPStartDate;
			strSql += " and F.PCURR = '" + strCurrency + "' ";
			
			if("6".equals(company)){
				strSql += " AND F.PAY_COMPANY='OIU' ";
			}else if("0".equals(company)){
				strSql += " AND F.PAY_COMPANY<>'OIU' ";
			}
			
			strSql += " GROUP BY F.PMETHOD,F.PPLANT,F.PSRCGP,F.PSRCCODE,F.PNOH,F.PCURR,H.PMETHOD ORDER BY PMETHOD,PPLANT ";
			// R60834END

			System.out.println("strSql_1_AC:" + strSql);
			rs = stmt.executeQuery(strSql);

			alReturn = alDwnDetails;

			while (rs.next()) {

				if (rs.getString("PMETHOD").trim().equals("A")) {
					iAmtByA = iAmtByA + rs.getDouble("SPAMT");

				} else if (rs.getString("PMETHOD").trim().equals("C")) {
					iAmtByC = iAmtByC + rs.getDouble("SPAMT");
				}

				// R60834
				if (rs.getString("PSRCCODE").equals("D2")
						|| rs.getString("PSRCCODE").equals("H1")
						|| rs.getString("PSRCCODE").equals("S1"))// R80714加入S1
				{
					continue;
				}
				else if (rs.getString("AMTTYPE").equals("V"))// VPS件加總 20050603 FOR Alice's request
				{
					if (!"FF".equals(rs.getString("PSRCGP")))
						iAmtV = iAmtV + rs.getDouble("SPAMT");
					else
						iAmtFV = iAmtFV + rs.getDouble("SPAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("C"))// CAPSIL件加總 20050603 FOR Alice's request
				{
					iAmtC = iAmtC + rs.getDouble("SPAMT");
				}
				// R60834 退匯拆:退匯和支票作廢和信用卡失敗
				else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("A")) {
					iAmtRbyA = iAmtRbyA + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("B")) {
					iAmtR = iAmtR + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("C")) {
					iAmtRbyC = iAmtRbyC + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("D")) {
					iAmtRbyD = iAmtRbyD + rs.getDouble("SPAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("W"))
				{
					iAmtW = iAmtW + rs.getDouble("SPAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("G"))
				{
					iAmtG = iAmtG + rs.getDouble("SPAMT");
				}
			}
			rs.close();
			// 條件同每日付款明細財務報表,付款方式信用卡及支票件者不同於匯款件, 20050603 added by Alice's
			// request
			strSql = null;
			/* 1.取得符合輸入日期, 且已被確認2的支付明細資料 -->支票/匯款/信用卡, 依各個付款方式,小計成一筆(貸方),為非急件者 */
			// R60834退匯拆:退匯和支票作廢和信用卡失敗
			strSql = "select SUM(F.PAMT) AS SPAMT,F.PMETHOD AS PMETHOD,F.PPLANT AS PPLANT,F.PCURR AS PCURR,F.PSRCCODE AS PSRCCODE,H.PMETHOD AS HPMETHOD";
			strSql += ",CASE ";
			strSql += " WHEN F.PNOH <> '' THEN 'R' ";
			strSql += " WHEN  (F.PPLANT ='V' AND F.PSRCGP NOT IN('WB','GT')) then 'V' ";
			strSql += " WHEN  (F.PPLANT <>'V' AND F.PSRCGP NOT IN('WB','GT'))then 'C' ";
			strSql += " WHEN  (F.PSRCGP = 'GT')then 'G' ";
			strSql += " ELSE 'W' END AMTTYPE,F.PSRCGP AS PSRCGP ";
			strSql += " from CAPPAYF F ";
			strSql += " LEFT OUTER JOIN CAPPAYF H ON F.PNOH = H.PNO ";
			strSql += " WHERE 1=1 and F.PCFMDT1<>0 AND F.PCFMTM1<>0 AND F.PCFMUSR1 <>''  and F.PCFMDT2<>0 AND F.PCFMTM2<>0 AND F.PCFMUSR2 <>''  and F.PDispatch <>'Y' ";
			strSql += " AND F.PAMT<>0 ";
			strSql += " AND F.PMETHOD in ('B','D') ";// R60550 加入外幣匯款
			strSql += " AND F.PDATE <= F.PCFMDT2 ";
			// R10314 strSql += " and F.PCFMDT2 between "+ strPStartDate+ "  and " + strPEndDate;
			strSql += " and F.PCFMDT2 = " + strPStartDate;
			strSql += " and F.PCURR = '" + strCurrency + "' ";
			
			if("6".equals(company)){
				strSql += " AND F.PAY_COMPANY='OIU' ";
			}else if("0".equals(company)){
				strSql += " AND F.PAY_COMPANY<>'OIU' ";
			}
			
			strSql += " GROUP BY F.PMETHOD,F.PPLANT,F.PSRCGP,F.PSRCCODE,F.PNOH,F.PCURR,H.PMETHOD ORDER BY PMETHOD,PPLANT ";
			// R60834END

			System.out.println("strSql_1_B:" + strSql);
			rs = stmt.executeQuery(strSql);

			while (rs.next()) {

				if (rs.getString("PMETHOD").trim().equals("B")) {
					iAmtByB = iAmtByB + rs.getDouble("SPAMT");
				} else if (rs.getString("PMETHOD").trim().equals("D")) {
					iAmtByD = iAmtByD + rs.getDouble("SPAMT");
				}

				// R60834 醫調.債權扣押各合併為一筆
				if (rs.getString("PSRCCODE").equals("D2")
						|| rs.getString("PSRCCODE").equals("H1")
						|| rs.getString("PSRCCODE").equals("S1")) // R80714加入S1
				{
					continue;
				}
				else if (rs.getString("AMTTYPE").equals("V"))
				{
					if (!"FF".equals(rs.getString("PSRCGP")))
						iAmtV = iAmtV + rs.getDouble("SPAMT");
					else
						iAmtFV = iAmtFV + rs.getDouble("SPAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("C"))
				{
					iAmtC = iAmtC + rs.getDouble("SPAMT");
				}
				else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("A")) {
					iAmtRbyA = iAmtRbyA + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("B")) {
					iAmtR = iAmtR + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("C")) {
					iAmtRbyC = iAmtRbyC + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("D")) {
					iAmtRbyD = iAmtRbyD + rs.getDouble("SPAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("W"))
				{
					iAmtW = iAmtW + rs.getDouble("SPAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("G"))
				{
					iAmtG = iAmtG + rs.getDouble("SPAMT");
				}
			}

			// 支票件加總一筆貸方金額 20050603 FOR Alice's request
			if (iAmtByA > 0) {
				DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();
				objAccCodeDetailM.setStrActCd2("27100000ZZZ");
				objAccCodeDetailM.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailM.setStrDesc("支票");
				objAccCodeDetailM.setStrDAmt(df.format(iAmtByA));
				objAccCodeDetailM.setStrCAmt("0");
				objAccCodeDetailM.setStrCheckDate(DateTemp1);
				objAccCodeDetailM.setStrDate1(DateTemp);
				objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					// R80132
					objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailM.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				} 
				// R80132 END
				alReturn.add(objAccCodeDetailM);
			}
			// 匯款件加總一筆貸方金額 20050603 FOR Alice's request

			if (iAmtByB > 0) {
				DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();
				objAccCodeDetailM.setStrActCd2("27100100ZZZ");
				objAccCodeDetailM.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailM.setStrDesc("匯款");
				objAccCodeDetailM.setStrDAmt(df.format(iAmtByB));
				objAccCodeDetailM.setStrCAmt("0");
				objAccCodeDetailM.setStrCheckDate(DateTemp1);
				objAccCodeDetailM.setStrDate1(DateTemp);
				// R80132
				objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					// R80132
					objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailM.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				// R80132 END

				alReturn.add(objAccCodeDetailM);
			}
			// 外幣匯款加總一筆貸方金額 R60550
			if (iAmtByD > 0) {
				DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();
				objAccCodeDetailM.setStrActCd2("27100100ZZZ");
				objAccCodeDetailM.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailM.setStrDesc("外幣匯款");
				objAccCodeDetailM.setStrDAmt(df.format(iAmtByD));
				if(!strCurrency.trim().equals("NT")) {
					objAccCodeDetailM.setStrDAmt(df1.format(iAmtByD));
				}
				objAccCodeDetailM.setStrCAmt("0");
				objAccCodeDetailM.setStrCheckDate(DateTemp1);
				objAccCodeDetailM.setStrDate1(DateTemp);
				// R80132
				objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					// R80132
					objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailM.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				// R80132 END
				alReturn.add(objAccCodeDetailM);
			}

			// 信用卡件加總一筆貸方金額 20050603 FOR Alice's request
			if (iAmtByC > 0) {
				DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();
				objAccCodeDetailM.setStrActCd2("11100000ZZZ");
				objAccCodeDetailM.setStrActCd5("P1000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailM.setStrDesc("信用卡");
				objAccCodeDetailM.setStrDAmt(df.format(iAmtByC));
				objAccCodeDetailM.setStrCAmt("0");
				objAccCodeDetailM.setStrCheckDate(DateTemp1);
				objAccCodeDetailM.setStrDate1(DateTemp);
				// R80132
				objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					// R80132
					objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailM.setStrActCd5("P1000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				} 
				alReturn.add(objAccCodeDetailM);
			}

			rs.close();

			strSql = null;
			// R60834退匯拆:退匯和支票作廢和信用卡失敗
			strSql = "select F.PAMT AS PAMT,F.PMETHOD AS PMETHOD,F.PNAME AS PNAME,F.PPLANT AS PPLANT,F.PSRCGP AS PSRCGP,F.PCURR AS PCURR,F.PCFMDT2 AS PCFMDT2,F.PDISPATCH AS PDISPATCH,F.PSRCCODE AS PSRCCODE,H.PMETHOD AS HPMETHOD";
			strSql += ",F.PVOIDABLE AS PVOIDABLE "; // R80822
			strSql += ",CASE ";
			strSql += " WHEN F.PNOH <> '' THEN 'R' ";
			strSql += " WHEN  (F.PPLANT ='V' AND F.PSRCGP NOT IN('WB','GT')) then 'V' ";
			strSql += " WHEN  (F.PPLANT <>'V' AND F.PSRCGP NOT IN('WB','GT'))then 'C' ";
			strSql += " WHEN  (F.PSRCGP='GT')then 'G' ";
			strSql += " ELSE 'W' END AMTTYPE,F.PSRCGP AS PSRCGP, IFNULL(H.REMITFAILD,0) as REMITFAILD ";
			strSql += " from CAPPAYF F ";
			strSql += "LEFT OUTER JOIN CAPPAYF H ON F.PNOH = H.PNO ";
			strSql += " WHERE F.PAMT<>0 ";
			strSql += " and ((F.PCFMDT2=0 AND F.PCFMTM2=0 AND F.PCFMUSR2 ='' ) OR (F.PCFMDT1<>0 AND F.PCFMTM1<>0 AND F.PCFMUSR1 <>''  and F.PCFMDT2<>0 AND F.PCFMTM2<>0 AND F.PCFMUSR2 <>''  and F.PDispatch ='Y' )) ";
			strSql += " and F.ENTRYDT = " + strEntryStartDate;
			strSql += " and F.PCURR = '" + strCurrency + "' ";
			
			if("6".equals(company)){
				strSql += " AND F.PAY_COMPANY='OIU' ";
			}else if("0".equals(company)){
				strSql += " AND F.PAY_COMPANY<>'OIU' ";
			}
			
			strSql += " ORDER BY PCFMDT2,PDISPATCH,PMETHOD";
			// R60834 END
			System.out.println("strSql_2:" + strSql);

			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			int i = 0;
			while (rs.next()) {
				
				if (rs.getString("PVOIDABLE").trim().equals("Y")) // R80822 作廢件
				{
					if (rs.getString("PNAME").trim().equals("GT")) {
						iAmtSum5B = iAmtSum5B + rs.getDouble("PAMT");
					} else {
						iAmtSum5A = iAmtSum5A + rs.getDouble("PAMT");
					}
				}
				else
				{
					if (rs.getString("PDispatch").trim().equals("Y") && rs.getInt("PCFMDT2") != 0) {
						if (rs.getInt("PCFMDT2") != iPCFMDate)
						{ // R80822 急件已開票
							if (rs.getString("PNAME").trim().equals("GT")) {
								iAmtSum3B = iAmtSum3B + rs.getDouble("PAMT");
							} else {
								iAmtSum3A = iAmtSum3A + rs.getDouble("PAMT");
							}
						}
						else
						{ // R80822 當日急件
							if (rs.getString("PNAME").trim().equals("GT"))
							{
								iAmtSum4B = iAmtSum4B + rs.getDouble("PAMT");
							} else {
								iAmtSum4A = iAmtSum4A + rs.getDouble("PAMT");
							}
						}
					} else {
						if (rs.getString("PNAME").trim().equals("GT")) {
							iAmtSum2B = iAmtSum2B + rs.getDouble("PAMT");
						} else {
							iAmtSum2A = iAmtSum2A + rs.getDouble("PAMT");
						}
					}
				}

				// 加總金額需區分是否為VPS
				String PPLANT = "";
				if (rs.getString("PPLANT") != null) {
					PPLANT = rs.getString("PPLANT");
				}
				if (!PPLANT.equals("")) {
					PPLANT = PPLANT.trim();
				}
				i++;
				// R10314
				if ((rs.getString("PSRCCODE").equals("D2") 
				      || rs.getString("PSRCCODE").equals("H1") 
				      || rs.getString("PSRCCODE").equals("S1")) // R80799加入S1
				      && rs.getInt("PCFMDT2") != 0) 
				{
					continue;
				}
				// R60834 醫調.債權扣押各合併為一筆 R10314
				//if (rs.getString("PSRCCODE").equals("D2")
						//|| rs.getString("PSRCCODE").equals("H1")
						//|| rs.getString("PSRCCODE").equals("S1")) // R80799加入S1
				//{
					//continue;
				//}
				//else if (rs.getString("AMTTYPE").equals("V"))
				if (rs.getString("AMTTYPE").equals("V"))
				{
					if (!"FF".equals(rs.getString("PSRCGP")))
						iAmtV = iAmtV + rs.getDouble("PAMT");
					else
						iAmtFV = iAmtFV + rs.getDouble("PAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("C"))
				{
					iAmtC = iAmtC + rs.getDouble("PAMT");
				}
				// R60834 退匯件拆退匯和支票作廢和信用卡失敗
				else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("B"))
				{
					iAmtR = iAmtR + rs.getDouble("PAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("A")) {
					iAmtRbyA = iAmtRbyA + rs.getDouble("PAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("C")) {
					iAmtRbyC = iAmtRbyC + rs.getDouble("PAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("D")) {
					iAmtRbyD = iAmtRbyD + rs.getDouble("PAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("W"))
				{
					iAmtW = iAmtW + rs.getDouble("PAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("G"))
				{
					iAmtG = iAmtG + rs.getDouble("PAMT");
				}
			}
			System.out.println("strSql_2"+iAmtW);
			// R70600 暫不開票各加總成一筆
			if (iAmtSum2A > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("00000000000000000000000000");
				objAccCodeDetail.setStrDesc("暫不付款");
				objAccCodeDetail.setStrDAmt(df.format(iAmtSum2A));
				if(!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrDAmt(df1.format(iAmtSum2A));
				}
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}				
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}

			if (iAmtSum2B > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("01000000000000000000000000");
				objAccCodeDetail.setStrDesc("暫不付款GT");
				objAccCodeDetail.setStrDAmt(df.format(iAmtSum2B));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("01000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}

			// R70600 急件已開票加總成一筆
			if (iAmtSum3A > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("00000000000000000000000000");
				objAccCodeDetail.setStrDesc("急件已開票");
				objAccCodeDetail.setStrDAmt(df.format(iAmtSum3A));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}

			if (iAmtSum3B > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("01000000000000000000000000");
				objAccCodeDetail.setStrDesc("急件已開票GT");
				objAccCodeDetail.setStrDAmt(df.format(iAmtSum3B));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("01000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}

			// R80822 當日急件
			if (iAmtSum4A > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("00000000000000000000000000");
				objAccCodeDetail.setStrDesc("當日急件");
				objAccCodeDetail.setStrDAmt(df.format(iAmtSum4A));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}

			if (iAmtSum4B > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("01000000000000000000000000");
				objAccCodeDetail.setStrDesc("當日急件GT");
				objAccCodeDetail.setStrDAmt(df.format(iAmtSum4B));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("01000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}

			// R80822 作廢件
			if (iAmtSum5A > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("00000000000000000000000000");
				objAccCodeDetail.setStrDesc("作廢件");
				objAccCodeDetail.setStrDAmt(df.format(iAmtSum5A));
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrDAmt(df1.format(iAmtSum5A));
				}
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}
			if (iAmtSum5B > 0) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd5("01000000000000000000000000");
				objAccCodeDetail.setStrDesc("作廢件GT");
				objAccCodeDetail.setStrDAmt(df.format(iAmtSum5B));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("01000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetail);
			}

			rs.close();
			strSql = null;
			/*
			 * 4. 取得符合支付確認日2 及 輸入日期不符合前端輸入日期區間的支付明細資料 -->支票/匯款/信用卡,
			 * 依各個付款方式,小計成一筆(貸方),為非急件者
			 */
			// R60834退匯拆:退匯和支票作廢和信用卡失敗
			strSql = "select SUM(F.PAMT) AS SPAMT,F.PMETHOD AS PMETHOD,F.PPLANT AS PPLANT,F.PCURR AS PCURR,H.PMETHOD AS HPMETHOD";
			strSql += ",CASE ";
			strSql += " WHEN F.PNOH <> '' THEN 'R' ";
			strSql += " WHEN  (F.PPLANT ='V' AND F.PSRCGP NOT IN('WB','GT')) then 'V' ";
			strSql += " WHEN  (F.PPLANT <>'V' AND F.PSRCGP NOT IN('WB','GT'))then 'C' ";
			strSql += " WHEN  (F.PSRCGP = 'GT' )then 'G' ";
			strSql += " ELSE 'W' END AMTTYPE,F.PSRCGP AS PSRCGP ";
			strSql += " from CAPPAYF F ";
			strSql += " LEFT OUTER JOIN CAPPAYF H ON F.PNOH = H.PNO ";
			strSql += " WHERE 1=1 and F.PCFMDT1<>0 AND F.PCFMTM1<>0 AND F.PCFMUSR1 <>''   AND F.PCFMTM2<>0 AND F.PCFMUSR2 <>''  and F.PDispatch <>'Y'  AND F.PSRCGP<>'WB' ";//R10314
			strSql += " AND F.PAMT<>0 ";
			strSql += " and F.PCFMDT2 = " + strPStartDate;// R10314
			strSql += " and F.ENTRYDT <> " + strEntryStartDate;// R10314
			strSql += " and F.PCURR = '" + strCurrency + "'";
			strSql += " AND F.PSRCCODE NOT IN ('D2','H1','S1') ";// R80799加入S1
			
			if("6".equals(company)){
				strSql += " AND F.PAY_COMPANY='OIU' ";
			}else if("0".equals(company)){
				strSql += " AND F.PAY_COMPANY<>'OIU' ";
			}
			
			strSql += " GROUP BY F.PMETHOD,F.PPLANT,F.PSRCGP,F.PNOH,F.PCURR,H.PMETHOD ORDER BY PMETHOD ";
			// R60834END
			System.out.println("strSql_3_D:" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			while (rs.next()) {
				if (rs.getString("AMTTYPE").equals("V"))
				{
					if (!"FF".equals(rs.getString("PSRCGP")))
						iAmtVD = iAmtVD + rs.getDouble("SPAMT");
					else
						iAmtFVD = iAmtFVD + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("C"))
				{
					iAmtCD = iAmtCD + rs.getDouble("SPAMT");
				}
				// R60834 退匯拆退匯及支票作廢
				else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("B")) {
					iAmtRD = iAmtRD + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("A")) {
					iAmtRDbyA = iAmtRDbyA + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("C")) {
					iAmtRDbyC = iAmtRDbyC + rs.getDouble("SPAMT");
				} else if (rs.getString("AMTTYPE").equals("R") && rs.getString("HPMETHOD").trim().equals("D")) {
					iAmtRDbyD = iAmtRDbyD + rs.getDouble("SPAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("W"))
				{
					iAmtWD = iAmtWD + rs.getDouble("SPAMT");
				} 
				else if (rs.getString("AMTTYPE").equals("G")) 
				{
					iAmtGD = iAmtGD + rs.getDouble("SPAMT");
				}
			}
			rs.close();

			strSql = null;
			// 20050603 marked by Alice's request end*/
			if (alReturn.size() > 0) {
				/* 20050603 FOR Alice's request 取得總計資料 為退匯人工件 */
				DISBAccCodeDetailVO objAccCodeDetailR = new DISBAccCodeDetailVO();
				System.out.println("iAmtR=" + iAmtR);
				System.out.println("iAmtRD=" + iAmtRD);
				objAccCodeDetailR.setStrActCd2("29004000ZZZ");
				objAccCodeDetailR.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				// R10314
				if (strEntryStartDate.length() < 7)
					strEntryStartDate = "0" + strEntryStartDate;
				objAccCodeDetailR.setStrDesc("退匯件-執行日期" + Integer.toString(1911 + Integer.parseInt(strEntryStartDate.substring(0, 3))) + "/" + strEntryStartDate.substring(3, 5) + "/" + strEntryStartDate.substring(5, 7));// R10314“退匯件–”+該筆支付資料的[退匯日期]，需進行日期格式轉換
				objAccCodeDetailR.setStrCAmt(df.format(iAmtR - iAmtRD));
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailR.setStrCAmt(df1.format(iAmtR - iAmtRD));
				}
				objAccCodeDetailR.setStrDAmt("0");
				objAccCodeDetailR.setStrCheckDate(DateTemp1);
				objAccCodeDetailR.setStrDate1(DateTemp);
				objAccCodeDetailR.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailR.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					// R80132
					objAccCodeDetailR.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailR.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				} 
				// R80132 EMD
				alReturn.add(objAccCodeDetailR);

				// R60834 取得總計資料 為支票作廢件
				DISBAccCodeDetailVO objAccCodeDetailRbyA = new DISBAccCodeDetailVO();
				System.out.println("iAmtRbyA=" + iAmtRbyA);
				System.out.println("iAmtRDbyA=" + iAmtRDbyA);
				objAccCodeDetailRbyA.setStrActCd2("29004000ZZZ");
				objAccCodeDetailRbyA.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailRbyA.setStrDesc("支票作廢");
				objAccCodeDetailRbyA.setStrCAmt(df.format(iAmtRbyA - iAmtRDbyA));
				objAccCodeDetailRbyA.setStrDAmt("0");
				objAccCodeDetailRbyA.setStrCheckDate(DateTemp1);
				objAccCodeDetailRbyA.setStrDate1(DateTemp);
				objAccCodeDetailRbyA.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailRbyA.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					// R80132
					objAccCodeDetailRbyA.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailRbyA.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				} 
				// R80132 END
				alReturn.add(objAccCodeDetailRbyA);

				// R60834 取得總計資料 為信用卡失敗件
				DISBAccCodeDetailVO objAccCodeDetailRbyC = new DISBAccCodeDetailVO();
				System.out.println("iAmtRbyC=" + iAmtRbyC);
				System.out.println("iAmtRDbyC=" + iAmtRDbyC);
				objAccCodeDetailRbyC.setStrActCd2("29004000ZZZ");
				objAccCodeDetailRbyC.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				//RA0102 修改會計摘要
				objAccCodeDetailRbyC.setStrDesc("信用卡失敗-執行日期" + Integer.toString(1911 + Integer.parseInt(strEntryStartDate.substring(0, 3))) + "/" + strEntryStartDate.substring(3, 5) + "/" + strEntryStartDate.substring(5, 7));
				objAccCodeDetailRbyC.setStrCAmt(df.format(iAmtRbyC - iAmtRDbyC));
				objAccCodeDetailRbyC.setStrDAmt("0");
				objAccCodeDetailRbyC.setStrCheckDate(DateTemp1);
				objAccCodeDetailRbyC.setStrDate1(DateTemp);
				objAccCodeDetailRbyC.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailRbyC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailRbyC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailRbyC.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetailRbyC);

				// R70366新增外幣匯退
				DISBAccCodeDetailVO objAccCodeDetailRbyD = new DISBAccCodeDetailVO();
				System.out.println("iAmtRbyD=" + iAmtRbyD);
				System.out.println("iAmtRDbyD=" + iAmtRDbyD);
				objAccCodeDetailRbyD.setStrActCd2("29004000ZZZ");
				objAccCodeDetailRbyD.setStrActCd5("00000000000000000000000000");
				//RA0102 修改會計摘要
				objAccCodeDetailRbyD.setStrDesc("外幣退匯-執行日期" + Integer.toString(1911 + Integer.parseInt(strEntryStartDate.substring(0, 3))) + "/" + strEntryStartDate.substring(3, 5) + "/" + strEntryStartDate.substring(5, 7));
				objAccCodeDetailRbyD.setStrCAmt(df.format(iAmtRbyD - iAmtRDbyD));
				if(!strCurrency.trim().equals("NT")) {
					objAccCodeDetailRbyD.setStrCAmt(df1.format(iAmtRbyD - iAmtRDbyD));
				}
				objAccCodeDetailRbyD.setStrDAmt("0");
				objAccCodeDetailRbyD.setStrCheckDate(DateTemp1);
				objAccCodeDetailRbyD.setStrDate1(DateTemp);
				objAccCodeDetailRbyD.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailRbyD.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailRbyD.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailRbyD.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				} // R80132 END
				alReturn.add(objAccCodeDetailRbyD);

				/* 取得總計資料 為非VPS件 */
				DISBAccCodeDetailVO objAccCodeDetailC = new DISBAccCodeDetailVO();
				System.out.println("iAmtC=" + iAmtC);
				System.out.println("iAmtCD=" + iAmtCD);
				objAccCodeDetailC.setStrActCd2("29004000ZZZ");
				objAccCodeDetailC.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailC.setStrDesc("非人工CAPSIL件");
				objAccCodeDetailC.setStrCAmt(df.format(iAmtC - iAmtCD));
				objAccCodeDetailC.setStrDAmt("0");
				objAccCodeDetailC.setStrCheckDate(DateTemp1);
				objAccCodeDetailC.setStrDate1(DateTemp);
				objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailC.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetailC);

				/* 取得總計資料 為VPS件 科目為29004001ZZ */
				System.out.println("iAmtV=" + iAmtV);
				System.out.println("iAmtVD=" + iAmtVD);
				DISBAccCodeDetailVO objAccCodeDetailV = new DISBAccCodeDetailVO();
				objAccCodeDetailV.setStrActCd2("29004001ZZZ");
				objAccCodeDetailV.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailV.setStrDesc("非人工VPS件");
				objAccCodeDetailV.setStrCAmt(df.format(iAmtV - iAmtVD));
				objAccCodeDetailV.setStrDAmt("0");
				objAccCodeDetailV.setStrCheckDate(DateTemp1);
				objAccCodeDetailV.setStrDate1(DateTemp);
				objAccCodeDetailV.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailV.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailV.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailV.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetailV);

				/* 取得總計資料 為FF非人工VPS件 科目為29004000ZZ */
				System.out.println("iAmtFV=" + iAmtFV);
				System.out.println("iAmtFVD=" + iAmtFVD);
				DISBAccCodeDetailVO objAccCodeDetailFV = new DISBAccCodeDetailVO();
				objAccCodeDetailFV.setStrActCd2("29004000ZZZ");
				objAccCodeDetailFV.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailFV.setStrDesc("FF非人工VPS件");
				objAccCodeDetailFV.setStrCAmt(df.format(iAmtFV - iAmtFVD));
				objAccCodeDetailFV.setStrDAmt("0");
				objAccCodeDetailFV.setStrCheckDate(DateTemp1);
				objAccCodeDetailFV.setStrDate1(DateTemp);
				objAccCodeDetailFV.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailFV.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailFV.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailV.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetailFV);

				/* 20050603 FOR Alice's request 取得總計資料 為非匯退人工件 */
				System.out.println("iAmtW=" + iAmtW);
				System.out.println("iAmtWD=" + iAmtWD);
				DISBAccCodeDetailVO objAccCodeDetailW = new DISBAccCodeDetailVO();
				objAccCodeDetailW.setStrActCd2("29004000ZZZ");
				objAccCodeDetailW.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailW.setStrDesc("人工非退匯件");
				objAccCodeDetailW.setStrCAmt(df.format(iAmtW - iAmtWD));
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailW.setStrCAmt(df1.format(iAmtW - iAmtWD));
				}
				objAccCodeDetailW.setStrDAmt("0");
				objAccCodeDetailW.setStrCheckDate(DateTemp1);
				objAccCodeDetailW.setStrDate1(DateTemp);
				objAccCodeDetailW.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailW.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailW.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailW.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetailW);

				/* 20051123 FOR Alice's request 取得總計資料 為GTMS件 */
				System.out.println("iAmtG=" + iAmtG);
				System.out.println("iAmtGD=" + iAmtGD);
				DISBAccCodeDetailVO objAccCodeDetailG = new DISBAccCodeDetailVO();
				objAccCodeDetailG.setStrActCd2("29004040ZZZ");
				objAccCodeDetailG.setStrActCd5("00000000000000000000000000");// R61017 ActCd5由13擴為26碼
				objAccCodeDetailG.setStrDesc("GTMS");
				objAccCodeDetailG.setStrCAmt(df.format(iAmtG - iAmtGD));
				objAccCodeDetailG.setStrDAmt("0");
				objAccCodeDetailG.setStrCheckDate(DateTemp1);
				objAccCodeDetailG.setStrDate1(DateTemp);
				objAccCodeDetailG.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				
				if("6".equals(company)){
					//RD0382:OIU
					objAccCodeDetailG.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}else {
					objAccCodeDetailG.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "300" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				
				if (!strCurrency.trim().equals("NT")) {
					objAccCodeDetailG.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				alReturn.add(objAccCodeDetailG);
			}
		} catch (SQLException ex) {
			System.err.println("ex" + ex);
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alReturn = null;
		} catch (Exception ex) {
			System.err.println("ex" + ex);
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
		System.out.println("alReturn1=" + alReturn.size());
		return alReturn;
	}
}
