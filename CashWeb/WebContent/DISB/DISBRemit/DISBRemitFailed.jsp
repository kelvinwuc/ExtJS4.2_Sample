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
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.21 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2013/12/24 03:55:46 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBRemitFailed.jsp,v $
 * Revision 1.21  2013/12/24 03:55:46  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.17.4.1  2012/12/06 06:28:26  MISSALLY
 * RA0102　PA0041
 * 配合法令修改酬佣支付作業
 *
 * Revision 1.17  2012/05/18 09:49:51  MISSALLY
 * R10314 CASH系統會計作業修改
 *
 * Revision 1.16  2011/06/02 10:28:08  MISSALLY
 * Q90585 / R90884 / R90989
 * CASH系統匯退處理作業新增匯退原因欄位並修正退匯明細表
 *
 * Revision 1.15  2010/11/23 02:39:10  MISJIMMY
 * R00226-百年專案
 * R00365-匯退報表無法正確顯示手續費支付方式及手續費金額
 *
 * Revision 1.14  2009/07/03 04:28:29  missteven
 * 退匯勾選欄位為空白
 * 匯退顯示確認筆數及金額視窗
 *
 * Revision 1.13  2009/02/24 06:34:57  misodin
 * R90130 不帶出支票件之判斷方式調整
 *
 * Revision 1.12  2008/09/04 06:10:14  MISODIN
 * R80132 調整CASH系統for 6種幣別
 *
 * Revision 1.11  2008/08/06 07:07:31  MISODIN
 * R80338 調整CASH系統 for 出納外幣一對一需求
 *
 * Revision 1.10  2008/06/06 03:34:06  misvanessa
 * R80391_請新增CASH系統信用卡退回
 *
 * Revision 1.9  2008/04/01 06:14:43  misvanessa
 * R80211_新增匯退日期及修改匯退報表規則
 *
 * Revision 1.8  2007/10/04 01:27:10  MISODIN
 * R70477 外幣保單匯款手續費
 *
 * Revision 1.7  2007/08/28 01:37:56  MISVANESSA
 * R70574_SPUL配息新增匯出檔案
 *
 * Revision 1.6  2007/04/13 06:06:15  MISVANESSA
 * R70279_匯退報表處理
 *
 * Revision 1.5  2007/01/31 08:07:42  MISVANESSA
 * R70088_SPUL配息
 *
 * Revision 1.4  2007/01/04 03:28:55  MISVANESSA
 * R60550_抓取方式修改
 *
 * Revision 1.3  2006/11/30 09:15:36  MISVANESSA
 * R60550_配合SPUL&外幣付款修改
 *
 * Revision 1.2  2006/10/31 08:53:12  MISVANESSA
 * R60420_匯退處理新增報表
 *
 * Revision 1.1  2006/06/29 09:39:46  MISangel
 * Init Project
 *
 * Revision 1.1.2.10  2006/04/27 09:41:44  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.9  2005/08/19 07:12:29  misangel
 * R50427 : 匯款件依部門+姓名+帳號合併
 *
 * Revision 1.1.2.8  2005/04/04 07:02:25  miselsa
 * R30530 支付系統
 *  
 */
%><%!
String strThisProgId = "DISBRemitFailed"; //本程式代號
DecimalFormat df = new DecimalFormat("#.00");
DecimalFormat df2 = new DecimalFormat("#.0000");
%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

//R60420 印出當天匯退資料
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();
String today = commonUtil.convertWesten2ROCDate(calendar.getTime());
int iToday = Integer.parseInt(commonUtil.convertWesten2ROCDate1(calendar.getTime()));

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

//付款帳號
List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") == null) {
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList", alPBBank);
} else {
	alPBBank = (List) session.getAttribute("PBBankList");
}
StringBuffer sbPBBank = new StringBuffer();
sbPBBank.append("<option value=\"\">&nbsp;</option>");
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
}

// R70477 外幣保單
List alPBBankD = new ArrayList();
if (session.getAttribute("PBBankListD") == null) {
	alPBBankD = (List) disbBean.getETable("PBKAT", "BANKD"); // R00386 - 2010/11/03 應要求加入 BNKPR 表中的 bank
//	alPBBankD.addAll(disbBean.getETable("BNKPR", "BANKPR")); // R00386, 加入傳統型美元保單用的匯款銀行
	alPBBankD.addAll(disbBean.getETable("PBKAT", "BANKP"));
	alPBBankD.addAll(disbBean.getETable("BNKFR", "BANKFR"));
	session.setAttribute("PBBankListD", alPBBankD);
} else {
	alPBBankD = (List) session.getAttribute("PBBankListD");
}
StringBuffer sbPBBankD = new StringBuffer();
sbPBBankD.append("<option value=\"\" >&nbsp;</option>");
if (alPBBankD.size() > 0) {
	for (int i = 0; i < alPBBankD.size(); i++) {
		htTemp = (Hashtable) alPBBankD.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		//R10314
		sbPBBankD.append("<option value=\"").append(strValue).append("\" >").append(strValue).append("-").append(strDesc).append("</option>");
		//if(strValue.equalsIgnoreCase("8220635/635131008304"))	//8220635/635131008304-中信銀復興
			//sbPBBankD.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		//else
			//sbPBBankD.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}

// R80338
List alPBBankP = new ArrayList();
if (session.getAttribute("PBBankListP") == null) {
	alPBBankP = (List) disbBean.getETable("PBKAT", "BANKP");
	session.setAttribute("PBBankListP", alPBBankP);
} else {
	alPBBankP = (List) session.getAttribute("PBBankListP");
}
StringBuffer sbPBBankP = new StringBuffer();
sbPBBankD.append("<option value=\"\">&nbsp;</option>");
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
}

//R80132 幣別挑選
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
} //R80132 END
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

//R90884
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

String strAction = "";
if (request.getAttribute("txtAction") != null) {
	strAction = (String) request.getAttribute("txtAction");
}

String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
	strReturnMessage = (String) request.getAttribute("txtMsg");
}
//R60550 
String strFEECURR = "";
if (request.getAttribute("txtFEECURR") != null) {
	strFEECURR = (String) request.getAttribute("txtFEECURR");
}

//R80391
String strWAYSHOW = "";
if (request.getAttribute("txtWAYSHOW") != null) {
	strWAYSHOW = (String) request.getAttribute("txtWAYSHOW");
}

//R10314
String strBRDate = "";
if (request.getAttribute("txtBRemitFailDate") != null) 
	strBRDate = (String) request.getAttribute("txtBRemitFailDate");
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>支付功能--退匯處理作業</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="javascript">
var iTotalrec =<%=itotalCount%>;
// *************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitFailed.jsp";
	}	

	if(document.getElementById("txtAction").value == "I")
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyRemitFailed,'' );	//退匯,離開
		document.getElementById("inquiryArea").style.display = "none";	// R70477
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";	//R80338
		document.getElementById("inquiryAreaC").style.display ="none";	//R90884
		document.getElementById("inquiryAreaE").style.display ="block";	//R90884
	}
	else
	{
		//R60420
		WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
		document.getElementById("inquiryArea").style.display = "block";	// R70477
		document.getElementById("inquiryAreaA").style.display ="block";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";	//R80338
		document.getElementById("inquiryAreaE").style.display ="none";	//R90884
	}

	//R90884
	document.getElementById("txtRDateC").value = "<%=today%>";
	document.getElementById("txtRFDateC").value = "<%=today%>";
	//R10314
	document.getElementById("txtBRFDateC").value = "<%=commonUtil.convertROCDate(strBRDate)%>";

	window.status = "";
}

// R70477 外幣保單
function showDArea()
{
	// R80338
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

/*
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
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
函數功能:	當toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitFailed.jsp";
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
    mapValue();
	if (document.getElementById("selFEESHOW").value == "US")
		document.getElementById("txtFEECURR").value = "US";
	else
		document.getElementById("txtFEECURR").value = "NT";

     document.getElementById("txtAction").value = "I";
    //R80211付款日期.金額.名字三個欄位必輸入二個以上
   	if( areAllFieldsOK() )
	{	
    	document.getElementById("frmMain").submit();
    }
}

//R80211
function areAllFieldsOK()
{
	var intCNT = 0;
	if (document.getElementById("txtNAME").value != "")
		intCNT = intCNT + 1;
	if (document.getElementById("txtPDate").value != "")
		intCNT = intCNT + 1;
	if (document.getElementById("txtAMT").value != "" )
		intCNT = intCNT + 1;
	if (document.getElementById("txtPCSHCM").value != "")
		intCNT = intCNT + 1;

	var varMsg = "";
	if (intCNT > 1) {
		var varRBDate = document.getElementById("txtBRDateC").value;
		if(varRBDate == "") {
			varMsg = "請輸入銀行退匯回存日期！";
		} else if(varRBDate.replace(/\//g,"") > <%=iToday%>) {
			varMsg = "銀行退匯回存日期不得晚於CAPSIL開機日期！";
		}
	} else {
		varMsg = "付款日/金額/受款人姓名/出納確認日必輸入二個以上查詢條件";
	}

	if(varMsg != "") {
		alert(varMsg);
		return false;
	} else {
		return true;
	}
}

//R80384 當 toolbar frame 中之退匯按鈕被點選時,本函數會被執行
function DISBRemitFailedAction()
{
	if(document.getElementById("selRFCode").value == "") 
	{
		alert("請選擇退匯代碼!!");
		return false;
	}
	//R90884 退匯原因檢核 代碼=99, User必須輸入退匯原因
	if(document.getElementById("selRFCode").value == "99" && document.getElementById("txtRFDesc").value == "") 
	{
		alert("退匯代碼99，請輸入退匯原因。");
		return false;
	}

	var flag = 0 ;
	var amount = 0 ;
 	for (var i = 0 ; i <  iTotalrec ; i++ ) {
    	if(document.getElementById("ch" + i ).checked) {
       		flag++ ;
       		amount = amount + parseFloat(document.getElementById("txtPAMT"+i).value) ;
       	}
	}

 	if(flag == 0) {
    	alert("至少要勾選一筆項目");
		return false;
    } else {
		var bConfirm = window.confirm("退匯筆數："+flag+"(筆)\n\n退匯金額："+amount+"(元)\n\n是否確定要執行退匯作業!?" );
		if(bConfirm)
		{
			enableAll();
			document.getElementById("txtAction").value = "DISBRemitFailed";
			mapValue();
			document.getElementById("frmMain").submit();
		}
	}
}

/* R60420   退匯/信用卡付款失敗報表
函數名稱:	printRAction()
函數功能:	當toolbar frame 中之報表按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function printRAction()
{
	mapValue();//R80211
	window.status = "";
	if (EntryDateVaild())
	{
		getReportInfo();
		document.getElementById("frmMain1").target="_blank";
		document.getElementById("frmMain1").submit();
	}
}

//R80211輸入退匯日期
function EntryDateVaild()
{
	if (document.getElementById("txtRDate").value == "")
	{
		alert ("請輸入退匯日期");
		return false;
	}
	else
		return true;
}

function getReportInfo()
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
	strSql += " left outer join caprfef d on A.PNO=D.FPNOH ";
	strSql += " left outer join (SELECT FPNOH,MAX(ENTRYDT) as ENTRYDT FROM CAPRFEF GROUP BY FPNOH) e on e.FPNOH=d.FPNOH and d.ENTRYDT=e.ENTRYDT ";
	strSql += " WHERE A.PAY_METHOD IN ('B','C','D') AND A.PAY_STATUS = 'A' AND A.PAY_REMITFAIL_DATE <> 0 ";
	strSql += " AND A.PAY_REMITFAIL_DATE= " + document.getElementById("txtRDate").value;

	//R80132
    if (document.getElementById("selCurrency").value !="")
    {
    	strSql += " AND A.PAY_CURRENCY = '" + document.getElementById("selCurrency").value + "' ";
    }

	strSql += " ORDER BY A.ENTRY_USER, A.PAY_METHOD";

	document.frmMain1.ReportSQL.value = strSql;
	document.frmMain1.para_PConDate.value = document.getElementById("txtRDate").value ;
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
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
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

function mapValue() 
{
	document.getElementById("txtPDate").value = rocDate2String(document.getElementById("txtPDateC").value) ;
    var BankAccount = document.getElementById("selPBBank").value ;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);
	}  
	// R70477
	var BankAccountD = document.getElementById("selPBBankD").value ;
	if(BankAccountD !="")
	{
		var iindexof = BankAccountD.indexOf('/');
		document.getElementById("txtPBBankD").value = BankAccountD.substring(0,iindexof);
		document.getElementById("txtPBAccountD").value = BankAccountD.substring(iindexof+1);	
	}  
	// R80338
	var BankAccountP = document.getElementById("selPBBankP").value ;
	if(BankAccountP !="")
	{
		var iindexof = BankAccountP.indexOf('/');
		document.getElementById("txtPBBankP").value = BankAccountP.substring(0,iindexof);
		document.getElementById("txtPBAccountP").value = BankAccountP.substring(iindexof+1);	
	}  
	//R80211
	document.getElementById("txtRDate").value = rocDate2String(document.getElementById("txtRDateC").value);
	//R90884
	document.getElementById("txtRFDateC").value = document.getElementById("txtRDateC").value;
	document.getElementById("txtRFDate").value = rocDate2String(document.getElementById("txtRFDateC").value);
	//R10314
	document.getElementById("txtBRDate").value = rocDate2String(document.getElementById("txtBRDateC").value);
	document.getElementById("txtBRFDate").value = rocDate2String(document.getElementById("txtBRFDateC").value);
	//R80391
	document.getElementById("txtPCSHCM").value = rocDate2String(document.getElementById("txtPCSHCMC").value) ;
}

//R90884 若選擇退匯代碼自動帶出退匯原因
function changeRFDesc()
{
	var RemitFailArray = [<% if(sbRFScriptArray.toString().length() > 0) { out.print(sbRFScriptArray.toString().substring(1)); } %>];

	document.getElementById("txtRFDesc").value = "";
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
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitFailedServlet">
	<TABLE border="1" width="400" id=inquiryArea>
		<TBODY>
			<TR>
				<TD align="right" class="TableHeading" width="130">付款日：</TD>
				<TD>
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateC" name="txtPDateC" value="" readOnly onBlur="checkClientField(this,true);">
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
				<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtAMT" name="txtAMT" VALUE=""></TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">受款人姓名：</TD>
				<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtNAME" name="txtNAME" VALUE=""></TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">退匯方式：</TD>
				<TD>
					<select size="1" name="selFEESHOW" id="selFEESHOW" onChange="showDArea();">
						<option value=""></option>
						<option value="NT">台幣退匯</option>
						<option value="US">外幣退匯</option>
						<option value="C">信用卡退回</option>
					</select>
				</TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">出納確認日：</TD>
				<TD><INPUT class="Data" size="11" type="text"
					maxlength="11" id="txtPCSHCMC" name="txtPCSHCMC" value="" readOnly
					onblur="checkClientField(this,true);"> <a
					href="javascript:show_calendar('frmMain.txtPCSHCMC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
					src="<%=request.getContextPath()%>/images/misc/show-calendar.gif"
					alt="查詢"></a> <INPUT type="hidden" name="txtPCSHCM" id="txtPCSHCM"
					value=""></TD>
			</TR>
		</TBODY>
	</TABLE>
<!-- R70477  -->
	<TABLE border="1" width="400" id=inquiryAreaA style='display: none'>
		<TR>
			<TD align="right" class="TableHeading" width="130">付款帳號：</TD>
			<TD>
				<select size="1" name="selPBBank" id="selPBBank">
					<%=sbPBBank.toString()%>
				</select>
				<INPUT type="hidden" name="txtPBBank" id="txtPBBank" value=""> 
				<INPUT type="hidden" name="txtPBAccount" id="txtPBAccount" value="">
			</TD>
		</TR>
	</TABLE>
<!--R80211 加入退匯日期-->
	<TABLE border="1" width="400" id=inquiryAreaC>
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
			<TD align="right" class="TableHeading">執行退匯日期：</TD>
			<TD>
				<INPUT type="text" class="Data" id="txtRDateC" name="txtRDateC" size="11" maxlength="11" value="" readOnly onBlur="checkClientField(this,true);">
				<INPUT type="hidden" id="txtRDate" name="txtRDate" value="">
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="400" id=inquiryAreaB style='display: none'>
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
<!-- R80338 -->
	<TABLE border="1" width="400" id=inquiryAreaD style='display: none'>
		<TR>
			<TD align="right" class="TableHeading" width="130">付款帳號：</TD>
			<TD>
				<select size="1" name="selPBBankP" id="selPBBankP">
					<%=sbPBBankP.toString()%>
				</select> 
				<INPUT type="hidden" name="txtPBBankP" id="txtPBBankP" value=""> 
				<INPUT type="hidden" name="txtPBAccountP" id="txtPBAccountP" value="">
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="700" id="inquiryAreaE" style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="130">銀行退匯回存日期：</TD>
			<TD colspan="5">
				<INPUT type="text" class="Data" id="txtBRFDateC" name="txtBRFDateC" size="11" maxlength="11" value="" readOnly>
				<INPUT type="hidden" id="txtBRFDate" name="txtBRFDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="130">執行退匯日期：</TD>
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
<%//R60550
String strFEESHOW = "";
if (strFEECURR.equals("NT")) {
	strFEESHOW = "display:none";
} else {
	strFEESHOW = "display:block";
}
//R80391
String strBankShow = "";
String strCrdShow = "";
if (strWAYSHOW.equals("C")) {
	strBankShow = "display:none";
	strCrdShow = "display:block";
} else {
	strBankShow = "display:block";
	strCrdShow = "display:none";
}
if (alPDetail != null) {
	//if1			
	if (alPDetail.size() > 0) {
		//if2
		int icurrentRec = 0;
		int icurrentPage = 0; // 由0開始計
		int iSeqNo = 0;
		for (int i = 0; i < itotalpage; i++) {
			icurrentPage = i;
			for (int j = 0; j < iPageSize; j++) {
				iSeqNo++;
				icurrentRec = icurrentPage * iPageSize + j;
				if (icurrentRec < alPDetail.size()) {
					if (j == 0) // show table head
					{
						if ((icurrentPage + 1) == 1) {%>
<div id="showPage<%=icurrentPage + 1%>" style="display: "><%} else {%>
<div id="showPage<%=icurrentPage + 1%>" style="display: none"><%}%>
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
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="25"><b><font size="2" face="細明體">勾選</font></b></TD>
				<TD bgcolor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="100"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
				<TD bgcolor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="50"><b><font size="2" face="細明體">受款人ID</font></b></TD>
				<!--r80391 信用卡-->
				<TD bgcolor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="50"><b><font size="2" face="細明體">匯款銀行</font></b></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="100"><font size="2" face="細明體"><b>匯款帳號</b></font></TD>
				<TD bgcolor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="50"><b><font size="2" face="細明體">付款銀行</font></b></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="139"><font size="2" face="細明體"><b>信用卡卡號</b></font></TD>
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
				<!--r80391-->
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="56"><font size="2" face="細明體"><b>保單號碼</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="90"><font size="2" face="細明體"><b>合併匯款金額</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="90"><font size="2" face="細明體"><b>外幣匯款金額</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="45"><font size="2" face="細明體"><b>退匯手續費幣別</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="115"><font size="2" face="細明體"><b>退匯手續費</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="45"><font size="2" face="細明體"><b>退匯支付方式</b></font></TD>
			</TR>
<%}
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
String strRFPAYCURR = ""; //R60550
String strSYMBOL = ""; //R60550
String opSel1 = ""; //R60550
String opSel2 = ""; //R60550
double iRPAYAMT = 0; //R60550
String strPFEEWAY = ""; //R70477
String strPBBank = ""; //r80391
String strPCrdNo = ""; //r80391
String strPONO = ""; //r80391
double iRAMT = 0; //R80391

if (objPDetailVO.getStrPNO() != null)
	strPNo = objPDetailVO.getStrPNO();
if (strPNo != "")
	strPNo = strPNo.trim();

if (objPDetailVO.getStrPName() != null)
	strPName = objPDetailVO.getStrPName();
if (strPName != "")
	strPName = strPName.trim();

if (objPDetailVO.getStrPId() != null)
	strPId = objPDetailVO.getStrPId();
if (strPId != "")
	strPId = strPId.trim();

if (objPDetailVO.getStrPCurr() != null)
	strCurrency = objPDetailVO.getStrPCurr();
if (strCurrency != "")
	strCurrency = strCurrency.trim();

if (objPDetailVO.getStrPRBank() != null)
	strPRBank = objPDetailVO.getStrPRBank();
if (strPRBank != "")
	strPRBank = strPRBank.trim();

if (objPDetailVO.getStrPRAccount() != null)
	strPRAccount = objPDetailVO.getStrPRAccount();
if (strPRAccount != "")
	strPRAccount = strPRAccount.trim();
iPFee = objPDetailVO.getIRmtFee();
iPAmt = objPDetailVO.getIPAMT();
iPDate = objPDetailVO.getIPDate();

if (iPDate == 0)
	strPDate = "";
else {
	strPDate = Integer.toString(iPDate);
	//R00231 edit by Leo Huang 
	strPDate = new CommonUtil().checkDateFomat(strPDate);
}
strRMTSEQ = objPDetailVO.getStrBATSEQ();
if (strRMTSEQ != "")
	strRMTSEQ = strRMTSEQ.trim();
//R60550
iRPAYAMT = objPDetailVO.getIPPAYAMT();
strRFPAYCURR = objPDetailVO.getStrPPAYCURR();
if (strRFPAYCURR != "")
	strRFPAYCURR = strRFPAYCURR.trim();
if(strRFPAYCURR.equals(""))
	strRFPAYCURR = "&nbsp;";


strSYMBOL = objPDetailVO.getStrPSYMBOL();
if (strSYMBOL.equals("S"))
	opSel1 = "selected";
else
	opSel2 = "selected";
// R70477 	
strPFEEWAY = objPDetailVO.getStrPFEEWAY();
if (strSYMBOL.equals("D") && strPFEEWAY.equals("BEN"))
	opSel1 = "selected";
if (strSYMBOL.equals("D") && strPFEEWAY.equals("OUR"))
	opSel2 = "selected";
//R80391 新增4個欄位 	
if (objPDetailVO.getStrPBBank() != null)
	strPBBank = objPDetailVO.getStrPBBank();
if (strPBBank != "")
	strPBBank = strPBBank.trim();

if (objPDetailVO.getStrPCrdNo() != null)
	strPCrdNo = objPDetailVO.getStrPCrdNo();
if (strPCrdNo != "")
	strPCrdNo = strPCrdNo.trim();

if (objPDetailVO.getStrPolicyNo() != null)
	strPONO = objPDetailVO.getStrPolicyNo();
if (strPONO != "")
	strPONO = strPONO.trim();
iRAMT = objPDetailVO.getIRAMT();%>

			<TR id=data>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="25"><span onClick="seqClicked('<%=strPNo%>')"
					style="cursor: hand"><%=icurrentRec + 1%></span></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
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
					height="35" width="65"><%=strPBBank%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="139"><%=strPCrdNo%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="61"><%=strPDate%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="142"><%=strCurrency%>$<%=df.format(iPAmt)%>&nbsp;
				<INPUT name="txtPAMT<%=icurrentRec%>" id="txtPAMT<%=icurrentRec%>"
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
					height="35" width="90"><%=df2.format(iRPAYAMT)%></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="45"><%=strRFPAYCURR%></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="115"><INPUT class="Data" size="3" type="text"
					maxlength="16" id="txtFEEAMT<%=icurrentRec%>"
					name="txtFEEAMT<%=icurrentRec%>" VALUE="0"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="45"><select size="1"
					name="selFEEWAY<%=icurrentRec%>" id="selFEEWAY<%=icurrentRec%>">
					<option value="BEN" <%=opSel1%>>BEN</option>
					<option value="OUR" <%=opSel2%>>OUR</option>
				</select></TD>
			</TR>
		<%if ((iSeqNo == iPageSize)
	|| (icurrentRec == (alPDetail.size() - 1))
	|| (iSeqNo % iPageSize == 0)) {%>
		</tbody>
	</table>
</div>
<%}
} // end of if --> inowRec < alPDetail.size()
} // end of for -- show detail      
} //end of for%> 
	<input name="allbox" type="checkbox" onClick="CheckAll();"> 總頁數 : <%=itotalpage%> &nbsp;&nbsp;總件數 : <%=itotalCount%>&nbsp;&nbsp;&nbsp;&nbsp;總金額:<%=df.format(iSumAmt)%> 
<%} //end of if2 
} //end of if1%>
	<INPUT type="hidden" id="txtPNo" name="txtPNo" value=""> 
	<INPUT type="hidden" id="txtTpage" name="txtTpage" value="<%=itotalpage%>"> 
	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
	<INPUT type="hidden" id="txtFEECURR" name="txtFEECURR" value="<%=strFEECURR%>"><!--R60550--> 
	<INPUT type="hidden" id="txtWAYSHOW" name="txtWAYSHOW" value="<%=strWAYSHOW%>"><!--R60550-->
</FORM>
</BODY>
</HTML>
