<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 現金支付
 * 
 * Remark   : 出納功能
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : 2013/11/13
 * 
 * Request ID  : RB0302
 * 
 * CVS History:
 
 *RD0397:Kelvin Wu,20150907,修改預設的付款帳號
 * 
 * $Log: DISBCashConfirmList.jsp,v $
 * Revision 1.3  2015/09/08 02:07:24  001946
 * *** empty log message ***
 *
 * Revision 1.2  2014/07/18 07:33:34  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.1  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 *  
 */
%><%! String strThisProgId = "DISBCashConfirm"; //本程式代號 %><%
DecimalFormat df = new DecimalFormat("#.00");
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPBBankP = null;

if (session.getAttribute("PBBankListP") == null) {
	alPBBankP = (List) disbBean.getETable("PBKAT", "BANKP");
	session.setAttribute("PBBankListP",alPBBankP);
} else {
	alPBBankP =(List) session.getAttribute("PBBankListP");
}
if (session.getAttribute("PBBankListP") != null) {
	session.removeAttribute("PBBankListP");
}

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

StringBuffer sbBankCode = new StringBuffer();
sbBankCode.append("<option value=\"\">&nbsp;</option>");
if (alPBBankP.size() > 0) {
	for (int i = 0; i < alPBBankP.size(); i++) {
		htTemp = (Hashtable) alPBBankP.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		//if(strValue.equals("0070937/09310112987"))
		//RD0397:Kelvin Wu,20150907,修改預設的付款帳號
		if(strValue.equals("1150111/11110100059"))
			sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}

double total = 0;
List<DISBPaymentDetailVO> vo = (List<DISBPaymentDetailVO>)request.getAttribute("PDetailListTemp");
request.removeAttribute("PDetailListTemp");
int count = (vo == null?0:vo.size());
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>現金支付</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
// *************************************************************
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
	window.status = "";
}

function confirmAction()
{
	document.getElementById("txtAction").value = "H";
	mapValue();
	if(checkField()){
		document.frmMain.submit();
	}
}

function resetAction()
{
	document.forms("frmMain").reset();
}

function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBCashConfirmInq.jsp";
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
function checkField()
{
	var bReturnStatus = false;
	var strTmpMsg = "";
	if(document.getElementById("txtPCSHCMC").value == "")
	{
	   alert( "請輸入出納確認日!" );
	   return bReturnStatus;
	}
	var chk = document.getElementsByName("PNO");
	for(var index = 0; index<chk.length; index++){
		if(chk[index].checked){
			bReturnStatus = true;
			break;
		}
	}
	if(!bReturnStatus){
		alert( "請勾選欲確認的保單!" );
	}

	return bReturnStatus;
}

function mapValue()
{
	document.getElementById("txtPCSHCM").value = rocDate2String(document.getElementById("txtPCSHCMC").value);
	var BankAccount = document.getElementById("selPBBANK").value ;
	if(BankAccount != "")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);	
	}

	var t1 = document.all("tbl").childNodes[0];
	var chk = document.getElementsByName("PNO");
	var amt = 0;
	for(var index=0; index<chk.length ; index++ ) {
		if(chk[index].checked) {
			amt = amt + parseFloat(t1.rows[index+1].cells[7].innerHTML);
		}
	}
	document.getElementById("PAMT").value = amt;
}

function calculateAmt()
{
	var amt = 0.00;
	var count = 0;
	var t1 = document.all("tbl").childNodes[0];

	var chk = document.getElementsByName("PNO");
	for(var index=0; index<chk.length ; index++ ){
		if(chk[index].checked){
			count = count+1;
			amt = amt + parseFloat(t1.rows[index+1].cells[7].innerHTML);
		}
	}

	var t2 = document.all("tbl2").childNodes[0];
	t2.rows[0].cells[1].innerHTML = count;
	t2.rows[0].cells[5].innerHTML = amt;
}

//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBCashConfirmServlet" id="frmMain" method="post" name="frmMain">
<INPUT type="hidden" id="txtPBBank" name="txtPBBank" value="">
<INPUT type="hidden" id="txtPBAccount" name="txtPBAccount" value="">
<INPUT type="hidden" id="PAMT" name="PAMT" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<TABLE border="1" width="452">
	</TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">出納確認日：</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCSHCMC" name="txtPCSHCMC" value="" >
				<a href="javascript:show_calendar('frmMain.txtPCSHCMC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
				<INPUT type="hidden" name="txtPCSHCM" id="txtPCSHCM" value=""> 
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">付款帳號：</TD>
			<TD width="333">
				<select size="1" name="selPBBANK" id="selPBBANK" class="Data">
					<%=sbBankCode.toString()%>
				</select>
			</TD>
		</TR>
	</TBODY>
</TABLE>
<br>
<TABLE id="tbl" border="0" cellpadding="0" cellspacing="0" width="900">
	<TBODY>
		<TR>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="細明體">序號</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="細明體">勾選</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="65"><B><FONT size="2" face="細明體">保單號碼</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="細明體">要保書號碼</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="細明體">受款人姓名</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="細明體">受款人ID</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="細明體">幣別</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="細明體">支付金額</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="細明體">支付描述</FONT></B></TD>
<!-- RC0036 -->
		    <TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">承辦單位</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">付款日期</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">付款方式</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">作廢否</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">急件否</FONT></B></TD>
		</TR>
<%	DISBPaymentDetailVO paymentDetail = null;
	String strPayMethodCode = "";
	String strPayMethodDesc = "";
	String strPaySRCDesc = "";
	for(int index = 0 ; index < vo.size() ; index++) {
		paymentDetail = (DISBPaymentDetailVO)vo.get(index);
		total += paymentDetail.getIPAMT();

		strPayMethodCode = CommonUtil.AllTrim(paymentDetail.getStrPMethod());
		if("A".equals(strPayMethodCode)) {
			strPayMethodDesc = "支票";
		} else if("B".equals(strPayMethodCode)) {
			strPayMethodDesc = "匯款";					
		} else if("C".equals(strPayMethodCode)) {
			strPayMethodDesc = "信用卡";					
		} else if("D".equals(strPayMethodCode)) {
			strPayMethodDesc = "國外匯款";					
		} else if("E".equals(strPayMethodCode)) {
			strPayMethodDesc = "現金";					
		}

		strPaySRCDesc = CommonUtil.AllTrim(paymentDetail.getStrPSrcCode()) + "-" + CommonUtil.AllTrim(paymentDetail.getStrPDesc()); %>
		<TR id="dataRow_<%=index+1%>" >
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35"><%=index+1%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35"><INPUT type="checkbox" checked name="PNO" id="PNO" value="<%=paymentDetail.getStrPNO()%>" onClick="calculateAmt();"></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrPolicyNo()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrAppNo()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrPName()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrPId()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrPCurr()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" align="right"><%=df.format(paymentDetail.getIPAMT())%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=strPaySRCDesc%></TD>
<!--RC0036-->
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrUsrDept()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getIPDate()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=strPayMethodDesc%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=("Y".equals(paymentDetail.getStrPVoidable())?"是":"否")%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="35">&nbsp;<%=("Y".equals(paymentDetail.getStrPDispatch())?"是":"否")%></TD>
		</TR>
<%	} %>
	</TBODY>
</TABLE>
<BR>
<table id="tbl2">
	<tr><td>總件數 :  </td><td><%=count%></td><td></td><td></td><td>總金額 : </td><td><%=df.format(total)%></td></tr>
</table>
</FORM>
</BODY>
</HTML>