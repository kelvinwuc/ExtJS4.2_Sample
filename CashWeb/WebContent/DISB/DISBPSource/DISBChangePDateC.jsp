<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CASHWEB
 * 
 * Function : 修改付款日-查詢
 * 
 * Remark   : 因應農曆過年假期較長，付款日為假期期間的支付案件提早給付
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $Date: 2013/11/11 02:15:08 $
 * 
 * Request ID : E10210
 * 
 * CVS History:
 * 
 * $Log: DISBChangePDateC.jsp,v $
 * Revision 1.3  2013/11/11 02:15:08  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.2  2012/08/29 02:57:50  ODCKain
 * Calendar problem
 *
 * Revision 1.1  2012/01/11 07:02:37  MISSALLY
 * E10210
 * 修改CASH系統，因BATCH所產生各項給付金的付款日
 *
 *  
 */
%><%! String strThisProgId = "ChangePDate"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();

String strAction = (request.getAttribute("txtAction") != null) ? (String) request.getAttribute("txtAction") : "";
String strMsg = (request.getAttribute("txtMsg") != null) ? (String) request.getAttribute("txtMsg") : "";
String strUserRight = (session.getAttribute("LogonUserRight") != null) ? CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")) : "";
String strPNOList = (request.getAttribute("aryPNO") != null) ? CommonUtil.AllTrim((String) request.getAttribute("aryPNO")) : "";
strPNOList = (!strPNOList.equals("")) ? strPNOList.substring(1) : "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>修改付款日</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" )
		alert(document.getElementById("txtMsg").value);

	if( document.getElementById("txtUserRight").value == "79" )
	{
		alert("無執行此功能權限!!");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else if( document.getElementById("txtAction").value == "Report" )
	{
		var varSql = "SELECT PNO,CASE PMETHOD WHEN 'A' THEN '支票' WHEN 'B' THEN '台幣匯款' WHEN 'C' THEN '信用卡' WHEN 'D' THEN '外幣匯款' ELSE '' END as PMETHOD,PDATE,PNAME,PID,PCURR,PAMT,PSRCCODE,PDESC,POLICYNO ";
		varSql += "FROM CAPPAYF ";
		varSql += "WHERE PNO IN (" + document.getElementById("txtPNOList").value + ") ";
		varSql += "ORDER BY PDATE,PID,PNAME,POLICYNO,PSRCCODE ";

		WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
		document.getElementById("ReportSQL").value = varSql;
		document.getElementById("frmMain").action = "<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
	}
	else
	{
		WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
	}

	window.status = "";
}

function inquiryAction()
{
	var strTmpMsg = "";
	if( document.getElementById("txtPDateS").value == "" || document.getElementById("txtPDateE").value == "" ) {
		alert("[付款日期] 不可空白!!");
		return false;
	} else if(document.getElementById("selPMethod").value == "") {
		alert("[付款方式] 不可空白!!");
		return false;
	} else {
		document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPDateS").value);
		document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPDateE").value);
		document.frmMain.submit();
	}
}
//-->
</SCRIPT>
</head>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSChangePDateServlet?action=query">
<TABLE border="1" width="450" id="inqueryArea">
	<TR>
		<TD align="right" class="TableHeading" width="100">來源：</TD>
		<TD>
			<input type="radio" name="rdFromBatch" id="rdFromBatch" value="Y" class="Data" checked>Batch作業 
			<input type="radio" name="rdFromBatch" id="rdFromBatch" value="N" class="Data">線上作業
		</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading" width="100">付款方式：</TD>
		<TD>
			<select id="selPMethod" name="selPMethod" class="Data">
				<option value="">&nbsp;</option>
				<option value="A">支票</option>
				<option value="B">台幣匯款</option>
				<option value="C">信用卡</option>
				<option value="D">外幣匯款</option>
			</select>
		</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading" width="100">付款日期：</TD>
		<TD>
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateS" name="txtPDateS" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtPDateS','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
			</a>
			<INPUT type="hidden" id="txtPStartDate" name="txtPStartDate" value="">
			~ 
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateE" name="txtPDateE" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtPDateE','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
			</a>
			<INPUT type="hidden" id="txtPEndDate" name="txtPEndDate" value=""> 
		</TD>
	</TR>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 

<INPUT type="hidden" id="txtPNOList" name="txtPNOList" value="<%=strPNOList%>">

<INPUT type="hidden" id="ReportName" name="ReportName" value="ChangePayDate.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="ChangePayDate.pdf"> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBPSource\\"> 

</FORM>
</BODY>
</html>