<%@ page contentType="text/html;charset=Big5" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>
<HTML>
<HEAD>

<%@ include file="../Logon/Init.inc" %>
<%@ include file="../Logon/CheckLogon.inc" %>

<%! String strThisProgId = "FileDownload";  %>

<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>�@�ȰU�����ɭ��ɤU��</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientR.js"></SCRIPT>

<SCRIPT>
function WindowOnLoad() 
{
	strFunctionKeyInitial = "";			//
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "";
	
}
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad()">

<form name="pass" method="POST" action="../servlet/NBC0181FNDownload">
<table border="1">
	<TR>
		<TD><H1><FONT color="#0000ff">�@�ȰU�����ڬɭ������ɧ@�~</FONT></H1></TD>
	</TR>
	
	<TR>
		<TD><input type="submit" value="�T�{"></TD>
	</TR>
</table>
</form>





</BODY>
</HTML>
