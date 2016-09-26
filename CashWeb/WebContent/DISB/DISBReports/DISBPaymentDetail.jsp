<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.aegon.disb.disbremit.CAPPaymentVO"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : ���I�q����
 * 
 * Remark   : �ק�/����
 * 
 * Revision : $Revision: 1.5 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2013/12/24 03:58:54 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPaymentDetail.jsp,v $
 * Revision 1.5  2013/12/24 03:58:54  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.4  2012/08/29 09:18:44  ODCKain
 * Character problem
 *
 * Revision 1.3  2012/08/27 04:22:11  ODCZheJun
 * update for add the display time
 *
 * Revision 1.2  2010/11/23 02:51:37  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.1.2.3  2005/04/04 07:02:20  miselsa
 * R30530 ��I�t��
 *  
 */
%><%! String strThisProgId = "DISBPaymentNotice"; //���{���N��%><%
Vector vo = (Vector)request.getAttribute("payments");
String strReturnMessage = (request.getAttribute("txtMsg") !=null)?(String)request.getAttribute("txtMsg"):"";
DecimalFormat df = new DecimalFormat("#.00");
%>
<HTML>
<HEAD>
<TITLE>���I�q����</TITLE>
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
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() {
	if( document.getElementById("txtMsg").value != "" )
		window.alert(document.getElementById("txtMsg").value) ;	
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action=""	id="frmMain" method="post" name="frmMain">
<TABLE id="tbl" border="0" cellpadding="0" cellspacing="0" width="840">
	<TBODY>
		<TR>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="64"><B><FONT size="2" face="�ө���">�O�渹�X</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="68"><B><FONT size="2" face="�ө���">�n�O�Ѹ��X</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="77"><B><FONT size="2" face="�ө���">���ڤH�m�W</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="71"><B><FONT size="2" face="�ө���">���ڤHID</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="82"><B><FONT size="2" face="�ө���">��I���B</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="56" width="67"><FONT size="2" face="�ө���"><B>�I�ڤ��e</B></FONT></TD>
			<TD bgcolor="#c0c0c0"
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="56" width="65"><FONT size="2" face="�ө���"><B>�@�o�_</B></FONT></TD>
			<TD bgcolor="#c0c0c0"
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="56" width="65"><FONT size="2" face="�ө���"><B>���_</B></FONT></TD>
			<TD bgcolor="#c0c0c0"
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="56" width="65"><FONT size="2" face="�ө���"><B>��J��</B></FONT></TD>
			<TD bgcolor="#c0c0c0"
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="56" width="65"><FONT size="2" face="�ө���"><B>��J��</B></FONT></TD>
		</TR>
<%  CAPPaymentVO paymentDetail = null;
	for(int index = 0 ; index < vo.size() ; index++) { 
		paymentDetail = (CAPPaymentVO)vo.get(index); %>
		<TR>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64">
				<a href="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=queryNotice&PNO=<%=paymentDetail.getPNO()%>" target="_parent"><%=paymentDetail.getPolicyNo()%>&nbsp;</a>
			</TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="68">&nbsp;<%=paymentDetail.getAppNo()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="77">&nbsp;<%=paymentDetail.getPName()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="71">&nbsp;<%=paymentDetail.getPId()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="82" id="PAMT" align="right"><%=df.format(paymentDetail.getPAMT())%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="67">&nbsp;<%=paymentDetail.getPDesc()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="65"><%=("Y".equals(paymentDetail.getPVoidable())?"�O":"�_")%>&nbsp;</TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="65"><%=("Y".equals(paymentDetail.getPDispatch())?"�O":"�_")%>&nbsp;</TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="35" width="67">&nbsp;<%=paymentDetail.getEntryUsr()%></TD>
			<TD style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="35" width="67">&nbsp;<%=paymentDetail.getEntryDt()%></TD>
		</TR>
<%	} %>		
</TABLE>
<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=request.getParameter("txtAction")%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>