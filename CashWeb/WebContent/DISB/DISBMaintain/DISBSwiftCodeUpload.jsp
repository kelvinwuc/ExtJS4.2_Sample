<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : SWIFT CODE 維護畫面
 * 
 * Remark   : 管理系統-財務
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : William wu
 * 
 * Create Date : 2013/02/18 
 * 
 * Request ID : RA0074
 * 
 * CVS History:
 * 
 * $Log: DISBSwiftCodeUpload.jsp,v $
 * Revision 1.3  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 *  
 */
%><%!String strThisProgId = "DISBSwiftCodeUpload"; //本程式代號%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
%>
<html>
<head>
<META http-equiv="Content-Style-Type" content="text/css">
<title>管理系統--SWIFT CODE上傳功能</title>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT>
<!--
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
	window.status = "";
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBSwiftCodeUpload.jsp";
}

/* 當toolbar frame 中之<確定>按鈕被點選時,本函數會被執行 */
function confirmAction()
{
	var fileObj = document.getElementById("UPFILE");
	if(fileObj.value == "") {
		alert("請挑選要上傳的檔案!!");
		return false;
	} else {
		document.getElementById("txtAction").value = "upload";
		document.forms("frmMain").submit();
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<FORM enctype="multipart/form-data" id="frmMain" name="frmMain" method="post"  action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBSwiftCodeManageServlet">
<TABLE border="1" width="450">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="100">檔案名稱：</TD>
			<TD><INPUT TYPE="FILE" id="UPFILE" name="UPFILE"></TD>
		</TR>
	</TBODY>
</TABLE>
<BR>
<% if(!strReturnMessage.equals("")) { %>
<BR>
<table><tr><td><%=strReturnMessage%></td></tr></table>
<BR>
<table><tr><td>新增成功筆數:</td><td><%=request.getAttribute("insertCount")%> </td></tr></table>
<table><tr><td>更新成功筆數:</td><td><%=request.getAttribute("successCount")%> </td></tr></table>
<table><tr><td>失敗筆數:</td><td><%=request.getAttribute("failCount")%> </td></tr></table>
<table><tr><td>失敗記錄:</td><td><%=request.getAttribute("failRec").equals("")?"N/A":request.getAttribute("failRec")%></td></tr></table>
<table><tr><td>總件數 : <%=request.getAttribute("totalCount")%> </td></tr></table>
<% } %>
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</html>