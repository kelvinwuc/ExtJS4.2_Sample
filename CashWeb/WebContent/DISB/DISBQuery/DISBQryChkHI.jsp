<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 歷史票據查詢
 * 
 * Remark   : 支付查詢
 * 
 * Revision : $Revision: 1.7 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: DISBQryChkHI.jsp,v $
 * Revision 1.7  2013/12/24 03:48:55  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */
%><%! String strThisProgId = "DISBQryChkHI"; //本程式代號%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";

String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	

DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alUSERid = new ArrayList();
if (session.getAttribute("USERList") == null) {
	alUSERid = (List) disbBean.getUSERList();
	session.setAttribute("USERList", alUSERid);
} else {
	alUSERid = (List) session.getAttribute("USERList");
}
Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbUserId = new StringBuffer();
if (alUSERid.size() > 0) {
	for (int i = 0; i < alUSERid.size(); i++) {
		htTemp = (Hashtable) alUSERid.get(i);
		strValue = (String) htTemp.get("USERid");
		strDesc = (String) htTemp.get("USERname");
		sbUserId.append("<option value=\"").append(strValue).append("\">").append(strValue).append(" / ").append(strDesc).append("</option>");
	}
} else {
	sbUserId.append("<option value=\"\">&nbsp;</option>");
}
%>
<HTML>
<HEAD>
<TITLE>票據查詢--歷史資料</TITLE>
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
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	if (document.getElementById("txtAction").value == "")
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' );
		document.getElementById("updateArea").style.display = "none";
		document.getElementById("inqueryArea").style.display = "block";
	}
	else
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyExit,'' ) ;	     
		document.getElementById("updateArea").display = "block";
		document.getElementById("inqueryArea").display = "none"; 
	}
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBQuery/DISBQryChkHI.jsp?";
}

/* 當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行 */
function inquiryAction()
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
	
		 modalDialog 會傳回使用者選定之用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開
		*/
		mapValue();

		var strSql = "SELECT CBKNO,CACCOUNT,CNO,CNM,CAMT,CAST(CHEQUEDT AS CHAR(7)) AS CHEQUEDT,";
		strSql += " CAST(CUSEDT AS CHAR(7)) AS CUSEDT,CSTATUS,MEMO,DTAFRM,";
		strSql += " CAST(CRTNDT AS CHAR(7)) AS CRTNDT,ENTRYUSR,ENTRYDT,CBNO,CHG4USER";
		strSql += " FROM CAPCHKFHI ";
		strSql += " WHERE 1=1 ";
		if ( document.getElementById("txtCHEQUE").value != "" ) {
			strSql += "   AND CNO= '" + document.getElementById("txtCHEQUE").value.toUpperCase() + "' ";						
		}
		if( document.getElementById("txtPName").value != "" ) {
			strSql += "  AND CNM like '^" +  document.getElementById("txtPName").value + "^' ";
		}
		if( document.getElementById("txtPAMT").value != "" ) {
			strSql += " AND  CAMT = " + document.getElementById("txtPAMT").value + " ";
		}
		if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value != "") {
			strSql += " AND  CHEQUEDT BETWEEN " + document.getElementById("txtPStartDate").value + " and " + document.getElementById("txtPEndDate").value;
		} else if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value == "") {
			strSql += "  AND CHEQUEDT >= " + document.getElementById("txtPStartDate").value ;
		} else if (document.getElementById("txtPStartDate").value == "" && document.getElementById("txtPEndDate").value != "") {
			strSql += " AND  CHEQUEDT <= " + document.getElementById("txtPEndDate").value ;
		}

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=820";
		<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	    session.setAttribute("Heading","受款人姓名,支付金額,票據狀態,到期日,開立日");
	    session.setAttribute("DisplayFields", "CNM,CAMT,CSTATUS,CHEQUEDT,CUSEDT");
	    session.setAttribute("ReturnFields", "CBKNO,CACCOUNT,CNO,CNM,CAMT,CHEQUEDT,CUSEDT,CSTATUS,MEMO,DTAFRM,CRTNDT,ENTRYUSR,ENTRYDT,CBNO,CHG4USER");
	    %>
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" )
		{
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtUBKNO").value = returnArray[0];
			document.getElementById("txtUACCOUNT").value = returnArray[1];			
			document.getElementById("txtCHEQUE_NO").value = returnArray[2];
			document.getElementById("txtUPName").value = returnArray[3];
			document.getElementById("txtUPAMT").value = returnArray[4];
			document.getElementById("txtCHEQUE_DATE").value = returnArray[5];			
			document.getElementById("txtCHEQUE_USED_DATE").value = returnArray[6];
			document.getElementById("txtChequeMEMO").value = returnArray[8];
			document.getElementById("txtCHEQUE_RETURN_DATE").value = returnArray[10];
			document.getElementById("txtENTRYUSR").value = returnArray[11];
			document.getElementById("txtENTRYDT").value = returnArray[12];
			document.getElementById("txtC4User").value = returnArray[14];
			document.getElementById("txtCBNO").value = returnArray[13];
            //資料來源
			var strDataFrom =returnArray[9];
			if(strDataFrom =="WT"){
				document.getElementById("txtDataFrom").value ="萬通系統";
			} else if (strDataFrom ="DC") {
				document.getElementById("txtDataFrom").value ="全美系統";
			}
			//票據狀態			            
            var strChqST =returnArray[7];
            if (strChqST =="D"){
            	document.getElementById("txtCHEQUE_STATUS").value ="開立";
            } else if (strChqST =="C") {
            	document.getElementById("txtCHEQUE_STATUS").value ="兌現";
            } else if (strChqST =="R") {
            	document.getElementById("txtCHEQUE_STATUS").value ="退回";
            } else if (strChqST =="V") {
            	document.getElementById("txtCHEQUE_STATUS").value ="作廢";
            } else if (strChqST =="1") {
            	document.getElementById("txtCHEQUE_STATUS").value ="逾一年";
            } else if (strChqST =="2") {
            	document.getElementById("txtCHEQUE_STATUS").value ="逾二年";
            } else if (strChqST =="3") {
            	document.getElementById("txtCHEQUE_STATUS").value ="重印";
            } else if (strChqST =="4") {
            	document.getElementById("txtCHEQUE_STATUS").value ="重開";
            } else if (strChqST =="5") {
            	document.getElementById("txtCHEQUE_STATUS").value ="掛失";
            } else if (strChqST =="6") {
            	document.getElementById("txtCHEQUE_STATUS").value ="除權判決";
            } else {
            	document.getElementById("txtCHEQUE_STATUS").value ="庫存";
            }

			if("<%=strUserDept%>" == "FIN") {
				document.getElementById("buttonArea").style.display = "block";

				document.getElementById("txtChequeMEMO").className = "DATA";

				if(strChqST != "4")
				{
					document.getElementById("Update4").style.display = "block";
				}

				if (strChqST == "4" || document.getElementById("Update4").style.display == "block")
				{
					document.getElementById("Update4User").style.display = "block";
					if (strChqST != "4")
					{
						document.getElementById("txtC4User").className = "Data";
						document.getElementById("txtC4User").readOnly =  false;
					}
				}
			}

			WindowOnLoadCommon( document.title , '' , 'E', '' );
			document.getElementById("updateArea").style.display = "block"; 
			document.getElementById("inqueryArea").style.display = "none"; 
		}
	}
}

function mapValue() {
	document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value) ;
	document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value) ;	
}

//修改備註
function updateDataAction() {
	document.getElementById("txtAction").value = "UpdateData";
	document.getElementById("frmMain").submit();
}
//重開
function update4Action() 
{
	if (document.getElementById("txtC4User").value == "")
	{
		alert("重開票據請輸入申請的USER!");
	}
	else
	{
		document.getElementById("txtAction").value = "Update4";
		document.getElementById("txtUpdateStatus").value = "4";
		document.getElementById("frmMain").submit();
	}
}

function checkClientField(objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";

	if( objThisItem.name == "txtPStartDateC" ||  objThisItem.name == "txtPEndDateC" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
        strTmpMsg = "系統日期-日期格式有誤";
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
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbquery.DISBQryChkHIServlet">
<TABLE border="1" width="452"  id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">受款人姓名：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="25" width="333"
				id="txtPName" name="txtPName" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">支付金額：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11"
				name="txtPAMT" id="txtPAMT" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">到期日期：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC" name="txtPStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> <INPUT
				type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> ~ <INPUT
				class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC"
				name="txtPEndDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> <INPUT
				type="hidden" name="txtPEndDate" id="txtPEndDate" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">支票號碼：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="16"
				name="txtCHEQUE" id="txtCHEQUE" value=""></TD>
		</TR>		
	</TBODY>
</TABLE>
<TABLE id="buttonArea" style="display:none">
	<TR>
		<TD id="Update4" style="display:none"><INPUT type="button" name="btnUpdate4" id="btnUpdate4" onClick="update4Action();" value="重開"></TD>
		<TD id="UpdateData"><INPUT type="button" name="btnUpdateData" id="btnUpdateData" onClick="updateDataAction();" value="修改備註"></TD>
	</TR>
</TABLE>
<TABLE border="1" width="600" id="updateArea" style="display:none">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="120">受款人姓名：</TD>
			<TD width="180"><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="11"
				id="txtUPName" name="txtUPName" ></TD>
			<TD align="right" class="TableHeading" width="120">支付金額：</TD>
			<TD width="180"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtUPAMT" id="txtUPAMT" ></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >行庫：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="11"
				id="txtUBKNO" name="txtUBKNO" ></TD>
			<TD align="right" class="TableHeading" >帳號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtUACCOUNT" id="txtUACCOUNT" ></TD>
		</TR>		
		<TR>
			<TD align="right" class="TableHeading" >票號：</TD>
			<TD ><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="11" id="txtCHEQUE_NO" name="txtCHEQUE_NO" value="" ></TD>
			<TD align="right" class="TableHeading" >開立日期：</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="11" id="txtCHEQUE_USED_DATE" name="txtCHEQUE_USED_DATE" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >支票狀態：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCHEQUE_STATUS" id="txtCHEQUE_STATUS" readOnly>
				<INPUT type="hidden" 
				name="txtCHEQUE_STATUS_HIDE" id="txtCHEQUE_STATUS_HIDE" value="2" />
				</TD>
			<TD align="right" class="TableHeading" >票據到期日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCHEQUE_DATE" id="txtCHEQUE_DATE" readOnly></TD>
		</TR>		
		<TR>
			<TD align="right" class="TableHeading" >兌現日期：</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="11" id="txtCHEQUE_RETURN_DATE" name="txtCHEQUE_RETURN_DATE" readOnly></TD>
			<TD align="right" class="TableHeading" >異動人員：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtENTRYUSR" name="txtENTRYUSR" ></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >資料來源：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtDataFrom"  name="txtDataFrom" ></TD>		
			<TD align="right" class="TableHeading" >異動日期：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtENTRYDT" id="txtENTRYDT" ></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >票據備註：</TD>
			<TD colspan="3"><INPUT class="INPUT_DISPLAY" type="text" id="txtChequeMEMO" name="txtChequeMEMO" size="50" maxlength="50"></TD>
		</TR>
		<TR id="Update4User" style="display:none">
			<TD align="right" class="TableHeading">申請重開 User：</TD>
			<TD colspan="3">
				<INPUT class="INPUT_DISPLAY" size="15" type="text" maxlength="10" name="txtC4User" id="txtC4User" ONKEYUP="autoComplete(this,this.form.options,'value',true,'selList')">
				<span style="display: none" id="selList">
					<SELECT NAME="options" onChange="this.form.txtC4User.value=this.options[this.selectedIndex].value" MULTIPLE SIZE=4 onblur="disableList('selList')" class="Data">
						<%=sbUserId.toString()%>
					</SELECT>
				</span>
			</TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtCBNO" name="txtCBNO" value="">
<INPUT type="hidden" id="txtUpdateStatus" name="txtUpdateStatus" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>