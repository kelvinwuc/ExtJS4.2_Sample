<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ page import="org.apache.regexp.RE" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : 
 * 
 * Function : 整批確認
 * 
 * Remark   : 支付來源
 * 
 * Revision : $Revision: 1.11 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2013/12/18 07:22:52 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPSourceConfirm.jsp,v $
 * Revision 1.11  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.10  2013/03/29 09:55:05  MISSALLY
 * RB0062 PA0047 - 新增指定銀行 彰化銀行
 *
 * Revision 1.9  2013/01/09 02:54:25  MISSALLY
 * Calendar problem
 *
 * Revision 1.8  2013/01/08 04:25:56  MISSALLY
 * 將分支的程式Merge至HEAD
 *
 * Revision 1.6.4.1  2012/12/06 06:28:29  MISSALLY
 * RA0102　PA0041
 * 配合法令修改酬佣支付作業
 *
 * Revision 1.6  2011/10/21 10:04:36  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 *
 * Revision 1.4  2009/11/11 06:15:17  missteven
 * R90474 修改CASH功能
 *
 * Revision 1.3  2008/08/06 06:04:56  MISODIN
 * R80132 調整CASH系統for 6種幣別
 *
 * Revision 1.2  2007/03/06 01:53:23  MISVANESSA
 * R70088_SPUL配息
 *
 * Revision 1.1  2006/06/29 09:40:47  MISangel
 * Init Project
 *
 * Revision 1.1.2.14  2006/04/27 09:35:39  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.13  2005/04/04 07:02:24  miselsa
 * R30530 支付系統
 *
 */
%><%!String strThisProgId = "DISBPSourceConfirm"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
RE reSpace = new RE(" ");
DecimalFormat df = new DecimalFormat("#.00");

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();

String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserId")):"";

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alPSrcCode = new ArrayList();
if (session.getAttribute("SrcCdList") == null) {
	alPSrcCode = (List) disbBean.getETable("PAYCD", "", false);
	session.setAttribute("SrcCdList", alPSrcCode);
} else {
	alPSrcCode = (List) session.getAttribute("SrcCdList");
}
StringBuffer sbPSrcCode = new StringBuffer();
sbPSrcCode.append("<option value=\"\">&nbsp;</option>");
if (alPSrcCode.size() > 0) {
	for (int i = 0; i < alPSrcCode.size(); i++) {
		htTemp = (Hashtable) alPSrcCode.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		if( strDesc != null && strDesc.length() > 16 )
			strDesc = reSpace.subst( strDesc.substring( 0, 16 ), "&nbsp;" );
		sbPSrcCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}

List alPDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
double iSumAmt = 0;//總金額_NT
double iUSSumAmt = 0;//總金額_US
if (session.getAttribute("PDetailList") != null) {
	alPDetail = (List) session.getAttribute("PDetailList");

	if (alPDetail != null) {
		if (alPDetail.size() > 0) {
			for (int k = 0; k < alPDetail.size(); k++) {
				DISBPaymentDetailVO objPDetailCounter = (DISBPaymentDetailVO) alPDetail.get(k);
				if (objPDetailCounter.getStrPCurr().trim().equals("US")) {
					iUSSumAmt = iUSSumAmt + objPDetailCounter.getIPAMT();
				} else {
					iSumAmt = iSumAmt + objPDetailCounter.getIPAMT();
				}
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
%>

<HTML>
<HEAD>
<TITLE>支付來源--整批確認</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
var iTotalrec = <%=itotalCount%>;
var iMehodA = 0;
var iAMTA = 0;
var iCountA = 0;
var iUSAMTA = 0;
var iUSCountA = 0;
var iMehodB = 0;
var iAMTB = 0;
var iCountB= 0;
var iUSAMTB = 0;
var iUSCountB= 0;
var iMehodC = 0;
var iAMTC = 0;
var iCountC= 0;
var iUSAMTC = 0;
var iUSCountC= 0;
var iCountE = 0;
var iAMTE = 0;

function WindowOnload()
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	if(document.getElementById("txtAction").value == "I")
	{
		if(iTotalrec > 0)
		{
			WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyConfirm,'' );
     		document.getElementById("iquiryArea").style.display ="none";
		}
	}
	else
	{
		WindowOnLoadCommon( document.title+"(查詢)" , '' , strFunctionKeyInquiry1,'' );
	}
}

function inquiryAction()
{
	document.getElementById("iquiryArea").style.display ="block";
	WindowOnLoadCommon( document.title+"(查詢)" , '' , strFunctionKeyInquiry1,'' );
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
}

function confirmAction()
{
	document.getElementById("txtAction").value = "I";
	mapValue();
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
		if(checkRemitPayment())
		{
			getCheckData();
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
			if(iCountE > 0)
			{
				strConfirmMsg = strConfirmMsg + "現金筆數:" + iCountE + "\n現金件總額:" + iAMTE +"\n";
			}

			var bConfirm = window.confirm(strConfirmMsg);
			if( bConfirm )
			{
				enableAll();
				document.getElementById("txtAction").value = "DISBPSourceConfirm";
				document.getElementById("frmMain").submit();
			}
		}
	}
}

function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBPSource/DISBPSourceConfirm.jsp";
}

function seqClicked(strPNo,currentPage)
{
	document.getElementById("txtPNo").value = strPNo;
	document.getElementById("txtAction").value = "IDetails";
	document.getElementById("currentPage").value = currentPage;
	document.getElementById("frmMain").action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSMaintainServlet";
	document.getElementById("frmMain").submit();
}

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
		if( objThisItem.value != "" && document.getElementById("txtEntryEndDateC").value != "" )
		{
			if (objThisItem.value  > document.getElementById("txtEntryEndDateC").value)
			{
			   	strTmpMsg = "輸入日期的起日不得大於輸入日期的迄日";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.id == "txtEntryEndDateC" )
	{
		if( objThisItem.value != "" && document.getElementById("txtEntryStartDateC").value != "" )
		{
			if (objThisItem.value < document.getElementById("txtEntryStartDateC").value)
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
	document.getElementById("txtPDate").value = rocDate2String(document.getElementById("txtPDateC").value);
	document.getElementById("txtEntryStartDate").value = rocDate2String(document.getElementById("txtEntryStartDateC").value);	    	 
   	document.getElementById("txtEntryEndDate").value = rocDate2String(document.getElementById("txtEntryEndDateC").value);
   	<%if(Integer.parseInt(strUserRight) > 79) { %>
   	document.getElementById("txtEntryUser").value = document.getElementById("txtEntryUser").value.toUpperCase();
   	<%}%>
}

function getCheckData()
{
	iMehodA = 0;
	iAMTA = 0;
	iCountA = 0;
	iUSAMTA = 0;
	iUSCountA = 0;
	iMehodB = 0;
	iAMTB = 0;
	iCountB= 0;
	iUSAMTB = 0;
	iUSCountB= 0;
	iMehodC = 0;
	iAMTC = 0;
	iUSMehodC = 0;
	iUSAMTC = 0;
	iCountC= 0;
	iAMTE = 0;
	iCountE = 0;

	for (var i=0; i<iTotalrec; i++ )
	{
		var checkId = "ch" + i;
		if(document.getElementById(checkId).checked)
		{
			if(document.getElementById("txtPMethod"+i).value == "A")
			{
				if(document.getElementById("txtCurrency"+i).value == "US")
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
			else  if(document.getElementById("txtPMethod"+i).value == "B")
			{
				if(document.getElementById("txtCurrency"+i).value == "US")
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
				if(document.getElementById("txtCurrency"+i).value == "US")
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
			else if(document.getElementById("txtPMethod"+i).value == "E")
			{
				iCountE++;
				iAMTE = iAMTE + parseFloat(document.getElementById("txtPAMT"+i).value);
			}
		}
	}
}

//支付確認檢核
function checkRemitPayment()
{
	var strTmpMsg = "";
	var bReturnStatus = true;
	for(var i=0; i< iTotalrec; i++)
	{
		var checkId = "ch" + i;
		if(document.getElementById(checkId).checked)
		{
			//僅針對付款方式為(台幣/外幣)匯款做檢核
			if(document.getElementById("txtPMethod"+i).value == "B" || document.getElementById("txtPMethod"+i).value == "D") 
			{
				//匯款銀行代號不得小於七碼
				if(document.getElementById("txtPRBank"+i).length < 7) {
					strTmpMsg += "「匯款銀行代號」不得小於七碼!!\n\r";
					bReturnStatus = false;
				}
				//匯款銀行帳號不得為空值
				if(document.getElementById("txtPRAccount"+i).value == "") {
					strTmpMsg += "「匯款銀行帳號」不得為空值!!\n\r";
					bReturnStatus = false;
				}
				//受款人姓名不得為空白
		    	if(document.getElementById("txtPName"+i).value == "") {
					strTmpMsg += "「受款人姓名」不得為空值!!\n\r";
					bReturnStatus = false;
				}
			}
			//PA0024 增加檢核支付原因代碼不得空白
			if(document.getElementById("txtPSRCCode"+i).value == "")
			{
				strTmpMsg += "序號" + (i+1) + "「支付原因代碼」不得為空值!!\n\r";
				bReturnStatus = false;
			}
			//RB0302 現金僅限於台幣急件借款
			if((document.getElementById("txtPMethod"+i).value == "E") &&
				(!(document.getElementById("txtCurrency"+i).value == "NT" && 
					(document.getElementById("txtPSRCCode"+i).value == "E1" || document.getElementById("txtPSRCCode"+i).value == "E2") &&
					document.getElementById("selDispatch"+i).value == "Y")))
			{
				strTmpMsg += "序號" + (i+1) + "必須為急件之保單借款才能以現金支付!!\n\r";
				bReturnStatus = false;
			}
		}
	}

	if(strTmpMsg != "") {
		alert(strTmpMsg);
	}

	return bReturnStatus;
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnload();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSConfirmServlet" id="frmMain" method="post" name="frmMain">
	<TABLE border="1" width="950" id="iquiryArea">
		<TBODY>
			<TR>
				<TD align="right" class="TableHeading" width="80">輸入日期：</TD>
				<TD colspan=3 width="321">
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
					<a href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
					<INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate" value=""> 
					~ 
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryEndDateC" name="txtEntryEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
					<a href="javascript:show_calendar('frmMain.txtEntryEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
					<INPUT type="hidden" name="txtEntryEndDate" id="txtEntryEndDate" value="">
				</TD>
				<TD align="right" class="TableHeading" width="74">付款日期：</TD>
				<TD colspan=3 width="155">
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateC" name="txtPDateC" value="" readOnly onblur="checkClientField(this,true);"> 
					<a href="javascript:show_calendar('frmMain.txtPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
					<INPUT type="hidden" name="txtPDate" id="txtPDate" value="">
				</TD>
				<TD align="right" class="TableHeading" width="93">支付原因：</TD>
				<TD colspan=3 width="50">
					<select size="1" name="selPSrcCode" id="selPSrcCode" class="Data">
						<%= sbPSrcCode.toString() %>
					</select>
				</TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading" width="48">急件：</TD>
				<TD colspan=3 width="40">
					<select size="1" name="selDispatch" id="selDispatch">
						<option value=""></option>
						<option value="Y">是</option>
						<option value="N">否</option>
					</select>
				</TD>
				<TD align="right" class="TableHeading" width="48">幣別：</TD>
				<TD colspan=3 width="40">
					<select size="1" name="selCurrency" id="selCurrency">
						<!-- R80132 外幣保單需輸入 SWIFT CODE 相關資料 , 故不得於支付來源確認時以整批的方式做 -->
						<!-- R80132		<option value=""></option>  -->
						<option value="NT">NT</option>
						<!-- R80132		<option value="US">US</option>   -->
					</select>
				</TD>
<%if(Integer.parseInt(strUserRight) > 79) { %>
				<TD align="right" class="TableHeading" width="93">輸入者代號：</TD>
				<TD colspan=3><input type="text" id="txtEntryUser" name="txtEntryUser" value="" style="text-transform: uppercase;"></TD>
<%} else { %>
				<TD colspan=4></TD>
<%} %>
			</TR>
		</TBODY>
	</TABLE>
	<BR>
<%
if(alPDetail != null) 
{
	if(alPDetail.size() > 0) 
	{
		int icurrentRec = 0;
		int icurrentPage = 0; // 由0開始計
		int iSeqNo = 0;
		for(int i = 0; i < itotalpage; i++) 
		{
			icurrentPage = i;
			for(int j = 0; j < iPageSize; j++) 
			{
				iSeqNo++;
				icurrentRec = icurrentPage * iPageSize + j;
				if(icurrentRec < alPDetail.size()) {
					if (j == 0) // show table head
					{
						if ((icurrentPage + 1) == 1) {
%>
	<div id="showPage<%=icurrentPage + 1%>" style="display: ">
<%						} else { %>
	<div id="showPage<%=icurrentPage + 1%>" style="display: none;">
<%						} %>
	<!-- R90474 -->
	<table>
		<tr>
			<td><a href="javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage + 1%>,1);">&lt;&lt;&nbsp;&nbsp;</a></td>
			<td><a href="javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage + 1%>,2);">&lt;&nbsp;&nbsp;</a></td>
			<td><a href="javascript:ChangePage(<%=icurrentPage + 2%>,<%=itotalpage%>,<%=icurrentPage + 1%>,3);">&gt;&nbsp;&nbsp;</a></td>
			<td><a href="javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage + 1%>,4);">&gt;&gt;&nbsp;&nbsp;</a></td>
		</tr>
	</table>
	<hr>
	<table border="0" cellPadding="0" cellSpacing="0" width="900" id="tblDetail">
		<tbody>
			<TR>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="30"><b><font size="2" face="細明體">序號</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="30"><b><font size="2" face="細明體">勾選</font></b></TD>
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
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="細明體">幣別</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><b><font size="2" face="細明體">單位</font></b></TD>
			</TR>
		</tbody>
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
					String strChecked = "";
					String strDisabled = "";
					String strVoidabled = "";
					String strPDispatch = "";
					String strVoidabledD = "";
					String strPDispatchD = "";
					String strBranch = "";
					String strCurrency = "";
					String strPsrccode = "";

					if (objPDetailVO.getStrPNO() != null)
						strPNo = objPDetailVO.getStrPNO();
					if (strPNo != "")
						strPNo = strPNo.trim();

					if (objPDetailVO.getStrPolicyNo() != null)
						strPolNo = objPDetailVO.getStrPolicyNo();
					if (strPolNo != "")
						strPolNo = strPolNo.trim();

					if (objPDetailVO.getStrAppNo() != null)
						strAppNo = objPDetailVO.getStrAppNo();
					if (strAppNo != "")
						strAppNo = strAppNo.trim();

					if (objPDetailVO.getStrPName() != null)
						strPName = objPDetailVO.getStrPName();
					if (strPName != "")
						strPName = strPName.trim();

					if (objPDetailVO.getStrPId() != null)
						strPId = objPDetailVO.getStrPId();
					if (strPId != "")
						strPId = strPId.trim();

					if (objPDetailVO.getStrPDesc() != null)
						strPdesc = objPDetailVO.getStrPDesc();
					if (strPdesc != "")
						strPdesc = strPdesc.trim();

					if (objPDetailVO.getStrPMethod() != null)
						strPMethod = objPDetailVO.getStrPMethod();
					if (strPMethod != "") {
						strPMethod = strPMethod.trim();
						if (strPMethod.equals("A"))
							strPMethodDesc = "支票";
						if (strPMethod.equals("B"))
							strPMethodDesc = "匯款";
						if (strPMethod.equals("C"))
							strPMethodDesc = "信用卡";
						if (strPMethod.equals("D"))//R70088
							strPMethodDesc = "外幣匯款";
						if (strPMethod.equals("E"))
							strPMethodDesc = "現金";
					}

					if (objPDetailVO.getStrPDispatch() != null)
						strPDispatch = objPDetailVO.getStrPDispatch();
					if (strPDispatch != "") {
						strPDispatch = strPDispatch.trim();
						if (strPDispatch.equals("Y"))
							strPDispatchD = "是";
						else
							strPDispatchD = "否";
					}

					if (objPDetailVO.getStrPVoidable() != null)
						strVoidabled = objPDetailVO.getStrPVoidable();
					if (strVoidabled != "") {
						strVoidabled = strVoidabled.trim();
						if (strVoidabled.equals("Y"))
							strVoidabledD = "是";
						else
							strVoidabledD = "否";
					}
					if (objPDetailVO.isChecked()) {
						strChecked = "checked";
					}
					if (objPDetailVO.isDisabled()) {
						strDisabled = "disabled";
					}

					if (objPDetailVO.getStrBranch() != null)
						strBranch = objPDetailVO.getStrBranch();
					if (strBranch != "")
						strBranch = strBranch.trim();

					if (objPDetailVO.getStrPCurr() != null)
						strCurrency = objPDetailVO.getStrPCurr();
					if (strCurrency != "")
						strCurrency = strCurrency.trim();

					iPAmt = objPDetailVO.getIPAMT();
					iPDate = objPDetailVO.getIPDate();
					if (iPDate == 0)
						strPDate = "";
					else
						strPDate = Integer.toString(iPDate);

					//R10260
					String strPRBank = "";		//匯款銀行
					String strPRAccount = "";	//匯款帳號

					strPRBank = (objPDetailVO.getStrPRBank() != null) ? CommonUtil.AllTrim(objPDetailVO.getStrPRBank()) : "" ;
					strPRAccount = (objPDetailVO.getStrPRAccount() != null) ? CommonUtil.AllTrim(objPDetailVO.getStrPRAccount()) : "" ;
					strPsrccode = (objPDetailVO.getStrPSrcCode() != null) ? CommonUtil.AllTrim(objPDetailVO.getStrPSrcCode()) : "" ;
%>
			<TR id=data>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><span onclick="seqClicked('<%=strPNo%>');" style="cursor: hand; color: blue"><%=icurrentRec + 1%></span></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><INPUT type="checkbox" name="ch<%=icurrentRec%>" id="ch<%=icurrentRec%>" value="Y" checked> <INPUT name="txtPNo<%=icurrentRec%>" id="txtPNo<%=icurrentRec%>" type="hidden" value="<%=strPNo%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><span onclick="seqClicked('<%=strPNo%>','<%=icurrentPage + 1%>');" style="cursor: hand; color: blue"><%=strPolNo%>&nbsp;</span></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="92"><%=strAppNo%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strPName%>&nbsp; <INPUT type="hidden" id="txtPName<%=icurrentRec%>" name="txtPName<%=icurrentRec%>" value="<%=strPName%>"><INPUT type="hidden" id="txtPRBank<%=icurrentRec%>" name="txtPRBank<%=icurrentRec%>" value="<%=strPRBank%>"><INPUT type="hidden" id="txtPRAccount<%=icurrentRec%>" name="txtPRAccount<%=icurrentRec%>" value="<%=strPRAccount%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strPId%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="69"><%=df.format(iPAmt)%>&nbsp; <INPUT name="txtPAMT<%=icurrentRec%>" id="txtPAMT<%=icurrentRec%>" type="hidden" value="<%=iPAmt%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="67"><%=strPsrccode%>&nbsp;<%=strPdesc%>&nbsp; <INPUT type="hidden" id="txtPSRCCode<%=icurrentRec%>" name="txtPSRCCode<%=icurrentRec%>" value="<%=strPsrccode%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><%=strPDate%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="60"><%=strPMethodDesc%>&nbsp; <INPUT name="txtPMethod<%=icurrentRec%>" id="txtPMethod<%=icurrentRec%>" type="hidden" value="<%=strPMethod%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="53"><%=strVoidabledD%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="53"><%=strPDispatchD%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="60"><%=strCurrency%>&nbsp; <INPUT name="txtCurrency<%=icurrentRec%>" id="txtCurrency<%=icurrentRec%>" type="hidden" value="<%=strCurrency%>"></TD>
				<TD style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="35" width="53"><%=strBranch%>&nbsp;</TD>
			</TR>
<%					if ((iSeqNo == iPageSize) || (icurrentRec == (alPDetail.size() - 1)) || (iSeqNo % iPageSize == 0)) { %>
	</table>
	</div>
<%					}
				} // end of if --> inowRec < alPDetail.size()
			}// end of for -- show detail      
		}//end of for %>
	<input name="allbox" type="checkbox" onClick="CheckAll();" checked>
	總頁數 :<%=itotalpage%>&nbsp;&nbsp;
	總件數 :<%=itotalCount%>&nbsp;&nbsp;&nbsp;&nbsp;
	NT_總金額:<%=df.format(iSumAmt)%>&nbsp;&nbsp;&nbsp;&nbsp;
	US_總金額:<%=df.format(iUSSumAmt)%>
<%	} //end of if2 
}//end of if1
else 
{ %>
	<table border="0" cellPadding="0" cellSpacing="0" width="816" id="tblDetail">
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
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="細明體">單位</font></b></TD>
			</TR>
		</tbody>
	</table>
<% } %>
	<INPUT type="hidden" id="txtPNo" name="txtPNo" value=""> 
	<INPUT type="hidden" id="txtTpage" name="txtTpage" value="<%=itotalpage%>">
	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>"> 
	<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>"> 
	<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 
	<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">
	<INPUT type="hidden" id="currentPage" name="currentPage" value="">
</form>
	<!-- R90474 -->
<% if (!"".equals(request.getParameter("currentPage") != null ? request.getParameter("currentPage") : "")) { %>
<SCRIPT language=javascript>
<!--
function EChangePage(ipage,iTpage,iCpage,iActionCode) 
{
	var strid = "showPage"+ipage;
	var bReturnStatus = true;

	if((iActionCode == 1 || iActionCode == 2) && iCpage == 1) {
		bReturnStatus = false;
	} else if((iActionCode == 3 || iActionCode == 4) && iCpage == iTpage) {
		bReturnStatus = false;
	}
	if(bReturnStatus) {
		document.getElementById(strid).style.display = "block";
		if(ipage>1) {
			for(var i=1; i<ipage; i++) {
				var stridi="showPage"+i;
				document.getElementById(stridi).style.display = "none";
			}
		}
		if(ipage < iTpage) {
			for(var j=iTpage; j>ipage; j--) {
				var stridj="showPage"+j;
				document.getElementById(stridj).style.display = "none";
			}
		}
   	}
}
<% 		if (itotalpage != Integer.parseInt(request.getParameter("currentPage"))) { %>
	EChangePage(<%=request.getParameter("currentPage")%>,<%=itotalpage%>,<%=request.getParameter("currentPage")%>,<%=request.getParameter("currentPage")%>);
<% 		} else { %>
	EChangePage(<%=request.getParameter("currentPage")%>,<%=itotalpage%>,<%=Integer.parseInt(request.getParameter("currentPage"))%>,<%=Integer.parseInt(request.getParameter("currentPage"))%>);
<% 		} %>
//-->
</SCRIPT>
<% } %>
</BODY>
</HTML>
