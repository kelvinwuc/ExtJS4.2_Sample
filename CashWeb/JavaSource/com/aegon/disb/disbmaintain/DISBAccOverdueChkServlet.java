package com.aegon.disb.disbmaintain;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

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
import com.aegon.comlib.WorkingDay;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBCSubjectTool;


/**
 * System   : CashWeb
 * 
 * Function : 逾期票據分錄
 * 
 * Remark   : 管理系統─財務
 * 
 * Revision : $$Revision: 1.1 $$
 * 
 * Author   : ODCZHEJUN
 * 
 * Create Date : $$Date: 2014/01/03 02:49:52 $$
 * 
 * Request ID : R00135 (PA0024)
 * 
 * CVS History:   
 * 
 * $$Log: DISBAccOverdueChkServlet.java,v $
 * $Revision 1.1  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $$
 *  
 */

public class DISBAccOverdueChkServlet extends InitDBServlet {

	private static final long serialVersionUID = -6982222850717790580L;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

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
		RequestDispatcher dispatcher = null;

		try {
			this.downloadProcess(request, response);
		} catch (Exception e) {
			System.err.println(e.toString());
			request.setAttribute("txtMsg", e.getMessage());
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccOverdueChk.jsp");
			dispatcher.forward(request, response);
		}
	}

	private void downloadProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {

		System.out.println("逾期票據 downloadProcess");
		List<DISBAccCodeDetailVO> alDwnDetails = new ArrayList<DISBAccCodeDetailVO>();

		alDwnDetails = (List<DISBAccCodeDetailVO>) getDetail(request, response, alDwnDetails);
		if (alDwnDetails.size() > 0) {
			ServletOutputStream os = response.getOutputStream();
			try {

				/* ConvertData */
				response.setContentType("application/vnd.ms-excel");           
				response.setHeader("Content-Disposition", "inline; filename=DISBAccOverdueChk.xls");

				HSSFWorkbook workbook = new HSSFWorkbook();
				HSSFSheet sheet = workbook.createSheet("Sheet1");
				int rownum = 0;

				String strActCd2 = null;
				String strActCd3 = null;
				String strActCd4 = null;
				String strActCd5 = null;
				String strDesc = null;
				String strSlipNo = null;
				String strDAmt = null;
				String strCAmt = null;
				String strPCfmDt = null;
				String count1 = null;

				for (int i = 0; i < alDwnDetails.size(); i++) {
					DISBAccCodeDetailVO objAccCodeDetail = (DISBAccCodeDetailVO) alDwnDetails.get(i);

					strActCd2 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd2());
					strActCd3 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd3());
					strActCd4 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd4());
					strActCd5 = CommonUtil.AllTrim(objAccCodeDetail.getStrActCd5());
					strPCfmDt = CommonUtil.AllTrim(objAccCodeDetail.getStrDate1());
					strDAmt = CommonUtil.AllTrim(objAccCodeDetail.getStrDAmt());
					strCAmt = CommonUtil.AllTrim(objAccCodeDetail.getStrCAmt());
					strDesc = objAccCodeDetail.getStrDesc() == null ? "" : CommonUtil.AllTrim(objAccCodeDetail.getStrDesc());
					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}
					strSlipNo = CommonUtil.AllTrim(objAccCodeDetail.getStrSlipNo());

					count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) {
						count1 = "0" + count1;
					}

					int cellnum = 0;
					Row row = sheet.createRow(rownum++);
					Cell cell = row.createCell(cellnum++);
					cell.setCellValue("Manual");		//Category
					cell = row.createCell(cellnum++);
					cell.setCellValue("Spreadsheet");	//Source
					cell = row.createCell(cellnum++);
					cell.setCellValue("TWD");			//Currency
					cell = row.createCell(cellnum++);
					cell.setCellValue("0");				//Company
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd2.substring(0, 6));		//Main Account,E欄
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd2.substring(6, 7));	//Channel
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd2.substring(7, 8));	//LOB
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd2.substring(8, 9));	//PERIOD
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd2.substring(9));	//Plan Code
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd3.substring(0, 3));	//INVESTMENT
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd3.substring(3, 4));	//INVESTMENT SEQ
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd4);					//DEPARTMENT,L欄
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd5.substring(0, 2));	//PARTNER
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd5.substring(2, 17));	//FUTURE1
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd5.substring(17, 20));	//FUTURE2
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd5.substring(20, 21));	//FUTURE3
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd5.substring(21, 23));	//FUTURE4
					cell = row.createCell(cellnum++);
					cell.setCellValue(strActCd5.substring(23, 26));	//FUTURE5
					cell = row.createCell(cellnum++);
					cell.setCellValue(strPCfmDt);	//出納確認日,(西元)YYYY/MM/DD,x(10)
					cell = row.createCell(cellnum++);
					if(strDAmt.equals("0")) {
						cell.setCellValue("");
					} else {
						cell.setCellValue(Double.parseDouble(strDAmt));		//借方金額, x(13), 若為0, 則為空白						
					}
					cell = row.createCell(cellnum++);
					if(strCAmt.equals("0")) {
						cell.setCellValue("");
					} else {
						cell.setCellValue(Double.parseDouble(strCAmt));		//貸方金額, x(13), 若為0, 則為空白
					}
					cell = row.createCell(cellnum++);
					cell.setCellValue(strSlipNo);	//Journal Name, x(15), 出納確認日之西元年後二碼+MMDD + 3個特定碼 + 幣別
					cell = row.createCell(cellnum++);
					cell.setCellValue(strDesc);		//Line Description, x(30)
					cell = row.createCell(cellnum++);
					cell.setCellValue("User");		//Conversion Type
					cell = row.createCell(cellnum++);
					cell.setCellValue(1); //Conversion Rate
					cell = row.createCell(cellnum++);
					cell.setCellValue(strPCfmDt);	//出納確認日,(西元)YYYY/MM/DD,x(10)
					cell = row.createCell(cellnum++);
					cell.setCellValue("BATCH");	//Batch Name
					cell = row.createCell(cellnum++);
					cell.setCellValue(count1);
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
			// 查無資料回傳訊息
			request.setAttribute("txtMsg", "查無可下載資料,請重新查明!");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccOverdueChk.jsp");
			dispatcher.forward(request, response);
		}
	}

	private List<DISBAccCodeDetailVO> getDetail(HttpServletRequest request, HttpServletResponse response, List<DISBAccCodeDetailVO> alDwnDetails) {

		Connection con = dbFactory.getAS400Connection("DISBAccOverdueChkServlet.getDetail()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		String strPaySql = "SELECT PPLANT,PSRCCODE,SRVBH,POLICYNO FROM CAPPAYF WHERE PNO=? ";
		String strPOSql = "SELECT FLD0184 FROM ORDUPO WHERE FLD0001='  ' and FLD0002=? ";
		String strGPPOSql = "SELECT 'GPA-'||GPCHANNEL as GPCHANNEL FROM CAPGASF/ORGPCM a JOIN ORDUAG b ON b.AGCOCO='  ' and b.AGCONU=a.CEAGNT1 WHERE CEPOLNO=? ";
		List<DISBAccCodeDetailVO> alReturn = new ArrayList<DISBAccCodeDetailVO>();

		String CBKNO = "";
		String CACCOUNT = "";
		String CAMT = "";
		String CSTATUS = "";
		int CHEQUEDT = 0;
		String GLACT = "";
		String PNO = "";
		String PSRCCODE = "";
		String PPLANT = "";
		String SRVBH = "";
		String MAINACCT = "";
		String CHANNEL = "";
		String LOB = "";
		String DEPT = "";
		String JOURNAL = "";
		String LINEDESC = "";

		/* 接參數 */
		String strYear = (request.getParameter("txtYear")!=null)?CommonUtil.AllTrim(request.getParameter("txtYear")):"";
		String strMonth = (request.getParameter("txtMonth")!=null)?CommonUtil.AllTrim(request.getParameter("txtMonth")):"";
		String strYearSelect = (request.getParameter("txtYearSelect")!=null)?CommonUtil.AllTrim(request.getParameter("txtYearSelect")):"";

		String strCaluYear = String.valueOf(Integer.parseInt(strYear) - Integer.parseInt(strYearSelect));

		if(strCaluYear.length() == 2)
			strCaluYear = "0" + strCaluYear;
		if(strMonth.length() == 1)
			strCaluYear = "0" + strMonth;

		String strCHKStartDate = strCaluYear + strMonth + "01";
		String strDay = "";
		String strCHKEndDate = "";

		String strMonthEndDay = "";

		PreparedStatement pstmtP = null;
		ResultSet rstP = null;
		PreparedStatement pstmtPO = null;
		ResultSet rstPO = null;
		PreparedStatement pstmtGPO = null;
		ResultSet rstGPO = null;

		try {
			Calendar cal = Calendar.getInstance();
			cal.setTime(commonUtil.convertROC2WestenDate1(strCHKStartDate));
			cal.set(Calendar.DAY_OF_MONTH, 1);
			cal.roll(Calendar.DAY_OF_MONTH, -1);
			strDay = String.valueOf(cal.get(Calendar.DATE));
			if (strDay.length() == 1)
				strDay = "0" + strDay;
			strCHKEndDate = strYear + strMonth + strDay;

			WorkingDay objWorkDate = new WorkingDay(dbFactory);
			if(objWorkDate.isWorkingDay(Integer.parseInt(strCHKEndDate)+19110000))
				strMonthEndDay = String.valueOf(Integer.parseInt(strCHKEndDate)+19110000);
			else
				strMonthEndDay = String.valueOf(objWorkDate.nextDay(Integer.parseInt(strCHKEndDate)+19110000, -1));

			alReturn = alDwnDetails;

			strSql = null;

			strSql = "select A.CBKNO,A.CACCOUNT,A.CNO,A.CAMT,A.CHEQUEDT,A.CSTATUS,A.PNO ";
			strSql += "from CAPCHKF A ";
			strSql += "WHERE A.CSTATUS = '" + strYearSelect + "' ";
			strSql += "and A.CHEQUEDT BETWEEN " + strCHKStartDate + " and " + strCHKEndDate + " ";
			strSql += "union all ";
			strSql += "select A.CBKNO,A.CACCOUNT,A.CNO,A.CAMT,A.CHEQUEDT,A.CSTATUS,A.PNO ";
			strSql += "from CAPCHKFHI A ";
			strSql += "WHERE A.CSTATUS = '" + strYearSelect + "' ";
			strSql += "and A.CHEQUEDT BETWEEN " + strCHKStartDate + " and " + strCHKEndDate + " ";
			strSql += "ORDER BY CBKNO,CACCOUNT,CNO ";
			System.out.println("strSql=" + strSql);

			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			DISBAccCodeDetailVO objAccCodeDetailD = null;
			DISBAccCodeDetailVO objAccCodeDetailC = null;
			DISBBean disbBean = new DISBBean(dbFactory);

			pstmtP = con.prepareStatement(strPaySql);
			pstmtPO = con.prepareStatement(strPOSql);
			pstmtGPO = con.prepareStatement(strGPPOSql);

			while (rs.next()) 
			{
				objAccCodeDetailD = new DISBAccCodeDetailVO();
				objAccCodeDetailC = new DISBAccCodeDetailVO();

				CBKNO = rs.getString("CBKNO");
				CACCOUNT = rs.getString("CACCOUNT");
				CSTATUS = rs.getString("CSTATUS");
				CHEQUEDT = rs.getInt("CHEQUEDT");
				CAMT = rs.getString("CAMT");
				PNO = rs.getString("PNO");

				GLACT = disbBean.getACTCDFinRmt(CBKNO.substring(0, 3), CACCOUNT, "NT");
				if(GLACT.equals("")) {
					objAccCodeDetailD.setStrActCd3("0000");
					objAccCodeDetailC.setStrActCd3("0000");
				} else {
					objAccCodeDetailD.setStrActCd3(CBKNO.substring(0, 3) + GLACT.substring(12, 13));
					objAccCodeDetailC.setStrActCd3(CBKNO.substring(0, 3) + GLACT.substring(12, 13));
				}
				objAccCodeDetailD.setStrActCd4("00");
				objAccCodeDetailD.setStrActCd5("00000000000000000000000000");

				objAccCodeDetailC.setStrActCd4("00");
				objAccCodeDetailC.setStrActCd5("00000000000000000000000000");

				if(CSTATUS.equals("1"))
				{
					objAccCodeDetailD.setStrActCd2("101T1000ZZZ");
					objAccCodeDetailC.setStrActCd2("29900000ZZZ");
					JOURNAL = "228";
					LINEDESC = "逾一年票";
					objAccCodeDetailC.setStrActCd3("0000");	//299000無須帶出銀行
				}

				if(CSTATUS.equals("2"))
				{
					//20160713-秀萍:工會要求逾兩年期支票不可轉收入,故會計科目要改,此為貸方
					System.out.println("strYear+strMonth是" + strYear+strMonth);
					if(Integer.parseInt(strYear+strMonth) < 10506){
						objAccCodeDetailD.setStrActCd2("29900000ZZZ");
					}else{
						objAccCodeDetailD.setStrActCd2("101T1000ZZZ");
					}					
					
					objAccCodeDetailD.setStrActCd3("0000");	//逾兩年無須帶出銀行
					objAccCodeDetailC.setStrActCd3("0000");	//逾兩年無須帶出銀行

					pstmtP.clearParameters();
					pstmtP.setString(1, PNO);
					rstP = pstmtP.executeQuery();
					if(rstP.next()) {
						PSRCCODE = rstP.getString("PSRCCODE");
						PPLANT = rstP.getString("PPLANT");
						SRVBH = rstP.getString("SRVBH");

						if(CommonUtil.AllTrim(SRVBH).equals("")) {
							pstmtPO.clearParameters();
							pstmtPO.setString(1, rstP.getString("POLICYNO"));
							rstPO = pstmtPO.executeQuery();
							if(rstPO.next()) {
								SRVBH = rstPO.getString("FLD0184");
							}
						}
						if(CommonUtil.AllTrim(SRVBH).equals("")) {
							pstmtGPO.clearParameters();
							pstmtGPO.setString(1, rstP.getString("POLICYNO"));
							rstGPO = pstmtGPO.executeQuery();
							if(rstGPO.next()) {
								SRVBH = rstGPO.getString("GPCHANNEL");
							}
						}
					}

					if(CHEQUEDT < 980301) {
						MAINACCT = "794401";
						CHANNEL = "9";
					} else {
						cal.setTime(commonUtil.convertROC2WestenDate1(String.valueOf(CHEQUEDT)));
						try {
							//20160713-秀萍:工會要求逾兩年期支票不可轉收入,故會計科目要改,此為貸方
							if(Integer.parseInt(strYear+strMonth) < 10506){
								MAINACCT = DISBCSubjectTool.dealWithOverTwoYear(cal, PSRCCODE, DISBCSubjectTool.getProperties());
							}else{
								MAINACCT = "299000";
							}
							
						} catch(Exception e) {
							MAINACCT = "      ";
						}
						try {
							CHANNEL = disbBean.getETableDesc("ORAL4", SRVBH).substring(0, 1);
						} catch(Exception e) {
							CHANNEL = " ";
						}
					}

					LOB = (PPLANT.equals("V"))?"1":"0";
					try {
						DEPT = disbBean.getETableDesc("ORAL4", SRVBH).substring(2, 4);
					} catch(Exception e) {
						DEPT = "  ";
					}

					if(PSRCCODE.equals("HS"))
					{
						CHANNEL = " ";
						LOB = " "; 
						DEPT = "  ";
					}

					objAccCodeDetailC.setStrActCd2(MAINACCT+CHANNEL+LOB+"ZZZ");//逾兩年期的會計科目
					objAccCodeDetailC.setStrActCd4(DEPT);

					JOURNAL = "229";
					LINEDESC = "逾二年票";
				}

				objAccCodeDetailD.setStrDate1(strMonthEndDay.substring(0, 4) + "/" + strMonthEndDay.substring(4, 6) + "/" + strMonthEndDay.substring(6));
				objAccCodeDetailD.setStrDAmt(CAMT);
				objAccCodeDetailD.setStrCAmt("0");
				objAccCodeDetailD.setStrSlipNo(strMonthEndDay.substring(2)+JOURNAL);
				objAccCodeDetailD.setStrDesc(LINEDESC);

				objAccCodeDetailC.setStrDate1(strMonthEndDay.substring(0, 4) + "/" + strMonthEndDay.substring(4, 6) + "/" + strMonthEndDay.substring(6));
				objAccCodeDetailC.setStrDAmt("0");
				objAccCodeDetailC.setStrCAmt(CAMT);
				objAccCodeDetailC.setStrSlipNo(strMonthEndDay.substring(2)+JOURNAL);
				objAccCodeDetailC.setStrDesc(LINEDESC);
			
				alReturn.add(objAccCodeDetailD);
				alReturn.add(objAccCodeDetailC);
			}

		} catch (Exception ex) {
			System.err.println("ex" + ex.getMessage());
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alReturn = null;
		} finally {
			try {
				if (rstP != null) {
					rstP.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (pstmtP != null) {
					pstmtP.close();
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

		System.out.println("逾期票據分錄筆數=" + ((alReturn == null)?"0":alReturn.size()));
		return alReturn;
	}

}
