<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : �Ȥ��I�ک��ӳ���
 * 
 * Remark   : DISBDailyHReports.rpt
 *            �Ȥ��I�ھl�B�� (FINACCT�i�d�Ҧ����/��l���v��)
 *            �e���Ȥ��I�ھl�B��/���w�I�ک��Ӫ�/���I���ڧ@�o���Ӫ�/�������Ӫ�(�ȴ��ѵ�FIN�ϥ�)
 * 
 * Revision : $Revision: 1.11 $
 * 
 * Author   : $Author: MISSALLY $
 * 
 * Create Date : $Date: 2013/12/26 01:28:15 $
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DISBDailyHReports.jsp,v $
 * Revision 1.11  2013/12/26 01:28:15  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{�� --- BugFix ���}���s�L�k�ϥ�
 *
 * Revision 1.10  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.8  2011/10/21 10:04:35  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 *  
 */
%><%! String strThisProgId = "DISBDailyHReports"; //���{���N��%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")):"";

CommonUtil commonUtil = new CommonUtil(globalEnviron);	
Calendar calendar  = commonUtil.getBizDateByRCalendar();
int  iCurrentDate =Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(calendar.getTime()));		

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);//R80132

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

List alCurrCash = new ArrayList(); //R80132 ���O�D��

if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}
else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}//R80132 END
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
<TITLE>�Ȥ��I�ک��ӳ���</TITLE>
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
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value);
    WindowOnLoadCommon( document.title, '', strFunctionKeyReport, '' );
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
	window.status = "";
	mapValue();
	if(document.getElementById("para_Reports").value == "ALL") 
	{
		document.getElementById("para_Reports").value = "A";
		getReportInfo();
		document.getElementById("txtAction").value = "L";
		WindowOnLoadCommon( document.title, '', 'E', '' );
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("para_Reports").value = "B";
		getReportInfoB();
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("para_Reports").value = "C";
		getReportInfoC();
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("para_Reports").value = "D";
		getReportInfoD();
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("para_Reports").value = "E";
		getReportInfoE();
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();

		document.getElementById("txtAction").value = "";
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyHReports.jsp";
	} 
	else 
	{
		//�Ȥ��I�ھl�B��
		if(document.getElementById("para_Reports").value == "A") {
			getReportInfo();
		//�e���Ȥ��I�ھl�B��
		} else if(document.getElementById("para_Reports").value == "B") {
			getReportInfoB();
		//���w�I�ک��Ӫ�
		} else if(document.getElementById("para_Reports").value == "C") {
			getReportInfoC();
		// R80822
		//���I���ڧ@�o���Ӫ�
		} else if(document.getElementById("para_Reports").value == "D") {
			getReportInfoD();
		//�������Ӫ�
		} else if(document.getElementById("para_Reports").value == "E") {
			getReportInfoE();
		}
	
		document.getElementById("txtAction").value = "L";
		WindowOnLoadCommon( document.title, '', 'E', '' );
		document.getElementById("frmMain").target = "_blank";
		document.getElementById("frmMain").submit();
	}
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
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyHReports.jsp";
}

//�Ȥ��I�ھl�B��
function getReportInfo()
{
	var strSql = "SELECT A.* ";
	strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";
	strSql += " from CAPPAYF A ";
    strSql += " left outer join USER B  on B.USRID = A.ENTRY_USER ";
	strSql += " WHERE A.PAY_VOIDABLE = '' ";	//R80822

	// ����:FIN, �i�d�Ҧ����
	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")	 // R80244
	{
		strSql += " AND (A.PAY_CONFIRM_DATE1 = 0 OR A.PAY_CONFIRM_DATE2 = 0) "; 
	}
	//�v����89��,�i�d�������
	else if( document.getElementById("txtUserRight").value > "79" )  // R80244	
	{
		strSql += " AND B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
		strSql += " AND A.PAY_CONFIRM_DATE1 = 0 and PAY_CONFIRM_TIME1=0 and PAY_CONFIRM_USER1='' ";
	}
	//�v����79��,�i�d�ۤv���
	else 
	{
		strSql += " AND A.ENTRY_USER ='"+ document.getElementById("txtUserID").value +"'  ";
		strSql += " AND A.PAY_CONFIRM_DATE1 = 0 and PAY_CONFIRM_TIME1=0 and PAY_CONFIRM_USER1='' ";
	}

	if ( document.getElementById("Para_EntryDate").value != "" ) {
		strSql += " AND A.ENTRY_DATE <= "+ document.getElementById("para_EntryDate").value;
	}
	if ( document.getElementById("Para_Currency").value != "" ) {
		strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'";
	}

    document.getElementById("ReportSQL").value = strSql;
}

// R70600 �e���Ȥ��}�����Ӫ�
function getReportInfoB()
{
	var strSql = "";

	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")
	{
		strSql = "SELECT A.* ";
		strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";		
		strSql += " from CAPPAYF A ";
	    strSql += "  left outer join USER B  on B.USRID = A.ENTRY_USER ";
		strSql += " WHERE A.PAY_VOIDABLE = ''"; //R80822		
		strSql += " AND A.PAY_CONFIRM_DATE1 <> 0 AND  A.PAY_CONFIRM_DATE2 <> 0 AND A.PAY_DISPATCH <> 'Y' ";
		strSql += " AND A.PAY_SOURCE_GROUP <>'WB' "; 
		strSql += " AND A.PAY_NO NOT IN (SELECT C.PNOH FROM CAPPAYF C WHERE C.PNOH <> '')"; // �ư��װh�󪺭�l��
		strSql += " AND A.PAY_SOURCE_CODE NOT IN ('D2','H1','S1')"; 	//R80799�[�JS1

		if ( document.getElementById("para_CFMDate").value != "" ) {
			strSql += " AND A.PAY_CONFIRM_DATE2 = "+ document.getElementById("para_CFMDate").value;
		}  			
        if ( document.getElementById("Para_EntryDate").value != "" ) {
        	strSql += " AND A.ENTRY_DATE < "+ document.getElementById("para_EntryDate").value;
		}  
        if ( document.getElementById("Para_Currency").value != "" ) {
        	strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'";
		}
	}

    document.getElementById("ReportSQL").value = strSql;
}

// R70600 ���w�}�����Ӫ�
function getReportInfoC()
{
	var strSql = "";

	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")
	{
		strSql = "SELECT A.* ";
		strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";		
		strSql += " from CAPPAYF A ";
	    strSql += "  left outer join USER B  on B.USRID = A.ENTRY_USER ";
		strSql += " WHERE A.PAY_VOIDABLE = ''"; //R80822		
		strSql += " AND A.PAY_CONFIRM_DATE1 <> 0 AND  A.PAY_CONFIRM_DATE2 <> 0 AND A.PAY_DISPATCH = 'Y' ";

		if ( document.getElementById("para_CFMDate").value != "" ) {  //R80822
			strSql += " AND A.PAY_CONFIRM_DATE2 <> "+ document.getElementById("para_CFMDate").value ;  //R80822
		}  //R80822
		if ( document.getElementById("Para_EntryDate").value != "" ) {
			strSql += " AND A.ENTRY_DATE = "+ document.getElementById("para_EntryDate").value ;
		}
		if (document.getElementById("Para_Currency").value != "" ) {
			strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'" ;
		}
	}

    document.getElementById("ReportSQL").value = strSql;
}

// R80822 ���I���ڧ@�o���Ӫ�
function getReportInfoD()
{
	var strSql = "";

	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")
	{
		strSql = "SELECT A.* ";
		strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";		
		strSql += " from CAPPAYF A ";
	    strSql += "  left outer join USER B  on B.USRID = A.ENTRY_USER ";
		strSql += " WHERE A.PAY_VOIDABLE = 'Y'";

		if (document.getElementById("Para_EntryDate").value != "" ) {
			strSql += " AND A.ENTRY_DATE = "+ document.getElementById("para_EntryDate").value ;
		}
		if (document.getElementById("Para_Currency").value != "" ) {
			strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'" ;
		}
	}

    document.getElementById("ReportSQL").value = strSql;
}

// R80822 �������Ӫ�
function getReportInfoE()
{
	var strSql = "";

	if (document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")
	{
		strSql = "SELECT A.* ";
		strSql += ",B.DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT ";		
		strSql += " from CAPPAYF A ";
	    strSql += "  left outer join USER B  on B.USRID = A.ENTRY_USER ";
		strSql += " WHERE A.PAY_VOIDABLE = ''";
		strSql += " AND A.PAY_CONFIRM_DATE1 <> 0 AND  A.PAY_CONFIRM_DATE2 <> 0 AND A.PAY_DISPATCH = 'Y' ";

		if (document.getElementById("para_CFMDate").value != "" ) {
			strSql += " AND A.PAY_CONFIRM_DATE2 = "+ document.getElementById("para_CFMDate").value ;
		}
		if (document.getElementById("Para_EntryDate").value != "" ) {
			strSql += " AND A.ENTRY_DATE = "+ document.getElementById("para_EntryDate").value ;
		}
		if (document.getElementById("Para_Currency").value != "" ) {
			strSql += " AND A.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value + "'" ;
		}
	}

    document.getElementById("ReportSQL").value = strSql;
}

function mapValue()
{
	if(document.getElementById("txtEntryDateC").value !="") {
		document.getElementById("para_EntryDate").value = rocDate2String(document.getElementById("txtEntryDateC").value) ;
	}
	if(document.getElementById("txtCFMDateC").value !="") {
		document.getElementById("para_CFMDate").value = rocDate2String(document.getElementById("txtCFMDateC").value) ;
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS"	id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="400"  id=BatchArea>
	<TR>
		<TD align="right" class="TableHeading" width="100">��J����G</TD>
		<TD width="150">
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryDateC" name="txtEntryDateC" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtEntryDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
			<INPUT type="hidden" name="para_EntryDate" id="para_EntryDate"	value="">
	    </TD>
		<TD align="right" class="TableHeading" width="50">���O�G</TD>
		<TD width="50" valign="middle">
			<select size="1" name="para_Currency" id="para_Currency">
				<%=sbCurrCash.toString()%>
			</select>
		</TD>
	</TR>		
    <!--R70600-->    
	<TR>
		<TD align="right" class="TableHeading">��I�T�{��G</TD>
		<TD>
			<INPUT class="Data" size="11" type="text" maxlength="11"id="txtCFMDateC" name="txtCFMDateC" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtCFMDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
			<INPUT type="hidden" name="para_CFMDate" id="para_CFMDate" value="">
		</TD>
		<TD colspan="2" rowspan="2">&nbsp;</TD>
	</TR>    
	<TR>
		<TD align="right" class="TableHeading">�п�ܳ���G</TD>
		<TD valign="middle">
			<select size="1" name="para_Reports" id="para_Reports">
			<% if(strUserDept.equals("ACCT") || strUserDept.equals("FIN")) { %>
				<option value="ALL">����</option>
				<option value="A">�Ȥ��I�ھl�B��</option>
				<option value="B">�e���Ȥ��I�ھl�B��</option>
				<option value="C">���w�I�ک��Ӫ�</option>
				<option value="D">���I���ڧ@�o���Ӫ�</option>
				<option value="E">�������Ӫ�</option>
			<% } else { %>
				<option value="A">�Ȥ��I�ھl�B��</option>
			<% } %>
			</select>
		</TD>
	</TR>
</TABLE>      

<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyHReports.rpt">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBDailyHReports.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">	
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">	
</form>
</BODY>
</HTML>

