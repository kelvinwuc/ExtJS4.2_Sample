<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 出納匯款會計分錄
 * 
 * Remark   : 管理系統─財務
 * 
 * Revision : $Revision: 1.8 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  : 
 * 
 * CVS History:
 * 
 * $Log: DISBAccFinRmt.jsp,v $
 * Revision 1.8  2014/10/31 02:49:04  misariel
 * RC0036-新增急件的選項
 *
 * Revision 1.7  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */
%><%! String strThisProgId = "DISBAccFinRmt"; //本程式代號%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alCurrCash = new ArrayList();

if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
Hashtable htTemp = null;
String strValue = null;
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"\">&nbsp;</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equals("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}
	htTemp = null;
	strValue = null;
}
%>
<HTML>
<HEAD>
<TITLE>管理系統--出納匯款會計分錄</TITLE>
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
		window.alert(document.getElementById("txtMsg").value) ;
	}

	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyDown,'' );
	window.status = "";
}

function mapValue()
{
	document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value) ;	    	 
   	document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value) ;	   
	document.getElementById("txtPStartDate2").value = rocDate2String(document.getElementById("txtPStartDateC2").value) ;	//R80338    	 
   	document.getElementById("txtPEndDate2").value = rocDate2String(document.getElementById("txtPEndDateC2").value) ;	//R80338    	     
}

function DISBDownloadAction()
{
    mapValue();
    if( areAllFieldsOK() )
	{	 
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
	}	

	if( objThisItem.id == "txtPStartDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "出納確認日的起日不得為空白";
				bReturnStatus = false;
		} 
		else if( !isValidDate(objThisItem.value,'C') ) 
		{
		 	strTmpMsg = "出納確認日的起日 - 日期格式不正確";
			bReturnStatus = false;
		}
		else
		{
			if( document.getElementById("txtPEndDateC").value != "")
			{
				if (objThisItem.value  > document.getElementById("txtPEndDateC").value)
				{
				   	strTmpMsg = "出納確認日的起日不得大於迄日";
					bReturnStatus = false;
				}
			}
		}
	}
	else 	if( objThisItem.id == "txtPEndDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "出納確認日的迄日不得為空白";
				bReturnStatus = false;
		}
		else if( !isValidDate(objThisItem.value,'C') ) 
		{
		 	strTmpMsg = "出納確認日的迄日 - 日期格式不正確";
			bReturnStatus = false;
		}
		else
		{
			if( objThisItem.value != "" && document.getElementById("txtPStartDateC").value != "")
			{
				if (objThisItem.value  < document.getElementById("txtPStartDateC").value)
				{
				   	strTmpMsg = "出納確認日的起日不得大於迄日";
					bReturnStatus = false;
				}
			}
		}			
	}
	// R80338 支付確認日二(會計確認日)
	else 	if( objThisItem.id == "txtPStartDateC2" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "會計確認日的起日不得為空白";
				bReturnStatus = false;
		}
		else if( !isValidDate(objThisItem.value,'C') ) 
		{
		 	strTmpMsg = "會計確認日的起日 - 日期格式不正確";
			bReturnStatus = false;
		}
		else
		{
			if( objThisItem.value != "" && document.getElementById("txtPEndDateC2").value != "")
			{
				if (objThisItem.value  > document.getElementById("txtPEndDateC2").value)
				{
				   	strTmpMsg = "會計確認日的起日不得大於迄日";
					bReturnStatus = false;
				}
			}
		}			
	}	
	else 	if( objThisItem.id == "txtPEndDateC2" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "會計確認日的迄日不得為空白";
				bReturnStatus = false;
		}
		else if( !isValidDate(objThisItem.value,'C') ) 
		{
		 	strTmpMsg = "會計確認日的迄日 - 日期格式不正確";
			bReturnStatus = false;
		}
		else
		{
			if( objThisItem.value != "" && document.getElementById("txtPStartDateC2").value != "")
			{
				if (objThisItem.value  < document.getElementById("txtPStartDateC2").value)
				{
				   	strTmpMsg = "會計確認日的起日不得大於迄日";
					bReturnStatus = false;
				}
			}
		}			
	}		
	 else if (objThisItem.id =="selCurrency")
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "幣別不可空白";
				bReturnStatus = false;
		}	
	}
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBAccFinRmt.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBAccFinRmtServlet">
<br>
<TABLE border="1" width="452" id="inqueryArea">
	<TBODY>
		<TR>		
			<TD align="right" class="TableHeading" width="110">出納確認日：</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC" name="txtPStartDateC" value="" 
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT	type="hidden" name="txtPStartDate" id="txtPStartDate"	value="">
				 ~
				  <INPUT class="Data" size="11" type="text" maxlength="11"	id="txtPEndDateC" name="txtPEndDateC" value="" 	onblur="checkClientField(this,true);">
				   <a 	href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
				 <INPUT	type="hidden" name="txtPEndDate" id="txtPEndDate" value="">
			
			</TD>
		</TR>
		<TR>  <!-- R80338 支付確認日二 -->		
			<TD align="right" class="TableHeading" width="110">(會計)支付確認日：</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC2" name="txtPStartDateC2" value="" 
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT	type="hidden" name="txtPStartDate2" id="txtPStartDate2"	value="">
				 ~
				  <INPUT class="Data" size="11" type="text" maxlength="11"	id="txtPEndDateC2" name="txtPEndDateC2" value="" 	onblur="checkClientField(this,true);">
				   <a 	href="javascript:show_calendar('frmMain.txtPEndDateC2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
				 <INPUT	type="hidden" name="txtPEndDate2" id="txtPEndDate2" value="">
			
			</TD>
		</TR>
		<!-- RC0036 -->
		<TR>
			<TD align="right" class="TableHeading" width="110">急件否：</TD>
			<TD colspan=3 width="40">
				<select size="1" name="pDispatch" id="pDispatch">
					<option value="Y">是</option>
					<option value="" selected>否</option>
				</select>
			</TD>
		</TR>
    	<TR>
	        <TD align="right" class="TableHeading" width="110">保單幣別：</TD>
			<TD colspan=3 width="40">
				<select size="1" name="selCurrency" id="selCurrency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
		<TR> <!-- R80338 -->
	        <TD align="right" class="TableHeading" width="110">付款方式：</TD>
			<TD colspan=3 width="40">
			   <SELECT class="Data" id="PMethod" name="PMethod">
					<OPTION value="B">銀行匯款</OPTION>
					<OPTION value="D">外幣匯款</OPTION>
				</SELECT>
			</TD>
		</TR>    
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>