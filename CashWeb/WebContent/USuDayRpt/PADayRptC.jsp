<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CASHWEB
 * 
 * Function : RCPP入帳檢核表
 * 
 * Remark   : 對帳報表
 * 
 * Revision : $Revision: 1.2 $
 * 
 * Author   : $Author: MISSALLY $
 * 
 * Create Date :  $Date: 2014/03/19 09:34:03 $
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: PADayRptC.jsp,v $
 * Revision 1.2  2014/03/19 09:34:03  MISSALLY
 * R00135---PA0024---CASH年度專案
 * 新增現金收入日報表顯示無效保單的入帳及RCPP檢核表不鎖定日期
 *
 * Revision 1.1  2014/02/20 10:18:49  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 增加檢核報表
 *
 *
 */
%><%! String strThisProgId = "PADayRpt"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
String strToday = strDateTime.substring(0, 7);  //String strToday = "1030214";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>RCPP入帳檢核表</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title, "", strDISBFunctionKeyInitial, "");
	window.status = "請輸入條件後按查詢鍵";
}

function inquiryAction() 
{
	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "PADailyCas.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "XLS";
		document.frmMain.OutputFileName.value = "PADailyCas.xls";
	}

	getReportInfo();

	document.getElementById("frmMain").target="_blank";
	document.getElementById("frmMain").submit();
}

function getReportInfo()
{
	var strSql = "SELECT a.BKCODE,a.BKATNO,a.BKNAME,a.BKALAT,a.BKCURR,b.FBMACTDT,b.FBMFACAMT,c.FBDPAYAMT,c.FBDREPNO,c.FBDREPSEQ,c.FBDCRTDT,d.PAYAMT,d.PAYIND,d.CRTUSER,d.CRTDATE,d.CASHDTE,d.PAYIND||IFNULL(substring(e.FLD0004,7,8),'') as PAYDESC ";
	strSql += "FROM CAPBNKF a ";
	strSql += "LEFT JOIN ORGNFBM b ON b.FBMACTBNK=a.BKALAT  ";
	strSql += "LEFT JOIN ORGNFBDK1 c ON c.FBDNO=b.FBMNO  ";
	strSql += "LEFT JOIN ORNBTAK1 d ON d.CRTDATE=c.FBDCRTDT+1110000 and d.RECEIPTNO=c.FBDREPNO and d.RECEIPSEQ=c.FBDREPSEQ and d.PAYIND IN ('1','5') and d.CASHBNK=b.FBMACTBNK ";
	strSql += "LEFT JOIN ORDUET e ON e.FLD0001='  ' and e.FLD0002='PAYID' and e.FLD0003=d.PAYIND ";
	strSql += "where c.FBDCRTDT=" + document.getElementById("txtEntryDate").value;
	if(document.getElementById("txtEntryID").value != "") {
		strSql += " and d.CRTUSER='" + document.getElementById("txtEntryID").value + "' ";
	}
	strSql += " ORDER BY d.CRTUSER,a.BKALAT,b.FBMACTDT,b.FBMFACAMT,c.FBDPAYAMT ";

	document.getElementById("ReportSQL").value = strSql;
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<FORM name="frmMain" method="POST" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="1" width="450">
	<TR>
		<TD align="right" class="TableHeading">入帳日期：</TD>
		<TD><INPUT type="text" size="10" maxlength="7" id="txtEntryDate" name="txtEntryDate" value="<%=strToday%>" class="Data"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">CAPSIL輸入者ID：</TD>
		<TD><INPUT type="text" size="10" maxlength="3" id="txtEntryID" name="txtEntryID" value="" class="Data">&nbsp;&nbsp;&nbsp;(空白表示全部)</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">報表格式：</TD>
		<TD>
			<input type="radio" id="rdReportForm" name="rdReportForm" value="PDF" class="Data" checked>PDF 
			<input type="radio" id="rdReportForm" name="rdReportForm" value="XLS" class="Data">EXCEL
		</TD>
	</TR>
</TABLE>

<INPUT type="hidden" id="ReportName" name="ReportName" value="PADayRpt.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="PADayRpt.PDF">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>UsuDayRpt\\">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="">

</FORM>
</BODY>
</HTML>