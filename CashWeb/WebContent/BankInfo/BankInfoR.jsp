<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : ���ĳ��M�U
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.1 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : 2013/6/14
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: BankInfoR.jsp,v $
 * Revision 1.1  2013/12/24 03:35:04  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */
%><%! String strThisProgId = "BankInfoR"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alCurrCash = new ArrayList(); 
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
}
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"\">����</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
}
%>
<HTML>
<HEAD>
<TITLE>���ĳ��M�U</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientR.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title, '', strFunctionKeyReport, '' );
}

/* ��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q���� */
function resetAction()
{
	document.forms("frmMain").reset();
}

/* ��toolbar frame ����<����>���s�Q�I���,����Ʒ|�Q���� */
function printRAction()
{
	getReportInfo();
	document.getElementById("frmMain").target="_blank";
	document.getElementById("frmMain").submit();
}

function getReportInfo()
{
	var strSql = "";
	strSql  = "SELECT BKCODE,BKNAME,BKATNO,BKCURR,GLACT,BKALAT,BKCRED,BKPACB,BKBATC,BKGPCD,BKSPEC,BKSTAT,BKMEMO ";
	strSql += " FROM CAPBNKF ";
	strSql += " WHERE 1=1 ";

	if( document.getElementById("para_Currency").value != "" ) {
		strSql += " and BKCURR = '"+document.getElementById("para_Currency").value +"' ";
	}
	if( document.getElementById("para_AcctStatus").value != "" ) {
		strSql += " and BKSTAT = '"+document.getElementById("para_AcctStatus").value +"' ";
	}
	if( document.getElementById("txtBankCode").value != "" ) {
		strSql += " and BKCODE = '"+document.getElementById("txtBankCode").value +"' ";
	}

    strSql += " ORDER BY BKCODE, BKATNO, BKALAT, BKCURR";

	document.getElementById("ReportSQL").value = strSql;

	document.getElementById("para_QCURR").value = document.getElementById("para_Currency").value;
	document.getElementById("para_QSTATUS").value = document.getElementById("para_AcctStatus").value;
	document.getElementById("para_QCODE").value = document.getElementById("txtBankCode").value;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<TABLE border="1" width="300" id=FormArea>
		<TR>
			<TD align="right" class="TableHeading" width="120">���O�G</TD>
			<TD width="180" valign="middle">
				<select size="1" name="para_Currency" id="para_Currency" class="Data">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�b�����A�G</TD>
			<TD valign="middle">
				<select size="1" name="para_AcctStatus" id="para_AcctStatus" class="Data">
					<option value="">����</option>
					<option value="Y">�ҥ�</option>
					<option value="N">����</option>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">���ĳ��N�X�G</TD>
			<TD valign="middle"><INPUT class="Data" size="10" type="text" maxlength="4" id="txtBankCode" name="txtBankCode" value=""></TD>
		</TR>
	</TABLE>
	<INPUT type="hidden" id="ReportName" name="ReportName" value="BankInfoRpt.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DBankInfoReport.pdf"> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>BankInfo\\">

	<INPUT type="hidden" id="para_QCURR" name="para_QCURR" value="">
	<INPUT type="hidden" id="para_QSTATUS" name="para_QSTATUS" value="">
	<INPUT type="hidden" id="para_QCODE" name="para_QCODE" value="">

</FORM>

</BODY>
</HTML>


