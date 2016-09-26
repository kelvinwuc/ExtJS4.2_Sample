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
 * Revision : $Revision: 1.2 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : 2013/11/13
 * 
 * Request ID  : RB0302
 * 
 * CVS History:
 * 
 * $Log: DISBCashConfirmInq.jsp,v $
 * Revision 1.2  2014/07/18 07:33:07  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.1  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 *  
 */
%><%! String strThisProgId = "DISBCashConfirm"; //本程式代號 %><%
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

request.removeAttribute("txtMsg");
request.removeAttribute("rowCount");
request.removeAttribute("totalAmt");

List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") ==null){
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
		if(strValue.equals("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>現金支付</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
// *************************************************************
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "") {
		var varMsg = document.getElementById("txtMsg").value + "\n\r";
		varMsg += "付現總件數：" + document.getElementById("txtCount").value + "\n\r";
		varMsg += "總金額：" + document.getElementById("txtAmt").value;
		window.alert(varMsg);
	}

	WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
	window.status = "";
}

function inquiryAction()
{
	document.getElementById("txtAction").value = "I";
	document.getElementById("txtStartDate").value = rocDate2String(document.getElementById("pDate1").value) ;
	document.getElementById("txtEndDate").value = rocDate2String(document.getElementById("pDate2").value) ;
	document.frmMain.submit();
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBCashConfirmServlet" id="frmMain" method="post" name="frmMain">
<INPUT type="hidden" id="txtStartDate" name="txtStartDate" value=""> 
<INPUT type="hidden" id="txtEndDate" name="txtEndDate" value=""> 
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
		<TR>
			<TD align="right" class="TableHeading" width="121" >急件否：</TD>
			<TD width="323">
				<select size="1" name="pDispatch" id="pDispatch">
					<option value="Y" selected>是</option>
					<option value="">否</option>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="121">保單幣別</TD>
			<TD width="323">
				<select size="1" name="selCurrency" id="selCurrency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
<!-- RC0036 -->
		<TR>
			<TD align="right" class="TableHeading" width="121">承辦單位</TD>
			<TD width="323">
				<select size="1" name="selUsrDept" id="selUsrDept">
					<option value="CSC" selected>CSC</option>
				</select>
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