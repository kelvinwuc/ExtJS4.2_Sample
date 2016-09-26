<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.5 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: DISBCRePrint.jsp,v $
 * Revision 1.5  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */
%><%! String strThisProgId = "DISBCRePrint"; //���{���N��%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strReturnMessage = (request.getParameter("txtMsg") !=null)?request.getParameter("txtMsg"):"";
%>
<HTML>
<HEAD>
<TITLE>�X�ǥ\��--���ڸɦL</TITLE>
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
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert("11"+document.getElementById("txtMsg").value) ;

   	WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' ) ;
    window.status = "";
}

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCRePrint.jsp";
}

/* ��toolbar frame ����<����>���s�Q�I���,����Ʒ|�Q���� */
function printRAction()
{
    var strSql = "SELECT * from CAPCHKF WHERE CHEQUE_STATUS ='D'";
    var strChequeNo = document.getElementById("para_ChequeF").value;
    var iindexof = strChequeNo.indexOf(' ') ;
	if( document.getElementById("para_ChequeF").value != "" ) {
		strSql += " AND CAST(SUBSTR(CHEQUE_NO,3,16) AS INT)  >=" + strChequeNo.substring(iindexof+1);
	}
    strChequeNo= document.getElementById("para_ChequeL").value;
    iindexof = strChequeNo.indexOf(' ');
	if( document.getElementById("para_ChequeL").value != "" ) {
		strSql += " AND CAST(SUBSTR(CHEQUE_NO,3,16) AS INT)  <= " + strChequeNo.substring(iindexof+1);
	}
    strSql += " order by CHEQUE_NO";
    document.getElementById("ReportSQL").value = strSql;
    document.getElementById("txtAction").value = "DISBCheckOpen";
    WindowOnLoadCommon( document.title, '', 'E', '' );
    document.getElementById("frmMain").submit();
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="1" width="308" id=inqueryArea name=inqueryArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">���ڰ_�l���G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="para_ChequeF" id="para_ChequeF" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">���ڲפ�G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="para_ChequeL" name="para_ChequeL" value=""></TD>
		</TR>
	</TBODY>
</TABLE>

<INPUT type="hidden" id="ReportName" name="ReportName" value="ChequeRpt.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="TXT">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="ChequeRpt.rpt">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">	
<INPUT type="hidden" id="para_rePrtFlag" name="para_rePrtFlag" value="Y"> 
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=request.getParameter("txtAction")%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>