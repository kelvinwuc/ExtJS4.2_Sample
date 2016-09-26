<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb 
 * 
 * Function : 應付票據明細表
 * 
 * Remark   : 支付報表
 * 
 * Revision : $Revision: 1.15 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2015/10/02 05:41:17 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBCDetailsReports.jsp,v $
 * Revision 1.15  2015/10/02 05:41:17  001946
 * *** empty log message ***
 *
 * Revision 1.14  2014/10/31 02:47:51  misariel
 * RC0036-Bug fix
 *
 * Revision 1.12  2013/12/24 03:56:46  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.11  2013/02/26 03:17:12  ODCZheJun
 * R00135 BRD5-5----5-9
 *
 * Revision 1.10  2013/01/09 03:24:24  MISSALLY
 * Calendar problem
 *
 * Revision 1.9  2013/01/08 04:25:56  MISSALLY
 * 將分支的程式Merge至HEAD
 *
 * Revision 1.6.4.1  2012/12/06 06:28:24  MISSALLY
 * RA0102　PA0041
 * 配合法令修改酬佣支付作業
 *
 * Revision 1.6  2010/11/23 02:51:38  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.4  2008/08/18 06:18:19  MISODIN
 * R80338 調整銀行帳號選單的預設值
 *
 * Revision 1.3  2008/06/12 02:12:24  MISODIN
 * R80244 FIN分成FIN & ACCT
 *
 * Revision 1.2  2006/07/14 03:57:56  MISangel
 * R60200:出納功能提升
 *
 * Revision 1.1  2006/06/29 09:40:41  MISangel
 * Init Project
 *
 * Revision 1.1.2.8  2006/06/14 10:01:53  misangel
 * R60183:新增對帳報表
 *
 * Revision 1.1.2.7  2005/10/31 03:30:54  misangel
 * R50820:增加狀態日
 *
 * Revision 1.1.2.5  2005/04/04 07:02:20  miselsa
 * R30530 支付系統
 *
 */
%><%! String strThisProgId = "DISBCDetailsReports"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String strReturnMessage = (request.getParameter("txtMsg") !=null) ? request.getParameter("txtMsg") : "";
String strAction = (request.getAttribute("txtAction") != null) ? (String) request.getAttribute("txtAction") : "";
String strUserDept = (session.getAttribute("LogonUserDept") != null) ? CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept")) : "";
String strUserRight = (session.getAttribute("LogonUserRight") != null) ? CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight")) : "";
String strUserId = (session.getAttribute("LogonUserId") != null) ? CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")) : "";

List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") == null) {
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList",alPBBank);
} else {
	alPBBank =(List) session.getAttribute("PBBankList");
}

List alPSrcGrp = new ArrayList();
if (session.getAttribute("SrcGpList") == null) {
	alPSrcGrp = (List) disbBean.getETable("SRCGP", "");
	session.setAttribute("SrcGpList",alPSrcGrp);
} else {
	alPSrcGrp =(List) session.getAttribute("SrcGpList");
}

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbPBBank = new StringBuffer();
sbPBBank.append("<option value=\"8220635/635300021303\">8220635/635300021303-中信銀復興</option>");
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

StringBuffer sbPSrcGrp = new StringBuffer();
sbPSrcGrp.append("<option value=\"\">全部</option>");
if (alPSrcGrp.size() > 0) {
	for (int i = 0; i < alPSrcGrp.size(); i++) {
		htTemp = (Hashtable) alPSrcGrp.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbPSrcGrp.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}
	htTemp = null;
	strValue = null;
	strDesc = null;
}
%>
<HTML>
<HEAD>
<TITLE>應付票據查詢明細表</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientR.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;

	if(document.getElementById("txtUserDept").value != "FIN" && document.getElementById("txtUserDept").value != "ACCT")  // R80244
	{
		alert("無執行此報表權限");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else
	{
		WindowOnLoadCommon( document.title, '', strFunctionKeyReport, '' );
	}
	window.status = "";
}
/* 當toolbar frame 中之<報表>按鈕被點選時,本函數會被執行 */
function printRAction()
{
	getReportInfo();
	document.getElementById("frmMain").target="_blank";
	document.getElementById("frmMain").submit();
}

function getReportInfo()
{
	mapValue();

	var varReportForm = 0;
	for (var i=0; i<document.forms[0].rdReportForm.length; i++)
	{
		if (document.forms[0].rdReportForm[i].checked)
		{
			varReportForm = i;
			break;
		}
	}

	if(varReportForm == 0 || varReportForm == 2)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DISBCDetailsReports.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain.OutputFileName.value = "DISBCDetailsReports.rpt";
	}

	var strSql = "";
	//應付票據查詢明細表
	if(document.frmMain.rdReport[0].checked) 
	{
		//RA0102
		if(varReportForm == 4)
		{
			document.frmMain.OutputType.value = "recXLS";
			document.frmMain.OutputFileName.value = "DISBCDetailsReports.xls";
			document.frmMain.ReportName.value = "DISBCDetailsPolicyXls.rpt";
		}
		else
		{
			document.frmMain.ReportName.value = "DISBCDetailsPolicy.rpt";
		}

		//strSql = "SELECT A.*,B.PCHKM1,B.ENTRYUSR,B.POLICYNO,B.APPNO,B.PDESC,C.FLD0004 ,D.DEPT FROM CAPCHKF A " ;
		strSql = "SELECT A.*,B.PCHKM1,B.PCHKM2,B.ENTRYUSR,B.POLICYNO,B.APPNO,B.PDESC,C.FLD0004 ,D.DEPT FROM CAPCHKF A " ;//RD0401:新增欄位-支票劃線
		strSql += " left outer join CAPPAYF B ON A.CNO = B.PCHECKNO ";
		strSql += " left outer join ORDUET C ON B.PAY_SOURCE_CODE = C.FLD0003 AND C.FLD0002='PAYCD' ";
		strSql += " left outer join USER D ON B.ENTRY_USER = D.USRID,CAPCKNOF E  ";
	}
	//應付票據查詢統計表
	else if (document.frmMain.rdReport[1].checked)
	{
		document.frmMain.TempValue.value = "1";
		document.frmMain.ReportName.value = "DISBCDetailsReports.rpt";
		strSql = "SELECT A.*,B.POLICYNO,DESPTXT1,CREAMT";
  		strSql += ",B.PSRCCODE,B.PDESC,B.PPLANT,CASE WHEN B.SRVBH='' THEN CASE WHEN D.FLD0184='' THEN 'GPA-'||G.GPCHANNEL ELSE D.FLD0184 END ELSE B.SRVBH END as SRVBH";
  		strSql += ",(select IFNULL(SUBSTR(ACTCD2,1,6),'') from CAPCHAF where DESPTXT1=C.DESPTXT1 and CREAMT=0)||' / '||(select IFNULL(SUBSTR(ACTCD2,1,6),'') from CAPCHAF where DESPTXT1=C.DESPTXT1 and CREAMT>0) as MPACCTNO"; //R00135
  		strSql += ",CASE WHEN B.PMETHOD = 'A' THEN '支票' WHEN B.PMETHOD = 'B' THEN '匯款' WHEN B.PMETHOD = 'C' THEN '信用卡' WHEN B.PMETHOD = 'D' THEN '外幣匯款' WHEN B.PMETHOD = 'E' THEN '現金' END AS PMETHOD"; //RC0036
  		strSql += ",I.DEPT"; //RC0036
  		strSql += " FROM CAPCHKF A LEFT OUTER JOIN CAPPAYF B ON A.CNO = B.PCHECKNO,CAPCKNOF E" ;
  		strSql += " LEFT OUTER JOIN CAPCHAF C ON C.DESPTXT1 like TRIM(A.CNO)||'%-->'||A.CSTATUS||')%' and C.CREAMT=0 ";
  		strSql += " LEFT OUTER JOIN ORDUPO D ON D.FLD0001='  ' and D.FLD0002=B.POLICYNO ";
  		strSql += " LEFT OUTER JOIN CAPGASF/ORGPCM F ON F.CEPOLNO=B.POLICYNO ";
  		strSql += " LEFT OUTER JOIN ORDUAG G ON G.AGCOCO='  ' and G.AGCONU=F.CEAGNT1 ";
  		strSql += " LEFT OUTER JOIN USER I ON B.PCFMUSR1 = I.USRID ";  //RC0036
  		
	}
	//應付票據明細表
	else if(document.frmMain.rdReport[2].checked)
	{
		document.frmMain.ReportName.value = "DISBCStatusReports.rpt";
		strSql = "SELECT A.* FROM CAPCHKF A,CAPCKNOF E " ;
	}
	//R00135 新增報表 科目彙總表
	else 
	{
		document.frmMain.TempValue.value = "1";
		document.frmMain.ReportName.value = "DISBCDetailsReportsAcct.rpt";
		strSql = "SELECT A.*,B.PSRCCODE,CASE WHEN C.CREAMT=0 THEN B.PAMT ELSE B.PAMT*(-1) END as PAMT,DESPTXT1,CREAMT,";
  		strSql += "IFNULL(SUBSTR(ACTCD2,1,6),'') as MPACCTNO,";
  		strSql += "SUBSTR(C.ACTCD2,7,1) as CHANNEL,SUBSTR(C.ACTCD2,8,1) as LOB,C.ACTCD4 as DEPT ";
  		strSql += "FROM CAPCHKF A LEFT OUTER JOIN CAPPAYF B ON A.CNO = B.PCHECKNO,CAPCKNOF E ";
  		strSql += "LEFT OUTER JOIN CAPCHAF C ON C.DESPTXT1 like TRIM(A.CNO)||'%-->'||A.CSTATUS||')%' ";
	}

	strSql += "where 1=1 ";

	//銀行帳號
	if (document.getElementById("txtPBBank").value != "")
	{
		strSql += " AND A.CBKNO = '" + document.getElementById("txtPBBank").value + "' ";
	}
	if (document.getElementById("txtPBAccount").value != "")
	{
		strSql += " AND A.CACCOUNT= '" + document.getElementById("txtPBAccount").value + "' ";
	}
	//票據狀態
	if (document.getElementById("para_ChkStatus").value != "ALL")
	{
		strSql += " AND A.CSTATUS= '" + document.getElementById("para_ChkStatus").value + "' ";
	}
	//日期別
	if(document.frmMain.para_DateType[0].checked) //日期別為票據開日
	{
		if (document.getElementById("para_ChkDateS").value != "" && document.getElementById("para_ChkDateE").value != "")  
		{
			strSql += " AND  A.CUSEDT BETWEEN " + document.getElementById("para_ChkDateS").value + " and " + document.getElementById("para_ChkDateE").value;
		} else if (document.getElementById("para_ChkDateS").value != "" && document.getElementById("para_ChkDateE").value == "") {
			strSql += "  AND A.CUSEDT >= " + document.getElementById("para_ChkDateS").value ;
		} else if (document.getElementById("para_ChkDateS").value == "" && document.getElementById("para_ChkDateE").value != "") {
			strSql += " AND  A.CUSEDT <= " + document.getElementById("para_ChkDateE").value ;
		}
	}
	else if(document.frmMain.para_DateType[1].checked) //日期別為到期日
	{
		if (document.getElementById("para_ChkDateS").value != "" && document.getElementById("para_ChkDateE").value != "")  
		{
			strSql += " AND  A.CHEQUEDT BETWEEN " + document.getElementById("para_ChkDateS").value + " and " + document.getElementById("para_ChkDateE").value;
		} else if (document.getElementById("para_ChkDateS").value != "" && document.getElementById("para_ChkDateE").value == "") {
			strSql += "  AND A.CHEQUEDT>= " + document.getElementById("para_ChkDateS").value ;
		} else if (document.getElementById("para_ChkDateS").value == "" && document.getElementById("para_ChkDateE").value != "") {
			strSql += " AND  A.CHEQUEDT<= " + document.getElementById("para_ChkDateE").value ;
		}
    }
    else if(document.frmMain.para_DateType[2].checked) //狀態日
    {
       	if (document.getElementById("para_ChkDateS").value != "" && document.getElementById("para_ChkDateE").value != "")  
		{
			strSql += " AND  A.CASHDT BETWEEN " + document.getElementById("para_ChkDateS").value + " and " + document.getElementById("para_ChkDateE").value;
		} else if (document.getElementById("para_ChkDateS").value != "" && document.getElementById("para_ChkDateE").value == "") {
			strSql += "  AND A.CASHDT >= " + document.getElementById("para_ChkDateS").value ;
		} else if (document.getElementById("para_ChkDateS").value == "" && document.getElementById("para_ChkDateE").value != "") {
			strSql += " AND  A.CASHDT <= " + document.getElementById("para_ChkDateE").value ;
		}
    }
    //查詢別為票據號碼
    if(document.frmMain.para_QueryType[1].checked) 
	{
    	if (document.getElementById("para_ChkNoS").value != "" && document.getElementById("para_ChkNoE").value != "")  
		{
			strSql += " AND  A.CNO BETWEEN '" + document.getElementById("para_ChkNoS").value + "' and '" + document.getElementById("para_ChkNoE").value + "' ";
		} else if (document.getElementById("para_ChkNoS").value != "" && document.getElementById("para_ChkNoE").value == "") {
			strSql += "  AND A.CNO>= '" + document.getElementById("para_ChkNoS").value + "' ";
		} else if (document.getElementById("para_ChkNoS").value == "" && document.getElementById("para_ChkNoE").value != "") {
			strSql += " AND  A.CNO<= '" + document.getElementById("para_ChkNoE").value + "' ";
		}
	}

    strSql += " AND A.CBKNO = E.CBKNO AND A.CACCOUNT = E.CACCOUNT AND A.CBNO = E.CBNO AND E.APPROVSTA NOT IN ('N','E') ";

	//RA0102
    if(document.frmMain.rdReport[0].checked)
	{
		//來源群組
	    if(document.getElementById("selPSrcGp").value != "")
		{
	    	strSql += " AND B.PSRCGP = '" + document.getElementById("selPSrcGp").value + "' ";
		}
		//部門
	    if(document.getElementById("selDEPT").value != "")
		{
	    	strSql += " AND D.DEPT = '" + document.getElementById("selDEPT").value + "' ";
		}

		strSql += "ORDER BY D.DEPT,B.ENTRYUSR,B.POLICYNO,B.PNO ";
	}

	//PA0024
	if(document.frmMain.rdReport[1].checked || document.frmMain.rdReport[3].checked)
	{
		//strSql += "ORDER BY MPACCTNO,LOB,CHANNEL,DEPT,B.PAMT ";
		strSql += "ORDER BY DESPTXT1,CREAMT ";
	}
    document.getElementById("ReportSQL").value = strSql;
}

function showCheckFields()
{
	if(document.frmMain.para_QueryType[1].checked)
	{
		document.getElementById("checkNo").style.display ="block";
	}
	else
	{
		document.getElementById("checkNo").style.display ="none";
	}
}

function mapValue()
{
	document.getElementById("para_ChkDateS").value = rocDate2String(document.getElementById("txtCheckStartDateC").value) ;
	document.getElementById("para_ChkDateE").value = rocDate2String(document.getElementById("txtCheckEndDateC").value) ;
	var BankAccount = document.getElementById("para_BnkAcc").value ;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);	
	}  
}

//RA0102
function switchXlsForm(blockParm)
{
	if(blockParm == "reportForm1") {
		document.getElementById("reportForm1").style.display = "block";
		document.getElementById("reportForm2").style.display = "none";
		document.getElementById("reportCon1").style.display = "none";
		document.getElementById("reportCon2").style.display = "none";

		document.forms[0].rdReportForm[0].checked = true;
		document.forms[0].rdReportForm[1].checked = false;
		document.forms[0].rdReportForm[2].checked = false;
		document.forms[0].rdReportForm[3].checked = false;
		document.forms[0].rdReportForm[4].checked = false;
	}

	if(blockParm == "reportForm2") {
		document.getElementById("reportForm2").style.display = "block";
		document.getElementById("reportForm1").style.display = "none";
		document.getElementById("reportCon1").style.display = "block";
		document.getElementById("reportCon2").style.display = "block";

		document.forms[0].rdReportForm[0].checked = false;
		document.forms[0].rdReportForm[1].checked = false;
		document.forms[0].rdReportForm[2].checked = true;
		document.forms[0].rdReportForm[3].checked = false;
		document.forms[0].rdReportForm[4].checked = false;
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form method="post"	id="frmMain" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="1" width="600"  id="inquiryArea">
	<TR>
		<TD align="right" class="TableHeading" width="180">請選擇報表：</TD>
		<TD width="420">			
			<input type="radio" name="rdReport" id="rdReport" Value="A" class="Data" checked onclick="switchXlsForm('reportForm2');">票據明細
			<input type="radio" name="rdReport" id="rdReport" Value="B"  class="Data" onclick="switchXlsForm('reportForm1');">票據統計			
            <input type="radio" name="rdReport" id="rdReport" Value="C"  class="Data" onclick="switchXlsForm('reportForm1');">票據狀態統計		
            <input type="radio" name="rdReport" id="rdReport" Value="D"  class="Data"  onclick="switchXlsForm('reportForm1');">科目彙總		
		</TD>
	</TR>
	<TR id="reportForm1" style="display:none;">
		<TD align="right" class="TableHeading">請選擇報表格式：</TD>
		<TD>
			<input type="radio" name="rdReportForm" id="rdReportForm" Value="PDF" class="Data" checked >PDF
			<input type="radio" name="rdReportForm" id="rdReportForm" Value="RPT" class="Data">RPT
		</TD>
	</TR>
	<TR id="reportForm2">
		<TD align="right" class="TableHeading">請選擇報表格式：</TD>
		<TD>
			<input type="radio" name="rdReportForm" id="rdReportForm" Value="PDF" class="Data" checked >PDF
			<input type="radio" name="rdReportForm" id="rdReportForm" Value="RPT" class="Data">RPT
			<input type="radio" name="rdReportForm" id="rdReportForm" Value="EXCEL" class="Data">EXCEL
		</TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">查詢別：</TD>
		<TD>
			<input type="radio" name="para_QueryType" id="para_QueryType" Value="A" class="Data" checked onclick="showCheckFields();">依銀行帳號
			<input type="radio" name="para_QueryType" id="para_QueryType" Value="B"  class="Data" onclick="showCheckFields();">依票據號碼
		</TD>
	</TR>
</TABLE>
<TABLE border="1" width="600" id="inquiryArea">
	<TR>
		<TD align="right" class="TableHeading" width="180" rowspan="2" >日期別：</TD>
		<TD width="420">
			<input type="radio" name="para_DateType" id="para_DateType" Value="A" class="Data" checked>票據開立日
			<input type="radio" name="para_DateType" id="para_DateType" Value="B"  class="Data">到期日
			<input type="radio" name="para_DateType" id="para_DateType" Value="C"  class="Data">狀態日
		</TD>
	</TR>
	<TR>
		<TD>
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtCheckStartDateC" name="txtCheckStartDateC" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtCheckStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
			<INPUT type="hidden" name="para_ChkDateS" id="para_ChkDateS" value=""> ~ 
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtCheckEndDateC" name="txtCheckEndDateC" value="" readOnly> 
			<a href="javascript:show_calendar('frmMain.txtCheckEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
			<INPUT type="hidden" name="para_ChkDateE" id="para_ChkDateE" value="">
		</TD>
	</TR>
</TABLE>
<TABLE border="1" width="600" id="inquiryArea">
	<TR>
		<TD align="right" class="TableHeading" width="180">銀行帳號：</TD>
		<TD width="420">
			<INPUT type="hidden" name="txtPBBank" id="txtPBBank" value="">
			<INPUT type="hidden" name="txtPBAccount" id="txtPBAccount" value="">
			<select size="1" name="para_BnkAcc" id="para_BnkAcc">
				<%=sbPBBank.toString()%>
			</select>
		</TD>
	</TR>
	<TR id="checkNo" style="display:none;">
		<TD align="right" class="TableHeading">票據號碼起迄：</TD>
		<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="para_ChkNoS" name="para_ChkNoS" value="">~ <INPUT class="Data" size="11" type="text" maxlength="11" id="para_ChkNoE" name="para_ChkNoE" value=""></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">票據狀態：</TD>
		<TD>
			<select size="1" name="para_ChkStatus" id="para_ChkStatus">
				<option value="ALL">全部</option>
				<option value="">庫存（未開立）</option>
				<option value="D">D:已開</option>
				<option value="C">C:兌現(回銷)</option>
				<option value="V">V:作廢</option>
				<option value="R">R:退回</option>	
				<option value="1">1:逾一年</option>
				<option value="2">2:逾二年</option>
				<option value="3">3:列印失敗作廢</option>	
				<option value="4">4:重開作廢</option>
				<option value="5">5:掛失中</option>
				<option value="6">6:除權判決</option>
			</select>
		</TD>
	</TR>
	<TR id="reportCon1">
		<TD align="right" class="TableHeading">來源群組：</TD>
		<TD>
			<select size="1" name="selPSrcGp" id="selPSrcGp">
				<%=sbPSrcGrp.toString()%>
			</select>
		</TD>
	</TR>
	<TR id="reportCon2">
		<TD align="right" class="TableHeading">部門：</TD>
		<TD>
			<select size="1" name="selDEPT" id="selDEPT">
				<option value="">全部</option>
				<option value="FIN">FIN</option>
				<option value="ACCT">ACCT</option>	
				<option value="CSC">CSC</option>
				<option value="NB">NB</option>
				<option value="PA">PA</option>
				<option value="GP">GP</option>
				<option value="GPH">GPH</option>
				<option value="CLM">CLM</option>						
				<option value="CLH">CLH</option>						
			</select>
		</TD>
	</TR>

</TABLE>
<!--R00135 add by zhejun.he-->  
<INPUT id="TempValue" type="hidden" name="TempValue" value="0"> 

<INPUT type="hidden" id="ReportName" name="ReportName" value="">
<INPUT type="hidden" id="OutputType" name="OutputType" value="">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="txtAction"	name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">	
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">

</FORM>
</BODY>
</HTML>