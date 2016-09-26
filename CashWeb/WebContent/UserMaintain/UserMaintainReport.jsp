<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="../Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%!
/**
 * System   : 
 * 
 * Function : 使用者盤點報表
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.9 $
 * 
 * Author   : VANESSA
 * 
 * Create Date : 2006/9/26
 * 
 * Request ID : R60802-提供CASH系統之使用者清單及功能盤點報表
 * 
 * CVS History:
 * 
 * $Log: UserMaintainReport.jsp,v $
 * Revision 1.9  2014/10/22 03:53:14  misariel
 * RC0402-新增部門
 *
 * Revision 1.8  2014/07/18 07:38:43  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.7  2013/01/29 03:21:53  MISSALLY
 * EB0019 --- CASH系統使用者盤點報表修改
 *
 * Revision 1.6  2011/08/09 01:34:10  MISSALLY
 * Q10256　 有關CASH系統錯誤無法跑出報表
 *
 * Revision 1.5  2010/11/23 03:37:17  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.3  2006/12/15 03:51:20  MISVANESSA
 * R60903_開放所有USER使用
 *
 * Revision 1.2  2006/11/02 10:08:50  MISVANESSA
 * R60903_新增輸入條件可分個人或整個部門
 *
 * Revision 1.1  2006/09/27 02:14:24  MISVANESSA
 * R60802_新增使用者清單.盤點報表二份
 *  
 */
%><%! String strThisProgId = "UserMaintainReport"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = request.getParameter("txtMsg")!=null?request.getParameter("txtMsg"):"";
String strAction = request.getAttribute("txtAction")!=null?(String) request.getAttribute("txtAction"):"";
String strUserDept = session.getAttribute("LogonUserDept")!=null?CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept")):"";
String strUserRight = session.getAttribute("LogonUserRight")!=null?CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight")):"";
String strUserId = session.getAttribute("LogonUserId")!=null?CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")):"";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>使用者盤點報表</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
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
	if( document.getElementById("txtMsg").value != "" )
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' );
    window.status = "";
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
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "../UserMaintain/UserMaintainReport.jsp";
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
函數名稱:	printRAction()
函數功能:	當toolbar frame 中之報表按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function printRAction()
{	//R60903開放給所有USER
	var strActcode = 0;
	if(document.getElementById("txtUserDept").value != "MIS") 
	{
		if(document.getElementById("txtUserDept").value != document.getElementById("selUserDept").value)
		{
			alert("您只能列印個人或所屬部門權限資料");
			strActcode = 1;
		}
	}
	if (strActcode == 0)
	{
		window.status = "";
		getReportInfo();
		WindowOnLoadCommon( document.title , '' , 'E','' ) ;
		document.getElementById("inquiryArea").style.display ="none";
   
		//User Check List
		if(document.frmMain.chkULR[0].checked)
		{
			document.getElementById("frmMain").target="_blank";
		    document.getElementById("frmMain").submit();
			
		}
		//User Function List
		if(document.frmMain.chkULR[1].checked)
		{
			document.getElementById("frmMain1").target="_blank";
			document.getElementById("frmMain1").submit();
		}
	}
}
function getReportInfo()
{    
	//User Check List
	if(document.frmMain.chkULR[0].checked)
	{
		var strSql = "SELECT U.DEPT,U.USRID,U.USRNAM,T.TYPNME,G.GRPNAM, U.USRAUTH FROM USER U";
		strSql += "  LEFT JOIN USERTYPE T ON  U.USRTYP = T.USRTYP LEFT JOIN FGROUP G ON U.DFTGRP = G.GRPID";
		//strSql += " WHERE 1=1 AND U.STAT='A' ORDER BY U.DEPT,U.USRID";
		strSql += " WHERE U.STAT<>'E' ";
		if (document.getElementById("selUserDept").value != "")
        {
          strSql += " AND U.DEPT = '" + document.getElementById("selUserDept").value + "' ";
        }
   		if (document.getElementById("txtUser").value != "")
        {
          strSql += " AND U.USRID = '" + document.getElementById("txtUser").value.toUpperCase() + "' ";
        }
   		strSql += " ORDER BY U.DEPT,U.USRID";
   		
  	    document.frmMain.ReportSQL.value = strSql;
	}
	//User Function List
	if(document.frmMain.chkULR[1].checked)
	{
		var strSql1 = "";
		//R60903 strSql1  = "SELECT U.DEPT, U.USRID, U.USRNAM, C.FUNNAM, R.FUNNAM AS FUNNAM1 FROM USER U JOIN GRPFUN G ON U.DFTGRP=G.GRPID JOIN FUNC C ON G.FUNID=C.FUNID";
		strSql1  = "SELECT U.DEPT, U.USRID, U.USRNAM, C.FUNNAM, T.TYPNME,P.GRPNAM, U.USRAUTH ";
		strSql1 += " FROM USER U JOIN GRPFUN G ON U.DFTGRP=G.GRPID JOIN FUNC C ON G.FUNID=C.FUNID";
		strSql1 += " LEFT JOIN USERTYPE T ON  U.USRTYP = T.USRTYP LEFT JOIN FGROUP P ON U.DFTGRP = P.GRPID";//R60903
        //R60903strSql1 += " LEFT OUTER JOIN (SELECT T.FUNUP, F.FUNID, F.FUNNAM FROM FUNC F JOIN FUNCTREE T ON T.FUNDWN=F.FUNID) R ON C.FUNID=R.FUNUP"; 
        //R60903strSql1 += " WHERE 1=1 AND U.STAT = 'A' ORDER BY U.DEPT, U.USRID";
        strSql1 += " WHERE U.STAT <> 'E' ";
        if (document.getElementById("selUserDept").value != "")
        {
          strSql1 += " AND U.DEPT = '" + document.getElementById("selUserDept").value + "' ";
        }
   		if (document.getElementById("txtUser").value != "")
        {
          strSql1 += " AND U.USRID = '" + document.getElementById("txtUser").value.toUpperCase() + "' ";
        }
        strSql1 += " ORDER BY U.DEPT, U.USRID";

		document.frmMain1.ReportSQL.value = strSql1;
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<form	action="../servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="452"  id=inquiryArea >
	<!--R60903新增輸入個人或部門-->
	<TR>
		<TD class="TableHeading" >請輸入列印條件：</TD>
		<TD colspan="2">
			<SELECT class="Data" id="selUserDept" name="selUserDept">
				<option value="">全部部門</option>
				<option value="MIS">MIS</option>
				<option value="FIN">FIN</option>
				<option value="ACCT">ACCT</option>
				<option value="CSC">CSC</option>
				<option value="NB">NB</option>
				<option value="PA">PA</option>
				<option value="GP">團險行政</option>
				<option value="GPH">團險理賠</option>
				<option value="CLM">個險理賠</option>
				<option value="080">080</option>
				<option value="CLH">醫調</option>
				<option value="MDS">MDS</option>
 <!--RC0402--> 	<option value="IA">稽核</option>
 <!--RC0402--> 	<option value="SPA">業務規劃行政處</option>				
 <!--RC0036--> 	<option value="PCD">收費處</option>
 <!--RC0036--> 	<option value="TYB">桃園分公司</option>
 <!--RC0036--> 	<option value="TCB">台中分公司</option>
 <!--RC0036--> 	<option value="TNB">台南分公司</option>
 <!--RC0036--> 	<option value="KHB">高雄分公司</option>
			</SELECT>
			<INPUT class="Data" size="14" type="text" maxlength="10" id="txtUser" name="txtUser" value=""><font color="red" size="2">(空白代表全部)</font>
		</TD>
	</TR>
	<TR>
		<TD align="left" class="TableHeading" >請選擇列印報表：</TD>
		<TD><INPUT type="checkbox" id="chkULR" name="chkULR" value="UsrChkRpt" checked>User Check List</TD>
		<TD><INPUT type="checkbox" id="chkULR" name="chkULR" value="UsrFunRpt" checked>User Function List</TD>
	</TR>
</TABLE>
                                                                                       
<INPUT type="hidden" id="ReportName" name="ReportName" value="UserMaintainList1.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="UserMaintainList1.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>UserMaintain\\">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept"  value="<%=strUserDept%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">	
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">
</FORM>
<FORM action="../servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain1" method="post" name="frmMain1">
<INPUT type="hidden" id="ReportName" name="ReportName" value="UserMaintainList2.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="UserMaintainList2.pdf"> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>UserMaintain\\">
</FORM>
</BODY>
</HTML>