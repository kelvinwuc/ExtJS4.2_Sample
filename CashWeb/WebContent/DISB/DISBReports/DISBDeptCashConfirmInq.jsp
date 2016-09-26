<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 現金支付
 * 
 * Remark   : 出納功能
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : Ariel Wei
 * 
 * Create Date : 2014/05/07
 * 
 * Request ID  : RC0036
 * 
 * CVS History:
 * 
 * Revision 1.3  2015/10/14 Kelvin Wu
 * RD0460 
 * 
 * $Log: DISBDeptCashConfirmInq.jsp,v $
 * Revision 1.3  2015/10/14 05:56:50  001946
 * *** empty log message ***
 *
 * Revision 1.2  2014/08/25 02:17:49  missteven
 * RC0036-3
 *
 * Revision 1.1  2014/07/18 07:34:41  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 *  
 */
%><%! String strThisProgId = "DISBDeptCashConfirm"; //本程式代號 %><%
GlobalEnviron globalEnviron =(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String preWorkDate = String.valueOf(disbBean.GetPreWorkDay(commonUtil.convertWesten2ROCDate1(calendar.getTime())));
String strPreDate = preWorkDate.substring(0,3) + "/" + preWorkDate.substring(3,5) + "/" + preWorkDate.substring(5);

String strMsg = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
String strCount = (request.getAttribute("rowCount") != null)?(String)request.getAttribute("rowCount"):"";
String strAmt = (request.getAttribute("totalAmt") != null)?(String)request.getAttribute("totalAmt"):"";

//request.removeAttribute("txtMsg");
//request.removeAttribute("rowCount");
//request.removeAttribute("totalAmt");

if(request.getAttribute("msg") != null) {
	strMsg = (String)request.getAttribute("msg");
}

if(request.getAttribute("rowCount") != null) {
	strMsg = "匯款總件數 : "+request.getAttribute("rowCount");
	strMsg += "\n匯款總金額 : "+ Double.valueOf((String)request.getAttribute("totalAmt")).doubleValue();
	strMsg += "\n匯款批號 : " +request.getAttribute("batNo");
}
//if(request.getAttribute("txtMsg") != null) {
//	strMsg = (String)request.getAttribute("txtMsg");
//}


%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>週轉金撥補</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
    if( document.getElementById("txtMsg").value != "") {
		window.alert(document.getElementById("txtMsg").value);
	}
    WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
	//WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
	window.status = "";
}

function inquiryAction()
{
	document.getElementById("txtAction").value = "I";
	document.getElementById("txtStartDate").value = rocDate2String(document.getElementById("pDate1").value) ;
	document.getElementById("txtEndDate").value = rocDate2String(document.getElementById("pDate2").value) ;
	document.frmMain.submit();
}


function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBDeptCashConfirmInq.jsp";
}

</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBDeptCashConfirmServlet" id="frmMain" method="post" name="frmMain">
<INPUT type="hidden" id="txtStartDate" name="txtStartDate" value=""> 
<INPUT type="hidden" id="txtEndDate" name="txtEndDate" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
<TABLE border="1" width="452" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="121">支付確認日：</TD>
			<TD width="323">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="pDate1" name="pDate1" value="<%=strPreDate%>" > 
				<a href="javascript:show_calendar('frmMain.pDate1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> ~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="pDate2" name="pDate2" value="<%=strPreDate%>"> 
				<a href="javascript:show_calendar('frmMain.pDate2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
			</TD>
		</TR>

 	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
<INPUT type="hidden" id="txtCount" name="txtCount" value="<%=strCount%>">
<INPUT type="hidden" id="txtAmt" name="txtAmt" value="<%=strAmt%>">
</FORM>

</BODY>
</HTML>