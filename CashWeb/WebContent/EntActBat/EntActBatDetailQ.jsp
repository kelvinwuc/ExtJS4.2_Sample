<!--
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393     Leo Huang    			2010/09/21         ������|��۹���|
 *    R00231     Leo Huang    			2010/09/27         ����ʦ~�M��
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
			<TD colspan="9" bgcolor="#c0c0c0">���n�b - �ɮפW�ǧ@�~</TD>
		</TR>
		<TR bgcolor="#c0c0c0">
			<TD>�Ǹ�</TD>
			<TD>��w</TD>
			<TD>�b��</TD>
			<TD>������</TD>			
			<TD align="center">������B</TD>
	<!--R70757		<TD align="center">�Ƶ�</TD>  -->
			<TD align="center"> �K�n</TD>
			<TD>���O</TD>
		</TR>
<%
    Vector v = (Vector)session.getAttribute("UPLOADFILE");

    for(int i = 0; i < v.size(); i++) {
        Hashtable line = (Hashtable)v.elementAt(i);
        String strFLD0001 = (String)line.get("FLD0001");//��w
        String strFLD0002 = (String)line.get("FLD0002");//�b��
        //R0023 edit by Leo Huang start  
        String strFLD0003 = (String)line.get("FLD0003");//������
        strFLD0003 = new CommonUtil().checkDateFomat(strFLD0003);
        //R0023 edit by Leo Huang end
        String strFLD0004 = (String)line.get("FLD0004");//�Ƶ�
        String strFLD0005 = (String)line.get("FLD0005");//���t��
        String strFLD0006 = (String)line.get("FLD0006");//���B
        String strFLD0007 = (String)line.get("FLD0007");//���O
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
<INPUT TYPE="SUBMIT" NAME="BUTTON" VALUE="�W��" >
</FORM>
</BODY>
</HTML>
