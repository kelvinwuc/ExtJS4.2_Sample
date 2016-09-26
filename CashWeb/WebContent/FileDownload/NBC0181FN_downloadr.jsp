<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393     Leo Huang    			2010/09/20          絕對路徑轉相對路徑
 *  =============================================================================
 */
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page 
language="java"
contentType="text/html; charset=BIG5"
pageEncoding="BIG5"
%>
<%@ include file="../Logon/Init.inc" %>
<%@ include file="../Logon/CheckLogon.inc" %>
<%! String strThisProgId = "FileDownload";  %>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="../Theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>NBC181r.jsp</TITLE>
</HEAD>
<BODY>
<table border="1" >
	<tr>
		<td>
		<h1><FONT color="#0000ff">一銀託收票據界面檔轉檔作業</FONT></h1>
		</td>
	</tr>

	<tr>
		<td>訊息 : 轉檔成功</td>
	</tr>
	<tr>
		<td>轉檔筆數 : <%= (String)request.getAttribute("servletparam") %></td>
	</tr>
    
	<tr>
		<td>請下載檔案 : 
		<% if (!request.getAttribute("servletparam").toString().equals("0"))
		{%>
		<!-- R00393  Edit by Leo Huang (EASONTECH) Start
		<A HREF="/CashWeb/download/TRF8.dat">TRF8.dat</A> 
		-->
		<A HREF="../download/TRF8.dat">TRF8.dat</A> 
		<!--R00393   Edit by Leo Huang (EASONTECH) Start-->
		
		<%}%>
		</td>
	</tr></table>
</BODY>
</HTML>
