package com.aegon.disb.disbmaintain;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;

import org.apache.log4j.Logger;

/**
 * System   : CashWeb
 * 
 * Function : 出納匯款會計分錄
 * 
 * Remark   : 管理系統─財務
 * 
 * Revision : $$Revision: 1.12 $$
 * 
 * Author   : Odin Tsai
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R80338
 * 
 * CVS History:
 * 
 * $$Log: DISBAccFinRmtServlet.java,v $
 * $Revision 1.12  2015/12/03 02:42:27  001946
 * $*** empty log message ***
 * $
 * $Revision 1.11  2015/11/24 04:16:07  001946
 * $*** empty log message ***
 * $
 * $Revision 1.10  2015/06/04 03:36:15  001946
 * $*** empty log message ***
 * $
 * $Revision 1.9  2014/08/05 03:15:12  missteven
 * $RC0036
 * $
 * $Revision 1.8  2013/12/24 03:00:05  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.6  2010/11/23 06:41:13  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.5  2010/11/18 12:22:17  MISJIMMY
 * $R00386 美元保單
 * $
 * $Revision 1.4  2008/10/31 09:46:54  MISODIN
 * $R80413_應收帳款逾期轉其他收入
 * $
 * $Revision 1.3  2008/10/23 02:30:36  MISODIN
 * $Q80628 資料重覆問題之修正
 * $
 * $Revision 1.2  2008/09/17 01:53:05  MISODIN
 * $R80338 出納匯款分錄格式調整
 * $
 * $Revision 1.1  2008/08/06 06:51:19  MISODIN
 * $R80338 調整CASH系統 for 出納外幣一對一需求
 * $
 * $$
 *  
 */

public class DISBAccFinRmtServlet extends InitDBServlet {
	
	Logger log = Logger.getLogger(getClass());

	private static final long serialVersionUID = -6516165572906219789L;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private DecimalFormat df2 = new DecimalFormat("0.00");
	private DecimalFormat df3 = new DecimalFormat("0.0000"); // R80338 匯率
	private String company = "";//RD0382:OIU

	public void init() throws ServletException {
		super.init();
	}

	// Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	// Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);

		try {
			this.downloadProcess(request, response);
		} catch (Exception e) {
			System.err.println(e.toString());
			request.setAttribute("txtMsg", e.getMessage());
			RequestDispatcher dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccFinRmt.jsp");
			dispatcher.forward(request, response);
		}

	}

	private void downloadProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
		System.out.println("inside downloadProcess");
		List<DISBAccCodeDetailVO> alDwnDetails = new ArrayList<DISBAccCodeDetailVO>();

		String selCurrency = request.getParameter("selCurrency") != null ? request.getParameter("selCurrency") : "";
		String strPMethod = request.getParameter("PMethod") != null ? request.getParameter("PMethod") : "";
		
		//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}

		//取得資料
		alDwnDetails = (List<DISBAccCodeDetailVO>) getNormalPayments(request, response, alDwnDetails);
		System.out.println("alDwnDetails=是" + alDwnDetails.size());

		if (alDwnDetails.size() > 0) {
			ServletOutputStream os = response.getOutputStream();

			try {
				/* ConvertData */

				response.setContentType("application/vnd.ms-excel");           
				response.setHeader("Content-Disposition", "inline; filename=AccFinRmtDetails.xls");

				String strActCd1 = null;
				String strActCd2 = null;
				String strActCd3 = null;
				String strActCd4 = null;
				String strActCd5 = null;
				String strDesc = null;
				String strSlipNo = null;
				String strDAmt = null;
				String strCAmt = null;
				String strPCfmDt = null;
				String strPAYCurrency = null;
				String strConverRate = null; // R80338 匯率
				String strCDAmt = null;
				String strCCAmt = null;
				String count1 = null;

				HSSFWorkbook workbook = new HSSFWorkbook();
				HSSFSheet sheet = workbook.createSheet("Sheet1");
				int rownum = 0;

				for (int i = 0; i < alDwnDetails.size(); i++) {
					DISBAccCodeDetailVO objAccCodeDetail = (DISBAccCodeDetailVO) alDwnDetails.get(i);

					strPAYCurrency = CommonUtil.AllTrim(objAccCodeDetail.getStrCurr());

					strActCd1 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd1());
					strActCd2 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd2());
					strActCd3 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd3());
					strActCd4 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd4());
					strActCd5 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd5());
					strPCfmDt = CommonUtil.AllTrim(objAccCodeDetail.getStrDate1());
					strDAmt = CommonUtil.AllTrim(objAccCodeDetail.getStrDAmt());
					strCAmt = CommonUtil.AllTrim(objAccCodeDetail.getStrCAmt());
					// DESCRIPTION,x(30) 因為中文的問題, 所以長度需用strDesc.getBytes().length取得
					strDesc = objAccCodeDetail.getStrDesc() == null ? "" : CommonUtil.AllTrim(objAccCodeDetail.getStrDesc());
					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}
					strSlipNo = CommonUtil.AllTrim(objAccCodeDetail.getStrSlipNo());
					strConverRate = CommonUtil.AllTrim(objAccCodeDetail.getStrConverRate());

					strCDAmt = CommonUtil.AllTrim(objAccCodeDetail.getConversionDebit());
					strCCAmt = CommonUtil.AllTrim(objAccCodeDetail.getConversionCredit());

					count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) {
						count1 = "0" + count1;
					}

					int cellnum = 0;
					Row row = sheet.createRow(rownum++);
					Cell cell = row.createCell(cellnum++);
					cell.setCellValue("Manual");		//Category,A
					cell = row.createCell(cellnum++);
					cell.setCellValue("Spreadsheet");	//Source,B
					cell = row.createCell(cellnum++);
					if("6".equals(company) && "外幣匯款匯費".equals(strDesc.trim())){
						cell.setCellValue("USD");	//Currency,C
					}else{
						cell.setCellValue(strPAYCurrency);	//Currency,C
					}					
					cell = row.createCell(cellnum++);
					//RD0382,OIU專案的公司別
					if("6".equals(company)){
						cell.setCellValue("6");				//Company,D
					}else {
						cell.setCellValue("0");				//Company,D
					}
					
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd2);		//Main Account,E
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd1.substring(0, 1));	//Channel,F
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd1.substring(1, 2));	//LOB,G
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd1.substring(2, 3));	//PERIOD,H
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd1.substring(3, 5));	//Plan Code,I
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd3.substring(0, 3));	//INVESTMENT,J
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd3.substring(3, 4));	//INVESTMENT SEQ,K
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd4.substring(0, 2));	//DEPARTMENT,L
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd4.substring(2, 4));	//PARTNER,M
					cell = row.createCell(cellnum++);
					cell.setCellValue("000000000000000");			//FUTURE1,N
					cell = row.createCell(cellnum++);
					cell.setCellValue("000");		//FUTURE2,O
					cell = row.createCell(cellnum++);
					cell.setCellValue("0");		//FUTURE3,P
					cell = row.createCell(cellnum++);
					cell.setCellValue("00");		//FUTURE4,Q
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd5);	//FUTURE5,R
					cell = row.createCell(cellnum++);
					cell.setCellValue(strPCfmDt);	//出納確認日,(西元)YYYY/MM/DD,x(10),S
					cell = row.createCell(cellnum++);
					//cell.setCellValue(strCAmt);		//借方金額, x(13), 若為0, 則為空白,T
					if(strCAmt.equals("0"))
	                    cell.setCellValue("");
	                else
	                    cell.setCellValue(Double.parseDouble(strCAmt));
					cell = row.createCell(cellnum++);
					//cell.setCellValue(strDAmt);		//貸方金額, x(13), 若為0, 則為空白,U
					 if(strDAmt.equals("0"))
	                    cell.setCellValue("");
	                else
	                    cell.setCellValue(Double.parseDouble(strDAmt));
					cell = row.createCell(cellnum++);
					cell.setCellValue(strSlipNo);	//Journal Name, x(15), 出納確認日之西元年後二碼+MMDD + 3個特定碼 + 幣別,V
					cell = row.createCell(cellnum++);
					cell.setCellValue(strDesc);		//Line Description, x(30),W
					cell = row.createCell(cellnum++);
					cell.setCellValue("User");		//Conversion Type,X
					cell = row.createCell(cellnum++);
					//cell.setCellValue(strConverRate); //Conversion Rate,Y
					cell.setCellValue(Double.parseDouble(strConverRate));//Conversion Rate,Y
					cell = row.createCell(cellnum++);
					cell.setCellValue(strPCfmDt);	//出納確認日,(西元)YYYY/MM/DD,x(10),Z
					cell = row.createCell(cellnum++);
					if(selCurrency.equals("NT") && strPMethod.equals("D"))
					{
	                    if(strCDAmt.equals("0"))
	                        cell.setCellValue("");
	                    else
	                        cell.setCellValue(Double.parseDouble(strCDAmt));
	                    cell = row.createCell(cellnum++);
	                    if(strCCAmt.equals("0"))
	                        cell.setCellValue("");
	                    else
	                        cell.setCellValue(Double.parseDouble(strCCAmt));
	                    cell = row.createCell(cellnum++);
					}

					cell.setCellValue(strSlipNo);	//Batch Name,AA
					//log.info("strSlipNo是" + strSlipNo);
					cell = row.createCell(cellnum++);
					cell.setCellValue(count1); //AB
				}

				workbook.write(os);

			} catch (Exception e) {
				System.err.println(e.toString());
				throw e;
			} finally {
				os.flush();
				os.close();
			}
		} else {
			// 查無資料回傳錯誤訊息
			request.setAttribute("txtMsg", "查無可下載資料,請重新查明!");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccFinRmt.jsp");
			dispatcher.forward(request, response);
		}
	}

	private List<DISBAccCodeDetailVO> getNormalPayments(HttpServletRequest request, HttpServletResponse response, List<DISBAccCodeDetailVO> alDwnDetails) {
		Connection con = dbFactory.getAS400Connection("DISBAccFinRmtServlet.getNormalPayments()");
		DISBBean disbBean = new DISBBean(dbFactory);
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		List<DISBAccCodeDetailVO> alReturn = new ArrayList<DISBAccCodeDetailVO>();
		String strPStartDate = ""; // 出納確認日起日
		String strPEndDate = ""; // 出納確認日迄日
		String strPStartDate2 = ""; // 會計確認日起日(支付確認日二)
		String strPEndDate2 = ""; // 會計確認日迄日(支付確認日二)
		String strCurrency = "";// 保單幣別
		String strPMethod = "";// 付款方式
		String strActCode4_1 = ""; // 部門 for 匯費
		String strActCode4_2 = ""; // 付款幣別 for 規則
		String strSlipCode = "";
		String strDEPT = "";
		String DateTemp = ""; // 出納確認日
		String DateTemp1 = ""; // 出納日 -1
		String strDesc_1 = "";
		String strPDispatch = "";
		String company = "";//RD0382:OIU

		String strPPAYCURR_Keep_1 = "";
		String strPBK_Keep_1 = "";
		String strPACCT_Keep_1 = "";
		int iPCSHCM_Keep_1 = 0;
		int iPCSHDT_Keep_1 = 0;
		String strPPAYCURR_Keep_2 = "";
		String strPBK_Keep_2 = "";
		String strPACCT_Keep_2 = "";
		int iPCSHCM_Keep_2 = 0;
		int iPCSHDT_Keep_2 = 0;

		int iPCSHCM = 0; // 出納確認日 (匯款日)
		int iPCSHDT = 0; // 出納日期 (出納執行日)
		double iConverRate = 0; // 1/匯率
		double iConverRate2 = 0; // 匯率

		double iAmtRMTFEE = 0; // 匯費
		//RC0036
		double iAmtRMTFEE_CSC = 0; // 匯費
		double iAmtRMTFEE_CSC_BRCH = 0; // 匯費
		double iAmtRMTFEE_NB = 0; // 匯費
		double iAmtRMTFEE_CLM = 0; // 匯費
		double iPayAmt_TOT_1 = 0; // 支付金額
		double iPayAmt_TOT_2 = 0; // 支付金額 + 匯費
		double iRMTFEE_TOT_1 = 0; // 匯費
		double iPPayAmy_TOT = 0;
		double iRPAYRATE = 0;

		strPStartDate = request.getParameter("txtPStartDate");
		if (strPStartDate != null)
			strPStartDate = strPStartDate.trim();
		else
			strPStartDate = "";

		strPEndDate = request.getParameter("txtPEndDate");
		if (strPEndDate != null)
			strPEndDate = strPEndDate.trim();
		else
			strPEndDate = "";

		strPStartDate2 = request.getParameter("txtPStartDate2");
		if (strPStartDate2 != null)
			strPStartDate2 = strPStartDate2.trim();
		else
			strPStartDate2 = "";

		strPEndDate2 = request.getParameter("txtPEndDate2");
		if (strPEndDate2 != null)
			strPEndDate2 = strPEndDate2.trim();
		else
			strPEndDate2 = "";

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";

		strPMethod = request.getParameter("PMethod");
		if (strPMethod != null)
			strPMethod = strPMethod.trim();
		else
			strPMethod = "";
		
		//RC0036
		strPDispatch = request.getParameter("pDispatch");
		if (strPDispatch != null)
			strPDispatch = strPDispatch.trim();
		else
			strPDispatch = "";
		
		//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}

		try {
			alReturn = alDwnDetails;

			strSql = null;

			if (strPMethod.trim().equals("D")) {
				strSql = "select C.PPAYCURR AS PPAYCURR,A.PBK AS PBK,A.PACCT AS PACCT,C.PCSHCM AS PCSHCM,C.PCSHDT AS PCSHDT,";
				strSql += "B.DEPT AS DEPT,";
				/*strSql += "CASE WHEN SUBSTR(B.DFTGRP,1,3)='CSC' THEN 'CSC' ";//RE0225-新增匯費對應碼規則
				strSql += "WHEN SUBSTR(B.DFTGRP,1,2)='NB' THEN 'NB' ";//RE0225-新增匯費對應碼規則
				strSql += "WHEN SUBSTR(B.DFTGRP,1,3)='CLAM' THEN 'CLM' ";//RE0225-新增匯費對應碼規則
				strSql += "WHEN SUBSTR(B.DFTGRP,1,2)='PA' THEN 'PA' ";//RE0225-新增匯費對應碼規則
				strSql += "WHEN SUBSTR(B.DFTGRP,1,5)='Group' THEN 'GP' ";//RE0225-新增匯費對應碼規則
				strSql += "WHEN SUBSTR(B.DFTGRP,1,3)='FIN' THEN 'FIN' ";//RE0225-新增匯費對應碼規則
				strSql += "ELSE '' END AS DEPT,";//RE0225-新增匯費對應碼規則
*/				strSql += "A.RPAYRATE,SUM(A.RAMT) AS RAMT,SUM(A.RMTFEE) AS RMTFEE,SUM(A.RPAYAMT) as RPAYAMT";			
			} else {
				if (!strPDispatch.trim().equals("Y")){//RC0036
					//strSql = "select A.PBK AS PBK,A.PACCT AS PACCT,C.PCSHCM AS PCSHCM,C.PCSHDT AS PCSHDT,B.DEPT AS DEPT,SUM(A.RAMT) AS RAMT,SUM(A.RMTFEE) AS RMTFEE";
					//TEST 
					strSql = "SELECT T.PBK AS PBK,T.PACCT AS PACCT,T.PCSHCM AS PCSHCM,T.PCSHDT AS PCSHDT,";
					strSql += "T.DEPT AS DEPT,";
					/*strSql += "CASE WHEN SUBSTR(T.DFTGRP,1,3)='CSC' THEN 'CSC' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(T.DFTGRP,1,2)='NB' THEN 'NB' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(T.DFTGRP,1,3)='CLAM' THEN 'CLM' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(T.DFTGRP,1,2)='PA' THEN 'PA' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(T.DFTGRP,1,5)='Group' THEN 'GP' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(T.DFTGRP,1,3)='FIN' THEN 'FIN' ";//RE0225-新增匯費對應碼規則
					strSql += "ELSE '' END AS DEPT,";//RE0225-新增匯費對應碼規則
*/					strSql += " SUM(T.RAMT) AS RAMT,SUM(T.RMTFEE) AS RMTFEE";
					strSql += " FROM (select  DISTINCT A.PBK AS PBK,A.PACCT AS PACCT,C.PCSHCM AS PCSHCM,C.PCSHDT AS PCSHDT,B.DEPT AS DEPT,A.SEQNO AS SEQNO,A.RAMT AS RAMT,A.RMTFEE AS RMTFEE ";
				}else{
					strSql = "select C.PBATNO AS PBATNO,A.PBK AS PBK,A.PACCT AS PACCT,C.PCSHCM AS PCSHCM,C.PCSHDT AS PCSHDT,";
					strSql += "B.DEPT AS DEPT,";
					/*strSql += "CASE WHEN SUBSTR(B.DFTGRP,1,3)='CSC' THEN 'CSC' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(B.DFTGRP,1,2)='NB' THEN 'NB' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(B.DFTGRP,1,3)='CLAM' THEN 'CLM' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(B.DFTGRP,1,2)='PA' THEN 'PA' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(B.DFTGRP,1,5)='Group' THEN 'GP' ";//RE0225-新增匯費對應碼規則
					strSql += "WHEN SUBSTR(B.DFTGRP,1,3)='FIN' THEN 'FIN' ";//RE0225-新增匯費對應碼規則
					strSql += "ELSE '' END AS DEPT,";//RE0225-新增匯費對應碼規則
*/					strSql += "A.RAMT AS RAMT,A.RMTFEE AS RMTFEE,CASE WHEN SUBSTR(A.RBK,1,3) = SUBSTR(A.PBK,1,3) THEN 'Y' ELSE 'N' END AS ISCHECK";	
			
				}
			}	
			strSql += " from CAPRMTF A";
			strSql += " LEFT OUTER JOIN USER B ON A.ENTRYUSR = B.USRID";
			// Q80628 strSql += " LEFT OUTER JOIN (SELECT DISTINCT PPAYCURR,PDATE,PCSHCM,PCSHDT,PBATNO,BATSEQ,PMETHOD,PCFMDT2 FROM CAPPAYF) C ";
			if (strPMethod.trim().equals("D")) {
				//strSql += " LEFT OUTER JOIN (SELECT DISTINCT PPAYCURR,PDATE,PCSHCM,PCSHDT,PBATNO,BATSEQ,PMETHOD,PCFMDT2,PDISPATCH FROM CAPPAYF) C ";
				//RD0382:OIU
				if("6".equals(company) || "0".equals(company)){
					strSql += " LEFT OUTER JOIN (SELECT DISTINCT PPAYCURR,PDATE,PCSHCM,PCSHDT,PBATNO,BATSEQ,PMETHOD,PCFMDT2,PDISPATCH,PAY_COMPANY FROM CAPPAYF) C ";
				} else{
					strSql += " LEFT OUTER JOIN (SELECT DISTINCT PPAYCURR,PDATE,PCSHCM,PCSHDT,PBATNO,BATSEQ,PMETHOD,PCFMDT2,PDISPATCH FROM CAPPAYF) C ";
				}				
			} else {
				strSql += " LEFT OUTER JOIN (SELECT DISTINCT PDATE,PCSHCM,PCSHDT,PBATNO,BATSEQ,PMETHOD,PCFMDT2,PDISPATCH,PAY_COMPANY FROM CAPPAYF) C ";
			}
			strSql += " on C.PBATNO=A.BATNO and C.BATSEQ=A.SEQNO ";
			strSql += " WHERE A.RAMT<>0";
			strSql += " AND C.PDATE <= C.PCFMDT2 ";
			strSql += " and C.PCSHCM between " + strPStartDate + "  and " + strPEndDate;
			strSql += " and C.PCFMDT2 between " + strPStartDate2 + "  and " + strPEndDate2;
			if (strPDispatch.trim().equals("Y")){
				strSql += " and C.PMETHOD IN ('" + strPMethod + "','E')";
			}else{
				strSql += " and C.PMETHOD = '" + strPMethod + "'";
			}
			if (strCurrency.trim().equals("NT")) {
				strSql += " and A.RPCURR IN(' ','NT')";
			} else {
				strSql += " and A.RPCURR = '" + strCurrency + "'";
			}
			//RC0036
			if (strPDispatch.trim().equals("Y")){
				strSql += " and C.PDISPATCH = 'Y' ";
			}else{
				strSql += " and C.PDISPATCH <> 'Y' ";
			}
			
			//RD0382:OIU
			if("6".equals(company)){
				strSql += " AND C.PAY_COMPANY='OIU' ";
			}else if("0".equals(company)){
				strSql += " AND C.PAY_COMPANY<>'OIU' ";
			}
			
			if (strPMethod.trim().equals("D")) {
				strSql += " GROUP BY PPAYCURR,PBK,PACCT,PCSHCM,PCSHDT,DEPT,RPAYRATE";
				strSql += " ORDER BY PPAYCURR,PBK,PACCT,PCSHCM,PCSHDT,DEPT";
				/*strSql += " GROUP BY PPAYCURR,PBK,PACCT,PCSHCM,PCSHDT,DFTGRP,RPAYRATE";//RE0225-新增匯費對應碼規則
				strSql += " ORDER BY PPAYCURR,PBK,PACCT,PCSHCM,PCSHDT,DFTGRP";//RE0225-新增匯費對應碼規則
*/			} else {
				if (!strPDispatch.trim().equals("Y")){//RC0036
					strSql += ") T ";//TEST
					strSql += " GROUP BY PBK,PACCT,PCSHCM,PCSHDT,DEPT";
					strSql += " ORDER BY PBK,PACCT,PCSHCM,PCSHDT,DEPT";
					/*strSql += " GROUP BY PBK,PACCT,PCSHCM,PCSHDT,DFTGRP";//RE0225-新增匯費對應碼規則				    
				    strSql += " ORDER BY PBK,PACCT,PCSHCM,PCSHDT,DFTGRP";//RE0225-新增匯費對應碼規則
*/				}
			}
				
			
			System.out.println("strSql=" + strSql);
			log.info("strSql=" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			// 1. 匯費借方
			// 2. 支付金額借方 ( 相同幣別帳號彙總成一筆 )
			// 3. 匯費 + 支付金額貸方 for 台幣匯款 ; 匯費貸方 , 支付金額貸方 for 外幣匯款
			while (rs.next()) {

				if (strPMethod.trim().equals("D")) {
					strPPAYCURR_Keep_1 = rs.getString("PPAYCURR");
					iRPAYRATE = rs.getDouble("RPAYRATE");//TEST
				} else {
					strPPAYCURR_Keep_1 = "";
				}
				strPBK_Keep_1 = rs.getString("PBK");
				strPACCT_Keep_1 = rs.getString("PACCT");
				iPCSHCM_Keep_1 = rs.getInt("PCSHCM");
				iPCSHDT_Keep_1 = rs.getInt("PCSHDT");

				if (!strPPAYCURR_Keep_2.trim().equals(strPPAYCURR_Keep_1.trim())
						|| !strPBK_Keep_2.trim().equals(strPBK_Keep_1.trim())
						|| !strPACCT_Keep_2.trim().equals(strPACCT_Keep_1.trim())
						|| iPCSHCM_Keep_2 != iPCSHCM_Keep_1) 
				{
					// 支付金額彙總成一筆
					if (iPayAmt_TOT_1 > 0) {

						List<DISBAccCodeDetailVO> alDwnDetails2 = new ArrayList<DISBAccCodeDetailVO>();

						if (strPMethod.trim().equals("B")) {
							alDwnDetails2 = (List<DISBAccCodeDetailVO>) getRAMTSumforB(strPBK_Keep_2, strPACCT_Keep_2, iPCSHCM_Keep_2, iPayAmt_TOT_1, iPayAmt_TOT_2, iRMTFEE_TOT_1, alDwnDetails2);
						} else if (strPMethod.trim().equals("D")) {
							alDwnDetails2 = (List<DISBAccCodeDetailVO>) getRAMTSumforD(strCurrency, strPPAYCURR_Keep_2, strPBK_Keep_2, strPACCT_Keep_2, iPCSHCM_Keep_2, iPCSHDT_Keep_2, iPayAmt_TOT_1, iPayAmt_TOT_2, iRMTFEE_TOT_1, alDwnDetails2, iPPayAmy_TOT, iRPAYRATE);
						}

						iPayAmt_TOT_1 = 0;
						iPayAmt_TOT_2 = 0;
						iRMTFEE_TOT_1 = 0;
						iPPayAmy_TOT = 0;//TEST 版本還原

						alReturn.addAll(alDwnDetails2);
					} // 支付金額彙總成一筆

					strPPAYCURR_Keep_2 = strPPAYCURR_Keep_1;
					strPBK_Keep_2 = strPBK_Keep_1;
					strPACCT_Keep_2 = strPACCT_Keep_1;
					iPCSHCM_Keep_2 = iPCSHCM_Keep_1;
					iPCSHDT_Keep_2 = iPCSHDT_Keep_1;
				} // Keep_1 <> Keep_2
				// ---------------------------------------------------------------------------------------------------
				iPayAmt_TOT_1 = iPayAmt_TOT_1 + rs.getDouble("RAMT");
				iPayAmt_TOT_2 = iPayAmt_TOT_2 + rs.getDouble("RAMT") + rs.getDouble("RMTFEE");
				iRMTFEE_TOT_1 = iRMTFEE_TOT_1 + rs.getDouble("RMTFEE");
				//iPPayAmy_TOT = iPPayAmy_TOT + rs.getDouble("RPAYAMT");
				
				//TEST 版本還原
				if (strPMethod.trim().equals("D")){
					iPPayAmy_TOT = iPPayAmy_TOT + rs.getDouble("RPAYAMT");
				}
				
				iAmtRMTFEE = rs.getDouble("RMTFEE");
				strDEPT = rs.getString("DEPT");
				
				//RC0036
				if (strPDispatch.trim().equals("Y")){
					if (rs.getString("PBATNO").startsWith("B")
						&& (strDEPT.trim().equals("CSC") 
							|| strDEPT.trim().equals("PA") 
							|| strDEPT.trim().equals("ACCT")
							|| strDEPT.trim().equals("PCD") 
							|| strDEPT.trim().equals("TYB") 
							|| strDEPT.trim().equals("TCB") 
							|| strDEPT.trim().equals("TNB") 
							|| strDEPT.trim().equals("KHB"))) {
						iAmtRMTFEE_CSC = iAmtRMTFEE_CSC + this.getBankFee(rs.getDouble("RAMT"),rs.getString("ISCHECK"));
					}
				
					if (rs.getString("PBATNO").startsWith("E")
						&& (strDEPT.trim().equals("PCD") 
							|| strDEPT.trim().equals("TYB") 
							|| strDEPT.trim().equals("TCB") 
							|| strDEPT.trim().equals("TNB") 
							|| strDEPT.trim().equals("KHB"))) {
						iAmtRMTFEE_CSC_BRCH = iAmtRMTFEE_CSC_BRCH + this.getBankFee(rs.getDouble("RAMT"),rs.getString("ISCHECK"));
					}
				
				
					if (rs.getString("PBATNO").startsWith("B") && strDEPT.trim().equals("NB")) {
						iAmtRMTFEE_NB = iAmtRMTFEE_NB + this.getBankFee(rs.getDouble("RAMT"),rs.getString("ISCHECK"));
					}
				
					if (rs.getString("PBATNO").startsWith("B") && (strDEPT.trim().equals("CLM") || strDEPT.trim().equals("GPH"))) {
						iAmtRMTFEE_CLM = iAmtRMTFEE_CLM + this.getBankFee(rs.getDouble("RAMT"),rs.getString("ISCHECK"));
					}	
				}
				
				if (iAmtRMTFEE > 0) { // 匯費 > 0 才產生分錄
					// 借方--匯費
					DISBAccCodeDetailVO objAccCodeDetailM3 = new DISBAccCodeDetailVO();

					objAccCodeDetailM3.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
					objAccCodeDetailM3.setStrActCd2("825500");
					objAccCodeDetailM3.setStrActCd1("90ZZZ");
					objAccCodeDetailM3.setStrActCd3("0000");
					strActCode4_1 = "63";
					//log.info("rs.getString(DEPT)是" + rs.getString("DEPT"));
					if (rs.getString("DEPT") != null) {
						strDEPT = rs.getString("DEPT");
						if (strDEPT.trim().equals("NB")) {
							strActCode4_1 = "61";
						}
						if (strDEPT.trim().equals("CSC")
							|| strDEPT.trim().equals("PCD") 
							|| strDEPT.trim().equals("TYB") 
							|| strDEPT.trim().equals("TCB") 
							|| strDEPT.trim().equals("TNB") 
							|| strDEPT.trim().equals("KHB")) {
							strActCode4_1 = "43";
						}
						if (strDEPT.trim().equals("PA")) {
							strActCode4_1 = "43";
						}
						//RD0571:新增FIN 
						if (strDEPT.trim().equals("ACCT")
							|| strDEPT.trim().equals("FIN")) {
							strActCode4_1 = "43";
						}
						if (strDEPT.trim().equals("CLM")) {
							strActCode4_1 = "62";
						}
						if (strDEPT.trim().equals("GPH")) {
							strActCode4_1 = "62";
						}
						if (strDEPT.trim().equals("GP")) {
							strActCode4_1 = "63";
							objAccCodeDetailM3.setStrActCd1("P0ZZZ");
						}
					}

					// 付款幣別 for 規則 : 外幣保單, 台幣付款--> TW, 其餘-->00 , 目前只會匯費會這樣
					if ("6".equals(company)) {
						strActCode4_2 = "00";
					}else{
						if (!strCurrency.trim().equals("NT")) {
							strActCode4_2 = "TW";
						} else {
							strActCode4_2 = "00";
						}
					}
					
					objAccCodeDetailM3.setStrActCd4(strActCode4_1 + strActCode4_2);
					log.info("setStrActCd4是" + strActCode4_1 + strActCode4_2 + ",company:" + company);

					if (!strCurrency.trim().equals("NT")) {
						objAccCodeDetailM3.setStrActCd5(disbBean.getETableDesc("CURRA", strCurrency.trim()));
					} else {
						objAccCodeDetailM3.setStrActCd5("000");
					}

					iPCSHCM = rs.getInt("PCSHCM");
					DateTemp = Integer.toString(19110000 + iPCSHCM);
					objAccCodeDetailM3.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
					objAccCodeDetailM3.setStrCAmt(df2.format(rs.getDouble("RMTFEE")));
					objAccCodeDetailM3.setStrDAmt("0");

					if (!strCurrency.trim().equals("NT")) {
						strSlipCode = "223";
					} else {
						strSlipCode = "221";
					}

					if (!strCurrency.trim().equals("NT")) {
						if("6".equals(company)){
							objAccCodeDetailM3.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "OIU" + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						}else{
							objAccCodeDetailM3.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						}																		
						//log.info("iAmtRMTFEE是" + iAmtRMTFEE + ",setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()));
					} else {
						objAccCodeDetailM3.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);						
						//log.info("iAmtRMTFEE是" + iAmtRMTFEE + ",setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					}

					if (strPMethod.trim().trim().equals("B")) {
						strDesc_1 = "台幣匯款匯費";
					} else if (strPMethod.trim().trim().equals("D")) {
						strDesc_1 = "外幣匯款匯費";
					}

					iPCSHDT = rs.getInt("PCSHDT");
					if (!strCurrency.trim().equals("NT")) {
						DateTemp1 = Integer.toString(1110000 + iPCSHDT - 1);
						//匯率表
						iConverRate2 = disbBean.getERRate(strCurrency.trim(), DateTemp1, "B");
						iConverRate = 1 / iConverRate2;
						log.info("DateTemp1(B)是" + DateTemp1 + ",iConverRate是" + iConverRate + ",iConverRate2是" + iConverRate2);
						
						if("6".equals(company)){
							objAccCodeDetailM3.setStrConverRate("1");
							objAccCodeDetailM3.setStrDesc(strDesc_1);
						}else{
							objAccCodeDetailM3.setStrConverRate(df3.format(iConverRate));
							objAccCodeDetailM3.setStrDesc(strDesc_1 + "(Rate 1:" + df3.format(iConverRate2) + ")");
						}						
					} else {
						objAccCodeDetailM3.setStrConverRate(df3.format(1));
						objAccCodeDetailM3.setStrDesc(strDesc_1);
						objAccCodeDetailM3.setConversionCredit("0");
						objAccCodeDetailM3.setConversionDebit(df2.format(rs.getDouble("RMTFEE")));
					}
					//RC0036 ，非急件
					if (!strPDispatch.trim().equals("Y")){
						alReturn.add(objAccCodeDetailM3);
					}
					// --------------------------------------------------------------------------------------------
				} // 匯費 > 0 才產生分錄

			} // rs.next
			
			if (strPDispatch.trim().equals("Y")){
				//CSC急件
				if (iAmtRMTFEE_CSC > 0 || iAmtRMTFEE_CSC_BRCH > 0){
					DISBAccCodeDetailVO objAccCodeDetailM4 = new DISBAccCodeDetailVO();
					objAccCodeDetailM4.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
					objAccCodeDetailM4.setStrActCd2("825500");
					objAccCodeDetailM4.setStrActCd1("90ZZZ");
					objAccCodeDetailM4.setStrActCd3("0000");
					objAccCodeDetailM4.setStrActCd4("4300");
					objAccCodeDetailM4.setStrActCd5("000");
					DateTemp = Integer.toString(19110000 + iPCSHDT);
					objAccCodeDetailM4.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
					objAccCodeDetailM4.setStrCAmt(df2.format(iAmtRMTFEE_CSC+iAmtRMTFEE_CSC_BRCH));
					objAccCodeDetailM4.setStrDAmt("0"); 
					objAccCodeDetailM4.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					objAccCodeDetailM4.setStrConverRate(df3.format(1));     
					objAccCodeDetailM4.setStrDesc("CSC急件匯費");   
					objAccCodeDetailM4.setConversionCredit("0");
					objAccCodeDetailM4.setConversionDebit(df2.format(iAmtRMTFEE_CSC+iAmtRMTFEE_CSC_BRCH));
					alReturn.add(objAccCodeDetailM4);
					DISBAccCodeDetailVO objAccCodeDetailM41 = new DISBAccCodeDetailVO();
					objAccCodeDetailM41.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
					objAccCodeDetailM41.setStrActCd2("271000");
					objAccCodeDetailM41.setStrActCd1("00ZZZ");
					objAccCodeDetailM41.setStrActCd3("0000");
					objAccCodeDetailM41.setStrActCd4("0000");
					objAccCodeDetailM41.setStrActCd5("000");
					objAccCodeDetailM41.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
					objAccCodeDetailM41.setStrCAmt("0");
					objAccCodeDetailM41.setStrDAmt(df2.format(iAmtRMTFEE_CSC)); 
					objAccCodeDetailM41.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					objAccCodeDetailM41.setStrConverRate(df3.format(1));     
					objAccCodeDetailM41.setStrDesc("急件匯款匯費");   
					objAccCodeDetailM41.setConversionCredit(df2.format(iAmtRMTFEE_CSC));
					objAccCodeDetailM41.setConversionDebit("0");
					alReturn.add(objAccCodeDetailM41);
					DISBAccCodeDetailVO objAccCodeDetailM42 = new DISBAccCodeDetailVO();
					objAccCodeDetailM42.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
					objAccCodeDetailM42.setStrActCd2("271003");
					objAccCodeDetailM42.setStrActCd1("00ZZZ");
					objAccCodeDetailM42.setStrActCd3("0000");
					objAccCodeDetailM42.setStrActCd4("0000");
					objAccCodeDetailM42.setStrActCd5("000");
					objAccCodeDetailM42.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
					objAccCodeDetailM42.setStrCAmt("0");
					objAccCodeDetailM42.setStrDAmt(df2.format(iAmtRMTFEE_CSC_BRCH)); 
					objAccCodeDetailM42.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					objAccCodeDetailM42.setStrConverRate(df3.format(1));     
					objAccCodeDetailM42.setStrDesc("急件分公司匯款匯費");   
					objAccCodeDetailM42.setConversionCredit(df2.format(iAmtRMTFEE_CSC_BRCH));
					objAccCodeDetailM42.setConversionDebit("0");
					alReturn.add(objAccCodeDetailM42);
				}
				//CLM急件
				if (iAmtRMTFEE_CLM > 0){
					DISBAccCodeDetailVO objAccCodeDetailM5 = new DISBAccCodeDetailVO();
					objAccCodeDetailM5.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
					objAccCodeDetailM5.setStrActCd2("825500");
					objAccCodeDetailM5.setStrActCd1("90ZZZ");
					objAccCodeDetailM5.setStrActCd3("0000");
					objAccCodeDetailM5.setStrActCd4("6200");
					objAccCodeDetailM5.setStrActCd5("000");
					objAccCodeDetailM5.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
					objAccCodeDetailM5.setStrCAmt(df2.format(iAmtRMTFEE_CLM));
					objAccCodeDetailM5.setStrDAmt("0"); 
					objAccCodeDetailM5.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					objAccCodeDetailM5.setStrConverRate(df3.format(1));     
					objAccCodeDetailM5.setStrDesc("CLM急件匯費");   
					objAccCodeDetailM5.setConversionCredit("0");
					objAccCodeDetailM5.setConversionDebit(df2.format(iAmtRMTFEE_CLM));
					alReturn.add(objAccCodeDetailM5);
					DISBAccCodeDetailVO objAccCodeDetailM51 = new DISBAccCodeDetailVO();
					objAccCodeDetailM51.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
					objAccCodeDetailM51.setStrActCd2("271000");
					objAccCodeDetailM51.setStrActCd1("00ZZZ");
					objAccCodeDetailM51.setStrActCd3("0000");
					objAccCodeDetailM51.setStrActCd4("0000");
					objAccCodeDetailM51.setStrActCd5("000");
					objAccCodeDetailM51.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
					objAccCodeDetailM51.setStrCAmt("0");
					objAccCodeDetailM51.setStrDAmt(df2.format(iAmtRMTFEE_CLM)); 
					objAccCodeDetailM51.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					objAccCodeDetailM51.setStrConverRate(df3.format(1));     
					objAccCodeDetailM51.setStrDesc("CLM急件匯款匯費");   
					objAccCodeDetailM51.setConversionCredit(df2.format(iAmtRMTFEE_CLM));
					objAccCodeDetailM51.setConversionDebit("0");
					alReturn.add(objAccCodeDetailM51);
				}
				
				//NB急件
				if (iAmtRMTFEE_NB > 0){
					DISBAccCodeDetailVO objAccCodeDetailM6 = new DISBAccCodeDetailVO();
					objAccCodeDetailM6.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
					objAccCodeDetailM6.setStrActCd2("825500");
					objAccCodeDetailM6.setStrActCd1("90ZZZ");
					objAccCodeDetailM6.setStrActCd3("0000");
					objAccCodeDetailM6.setStrActCd4("6100");
					objAccCodeDetailM6.setStrActCd5("000");
					objAccCodeDetailM6.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
					objAccCodeDetailM6.setStrCAmt(df2.format(iAmtRMTFEE_NB));
					objAccCodeDetailM6.setStrDAmt("0"); 
					objAccCodeDetailM6.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					objAccCodeDetailM6.setStrConverRate(df3.format(1));     
					objAccCodeDetailM6.setStrDesc("NB急件匯費");   
					objAccCodeDetailM6.setConversionCredit("0");
					objAccCodeDetailM6.setConversionDebit(df2.format(iAmtRMTFEE_NB));
					alReturn.add(objAccCodeDetailM6);
					DISBAccCodeDetailVO objAccCodeDetailM61 = new DISBAccCodeDetailVO();
					objAccCodeDetailM61.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
					objAccCodeDetailM61.setStrActCd2("271000");
					objAccCodeDetailM61.setStrActCd1("00ZZZ");
					objAccCodeDetailM61.setStrActCd3("0000");
					objAccCodeDetailM61.setStrActCd4("0000");
					objAccCodeDetailM61.setStrActCd5("000");
					objAccCodeDetailM61.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
					objAccCodeDetailM61.setStrCAmt("0");
					objAccCodeDetailM61.setStrDAmt(df2.format(iAmtRMTFEE_NB)); 
					objAccCodeDetailM61.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode);
					objAccCodeDetailM61.setStrConverRate(df3.format(1));     
					objAccCodeDetailM61.setStrDesc("NB急件匯款匯費");   
					objAccCodeDetailM61.setConversionCredit(df2.format(iAmtRMTFEE_NB));
					objAccCodeDetailM61.setConversionDebit("0");
					alReturn.add(objAccCodeDetailM61);
				}
				
			}//急件的if
			
			// 支付金額彙總成一筆，且為非急件
			log.info("iPayAmt_TOT_1是" + iPayAmt_TOT_1 + ",strPDispatch是" + strPDispatch.trim());
			if (iPayAmt_TOT_1 > 0 && !strPDispatch.trim().equals("Y")) {
				
				List<DISBAccCodeDetailVO> alDwnDetails2 = new ArrayList<DISBAccCodeDetailVO>();

				if (strPMethod.trim().trim().equals("B")) {
					alDwnDetails2 = (List<DISBAccCodeDetailVO>) getRAMTSumforB(strPBK_Keep_1, strPACCT_Keep_1, iPCSHCM_Keep_1, iPayAmt_TOT_1, iPayAmt_TOT_2, iRMTFEE_TOT_1, alDwnDetails2);
				} else if (strPMethod.trim().trim().equals("D")) {
					alDwnDetails2 = (List<DISBAccCodeDetailVO>) getRAMTSumforD(strCurrency, strPPAYCURR_Keep_1, strPBK_Keep_1, strPACCT_Keep_1, iPCSHCM_Keep_1, iPCSHDT_Keep_1, iPayAmt_TOT_1, iPayAmt_TOT_2, iRMTFEE_TOT_1, alDwnDetails2, iPPayAmy_TOT, iRPAYRATE);
				}

				alReturn.addAll(alDwnDetails2);
			} // 支付金額彙總成一筆

			rs.close();

		} catch (SQLException ex) {
			log.error(ex.getMessage(),ex);
			System.err.println("ex" + ex);
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alReturn = null;
		} catch (Exception ex) {
			log.error(ex.getMessage(),ex);
			System.err.println("DISBAccFinRmt Exception=" + ex.getMessage());
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

		System.out.println("alReturn=" + alReturn.size());
		return alReturn;
	}
	
	private double getBankFee(double amt,String isCheck) throws ServletException, IOException, Exception{
		Connection conDb = null;
		double bankFee = 0 ;
		if ("Y".equals(isCheck)) return bankFee ;
		try
			{
				conDb = dbFactory.getAS400Connection("getBankFee()");
				if( conDb != null )
				{
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery("select FLD006 FROM BANKFEE WHERE FLD001 = '' AND FLD002 = 'NT' AND FLD003 <= "+amt+" AND FLD004 >= "+amt);
					while(rstResultSet.next())
					{					
						bankFee = rstResultSet.getInt("FLD006");
					}	
					rstResultSet.close();
					stmtStatement.close();
				}				
		}
		catch( Exception ex )
		{
			System.out.println("Application Exception >>> " + ex);
			if( conDb != null )
				dbFactory.releaseAS400Connection(conDb);
		} finally {
				if (conDb != null) {
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		return bankFee;	
	}
	
	// 支付金額彙總成一筆 for 台幣匯款
	private List<DISBAccCodeDetailVO> getRAMTSumforCSC(String PBK, String PACCT, int PCSHCM, double PAYAMT1, double PAYAMT2, double RMTFEE, List<DISBAccCodeDetailVO> alDwnDetails2) {

		List<DISBAccCodeDetailVO> alReturn2 = new ArrayList<DISBAccCodeDetailVO>();
		DISBBean disbBean = new DISBBean(dbFactory);
		String DateTemp = ""; // 出納確認日

		// 借方--支付金額 , 台幣匯款
		DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();

		objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
		objAccCodeDetailM.setStrActCd2("825500");
		objAccCodeDetailM.setStrActCd1("00ZZZ");
		objAccCodeDetailM.setStrActCd3("0000");
		objAccCodeDetailM.setStrActCd4("0000");

		/* 台幣匯款件目前一定是台幣保單 */
		objAccCodeDetailM.setStrActCd5("000");

		DateTemp = Integer.toString(19110000 + PCSHCM);
		objAccCodeDetailM.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
		objAccCodeDetailM.setStrCAmt(df2.format(PAYAMT1));
		objAccCodeDetailM.setStrDAmt("0");

		/* 台幣匯款件目前一定是台幣保單 */
		objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "221" + "      ");
		//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "221" + "      ");
		objAccCodeDetailM.setStrDesc("台幣匯款");
		objAccCodeDetailM.setStrConverRate(df3.format(1));

		alReturn2.add(objAccCodeDetailM);
		
		return alReturn2;
	}

	// 支付金額彙總成一筆 for 台幣匯款
	private List<DISBAccCodeDetailVO> getRAMTSumforB(String PBK, String PACCT, int PCSHCM, double PAYAMT1, double PAYAMT2, double RMTFEE, List<DISBAccCodeDetailVO> alDwnDetails2) {

		List<DISBAccCodeDetailVO> alReturn2 = new ArrayList<DISBAccCodeDetailVO>();
		DISBBean disbBean = new DISBBean(dbFactory);

		String strBankCode = "";
		String strActCode3 = "";
		String DateTemp = ""; // 出納確認日

		// 借方--支付金額 , 台幣匯款
		DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();

		objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
		objAccCodeDetailM.setStrActCd2("271001");
		objAccCodeDetailM.setStrActCd1("00ZZZ");
		objAccCodeDetailM.setStrActCd3("0000");
		objAccCodeDetailM.setStrActCd4("0000");

		/* 台幣匯款件目前一定是台幣保單 */
		objAccCodeDetailM.setStrActCd5("000");

		DateTemp = Integer.toString(19110000 + PCSHCM);
		objAccCodeDetailM.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
		objAccCodeDetailM.setStrCAmt(df2.format(PAYAMT1));
		objAccCodeDetailM.setStrDAmt("0");

		/* 台幣匯款件目前一定是台幣保單 */
		objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "221" + "      ");
		//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "221" + "      ");
		
		objAccCodeDetailM.setStrDesc("台幣匯款");
		objAccCodeDetailM.setStrConverRate(df3.format(1));

		alReturn2.add(objAccCodeDetailM);
		// ----------------------------------------------------------------------------------------------
		// 貸方 --支付金額+匯費 , 台幣匯款
		DISBAccCodeDetailVO objAccCodeDetailM2 = new DISBAccCodeDetailVO();

		objAccCodeDetailM2.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
		/* 台幣匯款件目前一定是台幣保單 */
		objAccCodeDetailM2.setStrActCd2("101720");
		objAccCodeDetailM2.setStrActCd1("00ZZZ");

		strBankCode = PBK.substring(0, 3);
		// R80413 strActCode3 = disbBean.getACTCDFinRmt(strBankCode,PACCT);
		strActCode3 = disbBean.getACTCDFinRmt(strBankCode, PACCT, "NT"); // R80413
		objAccCodeDetailM2.setStrActCd3(strBankCode + strActCode3.substring(12, 13));
		//log.info("setStrActCd3是" + strBankCode + strActCode3.substring(12, 13));

		objAccCodeDetailM2.setStrActCd4("0000");
		/* 台幣匯款件目前一定是台幣保單 */
		objAccCodeDetailM2.setStrActCd5("000");

		DateTemp = Integer.toString(19110000 + PCSHCM);
		objAccCodeDetailM2.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
		objAccCodeDetailM2.setStrCAmt("0");
		objAccCodeDetailM2.setStrDAmt(df2.format(PAYAMT2));

		/* 台幣匯款件目前一定是台幣保單 */
		objAccCodeDetailM2.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "221" + "      ");
		//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "221" + "      ");
		
		objAccCodeDetailM2.setStrDesc("台幣匯款含匯費");
		objAccCodeDetailM2.setStrConverRate(df3.format(1));

		alReturn2.add(objAccCodeDetailM2);
		// ----------------------------------------------------------------------------------------------

		return alReturn2;
	}

	// 支付金額彙總成一筆 for 外幣匯款
	private List<DISBAccCodeDetailVO> getRAMTSumforD(String CURRENCY, String PPAYCURR, String PBK, String PACCT, int PCSHCM, int PCSHDT, double PAYAMT1, double PAYAMT2, double RMTFEE, List<DISBAccCodeDetailVO> alDwnDetails2, double PPAYAMT, double RPAYRATE) {

		List<DISBAccCodeDetailVO> alReturn2 = new ArrayList<DISBAccCodeDetailVO>();
		DISBBean disbBean = new DISBBean(dbFactory);
		String strCurrency = "";// 保單幣別
		String strBankCode = "";
		String strActCode2 = "";
		String strActCode3 = "";
		String strActCode4_1 = ""; // 部門 for 匯費
		String strActCode4_2 = ""; // 付款幣別 for 規則
		String strSlipCode = "";
		String strPayCurr = "";// 付款幣別
		String DateTemp = ""; // 出納確認日
		String DateTemp1 = ""; // 出納日 -1
		String strDesc_1 = "";

		double iConverRate = 0; // 1/匯率
		double iConverRate2 = 0; // 匯率

		// 借方 --支付金額 , 外幣匯款
		DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();

		strPayCurr = PPAYCURR;
		strCurrency = CURRENCY;
		
		objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", strPayCurr.trim()));//TEST 版本還原
		
		objAccCodeDetailM.setStrActCd2("271001");
		objAccCodeDetailM.setStrActCd1("00ZZZ");
		objAccCodeDetailM.setStrActCd3("0000");
		objAccCodeDetailM.setStrActCd4("0000");

		if (!strCurrency.trim().equals("NT")) {
			objAccCodeDetailM.setStrActCd5(disbBean.getETableDesc("CURRA", strCurrency.trim()));
		} else {
			objAccCodeDetailM.setStrActCd5("000");
		}

		DateTemp = Integer.toString(19110000 + PCSHCM);
		objAccCodeDetailM.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
		objAccCodeDetailM.setStrCAmt(df2.format(PAYAMT1));
		objAccCodeDetailM.setStrDAmt("0");

		/* 保單幣別 = NT : 221 , else 223 */
		if (!strCurrency.trim().equals("NT")) {
			strSlipCode = "223";
		} else {
			objAccCodeDetailM.setStrCAmt(df2.format(PPAYAMT));
			//strSlipCode = "221";
			strSlipCode = "222";
		}

		if (!strCurrency.trim().equals("NT")) {
			//RD0382:OIU
			if("6".equals(company)){
				objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "OIU" + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
			}else{
				objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
			}			
			//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
		} else {
			objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");
			//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");
			objAccCodeDetailM.setConversionCredit("0");
			objAccCodeDetailM.setConversionDebit(df2.format(PAYAMT1));
		}

		objAccCodeDetailM.setStrDesc("外幣匯款");

		if(strCurrency.trim().equals("NT")) {
			//TEST objAccCodeDetailM.setStrConverRate(df3.format(RPAYRATE));
			//TEST 版本還原
			objAccCodeDetailM.setStrConverRate(df3.format(PAYAMT1/PPAYAMT));
		} else {
			objAccCodeDetailM.setStrConverRate(df3.format(1));
		}

		alReturn2.add(objAccCodeDetailM);
		// --------------------------------------------------------------------------------------------------
		// 貸方 --匯費 , 外幣匯款
		if (RMTFEE > 0) { // 匯費 >0 才寫分錄
			DISBAccCodeDetailVO objAccCodeDetailM4 = new DISBAccCodeDetailVO();
			
			objAccCodeDetailM4.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));		
			//RD0382:OIU			
			if("6".equals(company)){
				objAccCodeDetailM4.setStrActCd2("101721");
			}else{
				
				objAccCodeDetailM4.setStrActCd2("101720");
			}	
			
			objAccCodeDetailM4.setStrActCd1("00ZZZ");

			strBankCode = PBK.substring(0, 3);
			//System.out.println("strBankCode是" + strBankCode);
			if (strBankCode.trim().equals("007")) {
				// objAccCodeDetailM4.setStrActCd3("0071");
				objAccCodeDetailM4.setStrActCd3("007A");
			} else if (strBankCode.trim().equals("822")) {
				objAccCodeDetailM4.setStrActCd3("8223");
				//log.info("setStrActCd3是8223");
			} else if (strBankCode.trim().equals("013")) { //RD0077:新增國泰世華外幣的判斷
				objAccCodeDetailM4.setStrActCd3("0137");
			} else if (strBankCode.trim().equals("004")) { //RD0440-新增外幣指定銀行-台灣銀行的判斷 
				objAccCodeDetailM4.setStrActCd3("004A");			
			}else {
				// R80413 strActCode3 =
				// disbBean.getACTCDFinRmt(strBankCode,PACCT);
				strActCode3 = disbBean.getACTCDFinRmt(strBankCode, PACCT, strPayCurr); // R80413
				log.info("strActCode3是" + strActCode3);
				objAccCodeDetailM4.setStrActCd3(strBankCode + strActCode3.substring(12, 13));
				//log.info("setStrActCd3是" + strBankCode + strActCode3.substring(12, 13));
			}

			strActCode4_1 = "00";
			// R80338 付款幣別 for 規則 : 外幣保單, 台幣付款--> TW, 其餘-->00 , 目前只會匯費會這樣
			if("6".equals(company)){
				strActCode4_2 = "00";
			}else{
				if (!strCurrency.trim().equals("NT")) {
					strActCode4_2 = "TW";
				} else {
					strActCode4_2 = "00";
				}
			}
			
			objAccCodeDetailM4.setStrActCd4(strActCode4_1 + strActCode4_2);
			log.info("setStrActCd4是" + strActCode4_1 + strActCode4_2);
			if (!strCurrency.trim().equals("NT")) {
				objAccCodeDetailM4.setStrActCd5(disbBean.getETableDesc("CURRA", strCurrency.trim()));
			} else {
				objAccCodeDetailM4.setStrActCd5("000");
			}

			DateTemp = Integer.toString(19110000 + PCSHCM);
			objAccCodeDetailM4.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
			objAccCodeDetailM4.setStrCAmt("0");
			objAccCodeDetailM4.setStrDAmt(df2.format(RMTFEE));

			if (!strCurrency.trim().equals("NT")) {
				strSlipCode = "223";
			} else {
				//strSlipCode = "221";
				strSlipCode = "222";
			}

			if (!strCurrency.trim().equals("NT")) {
				if("6".equals(company)){
					objAccCodeDetailM4.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "OIU" + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
				}else{
					objAccCodeDetailM4.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
				}				
				//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
			} else {
				objAccCodeDetailM4.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");
				//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");
				objAccCodeDetailM4.setConversionCredit(df2.format(RMTFEE));
				objAccCodeDetailM4.setConversionDebit("0");
			}

			strDesc_1 = "外幣匯款匯費";

			if (!strCurrency.trim().equals("NT")) {
				DateTemp1 = Integer.toString(1110000 + PCSHDT - 1);
				/*iConverRate2 = disbBean.getERRate(strPayCurr.trim(), DateTemp1, "S");*/
				iConverRate2 = disbBean.getERRate(strCurrency.trim(), DateTemp1, "B");//TEST版本還原
				iConverRate = 1 / iConverRate2;
				log.info("DateTemp1(B)是" + DateTemp1 + ",iConverRate是" + iConverRate + ",iConverRate2是" + iConverRate2);
				
				if("6".equals(company)){
					objAccCodeDetailM4.setStrConverRate("1");
					objAccCodeDetailM4.setStrDesc(strDesc_1);
				}else {
					objAccCodeDetailM4.setStrConverRate(df3.format(iConverRate));
					objAccCodeDetailM4.setStrDesc(strDesc_1 + "(Rate 1:" + df3.format(iConverRate2) + ")");
				}				
			} else {
				objAccCodeDetailM4.setStrConverRate(df3.format(1));
				objAccCodeDetailM4.setStrDesc(strDesc_1);
				objAccCodeDetailM4.setConversionCredit(df2.format(RMTFEE));
				objAccCodeDetailM4.setConversionDebit("0");
			}

			alReturn2.add(objAccCodeDetailM4);
		} // 匯費 >0 才寫分錄
			// -----------------------------------------------------------------------------------------
			// 貸方 --支付金額 , 外幣匯款

		DISBAccCodeDetailVO objAccCodeDetailM2 = new DISBAccCodeDetailVO();

		strPayCurr = PPAYCURR;
		
		objAccCodeDetailM2.setStrCurr(disbBean.getETableDesc("CURRA", strPayCurr.trim()));//TEST 版本還原
				
		if (strPayCurr.trim().equals("NT") || strPayCurr.trim().equals("")) {
			strActCode2 = disbBean.getACTCD2(disbBean.getETableDesc("CURRA", "NT"));
		} else {
			strActCode2 = disbBean.getACTCD2(disbBean.getETableDesc("CURRA", strPayCurr.trim()));
		}

		objAccCodeDetailM2.setStrActCd2(strActCode2.substring(0, 6));
		objAccCodeDetailM2.setStrActCd1("00ZZZ");

		strBankCode = PBK.substring(0, 3);
		// R80413 strActCode3 = disbBean.getACTCDFinRmt(strBankCode,PACCT);
		strActCode3 = disbBean.getACTCDFinRmt(strBankCode, PACCT, strPayCurr); // R80413
		
		//此為外幣付款的會計分錄,中信是8226
		objAccCodeDetailM2.setStrActCd3(strBankCode + strActCode3.substring(12, 13));
		//log.info("setStrActCd3是" + strBankCode + strActCode3.substring(12, 13));
		objAccCodeDetailM2.setStrActCd4("0000");

		if (!strCurrency.trim().equals("NT")) {
			objAccCodeDetailM2.setStrActCd5(disbBean.getETableDesc("CURRA", strCurrency.trim()));
		} else {
			objAccCodeDetailM2.setStrActCd5("000");
		}

		DateTemp = Integer.toString(19110000 + PCSHCM);
		objAccCodeDetailM2.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
		objAccCodeDetailM2.setStrCAmt("0");
		objAccCodeDetailM2.setStrDAmt(df2.format(PAYAMT1));

		/* 保單幣別 = NT : 221 , else 223 */
		if (!strCurrency.trim().equals("NT")) {
			strSlipCode = "223";
		} else {
			objAccCodeDetailM2.setStrDAmt(df2.format(PPAYAMT));
			//strSlipCode = "221";
			strSlipCode = "222";
		}

		if (!strCurrency.trim().equals("NT")) {
			if("6".equals(company)){
				objAccCodeDetailM2.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + "OIU" + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
			}else{
				objAccCodeDetailM2.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
			}			
			//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + disbBean.getETableDesc("CURRA", strCurrency.trim()) + "   ");
		} else {
			objAccCodeDetailM2.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");
			//log.info("setStrSlipNo是" + DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");
			objAccCodeDetailM2.setConversionDebit("0");
			objAccCodeDetailM2.setConversionCredit(df2.format(PAYAMT1));
		}

		objAccCodeDetailM2.setStrDesc("外幣匯款");
		if(strCurrency.trim().equals("NT")) {
			//TEST objAccCodeDetailM2.setStrConverRate(df3.format(RPAYRATE));
			//TEST 版本還原
			objAccCodeDetailM2.setStrConverRate(df3.format(PAYAMT1/PPAYAMT));
		} else {
			objAccCodeDetailM2.setStrConverRate(df3.format(1));
		}

		alReturn2.add(objAccCodeDetailM2);
		// -------------------------------------------------------------------------------------------------

		return alReturn2;
	}

}
