<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.SessionInfo" %>
<%@ page import="com.aegon.comlib.UserInfo" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%!
/**
 * System   : 
 * 
 * Function : 個人資料維護
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.5 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date: ${date}
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: PasswordChangeC.jsp,v $
 * Revision 1.5  2013/12/24 04:12:48  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.4  2012/08/31 09:26:01  taipei\ODCKain
 * prepare WAS8 dev env
 *
 * Revision 1.3  2012/08/29 10:45:23  ODCWilliam
 * modify: william
 * date: 2012-08-28
 * issue: session expiry
 *
 * Revision 1.2  2012/08/24 02:39:32  ODCWilliam
 * *** empty log message ***
 *
 * Revision 1.1  2011/08/09 01:34:09  MISSALLY
 * Q10256　 有關CASH系統錯誤無法跑出報表
 *
 *  
 */
%><%
String strMsg = request.getParameter("txtMsg")==null?"":request.getParameter("txtMsg");
int iPasswordStatus = Integer.parseInt(String.valueOf(session.getAttribute("PasswordAging")));
String strPasswordAgingMsg = String.valueOf(session.getAttribute("PasswordAgingMsg"));
String strUserId = String.valueOf(session.getAttribute(Constant.LOGON_USER_ID));
String orgPwdStat = request.getParameter("txtorgPwdStat")==null?String.valueOf(iPasswordStatus):request.getParameter("txtorgPwdStat");
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>個人資料維護</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 	 = "";						//第一個可輸入之Key欄位名稱
var strFirstData 	 = "txtPassword";			//第一個可輸入之Data欄位名稱

var iPasswordStatus  = 0;			            // 0:密碼有效, 1:必須更改密碼, 2:警告期, 9:第一次登錄
var strMustChangeMsg = "您的密碼已經過期,請先更改密碼後再進行其他作業";
var strWarningMsg    = "您的密碼快要過期了,是否要立刻修改密碼?";
var strFirstTimeMsg  = " 第一次進入系統,請修改密碼及確認個人資料";
var strPasswordAgingMsg = "";
var strNextUrl       = "<%=request.getContextPath()%>/NewMenu/index.html";

// *************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	strFunctionKeyInitial = "H,R,E";			//確定,清除,離開
	if( document.getElementById("txtMsg").value != "" )
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;

	iPasswordStatus = "<%=iPasswordStatus%>";
	strPasswordAgingMsg = "<%=strPasswordAgingMsg%>";

	if( iPasswordStatus != 0 )
	{
		alert( strPasswordAgingMsg );
//		if( iPasswordStatus == 1 )	//必需更改密碼
//		{
//			alert( strPasswordAgingMsg );
//		}
//		else if( iPasswordStatus == 2 )	//超過警告期
//		{
//			var bPasswordChange = window.confirm( strPasswordAgingMsg );
//			if( !bPasswordChange )
//			{
			//	alert("here_1");
			//	window.top.navigate( strNextUrl );
//			window.top.navigate("../Logon/Logon.jsp");
//			}
//		}
//		else if( iPasswordStatus == 9 ) //第一次登錄系統
//		{
//			alert( strPasswordAgingMsg );
//		}
	}
	else
	{
		if( document.getElementById("txtorgPwdStat").value != "0" )
			window.top.navigate( strNextUrl );
	}
	window.status = "輸入密碼及確認密碼後,按確定鈕即可更改密碼";
	enableData();

	document.getElementById("txtEmail").value = "<%=uiThisUserInfo.getEmail()%>";
	document.getElementById("txtSecretQuestion").value = "<%=uiThisUserInfo.getSecretQuestion()%>";
	document.getElementById("txtSecretAnswer").value = "<%=uiThisUserInfo.getSecretAnswer()%>";
}

/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtPassword" )
	{
		if( objThisItem.value == "" )
		{
			if( iPasswordStatus == 1 || iPasswordStatus == 9 ) //密碼已過期及第一次登入必須修改密碼
			{
				strTmpMsg = "新密碼不可空白";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.name == "txtConfirmPassword" )
	{
		if( objThisItem.value != document.all("txtPassword").value )
		{
			strTmpMsg = "確認新密碼必須與新密碼相同";
			bReturnStatus = false;
		}
	}
	else if(objThisItem.name == "txtSecretAnswer")
	{
		if(alltrim(objThisItem.value) == ""){
			strTmpMsg += "密碼提示問題之答案，不可空白 !";
			bReturnStatus = false ;
		}
	}
	else if( objThisItem.name == "txtSecretQuestion" )
	{
		if(alltrim(objThisItem.value) == ""){
			strTmpMsg += "密碼提示語問題，不可空白 !";
			bReturnStatus = false ;
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
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
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
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function exitAction()
{
	window.location = '<%=request.getContextPath()%>/Logon/Logoff.jsp';
}

/*
函數名稱:	confirmAction()
函數功能:	當toolbar frame 中之確定按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function confirmAction()
{
	enableAll();
	if( areAllFieldsOK() )
	{
		document.getElementById("txtAction").value = "U";
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}

function PickQuestion()
{
	if(document.getElementById("divPickQuestion").style.display == "block"){
		document.getElementById("divPickQuestion").style.display = "none";
	}else{
		document.getElementById("divPickQuestion").style.display = "block";
		changeQuestion(document.getElementsByTagName("SELECT").item(0));
	}
}

function changeQuestion(thisSelection)
{
	if( thisSelection.selectedIndex != 0 )
		document.getElementById("txtSecretQuestion").value = thisSelection.options.item( thisSelection.selectedIndex ).text;
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnLoad();">
<form id="frmMain" name="frmMain" method="post" action="PasswordChangeS.jsp">
<CENTER>
<table border="0" width=730 cellspacing="0" cellpadding="0" >
	<tr><td><font color=red>請注意：</font></td></tr>			
	<tr><td><font color=red>　　　‧密碼中的英文字母大小寫是不同的。</font></td></tr>
	<tr><td><font color=red>　　　‧密碼的長度必須為7-15碼，其中包含英文字母及阿拉伯數字。</font></td></tr>
	<tr><td><font color=red>　　　　(例如 密碼person888，其長度為9，同時包含英文字母及阿拉伯數字)</font></td></tr>
</table>
<br>
<TABLE width="730" border="1">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="302">新 密 碼(如不更改,就保持空白)：</TD>
			<TD width="420"><INPUT class="Data" size="30" type="password" maxlength="15" id="txtPassword" name="txtPassword" value="" onblur="checkClientField(this,true);"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="302">新密碼確認：</TD>
			<TD width="420"><INPUT class="Data" size="30" type="password" maxlength="15" id="txtConfirmPassword" name="txtConfirmPassword" value="" onblur="checkClientField(this,true);"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="302">email帳號：</TD>
			<TD width="420"><INPUT class="Data" size="30" type="text" maxlength="60" id="txtEmail" name="txtEmail" value="" onblur="checkClientField(this,true);"></TD>
		</TR>
	</TBODY>
</TABLE>
<TABLE border="1" width="730" height="51">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="296">密碼提示語問題：</TD>
			<TD align='left' width="265"><INPUT class="Data" size="32" maxlength="60" id="txtSecretQuestion" name="txtSecretQuestion" value="" onblur="checkClientField(this,false);"></TD>
			<TD align='center'>
				<DIV id="divPickQuestion" Style="display: block">
					<SELECT class="Data" id='tmpSelect' name='tmpSelect' onChange="changeQuestion(this);">
						<OPTION>參考題目</OPTION>
						<OPTION>我的出生日期?</OPTION>
						<OPTION>我最喜歡的食物?</OPTION>
						<OPTION>我的結婚週年日?</OPTION>
						<OPTION>我太太的生日?</OPTION>
					</SELECT>
				</DIV>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="296">密碼提示問題之答案：</TD>
			<TD colspan='3'><INPUT class="Data" size='32' maxlength="60" id="txtSecretAnswer" name="txtSecretAnswer" value="" onblur="checkClientField(this,false);"></TD>
		</TR>
	</TBODY>
</TABLE><br>


<table border="0" width=730 cellspacing="0" cellpadding="0" id="copyright">
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'>
	        <Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: 新細明體;">著作權所有全球人壽</font>
        </td>
	</tr>
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'><Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: 新細明體;">
		<script language=JavaScript >
        var dteDate = new Date( document.lastModified );
        var strOut = '更新日期:';
        if( dteDate.getMonth() + 1 < 10 )
    	    strOut += "0"+(dteDate.getMonth()+1)+"/";
        else
	        strOut += (dteDate.getMonth()+1)+"/";
        if( dteDate.getDate() < 10 )
	        strOut += "0"+dteDate.getDate()+"/";
        else
	        strOut += dteDate.getDate()+"/";
	        strOut += dteDate.getFullYear();
	        document.write( strOut );
		</script></font></td>
	</tr>
</table>
</CENTER>
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
<INPUT type="hidden" id="txtorgPwdStat" name="txtorgPwdStat" value="<%=orgPwdStat%>">
</FORM>
</BODY>
</HTML>