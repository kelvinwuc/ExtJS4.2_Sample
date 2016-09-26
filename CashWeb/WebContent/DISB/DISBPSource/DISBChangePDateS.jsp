<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CASHWEB
 * 
 * Function : 修改付款日-修改
 * 
 * Remark   : 因應農曆過年假期較長，付款日為假期期間的支付案件提早給付
 * 
 * Revision : $Revision: 1.5 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $Date: 2013/12/18 07:22:52 $
 * 
 * Request ID : E10210
 * 
 * CVS History:
 * 
 * $Log: DISBChangePDateS.jsp,v $
 * Revision 1.5  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.4  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 *  
 */
%><%! String strThisProgId = "ChangePDate"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();

DecimalFormat df = new DecimalFormat("#.00");

String strAction = (request.getAttribute("txtAction") != null) ? (String) request.getAttribute("txtAction") : "";
String strMsg = (request.getAttribute("txtMsg") != null) ? (String) request.getAttribute("txtMsg") : "";

List tmpList = (List) request.getAttribute("PDetailList");
int count = ( tmpList == null ? 0 : tmpList.size() );
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>修改付款日</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' );
	window.status = "";
}

function resetAction()
{
	document.forms("frmMain").reset();
}

function exitAction()
{
	document.getElementById("txtAction").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBPSource/DISBChangePDateC.jsp";
}

function confirmAction()
{
	document.getElementById("txtPayDate").value = rocDate2String(document.getElementById("txtPDate").value);

	if( document.getElementById("txtPDate").value == "" ) {
		alert("請輸入付款日期!");
		return false;
	}

	var bReturnStatus = false;
	var chk = document.getElementsByName("PNO");
	for( var index = 0; index<chk.length; index++ ) {
		if(chk[index].checked) {
			bReturnStatus = true;
			break;
		}
	}
	if(!bReturnStatus) {
		alert("請勾選欲修改的保單!");
		return false;
	}

	document.frmMain.submit();
}
//-->
</SCRIPT>
</head>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSChangePDateServlet?action=update">
<TABLE border="1" width="450">
	</TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="100">付款日期：</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDate" name="txtPDate" value="" >
				<a href="javascript:show_calendar('frmMain.txtPDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
				<INPUT type="hidden" name="txtPayDate" id="txtPayDate" value=""> 
			</TD>
		</TR>
	</TBODY>
</TABLE>
<BR>
<TABLE id="tbl" border="0" cellpadding="0" cellspacing="0" width="700">
	<TR align="center" class="TableHeading">
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="55" width="30"><B><FONT size="2" face="細明體">序號</FONT></B></TD>
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="55" width="30"><B><FONT size="2" face="細明體">勾選</FONT></B></TD>
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="55" width="75"><B><FONT size="2" face="細明體">付款日期</FONT></B></TD>
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="55" width="70"><B><FONT size="2" face="細明體">付款方式</FONT></B></TD>
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="55" width="65"><B><FONT size="2" face="細明體">保單號碼</FONT></B></TD>
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="55" width="80"><B><FONT size="2" face="細明體">受款人姓名</FONT></B></TD>
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="55" width="70"><B><FONT size="2" face="細明體">受款人ID</FONT></B></TD>
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="55" width="80"><B><FONT size="2" face="細明體">支付金額</FONT></B></TD>
		<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;" height="55" width="150"><B><FONT size="2" face="細明體">支付描述</FONT></B></TD>
	</TR>
<%
DISBPaymentDetailVO objPDetailVO = null;
String strPayMethodCode = "";
String strPayMethodDesc = "";
String strPaySource = "";
String strPayAmt = "";
for(int i=0; i<count; i++) {
	objPDetailVO = (DISBPaymentDetailVO) tmpList.get(i);

	strPayMethodCode = CommonUtil.AllTrim(objPDetailVO.getStrPMethod());
	if("A".equals(strPayMethodCode)) {
		strPayMethodDesc = "支票";
	} else if("B".equals(strPayMethodCode)) {
		strPayMethodDesc = "台幣匯款";
	} else if("C".equals(strPayMethodCode)) {
		strPayMethodDesc = "信用卡";
	} else if("D".equals(strPayMethodCode)) {
		strPayMethodDesc = "外幣匯款";
	} else if("E".equals(strPayMethodCode)) {
		strPayMethodDesc = "現金";
	} else {
		strPayMethodDesc = "";
	}

	strPaySource = CommonUtil.AllTrim(objPDetailVO.getStrPSrcCode()) + " " + CommonUtil.AllTrim(objPDetailVO.getStrPDesc());
	strPayAmt = CommonUtil.AllTrim(objPDetailVO.getStrPCurr()) + " " + df.format(objPDetailVO.getIPAMT());
%>
	<TR id="dataRow_<%=i+1%>" >
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; text-align: center;" height="35"><%=i+1%></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; text-align: center;" height="35"><INPUT type="checkbox" checked id="PNO" name="PNO" value="<%=objPDetailVO.getStrPNO()%>"></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="35">&nbsp;<%=objPDetailVO.getStrPDate()%></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="35">&nbsp;<%=strPayMethodDesc%></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="35">&nbsp;<%=objPDetailVO.getStrPolicyNo()%></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="35">&nbsp;<%=objPDetailVO.getStrPName()%></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;" height="35">&nbsp;<%=objPDetailVO.getStrPId()%></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; text-align: right;" height="35">&nbsp;<%=strPayAmt%></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;" height="35">&nbsp;<%=strPaySource%></TD>
	</TR>
<%}%>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
</FORM>
</BODY>
</html>