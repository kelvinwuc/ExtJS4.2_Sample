<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 票據維護
 * 
 * Remark   : 出納功能
 * 
 * Revision : $Revision: 1.10 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckMaintain.jsp,v $
 * Revision 1.10  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.9  2013/02/22 03:21:35  ODCWilliam
 * william wu
 * PA0024
 * bill cash day
 *
 * Revision 1.8  2012/08/29 09:18:46  ODCKain
 * Character problem
 *
 * Revision 1.7  2012/08/29 03:38:54  ODCWilliam
 * modify:william
 * date:2012-08-28
 *
 * Revision 1.6  2010/11/23 02:17:05  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.5  2009/08/27 06:23:26  misodin
 * Q90431 掛失重開需輸入申請重開User
 *
 * Revision 1.4  2009/01/21 02:05:17  misvanessa
 * Q90020_申請重開USER使用點選方式
 *
 * Revision 1.3  2008/08/18 06:15:05  MISODIN
 * R80338 調整銀行帳號選單的預設值
 *
 * Revision 1.2  2006/10/31 08:57:33  MISVANESSA
 * R60420_票據異動為"4"重開,需輸入申請重開USER
 *
 * Revision 1.1  2006/06/29 09:40:44  MISangel
 * Init Project
 *
 * Revision 1.1.2.13  2005/10/31 03:32:03  misangel
 * R50820:支付功能提升
 *
 * Revision 1.1.2.12  2005/08/08 01:48:09  misangel
 * 庫存票可作廢
 *
 * Revision 1.1.2.10  2005/04/20 03:29:19  miselsa
 * R30530_修改票據備註
 *
 * Revision 1.1.2.9  2005/04/04 07:02:23  miselsa
 * R30530 支付系統
 *  
 */
%><%!String strThisProgId = "DISBCheckMaintain"; //本程式代號%><%
String strAction = (request.getAttribute("txtAction") == null)?"":(String) request.getAttribute("txtAction");
String strReturnMessage = (request.getAttribute("txtMsg") == null)?"":(String) request.getAttribute("txtMsg");

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") ==null) {
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList",alPBBank);
} else {
	alPBBank =(List) session.getAttribute("PBBankList");
}

//Q90020 USER LIST
List alUSERid = new ArrayList();
if (session.getAttribute("USERList") == null) {
	alUSERid = (List) disbBean.getUSERList();
	session.setAttribute("USERList", alUSERid);
} else {
	alUSERid = (List) session.getAttribute("USERList");
}
//Q90020 END
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>支票功能--票據狀態維護作業</TITLE>
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
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckMaintain.jsp";
	}	
	if (document.getElementById("txtAction").value == "")
	{
		document.getElementById("inquiryArea").style.display = "block";
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;
		window.status = "";
	}
	else
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyExit,'' ) ;
		window.status = "";
	}
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckMaintain.jsp?";
}

/* 當toolbar frame 中之<查詢>鈕被點選時,本函數會被執行 */
function inquiryAction()
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
	mapValue();

	var strSql = "";
	strSql = " select CHEQUE_NO,CHEQUE_BOOK_NO,CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_NAME,CHEQUE_AMOUNT,CAST(CHEQUE_DATE AS CHAR(7))  AS CHEQUE_DATE,CAST(CHEQUE_CASH_DATE AS CHAR(7)) AS CASH_DATE,CAST(CHEQUE_RETURN_DATE AS CHAR(7)) AS CHEQUE_RETURN_DATE,CAST(CHEQUE_USED_DATE AS CHAR(7)) AS CHEQUE_USED_DATE,CAST(CHEQUE_BACK_DATE AS CHAR(7)) AS CHEQUE_BACK_DATE,CHEQUE_STATUS,PAY_NO,CHEQUE_ERROR_FLAG,CHEQUE_HAND_FLAG,CAST(ENTRY_DATE AS CHAR(7)) AS ENTRY_DATE,CAST(ENTRY_TIME AS CHAR(6)) AS ENTRY_TIME,ENTRY_USER,CHEQUE_MEMO,CHEQUE_CHG4USER ";
	strSql += " from  CAPCHKF ";
	strSql += " WHERE  1=1 ";
	if( document.getElementById("txtCBank").value != "" ) {
		strSql += " AND CHEQUE_BANK_NO = '" + document.getElementById("txtCBank").value + "' ";
	}
	if( document.getElementById("txtCAccount").value != "" ) {
		strSql += "  AND  CHEQUE_ACCOUNT= '" + document.getElementById("txtCAccount").value + "' ";
	}
	if( document.getElementById("txtCNo").value != "" ){
		strSql += "  AND CHEQUE_NO like '^" +  document.getElementById("txtCNo").value + "^' ";
	}

	var strQueryString = "?Time="+new Date()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=500";
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","銀行行庫,銀行帳號,票據批號,票據號碼,票據狀態,輸入者,輸入日");
	session.setAttribute("DisplayFields", "CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_BOOK_NO,CHEQUE_NO,CHEQUE_STATUS,ENTRY_USER,ENTRY_DATE");
	session.setAttribute("ReturnFields", "CHEQUE_NO,CHEQUE_BOOK_NO,CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_NAME,CHEQUE_AMOUNT,CHEQUE_DATE,CASH_DATE,CHEQUE_RETURN_DATE,CHEQUE_USED_DATE,CHEQUE_BACK_DATE,CHEQUE_STATUS,PAY_NO,CHEQUE_ERROR_FLAG,CHEQUE_HAND_FLAG,CHEQUE_MEMO,CHEQUE_CHG4USER");
%>
	//modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:550px;dialogHeight:600px;center:yes" );
	if( strReturnValue != "" )
	{
		var returnArray = string2Array(strReturnValue,",");

		document.getElementById("txtCNoU").value = returnArray[0];
		document.getElementById("txtCBNoU").value = returnArray[1];
		document.getElementById("txtCBkNoU").value = returnArray[2];
		document.getElementById("txtCAccountU").value = returnArray[3];
		document.getElementById("txtCNMU").value = returnArray[4];		
		document.getElementById("txtCAMTU").value = returnArray[5];	
		if( returnArray[6] == "0") {
			document.getElementById("txtChequeDtU").value = "";
		} else {
			document.getElementById("txtChequeDtU").value = returnArray[6];
		}
	    if( returnArray[7] == "0") {
	    	document.getElementById("txtCashDtU").value = "";
	    } else {
	    	document.getElementById("txtCashDtU").value = returnArray[7];
	    }
	    if( returnArray[8] == "0") {
	    	document.getElementById("txtCrtnDtU").value = "";
	    } else {
	    	document.getElementById("txtCrtnDtU").value = returnArray[8];
	    }
	    if( returnArray[9] == "0") {
	    	document.getElementById("txtCUseDtU").value = "";
	    } else {
	    	document.getElementById("txtCUseDtU").value = returnArray[9];
	    }
	    if( returnArray[10] == "0") {
	    	document.getElementById("txtCBckDtU").value = "";
	    } else {
	    	document.getElementById("txtCBckDtU").value = returnArray[10];
	    }
		var strCStatus = returnArray[11];
		document.getElementById("txtCStatusU").value = returnArray[11];
		document.getElementById("txtPNoU").value = returnArray[12];
		document.getElementById("txtCerFlagU").value = returnArray[13];
		document.getElementById("txtChndFlgU").value = returnArray[14];
		document.getElementById("txtCMEMO").value = returnArray[15];
		document.getElementById("txtC4User").value = returnArray[16];//R60420

		document.getElementById("txtAction").value = "I";
		WindowOnLoadCommon( document.title , '' , 'E','' ) ;
		document.getElementById("updateArea").style.display = "block";
		document.getElementById("inquiryArea").style.display = "none";

		/*控制那些Buttion 的呈現*/
		if(strCStatus == "") //庫存票可作廢
		{
			document.getElementById("UpdateV").style.display = "block";
		}
		if(strCStatus == "D")
		{
			document.getElementById("UpdateV").style.display = "block";
			document.getElementById("UpdateR").style.display = "block";
			document.getElementById("Update1").style.display = "block";
			document.getElementById("Update3").style.display = "block";
			document.getElementById("Update4").style.display = "block";
		}
		else  if(strCStatus == "R")
		{
			document.getElementById("Update1").style.display = "block";
			document.getElementById("Update2").style.display = "block";
			document.getElementById("Update4").style.display = "block";
		}
		else  if(strCStatus == "1")
		{
			document.getElementById("Update2").style.display = "block";
			document.getElementById("Update4").style.display = "block";
			document.getElementById("UpdateV").style.display = "block";
		}
		else  if(strCStatus == "2")
		{
			document.getElementById("Update4").style.display = "block";
			document.getElementById("UpdateV").style.display = "block";
		}
		else  if(strCStatus == "C")
		{
			document.getElementById("Update5").style.display = "block";
		}
		else  if(strCStatus == "5")
		{
			document.getElementById("Update6").style.display = "block";
		}
		//R60420 申請4作廢重開的USER
		if (strCStatus =="4" || document.getElementById("Update4").style.display == "block")
		{
			document.getElementById("Update4User").style.display = "block";
			if (strCStatus != "4")
			{
				document.getElementById("txtC4User").className = "Data";
				document.getElementById("txtC4User").readOnly =  false;
			}
		}
		//Q90431 申請5掛失重開的USER
		if (strCStatus =="5" || document.getElementById("Update5").style.display == "block" || strCStatus =="6")
		{
			document.getElementById("Update4User").style.display = "block";
			if (strCStatus != "5" && strCStatus != "6")
			{
				document.getElementById("txtC4User").className = "Data";
				document.getElementById("txtC4User").readOnly =  false;
			}
		}
	}
}

/* 更新票據狀態為作廢: V */
function updateVAction()
{
	document.getElementById("txtAction").value = "UpdateV";
	document.getElementById("txtUpdateStatus").value = "V";
	document.getElementById("frmMain").submit();
}
/* 更新票據狀態為退回: R */
function updateRAction()
{
	document.getElementById("txtAction").value = "UpdateR";
	document.getElementById("txtUpdateStatus").value = "R";
	document.getElementById("frmMain").submit();
}
/* 更新票據狀態為逾一年: 1 */
function update1Action()
{
	document.getElementById("txtAction").value = "Update1";
	document.getElementById("txtUpdateStatus").value = "1";
	document.getElementById("frmMain").submit();
} 
/* 更新票據狀態為逾二年: 2 */
function update2Action()
{
	document.getElementById("txtAction").value = "Update2";
	document.getElementById("txtUpdateStatus").value = "2";
	document.getElementById("frmMain").submit();
} 
/* 更新票據狀態為重印: 3 */
function update3Action()
{
	document.getElementById("txtAction").value = "Update3";
	document.getElementById("txtUpdateStatus").value = "3";
	document.getElementById("frmMain").submit();
} 
/* 更新票據狀態為重開:4 */
function update4Action()
{
	//R60420 重開必須輸入申請的USER
	if (document.getElementById("txtC4User").value == "") {
		window.alert("重開票據請輸入申請的USER!");		
	} else {
		document.getElementById("txtAction").value = "Update4";
		document.getElementById("txtUpdateStatus").value = "4";
		document.getElementById("frmMain").submit();
	}
}
/* 更新票據狀態為掛失: 5 */
function update5Action()
{
	//Q90431 重開必須輸入申請的USER
	if (document.getElementById("txtC4User").value == "") {
		window.alert("重開票據請輸入申請的USER!");
	} else {
		document.getElementById("txtAction").value = "Update5";
		document.getElementById("txtUpdateStatus").value = "5";
		document.getElementById("frmMain").submit();
	}
} 
/* 更新票據狀態為除權判決: 6 */
function update6Action()
{
	document.getElementById("txtAction").value = "Update6";
	document.getElementById("txtUpdateStatus").value = "6";
	document.getElementById("frmMain").submit();
} 
/* 只修改備註 */
function updateDataAction()
{
	document.getElementById("txtAction").value = "UpdateData";
	document.getElementById("frmMain").submit();
} 

function mapValue() {
	var BankAccount = document.getElementById("selCBank").value ;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtCBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtCAccount").value = BankAccount.substring(iindexof+1);	
	}  
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckMaintainServlet" id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="452" id=inquiryArea name=inquiryArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">付款帳號：</TD>
			<TD width="333"><select size="1" name="selCBank" id="selCBank">
                <option value="8220635/635300021303">8220635/635300021303-中信銀復興</option><!--R80338-->
				<%if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		Hashtable htPBBankTemp = (Hashtable) alPBBank.get(i);
		String strETVDesc = (String) htPBBankTemp.get("ETVDesc");
		String strETValue = (String) htPBBankTemp.get("ETValue");
		out.println("<option value=" + strETValue + ">" + strETValue + "-" + strETVDesc + "</option>");
	}
} else {%>
				<option value=""></option>
				<%}%>
			</select>
			<INPUT type="hidden" name="txtCBank" id="txtCBank"	value="">
			<INPUT type="hidden" name="txtCAccount" id="txtCAccount" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">票據號碼：</TD>
			<TD><INPUT class="Data" size="20" type="text" maxlength="18" name="txtCNo" id="txtCNo" value="">(模糊比對)</TD>
		</TR>
	</TBODY>
</TABLE>
<DIV Id=updateArea style="display:none ">
<table>
<tr>
<td id="UpdateV"  style="display:none" ><input type="button" name="btnUpdateV" id="btnUpdateV" onClick="updateVAction();" value="作廢"></td>
<td id="UpdateR"  style="display:none" ><input type="button" name="btnUpdateR" id="btnUpdateR" onClick="updateRAction();" value="退回"></td>
<td id="Update1"  style="display:none" ><input type="button" name="btnUpdate1" id="btnUpdate1" onClick="update1Action();" value="逾一年票"></td>
<td id="Update2"  style="display:none" ><input type="button" name="btnUpdate2" id="btnUpdate2" onClick="update2Action();" value="逾二年票"></td>
<td id="Update3" style="display:none" ><input type="button" name="btnUpdate3" id="btnUpdate3" onClick="update3Action();" value="重印"></td>
<td id="Update4"  style="display:none" ><input type="button" name="btnUpdate4" id="btnUpdate4" onClick="update4Action();" value="重開"></td>
<td id="Update5" style="display:none" ><input type="button" name="btnUpdate5" id="btnUpdate5" onClick="update5Action();" value="掛失"></td>
<td id="Update6"  style="display:none" ><input type="button" name="btnUpdate6" id="btnUpdate6" onClick="update6Action();" value="除權判決"></td>
<td id="UpdateData"  style="" ><input type="button" name="btnUpdateData" id="btnUpdateData" onClick="updateDataAction();" value="修改備註"></td>
</tr>
</table>
<TABLE border="1" width="452" >
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">票據號碼：</TD>
			<TD><INPUT  class="INPUT_DISPLAY" size="25" type="text" maxlength="25"
				name="txtCNoU" id="txtCNoU" value="" readonly></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="101">票據批號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				id="txtCBNoU" name="txtCBNoU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">銀行行庫：</TD>
			<TD width="333"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="10" id="txtCBkNoU" name="txtCBkNoU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">銀行帳號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCAccountU" id="txtCAccountU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">票據抬頭：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50"
				name="txtCNMU" id="txtCNMU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">票據金額：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCAMTU" id="txtCAMTU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">到期日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtChequeDtU" id="txtChequeDtU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">兌現日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCashDtU" id="txtCashDtU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">回銷日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCrtnDtU" id="txtCrtnDtU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">開立日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCUseDtU" id="txtCUseDtU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">退回日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCBckDtU" id="txtCBckDtU" readonly></TD>
		</tr>		
		<tr>
			<TD align="right" class="TableHeading" width="101">支票狀態：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCStatusU" id="txtCStatusU" readonly></TD>
		</tr>		
		<tr>
			<TD align="right" class="TableHeading" width="101">支付序號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="30" type="text" maxlength="11"
				name="txtPNoU" id="txtPNoU" readonly></TD>
		</tr>	
		<tr>
			<TD align="right" class="TableHeading" width="101">問題票據：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCerFlagU" id="txtCerFlagU" readonly></TD>
		</tr>	
		<tr>
			<TD align="right" class="TableHeading" width="101">人工開票用：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtChndFlgU" id="txtChndFlgU" readonly></TD>
		</tr>									
		<tr>
			<TD align="right" class="TableHeading" width="101">備註 : </TD>
			<TD><INPUT class="DATA" size="50" type="text" maxlength="50"
				name="txtCMEMO" id="txtCMEMO" ></TD>
		</tr>
		<!--R60420 申請重開的USER-->
		<tr id="Update4User" style="display:none">
			<TD align="right" class="TableHeading" width="101">申請重開User : </TD>
			<TD><INPUT class="INPUT_DISPLAY" size="15" type="text" maxlength="10"
				name="txtC4User" id="txtC4User" 
				ONKEYUP="autoComplete(this,this.form.options,'value',true,'selList')">
		<!--Q90020 改由點選-->
			<span style="display: none" id="selList" name="selList">
			<SELECT
				NAME="options"
				onChange="this.form.txtC4User.value=this.options[this.selectedIndex].value"
				MULTIPLE SIZE=4 onblur="disableList('selList')" class="Data">
	<%if (alUSERid.size() > 0) {
			for (int i = 0; i < alUSERid.size(); i++) {
				Hashtable htUSERIDTemp = (Hashtable) alUSERid.get(i);
				String strETid = (String) htUSERIDTemp.get("USERid");
				String strETname = (String) htUSERIDTemp.get("USERname");
				out.println(
				"<option value="
					+ strETid
					+ ">"
					+ strETid + " / " + strETname
					+ "</option>");
			}
	} else {%>
		<option value=""></option>
	<%}%>
			</select> </span></TD>
		</tr>
	</TBODY>
</TABLE>
附註(票據狀態說明):
D:已開、C:兌現、V:作廢、R:退回、1:逾一年票、2:逾二年票、3:重印、4:重開、5:掛失、6:除權判決
</div>
<INPUT name="txtUpdateStatus" id="txtUpdateStatus" type="hidden" value=""> 
<INPUT name="txtAction" id="txtAction" type="hidden" 	value="<%=strAction%>"> 
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>
