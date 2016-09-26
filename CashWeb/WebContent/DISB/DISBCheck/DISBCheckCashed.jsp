<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : ���ڦ^�P�@�~
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.5 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckCashed.jsp,v $
 * Revision 1.5  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.4  2012/08/29 09:18:45  ODCKain
 * Character problem
 *
 * Revision 1.3  2010/11/23 02:17:05  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.2  2008/08/18 06:13:39  MISODIN
 * R80338 �վ�Ȧ�b����檺�w�]��
 *
 * Revision 1.1  2006/06/29 09:40:45  MISangel
 * Init Project
 *
 * Revision 1.1.2.4  2005/04/04 07:02:23  miselsa
 * R30530 ��I�t��
 *  
 */
%><%!String strThisProgId = "DISBCheckCashed"; //���{���N��%><%
String strReturnMessage = (request.getAttribute("txtMsg") !=null)?(String)request.getAttribute("txtMsg"):"";

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPBBank = new ArrayList();
alPBBank = (List) disbBean.getETable("PBKAT", "BANK");

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbBankCode = new StringBuffer();
if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		htTemp = (Hashtable) alPBBank.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�䲼�\��--���ڦ^�P�@�~</TITLE>
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
	if( document.getElementById("txtMsg").value == "" && document.getElementById("txtMsg").value ==null)
		window.alert(document.getElementById("txtMsg").value) ;

	document.getElementById("inqueryArea").display = "block"; 
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
	document.getElementById("txtAction").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckCashed.jsp?";
}

/* ��toolbar frame ����<�T�w>���s�Q�I���,����Ʒ|�Q���� */
function confirmAction()
{
	document.forms("frmMain").submit();
}

/* ��toolbar frame ����<�x�s>���s�Q�I���,����Ʒ|�Q���� */
function saveAction()
{
	enableAll();
	mapValue();
	if( areAllFieldsOK() ){	
		document.getElementById("frmMain").submit();
	}else{
		alert( strErrMsg );
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form ENCTYPE="multipart/form-data" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckCashedServlet?action=upload" id="frmMain" method="post" name="frmMain" target="iframe">
<TABLE border="1" width="452" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">�I�ڱb���G</TD>
			<TD width="333">
				<select size="1" name="PBBank" id="PBBank">
					<%=sbBankCode.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�ɮצW�١G</TD>
			<TD><INPUT TYPE="FILE"  name="UPFILE"  id="UPFILE"></TD>
		</TR>
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
<IFRAME name="iframe"  frameborder="0"  width="100%" height="400"/>
</BODY>
</HTML>