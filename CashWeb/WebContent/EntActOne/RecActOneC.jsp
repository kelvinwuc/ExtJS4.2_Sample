<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 單筆入帳處理
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : MISSALLY
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: RecActOneC.jsp,v $
 * Revision 1.3  2014/02/14 06:42:52  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---修正多對一時多筆不需銷帳的資料被銷到
 *
 * Revision 1.2  2014/01/21 09:07:15  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---保留上次的資訊
 *
 * Revision 1.1  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%><%! String strThisProgId = "RecActOne"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
String strMsg = (request.getAttribute("txtMsg")!=null?(String)request.getAttribute("txtMsg"):"");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>單筆入帳處理</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 			= "txtCBKCD";		//第一個可輸入之Key欄位名稱
var strFirstData 			= "txtCATNO";		//第一個可輸入之Data欄位名稱
var today = new Date();
// *************************************************************
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial, '' ) ;
	disableKey();
	disableData();
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtCBKCD" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "金融單位代碼不可空白";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.name == "txtCATNO" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "金融單位帳號不可空白";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.name == "txtCURRENCY" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "幣別不可空白";
				bReturnStatus = false;
			}
		}
	}	
	else if( objThisItem.name == "dspCBKRMD" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "金融單位匯款日不可空白";
				bReturnStatus = false;
			}
		}	 
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "金融單位匯款日-日期格式有誤";
	        bReturnStatus = false;			
        }
	}
	else if( objThisItem.name == "txtCROAMT" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "入帳金額不可空白";
				bReturnStatus = false;
			}
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

/* 當toolbar frame 中之<修改>按鈕被點選時,本函數會被執行 */
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );

	disableAll();
	enableQueryFields("txtCATNO,dspCBKRMD");

	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstData) != null )
			document.getElementById(strFirstData).focus() ;
	}

	document.getElementById("txtAction").value = "U";
}

/* 當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行 */
function inquiryAction()
{
	winToolBar.ShowButton( strFunctionKeyInquiry1 );
	enableQueryFields("txtCBKCD,txtCATNO,dspCBKRMD,txtCROAMT,txtCURRENCY");
	document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
}

/* 當toolbar frame 中之<確定>按鈕被點選時,本函數會被執行 */
function confirmAction()
{
	if( document.getElementById("txtAction").value == "I" )
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
		var strSql = "select CBKCD,CATNO,CAST(CBKRMD AS CHAR(7)) as CBKRMD,CROAMT,CROSRC,CSFBAU,CAST(CSFBAD AS CHAR(8))AS CSFBAD,CAST(CSFBAT AS CHAR(6)) AS CSFBAT,CAST(CAEGDT AS CHAR(7)) as CAEGDT,CSFBRECTNO,CAST(CSFBRECSEQ as INT) as CSFBRECSEQ,CSFBPONO,CSFBCURR from CAPCSHFB where 1 = 1 ";
		if( document.getElementById("txtCBKCD").value != "" )
			strSql += " and CBKCD = '"+document.getElementById("txtCBKCD").value +"' ";

		if( document.getElementById("txtCATNO").value != "" )
			strSql += " and CATNO = '"+document.getElementById("txtCATNO").value +"' ";

		if( document.getElementById("txtCURRENCY").value != "" )
			strSql += " and CSFBCURR = '"+document.getElementById("txtCURRENCY").value +"' ";
			
		if( document.getElementById("dspCBKRMD").value != "" )
			strSql += " and CBKRMD = "+  rocDate2String(document.getElementById("dspCBKRMD").value) +" ";
		
 		if( document.getElementById("txtCROAMT").value != "" )
			strSql += " and CROAMT = "+ document.getElementById("txtCROAMT").value +" ";

		strSql += " ORDER BY CSFBAD,CSFBAT ";

        var strQueryString = "?parm=parm&Time="+today.getTime()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading2","金融單位代號,金融單位帳號,金融單位匯款日,匯款金額,全球入帳日");
	session.setAttribute("DisplayFields2", "CBKCD,CATNO,CBKRMD,CROAMT,CAEGDT");
	session.setAttribute("ReturnFields2", "CBKCD,CATNO,CBKRMD,CROAMT,CROSRC,CSFBAU,CSFBAD,CSFBAT,CAEGDT,CSFBRECTNO,CSFBRECSEQ,CSFBPONO,CSFBCURR");
%>
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		if( strReturnValue != "" )
		{
			enableAll();
			var returnArray = string2Array(strReturnValue,",");

			document.getElementById("txtCBKCD").value = returnArray[0];
			document.getElementById("txtCATNO").value = returnArray[1];
			document.getElementById("txtCBKRMD").value = returnArray[2];
			document.getElementById("txtCROAMT").value = returnArray[3];
			document.getElementById("txtCROSRC").value = returnArray[4];
			document.getElementById("txtCSFBAU").value = returnArray[5];
			document.getElementById("txtCSFBAD").value = returnArray[6];
			document.getElementById("txtCSFBAT").value = returnArray[7];
			document.getElementById("txtCAEGDT").value = returnArray[8];
			document.getElementById("txtCSFBRECTNO").value = returnArray[9];
			document.getElementById("txtCSFBRECSEQ").value = returnArray[10];
			document.getElementById("txtCSFBPONO").value = returnArray[11];
            document.getElementById("txtCURRENCY").value = returnArray[12];

			document.getElementById("txtCBKCD_O").value = returnArray[0];
			document.getElementById("txtCATNO_O").value = returnArray[1];
			document.getElementById("txtCBKRMD_O").value = returnArray[2];
			document.getElementById("txtCROAMT_O").value = returnArray[3];
            document.getElementById("txtCURRENCY_O").value = returnArray[12];

			//同步顯示欄位及資料欄位
			mapValue("D2P");
			disableAll();
			winToolBar.ShowButton( strDISBFunctionKeySourceU );
		}
	}
}

/* 當toolbar frame 中之<儲存>按鈕被點選時,本函數會被執行 */
function saveAction()
{
	enableAll();
	mapValue("P2D");
	if( areAllFieldsOK() )
	{
		if( document.getElementById("txtCATNO").value == "" ) {
			alert("金融單位帳號不可空白!!");
		} else if( document.getElementById("txtCBKRMD").value == "" ) {
			alert("金融單位匯款日不可空白!!");
		} else {
			if(document.getElementById("txtCROSRC").value != "9") {
				if (window.confirm("儲存完畢後，是否要核銷該筆入帳資料?")) {
					document.getElementById("nextAction").value = "Writeoffs";
				}
			} else {
				alert("GTMS請至「整批銷帳處理」核銷該筆入帳資料!!");
			}
			document.getElementById("frmMain").submit();
		}
	}
	else
		alert( strErrMsg );
}

/*
函數名稱:	mapValue( direction )
函數功能:	同步顯示欄位及資料欄位
傳入參數:	資料同步的方向 (P2D: Display to Data, D2P: data to display )
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function mapValue(direction){
	if(direction.toUpperCase()=="P2D"){
		//自 顯示欄位更新資料欄位
		document.getElementById("txtCBKRMD").value = rocDate2String(document.getElementById("dspCBKRMD").value) ;
	}else{
		//自資料欄位更新顯示欄位
		document.getElementById("dspCBKRMD").value = string2RocDate(document.getElementById("txtCBKRMD").value) ;
	}
	return ;
}

/*  查詢金融單位代碼及帳號 */
function getBankCode()
{
	if(document.getElementById("txtCBKCD").disabled){
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
	if( document.getElementById("txtCBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtCBKCD").value +"' ";
	if( document.getElementById("txtCATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtCATNO").value +"' ";
	strSql += " ORDER BY BKCODE,BKADDT ";

	var strQueryString = "?Time="+today.getMilliseconds()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=600";
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
		document.getElementById("txtCBKCD").value = returnArray[0];
		document.getElementById("txtCATNO").value = returnArray[1];
		document.getElementById("txtCURRENCY").value = returnArray[2];
	}
}
//-->
</script>
</HEAD>
<BODY  onload="WindowOnLoad();">
<P><BR></P>
<form method="post" id="frmMain" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.entactone.RecActOneServlet">
<TABLE border="0">
	<TBODY>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融單位代碼 *:</TD>
			<TD>
				<INPUT type="text" id="txtCBKCD" name="txtCBKCD" size="4" maxlength="4" value="" class="Data">
				<INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode();" value="代碼查詢">
			</TD>
			<TD>( 請輸入金資中心代碼 )</TD>
		</TR>
		<TR>
			<TD>金融單位帳號 *:</TD>
			<TD><INPUT type="text" id="txtCATNO" name="txtCATNO" size="17" maxlength="17" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>幣別 *:</TD>
			<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="5" maxlength="5" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融單位匯款日 *:</TD>
			<TD><INPUT type="text" id="dspCBKRMD" name="dspCBKRMD" size="8" maxlength="9" value="" class="Data"  onblur="checkClientField(this,true);"><INPUT name="txtCBKRMD" id="txtCBKRMD"  type="hidden" value=""></TD>
			<TD><A href="javascript:show_calendar('frmMain.dspCBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"  ></A></TD>
		</TR>
		<TR>
			<TD>入帳金額 *:</TD>
			<TD><INPUT type="text" id="txtCROAMT" name="txtCROAMT" size="13" maxlength="13" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>全球入帳日 :</TD>
			<TD><INPUT type="text" id="txtCAEGDT" name="txtCAEGDT" size="8" maxlength="9" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>付款方式 :</TD>
			<TD><INPUT type="text" id="txtCROSRC" name="txtCROSRC" size="20" maxlength="40" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>送金單號碼 :</TD>
			<TD><INPUT type="text" id="txtCSFBRECTNO" name="txtCSFBRECTNO" size="10" maxlength="9" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>送金單序號 :</TD>
			<TD><INPUT type="text" id="txtCSFBRECSEQ" name="txtCSFBRECSEQ" size="5" maxlength="3" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>保單號碼 :</TD>
			<TD><INPUT type="text" id="txtCSFBPONO" name="txtCSFBPONO" size="10" maxlength="10" value="" class="Data"></TD>
			<TD></TD>
		</TR>
	</TBODY>
</TABLE>              
<BR>* 為必須輸入項目
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="nextAction" name="nextAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">

<INPUT type="hidden" id="txtCBKCD_O" name="txtCBKCD_O" value="">
<INPUT type="hidden" id="txtCATNO_O" name="txtCATNO_O" value="">
<INPUT type="hidden" id="txtCURRENCY_O" name="txtCURRENCY_O" value="">
<INPUT type="hidden" id="txtCBKRMD_O" name="txtCBKRMD_O" value="">
<INPUT type="hidden" id="txtCROAMT_O" name="txtCROAMT_O" value="">
<INPUT type="hidden" id="txtCSFBAU" name="txtCSFBAU">
<INPUT type="hidden" id="txtCSFBAD" name="txtCSFBAD">
<INPUT type="hidden" id="txtCSFBAT" name="txtCSFBAT">

</form>
</BODY>
</HTML>

