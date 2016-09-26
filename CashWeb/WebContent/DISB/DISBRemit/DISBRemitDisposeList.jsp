<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.codeAttr.CodeAttr" %>
<%@ page import="com.aegon.codeAttr.RemittancePayRule" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : �״ڥ\��--���״ڧ@�~(�T�{)
 * 
 * Remark   : �X�ǥ\��-���״�
 * 
 * Revision : $Revision: 1.21 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2014/08/25 02:16:25 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBRemitDisposeList.jsp,v $
 * Revision 1.21  2014/08/25 02:16:25  missteven
 * RC0036-3
 *
 * Revision 1.20  2014/07/18 07:31:02  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.19  2014/02/26 06:39:32  MISSALLY
 * EB0537 --- �s�W�U���Ȧ欰�~�����w�Ȧ�
 *
 * Revision 1.18  2013/03/29 09:55:05  MISSALLY
 * RB0062 PA0047 - �s�W���w�Ȧ� ���ƻȦ�
 *
 * Revision 1.17  2012/08/29 02:57:53  ODCKain
 * Calendar problem
 *
 * Revision 1.16  2012/05/18 10:07:42  MISSALLY
 * BUG-FIX �h�����B�e���ť�
 *
 * Revision 1.15  2011/11/08 09:16:39  MISSALLY
 * Q10312
 * �״ڥ\��-���״ڧ@�~
 * 1.�ץ��Ȧ�b�����@�P
 * 2.�վ���׶״���
 *
 * Revision 1.14  2011/10/24 07:59:03  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 * FIX �X�ǽT�{��P��I�T�{����A��I�T�{�骺�e���W�[�a�ť�
 *
 * Revision 1.13  2011/10/24 03:53:33  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 * Revision 1.12  2011/10/21 10:04:38  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 * Revision 1.10  2008/08/18 06:16:30  MISODIN
 * R80338 �վ�Ȧ�b����檺�w�]��
 *
 * Revision 1.9  2008/08/07 05:08:10  MISODIN
 * R80338 �վ�CASH�t�� for �X�ǥ~���@��@�ݨD
 *
 * Revision 1.8  2008/08/06 07:07:02  MISODIN
 * R80338 �վ�CASH�t�� for �X�ǥ~���@��@�ݨD
 *
 * Revision 1.7  2007/08/03 10:12:22  MISODIN
 * R70477 �~���O��״ڤ���O
 *
 * Revision 1.6  2007/03/06 01:49:55  MISVANESSA
 * R70088_SPUL�t��������W��I�Ȧ�ña�J
 *
 * Revision 1.5  2006/12/07 22:00:57  miselsa
 * R60463��R60550�~����SPUL�O��
 *
 * Revision 1.4  2006/11/29 08:07:41  miselsa
 * R60463��R60550�~����SPUL�O��
 *
 * Revision 1.3  2006/09/25 06:36:15  miselsa
 * R60747�B�z�e���W�[�`���BNan�����D
 *
 * Revision 1.2  2006/09/04 09:47:07  miselsa
 * R60747_1.���״ڼW�[�X�ǽT�{�� 2.�ץX����״ڤ���אּ�X�ǽT�{�� 3.��I�d�ߥI�ڤ�����X�ǽT�{��
 *
 * Revision 1.1  2006/06/29 09:39:46  MISangel
 * Init Project
 *
 * Revision 1.1.2.5  2006/04/27 09:41:44  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.4  2005/04/18 08:54:28  MISANGEL
 * R30530:��I�t��
 *
 * Revision 1.1.2.3  2005/04/04 07:02:25  miselsa
 * R30530 ��I�t��
 *  
 */
%><%! String strThisProgId = "DISBRemitDispose"; //���{���N�� %><%
DecimalFormat df = new DecimalFormat("#.00");
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPBBankD = new ArrayList(); //R70477
List alPBBankP = new ArrayList(); //R80338
List alPBBankFR = new ArrayList();

if (session.getAttribute("PBBankListD") == null) {
	//R00386 - �t�� 
	//if ("B01T01F".equals(request.getAttribute("payRule")!=null?(String)request.getAttribute("payRule"):"")){
		alPBBankD = (List) disbBean.getETable("PBKAT", "BANKDC");
	//}else if ("B01T01B".equals(request.getAttribute("payRule")!=null?(String)request.getAttribute("payRule"):"")){ //�D�t��
	//	Hashtable htETtable = new Hashtable();
	//	htETtable.put("ETType","PBKAT");
	//	htETtable.put("ETValue","8220635/635131008304");
	//	htETtable.put("ETVDesc","���H�ȴ_�� ");
	//	alPBBankD.add(htETtable);
	//}else{
	//	alPBBankD.addAll( disbBean.getETable("BNKPR", "BANKPR") );	// R00386, �[�J�ǲΫ������O��Ϊ��״ڻȦ�
	//}
	session.setAttribute("PBBankListD",alPBBankD);
} else {
	alPBBankD =(List) session.getAttribute("PBBankListD");
}
// R80338
if (session.getAttribute("PBBankListP") == null) {
	alPBBankP = (List) disbBean.getETable("PBKAT", "BANKP");
	session.setAttribute("PBBankListP",alPBBankP);
} else {
	alPBBankP =(List) session.getAttribute("PBBankListP");
}

if (session.getAttribute("fcTriBankCodeList") == null) {
	alPBBankFR = (List) disbBean.getETable("BNKFR", "BANKFRC");
	session.setAttribute("fcTriBankCodeList", alPBBankFR );
} else {
	alPBBankFR = (List) session.getAttribute("fcTriBankCodeList");
}

double total = 0;
List vo = (List)request.getAttribute("vo");
int count = (vo == null?0:vo.size());

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;


StringBuffer sbBankCode = new StringBuffer();
if(request.getAttribute("PMETHOD").equals("B")) 
{	   
	if(request.getAttribute("pDispatch").equals("Y")) {//RC0036 
       sbBankCode.append("<option value=\"8120610/06120001666600\">8120610/06120001666600-�x�s���</option>");//RC0036
    }else{//RC0036
	   sbBankCode.append("<option value=\"8220635/635530015707\">8220635/635530015707-���H�ȴ_��</option>");
	}                                              //RC0036 
	if (alPBBankP.size() > 0) {
		for (int i = 0; i < alPBBankP.size(); i++) {
			htTemp = (Hashtable) alPBBankP.get(i);
			strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
			strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));
			if(strValue.equals(request.getAttribute("SELPRBank")))
				sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
			else
				sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
		}
	} else {  
		sbBankCode.append("<option value=\"\">&nbsp;</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
else if(request.getAttribute("PMETHOD").equals("D"))
{
	sbBankCode.append("<option value=\"\">&nbsp;</option>");

	if (alPBBankD != null && alPBBankD.size() > 0) {
		for (int i = 0; i < alPBBankD.size(); i++) {
			htTemp = (Hashtable) alPBBankD.get(i);
			strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
			strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));
			if(strValue.equals(request.getAttribute("SELPRBank")))
				sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
			else
				sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
		}
	}

	htTemp = null;
	strValue = null;
	strDesc = null;

	if (alPBBankFR != null && alPBBankFR.size() > 0) {
		for (int i = 0; i < alPBBankFR.size(); i++) {
			htTemp = (Hashtable) alPBBankFR.get(i);
			strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
			strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));
			if(strValue.equals(request.getAttribute("SELPRBank")))
				sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
			else
				sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
		}
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
else 
{
	if (alPBBankP.size() > 0) {
    	for (int i = 0; i < alPBBankP.size(); i++) {
			htTemp = (Hashtable) alPBBankP.get(i);
			strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
			strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));
			if(strValue.equals(request.getAttribute("SELPRBank")))
				sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
			else
				sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
		}
	} else {
		sbBankCode.append("<option value=\"\">&nbsp;</option>");
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
<SCRIPT language="JavaScript">
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
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
	window.status = "";
}

function DISBRemitAction()
{
    WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyRemitL,'' );
}

function confirmAction()
{
	mapValue();
	if(checkField()){
		document.frmMain.submit();
	}
}

function resetAction()
{
	alert("yes, u just click the reset button,\n but i didnt done it yet");
}

function exitAction()
{
	history.back(-1);
}

/**
��ƦW��:	checkClientField(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function checkField()
{
	var bReturnStatus = false;
	var strTmpMsg = "";
	if(document.getElementById("txtPCSHCMC").value=="")
	{
	   alert( "�п�J�X�ǽT�{��!" );
	   return bReturnStatus;
	}
	<%if (request.getAttribute("PMETHOD").equals("B") &&
		      request.getAttribute("pDispatch").equals("Y") &&
		      request.getAttribute("selCurrency").equals("NT")){%>
	if(document.getElementById("txtCHKNO").value=="")
	{
	   alert( "�п�J�䲼���X!" );
	   return bReturnStatus;
	}
	<%}%>
	var chk = document.getElementsByName("PNO");
	for(var index = 0; index<chk.length; index++){
		if(chk[index].checked){
			bReturnStatus = true;
			break;
		}
	}
	if(!bReturnStatus){
		alert( "�ФĿ���״ڪ��O��!" );
	}
	
	// �[�J�X�ǽT�{�骺�P�_
	bReturnStatus = checkPayDate();
	
	return bReturnStatus;
}

// R00386
function checkPayDate() 
{
	// �o�O�w��~���״ڦӰ����ˬd
	var payMethod = document.getElementById( "PMETHOD" ).value;
	if( payMethod != "D" )
		return true;
	
	// ����X�ǽT�{��P��I�T�{��
	var chk = document.getElementsByName("PNO");
	var index, seqNo;
	var hightlight;
	var warnCount = 0;
	var errorMsg = "";
	var tooManyErrMsg = "";
	var payDateStr = document.getElementById( "txtPCSHCMC" ).value;	// ���W��J���X�ǽT�{��
	var payDate = parseInt( payDateStr.replace( /[/]/g, "" ), 10 );
	// �D�靈���Ī��Ӥ��
	for( index = 0; index < chk.length; index++ )
	{
		seqNo = index + 1;
		hightlight = false;

		if( chk[index].checked ){
			var checkedPayDate = document.getElementById( "CheckedPayDate_" + seqNo ).innerHTML;
			if( payDate != checkedPayDate ) {
				warnCount++;
				hightlight = true;
				if( warnCount > 10 )
					tooManyErrMsg = "\n    (�W�L��ܤW���A���C��ܦh��� 10 ����ơA��l�����Ъ����Ѹ�ƪ��d��)";
				else
					errorMsg += ( "\n    �� �� " + seqNo + " ��, �X�ǽT�{������ " + checkedPayDate );
			}
		}

		var currentRow = document.getElementById( "dataRow_" + seqNo );
		if( hightlight )
			currentRow.style.background = "yellow";
		else
			currentRow.style.background = "";
	}

	if( warnCount == 0 )
		return true;

	errorMsg += tooManyErrMsg;
	errorMsg += "\n\n�O�_���n������״�";
	errorMsg += "\n    �y�O�z�N�X�ǽT�{��g��I���";
	errorMsg += "\n    �y�_�z���N�X�ǽT�{��g��I���";
	errorMsg = ( "WARNING!!! �ˮ֥X�ǽT�{��@�� " + warnCount + " �����ŦX (�H������аO)�A���e�p�U�G\n" ) + errorMsg;
	return confirm( errorMsg );
}

function calculateAmt()
{
	var amt = 0.00;
	var count = 0;
	var t1 = document.all("tbl").childNodes[0];

	var chk = document.getElementsByName("PNO");
	for(var index=0; index<chk.length ; index++ ){
		if(chk[index].checked){
			count = count+1;
			amt = amt + parseFloat(t1.rows[index+1].cells[6].innerHTML.substr(3));
		}
	}

	var t2 = document.all("tbl2").childNodes[0];
	t2.rows[0].cells[1].innerHTML = count;
	t2.rows[0].cells[5].innerHTML = amt;
}

function mapValue()
{
	document.getElementById("txtPCSHCM").value = rocDate2String(document.getElementById("txtPCSHCMC").value);
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitDisposeServlet?action=update" id="frmMain" method="post" name="frmMain">
<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value=""> 
<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="">
<INPUT type="hidden" id="PMETHOD" name="PMETHOD" value="<%=request.getAttribute("PMETHOD")%>">
<INPUT type="hidden" id="pDispatch" name="pDispatch" value="<%=request.getAttribute("pDispatch")%>"> <!-- RC0036 -->
<% if(vo.size() > 0){ %>
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
				<select size="1" name="PBBANK" id="PBBANK" class="Data">
					<%=sbBankCode.toString()%>
				</select>
			</TD>
		</TR>
		<%if (request.getAttribute("PMETHOD").equals("B") &&
		      request.getAttribute("pDispatch").equals("Y") &&
		      request.getAttribute("selCurrency").equals("NT")){%>
		<TR>
			<TD align="right" class="TableHeading" width="101">�䲼���X�G</TD>
			<TD width="333">
				<input type="text" name="txtCHKNO" size="15"/>
			</TD>
		</TR>
		<%}%>	
	</TBODY>
</TABLE>
<br>
<TABLE id="tbl" border="0" cellpadding="0" cellspacing="0" width="850">
	<TBODY>
		<TR>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><B><FONT size="2" face="�ө���">�Ǹ�</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><B><FONT size="2" face="�ө���">�Ŀ�</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><B><FONT size="2" face="�ө���">�O�渹�X</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="68"><B><FONT size="2" face="�ө���">�n�O�Ѹ��X</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="77"><B><FONT size="2" face="�ө���">���ڤH�m�W</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="71"><B><FONT size="2" face="�ө���">���ڤHID</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="82"><B><FONT size="2" face="�ө���">��I���B</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><B><FONT size="2" face="�ө���">�I�ڤ��e</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="�ө���">�I�ڤ��</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="70"><B><FONT size="2" face="�ө���">�I�ڤ覡</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="65"><B><FONT size="2" face="�ө���">���_</FONT></B></TD>
<%	if(request.getAttribute("PMETHOD").equals("D") && request.getAttribute("SYMBOL").equals("S")) { %>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="82"><B><FONT size="2" face="�ө���">�~�����B</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="82"><B><FONT size="2" face="�ө���">�������</FONT></B></TD>
<%	} %>	
		</TR>
<%	DISBPaymentDetailVO paymentDetail = null;
	String strPayMethodCode = "";
	String strPayMethodDesc = "";
	for(int index = 0 ; index < vo.size() ; index++) {
		paymentDetail = (DISBPaymentDetailVO)vo.get(index);
		total += paymentDetail.getIPAMT();
	
		strPayMethodCode = CommonUtil.AllTrim(paymentDetail.getStrPMethod());
		if("A".equals(strPayMethodCode)) {
			strPayMethodDesc = "�䲼";
		} else if("B".equals(strPayMethodCode)) {
			strPayMethodDesc = "�״�";					
		} else if("C".equals(strPayMethodCode)) {
			strPayMethodDesc = "�H�Υd";					
		} else if("D".equals(strPayMethodCode)) {
			strPayMethodDesc = "��~�״�";					
		} %>
		<TR id="dataRow_<%=index+1%>" >
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><%=index+1%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><INPUT type="checkbox" checked name="PNO" id="PNO" value="<%=paymentDetail.getStrPNO()%>" onClick="calculateAmt();"></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64">&nbsp;<%=paymentDetail.getStrPolicyNo()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="68">&nbsp;<%=paymentDetail.getStrAppNo()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="77">&nbsp;<%=paymentDetail.getStrPName()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="71">&nbsp;<%=paymentDetail.getStrPId()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="82" id="PAMT"><%=paymentDetail.getStrPCurr()%><%=df.format(paymentDetail.getIPAMT())%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="67">&nbsp;<%=paymentDetail.getStrPDesc()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="58">&nbsp;<%=paymentDetail.getIPDate()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="70">&nbsp;<%=strPayMethodDesc%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="65">&nbsp;<%=("Y".equals(paymentDetail.getStrPDispatch())?"�O":"�_")%></TD>
<%		if(request.getAttribute("PMETHOD").equals("D") && request.getAttribute("SYMBOL").equals("S")) { %>			
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="82"><%=paymentDetail.getStrPPAYCURR()%><%=df.format(paymentDetail.getIPPAYAMT())%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="82"><span id="CheckedPayDate_<%= index + 1 %>"><%=paymentDetail.getCheckedPayDate() %></span></TD>
<%		} %>	
		</TR>
<%	} %>
	</TBODY>
</TABLE>
<BR>
<table id="tbl2">
	<tr><td>�`��� :  </td><td><%=count %></td><td></td><td></td><td>�`���B : </td><td><%=df.format(total)%></td></tr>
</table>
<% } %>

<input type="hidden" id="PMETHOD" name="PMETHOD" value="<%=request.getAttribute( "PMETHOD" )%>">
</FORM>
</BODY>
</HTML>