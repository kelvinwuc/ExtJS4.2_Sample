<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393      Leo Huang    			2010/09/20           現在時間取Capsil營運時間
 *  =============================================================================
 */
%>
<%@ page contentType="text/html; charset=Big5" pageEncoding="Big5"%>
<%@ include file="../Logon/Init.inc" %>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.aegon.comlib.*" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.aegon.servlet.*" %>
<%@ page import="org.apache.xml.serialize.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.apache.xerces.parsers.*" %>
<%@ page import="org.xml.sax.*" %>
<%!
//在此定義calss variable

	String strThisProgId = new String("SecretWordInput");		//本程式代號
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393   Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	class DataClass extends Object 
	{
		//資料庫相關欄位變數(本程式主要欄位)
		public String strUserId = new String("");		//使用者代號
		public String strSecretWordQuestion = "";		//密碼提示語問題
		public String strSecretWordAnswer = "";			//密碼提示問題之答案

		public SessionInfo siThisSessionInfo = null;						//每一支程式所在的Session information	
		public String strAction = new String("");							//Client端之功能要求:'A':新增,'U':修改,'D':刪除,'I':查詢

		//資料庫連結變數
		public Connection conDb = null;									//CallCenter之jdbc connection

		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			//將 Date type 的變數設定為初始資料
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
		}

		//自 DbFactory 中取得一個 Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("SecretWordInputS.DataClass.getConnection()");
			if( conDb == null )
				bReturnStatus = false;
			if( bReturnStatus )
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getConnection()","getConnection O.K.");
			else
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":getConnection()","siThisSessionInfo.getUserInfo().getDbFactory().getConnection() return null error!!");

			return bReturnStatus;
		}
		
		// 關閉 Connection
		public boolean releaseConnection()
		{
			boolean bReturnStatus = true ;
			if(conDb!=null){
				siThisSessionInfo.getUserInfo().getDbFactory().releaseConnection(conDb);
			}
			return bReturnStatus ;	
		}

		//取得本程式的 Insert SQL
		public String getInsertSql()
		{	
			String strReturn = new  String("");
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInsertSql()","The insert sql is '"+strReturn+"'");
			return strReturn;
		}

		//取得本程式的 Update SQL
		public String getUpdateSql()
		{	
			String strReturn = 
				"update USER set "
					+" SCTQ='"+strSecretWordQuestion+"', "
					+" SCTA='"+strSecretWordAnswer+"' "
					+" where USRID='"+strUserId+"' ";
					
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getUpdateSql()","The update sql is '"+strReturn+"'");
			return strReturn;
		}

		//取得本程式的 Delete SQL
		public String getDeleteSql()
		{	
			String strReturn = new  String("");
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}


		//取得本程式的 Inquiry SQL
		public String getInquirySql()
		{	
			String strReturn = 
				"select 1 from USER where USRID='"+strUserId+"' ";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}
	}

%>
<%!
//本程式之獨立函數在此定義
/**
函數名稱:	checkFieldsServer( DataClass objThisData )
函數功能:	檢查所有的欄位,若有任一欄位錯誤,則傳回false,否則傳回true
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有任一欄位錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean checkFieldsServer( DataClass objThisData )
{
	boolean bReturnStatus = true;

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Enter");
	if( objThisData.strUserId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","使用者代號不可空白");
		bReturnStatus = false;
	}

	if( objThisData.strSecretWordQuestion.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","密碼提示語問題不可空白");
		bReturnStatus = false;
	}

	if( objThisData.strSecretWordAnswer.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","密碼提示問題之答案不可空白");
		bReturnStatus = false;
	}

	if( bReturnStatus )	
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status false");
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
public boolean getInputParameter( Document xmlDom ,DataClass objThisData)
{
	boolean bReturnStatus = true;
	String strTmp = new String("");
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//CommonUtil commonUtil = new CommonUtil();
	//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
	//R00393  Edit by Leo Huang (EASONTECH) End

	try
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
		//取得Client端之資料,存入DataClass中
		
		objThisData.strAction = xmlDom.getElementsByTagName("txtAction").item(0).getFirstChild().getNodeValue();
			
		if( objThisData.strAction == null )
			objThisData.strAction = "";	

		objThisData.strSecretWordQuestion = xmlDom.getElementsByTagName("txtSecretWordQuestion").item(0).getFirstChild().getNodeValue();
		if( objThisData.strSecretWordQuestion == null )
			objThisData.strSecretWordQuestion = "";

		objThisData.strSecretWordAnswer = xmlDom.getElementsByTagName("txtSecretWordAnswer").item(0).getFirstChild().getNodeValue();
		if( objThisData.strSecretWordAnswer == null )
			objThisData.strSecretWordAnswer = "";	
	}
	catch( Exception e )
	{
		bReturnStatus = false;
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status true");
	else	
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status false");
	return bReturnStatus;
}
/**
函數名稱:	insertDb( DataClass objThisData )
函數功能:	將一筆資料新增至tuser table 中
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean insertDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	/*
	Statement stmInsert = null;			//Insert tuser 之statement
	String strInsertSql = new String("");	//Insert tuser 之SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Enter");
	//顯檢查鍵值是否存在,如果存在則傳回錯誤訊息,否則將改筆資料新增至資料庫中
	if( isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","使用者代號 '"+objThisData.strUserId+"' 已存在於資料庫中");
		bReturnStatus = false;
	}
	else
	{
		try
		{
			strInsertSql = objThisData.getInsertSql();
			stmInsert = objThisData.conDb.createStatement();
			iReturn = stmInsert.executeUpdate(strInsertSql);
			if( iReturn != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","The insert sql return != 1 return = '"+String.valueOf(iReturn)+"'");
				bReturnStatus = false;
			}
		}
		catch( SQLException e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()",e);
			bReturnStatus = false;
		}
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Exit with status false");
	*/
	return bReturnStatus;
}
/**
函數名稱:	updateDb( DataClass objThisData )
函數功能:	更新該筆資料
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean updateDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmUpdate = null;			//Update tuser 之statement
	String strUpdateSql = new String("");	//Update tuser 之SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Enter");
	//先檢查該筆資料是否存在於資料庫中,若不存在,則傳回錯誤訊息,否則進行資料庫更新
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","使用者代號 '"+objThisData.strUserId+"' 未存在於資料庫中");
		bReturnStatus = false;
	}
	else
	{
		try
		{
			strUpdateSql = objThisData.getUpdateSql();
			stmUpdate = objThisData.conDb.createStatement();
			iReturn = stmUpdate.executeUpdate(strUpdateSql);
			if( iReturn != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","The update sql return != 1 return = '"+String.valueOf(iReturn)+"'");
				bReturnStatus = false;
			}
		}
		catch( SQLException e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()",e);
			bReturnStatus = false;
		}
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Exit with status false");
	return bReturnStatus;
}
/**
函數名稱:	inquiryDb( DataClass objThisData )
函數功能:	自資料庫中查詢一筆資料
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean inquiryDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	/*
	Statement stmInquiry = null;			//Inquiry tuser 之statement
	String strInquirySql = new String("");	//Inquiry tuser 之SQL
	ResultSet rstResultSet = null;		//Inquiry tuser 傳回之ResultSet
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Enter");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstResultSet = stmInquiry.executeQuery(strInquirySql);
		if( rstResultSet.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Fetch 1 record successfully");
			objThisData.strUserId = rstResultSet.getString("user_id").trim();
			objThisData.strUserName = rstResultSet.getString("user_name").trim();
			objThisData.strPassword = rstResultSet.getString("password").trim();
			objThisData.strPasswordConfirm = objThisData.strPassword;
			objThisData.dteCreateDate = rstResultSet.getDate("create_date");
			objThisData.strUserStatus = rstResultSet.getString("user_status").trim();
			objThisData.strUserType = rstResultSet.getString("user_type").trim();
			objThisData.dteLastLoginDate = rstResultSet.getDate("last_login_date");
			objThisData.dteLastPasswdDate = rstResultSet.getDate("last_password_date");
			objThisData.strRemark = rstResultSet.getString("remark").trim();
			objThisData.iPasswordValidDay = rstResultSet.getInt("password_valid_day");
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Password valid days = '"+String.valueOf(objThisData.iPasswordValidDay)+"'");
		}
		else
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","使用者代號 '"+objThisData.strUserId+"' 未存在於資料庫中");
			bReturnStatus = false;
		}
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Exit with status false");
	*/
	return bReturnStatus;
}

/**
函數名稱:	deleteDb( DataClass objThisData )
函數功能:	刪除一筆資料
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean deleteDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	/*
	Statement stmDelete = null;			//Delete tuser 之statement
	String strDeleteSql = new String("");	//Delete tuser 之SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Enter");
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","使用者代號 '"+objThisData.strUserId+"' 未存在於資料庫中");
		bReturnStatus = false;
	}
	else
	{
		try
		{
			strDeleteSql = objThisData.getDeleteSql();
			stmDelete = objThisData.conDb.createStatement();
			iReturn = stmDelete.executeUpdate(strDeleteSql);
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","'"+String.valueOf(iReturn)+"' record deleted");
			if( iReturn != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","The update sql return != 1 return = '"+String.valueOf(iReturn)+"'");
				bReturnStatus = false;
			}
		}
		catch( SQLException e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()",e);
			bReturnStatus = false;
		}
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Exit with status false");
	*/
	return bReturnStatus;
}

/**
函數名稱:	isKeyExist( DataClass objThisData )
函數功能:	檢核主鍵值是否存在於資料庫中
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若不存在則傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean isKeyExist( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInquiry = null;				//inquiry tuser 之statement
	ResultSet rstUser = null;				//stmInquiry傳回之Resultset
	String strInquirySql = null;
												//查詢SQL
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the user_id is '"+objThisData.strUserId+"'");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstUser = stmInquiry.executeQuery(strInquirySql);
		if( !rstUser.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The user_id '"+objThisData.strUserId+"' is not exist in the database");
			bReturnStatus = false;
		}
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The user_id '"+objThisData.strUserId+"' is exist in the database");
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkKey()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Exit with status false");
	return bReturnStatus;
}

/**
函數名稱:	moveToXML( DataClass objThisData , Document xmlDom )
函數功能:	將記憶體變數之值轉入xml中
傳入參數:	objThisData	: 所有前端變數之資料結構
			xmlDom		: XML資料結構
傳 回 值:	strReturn		: 若為空白,則表示完成.否則傳回錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean moveToXML( DataClass objThisData , Document xmlDom )
{
	boolean bReturn = true;

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Enter");
	try
	{	
		xmlDom.getElementsByTagName("txtAction").item(0).getFirstChild().setNodeValue( objThisData.strAction );
		xmlDom.getElementsByTagName("txtSecretWordQuestion").item(0).getFirstChild().setNodeValue( objThisData.strSecretWordQuestion );
		xmlDom.getElementsByTagName("txtSecretWordAnswer").item(0).getFirstChild().setNodeValue( objThisData.strSecretWordAnswer );
	}
	catch(Exception ex)
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":moveToXML()","Exception : "+ex.getMessage());
		bReturn = false;
	}
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Exit");
	return bReturn;
}


/**
函數名稱:	validDom( DataClass objThisData , Document xmlDom )
函數功能:	將 DOM 中之每一 Element 都加上 Text
傳入參數:	objThisData	: 所有前端變數之資料結構
			xmlDom		: XML資料結構
傳 回 值:	strReturn		: 若為空白,則表示完成.否則傳回錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean validDom( DataClass objThisData , Document xmlDom )
{
	boolean bReturn = true;
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":validDom()","Enter");
	try
	{	
		Element elmtRoot = xmlDom.getDocumentElement();
		if( elmtRoot.hasChildNodes() )
		{
			createNodeText( objThisData , (Node)elmtRoot );
		}
		else
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":validDom()","Input dom is empty  ");
			bReturn = false;
		}
	}
	catch(Exception ex)
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":validDom()","Exception : "+ex.getMessage());
		bReturn = false;
	}
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":validDom()","Exit");
	return bReturn;
}


/**
函數名稱:	createNodeText( DataClass objThisData , Node xmlDom )
函數功能:	將 DOM 中之每一 Element 都加上 Text
傳入參數:	objThisData	: 所有前端變數之資料結構
			xmlDom		: XML資料結構
傳 回 值:	strReturn		: 若為空白,則表示完成.否則傳回錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean createNodeText( DataClass objThisData , Node nodeInput )
{
	boolean bReturn = true;
	String strStep = new String("0");

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":createNodeText()","Enter");
	if( nodeInput.getChildNodes().getLength() != 0 )
	{
		for(int i=0;i< nodeInput.getChildNodes().getLength();i++)
		{
			Node nodeTmp = nodeInput.getChildNodes().item(i);
			if( nodeTmp.getNodeType() == Node.ELEMENT_NODE )
			{
				if( nodeTmp.getFirstChild() == null )
				{
					org.w3c.dom.Text textTmp = nodeInput.getOwnerDocument().createTextNode("");
					nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
				}
				else
					createNodeText( objThisData , nodeTmp );
			}
		}
	}
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":createNodeText()","Exit");
	return bReturn;
}



%>
<%@ include file="../Logon/CheckLogon.inc" %>
<%	//Server端程式由此正式開始
	//本程式主要之變數
	boolean bCallBySelf = false;						//是否為自行呼叫
	String strClientMsg = new String("");				//傳回給Client之訊息
	boolean bReturnStatus = true;						//各函數執行之結果
    //R00393  Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();		//目前日期時間
//R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass(siThisSessionInfo);	//本程式主要各欄位資料
	
	objThisData.strUserId = siThisSessionInfo.getUserInfo().getUserId();

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
	//_jspx_cleared_due_to_forward = true;
%>
<%
	/* 
		按照功能處理資料
		1.自request物件中將client傳回之資料載入程式
		2.檢核資料正確性,若有發現任何錯誤,則將錯誤訊息放入strClientMsg中
		3.按照A,U,D,I之功能別,進行資料庫更新
	*/
	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");

	//將前端傳來之資料轉為 Document 物件
	Document xmlDom = null;
	org.apache.xerces.parsers.DOMParser parser = new org.apache.xerces.parsers.DOMParser();

	try
	{	
//		java.io.Reader reader = loadXML( request , objThisData );
//		org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource( reader );
		org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource( new InputStreamReader(request.getInputStream(),"UTF-8") );
		parser.parse( inputSource );
	}
	catch( Exception ex )
	{
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":service()","loadXML Exception : "+ex.getMessage());
	}


	xmlDom = parser.getDocument();

	validDom( objThisData , xmlDom );

	
	//先取得資料庫連線
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	else if( !getInputParameter( xmlDom , objThisData) )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	else
	{
		//若是新增動作時,先檢核各欄為是否輸入正確,若正確,則寫資料庫
		if( objThisData.strAction.equalsIgnoreCase("A") )	//新增
		{//先檢查所有欄位是否正確
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing add function");
			if( !checkFieldsServer( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
			else
			{
				if( !insertDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				else
				{
					strClientMsg = "'"+objThisData.strUserId+"'新增完成";
					siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction,"Q = '"+objThisData.strSecretWordQuestion+"' <BR> A = '"+objThisData.strSecretWordAnswer+"'");
				}
			}
		}
		//若是修改動作時,先檢核各欄為是否輸入正確,若正確,則寫資料庫
		if( objThisData.strAction.equalsIgnoreCase("U"))	//修改
		{//先檢查所有欄位是否正確
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing update function");
			if( !checkFieldsServer( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
			else
			{
				if( !updateDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				else
				{
					strClientMsg = ""+objThisData.strUserId+"修改完成";
					siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction,"Q = '"+objThisData.strSecretWordQuestion+"' <BR> A = '"+objThisData.strSecretWordAnswer+"'");
				}
			}
		}
		else if( objThisData.strAction.equalsIgnoreCase("D") )	//刪除
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing delete function");
			if( !deleteDb( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
			else
				strClientMsg = "'"+objThisData.strUserId+"'刪除完成";
		}
		else if( objThisData.strAction.equalsIgnoreCase("I") )	//查詢
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing inquiry function");
			if( !inquiryDb( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
		}
	}
	moveToXML( objThisData , xmlDom );
	org.w3c.dom.Node nodeTmp = null ;
	org.w3c.dom.Text textTmp = null ;
	if( xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild() == null)
	{
		nodeTmp = xmlDom.getElementsByTagName("txtMsg").item(0);
		textTmp = xmlDom.createTextNode("");
		nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
	}
	xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild().setNodeValue( strClientMsg );
	XMLSerializer ser = new XMLSerializer(out, new OutputFormat("xml","BIG5",true) );
	ser.serialize( xmlDom );
	objThisData.releaseConnection();
%>