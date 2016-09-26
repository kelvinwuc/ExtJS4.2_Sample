<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CASHWEB
 * 
 * Function : 現金收入日報表
 * 
 * Remark   : 對帳報表
 * 
 * Revision : $Revision: 1.9 $
 * 
 * Author   : 
 * 
 * Create Date : $Date: 2014/04/02 00:52:20 $
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $$Log: DayCasRptC.jsp,v $
 * $Revision 1.9  2014/04/02 00:52:20  misariel
 * $R00135---PA0024---CASH年度專案(SQL turning)
 * $
 * $Revision 1.8  2014/03/21 08:01:54  misariel
 * $R00135---PA0024---CASH年度專案(修改CAPSIL輸入者長度)
 * $
 * $Revision 1.7  2014/03/20 01:22:12  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $ORDUTV -> ORDUTQ
 * $ORNBTV -> ORNBTQ
 * $
 * $Revision 1.6  2014/03/19 09:34:03  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $新增現金收入日報表顯示無效保單的入帳及RCPP檢核表不鎖定日期
 * $
 * $Revision 1.5  2014/01/03 02:51:37  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $$
 *  
 */
%><%!String strThisProgId = "DayCasRpt"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();

Hashtable htTemp = null;
String strValue = null;

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alCurrCash = new ArrayList(); 
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>現金收入日報表</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
// *************************************************************
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title, "", strDISBFunctionKeyInitial, "");
	window.status = "請輸入條件後按查詢鍵";
}

function inquiryAction() 
{
	var varMsg = "";
	if(document.getElementById("para_Currency").value == "")
	{
		varMsg = "幣別不可為空白\n\r";
	}
	if(document.getElementById("dspCaeGet").value == "")
	{
		varMsg += "入帳日期不可為空白\n\r";
	}

	if(varMsg != "")
	{
		alert(varMsg);
		return false;
	}

	mapValue();
	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DailyCas.pdf";
		document.frmMain2.OutputType.value = "PDF";
		document.frmMain2.OutputFileName.value = "DailyCas2.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "XLS";
		document.frmMain.OutputFileName.value = "DailyCas.xls";
		document.frmMain2.OutputType.value = "XLS";
		document.frmMain2.OutputFileName.value = "DailyCas2.xls";
	}

	getReportInfo();
	getReportInfo2();

	document.getElementById("frmMain").target="_blank";
	document.getElementById("frmMain").submit();

	document.getElementById("frmMain2").target="_blank";
	document.getElementById("frmMain2").submit();
}

function mapValue() {
	document.getElementById("para_p_caegdt").value = rocDate2String(document.getElementById("dspCaeGet").value);
	document.getElementById("para_POCURR").value = document.getElementById("para_Currency").value;
	document.getElementById("para_CreateDate").value = document.getElementById("para_p_caegdt").value;
	document.getElementById("para_CreateUser").value = document.getElementById("txtEntryID").value;

	document.frmMain.para_POCURR.value = document.getElementById("para_POCURR").value;
	document.frmMain.para_CreateDate.value = document.getElementById("para_CreateDate").value;
	document.frmMain.para_CreateUser.value = document.getElementById("para_CreateUser").value;

	document.frmMain2.para_POCURR.value = document.getElementById("para_POCURR").value;
	document.frmMain2.para_CreateDate.value = document.getElementById("para_CreateDate").value;
	document.frmMain2.para_CreateUser.value = document.getElementById("para_CreateUser").value;

}

function checkClientField(objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";

	if( objThisItem.name == "dspCaeGet" )
	{
		bDate = true;
		bDate = isValidDate(objThisItem.value, "C");
		if (bDate == false) {
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

function getReportInfo()
{
	var currentDate = new Date("<%=calendar.get(Calendar.YEAR)%>","<%=calendar.get(Calendar.MONTH)%>","<%=calendar.get(Calendar.DAY_OF_MONTH)%>");
	var today = getROCDateTime(2, currentDate);

	var strSql = "select a.RECEIPTNO,a.RECEIPSEQ,a.CRTDATE-1110000 as CRTDATE,a.CRTUSER,";
	strSql += "CASE WHEN LENGTH(RTRIM(TRANSLATE(a.PAYIND, '*', ' 0123456789'))) = 0 THEN 'RCPP' ELSE '批次作業' END as GRP_1,";
	strSql += "a.PAYIND,a.CASHBNK,CASE WHEN e.RPRSCD='R' THEN a.PAYAMT*(-1) ELSE a.PAYAMT END as PAYAMT,TRIM(substring(et.FLD0004,7,8)) as PayDesc,";
	strSql += "CASE WHEN a.PAYIND='G' THEN CASE WHEN a.CREDITCAT<>'A' THEN 'B' ELSE a.CREDITCAT END ELSE IFNULL(a.CASHBNK,'') END as BKCODE,";
	strSql += "CASE WHEN a.PAYIND IN ('0','1','4','5','6','7','A','B','C','E','H') THEN b.BKATNO ELSE '' END as BKATNO,";
	strSql += "CASE WHEN a.PAYIND IN ('1','4','5','6','7','A','B','C','E') THEN b.BKNAME ";
	strSql += "     WHEN a.PAYIND='0' THEN CASE WHEN IFNULL(a.CASHBNK,'')='9999' THEN '臨時憑證' ELSE b.BKNAME END ";
	strSql += "     WHEN a.PAYIND='2' THEN '應收票據-CAPSIL' ";
	strSql += "     WHEN a.PAYIND='H' THEN '銀行轉帳請款成功件' ";
	strSql += "     WHEN a.PAYIND IN ('8','F') THEN '便利商店' ";
	strSql += "     WHEN a.PAYIND IN ('3','G') THEN CASE a.CREDITCAT WHEN 'A' THEN '信用卡請款成功件-台新' ELSE '信用卡請款成功件-花旗' END ";
	strSql += "ELSE '' END as BKNAME,";
	strSql += "CASE WHEN a.PAYIND IN ('1','4','5','6','7','A','B','C','E','H') THEN b.GLACT ";
	strSql += "     WHEN a.PAYIND='0' THEN CASE WHEN IFNULL(a.CASHBNK,'')='9999' THEN '120001' ELSE b.GLACT END ";
	strSql += "     WHEN a.PAYIND='2' THEN '110000-0000N1' ";
	strSql += "     WHEN a.PAYIND IN ('8','F') THEN '111000-0000P5' ";
	strSql += "     WHEN a.PAYIND IN ('3','G') THEN CASE a.CREDITCAT WHEN 'A' THEN '111000-0000P1' ELSE '111000-0000P3' END ELSE '' END as GLACT, ";
	strSql += "IFNULL((CASE WHEN a.PAYIND='H' THEN po.FLD0055 ELSE b.BKCURR END),'NT') as FLD0055,d.FLD0004 as CurrDesc ";

	if(document.getElementById("para_p_caegdt").value == today ) {
		strSql += "from NBM0200F e ";
	} else {
		strSql += "from NBM0200FH e ";
	}

//R00135	strSql += "JOIN ORNBTA a ON a.RECEIPTNO=e.RRCPTNO ";
	strSql += "JOIN ORNBTA a ON a.RECEIPTNO=e.RRCPTNO and a.RECEIPSEQ > 0 "; //R00135
	strSql += "JOIN ORDUET et on et.FLD0001='  ' and et.fld0002='PAYID' and et.FLD0003=a.PAYIND ";
	strSql += "LEFT JOIN CAPBNKF b on a.CASHBNK=b.BKALAT and a.PAYIND IN ('0','1','4','5','6','7','8','A','B','C','E','F','H') and a.CASHBNK<>'' and b.BKSTAT='Y' ";
	strSql += "LEFT JOIN ORDUTA c on c.FLD0001='  ' and c.FLD0002=SUBSTR(a.RECEIPTNO,1,2) and c.FLD0003=SUBSTR(a.RECEIPTNO,3) and a.PAYIND='H' ";
	strSql += "LEFT JOIN ORDUPO po on po.FLD0001='  ' and po.FLD0002=(CASE WHEN c.TATYPE='F' THEN TRIM(c.FLD0011)||'0' ELSE c.FLD0011 END) ";
	strSql += "LEFT JOIN ORDUET d on d.FLD0001='  ' and d.fld0002='CURRN' and d.FLD0003=IFNULL((CASE WHEN a.PAYIND='H' THEN po.FLD0055 ELSE b.BKCURR END),'NT') ";
	strSql += "where a.RECEIPTNO<>'' ";

	if(document.getElementById("para_Currency").value != "")
	{
		strSql += " AND IFNULL((CASE WHEN a.PAYIND='H' THEN po.FLD0055 ELSE b.BKCURR END),'NT') = '" + document.getElementById("para_Currency").value + "' ";
	}
	if(document.getElementById("para_p_caegdt").value != "")
	{
		var varDt = parseInt(document.getElementById("para_p_caegdt").value) + 1110000;
		if(document.getElementById("para_p_caegdt").value != today ) {
			strSql += " AND e.CRTDT = '" + varDt + "' ";
		}
	}
	if(document.getElementById("txtEntryID").value != "")
	{
		strSql += " AND e.RUSER = '" + document.getElementById("txtEntryID").value + "' ";
	}

	strSql += "order by CRTDATE,CRTUSER,GRP_1,PAYIND,BKCODE";

	//document.getElementById("ReportSQL").value = strSql;
	document.frmMain.ReportSQL.value = strSql;
}

function getReportInfo2()
{
	var currentDate = new Date("<%=calendar.get(Calendar.YEAR)%>","<%=calendar.get(Calendar.MONTH)%>","<%=calendar.get(Calendar.DAY_OF_MONTH)%>");
	var today = getROCDateTime(2, currentDate);

	var strSql = "select a.RECEIPTNO,a.RECEIPSEQ,a.CRTDATE-1110000 as CRTDATE,a.CRTUSER,";
	strSql += "CASE WHEN LENGTH(RTRIM(TRANSLATE(a.PAYIND, '*', ' 0123456789'))) = 0 THEN 'RCPP' ELSE '批次作業' END as GRP_1,";
	strSql += "a.PAYIND,a.CASHBNK,CASE WHEN e.RPRSCD='R' THEN a.PAYAMT*(-1) ELSE a.PAYAMT END as PAYAMT,TRIM(substring(et.FLD0004,7,8)) as PayDesc,";
	strSql += "CASE WHEN a.PAYIND='G' THEN CASE WHEN a.CREDITCAT<>'A' THEN 'B' ELSE a.CREDITCAT END ELSE IFNULL(a.CASHBNK,'') END as BKCODE,";
	strSql += "CASE WHEN a.PAYIND IN ('0','1','4','5','6','7','A','B','C','E','H') THEN b.BKATNO ELSE '' END as BKATNO,";
	strSql += "CASE WHEN a.PAYIND IN ('1','4','5','6','7','A','B','C','E') THEN b.BKNAME ";
	strSql += "     WHEN a.PAYIND='0' THEN CASE WHEN IFNULL(a.CASHBNK,'')='9999' THEN '臨時憑證' ELSE b.BKNAME END ";
	strSql += "     WHEN a.PAYIND='2' THEN '應收票據-CAPSIL' ";
	strSql += "     WHEN a.PAYIND='H' THEN '銀行轉帳請款成功件' ";
	strSql += "     WHEN a.PAYIND IN ('8','F') THEN '便利商店' ";
	strSql += "     WHEN a.PAYIND IN ('3','G') THEN CASE a.CREDITCAT WHEN 'A' THEN '信用卡請款成功件-台新' ELSE '信用卡請款成功件-花旗' END ";
	strSql += "ELSE '' END as BKNAME,";
	strSql += "CASE WHEN a.PAYIND IN ('1','4','5','6','7','A','B','C','E','H') THEN b.GLACT ";
	strSql += "     WHEN a.PAYIND='0' THEN CASE WHEN IFNULL(a.CASHBNK,'')='9999' THEN '120001' ELSE b.GLACT END ";
	strSql += "     WHEN a.PAYIND='2' THEN '110000-0000N1' ";
	strSql += "     WHEN a.PAYIND IN ('8','F') THEN '111000-0000P5' ";
	strSql += "     WHEN a.PAYIND IN ('3','G') THEN CASE a.CREDITCAT WHEN 'A' THEN '111000-0000P1' ELSE '111000-0000P3' END ELSE '' END as GLACT, ";
	strSql += "IFNULL((CASE WHEN a.PAYIND='H' THEN po.FLD0055 ELSE b.BKCURR END),'NT') as FLD0055,d.FLD0004 as CurrDesc ";

	if(document.getElementById("para_p_caegdt").value == today ) {
		strSql += "from NBM0200F e ";
	} else {
		strSql += "from NBM0200FH e ";
	}

//R00135	strSql += "JOIN ORNBTQ a ON a.RECEIPTNO=e.RRCPTNO ";
	strSql += "JOIN ORNBTQ a ON a.RECEIPTNO=e.RRCPTNO and a.RECEIPSEQ > 0 ";//R00135
	strSql += "JOIN ORDUET et on et.FLD0001='  ' and et.fld0002='PAYID' and et.FLD0003=a.PAYIND ";
	strSql += "LEFT JOIN CAPBNKF b on a.CASHBNK=b.BKALAT and a.PAYIND IN ('0','1','4','5','6','7','8','A','B','C','E','F','H') and a.CASHBNK<>'' and b.BKSTAT='Y' ";
	strSql += "LEFT JOIN ORDUTQ c on c.FLD0001='  ' and c.FLD0002=SUBSTR(a.RECEIPTNO,1,2) and c.FLD0003=SUBSTR(a.RECEIPTNO,3) and a.PAYIND='H' ";
	strSql += "LEFT JOIN ORDUPO po on po.FLD0001='  ' and po.FLD0002=(CASE WHEN c.TATYPE='F' THEN TRIM(c.FLD0011)||'0' ELSE c.FLD0011 END) ";
	strSql += "LEFT JOIN ORDUET d on d.FLD0001='  ' and d.fld0002='CURRN' and d.FLD0003=IFNULL((CASE WHEN a.PAYIND='H' THEN po.FLD0055 ELSE b.BKCURR END),'NT') ";
	strSql += "where a.RECEIPTNO<>'' ";

	if(document.getElementById("para_Currency").value != "")
	{
		strSql += " AND IFNULL((CASE WHEN a.PAYIND='H' THEN po.FLD0055 ELSE b.BKCURR END),'NT') = '" + document.getElementById("para_Currency").value + "' ";
	}
	if(document.getElementById("para_p_caegdt").value != "")
	{
		var varDt = parseInt(document.getElementById("para_p_caegdt").value) + 1110000;
		if(document.getElementById("para_p_caegdt").value != today ) {
			strSql += " AND e.CRTDT = '" + varDt + "' ";
		}
	}
	if(document.getElementById("txtEntryID").value != "")
	{
		strSql += " AND e.RUSER = '" + document.getElementById("txtEntryID").value + "' ";
	}

	strSql += "order by CRTDATE,CRTUSER,GRP_1,PAYIND,BKCODE";

	document.frmMain2.ReportSQL.value = strSql;
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<FORM name="frmMain" method="POST" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="1" width="450">
	<TR>
		<TD align="right" class="TableHeading" width="150">幣別*：</TD>
		<TD width="300" valign="middle">
			<select size="1" name="para_Currency" id="para_Currency" class="Data">
				<%=sbCurrCash.toString()%>
			</select>
		</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">入帳日期*：</TD>
		<TD>
			<INPUT type="text" name="dspCaeGet" id="dspCaeGet" size="9" maxlength="9" class="Data" onblur="checkClientField(this,true);">
			<a href="javascript:show_calendar('frmMain.dspCaeGet','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
			</a>
			<INPUT type="hidden" id="para_p_caegdt" name="para_p_caegdt" value="">
		</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">CAPSIL輸入者ID：</TD>
		<TD><INPUT type="text" size="10" maxlength="4" id="txtEntryID" name="txtEntryID" value="" class="Data">&nbsp;&nbsp;&nbsp;(空白表示全部)</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">報表格式：</TD>
		<TD>
			<input type="radio" id="rdReportForm" name="rdReportForm" value="PDF" class="Data" checked>PDF 
			<input type="radio" id="rdReportForm" name="rdReportForm" value="XLS" class="Data">EXCEL
		</TD>
	</TR>
	<TR><TD colspan="2"><BR><BR>&nbsp;* 為必輸欄位</TD></TR>
</TABLE>

<INPUT type="hidden" id="ReportName" name="ReportName" value="DayCasRpt.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DailyCas.PDF">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DayCasRpt\\">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="para_POCURR" name="para_POCURR" value="">
<INPUT type="hidden" id="para_CreateDate" name="para_CreateDate" value="">
<INPUT type="hidden" id="para_CreateUser" name="para_CreateUser" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
</FORM>
<FORM name="frmMain2" method="POST" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DayCasRpt2.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DailyCas2.PDF">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DayCasRpt\\">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="para_POCURR" name="para_POCURR" value="">
<INPUT type="hidden" id="para_CreateDate" name="para_CreateDate" value="">
<INPUT type="hidden" id="para_CreateUser" name="para_CreateUser" value="">
</FORM>
</BODY>
</HTML>
