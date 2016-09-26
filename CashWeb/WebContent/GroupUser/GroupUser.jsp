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

	String strThisProgId = new String("GroupUser");		//本程式代號
	public final String DEFAULT_GROUP = "select default group";
	class DataClass extends Object 
	{
		public String strGroupId = new String("");
		public String strUserId = new String("");
		public String strSeqNo  = new String("");
		public String strSystemFlag=new String("");
		public String strDefaultGroup = new String("");	
		public String strCallingUrl = new String("");	
		public String strAllGroupIds = new String("");	
		public SessionInfo siThisSessionInfo = null;	
		public String strActionCode = new String("");	
		public Vector vGroupIds = new Vector();
		//資料庫連結變數
	
		public Connection conDb = null;					//jdbc connection
		public String szSysFlag = new String("");
		
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
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("GroupUser.DataClass.getConnection()");
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

		// Delete SQL
		public String getDeleteSql()
		{	
			String strReturn = new  String("");
			strReturn = "delete tgroup_user where user_id = '"+strUserId+"'" ;
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}
	
	}

%>
<%!
/**
函數名稱:	getInputParameter( HttpServletRequest req, DataCalss objThisData ) 
函數功能:	將Client端傳入之各欄位值存入objThisData中
傳入參數:	HttpServletRequest req: Client傳入之 request object
		DataClass objThisData : 本程式所有的欄位值
傳回值:	若有任一欄位錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean getInputParameter(HttpServletRequest req,DataClass objThisData,HttpSession userSession)
{
	boolean bReturnStatus = true;
	CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
		
	objThisData.strActionCode = req.getParameter("btnAction");
	if( objThisData.strActionCode == null )
		objThisData.strActionCode = "";	

	objThisData.strUserId = req.getParameter("txtUserId");
	if( objThisData.strUserId == null )
	{
		objThisData.strUserId = (String)userSession.getAttribute("TheUserId");
		if( objThisData.strUserId == null )
			objThisData.strUserId = "";	
	}

	objThisData.strGroupId = req.getParameter("txtGroupId");
	if( objThisData.strGroupId == null )
		objThisData.strGroupId = "";	

	objThisData.strCallingUrl = req.getParameter("txtCallingUrl");
	if( objThisData.strCallingUrl == null )
	{
		objThisData.strCallingUrl = req.getHeader("referer");
		if( objThisData.strCallingUrl == null )
			objThisData.strCallingUrl = new String("");
	}

	objThisData.strAllGroupIds = req.getParameter("N0_lst");
	if( objThisData.strAllGroupIds == null )
		objThisData.strAllGroupIds = "";	

	StringTokenizer stGroupIds = new StringTokenizer(objThisData.strAllGroupIds,",");
	while(stGroupIds.hasMoreTokens()) {
		objThisData.vGroupIds.addElement(stGroupIds.nextToken());
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
	try
	{
		for(int i=0;i<objThisData.vGroupIds.size();i++)
		{
			String szSeq = new String("");
			szSeq = Integer.toString(i+1);
			if(szSeq.length()<2)	{
				szSeq = "0"+szSeq;
			}
			strInsertSql = "insert into tgroup_user (user_id, seq ,"+
						"group_id) values ('"+objThisData.strUserId+"','"+szSeq+"','"+objThisData.vGroupIds.elementAt(i)+"')";

			stmInsert = objThisData.conDb.createStatement();
			iReturn = stmInsert.executeUpdate(strInsertSql);
			if( iReturn != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","The insert sql return != 1 return = '"+String.valueOf(iReturn)+"'");
				bReturnStatus = false;
			}
		}
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Exit with status false");
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
	try
	{
		strDeleteSql = objThisData.getDeleteSql();
		stmDelete = objThisData.conDb.createStatement();
		iReturn = stmDelete.executeUpdate(strDeleteSql);
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","'"+String.valueOf(iReturn)+"' record deleted");
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Exit with status false");
	return bReturnStatus;
}

public String getCurrentGroupIdList(DataClass objThisData)
{
	String strReturnHtml = new String("<SELECT name=\"N0\" size=\"14\">");					
	Statement stmStatement = null;
	ResultSet rstResultSet = null;
	String strSql = new String("");
	strSql = new String("select a.group_id,b.group_name  from tgroup_user a,tgroup b where a.user_id = '"+objThisData.strUserId+"'"
					+" and a.group_id = b.group_id");

	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery(strSql);
		while( rstResultSet.next() )
		{		
			if(rstResultSet.getString("group_id") != null )
			{
				strReturnHtml += "<OPTION value=\""+rstResultSet.getString("group_id")+"\"";
				strReturnHtml += ">"+rstResultSet.getString("group_id")+", "+rstResultSet.getString("group_name")+" </OPTION>\r\n";
			}
		}
		strReturnHtml += "</SELECT>";
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError("getCurrentGroupIdList()",e);
	}
	return strReturnHtml;
}

public String getAvailableGroupIdList(DataClass objThisData)
{
	String strReturnHtml = new String("<SELECT name=\"W0\" size=\"14\">");					
	Statement stmStatement = null;
	ResultSet rstResultSet = null;

	String strSql = new String("");
	strSql = new String("select group_id,group_name from tgroup where group_id not in"+
				     " (select group_id from tgroup_user where user_id = '"+objThisData.strUserId+"')"+
				     " and group_id not in (select default_group from tuser_id where user_id = '"+objThisData.strUserId+"')");

	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery(strSql);
		while( rstResultSet.next() )
		{		
			if(rstResultSet.getString("group_id") != null )
			{
				strReturnHtml += "<OPTION value=\""+rstResultSet.getString("group_id")+"\"";
				strReturnHtml += ">"+rstResultSet.getString("group_id")+", "+rstResultSet.getString("group_name")+"</OPTION>\r\n";
			}
		}
		strReturnHtml += "</SELECT>";
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError("getAvailableGroupIdList()",e);
	}
	return strReturnHtml;
}
%>
<%
	HttpSession userSession = request.getSession(false); 
	//the main program begins...
	boolean bCallBySelf = false;						//是否為自行呼叫
	String strClientMsg = new String("");				//傳回給Client之訊息
	boolean bReturnStatus = true;						//各函數執行之結果
	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());

	DataClass objThisData = new DataClass(siThisSessionInfo);	//本程式主要各欄位資料
	objThisData.szSysFlag = (String)userSession.getAttribute("SYSTEM_FLAG");
	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");

%>
<%
	//先取得資料庫連線
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	if( !getInputParameter(request,objThisData,userSession) )
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
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Client request function is '"+objThisData.strActionCode+"'");
		if( objThisData.strActionCode.equalsIgnoreCase("S"))
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing add function");
			if( !deleteDb( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}else{				
				if( !insertDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				else
				{
					try
					{
						//strClientMsg = "'"+objThisData.strUserId+"' updated in tgroup_user";
						strClientMsg = "'"+objThisData.strUserId+"' 儲存完成";
					}catch( Exception e ){
					}
				}
			}
		}
		else if( objThisData.strActionCode.equalsIgnoreCase("E") )	
		{
			if( !objThisData.strCallingUrl.equals("") )
				response.sendRedirect(objThisData.strCallingUrl);
		}
	}

%>
<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5.3 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>群組使用者維護</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" VI6.0THEME="Global Marketing">
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
			if( winTarget.name == 'titleFrame' )
			{
				iTitle = i;
				oTitle = window.setInterval("checkTitleWindowState('"+strTitle+"','"+strProgId+"')",100);
			}
			if( winTarget.name == 'toolbarFrame' )
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
傳入參數:	String strButtonTag: 	E:Exit
						S:Save
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
	if( strButtonTag == "S" )	
	{
		document.getElementById("btnAction").value = "S";
		doSub(); 
		if( areAllFieldsOK() )
			document.getElementById("MainForm").submit();
		else
			alert(strErrMsg);
	}
	else if( strButtonTag == "E" )		
	{
		document.getElementById("btnAction").value = "E";
		location.replace("tGroupUserSelect.jsp");
		//document.forms("MainForm").submit();
	}
	else
	{
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
var strFunctionKey="E,S";		//toolbar frame 中要顯示的功能鍵,會按照排列順序出現
							//E:Exit, S:Save
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
			//strTmpMsg = "請輸入專案代號";
			strTmpMsg   = "Hello ! Please fill the Group Id ";
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

function moveModule(o_col, d_col) 
{
  o_sl = document.MainForm[o_col].selectedIndex;
  d_sl = document.MainForm[d_col].length;
  if (o_sl != -1 && document.MainForm[o_col].options[o_sl].value > "") {
    oText = document.MainForm[o_col].options[o_sl].text;
    oValue = document.MainForm[o_col].options[o_sl].value;
    document.MainForm[o_col].options[o_sl] = null;
    document.MainForm[d_col].options[d_sl] = new Option (oText, oValue, false, true);
  } else {
    //alert("Please select a group id first");
     alert("請先選擇一個群組代號");

  }
}  

function orderModule(down, col) 
{
  sl = document.MainForm[col].selectedIndex;
  if (sl != -1 && document.MainForm[col].options[sl].value > "") {
    oText = document.MainForm[col].options[sl].text;
    oValue = document.MainForm[col].options[sl].value;
    if (document.MainForm[col].options[sl].value > "" && sl > 0 && down == 0) {
      document.MainForm[col].options[sl].text = document.MainForm[col].options[sl-1].text;
      document.MainForm[col].options[sl].value = document.MainForm[col].options[sl-1].value;
      document.MainForm[col].options[sl-1].text = oText;
      document.MainForm[col].options[sl-1].value = oValue;
      document.MainForm[col].selectedIndex--;
    } else if (sl < document.MainForm[col].length-1 && document.MainForm[col].options[sl+1].value > "" && down == 1) {
      document.MainForm[col].options[sl].text = document.MainForm[col].options[sl+1].text;
      document.MainForm[col].options[sl].value = document.MainForm[col].options[sl+1].value;
      document.MainForm[col].options[sl+1].text = oText;
      document.MainForm[col].options[sl+1].value = oValue;
      document.MainForm[col].selectedIndex++;
    }
  } else {
    //alert("Please select a group id first");
    alert("請先選擇一個群組代號");
    }
}

function xMod(col) 
{
  req = "";
  sl = document.MainForm[col].selectedIndex;
  if (sl != -1 && document.MainForm[col].options[sl].value > "") {
    if (req.indexOf(document.MainForm[col].options[sl].value) > -1) {
      alert ("You may not delete a required corporate module.");
    } else {
      if (confirm("This will delete the selected module.")) {
        if (document.MainForm[col].options[sl].value!=".none") {
          if (document.MainForm[col].length==1) {
            document.MainForm[col].options[0].text="";
            document.MainForm[col].options[0].value=".none";
          } else {
            document.MainForm[col].options[sl]=null; 
          } 
        } else {
          //alert("Please select a group id first");
	    alert("請先選擇一個群組代號");
	}
      }
    }
  }
}

function doSub() 
{
  layout = "W0N0";
  for (i=0; i < layout.length; i++) {
    if (layout.substr(i,1) == 'N' || layout.substr(i,1) == 'W') {
      col = layout.substr(i,2); 
      document.MainForm[col + "_lst"].value = makeList(col);
	//alert(document.MainForm[col + "_lst"].value);
    }
  }
  return true;
}

function makeList(col) 
{
  val = "";
  for (j=0; j<document.MainForm[col].length; j++) {
    if (val > "") { val += ","; }
    if (document.MainForm[col].options[j].value > "") val += document.MainForm[col].options[j].value;
  } 
  return val;
}

function sub_layout(layout) {
  document.MainForm['.commit'][0].value="";
  document.MainForm['.layout'].value=layout;
  doSub();
  document.MainForm.submit();
}
</SCRIPT>
</HEAD>
<BODY style="margin:0px" onload="OnLoad(document.title,'<%=strThisProgId%>',strFunctionKey,'txtProgramId')">
<FORM id="MainForm" name="MainForm" action="GroupUser.jsp">
<CENTER>
<p><b>使用者代號: <%=objThisData.strUserId%></b></p>
<table border=0 cellpadding=0 cellspacing=0 width="80%"><tr><td bgcolor=#666666>
<table border=0 cellpadding=2 cellspacing=1 width="100%">
<tr><td bgcolor="ffffff" align=center valign=top width="75%">
<input type=hidden name="W0_lst">
            <TABLE border="0" cellspacing="0" cellpadding="2" width="100%">
<tr>
                  <TD bgcolor="#999999" align="center"><font face="Arial" size=-1><b>可供選擇的功能選項</b></font></TD>
                </tr>
<tr><td align=center><table border=0 cellspacing=2 cellpadding=0>
<tr><td rowspan=2><%= getAvailableGroupIdList(objThisData)%></td>
<td valign=top><a href="javascript:moveModule('W0','N0');"><img src="../images/misc/right.gif" width=16 height=16 border=0 alt="Right" vspace=2></a><br><a href="javascript:moveModule('N0','W0');"><img src="/webapp/NanShan/Aes/misc/left.gif" width=16 height=16 border=0 alt="Left" vspace=2></a></td></tr>
<tr><td valign=bottom><br><br></td></tr></table></td></tr></TABLE>
            </td>
<td bgcolor="eeeeee" align=center valign=top width="25%">
<input type=hidden name="N0_lst">
<table border=0 cellspacing=0 cellpadding=2 width="100%">
<tr><td bgcolor=#999999 align=center><font face="Arial" size=-1><b>目前選擇的功能選項</b></font></td></tr>
<tr><td align=center><table border=0 cellspacing=2 cellpadding=0>
<tr><td rowspan=2><%= getCurrentGroupIdList(objThisData)%></td>
<td valign=top><a href="javascript:orderModule(0,'N0');"><img src="../images/misc/up.gif" width=16 height=16 border=0 alt="Up" vspace=2></a><br>
<a href="javascript:orderModule(1,'N0');"><img src="../images/misc/down.gif" width=16 height=16 border=0 alt="Down" vspace=2></a></td></tr>
<tr><td valign=bottom><br><br></td></tr></table></td></tr></table></td></tr>
</table>
</td></tr></table>
</CENTER>
<INPUT name="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
<INPUT id=txtCallingUrl name=txtCallingUrl type=hidden value="<%=objThisData.strCallingUrl%>">
<INPUT name="btnAction" id="btnAction" type="hidden" value="<%=objThisData.strActionCode%>">
<INPUT name="txtClientMsg"  type="hidden" value="<%= strClientMsg %>">
<INPUT name="txtUserId"  type="hidden" value="<%=objThisData.strUserId%>">
<INPUT name="txtDebug"  type="hidden" value="0">
</FORM>
</BODY>
</HTML>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>
