<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.21 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2013/12/24 03:55:46 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBRemitFailed.jsp,v $
 * Revision 1.21  2013/12/24 03:55:46  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.17.4.1  2012/12/06 06:28:26  MISSALLY
 * RA0102�@PA0041
 * �t�X�k�O�ק�S����I�@�~
 *
 * Revision 1.17  2012/05/18 09:49:51  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�
 *
 * Revision 1.16  2011/06/02 10:28:08  MISSALLY
 * Q90585 / R90884 / R90989
 * CASH�t�ζװh�B�z�@�~�s�W�װh��]���íץ��h�ש��Ӫ�
 *
 * Revision 1.15  2010/11/23 02:39:10  MISJIMMY
 * R00226-�ʦ~�M��
 * R00365-�װh����L�k���T��ܤ���O��I�覡�Τ���O���B
 *
 * Revision 1.14  2009/07/03 04:28:29  missteven
 * �h�פĿ���쬰�ť�
 * �װh��ܽT�{���ƤΪ��B����
 *
 * Revision 1.13  2009/02/24 06:34:57  misodin
 * R90130 ���a�X�䲼�󤧧P�_�覡�վ�
 *
 * Revision 1.12  2008/09/04 06:10:14  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.11  2008/08/06 07:07:31  MISODIN
 * R80338 �վ�CASH�t�� for �X�ǥ~���@��@�ݨD
 *
 * Revision 1.10  2008/06/06 03:34:06  misvanessa
 * R80391_�зs�WCASH�t�ΫH�Υd�h�^
 *
 * Revision 1.9  2008/04/01 06:14:43  misvanessa
 * R80211_�s�W�װh����έק�װh����W�h
 *
 * Revision 1.8  2007/10/04 01:27:10  MISODIN
 * R70477 �~���O��״ڤ���O
 *
 * Revision 1.7  2007/08/28 01:37:56  MISVANESSA
 * R70574_SPUL�t���s�W�ץX�ɮ�
 *
 * Revision 1.6  2007/04/13 06:06:15  MISVANESSA
 * R70279_�װh����B�z
 *
 * Revision 1.5  2007/01/31 08:07:42  MISVANESSA
 * R70088_SPUL�t��
 *
 * Revision 1.4  2007/01/04 03:28:55  MISVANESSA
 * R60550_����覡�ק�
 *
 * Revision 1.3  2006/11/30 09:15:36  MISVANESSA
 * R60550_�t�XSPUL&�~���I�ڭק�
 *
 * Revision 1.2  2006/10/31 08:53:12  MISVANESSA
 * R60420_�װh�B�z�s�W����
 *
 * Revision 1.1  2006/06/29 09:39:46  MISangel
 * Init Project
 *
 * Revision 1.1.2.10  2006/04/27 09:41:44  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.9  2005/08/19 07:12:29  misangel
 * R50427 : �״ڥ�̳���+�m�W+�b���X��
 *
 * Revision 1.1.2.8  2005/04/04 07:02:25  miselsa
 * R30530 ��I�t��
 *  
 */
%><%!
String strThisProgId = "DISBRemitFailed"; //���{���N��
DecimalFormat df = new DecimalFormat("#.00");
DecimalFormat df2 = new DecimalFormat("#.0000");
%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

//R60420 �L�X��Ѷװh���
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();
String today = commonUtil.convertWesten2ROCDate(calendar.getTime());
int iToday = Integer.parseInt(commonUtil.convertWesten2ROCDate1(calendar.getTime()));

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

//�I�ڱb��
List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") == null) {
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList", alPBBank);
} else {
	alPBBank = (List) session.getAttribute("PBBankList");
}
StringBuffer sbPBBank = new StringBuffer();
sbPBBank.append("<option value=\"\">&nbsp;</option>");
if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		htTemp = (Hashtable) alPBBank.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbPBBank.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}

// R70477 �~���O��
List alPBBankD = new ArrayList();
if (session.getAttribute("PBBankListD") == null) {
	alPBBankD = (List) disbBean.getETable("PBKAT", "BANKD"); // R00386 - 2010/11/03 ���n�D�[�J BNKPR ���� bank
//	alPBBankD.addAll(disbBean.getETable("BNKPR", "BANKPR")); // R00386, �[�J�ǲΫ������O��Ϊ��״ڻȦ�
	alPBBankD.addAll(disbBean.getETable("PBKAT", "BANKP"));
	alPBBankD.addAll(disbBean.getETable("BNKFR", "BANKFR"));
	session.setAttribute("PBBankListD", alPBBankD);
} else {
	alPBBankD = (List) session.getAttribute("PBBankListD");
}
StringBuffer sbPBBankD = new StringBuffer();
sbPBBankD.append("<option value=\"\" >&nbsp;</option>");
if (alPBBankD.size() > 0) {
	for (int i = 0; i < alPBBankD.size(); i++) {
		htTemp = (Hashtable) alPBBankD.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		//R10314
		sbPBBankD.append("<option value=\"").append(strValue).append("\" >").append(strValue).append("-").append(strDesc).append("</option>");
		//if(strValue.equalsIgnoreCase("8220635/635131008304"))	//8220635/635131008304-���H�ȴ_��
			//sbPBBankD.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		//else
			//sbPBBankD.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}

// R80338
List alPBBankP = new ArrayList();
if (session.getAttribute("PBBankListP") == null) {
	alPBBankP = (List) disbBean.getETable("PBKAT", "BANKP");
	session.setAttribute("PBBankListP", alPBBankP);
} else {
	alPBBankP = (List) session.getAttribute("PBBankListP");
}
StringBuffer sbPBBankP = new StringBuffer();
sbPBBankD.append("<option value=\"\">&nbsp;</option>");
if (alPBBankP.size() > 0) {
	for (int i = 0; i < alPBBankP.size(); i++) {
		htTemp = (Hashtable) alPBBankP.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		if(strValue.equalsIgnoreCase("8220635/635530015707"))	//8220635/635530015707-���H�ȴ_��
			sbPBBankP.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
		else
			sbPBBankP.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}

//R80132 ���O�D��
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
} //R80132 END
StringBuffer sbCurrCash = new StringBuffer();
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equalsIgnoreCase("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
} else {
	sbCurrCash.append("<option value=\"\">&nbsp;</option>");
}

//R90884
List alRemitFail = new ArrayList();
if(session.getAttribute("RemitFailList") == null) {
	alRemitFail = (List) disbBean.getETable("CASH1");
	session.setAttribute("RemitFailList", alRemitFail);
} else {
	alRemitFail = (List) session.getAttribute("RemitFailList");
}
StringBuffer sbRemitFail = new StringBuffer();
StringBuffer sbRFScriptArray = new StringBuffer();
sbRemitFail.append("<option value=\"\">&nbsp;</option>");
if (alRemitFail.size() > 0) {
	for (int i = 0; i < alRemitFail.size(); i++) {
		htTemp = (Hashtable) alRemitFail.get(i);
		strValue = (String) htTemp.get("ETValue");
		strDesc = (String) htTemp.get("ETVDesc");
		sbRemitFail.append("<option value=\"").append(strValue).append("\">").append(strValue).append(" - ").append(strDesc).append("</option>");
		sbRFScriptArray.append(",[").append("\"").append(strValue).append("\"").append(",\"").append(strDesc).append("\"").append("]");
	}

	htTemp = null;
	strValue = null;
}

List alPDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
double iSumAmt = 0; //�`���B
DISBPaymentDetailVO objPDetailCounter = null;
if (session.getAttribute("PDetailList") != null) {
	alPDetail = (List) session.getAttribute("PDetailList");

	if (alPDetail != null) {
		if (alPDetail.size() > 0) {
			for (int k = 0; k < alPDetail.size(); k++) {
				objPDetailCounter = (DISBPaymentDetailVO) alPDetail.get(k);
				iSumAmt = iSumAmt + objPDetailCounter.getIPAMT();
			}
			itotalCount = alPDetail.size();
			objPDetailCounter = null;
		}
		if (itotalCount % iPageSize == 0) {
			itotalpage = itotalCount / iPageSize;
		} else {
			itotalpage = itotalCount / iPageSize + 1;
		}
	}
}
session.removeAttribute("PDetailList");

String strAction = "";
if (request.getAttribute("txtAction") != null) {
	strAction = (String) request.getAttribute("txtAction");
}

String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
	strReturnMessage = (String) request.getAttribute("txtMsg");
}
//R60550 
String strFEECURR = "";
if (request.getAttribute("txtFEECURR") != null) {
	strFEECURR = (String) request.getAttribute("txtFEECURR");
}

//R80391
String strWAYSHOW = "";
if (request.getAttribute("txtWAYSHOW") != null) {
	strWAYSHOW = (String) request.getAttribute("txtWAYSHOW");
}

//R10314
String strBRDate = "";
if (request.getAttribute("txtBRemitFailDate") != null) 
	strBRDate = (String) request.getAttribute("txtBRemitFailDate");
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>��I�\��--�h�׳B�z�@�~</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT LANGUAGE="javascript">
var iTotalrec =<%=itotalCount%>;
// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitFailed.jsp";
	}	

	if(document.getElementById("txtAction").value == "I")
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyRemitFailed,'' );	//�h��,���}
		document.getElementById("inquiryArea").style.display = "none";	// R70477
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";	//R80338
		document.getElementById("inquiryAreaC").style.display ="none";	//R90884
		document.getElementById("inquiryAreaE").style.display ="block";	//R90884
	}
	else
	{
		//R60420
		WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
		document.getElementById("inquiryArea").style.display = "block";	// R70477
		document.getElementById("inquiryAreaA").style.display ="block";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";	//R80338
		document.getElementById("inquiryAreaE").style.display ="none";	//R90884
	}

	//R90884
	document.getElementById("txtRDateC").value = "<%=today%>";
	document.getElementById("txtRFDateC").value = "<%=today%>";
	//R10314
	document.getElementById("txtBRFDateC").value = "<%=commonUtil.convertROCDate(strBRDate)%>";

	window.status = "";
}

// R70477 �~���O��
function showDArea()
{
	// R80338
	if(document.getElementById("selFEESHOW").value == "US") 
	{
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="block";
		document.getElementById("inquiryAreaD").style.display ="none";
	}
	else if(document.getElementById("selFEESHOW").value =="NT") 
	{
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="block";
	}
	else if(document.getElementById("selFEESHOW").value =="C")
	{
		document.getElementById("inquiryAreaA").style.display ="block";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";
	}
	else
	{
		document.getElementById("inquiryAreaA").style.display ="none";
		document.getElementById("inquiryAreaB").style.display ="none";
		document.getElementById("inquiryAreaD").style.display ="none";
	}
}

/*
��ƦW��:	resetAction()
��ƥ\��:	��toolbar frame �����M�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitFailed.jsp";
}

/*
��ƦW��:	confirmAction()
��ƥ\��:	��toolbar frame �����T�w���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��  :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function confirmAction()
{
    mapValue();
	if (document.getElementById("selFEESHOW").value == "US")
		document.getElementById("txtFEECURR").value = "US";
	else
		document.getElementById("txtFEECURR").value = "NT";

     document.getElementById("txtAction").value = "I";
    //R80211�I�ڤ��.���B.�W�r�T����쥲��J�G�ӥH�W
   	if( areAllFieldsOK() )
	{	
    	document.getElementById("frmMain").submit();
    }
}

//R80211
function areAllFieldsOK()
{
	var intCNT = 0;
	if (document.getElementById("txtNAME").value != "")
		intCNT = intCNT + 1;
	if (document.getElementById("txtPDate").value != "")
		intCNT = intCNT + 1;
	if (document.getElementById("txtAMT").value != "" )
		intCNT = intCNT + 1;
	if (document.getElementById("txtPCSHCM").value != "")
		intCNT = intCNT + 1;

	var varMsg = "";
	if (intCNT > 1) {
		var varRBDate = document.getElementById("txtBRDateC").value;
		if(varRBDate == "") {
			varMsg = "�п�J�Ȧ�h�צ^�s����I";
		} else if(varRBDate.replace(/\//g,"") > <%=iToday%>) {
			varMsg = "�Ȧ�h�צ^�s������o�ߩ�CAPSIL�}������I";
		}
	} else {
		varMsg = "�I�ڤ�/���B/���ڤH�m�W/�X�ǽT�{�饲��J�G�ӥH�W�d�߱���";
	}

	if(varMsg != "") {
		alert(varMsg);
		return false;
	} else {
		return true;
	}
}

//R80384 �� toolbar frame �����h�׫��s�Q�I���,����Ʒ|�Q����
function DISBRemitFailedAction()
{
	if(document.getElementById("selRFCode").value == "") 
	{
		alert("�п�ܰh�ץN�X!!");
		return false;
	}
	//R90884 �h�׭�]�ˮ� �N�X=99, User������J�h�׭�]
	if(document.getElementById("selRFCode").value == "99" && document.getElementById("txtRFDesc").value == "") 
	{
		alert("�h�ץN�X99�A�п�J�h�׭�]�C");
		return false;
	}

	var flag = 0 ;
	var amount = 0 ;
 	for (var i = 0 ; i <  iTotalrec ; i++ ) {
    	if(document.getElementById("ch" + i ).checked) {
       		flag++ ;
       		amount = amount + parseFloat(document.getElementById("txtPAMT"+i).value) ;
       	}
	}

 	if(flag == 0) {
    	alert("�ܤ֭n�Ŀ�@������");
		return false;
    } else {
		var bConfirm = window.confirm("�h�׵��ơG"+flag+"(��)\n\n�h�ת��B�G"+amount+"(��)\n\n�O�_�T�w�n����h�ק@�~!?" );
		if(bConfirm)
		{
			enableAll();
			document.getElementById("txtAction").value = "DISBRemitFailed";
			mapValue();
			document.getElementById("frmMain").submit();
		}
	}
}

/* R60420   �h��/�H�Υd�I�ڥ��ѳ���
��ƦW��:	printRAction()
��ƥ\��:	��toolbar frame ����������s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function printRAction()
{
	mapValue();//R80211
	window.status = "";
	if (EntryDateVaild())
	{
		getReportInfo();
		document.getElementById("frmMain1").target="_blank";
		document.getElementById("frmMain1").submit();
	}
}

//R80211��J�h�פ��
function EntryDateVaild()
{
	if (document.getElementById("txtRDate").value == "")
	{
		alert ("�п�J�h�פ��");
		return false;
	}
	else
		return true;
}

function getReportInfo()
{  
	var strSql = "";
	strSql  = "SELECT A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,A.POLICY_NO,A.APPNO,";
	strSql += " A.ENTRY_USER,B.DEPT AS USERDEPT,A.PDESC,A.PAY_SRC_NAME,C.BKNM,A.PAY_REMIT_ACCOUNT,";
	strSql += " A.PAY_CREDIT_CARD,A.PAY_NO_HISTORY,A.PAY_CURRENCY,A.ENTRY_DATE,A.PAY_PAYCURR,A.PAY_PAYAMT,";
	strSql += " A.PAY_PAYRATE,A.PAY_FEEWAY,A.REMIT_FEE,D.FPAYAMT,D.FFEEWAY,A.REMITFAILD,A.REMITFCODE,";
	strSql += " A.REMITFDESC ";
	strSql += " FROM CAPPAYF A ";
	strSql += " left outer join USER B on A.ENTRY_USER =B.USRID ";
	strSql += " left outer join CAPCCBF C on A.PRBANK=C.BKNO ";
	strSql += " left outer join caprfef d on A.PNO=D.FPNOH ";
	strSql += " left outer join (SELECT FPNOH,MAX(ENTRYDT) as ENTRYDT FROM CAPRFEF GROUP BY FPNOH) e on e.FPNOH=d.FPNOH and d.ENTRYDT=e.ENTRYDT ";
	strSql += " WHERE A.PAY_METHOD IN ('B','C','D') AND A.PAY_STATUS = 'A' AND A.PAY_REMITFAIL_DATE <> 0 ";
	strSql += " AND A.PAY_REMITFAIL_DATE= " + document.getElementById("txtRDate").value;

	//R80132
    if (document.getElementById("selCurrency").value !="")
    {
    	strSql += " AND A.PAY_CURRENCY = '" + document.getElementById("selCurrency").value + "' ";
    }

	strSql += " ORDER BY A.ENTRY_USER, A.PAY_METHOD";

	document.frmMain1.ReportSQL.value = strSql;
	document.frmMain1.para_PConDate.value = document.getElementById("txtRDate").value ;
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
	
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}

function mapValue() 
{
	document.getElementById("txtPDate").value = rocDate2String(document.getElementById("txtPDateC").value) ;
    var BankAccount = document.getElementById("selPBBank").value ;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);
	}  
	// R70477
	var BankAccountD = document.getElementById("selPBBankD").value ;
	if(BankAccountD !="")
	{
		var iindexof = BankAccountD.indexOf('/');
		document.getElementById("txtPBBankD").value = BankAccountD.substring(0,iindexof);
		document.getElementById("txtPBAccountD").value = BankAccountD.substring(iindexof+1);	
	}  
	// R80338
	var BankAccountP = document.getElementById("selPBBankP").value ;
	if(BankAccountP !="")
	{
		var iindexof = BankAccountP.indexOf('/');
		document.getElementById("txtPBBankP").value = BankAccountP.substring(0,iindexof);
		document.getElementById("txtPBAccountP").value = BankAccountP.substring(iindexof+1);	
	}  
	//R80211
	document.getElementById("txtRDate").value = rocDate2String(document.getElementById("txtRDateC").value);
	//R90884
	document.getElementById("txtRFDateC").value = document.getElementById("txtRDateC").value;
	document.getElementById("txtRFDate").value = rocDate2String(document.getElementById("txtRFDateC").value);
	//R10314
	document.getElementById("txtBRDate").value = rocDate2String(document.getElementById("txtBRDateC").value);
	document.getElementById("txtBRFDate").value = rocDate2String(document.getElementById("txtBRFDateC").value);
	//R80391
	document.getElementById("txtPCSHCM").value = rocDate2String(document.getElementById("txtPCSHCMC").value) ;
}

//R90884 �Y��ܰh�ץN�X�۰ʱa�X�h�׭�]
function changeRFDesc()
{
	var RemitFailArray = [<% if(sbRFScriptArray.toString().length() > 0) { out.print(sbRFScriptArray.toString().substring(1)); } %>];

	document.getElementById("txtRFDesc").value = "";
	document.getElementById("txtRFDesc").readOnly = true;
	for(var i=0; i<RemitFailArray.length; i++)
	{
		if( RemitFailArray[i][0] == document.getElementById("selRFCode").value ) {
			document.getElementById("txtRFDesc").value = RemitFailArray[i][1];
			if( RemitFailArray[i][0] == "99" ) {
				document.getElementById("txtRFDesc").readOnly = false;
			}
			break;
		}
	}
}
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitFailedServlet">
	<TABLE border="1" width="400" id=inquiryArea>
		<TBODY>
			<TR>
				<TD align="right" class="TableHeading" width="130">�I�ڤ�G</TD>
				<TD>
					<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateC" name="txtPDateC" value="" readOnly onBlur="checkClientField(this,true);">
					<a href="javascript:show_calendar('frmMain.txtPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
						<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��">
					</a>
					<INPUT type="hidden" name="txtPDate" id="txtPDate" value="">
				</TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">�O����O�G</TD>
				<TD valign="middle">
					<select size="1" name="selCurrency" id="selCurrency">
						<%=sbCurrCash.toString()%>
					</select>
				</TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">���B�G</TD>
				<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtAMT" name="txtAMT" VALUE=""></TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">���ڤH�m�W�G</TD>
				<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtNAME" name="txtNAME" VALUE=""></TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">�h�פ覡�G</TD>
				<TD>
					<select size="1" name="selFEESHOW" id="selFEESHOW" onChange="showDArea();">
						<option value=""></option>
						<option value="NT">�x���h��</option>
						<option value="US">�~���h��</option>
						<option value="C">�H�Υd�h�^</option>
					</select>
				</TD>
			</TR>
			<TR>
				<TD align="right" class="TableHeading">�X�ǽT�{��G</TD>
				<TD><INPUT class="Data" size="11" type="text"
					maxlength="11" id="txtPCSHCMC" name="txtPCSHCMC" value="" readOnly
					onblur="checkClientField(this,true);"> <a
					href="javascript:show_calendar('frmMain.txtPCSHCMC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
					src="<%=request.getContextPath()%>/images/misc/show-calendar.gif"
					alt="�d��"></a> <INPUT type="hidden" name="txtPCSHCM" id="txtPCSHCM"
					value=""></TD>
			</TR>
		</TBODY>
	</TABLE>
<!-- R70477  -->
	<TABLE border="1" width="400" id=inquiryAreaA style='display: none'>
		<TR>
			<TD align="right" class="TableHeading" width="130">�I�ڱb���G</TD>
			<TD>
				<select size="1" name="selPBBank" id="selPBBank">
					<%=sbPBBank.toString()%>
				</select>
				<INPUT type="hidden" name="txtPBBank" id="txtPBBank" value=""> 
				<INPUT type="hidden" name="txtPBAccount" id="txtPBAccount" value="">
			</TD>
		</TR>
	</TABLE>
<!--R80211 �[�J�h�פ��-->
	<TABLE border="1" width="400" id=inquiryAreaC>
		<TR>
			<TD align="right" class="TableHeading" width="130">�Ȧ�h�צ^�s����G</TD>
			<TD>
				<INPUT type="text" class="Data" id="txtBRDateC" name="txtBRDateC" size="11" maxlength="11" value="" readOnly>
				<a href="javascript:show_calendar('frmMain.txtBRDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
					<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��">
				</a>
				<INPUT type="hidden" id="txtBRDate" name="txtBRDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">����h�פ���G</TD>
			<TD>
				<INPUT type="text" class="Data" id="txtRDateC" name="txtRDateC" size="11" maxlength="11" value="" readOnly onBlur="checkClientField(this,true);">
				<INPUT type="hidden" id="txtRDate" name="txtRDate" value="">
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="400" id=inquiryAreaB style='display: none'>
		<TR>
			<TD align="right" class="TableHeading" width="130">�I�ڱb���G</TD>
			<TD>
				<select size="1" name="selPBBankD" id="selPBBankD">
					<%=sbPBBankD.toString()%>
				</select> 
				<INPUT type="hidden" name="txtPBBankD" id="txtPBBankD" value=""> 
				<INPUT type="hidden" name="txtPBAccountD" id="txtPBAccountD" value="">
			</TD>
		</TR>
	</TABLE>
<!-- R80338 -->
	<TABLE border="1" width="400" id=inquiryAreaD style='display: none'>
		<TR>
			<TD align="right" class="TableHeading" width="130">�I�ڱb���G</TD>
			<TD>
				<select size="1" name="selPBBankP" id="selPBBankP">
					<%=sbPBBankP.toString()%>
				</select> 
				<INPUT type="hidden" name="txtPBBankP" id="txtPBBankP" value=""> 
				<INPUT type="hidden" name="txtPBAccountP" id="txtPBAccountP" value="">
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="700" id="inquiryAreaE" style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="130">�Ȧ�h�צ^�s����G</TD>
			<TD colspan="5">
				<INPUT type="text" class="Data" id="txtBRFDateC" name="txtBRFDateC" size="11" maxlength="11" value="" readOnly>
				<INPUT type="hidden" id="txtBRFDate" name="txtBRFDate" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="130">����h�פ���G</TD>
			<TD>
				<INPUT type="text" class="Data" id="txtRFDateC" name="txtRFDateC" size="11" maxlength="11" value="" readOnly onBlur="checkClientField(this,true);">
				<INPUT type="hidden" id="txtRFDate" name="txtRFDate" value="">
			</TD>
			<TD align="right" class="TableHeading" width="100">�h�ץN�X�G</TD>
			<TD>
				<SELECT id="selRFCode" name="selRFCode" onChange="changeRFDesc(this);">
					<%=sbRemitFail.toString()%>
				</SELECT>
			</TD>
			<TD align="right" class="TableHeading" width="100">�h�׭�]�G</TD>
			<TD><INPUT type="text" id="txtRFDesc" name="txtRFDesc" value="" readonly="readonly"></TD>
		</TR>
	</TABLE>
	<BR>
<%//R60550
String strFEESHOW = "";
if (strFEECURR.equals("NT")) {
	strFEESHOW = "display:none";
} else {
	strFEESHOW = "display:block";
}
//R80391
String strBankShow = "";
String strCrdShow = "";
if (strWAYSHOW.equals("C")) {
	strBankShow = "display:none";
	strCrdShow = "display:block";
} else {
	strBankShow = "display:block";
	strCrdShow = "display:none";
}
if (alPDetail != null) {
	//if1			
	if (alPDetail.size() > 0) {
		//if2
		int icurrentRec = 0;
		int icurrentPage = 0; // ��0�}�l�p
		int iSeqNo = 0;
		for (int i = 0; i < itotalpage; i++) {
			icurrentPage = i;
			for (int j = 0; j < iPageSize; j++) {
				iSeqNo++;
				icurrentRec = icurrentPage * iPageSize + j;
				if (icurrentRec < alPDetail.size()) {
					if (j == 0) // show table head
					{
						if ((icurrentPage + 1) == 1) {%>
<div id="showPage<%=icurrentPage + 1%>" style="display: "><%} else {%>
<div id="showPage<%=icurrentPage + 1%>" style="display: none"><%}%>
	<table>
		<tr>
			<td><a href='javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage + 1%>,1)'>&lt;&lt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage + 1%>,2)'>&lt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=icurrentPage + 2%>,<%=itotalpage%>,<%=icurrentPage + 1%>,3)'>&gt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage + 1%>,4)'>&gt;&gt;&nbsp;&nbsp;</a></td>
		</tr>
	</table>
	<hr>
	<table border="0" cellPadding="0" cellSpacing="0" width="100%" id="tblDetail">
		<tbody>
			<TR>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="25"><b><font size="2" face="�ө���">�Ǹ�</font></b></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="25"><b><font size="2" face="�ө���">�Ŀ�</font></b></TD>
				<TD bgcolor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="100"><b><font size="2" face="�ө���">���ڤH�m�W</font></b></TD>
				<TD bgcolor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="50"><b><font size="2" face="�ө���">���ڤHID</font></b></TD>
				<!--r80391 �H�Υd-->
				<TD bgcolor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="50"><b><font size="2" face="�ө���">�״ڻȦ�</font></b></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="100"><font size="2" face="�ө���"><b>�״ڱb��</b></font></TD>
				<TD bgcolor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="50"><b><font size="2" face="�ө���">�I�ڻȦ�</font></b></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="139"><font size="2" face="�ө���"><b>�H�Υd�d��</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="61"><b><font size="2" face="�ө���">�I�ڤ��</font></b></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="142"><b><font size="2" face="�ө���">�I�ڪ��B</font></b></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="56"><font size="2" face="�ө���"><b>����O</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="56"><font size="2" face="�ө���"><b>�״ڧǸ�</b></font></TD>
				<!--r80391-->
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="56"><font size="2" face="�ө���"><b>�O�渹�X</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="90"><font size="2" face="�ө���"><b>�X�ֶ״ڪ��B</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="90"><font size="2" face="�ө���"><b>�~���״ڪ��B</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="45"><font size="2" face="�ө���"><b>�h�פ���O���O</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="115"><font size="2" face="�ө���"><b>�h�פ���O</b></font></TD>
				<TD bgColor="#c0c0c0"
					style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="56" width="45"><font size="2" face="�ө���"><b>�h�פ�I�覡</b></font></TD>
			</TR>
<%}
DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(icurrentRec);
String strPNo = "";
String strPName = "";
String strPId = "";
String strPRBank = "";
String strPRAccount = "";
double iPAmt = 0;
int iPDate = 0;
String strPDate = "";
int iPFee = 0;
String strRMTSEQ = "";
String strCurrency = "";
String strRFPAYCURR = ""; //R60550
String strSYMBOL = ""; //R60550
String opSel1 = ""; //R60550
String opSel2 = ""; //R60550
double iRPAYAMT = 0; //R60550
String strPFEEWAY = ""; //R70477
String strPBBank = ""; //r80391
String strPCrdNo = ""; //r80391
String strPONO = ""; //r80391
double iRAMT = 0; //R80391

if (objPDetailVO.getStrPNO() != null)
	strPNo = objPDetailVO.getStrPNO();
if (strPNo != "")
	strPNo = strPNo.trim();

if (objPDetailVO.getStrPName() != null)
	strPName = objPDetailVO.getStrPName();
if (strPName != "")
	strPName = strPName.trim();

if (objPDetailVO.getStrPId() != null)
	strPId = objPDetailVO.getStrPId();
if (strPId != "")
	strPId = strPId.trim();

if (objPDetailVO.getStrPCurr() != null)
	strCurrency = objPDetailVO.getStrPCurr();
if (strCurrency != "")
	strCurrency = strCurrency.trim();

if (objPDetailVO.getStrPRBank() != null)
	strPRBank = objPDetailVO.getStrPRBank();
if (strPRBank != "")
	strPRBank = strPRBank.trim();

if (objPDetailVO.getStrPRAccount() != null)
	strPRAccount = objPDetailVO.getStrPRAccount();
if (strPRAccount != "")
	strPRAccount = strPRAccount.trim();
iPFee = objPDetailVO.getIRmtFee();
iPAmt = objPDetailVO.getIPAMT();
iPDate = objPDetailVO.getIPDate();

if (iPDate == 0)
	strPDate = "";
else {
	strPDate = Integer.toString(iPDate);
	//R00231 edit by Leo Huang 
	strPDate = new CommonUtil().checkDateFomat(strPDate);
}
strRMTSEQ = objPDetailVO.getStrBATSEQ();
if (strRMTSEQ != "")
	strRMTSEQ = strRMTSEQ.trim();
//R60550
iRPAYAMT = objPDetailVO.getIPPAYAMT();
strRFPAYCURR = objPDetailVO.getStrPPAYCURR();
if (strRFPAYCURR != "")
	strRFPAYCURR = strRFPAYCURR.trim();
if(strRFPAYCURR.equals(""))
	strRFPAYCURR = "&nbsp;";


strSYMBOL = objPDetailVO.getStrPSYMBOL();
if (strSYMBOL.equals("S"))
	opSel1 = "selected";
else
	opSel2 = "selected";
// R70477 	
strPFEEWAY = objPDetailVO.getStrPFEEWAY();
if (strSYMBOL.equals("D") && strPFEEWAY.equals("BEN"))
	opSel1 = "selected";
if (strSYMBOL.equals("D") && strPFEEWAY.equals("OUR"))
	opSel2 = "selected";
//R80391 �s�W4����� 	
if (objPDetailVO.getStrPBBank() != null)
	strPBBank = objPDetailVO.getStrPBBank();
if (strPBBank != "")
	strPBBank = strPBBank.trim();

if (objPDetailVO.getStrPCrdNo() != null)
	strPCrdNo = objPDetailVO.getStrPCrdNo();
if (strPCrdNo != "")
	strPCrdNo = strPCrdNo.trim();

if (objPDetailVO.getStrPolicyNo() != null)
	strPONO = objPDetailVO.getStrPolicyNo();
if (strPONO != "")
	strPONO = strPONO.trim();
iRAMT = objPDetailVO.getIRAMT();%>

			<TR id=data>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="25"><span onClick="seqClicked('<%=strPNo%>')"
					style="cursor: hand"><%=icurrentRec + 1%></span></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="25"><INPUT type="checkbox"
					name="ch<%=icurrentRec%>" id="ch<%=icurrentRec%>" value="Y"> <INPUT
					name="txtPNo<%=icurrentRec%>" id="txtPNo<%=icurrentRec%>"
					type="hidden" value="<%=strPNo%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="157"><%=strPName%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="65"><%=strPId%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="65"><%=strPRBank%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="139"><%=strPRAccount%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="65"><%=strPBBank%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="139"><%=strPCrdNo%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="61"><%=strPDate%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="142"><%=strCurrency%>$<%=df.format(iPAmt)%>&nbsp;
				<INPUT name="txtPAMT<%=icurrentRec%>" id="txtPAMT<%=icurrentRec%>"
					type="hidden" value="<%=iPAmt%>"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="56"><%=iPFee%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="56"><%=strRMTSEQ%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="56"><%=strPONO%>&nbsp;</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="90"><%=df.format(iRAMT)%></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="90"><%=df2.format(iRPAYAMT)%></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="45"><%=strRFPAYCURR%></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="115"><INPUT class="Data" size="3" type="text"
					maxlength="16" id="txtFEEAMT<%=icurrentRec%>"
					name="txtFEEAMT<%=icurrentRec%>" VALUE="0"></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
					height="35" width="45"><select size="1"
					name="selFEEWAY<%=icurrentRec%>" id="selFEEWAY<%=icurrentRec%>">
					<option value="BEN" <%=opSel1%>>BEN</option>
					<option value="OUR" <%=opSel2%>>OUR</option>
				</select></TD>
			</TR>
		<%if ((iSeqNo == iPageSize)
	|| (icurrentRec == (alPDetail.size() - 1))
	|| (iSeqNo % iPageSize == 0)) {%>
		</tbody>
	</table>
</div>
<%}
} // end of if --> inowRec < alPDetail.size()
} // end of for -- show detail      
} //end of for%> 
	<input name="allbox" type="checkbox" onClick="CheckAll();"> �`���� : <%=itotalpage%> &nbsp;&nbsp;�`��� : <%=itotalCount%>&nbsp;&nbsp;&nbsp;&nbsp;�`���B:<%=df.format(iSumAmt)%> 
<%} //end of if2 
} //end of if1%>
	<INPUT type="hidden" id="txtPNo" name="txtPNo" value=""> 
	<INPUT type="hidden" id="txtTpage" name="txtTpage" value="<%=itotalpage%>"> 
	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
	<INPUT type="hidden" id="txtFEECURR" name="txtFEECURR" value="<%=strFEECURR%>"><!--R60550--> 
	<INPUT type="hidden" id="txtWAYSHOW" name="txtWAYSHOW" value="<%=strWAYSHOW%>"><!--R60550-->
</FORM>
</BODY>
</HTML>
