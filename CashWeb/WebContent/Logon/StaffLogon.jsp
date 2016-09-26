<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.GlobalEnviron" %>
<%@ include file="Init.inc" %>
<%!private float getIEVersion(HttpServletRequest request) {
    String UserAgent = request.getHeader("user-agent");
    float fVersion = 0;
    if (UserAgent != null) {
        int i1 = UserAgent.indexOf("MSIE");
        int i2 = UserAgent.indexOf(";", i1);
        if (i1 != -1 && i2 != -1) {
            fVersion = Float.parseFloat(UserAgent.substring(i1 + 4, i2));
        } else {
            fVersion = -1;
        }
    }
    //System.out.println("The Browser Version is : '"+fVersion+"' ");
    return fVersion;
}
%><%
boolean bHasError = false;
String strUserId = "";
String strPassword = "";
String strErrorMessage = "";
String strConfirmMessage = "";

if (request.getParameter("txtUserId") != null) {
    strUserId = request.getParameter("txtUserId");
}
if (request.getParameter("txtPassword") != null) {
    strPassword = request.getParameter("txtPassword");
}

float fIEVersion = getIEVersion(request);

// 判斷是否有需確認的 Message
if (request.getAttribute("txtConfirmMessage") != null) {
    strConfirmMessage = (String) request.getAttribute("txtConfirmMessage");
} else if (request.getParameter("txtConfirmMessage") != null) {
    strConfirmMessage = request.getParameter("txtConfirmMessage");
}

//若傳入參數中有txtMsg時,表示由其他程式轉過來,需判對訊息為何
if (request.getAttribute("txtMsg") != null) {
    strErrorMessage = (String) request.getAttribute("txtMsg");
} else {
    if (request.getParameter("txtMsg") != null) {
        String strMsg = request.getParameter("txtMsg");

        if (strMsg.equals("300")) {
            //300:session是新設立
            strErrorMessage = "未登錄過,或登錄之連結已過時,請重新登錄本系統(300)";
        } else if (strMsg.equals("301")) {
            //301:siThisSessionInfo為null
            strErrorMessage = "SessionInfo為空白,請重新登錄本系統(301)";
        } else if (strMsg.equals("302")) {
            //302:uiThisUserInfo為null
            strErrorMessage = "UserInfo為空白,請重新登錄本系統(302)";
        } else if (strMsg.equals("303")) {
            //303:checkPassword() failed
            strErrorMessage = "未登錄OK,請重新登錄本系統(303)";
        } else if (strMsg.equals("304")) {
            //304:checkPrivilege() failed
            strErrorMessage = "無權限執行該程式(304)";
        } else if (strMsg.equals("305")) {
            //305:system shutted down failed
            strErrorMessage = "系統關閉中(305)";
        } else {
        	strErrorMessage = strMsg ;
        }
    }
}
if (request.getParameter("fromLogonBean") != null
    && request.getParameter("fromLogonBean").equals("true")) {
    // do nothing
} else {
    session.invalidate();
}
// Check Brower Version

if (fIEVersion < 5.5) {
    strErrorMessage += "本系統須使用 Microsoft Internet Explorer (MSIE) 5.5 以上的版本，\n\r請至微軟網站更新瀏覽器版本 !";
}

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
boolean isAEGON401 = (globalEnviron.getActiveAS400DataSource().equals(Constant.CAPSIL_DATA_SOURCE_AEGON401));
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=BIG5">
<META http-equiv="Content-Style-Type" content="text/css">
<style type="text/css">
<!--
a {
	color: #FF0000;
	text-decoration: underline
}

a:hover {
	color: #EA930A;
	text-decoration: none
}

.normal {
	font-size: 15px;
	line-height: 20px;
	font-weight: bold;
	color: #666666;
}

.small {
	font-size: 12px;
	line-height: 16px
}

input.button {
	background-color: #FCE3AF;;
	font-size: 12px
}

.footer {
	font-size: 12px;
	color: #666666
}

body {
	BACKGROUND-IMAGE: url(<%=request.getContextPath()%>/images/misc/background.gif)
}
-->
</style>

<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<TITLE>登錄畫面</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT>
<!--
function WindowOnLoad()
{
	if( typeof(window.dialogArguments) == 'undefined' )	//未出現於 modalDialog 中
	{
		//將本Logon畫面置於最上層
		if( top.name != window.name )
		{
			top.open( "<%=request.getContextPath()%>/"+document.getElementById("txtCallerUrl").value,"_self" );
		}
		else
		{
			if( document.getElementById("txtMsg").value != "" )
			{
				alert( document.getElementById("txtMsg").value );
			}
			document.getElementById("txtUserId").focus();
		}
		document.all("txtUserId").focus();
	}
	else		//若出現於 modlaDialog 中時,表示session有問題時redirect至本網頁,顯示錯誤訊息後結束本網頁
	{
		if( document.getElementById("txtMsg").value != "" )
		{
			alert( document.getElementById("txtMsg").value );
		}
		window.returnValue = "";
		window.close();
	}
	<%if (!strConfirmMessage.equals("")) {
    out.println("if(confirm('" + strConfirmMessage + "')){");
    out.println("   document.getElementById('txtRemoveAll').value = 'TRUE' ;");
    out.println("   document.getElementById('frmMain').submit();");
    out.println("}else{");
    out.println("   document.getElementById('txtRemoveAll').value = 'FALSE';");
    out.println("}");
}%>
}

function SecretWord()
{
	if( document.getElementById("txtUserId").value == "" )
		alert("請先輸入帳號");
	else
	{
		document.getElementById("txtUserId").value = document.getElementById("txtUserId").value.toUpperCase();
		window.open("<%=request.getContextPath()%>/SecretWordInput/index.jsp?txtUrl=SecretWordShow.jsp?txtUserId="+document.getElementById("txtUserId").value+"%26txtCallerUrl=<%=request.getContextPath()%>/"+document.getElementById("txtCallerUrl").value,"_self");
	}
}

function ShowHelp(){
	window.open("help.html","_help","height=200,width=350");	
}

function CheckLogon()
{
	if( document.getElementById("txtUserId").value == "" ){
		alert("請先輸入帳號");
		document.getElementById("txtUserId").focus();
		return false ;
	}else{
		document.getElementById("txtUserId").value = document.getElementById("txtUserId").value.toUpperCase();
		return true;
	}
}
//-->
</SCRIPT>
</head>
<body onload="WindowOnLoad();">
<DIV align="center">
<FORM id="frmMain" method="POST"
	action="<%=request.getContextPath()%>/servlet/com.aegon.logon.LogonBean"
	onsubmit="return CheckLogon();">
<table border="0" cellpadding="0" cellspacing="0" width="760">
	<tr><td colspan="3"><IMG border="0" src="<%=request.getContextPath()%>/Logon/images/StaffLogon.jpg" width="760" height="282"></td></tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="760">
<% if(isAEGON401) { %>
	<tr align="center"><td colspan="9"><BR><span class="normal">※ CASH 測試環境：<%=globalEnviron.getAS400DbUserIdAEGON401()%></span><BR></td></tr>
<% } %>
	<tr>
		<td height="10"></td>
	</tr>
	<tr><!--R00393 edit by Leo Huang-->
		<td><img src="<%=request.getContextPath()%>/Logon/images/logon.gif" width="122" height="24" align="baseline"></td>
		<td rowspan="3" bgcolor="#FF9900" width="1"><img src="<%=request.getContextPath()%>/Logon/images/space.gif" width="1" height="1"></td>
		<td>&nbsp;&nbsp;</td>
		<td><img src="<%=request.getContextPath()%>/Logon/images/logon_id.gif" width="41" height="16"></td>
		<td><INPUT class="Data" size="16" type="text" maxlength="10" name="txtUserId" value="<%=strUserId%>"></td>
		<td><img src="<%=request.getContextPath()%>/Logon/images/logon_ps.gif" width="41" height="16"></td>
		<td><INPUT class="Data" size="19" type="password" maxlength="10" name="txtPassword" value="<%=strPassword%>"> <span class="small"> </span></td>
		<td><input type="submit" name="btnSubmit" value="登入" class="button"></td>
		<td><input type="reset" name="btnReset" value="清除" class="button"></td>
	</tr>
	<tr>
		<td></td>
		<td colspan="6"><br>
		<p>
		<img src="<%=request.getContextPath()%>/Logon/images/diodio_a.gif" width="15" height="15"
			align="absmiddle" hspace="5"><span class="small"><a href="#"
			onClick="SecretWord()">忘記密碼？</a></span><img
			src="<%=request.getContextPath()%>/Logon/images/diodio_a.gif" width="15" height="15"
			align="absmiddle" hspace="5"><span class="small"><a href="#"
			onClick="ShowHelp()">使用說明</a></span> <span class="small"></span></p>
		</td>
		<td>&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="6">
		<span class="small"><br>&nbsp;&nbsp;
			<table width=500>
				<tr><td colspan="6">請注意：</td></tr>			
				<tr><td colspan="6"><span class="small">　　　‧密碼中的英文字母大小寫是不同的。</span></td></tr>
	        	<tr><td colspan="6"><span class="small">　　　‧密碼輸入錯誤超過5次，帳號將暫停使用。</span></td></tr>
	        	<tr><td colspan="6"><span class="small">　　　‧同一帳號，在同一時間內只能在一台PC登入。</span></td></tr>
				<tr><td colspan="6"><span class="small"><font color="#2183D0">　　　‧本網頁請使用IE5.5以上版本瀏覽。</font></span></td></tr>	        	
	        </table>
		</span>
		</td>
	</tr>	
</table>
<INPUT type="hidden" name="txtDebug" value="3"> 
<INPUT type="hidden" id="txtMsg" name="txtMs"g value="<%=strErrorMessage%>"> 
<INPUT type="hidden" id="txtRemoveAll" name="txtRemoveAll" value="FALSE"> 
<INPUT type="hidden" id="txtCallerUrl" name="txtCallerUrl" value="/Logon/StaffLogon.jsp">
<INPUT type="hidden" id="txtAreaCode" name="txtAreaCode" value="Staff">
</FORM>
</DIV>
</body>
</html>
