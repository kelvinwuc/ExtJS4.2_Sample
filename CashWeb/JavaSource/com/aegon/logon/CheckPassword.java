/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393            Leo Huang    			2010/09/17           �{�b�ɶ���Capsil��B�ɶ�
 *  =============================================================================
 */
package com.aegon.logon;

import java.io.IOException;
import javax.servlet.Servlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.*;

import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;

/**
 * @version 	1.0
 * @author
 */
public class CheckPassword extends HttpServlet implements Servlet {

	final static String strThisProgId = "CheckPassword";
	GlobalEnviron globalEnviron = null;
	DbFactory dbFactory = null;
	XMLOutputter outputter = null;
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

	final static int PASSWORD_CHECK_MIN_LENGTH = 7;
	final static int PASSWORD_CHECK_PASSWORD_COUNT = 5;
	final static String PWSSWORD_CHECK_DB_NAME = "CASH";

	class DataClass extends RootClass {
		//��Ʈw��������ܼ�(���{���D�n���)
		int iLineCnt = 0; //How many lines had been output in this page, including subtotal line.
		String strSystemId = ""; //�t�ΥN��
		String strUserId = ""; //�ϥΪ̥N��
		String strPassword = ""; //�K�X
		String strUserType = ""; //�ϥΪ����O
		//�ϥΪ����O
		// P: Public
		// A: Agency
		// R: Broker
		// D: Bank
		// S: Staff 

		boolean bCaseSensitive = false; //�O�_�Ϥ��j�p�g	true : �n�Ϥ��j�p�g , false : ���Ϥ��j�p�g
		int historyCount = PASSWORD_CHECK_PASSWORD_COUNT;
		// counter for old password can't be the same
		int minLength = PASSWORD_CHECK_MIN_LENGTH; // minimun length

		int iReturnCode = 0; //�Ǧ^���T���N�X
		String strReturnMessageE = ""; //�Ǧ^���^��T��
		String strReturnMessageC = ""; //�Ǧ^������T��

		//��Ʈw�s���ܼ�
		public Connection conDb = null; //jdbc connection

		//constructor
		public DataClass() {
			super();
			//�N Date type ���ܼƳ]�w����l���
		}

		//destructor
		public void finalize() {
			releaseConnection();
		}

		//�� DbFactory �����o�@�� Connection
		public boolean getConnection() {
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
			if (conDb == null) {
				conDb = dbFactory.getConnection(strThisProgId);
			}
			if (conDb == null)
				bReturnStatus = false;
			if (bReturnStatus)
				writeDebugLog(
					Constant.DEBUG_DEBUG,
					strThisProgId + ":getConnection()",
					"getConnection O.K.");
			else
				writeDebugLog(
					Constant.DEBUG_ERROR,
					strThisProgId + ":getConnection()",
					"dbFactory.getConnection() return null error!!");

			return bReturnStatus;
		}

		public void releaseConnection() {
			if (conDb != null)
				dbFactory.releaseConnection(conDb);
			conDb = null;
		}
	}

	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
		doPost(req, resp);
	}

	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
       //R00393   Edit by Leo Huang (EASONTECH) Start  ���ܼƥ��ϥ�
		//java.util.Date dteToday = new java.util.Date(System.currentTimeMillis()); //�ثe����ɶ�
             //	R00393	Edit by Leo Huang (EASONTECH) End 
		ServletContext application = getServletContext();

		// ���o���Ҹ�T
		try {

			if (globalEnviron == null) {
				globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
			}
			if (dbFactory == null) {
				dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
			}
			if (outputter == null) {
				outputter = new XMLOutputter("  ", true, "UTF-8");
			}
		} catch (NullPointerException ex) {
			System.err.println("CheckPassword can't get GlobalEnviron and DbFactory !");
			return;
		}

		DataClass objThisData = new DataClass(); //���{���D�n�U�����

		//�����o��Ʈw�s�u
		if (!objThisData.getConnection()) {
			objThisData.iReturnCode = -1;
			if (objThisData.strReturnMessageC.length() != 0) {
				objThisData.strReturnMessageE += "<BR>" + objThisData.getLastErrorMessage();
				objThisData.strReturnMessageC += "<BR>" + objThisData.getLastErrorMessage();
			} else {
				objThisData.strReturnMessageE = objThisData.getLastErrorMessage();
				objThisData.strReturnMessageC = objThisData.getLastErrorMessage();
			}
		}

		objThisData.writeDebugLog(
			Constant.DEBUG_DEBUG,
			strThisProgId + ":service()",
			"Server side Enter");

		if (!getInputParameter(request, objThisData)) {
			objThisData.iReturnCode = -2;
			if (objThisData.strReturnMessageC.length() != 0) {
				objThisData.strReturnMessageE += "<BR>" + objThisData.getLastErrorMessage();
				objThisData.strReturnMessageC += "<BR>" + objThisData.getLastErrorMessage();
			} else {
				objThisData.strReturnMessageE = objThisData.getLastErrorMessage();
				objThisData.strReturnMessageC = objThisData.getLastErrorMessage();
			}
		}

		if (objThisData.iReturnCode == 0) {
			if (!checkPassword(objThisData)) {
				objThisData.iReturnCode = -3;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE += "<BR>" + objThisData.getLastErrorMessage();
					objThisData.strReturnMessageC += "<BR>" + objThisData.getLastErrorMessage();
				} else {
					objThisData.strReturnMessageE = objThisData.getLastErrorMessage();
					objThisData.strReturnMessageC = objThisData.getLastErrorMessage();
				}
			}
		}
		if (objThisData.iReturnCode == 0) {
			if (!writePasswordLog(objThisData)) {
				objThisData.iReturnCode = -4;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE += "<BR>" + objThisData.getLastErrorMessage();
					objThisData.strReturnMessageC += "<BR>" + objThisData.getLastErrorMessage();
				} else {
					objThisData.strReturnMessageE = objThisData.getLastErrorMessage();
					objThisData.strReturnMessageC = objThisData.getLastErrorMessage();
				}
			}
		}

		//moveToXML(xmlDom, objThisData);
		// Send XML to client
		sendMessage(response, objThisData);
	}

	/**
	��ƦW��:	checkPassword( DataClass objThisData )
	��ƥ\��:	�ˮֶǤJ���K�X
	�ǤJ�Ѽ�:	objThisData	: �Ҧ��e���ܼƤ���Ƶ��c
	�� �^ ��:	bReturnStatus : true : ���\ , false : ����
	�ק����:	�ק���	�ק��	��   ��   �K   �n
			---------	----------	-----------------------------------------
	*/
	private boolean checkPassword(DataClass objThisData) {
		boolean bReturnStatus = true;
		Statement stmtStatement = null;
		ResultSet rstResultSet = null;
		boolean bHasNumeric = false;
		boolean bHasAlphabetic = false;
		int i = 0;
		boolean bHasSamePassword = false;
		String strSql = new String("");

		if (objThisData.strPassword != null) {
			//�ˮֱK�X����
			if (objThisData.strPassword.length() < objThisData.minLength) {
				objThisData.iReturnCode = -100;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String(
							"<BR>Password is less then "
								+ String.valueOf(objThisData.minLength)
								+ " ");
					objThisData.strReturnMessageC
						+= new String("<BR>�K�X���פ��i�֩�" + String.valueOf(objThisData.minLength) + "�� ");
				} else {
					objThisData.strReturnMessageE =
						new String(
							"Password is less then " + String.valueOf(objThisData.minLength) + " ");
					objThisData.strReturnMessageC =
						new String("�K�X���פ��i�֩�" + String.valueOf(objThisData.minLength) + "�� ");
				}
			}
			//�ˮ֤�Ʀr�V�X
			for (i = 0; i < objThisData.strPassword.length(); i++) {
				int iChar = objThisData.strPassword.charAt(i);
				if (iChar >= 48 && iChar <= 57) //�Ʀr
					bHasNumeric = true;
				if ((iChar >= 65 && iChar <= 90) || (iChar >= 97 && iChar <= 122)) //��r
					bHasAlphabetic = true;
			}
			if (!bHasNumeric) {
				objThisData.iReturnCode = -102;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String("<BR>Password must contain at least one numeric ");
					objThisData.strReturnMessageC += new String("<BR>�K�X���ܤ֭n���@�ӼƦr ");
				} else {
					objThisData.strReturnMessageE =
						new String("Password must contain at least one numeric ");
					objThisData.strReturnMessageC = new String("�K�X���ܤ֭n���@�ӼƦr ");
				}
			}
			if (!bHasAlphabetic) {
				objThisData.iReturnCode = -103;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String("<BR>Password must contain at least one alphabetic ");
					objThisData.strReturnMessageC += new String("<BR>�K�X���ܤ֭n���@�Ӥ�r ");
				} else {
					objThisData.strReturnMessageE =
						new String("Password must contain at least one alphabetic ");
					objThisData.strReturnMessageC = new String("�K�X���ܤ֭n���@�Ӥ�r ");
				}
			}
			//���i�H�Ʀr�a�Y
			/*
			if ((int) objThisData.strPassword.charAt(0) >= 48
				&& (int) objThisData.strPassword.charAt(0) <= 57) {
				objThisData.iReturnCode = -104;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String("<BR>Password can not be started with numeric ");
					objThisData.strReturnMessageC += new String("<BR>�K�X���i�H�Ʀr�a�Y ");
				} else {
					objThisData.strReturnMessageE =
						new String("Password can not be started with numeric ");
					objThisData.strReturnMessageC = new String("�K�X���i�H�Ʀr�a�Y ");
				}
			}
			//���i�H�Ʀr����
			if ((int) objThisData.strPassword.charAt(objThisData.strPassword.length() - 1) >= 48
				&& (int) objThisData.strPassword.charAt(objThisData.strPassword.length() - 1) <= 57) {
				objThisData.iReturnCode = -105;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String("<BR>Password can not be ended with numeric ");
					objThisData.strReturnMessageC += new String("<BR>�K�X���i�H�Ʀr���� ");
				} else {
					objThisData.strReturnMessageE =
						new String("Password can not be ended with numeric ");
					objThisData.strReturnMessageC = new String("�K�X���i�H�Ʀr���� ");
				}
			}
			*/
			//���i��e PASSWORD_CHECK_PASSWORD_COUNT ���ۦP
			if (!objThisData.strUserType.equalsIgnoreCase("A")) {

				strSql =
					new String(
						"set rowcount "
							+ String.valueOf(objThisData.historyCount)
							+ " select * from "
							+ PWSSWORD_CHECK_DB_NAME
							+ "..tPasswordLog where SystemId = '");
				strSql += objThisData.strSystemId + "' and UserId = '";
				strSql += objThisData.strUserId + "' order by CheckTime desc";

				try {
					stmtStatement = objThisData.conDb.createStatement();
					rstResultSet = stmtStatement.executeQuery(strSql);
					while (rstResultSet.next()) {
						if (objThisData.bCaseSensitive) {
							if (rstResultSet.getString("password").equals(objThisData.strPassword))
								bHasSamePassword = true;
						} else {
							if (rstResultSet
								.getString("password")
								.equalsIgnoreCase(objThisData.strPassword))
								bHasSamePassword = true;
						}
						if (bHasSamePassword) {
							objThisData.iReturnCode = -106;
							if (objThisData.strReturnMessageC.length() != 0) {
								objThisData.strReturnMessageE
									+= new String(
										"<BR>Password can not be the same with last "
											+ String.valueOf(objThisData.historyCount)
											+ " times");
								objThisData.strReturnMessageC
									+= new String(
										"<BR>�K�X���i�H�P�e"
											+ String.valueOf(objThisData.historyCount)
											+ "���ۦP");
							} else {
								objThisData.strReturnMessageE =
									new String(
										"Password can not be the same with last "
											+ String.valueOf(objThisData.historyCount)
											+ " times");
								objThisData.strReturnMessageC =
									new String(
										"�K�X���i�H�P�e"
											+ String.valueOf(objThisData.historyCount)
											+ "���ۦP");
							}
							break;
						}
					}
					rstResultSet.close();
					strSql = "set rowcount 0 ";
					stmtStatement.execute(strSql);
					stmtStatement.close();
				} catch (Exception e) {
					objThisData.setLastError(
						strThisProgId + ":checkPassword()",
						e);
					bReturnStatus = false;
				}
			}
			//Administrator �n�[�j�ˮ�
			/*
			if (objThisData.strUserType.equalsIgnoreCase("A")) {
				boolean bHasUpperCase = false;
				boolean bHasLowerCase = false;
			
				//���׭n PASSWORD_CHECK_MIN_LENGTH_ADM ��
				if (objThisData.strPassword.length() < PASSWORD_CHECK_MIN_LENGTH_ADM) {
					objThisData.iReturnCode = -107;
					if (objThisData.strReturnMessageC.length() != 0) {
						objThisData.strReturnMessageE
							+= new String(
								"<BR>Password of administrator is less then "
									+ String.valueOf(PASSWORD_CHECK_MIN_LENGTH_ADM)
									+ " ");
						objThisData.strReturnMessageC
							+= new String(
								"<BR>Administrator�K�X���פ��i�֩�"
									+ String.valueOf(PASSWORD_CHECK_MIN_LENGTH_ADM)
									+ "�� ");
					} else {
						objThisData.strReturnMessageE =
							new String(
								"Password of administrator is less then "
									+ String.valueOf(PASSWORD_CHECK_MIN_LENGTH_ADM)
									+ " ");
						objThisData.strReturnMessageC =
							new String(
								"Administrator�K�X���פ��i�֩�"
									+ String.valueOf(PASSWORD_CHECK_MIN_LENGTH_ADM)
									+ "�� ");
					}
				}
				//�j�p�g�V�X
				for (i = 0; i < objThisData.strPassword.length(); i++) {
					int iChar = objThisData.strPassword.charAt(i);
					if ((iChar >= 65 && iChar <= 90)) //�j�g
						bHasUpperCase = true;
					if ((iChar >= 97 && iChar <= 122)) //�p�g
						bHasLowerCase = true;
				}
				if (!bHasUpperCase || !bHasLowerCase) {
					objThisData.iReturnCode = -108;
					if (objThisData.strReturnMessageC.length() != 0) {
						objThisData.strReturnMessageE
							+= new String("<BR>Password of administrator must contain both upper and lower case ");
						objThisData.strReturnMessageC += new String("<BR>Administrator���K�X���ݬO�j�p�g�V�X");
					} else {
						objThisData.strReturnMessageE =
							new String("Password of administrator must contain both upper and lower case ");
						objThisData.strReturnMessageC = new String("Administrator���K�X���ݬO�j�p�g�V�X");
					}
				}
			}
			*/
		} else {
			objThisData.iReturnCode = -101;
			if (objThisData.strReturnMessageC.length() != 0) {
				objThisData.strReturnMessageE += new String("<BR>null password");
				objThisData.strReturnMessageC += new String("<BR>null password");
			} else {
				objThisData.strReturnMessageE = new String("null password");
				objThisData.strReturnMessageC = new String("null password");
			}
		}
		return bReturnStatus;
	}

	/**
	��ƦW��:	getInputParameter( Document xmlDom , DataCalss objThisData ) 
	��ƥ\��:	�NClient�ݶǤJ���U���Ȧs�JobjThisData��
	�ǤJ�Ѽ�:	Document xmlDom : Client�ǤJ�����
				DataClass objThisData : ���{���Ҧ�������
	�Ǧ^��:		�Y�����@�����~,�Ǧ^false,�_�h�Ǧ^true
	�ק����:	�ק���	�ק��	��   ��   �K   �n
			---------	----------	-----------------------------------------
	*/
	private boolean getInputParameter(HttpServletRequest request, DataClass objThisData) {
		boolean bReturnStatus = true;

		objThisData.writeDebugLog(
			Constant.DEBUG_DEBUG,
			strThisProgId + ":getInputParameter()",
			"Enter");

		//�N�e�ݶǨӤ�����ର Document ����
		Document xmlDom = null;
		org.xml.sax.InputSource inputSource = null;
		try {
			inputSource =
				new org.xml.sax.InputSource(
					new InputStreamReader(request.getInputStream(), "UTF-8"));
		} catch (Exception ex) {
			objThisData.writeDebugLog(
				Constant.DEBUG_ERROR,
				strThisProgId + ":service()",
				"parser Exception : " + ex.getMessage());
		}
		SAXBuilder builder = new SAXBuilder();
		try {

			xmlDom = builder.build(inputSource);

			//���oClient�ݤ����,�s�JDataClass��
			Element root = xmlDom.getRootElement();

			objThisData.strSystemId = root.getChildTextTrim("systemId");
			objThisData.strUserId = root.getChildTextTrim("userId");
			objThisData.strPassword = root.getChildText("password");
			objThisData.strUserType = root.getChildText("userType");
			if (root.getChildTextTrim("caseSensitive") != null
				&& root.getChildTextTrim("caseSensitive").startsWith("Y")) {
				objThisData.bCaseSensitive = true;
			} else {
				objThisData.bCaseSensitive = false;
			}

			if (objThisData.strSystemId == null) {
				objThisData.setLastError(strThisProgId + ":getInputParameter()", "systemId ���i�ť�");
				bReturnStatus = false;
			}
			if (objThisData.strUserId == null) {
				objThisData.setLastError(strThisProgId + ":getInputParameter()", "userId ���i�ť�");
				bReturnStatus = false;
			}
		} catch (IOException ex) {
			bReturnStatus = false;
			objThisData.setLastError(ex);
		} catch (JDOMException ex) {
			bReturnStatus = false;
			objThisData.setLastError(ex);
		}

		if (bReturnStatus)
			objThisData.writeDebugLog(
				Constant.DEBUG_DEBUG,
				strThisProgId + ":getInputParameter()",
				"Exit with status true ");
		else
			objThisData.writeDebugLog(
				Constant.DEBUG_DEBUG,
				strThisProgId + ":getInputParameter()",
				"Exit with status false");
		return bReturnStatus;
	}

	/**
	��ƦW��:	moveToXML(Document xmlDom,DataClass objThisData)
	��ƥ\��:	�NResultSet��������Jxml��
	�ǤJ�Ѽ�:	Document xmlDom				: �Ǧ^��xmlDom
				DataClass objThisData		: �Ҧ��e���ܼƤ���Ƶ��c
	�� �^ ��:	strReturn		: �Y���ť�,�h��ܦ��\.�_�h�Ǧ^���~�T��
	�ק����:	�ק���	�ק��	��   ��   �K   �n
			---------	----------	-----------------------------------------
	*/
	private boolean sendMessage(HttpServletResponse response, DataClass objThisData)
		throws ServletException, IOException {
		boolean bReturn = true;
		CommonUtil commonUtil = new CommonUtil();

		Document doc =
			new Document(
				new Element("request")
					.addContent(
						new Element("returnCode").setText(String.valueOf(objThisData.iReturnCode)))
					.addContent(
						new Element("returnMessageE").setText(objThisData.strReturnMessageE))
					.addContent(
						new Element("returnMessageC").setText(objThisData.strReturnMessageC)));

		outputter.output(doc, response.getOutputStream());

		return bReturn;
	}

	/**
	��ƦW��:	writePasswordLog( DataClass objThisData )
	��ƥ\��:	�����ק�K�X
	�ǤJ�Ѽ�:	objThisData	: �Ҧ��e���ܼƤ���Ƶ��c
	�� �^ ��:	bReturnStatus :	true ���\ , false : ����
	�ק����:	�ק���	�ק��	��   ��   �K   �n
			---------	----------	-----------------------------------------
	*/
	private boolean writePasswordLog(DataClass objThisData) {
		Statement stmtStatement = null;
		ResultSet rstResultSet = null;
		int iRowInserted = 0;
		boolean bReturnStatus = true;
		
		String strSql = "";
		try {
			stmtStatement =
				objThisData.conDb.createStatement(
					ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			strSql =
				"insert into "
					+ PWSSWORD_CHECK_DB_NAME
					+ "..tPasswordLog (SystemId,UserId,CheckTime,Password,UserType,CaseSensitive) values ";
			strSql += " ('" + objThisData.strSystemId + "'";
			strSql += ",'" + objThisData.strUserId + "'";
			strSql += ",'" + sdfDateFormatter.format(new java.util.Date()) + "'";
			strSql += ",'" + objThisData.strPassword + "'";
			strSql += ",'" + objThisData.strUserType + "'";
			if (objThisData.bCaseSensitive)
				strSql += ",'Y')";
			else
				strSql += ",'N')";
			objThisData.writeDebugLog(
				Constant.DEBUG_DEBUG,
				strThisProgId + ":writePasswordLog()",
				"The insert Sql = '" + strSql + "'");
			iRowInserted = stmtStatement.executeUpdate(strSql);
			if (iRowInserted != 1) {
				objThisData.setLastError(
					strThisProgId + ":writePasswordLog()",
					"Statement.executeUpdate() return not equals 1");
				bReturnStatus = false;
			}
		} catch (Exception e) {
			System.err.println("CheckPassword.writePasswordLog():sql='"+strSql+"'");
			objThisData.setLastError(strThisProgId + ":writePasswordLog()", e);
			bReturnStatus = false;
		}
		return bReturnStatus;
	}

}
