<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.crooutone.CroOutOneConditionDTO" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 單筆銷帳處理
 * 
 * Remark   : 
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
 * $Log: CroOutOneC.jsp,v $
 * Revision 1.8  2014/01/24 07:11:58  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix
 *
 * Revision 1.7  2014/01/14 01:49:43  MISSALLY
 * R00135---PA0024---CASH年度專案
 * 非保費帳處理
 *
 * Revision 1.6  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%><%! String strThisProgId = "CroOutOne"; //本程式代號 %><%
String strMsg = (request.getAttribute("txtMsg") == null)?"":((String)request.getAttribute("txtMsg"));

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strBKCD = "";
String strATNO = "";
String strCURR = "";
String strRMDDT = "";
String strAEGDT = "";
String strAMOUNT = "";
CroOutOneConditionDTO coocDTO = (session.getAttribute("condition") == null)?null:(CroOutOneConditionDTO) session.getAttribute("condition");
if(coocDTO != null) {
	session.removeAttribute("condition");

	strBKCD = coocDTO.getBkCode();
	strATNO = coocDTO.getAccount();
	strCURR = coocDTO.getCurrency();
	strAMOUNT = String.valueOf(coocDTO.getRmtAmt());
	strRMDDT = String.valueOf(coocDTO.getRmtDate());
	strAEGDT = String.valueOf(coocDTO.getAegDate());

	strAMOUNT = strAMOUNT.equals("0")?"":strAMOUNT;
	strRMDDT = strRMDDT.equals("0")?"":strRMDDT.substring(0,3)+"/"+strRMDDT.substring(3,5)+"/"+strRMDDT.substring(5,7);
	strAEGDT = strAEGDT.equals("0")?"":strAEGDT.substring(0,3)+"/"+strAEGDT.substring(3,5)+"/"+strAEGDT.substring(5,7);
}

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") ==null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
Hashtable htTemp = null;
String strValue = null;
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"all\">全部</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equals(strCURR))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>單筆銷帳</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 			= "txtEBKCD";		//第一個可輸入之Key欄位名稱
var strFirstData 			= "dspEAEGDT";		//第一個可輸入之Data欄位名稱

// *************************************************************
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '');
	window.status = "";
	disableAll();
}

/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
93/06/2      Jerry      因為user要把銷帳銷錯的恢復成未銷帳, 所以取消全球入帳日不可空白的檢查
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";

	if( objThisItem.name == "dspEBKRMD" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "金融單位匯款日-日期格式有誤";
	        bReturnStatus = false;			
        }
	}
	if( objThisItem.name == "dspEAEGDT" )
	{
		if (objThisItem.value != "000/00/00") {
			bDate = true;
			bDate = isValidDate(objThisItem.value,'C');
			if (bDate == false) {
				strTmpMsg = "全球人壽入帳日-日期格式有誤";
				bReturnStatus = false;
			}
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

/* 當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行 */
function inquiryAction()
{
	enableAll();
	winToolBar.ShowButton( strFunctionKeyInquiry1 );
    document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus();
	}
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	var elements = document.forms("frmMain");
	for(var i=0; i<elements.length; i++) {
		field_type = elements[i].type.toLowerCase();
		switch(field_type) {
			case "text":
			case "password":
			case "textarea":
			case "hidden":
				elements[i].value = "";
				break;
			case "radio":
			case "checkbox":
				if (elements[i].checked) {
					elements[i].checked = false;
				}
				break;
			case "select-one":
			case "select-multi":
				elements[i].selectedIndex = -1;
				break;
			default:
				break;
		}
	}
	document.getElementById("txtAction").value = strSaveAction;
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
	document.frmMain.radType[0].checked = true;
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton('I');
	document.getElementById("txtAction").value = "";
	disableAll();
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

	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
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
		for(var i=0;i< document.getElementById("txtCURRENCY").options.length;i++)
		{
			if( returnArray[2]== document.getElementById("txtCURRENCY").options.item(i).value )
			{
				document.getElementById("txtCURRENCY").options.item(i).selected = true;
				break;
			}
		}
	}
}

function getRmd() {
	if(document.getElementById("dspEAEGDT").disabled){
		return ;
	}else{
		show_calendar('frmMain.dspEAEGDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
	}
}
	
function getRmd2(){
	if(document.getElementById("dspEBKRMD").disabled){
		return ;
	}else{
		show_calendar('frmMain.dspEBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
	}
}

/* 當toolbar frame 中之<確定>按鈕被點選時,本函數會被執行 */
function confirmAction()
{
	mapValue();

	var varMsg = "";
	if(document.getElementById("txtEBKCD").value == "") {
		varMsg += "金融單位代碼不可空白\n\r";
	}
	if(document.getElementById("dspEBKRMD").value == "" && document.getElementById("txtENTAMT").value == "") {
		varMsg += "金融單位匯款日與匯款金額不可同時空白\n\r";
	} else if(document.getElementById("dspEBKRMD").value != "" && !isValidDate(document.getElementById("dspEBKRMD").value,'C')) {
		varMsg += "金融單位匯款日-日期格式有誤\n\r";
	}
	if(document.getElementById("dspEAEGDT").value != "") {
		if(!isValidDate(document.getElementById("dspEAEGDT").value,'C')) {
			varMsg += "全球人壽入帳日-日期格式有誤\n\r";
		}
	}

	if(varMsg != "") {
		alert(varMsg);
		return false;
	} else {
		if(document.frmMain.radType[1].checked == true) {
			var varMsg = "請確認是否已經新增團體入帳資料，\n\r";
			varMsg += "若已新增，請選擇「一般銷帳處理」請勿重覆新增!!";
			if(confirm(varMsg)) {
				document.getElementById("frmMain").submit();
			}
		} else {
			document.getElementById("frmMain").submit();
		}
	}
}

function mapValue() 
{
	if(document.getElementById("dspEBKRMD").value != "") {
		document.getElementById("txtEBKRMD").value = rocDate2String(document.getElementById("dspEBKRMD").value);
	}
	if(document.getElementById("dspEAEGDT").value != "") {
		document.getElementById("txtEAEGDT").value = rocDate2String(document.getElementById("dspEAEGDT").value);
	}
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnLoad();">
<P><BR></P>
<form id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crooutone.CroOutOneServlet">
<TABLE border="0">
	<TBODY>
		<TR><TD colspan="4"><INPUT TYPE="radio" ID="radType" NAME="radType" VALUE="<%=CroOutOneConditionDTO.NORMAL%>" checked="checked" class="Key" />　一般銷帳處理</TD></TR>
		<TR><TD colspan="4"><INPUT TYPE="radio" ID="radType" NAME="radType" VALUE="<%=CroOutOneConditionDTO.SPECIAL_I%>" class="Key" />　新增I.團體批次入帳資料</TD></TR>
		<TR><TD colspan="4"><INPUT TYPE="radio" ID="radType" NAME="radType" VALUE="<%=CroOutOneConditionDTO.NONE_PREM_CASE%>" class="Key" />　非保費銷帳處理</TD></TR>
	</TBODY>
</TABLE>
<BR>
<TABLE border="0">
	<TBODY>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融單位代碼* :</TD>
			<TD>
				<INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="<%=strBKCD%>" class="Key">
				<INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode();" value="代碼查詢" class="Key">
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融單位帳號 :</TD>
			<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value="<%=strATNO%>" class="Key"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>幣別 :</TD>
			<TD>
				<select size="1" name="txtCURRENCY" id="txtCURRENCY" class="Key">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融單位匯款日* :</TD>
			<TD><INPUT type="text" id="dspEBKRMD" name="dspEBKRMD" size="8" maxlength="9" value="<%=strRMDDT%>" class="Key" onblur="checkClientField(this,true);"  ></TD>
			<TD><A href="javascript:show_calendar('frmMain.dspEBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getRmd2();" ></A></TD>
		</TR>
		<TR>
			<TD>匯款金額* :</TD>
			<TD><INPUT type="text" id="txtENTAMT" name="txtENTAMT" size="13" maxlength="13" value="<%=strAMOUNT%>" class="Key"></TD> 
			<TD></TD>
		</TR>
		<TR>
			<TD>全球人壽入帳日 :</TD>
			<TD><INPUT type="text" id="dspEAEGDT" name="dspEAEGDT" size="8" maxlength="9" value="<%=strAEGDT%>" class="Data" onblur="checkClientField(this,true);"></TD>
			<TD><A href="javascript:show_calendar('frmMain.dspEAEGDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getRmd();" ></A></TD>
		</TR>
		<TR><TD colspan="4"><BR></TD></TR>
		<TR><TD colspan="4"><BR></TD></TR>
		<TR><TD colspan="4">*為必輸欄位，金融單位匯款日與匯款金額二擇一</TD></TR>
	</TBODY>
</TABLE>              

<INPUT type="hidden" id="txtEBKRMD" name="txtEBKRMD" value="">
<INPUT type="hidden" id="txtEAEGDT" name="txtEAEGDT" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="I">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
</form>
</BODY>
</HTML>
