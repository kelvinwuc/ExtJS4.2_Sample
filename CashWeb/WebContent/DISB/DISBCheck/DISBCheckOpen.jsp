<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBCheckControlInfoVO"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * Function : 出納功能-票據開立
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.7 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2013/12/24 03:40:20 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckOpen.jsp,v $
 * Revision 1.7  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.6  2012/08/29 02:57:57  ODCKain
 * Calendar problem
 *
 * Revision 1.5  2011/07/14 11:34:05  MISSALLY
 * Q10183
 * 票據開立時若遇到要換票據批號時需人工勾選, 修正為系統自動作業
 *
 * Revision 1.4  2010/11/23 02:17:05  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.2  2008/08/18 06:15:28  MISODIN
 * R80338 調整銀行帳號選單的預設值
 *
 * Revision 1.1  2006/06/29 09:40:45  MISangel
 * Init Project
 *
 * Revision 1.1.2.9  2005/04/04 07:02:23  miselsa
 * R30530 支付系統
 *  
 */
%><%!
String strThisProgId = "DISBCheckOpen"; //本程式代號
DecimalFormat df = new DecimalFormat("#.00");
%><%
SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", Locale.TAIWAN);
SimpleDateFormat sdfDate = new SimpleDateFormat("yyyyMMdd", Locale.TAIWAN);
SimpleDateFormat sdfTime = new SimpleDateFormat("hhmmss", Locale.TAIWAN);

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();

//付款帳號
List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") == null) {
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList", alPBBank);
} else {
	alPBBank = (List) session.getAttribute("PBBankList");
}
Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbPBBank = new StringBuffer();
if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		htTemp = (Hashtable) alPBBank.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		if(strValue.equalsIgnoreCase("8220635/635300021303"))	//8220635/635300021303-中信銀復興
			sbPBBank.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbPBBank.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
} else {
	sbPBBank.append("<option value=\"\">&nbsp;</option>");
}

List alPDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
double iSumAmt = 0; //總金額
if (session.getAttribute("PDetailList") != null) {
	alPDetail = (List) session.getAttribute("PDetailList");

	if (alPDetail != null) {
		if (alPDetail.size() > 0) {
			for (int k = 0; k < alPDetail.size(); k++) {
				DISBPaymentDetailVO objPDetailCounter = (DISBPaymentDetailVO) alPDetail.get(k);
				iSumAmt = iSumAmt + objPDetailCounter.getIPAMT();
			}
			itotalCount = alPDetail.size();
		}

		if (itotalCount % iPageSize == 0) {
			itotalpage = itotalCount / iPageSize;
		} else {
			itotalpage = itotalCount / iPageSize + 1;
		}
	}
}
session.removeAttribute("PDetailList");

List alCControl = new ArrayList();
if (session.getAttribute("CheckControlList") != null) {
	alCControl = (List) session.getAttribute("CheckControlList");
}
session.removeAttribute("CheckControlList");

String strCBNoOld = "";
String strCSNoOld = "";
String strEmptyCheckCount = "";
int iEmptyCheckCount = 0;
DISBCheckControlInfoVO objCControlVO = null;
for(Iterator it=alCControl.iterator(); it.hasNext();) {
	objCControlVO = (DISBCheckControlInfoVO) it.next();
	strCBNoOld += "/" + CommonUtil.AllTrim(objCControlVO.getStrCBNo());
	strCSNoOld += "/" + CommonUtil.AllTrim(objCControlVO.getStrCSNo());

	if (objCControlVO.getIEmptyCheck() > 0) {
		strEmptyCheckCount += "/" + Integer.toString(objCControlVO.getIEmptyCheck());
		iEmptyCheckCount += objCControlVO.getIEmptyCheck();
	}
}
strCBNoOld = (strCBNoOld.length()>0)?strCBNoOld.substring(1):"";
strCSNoOld = (strCSNoOld.length()>0)?strCSNoOld.substring(1):"";
strEmptyCheckCount = (strEmptyCheckCount.length()>0)?strEmptyCheckCount.substring(1):"";

String strAction = "";
if (request.getAttribute("txtAction") != null) {
	strAction = (String) request.getAttribute("txtAction");
}

String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
	strReturnMessage = (String) request.getAttribute("txtMsg");
}

String para_Cheque = "";
if (request.getAttribute("para_Cheque") != null) {
	para_Cheque = (String) request.getAttribute("para_Cheque");
}
String para_rePrtFlag = "";
if (request.getAttribute("para_rePrtFlag") != null) {
	para_rePrtFlag = (String) request.getAttribute("para_rePrtFlag");
}
String PBBank = "";
if (request.getAttribute("PBBank") != null) {
	PBBank = (String) request.getAttribute("PBBank");
}
String PBAccount = "";
if (request.getAttribute("PBAccount") != null) {
	PBAccount = (String) request.getAttribute("PBAccount");
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>支票功能--票據開立作業</TITLE>
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
// *************************************************************
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
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckOpen.jsp";
	}

	if(document.getElementById("txtAction").value == "")
	{
		WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' );
		document.getElementById("inquiryArea").style.display = "block";
	}
	else
	{
		if(document.getElementById("txtAction").value == "CheckReport")
		{
			var strSql = "SELECT * from CAPCHKF WHERE 1=1 AND CHEQUE_STATUS ='D' ";
			strSql += "AND CHEQUE_NO IN (" + document.getElementById("para_Cheque").value + ") ";
			strSql += "order by CHEQUE_NO ";

			document.getElementById("inquiryArea").style.display = "block";
			WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' );
			document.getElementById("ReportSQL").value = strSql;
			document.getElementById("frmMain").action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";
			document.getElementById("frmMain").target="_blank";
			document.getElementById("frmMain").submit();
		}
		else
		{
			WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyCheck,'' );
			document.getElementById("inquiryArea").style.display = "none";
		}

		var PBBankValue = document.getElementById("OPBBank").value + "/" + document.getElementById("OPBAccount").value;
		for(var i=0;i< document.getElementById("selPBBank").options.length;i++)
		{
			if( PBBankValue== document.getElementById("selPBBank").options.item(i).value )
			{
				document.getElementById("selPBBank").options.item(i).selected = true;
				break;
			}
		}
	}

	window.status = "";
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
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckOpen.jsp";
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
	document.getElementById("frmMain").target="_self";
	document.getElementById("frmMain").action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckOpenServlet";
	document.getElementById("txtAction").value = "I";
	document.getElementById("frmMain").submit();
}

/*
函數名稱:	DISBCheckOpenAction()
函數功能:	當toolbar frame 中之[票據開立]按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值  :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function DISBCheckOpenAction()
{
	if(isValidCheckCount())
	{
		var strConfirmMsg = "是否確定執行票據開立作業?\n";
		var bConfirm = window.confirm(strConfirmMsg);
		if( bConfirm )
		{
			enableAll();
			document.getElementById("txtAction").value = "DISBCheckOpen";
			mapValue();
			document.getElementById("frmMain").submit();
		}
	}
}

/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值  :	無
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
	document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value);
	document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value);

	var BankAccount = document.getElementById("selPBBank").value;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);
	}
}

/*
 * 判斷勾選數目和可用張數是否符合 2004/12/03  Elsa
 */
function isValidCheckCount()
{
	var iflag=0;
	var strTmpMsg = "";
	var bReturnStatus = true;
	for (i=0;i< iTotalrec;i++ )
	{
		var checkId = "ch" + i;
		if(document.getElementById(checkId).checked)
		{
			iflag ++;
			bReturnStatus = true;
		}
	}
	if(iflag==0)
	{
		strTmpMsg ="至少要勾選一筆項目";
		bReturnStatus = false;
	}
	else
	{
		var iCheckCount =  document.getElementById("txtOCount").value;
		if(iflag > iCheckCount)
		{
			strTmpMsg ="勾選數目(" +  iflag + ")不得大於可用張數( " + iCheckCount+ ")";
			bReturnStatus=false;
		}
	}
	if( !bReturnStatus )
	{
		alert( strTmpMsg );
	}
	return bReturnStatus;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckOpenServlet" id="frmMain" name="frmMain" method="post">

<INPUT type="hidden" name="txtUPinquiryAreaDate" id="txtUPDate" value="">
<TABLE border="1" width="468" id="inquiryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="131">付款帳號：</TD>
			<TD width="329">
				<select size="1" name="selPBBank" id="selPBBank">
					<%=sbPBBank.toString()%>
				</select>
				<INPUT type="hidden" id="txtPBBank" name="txtPBBank" value=""> 
				<INPUT type="hidden" id="txtPBAccount" name="txtPBAccount" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="131">支付確認起始日：</TD>
			<TD width="329"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtPStartDateC" name="txtPStartDateC" value=""
				readOnly onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> <INPUT
				type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> ~ <INPUT
				class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC"
				name="txtPEndDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> <INPUT
				type="hidden" name="txtPEndDate" id="txtPEndDate" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="131">急件否：</TD>
			<TD valign="middle" width="329">
				<select size="1" name="selDispatch" id="selDispatch">
					<option value=""></option>
					<option value="Y">是</option>
					<option value="N">否</option>
				</select>
			</TD>
		</TR>
	</TBODY>
</TABLE>
<BR>

<%if (alPDetail != null) 
{ //if1
	if (alPDetail.size() > 0) 
	{ //if2
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
						if ((icurrentPage + 1) == 1) {%><div id=showPage <%=icurrentPage + 1%> style="display: "><%} else {%><div id=showPage <%=icurrentPage + 1%> style="display: none"><%}%>
<TABLE>
	<TR>
		<TD><a href='javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage + 1%>,1)'>&lt;&lt;&nbsp;&nbsp;</a></TD>
		<TD><a href='javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage + 1%>,2)'>&lt;&nbsp;&nbsp;</a></TD>
		<TD><a href='javascript:ChangePage(<%=icurrentPage + 2%>,<%=itotalpage%>,<%=icurrentPage + 1%>,3)'>&gt;&nbsp;&nbsp;</a></TD>
		<TD><a href='javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage + 1%>,4)'>&gt;&gt;&nbsp;&nbsp;</a></TD>
	</TR>
</TABLE>
<HR>
<TABLE>
	<TR>
		<TD>票據批號:</TD>
		<TD><%=strCBNoOld%></TD>
	</TR>
	<TR>
		<TD>支票起始號:</TD>
		<TD><%=strCSNoOld%></TD>
	</TR>
	<TR>
		<TD>可用張數:</TD>
		<TD><%=strEmptyCheckCount%></TD>
	</TR>
</TABLE>

<TABLE border="0" cellPadding="0" cellSpacing="0" width="816" id="tblDetail">
	<TBODY>
		<TR>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">序號</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">勾選</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">保單號碼</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="細明體">要保書號碼</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">受款人ID</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">支付金額</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><font size="2" face="細明體"><b>支付描述</b></font></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">付款日期</font></b></TD>
			<TD bgColor="#c0c0c0" style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="56" width="53"><font size="2" face="細明體"><b>急件否</b></font></TD>
		</TR>
<%					}
					DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(icurrentRec);
					String strPNo = "";
					String strPolNo = "";
					String strAppNo = "";
					String strPName = "";
					String strPId = "";
					double iPAmt = 0;
					String strPdesc = "";
					String strPMethod = "";
					String strPMethodDesc = "";
					int iPDate = 0;
					String strPDate = "";
					String strPDispatch = "";
					String strPDispatchD = "";

					if (objPDetailVO.getStrPNO() != null)
						strPNo = objPDetailVO.getStrPNO();
					if (strPNo != "")
						strPNo = CommonUtil.AllTrim(strPNo);

					if (objPDetailVO.getStrPolicyNo() != null)
						strPolNo = objPDetailVO.getStrPolicyNo();
					if (strPolNo != "")
						strPolNo = CommonUtil.AllTrim(strPolNo);

					if (objPDetailVO.getStrAppNo() != null)
						strAppNo = objPDetailVO.getStrAppNo();
					if (strAppNo != "")
						strAppNo = CommonUtil.AllTrim(strAppNo);

					if (objPDetailVO.getStrPName() != null)
						strPName = objPDetailVO.getStrPName();
					if (strPName != "")
						strPName = CommonUtil.AllTrim(strPName);

					if (objPDetailVO.getStrPId() != null)
						strPId = objPDetailVO.getStrPId();
					if (strPId != "")
						strPId = CommonUtil.AllTrim(strPId);

					if (objPDetailVO.getStrPDesc() != null)
						strPdesc = objPDetailVO.getStrPDesc();
					if (strPdesc != "")
						strPdesc = CommonUtil.AllTrim(strPdesc);

					if (objPDetailVO.getStrPDispatch() != null)
						strPDispatch = objPDetailVO.getStrPDispatch();
					if (strPDispatch != "") {
						strPDispatch = CommonUtil.AllTrim(strPDispatch);
						if (strPDispatch.equals("Y"))
							strPDispatchD = "是";
						else
							strPDispatchD = "否";
					}

					iPAmt = objPDetailVO.getIPAMT();
					iPDate = objPDetailVO.getIPDate();
					if (iPDate == 0)
						strPDate = "";
					else
						strPDate = Integer.toString(iPDate);
%>
		<TR id=data>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><span onclick="seqClicked('<%=strPNo%>')" style="cursor: hand"><%=icurrentRec + 1%></span></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><INPUT type="checkbox" name="ch<%=icurrentRec%>" id="ch<%=icurrentRec%>" value="Y" checked><INPUT name="txtPNo<%=icurrentRec%>" id="txtPNo<%=icurrentRec%>" type="hidden" value="<%=strPNo%>"></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><%=strPolNo%>&nbsp;</TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="92"><%=strAppNo%>&nbsp;</TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strPName%>&nbsp;</TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strPId%>&nbsp;</TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="69"><%=df.format(iPAmt)%>&nbsp; <INPUT name="txtPAMT<%=icurrentRec%>" id="txtPAMT<%=icurrentRec%>" type="hidden" value="<%=iPAmt%>"></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="67"><%=strPdesc%>&nbsp;</TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><%=strPDate%>&nbsp;</TD>
			<TD style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="35" width="53"><%=strPDispatchD%>&nbsp;</TD>
		</TR>
<%					if ((iSeqNo == iPageSize) || (icurrentRec == (alPDetail.size() - 1)) || (iSeqNo % iPageSize == 0)) {%>
	</TBODY>
</TABLE>
</div>
<%					}
				} // end of if --> inowRec < alPDetail.size()
			} // end of for -- show detail      
		} //end of for%>
<input name="allbox" type="checkbox" onClick="CheckAll();" checked> 總頁數 : <%=itotalpage%> &nbsp;&nbsp;總件數 : <%=itotalCount%> &nbsp;&nbsp;&nbsp;&nbsp;總金額:<%=df.format(iSumAmt)%> 
<%	} //end of if2 
} //end of if1
else 
{%>
<TABLE border="0" cellPadding="0" cellSpacing="0" width="816" id="tblDetail">
	<TBODY>
		<TR>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">序號</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">勾選</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">保單號碼</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="細明體">要保書號碼</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">受款人ID</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">支付金額</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><font size="2" face="細明體"><b>支付描述</b></font></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">付款日期</font></b></TD>
			<TD bgColor="#c0c0c0" style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="56" width="53"><font size="2" face="細明體"><b>急件否</b></font></TD>
		</TR>
	</TBODY>
</TABLE>
<%}%> 
<INPUT type="hidden" id="txtOCBNo" name="txtOCBNo" value="<%=strCBNoOld%>"> 
<INPUT type="hidden" id="txtOCSNo" name="txtOCSNo" value="<%=strCSNoOld%>"> 
<INPUT type="hidden" id="txtOCount" name="txtOCount" value="<%=iEmptyCheckCount%>"> 
<INPUT type="hidden" id="txtPNo" name="txtPNo" value=""> 
<INPUT type="hidden" id="txtTpage" name="txtTpage" value="<%=itotalpage%>"> 
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="para_Cheque" name="para_Cheque" value="<%=para_Cheque%>"> 
<INPUT type="hidden" id="para_rePrtFlag" name="para_rePrtFlag" value="<%=para_rePrtFlag%>"> 
<INPUT type="hidden" id="ReportName" name="ReportName" value="ChequeRpt.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="TXT"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="ChequeRpt.rpt"> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
<INPUT type="hidden" id="OPBBank" name="OPBBank" value="<%=PBBank%>"> 
<INPUT type="hidden" id="OPBAccount" name="OPBAccount" value="<%=PBAccount%>">
<IFRAME id="outputFrame" name="outputFrame" height="0" width="0"></IFRAME>
</FORM>
</BODY>
</HTML>
