<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 新增國內金資檔
 * 
 * Remark   : 管理系統-財務
 * 
 * Revision : $Revision: 1.10 $
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 2010/11/23 02:21:59
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DISBCAPccbfCreate.jsp,v $
 * Revision 1.10  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.9  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 * Revision 1.5  2012/06/18 09:35:41  MISSALLY
 * QA0132-金資檔案及 SWIFT CODE檔案維護
 * 1.功能「新增金資碼」增加檢核不得為空值。
 * 2.功能「金資銀行檔」
 *    2.1國外SWIFT CODE畫面隱藏。
 *    2.2增加檢核不得上傳空檔。
 *    2.3增加檢核金資代碼長度必須為7位數字，否則顯示失敗的記錄；若執行時有錯誤訊息則全部不更新，且顯示失敗的記錄。
 *
 *  
 */
%><%!String strThisProgId = "DISBCAPccbf"; //本程式代號%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>管理系統--維護金資銀行檔</TITLE>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" )
	{
		alert(document.getElementById("txtMsg").value);
	}

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' );	//新增A+查詢I
	window.status = "若要修改資料,可經由查詢功能後再進入";

	if ( document.getElementById("txtAction").value == "U" ) {
		WindowOnLoadCommon( document.title , '' , strFunctionKeyUpdate,'' );//儲存S+離開E
	}
}

/* 當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行 */
function inquiryAction()
{
	// R60463
	if( document.getElementById("txtAction").value == "I" ) {
		var strSql = "select * from CAPCCBF WHERE 1=1 ";
		if( document.getElementById("txtBKNO").value != "" ) {
			strSql += " AND BANK_NO = '" + document.getElementById("txtBKNO").value + "' ";
		}
		if( document.getElementById("txtBKNM").value != "" ) {
			strSql += " AND BANK_NAME LIKE '^" + document.getElementById("txtBKNM").value + "^' ";
		}
		if( document.getElementById("txtBKFNM").value != "" ) {
			strSql += " AND BANK_F_NAME LIKE '^" + document.getElementById("txtBKFNM").value + "^' ";
		}
		strSql += " ORDER BY BANK_NO,BANK_F_NAME,BANK_NAME ";

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
		<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	    session.setAttribute("Heading","金資碼,簡稱,全名");
	    session.setAttribute("DisplayFields", "BANK_NO,BANK_NAME,BANK_F_NAME");
	    session.setAttribute("ReturnFields", "BANK_NO,BANK_NAME,BANK_F_NAME");
	    %>
		//modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:600px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" ) {		
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtBKNO").value = returnArray[0];
			document.getElementById("txtBKNM").value = returnArray[1];			
			document.getElementById("txtBKFNM").value = returnArray[2];				

			disableAll();
			WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry,'' ) ; //修改,刪除,離開
		}
	}
}

/* 當toolbar frame 中之<新增>按鈕被點選時,本函數會被執行 */
function addAction()
{
	document.getElementById("txtAction").value = "C";

	if( areAllFieldsOK() ) {
		document.getElementById("frmMain").submit();
	}
}

/* 當toolbar frame 中之<修改>鈕被點選時,本函數會被執行 */
function updateAction() 
{
	enableData();
	WindowOnLoadCommon( document.title, '', strFunctionKeyUpdate, '' );// 儲存S+離開E
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBCAPccbfCreate.jsp";
}

/* 當toolbar frame 中之<儲存>按鈕被點選時,本函數會被執行 */
function saveAction()
{
	document.getElementById("txtAction").value = "S";

	enableAll();
	if( areAllFieldsOK() ) {
		document.getElementById("frmMain").submit();
	}
}

function areAllFieldsOK()
{
	var strTmpMsg = "";

	if (document.getElementById("txtBKNO").value.length != 7) {
		strTmpMsg += "金資碼為7碼數字\r\n";
	}
	if (document.getElementById("txtBKNM").value == "") {
		strTmpMsg += "銀行簡稱不可空白\r\n";
	}
	if (document.getElementById("txtBKFNM").value == "") {
		strTmpMsg += "銀行全名不可空白\r\n";
	}

	if(strTmpMsg != "") {
		alert(strTmpMsg);
		return false;
	} else {
		return true;
	}
}

/* 當toolbar frame 中之<刪除>按鈕被點選時,本函數會被執行 */
function deleteAction()
{
	var bConfirm = window.confirm("是否確定刪除該筆資料?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "D";
		document.getElementById("frmMain").submit();
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBCAPccbfServlet">
<TABLE border="1" width="450">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="74">金資代碼：</TD>
			<TD><INPUT class="Key" size="7" type="text" maxlength="7" name="txtBKNO" id="txtBKNO" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="74">銀行簡稱：</TD>
			<TD><INPUT class="Data" size="10" type="text" maxlength="5" name="txtBKNM" id="txtBKNM" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="74">銀行全名：</TD>
			<TD><INPUT class="Data" size="40" type="text" maxlength="20" name="txtBKFNM" id="txtBKFNM" value=""></TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>