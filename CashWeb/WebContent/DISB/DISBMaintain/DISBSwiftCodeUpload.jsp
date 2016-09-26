<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : SWIFT CODE ���@�e��
 * 
 * Remark   : �޲z�t��-�]��
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
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 *
 *  
 */
%><%!String strThisProgId = "DISBSwiftCodeUpload"; //���{���N��%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
%>
<html>
<head>
<META http-equiv="Content-Style-Type" content="text/css">
<title>�޲z�t��--SWIFT CODE�W�ǥ\��</title>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT>
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
	window.status = "";
}

/* ��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q���� */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBSwiftCodeUpload.jsp";
}

/* ��toolbar frame ����<�T�w>���s�Q�I���,����Ʒ|�Q���� */
function confirmAction()
{
	var fileObj = document.getElementById("UPFILE");
	if(fileObj.value == "") {
		alert("�ЬD��n�W�Ǫ��ɮ�!!");
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
			<TD align="left" class="TableHeading" width="100">�ɮצW�١G</TD>
			<TD><INPUT TYPE="FILE" id="UPFILE" name="UPFILE"></TD>
		</TR>
	</TBODY>
</TABLE>
<BR>
<% if(!strReturnMessage.equals("")) { %>
<BR>
<table><tr><td><%=strReturnMessage%></td></tr></table>
<BR>
<table><tr><td>�s�W���\����:</td><td><%=request.getAttribute("insertCount")%> </td></tr></table>
<table><tr><td>��s���\����:</td><td><%=request.getAttribute("successCount")%> </td></tr></table>
<table><tr><td>���ѵ���:</td><td><%=request.getAttribute("failCount")%> </td></tr></table>
<table><tr><td>���ѰO��:</td><td><%=request.getAttribute("failRec").equals("")?"N/A":request.getAttribute("failRec")%></td></tr></table>
<table><tr><td>�`��� : <%=request.getAttribute("totalCount")%> </td></tr></table>
<% } %>
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</html>