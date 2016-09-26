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
 * Function : ���T�{
 * 
 * Remark   : ��I�ӷ�
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
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.10  2013/03/29 09:55:05  MISSALLY
 * RB0062 PA0047 - �s�W���w�Ȧ� ���ƻȦ�
 *
 * Revision 1.9  2013/01/09 02:54:25  MISSALLY
 * Calendar problem
 *
 * Revision 1.8  2013/01/08 04:25:56  MISSALLY
 * �N���䪺�{��Merge��HEAD
 *
 * Revision 1.6.4.1  2012/12/06 06:28:29  MISSALLY
 * RA0102�@PA0041
 * �t�X�k�O�ק�S����I�@�~
 *
 * Revision 1.6  2011/10/21 10:04:36  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 * Revision 1.4  2009/11/11 06:15:17  missteven
 * R90474 �ק�CASH�\��
 *
 * Revision 1.3  2008/08/06 06:04:56  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.2  2007/03/06 01:53:23  MISVANESSA
 * R70088_SPUL�t��
 *
 * Revision 1.1  2006/06/29 09:40:47  MISangel
 * Init Project
 *
 * Revision 1.1.2.14  2006/04/27 09:35:39  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.13  2005/04/04 07:02:24  miselsa
 * R30530 ��I�t��
 *
 */
%><%!String strThisProgId = "DISBPSourceConfirm"; //���{���N��%><%
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
double iSumAmt = 0;//�`���B_NT
double iUSSumAmt = 0;//�`���B_US
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
<TITLE>��I�ӷ�--���T�{</TITLE>
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
		WindowOnLoadCommon( document.title+"(�d��)" , '' , strFunctionKeyInquiry1,'' );
	}
}

function inquiryAction()
{
	document.getElementById("iquiryArea").style.display ="block";
	WindowOnLoadCommon( document.title+"(�d��)" , '' , strFunctionKeyInquiry1,'' );
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
			var strConfirmMsg = "�O�_�T�w�n�����I�T�{�@�~?\n";
			if(iCountA > 0)
			{
				strConfirmMsg = strConfirmMsg + "�䲼����:" + iCountA + "\n�䲼���`�B:" + iAMTA +"\n";
			}
			if(iUSCountA > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_�䲼����:" + iUSCountA + "\n�䲼���`�B:" + iUSAMTA +"\n";
			}
			if(iCountB > 0)
			{
				strConfirmMsg = strConfirmMsg + "�״ڵ���:" + iCountB + "\n�״ڥ��`�B:" + iAMTB +"\n";
			}
			if(iUSCountB > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_�״ڵ���:" + iUSCountB + "\n�״ڥ��`�B:" + iUSAMTB +"\n";
			}
			if(iCountC > 0)
			{
				strConfirmMsg = strConfirmMsg + "�H�Υd����:" + iCountC + "\n�H�Υd���`�B:" + iAMTC +"\n";
			}
			if(iUSCountC > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_�H�Υd����:" + iUSCountC + "\n�H�Υd���`�B:" + iUSAMTC +"\n";
			}
			if(iCountE > 0)
			{
				strConfirmMsg = strConfirmMsg + "�{������:" + iCountE + "\n�{�����`�B:" + iAMTE +"\n";
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
			   	strTmpMsg = "��J������_�餣�o�j���J���������";
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
				strTmpMsg = "��J������_�餣�o�j���J���������";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.id == "txtPDateC" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "�I�ڤ�����i�ť�";
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

//��I�T�{�ˮ�
function checkRemitPayment()
{
	var strTmpMsg = "";
	var bReturnStatus = true;
	for(var i=0; i< iTotalrec; i++)
	{
		var checkId = "ch" + i;
		if(document.getElementById(checkId).checked)
		{
			//�Ȱw��I�ڤ覡��(�x��/�~��)�״ڰ��ˮ�
			if(document.getElementById("txtPMethod"+i).value == "B" || document.getElementById("txtPMethod"+i).value == "D") 
			{
				//�״ڻȦ�N�����o�p��C�X
				if(document.getElementById("txtPRBank"+i).length < 7) {
					strTmpMsg += "�u�״ڻȦ�N���v���o�p��C�X!!\n\r";
					bReturnStatus = false;
				}
				//�״ڻȦ�b�����o���ŭ�
				if(document.getElementById("txtPRAccount"+i).value == "") {
					strTmpMsg += "�u�״ڻȦ�b���v���o���ŭ�!!\n\r";
					bReturnStatus = false;
				}
				//���ڤH�m�W���o���ť�
		    	if(document.getElementById("txtPName"+i).value == "") {
					strTmpMsg += "�u���ڤH�m�W�v���o���ŭ�!!\n\r";
					bReturnStatus = false;
				}
			}
			//PA0024 �W�[�ˮ֤�I��]�N�X���o�ť�
			if(document.getElementById("txtPSRCCode"+i).value == "")
			{
				strTmpMsg += "�Ǹ�" + (i+1) + "�u��I��]�N�X�v���o���ŭ�!!\n\r";
				bReturnStatus = false;
			}
			//RB0302 �{���ȭ���x�����ɴ�
			if((document.getElementById("txtPMethod"+i).value == "E") &&
				(!(document.getElementById("txtCurrency"+i).value == "NT" && 
					(document.getElementById("txtPSRCCode"+i).value == "E1" || document.getElementById("txtPSRCCode"+i).value == "E2") &&
					document.getElementById("selDispatch"+i).value == "Y")))
			{
				strTmpMsg += "�Ǹ�" + (i+1) + "��������󤧫O��ɴڤ~��H�{����I!!\n\r";
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
				<TD align="right" class="TableHeading" width="80">��J����G</TD>
				<TD colspan=3 width="321">
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
					<a href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
					<INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate" value=""> 
					~ 
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryEndDateC" name="txtEntryEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
					<a href="javascript:show_calendar('frmMain.txtEntryEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
					<INPUT type="hidden" name="txtEntryEndDate" id="txtEntryEndDate" value="">
				</TD>
				<TD align="right" class="TableHeading" width="74">�I�ڤ���G</TD>
				<TD colspan=3 width="155">
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateC" name="txtPDateC" value="" readOnly onblur="checkClientField(this,true);"> 
					<a href="javascript:show_calendar('frmMain.txtPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
					<INPUT type="hidden" name="txtPDate" id="txtPDate" value="">
				</TD>
				<TD align="right" class="TableHeading" width="93">��I��]�G</TD>
				<TD colspan=3 width="50">
					<select size="1" name="selPSrcCode" id="selPSrcCode" class="Data">
						<%= sbPSrcCode.toString() %>
					</select>
				</TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading" width="48">���G</TD>
				<TD colspan=3 width="40">
					<select size="1" name="selDispatch" id="selDispatch">
						<option value=""></option>
						<option value="Y">�O</option>
						<option value="N">�_</option>
					</select>
				</TD>
				<TD align="right" class="TableHeading" width="48">���O�G</TD>
				<TD colspan=3 width="40">
					<select size="1" name="selCurrency" id="selCurrency">
						<!-- R80132 �~���O��ݿ�J SWIFT CODE ������� , �G���o���I�ӷ��T�{�ɥH��媺�覡�� -->
						<!-- R80132		<option value=""></option>  -->
						<option value="NT">NT</option>
						<!-- R80132		<option value="US">US</option>   -->
					</select>
				</TD>
<%if(Integer.parseInt(strUserRight) > 79) { %>
				<TD align="right" class="TableHeading" width="93">��J�̥N���G</TD>
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
		int icurrentPage = 0; // ��0�}�l�p
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
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="30"><b><font size="2" face="�ө���">�Ǹ�</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="30"><b><font size="2" face="�ө���">�Ŀ�</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�O�渹�X</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="�ө���">�n�O�Ѹ��X</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤH�m�W</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤHID</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="�ө���">��I���B</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><b><font size="2" face="�ө���">��I�y�z</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�I�ڤ��</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><b><font size="2" face="�ө���">�I�ڤ覡</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="�ө���">�@�o�_</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="�ө���">���_</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="�ө���">���O</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><b><font size="2" face="�ө���">���</font></b></TD>
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
							strPMethodDesc = "�䲼";
						if (strPMethod.equals("B"))
							strPMethodDesc = "�״�";
						if (strPMethod.equals("C"))
							strPMethodDesc = "�H�Υd";
						if (strPMethod.equals("D"))//R70088
							strPMethodDesc = "�~���״�";
						if (strPMethod.equals("E"))
							strPMethodDesc = "�{��";
					}

					if (objPDetailVO.getStrPDispatch() != null)
						strPDispatch = objPDetailVO.getStrPDispatch();
					if (strPDispatch != "") {
						strPDispatch = strPDispatch.trim();
						if (strPDispatch.equals("Y"))
							strPDispatchD = "�O";
						else
							strPDispatchD = "�_";
					}

					if (objPDetailVO.getStrPVoidable() != null)
						strVoidabled = objPDetailVO.getStrPVoidable();
					if (strVoidabled != "") {
						strVoidabled = strVoidabled.trim();
						if (strVoidabled.equals("Y"))
							strVoidabledD = "�O";
						else
							strVoidabledD = "�_";
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
					String strPRBank = "";		//�״ڻȦ�
					String strPRAccount = "";	//�״ڱb��

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
	�`���� :<%=itotalpage%>&nbsp;&nbsp;
	�`��� :<%=itotalCount%>&nbsp;&nbsp;&nbsp;&nbsp;
	NT_�`���B:<%=df.format(iSumAmt)%>&nbsp;&nbsp;&nbsp;&nbsp;
	US_�`���B:<%=df.format(iUSSumAmt)%>
<%	} //end of if2 
}//end of if1
else 
{ %>
	<table border="0" cellPadding="0" cellSpacing="0" width="816" id="tblDetail">
		<tbody>
			<TR>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ǹ�</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ŀ�</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�O�渹�X</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="�ө���">�n�O�Ѹ��X</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤH�m�W</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤHID</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="�ө���">��I���B</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><b><font size="2" face="�ө���">��I�y�z</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�I�ڤ��</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><b><font size="2" face="�ө���">�I�ڤ覡</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="�ө���">�@�o�_</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="�ө���">���_</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="�ө���">���</font></b></TD>
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
