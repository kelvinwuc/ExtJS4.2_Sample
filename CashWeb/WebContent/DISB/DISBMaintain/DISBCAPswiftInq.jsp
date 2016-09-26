<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 查詢SWIFT CODE
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.9 $
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 2010/11/23 02:21:59
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DISBCAPswiftInq.jsp,v $
 * Revision 1.9  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.8  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 * Revision 1.7  2013/02/26 10:10:36  ODCWilliam
 * william wu
 * RA0074
 *
 * Revision 1.6  2012/08/29 07:07:59  ODCWilliam
 * *** empty log message ***
 *
 * Revision 1.5  2012/08/29 03:43:42  ODCWilliam
 * modify:william
 * date:2012-08-12
 *
 * Revision 1.4  2012/06/18 09:35:40  MISSALLY
 * QA0132-金資檔案及 SWIFT CODE檔案維護
 * 1.功能「新增金資碼」增加檢核不得為空值。
 * 2.功能「金資銀行檔」
 *    2.1國外SWIFT CODE畫面隱藏。
 *    2.2增加檢核不得上傳空檔。
 *    2.3增加檢核金資代碼長度必須為7位數字，否則顯示失敗的記錄；若執行時有錯誤訊息則全部不更新，且顯示失敗的記錄。
 *
 *  
 */
%><%!String strThisProgId = "DISBCAPswiftInq"; //本程式代號%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>管理系統--查詢國外金資銀行SWIFT CODE檔</TITLE>
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
	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ); //查詢I
}

/* 當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行 */
function inquiryAction()
{
	if( document.getElementById("txtAction").value == "I" ) {
		var strSql = "select * from ORCHSWFT WHERE 1=1 ";
		if( document.getElementById("txtBKNO").value != "" ) {
			strSql += " AND BANK_NO = '" + document.getElementById("txtBKNO").value + "' ";
		}
		if( document.getElementById("txtSWFT").value != "" ) {
			strSql += " AND SWIFT_CODE LIKE '^" + document.getElementById("txtSWFT").value + "^' ";
		}
		if( document.getElementById("txtBKNM").value != "" ) {
			strSql += " AND BANK_NAME LIKE '^" + document.getElementById("txtBKNM").value + "^' ";
		}
		strSql += " ORDER BY BANK_NO,BANK_NAME,SWIFT_CODE ";

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
		<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	    session.setAttribute("Heading","金融機構代碼,銀行名稱,SWFIT CODE");
	    session.setAttribute("DisplayFields", "BANK_NO,BANK_NAME,SWIFT_CODE");
	    session.setAttribute("ReturnFields", "BANK_NO,BANK_NAME,SWIFT_CODE");
	    %>
		//modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:600px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" ) {		
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtBKNO").value = returnArray[0];
			document.getElementById("txtSWFT").value = returnArray[1];				
			document.getElementById("txtBKNM").value = returnArray[2];			

			document.getElementById("txtBKNO").readOnly = true;
			document.getElementById("txtSWFT").readOnly = true;
			document.getElementById("txtBKNM").readOnly = true;

			WindowOnLoadCommon( document.title, '', strDISBFunctionKeyExit, '' ) ; //離開
		}
	}
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBCAPswiftInq.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post">
<TABLE border="1" width="450">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="200">金融機構代碼：</TD>
			<TD><INPUT class="Key" size="7" type="text" maxlength="3" name="txtBKNO" id="txtBKNO" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="200">銀行名稱：</TD>
			<TD><INPUT class="Data" size="45" type="text" maxlength="60" name="txtBKNM" id="txtBKNM" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="200">SWIFT CODE：</TD>
			<TD><INPUT class="Data" size="45" type="text" maxlength="11" name="txtSWFT" id="txtSWFT" value="" style="text-transform: uppercase;"></TD>
		</TR>
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value="">
</FORM>
</BODY>
</HTML>