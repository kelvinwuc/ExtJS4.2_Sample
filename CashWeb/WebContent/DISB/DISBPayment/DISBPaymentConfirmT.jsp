<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.math.BigDecimal" %>
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
 * Revision : $Revision: 1.8 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2014/07/18 07:28:01 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPaymentConfirmT.jsp,v $
 * Revision 1.8  2014/07/18 07:28:01  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.7  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.6  2013/01/09 02:51:05  MISSALLY
 * Calendar problem
 *
 * Revision 1.5  2013/01/08 04:25:58  MISSALLY
 * 將分支的程式Merge至HEAD
 *
 * Revision 1.2.4.1  2012/12/06 06:28:23  MISSALLY
 * RA0102　PA0041
 * 配合法令修改酬佣支付作業
 *
 * Revision 1.2  2010/11/23 02:24:10  MISJIMMY
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
GlobalEnviron globalEnviron =(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";

//付款日期
String strPDateHold = (request.getAttribute("txtPDateHold") != null)?(String) request.getAttribute("txtPDateHold"):"";
//輸入日期迄日  
String strEEDateHold = (request.getAttribute("txtEEDateHold") != null)?(String) request.getAttribute("txtEEDateHold"):"";

List alPSrcGrp = new ArrayList();
if (session.getAttribute("SrcGpList") == null) {
	alPSrcGrp = (List) disbBean.getETable("SRCGP", "");
	session.setAttribute("SrcGpList",alPSrcGrp);
} else {
	alPSrcGrp =(List) session.getAttribute("SrcGpList");
}
List alCurrCash = new ArrayList(); //R80132 幣別挑選
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}

List alPDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;

if (session.getAttribute("PDetailList") != null) {
	alPDetail = (List)session.getAttribute("PDetailList");
}

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
function WindowOnload()
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBPayment/DISBPaymentConfirm.jsp";
	}

	if (document.getElementById("txtAction").value == "I")
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyConfirm,'' );
	}
	else
	{
		WindowOnLoadCommon( document.title+"(查詢)" , '' , strFunctionKeyInquiry1,'' );
	}
}

function inquiryAction()
{
	WindowOnLoadCommon( document.title+"(查詢)" , '' , strFunctionKeyInquiry1,'' );
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

	if(getCheckData()) {
		if( areAllFieldsOK() )
		{
			document.getElementById("frmMain").submit();
		}
		else
			alert( strErrMsg );
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

function mapValue()
{
	document.getElementById("txtPDate").value = rocDate2String(document.getElementById("txtPDateC").value) ;
	document.getElementById("txtEntryStartDate").value = rocDate2String(document.getElementById("txtEntryStartDateC").value) ;	    	 
   	document.getElementById("txtEntryEndDate").value = rocDate2String(document.getElementById("txtEntryEndDateC").value) ;	
}

function getCheckData()
{
	iAMTA = 0 ;
	iCountA = 0;
	iUSAMTA = 0 ;
	iUSCountA = 0;
	iAMTB = 0 ;
	iCountB= 0;
	iUSAMTB = 0 ;
	iUSCountB= 0;
	iAMTC = 0 ;
	iCountC= 0;
	iUSAMTC = 0 ;
	iUSCountC= 0;
	iAMTD = 0 ;//R60550
	iCountD= 0;//R60550
	iAMTE = 0 ;//RB0302
	iCountE= 0;//RB0302

	var varMsg = "";
	var errCounter = 0;
	for (var i=0;i< iTotalrec;i++ )
	{
		var checkId = "ch" + i ;
		if(document.getElementById(checkId).checked)
		{
			if(document.getElementById("txtPMethod"+i).value == "A")
			{
				if (document.getElementById("txtCurrency"+i).value == "US")
				{
					iUSCountA ++;
					iUSAMTA = iUSAMTA + parseFloat(document.getElementById("txtPAMT"+i).value);
				} 
				else
				{
					iCountA ++;
					iAMTA = iAMTA + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
			}
			else if(document.getElementById("txtPMethod"+i).value == "B")
			{
				if (document.getElementById("txtCurrency"+i).value == "US")
				{
					iUSCountB ++;
					iUSAMTB = iUSAMTB + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
				else
				{
					iCountB ++;
					iAMTB = iAMTB + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
			}
			else  if(document.getElementById("txtPMethod"+i).value == "C")
			{
				if (document.getElementById("txtCurrency"+i).value == "US")
				{
					iUSCountC ++;
					iUSAMTC = iUSAMTC + parseFloat(document.getElementById("txtPAMT"+i).value);
				} 
				else
				{
					iCountC ++;
					iAMTC = iAMTC + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
			}
			else  if(document.getElementById("txtPMethod"+i).value == "D")
			{
				iCountD ++;
				iAMTD = iAMTD + parseFloat(document.getElementById("txtPAMT"+i).value);
			//RB0302
			} else if (document.getElementById("txtPMethod" + i).value == "E") {
				iCountE++;
				iAMTE = iAMTE + parseFloat(document.getElementById("txtPAMT" + i).value);
			}

			//PA0024 - 增加檢核支付代碼不得為空白
			if(errCounter <= 10) {
				if(document.getElementById("txtPsrccode" + i).value == "") {
					varMsg += "序號"+(i+1)+" 支付代碼為空白\r\n";
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

function CheckAll()
{
	for (var i=0;i<document.frmMain.elements.length;i++)
	{
		var e = document.frmMain.elements[i];
		if (e.name != 'allbox')
			e.checked = !e.checked;
	}
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnload();">
<form method="post" id="frmMain" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpayment.DISBPConfirmServlet">
<TABLE border="1" width="1030">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="80">輸入日期：</TD>
			<TD colspan=3 width="320"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> <INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate"
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
				</a> <INPUT type="hidden" name="txtPDate" id="txtPDate" value="">
			</TD>
           	<TD align="right" class="TableHeading" width="80">來源群組：</TD>
			<TD colspan=3 width="130">
				<select size="1" name="selPSrcGp" id="selPSrcGp">
					<%=sbPSrcGrp.toString()%>
				</select>
			</TD>
	        <TD align="right" class="TableHeading" width="60">急件：</TD>
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
	        <TD align="right" class="TableHeading" width="60">保單幣別：</TD>
			<TD colspan=3 width="60">
				<select size="1" name="selCurrency" id="selCurrency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
	    </TR>
	</TBODY>
</TABLE>

<BR>
<% if (alPDetail !=null) {
	if(alPDetail.size()>0) { %>
<hr>
<table border="0" cellPadding="0" cellSpacing="0" width="70%" id="tblDetail" align="center">
	<tbody>
		<TR>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" width="50"><b><font size="2" face="細明體">序號</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" width="100"><b><font size="2" face="細明體">輸入者</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" width="100"><b><font size="2" face="細明體">總筆數</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" width="150"><b><font size="2" face="細明體">金額總數</font></b></TD>
		</TR>
<%	}
	BigDecimal strIPamt = null;
	String strEntryUser = "" ; 
	String strEntryStartDate = "" ;
	String strEntryEndDate = "" ; 
	String strPDate = "" ; 
	String strDispatch = "" ;
	String strPSrcGp = "" ;
	String strDept = "" ;
	String strEntryUsr = "" ;
	String strCurrency = "" ;
	String strPMETHOD = "" ;
	String strPsrccode = "";

	for (int icurrentRec = 0 ; icurrentRec < alPDetail.size() ; icurrentRec++){
		DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)alPDetail.get(icurrentRec);
		int rowcount = 0 ;
		strIPamt = new BigDecimal("0");
		strEntryUser = "" ; 
		strEntryStartDate = "" ;
		strEntryEndDate = "" ; 
		strPDate = "" ; 
		strDispatch = "" ;
		strPSrcGp = "" ;
		strDept = "" ;
		strEntryUsr = "" ;
		strCurrency = "" ;
		strPMETHOD = "" ;

		rowcount = objPDetailVO.getRowCount();

		strIPamt = objPDetailVO.getTPAMT();

		if (objPDetailVO.getStrEntryUsr()!=null)
			strEntryUser = objPDetailVO.getStrEntryUsr().trim();

		if (objPDetailVO.getEntryStartDate()!=null)
			strEntryStartDate = objPDetailVO.getEntryStartDate().trim();

		if (objPDetailVO.getEntryEndDate()!=null)
			strEntryEndDate = objPDetailVO.getEntryEndDate().trim();

		if (objPDetailVO.getStrPDate()!=null)
			strPDate = objPDetailVO.getStrPDate().trim();

		if (objPDetailVO.getStrDispatch()!=null)
			strDispatch = objPDetailVO.getStrDispatch().trim();

		if (objPDetailVO.getSelPSrcGp()!=null)
			strPSrcGp = objPDetailVO.getSelPSrcGp().trim();

		if (objPDetailVO.getStrDept()!=null)
			strDept = objPDetailVO.getStrDept().trim();

		if (objPDetailVO.getStrCurrency()!=null)
			strCurrency = objPDetailVO.getStrCurrency().trim();

		if (objPDetailVO.getStrPMETHOD()!=null)
			strPMETHOD = objPDetailVO.getStrPMETHOD().trim();

		if (objPDetailVO.getStrPSrcCode()!=null)
			strPsrccode = objPDetailVO.getStrPSrcCode().trim();
%>
		<TR>
			<TD>
				<a target="_blank" href="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpayment.DISBPConfirmServlet?txtAction=I&txtEntryStartDate=<%=strEntryStartDate%>&txtEntryEndDate=<%=strEntryEndDate%>&txtPDate=<%=strPDate%>&selDispatch=<%=strDispatch%>&selPSrcGp=<%=strPSrcGp%>&selDEPT=<%=strDept%>&txtEntryUsr=<%=strEntryUser%>&selCurrency=<%=strCurrency%>&selPMETHOD=<%=strPMETHOD%>&FNP=Y">
				<%=icurrentRec+1%>
				</a>
				<INPUT type="hidden" id="txtCurrency<%=icurrentRec%>" name="txtCurrency<%=icurrentRec%>" value="<%=strCurrency%>">
				<INPUT type="hidden" id="txtPsrccode<%=icurrentRec%>" name="txtPsrccode<%=icurrentRec%>" value="<%=strPsrccode%>">
				<INPUT type="hidden" id="txtDispatch<%=icurrentRec%>" name="txtDispatch<%=icurrentRec%>" value="<%=strDispatch%>">
			</TD>
			<TD><%=strEntryUser%></TD>
			<TD><%=rowcount%></TD>
			<TD><%=strIPamt%></TD>
		</TR>
<%	}
}%>
	</tbody>
</table>	
<INPUT type="hidden" id="txtAction" name="txtAction"  value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtPDateHold" name="txtPDateHold" value="<%=strPDateHold%>">
<INPUT type="hidden" id="txtEEDateHold" name="txtEEDateHold" value="<%=strEEDateHold%>">
</form>
</BODY>
</HTML>