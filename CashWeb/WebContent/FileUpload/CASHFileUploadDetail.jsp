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
<%! String strThisProgId = "FileUpload";  %>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="../Theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>CASHFileUploadDetail.jsp</TITLE>
</HEAD>
<BODY>

<FORM NAME="form1" METHOD="post" ACTION="CASHFileUploadReport.jsp"><TABLE border="1">
	<TBODY>
		<TR>
			<TD colspan="9" bgcolor="#c0c0c0">支票託收兌現 - 檔案上傳作業</TD>
		</TR>
		<TR bgcolor="#c0c0c0">
			<TD>序號</TD>
			<TD>銷帳記號</TD>
			<TD>票據收受日期</TD><TD align="center">票據號碼</TD><TD align="center">存款帳號</TD><TD align="center">票據金額</TD><TD>票據收妥到期日</TD><TD>票據到期日</TD><TD>備註</TD>
			
			
			
			
			
		</TR>
<%
    Vector v = (Vector)session.getAttribute("UPLOADFILE");

    for(int i = 0; i < v.size(); i++) {
        Hashtable line = (Hashtable)v.elementAt(i);
        String strFLD0001 = (String)line.get("FLD0001");
        String strFLD0002 = (String)line.get("FLD0002");
        String strFLD0003 = (String)line.get("FLD0003");
        String strFLD0004 = (String)line.get("FLD0004");
        String strFLD0005 = (String)line.get("FLD0005");
        String strFLD0006 = (String)line.get("FLD0006");
        String strFLD0007 = (String)line.get("FLD0007");
        String strFLD0008 = (String)line.get("FLD0008");
%>


		<TR>
			<TD bgcolor="#8080ff"><%= i + 1 %></TD>
			<TD><% if(strFLD0008.equals("1")) {
			                     %>兌現<%
			                 } else if(strFLD0008.equals("2")) {
			                     %>退票<%
			                 } else if(strFLD0008.equals("3")) {
			                     %>領回<%
			                 } %></TD>
			<TD align="center">
			<% String receiveDate = Integer.parseInt(strFLD0001.substring(0, 4)) + "/"+ strFLD0001.substring(4, 6) + "/" +strFLD0001.substring(6, 8); %>
			<%= receiveDate %>
			</TD>
			<TD align="center"><%= strFLD0002 %></TD>
			<TD><%= strFLD0003 %></TD>
			<TD align="right"><% int s = 0;
			                 int e = s+1;
			                 String value = "";
			                 while(strFLD0004.substring(s, e).equals("0")) {
			                     value = strFLD0004.substring(e);
			                     s++;
			                     e++;
			                 }
			                 if(value.equals("")) {
			                     value = "0.00";
			                 } else {
			                     value = value.substring(0, value.length() -2)+"."+value.substring(value.length() -2);
			                 }
			            %>
			            <%= value %>
			</TD>
			<TD align="center">
            <% String resafeDate = Integer.parseInt(strFLD0005.substring(0, 4)) + "/"+ strFLD0005.substring(4, 6) + "/" +strFLD0005.substring(6, 8); %>
			<%= resafeDate %>
			</TD>
			<TD align="center">
            <% String expireDate = Integer.parseInt(strFLD0006.substring(0, 4)) + "/"+ strFLD0006.substring(4, 6) + "/" +strFLD0006.substring(6, 8); %>
			<%= expireDate %>
			</TD>
			<TD><%= strFLD0007 %></TD>
		</TR>
		<%
		       }
        %>
	</TBODY>
</TABLE>
<INPUT TYPE="SUBMIT" NAME="BUTTON" VALUE="回上頁" >
</FORM>
</BODY>
</HTML>
