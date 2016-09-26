package com.aegon.disb.disbmaintain;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
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
import com.aegon.disb.util.DISBBean;

/**
 * System   : CashWeb
 * 
 * Function : 保費收入現金帳分錄
 * 
 * Remark   : 管理系統─財務
 * 
 * Revision : $$Revision: 1.3 $$
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : $$Date: 2014/01/29 07:40:01 $$
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * $$Log: DISBAccPremCasServlet.java,v $
 * $Revision 1.3  2014/01/29 07:40:01  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---0->00
 * $
 * $Revision 1.2  2014/01/24 07:11:58  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.1  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $$
 *  
 */

public class DISBAccPremCasServlet extends InitDBServlet {

	private static final long serialVersionUID = 1821198011376168409L;

	private DISBBean disbBean = null;
	private List<DISBAccPremCasDTO> list = null;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

	private double debitAmount = 0;
	private double creditAmount = 0;

	public void init() throws ServletException {
		super.init();

		list = new ArrayList<DISBAccPremCasDTO>();
		disbBean = new DISBBean(globalEnviron, dbFactory);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);

		try {
			this.downloadProcess(request, response);
		} catch (Exception e) {
			System.err.println(e.toString());
			request.setAttribute("txtMsg", e.getMessage());
		}

	}

	private void downloadProcess(HttpServletRequest req, HttpServletResponse resp) throws Exception {

		String curren = req.getParameter("selCurrency");
		int entryDate = Integer.parseInt(req.getParameter("txtPStartDate"));

		Connection conn = dbFactory.getAS400Connection("DISBAccPremCasServlet.downloadProcess");

		/* 借方 */
		this.getPaymentTypeData(curren, entryDate, conn);
		this.getCreditCardData(curren, entryDate, conn);
		if ("NT".equals(curren)) {
			this.getTransferFeeData(curren, entryDate, conn);
		}
		this.getNoWriteoffData(curren, entryDate, conn);

		/* 貸方 */
		this.getCAP1043FABData(curren, entryDate, conn);

		/* 借貸差額 */
		this.getLendingUnequally(curren, entryDate);

		/* CHSS退換票處理 */
		if ("NT".equals(curren)) {
			this.getCHSSData(entryDate, conn);
		}

		if(conn != null)
			dbFactory.releaseAS400Connection(conn);

		if (list.size() > 0) {
			ServletOutputStream os = resp.getOutputStream();
			Collections.sort(list);

			try {
				resp.setContentType("text/plain");// text/plain
				resp.setHeader("Content-Disposition", "attachment; filename=PremiumIncomeCash.xls");

				HSSFWorkbook workbook = new HSSFWorkbook();
				HSSFSheet sheet = workbook.createSheet("Sheet1");
				int rownum = 0;

				DISBAccPremCasDTO dto = null;
				for (int i = 0; i < list.size(); i++) {
					dto = list.get(i);

					if(dto.getDebit()==0 && dto.getCredit() ==0)
						continue;

					int cellnum = 0;
					Row row = sheet.createRow(rownum++);
					Cell cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getCategory());	//Category
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getSource());		//Source
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getCurrency());	//Currency
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getCompany());	//Company
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getMainAccount());//Main Account
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getChannel());	//Channel
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getLob());		//LOB
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getPeriod());		//PERIOD
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getPlanCode());	//Plan Code
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getInvestment());	//INVESTMENT
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getInvestmentSql());	//INVESTMENT SEQ
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getDepartment());	//DEPARTMENT
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getPartner());	//PARTNER
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getFuture1());	//FUTURE1
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getFuture2());	//FUTURE2
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getFuture3());	//FUTURE3
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getFuture4());	//FUTURE4
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getFuture5());	//FUTURE5
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getAccountingDate());	//出納確認日,(西元)YYYY/MM/DD,x(10)
					cell = row.createCell(cellnum++);
					if(dto.getDebit() > 0) {
						cell.setCellValue(dto.getDebit());		//借方金額, x(13), 若為0, 則為空白
					} else {
						cell.setCellValue("");
					}
					cell = row.createCell(cellnum++);
					if(dto.getCredit() > 0) {
						cell.setCellValue(dto.getCredit());		//貸方金額, x(13), 若為0, 則為空白
					} else {
						cell.setCellValue("");
					}
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getJournalName());	//Journal Name, x(15), 出納確認日之西元年後二碼+MMDD + 3個特定碼 + 幣別
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getLineDescription());//Line Description, x(30)
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getConversionType());	//Conversion Type
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getConversionRate()); //Conversion Rate
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getConversionDate());	//出納確認日,(西元)YYYY/MM/DD,x(10)
					cell = row.createCell(cellnum++);
					cell.setCellValue(dto.getBatchName());		//Batch Name
					cell = row.createCell(cellnum++);
					cell.setCellValue(createIndex(i+1));
				}

				workbook.write(os);

			} catch (IOException e) {
				throw e;
			} finally {
				os.flush();
				os.close();
				creditAmount = 0;
				debitAmount = 0;
				list.clear();
			}
		} else {
			RequestDispatcher dispatcher = null;
			req.setAttribute("txtMsg", "查無可下載資料,請重新查明!");
			dispatcher = req.getRequestDispatcher("/DISB/DISBMaintain/DISBAccPremCas.jsp");
			dispatcher.forward(req, resp);
		}

	}

	// 來自人工及批次入帳登帳之核銷資料
	private void getPaymentTypeData(String curren, int entryDate, Connection con) throws Exception {
		String currency = disbBean.getETableDesc("CURRA", curren);
		String sql1 = this.getSqlForPaymentType1(curren, entryDate);
		String sql2 = this.getSqlForPaymentType2(entryDate);
		String sql3 = this.getSqlForPaymentType3(curren, entryDate);
		String sql4 = this.getSqlForPaymentType4(curren, entryDate);
		String sql5 = this.getSqlForPaymentType5(curren, entryDate);
		String sql6 = this.getSqlForPaymentType6(curren, entryDate);
		String sDate = this.changeDateForString(entryDate);
		String strACTCD2 = disbBean.getACTCD2(currency);
		Statement stmt = null;
		ResultSet rs = null;
		String bankAccount = "";
		String bankCode = "";
		String key = "";
		String payID = "";
		String payType = "";

		stmt = con.createStatement();
		rs = stmt.executeQuery(sql1);
		DISBAccPremCasDTO dto = null;
		while (rs.next()) {
			dto = new DISBAccPremCasDTO(currency, sDate);

			debitAmount = debitAmount + rs.getDouble("AMOUNT");
			dto.setDebit(rs.getDouble("AMOUNT"));
			payType = CommonUtil.AllTrim(rs.getString("CROSRC"));
			payID = disbBean.getETableDesc("PAYID", payType);
			payID = getPayidDesc(payID);
			dto.setLineDescription(this.getLineDescription(sDate, payID));

			if(!curren.equals("NT"))
				dto.setFuture5(currency);

			bankCode = rs.getString("CBKCD");

			if (payType.equals("0") && bankCode.equals("")) 
			{
				dto.setMainAccount("120001");
				dto.setLineDescription(this.getLineDescription(sDate, "臨時憑證"));
			} 
			else
			{
				dto.setMainAccount(strACTCD2.substring(0, 6));
				dto.setChannel(strACTCD2.substring(6, 7));
				dto.setLob(strACTCD2.substring(7, 8));
				dto.setPeriod(strACTCD2.substring(8, 9));
				dto.setPlanCode(strACTCD2.substring(9, 11));
				bankAccount = rs.getString("CATNO");
				bankCode = rs.getString("CBKCD");
				dto.setInvestment(bankCode);
				key = this.getInvestmentSql(bankCode, bankAccount, curren, con);
				dto.setInvestmentSql(key);
			}

			dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
			list.add(dto);
		}

		if(curren.equals("NT")) {
			stmt.clearBatch();
			rs = stmt.executeQuery(sql2);
			dto = null;
			while (rs.next()) {
				dto = new DISBAccPremCasDTO(currency, sDate);

				debitAmount = debitAmount + rs.getDouble("AMOUNT");
				dto.setDebit(rs.getDouble("AMOUNT"));
				payID = disbBean.getETableDesc("PAYID", "2");
				payID = getPayidDesc(payID);
				dto.setLineDescription(this.getLineDescription(sDate, payID));
				dto.setMainAccount("110000");
				dto.setPartner("N1");

				dto.setSort("02");
				list.add(dto);
			}
		}

		if(curren.equals("NT")) {
			stmt.clearBatch();
			rs = stmt.executeQuery(sql3);
			dto = null;
			while (rs.next()) {
				dto = new DISBAccPremCasDTO(currency, sDate);

				debitAmount = debitAmount + rs.getDouble("AMOUNT");
				dto.setDebit(rs.getDouble("AMOUNT"));
				payType = CommonUtil.AllTrim(rs.getString("CROSRC"));
				payID = disbBean.getETableDesc("PAYID", payType);
				payID = getPayidDesc(payID);
				dto.setLineDescription(this.getLineDescription(sDate, payID));

				dto.setMainAccount(strACTCD2.substring(0, 6));
				dto.setChannel(strACTCD2.substring(6, 7));
				dto.setLob(strACTCD2.substring(7, 8));
				dto.setPeriod(strACTCD2.substring(8, 9));
				dto.setPlanCode(strACTCD2.substring(9, 11));
				bankAccount = rs.getString("CATNO");
				bankCode = rs.getString("CBKCD");
				dto.setInvestment(bankCode);
				key = this.getInvestmentSql(bankCode, bankAccount, curren, con);
				dto.setInvestmentSql(key);

				dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
				list.add(dto);
			}

			stmt.clearBatch();
			rs = stmt.executeQuery(sql4);
			dto = null;
			while (rs.next()) {
				dto = new DISBAccPremCasDTO(currency, sDate);

				debitAmount = debitAmount + rs.getDouble("AMOUNT");
				dto.setDebit(rs.getDouble("AMOUNT"));
				payType = CommonUtil.AllTrim(rs.getString("CROSRC"));
				payID = disbBean.getETableDesc("PAYID", payType);
				payID = getPayidDesc(payID);
				dto.setLineDescription(this.getLineDescription(sDate, payID));

				dto.setMainAccount(strACTCD2.substring(0, 6));
				dto.setChannel(strACTCD2.substring(6, 7));
				dto.setLob(strACTCD2.substring(7, 8));
				dto.setPeriod(strACTCD2.substring(8, 9));
				dto.setPlanCode(strACTCD2.substring(9, 11));
				dto.setInvestment("007");
				dto.setInvestmentSql("A");

				dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
				list.add(dto);
			}
		} else {
			stmt.clearBatch();
			rs = stmt.executeQuery(sql5);
			dto = null;
			while (rs.next()) {
				dto = new DISBAccPremCasDTO(currency, sDate);

				debitAmount = debitAmount + rs.getDouble("AMOUNT");
				dto.setDebit(rs.getDouble("AMOUNT"));
				payType = CommonUtil.AllTrim(rs.getString("CROSRC"));
				payID = disbBean.getETableDesc("PAYID", payType);
				payID = getPayidDesc(payID);
				dto.setLineDescription(this.getLineDescription(sDate, payID));
				dto.setFuture5(currency);

				dto.setMainAccount(strACTCD2.substring(0, 6));
				dto.setChannel(strACTCD2.substring(6, 7));
				dto.setLob(strACTCD2.substring(7, 8));
				dto.setPeriod(strACTCD2.substring(8, 9));
				dto.setPlanCode(strACTCD2.substring(9, 11));
				bankAccount = rs.getString("CATNO");
				bankCode = rs.getString("CBKCD");
				dto.setInvestment(bankCode);
				key = this.getInvestmentSql(bankCode, bankAccount, curren, con);
				dto.setInvestmentSql(key);

				dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
				list.add(dto);
			}
		}

		stmt.clearBatch();
		rs = stmt.executeQuery(sql6);
		dto = null;
		while (rs.next()) {
			dto = new DISBAccPremCasDTO(currency, sDate);

			debitAmount = debitAmount + rs.getDouble("AMOUNT");
			dto.setDebit(rs.getDouble("AMOUNT"));
			payType = CommonUtil.AllTrim(rs.getString("CROSRC"));
			payID = disbBean.getETableDesc("PAYID", payType);
			payID = getPayidDesc(payID);
			dto.setLineDescription(this.getLineDescription(sDate, payID));
			dto.setMainAccount("111000");
			dto.setPartner("P5");

			dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
			list.add(dto);
		}
	}

	// 信用卡(台新/花旗)
	private void getCreditCardData(String curren, int entryDate, Connection con) throws Exception {
		String currency = disbBean.getETableDesc("CURRA", curren);
		String sql = this.getSqlForCreditCard(curren, entryDate);
		String sDate = this.changeDateForString(entryDate);
		Statement stmt = null;
		ResultSet rs = null;
		String bankAccount = "";
		String bankCode = "";
		String key = "";
		String payID = "";
		String payType = "";
		String cardType = "";
		double[] aryD = this.getCommissionFee(entryDate, con);

		stmt = con.createStatement();
		rs = stmt.executeQuery(sql);
		DISBAccPremCasDTO dto = null;

		boolean hasData = false;

		while (rs.next()) {
			dto = new DISBAccPremCasDTO(currency, sDate);

			payType = rs.getString("CROSRC");
			payID = disbBean.getETableDesc("PAYID", payType);
			payID = getPayidDesc(payID);
			dto.setLineDescription(this.getLineDescription(sDate, payID));

			cardType = CommonUtil.AllTrim(rs.getString("CSFBCRDCAT"));
			//台新
			if(cardType.equals("A")) 
			{
				dto.setMainAccount("111000");
				debitAmount = debitAmount + rs.getDouble("AMOUNT");
				dto.setDebit(rs.getDouble("AMOUNT"));
				dto.setPartner("P1");
			} 
			//花旗
			else 
			{
				dto.setMainAccount("101720");
				debitAmount = debitAmount + (rs.getDouble("AMOUNT") - aryD[1]);
				dto.setDebit(rs.getDouble("AMOUNT") - aryD[1]);
				dto.setLineDescription(this.getLineDescription(sDate, "花旗信用卡批次"));

				bankAccount = rs.getString("CATNO");
				bankCode = rs.getString("CBKCD");
				dto.setInvestment(bankCode);
				key = this.getInvestmentSql(bankCode, bankAccount, curren, con);
				dto.setInvestmentSql(key);

				hasData = true;
			}

			dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
			list.add(dto);

		}

		if(hasData) {
			dto = new DISBAccPremCasDTO(currency, sDate);
			dto.setMainAccount("111000");
			dto.setPartner("P3");
			debitAmount = debitAmount + aryD[1];
			dto.setDebit(aryD[1]);
			dto.setLineDescription(this.getLineDescription(sDate, "花旗信用卡批次手續費"));
			dto.setSort("1G");
			list.add(dto);
		}
	}

	// 批次轉帳手續費
	private void getTransferFeeData(String curren, int entryDate, Connection con) throws Exception {
		String currency = disbBean.getETableDesc("CURRA", curren);
		String sql1 = this.getSqlForBatchTransferFee1(curren, entryDate);
		String sql2 = this.getSqlForBatchTransferFee2(curren, entryDate);
		String sql3 = this.getSqlForBatchTransferFee3(curren, entryDate);
		String sDate = this.changeDateForString(entryDate);		
		String strACTCD2 = disbBean.getACTCD2(currency);
		Statement stmt = null;
		Statement stmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String bankAccount = "";
		String bankCode = "";
		String key = "";
		double transFee = 0;
		double totalFee = 0;

		stmt = con.createStatement();
		rs = stmt.executeQuery(sql1);
		DISBAccPremCasDTO dto = null;
		while (rs.next()) {
			dto = new DISBAccPremCasDTO(currency, sDate);

			dto.setMainAccount(strACTCD2.substring(0, 6));
			dto.setChannel(strACTCD2.substring(6, 7));
			dto.setLob(strACTCD2.substring(7, 8));
			dto.setPeriod(strACTCD2.substring(8, 9));
			dto.setPlanCode(strACTCD2.substring(9, 11));

			transFee = rs.getDouble("transfee");
			totalFee += transFee;
			creditAmount += transFee;
			dto.setCredit(transFee);
			dto.setLineDescription(this.getLineDescription(sDate, "銀行批次手續費"));

			bankAccount = rs.getString("CATNO");
			bankCode = rs.getString("CBKCD");
			dto.setInvestment(bankCode);
			key = this.getInvestmentSql(bankCode, bankAccount, curren, con);
			dto.setInvestmentSql(key);

			if(transFee > 0) {
				dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
				list.add(dto);
			}
		}

		stmt.clearBatch();
		stmt = con.createStatement();
		rs = stmt.executeQuery(sql2);
		dto = null;
		if (rs.next()) {
			stmt1 = con.createStatement();
			rs1 = stmt1.executeQuery(sql3);
			if (rs1.next()) {
				dto = new DISBAccPremCasDTO(currency, sDate);

				dto.setMainAccount(strACTCD2.substring(0, 6));
				dto.setChannel(strACTCD2.substring(6, 7));
				dto.setLob(strACTCD2.substring(7, 8));
				dto.setPeriod(strACTCD2.substring(8, 9));
				dto.setPlanCode(strACTCD2.substring(9, 11));
				dto.setInvestment("007");
				dto.setInvestmentSql("A");

				transFee = rs.getDouble("transfee");
				totalFee += transFee;
				creditAmount += transFee;
				dto.setCredit(transFee);
				dto.setLineDescription(this.getLineDescription(sDate, "銀行批次手續費"));

				if(transFee > 0) {
					dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
					list.add(dto);
				}
			}
		}

		dto = new DISBAccPremCasDTO(currency, sDate);
		dto.setMainAccount("590040");
		dto.setChannel("9");
		dto.setDepartment("43");
		debitAmount = debitAmount + totalFee;
		dto.setDebit(totalFee);
		dto.setLineDescription(this.getLineDescription(sDate, "銀行批次手續費"));
		if(totalFee > 0) {
			dto.setSort(CommonUtil.AllTrim(rs.getString("GRP_1"))+CommonUtil.AllTrim(rs.getString("CROSRC")));
			list.add(dto);
		}
	}

	// 已入帳未銷帳的資料
	private void getNoWriteoffData(String curren, int entryDate, Connection con) throws Exception {
		String currency = disbBean.getETableDesc("CURRA", curren);
		String sql = this.getSqlForNoWriteoff(curren, entryDate);
		String sDate = this.changeDateForString(entryDate);
		Statement stmt = null;
		ResultSet rs = null;
		String bankAccount = "";
		String bankCode = "";
		String key = "";
		String payID = "";

		stmt = con.createStatement();
		rs = stmt.executeQuery(sql);
		while (rs.next()) {
			DISBAccPremCasDTO dto = new DISBAccPremCasDTO(currency, sDate);
			dto.setMainAccount("285000");
			bankAccount = rs.getString("CATNO");
			bankCode = rs.getString("CBKCD");
			dto.setInvestment(bankCode);
			key = this.getInvestmentSql(bankCode, bankAccount, curren, con);
			dto.setInvestmentSql(key);

			if(!curren.equals("NT"))
				dto.setFuture5(currency);

			debitAmount = debitAmount + rs.getDouble("AMOUNT");
			dto.setDebit(rs.getDouble("AMOUNT"));
			payID = disbBean.getETableDesc("PAYID", rs.getString("CROSRC"));
			payID = getPayidDesc(payID) + "-未達帳";
			dto.setLineDescription(this.getLineDescription(sDate, payID));
			list.add(dto);
		}
	}

	// 來自人工及批次入帳登帳之核銷資料
	private String getSqlForPaymentType1(String currency, int entryDate) {
		String strSql = "SELECT CASE WHEN CROSRC IN ('0','1','2','3','4','5','6','7','8','9') THEN '0' ELSE '1' END as GRP_1,CROSRC,CBKCD,CATNO,sum(CROAMT) as AMOUNT "
				+ " FROM CAPCSHFB "
				+ " WHERE CRODAY > 0"
				+ " and CAEGDT =" + entryDate
				+ " and CSFBCURR = '" + currency + "'"
				+ " and CROSRC in ('0','1','5','6','7','A','B','C','E','I','J') "
				+ " GROUP BY CROSRC,CBKCD,CATNO "
				+ " ORDER BY GRP_1,CROSRC,CBKCD,CATNO ";
		System.out.println("PaymentType1=" + strSql);
		return strSql;
	}

	//2:支票, 4,H:銀行轉帳, 8,F:便利商店 不用登也不用銷直接出帳
	private String getSqlForPaymentType2(int entryDate) {
		String strSql = "select sum(PAYAMT) as AMOUNT "
				+ " from ORNBTA "
				+ " where CRTDATE-1110000 =" + entryDate
				+ " and PAYIND = '2' ";
		System.out.println("PaymentType2=" + strSql);
		return strSql;
	}

	private String getSqlForPaymentType3(String currency, int entryDate) {
		String strSql = "SELECT CASE WHEN CROSRC IN ('0','1','2','3','4','5','6','7','8','9') THEN '0' ELSE '1' END as GRP_1,CROSRC,CBKCD,CATNO,sum(a.CROAMT) as AMOUNT "
				+ " FROM CAPCSHFB a "
				+ " WHERE CAEGDT =" + entryDate
				+ " and CSFBCURR = '" + currency + "'"
				+ " and (CROSRC='4' or (CROSRC='H' and CBKCD NOT IN (SELECT FLD0003 FROM ORDUET WHERE FLD0001='  ' and FLD0002='ACH'))) "
				+ " GROUP BY CROSRC,CBKCD,CATNO "
				+ " ORDER BY GRP_1,CROSRC,CBKCD,CATNO ";
		System.out.println("PaymentType3=" + strSql);
		return strSql;
	}

	//H:銀行轉帳 若屬於ACH則固定出007-A
	private String getSqlForPaymentType4(String currency, int entryDate) {
		String strSql = "SELECT CASE WHEN a.CROSRC IN ('0','1','2','3','4','5','6','7','8','9') THEN '0' ELSE '1' END as GRP_1,a.CROSRC,sum(a.CROAMT) as AMOUNT "
				+ " FROM CAPCSHFB a "
				+ " JOIN ORDUET b ON b.FLD0001='  ' and b.FLD0002='ACH' and b.FLD0003=a.CBKCD "
				+ " WHERE a.CAEGDT =" + entryDate
				+ " and a.CSFBCURR = '" + currency + "'"
				+ " and a.CROSRC='H' "
				+ " GROUP BY CROSRC "
				+ " ORDER BY GRP_1 ";
		System.out.println("PaymentType4=" + strSql);
		return strSql;
	}

	private String getSqlForPaymentType5(String currency, int entryDate) {
		String strSql = "SELECT CASE WHEN CROSRC IN ('0','1','2','3','4','5','6','7','8','9') THEN '0' ELSE '1' END as GRP_1,CROSRC,CBKCD,CATNO,sum(a.CROAMT) as AMOUNT "
				+ " FROM CAPCSHFB a "
				+ " WHERE CAEGDT =" + entryDate
				+ " and CSFBCURR = '" + currency + "'"
				+ " and a.CROSRC IN ('4','H') "
				+ " GROUP BY CROSRC,CBKCD,CATNO "
				+ " ORDER BY GRP_1,CROSRC,CBKCD,CATNO ";
		System.out.println("PaymentType5=" + strSql);
		return strSql;
	}

	private String getSqlForPaymentType6(String currency, int entryDate) {
		String strSql = "SELECT CASE WHEN CROSRC IN ('0','1','2','3','4','5','6','7','8','9') THEN '0' ELSE '1' END as GRP_1,CROSRC,sum(CROAMT) as AMOUNT "
				+ " FROM CAPCSHFB "
				+ " WHERE CAEGDT =" + entryDate
				+ " and CSFBCURR = '" + currency + "'"
				+ " and CROSRC in ('8','F') "
				+ " GROUP BY CROSRC ";
		System.out.println("PaymentType6=" + strSql);
		return strSql;
	}

	// 3, G:信用卡(台新 / 花旗) 不用登也不用銷直接出帳
	private String getSqlForCreditCard(String currency, int entryDate) {
		String strSql = "select CASE WHEN CROSRC IN ('0','1','2','3','4','5','6','7','8','9') THEN '0' ELSE '1' END as GRP_1,CROSRC,CBKCD,CATNO,CASE CSFBCRDCAT WHEN 'A' THEN CSFBCRDCAT ELSE 'B' END as CSFBCRDCAT,sum(CROAMT) as AMOUNT "
				+ " from CAPCSHFB "
				+ " where CAEGDT =" + entryDate
				+ " and CSFBCURR = '" + currency + "'"
				+ " and CROSRC IN ('3','G') "
				+ " Group by CROSRC,CBKCD,CATNO,CASE CSFBCRDCAT WHEN 'A' THEN CSFBCRDCAT ELSE 'B' END "
				+ " ORDER BY CROSRC,CSFBCRDCAT,CBKCD,CATNO ";
		System.out.println("CreditCard=" + strSql);
		return strSql;
	}

	// 得到支付方式為批次轉帳的SQL
	private String getSqlForBatchTransferFee1(String currency, int entryDate) {
		String capsilDate = String.valueOf(entryDate + 1110000);
		String strSql = "SELECT a.CBKCD,a.CATNO,SUM(CAST(substring(et.FLD0004,3,5) AS FLOAT))/10 as transfee "
				+ " FROM CAPCSHFB a "
				+ " JOIN CAPBNKF b ON b.BKCODE=a.CBKCD and b.BKATNO=a.CATNO and b.BKCURR=a.CSFBCURR "
				+ " JOIN ORDUBHK6 c ON c.FLD0029='" + capsilDate + "' and c.FLD0002=b.BKCURR and c.FLD0003=b.BKPACB and c.FLD0026='" + capsilDate + "' "
				+ " JOIN ORDUET et on et.FLD0001='  ' and et.FLD0002='BANKP' and et.FLD0003=b.BKPACB "
				+ " WHERE a.CROSRC IN ('4','H') and a.CAEGDT=" + entryDate + " and a.CSFBCURR = '" + currency + "' "
				+ " and a.CBKCD NOT IN (SELECT FLD0003 FROM ORDUET WHERE FLD0001='  ' and FLD0002='ACH') "
				+ " GROUP BY a.CBKCD,a.CATNO "
				+ " ORDER BY a.CBKCD,a.CATNO ";
		System.out.println("BatchTransferFee1=" + strSql);
		return strSql;
	}
	private String getSqlForBatchTransferFee2(String currency, int entryDate) {
		String capsilDate = String.valueOf(entryDate + 1110000);
		String strSql = "SELECT et.FLD0004 "
				+ " FROM CAPCSHFB a "
				+ " JOIN ORDUBHK6 c ON c.FLD0029='" + capsilDate + "' and c.FLD0002=a.CSFBCURR and c.FLD0003=a.CBKCD and c.FLD0026='" + capsilDate + "' "
				+ " JOIN ORDUET d on d.FLD0001='  ' and d.FLD0002='ACH' and d.FLD0003=a.CBKCD "
				+ " JOIN ORDUET et on et.FLD0001='  ' and et.FLD0002='BANKP' and et.FLD0003=a.CBKCD "
				+ " WHERE a.CROSRC IN ('4','H') and a.CAEGDT=" + entryDate + " and a.CSFBCURR = '" + currency + "' ";
		System.out.println("BatchTransferFee2=" + strSql);
		return strSql;
	}
	private String getSqlForBatchTransferFee3(String currency, int entryDate) {
		String capsilDate = String.valueOf(entryDate + 1110000);
		String strSql = "SELECT SUM(CAST(substring(et.FLD0004,3,5) AS FLOAT))/10 as transfee "
				+ " FROM CAPCSHFB a "
				+ " JOIN ORDUBHK6 c ON c.FLD0029='" + capsilDate + "' and c.FLD0002=a.CSFBCURR and c.FLD0003=a.CBKCD and c.FLD0026='" + capsilDate + "' "
				+ " JOIN ORDUET d on d.FLD0001='  ' and d.FLD0002='ACH' and d.FLD0003=a.CBKCD "
				+ " JOIN ORDUET et on et.FLD0001='  ' and et.FLD0002='BANKP' and et.FLD0003=a.CBKCD "
				+ " WHERE a.CROSRC IN ('4','H') and a.CAEGDT=" + entryDate + " and a.CSFBCURR = '" + currency + "' ";
		System.out.println("BatchTransferFee3=" + strSql);
		return strSql;
	}


	// 已入帳未銷帳
	private String getSqlForNoWriteoff(String currency, int entryDate) {
		String strSql = "select CASE WHEN CROSRC IN ('0','1','2','3','4','5','6','7','8','9') THEN '0' ELSE '1' END as GRP_1,CROSRC,CBKCD,CATNO,sum(CROAMT) as AMOUNT "
				+ " from CAPCSHFB "
				+ " where CRODAY = 0 "
				+ " and CROSRC IN ('0','1','5','6','7','A','B','C','E','I','J') "
				+ " and CAEGDT =" + entryDate
				+ " and CSFBCURR = '" + currency + "'"
				+ " Group by CROSRC,CBKCD,CATNO "
				+ " ORDER BY GRP_1,CROSRC,CBKCD,CATNO ";
		System.out.println("NoWriteoff=" + strSql);
		return strSql;
	}

	// 取得會計科目最後一碼
	private String getInvestmentSql(String bankCode, String bankAccount, String currency, Connection con) throws Exception {
		String str = disbBean.getACTCDFinRmt(bankCode, bankAccount, currency);
		str = ( str.length() >=12 ) ? str.substring(12) : "";
		return str;
	}

	// 花旗信用卡入帳金額及佣金手續費
	private double[] getCommissionFee(int entryDate, Connection con) throws Exception {
		Statement stmt = null;
		ResultSet rs = null;
		double[] retD = new double[2];
		String strSql = "select R200MODTOT, R200COMTOT from REP0200 where R200PRCDT = " + entryDate;
		System.out.println("CommissionFee=" + strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		if (rs.next()) {
			retD[0] = rs.getDouble("R200MODTOT");
			retD[1] = rs.getDouble("R200COMTOT");
		}
		return retD;
	}

	// CAPSIL每日ORCALE帳務下載檔
	private void getCAP1043FABData(String curren, int entryDate, Connection con) throws Exception {
		String currency = disbBean.getETableDesc("CURRA", curren);
		String sql = this.getSqlForCAP1043FAB(currency, String.valueOf(entryDate));
		String sDate = this.changeDateForString(entryDate);
		Statement stmt = null;
		ResultSet rs = null;

		stmt = con.createStatement();
		rs = stmt.executeQuery(sql);
		DISBAccPremCasDTO dto = null;
		while (rs.next()) {
			dto = new DISBAccPremCasDTO(currency, sDate);
			dto.setMainAccount("290030");
			if ("".equals(CommonUtil.AllTrim(rs.getString("POLOB")))) {
				dto.setLineDescription(this.getLineDescription(sDate, "PREM-CAPSIL"));
			} else {
				dto.setLob("1");
				dto.setLineDescription(this.getLineDescription(sDate, "PREM-VPS"));
			}

			if(!curren.equals("NT"))
				dto.setFuture5(currency);

			creditAmount = creditAmount + rs.getDouble("CREAMT");
			dto.setCredit(rs.getDouble("CREAMT"));
			list.add(dto);
		}

	}

	// CAPSIL每日ORCALE帳務下載檔SQL
	private String getSqlForCAP1043FAB(String currency, String entryDate) {
		int sDate = Integer.parseInt(entryDate);
		String strSql = "select CREAMT,POLOB from CAP1043FAB "
				+ "where ACNTCURR = '" + currency + "' "
				+ " and CPSDATE-1110000 =" + sDate 
				+ " and SUBSTRING(DESPTXT1,14,6) ='102100' ";
		System.out.println("CAP1043FAB=" + strSql);
		return strSql;
	}

	// 處理借貸不平記錄
	private void getLendingUnequally(String curren, int entryDate) {
		if (creditAmount != debitAmount) {
			String currency = disbBean.getETableDesc("CURRA", curren);
			String sDate = this.changeDateForString(entryDate);
			DISBAccPremCasDTO dto = new DISBAccPremCasDTO(currency, sDate);
			dto.setMainAccount("285000");
			if (creditAmount > debitAmount) {
				double amount = creditAmount - debitAmount;
				dto.setDebit(amount);
			} else {
				double amount = debitAmount - creditAmount;
				dto.setCredit(amount);
			}
			dto.setLineDescription(this.getLineDescription(sDate, "借貸差額"));

			if(!curren.equals("NT"))
				dto.setFuture5(currency);

			list.add(dto);
		}
	}

	// CHSS票據處理分錄
	private void getCHSSData(int entryDate, Connection con) throws Exception {
		String sql = this.getSqlForCHSS(entryDate);
		String sql2 = this.getSqlForCHSSD(entryDate);
		String sDate = this.changeDateForString(entryDate);
		Statement stmt = null;
		ResultSet rs = null;
		ResultSet rs2 = null;

		stmt = con.createStatement();
		rs = stmt.executeQuery(sql);
		DISBAccPremCasDTO dto = null;
		DISBAccPremCasDTO dto2 = null;
		while (rs.next()) {
			dto2 = new DISBAccPremCasDTO("TWD", sDate);
			String type = CommonUtil.AllTrim(rs.getString("CHEQUEST"));
			String typeDes = CommonUtil.AllTrim(disbBean.getETableDesc("CSTAT", type));
			if ("U".equals(type)) {			//U:換票
				dto = new DISBAccPremCasDTO("TWD", sDate);
				dto.setMainAccount("110000");
				dto.setPartner("N1");
				dto.setDebit(rs.getDouble("CHEQUEAMT"));
				dto.setLineDescription(this.getLineDescription(sDate, typeDes));
				dto2.setMainAccount("110000");
				dto2.setPartner("N1");
				dto2.setCredit(rs.getDouble("CHEQUEAMT"));
				dto2.setLineDescription(this.getLineDescription(sDate, typeDes));
			} else if ("B".equals(type)) {	//B:退票
				dto2.setMainAccount("110000");
				dto2.setPartner("N1");
				dto2.setCredit(rs.getDouble("CHEQUEAMT"));
				dto2.setLineDescription(this.getLineDescription(sDate, typeDes));
			} else if ("X".equals(type)) {	//X:退票換現
				dto = new DISBAccPremCasDTO("TWD", sDate);
				dto.setMainAccount("101720");
				String bankAccount = rs.getString("ACCNTCODE");
				String bankCode = rs.getString("BANKCODE");
				dto.setInvestment(bankCode);
				String key = this.getInvestmentSql(bankCode, bankAccount, "NT", con);
				dto.setInvestmentSql(key);
				dto.setDebit(rs.getDouble("CHEQUEAMT"));
				dto.setLineDescription(this.getLineDescription(sDate, typeDes));
				dto2.setMainAccount("110000");
				dto2.setPartner("N1");
				dto2.setCredit(rs.getDouble("CHEQUEAMT"));
				dto2.setLineDescription(this.getLineDescription(sDate, typeDes));
			}
			if(dto != null) {
				list.add(dto);
			}
			list.add(dto2);
		}
		rs2 = stmt.executeQuery(sql2);
		while (rs2.next()) {
			String type = CommonUtil.AllTrim(rs2.getString("CHEQUEST"));
			String typeDes = CommonUtil.AllTrim(disbBean.getETableDesc("CSTAT", type));
			dto = new DISBAccPremCasDTO("TWD", sDate);
			dto2 = new DISBAccPremCasDTO("TWD", sDate);
			dto.setMainAccount("110000");
			dto.setPartner("N1");
			dto.setDebit(rs2.getDouble("CHEQUEAMT"));
			dto.setLineDescription(this.getLineDescription(sDate, typeDes));
			dto2.setMainAccount("110000");
			dto2.setPartner("N1");
			dto2.setCredit(rs2.getDouble("CHEQUEAMT"));
			dto2.setLineDescription(this.getLineDescription(sDate, typeDes));
			list.add(dto);
			list.add(dto2);
		}
	}

	// 換票, 退票換現, 退票
	private String getSqlForCHSS(int entryDate) {
		String strSql = "select CHEQUEAMT,CHEQUEST,BANKCODE,ACCNTCODE from ORNBTB "
				+ " where STDATE = CHGDATE and CHEQUEST in ('U','X','B') "
				+ "and STDATE-1110000= " + entryDate;
		System.out.println("CHSS=" + strSql);
		return strSql;
	}

	//原票重入
	private String getSqlForCHSSD(int entryDate) {
		String strSql = "select b.CHEQUEAMT,b.CHEQUEST from ORNBTB b,ORNBTE e "
				+ " where b.CHEQUECODE = e.CHEQUECODE and b.BANKCODE = e.BANKCODE"
				+ " and b.ACCNTCODE = e.ACCNTCODE and b.CHGDATE = e.CHGDATE"
				+ " and b.STDATE = b.CHGDATE and b.CHEQUEST = 'D' "
				+ " and b.STDATE-1110000= " + entryDate;
		System.out.println("CHSS-D=" + strSql);
		return strSql;
	}

	// 生成序列
	private String createIndex(int index) {
		String sequence = "";
		String zero = "000000";
		String num = String.valueOf(index);
		sequence = zero.substring(num.length()) + num;
		return sequence;
	}

	private String changeDateForString(int date) {
		int count = date + 19110000;
		return String.valueOf(count);
	}

	private String getLineDescription(String date, String des) {
		String content = "";
		content = date.substring(4, 6) + "/" + date.substring(6, 8) + " " + des;
		return content;
	}

	private String getPayidDesc(String str) {
		byte[] tmp = new byte[12];
		System.arraycopy( str.getBytes(), 8, tmp, 0, 12 );
		str = CommonUtil.AllTrim(new String(tmp));
		return str;
	}
}
