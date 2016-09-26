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
 * Revision : $Revision: 1.5 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2013/12/24 03:40:20 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckRejected.jsp,v $
 * Revision 1.5  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.1  2006/06/29 09:40:44  MISangel
 * Init Project
 *
 * Revision 1.1.2.5  2005/04/25 10:03:26  MISANGEL
 * R30530:支付系統
 *
 * Revision 1.1.2.4  2005/04/04 07:02:23  miselsa
 * R30530 支付系統
 *
 *  
 */
-->

<%! String strThisProgId = "DISBCheckRejected"; //本程式代號%>
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
//java.util.Date dteToday = cldCalendar.getTime(); //目前日期時間
//R00393  Edit by Leo Huang (EASONTECH) End

//List alPSrcCode = new ArrayList();

//alPSrcCode = (List) disbBean.getETable("PAYCD", "");
 String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
    strReturnMessage = (String) request.getAttribute("txtMsg");
  }  
  
String strUserDept ="";
if (session.getAttribute("LogonUserDept") != null)
	strUserDept=(String)session.getAttribute("LogonUserDept");
if(!strUserDept.equals(""))
		strUserDept=strUserDept.trim();
		
String strUserRight ="";
if (session.getAttribute("LogonUserRight") != null)
	strUserRight=(String)session.getAttribute("LogonUserRight");
if(!strUserRight.equals(""))
		strUserRight=strUserRight.trim();		

String strUserId ="";
if (session.getAttribute("LogonUserId") != null)
	strUserId=(String)session.getAttribute("LogonUserId");
if(!strUserId.equals(""))
		strUserId=strUserId.trim();

%>
<HTML>
<HEAD>
<TITLE>支付功能--票據退回</TITLE>
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
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
	{
		window.alert(document.getElementById("txtMsg").value) ;
	}
		
	if (document.getElementById("txtAction").value == "I")
	{
	   WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInquiry,'' ) ;
        document.getElementById("updateArea").style.display = "block"; 
	  //  document.getElementById("inqueryArea").style.display = "none"; 
	    disableKey();
	    disableData();
	}
	else
	{
	    document.getElementById("inqueryArea").display = "block"; 
	   	document.getElementById("updateArea").display = "none"; 
	   	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;
        enableKey();
	    enableData();	    	   	
	    window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
	}

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
 	if( document.getElementById("txtAction").value == "I" )
	{
	  var strSql = "";
	  strSql = "SELECT CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_BOOK_NO,CHEQUE_NO,CHEQUE_NAME,CHEQUE_AMOUNT,CAST(CHEQUE_DATE AS CHAR(7)) AS CHEQUE_DATE ,CAST(CASH_DATE AS CHAR(7)) AS CASH_DATE,CHEQUE_STATUS FROM CAPCHKF  A left outer JOIN USER B ON B.USRID=A.ENTRY_USER WHERE 1=1" ;
	  
	  if( document.getElementById("txtChequeNo").value != "" ) {
			strSql += " AND CHEQUE_NO like '^" + document.getElementById("txtChequeNo").value + "^' ";
	  }
	  
	     strSql +=" AND B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";  
	  var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=820";
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","銀行代碼,銀行帳號,票據批號,票據號碼,抬頭,金額,到期日,狀態日,狀態");
	session.setAttribute("DisplayFields", "CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_BOOK_NO,CHEQUE_NO,CHEQUE_NAME,CHEQUE_AMOUNT,CHEQUE_DATE,CASH_DATE,CHEQUE_STATUS");
	session.setAttribute("ReturnFields", "CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_BOOK_NO,CHEQUE_NO,CHEQUE_NAME,CHEQUE_AMOUNT,CHEQUE_DATE,CASH_DATE,CHEQUE_STATUS,ENTRY_DATE,ENTRY_TIME,ENTRY_USER");
%>
	 //modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
	  var strReturnValue = window.showModalDialog("<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
		
	  if( strReturnValue != "" )
		{
			//enableAll();
		var returnArray = string2Array(strReturnValue,",");
		document.getElementById("txtCBKNo").value = returnArray[0];
	    document.getElementById("txtCAccount").value = returnArray[1];
	    document.getElementById("txtCBNo").value = returnArray[2];
	    document.getElementById("txtCNo").value = returnArray[3];
	    document.getElementById("txtCNM").value = returnArray[4];
	    document.getElementById("txtCAMT").value = returnArray[5];
	    document.getElementById("txtChequeDt").value = returnArray[6];
	    document.getElementById("txtCashDt").value = returnArray[7];
	    document.getElementById("txtCStatus").value = returnArray[8];
	    
	    if (document.getElementById("txtCStatus").value == "D") {	  
          // document.getElementById("txtAction").value = "DISBCRejected";        
           WindowOnLoadCommon( document.title+"(票據退回)" , '' , strDISBFunctionKeyCR,'' ) ;
        } else
        { 
          WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyExit,'' );
        }
        
        disableAll(); 
	    document.getElementById("updateArea").style.display = "block"; 
	    document.getElementById("inqueryArea").style.display = "none"; 
	    }
	}	
}


/*
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	enableAll();
	//R00393 edit by Leo Huang
	//window.location.href= "/CashWeb/DISB/DISBCheck/DISBCheckRejected.jsp";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckRejected.jsp";
}

/*
函數名稱:	DISBCRejectedAction()
函數功能:	當toolbar frame 中之[票據退回]按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function DISBCRejectedAction()
{
   	var bConfirm = window.confirm("確定退回票據?");
	if( bConfirm )
	{
		//enableAll();
		document.getElementById("txtAction").value = "DISBCRejected";
		document.getElementById("frmMain").submit();
	}
}


</SCRIPT>
</HEAD>

<BODY ONLOAD="WindowOnLoad()">
<!-- R00393 edit by Leo Huang 
<form
	action="/CashWeb/servlet/com.aegon.disb.disbcheck.DISBCheckRejectedServlet"
	id="frmMain" method="post" name="frmMain">-->
<form	action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckRejectedServlet"
	id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="304" id=inqueryArea
	name=inqueryArea>
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="108">支票號碼：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11"
				name="txtChequeNo" id="txtChequeNo" value="" ></TD>
		</TR>
	</TBODY>
</TABLE>

<TABLE border="1" width="302" id=updateArea name=updateArea
	style="display: none">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="91">銀行行庫：</TD>
			<TD width="195">
			<INPUT class="DATA" size="17" type="text" maxlength="25"
				name="txtCBKNo" id="txtCBKNo" value="" readonly></TD>
	</TR>
		<TR>
			<TD align="left" class="TableHeading" width="91" height="21">銀行帳號：</TD>
			<TD width="195" height="21">
			<INPUT class="DATA" size="17" type="text" maxlength="25"
				name="txtCAccount" id="txtCAccount" value="" readonly ></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="91">票據批號：</TD>
			<TD width="195">
			<INPUT class="DATA" size="17" type="text" maxlength="25"
				name="txtCBNo" id="txtCBNo" value="" readonly ></TD>	
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="91">票據號碼：</TD>
			<TD width="195">
			<INPUT class="DATA" size="17" type="text" maxlength="25"
				name="txtCNO" id="txtCNO" value="" readonly ></TD>
	
		</TR>

		<TR>
			<TD align="left" class="TableHeading" width="91">票據抬頭：</TD>
			<TD width="195">
			<INPUT class="DATA" size="17" type="text" maxlength="25"
				name="txtCNM" id="txtCNM" value="" readonly></TD>
	
		</TR>

		<TR>
			<TD align="left" class="TableHeading" width="91">票面金額：</TD>
			<TD width="195">
			<INPUT class="DATA" size="17" type="text" maxlength="25"
				name="txtCAMT" id="txtCAMT" value="" readonly></TD>
	
		</TR>

		<TR>
			<TD align="left" class="TableHeading" width="91">到期日：</TD>
			<TD width="195">
			<INPUT class="DATA" size="17" type="text" maxlength="25"
				name="txtChequeDt" id="txtChequeDt" value="" readonly ></TD>
	
		</TR>

		<TR>
			<TD align="left" class="TableHeading" width="91">狀態日：</TD>
			<TD width="195">
			<INPUT class="DATA" size="17" type="text" maxlength="25"
				name="txtCashDt" id="txtCashDt" readonly></TD>
	
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="91">支票狀態：</TD>
			<TD width="195">
			<INPUT class="DATA" size="17" type="text" maxlength="1"
				name="txtCStatus" id="txtCStatus" value="" readonly></TD>
	
		</TR>
	
	</TBODY>
</TABLE>

<INPUT name="txtPaySeq" id="txtPaySeq" type="hidden" value=""> <INPUT
	name="txtAction" id="txtAction" type="hidden"
	value="<%=request.getParameter("txtAction")%>"> <INPUT name="txtMsg"
	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
<INPUT name="txtUserDept" 	id="txtUserDept" type="hidden" value="<%=strUserDept%>">
<INPUT name="txtUserRight" 	id="txtUserRight" type="hidden" value="<%=strUserRight%>">	
<INPUT name="txtUserId" 	id="txtUserId" type="hidden" value="<%=strUserId%>">		
</FORM>
</BODY>
</HTML>