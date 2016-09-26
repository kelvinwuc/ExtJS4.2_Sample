<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : 支付明細
 * 
 * Remark   : 支付查詢
 * 
 * Revision : $Revision: 1.27 $
 * 
 * Author   : ANGEL CHEN
 * 
 * Create Date : $Date: 2014/11/27 06:00:52 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBQryPay.jsp,v $
 * Revision 1.27  2014/11/27 06:00:52  MISDAVID
 * EC0386 - Merge MIS Ariel Tag
 *
 * Revision 1.26  2014/07/18 07:29:42  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.25  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.17.4.1  2012/10/31 06:07:24  MISSALLY
 * EA0152 --- VFL PHASE 4
 *
 * Revision 1.17  2012/06/20 00:57:45  MISSALLY
 * QA0134---CASH系統維護信用卡支付增加檢核
 *
 * Revision 1.16  2012/05/18 09:49:52  MISSALLY
 * R10314 CASH系統會計作業修改
 *
 * Revision 1.15  2011/06/02 10:28:08  MISSALLY
 * Q90585 / R90884 / R90989
 * CASH系統匯退處理作業新增匯退原因欄位並修正退匯明細表
 *
 * Revision 1.14  2010/11/23 02:33:05  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.12  2008/08/21 09:15:51  misvanessa
 * R80631_新增原始付款方式 (FOR FF)
 *
 * Revision 1.11  2008/08/06 06:06:12  MISODIN
 * R80132 調整CASH系統for 6種幣別
 *
 * Revision 1.10  2008/04/30 07:50:28  misvanessa
 * R80300_收單行轉台新,新增下載檔案及報表
 *
 * Revision 1.8  2007/01/05 10:10:50  MISVANESSA
 * R60550_匯退支付方式
 *
 * Revision 1.7  2007/01/04 03:24:58  MISVANESSA
 * R60550_新增SHOW匯退手續費
 *
 * Revision 1.3  2006/11/01 08:32:12  MISVANESSA
 * R60420_票據異動為"4"重開,需輸入申請重開USER
 *
 * Revision 1.2  2006/09/04 09:47:07  miselsa
 * R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 *
 * Revision 1.1  2006/06/29 09:40:48  MISangel
 * Init Project
 *
 * Revision 1.1.2.11  2006/04/27 09:42:49  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.10  2006/04/10 05:52:14  misangel
 * R60200:出納功能提升
 *
 * Revision 1.1.2.7  2005/08/19 06:24:45  misangel
 * R50427 : 增加以票據號碼查詢
 *
 * Revision 1.1.2.3  2005/04/04 07:02:21  miselsa
 * R30530 支付系統
 *  
 */
%><%! String strThisProgId = "DISBQryPay"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();

Hashtable htTemp = null;
String strValue = null;

//取得支付原因
List alPSrcCode = new ArrayList();
if (session.getAttribute("PaycdList") == null) {
	alPSrcCode = (List) disbBean.getETable("PAYCD", "");
	session.setAttribute("PaycdList", alPSrcCode);
} else {
	alPSrcCode = (List) session.getAttribute("PaycdList");
}

//R80132 幣別挑選
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

String strReturnMessage = "";
if (request.getParameter("txtMsg") != null) {
	strReturnMessage = request.getParameter("txtMsg");
}

String strAction = "";
if (request.getAttribute("txtAction") != null) {
	strAction = (String) request.getAttribute("txtAction");
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>支付查詢--支付明細</TITLE>
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
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;

	if (document.getElementById("txtAction").value == "")
	{
	   WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;
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

/* 當toolbar frame 中之[離開]按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBQuery/DISBQryPay.jsp?";
}

/* 當toolbar frame 中之[查詢]按鈕被點選時,本函數會被執行 */
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

		var strSql = "SELECT A.PNO,A.PMETHOD,CAST(A.PDATE AS CHAR(7)) AS PDATE,A.PNAME,A.PID,A.PAMT,";
		strSql += "A.PSTATUS,A.PDESC,A.PVOIDABLE,A.PDISPATCH,A.PRBANK,A.PRACCOUNT,A.PCRDNO,A.PCRDTYPE,";
		strSql += "A.PAUTHCODE,A.PCRDEFFMY,A.POLICYNO,A.APPNO,CAST(A.PCSHDT AS CHAR(7)) AS PCSHDT,A.MEMO,";
//RC0036		strSql += "A.PCHKM1,A.PCHKM2,CAST(A.PCFMDT1 AS CHAR(7)) AS PCFMDT1,A.PCFMUSR1,";
/*RC0036*/strSql += "A.PCHKM1,A.PCHKM2,CAST(A.PCFMDT1 AS CHAR(7)) AS PCFMDT1,";
/*RC0036*/strSql += "CAST(U.USRNAM AS CHAR(14))||CAST(T2.FLD0003 AS CHAR(4))||CAST(T1.FLD0003 AS CHAR(4))||CAST(T2.FLD0004 AS CHAR(16))||CAST(T1.FLD0004 AS CHAR(12)) AS PCFMUSR1,";
		strSql += "CAST(A.PCFMDT2 AS CHAR(7)) AS PCFMDT2,A.PCFMUSR2,CAST(A.ENTRYDT AS CHAR(7)) AS ENTRYDT,";
		strSql += "D.CHEQUE_STATUS,CAST(D.CHEQUE_USED_DATE AS CHAR(7)) AS CHEQUE_USED_DATE,D.CHEQUE_NO,";
		strSql += "CAST(D.CHEQUE_DATE AS CHAR(7)) AS CHEQUE_DATE,D.CHEQUE_MEMO,";
		strSql += "CAST(D.CHEQUE_CASH_DATE AS CHAR(7)) AS CHEQUE_CASH_DATE,A.PCURR,";
		strSql += "CAST(A.PCSHCM AS CHAR(7)) AS PCSHCM,D.CHEQUE_CHG4USER";	//R60420新增申請重開票USER
		//R60463
		strSql += ",A.PPAYCURR,A.PPAYAMT,A.PPAYRATE,A.PFEEWAY,A.ENTRYUSR,E.RPAYMIDFEE";
		strSql += ",R.FPAYAMT,R.FFEEWAY";	//R60550新增匯退手續費,支付方式欄位
		strSql += ",A.PORGAMT,A.PORGCRDNO";	//R80300信用卡新增欄位
		strSql += ",A.PMETHODO";	//R80631原始付款方式
		strSql += ",CAST(A.REMITFAILD AS CHAR(7)) as REMITFAILD";
		strSql += " from CAPPAYF A ";
		strSql += " left outer join CAPCHKF D ON  A.PAY_CHECK_NO = D.CHEQUE_NO ";
		//R60463
		strSql += " left outer join CAPRMTF E ON  A.PBATNO = E.BATNO  AND A.BATSEQ = SUBSTR(E.SEQNO,1,3) ";
		strSql += " left outer join CAPRFEF R ON A.PNO = R.FPNO";//R60550新增匯退手續費欄位
/*RC0036*/strSql += " left outer join USER U ON A.PCFMUSR1 = U.USRID ";
/*RC0036*/strSql += " left outer join ORDUET T1 ON  T1.FLD0002 = 'DEPT' AND T1.FLD0003 = U.USRBRCH";    
/*RC0036*/strSql += " left outer join ORDUET T2 ON  T2.FLD0002 = 'DEPT' AND T2.FLD0003 = U.DEPT  ";
		  strSql += " WHERE A.PAY_AMOUNT <> 0 ";
/*RC0036*///strSql += "   AND T1.FLD0002 = 'DEPT'  AND T2.FLD0002 = 'DEPT' ";

		if( document.getElementById("txtCHEQUE").value != "" ) 
		{
			strSql = "SELECT A.PNO,A.PMETHOD,CAST(A.PDATE AS CHAR(7)) AS PDATE ,A.PNAME,A.PID,A.PAMT,";
			strSql += "A.PSTATUS,A.PDESC,A.PVOIDABLE,A.PDISPATCH,A.PRBANK,A.PRACCOUNT,A.PCRDNO,A.PCRDTYPE,";
			strSql += "A.PAUTHCODE,A.PCRDEFFMY,A.POLICYNO,A.APPNO,CAST(A.PCSHDT AS CHAR(7)) AS PCSHDT,";
//RC0036			strSql += "A.MEMO,A.PCHKM1,A.PCHKM2,CAST(A.PCFMDT1 AS CHAR(7)) AS PCFMDT1,A.PCFMUSR1,";
/*RC0036*/	strSql += "A.MEMO,A.PCHKM1,A.PCHKM2,CAST(A.PCFMDT1 AS CHAR(7)) AS PCFMDT1,";
/*RC0036*/  strSql += "CAST(U.USRNAM AS CHAR(14))||CAST(T2.FLD0003 AS CHAR(4))||CAST(T1.FLD0003 AS CHAR(4))||CAST(T2.FLD0004 AS CHAR(16))||CAST(T1.FLD0004 AS CHAR(12)) AS PCFMUSR1,";
			strSql += "CAST(A.PCFMDT2 AS CHAR(7)) AS PCFMDT2,A.PCFMUSR2,";
			strSql += "CAST(A.ENTRYDT AS CHAR(7)) AS ENTRYDT,D.CHEQUE_STATUS,";
			strSql += "CAST(D.CHEQUE_USED_DATE AS CHAR(7)) AS CHEQUE_USED_DATE,D.CHEQUE_NO,";
			strSql += "CAST(D.CHEQUE_DATE AS CHAR(7)) AS CHEQUE_DATE,D.CHEQUE_MEMO,";
			strSql += "CAST(D.CHEQUE_CASH_DATE AS CHAR(7)) AS CHEQUE_CASH_DATE,A.PCURR,";
			strSql += "CAST(A.PCSHCM AS CHAR(7)) AS PCSHCM,D.CHEQUE_CHG4USER";	//R60420新增申請重開票USER
			//R60463
			strSql += ",A.PPAYCURR,A.PPAYAMT,A.PPAYRATE,A.PFEEWAY,A.ENTRYUSR,E.RPAYMIDFEE,R.FPAYAMT";
			strSql += ",R.FFEEWAY";	//R60550新增匯退手續費欄位
			strSql += ",A.PORGAMT,A.PORGCRDNO";	//R80300信用卡新增欄位
			strSql += ",A.PMETHODO";	//R80631原始付款方式
			strSql += ",A.REMITFAILD";
			strSql += " from CAPCHKF D ";
			strSql += " left outer join CAPPAYF A ON  A.PAY_CHECK_NO = D.CHEQUE_NO ";
			//R60463
			strSql += " left outer join CAPRMTF E ON  A.PBATNO = E.BATNO  AND A.BATSEQ = SUBSTR(E.SEQNO,1,3)" ;
			strSql += " left outer join CAPRFEF R ON A.PNO = R.FPNO";//R60550新增匯退手續費欄位
/*RC0036*/	strSql += " LEFT OUTER JOIN USER U ON A.PCFMUSR1 = U.USRID ";
/*RC0036*/	strSql += " LEFT OUTER JOIN ORDUET T1 ON  T1.FLD0003 = U.USRBRCH";    
/*RC0036*/	strSql += " LEFT OUTER JOIN ORDUET T2 ON  T2.FLD0003 = U.DEPT  ";
/*RC0036*/	strSql += " WHERE T1.FLD0002 = 'DEPT'  AND T2.FLD0002 = 'DEPT' ";
/*RC0036*/  strSql += "   AND D.CHEQUE_NO= '" + document.getElementById("txtCHEQUE").value.toUpperCase() + "' ";  
//RC0036			strSql += " WHERE D.CHEQUE_NO= '" + document.getElementById("txtCHEQUE").value.toUpperCase() + "' ";
		}

		if( document.getElementById("txtPolicyNo").value != "" ) {
			strSql += " AND POLICY_NO = '" + document.getElementById("txtPolicyNo").value.toUpperCase() + "' ";
		}
		if( document.getElementById("txtAppNo").value != "" ) {
			strSql += "  AND  APPNO= '" + document.getElementById("txtAppNo").value.toUpperCase() + "' ";
		}
		if( document.getElementById("txtPName").value != "" ){
			strSql += "  AND PNAME like '^" +  document.getElementById("txtPName").value + "^' ";
		}
		if( document.getElementById("txtPid").value != "" ){
			strSql += "  AND  PID= '" + document.getElementById("txtPid").value.toUpperCase()  + "' ";
		}
		if( document.getElementById("txtPAMT").value != "" ) {
			strSql += " AND  PAMT = " + document.getElementById("txtPAMT").value + " ";
		}
		if( document.getElementById("txtPRBank").value != "" ) {
			strSql += "  AND  PRBANK= '" +  document.getElementById("txtPRBank").value + "' ";
		}
		if( document.getElementById("txtPRAccount").value != "" ) {
			strSql += " AND  PRACCOUNT = '" + document.getElementById("txtPRAccount").value + "' ";
		}
		if( document.getElementById("txtPCrdNo").value != "" ){
			strSql += "  AND  PCRDNO= '" + document.getElementById("txtPCrdNo").value + "' ";
		}
		if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value != "") {
			strSql += " AND  PAY_DATE BETWEEN " + document.getElementById("txtPStartDate").value + " and " + document.getElementById("txtPEndDate").value ;
		} else if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value == "") {
			strSql += "  AND PAY_DATE >= " + document.getElementById("txtPStartDate").value ;
		} else if (document.getElementById("txtPStartDate").value == "" && document.getElementById("txtPEndDate").value != "") {
			strSql += " AND  PAY_DATE <= " + document.getElementById("txtPEndDate").value ;
		}

		if (document.getElementById("txtEntryStartDate").value != "" && document.getElementById("txtEntryEndDate").value != "")  {
			strSql += " AND  A.ENTRY_DATE BETWEEN " + document.getElementById("txtEntryStartDate").value + " and " + document.getElementById("txtEntryEndDate").value;
		} else if (document.getElementById("txtEntryStartDate").value != "" && document.getElementById("txtEntryEndDate").value == "") {
			strSql += "  AND A.ENTRY_DATE >= " + document.getElementById("txtEntryStartDate").value;
		} else if (document.getElementById("txtEntryStartDate").value == "" && document.getElementById("txtEntryEndDate").value != "") {
			strSql += " AND  A.ENTRY_DATE <= " + document.getElementById("txtEntryEndDate").value;
		}

		if (document.getElementById("txtUpdStartDate").value != "" && document.getElementById("txtUpdEndDate").value != "") {
			strSql += "  AND UPDATE_DATE BETWEEN " + document.getElementById("txtUpdStartDate").value + " and " + document.getElementById("txtUpdEndDate").value;
		} else if (document.getElementById("txtUpdStartDate").value != "" && document.getElementById("txtUpdEndDate").value == "") {
			strSql += "  AND UPDATE_DATE >= " + document.getElementById("txtUpdStartDate").value;
		} else if (document.getElementById("txtUpdStartDate").value == "" && document.getElementById("txtUpdEndDate").value != "") {
			strSql += "  AND UPDATE_DATE <= " + document.getElementById("txtUpdEndDate").value;
		}

		if( document.getElementById("selPStatus").value != "" ) {
			strSql += "   AND PSTATUS= '" + document.getElementById("selPStatus").value + "' ";
		}

		if( document.getElementById("selPVoidable").value != "" ) {
			strSql += "   AND PVOIDABLE= '" + document.getElementById("selPVoidable").value + "' ";
		}

		if( document.getElementById("selDispatch").value != "" ) {
			strSql += "   AND PDISPATCH= '" + document.getElementById("selDispatch").value + "' ";
		}

		if( document.getElementById("selCurrency").value != "" ) {
			strSql += "   AND PCURR= '" + document.getElementById("selCurrency").value + "' ";
		}

		var strQueryString = "?RowPerPage=20&TableWidth=820&Sql="+strSql;
		<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	    session.setAttribute("Heading","保單號碼,要保書號碼,受款人姓名,受款人ID,幣別,支付金額,付款方式,付款內容,付款狀態,作廢否,急件否,輸入者,輸入日,出納確認日,退匯日期");
	    session.setAttribute("DisplayFields", "POLICYNO,APPNO,PNAME,PID,PCURR,PAMT,PMETHOD,PDESC,PSTATUS,PVOIDABLE,PDISPATCH,ENTRYUSR,ENTRYDT,PCSHCM,REMITFAILD");
	    session.setAttribute("ReturnFields", "PNO,PMETHOD,PDATE,PNAME,PID,PAMT,PSTATUS,PDESC,PVOIDABLE,PDISPATCH,PRBANK,PRACCOUNT,PCRDNO,PCRDTYPE,PAUTHCODE,PCRDEFFMY,POLICYNO,APPNO,PCSHDT,MEMO,PCHKM1,PCHKM2,PCFMDT1,PCFMUSR1,PCFMDT2,PCFMUSR2,ENTRYDT,CHEQUE_STATUS,CHEQUE_USED_DATE,CHEQUE_NO,CHEQUE_DATE,CHEQUE_MEMO,CHEQUE_CASH_DATE,PCURR,PCSHCM,CHEQUE_CHG4USER,PPAYCURR,PPAYAMT,PPAYRATE,PFEEWAY,ENTRYUSR,RPAYMIDFEE,FPAYAMT,FFEEWAY,PORGAMT,PORGCRDNO,PMETHODO,REMITFAILD");
	    %>
		//modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" )
		{
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtUPNO").value = returnArray[0];
			document.getElementById("txtPNO").value = document.getElementById("txtUPNO").value;
			var strUPMethod = returnArray[1];

			if (strUPMethod =="A")
			{
				document.getElementById("txtUPMethod").value = "支票";
				document.getElementById("txtUPDate").value = returnArray[18];	
			} 
			else if(strUPMethod =="B")
			{
				document.getElementById("txtUPMethod").value = "匯款";
				document.getElementById("txtUPDate").value = returnArray[34];	
			} 
			else if(strUPMethod =="C")
			{
				document.getElementById("txtUPMethod").value = "信用卡";
				document.getElementById("txtUPDate").value = returnArray[18];
			}
			else if(strUPMethod =="D")   //R60463
			{
				document.getElementById("txtUPMethod").value = "外幣付款";
				document.getElementById("txtUPDate").value = returnArray[34];
			} 
			else if(strUPMethod =="E")
			{
				document.getElementById("txtUPMethod").value = "現金";
				document.getElementById("txtUPDate").value = returnArray[34];
			}
			else
			{
				document.getElementById("txtUPMethod").value = "";
				document.getElementById("txtUPDate").value = returnArray[18];
			}

			document.getElementById("txtCSHDT").value = returnArray[18];
			document.getElementById("txtCSHCFMDT").value = returnArray[34];

			// R60463			
			if (strUPMethod =="D")
			{
				document.getElementById("txtPayCurr").value = returnArray[36];
				document.getElementById("txtPayAmt").value = returnArray[37];
				document.getElementById("txtPayRate").value = returnArray[38];

				if (returnArray[39] =="SHA")
				{
					document.getElementById("txtFeeWay").value = "SHARE";
				} 
				else if(returnArray[39] =="BEN")
				{
					document.getElementById("txtFeeWay").value = "BENEFIT";
				} 
				else if(returnArray[39] =="OUR")
				{
					document.getElementById("txtFeeWay").value = "OUR";
				} 
				else 
				{
					document.getElementById("txtFeeWay").value = "";
				}

				if (returnArray[41] > 0  && returnArray[41] != null)
				{
					document.getElementById("txtPayMidfee").value = "Y";
				} 
				else 
				{
					document.getElementById("txtPayMidfee").value = "N";
				}
			}

			document.getElementById("txtFPAYAMT").value = returnArray[42];	//R60550新增匯退手續費
			document.getElementById("txtFFEEWAY").value = returnArray[43];	//R60550新增匯退支付方式
			document.getElementById("txtUPOrgAMT").value = returnArray[44];	//R80300原始請款金額
			document.getElementById("txtUPOrgCrdNo").value = returnArray[45];//R80300原始請款卡號
			//R80631原始付款方式
			var strPMethodO = returnArray[46];
			if (strPMethodO =="A") {
				document.getElementById("txtPMethodO").value = "支票";
			} else if(strPMethodO =="B") {
				document.getElementById("txtPMethodO").value = "匯款";
			} else if(strPMethodO =="C") {
				document.getElementById("txtPMethodO").value = "信用卡";
			} else if(strPMethodO =="D") {
			 	document.getElementById("txtPMethodO").value = "外幣付款"; 
			} else if(strPMethodO =="E") {
				document.getElementById("txtPMethodO").value = "現金";
			} else {
			 	document.getElementById("txtPMethodO").value = strPMethodO;
			} //R80631 end

			document.getElementById("txtUPName").value = returnArray[3];
			document.getElementById("txtUPId").value = returnArray[4];
			document.getElementById("txtUPAMT").value = returnArray[33] +"$ " + returnArray[5];

			var strUPStatus = returnArray[6];
			if (strUPStatus == "A")
			{
				//R90884 增加退匯日期
				if(strUPMethod == "B" || strUPMethod == "C" || strUPMethod == "D") {
					document.getElementById("txtUPStatus").value = "失敗　退匯日期：" + returnArray[47];
				} else {
					document.getElementById("txtUPStatus").value = "失敗";
				}
			}
			else if(strUPStatus =="B")
			{
				document.getElementById("txtUPStatus").value = "成功";
			}
			else
			{
				document.getElementById("txtUPStatus").value = "";
				document.getElementById("txtUPDate").value = returnArray[2];
			}

			document.getElementById("txtUPDesc").value = returnArray[7];

			//作廢否            			            
			var strUPVoidable = returnArray[8];
			//急件否
			var strUPDispatch = returnArray[9];
			if (strUPDispatch == "Y")
			{
				document.getElementById("txtUDispatch_1").checked = true;
				document.getElementById("txtUDispatch_1").value = "Y";
			} 
			else
			{
				document.getElementById("txtUDispatch_2").checked = true;
				document.getElementById("txtUDispatch_2").value = "";
			}
			//支票禁背
			var strUPCHKM1 = returnArray[20];
			if (strUPCHKM1 == "Y")
			{
				document.getElementById("txtUPCHKM1_1").checked = true;
				document.getElementById("txtUPCHKM1_1").value = "Y";
			} 
			else
			{
				document.getElementById("txtUPCHKM1_2").checked = true;
				document.getElementById("txtUPCHKM1_2").value = "";
			}
			//支票劃線
			var strUPCHKM2 = returnArray[21];
			if (strUPCHKM2 == "Y")
			{
				document.getElementById("txtUPCHKM2_1").checked = true;
				document.getElementById("txtUPCHKM2_1").value = "Y";
			} 
			else
			{
				document.getElementById("txtUPCHKM2_2").checked = true;
				document.getElementById("txtUPCHKM2_2").value = "";
			}

			document.getElementById("txtUPRBank").value = returnArray[10];
			document.getElementById("txtUPRAccount").value = returnArray[11];
			document.getElementById("txtUPCrdNo").value = returnArray[12];
			document.getElementById("txtUPCrdEffMY").value = returnArray[15];
			document.getElementById("txtPUCrdType").value = returnArray[13];
			document.getElementById("txtUPAuthCode").value = returnArray[14];
			document.getElementById("txtUPolNo").value = returnArray[16];
			document.getElementById("txtUAppNo").value = returnArray[17];
			document.getElementById("txtUPMEMO").value = returnArray[19];
            document.getElementById("txtCHEQUE_STATUS").value = returnArray[27];
            document.getElementById("txtCapsilDate").value = returnArray[26];
			document.getElementById("txtUsrCfmDT1").value = returnArray[22];			
			document.getElementById("txtUsrCfmID1").value = returnArray[23];			
			document.getElementById("txtUsrCfmDT2").value = returnArray[24];			
			document.getElementById("txtUsrCfmID2").value = returnArray[25];			            
            var strChqST =returnArray[27];

			if (returnArray[29] !="" )
			{
				document.getElementById("txtCHEQUE_USED_DATE").value = returnArray[28];
				document.getElementById("txtCHEQUE_NO").value = returnArray[29];
				document.getElementById("txtCHEQUE_DATE").value = returnArray[30];
				document.getElementById("txtChequeMEMO").value = returnArray[31];
				document.getElementById("txtCHEQUE_CASH_DATE").value = returnArray[32];
				document.getElementById("txtCHEQUE_CHG4USER").value = returnArray[35];	//R60420

				if (strChqST =="D")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="開立";
				}
				else if (strChqST =="C")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="兌現";
				}
				else if (strChqST =="R")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="退回";
				}
				else if (strChqST =="V")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="作廢";
				}
				else if (strChqST =="1")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="逾一年";
				}
				else if (strChqST =="2")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="逾二年";
				}
				else if (strChqST =="3")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="重印";
				}
				else if (strChqST =="4")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="重開";
				}
				else if (strChqST =="5")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="掛失";
				}
				else if (strChqST =="6")
				{
					document.getElementById("txtCHEQUE_STATUS").value ="除權判決";
				}
				else
				{
					document.getElementById("txtCHEQUE_STATUS").value ="庫存";
				}
			}

			document.getElementById("txtAction").value = "I";
			WindowOnLoadCommon( document.title , '' , 'E','' );
			document.getElementById("updateArea").style.display = "block";
			document.getElementById("inqueryArea").style.display = "none";
		}
	}
}

function mapValue()
{
	document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value) ;
	document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value) ;	
	document.getElementById("txtEntryStartDate").value = rocDate2String(document.getElementById("txtEntryStartDateC").value) ;	    	 
   	document.getElementById("txtEntryEndDate").value = rocDate2String(document.getElementById("txtEntryEndDateC").value) ;	
	document.getElementById("txtUpdStartDate").value = rocDate2String(document.getElementById("txtUpdStartDateC").value) ;	    	 
   	document.getElementById("txtUpdEndDate").value = rocDate2String(document.getElementById("txtUpdEndDateC").value) ;	
}

function checkClientField(objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";

	if( objThisItem.name == "txtPStartDateC" || objThisItem.name == "txtPEndDateC" ||
	    objThisItem.name == "txtEntryStartDateC" || objThisItem.name == "txtEntryEndDateC" ||
	    objThisItem.name == "txtUpdStartDateC" || objThisItem.name == "txtUpdEndDateC" )
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
<form id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="452" height="333" id=inqueryArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">受款人姓名：</TD>
			<TD><INPUT class="Data" size="25" type="text" maxlength="25" width="333" id="txtPName" name="txtPName" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">受款人ID：</TD>
			<TD width="333"><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPid" name="txtPid" value=""></TD>
		<TR>
			<TD align="right" class="TableHeading" width="101">支付狀態：</TD>
			<TD width="333">
				<select size="1" name="selPStatus" id="selPStatus">
					<option value=""></option>
					<option value="A">A:失敗</option>
					<option value="B">B:成功</option>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">支付金額：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPAMT" id="txtPAMT" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">付款日期：</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPStartDateC" name="txtPStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> 
				<INPUT type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> 
				~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC" name="txtPEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> 
				<INPUT type="hidden" name="txtPEndDate" id="txtPEndDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">輸入日期：</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> 
				<INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate" value=""> 
				~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryEndDateC" name="txtEntryEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtEntryEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> 
				<INPUT type="hidden" name="txtEntryEndDate" id="txtEntryEndDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">匯款銀行代號：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPRBank" id="txtPRBank" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">匯款銀行帳號：</TD>
			<TD><INPUT class="Data" size="16" type="text" maxlength="16" name="txtPRAccount" id="txtPRAccount" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">信用卡號碼：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCrdNo" name="txtPCrdNo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">異動日期：</TD>
			<TD width="333" valign="middle">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUpdStartDateC" name="txtUpdStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtUpdStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> 
				<INPUT type="hidden" name="txtUpdStartDate" id="txtUpdStartDate" value=""> 
				~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUpdEndDateC" name="txtUpdEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtUpdEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				</a> 
				<INPUT type="hidden" name="txtUpdEndDate" id="txtUpdEndDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">作廢否：</TD>
			<TD width="333" valign="middle">
				<select size="1" name="selPVoidable" id="selPVoidable">
					<option value=""></option>
					<option value="Y">是</option>
					<option value="N">否</option>
				</select>
			</TD>
		<TR>
			<TD align="right" class="TableHeading" width="101">急件否：</TD>
			<TD width="333" valign="middle">
				<select size="1" name="selDispatch" id="selDispatch">
					<option value=""></option>
					<option value="Y">是</option>
					<option value="N">否</option>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">保單號碼：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPolicyNo" id="txtPolicyNo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101" height="24">要保書號碼：</TD>
			<TD height="24"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtAppNo" id="txtAppNo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">支票號碼：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="16" name="txtCHEQUE" id="txtCHEQUE" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">幣別：</TD>
			<TD width="333" valign="middle">
				<select size="1" name="selCurrency" id="selCurrency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
	</TBODY>
</TABLE>

<TABLE border="1" width="900" id=updateArea style="display: none">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="200">保單號碼：</TD>
			<TD width="200"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" width="100" name="txtUPolNo" id="txtUPolNo" readOnly></TD>
			<TD align="right" class="TableHeading" height="24" width="200">要保書號碼：</TD>
			<TD height="24" width="200"><INPUT class="INPUT_DISPLAY" size="11" type="text" width="100" maxlength="10" name="txtUAppNo" id="txtUAppNo"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">付款日期：</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPDate" name="txtUPDate" readOnly></TD>
			<TD align="right" class="TableHeading">受款人ID：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPid" name="txtUPid"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">受款人姓名：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="11" id="txtUPName" name="txtUPName"></TD>
			<TD align="right" class="TableHeading">支付金額：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPAMT" id="txtUPAMT"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">付款方式：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPMethod" name="txtUPMethod"></TD>
			<TD align="right" class="TableHeading">支付狀態：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="25" name="txtUPStatus" id="txtUPStatus" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">支付描述：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" maxlength="11" name="txtUPDesc" id="txtUPDesc"></TD>
			<TD align="right" class="TableHeading">支付註記：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtUPMEMO" id="txtUPMEMO" size="45"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">匯款銀行代號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPRBank" id="txtUPRBank"></TD>
			<TD align="right" class="TableHeading">匯款銀行帳號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="14" type="text" maxlength="11" name="txtUPRAccount" id="txtUPRAccount"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">信用卡號碼：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPCrdNo" name="txtUPCrdNo" value=""></TD>
			<TD align="right" class="TableHeading">卡別：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtPUCrdType" name="txtPUCrdType" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">有效截止月年：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPCrdEffMY" name="txtUPCrdEffMY" value=""></TD>
			<TD align="right" class="TableHeading">授權碼：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPAuthCode" name="txtUPAuthCode" value=""></TD>
		</TR>
		<!--R80300  信用卡新增欄位-->
		<TR>
			<TD align="right" class="TableHeading">原刷金額：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPOrgAMT" name="txtUPOrgAMT" value=""></TD>
			<TD align="right" class="TableHeading">原刷卡號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPOrgCrdNo" name="txtUPOrgCrdNo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">急件否：</TD>
			<TD><input type="radio" name="txtUDispatch" id="txtUDispatch_1" Value="Y" disabled>是 <input type="radio" name="txtUDispatch" id="txtUDispatch_2" Value="" disabled>否</TD>
			<!--R60420申請重開票USER-->
			<TD align="right" class="TableHeading">申請重開票User：</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtCHEQUE_CHG4USER" name="txtCHEQUE_CHG4USER" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">票號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtCHEQUE_NO" name="txtCHEQUE_NO" value=""></TD>
			<TD align="right" class="TableHeading">開立日期：</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtCHEQUE_USED_DATE" name="txtCHEQUE_USED_DATE" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">支票劃線：</TD>
			<TD><input type="radio" name="txtUPCHKM2" id="txtUPCHKM2_1" checked Value="Y" disabled>是 <input type="radio" name="txtUPCHKM2" id="txtUPCHKM2_2" checked Value="" disabled>否</TD>
			<TD align="right" class="TableHeading">支票禁背：</TD>
			<TD><input type="radio" name="txtUPCHKM1" id="txtUPCHKM1_1" Value="Y" disabled>是 <input type="radio" name="txtUPCHKM1" id="txtUPCHKM1_2" Value="" disabled>否</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">支票狀態：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtCHEQUE_STATUS" id="txtCHEQUE_STATUS" readOnly></TD>
			<TD align="right" class="TableHeading">票據到期日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtCHEQUE_DATE" id="txtCHEQUE_DATE" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">票據兌現日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtCHEQUE_CASH_DATE" id="txtCHEQUE_CASH_DATE" readOnly></TD>
			<TD align="right" class="TableHeading">票據備註：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtChequeMEMO" id="txtChequeMEMO"></TD>
		</TR>
		<TR>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">支付序號：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="25" name="txtUPNO" id="txtUPNO" readOnly></TD>
			<TD align="right" class="TableHeading">CAPSIL DATE：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtCapsilDate" id="txtCapsilDate"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">User確認日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtUsrCfmDT1" id="txtUsrCfmDT1"></TD>
			<TD align="right" class="TableHeading">User確認人員：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="40" type="text" maxlength="25" name="txtUsrCfmID1" id="txtUsrCfmID1" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">財務確認日：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtUsrCfmDT2" id="txtUsrCfmDT2"></TD>
			<TD align="right" class="TableHeading">財務確認人員：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="25" name="txtUsrCfmID2" id="txtUsrCfmID2" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">出納日期(出納執行日)：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtCSHDT" id="txtCSHDT"></TD>
			<TD align="right" class="TableHeading">出納確認日(匯款日)：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtCSHCFMDT" id="txtCSHCFMDT" readOnly></TD>
		</TR>
		<!--  R60463  -->
		<TR>
			<TD align="right" class="TableHeading">外幣匯出幣別：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtPayCurr" id="txtPayCurr"></TD>
			<TD align="right" class="TableHeading">外幣匯率：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="25" name="txtPayRate" id="txtPayRate" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">外幣匯出金額：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtPayAmt" id="txtPayAmt"></TD>
			<TD align="right" class="TableHeading">手續費支付方式：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="25" name="txtFeeWay" id="txtFeeWay" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">後收手續費是否已處理：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtPayMidfee" id="txtPayMidfee"></TD>
			<!--R80631-->
			<TD align="right" class="TableHeading">原始付款方式：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtPMethodO" id="txtPMethodO"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">匯退手續費支付方式：</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtFFEEWAY" id="txtFFEEWAY"></TD>
			<TD align="right" class="TableHeading">匯退手續費：</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="25" name="txtFPAYAMT" id="txtFPAYAMT" readOnly></TD>
		</TR>
		<TR>
			<TD colspan=4><font color="red">PS:匯退手續費幣別同於外幣匯出幣別</font></TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtPNO" name="txtPNO" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>
