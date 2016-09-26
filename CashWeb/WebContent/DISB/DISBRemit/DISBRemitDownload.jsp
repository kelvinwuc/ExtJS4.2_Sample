<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 匯出
 * 
 * Remark   : 出納功能
 * 
 * Revision : $Revision: 1.23 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : 2005/04/04
 * 
 * Request ID  : R30530
 * 
 * CVS History :
 * 
 * $Log: DISBRemitDownload.jsp,v $
 * Revision 1.23  2015/04/30 02:20:03  001946
 * RD0144-凱基銀行變更人民幣代號及SWIFT CODE
 *
 * Revision 1.22  2014/10/07 06:26:57  misariel
 * QC0274-英文姓名轉為大寫顯示
 *
 * Revision 1.21  2014/07/18 07:31:58  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.20  2014/02/06 09:52:59  MISSALLY
 * RB0806---修改彰銀媒體遞送單
 *
 * Revision 1.19  2013/12/13 04:02:25  MISSALLY
 * RB0682---修改台新退貨憑證
 *
 * Revision 1.18  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 * Revision 1.17  2013/03/11 08:59:44  ODCWilliam
 * Revision 1.16  2013/02/26 10:18:20  ODCWilliam
 * RA0074
 *
 * Revision 1.15  2011/03/03 01:51:43  MISJIMMY
 * R00565  台新退貨憑證改版
 *
 * Revision 1.13  2008/08/18 06:17:44  MISODIN
 * R80338 外幣匯款表帶出銀行中文簡稱
 *
 * Revision 1.12  2008/04/30 07:50:38  misvanessa
 * R80300_收單行轉台新,新增下載檔案及報表
 *
 * Revision 1.11  2007/10/04 01:44:55  MISODIN
 * R70477 外幣保單匯款手續費
 *
 * Revision 1.10  2007/08/03 10:09:32  MISODIN
 * R70477 外幣保單匯款手續費
 *
 * Revision 1.9  2007/03/19 02:27:28  MISVANESSA
 * R70088_SPUL配息新增各部分匯費
 *
 * Revision 1.8  2007/03/06 01:48:21  MISVANESSA
 * R70088_SPUL配息新增客戶負擔手續費
 *
 * Revision 1.7  2007/01/31 08:06:50  MISVANESSA
 * R70088_SPUL配息
 *
 * Revision 1.6  2007/01/12 02:19:30  MISVANESSA
 * R60550_抓取方式修改
 *
 * Revision 1.5  2007/01/05 07:24:23  MISVANESSA
 * R60550_匯出檔案.報表修改
 *
 * Revision 1.4  2007/01/04 03:26:56  MISVANESSA
 * R60550_抓取方式修改
 *
 * Revision 1.3  2006/11/30 09:14:24  MISVANESSA
 * R60550_配合SPUL&外幣付款修改
 *
 * Revision 1.2  2006/09/04 09:47:07  miselsa
 * R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 *
 * Revision 1.1  2006/06/29 09:39:46  MISangel
 * Init Project
 *
 * Revision 1.1.2.9  2006/04/27 09:41:44  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.8  2006/04/10 05:54:19  misangel
 * R60200:出納功能提升
 *
 * Revision 1.1.2.5  2005/05/05 02:46:39  MISANGEL
 * R30530:支付系統
 *
 * Revision 1.1.2.4  2005/04/04 07:02:26  miselsa
 * R30530 支付系統
 *  
 */
%><%! String strThisProgId = "DISBRemitExport"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
SimpleDateFormat sdfDate = new SimpleDateFormat("yyyyMMdd", java.util.Locale.TAIWAN);
String strCapsil = sdfDate.format(commonUtil.getBizDateByRDate());

String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";

Vector vo = (Vector)request.getAttribute("vo");
Vector downfile = (Vector)request.getAttribute("downdatalist");
%>
<HTML>
<HEAD>
<TITLE>出納功能--匯款檔案</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value);

	if(document.getElementById("txtAction").value == "downReturn")
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyExit,'' ) ;
		document.getElementById("inqueryArea").style.display = "none";
		document.getElementById("inqueryArea1").style.display = "none";
		document.getElementById("downReturnArea").style.display = "block";
	}
	else
	{
	   	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyRemitB,'' ) ;
	    document.getElementById("inqueryArea").style.display = "block";
	    document.getElementById("inqueryArea1").style.display = "block";
		document.getElementById("downReturnArea").style.display = "none";
	}

	window.status = "";
}

function selectBatNo(strBATNO,strPCURR) 
{
	document.getElementById("para_PBATNO").value=strBATNO;
	document.getElementById("para_PoCURR").value=strPCURR;

	//R80300 信用卡
	if (strBATNO.charAt(0)=="C")
	{
		document.getElementById("selCredit").style.display = "block";	
	}
	else
	{
		document.getElementById("selCredit").style.display = "none";
	}
}

function DISBDownloadAction()
{
	document.frmMain.action = "<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitExportServlet?action=download";
	document.frmMain.submit();
}

function printRAction()
{   
	var batno = document.frmMain.para_PBATNO.value;
	var reportName = document.getElementById("ReportName");
	var strFormValue = "pdf";

	if(document.frmMain.rdReportForm[0].checked) 
	{ 
		document.frmMain.OutputType.value = "PDF";
		document.frmMain1.OutputType.value = "PDF";//R60550
		document.frmMain2.OutputType.value = "PDF";//R70088
		document.frmMain3.OutputType.value = "PDF";//R80300
		document.frmMain4.OutputType.value = "PDF";//R80300
		document.frmMain5.OutputType.value = "PDF";//R80300
		document.frmMain6.OutputType.value = "PDF";//R00386
		document.frmMain7.OutputType.value = "PDF";//R00386
		strFormValue = "pdf";
	}
	else
	{ 
		document.frmMain.OutputType.value = "TXT";
		document.frmMain1.OutputType.value = "TXT";//R60550
		document.frmMain2.OutputType.value = "TXT";//R70088
		document.frmMain3.OutputType.value = "TXT";//R80300
		document.frmMain4.OutputType.value = "TXT";//R80300
		document.frmMain5.OutputType.value = "TXT";//R80300
		document.frmMain6.OutputType.value = "TXT";//R00386
		document.frmMain7.OutputType.value = "TXT";//R00386
		strFormValue = "rpt";
	}

	if(batno.charAt(0)=="D" )
	{
		// R70477 花旗拆同行相轉與非同行相轉
		if(batno.substring(8,11) != "021" )
		{
			getReportInfoD(); //外幣的整批匯款報表
			document.frmMain1.OutputFileName.value = "DISBRemitExportD." + strFormValue;
			document.getElementById("frmMain1").target="_blank";
			document.frmMain1.submit();

			document.frmMain2.OutputFileName.value = "DISBRemitExportDTot." + strFormValue;
			document.getElementById("frmMain2").target="_blank";
			document.frmMain2.submit();
		}
		else 
		{
			if(batno.substring(8,11) == "021" )
			{
				getReportInfoD021_1();
				document.frmMain1.OutputFileName.value = "DISBRemitExportD." + strFormValue ;
				document.getElementById("frmMain1").target="_blank";
				document.frmMain1.submit();

				getReportInfoD021_2();
				document.frmMain1.OutputFileName.value = "DISBRemitExportD." + strFormValue ;
				document.getElementById("frmMain1").target="_blank";
				document.frmMain1.submit();

				// 總表
				getReportInfoD021_3();
				document.frmMain2.OutputFileName.value = "DISBRemitExportDTot." + strFormValue ;
				document.getElementById("frmMain2").target="_blank";
				document.frmMain2.submit();
			}
		}
	}
	else
	{
		if(batno.charAt(0)=="C" )
		{	//R80300 匯豐
			if(document.frmMain.chkRPT[0].checked) 
			{
				getReportInfoC();
				reportName.value = "DISBRemitExportC.rpt" ;
				document.getElementById("OutputFileName").value = "DISBRemitExportC." + strFormValue ;
			  	document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";
		    	document.getElementById("frmMain").target="_blank";
		    	document.frmMain.submit();
		    }
       		//R80300 台新退貨憑證
		    if(document.frmMain.chkRPT[1].checked) 
		    {
			    getReportInfoC812();     	
 		    	document.frmMain3.OutputFileName.value = "DISBRemitExportC812." + strFormValue ;
			    document.getElementById("frmMain3").target="_blank";			    
		    	document.frmMain3.submit();
		    }
       		//R80300 信用卡退貨所有-FIN
		    if(document.frmMain.chkRPT[2].checked) 
		    {
			    getReportInfoC_FIN("812"); 
 		    	document.frmMain4.OutputFileName.value = "DISBRemitExportC_FIN." + strFormValue ;
		    	document.getElementById("frmMain4").target="_blank";
		    	document.frmMain4.submit();
			    getReportInfoC_FIN("081"); 
 		    	document.frmMain4.OutputFileName.value = "DISBRemitExportC_FIN." + strFormValue ;
		    	document.getElementById("frmMain4").target="_blank";
		    	document.frmMain4.submit();
		    	
		    }
       		//R80300 拒絕報表
		    if(document.frmMain.chkRPT[3].checked) 
		    {
			    getReportInfoC_FAIL(); 
 		    	document.frmMain5.OutputFileName.value = "DISBRemitExportC_Fail." + strFormValue ;
		    	document.getElementById("frmMain5").target="_blank";
		    	document.frmMain5.submit();
		    }
		}
		else
		{   //RC0036
		    if(batno.substring(8,11) == "812" ){ 
		       var xPaymethod = batno.charAt(0);
		       getReportInfo812U(xPaymethod);                  
		       reportName.value = "DISBRemitExport812U.rpt" ; 
			   document.getElementById("OutputFileName").value = "DISBRemitExport812U." + strFormValue ; 
			   document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";  
		       document.getElementById("frmMain").target="_blank"; 
		       document.frmMain.submit();
		    }else{                                //RC0036        
		       getReportInfoB();
			   reportName.value = "DISBRemitExportB.rpt" ;
			   document.getElementById("OutputFileName").value = "DISBRemitExportB." + strFormValue ;
			   document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";
			   document.getElementById("frmMain").target="_blank";
		 	   document.frmMain.submit();
		 	}   
		}
	}

	// R00386 一銀專屬匯款申請書
    var payMethod = batno.charAt(0);
    var rBank = batno.substring( 8, 11 );
    if( rBank == "007" && ( payMethod == "B" || payMethod == "D" ) ) 
    {
		var sql = " SELECT PBK AS PBBANK,B.BKFNM,PACCT AS PBACCOUNT,E.FLD0004 AS PAYCURR,COUNT(*) AS CNT, SUM(RPAYAMT) AS SUM, SUM( RMTFEE ) AS RMTFEE,A.RMTDT "
    			+ " FROM CAPRMTF A "
    			+ " LEFT JOIN CAPCCBF B ON A.PBK = B.BKNO "
    			+ " LEFT JOIN ORDUET E ON FLD0002 = 'CURRA' AND E.FLD0003 = A.RPAYCURR "
    			+ " WHERE BATNO = '" + batno + "' "
    			+ " GROUP BY A.PBK, B.BKFNM, A.PACCT, E.FLD0004, A.RMTDT "
    			+ " ORDER BY PBK, A.PACCT ";

    	// 取日期
    	var rocDate = batno.substring( 1, 8 );
    	var wcDate = ( parseInt( rocDate.substring( 0, 3 ), 10 ) + 1911 )
    			   + "/" + rocDate.substring( 3, 5 ) 
    			   + "/" + rocDate.substring( 5 ); 

		document.getElementById( "frmMain6" ).target="_blank";
		document.frmMain6.para_cashConfirmDate.value = wcDate;
    	document.frmMain6.ReportSQL.value = sql;
		document.frmMain6.OutputFileName.value = "DISBRemitFcbForm2." + strFormValue;
		document.frmMain6.submit();

		document.getElementById( "frmMain7" ).target="_blank";
		document.frmMain7.para_cashConfirmDate.value = wcDate;
    	document.frmMain7.ReportSQL.value = sql;
		document.frmMain7.OutputFileName.value = "DISBRemitFcbForm1." + strFormValue;
		document.frmMain7.submit();
	}

	//彰銀媒體遞送單 (僅轉帳檔)
	if( rBank == "009" && payMethod == "D" )
	{
		document.getElementById( "frmMain8" ).target="_blank";
		document.frmMain8.para_batchno.value = batno;
		document.frmMain8.submit();
	}
}

function getReportInfoB()
{
	var strSql  = "select RNAME,PACCT,BANK_NAME,RACCT,RMTDT,RAMT,RMTFEE,BATNO,C.DEPT,SEQNO,d.pdispatch ";
	strSql += " from CAPRMTF A ";
	strSql += " LEFT OUTER JOIN capccbf B on A.RBK = B. BANK_NO";
	strSql += " LEFT OUTER JOIN USER C ON A.ENTRYUSR = C.USRID";
	strSql += "  join (SELECT DISTINCT PBATNO,pdispatch FROM CAPPAYF) d on d.PBATNO=a.batno ";
	strSql += " WHERE 1=1 ";

	if (document.frmMain.para_PBATNO.value != "") {
		strSql += " AND A.BATNO = '" + document.frmMain.para_PBATNO.value + "' ";
	}

	strSql +=" order by A.seqno"; 

	document.getElementById("ReportSQL").value = strSql;
}
//RC0036-台新急件
function getReportInfo812U(xMethod)
{  
   
    if(xMethod=="B" )
	{
	   //RC0036
	   //var strSql  = " SELECT SUBSTR(RBK,1,6) AS RBK,RAMT,(SELECT FLD006 FROM BANKFEE WHERE FLD003 <= RAMT AND FLD004 >= RAMT) AS FEE,RIGHT('00000000000000'||TRIM(RACCT),14) AS RACCT,RNAME,SUBSTR(RMTDT,1,3)||'/'||SUBSTR(RMTDT,4,2)||'/'||SUBSTR(RMTDT,6,2) AS RMTDT, ";
	   var strSql  = " SELECT SUBSTR(RBK,1,6) AS RBK,RAMT,(SELECT CASE WHEN SUBSTR(RBK,1,3) = SUBSTR(PBK,1,3) THEN 0 ELSE FLD006 END FROM BANKFEE WHERE FLD003 <= RAMT AND FLD004 >= RAMT) AS FEE,RIGHT('00000000000000'||TRIM(RACCT),14) AS RACCT,RNAME,SUBSTR(RMTDT,1,3)||'/'||SUBSTR(RMTDT,4,2)||'/'||SUBSTR(RMTDT,6,2) AS RMTDT, ";
	       strSql += " '全球人壽' AS NOTE ";
	       strSql += " FROM CAPRMTF A ";
	       strSql += " LEFT OUTER JOIN USER C ON A.ENTRYUSR = C.USRID";
	       strSql += " JOIN (SELECT DISTINCT PBATNO , PDISPATCH FROM CAPPAYF) D ON D.PBATNO = A.BATNO   ";
	       strSql += " WHERE 1=1 ";
	       strSql += "   AND SUBSTR(BATNO,1,1)='B' ";
	 }
	 if(xMethod=="E" )
	{
	   //RC0036
	   //var strSql  = " SELECT SUBSTR(RBK,1,6) AS RBK,RAMT,(SELECT FLD006 FROM BANKFEE WHERE FLD003 <= RAMT AND FLD004 >= RAMT) AS FEE,RIGHT('00000000000000'||TRIM(RACCT),14) AS RACCT,RNAME,SUBSTR(RMTDT,1,3)||'/'||SUBSTR(RMTDT,4,2)||'/'||SUBSTR(RMTDT,6,2) AS RMTDT, ";
	   var strSql  = " SELECT SUBSTR(RBK,1,6) AS RBK,RAMT,(SELECT CASE WHEN SUBSTR(RBK,1,3) = SUBSTR(PBK,1,3) THEN 0 ELSE FLD006 END FROM BANKFEE WHERE FLD003 <= RAMT AND FLD004 >= RAMT) AS FEE,RIGHT('00000000000000'||TRIM(RACCT),14) AS RACCT,RNAME,SUBSTR(RMTDT,1,3)||'/'||SUBSTR(RMTDT,4,2)||'/'||SUBSTR(RMTDT,6,2) AS RMTDT, ";
	       strSql += " '全球人壽' AS NOTE ";
	       strSql += " FROM CAPRMTF A ";
	       strSql += " LEFT OUTER JOIN USER C ON A.ENTRYUSR = C.USRID";
	       strSql += " JOIN (SELECT DISTINCT PBATNO , PDISPATCH FROM CAPPAYF) D ON D.PBATNO = A.BATNO   ";
	       strSql += " WHERE 1=1 ";
	       strSql += "   AND SUBSTR(BATNO,1,1)='E' ";
	 }      
	       
	if (document.frmMain.para_PBATNO.value != "") {
		strSql += " AND A.BATNO = '" + document.frmMain.para_PBATNO.value + "' ";
	}

	strSql +=" order by A.seqno"; 

	document.getElementById("ReportSQL").value = strSql;
	
}

//匯豐報表
function getReportInfoC()
{
	var strSql = "SELECT A.PNO, A.PCRDNO,A.PCRDEFFMY,A.PCSHDT,A.PAMT,A.PAUTHCODE,A.POLICYNO,A.PAUTHDT,A.PCRDTYPE,A.PBATNO,B.BKNM";
	strSql += " ,A.PORGAMT, A.PORGCRDNO"; //R80300
	strSql += " FROM CAPPAYF A ";
	strSql += " LEFT OUTER JOIN CAPCCBF B ON A.PBBANK = B.BKNO";
	strSql += " where A.PAUTHDT < 970501 AND PSTATUS<>'C' "; //R80300  匯豐

	//銀行帳號
	if (document.frmMain.para_PBATNO.value != "")
	{
		strSql += " AND A.PBATNO = '" + document.frmMain.para_PBATNO.value + "' ";
	}

	document.getElementById("ReportSQL").value = strSql;
}

//R80300 台新退貨憑證
function getReportInfoC812()
{
	var strSql3 = "SELECT A.PNO, A.PCRDNO,A.PCRDEFFMY,A.PCSHDT,A.PAMT,A.PAUTHCODE,A.POLICYNO,A.PAUTHDT,A.PCRDTYPE,A.PBATNO";
	strSql3 += " ,A.PORGAMT ";
	strSql3 += " ,(SELECT SUM(PAMT) FROM CAPPAYF  WHERE PBATNO ='" +  document.frmMain.para_PBATNO.value + "' AND PAUTHDT >= 970501 AND PSTATUS<>'C' ) AS SUMAMT";
	//R00565  台新退貨憑證改版
	strSql3 += " ,(SELECT COUNT(*) FROM CAPPAYF  WHERE PBATNO ='" +  document.frmMain.para_PBATNO.value + "' AND PAUTHDT >= 970501 AND PSTATUS<>'C' AND (PORGAMT=0 or (PORGAMT>0 and PORGAMT=PAMT))) AS SS01";
	//R00565  台新退貨憑證改版
	strSql3 += " ,(SELECT COUNT(*) FROM CAPPAYF  WHERE PBATNO ='" +  document.frmMain.para_PBATNO.value + "' AND PAUTHDT >= 970501 AND PSTATUS<>'C' AND PORGAMT>0 AND PORGAMT<>PAMT) AS SS02";
	strSql3 += " FROM CAPPAYF A ";
	strSql3 += " where A.PAUTHDT >= 970501 AND PSTATUS<>'C' ";
	strSql3 += " AND A.PBATNO = '" + document.frmMain.para_PBATNO.value + "' ";

	document.frmMain3.ReportSQL.value = strSql3;
	document.frmMain3.para_PBATNO.value = document.frmMain.para_PBATNO.value;
}

//R80300 信用卡FIN留存報表
function getReportInfoC_FIN(strBank)
{
	var strSql4 = "SELECT A.PNO, A.PCRDNO,A.PCRDEFFMY,A.PCSHDT,A.PAMT,A.PAUTHCODE,A.POLICYNO,A.PAUTHDT,A.PCRDTYPE,A.PBATNO,B.BKNM";
	strSql4 += " ,A.PORGAMT, A.PORGCRDNO, '" + strBank +"' AS BANKNO";
	strSql4 += " FROM CAPPAYF A ";
	strSql4 += " LEFT OUTER JOIN CAPCCBF B ON A.PBBANK = B.BKNO";
	strSql4 += " where PSTATUS<>'C' ";
	strSql4 += " AND A.PBATNO = '" + document.frmMain.para_PBATNO.value + "' ";

	if (strBank == "812") {
		strSql4 += " AND A.PAUTHDT >= 970501 ";
	} else {
		strSql4 += " AND A.PAUTHDT < 970501 ";
	}

	document.frmMain4.ReportSQL.value = strSql4;
	document.frmMain4.para_PBATNO.value = document.frmMain.para_PBATNO.value ;
}

//R80300 信用卡拒絕報表
function getReportInfoC_FAIL()
{
	var strSql5 = "SELECT A.PNO, A.PCRDNO,A.PCRDEFFMY,A.PCSHDT,A.PAMT,A.PAUTHCODE,A.POLICYNO,A.PAUTHDT,A.PCRDTYPE,A.PBATNO,B.BKNM";
	strSql5 += " ,A.PORGAMT, A.PORGCRDNO, A.PCFMUSR1";
	strSql5 += " FROM CAPPAYF A ";
	strSql5 += " LEFT OUTER JOIN CAPCCBF B ON A.PBBANK = B.BKNO";
	strSql5 += " where PSTATUS = 'C' ";
	strSql5 += " AND A.PBATNO = '" + document.frmMain.para_PBATNO.value + "' ";

	document.frmMain5.ReportSQL.value = strSql5;
	document.frmMain5.para_PBATNO.value = document.frmMain.para_PBATNO.value ;
}

//R60550外幣報表
function getReportInfoD()
{
	var batno = document.frmMain.para_PBATNO.value;
	var rBank = batno.substring( 8, 11 );
	//alert("rBank是" + rBank);
	var strSql1 = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,UPPER(A.RNAME) AS RNAME,A.RPAYCURR as RPCURR2,";
	//RD0144,修改萬泰人民幣CNY為CNH
	if(rBank == "809"){
		strSql1 += "CASE WHEN SUBSTR(A.PBK,1,3)='809' AND TRIM(A.RPCURR)='CN' THEN TRIM(A.RPCURR) ||'H' ELSE G.FLD0004 END RPCURR,";
		strSql1 += "CASE WHEN SUBSTR(A.PBK,1,3)='809' AND TRIM(A.RPCURR)='CN' THEN TRIM(A.RPCURR) ||'H' ELSE G.FLD0004 END RPAYCURR,";
	}else{
		strSql1 += "F.FLD0004 as RPAYCURR,";
	}
	
	strSql1 += "H.FLD0004 as RPCURRDesc,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
//QC0274	strSql1 += ",A.RBKCITY,A.RBKBRCH,A.RENGNAME,C.DEPT,A.SEQNO,D.PDISPATCH,S.BANK_NAME AS SWBKNAME,A.RBENFEE";//R70088新增RBENFEE
//QC0274	
    strSql1 += ",A.RBKCITY,A.RBKBRCH,UPPER(A.RENGNAME) AS RENGNAME,C.DEPT,A.SEQNO,D.PDISPATCH,S.BANK_NAME AS SWBKNAME,A.RBENFEE";//R70088新增RBENFEE
	strSql1 += ",A.RPCURR as RCURR2,";
	//RD0144,修改萬泰人民幣CNY為CNH
	if(rBank == "809"){
		strSql1 += "CASE WHEN SUBSTR(A.PBK,1,3)='809' AND TRIM(A.RPCURR)='CN' THEN TRIM(A.RPCURR) ||'H' ELSE G.FLD0004 END RPCURR,";
	}else{
		strSql1 += "G.FLD0004 as RPCURR,";
	}
	strSql1 += "I.FLD0004 as RCURRDesc,B.BKNM AS PBKNM,E.BKNM AS RBKNM "; //R80338         
	strSql1 += " from CAPRMTF A ";
	strSql1 += " LEFT OUTER JOIN USER C ON A.ENTRYUSR = C.USRID ";
	strSql1 += " LEFT OUTER JOIN (SELECT  DISTINCT PBATNO,pdispatch FROM CAPPAYF) d on d.PBATNO=a.batno";
	//strSql1 += " left outer join ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE";  //RA0074
	strSql1 += " left outer join ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE AND SUBSTR(A.PBK,1,3) = S.BANK_NO";  //RD0144
	strSql1 += " LEFT OUTER JOIN CAPCCBF B on A.PBK = B.BKNO";	//R80338
	strSql1 += " LEFT OUTER JOIN CAPCCBF E on A.RBK = E.BKNO";	//R00386
	strSql1 += " LEFT OUTER JOIN ORDUET F on F.FLD0001='  ' and F.FLD0002='CURRA' and F.FLD0003=A.RPAYCURR ";
	strSql1 += " LEFT OUTER JOIN ORDUET G on G.FLD0001='  ' and G.FLD0002='CURRA' and G.FLD0003=A.RPCURR ";
	strSql1 += " LEFT OUTER JOIN ORDUET H on H.FLD0001='  ' and H.FLD0002='CURRN' and H.FLD0003=A.RPAYCURR ";
	strSql1 += " LEFT OUTER JOIN ORDUET I on I.FLD0001='  ' and I.FLD0002='CURRN' and I.FLD0003=A.RPCURR ";
	strSql1 += " WHERE 1=1";

	if (document.frmMain.para_PBATNO.value != "") {
		strSql1 += " AND A.BATNO = '" + document.frmMain.para_PBATNO.value + "' ";
	}

	strSql1 +=" ORDER BY A.BATNO,A.RACCT,A.RENGNAME,A.RPAYCURR";
	document.frmMain1.ReportSQL.value = strSql1;
	document.frmMain1.para_BATNO.value = document.frmMain.para_PBATNO.value;
	

	//R70088新增總表
	//QC0274var strSql2   = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,A.RNAME,A.RPAYCURR as RPCURR2, F.FLD0004 as RPAYCURR, H.FLD0004 as RPCURRDesc,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
	//QC0274	strSql2 += " ,A.RBKCITY,A.RBKBRCH,A.RENGNAME,A.SEQNO,A.RBENFEE,A.RPAYRATE,A.RAMT,B.DEPT";	
	var strSql2   = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,UPPER(A.RNAME) AS RNAME,A.RPAYCURR as RPCURR2,";
	//RD0144,修改萬泰人民幣CNY為CNH
	if(rBank == "809"){
		strSql2 += "CASE WHEN SUBSTR(A.PBK,1,3)='809' AND TRIM(A.RPCURR)='CN' THEN TRIM(A.RPCURR) ||'H' ELSE G.FLD0004 END RPAYCURR,";
	}else{
		strSql2 += "F.FLD0004 as RPAYCURR,";
	}
	strSql2 += "H.FLD0004 as RPCURRDesc,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
	strSql2 += " ,A.RBKCITY,A.RBKBRCH,UPPER(A.RENGNAME) AS RENGNAME,A.SEQNO,A.RBENFEE,A.RPAYRATE,A.RAMT,B.DEPT";
	strSql2 += ",A.RPCURR as RCURR2,";
	//RD0144,修改萬泰人民幣CNY為CNH
	if(rBank == "809"){
		strSql2 += "CASE WHEN SUBSTR(A.PBK,1,3)='809' AND TRIM(A.RPCURR)='CN' THEN TRIM(A.RPCURR) ||'H' ELSE G.FLD0004 END RPCURR,";
	}else{
		strSql2 += "G.FLD0004 as RPCURR,";
	}
	strSql2 += "I.FLD0004 as RCURRDesc,C.BKNM AS PBKNM,D.BKNM AS RBKNM "; //R80338
	strSql2 += " from CAPRMTF A ";
	strSql2 += " LEFT OUTER JOIN USER B ON A.ENTRYUSR = B.USRID";
	strSql2 += " LEFT OUTER JOIN CAPCCBF C on A.PBK = C.BKNO";	//R80338
	strSql2 += " LEFT OUTER JOIN CAPCCBF D on A.RBK = D.BKNO";	//R80338
	strSql2 += " LEFT OUTER JOIN ORDUET F on F.FLD0001='  ' and F.FLD0002='CURRA' and F.FLD0003=A.RPAYCURR ";
	strSql2 += " LEFT OUTER JOIN ORDUET G on G.FLD0001='  ' and G.FLD0002='CURRA' and G.FLD0003=A.RPCURR ";
	strSql2 += " LEFT OUTER JOIN ORDUET H on H.FLD0001='  ' and H.FLD0002='CURRN' and H.FLD0003=A.RPAYCURR ";
	strSql2 += " LEFT OUTER JOIN ORDUET I on I.FLD0001='  ' and I.FLD0002='CURRN' and I.FLD0003=A.RPCURR ";
	strSql2 += " WHERE 1=1";

	if (document.frmMain.para_PBATNO.value != "") {
		strSql2 += " AND A.BATNO = '" + document.frmMain.para_PBATNO.value + "' ";
	}

	strSql2 +=" ORDER BY A.BATNO,A.RACCT,A.RENGNAME,A.RPAYCURR";

	document.frmMain2.ReportSQL.value = strSql2;
	document.frmMain2.para_BATNO.value = document.frmMain.para_PBATNO.value;
}

// R70477 花旗拆同行相轉與非同行相轉
function getReportInfoD021_1()
{
//QC0274
//	var strSql021_1 = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,A.RNAME,A.RPAYCURR,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
//	strSql021_1 += " ,A.RBKCITY,A.RBKBRCH,A.RENGNAME,C.DEPT,A.SEQNO,D.PDISPATCH,S.BANK_NAME AS SWBKNAME,A.RBENFEE";
	var strSql021_1 = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,UPPER(A.RNAME) AS RNAME,A.RPAYCURR,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
	strSql021_1 += " ,A.RBKCITY,A.RBKBRCH,UPPER(A.RENGNAME) AS RENGNAME,C.DEPT,A.SEQNO,D.PDISPATCH,S.BANK_NAME AS SWBKNAME,A.RBENFEE";
	strSql021_1 += ",A.RPCURR,B.BKNM AS PBKNM,E.BKNM AS RBKNM "; //R80338           
	strSql021_1 += " from CAPRMTF A LEFT OUTER JOIN USER C ON A.ENTRYUSR = C.USRID ";
	strSql021_1 += " LEFT OUTER JOIN (SELECT  DISTINCT PBATNO,pdispatch FROM CAPPAYF) d on d.PBATNO=a.batno";
	strSql021_1 += " left outer join ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE";
	strSql021_1 += " LEFT OUTER JOIN CAPCCBF B on A.PBK = B.BKNO";	//R80338  
	strSql021_1 += " LEFT OUTER JOIN CAPCCBF E on A.RBK = E.BKNO";	//R00386
	strSql021_1 += " WHERE SUBSTR(A.RBKSWIFT,1,4) = 'CITI' ";

	if (document.frmMain.para_PBATNO.value != "") {
		strSql021_1 += " AND A.BATNO = '" + document.frmMain.para_PBATNO.value + "' ";
	}

	strSql021_1 +=" ORDER BY A.BATNO,A.RACCT,A.RENGNAME,A.RPAYCURR";

	document.frmMain1.ReportSQL.value = strSql021_1;
	document.frmMain1.para_BATNO.value = document.frmMain.para_PBATNO.value ;	
}

// R70477 花旗拆同行相轉與非同行相轉
function getReportInfoD021_2()
{
//QC0274
//	var strSql021_2 = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,A.RNAME,A.RPAYCURR,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
//	strSql021_2 += ",A.RBKCITY,A.RBKBRCH,A.RENGNAME,C.DEPT,A.SEQNO,D.PDISPATCH,S.BANK_NAME AS SWBKNAME,A.RBENFEE";
	var strSql021_2 = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,UPPER(A.RNAME) AS RNAME,A.RPAYCURR,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
	strSql021_2 += ",A.RBKCITY,A.RBKBRCH,UPPER(A.RENGNAME) AS RENGNAME,C.DEPT,A.SEQNO,D.PDISPATCH,S.BANK_NAME AS SWBKNAME,A.RBENFEE";
	strSql021_2 += ",A.RPCURR,B.BKNM AS PBKNM,E.BKNM AS RBKNM "; //R80338
	strSql021_2 += " from CAPRMTF A LEFT OUTER JOIN USER C ON A.ENTRYUSR = C.USRID ";
	strSql021_2 += " LEFT OUTER JOIN (SELECT  DISTINCT PBATNO,pdispatch FROM CAPPAYF) d on d.PBATNO=a.batno";
	strSql021_2 += " left outer join ORCHSWFT S ON A.RBKSWIFT = S.SWIFT_CODE";
	strSql021_2 += " LEFT OUTER JOIN CAPCCBF B on A.PBK = B.BKNO";	//R80338
	strSql021_2 += " LEFT OUTER JOIN CAPCCBF E on A.RBK = E.BKNO";	//R00386         
	strSql021_2 += " WHERE SUBSTR(A.RBKSWIFT,1,4) <> 'CITI' ";

	if (document.frmMain.para_PBATNO.value != "") {
		strSql021_2 += " AND A.BATNO = '" + document.frmMain.para_PBATNO.value + "' ";
	}

  	strSql021_2 +=" ORDER BY A.BATNO,A.RACCT,A.RENGNAME,A.RPAYCURR";

	document.frmMain1.ReportSQL.value = strSql021_2;
	document.frmMain1.para_BATNO.value = document.frmMain.para_PBATNO.value ;	
}

 // R70477 花旗拆同行相轉與非同行相轉
function getReportInfoD021_3()
{
	//總表
//QC0274
//	var strSql021_3   = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,A.RNAME,A.RPAYCURR,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
//	strSql021_3 += " ,A.RBKCITY,A.RBKBRCH,A.RENGNAME,A.SEQNO,A.RBENFEE,A.RPAYRATE,A.RAMT,B.DEPT";
	var strSql021_3   = "SELECT A.PBK,A.PACCT,A.RMTDT,A.RACCT,UPPER(A.RNAME) AS RNAME ,A.RPAYCURR,A.RPAYAMT,A.RPAYFEEWAY,A.RMTFEE,A.BATNO,A.RBKSWIFT,A.RBKCOUNTRY";
	strSql021_3 += " ,A.RBKCITY,A.RBKBRCH,UPPER(A.RENGNAME) AS RENGNAME,A.SEQNO,A.RBENFEE,A.RPAYRATE,A.RAMT,B.DEPT";
	strSql021_3 += ",A.RPCURR,C.BKNM AS PBKNM "; //R00386
	strSql021_3 += " from CAPRMTF A ";
	strSql021_3 += " LEFT OUTER JOIN USER B ON A.ENTRYUSR = B.USRID";
	strSql021_3 += " LEFT OUTER JOIN CAPCCBF C on A.PBK = C.BKNO";	//R80338
	strSql021_3 += " WHERE 1=1";

	if (document.frmMain.para_PBATNO.value != "") {
		strSql021_3 += " AND A.BATNO = '" + document.frmMain.para_PBATNO.value + "' ";
	}

  	strSql021_3 +=" ORDER BY A.BATNO,A.RACCT,A.RENGNAME,A.RPAYCURR";

	document.frmMain2.ReportSQL.value = strSql021_3;
	document.frmMain2.para_BATNO.value = document.frmMain.para_PBATNO.value ;
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	history.back();
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM	id="frmMain" name="frmMain" method="post" action="">
<TABLE border="1" width="759" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="174">請選擇報表格式：</TD>
			<TD colspan="4" width="584">
				<input type="radio" name="rdReportForm" id="rdReportForm" Value="PDF" class="Data" checked>PDF 
				<input type="radio" name="rdReportForm" id="rdReportForm" Value="RPT" class="Data">RPT
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="174">匯款批號：</TD>
			<TD colspan="4" width="584"><INPUT class="Data" size="23" type="text" maxlength="11" id="para_PBATNO" name="para_PBATNO" value=""></TD>
		</TR>
		<!--R80300信用卡新增報表-->
		<TR id="selCredit" style="display: none">
			<TD align="left" class="TableHeading" width="174">信用卡報表：</TD>
			<TD><INPUT type="checkbox" id="chkRPT" name="chkRPT" value="HSBC"
				checked>匯豐信用卡報表</TD>
			<TD><INPUT type="checkbox" id="chkRPT" name="chkRPT" value="CICI"
				checked>台新退貨憑證</TD>
			<TD><INPUT type="checkbox" id="chkRPT" name="chkRPT" value="CICIFIN"
				checked>信用卡退貨報表-FIN</TD>
			<TD><INPUT type="checkbox" id="chkRPT" name="chkRPT" value="REJT"
				>信用卡拒絕報表</TD>
		</TR>
	</TBODY>
</TABLE>
<BR>

<TABLE border="0" cellpadding="0" cellspacing="0" width="300" id="inqueryArea1">
	<TR>
		<TD bgcolor="#c0c0c0"
			style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;BORDER-RIGHT: black 1px solid"
			height="25" width="50" align="right"><B><FONT size="2" face="細明體">序號</FONT></B></TD>
		<TD bgcolor="#c0c0c0"
			style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;BORDER-RIGHT: black 1px solid"
			height="25"><B><FONT size="2" face="細明體">&nbsp;&nbsp;匯款批號</FONT></B></TD>
		<TD bgcolor="#c0c0c0"
			style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;BORDER-RIGHT: black 1px solid"
			height="25"><B><FONT size="2" face="細明體">&nbsp;&nbsp;幣別</FONT></B></TD>
	</TR>
<%
	String strBATNO = "";//R60550
  	String strPCURR = "";//R60550
	if (vo != null) {
		if(vo.size()>0) {
			for (int index = 0 ; index < vo.size() ;index++) {
				DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)vo.get(index);
				//R60550
				if (objPDetailVO.getStrBatNo()!=null)
					strBATNO = objPDetailVO.getStrBatNo().trim();
				//保單幣別
				if (objPDetailVO.getStrPCurr()!=null)
					strPCURR = objPDetailVO.getStrPCurr().trim();
%>
	<TR>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;BORDER-RIGHT: black 1px solid"
			height="30" width="50"  align="right"><%=index+1%>&nbsp;</TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;BORDER-RIGHT: black 1px solid"
			height="30"><input type="radio" name="BATNOs" value="點選" onClick="selectBatNo('<%=strBATNO%>','<%=strPCURR%>');"><%=strBATNO%></TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;BORDER-RIGHT: black 1px solid" height="30"><%=objPDetailVO.getStrPCurr()%></TD>
	</TR>
<%			} // for
		} //alPDetail.size()>0
	} //alPDetail != null %>
</TABLE>
<!--R70088下載檔案改變-->
<BR>
<TABLE border="0" cellpadding="0" cellspacing="0" width="470" id="downReturnArea">
	<TR>
		<TD bgcolor="#c0c0c0" colspan="2" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="25">
			<B><FONT size="2" face="細明體">產生檔案如下:</FONT><BR>
			<FONT color="red" size="2" >請按右鍵"另存目標",即另存新檔。<br>
<%
	String xlsFileExist = (String)request.getAttribute( "xlsFileExist" );
	String bankCode = (String)request.getAttribute( "downloadBankCode" );
	String bankName = (String)request.getAttribute( "downloadBankName" );
	if( xlsFileExist != null && xlsFileExist.equalsIgnoreCase( "Y" ) )
		out.println( bankName + bankCode + "&nbsp;為EXCEL檔,請修改存檔類型為所有檔案並修改副檔名.XLS" );
%>
			 </FONT></B>
			</TD>
	</TR>
<% 
	String strFILELOC = "";
	String strFILEURL="";
	if (downfile != null) {
		if(downfile.size()>0){		     
			for (int index = 0 ; index < downfile.size() ;index++) {
				strFILELOC = (String) downfile.get(index);
				strFILEURL= request.getContextPath()+ strFILELOC;
%>
	<TR>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid"
			height="30" width="50" align="right"><%=index+1%>&nbsp;</TD>
		<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid"
			height="30" width="402"><a href=<%=strFILEURL%> target="_blank"><%=strFILELOC.substring(19)%></a></TD>
	</TR>
<%			} // for
		} //alPDetail.size()>0
	} //alPDetail != null %>
</TABLE>

<INPUT type="hidden" id="ReportName" name="ReportName"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">

<INPUT type="hidden" name="txtAction" id="txtAction" value="<%=strAction%>">
<INPUT type="hidden" name="txtMsg" id="txtMsg" value="<%=strReturnMessage%>">

<INPUT type="hidden" name="para_PoCURR" id="para_PoCURR" value="">
</FORM>
<!--R60550新增外幣報表-->
<FORM id="frmMain1" name="frmMain1" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitExportD.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="para_BATNO" name="para_BATNO" value="">
</FORM>
<!--R70088外幣匯款總表-->
<FORM id="frmMain2" name="frmMain2" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitExportDTot.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="para_BATNO" name="para_BATNO" value="">
</FORM>
<!--R80300台新退貨憑證-->
<FORM id="frmMain3" name="frmMain3" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitExportC812.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" name="para_PBATNO" id="para_PBATNO" value="">
<INPUT type="hidden" name="para_CapsilDate" id="para_CapsilDate" value="<%=strCapsil%>">
</FORM>
<!--R80300信用卡退貨報表FIN-->
<FORM id="frmMain4" name="frmMain4" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitExportC_FIN.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="para_PBATNO" name="para_PBATNO" value="">
</FORM>
<!--R80300信用卡拒絕報表-->
<FORM id="frmMain5" name="frmMain5" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitExportC_Fail.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="para_PBATNO" name="para_PBATNO" value="">
</FORM>
<!-- R00386 一銀匯款轉帳申請書 -->
<FORM id="frmMain6" name="frmMain6" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitFcbForm2.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
<INPUT type="hidden" id="ReportPath" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBRemit\\"> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="para_companyCName" name="para_companyCName" value="全球人壽保險(股)公司">
<INPUT type="hidden" id="para_companyEName" name="para_companyEName" value="TransGlobe Life Insurance Inc.">
<INPUT type="hidden" id="para_cashConfirmDate" name="para_cashConfirmDate" value="">
</FORM>

<FORM id="frmMain7" name="frmMain7" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitFcbForm1.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
<INPUT type="hidden" id="ReportPath" type="hidden" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBRemit\\"> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
<INPUT type="hidden" id="para_companyCName" name="para_companyCName" value="全球人壽保險(股)公司">
<INPUT type="hidden" id="para_companyEName" name="para_companyEName" value="TransGlobe Life Insurance Inc.">
<INPUT type="hidden" id="para_cashConfirmDate" name="para_cashConfirmDate" value="">
</FORM>
<!-- RB0089 彰銀媒體遞送單  -->
<FORM id="frmMain8" name="frmMain8" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportCHBMediaDelivery">
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitCHBForm.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBRemitCHBForm.pdf"> 
<INPUT type="hidden" id="ReportPath" type="hidden" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBRemit\\"> 
<INPUT type="hidden" id="para_batchno" name="para_batchno" value="">
</FORM>
</BODY>
</HTML>