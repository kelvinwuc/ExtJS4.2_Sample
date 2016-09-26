<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 現金支付
 * 
 * Remark   : 出納功能
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : Ariel Wei
 * 
 * Create Date : 2014/05/07
 * 
 * Request ID  : RC0036
 * 
 * CVS History:
 * 
 * Revision 1.3  2015/10/14 Kelvin Wu
 * RD0460:新增CSC
 *
 * $Log: DISBDeptCashConfirmList.jsp,v $
 * Revision 1.3  2015/10/14 05:57:05  001946
 * *** empty log message ***
 *
 * Revision 1.2  2015/08/05 03:58:46  001946
 * *** empty log message ***
 *
 * Revision 1.1  2014/07/18 07:34:50  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 * 
 */
%>
<%
Logger log = Logger.getLogger(getClass());
 %>
<%! String strThisProgId = "DISBDeptCashConfirm"; //本程式代號 %><%
DecimalFormat df = new DecimalFormat("#.00");
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPBBankP = null;

if (session.getAttribute("PBBankListP") == null) {
	alPBBankP = (List) disbBean.getETable("PBKAT", "BANKP");
	session.setAttribute("PBBankListP",alPBBankP);
} else {
	alPBBankP =(List) session.getAttribute("PBBankListP");
}
if (session.getAttribute("PBBankListP") != null) {
	session.removeAttribute("PBBankListP");
}

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

StringBuffer sbBankCode = new StringBuffer();
sbBankCode.append("<option value=\"\">&nbsp;</option>");
if (alPBBankP.size() > 0) {
	for (int i = 0; i < alPBBankP.size(); i++) {
		htTemp = (Hashtable) alPBBankP.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		if(strValue.equals("8120610/06120001666600"))
			sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}

double total = 0;
List<DISBPaymentDetailVO> vo = (List<DISBPaymentDetailVO>)request.getAttribute("PDetailListTemp");
request.removeAttribute("PDetailListTemp");
int count = (vo == null?0:vo.size());
log.info("共計:" + count + "筆");
int TYBcount = 0;
int TCBcount = 0;
int TNBcount = 0;
int KHBcount = 0;
int PCDcount = 0;
int CSCcount = 0;
double iTYBamt = 0;
double iTCBamt = 0;
double iTNBamt = 0;
double iKHBamt = 0;
double iPCDamt = 0;
double iCSCamt = 0;


%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>週轉金撥補</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
// *************************************************************
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{    
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
	window.status = "";
}

function confirmAction()
{
	document.getElementById("txtAction").value = "H";
	mapValue();
	if(checkField()){
		document.frmMain.submit();
	}
}

function resetAction()
{
	document.forms("frmMain").reset();
}

function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBDeptCashConfirmInq.jsp";
}


function mapValue()
{
    document.getElementById("txtPCSHCM").value = rocDate2String(document.getElementById("txtPCSHCMC").value);
	var BankAccount = document.getElementById("selPBBANK").value ;
	if(BankAccount != "")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);	
	}
    	
	var t1 = document.all("tbl").childNodes[0];
	var chk = document.getElementsByName("PNO");
	var amt = 0;
	for(var index=0; index<chk.length ; index++ ) {
		if(chk[index].checked) {
			amt = amt + parseFloat(t1.rows[index+1].cells[6].innerHTML);
		}
	}
	document.getElementById("PAMT").value = amt;
}

function checkField()
{	
	var bReturnStatus = false;
	var strTmpMsg = "";
	if(document.getElementById("txtPCSHCMC").value == "")
	{
	   alert( "請輸入出納確認日!" );
	   return bReturnStatus;
	}
	
	if(document.getElementById("txtCHKNO").value=="")
	{
	   alert( "請輸入支票號碼!" );
	   return bReturnStatus;
	}
	
	var chk = document.getElementsByName("PNO");
	for(var index = 0; index<chk.length; index++){
		if(chk[index].checked){
			bReturnStatus = true;
			break;
		}
	}
	if(!bReturnStatus){
		alert( "請勾選欲確認的保單!" );
	}

	return bReturnStatus;
}


function calculateAmt()
{
	var amt = 0.00;
	var count = 0;
	var TYBcount = 0;
	var TCBcount = 0;
	var TNBcount = 0;
	var KHBcount = 0;
	var PCDcount = 0;
	var CSCcount = 0;
	
	var strUsrDept ='';
	var TYBamt = 0.00;
    var TCBamt = 0.00;
	var TNBamt = 0.00;
	var KHBamt = 0.00;
	var PCDamt = 0.00;
	var CSCamt = 0.00;

	var t1 = document.all("tbl").childNodes[0];

	var chk = document.getElementsByName("PNO");
	for(var index=0; index<chk.length ; index++ ){
		if(chk[index].checked){
			count = count+1;
			amt = amt + parseFloat(t1.rows[index+1].cells[6].innerHTML);
		    strUsrDept = t1.rows[index+1].cells[12].innerHTML;
		    strUsrDept = strUsrDept.replace('&nbsp;','');
		    
		    if(trim(strUsrDept) == "TYB") {
		     	TYBamt = TYBamt + parseFloat(t1.rows[index+1].cells[6].innerHTML);
		     	TYBcount = TYBcount+1;
		     } else if(trim(strUsrDept) == "TCB") {
			    TCBamt = TCBamt + parseFloat(t1.rows[index+1].cells[6].innerHTML);
			    TCBcount = TCBcount+1;
		     } else if(trim(strUsrDept) == "TNB") {
			    TNBamt = TNBamt + parseFloat(t1.rows[index+1].cells[6].innerHTML);
			    TNBcount = TNBcount+1;	    			
		     } else if(trim(strUsrDept) == "KHB") {	     			    			    			    		     			   
			    KHBamt = KHBamt + parseFloat(t1.rows[index+1].cells[6].innerHTML);
			    KHBcount = KHBcount+1;			    			    			    		     			     				
		     } else if(trim(strUsrDept) == "PCD") {
		        PCDamt = PCDamt + parseFloat(t1.rows[index+1].cells[6].innerHTML);
			    PCDcount = PCDcount+1;	 
		     }else if(trim(strUsrDept) == "CSC") {	     			    			    			    		     			   
			    CSCamt = CSCamt + parseFloat(t1.rows[index+1].cells[6].innerHTML);
			    CSCcount = CSCcount+1;			    			    			    		     			     				
		     }
		}
	}

	var t2 = document.all("tbl2").childNodes[0];
	t2.rows[0].cells[1].innerHTML = count;
	t2.rows[0].cells[5].innerHTML = amt;
	t2.rows[1].cells[1].innerHTML = KHBcount;
    t2.rows[1].cells[5].innerHTML = KHBamt;
    t2.rows[2].cells[1].innerHTML = PCDcount;
    t2.rows[2].cells[5].innerHTML = PCDamt;
    t2.rows[3].cells[1].innerHTML = TCBcount;  
    t2.rows[3].cells[5].innerHTML = TCBamt;
    t2.rows[4].cells[1].innerHTML = TNBcount;  
    t2.rows[4].cells[5].innerHTML = TNBamt;
    t2.rows[5].cells[1].innerHTML = TYBcount;  
    t2.rows[5].cells[5].innerHTML = TYBamt;
    t2.rows[6].cells[1].innerHTML = CSCcount;  
    t2.rows[6].cells[5].innerHTML = CSCamt;
    
}

function trim(str) {
  var start = -1,
  end = str.length;
  while (str.charCodeAt(--end) < 33);
  while (str.charCodeAt(++start) < 33);
  return str.slice(start, end + 1);
};



//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBDeptCashConfirmServlet" id="frmMain" method="post" name="frmMain">
<INPUT type="hidden" id="PAMT" name="PAMT" value="">
<INPUT type="hidden" id="txtPBBank" name="txtPBBank" value="">
<INPUT type="hidden" id="txtPBAccount" name="txtPBAccount" value="">
<INPUT type="hidden" id="PMETHOD" name="PMETHOD" value="E">
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<TABLE border="1" width="452">
	</TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">出納確認日：</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCSHCMC" name="txtPCSHCMC" value="" >
				<a href="javascript:show_calendar('frmMain.txtPCSHCMC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
				<INPUT type="hidden" name="txtPCSHCM" id="txtPCSHCM" value=""> 
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">付款帳號：</TD>
			<TD width="333">
				<select size="1" name="selPBBANK" id="selPBBANK" class="Data">
					<%=sbBankCode.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">支票號碼：</TD>
			<TD width="333">
				<input type="text" name="txtCHKNO" size="15"/>
			</TD>
		</TR>
	</TBODY>
</TABLE>
<br>
<TABLE id="tbl" border="0" cellpadding="0" cellspacing="0" width="900">
	<TBODY>
		<TR>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="細明體">序號</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="細明體">勾選</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="65"><B><FONT size="2" face="細明體">保單號碼</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="細明體">受款人姓名</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="細明體">受款人ID</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="細明體">幣別</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="細明體">支付金額</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="細明體">支付描述</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">付款日期</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">付款方式</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">作廢否</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">急件否</FONT></B></TD>
		    <TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="56" width="60"><B><FONT size="2" face="細明體">承辦單位</FONT></B></TD>
		</TR>
<%	DISBPaymentDetailVO paymentDetail = null;
	String strPayMethodCode = "";
	String strPayMethodDesc = "";
	String strPaySRCDesc = "";
    String strDeptChk = "";
	for(int index = 0 ; index < vo.size() ; index++) {
		paymentDetail = (DISBPaymentDetailVO)vo.get(index);
		total += paymentDetail.getIPAMT();
		
		

    strDeptChk = CommonUtil.AllTrim(paymentDetail.getStrUsrDept());
		if("TYB".equals(strDeptChk)) {
			iTYBamt += paymentDetail.getIPAMT();
			TYBcount = TYBcount +1;
		} else if("TCB".equals(strDeptChk)) {
			iTCBamt += paymentDetail.getIPAMT();
			TCBcount = TCBcount +1;		
		} else if("TNB".equals(strDeptChk)) {
			iTNBamt += paymentDetail.getIPAMT();	
			TNBcount = TNBcount +1;
		} else if("KHB".equals(strDeptChk)) {
			iKHBamt += paymentDetail.getIPAMT();
			KHBcount = KHBcount +1;			
		} else if("CSC".equals(strDeptChk)) {
			iCSCamt += paymentDetail.getIPAMT();
			CSCcount = CSCcount +1;			
		} else {
			iPCDamt += paymentDetail.getIPAMT();
			PCDcount = PCDcount +1;			
		}
        
		strPayMethodCode = CommonUtil.AllTrim(paymentDetail.getStrPMethod());
		if("A".equals(strPayMethodCode)) {
			strPayMethodDesc = "支票";
		} else if("B".equals(strPayMethodCode)) {
			strPayMethodDesc = "匯款";					
		} else if("C".equals(strPayMethodCode)) {
			strPayMethodDesc = "信用卡";					
		} else if("D".equals(strPayMethodCode)) {
			strPayMethodDesc = "國外匯款";					
		} else if("E".equals(strPayMethodCode)) {
			strPayMethodDesc = "現金";					
		}

		strPaySRCDesc = CommonUtil.AllTrim(paymentDetail.getStrPSrcCode()) + "-" + CommonUtil.AllTrim(paymentDetail.getStrPDesc()); %>
		<TR id="dataRow_<%=index+1%>" >
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35"><%=index+1%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35"><INPUT type="checkbox" checked name="PNO" id="PNO" value="<%=paymentDetail.getStrPNO()%>" onClick="calculateAmt();"></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrPolicyNo()%></TD>

			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrPName()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrPId()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getStrPCurr()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" align="right"><%=df.format(paymentDetail.getIPAMT())%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=strPaySRCDesc%></TD>

			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=paymentDetail.getIPDate()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=strPayMethodDesc%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=("Y".equals(paymentDetail.getStrPVoidable())?"是":"否")%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=("Y".equals(paymentDetail.getStrPDispatch())?"是":"否")%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="35" id="UsrDept">&nbsp;<%=paymentDetail.getStrUsrDept()%></TD>
		</TR>
<%	} %>
	</TBODY>
</TABLE>
<BR>
<table id="tbl2">
	<tr><td>總件數 :  </td><td><%=count%></td><td></td><td></td><td>總金額 : </td><td><%=df.format(total)%></td></tr>
	<tr><td>KHB 高雄分公司 :  </td><td><%=KHBcount%></td><td></td><td></td><td>總金額 : </td><td><%=df.format(iKHBamt)%></td></tr> 
	<tr><td>PCD   收費處 :  </td><td><%=PCDcount%></td><td></td><td></td><td>總金額 : </td><td><%=df.format(iPCDamt)%></td></tr>     
 	<tr><td>TCB 台中分公司 :  </td><td><%=TCBcount%></td><td></td><td></td><td>總金額 : </td><td><%=df.format(iTCBamt)%></td></tr> 
  	<tr><td>TNB 台南分公司 :  </td><td><%=TNBcount%></td><td></td><td></td><td>總金額 : </td><td><%=df.format(iTNBamt)%></td></tr> 
  	<tr><td>TYB 桃園分公司 :  </td><td><%=TYBcount%></td><td></td><td></td><td>總金額 : </td><td><%=df.format(iTYBamt)%></td></tr>
  	<tr><td>CSC 總公司 :  </td><td><%=CSCcount%></td><td></td><td></td><td>總金額 : </td><td><%=df.format(iCSCamt)%></td></tr> 



</table>
</FORM>
</BODY>
</HTML>