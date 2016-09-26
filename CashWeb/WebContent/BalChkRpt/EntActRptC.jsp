<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 銀行登帳報表
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
 * $Log: EntActRptC.jsp,v $
 * Revision 1.8  2014/02/25 09:04:20  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 還原
 *
 * Revision 1.7  2014/02/25 03:41:56  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 還原
 *
 * Revision 1.6  2014/02/19 08:52:30  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 還原
 *
 * Revision 1.5  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%><%! String strThisProgId = "EntActRptC"; //本程式代號 %><%
GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>銀行登帳報表</TITLE>
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
		window.alert(document.getElementById("txtMsg").value) ;
	WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' ) ;
}

/*  查詢金融單位代碼及帳號  */
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
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR,BKADDT from CAPBNKF where 1 = 1 ";
	if( document.getElementById("txtEBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtEBKCD").value +"' ";
	if( document.getElementById("txtEATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtEATNO").value +"' ";
	if( document.getElementById("txtCURRENCY").value != "" )
		strSql += " and BKCURR = '"+document.getElementById("txtCURRENCY").value +"' ";	
	strSql += " ORDER BY BKCODE,BKADDT";
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

function getEBKRMD_S1() {
	show_calendar('frmMain.dspEBKRMD_S1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_E1() {
	show_calendar('frmMain.dspEBKRMD_E1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function confirmAction() {
	mapValue();

	if(document.getElementById("txtEBKCD").value == "" &&
		document.getElementById("txtEATNO").value == "" &&
		document.getElementById("txtCURRENCY").value == "" &&
		document.getElementById("para_EBKRMD_S1").value == "0010101" &&
		document.getElementById("para_EBKRMD_E1").value == "9991231")
	{
		alert("請輸入查詢條件!!");
		return false;
	}

	getSqlstm();
	
	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF" ;
		document.frmMain.OutputFileName.value = "EntActRpt.pdf" ;
	}
	else
	{
		document.frmMain.OutputType.value = "XLS" ;
		document.frmMain.OutputFileName.value = "EntActRpt.XLS" ;
	}
	if(document.frmMain.rdRpType[0].checked)
	{
		document.getElementById("para_RpType").value ="1";
	}
	else
	{
		document.getElementById("para_RpType").value ="2";
	}

	if(document.getElementById("chkOpenNew").checked){
		document.getElementById("frmMain").target="_blank";
	}else{
		winToolBar.ShowButton( "E" );
		var objOutputFrame = document.getElementById("outputFrame") ;
		document.getElementById("frmMain").target="outputFrame";
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
	}

	// 製作報表
	document.getElementById("frmMain").submit();
}

function mapValue(){
	document.getElementById("para_EBKRMD_S1").value = rocDate2String(document.getElementById("dspEBKRMD_S1").value) ;	
	document.getElementById("para_EBKRMD_E1").value = rocDate2String(document.getElementById("dspEBKRMD_E1").value) ;	
	document.getElementById("para_BnkNo").value = document.getElementById("txtEBKCD").value ;	
	document.getElementById("para_BnkAcct").value = document.getElementById("txtEATNO").value ;	
	document.getElementById("para_CURRENCY").value = document.getElementById("txtCURRENCY").value ;		
}

function checkClientField(objThisItem,bShowMsg ){
	var bDate = true;
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
	}	
	if( objThisItem.id == "para_EBKRMD_S1" || objThisItem.id == "para_EBKRMD_E1")
	{
		bDate = true ;		
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false){
			strTmpMsg = "日期格式有誤";
			bShowMsg = true;
		}		
	}
}

function getSqlstm(){
   var strSql ="";

	if(document.frmMain.rdRpType[0].checked)
	{
		strSql = " select * FROM CAPBNKF A, CAPCSHF B ";
	}
	else
	{
		strSql = " SELECT A.BKNAME,B.EBKCD, B.EATNO, B.EBKRMD,SUM(B.ENTAMT) AS ENTAMT,B.CSHFCURR FROM CAPBNKF A, CAPCSHF B ";
	}

	strSql += " WHERE a.bkcode = b.ebkcd and a.bkatno = b.eatno AND A.BKCURR=B.CSHFCURR ";
	if(document.getElementById("para_BnkNo").value != ""){
		strSql += " AND A.BKCODE = '" + document.getElementById("para_BnkNo").value + "' ";
	}
	if(document.getElementById("para_BnkAcct").value != ""){
		strSql += " AND A.BKATNO = '" + document.getElementById("para_BnkAcct").value + "' ";
	}
	if(document.getElementById("para_CURRENCY").value != ""){
		strSql += " AND A.BKCURR = '" + document.getElementById("para_CURRENCY").value + "' ";
	}
	if(document.getElementById("para_EBKRMD_S1").value != ""){
		strSql += " AND B.EBKRMD >= " + document.getElementById("para_EBKRMD_S1").value ;
	}
	if(document.getElementById("para_EBKRMD_E1").value != ""){
		strSql += " AND B.EBKRMD <= " + document.getElementById("para_EBKRMD_E1").value ;
	}
	if(document.frmMain.rdRpType[0].checked) {
		strSql +=" ORDER BY B.EBKCD, B.EATNO, B.EBKRMD";
	}
	else
	{
		strSql +=" GROUP BY A.BKNAME, B.EBKCD, B.EATNO, B.CSHFCURR,B.EBKRMD ORDER BY B.EBKCD, B.EATNO,B.EBKRMD";
	}

	document.getElementById("ReportSQL").value = strSql;
}

// 離開 Button
function exitAction(){
	document.getElementById("outputFrame").height = 0;
	document.getElementById("outputFrame").width = 0 ;
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
<FORM name='frmMain' id="frmMain" method='POST' target="_self" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="0">
	<TR>	
		<TD>請選擇報表格式：</TD>
		<TD width="305">
		  <input type="radio" name="rdReportForm" id="rdReportForm" Value="PDF" class="Data" checked>PDF 
		  <input type="radio" name="rdReportForm" id="rdReportForm" Value="XLS" class="Data">EXCEL</TD>
	</TR>
	<TR>
		<TD>請選擇Query：</TD>
		<TD width="305">
		  <input type="radio" name="rdRpType" id="rdRpType" Value="1" class="Data" checked>登帳明細 
		  <input type="radio" name="rdRpType" id="rdRpType" Value="2" class="Data">登帳彙總<INPUT id="para_RpType" name="para_RpType" value="" type="hidden"></TD>
	</TR>		
	<TR>
		<TD>金融單位代碼 :</TD>
		<TD><INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="">
		    <INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode()" value="代碼查詢"></TD>
		<TD>(請輸入金資中心代碼)<INPUT type="hidden" name="para_BnkNo" id="para_BnkNo" value=""></TD>
	</TR>
	<TR>
		<TD>金融單位代號 :</TD>
		<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value=""></TD>
		<TD><INPUT type="hidden" name="para_BnkAcct" id="para_BnkAcct" value=""></TD>
	</TR>
	<TR>
		<TD>幣別 :</TD>
		<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="17" maxlength="17" value=""></TD>
		<TD><INPUT type="hidden" name="para_CURRENCY" id="para_CURRENCY" value=""></TD>
	</TR>
	<TR>
		<TD>銀行匯款起日 :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_S1" name="dspEBKRMD_S1" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);" ></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEBKRMD_S1()"></A><INPUT type="hidden" name="para_EBKRMD_S1" id="para_EBKRMD_S1" value=""></TD>
	</TR>
	<TR>
		<TD>銀行匯款迄日 :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_E1" name="dspEBKRMD_E1" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getEBKRMD_E1()"></A><INPUT type="hidden" name="para_EBKRMD_E1" id="para_EBKRMD_E1" value=""></TD>
	</TR>
</TABLE>

<!--指向RAS所在位置,report也要放在所指路徑-->
<INPUT type="hidden" id="ReportName" name="ReportName" value="EntActRpt.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="EntActRpt.pdf">
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
