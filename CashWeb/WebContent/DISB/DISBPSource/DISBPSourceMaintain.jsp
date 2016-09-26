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
 * Function : �浧���@�T�{
 * 
 * Remark   : ��I�ӷ�
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
 * QC0290��CASH�L�k����{�����I
 *
 * Revision 1.29  2014/07/18 07:29:01  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.28  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.27  2013/05/02 11:07:05  MISSALLY
 * R10190 �������īO��@�~
 *
 * Revision 1.26  2013/04/23 10:25:27  MISSALLY
 * RA0074 BUG FIX
 *
 * Revision 1.25  2013/04/18 02:09:26  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 * �ץ����H�״���
 *
 * Revision 1.24  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
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
 * QA0134---CASH�t�κ��@�H�Υd��I�W�[�ˮ�
 *
 * Revision 1.18  2012/01/04 10:07:10  MISSALLY
 * Q10419
 * �����O��I�覡���ťծɭn��ܿ��~�T��
 *
 * Revision 1.17  2011/11/01 07:41:43  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 * FIX �I�ڤ覡��(�~��)�״ڮɡA�������ˮֲ����x�s�νT�{�ɦA�ˮ�
 *
 * Revision 1.16  2011/10/21 10:04:37  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 * Revision 1.14  2009/11/11 06:17:38  missteven
 * R90474 �ק�CASH�\��
 *
 * Revision 1.13  2008/09/25 02:55:06  misvanessa
 * R80498_�~���״ڪ��B���i���s
 *
 * Revision 1.12  2008/08/12 06:56:35  misvanessa
 * R80480_�W���Ȧ�~�������s�ɮ�
 *
 * Revision 1.11  2008/08/06 06:05:29  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.10  2008/04/30 07:50:17  misvanessa
 * R80300_�������x�s,�s�W�U���ɮפγ���
 *
 * Revision 1.9  2007/11/13 06:44:31  MISVANESSA
 * Q70581_�u�W�s�W�~���״ڤ�I����(BUGFIX)
 *
 * Revision 1.8  2007/09/07 10:41:38  MISVANESSA
 * R70455_TARGET OUT
 *
 * Revision 1.7  2007/08/03 10:03:49  MISODIN
 * R70477 �~���O��״ڤ���O
 *
 * Revision 1.6  2007/03/06 01:52:39  MISVANESSA
 * R70088_SPUL�t��
 *
 * Revision 1.5  2007/01/31 08:04:56  MISVANESSA
 * R70088_SPUL�t��
 *
 * Revision 1.4  2007/01/05 10:10:30  MISVANESSA
 * R60550_�װh��I�覡
 *
 * Revision 1.3  2007/01/04 03:23:04  MISVANESSA
 * R60550_�װh�W�h�ק�
 *
 * Revision 1.2  2006/11/30 09:12:45  MISVANESSA
 * R60550_�t�XSPUL&�~���I�ڭק�
 *
 * Revision 1.1  2006/06/29 09:40:48  MISangel
 * Init Project
 *
 * Revision 1.1.2.20  2006/04/27 09:35:38  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.19  2005/10/14 07:48:21  misangel
 * R50835:��I�\�ണ��
 *
 * Revision 1.1.2.17  2005/05/13 02:31:12  miselsa
 * R30530_�����ҥi�ק�
 *
 * Revision 1.1.2.16  2005/05/04 10:26:35  MISANGEL
 * R30530:��I�t��-�H�Υd�����ˮֱ��v��/���v�X
 *
 * Revision 1.1.2.15  2005/04/22 06:25:14  miselsa
 * R30530_�[�j�m�W���
 *
 * Revision 1.1.2.14  2005/04/22 06:18:41  miselsa
 * R30530_�[�j�m�W���
 *
 * Revision 1.1.2.13  2005/04/12 03:17:08  miselsa
 * R30530_�ק�����ݳ�����ƪ�JOIN SQL
 *
 * Revision 1.1.2.12  2005/04/04 07:02:24  miselsa
 * R30530 ��I�t��
 *  
 */
%><%! String strThisProgId = "DISBPSourceMaintain"; //���{���N�� %><%
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

//R80132 ���O�D��
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
//R60550�s�W12���
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
			strPMethodDesc = "�䲼";
		if (strPMethod.equals("B"))
			strPMethodDesc = "�״�";
		if (strPMethod.equals("C"))
			strPMethodDesc = "�H�Υd";	
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
	//R80300 ���d��
	if (objPDetailVO.getStrPOrgCrdNo() != null)
		strPOrgCrdNo = objPDetailVO.getStrPOrgCrdNo();
	if (strPOrgCrdNo != "")
		strPOrgCrdNo = strPOrgCrdNo.trim();
	//R80300 �����B
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
	//RA0074  ���w��l��
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
	//R70088 ���_�l��O�P��J����
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
//RA0074 �̾ڻȦ�N�X�۰ʱa�XSWIFT CODE
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
<TITLE>��I�ӷ�--�浧���@�T�{</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
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
		WindowOnLoadCommon( document.title+"(�d��)" , '' , strFunctionKeyInquiry1,'' );
		window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
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
//R70088 �O�P��J���� tmpPDT -> tmpENTRYDT
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

	//RA0074 ���w��l��
	document.getElementById("txtPBKCITY").value = "TP";
	document.getElementById("selPBKCOTRY").value = "TW";
}

/* ��toolbar frame ����<�s�W>���s�Q�I���,����Ʒ|�Q���� */
function addAction()
{
	window.status = "";
	document.getElementById("txtAction").value = "A";
	document.getElementById("updateArea").style.display = "block"; 
	document.getElementById("inqueryArea").style.display = "none"; 
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
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

/* ��toolbar frame ����<�d��>���s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
{
	WindowOnLoadCommon( document.title+"(�d��)" , '' , strFunctionKeyInquiry1,'' ) ;
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
}

/* ��toolbar frame ����<�����T�{>���s�Q�I���,����Ʒ|�Q���� */
function DISBCanConfirmAction()
{
	var bConfirm = window.confirm("�O�_�T�w�����T�{�ӵ����?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "DISBCancelConfirm";
		document.getElementById("frmMain").submit();
	}
}

/* ��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q���� */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBPSource/DISBPSourceMaintain.jsp";
}

/* ��toolbar frame ����<�T�w>���s�Q�I���,����Ʒ|�Q���� */
function confirmAction()
{
	/*	���� QueryFrameSet.jsp ��,�U QueryString �ѼƤ��N�q
		RowPerPage		: �C�@�����X�C
		Heading			: ���Y���W��,�H�r��','���}�C�@���
		DisplayFields	: �n��ܤ���Ʈw���W��,�H�r�����}�C�@���,�PHeading�۹���
		ReturnFields	: �Ǧ^������줧��,�H�r�����}�C�@���
		Sql				: �ݰ��椧SQL,��i�[�Jwhere����
		TableWidth		: ���Table���e��

	 modalDialog �|�Ǧ^�ϥΪ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}

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
	{// �v����99��, �i�d�Ҧ����
	}
	else if(document.getElementById("txtUserRight").value >= "89" && document.getElementById("txtUserRight").value < "99")
	{//�u��d�������Ҧ����
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
	{//�u��d�ۤv�ҿ�J�����
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
	//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
	//R00393 edit by Leo Huang
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading","�O�渹�X,�n�O�Ѹ��X,���ڤH�m�W,���ڤHID,��I���B,�I�ڤ覡,�I�ڤ��e,�I�ڪ��A,�@�o�_,���_,��J��,��J��");
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
		strName = strName.replace(/^[\s�@]+|[\s�@]+$/g, "");
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
			
		/*R30530 modi 20050218  -->�W�[�����T�{���\��*/
		//PAY_CONFIRM_DATE1-->returnArray[26] ,PAY_CONFIRM_TIME1-->returnArray[27], PAY_CONFIRM_USER1-->returnArray[28]
		document.getElementById("hidPConDT1").value = returnArray[26];
		document.getElementById("hidPnoH").value = returnArray[31];
		document.getElementById("txtCurrency").value = returnArray[32];
		document.getElementById("txtUsrInfo").value = returnArray[35];//RC0036
		// R00386 
		document.getElementById( "txtPBBank" ).value = returnArray[33];
		document.getElementById( "txtPlanType" ).value = returnArray[34];
		//R60550 �s�W12�����
		document.getElementById("txtAction").value = "INQ";
		document.getElementById("frmMain").submit();	
		makeButtons();
		makeSeleted();

    	document.getElementById("updateArea").style.display = "block"; 
    	document.getElementById("inqueryArea").style.display = "none"; 
		disableAll();
	}
}

/* ��toolbar frame ����<�x�s>���s�Q�I���,����Ʒ|�Q���� */
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

			//R00135 ���]�ȭn�D��I��]���i�ť�
			if(document.getElementById("selUPSrcCode").value == "")
			{
				varMsg = "�п�ܤ�I��]\r\n";
				varStatus = false;
			}

			//R10260 �״��ˮ�
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

			//QA0134 �H�Υd������T�ˮ�
			var varMsgC = "";
			if(document.getElementById("selUPMethod").value == "C")
			{
				if(document.getElementById("txtUPCrdNo").value == "")
				{
					varMsgC += "-->�H�Υd�d�����i�ť�\r\n";
				}
				else 
				{
					if (document.getElementById("txtUPCrdNo").value.length != 16)
					{
						varMsgC += "-->�H�Υd�d���ݬ�16�X�Ʀr\r\n";
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
					varMsgC += "-->�п�ܦ��Ĥ�~\r\n";
				}
				if(document.getElementById("txtUPAuthDtC").value == "")
				{
					varMsgC += "-->�п�J���v�����\r\n";
				}
				if(document.getElementById("txtUPAuthDtC").value.length != 9 )
				{
					varMsgC += "-->���v�����榡��YYY/MM/DD \r\n";
				}
				if (document.getElementById("txtUPAuthDt").value > <%=iCurrentDate%>)
				{
					varMsgC += "-->���v�����j��ثe��� \r\n";
				}

				if(varMsgC != "")
				{
					varMsg += "�A�ҿ�ܪ���I�覡�O[�H�Υd]\r\n";
					varMsg += varMsgC;
					varStatus = false;
				}
			}
			//RB0302��������󤧫O��ɴڤ~��H�{����I
			if(document.getElementById("selUPMethod").value == "E")
			{
				if(!(document.getElementById("txtCurrency").value == "NT" && (document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") && document.frmMain.rdUDispatch[0].checked))
				{
					varMsg += "��������󤧫O��ɴڤ~��H�{����I!!\n\r";
					varStatus = false;
				}
			}
			//RC0036 ���:�����q�H�Τ��B�H���A���i�䲼��I
			if(document.getElementById("selUPMethod").value == "A")
			{
				if(document.frmMain.rdUDispatch[0].checked && document.getElementById("txtUserArea").value != "")
				{
					varMsg += "���@�~�����ɡA���i�H�䲼��I!!\n\r";
					varStatus = false;
				}
			}
           //RC0036 ���:���B�H�����i�{����I
			if(document.getElementById("selUPMethod").value == "E")
			{
				//if(document.frmMain.rdUDispatch[0].checked && document.getElementById("txtUserArea").value != "" && document.getElementById("txtUserBrch)").value != "")
				//QC0290���]��{���h�F��")"�A�y��������~�C
				if(document.frmMain.rdUDispatch[0].checked && document.getElementById("txtUserArea").value != "" && document.getElementById("txtUserBrch").value != "")
				{
					varMsg += "���@�~�����ɡA���i�H�{����I!!\n\r";
					varStatus = false;
				}
			}
			if(varStatus)
			{
				<%-- R00386 --%>
				if( checkFeeWay() ) 
				{
					if (window.confirm("�x�s������A�O�_�n�T�{�ӵ���I�ӷ�?"))
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

	//Q10419 ����O��I�覡���o���ť�
	if( currentFeeWay == "" )
	{
		alert("����O��I�覡���o���ť�!!");
		return false;
	}
	//R00386 �ˬd / ��������O��I�覡
	else if( payMethod == "D" && polCurr != "NT" && ( planType == " " || planType == "" ) ) 
	{
		var myFeeWayEle = document.getElementById( "selUPSrcCode" );
		var myFeeWayText = myFeeWayEle.options.item( myFeeWayEle.selectedIndex ).innerHTML;
		var myFeeWay = myFeeWayText.replace( /&nbsp;/g, " " ).substring( 3, 11 ).replace( /^\s*|\s*$/g, "" );
		var payCode = myFeeWayText.substring( 0, 2 );

		var bnkfrList = document.getElementById( "strBnkfrList" ).value;
		<%--
		// �� OUR ��, �Y�I�ڻȦ�P���ڻȦ椣�P, �קאּ SHA �� BEN
		/*if( myFeeWay == "OUR" ) {
			
			var rbank = document.getElementById( "txtUPRBank" ).value;
			if( rbank.length > 3 )
				rbank = rbank.substring( 0, 3 );
			else
				rbank = rbank + "   ".substring( 0, 3 - rbank.length );
			
			var checkStr = polCurr + rbank;
			if( bnkfrList.indexOf( checkStr ) == -1 ) {	// ���O���q���w����
				// �̤�I��]�M�w�n���u�ΫȤ�ۥI����O
				if( "<%= DISBBean.FCTRI_FEEWAY_SHA_CODETABLE %>".indexOf( payCode ) != -1 )
					myFeeWay = "SHA";
				else
					myFeeWay = "BEN";
			}
		}*/
		--%>
		// �� BEN/SHA ��, �Y�I�ڻȦ�P���ڻȦ�ۦP, �קאּ OUR(���q��I)
		if( myFeeWay == "BEN" || myFeeWay == "SHA" ) {
			var rbank = document.getElementById( "txtUPRBank" ).value;
			if( rbank.length > 3 )
				rbank = rbank.substring( 0, 3 );
			else
				rbank = rbank + "   ".substring( 0, 3 - rbank.length );

			var checkStr = polCurr + rbank;
			if( bnkfrList.indexOf( checkStr ) != -1 ) {	// �O���q���w����
				myFeeWay = "OUR";
			}
		}

		if( currentFeeWay == myFeeWay )
			return true;

		var currentFeeWayDesc = getFeeWayDesc( currentFeeWay );
		var myFeeWayDesc = getFeeWayDesc( myFeeWay );

		var msg = "�ˮֵ��G����O��I�覡���� " + myFeeWayDesc +"\n�P�ϥΪ̿�ܪ� " + currentFeeWayDesc
				+ "���G���ŦX�C\n\n�Y" + currentFeeWayDesc + "���G���T�L�~���I��u�T�{�v\n�_�h�Ы��u�����v�^���e�@�~�ק�";
		return confirm( msg );

	} else {
		return true;
	}
}

function getFeeWayDesc( feeWay ) 
{
	if( feeWay == "OUR" )
		return "�y���q��I(OUR)�z";
	else if( feeWay == "BEN" )
		return "�y�Ȥ��I(BEN)�z";
	else if( feeWay == "SHA" )
		return "�y�U�ۭt��(SHA)�z";
	else
		return "�y �z";
}

// R00386 �̤�I��]�P�״ڻȦ�N�X�۰ʽվ����O��I�覡
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
	WriteCode(); //RA0074 �̾ڻȦ�N�X�a�XSWIFT CODE
}

function updatePRBankBySelection() 
{
	var sel = document.getElementById( "prbankList" );
	document.getElementById( "txtUPRBank" ).value = sel.options[ sel.selectedIndex ].value;
	changeFeeWayByRules();
	WriteCode(); //RA0074 �̾ڻȦ�N�X�a�XSWIFT CODE
}

function DISBPConfirmAction() 
{
	var varMsg = "";
	var varStatus = true;
	//R00135 ���]�ȭn�D��I��]���i�ť�
	if(document.getElementById("selUPSrcCode").value == "")
	{
		varMsg = "�п�ܤ�I��]\r\n";
		varStatus = false;
	}
	//R10260 �״��ˮ�
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
	//RB0302��������󤧫O��ɴڤ~��H�{����I
	if(document.getElementById("selUPMethod").value == "E")
	{
		if(!(document.getElementById("txtCurrency").value == "NT" && (document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") && document.frmMain.rdUDispatch[0].checked))
		{
			varMsg += "��������󤧫O��ɴڤ~��H�{����I!!\n\r";
			varStatus = false;
		}
	}

	if(varStatus)
	{
		var bConfirm = window.confirm("�O�_�T�w�n�T�{�ӵ���I�ӷ�?");
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
	if( objThisItem.id == "txtUPName" )
	{
		objThisItem.value = objThisItem.value.replace(/^[\s�@]+|[\s�@]+$/g, "");		// �R���Y�����ťզr��
		if( objThisItem.value == "" )
		{
			strTmpMsg = "���ڤH�m�W���i�ť�";
			bReturnStatus = false;
		}
	}
//	else if( objThisItem.id == "txtUPId" )
//	{
//		if( objThisItem.value == "" )
//		{
//			strTmpMsg = "���ڤHID���i�ť�";
//			bReturnStatus = false;
//		}
//	}
	else if( objThisItem.id == "txtUPAMT" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "���ڪ��B���i�ť�";
			bReturnStatus = false;
		}
	}	
	else if( objThisItem.id == "txtUPDateC" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "�I�ڤ�����i�ť�";
			bReturnStatus = false;
		}
		if (document.getElementById("hidPnoH").value != "" )
		{
			if (document.getElementById("txtCurrentDate").value > document.getElementById("txtUPDate").value)
			{
				strTmpMsg = " �I�ڤ������ >= �t�Τ�� \r\n";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.id == "selUPMethod" )
	{
		if( objThisItem.value == "A")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�䲼]\r\n";
			// R80132  if (document.getElementById("txtCurrency").value =="US"){
			// R80132     strTmpMsg += "-->�����O�椣���\�}��";
			if (document.getElementById("txtCurrency").value !="NT")
			{  // R80132
				strTmpMsg += "-->�~���O�椣���\�}��";			             // R80132
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPCrdNo").value !="" 
					|| document.getElementById("selPUCrdType").value !="" 
					|| document.getElementById("txtUPCrdEffMY").value !="" 
					|| document.getElementById("txtUPAuthCode").value !="" 
					|| document.getElementById("txtUPAuthDtC").value !="" 
					|| document.getElementById("txtUPRBank").value !="" 
					|| document.getElementById("txtUPRAccount").value !="")//R60550�s�W�Ȧ�b��
			{
				strTmpMsg += "-->�״ڻȦ�/�״ڱb��/�H�Υd�d��/�d�O/���Ħ~��/���v�X/���v�����,���ݿ�J";
				bReturnStatus = false;
			}

			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "B")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�״�]\r\n";
			if(document.getElementById("txtUPRBank").value =="" 
					&& document.getElementById("txtCurrency").value =="NT")
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
			document.getElementById("txtUPName").value = document.getElementById("txtUPName").value.replace(/^[\s�@]+|[\s�@]+$/g, "");
			if(document.getElementById("txtUPName").value == "" )
			{
				strTmpMsg += "-->���ڤH�m�W���i�ť�\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPCrdNo").value !="" 
					|| document.getElementById("selPUCrdType").value !="" 
					|| document.getElementById("txtUPCrdEffMY").value !="" 
					|| document.getElementById("txtUPAuthCode").value !="" 
					|| document.getElementById("txtUPAuthDtC").value !="")
			{
				strTmpMsg += "-->�H�Υd�d��/�d�O/���Ħ~��/���v�X/���v�����,���ݿ�J\r\n";
				bReturnStatus = false;
			}

			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "C")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�H�Υd]\r\n";
			// R80132  if (document.getElementById("txtCurrency").value =="US")
			if (document.getElementById("txtCurrency").value !="NT")  // R80132			
			{
				// R80132  strTmpMsg += "-->�����O�椣���\�H�Υd���I";
				strTmpMsg += "-->�~���O�椣���\�H�Υd���I";	// R80132		
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRBank").value !="" 
					|| document.getElementById("txtUPRAccount").value !="" )
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
				if (document.getElementById("txtUPCrdNo").value.length != 16)
				{
					strTmpMsg += "-->�H�Υd�d���ݬ�16�X�Ʀr\r\n";
					bReturnStatus = false;
				}
			}
			if(document.getElementById("txtUPCrdEffMY").value =="" )
			{
				strTmpMsg += "-->�п�ܦ��Ĥ�~\r\n";
				bReturnStatus = false;
			}
			//R80300 �H�Υd����J������v��
			if(document.getElementById("txtUPAuthDtC").value =="" )
			{
				strTmpMsg += "-->�п�J���v�����\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPAuthDtC").value.length != 9 )
			{
				strTmpMsg += "-->���v�����榡��YYY/MM/DD \r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtUPAuthDt").value > <%=iCurrentDate%>)
			{
				strTmpMsg += "-->���v�����j��ثe��� \r\n";
				bReturnStatus = false;
			}
		}
		//R60550 ���_�l��e���ݱj��KEY�~���״����
		else if( objThisItem.value == "D")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�~���״�]\r\n";
			if(document.getElementById("txtUPRAccount").value == "" )
			{
				strTmpMsg += "-->�״ڱb�����i�ť�\r\n";
				bReturnStatus = false;
			}
			//R80480�~���״ڥ���JID
			if (document.getElementById("txtUPId").value == "")
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
			if((document.getElementById("txtUPRBank").value =="" 
						&& document.getElementById("hidENTRYDT").value <= document.getElementById("txtINVDT").value) 
				//R70545  || (document.getElementById("txtUPRBank").value =="" && document.getElementById("selUPSrcCode").value =="B8"))
			 	|| (document.getElementById("txtUPRBank").value =="" 
						//R00440 SN������(document.getElementById("selUPSrcCode").value =="B8" || document.getElementById("selUPSrcCode").value =="B9")) )
			 			&& (document.getElementById("selUPSrcCode").value =="B8" 
			 					|| document.getElementById("selUPSrcCode").value =="B9" 
			 					|| document.getElementById("selUPSrcCode").value =="BB")) )  //R00440 SN������
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
			if (document.getElementById("selPBKCOTRY").value =="")
			{
				strTmpMsg += "-->�Ȧ��O���i�ť�\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPENGNAME").value =="")
			{
				strTmpMsg += "-->���ڤH�^��m�W���i�ť�\r\n";
				bReturnStatus = false;
			}
			var reg=/[^A-Z\- ]/g;
			if (reg.test(document.getElementById("txtPENGNAME").value))
			{
				strTmpMsg += "-->���ڤH�^��m�W�u�ର�j�g�^��r��";
				bReturnStatus = false;
			}
		}
		//RB0302�������x����󤧫O��ɴڤ~��H�{����I
		else if( objThisItem.value == "E")
		{
			if(!(document.getElementById("txtCurrency").value == "NT" && (document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") && document.frmMain.rdUDispatch[0].checked))
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
		strTmpMsg = "�ݭn�����,�l�i�H�����䲼���u!\r\n";
		bReturnStatus = false;
	}*/
	// R80132
	if( document.getElementById("txtCurrency").value !="NT" && document.frmMain.rdUDispatch[0].checked  )
	{
		strTmpMsg += "�~���O�椣�i�Ŀ���!\r\n";
		bReturnStatus = false;
	}
	//R80132 END
	//RB0302���i�P�ɨ����䲼�T�I�Τ䲼���u
   	if( document.frmMain.rdUPCHKM1[1].checked && document.frmMain.rdUPCHKM2[1].checked  )
	{
		strTmpMsg += "���i�P�ɨ����䲼�T�I�Τ䲼���u!\r\n";
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
		/*R30530  modi 20050223 -->�������d�O���n��쪺���� start */
		//if(strPMethod == "A" || (strPMethod == "B" && document.getElementById("txtUPRBank").value !="" && document.getElementById("txtUPRAccount").value !=="") || (strPMethod == "C" && document.getElementById("txtUPCrdNo").value !="" && document.getElementById("selUPCrdType").value !=="" && document.getElementById("txtUPAuthCode").value !=="" && document.getElementById("txtUPAuthDtC").value !==""))
		/*R30530  modi 20050428 -->���������v�X���n��쪺���� start */
		//if(document.getElementById("hidPMethod").value == "A" || (document.getElementById("hidPMethod").value == "B" && document.getElementById("txtUPRBank").value !="" && document.getElementById("txtUPRAccount").value !=="") || (document.getElementById("hidPMethod").value == "C" && document.getElementById("txtUPCrdNo").value !="" && document.getElementById("txtUPAuthCode").value !=="" && document.getElementById("txtUPAuthDtC").value !==""))
		//if(document.getElementById("hidPMethod").value == "A" || (document.getElementById("hidPMethod").value == "B" && document.getElementById("txtUPRBank").value !="" && document.getElementById("txtUPRAccount").value !=="") || (document.getElementById("hidPMethod").value == "C" && document.getElementById("txtUPCrdNo").value !=""))
		//R60550�s�W�~���״�"D"�ˮ�
		//R70088���_�l��e�nKEY�״ڻȦ� ���_�l��O�P��J���� �״ڤ�->��J��
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
							//R00440SN������                   document.getElementById("selUPSrcCode").value =="B8" || document.getElementById("selUPSrcCode").value =="B9") ) || 
							|| document.getElementById("selUPSrcCode").value =="BB" 
							|| document.getElementById("selUPSrcCode").value =="B8" 
							|| document.getElementById("selUPSrcCode").value =="B9") ) //R00440SN������
			|| (document.getElementById("hidPMethod").value == "B" 
					&& document.getElementById("txtUPRAccount").value !=="" 
					&& document.getElementById("txtCurrency").value == "US" ) 
			|| (document.getElementById("hidPMethod").value == "C" 
					&& document.getElementById("txtUPAuthDtC").value !="" 
					&& document.getElementById("txtUPCrdEffMY").value !="" 
					&& document.getElementById("txtUPCrdNo").value !=""))
		{ /*R30530  modi 20050223 -->�������d�O���n��쪺���� end*/
			WindowOnLoadCommon( document.title+"(��I�T�{/�ק�)" , '' , strDISBFunctionKeySourceC,'' ) ;
		}
		else
		{
			WindowOnLoadCommon( document.title+"(�ק�)" , '' , strDISBFunctionKeySourceU,'' );
		}
	}
	else
	{
		WindowOnLoadCommon( document.title+"(�����T�{)" , '' , strDISBFunctionKeyInquiry_1,'' );
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

//WILLIAM 2013/02/21 RA0074 �̻Ȧ�N�X�e�T�X�a�XSWIFT CODE
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
					<TD align="right" class="TableHeading" width="101">�O�渹�X�G</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPolicyNo" id="txtPolicyNo"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101" height="24">�n�O�Ѹ��X�G</TD>
					<TD height="24"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtAppNo" id="txtAppNo"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">���ڤH�m�W�G</TD>
					<TD><INPUT class="Data" size="40" type="text" maxlength="40" id="txtPName" name="txtPName" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">���ڤHID�G</TD>
					<TD width="333"><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPid" name="txtPid" value=""></TD>
<!--			<TR>
					<TD align="right" class="TableHeading" width="101">��I���A�G</TD>
					<TD width="333">
						<select size="1" name="selPStatus" id="selPStatus">
							<option value=""></option>
							<option value="A">A:����</option>
							<option value="B">B:���\</option>
						</select>
					</TD>
				</TR>-->
				<TR>
					<TD align="right" class="TableHeading" width="101">��I���B�G</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPAMT" id="txtPAMT" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">�I�ڤ���G</TD>
					<TD>
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPStartDateC" name="txtPStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
						<INPUT type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> ~ 
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC" name="txtPEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
						<INPUT type="hidden" name="txtPEndDate" id="txtPEndDate" value="">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">��J����G</TD>
					<TD>
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
						<INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate" value=""> ~ 
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryEndDateC" name="txtEntryEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtEntryEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"> <IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
						<INPUT type="hidden" name="txtEntryEndDate" id="txtEntryEndDate" value="">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">�״ڻȦ�N���G</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPRBank" id="txtPRBank" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">�״ڻȦ�b���G</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPRAccount" id="txtPRAccount" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">�H�Υd���X�G</TD>
					<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCrdNo" name="txtPCrdNo" value="">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">���ʤ���G</TD>
					<TD width="333" valign="middle">
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUpdStartDateC" name="txtUpdStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtUpdStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
						<INPUT type="hidden" name="txtUpdStartDate" id="txtUpdStartDate" value=""> ~ 
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUpdEndDateC" name="txtUpdEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
						<a href="javascript:show_calendar('frmMain.txtUpdEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
						<INPUT type="hidden" name="txtUpdEndDate" id="txtUpdEndDate" value="">
					</TD>
				<TR>
					<TD align="right" class="TableHeading" width="101">�@�o�_�G</TD>
					<TD width="333" valign="middle">
						<select size="1" name="selPVoidable" id="selPVoidable">
							<option value=""></option>
							<option value="Y">�O</option>
							<option value="">�_</option>
						</select>
					</TD>
				<TR>
					<TD align="right" class="TableHeading" width="101">���_�G</TD>
					<TD width="333" valign="middle">
						<select size="1" name="selDispatch" id="selDispatch">
							<option value=""></option>
							<option value="Y">�O</option>
							<option value="N">�_</option>
						</select>
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101" height="24">��J�̡G</TD>
					<TD height="24"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtEntryUsr" id="txtEntryUsr" value=""></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="101">���O�G</TD>
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
					<TD align="right" class="TableHeading" width="166">��I�Ǹ��G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="30" type="text" maxlength="30" name="txtUPNO" id="txtUPNO" value="<%=strPNo%>" readonly></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">���ڤH�m�W�G</TD>
					<TD width="540"><INPUT class="Data" size="40" type="text" maxlength="40" id="txtUPName" name="txtUPName" value="<%=strPName%>" onblur="checkClientField(this,true);"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">���ڤHID�G</TD>
					<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPId" name="txtUPId" value="<%=strPId%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">��I���B�G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPAMT" id="txtPAMT" readonly value="<%=df.format(iPAmt)%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" height="24" width="166">�I�ڤ���G</TD>
					<TD height="24" width="540">
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPDateC" name="txtUPDateC" readOnly onblur="checkClientField(this,true);">
						<a href="javascript:show_calendar('frmMain.txtUPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" width="24" height="21"></a> 
						<INPUT type="hidden" name="txtUPDate" id="txtUPDate" value="<%=strPDate%>">
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">��I�y�z�G</TD>
					<TD width="540"><INPUT class="Data" size="37" type="text" maxlength="11" name="txtUPDesc" id="txtUPDesc" value="<%=strPdesc%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="200">�I�ڤ覡�G(�״�-�`���q)</TD>
					<TD width="540">
						<select size="1" name="selUPMethod" id="selUPMethod" class="Data">
						<%
						//R60550
						//R80498 �s�W����~���״ڪ��B������0,�~��ܿﶵ
						if (!strCurrency.equals("NT") 
								|| (!strPAYCURR.equals("") && strSYMBOL.equals("S") && (iENTRYDT <= iINVDT) && iPAYAMT != 0)) 
						{
							out.println("<option value=\"D\">�~���״�</option>");
						} 
						else 
						{
						%>
							<option value="A">�䲼</option>
							<option value="B" selected>�״�</option>
							<option value="C">�H�Υd</option>
							<option value="E">�{��</option>
						<%
							if (strSYMBOL.equals("S") && (iENTRYDT > iINVDT) && iPAYAMT != 0) {
								out.println("<option value=\"D\">�~���״�</option>");
							}
						}
						%>
						</select>
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">�״ڻȦ�N���G</TD>
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
					<TD align="right" class="TableHeading" width="166">�״ڻȦ�b���G</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="16" name="txtUPRAccount" id="txtUPRAccount" value="<%=strPRAccount%>" onblur="checkClientField(this,true);"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">�H�Υd���X�G</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="16" id="txtUPCrdNo" name="txtUPCrdNo" value="<%=strPCrdNo%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">�d�O�G</TD>
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
					<TD align="right" class="TableHeading" width="166">���ĺI���~�G</TD>
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
					<TD align="right" class="TableHeading" width="166">���v�X�G</TD>
					<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPAuthCode" name="txtUPAuthCode" value="<%=strPAuthCode%>"><font color="red" size="2">(��l���v�X)</font></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" height="24" width="166">���v�����G</TD>
					<TD height="24" width="540">
						<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPAuthDtC" name="txtUPAuthDtC" onblur="checkClientField(this,true);">
						<a href="javascript:show_calendar('frmMain.txtUPAuthDtC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" width="24" height="21"></a> 
						<INPUT type="hidden" name="txtUPAuthDt" id="txtUPAuthDt" value="<%=strPAuthDt%>"><font color="red" size="2">(��l���v�����)</font>
					</TD>
				</TR>
				<!--R80300 ���d���M�����B-->
				<TR>
					<TD align="right" class="TableHeading" width="166">�����B�G</TD>
					<TD width="540"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtUPOrgAMT" id="txtUPOrgAMT" value="<%=df.format(iPOrgAMT)%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">���d���G</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="16" id="txtUPOrgCrdNo" name="txtUPOrgCrdNo" value="<%=strPOrgCrdNo%>"><font color="red" size="2">(�����h�O�d�����P���l�дڥd����,�п�J)</font></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">���_�G</TD>
					<TD width="540">
						<input type="radio" name="rdUDispatch" id="rdUDispatch" value="Y" <%if (strPDispatch.trim().equals("Y")) out.println("checked");%>>�O
						<input type="radio" name="rdUDispatch" id="rdUDispatch" value="" <%if (!strPDispatch.trim().equals("Y")) out.println("checked");%>>�_
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">�䲼�T�I�G</TD>
					<TD width="540">
						<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1" value="Y" <%if (strPChkm1.equals("Y")) out.println("checked");%>>�T�I
						<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1" value="" <%if (!strPChkm1.equals("Y")) out.println("checked");%>>�����T�I
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">�䲼���u�G</TD>
					<TD width="540">
						<input type="radio" name="rdUPCHKM2" id="rdUPCHKM2" value="Y" <%if (strPChkm2.equals("Y")) out.println("checked");%>>���u
						<input type="radio" name="rdUPCHKM2" id="rdUPCHKM2" value="" <%if (!strPChkm2.equals("Y")) out.println("checked");%>>�������u
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">��I��]�G</TD>
					<TD width="540">
						<select size="1" name="selUPSrcCode" id="selUPSrcCode" class="Data" onchange="changeFeeWayByRules();">
							<%=sbPSrcCode.toString()%>
						</select>
					</TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">�ӷ��s�աG</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUPSrcGp" id="txtUPSrcGp" value="<%=strPSrcGp%>" readonly></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">�O�渹�X�G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPolNo" id="txtUPolNo" readonly value="<%=strPolNo%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" height="24" width="166">�n�O�Ѹ��X�G</TD>
					<TD height="24" width="540"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUAppNo" id="txtUAppNo" readonly value="<%=strAppNo%>"></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">���G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUPolDiv" id="txtUPolDiv" value="<%=strBranch%>" readonly></TD>
				</TR>
				<TR>
					<TD align="right" class="TableHeading" width="166">���O�G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtCurrency" id="txtCurrency" value="<%=strCurrency%>" readonly></TD>
				</TR>
<!-- RC0036 �ӿ�H�� -->
				<TR>
					<TD align="right" class="TableHeading" width="166">�ӿ�H���G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUsrInfo" id="txtUsrInfo" value="<%=strUsrInfo%>" readonly></TD>
				</TR>
				<!--R60550�s�W11�����FOR�~���״�-->
				<TR id="usSHOW0" style="display: none">
					<TD align="right" class="TableHeading" width="166">���_�l��G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtINVDT" id="txtINVDT" value="<%=strINVDTC%>" readonly></TD>
				</TR>
				<TR id="usSHOW1" style="display: none">
					<TD align="right" class="TableHeading" width="166">�~���ץX���O�G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="10" type="text" maxlength="10" name="txtPAYCURR" id="txtPAYCURR" value="<%=strPAYCURR%>" readonly></TD>
				</TR>
				<TR id="usSHOW2" style="display: none">
					<TD align="right" class="TableHeading" width="166">�~���ץX�ײv�G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="16" type="text" maxlength="16" name="txtPAYRATE" id="txtPAYRATE" value="<%=df2.format(iPAYRATE)%>" readonly></TD>
				</TR>
				<TR id="usSHOW3" style="display: none">
					<TD align="right" class="TableHeading" width="166">�~���ץX���B�G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtPAYAMT" id="txtPAYAMT" value="<%=df2.format(iPAYAMT)%>" readonly></TD>
				</TR>
				<TR id="usSHOW4" style="display: none">
					<TD align="right" class="TableHeading" width="166">����O��I�覡�G</TD>
					<TD width="540">
						<select size="1" name="selFEEWAY" id="selFEEWAY" class="Data">
							<option value="SHA">�U�ۭt��</option>
							<option value="BEN">�O���I</option>
							<option value="OUR">���q��I</option>
						</select>
					</TD>
				</TR>
				<TR id="usSHOW5" style="display: none">
					<TD align="right" class="TableHeading" width="166">SWIFT CODE�G</TD>
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
					<TD align="right" class="TableHeading" width="166">�Ȧ����G</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKBRCH" id="txtPBKBRCH" value="<%=strPBKBRCH%>" style="text-transform: uppercase;" onchange="this.form.txtPBKBRCH.value=FulltoHalf(this.form.txtPBKBRCH.value);"></TD>
				</TR>
				<TR id="usSHOW7" style="display: none">
					<TD align="right" class="TableHeading" width="166">�Ȧ櫰���G</TD>
					<TD width="540"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKCITY" id="txtPBKCITY" value="<%=strPBKCITY%>" style="text-transform: uppercase;"></TD>
				</TR>
				<TR id="usSHOW8" style="display: none">
					<TD align="right" class="TableHeading" width="166">�Ȧ��O�G</TD>
					<TD width="540">
						<select size="1" name="selPBKCOTRY" id="selPBKCOTRY" class="Data">
							<%=sbCotryCode.toString()%>
						</select>
					</TD>
				</TR>
				<TR id="usSHOW9" style="display: none">
					<TD align="right" class="TableHeading" width="166">���ڤH�^��m�W�G</TD>
					<TD width="540"><INPUT class="Data" size="70" type="text" maxlength="70" name="txtPENGNAME" id="txtPENGNAME" value="<%=strPENGNAME%>" style="text-transform: uppercase;" onchange="this.form.txtPENGNAME.value=FulltoHalf(this.form.txtPENGNAME.value);"></TD>
				</TR>
				<TR id="usSHOW10" style="display: none">
					<TD align="right" class="TableHeading" width="166">���O�G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="5" type="text" maxlength="1" name="txtSYMBOL" id="txtSYMBOL" value="<%=strSYMBOL%>" readonly><font color="red" size="2">(����S:SPUL D:�~���O��)</font></TD>
				</TR>
				<TR id="usSHOW11" style="display: none">
					<TD align="right" class="TableHeading" width="166">�h�פ���O�G</TD>
					<TD width="540"><INPUT class="INPUT_DISPLAY" size="40" type="text" maxlength="40" name="txtFPAYAMT" id="txtFPAYAMT" value="<%=df2.format(iFPAYAMT)%>" readonly> <font color="red" size="2">(�h�פ���O���O�P�~���ץX���O)</font></TD>
				</TR>
				<TR id="usSHOW12" style="display: none">
					<TD align="right" class="TableHeading" width="166">�h�פ���O��I�覡�G</TD>
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
