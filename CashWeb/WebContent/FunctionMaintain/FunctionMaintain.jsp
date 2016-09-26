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
		NsSessionInfo siThisSessionInfo
		NsUserInfo    uiThisUserInfo
-->
<%!

	String strThisProgId = new String("FunctionMaintain");		//本程式代號
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	public final String DEFAULT_GROUP = "select default group";
	class DataClass extends Object 
	{
		public String strFuncId    = new String("");
		public String strFuncName  = new String("");
		public String strColorName = new String("");
		public String strRemark    = new String("");
		public String strProperty  = new String("P");	
		public String strUrl       = new String("");				
		public String strTargetWindow = new String("arena");	
		public String strMenuOn    = new String("");	
		public String strMenuOff   = new String("");	
		public String strTopBar    = new String("");	
		public String strTopBarExt = new String("");	
		public String strSwoosh    = new String("");
		public Vector vFuncId      = new Vector();
		public Vector vFunction    = new Vector();
		public String strDefaultGroup = new String("");			
		public SessionInfo siThisSessionInfo = null;	
		public String strActionCode= new String("");	
				
		//資料庫連結變數
		public Connection conDb = null;					//db_basic之jdbc connection
		
		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
		}

		//destructor
		public void finalize()
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":finalize()","Destructor enter");
			releaseConnection();
		}

		//自 NsDbFactory 中取得一個 Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("FunctionMaintain.DataClass.getConnection()");
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
			strReturn = "insert into db_eservice..tfunction (func_id,func_name,image_file_on,"+
			"image_file_off,top_bar,top_bar_extend,swoosh,property,url,remark,target_window) values ('";
			strReturn = strReturn + strFuncId + "','" ;
			strReturn = strReturn + strFuncName + "','" ;
			strReturn = strReturn + strMenuOn + "','" ;
			strReturn = strReturn + strMenuOff + "','" ;
			strReturn = strReturn + strTopBar + "','" ;
			strReturn = strReturn + strTopBarExt + "','" ;
			strReturn = strReturn + strSwoosh + "','" ;
			strReturn = strReturn + strProperty + "','" ;
			strReturn = strReturn + strUrl + "','" ;
			strReturn = strReturn + strRemark + "','" ;
			strReturn = strReturn + strTargetWindow + "')" ;
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInsertSql()","The insert sql is '"+strReturn+"'");
			return strReturn;
		}

		//取得本程式的 Update SQL
		public String getUpdateSql()
		{	
			String strReturn = new  String("");
			strReturn = "update db_eservice..tfunction set ";
			strReturn = strReturn + " func_id = '"+strFuncId + "'," ;
			strReturn = strReturn + " func_name = '"+strFuncName + "'," ;
			strReturn = strReturn + " image_file_on = '"+strMenuOn + "'," ;
			strReturn = strReturn + " image_file_off = '"+strMenuOff + "'," ;
			strReturn = strReturn + " top_bar = '"+strTopBar + "'," ;
			strReturn = strReturn + " top_bar_extend = '"+strTopBarExt + "'," ;
			strReturn = strReturn + " swoosh = '"+strSwoosh + "'," ;
			strReturn = strReturn + " property = '"+strProperty + "'," ;
			strReturn = strReturn + " url = '"+strUrl + "'," ;
			strReturn = strReturn + " remark = '"+strRemark + "'," ;
			strReturn = strReturn + " target_window = '"+strTargetWindow + "' " ;
			strReturn = strReturn + " where func_id = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getUpdateSql()","The update sql is '"+strReturn+"'");
			return strReturn;
		}

		//取得本程式的 Delete SQL
		public String getDeleteSql()
		{	
			String strReturn = new  String("");
			strReturn = "delete db_eservice..tfunction where func_id = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}


		//取得本程式的 Inquiry SQL
		public String getInquirySql()
		{	
			String strReturn = new  String("");
			strReturn = "select a.func_id, a.func_name, a.property, a.target_window, a.url, a.remark, b.color_name"+
				     " from db_eservice..tfunction a, db_eservice..tmenu_color b  where a.func_id = '"+strFuncId+"'"+
				     "	and a.image_file_on*=b.menuitem_on"; 
			//strReturn = "select * from db_eservice..tfunction where func_id = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}
		
		// Report SQL
		public String getReportSql()
		{
			String strReturn = new String("");
			strReturn = "select func_id, func_name,property,target_window from db_eservice..tfunction ";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getReportSql()","The Report1 sql is '"+strReturn+"'");
			return strReturn;
		}
		
		//tmenu_color details
		public String getColorDetailsSql()
		{
			String strReturn = new String();
			strReturn = "select * from db_eservice..tmenu_color where color_name = '"+strColorName+"' ";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getColorDetailsSql()","The Report1 sql is '"+strReturn+"'");
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
	if( objThisData.strFuncId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","Please enter the function id");
		bReturnStatus = false;
	}

	if( objThisData.strUrl.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","請輸入 URL 內容");
		bReturnStatus = false;
	}

	/*try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery("select group_id from db_eservice..tgroup where group_id = '"+objThisData.strDefaultGroup+"'");
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
			
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
	//取得Client端之資料,存入DataClass中
	//首先將client端之功能鍵取得
	objThisData.strActionCode = req.getParameter("btnAction");
	if( objThisData.strActionCode == null )
		objThisData.strActionCode = "";	

	objThisData.strFuncId = req.getParameter("txtFuncId");
	if( objThisData.strFuncId == null )
		objThisData.strFuncId = "";	

	objThisData.strFuncName = req.getParameter("txtFuncName");
	if( objThisData.strFuncName == null )
		objThisData.strFuncName = "";
	//中文欄位必須使用getBytes("Big5")才會正確,否則會變成亂碼
	try
	{	
		objThisData.strFuncName = new String( objThisData.strFuncName.getBytes("Big5") );
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
	}

	objThisData.strColorName = req.getParameter("cmbColorName");
	if( objThisData.strColorName == null )
		objThisData.strColorName = "";	

	objThisData.strProperty = req.getParameter("radProperty");
	if( objThisData.strProperty == null )
		objThisData.strProperty = "";
	else{
		if(objThisData.strProperty.equals("M"))
			objThisData.strColorName = "deepblue_m";
	}	
	objThisData.strUrl = req.getParameter("txtUrl");
	if( objThisData.strUrl == null )
		objThisData.strUrl = "";	

	objThisData.strTargetWindow = req.getParameter("cmbTargetWindow");
	if( objThisData.strTargetWindow == null )
		objThisData.strTargetWindow = "";	

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
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","使用者代號 '"+objThisData.strFuncId+"' 已存在於資料庫中");
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
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","使用者代號 '"+objThisData.strFuncId+"' 未存在於資料庫中");
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
			if( rstResultSet.getString("func_id") != null )
				objThisData.strFuncId = rstResultSet.getString("func_id").trim();
			else
				objThisData.strFuncId = new String("");
			if( rstResultSet.getString("func_name") != null )
				objThisData.strFuncName = rstResultSet.getString("func_name").trim();
			else
				objThisData.strFuncName = new String("");
			if( rstResultSet.getString("remark") != null )
				objThisData.strRemark = rstResultSet.getString("remark").trim();
			else
				objThisData.strRemark = new String("");
			if( rstResultSet.getString("property") != null)
				objThisData.strProperty = rstResultSet.getString("property").trim();
			else
				objThisData.strProperty = new String("");
			if( rstResultSet.getString("url") != null )
				objThisData.strUrl = rstResultSet.getString("url");
			else
				objThisData.strUrl = new String("");
			if( rstResultSet.getString("color_name") != null )
				objThisData.strColorName = rstResultSet.getString("color_name");
			else
				objThisData.strColorName = new String("");
			if( rstResultSet.getString("target_window") != null )
				objThisData.strTargetWindow = rstResultSet.getString("target_window");
			else
				objThisData.strTargetWindow = new String("");

		}
		else
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","使用者代號 '"+objThisData.strFuncId+"' 未存在於資料庫中");
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
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","使用者代號 '"+objThisData.strFuncId+"' 未存在於資料庫中");
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
			if( rstResultSet.getString("func_id") != null )
				objThisData.vFuncId.addElement(rstResultSet.getString("func_id").trim());
			else
				objThisData.vFuncId.addElement("");
			if( rstResultSet.getString("func_name") != null )
				objThisData.vFuncId.addElement(rstResultSet.getString("func_name").trim());
			else
				objThisData.vFuncId.addElement("");

			if( rstResultSet.getString("property") != null )
				objThisData.vFuncId.addElement(rstResultSet.getString("property").trim());
			else
				objThisData.vFuncId.addElement("");

			if( rstResultSet.getString("target_window") != null )
				objThisData.vFuncId.addElement(rstResultSet.getString("target_window").trim());
			else
				objThisData.vFuncId.addElement("");

			objThisData.vFunction.addElement(objThisData.vFuncId);
			objThisData.vFuncId = new Vector();
		}
		objThisData.strFuncId    = "";
 		objThisData.strFuncName  = "";
		objThisData.strColorName = "";
		objThisData.strUrl       = "";
		objThisData.strRemark    = "";
		objThisData.strTargetWindow = "";
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

//to get the top bar,swoosh,menu item details corresponding to the color selected by the user.

public boolean selectDbColorDetails(DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInquiry = null;		
	String strSelectSql = new String("");	
	ResultSet rstResultSet = null;		
	int iReturn = 0;
		
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDbColorDetails()","Enter");
	try
	{
		strSelectSql = objThisData.getColorDetailsSql();
		stmInquiry = objThisData.conDb.createStatement();
		rstResultSet = stmInquiry.executeQuery(strSelectSql);
		while(rstResultSet.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDbColorDetails()","Fetched records successfully");
			if( rstResultSet.getString("menuitem_on") != null )
				objThisData.strMenuOn = rstResultSet.getString("menuitem_on").trim();
			else
				objThisData.strMenuOn = new String("");
			if( rstResultSet.getString("menuitem_off") != null )
				objThisData.strMenuOff = rstResultSet.getString("menuitem_off").trim();
			else
				objThisData.strMenuOff = new String("");

			if( rstResultSet.getString("top_bar") != null )
				objThisData.strTopBar = rstResultSet.getString("top_bar").trim();
			else
				objThisData.strTopBar = new String("");

			if( rstResultSet.getString("top_bar_extend") != null )
				objThisData.strTopBarExt = rstResultSet.getString("top_bar_extend").trim();
			else
				objThisData.strTopBarExt = new String("");

			if( rstResultSet.getString("swoosh_bar") != null )
				objThisData.strSwoosh = rstResultSet.getString("swoosh_bar").trim();
			else
				objThisData.strSwoosh = new String("");
		}
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":selectDbColorDetails()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDbColorDetails()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDbColorDetails()","Exit with status false");
	return bReturnStatus;
}

//for displaying the available colors to the user

public String getColorList(DataClass objThisData )
{
	String strReturnHtml = new String("<SELECT name=\"cmbColorName\" id=\"cmbColorName\" size=\"1\"><OPTION value=\"\"></OPTION>\r\n");					// return html string
	Statement stmStatement = null;				//temperory statement
	ResultSet rstResultSet = null;				//temperory Resultset
	String strSql = new String("select distinct color_name from db_eservice..tmenu_color ");

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SelectInput.jsp:getColorList()","Enter the sql = '"+strSql+"'");
	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery(strSql);
		while( rstResultSet.next() )
		{
			if(rstResultSet.getString("color_name") != null )
			{
				strReturnHtml += "<OPTION value=\""+rstResultSet.getString("color_name")+"\"";
				if( rstResultSet.getString("color_name").trim().equals(objThisData.strColorName.trim()) )
					strReturnHtml += " selected ";
				strReturnHtml += ">"+rstResultSet.getString("color_name")+" </OPTION>\r\n";
			}
		}
		strReturnHtml += "</SELECT>";
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getColorList()",e);
	}
//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SelectInput.jsp:getColorList()","The actual return html = '"+strReturnHtml+"'");
	return strReturnHtml;
}

//for displaying the available target windows to the user

public String getTargetWindowList(DataClass objThisData )
{
	String strReturnHtml = new String("<SELECT name=\"cmbTargetWindow\" id=\"cmbTargetWindow\" size=\"1\"><OPTION value=\"\"></OPTION>\r\n");					// return html string
	Statement stmStatement = null;				//temperory statement
	ResultSet rstResultSet = null;				//temperory Resultset
	String strSql = new String("select distinct target_window from db_eservice..tfunction ");

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SelectInput.jsp:getTargetWindowList()","Enter the sql = '"+strSql+"'");
	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery(strSql);
		while( rstResultSet.next() )
		{
			if(rstResultSet.getString("target_window") != null )
			{
				strReturnHtml += "<OPTION value=\""+rstResultSet.getString("target_window")+"\"";
				if( rstResultSet.getString("target_window").trim().equals(objThisData.strTargetWindow.trim()) )
					strReturnHtml += " selected ";
				strReturnHtml += ">"+rstResultSet.getString("target_window")+" </OPTION>\r\n";
			}
		}
		strReturnHtml += "</SELECT>";
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getTargetWindowList()",e);
	}
//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SelectInput.jsp:getTargetWindowList()","The actual return html = '"+strReturnHtml+"'");
	return strReturnHtml;
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
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the user_id is '"+objThisData.strFuncId+"'");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstUser = stmInquiry.executeQuery(strInquirySql);
		if( !rstUser.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strFuncId+"' does not exist in the database");
			bReturnStatus = false;
		}
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strFuncId+"' exists in the database");
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
	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();		//目前日期時間
     //R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass(siThisSessionInfo);	//本程式主要各欄位資料

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
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
					if(!selectDbColorDetails(objThisData ))
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
							strClientMsg = "'"+objThisData.strFuncId+"'新增完成";
						}
						catch( Exception e )
						{
						}
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
					if(!selectDbColorDetails(objThisData ))
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
							strClientMsg = "'"+objThisData.strFuncId+"'修改完成";
						}
						catch( Exception e )
						{
						}
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
							strClientMsg = "'"+objThisData.strFuncId+"'刪除完成";
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
							strClientMsg = "'"+objThisData.strFuncId+"'刪除完成";
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
<TITLE>功能資料檔維護</TITLE>
<SCRIPT language="JavaScript" >
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

var strErrMsg = "";	
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
						L: Reports
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
		{
			alert(strErrMsg);
		}
			
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
			if( checkFieldsClient( document.getElementById("txtFuncId"),true ) )
				document.getElementById("MainForm").submit();
		}
	}
	else if( strButtonTag == "I" )		//查詢鈕
	{
		document.getElementById("btnAction").value = "I";
		document.getElementById("txtThisProgId").value = "COMTFunctionMaintain";
		if( checkFieldsClient( document.getElementById("txtFuncId"),true ) )
			{
				document.getElementById("MainForm").submit();
			}
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
	if( document.getElementsByTagName("SELECT") != null)
	{
		var m=0;
		var collm = document.getElementsByTagName("SELECT");
		for(m=0;m<collm.length;m++)
		{
			if( !checkCombo(collm[m],false) )
			{
				bReturnStatus = false;
			}
		}
	}
	return bReturnStatus;
}

function checkCombo(objThisItem,bShowMsg)
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	//objThisItem.value = objThisItem.options[objThisItem.selectedIndex].value;
		
	if(objThisItem.name == "cmbTargetWindow" )
	{
		if(objThisItem.value == "")
		{
			//strTmpMsg   = "Hello ! Please select a target window ";
			strTmpMsg   = "請輸入 TARGET WINDOW";
			bReturnStatus = false;
		}
	}
	if(objThisItem.name == "cmbColorName" )
	{
		if(objThisItem.value == "")
		{
			//strTmpMsg   = "Hello ! Please select a color ";
			strTmpMsg   = "請輸入色系";
			bReturnStatus = false;
		}
	}
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
	if( objThisItem.name == "txtFuncId" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "請輸入功能代號";
			//strTmpMsg   = "Hello ! Please fill the Func Id ";
			bReturnStatus = false;
		}
	}
	else if( objThisItem.name == "txtFuncName" )
	{
		if( objThisItem.value == "")
		{
			strTmpMsg = "請輸入功能名稱";
			//strTmpMsg = "Hello ! please fill the Func Name ";
			bReturnStatus = false;
		}
	}
	else if( objThisItem.name == "txtUrl" )
	{
		//if(document.getElementById("radProperty").value != "M")
		//{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "請輸入 URL 內容";
				bReturnStatus = false;
			}
		//}			
	}
	
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
function disablecolor()
{
	document.getElementById("radProperty").value = "M";
	document.getElementById("cmbColorName").value = "deepblue_m";
	document.getElementById("cmbColorName").disabled = true;	
	//document.getElementById("cmbTargetWindow").disabled = true;
	//document.getElementById("txtUrl").value = "";
	//document.getElementById("txtUrl").disabled = true;
}
function enablecolor()
{	
	document.getElementById("cmbColorName").disabled = false;
	document.getElementById("cmbTargetWindow").disabled = false;	
	document.getElementById("txtUrl").disabled = false;
}
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" VI6.0THEME="Global Marketing">
</HEAD>
<BODY style="margin:0px" onload="OnLoad(document.title,'<%=strThisProgId%>',strFunctionKey,'txtProgramId')">
<FORM id="MainForm" name="MainForm" method="post" action="FunctionMaintain.jsp">
<CENTER>
 <table border="1" width="600">   
    <tbody>   
      <tr>   
        <td width="150" ><b>功能代號：</b></td>    
        <td width="450" colspan="3"><input maxLength="20" type="text" name="txtFuncId" id="txtFuncId" value="<%=objThisData.strFuncId%>" onchange="checkFieldsClient(this,true);" size="20">    
        </td>    
      </tr>    
      <tr>    
        <td width="150" ><b>功能名稱：</b></td>    
        <td width="450" colspan="3"><input maxLength="20" type="text" name="txtFuncName" id="txtFuncName" value="<%=objThisData.strFuncName%>" onchange="checkFieldsClient(this,true);" size="20">
	</td>    
      </tr>    
      <tr>  
        <td width="150" ><b>屬性：</b></td>   
        <td width="150" ><input  id="radProperty" name="radProperty" <%if( objThisData.strProperty.equalsIgnoreCase("P") ) out.print("checked");%> onblur="checkFieldsClient(this,true);" type="radio" value="P" onclick="enablecolor();">Program   
          <input id="radProperty" name="radProperty" <%if( objThisData.strProperty.equalsIgnoreCase("M") ) out.print("checked");%> onblur="checkFieldsClient(this,true);" type="radio" value="M" onclick="disablecolor();">Menu</td>      
        <td width="150" ><b>Target Window:</b></td>     
        <td width="150" ><%=getTargetWindowList(objThisData)%></td>     
      </tr>     
      <tr>     
        <td width="150" ><b>Url:</b></td>      
        <td width="450"  colspan="3"><input maxLength="255" type="text" id="txtUrl" name="txtUrl" value="<%=objThisData.strUrl%>" onchange="checkFieldsClient(this,true);" size="70" >        
        </td>      
      </tr>     
      <tr>     
        <td width="150" ><b>備註：</b></td>     
        <td width="450" colspan="3"><input maxLength="70" type="text" id="txtRemark" name="txtRemark" value="<%=objThisData.strRemark%>" onblur="checkFieldsClient(this,true);" size="70" >       
        </td>     
      </tr>    
    </tbody>    
  </table>    
<table border="0" cellPadding="0" cellSpacing="0" width="580">   
  <tbody>   
    <tr>   
        <td align="middle" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" width="120">   
        <div align="left">   
          <strong><font color="#000000" face="MingLiu" size="2">&nbsp;</font><font color="#000000" size="2">功能代號</font><font color="#000000" face="MingLiu" size="2">&nbsp;&nbsp;</font></strong>   
        </div>   
      </td>   
      <td align="left" bgColor="#c0c0c0" colSpan="2" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="130"><b><font color="#000000" face="MingLiu" size="2">&nbsp;&nbsp;&nbsp;  
        </font><font color="#000000" size="2">功能名稱</font><font color="#000000" face="MingLiu" size="2">&nbsp;</font></b></td>   
      <td bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="100"><b><font size="2">&nbsp;&nbsp;    
        屬性</font></b></td>    
      <td align="right" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="120"><b><font size="2">Target Window</font></b></td>    
      <td align="right" bgColor="#c0c0c0" height="20" style="border-right: 1px solid black; border-top: 1px solid black; border-bottom: 1px solid black" width="50">&nbsp;</td> 
    </tr> 
  </tbody> 
</table> 
&nbsp;<textarea rows="10" name="S1" cols="80" readonly>
<%
	for(int i=0;i<objThisData.vFunction.size();i++)
	{	
		objThisData.vFuncId = (Vector)objThisData.vFunction.elementAt(i);
		out.println(objThisData.vFuncId.elementAt(0)+"     "+objThisData.vFuncId.elementAt(1)+"              "+objThisData.vFuncId.elementAt(2)+"             "+objThisData.vFuncId.elementAt(3));		
       }
%>
</textarea>
</CENTER>
<INPUT name="txtThisProgId" id="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
<INPUT name="btnAction"  id="btnAction" type="hidden" value="<%=objThisData.strActionCode%>">
<INPUT name="txtClientMsg"  type="hidden" value="<%= strClientMsg %>">
<INPUT name="txtDebug"  type="hidden" value="0">
</FORM>
</BODY>
</HTML>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>
