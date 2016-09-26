<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393       Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
 *    R00393       Leo Huang    			2010/09/23           ������|��۹���|
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
 * Revision : $Revision: 1.3 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2012/08/29 09:18:44 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBRemitReport.jsp,v $
 * Revision 1.3  2012/08/29 09:18:44  ODCKain
 * Character problem
 *
 * Revision 1.2  2010/11/23 02:51:38  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.1.2.4  2005/04/04 07:02:19  miselsa
 * R30530 ��I�t��
 *
 *  
 */
-->

<%! String strThisProgId = "DISBRemitReport"; //���{���N��%>
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

//DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
//R00393  Edit by Leo Huang (EASONTECH) Start
//java.util.Date dteToday = cldCalendar.getTime(); //�ثe����ɶ�
//R00393  Edit by Leo Huang (EASONTECH) end
//List alPSrcCode = new ArrayList();

//alPSrcCode = (List) disbBean.getETable("PAYCD", "");
String strReturnMessage = "";
if(request.getParameter("txtMsg") !=null)
{
	strReturnMessage = request.getParameter("txtMsg") ;
}
else
{
   strReturnMessage="";
}
%>
<HTML>
<HEAD>
<TITLE>�X�ǥ\��--�״ڳ���</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<!--R00393 edit by Leo Huang 
<LINK REL="stylesheet" TYPE="text/css"
	HREF="../../Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="../../Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="../../Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="../../Theme/global/custom.css">
<SCRIPT language="JavaScript" src="../../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../../ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../../ScriptLibrary/Calendar.js"></SCRIPT>
-->
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
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
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;
	
	// 93/04/01 added by Andy : �ˮָӨϥΪ̬O�_�������v��
//	var domServerInformation = getServerInformation("UserInfo",strProgId);
//	updatePrevilege(domServerInformation.getElementsByTagName(strProgId).item(0).text);
	// end of 93/04/01
	   	WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' ) ;
	    window.status = "";

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
{
  window.status = "";
    document.getElementById("txtAction").value = "L";
   document.getElementById("frmMain").submit();
}


</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<!--R00393  edit by Leo Huang start
<form
	action="/CashWeb/servlet/com.aegon.disb.disbreports.DISBPReportsServlet"
	id="frmMain" method="post" name="frmMain">
-->
<form	action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPReportsServlet"
	id="frmMain" method="post" name="frmMain">
<!--R00393  edit by Leo Huang end-->
<TABLE border="1" width="194" id=inqueryArea name=inqueryArea>
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="82">�״ڧ帹�G</TD>
			<TD width="104"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtPRemitNo" name="txtPRemitNo" value=""></TD>
		</TR>
	</TBODY>
</TABLE>


<INPUT name="txtPaySeq" id="txtPaySeq" type="hidden" value=""> <INPUT
	name="txtAction" id="txtAction" type="hidden"
	value="<%=request.getParameter("txtAction")%>"> <INPUT name="txtMsg"
	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>