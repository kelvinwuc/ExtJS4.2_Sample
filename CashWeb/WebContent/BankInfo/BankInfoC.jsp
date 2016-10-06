<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.bankinfo.CapbnkfVO" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 金融單位資料維護
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.5 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * RD0382-OIU專案:20150909,Kelvin Wu,新增【帳戶所屬公司別】
 *
 * $Log: BankInfoC.jsp,v $
 * Revision 1.5  2015/11/09 09:01:31  001946
 * *** empty log message ***
 *
 * Revision 1.4  2014/02/26 06:39:32  MISSALLY
 * EB0537 --- 新增萬泰銀行為外幣指定銀行
 *
 * Revision 1.3  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%>
<%
Logger log = Logger.getLogger(getClass());
//log.info("金融單位資料維護");
 %>
<%! String strThisProgId = "BankInfoC"; //本程式代號 %><% 
String strMsg = (request.getAttribute("txtMsg") == null)?"":((String)request.getAttribute("txtMsg"));

CapbnkfVO vo = (request.getAttribute("bankVo") != null)?((CapbnkfVO) request.getAttribute("bankVo")):null;
String strBankCode = "";
String strBankAccount = "";
String strBankGlAct = "";
String strBankCurr = "";
String strBankName = "";
String strBankAlat = "";
String strBankCred = "";
String strBankPacb = "";
String strBankBatc = "";
String strBankGpCd = "";
String strBankSpec = "";
String strBankStatus = "";
String strBankMemo = "";
String strCompanyType =""; //RD0382

if(vo != null) {
	strBankCode = CommonUtil.AllTrim(vo.getBankCode());
	strBankAccount = CommonUtil.AllTrim(vo.getBankAccount());
	strBankGlAct = CommonUtil.AllTrim(vo.getBankGlAct());
	strBankCurr = CommonUtil.AllTrim(vo.getBankCurr());
	strBankName = CommonUtil.AllTrim(vo.getBankName());
	strBankAlat = CommonUtil.AllTrim(vo.getBankAlat());
	strBankCred = CommonUtil.AllTrim(vo.getBankCred());
	strBankPacb = CommonUtil.AllTrim(vo.getBankPacb());
	strBankBatc = CommonUtil.AllTrim(vo.getBankBatc());
	strBankGpCd = CommonUtil.AllTrim(vo.getBankGpCd());
	strBankSpec = CommonUtil.AllTrim(vo.getBankSpec());
	strBankStatus = CommonUtil.AllTrim(vo.getBankStatus());
	strBankMemo = CommonUtil.AllTrim(vo.getBankMemo());
	//strCompanyType = CommonUtil.AllTrim(vo.getCompanyType());
	strCompanyType = "";
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>金融單位資料維護</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">
<!--
var strFirstKey 	 = "txtBkCode";			//第一個可輸入之Key欄位名稱
var strFirstData 	 = "txtBkName";			//第一個可輸入之Data欄位名稱

/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
	disableAll();
}

/* 檢核傳入之欄位是否正確 */
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtBkCode" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "金融單位代碼不可空白";
				bReturnStatus = false;
			}
			else
			{
				re = /^[0-9]{3}$/;
				if (!re.test(objThisItem.value))
				{
					strTmpMsg = "金融單位代碼不符合 999 的格式";
					bReturnStatus = false;
				}
			}
		}
	}
	else if( objThisItem.name == "txtBkName" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "金融單位名稱不可空白";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.name == "txtBkAtNo" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "金融單位帳號不可空白";
				bReturnStatus = false;
			}
			else
			{
				re = /^\d{1,17}$/;
				if (!re.test(objThisItem.value))
				{
					strTmpMsg = "金融單位帳號不為數字";
					bReturnStatus = false;
				}
			}
		}
	}
	else if( objThisItem.name == "txtGlAct" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "會計科目不可空白";
				bReturnStatus = false;
			}
			else
			{
				re = /^[A-Z0-9]{6}-[A-Z0-9]{6}$/;
				if (!re.test(objThisItem.value))
				{
					strTmpMsg = "會計科目不符合 999999-999999 的格式";
					bReturnStatus = false;
				}
			}
		}
	}
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
	
}

/* 當toolbar frame 中之<新增>按鈕被點選時,本函數會被執行 */
function addAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
	document.getElementById("txtAction").value = "A";

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
	disableKey();
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
	enableQueryFields("txtBkCode,txtBkName,txtBkAtNo,txtGlAct");
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
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	WindowOnLoad();
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
		var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR,GLACT,BKALAT,BKCRED,BKPACB,BKBATC,BKGPCD,CASE BKSPEC WHEN 'Y' THEN BKSPEC ELSE 'N' END as BKSPEC,CASE BKSTAT WHEN 'Y' THEN '啟用' ELSE '停用' END as STATDESC,CASE BKSTAT WHEN 'Y' THEN BKSTAT ELSE 'N' END as BKSTAT,BKMEMO,CASE COMPANY WHEN 'OIU' THEN COMPANY ELSE '總公司' END as COMPANY from CAPBNKF where 1 = 1 ";//RD0382
		if( document.getElementById("txtBkCode").value != "" )
			strSql += " and BKCODE = '"+document.getElementById("txtBkCode").value +"' ";

		if( document.getElementById("txtBkName").value != "" )
			strSql += " and BKNAME = '"+document.getElementById("txtBkName").value +"' ";

		if( document.getElementById("txtBkAtNo").value != "" )
			strSql += " and BKATNO = '"+document.getElementById("txtBkAtNo").value +"' ";

		if( document.getElementById("txtGlAct").value != "" )
			strSql += " and GLACT = '"+document.getElementById("txtGlAct").value +"' ";

		var strQueryString = "?Time="+new Date()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=650";

	<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","金融單位代號,金融單位名稱,金融單位帳號,幣別,會計科目,金融簡碼,信用卡銀行碼,銀行轉帳請款碼,批次入帳銀行碼,GTMS現金類別,狀態,帳戶所屬公司別");//RD0382
	session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR,GLACT,BKALAT,BKCRED,BKPACB,BKBATC,BKGPCD,STATDESC,COMPANY");//RD0382
	session.setAttribute("ReturnFields", "BKCODE,BKNAME,BKATNO,BKCURR,GLACT,BKALAT,BKCRED,BKPACB,BKBATC,BKGPCD,BKSPEC,BKSTAT,BKMEMO,COMPANY");//RD0382
	%>

		var strReturnValue = window.showModalDialog( "../CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		
		if( strReturnValue != "" )
		{
			disableAll();
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtBkCode").value = returnArray[0];
			document.getElementById("txtBkName").value = returnArray[1];
			document.getElementById("txtBkAtNo").value = returnArray[2];
			document.getElementById("txtBkCurr").value = returnArray[3];
			document.getElementById("txtGlAct").value = returnArray[4];
			document.getElementById("txtBkAlat").value = returnArray[5];
			document.getElementById("txtBkCred").value = returnArray[6];
			document.getElementById("txtBkPacb").value = returnArray[7];
			document.getElementById("txtBkBatc").value = returnArray[8];
			document.getElementById("txtBkGpCd").value = returnArray[9];
			//document.getElementById("txtCompanyType").value = returnArray[13];//RD0382

			var varTmp = returnArray[10];
			var objSelect = document.getElementById("txtBkSpEc");
			for (var i = 0; i < objSelect.options.length; i++) {
				if (objSelect.options[i].value == varTmp) {
					objSelect.options[i].selected = true;
					break;
				}
			}

			varTmp = returnArray[11];
			objSelect = document.getElementById("txtBkStAt");
			for (var i = 0; i < objSelect.options.length; i++) {
				if (objSelect.options[i].value == varTmp) {
					objSelect.options[i].selected = true;
					break;
				}
			}
			
			//RD0382:新增OIU
			varTmp = returnArray[13];
			objSelect = document.getElementById("txtCompanyType");
			for (var i = 0; i < objSelect.options.length; i++) {
				if (objSelect.options[i].value == varTmp) {
					objSelect.options[i].selected = true;
					break;
				}
			}

			document.getElementById("txtBkMeMo").value = returnArray[12];

			document.getElementById("txtAction").value = "I";
			winToolBar.ShowButton( strFunctionKeyInquiry );
			window.status = "目前為查詢狀態,若要修改或刪除資料,請先選擇修改或刪除功能鍵";
		}
	}
}

/* 當toolbar frame 中之<儲存>按鈕被點選時,本函數會被執行 */
function saveAction()
{
	enableAll();
	if( areAllFieldsOK() )
	{
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnLoad();">
<P><B>金融單位資料維護</B></P>
<P><BR></P>
<form id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.bankinfo.BankInfoServlet" >
<TABLE border="0">
	<TBODY>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融單位代碼　 *:</TD>
			<TD><INPUT type="text" id="txtBkCode" name="txtBkCode" size="4" maxlength="4" value="<%=strBankCode%>" class="Key"></TD>
			<TD>( 請輸入金資中心代碼 )</TD>
		</TR>
		<TR>
			<TD>金融單位名稱　 *:</TD>
			<TD><INPUT type="text" id="txtBkName" name="txtBkName" size="30" maxlength="30" value="<%=strBankName%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>帳戶所屬公司別　 *:</TD>
			<TD>
				<select id="txtCompanyType" name="txtCompanyType" class="Data">
					<option value="" <%=strCompanyType.equals("")?" selected":""%>>總公司</option>
					<option value="OIU" <%=strCompanyType.equals("OIU")?" selected":""%>>OIU</option>
				</select>
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融單位帳號　 *:</TD>
			<TD><INPUT type="text" id="txtBkAtNo" name="txtBkAtNo" size="17" maxlength="17" value="<%=strBankAccount%>" class="Key"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>幣別　 *:</TD>
			<TD><INPUT type="text" id="txtBkCurr" name="txtBkCurr" size="5" maxlength="2" value="<%=strBankCurr.equals("")?"NT":strBankCurr%>" class="Key" ></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>會計科目　　　 *:</TD>
			<TD><INPUT type="text" id="txtGlAct" name="txtGlAct" size="15" maxlength="15" value="<%=strBankGlAct%>" class="Key"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>金融簡碼　　　   :</TD>
			<TD><INPUT type="text" id="txtBkAlat" name="txtBkAlat" size="4" maxlength="4" value="<%=strBankAlat%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>信用卡銀行碼　   :</TD>
			<TD><INPUT type="text" id="txtBkCred" name="txtBkCred" size="4" maxlength="4" value="<%=strBankCred%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>銀行轉帳請款碼   :</TD>
			<TD><INPUT type="text" id="txtBkPacb" name="txtBkPacb" size="4" maxlength="4" value="<%=strBankPacb%>" class="Data"></TD>
			<TD>( 新增資料需與保費行政確認 -銀行轉帳 )</TD>
		</TR>
		<TR>
			<TD>批次入帳銀行碼   :</TD>
			<TD><INPUT type="text" id="txtBkBatc" name="txtBkBatc" size="17" maxlength="17" value="<%=strBankBatc%>" class="Data"></TD>
			<TD>( 新增資料需與保費行政確認 -虛擬帳號 )</TD>
		</TR>
		<TR>
			<TD>GTMS現金類別   :</TD>
			<TD><INPUT type="text" id="txtBkGpCd" name="txtBkGpCd" size="2" maxlength="1" value="<%=strBankGpCd%>" class="Data"></TD>
			<TD>( 如該帳號亦為GTMS使用者,需輸入其現金類別 )</TD>
		</TR>
		<TR>
			<TD>整批登帳格式    *:</TD>
			<TD>
				<select id="txtBkSpEc" name="txtBkSpEc" class="Data">
					<option value="N" <%=strBankSpec.equals("N")?" selected":""%>>通用格式</option>
					<option value="Y" <%=strBankSpec.equals("Y")?" selected":""%>>銀行格式</option>
				</select>
			</TD>
			<TD></TD>
		</TR>
		<TR>  
			<TD>帳號狀態          *:</TD>
			<TD>
				<select id="txtBkStAt" name="txtBkStAt" class="Data">
					<option value="N" <%=strBankStatus.equals("N")?" selected":""%>>停用</option>
					<option value="Y" <%=strBankStatus.equals("Y")?" selected":""%>>啟用</option>
				</select>
			</TD>
	        <TD></TD>	
		</TR>
		<TR>
		    <TD>備註   :</TD>
			<TD><INPUT type="text" id="txtBkMeMo" name="txtBkMeMo" size="30" maxlength="100" value="<%=strBankMemo%>" class="Data"></TD>
            <TD></TD>		 
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">

</form>
<P><BR>* 為必須輸入項目</P>
<P><BR></P>
</BODY>
</HTML>
