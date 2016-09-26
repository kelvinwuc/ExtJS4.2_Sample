<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CASHWEB
 * 
 * Function : 未銷帳明表
 * 
 * Remark   : 對帳報表
 * 
 * Revision : $$Revision: 1.12 $$
 * 
 * Author   : $$Author: MISSALLY $$
 * 
 * Create Date : $$Date: 2014/02/25 09:04:20 $$
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $$Log: SusDayRptC.jsp,v $
 * $Revision 1.12  2014/02/25 09:04:20  MISSALLY
 * $R00135---PA0024---CASH年度專案-03
 * $還原
 * $
 * $Revision 1.11  2014/02/25 03:41:56  MISSALLY
 * $R00135---PA0024---CASH年度專案-03
 * $還原
 * $
 * $Revision 1.10  2014/02/21 08:38:31  MISSALLY
 * $R00135---PA0024---CASH年度專案-03
 * $還原
 * $
 * $Revision 1.9  2014/02/19 08:52:30  MISSALLY
 * $R00135---PA0024---CASH年度專案-03
 * $還原
 * $
 * $Revision 1.8  2014/01/14 10:41:32  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $報表調整
 * $
 * $Revision 1.7  2014/01/03 02:52:12  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $$
 *  
 */
%><%! String strThisProgId = "SusDayRpt"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>未銷帳明細表列印</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
function WindowOnLoad() 
{
	//debugger;
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' ) ;

	window.status = "請先輸入查詢條件後再點選確定鍵";
}

/* 查詢金融單位代碼及帳號  */
function getBankCode()
{
	//檢查是否於可查詢的狀態
	if(document.getElementById("txtEBKCD").disabled) {
		return;
	}

	/*	執行 QueryFrameSet.jsp 時,各 QueryString 參數之意義
			RowPerPage		: 每一頁有幾列
			Heading			: 表頭欄位名稱,以逗號','分開每一欄位
			DisplayFields	: 要顯示之資料庫欄位名稱,以逗號分開每一欄位,與Heading相對應
			ReturnFields	: 傳回哪些欄位之值,以逗號分開每一欄位
			Sql				: 待執行之SQL,亦可加入where條件
			TableWidth		: 整個Table之寬度
	
		 modalDialog 會傳回使用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開
	*/
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR from CAPBNKF where 1 = 1 ";
	if( document.getElementById("txtEBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtEBKCD").value +"' ";
	if( document.getElementById("txtEATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtEATNO").value +"' ";
	strSql += " ORDER BY BKCODE,BKADDT ";

	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600&Time="+new Date();
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","金融單位代號,金融單位名稱,金融單位帳號,幣別");
	session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR");
	session.setAttribute("ReturnFields", "BKCODE,BKATNO,BKCURR");
%>
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
	if( strReturnValue != "" )
	{
		enableAll();
		var returnArray = string2Array(strReturnValue,",");
		document.getElementById("txtEBKCD").value = returnArray[0];
		document.getElementById("txtEATNO").value = returnArray[1];
		document.getElementById("txtCURRENCY").value = returnArray[2];
	}
}

function getStartDay() {
	show_calendar('frmMain.dspStartDay','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function getEndDay() {
	show_calendar('frmMain.dspEndDay','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function confirmAction()
{
	mapValue();

	if(document.getElementById("para_BnkNo").value == "" && 
		document.getElementById("para_BnkAcct").value == "" &&
		document.getElementById("txtCURRENCY").value == "" &&
		document.getElementById("para_StartDay").value == "0010101" &&
		document.getElementById("para_EndDay").value == "9991231") 
	{
		alert("請輸入查詢條件!!");
		return false;
	}
	
	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF" ;
		document.frmMain.OutputFileName.value = "SusDayRpt.pdf" ;
	}
	else
	{
		document.frmMain.OutputType.value = "XLS" ;
		document.frmMain.OutputFileName.value = "SusDayRpt.XLS" ;
	}

	
	getSqlstm();
	if(document.getElementById("chkOpenNew").checked) {
		document.getElementById("frmMain").target="_blank";
	}else{
		winToolBar.ShowButton( "E" );
		var objOutputFrame = document.getElementById("outputFrame") ;
		document.getElementById("frmMain").target="outputFrame";
		objOutputFrame.height="100%";
		objOutputFrame.width="100%";
		objOutputFrame.src="../reportProcessing.html";
		document.getElementById("inputArea").style.display="none";
		while(true) {
			if(objOutputFrame.readyState=='complete'){
				break;
			} else {
				window.showModalDialog( '<%=request.getContextPath()%>/NewMenu/blank_close.html');
			}
		}
	}
	if(document.getElementById("para_StartAmt").value == "") {
		document.getElementById("para_StartAmt").value = 0 ;
	}
	if(document.getElementById("para_EndAmt").value == ""){
		document.getElementById("para_EndAmt").value = 9999999999999 ;
	}

	// 製作報表
	document.getElementById("frmMain").submit();
}

function mapValue()
{
	document.getElementById("para_StartDay").value = rocDate2String(document.getElementById("dspStartDay").value) ;
	document.getElementById("para_EndDay").value = rocDate2String(document.getElementById("dspEndDay").value) ;	
	document.getElementById("para_BnkNo").value = document.getElementById("txtEBKCD").value ;	
	document.getElementById("para_BnkAcct").value = document.getElementById("txtEATNO").value ;	
}

function checkClientField(objThisItem,bShowMsg)
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";

	if( objThisItem.name == "dspStartDay" )
	{
		bDate = true ;
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false) {
			strTmpMsg = "銀行匯款起日-日期格式有誤";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "dspEndDay" )
	{
		bDate = true ;
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false) {
			strTmpMsg = "銀行匯款迄日-日期格式有誤";
			bReturnStatus = false;
		}
	}

	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg += strTmpMsg + "\r\n";
	}
	return bReturnStatus;	
}

function getSqlstm()
{
	var strSql = " SELECT A.BKNAME,B.EBKCD,B.EATNO,B.EBKRMD,B.ENTAMT,B.EAEGDT,B.ECRDAY,B.EUSREM,B.EUSREM2,B.CROTYPE,B.CSHFCURR,B.CSHFPOCURR,B.CSHFAT ";
	strSql += " FROM CAPBNKF A  JOIN CAPCSHF B ON A.BKCODE = B.EBKCD AND A.BKATNO = B.EATNO AND A.BKCURR=B.CSHFCURR ";
	strSql += " WHERE B.ECRDAY=0 ";

	if(document.getElementById("para_BnkNo").value != ""){
		strSql += " AND B.EBKCD = '" + document.getElementById("para_BnkNo").value + "' ";
	}
	if(document.getElementById("para_BnkAcct").value != ""){
		strSql += " AND B.EATNO = '" + document.getElementById("para_BnkAcct").value + "' ";
	}
	if (document.getElementById("txtCURRENCY").value != ""){
		strSql += " AND B.CSHFCURR = '" + document.getElementById("txtCURRENCY").value +"'";
	}
	//銀行匯款日
	if(document.getElementById("para_StartDay").value != ""){
		strSql += " AND B.EBKRMD >= " + document.getElementById("para_StartDay").value ;
	}
	//銀行匯款日
	if(document.getElementById("para_EndDay").value != ""){
		strSql += " AND B.EBKRMD <= " + document.getElementById("para_EndDay").value ;
	}
	//匯款金額起
	if(document.getElementById("para_StartAmt").value != ""){
		strSql += " AND B.ENTAMT >= " + document.getElementById("para_StartAmt").value ;
	}
	//匯款金額迄
	if(document.getElementById("para_EndAmt").value != ""){
		strSql += " AND B.ENTAMT <= " + document.getElementById("para_EndAmt").value ;
	}

	strSql += " ORDER BY B.EBKCD,B.EATNO,B.EBKRMD,B.ENTAMT,B.EAEGDT,B.ECRDAY,B.EUSREM,B.EUSREM2,B.CROTYPE,B.CSHFCURR,B.CSHFPOCURR,B.CSHFAT ";

	document.getElementById("ReportSQL").value = strSql ;
}

// 離開 Button
function exitAction()
{
	document.getElementById("outputFrame").height = 0;
	document.getElementById("outputFrame").width = 0 ;
	document.getElementById("inputArea").style.display = "block";
	// 顯示確認鍵
	winToolBar.ShowButton( "H,R,E" );
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<P></P>
<DIV id="inputArea">
<FORM name='frmMain' id="frmMain" method='POST' target="_self" action="../servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="0">
	<TR>
		<TD>請選擇報表格式：</TD>
		<TD width="305">
			<input type="radio" name="rdReportForm" id="rdReportForm" Value="PDF" class="Data" checked>PDF 
			<input type="radio" name="rdReportForm" id="rdReportForm" Value="XLS" class="Data">EXCEL
		</TD>
		<TD>&nbsp;</TD>
	</TR>		
	<TR>
		<TD>金融單位代碼 :</TD>
		<TD><INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="">
		    <INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode()" value="代碼查詢">
		    <INPUT type="hidden" name="para_BnkNo" id="para_BnkNo" value=""></TD>
		<TD>(請輸入金資中心代碼)</TD>
	</TR>
	<TR>
		<TD>金融單位代號 :</TD>
		<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value=""></TD>
		<TD><INPUT type="hidden" name="para_BnkAcct" id="para_BnkAcct" value=""></TD>
	</TR>
	<TR>
		<TD>幣別 :</TD>
		<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="3" maxlength="2" value="" class="data"></TD>
		<TD>&nbsp;</TD>
	</TR>
	<TR>
		<TD>銀行匯款起日 :</TD>
		<TD><INPUT type="text" id="dspStartDay" name="dspStartDay" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"><INPUT type="hidden" name="para_StartDay" id="para_StartDay" value=""></TD>
		<TD><A href="#"><img src="../images/misc/show-calendar.gif" alt="查詢" onClick="getStartDay()"></A></TD>
	</TR>
	<TR>
		<TD>銀行匯款迄日 :</TD>
		<TD><INPUT type="text" id="dspEndDay" name="dspEndDay" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"><INPUT type="hidden" name="para_EndDay" id="para_EndDay" value=""></TD>
		<TD><A href="#"><img src="../images/misc/show-calendar.gif" alt="查詢" onClick="getEndDay()"></A></TD>
	</TR>
	<TR>
		<TD>匯款金額 : 起 </TD>
		<TD><INPUT type="text" id="para_StartAmt" name="para_StartAmt" size="15" maxlength="15" value="">
		迄  <INPUT type="text" id="para_EndAmt" name="para_EndAmt" size="15" maxlength="15" value=""></TD>
		<TD>&nbsp;</TD>
	</TR>
</TABLE>

<!--指向RAS所在位置,report也要放在所指路徑-->
<INPUT type="hidden" id="ReportName" name="ReportName" value="SusDayRpt.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="SusDetailRpt.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>SusDayRpt\\">
</FORM>
<BR>
<INPUT type="checkbox" id="chkByAmt" name="chkByAmt">&nbsp;依金額排序
<INPUT type="checkbox" id="chkOpenNew" name="chkOpenNew">&nbsp;開啟新視窗
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
</DIV>
<IFRAME id="outputFrame" name="outputFrame" height="0" width="0"></IFRAME>
</BODY>
</HTML>
