<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393       Leo Huang    			2010/09/20           現在時間取Capsil營運時間
 *   R00393       Leo Huang    			2010/09/23           絕對路徑轉相對路徑
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
 * Author   : VANESSA LIAO
 * 
 * Create Date : $Date: 2012/08/29 09:18:47 $
 * 
 * Request ID : R80300
 * 
 * CVS History:
 * 
 * $Log: DISBRemitCreditBack.jsp,v $
 * Revision 1.3  2012/08/29 09:18:47  ODCKain
 * Character problem
 *
 * Revision 1.2  2010/11/23 02:39:10  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.1  2008/06/12 09:43:36  misvanessa
 * R80300_收單行轉台新,新增上傳檔案及報表
 *
 *  
 */
-->
<%! String strThisProgId = "DISBRemitCreditBack"; //本程式代號%>
<%

//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
SimpleDateFormat sdfDateFormatter =	new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", java.util.Locale.TAIWAN);
SimpleDateFormat sdfDate =	new SimpleDateFormat("yyyyMMdd", java.util.Locale.TAIWAN);
SimpleDateFormat sdfTime =	new SimpleDateFormat("hhmmss", java.util.Locale.TAIWAN);

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = "";
if(request.getParameter("txtMsg") !=null){
	strReturnMessage = request.getParameter("txtMsg") ;
}
else{
   strReturnMessage="";
}
 
String strAction = "";
if (request.getAttribute("txtAction") != null) {
    strAction = (String) request.getAttribute("txtAction");
}
  
String para_Count = "";  
if (request.getAttribute("para_Count") != null) {
    para_Count = (String) request.getAttribute("para_Count");
  } 
  
String ActionTarget = "servlet/DISBRemitCreditBackS"; 
%>
<HTML>
<HEAD>
<TITLE>信用卡回覆檔案-上傳&報表作業</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT>
function WindowOnLoad() 
{
  	if (document.getElementById("txtAction").value == "showPRT") {
		window.alert("成功上傳 : " + document.getElementById("para_Count").value + " 筆") ;
		WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' ) ;
	}	
  	else
  	{
		strFunctionKeyInitial = "";			//
		WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
		window.status = "";
		document.frmMain.action="/CashWeb/<%= ActionTarget %>";	
	}
}
function printRAction(){
	getReportInfo();
	document.getElementById("frmMain1").target="_blank";
	document.getElementById("frmMain1").submit();
}
function getReportInfo()
{
    var ReportSQL = "";
	var strSql = "";

    strSql = "SELECT A.PNO, A.PAMT, A.PDATE, A.BDATE, A.STUS, B.POLICYNO, B.PAMT, B.PCSHDT, B.PCFMUSR1, B.PCRDNO";
	strSql += ", CASE WHEN A.STUS = '00' THEN 'S' ELSE 'F' END SUSTYPE ";
    strSql += " FROM CAPPAY812 A ";
    strSql += " LEFT OUTER JOIN CAPPAYF B ON A.PNO = B.PNO";
    strSql += " ORDER BY SUSTYPE";
	document.frmMain1.ReportSQL.value = strSql;

}
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad()">
<FORM action=""	id="frmMain" method="post" name="frmMain" enctype="multipart/form-data" >
<TABLE border="0">
	<TBODY>
		<TR>
			<TD bgcolor="#8080ff"><font color="white">信用卡回覆檔案上傳報表&作業</font></TD>
		</TR>
	</TBODY>
</TABLE>
檔案名稱:<BR>
	<INPUT TYPE='FILE' name='upload0'><BR>
	<BR>
<INPUT TYPE="hidden" NAME="ProgId" VALUE="<%= strThisProgId %>"> 
<INPUT TYPE="hidden" NAME="para_Count" VALUE="<%= para_Count %>">
<INPUT TYPE=SUBMIT  VALUE='上傳'> <INPUT TYPE=RESET VALUE='清除'><BR>
<INPUT name="txtMsg" id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
<INPUT name="txtAction" id="txtAction" type="hidden"	value="<%=strAction%>">
</FORM>
<!--R00393  edit by Leo Huang Start
<FORM action="/CashWeb/servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain1" method="post" name="frmMain1">
-->
<FORM action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain1" method="post" name="frmMain1">
<!--R00393  edit by Leo Huang end-->
<INPUT id="ReportName" name="ReportName" type="hidden" value="DISBRemitCardBackRpt.rpt"> 
<INPUT id="OutputType" name="OutputType" type="hidden" value="PDF"> 
<!--R00393
<INPUT id="ReportPath" type="hidden" name="ReportPath"	value="D:\\WAS5App\\CashWeb.ear\\CashWeb.war\\DISB\\DISBReports\\"> 
-->
<INPUT id="ReportPath" type="hidden" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
<INPUT id="OutputFileName" name="OutputFileName" type="hidden" value="DISBRemitCardBackRpt.pdf"> 
<INPUT id="ReportSQL" type="hidden" name="ReportSQL" value=""> 
</FORM>
</BODY>
</HTML>
