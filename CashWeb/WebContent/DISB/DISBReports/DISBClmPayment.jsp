<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : �U���z�ߵ��I���Ӫ�
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.4 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $Date: 2014/01/03 02:51:37 $
 * 
 * Request ID : R10231
 * 
 * CVS History:
 * 
 * $Log: DISBClmPayment.jsp,v $
 * Revision 1.4  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 * Revision 1.1  2011/08/31 07:28:18  MISSALLY
 * R10231
 * CASH�t�ηs�W�U���z�ߵ��I���Ӫ�
 *
 *  
 */
%><%! String strThisProgId = "DISBClmPayment"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?((String) request.getAttribute("txtAction")):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?(CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept"))):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?(CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight"))):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?(CommonUtil.AllTrim((String)session.getAttribute("LogonUserId"))):"";

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

//���O
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
}
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"\">&nbsp;</option>");
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
<TITLE>�U���z�ߵ��I���Ӫ�</TITLE>
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
// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value !=null && document.getElementById("txtMsg").value != "" )
		window.alert(document.getElementById("txtMsg").value);

	if(document.getElementById("txtUserDept").value != "CLM" && document.getElementById("txtUserDept").value != "GPH")
	{
		alert("�L���榹�����v��");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else
	{
		WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' );
	}

	window.status = "";
}

/*
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBClmPayment.jsp";
}

/*
��ƦW��:	printRAction()
��ƥ\��:	��toolbar frame ����������s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function printRAction()
{
	if(document.getElementById("txtPSRCDT").value == "") 
	{
		alert("�y��J����z���o���ť�!!");
		return false;
	}

	window.status = "";
	getReportInfo();
	WindowOnLoadCommon( document.title , '' , 'E','' );
	document.getElementById("inquiryArea").style.display ="none";

	document.getElementById("frmMain").target="_blank";
	document.getElementById("frmMain").submit();
}

function getReportInfo()
{
	mapValue();

	var strSql  = "SELECT a.PNO, a.POLICYNO, a.PCFMUSR1, a.PMETHOD, a.PCFMDT1, a.ENTRYDT, a.PCHKM1, a.PCHKM2, ";
	strSql += "a.PCURR, a.PAMT, a.PNAME, a.PSNAME, a.PENGNAME, a.PPAYCURR, a.PPAYAMT, a.PPAYRATE, a.PFEEWAY, ";
	strSql += "a.PRBANK, a.PRACCOUNT, a.PSWIFT, a.PAMTNT, b.DEPT as PAY_DEPT, a.PDISPATCH, ";
	strSql += "'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT, ";
	strSql += "'" + document.getElementById("txtUserDept").value + "' AS USERDEPT, ";
	strSql += "IFNULL(c.BKNM,'') as BKNM, IFNULL(na.FLD0002,'') as OwnerId, IFNULL(na.FLD0070,'') as Owner ";
	strSql += "FROM CAPPAYF a  ";
	strSql += "LEFT JOIN USER b on b.USRID=a.ENTRY_USER ";
	strSql += "LEFT JOIN CAPCCBF c on c.BKNO=a.PRBANK ";
	strSql += "LEFT JOIN ORDUPO po ON po.FLD0001='  ' and po.FLD0002=a.POLICYNO ";
	strSql += "LEFT JOIN ORDUNA na ON na.FLD0001=po.FLD0001 and na.FLD0002=po.FLD0021 ";
	strSql += "WHERE a.PCFMDT1 <> 0 AND a.PCFMDT2 = 0 AND a.PVOIDABLE = '' ";
	if (document.getElementById("para_Dispatch").value != "" )
	{
		strSql += "AND a.PDISPATCH = '" + document.getElementById("para_Dispatch").value + "' ";
	}
	if (document.getElementById("para_Currency").value != "" )
	{
		strSql += "AND a.PCURR = '" + document.getElementById("para_Currency").value + "' ";
	}

	if(document.getElementById("txtUserRight").value >= "79" && document.getElementById("txtUserRight").value < "89")
	{	//�u��d�ۤv�ҿ�J�����
		strSql += "AND a.PCFMUSR1 = '" + document.getElementById("txtUserId").value + "' ";
	}
	else if(document.getElementById("txtUserRight").value >= "89" && document.getElementById("txtUserRight").value < "99")
	{	//�u��d�������Ҧ����
		strSql += "AND b.DEPT='" + document.getElementById("txtUserDept").value + "' ";

		//�u�d���H�����
		if(document.getElementById("para_UserRight").value == "1")
		{
			strSql += "AND a.PCFMUSR1 = '" + document.getElementById("txtUserId").value + "' ";
		}
	}
	else
	{	// �v����99��, �i�d�Ҧ����
	}

    document.getElementById("ReportSQL").value = strSql;
}

function mapValue() {
	document.getElementById("para_PSRCDT").value = rocDate2String(document.getElementById("txtPSRCDT").value);
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS"	id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="650"  id=inquiryArea>
	<TR>
		<TD align="right" class="TableHeading" width="120">��J����G</TD>
		<TD width="150">
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPSRCDT" name="txtPSRCDT" value="" readOnly >
			<a href="javascript:show_calendar('frmMain.txtPSRCDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
			<INPUT type="hidden" name="para_PSRCDT" id="para_PSRCDT" value="">
			<a href="javascript:show_calendar('frmMain.txtPSRCDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"></a>	
		</TD>
		<TD align="right" class="TableHeading" width="80">���G</TD>
		<TD>
			<select size="1" name="para_Dispatch" id="para_Dispatch">
				<option value="">&nbsp;</option>
				<option value="Y">���</option>
			</select>
		</TD>
		<TD align="right" class="TableHeading" width="80">���O�G</TD>
		<TD>
			<select size="1" name="para_Currency" id="para_Currency">
				<%=sbCurrCash.toString()%>
			</select>
		</TD>
<% if(!strUserRight.equals("") && Integer.parseInt(strUserRight) > 79) { %>
		<TD align="right" class="TableHeading" width="100">���H/�����G</TD>
		<TD>
			<select size="1" name="para_UserRight" id="para_UserRight">
				<option value="0">������</option>
				<option value="1">���H</option>
			</select>
		</TD>
<% } %>
	</TR>
</table>

<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBClmPayment.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBClmPayment.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="txtAction"	name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">

</FORM>
</BODY>
</HTML>