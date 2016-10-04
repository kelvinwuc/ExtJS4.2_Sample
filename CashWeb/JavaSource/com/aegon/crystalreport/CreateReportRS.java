package com.aegon.crystalreport;

/**
 * System   :
 * 
 * Function : ���ͳ����@�ε{��
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
 * $$Log: CreateReportRS.java,v $
 * $Revision 1.8  2013/01/08 04:24:04  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.7.4.1  2012/12/06 06:28:27  MISSALLY
 * $RA0102�@PA0041
 * $�t�X�k�O�ק�S����I�@�~
 * $
 * $Revision 1.7  2011/08/31 07:28:19  MISSALLY
 * $R10231
 * $CASH�t�ηs�W�U���z�ߵ��I���Ӫ�
 * $
 * $Revision 1.6  2011/08/09 01:34:11  MISSALLY
 * $Q10256�@ ����CASH�t�ο��~�L�k�]�X����
 * $
 * $Revision 1.5  2011/04/14 01:39:46  MISJIMMY
 * $M10004--�s�Wlog
 * $
 * $Revision 1.4  2007/04/13 09:45:14  MISVANESSA
 * $R70292_�t���䲼��W�h����
 * $
 * $Revision 1.3  2007/01/19 08:26:48  miselsa
 * $Q60236�ק�RPT�ɪ������榡
 * $
 * $Revision 1.2  2006/08/28 07:40:37  miselsa
 * $Q60236�W�[���O�Τp���I
 * $
 * $Revision 1.1  2006/06/29 09:40:12  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:25  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.GlobalEnviron;
import com.aegon.disb.util.DISBBean;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ReportAppSession;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.data.FieldDisplayNameType;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.data.ParameterField;
import com.crystaldecisions.sdk.occa.report.data.ParameterFieldDiscreteValue;
import com.crystaldecisions.sdk.occa.report.data.Values;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;

public class CreateReportRS extends HttpServlet implements Servlet {

	private static final long serialVersionUID = 8160508113339601470L;

	public static String CLIENT_REPORT_NAME = "ReportName";		// �����W��
	public static String CLIENT_PARA_PREFIX = "para_";			// �ǤJ�������Ѽ�
	public static String CLIENT_OUTPUT_FILE_NAME = "OutputFileName"; // �ץX�ɮצW��
	public static String CLIENT_OUTPUT_TYPE = "OutputType";		// �����榡 PDF, TXT, XLS
	public static String CLIENT_REPORT_SQL = "ReportSQL";		// ���� DataSource SQL
	public static String CLIENT_REPORT_PATH = "ReportPath";		// .rpt���s����|
	public static String CLIENT_SWITCH_AREA = "switch_";		// ��ݳB�z�Ѽ�//R70292

	private Logger logger = Logger.getLogger(getClass());

	GlobalEnviron globalEnviron = null;
	DbFactory dbFactory = null;

	class DataClass {

		public HttpServletRequest req = null;
		public HttpServletResponse resp = null;

		public String dbServer = null;		// DataBase �Ҧb��Server
		public String reportServer = null;	// RAS �Ҧb��Server
		public String reportName = null;	// .rpt���W��
		public String reportPath = null;	// RAS�W�s��.rpt�����|
		public Map parameters = new HashMap(2, 3); // �����Ѽƪ� collection
		public String outputType = "";		// ������X���A (PDF, TXT, XLS)
		public String outputFileName = "";	// �w�]���ɮצW��
		public String errorMessage = "";
		public String reportSQL = null;		// �����ҥΤ�SQL
		public String userID = null;		// resultSET �ҥΤ�ID
		public String userPassword = null;	// resultSET�ҥΤ�password
		public String odbcName = null;		// �����ɩҳs���� ODBC Driver �W��
		public Map switchparas = new HashMap(2, 3); // ��ݳB�z�ѼƳ]�w R70292

		DataClass(HttpServletRequest thisReq, HttpServletResponse thisResp) {
			req = thisReq;
			resp = thisResp;
		}
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("�Ұ� CreateReportRS");

		DataClass thisData = new DataClass(req, resp);
		System.out.println("�Ұ� CreateReportRS inner class");
		setDefaultValue(thisData); // �]�w�w�]��

		if (getInputParameter(thisData)) {
			if (!createReport(thisData)) {
				responseMessage(thisData);
			}
		} else {
			responseMessage(thisData);
		}
	}

	/**
	 * ����������T, �ѫe�@��{���Ƕi��, �ҥH�ܼƦW�٥����T�w
	 * 
	 * ReportName : �����W�� OutputFileName : �ץX�ɮצW�� OutputType : �����榡 PDF , TXT ,
	 * XLS ReportSQL : ���� SQL para_* : �ǤJ�������Ѽ� , * ���ܳ]�w�b Crystal Report�W���ѼƦW��
	 */
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

				if (tmpKey.equalsIgnoreCase(CreateReportRS.CLIENT_REPORT_NAME)) {
					thisData.reportName = (String) thisData.req.getAttribute(tmpKey);
				} else if (tmpKey.startsWith(CreateReportRS.CLIENT_PARA_PREFIX)) {
					tmpKey = tmpKey.substring(5);
					thisData.parameters.put(tmpKey, (String) thisData.req.getAttribute("para_" + tmpKey));
				} else if (tmpKey.equalsIgnoreCase(CreateReportRS.CLIENT_OUTPUT_FILE_NAME)) {
					thisData.outputFileName = (String) thisData.req.getAttribute(tmpKey);
				} else if (tmpKey.equalsIgnoreCase(CreateReportRS.CLIENT_OUTPUT_TYPE)) {
					thisData.outputType = (String) thisData.req.getAttribute(tmpKey);
				} else if (tmpKey.equalsIgnoreCase(CreateReportRS.CLIENT_REPORT_SQL)) {
					thisData.reportSQL = (String) thisData.req.getAttribute(tmpKey);
					System.out.println("ReportSQL=" + (String) thisData.req.getAttribute(tmpKey));
					logger.info(",I,ReportSQL:" + (String) thisData.req.getAttribute(tmpKey));
				} else if (tmpKey.equalsIgnoreCase(CreateReportRS.CLIENT_REPORT_PATH)) {
					thisData.reportPath = (String) thisData.req.getAttribute(tmpKey);

				// R70292 ��ݰѼƳB�z
				} else if (tmpKey.startsWith(CreateReportRS.CLIENT_SWITCH_AREA)) {
					tmpKey = tmpKey.substring(7);
					thisData.switchparas.put(tmpKey, (String) thisData.req.getAttribute("switch_" + tmpKey));
					System.out.println("switchparas=" + (String) thisData.req.getAttribute("switch_" + tmpKey));
					logger.info(",I,switchparas:" + (String) thisData.req.getAttribute("switch_" + tmpKey));
				}
				globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG, "CreateReportRS.getInputParameter", "key='" + tmpKey + "', value='" + tmpValue + "'");
			}
		} catch (Exception ex) {
			returnStatus = false;
			ex.printStackTrace();
		}
		return returnStatus;
	}

	/**
	 * �]�w�����Ѽƹw�]��
	 * 
	 * dbServer :DataBase �Ҧb��Server RAS_SERVER_NAME :RAS �Ҧb��Server RAS_USER_ID
	 * :resultSET �ҥΤ�ID RAS_PASSWORD :resultSET�ҥΤ�password RAS_ODBC_NAME
	 * :�����ɩҳs���� ODBC Driver �W�� reportPath :RAS�W�s��.rpt�����|
	 * (�w�]�s��.rpt�����|��D:\WAS5App\AegonWeb.ear\AegonWeb.war\ReportRPT\)
	 */
	private void setDefaultValue(DataClass thisData) {
		try {
			ServletContext application = getServletContext();

			if (globalEnviron == null) {
				globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
			}

			if (dbFactory == null) {
				dbFactory = new DbFactory();
				dbFactory.setGlobalEnviron(globalEnviron);
			}

			if (application.getAttribute("RAS_SERVER_NAME") != null) {
				thisData.reportServer = (String) application.getAttribute("RAS_SERVER_NAME");
				System.out.println("reportServer=" + thisData.reportServer);
			}
			if (application.getAttribute("RAS_USER_ID") != null) {
				thisData.userID = (String) application.getAttribute("RAS_USER_ID");
			}
			if (application.getAttribute("RAS_PASSWORD") != null) {
				thisData.userPassword = (String) application.getAttribute("RAS_PASSWORD");
			}
			if (application.getAttribute("RAS_ODBC_NAME") != null) {
				thisData.odbcName = (String) application.getAttribute("RAS_ODBC_NAME");
			}

			thisData.reportPath = "D:\\WAS5App\\CashWeb.ear\\CashWeb.war\\DISB\\DISBReports\\";

			thisData.outputType = "PDF"; // �w�]��������X���A�� PDF
		} catch (NullPointerException ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * �s�@����.
	 * 
	 * 1.����ܭn�s����DB , �ǤJID & PSW �@Connection 2.�NSQL�ǤJ Report �� DataSource 3.�]�w
	 * Report������T 4.���ͳ���
	 */
	private boolean createReport(DataClass thisData) {
		boolean returnStatus = true;
		Connection connection = null;
		Statement select = null;
		ResultSet rs = null;
		try {

			ReportAppSession ra = new ReportAppSession();
			ra.createService("com.crystaldecisions.sdk.occa.report.application.ReportClientDocument");
			ra.setReportAppServer(thisData.reportServer);
			System.out.println("RAS=" + ra.getReportAppServer());
			ra.initialize();
			System.out.println("RAS initialize ���\.");

			Properties props = new Properties();
			props.put("user", thisData.userID);
			props.put("password", thisData.userPassword);
			props.put("naming", "system");

			connection = dbFactory.getAS400Connection("CreateReportRS");
			select = connection.createStatement();
			rs = select.executeQuery(thisData.reportSQL);
			ReportClientDocument clientDoc = new ReportClientDocument();
			// System.out.println("1thisData.reportSQL="+thisData.reportSQL);
			clientDoc.setReportAppServer(ra.getReportAppServer());
			// System.out.println("2thisData.reportSQL="+thisData.reportSQL);
			clientDoc.open(thisData.reportPath + thisData.reportName, OpenReportOptions._openAsReadOnly);
			// System.out.println("3thisData.reportSQL="+thisData.reportSQL);
			clientDoc.getDatabaseController().setDataSource(rs, "Command", "Reports");
			// System.out.println("4thisData.reportSQL="+thisData.reportSQL);

			// R70292 ��ݰѼƳB�z
			String strYORN = (String) thisData.switchparas.get("CallYorN");
			String strPGM = (String) thisData.switchparas.get("PGM");
			if (strYORN != null && strYORN.equals("Y")) {
				getProcessPara(thisData, strPGM);
			}
			// Process for parameter
			String tmpKey = "";
			String tmpValue = "";
			for (Iterator ite = thisData.parameters.keySet().iterator(); ite.hasNext();) {
				tmpKey = (String) ite.next();
				tmpValue = (String) thisData.parameters.get(tmpKey);

				Fields fields = clientDoc.getDataDefinition().getParameterFields();
				int index = fields.find(tmpKey, FieldDisplayNameType.fieldName, Locale.ENGLISH);

				if (index > -1) {
					globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG, "CreateReport.createReport()", "The first index is '" + String.valueOf(index) + "'");
					globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG, "CreateReportRS.createReport()", "key = '" + tmpKey + "', value='" + tmpValue + "'");

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
				// exportFormat = ReportExportFormat.text;
				exportFormat = ReportExportFormat.crystalReports;
			} else if (thisData.outputType.equalsIgnoreCase("XLS")) {
				thisData.resp.setContentType("application/excel");
				exportFormat = ReportExportFormat.MSExcel;
			} else if (thisData.outputType.equalsIgnoreCase("recXLS")) {
				thisData.resp.setContentType("application/excel");
				exportFormat = ReportExportFormat.recordToMSExcel;
			}

			// thisData.resp.setHeader("Expire","0"); // for HTTP 1.0
			// thisData.resp.setHeader("Pragma","no-cache"); // for HTTP 1.0
			thisData.resp.setHeader("Cash-Control", "private,no-cache,no-store");

			// for HTTP 1.1
			thisData.resp.setHeader("Content-Disposition", "inline;filename=" + thisData.outputFileName);

			// �p�G�����n�令�t�s�s�ɤ覡, �h�n�� attachment , outputFileName�~���ĪG
			// thisData.resp.setHeader("Content-Disposition","attachment;filename="
			// + thisData.outputFileName);

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
			ex.printStackTrace();
			returnStatus = false;
		} finally {
			if (connection != null)
				dbFactory.releaseConnection(connection);
		}
		return returnStatus;
	}

	private void responseMessage(DataClass thisData) {
		RequestDispatcher dispatch = thisData.req.getRequestDispatcher("/ReportCommon/ShowMessage.jsp?message=" + thisData.errorMessage);
		try {
			dispatch.forward(thisData.req, thisData.resp);
		} catch (IOException ex) {
			ex.printStackTrace();
		} catch (ServletException ex) {
			ex.printStackTrace();
		}
		return;
	}

	// R70292 ��ݰѼƳB�z
	private void getProcessPara(DataClass thisData, String strPGM) {
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		if (strPGM.equals("DISBDailyPReports")) {
			String strPDate = (String) thisData.parameters.get("PDate");
			if (strPDate != null) {
				int iNextDT = disbBean.GetNextWorkDay(strPDate);
				thisData.parameters.put("NextWorkDT", Integer.toString(iNextDT));
			}
		}
		return;
	}

}