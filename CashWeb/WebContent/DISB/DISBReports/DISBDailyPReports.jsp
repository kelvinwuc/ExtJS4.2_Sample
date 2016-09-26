<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : �C��I�ک��ӳ���
 * 
 * Remark   : �C���I���Ӫ�а]��                �GDISBDailyPDetailsByFin.rpt
 *            �C���I���Ӫ�а]�� (ĵ��)�GDISBDailyPDetailsByFinA.rpt
 *            �C��I���`��                                    �GDISBDailyToFin.rpt (BATCH�@�~)
 *                                       DISBDailyToFin_ONLINE.rpt (�u�W�@�~)
 *            �C��I���`��(����)        �GDISBDailyToFinForCE.rpt
 *            �C���b��(�d�s��)        �GDISBDaily.rpt
 *            �C���b�� (�d�s��)����          �GDISBDailyForCE.rpt
 *            �C��I�ک��Ӫ�                                �GDISBDailyPDetails.rpt
 * 
 * Revision : $Revision: 1.34 $
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $Date: 2014/10/31 02:46:32 $
 * 
 * Request ID : R10231
 * 
 * CVS History:
 * 
 * $Log: DISBDailyPReports.jsp,v $
 * Revision 1.34  2014/10/31 02:46:32  misariel
 * RC0036-�s�W�����q��F�H���ϥ�CAPSIL�ܧ��v������
 *
 * Revision 1.32  2014/03/31 03:18:26  misariel
 * R80734-�s�W��I�N�XBI
 *
 * Revision 1.31  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.30  2013/06/13 09:58:24  MISSALLY
 * EB0097-�t�XCMP�ק�C��I���`��������W�[����yUser�T�{��z<=�e�����y��J����z
 *
 * Revision 1.29  2013/01/09 03:25:00  MISSALLY
 * Calendar problem
 *
 * Revision 1.28  2013/01/08 04:25:56  MISSALLY
 * �N���䪺�{��Merge��HEAD
 *
 * Revision 1.26.4.3  2012/12/06 06:28:24  MISSALLY
 * RA0102�@PA0041
 * �t�X�k�O�ק�S����I�@�~
 *
 * Revision 1.26.4.2  2012/10/31 06:07:24  MISSALLY
 * EA0152 --- VFL PHASE 4
 *
 * Revision 1.26.4.1  2012/09/06 09:21:12  MISSALLY
 * QA0295---�ץ�ĵ�ܳ����ഫ�ƭȫ��A��Function
 *
 * Revision 1.26  2012/05/24 06:53:26  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�-��������O��I�覡�ˮ֧P�_
 *
 * Revision 1.25  2012/05/24 03:03:22  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�-�����P�N�ѧP�_
 *
 * Revision 1.24  2012/05/23 01:21:44  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�-�ץ��z�ߥI�ڪ��B���P�_
 *
 * Revision 1.23  2012/05/22 02:45:01  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�-�ץ��z�ߥI�ڪ��B���P�_
 *
 * Revision 1.22  2012/05/21 04:34:32  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�-�ץ��z�ߥI�ڪ��B���P�_
 *
 * Revision 1.21  2012/05/18 09:49:52  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�
 *
 * Revision 1.20  2011/10/21 10:04:35  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 *
 *
 */
%><%!String strThisProgId = "DISBDailyPReports"; //���{���N��%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserRight")):"";
String strUserBrch = (session.getAttribute("LogonUserBrch") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserBrch")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserId")):"";

CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar  =commonUtil.getBizDateByRCalendar();
int iCurrentDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(calendar.getTime()));

//Q80432 XFILE�ˬd		
Vector XPol = (Vector)request.getAttribute("XPol");

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alCurrCash = new ArrayList(); //R80132 ���O�D��
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
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
%>
<HTML>
<HEAD>
<TITLE>�C��I�ک��ӳ���</TITLE>
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
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title, '', '', '' );
	// R80244  if(document.getElementById("txtUserDept").value != "FIN" && document.getElementById("txtUserRight").value >= "99")
	if(document.getElementById("txtUserDept").value != "FIN" && document.getElementById("txtUserDept").value != "ACCT" && document.getElementById("txtUserRight").value >= "99")
	{
		alert("�L���榹�����v��");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else
	{
		document.getElementById("FormArea").style.display ="block";
		document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";//Q80432

		if(document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT" )//R80244
		{
			document.getElementById("FinArea").style.display ="block";
			document.getElementById("inquiryArea").style.display ="none";
			document.getElementById("BatchArea").style.display ="none";
		}
		else
		{
			if(document.getElementById("txtUserRight").value > "79" && document.getElementById("txtUserRight").value <= "89")
			{	//Q80432�ˬd�O�_XFILE
				if(document.getElementById("txtAction").value != "returnXPOL" && document.getElementById("txtUserDept").value == "CSC")
				{
					document.frmMain.action = "<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBDailyPRServlet?action=query";
					document.frmMain.submit();
				}
				else
				{
					document.getElementById("inquiryArea").style.display ="block";
					document.getElementById("FinArea").style.display ="none";
					document.frmMain.rdReportType[0].checked = true;
					document.getElementById("BatchArea").style.display ="block";
				}
			}
			else
			{
				document.getElementById("inquiryArea").style.display ="none";
				document.getElementById("FinArea").style.display ="none";
				document.frmMain.rdReportType[1].checked = true;
				document.getElementById("BatchArea").style.display ="none";
			}
		}
	}
	window.status = "";
}

/*
��ƦW��:	printRAction()
��ƥ\��:	��toolbar frame ����������s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function printRAction()
{
	window.status = "";

	document.getElementById("txtAction").value = "L";

	WindowOnLoadCommon( document.title , '' , 'E','' );

	document.getElementById("FormArea").style.display ="none";
	document.getElementById("inquiryArea").style.display ="none";
	document.getElementById("FinArea").style.display ="none";
	document.getElementById("BatchArea").style.display ="none";
	document.getElementById("btnPrint").style.display ="none";

	//FIN
	if(document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT")  // R80244
	{	//�C��I�ک��Ӫ�(�]��) / ĵ��
		getReportInfoByFin();
		if (document.frmMain.rdReportForm[0].checked)
		{
			document.frmMain2.OutputType.value = "PDF";
			document.frmMain2.OutputFileName.value = "DISBDailyPDetailsByFin.pdf";
			document.frmMain3.OutputType.value = "PDF";
			document.frmMain3.OutputFileName.value = "DISBDailyPDetailsByFinA.pdf";
		}
		else
		{
			document.frmMain2.OutputType.value = "TXT";
			document.frmMain2.OutputFileName.value = "DISBDailyPDetailsByFin.rpt";
			document.frmMain3.OutputType.value = "TXT";
			document.frmMain3.OutputFileName.value = "DISBDailyPDetailsByFinA.rpt";
		}
		document.getElementById("frmMain2").target="_blank";
		document.getElementById("frmMain2").submit();
		document.getElementById("frmMain3").target="_blank";
		document.getElementById("frmMain3").submit();
	}
	else if(document.getElementById("txtUserRight").value >= "89" && document.getElementById("txtUserRight").value < "99")
	{
		if(document.frmMain.rdReportType[0].checked)
		{
			getReportInfo89();
			if(document.frmMain.rdReportType[0].checked)
			{	//�C��I���`��ΨC��I�ک��Ӫ�(�d�s) / ����
				//window.open('<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyPConfirm.jsp?sql='+ document.frmMain.ReportSQL.value,'�C��I���`��','top=0,left=0,scrollbars=1,resizable=yes,width=650,height=350');
				//RC0036
				document.getElementById("frmMain").action = '<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyPConfirm.jsp' ;
				document.getElementById("frmMain").target="_blank";
				document.getElementById("frmMain1").target="_blank";
				document.getElementById("frmMain4").target="_blank";
				document.getElementById("frmMain5").target="_blank";
				if (checkXFILE()) 
				{  //Q80432
					document.getElementById("frmMain").submit();
					if(document.frmMain.rdFromBatch[0].checked)
					{
						document.getElementById("frmMain1").submit();
						document.getElementById("frmMain4").submit();
						document.getElementById("frmMain5").submit();
					}
				}
			} else {//�C��I���`��
				document.getElementById("frmMain").target="_blank";
				document.getElementById("frmMain").submit();
			}
		}
		else if(document.frmMain.rdReportType[1].checked)
		{	//�C��I�ک��Ӫ�
			getReportInfo89forDetails();
			document.getElementById("frmMain").target="_blank";
			document.getElementById("frmMain").submit();
		}
		else
		{	//RB0302�zڦ�����Ӫ� for POS
			getReportInfoByClamforPOS();
			document.getElementById("frmMain").target="_blank";
			document.getElementById("frmMain").submit();
		}
	}
	else
	{	//�C��I�ک��Ӫ�
		getReportInfo79();
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
	}
}

/*
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBDailyPReports.jsp";
}

function getReportInfo89()
{
	var strBatchSql = "";
	var strBatchCEsql = "";//R90624
	var strForm = "";

	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain1.OutputType.value = "PDF";
		document.frmMain4.OutputType.value = "PDF";
		document.frmMain5.OutputType.value = "PDF";
		strForm = ".pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain1.OutputType.value = "TXT";
		strForm = ".rpt";
	}

	if(document.frmMain.rdDISPATCH[0].checked) {
		document.frmMain.para_DISPATCH.value ="Y";
	} else {
		document.frmMain.para_DISPATCH.value ="";
	}

	if(document.frmMain.rdReportType[0].checked)
	{
		if(document.frmMain.rdFromBatch[0].checked)
		{
			document.frmMain.ReportName.value = "DISBDailyToFin.rpt";
			document.frmMain.OutputFileName.value = "DISBDailyToFin" + strForm;
			document.frmMain1.ReportName.value = "DISBDaily.rpt";
			document.frmMain1.OutputFileName.value = "DISBDaily" + strForm;

			document.frmMain4.ReportName.value = "DISBDailyToFinForCE.rpt";
			document.frmMain4.OutputFileName.value = "DISBDailyToFinForCE" + strForm;
			document.frmMain5.ReportName.value = "DISBDailyForCE.rpt";
			document.frmMain5.OutputFileName.value = "DISBDailyForCE" + strForm;

			document.frmMain.para_FromBatch.value='Y';
			document.frmMain1.para_FromBatch.value='Y';      
			document.frmMain4.para_FromBatch.value='Y';//@R90624
			document.frmMain5.para_FromBatch.value='Y';//@R90624
			//strBatchSql = " AND A.PAY_SOURCE_CODE in ('B1','B2','B3','B4','B5','B6','B7','B8','B9','BA')"//R70088�t�� @R70455�[�J'B9'  @Q00014�����Ѭ�
			//strBatchSql = " AND A.PAY_SOURCE_CODE in ('B1','B2','B3','B4','B5','B6','B7','B8','B9','BB','BA')";//R00440�������@�~
            strBatchSql = " AND A.PAY_SOURCE_CODE in (<%=Constant.Batch_PAY_SRCCODE%>) ";
			strBatchCEsql = " AND A.PAY_SOURCE_CODE = 'CE' ";//@R90624���� CE
		}
		else
		{
			document.frmMain.ReportName.value = "DISBDailyToFin_ONLINE.rpt";
			document.frmMain.OutputFileName.value = "DISBDailyToFin_ONLINE" + strForm;
			document.frmMain.para_FromBatch.value='N';
			document.frmMain1.para_FromBatch.value='N';
			//strBatchSql = " AND A.PAY_SOURCE_CODE NOT in ('B1','B2','B3','B4','B5','B6','B7','B8','B9','CE','BA')"//R70088�t�� @R70088�t�� R70455�[�J'B9' @R90624 �[�J ���� @Q00014�����Ѭ�\
			//strBatchSql = " AND A.PAY_SOURCE_CODE NOT in ('B1','B2','B3','B4','B5','B6','B7','B8','B9','BB','BA','CE')";//R00440 �������@�~
         	strBatchSql = " AND A.PAY_SOURCE_CODE NOT in (<%=Constant.Batch_PAY_SRCCODE%>,'CE') ";
		}
	}

	mapValue();

	//�`��
	var strSql = "";
	strSql = "SELECT A.*,B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM,B.USRBRCH AS USRBRCH,B.USRAREA AS USRAREA,E.FLD0004,F.FLD0004 ";
	strSql += " from CAPPAYF A ";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C on C.BKNO=A.PRBANK ";
	//RC0036
	strSql += "left outer join ORDUET E on E.FLD0002 = 'DEPT' AND E.FLD0003 = B.DEPT ";
	strSql += "left outer join ORDUET F on F.FLD0002 = 'DEPT' AND F.FLD0003 = B.USRAREA ";
	if (document.getElementById("txtUserDept").value == "CSC")
		strSql += " WHERE B.DEPT IN ('CSC','PCD','TYB','TCB','TNB','KHB') ";
	else
		strSql += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
		
	if (document.getElementById("txtUserBrch").value != "")
		strSql += " AND B.USRBRCH='"+ document.getElementById("txtUserBrch").value +"'  ";
		
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>''  ";
    strSql += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2='' and PAY_AMOUNT > 0 "; 
    strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";

	//EB0097 �۰ʽT�{�|�a���Ӥ�
	if(document.frmMain.rdFromBatch[1].checked && (document.getElementById("txtUserDept").value == "CSC"
											       || document.getElementById("txtUserDept").value =='PCD'
												   || document.getElementById("txtUserDept").value =='TYB'
												   || document.getElementById("txtUserDept").value =='TCB'
												   || document.getElementById("txtUserDept").value =='TNB'
												   || document.getElementById("txtUserDept").value =='KHB')) {
		strSql += " AND A.PAY_CONFIRM_DATE1 <= " + document.getElementById("txtEntryDate").value;
	}

	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value !="") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"' ";
	}
	//R61220
	if(document.frmMain.rdReportType[0].checked && document.frmMain.rdFromBatch[0].checked)
	{
		if(document.frmMain.rdMethod[1].checked) {
			strSql += " AND A.PMETHOD = 'A' ";
		}
		if (document.frmMain.rdMethod[2].checked) {
			strSql += " AND A.PMETHOD <> 'A' ";
		}
	}
	//R90624
	document.frmMain.ReportSQL.value = strSql+strBatchSql+" ORDER BY A.ENTRY_USER,A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";//R70088�ק�ƧǷs�WMETHOD,PAYCURR;
	document.frmMain4.ReportSQL.value = strSql+strBatchCEsql+" ORDER BY A.ENTRY_USER,A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";//R90624

	//��b��
	var strSql1= "";
	strSql1= "SELECT A.*,B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,C.BKNM ";
	strSql1 += " from CAPPAYF A ";
	strSql1 += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql1 += "  left outer join CAPCCBF C on C.BKNO=A.PRBANK   ";
	strSql1 += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
	//R10260 �ѩ�״ڸ�Ƥ�������Ʒ|�g�J��I�ɡA�G�����ѵ�User����follow up
	//R10260 strSql1 += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_TIME1 <>0 AND A.PAY_CONFIRM_USER1<>''  ";
	strSql1 += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2=''"; //R70088 and A.PAY_METHOD <> 'A' "; 
	strSql1 += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";

	if(document.getElementById("txtEntryDate").value !="") {
		strSql1 += " AND A.ENTRY_DATE = " + document.getElementById("txtEntryDate").value;
	}
	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql1 += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql1 += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value !="") {
		strSql1+= " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"'";
	}

//R80734	document.frmMain1.ReportSQL.value = strSql1+ strBatchSql+" AND ((A.PAY_METHOD IN ('B','C','D')) OR (A.PAY_METHOD = 'A' AND A.PAY_SOURCE_CODE IN ('B8','B9','BB'))) ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO";//R00440-SN�������@�~
/*R80734*/
	document.frmMain1.ReportSQL.value = strSql1+ strBatchSql+" AND ((A.PAY_METHOD IN ('B','C','D')) OR (A.PAY_METHOD = 'A' AND A.PAY_SOURCE_CODE IN ('B8','B9','BB','BI'))) ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO";//R00440-SN�������@�~
   	document.frmMain5.ReportSQL.value = strSql1+" AND A.PAY_METHOD IN  ('B','C','D')  AND A.PAY_SOURCE_CODE = 'CE' ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO";//R90624
}

function getReportInfo89forDetails()
{
	if(document.frmMain.rdDISPATCH[0].checked) {//R70088 BUGFIX
		document.frmMain.para_DISPATCH.value = "Y";
	} else {
		document.frmMain.para_DISPATCH.value ="";
	}

	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DISBDailyPDetails.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain.OutputFileName.value = "DISBDailyPDetails.rpt";
	}

	//���Ӫ�
	var strSql = "";
	strSql = "SELECT A.* ";
	strSql += ",B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM,B.USRAREA AS USRAREA ";
	strSql += " from CAPPAYF A";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C  on C.BKNO=A.PRBANK   ";
	//strSql += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";
	if (document.getElementById("txtUserDept").value == "CSC")
		strSql += " WHERE B.DEPT IN ('CSC','PCD','TYB','TCB','TNB','KHB') ";
	else
		strSql += " WHERE B.DEPT='"+ document.getElementById("txtUserDept").value +"'  ";	
	if (document.getElementById("txtUserBrch").value != "")
		strSql += " AND B.USRBRCH='"+ document.getElementById("txtUserBrch").value +"'  ";
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>''";
	strSql += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2=''  ";
	strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";

	if(document.getElementById("txtEntryDate").value !="") {
		strSql += " AND A.ENTRY_DATE = " + document.getElementById("txtEntryDate").value;
		//EB0097 �۰ʽT�{�|�a���Ӥ�
		if(document.getElementById("txtUserDept").value == "CSC") {
			strSql += " AND A.PAY_CONFIRM_DATE1 <= " + document.getElementById("txtEntryDate").value;
		}
	}
	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value !="") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"'";
	}

	strSql += " ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";

	document.getElementById("ReportSQL").value = strSql;
}

function getReportInfoByClamforPOS()
{
	document.frmMain.para_DISPATCH.value = "Y";
	document.frmMain.ReportName.value = "DISBDailyPDetailsByClm4POS.rpt";

	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DISBDailyPDetailsByClm4POS.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain.OutputFileName.value = "DISBDailyPDetailsByClm4POS.rpt";
	}

	//���Ӫ�
	var strSql = "";
	strSql = "SELECT A.* ";
	strSql += ",B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM ";
	strSql += " from CAPPAYF A";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C  on C.BKNO=A.PRBANK   ";
	strSql += " WHERE B.DEPT='CLM'  ";
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>''";
	strSql += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2=''  ";
	strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";
	strSql += " AND PAY_DISPATCH='Y' ";

	if(document.getElementById("txtEntryDate").value !="") {
		strSql += " AND A.ENTRY_DATE = " + document.getElementById("txtEntryDate").value;
	}
	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value !="") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"'";
	}

	strSql += " ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";

	document.getElementById("ReportSQL").value = strSql;
}

function getReportInfo79()
{
	if(document.frmMain.rdDISPATCH[0].checked) {
		document.frmMain.para_DISPATCH.value = "Y";
	} else {
		document.frmMain.para_DISPATCH.value = "";
	}

	if(document.frmMain.rdReportForm[0].checked) 
	{
		document.frmMain.OutputType.value = "PDF";
		document.frmMain.OutputFileName.value = "DISBDailyPDetails.pdf";
	}
	else
	{
		document.frmMain.OutputType.value = "TXT";
		document.frmMain.OutputFileName.value = "DISBDailyPDetails.rpt";
	}

	//�u��d�ۤv�ҿ�J�����
	var strSql = "";
	strSql = "SELECT A.* ";		
	strSql += ",B.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM,B.USRAREA AS USRAREA ";		
	strSql += " from CAPPAYF A";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C  on C.BKNO=A.PRBANK   ";
	strSql += " WHERE  A.ENTRY_USER= '" + document.getElementById("txtUserId").value  + "'";
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>''";
	strSql += " AND A.PAY_CONFIRM_DATE2 =0 AND A.PAY_CONFIRM_USER2=''  "; 
	strSql += " AND A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 ";

	if(document.getElementById("txtEntryDate").value !="") {
		strSql += " AND A.ENTRY_DATE = " + document.getElementById("txtEntryDate").value;
		//EB0097 �۰ʽT�{�|�a���Ӥ�
		if(document.getElementById("txtUserDept").value == "CSC") {
			strSql += " AND A.PAY_CONFIRM_DATE1 <= " + document.getElementById("txtEntryDate").value;
		}
	}

	if(document.frmMain.rdDISPATCH[0].checked) {
		strSql += " AND PAY_DISPATCH='Y' ";
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}

	if(document.getElementById("para_Currency").value !="") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"'";
	}

	strSql += " ORDER BY A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";

	document.getElementById("ReportSQL").value = strSql;
}

function getReportInfoByFin()
{
	mapValue();

	var strSql = "";
	// FIN �i�d�Ҧ���I���
	strSql = "SELECT A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,A.PAY_DISPATCH,A.PAY_CHECK_M1,A.PAY_CHECK_M2,A.POLICY_NO,A.APPNO,";
	//R10314
//	strSql += "CASE WHEN A.ENTRY_USER LIKE 'BATCH%' THEN A.ENTRY_USER ELSE '��J��' END AS isBatch,A.ENTRY_USER,A.PAY_SOURCE_CODE, d.CLMNO, d.ClmCase, SUM(d.CLMKAMT) AS CLMKAMT,";
	strSql += "CASE WHEN A.ENTRY_USER LIKE 'BATCH%' THEN A.ENTRY_USER ELSE '��J��' END AS isBatch,A.ENTRY_USER,A.PAY_SOURCE_CODE,IFNULL(d.CLMNO,'') as CLMNO,IFNULL(d.SUM1_AMT,0) as SUM1_AMT,IFNULL(d.SUM2_AMT,0) as SUM2_AMT,";
	strSql += "DEC(substr(et.FLD0004,1,10)) as caseAmt1, DEC(substr(et.FLD0004,11,10)) as caseAmt2,";

	strSql += "A.PAY_CONFIRM_DATE2,A.PDESC,A.PAY_SRC_NAME,C.BKNM,A.PAY_CURRENCY";
	strSql += ",'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,B.DEPT AS USERDEPT";
	strSql += ",A.PAY_PLAN_TYPE";
	strSql += ",CASE WHEN F.FLD0004 IS NULL THEN SUBSTR(E.FLD0004,1,3) "; 
	strSql += " WHEN SUBSTR(E.FLD0004,1,3) = 'BEN' OR SUBSTR(E.FLD0004,1,3) = 'SHA' THEN 'OUR' END AS SYS_FEEWAY ";
	strSql += ",A.PAY_PAYCURR,A.PAY_PAYAMT,A.PAY_PAYRATE,A.PAY_FEEWAY,A.PAY_SYMBOL,A.PAY_INV_DATE,A.PENGNAME  ";//R60550
	strSql += ",A.PMETHODO,A.PSRCGP  ";//R80631
	strSql += ",A.ENTRY_DATE,A.PAY_AMOUNT_NT,A.PAY_CASH_DATE,B.USRAREA AS USRAREA  ";//R80132   	    
	strSql += " from CAPPAYF A ";
	strSql += "  left outer join USER B  on B.USRID=A.ENTRY_USER   ";
	strSql += "  left outer join CAPCCBF C  on C.BKNO=A.PRBANK   ";
	strSql += "  LEFT JOIN ORDUET E ON E.FLD0002 = 'PAYCD' AND E.FLD0003 = A.PSRCCODE ";
	strSql += "  LEFT JOIN ORDUET F ON E.FLD0002 = 'BANFR' AND F.FLD0003 = SUBSTR(A.PAY_CURRENCY,1,2) || SUBSTR(A.PAY_BUDGET_BANK,1,3) ";
	//R10314
	strSql += " LEFT JOIN ORDUET et ON et.FLD0001='  ' and et.FLD0002='CLAMQ' and et.FLD0003=A.PCURR ";
	strSql += " LEFT JOIN (SELECT G.clmno, SUM (CASE WHEN G.ClmCase = '1' THEN G.CLMKAMT  ELSE 0 END) AS SUM1_AMT, SUM (CASE WHEN G.ClmCase = '2' THEN G.CLMKAMT  ELSE 0 END) AS SUM2_AMT ";
	strSql += " FROM ( select  clmno,CRIDER,CASE WHEN substr(CLMCODE,6,2) IN ('-7','-8','-9') or substr(ETABCLMNO,1,3) IN ('AC0','AC1','AC2','AC3','AC4','CC1','CC2','CC3','CC4','CL1','CL2','CL3','CL4','C10','C11','C12','HCB','HCR','NCB','NCR','NC1','NC2','NC3','NC4','SC1','SC2','SC3','SC4') THEN '1' ELSE '2' END as ClmCase,SUM(CLMKAMT) as CLMKAMT ";
	strSql += " from clamcd where substr(CLMCODE,6,1)<>'*' and CRIDER<>'' group by clmno,CRIDER,CLMCODE,ETABCLMNO ) G group by G.clmno ";
	strSql += "  ) d ON a.policyno=A.POLICYNO and d.CLMNO=A.PCLMNUM AND A.PSRCCODE='D1' ";

	//strSql += " WHERE  A.PAY_VOIDABLE='' AND A.PAY_AMOUNT <> 0 "; RA0102
	strSql += " WHERE A.PAY_AMOUNT <> 0 ";	//RA0102
	strSql += " AND A.PAY_CONFIRM_DATE1 <>0 AND A.PAY_CONFIRM_USER1<>'' ";
	strSql += " AND A.PAY_CONFIRM_DATE2 =" + document.getElementById("para_PConDate").value + " ";

	if(document.frmMain.rdDISPATCH[0].checked) {
		//strSql += " AND PAY_DISPATCH='Y' AND A.PAY_CASH_DATE =0 ";R10314
		strSql += " AND PAY_DISPATCH='Y'  ";//R10314
	} else {
		strSql += " AND PAY_DISPATCH='' ";
	}
	if(document.getElementById("para_Currency").value != "") {
		strSql += " AND PAY_CURRENCY = '"+ document.getElementById("para_Currency").value +"' ";
	}

	strSql += "GROUP BY A.PAY_NO,A.PAY_NAME,A.PAY_METHOD,A.PAY_DATE,A.PAY_AMOUNT,";
	strSql += "A.PAY_DISPATCH,A.PAY_CHECK_M1,A.PAY_CHECK_M2,A.POLICY_NO,A.APPNO,"; 
	strSql += "A.ENTRY_USER,A.ENTRY_USER,A.PAY_SOURCE_CODE,d.CLMNO,d.SUM1_AMT,d.SUM2_AMT,";      
	strSql += "et.FLD0004,A.PAY_CONFIRM_DATE2,A.PDESC,A.PAY_SRC_NAME,C.BKNM,";      
	strSql += "A.PAY_CURRENCY,B.DEPT,A.PAY_PLAN_TYPE,F.FLD0004,E.FLD0004,";          
	strSql += "A.PAY_PAYCURR,A.PAY_PAYAMT,A.PAY_PAYRATE,A.PAY_FEEWAY,";              
	strSql += "A.PAY_SYMBOL,A.PAY_INV_DATE,A.PENGNAME,A.PMETHODO,A.PSRCGP,";         
	strSql += "A.ENTRY_DATE,A.PAY_AMOUNT_NT,A.PAY_CASH_DATE,USRAREA ";                                       
	strSql += " ORDER BY A.ENTRY_USER,A.PAY_METHOD, A.PAY_PAYCURR,A.POLICY_NO ";//R70600

	document.frmMain2.ReportSQL.value = strSql;
	document.frmMain2.para_PConDate.value = document.getElementById("para_PConDate").value;
	document.frmMain2.para_Currency.value = document.getElementById("para_Currency").value;

	document.frmMain3.ReportSQL.value = strSql;  //R70600
	document.frmMain3.para_PConDate.value = document.getElementById("para_PConDate").value ;  //R70600
	document.frmMain3.para_Currency.value = document.getElementById("para_Currency").value ;  //R70600
}

function mapValue()
{
	if(document.getElementById("txtPConfirmDateC").value !="") {
		document.getElementById("para_PConDate").value = rocDate2String(document.getElementById("txtPConfirmDateC").value);
	}
	if(document.getElementById("txtEntryDateC").value !="") {
		document.getElementById("txtEntryDate").value = rocDate2String(document.getElementById("txtEntryDateC").value) ;
		document.getElementById("para_EntryDate").value = rocDate2String(document.getElementById("txtEntryDateC").value) ;		
	}
	if(document.getElementById("txtPDateC").value !="") {
		document.getElementById("para_PDate").value = rocDate2String(document.getElementById("txtPDateC").value) ;		
	}
}

function enableBatchArea()
{
   document.getElementById("BatchArea").style.display ="block";
}
function disableBatchArea()
{
   document.getElementById("BatchArea").style.display ="none";
   <% if(strUserDept.equals("CSC") && strUserRight.equals("89")) { %>
	if(document.frmMain.rdReportType[2].checked) {
		document.frmMain.rdDISPATCH[0].checked = true;
	}
   <% } %>
}
function enablePDateArea()
{
   document.getElementById("PDateArea").style.display ="block";
   document.getElementById("PDateMethod").style.display ="block";//R61220
}
function disablePDateArea()
{
   document.getElementById("PDateArea").style.display ="none";
   document.getElementById("PDateMethod").style.display ="none";//R61220
}

//Q80432 �ˬd�O�_��X-FILE
function checkXFILE()
{	
	var rtnVal = true;
	var strTmpMsg = "";
	<%
 	if (XPol != null) {
		if (XPol.size() > 0) {
	%>
		strTmpMsg += "�Х��ץ��H�UX-FILE�O�檺���ڤH��ID: \r\n";
        <% for (int i = 0; i < XPol.size(); i++) {%>
				strTmpMsg += "<%=(String)XPol.get(i)%> \r\n";
		<% } %>	
		rtnVal = false;
	<%  }
	} %>

	if( !rtnVal )
	{
		alert( strTmpMsg );
	}
	return rtnVal;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="" id="frmMain" method="post" name="frmMain">
	<input type="button" value="��  ��" name="btnPrint" id="btnPrint" onclick="printRAction();" class="eServiceButton" style="margin: 0px; padding: 0px; height: 27; width: 40;">
	<TABLE border="1" width="680" id=FormArea style="display: none;">
		<TR>
			<TD align="right" class="TableHeading" width="180">�п�ܳ���榡�G</TD>
			<TD width="500">
				<input type="radio" name="rdReportForm" id="rdReportForm" value="PDF" class="Data" checked>PDF 
				<input type="radio" name="rdReportForm" id="rdReportForm" value="RPT" class="Data">RPT
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="180">���G</TD>
			<TD width="500">
				<input type="radio" name="rdDISPATCH" id="rdDISPATCH" value="Y" class="Data">�O 
				<input type="radio" name="rdDISPATCH" id="rdDISPATCH" value="N" class="Data" checked>�_
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="180">���O�G</TD>
			<TD width="333" valign="middle">
				<select size="1" name="para_Currency" id="para_Currency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="680" id=inquiryArea style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="180">�п�ܱ��������G</TD>
			<TD width="500">
				<input type="radio" name="rdReportType" id="rdReportType" value="B" class="Data" onclick="enableBatchArea();">�C��I���`��
				<input type="radio" name="rdReportType" id="rdReportType" value="A" class="Data" checked onclick="disableBatchArea();">�C��I�ک��Ӫ�
<% if(strUserDept.equals("CSC") && strUserRight.equals("89")) { %>
				<input type="radio" name="rdReportType" id="rdReportType" value="C" class="Data" onclick="disableBatchArea();">�z�߫����Ӫ�
<% } %>
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="680" id=BatchArea>
		<TR>
			<TD align="right" class="TableHeading" width="180">�ӷ��G</TD>
			<TD width="500">
				<input type="radio" name="rdFromBatch" id="rdFromBatch" value="Y" class="Data" checked onclick="enablePDateArea();">Batch�@�~ 
				<input type="radio" name="rdFromBatch" id="rdFromBatch" value="N" class="Data" onclick="disablePDateArea();">�u�W�@�~
			</TD>
		</TR>
		<TR id=PDateArea>
			<TD align="right" class="TableHeading" width="180">�I�ڤ���G</TD>
			<TD width="500">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPDateC" name="txtPDateC" value="" readOnly>
				<a href="javascript:show_calendar('frmMain.txtPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="180">��J����G</TD>
			<TD width="500">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtEntryDateC" name="txtEntryDateC" value="" readOnly> 
				<a href="javascript:show_calendar('frmMain.txtEntryDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT type="hidden" name="txtEntryDate" id="txtEntryDate" value="">
			</TD>
		</TR>
		<!--R61220 ����䲼.�״�-->
		<TR id=PDateMethod>
			<TD align="right" class="TableHeading" width="180">���ͳ����I�覡�G</TD>
			<TD width="500">
				<input type="radio" name="rdMethod" id="rdMethod" value="N" class="Data" checked>����
				<input type="radio" name="rdMethod" id="rdMethod" value="A" class="Data">�䲼��
				<input type="radio" name="rdMethod" id="rdMethod" value="B" class="Data">�D�䲼��
			</TD>
		</TR>
	</TABLE>
	<TABLE border="1" width="680" id=FinArea style="display: none">
		<TR>
			<TD align="right" class="TableHeading" width="180">��I�T�{��G</TD>
			<TD width="500">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPConfirmDateC" name="txtPConfirmDateC" value="" readOnly> 
				<a href="javascript:show_calendar('frmMain.txtPConfirmDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT type="hidden" name="para_PConDate" id="para_PConDate" value="<%=iCurrentDate%>">
			</TD>
		</TR>
	</TABLE>

	<!-- �C��I���`�� -->
	<!-- �C��I�ک��Ӫ� -->
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyPDetails.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL"	name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
	<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>"> 
	<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 
	<INPUT type="hidden" id="txtUserBrch" name="txtUserBrch" value="<%=strUserBrch%>">
	<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>"> 
	<INPUT type="hidden" id="para_EntryDate" name="para_EntryDate" value="<%=iCurrentDate%>"> 
	<INPUT type="hidden" id="para_PDate" name="para_PDate" value="<%=iCurrentDate%>"> 
	<INPUT type="hidden" id="para_FromBatch" name="para_FromBatch" value="">
	<INPUT type="hidden" id="para_DISPATCH" name="para_DISPATCH" value="">
	<INPUT type="hidden" id="para_NextDT" name="para_NextDT" value="<%=iCurrentDate%>">
	<INPUT type="hidden" id="switch_Call" name="switch_CallYorN" value="Y">
	<INPUT type="hidden" id="switch_PGM" name="switch_PGM" value="<%=strThisProgId%>">
</FORM>
<!-- �C���b�� (�d�s��) -->
<FORM id="frmMain1" name="frmMain1" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDaily.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT id="ReportPath" type="hidden" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" name="para_FromBatch" id="para_FromBatch" value="">
</FORM>
<!-- �C���I���Ӫ�а]�� -->
<FORM id="frmMain2" name="frmMain2" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyPDetailsByFin.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL"> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\"> 
	<INPUT type="hidden" id="para_PConDate" name="para_PConDate">
	<INPUT type="hidden" id="para_Currency" name="para_Currency">
</FORM>
<!-- R70600 �C��I�ک��Ӫ�-�]��-ĵ�� -->
<FORM id="frmMain3" name="frmMain3" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyPDetailsByFinA.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL"> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" id="para_PConDate" name="para_PConDate">
	<INPUT type="hidden" id="para_Currency" name="para_Currency">
</FORM>
<!-- R90624 �C��I���`�� (����) -->
<FORM id="frmMain4" name="frmMain4" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyToFinForCE.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
	<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>"> 
	<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>"> 
	<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>"> 
	<INPUT type="hidden" id="para_EntryDate" name="para_EntryDate" value="<%=iCurrentDate%>"> 
	<INPUT type="hidden" id="para_PDate" name="para_PDate" value="<%=iCurrentDate%>"> 
	<INPUT type="hidden" id="para_FromBatch" name="para_FromBatch" value="">
	<INPUT type="hidden" id="para_DISPATCH" name="para_DISPATCH" value="">
	<INPUT type="hidden" id="para_NextDT" name="para_NextDT" value="<%=iCurrentDate%>">
	<INPUT type="hidden" id="switch_Call" name="switch_CallYorN" value="Y">
	<INPUT type="hidden" id="switch_PGM" name="switch_PGM" value="<%=strThisProgId%>">
</FORM>
<!-- R90624 �C���b��(�d�s��)���� -->
<FORM id="frmMain5" name="frmMain5" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBDailyForCE.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value=""> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value=""> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" id="para_FromBatch" name="para_FromBatch" value="">
</FORM>

</BODY>
</HTML>

