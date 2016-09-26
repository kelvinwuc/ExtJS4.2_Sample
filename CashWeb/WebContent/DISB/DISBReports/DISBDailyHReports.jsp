<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : 暫不付款明細報表
 * 
 * Remark   : DISBDailyHReports.rpt
 *            暫不付款餘額表 (FINACCT可查所有資料/其餘看權限)
 *            前次暫不付款餘額表/急件已付款明細表/應付票據作廢明細表/當日急件明細表(僅提供給FIN使用)
 * 
 * Revision : $Revision: 1.11 $
 * 
 * Author   : $Author: MISSALLY $
 * 
 * Create Date : $Date: 2013/12/26 01:28:15 $
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DISBDailyHReports.jsp,v $
 * Revision 1.11  2013/12/26 01:28:15  MISSALLY
 * RB0302---新增付款方式現金 --- BugFix 離開按鈕無法使用
 *
 * Revision 1.10  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.8  2011/10/21 10:04:35  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 *
 *  
 */
%><%! String strThisProgId = "DISBDailyHReports"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")):"";

CommonUtil commonUtil = new CommonUtil(globalEnviron);	
Calendar calendar  = commonUtil.getBizDateByRCalendar();
int  iCurrentDate =Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(calendar.getTime()));		

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);//R80132

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

List alCurrCash = new ArrayList(); //R80132 幣別挑選

if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}
else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}//R80132 END
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
<TITLE>暫不付款明細報表</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript">
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
	window.status = "";
	mapValue();
	if(document.getElementById("para_Reports").value == "ALL") 
	{
		document.getElementById("para_Reports").value = "A";
		getReportInfo();
		document.getElementById("txtAction").value = "L";
		WindowOnLoadCommon( document.title, '', 'E', '' );
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("para_Reports").value = "B";
		getReportInfoB();
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("para_Reports").value = "C";
		getReportInfoC();
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("para_Reports").value = "D";
		getReportInfoD();
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("para_Reports").value = "E";
		getReportInfoE();
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("txtAction").value = "";
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyHReports.jsp";
	} 
	else 
	{
		//暫不付款餘額表
		if(document.getElementById("para_Reports").value == "A") {
			getReportInfo();
		//前次暫不付款餘額表
		} else if(document.getElementById("para_Reports").value == "B") {
			getReportInfoB();
		//急件已付款明細表
		} else if(document.getElementById("para_Reports").value == "C") {
			getReportInfoC();
		// R80822
		//應付票據作廢明細表
		} else if(document.getElementById("para_Reports").value == "D") {
			getReportInfoD();
		//當日急件明細表
		} else if(document.getElementById("para_Reports").value == "E") {
			getReportInfoE();
		}
	
		document.getElementById("txtAction").value = "L";
		WindowOnLoadCommon( document.title, '', 'E', '' );
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();
	}
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
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyHReports.jsp";
}

//暫不付款餘額表
function getReportInfo()
{
	var strSql = "SELECT A.* ";
	strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";
	strSql += " from CAPPAYF A ";
    strSql += " left outer join USER B  on B.USRID = A.ENTRY_USER ";
	strSql += " WHERE A.PAY_VOIDABLE = '' ";	//R80822

	// 部門:FIN, 可查所有資料
	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")	 // R80244
	{
		strSql += " AND (A.PAY_CONFIRM_DATE1 = 0 OR A.PAY_CONFIRM_DATE2 = 0) "; 
	}
	//權限為89者,可查部門資料
	else if( document.getElementById("txtUserRight").value > "79" )  // R80244	
	{
		strSql += " AND B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
		strSql += " AND A.PAY_CONFIRM_DATE1 = 0 and PAY_CONFIRM_TIME1=0 and PAY_CONFIRM_USER1='' ";
	}
	//權限為79者,可查自己資料
	else 
	{
		strSql += " AND A.ENTRY_USER ='"+ document.getElementById("txtUserID").value +"'  ";
		strSql += " AND A.PAY_CONFIRM_DATE1 = 0 and PAY_CONFIRM_TIME1=0 and PAY_CONFIRM_USER1='' ";
	}

	if ( document.getElementById("Para_EntryDate").value != "" ) {
		strSql += " AND A.ENTRY_DATE <= "+ document.getElementById("para_EntryDate").value;
	}
	if ( document.getElementById("Para_Currency").value != "" ) {
		strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'";
	}

    document.getElementById("ReportSQL").value = strSql;
}

// R70600 前次暫不開票明細表
function getReportInfoB()
{
	var strSql = "";

	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")
	{
		strSql = "SELECT A.* ";
		strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";		
		strSql += " from CAPPAYF A ";
	    strSql += "  left outer join USER B  on B.USRID = A.ENTRY_USER ";
		strSql += " WHERE A.PAY_VOIDABLE = ''"; //R80822		
		strSql += " AND A.PAY_CONFIRM_DATE1 <> 0 AND  A.PAY_CONFIRM_DATE2 <> 0 AND A.PAY_DISPATCH <> 'Y' ";
		strSql += " AND A.PAY_SOURCE_GROUP <>'WB' "; 
		strSql += " AND A.PAY_NO NOT IN (SELECT C.PNOH FROM CAPPAYF C WHERE C.PNOH <> '')"; // 排除匯退件的原始件
		strSql += " AND A.PAY_SOURCE_CODE NOT IN ('D2','H1','S1')"; 	//R80799加入S1

		if ( document.getElementById("para_CFMDate").value != "" ) {
			strSql += " AND A.PAY_CONFIRM_DATE2 = "+ document.getElementById("para_CFMDate").value;
		}  			
        if ( document.getElementById("Para_EntryDate").value != "" ) {
        	strSql += " AND A.ENTRY_DATE < "+ document.getElementById("para_EntryDate").value;
		}  
        if ( document.getElementById("Para_Currency").value != "" ) {
        	strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'";
		}
	}

    document.getElementById("ReportSQL").value = strSql;
}

// R70600 急件已開票明細表
function getReportInfoC()
{
	var strSql = "";

	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")
	{
		strSql = "SELECT A.* ";
		strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";		
		strSql += " from CAPPAYF A ";
	    strSql += "  left outer join USER B  on B.USRID = A.ENTRY_USER ";
		strSql += " WHERE A.PAY_VOIDABLE = ''"; //R80822		
		strSql += " AND A.PAY_CONFIRM_DATE1 <> 0 AND  A.PAY_CONFIRM_DATE2 <> 0 AND A.PAY_DISPATCH = 'Y' ";

		if ( document.getElementById("para_CFMDate").value != "" ) {  //R80822
			strSql += " AND A.PAY_CONFIRM_DATE2 <> "+ document.getElementById("para_CFMDate").value ;  //R80822
		}  //R80822
		if ( document.getElementById("Para_EntryDate").value != "" ) {
			strSql += " AND A.ENTRY_DATE = "+ document.getElementById("para_EntryDate").value ;
		}
		if (document.getElementById("Para_Currency").value != "" ) {
			strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'" ;
		}
	}

    document.getElementById("ReportSQL").value = strSql;
}

// R80822 應付票據作廢明細表
function getReportInfoD()
{
	var strSql = "";

	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")
	{
		strSql = "SELECT A.* ";
		strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";		
		strSql += " from CAPPAYF A ";
	    strSql += "  left outer join USER B  on B.USRID = A.ENTRY_USER ";
		strSql += " WHERE A.PAY_VOIDABLE = 'Y'";

		if (document.getElementById("Para_EntryDate").value != "" ) {
			strSql += " AND A.ENTRY_DATE = "+ document.getElementById("para_EntryDate").value ;
		}
		if (document.getElementById("Para_Currency").value != "" ) {
			strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'" ;
		}
	}

    document.getElementById("ReportSQL").value = strSql;
}

// R80822 當日急件明細表
function getReportInfoE()
{
	var strSql = "";

	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")
	{
		strSql = "SELECT A.* ";
		strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";		
		strSql += " from CAPPAYF A ";
	    strSql += "  left outer join USER B  on B.USRID = A.ENTRY_USER ";
		strSql += " WHERE A.PAY_VOIDABLE = ''";
		strSql += " AND A.PAY_CONFIRM_DATE1 <> 0 AND  A.PAY_CONFIRM_DATE2 <> 0 AND A.PAY_DISPATCH = 'Y' ";

		if (document.getElementById("para_CFMDate").value != "" ) {
			strSql += " AND A.PAY_CONFIRM_DATE2 = "+ document.getElementById("para_CFMDate").value ;
		}
		if (document.getElementById("Para_EntryDate").value != "" ) {
			strSql += " AND A.ENTRY_DATE = "+ document.getElementById("para_EntryDate").value ;
		}
		if (document.getElementById("Para_Currency").value != "" ) {
			strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'" ;
		}
	}

    document.getElementById("ReportSQL").value = strSql;
}

function mapValue()
{
	if(document.getElementById("txtEntryDateC").value !="") {
		document.getElementById("para_EntryDate").value = rocDate2String(document.getElementById("txtEntryDateC").value) ;
	}
	if(document.getElementById("txtCFMDateC").value !="") {
		document.getElementById("para_CFMDate").value = rocDate2String(document.getElementById("txtCFMDateC").value) ;
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS"	id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="400"  id=BatchArea>
	<TR>
		<TD align="right" class="TableHeading" width="100">輸入日期：</TD>
		<TD width="150">
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryDateC" name="txtEntryDateC" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtEntryDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
			<INPUT type="hidden" name="para_EntryDate" id="para_EntryDate"	value="">
	    </TD>
		<TD align="right" class="TableHeading" width="50">幣別：</TD>
		<TD width="50" valign="middle">
			<select size="1" name="para_Currency" id="para_Currency">
				<%=sbCurrCash.toString()%>
			</select>
		</TD>
	</TR>		
    <!--R70600-->    
	<TR>
		<TD align="right" class="TableHeading">支付確認日：</TD>
		<TD>
			<INPUT class="Data" size="11" type="text" maxlength="11"id="txtCFMDateC" name="txtCFMDateC" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtCFMDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
			<INPUT type="hidden" name="para_CFMDate" id="para_CFMDate" value="">
		</TD>
		<TD colspan="2" rowspan="2">&nbsp;</TD>
	</TR>    
	<TR>
		<TD align="right" class="TableHeading">請選擇報表：</TD>
		<TD valign="middle">
			<select size="1" name="para_Reports" id="para_Reports">
			<% if(strUserDept.equals("ACCT") || strUserDept.equals("FIN")) { %>
				<option value="ALL">全部</option>
				<option value="A">暫不付款餘額表</option>
				<option value="B">前次暫不付款餘額表</option>
				<option value="C">急件已付款明細表</option>
				<option value="D">應付票據作廢明細表</option>
				<option value="E">當日急件明細表</option>
			<% } else { %>
				<option value="A">暫不付款餘額表</option>
			<% } %>
			</select>
		</TD>
	</TR>
</TABLE>      

<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyHReports.rpt">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBDailyHReports.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">	
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">	
</form>
</BODY>
</HTML>

