<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 銀行對帳彙總表(各銀行未銷已銷帳彙總表)
 * 
 * Remark   : 對帳報表
 * 
 * Revision : $Revision: 1.8 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: BalDayRptC.jsp,v $
 * Revision 1.8  2014/02/19 08:52:30  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 還原
 *
 * Revision 1.7  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%><%! String strThisProgId = "BalDayRptC"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();
%>
<HTML>
<HEAD>
<TITLE>各銀行未銷已銷帳彙總表</TITLE>
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
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' ) ;
}

/* 查詢金融單位代碼及帳號  */
function getBankCode()
{
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
	strSql += " ORDER BY BKCODE";

	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
    session.setAttribute("Heading","金融單位代號,金融單位名稱,金融單位帳號,幣別");
    session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR");
    session.setAttribute("ReturnFields", "BKCODE,BKATNO,BKCURR");
%>
	var strReturnValue = window.showModalDialog( "../CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );

	if( strReturnValue != "" )
	{
		enableAll();
		var returnArray = string2Array(strReturnValue,",");
		document.getElementById("txtEBKCD").value = returnArray[0];
		document.getElementById("txtEATNO").value = returnArray[1];
		document.getElementById("txtCURRENCY").value = returnArray[2];
	}
}

//R00393
function getEBKRMD_S1() {
	show_calendar('frmMain.dspEBKRMD_S1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_E1() {
	show_calendar('frmMain.dspEBKRMD_E1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_S2() {
	show_calendar('frmMain.dspEBKRMD_S2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_E2() {
	show_calendar('frmMain.dspEBKRMD_E2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_S3() {
	show_calendar('frmMain.dspEBKRMD_S3','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_E3() {
	show_calendar('frmMain.dspEBKRMD_E3','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_S1() {
	show_calendar('frmMain.dspEAEGDT_S1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_E1() {
	show_calendar('frmMain.dspEAEGDT_E1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_S2() {
	show_calendar('frmMain.dspEAEGDT_S2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_E2() {
	show_calendar('frmMain.dspEAEGDT_E2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_S3() {
	show_calendar('frmMain.dspEAEGDT_S3','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_E3() {
	show_calendar('frmMain.dspEAEGDT_E3','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function confirmAction() {
	mapValue();

	if(document.getElementById("txtEBKCD").value == "" &&
		document.getElementById("txtEATNO").value == "" &&
		document.getElementById("txtCURRENCY").value == "" &&
		document.getElementById("EBKRMD_S1").value == "0010101" &&
		document.getElementById("EBKRMD_E1").value == "9991231" &&	
		document.getElementById("EBKRMD_S2").value == "0010101" &&
		document.getElementById("EBKRMD_E2").value == "9991231" &&	
		document.getElementById("EBKRMD_S3").value == "0010101" &&
		document.getElementById("EBKRMD_E3").value == "9991231" &&
		document.getElementById("EAEGDT_S1").value == "0010101" &&
		document.getElementById("EAEGDT_E1").value == "9991231" &&	
		document.getElementById("EAEGDT_S2").value == "0010101" &&
		document.getElementById("EAEGDT_E2").value == "9991231" &&	
		document.getElementById("EAEGDT_S3").value == "0010101" &&
		document.getElementById("EAEGDT_E3").value == "9991231")
	{
		alert("請輸入查詢條件!!");
		return false;
	}

	winToolBar.ShowButton( "E" );
	var objOutputFrame = document.getElementById("outputFrame") ;
	objOutputFrame.height="100%";
	objOutputFrame.width="100%";
	objOutputFrame.src="<%=request.getContextPath()%>/reportProcessing.html";
	document.getElementById("inputArea").style.display="none";
	while(true){
		if(objOutputFrame.readyState=='complete'){
			break;
		}else{
			window.showModalDialog( '<%=request.getContextPath()%>/NewMenu/blank_close.html');
		}
	}
	document.getElementById("frmMain").submit();
}

function mapValue() {
	document.getElementById("EBKRMD_S1").value = rocDate2String(document.getElementById("dspEBKRMD_S1").value) ;	
	document.getElementById("EBKRMD_E1").value = rocDate2String(document.getElementById("dspEBKRMD_E1").value) ;	
	document.getElementById("EBKRMD_S2").value = rocDate2String(document.getElementById("dspEBKRMD_S2").value) ;
	document.getElementById("EBKRMD_E2").value = rocDate2String(document.getElementById("dspEBKRMD_E2").value) ;	
	document.getElementById("EBKRMD_S3").value = rocDate2String(document.getElementById("dspEBKRMD_S3").value) ;
	document.getElementById("EBKRMD_E3").value = rocDate2String(document.getElementById("dspEBKRMD_E3").value) ;
	document.getElementById("EAEGDT_S1").value = rocDate2String(document.getElementById("dspEAEGDT_S1").value) ;
	document.getElementById("EAEGDT_E1").value = rocDate2String(document.getElementById("dspEAEGDT_E1").value) ;	
	document.getElementById("EAEGDT_S2").value = rocDate2String(document.getElementById("dspEAEGDT_S2").value) ;
	document.getElementById("EAEGDT_E2").value = rocDate2String(document.getElementById("dspEAEGDT_E2").value) ;	
	document.getElementById("EAEGDT_S3").value = rocDate2String(document.getElementById("dspEAEGDT_S3").value) ;
	document.getElementById("EAEGDT_E3").value = rocDate2String(document.getElementById("dspEAEGDT_E3").value) ;	
	document.getElementById("EBKCD").value = document.getElementById("txtEBKCD").value ;	
	document.getElementById("EATNO").value = document.getElementById("txtEATNO").value ;	
	document.getElementById("CURRENCY").value = document.getElementById("txtCURRENCY").value ;		
}

function checkClientField(objThisItem,bShowMsg) {

	var bReturnStatus = true;
	var strTmpMsg = "";
	var bDate = true;
	if( objThisItem.name == "dspEBKRMD_S1" || objThisItem.name == "dspEBKRMD_E1" || objThisItem.name == "dspEBKRMD_S2" ||
	    objThisItem.name == "dspEBKRMD_E2" || objThisItem.name == "dspEBKRMD_S3" || objThisItem.name == "dspEBKRMD_E3" ||
	    objThisItem.name == "dspEAEGDT_S1" || objThisItem.name == "dspEAEGDT_E1" || objThisItem.name == "dspEAEGDT_S2" ||
	    objThisItem.name == "dspEAEGDT_E2" || objThisItem.name == "dspEAEGDT_S3" || objThisItem.name == "dspEAEGDT_E3")
	{
		bDate = true ;		
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false){
			strTmpMsg = "日期格式有誤";
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

// 離開 Button
function exitAction() {
	document.getElementById("outputFrame").height = 0;
	document.getElementById("outputFrame").width = 0;
	document.getElementById("inputArea").style.display="block";
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
<FORM id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.balchkrpt.BalanceRptServlet?act=query">
<TABLE border="0">
	<TR>
		<TD>金融單位代碼 :</TD>
		<TD><INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="">
		    <INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode();" value="代碼查詢"></TD>
		<TD>(請輸入金資中心代碼)<INPUT type="hidden" name="EBKCD" id="EBKCD" value=""></TD>
	</TR>
	<TR>
		<TD>金融單位代號 :</TD>
		<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value=""></TD>
		<TD><INPUT type="hidden" name="EATNO" id="EATNO" value=""></TD>
	</TR>
	<TR>
		<TD>幣別 :</TD>
		<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="3" maxlength="2" value="" ></TD>
		<TD><INPUT type="hidden" name="CURRENCY" id="CURRENCY" value=""></TD>
	</TR>
    <TR><TD class="TableHeading">未銷帳:</TD></TR>
	<TR>
		<TD>銀行匯款起日 :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_S1" name="dspEBKRMD_S1" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEBKRMD_S1();"></A><INPUT type="hidden" name="EBKRMD_S1" id="EBKRMD_S1" value=""></TD>
	</TR>
	<TR>
		<TD>銀行匯款迄日 :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_E1" name="dspEBKRMD_E1" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEBKRMD_E1();"></A><INPUT type="hidden" name="EBKRMD_E1" id="EBKRMD_E1" value=""></TD>
	</TR>
	<TR>
		<TD>全球入帳起日 :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_S1" name="dspEAEGDT_S1" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEAEGDT_S1();"></A><INPUT type="hidden" name="EAEGDT_S1" id="EAEGDT_S1" value=""></TD>
	</TR>
	<TR>
		<TD>全球入帳迄日 :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_E1" name="dspEAEGDT_E1" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEAEGDT_E1();"></A><INPUT type="hidden" name="EAEGDT_E1" id="EAEGDT_E1" value=""></TD>
	</TR>
	<TR><TD class="TableHeading">已銷帳(1):</TD></TR>
	<TR>
		<TD>銀行匯款起日 :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_S2" name="dspEBKRMD_S2" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEBKRMD_S2();"></A><INPUT type="hidden" name="EBKRMD_S2" id="EBKRMD_S2" value=""></TD>
	</TR>
	<TR>
		<TD>銀行匯款迄日 :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_E2" name="dspEBKRMD_E2" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEBKRMD_E2();"></A><INPUT type="hidden" name="EBKRMD_E2" id="EBKRMD_E2" value=""></TD>
	</TR>
	<TR>
		<TD>全球入帳起日 :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_S2" name="dspEAEGDT_S2" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEAEGDT_S2();"></A><INPUT type="hidden" name="EAEGDT_S2" id="EAEGDT_S2" value=""></TD>
	</TR>
	<TR>
		<TD>全球入帳迄日 :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_E2" name="dspEAEGDT_E2" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEAEGDT_E2();"></A><INPUT type="hidden" name="EAEGDT_E2" id="EAEGDT_E2" value=""></TD>
	</TR>
	<TR>
    <TD class="TableHeading">已銷帳(2):</TD>
    </TR>
	<TR>
		<TD>銀行匯款起日 :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_S3" name="dspEBKRMD_S3" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEBKRMD_S3();"></A><INPUT type="hidden" name="EBKRMD_S3" id="EBKRMD_S3" value=""></TD>
	</TR>
	<TR>
		<TD>銀行匯款迄日 :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_E3" name="dspEBKRMD_E3" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEBKRMD_E3();"></A><INPUT type="hidden" name="EBKRMD_E3" id="EBKRMD_E3" value=""></TD>
	</TR>
	<TR>
		<TD>全球入帳起日 :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_S3" name="dspEAEGDT_S3" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEAEGDT_S3();"></A><INPUT type="hidden" name="EAEGDT_S3" id="EAEGDT_S3" value=""></TD>
	</TR>
	<TR>
		<TD>全球入帳迄日 :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_E3" name="dspEAEGDT_E3" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEAEGDT_E3();"></A><INPUT type="hidden" name="EAEGDT_E3" id="EAEGDT_E3" value=""></TD>
	</TR>
</TABLE>

<!--指向RAS所在位置,report也要放在所指路徑-->
<INPUT type="hidden" id="ReportName" name="ReportName" value="BalanceRpt.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="BalanceRpt.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>BalChkRpt\\">
</FORM>

<BR>
<INPUT type="checkbox" id="chkOpenNew" name="chkOpenNew">&nbsp;開啟新視窗
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
</DIV>
<IFRAME id="outputFrame" name="outputFrame" height="0" width="0"></IFRAME>
</BODY>
</HTML>