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
 * Function : �{����I
 * 
 * Remark   : �X�ǥ\��
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
 
 *RD0397:Kelvin Wu,20150907,�ק�w�]���I�ڱb��
 * 
 * $Log: DISBCashConfirmList.jsp,v $
 * Revision 1.3  2015/09/08 02:07:24  001946
 * *** empty log message ***
 *
 * Revision 1.2  2014/07/18 07:33:34  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.1  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 *  
 */
%><%! String strThisProgId = "DISBCashConfirm"; //���{���N�� %><%
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
		//RD0397:Kelvin Wu,20150907,�ק�w�]���I�ڱb��
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
<TITLE>�{����I</TITLE>
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
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
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
��ƦW��:	checkClientField(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function checkField()
{
	var bReturnStatus = false;
	var strTmpMsg = "";
	if(document.getElementById("txtPCSHCMC").value == "")
	{
	   alert( "�п�J�X�ǽT�{��!" );
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
		alert( "�ФĿ���T�{���O��!" );
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
			<TD align="right" class="TableHeading" width="101">�X�ǽT�{��G</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCSHCMC" name="txtPCSHCMC" value="" >
				<a href="javascript:show_calendar('frmMain.txtPCSHCMC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
				<INPUT type="hidden" name="txtPCSHCM" id="txtPCSHCM" value=""> 
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�I�ڱb���G</TD>
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
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="�ө���">�Ǹ�</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="�ө���">�Ŀ�</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="65"><B><FONT size="2" face="�ө���">�O�渹�X</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="�ө���">�n�O�Ѹ��X</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="�ө���">���ڤH�m�W</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="�ө���">���ڤHID</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="�ө���">���O</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="�ө���">��I���B</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="�ө���">��I�y�z</FONT></B></TD>
<!-- RC0036 -->
		    <TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">�ӿ���</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">�I�ڤ��</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">�I�ڤ覡</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">�@�o�_</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">���_</FONT></B></TD>
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
			strPayMethodDesc = "�䲼";
		} else if("B".equals(strPayMethodCode)) {
			strPayMethodDesc = "�״�";					
		} else if("C".equals(strPayMethodCode)) {
			strPayMethodDesc = "�H�Υd";					
		} else if("D".equals(strPayMethodCode)) {
			strPayMethodDesc = "��~�״�";					
		} else if("E".equals(strPayMethodCode)) {
			strPayMethodDesc = "�{��";					
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
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=("Y".equals(paymentDetail.getStrPVoidable())?"�O":"�_")%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="35">&nbsp;<%=("Y".equals(paymentDetail.getStrPDispatch())?"�O":"�_")%></TD>
		</TR>
<%	} %>
	</TBODY>
</TABLE>
<BR>
<table id="tbl2">
	<tr><td>�`��� :  </td><td><%=count%></td><td></td><td></td><td>�`���B : </td><td><%=df.format(total)%></td></tr>
</table>
</FORM>
</BODY>
</HTML>