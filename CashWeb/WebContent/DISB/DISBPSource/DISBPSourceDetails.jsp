<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ page import="org.apache.regexp.RE" %>
<%@ include file="/Logon/Init.inc"%>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �浧���Ӻ��@
 * 
 * Remark   : ��I�ӷ�
 * 
 * Revision : $Revision: 1.15 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : 2005/04/04
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPSourceDetails.jsp,v $
 * Revision 1.15  2014/07/18 07:28:32  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.14  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.13  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 *
 * Revision 1.12  2012/08/29 02:57:50  ODCKain
 * Calendar problem
 *
 * Revision 1.11  2011/11/01 07:41:43  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 * FIX �I�ڤ覡��(�~��)�״ڮɡA�������ˮֲ����x�s�νT�{�ɦA�ˮ�
 *
 * Revision 1.10  2011/10/21 10:04:37  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 * Revision 1.7  2008/08/12 06:56:19  misvanessa
 * R80480_�W���Ȧ�~�������s�ɮ�
 *
 * Revision 1.6  2008/04/30 07:50:07  misvanessa
 * R80300_�������x�s,�s�W�U���ɮפγ���
 *
 * Revision 1.5  2007/09/07 10:39:53  MISVANESSA
 * R70455_TARGET OUT
 *
 * Revision 1.4  2007/01/31 08:04:06  MISVANESSA
 * R70088_SPUL�t��
 *
 * Revision 1.3  2007/01/15 06:47:37  MISVANESSA
 * R60550_SPUL&VA�����~���״�
 *
 * Revision 1.2  2007/01/04 03:22:33  MISVANESSA
 * R60550_�~���״ڻȦ����覡�ק�
 *
 * Revision 1.1  2006/06/29 09:40:48  MISangel
 * Init Project
 *
 * Revision 1.1.2.12  2006/04/27 09:35:39  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.11  2005/05/13 02:31:12  miselsa
 * R30530_�����ҥi�ק�
 *
 * Revision 1.1.2.10  2005/04/22 06:25:14  miselsa
 * R30530_�[�j�m�W���
 *
 * Revision 1.1.2.9  2005/04/22 06:18:41  miselsa
 * R30530_�[�j�m�W���
 *
 * Revision 1.1.2.8  2005/04/04 07:02:24  miselsa
 * R30530 ��I�t��
 *  
 */
%><%! String strThisProgId = "DISBPSourceDetails"; //���{���N�� %><%
DecimalFormat df = new DecimalFormat("#.00");
DecimalFormat df2 = new DecimalFormat("#.0000");//R60550
RE reSpace = new RE(" ");

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	

String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";
String strBack = (request.getAttribute("txtParent") != null)?(String) request.getAttribute("txtParent"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserId")):"";

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPDetail = new ArrayList();
if(session.getAttribute("PDetailList") != null)
{
	alPDetail = (List)session.getAttribute("PDetailList");
}
session.removeAttribute("PDetailList");

String strPNo = "";
String strPolNo = "";
String strAppNo = "";
String strPName = "";
String strPId = "";
double iPAmt = 0;
String strPdesc = "";
String strPMethod="";
//String strPMethodDesc = "";
String strPRBank="";
String strPRAccount="";
String strPCrdNo="";
String strPCrdType="";
String strPCrdEffMY="";
String strPCrdEffM="";
String strPCrdEffY="";
String strPAuthCode="";     
int iPDate = 0;
String strPDate = "";
String strVoidabled="";
String strPDispatch = "";
String strPChkm1="";
String strPChkm2="";
String strPSrcGp="";
String strPSrcCode="";
String strBranch="";
String strCurrency ="";
String strUsrInfo ="";//RC0036
int iPAuthDt = 0;
String strPAuthDt = "";
//R60550�s�W12���
String strPAYCURR ="";
double iPAYRATE =0;
double iPAYAMT =0;
String strPFEEWAY ="";
String strSYMBOL ="";
int iINVDT = 0;
String strINVDTC ="";
String strPSWIFT ="";
String strPBKBRCH ="";
String strPBKCITY ="";
String strPBKCOTRY ="";
String strPENGNAME ="";
double iFPAYAMT =0;
String strFFEEWAY ="";
int iENTRYDT = 0;//R70088
String strENTRYDTC ="";//R70088
String strPOrgCrdNo = "";//R80300
double iPOrgAMT = 0;//R80300

if (alPDetail.size()>0)
{
	DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)alPDetail.get(0);

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

	if (objPDetailVO.getStrPDesc()!=null)
		strPdesc = objPDetailVO.getStrPDesc();	
	if(strPdesc!="")
		strPdesc = strPdesc.trim();

	if (objPDetailVO.getStrPMethod()!=null)
		strPMethod = objPDetailVO.getStrPMethod();	
	if(strPMethod!="")
	{
		strPMethod = strPMethod.trim();
		/*
		if (strPMethod.equals("A"))
			strPMethodDesc = "�䲼";
		if (strPMethod.equals("B"))
			strPMethodDesc = "�״�";
		if (strPMethod.equals("C"))
			strPMethodDesc = "�H�Υd";	
		*/		
	}

	if (objPDetailVO.getStrPRBank()!=null)
		strPRBank = objPDetailVO.getStrPRBank();	
	if(strPRBank!="")
		strPRBank = strPRBank.trim();	

 	if (objPDetailVO.getStrPRAccount()!=null)
		strPRAccount = objPDetailVO.getStrPRAccount();	
	if(strPRAccount!="")
		strPRAccount = strPRAccount.trim();

	if (objPDetailVO.getStrPCrdNo()!=null)
		strPCrdNo = objPDetailVO.getStrPCrdNo();	
	if(strPCrdNo!="")
		strPCrdNo = strPCrdNo.trim();

	if (objPDetailVO.getStrPCrdType()!=null)
		strPCrdType = objPDetailVO.getStrPCrdType();	
	if(strPCrdType!="")
		strPCrdType = strPCrdType.trim();

	if (objPDetailVO.getStrPCrdEffMY()!=null)
		strPCrdEffMY = objPDetailVO.getStrPCrdEffMY();	
	if(strPCrdEffMY!="")
	{
		strPCrdEffMY = strPCrdEffMY.trim();	
		//System.out.println("strPCrdEffMY.length()="+strPCrdEffMY.length());	
		if(strPCrdEffMY.length()>0)
		{
			strPCrdEffM = strPCrdEffMY.substring(0,2);
			strPCrdEffY = strPCrdEffMY.substring(2,6);
		}
	}

	//R80300 ���d��
	if (objPDetailVO.getStrPOrgCrdNo() != null)
		strPOrgCrdNo = objPDetailVO.getStrPOrgCrdNo();
	if (strPOrgCrdNo != "")
		strPOrgCrdNo = strPOrgCrdNo.trim();
	//R80300 �����B
	iPOrgAMT = objPDetailVO.getIPOrgAMT();        	

	if (objPDetailVO.getStrPAuthCode()!= null)
		strPAuthCode = objPDetailVO.getStrPAuthCode();
	if(strPAuthCode!="")
		strPAuthCode = strPAuthCode.trim();

	if (objPDetailVO.getStrPDispatch()!= null)
		strPDispatch = objPDetailVO.getStrPDispatch();
	if(strPDispatch!="")
		strPDispatch = strPDispatch.trim();
	//System.out.println("strPDispatch="+strPDispatch);               
	if (objPDetailVO.getStrPVoidable()!= null)
		strVoidabled = objPDetailVO.getStrPVoidable();
	if(strVoidabled!="")
		strVoidabled = strVoidabled.trim();
	//System.out.println("strVoidabled="+strVoidabled);          	
	if (objPDetailVO.getStrPChkm1()!= null)
		strPChkm1 = objPDetailVO.getStrPChkm1();
	if(strPChkm1!="")
		strPChkm1 = strPChkm1.trim();
	//System.out.println("strPChkm1="+strPChkm1);
	if (objPDetailVO.getStrPChkm2()!= null)
		strPChkm2 = objPDetailVO.getStrPChkm2();
	if(strPChkm2!="")
		strPChkm2= strPChkm2.trim();
	//System.out.println("strPChkm2="+strPChkm2);
	if (objPDetailVO.getStrPSrcGp()!= null)
		strPSrcGp = objPDetailVO.getStrPSrcGp();
	if(strPSrcGp!="")
		strPSrcGp= strPSrcGp.trim();		

	if (objPDetailVO.getStrPSrcCode()!= null)
		strPSrcCode = objPDetailVO.getStrPSrcCode();
	if(strPSrcCode!="")
		strPSrcCode= strPSrcCode.trim();
	//System.out.println("$$$strPSrcCode="+strPSrcCode);
	if (objPDetailVO.getStrBranch()!= null)
		strBranch = objPDetailVO.getStrBranch();	
	if(strBranch!="")
		strBranch = strBranch.trim();

	if (objPDetailVO.getStrPCurr() != null)
		strCurrency = objPDetailVO.getStrPCurr();	
	if(strCurrency!="")
		strCurrency = strCurrency.trim();
//RC0036
	if (objPDetailVO.getStrUsrInfo() != null)
		strUsrInfo = objPDetailVO.getStrUsrInfo();	
    if (strUsrInfo!="")
		strUsrInfo = strUsrInfo.trim();

	iPAmt = objPDetailVO.getIPAMT();

	iPDate = objPDetailVO.getIPDate();	  
	if(iPDate == 0)
		strPDate = "";
	else
		strPDate = Integer.toString(iPDate);	

	iPAuthDt = objPDetailVO.getIPAuthDt();
	if(iPAuthDt == 0)
		strPAuthDt = "";	
	else
		strPAuthDt = Integer.toString(iPAuthDt);
	//R60550
	if (objPDetailVO.getStrPPAYCURR() != null)
		strPAYCURR = objPDetailVO.getStrPPAYCURR().trim();
	else
		strPAYCURR = "";

	iPAYRATE = objPDetailVO.getIPPAYRATE();   

	iPAYAMT = objPDetailVO.getIPPAYAMT();

	if (objPDetailVO.getStrPFEEWAY() != null)
		strPFEEWAY = objPDetailVO.getStrPFEEWAY().trim();
	else
		strPFEEWAY = "";   

	if (objPDetailVO.getStrPSWIFT() != null)
		strPSWIFT = objPDetailVO.getStrPSWIFT().trim();
	else
		strPSWIFT = "";

	if (objPDetailVO.getStrPBKBRCH() != null)
		strPBKBRCH = objPDetailVO.getStrPBKBRCH().trim();
	else
		strPBKBRCH = "";

	if (objPDetailVO.getStrPBKCITY() != null)
		strPBKCITY = objPDetailVO.getStrPBKCITY().trim();
	else
		strPBKCITY = "TP";  //RA0074 ���w��l��

	if (objPDetailVO.getStrPBKCOTRY() != null)
		strPBKCOTRY = objPDetailVO.getStrPBKCOTRY().trim();
	else
		strPBKCOTRY = "TW"; //RA0074 ���w��l��

	if (objPDetailVO.getStrPENGNAME() != null)
		strPENGNAME = objPDetailVO.getStrPENGNAME().trim();
	else
		strPENGNAME = "";

	iINVDT = objPDetailVO.getIPINVDT();
	if (iINVDT == 0)
		strINVDTC = "";
	else
		strINVDTC = Integer.toString(iINVDT);

	if (objPDetailVO.getStrPSYMBOL() != null)
		strSYMBOL = objPDetailVO.getStrPSYMBOL().trim();
	else
		strSYMBOL = "";

	iFPAYAMT = objPDetailVO.getFPAYAMT();

	if (objPDetailVO.getFFEEWAY() != null)
		strFFEEWAY = objPDetailVO.getFFEEWAY().trim();
	else
		strFFEEWAY = "";
	//R70088 ���_�l��O�P��J����
	iENTRYDT = objPDetailVO.getIEntryDt();
	if (iENTRYDT == 0)
		strENTRYDTC = "";
	else
		strENTRYDTC = Integer.toString(iENTRYDT);
}

List alPSrcCode = new ArrayList();
if (session.getAttribute("SrcCdList") == null) {
	alPSrcCode = (List) disbBean.getETable("PAYCD", "");
	session.setAttribute("SrcCdList",alPSrcCode);
} else {
	alPSrcCode =(List) session.getAttribute("SrcCdList");
}

List alBankCode = new ArrayList();
if (session.getAttribute("BankCodeList") == null) {
	alBankCode = (List) disbBean.getBankList();
	session.setAttribute("BankCodeList",alBankCode);
} else {
	alBankCode =(List) session.getAttribute("BankCodeList");
}

//R60550 COUNTRY
List alCotryCode = new ArrayList();
if (session.getAttribute("CotryCodeList") == null) {
	alCotryCode = (List) disbBean.getCotryList();
	session.setAttribute("CotryCodeList", alCotryCode);
} else {
	alCotryCode = (List) session.getAttribute("CotryCodeList");
}

//SWIFT
List alSWIFTCode = new ArrayList();
if (session.getAttribute("SWIFTCodeList") == null) {
	alSWIFTCode = (List) disbBean.getSWIFTList();
	session.setAttribute("SWIFTCodeList", alSWIFTCode);
} else {
	alSWIFTCode = (List) session.getAttribute("SWIFTCodeList");
}//R60550 END

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

StringBuffer sbBankCode = new StringBuffer();
if (alBankCode.size() > 0) {
	for (int i = 0; i < alBankCode.size(); i++) {
		htTemp = (Hashtable) alBankCode.get(i);
		strValue = (String) htTemp.get("BKNO");
		strDesc = (String) htTemp.get("BKNM");
		sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
} else {
	sbBankCode.append("<option value=\"\">&nbsp;</option>");
}
StringBuffer sbPSrcCode = new StringBuffer();
sbPSrcCode.append("<option value=\"\">&nbsp;</option>");
if (alPSrcCode.size() > 0) {
	for (int i = 0; i < alPSrcCode.size(); i++) {
		htTemp = (Hashtable) alPSrcCode.get(i);
		strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
		strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));

		// R00386 ���ק�, �e�K�X������O���u�覡, ���ۤK�쬰�Ĥ@�������y�z (�ĤG�����y�z�ثe�O���Ъ�, �����)
		if (strDesc.length() >= 16) 
			strDesc = reSpace.subst(strDesc.substring(0, 16), "&nbsp;");

		if (strValue.equals(strPSrcCode))
			sbPSrcCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbPSrcCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
StringBuffer sbSWIFTCode = new StringBuffer();
sbSWIFTCode.append("<option value=\"\">&nbsp;</option>");
//RA0074 �̾ڻȦ�N�X�a�XSWIFT CODE
StringBuffer sBankNo = new StringBuffer();
if (alSWIFTCode.size() > 0) {
	String strTmp = "";
	for (int i = 0; i < alSWIFTCode.size(); i++) {
		htTemp = (Hashtable) alSWIFTCode.get(i);
		strValue = CommonUtil.AllTrim((String) htTemp.get("SwiftCD"));
		strDesc = CommonUtil.AllTrim((String) htTemp.get("SwiftBK"));
		strTmp = CommonUtil.AllTrim((String) htTemp.get("SwiftBN"));

		if (strValue.equals(strPSWIFT))
			sbSWIFTCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strTmp).append("</option>");
		else
			sbSWIFTCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strTmp).append("</option>");

		sBankNo.append("<input type=\"").append("hidden").append("\"").append("id=\"").append(strDesc).append("\"").append("value=\"").append(strValue).append("\"").append("/>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
StringBuffer sbCotryCode = new StringBuffer();
sbCotryCode.append("<option value=\"\">&nbsp;</option>");
if (alCotryCode.size() > 0) {
	for (int i = 0; i < alCotryCode.size(); i++) {
		htTemp = (Hashtable) alCotryCode.get(i);
		strValue = CommonUtil.AllTrim((String) htTemp.get("CotryCODE"));
		strDesc = CommonUtil.AllTrim((String) htTemp.get("CotryENNM"));

		if (strValue.equals(strPBKCOTRY))
			sbCotryCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbCotryCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>��I�ӷ�--�浧���Ӻ��@</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
	}
	if(document.getElementById("txtBack").value == "DISBPSourceConfirm" || document.getElementById("txtMsg").value != "")	
	{
		document.getElementById("txtAction").value = "I";
		document.getElementById("frmMain").action = "<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSConfirmServlet";
		document.getElementById("frmMain").submit();
	}
	else
	{
		var PDateTemp="<%=strPDate%>";
		var PAuthDtTemp="<%=strPAuthDt%>";
		if(PDateTemp !="") {
			document.getElementById("txtUPDateC").value =string2RocDate(PDateTemp);
		}
		if(PAuthDtTemp!="") {
			document.getElementById("txtUPAuthDtC").value = string2RocDate(PAuthDtTemp);
		}
		makeSeleted(); //R70088
		showAddfield();//R60550
		WindowOnLoadCommon( document.title, '', strDISBFunctionKeySDetailsU, '' );
		disableData();
		window.status = "";
	}
}
//R60550
function showAddfield() 
{
	var tmpPAYCURR ="<%=strPAYCURR%>";
	var tmpSYMBOL ="<%=strSYMBOL%>";
	var tmpINVDT =<%=iINVDT%>;
	var tmpPOCURR = "<%=strCurrency%>";
	var tmpFEEWAY = "<%=strPFEEWAY%>";
	var tmpENTRYDT = <%=iENTRYDT%>;//R70088

	var tempshow = "";
	//R70088 �O�P��J���� tmpPDT -> tmpENTRYDT
	if (tmpPOCURR != "NT" || (tmpPAYCURR != "" && tmpSYMBOL== "S" && tmpENTRYDT <= tmpINVDT)
	  || (tmpSYMBOL =="S" && tmpENTRYDT > tmpINVDT))
	{
		for(var i=0;i< 13;i++) {
			tempshow= "usSHOW"+i;
			document.getElementById(tempshow).style.display = "block";
  		}
  	}

  	if (tmpFEEWAY != "")
		document.getElementById("selFEEWAY").value = tmpFEEWAY;
	else if (tmpSYMBOL =="S")
		document.getElementById("selFEEWAY").value = "BEN";
	else
		document.getElementById("selFEEWAY").value = "OUR";

	//RA0074 ���w��l��
	document.getElementById("txtPBKCITY").value = "TP";
	document.getElementById("selPBKCOTRY").value = "TW";
}

//R70088
function makeSeleted()
{
	for(var i=0;i< document.getElementById("selUPMethod").options.length;i++)
	{
		if( document.getElementById("hidPMethod").value== document.getElementById("selUPMethod").options.item(i).value )
		{
			document.getElementById("selUPMethod").options.item(i).selected = true;
			break;
		}
	}
	for(var i=0;i< document.getElementById("selPUCrdType").options.length;i++)
	{
		if( document.getElementById("txtPUCrdType").value== document.getElementById("selPUCrdType").options.item(i).value )
		{	
			document.getElementById("selPUCrdType").options.item(i).selected = true;
			break;
		}
	}	
    for(var i=0;i< document.getElementById("selUPCrdEffM").options.length;i++)
	{
		if( document.getElementById("txtUPCrdEffMY").value.substring(0,2)== document.getElementById("selUPCrdEffM").options.item(i).value )
		{	
			document.getElementById("selUPCrdEffM").options.item(i).selected = true;
			break;
		}
	}	
    for(var i=0;i< document.getElementById("selUPCrdEffY").options.length;i++)
	{
		if( document.getElementById("txtUPCrdEffMY").value.substring(2,6)== document.getElementById("selUPCrdEffY").options.item(i).value )
		{	
			document.getElementById("selUPCrdEffY").options.item(i).selected = true;
			break;
		}
	}
}

/* ��toolbar frame ����<�ק�>���s�Q�I���,����Ʒ|�Q���� */
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );
	disableKey();
	enableData();
	document.getElementById("txtAction").value = "U";
}

/* ��toolbar frame ����<�x�s>���s�Q�I���,����Ʒ|�Q���� */
function saveAction()
{
	enableAll();
	mapValue();
	if( areAllFieldsOK() )
	{
		if( checkRadio() )
		{
			//R10260 �״��ˮ�
			var varMsg = "";
			var varStatus = true;
			//R00135 ���]�ȭn�D��I��]���i�ť�
			if(document.getElementById("selUPSrcCode").value == "")
			{
				varMsg = "�п�ܤ�I��]\r\n";
				varStatus = false;
			}
			if(document.getElementById("selUPMethod").value == "B" || document.getElementById("selUPMethod").value == "D")
			{
				if(document.getElementById("selUPMethod").value == "B")
				{
					varMsg = "�A�ҿ�ܪ���I�覡�O[�״�]\r\n";
				}
				else if(document.getElementById("selUPMethod").value == "D")
				{
					varMsg = "�A�ҿ�ܪ���I�覡�O[�~���״�]\r\n";
				}

				if(document.getElementById("txtUPRBank").value.length != 7)
				{
					varMsg += "-->�״ڻȦ�N�����i�֩� 7 �X\r\n";
					varStatus = false;
				}
				if(document.getElementById("txtUPRAccount").value == "")
				{
					varMsg += "-->�״ڱb�����i�ť�\r\n";
					varStatus = false;
				}
				document.getElementById("txtUPName").value = document.getElementById("txtUPName").value.replace(/^[\s�@]+|[\s�@]+$/g, "");
				if(document.getElementById("txtUPName").value == "" )
				{
					varMsg += "-->���ڤH�m�W���i�ť�\r\n";
					varStatus = false;
				}
			}
			//RB0302 �{���ȭ���x�����ɴ�
			if((document.getElementById("selUPMethod").value == "E") &&
				(!(document.getElementById("txtCurrency").value == "NT" && 
					(document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") &&
					document.frmMain.rdUDispatch[0].checked)))
			{
				varMsg += "��������󤧫O��ɴڤ~��H�{����I!!\n\r";
				varStatus = false;
			}

			if(varStatus)
			{
				document.getElementById("frmMain").submit();
			}
			else
			{
				alert(varMsg);
			}
		}
		else
		  	alert( strErrMsg );
	}
	else
		alert( strErrMsg );
}

function DISBBackAction()
{
	document.getElementById("txtAction").value = "I";
	document.getElementById("frmMain").action = "<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSConfirmServlet";
	document.getElementById("frmMain").submit();
}

function exitAction()
{
	document.getElementById("txtAction").value = "I";
	document.getElementById("frmMain").action = "<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSConfirmServlet";
	document.getElementById("frmMain").submit();
}

/**
��ƦW��:	checkClientField(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
	}	
    if( objThisItem.id == "txtUPDateC" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "�I�ڤ�����i�ť�";
			bReturnStatus = false;
		}
	}
    else if( objThisItem.id == "txtUPName" )
	{
		objThisItem.value = objThisItem.value.replace(/^[\s�@]+|[\s�@]+$/g, "");
		if( objThisItem.value == "" )
		{
			strTmpMsg = "���ڤH�m�W���i�ť�";
			bReturnStatus = false;
		}
	}
	else if( objThisItem.id == "selUPMethod" )
	{
		if( objThisItem.value == "A")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�䲼]\r\n";
			if(document.getElementById("txtUPRBank").value !="" || document.getElementById("txtUPRAccount").value !="" || document.getElementById("txtUPCrdNo").value !="" || document.getElementById("selPUCrdType").value !="" || document.getElementById("txtUPCrdEffMY").value !="" || document.getElementById("txtUPAuthCode").value !="" || document.getElementById("txtUPAuthDtC").value !="")
			{
				strTmpMsg = "-->�״ڻȦ�/�״ڱb��/�H�Υd�d��/�d�O/���Ħ~��/���v�X/���v�����,���ݿ�J";
				bReturnStatus = false;
			}
			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "B")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�״�]\r\n";
			if(document.getElementById("txtUPRBank").value =="" )
			{
				strTmpMsg += "-->�״ڻȦ椣�i�ť�\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRBank").value.length != 7 
					&& document.getElementById("txtCurrency").value =="NT")
			{
				strTmpMsg += "-->�״ڻȦ�N�����i�֩� 7 �X\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRAccount").value =="" )
			{
				strTmpMsg += "-->�״ڱb�����i�ť�\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPCrdNo").value !="" || document.getElementById("selPUCrdType").value !="" || document.getElementById("txtUPCrdEffMY").value !="" || document.getElementById("txtUPAuthCode").value !="" || document.getElementById("txtUPAuthDtC").value !="")
			{
				strTmpMsg += "-->�H�Υd�d��/�d�O/���Ħ~��/���v�X/���v�����,���ݿ�J\r\n";
				bReturnStatus = false;
			}
			document.getElementById("txtUPName").value = document.getElementById("txtUPName").value.replace(/^[\s�@]+|[\s�@]+$/g, "");
			if(document.getElementById("txtUPName").value == "" )
			{
				strTmpMsg += "-->���ڤH�m�W���i�ť�\r\n";
				bReturnStatus = false;
			}
			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "C")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�H�Υd]\r\n";
			if(document.getElementById("txtUPRBank").value !="" || document.getElementById("txtUPRAccount").value !="" )
			{
				strTmpMsg += "-->�״ڻȦ�/�״ڱb�����ݿ�J\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPCrdNo").value =="" )
			{
				strTmpMsg += "-->�H�Υd�d�����i�ť�\r\n";
				bReturnStatus = false;
			}
			else 
			{
				/*
				if (document.getElementById("txtUPCrdNo").value.length != 16)
				{
					strTmpMsg += "-->�H�Υd�d���ݬ�16�X�Ʀr\r\n";
					bReturnStatus = false;
				}
				else
				{ 
					re = /^\d{20}$/;
					if (!re.test(document.getElementById("txtUPCrdNo").value))
					{
						strTmpMsg += "-->�H�Υd�d���ݬ��Ʀr\r\n";
						bReturnStatus = false;
					}
				}*/
			}
			/*R30530  modi 20050223 -->�������d�O���n��쪺���� start 
			if(document.getElementById("selPUCrdType").value =="" )
			{
				strTmpMsg += "-->�п�ܥd�O\r\n";
				bReturnStatus = false;
			}
			R30530  modi 20050223 -->�������d�O���n��쪺���� end */
			if(document.getElementById("txtUPCrdEffMY").value =="" )
			{
				strTmpMsg += "-->�п�ܦ��Ĥ�~\r\n";
				bReturnStatus = false;
			}
			/*
			if(document.getElementById("txtUPAuthCode").value =="" )
			{
				strTmpMsg += "-->���v�X���i�ť�\r\n";
				bReturnStatus = false;
			}
			else
			{
				re = /^\d{10}$/;
				if (!re.test(document.getElementById("txtUPAuthCode").value))
				{
					strTmpMsg += "-->���v�X�ݬ��Ʀr\r\n";
					bReturnStatus = false;
				}
			}
			R80300 �H�Υd����J������v��*/
			if(document.getElementById("txtUPAuthDtC").value =="" )
			{
				strTmpMsg += "-->�п�ܱ��v�����\r\n";
				bReturnStatus = false;
			}								
		}
		//R60550 ���_�l��e���ݱj��KEY�~���״����
		else if( objThisItem.value == "D")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�~���״�]\r\n";
			if(document.getElementById("txtUPRBank").value =="" )
			{
				strTmpMsg += "-->�״ڻȦ椣�i�ť�\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRBank").value.length != 7 
					&& document.getElementById("txtCurrency").value =="NT")
			{
				strTmpMsg += "-->�״ڻȦ�N�����i�֩� 7 �X\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRAccount").value =="" )
			{
				strTmpMsg += "-->�״ڱb�����i�ť�\r\n";
				bReturnStatus = false;
			}
			//R80480���ڤHID
			if(document.getElementById("txtUPId").value =="" )
			{
				strTmpMsg += "-->���ڤHID���i�ť�\r\n";
				bReturnStatus = false;
			}
			document.getElementById("txtUPName").value = document.getElementById("txtUPName").value.replace(/^[\s�@]+|[\s�@]+$/g, "");
			if(document.getElementById("txtUPName").value == "" )
			{
				strTmpMsg += "-->���ڤH�m�W���i�ť�\r\n";
				bReturnStatus = false;
			}
			//R70088���_�l��e&�t���nKEY�״ڻȦ� 
			if((document.getElementById("txtUPRBank").value =="" && document.getElementById("hidENTRYDT").value <= document.getElementById("txtINVDT").value) 
	 			  || (document.getElementById("txtUPRBank").value =="" 
	 					  && (document.getElementById("selUPSrcCode").value =="B8" || document.getElementById("selUPSrcCode").value =="B9" || document.getElementById("selUPSrcCode").value =="BB")) )//R00440 SN������
			{
				strTmpMsg += "-->���_�l��e�ΰt��,�״ڻȦ椣�i�ť�\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("selPSWIFT").value =="")
			{
				strTmpMsg += "-->SWIFT CODE���i�ť�\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPBKBRCH").value =="")
			{
				strTmpMsg += "-->�Ȧ���椣�i�ť�\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPBKCITY").value =="")
			{
				strTmpMsg += "-->�Ȧ櫰�����i�ť�\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPENGNAME").value =="")
			{
				strTmpMsg += "-->���ڤH�^��m�W���i�ť�\r\n";
				bReturnStatus = false;
			}
			var reg=/[^A-Z]/g;
			if (reg.test(document.getElementById("txtPENGNAME").value))
			{
				strTmpMsg += "-->���ڤH�^��m�W�u�ର�j�g�^��r��";
				bReturnStatus = false;
			}
		}
		else if( objThisItem.value == "E")
		{
			if(!((document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") && document.frmMain.rdUDispatch[0].checked))
			{
				strTmpMsg += "��������󤧫O��ɴڤ~��H�{����I!!\n\r";
				bReturnStatus = false;
			}
		}
	}
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}

/**
��ƦW��:	checkRadio()
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
/*R30530  modi 20050223 -->�ݭn�����,�l�i�H�����䲼���u start */

function checkRadio()
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	/* RB0302�������~�i�����䲼���u
   	if( document.frmMain.rdUPCHKM2[1].checked && document.frmMain.rdUDispatch[1].checked  )
	{
		strTmpMsg = "�ݭn�����,�l�i�H�����䲼���u!";
		bReturnStatus = false;
	}*/
	//RB0302���i�P�ɨ����䲼�T�I�Τ䲼���u
   	if( document.frmMain.rdUPCHKM1[1].checked && document.frmMain.rdUPCHKM2[1].checked  )
	{
		strTmpMsg += "���i�P�ɨ����䲼�T�I�Τ䲼���u!";
		bReturnStatus = false;
	}

	if( !bReturnStatus )
	{
		strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
/*R30530  modi 20050223 -->�ݭn�����,�l�i�H�����䲼���u end */

function mapValue()
{
	document.getElementById("txtUPDate").value = rocDate2String(document.getElementById("txtUPDateC").value);
	document.getElementById("txtUPCrdEffMY").value = document.getElementById("selUPCrdEffM").value + document.getElementById("selUPCrdEffY").value;
	document.getElementById("txtUPAuthDt").value = rocDate2String(document.getElementById("txtUPAuthDtC").value);
	document.getElementById("txtPUCrdType").value = document.getElementById("selPUCrdType").value;

	document.getElementById("txtPBKBRCH").value = document.getElementById("txtPBKBRCH").value.toUpperCase(); //RA0074
	document.getElementById("txtPBKCITY").value = document.getElementById("txtPBKCITY").value.toUpperCase(); //RA0074
	document.getElementById("txtPENGNAME").value = document.getElementById("txtPENGNAME").value.toUpperCase(); //RA0074
}

// �̤�I��]�P�״ڻȦ�N�X�۰ʽվ����O��I�覡
function changeFeeWayByRules() 
{
	var payMethod = document.getElementById("selUPMethod").value;
	if( payMethod != "D" )	// �~���״ڤ~�n����
		return;

	var policyCurr = document.getElementById( "txtCurrency" ).value;
	var prbank = document.getElementById( "txtUPRBank" ).value;
	if( prbank.length > 3 )
		prbank = prbank.substring( 0, 3 );
	else if( prbank.length < 3 )
		prbank = prbank + "   ".substring( 0, 3 - prbank.length );
	var bnkfrCondition = policyCurr + prbank;

	var paySourceElement = document.getElementById( "selUPSrcCode" );
	var paySourceDesc = paySourceElement.options[ paySourceElement.selectedIndex ].text;
	var tableFeeWay = paySourceDesc.substring( 3, 6 );

	if( document.getElementById( "strBnkfrList").value.indexOf( bnkfrCondition ) != -1 )
		document.getElementById( "selFEEWAY" ).value = "OUR";
	else
		document.getElementById( "selFEEWAY" ).value = tableFeeWay;
}

function updatePRBankByKeyup() 
{
	var field = document.getElementById( "txtUPRBank" );
	autoComplete( field, field.form.options, "value", true, "selList" );
	changeFeeWayByRules();
	WriteCode();
}

function updatePRBankBySelection() 
{
	var sel = document.getElementById( "prbankList" );
	document.getElementById( "txtUPRBank" ).value = sel.options[ sel.selectedIndex ].value;
	changeFeeWayByRules();
	WriteCode();
}

//RA0074 �̻Ȧ�N�X�e�T�X�a�XSWIFT CODE
function WriteCode(){
	var bankNo = "";
	var prbank = document.getElementById( "txtUPRBank" ).value;
	if( prbank.length > 3 )
		bankNo = prbank.substring( 0, 3 );

	document.getElementById("txtPSWIFT").value = document.getElementById(bankNo).value;
	document.getElementById("selPSWIFT").value = document.getElementById("txtPSWIFT").value
	document.getElementById("selPBKCOTRY").value = document.getElementById("txtPSWIFT").value.substring(4, 6);
}

//RA0074 ������b��
function FulltoHalf(text) 
{
	var result = "";
	for(var i=0; i <= text.length; i++)
	{
		if( text.charCodeAt(i)== 12288)
		{
			result += " ";
		}
		else
		{
			if(text.charCodeAt(i) > 65280 && text.charCodeAt(i) < 65375)
			{
				result += String.fromCharCode(text.charCodeAt(i) - 65248);
			}
			else
			{
				result += String.fromCharCode(text.charCodeAt(i));
			}
		}
	}
	return result;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSMaintainServlet" id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="708" id=updateArea style="display: ">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="158">��I�Ǹ��G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="30" type="text" maxlength="30" name="txtUPNO" id="txtUPNO" value="<%=strPNo%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">�O�渹�X�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPolNo" id="txtUPolNo" VALUE="<%=strPolNo%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="158">�n�O�Ѹ��X�G</TD>
			<TD height="24" width="542"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUAppNo" id="txtUAppNo" VALUE="<%=strAppNo%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">���ڤH�m�W�G</TD>
			<TD width="542"><INPUT class="Data" size="15" type="text" maxlength="15" id="txtUPName" name="txtUPName" value="<%=strPName%>" onblur="checkClientField(this,true);"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">���ڤHID�G</TD>
			<TD width="542"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPId" name="txtUPId" value="<%=strPId%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">��I���B�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPAMT" id="txtPAMT" value="<%=df.format(iPAmt)%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="158">�I�ڤ���G</TD>
			<TD height="24" width="542">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPDateC" name="txtUPDateC" readOnly onblur="checkClientField(this,true);" value="">
				<a href="javascript:show_calendar('frmMain.txtUPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" width="24" height="21"></a> 
				<INPUT type="hidden" name="txtUPDate" id="txtUPDate" value="<%=strPDate%>">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">��I�y�z�G</TD>
			<TD width="542"><INPUT class="Data" size="37" type="text" maxlength="11" name="txtUPDesc" id="txtUPDesc" value="<%=strPdesc%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="200">�I�ڤ覡�G(�״�-�`���q)</TD>
			<TD width="540">
				<select size="1" name="selUPMethod" id="selUPMethod" class="Data">
				<% //R60550
				if (!strCurrency.equals("NT") || (!strPAYCURR.equals("") && strSYMBOL.equals("S") && (iENTRYDT <= iINVDT)))
				{ out.println("<option value=\"D\">�~���״�</option>");	}
				else
				{
				%>
				<option value="A">�䲼</option>
				<option value="B" selected>�״�</option>
				<option value="C">�H�Υd</option>
				<option value="E">�{��</option>
				<%
					if (strSYMBOL.equals("S") && (iENTRYDT > iINVDT))
					{out.println("<option value=\"D\">�~���״�</option>");}
				}%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">�״ڻȦ�N���G</TD>
			<TD width="542">
				<INPUT class="Data" size="11" type="text" maxlength="11" name="txtUPRBank" id="txtUPRBank" value="<%=strPRBank%>" ONKEYUP="updatePRBankByKeyup();" onchange="changeFeeWayByRules(),WriteCode(this);" onblur="checkClientField(this,true);">
				<span style="display: none" id="selList"> 
					<SELECT NAME="options" onChange="updatePRBankBySelection();" MULTIPLE SIZE=4 onblur="disableList('selList');" class="Data">
						<%=sbBankCode.toString()%>
					</SELECT>
				</span>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">�״ڻȦ�b���G</TD>
			<TD width="542"><INPUT class="Data" size="20" type="text" maxlength="16" name="txtUPRAccount" id="txtUPRAccount" value="<%=strPRAccount%>" onblur="checkClientField(this,true);"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">�H�Υd���X�G</TD>
			<TD width="542"><INPUT class="Data" size="20" type="text" maxlength="16" id="txtUPCrdNo" name="txtUPCrdNo" value="<%=strPCrdNo%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">�d�O�G</TD>
			<TD width="542">
				<select size="1" name="selPUCrdType" id="selUPCrdType" class="Data">
					<option value=""></option>
					<option value="VC">VC</option>
					<option value="MC">MC</option>
					<option value="JCB">JCB</option>
					<option value="NCC">NCC</option>
				</select> 
				<INPUT type="hidden" id="txtPUCrdType" name="txtPUCrdType" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">���ĺI���~�G</TD>
			<TD width="542">
				<select size="1" name="selUPCrdEffM" id="selUPCrdEffM" class="Data">
					<option value=""></option>
					<option value="01">01</option>
					<option value="02">02</option>
					<option value="03">03</option>
					<option value="04">04</option>
					<option value="05">05</option>
					<option value="06">06</option>
					<option value="07">07</option>
					<option value="08">08</option>
					<option value="09">09</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
				</select> -- 
				<select size="1" name="selUPCrdEffY" id="selUPCrdEffY" class="Data">
					<option value=""></option>
					<option value="2004">2004</option>
					<option value="2005">2005</option>
					<option value="2006">2006</option>
					<option value="2007">2007</option>
					<option value="2008">2008</option>
					<option value="2009">2009</option>
					<option value="2010">2010</option>
					<option value="2011">2011</option>
					<option value="2012">2012</option>
					<option value="2013">2013</option>
					<option value="2014">2014</option>
					<option value="2015">2015</option>
					<option value="2016">2016</option>
					<option value="2017">2017</option>
					<option value="2018">2018</option>
					<option value="2019">2019</option>
					<option value="2020">2020</option>
				</select> 
				<INPUT type="hidden" id="txtUPCrdEffMY" name="txtUPCrdEffMY" value="<%=strPCrdEffMY%>">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">���v�X�G</TD>
			<TD width="542"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPAuthCode" name="txtUPAuthCode" value="<%=strPAuthCode%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="158">���v�����G</TD>
			<TD height="24" width="542">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPAuthDtC" name="txtUPAuthDtC" onblur="checkClientField(this,true);" value="">
				<a href="javascript:show_calendar('frmMain.txtUPAuthDtC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" width="24" height="21"></a> 
				<INPUT type="hidden" name="txtUPAuthDt" id="txtUPAuthDt" value="<%=strPAuthDt%>">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="166">�����B�G</TD>
			<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtUPOrgAMT" id="txtUPOrgAMT" value="<%=df.format(iPOrgAMT)%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="166">���d���G</TD>
			<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPOrgCrdNo" name="txtUPOrgCrdNo" value="<%=strPOrgCrdNo%>"><font color="red" size="2">(�����h�O�d�����P���l�d����,�п�J)</font></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">���_�G</TD>
			<TD width="542"><input type="radio" name="rdUDispatch" id="rdUDispatch" Value="Y" <% if (strPDispatch.trim().equals("Y")) out.println("checked");%>>�O <input type="radio" name="rdUDispatch" id="rdUDispatch" Value="" <% if (!strPDispatch.trim().equals("Y")) out.println("checked");%>>�_</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">�䲼�T�I�G</TD>
			<TD width="542">
				<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1" Value="Y" <% if (strPChkm1.equals("Y")) out.println("checked");%>>�T�I
				<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1" Value="" <% if (!strPChkm1.equals("Y")) out.println("checked");%>>�����T�I
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">�䲼���u�G</TD>
			<TD width="542">
				<input type="radio" name="rdUPCHKM2" id="rdUPCHKM2" Value="Y" <% if (strPChkm2.equals("Y")) out.println("checked");%>>���u
				<input type="radio" name="rdUPCHKM2" id="rdUPCHKM2" Value="" <% if (!strPChkm2.equals("Y")) out.println("checked");%>>�������u
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">��I��]�G</TD>
			<TD width="542">
				<select size="1" name="selUPSrcCode" id="selUPSrcCode" class="Data">
					<%=sbPSrcCode.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">�ӷ��s�աG</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="16" type="text" maxlength="11" name="txtUPSrcGp" id="txtUPSrcGp" VALUE="<%=strPSrcGp%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">���G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUPolDiv" id="txtUPolDiv" VALUE="<%=strBranch%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">���O�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtCurrency" id="txtCurrency" VALUE="<%=strCurrency%>" readonly></TD>
		</TR>
		<!-- RC0036 �ӿ�H�� -->
		<TR>
			<TD align="right" class="TableHeading" width="158">�ӿ�H���G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUsrInfo" id="txtUsrInfo" VALUE="<%=strUsrInfo%>" readonly></TD>
		</TR>
		<!--R60550�s�W11�����FOR�~���״�-->
		<TR id="usSHOW0" style="display: none">
			<TD align="right" class="TableHeading" width="158">���_�l��G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtINVDT" id="txtINVDT" VALUE="<%=strINVDTC%>" readonly></TD>
		</TR>
		<TR id="usSHOW1" style="display: none">
			<TD align="right" class="TableHeading" width="158">�~���ץX���O�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="10" type="text" maxlength="10" name="txtPAYCURR" id="txtPAYCURR" VALUE="<%=strPAYCURR%>" readonly></TD>
		</TR>
		<TR id="usSHOW2" style="display: none">
			<TD align="right" class="TableHeading" width="158">�~���ץX�ײv�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="16" type="text" maxlength="16" name="txtPAYRATE" id="txtPAYRATE" VALUE="<%=df2.format(iPAYRATE)%>" readonly></TD>
		</TR>
		<TR id="usSHOW3" style="display: none">
			<TD align="right" class="TableHeading" width="158">�~���ץX���B�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtPAYAMT" id="txtPAYAMT" VALUE="<%=df2.format(iPAYAMT)%>" readonly></TD>
		</TR>
		<TR id="usSHOW4" style="display: none">
			<TD align="right" class="TableHeading" width="158">����O��I�覡�G</TD>
			<TD width="542">
				<select size="1" name="selFEEWAY" id="selFEEWAY" class="Data">
					<option value="SHA">�U�ۭt��</option>
					<option value="BEN">�O���I</option>
					<option value="OUR">���q��I</option>
				</select>
			</TD>
		</TR>
		<TR id="usSHOW5" style="display: none">
			<TD align="right" class="TableHeading" width="158">SWIFT CODE�G</TD>
			<TD width="542">
				<INPUT class="Data" size="13" type="text" maxlength="12" value="<%=strPSWIFT%>" name="txtPSWIFT" id="txtPSWIFT" ONKEYUP="autoComplete(this,this.form.selPSWIFT,'value',true,'selList2')">
				<span style="display: none" id="selList2"> 
					<select name="selPSWIFT" id="selPSWIFT" onChange="this.form.txtPSWIFT.value=this.options[this.selectedIndex].value;this.form.selPBKCOTRY.value=this.value.substring(4,6);" MULTIPLE SIZE=4 onblur="disableList('selList2');" class="Data">
						<%=sbSWIFTCode.toString()%>
					</select>
				</span>
				<%=sBankNo.toString()%>
			</TD>
		</TR>
		<TR id="usSHOW6" style="display: none">
			<TD align="right" class="TableHeading" width="158">�Ȧ����G</TD>
			<TD width="542"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKBRCH" id="txtPBKBRCH" value="<%=strPBKBRCH%>" style="text-transform: uppercase;" onchange="this.form.txtPBKBRCH.value=FulltoHalf(this.form.txtPBKBRCH.value);"></TD>
		</TR>
		<TR id="usSHOW7" style="display: none">
			<TD align="right" class="TableHeading" width="158">�Ȧ櫰���G</TD>
			<TD width="542"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKCITY" id="txtPBKCITY" value="<%=strPBKCITY%>" style="text-transform: uppercase;"></TD>
		</TR>
		<TR id="usSHOW8" style="display: none">
			<TD align="right" class="TableHeading" width="158">�Ȧ��O�G</TD>
			<TD width="542">
				<select size="1" name="selPBKCOTRY" id="selPBKCOTRY" class="Data">
					<%=sbCotryCode.toString()%>
				</select>
			</TD>
		</TR>
		<TR id="usSHOW9" style="display: none">
			<TD align="right" class="TableHeading" width="158">���ڤH�^��m�W�G</TD>
			<TD width="542"><INPUT class="Data" size="70" type="text" maxlength="70" name="txtPENGNAME" id="txtPENGNAME" value="<%=strPENGNAME%>" style="text-transform: uppercase;" onchange="this.form.txtPENGNAME.value=FulltoHalf(this.form.txtPENGNAME.value);"></TD>
		</TR>
		<TR id="usSHOW10" style="display: none">
			<TD align="right" class="TableHeading" width="158">���O�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="5" type="text" maxlength="1" name="txtSYMBOL" id="txtSYMBOL" VALUE="<%=strSYMBOL%>" readonly><font color="red" size="2">(���� S:SPUL)</font></TD>
		</TR>
		<TR id="usSHOW11" style="display: none">
			<TD align="right" class="TableHeading" width="158">�h�פ���O�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="40" type="text" maxlength="40" name="txtFPAYAMT" id="txtFPAYAMT" VALUE="<%=df2.format(iFPAYAMT)%>" readonly> <font color="red" size="2">(�h�פ���O���O�P�~���ץX���O)</font></TD>
		</TR>
		<TR id="usSHOW12" style="display: none">
			<TD align="right" class="TableHeading" width="158">�h�פ���O��I�覡�G</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="40" type="text" maxlength="40" name="txtFFEEWAY" id="txtFFEEWAY" VALUE="<%=strFFEEWAY%>" readonly></TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtParent" name="txtParent" value="DISBPSourceConfirm">
<INPUT type="hidden" id="txtBack" name="txtBack" value="<%=strBack%>">
<INPUT type="hidden" id="currentPage" name="currentPage" value="<%=request.getParameter("currentPage")!=null?request.getParameter("currentPage"):""%>">
<INPUT type="hidden" id="hidPMethod" name="hidPMethod" value="<%=strPMethod%>">
<INPUT type="hidden" id="hidENTRYDT" name="hidENTRYDT" value="<%=strENTRYDTC%>"> 
</FORM>
</BODY>
</HTML>
