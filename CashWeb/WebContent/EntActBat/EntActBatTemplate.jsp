<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �Ȧ�W�ǵn�b�榡�]�w
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntActBatTemplate.jsp,v $
 * Revision 1.1  2013/12/24 04:02:15  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */
%><%! String strThisProgId = "EntActBatB"; //���{���N�� %><%
String strMsg = (request.getAttribute("txtMsg") == null)?"":(String)request.getAttribute("txtMsg");
%>
<html>
<head>
<title>�Ȧ�W�ǵn�b�ҪO�j������</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js""></SCRIPT>
<SCRIPT>
<!--
function WindowOnLoad() 
{
	if(document.getElementById("txtMsg").value!=""){
		alert(document.getElementById("txtMsg").value);
	}

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial, '') ;
}

function inquiryAction()
{
	var code = document.getElementById("BKALAT").value;
	if(code == "") {
		alert("����²�X���ର��");
	} else {
		document.frmMain.submit();
	}
}

function addAction()
{
	window.location.href = "<%=request.getContextPath()%>/EntActBat/EntActBatB.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<BR>
<FORM name="frmMain" METHOD="POST" ACTION="<%=request.getContextPath()%>/servlet/com.aegon.entactbat.EntActBatTemplateServlet" >
<div>
	<table>
		<TR>
			<TD>����²�X:*</TD>
			<TD><input type="text" id="BKALAT" name="BKALAT"></TD>
		</TR>
	</table>
</div>
<input type="hidden" id="PAGETYPE" name="PAGETYPE" value="SE" />
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
</FORM>
<BR>*�N����ﶵ�A���ର�ũΤ����<BR>
</BODY>
</HTML>
