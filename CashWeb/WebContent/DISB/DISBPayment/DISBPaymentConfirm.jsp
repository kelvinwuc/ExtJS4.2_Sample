<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   :  
 * 
 * Function : 支付確認
 * 
 * Remark   : 支付功能
 * 
 * Revision : $Revision: 1.16 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2014/07/18 07:27:21 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPaymentConfirm.jsp,v $
 * Revision 1.16  2014/07/18 07:27:21  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.15  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.14  2013/01/09 02:47:49  MISSALLY
 * 1. for add the display time
 * 2. Calendar problem
 *
 * Revision 1.13  2013/01/08 04:25:57  MISSALLY
 * 將分支的程式Merge至HEAD
 *
 * Revision 1.9.4.1  2012/12/06 06:28:23  MISSALLY
 * RA0102　PA0041
 * 配合法令修改酬佣支付作業
 *
 * Revision 1.9  2010/11/23 02:24:10  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.7  2008/09/04 06:09:22  MISODIN
 * R80132 調整CASH系統for 6種幣別
 *
 * Revision 1.6  2008/08/06 06:03:08  MISODIN
 * R80132 調整CASH系統for 6種幣別
 *
 * Revision 1.5  2008/06/12 02:10:58  MISODIN
 * R80244 FIN分成FIN & ACCT
 * 
 * Revision 1.4  2007/08/03 10:14:27  MISODIN
 * R70477 外幣保單匯款手續費
 *
 * Revision 1.3  2007/01/04 03:18:43  MISVANESSA
 * R60550_配合SPUL&外幣付款修改
 *
 * Revision 1.2  2006/12/07 10:11:11  MISVANESSA
 * R60550_配合SPUL&外幣付款修改
 *
 * Revision 1.1  2006/06/29 09:40:49  MISangel
 * Init Project
 *
 * Revision 1.1.2.12  2006/04/27 09:31:44  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.10  2005/04/04 07:02:21  miselsa
 * R30530 支付系統
 *  
 */
%><%! String strThisProgId = "DISBPaymentConfirm"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
DecimalFormat df = new DecimalFormat("#.00");
DecimalFormat df2 = new DecimalFormat("#.0000");//R60550

String strAction = (request.getAttribute("txtAction") != null)?((String) request.getAttribute("txtAction")):"";
String strReturnMessage = (request.getAttribute("txtMsg") != null)?((String) request.getAttribute("txtMsg")):"";

List alPSrcGrp = new ArrayList();
if (session.getAttribute("SrcGpList") == null) {
	alPSrcGrp = (List) disbBean.getETable("SRCGP", "");
	session.setAttribute("SrcGpList",alPSrcGrp);
} else {
	alPSrcGrp =(List) session.getAttribute("SrcGpList");
}

List alPDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
double iSumAmt = 0;		//總金額
double iUSSumAmt = 0;	//總金額-美金
double iAUSumAmt = 0;	//總金額-AU   R80132
double iEUSumAmt = 0;	//總金額-EU   R80132
double iHKSumAmt = 0;	//總金額-HK   R80132
double iJPSumAmt = 0;	//總金額-JP   R80132
double iNZSumAmt = 0;	//總金額-NZ   R80132
double iCNSumAmt = 0;	//總金額-CN   EB0070

if(session.getAttribute("PDetailList") !=null)
{
	alPDetail = (List)session.getAttribute("PDetailList");
	if (alPDetail!=null)
	{
		if (alPDetail.size()>0)
		{
			for (int k = 0 ; k < alPDetail.size();k++)
			{
				DISBPaymentDetailVO objPDetailCounter = (DISBPaymentDetailVO)alPDetail.get(k);
				//System.out.println(objPDetailCounter.getStrPCurr());
				if (objPDetailCounter.getStrPCurr().trim().equals("US"))
				{
					iUSSumAmt = iUSSumAmt + objPDetailCounter.getIPAMT();
				} 
				// R80132 START
				else if (objPDetailCounter.getStrPCurr().trim().equals("AU"))
				{
					iAUSumAmt = iAUSumAmt + objPDetailCounter.getIPAMT();
				}
				else if (objPDetailCounter.getStrPCurr().trim().equals("EU"))
				{
					iEUSumAmt = iEUSumAmt + objPDetailCounter.getIPAMT();
				}
				else if (objPDetailCounter.getStrPCurr().trim().equals("HK"))
				{
					iHKSumAmt = iHKSumAmt + objPDetailCounter.getIPAMT();
				}
				else if (objPDetailCounter.getStrPCurr().trim().equals("JP"))
				{
					iJPSumAmt = iJPSumAmt + objPDetailCounter.getIPAMT();
				}
				else if (objPDetailCounter.getStrPCurr().trim().equals("NZ"))
				{
					iNZSumAmt = iNZSumAmt + objPDetailCounter.getIPAMT();
				}
				// R80132 END
				else if (objPDetailCounter.getStrPCurr().trim().equals("CN"))
				{
					iCNSumAmt = iCNSumAmt + objPDetailCounter.getIPAMT();
				}
				else
				{
					iSumAmt = iSumAmt + objPDetailCounter.getIPAMT();
				}
			}
			itotalCount = alPDetail.size();
		}

		if(itotalCount%iPageSize == 0) {
			itotalpage = itotalCount/iPageSize;
		} else {
			itotalpage = itotalCount/iPageSize + 1;
		}
	}
}
session.removeAttribute("PDetailList");

//付款日期
String strPDateHold = (request.getAttribute("txtPDateHold") != null)?((String) request.getAttribute("txtPDateHold")):"" ;
//輸入日期迄日  
String strEEDateHold = (request.getAttribute("txtEEDateHold") != null)?((String) request.getAttribute("txtEEDateHold")):"";

//R80132 幣別挑選
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
//R80132 END
Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbPSrcGrp = new StringBuffer();
sbPSrcGrp.append("<option value=\"\">&nbsp;</option>");
if (alPSrcGrp.size() > 0) {
	for (int i = 0; i < alPSrcGrp.size(); i++) {
		htTemp = (Hashtable) alPSrcGrp.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbPSrcGrp.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}
	sbPSrcGrp.append("<option value=\"CSCPAY\">CSC當日付款</option>");
	htTemp = null;
	strValue = null;
	strDesc = null;
}
StringBuffer sbCurrCash = new StringBuffer();
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		//R80132 default NT
		if(strValue.equalsIgnoreCase("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}
	htTemp = null;
	strValue = null;
} else {
	sbCurrCash.append("<option value=\"\">&nbsp;</option>");
}
%>
<HTML>
<HEAD>
<TITLE>支付功能--支付確認</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var iTotalrec =<%=itotalCount%>;
var iAMTA = 0 ;
var iCountA = 0;
var iUSAMTA = 0 ;
var iUSCountA = 0;
var iAMTB = 0 ;
var iCountB= 0;
var iUSAMTB = 0 ;
var iUSCountB= 0;
var iAMTC = 0 ;
var iCountC= 0;
var iUSAMTC = 0 ;
var iUSCountC= 0;
var iCountD= 0;//R60550
var iAMTD= 0;//R60550
var iCountE = 0;
var iAMTE = 0 ;

function WindowOnload()
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value);
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBPayment/DISBPaymentConfirm.jsp";
	}

	if(document.getElementById("txtAction").value == "I") {
		WindowOnLoadCommon( document.title, '', strDISBFunctionKeyConfirm, '' );
	} else {
		WindowOnLoadCommon( document.title+"(查詢)", '', strFunctionKeyInquiry1, '' );
	}
}

function inquiryAction()
{
	WindowOnLoadCommon( document.title+"(查詢)", '', strFunctionKeyInquiry1, '' );
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
}

function confirmAction()
{
	//R90380
	var objsrcgp = document.getElementById("selPSrcGp");
	var srcgp = objsrcgp.options[objsrcgp.selectedIndex].value;
	if ("CSCPAY" === srcgp)
		document.getElementById("txtAction").value = "CSC";
	else
		document.getElementById("txtAction").value = "I";

	mapValue();
	document.getElementById("txtPDateHold").value = document.getElementById("txtEntryEndDate").value;

	if( areAllFieldsOK() )
	{
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}

function DISBPConfirmAction()
{
	if(IsItemChecked())
	{
		if(getCheckData()) {
			var strConfirmMsg = "是否確定要執行支付確認作業?\n";
			if(iCountA > 0)
			{
				strConfirmMsg = strConfirmMsg + "支票筆數:" + iCountA + "\n支票件總額:" + iAMTA +"\n";
			}
			if(iUSCountA > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_支票筆數:" + iUSCountA + "\n支票件總額:" + iUSAMTA +"\n";
			}
			if(iCountB > 0)
			{
				strConfirmMsg = strConfirmMsg + "匯款筆數:" + iCountB + "\n匯款件總額:" + iAMTB +"\n";
			}
			if(iUSCountB > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_匯款筆數:" + iUSCountB + "\n匯款件總額:" + iUSAMTB +"\n";
			}
			if(iCountC > 0)
			{
				strConfirmMsg = strConfirmMsg + "信用卡筆數:" + iCountC + "\n信用卡件總額:" + iAMTC +"\n";
			}
			if(iUSCountC > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_信用卡筆數:" + iUSCountC + "\n信用卡件總額:" + iUSAMTC +"\n";
			}
			//R60550
			if(iCountD > 0)
			{
				strConfirmMsg = strConfirmMsg + "外幣匯款:" + iCountD + "\n外幣匯款總額:" + iAMTD.toFixed(2) +"\n";
			}
			//RB0302
			if(iCountE > 0)
			{
				strConfirmMsg = strConfirmMsg + "現金筆數:" + iCountE + "\n現金件總額:" + iAMTE +"\n";
			}
	
			var bConfirm = window.confirm(strConfirmMsg);
			if( bConfirm )
			{
				enableAll();
				document.getElementById("txtAction").value = "DISBPaymentConfirm";
				document.getElementById("frmMain").submit();
			}
		}
	}
}

/*
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
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
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBPayment/DISBPaymentConfirm.jsp";
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
	if( objThisItem.id == "txtEntryStartDateC" )
	{
		if( objThisItem.value != "" && document.getElementById("txtEntryEndDateC").value != "")
		{
			if (objThisItem.value  > document.getElementById("txtEntryEndDateC").value)
			{
			   	strTmpMsg = "輸入日期的起日不得大於輸入日期的迄日";
				bReturnStatus = false;
			}
		}
	}
	else 	if( objThisItem.id == "txtEntryEndDateC" )
	{
	    if (objThisItem.value =="")
	    {
			strTmpMsg = "輸入迄日不可空白";
			bReturnStatus = false;	    
	    }
		if( objThisItem.value != "" && document.getElementById("txtEntryStartDateC").value != "")
		{
			if (objThisItem.value  < document.getElementById("txtEntryStartDateC").value)
			{
			   	strTmpMsg = "輸入日期的起日不得大於輸入日期的迄日";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.id == "txtPDateC" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "付款日期不可空白";
			bReturnStatus = false;
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

function mapValue() {
	document.getElementById("txtPDate").value = rocDate2String(document.getElementById("txtPDateC").value) ;
	document.getElementById("txtEntryStartDate").value = rocDate2String(document.getElementById("txtEntryStartDateC").value) ;	    	 
   	document.getElementById("txtEntryEndDate").value = rocDate2String(document.getElementById("txtEntryEndDateC").value) ;	
}

function getCheckData()
{
	iAMTA = 0;
	iCountA = 0;
	iUSAMTA = 0;
	iUSCountA = 0;
	iAMTB = 0;
	iCountB = 0;
	iUSAMTB = 0;
	iUSCountB = 0;
	iAMTC = 0;
	iCountC = 0;
	iUSAMTC = 0;
	iUSCountC = 0;
	iAMTD = 0;//R60550
	iCountD = 0;//R60550
	iCountE = 0;//RB0302
	iAMTE = 0;//RB0302

	var varMsg = "";
	var errCounter = 0;
	for (var i = 0; i < iTotalrec; i++) {
		var checkId = "ch" + i;
		if (document.getElementById(checkId).checked) {
			if (document.getElementById("txtPMethod" + i).value == "A") {
				if (document.getElementById("txtCurrency" + i).value == "US") {
					iUSCountA++;
					iUSAMTA = iUSAMTA + parseFloat(document.getElementById("txtPAMT" + i).value);
				} else {
					iCountA++;
					iAMTA = iAMTA + parseFloat(document.getElementById("txtPAMT" + i).value);
				}
			} else if (document.getElementById("txtPMethod" + i).value == "B") {
				if (document.getElementById("txtCurrency" + i).value == "US") {
					iUSCountB++;
					iUSAMTB = iUSAMTB + parseFloat(document.getElementById("txtPAMT" + i).value);
				} else {
					iCountB++;
					iAMTB = iAMTB + parseFloat(document.getElementById("txtPAMT" + i).value);
				}
			} else if (document.getElementById("txtPMethod" + i).value == "C") {
				if (document.getElementById("txtCurrency" + i).value == "US") {
					iUSCountC++;
					iUSAMTC = iUSAMTC + parseFloat(document.getElementById("txtPAMT" + i).value);
				} else {
					iCountC++;
					iAMTC = iAMTC + parseFloat(document.getElementById("txtPAMT" + i).value);
				}
			} else if (document.getElementById("txtPMethod" + i).value == "D") {
				iCountD++;
				iAMTD = iAMTD + parseFloat(document.getElementById("txtPAMT" + i).value);
			//RB0302
			} else if (document.getElementById("txtPMethod" + i).value == "E") {
				iCountE++;
				iAMTE = iAMTE + parseFloat(document.getElementById("txtPAMT" + i).value);
			}
			//alert(checkId);
			//PA0024 - 增加檢核支付代碼不得為空白
			if(errCounter <= 10) {
				if(document.getElementById("txtPsrccode" + i).value == "") {
					varMsg += "序號"+(i+1)+" 支付代碼不可為空白\r\n";
					errCounter++;
				}
			}
			//RB0302
			if(document.getElementById("txtPMethod" + i).value == "E" &&
				(!(document.getElementById("txtCurrency" + i).value == "NT" && (document.getElementById("txtPsrccode" + i).value == "E1" || document.getElementById("txtPsrccode" + i).value == "E2") &&
				document.getElementById("txtDispatch" + i).value == "Y"))) {
				varMsg += "序號"+(i+1)+" 必須為急件之保單借款才能現金支付\r\n";
				errCounter++;
			}
		}
	}
	if(errCounter > 0) {
		alert(varMsg);
		return false;
	} else {
		return true;
	}
}

function CheckAll() {
	for ( var i = 0; i < document.frmMain.elements.length; i++) {
		var e = document.frmMain.elements[i];
		if (e.name != 'allbox')
			e.checked = !e.checked;
	}
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnload();">
<form id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpayment.DISBPConfirmServlet">
<TABLE border="1" width="1030">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="80">輸入日期：</TD>
			<TD colspan=3 width="320"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> <INPUT
				type="hidden" name="txtEntryStartDate" id="txtEntryStartDate"
				value=""> ~ <INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtEntryEndDateC" name="txtEntryEndDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtEntryEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> <INPUT type="hidden" name="txtEntryEndDate" id="txtEntryEndDate" value="">
			</TD>
			<TD align="right" class="TableHeading" width="80">付款日期：</TD>
			<TD colspan=3 width="150"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPDateC" name="txtPDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> <INPUT type="hidden" name="txtPDate" id="txtPDate" value=""></TD>
           	<TD align="right" class="TableHeading" width="80">來源群組：</TD>
			<TD colspan=3 width="130">
				<select size="1" name="selPSrcGp" id="selPSrcGp">
					<%=sbPSrcGrp.toString()%>
				</select>
			</TD>
	        <TD align="right" class="TableHeading" width="80">急件：</TD>
			<TD colspan=3 width="60">
				<select size="1" name="selDispatch" id="selDispatch">
					<option value=""></option>
					<option value="Y">是</option>
					<option value="N">否</option>
				</select>
			</TD>
		</TR>		
        <TR>
	        <TD align="right" class="TableHeading" width="80">部門：</TD>
			<TD colspan=3 width="260">
				<select size="1" name="selDEPT" id="selDEPT">
					<option value=""></option>
					<option value="CSC">CSC</option>
					<option value="NB">NB</option>
					<option value="PA">PA</option>
					<option value="FIN">FIN</option>
					<option value="ACCT">ACCT</option>	
					<option value="CLM">CLM</option>
<!-- RC0036 -->		<option value="PCD">PCD</option>
<!-- RC0036 -->		<option value="TYB">TYB</option>
<!-- RC0036 -->		<option value="TCB">TCB</option>
<!-- RC0036 -->		<option value="TNB">TNB</option>	
<!-- RC0036 -->		<option value="KHB">KHB</option>							
				</select>
			</TD>
			<!--R60550-->
			<TD align="right" class="TableHeading" width="80">付款方式：</TD>
			<TD colspan=3 width="130">
				<select size="1" name="selPMETHOD" id="selPMETHOD">
					<option value=""></option>
					<option value="A">支票</option>
					<option value="B">匯款</option>
					<option value="C">信用卡</option>
					<option value="D">外幣匯款</option>
					<option value="E">現金</option>
				</select>
			</TD>
	        <TD align="right" class="TableHeading" width="80">輸入者：</TD>
			<TD colspan=3 width="130"><INPUT size="10" name="txtEntryUsr" id="txtEntryUsr"></TD>
	        <TD align="right" class="TableHeading" width="80">保單幣別：</TD>
			<TD colspan=3 width="60">
				<select size="1" name="selCurrency" id="selCurrency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
	    </TR>
	</TBODY>
</TABLE>
<BR>
<%	if (alPDetail !=null)
	{//if1
		if(alPDetail.size()>0)
		{//if2
			int icurrentRec = 0;
			int icurrentPage = 0; // 由0開始計
			int iSeqNo = 0;
			for (int i=0; i<itotalpage;i++)
			{
				icurrentPage = i ;
				for (int j = 0 ; j < iPageSize;j++)
				{
					iSeqNo ++;
					icurrentRec = icurrentPage * iPageSize + j ;
					if(icurrentRec < alPDetail.size())
					{
						if( j == 0) // show table head
						{
							if((icurrentPage + 1) == 1)
							{  %>
<div id="showPage<%=(icurrentPage+1)%>" style="display: ">
<%							} else { %>
<div id="showPage<%=(icurrentPage+1)%>" style="display:none">
<%							} %>
	<table>
		<tr>
			<td><a href='javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage+1%>,1)'> &lt;&lt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage+1%>,2)'>&lt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=icurrentPage+2%>,<%=itotalpage%>,<%=icurrentPage+1%>,3)'>&gt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage+1%>,4)'>&gt;&gt;&nbsp;&nbsp;</a></td>
		</tr>
	</table>
	<hr>
	<table border="0" cellPadding="0" cellSpacing="0" width="1030" id="tblDetail">
		<tbody>
			<TR>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">序號</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">勾選</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">保單號碼</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="細明體">要保書號碼</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">受款人ID</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="39"><b><font size="2" face="細明體">幣別</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">支付金額</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="細明體">支付描述</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">付款日期</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="65"><b><font size="2" face="細明體">付款方式</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="細明體">作廢否</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="細明體">急件否</font></b></TD>
				<!--R60550-->
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="39"><b><font size="2" face="細明體">外幣幣別</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;" height="56" width="69"><b><font size="2" face="細明體">外幣金額</font></b></TD>
			</TR>
<%						}
						DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)alPDetail.get(icurrentRec);
						String strPNo = "";
						String strPolNo = "";
						String strAppNo = "";
						String strPName = "";
						String strPId = "";
						double iPAmt = 0;
						String strPdesc = "";
						String strPMethod="";
						String strPMethodDesc = "";
						int iPDate = 0;
						String strPDate ="";
						String strChecked = "";
						String strDisabled = "";
						String strVoidabled="";
						String strPDispatch = "";
						String strVoidabledD="";
						String strPDispatchD = "";
						String strCurrency = "";
						String strPAYCURR = "";//R60550
						double iPAYAMT = 0;//R60550
						String strPsrcCode = "";

						if (objPDetailVO.getStrPNO()!=null)
							strPNo = objPDetailVO.getStrPNO();
						if (strPNo!="")
							strPNo= strPNo.trim();		

						if (objPDetailVO.getStrPolicyNo()!=null)
							strPolNo = objPDetailVO.getStrPolicyNo();
						if (strPolNo!="")
							strPolNo= strPolNo.trim();		

						if (objPDetailVO.getStrAppNo()!=null)
							strAppNo = objPDetailVO.getStrAppNo();
						if (strAppNo!="")
							strAppNo=strAppNo.trim();	

						if (objPDetailVO.getStrPName()!=null)
							strPName = objPDetailVO.getStrPName();
						if (strPName !="")
							strPName = strPName.trim();	

						if (objPDetailVO.getStrPId()!=null)
							strPId = objPDetailVO.getStrPId();
						if (strPId!="")
							strPId = strPId.trim();		         

						if (objPDetailVO.getStrPSrcCode()!=null)
							strPsrcCode = objPDetailVO.getStrPSrcCode();
						if (strPsrcCode!="")
							strPsrcCode = strPsrcCode.trim();

						if (objPDetailVO.getStrPDesc()!=null)
							strPdesc = strPsrcCode + objPDetailVO.getStrPDesc();
						if (strPdesc!="")
							strPdesc = strPdesc.trim();

						if (objPDetailVO.getStrPCurr()!=null)
							strCurrency = objPDetailVO.getStrPCurr();
						if (strCurrency!="")
							strCurrency = strCurrency.trim();

						if (objPDetailVO.getStrPMethod()!=null)
							strPMethod = objPDetailVO.getStrPMethod();
						if(strPMethod!="")
						{
							strPMethod = strPMethod.trim();
							if (strPMethod.equals("A"))
								strPMethodDesc = "支票";
							if (strPMethod.equals("B"))
								strPMethodDesc = "匯款";
							if (strPMethod.equals("C"))
								strPMethodDesc = "信用卡";
							if (strPMethod.equals("D"))
								strPMethodDesc = "外幣匯款";//R60550
							if (strPMethod.equals("E"))
								strPMethodDesc = "現金";
						}

						if (objPDetailVO.getStrPDispatch()!=null)
							strPDispatch = objPDetailVO.getStrPDispatch();
						if(strPDispatch!="")
						{
							strPDispatch = strPDispatch.trim();
							if (strPDispatch.equals("Y"))
								strPDispatchD ="是";
							else
								strPDispatchD = "否";
						}

						if (objPDetailVO.getStrPVoidable()!=null)
							strVoidabled = objPDetailVO.getStrPVoidable();
						if(strVoidabled!="")
						{
							strVoidabled = strVoidabled.trim();
							if (strVoidabled.equals("Y"))
								strVoidabledD ="是";
							else
								strVoidabledD = "否";
						}
						if (objPDetailVO.isChecked())
						{
							strChecked = "checked";
						}
						if (objPDetailVO.isDisabled())
						{
							strDisabled = "disabled";
						}

						iPAmt = objPDetailVO.getIPAMT();
						iPDate = objPDetailVO.getIPDate();
						if(iPDate == 0)
							strPDate = "";
						else {
							strPDate = Integer.toString(iPDate);
							strPDate = (new CommonUtil()).checkDateFomat(strPDate);
						}

						//R60550外幣幣別.金額
						if (objPDetailVO.getStrPPAYCURR()!=null)
							strPAYCURR = objPDetailVO.getStrPPAYCURR();
						if(strCurrency!="")
							strPAYCURR = strPAYCURR.trim();
						iPAYAMT = objPDetailVO.getIPPAYAMT();
%>
			<TR id=data>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><%=icurrentRec+1%></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25">
					<INPUT type="checkbox" name="ch<%=icurrentRec%>" id="ch<%=icurrentRec%>" value="Y" <%=strChecked%> <%=strDisabled%>> 
					<INPUT type="hidden" name="txtPNo<%=icurrentRec%>" id="txtPNo<%=icurrentRec%>" value="<%=strPNo%>">
				</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><%=strPolNo%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="92"><%=strAppNo%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strPName%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strPId%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="39"><%=strCurrency%>&nbsp; <INPUT name="txtCurrency<%=icurrentRec%>" id="txtCurrency<%=icurrentRec%>" type="hidden" value="<%=strCurrency%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="69"><%=df.format(iPAmt)%>&nbsp; <INPUT name="txtPAMT<%=icurrentRec%>" id="txtPAMT<%=icurrentRec%>" type="hidden" value="<%=iPAmt%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="92"><%=strPdesc%>&nbsp; <INPUT type="hidden" id="txtPsrccode<%=icurrentRec%>" name="txtPsrccode<%=icurrentRec%>" value="<%=strPsrcCode%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><%=strPDate%>&nbsp; <INPUT name="txtPDATE<%=icurrentRec%>" id="txtPDATE<%=icurrentRec%>" type="hidden" value="<%=iPDate%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="65"><%=strPMethodDesc%>&nbsp; <INPUT name="txtPMethod<%=icurrentRec%>" id="txtPMethod<%=icurrentRec%>" type="hidden" value="<%=strPMethod%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; height="35" width="53"><%=strVoidabledD%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; height="35" width="53"><%=strPDispatchD%>&nbsp; <INPUT type="hidden" id="txtDispatch<%=icurrentRec%>" name="txtDispatch<%=icurrentRec%>" value="<%=strPDispatch%>"></TD>
				<!--R60550-->
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="39"><%=strPAYCURR%>&nbsp; <INPUT name="txtCurrency<%=icurrentRec%>" id="txtCurrency<%=icurrentRec%>" type="hidden" value="<%=strPAYCURR%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;" height="35" width="69"><%=df2.format(iPAYAMT)%>&nbsp; <INPUT name="txtPAYAMT<%=icurrentRec%>" id="txtPAYAMT<%=icurrentRec%>" type="hidden" value="<%=iPAYAMT%>"></TD>
			</TR>
<%						if((iSeqNo == iPageSize) || (icurrentRec == (alPDetail.size()-1) ) || (iSeqNo%iPageSize == 0) ) { %>
		</tbody>
	</table>
</div>		
<%						}
					} // end of if --> inowRec < alPDetail.size()
				}// end of for -- show detail
			}//end of for
%>
<input name="allbox" type="checkbox" onClick="CheckAll();"> 總頁數 : <%=itotalpage%> &nbsp;&nbsp;總件數 : <%=itotalCount%> &nbsp;&nbsp;&nbsp;&nbsp;總金額:<%=df.format(iSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp;外幣美元保單總金額:<%=df.format(iUSSumAmt)%>
<BR>
AU保單總金額：<%=df.format(iAUSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp; EU保單總金額：<%=df.format(iEUSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp; HK保單總金額：<%=df.format(iHKSumAmt)%>
<BR>
JP保單總金額：<%=df.format(iJPSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp; NZ保單總金額：<%=df.format(iNZSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp; CN保單總金額：<%=df.format(iCNSumAmt)%>
<%		} //end of if2
	}//end of if1
	else
	{ %>
<table border="0" cellPadding="0" cellSpacing="0" width="1030" id="tblDetail">
	<tbody>
		<TR>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">序號</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">勾選</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">保單號碼</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="細明體">要保書號碼</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">受款人ID</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">支付金額</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><b><font size="2" face="細明體">支付描述</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">付款日期</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><b><font size="2" face="細明體">付款方式</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="細明體">作廢否</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="細明體">急件否</font></b></TD>
			<!--R60550-->
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">外幣幣別</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">外幣金額</font></b></TD>
		</TR>
	</tbody>
</table>
<%}%>
		
<INPUT type="hidden" id="txtTpage" name="txtTpage"  value="<%=itotalpage%>">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtPDateHold" name="txtPDateHold" value="<%=strPDateHold%>">
<INPUT type="hidden" id="txtEEDateHold" name="txtEEDateHold" value="<%=strEEDateHold%>">
</form>
</BODY>
</HTML>