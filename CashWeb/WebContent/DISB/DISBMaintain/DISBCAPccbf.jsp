<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : �ꤺ������
 * 
 * Remark   : �޲z�t��-�]��
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
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 *
 * Revision 1.5  2012/06/18 09:35:40  MISSALLY
 * QA0132-�����ɮפ� SWIFT CODE�ɮ׺��@
 * 1.�\��u�s�W����X�v�W�[�ˮ֤��o���ŭȡC
 * 2.�\��u����Ȧ��ɡv
 *    2.1��~SWIFT CODE�e�����áC
 *    2.2�W�[�ˮ֤��o�W�Ǫ��ɡC
 *    2.3�W�[�ˮ֪���N�X���ץ�����7��Ʀr�A�_�h��ܥ��Ѫ��O���F�Y����ɦ����~�T���h��������s�A�B��ܥ��Ѫ��O���C
 *
 *  
 */
%><%!String strThisProgId = "DISBCAPccbf"; //���{���N��%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�޲z�t��--����Ȧ���</TITLE>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
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
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBCAPccbf.jsp";
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
<BODY ONLOAD="WindowOnLoad();">
<FORM ENCTYPE="multipart/form-data" id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBCAPccbfServlet">
<TABLE border="1" width="450" id="tbArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">�ɮצW�١G</TD>
			<TD><INPUT TYPE="FILE" id="UPFILE" name="UPFILE"></TD>
		</TR>
	</TBODY>
</TABLE>
<BR>
<% if(!strReturnMessage.equals("")) { %>
<BR>
<div id="divMsgArea">
<table><tr><td>�s�W���\����:</td><td><%=request.getAttribute("insertCount")%> </td></tr></table>
<table><tr><td>��s���\����:</td><td><%=request.getAttribute("successCount")%> </td></tr></table>
<table><tr><td>���ѵ���:</td><td><%=request.getAttribute("failCount")%> </td></tr></table>
<table><tr><td>���ѰO��:</td><td><%=request.getAttribute("failRec")!=null?request.getAttribute("failRec"):"N/A"%></td></tr></table>
<table><tr><td>�`��� : <%=request.getAttribute("totalCount")%> </td></tr></table>
</div>
<% } %>
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>