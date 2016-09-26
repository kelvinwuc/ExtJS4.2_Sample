<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393      Leo Huang    			2010/09/20           現在時間取Capsil營運時間
 *  =============================================================================
 */
%>
<%@ page contentType="text/html;charset=BIG5" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.aegon.servlet.*" %>
<%@ include file="../Logon/CheckLogon.inc" %>
<!--
	經過 CheckLogon.jsp 之處理後,每一支程式都會有 
		SessionInfo siThisSessionInfo
		UserInfo    uiThisUserInfo
-->
<%!

	String strThisProgId = new String("GroupMaintain");		//本程式代號
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
    Calendar cldCalendar = null;
    CommonUtil commonUtil =null;
//R00393  Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	public final String DEFAULT_GROUP = "select default group";
	class DataClass extends Object 
	{
		public String strGroupId = new String("");
		public String strDefUserId = new String("");
		public String strGroupName = new String("");
		public String strRemark = new String("");
		public String strUpdateId = new String("");	
		public String strCreateDate = new String("");				
		public String strAllGroupIds = new String("");			
		public String strAllGroupNames = new String("");
		public Vector vGroupId    = new Vector();
		public Vector vGroupName  = new Vector();			
		public String strDefaultGroup = new String("");			
		public SessionInfo siThisSessionInfo = null;	
		public String strActionCode = new String("");	
		public java.util.Date dteStartDate = cldCalendar.getTime();			
		
		public String szSysFlag = new String("");
		//資料庫連結變數
		public Connection conDb = null;					//jdbc connection
		
		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			//R00393   Edit by Leo Huang (EASONTECH) Start
			commonUtil = new CommonUtil(siSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());
			cldCalendar = commonUtil.getBizDateByRCalendar();
			//R00393  Edit by Leo Huang (EASONTECH) End
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
			
		}

		//destructor
		public void finalize()
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":finalize()","Destructor enter");
			releaseConnection();
		}

		//自 DbFactory 中取得一個 Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("GroupMaintain.DataClass.getConnection()");
			if( conDb == null )
				bReturnStatus = false;
			if( bReturnStatus )
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getConnection()","getConnection O.K.");
			else
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":getConnection()","siThisSessionInfo.getUserInfo().getDbFactory().getConnection() return null error!!");

			return bReturnStatus;
		}

		public void releaseConnection()
		{
			if( conDb != null )
				siThisSessionInfo.getUserInfo().getDbFactory().releaseConnection(conDb);
			conDb = null;
		}


		//取得本程式的 Insert SQL
		public String getInsertSql()
		{	
			String strReturn = new  String("");
			strReturn = "insert into tgroup (group_id,group_name,create_date,update_user_id,remark) values ('";
			strReturn = strReturn + strGroupId + "','" ;
			strReturn = strReturn + strGroupName + "','" ;
			strReturn = strReturn + sdfDateFormatter.format(dteStartDate) + "','" ;
			strReturn = strReturn + strDefUserId + "','" ;
			strReturn = strReturn + strRemark + "')" ;
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInsertSql()","The insert sql is '"+strReturn+"'");
			return strReturn;
		}

		//取得本程式的 Update SQL
		public String getUpdateSql()
		{	
			String strReturn = new  String("");
			strReturn = "update tgroup set ";
			strReturn = strReturn + " group_id = '"+strGroupId + "'," ;
			strReturn = strReturn + " group_name = '"+strGroupName + "'," ;
			strReturn = strReturn + " create_date = '"+sdfDateFormatter.format(dteStartDate)+ "'," ;
			strReturn = strReturn + " update_user_id = '"+strDefUserId + "'," ;
			strReturn = strReturn + " remark = '"+strRemark + "' " ;
			strReturn = strReturn + " where group_id = '"+strGroupId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getUpdateSql()","The update sql is '"+strReturn+"'");
			return strReturn;
		}

		//取得本程式的 Delete SQL
		public String getDeleteSql()
		{	
			String strReturn = new  String("");
			strReturn = "delete tgroup where group_id = '"+strGroupId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}


		//取得本程式的 Inquiry SQL
		public String getInquirySql()
		{	
			String strReturn = new  String("");
			strReturn = "select * from tgroup where group_id = '"+strGroupId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}
		
		// Report SQL
		public String getReportSql()
		{
			String strReturn = new String("");
			strReturn = "select group_id, group_name from tgroup ";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getReportSql()","The Report1 sql is '"+strReturn+"'");
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
	boolean bReturnStatus  = true;
	Statement stmStatement = null;
	ResultSet rstResultSet = null;
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Enter");
	if( objThisData.strGroupId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","請輸入專案代號");
		bReturnStatus = false;
	}

	/*if( objThisData.strProjectUrl.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","請輸入專案說明網頁網址");
		bReturnStatus = false;
	}

	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery("select group_id from tgroup where group_id = '"+objThisData.strDefaultGroup+"'");
		if( !rstResultSet.next() )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","預設群組'"+objThisData.strDefaultGroup+"'未存於存於群組檔中");
			bReturnStatus = false;
		}
		rstResultSet.close();
		stmStatement.close();
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()",e);
		bReturnStatus = false;
	}*/
	
	if( bReturnStatus )	
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status false");
	return bReturnStatus;
}
/**
函數名稱:	getInputParameter( HttpServletRequest req, DataCalss objThisData ) 
函數功能:	將Client端傳入之各欄位值存入objThisData中
傳入參數:	HttpServletRequest req: Client傳入之 request object
		DataClass objThisData : 本程式所有的欄位值
傳回值:	若有任一欄位錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean getInputParameter(HttpServletRequest req,DataClass objThisData)
{
	boolean bReturnStatus = true;
	CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());

	HttpSession userSession = req.getSession(false);
	objThisData.strDefUserId = (String)userSession.getAttribute("UserId");
	if( objThisData.strDefUserId == null )
		objThisData.strDefUserId = "";
			
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
	//取得Client端之資料,存入DataClass中
	//首先將client端之功能鍵取得
	objThisData.strActionCode = req.getParameter("btnAction");
	if( objThisData.strActionCode == null )
		objThisData.strActionCode = "";	

	objThisData.strGroupId = req.getParameter("txtGroupId");
	if( objThisData.strGroupId == null )
		objThisData.strGroupId = "";	
	objThisData.strGroupName = req.getParameter("txtGroupName");
	if( objThisData.strGroupName == null )
		objThisData.strGroupName = "";
	//中文欄位必須使用getBytes("Big5")才會正確,否則會變成亂碼
	try
	{	
		objThisData.strGroupName = new String( objThisData.strGroupName.getBytes("Big5") );
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
	}
	objThisData.strRemark = req.getParameter("txtRemark");
	if( objThisData.strRemark == null )
		objThisData.strRemark = "";	
	try
	{	
		objThisData.strRemark = new String( objThisData.strRemark.getBytes("Big5") );
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
	}

	objThisData.dteStartDate = commonUtil.convertROC2WestenDate(req.getParameter("txtCreateDate"));
	if( objThisData.dteStartDate== null )
		objThisData.dteStartDate = cldCalendar.getTime();	
	objThisData.strUpdateId = req.getParameter("txtUpdateId");
	if( objThisData.strUpdateId== null )
		objThisData.strUpdateId= "";	
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
	Statement stmInsert = null;	
	String strInsertSql = new String("");
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Enter");
	//顯檢查鍵值是否存在,如果存在則傳回錯誤訊息,否則將改筆資料新增至資料庫中
	if( isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","使用者代號 '"+objThisData.strGroupId+"' 已存在於資料庫中");
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
	Statement stmUpdate = null;
	String strUpdateSql = new String("");
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Enter");
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","使用者代號 '"+objThisData.strGroupId+"' 未存在於資料庫中");
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
	Statement stmInquiry = null;		
	String strInquirySql = new String("");	
	ResultSet rstResultSet = null;		
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
			if( rstResultSet.getString("group_id") != null )
				objThisData.strGroupId = rstResultSet.getString("group_id").trim();
			else
				objThisData.strGroupId = new String("");
			if( rstResultSet.getString("group_name") != null )
				objThisData.strGroupName = rstResultSet.getString("group_name").trim();
			else
				objThisData.strGroupName = new String("");
			if( rstResultSet.getString("remark") != null )
				objThisData.strRemark = rstResultSet.getString("remark").trim();
			else
				objThisData.strRemark = new String("");
			if( rstResultSet.getString("update_user_id") != null)
				objThisData.strUpdateId = rstResultSet.getString("update_user_id").trim();
			else
				objThisData.strUpdateId = new String("");
			if( rstResultSet.getDate("create_date") != null )
				objThisData.dteStartDate = rstResultSet.getDate("create_date");
			else
				objThisData.dteStartDate = null;
		}
		else
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","使用者代號 '"+objThisData.strGroupId+"' 未存在於資料庫中");
			bReturnStatus = false;
		}
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Exit with status false");
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
	Statement stmDelete = null;
	String strDeleteSql = new String("");
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Enter");
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","使用者代號 '"+objThisData.strGroupId+"' 未存在於資料庫中");
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
	return bReturnStatus;
}

public boolean selectDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInquiry = null;		
	String strReportSql = new String("");	
	ResultSet rstResultSet = null;		
	int iReturn = 0;
		
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDb()","Enter");
	try
	{
		strReportSql = objThisData.getReportSql();
		stmInquiry = objThisData.conDb.createStatement();
		rstResultSet = stmInquiry.executeQuery(strReportSql);
		while(rstResultSet.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDb()","Fetched records successfully");
			if( rstResultSet.getString("group_id") != null )
				objThisData.strAllGroupIds = rstResultSet.getString("group_id").trim();
			else
				objThisData.strAllGroupIds = new String("");
			if( rstResultSet.getString("group_name") != null )
				objThisData.strAllGroupNames = rstResultSet.getString("group_name").trim();
			else
				objThisData.strAllGroupNames = new String("");
			objThisData.vGroupId.addElement(objThisData.strAllGroupIds);
			objThisData.vGroupName.addElement(objThisData.strAllGroupNames);
		}
		
		objThisData.strGroupId    = "";
 		objThisData.strGroupName  = "";
		objThisData.strRemark     = "";
		objThisData.strUpdateId   = "";
		objThisData.strCreateDate = "";
		
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":selectDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDb()","Exit with status false");
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
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the user_id is '"+objThisData.strGroupId+"'");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstUser = stmInquiry.executeQuery(strInquirySql);
		if( !rstUser.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strGroupId+"' does not exist in the database");
			bReturnStatus = false;
		}
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strGroupId+"' exists in the database");
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

%>
<%
	//the main program begins...
	//Server端程式由此正式開始
	//本程式主要之變數
	boolean bCallBySelf = false;						//是否為自行呼叫
	String strClientMsg = new String("");				//傳回給Client之訊息
	boolean bReturnStatus = true;						//各函數執行之結果
	
	//R00393   Edit by Leo Huang (EASONTECH) Start
	//CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());

	//java.util.Date dteToday = cldCalendar.getTime();		//目前日期時間

	//DataClass objThisData = new DataClass(siThisSessionInfo);	//本程式主要各欄位資料
	
	DataClass objThisData = new DataClass(siThisSessionInfo);	//本程式主要各欄位資料
	if(commonUtil==null){
		commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
		cldCalendar = commonUtil.getBizDateByRCalendar();
	}
	
	//R00393  Edit by Leo Huang (EASONTECH) End
	HttpSession userSession = request.getSession(false);
	objThisData.szSysFlag = (String)userSession.getAttribute("SYSTEM_FLAG");

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
%>
<%
	//先取得資料庫連線
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	//檢查是否為本程式自行呼叫
	if( request.getParameter("txtThisProgId") != null )
	{	
		if(request.getParameter("txtThisProgId").equalsIgnoreCase(strThisProgId))
			bCallBySelf = true;
	}

	/* 
		若是自行呼叫,則要按照功能處理資料
		1.自request物件中將client傳回之資料載入程式
		2.檢核資料正確性,若有發現任何錯誤,則將錯誤訊息放入strClientMsg中
		3.按照A,U,D,I之功能別,進行資料庫更新
	*/
	if( bCallBySelf )
	{
		if( !getInputParameter(request,objThisData) )
		{
			strClientMsg = siThisSessionInfo.getLastErrorMessage();
		}
		else
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Client request function is '"+objThisData.strActionCode+"'");
			//若是新增動作時,先檢核各欄為是否輸入正確,若正確,則寫資料庫
			if( objThisData.strActionCode.equalsIgnoreCase("A") )	//新增
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
						try
						{
							strClientMsg = "'"+objThisData.strGroupId+"'新增完成";
						}
						catch( Exception e )
						{
						}
					}
				}
			}
			//若是修改動作時,先檢核各欄為是否輸入正確,若正確,則寫資料庫
			if( objThisData.strActionCode.equalsIgnoreCase("U"))	//修改
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
						try
						{
							strClientMsg = "'"+objThisData.strGroupId+"'修改完成";
						}
						catch( Exception e )
						{
						}
					}
				}
			}
			else if( objThisData.strActionCode.equalsIgnoreCase("D") )	//刪除
			{
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing delete function");
				if( !deleteDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				else
				{
						try
						{
							strClientMsg = "'"+objThisData.strGroupId+"'刪除完成";
						}
						catch( Exception e )
						{
						}
				}
			}
			else if( objThisData.strActionCode.equalsIgnoreCase("I") )	//查詢
			{
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing inquiry function");
				if( !inquiryDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
			}
			else if( objThisData.strActionCode.equalsIgnoreCase("L") )	//For the reports
			{
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing report function");
				if( !selectDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				/*else
				{
						try
						{
							strClientMsg = "'"+objThisData.strGroupId+"'刪除完成";
						}
						catch( Exception e )
						{
						}
				}*/
			}

		}
	}

	

%>
<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>群組資料維護</TITLE>
<SCRIPT language="JavaScript" >
var strErrMsg = "";				//Batch檢查之錯誤訊息,本變數可跨函數存在

/**
函數名稱:	OnLoad( String strTitle, String strProgId, strThisFunctionKey )
函數功能:	當Client端畫面啟動時,執行本函數.
		1.先在title frame顯示程式代號及程式名稱,程式代號及程式名稱要在<BODY>tag中修改
		2.若txtClientMsg欄位不為空白時, 表示有錯誤訊息,使用alert()顯示它
		3.在toolbar frame顯示功能鍵
傳入參數:	String strTitle: 程式名稱,置於title frame之中央,這個變數是使用本頁面之
					document.title,應修改本jsp之<TITLE>tag
		String strProgId:	程式代號,置於title frame之左側.變數來源為jsp之strThisProgId.
		String strThisFunctionKey: 要顯示的功能鍵代號,A:新增,U:修改,D:刪除,I:查詢,E:離開,R:清除
		String strFirstField: 輸入的第一個欄位
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
var oToolBar = "";
var oTitle = "";
var iToolBar = 0;
var iTitle = 0;
var iInterval = "";
function OnLoad(strTitle,strProgId,strThisFunctionKey,strFirstField)
{
	var i,j;
	if( window.parent.frames.length != 0 )
	{
		i = 0;
		while( i < window.parent.frames.length )
		{
			var winTarget = window.parent.frames[i];
			if( winTarget.name == 'title' )
			{
				iTitle = i;
				oTitle = window.setInterval("checkTitleWindowState('"+strTitle+"','"+strProgId+"')",100);
			}
			if( winTarget.name == 'toolbar' )
			{
				iToolBar = i;
				oToolBar = window.setInterval("checkToolBarWindowState('"+strThisFunctionKey+"')",100);
			}
			i++;
		} 
	}
	if( document.getElementById("txtClientMsg") != null )
		if( document.getElementById("txtClientMsg").value != "" )
			alert( document.getElementById("txtClientMsg").value );
	if( document.getElementById(strFirstField) != null )
		document.getElementById(strFirstField).focus();
			
}

function checkTitleWindowState(strTitle,strProgId)
{
	var winTarget = window.parent.frames[iTitle];
	if( winTarget.document.getElementById("MainBody") != null )
	{
		var strCommand = "ShowTitle('"+strTitle+"','"+strProgId+"')";
		winTarget.iInterval = winTarget.setInterval(strCommand,1);
		if( oTitle != "" )
		{
			window.clearInterval(oTitle);
			oTitle = "";
		}
	}
}

function checkToolBarWindowState(strThisFunctionKey)
{
	var winTarget = window.parent.frames[iToolBar];
	if( winTarget.document.getElementById("MainForm") != null )
	{
		var strCommand = "ShowButton('"+strThisFunctionKey+"')";
		winTarget.iInterval = winTarget.setInterval(strCommand,1);
		if( oToolBar != "")
		{
			window.clearInterval(oToolBar);
			oToolBar = "";
		}
	}
}

/**
函數名稱:	ToolBarClick( String strButtonTag )
函數功能:	當toolbar frame中任一按鈕click時,就會執行本函數.當執行本函數時會傳入一個字串,
		該字串代表toolbar frame中哪一個按鈕被click
		當新增,修改按鈕時,先執行全部欄位檢查,若有任一欄位錯誤時,
		就顯示全部錯誤訊息,若正確時則將bntAction設定為傳入之參數值,
		並執行MainForm.submit(),將輸入之欄位傳送至web server
		若為查詢及刪除時,僅檢查鍵值是否正確,若正確,則將bntAction設定為傳入之參數值,
		並執行MainForm.submit(),將輸入之欄位傳送至web server
		若為清除時,則將各欄位清空.
傳入參數:	String strButtonTag: 	A:新增按鈕
						U:修改按鈕
						D:刪除按鈕
						I:查詢按鈕
						R:清除按鈕
						L:Reports
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function ToolBarOnClick(strButtonTag)
{
	if( iInterval != "" )
	{
		window.clearInterval(iInterval);
		iInterval = "";
	}

	if( strButtonTag == "A" )			//新增鈕
	{
		document.getElementById("btnAction").value = "A";
		if( areAllFieldsOK() )
			document.getElementById("MainForm").submit();
		else
			alert(strErrMsg);
	}
	else if( strButtonTag == "U" )		//修改鈕
	{
		document.getElementById("btnAction").value = "U";
		if( areAllFieldsOK() )
			document.getElementById("MainForm").submit();
		else
			alert(strErrMsg);
	}
	else if( strButtonTag == "D" )		//刪除鈕
	{
		var bAnswer = confirm("是否確定要刪除該筆資料?");
		if( bAnswer )
		{
			document.getElementById("btnAction").value = "D";
			if( checkFieldsClient( document.getElementById("txtGroupId"),true ) )
				document.getElementById("MainForm").submit();
		}
	}
	else if( strButtonTag == "I" )		//查詢鈕
	{
		document.getElementById("btnAction").value = "I";
		if( checkFieldsClient( document.getElementById("txtGroupId"),true ) )
			document.getElementById("MainForm").submit();
	}
	else if( strButtonTag == "E" )		//離開鈕
	{
		document.getElementById("btnAction").value = "E";
	}
	else if( strButtonTag == "L" )		//離開鈕
	{
		document.getElementById("btnAction").value = "L";
		document.getElementById("MainForm").submit();
	}
	else if( strButtonTag == "R" )		//清除鈕
	{//無法直接使用forms.reset()
		if( document.getElementById("MainForm") != null )
		{
			var j=0;
			if( document.getElementsByTagName("INPUT") != null )
			{
				var k=0;
				var coll = document.getElementsByTagName("INPUT");
				for(k=0;k<coll.length;k++)
				{//僅將text及password之欄位清空
					if( coll[k].type == "text" || coll[k].type == "password")
						coll[k].value = "";
				}
			}
		}
	}
	else
	{//若有未處理的按鈕值,顯示錯誤訊息
		alert("The button flag = '"+strButtonTag+"' unhandled");
	}
}


/**
函數名稱:	areAllFieldsOk()
函數功能:	呼叫checkFieldsClient()檢核所有欄位是否輸入正確
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function areAllFieldsOK()
{
	var i=0;
	var bReturnStatus = true;
	strErrMsg = "";
	if( document.getElementsByTagName("INPUT") != null )
	{
		var k=0;
		var coll = document.getElementsByTagName("INPUT");
		for(k=0;k<coll.length;k++)
		{
			if( !checkFieldsClient(coll[k],false) )
			{
				bReturnStatus = false;
			}
		}
	}
	return bReturnStatus;
}

</SCRIPT>
<SCRIPT language=JavaScript >
var strFunctionKey="AUDIRL";		//toolbar frame 中要顯示的功能鍵,會按照排列順序出現
							//A:新增,U:修改,D:刪除,I:查詢,E:離開,R:清除
/**
函數名稱:	checkFieldsClient(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
		bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkFieldsClient(objThisItem,bShowMsg)
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtGroupId" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "請輸入群組代號";
			//strTmpMsg   = "Hello ! Please fill the Group Id ";
			bReturnStatus = false;
		}
	}
	else if( objThisItem.name == "txtGroupName" )
	{
		if( objThisItem.value.length < 1)
		{
			strTmpMsg = "請輸入群組名稱";
			//strTmpMsg = "Hello ! Please fill the Group Name ";
			bReturnStatus = false;
		}
	}
	/*else if( objThisItem.name == "txtRemark" )
	{
		if( objThisItem.value == "" )
		{
			//strTmpMsg = "請輸入專案說明";
			strTmpMsg   = "Hello ! Please fill the Remark ";
			bReturnStatus = false;
		}
	}*/
	/*else if( objThisItem.name == "txtUpdateId" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "請輸入專案說明網頁網址";
			bReturnStatus = false;
		}
		
	}*/
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
</SCRIPT>
</HEAD>
<BODY style="margin:0px" onload="OnLoad(document.title,'<%=strThisProgId%>',strFunctionKey,'txtProgramId')">
<FORM id="MainForm" name="MainForm" action="GroupMaintain.jsp">
<CENTER>
<TABLE border="1" width="600" height="100">
    <TBODY>
        <TR>
            <TD width="150">群組代號：</TD>
            <TD width="450" colspan="3"><FONT><INPUT size="10" type="text" maxlength="10" name="txtGroupId" id="txtGroupId" value="<%=objThisData.strGroupId%>" onchange="checkFieldsClient(this,true);"></FONT></TD>
            </TR>
        <TR>
            <TD width="150">群組名稱：</TD>
      <TD width="450" colspan="3"><INPUT size="30" type="text" maxlength="20" name="txtGroupName" value="<%=objThisData.strGroupName%>" onchange="checkFieldsClient(this,true);"></TD>
    </TR>
        <TR>
            <TD width="150">備註：</TD>
            <TD width="450" colspan="3"><INPUT size="60" type="text" maxlength="50" name="txtRemark" value="<%=objThisData.strRemark%>" onblur="checkFieldsClient(this,true);"></TD>
        </TR>
        <TR>
            <TD width="150">修改者代號 ：</TD>
            <TD width="150"><INPUT size="10" type="text" maxlength="10" name="txtUpdateId" value="<%=objThisData.strUpdateId%>" onblur="checkFieldsClient(this,true);" readonly></TD>
		<TD width="150">資料更新日期：</TD>
            <TD width="150"><INPUT size="10" type="text" maxlength="10" name="txtCreateDate" value="<%=commonUtil.convertWesten2ROCDate(objThisData.dteStartDate)%>" onblur="checkFieldsClient(this,true);" readonly></TD>

        </TR>
       
     </TBODY>
</TABLE>
<br>
<table border="0" align="middle" cellPadding="0" cellSpacing="0" height="20" width="580">    
  <tbody>    
    <tr>    
       <td align="middle" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" width="120">    
        <div align="left">    
          <strong>    
          <font color="#000000" face="MingLiu" size="2">&nbsp;</font><font color="#000000" size="2">群組代號</font>    
          </strong>    
        </div>    
      </td>    
      <td align="left" bgColor="#c0c0c0" colSpan="2" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="130"><b><font color="#000000" size="2">群組名稱</font></b></td>    
      <td bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="100">&nbsp;</td>    
      <td align="right" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="80">&nbsp;</td>    
      <td align="right" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid" width="120">&nbsp;</td>    
    </tr>    
  </tbody>    
</table>
&nbsp;<textarea rows="10" name="S1" cols="80" readonly>
<%
	for(int i=0;i<objThisData.vGroupId.size();i++)
	{
		out.println(objThisData.vGroupId.elementAt(i)+"        "+objThisData.vGroupName.elementAt(i));		
       }
%>
</textarea>
</CENTER>
<INPUT name="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
<INPUT name="btnAction" id="btnAction" type="hidden" value="<%=objThisData.strActionCode%>">
<INPUT name="txtClientMsg"  type="hidden" value="<%= strClientMsg %>">
<INPUT name="txtDebug"  type="hidden" value="0">
</FORM>
</BODY>
</HTML>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>
