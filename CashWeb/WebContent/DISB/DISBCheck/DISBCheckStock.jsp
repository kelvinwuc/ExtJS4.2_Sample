<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBCheckControlInfoVO"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 票據庫存
 * 
 * Remark   : 管理系統-財務
 * 
 * Revision : $Revision: 1.4 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2012/07/17 02:50:30 $ 
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckStock.jsp,v $
 * Revision 1.4  2012/07/17 02:50:30  MISSALLY
 * RA0043 / RA0081
 * 1.一銀台新下載檔格式調整
 * 2.票據庫存之核准權限改讀設定
 *
 * Revision 1.3  2010/11/23 02:17:04  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.1  2006/06/29 09:40:44  MISangel
 * Init Project
 *
 * Revision 1.1.2.6  2005/04/04 07:02:23  miselsa
 * R30530 支付系統
 *  
 */
%><%! String strThisProgId = "DISBCheckStock"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") == null)
{
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList",alPBBank);
}
else
{
	alPBBank =(List) session.getAttribute("PBBankList");
}
//System.out.println("alPBBank="+alPBBank.size());

List alCheckControl = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
if(session.getAttribute("CheckControlList") != null)
{
	alCheckControl = (List)session.getAttribute("CheckControlList");

	if (alCheckControl != null)
	{
		if (alCheckControl.size() > 0)
			itotalCount = alCheckControl.size();
		if(itotalCount%iPageSize == 0)
		{
			itotalpage = itotalCount/iPageSize;
		}
		else
		{
			itotalpage = itotalCount/iPageSize + 1;
		}
	}
}
session.removeAttribute("CheckControlList");

String strAction = (request.getAttribute("txtAction") != null) ? (String) request.getAttribute("txtAction") : "";
String strReturnMessage = (request.getAttribute("txtMsg") != null) ? (String) request.getAttribute("txtMsg") : "";
String strSelectedBank = (session.getAttribute("SelectedBank") !=null) ? (String)session.getAttribute("SelectedBank") : "";
if(!strSelectedBank.equals(""))
	strSelectedBank = strSelectedBank.trim();	
session.removeAttribute("SelectedBank");
Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbPBBank = new StringBuffer();
if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		htTemp = (Hashtable) alPBBank.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		if(strValue.equalsIgnoreCase(strSelectedBank))
			sbPBBank.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbPBBank.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
} else {
	sbPBBank.append("<option value=\"\">&nbsp;</option>");
}

/* RA0043 權限參照使用者設定
//R90628
String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
ArrayList list = new ArrayList(); 
list.add("FINKATTY"); 
list.add("FINANITA"); 
list.add("FINJOYCE");
*/
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")):"";
%>
<HTML>
<HEAD>
<TITLE>管理系統--票據庫存</TITLE>
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
var iTotalrec =<%=itotalCount%>;

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
		window.alert(document.getElementById("txtMsg").value) ;
	
	if (document.getElementById("txtAction").value == "I")
	{
		WindowOnLoadCommon( document.title, '', strDISBFunctionKeyExit, '' );
		document.getElementById("updateArea").style.display = "none";
		if(iTotalrec == 0)
		{
			document.getElementById("detailsArea").style.display = "none";
		}
		else
		{
			document.getElementById("detailsArea").style.display = "block";
		}
	}
	else
	{
		document.getElementById("updateArea").style.display = "none";
		document.getElementById("detailsArea").style.display = "none";

		if("<%=strUserDept%>" == "FIN" && <%=strUserRight%> >= 89) {
			WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
		} else if("<%=strUserDept%>" == "FIN" && <%=strUserRight%> == 79) {
			WindowOnLoadCommon( document.title, '', strFunctionKeyInitial, '' );
		} else {
			WindowOnLoadCommon( document.title, '', strDISBFunctionKeyExit, '' );
		}
	}
	disableKey();
	disableData();
}

/*
函數名稱:	addAction()
函數功能:	當toolbar frame 中之新增按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function addAction()
{
	window.status = "";
	document.getElementById("txtAction").value = "A";
	document.getElementById("updateArea").style.display = "block";
	document.getElementById("detailsArea").style.display = "none";
	WindowOnLoadCommon( document.title+"(新增)", '', strFunctionKeyAdd, '' );
	enableAll();
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
	WindowOnLoadCommon( document.title+"(查詢)", '', strFunctionKeyInquiry1, '' );
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
}

/*
函數名稱:	deleteAction()
函數功能:	當toolbar frame 中之刪除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function deleteAction(strCBKNo,strCAccount,strCBNo,strChkSNo,strChkENo)
{
	var bConfirm = window.confirm("是否確定刪除該筆資料?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtDCBKNo").value = strCBKNo;
		document.getElementById("txtDCAccount").value = strCAccount;
		document.getElementById("txtDCBNo").value = strCBNo;
		document.getElementById("txtDCSNo").value = strChkSNo;
		document.getElementById("txtDCENo").value = strChkENo;
		document.getElementById("txtAction").value = "D";
		document.getElementById("frmMain").submit();
	}
}

/*R90628*/
function approvUAction(strCBKNo,strCAccount,strCBNo,strChkSNo,strChkENo)
{
	var bConfirm = window.confirm("是否確定核准使用該筆票據批號?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtDCBKNo").value = strCBKNo;
		document.getElementById("txtDCAccount").value = strCAccount;
		document.getElementById("txtDCBNo").value = strCBNo;
		document.getElementById("txtDCSNo").value = strChkSNo;
		document.getElementById("txtDCENo").value = strChkENo;
		document.getElementById("txtAction").value = "AU";
		document.getElementById("frmMain").submit();
	}
}

function approvRDAction(strCBKNo,strCAccount,strCBNo,strChkSNo,strChkENo)
{
	var bConfirm = window.confirm("是否確定申請刪除該筆票據批號?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtDCBKNo").value = strCBKNo;
		document.getElementById("txtDCAccount").value = strCAccount;
		document.getElementById("txtDCBNo").value = strCBNo;
		document.getElementById("txtDCSNo").value = strChkSNo;
		document.getElementById("txtDCENo").value = strChkENo;
		document.getElementById("txtAction").value = "AR";
		document.getElementById("frmMain").submit();
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
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckStock.jsp";
}

/*
函數名稱:	confirmAction()
函數功能:	當toolbar frame 中之確定按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function confirmAction()
{
	mapValue();
	enableAll();
	document.getElementById("frmMain").submit();
}

/*
函數名稱:	saveAction()
函數功能:	當toolbar frame 中之儲存按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function saveAction()
{
	
	enableAll();
	mapValue();
	if( areAllFieldsOK() )
	{	
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
	if( objThisItem.id == "txtUCSNo" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "票據起號不可空白";
			bReturnStatus = false;
		}
		else if(objThisItem.value.length < 3 )
		{
			strTmpMsg = "票據起號不合法";
			bReturnStatus = false;
		}
		else
		{  
		     re = /^[A-Z]/;
		     var TempNo1 = objThisItem.value.substring(0,1);
		     var TempNo2 = objThisItem.value.substring(1,2);
		     if(!re.test(TempNo1)|| !re.test(TempNo2))
		     {
		        strTmpMsg = "票據起號前二碼為英文字母!";
			    bReturnStatus = false;
		     }
		 
		}
	}
	else if( objThisItem.id == "txtUCENo" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "票據迄號不可空白";
			bReturnStatus = false;
		}
		else if(objThisItem.value.length < 3 )
		{
			strTmpMsg = "票據迄號不合法";
			bReturnStatus = false;
		}
		else
		{  
	     re = /^[A-Z]/;
	     var TempNo1 = objThisItem.value.substring(0,1);
	     var TempNo2 = objThisItem.value.substring(1,2);
	     if(!re.test(TempNo1)|| !re.test(TempNo2))
	     {
	       strTmpMsg = "票據迄號前二碼為英文字母!";
		     bReturnStatus = false;
	     }
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

function mapValue() {
	var BankAccount = document.getElementById("selCBank").value ;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtCBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtCAccount").value = BankAccount.substring(iindexof+1);	
	}
	document.getElementById("txtUCSNo").value = document.getElementById("txtUCSNo").value.toUpperCase();
	document.getElementById("txtUCENo").value = document.getElementById("txtUCENo").value.toUpperCase();
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckStockServlet">
<TABLE border="1" width="452" id="inquiryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">付款帳號：</TD>
			<TD width="333">
				<select size="1" name="selCBank" id="selCBank">
					<%=sbPBBank.toString()%>
				</select>
				<INPUT type="hidden" name="txtCBank" id="txtCBank" value="">
				<INPUT type="hidden" name="txtCAccount" id="txtCAccount" value="">
			</TD>
		</TR>
	</TBODY>
</TABLE>
<TABLE border="1" width="452" id="updateArea" style="display: none">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">票據起始號：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtUCSNo" id="txtUCSNo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">票據終止號：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtUCENo" name="txtUCENo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">人工開票用：</TD>
			<TD><INPUT class="Data" size="11" type="checkbox" name="chUChdFlg" id="chUChdFlg" value="Y"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">票據批號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUCBNo" name="txtUCBNo" value="" readonly></TD>
		</TR>
	</TBODY>
</TABLE>
<BR>
<div id="detailsArea" style="display:none;">
<%	if (alCheckControl != null)
	{//if1
		if(alCheckControl.size()>0)
		{//if2
			int icurrentRec = 0;
			int icurrentPage = 0; // 由0開始計
			int iSeqNo = 0;
			for (int i=0; i<itotalpage;i++)
			{
				icurrentPage = i ;
				for (int j = 0 ; j < iPageSize;j++)
				{
					iSeqNo ++;
					icurrentRec = icurrentPage * iPageSize + j;
					if(icurrentRec < alCheckControl.size())
					{
						if( j == 0) // show table head
						{
							String strStyle = "";
							if((icurrentPage + 1) == 1)
							{
								strStyle = "block;";
							}
							else
							{
								strStyle = "none;";
							}  %>
	<div id="showPage<%=icurrentPage+1%>" style="display:<%=strStyle%>">
		<table border=0>
			<tr>
				<td><a href="javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage+1%>,1)"> &lt;&lt;&nbsp;&nbsp;</a></td>
				<td><a href="javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage+1%>,2)">&lt;&nbsp;&nbsp;</a></td>
				<td><a href="javascript:ChangePage(<%=icurrentPage+2%>,<%=itotalpage%>,<%=icurrentPage+1%>,3)">&gt;&nbsp;&nbsp;</a></td>
				<td><a href="javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage+1%>,4)">&gt;&gt;&nbsp;&nbsp;</a></td>
			</tr>
		</table>
		<hr>
		<table border="0" cellPadding="0" cellSpacing="0" width="816" id="tblDetail">
			<tbody>		       
				<TR>
					<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">序號</font></b></TD>
					<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">銀行行庫</font></b></TD>
					<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="細明體">銀行帳號</font></b></TD>
					<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><b><font size="2" face="細明體">票據批號</font></b></TD>
					<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">票據起號</font></b></TD>
					<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">票據迄號</font></b></TD>
					<!-- R90628 -->
					<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><b><font size="2" face="細明體">未使用張數</font></b></TD>
					<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">票據狀態</font></b></TD>
					<TD bgColor="#c0c0c0" style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="56" width="53"><font size="2" face="細明體"><b>功能</b></font></TD>
				</TR>
<%						}
						DISBCheckControlInfoVO objCControlVO = (DISBCheckControlInfoVO)alCheckControl.get(icurrentRec);
						String strCBKNo = "";
					    String strCAccount = "";
					    String strCBNo = "";
					    String strCSNo = "";
					    String strCENo = "";
					    String strEmptyCheck = "";
					    String strStatus = "";
					    String strMemo = "";
					    boolean bIsUsed = false;

						if (objCControlVO.getStrCBKNo() != null)
							strCBKNo = objCControlVO.getStrCBKNo();
						if(strCBKNo != "")
							strCBKNo= strCBKNo.trim();

						if (objCControlVO.getStrCAccount() != null)
							strCAccount = objCControlVO.getStrCAccount();
						if(strCAccount != "")
							strCAccount= strCAccount.trim();

						if (objCControlVO.getStrCBNo() != null)
							strCBNo = objCControlVO.getStrCBNo();
						if(strCBNo != "")
							strCBNo= strCBNo.trim();

						if (objCControlVO.getStrCSNo() != null)
							strCSNo = objCControlVO.getStrCSNo();
						if(strCSNo != "")
							strCSNo= strCSNo.trim();

						if (objCControlVO.getStrCENo() != null)
							strCENo = objCControlVO.getStrCENo();
						if(strCENo != "")
							strCENo= strCENo.trim();

						//R90628
						if (objCControlVO.getIEmptyCheck() < 999999999)
							strEmptyCheck = Integer.toString(objCControlVO.getIEmptyCheck());

						if (objCControlVO.getStrApprovStat() != null)
							strStatus = objCControlVO.getStrApprovStat();

						if (objCControlVO.getStrMemo() != null)
							strMemo = objCControlVO.getStrMemo();

						bIsUsed = objCControlVO.isUsed();
%>
				<TR id="data">
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><%=icurrentRec+1%></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><%=strCBKNo%></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="92"><%=strCAccount%></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="60"><%=strCBNo%></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strCSNo%></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="69"><%=strCENo%></TD>
					<!-- R90628 -->
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="75"><%=strEmptyCheck%></TD>
					<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="69"><%=strMemo%></TD>
					<TD style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="35" width="53">
					<!-- R90628 RA0043 -->
					<%if ("N".equals(strStatus) && strUserDept.equals("FIN") && (Integer.parseInt(strUserRight) >= 89)){%>
						<input type=button value="核准使用" onclick="approvUAction('<%=strCBKNo%>','<%=strCAccount%>','<%=strCBNo%>','<%=strCSNo%>','<%=strCENo%>');">
					<%}%>
					<%if (!("R".equals(strStatus) || "D".equals(strStatus)) && strUserDept.equals("FIN") && (Integer.parseInt(strUserRight) == 79) && !"0".equals(strEmptyCheck)){%>
						<input type=button value="申請刪除" onclick="approvRDAction('<%=strCBKNo%>','<%=strCAccount%>','<%=strCBNo%>','<%=strCSNo%>','<%=strCENo%>');">
					<%}%>
					<%if ("R".equals(strStatus) && strUserDept.equals("FIN") && (Integer.parseInt(strUserRight) >= 89) && !"0".equals(strEmptyCheck)){%>
						<input type=button value="刪除" onclick="deleteAction('<%=strCBKNo%>','<%=strCAccount%>','<%=strCBNo%>','<%=strCSNo%>','<%=strCENo%>');">
					<%}%>
					&nbsp;
					</TD>
				</TR>
					<%//R90628			
						if((iSeqNo == iPageSize) || (icurrentRec == (alCheckControl.size()-1) )  || (iSeqNo%iPageSize == 0) )
						{  %>
			</tbody>
		</table>
	</div>		
<%			    	    }
					} // end of if --> inowRec < alCheckControl.size()
				}// end of for -- show detail      
			}//end of for  %>
        						總頁數 : <%=itotalpage%> &nbsp;&nbsp;總件數 : <%=itotalCount%> &nbsp;&nbsp;&nbsp;&nbsp;
<%
		} //end of if2 
	}//end of if1
	else
	{  %>
	<table border="0" cellPadding="0" cellSpacing="0" width="816" id="tblDetail">
		<tbody>
			<TR>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="細明體">序號</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="細明體">銀行行庫</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="細明體">銀行帳號</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><b><font size="2" face="細明體">票據批號</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="細明體">票據起號</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">票據迄號</font></b></TD>
				<!-- R90628 -->
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><b><font size="2" face="細明體">未使用張數</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="細明體">票據狀態</font></b></TD>
				<TD bgColor="#c0c0c0" style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="56" width="53"><font size="2" face="細明體"><b>刪除</b></font></TD>
			</TR>
			</tbody>
	</table>
<%}%>
</div>
	<INPUT type="hidden" id="txtDCBKNo" name="txtDCBKNo" value="">		
	<INPUT type="hidden" id="txtDCAccount" name="txtDCAccount" value="">		
	<INPUT type="hidden" id="txtDCBNo" name="txtDCBNo" value="">		
	<INPUT type="hidden" id="txtDCSNo" name="txtDCSNo" value="">		
	<INPUT type="hidden" id="txtDCENo" name="txtDCENo" value="">				
	<INPUT type="hidden" id="txtTpage" name="txtTpage" value="<%=itotalpage%>">
	<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value="">
 	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>