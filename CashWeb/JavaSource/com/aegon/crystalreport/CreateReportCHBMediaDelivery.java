package com.aegon.crystalreport;

/**
 * System   : CashWeb
 * 
 * Function : 彰化銀行媒體遞送單
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.3 $$
 * 
 * Author   : $$Author: MISSALLY $$
 * 
 * Create Date : 2013/04/08
 * 
 * Request ID  : RB0089
 * 
 * CVS History:
 * 
 * $$Log: CreateReportCHBMediaDelivery.java,v $
 * $Revision 1.3  2014/02/06 09:52:59  MISSALLY
 * $RB0806---修改彰銀媒體遞送單
 * $
 * $Revision 1.2  2013/12/24 02:16:19  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.1  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $$
 *  
 */

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.FieldDisplayNameType;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.data.ParameterField;
import com.crystaldecisions.sdk.occa.report.data.ParameterFieldDiscreteValue;
import com.crystaldecisions.sdk.occa.report.data.Values;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;


public class CreateReportCHBMediaDelivery extends HttpServlet implements Servlet {

	private static final long serialVersionUID = 2222063762311759746L;

	private DbFactory dbFactory = null;
       
 	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletContext application = getServletContext();
		dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
		RequestDispatcher dispatcher = null;
		
		//接收前端參數
		String reportPath = request.getParameter("ReportPath");
		String reportName = request.getParameter("ReportName");
		String strBatchNO = request.getParameter("para_batchno");

		//瀏覽資料
		Connection connection = null;
		ResultSet rs = null;

		//產生報表
		String errorMessage = "";
		try {
			connection = dbFactory.getAS400Connection("CreateReportCHBMediaDelivery");
			rs = dataProcess(connection, strBatchNO);

			String reportServer = "";
			String reportUserID = "";
			String reportUserPassword = "";
			if (application.getAttribute("RAS_SERVER_NAME") != null) {
				reportServer = (String) application.getAttribute("RAS_SERVER_NAME");
			}
			if (application.getAttribute("RAS_USER_ID") != null) {
				reportUserID = (String) application.getAttribute("RAS_USER_ID");
			}
			if (application.getAttribute("RAS_PASSWORD") != null) {
				reportUserPassword = (String) application.getAttribute("RAS_PASSWORD");
			}

			ReportAppSession ra = new ReportAppSession();
			ra.createService("com.crystaldecisions.sdk.occa.report.application.ReportClientDocument");
			ra.setReportAppServer(reportServer);
			ra.initialize();
			System.out.println("RAS initialize 成功.");

			Properties props = new Properties();
			props.put("user", reportUserID);
			props.put("password", reportUserPassword);
			props.put("naming", "system");

			ReportClientDocument clientDoc = new ReportClientDocument();
			clientDoc.setReportAppServer(ra.getReportAppServer());
			clientDoc.open(reportPath + reportName, OpenReportOptions._openAsReadOnly);
			clientDoc.getDatabaseController().setDataSource(rs, "Command", "Reports");

			// Process for parameter
			Enumeration<String> para = request.getParameterNames();
			String tmpKey = "";
			String tmpValue = "";
			while (para.hasMoreElements()) {
				tmpKey = (String) para.nextElement();
				tmpValue = request.getParameter(tmpKey);

				Fields fields = clientDoc.getDataDefinition().getParameterFields();
				int index = fields.find(tmpKey, FieldDisplayNameType.fieldName, Locale.ENGLISH);

				if (index > -1) {
					System.out.println("key = '" + tmpKey + "', value='" + tmpValue + "'");

					ParameterField oldField = (ParameterField) fields.getField(index);
					ParameterField newField = (ParameterField) oldField.clone(true);
					Values values = new Values();
					ParameterFieldDiscreteValue value = new ParameterFieldDiscreteValue();
					value.setValue(tmpValue);
					values.add(value);
					newField.setCurrentValues(values);
					clientDoc.getDataDefController().getParameterFieldController().modify(oldField, newField);
				}
			}

			// Export Report

			// Set response headers to indicate pdf MIME type and inline file
			response.reset();
			response.setHeader("Cash-Control", "private,no-cache,no-store");
			response.setHeader("Content-Disposition", "inline;filename=DISBRemitCHBForm.pdf");

			// Send the Byte Array to the Client
			ByteArrayInputStream byteIS = (ByteArrayInputStream) clientDoc.getPrintOutputController().export(ReportExportFormat.PDF);

			// Create a byte[] (same size as the exported ByteArrayInputStream)
			byte[] buf = new byte[2000 * 1024];
			int nRead = 0;
			while ((nRead = byteIS.read(buf)) != -1) {
				response.getOutputStream().write(buf, 0, nRead);
			}

			// Flush the output stream
			response.getOutputStream().flush();
			// Close the output stream
			response.getOutputStream().close();
		} catch (Exception ex) {
			errorMessage = ex.getMessage();
			System.err.println("Create Report CHB Err="+ex.getMessage());

			try { if (connection != null) dbFactory.releaseConnection(connection); } catch(Exception ee) {}

			dispatcher = request.getRequestDispatcher("/ReportCommon/close.html");
			dispatcher.forward(request, response);
		} finally {
			try { if (connection != null) dbFactory.releaseConnection(connection); } catch(Exception ee) {}
		}

		dispatcher = request.getRequestDispatcher("/ReportCommon/ShowMessage.jsp?message=" + errorMessage);
	}

	/**
	 * 核證總數＝ A ＋ B ＋ B' ＋ C
	 *
	 *	A ＝ 本次轉帳資料預定撥帳日期。
	 *	B ＝ 本次轉帳資料單筆最高轉帳金額帳戶之帳號（14位中第7位開始取 6 位數字)，但有多筆同金額時，以第一筆帳號為準。
	 *	B'＝ 本筆帳戶 (即 B)之轉帳金額（以元為單位）。
	 *	C ＝ 本次資料各筆帳號之累計數（取每一筆帳號 6 位數(14位中第7位開始取 6 位)予以累加）。
	 *
	 *	核證總數最多以 10 位數字為限，發生溢位時，取最右 10 位即可。
	 *
	 * @param batno : 匯款批號
	 * @return
	 */
	private ResultSet dataProcess(Connection conn, String batno) throws Exception {
		ResultSet returnRst = null;

		String strSql = "SELECT A.RACCT,A.RAMT,A.ENTRYDT,A.RMTDT,B.FLD0004 AS PAYCURR FROM CAPRMTF A ";
		strSql += "LEFT JOIN ORDUET B ON B.FLD0001='  ' and B.FLD0002='CURRA' and B.FLD0003=A.RPAYCURR ";
		strSql += "WHERE A.BATNO=? and SUBSTRING(PBK,1,3)=SUBSTRING(RBK,1,3) ORDER BY A.RAMT DESC ";

		PreparedStatement pstmt = null;
		ResultSet rst = null;
		Statement stmtTmp = null;
		try {
			pstmt = conn.prepareStatement(strSql);
			pstmt.setString(1, batno);
			rst = pstmt.executeQuery();

			String strEntryDate = "";
			String strRemitDate = "";
			String strAcct = "";
			String strCurr = "";
			int iAcct = 0;
			int iTotalAcct = 0;
			int currentAmt = 0;
			int preAmt = 0;
			int maxAmt = 0;
			int imaxAmtAcct = 0;
			int iTotalAmt = 0;
			int iCounter = 0;
			while(rst.next()) {
				iCounter++;
				currentAmt = rst.getInt("RAMT");
				strAcct = CommonUtil.AllTrim(rst.getString("RACCT"));
				if(strAcct.length() > 12) {
					iAcct = Integer.parseInt(strAcct.substring(6, 12));
				}

				if(currentAmt > preAmt) {
					maxAmt = currentAmt;
					imaxAmtAcct = iAcct;
				}

				iTotalAcct += iAcct;
				iTotalAmt += currentAmt;

				strEntryDate = CommonUtil.AllTrim(rst.getString("ENTRYDT"));
				strRemitDate = CommonUtil.AllTrim(rst.getString("RMTDT"));
				strCurr = CommonUtil.AllTrim(rst.getString("PAYCURR"));
				preAmt = currentAmt;
			}
			int totalNumCertified = Integer.parseInt(strRemitDate) + 19110000 + imaxAmtAcct + maxAmt + iTotalAcct;

			stmtTmp = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
			try{ stmtTmp.execute("DROP TABLE QTEMP/CHBData "); } catch(Exception ex) {}

			String strTempSql = "CREATE TABLE QTEMP/CHBData ( FLD0001 CHAR(7),FLD0002 CHAR(7),FLD0003 INT DEFAULT 0,FLD0004 INT DEFAULT 0,FLD0005 CHAR(3),FLD0006 INT DEFAULT 0 ) ";
			stmtTmp.execute(strTempSql);

			String strInsertSql = "INSERT INTO QTEMP/CHBData VALUES ('"+strEntryDate+"','"+strRemitDate+"',"+iCounter+","+totalNumCertified+",'"+strCurr+"',"+iTotalAmt+") ";
			stmtTmp.execute(strInsertSql);

			String strQuerySql = "SELECT FLD0001, FLD0002, FLD0003, FLD0004, FLD0005, FLD0006 FROM QTEMP/CHBData ";
			returnRst = stmtTmp.executeQuery(strQuerySql);

		} catch(Exception ex) {
			System.err.println(ex.getMessage());
			throw ex;
		} finally {
			try { if(rst != null) rst.close(); } catch(Exception e) {}
			try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
		}
		
		return returnRst;
	}
	
}
