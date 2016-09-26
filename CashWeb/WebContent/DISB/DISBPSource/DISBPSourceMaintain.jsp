<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ page import="org.apache.regexp.RE" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 單筆維護確認
 * 
 * Remark   : 支付來源
 * 
 * Revision : $Revision: 1.30 $
 * 
 * Author   : Elsa Huang
 * Create Date : 2005/04/04
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPSourceMaintain.jsp,v $
 * Revision 1.30  2014/09/24 03:31:02  miscolin
 * QC0290－CASH無法執行現金給付
 *
 * Revision 1.29  2014/07/18 07:29:01  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.28  2013/12/18 07:22:52  MISSALLY
 * RB0302---新增付款方式現金
 *
 * Revision 1.27  2013/05/02 11:07:05  MISSALLY
 * R10190 美元失效保單作業
 *
 * Revision 1.26  2013/04/23 10:25:27  MISSALLY
 * RA0074 BUG FIX
 *
 * Revision 1.25  2013/04/18 02:09:26  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 * 修正中信匯款檔
 *
 * Revision 1.24  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE滿期生存金受益人帳戶及給付
 *
 * Revision 1.23  2013/02/26 10:23:26  ODCWilliam
 * william wu
 * RA0074
 *
 * Revision 1.21  2012/08/29 04:00:50  ODCWilliam
 * modify:william
 * date:2012-08-28
 * issue:showModalDialog
 *
 * Revision 1.20  2012/08/29 02:57:50  ODCKain
 * Calendar problem
 *
 * Revision 1.19  2012/06/20 00:57:45  MISSALLY
 * QA0134---CASH系統維護信用卡支付增加檢核
 *
 * Revision 1.18  2012/01/04 10:07:10  MISSALLY
 * Q10419
 * 當手續費支付方式為空白時要顯示錯誤訊息
 *
 * Revision 1.17  2011/11/01 07:41:43  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 * FIX 付款方式為(外幣)匯款時，相關的檢核移到儲存或確認時再檢核
 *
 * Revision 1.16  2011/10/21 10:04:37  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 *
 * Revision 1.14  2009/11/11 06:17:38  missteven
 * R90474 修改CASH功能
 *
 * Revision 1.13  2008/09/25 02:55:06  misvanessa
 * R80498_外幣匯款金額不可為零
 *
 * Revision 1.12  2008/08/12 06:56:35  misvanessa
 * R80480_上海銀行外幣整批轉存檔案
 *
 * Revision 1.11  2008/08/06 06:05:29  MISODIN
 * R80132 調整CASH系統for 6種幣別
 *
 * Revision 1.10  2008/04/30 07:50:17  misvanessa
 * R80300_收單行轉台新,新增下載檔案及報表
 *
 * Revision 1.9  2007/11/13 06:44:31  MISVANESSA
 * Q70581_線上新增外幣匯款支付明細(BUGFIX)
 *
 * Revision 1.8  2007/09/07 10:41:38  MISVANESSA
 * R70455_TARGET OUT
 *
 * Revision 1.7  2007/08/03 10:03:49  MISODIN
 * R70477 外幣保單匯款手續費
 *
 * Revision 1.6  2007/03/06 01:52:39  MISVANESSA
 * R70088_SPUL配息
 *
 * Revision 1.5  2007/01/31 08:04:56  MISVANESSA
 * R70088_SPUL配息
 *
 * Revision 1.4  2007/01/05 10:10:30  MISVANESSA
 * R60550_匯退支付方式
 *
 * Revision 1.3  2007/01/04 03:23:04  MISVANESSA
 * R60550_匯退規則修改
 *
 * Revision 1.2  2006/11/30 09:12:45  MISVANESSA
 * R60550_配合SPUL&外幣付款修改
 *
 * Revision 1.1  2006/06/29 09:40:48  MISangel
 * Init Project
 *
 * Revision 1.1.2.20  2006/04/27 09:35:38  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.19  2005/10/14 07:48:21  misangel
 * R50835:支付功能提升
 *
 * Revision 1.1.2.17  2005/05/13 02:31:12  miselsa
 * R30530_身份證可修改
 *
 * Revision 1.1.2.16  2005/05/04 10:26:35  MISANGEL
 * R30530:支付系統-信用卡不需檢核授權日/授權碼
 *
 * Revision 1.1.2.15  2005/04/22 06:25:14  miselsa
 * R30530_加大姓名欄位
 *
 * Revision 1.1.2.14  2005/04/22 06:18:41  miselsa
 * R30530_加大姓名欄位
 *
 * Revision 1.1.2.13  2005/04/12 03:17:08  miselsa
 * R30530_修改取所屬部門資料的JOIN SQL
 *
 * Revision 1.1.2.12  2005/04/04 07:02:24  miselsa
 * R30530 支付系統
 *  
 */
%><%! String strThisProgId = "DISBPSourceMaintain"; //本程式代號 %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
RE reSpace = new RE(" ");
DecimalFormat df = new DecimalFormat("#.00");
DecimalFormat df2 = new DecimalFormat("#.0000");//R60550

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();
int iCurrentDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(calendar.getTime()));
int iCurrentYear = Integer.parseInt(commonUtil.convertWesten2ROCDate1(calendar.getTime()).substring(0,3))+1911;

String strAction = (request.getAttribute("txtAction") != null) ? (String) request.getAttribute("txtAction") : "";
String strReturnMessage = (request.getAttribute("txtMsg") != null) ? (String) request.getAttribute("txtMsg") : "";
String strUserDept = (session.getAttribute("LogonUserDept") != null) ? CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")) : "";
String strUserRight = (session.getAttribute("LogonUserRight") != null) ? CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")) : "";
String strUserId = (session.getAttribute("LogonUserId") != null) ? CommonUtil.AllTrim((String) session.getAttribute("LogonUserId")) : "";
String strUserBrch = (session.getAttribute("LogonUserBrch") != null) ? CommonUtil.AllTrim((String) session.getAttribute("LogonUserBrch")) : "";//RC0036
String strUserArea = (session.getAttribute("LogonUserArea") != null) ? CommonUtil.AllTrim((String) session.getAttribute("LogonUserArea")) : "";//RC0036

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alPSrcCode = new ArrayList();
if (session.getAttribute("PaycdList") == null) {
	alPSrcCode = (List) disbBean.getETable("PAYCD", "", false);
	session.setAttribute("PaycdList", alPSrcCode);
} else {
	alPSrcCode = (List) session.getAttribute("PaycdList");
}

List alBankCode = new ArrayList();
if (session.getAttribute("BankCodeList") == null) {
	alBankCode = (List) disbBean.getBankList();
	session.setAttribute("BankCodeList", alBankCode);
} else {
	alBankCode = (List) session.getAttribute("BankCodeList");
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
}
//R60550 END

//R80132 幣別挑選
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
}
//R80132 END

List alPDetail = new ArrayList();
if (session.getAttribute("PDetailList") != null) {
	alPDetail = (List) session.getAttribute("PDetailList");
}
session.removeAttribute("PDetailList");

// R00386
String bnkprStr = "";
if (session.getAttribute("bnkprStr") == null) {
	List dataList = (List) disbBean.getETable("BNKFR", "");
	//R00365 List dataList = (List) disbBean.getETable( "BNKPR", "" );
	for (int i = 0; i < dataList.size(); i++) {
		Map dataMap = (Map) dataList.get(i);
		bnkprStr += (dataMap.get("ETValue") + ",");
	}
	session.setAttribute("bnkprStr", bnkprStr);
} else {
	bnkprStr = (String) session.getAttribute("bnkprStr");
}

String strPNo = "";
String strPolNo = "";
String strAppNo = "";
String strPName = "";
String strPId = "";
double iPAmt = 0;
String strPdesc = "";
String strPMethod = "";
//String strPMethodDesc = "";
String strPRBank = "";
String strPRAccount = "";
String strPCrdNo = "";
String strPCrdType = "";
String strPCrdEffMY = "";
String strPCrdEffM = "";
String strPCrdEffY = "";
String strPAuthCode = "";
String strPOrgCrdNo = "";//R80300
double iPOrgAMT = 0;//R80300
int iPDate = 0;
String strPDate = "";
String strVoidabled = "";
String strPDispatch = "";
String strPChkm1 = "";
String strPChkm2 = "";
String strPSrcGp = "";
String strPSrcCode = "";
String strBranch = "";
int iPAuthDt = 0;
String strPAuthDt = "";
int iPConDT1 = 0;
String strCurrency = "";
String strUsrInfo ="";//RC0036
//R60550新增12欄位
String strPAYCURR = "";
double iPAYRATE = 0;
double iPAYAMT = 0;
String strPFEEWAY = "";
String strSYMBOL = "";
int iINVDT = 0;
String strINVDTC = "";
String strPSWIFT = "";
String strPBKBRCH = "";
String strPBKCITY = "";
String strPBKCOTRY = "";
String strPENGNAME = "";
double iFPAYAMT = 0;
String strFFEEWAY = "";
int iENTRYDT = 0;//R70088
String strENTRYDTC = "";//R70088
String strPPlanT = "";
String strPBBank = "";

//System.out.println("alPDetail.size()=" + alPDetail.size());

if (alPDetail.size() > 0) {
	DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(0);
	iPConDT1 = objPDetailVO.getIPCfmDt1();

	if (objPDetailVO.getStrPNO() != null)
		strPNo = objPDetailVO.getStrPNO();
	if (strPNo != "")
		strPNo = strPNo.trim();

	if (objPDetailVO.getStrPolicyNo() != null)
		strPolNo = objPDetailVO.getStrPolicyNo();
	if (strPolNo != "")
		strPolNo = strPolNo.trim();

	if (objPDetailVO.getStrAppNo() != null)
		strAppNo = objPDetailVO.getStrAppNo();
	if (strAppNo != "")
		strAppNo = strAppNo.trim();

	if (objPDetailVO.getStrPName() != null)
		strPName = objPDetailVO.getStrPName();
	if (strPName != "")
		strPName = strPName.trim();

	if (objPDetailVO.getStrPId() != null)
		strPId = objPDetailVO.getStrPId();
	if (strPId != "")
		strPId = strPId.trim();

	if (objPDetailVO.getStrPDesc() != null)
		strPdesc = objPDetailVO.getStrPDesc();
	if (strPdesc != "")
		strPdesc = strPdesc.trim();

	if (objPDetailVO.getStrPMethod() != null)
		strPMethod = objPDetailVO.getStrPMethod();
	if (strPMethod != "") {
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

	if (objPDetailVO.getStrPRBank() != null)
		strPRBank = objPDetailVO.getStrPRBank();
	if (strPRBank != "")
		strPRBank = strPRBank.trim();

	if (objPDetailVO.getStrPRAccount() != null)
		strPRAccount = objPDetailVO.getStrPRAccount();
	if (strPRAccount != "")
		strPRAccount = strPRAccount.trim();

	if (objPDetailVO.getStrPCrdNo() != null)
		strPCrdNo = objPDetailVO.getStrPCrdNo();
	if (strPCrdNo != "")
		strPCrdNo = strPCrdNo.trim();

	if (objPDetailVO.getStrPCrdType() != null)
		strPCrdType = objPDetailVO.getStrPCrdType();
	if (strPCrdType != "")
		strPCrdType = strPCrdType.trim();

	if (objPDetailVO.getStrPCrdEffMY() != null)
		strPCrdEffMY = objPDetailVO.getStrPCrdEffMY();
	if (strPCrdEffMY != "") {
		strPCrdEffMY = strPCrdEffMY.trim();
		//System.out.println("strPCrdEffMY.length()=" + strPCrdEffMY.length());
		/*if (strPCrdEffMY.length() > 0) {
			strPCrdEffM = strPCrdEffMY.substring(0, 2);
			strPCrdEffY = strPCrdEffMY.substring(2, 6);
		}*/
	}

	if (objPDetailVO.getStrPAuthCode() != null)
		strPAuthCode = objPDetailVO.getStrPAuthCode();
	if (strPAuthCode != "")
		strPAuthCode = strPAuthCode.trim();
	//R80300 原刷卡號
	if (objPDetailVO.getStrPOrgCrdNo() != null)
		strPOrgCrdNo = objPDetailVO.getStrPOrgCrdNo();
	if (strPOrgCrdNo != "")
		strPOrgCrdNo = strPOrgCrdNo.trim();
	//R80300 原刷金額
	iPOrgAMT = objPDetailVO.getIPOrgAMT();

	if (objPDetailVO.getStrPDispatch() != null)
		strPDispatch = objPDetailVO.getStrPDispatch();
	if (strPDispatch != "")
		strPDispatch = strPDispatch.trim();
	//System.out.println("strPDispatch=" + strPDispatch);
	if (objPDetailVO.getStrPVoidable() != null)
		strVoidabled = objPDetailVO.getStrPVoidable();
	if (strVoidabled != "") {
		strVoidabled = strVoidabled.trim();
	}
	//System.out.println("strVoidabled=" + strVoidabled);
	if (objPDetailVO.getStrPChkm1() != null)
		strPChkm1 = objPDetailVO.getStrPChkm1();
	if (strPChkm1 != "")
		strPChkm1 = strPChkm1.trim();
	//System.out.println("strPChkm1=" + strPChkm1);
	if (objPDetailVO.getStrPChkm2() != null)
		strPChkm2 = objPDetailVO.getStrPChkm2();
	if (strPChkm2 != "")
		strPChkm2 = strPChkm2.trim();
	//System.out.println("strPChkm2=" + strPChkm2);
	if (objPDetailVO.getStrPSrcGp() != null)
		strPSrcGp = objPDetailVO.getStrPSrcGp();
	if (strPSrcGp != "") 
		strPSrcGp = strPSrcGp.trim();

	if (objPDetailVO.getStrPSrcCode() != null)
		strPSrcCode = objPDetailVO.getStrPSrcCode();
	if (strPSrcCode != "") 
		strPSrcCode = strPSrcCode.trim();

	if (objPDetailVO.getStrBranch() != null)
		strBranch = objPDetailVO.getStrBranch();
	if (strBranch != "")
		strBranch = strBranch.trim();

	iPAmt = objPDetailVO.getIPAMT();

	iPDate = objPDetailVO.getIPDate();
	if (iPDate == 0)
		strPDate = "";
	else
		strPDate = Integer.toString(iPDate);

	iPAuthDt = objPDetailVO.getIPAuthDt();
	if (iPAuthDt == 0)
		strPAuthDt = "";
	else
		strPAuthDt = Integer.toString(iPAuthDt);

	if (objPDetailVO.getStrPCurr() != null)
		strCurrency = objPDetailVO.getStrPCurr().trim();
	else
		strCurrency = "";
	//RC0036
	if (objPDetailVO.getStrUsrInfo() != null)
		strUsrInfo = objPDetailVO.getStrUsrInfo().trim();
	else
		strUsrInfo = "";	

	//System.out.println(strUsrInfo);
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
	//RA0074  給定初始值
	if (objPDetailVO.getStrPBKCITY() != null)
		strPBKCITY = objPDetailVO.getStrPBKCITY().trim();
	else
		strPBKCITY = "TP";

	if (objPDetailVO.getStrPBKCOTRY() != null)
		strPBKCOTRY = objPDetailVO.getStrPBKCOTRY().trim();
	else
		strPBKCOTRY = "TW";

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

	// R00386
	strPPlanT = objPDetailVO.getStrPPlant();
	strPBBank = objPDetailVO.getStrPBBank();
}

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
//RA0074 依據銀行代碼自動帶出SWIFT CODE
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

		sBankNo.append("<input type=\"").append("hidden").append("\"").append(" id=\"").append(strDesc).append("\"").append(" value=\"").append(strValue).append("\"").append("/>");
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
StringBuffer sbCardYear = new StringBuffer();
boolean hasEqual = false;
sbCardYear.append("<option value=\"\">&nbsp;</option>");
for(int i=iCurrentYear-10; i<=iCurrentYear+20; i++) {
	if (!strPCrdEffMY.equals("") && String.valueOf(i).equals(strPCrdEffMY.substring(2))) {
		sbCardYear.append("<option value=\"").append(i).append("\" selected=\"selected\">").append(i).append("</option>");
		hasEqual = true;
	} else {
		sbCardYear.append("<option value=\"").append(i).append("\">").append(i).append("</option>");
	}
}
if(!strPCrdEffMY.equals("") && !hasEqual) {
	sbCardYear.append("<option value=\"").append(strPCrdEffMY.substring(2)).append("\" selected=\"selected\">").append(strPCrdEffMY.substring(2)).append("</option>");
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>支付來源--單筆維護確認</TITLE>
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
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value);
	}

	if(document.getElementById("txtAction").value != "")
	{
		if (document.getElementById("txtAction").value == "DISBPSourceConfirm") {
			window.location.href= "<%=request.getContextPath()%>/DISB/DISBPSource/DISBPSourceMaintain.jsp";
		}

		document.getElementById("updateArea").style.display = "block";
		document.getElementById("inqueryArea").style.display = "none";

		var PDateTemp="<%=strPDate%>";
		var PAuthDtTemp="<%=strPAuthDt%>";

		showAddfield();//R60550

		if(PDateTemp !="")
		{
			document.getElementById("txtUPDateC").value =string2RocDate(PDateTemp);
		}
		if(PAuthDtTemp!="")
		{
			document.getElementById("txtUPAuthDtC").value = string2RocDate(PAuthDtTemp);
		}

		makeButtons();
		makeSeleted();
	}
	else
	{
		document.getElementById("inqueryArea").display = "block";
		document.getElementById("updateArea").display = "none";
		WindowOnLoadCommon( document.title+"(查詢)" , '' , strFunctionKeyInquiry1,'' );
		window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
	}
//	disableKey();
//	disableData();
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

	var tempshow="";
//R70088 是與輸入日比較 tmpPDT -> tmpENTRYDT
	if (tmpPOCURR != "NT" 
			|| (tmpPAYCURR != "" && tmpSYMBOL== "S" && tmpENTRYDT <= tmpINVDT)
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

/* 當toolbar frame 中之<新增>按鈕被點選時,本函數會被執行 */
function addAction()
{
	window.status = "";
	document.getElementById("txtAction").value = "A";
	document.getElementById("updateArea").style.display = "block"; 
	document.getElementById("inqueryArea").style.display = "none"; 
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
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

/* 當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行 */
function inquiryAction()
{
	WindowOnLoadCommon( document.title+"(查詢)" , '' , strFunctionKeyInquiry1,'' ) ;
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
}

/* 當toolbar frame 中之<取消確認>按鈕被點選時,本函數會被執行 */
function DISBCanConfirmAction()
{
	var bConfirm = window.confirm("是否確定取消確認該筆資料?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "DISBCancelConfirm";
		document.getElementById("frmMain").submit();
	}
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBPSource/DISBPSourceMaintain.jsp";
}

/* 當toolbar frame 中之<確定>按鈕被點選時,本函數會被執行 */
function confirmAction()
{
	/*	執行 QueryFrameSet.jsp 時,各 QueryString 參數之意義
		RowPerPage		: 每一頁有幾列
		Heading			: 表頭欄位名稱,以逗號','分開每一欄位
		DisplayFields	: 要顯示之資料庫欄位名稱,以逗號分開每一欄位,與Heading相對應
		ReturnFields	: 傳回哪些欄位之值,以逗號分開每一欄位
		Sql				: 待執行之SQL,亦可加入where條件
		TableWidth		: 整個Table之寬度

	 modalDialog 會傳回使用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開

	*/
	document.getElementById("txtAction").value = "I";   
 	mapValue();

	var strSql = "SELECT A.POLICY_NO,A.APP_NO,A.PAY_NAME,A.PAY_ID,A.PAY_AMOUNT,A.PAY_METHOD,A.PAY_DESCRIPTION,A.PAY_STATUS,A.PAY_VOIDABLE,A.PAY_DISPATCH,A.ENTRY_USER,CAST(A.ENTRY_DATE AS CHAR(7)) AS ENTRY_DATE,A.PAY_NO,CAST(A.PAY_DATE AS CHAR(7)) AS PAY_DATE,CAST(A.PAY_CONFIRM_DATE2 AS CHAR(7)) AS PAY_CONFIRM_DATE2,CAST(A.PAY_CONFIRM_TIME2 AS CHAR(6)) AS PAY_CONFIRM_TIME2,A.PAY_CONFIRM_USER2,A.PAY_SOURCE_CODE,A.PAY_REMIT_BANK,A.PAY_REMIT_ACCOUNT,A.PAY_CREDIT_CARD,A.PAY_CREDIT_TYPE,A.PAY_AUTHORITY_CODE,A.PAY_CARD_MMYYYY,A.PAY_BRANCH,CAST(A.PAY_AUTHORITY_DATE AS CHAR(7)) AS PAY_AUTHORITY_DATE,A.PAY_SOURCE_GROUP, C.FLD0004 AS PSRCGPDESC ,CAST(A.PAY_CONFIRM_DATE1 AS CHAR(7))  as PAY_CONFIRM_DATE1 ,CAST(A.PAY_CONFIRM_TIME1 AS CHAR(6)) AS PAY_CONFIRM_TIME1, A.PAY_CONFIRM_USER1,A.PAY_CHECK_M1,A.PAY_CHECK_M2,A.PAY_NO_HISTORY,A.PAY_CURRENCY,A.PAY_BUDGET_BANK,A.PAY_PLAN_TYPE ";
	strSql += ",CAST(B.USRNAM AS CHAR(14))||CAST(T2.FLD0003 AS CHAR(4))||CAST(T1.FLD0003 AS CHAR(4))||CAST(T2.FLD0004 AS CHAR(16))||CAST(T1.FLD0004 AS CHAR(12)) AS USRINFO";// RC0036
	strSql += " from CAPPAYF A ";
	strSql += " join USER B  on B.USRID=A.ENTRY_USER  ";
    strSql += " left outer join ORDUET C on C.FLD0003 = A.PAY_SOURCE_GROUP ";
    strSql += " left outer join ORDUET T1 ON  T1.FLD0003 = B.USRBRCH";   //RC0036 
    strSql += " left outer join ORDUET T2 ON  T2.FLD0003 = B.DEPT  ";//RC0036
    strSql += " WHERE A.PAY_CONFIRM_DATE2=0 AND A.PAY_CONFIRM_TIME2=0 AND A.PAY_CONFIRM_USER2=''  ";
	strSql += " AND C.FLD0002='SRCGP' ";
	strSql += " AND T1.FLD0002 = 'DEPT'  AND T2.FLD0002 = 'DEPT'";

	if(document.getElementById("txtUserRight").value == "99")
	{// 權限為99者, 可查所有資料
	}
	else if(document.getElementById("txtUserRight").value >= "89" && document.getElementById("txtUserRight").value < "99")
	{//只能查部門內所有資料
		if (document.getElementById("txtUserDept").value == "CSC"){                   //RC0036
		    strSql += "  AND B.DEPT IN ('PCD','TYB','TCB','TNB','KHB','CSC')";              //RC0036
		}else{                                                                        //RC0036 
		    if (document.getElementById("txtUserBrch").value == ""){          //RC0036                                                          
	    	strSql += "  AND B.DEPT='"+ document.getElementById("txtUserDept").value +"' ";//RC0036 
	    	}else{//RC0036 
	    	strSql += "  AND B.DEPT='"+ document.getElementById("txtUserDept").value +"' ";//RC0036 
	    	strSql += "  AND B.USRBRCH='"+ document.getElementById("txtUserBrch").value +"' ";//RC0036 
	    	}                                                                          //RC0036 
	    }	                                                                          //RC0036 
	}                                                                                 //RC0036 
	else
	{//只能查自己所輸入的資料
		strSql += "  AND A.ENTRY_USER= '" + document.getElementById("txtUserId").value  + "' ";
	}
	if( document.getElementById("txtPolicyNo").value != "" ) {
		strSql += " AND A.POLICY_NO = '" + document.getElementById("txtPolicyNo").value.toUpperCase() + "' ";
	}
	if( document.getElementById("txtAppNo").value != "" ) {
		strSql += "  AND  A.APP_NO= '" + document.getElementById("txtAppNo").value.toUpperCase() + "' ";
	}
	if( document.getElementById("txtPName").value != "" ) {
		strSql += "  AND A.PAY_NAME like '^" +  document.getElementById("txtPName").value + "^' ";
	}
	if( document.getElementById("txtPid").value != "" ) {
		strSql += "  AND A.PAY_ID = '" +  document.getElementById("txtPid").value.toUpperCase() + "' ";
	}
	if( document.getElementById("txtPAMT").value != "" ) {
		strSql += " AND  A.PAY_AMOUNT = " + document.getElementById("txtPAMT").value + " ";
	}
	if( document.getElementById("txtPRBank").value != "" ) {
		strSql += "  AND  A.PAY_REMIT_BANK= '" +  document.getElementById("txtPRBank").value + "' ";
	}
	if( document.getElementById("txtPRAccount").value != "" ) {
		strSql += " AND  A.PAY_REMIT_ACCOUNT = '" + document.getElementById("txtPRAccount").value + "' ";
	}
	if( document.getElementById("txtPCrdNo").value != "" ){
		strSql += "  AND  A.PAY_CREDIT_CARD= '" + document.getElementById("txtPCrdNo").value + "' ";
	}
	if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value != "") {
		strSql += " AND  A.PAY_DATE BETWEEN " + document.getElementById("txtPStartDate").value + " and " + document.getElementById("txtPEndDate").value;
	} else if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value == "") {
		strSql += "  AND A.PAY_DATE >= " + document.getElementById("txtPStartDate").value ;
	} else if (document.getElementById("txtPStartDate").value == "" && document.getElementById("txtPEndDate").value != "") {
		strSql += " AND  A.PAY_DATE <= " + document.getElementById("txtPEndDate").value ;
	}

	if (document.getElementById("txtEntryStartDate").value != "" && document.getElementById("txtEntryEndDate").value != "")  {
		strSql += " AND  A.ENTRY_DATE BETWEEN " + document.getElementById("txtEntryStartDate").value + " and " + document.getElementById("txtEntryEndDate").value;
	} else if (document.getElementById("txtEntryStartDate").value != "" && document.getElementById("txtEntryEndDate").value == "") {
		strSql += "  AND A.ENTRY_DATE >= " + document.getElementById("txtEntryStartDate").value ;
	} else if (document.getElementById("txtEntryStartDate").value == "" && document.getElementById("txtEntryEndDate").value != "") {
		strSql += " AND  A.ENTRY_DATE <= " + document.getElementById("txtEntryEndDate").value ;
	}

	if (document.getElementById("txtUpdStartDate").value != "" && document.getElementById("txtUpdEndDate").value != "") {
		strSql += "  AND A.UPDATE_DATE = " + document.getElementById("txtUpdStartDate").value + " and " + document.getElementById("txtUpdEndDate").value;
	} else if (document.getElementById("txtUpdStartDate").value != "" && document.getElementById("txtUpdEndDate").value == "") {
		strSql += "  AND A.UPDATE_DATE >= " + document.getElementById("txtUpdStartDate").value ;
	} else if (document.getElementById("txtUpdStartDate").value == "" && document.getElementById("txtUpdEndDate").value != "") {
		strSql += "  AND A.UPDATE_DATE <= " + document.getElementById("txtUpdEndDate").value ;
	}

	if( document.getElementById("selPVoidable").value != "" ) {
		strSql += "   AND A.PAY_VOIDABLE= '" + document.getElementById("selPVoidable").value + "' ";
	}
	if( document.getElementById("selDispatch").value != "" ) {
		strSql += "   AND A.PAY_DISPATCH= '" + document.getElementById("selDispatch").value + "' ";
	}	

   	if( document.getElementById("txtEntryUsr").value != "" ) {
		strSql += "  AND A.ENTRY_USER like '^" +  document.getElementById("txtEntryUsr").value + "^' ";
	}
   	if( document.getElementById("selCurrency").value != "" ) {
		strSql += "  AND A.PAY_CURRENCY = '" +  document.getElementById("selCurrency").value + "'";
	}

	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=820";

	var strReturn = "";
	//modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
	//R00393 edit by Leo Huang
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","保單號碼,要保書號碼,受款人姓名,受款人ID,支付金額,付款方式,付款內容,付款狀態,作廢否,急件否,輸入者,輸入日");
	session.setAttribute("DisplayFields", "POLICY_NO,APP_NO,PAY_NAME,PAY_ID,PAY_AMOUNT,PAY_METHOD,PAY_DESCRIPTION,PAY_STATUS,PAY_VOIDABLE,PAY_DISPATCH,ENTRY_USER,ENTRY_DATE");
	session.setAttribute("ReturnFields", "PAY_NO,PAY_METHOD,PAY_DATE,PAY_NAME,PAY_ID,PAY_AMOUNT,PAY_STATUS,PAY_CONFIRM_DATE2,PAY_CONFIRM_TIME2,PAY_CONFIRM_USER2,PAY_DESCRIPTION,PAY_SOURCE_CODE,PAY_VOIDABLE,PAY_DISPATCH,PAY_REMIT_BANK,PAY_REMIT_ACCOUNT,PAY_CREDIT_CARD,PAY_CREDIT_TYPE,PAY_AUTHORITY_CODE,PAY_CARD_MMYYYY,POLICY_NO,APP_NO,PAY_BRANCH,PAY_AUTHORITY_DATE,PAY_SOURCE_GROUP,PSRCGPDESC,PAY_CONFIRM_DATE1,PAY_CONFIRM_TIME1,PAY_CONFIRM_USER1,PAY_CHECK_M1,PAY_CHECK_M2,PAY_NO_HISTORY,PAY_CURRENCY,PAY_BUDGET_BANK,PAY_PLAN_TYPE,USRINFO");
%>
	if( strReturnValue != "" )
	{
		//enableAll();
		var returnArray = string2Array(strReturnValue,",");

		document.getElementById("txtUPolNo").value = returnArray[0];
		document.getElementById("txtUAppNo").value = returnArray[1];
		var strName = returnArray[2];
		strName = strName.replace(/^[\s　]+|[\s　]+$/g, "");
		document.getElementById("txtUPName").value =strName;
//		document.getElementById("txtUPName").value = returnArray[2];
		document.getElementById("txtUPId").value = returnArray[3];
		document.getElementById("txtUPAMT").value = returnArray[4];		
		var strPMethod = returnArray[5];
		document.getElementById("hidPMethod").value = returnArray[5];
		//makedataSelected("selUPMethod",strPMethod);

		document.getElementById("txtUPDesc").value = returnArray[6];	
		var strUPStatus = returnArray[7];
		var strUPVoidable = returnArray[8];
		var strUPDispatch = returnArray[9];
		if(strUPDispatch == "Y") {
			document.frmMain.rdUDispatch[0].checked = true;
		} else {
			document.frmMain.rdUDispatch[1].checked = true;
		}
		document.getElementById("txtUPNO").value = returnArray[10];
		if( returnArray[11] == "0") {
			document.getElementById("txtUPDate").value = "";
			document.getElementById("txtUPDateC").value = "";
		} else {
			document.getElementById("txtUPDate").value = returnArray[11];
			document.getElementById("txtUPDateC").value =string2RocDate(returnArray[11]);
		}
		var strUPCfmDT = returnArray[12];
		var strUPCfmTM = returnArray[13];
		var strUPCfmUsr = returnArray[14];
		//document.getElementById("txtUPSrcCode").value = returnArray[15] + "--"+returnArray[25];
        document.getElementById("hidPSrcCode").value = returnArray[15];
		document.getElementById("txtUPRBank").value = returnArray[16];
		document.getElementById("txtUPRAccount").value = returnArray[17];
		document.getElementById("txtUPCrdNo").value = returnArray[18];
		document.getElementById("txtPUCrdType").value = returnArray[19];
		//makedataSelected("selPUCrdType",returnArray[19]);		

		document.getElementById("txtUPAuthCode").value = returnArray[20];
		document.getElementById("txtUPCrdEffMY").value = returnArray[21];

		document.getElementById("txtUPolDiv").value = returnArray[22];
		if( returnArray[23] == "0") {
			document.getElementById("txtUPAuthDt").value = "";
			document.getElementById("txtUPAuthDtC").value = "";
		} else {
			document.getElementById("txtUPAuthDt").value = returnArray[23];
			document.getElementById("txtUPAuthDtC").value = string2RocDate(returnArray[23]);
		}
		document.getElementById("txtUPSrcGp").value = returnArray[24]+ "--"+returnArray[25];
		var strChkM1 = returnArray[29];
		if(strChkM1=="Y") {
			document.frmMain.rdUPCHKM1[0].checked = true;
		} else {
			document.frmMain.rdUPCHKM1[1].checked = true;
		}
		var strChkM2 = returnArray[30];
		if(strChkM2=="Y") {
			document.frmMain.rdUPCHKM2[0].checked = true;
		} else {
			document.frmMain.rdUPCHKM2[1].checked = true;
		}

		document.getElementById("txtAction").value = "I";
			
		/*R30530 modi 20050218  -->增加取消確認的功能*/
		//PAY_CONFIRM_DATE1-->returnArray[26] ,PAY_CONFIRM_TIME1-->returnArray[27], PAY_CONFIRM_USER1-->returnArray[28]
		document.getElementById("hidPConDT1").value = returnArray[26];
		document.getElementById("hidPnoH").value = returnArray[31];
		document.getElementById("txtCurrency").value = returnArray[32];
		document.getElementById("txtUsrInfo").value = returnArray[35];//RC0036
		// R00386 
		document.getElementById( "txtPBBank" ).value = returnArray[33];
		document.getElementById( "txtPlanType" ).value = returnArray[34];
		//R60550 新增12個欄位
		document.getElementById("txtAction").value = "INQ";
		document.getElementById("frmMain").submit();	
		makeButtons();
		makeSeleted();

    	document.getElementById("updateArea").style.display = "block"; 
    	document.getElementById("inqueryArea").style.display = "none"; 
		disableAll();
	}
}

/* 當toolbar frame 中之<儲存>按鈕被點選時,本函數會被執行 */
function saveAction()
{
	enableAll();
	mapValue();
	if( areAllFieldsOK() )
	{
		if(checkRadio())
		{
			var varMsg = "";
			var varStatus = true;

			//R00135 應財務要求支付原因不可空白
			if(document.getElementById("selUPSrcCode").value == "")
			{
				varMsg = "請選擇支付原因\r\n";
				varStatus = false;
			}

			//R10260 匯款檢核
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

			//QA0134 信用卡相關資訊檢核
			var varMsgC = "";
			if(document.getElementById("selUPMethod").value == "C")
			{
				if(document.getElementById("txtUPCrdNo").value == "")
				{
					varMsgC += "-->信用卡卡號不可空白\r\n";
				}
				else 
				{
					if (document.getElementById("txtUPCrdNo").value.length != 16)
					{
						varMsgC += "-->信用卡卡號需為16碼數字\r\n";
					}
				}
				var selectObjM = document.getElementById("selUPCrdEffM");
				var selectObjY = document.getElementById("selUPCrdEffY");
				var varSelectM = "";
				var varSelectY = "";
				for(var i=0; i<selectObjM.options.length; i++) {
					if(selectObjM.options[i].selected == true) {
						varSelectM = selectObjM.options[i].value;
						break;
					}
				}
				for(var i=0; i<selectObjY.options.length; i++) {
					if(selectObjY.options[i].selected == true) {
						varSelectY = selectObjY.options[i].value;
						break;
					}
				}
				if(varSelectM == "" || varSelectY == "")
				{
					varMsgC += "-->請選擇有效月年\r\n";
				}
				if(document.getElementById("txtUPAuthDtC").value == "")
				{
					varMsgC += "-->請輸入授權交易日\r\n";
				}
				if(document.getElementById("txtUPAuthDtC").value.length != 9 )
				{
					varMsgC += "-->授權交易日格式為YYY/MM/DD \r\n";
				}
				if (document.getElementById("txtUPAuthDt").value > <%=iCurrentDate%>)
				{
					varMsgC += "-->授權交易日大於目前日期 \r\n";
				}

				if(varMsgC != "")
				{
					varMsg += "你所選擇的支付方式是[信用卡]\r\n";
					varMsg += varMsgC;
					varStatus = false;
				}
			}
			//RB0302必須為急件之保單借款才能以現金支付
			if(document.getElementById("selUPMethod").value == "E")
			{
				if(!(document.getElementById("txtCurrency").value == "NT" && (document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") && document.frmMain.rdUDispatch[0].checked))
				{
					varMsg += "必須為急件之保單借款才能以現金支付!!\n\r";
					varStatus = false;
				}
			}
			//RC0036 急件:分公司以及分處人員，不可支票支付
			if(document.getElementById("selUPMethod").value == "A")
			{
				if(document.frmMain.rdUDispatch[0].checked && document.getElementById("txtUserArea").value != "")
				{
					varMsg += "此作業單位急件時，不可以支票支付!!\n\r";
					varStatus = false;
				}
			}
           //RC0036 急件:分處人員不可現金支付
			if(document.getElementById("selUPMethod").value == "E")
			{
				//if(document.frmMain.rdUDispatch[0].checked && document.getElementById("txtUserArea").value != "" && document.getElementById("txtUserBrch)").value != "")
				//QC0290→因原程式多了個")"，造成執行錯誤。
				if(document.frmMain.rdUDispatch[0].checked && document.getElementById("txtUserArea").value != "" && document.getElementById("txtUserBrch").value != "")
				{
					varMsg += "此作業單位急件時，不可以現金支付!!\n\r";
					varStatus = false;
				}
			}
			if(varStatus)
			{
				<%-- R00386 --%>
				if( checkFeeWay() ) 
				{
					if (window.confirm("儲存完畢後，是否要確認該筆支付來源?"))
					{
						document.getElementById("nextAction").value = "DISBPSourceConfirm";
					}
					document.getElementById("frmMain").submit();
					disableAll();
				}
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

function checkFeeWay() 
{
	var payMethod = document.getElementById( "selUPMethod" ).value;
	var polCurr = document.getElementById( "txtCurrency" ).value;
	var planType = document.getElementById( "txtPlanType" ).value;
	var currentFeeWay = document.getElementById( "selFEEWAY" ).value;

	//Q10419 手續費支付方式不得為空白
	if( currentFeeWay == "" )
	{
		alert("手續費支付方式不得為空白!!");
		return false;
	}
	//R00386 檢查 / 提醒手續費支付方式
	else if( payMethod == "D" && polCurr != "NT" && ( planType == " " || planType == "" ) ) 
	{
		var myFeeWayEle = document.getElementById( "selUPSrcCode" );
		var myFeeWayText = myFeeWayEle.options.item( myFeeWayEle.selectedIndex ).innerHTML;
		var myFeeWay = myFeeWayText.replace( /&nbsp;/g, " " ).substring( 3, 11 ).replace( /^\s*|\s*$/g, "" );
		var payCode = myFeeWayText.substring( 0, 2 );

		var bnkfrList = document.getElementById( "strBnkfrList" ).value;
		<%--
		// 當 OUR 時, 若付款銀行與收款銀行不同, 修改為 SHA 或 BEN
		/*if( myFeeWay == "OUR" ) {
			
			var rbank = document.getElementById( "txtUPRBank" ).value;
			if( rbank.length > 3 )
				rbank = rbank.substring( 0, 3 );
			else
				rbank = rbank + "   ".substring( 0, 3 - rbank.length );
			
			var checkStr = polCurr + rbank;
			if( bnkfrList.indexOf( checkStr ) == -1 ) {	// 不是公司指定分行
				// 依支付原因決定要分攤或客戶自付手續費
				if( "<%= DISBBean.FCTRI_FEEWAY_SHA_CODETABLE %>".indexOf( payCode ) != -1 )
					myFeeWay = "SHA";
				else
					myFeeWay = "BEN";
			}
		}*/
		--%>
		// 當 BEN/SHA 時, 若付款銀行與收款銀行相同, 修改為 OUR(公司支付)
		if( myFeeWay == "BEN" || myFeeWay == "SHA" ) {
			var rbank = document.getElementById( "txtUPRBank" ).value;
			if( rbank.length > 3 )
				rbank = rbank.substring( 0, 3 );
			else
				rbank = rbank + "   ".substring( 0, 3 - rbank.length );

			var checkStr = polCurr + rbank;
			if( bnkfrList.indexOf( checkStr ) != -1 ) {	// 是公司指定分行
				myFeeWay = "OUR";
			}
		}

		if( currentFeeWay == myFeeWay )
			return true;

		var currentFeeWayDesc = getFeeWayDesc( currentFeeWay );
		var myFeeWayDesc = getFeeWayDesc( myFeeWay );

		var msg = "檢核結果手續費支付方式應為 " + myFeeWayDesc +"\n與使用者選擇的 " + currentFeeWayDesc
				+ "結果不符合。\n\n若" + currentFeeWayDesc + "結果正確無誤請點選「確認」\n否則請按「取消」回之前作業修改";
		return confirm( msg );

	} else {
		return true;
	}
}

function getFeeWayDesc( feeWay ) 
{
	if( feeWay == "OUR" )
		return "『公司支付(OUR)』";
	else if( feeWay == "BEN" )
		return "『客戶支付(BEN)』";
	else if( feeWay == "SHA" )
		return "『各自負擔(SHA)』";
	else
		return "『 』";
}

// R00386 依支付原因與匯款銀行代碼自動調整手續費支付方式
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
	//var userFeeWay = document.getElementById( "selFEEWAY" ).value;

	if( document.getElementById( "strBnkfrList").value.indexOf( bnkfrCondition ) != -1 )
		document.getElementById( "selFEEWAY" ).value = "OUR";
	else
		document.getElementById( "selFEEWAY" ).value = tableFeeWay;

	//alert( paySourceDesc.substring( 3, 6 ) );
}

function updatePRBankByKeyup() 
{
	var field = document.getElementById( "txtUPRBank" );
	autoComplete( field, field.form.options, "value", true, "selList" );
	changeFeeWayByRules();
	WriteCode(); //RA0074 依據銀行代碼帶出SWIFT CODE
}

function updatePRBankBySelection() 
{
	var sel = document.getElementById( "prbankList" );
	document.getElementById( "txtUPRBank" ).value = sel.options[ sel.selectedIndex ].value;
	changeFeeWayByRules();
	WriteCode(); //RA0074 依據銀行代碼帶出SWIFT CODE
}

function DISBPConfirmAction() 
{
	var varMsg = "";
	var varStatus = true;
	//R00135 應財務要求支付原因不可空白
	if(document.getElementById("selUPSrcCode").value == "")
	{
		varMsg = "請選擇支付原因\r\n";
		varStatus = false;
	}
	//R10260 匯款檢核
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
	//RB0302必須為急件之保單借款才能以現金支付
	if(document.getElementById("selUPMethod").value == "E")
	{
		if(!(document.getElementById("txtCurrency").value == "NT" && (document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") && document.frmMain.rdUDispatch[0].checked))
		{
			varMsg += "必須為急件之保單借款才能以現金支付!!\n\r";
			varStatus = false;
		}
	}

	if(varStatus)
	{
		var bConfirm = window.confirm("是否確定要確認該筆支付來源?");
		if( bConfirm )
		{
			enableAll();
			document.getElementById("txtAction").value = "DISBPSourceConfirm";
			document.getElementById("frmMain").submit();
	        disableAll();
		}
	}
	else
	{
		alert(varMsg);
	}
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
	if( objThisItem.id == "txtUPName" )
	{
		objThisItem.value = objThisItem.value.replace(/^[\s　]+|[\s　]+$/g, "");		// 刪除頭尾的空白字串
		if( objThisItem.value == "" )
		{
			strTmpMsg = "受款人姓名不可空白";
			bReturnStatus = false;
		}
	}
//	else if( objThisItem.id == "txtUPId" )
//	{
//		if( objThisItem.value == "" )
//		{
//			strTmpMsg = "受款人ID不可空白";
//			bReturnStatus = false;
//		}
//	}
	else if( objThisItem.id == "txtUPAMT" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "受款金額不可空白";
			bReturnStatus = false;
		}
	}	
	else if( objThisItem.id == "txtUPDateC" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "付款日期不可空白";
			bReturnStatus = false;
		}
		if (document.getElementById("hidPnoH").value != "" )
		{
			if (document.getElementById("txtCurrentDate").value > document.getElementById("txtUPDate").value)
			{
				strTmpMsg = " 付款日期必須 >= 系統日期 \r\n";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.id == "selUPMethod" )
	{
		if( objThisItem.value == "A")
		{
			strTmpMsg = "你所選擇的支付方式是[支票]\r\n";
			// R80132  if (document.getElementById("txtCurrency").value =="US"){
			// R80132     strTmpMsg += "-->美元保單不允許開票";
			if (document.getElementById("txtCurrency").value !="NT")
			{  // R80132
				strTmpMsg += "-->外幣保單不允許開票";			             // R80132
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPCrdNo").value !="" 
					|| document.getElementById("selPUCrdType").value !="" 
					|| document.getElementById("txtUPCrdEffMY").value !="" 
					|| document.getElementById("txtUPAuthCode").value !="" 
					|| document.getElementById("txtUPAuthDtC").value !="" 
					|| document.getElementById("txtUPRBank").value !="" 
					|| document.getElementById("txtUPRAccount").value !="")//R60550新增銀行帳號
			{
				strTmpMsg += "-->匯款銀行/匯款帳號/信用卡卡號/卡別/有效年月/授權碼/授權交易日,不需輸入";
				bReturnStatus = false;
			}

			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "B")
		{
			strTmpMsg = "你所選擇的支付方式是[匯款]\r\n";
			if(document.getElementById("txtUPRBank").value =="" 
					&& document.getElementById("txtCurrency").value =="NT")
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
			document.getElementById("txtUPName").value = document.getElementById("txtUPName").value.replace(/^[\s　]+|[\s　]+$/g, "");
			if(document.getElementById("txtUPName").value == "" )
			{
				strTmpMsg += "-->受款人姓名不可空白\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPCrdNo").value !="" 
					|| document.getElementById("selPUCrdType").value !="" 
					|| document.getElementById("txtUPCrdEffMY").value !="" 
					|| document.getElementById("txtUPAuthCode").value !="" 
					|| document.getElementById("txtUPAuthDtC").value !="")
			{
				strTmpMsg += "-->信用卡卡號/卡別/有效年月/授權碼/授權交易日,不需輸入\r\n";
				bReturnStatus = false;
			}

			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "C")
		{
			strTmpMsg = "你所選擇的支付方式是[信用卡]\r\n";
			// R80132  if (document.getElementById("txtCurrency").value =="US")
			if (document.getElementById("txtCurrency").value !="NT")  // R80132			
			{
				// R80132  strTmpMsg += "-->美元保單不允許信用卡給付";
				strTmpMsg += "-->外幣保單不允許信用卡給付";	// R80132		
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRBank").value !="" 
					|| document.getElementById("txtUPRAccount").value !="" )
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
				if (document.getElementById("txtUPCrdNo").value.length != 16)
				{
					strTmpMsg += "-->信用卡卡號需為16碼數字\r\n";
					bReturnStatus = false;
				}
			}
			if(document.getElementById("txtUPCrdEffMY").value =="" )
			{
				strTmpMsg += "-->請選擇有效月年\r\n";
				bReturnStatus = false;
			}
			//R80300 信用卡必輸入交易授權日
			if(document.getElementById("txtUPAuthDtC").value =="" )
			{
				strTmpMsg += "-->請輸入授權交易日\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPAuthDtC").value.length != 9 )
			{
				strTmpMsg += "-->授權交易日格式為YYY/MM/DD \r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtUPAuthDt").value > <%=iCurrentDate%>)
			{
				strTmpMsg += "-->授權交易日大於目前日期 \r\n";
				bReturnStatus = false;
			}
		}
		//R60550 投資起始日前不需強制KEY外幣匯款欄位
		else if( objThisItem.value == "D")
		{
			strTmpMsg = "你所選擇的支付方式是[外幣匯款]\r\n";
			if(document.getElementById("txtUPRAccount").value == "" )
			{
				strTmpMsg += "-->匯款帳號不可空白\r\n";
				bReturnStatus = false;
			}
			//R80480外幣匯款必輸入ID
			if (document.getElementById("txtUPId").value == "")
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
			if((document.getElementById("txtUPRBank").value =="" 
						&& document.getElementById("hidENTRYDT").value <= document.getElementById("txtINVDT").value) 
				//R70545  || (document.getElementById("txtUPRBank").value =="" && document.getElementById("selUPSrcCode").value =="B8"))
			 	|| (document.getElementById("txtUPRBank").value =="" 
						//R00440 SN滿期金(document.getElementById("selUPSrcCode").value =="B8" || document.getElementById("selUPSrcCode").value =="B9")) )
			 			&& (document.getElementById("selUPSrcCode").value =="B8" 
			 					|| document.getElementById("selUPSrcCode").value =="B9" 
			 					|| document.getElementById("selUPSrcCode").value =="BB")) )  //R00440 SN滿期金
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
			if (document.getElementById("selPBKCOTRY").value =="")
			{
				strTmpMsg += "-->銀行國別不可空白\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPENGNAME").value =="")
			{
				strTmpMsg += "-->受款人英文姓名不可空白\r\n";
				bReturnStatus = false;
			}
			var reg=/[^A-Z\- ]/g;
			if (reg.test(document.getElementById("txtPENGNAME").value))
			{
				strTmpMsg += "-->受款人英文姓名只能為大寫英文字母";
				bReturnStatus = false;
			}
		}
		//RB0302必須為台幣急件之保單借款才能以現金支付
		else if( objThisItem.value == "E")
		{
			if(!(document.getElementById("txtCurrency").value == "NT" && (document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") && document.frmMain.rdUDispatch[0].checked))
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
		strTmpMsg = "需要為急件,始可以取消支票劃線!\r\n";
		bReturnStatus = false;
	}*/
	// R80132
	if( document.getElementById("txtCurrency").value !="NT" && document.frmMain.rdUDispatch[0].checked  )
	{
		strTmpMsg += "外幣保單不可勾選急件!\r\n";
		bReturnStatus = false;
	}
	//R80132 END
	//RB0302不可同時取消支票禁背及支票劃線
   	if( document.frmMain.rdUPCHKM1[1].checked && document.frmMain.rdUPCHKM2[1].checked  )
	{
		strTmpMsg += "不可同時取消支票禁背及支票劃線!\r\n";
		bReturnStatus = false;
	}

	if( !bReturnStatus )
	{
		strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}

function mapValue()
{
    if(document.getElementById("txtAction").value == "I")   
	{
		document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value);
		document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value);
		document.getElementById("txtEntryStartDate").value = rocDate2String(document.getElementById("txtEntryStartDateC").value);
	   	document.getElementById("txtEntryEndDate").value = rocDate2String(document.getElementById("txtEntryEndDateC").value);
	   	document.getElementById("txtUpdStartDate").value = rocDate2String(document.getElementById("txtUpdStartDateC").value);
	   	document.getElementById("txtUpdEndDate").value = rocDate2String(document.getElementById("txtUpdEndDateC").value);
	}
    if(document.getElementById("txtAction").value == "U")
	{
		document.getElementById("txtUPDate").value = rocDate2String(document.getElementById("txtUPDateC").value);
		document.getElementById("txtUPCrdEffMY").value =  document.getElementById("selUPCrdEffM").value + document.getElementById("selUPCrdEffY").value;
		document.getElementById("txtUPAuthDt").value = rocDate2String(document.getElementById("txtUPAuthDtC").value);
		document.getElementById("txtPUCrdType").value = document.getElementById("selPUCrdType").value;
		//document.getElementById("txtCurrency").value = document.getElementById("selCurrency").value;
		document.getElementById("txtPBKBRCH").value = document.getElementById("txtPBKBRCH").value.toUpperCase(); //RA0074 
		document.getElementById("txtPBKCITY").value = document.getElementById("txtPBKCITY").value.toUpperCase(); //RA0074
		document.getElementById("txtPENGNAME").value = document.getElementById("txtPENGNAME").value.toUpperCase(); //RA0074
	}
}

function makeButtons()
{
	if(document.getElementById("hidPConDT1").value=="0")
	{
		/*R30530  modi 20050223 -->取消為卡別為要欄位的限制 start */
		//if(strPMethod == "A" || (strPMethod == "B" && document.getElementById("txtUPRBank").value !="" && document.getElementById("txtUPRAccount").value !=="") || (strPMethod == "C" && document.getElementById("txtUPCrdNo").value !="" && document.getElementById("selUPCrdType").value !=="" && document.getElementById("txtUPAuthCode").value !=="" && document.getElementById("txtUPAuthDtC").value !==""))
		/*R30530  modi 20050428 -->取消為授權碼為要欄位的限制 start */
		//if(document.getElementById("hidPMethod").value == "A" || (document.getElementById("hidPMethod").value == "B" && document.getElementById("txtUPRBank").value !="" && document.getElementById("txtUPRAccount").value !=="") || (document.getElementById("hidPMethod").value == "C" && document.getElementById("txtUPCrdNo").value !="" && document.getElementById("txtUPAuthCode").value !=="" && document.getElementById("txtUPAuthDtC").value !==""))
		//if(document.getElementById("hidPMethod").value == "A" || (document.getElementById("hidPMethod").value == "B" && document.getElementById("txtUPRBank").value !="" && document.getElementById("txtUPRAccount").value !=="") || (document.getElementById("hidPMethod").value == "C" && document.getElementById("txtUPCrdNo").value !=""))
		//R60550新增外幣匯款"D"檢核
		//R70088投資起始日前要KEY匯款銀行 投資起始日是與輸入日比較 匯款日->輸入日
		if(document.getElementById("hidPMethod").value == "A" 
			|| (document.getElementById("hidPMethod").value == "B" 
					&& document.getElementById("txtUPRBank").value !="" 
					&& document.getElementById("txtUPRAccount").value !=="" 
					&& document.getElementById("txtCurrency").value == "NT" ) 
			|| (document.getElementById("hidPMethod").value == "D" 
					&& document.getElementById("selPSWIFT").value != "" 
					&& document.getElementById("txtPBKCITY").value != "" 
					&& document.getElementById("txtPBKBRCH").value != "" 
					&& document.getElementById("txtPENGNAME").value != "" 
					&& document.getElementById("txtUPRAccount").value !="" 
					&& document.getElementById("hidENTRYDT").value > document.getElementById("txtINVDT").value) 
            || (document.getElementById("hidPMethod").value == "D" 
            		&& document.getElementById("txtUPRBank").value !="" 
            		&& document.getElementById("txtUPRAccount").value !="" 
					//R70455 && (document.getElementById("hidENTRYDT").value <= document.getElementById("txtINVDT").value || document.getElementById("selUPSrcCode").value =="B8")) || 
					&& (document.getElementById("hidENTRYDT").value <= document.getElementById("txtINVDT").value 
							//R00440SN滿期金                   document.getElementById("selUPSrcCode").value =="B8" || document.getElementById("selUPSrcCode").value =="B9") ) || 
							|| document.getElementById("selUPSrcCode").value =="BB" 
							|| document.getElementById("selUPSrcCode").value =="B8" 
							|| document.getElementById("selUPSrcCode").value =="B9") ) //R00440SN滿期金
			|| (document.getElementById("hidPMethod").value == "B" 
					&& document.getElementById("txtUPRAccount").value !=="" 
					&& document.getElementById("txtCurrency").value == "US" ) 
			|| (document.getElementById("hidPMethod").value == "C" 
					&& document.getElementById("txtUPAuthDtC").value !="" 
					&& document.getElementById("txtUPCrdEffMY").value !="" 
					&& document.getElementById("txtUPCrdNo").value !=""))
		{ /*R30530  modi 20050223 -->取消為卡別為要欄位的限制 end*/
			WindowOnLoadCommon( document.title+"(支付確認/修改)" , '' , strDISBFunctionKeySourceC,'' ) ;
		}
		else
		{
			WindowOnLoadCommon( document.title+"(修改)" , '' , strDISBFunctionKeySourceU,'' );
		}
	}
	else
	{
		WindowOnLoadCommon( document.title+"(取消確認)" , '' , strDISBFunctionKeyInquiry_1,'' );
	}
	disableAll();
}

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
	for(var i=0;i< document.getElementById("selUPSrcCode").options.length;i++)
	{
		if( document.getElementById("hidPSrcCode").value== document.getElementById("selUPSrcCode").options.item(i).value )
		{	
			document.getElementById("selUPSrcCode").options.item(i).selected = true;
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

//WILLIAM 2013/02/21 RA0074 依銀行代碼前三碼帶出SWIFT CODE
function WriteCode() {
	document.getElementById("txtPSWIFT").value = "";
	document.getElementById("selPSWIFT").value = "";

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
	return result.toUpperCase();
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
	<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpsource.DISBSMaintainServlet" id="frmMain" name="frmMain" method="post">
		<TABLE border="1" width="452" height="333" id=inqueryArea>
			<TBODY>
				<TR>
					<TD align="right" class="TableHeading" width="101">保單號碼：</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPolicyNo" id="txtPolicyNo"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101" height="24">要保書號碼：</TD>
					<TD height="24"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtAppNo" id="txtAppNo"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">受款人姓名：</TD>
					<TD><INPUT class="Data" size="40" type="text" maxlength="40" id="txtPName" name="txtPName" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">受款人ID：</TD>
					<TD width="333"><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPid" name="txtPid" value=""></TD>
<!--			<TR>
					<TD align="right" class="TableHeading" width="101">支付狀態：</TD>
					<TD width="333">
						<select size="1" name="selPStatus" id="selPStatus">
							<option value=""></option>
							<option value="A">A:失敗</option>
							<option value="B">B:成功</option>
						</select>
					</TD>
				</TR>-->
				<TR>
					<TD align="right" class="TableHeading" width="101">支付金額：</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPAMT" id="txtPAMT" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">付款日期：</TD>
					<TD>
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPStartDateC" name="txtPStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
						<INPUT type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> ~ 
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC" name="txtPEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
						<INPUT type="hidden" name="txtPEndDate" id="txtPEndDate" value="">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">輸入日期：</TD>
					<TD>
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
						<INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate" value=""> ~ 
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryEndDateC" name="txtEntryEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtEntryEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
						<INPUT type="hidden" name="txtEntryEndDate" id="txtEntryEndDate" value="">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">匯款銀行代號：</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPRBank" id="txtPRBank" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">匯款銀行帳號：</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPRAccount" id="txtPRAccount" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">信用卡號碼：</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCrdNo" name="txtPCrdNo" value="">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">異動日期：</TD>
					<TD width="333" valign="middle">
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUpdStartDateC" name="txtUpdStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtUpdStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
						<INPUT type="hidden" name="txtUpdStartDate" id="txtUpdStartDate" value=""> ~ 
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUpdEndDateC" name="txtUpdEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtUpdEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
						<INPUT type="hidden" name="txtUpdEndDate" id="txtUpdEndDate" value="">
					</TD>
				<TR>
					<TD align="right" class="TableHeading" width="101">作廢否：</TD>
					<TD width="333" valign="middle">
						<select size="1" name="selPVoidable" id="selPVoidable">
							<option value=""></option>
							<option value="Y">是</option>
							<option value="">否</option>
						</select>
					</TD>
				<TR>
					<TD align="right" class="TableHeading" width="101">急件否：</TD>
					<TD width="333" valign="middle">
						<select size="1" name="selDispatch" id="selDispatch">
							<option value=""></option>
							<option value="Y">是</option>
							<option value="N">否</option>
						</select>
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101" height="24">輸入者：</TD>
					<TD height="24"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtEntryUsr" id="txtEntryUsr" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">幣別：</TD>
					<TD width="333" valign="middle">
						<select size="1" name="selCurrency" id="selCurrency">
							<%=sbCurrCash.toString()%>
						</select>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<TABLE border="1" width="705" id="updateArea" style="display: none;">
			<TBODY>
				<TR>
					<TD align="right" class="TableHeading" width="166">支付序號：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="30" type="text" maxlength="30" name="txtUPNO" id="txtUPNO" value="<%=strPNo%>" readonly></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">受款人姓名：</TD>
					<TD width="540"><INPUT class="Data" size="40" type="text" maxlength="40" id="txtUPName" name="txtUPName" value="<%=strPName%>" onblur="checkClientField(this,true);"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">受款人ID：</TD>
					<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPId" name="txtUPId" value="<%=strPId%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">支付金額：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPAMT" id="txtPAMT" readonly value="<%=df.format(iPAmt)%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" height="24" width="166">付款日期：</TD>
					<TD height="24" width="540">
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPDateC" name="txtUPDateC" readOnly onblur="checkClientField(this,true);">
						<a href="javascript:show_calendar('frmMain.txtUPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" width="24" height="21"></a> 
						<INPUT type="hidden" name="txtUPDate" id="txtUPDate" value="<%=strPDate%>">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">支付描述：</TD>
					<TD width="540"><INPUT class="Data" size="37" type="text" maxlength="11" name="txtUPDesc" id="txtUPDesc" value="<%=strPdesc%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="200">付款方式：(匯款-總公司)</TD>
					<TD width="540">
						<select size="1" name="selUPMethod" id="selUPMethod" class="Data">
						<%
						//R60550
						//R80498 新增條件外幣匯款金額不等於0,才顯示選項
						if (!strCurrency.equals("NT") 
								|| (!strPAYCURR.equals("") && strSYMBOL.equals("S") && (iENTRYDT <= iINVDT) && iPAYAMT != 0)) 
						{
							out.println("<option value=\"D\">外幣匯款</option>");
						} 
						else 
						{
						%>
							<option value="A">支票</option>
							<option value="B" selected>匯款</option>
							<option value="C">信用卡</option>
							<option value="E">現金</option>
						<%
							if (strSYMBOL.equals("S") && (iENTRYDT > iINVDT) && iPAYAMT != 0) {
								out.println("<option value=\"D\">外幣匯款</option>");
							}
						}
						%>
						</select>
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">匯款銀行代號：</TD>
					<TD width="540">
						<INPUT class="Data" size="8" type="text" maxlength="7" value="<%=strPRBank%>" name="txtUPRBank" id="txtUPRBank" ONKEYUP="updatePRBankByKeyup();" onchange="changeFeeWayByRules(),WriteCode();" onblur="checkClientField(this,true);">
						<span style="display: none" id="selList"> 
							<SELECT id="prbankList" NAME="options" onChange="updatePRBankBySelection();" MULTIPLE SIZE=4 onblur="disableList('selList');" class="Data">
								<%=sbBankCode.toString()%>
							</SELECT>
						</span>
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">匯款銀行帳號：</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="16" name="txtUPRAccount" id="txtUPRAccount" value="<%=strPRAccount%>" onblur="checkClientField(this,true);"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">信用卡號碼：</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="16" id="txtUPCrdNo" name="txtUPCrdNo" value="<%=strPCrdNo%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">卡別：</TD>
					<TD width="540">
						<select size="1" name="selPUCrdType" id="selPUCrdType" class="Data">
							<option value=""></option>
							<option value="VC">VC</option>
							<option value="MC">MC</option>
							<option value="JCB">JCB</option>
							<option value="NCC">NCC</option>
						</select> 
						<INPUT type="hidden" id="txtPUCrdType" name="txtPUCrdType" value="<%=strPCrdType%>">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">有效截止月年：</TD>
					<TD width="540">
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
							<%=sbCardYear.toString()%>
							<!--option value=""></option>
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
							<option value="2020">2020</option-->
						</select> 
						<INPUT type="hidden" id="txtUPCrdEffMY" name="txtUPCrdEffMY" value="<%=strPCrdEffMY%>">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">授權碼：</TD>
					<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPAuthCode" name="txtUPAuthCode" value="<%=strPAuthCode%>"><font color="red" size="2">(原始授權碼)</font></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" height="24" width="166">授權交易日：</TD>
					<TD height="24" width="540">
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPAuthDtC" name="txtUPAuthDtC" onblur="checkClientField(this,true);">
						<a href="javascript:show_calendar('frmMain.txtUPAuthDtC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" width="24" height="21"></a> 
						<INPUT type="hidden" name="txtUPAuthDt" id="txtUPAuthDt" value="<%=strPAuthDt%>"><font color="red" size="2">(原始授權交易日)</font>
					</TD>
				</TR>
				<!--R80300 原刷卡號和原刷金額-->
				<TR>
					<TD align="right" class="TableHeading" width="166">原刷金額：</TD>
					<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtUPOrgAMT" id="txtUPOrgAMT" value="<%=df.format(iPOrgAMT)%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">原刷卡號：</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="16" id="txtUPOrgCrdNo" name="txtUPOrgCrdNo" value="<%=strPOrgCrdNo%>"><font color="red" size="2">(此次退費卡號不同於原始請款卡號時,請輸入)</font></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">急件否：</TD>
					<TD width="540">
						<input type="radio" name="rdUDispatch" id="rdUDispatch" value="Y" <%if (strPDispatch.trim().equals("Y")) out.println("checked");%>>是
						<input type="radio" name="rdUDispatch" id="rdUDispatch" value="" <%if (!strPDispatch.trim().equals("Y")) out.println("checked");%>>否
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">支票禁背：</TD>
					<TD width="540">
						<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1" value="Y" <%if (strPChkm1.equals("Y")) out.println("checked");%>>禁背
						<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1" value="" <%if (!strPChkm1.equals("Y")) out.println("checked");%>>取消禁背
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">支票劃線：</TD>
					<TD width="540">
						<input type="radio" name="rdUPCHKM2" id="rdUPCHKM2" value="Y" <%if (strPChkm2.equals("Y")) out.println("checked");%>>劃線
						<input type="radio" name="rdUPCHKM2" id="rdUPCHKM2" value="" <%if (!strPChkm2.equals("Y")) out.println("checked");%>>取消劃線
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">支付原因：</TD>
					<TD width="540">
						<select size="1" name="selUPSrcCode" id="selUPSrcCode" class="Data" onchange="changeFeeWayByRules();">
							<%=sbPSrcCode.toString()%>
						</select>
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">來源群組：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUPSrcGp" id="txtUPSrcGp" value="<%=strPSrcGp%>" readonly></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">保單號碼：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPolNo" id="txtUPolNo" readonly value="<%=strPolNo%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" height="24" width="166">要保書號碼：</TD>
					<TD height="24" width="540"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUAppNo" id="txtUAppNo" readonly value="<%=strAppNo%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">單位：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUPolDiv" id="txtUPolDiv" value="<%=strBranch%>" readonly></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">幣別：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtCurrency" id="txtCurrency" value="<%=strCurrency%>" readonly></TD>
				</TR>
<!-- RC0036 承辦人員 -->
				<TR>
					<TD align="right" class="TableHeading" width="166">承辦人員：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUsrInfo" id="txtUsrInfo" value="<%=strUsrInfo%>" readonly></TD>
				</TR>
				<!--R60550新增11個欄位FOR外幣匯款-->
				<TR id="usSHOW0" style="display: none">
					<TD align="right" class="TableHeading" width="166">投資起始日：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtINVDT" id="txtINVDT" value="<%=strINVDTC%>" readonly></TD>
				</TR>
				<TR id="usSHOW1" style="display: none">
					<TD align="right" class="TableHeading" width="166">外幣匯出幣別：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="10" type="text" maxlength="10" name="txtPAYCURR" id="txtPAYCURR" value="<%=strPAYCURR%>" readonly></TD>
				</TR>
				<TR id="usSHOW2" style="display: none">
					<TD align="right" class="TableHeading" width="166">外幣匯出匯率：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="16" type="text" maxlength="16" name="txtPAYRATE" id="txtPAYRATE" value="<%=df2.format(iPAYRATE)%>" readonly></TD>
				</TR>
				<TR id="usSHOW3" style="display: none">
					<TD align="right" class="TableHeading" width="166">外幣匯出金額：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtPAYAMT" id="txtPAYAMT" value="<%=df2.format(iPAYAMT)%>" readonly></TD>
				</TR>
				<TR id="usSHOW4" style="display: none">
					<TD align="right" class="TableHeading" width="166">手續費支付方式：</TD>
					<TD width="540">
						<select size="1" name="selFEEWAY" id="selFEEWAY" class="Data">
							<option value="SHA">各自負擔</option>
							<option value="BEN">保戶支付</option>
							<option value="OUR">公司支付</option>
						</select>
					</TD>
				</TR>
				<TR id="usSHOW5" style="display: none">
					<TD align="right" class="TableHeading" width="166">SWIFT CODE：</TD>
					<TD width="540">
						<INPUT class="Data" size="13" type="text" maxlength="12" value="<%=strPSWIFT%>" name="txtPSWIFT" id="txtPSWIFT" ONKEYUP="autoComplete(this,this.form.selPSWIFT,'value',true,'selList2');">
						<span style="display: none" id="selList2">
							<select name="selPSWIFT" id="selPSWIFT" onChange="this.form.txtPSWIFT.value=this.options[this.selectedIndex].value;this.form.selPBKCOTRY.value=this.form.txtPSWIFT.value.substring(4,6);" MULTIPLE SIZE=4 onblur="disableList('selList2')" class="Data">
								<%=sbSWIFTCode.toString()%>
							</select>
						</span>
						<%=sBankNo.toString()%>
					</TD>
				</TR>
				<TR id="usSHOW6" style="display: none">
					<TD align="right" class="TableHeading" width="166">銀行分行：</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKBRCH" id="txtPBKBRCH" value="<%=strPBKBRCH%>" style="text-transform: uppercase;" onchange="this.form.txtPBKBRCH.value=FulltoHalf(this.form.txtPBKBRCH.value);"></TD>
				</TR>
				<TR id="usSHOW7" style="display: none">
					<TD align="right" class="TableHeading" width="166">銀行城市：</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKCITY" id="txtPBKCITY" value="<%=strPBKCITY%>" style="text-transform: uppercase;"></TD>
				</TR>
				<TR id="usSHOW8" style="display: none">
					<TD align="right" class="TableHeading" width="166">銀行國別：</TD>
					<TD width="540">
						<select size="1" name="selPBKCOTRY" id="selPBKCOTRY" class="Data">
							<%=sbCotryCode.toString()%>
						</select>
					</TD>
				</TR>
				<TR id="usSHOW9" style="display: none">
					<TD align="right" class="TableHeading" width="166">受款人英文姓名：</TD>
					<TD width="540"><INPUT class="Data" size="70" type="text" maxlength="70" name="txtPENGNAME" id="txtPENGNAME" value="<%=strPENGNAME%>" style="text-transform: uppercase;" onchange="this.form.txtPENGNAME.value=FulltoHalf(this.form.txtPENGNAME.value);"></TD>
				</TR>
				<TR id="usSHOW10" style="display: none">
					<TD align="right" class="TableHeading" width="166">註記：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="5" type="text" maxlength="1" name="txtSYMBOL" id="txtSYMBOL" value="<%=strSYMBOL%>" readonly><font color="red" size="2">(說明S:SPUL D:外幣保單)</font></TD>
				</TR>
				<TR id="usSHOW11" style="display: none">
					<TD align="right" class="TableHeading" width="166">退匯手續費：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="40" type="text" maxlength="40" name="txtFPAYAMT" id="txtFPAYAMT" value="<%=df2.format(iFPAYAMT)%>" readonly> <font color="red" size="2">(退匯手續費幣別同外幣匯出幣別)</font></TD>
				</TR>
				<TR id="usSHOW12" style="display: none">
					<TD align="right" class="TableHeading" width="166">退匯手續費支付方式：</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="40" type="text" maxlength="40" name="txtFFEEWAY" id="txtFFEEWAY" value="<%=strFFEEWAY%>" readonly></TD>
				</TR>
			</TBODY>
		</TABLE>
		<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value="">
		<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
		<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>"> 
		<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>"> 
		<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 
		<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">
		<INPUT type="hidden" id="txtUserBrch" name="txtUserBrch" value="<%=strUserBrch%>"> <!-- RC0036 -->
		<INPUT type="hidden" id="txtUserArea" name="txtUserArea" value="<%=strUserArea%>"> <!-- QC0290 -->
		<INPUT type="hidden" id="hidPMethod" name="hidPMethod" value="<%=strPMethod%>"> 
		<INPUT type="hidden" id="hidPConDT1" name="hidPConDT1" value="<%=iPConDT1%>"> 
		<INPUT type="hidden" id="hidPSrcCode" name="hidPSrcCode" value="<%=strPSrcCode%>"> 
		<INPUT type="hidden" id="txtCurrentDate" name="txtCurrentDate" value="<%=iCurrentDate%>">
		<INPUT type="hidden" id="hidPnoH" name="hidPnoH" value=""> 
		<INPUT type="hidden" id="hidENTRYDT" name="hidENTRYDT" value="<%=strENTRYDTC%>"> 
		<INPUT type="hidden" id="strBnkfrList" name="strBnkfrList" value="<%=bnkprStr%>"> 
		<INPUT type="hidden" id="txtPBBank" name="txtPBBank" value="<%=strPBBank%>"> 
		<INPUT type="hidden" id="txtPlanType" name="txtPlanType" value="<%=strPPlanT%>"> 
		<INPUT type="hidden" id="nextAction" name="nextAction" value="">
	</FORM>
</BODY>
</HTML>
