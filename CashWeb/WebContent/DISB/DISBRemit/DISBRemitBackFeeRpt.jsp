<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 後收手續費->輸入維護
 * 
 * Remark   : 出納功能
 * 
 * Revision : $Revision: 1.9 $
 * 
 * Author   : Vanessa Liao
 * 
 * Create Date : 2006/11/30
 * 
 * Request ID :R60550
 * 
 * CVS History:
 * 
 * $Log: DISBRemitBackFeeRpt.jsp,v $
 * Revision 1.9  2015/10/20 03:20:29  001946
 * *** empty log message ***
 *
 * Revision 1.8  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 * Revision 1.7  2013/03/11 07:50:50  ODCWilliam
 * Revision 1.6  2013/02/26 10:13:23  ODCWilliam
 * william wu
 * RA0074
 *
 * Revision 1.5  2012/08/29 02:57:52  ODCKain
 * Calendar problem
 *
 * Revision 1.4  2010/11/23 02:39:11  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.3  2008/08/06 07:05:19  MISODIN
 * R80338 調整CASH系統 for 出納外幣一對一需求
 *
 * Revision 1.2  2007/01/04 03:26:17  MISVANESSA
 * R60550_抓取方式修改
 *
 * Revision 1.1  2006/11/30 09:13:37  MISVANESSA
 * R60550_配合SPUL&外幣付款修改
 *
 */
%><%! String strThisProgId = "DISBRemitBackFeeRpt"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strAction = (request.getAttribute("txtAction") != null)?((String) request.getAttribute("txtAction")):"";

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") ==null){
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList",alPBBank);
}else{
	alPBBank =(List) session.getAttribute("PBBankList");
}

List alCurrCash = new ArrayList(); //R80338 保單幣別挑選
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}//R80338 END

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbPBBank = new StringBuffer();
if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		htTemp = (Hashtable) alPBBank.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbPBBank.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
} else {
	sbPBBank.append("<option value=\"\">&nbsp;</option>");
}

StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"\">&nbsp;</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
}
%>
<HTML>
<HEAD>
<TITLE>出納功能--後收手續費報表</TITLE>
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
   	WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' ) ;
    window.status = "";
}

/* 當toolbar frame 中之[報表]按鈕被點選時,本函數會被執行 */
function printRAction()
{
	window.status = "";
	strErrMsg = "";
	mapValue();
	if(checkFieldOK())
	{
		document.getElementById("txtAction").value = "L";
		WindowOnLoadCommon( document.title , '' , 'E','' );
		getReportInfo();
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
	}
	else
	{
		alert( strErrMsg );	
	}	   
}

function getReportInfo()
{
	var strSql = "select A.PACCT,A.RMTDT,A.RACCT,A.RNAME,A.RPAYCURR,A.RPAYAMT,A.RPAYFEEWAY,";
	strSql += "  A.RMTFEE,A.BATNO,C.DEPT,A.SEQNO,A.RPAYMIDCUR,A.RPAYMIDFEE,A.RPAYMIDDT,";
	strSql += "  A.RBKSWIFT,A.RBKCOUNTRY,A.RBKBRCH,A.RENGNAME,S.BANK_NAME as SWBKNAME,A.RPCURR";  //R80338	
	strSql += " from CAPRMTF A";
	strSql += " LEFT OUTER JOIN USER C ON A.ENTRYUSR = C.USRID";
	strSql += " LEFT OUTER JOIN ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE AND SUBSTR(A.RBK,1,3)=S.BANK_NO"; //QD0285:修正中華開發工業銀行與凱基銀行的SWIFT CODE是相同
	strSql += " WHERE 1=1";
    strSql += " AND A.RPAYMIDDT = " + document.getElementById("txtBKFEEDT").value;
    strSql += " AND A.PACCT = '" + document.getElementById("txtPACCT").value.substring(8, 25) + "' ";

 	if( document.getElementById("selPOCurr").value != "" ) {   //R80338
		strSql += " AND A.RPCURR = '" + document.getElementById("selPOCurr").value + "' ";    //R80338
  	}    //R80338

	strSql += " ORDER BY A.BATNO,A.RACCT,A.RENGNAME,A.RPAYCURR";

	document.frmMain.ReportSQL.value = strSql;
	document.frmMain.para_PACCT.value = document.getElementById("txtPACCT").value.substring(8, 25);
	document.frmMain.para_PBKFEEDT.value = document.getElementById("txtBKFEEDT").value;
}

/* 當toolbar frame 中之離開按鈕被點選時,本函數會被執行 */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitBackFeeRpt.jsp";
}

function mapValue() {
	document.getElementById("txtBKFEEDT").value = rocDate2String(document.getElementById("txtBKFEEDTC").value) ;
}

function checkFieldOK()
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if(document.getElementById("txtBKFEEDTC").value=="")
	{
		strTmpMsg = "請輸入後收手續費日期!\r\n";
		bReturnStatus = false;;
	} else {
		bReturnStatus = checkClientField( document.getElementById("txtBKFEEDTC"), false );
	}
	if(document.getElementById("txtPACCT").value=="")
	{
		strTmpMsg += "請輸入全球匯出銀行帳號!\r\n";
		bReturnStatus = false;;
	}
	if( !bReturnStatus )
	{
		strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtBKFEEDTC"  ) {
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
        	strTmpMsg = "後收手續費日期-日期格式有誤";
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
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="450" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="130">全球匯出銀行帳號：</TD>
			<TD>
				<select size="1" name="txtPACCT" id="txPACCT">
					<%=sbPBBank.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">後收手續費日期：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtBKFEEDTC" name="txtBKFEEDTC" value=""> 
				<a href="javascript:show_calendar('frmMain.txtBKFEEDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT type="hidden" name="txtBKFEEDT" id="txtBKFEEDT" value="" >
			</TD>
		</TR>
		<!-- R80338 保單幣別 -->
		<TR>
			<TD align="right" class="TableHeading">保單幣別：</TD>
			<TD>
				<select size="1" name="selPOCurr" id="selPOCurr">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>				
	</TBODY>
</TABLE>

<!--指向RAS所在位置,report也要放在所指路徑-->
<INPUT id="ReportName" type="hidden" name="ReportName" value="DISBRemitBackFeeRpt.rpt">
<INPUT id="OutputType" type="hidden" name="OutputType" value="PDF">
<INPUT id="OutputFileName" type="hidden" name="OutputFileName" value="DISBRemitBackFeeRpt.pdf">
<INPUT id="ReportSQL" type="hidden" name="ReportSQL" value="">
<INPUT id="ReportPath" type="hidden" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBRemit\\">
<INPUT	name="txtAction" id="txtAction" type="hidden"	value="<%=strAction%>">
<INPUT type="hidden" name="para_PACCT" id="para_PACCT" value="">
<INPUT type="hidden" name="para_PBKFEEDT" id="para_PBKFEEDT" value="">	
</FORM>
</BODY>
</HTML>