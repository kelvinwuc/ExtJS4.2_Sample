<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : 各項理賠給付明細表
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.4 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $Date: 2014/01/03 02:51:37 $
 * 
 * Request ID : R10231
 * 
 * CVS History:
 * 
 * $Log: DISBClmPayment.jsp,v $
 * Revision 1.4  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 * Revision 1.1  2011/08/31 07:28:18  MISSALLY
 * R10231
 * CASH系統新增各項理賠給付明細表
 *
 *  
 */
%><%! String strThisProgId = "DISBClmPayment"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?((String) request.getAttribute("txtAction")):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?(CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept"))):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?(CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight"))):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?(CommonUtil.AllTrim((String)session.getAttribute("LogonUserId"))):"";

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

//幣別
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
<TITLE>各項理賠給付明細表</TITLE>
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
	if( document.getElementById("txtMsg").value !=null && document.getElementById("txtMsg").value != "" )
		window.alert(document.getElementById("txtMsg").value);

	if(document.getElementById("txtUserDept").value != "CLM" && document.getElementById("txtUserDept").value != "GPH")
	{
		alert("無執行此報表權限");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else
	{
		WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' );
	}

	window.status = "";
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
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBClmPayment.jsp";
}

/*
函數名稱:	printRAction()
函數功能:	當toolbar frame 中之報表按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function printRAction()
{
	if(document.getElementById("txtPSRCDT").value == "") 
	{
		alert("『輸入日期』不得為空白!!");
		return false;
	}

	window.status = "";
	getReportInfo();
	WindowOnLoadCommon( document.title , '' , 'E','' );
	document.getElementById("inquiryArea").style.display ="none";

	document.getElementById("frmMain").target="_blank";
	document.getElementById("frmMain").submit();
}

function getReportInfo()
{
	mapValue();

	var strSql  = "SELECT a.PNO, a.POLICYNO, a.PCFMUSR1, a.PMETHOD, a.PCFMDT1, a.ENTRYDT, a.PCHKM1, a.PCHKM2, ";
	strSql += "a.PCURR, a.PAMT, a.PNAME, a.PSNAME, a.PENGNAME, a.PPAYCURR, a.PPAYAMT, a.PPAYRATE, a.PFEEWAY, ";
	strSql += "a.PRBANK, a.PRACCOUNT, a.PSWIFT, a.PAMTNT, b.DEPT as PAY_DEPT, a.PDISPATCH, ";
	strSql += "'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT, ";
	strSql += "'" + document.getElementById("txtUserDept").value + "' AS USERDEPT, ";
	strSql += "IFNULL(c.BKNM,'') as BKNM, IFNULL(na.FLD0002,'') as OwnerId, IFNULL(na.FLD0070,'') as Owner ";
	strSql += "FROM CAPPAYF a  ";
	strSql += "LEFT JOIN USER b on b.USRID=a.ENTRY_USER ";
	strSql += "LEFT JOIN CAPCCBF c on c.BKNO=a.PRBANK ";
	strSql += "LEFT JOIN ORDUPO po ON po.FLD0001='  ' and po.FLD0002=a.POLICYNO ";
	strSql += "LEFT JOIN ORDUNA na ON na.FLD0001=po.FLD0001 and na.FLD0002=po.FLD0021 ";
	strSql += "WHERE a.PCFMDT1 <> 0 AND a.PCFMDT2 = 0 AND a.PVOIDABLE = '' ";
	if (document.getElementById("para_Dispatch").value != "" )
	{
		strSql += "AND a.PDISPATCH = '" + document.getElementById("para_Dispatch").value + "' ";
	}
	if (document.getElementById("para_Currency").value != "" )
	{
		strSql += "AND a.PCURR = '" + document.getElementById("para_Currency").value + "' ";
	}

	if(document.getElementById("txtUserRight").value >= "79" && document.getElementById("txtUserRight").value < "89")
	{	//只能查自己所輸入的資料
		strSql += "AND a.PCFMUSR1 = '" + document.getElementById("txtUserId").value + "' ";
	}
	else if(document.getElementById("txtUserRight").value >= "89" && document.getElementById("txtUserRight").value < "99")
	{	//只能查部門內所有資料
		strSql += "AND b.DEPT='" + document.getElementById("txtUserDept").value + "' ";

		//只查本人的資料
		if(document.getElementById("para_UserRight").value == "1")
		{
			strSql += "AND a.PCFMUSR1 = '" + document.getElementById("txtUserId").value + "' ";
		}
	}
	else
	{	// 權限為99者, 可查所有資料
	}

    document.getElementById("ReportSQL").value = strSql;
}

function mapValue() {
	document.getElementById("para_PSRCDT").value = rocDate2String(document.getElementById("txtPSRCDT").value);
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS"	id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="650"  id=inquiryArea>
	<TR>
		<TD align="right" class="TableHeading" width="120">輸入日期：</TD>
		<TD width="150">
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPSRCDT" name="txtPSRCDT" value="" readOnly >
			<a href="javascript:show_calendar('frmMain.txtPSRCDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
			<INPUT type="hidden" name="para_PSRCDT" id="para_PSRCDT" value="">
			<a href="javascript:show_calendar('frmMain.txtPSRCDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"></a>	
		</TD>
		<TD align="right" class="TableHeading" width="80">急件：</TD>
		<TD>
			<select size="1" name="para_Dispatch" id="para_Dispatch">
				<option value="">&nbsp;</option>
				<option value="Y">急件</option>
			</select>
		</TD>
		<TD align="right" class="TableHeading" width="80">幣別：</TD>
		<TD>
			<select size="1" name="para_Currency" id="para_Currency">
				<%=sbCurrCash.toString()%>
			</select>
		</TD>
<% if(!strUserRight.equals("") && Integer.parseInt(strUserRight) > 79) { %>
		<TD align="right" class="TableHeading" width="100">本人/部門：</TD>
		<TD>
			<select size="1" name="para_UserRight" id="para_UserRight">
				<option value="0">全部門</option>
				<option value="1">本人</option>
			</select>
		</TD>
<% } %>
	</TR>
</table>

<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBClmPayment.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBClmPayment.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="txtAction"	name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">

</FORM>
</BODY>
</HTML>