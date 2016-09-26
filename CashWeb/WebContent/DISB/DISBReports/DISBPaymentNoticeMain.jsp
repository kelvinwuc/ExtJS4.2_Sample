<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.aegon.disb.disbreports.CAPPAYReportVO"%>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : 給付通知書
 * 
 * Remark   : 修改/報表
 * 
 * Revision : $Revision: 1.17 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : 2005/04/04
 * 
 * Request ID  : R30530
 * 
 * CVS History:
 * 
 * $Log: DISBPaymentNoticeMain.jsp,v $
 * Revision 1.17  2014/02/26 07:16:11  misariel
 * EB0536-BC264 沛利多利率變動型養老保險SIE
 *
 * Revision 1.16  2013/12/27 03:42:50  MISSALLY
 * EB0194-PB0016---新增可修改給付通知書的收件人
 *
 * Revision 1.15  2013/12/06 02:52:55  MISSALLY
 * EB0194-PB0016-BC255利率變動型即期年金保險專案-BUGFix
 *
 * Revision 1.14  2013/11/08 05:52:33  MISSALLY
 * EB0194-PB0016-BC255利率變動型即期年金保險專案
 *
 * Revision 1.13  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 * Revision 1.12  2013/03/12 02:31:54  ODCWilliam
 * Revision 1.11  2013/03/11 08:53:43  ODCWilliam
 * Revision 1.10  2013/02/26 10:20:20  ODCWilliam
 * william wu
 * RA0074
 *
 * Revision 1.9  2011/08/09 08:12:52  MISSALLY
 * Q10180　修正給付通知書
 *
 * Revision 1.8  2011/07/06 11:45:44  MISSALLY
 * Q10180
 * 增加給付通知書檢核功能
 *
 * Revision 1.7  2010/11/23 02:51:38  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.6  2009/11/11 06:08:57  missteven
 * R90474 修改CASH功能
 *
 * Revision 1.5  2007/04/20 02:25:13  MISODIN
 * R60713 FOR AWD
 *
 * Revision 1.4  2007/01/08 01:50:29  MISVANESSA
 * R60550_抓取方式修改
 *
 * Revision 1.3  2007/01/04 03:30:53  MISVANESSA
 * R60550_抓取方式修改
 *
 * Revision 1.2  2006/12/05 10:19:45  MISVANESSA
 * R60550_配合SPUL&外幣付款修改
 *
 * Revision 1.1  2006/06/29 09:40:42  MISangel
 * Init Project
 *
 * Revision 1.1.2.11  2006/04/27 09:47:31  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.10  2005/11/14 06:09:22  misangel
 * R50820:支付功能提升
 *
 * Revision 1.1.2.7  2005/04/20 03:31:57  miselsa
 * R30530_支付通知書
 *
 * Revision 1.1.2.6  2005/04/12 10:08:05  miselsa
 * R30530_支付通知書
 *
 * Revision 1.1.2.5  2005/04/12 07:49:43  miselsa
 * R30530_支付通知書
 *
 * Revision 1.1.2.4  2005/04/04 07:02:20  miselsa
 * R30530 支付系統
 *  
 */
%><%!
String strThisProgId = "DISBPaymentNotice"; //本程式代號
DecimalFormat df = new DecimalFormat("#.00");
%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String strReturnMessage = (request.getAttribute("txtMsg") != null) ? (String) request.getAttribute("txtMsg") : "";

CAPPAYReportVO vo = (CAPPAYReportVO) request.getAttribute("notice");
%>
<HTML>
<HEAD>
<TITLE>給付通知書</TITLE>
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
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;

	if(document.getElementById("AMT1").value == "0.0" && document.getElementById("AMT2").value == "0.0")
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeySourceU,'' ) ;
	}
	else
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyNotice,'' ) ;
	}
	document.getElementById("updateArea").style.display = "block";
	backHistory();
}

function backHistory()
{
	<%if (vo == null) {
	out.print("history.back();");
	}%>
}

/*
函數名稱:	updateAction()
函數功能:	當toolbar frame 中之修改按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function updateAction()
{
	if(checkFields())
	{
		getRecevier();
		document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=update";
		document.frmMain.submit();
	}
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
	history.back();
}

function printRAction()
{
	if(checkFields())
	{
		getRecevier();
		document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=update";
		document.frmMain.submit();

		getReportInfo();
		// R61050
		if(document.frmMain.rdReportForm[0].checked)
		{
			document.frmMain.ReportName.value = "DISBPaymentNotice.rpt";
		}
		else
		{
			document.frmMain.ReportName.value ="DISBPaymentNoticeAWD.rpt";
		}
		document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";
		document.getElementById("frmMain").target="_blank";
		document.frmMain.submit();
	}
}

function checkFields()
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	var itemchecked = false;
	var PAMT= parseFloat(document.getElementById("PAMT").value) ;//R60550parseInt(document.getElementById("PAMT").value,10) ;
	//r60550var AMT= parseInt(document.getElementById("AMT1").value,10) - parseInt(document.getElementById("AMT2").value,10) ;
	var AMT= parseFloat(document.getElementById("AMT1").value) - parseFloat(document.getElementById("AMT2").value) ;

	for (var i=0;i<7;i++)
	{
	     if(document.frmMain.ITEM[i].checked)
	     {
	     	itemchecked = true;
	     	break;
	     }
	}
	if(!itemchecked)
	{
	    strTmpMsg =strTmpMsg + "需選擇給付項目!!\n\r";
		bReturnStatus = false;
	}
	if(PAMT > AMT || PAMT < AMT)
	{
	    strTmpMsg =strTmpMsg + "付款金額與實付金額不符!!\n\r";
		bReturnStatus = false;
	}
	if(AMT == 0)
	{
		strTmpMsg =strTmpMsg + "付款明細未輸入!!\n\r";
		bReturnStatus = false;
	}

	if( !bReturnStatus )
	{
			alert( strTmpMsg );
	}
	return bReturnStatus;
}

function getAAmount()
{
	document.getElementById("AMT1").value = (parseFloat(document.getElementById("DEFAMT").value)
												+ parseFloat(document.getElementById("DIVAMT").value)
												+ parseFloat(document.getElementById("LOAN").value)
												+ parseFloat(document.getElementById("UNPRDPRM").value)
												+ parseFloat(document.getElementById("REVPRM").value)
												+ parseFloat(document.getElementById("CURPRM").value)
												+ parseFloat(document.getElementById("OVRRTN").value)
												+ parseFloat(document.getElementById("PEAMT").value)
												+ parseFloat(document.getElementById("ANNAMT").value)).toFixed(2);
}

function getMAmount()
{
	document.getElementById("AMT2").value = (parseFloat(document.getElementById("LANCAP").value)
												+ parseFloat(document.getElementById("LANINT").value)
												+ parseFloat(document.getElementById("APL").value)
												+ parseFloat(document.getElementById("APLINT").value)
												+ parseFloat(document.getElementById("OFFAMT").value)
												+ parseFloat(document.getElementById("OFFAMT1").value)  //R90474
												+ parseFloat(document.getElementById("OFFAMT2").value)  //R90474
												+ parseFloat(document.getElementById("OFFAMT3").value)).toFixed(2);	//R90474
}

function getReportInfo()
{
	var strSql = "SELECT a.*,b.PMETHOD,b.PAMT,b.PCHECKNO,b.PCRDNO,b.PRBANK,b.PRACCOUNT, c.CUSEDT,d.BKFNM,";
    strSql += "IFNULL(ph.FLD0154,'') as DIVTYPE,"; //EB0536
    strSql += "d.BKNM,b.ENTRYUSR,b.UPDUSR,b.PCURR as POCURR,trim(g.FLD0004) as PCURR,b.PPAYCURR as PAYCURR,trim(h.FLD0004) as PPAYCURR,b.PPAYAMT,e.BANK_NAME as SWBKNAME,FSFUCO,b.PFEEWAY";//r60550
    strSql += " FROM CAPPAYRF a ";
    strSql += " LEFT OUTER JOIN CAPPAYF  b on b.PNO = a.PNO";  
    strSql += " LEFT OUTER JOIN CAPCHKF  c ON b.PCHECKNO = c.CNO";  
    strSql += " LEFT OUTER JOIN CAPCCBF  d ON d.BKNO = b.PRBANK" ;
    strSql += " LEFT OUTER JOIN ORCHSWFT e ON b.PSWIFT = e.SWIFT_CODE" ;//R60550
    strSql += " LEFT OUTER JOIN SSEGFS   f ON b.POLICYNO = f.FSPONU AND f.FSCOCO = '' AND b.PCURR = f.FSCURR AND f.FSCONU = 1 AND f.FSFUCO = 'SVSA'  ";//R90474
    strSql += " LEFT OUTER JOIN ORDUET   g ON g.FLD0001='  ' and g.FLD0002='CURRA' and g.FLD0003=b.PCURR ";
    strSql += " LEFT OUTER JOIN ORDUET   h ON h.FLD0001='  ' and h.FLD0002='CURRA' and h.FLD0003=b.PPAYCURR ";
    strSql += " LEFT OUTER JOIN ORDUPO PO ON PO.FLD0001='  ' AND PO.FLD0002 = b.POLICYNO "; //EB0536
    strSql += " LEFT OUTER JOIN ORDUPH ph ON ph.FLD0001='  ' AND ph.FLD0002= PO.FLD0015 AND ph.FLD0003=PO.FLD0016 "; //EB0536
    
	if (document.getElementById("para_PNO").value != "" )
	{
		strSql +=" WHERE a.PNO = '" + document.getElementById("para_PNO").value +"'" ;
	}

	document.getElementById("ReportSQL").value = strSql;
}

function changeReceiver(action)
{
	if(action == "T") {
		document.getElementById("selRecevier").disabled = false;
		var myselect=document.getElementById("selRecevier");
		myselect.options[0].selected = false;
		myselect.options[1].selected = false;
		myselect.options[2].selected = true;
	} else {
		document.getElementById("selRecevier").disabled = true;
		var myselect=document.getElementById("selRecevier");
		myselect.options[0].selected = true;
		myselect.options[1].selected = false;
		myselect.options[2].selected = false;
	}
}

function getRecevier() {
	var myselect=document.getElementById("selRecevier");
	for(var i=0; i<myselect.length; i++) {
		if(myselect.options[i].selected == true) {
			document.getElementById("RECEIVER").value = myselect.options[i].value;
			break;
		}
	}
}
//-->
</script>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">

<form action="" id="frmMain" method="post" name="frmMain">
<%if (vo != null) {
	String SNDNM = "";
	String SHOWCURR = ""; //R60550
	double SHOWAMT = 0; //R60550    
	if (vo.getSNDNM() != null && !vo.getSNDNM().trim().equals("")) {
		SNDNM = vo.getSNDNM().trim();
	} else {
		SNDNM = vo.getAPPNM().replace('　', ' ').trim();
	}
	//R60550 如為外幣繳費,幣別帶付款幣別SHOWCURR取代 vo.getPayment().getPCurr()
	//									SHOWAMT取代 vo.getPayment().getPAMT()
	if ("D".equals(vo.getPayment().getPMethod().trim())) {
		SHOWCURR = vo.getPayment().getPPAYCURR().trim();
		SHOWAMT = vo.getPayment().getPPAYAMT();
	} else {
		SHOWCURR = vo.getPayment().getPCurr().trim();
		SHOWAMT = vo.getPayment().getPAMT();
	}
	SHOWCURR = disbBean.getETableDesc("CURRA", SHOWCURR) + "$";
%>
<TABLE border="1" width="854" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="106">保單號碼：</TD>
			<TD width="241">
				<INPUT class="Data" type="text" id="POLICYNO" name="POLICYNO" size="15" maxlength="11" value="<%=vo.getPOLICYNO()%>" readonly> 
				<input type="hidden" id="para_PNO" name="para_PNO" value="<%=vo.getPNO()%>">
			</TD>
			<TD align="left" class="TableHeading" width="132">支付來源確認日：</TD>
			<TD width="304"><INPUT class="INPUT_DISPLAY" size="21" type="text" maxlength="11" name="PCFMDT1" id="PCFMDT1" value="<%=vo.getPayment().getPCfmDt1()%>" readonly></TD>
		</TR>
	</TBODY>
</TABLE>
<TABLE border="1" width="854" id="updateArea" style="display: none">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="106">要保人：</TD>
			<TD width="241"><INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="APPNM" id="APPNM" value="<%=vo.getAPPNM()%>" readonly></TD>
			<TD align="left" class="TableHeading" width="116">承辦人：</TD>
			<TD width="363">
				<INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="SRVNM" id="SRVNM" value="<%=vo.getUPDUSR().trim()%>" readonly> 
				<input type="hidden" id="para_SRVNM" name="para_SRVNM" value="<%=vo.getUPDUSR().trim()%>">
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">被保險人：</TD>
			<TD width="241"><INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="INSNM" id="INSNM" value="<%=vo.getINSNM()%>" readonly></TD>
			<TD align="left" class="TableHeading" width="116">通訊處：</TD>
			<TD width="363"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="SRVBH" id="SRVBH" value="<%=vo.getSRVBH()%>" readonly></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">收件人：</TD>
			<TD width="241">
				<INPUT type="hidden" name="RECEIVER" id="RECEIVER" value="<%=vo.getRECEIVER()%>">
				<select id="selRecevier" disabled="disabled"><option value="<%=vo.getRECEIVER()%>"><%=vo.getRECEIVER()%></option><option value="<%=vo.getAPPNM()%>"><%=vo.getAPPNM()%></option><option value="<%=vo.getINSNM()%>"><%=vo.getINSNM()%></option></select>
			</TD>
			<TD align="left" class="TableHeading" width="116">服務人員：</TD>
			<TD width="363"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="SRVNM2" id="SRVNM2" value="<%=vo.getSRVNM()%>" readonly></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">住所地址：</TD>
			<TD width="" colspan=3>
				<INPUT class="Data" size="6" type="text" maxlength="5" name="HMZIP" id="HMZIP" value="<%=(String) vo.getHMZIP().trim()%>"> 
				<INPUT class="Data" size="49" type="text" maxlength="35" name="HMAD" id="HMAD" value="<%=(String) vo.getHMAD().trim()%>">
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">郵寄地址：</TD>
			<TD width="" colspan=3>
				<INPUT class="Data" size="6" type="text" maxlength="5" name="MAILZIP" id="MAILZIP" value="<%=(String) vo.getMAILZIP().trim()%>"> 
				<INPUT class="Data" size="49" type="text" maxlength="35" name="MAILAD" id="MAILAD" value="<%=(String) vo.getMAILAD().trim()%>">
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">給付項目：</TD>
			<TD width="" colspan=3>
				<input type="radio" value="A" name="ITEM" id="ITEM" <%if ("A".equals(vo.getITEM())) out.print("checked");%> onclick="changeReceiver('F');" >借款
				<input type="radio" value="B" name="ITEM" id="ITEM" <%if ("B".equals(vo.getITEM())) out.print("checked");%> onclick="changeReceiver('F');" >終止/撤銷 
				<input type="radio" value="C" name="ITEM" id="ITEM" <%if ("C".equals(vo.getITEM())) out.print("checked");%> onclick="changeReceiver('F');" >變更退費 
				<input type="radio" value="D" name="ITEM" id="ITEM" <%if ("D".equals(vo.getITEM())) out.print("checked");%> onclick="changeReceiver('F');" >退還當期保費 
				<input type="radio" value="E" name="ITEM" id="ITEM" <%if ("E".equals(vo.getITEM())) out.print("checked");%> onclick="changeReceiver('F');" >溢繳退費 
				<input type="radio" value="G" name="ITEM" id="ITEM" <%if ("G".equals(vo.getITEM())) out.print("checked");%> onclick="changeReceiver('T');" >年金提前給付
				<input type="radio" value="F" name="ITEM" id="ITEM" <%if ("F".equals(vo.getITEM())) out.print("checked");%> onclick="changeReceiver('F');" >其他
			</TD>
		</TR>
		<TR><TD align="left" class="TableHeading" width="" colspan=4>付款明細說明如下：</TD></TR>
		<TR>
			<TD align="left" class="TableHeading" width="" colspan=2>給付項目：</TD>
			<TD align="left" class="TableHeading" width="" colspan=2>扣款項目：</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">解約退費：<%=SHOWCURR%></TD>
			<TD width="241"><INPUT class="Data" size="17" type="text" maxlength="25" name="DEFAMT" id="DEFAMT" value="<%=df.format(vo.getDEFAMT())%>" onchange="getAAmount();"></TD>
			<TD align="left" class="TableHeading" width="116">借款本金：<%=SHOWCURR%></TD>
			<TD width="363"><INPUT class="Data" size="20" type="text" maxlength="25" name="LANCAP" id="LANCAP" value="<%=df.format(vo.getLANCAP())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106"><%=vo.getDIVDesc()%>：<%=SHOWCURR%></TD>
			<TD width="241"><INPUT class="Data" size="17" type="text" maxlength="25" name="DIVAMT" id="DIVAMT" value="<%=df.format(vo.getDIVAMT())%>" onchange="getAAmount();"></TD>
			<TD align="left" class="TableHeading" width="116">借款利息：<%=SHOWCURR%></TD>
			<TD width="363"><INPUT class="Data" size="20" type="text" maxlength="25" name="LANINT" id="LANINT" value="<%=df.format(vo.getLANINT())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106" height="24">保單借款：<%=SHOWCURR%></TD>
			<TD width="241" height="24"><INPUT class="Data" size="17" type="text" maxlength="25" name="LOAN" id="LOAN" value="<%=df.format(vo.getLOAN())%>" onchange="getAAmount();"></TD>
			<TD align="left" class="TableHeading" width="116" height="24">自動墊繳：<%=SHOWCURR%></TD>
			<TD width="363" height="24"><INPUT class="Data" size="20" type="text" maxlength="25" name="APL" id="APL" value="<%=df.format(vo.getAPL())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">帳戶價值：<%=SHOWCURR%></TD>
			<TD width="241"><INPUT class="Data" size="17" type="text" maxlength="25" name="UNPRDPRM" id="UNPRDPRM" value="<%=df.format(vo.getUNPRDPRM())%>" onchange="getAAmount();"></TD>
			<TD align="left" class="TableHeading" width="116">墊繳利息：<%=SHOWCURR%></TD>
			<TD width="363"><INPUT class="Data" size="20" type="text" maxlength="25" name="APLINT" id="APLINT" value="<%=df.format(vo.getAPLINT())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">撤銷保費：<%=SHOWCURR%></TD>
			<TD width="241"><INPUT class="Data" size="17" type="text" maxlength="25" name="REVPRM" id="REVPRM" value="<%=df.format(vo.getREVPRM())%>" onchange="getAAmount();"></TD>
			<TD align="left" class="TableHeading" width="116"><INPUT class="Data" size="14" type="text" maxlength="15" name="OFFWD" id="OFFWD" value="<%=(String) vo.getOFFWD().trim()%>"></TD>
			<TD width="" colspan=3><INPUT class="Data" size="17" type="text" maxlength="25" name="OFFAMT" id="OFFAMT" value="<%=df.format(vo.getOFFAMT())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">變更退費：<%=SHOWCURR%></TD>
			<TD width=""><INPUT class="Data" size="17" type="text" maxlength="25" name="CURPRM" id="CURPRM" value="<%=df.format(vo.getCURPRM())%>" onchange="getAAmount();"></TD>
			<!--R90474 -->
			<TD align="left" class="TableHeading" width="116"><INPUT class="Data" size="14" type="text" maxlength="15" name="OFFWD1" id="OFFWD1" value="<%=(String) vo.getOFFWD1().trim()%>"></TD>
			<TD width="" colspan=3><INPUT class="Data" size="17" type="text" maxlength="25" name="OFFAMT1" id="OFFAMT1" value="<%=df.format(vo.getOFFAMT1())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">溢繳退費：<%=SHOWCURR%></TD>
			<TD width=""><INPUT class="Data" size="17" type="text" maxlength="25" name="OVRRTN" id="OVRRTN" value="<%=df.format(vo.getOVRRTN())%>" onchange="getAAmount();"></TD>
			<TD align="left" class="TableHeading" width="116"><INPUT class="Data" size="14" type="text" maxlength="15" name="OFFWD2" id="OFFWD2" value="<%=(String) vo.getOFFWD2().trim()%>"></TD>
			<TD width="" colspan=3><INPUT class="Data" size="17" type="text" maxlength="25" name="OFFAMT2" id="OFFAMT2" value="<%=df.format(vo.getOFFAMT2())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">提前給付：<%=SHOWCURR%></TD>
			<TD width=""><INPUT class="Data" size="17" type="text" maxlength="25" name="ANNAMT" id="ANNAMT" value="<%=df.format(vo.getANNAMT())%>" onchange="getAAmount();"></TD>
			<TD align="left" class="TableHeading" width="116"><INPUT class="Data" size="14" type="text" maxlength="15" name="OFFWD3" id="OFFWD3" value="<%=(String) vo.getOFFWD3().trim()%>"></TD>
			<TD width="" colspan=3><INPUT class="Data" size="17" type="text" maxlength="25" name="OFFAMT3" id="OFFAMT3" value="<%=df.format(vo.getOFFAMT3())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106"><INPUT class="Data" size="14" type="text" maxlength="15" name="PEWD" id="PEWD" value="<%=(String) vo.getPEWD().trim()%>"></TD>
			<TD width="363"><INPUT class="Data" size="20" type="text" maxlength="25" name="PEAMT" id="PEAMT" value="<%=df.format(vo.getPEAMT())%>" onchange="getAAmount();"></TD>
			<TD colspan="4">&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">給付合計：<%=SHOWCURR%></TD>
			<TD width="241"><INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="AMT1" id="AMT1" value="<%=df.format(vo.getDEFAMT() + vo.getDIVAMT() + vo.getLOAN() + vo.getUNPRDPRM() + vo.getREVPRM() + vo.getCURPRM() + vo.getPEAMT() + vo.getOVRRTN() + vo.getANNAMT())%>"></TD>
			<TD align="left" class="TableHeading" width="116">扣款合計：<%=SHOWCURR%></TD>
			<TD width="363"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="AMT2" id="AMT2" value="<%=df.format(vo.getLANCAP() + vo.getLANINT() + vo.getAPL() + vo.getAPLINT() + vo.getOFFAMT() + vo.getOFFAMT1() + vo.getOFFAMT2() + vo.getOFFAMT3())%>"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">實付金額：<%=SHOWCURR%></TD>
			<TD width="" colspan=3><INPUT class="INPUT_DISPLAY" size="49" type="text" maxlength="25" name="PAMT" id="PAMT" value="<%=df.format(SHOWAMT)%>"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="" colspan=4>付款方式：</TD>
		</TR>
		<%String pMethod = vo.getPayment().getPMethod().trim();%>
		<TR>
			<TD align="left" class="TableHeading" width="106"><input type="radio" name="PMETHOD" value="A" readOnly <%if ("A".equals(pMethod)) out.print("checked");%>>支票：</TD>
			<TD width="" colspan=3>
				金額<INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="PAMT" id="PAMT" value="<%if ("A".equals(pMethod)) out.print(df.format(vo.getPayment().getPAMT()));%>" readonly>&nbsp; 
				支票號碼<INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="PCHECKNO" id="PCHECKNO" value="<%=vo.getPayment().getPCheckNO()%>" readonly>&nbsp; 
				支票日期<INPUT class="INPUT_DISPLAY" size="12" type="text" maxlength="25" name="CUSEDT" id="CUSEDT" value="<%=vo.getPayment().getPaymentCheck().getCUSEDT()%>" readonly>&nbsp;
				寄交<INPUT class="Data" size="15" type="text" maxlength="9" name="SNDNM" id="SNDNM" value="<%=SNDNM%>">
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106"><input type="radio" readOnly name="PMETHOD" value="C" <%if ("C".equals(pMethod)) out.print("checked");%>>信用卡：</TD>
			<TD width="" colspan=3>
				金額<INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="PAMT" id="PAMT" value="<%if ("C".equals(pMethod)) out.print(df.format(vo.getPayment().getPAMT()));%>" readonly>&nbsp;&nbsp; 
				卡號<INPUT class="INPUT_DISPLAY" size="42" type="text" maxlength="25" name="PCRDNO" id="PCRDNO" value="<%if ("C".equals(pMethod)) {  if (vo.getPayment().getPCrdNo().trim().length() > 4) { out.print(vo.getPayment().getPCrdNo().trim().substring(0, vo.getPayment().getPCrdNo().trim().length() - 4) + "XXXX"); } }%>" readonly>&nbsp;
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106"><!--R60550加上Method"D"--><input type="radio" readOnly name="PMETHOD" value="B" <%if ("B".equals(pMethod) || "D".equals(pMethod)) out.print("checked");%>>電匯：</TD>
			<TD width="" colspan=4>
				金額<INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="10" name="PAMT" id="PAMT" value="<%if ("B".equals(pMethod) || "D".equals(pMethod)) out.print(df.format(SHOWAMT)); //R60500vo.getPayment().getPAMT()); %>" readonly>&nbsp; 
				銀行<INPUT class="INPUT_DISPLAY" size="40" type="text" maxlength="30" name="PRBANK" id="PRBANK" value="<%if ("B".equals(pMethod))  out.print(vo.getPayment().getPRBank()); else if ("D".equals(pMethod)) out.print(vo.getPayment().getPBKNAME());%>" readonly> 
				帳號<INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="PRACCOUNT" id="PRACCOUNT" value="<%if ("B".equals(pMethod) || "D".equals(pMethod)) { if (vo.getPayment().getPRAccount().trim().length() > 4) { out.print(vo.getPayment().getPRAccount().trim().substring(0, vo.getPayment().getPRAccount().trim().length() - 4) + "XXXX"); } }%>" readonly>&nbsp;&nbsp;
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106"><input type="radio" name="PMETHOD" value="E" readOnly <%if ("E".equals(pMethod)) out.print("checked");%>>現金：</TD>
			<TD width="" colspan=3>
				金額<INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="PAMT" id="PAMT" value="<%if ("E".equals(pMethod)) out.print(df.format(vo.getPayment().getPAMT()));%>" readonly>&nbsp; 
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="180">報表格式：</TD>
			<TD width="305">
				<input type="radio" name="rdReportForm" id="rdReportForm" Value="NOTAWD" class="Data" checked>NOT FOR AWD 
				<input type="radio" name="rdReportForm" id="rdReportForm" Value="FORAWD" class="Data">FOR AWD
			</TD>
		</TR>
	</TBODY>
</TABLE>
<%}%> 
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBPaymentNotice.rpt"> 
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="SusDetailRpt.pdf"> 
<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value=""> 
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=request.getParameter("txtAction")%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>