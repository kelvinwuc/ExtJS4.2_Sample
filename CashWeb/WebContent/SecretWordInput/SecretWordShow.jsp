<%@ page contentType="text/html; charset=BIG5"%>
<%@ include file="../Logon/Init.inc" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="com.aegon.servlet.*" %>
<%@ page import="com.aegon.logon.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%!
	// class variable
	public String strThisProgId = new String("SecretWordShow");		//本程式代號

	class DataClass {
		public String strUserId = "";
		public String strSecretAnswer = "";
		public String strSecretAnswerDb = "";
		public String strPassword = "";
		public String strPasswordConfirm = "";
		public String strCallerUrl = "";
		public String strDebug = "";
		public String strUserType = "";
		
		public Connection conDb = null ;
		
		// the following variables are about password encrypt
		public boolean bPasswordEncryption = false;
		public EncryptionBean encoder = null;
		public boolean bCaseSenstive = true;
		
		
		public SessionInfo siThisSessionInfo = null;
		
		// constructor
		public DataClass(){
		}
		
		public void init(SessionInfo siSessionInfo){
			siThisSessionInfo = siSessionInfo;
			bPasswordEncryption = siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron().getPasswordEncrypted();
			encoder = new EncryptionBean( siThisSessionInfo.getUserInfo().getDbFactory() );
			bCaseSenstive = siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron().getPasswordCaseSenstivity();
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","init() normal exit");
		}
		
		//自 DbFactory 中取得一個 Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("SecretWordShow.DataClass.getConnection()");
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
	}
	
	// 取得Client端參數
	public boolean getInputParameter(HttpServletRequest request, DataClass objThisData){
		boolean bReturnStatus = true ;
		if(objThisData==null){
			bReturnStatus = false ;
		}else{
			objThisData.strUserId = request.getParameter("txtUserId");
			objThisData.strSecretAnswer = request.getParameter("txtSecretAnswer");
			objThisData.strPassword = request.getParameter("txtPassword");
			objThisData.strPasswordConfirm = request.getParameter("txtPasswordConfirm");
			objThisData.strDebug = request.getParameter("txtDebug");
			if(request.getParameter("txtCallerUrl")!=null){
				objThisData.strCallerUrl = request.getParameter("txtCallerUrl");
			}else{
				objThisData.strCallerUrl = "";
			}
		}
		if(objThisData.strUserId == null) objThisData.strUserId="";
		if(objThisData.strSecretAnswer == null) objThisData.strSecretAnswer="";
		if(objThisData.strPassword == null) objThisData.strPassword="";
		if(objThisData.strPasswordConfirm == null) objThisData.strPasswordConfirm="";
		if(objThisData.strDebug == null) objThisData.strDebug = "" ;
		
		return bReturnStatus ;
	}
	
	// 取得特定 User 的 Secret Word Question , Answer 及 User Type
	public String getSecretWord(DataClass objThisData){
		
		String strReturn = "";
		String getQuestionSql = "select SCTQ, SCTA, USRTYP from USER where USR='"+objThisData.strUserId+"' ";
		Statement stmt = null;
		ResultSet rst = null;
		try{
			stmt = objThisData.conDb.createStatement();
			rst = stmt.executeQuery(getQuestionSql);
			if(rst.next()){
				strReturn = rst.getString("SCTQ");
				objThisData.strSecretAnswerDb = rst.getString("SCTA");
				objThisData.strUserType = rst.getString("USRTYP");
			}else{
				strReturn = null;
			}
		}catch(SQLException ex){
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,"SecretWordShow.jsp:getSecretWordQuestion()",ex.getMessage());
		}finally{
			try{
				if(stmt!=null) stmt.close();
				if(rst!=null) rst.close();
			}catch(SQLException e){
			}
		}
		
		return strReturn ;
	}
	
	//檢查特定 User 的 secret word answer 是否符合
	public boolean checkAnswer(DataClass objThisData){
		boolean bReturnStatus = false ;
		// 正確答案已於 getSecretWord() 中取得
		if(objThisData.strSecretAnswer.equals(objThisData.strSecretAnswerDb)){
			bReturnStatus = true ;
		}
		return bReturnStatus ;
	}
	
	//重設使用者密碼
	public boolean resetPassword(DataClass objThisData){
		boolean bReturnStatus = true ;
		String resetPasswordSql = "update USER set PWD='"+encryptPassword(objThisData)
			+"' where USRID='"+objThisData.strUserId+"' ";
		
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SecretWordShow.jsp:resetPassword()","USRID='"+objThisData.strUserId+"' : '"+objThisData.strPassword+"' ");
		Statement stmt = null;
		try{
			stmt = objThisData.conDb.createStatement();
			if(stmt.executeUpdate(resetPasswordSql)<1){
				bReturnStatus = false ;
				objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SecretWordShow.jsp:resetPassword()","Nothing Update! sql='"+resetPasswordSql+"' ");
			}
		}catch(SQLException ex){
			bReturnStatus = false ;
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,"SecretWordShow.jsp:resetPassword()",ex.getMessage());
		}finally{
			try{
				if(stmt!=null) stmt.close();
			}catch(SQLException e){
			}
		}
		
		return bReturnStatus ;		
	}
	
	// 加密
	public String encryptPassword(DataClass objThisData){
		String strPassword = objThisData.strPassword ;
	
		if( !objThisData.bCaseSenstive ){
			objThisData.strPassword = objThisData.strPassword.toUpperCase();
		}
		if( objThisData.bPasswordEncryption ){
			strPassword = objThisData.encoder.getEncryptedPassword(objThisData.strPassword) ;
		}
		return strPassword;
	}	
	
%>
<%
	String webAppName = "CashWeb";
	if(application.getAttribute("ApplicationName")!=null){
		webAppName = (String)application.getAttribute("ApplicationName") ;
	}	
	boolean bCalledFromSelf = false;
	boolean bHasError = false;
	boolean forward = false;
	String strErrorMessage = "" ;
	String strSecretWordQuestion = "";
	
	DateFormat dfFormat = DateFormat.getDateTimeInstance(DateFormat.LONG,DateFormat.LONG,Locale.TAIWAN);
	SessionInfo siThisSessionInfo = null;
	UserInfo uiThisUserInfo = null;
	String strTmpStr = new String("");
	String strDbName= new String("CASH");
	String strMainPgmUrl = "/servlet/com.aegon.logon.LogonBean";
	//String strMainPgmUrl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/AegonWeb/servlet/com.aegon.logon.LogonBean" ;
	String strPgmUrl = "";

	String strCheckPasswordUrl = "";

	if(request.getScheme().indexOf("https")!=-1){
		strCheckPasswordUrl = "http://10.67.0.110:9080/CSIS/servlet/com.aegon.logon.CheckPassword" ;
	}else{
		strCheckPasswordUrl = "http://10.67.0.110:9080/CSIS/servlet/com.aegon.logon.CheckPassword" ;
	}

	DataClass objThisData = new DataClass();

	// get input parameter
	if(getInputParameter(request, objThisData)){
		// Create SessionInfo object for use (Because this program is before logon !)
		objThisData.init(new SessionInfo( (DbFactory)application.getAttribute(Constant.DB_FACTORY) , objThisData.strUserId ));
		objThisData.siThisSessionInfo.setSessionId(session.getId());
		objThisData.siThisSessionInfo.setAuditLogBean(new AuditLogBean((GlobalEnviron)application.getAttribute(Constant.GLOBAL_ENVIRON),(DbFactory)application.getAttribute(Constant.DB_FACTORY)));
		siThisSessionInfo = objThisData.siThisSessionInfo ;
				
		if(!objThisData.getConnection()){
			strErrorMessage = "無法連結資料庫 !";
		}else{
			// get secret word question !
			strSecretWordQuestion = getSecretWord(objThisData);
			
			if(strSecretWordQuestion==null){
				// 非會員
				strErrorMessage = "使用者帳號不存在 !";
			}else{
				if(request.getParameter("txtPgmUrl")!= null &&
		   		request.getParameter("txtPgmUrl").equals(strThisProgId)){
					bCalledFromSelf = true ;
				}else{
					bCalledFromSelf = false;
				}
				if(bCalledFromSelf){
					// Check secret word answer
					if(checkAnswer(objThisData)){
						// 檢查密碼檢核挸則
						CheckPasswordClient.setServerUrl(strCheckPasswordUrl);
						String[] chkPassReturn = CheckPasswordClient.getCheckResult("CashWeb",objThisData.strUserId,objThisData.strPassword,objThisData.strUserType,"F");
						objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","after checkPasswordClient() user id = '"+objThisData.strUserId+"' password = '"+objThisData.strPassword+"'");		
						if(!chkPassReturn[0].equals("0"))
						{
							objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()",chkPassReturn[2]);
							//bReturnStatus = false;
							strErrorMessage = chkPassReturn[2];
						}else{
							// reset password 
							if(resetPassword(objThisData)){
								forward = true ;
								out.clear();
								strMainPgmUrl += "?txtUserId="+objThisData.strUserId
									+"&txtPassword="+objThisData.strPassword
									+"&txtDebug="+objThisData.strDebug ;
								// redirect to Main program	
								System.out.println("strMainPgmUrl='"+strMainPgmUrl);
								objThisData.releaseConnection();
								pageContext.forward(strMainPgmUrl);
								return ;
								
						       	//strPgmUrl = strMainPgmUrl ;
								//response.sendRedirect(strTmpStr);
								//return ;
							}else{
								strErrorMessage = "重設密碼失敗 !";
							}
						}
					}else{
						// send error message to client	
						strErrorMessage = "密碼提示語答案不正確 !";			
					}
					
					if(strErrorMessage.equals("")){
						siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),"L","以 Secret Word 登入");
					}else{
						siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),"L",strErrorMessage);
					}
				}
			}
		}
	}else{
		strErrorMessage = "無法取得前端參數 !";
	}
	
%>
<% if(forward){ %>

<%}%>
<HTML>

<HEAD>
<META name="GENERATOR" content="Microsoft FrontPage 4.0">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>忘記密碼</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css">
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientM1.js"></SCRIPT>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">

var strFirstKey 			= "txtSecretAnswer";			//第一個可輸入之Key欄位名稱
var strFirstData 			= "txtSecretAnswer";			//第一個可輸入之Data欄位名稱
var strNextUrl				= "../Logon/Logon.jsp"
// *************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	strFunctionKeyInitial = "H,R,E";
	if( document.getElementById("txtMsg").value != ""){
		window.alert(document.getElementById("txtMsg").value) ;
	}
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "";
	/*
	if(document.getElementById("txtPgmUrl").value!=null &&
	   document.getElementById("txtPgmUrl").value!=""){
	   	window.top.open( document.getElementById("txtPgmUrl").value , "_top" );
	}
	*/
//	disableKey();
//	disableData();
}


/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtUserId" ){
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "使用者代號不可空白\n\r";
				bReturnStatus = false;
			}
		}
	}else if( objThisItem.name == "txtSecretAnswer" ){
		if( objThisItem.value == "" )
		{
			strTmpMsg = "問題之回答不可空白 !\n\r";
			bReturnStatus = false;
		}
	}else if( objThisItem.name == "txtPassword" ){
		if( objThisItem.value == "" )
		{
			strTmpMsg = "重設之新密碼不可空白\n\r";
			bReturnStatus = false;
		}
	}else if( objThisItem.name == "txtPasswordConfirm" ){
		if( objThisItem.value != document.all("txtPassword").value )
		{
			strTmpMsg = "確認使用者密碼必須與使用者密碼相同";
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

/*
函數名稱:	addAction()
函數功能:	當toolbar frame 中之新增按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function addAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
	document.getElementById("txtAction").value = "A";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/*
函數名稱:	updateAction()
函數功能:	當toolbar frame 中之修改按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );
	disableKey();
	enableData();
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstData) != null )
			document.getElementById(strFirstData).focus() ;
	}
	document.getElementById("txtAction").value = "U";
}

/*
函數名稱:	inquiryAction()
函數功能:	當toolbar frame 中之查詢按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function inquiryAction()
{
	winToolBar.ShowButton( strFunctionKeyInquiry1 );
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}

}

/*
函數名稱:	deleteAction()
函數功能:	當toolbar frame 中之刪除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function deleteAction()
{
	var bConfirm = window.confirm("是否確定刪除該筆資料?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "D";
		document.getElementById("frmMain").submit();
	}
}

/*
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	var strUserId = document.getElementById("txtUserId").value ;
	var strCallerUrl = document.getElementById("txtCallerUrl").value ;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
	document.getElementById("txtUserId").value = strUserId;
	document.getElementById("txtCallerUrl").value = strCallerUrl ;
	
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/*
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	var strNextUrl = document.getElementById("txtCallerUrl").value;
	window.top.open( strNextUrl , "_top" );
}

/*
函數名稱:	confirmAction()
函數功能:	當toolbar frame 中之確定按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function confirmAction()
{
	enableAll();
	if( areAllFieldsOK() )	{
		document.getElementById("frmMain").submit();
	}else{
		alert( strErrMsg );
	}	
}

/*
函數名稱:	saveAction()
函數功能:	當toolbar frame 中之儲存按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function saveAction()
{
	enableAll();
	if( areAllFieldsOK() )
	{
//		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}

</script>
</HEAD>
<BODY onload="WindowOnLoad()">
<FORM id="frmMain" method="POST" action="SecretWordShow.jsp">
<CENTER><BR>
<BR>
<table border="0" width=500 cellspacing="0" cellpadding="0" >
	<tr><td><font color=red>請注意：</font></td></tr>			
	<tr><td><font color=red>　　　‧密碼中的英文字母大小寫是不同的。</font></td></tr>
	<tr><td><font color=red>　　　‧密碼的長度必須為7-15碼，其中包含英文字母及阿拉伯數字。</font></td></tr>
	<tr><td><font color=red>　　　　(例如 密碼aegon888，其長度為8，同時包含英文字母及阿拉伯數字)</font></td></tr>
</table>
<BR>
<TABLE border="1" width="500"
	style="border-style: none; font-size: large; font-family: 細明體; font-weight: middle; color: black">
	<TBODY>
		<TR>
			<TD align="right" width="250" class="TableHeading"><font face="細明體"
				size="2" color="black">密碼重設問題：</font></TD>
			<TD width="250"><font face="細明體" size="2" color="red"><%=strSecretWordQuestion%><FONT></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading"><font face="細明體" size="2"
				color="black">以上問題之回答：</font></TD>
			<TD valign="middle" align="left"><INPUT class="Key" size="20"
				type="text" maxlength="50" id="txtSecretAnswer"
				name="txtSecretAnswer" value="<%=objThisData.strSecretAnswer%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading"><font face="細明體" size="2"
				color="black">重設之新密碼：</font></TD>
			<TD valign="middle" align="left"><INPUT class="Key" size="10"
				type="password" maxlength="10" id="txtPassword" name="txtPassword"
				value="<%=objThisData.strPassword%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading"><font face="細明體" size="2"
				color="black">新密碼確認：</font></TD>
			<TD valign="middle" align="left"><INPUT class="Key" size="10"
				type="password" maxlength="10" id="txtPasswordConfirm"
				name="txtPasswordConfirm"
				value="<%=objThisData.strPasswordConfirm%>"></TD>
		</TR>
	</TBODY>
</TABLE>

</CENTER>
<INPUT name="txtAction" id="txtAction" type="hidden" value=""> <INPUT
	size="20" type="hidden" name="txtDebug" style="font-family: 細明體"
	value="3"> <INPUT id=txtMsg name=txtMsg type=hidden
	value="<%=strErrorMessage%>"> <INPUT id="txtUserId" name="txtUserId"
	value="<%=objThisData.strUserId%>" type="hidden"> <INPUT
	id="txtCallerUrl" name="txtCallerUrl"
	value="<%=objThisData.strCallerUrl%>" type="hidden"> <INPUT
	id="txtPgmUrl" name="txtPgmUrl" value="<%=strThisProgId%>"
	type="hidden"></FORM>
</BODY>
</HTML>
<%
	objThisData.releaseConnection();
%>