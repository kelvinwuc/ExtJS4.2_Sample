<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393       Leo Huang    			2010/09/20           現在時間取Capsil營運時間
 *  =============================================================================
 */
%>
<%@ page language="java" contentType="text/html; charset=CP950" pageEncoding="CP950" %>
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
 * Revision : $Revision: 1.6 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2013/12/24 03:55:46 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBRemitExport.jsp,v $
 * Revision 1.6  2013/12/24 03:55:46  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.2  2006/09/04 09:47:07  miselsa
 * R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 *
 * Revision 1.1  2006/06/29 09:39:46  MISangel
 * Init Project
 *
 * Revision 1.1.2.4  2005/04/04 07:02:25  miselsa
 * R30530 支付系統
 *
 *  
 */
-->
<%! String strThisProgId = "DISBRemitExport"; //本程式代號%>
<%

//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
SimpleDateFormat sdfDateFormatter =	new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", java.util.Locale.TAIWAN);
SimpleDateFormat sdfDate =	new SimpleDateFormat("yyyyMMdd", java.util.Locale.TAIWAN);
SimpleDateFormat sdfTime =	new SimpleDateFormat("hhmmss", java.util.Locale.TAIWAN);

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = "";
if(request.getParameter("txtMsg") !=null){
	strReturnMessage = request.getParameter("txtMsg") ;
}
else{
   strReturnMessage="";
}
%>
<HTML>
<HEAD>
<TITLE>出納功能--匯出</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
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
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;
	
	// 93/04/01 added by Andy : 檢核該使用者是否有相關權限
//	var domServerInformation = getServerInformation("UserInfo",strProgId);
//	updatePrevilege(domServerInformation.getElementsByTagName(strProgId).item(0).text);
	// end of 93/04/01
	   	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;
	    window.status = "";

}
/*
函數名稱:	inquiryAction()
函數功能:	當toolbar frame 中之查詢按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function inquiryAction(){

/*	if(document.frmMain.PCSHDT.value==""){
		return false;
	}
*/	
	
	if( checkClientField( document.getElementById("PCSHCM"), true ) )
		document.frmMain.submit();
}
/*
函數名稱:	printRAction()
函數功能:	當toolbar frame 中之報表按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function printRAction(){
  window.status = "";
  document.getElementById("txtAction").value = "L";
  document.getElementById("frmMain").submit();
}


// --------
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "PCSHCM"  ) {
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
        	strTmpMsg = "出納確認日期-日期格式有誤";
        	bReturnStatus = false;			
        }
	}
	
	
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg += strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}


</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<form
	action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitExportServlet?action=query"
	id="frmMain" method="post" name="frmMain">

<TABLE border="1" width="307" id=inqueryArea1 name=inqueryArea1>
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="125">出納確認日期：</TD>
			<TD width="174"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="PCSHCM" name="PCSHCM" onblur="checkClientField(this,true);"> 
				<a
				href="javascript:show_calendar('frmMain.PCSHCM','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" width="24"
				height="21"></a> <!--INPUT type="hidden" name="PCSHCMC" id="PCSHCMC" value=""--></TD>
		</TR>
	</TBODY>
</TABLE>

<INPUT name="txtPaySeq" id="txtPaySeq" type="hidden" value=""> 
<INPUT name="txtAction" id="txtAction" type="hidden" value="<%=request.getParameter("txtAction")%>"> 
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>