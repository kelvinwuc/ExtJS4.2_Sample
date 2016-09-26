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
 * Function : �X�ǥ\��-���ڶ}��
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
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.6  2012/08/29 02:57:57  ODCKain
 * Calendar problem
 *
 * Revision 1.5  2011/07/14 11:34:05  MISSALLY
 * Q10183
 * ���ڶ}�߮ɭY�J��n�����ڧ帹�ɻݤH�u�Ŀ�, �ץ����t�Φ۰ʧ@�~
 *
 * Revision 1.4  2010/11/23 02:17:05  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.2  2008/08/18 06:15:28  MISODIN
 * R80338 �վ�Ȧ�b����檺�w�]��
 *
 * Revision 1.1  2006/06/29 09:40:45  MISangel
 * Init Project
 *
 * Revision 1.1.2.9  2005/04/04 07:02:23  miselsa
 * R30530 ��I�t��
 *  
 */
%><%!
String strThisProgId = "DISBCheckOpen"; //���{���N��
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

//�I�ڱb��
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
		if(strValue.equalsIgnoreCase("8220635/635300021303"))	//8220635/635300021303-���H�ȴ_��
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
double iSumAmt = 0; //�`���B
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
<TITLE>�䲼�\��--���ڶ}�ߧ@�~</TITLE>
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
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	resetAction()
��ƥ\��:	��toolbar frame �����M�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckOpen.jsp";
}

/*
��ƦW��:	confirmAction()
��ƥ\��:	��toolbar frame �����T�w���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	DISBCheckOpenAction()
��ƥ\��:	��toolbar frame ����[���ڶ}��]���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function DISBCheckOpenAction()
{
	if(isValidCheckCount())
	{
		var strConfirmMsg = "�O�_�T�w���沼�ڶ}�ߧ@�~?\n";
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
��ƦW��:	checkClientField(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
 * �P�_�Ŀ�ƥةM�i�αi�ƬO�_�ŦX 2004/12/03  Elsa
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
		strTmpMsg ="�ܤ֭n�Ŀ�@������";
		bReturnStatus = false;
	}
	else
	{
		var iCheckCount =  document.getElementById("txtOCount").value;
		if(iflag > iCheckCount)
		{
			strTmpMsg ="�Ŀ�ƥ�(" +  iflag + ")���o�j��i�αi��( " + iCheckCount+ ")";
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
			<TD align="right" class="TableHeading" width="131">�I�ڱb���G</TD>
			<TD width="329">
				<select size="1" name="selPBBank" id="selPBBank">
					<%=sbPBBank.toString()%>
				</select>
				<INPUT type="hidden" id="txtPBBank" name="txtPBBank" value=""> 
				<INPUT type="hidden" id="txtPBAccount" name="txtPBAccount" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="131">��I�T�{�_�l��G</TD>
			<TD width="329"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtPStartDateC" name="txtPStartDateC" value=""
				readOnly onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> ~ <INPUT
				class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC"
				name="txtPEndDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtPEndDate" id="txtPEndDate" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="131">���_�G</TD>
			<TD valign="middle" width="329">
				<select size="1" name="selDispatch" id="selDispatch">
					<option value=""></option>
					<option value="Y">�O</option>
					<option value="N">�_</option>
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
		int icurrentPage = 0; // ��0�}�l�p
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
		<TD>���ڧ帹:</TD>
		<TD><%=strCBNoOld%></TD>
	</TR>
	<TR>
		<TD>�䲼�_�l��:</TD>
		<TD><%=strCSNoOld%></TD>
	</TR>
	<TR>
		<TD>�i�αi��:</TD>
		<TD><%=strEmptyCheckCount%></TD>
	</TR>
</TABLE>

<TABLE border="0" cellPadding="0" cellSpacing="0" width="816" id="tblDetail">
	<TBODY>
		<TR>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ǹ�</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ŀ�</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�O�渹�X</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="�ө���">�n�O�Ѹ��X</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤH�m�W</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤHID</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="�ө���">��I���B</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><font size="2" face="�ө���"><b>��I�y�z</b></font></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�I�ڤ��</font></b></TD>
			<TD bgColor="#c0c0c0" style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="56" width="53"><font size="2" face="�ө���"><b>���_</b></font></TD>
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
							strPDispatchD = "�O";
						else
							strPDispatchD = "�_";
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
<input name="allbox" type="checkbox" onClick="CheckAll();" checked> �`���� : <%=itotalpage%> &nbsp;&nbsp;�`��� : <%=itotalCount%> &nbsp;&nbsp;&nbsp;&nbsp;�`���B:<%=df.format(iSumAmt)%> 
<%	} //end of if2 
} //end of if1
else 
{%>
<TABLE border="0" cellPadding="0" cellSpacing="0" width="816" id="tblDetail">
	<TBODY>
		<TR>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ǹ�</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ŀ�</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�O�渹�X</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="�ө���">�n�O�Ѹ��X</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤH�m�W</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤHID</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="�ө���">��I���B</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><font size="2" face="�ө���"><b>��I�y�z</b></font></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�I�ڤ��</font></b></TD>
			<TD bgColor="#c0c0c0" style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="56" width="53"><font size="2" face="�ө���"><b>���_</b></font></TD>
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
