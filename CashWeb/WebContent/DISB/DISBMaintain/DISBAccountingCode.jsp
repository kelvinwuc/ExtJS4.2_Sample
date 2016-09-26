<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393     Leo Huang    			2010/09/21           現在時間取Capsil營運時間
 *   R00393       Leo Huang    			2010/09/21           絕對路徑轉相對路徑
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
 * Revision : $Revision: 1.7 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2013/12/24 03:44:07 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBAccountingCode.jsp,v $
 * Revision 1.7  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.4  2012/05/18 09:49:51  MISSALLY
 * R10314 CASH系統會計作業修改
 *
 * Revision 1.3  2010/11/23 02:21:59  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.2  2008/08/06 06:01:30  MISODIN
 * R80132 調整CASH系統for 6種幣別
 *
 * Revision 1.1  2006/06/29 09:40:14  MISangel
 * Init Project
 *
 * Revision 1.1.2.5  2006/04/27 09:38:42  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.4  2005/04/25 07:24:48  miselsa
 * R30530
 *
 * Revision 1.1.2.3  2005/04/04 07:02:25  miselsa
 * R30530 支付系統
 *
 *  
 */
-->

<%! String strThisProgId = "DISBAccountingCode"; //本程式代號%>
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
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	
	
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
//R00393  Edit by Leo Huang (EASONTECH) Start
//java.util.Date dteToday = cldCalendar.getTime(); //目前日期時間
//R00393  Edit by Leo Huang (EASONTECH) End
//List alPSrcCode = new ArrayList();

//alPSrcCode = (List) disbBean.getETable("PAYCD", "");

List alCurrCash = new ArrayList(); //R80132 幣別挑選

if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}
else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}//R80132 END

  
  String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
    strReturnMessage = (String) request.getAttribute("txtMsg");
  }  
  
%>
<HTML>
<HEAD>
<TITLE>管理系統--財務會計分錄</TITLE>
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
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">

var strFirstKey 			= "txtUserId";			//第一個可輸入之Key欄位名稱
var strFirstData 			= "txtPassword";		//第一個可輸入之Data欄位名稱
var strServerProgram 			= "UserMaintainS.jsp";		//Post至Server時,要呼叫之程式名稱

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
	if( document.getElementById("txtMsg").value != "" )
	{
		window.alert(document.getElementById("txtMsg").value) ;
	//	document.getElementById("btnDownload").style.display="block"; 
	//	document.getElementById("btnExit").style.display="none";
	//	document.getElementById("inqueryArea").style.display="block"; 
	}
	
	   	WindowOnLoadCommon( document.title , '' , '','' ) ;
	    window.status = "";

}

function mapValue(){
	document.getElementById("txtEntryStartDate").value 
	   	= rocDate2String(document.getElementById("txtEntryStartDateC").value) ;	    	 
	document.getElementById("txtPStartDate").value 
	   	= rocDate2String(document.getElementById("txtPStartDateC").value) ;	    	   
}
function DISBDownloadAction()
{
    mapValue();
    if( areAllFieldsOK() )
	{	
	  // 	document.getElementById("btnDownload").style.display="none"; 
	//	document.getElementById("btnExit").style.display="block";
	//	document.getElementById("inqueryArea").style.display="none"; 
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}
/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
	}	
	if( objThisItem.id == "txtEntryStartDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "輸入日期不得為空白";
				bReturnStatus = false;
		}
	}
	else	if( objThisItem.id == "txtPStartDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "支付確認日不得為空白";
				bReturnStatus = false;
		}
	} else if (objThisItem.id =="selCurrency")
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "保單幣別不可空白";
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
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<!--R00393  Edit by Leo Huang (EASONTECH) Start
<form
	action="/CashWeb/servlet/com.aegon.disb.disbmaintain.DISBAccCodeServlet"
	id="frmMain" method="post" name="frmMain">
<input type=button onclick="DISBDownloadAction()" name="btnDownload" id="btnDownload" value="下載">	
<input type=button onclick="window.location.href= '/CashWeb/DISB/DISBMaintain/DISBAccountingCode.jsp' ;" name="btnExit" id="btnExit" value="離開">
-->
<form
	action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBAccCodeServlet"
	id="frmMain" method="post" name="frmMain">
<input type=button onclick="DISBDownloadAction()" name="btnDownload" id="btnDownload" value="下載">	
<input type=button onclick="window.location.href= '<%=request.getContextPath()%>/DISB/DISBMaintain/DISBAccountingCode.jsp' ;" name="btnExit" id="btnExit" value="離開">
<!--R00393  Edit by Leo Huang (EASONTECH) End-->
<br>
<br>
<TABLE border="1" width="452" id=inqueryArea name=inqueryArea>
	<TBODY>
<TR>
			<TD align="right" class="TableHeading" width="110">輸入日期：</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate" value=""> 
			</TD>
	</tr>
	<tr>		
			<TD align="right" class="TableHeading" width="110">支付確認日：</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC" name="txtPStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT	type="hidden" name="txtPStartDate" id="txtPStartDate"	value="">		
			</TD>
	</tr>		
    <TR>
	        <TD align="right" class="TableHeading" width="110">保單幣別：</TD>
			<TD colspan=3 width="40"><select size="1" name="selCurrency" id="selCurrency">
			<option value=""></option>
			<!--  <option value="NT">NT</option>
			<option value="US">US</option>  -->
			<% //R80132
				 if (alCurrCash.size() > 0) {
				     for (int i = 0; i < alCurrCash.size(); i++) {
				       	Hashtable htCurrCashTemp = (Hashtable) alCurrCash.get(i);
				        String strETValue = (String) htCurrCashTemp.get("ETValue");
		            	out.println("<option value="+ strETValue+ ">"+ strETValue+"</option>");
			            }
			       	}
			     else 
			       {
				   out.println("<option value=''></option>");
				   }
				%>										
			</select></TD>							
    
    </TR>
	</TBODY>
</TABLE>

<INPUT name="txtAction" id="txtAction" type="hidden" value=""> 
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>