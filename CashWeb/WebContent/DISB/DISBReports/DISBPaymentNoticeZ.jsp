<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393     Leo Huang    			2010/09/20           現在時間取Capsil營運時間
 *    R00393       Leo Huang    			2010/09/23           絕對路徑轉相對路徑
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

<%@ include file="../../Logon/Init.inc" %>
<%@ include file="../../Logon/CheckLogonDISB.inc" %>
<!--
/*
 * System   : 
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.6 $
 * 
 * Author   : ODIN  TSAI
 * 
 * Create Date : $Date: 2012/08/29 09:18:43 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 *  
 */
-->
<%!String strThisProgId = "DISBPaymentNoticeZ"; //本程式代號%>
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
//java.util.Date dteToday = cldCalendar.getTime(); //目前日期時間
//R00393  Edit by Leo Huang (EASONTECH) End
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
<TITLE>給付通知書實付零</TITLE>
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
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function WindowOnLoad(){
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;
		
	//R90665 if(document.getElementById("txtUserDept").value != "CSC" )
	//R90665 {
	//R90665	alert("無執行此報表權限");
	//R90665	window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	//R90665 }
	//R90665 else
	//R90665 {	
		//WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;	
	   	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial1,'' ) ;// 新增A+查詢I		
  		 window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
    //R90665 }
}

/*
函數名稱:	inquiryAction()
函數功能:	當toolbar frame 中之查詢按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function inquiryAction()
{
	document.getElementById("txtAction").value = "queryZ";	
    document.getElementById("frmMain").submit();   
}
/*
函數名稱:	addAction()
函數功能:	當toolbar frame 中之<新增>按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function addAction()//ADD CAPSIL R90172
{
    document.getElementById("txtAction").value = "add";	
    document.getElementById("frmMain").submit();    
}
//function addFAction()//ADD FF R90172
//{
    //document.getElementById("txtAction").value = "addF";	
    //document.getElementById("frmMain").submit();    
//}
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<!--R00393  edit by Leo Huang start
<form action="/CashWeb/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet" id="frmMain" method="post" name="frmMain" target="iframe">
-->
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet" id="frmMain" method="post" name="frmMain" target="iframe">
<!--R00393  edit by Leo Huang end-->
<TABLE border="1" width="514">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="108">保單號碼：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="POLICYNO" id="POLICYNO" value=""></TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT name="txtPaySeq" id="txtPaySeq" type="hidden" value=""> 
<INPUT name="txtAction" id="txtAction" type="hidden"	value="<%=request.getParameter("txtAction")%>">
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
<INPUT name="txtUserDept" id="txtUserDept" type="hidden"	value="<%=strUserDept%>"> 
<INPUT name="txtUserRight" id="txtUserRight"	type="hidden" value="<%=strUserRight%>">
</FORM>
<IFRAME name="iframe" width="100%" frameborder="0" height="88%">
</BODY>
</HTML>
