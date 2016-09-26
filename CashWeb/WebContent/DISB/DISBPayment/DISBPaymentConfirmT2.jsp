<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : ��I�T�{
 * 
 * Remark   : ��I�\��
 * 
 * Revision : $Revision: 1.5 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2013/12/18 07:22:52 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPaymentConfirmT2.jsp,v $
 * Revision 1.5  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.4  2013/01/08 04:25:57  MISSALLY
 * �N���䪺�{��Merge��HEAD
 *
 * Revision 1.2.4.1  2012/12/06 06:28:23  MISSALLY
 * RA0102�@PA0041
 * �t�X�k�O�ק�S����I�@�~
 *
 * Revision 1.2  2010/11/23 02:24:10  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.7  2008/09/04 06:09:22  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.6  2008/08/06 06:03:08  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.5  2008/06/12 02:10:58  MISODIN
 * R80244 FIN����FIN & ACCT
 * 
 * Revision 1.4  2007/08/03 10:14:27  MISODIN
 * R70477 �~���O��״ڤ���O
 *
 * Revision 1.3  2007/01/04 03:18:43  MISVANESSA
 * R60550_�t�XSPUL&�~���I�ڭק�
 *
 * Revision 1.2  2006/12/07 10:11:11  MISVANESSA
 * R60550_�t�XSPUL&�~���I�ڭק�
 *
 * Revision 1.1  2006/06/29 09:40:49  MISangel
 * Init Project
 *
 * Revision 1.1.2.12  2006/04/27 09:31:44  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.10  2005/04/04 07:02:21  miselsa
 * R30530 ��I�t��
 *  
 */
%><%! String strThisProgId = "DISBPaymentConfirm"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
DecimalFormat df = new DecimalFormat("#.00");
DecimalFormat df2 = new DecimalFormat("#.0000");//R60550

String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";

List alPSrcGrp = new ArrayList();
if (session.getAttribute("SrcGpList") == null) {
	alPSrcGrp = (List) disbBean.getETable("SRCGP", "");
	session.setAttribute("SrcGpList",alPSrcGrp);
} else {
	alPSrcGrp =(List) session.getAttribute("SrcGpList");
}
List alCurrCash = new ArrayList(); //R80132 ���O�D��
if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}

List alPDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
double iSumAmt = 0;		//�`���B
double iUSSumAmt = 0;	//�`���B-����
double iAUSumAmt = 0;	//�`���B-AU   R80132
double iEUSumAmt = 0;	//�`���B-EU   R80132
double iHKSumAmt = 0;	//�`���B-HK   R80132
double iJPSumAmt = 0;	//�`���B-JP   R80132
double iNZSumAmt = 0;	//�`���B-NZ   R80132
double iCNSumAmt = 0;	//�`���B-CN   EB0070

if(session.getAttribute("PDetailList") !=null)
{
	alPDetail = (List)session.getAttribute("PDetailList");

	if (alPDetail!=null)
	{
		if (alPDetail.size()>0)
		{
			for (int k = 0 ; k < alPDetail.size();k++)
			{
				DISBPaymentDetailVO objPDetailCounter = (DISBPaymentDetailVO)alPDetail.get(k);
				if (objPDetailCounter.getStrPCurr().trim().equals("US"))
				{
					iUSSumAmt = iUSSumAmt + objPDetailCounter.getIPAMT();
				} // R80132
				else if (objPDetailCounter.getStrPCurr().trim().equals("AU"))
				{
					iAUSumAmt = iAUSumAmt + objPDetailCounter.getIPAMT();
				}
				else if (objPDetailCounter.getStrPCurr().trim().equals("EU"))
				{
					iEUSumAmt = iEUSumAmt + objPDetailCounter.getIPAMT();
				}
				else if (objPDetailCounter.getStrPCurr().trim().equals("HK"))
				{
					iHKSumAmt = iHKSumAmt + objPDetailCounter.getIPAMT();
				}
				else if (objPDetailCounter.getStrPCurr().trim().equals("JP"))
				{
					iJPSumAmt = iJPSumAmt + objPDetailCounter.getIPAMT();
				}
				else if (objPDetailCounter.getStrPCurr().trim().equals("NZ"))
				{
					iNZSumAmt = iNZSumAmt + objPDetailCounter.getIPAMT();
				}// R80132 END
				else if (objPDetailCounter.getStrPCurr().trim().equals("CN"))
				{
					iCNSumAmt = iCNSumAmt + objPDetailCounter.getIPAMT();
				}
				else
				{
					iSumAmt = iSumAmt + objPDetailCounter.getIPAMT();
				}
			}
			itotalCount = alPDetail.size();
		}
		if(itotalCount%iPageSize == 0)
		{
			itotalpage = itotalCount/iPageSize;
		}
		else
		{
			itotalpage = itotalCount/iPageSize + 1;
		}
	}
}
session.removeAttribute("PDetailList");

//�I�ڤ��
String strPDateHold = (request.getAttribute("txtPDateHold") != null)?(String) request.getAttribute("txtPDateHold"):"";
//��J�������  
String strEEDateHold = (request.getAttribute("txtEEDateHold") != null)?(String) request.getAttribute("txtEEDateHold"):"";

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbPSrcGrp = new StringBuffer();
sbPSrcGrp.append("<option value=\"\">&nbsp;</option>");
if (alPSrcGrp.size() > 0) {
	for (int i = 0; i < alPSrcGrp.size(); i++) {
		htTemp = (Hashtable) alPSrcGrp.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbPSrcGrp.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}
	sbPSrcGrp.append("<option value=\"CSCPAY\">CSC���I��</option>");
	htTemp = null;
	strValue = null;
	strDesc = null;
}
StringBuffer sbCurrCash = new StringBuffer();
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		//R80132 default NT
		if(strValue.equalsIgnoreCase("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}
	htTemp = null;
	strValue = null;
} else {
	sbCurrCash.append("<option value=\"\">&nbsp;</option>");
}
%>
<HTML>
<HEAD>
<TITLE>��I�\��--��I�T�{</TITLE>
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
var iTotalrec =<%=itotalCount%>;
var iAMTA = 0 ;
var iCountA = 0;
var iUSAMTA = 0 ;
var iUSCountA = 0;
var iAMTB = 0 ;
var iCountB= 0;
var iUSAMTB = 0 ;
var iUSCountB= 0;
var iAMTC = 0 ;
var iCountC= 0;
var iUSAMTC = 0 ;
var iUSCountC= 0;
var iCountD= 0;//R60550
var iAMTD= 0;//R60550
var iCountE= 0;//RB0302
var iAMTE= 0;//RB0302

function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value);
		window.close();
	}
}	

function DISBPConfirmAction()
{
	if(IsItemChecked())
	{
		if(getCheckData())
		{
			var strConfirmMsg = "�O�_�T�w�n�����I�T�{�@�~?\n";
			if(iCountA > 0)
			{
				strConfirmMsg = strConfirmMsg + "�䲼����:" + iCountA + "\n�䲼���`�B:" + iAMTA +"\n";
			}
			if(iUSCountA > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_�䲼����:" + iUSCountA + "\n�䲼���`�B:" + iUSAMTA +"\n";
			}
			if(iCountB > 0)
			{
				strConfirmMsg = strConfirmMsg + "�״ڵ���:" + iCountB + "\n�״ڥ��`�B:" + iAMTB +"\n";
			}
			if(iUSCountB > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_�״ڵ���:" + iUSCountB + "\n�״ڥ��`�B:" + iUSAMTB +"\n";
			}
			if(iCountC > 0)
			{
				strConfirmMsg = strConfirmMsg + "�H�Υd����:" + iCountC + "\n�H�Υd���`�B:" + iAMTC +"\n";
			}
			if(iUSCountC > 0)
			{
				strConfirmMsg = strConfirmMsg + "US_�H�Υd����:" + iUSCountC + "\n�H�Υd���`�B:" + iUSAMTC +"\n";
			}
			//R60550
			if(iCountD > 0)
			{
				strConfirmMsg = strConfirmMsg + "�~���״�:" + iCountD + "\n�~���״��`�B:" + iAMTD.toFixed(2) +"\n";
			}
			//RB0302
			if(iCountE > 0)
			{
				strConfirmMsg = strConfirmMsg + "�{������:" + iCountE + "\n�{�����`�B:" + iAMTE +"\n";
			}
			
			var bConfirm = window.confirm(strConfirmMsg);
			if( bConfirm )
			{
				enableAll();
				document.getElementById("txtAction").value = "DISBPaymentConfirm";
				document.getElementById("frmMain").submit();
			}
		}
	}	
}

function mapValue()
{
	document.getElementById("txtPDate").value = rocDate2String(document.getElementById("txtPDateC").value) ;
	document.getElementById("txtEntryStartDate").value = rocDate2String(document.getElementById("txtEntryStartDateC").value) ;	    	 
   	document.getElementById("txtEntryEndDate").value = rocDate2String(document.getElementById("txtEntryEndDateC").value) ;	
}

function getCheckData()
{
	iAMTA = 0 ;
	iCountA = 0;
	iUSAMTA = 0 ;
	iUSCountA = 0;
	iAMTB = 0 ;
	iCountB= 0;
	iUSAMTB = 0 ;
	iUSCountB= 0;
	iAMTC = 0 ;
	iCountC= 0;
	iUSAMTC = 0 ;
	iUSCountC= 0;
	iAMTD = 0 ;//R60550
	iCountD= 0;//R60550
	iCountE = 0;//RB0302
	iAMTE = 0;//RB0302

	var varMsg = "";
	var errCounter = 0;
	for (var i=0;i< iTotalrec;i++ )
	{
		var checkId = "ch" + i ;
		if(document.getElementById(checkId).checked)
		{
			if(document.getElementById("txtPMethod"+i).value == "A")
			{
				if (document.getElementById("txtCurrency"+i).value == "US")
				{
					iUSCountA ++;
					iUSAMTA = iUSAMTA + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
				else
				{
					iCountA ++;
					iAMTA = iAMTA + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
			}
			else  if(document.getElementById("txtPMethod"+i).value == "B")
			{
				if (document.getElementById("txtCurrency"+i).value == "US")
				{
					iUSCountB ++;
					iUSAMTB = iUSAMTB + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
				else
				{
					iCountB ++;
					iAMTB = iAMTB + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
			}
			else  if(document.getElementById("txtPMethod"+i).value == "C")
			{
				if (document.getElementById("txtCurrency"+i).value == "US")
				{
					iUSCountC ++;
					iUSAMTC = iUSAMTC + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
				else
				{
					iCountC ++;
					iAMTC = iAMTC + parseFloat(document.getElementById("txtPAMT"+i).value);
				}
			}
			else  if(document.getElementById("txtPMethod"+i).value == "D")
			{
				iCountD ++;
				iAMTD = iAMTD + parseFloat(document.getElementById("txtPAMT"+i).value);
			//RB0302
			} else if (document.getElementById("txtPMethod" + i).value == "E") {
				iCountE++;
				iAMTE = iAMTE + parseFloat(document.getElementById("txtPAMT" + i).value);
			}
			//PA0024 - �W�[�ˮ֤�I�N�X���o���ť�
			if(errCounter <= 10) {
				if(document.getElementById("txtPsrccode" + i).value == "") {
					varMsg += "�Ǹ�"+(i+1)+" ��I�N�X���ť�\r\n";
					errCounter++;
				}
			}
			//RB0302
			if(document.getElementById("txtPMethod" + i).value == "E" &&
				(!(document.getElementById("txtCurrency"+i).value == "NT" && (document.getElementById("txtPsrccode" + i).value == "E1" || document.getElementById("txtPsrccode" + i).value == "E2") &&
				document.getElementById("txtDispatch" + i).value == "Y"))) {
				varMsg += "�Ǹ�"+(i+1)+" ��������󤧫O��ɴڤ~��{����I\r\n";
				errCounter++;
			}
		}
	}
	if(errCounter > 0) {
		alert(varMsg);
		return false;
	} else {
		return true;
	}
}

function CheckAll()
{
	for (var i=0;i<document.frmMain.elements.length;i++)
	{
		var e = document.frmMain.elements[i];
		if (e.name != 'allbox')
			e.checked = !e.checked;
	}
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnLoad();">
<form name="frmMain" id="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpayment.DISBPConfirmServlet">
<TABLE border=0 width="181">
	<TR>
		<TD><INPUT type=button name="confirmBTN" id="confirmBTN" value="��I�T�{" onclick="DISBPConfirmAction();"></TD>
		<TD><INPUT type=button name="confirmBTN" id="confirmBTN" value="��������" onclick="javascript:window.close();"></TD>
	</TR>
</TABLE>

<BR>
<% if (alPDetail !=null)
{//if1
	if(alPDetail.size()>0)
	{//if2
		int icurrentRec = 0;
		int icurrentPage = 0; // ��0�}�l�p
		int iSeqNo = 0;
		for (int i=0; i<itotalpage;i++)
		{
			icurrentPage = i ;
			for (int j = 0 ; j < iPageSize;j++)
			{
				iSeqNo ++;
				icurrentRec = icurrentPage * iPageSize + j;
				if(icurrentRec < alPDetail.size())
				{
					if( j == 0) // show table head
					{
						if((icurrentPage + 1) == 1)
						{
%>
<div id="showPage<%=icurrentPage+1%>" style="display:">
<%						} else { %>
<div id="showPage<%=icurrentPage+1%>" style="display:none">
<%						} %>
	<table border="1">
		<tr>
			<td><a href='javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage+1%>,1)'> &lt;&lt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage+1%>,2)'>&lt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=icurrentPage+2%>,<%=itotalpage%>,<%=icurrentPage+1%>,3)'>&gt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage+1%>,4)'>&gt;&gt;&nbsp;&nbsp;</a></td>
		</tr>
	</table>
	<hr>

	<table border="0" cellPadding="0" cellSpacing="0" width="1030" id="tblDetail">
		<tbody>
			<TR>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ǹ�</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ŀ�</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�O�渹�X</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="�ө���">�n�O�Ѹ��X</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤH�m�W</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤHID</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="39"><b><font size="2" face="�ө���">���O</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="�ө���">��I���B</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><font size="2" face="�ө���"><b>��I�y�z</b></font></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�I�ڤ��</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="65"><b><font size="2" face="�ө���">�I�ڤ覡</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><font size="2" face="�ө���"><b>�@�o�_</b></font></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><font size="2" face="�ө���"><b>���_</b></font></TD>
				<!--R60550-->
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="39"><b><font size="2" face="�ө���">�~�����O</font></b></TD>
				<TD bgcolor="#c0c0c0" style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black" height="56" width="69"><b><font size="2" face="�ө���">�~�����B</font></b></TD>
			</TR>
<%					}
					DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)alPDetail.get(icurrentRec);
					String strPNo = "";
					String strPolNo = "";
					String strAppNo = "";
					String strPName = "";
					String strPId = "";
					double iPAmt = 0;
					String strPdesc = "";
					String strPMethod="";
					String strPMethodDesc = "";
					int iPDate = 0;
					String strPDate ="";
					String strChecked = "";
					String strDisabled = "";
					String strVoidabled ="";
					String strPDispatch = "";
					String strVoidabledD ="";
					String strPDispatchD = "";
					String strCurrency = "";
					String strPAYCURR = "";//R60550
					double iPAYAMT = 0;//R60550
					String strPsrcCode = "";

					if (objPDetailVO.getStrPNO()!=null)
						strPNo = objPDetailVO.getStrPNO();
					if(strPNo!="")
						strPNo= strPNo.trim();

					if (objPDetailVO.getStrPolicyNo()!=null)
						strPolNo = objPDetailVO.getStrPolicyNo();
					if(strPolNo!="")
						strPolNo= strPolNo.trim();

					if (objPDetailVO.getStrAppNo()!=null)
						strAppNo = objPDetailVO.getStrAppNo();
					if(strAppNo!="")
						strAppNo=strAppNo.trim();

					if (objPDetailVO.getStrPName()!=null)
						strPName = objPDetailVO.getStrPName();
					if(strPName !="")
						strPName = strPName.trim();

					if (objPDetailVO.getStrPId()!=null)
						strPId = objPDetailVO.getStrPId();
					if(strPId!="")
						strPId = strPId.trim();

					if (objPDetailVO.getStrPSrcCode()!=null)
						strPsrcCode = objPDetailVO.getStrPSrcCode();
					if (strPsrcCode!="")
						strPsrcCode = strPsrcCode.trim();

					if (objPDetailVO.getStrPDesc()!=null)
						strPdesc = strPsrcCode + objPDetailVO.getStrPDesc();
					if(strPdesc!="")
						strPdesc = strPdesc.trim();

					if (objPDetailVO.getStrPCurr()!=null)
						strCurrency = objPDetailVO.getStrPCurr();
					if(strCurrency!="")
						strCurrency = strCurrency.trim();

					if (objPDetailVO.getStrPMethod()!=null)
						strPMethod = objPDetailVO.getStrPMethod();
					if(strPMethod!="")
					{
						strPMethod = strPMethod.trim();
						if (strPMethod.equals("A"))
							strPMethodDesc = "�䲼";
						if (strPMethod.equals("B"))
							strPMethodDesc = "�״�";
						if (strPMethod.equals("C"))
							strPMethodDesc = "�H�Υd";
						if (strPMethod.equals("D"))
							strPMethodDesc = "�~���״�";//R60550
						if (strPMethod.equals("E"))
							strPMethodDesc = "�{��";
					}

					if (objPDetailVO.getStrPDispatch()!=null)
						strPDispatch = objPDetailVO.getStrPDispatch();
					if(strPDispatch!="")
					{
						strPDispatch = strPDispatch.trim();
						if (strPDispatch.equals("Y"))
							strPDispatchD ="�O";
						else
							strPDispatchD = "�_";
					}

					if (objPDetailVO.getStrPVoidable()!= null)
						strVoidabled = objPDetailVO.getStrPVoidable();
					if(strVoidabled!="")
					{
						strVoidabled = strVoidabled.trim();
						if (strVoidabled.equals("Y"))
							strVoidabledD ="�O";
						else
							strVoidabledD = "�_";
					}
					if (objPDetailVO.isChecked())
					{
						strChecked = "checked";
					}
					if (objPDetailVO.isDisabled())
					{
						strDisabled = "disabled";
					}
		           	iPAmt = objPDetailVO.getIPAMT();
		           	iPDate = objPDetailVO.getIPDate();
		           	if(iPDate == 0)
		           		strPDate = "";
		           	else
		           		strPDate = Integer.toString(iPDate);
		           	//R60550�~�����O.���B
		           	if (objPDetailVO.getStrPPAYCURR()!= null)
		           		strPAYCURR = objPDetailVO.getStrPPAYCURR();
		           	if(strCurrency!="")
		           		strPAYCURR = strPAYCURR.trim();
		           	iPAYAMT = objPDetailVO.getIPPAYAMT();
%>
			<TR id=data>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><%=icurrentRec+1%></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><INPUT type="checkbox" name="ch<%=icurrentRec%>" id="ch<%=icurrentRec%>" value="Y" <%=strChecked%> <%=strDisabled%>> <INPUT name="txtPNo<%=icurrentRec%>" id="txtPNo<%=icurrentRec%>" type="hidden" value="<%=strPNo%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><%=strPolNo%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="92"><%=strAppNo%>&nbsp;</TD> 
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strPName%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="78"><%=strPId%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="39"><%=strCurrency%>&nbsp; <INPUT name="txtCurrency<%=icurrentRec%>" id="txtCurrency<%=icurrentRec%>" type="hidden" value="<%=strCurrency%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="69"><%=df.format(iPAmt)%>&nbsp; <INPUT name="txtPAMT<%=icurrentRec%>" id="txtPAMT<%=icurrentRec%>" type="hidden" value="<%=iPAmt%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="92"><%=strPdesc%>&nbsp; <INPUT type="hidden" id="txtPsrccode<%=icurrentRec%>" name="txtPsrccode<%=icurrentRec%>" value="<%=strPsrcCode%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64"><%=iPDate%>&nbsp; <INPUT name="txtPDATE<%=icurrentRec%>" id="txtPDATE<%=icurrentRec%>" type="hidden" value="<%=iPDate%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="65"><%=strPMethodDesc%>&nbsp; <INPUT name="txtPMethod<%=icurrentRec%>" id="txtPMethod<%=icurrentRec%>" type="hidden" value="<%=strPMethod%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="53"><%=strVoidabledD%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="53"><%=strPDispatchD%>&nbsp; <INPUT type="hidden" id="txtDispatch<%=icurrentRec%>" name="txtDispatch<%=icurrentRec%>" value="<%=strPDispatch%>"></TD>
				<!--R60550-->
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="39"><%=strPAYCURR%>&nbsp; <INPUT name="txtCurrency<%=icurrentRec%>" id="txtCurrency<%=icurrentRec%>" type="hidden" value="<%=strPAYCURR%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="69"><%=df2.format(iPAYAMT)%>&nbsp; <INPUT name="txtPAYAMT<%=icurrentRec%>" id="txtPAYAMT<%=icurrentRec%>" type="hidden" value="<%=iPAYAMT%>"></TD>
			</TR>
<%					if((iSeqNo == iPageSize) || (icurrentRec == (alPDetail.size()-1) ) || (iSeqNo%iPageSize == 0) )
					{ %>
		</tbody>
	</table>
</div>
<%					}
				} // end of if --> inowRec < alPDetail.size()
			}// end of for -- show detail
		}//end of for
%>
<input name="allbox" type="checkbox" onClick="CheckAll();">
�`���� : <%=itotalpage%> &nbsp;&nbsp;�`��� : <%=itotalCount%> &nbsp;&nbsp;&nbsp;&nbsp;�`���B:<%=df.format(iSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp;�~�������O���`���B:<%=df.format(iUSSumAmt)%> 
<BR>
AU�O���`���B�G<%=df.format(iAUSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp; EU�O���`���B�G<%=df.format(iEUSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp; HK�O���`���B�G<%=df.format(iHKSumAmt)%>
<BR>
JP�O���`���B�G<%=df.format(iJPSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp; NZ�O���`���B�G<%=df.format(iNZSumAmt)%> &nbsp;&nbsp;&nbsp;&nbsp; CN�O���`���B�G<%=df.format(iCNSumAmt)%>
<%	} //end of if2
}//end of if1
else
{ %>
<table border="0" cellPadding="0" cellSpacing="0" width="1030" id="tblDetail">
	<tbody>		       
       	<TR>
       		<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ǹ�</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><b><font size="2" face="�ө���">�Ŀ�</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�O�渹�X</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="92"><b><font size="2" face="�ө���">�n�O�Ѹ��X</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤH�m�W</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="78"><b><font size="2" face="�ө���">���ڤHID</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="�ө���">��I���B</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><b><font size="2" face="�ө���">��I�y�z</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><b><font size="2" face="�ө���">�I�ڤ��</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="60"><b><font size="2" face="�ө���">�I�ڤ覡</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="�ө���">�@�o�_</font></b></TD>
			<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="53"><b><font size="2" face="�ө���">���_</font></b></TD>
			<!--R60550-->
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="�ө���">�~�����O</font></b></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="69"><b><font size="2" face="�ө���">�~�����B</font></b></TD>
		</TR>
	</tbody>
</table>
<%}%>

<INPUT type="hidden" id="txtTpage" name="txtTpage" value="<%=itotalpage%>">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtPDateHold" name="txtPDateHold" value="<%=strPDateHold%>">
<INPUT type="hidden" id="txtEEDateHold" name="txtEEDateHold" value="<%=strEEDateHold%>">
<INPUT type="hidden" id="FNP" name="FNP" value="Y">
</form>
</BODY>
</HTML>