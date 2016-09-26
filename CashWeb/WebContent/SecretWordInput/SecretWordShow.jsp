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
	public String strThisProgId = new String("SecretWordShow");		//���{���N��

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
		
		//�� DbFactory �����o�@�� Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
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
	
	// ���oClient�ݰѼ�
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
	
	// ���o�S�w User �� Secret Word Question , Answer �� User Type
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
	
	//�ˬd�S�w User �� secret word answer �O�_�ŦX
	public boolean checkAnswer(DataClass objThisData){
		boolean bReturnStatus = false ;
		// ���T���פw�� getSecretWord() �����o
		if(objThisData.strSecretAnswer.equals(objThisData.strSecretAnswerDb)){
			bReturnStatus = true ;
		}
		return bReturnStatus ;
	}
	
	//���]�ϥΪ̱K�X
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
	
	// �[�K
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
			strErrorMessage = "�L�k�s����Ʈw !";
		}else{
			// get secret word question !
			strSecretWordQuestion = getSecretWord(objThisData);
			
			if(strSecretWordQuestion==null){
				// �D�|��
				strErrorMessage = "�ϥΪ̱b�����s�b !";
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
						// �ˬd�K�X�ˮ��ɫh
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
								strErrorMessage = "���]�K�X���� !";
							}
						}
					}else{
						// send error message to client	
						strErrorMessage = "�K�X���ܻy���פ����T !";			
					}
					
					if(strErrorMessage.equals("")){
						siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),"L","�H Secret Word �n�J");
					}else{
						siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),"L",strErrorMessage);
					}
				}
			}
		}
	}else{
		strErrorMessage = "�L�k���o�e�ݰѼ� !";
	}
	
%>
<% if(forward){ %>

<%}%>
<HTML>

<HEAD>
<META name="GENERATOR" content="Microsoft FrontPage 4.0">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>�ѰO�K�X</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css">
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientM1.js"></SCRIPT>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">

var strFirstKey 			= "txtSecretAnswer";			//�Ĥ@�ӥi��J��Key���W��
var strFirstData 			= "txtSecretAnswer";			//�Ĥ@�ӥi��J��Data���W��
var strNextUrl				= "../Logon/Logon.jsp"
// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	checkClientField(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
				strTmpMsg = "�ϥΪ̥N�����i�ť�\n\r";
				bReturnStatus = false;
			}
		}
	}else if( objThisItem.name == "txtSecretAnswer" ){
		if( objThisItem.value == "" )
		{
			strTmpMsg = "���D���^�����i�ť� !\n\r";
			bReturnStatus = false;
		}
	}else if( objThisItem.name == "txtPassword" ){
		if( objThisItem.value == "" )
		{
			strTmpMsg = "���]���s�K�X���i�ť�\n\r";
			bReturnStatus = false;
		}
	}else if( objThisItem.name == "txtPasswordConfirm" ){
		if( objThisItem.value != document.all("txtPassword").value )
		{
			strTmpMsg = "�T�{�ϥΪ̱K�X�����P�ϥΪ̱K�X�ۦP";
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
��ƦW��:	addAction()
��ƥ\��:	��toolbar frame �����s�W���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	updateAction()
��ƥ\��:	��toolbar frame �����ק���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	inquiryAction()
��ƥ\��:	��toolbar frame �����d�߫��s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	deleteAction()
��ƥ\��:	��toolbar frame �����R�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function deleteAction()
{
	var bConfirm = window.confirm("�O�_�T�w�R���ӵ����?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "D";
		document.getElementById("frmMain").submit();
	}
}

/*
��ƦW��:	resetAction()
��ƥ\��:	��toolbar frame �����M�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	var strNextUrl = document.getElementById("txtCallerUrl").value;
	window.top.open( strNextUrl , "_top" );
}

/*
��ƦW��:	confirmAction()
��ƥ\��:	��toolbar frame �����T�w���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	saveAction()
��ƥ\��:	��toolbar frame �����x�s���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
	<tr><td><font color=red>�Ъ`�N�G</font></td></tr>			
	<tr><td><font color=red>�@�@�@�E�K�X�����^��r���j�p�g�O���P���C</font></td></tr>
	<tr><td><font color=red>�@�@�@�E�K�X�����ץ�����7-15�X�A�䤤�]�t�^��r���Ϊ��ԧB�Ʀr�C</font></td></tr>
	<tr><td><font color=red>�@�@�@�@(�Ҧp �K�Xaegon888�A����׬�8�A�P�ɥ]�t�^��r���Ϊ��ԧB�Ʀr)</font></td></tr>
</table>
<BR>
<TABLE border="1" width="500"
	style="border-style: none; font-size: large; font-family: �ө���; font-weight: middle; color: black">
	<TBODY>
		<TR>
			<TD align="right" width="250" class="TableHeading"><font face="�ө���"
				size="2" color="black">�K�X���]���D�G</font></TD>
			<TD width="250"><font face="�ө���" size="2" color="red"><%=strSecretWordQuestion%><FONT></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading"><font face="�ө���" size="2"
				color="black">�H�W���D���^���G</font></TD>
			<TD valign="middle" align="left"><INPUT class="Key" size="20"
				type="text" maxlength="50" id="txtSecretAnswer"
				name="txtSecretAnswer" value="<%=objThisData.strSecretAnswer%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading"><font face="�ө���" size="2"
				color="black">���]���s�K�X�G</font></TD>
			<TD valign="middle" align="left"><INPUT class="Key" size="10"
				type="password" maxlength="10" id="txtPassword" name="txtPassword"
				value="<%=objThisData.strPassword%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading"><font face="�ө���" size="2"
				color="black">�s�K�X�T�{�G</font></TD>
			<TD valign="middle" align="left"><INPUT class="Key" size="10"
				type="password" maxlength="10" id="txtPasswordConfirm"
				name="txtPasswordConfirm"
				value="<%=objThisData.strPasswordConfirm%>"></TD>
		</TR>
	</TBODY>
</TABLE>

</CENTER>
<INPUT name="txtAction" id="txtAction" type="hidden" value=""> <INPUT
	size="20" type="hidden" name="txtDebug" style="font-family: �ө���"
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