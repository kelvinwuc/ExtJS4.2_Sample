<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 登銷帳查詢
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.8 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntCroInq.jsp,v $
 * Revision 1.8  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%><%! String strThisProgId = "EntCroInq"; //本程式代號 %><% 
String strMsg = (request.getAttribute("txtMsg") == null)?"":(String)request.getAttribute("txtMsg");

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>登銷帳查詢</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientI.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script language="javaScript">
<!--
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	WindowOnLoadCommon(document.title, '', strFunctionKeyInitial, '');
	window.status = "";
}

/* 當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行 */
function inquiryAction()
{
	var form1 =	document.mainForm ; 
	if(	form1.EBKCD.value=="" && form1.EATNO.value=="" && form1.EBKRMD.value=="" && form1.ENTAMT.value=="" ){
		alert("請輸入查詢條件");
		return;
	}
	form1.PAGEINDEX.value = 0 ;
	form1.submit();
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("mainForm").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*  查詢金融單位代碼及帳號 */
function getBankCode()
{
	//檢查是否於可查詢的狀態
	if(document.getElementById("EBKCD").disabled){
		return ;
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
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR,BKADDT from CAPBNKF where 1 = 1 ";
	if( document.getElementById("EBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("EBKCD").value +"' ";
	if( document.getElementById("EATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("EATNO").value +"' ";
	strSql +=" order by bkcode,bkaddt "       
	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";

	<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","金融單位代號,金融單位名稱,金融單位帳號,幣別");
	session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR");
	session.setAttribute("ReturnFields", "BKCODE,BKATNO,BKCURR");
	%>

	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );

	if( strReturnValue != "" )
	{
		var returnArray = string2Array(strReturnValue,",");
		document.getElementById("EBKCD").value = returnArray[0];
		document.getElementById("EATNO").value = returnArray[1];
		document.getElementById("CSHFCURR").value = returnArray[2];
	}
}

/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	var bDate = true;
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bReturnStatus = false;
	}	
	if( objThisItem.id == "EBKRMD" )
	{
		bDate = true ;		
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false){
			strTmpMsg = "金融單位匯款日(起)-日期格式有誤";
			bReturnStatus = false;
		}		
	}
	if( objThisItem.id == "EBKRMD2" )
	{
		bDate = true ;		
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false){
			strTmpMsg = "金融單位匯款日(迄)-日期格式有誤";
			bReturnStatus = false;
		}		
	}

	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
		{
    		strErrMsg += strTmpMsg + "\r\n";
		}
	}

	return bReturnStatus;
}	
//-->
</script>
</HEAD>
<body bgcolor="#ffffff" onload="WindowOnLoad();">
<form id="mainForm" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.entCroInq.EntCroInqServlet?act=query" name="mainForm" target="iframe" >
<TABLE border="0">
	<TBODY>		
		<TR>
			<TD>金融單位代碼 :</TD>
			<TD>
				<INPUT type="text" id="EBKCD" name="EBKCD" size="4" maxlength="4" value="" class="Key">
				<INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode()" value="代碼查詢" readOnly>
			</TD>
			<TD>( 請輸入金資中心代碼 )</TD>
		</TR>
		<TR>
			<TD>金融單位帳號 :</TD>
			<TD><INPUT type="text" id="EATNO" name="EATNO" size="17" maxlength="17" value="" class="Key" ></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>幣別 :</TD>
			<TD><INPUT type="text" id="CSHFCURR" name="CSHFCURR" size="3" maxlength="2" value="" class="Key" ></TD>
			<TD></TD>
		</TR>		
		<TR>
			<TD>金融單位匯款日(起) :</TD>
            <TD><INPUT class="Data" size="11" type="text" maxlength="11"
				id="EBKRMD" name="EBKRMD" value="" onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('mainForm.EBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>				
			</TD>
			<TD>(YYY/MM/DD)</TD>	
		</TR>
		<TR>
			<TD>金融單位匯款日(迄) :</TD>
            <TD><INPUT class="Data" size="11" type="text" maxlength="11"
				id="EBKRMD2" name="EBKRMD2" value="" onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('mainForm.EBKRMD2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>				
			</TD>
			<TD>(YYY/MM/DD)</TD>	
		</TR>
		<TR>
			<TD>匯款金額 :</TD>
			<TD><INPUT type="text" id="ENTAMT" name="ENTAMT" size="13" maxlength="13" value="" class="Key"></TD>
			<TD></TD>
		</TR>
	</TBODY>
</TABLE>              
<input type="hidden" id="PAGEINDEX" name="PAGEINDEX" value="0">
<input type="hidden" id="txtAction" name="txtAction" value="">
</form>
<iframe height="400" width="100%" name="iframe" frameborder="0"></iframe>
</body>
</html>