<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%!
/**
 * System   : 
 * 
 * Function : 使用者資料維護
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.10 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date: ${date}
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: UserMaintainC.jsp,v $
 * Revision 1.10  2014/07/18 07:38:25  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.9  2013/12/24 04:17:10  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.8  2013/01/09 03:28:12  MISSALLY
 * 1.Calendar problem
 * 2.showModalDialog
 *
 * Revision 1.7  2013/01/08 04:25:58  MISSALLY
 * 將分支的程式Merge至HEAD
 *
 * Revision 1.3.4.1  2012/12/06 06:28:29  MISSALLY
 * RA0102　PA0041
 * 配合法令修改酬佣支付作業
 *
 * Revision 1.3  2011/08/31 07:28:19  MISSALLY
 * R10231
 * CASH系統新增各項理賠給付明細表
 *
 * Revision 1.2  2011/08/09 01:34:10  MISSALLY
 * Q10256　 有關CASH系統錯誤無法跑出報表
 *
 *  
 */
%><%
String strMsg = request.getParameter("txtMsg")==null?"":request.getParameter("txtMsg");
CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
Calendar  calendar = commonUtil.getBizDateByRCalendar();

Connection conn = null;
Statement stmt = null;
PreparedStatement pstmt = null;
ResultSet rst = null;
StringBuffer sbUserType = new StringBuffer();
StringBuffer sbGroup = new StringBuffer();

String strAction = request.getParameter("txtAction");
if( strAction == null )
	strAction = "";
String strUserId = request.getParameter("txtUserId");
if( strUserId == null )
	strUserId = "";
String strUserName = "";
String strUserStatus = "";
String strUserType = "";
String strDefaultGroup = "";
String strUserDept = "";
String strUserRight = "";
String strRemark = "";
String strEmail = "";
String strPasswordValidDay = "";
String strUserStatusDate = "";
String strLastPasswordDate = "";
String strRegDate = "";
String strLastLogonDate = "";
String strORGLastPasswordDate = "";
/*RC0036*/
String strUserArea = "";
String strUserBrch = "";

try {
	conn = uiThisUserInfo.getDbFactory().getConnection("UserMaintain");

	if(strAction.equalsIgnoreCase("I"))	//查詢
	{
		pstmt = conn.prepareStatement("select * from USER where USRID = ? ");
		pstmt.setString(1, strUserId);
		rst = pstmt.executeQuery();
		if( !rst.next() ) {
			strMsg = "使用者代號 '"+strUserId+"' 未存在於資料庫中";
		} else {
			strUserName = CommonUtil.AllTrim(rst.getString("USRNAM"));
			strUserStatus = CommonUtil.AllTrim(rst.getString("STAT"));
			strUserType = CommonUtil.AllTrim(rst.getString("USRTYP"));
			strDefaultGroup = CommonUtil.AllTrim(rst.getString("DFTGRP"));
			strUserDept = CommonUtil.AllTrim(rst.getString("DEPT"));
			strUserRight = CommonUtil.AllTrim(rst.getString("USRAUTH"));
			strRemark = CommonUtil.AllTrim(rst.getString("REMARK"));
			strEmail = CommonUtil.AllTrim(rst.getString("Email"));
			strPasswordValidDay = CommonUtil.AllTrim(rst.getString("PWDVAL"));
			strUserStatusDate = CommonUtil.AllTrim(rst.getString("STSDTE"));
			strLastPasswordDate = CommonUtil.AllTrim(rst.getString("LPWDTE"));
			strRegDate = CommonUtil.AllTrim(rst.getString("REGDTE"));
			strLastLogonDate = CommonUtil.AllTrim(rst.getString("LLOGD"));
			strUserArea = CommonUtil.AllTrim(rst.getString("USRAREA")); //RC0036
			strUserBrch = CommonUtil.AllTrim(rst.getString("USRBRCH")); //RC0036
			strORGLastPasswordDate = strLastLogonDate;
		}
	}

	stmt = conn.createStatement();
	rst = stmt.executeQuery("select * from USERTYPE");
	while (rst.next()) {
		if(CommonUtil.AllTrim(rst.getString("USRTYP")).equalsIgnoreCase(strUserType))
			sbUserType.append("<option value=\"").append(rst.getString("USRTYP")).append("\" selected=\"selected\">").append(rst.getString("TYPNME")).append("</option>");
		else
			sbUserType.append("<option value=\"").append(rst.getString("USRTYP")).append("\">").append(rst.getString("TYPNME")).append("</option>");
	}

	rst = stmt.executeQuery("select * from FGROUP");
	while (rst.next()) {
		if(CommonUtil.AllTrim(rst.getString("GRPID")).equalsIgnoreCase(strDefaultGroup))
			sbGroup.append("<option value=\"").append(rst.getString("GRPID")).append("\" selected=\"selected\">").append(rst.getString("GRPNAM")).append("</option>");
		else
			sbGroup.append("<option value=\"").append(rst.getString("GRPID")).append("\">").append(rst.getString("GRPNAM")).append("</option>");
	}
} catch (SQLException ex) {
	System.err.println(ex);
} finally {
	try { if(rst != null) rst.close(); } catch (Exception e) { }
	try { if(pstmt != null) pstmt.close(); } catch (Exception e) { }
	try { if(stmt != null) stmt.close(); } catch (Exception e) { }
	try { if(conn != null) uiThisUserInfo.getDbFactory().releaseConnection(conn); } catch (Exception e) { }
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<META http-equiv="Content-Style-Type" content="text/css">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>使用者資料維護</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 			= "txtUserId";			//第一個可輸入之Key欄位名稱
var strFirstData 			= "txtPassword";		//第一個可輸入之Data欄位名稱

//*************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" ) {
		window.alert(document.getElementById("txtMsg").value);
		document.getElementById("txtMsg").value = "";
	}

	if( document.getElementById("txtAction").value == "I" ) {
		WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry,'' ) ;
		window.status = "目前為查詢狀態,若要修改或刪除資料,請先選擇修改或刪除功能鍵";
	} else {
		WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' );
		window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
	}
	disableAll();
}

/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtUserId" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg += "使用者代號不可空白\r\n";
				bReturnStatus = false;
			}
		}
	}
	if( objThisItem.name == "txtPasswordConfirm" )
	{
		if( objThisItem.value != document.all("txtPassword").value )
		{
			strTmpMsg += "確認使用者密碼必須與使用者密碼相同\r\n";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "txtPasswdValidDays" )
	{
		if( objThisItem.value == "" )
		{
			objThisItem.value = "0";
		}
		var i=0;
		for(i=0;i<objThisItem.value.length;i++)
		{
			if( objThisItem.value.charAt(i) > '9'  || objThisItem.value.charAt(i) < '0' )
			{
				strTmpMsg += "密碼有效日數必須為數字\r\n";
				bReturnStatus = false;
			}
		}
	}
	if( objThisItem.name == "selUserType" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg += "請選擇使用者類別\r\n";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "selDefaultGroup" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg += "請選擇功能群組\r\n";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "selUserDept" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg += "請選擇使用者部門\r\n";
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

/*
函數名稱:	addAction()
函數功能:	當toolbar frame 中之新增按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function addAction()
{
	var dteDate = new Date();
	strOut =  "0000"+ (dteDate.getFullYear() - 1911) + "/" ;
	strOut = strOut.substring(strOut.length-4,strOut.length);
	if( dteDate.getMonth() + 1 < 10 ) {
		strOut += "0"+(dteDate.getMonth()+1)+"/";
	} else {
		strOut += (dteDate.getMonth()+1)+"/";
	}
	if( dteDate.getDate() < 10 ) {
		strOut += "0"+dteDate.getDate();
	} else {
		strOut += dteDate.getDate();
	}

	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
	document.getElementById("txtAction").value = "A";
	// 給予預設值
	document.getElementById("txtUserStatusDate").value = strOut;
	document.getElementById("txtRegDate").value = strOut;
	//設定為空白, 強迫下次Logon需修改密碼
	document.getElementById("txtLastPasswordDate").value = "";

	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/*
函數名稱:	inquiryAction()
函數功能:	當toolbar frame 中之查詢按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function inquiryAction()
{
	winToolBar.ShowButton( strFunctionKeyInquiry1 );
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus();
	}
}

/*
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/*
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值    :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	WindowOnLoad();
}

/*
函數名稱:	confirmAction()
函數功能:	當toolbar frame 中之確定按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function confirmAction()
{
	if( document.getElementById("txtAction").value == "I" )
	{
		/*	執行 QueryFrameSet.jsp 時,各 QueryString 參數之意義
			RowPerPage		: 每一頁有幾列
			Heading			: 表頭欄位名稱,以逗號','分開每一欄位
			DisplayFields	: 要顯示之資料庫欄位名稱,以逗號分開每一欄位,與Heading相對應
			ReturnFields	: 傳回哪些欄位之值,以逗號分開每一欄位
			Sql				: 待執行之SQL,亦可加入where條件
			TableWidth		: 整個Table之寬度

		 modalDialog 會傳回使用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開
		*/
		var strSql = "select * from USER where 1 = 1 ";
		if( document.getElementById("txtUserId").value != "" )
			strSql += " and USRID = '"+document.getElementById("txtUserId").value.toUpperCase() +"' ";
		if( document.getElementById("txtUserName").value != "" )
			strSql += " and USRNAM = '"+document.getElementById("txtUserName").value +"' ";

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","使用者代號,使用者姓名,群組代號,最近登錄日期");
	session.setAttribute("DisplayFields", "USRID,USRNAM,DFTGRP,LLOGD");
	session.setAttribute("ReturnFields", "USRID");
%>
		//modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		if( strReturnValue != "" )
		{
			enableAll();
			document.getElementById("txtUserId").value = strReturnValue;
			document.getElementById("txtAction").value = "I";
			document.getElementById("frmMain").action = "UserMaintainC.jsp";
			document.getElementById("frmMain").submit();
		}
	}
}

/*
函數名稱:	updateAction()
函數功能:	當toolbar frame 中之修改按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );
	disableKey();
	enableData();
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstData) != null )
			document.getElementById(strFirstData).focus() ;
	}
	document.getElementById("txtAction").value = "U";
}

/*
函數名稱:	saveAction()
函數功能:	當toolbar frame 中之儲存按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function saveAction()
{
	enableAll();
	if( areAllFieldsOK() )
	{
		document.getElementById("txtUserId").value = document.getElementById("txtUserId").value.toUpperCase();
		document.getElementById("frmMain").action = "UserMaintainS.jsp";
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}

/*
函數名稱:	deleteAction()
函數功能:	當toolbar frame 中之刪除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function deleteAction()
{
	var bConfirm = window.confirm("是否確定刪除該筆資料?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "D";
		document.getElementById("frmMain").action = "UserMaintainS.jsp";
		document.getElementById("frmMain").submit();
	}
}
//-->
</script>
</head>
<body onload="WindowOnLoad();">
<form id="frmMain" name="frmMain" method="post" action="">
<CENTER>
<TABLE width="630" border="1">
	<TBODY>
    	<TR>
        	<TD width="120" align="right" class="TableHeading">使用者代號：</TD>
            <TD width="200" align="left"><INPUT class="Key" size="10" type="text" maxlength="10" id="txtUserId" name="txtUserId"  value="<%=strUserId%>" onblur="checkClientField(this,true);"></TD>
            <TD width="160" align="right" class="TableHeading">使用者密碼：</TD>
            <TD width="150" align="left"><INPUT  class="Data" size="12" type="password" maxlength="12" id="txtPassword" name="txtPassword"  value=""  onblur="checkClientField(this,true);"></TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">使用者名稱：</TD>
            <TD align="left"><INPUT  class="Data" size="18" type="text" maxlength="30" id="txtUserName" name="txtUserName"  value="<%=strUserName%>"  onblur="checkClientField(this,true);"></TD>
            <TD align="right" class="TableHeading">確認使用者密碼：</TD>
            <TD align="left"><INPUT  class="Data" size="12" type="password" maxlength="12" id="txtPasswordConfirm" name="txtPasswordConfirm"  value=""  onblur="checkClientField(this,true);"></TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">使用者狀態：</TD>
            <TD align="left">
            	<INPUT  class="Data" type="radio" id="radUserStatus" name="radUserStatus" value="A"  onblur="checkClientField(this,true);"  <%=strUserStatus.equalsIgnoreCase("A")?"checked=\"checked\"":""%>>正常 
            	<INPUT  class="Data" type="radio" id="radUserStatus" name="radUserStatus"  value="I"  onblur="checkClientField(this,true);"  <%=strUserStatus.equalsIgnoreCase("I")?"checked=\"checked\"":""%>>失效
            	<BR><INPUT  class="Data" type="radio" id="radUserStatus" name="radUserStatus"  value="R"  onblur="checkClientField(this,true);"  <%=strUserStatus.equalsIgnoreCase("R")?"checked=\"checked\"":""%>>註冊中
            	<input  class="Data" type="radio" id="radUserStatus" name="radUserStatus"  value="E"  onBlur="checkClientField(this,true);"  <%=strUserStatus.equalsIgnoreCase("E")?"checked=\"checked\"":""%>>離職
            </TD>
            <TD align="right" class="TableHeading">狀態生效日期:</TD>
            <TD align="left"><INPUT  class="Data" size="10" type="text" maxlength="10" id="txtUserStatusDate" name="txtUserStatusDate"  readonly value="<%=strUserStatusDate%>"  onblur="checkClientField(this,true);"></TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">密碼有效日數:</TD>
            <TD align="left"><INPUT class="Data" size="3" type="text" maxlength="4" id="txtPasswordValidDay" name="txtPasswordValidDay"  value="30"  onblur="checkClientField(this,true);"></TD>
            <TD align="right" class="TableHeading">最近密碼修改日期：</TD>
            <TD align="left">
            	<INPUT  class="Data" size="10" type="text" maxlength="10" id="txtLastPasswordDate" name="txtLastPasswordDate"  readonly value="<%=strLastPasswordDate%>"  onblur="checkClientField(this,true);">
            	<a href="javascript:show_calendar('frmMain.txtLastPasswordDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');" ><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
            </TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">使用者類別：</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserType" name="selUserType">
            		<option value="">請選擇</option>
            		<%=sbUserType.toString()%>
            	</SELECT>
            </TD>
            <TD align="right" class="TableHeading">註冊日期:</TD>
            <TD align="left">
            	<INPUT class="Data" size="10" type="text" maxlength="10" id="txtRegDate" name="txtRegDate"  value="<%=strRegDate%>"  onblur="checkClientField(this,true);">
            	<a href="javascript:show_calendar('frmMain.txtRegDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');" ><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
            </TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">功能群組：</TD>
            <TD align="left">
            	<SELECT class="Data" id="selDefaultGroup" name="selDefaultGroup">
            		<option value="">請選擇</option>
            		<%=sbGroup.toString()%>
            	</SELECT>
            </TD>
            <TD  align="right" class="TableHeading">支付資料查詢權限:</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserRight" name="selUserRight">
            		<option value="99" <%=strUserRight.equalsIgnoreCase("99")?"selected=\"selected\"":""%>>所有資料</option>
            		<option value="89" <%=strUserRight.equalsIgnoreCase("89")?"selected=\"selected\"":""%>>所屬部門資料</option>
            		<option value="79" <%=strUserRight.equalsIgnoreCase("79")?"selected=\"selected\"":""%>>所屬輸入人員資料</option>
            	</SELECT>
            </TD>
        </TR>
        <TR>
            <TD  align="right" class="TableHeading">使用者部門：</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserDept" name="selUserDept">
            		<option value="">請選擇</option>
            	  	<option value="MIS" <%=strUserDept.equalsIgnoreCase("MIS")?"selected=\"selected\"":""%>>MIS</option>
            		<option value="FIN" <%=strUserDept.equalsIgnoreCase("FIN")?"selected=\"selected\"":""%>>FIN</option>
            		<option value="ACCT" <%=strUserDept.equalsIgnoreCase("ACCT")?"selected=\"selected\"":""%>>ACCT</option>            		
            		<option value="CSC" <%=strUserDept.equalsIgnoreCase("CSC")?"selected=\"selected\"":""%>>CSC</option>
            		<option value="NB" <%=strUserDept.equalsIgnoreCase("NB")?"selected=\"selected\"":""%>>NB</option>
            		<option value="PA" <%=strUserDept.equalsIgnoreCase("PA")?"selected=\"selected\"":""%>>PA</option>
            		<option value="GP" <%=strUserDept.equalsIgnoreCase("GP")?"selected=\"selected\"":""%>>團險行政</option>
            		<option value="GPH" <%=strUserDept.equalsIgnoreCase("GPH")?"selected=\"selected\"":""%>>團險理賠</option>
            		<option value="CLM" <%=strUserDept.equalsIgnoreCase("CLM")?"selected=\"selected\"":""%>>個險理賠</option>
            		<option value="080" <%=strUserDept.equalsIgnoreCase("080")?"selected=\"selected\"":""%>>080</option>
            		<option value="CLH" <%=strUserDept.equalsIgnoreCase("CLH")?"selected=\"selected\"":""%>>醫調</option>
            		<option value="MDS" <%=strUserDept.equalsIgnoreCase("MDS")?"selected=\"selected\"":""%>>MDS</option>
            		<option value="IA" <%=strUserDept.equalsIgnoreCase("IA")?"selected=\"selected\"":""%>>稽核</option>
            		<option value="SPA" <%=strUserDept.equalsIgnoreCase("SPA")?"selected=\"selected\"":""%>>業務規劃行政處</option>
<!--RC0036-->    	<option value="PCD" <%=strUserDept.equalsIgnoreCase("PCD")?"selected=\"selected\"":""%>>收費處</option>
<!--RC0036-->       <option value="TYB" <%=strUserDept.equalsIgnoreCase("TYB")?"selected=\"selected\"":""%>>桃園分公司</option>
<!--RC0036-->       <option value="TCB" <%=strUserDept.equalsIgnoreCase("TCB")?"selected=\"selected\"":""%>>台中分公司</option>
<!--RC0036-->       <option value="TNB" <%=strUserDept.equalsIgnoreCase("TNB")?"selected=\"selected\"":""%>>台南分公司</option>
<!--RC0036-->       <option value="KHB" <%=strUserDept.equalsIgnoreCase("KHB")?"selected=\"selected\"":""%>>高雄分公司</option>
            	</SELECT>
            </TD>
            <TD  align="right" class="TableHeading">最近一次登錄日期:</TD>
            <TD align="left"><INPUT  class="Data" size="10" type="text" maxlength="10" name="txtLastLogonDate" id="txtLastLogonDate"  readonly value="<%=strLastLogonDate%>"  onblur="checkClientField(this,true);"></TD>
        </TR>
<!--RC0036-->        
        <TR>
            <TD  align="right" class="TableHeading">職域：</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserArea" name="selUserArea">
            		<option value="">請選擇</option>
           	        <option value="   " <%=strUserArea.equalsIgnoreCase("   ")?"selected=\"selected\"":""%>>   </option>            
                    <option value="LIO" <%=strUserArea.equalsIgnoreCase("LIO")?"selected=\"selected\"":""%>>LIO</option>
            		<option value="CS1" <%=strUserArea.equalsIgnoreCase("CS1")?"selected=\"selected\"":""%>>CS1</option>
 		            		
            	</SELECT>
            </TD>
<!--RC0036-->               
            <TD  align="right" class="TableHeading">分處:</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserBrch" name="selUserBrch">
            		<option value="">請選擇</option>
                    <option value="   " <%=strUserBrch.equalsIgnoreCase("   ")?"selected=\"selected\"":""%>>   </option>   
            	    <option value="TPE" <%=strUserBrch.equalsIgnoreCase("TPE")?"selected=\"selected\"":""%>>TPE</option>
            		<option value="PCH" <%=strUserBrch.equalsIgnoreCase("PCH")?"selected=\"selected\"":""%>>PCH</option>
            	    <option value="KL" <%=strUserBrch.equalsIgnoreCase("KL")?"selected=\"selected\"":""%>>KL</option>
            		<option value="IL" <%=strUserBrch.equalsIgnoreCase("IL")?"selected=\"selected\"":""%>>IL</option>            		
            	    <option value="HC" <%=strUserBrch.equalsIgnoreCase("HC")?"selected=\"selected\"":""%>>HC</option>
            		<option value="ML" <%=strUserBrch.equalsIgnoreCase("ML")?"selected=\"selected\"":""%>>ML</option>
            	    <option value="CTN" <%=strUserBrch.equalsIgnoreCase("CTN")?"selected=\"selected\"":""%>>CTN</option>
            		<option value="CH" <%=strUserBrch.equalsIgnoreCase("CH")?"selected=\"selected\"":""%>>CH</option>
            		<option value="YL" <%=strUserBrch.equalsIgnoreCase("YL")?"selected=\"selected\"":""%>>YL</option>
            	    <option value="CY" <%=strUserBrch.equalsIgnoreCase("CY")?"selected=\"selected\"":""%>>CY</option>
            		<option value="XY" <%=strUserBrch.equalsIgnoreCase("XY")?"selected=\"selected\"":""%>>XY</option>            		
            	    <option value="PT" <%=strUserBrch.equalsIgnoreCase("PT")?"selected=\"selected\"":""%>>PT</option>
            		<option value="HL" <%=strUserBrch.equalsIgnoreCase("HL")?"selected=\"selected\"":""%>>HL</option>
            	    <option value="TTG" <%=strUserBrch.equalsIgnoreCase("TTG")?"selected=\"selected\"":""%>>TTG</option>
            		<option value="KMN" <%=strUserBrch.equalsIgnoreCase("KMN")?"selected=\"selected\"":""%>>KMN</option>
            		<option value="PH" <%=strUserBrch.equalsIgnoreCase("PH")?"selected=\"selected\"":""%>>PH</option>                  		      		            		            		
            	</SELECT>
            </TD>
        </TR>
        <TR>
            <TD  align="right" class="TableHeading">備　 註：</TD>
            <TD align="left"><INPUT  class="Data" size="18" type="text" maxlength="200" id="txtRemark" name="txtRemark"  value="<%=strRemark%>"  onblur="checkClientField(this,true);"></TD>
            <TD  align="right" class="TableHeading"><font size=2>電子郵箱帳號：</font></TD>
            <TD align="left"><INPUT  class="Data" size="20" type="text" maxlength="60" id="txtEmail" name="txtEmail"  value="<%=strEmail%>"  onblur="checkClientField(this,true);"></TD>
        </TR>
    </TBODY>
</TABLE><br>
<table border="0" width=630 cellspacing="0" cellpadding="0" id="copyright">
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'>
	        <Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: 新細明體;">著作權所有全球人壽</font>
        </td>
	</tr>
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'><Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: 新細明體;"> 		
		<script language=JavaScript >
        var dteDate = new Date( document.lastModified );
        var strOut = '更新日期:';
        if( dteDate.getMonth() + 1 < 10 )
    	    strOut += "0"+(dteDate.getMonth()+1)+"/";
        else
	        strOut += (dteDate.getMonth()+1)+"/";
        if( dteDate.getDate() < 10 )
	        strOut += "0"+dteDate.getDate()+"/";
        else
	        strOut += dteDate.getDate()+"/";
	        strOut += dteDate.getFullYear();
	        document.write( strOut );
		</script></font></td>
	</tr>
</table>
</CENTER>
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
<INPUT type="hidden" id="txtOrgPWDT" name="txtOrgPWDT" value="<%=strORGLastPasswordDate%>">
</FORM>
</body>
</html>