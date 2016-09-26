<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CASHWEB
 * 
 * Function : �ק�I�ڤ�-�d��
 * 
 * Remark   : �]���A��L�~���������A�I�ڤ鬰������������I�ץ󴣦����I
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $Date: 2013/11/11 02:15:08 $
 * 
 * Request ID : E10210
 * 
 * CVS History:
 * 
 * $Log: DISBChangePDateC.jsp,v $
 * Revision 1.3  2013/11/11 02:15:08  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.2  2012/08/29 02:57:50  ODCKain
 * Calendar problem
 *
 * Revision 1.1  2012/01/11 07:02:37  MISSALLY
 * E10210
 * �ק�CASH�t�ΡA�]BATCH�Ҳ��ͦU�����I�����I�ڤ�
 *
 *  
 */
%><%! String strThisProgId = "ChangePDate"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();

String strAction = (request.getAttribute("txtAction") != null) ? (String) request.getAttribute("txtAction") : "";
String strMsg = (request.getAttribute("txtMsg") != null) ? (String) request.getAttribute("txtMsg") : "";
String strUserRight = (session.getAttribute("LogonUserRight") != null) ? CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")) : "";
String strPNOList = (request.getAttribute("aryPNO") != null) ? CommonUtil.AllTrim((String) request.getAttribute("aryPNO")) : "";
strPNOList = (!strPNOList.equals("")) ? strPNOList.substring(1) : "";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>�ק�I�ڤ�</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" )
		alert(document.getElementById("txtMsg").value);

	if( document.getElementById("txtUserRight").value == "79" )
	{
		alert("�L���榹�\���v��!!");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else if( document.getElementById("txtAction").value == "Report" )
	{
		var varSql = "SELECT PNO,CASE PMETHOD WHEN 'A' THEN '�䲼' WHEN 'B' THEN '�x���״�' WHEN 'C' THEN '�H�Υd' WHEN 'D' THEN '�~���״�' ELSE '' END as PMETHOD,PDATE,PNAME,PID,PCURR,PAMT,PSRCCODE,PDESC,POLICYNO ";
		varSql += "FROM CAPPAYF ";
		varSql += "WHERE PNO IN (" + document.getElementById("txtPNOList").value + ") ";
		varSql += "ORDER BY PDATE,PID,PNAME,POLICYNO,PSRCCODE ";

		WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
		document.getElementById("ReportSQL").value = varSql;
		document.getElementById("frmMain").action = "<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
	}
	else
	{
		WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
	}

	window.status = "";
}

function inquiryAction()
{
	var strTmpMsg = "";
	if( document.getElementById("txtPDateS").value == "" || document.getElementById("txtPDateE").value == "" ) {
		alert("[�I�ڤ��] ���i�ť�!!");
		return false;
	} else if(document.getElementById("selPMethod").value == "") {
		alert("[�I�ڤ覡] ���i�ť�!!");
		return false;
	} else {
		document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPDateS").value);
		document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPDateE").value);
		document.frmMain.submit();
	}
}
//-->
</SCRIPT>
</head>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSChangePDateServlet?action=query">
<TABLE border="1" width="450" id="inqueryArea">
	<TR>
		<TD align="right" class="TableHeading" width="100">�ӷ��G</TD>
		<TD>
			<input type="radio" name="rdFromBatch" id="rdFromBatch" value="Y" class="Data" checked>Batch�@�~ 
			<input type="radio" name="rdFromBatch" id="rdFromBatch" value="N" class="Data">�u�W�@�~
		</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading" width="100">�I�ڤ覡�G</TD>
		<TD>
			<select id="selPMethod" name="selPMethod" class="Data">
				<option value="">&nbsp;</option>
				<option value="A">�䲼</option>
				<option value="B">�x���״�</option>
				<option value="C">�H�Υd</option>
				<option value="D">�~���״�</option>
			</select>
		</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading" width="100">�I�ڤ���G</TD>
		<TD>
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateS" name="txtPDateS" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtPDateS','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��">
			</a>
			<INPUT type="hidden" id="txtPStartDate" name="txtPStartDate" value="">
			~ 
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateE" name="txtPDateE" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtPDateE','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��">
			</a>
			<INPUT type="hidden" id="txtPEndDate" name="txtPEndDate" value=""> 
		</TD>
	</TR>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 

<INPUT type="hidden" id="txtPNOList" name="txtPNOList" value="<%=strPNOList%>">

<INPUT type="hidden" id="ReportName" name="ReportName" value="ChangePayDate.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="ChangePayDate.pdf"> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBPSource\\"> 

</FORM>
</BODY>
</html>