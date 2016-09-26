<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : 每日付款明細報表
 * 
 * Remark   : 每日支付明細表－財務                ：DISBDailyPDetailsByFin.rpt
 *            每日支付明細表－財務 (警示)：DISBDailyPDetailsByFinA.rpt
 *            每日付款總表                                    ：DISBDailyToFin.rpt (BATCH作業)
 *                                       DISBDailyToFin_ONLINE.rpt (線上作業)
 *            每日付款總表(失效)        ：DISBDailyToFinForCE.rpt
 *            每日對帳表(留存用)        ：DISBDaily.rpt
 *            每日對帳表 (留存用)失效          ：DISBDailyForCE.rpt
 *            每日付款明細表                                ：DISBDailyPDetails.rpt
 * 
 * Revision : $Revision: 1.34 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $Date: 2014/10/31 02:46:32 $
 * 
 * Request ID : R10231
 * 
 * CVS History:
 * 
 * $Log: DISBDailyPReports.jsp,v $
 * Revision 1.34  2014/10/31 02:46:32  misariel
 * RC0036-新增分公司行政人員使用CAPSIL變更的權限控管
 *
 * Revision 1.32  2014/03/31 03:18:26  misariel
 * R80734-新增支付代碼BI
 *
 * Revision 1.31  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.30  2013/06/13 09:58:24  MISSALLY
 * EB0097-配合CMP修改每日付款總表撈取條件增加限制『User確認日』<=畫面的『輸入日期』
 *
 * Revision 1.29  2013/01/09 03:25:00  MISSALLY
 * Calendar problem
 *
 * Revision 1.28  2013/01/08 04:25:56  MISSALLY
 * 將分支的程式Merge至HEAD
 *
 * Revision 1.26.4.3  2012/12/06 06:28:24  MISSALLY
 * RA0102　PA0041
 * 配合法令修改酬佣支付作業
 *
 * Revision 1.26.4.2  2012/10/31 06:07:24  MISSALLY
 * EA0152 --- VFL PHASE 4
 *
 * Revision 1.26.4.1  2012/09/06 09:21:12  MISSALLY
 * QA0295---修正警示報表轉換數值型態的Function
 *
 * Revision 1.26  2012/05/24 06:53:26  MISSALLY
 * R10314 CASH系統會計作業修改-移除手續費支付方式檢核判斷
 *
 * Revision 1.25  2012/05/24 03:03:22  MISSALLY
 * R10314 CASH系統會計作業修改-移除同意書判斷
 *
 * Revision 1.24  2012/05/23 01:21:44  MISSALLY
 * R10314 CASH系統會計作業修改-修正理賠付款金額的判斷
 *
 * Revision 1.23  2012/05/22 02:45:01  MISSALLY
 * R10314 CASH系統會計作業修改-修正理賠付款金額的判斷
 *
 * Revision 1.22  2012/05/21 04:34:32  MISSALLY
 * R10314 CASH系統會計作業修改-修正理賠付款金額的判斷
 *
 * Revision 1.21  2012/05/18 09:49:52  MISSALLY
 * R10314 CASH系統會計作業修改
 *
 * Revision 1.20  2011/10/21 10:04:35  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 *
 *
 */
%><%!String strThisProgId = "DISBDailyPReports"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")):"";
String strUserBrch = (session.getAttribute("LogonUserBrch") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserBrch")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserId")):"";

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar  =commonUtil.getBizDateByRCalendar();
int iCurrentDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(calendar.getTime()));

//Q80432 XFILE檢查		
Vector XPol = (Vector)request.getAttribute("XPol");

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alCurrCash = new ArrayList(); //R80132 幣別挑選
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
<HTML>
<HEAD>
<TITLE>每日付款明細報表</TITLE>
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
// *************************************************************
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
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title, '', '', '' );
	// R80244  if(document.getElementById("txtUserDept").value != "FIN" && document.getElementById("txtUserRight").value >= "99")
	if(document.getElementById("txtUserDept").value != "FIN" && document.getElementById("txtUserDept").value != "ACCT" && document.getElementById("txtUserRight").value >= "99")
	{
		alert("無執行此報表權限");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else
	{
		document.getElementById("FormArea").style.display ="block";
		document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";//Q80432

		if(document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT" )//R80244
		{
			document.getElementById("FinArea").style.display ="block";
			document.getElementById("inquiryArea").style.display ="none";
			document.getElementById("BatchArea").style.display ="none";
		}
		else
		{
			if(document.getElementById("txtUserRight").value > "79" && document.getElementById("txtUserRight").value <= "89")
			{	//Q80432檢查是否XFILE
				if(document.getElementById("txtAction").value != "returnXPOL" && document.getElementById("txtUserDept").value == "CSC")
				{
					document.frmMain.action = "<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBDailyPRServlet?action=query";
					document.frmMain.submit();
				}
				else
				{
					document.getElementById("inquiryArea").style.display ="block";
					document.getElementById("FinArea").style.display ="none";
					document.frmMain.rdReportType[0].checked = true;
					document.getElementById("BatchArea").style.display ="block";
				}
			}
			else
			{
				document.getElementById("inquiryArea").style.display ="none";
				document.getElementById("FinArea").style.display ="none";
				document.frmMain.rdReportType[1].checked = true;
				document.getElementById("BatchArea").style.display ="none";
			}
		}
	}
	window.status = "";
}

/*
函數名稱:	printRAction()
函數功能:	當toolbar frame 中之報表按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function printRAction()
{
	window.status = "";

	document.getElementById("txtAction").value = "L";

	WindowOnLoadCommon( document.title , '' , 'E','' );

	document.getElementById("FormArea").style.display ="none";
	document.getElementById("inquiryArea").style.display ="none";
	document.getElementById("FinArea").style.display ="none";
	document.getElementById("BatchArea").style.display ="none";
	document.getElementById("btnPrint").style.display ="none";

	//FIN
	if(document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")  // R80244
	{	//每日付款明細表(財務) / 警示
		getReportInfoByFin();
		if (document.frmMain.rdReportForm[0].checked)
		{
			document.frmMain2.OutputType.value = "PDF";
			document.frmMain2.OutputFileName.value = "DISBDailyPDetailsByFin.pdf";
			document.frmMain3.OutputType.value = "PDF";
			document.frmMain3.OutputFileName.value = "DISBDailyPDetailsByFinA.pdf";
		}
		else
		{
			document.frmMain2.OutputType.value = "TXT";
			document.frmMain2.OutputFileName.value = "DISBDailyPDetailsByFin.rpt";
			document.frmMain3.OutputType.value = "TXT";
			document.frmMain3.OutputFileName.value = "DISBDailyPDetailsByFinA.rpt";
		}
		document.getElementById("frmMain2").target="_blank";
		document.getElementById("frmMain2").submit();
		document.getElementById("frmMain3").target="_blank";
		document.getElementById("frmMain3").submit();
	}
	else if(document.getElementById("txtUserRight").value >= "89" && document.getElementById("txtUserRight").value < "99")
	{
		if(document.frmMain.rdReportType[0].checked)
		{
			getReportInfo89();
			if(document.frmMain.rdReportType[0].checked)
			{	//每日付款總表及每日付款明細表(留存) / 失效
				//window.open('<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyPConfirm.jsp?sql='+ document.frmMain.ReportSQL.value,'每日付款總表','top=0,left=0,scrollbars=1,resizable=yes,width=650,height=350');
				//RC0036
				document.getElementById("frmMain").action = '<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyPConfirm.jsp' ;
				document.getElementById("frmMain").target="_blank";
				document.getElementById("frmMain1").target="_blank";
				document.getElementById("frmMain4").target="_blank";
				document.getElementById("frmMain5").target="_blank";
				if (checkXFILE()) 
				{  //Q80432
					document.getElementById("frmMain").submit();
					if(document.frmMain.rdFromBatch[0].checked)
					{
						document.getElementById("frmMain1").submit();
						document.getElementById("frmMain4").submit();
						document.getElementById("frmMain5").submit();
					}
				}
			} else {//每日付款總表
				document.getElementById("frmMain").target="_blank";
				document.getElementById("frmMain").submit();
			}
		}
		else if(document.frmMain.rdReportType[1].checked)
		{	//每日付款明細表
			getReportInfo89forDetails();
			document.getElementById("frmMain").target="_blank";
			document.getElementById("frmMain").submit();
		}
		else
		{	//RB0302理琣急件明細表 for POS
			getReportInfoByClamforPOS();
			document.getElementById("frmMain").target="_blank";
			document.getElementById("frmMain").submit();
		}
	}
	else
	{	//每日付款明細表
		getReportInfo79();
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
	}
}

/*
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyPReports.jsp";
}

function getReportInfo89()
{
	var strBatchSql = "";
	var strBatchCEsql = "";//R90624
	var strForm = "";

	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain1.OutputType.value = "PDF";
		document.frmMain4.OutputType.value = "PDF";
		document.frmMain5.OutputType.value = "PDF";
		strForm = ".pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain1.OutputType.value = "TXT";
		strForm = ".rpt";
	}

	if(document.frmMain.rdDISPATCH[0].checked) {
		document.frmMain.para_DISPATCH.value ="Y";
	} else {
		document.frmMain.para_DISPATCH.value ="";
	}

	if(document.frmMain.rdReportType[0].checked)
	{
		if(document.frmMain.rdFromBatch[0].checked)
		{
			document.frmMain.ReportName.value = "DISBDailyToFin.rpt";
			document.frmMain.OutputFileName.value = "DISBDailyToFin" + strForm;
			document.frmMain1.ReportName.value = "DISBDaily.rpt";
			document.frmMain1.OutputFileName.value = "DISBDaily" + strForm;

			document.frmMain4.ReportName.value = "DISBDailyToFinForCE.rpt";
			document.frmMain4.OutputFileName.value = "DISBDailyToFinForCE" + strForm;
			document.frmMain5.ReportName.value = "DISBDailyForCE.rpt";
			document.frmMain5.OutputFileName.value = "DISBDailyForCE" + strForm;

			document.frmMain.para_FromBatch.value='Y';
			document.frmMain1.para_FromBatch.value='Y';      
			document.frmMain4.para_FromBatch.value='Y';//@R90624
			document.frmMain5.para_FromBatch.value='Y';//@R90624
			//strBatchSql = " AND A.PAY_SOURCE_CODE in ('B1','B2','B3','B4','B5','B6','B7','B8','B9','BA')"//R70088配息 @R70455加入'B9'  @Q00014部份解約
			//strBatchSql = " AND A.PAY_SOURCE_CODE in ('B1','B2','B3','B4','B5','B6','B7','B8','B9','BB','BA')";//R00440滿期金作業
            strBatchSql = " AND A.PAY_SOURCE_CODE in (<%=Constant.Batch_PAY_SRCCODE%>) ";
			strBatchCEsql = " AND A.PAY_SOURCE_CODE = 'CE' ";//@R90624失效 CE
		}
		else
		{
			document.frmMain.ReportName.value = "DISBDailyToFin_ONLINE.rpt";
			document.frmMain.OutputFileName.value = "DISBDailyToFin_ONLINE" + strForm;
			document.frmMain.para_FromBatch.value='N';
			document.frmMain1.para_FromBatch.value='N';
			//strBatchSql = " AND A.PAY_SOURCE_CODE NOT in ('B1','B2','B3','B4','B5','B6','B7','B8','B9','CE','BA')"//R70088配息 @R70088配息 R70455加入'B9' @R90624 加入 失效 @Q00014部份解約\
			//strBatchSql = " AND A.PAY_SOURCE_CODE NOT in ('B1','B2','B3','B4','B5','B6','B7','B8','B9','BB','BA','CE')";//R00440 滿期金作業
         	strBatchSql = " AND A.PAY_SOURCE_CODE NOT in (<%=Constant.Batch_PAY_SRCCODE%>,'CE') ";
		}
	}

	mapValue();

	//總表
	var strSql = "";
	strSql = "SELECT A.*,B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM,B.USRBRCH AS USRBRCH,B.USRAREA AS USRAREA,E.FLD0004,F.FLD0004 ";
	strSql += " from CAPPAYF A ";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C on C.BKNO=A.PRBANK ";
	//RC0036
	strSql += "left outer join ORDUET E on E.FLD0002 = 'DEPT' AND E.FLD0003 = B.DEPT ";
	strSql += "left outer join ORDUET F on F.FLD0002 = 'DEPT' AND F.FLD0003 = B.USRAREA ";
	if (document.getElementById("txtUserDept").value == "CSC")
		strSql += " WHERE B.DEPT IN ('CSC','PCD','TYB','TCB','TNB','KHB') ";
	else
		strSql += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
		
	if (document.getElementById("txtUserBrch").value != "")
		strSql += " AND B.USRBRCH='"+ document.getElementById("txtUserBrch").value +"'  ";
		
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>''  ";
    strSql += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2='' and PAY_AMOUNT > 0 "; 
    strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";

	//EB0097 自動確認會帶未來日
	if(document.frmMain.rdFromBatch[1].checked && (document.getElementById("txtUserDept").value == "CSC"
											       || document.getElementById("txtUserDept").value =='PCD'
												   || document.getElementById("txtUserDept").value =='TYB'
												   || document.getElementById("txtUserDept").value =='TCB'
												   || document.getElementById("txtUserDept").value =='TNB'
												   || document.getElementById("txtUserDept").value =='KHB')) {
		strSql += " AND A.PAY_CONFIRM_DATE1 <= " + document.getElementById("txtEntryDate").value;
	}

	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value !="") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"' ";
	}
	//R61220
	if(document.frmMain.rdReportType[0].checked && document.frmMain.rdFromBatch[0].checked)
	{
		if(document.frmMain.rdMethod[1].checked) {
			strSql += " AND A.PMETHOD = 'A' ";
		}
		if (document.frmMain.rdMethod[2].checked) {
			strSql += " AND A.PMETHOD <> 'A' ";
		}
	}
	//R90624
	document.frmMain.ReportSQL.value = strSql+strBatchSql+" ORDER BY A.ENTRY_USER,A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";//R70088修改排序新增METHOD,PAYCURR;
	document.frmMain4.ReportSQL.value = strSql+strBatchCEsql+" ORDER BY A.ENTRY_USER,A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";//R90624

	//對帳表
	var strSql1= "";
	strSql1= "SELECT A.*,B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,C.BKNM ";
	strSql1 += " from CAPPAYF A ";
	strSql1 += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql1 += "  left outer join CAPCCBF C on C.BKNO=A.PRBANK   ";
	strSql1 += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
	//R10260 由於匯款資料不全的資料會寫入支付檔，故須提供給User後續的follow up
	//R10260 strSql1 += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_TIME1 <>0 AND A.PAY_CONFIRM_USER1<>''  ";
	strSql1 += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2=''"; //R70088 and A.PAY_METHOD <> 'A' "; 
	strSql1 += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";

	if(document.getElementById("txtEntryDate").value !="") {
		strSql1 += " AND A.ENTRY_DATE = " + document.getElementById("txtEntryDate").value;
	}
	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql1 += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql1 += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value !="") {
		strSql1+= " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"'";
	}

//R80734	document.frmMain1.ReportSQL.value = strSql1+ strBatchSql+" AND ((A.PAY_METHOD IN ('B','C','D')) OR (A.PAY_METHOD = 'A' AND A.PAY_SOURCE_CODE IN ('B8','B9','BB'))) ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO";//R00440-SN滿期金作業
/*R80734*/
	document.frmMain1.ReportSQL.value = strSql1+ strBatchSql+" AND ((A.PAY_METHOD IN ('B','C','D')) OR (A.PAY_METHOD = 'A' AND A.PAY_SOURCE_CODE IN ('B8','B9','BB','BI'))) ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO";//R00440-SN滿期金作業
   	document.frmMain5.ReportSQL.value = strSql1+" AND A.PAY_METHOD IN  ('B','C','D')  AND A.PAY_SOURCE_CODE = 'CE' ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO";//R90624
}

function getReportInfo89forDetails()
{
	if(document.frmMain.rdDISPATCH[0].checked) {//R70088 BUGFIX
		document.frmMain.para_DISPATCH.value = "Y";
	} else {
		document.frmMain.para_DISPATCH.value ="";
	}

	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DISBDailyPDetails.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain.OutputFileName.value = "DISBDailyPDetails.rpt";
	}

	//明細表
	var strSql = "";
	strSql = "SELECT A.* ";
	strSql += ",B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM,B.USRAREA AS USRAREA ";
	strSql += " from CAPPAYF A";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C  on C.BKNO=A.PRBANK   ";
	//strSql += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
	if (document.getElementById("txtUserDept").value == "CSC")
		strSql += " WHERE B.DEPT IN ('CSC','PCD','TYB','TCB','TNB','KHB') ";
	else
		strSql += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";	
	if (document.getElementById("txtUserBrch").value != "")
		strSql += " AND B.USRBRCH='"+ document.getElementById("txtUserBrch").value +"'  ";
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>''";
	strSql += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2=''  ";
	strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";

	if(document.getElementById("txtEntryDate").value !="") {
		strSql += " AND A.ENTRY_DATE = " + document.getElementById("txtEntryDate").value;
		//EB0097 自動確認會帶未來日
		if(document.getElementById("txtUserDept").value == "CSC") {
			strSql += " AND A.PAY_CONFIRM_DATE1 <= " + document.getElementById("txtEntryDate").value;
		}
	}
	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value !="") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"'";
	}

	strSql += " ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";

	document.getElementById("ReportSQL").value = strSql;
}

function getReportInfoByClamforPOS()
{
	document.frmMain.para_DISPATCH.value = "Y";
	document.frmMain.ReportName.value = "DISBDailyPDetailsByClm4POS.rpt";

	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DISBDailyPDetailsByClm4POS.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain.OutputFileName.value = "DISBDailyPDetailsByClm4POS.rpt";
	}

	//明細表
	var strSql = "";
	strSql = "SELECT A.* ";
	strSql += ",B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM ";
	strSql += " from CAPPAYF A";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C  on C.BKNO=A.PRBANK   ";
	strSql += " WHERE B.DEPT='CLM'  ";
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>''";
	strSql += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2=''  ";
	strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";
	strSql += " AND PAY_DISPATCH='Y' ";

	if(document.getElementById("txtEntryDate").value !="") {
		strSql += " AND A.ENTRY_DATE = " + document.getElementById("txtEntryDate").value;
	}
	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value !="") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"'";
	}

	strSql += " ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";

	document.getElementById("ReportSQL").value = strSql;
}

function getReportInfo79()
{
	if(document.frmMain.rdDISPATCH[0].checked) {
		document.frmMain.para_DISPATCH.value = "Y";
	} else {
		document.frmMain.para_DISPATCH.value = "";
	}

	if(document.frmMain.rdReportForm[0].checked) 
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DISBDailyPDetails.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain.OutputFileName.value = "DISBDailyPDetails.rpt";
	}

	//只能查自己所輸入的資料
	var strSql = "";
	strSql = "SELECT A.* ";		
	strSql += ",B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM,B.USRAREA AS USRAREA ";		
	strSql += " from CAPPAYF A";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C  on C.BKNO=A.PRBANK   ";
	strSql += " WHERE  A.ENTRY_USER= '" + document.getElementById("txtUserId").value  + "'";
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>''";
	strSql += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2=''  "; 
	strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";

	if(document.getElementById("txtEntryDate").value !="") {
		strSql += " AND A.ENTRY_DATE = " + document.getElementById("txtEntryDate").value;
		//EB0097 自動確認會帶未來日
		if(document.getElementById("txtUserDept").value == "CSC") {
			strSql += " AND A.PAY_CONFIRM_DATE1 <= " + document.getElementById("txtEntryDate").value;
		}
	}

	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}

	if(document.getElementById("para_Currency").value !="") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"'";
	}

	strSql += " ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";

	document.getElementById("ReportSQL").value = strSql;
}

function getReportInfoByFin()
{
	mapValue();

	var strSql = "";
	// FIN 可查所有支付資料
	strSql = "SELECT A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,A.PAY_DISPATCH,A.PAY_CHECK_M1,A.PAY_CHECK_M2,A.POLICY_NO,A.APPNO,";
	//R10314
//	strSql += "CASE WHEN A.ENTRY_USER LIKE 'BATCH%' THEN A.ENTRY_USER ELSE '輸入者' END AS isBatch,A.ENTRY_USER,A.PAY_SOURCE_CODE, d.CLMNO, d.ClmCase, SUM(d.CLMKAMT) AS CLMKAMT,";
	strSql += "CASE WHEN A.ENTRY_USER LIKE 'BATCH%' THEN A.ENTRY_USER ELSE '輸入者' END AS isBatch,A.ENTRY_USER,A.PAY_SOURCE_CODE,IFNULL(d.CLMNO,'') as CLMNO,IFNULL(d.SUM1_AMT,0) as SUM1_AMT,IFNULL(d.SUM2_AMT,0) as SUM2_AMT,";
	strSql += "DEC(substr(et.FLD0004,1,10)) as caseAmt1, DEC(substr(et.FLD0004,11,10)) as caseAmt2,";

	strSql += "A.PAY_CONFIRM_DATE2,A.PDESC,A.PAY_SRC_NAME,C.BKNM,A.PAY_CURRENCY";
	strSql += ",'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT";
	strSql += ",A.PAY_PLAN_TYPE";
	strSql += ",CASE WHEN F.FLD0004 IS NULL THEN SUBSTR(E.FLD0004,1,3) "; 
	strSql += " WHEN SUBSTR(E.FLD0004,1,3) = 'BEN' OR SUBSTR(E.FLD0004,1,3) = 'SHA' THEN 'OUR' END AS SYS_FEEWAY ";
	strSql += ",A.PAY_PAYCURR,A.PAY_PAYAMT,A.PAY_PAYRATE,A.PAY_FEEWAY,A.PAY_SYMBOL,A.PAY_INV_DATE,A.PENGNAME  ";//R60550
	strSql += ",A.PMETHODO,A.PSRCGP  ";//R80631
	strSql += ",A.ENTRY_DATE,A.PAY_AMOUNT_NT,A.PAY_CASH_DATE,B.USRAREA AS USRAREA  ";//R80132   	    
	strSql += " from CAPPAYF A ";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C  on C.BKNO=A.PRBANK   ";
	strSql += "  LEFT JOIN ORDUET E ON E.FLD0002 = 'PAYCD' AND E.FLD0003 = A.PSRCCODE ";
	strSql += "  LEFT JOIN ORDUET F ON E.FLD0002 = 'BANFR' AND F.FLD0003 = SUBSTR(A.PAY_CURRENCY,1,2) || SUBSTR(A.PAY_BUDGET_BANK,1,3) ";
	//R10314
	strSql += " LEFT JOIN ORDUET et ON et.FLD0001='  ' and et.FLD0002='CLAMQ' and et.FLD0003=A.PCURR ";
	strSql += " LEFT JOIN (SELECT G.clmno, SUM (CASE WHEN G.ClmCase = '1' THEN G.CLMKAMT  ELSE 0 END) AS SUM1_AMT, SUM (CASE WHEN G.ClmCase = '2' THEN G.CLMKAMT  ELSE 0 END) AS SUM2_AMT ";
	strSql += " FROM ( select  clmno,CRIDER,CASE WHEN substr(CLMCODE,6,2) IN ('-7','-8','-9') or substr(ETABCLMNO,1,3) IN ('AC0','AC1','AC2','AC3','AC4','CC1','CC2','CC3','CC4','CL1','CL2','CL3','CL4','C10','C11','C12','HCB','HCR','NCB','NCR','NC1','NC2','NC3','NC4','SC1','SC2','SC3','SC4') THEN '1' ELSE '2' END as ClmCase,SUM(CLMKAMT) as CLMKAMT ";
	strSql += " from clamcd where substr(CLMCODE,6,1)<>'*' and CRIDER<>'' group by clmno,CRIDER,CLMCODE,ETABCLMNO ) G group by G.clmno ";
	strSql += "  ) d ON a.policyno=A.POLICYNO and d.CLMNO=A.PCLMNUM AND A.PSRCCODE='D1' ";

	//strSql += " WHERE  A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 "; RA0102
	strSql += " WHERE A.PAY_AMOUNT <> 0 ";	//RA0102
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>'' ";
	strSql += " AND A.PAY_CONFIRM_DATE2 =" + document.getElementById("para_PConDate").value + " ";

	if(document.frmMain.rdDISPATCH[0].checked) {
		//strSql += " AND PAY_DISPATCH='Y' AND A.PAY_CASH_DATE =0 ";R10314
		strSql += " AND PAY_DISPATCH='Y'  ";//R10314
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value != "") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"' ";
	}

	strSql += "GROUP BY A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,";
	strSql += "A.PAY_DISPATCH,A.PAY_CHECK_M1,A.PAY_CHECK_M2,A.POLICY_NO,A.APPNO,"; 
	strSql += "A.ENTRY_USER,A.ENTRY_USER,A.PAY_SOURCE_CODE,d.CLMNO,d.SUM1_AMT,d.SUM2_AMT,";      
	strSql += "et.FLD0004,A.PAY_CONFIRM_DATE2,A.PDESC,A.PAY_SRC_NAME,C.BKNM,";      
	strSql += "A.PAY_CURRENCY,B.DEPT,A.PAY_PLAN_TYPE,F.FLD0004,E.FLD0004,";          
	strSql += "A.PAY_PAYCURR,A.PAY_PAYAMT,A.PAY_PAYRATE,A.PAY_FEEWAY,";              
	strSql += "A.PAY_SYMBOL,A.PAY_INV_DATE,A.PENGNAME,A.PMETHODO,A.PSRCGP,";         
	strSql += "A.ENTRY_DATE,A.PAY_AMOUNT_NT,A.PAY_CASH_DATE,USRAREA ";                                       
	strSql += " ORDER BY A.ENTRY_USER,A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";//R70600

	document.frmMain2.ReportSQL.value = strSql;
	document.frmMain2.para_PConDate.value = document.getElementById("para_PConDate").value;
	document.frmMain2.para_Currency.value = document.getElementById("para_Currency").value;

	document.frmMain3.ReportSQL.value = strSql;  //R70600
	document.frmMain3.para_PConDate.value = document.getElementById("para_PConDate").value ;  //R70600
	document.frmMain3.para_Currency.value = document.getElementById("para_Currency").value ;  //R70600
}

function mapValue()
{
	if(document.getElementById("txtPConfirmDateC").value !="") {
		document.getElementById("para_PConDate").value = rocDate2String(document.getElementById("txtPConfirmDateC").value);
	}
	if(document.getElementById("txtEntryDateC").value !="") {
		document.getElementById("txtEntryDate").value = rocDate2String(document.getElementById("txtEntryDateC").value) ;
		document.getElementById("para_EntryDate").value = rocDate2String(document.getElementById("txtEntryDateC").value) ;		
	}
	if(document.getElementById("txtPDateC").value !="") {
		document.getElementById("para_PDate").value = rocDate2String(document.getElementById("txtPDateC").value) ;		
	}
}

function enableBatchArea()
{
   document.getElementById("BatchArea").style.display ="block";
}
function disableBatchArea()
{
   document.getElementById("BatchArea").style.display ="none";
   <% if(strUserDept.equals("CSC") && strUserRight.equals("89")) { %>
	if(document.frmMain.rdReportType[2].checked) {
		document.frmMain.rdDISPATCH[0].checked = true;
	}
   <% } %>
}
function enablePDateArea()
{
   document.getElementById("PDateArea").style.display ="block";
   document.getElementById("PDateMethod").style.display ="block";//R61220
}
function disablePDateArea()
{
   document.getElementById("PDateArea").style.display ="none";
   document.getElementById("PDateMethod").style.display ="none";//R61220
}

//Q80432 檢查是否有X-FILE
function checkXFILE()
{	
	var rtnVal = true;
	var strTmpMsg = "";
	<%
 	if (XPol != null) {
		if (XPol.size() > 0) {
	%>
		strTmpMsg += "請先修正以下X-FILE保單的受款人及ID: \r\n";
        <% for (int i = 0; i < XPol.size(); i++) {%>
				strTmpMsg += "<%=(String)XPol.get(i)%> \r\n";
		<% } %>	
		rtnVal = false;
	<%  }
	} %>

	if( !rtnVal )
	{
		alert( strTmpMsg );
	}
	return rtnVal;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="" id="frmMain" method="post" name="frmMain">
	<input type="button" value="報  表" name="btnPrint" id="btnPrint" onclick="printRAction();" class="eServiceButton" style="margin: 0px; padding: 0px; height: 27; width: 40;">
	<TABLE border="1" width="680" id=FormArea style="display: none;">
		<TR>
			<TD align="right" class="TableHeading" width="180">請選擇報表格式：</TD>
			<TD width="500">
				<input type="radio" name="rdReportForm" id="rdReportForm" value="PDF" class="Data" checked>PDF 
				<input type="radio" name="rdReportForm" id="rdReportForm" value="RPT" class="Data">RPT
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="180">急件：</TD>
			<TD width="500">
				<input type="radio" name="rdDISPATCH" id="rdDISPATCH" value="Y" class="Data">是 
				<input type="radio" name="rdDISPATCH" id="rdDISPATCH" value="N" class="Data" checked>否
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="180">幣別：</TD>
			<TD width="333" valign="middle">
				<select size="1" name="para_Currency" id="para_Currency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="680" id=inquiryArea style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="180">請選擇欲執行報表：</TD>
			<TD width="500">
				<input type="radio" name="rdReportType" id="rdReportType" value="B" class="Data" onclick="enableBatchArea();">每日付款總表
				<input type="radio" name="rdReportType" id="rdReportType" value="A" class="Data" checked onclick="disableBatchArea();">每日付款明細表
<% if(strUserDept.equals("CSC") && strUserRight.equals("89")) { %>
				<input type="radio" name="rdReportType" id="rdReportType" value="C" class="Data" onclick="disableBatchArea();">理賠急件明細表
<% } %>
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="680" id=BatchArea>
		<TR>
			<TD align="right" class="TableHeading" width="180">來源：</TD>
			<TD width="500">
				<input type="radio" name="rdFromBatch" id="rdFromBatch" value="Y" class="Data" checked onclick="enablePDateArea();">Batch作業 
				<input type="radio" name="rdFromBatch" id="rdFromBatch" value="N" class="Data" onclick="disablePDateArea();">線上作業
			</TD>
		</TR>
		<TR id=PDateArea>
			<TD align="right" class="TableHeading" width="180">付款日期：</TD>
			<TD width="500">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateC" name="txtPDateC" value="" readOnly>
				<a href="javascript:show_calendar('frmMain.txtPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="180">輸入日期：</TD>
			<TD width="500">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryDateC" name="txtEntryDateC" value="" readOnly> 
				<a href="javascript:show_calendar('frmMain.txtEntryDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT type="hidden" name="txtEntryDate" id="txtEntryDate" value="">
			</TD>
		</TR>
		<!--R61220 拆分支票.匯款-->
		<TR id=PDateMethod>
			<TD align="right" class="TableHeading" width="180">產生報表支付方式：</TD>
			<TD width="500">
				<input type="radio" name="rdMethod" id="rdMethod" value="N" class="Data" checked>不拘
				<input type="radio" name="rdMethod" id="rdMethod" value="A" class="Data">支票件
				<input type="radio" name="rdMethod" id="rdMethod" value="B" class="Data">非支票件
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="680" id=FinArea style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="180">支付確認日：</TD>
			<TD width="500">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPConfirmDateC" name="txtPConfirmDateC" value="" readOnly> 
				<a href="javascript:show_calendar('frmMain.txtPConfirmDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
				<INPUT type="hidden" name="para_PConDate" id="para_PConDate" value="<%=iCurrentDate%>">
			</TD>
		</TR>
	</TABLE>

	<!-- 每日付款總表 -->
	<!-- 每日付款明細表 -->
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyPDetails.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL"	name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
	<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>"> 
	<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 
	<INPUT type="hidden" id="txtUserBrch" name="txtUserBrch" value="<%=strUserBrch%>">
	<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>"> 
	<INPUT type="hidden" id="para_EntryDate" name="para_EntryDate" value="<%=iCurrentDate%>"> 
	<INPUT type="hidden" id="para_PDate" name="para_PDate" value="<%=iCurrentDate%>"> 
	<INPUT type="hidden" id="para_FromBatch" name="para_FromBatch" value="">
	<INPUT type="hidden" id="para_DISPATCH" name="para_DISPATCH" value="">
	<INPUT type="hidden" id="para_NextDT" name="para_NextDT" value="<%=iCurrentDate%>">
	<INPUT type="hidden" id="switch_Call" name="switch_CallYorN" value="Y">
	<INPUT type="hidden" id="switch_PGM" name="switch_PGM" value="<%=strThisProgId%>">
</FORM>
<!-- 每日對帳表 (留存用) -->
<FORM id="frmMain1" name="frmMain1" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDaily.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT id="ReportPath" type="hidden" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" name="para_FromBatch" id="para_FromBatch" value="">
</FORM>
<!-- 每日支付明細表－財務 -->
<FORM id="frmMain2" name="frmMain2" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyPDetailsByFin.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL"> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
	<INPUT type="hidden" id="para_PConDate" name="para_PConDate">
	<INPUT type="hidden" id="para_Currency" name="para_Currency">
</FORM>
<!-- R70600 每日付款明細表-財務-警示 -->
<FORM id="frmMain3" name="frmMain3" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyPDetailsByFinA.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL"> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" id="para_PConDate" name="para_PConDate">
	<INPUT type="hidden" id="para_Currency" name="para_Currency">
</FORM>
<!-- R90624 每日付款總表 (失效) -->
<FORM id="frmMain4" name="frmMain4" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyToFinForCE.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
	<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>"> 
	<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 
	<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>"> 
	<INPUT type="hidden" id="para_EntryDate" name="para_EntryDate" value="<%=iCurrentDate%>"> 
	<INPUT type="hidden" id="para_PDate" name="para_PDate" value="<%=iCurrentDate%>"> 
	<INPUT type="hidden" id="para_FromBatch" name="para_FromBatch" value="">
	<INPUT type="hidden" id="para_DISPATCH" name="para_DISPATCH" value="">
	<INPUT type="hidden" id="para_NextDT" name="para_NextDT" value="<%=iCurrentDate%>">
	<INPUT type="hidden" id="switch_Call" name="switch_CallYorN" value="Y">
	<INPUT type="hidden" id="switch_PGM" name="switch_PGM" value="<%=strThisProgId%>">
</FORM>
<!-- R90624 每日對帳表(留存用)失效 -->
<FORM id="frmMain5" name="frmMain5" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyForCE.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" id="para_FromBatch" name="para_FromBatch" value="">
</FORM>

</BODY>
</HTML>

