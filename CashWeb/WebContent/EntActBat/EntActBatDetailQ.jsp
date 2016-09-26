<!--
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393     Leo Huang    			2010/09/21         絕對路徑轉相對路徑
 *    R00231     Leo Huang    			2010/09/27         民國百年專案
 *  =============================================================================
 */
 -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page 
language="java"
contentType="text/html; charset=BIG5"
pageEncoding="BIG5"
%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ include file="../Logon/Init.inc" %>
<%@ include file="../Logon/CheckLogon.inc" %>
<%! String strThisProgId = "FileUpload";  
 String ActionTarget = "servlet/EntActBatSaveS";%>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="../Theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>CASHFileUploadDetail.jsp</TITLE>
</HEAD>
<BODY>
<!--R00393  Edit by Leo Huang (EASONTECH) Start
<FORM NAME="form1" METHOD="post" ACTION="/CashWeb/<%= ActionTarget %>" enctype="multipart/form-data"">
-->
<FORM NAME="form1" METHOD="post" ACTION="../<%= ActionTarget %>" enctype="multipart/form-data"">
<!--R00393  Edit by Leo Huang (EASONTECH) End-->
<TABLE border="1">
	<TBODY>
		<TR>
			<TD colspan="9" bgcolor="#c0c0c0">整批登帳 - 檔案上傳作業</TD>
		</TR>
		<TR bgcolor="#c0c0c0">
			<TD>序號</TD>
			<TD>行庫</TD>
			<TD>帳號</TD>
			<TD>交易日期</TD>			
			<TD align="center">交易金額</TD>
	<!--R70757		<TD align="center">備註</TD>  -->
			<TD align="center"> 摘要</TD>
			<TD>幣別</TD>
		</TR>
<%
    Vector v = (Vector)session.getAttribute("UPLOADFILE");

    for(int i = 0; i < v.size(); i++) {
        Hashtable line = (Hashtable)v.elementAt(i);
        String strFLD0001 = (String)line.get("FLD0001");//行庫
        String strFLD0002 = (String)line.get("FLD0002");//帳號
        //R0023 edit by Leo Huang start  
        String strFLD0003 = (String)line.get("FLD0003");//交易日期
        strFLD0003 = new CommonUtil().checkDateFomat(strFLD0003);
        //R0023 edit by Leo Huang end
        String strFLD0004 = (String)line.get("FLD0004");//備註
        String strFLD0005 = (String)line.get("FLD0005");//正負號
        String strFLD0006 = (String)line.get("FLD0006");//金額
        String strFLD0007 = (String)line.get("FLD0007");//幣別
%>


		<TR>
			<TD bgcolor="#8080ff"><%= i + 1 %></TD>
			<TD align="center"><%= strFLD0001 %></TD>
			<TD align="center"><%= strFLD0002 %></TD>
			<TD align="center"><%= strFLD0003 %></TD>
			<TD align="right"><%= strFLD0005 %><%= strFLD0006 %></TD>
			<TD><%= strFLD0004 %></TD>
			<TD><%= strFLD0007 %></TD>
		</TR>
		<%
		       }
        %>
	</TBODY>
</TABLE>
<INPUT TYPE="SUBMIT" NAME="BUTTON" VALUE="上傳" >
</FORM>
</BODY>
</HTML>
