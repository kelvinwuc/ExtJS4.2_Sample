<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CASHWEB
 * 
 * Function : 現金收入日報表--小數點差異表
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.6 $
 * 
 * Author   : $Author: MISSALLY $
 * 
 * Create Date : $Date: 2013/12/24 03:37:22 $
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DayCasRptD.jsp,v $
 * Revision 1.6  2013/12/24 03:37:22  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.4  2012/01/10 08:12:38  MISSALLY
 * Q10312
 * 修改小數差異報表的資料
 *
 *  
 */
%><%! String strThisProgId = "DayCasRptD"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
Calendar  calendar = new CommonUtil(globalEnviron).getBizDateByRCalendar();

String strReturnMessage = (request.getParameter("txtMsg") != null) ?  request.getParameter("txtMsg") : "";
String strAction = (request.getAttribute("txtAction") != null) ? ((String) request.getAttribute("txtAction")) : "";
String strUserDept = (session.getAttribute("LogonUserDept") != null) ? CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept")) : "";
String strUserRight = (session.getAttribute("LogonUserRight") != null) ? CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight")) : "";
String strUserId = (session.getAttribute("LogonUserId") != null) ? CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")) : "";

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") ==null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
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
<TITLE>現金收入日報表--小數點差異表</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css">
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="javascript">
<!--
// *************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title, '', strFunctionKeyReport, '' );
	window.status = "";
}

/*
函數名稱:	printRAction()
函數功能:	當toolbar frame 中之[報表]按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function printRAction()
{
	document.getElementById("txtAction").value = "L";   
	WindowOnLoadCommon( document.title, '', 'E', '' );

	mapValue();

	if(document.frmMain.rdReportType[0].checked) {
		getReportInfoDetails();
		window.status = "";
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
	} else {
		getReportInfoTotal();
		window.status = "";
		document.frmMain.ReportName.value = "DayCasRptDTotal.rpt";
		document.frmMain.OutputFileName.value = "DayCasRptDTotal.pdf";
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
	}
}

function mapValue()
{
	document.getElementById("para_STRDATE").value = rocDate2String(document.getElementById("txtSTRDATE").value,"3");
	document.getElementById("para_ENDDATE").value = rocDate2String(document.getElementById("txtENDDATE").value,"3");
}

/*
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "../DayCasRpt/DayCasRptD.jsp";
}

function getReportInfoDetails()
{
	var strSql = "";
	strSql = "SELECT A.TRANSDATE,A.POLICY28F,A.EXPCASH,A.CURRPAY,A.CURRAMT,IFNULL(B.CASHBNK,'') as CASHBNK,IFNULL(C.BKNAME,'') as BKNAME,IFNULL(C.BKATNO,'') as BKATNO,IFNULL(C.BKCURR,'') as BKCURR,IFNULL(C.GLACT,'') as GLACT  ";
	strSql += "FROM CAP1228F A ";
	strSql += "LEFT JOIN ORNBTA B ON B.RECEIPTNO = DIGITS(A.CDJDAY) || DIGITS(A.CDNUMBER) ";
	strSql += "LEFT JOIN CAPBNKF C ON B.CASHBNK <> '' and B.CASHBNK = C.BKALAT ";
	strSql += "LEFT JOIN ORDUTA D ON D.FLD0001='  ' and D.FLD0002 = A.CDJDAY and D.FLD0003 = A.CDNUMBER ";
	strSql += "WHERE B.RECEIPSEQ = 1 AND A.CURRRATE = 0 and D.TATYPE<>'Y' and D.FLD0024='P' ";
	strSql += "AND A.TRANSDATE BETWEEN " + document.getElementById("para_STRDATE").value + " AND " + document.getElementById("para_ENDDATE").value + " ";

	if (document.getElementById("txtPOCurr").value != "") {
		strSql += " AND A.CURRPAY = '" + document.getElementById("txtPOCurr").value + "' ";
	}

	if (document.getElementById("txtPOCurr").value == "") {
		strSql += "AND A.CURRPAY NOT IN(' ','NT') ";
	}

	strSql += "ORDER BY A.TRANSDATE,A.CURRPAY ";

	document.getElementById("ReportSQL").value = strSql;
}

function getReportInfoTotal()
{
	var strSql = "";
	strSql = "SELECT A.TRANSDATE,A.CURRPAY,IFNULL(C.GLACT,'') as GLACT,IFNULL(C.BKNAME,'') as BKNAME,IFNULL(C.BKATNO,'') as BKATNO,SUM(A.EXPCASH) AS EXPCASH,SUM(A.CURRAMT) AS CURRAMT ";
	strSql += "FROM CAP1228F A ";
	strSql += "LEFT JOIN ORNBTA B ON B.RECEIPTNO = DIGITS(A.CDJDAY) || DIGITS(A.CDNUMBER) ";
	strSql += "LEFT JOIN CAPBNKF C ON B.CASHBNK <> '' and B.CASHBNK = C.BKALAT ";
	strSql += "LEFT JOIN ORDUTA D ON D.FLD0001='  ' and D.FLD0002 = A.CDJDAY and D.FLD0003 = A.CDNUMBER ";
	strSql += "WHERE B.RECEIPSEQ = 1 AND A.CURRRATE = 0 and D.TATYPE<>'Y' and D.FLD0024='P' ";
	strSql += "AND A.TRANSDATE BETWEEN " + document.getElementById("para_STRDATE").value + " AND " + document.getElementById("para_ENDDATE").value + " ";

	if (document.getElementById("txtPOCurr").value != "") {
		strSql += " AND A.CURRPAY = '" + document.getElementById("txtPOCurr").value + "' ";
	}

	if (document.getElementById("txtPOCurr").value == "") {
		strSql += "AND A.CURRPAY NOT IN(' ','NT') ";
	}

	strSql += "GROUP BY A.TRANSDATE,A.CURRPAY,C.GLACT,C.BKNAME,C.BKATNO ";
	strSql += "ORDER BY A.TRANSDATE,A.CURRPAY,C.GLACT,C.BKNAME,C.BKATNO ";

	document.getElementById("ReportSQL").value = strSql;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" name="frmMain" method="post" action="../servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="1" width="452" id="inqueryArea">
	<TBODY>
	<TR>
		<TD align="right" class="TableHeading" width="180">請選擇欲執行報表：</TD>
		<TD width="305">
			<input type="radio" name="rdReportType" id="rdReportType" Value="A" class="Data" checked>差異明細表
			<input type="radio" name="rdReportType" id="rdReportType" Value="B" class="Data">差異匯總表
		</TD>
	</TR>
	<TR>
		<TD align="left" class="TableHeading" width="118">系統日期起日：</TD>
		<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtSTRDATE" name="txtSTRDATE" value="" readOnly onblur="checkClientField(this,true);"> 
			<a href="javascript:show_calendar('frmMain.txtSTRDATE','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="../images/misc/show-calendar.gif" alt="查詢"></a>
			<INPUT type="hidden" name="para_STRDATE" id="para_STRDATE" value="">
		</TD>
	</TR>
	<TR> 
		<TD align="left" class="TableHeading" width="118">系統日期迄日：</TD>
		<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtENDDATE" name="txtENDDATE" value="" readOnly onblur="checkClientField(this,true);"> 
			<a href="javascript:show_calendar('frmMain.txtENDDATE','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="../images/misc/show-calendar.gif" alt="查詢"></a>
			<INPUT type="hidden" name="para_ENDDATE" id="para_ENDDATE" value="">
		</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading" width="180">幣別：</TD>
		<TD width="333" valign="middle">
			<select size="1" name="txtPOCurr" id="txtPOCurr">
				<%=sbCurrCash.toString()%>
			</select>
		</TD>
	</TR>		
	</TBODY>
</TABLE>

<INPUT type="hidden" id="ReportName" name="ReportName" value="DayCasRptDDetails.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DayCasRptDDetails.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DayCasRpt\\">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>"> 
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">
<INPUT type="hidden" id="para_STRDATE" name="para_STRDATE" Value=""> 
<INPUT type="hidden" id="para_ENDDATE" name="para_ENDDATE" Value=""> 

</FORM>
</BODY>
</HTML>