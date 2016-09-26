<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="../Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%!
/**
 * System   : 
 * 
 * Function : �ϥΪ̽L�I����
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.9 $
 * 
 * Author   : VANESSA
 * 
 * Create Date : 2006/9/26
 * 
 * Request ID : R60802-����CASH�t�Τ��ϥΪ̲M��Υ\��L�I����
 * 
 * CVS History:
 * 
 * $Log: UserMaintainReport.jsp,v $
 * Revision 1.9  2014/10/22 03:53:14  misariel
 * RC0402-�s�W����
 *
 * Revision 1.8  2014/07/18 07:38:43  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.7  2013/01/29 03:21:53  MISSALLY
 * EB0019 --- CASH�t�ΨϥΪ̽L�I����ק�
 *
 * Revision 1.6  2011/08/09 01:34:10  MISSALLY
 * Q10256�@ ����CASH�t�ο��~�L�k�]�X����
 *
 * Revision 1.5  2010/11/23 03:37:17  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.3  2006/12/15 03:51:20  MISVANESSA
 * R60903_�}��Ҧ�USER�ϥ�
 *
 * Revision 1.2  2006/11/02 10:08:50  MISVANESSA
 * R60903_�s�W��J����i���ӤH�ξ�ӳ���
 *
 * Revision 1.1  2006/09/27 02:14:24  MISVANESSA
 * R60802_�s�W�ϥΪ̲M��.�L�I����G��
 *  
 */
%><%! String strThisProgId = "UserMaintainReport"; //���{���N��%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = request.getParameter("txtMsg")!=null?request.getParameter("txtMsg"):"";
String strAction = request.getAttribute("txtAction")!=null?(String) request.getAttribute("txtAction"):"";
String strUserDept = session.getAttribute("LogonUserDept")!=null?CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept")):"";
String strUserRight = session.getAttribute("LogonUserRight")!=null?CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight")):"";
String strUserId = session.getAttribute("LogonUserId")!=null?CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")):"";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�ϥΪ̽L�I����</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
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
	if( document.getElementById("txtMsg").value != "" )
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' );
    window.status = "";
}

/*
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "../UserMaintain/UserMaintainReport.jsp";
}

/*
��ƦW��:	resetAction()
��ƥ\��:	��toolbar frame �����M�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
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
��ƦW��:	printRAction()
��ƥ\��:	��toolbar frame ����������s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function printRAction()
{	//R60903�}�񵹩Ҧ�USER
	var strActcode = 0;
	if(document.getElementById("txtUserDept").value != "MIS") 
	{
		if(document.getElementById("txtUserDept").value != document.getElementById("selUserDept").value)
		{
			alert("�z�u��C�L�ӤH�Ω��ݳ����v�����");
			strActcode = 1;
		}
	}
	if (strActcode == 0)
	{
		window.status = "";
		getReportInfo();
		WindowOnLoadCommon( document.title , '' , 'E','' ) ;
		document.getElementById("inquiryArea").style.display ="none";
   
		//User Check List
		if(document.frmMain.chkULR[0].checked)
		{
			document.getElementById("frmMain").target="_blank";
		    document.getElementById("frmMain").submit();
			
		}
		//User Function List
		if(document.frmMain.chkULR[1].checked)
		{
			document.getElementById("frmMain1").target="_blank";
			document.getElementById("frmMain1").submit();
		}
	}
}
function getReportInfo()
{    
	//User Check List
	if(document.frmMain.chkULR[0].checked)
	{
		var strSql = "SELECT U.DEPT,U.USRID,U.USRNAM,T.TYPNME,G.GRPNAM, U.USRAUTH FROM USER U";
		strSql += "  LEFT JOIN USERTYPE T ON  U.USRTYP = T.USRTYP LEFT JOIN FGROUP G ON U.DFTGRP = G.GRPID";
		//strSql += " WHERE 1=1 AND U.STAT='A' ORDER BY U.DEPT,U.USRID";
		strSql += " WHERE U.STAT<>'E' ";
		if (document.getElementById("selUserDept").value != "")
        {
          strSql += " AND U.DEPT = '" + document.getElementById("selUserDept").value + "' ";
        }
   		if (document.getElementById("txtUser").value != "")
        {
          strSql += " AND U.USRID = '" + document.getElementById("txtUser").value.toUpperCase() + "' ";
        }
   		strSql += " ORDER BY U.DEPT,U.USRID";
   		
  	    document.frmMain.ReportSQL.value = strSql;
	}
	//User Function List
	if(document.frmMain.chkULR[1].checked)
	{
		var strSql1 = "";
		//R60903 strSql1  = "SELECT U.DEPT, U.USRID, U.USRNAM, C.FUNNAM, R.FUNNAM AS FUNNAM1 FROM USER U JOIN GRPFUN G ON U.DFTGRP=G.GRPID JOIN FUNC C ON G.FUNID=C.FUNID";
		strSql1  = "SELECT U.DEPT, U.USRID, U.USRNAM, C.FUNNAM, T.TYPNME,P.GRPNAM, U.USRAUTH ";
		strSql1 += " FROM USER U JOIN GRPFUN G ON U.DFTGRP=G.GRPID JOIN FUNC C ON G.FUNID=C.FUNID";
		strSql1 += " LEFT JOIN USERTYPE T ON  U.USRTYP = T.USRTYP LEFT JOIN FGROUP P ON U.DFTGRP = P.GRPID";//R60903
        //R60903strSql1 += " LEFT OUTER JOIN (SELECT T.FUNUP, F.FUNID, F.FUNNAM FROM FUNC F JOIN FUNCTREE T ON T.FUNDWN=F.FUNID) R ON C.FUNID=R.FUNUP"; 
        //R60903strSql1 += " WHERE 1=1 AND U.STAT = 'A' ORDER BY U.DEPT, U.USRID";
        strSql1 += " WHERE U.STAT <> 'E' ";
        if (document.getElementById("selUserDept").value != "")
        {
          strSql1 += " AND U.DEPT = '" + document.getElementById("selUserDept").value + "' ";
        }
   		if (document.getElementById("txtUser").value != "")
        {
          strSql1 += " AND U.USRID = '" + document.getElementById("txtUser").value.toUpperCase() + "' ";
        }
        strSql1 += " ORDER BY U.DEPT, U.USRID";

		document.frmMain1.ReportSQL.value = strSql1;
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<form	action="../servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="452"  id=inquiryArea >
	<!--R60903�s�W��J�ӤH�γ���-->
	<TR>
		<TD class="TableHeading" >�п�J�C�L����G</TD>
		<TD colspan="2">
			<SELECT class="Data" id="selUserDept" name="selUserDept">
				<option value="">��������</option>
				<option value="MIS">MIS</option>
				<option value="FIN">FIN</option>
				<option value="ACCT">ACCT</option>
				<option value="CSC">CSC</option>
				<option value="NB">NB</option>
				<option value="PA">PA</option>
				<option value="GP">���I��F</option>
				<option value="GPH">���I�z��</option>
				<option value="CLM">���I�z��</option>
				<option value="080">080</option>
				<option value="CLH">���</option>
				<option value="MDS">MDS</option>
 <!--RC0402--> 	<option value="IA">�]��</option>
 <!--RC0402--> 	<option value="SPA">�~�ȳW����F�B</option>				
 <!--RC0036--> 	<option value="PCD">���O�B</option>
 <!--RC0036--> 	<option value="TYB">�������q</option>
 <!--RC0036--> 	<option value="TCB">�x�������q</option>
 <!--RC0036--> 	<option value="TNB">�x�n�����q</option>
 <!--RC0036--> 	<option value="KHB">���������q</option>
			</SELECT>
			<INPUT class="Data" size="14" type="text" maxlength="10" id="txtUser" name="txtUser" value=""><font color="red" size="2">(�ťեN�����)</font>
		</TD>
	</TR>
	<TR>
		<TD align="left" class="TableHeading" >�п�ܦC�L����G</TD>
		<TD><INPUT type="checkbox" id="chkULR" name="chkULR" value="UsrChkRpt" checked>User Check List</TD>
		<TD><INPUT type="checkbox" id="chkULR" name="chkULR" value="UsrFunRpt" checked>User Function List</TD>
	</TR>
</TABLE>
                                                                                       
<INPUT type="hidden" id="ReportName" name="ReportName" value="UserMaintainList1.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="UserMaintainList1.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>UserMaintain\\">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept"  value="<%=strUserDept%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">	
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">
</FORM>
<FORM action="../servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain1" method="post" name="frmMain1">
<INPUT type="hidden" id="ReportName" name="ReportName" value="UserMaintainList2.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="UserMaintainList2.pdf"> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>UserMaintain\\">
</FORM>
</BODY>
</HTML>