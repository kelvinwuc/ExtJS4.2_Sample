<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 付現明細表
 * 
 * Remark   : 支付報表
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : 2013/11/12
 * 
 * Request ID  : RB0302
 * 
 * CVS History:
 * 
 * $Log: DISBCashReport.jsp,v $
 * Revision 1.1  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 *  
 */
%><%! String strThisProgId = "DISBCashReport"; //本程式代號 %><%
GlobalEnviron globalEnviron =(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String strUserDept = (session.getAttribute("LogonUserDept") != null)?(CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept"))):"";

List alPBBankP = null;

if (session.getAttribute("PBBankListP") == null) {
	alPBBankP = (List) disbBean.getETable("PBKAT", "BANKP");
	session.setAttribute("PBBankListP",alPBBankP);
} else {
	alPBBankP =(List) session.getAttribute("PBBankListP");
}
if (session.getAttribute("PBBankListP") != null) {
	session.removeAttribute("PBBankListP");
}

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

StringBuffer sbBankCode = new StringBuffer();
sbBankCode.append("<option value=\"\">&nbsp;</option>");
if (alPBBankP.size() > 0) {
	for (int i = 0; i < alPBBankP.size(); i++) {
		htTemp = (Hashtable) alPBBankP.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>現金支付明細表</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientR.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
// *************************************************************
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if(document.getElementById("txtUserDept").value != "FIN") {
		alert("無執行此報表權限");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	} else {
		WindowOnLoadCommon( document.title, '', strFunctionKeyReport, '' );
	}
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	document.forms("frmMain").reset();
}

/* 當toolbar frame 中之<報表>按鈕被點選時,本函數會被執行 */
function printRAction()
{
	if(document.getElementById("pDate1").value == "" || document.getElementById("pDate2").value == "") 
	{
		alert("『出納確認日』不得為空白!!");
		return false;
	}

	mapValue();
	getReportInfo();

	if (document.frmMain.rdReportForm[0].checked) {
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DISBCashReport.pdf";
	} else {
		document.frmMain.OutputType.value = "TXT";
		document.frmMain.OutputFileName.value = "DISBCashReport.rpt";
	}

	document.getElementById("frmMain").target="_blank";
	document.getElementById("frmMain").submit();
}

function getReportInfo()
{
	var strSql = "";
	strSql = "SELECT a.PBBANK,a.PBACCOUNT,a.POLICYNO,a.PNAME,a.PSRCCODE,substring(b.FLD0004,8,6) as PDESC,a.PAMT,a.PCFMDT2,a.PCSHCM ";
	strSql += "FROM CAPPAYF a ";
	strSql += "JOIN ORDUET b ON b.FLD0001='  ' and b.FLD0002='PAYCD' and b.FLD0003=a.PSRCCODE ";
	strSql += "WHERE PMETHOD='E' and PAMT>0 and PVOIDABLE<>'Y' ";
	strSql += "and PCSHCM between " + document.getElementById("para_DateS").value + " and " + document.getElementById("para_DateE").value + " ";

	if(document.getElementById("selPBBANK").value != "") {
		strSql += " and a.PBBANK='" + document.getElementById("txtPBBank").value + "' ";
		strSql += " and a.PBACCOUNT='" + document.getElementById("txtPBAccount").value + "' ";
	}

	strSql += "ORDER BY a.PBBANK,a.PBACCOUNT,a.POLICYNO ";

	document.getElementById("ReportSQL").value = strSql;
}
function mapValue()
{
	document.getElementById("para_DateS").value = rocDate2String(document.getElementById("pDate1").value) ;
	document.getElementById("para_DateE").value = rocDate2String(document.getElementById("pDate2").value) ;
	var BankAccount = document.getElementById("selPBBANK").value ;
	if(BankAccount != "")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);	
	}  
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain" method="post" name="frmMain">
<INPUT type="hidden" id="txtPBBank" name="txtPBBank" value="">
<INPUT type="hidden" id="txtPBAccount" name="txtPBAccount" value="">
<TABLE border="1" width="452" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="180">請選擇報表格式：</TD>
			<TD width="305">
				<input type="radio" name="rdReportForm" id="rdReportForm" value="PDF" class="Data" checked>PDF 
				<input type="radio" name="rdReportForm" id="rdReportForm" value="RPT" class="Data">RPT
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">出納確認日：</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="pDate1" name="pDate1" > 
				<a href="javascript:show_calendar('frmMain.pDate1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
				<INPUT type="hidden" id="para_DateS" name="para_DateS" value=""> ~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="pDate2" name="pDate2" onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.pDate2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
				<INPUT type="hidden" id="para_DateE" name="para_DateE" value=""> 
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">付款帳號：</TD>
			<TD>
				<SELECT	NAME="selPBBANK" id="selPBBANK" class="Data">
					<%=sbBankCode.toString()%>
				</SELECT> 
			</TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 

<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBCashReport.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBCashReport.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
</FORM>

</BODY>
</HTML>