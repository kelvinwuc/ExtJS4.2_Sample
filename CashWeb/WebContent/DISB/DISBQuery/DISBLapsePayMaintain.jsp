<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 失效給付通知書維護
 * 
 * Remark   : 支付查詢
 * 
 * Revision : $Revision: 1.2 $
 * 
 * Author   : zhejun.he
 * 
 * Create Date : 2013/02/27
 * 
 * Request ID  : R10190
 * 
 * CVS History :
 * $$Log: DISBLapsePayMaintain.jsp,v $
 * $Revision 1.2  2013/12/24 03:48:55  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.1  2013/05/02 11:07:05  MISSALLY
 * $R10190 美元失效保單作業
 * $$
 *  
 */
%><%! String strThisProgId = "DISBLapsePayMaintain"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();

String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")):"";
String strUserId = (session.getAttribute("LogonUserId") != null) ? CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")) : "";

String strReturnMessage = (request.getAttribute("txtMsg") != null) ? (String)request.getAttribute("txtMsg") : "";
String strAction = (request.getAttribute("txtAction") != null) ? (String) request.getAttribute("txtAction") : "";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>支付查詢--失效給付通知書維護</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script language="javascript">
<!--
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if(!("<%=strUserDept%>" == "CSC" && <%=strUserRight%> == 89)) {
		alert("無權限執行此功能！");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}

	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' );
	document.getElementById("inqueryArea").style.display = "block";

	if ( document.getElementById("txtAction").value == "U" ) {
		WindowOnLoadCommon( document.title , '' , strFunctionKeyUpdate,'' );//儲存S+離開E
        document.getElementById("updateArea").style.display = "block";
        document.getElementById("inqueryArea").style.display = "none";
	}
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBQuery/DISBLapsePayMaintain.jsp?";
}

/* 當toolbar frame 中之<修改>按鈕被點選時,本函數會被執行 */
function updateAction()
{
	enableData();
	WindowOnLoadCommon( document.title, '', strFunctionKeyUpdate, '' );// 儲存S+離開E
}

/* 當toolbar frame 中之<儲存>按鈕被點選時,本函數會被執行 */
function saveAction()
{
	document.getElementById("txtAction").value = "S";

	document.getElementById("txtUSend").value = document.getElementById("txtUSend").value.toUpperCase();
	var strUSend = document.getElementById("txtUSend").value;
	if(strUSend == "" || !(strUSend == "Y" || strUSend == "N")) {
		alert("欄位【是否寄送】不得為空值僅能輸入Y或N！");
		return false;
	}

	enableAll();
	document.getElementById("frmMain").submit();
}

/* 當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行 */
function inquiryAction()
{
	var flag = 0;
	if(document.getElementById("txtPoid").value == "") {
		flag ++;
	}
	if(document.getElementById("txtPbenid").value == "") {
		flag ++;
	}
	if(document.getElementById("txtPbenName").value == "") {
		flag ++;
	}
	if(document.getElementById("txtPStartDateC").value == "" && document.getElementById("txtPEndDateC").value == "") {
		flag ++;
	}
	var varMsg = "";
	if(flag == 4 ) {
		varMsg = "最少要指定一個查詢條件！\n\r";
	}
	if(document.getElementById("txtPStartDateC").value != "" && document.getElementById("txtPEndDateC").value == "") {
		varMsg += "請輸入出納確認日(迄)\n\r";
	}
	if(document.getElementById("txtPStartDateC").value == "" && document.getElementById("txtPEndDateC").value != "") {
		varMsg += "請輸入出納確認日(起)";
	}

	if(varMsg != "")
	{
		alert(varMsg);
		return false;
	}

	mapValue();

	if( document.getElementById("txtAction").value == "I" )
	{
		/*	執行 QueryFrameSet.jsp 時,各 QueryString 參數之意義
			RowPerPage		: 每一頁有幾列
			Heading			: 表頭欄位名稱,以逗號','分開每一欄位
			DisplayFields	: 要顯示之資料庫欄位名稱,以逗號分開每一欄位,與Heading相對應
			ReturnFields	: 傳回哪些欄位之值,以逗號分開每一欄位
			Sql				: 待執行之SQL,亦可加入where條件
			TableWidth		: 整個Table之寬度
		 modalDialog 會傳回使用者選定之用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開
		*/

		var strSql = "SELECT FLD0010,FLD0020,FLD0030,FLD0040,FLD0050,CAST(FLD0060 as CHAR(7)) as FLD0060,FLD0070,FLD0080,CAST(FLD0090 as CHAR(7)) as FLD0090,FLD0100,CAST(FLD0110 as CHAR(7)) as FLD0110 from ORCHLPPY where 1=1 ";

		if( document.getElementById("txtPoid").value != "" ) {
			strSql += " AND FLD0020 = '" + document.getElementById("txtPoid").value + "' ";
		}
		if( document.getElementById("txtPbenid").value != "" ) {
			strSql += "  AND  FLD0030= '" + document.getElementById("txtPbenid").value + "' ";
		}
		if( document.getElementById("txtPbenName").value != "" ) {
			strSql += "  AND FLD0040 like '^" +  document.getElementById("txtPbenName").value + "^' ";
		}
		if( document.getElementById("txtPStartDate").value != "" ) {
			strSql += "  AND FLD0060 >= '" +  document.getElementById("txtPStartDate").value + "' ";
		}
		if( document.getElementById("txtPEndDate").value != "" ){
			strSql += "  AND FLD0060 <= '" +  document.getElementById("txtPEndDate").value + "' ";
		}
		strSql += " ORDER BY FLD0020,FLD0060 ";

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=820";
		<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	    session.setAttribute("Heading","保單號碼,受款人ID,受款人姓名,支付序號,金額,出納確認日,寄送日期,是否寄送,已寄送，但退匯");
	    session.setAttribute("DisplayFields", "FLD0020,FLD0030,FLD0040,FLD0010,FLD0050,FLD0060,FLD0090,FLD0070,FLD0080");
	    session.setAttribute("ReturnFields", "FLD0010,FLD0020,FLD0030,FLD0040,FLD0050,FLD0060,FLD0070,FLD0080,FLD0090,FLD0100,FLD0110");
	    %>
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" )
		{
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtUPno").value = returnArray[0];
			document.getElementById("txtUPoid").value = returnArray[1];			
			document.getElementById("txtUPbenid").value = returnArray[2];
			document.getElementById("txtUPbenName").value = returnArray[3];
			document.getElementById("txtUPamt").value = returnArray[4];
			document.getElementById("txtUProcDate").value = returnArray[5];			
			document.getElementById("txtUSend").value = returnArray[6];
			document.getElementById("txtURercv").value = returnArray[7];
			document.getElementById("txtUSendDate").value = returnArray[8];
			document.getElementById("txtUUpdateUser").value = returnArray[9];
			document.getElementById("txtUUpdateDate").value = returnArray[10];

			if(returnArray[8] > 0) {
				WindowOnLoadCommon( document.title, '', strDISBFunctionKeyExit, '' );
			} else {
				WindowOnLoadCommon( document.title, '', strDISBFunctionKeySourceU, '' );
			}

			disableAll();
	        document.getElementById("updateArea").style.display = "block"; 
	        document.getElementById("inqueryArea").style.display = "none";
		}
	}
}

function mapValue()
{
	document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value) ;
	document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value) ;	
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbquery.DISBLapsePayServlet">
<TABLE border="1" width="452"  id=inqueryArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">保單號碼：</TD>
			<TD><INPUT class="Data" size="10" type="text" maxlength="10" width="333" id="txtPoid" name="txtPoid" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">受益人ID：</TD>
			<TD width="333"><INPUT class="Data" size="10" type="text" maxlength="10" id="txtPbenid" name="txtPbenid" value=""></TD>
		<TR>
			<TD align="right" class="TableHeading" width="101">受益人姓名：</TD>
			<TD width="333"><INPUT class="Data" size="10" type="text" id="txtPbenName" name="txtPbenName" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">出納確認日：</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPStartDateC" name="txtPStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> 
				<INPUT type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> 
				~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC" name="txtPEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> 
				<INPUT type="hidden" name="txtPEndDate" id="txtPEndDate" value="">
			</TD>
		</TR>
	</TBODY>
</TABLE>

<TABLE border="1" width="600" id=updateArea style="display:none">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" >保單號碼：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtUPoid" name="txtUPoid" readonly="readonly"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >受益人ID：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtUPbenid" name="txtUPbenid" readonly="readonly"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >受益人姓名：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtUPbenName" name="txtUPbenName" readonly="readonly"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >支付序號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtUPno" name="txtUPno" readonly="readonly"></TD>
		</TR>		
		<TR>
			<TD align="right" class="TableHeading" >金額：</TD>
			<TD ><INPUT class="INPUT_DISPLAY" type="text" id="txtUPamt" name="txtUPamt" readonly="readonly"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >出納確認日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtUProcDate" name="txtUProcDate" readonly="readonly"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >寄送日期：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtUSendDate" name="txtUSendDate" readonly="readonly"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >已寄送，但退匯：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtURercv" name="txtURercv" readonly="readonly"></TD>
		</TR>		
		<TR>
			<TD align="right" class="TableHeading" >是否寄送：</TD>
			<TD><INPUT class="Data" maxlength=1 size="2" type="text" id="txtUSend" name="txtUSend" style="text-transform: uppercase;"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >異動者：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtUUpdateUser" name="txtUUpdateUser" readonly="readonly"></TD>
		</TR>		
		<TR>
			<TD align="right" class="TableHeading" >異動日期：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtUUpdateDate" name="txtUUpdateDate" readonly="readonly"></TD>
		</TR>		
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>"> 
</FORM>
</BODY>
</HTML>
