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
 * Function : 單筆明細維護
 * 
 * Remark   : 支付來源
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
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.14  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.13  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 * Revision 1.12  2012/08/29 02:57:50  ODCKain
 * Calendar problem
 *
 * Revision 1.11  2011/11/01 07:41:43  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 * FIX 付款方式為(外幣)匯款時，相關的檢核移到儲存或確認時再檢核
 *
 * Revision 1.10  2011/10/21 10:04:37  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 *
 * Revision 1.7  2008/08/12 06:56:19  misvanessa
 * R80480_上海銀行外幣整批轉存檔案
 *
 * Revision 1.6  2008/04/30 07:50:07  misvanessa
 * R80300_收單行轉台新,新增下載檔案及報表
 *
 * Revision 1.5  2007/09/07 10:39:53  MISVANESSA
 * R70455_TARGET OUT
 *
 * Revision 1.4  2007/01/31 08:04:06  MISVANESSA
 * R70088_SPUL配息
 *
 * Revision 1.3  2007/01/15 06:47:37  MISVANESSA
 * R60550_SPUL&VA美元外幣匯款
 *
 * Revision 1.2  2007/01/04 03:22:33  MISVANESSA
 * R60550_外幣匯款銀行抓取方式修改
 *
 * Revision 1.1  2006/06/29 09:40:48  MISangel
 * Init Project
 *
 * Revision 1.1.2.12  2006/04/27 09:35:39  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.11  2005/05/13 02:31:12  miselsa
 * R30530_身份證可修改
 *
 * Revision 1.1.2.10  2005/04/22 06:25:14  miselsa
 * R30530_加大姓名欄位
 *
 * Revision 1.1.2.9  2005/04/22 06:18:41  miselsa
 * R30530_加大姓名欄位
 *
 * Revision 1.1.2.8  2005/04/04 07:02:24  miselsa
 * R30530 支付系統
 *  
 */
%><%! String strThisProgId = "DISBPSourceDetails"; //本程式代號 %><%
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
//R60550新增12欄位
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
			strPMethodDesc = "支票";
		if (strPMethod.equals("B"))
			strPMethodDesc = "匯款";
		if (strPMethod.equals("C"))
			strPMethodDesc = "信用卡";	
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

	//R80300 原刷卡號
	if (objPDetailVO.getStrPOrgCrdNo() != null)
		strPOrgCrdNo = objPDetailVO.getStrPOrgCrdNo();
	if (strPOrgCrdNo != "")
		strPOrgCrdNo = strPOrgCrdNo.trim();
	//R80300 原刷金額
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
		strPBKCITY = "TP";  //RA0074 給定初始值

	if (objPDetailVO.getStrPBKCOTRY() != null)
		strPBKCOTRY = objPDetailVO.getStrPBKCOTRY().trim();
	else
		strPBKCOTRY = "TW"; //RA0074 給定初始值

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
	//R70088 投資起始日是與輸入日比較
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

		// R00386 欄位修改, 前八碼為手續費分攤方式, 接著八位為第一部份的描述 (第二部份描述目前是重覆的, 不顯示)
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
//RA0074 依據銀行代碼帶出SWIFT CODE
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
<TITLE>支付來源--單筆明細維護</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
/* 當前端程式開始時,本函數會被執行 */
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
	//R70088 是與輸入日比較 tmpPDT -> tmpENTRYDT
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

	//RA0074 給定初始值
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

/* 當toolbar frame 中之<修改>按鈕被點選時,本函數會被執行 */
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );
	disableKey();
	enableData();
	document.getElementById("txtAction").value = "U";
}

/* 當toolbar frame 中之<儲存>按鈕被點選時,本函數會被執行 */
function saveAction()
{
	enableAll();
	mapValue();
	if( areAllFieldsOK() )
	{
		if( checkRadio() )
		{
			//R10260 匯款檢核
			var varMsg = "";
			var varStatus = true;
			//R00135 應財務要求支付原因不可空白
			if(document.getElementById("selUPSrcCode").value == "")
			{
				varMsg = "請選擇支付原因\r\n";
				varStatus = false;
			}
			if(document.getElementById("selUPMethod").value == "B" || document.getElementById("selUPMethod").value == "D")
			{
				if(document.getElementById("selUPMethod").value == "B")
				{
					varMsg = "你所選擇的支付方式是[匯款]\r\n";
				}
				else if(document.getElementById("selUPMethod").value == "D")
				{
					varMsg = "你所選擇的支付方式是[外幣匯款]\r\n";
				}

				if(document.getElementById("txtUPRBank").value.length != 7)
				{
					varMsg += "-->匯款銀行代號不可少於 7 碼\r\n";
					varStatus = false;
				}
				if(document.getElementById("txtUPRAccount").value == "")
				{
					varMsg += "-->匯款帳號不可空白\r\n";
					varStatus = false;
				}
				document.getElementById("txtUPName").value = document.getElementById("txtUPName").value.replace(/^[\s　]+|[\s　]+$/g, "");
				if(document.getElementById("txtUPName").value == "" )
				{
					varMsg += "-->受款人姓名不可空白\r\n";
					varStatus = false;
				}
			}
			//RB0302 現金僅限於台幣急件借款
			if((document.getElementById("selUPMethod").value == "E") &&
				(!(document.getElementById("txtCurrency").value == "NT" && 
					(document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") &&
					document.frmMain.rdUDispatch[0].checked)))
			{
				varMsg += "必須為急件之保單借款才能以現金支付!!\n\r";
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
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
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
			strTmpMsg = "付款日期不可空白";
			bReturnStatus = false;
		}
	}
    else if( objThisItem.id == "txtUPName" )
	{
		objThisItem.value = objThisItem.value.replace(/^[\s　]+|[\s　]+$/g, "");
		if( objThisItem.value == "" )
		{
			strTmpMsg = "受款人姓名不可空白";
			bReturnStatus = false;
		}
	}
	else if( objThisItem.id == "selUPMethod" )
	{
		if( objThisItem.value == "A")
		{
			strTmpMsg = "你所選擇的支付方式是[支票]\r\n";
			if(document.getElementById("txtUPRBank").value !="" || document.getElementById("txtUPRAccount").value !="" || document.getElementById("txtUPCrdNo").value !="" || document.getElementById("selPUCrdType").value !="" || document.getElementById("txtUPCrdEffMY").value !="" || document.getElementById("txtUPAuthCode").value !="" || document.getElementById("txtUPAuthDtC").value !="")
			{
				strTmpMsg = "-->匯款銀行/匯款帳號/信用卡卡號/卡別/有效年月/授權碼/授權交易日,不需輸入";
				bReturnStatus = false;
			}
			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "B")
		{
			strTmpMsg = "你所選擇的支付方式是[匯款]\r\n";
			if(document.getElementById("txtUPRBank").value =="" )
			{
				strTmpMsg += "-->匯款銀行不可空白\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRBank").value.length != 7 
					&& document.getElementById("txtCurrency").value =="NT")
			{
				strTmpMsg += "-->匯款銀行代號不可少於 7 碼\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRAccount").value =="" )
			{
				strTmpMsg += "-->匯款帳號不可空白\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPCrdNo").value !="" || document.getElementById("selPUCrdType").value !="" || document.getElementById("txtUPCrdEffMY").value !="" || document.getElementById("txtUPAuthCode").value !="" || document.getElementById("txtUPAuthDtC").value !="")
			{
				strTmpMsg += "-->信用卡卡號/卡別/有效年月/授權碼/授權交易日,不需輸入\r\n";
				bReturnStatus = false;
			}
			document.getElementById("txtUPName").value = document.getElementById("txtUPName").value.replace(/^[\s　]+|[\s　]+$/g, "");
			if(document.getElementById("txtUPName").value == "" )
			{
				strTmpMsg += "-->受款人姓名不可空白\r\n";
				bReturnStatus = false;
			}
			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "C")
		{
			strTmpMsg = "你所選擇的支付方式是[信用卡]\r\n";
			if(document.getElementById("txtUPRBank").value !="" || document.getElementById("txtUPRAccount").value !="" )
			{
				strTmpMsg += "-->匯款銀行/匯款帳號不需輸入\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPCrdNo").value =="" )
			{
				strTmpMsg += "-->信用卡卡號不可空白\r\n";
				bReturnStatus = false;
			}
			else 
			{
				/*
				if (document.getElementById("txtUPCrdNo").value.length != 16)
				{
					strTmpMsg += "-->信用卡卡號需為16碼數字\r\n";
					bReturnStatus = false;
				}
				else
				{ 
					re = /^\d{20}$/;
					if (!re.test(document.getElementById("txtUPCrdNo").value))
					{
						strTmpMsg += "-->信用卡卡號需為數字\r\n";
						bReturnStatus = false;
					}
				}*/
			}
			/*R30530  modi 20050223 -->取消為卡別為要欄位的限制 start 
			if(document.getElementById("selPUCrdType").value =="" )
			{
				strTmpMsg += "-->請選擇卡別\r\n";
				bReturnStatus = false;
			}
			R30530  modi 20050223 -->取消為卡別為要欄位的限制 end */
			if(document.getElementById("txtUPCrdEffMY").value =="" )
			{
				strTmpMsg += "-->請選擇有效月年\r\n";
				bReturnStatus = false;
			}
			/*
			if(document.getElementById("txtUPAuthCode").value =="" )
			{
				strTmpMsg += "-->授權碼不可空白\r\n";
				bReturnStatus = false;
			}
			else
			{
				re = /^\d{10}$/;
				if (!re.test(document.getElementById("txtUPAuthCode").value))
				{
					strTmpMsg += "-->授權碼需為數字\r\n";
					bReturnStatus = false;
				}
			}
			R80300 信用卡必輸入交易授權日*/
			if(document.getElementById("txtUPAuthDtC").value =="" )
			{
				strTmpMsg += "-->請選擇授權交易日\r\n";
				bReturnStatus = false;
			}								
		}
		//R60550 投資起始日前不需強制KEY外幣匯款欄位
		else if( objThisItem.value == "D")
		{
			strTmpMsg = "你所選擇的支付方式是[外幣匯款]\r\n";
			if(document.getElementById("txtUPRBank").value =="" )
			{
				strTmpMsg += "-->匯款銀行不可空白\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRBank").value.length != 7 
					&& document.getElementById("txtCurrency").value =="NT")
			{
				strTmpMsg += "-->匯款銀行代號不可少於 7 碼\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRAccount").value =="" )
			{
				strTmpMsg += "-->匯款帳號不可空白\r\n";
				bReturnStatus = false;
			}
			//R80480受款人ID
			if(document.getElementById("txtUPId").value =="" )
			{
				strTmpMsg += "-->受款人ID不可空白\r\n";
				bReturnStatus = false;
			}
			document.getElementById("txtUPName").value = document.getElementById("txtUPName").value.replace(/^[\s　]+|[\s　]+$/g, "");
			if(document.getElementById("txtUPName").value == "" )
			{
				strTmpMsg += "-->受款人姓名不可空白\r\n";
				bReturnStatus = false;
			}
			//R70088投資起始日前&配息要KEY匯款銀行 
			if((document.getElementById("txtUPRBank").value =="" && document.getElementById("hidENTRYDT").value <= document.getElementById("txtINVDT").value) 
	 			  || (document.getElementById("txtUPRBank").value =="" 
	 					  && (document.getElementById("selUPSrcCode").value =="B8" || document.getElementById("selUPSrcCode").value =="B9" || document.getElementById("selUPSrcCode").value =="BB")) )//R00440 SN滿期金
			{
				strTmpMsg += "-->投資起始日前或配息,匯款銀行不可空白\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("selPSWIFT").value =="")
			{
				strTmpMsg += "-->SWIFT CODE不可空白\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPBKBRCH").value =="")
			{
				strTmpMsg += "-->銀行分行不可空白\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPBKCITY").value =="")
			{
				strTmpMsg += "-->銀行城市不可空白\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPENGNAME").value =="")
			{
				strTmpMsg += "-->受款人英文姓名不可空白\r\n";
				bReturnStatus = false;
			}
			var reg=/[^A-Z]/g;
			if (reg.test(document.getElementById("txtPENGNAME").value))
			{
				strTmpMsg += "-->受款人英文姓名只能為大寫英文字母";
				bReturnStatus = false;
			}
		}
		else if( objThisItem.value == "E")
		{
			if(!((document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") && document.frmMain.rdUDispatch[0].checked))
			{
				strTmpMsg += "必須為急件之保單借款才能以現金支付!!\n\r";
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
函數名稱:	checkRadio()
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
/*R30530  modi 20050223 -->需要為急件,始可以取消支票劃線 start */

function checkRadio()
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	/* RB0302取消急件才可取消支票劃線
   	if( document.frmMain.rdUPCHKM2[1].checked && document.frmMain.rdUDispatch[1].checked  )
	{
		strTmpMsg = "需要為急件,始可以取消支票劃線!";
		bReturnStatus = false;
	}*/
	//RB0302不可同時取消支票禁背及支票劃線
   	if( document.frmMain.rdUPCHKM1[1].checked && document.frmMain.rdUPCHKM2[1].checked  )
	{
		strTmpMsg += "不可同時取消支票禁背及支票劃線!";
		bReturnStatus = false;
	}

	if( !bReturnStatus )
	{
		strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
/*R30530  modi 20050223 -->需要為急件,始可以取消支票劃線 end */

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

// 依支付原因與匯款銀行代碼自動調整手續費支付方式
function changeFeeWayByRules() 
{
	var payMethod = document.getElementById("selUPMethod").value;
	if( payMethod != "D" )	// 外幣匯款才要執行
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

//RA0074 依銀行代碼前三碼帶出SWIFT CODE
function WriteCode(){
	var bankNo = "";
	var prbank = document.getElementById( "txtUPRBank" ).value;
	if( prbank.length > 3 )
		bankNo = prbank.substring( 0, 3 );

	document.getElementById("txtPSWIFT").value = document.getElementById(bankNo).value;
	document.getElementById("selPSWIFT").value = document.getElementById("txtPSWIFT").value
	document.getElementById("selPBKCOTRY").value = document.getElementById("txtPSWIFT").value.substring(4, 6);
}

//RA0074 全形轉半形
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
			<TD align="right" class="TableHeading" width="158">支付序號：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="30" type="text" maxlength="30" name="txtUPNO" id="txtUPNO" value="<%=strPNo%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">保單號碼：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPolNo" id="txtUPolNo" VALUE="<%=strPolNo%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="158">要保書號碼：</TD>
			<TD height="24" width="542"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUAppNo" id="txtUAppNo" VALUE="<%=strAppNo%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">受款人姓名：</TD>
			<TD width="542"><INPUT class="Data" size="15" type="text" maxlength="15" id="txtUPName" name="txtUPName" value="<%=strPName%>" onblur="checkClientField(this,true);"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">受款人ID：</TD>
			<TD width="542"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPId" name="txtUPId" value="<%=strPId%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">支付金額：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPAMT" id="txtPAMT" value="<%=df.format(iPAmt)%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="158">付款日期：</TD>
			<TD height="24" width="542">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPDateC" name="txtUPDateC" readOnly onblur="checkClientField(this,true);" value="">
				<a href="javascript:show_calendar('frmMain.txtUPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" width="24" height="21"></a> 
				<INPUT type="hidden" name="txtUPDate" id="txtUPDate" value="<%=strPDate%>">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">支付描述：</TD>
			<TD width="542"><INPUT class="Data" size="37" type="text" maxlength="11" name="txtUPDesc" id="txtUPDesc" value="<%=strPdesc%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="200">付款方式：(匯款-總公司)</TD>
			<TD width="540">
				<select size="1" name="selUPMethod" id="selUPMethod" class="Data">
				<% //R60550
				if (!strCurrency.equals("NT") || (!strPAYCURR.equals("") && strSYMBOL.equals("S") && (iENTRYDT <= iINVDT)))
				{ out.println("<option value=\"D\">外幣匯款</option>");	}
				else
				{
				%>
				<option value="A">支票</option>
				<option value="B" selected>匯款</option>
				<option value="C">信用卡</option>
				<option value="E">現金</option>
				<%
					if (strSYMBOL.equals("S") && (iENTRYDT > iINVDT))
					{out.println("<option value=\"D\">外幣匯款</option>");}
				}%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">匯款銀行代號：</TD>
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
			<TD align="right" class="TableHeading" width="158">匯款銀行帳號：</TD>
			<TD width="542"><INPUT class="Data" size="20" type="text" maxlength="16" name="txtUPRAccount" id="txtUPRAccount" value="<%=strPRAccount%>" onblur="checkClientField(this,true);"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">信用卡號碼：</TD>
			<TD width="542"><INPUT class="Data" size="20" type="text" maxlength="16" id="txtUPCrdNo" name="txtUPCrdNo" value="<%=strPCrdNo%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">卡別：</TD>
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
			<TD align="right" class="TableHeading" width="158">有效截止月年：</TD>
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
			<TD align="right" class="TableHeading" width="158">授權碼：</TD>
			<TD width="542"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPAuthCode" name="txtUPAuthCode" value="<%=strPAuthCode%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="158">授權交易日：</TD>
			<TD height="24" width="542">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPAuthDtC" name="txtUPAuthDtC" onblur="checkClientField(this,true);" value="">
				<a href="javascript:show_calendar('frmMain.txtUPAuthDtC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" width="24" height="21"></a> 
				<INPUT type="hidden" name="txtUPAuthDt" id="txtUPAuthDt" value="<%=strPAuthDt%>">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="166">原刷金額：</TD>
			<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtUPOrgAMT" id="txtUPOrgAMT" value="<%=df.format(iPOrgAMT)%>"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="166">原刷卡號：</TD>
			<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPOrgCrdNo" name="txtUPOrgCrdNo" value="<%=strPOrgCrdNo%>"><font color="red" size="2">(此次退費卡號不同於原始卡號時,請輸入)</font></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">急件否：</TD>
			<TD width="542"><input type="radio" name="rdUDispatch" id="rdUDispatch" Value="Y" <% if (strPDispatch.trim().equals("Y")) out.println("checked");%>>是 <input type="radio" name="rdUDispatch" id="rdUDispatch" Value="" <% if (!strPDispatch.trim().equals("Y")) out.println("checked");%>>否</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">支票禁背：</TD>
			<TD width="542">
				<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1" Value="Y" <% if (strPChkm1.equals("Y")) out.println("checked");%>>禁背
				<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1" Value="" <% if (!strPChkm1.equals("Y")) out.println("checked");%>>取消禁背
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">支票劃線：</TD>
			<TD width="542">
				<input type="radio" name="rdUPCHKM2" id="rdUPCHKM2" Value="Y" <% if (strPChkm2.equals("Y")) out.println("checked");%>>劃線
				<input type="radio" name="rdUPCHKM2" id="rdUPCHKM2" Value="" <% if (!strPChkm2.equals("Y")) out.println("checked");%>>取消劃線
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">支付原因：</TD>
			<TD width="542">
				<select size="1" name="selUPSrcCode" id="selUPSrcCode" class="Data">
					<%=sbPSrcCode.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">來源群組：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="16" type="text" maxlength="11" name="txtUPSrcGp" id="txtUPSrcGp" VALUE="<%=strPSrcGp%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">單位：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUPolDiv" id="txtUPolDiv" VALUE="<%=strBranch%>" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="158">幣別：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtCurrency" id="txtCurrency" VALUE="<%=strCurrency%>" readonly></TD>
		</TR>
		<!-- RC0036 承辦人員 -->
		<TR>
			<TD align="right" class="TableHeading" width="158">承辦人員：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUsrInfo" id="txtUsrInfo" VALUE="<%=strUsrInfo%>" readonly></TD>
		</TR>
		<!--R60550新增11個欄位FOR外幣匯款-->
		<TR id="usSHOW0" style="display: none">
			<TD align="right" class="TableHeading" width="158">投資起始日：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtINVDT" id="txtINVDT" VALUE="<%=strINVDTC%>" readonly></TD>
		</TR>
		<TR id="usSHOW1" style="display: none">
			<TD align="right" class="TableHeading" width="158">外幣匯出幣別：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="10" type="text" maxlength="10" name="txtPAYCURR" id="txtPAYCURR" VALUE="<%=strPAYCURR%>" readonly></TD>
		</TR>
		<TR id="usSHOW2" style="display: none">
			<TD align="right" class="TableHeading" width="158">外幣匯出匯率：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="16" type="text" maxlength="16" name="txtPAYRATE" id="txtPAYRATE" VALUE="<%=df2.format(iPAYRATE)%>" readonly></TD>
		</TR>
		<TR id="usSHOW3" style="display: none">
			<TD align="right" class="TableHeading" width="158">外幣匯出金額：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtPAYAMT" id="txtPAYAMT" VALUE="<%=df2.format(iPAYAMT)%>" readonly></TD>
		</TR>
		<TR id="usSHOW4" style="display: none">
			<TD align="right" class="TableHeading" width="158">手續費支付方式：</TD>
			<TD width="542">
				<select size="1" name="selFEEWAY" id="selFEEWAY" class="Data">
					<option value="SHA">各自負擔</option>
					<option value="BEN">保戶支付</option>
					<option value="OUR">公司支付</option>
				</select>
			</TD>
		</TR>
		<TR id="usSHOW5" style="display: none">
			<TD align="right" class="TableHeading" width="158">SWIFT CODE：</TD>
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
			<TD align="right" class="TableHeading" width="158">銀行分行：</TD>
			<TD width="542"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKBRCH" id="txtPBKBRCH" value="<%=strPBKBRCH%>" style="text-transform: uppercase;" onchange="this.form.txtPBKBRCH.value=FulltoHalf(this.form.txtPBKBRCH.value);"></TD>
		</TR>
		<TR id="usSHOW7" style="display: none">
			<TD align="right" class="TableHeading" width="158">銀行城市：</TD>
			<TD width="542"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKCITY" id="txtPBKCITY" value="<%=strPBKCITY%>" style="text-transform: uppercase;"></TD>
		</TR>
		<TR id="usSHOW8" style="display: none">
			<TD align="right" class="TableHeading" width="158">銀行國別：</TD>
			<TD width="542">
				<select size="1" name="selPBKCOTRY" id="selPBKCOTRY" class="Data">
					<%=sbCotryCode.toString()%>
				</select>
			</TD>
		</TR>
		<TR id="usSHOW9" style="display: none">
			<TD align="right" class="TableHeading" width="158">受款人英文姓名：</TD>
			<TD width="542"><INPUT class="Data" size="70" type="text" maxlength="70" name="txtPENGNAME" id="txtPENGNAME" value="<%=strPENGNAME%>" style="text-transform: uppercase;" onchange="this.form.txtPENGNAME.value=FulltoHalf(this.form.txtPENGNAME.value);"></TD>
		</TR>
		<TR id="usSHOW10" style="display: none">
			<TD align="right" class="TableHeading" width="158">註記：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="5" type="text" maxlength="1" name="txtSYMBOL" id="txtSYMBOL" VALUE="<%=strSYMBOL%>" readonly><font color="red" size="2">(說明 S:SPUL)</font></TD>
		</TR>
		<TR id="usSHOW11" style="display: none">
			<TD align="right" class="TableHeading" width="158">退匯手續費：</TD>
			<TD width="542"><INPUT class="INPUT_DISPLAY" size="40" type="text" maxlength="40" name="txtFPAYAMT" id="txtFPAYAMT" VALUE="<%=df2.format(iFPAYAMT)%>" readonly> <font color="red" size="2">(退匯手續費幣別同外幣匯出幣別)</font></TD>
		</TR>
		<TR id="usSHOW12" style="display: none">
			<TD align="right" class="TableHeading" width="158">退匯手續費支付方式：</TD>
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
