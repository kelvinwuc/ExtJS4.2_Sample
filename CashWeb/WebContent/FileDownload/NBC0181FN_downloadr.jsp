<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393     Leo Huang    			2010/09/20          ������|��۹���|
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
		<h1><FONT color="#0000ff">�@�ȰU�����ڬɭ������ɧ@�~</FONT></h1>
		</td>
	</tr>

	<tr>
		<td>�T�� : ���ɦ��\</td>
	</tr>
	<tr>
		<td>���ɵ��� : <%= (String)request.getAttribute("servletparam") %></td>
	</tr>
    
	<tr>
		<td>�ФU���ɮ� : 
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
