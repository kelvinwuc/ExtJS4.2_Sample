<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>

<%!String strThisProgId = "DISBRemitFailReport"; //本程式代號%>
<%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserId")):"";

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar  =commonUtil.getBizDateByRCalendar();
String today = commonUtil.convertWesten2ROCDate(calendar.getTime());

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alCurrCash = new ArrayList(); 
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
}
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"\">&nbsp;</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
}
%>
<HTML>
<HEAD>
<TITLE>退匯明細表</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title, '', '', '' );
	document.getElementById("txtRDateC").value = "<%=today%>";
	window.status = "";
}

/* 
函數名稱:	printRAction()
函數功能:	當toolbar frame 中之報表按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function printRAction()
{
	mapValue();
	window.status = "";
	if (EntryDateVaild()){
		//FIN
		if(document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT"){	
			getReportInfoByFin();
		}else if(document.getElementById("txtUserRight").value >= "89" && document.getElementById("txtUserRight").value < "99"){
			getReportInfoBy89();
		}else{	//每日付款明細表
			getReportInfoBy79();
		}
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
	}
}

function EntryDateVaild()
{
	if (document.getElementById("para_Currency").value == "")
	{
		alert ("請輸入保單幣別");
		return  false;
	}else if (document.getElementById("txtRFDate").value == "")
	{
		alert ("請輸入銀行退匯回存日");
		return  false;
	}else{
		return true;
	}
}
function getReportInfoByFin()
{  
	var strSql = "";
	strSql  = "SELECT A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,A.POLICY_NO,A.APPNO,";
	strSql += " A.ENTRY_USER,B.DEPT AS USERDEPT,A.PDESC,A.PAY_SRC_NAME,C.BKNM,A.PAY_REMIT_ACCOUNT,";
	strSql += " A.PAY_CREDIT_CARD,A.PAY_NO_HISTORY,A.PAY_CURRENCY,A.ENTRY_DATE,A.PAY_PAYCURR,A.PAY_PAYAMT,";
	strSql += " A.PAY_PAYRATE,A.PAY_FEEWAY,A.REMIT_FEE,D.FPAYAMT,D.FFEEWAY,A.REMITFAILD,A.REMITFCODE,";
	strSql += " A.REMITFDESC,A.PBNKRFDT ";
	strSql += " FROM CAPPAYF A ";
	strSql += " left outer join USER B on A.ENTRY_USER =B.USRID ";
	strSql += " left outer join CAPCCBF C on A.PRBANK=C.BKNO ";
	strSql += " left outer join caprfef d on A.PNO=D.FPNOH ";
	strSql += " left outer join (SELECT FPNOH,MAX(ENTRYDT) as ENTRYDT FROM CAPRFEF GROUP BY FPNOH) e on e.FPNOH=d.FPNOH and d.ENTRYDT=e.ENTRYDT ";
	strSql += " WHERE A.PAY_METHOD IN ('B','C','D') AND A.PAY_STATUS = 'A' AND A.PAY_REMITFAIL_DATE <> 0 ";
	//strSql += " AND A.PAY_REMITFAIL_DATE= " + document.getElementById("txtRDate").value;
	strSql += " AND A.BANK_REMITFAIL_DATE= " + document.getElementById("txtRFDate").value;
    strSql += " AND A.PAY_CURRENCY = '" + document.getElementById("para_Currency").value + "' ";
    strSql += " ORDER BY A.ENTRY_USER, A.PAY_METHOD";

	document.frmMain.ReportSQL.value = strSql;
	//document.frmMain.para_PConDate.value = document.getElementById("txtRDate").value ;
	document.frmMain.para_PConDate2.value = document.getElementById("txtRFDate").value ;
}
function getReportInfoBy89()
{  
	var strSql = "";
	strSql  = "SELECT A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,A.POLICY_NO,A.APPNO,";
	strSql += " A.ENTRY_USER,B.DEPT AS USERDEPT,A.PDESC,A.PAY_SRC_NAME,C.BKNM,A.PAY_REMIT_ACCOUNT,";
	strSql += " A.PAY_CREDIT_CARD,A.PAY_NO_HISTORY,A.PAY_CURRENCY,A.ENTRY_DATE,A.PAY_PAYCURR,A.PAY_PAYAMT,";
	strSql += " A.PAY_PAYRATE,A.PAY_FEEWAY,A.REMIT_FEE,D.FPAYAMT,D.FFEEWAY,A.REMITFAILD,A.REMITFCODE,";
	strSql += " A.REMITFDESC,A.PBNKRFDT ";
	strSql += " FROM CAPPAYF A ";
	strSql += " left outer join USER B on A.ENTRY_USER =B.USRID ";
	strSql += " left outer join CAPCCBF C on A.PRBANK=C.BKNO ";
	strSql += " left outer join caprfef d on A.PNO=D.FPNOH ";
	strSql += " left outer join (SELECT FPNOH,MAX(ENTRYDT) as ENTRYDT FROM CAPRFEF GROUP BY FPNOH) e on e.FPNOH=d.FPNOH and d.ENTRYDT=e.ENTRYDT ";
	strSql += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
	strSql += " AND A.PAY_METHOD IN ('B','C','D') AND A.PAY_STATUS = 'A' AND A.PAY_REMITFAIL_DATE <> 0 ";
	strSql += " AND A.PAY_REMITFAIL_DATE= " + document.getElementById("txtRDate").value;
	strSql += " AND A.BANK_REMITFAIL_DATE= " + document.getElementById("txtRFDate").value;
	strSql += " AND A.PAY_CURRENCY = '" + document.getElementById("para_Currency").value + "' ";
    strSql += " ORDER BY A.ENTRY_USER, A.PAY_METHOD";

	document.frmMain.ReportSQL.value = strSql;
	document.frmMain.para_PConDate.value = document.getElementById("txtRDate").value ;
	document.frmMain.para_PConDate2.value = document.getElementById("txtRFDate").value ;
}
function getReportInfoBy79()
{  
	var strSql = "";
	strSql  = "SELECT A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,A.POLICY_NO,A.APPNO,";
	strSql += " A.ENTRY_USER,B.DEPT AS USERDEPT,A.PDESC,A.PAY_SRC_NAME,C.BKNM,A.PAY_REMIT_ACCOUNT,";
	strSql += " A.PAY_CREDIT_CARD,A.PAY_NO_HISTORY,A.PAY_CURRENCY,A.ENTRY_DATE,A.PAY_PAYCURR,A.PAY_PAYAMT,";
	strSql += " A.PAY_PAYRATE,A.PAY_FEEWAY,A.REMIT_FEE,D.FPAYAMT,D.FFEEWAY,A.REMITFAILD,A.REMITFCODE,";
	strSql += " A.REMITFDESC,A.PBNKRFDT ";
	strSql += " FROM CAPPAYF A ";
	strSql += " left outer join USER B on A.ENTRY_USER =B.USRID ";
	strSql += " left outer join CAPCCBF C on A.PRBANK=C.BKNO ";
	strSql += " left outer join caprfef d on A.PNO=D.FPNOH ";
	strSql += " left outer join (SELECT FPNOH,MAX(ENTRYDT) as ENTRYDT FROM CAPRFEF GROUP BY FPNOH) e on e.FPNOH=d.FPNOH and d.ENTRYDT=e.ENTRYDT ";
	strSql += " WHERE  A.ENTRY_USER= '" + document.getElementById("txtUserId").value  + "' ";
	strSql += " AND A.PAY_METHOD IN ('B','C','D') AND A.PAY_STATUS = 'A' AND A.PAY_REMITFAIL_DATE <> 0 ";
	strSql += " AND A.PAY_REMITFAIL_DATE= " + document.getElementById("txtRDate").value;
	strSql += " AND A.BANK_REMITFAIL_DATE= " + document.getElementById("txtRFDate").value;
	strSql += " AND A.PAY_CURRENCY = '" + document.getElementById("para_Currency").value + "' ";
    strSql += " ORDER BY A.ENTRY_USER, A.PAY_METHOD";

	document.frmMain.ReportSQL.value = strSql;
	document.frmMain.para_PConDate.value = document.getElementById("txtRDate").value ;
	document.frmMain.para_PConDate2.value = document.getElementById("txtRFDate").value ;
}
function mapValue() 
{
	document.getElementById("txtRDate").value = rocDate2String(document.getElementById("txtRDateC").value);
	document.getElementById("txtRFDate").value = rocDate2String(document.getElementById("txtRFDateC").value);
}
/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
	}	
	
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain" method="post" name="frmMain">
	<input type="button" value="報  表" name="btnPrint" id="btnPrint" onclick="printRAction();" class="eServiceButton" style="margin: 0px; padding: 0px; height: 27; width: 40;">
	<TABLE border="1" width="452" id=FormArea>
		<TR>
			<TD align="right" class="TableHeading" width="180">請選擇報表格式：</TD>
			<TD width="305">
				<input type="radio" name="rdReportForm" id="rdReportForm" value="PDF" class="Data" checked>PDF 
				<input type="radio" name="rdReportForm" id="rdReportForm" value="RPT" class="Data">RPT
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="180">保單幣別：</TD>
			<TD width="333" valign="middle">
				<select size="1" name="para_Currency" id="para_Currency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
		<!--
		<TR>
			<TD align="right" class="TableHeading" width="180">執行退匯日期：</TD>
			<TD>
				<INPUT type="text" class="Data" id="txtRDateC" name="txtRDateC" size="11" maxlength="11" value="" readOnly onBlur="checkClientField(this,true);">
				<INPUT type="hidden" id="txtRDate" name="txtRDate" value="">
			</TD>
		</TR>
		-->
		<TR>
			<TD align="right" class="TableHeading" width="180">銀行退匯回存日：</TD>
			<TD width="333" valign="middle">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtRDateC" name="txtRFDateC" value="" readOnly> 
				<a href="javascript:show_calendar('frmMain.txtRFDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT type="hidden" id="txtRDate" name="txtRFDate" value="">
			</TD>
		</TR>
	</TABLE>
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitFailReport.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBRemitFailReport.pdf"> 
	<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>"> 
	<INPUT type="hidden" id="txtUserRight" name="txtUserDept" value="<%=strUserRight%>"> 
	<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>"> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBRemit\\"> 
	<INPUT type="hidden" id="para_PConDate" name="para_PConDate">
	<INPUT type="hidden" id="para_PConDate2" name="para_PConDate2">
</FORM>

</BODY>
</HTML>


