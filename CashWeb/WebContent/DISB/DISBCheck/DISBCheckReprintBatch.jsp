<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393       Leo Huang    			2010/09/20          絕對路徑轉相對路徑
 *  =============================================================================
 */
%>
<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.DbFactory" %>

<%//R00393%>
<!--# include virtual="/Logon/Init.inc"-->
<!--# include virtual="/Logon/CheckLogonDISB.inc"-->

<%!String strThisProgId = "DISBCheckBReprint"; //本程式代號%>
<%
String strAction = request.getAttribute("txtAction") != null? (String) request.getAttribute("txtAction"):"";
String strReturnMessage = request.getAttribute("txtMsg") != null?(String) request.getAttribute("txtMsg"):"";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>出納功能--整批票據重印作業</TITLE>
<!-- R00393 edit by Leo Huang 
<LINK REL="stylesheet" TYPE="text/css" HREF="/CashWeb/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="/CashWeb/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="/CashWeb/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="/CashWeb/Theme/global/custom.css">
-->
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<style type="text/css">
div.tableContainer {
	width: 100%;		/* table width will be 99% of this*/
	height: 300px; 	/* must be greater than tbody*/
	overflow: auto;
	margin: 0 auto;
}

table>tbody	{  /* child selector syntax which IE6 and older do not support*/
	overflow: auto; 
	height: 290px;
	overflow-x: hidden;
}
	
thead tr	{
	position:relative; 
	top: expression(offsetParent.scrollTop); /*IE5+ only*/
}
	
thead td, thead th {
	text-align: left;
	font-size: 12px; 
	background-color: #d8d8d8;
	border-top: solid 1px #d8d8d8;
}	
</style>
<!--
<SCRIPT language="JavaScript" src="/CashWeb/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/CashWeb/ScriptLibrary/ClientDISB.js"></SCRIPT>
-->
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>

<script LANGUAGE="javascript">
// *************************************************************
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
		if( document.getElementById("txtMsg").value != "")
		{
			window.alert(document.getElementById("txtMsg").value) ;
			//R00393 edit Leo Huang
			//window.location.href= "/CashWeb/DISB/DISBCheck/DISBCheckReprintBatch.jsp";
			window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckReprintBatch.jsp";
			
		}	
        if (document.getElementById("txtAction").value == "")
        {
		    WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;
		    window.status = "";
	    }
	    else
	    {
	    	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyExit,'' ) ;
		    window.status = "";
	    }	
}
/*
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之[離開]按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//window.location.href= "/CashWeb/DISB/DISBCheck/DISBCheckReprintBatch.jsp?";
    window.location.href= "<%=request.getContextPath()%>/DISBCheck/DISBCheckReprintBatch.jsp?";
	//R00393  Edit by Leo Huang (EASONTECH) End
}

/*
查詢重印票號區間
*/
function inquiryAction()
{
	if (document.frmMain.txtSNo.value == ""){
		alert("請輸入重印票號起日");
		document.frmMain.txtSNo.focus();
		return false;
	}
	
	if (document.frmMain.txtENo.value == ""){
		alert("請輸入重印票號迄日");
		document.frmMain.txtENo.focus();
		return false;
	}
	
	document.getElementById("txtAction").value = "Query";
	document.getElementById("txtUpdateStatus").value = "Q";
	document.getElementById("frmMain").submit();
}

/*
 更新票據狀態為重印: 3
*/
function update3Action()
{
	document.getElementById("txtAction").value = "UpdateBatch";
	document.getElementById("txtUpdateStatus").value = "3";
	if (parseInt(document.getElementsByName("count")[0].value) > 0)
	{
		if (confirm('您確定要重印下列票據號碼!?'))
			document.getElementById("frmMain").submit();
	}else{
		alert("查詢無符合重印資料?!");
		return false ;
	}
} 

function sbar(st) {
	st.style.backgroundColor = '#CBDDF1';
}
			
function cbar(st) {
	st.style.backgroundColor = '';
}
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<!--R00393  Edit by Leo Huang (EASONTECH) Start
<form action="/CashWeb/servlet/com.aegon.disb.disbcheck.DISBCheckMaintainServlet" id="frmMain" method="post" name="frmMain">
-->
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckMaintainServlet" id="frmMain" method="post" name="frmMain">
<!--R00393  Edit by Leo Huang (EASONTECH) End-->
<TABLE border="1" width="100%" id=inquiryArea name=inquiryArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">重印票據號碼：</TD>
			<TD>
			起：<INPUT class="Data" size="20" type="text" maxlength="18" name="txtSNo" id="txtSNo" value="">&nbsp;&nbsp;
			迄：<INPUT class="Data" size="20" type="text" maxlength="18" name="txtENo" id="txtENo" value="">&nbsp;(請輸入完整票據起迄區間)
			</TD>
		</TR>
	</TBODY>
</TABLE>
<br>
<%
int count = 0 ;
int totalAMT = 0 ;
if (request.getAttribute("data") != null){
	ResultSet rs = (ResultSet)request.getAttribute("data") ;
%>
<table>
<tr>
<td id="Update3"><input type="button" name="btnUpdate3" id="btnUpdate3" onClick="update3Action();" value="整批重印"></td>
</tr>
</table>
<div class="tableContainer"> 
<TABLE border="1" width="100%" cellspacing="0" cellpadding="0">
		<thead>
		<TR>
			<TD width="80">票據號碼：</TD>
			<TD width="80">票據批號：</TD>
			<TD width="80">銀行行庫：</TD>
			<TD width="101">銀行帳號：</TD>
			<TD width="260">票據抬頭：</TD>
			<TD width="80">票據金額：</TD>
			<TD width="60">到期日：</TD>
			<TD width="60">開立日：</TD>
			<TD width="101">支付序號：</TD>
			<!--<TD align="left" class="TableHeading" width="101">備註：</TD>-->
		</TR>
		</thead>	
<%while (rs.next()){%>
	<TBODY>
		<TR onMouseOver=sbar(this) onMouseOut=cbar(this)>
			<TD width="80"><%=rs.getString("CNO")%></TD>
			<TD width="80"><%=rs.getString("CBNO")%></TD>
			<TD width="80"><%=rs.getString("CBKNO")%></TD>
			<TD width="101"><%=rs.getString("CACCOUNT")%></TD>
			<TD width="290"><%=rs.getString("CNM")%></TD>
			<TD width="80"><%=rs.getInt("CAMT")%></TD>
			<TD width="60"><%=rs.getString("CHEQUEDT")%></TD>
			<TD width="60"><%=rs.getString("CUSEDT")%></TD>
			<TD width="101"><%=rs.getString("PNO")%>
			<input type="hidden" name="txtCBkNoU" value="<%=rs.getString("CBKNO")%>">
			<input type="hidden" name="txtCAccountU" value="<%=rs.getString("CACCOUNT")%>">
			<input type="hidden" name="txtCBNoU" value="<%=rs.getString("CBNO")%>">
			<input type="hidden" name="txtCNoU" value="<%=rs.getString("CNO")%>">
			<input type="hidden" name="txtPNoU" value="<%=rs.getString("PNO")%>">
			<input type="hidden" name="txtCMEMO" value="<%=rs.getString("MEMO")%>">
			</TD>
			<!--<TD align="left" class="TableHeading" width="101"><%=rs.getString("MEMO")%></TD>-->
		</TR>	
<%	totalAMT = totalAMT+rs.getInt("CAMT") ;
		count++ ;
	}
%>
	   <TR>
	   		<TD COLSPAN="9" ALIGN="RIGHT">票據重印總筆數：<b><font color="red"><%=count%></font></b>(筆)，票據重印總金額：<b><font color="red"><%=totalAMT%></font></b>(元)</TD>
	   </TR>					
	</TBODY>
</TABLE>
</div>
<%}%>
<INPUT name="txtUpdateStatus" id="txtUpdateStatus" type="hidden" value=""> 
<INPUT name="txtAction" id="txtAction" type="hidden" 	value="<%=strAction%>"> 
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
<INPUT name="count" type="hidden" value="<%=count%>"> 
</FORM>
</BODY>
</HTML>
