<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 逾期票據分錄
 * 
 * Remark   : 管理系統─財務
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: DISBAccOverdueChk.jsp,v $
 * Revision 1.1  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */
%><%! String strThisProgId = "DISBAccOverdueChk"; //本程式代號 %><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";
%>
<HTML>
<HEAD>
<TITLE>管理系統--逾期應付票據分錄</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" )
	{
		window.alert(document.getElementById("txtMsg").value) ;
	}

	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyDown,'' );
	window.status = "";
}

function DISBDownloadAction()
{
	var strErrMsg = "";
	if( document.getElementById("txtYear").value == "" ) {
		strErrMsg = "逾期年不可空白";
	}
	if( document.getElementById("txtMonth").value == "" ) {
		strErrMsg += "逾期月不可空白";
	}

	if(strErrMsg != "") {
		alert( strErrMsg );
		return false;
	} else {
		if(document.getElementById("txtMonth").value.length == "1") {
			document.getElementById("txtMonth").value = "0" + document.getElementById("txtMonth").value;
		}
		document.getElementById("frmMain").submit();
	}
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBAccOverdueChk.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBAccOverdueChkServlet">
<br>
<TABLE border="1" width="300" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="100">逾期年月：</TD>
			<TD colspan="2" width="200">&nbsp;<INPUT type="text" id="txtYear" name="txtYear" size="3" maxlength="3" class="Data">年 <INPUT type="text" id="txtMonth" name="txtMonth" size="3" maxlength="2" class="Data">月</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">逾期年數： </TD>
			<TD>
				<select id="txtYearSelect" name="txtYearSelect">
					<option value="1">逾一年</option>
					<option value="2">逾二年</option>
				</select>
			</TD>
		</TR>
		<TR>
			<TD colspan="2"><BR>請輸入民國年</TD>
		</TR>
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>