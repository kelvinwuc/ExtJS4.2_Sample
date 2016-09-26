<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393      Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
 *    R00393      Leo Huang    			2010/09/23           ������|��۹���|
 *  =============================================================================
 */
%>
<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.DbFactory" %>

<%//R00393%>
<!--# include virtual="/Logon/Init.inc"-->
<!--# include virtual="/Logon/CheckLogonDISB.inc"-->
<!--
/*
 * System   : 
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.4 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2012/08/29 09:18:43 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPaymentNotice.jsp,v $
 * Revision 1.4  2012/08/29 09:18:43  ODCKain
 * Character problem
 *
 * Revision 1.3  2010/11/23 02:51:38  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.1  2006/06/29 09:40:41  MISangel
 * Init Project
 *
 * Revision 1.1.2.7  2005/04/12 08:16:31  miselsa
 * R30530_�[�W�����v��
 *
 * Revision 1.1.2.6  2005/04/04 07:02:20  miselsa
 * R30530 ��I�t��
 *
 *  
 */
-->
<%!String strThisProgId = "DISBPaymentNotice"; //���{���N��%>
<%
//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
SimpleDateFormat sdfDateFormatter =
	new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", java.util.Locale.TAIWAN);
SimpleDateFormat sdfDate =
	new SimpleDateFormat("yyyyMMdd", java.util.Locale.TAIWAN);
SimpleDateFormat sdfTime =
	new SimpleDateFormat("hhmmss", java.util.Locale.TAIWAN);

GlobalEnviron globalEnviron =
	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
//R00393  Edit by Leo Huang (EASONTECH) Start
//java.util.Date dteToday = cldCalendar.getTime(); //�ثe����ɶ�
//R00393  Edit by Leo Huang (EASONTECH) end
String strReturnMessage = "";
if (request.getParameter("txtMsg") != null) {
	strReturnMessage = request.getParameter("txtMsg");
} else {
	strReturnMessage = "";
}

String strUserDept = "";
if (session.getAttribute("LogonUserDept") != null)
	strUserDept = (String) session.getAttribute("LogonUserDept");
if (!strUserDept.equals(""))
	strUserDept = strUserDept.trim();

String strUserRight = "";
if (session.getAttribute("LogonUserRight") != null)
	strUserRight = (String) session.getAttribute("LogonUserRight");
if (!strUserRight.equals(""))
	strUserRight = strUserRight.trim();
%>
<HTML>
<HEAD>
<TITLE>���I�q����</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript"
	src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript"
	src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript"
	src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">

// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function WindowOnLoad(){
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;
		
	//R90665 if(document.getElementById("txtUserDept").value != "CSC" )
	//R90665 {
	//R90665	alert("�L���榹�����v��");
	//R90665	window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	//R90665 }
	//R90665 else
	//R90665{	
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;
  		 window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
    //R90665 }
}

/*
��ƦW��:	inquiryAction()
��ƥ\��:	��toolbar frame �����d�߫��s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function inquiryAction(){
	document.frmMain.submit();	
}

</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<!--R00393  edit by Leo Huang start
<form
	action="/CashWeb/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=query"
	id="frmMain" method="post" name="frmMain" target="iframe">
	-->
<form
	action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=query"
	id="frmMain" method="post" name="frmMain" target="iframe">
<!--R00393  edit by Leo Huang end-->	

<TABLE border="1" width="514">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="108">�O�渹�X�G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11"
				name="POLICYNO" id="POLICYNO" value=""></TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT name="txtPaySeq" id="txtPaySeq" type="hidden" value=""> <INPUT
	name="txtAction" id="txtAction" type="hidden"
	value="<%=request.getParameter("txtAction")%>"> <INPUT name="txtMsg"
	id="txtMsg" type="hidden" value="<%=strReturnMessage%>"> <INPUT
	name="txtUserDept" id="txtUserDept" type="hidden"
	value="<%=strUserDept%>"> <INPUT name="txtUserRight" id="txtUserRight"
	type="hidden" value="<%=strUserRight%>"></FORM>
<IFRAME name="iframe" width="100%" frameborder="0" height="88%">
</BODY>
</HTML>
