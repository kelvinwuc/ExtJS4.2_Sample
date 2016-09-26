<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 支票異動會計分錄
 * 
 * Remark   : 管理系統─財務
 * 
 * Revision : $Revision: 1.8 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: DISBCStatusAccCode.jsp,v $
 * Revision 1.8  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 * Revision 1.3  2006/08/25 05:57:15  miselsa
 * Q60159_增加 2-> V ,R->V,R->4會計分錄
 *
 * Revision 1.2  2006/08/14 08:13:41  miselsa
 * Q60159_會計分錄借貸方向錯誤及新增醫調票作廢的會計分錄
 *
 * Revision 1.1  2006/06/29 09:40:14  MISangel
 * Init Project
 *
 * Revision 1.1.2.4  2005/11/03 08:32:15  misangel
 * R50820:支付功能提升-取消支票到期日限制
 *
 * Revision 1.1.2.3  2005/04/25 07:24:48  miselsa
 * R30530
 *
 * Revision 1.1.2.2  2005/04/04 07:02:25  miselsa
 * R30530 支付系統
 *  
 */
%><%! String strThisProgId = "DISBCStatusAccCode"; //本程式代號%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	
%>
<HTML>
<HEAD>
<TITLE>管理系統--支票異動會計分錄</TITLE>
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
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" )
	{
		window.alert(document.getElementById("txtMsg").value);
	}

	WindowOnLoadCommon( document.title, '', strDISBFunctionKeyDown, '' );
	window.status = "";
}

function mapValue(){
	document.getElementById("txtCheqDtS").value = rocDate2String(document.getElementById("txtCheqDtSC").value) ;	 
	document.getElementById("txtCheqDtE").value = rocDate2String(document.getElementById("txtCheqDtEC").value) ;	 	      	 
   	document.getElementById("txtUpdDt").value = rocDate2String(document.getElementById("txtUpdDtC").value) ;	    	 
}

function DISBDownloadAction()
{
    mapValue();
 	document.getElementById("frmMain").submit();
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBCStatusAccCode.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBCStatusAccCdServlet">
<br>
<TABLE border="1" width="452" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="151">票據狀態異動日期：</TD>
			<TD colspan=3 width="347"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtUpdDtC" name="txtUpdDtC" value="" readOnly> <a
				href="javascript:show_calendar('frmMain.txtUpdDtC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT type="hidden" name="txtUpdDt" id="txtUpdDt" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="151">票據到期日：</TD>
			<TD colspan=3 width="347"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtCheqDtSC" name="txtCheqDtSC" value="" readOnly> <a
				href="javascript:show_calendar('frmMain.txtCheqDtSC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT	type="hidden" name="txtCheqDtS" id="txtCheqDtS" value="">
			   ~
			   <INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtCheqDtEC" name="txtCheqDtEC" value="" readOnly> <a
				href="javascript:show_calendar('frmMain.txtCheqDtEC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT	type="hidden" name="txtCheqDtE" id="txtCheqDtE" value="">
			</TD>
		</TR>		
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>