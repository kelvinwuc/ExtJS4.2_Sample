<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.entactbat.CapcshfDTO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 單筆登帳處理
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.10 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntActOneC.jsp,v $
 * Revision 1.10  2014/01/21 09:07:15  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---保留上次的資訊
 *
 * Revision 1.9  2014/01/15 02:30:38  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---保留上次的資訊
 *
 * Revision 1.8  2014/01/08 10:59:15  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---保留上次的資訊
 *
 * Revision 1.7  2014/01/07 10:31:57  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---1.歷史紀錄一筆一行   2.金額允許有小數點
 *
 * Revision 1.6  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%><%! String strThisProgId = "EntActOne"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DecimalFormat df = new DecimalFormat("#,###,###,###,###.##");
String strMsg = (request.getAttribute("txtMsg")!=null?(String)request.getAttribute("txtMsg"):"");
CapcshfDTO preDto = (request.getAttribute("preDto")!=null?(CapcshfDTO)request.getAttribute("preDto"):null);
List<CapcshfDTO> list = (request.getAttribute("history")!=null?(List)request.getAttribute("history"):null);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>單筆登帳</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 			= "txtEBKCD";		//第一個可輸入之Key欄位名稱
var strFirstData 			= "txtEUSREM";		//第一個可輸入之Data欄位名稱
var today = new Date();
// *************************************************************
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
	disableKey();
	disableData();
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtEBKCD" )
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
	else if( objThisItem.name == "txtEATNO" )
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
	else if( objThisItem.name == "dspEBKRMD" )
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
	else if( objThisItem.name == "txtENTAMT" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "匯款金額不可空白";
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

/* 當toolbar frame 中之新增按鈕被點選時,本函數會被執行 */
function addAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
	document.getElementById("txtAction").value = "A"; // 給予預設值
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/* 當toolbar frame 中之<修改>按鈕被點選時,本函數會被執行 */
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );

	enableKey();
	enableData();   
	
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
	enableQueryFields("txtEBKCD,txtEATNO,dspEBKRMD,txtENTAMT,txtCURRENCY");
	document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
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

	document.getElementById("txtEBKCD").value = "";
	document.getElementById("txtEATNO").value = "";
	document.getElementById("txtCURRENCY").value = "";
	document.getElementById("dspEBKRMD").value = "";
	document.getElementById("divWarning").style.display = "none";
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	document.getElementById("divWarning").style.display = "none";
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
		var strSql = "select EBKCD,EATNO,CAST(EBKRMD AS CHAR(7)) as EBKRMD,ENTAMT,EUSREM,CSHFAU,CAST(CSHFAD AS CHAR(8))AS CSHFAD,CAST(CSHFAT AS CHAR(6)) AS CSHFAT,EUSREM2,CSHFCURR,CAST(ECRDAY AS CHAR(8))AS ECRDAY from CAPCSHF where 1 = 1 ";
		if( document.getElementById("txtEBKCD").value != "" )
			strSql += " and EBKCD = '"+document.getElementById("txtEBKCD").value +"' ";

		if( document.getElementById("txtEATNO").value != "" )
			strSql += " and EATNO = '"+document.getElementById("txtEATNO").value +"' ";

		if( document.getElementById("txtCURRENCY").value != "" )
			strSql += " and CSHFCURR = '"+document.getElementById("txtCURRENCY").value +"' ";
			
		if( document.getElementById("dspEBKRMD").value != "" )
			strSql += " and EBKRMD = "+  rocDate2String(document.getElementById("dspEBKRMD").value) +" ";
		
 		if( document.getElementById("txtENTAMT").value != "" )
			strSql += " and ENTAMT = "+ document.getElementById("txtENTAMT").value +" ";

		strSql += " ORDER BY CSHFAD,CSHFAT ";

        var strQueryString = "?parm=parm&Time="+today.getTime()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading2","金融單位代號,金融單位帳號,金融單位匯款日,匯款金額,摘要,備註,幣別");
	session.setAttribute("DisplayFields2", "EBKCD,EATNO,EBKRMD,ENTAMT,EUSREM,EUSREM2,CSHFCURR");
	session.setAttribute("ReturnFields2", "EBKCD,EATNO,EBKRMD,ENTAMT,EUSREM,CSHFAU,CSHFAD,CSHFAT,EUSREM2,CSHFCURR,ECRDAY");
%>
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		if( strReturnValue != "" )
		{
			enableAll();
			var returnArray = string2Array(strReturnValue,",");

			document.getElementById("txtEBKCD").value = returnArray[0];
			document.getElementById("txtEATNO").value = returnArray[1];
			document.getElementById("txtEBKRMD").value = returnArray[2];
			document.getElementById("txtENTAMT").value = returnArray[3];
			document.getElementById("txtEUSREM").value = returnArray[4];
			document.getElementById("txtCSHFAU").value = returnArray[5];
			document.getElementById("txtCSHFAD").value = returnArray[6];
			document.getElementById("txtCSHFAT").value = returnArray[7];
			document.getElementById("txtEUSREM2").value = returnArray[8];
            document.getElementById("txtCURRENCY").value = returnArray[9];

			document.getElementById("txtEBKCD_O").value = returnArray[0];
			document.getElementById("txtEATNO_O").value = returnArray[1];
			document.getElementById("txtEBKRMD_O").value = returnArray[2];
			document.getElementById("txtENTAMT_O").value = returnArray[3];
            document.getElementById("txtCURRENCY_O").value = returnArray[9];

			var varWarning = returnArray[10];
			if(varWarning > 0) {
				document.getElementById("divWarning").style.display = "block";
			}

			//同步顯示欄位及資料欄位
			mapValue("D2P");

			winToolBar.ShowButton( strFunctionKeyInquiry );
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
		if( document.getElementById("txtAction").value != "A"
			&& document.getElementById("txtEBKRMD_O").value != document.getElementById("txtEBKRMD").value 
			&& document.getElementById("txtEUSREM2").value == "" )
		{
			alert("變更匯款日請輸入備註說明!!");
		} else {
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
		document.getElementById("txtEBKRMD").value = rocDate2String(document.getElementById("dspEBKRMD").value) ;
	}else{
		//自資料欄位更新顯示欄位
		document.getElementById("dspEBKRMD").value = string2RocDate(document.getElementById("txtEBKRMD").value) ;
	}
	return ;
}

/*  查詢金融單位代碼及帳號 */
function getBankCode()
{
	if(document.getElementById("txtEBKCD").disabled){
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
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR,BKADDT,BKSTAT from CAPBNKF where 1 = 1 ";
	if( document.getElementById("txtEBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtEBKCD").value +"' ";
	if( document.getElementById("txtEATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtEATNO").value +"' ";
	strSql += " ORDER BY BKCODE,BKADDT ";

	var strQueryString = "?Time="+today.getMilliseconds()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","金融單位代號,金融單位名稱,金融單位帳號,幣別");
	session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR");
	session.setAttribute("ReturnFields", "BKCODE,BKATNO,BKCURR,BKSTAT");
%>
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
	if( strReturnValue != "" )
	{
		enableAll();
		var returnArray = string2Array(strReturnValue,",");
		if(returnArray[3] == "Y") {
			document.getElementById("txtEBKCD").value = returnArray[0];
			document.getElementById("txtEATNO").value = returnArray[1];
			document.getElementById("txtCURRENCY").value = returnArray[2];
		} else {
			alert("金融單位狀態為停用!!");
		}
	}
}
//-->
</script>
</HEAD>
<BODY  onload="WindowOnLoad();">
<P><BR></P>
<form method="post" id="frmMain" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.entactone.EntActOneServlet">
<%
String strEBKCD = "";
String strEATNO = "";
String strCURRENCY = "";
String strEBKRMD = "";
if(preDto != null) {
	strEBKCD = preDto.getEBKCD();
	strEATNO = preDto.getEATNO();
	strCURRENCY = preDto.getCSHFCURR();
	strEBKRMD = String.valueOf(preDto.getEBKRMD());
	if(CommonUtil.AllTrim(strEBKRMD).length() == 7) {
		strEBKRMD = strEBKRMD.substring(0,3) + "/" + strEBKRMD.substring(3,5) + "/" + strEBKRMD.substring(5,7);
	}
}
%>
<DIV id="divWarning" style="display: none;"><font color="red"><b>此筆資料已銷帳!!</b></font><BR></DIV>
<P><BR></P>
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
				<INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="<%=strEBKCD%>" class="Data">
				<INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode();" value="代碼查詢">
			</TD>
			<TD>( 請輸入金資中心代碼 )</TD>
		</TR>
		<TR>
			<TD>金融單位帳號 *:</TD>
			<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value="<%=strEATNO%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>幣別 *:</TD>
			<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="5" maxlength="5" value="<%=strCURRENCY%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融單位匯款日 *:</TD>
			<TD><INPUT type="text" id="dspEBKRMD" name="dspEBKRMD" size="8" maxlength="9" value="<%=strEBKRMD%>" class="Data"  onblur="checkClientField(this,true);"><INPUT name="txtEBKRMD" id="txtEBKRMD"  type="hidden" value=""></TD>
			<TD><A href="javascript:show_calendar('frmMain.dspEBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"  ></A></TD>
		</TR>
		<TR>
			<TD>匯款金額 *:</TD>
			<TD><INPUT type="text" id="txtENTAMT" name="txtENTAMT" size="13" maxlength="13" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>摘要 :</TD>
			<TD><INPUT type="text" id="txtEUSREM" name="txtEUSREM" size="20" maxlength="40" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>備註 :</TD>
			<TD><INPUT type="text" id="txtEUSREM2" name="txtEUSREM2" size="20" maxlength="40" value="" class="Data"></TD>
			<TD></TD>
		</TR>
	</TBODY>
</TABLE>
<BR>* 為必須輸入項目
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">

<INPUT type="hidden" id="txtEBKCD_O" name="txtEBKCD_O" value="">
<INPUT type="hidden" id="txtEATNO_O" name="txtEATNO_O" value="">
<INPUT type="hidden" id="txtCURRENCY_O" name="txtCURRENCY_O" value="">
<INPUT type="hidden" id="txtEBKRMD_O" name="txtEBKRMD_O" value="">
<INPUT type="hidden" id="txtENTAMT_O" name="txtENTAMT_O" value="">
<INPUT type="hidden" id="txtCSHFAU" name="txtCSHFAU">
<INPUT type="hidden" id="txtCSHFAD" name="txtCSHFAD">
<INPUT type="hidden" id="txtCSHFAT" name="txtCSHFAT">

</form>
<BR>
當日最近輸入資料列表 :
<TABLE id=displayTable name=displayTable width="80%" border=1>
	<THEAD>
		<TR>
			<TD align="center" width="15%">金融單位代碼</TD>
			<TD align="center" width="15%">帳號</TD>
			<TD align="center" width="10%">幣別</TD>
			<TD width="10%" align="center">匯款日</TD>
			<TD width="20%" align="center">匯款金額</TD>
			<TD width="15%" align="center">摘要</TD>
			<TD width="15%" align="center">備註</TD>
		</TR>
	</THEAD>
	<TBODY id="displayBody" name="displayBody" align="center">
<% if(list!=null && list.size() > 0) {
	CapcshfDTO dto = null;
	for(int i=0; i<list.size(); i++) {
		dto = list.get(i); %>
		<TR>
			<TD><%=dto.getEBKCD()%></TD>
			<TD><%=dto.getEATNO()%></TD>
			<TD><%=dto.getCSHFCURR()%></TD>
			<TD><%=dto.getEBKRMD()%></TD>
			<TD><%=df.format(dto.getENTAMT())%></TD>
			<TD><%=(CommonUtil.AllTrim(dto.getEUSREM()).equals(""))?"&nbsp;":dto.getEUSREM()%></TD>
			<TD><%=(CommonUtil.AllTrim(dto.getEUSREM2()).equals(""))?"&nbsp;":dto.getEUSREM2()%></TD>
		</TR>
<% 	} %>
<% } %>
	</TBODY>
</TABLE>
</BODY>
</HTML>

