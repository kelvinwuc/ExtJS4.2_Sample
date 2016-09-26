<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : ��I�\��
 * 
 * Remark   : ��I���@
 * 
 * Revision : $Revision: 1.24 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : 2005/04/04
 * 
 * Request ID  : R30530
 * 
 * CVS History :
 * 
 * $Log: DISBPaymentMaintain.jsp,v $
 * Revision 1.24  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.23  2013/05/02 11:07:05  MISSALLY
 * R10190 �������īO��@�~
 *
 * Revision 1.22  2013/04/18 02:09:26  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 * �ץ����H�״���
 *
 * Revision 1.21  2013/04/12 06:10:26  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 *
 * Revision 1.20  2012/08/29 07:09:59  ODCWilliam
 * *** empty log message ***
 *
 * Revision 1.19  2012/08/29 03:54:19  ODCWilliam
 * modify:william
 * date:2012-08-28
 *
 * Revision 1.18  2012/08/29 02:57:56  ODCKain
 * Calendar problem
 *
 * Revision 1.17  2012/05/18 09:49:50  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�
 *
 * Revision 1.16  2011/05/12 10:25:55  MISJIMMY
 * R00440 -SN������
 *
 * Revision 1.14  2008/09/25 02:55:20  misvanessa
 * R80498_�~���״ڪ��B���i���s
 *
 * Revision 1.13  2008/08/21 09:16:29  misvanessa
 * R80631_�s�W��l�I�ڤ覡 (FOR FF)
 *
 * Revision 1.12  2008/08/11 04:20:22  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.11  2008/08/06 06:03:44  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.10  2008/04/30 07:49:55  misvanessa
 * R80300_�������x�s,�s�W�U���ɮפγ���
 *
 * Revision 1.9  2007/11/13 06:45:05  MISVANESSA
 * Q70581_�u�W�s�W�~���״ڤ�I����(BUGFIX)
 *
 * Revision 1.8  2007/09/07 10:38:36  MISVANESSA
 * R70455_TARGET OUT
 *
 * Revision 1.7  2007/08/03 10:06:14  MISODIN
 * R70477 �~���O��״ڤ���O
 *
 * Revision 1.6  2007/03/06 01:54:03  MISVANESSA
 * R70088_SPUL�t��
 *
 * Revision 1.5  2007/01/31 08:03:00  MISVANESSA
 * R70088_SPUL�t��
 *
 * Revision 1.4  2007/01/05 10:09:57  MISVANESSA
 * R60550_�װh��I�覡
 *
 * Revision 1.3  2007/01/04 03:19:24  MISVANESSA
 * R60550_�t�XSPUL&�~���I�ڳW�h�ק�
 *
 * Revision 1.2  2006/11/30 09:11:25  MISVANESSA
 * R60550_�t�XSPUL&�~���I�ڭק�
 *
 * Revision 1.1  2006/06/29 09:40:49  MISangel
 * Init Project
 *
 * Revision 1.1.2.21  2006/05/19 07:20:41  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.20  2006/04/27 09:31:44  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.19  2005/10/14 07:47:48  misangel
 * R50835:��I�\�ണ��
 *
 * Revision 1.1.2.17  2005/05/13 02:31:11  miselsa
 * R30530_�����ҥi�ק�
 *
 * Revision 1.1.2.16  2005/05/04 10:27:23  MISANGEL
 * R30530:��I�t��-�H�Υd�����ˮֱ��v��/���v�X
 *
 * Revision 1.1.2.14  2005/04/22 06:25:13  miselsa
 * R30530_�[�j�m�W���
 *
 * Revision 1.1.2.13  2005/04/22 06:18:40  miselsa
 * R30530_�[�j�m�W���
 *
 * Revision 1.1.2.12  2005/04/04 07:02:21  miselsa
 * R30530 ��I�t��
 *  
 */
%><%! String strThisProgId = "DISBPaymentMaintain"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar  = commonUtil.getBizDateByRCalendar();
DecimalFormat df = new DecimalFormat("#.00");
DecimalFormat df2 = new DecimalFormat("#.0000");//R60550

int iCurrentDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(calendar .getTime()));
int iCurrentYear = Integer.parseInt(commonUtil.convertWesten2ROCDate1(calendar.getTime()).substring(0,3))+1911;

String strAction = (request.getAttribute("txtAction") != null)?((String) request.getAttribute("txtAction")):"";
String strReturnMessage = (request.getAttribute("txtMsg") != null)?((String) request.getAttribute("txtMsg")):"";
String strErr = (request.getAttribute("isErr") != null)?((String) request.getAttribute("isErr")):"";

String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";

List alPSrcCode = new ArrayList();
if (session.getAttribute("SrcCdList") == null) {
	alPSrcCode = (List) disbBean.getETable("PAYCD", "");
	session.setAttribute("SrcCdList", alPSrcCode);
} else {
	alPSrcCode = (List) session.getAttribute("SrcCdList");
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
List alCurrCash = new ArrayList(); //R80132 ���O�D��
if (session.getAttribute("CurrCashList") ==null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}

String strPNo = "";
String strPolNo = "";
String strAppNo = "";
String strPName = "";
String strPId = "";
double iPAmt = 0;
String strPdesc = "";
String strPMethod = "";
//  String strPMethodDesc = "";
String strPRBank = "";
String strPRAccount = "";
String strPCrdNo = "";
String strPCrdType = "";
String strPCrdEffMY = "";
String strPCrdEffM = "";
String strPCrdEffY = "";
String strPAuthCode = "";
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
int iPConDT2 = 0;
String strPStatus = "";
String strCurrency = "";
String strPMETHODO = "";//R80631
String strPMETHODODESC = "";//R80631
//R60550�s�W12���
String strPAYCURR ="";
double iPAYRATE = 1.0;//R10314
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
int iPConDT1 = 0;
int iENTRYDT = 0;//R70088
String strENTRYDTC ="";//R70088
String strPOrgCrdNo = "";//R80300
double iPOrgAMT = 0;//R80300
double iPAYAMTNT = 0;	//R10314

List alPDetail = new ArrayList();
if (session.getAttribute("PDetailList") != null) {
	alPDetail = (List) session.getAttribute("PDetailList");
}
session.removeAttribute("PDetailList");
//System.out.println("alPDetail.size()=" + alPDetail.size());
if (alPDetail.size() > 0) {
	DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(0);
	iPConDT2 = objPDetailVO.getIPCfmDt2();
	iPConDT1 = objPDetailVO.getIPCfmDt1();//R60550

	if (objPDetailVO.getStrPStatus() != null)
		strPStatus = objPDetailVO.getStrPStatus();
	if (strPStatus != "")
		strPStatus = strPStatus.trim();

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
//		System.out.println("strPCrdEffMY.length()=" + strPCrdEffMY.length());
		if (strPCrdEffMY.length() > 0) {
			strPCrdEffM = strPCrdEffMY.substring(0, 2);
			strPCrdEffY = strPCrdEffMY.substring(2, 6);
		}
	}

	if (objPDetailVO.getStrPAuthCode() != null)
		strPAuthCode = objPDetailVO.getStrPAuthCode();
	if (strPAuthCode != "")
		strPAuthCode = strPAuthCode.trim();

	if (objPDetailVO.getStrPDispatch() != null)
		strPDispatch = objPDetailVO.getStrPDispatch();
	if (strPDispatch != "") {
		strPDispatch = strPDispatch.trim();
	}
//	System.out.println("strPDispatch=" + strPDispatch);
	if (objPDetailVO.getStrPVoidable() != null)
		strVoidabled = objPDetailVO.getStrPVoidable();
	if (strVoidabled != "") {
		strVoidabled = strVoidabled.trim();
	}
//	System.out.println("strVoidabled=" + strVoidabled);
	if (objPDetailVO.getStrPChkm1() != null)
		strPChkm1 = objPDetailVO.getStrPChkm1();
	if (strPChkm1 != "") {
		strPChkm1 = strPChkm1.trim();
	}
//	System.out.println("strPChkm1=" + strPChkm1);
	if (objPDetailVO.getStrPChkm2() != null)
		strPChkm2 = objPDetailVO.getStrPChkm2();
	if (strPChkm2 != "") {
		strPChkm2 = strPChkm2.trim();
	}
//	System.out.println("strPChkm2=" + strPChkm2);
	if (objPDetailVO.getStrPSrcGp() != null)
		strPSrcGp = objPDetailVO.getStrPSrcGp();
	if (strPSrcGp != "") {
		strPSrcGp = strPSrcGp.trim();
	}
	if (objPDetailVO.getStrPSrcCode() != null)
		strPSrcCode = objPDetailVO.getStrPSrcCode();
	if (strPSrcCode != "") {
		strPSrcCode = strPSrcCode.trim();
	}
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

	//R80631��l�I�ڤ覡
    if (objPDetailVO.getStrPMETHODO() != null) {
       strPMETHODO = objPDetailVO.getStrPMETHODO().trim()  ;       
       if (strPMETHODO.equals("A"))
       		strPMETHODODESC = "�䲼";
       else if (strPMETHODO.equals("B"))
       		strPMETHODODESC = "�״�";
       else if (strPMETHODO.equals("C"))
      		strPMETHODODESC = "�H�Υd";
       else if (strPMETHODO.equals("D"))
      		strPMETHODODESC = "�~���״�";
       else if (strPMETHODO.equals("E"))
       		strPMETHODODESC = "�{��";
    } else {
       strPMETHODO ="";
       strPMETHODODESC ="";
    }
	//R60550
	if (strCurrency != null)
		strCurrency = objPDetailVO.getStrPCurr();
	if(strCurrency != "")
		strCurrency = strCurrency.trim();
		
    if (objPDetailVO.getStrPPAYCURR() != null)
       strPAYCURR = objPDetailVO.getStrPPAYCURR().trim()  ;       
    else
       strPAYCURR ="";
    
    iPAYRATE = objPDetailVO.getIPPAYRATE();   
    
    iPAYAMT = objPDetailVO.getIPPAYAMT();
    
    if (objPDetailVO.getStrPFEEWAY() != null)
       strPFEEWAY = objPDetailVO.getStrPFEEWAY().trim()  ;       
    else
       strPFEEWAY ="";   
    
    if (objPDetailVO.getStrPSWIFT() != null)
       strPSWIFT = objPDetailVO.getStrPSWIFT().trim()  ;       
    else
       strPSWIFT ="";
    
    if (objPDetailVO.getStrPBKBRCH() != null)
       strPBKBRCH = objPDetailVO.getStrPBKBRCH().trim()  ;       
    else
       strPBKBRCH ="";
     //RA0074  ���w��l��  
    if (objPDetailVO.getStrPBKCITY() != null)
       strPBKCITY = objPDetailVO.getStrPBKCITY().trim()  ;       
    else
       strPBKCITY ="TP";
       
    if (objPDetailVO.getStrPBKCOTRY() != null)
       strPBKCOTRY = objPDetailVO.getStrPBKCOTRY().trim()  ;       
    else
       strPBKCOTRY ="TW";
       
    if (objPDetailVO.getStrPENGNAME() != null)
       strPENGNAME = objPDetailVO.getStrPENGNAME().trim()  ;       
    else
       strPENGNAME ="";
       
    iINVDT = objPDetailVO.getIPINVDT();
	if (iINVDT == 0)
		strINVDTC = "";
	else
		strINVDTC = Integer.toString(iINVDT);
		
    if (objPDetailVO.getStrPSYMBOL() != null)
       strSYMBOL = objPDetailVO.getStrPSYMBOL().trim()  ;       
    else
       strSYMBOL ="";
    
   iFPAYAMT = objPDetailVO.getFPAYAMT();
   if (objPDetailVO.getFFEEWAY() != null)
       strFFEEWAY = objPDetailVO.getFFEEWAY().trim()  ;       
    else
       strFFEEWAY ="";
       //R70088 ���_�l��O�P��J����
   iENTRYDT = objPDetailVO.getIEntryDt();
   	if (iENTRYDT == 0)
		strENTRYDTC = "";
	else
		strENTRYDTC = Integer.toString(iENTRYDT);   	
	//R80300 ���d��
	if (objPDetailVO.getStrPOrgCrdNo() != null)
		strPOrgCrdNo = objPDetailVO.getStrPOrgCrdNo();
	if (strPOrgCrdNo != "")
		strPOrgCrdNo = strPOrgCrdNo.trim();
	//R80300 �����B
	iPOrgAMT = objPDetailVO.getIPOrgAMT();
	//R10314
	iPAYAMTNT = objPDetailVO.getIPAMTNT();
} else {

	if (request.getAttribute("txtUPolNo") != null) {
		strPolNo = (String) request.getAttribute("txtUPolNo");
	}
	if (request.getAttribute("txtUAppNo") != null) {
		strAppNo = (String) request.getAttribute("txtUAppNo");
	}
	if (request.getAttribute("txtUPName") != null) {
		strPName = (String) request.getAttribute("txtUPName");
	}
	if (request.getAttribute("txtUPId") != null) {
		strPId = (String) request.getAttribute("txtUPId");
	}
	if (request.getAttribute("txtUPMethod") != null) {
		strPMethod = (String) request.getAttribute("txtUPMethod");
	}
	if (request.getAttribute("txtUPCHKM1") != null) {
		strPChkm1 = (String) request.getAttribute("txtUPCHKM1");
	}
	if (request.getAttribute("txtPCHKM2") != null) {
		strPChkm2 = (String) request.getAttribute("txtPCHKM2");
	}
	if (request.getAttribute("txtUPDesc") != null) {
		strPdesc = (String) request.getAttribute("txtUPDesc");
	}
	if (request.getAttribute("txtUPSrcCode") != null) {
		strPSrcCode = (String) request.getAttribute("txtUPSrcCode");
	}
	if (request.getAttribute("txtUPRBank") != null) {
		strPRBank = (String) request.getAttribute("txtUPRBank");
	}
	if (request.getAttribute("txtUPRAccount") != null) {
		strPRAccount = (String) request.getAttribute("txtUPRAccount");
	}
	if (request.getAttribute("txtUPCrdNo") != null) {
		strPCrdNo = (String) request.getAttribute("txtUPCrdNo");
	}
	if (request.getAttribute("txtPUCrdType") != null) {
		strPCrdType = (String) request.getAttribute("txtPUCrdType");
	}
	if (request.getAttribute("txtUPCrdEffMY") != null) {
		strPCrdEffMY = (String) request.getAttribute("txtUPCrdEffMY");
	}
	if (request.getAttribute("txtUPAMT") != null) {
		iPAmt = Integer.parseInt((String) request.getAttribute("txtUPAMT"));
	}
	if (request.getAttribute("txtUPDate") != null) {
		strPDate = (String) request.getAttribute("txtUPDate");
	}
	if (request.getAttribute("txtUPAuthDt") != null) {
		strPAuthDt = (String) request.getAttribute("txtUPAuthDt");
	}
	if (request.getAttribute("txtUDispatch") != null) {
		strPDispatch = (String) request.getAttribute("txtUDispatch");
	}
	if (request.getAttribute("txtCurrency") != null) {
		strCurrency = (String) request.getAttribute("txtCurrency");
	}	
}

String strPAmt = "";
if (iPAmt > 0)
	strPAmt = df.format(iPAmt);

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

StringBuffer sbPSrcCode = new StringBuffer();
if (alPSrcCode.size() > 0) {
	for (int i = 0; i < alPSrcCode.size(); i++) {
		htTemp = (Hashtable) alPSrcCode.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		if (strValue.trim().equals(strPSrcCode))
			sbPSrcCode.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbPSrcCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}
	htTemp = null;
	strValue = null;
	strDesc = null;
} else {
	sbPSrcCode.append("<option value=\"\">&nbsp;</option>");
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

StringBuffer sbCotryCode = new StringBuffer();
sbCotryCode.append("<option value=\"\">&nbsp;</option>");
if (alCotryCode.size() > 0) {
	for (int i = 0; i < alCotryCode.size(); i++) {
		htTemp = (Hashtable) alCotryCode.get(i);
		strValue = (String) htTemp.get("CotryCODE");
		strDesc = (String) htTemp.get("CotryENNM");
		if (strValue.trim().equals(strPBKCOTRY))
			sbCotryCode.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbCotryCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
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
		strValue = (String) htTemp.get("SwiftCD");
		strDesc = (String) htTemp.get("SwiftBK");
		strTmp = CommonUtil.AllTrim((String) htTemp.get("SwiftBN"));

		if (strValue.trim().equals(strPSWIFT))
			sbSWIFTCode.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("-").append(strTmp).append("</option>");
		else
			sbSWIFTCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strTmp).append("</option>");

		sBankNo.append("<input type=\"").append("hidden").append("\"").append("id=\"").append(strDesc).append("\"").append("value=\"").append(strValue).append("\"").append("/>");
	}
	htTemp = null;
	strValue = null;
	strDesc = null;
}

StringBuffer sbCurrCash = new StringBuffer();
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}
	htTemp = null;
	strValue = null;
} else {
	sbCurrCash.append("<option value=\"\">&nbsp;</option>");
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
<TITLE>��I�\��--��I���@</TITLE>
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
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
	}	
	if (document.getElementById("txtAction").value != "")
	{
		document.getElementById("updateArea").style.display = "block";
		document.getElementById("inqueryArea").style.display = "none";
		var PDateTemp="<%=strPDate%>";
		var PAuthDtTemp="<%=strPAuthDt%>";
		showAddfield();//R60550
		if(PDateTemp !="")  {
			document.getElementById("txtUPDateC").value =string2RocDate(PDateTemp);
		}
		if(PAuthDtTemp!="") {
			document.getElementById("txtUPAuthDtC").value = string2RocDate(PAuthDtTemp);
		}
		if(document.getElementById("txtAction").value == "A" && document.getElementById("txtErr").value == "Y") {
			addAction();
		} else {
			makeButtons();
		}
		makeSeleted();
	}
	else
	{
		document.getElementById("inqueryArea").display = "block";
		document.getElementById("updateArea").display = "none";
		WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' );
		window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
	}
}

//R60550
function showAddfield() 
{
	var tmpPAYCURR ="<%=strPAYCURR%>";
	var tmpSYMBOL ="<%=strSYMBOL%>";
	var tmpINVDT =<%=iINVDT%>;
	var tmpVOID ="<%=strVoidabled%>";
	var tmpCONDT1 =<%=iPConDT1%>;
	var tmpPOCURR = "<%=strCurrency%>";
	var tmpACTION = "<%=strAction%>";
	var tmpFEEWAY = "<%=strPFEEWAY%>";
	var tmpENTRYDT = <%=iENTRYDT%>;//R70088
	var tempshow="";

	/*�������줣�i�H�Q�ק�*/
	document.getElementById("txtUPId").className="INPUT_DISPLAY";
	document.getElementById("txtUPId").readOnly =true;
	document.getElementById("txtUPAMT").className="INPUT_DISPLAY";
	document.getElementById("txtUPAMT").readOnly =true;
	document.getElementById("txtUPolNo").className="INPUT_DISPLAY";
	document.getElementById("txtUPolNo").readOnly =true;
	document.getElementById("txtUAppNo").className="INPUT_DISPLAY";
	document.getElementById("txtUAppNo").readOnly =true;
	document.getElementById("selUCurrency").readOnly = true;
	if(tmpVOID == "Y" && document.getElementById("txtAction").value != "A")
		document.getElementById("VoidableArea").style.display = "block"; 
	if(tmpCONDT1 == 0 && document.getElementById("txtAction").value != "A")
		document.getElementById("CFM1Area").style.display = "block"; 	      
		
	//R70088 �O�P��J���� tmpPDT -> tmpENTRYDT
	if (tmpPOCURR != "NT" || (tmpPAYCURR != "" && tmpSYMBOL== "S" && tmpENTRYDT <= tmpINVDT)
	  || (tmpSYMBOL =="S" && tmpENTRYDT > tmpINVDT) || tmpACTION == "")
	{
		for(var i=0;i< 13;i++) {
			tempshow= "usSHOW"+i;
			document.getElementById(tempshow).style.display = "block";
  		}
  	}

	if (tmpFEEWAY != "")
		document.getElementById("selFEEWAY").value =tmpFEEWAY;
	else if (tmpSYMBOL =="S")
		document.getElementById("selFEEWAY").value ="BEN";
	else
		document.getElementById("selFEEWAY").value ="OUR";

	document.getElementById("selUCurrency").value = tmpPOCURR;
	document.getElementById("txtINVDTC").value = string2RocDate(tmpINVDT.toString());

	//R10314
	if( document.getElementById("txtUserDept").value == "ACCT" && document.getElementById("txtUPSrcGp").value == "WB--WEB ON LINE" )
	{
		document.getElementById("ACCTSHOW").style.display = "block";
	   	document.getElementById("txtPAYAMTNT").className="Data";
		document.getElementById("txtPAYAMTNT").readOnly =false;
	}

	//RA0074 ���w��l��
	document.getElementById("txtPBKCITY").value = "TP";
	document.getElementById("selPBKCOTRY").value = "TW";

	//RB0302 �s�W�ﶵ�����ѥI�ڤ覡���{��
	if(document.getElementById("txtAction").value == "A") 
	{
		for(var i=0;i< document.getElementById("selUPMethod").options.length;i++)
		{
			if(document.getElementById("selUPMethod").options.item(i).value == "E") {
				document.getElementById("selUPMethod").remove(i);
			}
		}
	}
}

/* ��toolbar frame ����<�s�W>���s�Q�I���,����Ʒ|�Q���� */
function addAction()
{
	window.status = "";
	document.getElementById("txtAction").value = "A";
	showAddfield();//R60550
	document.getElementById("updateArea").style.display = "block";
	document.getElementById("inqueryArea").style.display = "none";
	WindowOnLoadCommon( document.title+"(�s�W)" , '' , strFunctionKeyAdd,'' ) ;	

	/*��������i�H�Q��J*/
	document.getElementById("txtUPId").className="Data";
	document.getElementById("txtUPId").readOnly =false;
	document.getElementById("txtUPAMT").className="Data";
	document.getElementById("txtUPAMT").readOnly =false;
	document.getElementById("txtUPolNo").className="Data";
	document.getElementById("txtUPolNo").readOnly =false;
	document.getElementById("txtUAppNo").className="Data";
	document.getElementById("txtUAppNo").readOnly =false;
	document.frmMain.rdUDispatch[1].checked = true;
    document.frmMain.rdUPCHKM1[0].checked = true;
    document.frmMain.rdUPCHKM2[0].checked = true;
    //R60550
  	document.getElementById("imgShow").style.display = "block";
	document.getElementById("txtINVDTC").className="Data";
   	document.getElementById("txtPAYCURR").className="Data";
	document.getElementById("txtPAYCURR").readOnly =false;
   	document.getElementById("txtPAYAMT").className="Data";
	document.getElementById("txtPAYAMT").readOnly =false;
   	document.getElementById("txtPAYRATE").className="Data";
	document.getElementById("txtPAYRATE").readOnly =false;
   	document.getElementById("txtSYMBOL").className="Data";
	document.getElementById("txtSYMBOL").readOnly =false;
	//R10314
	document.getElementById("ACCTSHOW").style.display = "block";
   	document.getElementById("txtPAYAMTNT").className="Data";
	document.getElementById("txtPAYAMTNT").readOnly =false;

	enableData();
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

	//RB0302 �Y�I�ڤ覡���{���h�����A���Y�����{���]����אּ�{��
	if(document.getElementById("hidPMethod").value == "E") {
		document.getElementById("selUPMethod").disabled = true;
	} else {
		for(var i=0;i< document.getElementById("selUPMethod").options.length;i++)
		{
			if(document.getElementById("selUPMethod").options.item(i).value == "E") {
				document.getElementById("selUPMethod").remove(i);
			}
		}
	}
}

/* ��toolbar frame ����<�d��>���s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
{
	WindowOnLoadCommon( document.title+"(�d��)" , '' , strFunctionKeyInquiry1,'' ) ;
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
}

/* ��toolbar frame ����<�R��>���s�Q�I���,����Ʒ|�Q���� */
function deleteAction()
{
	var bConfirm = window.confirm("�O�_�T�w�R���ӵ����?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "D";
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
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBPayment/DISBPaymentMaintain.jsp";
}

/* ��toolbar frame ����<�T�w>���s�Q�I���,����Ʒ|�Q���� */
function confirmAction()
{
 	if( document.getElementById("txtAction").value == "I" )
	{
		/*	
		���� QueryFrameSet.jsp ��,�U QueryString �ѼƤ��N�q
			RowPerPage		: �C�@�����X�C
			Heading			: ���Y���W��,�H�r��','���}�C�@���
			DisplayFields	: �n��ܤ���Ʈw���W��,�H�r�����}�C�@���,�PHeading�۹���
			ReturnFields	: �Ǧ^������줧��,�H�r�����}�C�@���
			Sql				: �ݰ��椧SQL,��i�[�Jwhere����
			TableWidth		: ���Table���e��
	
		 modalDialog �|�Ǧ^�ϥΪ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}
		*/

		mapValue();

 		var strSql = "";
		strSql = "SELECT A.POLICY_NO,A.APP_NO,A.PAY_NAME,A.PAY_ID,A.PAY_AMOUNT,A.PAY_METHOD,A.PAY_DESCRIPTION,A.PAY_STATUS,A.PAY_VOIDABLE,A.PAY_DISPATCH,A.ENTRY_USER,CAST(A.ENTRY_DATE AS CHAR(7)) AS ENTRY_DATE,A.PAY_NO,CAST(A.PAY_DATE AS CHAR(7)) AS PAY_DATE,CAST(A.PAY_CONFIRM_DATE1 AS CHAR(7)) AS PAY_CONFIRM_DATE1,CAST(A.PAY_CONFIRM_DATE2 AS CHAR(7)) AS PAY_CONFIRM_DATE2,CAST(A.PAY_CONFIRM_TIME2 AS CHAR(6)) AS PAY_CONFIRM_TIME2,A.PAY_CONFIRM_USER2,A.PAY_SOURCE_CODE,A.PAY_REMIT_BANK,A.PAY_REMIT_ACCOUNT,A.PAY_CREDIT_CARD,A.PAY_CREDIT_TYPE,A.PAY_AUTHORITY_CODE,A.PAY_CARD_MMYYYY,A.PAY_BRANCH,CAST(A.PAY_AUTHORITY_DATE AS CHAR(7)) AS PAY_AUTHORITY_DATE,A.PAY_SOURCE_GROUP,C.FLD0004 AS PSRCGPDESC,A.PAY_CHECK_M1 as PAY_CHECK_M1,A.PAY_CHECK_M2 as PAY_CHECK_M2,A.PAY_CURRENCY";		
		strSql += " from CAPPAYF A ";
		strSql += " left outer join ORDUET C on C.FLD0003 = A.PAY_SOURCE_GROUP AND C.FLD0002='SRCGP' ";
//*R50434* �i�d�ߦU��쥼�T�{���
		strSql += " WHERE A.PAY_CASH_DATE=0 ";

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
		if( document.getElementById("txtPCrdNo").value != "" ) {
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
			strSql += " AND  A.ENTRY_DATE BETWEEN " + document.getElementById("txtEntryStartDate").value + " and " + document.getElementById("txtEntryEndDate").value ;
		} else if (document.getElementById("txtEntryStartDate").value != "" && document.getElementById("txtEntryEndDate").value == "") {
			strSql += "  AND A.ENTRY_DATE >= " + document.getElementById("txtEntryStartDate").value ;
		} else if (document.getElementById("txtEntryStartDate").value == "" && document.getElementById("txtEntryEndDate").value != "") {
			strSql += " AND  A.ENTRY_DATE <= " + document.getElementById("txtEntryEndDate").value ;
		}
		if (document.getElementById("txtUpdStartDate").value != "" && document.getElementById("txtUpdEndDate").value != "") {
			strSql += "  AND A.UPDATE_DATE BETWEEN " + document.getElementById("txtUpdStartDate").value + " and " + document.getElementById("txtUpdEndDate").value ;
		} else if (document.getElementById("txtUpdStartDate").value != "" && document.getElementById("txtUpdEndDate").value == "") {
			strSql += "  AND A.UPDATE_DATE >= " + document.getElementById("txtUpdStartDate").value ;
		} else if (document.getElementById("txtUpdStartDate").value == "" && document.getElementById("txtUpdEndDate").value != "") {
			strSql += "  AND A.UPDATE_DATE <= " + document.getElementById("txtUpdEndDate").value ;
		}
		if( document.getElementById("selPVoidable").value != "" ){
			strSql += "   AND A.PAY_VOIDABLE= '" + document.getElementById("selPVoidable").value + "' ";
		}
		if( document.getElementById("selDispatch").value != "" ) {
			strSql += "   AND A.PAY_DISPATCH= '" + document.getElementById("selDispatch").value + "' ";
		}	
		if( document.getElementById("selCurrency").value != "" ) {
			strSql += "   AND A.PAY_Currency= '" + document.getElementById("selCurrency").value + "' ";
		} else {
		 // R80132   strSql += " AND A.PAY_Currency in ('NT','US')";
			strSql += " AND A.PAY_Currency in ('NT','US','AU','EU','HK','JP','NZ')";
		}    	

   	    var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=820";
		<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	    session.setAttribute("Heading","�O�渹�X,�n�O�Ѹ��X,���ڤH�m�W,���ڤHID,��I���B,�I�ڤ覡,�I�ڤ��e,�I�ڪ��A,�@�o�_,���_,��J��,��J��");
	    session.setAttribute("DisplayFields", "POLICY_NO,APP_NO,PAY_NAME,PAY_ID,PAY_AMOUNT,PAY_METHOD,PAY_DESCRIPTION,PAY_STATUS,PAY_VOIDABLE,PAY_DISPATCH,ENTRY_USER,ENTRY_DATE");
	    session.setAttribute("ReturnFields", "POLICY_NO,APP_NO,PAY_NAME,PAY_ID,PAY_AMOUNT,PAY_METHOD,PAY_DESCRIPTION,PAY_STATUS,PAY_VOIDABLE,PAY_DISPATCH,PAY_NO,PAY_DATE,PAY_CONFIRM_DATE1,PAY_CONFIRM_DATE2,PAY_CONFIRM_TIME2,PAY_CONFIRM_USER2,PAY_SOURCE_CODE,PAY_REMIT_BANK,PAY_REMIT_ACCOUNT,PAY_CREDIT_CARD,PAY_CREDIT_TYPE,PAY_AUTHORITY_CODE,PAY_CARD_MMYYYY,PAY_AUTHORITY_DATE,PAY_SOURCE_GROUP,PSRCGPDESC,PAY_CHECK_M1,PAY_CHECK_M2,PAY_CURRENCY");
	    %>
		//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" )
		{
			var returnArray = string2Array(strReturnValue,",");
	
			document.getElementById("txtUPolNo").value = returnArray[0];
			document.getElementById("txtUAppNo").value = returnArray[1];
			var strName = returnArray[2];
			while(strName.indexOf('�@')>1) {
			   strName =strName.replace('�@','');
			}
			document.getElementById("txtUPName").value = strName;			
			//document.getElementById("txtUPName").value = returnArray[2];
			document.getElementById("txtUPId").value = returnArray[3];
			document.getElementById("txtUPAMT").value = returnArray[4];		
			var strPcfmdt1 = returnArray[6];
			var strPMethod = returnArray[5];
			document.getElementById("hidPMethod").value = returnArray[5];
			//makedataSelected("selUPMethod",strPMethod);
			document.getElementById("txtUPDesc").value = returnArray[6];	
			var strUPStatus = returnArray[7];
			var strUPVoidable = returnArray[8];
			document.getElementById("hidPVoidabled").value = returnArray[8];	
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
            var strPcfmdt1 = returnArray[12];			
			var strUPCfmDT2 = returnArray[13];
			var strUPCfmTM2 = returnArray[14];
			var strUPCfmUsr2 = returnArray[15];
			//document.getElementById("txtUPSrcCode").value = returnArray[15] + "--"+returnArray[24];
			document.getElementById("hidPSrcCode").value = returnArray[16];

			document.getElementById("txtUPRBank").value = returnArray[17];
			document.getElementById("txtUPRAccount").value = returnArray[18];
			document.getElementById("txtUPCrdNo").value = returnArray[19];
			document.getElementById("txtPUCrdType").value = returnArray[20];
			
			document.getElementById("txtUPAuthCode").value = returnArray[21];
			document.getElementById("txtUPCrdEffMY").value = returnArray[22];
//			makedataSelected("selUPCrdEffM",returnArray[21].substring(0,2));
//			makedataSelected("selUPCrdEffY",returnArray[21].substring(2,6));

    		if( returnArray[23] == "0") {
				document.getElementById("txtUPAuthDt").value = "";
				document.getElementById("txtUPAuthDtC").value = "";
			} else {
				document.getElementById("txtUPAuthDt").value = returnArray[23];
				document.getElementById("txtUPAuthDtC").value = string2RocDate(returnArray[23]);
			}
			document.getElementById("txtUPSrcGp").value = returnArray[24]+ "--"+ returnArray[25];
			var strChkM1 = returnArray[26];
			if(strChkM1=="Y") {
				document.frmMain.rdUPCHKM1[0].checked = true;
			} else {
				document.frmMain.rdUPCHKM1[1].checked = true;
			}
			var strChkM2 = returnArray[27];
			if(strChkM2=="Y") {
				document.frmMain.rdUPCHKM2[0].checked = true;
			} else {
				document.frmMain.rdUPCHKM2[1].checked = true;
			}
			//document.getElementById("txtCurrency").value = returnArray[28];
			var strCurrency = returnArray[28];
			document.getElementById("txtCurrency").value = returnArray[28];
			document.getElementById("txtAction").value = "I";

			/*�������줣�i�H�Q�ק�*/
			document.getElementById("txtUPId").className="INPUT_DISPLAY";
			document.getElementById("txtUPId").readOnly =true;
			document.getElementById("txtUPAMT").className="INPUT_DISPLAY";
			document.getElementById("txtUPAMT").readOnly =true;
			document.getElementById("txtUPolNo").className="INPUT_DISPLAY";
			document.getElementById("txtUPolNo").readOnly =true;
			document.getElementById("txtUAppNo").className="INPUT_DISPLAY";
			document.getElementById("txtUAppNo").readOnly =true;
			document.getElementById("selUCurrency").readOnly = true;
			if(strUPVoidable == "Y") {
				document.getElementById("VoidableArea").style.display = "block";
			}
			if(strPcfmdt1 == 0) {
				document.getElementById("CFM1Area").style.display = "block";
			}
			//R60550 �s�W12�����
			document.getElementById("txtAction").value = "INQ";
			document.getElementById("frmMain").submit();

			makeButtons();
			makeSeleted();

			disableAll();
			document.getElementById("updateArea").style.display = "block";
			document.getElementById("inqueryArea").style.display = "none";
		}
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
			var selObj = document.getElementById("selUCurrency");
			var selIndex = selObj.selectedIndex ;

			//R10314  �ˮ� �~���ץX�ײv / ��I���B�x���Ѧҭ�
			if( (selObj.options[selIndex].value == document.getElementById("txtPAYCURR").value) &&
				(document.getElementById("txtPAYRATE").value != "1.0000") )
			{
				alert("�~���ץX�ײv������1.0000");
				return false;
			}
			if( (document.getElementById("selUPMethod").value == "D") &&
				(selObj.options[selIndex].value != document.getElementById("txtPAYCURR").value) &&
				(document.getElementById("txtPAYRATE").value == "1.0000") )
			{
				alert("�п�J�~���ץX�ײv�A���i��1.0000");
				return false;
			}
			if( (selObj.options[selIndex].value != "NT") && 
				(selObj.options[selIndex].value == document.getElementById("txtPAYCURR").value) &&
				(document.getElementById("txtUPAMT").value == document.getElementById("txtPAYAMTNT").value) )
			{
				//var confirmMsg = "�нT�{�u��I���B�x���Ѧҭȡv=�u��I���B�v*�u�~���ץX���O�v�O�_���T�H\r\n";
				var confirmMsg = "�нT�{�u��I���B�x���Ѧҭȡv�O�_���T�H\r\n";
				//confirmMsg += document.getElementById("txtPAYAMTNT").value + "=";
				//confirmMsg += document.getElementById("txtUPAMT").value + "*";
				//confirmMsg += document.getElementById('txtPAYRATE').value;

				var varConfirm = window.confirm(confirmMsg);
				if( !varConfirm )
				{
					document.getElementById("txtPAYAMTNT").focus();
					return false;
				}
			}

			if (selObj.options[selIndex].value != "NT") {
				var varPayRate = document.getElementById("txtPAYRATE").value;
				if (selObj.options[selIndex].value == document.getElementById("txtPAYCURR").value) {
					varPayRate = 1.0000;
				}
				document.getElementById("txtPAYAMT").value = parseFloat(document.getElementById("txtUPAMT").value) * parseFloat(varPayRate);
			}

			document.getElementById("frmMain").submit();
		}
		else
			alert( strErrMsg );	
	}
	else
		alert( strErrMsg );
}

function DISBCanConfirmAction() 
{
   	var bConfirm = window.confirm("�O�_�T�w�����ӵ���ƪ���I�T�{?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "DISBCancelConfirm";
		document.getElementById("frmMain").submit();
	}
}

function DISBPVoidableAction()
{

   	var bConfirm = window.confirm("�O�_�T�w�n�@�o�������?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "DISBPVoidable";
		document.getElementById("frmMain").submit();
	}
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
		if( objThisItem.value == "" )
		{
			strTmpMsg = "���ڤH�m�W���i�ť�";
			bReturnStatus = false;
		}
	}
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
	}
	else if( objThisItem.id == "selUCurrency" )
	{
		// R80132  if (document.getElementById("selUCurrency").value == "US" && 
		if (document.getElementById("selUCurrency").value != "NT" && 
			document.getElementById("selUPMethod").value != "D")
		{
			// R80132  strTmpMsg = "�����O��I�ڤ覡�u��[�~���״�]";
			strTmpMsg = "�~���O��I�ڤ覡�u��[�~���״�]";
			bReturnStatus = false;
		}
	}		
	else if( objThisItem.id == "selUPMethod" )
	{
		if( objThisItem.value == "A")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�䲼]\r\n";
			// R80132   if (document.getElementById("selUCurrency").value =="US"){
			if (document.getElementById("selUCurrency").value !="NT"){			
			   // R80132  strTmpMsg += "-->�����O�椣���\�}��";
			   strTmpMsg += "-->�~���O�椣���\�}��";			   
			   bReturnStatus = false;
			}
			
			if(document.getElementById("txtUPRBank").value !="" || document.getElementById("txtUPRAccount").value !="" || document.getElementById("txtUPCrdNo").value !="" || document.getElementById("selPUCrdType").value !="" || document.getElementById("txtUPCrdEffMY").value !="" || document.getElementById("txtUPAuthCode").value !="" || document.getElementById("txtUPAuthDtC").value !="")
			{
				strTmpMsg += "-->�״ڻȦ�/�״ڱb��/�H�Υd�d��/�d�O/���Ħ~��/���v�X/���v�����,���ݿ�J";
				bReturnStatus = false;
			}
			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "B")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�״�]\r\n";
			if(document.getElementById("txtUPRBank").value =="" && document.getElementById("selUCurrency").value =="NT")
			{			 
				strTmpMsg += "-->�״ڻȦ椣�i�ť�\r\n";
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
			document.getElementById("txtUPAuthDt").value ="";
		}
		else if( objThisItem.value == "C")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�H�Υd]\r\n";
			// R80132  if (document.getElementById("selUCurrency").value =="US")
			if (document.getElementById("selUCurrency").value !="NT")			
			{
			// R80132  strTmpMsg += "-->�����O�椣���\�H�Υd���I";
			strTmpMsg += "-->�~���O�椣���\�H�Υd���I";			
			   bReturnStatus = false;
			}			
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
			if(document.getElementById("txtUPCrdEffMY").value =="" )
			{
				strTmpMsg += "-->�п�ܦ��Ĥ�~\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPAuthDtC").value =="" )
			{
				strTmpMsg += "-->�п�ܱ��v�����\r\n";
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
		//R60550���_�l��e���ݱj��KEY�~���״����
		else if( objThisItem.value == "D")
		{
			strTmpMsg = "�A�ҿ�ܪ���I�覡�O[�~���״�]\r\n";
			if (document.getElementById("txtINVDTC").value =="000/00/00" && 
				document.getElementById("txtSYMBOL").value.toUpperCase() == "S")
			{
				strTmpMsg += "-->SPUL��п�J���_�l��\r\n";
				bReturnStatus = false;
			}
			if(document.getElementById("txtUPRAccount").value =="" )
			{
				strTmpMsg += "-->�״ڱb�����i�ť�\r\n";
				bReturnStatus = false;
			}
			//R70088���_�l��e&�t���nKEY�״ڻȦ�
			if((document.getElementById("txtUPRBank").value =="" && document.getElementById("hidENTRYDT").value <= document.getElementById("txtINVDT").value) 
			  //R70455 || (document.getElementById("txtUPRBank").value =="" && document.getElementById("selUPSrcCode").value =="B8"))
			  || (document.getElementById("txtUPRBank").value =="" && 
	     	   //r00440 (document.getElementById("selUPSrcCode").value =="B8" || document.getElementById("selUPSrcCode").value =="B9")))
		         (document.getElementById("selUPSrcCode").value =="B8" || document.getElementById("selUPSrcCode").value =="B9" || document.getElementById("selUPSrcCode").value =="BB")))//R00440-SN�������@�~
			{
				strTmpMsg += "-->���_�l��e�ΰt��,�״ڻȦ椣�i�ť�\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPAYCURR").value =="")
			{
				strTmpMsg += "-->�~���ץX���O���i�ť�\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("txtPAYRATE").value ==".0000")
			{
				strTmpMsg += "-->�~���ץX�ײv���i�ť�\r\n";
				bReturnStatus = false;
			}
			if (document.getElementById("selFEEWAY").value =="")
			{
				strTmpMsg += "-->����O��I�覡���i�ť�\r\n";
				bReturnStatus = false;
			}
			//R70088 ���_�l��O�P��J���� �״ڤ� -> ��J��
			//R70477 �~���O��j���J
			//R70455  if (document.getElementById("hidENTRYDT").value > document.getElementById("txtINVDT").value && document.getElementById("selUPSrcCode").value !="B8")
			if ((document.getElementById("hidENTRYDT").value > document.getElementById("txtINVDT").value 
			 //R00440 SN�������@�~  && document.getElementById("selUPSrcCode").value !="B8" && document.getElementById("selUPSrcCode").value !="B9")
			    && document.getElementById("selUPSrcCode").value !="B8" && document.getElementById("selUPSrcCode").value !="B9" && document.getElementById("selUPSrcCode").value !="BB")//R00440 SN�������@�~
             || (document.getElementById("txtSYMBOL").value == "D") )//Q70581
			{
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
				var reg=/[^A-Z\- ]/g;
				if (reg.test(document.getElementById("txtPENGNAME").value))
				{
					strTmpMsg += "-->���ڤH�^��m�W�u�ର�j�g�^��r��";
					bReturnStatus = false;
				}
			}
		}
		//RB0302�������x����󤧫O��ɴڤ~��{����I
		else if( objThisItem.value == "E" )
		{
			if(!(document.getElementById("txtCurrency").value == "NT" && 
				(document.getElementById("selUPSrcCode").value == "E1" || document.getElementById("selUPSrcCode").value == "E2") &&
				document.frmMain.rdUDispatch[0].checked)) {
				strTmpMsg += "��������󤧫O��ɴڤ~��{����I\r\n";
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
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
/*R30530  modi 20050223 -->�ݭn�����,�l�i�H�����䲼���u start */
function checkRadio()
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	/* RB0302�������~�i�����䲼���u
	if( document.frmMain.rdUPCHKM2[1].checked && document.frmMain.rdUDispatch[1].checked )
	{
		strTmpMsg = "�ݭn�����,�l�i�H�����䲼���u!\r\n";
		bReturnStatus = false;
	}*/
	// R80132
   	if( document.getElementById("selUCurrency").value !="NT" && document.frmMain.rdUDispatch[0].checked )
   	{
   		strTmpMsg += "�~���O�椣�i�Ŀ���!\r\n";
		bReturnStatus = false;
	}
	// R80132  END
	//RB0302���i�P�ɨ����䲼�T�I�Τ䲼���u
	if( document.frmMain.rdUPCHKM1[1].checked && document.frmMain.rdUPCHKM2[1].checked )
	{
		strTmpMsg += "���i�P�ɨ����䲼�T�I�Τ䲼���u!\r\n";
		bReturnStatus = false;
	}

	if( !bReturnStatus )
	{
		strErrMsg = strErrMsg + strTmpMsg;
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
		document.getElementById("txtPAYCURR").value = document.getElementById("txtPAYCURR").value.toUpperCase();
	}
	if(document.getElementById("txtAction").value == "U" || document.getElementById("txtAction").value == "A")   
	{
		document.getElementById("txtUPDate").value = rocDate2String(document.getElementById("txtUPDateC").value) ;	
		document.getElementById("txtUPCrdEffMY").value =  document.getElementById("selUPCrdEffM").value + document.getElementById("selUPCrdEffY").value ;
	  	document.getElementById("txtUPAuthDt").value = rocDate2String(document.getElementById("txtUPAuthDtC").value) ;	   
	    document.getElementById("txtPUCrdType").value = document.getElementById("selPUCrdType").value;	 
	    if (document.getElementById("txtAction").value == "A")
	    	document.getElementById("txtINVDT").value = rocDate2String(document.getElementById("txtINVDTC").value);
	    document.getElementById("txtPAYCURR").value = document.getElementById("txtPAYCURR").value.toUpperCase();

		document.getElementById("txtPBKBRCH").value = document.getElementById("txtPBKBRCH").value.toUpperCase(); //RA0074 
		document.getElementById("txtPBKCITY").value = document.getElementById("txtPBKCITY").value.toUpperCase(); //RA0074
		document.getElementById("txtPENGNAME").value = document.getElementById("txtPENGNAME").value.toUpperCase(); //RA0074
    }
}

function makeButtons()
{
	if(document.getElementById("hidPStatus").value  !="" || document.getElementById("hidPVoidabled").value  == "Y")
	{
		WindowOnLoadCommon( document.title+"(���})" , '' , strDISBFunctionKeyExit,'' );
	}
	else
	{
		if(document.getElementById("hidPConDT2").value!="0")
		{
			WindowOnLoadCommon( document.title+"(�����T�{)" , '' , strDISBFunctionKeyInquiry_1,'' ) ;
		}
		else
		{
			WindowOnLoadCommon( document.title+"(�ק�Χ@�o)" , '' , strDISBFunctionKeyInquiry,'' ) ;
		}
	}

	disableAll();
}

function makeSeleted()
{
	for(var i=0;i< document.getElementById("selUPMethod").options.length;i++)
	{
		if( document.getElementById("hidPMethod").value == document.getElementById("selUPMethod").options.item(i).value )
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
	for(var i=0;i< document.getElementById("selUCurrency").options.length;i++)
	{
		if( document.getElementById("txtCurrency").value== document.getElementById("selUCurrency").options.item(i).value )
		{
			document.getElementById("selUCurrency").options.item(i).selected = true;
			break;
		}
	}
}

//R10314 ��I���B�x���Ѧҭ�=��I���B*�~���ץX�ײv
function calPAYAMTNT() 
{
	var varPayRate = 1.0000;

	if(document.getElementById("selUCurrency").value != "NT")
		varPayRate = document.getElementById('txtPAYRATE').value;

	document.getElementById('txtPAYAMTNT').value = Math.round( parseFloat(document.getElementById('txtUPAMT').value) * parseFloat(varPayRate));
}

//RA0074 �̻Ȧ�N�X�e�T�X�a�XSWIFT CODE
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
<form id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpayment.DISBPMaintainServlet">
<TABLE border="1" width="452" height="333" id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">���ڤH�m�W�G</TD>
			<TD><INPUT class="Data" size="40" type="text" maxlength="40" id="txtPName" name="txtPName" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">���ڤHID�G</TD>
			<TD width="333"><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPid" name="txtPid" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">���O�G</TD>
			<TD width="333">
				<select size="1" name="selCurrency" id="selCurrency">
					<option value="">&nbsp;</option>
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">��I���B�G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPAMT" id="txtPAMT" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�I�ڤ���G</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPStartDateC" name="txtPStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> ~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC" name="txtPEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT type="hidden" name="txtPEndDate" id="txtPEndDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">��J����G</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate" value=""> ~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryEndDateC" name="txtEntryEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtEntryEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
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
		<tr>
			<TD align="right" class="TableHeading" width="101">�H�Υd���X�G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCrdNo" name="txtPCrdNo" value=""></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" width="101">���ʤ���G</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUpdStartDateC" name="txtUpdStartDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtUpdStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT type="hidden" name="txtUpdStartDate" id="txtUpdStartDate" value=""> ~ 
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtUpdEndDateC" name="txtUpdEndDateC" value="" readOnly onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('frmMain.txtUpdEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT type="hidden" name="txtUpdEndDate" id="txtUpdEndDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�@�o�_�G</TD>
			<TD width="333"><select size="1" name="selPVoidable" id="selPVoidable">
				<option value=""></option>
				<option value="Y">�O</option>
				<option value="N">�_</option>
			</select></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">���_�G</TD>
			<TD width="333"><select size="1" name="selDispatch" id="selDispatch">
				<option value=""></option>
				<option value="Y">�O</option>
				<option value="">�_</option>
			</select></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�O�渹�X�G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPolicyNo" id="txtPolicyNo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101" height="24"> �n�O�Ѹ��X�G</TD>
			<TD height="24"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtAppNo" id="txtAppNo" value=""></TD>
		</TR>
	</TBODY>
</TABLE>
<DIV id="VoidableArea" style="display: none"><font color="red"><b>�ӵ���Ƥw�Q�@�o</b></font></div>
<DIV id="CFM1Area" style="display: none"><font color="red"><b>������Ʃ|���T�{�I��</b></font></div>
<TABLE border="1" width="712" id="updateArea" style="display: none">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="162">��I�Ǹ��G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="25" name="txtUPNO" id="txtUPNO" value="<%=strPNo%>" readonly></TD>
		</TR>

		<tr>
			<TD align="right" class="TableHeading" width="162">���ڤH�m�W�G</TD>
			<TD width="543"><INPUT class="Data" size="40" type="text" maxlength="40" id="txtUPName" name="txtUPName" value="<%=strPName%>"></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="162">���ڤHID�G</TD>
			<TD width="543"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPId" name="txtUPId" value="<%=strPId%>"></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="162">�O����O�G</TD>
			<TD width="543"><select size="1" name="selUCurrency" id="selUCurrency" class="Data"><%=sbCurrCash.toString()%></select></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="162">��I���B�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPAMT" id="txtUPAMT" value="<%=strPAmt%>" onchange="calPAYAMTNT();"></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="162">�I�ڤ���G</TD>
			<TD height="24" width="543"><INPUT class="Data" size="11" type="text" maxlength="11" id="txtUPDateC" name="txtUPDateC" readOnly onblur="checkClientField(this,true);"><a href="javascript:show_calendar('frmMain.txtUPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" width="24" height="21"></a> <INPUT type="hidden" name="txtUPDate" id="txtUPDate" value="<%=strPDate%>"></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="162">��I�y�z�G</TD>
			<TD width="543"><INPUT class="Data" size="40" type="text" maxlength="40" name="txtUPDesc" id="txtUPDesc" value="<%=strPdesc%>"></TD>
		</tr>

		<TR>
			<TD align="right" class="TableHeading" width="162">�I�ڤ覡�G</TD>
			<TD width="543"><select size="1" name="selUPMethod" id="selUPMethod" class="Data">
				<% //R60550
				//R80498 �s�W����~���״ڪ��B������0,�~��ܿﶵ
				if ((!strCurrency.equals("NT") && !strAction.equals("")) || 
					(!strPAYCURR.equals("") && strSYMBOL.equals("S") && (iENTRYDT <= iINVDT) && iPAYAMT !=0))
				{ 
				out.println("<option value=\"D\">�~���״�</option>");	}
				else
				{	
				%>
				<option value="A">�䲼</option>
				<option value="B">�״�</option>
				<option value="C">�H�Υd</option>
				<option value="E">�{��</option>
				<%
				if ((strSYMBOL.equals("S") && (iENTRYDT > iINVDT) && iPAYAMT !=0) || strAction.equals(""))
				{out.println("<option value=\"D\">�~���״�</option>");}
				}
				%>
			</select></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="162">�״ڻȦ�N���G</TD>
			<TD width="543">
				<INPUT class="Data" size="8" type="text" maxlength="7" value="<%=strPRBank%>" name="txtUPRBank" id="txtUPRBank" ONKEYUP="autoComplete(this,this.form.options,'value',true,'selList');" onchange="WriteCode();">
				<span style="display: none" id="selList"><SELECT NAME="options" onChange="this.form.txtUPRBank.value=this.options[this.selectedIndex].value,WriteCode();" MULTIPLE SIZE=4 onblur="disableList('selList')" class="Data"><%=sbBankCode.toString()%></SELECT></span>
			</TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="162">�״ڻȦ�b���G</TD>
			<TD width="543"><INPUT class="Data" size="20" type="text" maxlength="16" name="txtUPRAccount" id="txtUPRAccount" value="<%=strPRAccount%>"></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="162">�H�Υd���X�G</TD>
			<TD width="543"><INPUT class="Data" size="20" type="text" maxlength="16" id="txtUPCrdNo" name="txtUPCrdNo" value="<%=strPCrdNo%>"></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" class="Data" width="162">�d�O�G</TD>
			<TD width="543">
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
			<TD align="right" class="TableHeading" width="162">���ĺI���~�G</TD>
			<TD width="543">
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
			<TD align="right" class="TableHeading" width="162">���v�X�G</TD>
			<TD width="543"><INPUT class="Data" size="11" type="text" maxlength="10" id="txtUPAuthCode" name="txtUPAuthCode" value="<%=strPAuthCode%>"><font color="red" size="2">(��l���v�X)</font></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="162">���v�����G</TD>
			<TD height="24" width="543"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtUPAuthDtC" name="txtUPAuthDtC"
				onblur="checkClientField(this,true);"><a
				href="javascript:show_calendar('frmMain.txtUPAuthDtC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" width="24"
				height="21"></a> <INPUT type="hidden" name="txtUPAuthDt"
				id="txtUPAuthDt" value="<%=strPAuthDt%>"><font color="red" size="2">(��l���v�����)</font></TD>
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
			<TD align="right" class="TableHeading" width="162">���_�G</TD>
			<TD width="543"><input type="radio" name="rdUDispatch" id="rdUDispatch" Value="Y"
				<%if (strPDispatch.trim().equals("Y"))
	out.println("checked");%>
				class="Data">�O <input type="radio" name="rdUDispatch"
				id="rdUDispatch" Value=""
				<%if (!strPDispatch.trim().equals("Y"))
	out.println("checked");%>
				class="Data">�_</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="162">�䲼�T�I�G</TD>
			<TD width="543"><input type="radio" name="rdUPCHKM1" id="rdUPCHKM1"
				Value="Y" <%if (strPChkm1.equals("Y"))
	out.println("checked");%>
				class="Data">�T�I<input type="radio" name="rdUPCHKM1" id="rdUPCHKM1"
				Value="" <%if (!strPChkm1.equals("Y"))
	out.println("checked");%>
				class="Data">�����T�I</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="162">�䲼���u�G</TD>
			<TD width="543"><input type="radio" name="rdUPCHKM2" id="rdUPCHKM2"
				Value="Y" <%if (strPChkm2.equals("Y"))
	out.println("checked");%>
				class="Data">���u <input type="radio" name="rdUPCHKM2" id="rdUPCHKM2"
				Value="" <%if (!strPChkm2.equals("Y"))
	out.println("checked");%>
				class="Data">�������u</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="162">�O�渹�X�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPolNo" id="txtUPolNo" value="<%=strPolNo%>"></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" height="24" width="162">�n�O�Ѹ��X�G</TD>
			<TD height="24" width="543"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUAppNo" id="txtUAppNo" VALUE="<%=strAppNo%>"></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="162">��I��]�G</TD>
			<TD width="543"><select size="1" name="selUPSrcCode" id="selUPSrcCode" class="Data"><%=sbPSrcCode.toString()%></select></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="162">�ӷ��s�աG</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtUPSrcGp" id="txtUPSrcGp" VALUE="<%=strPSrcGp%>" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="162">��l�I�ڤ覡�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtPMETHODO" id="txtPMETHODO" VALUE="<%=strPMETHODO%><%=strPMETHODODESC%>" readonly></TD>
		</tr>
		<!--R60550�s�W11�����FOR�~���״�-->
		<tr id="usSHOW0" style="display: none">
			<TD align="right" class="TableHeading" width="162">���_�l��G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="11" id="txtINVDTC" name="txtINVDTC" readOnly> <a
				href="javascript:show_calendar('frmMain.txtINVDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" width="24"
				height="21" style="display: none" id="imgShow"></a> <INPUT type="hidden" name="txtINVDT" id="txtINVDT" value="<%=strINVDTC%>">
			</TD>
		</tr>
		<tr id="usSHOW1" style="display: none">
			<TD align="right" class="TableHeading" width="162">�~���ץX���O�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="10" type="text" maxlength="10" name="txtPAYCURR" id="txtPAYCURR" VALUE="<%=strPAYCURR%>" style="text-transform: uppercase;" readonly></TD>
		</tr>
		<tr id="usSHOW2" style="display: none">
			<TD align="right" class="TableHeading" width="162">�~���ץX�ײv�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="16" type="text" maxlength="16" name="txtPAYRATE" id="txtPAYRATE" VALUE="<%=df2.format(iPAYRATE)%>" onchange="calPAYAMTNT();" readonly></TD>
		</tr>
		<tr id="usSHOW3" style="display: none">
			<TD align="right" class="TableHeading" width="162">�~���ץX���B�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtPAYAMT" id="txtPAYAMT" VALUE="<%=df2.format(iPAYAMT)%>" readonly></TD>
		</tr>
		<TR id="ACCTSHOW" style="display: none">
			<TD align="right" class="TableHeading" width="162">��I���B�x���ѦҭȡG</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="10" type="text" maxlength="20" name="txtPAYAMTNT" id="txtPAYAMTNT" VALUE="<%=iPAYAMTNT%>" readonly></TD>
		</TR>
		<tr id="usSHOW4" style="display: none">
			<TD align="right" class="TableHeading" width="162">����O��I�覡�G</TD>
			<TD width="543"><select size="1" name="selFEEWAY" id="selFEEWAY" class="Data">
				<option value="SHA">�U�ۭt��</option>
				<option value="BEN">�O���I</option>
				<option value="OUR">���q��I</option>
			</select></TD>
		</tr>
		<tr id="usSHOW5" style="display: none">
			<TD align="right" class="TableHeading" width="162">SWIFT CODE�G</TD>
			<TD width="543">
				<INPUT class="Data" size="13" type="text" maxlength="12" value="<%=strPSWIFT%>" name="txtPSWIFT" id="txtPSWIFT" ONKEYUP="autoComplete(this,this.form.selPSWIFT,'value',true,'selList2')">
				<span style="display: none" id="selList2"> <select name="selPSWIFT" id="selPSWIFT" onChange="this.form.txtPSWIFT.value=this.options[this.selectedIndex].value;this.form.selPBKCOTRY.value=this.value.substring(4,6)" MULTIPLE SIZE=4 onblur="disableList('selList2')" class="Data"><%=sbSWIFTCode.toString()%></select></span>
				<%=sBankNo.toString()%>
			</TD>
		</tr>
		<tr id="usSHOW6" style="display: none">
			<TD align="right" class="TableHeading" width="162">�Ȧ����G</TD>
			<TD width="543"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKBRCH" id="txtPBKBRCH" value="<%=strPBKBRCH%>" style="text-transform: uppercase;" onchange="this.form.txtPBKBRCH.value=FulltoHalf(this.form.txtPBKBRCH.value);"></TD>
		</tr>
		<tr id="usSHOW7" style="display: none">
			<TD align="right" class="TableHeading" width="162">�Ȧ櫰���G</TD>
			<TD width="543"><INPUT class="Data" size="20" type="text" maxlength="20" name="txtPBKCITY" id="txtPBKCITY" value="<%=strPBKCITY%>" style="text-transform: uppercase;" onchange="this.form.txtPBKCITY.value=FulltoHalf(this.form.txtPBKCITY.value);"></TD>
		</tr>
		<tr id="usSHOW8" style="display: none">
			<TD align="right" class="TableHeading" width="162">�Ȧ��O�G</TD>
			<TD width="543"><select size="1" name="selPBKCOTRY" id="selPBKCOTRY" class="Data"><%=sbCotryCode.toString()%></select></TD>
		</tr>
		<tr id="usSHOW9" style="display: none">
			<TD align="right" class="TableHeading" width="162">���ڤH�^��m�W�G</TD>
			<TD width="543"><INPUT class="Data" size="70" type="text" maxlength="70" name="txtPENGNAME" id="txtPENGNAME" value="<%=strPENGNAME%>" style="text-transform: uppercase;" onchange="this.form.txtPENGNAME.value=FulltoHalf(this.form.txtPENGNAME.value);"></TD>
		</tr>
		<tr id="usSHOW10" style="display: none">
			<TD align="right" class="TableHeading" width="162">���O�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="5" type="text" maxlength="1" name="txtSYMBOL" id="txtSYMBOL" VALUE="<%=strSYMBOL%>" readonly><font color="red" size="2">(���� S:SPUL  D:�~���O��)</font></TD>
		</tr>
		<tr id="usSHOW11" style="display: none">
			<TD align="right" class="TableHeading" width="162">�װh����O�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="40" type="text"
				maxlength="40" name="txtFPAYAMT" id="txtFPAYAMT"
				VALUE="<%=df2.format(iFPAYAMT)%>" readonly><font color="red"
				size="2">(�װh����O���O�P�~���ץX���O)</font></TD>
		</tr>
		<tr id="usSHOW12" style="display: none">
			<TD align="right" class="TableHeading" width="162">�װh����O��I�覡�G</TD>
			<TD width="543"><INPUT class="INPUT_DISPLAY" size="40" type="text"
				maxlength="40" name="txtFFEEWAY" id="txtFFEEWAY"
				VALUE="<%=strFFEEWAY%>" readonly></TD>
		</tr>
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value=""> 
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtErr" name="txtErr" value="<%=strErr%>"> 
<INPUT type="hidden" id="hidPMethod" name="hidPMethod" value="<%=strPMethod%>">
<INPUT type="hidden" id="hidPConDT2" name="hidPConDT2" value="<%=iPConDT2%>"> 
<INPUT type="hidden" id="hidPSrcCode" name="hidPSrcCode" value="<%=strPSrcCode%>"> 
<INPUT type="hidden" id="hidPStatus" name="hidPStatus" value="<%=strPStatus%>"> 
<INPUT type="hidden" id="txtCurrency" name="txtCurrency" value="<%=strCurrency%>">
<INPUT type="hidden" id="hidPVoidabled" name="hidPVoidabled" value="<%=strVoidabled%>">
<INPUT type="hidden" id="hidENTRYDT" name="hidENTRYDT" value="<%=strENTRYDTC%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
</FORM>
</BODY>
</HTML>