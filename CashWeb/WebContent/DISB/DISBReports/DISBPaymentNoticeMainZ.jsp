<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.aegon.disb.disbreports.CAPPAYReportVO"%>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * Function : 給付通知書實付零
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.10 $
 * 
 * Author   : ODIN  TSAI
 * 
 * Create Date : $Date: 2014/02/27 03:54:58 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $$Log: DISBPaymentNoticeMainZ.jsp,v $
 * $Revision 1.10  2014/02/27 03:54:58  MISSALLY
 * $EB0536-BC264 沛利多利率變動型養老保險SIE
 * $
 * $Revision 1.9  2013/12/06 02:52:55  MISSALLY
 * $EB0194-PB0016-BC255利率變動型即期年金保險專案-BUGFix
 * $
 * $Revision 1.8  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255利率變動型即期年金保險專案
 * $
 * $Revision 1.7  2013/04/12 06:10:26  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.6  2013/03/11 08:58:46  ODCWilliam
 * $Revision 1.5  2013/02/26 10:21:45  ODCWilliam
 * $william wu
 * $RA0074
 * $
 * $Revision 1.4  2011/07/06 11:45:43  MISSALLY
 * $Q10180
 * $增加給付通知書檢核功能
 * $$
 *  
 */
%><%!
String strThisProgId = "DISBPaymentNoticeZ"; //本程式代號
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
<TITLE>給付通知書實付零</TITLE>
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
	if( document.getElementById("txtMsg").value != "" )
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title, '', strDISBFunctionKeyNotice, '' );
	document.getElementById("updateArea").style.display = "block";
	backHistory();
}

function backHistory() {
<%if (vo == null) {
	out.print("history.back();");
}
%>
}

/* 當toolbar frame 中之<修改>按鈕被點選時,本函數會被執行 */
function updateAction()
{
	if(checkFields())
	{
		document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=updateZ";
		document.frmMain.submit();
	}
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	history.back();
}

function printRAction() 
{
	if(checkFields())
	{
		document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBPaymentNoticeServlet?action=updateZ";
		document.frmMain.submit();

		getReportInfo();
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
	var PAMT= parseFloat(document.getElementById("PAMT").value) ;
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

	if( !bReturnStatus )
	{
		alert( strTmpMsg );
	}
	return bReturnStatus;
}

function getAAmount()
{
	document.getElementById("AMT1").value =  (parseFloat(document.getElementById("DEFAMT").value)
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
											+ parseFloat(document.getElementById("OFFAMT3").value)).toFixed(2);//R90474
}

function getReportInfo()
{
	var strSql = "SELECT a.*,b.PMETHOD,b.PAMT,b.PCHECKNO,b.PCRDNO,b.PRBANK,b.PRACCOUNT,c.CUSEDT,d.BKFNM,";
	strSql += "IFNULL(ph.FLD0154,'') as DIVTYPE,";
	strSql += "d.BKNM,b.ENTRYUSR,b.UPDUSR,IFNULL(b.PCURR,'"+document.getElementById("txtCurr").value+"') as POCURR,trim(g.FLD0004) as PCURR,IFNULL(b.PPAYCURR,'"+document.getElementById("txtCurr").value+"') as PAYCURR,trim(h.FLD0004) as PPAYCURR,b.PPAYAMT,e.BANK_NAME as SWBKNAME,FSFUCO,b.PFEEWAY ";//R90474
	strSql += " FROM CAPPAYRF a ";
	strSql += " LEFT OUTER JOIN CAPPAYF  b  ON b.PNO = a.PNO";
	strSql += " LEFT OUTER JOIN CAPCHKF  c  ON b.PCHECKNO = c.CNO";
	strSql += " LEFT OUTER JOIN CAPCCBF  d  ON d.BKNO = b.PRBANK" ;
	strSql += " LEFT OUTER JOIN ORCHSWFT e  ON b.PSWIFT = e.SWIFT_CODE" ;
	strSql += " LEFT OUTER JOIN SSEGFS   f  ON b.POLICYNO = f.FSPONU AND f.FSCOCO = '' AND b.PCURR = f.FSCURR AND f.FSCONU = 1 AND f.FSFUCO = 'SVSA' ";//R90474
    strSql += " LEFT OUTER JOIN ORDUET   g ON g.FLD0001='  ' and g.FLD0002='CURRA' and g.FLD0003=(CASE WHEN b.PCURR IS NULL THEN '"+document.getElementById("txtCurr").value+"' ELSE '' END) ";
    strSql += " LEFT OUTER JOIN ORDUET   h ON h.FLD0001='  ' and h.FLD0002='CURRA' and h.FLD0003=(CASE WHEN b.PPAYCURR IS NULL THEN '"+document.getElementById("txtCurr").value+"' ELSE '' END) ";
    strSql += " LEFT OUTER JOIN ORDUPO PO ON PO.FLD0001='  ' AND PO.FLD0002 = b.POLICYNO "; //EB0536
    strSql += " LEFT OUTER JOIN ORDUPH ph ON ph.FLD0001='  ' AND ph.FLD0002= PO.FLD0015 AND ph.FLD0003=PO.FLD0016 "; //EB0536

	if (document.getElementById("para_PNO").value != "" )
	{
		strSql +=" WHERE a.PNO = '" + document.getElementById("para_PNO").value +"'" ;
	}

	document.getElementById("ReportSQL").value = strSql;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">

<form action="" id="frmMain" name="frmMain" method="post">
<%if (vo != null) {
	String strSNDNM = "";
	double SHOWAMT = 0;
	String SHOWCURR = "";
	if (vo.getSNDNM() != null && !vo.getSNDNM().trim().equals("")) {
		strSNDNM = vo.getSNDNM().trim();
	} else {
		strSNDNM = vo.getAPPNM().replace('　', ' ').trim();
	}
	SHOWCURR = vo.getPayment().getPCurr().trim();
	SHOWCURR = disbBean.getETableDesc("CURRA", SHOWCURR) + "$";
%>
<TABLE border="1" width="854" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="106">保單號碼：</TD>
			<TD width="241"><INPUT class="Data" size="15" type="text" maxlength="11" name="POLICYNO" id="POLICYNO" value="<%=vo.getPOLICYNO()%>" readonly> <input type="hidden" id="para_PNO" name="para_PNO" value="<%=vo.getPNO()%>"></TD>
			<TD align="left" class="TableHeading" width="132">資料產生日：</TD>
			<TD width="304"><INPUT class="INPUT_DISPLAY" size="21" type="text" maxlength="11" name="UPDDT" id="UPDDT" value="<%=vo.getUPDDT()%>" readonly></TD>
		</TR>
	</TBODY>
</TABLE>
<TABLE border="1" width="854" id="updateArea" style="display: none">
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="106">要保人：</TD>
			<TD width="241"><INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="APPNM" id="APPNM" value="<%=vo.getAPPNM()%>" readonly></TD>
			<TD align="left" class="TableHeading" width="116">承辦人：</TD>
			<TD width="363"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="SRVNM" id="SRVNM" value="<%=vo.getUPDUSR().trim()%>" readonly> <input type="hidden" id="para_SRVNM" name="para_SRVNM" value="<%=vo.getUPDUSR().trim()%>"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">被保險人：</TD>
			<TD width="241"><INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="INSNM" id="INSNM" value="<%=vo.getINSNM()%>" readonly></TD>
			<TD align="left" class="TableHeading" width="116">通訊處：</TD>
			<TD width="363"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="SRVBH" id="SRVBH" value="<%=vo.getSRVBH()%>" readonly></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">收件人：</TD>
			<TD width="241"><INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="RECEIVER" id="RECEIVER" value="<%=vo.getRECEIVER()%>" readonly></TD>
			<TD align="left" class="TableHeading" width="116">服務人員：</TD>
			<TD width="363"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="SRVNM2" id="SRVNM2" value="<%=vo.getSRVNM()%>" readonly></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">住所地址：</TD>
			<TD width="" colspan=3><INPUT class="INPUT_DISPLAY" size="6" type="text" maxlength="5" name="HMZIP" id="HMZIP" value="<%=(String) vo.getHMZIP().trim()%>"> <INPUT class="INPUT_DISPLAY" size="49" type="text" maxlength="35" name="HMAD" id="HMAD" value="<%=(String) vo.getHMAD().trim()%>"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">郵寄地址：</TD>
			<TD width="" colspan=3><INPUT class="INPUT_DISPLAY" size="6" type="text" maxlength="5" name="MAILZIP" id="MAILZIP" value="<%=(String) vo.getMAILZIP().trim()%>"> <INPUT class="INPUT_DISPLAY" size="49" type="text" maxlength="35" name="MAILAD" id="MAILAD" value="<%=(String) vo.getMAILAD().trim()%>"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">給付項目：</TD>
			<TD width="" colspan=3>
				<input type="radio" value="A" name="ITEM" id="ITEM" <%if ("A".equals(vo.getITEM())) out.print("checked");%>>借款
				<input type="radio" value="B" name="ITEM" id="ITEM" <%if ("B".equals(vo.getITEM())) out.print("checked");%>>終止/撤銷 
				<input type="radio" value="C" name="ITEM" id="ITEM" <%if ("C".equals(vo.getITEM())) out.print("checked");%>>變更退費 
				<input type="radio" value="D" name="ITEM" id="ITEM" <%if ("D".equals(vo.getITEM())) out.print("checked");%>>退還當期保費 
				<input type="radio" value="E" name="ITEM" id="ITEM" <%if ("E".equals(vo.getITEM())) out.print("checked");%>>溢繳退費 
				<input type="radio" value="G" name="ITEM" id="ITEM" <%if ("G".equals(vo.getITEM())) out.print("checked");%>>年金提前給付
				<input type="radio" value="F" name="ITEM" id="ITEM" <%if ("F".equals(vo.getITEM())) out.print("checked");%>>其他
			</TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="" colspan=4>付款明細說明如下：</TD>
		</TR>
		<tr>
			<TD align="left" class="TableHeading" width="" colspan=2>給付項目：</TD>
			<TD align="left" class="TableHeading" width="" colspan=2>扣款項目：</TD>
		</tr>
		<TR>
			<TD align="left" class="TableHeading" width="106">解約退費：<%=SHOWCURR%></TD>
			<TD width="241"><INPUT class="Data" size="17" type="text" maxlength="25" name="DEFAMT" id="DEFAMT" value="<%=df.format(vo.getDEFAMT())%>" onchange="getAAmount();"></TD>
			<TD align="left" class="TableHeading" width="116">借款本金：<%=SHOWCURR%></TD>
			<TD width="363"><INPUT class="Data" size="20" type="text" maxlength="25" name="LANCAP" id="LANCAP" value="<%=df.format(vo.getLANCAP())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">保單紅利：<%=SHOWCURR%></TD>
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
			<TD colspan="4"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106"><INPUT class="Data" size="14" type="text" maxlength="15" name="PEWD" id="PEWD" value="<%=(String) vo.getPEWD().trim()%>"></TD>
			<TD width="363"><INPUT class="Data" size="20" type="text" maxlength="25" name="PEAMT" id="PEAMT" value="<%=df.format(vo.getPEAMT())%>" onchange="getAAmount();"></TD>
			<!--R90474 -->
			<TD align="left" class="TableHeading" width="116"><INPUT class="Data" size="14" type="text" maxlength="15" name="OFFWD3" id="OFFWD3" value="<%=(String) vo.getOFFWD3().trim()%>"></TD>
			<TD width="" colspan=3><INPUT class="Data" size="17" type="text" maxlength="25" name="OFFAMT3" id="OFFAMT3" value="<%=df.format(vo.getOFFAMT3())%>" onchange="getMAmount();"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">給付合計：<%=SHOWCURR%></TD>
			<TD width="241"><INPUT class="INPUT_DISPLAY" size="17" type="text" maxlength="25" name="AMT1" id="AMT1" value="<%=df.format(vo.getDEFAMT() + vo.getDIVAMT() + vo.getLOAN() + vo.getUNPRDPRM() + vo.getREVPRM() + vo.getCURPRM() + vo.getPEAMT() + vo.getOVRRTN() + vo.getANNAMT())%>"></TD>
			<TD align="left" class="TableHeading" width="116">扣款合計：<%=SHOWCURR%></TD>
			<TD width="363"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="25" name="AMT2" id="AMT2" value="<%=df.format(vo.getLANCAP() + vo.getLANINT() + vo.getAPL() + vo.getAPLINT() + vo.getOFFAMT() + vo.getOFFAMT1() + vo.getOFFAMT2() + vo.getOFFAMT3())%>"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="106">實付金額：<%=SHOWCURR%></TD>
			<TD width="" colspan=3><INPUT class="INPUT_DISPLAY" size="49" type="text" maxlength="25" name="PAMT" id="PAMT" value="<%=df.format(SHOWAMT)%>">&nbsp;&nbsp; 寄交<INPUT class="Data" size="15" type="text" maxlength="9" name="SNDNM" id="SNDNM" value="<%=strSNDNM%>"></TD>
		</TR>
		<TR>
			<TD align="left" class="TableHeading" width="180">報表格式：</TD>
			<TD width="305"><input type="radio" name="rdReportForm" id="rdReportForm" Value="NOTAWD" class="Data" checked>NOT FOR AWD <input type="radio" name="rdReportForm" id="rdReportForm" Value="FORAWD" class="Data">FOR AWD</TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtCurr" name="txtCurr" value="<%=vo.getPayment().getPCurr().trim()%>">
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
