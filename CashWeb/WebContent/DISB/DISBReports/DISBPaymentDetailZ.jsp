<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393     Leo Huang    			2010/09/23          ������|��۹���|
 *  =============================================================================
 */
%>
<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.disbreports.CAPPAYReportVO"%>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.DbFactory" %>

<%//R00393%>
<!--# include virtual="/Logon/Init.inc"-->
<!--# include virtual="/Logon/CheckLogonDISB.inc"-->
<!--
/*
 * System   : 
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.2 $
 * 
 * Author   :  ODIN  TSAI
 * 
 * Create Date : $Date: 2010/11/23 02:51:38 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPaymentDetailZ.jsp,v $
 * Revision 1.2  2010/11/23 02:51:38  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.1  2007/04/20 04:00:37  MISODIN
 * R60713 FOR AWD
 *
 *
 *  
 */
-->
<%! 
String strThisProgId = "DISBPaymentNoticeZ"; //���{���N��
DecimalFormat df = new DecimalFormat("#.00");
%>
<%
Vector vo = (Vector)request.getAttribute("payments");
String strReturnMessage = "";
if(request.getAttribute("txtMsg") !=null){
	strReturnMessage = (String)request.getAttribute("txtMsg") ;
}else{
   strReturnMessage="";
}

%>
<HTML>
<HEAD>
<TITLE>���I�q���ѹ�I�s</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">

// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() {
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;	
}

</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<form action=""	id="frmMain" method="post" name="frmMain">
<TABLE id="tbl" border="0" cellpadding="0" cellspacing="0" width="840">
	<TBODY>
		<TR>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="64"><B><FONT size="2" face="�ө���">�O�渹�X</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="77"><B><FONT size="2" face="�ө���">�n�O�H</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="71"><B><FONT size="2" face="�ө���">�Q�O�H</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="56" width="65"><FONT size="2" face="�ө���"><B>��J��</B></FONT></TD>
			<TD bgcolor="#c0c0c0"
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="56" width="65"><FONT size="2" face="�ө���"><B>��J��</B></FONT></TD>
		</TR>
		<%for(int index = 0 ; index < vo.size() ; index++){%>
		<%CAPPAYReportVO paymentDetail = (CAPPAYReportVO)vo.get(index); %>

		<TR>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="64">
				<!--R00393  edit by Leo Huang start
				<a href="/CashWeb/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=queryNoticeZ&PNO=<%=paymentDetail.getPNO()%>" target="_parent">
				-->
				<a href="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=queryNoticeZ&PNO=<%=paymentDetail.getPNO()%>" target="_parent">
				<!--R00393  edit by Leo Huang end-->
				<%=paymentDetail.getPOLICYNO()%>&nbsp;
				</a></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="68">&nbsp;<%=paymentDetail.getAPPNM()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="77">&nbsp;<%=paymentDetail.getINSNM()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="71">&nbsp;<%=paymentDetail.getUPDDT()%></TD>
			<TD
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="35" width="67">&nbsp;<%=paymentDetail.getUPDUSR()%></TD>
		</TR>
		<%}%>		
</TABLE>
<INPUT name="txtPaySeq" id="txtPaySeq" type="hidden" value=""> 
<INPUT	name="txtAction" id="txtAction" type="hidden" value="<%=request.getParameter("txtAction")%>"> 
<INPUT name="txtMsg" id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>