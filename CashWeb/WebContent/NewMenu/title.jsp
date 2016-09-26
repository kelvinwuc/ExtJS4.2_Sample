<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%
GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
boolean isAEGON401 = (globalEnviron.getActiveAS400DataSource().equals(Constant.CAPSIL_DATA_SOURCE_AEGON401));
%>
<HTML>
<HEAD>
<TITLE>Title</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
var iInterval = "";

function ShowTitle(strTitle,strProgId)
{
	if( iInterval != "")
	{
		window.clearInterval(iInterval);
		iInterval = "";
	}

	var elmChild = document.getElementById("thisTitle").childNodes.item(0);
	if( elmChild != null )
		document.getElementById("thisTitle").removeChild(elmChild);
	var elmText = document.createTextNode(strTitle);
	document.getElementById("thisTitle").appendChild(elmText);
}
//-->
</SCRIPT>
</HEAD>
<BODY id="MainBody" style="margin: 0px">
<TABLE height="33%" width="100%" bgcolor="#DEEAF8" cellspacing="0"	cellpadding="0" border="0">
	<TBODY>
<% if(isAEGON401) { %>
		<TR align="center">
			<TD colspan="2"><FONT size="2" Style="color:blue;font-weight:bolder;">¡° CASH ´ú¸ÕÀô¹Ò¡G<%=globalEnviron.getAS400DbUserIdAEGON401()%></FONT></TD>
		</TR>
<% } %>
	</TBODY>
</TABLE>
<TABLE height="67%" width="100%" bgcolor="#DEEAF8" cellspacing="0"	cellpadding="0" border="0">
	<TR Style="height: 35">
		<TD width="100%" valign="bottom" align="center" bgcolor="#DEEAF8" cellspacing="0" cellpadding="0" Style="vertical-align: bottom">
			<FONT id="thisTitle" style="font-weight: bold; color: #000099; vertical-align: bottom; font-size: 18px"	align="center" valign="bottom">&nbsp;</FONT>
		</TD>
	</TR>
	<TR Style="height: 25">
		<TD width="100%" nowrap valign="top" align="right" bgcolor="#DEEAF8" cellspacing="0" cellpadding="0" Style="top: 0; margin-top: 0; padding-top: 0">
		</TD>
	</TR>
</TABLE>
</BODY>
</HTML>
