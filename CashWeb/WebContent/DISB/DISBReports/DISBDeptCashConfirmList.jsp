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
 * Function : �{����I
 * 
 * Remark   : �X�ǥ\��
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
 * RD0460:�s�WCSC
 *
 * $Log: DISBDeptCashConfirmList.jsp,v $
 * Revision 1.3  2015/10/14 05:57:05  001946
 * *** empty log message ***
 *
 * Revision 1.2  2015/08/05 03:58:46  001946
 * *** empty log message ***
 *
 * Revision 1.1  2014/07/18 07:34:50  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 * 
 */
%>
<%
Logger log = Logger.getLogger(getClass());
 %>
<%! String strThisProgId = "DISBDeptCashConfirm"; //���{���N�� %><%
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
log.info("�@�p:" + count + "��");
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
<TITLE>�g�������</TITLE>
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
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
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
	   alert( "�п�J�X�ǽT�{��!" );
	   return bReturnStatus;
	}
	
	if(document.getElementById("txtCHKNO").value=="")
	{
	   alert( "�п�J�䲼���X!" );
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
		alert( "�ФĿ���T�{���O��!" );
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
			<TD align="right" class="TableHeading" width="101">�X�ǽT�{��G</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCSHCMC" name="txtPCSHCMC" value="" >
				<a href="javascript:show_calendar('frmMain.txtPCSHCMC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
				<INPUT type="hidden" name="txtPCSHCM" id="txtPCSHCM" value=""> 
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�I�ڱb���G</TD>
			<TD width="333">
				<select size="1" name="selPBBANK" id="selPBBANK" class="Data">
					<%=sbBankCode.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�䲼���X�G</TD>
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
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="�ө���">�Ǹ�</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="�ө���">�Ŀ�</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="65"><B><FONT size="2" face="�ө���">�O�渹�X</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="�ө���">���ڤH�m�W</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="�ө���">���ڤHID</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="35"><B><FONT size="2" face="�ө���">���O</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="�ө���">��I���B</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="80"><B><FONT size="2" face="�ө���">��I�y�z</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">�I�ڤ��</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">�I�ڤ覡</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">�@�o�_</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">���_</FONT></B></TD>
		    <TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="56" width="60"><B><FONT size="2" face="�ө���">�ӿ���</FONT></B></TD>
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
			strPayMethodDesc = "�䲼";
		} else if("B".equals(strPayMethodCode)) {
			strPayMethodDesc = "�״�";					
		} else if("C".equals(strPayMethodCode)) {
			strPayMethodDesc = "�H�Υd";					
		} else if("D".equals(strPayMethodCode)) {
			strPayMethodDesc = "��~�״�";					
		} else if("E".equals(strPayMethodCode)) {
			strPayMethodDesc = "�{��";					
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
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=("Y".equals(paymentDetail.getStrPVoidable())?"�O":"�_")%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35">&nbsp;<%=("Y".equals(paymentDetail.getStrPDispatch())?"�O":"�_")%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid" height="35" id="UsrDept">&nbsp;<%=paymentDetail.getStrUsrDept()%></TD>
		</TR>
<%	} %>
	</TBODY>
</TABLE>
<BR>
<table id="tbl2">
	<tr><td>�`��� :  </td><td><%=count%></td><td></td><td></td><td>�`���B : </td><td><%=df.format(total)%></td></tr>
	<tr><td>KHB ���������q :  </td><td><%=KHBcount%></td><td></td><td></td><td>�`���B : </td><td><%=df.format(iKHBamt)%></td></tr> 
	<tr><td>PCD   ���O�B :  </td><td><%=PCDcount%></td><td></td><td></td><td>�`���B : </td><td><%=df.format(iPCDamt)%></td></tr>     
 	<tr><td>TCB �x�������q :  </td><td><%=TCBcount%></td><td></td><td></td><td>�`���B : </td><td><%=df.format(iTCBamt)%></td></tr> 
  	<tr><td>TNB �x�n�����q :  </td><td><%=TNBcount%></td><td></td><td></td><td>�`���B : </td><td><%=df.format(iTNBamt)%></td></tr> 
  	<tr><td>TYB �������q :  </td><td><%=TYBcount%></td><td></td><td></td><td>�`���B : </td><td><%=df.format(iTYBamt)%></td></tr>
  	<tr><td>CSC �`���q :  </td><td><%=CSCcount%></td><td></td><td></td><td>�`���B : </td><td><%=df.format(iCSCamt)%></td></tr> 



</table>
</FORM>
</BODY>
</HTML>