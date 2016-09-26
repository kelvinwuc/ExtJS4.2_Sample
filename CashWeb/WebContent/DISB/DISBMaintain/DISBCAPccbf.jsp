<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 國內金資檔
 * 
 * Remark   : 管理系統-財務
 * 
 * Revision : $Revision: 1.6 $
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 2010/11/23 02:21:59
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DISBCAPccbf.jsp,v $
 * Revision 1.6  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 * Revision 1.5  2012/06/18 09:35:40  MISSALLY
 * QA0132-金資檔案及 SWIFT CODE檔案維護
 * 1.功能「新增金資碼」增加檢核不得為空值。
 * 2.功能「金資銀行檔」
 *    2.1國外SWIFT CODE畫面隱藏。
 *    2.2增加檢核不得上傳空檔。
 *    2.3增加檢核金資代碼長度必須為7位數字，否則顯示失敗的記錄；若執行時有錯誤訊息則全部不更新，且顯示失敗的記錄。
 *
 *  
 */
%><%!String strThisProgId = "DISBCAPccbf"; //本程式代號%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>管理系統--金資銀行檔</TITLE>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
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
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBCAPccbf.jsp";
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
<BODY ONLOAD="WindowOnLoad();">
<FORM ENCTYPE="multipart/form-data" id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBCAPccbfServlet">
<TABLE border="1" width="450" id="tbArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">檔案名稱：</TD>
			<TD><INPUT TYPE="FILE" id="UPFILE" name="UPFILE"></TD>
		</TR>
	</TBODY>
</TABLE>
<BR>
<% if(!strReturnMessage.equals("")) { %>
<BR>
<div id="divMsgArea">
<table><tr><td>新增成功筆數:</td><td><%=request.getAttribute("insertCount")%> </td></tr></table>
<table><tr><td>更新成功筆數:</td><td><%=request.getAttribute("successCount")%> </td></tr></table>
<table><tr><td>失敗筆數:</td><td><%=request.getAttribute("failCount")%> </td></tr></table>
<table><tr><td>失敗記錄:</td><td><%=request.getAttribute("failRec")!=null?request.getAttribute("failRec"):"N/A"%></td></tr></table>
<table><tr><td>總件數 : <%=request.getAttribute("totalCount")%> </td></tr></table>
</div>
<% } %>
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>