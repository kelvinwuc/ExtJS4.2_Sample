<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : 退匯作業維護
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.6 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date: ${date}
 * 
 * Request ID : R90884
 * 
 * CVS History:
 * 
 * $$Log: DISBRemitFailedMaintain.jsp,v $
 * $Revision 1.6  2013/12/24 03:55:46  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.2.4.1  2012/12/06 06:28:26  MISSALLY
 * $RA0102　PA0041
 * $配合法令修改酬佣支付作業
 * $
 * $Revision 1.2  2012/05/18 09:49:51  MISSALLY
 * $R10314 CASH系統會計作業修改
 * $
 * $Revision 1.1  2011/06/02 10:28:07  MISSALLY
 * $Q90585 / R90884 / R90989
 * $CASH系統匯退處理作業新增匯退原因欄位並修正退匯明細表
 * $$
 *  
 */
%><%!
String strThisProgId = "DISBRemitFMaintain"; //本程式代號
DecimalFormat df = new DecimalFormat("#.00");
DecimalFormat df2 = new DecimalFormat("#.0000");
%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();
String today = commonUtil.convertWesten2ROCDate(calendar.getTime());
int iToday = Integer.parseInt(commonUtil.convertWesten2ROCDate1(calendar.getTime()));

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

//幣別
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
}
StringBuffer sbCurrCash = new StringBuffer();
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equalsIgnoreCase("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
} else {
	sbCurrCash.append("<option value=\"\">&nbsp;</option>");
}

//付款帳號
List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") == null) {
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList", alPBBank);
} else {
	alPBBank = (List) session.getAttribute("PBBankList");
}
StringBuffer sbPBBank = new StringBuffer();
if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		htTemp = (Hashtable) alPBBank.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbPBBank.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
} else {
	sbPBBank.append("<option value=\"\">&nbsp;</option>");
}

List alPBBankD = new ArrayList();
if (session.getAttribute("PBBankListD") == null) {
	alPBBankD = (List) disbBean.getETable("PBKAT", "BANKD");
	session.setAttribute("PBBankListD", alPBBankD);
} else {
	alPBBankD = (List) session.getAttribute("PBBankListD");
}
StringBuffer sbPBBankD = new StringBuffer();
if (alPBBankD.size() > 0) {
	for (int i = 0; i < alPBBankD.size(); i++) {
		htTemp = (Hashtable) alPBBankD.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		if(strValue.equalsIgnoreCase("8220635/635131008304"))	//8220635/635131008304-中信銀復興
			sbPBBankD.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbPBBankD.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
} else {
	sbPBBankD.append("<option value=\"\">&nbsp;</option>");
}

List alPBBankP = new ArrayList();
if (session.getAttribute("PBBankListP") == null) {
	alPBBankP = (List) disbBean.getETable("PBKAT", "BANKP");
	session.setAttribute("PBBankListP", alPBBankP);
} else {
	alPBBankP = (List) session.getAttribute("PBBankListP");
}
StringBuffer sbPBBankP = new StringBuffer();
if (alPBBankP.size() > 0) {
	for (int i = 0; i < alPBBankP.size(); i++) {
		htTemp = (Hashtable) alPBBankP.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		if(strValue.equalsIgnoreCase("8220635/635530015707"))	//8220635/635530015707-中信銀復興
			sbPBBankP.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbPBBankP.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
} else {
	sbPBBankD.append("<option value=\"\">&nbsp;</option>");
}

//退匯代碼
List alRemitFail = new ArrayList();
if(session.getAttribute("RemitFailList") == null) {
	alRemitFail = (List) disbBean.getETable("CASH1");
	session.setAttribute("RemitFailList", alRemitFail);
} else {
	alRemitFail = (List) session.getAttribute("RemitFailList");
}
StringBuffer sbRemitFail = new StringBuffer();
StringBuffer sbRFScriptArray = new StringBuffer();
sbRemitFail.append("<option value=\"\">&nbsp;</option>");
if (alRemitFail.size() > 0) {
	for (int i = 0; i < alRemitFail.size(); i++) {
		htTemp = (Hashtable) alRemitFail.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbRemitFail.append("<option value=\"").append(strValue).append("\">").append(strValue).append(" - ").append(strDesc).append("</option>");
		sbRFScriptArray.append(",[").append("\"").append(strValue).append("\"").append(",\"").append(strDesc).append("\"").append("]");
	}

	htTemp = null;
	strValue = null;
}

String strAction = "";
String strReturnMessage = "";
String strRemitFailDate = "";
int iBankRemitBackDate = 0;

if (request.getAttribute("txtAction") != null) 
	strAction = (String) request.getAttribute("txtAction");
if (request.getAttribute("txtMsg") != null) 
	strReturnMessage = (String) request.getAttribute("txtMsg");
if (request.getAttribute("txtRemitFailDate") != null) 
	strRemitFailDate = (String) request.getAttribute("txtRemitFailDate");
//R10314
String strBRDate = "";
if (request.getAttribute("txtBRemitFailDate") != null) 
	strBRDate = (String) request.getAttribute("txtBRemitFailDate");

List alPDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
double iSumAmt = 0; //總金額
DISBPaymentDetailVO objPDetailCounter = null;
if (session.getAttribute("PDetailList") != null) {
	alPDetail = (List) session.getAttribute("PDetailList");

	if (alPDetail != null) {
		if (alPDetail.size() > 0) {
			for (int k = 0; k < alPDetail.size(); k++) {
				objPDetailCounter = (DISBPaymentDetailVO) alPDetail.get(k);
				iSumAmt = iSumAmt + objPDetailCounter.getIPAMT();

				iBankRemitBackDate = objPDetailCounter.getBankRemitFailDate();
			}
			itotalCount = alPDetail.size();
			objPDetailCounter = null;
		}
		if (itotalCount % iPageSize == 0) {
			itotalpage = itotalCount / iPageSize;
		} else {
			itotalpage = itotalCount / iPageSize + 1;
		}
	}
}
session.removeAttribute("PDetailList");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>支付功能--退匯維護作業</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="javascript">
<!--
var iTotalrec =<%=itotalCount%>;
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitFailedMaintain.jsp";
	}

	if(document.getElementById("txtAction").value == "I")
	{
		WindowOnLoadCommon( "支付功能--退匯維護作業-查詢", "", strDISBFunctionKeyExit, "" );	//離開
		document.getElementById("inquiryArea").style.display = "none";
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaC").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";
		document.getElementById("inquiryAreaE").style.display ="none";
	}
	else if(document.getElementById("txtAction").value == "U")
	{
		WindowOnLoadCommon( "支付功能--退匯維護作業-修改", "", strFunctionKeyInquiry1, "" );	//確定,清除,離開
		document.getElementById("inquiryArea").style.display = "none";
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaC").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";
		document.getElementById("inquiryAreaE").style.display ="block";

		document.getElementById("txtRFDateC").value = "<%=strRemitFailDate%>";
		//R10314
		document.getElementById("txtBRFDateC").value = "<%=commonUtil.convertROCDate(strBRDate)%>";
	}
	else
	{
		WindowOnLoadCommon( document.title, "", strRemitFailMaintainFunctionKey, "" );
		document.getElementById("inquiryArea").style.display = "block";
		document.getElementById("inquiryAreaA").style.display ="block";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaC").style.display ="block";
		document.getElementById("inquiryAreaD").style.display ="none";
		document.getElementById("inquiryAreaE").style.display ="none";

		//R90884
		document.getElementById("txtRDateC").value = "<%=today%>";
		document.getElementById("txtRFDateC").value = "<%=today%>";
		//R10314
		document.getElementById("txtBRFDateC").value = "<%=commonUtil.convertROCDate(strBRDate)%>";
	}

	window.status = "";
}

/*
函數名稱:	resetAction()
函數功能:	當 toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*
函數名稱:	exitAction()
函數功能:	當 toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitFailedMaintain.jsp";
}

/*
函數名稱:	updateAction()
函數功能:	當 toolbar frame 中之修改按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function updateAction()
{
	mapValue();

	document.getElementById("txtAction").value = "U";

	//付款日期/金額/受款人姓名 三個欄位必輸入二個以上
	if( areAllFieldsOK() )
	{
		var varMsg = "" ;
		var varRBDate = document.getElementById("txtBRDateC").value;
		if(varRBDate == "") {
			varMsg = "請輸入銀行退匯回存日期！";
		} else if(varRBDate.replace(/\//g,"") > <%=iToday%>) {
			varMsg = "銀行退匯回存日期不得晚於CAPSIL開機日期！";
		}
		if(varMsg != "") {
			alert(varMsg);
		} else {
			//退匯日期必須 <= 系統日
			if(document.getElementById("txtRDate").value <= <%=iToday%>)
			{
				//若User選擇其他日期，需產生訊息
				if(document.getElementById("txtRDateC").value != "<%=today%>") 
				{
					var bConfirm = window.confirm("修改的資料非當日退匯的資料，請確認是否修改!?" );
					if(bConfirm) 
					{
						document.getElementById("frmMain").submit();
					}
				}
				else
				{
					document.getElementById("frmMain").submit();
				}
			}
			else
			{
				alert("退匯日期必須小於等於系統日(<%=iToday%>)");
			}
    	}
	}
}

function mapValue() 
{
	document.getElementById("txtPDate").value = rocDate2String(document.getElementById("txtPDateC").value);

    var BankAccount = document.getElementById("selPBBank").value ;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);
	}  

	var BankAccountD = document.getElementById("selPBBankD").value ;
	if(BankAccountD !="")
	{
		var iindexof = BankAccountD.indexOf('/');
		document.getElementById("txtPBBankD").value = BankAccountD.substring(0,iindexof);
		document.getElementById("txtPBAccountD").value = BankAccountD.substring(iindexof+1);	
	}  

	var BankAccountP = document.getElementById("selPBBankP").value ;
	if(BankAccountP !="")
	{
		var iindexof = BankAccountP.indexOf('/');
		document.getElementById("txtPBBankP").value = BankAccountP.substring(0,iindexof);
		document.getElementById("txtPBAccountP").value = BankAccountP.substring(iindexof+1);	
	}  

	document.getElementById("txtRDate").value = rocDate2String(document.getElementById("txtRDateC").value);

	document.getElementById("txtRFDateC").value = document.getElementById("txtRDateC").value;
	//R10314
	document.getElementById("txtBRDate").value = rocDate2String(document.getElementById("txtBRDateC").value);
	document.getElementById("txtBRFDate").value = rocDate2String(document.getElementById("txtBRFDateC").value);
}

function areAllFieldsOK()
{
	var intCNT = 0;
	if (document.getElementById("txtPDate").value != "")
		intCNT = intCNT + 1;
	if (document.getElementById("txtAMT").value != "" )
		intCNT = intCNT + 1;
	if (document.getElementById("txtNAME").value != "")
		intCNT = intCNT + 1;

	if (intCNT > 1) {
		return true;
	} else {
		alert("付款日/金額/受款人姓名必輸入二個以上查詢條件");
		return false;
	}
}

//退匯方式
function showDArea()
{
	if(document.getElementById("selFEESHOW").value == "US") 
	{
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="block";
		document.getElementById("inquiryAreaD").style.display ="none";
	}
	else if(document.getElementById("selFEESHOW").value =="NT") 
	{
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="block";
	}
	else if(document.getElementById("selFEESHOW").value =="C")
	{
		document.getElementById("inquiryAreaA").style.display ="block";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";
	}
	else
	{
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";
	}
}

//若選擇退匯代碼自動帶出退匯原因
function changeRFDesc()
{
	var RemitFailArray = [<% if(sbRFScriptArray.toString().length() > 0) { out.print(sbRFScriptArray.toString().substring(1)); } %>];

	document.getElementById("txtRFDesc").readOnly = true;
	for(var i=0; i<RemitFailArray.length; i++)
	{
		if( RemitFailArray[i][0] == document.getElementById("selRFCode").value ) {
			document.getElementById("txtRFDesc").value = RemitFailArray[i][1];
			if( RemitFailArray[i][0] == "99" ) {
				document.getElementById("txtRFDesc").readOnly = false;
			}
			break;
		}
	}
}

/*
函數名稱:	confirmAction()
函數功能:	當toolbar frame 中之確定按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function confirmAction()
{
	var varMsg = "";
	var varRBDate = document.getElementById("txtBRFDateC").value;
	if(varRBDate == "") {
		alert("請輸入銀行退匯回存日期！");
		return false;
	} else if(varRBDate.replace(/\//g,"") > <%=iToday%>) {
		alert("銀行退匯回存日期不得晚於該筆保單執行退匯日期！");
		return false;
	}
	if(<%=alRemitFail.size()%> <= 0)
	{
		varMsg = "ETAB-CASH1退匯失敗代碼不存在，煩請確認後再執行!!";
	}
	if(document.getElementById("selRFCode").value == "") 
	{
		varMsg += "請選擇退匯代碼!!\n\r";
	}
	//退匯原因檢核 代碼=99, User必須輸入退匯原因
	if(document.getElementById("selRFCode").value == "99" && document.getElementById("txtRFDesc").value == "") 
	{
		varMsg += "退匯代碼99，請輸入退匯原因!!\n\r";
	}

	var flag = 0;
	var varConfirmMsg = "";
	for (var i=0; i<iTotalrec; i++ ) {
		if(document.getElementById("ch" + i ).checked) {
			flag++;

			//R90884 檢核是否有重複的
			if(document.getElementById("txtCode"+i).value == document.getElementById("selRFCode").value 
				|| document.getElementById("txtDesc"+i).value == document.getElementById("txtRFDesc").value) 
			{
				varConfirmMsg += "序號=" + (i+1) + "\n\r";
			}
       	}
	}
 	if(flag == 0) {
    	varMsg += "至少要勾選一筆項目!!";
    }

	if(varMsg != "") {
		alert(varMsg);
		return false;
	} else {
		mapValue();//R10314
		var varRBDate = document.getElementById("txtBRFDate").value;
		if(varRBDate != <%=iBankRemitBackDate%>) {
			var varConfirm = window.confirm("更新銀行退匯回存日期前，請先下載反轉退匯分錄，再更新銀行退匯回存日期。請確定是否要執行更新?" );
			if(varConfirm) {
				var varFlag = true;
				if(varConfirmMsg != "")
				{
					var bConfirm = window.confirm( varConfirmMsg + "上列資訊退匯代碼/原因未異動，請確認是否修改!?" );
					if(!bConfirm) 
					{
						varFlag = false;
					}
				}
		
				if(varFlag)
				{
					enableAll();
					document.getElementById("txtAction").value = "DISBRemitFailedModify";
					//mapValue(); R10314
					document.getElementById("frmMain").submit();
				}
			} else {
				return false;
			}
		}
	}
}

/*
函數名稱:	inquiryAction()
函數功能:	當 toolbar frame 中之查詢按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function inquiryAction() 
{
	var varMsg = "";

	var intCNT = 0;
	if (document.getElementById("txtPDate").value != "")
		intCNT = intCNT + 1;
	if (document.getElementById("txtAMT").value != "" )
		intCNT = intCNT + 1;
	if (document.getElementById("txtNAME").value != "")
		intCNT = intCNT + 1;
	if (document.getElementById("txtRDateC").value != "")
		intCNT = intCNT + 1;

	if (intCNT < 0) {
		varMsg = "付款日/金額/受款人姓名/退匯日期必輸入一個以上查詢條件!!\n\r";
	}

	if(document.getElementById("selCurrency").value == "") {
		varMsg += "幣別為必輸入欄位!!\n\r";
	}
	if(document.getElementById("selFEESHOW").value == "") {
		varMsg += "退匯方式為必輸入欄位!!\n\r";
	}

	var varRBDate = document.getElementById("txtBRFDateC").value;
	if(varRBDate == "") {
		varMsg = "請輸入銀行退匯回存日期！";
	} else if(varRBDate > <%=iToday%>) {
		varMsg = "銀行退匯回存日期不得晚於CAPSIL開機日期！";
	}

	if(varMsg != "") {
		alert(varMsg);
		return false;
	} else {
		enableAll();
		document.getElementById("txtAction").value = "DISBRemitFailedInquiry";
		mapValue();
		document.getElementById("frmMain").submit();
	}
}

/*
函數名稱:	printRAction()
函數功能:	當 toolbar frame 中之報表按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function printRAction() 
{
	mapValue();
	window.status = "";
	if (document.getElementById("txtRDate").value == "")
	{
		alert ("請輸入退匯日期");
		return false;
	}
	else
	{
		var strSql = "";
		strSql  = "SELECT A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,A.POLICY_NO,A.APPNO,";
		strSql += " A.ENTRY_USER,B.DEPT AS USERDEPT,A.PDESC,A.PAY_SRC_NAME,C.BKNM,A.PAY_REMIT_ACCOUNT,";
		strSql += " A.PAY_CREDIT_CARD,A.PAY_NO_HISTORY,A.PAY_CURRENCY,A.ENTRY_DATE,A.PAY_PAYCURR,A.PAY_PAYAMT,";
		strSql += " A.PAY_PAYRATE,A.PAY_FEEWAY,A.REMIT_FEE,D.FPAYAMT,D.FFEEWAY,A.REMITFAILD,A.REMITFCODE,";
		strSql += " A.REMITFDESC ";
		strSql += " FROM CAPPAYF A ";
		strSql += " left outer join USER B on A.ENTRY_USER =B.USRID ";
		strSql += " left outer join CAPCCBF C on A.PRBANK=C.BKNO ";
		strSql += " left outer join CAPRFEF d on A.PNO=D.FPNOH ";
		strSql += " left outer join (SELECT FPNOH,MAX(ENTRYDT) as ENTRYDT FROM CAPRFEF GROUP BY FPNOH) e on e.FPNOH=d.FPNOH and d.ENTRYDT=e.ENTRYDT ";
	    strSql += " WHERE A.PAY_METHOD IN ('B','C','D') AND A.PAY_STATUS = 'A' AND A.PAY_REMITFAIL_DATE <> 0 ";
	    strSql += " AND A.PAY_NO_HISTORY = '' AND (A.UPDATE_DATE<>A.PAY_REMITFAIL_DATE OR A.UPDATE_TIME<>A.PAY_REMITFAIL_TIME) ";

	    if(document.getElementById("txtPDate").value != "")
	    	strSql += " AND A.PAY_DATE = " + document.getElementById("txtPDate").value;

	    if(document.getElementById("selCurrency").value !="")
	    	strSql += " AND A.PAY_CURRENCY = '" + document.getElementById("selCurrency").value + "' ";

		if(document.getElementById("txtAMT").value != "")
			strSql += " AND A.PAY_AMOUNT = " + document.getElementById("txtAMT").value;

		if(document.getElementById("txtNAME").value != "")
			strSql += " AND A.PNAME = '" + document.getElementById("txtNAME").value + "' ";

		if(document.getElementById("selFEESHOW").value != "")
		{
			if(document.getElementById("selFEESHOW").value == "NT")
				strSql += " AND A.PAY_METHOD = 'B' ";
			else if(document.getElementById("selFEESHOW").value == "US")
				strSql += " AND A.PAY_METHOD = 'D' ";
			else
				strSql += " AND A.PAY_METHOD = 'C' ";
		}

		if(document.getElementById("txtRDate").value != "")
			strSql += " AND A.PAY_REMITFAIL_DATE = " + document.getElementById("txtRDate").value;

		strSql += " ORDER BY A.ENTRY_USER, A.PAY_METHOD";

		document.frmMain1.ReportSQL.value = strSql;
		document.frmMain1.para_PConDate.value = document.getElementById("txtRDate").value;

		document.getElementById("frmMain1").target="_blank";
		document.getElementById("frmMain1").submit();
		return true;
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitFailedServlet">
	<TABLE border="1" width="400" id=inquiryArea>
		<TBODY>
			<TR>
				<TD align="right" class="TableHeading" width="130">付款日：</TD>
				<TD>
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateC" name="txtPDateC" value="" readOnly onblur="checkClientField(this,true);">
					<a href="javascript:show_calendar('frmMain.txtPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
						<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
					</a>
					<INPUT type="hidden" name="txtPDate" id="txtPDate" value="">
				</TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">保單幣別：</TD>
				<TD valign="middle">
					<select size="1" name="selCurrency" id="selCurrency">
						<%=sbCurrCash.toString()%>
					</select>
				</TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">金額：</TD>
				<TD ><INPUT class="Data" size="11" type="text" maxlength="11" id="txtAMT" name="txtAMT" VALUE=""></TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">受款人姓名：</TD>
				<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtNAME" name="txtNAME" VALUE=""></TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">退匯方式：</TD>
				<TD>
					<select size="1" id="selFEESHOW" name="selFEESHOW" onchange="showDArea();">
						<option value=""></option>
						<option value="NT">台幣退匯</option>
						<option value="US">外幣退匯</option>
						<option value="C">信用卡退回</option>
					</select>
				</TD>
			</TR>
		</TBODY>
	</TABLE>
	<TABLE border="1" width="400" id="inquiryAreaA" style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="130">付款帳號：</TD>
			<TD>
				<select size="1" name="selPBBank" id="selPBBank">
					<%=sbPBBank.toString()%>
				</select>
				<INPUT type="hidden" id="txtPBBank" name="txtPBBank" value=""> 
				<INPUT type="hidden" id="txtPBAccount" name="txtPBAccount" value="">
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="400" id="inquiryAreaC">
		<TR>
			<TD align="right" class="TableHeading" width="130">銀行退匯回存日期：</TD>
			<TD>
				<INPUT type="text" class="Data" id="txtBRDateC" name="txtBRDateC" size="11" maxlength="11" value="" readOnly>
				<a href="javascript:show_calendar('frmMain.txtBRDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a>
				<INPUT type="hidden" id="txtBRDate" name="txtBRDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="130">執行退匯日期：</TD>
			<TD>
				<INPUT type="text" class="Data" id="txtRDateC" name="txtRDateC" size="11" maxlength="11" value="" readOnly onblur="checkClientField(this,true);">
				<a href="javascript:show_calendar('frmMain.txtRDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a>
				<INPUT type="hidden" id="txtRDate" name="txtRDate" value="">
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="400" id=inquiryAreaB style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="130">付款帳號：</TD>
			<TD>
				<select size="1" name="selPBBankD" id="selPBBankD">
					<%=sbPBBankD.toString()%>
				</select> 
				<INPUT type="hidden" name="txtPBBankD" id="txtPBBankD" value=""> 
				<INPUT type="hidden" name="txtPBAccountD" id="txtPBAccountD" value="">
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="400" id=inquiryAreaD style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="130">付款帳號：</TD>
			<TD>
				<select size="1" name="selPBBankP" id="selPBBankP">
					<%=sbPBBankP.toString()%>
				</select> 
				<INPUT type="hidden" id="txtPBBankP" name="txtPBBankP" value=""> 
				<INPUT type="hidden" id="txtPBAccountP" name="txtPBAccountP" value="">
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="650" id="inquiryAreaE" style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="104">銀行退匯回存日期：</TD>
			<TD colspan="5">
				<INPUT type="text" class="Data" id="txtBRFDateC" name="txtBRFDateC" size="11" maxlength="11" value="" readOnly> 
				<a href="javascript:show_calendar('frmMain.txtBRFDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				<INPUT type="hidden" id="txtBRFDate" name="txtBRFDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="104">執行退匯日期：</TD>
			<TD>
				<INPUT type="text" class="Data" id="txtRFDateC" name="txtRFDateC" size="11" maxlength="11" value="" readOnly onBlur="checkClientField(this,true);">
				<INPUT type="hidden" id="txtRFDate" name="txtRFDate" value="">
			</TD>
			<TD align="right" class="TableHeading" width="100">退匯代碼：</TD>
			<TD>
				<SELECT id="selRFCode" name="selRFCode" onChange="changeRFDesc(this);">
					<%=sbRemitFail.toString()%>
				</SELECT>
			</TD>
			<TD align="right" class="TableHeading" width="100">退匯原因：</TD>
			<TD><INPUT type="text" id="txtRFDesc" name="txtRFDesc" value="" readonly="readonly"></TD>
		</TR>
	</TABLE>
	<BR>
<%
String isDisablecheck = (strAction.equalsIgnoreCase("I"))?"none":"";

if (alPDetail != null) 
{	// if alPDetail != null
	if (alPDetail.size() > 0) 
	{ //if alPDetail.size() > 0
		int icurrentRec = 0;
		int icurrentPage = 0; // 由0開始計
		int iSeqNo = 0;

		for (int i = 0; i < itotalpage; i++) 
		{
			icurrentPage = i;
			for (int j = 0; j < iPageSize; j++) 
			{
				iSeqNo++;
				icurrentRec = icurrentPage * iPageSize + j;
				if (icurrentRec < alPDetail.size()) 
				{
					if (j == 0) // show table head
					{
						if ((icurrentPage + 1) == 1) { %>
	<div id="showPage<%=icurrentPage + 1%>" >
<%						} else { %>
	<div id="showPage<%=icurrentPage + 1%>" style="display: none">
<%						} %>
		<table>
			<tr>
				<td><a href='javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage + 1%>,1)'>&lt;&lt;&nbsp;&nbsp;</a></td>
				<td><a href='javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage + 1%>,2)'>&lt;&nbsp;&nbsp;</a></td>
				<td><a href='javascript:ChangePage(<%=icurrentPage + 2%>,<%=itotalpage%>,<%=icurrentPage + 1%>,3)'>&gt;&nbsp;&nbsp;</a></td>
				<td><a href='javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage + 1%>,4)'>&gt;&gt;&nbsp;&nbsp;</a></td>
			</tr>
		</table>
		<hr>
		<table border="0" cellPadding="0" cellSpacing="0" width="100%" id="tblDetail">
			<tbody>
				<TR>
					<TD bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="25"><b><font size="2" face="細明體">序號</font></b></TD>
					<TD bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; display: <%=isDisablecheck%>"
						height="56" width="25"><b><font size="2" face="細明體">勾選</font></b></TD>
					<TD bgcolor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="157"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
					<TD bgcolor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="65"><b><font size="2" face="細明體">受款人ID</font></b></TD>
					<TD style="" bgcolor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="65"><b><font size="2" face="細明體">匯款銀行</font></b></TD>
					<TD style="" bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="139"><font size="2" face="細明體"><b>匯款帳號</b></font></TD>
					<TD bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="61"><b><font size="2" face="細明體">付款日期</font></b></TD>
					<TD bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="142"><b><font size="2" face="細明體">付款金額</font></b></TD>
					<TD bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="56"><font size="2" face="細明體"><b>手續費</b></font></TD>
					<TD bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="56"><font size="2" face="細明體"><b>匯款序號</b></font></TD>
					<TD style="" bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="56"><font size="2" face="細明體"><b>保單號碼</b></font></TD>
					<TD style="" bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="90"><font size="2" face="細明體"><b>合併匯款金額</b></font></TD>
					<TD style="" bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="45"><font size="2" face="細明體"><b>退匯日期</b></font></TD>
					<TD style="" bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="45"><font size="2" face="細明體"><b>退匯代碼</b></font></TD>
					<TD style="" bgColor="#c0c0c0"
						style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="56" width="45"><font size="2" face="細明體"><b>退匯原因</b></font></TD>
				</TR>
<%					} //end if (j == 0)
					DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(icurrentRec);
					String strPNo = "";
					String strPName = "";
					String strPId = "";
					String strPRBank = "";
					String strPRAccount = "";
					double iPAmt = 0;
					int iPDate = 0;
					String strPDate = "";
					int iPFee = 0;
					String strRMTSEQ = "";
					String strCurrency = "";
					String strRFPAYCURR = "";
					double iRPAYAMT = 0;
					String strPFEEWAY = "";
					String strPONO = "";
					double iRAMT = 0;
					int iRemitFailDate = 0;
					strRemitFailDate = "";
					String strRemitFailCode = "";
					String strRemitFailDesc = "";

					if (objPDetailVO.getStrPNO() != null)
						strPNo = objPDetailVO.getStrPNO();
					if (strPNo != "")
						strPNo = CommonUtil.AllTrim(strPNo);

					if (objPDetailVO.getStrPName() != null)
						strPName = objPDetailVO.getStrPName();
					if (strPName != "")
						strPName = CommonUtil.AllTrim(strPName);

					if (objPDetailVO.getStrPId() != null)
						strPId = objPDetailVO.getStrPId();
					if (strPId != "")
						strPId = CommonUtil.AllTrim(strPId);

					if (objPDetailVO.getStrPCurr() != null)
						strCurrency = objPDetailVO.getStrPCurr();
					if (strCurrency != "")
						strCurrency = CommonUtil.AllTrim(strCurrency);

					if (objPDetailVO.getStrPRBank() != null)
						strPRBank = objPDetailVO.getStrPRBank();
					if (strPRBank != "")
						strPRBank = CommonUtil.AllTrim(strPRBank);

					if (objPDetailVO.getStrPRAccount() != null)
						strPRAccount = objPDetailVO.getStrPRAccount();
					if (strPRAccount != "")
						strPRAccount = CommonUtil.AllTrim(strPRAccount);

					iPFee = objPDetailVO.getIRmtFee();

					iPAmt = objPDetailVO.getIPAMT();

					iPDate = objPDetailVO.getIPDate();
					if (iPDate == 0)
						strPDate = "";
					else {
						strPDate = Integer.toString(iPDate);
						strPDate = commonUtil.checkDateFomat(strPDate);
					}

					strRMTSEQ = objPDetailVO.getStrBATSEQ();
					if (strRMTSEQ != "")
						strRMTSEQ = CommonUtil.AllTrim(strRMTSEQ);

					iRPAYAMT = objPDetailVO.getIPPAYAMT();
					strRFPAYCURR = objPDetailVO.getStrPPAYCURR();
					if (strRFPAYCURR != "")
						strRFPAYCURR = CommonUtil.AllTrim(strRFPAYCURR);

					if (objPDetailVO.getStrPolicyNo() != null)
						strPONO = objPDetailVO.getStrPolicyNo();
					if (strPONO != "")
						strPONO = CommonUtil.AllTrim(strPONO);

					iRAMT = objPDetailVO.getIRAMT();

					iRemitFailDate = objPDetailVO.getRemitFailDate();
					if (iRemitFailDate == 0)
						strRemitFailDate = "";
					else {
						strRemitFailDate = Integer.toString(iRemitFailDate);
						strRemitFailDate = commonUtil.checkDateFomat(strRemitFailDate);
					}

					if(objPDetailVO.getRemitFailCode() != null)
						strRemitFailCode = CommonUtil.AllTrim(objPDetailVO.getRemitFailCode());

					if(objPDetailVO.getRemitFailDesc() != null)
						strRemitFailDesc = CommonUtil.AllTrim(objPDetailVO.getRemitFailDesc());
%>
				<TR id=data>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="25"><span onclick="seqClicked('<%=strPNo%>')"
						style="cursor: hand"><%=icurrentRec + 1%></span></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; display: <%=isDisablecheck%>"
						height="35" width="25"><INPUT type="checkbox"
						name="ch<%=icurrentRec%>" id="ch<%=icurrentRec%>" value="Y"> <INPUT
						name="txtPNo<%=icurrentRec%>" id="txtPNo<%=icurrentRec%>"
						type="hidden" value="<%=strPNo%>"></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="157"><%=strPName%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="65"><%=strPId%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="65"><%=strPRBank%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="139"><%=strPRAccount%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="61"><%=strPDate%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="142"><%=strCurrency%>$<%=df.format(iPAmt)%>&nbsp;<INPUT name="txtPAMT<%=icurrentRec%>" id="txtPAMT<%=icurrentRec%>"
						type="hidden" value="<%=iPAmt%>"></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="56"><%=iPFee%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="56"><%=strRMTSEQ%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="56"><%=strPONO%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="90"><%=df.format(iRAMT)%></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="61"><%=strRemitFailDate%>&nbsp;</TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="61"><%=strRemitFailCode%>&nbsp;<INPUT type="hidden" id="txtCode<%=icurrentRec%>" name="txtCode<%=icurrentRec%>" value="<%=strRemitFailCode%>"></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
						height="35" width="61"><%=strRemitFailDesc%>&nbsp;<INPUT type="hidden" id="txtDesc<%=icurrentRec%>" name="txtDesc<%=icurrentRec%>" value="<%=strRemitFailDesc%>"></TD>
				</TR>
<%					if ((iSeqNo == iPageSize) || (icurrentRec == (alPDetail.size() - 1)) || (iSeqNo % iPageSize == 0)) { %>
			</tbody>
		</table>
	</div>
<%					}
				} // end of if --> inowRec < alPDetail.size()
			} // end of for -- show detail      
		} //end of for%> 
	<input type="checkbox" name="allbox" onClick="CheckAll();" style="display: ; display: <%=isDisablecheck%>"> 總頁數 : <%=itotalpage%> &nbsp;&nbsp;總件數 : <%=itotalCount%>&nbsp;&nbsp;&nbsp;&nbsp;總金額:<%=df.format(iSumAmt)%> 
<%	} //end of f alPDetail.size() > 0 
} //end of if alPDetail != null
%>
	<INPUT type="hidden" id="txtPNo" name="txtPNo" value=""> 
	<INPUT type="hidden" id="txtTpage" name="txtTpage" value="<%=itotalpage%>"> 
	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
<!--報表-->
<FORM id="frmMain1" method="post" name="frmMain1" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitFailModifyReport.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBRemitFailMaintainReport.pdf"> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBRemit\\"> 
	<INPUT type="hidden" id="para_PConDate" name="para_PConDate">
</FORM>
</BODY>
</HTML>
