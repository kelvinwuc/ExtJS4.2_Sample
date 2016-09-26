<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.aegon.balchkrpt.BalanceRptVO"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 銀行對帳彙總表(各銀行未銷已銷帳彙總表)
 * 
 * Remark   : 對帳報表
 * 
 * Revision : $Revision: 1.6 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: BalDayRptC_1.jsp,v $
 * Revision 1.6  2013/12/24 03:34:02  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */
%><%! String strThisProgId = "BalDayRptC"; //本程式代號 %><%
Vector v = new Vector();
String strENTAMT1 ="";
String strENTAMT2 ="";
String strENTAMT3 ="";
String strEBKRMD_S1="";
String strEBKRMD_S2="";
String strEBKRMD_S3="";
String strEBKRMD_E1="";
String strEBKRMD_E2="";
String strEBKRMD_E3="";
String strEAEGDT_S1="";
String strEAEGDT_S2="";
String strEAEGDT_S3="";
String strEAEGDT_E1="";
String strEAEGDT_E2="";
String strEAEGDT_E3="";
if(request.getAttribute("VO")!=null) {
	v = (Vector)request.getAttribute("VO");
}
if(request.getAttribute("ENTAMT1")!=null) {
	strENTAMT1 = (String)request.getAttribute("ENTAMT1");  
}
if(request.getAttribute("ENTAMT2")!=null){
	strENTAMT2 = (String)request.getAttribute("ENTAMT2");  
}
if(request.getAttribute("ENTAMT3")!=null){
	strENTAMT3 = (String)request.getAttribute("ENTAMT3");  
}
if(request.getAttribute("EBKRMD_S1")!=null){
	strEBKRMD_S1 = (String)request.getAttribute("EBKRMD_S1");  
}
if(request.getAttribute("EBKRMD_S2")!=null){
	strEBKRMD_S2 = (String)request.getAttribute("EBKRMD_S2");  
}
if(request.getAttribute("EBKRMD_S3")!=null){
	strEBKRMD_S3 = (String)request.getAttribute("EBKRMD_S3");  
}
if(request.getAttribute("EBKRMD_E1")!=null){
	strEBKRMD_E1 = (String)request.getAttribute("EBKRMD_E1");  
}
if(request.getAttribute("EBKRMD_E2")!=null){
	strEBKRMD_E2 = (String)request.getAttribute("EBKRMD_E2");  
}
if(request.getAttribute("EBKRMD_E3")!=null){
	strEBKRMD_E3 = (String)request.getAttribute("EBKRMD_E3");  
}
if(request.getAttribute("EAEGDT_S1")!=null){
	strEAEGDT_S1 = (String)request.getAttribute("EAEGDT_S1");  
}
if(request.getAttribute("EAEGDT_S2")!=null){
	strEAEGDT_S2 = (String)request.getAttribute("EAEGDT_S2");  
}
if(request.getAttribute("EAEGDT_S3")!=null){
	strEAEGDT_S3 = (String)request.getAttribute("EAEGDT_S3");  
}
if(request.getAttribute("EAEGDT_E1")!=null){
	strEAEGDT_E1 = (String)request.getAttribute("EAEGDT_E1");  
}
if(request.getAttribute("EAEGDT_E2")!=null){
	strEAEGDT_E2 = (String)request.getAttribute("EAEGDT_E2");  
}
if(request.getAttribute("EAEGDT_E3")!=null){
	strEAEGDT_E3 = (String)request.getAttribute("EAEGDT_E3");  
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>各銀行未銷已銷帳彙總表</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script language="javaScript">
<!--
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry_1, '');
	window.status = "";
}
/* 當toolbar frame 中之[離開]按鈕被點選時,本函數會被執行 */
function exitAction()
{
	window.location.href= "<%=request.getContextPath()%>/BalChkRpt/BalDayRptC.jsp?";
}
//-->
</script>
</HEAD>
<body bgcolor="#ffffff" ONLOAD="WindowOnLoad();">
未銷帳-----匯款日:<%=strEBKRMD_S1%> ~ <%=strEBKRMD_E1%>;全球入帳日:<%=strEAEGDT_S1%> ~ <%=strEAEGDT_E1%><br>
已銷帳(1)--匯款日:<%=strEBKRMD_S2%> ~ <%=strEBKRMD_E2%>;全球入帳日:<%=strEAEGDT_S2%> ~ <%=strEAEGDT_E2%><br>
已銷帳(2)--匯款日:<%=strEBKRMD_S3%> ~ <%=strEBKRMD_E3%>;全球入帳日:<%=strEAEGDT_S3%> ~ <%=strEAEGDT_E3%><br> 
<%if(v.size()>0){%>
<TABLE width="800" border=1>
	<THEAD>
		<TR>
			<TD>NO.</TD>
			<TD align="center" width="207">金融單位代碼</TD>
			<TD align="center" width="148">帳號</TD>
			<TD align="center" width="50">幣別</TD>
			<TD align="center" width="142">未銷帳</TD>
			<TD align="center">已銷帳(1)</TD>
			<TD align="center" width="99">已銷帳(2)</TD>
		</TR>
	</THEAD>
	<TBODY>
<%	BalanceRptVO vo = null;
	for(int index = 0 ; index<v.size() ; index++) {
		vo = (BalanceRptVO) v.get(index);
%>
		<TR>
			<TD><%=index+1%></TD>
			<TD><%=vo.getBKNAME()%></TD>
			<TD><%=vo.getBKCODE()%>-<%=vo.getBKATNO()%></TD>
			<TD WIDTH=10><%=vo.getBKCURR()%></TD>
			<TD align="right"><%=vo.getAMT1()%></TD>
			<TD align="right"><%=vo.getAMT2()%></TD>
			<TD align="right"><%=vo.getAMT3()%></TD>
		</TR>
<%	}%>
	</TABLE>
</TABLE>
<%	}%>
</body>
</html>