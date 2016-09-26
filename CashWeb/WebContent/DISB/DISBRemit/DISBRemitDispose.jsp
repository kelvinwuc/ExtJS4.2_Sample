<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.text.DecimalFormat"%>
<%@page import="com.aegon.codeAttr.CodeAttr"%>
<%@page import="com.aegon.codeAttr.RemittancePayRule"%>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : �״ڥ\��--���״ڧ@�~(�d��)
 * 
 * Remark   : �X�ǥ\��-���״�
 * 
 * Revision : $Revision: 1.18 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2014/02/26 06:39:32 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBRemitDispose.jsp,v $
 * Revision 1.18  2014/02/26 06:39:32  MISSALLY
 * EB0537 --- �s�W�U���Ȧ欰�~�����w�Ȧ�
 *
 * Revision 1.17  2013/01/09 03:21:50  MISSALLY
 * Calendar problem
 *
 * Revision 1.16  2013/01/08 04:25:55  MISSALLY
 * �N���䪺�{��Merge��HEAD
 *
 * Revision 1.14.4.1  2012/08/31 01:21:31  MISSALLY
 * RA0140---�s�W���׬��~�����w��
 *
 * Revision 1.14  2011/10/24 03:53:33  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 * Revision 1.13  2011/10/21 10:04:38  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 * Revision 1.11  2010/05/04 07:16:09  missteven
 * R90735
 *
 * Revision 1.10  2008/08/06 07:06:35  MISODIN
 * R80338 �վ�CASH�t�� for �X�ǥ~���@��@�ݨD
 *
 * Revision 1.9  2007/09/07 10:42:41  MISVANESSA
 * R70455_TARGET OUT
 *
 * Revision 1.8  2007/08/03 10:07:51  MISODIN
 * R70477 �~���O��״ڤ���O
 *
 * Revision 1.7  2007/03/06 01:50:41  MISVANESSA
 * R70088_SPUL�t��������W��I�Ȧ�ña�J
 *
 * Revision 1.6  2007/01/31 08:06:14  MISVANESSA
 * R70088_SPUL�t��
 *
 * Revision 1.5  2007/01/05 06:09:53  miselsa
 * R60550_�~���״ڥ�l���S�O�z��O�_��SPUL
 *
 * Revision 1.4  2007/01/03 08:32:50  miselsa
 * R60550_SPUL ���_�l�餧�e �W�[ �Ȥ�ץX�Ȧ����
 *
 * Revision 1.3  2006/12/07 22:00:57  miselsa
 * R60463��R60550�~����SPUL�O��
 *
 * Revision 1.2  2006/11/29 08:07:41  miselsa
 * R60463��R60550�~����SPUL�O��
 *
 * Revision 1.1  2006/06/29 09:39:46  MISangel
 * Init Project
 *
 * Revision 1.1.2.6  2006/04/27 09:41:44  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.5  2005/04/18 08:54:04  MISANGEL
 * R30530:��I�t��
 *
 * Revision 1.1.2.4  2005/04/08 02:57:44  MISANGEL
 * R30530:��I�t��
 *
 * Revision 1.1.2.3  2005/04/04 07:02:25  miselsa
 * R30530 ��I�t��
 *  
 */
%><%! String strThisProgId = "DISBRemitDispose"; //���{���N�� %><%
DecimalFormat df = new DecimalFormat("#.00");//@R90735
GlobalEnviron globalEnviron =(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alBankCodeD = null; //R70477
List fcTriBankCode = null; //R00386
List alCurrCash = new ArrayList(); //R80132 ���O�D��

// R70477
if (session.getAttribute("BankCodeListD") == null) {
	alBankCodeD = (List) disbBean.getETable("PBKAT", "BANKDC");
	session.setAttribute("BankCodeListD", alBankCodeD);
} else {
	alBankCodeD = (List) session.getAttribute("BankCodeListD");
}
//R00386
if (session.getAttribute("fcTriBankCodeList") == null) {
    fcTriBankCode = (List) disbBean.getETable("BNKFR", "BANKFRC");
	session.setAttribute("fcTriBankCodeList", fcTriBankCode );
} else {
    fcTriBankCode = (List) session.getAttribute("fcTriBankCodeList");
}
//R00386
if (session.getAttribute("PBBankListD") != null) {
	session.removeAttribute("PBBankListD");
}
if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
//R80132 END

String msg = "";
if(request.getAttribute("count") != null) {
	msg = "�״��`��� : "+request.getAttribute("count");
	msg += "\n�״��`���B : "+df.format(Double.valueOf((String)request.getAttribute("amt")).doubleValue());//@R90735
	if(request.getAttribute("RPAYamt") != null)
		msg += "\n�~���״��`���B : "+request.getAttribute("RPAYamt");//�~���״��`���B
	msg += "\n�״ڧ帹 : " +request.getAttribute("batNo");
}
if(request.getAttribute("msg") != null) {
	msg = (String)request.getAttribute("msg");
}
String PMETHOD = "";
if(request.getAttribute("PMETHOD") != null) {
	PMETHOD = (String)request.getAttribute("PMETHOD");
}

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

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
StringBuffer sbBankCodeD = new StringBuffer();
sbBankCodeD.append("<option value=\"\">&nbsp;</option>");
if (alBankCodeD.size() > 0) {
	for (int i = 0; i < alBankCodeD.size(); i++) {
		htTemp = (Hashtable) alBankCodeD.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbBankCodeD.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
StringBuffer sbfcTriBankCode = new StringBuffer();
sbfcTriBankCode.append("<option value=\"\">&nbsp;</option>");
if (fcTriBankCode.size() > 0) {
	for (int i = 0; i < fcTriBankCode.size(); i++) {
		htTemp = (Hashtable) fcTriBankCode.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbfcTriBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
%>

<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�״ڥ\��--���״ڧ@�~</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--
// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "") {
		window.alert(document.getElementById("txtMsg").value);
	}

	WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
	window.status = "";

	if( document.getElementById("pMethod").value=="D" ) {  // R00386 
		document.getElementById("DArea").style.display = "block";
		document.getElementById("txtSYMBOL").value = "S";
		showBankAreaByPayRule( true );
	}
}

function inquiryAction()
{
	if(checkField()) {
	    mapValue();
		document.frmMain.submit();
	}
}

function checkField() 
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	with(document.frmMain) {
		if(pDate1.value == "" || pDate2.value == "") {
			strTmpMsg = "[ ��I�T�{�� ] ���i�ť�";
			bReturnStatus = false;
		}
	}
	if( !bReturnStatus ) {
		alert( strTmpMsg );
	}
	return bReturnStatus;
}
/*
function enableSPULArea()
{
   document.getElementById("SPULAreaH").style.display ="block";
   document.getElementById("SPULArea").style.display ="block";
}
function disableSPULArea()
{
   document.getElementById("SPULAreaH").style.display ="none";
   document.getElementById("SPULArea").style.display ="none";
}
*/
function mapValue()
{
	// R80338 if(document.getElementById("pMethod").value=="D" && document.getElementById("selCurrency").value=="NT"){
	if(document.getElementById("pMethod").value=="D" ) {  //R80338
		document.getElementById("txtSYMBOL").value = "S";
	} else {
		document.getElementById("txtSYMBOL").value = "";
	} 

	// R00386 
	var payRule = document.getElementById("selPayRule").value;
	var prbank = "";

	if( payRule == "<%= RemittancePayRule.PLANV_DIV.getCode() %>" )
		prbank = document.getElementById("selPRBank3").value;
	else if( payRule == "<%= RemittancePayRule.PLANV_NODIV.getCode() %>" )
		prbank = document.getElementById("selPRBank4").value;
	else if( payRule == "<%= RemittancePayRule.PLANT.getCode() %>" )
		prbank = document.getElementById("selPRBank5").value;
	else
		prbank = document.getElementById("selPRBank6").value;

	document.getElementById("txtPayRule").value = payRule;
	document.getElementById("txtPRBank").value = prbank;

	/*
	document.getElementById("txtBeforePINVDT").value=document.getElementById("selBeforePINVDT").value;
	//R80338 document.getElementById("txtPRBank").value=document.getElementById("selPRBank").value;
	if(document.getElementById("selBeforePINVDT").value=="N" && document.getElementById("selCurrency").value!="NT"){  //R80338
		document.getElementById("txtPRBank").value=document.getElementById("selPRBank4").value;    //R80338
	}      //R80338
	else if(document.getElementById("selProjectCode").value=="UBS"){   //R80338
		document.getElementById("txtPRBank").value=document.getElementById("selPRBank4").value;   //R08338
	}  //R80338
	else{   //R80338
		document.getElementById("txtPRBank").value=document.getElementById("selPRBank3").value;  //R80338
	}   //R80338
	*/

	/*
	if(document.frmMain.rdSYMBOL[0].checked)
	{
		document.getElementById("txtSYMBOL").value="S";
	}
	else
	{
		document.getElementById("txtSYMBOL").value="N";
	}
	if(document.frmMain.rdBeforePINVDT[0].checked)
	{
		document.getElementById("txtBeforePINVDT").value="Y";
	}
	else
	{
		document.getElementById("txtBeforePINVDT").value="N";
	}
	*/
}

function showDArea()
{
	// alert(document.getElementById("pMethod").value);
	// alert(document.getElementById("selCurrency").value);
	//R80338 if(document.getElementById("pMethod").value=="D" && document.getElementById("selCurrency").value=="NT"){
	if(document.getElementById("pMethod").value=="D" ) {  //R80338 
		document.getElementById("DArea").style.display = "block";
		document.getElementById("txtSYMBOL").value = "S";
		showBankAreaByPayRule( true );
	}
	//R70477
	// R80132 else  if(document.getElementById("selCurrency").value=="US") {
	// R80338 else  if(document.getElementById("selCurrency").value !="NT" && document.getElementById("selCurrency").value !="" ){
	//R80338 document.getElementById("D3Area").style.display ="block";
	//R80338 document.getElementById("D2Area").style.display ="none";    
	//R80338 document.getElementById("DArea").style.display ="none"; 
	//R80338 document.getElementById("DArea").style.display ="block";     //R80338       
	//R80338}
	else {
		document.getElementById("DArea").style.display ="none";
		document.getElementById("txtSYMBOL").value="";
		// R70477
		//document.getElementById("D2Area").style.display ="none";
		//document.getElementById("D3Area").style.display ="none";
		showBankAreaByPayRule( false );
	}
}
<%-- R00386 �H�I�ڳW�h���N
function showPRBankArea(BeforePINVDT)
{
	if(BeforePINVDT=="N" && document.getElementById("selCurrency").value=="NT"){   //R80338
		document.getElementById("D2Area").style.display ="none";     //R80338
		document.getElementById("D3Area").style.display ="none";
		document.getElementById("D4Area").style.display ="none";   //R80338      
	}
	else if(BeforePINVDT=="N" && document.getElementById("selCurrency").value!="NT"){   //R80338
		document.getElementById("D2Area").style.display ="none";     //R80338
		document.getElementById("D3Area").style.display ="none";     //R80338
		document.getElementById("D4Area").style.display ="block";    //R80338
	}    //R80338
	else{
		//R80338 document.getElementById("D2Area").style.display ="block";  
		//R80338 document.getElementById("D3Area").style.display ="none";
		document.getElementById("D2Area").style.display ="none";  
		document.getElementById("D3Area").style.display ="block";
		document.getElementById("D4Area").style.display ="none";   //R80338
	}
}
// R80338
function showProjectBankArea()  
{
	if(document.getElementById("selProjectCode").value=="UBS") 
	{
		document.getElementById("D2Area").style.display ="none";   
		document.getElementById("D3Area").style.display ="none";  
		document.getElementById("D4Area").style.display ="block";   
	}
	else
	{
		document.getElementById("D2Area").style.display ="none";   
		document.getElementById("D3Area").style.display ="none";
		document.getElementById("D4Area").style.display ="none";     
	}
}  //R80338 END 
--%>

// R00386
function showBankAreaByPayRule( showBank ) 
{
	//alert( "current value=" + document.getElementById( "selPayRule" ).value );

	var rule = document.getElementById( "selPayRule" ).value;
    document.getElementById("D3Area").style.display = "none";
    document.getElementById("D4Area").style.display = "none";
    document.getElementById("D5Area").style.display = "none";

    if( showBank ) {
		document.getElementById("D6Area").style.display = "none";

		if( rule == "<%= RemittancePayRule.PLANV_DIV.getCode() %>" )
			document.getElementById("D3Area").style.display = "block";
		else if( rule == "<%= RemittancePayRule.PLANV_NODIV.getCode() %>" )
			document.getElementById("D4Area").style.display = "block";
		else if( rule == "<%= RemittancePayRule.PLANT.getCode() %>" )
			document.getElementById("D5Area").style.display = "block";
		else
			document.getElementById("D6Area").style.display = "block";
			
	}
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	var itemName = objThisItem.name;
	if( itemName == "pDate1" || itemName == "pDate2" ) {
		bDate = true ;
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false) {
			strTmpMsg = "��I�T�{��-����榡���~";
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
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitDisposeServlet?action=query" id="frmMain" method="post" name="frmMain">
<INPUT type="hidden" id="txtPEndDate" name="txtPEndDate" value=""> 
<INPUT type="hidden" id="txtPStartDate" name="txtPStartDate" value=""> 
<INPUT type="hidden" id="txtUPDate" name="txtUPDate" value=""> 
<TABLE border="1" width="452" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="121">�I�ڤ覡�G</TD>
			<TD width="323"> 
				<SELECT class="Data" id="pMethod" name="pMethod" onchange="showDArea();">
					<OPTION value="B">�Ȧ�״�</OPTION>
					<OPTION value="C">�H�Υd</OPTION>
					<OPTION value="D">�~���״�</OPTION>
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="121">��I�T�{��G</TD>
			<TD width="323">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="pDate1" name="pDate1" > 
				<a href="javascript:show_calendar('frmMain.pDate1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
				<INPUT type="hidden" name="pDate1C" id="pDate1C" value=""> ~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="pDate2" name="pDate2" onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.pDate2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
				<INPUT type="hidden" name="pDate2C" id="pDate2C" value=""> 
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="121">���_�G</TD>
			<TD width="323">
				<select size="1" name="pDispatch" id="pDispatch">
					<option value="Y">�O</option>
					<option value="" selected>�_</option>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="121">�O����O</TD>
			<TD width="323">
				<select size="1" name="selCurrency" id="selCurrency" onchange="showDArea();">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
 		<!-- R80338 �M�׽X -->
		<%-- R00386 �H�I�ڳW�h���N
		<TR>
			<TD align="right" class="TableHeading" width="121">�M�׽X�G</TD>
			<TD width="323">
				<select size="1" name="selProjectCode" id="selProjectCode" onchange="showProjectBankArea();">
					<option value="" selected>ALL</option>
					<option value="UBS">UBS</option>
					<option value="OTHERS">Others</option>			
				</select>
			</TD>
		</TR>
		--%>
<%--
// R00386 �H�I�ڳW�h���N 
	<TR>
	<TD name=SPULAreaH ID=SPULAreaH  class="TableHeading" align="right" width="121"><!--R70088--><!--R70455 ADD TARGET OUT-->
	 ���_�l��e��SPUL�t���δ��e�X��:
	</TD>
	<TD name=SPULArea ID=SPULArea width="323">
	    <select size="1" name="selBeforePINVDT" id="selBeforePINVDT" onchange="showPRBankArea(this.options[this.selectedIndex].value)">
			<option value=""> </option>
			<option value="Y">�O</option>
			<option value="N">�_</option>
		</select>
		<INPUT TYPE=hidden  id="txtBeforePINVDT" name="txtBeforePINVDT" value="">
	</TD>
	</TR>
--%>	 
		<TR id="DArea" style="display:none">
			<TD class="TableHeading" align="right" width="121">�I�ڳW�h�G</TD>
			<TD>
				<select size="1" name="selPayRule" id="selPayRule" onchange="showBankAreaByPayRule( true );">
					<option value="">�ť�</option>
			<%	
			// R00386 - �H�I�ڳW�h���N�M�׽X�P����
			CodeAttr[] attrs = RemittancePayRule.getAllCodeAttr();
			for( int i = 0 ; i < attrs.length ; i++ )
				out.println( "<option value=\"" + attrs[i].getCode() + "\">" + attrs[i].getName() + " " + attrs[i].getCode() + "</option>");
			%>
				</select>
			</TD>
		</TR>
		<TR id="D3Area" style="display:none" >
			<TD ID="PRBankAreaH"  class="TableHeading" align="right" width="121">�ץX�Ȧ�G</TD>
			<TD ID="PRBankArea" width="323"> 
				<SELECT	NAME="selPRBank3" id="selPRBank3" class="Data">
					<%=sbBankCodeD.toString()%>
				</SELECT> 
			</TD>
		</TR>
<!-- R80338 -->	
		<TR id="D4Area" style="display:none" >
			<TD ID=PRBankAreaH class="TableHeading" align="right" width="121">�ץX�Ȧ�G</TD>
			<TD ID=PRBankArea width="323"> 
				<SELECT	NAME="selPRBank4" id="selPRBank4" class="Data">
					<option value="8220635/635131008304">8220635/635131008304-���H�ȴ_��</option>     
				</SELECT> 
			</TD>
		</TR>
<!-- R00386 -->
		<TR id="D5Area" style="display:none" >
			<TD class="TableHeading" align="right" width="121">�ץX�Ȧ�G</TD>
			<TD width="323"> 
				<SELECT	NAME="selPRBank5" id="selPRBank5" class="Data">
					<%=sbfcTriBankCode.toString()%>
				</SELECT> 
			</TD>
		</TR>
<!-- EB0537 -->
		<TR id="D6Area" style="display:none" >
			<TD class="TableHeading" align="right" width="121">�ץX�Ȧ�G</TD>
			<TD width="323"> 
				<SELECT	NAME="selPRBank6" id="selPRBank6" class="Data">
					<%=sbBankCodeD.toString()%>
				</SELECT> 
			</TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtPayRule" name="txtPayRule" value=""> 
<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value=""> 
<INPUT type="hidden" id="txtSYMBOL" name="txtSYMBOL" value="">
<INPUT type="hidden" id="txtPRBank" name="txtPRBank" value="">
<INPUT type="hidden" id="txtPMethod" name="txtPMethod" value="<%=PMETHOD%>"> 
<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value=""> 
<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=msg%>">
</FORM>

</BODY>
</HTML>