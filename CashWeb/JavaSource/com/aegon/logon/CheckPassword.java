/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393            Leo Huang    			2010/09/17           現在時間取Capsil營運時間
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
		//資料庫相關欄位變數(本程式主要欄位)
		int iLineCnt = 0; //How many lines had been output in this page, including subtotal line.
		String strSystemId = ""; //系統代號
		String strUserId = ""; //使用者代號
		String strPassword = ""; //密碼
		String strUserType = ""; //使用者類別
		//使用者類別
		// P: Public
		// A: Agency
		// R: Broker
		// D: Bank
		// S: Staff 

		boolean bCaseSensitive = false; //是否區分大小寫	true : 要區分大小寫 , false : 不區分大小寫
		int historyCount = PASSWORD_CHECK_PASSWORD_COUNT;
		// counter for old password can't be the same
		int minLength = PASSWORD_CHECK_MIN_LENGTH; // minimun length

		int iReturnCode = 0; //傳回之訊息代碼
		String strReturnMessageE = ""; //傳回之英文訊息
		String strReturnMessageC = ""; //傳回之中文訊息

		//資料庫連結變數
		public Connection conDb = null; //jdbc connection

		//constructor
		public DataClass() {
			super();
			//將 Date type 的變數設定為初始資料
		}

		//destructor
		public void finalize() {
			releaseConnection();
		}

		//自 DbFactory 中取得一個 Connection
		public boolean getConnection() {
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
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
       //R00393   Edit by Leo Huang (EASONTECH) Start  該變數未使用
		//java.util.Date dteToday = new java.util.Date(System.currentTimeMillis()); //目前日期時間
             //	R00393	Edit by Leo Huang (EASONTECH) End 
		ServletContext application = getServletContext();

		// 取得環境資訊
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

		DataClass objThisData = new DataClass(); //本程式主要各欄位資料

		//先取得資料庫連線
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
	函數名稱:	checkPassword( DataClass objThisData )
	函數功能:	檢核傳入之密碼
	傳入參數:	objThisData	: 所有前端變數之資料結構
	傳 回 值:	bReturnStatus : true : 成功 , false : 失敗
	修改紀錄:	修改日期	修改者	修   改   摘   要
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
			//檢核密碼長度
			if (objThisData.strPassword.length() < objThisData.minLength) {
				objThisData.iReturnCode = -100;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String(
							"<BR>Password is less then "
								+ String.valueOf(objThisData.minLength)
								+ " ");
					objThisData.strReturnMessageC
						+= new String("<BR>密碼長度不可少於" + String.valueOf(objThisData.minLength) + "位 ");
				} else {
					objThisData.strReturnMessageE =
						new String(
							"Password is less then " + String.valueOf(objThisData.minLength) + " ");
					objThisData.strReturnMessageC =
						new String("密碼長度不可少於" + String.valueOf(objThisData.minLength) + "位 ");
				}
			}
			//檢核文數字混合
			for (i = 0; i < objThisData.strPassword.length(); i++) {
				int iChar = objThisData.strPassword.charAt(i);
				if (iChar >= 48 && iChar <= 57) //數字
					bHasNumeric = true;
				if ((iChar >= 65 && iChar <= 90) || (iChar >= 97 && iChar <= 122)) //文字
					bHasAlphabetic = true;
			}
			if (!bHasNumeric) {
				objThisData.iReturnCode = -102;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String("<BR>Password must contain at least one numeric ");
					objThisData.strReturnMessageC += new String("<BR>密碼中至少要有一個數字 ");
				} else {
					objThisData.strReturnMessageE =
						new String("Password must contain at least one numeric ");
					objThisData.strReturnMessageC = new String("密碼中至少要有一個數字 ");
				}
			}
			if (!bHasAlphabetic) {
				objThisData.iReturnCode = -103;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String("<BR>Password must contain at least one alphabetic ");
					objThisData.strReturnMessageC += new String("<BR>密碼中至少要有一個文字 ");
				} else {
					objThisData.strReturnMessageE =
						new String("Password must contain at least one alphabetic ");
					objThisData.strReturnMessageC = new String("密碼中至少要有一個文字 ");
				}
			}
			//不可以數字帶頭
			/*
			if ((int) objThisData.strPassword.charAt(0) >= 48
				&& (int) objThisData.strPassword.charAt(0) <= 57) {
				objThisData.iReturnCode = -104;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String("<BR>Password can not be started with numeric ");
					objThisData.strReturnMessageC += new String("<BR>密碼不可以數字帶頭 ");
				} else {
					objThisData.strReturnMessageE =
						new String("Password can not be started with numeric ");
					objThisData.strReturnMessageC = new String("密碼不可以數字帶頭 ");
				}
			}
			//不可以數字結尾
			if ((int) objThisData.strPassword.charAt(objThisData.strPassword.length() - 1) >= 48
				&& (int) objThisData.strPassword.charAt(objThisData.strPassword.length() - 1) <= 57) {
				objThisData.iReturnCode = -105;
				if (objThisData.strReturnMessageC.length() != 0) {
					objThisData.strReturnMessageE
						+= new String("<BR>Password can not be ended with numeric ");
					objThisData.strReturnMessageC += new String("<BR>密碼不可以數字結尾 ");
				} else {
					objThisData.strReturnMessageE =
						new String("Password can not be ended with numeric ");
					objThisData.strReturnMessageC = new String("密碼不可以數字結尾 ");
				}
			}
			*/
			//不可於前 PASSWORD_CHECK_PASSWORD_COUNT 次相同
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
										"<BR>密碼不可以與前"
											+ String.valueOf(objThisData.historyCount)
											+ "次相同");
							} else {
								objThisData.strReturnMessageE =
									new String(
										"Password can not be the same with last "
											+ String.valueOf(objThisData.historyCount)
											+ " times");
								objThisData.strReturnMessageC =
									new String(
										"密碼不可以與前"
											+ String.valueOf(objThisData.historyCount)
											+ "次相同");
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
			//Administrator 要加強檢核
			/*
			if (objThisData.strUserType.equalsIgnoreCase("A")) {
				boolean bHasUpperCase = false;
				boolean bHasLowerCase = false;
			
				//長度要 PASSWORD_CHECK_MIN_LENGTH_ADM 位
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
								"<BR>Administrator密碼長度不可少於"
									+ String.valueOf(PASSWORD_CHECK_MIN_LENGTH_ADM)
									+ "位 ");
					} else {
						objThisData.strReturnMessageE =
							new String(
								"Password of administrator is less then "
									+ String.valueOf(PASSWORD_CHECK_MIN_LENGTH_ADM)
									+ " ");
						objThisData.strReturnMessageC =
							new String(
								"Administrator密碼長度不可少於"
									+ String.valueOf(PASSWORD_CHECK_MIN_LENGTH_ADM)
									+ "位 ");
					}
				}
				//大小寫混合
				for (i = 0; i < objThisData.strPassword.length(); i++) {
					int iChar = objThisData.strPassword.charAt(i);
					if ((iChar >= 65 && iChar <= 90)) //大寫
						bHasUpperCase = true;
					if ((iChar >= 97 && iChar <= 122)) //小寫
						bHasLowerCase = true;
				}
				if (!bHasUpperCase || !bHasLowerCase) {
					objThisData.iReturnCode = -108;
					if (objThisData.strReturnMessageC.length() != 0) {
						objThisData.strReturnMessageE
							+= new String("<BR>Password of administrator must contain both upper and lower case ");
						objThisData.strReturnMessageC += new String("<BR>Administrator的密碼必需是大小寫混合");
					} else {
						objThisData.strReturnMessageE =
							new String("Password of administrator must contain both upper and lower case ");
						objThisData.strReturnMessageC = new String("Administrator的密碼必需是大小寫混合");
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
	函數名稱:	getInputParameter( Document xmlDom , DataCalss objThisData ) 
	函數功能:	將Client端傳入之各欄位值存入objThisData中
	傳入參數:	Document xmlDom : Client傳入之資料
				DataClass objThisData : 本程式所有的欄位值
	傳回值:		若有任一欄位錯誤,傳回false,否則傳回true
	修改紀錄:	修改日期	修改者	修   改   摘   要
			---------	----------	-----------------------------------------
	*/
	private boolean getInputParameter(HttpServletRequest request, DataClass objThisData) {
		boolean bReturnStatus = true;

		objThisData.writeDebugLog(
			Constant.DEBUG_DEBUG,
			strThisProgId + ":getInputParameter()",
			"Enter");

		//將前端傳來之資料轉為 Document 物件
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

			//取得Client端之資料,存入DataClass中
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
				objThisData.setLastError(strThisProgId + ":getInputParameter()", "systemId 不可空白");
				bReturnStatus = false;
			}
			if (objThisData.strUserId == null) {
				objThisData.setLastError(strThisProgId + ":getInputParameter()", "userId 不可空白");
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
	函數名稱:	moveToXML(Document xmlDom,DataClass objThisData)
	函數功能:	將ResultSet中之值轉入xml中
	傳入參數:	Document xmlDom				: 傳回之xmlDom
				DataClass objThisData		: 所有前端變數之資料結構
	傳 回 值:	strReturn		: 若為空白,則表示成功.否則傳回錯誤訊息
	修改紀錄:	修改日期	修改者	修   改   摘   要
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
	函數名稱:	writePasswordLog( DataClass objThisData )
	函數功能:	紀錄修改密碼
	傳入參數:	objThisData	: 所有前端變數之資料結構
	傳 回 值:	bReturnStatus :	true 成功 , false : 失敗
	修改紀錄:	修改日期	修改者	修   改   摘   要
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
