package com.aegon.crystalreport;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.Constant;
import com.aegon.comlib.GlobalEnviron;
import com.aegon.security.Security;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.ConnectionInfos;
import com.crystaldecisions.sdk.occa.report.data.FieldDisplayNameType;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.data.IConnectionInfo;
import com.crystaldecisions.sdk.occa.report.data.ParameterField;
import com.crystaldecisions.sdk.occa.report.data.ParameterFieldDiscreteValue;
import com.crystaldecisions.sdk.occa.report.data.Values;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;
import com.crystaldecisions.sdk.occa.report.lib.PropertyBag;

/**
 * System   : CASHWEB
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: CreateReport.java,v $
 * $Revision 1.2  2013/01/08 04:24:04  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.1.4.1  2012/12/06 06:28:27  MISSALLY
 * $RA0102　PA0041
 * $配合法令修改酬佣支付作業
 * $
 * $Revision 1.1  2006/06/29 09:40:12  MISangel
 * $Init Project
 * $
 * $Revision 1.4.4.4  2005/04/04 07:02:25  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class CreateReport extends HttpServlet implements Servlet {

	public static String CLIENT_REPORT_NAME = "ReportName";
	public static String CLIENT_REPORT_SERVER = "ReportServer";
	public static String CLIENT_PARA_PREFIX = "para_";
	public static String CLIENT_OUTPUT_FILE_NAME = "OutputFileName";
	public static String CLIENT_OUTPUT_TYPE = "OutputType";

	GlobalEnviron globalEnviron = null;

	class DataClass {

		public HttpServletRequest req = null;
		public HttpServletResponse resp = null;

		public String reportServer = null;	// RAS 所在的Server
		public String reportName = null;	// .rpt的名稱(含所在RAS路徑的?對位址)
		public Map parameters = new HashMap(2, 3); // 報表參數的 collection
		public String outputType = "";		// 報表輸出型態 (PDF, TXT, XLS)
		public String outputFileName = "";	// 預設的檔案名稱
		public String errorMessage = "";
		public String userId = null;		// 報表所需登入資料庫的 ID
		public String password = null;		// 報表所需登入資料庫的 Password
		public String odbcName = null;		// 報表檔所連結的 ODBC Driver 名稱

		// contrucuter
		DataClass(HttpServletRequest thisReq, HttpServletResponse thisResp) {
			req = thisReq;
			resp = thisResp;
		}
	}

	/**
	 * @see javax.servlet.http.HttpServlet#void
	 *      (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	/**
	 * @see javax.servlet.http.HttpServlet#void
	 *      (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		System.out.println("啟動 CreateReport");

		DataClass thisData = new DataClass(req, resp);
		// 設定預設值
		setDefaultValue(thisData);

		if (getInputParameter(thisData)) {
			if (!createReport(thisData)) {
				responseMessage(thisData);
			}
		} else {
			responseMessage(thisData);
		}
	}

	private boolean getInputParameter(DataClass thisData) {
		boolean returnStatus = true;

		String pmpKey = null;
		Enumeration parasbb = thisData.req.getParameterNames();
		while (parasbb.hasMoreElements()) {
			pmpKey = (String) parasbb.nextElement();
			thisData.req.setAttribute(pmpKey, thisData.req.getParameter(pmpKey));
		}

		Enumeration paras = thisData.req.getAttributeNames();

		String tmpKey = null;
		String tmpValue = null;
		try {
			while (paras.hasMoreElements()) {
				tmpKey = (String) paras.nextElement();
				// tmpValue = thisData.req.getParameter(tmpKey);

				if (tmpKey.equalsIgnoreCase(CreateReport.CLIENT_REPORT_NAME)) {
					thisData.reportName = (String) thisData.req.getAttribute(tmpKey);
					System.out.println("ReportName=" + (String) thisData.req.getAttribute(tmpKey));
				} else if (tmpKey.equalsIgnoreCase(CreateReport.CLIENT_REPORT_SERVER)) {
					thisData.reportServer = tmpValue;
				} else if (tmpKey.startsWith(CreateReport.CLIENT_PARA_PREFIX)) {
					tmpKey = tmpKey.substring(5);
					thisData.parameters.put(tmpKey, (String) thisData.req.getAttribute("para_" + tmpKey));
					System.out.println("Parm=" + (String) thisData.req.getAttribute("para_" + tmpKey));
				} else if (tmpKey.equalsIgnoreCase(CreateReport.CLIENT_OUTPUT_FILE_NAME)) {
					thisData.outputFileName = (String) thisData.req.getAttribute(tmpKey);
				} else if (tmpKey.equalsIgnoreCase(CreateReport.CLIENT_OUTPUT_TYPE)) {
					thisData.outputType = (String) thisData.req.getAttribute(tmpKey);
				}
				globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG, "CreateReport.getInputParameter", "key='" + tmpKey + "', value='" + tmpValue + "'");
			}
		} catch (Exception ex) {
			returnStatus = false;
			thisData.errorMessage = ex.getMessage();
		}
		return returnStatus;
	}

	/**
	 * 設定相關參數預設值
	 * 
	 * @param thisData
	 */
	private void setDefaultValue(DataClass thisData) {
		try {
			ServletContext application = getServletContext();

			if (globalEnviron == null) {
				globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
			}

			if (application.getAttribute("RAS_SERVER_NAME") != null) {
				thisData.reportServer = (String) application.getAttribute("RAS_SERVER_NAME");
			}
			if (application.getAttribute("RAS_USER_ID") != null) {
				thisData.userId = (String) application.getAttribute("RAS_USER_ID");
			}
			if (application.getAttribute("RAS_PASSWORD") != null) {
				thisData.password = Security.decrypt((String) application.getAttribute("RAS_PASSWORD"));
			}
			if (application.getAttribute("RAS_ODBC_NAME") != null) {
				thisData.odbcName = (String) application.getAttribute("RAS_ODBC_NAME");
			}

			// 預設的報表輸出型態為 PDF
			thisData.outputType = "PDF";
		} catch (NullPointerException ex) {
			System.err.println(ex.getMessage());
		}
	}

	/**
	 * 製作報表.
	 * 
	 * @param thisData
	 * @return
	 */
	private boolean createReport(DataClass thisData) {
		boolean returnStatus = true;
		try {
			// Create a new Report Application Session
			ReportAppSession ra = new ReportAppSession();
			// Create a Report Application Server Service
			ra.createService("com.crystaldecisions.sdk.occa.report.application.ReportClientDocument");
			// Set the RAS Server to be used for the service
			// ra.setReportAppServer("aegonn25.aegon.com.tw");
			ra.setReportAppServer(thisData.reportServer);

			// Initialize RAS
			ra.initialize();
			// Create the report client document object
			ReportClientDocument clientDoc = new ReportClientDocument();
			// Set the RAS Server to be used for the Client Document
			clientDoc.setReportAppServer(ra.getReportAppServer());
			// Open the report, and set the open type to Read Only
			globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG, "CreateReport.createReport()", thisData.reportName);
			clientDoc.open(thisData.reportName, OpenReportOptions._openAsReadOnly);
			PropertyBag propBag = null;
			ConnectionInfos infos = null;
			if (thisData.odbcName != null && !thisData.odbcName.equals("")) {
				propBag = new PropertyBag();
				infos = clientDoc.getDatabaseController().getConnectionInfos(propBag);
				for (int i = 0, j = infos.size(); i < j; i++) {
					IConnectionInfo conInfo = infos.getConnectionInfo(i);
					propBag = conInfo.getAttributes();
					propBag.putStringValue("QE_ServerDescription", thisData.odbcName);
					conInfo.setAttributes(propBag);
					conInfo.setUserName(thisData.userId);
					conInfo.setPassword(thisData.password);
				}
			}
			clientDoc.getDatabaseController().setConnectionInfos(infos);
			// clientDoc.getDatabaseController().logon(thisData.userId,
			// thisData.password) ;

			// Process for parameter

			String tmpKey = "";
			String tmpValue = "";
			for (Iterator ite = thisData.parameters.keySet().iterator(); ite.hasNext();) {
				tmpKey = (String) ite.next();
				tmpValue = (String) thisData.parameters.get(tmpKey);

				Fields fields = clientDoc.getDataDefinition().getParameterFields();
				int index = fields.find(tmpKey, FieldDisplayNameType.fieldName, Locale.ENGLISH);
				globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG, "CreateReport.createReport()", "The first index is '" + String.valueOf(index) + "'");
				globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG, "CreateReport.createReport()", "key = '" + tmpKey + "', value='" + tmpValue + "'");
				ParameterField oldField = (ParameterField) fields.getField(index);
				ParameterField newField = (ParameterField) oldField.clone(true);
				Values values = new Values();
				ParameterFieldDiscreteValue value = new ParameterFieldDiscreteValue();
				value.setValue(tmpValue);
				values.add(value);
				newField.setCurrentValues(values);
				clientDoc.getDataDefController().getParameterFieldController().modify(oldField, newField);
			}

			// Export Report
			// EXPORTING THE REPORT

			// Create a byte[] (same size as the exported ByteArrayInputStream)
			byte[] buf = new byte[2000 * 1024];
			int nRead = 0;
			ReportExportFormat exportFormat = null;

			// Set response headers to indicate pdf MIME type and inline file
			thisData.resp.reset();
			if (thisData.outputType.equalsIgnoreCase("PDF")) {
				thisData.resp.setContentType("application/pdf");
				exportFormat = ReportExportFormat.PDF;
			} else if (thisData.outputType.equalsIgnoreCase("TXT")) {
				thisData.resp.setContentType("text/plain");
				exportFormat = ReportExportFormat.text;
			} else if (thisData.outputType.equalsIgnoreCase("XLS")) {
				thisData.resp.setContentType("application/excel");
				exportFormat = ReportExportFormat.MSExcel;
			} else if (thisData.outputType.equalsIgnoreCase("recXLS")) {
				thisData.resp.setContentType("application/excel");
				exportFormat = ReportExportFormat.recordToMSExcel;
			}

			// thisData.resp.setHeader("Expire","0"); // for HTTP 1.0
			// thisData.resp.setHeader("Pragma","no-cache"); // for HTTP 1.0
			thisData.resp.setHeader("Cash-Control", "private,no-cache,no-store"); // for HTTP 1.1
			thisData.resp.setHeader("Content-Disposition", "inline;filename=" + thisData.outputFileName);

			// Send the Byte Array to the Client
			ByteArrayInputStream byteIS = (ByteArrayInputStream) clientDoc.getPrintOutputController().export(exportFormat);

			while ((nRead = byteIS.read(buf)) != -1) {
				thisData.resp.getOutputStream().write(buf, 0, nRead);
			}

			// Flush the output stream
			thisData.resp.getOutputStream().flush();
			// Close the output stream
			thisData.resp.getOutputStream().close();

		} catch (Exception ex) {
			globalEnviron.writeDebugLog(Constant.DEBUG_ERROR, "CreatReport.creatReport()", ex.getMessage());
			thisData.errorMessage = ex.getMessage();
			returnStatus = false;
		}
		return returnStatus;
	}

	private void responseMessage(DataClass thisData) {
		RequestDispatcher dispatch = thisData.req.getRequestDispatcher("/ReportCommon/ShowMessage.jsp?message=" + thisData.errorMessage);
		try {
			dispatch.forward(thisData.req, thisData.resp);
		} catch (IOException ex) {
			globalEnviron.writeDebugLog(Constant.DEBUG_ERROR, "CreateReport.responseMessage", ex.getMessage());
		} catch (ServletException ex) {
			globalEnviron.writeDebugLog(Constant.DEBUG_ERROR, "CreateReport.responseMessage", ex.getMessage());
		}
		return;
	}

}
