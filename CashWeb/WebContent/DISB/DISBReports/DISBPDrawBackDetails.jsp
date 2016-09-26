<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : �U���ܧ�h�O���Ӫ�-POS
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.14 $
 * 
 * Author   : ELSA HUANG
 * 
 * Create Date : $Date: 2014/08/15 06:39:31 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPDrawBackDetails.jsp,v $
 * Revision 1.14  2014/08/15 06:39:31  missteven
 * RC0036-2
 *
 * Revision 1.13  2014/07/18 07:35:56  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.12  2014/06/18 03:21:40  MISARIEL
 * EB0469-PA0027 - VA�ӫ~�~���ഫ�M��
 * 
 * $Log: DISBPDrawBackDetails.jsp,v $
 * Revision 1.14  2014/08/15 06:39:31  missteven
 * RC0036-2
 *
 * Revision 1.13  2014/07/18 07:35:56  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.10  2012/08/29 02:57:51  ODCKain
 * Calendar problem
 *
 * Revision 1.9  2011/11/01 10:31:11  MISSALLY
 * R10260---�~���ǲΫ��O��ͦs�����I�@�~
 * FIX 79�v�����������I�D�ɪ���J�̫D���I�q���Ѫ���s��
 *
 * Revision 1.8  2011/08/31 07:28:18  MISSALLY
 * R10231
 * CASH�t�ηs�W�U���z�ߵ��I���Ӫ�
 *
 * Revision 1.7  2011/04/21 10:08:51  MISJIMMY
 * R00359-P00026 BC��������ú
 *
 * Revision 1.6  2010/11/23 02:51:38  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.5  2009/11/11 06:13:39  missteven
 * R90474 �ק�CASH�\��
 *
 * Revision 1.4  2008/08/06 06:08:52  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.3  2008/06/12 02:16:44  MISODIN
 * R80244 FIN����FIN & ACCT
 *
 * Revision 1.2  2006/12/07 02:20:22  MISODIN
 * R60463  �~���״�
 *
 * Revision 1.1  2006/06/29 09:40:41  MISangel
 * Init Project
 *
 * Revision 1.1.2.17  2006/04/27 09:47:31  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.16  2006/01/05 02:38:45  misangel
 * R50845:�T�I���u
 *
 * Revision 1.1.2.15  2005/11/18 04:31:08  misangel
 * R50820:��I�\�ണ��
 *
 * Revision 1.1.2.13  2005/06/09 11:03:21  MISANGEL
 * R30530:�H��J��d��
 *
 * Revision 1.1.2.12  2005/06/02 07:22:15  MISANGEL
 * R30530:�[��ú�h�O
 *
 * Revision 1.1.2.10  2005/04/22 07:29:10  miselsa
 * R30530
 *
 * Revision 1.1.2.9  2005/04/12 08:16:50  miselsa
 * R30530_�[�W�����v��
 *
 * Revision 1.1.2.8  2005/04/12 05:45:15  miselsa
 * R30530_�ק�����ݳ�����ƪ�JOIN SQL
 *
 * Revision 1.1.2.7  2005/04/12 03:13:39  miselsa
 * R30530_�ק�����ݳ�����ƪ�JOIN SQL
 *
 * Revision 1.1.2.6  2005/04/04 07:02:20  miselsa
 * R30530 ��I�t��
 *  
 */
%><%! String strThisProgId = "DISBPDrawBackDetails"; //���{���N��%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept")):"";
String strUserBrch = (session.getAttribute("LogonUserBrch") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserBrch")):"";//RC0036
String strUserArea = (session.getAttribute("LogonUserArea") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserArea")):"";//RC0036
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")):"";

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;

//R80132 ���O�D��
List alCurrCash = new ArrayList();
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
<TITLE>�U���ܧ�h�O���Ӫ�</TITLE>
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
		window.alert(document.getElementById("txtMsg").value) ;
	// R80244 if(document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "NB")
	// R10231 if(document.getElementById("txtUserDept").value == "FIN" || document.getElementById("txtUserDept").value == "ACCT" || document.getElementById("txtUserDept").value == "NB")	
	//RC0036if(document.getElementById("txtUserDept").value != "CSC")
	//RC0036	
	if(document.getElementById("txtUserDept").value != "CSC" && document.getElementById("txtUserArea").value == "")
		{
		alert("�L���榹�����v��");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else
	{
		WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' ) ;
	}
	window.status = "";
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
	//R00393  edit by Leo Huang Start
	//window.location.href= "/CashWeb/DISB/DISBReports/DISBPDrawBackDetails.jsp";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBReports/DISBPDrawBackDetails.jsp";
	//R00393  edit by Leo Huang end
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
	getReportInfo();
	WindowOnLoadCommon( document.title , '' , 'E','' );
	document.getElementById("inquiryArea").style.display ="none";
	document.getElementById("frmMain").target="_blank";
	document.getElementById("frmMain").submit();
}

function getReportInfo()
{
	mapValue();

	var strSql = "";

	if(document.getElementById("txtUserRight").value == "99")
	{	// �v����99��, �i�d�Ҧ����
		strSql  = "SELECT A.PAYR_NO, A.PAYR_POLICY_NO, A.PAYR_APP_NAME, A.PAYR_SERV_BRANCH, A.PAYR_ITEM, A.PAYR_DEF_AMOUNT, A.PAYR_DIV_AMOUNT, A.PAYR_LOAN, A.PAYR_UNPERIOD_PREM, B.PAY_METHOD,";
		strSql += "B.PAY_CONFIRM_DATE1, A.PAYR_REV_PREM, B.PAY_SOURCE_CODE, A.PAYR_SERV_AGENT, A.PAYR_CURR_PREM,A.PAYR_OVER_RETURN, A.PAYR_EXTRA_WORDING,B.ENTRY_DATE, B.PAY_CHECK_M1,B.PAY_CHECK_M2, ";
		strSql += "A.PAYR_EXTRA_AMOUNT, A.PAYR_LOAN_CAPITAL, A.PAYR_UPDATE_USER, A.PAYR_LOAN_INTEREST, A.PAYR_APL, A.PAYR_APL_INTEREST, A.PAYR_OFF_WORDING, A.PAYR_OFF_AMOUNT, ";
		strSql += "A.PAYR_OFF_AMOUNT1, A.PAYR_OFF_AMOUNT2, A.PAYR_OFF_AMOUNT3,B.PAY_CURRENCY,B.PAY_NAME,B.PENGNAME,B.PAY_FEEWAY "; //R90474
		strSql += ",C.DEPT AS PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,'" + document.getElementById("txtUserDept").value + "' AS USERDEPT,B.PAY_NAME,B.PENGNAME,B.PAY_REMIT_BANK,B.PAY_REMIT_ACCOUNT, B.PAY_SWIFT ";
       	strSql += ",C.USRNAM,C.USRBRCH,C.DEPT,CASE WHEN TRIM(REPLACE(T1.FLD0004,'�@',''))  = '' THEN T2.FLD0004 ELSE T1.FLD0004 END AS UNITNM"; //RC0036  
		strSql += ",B.PDISPATCH ";        //RC0036
	    strSql += " ,A.PAYR_ANN_AMOUNT     ";//EB0469
		strSql += " ,B.PAY_SRC_NAME, D.BKNM   ";
		strSql += " ,IFNULL(CASE WHEN B.PPAYRATE = 0 THEN 1 ELSE B.PPAYRATE END,1) AS PPAYRATE "//RC0036
		strSql += " from CAPPAYRF A LEFT OUTER JOIN CAPPAYF B ON A.PNO = B.PNO  left outer join USER C  on C.USRID=B.ENTRY_USER    ";
		strSql += " LEFT JOIN CAPCCBF D on D.BKNO = B.PRBANK   ";
	    strSql += " LEFT OUTER JOIN ORDUET T1 ON  T1.FLD0003 = C.USRBRCH";    //RC0036
        strSql += " LEFT OUTER JOIN ORDUET T2 ON  T2.FLD0003 = C.DEPT  "; //RC0036
		strSql += " WHERE  1=1 AND B.PCFMDT1 <> 0 AND B.PCFMDT2 = 0 AND B.PVOIDABLE = ''";
		strSql += "  AND T1.FLD0002 = 'DEPT'  AND T2.FLD0002 = 'DEPT'    ";//RC0036
		strSql += "   AND  B.PDISPATCH = '" + document.getElementById("selDispatch").value +"'" ;//RC0036

		if (document.getElementById("Para_Currency").value != "" )
		{
			strSql += " AND B.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value +"'" ;
		}
	}
	else if(document.getElementById("txtUserRight").value >= "89" && document.getElementById("txtUserRight").value < "99")
	{	//�u��d�������Ҧ����
		strSql  = "SELECT A.PAYR_NO, A.PAYR_POLICY_NO, A.PAYR_APP_NAME, A.PAYR_SERV_BRANCH, A.PAYR_ITEM, A.PAYR_DEF_AMOUNT, A.PAYR_DIV_AMOUNT, A.PAYR_LOAN, A.PAYR_UNPERIOD_PREM, B.PAY_METHOD,";
		strSql += "B.PAY_CONFIRM_DATE1, A.PAYR_REV_PREM, B.PAY_SOURCE_CODE, A.PAYR_SERV_AGENT, A.PAYR_CURR_PREM,A.PAYR_OVER_RETURN, A.PAYR_EXTRA_WORDING,B.ENTRY_DATE,B.PAY_CHECK_M1,B.PAY_CHECK_M2, ";
		strSql += "A.PAYR_EXTRA_AMOUNT, A.PAYR_LOAN_CAPITAL, A.PAYR_UPDATE_USER, A.PAYR_LOAN_INTEREST, A.PAYR_APL, A.PAYR_APL_INTEREST, A.PAYR_OFF_WORDING, A.PAYR_OFF_AMOUNT,";
		strSql += "A.PAYR_OFF_AMOUNT1, A.PAYR_OFF_AMOUNT2, A.PAYR_OFF_AMOUNT3,B.PAY_CURRENCY,B.PAY_NAME,B.PENGNAME"; //R90474
		strSql += ",B.PDISPATCH ";        //RC0036
       	strSql += ",C.USRNAM,C.USRBRCH,C.DEPT,CASE WHEN TRIM(REPLACE(T1.FLD0004,'�@',''))  = '' THEN T2.FLD0004 ELSE T1.FLD0004 END AS UNITNM "; //RC0036  
       	strSql += " ,A.PAYR_ANN_AMOUNT     ";//EB0469
		strSql += ",C.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,'" + document.getElementById("txtUserDept").value + "' AS USERDEPT ";
		// R60463
		strSql += ",B.PAY_PAYCURR,B.PAY_PAYAMT,B.PAY_PAYRATE,B.PAY_FEEWAY,B.PAY_NAME,B.PENGNAME,B.PAY_REMIT_BANK,B.PAY_REMIT_ACCOUNT, B.PAY_SWIFT ";
		strSql += " ,B.PAY_SRC_NAME, D.BKNM   ";
		strSql += " ,IFNULL(CASE WHEN B.PPAYRATE = 0 THEN 1 ELSE B.PPAYRATE END,1) AS PPAYRATE "//RC0036
		strSql += " from CAPPAYRF A LEFT OUTER JOIN CAPPAYF B ON A.PNO = B.PNO LEFT ";
		strSql += " JOIN USER C ON C.USRID=B.ENTRY_USER ";
		strSql += " LEFT OUTER JOIN ORDUET T1 ON  T1.FLD0003 = C.USRBRCH";    //RC0036
        strSql += " LEFT OUTER JOIN ORDUET T2 ON  T2.FLD0003 = C.DEPT  "; //RC0036
		strSql += " LEFT JOIN CAPCCBF D on D.BKNO = B.PRBANK   ";
//RC0036		strSql += " WHERE   C.DEPT='"+ document.getElementById("txtUserDept").value +"' AND B.PCFMDT1 <> 0 AND B.PCFMDT2 = 0 AND B.PVOIDABLE = '' ";
        strSql += " WHERE  B.PCFMDT1 <> 0 AND B.PCFMDT2 = 0 AND B.PVOIDABLE = '' "; //RC0036
        strSql += "  AND T1.FLD0002 = 'DEPT'  AND T2.FLD0002 = 'DEPT'    ";//RC0036             
		strSql += "   AND  B.PDISPATCH = '" + document.getElementById("selDispatch").value +"'" ;//RC0036
		if (document.getElementById("txtUserDept").value == "CSC"){                              //RC0036
		    strSql += "  AND C.DEPT IN ('PCD','TYB','TCB','TNB','KHB','CSC')";                   //RC0036                 
		}else{                                                                        //RC0036 
		    if (document.getElementById("txtUserBrch").value == ""){          //RC0036                                                             //RC0036
	    	strSql += "  AND C.DEPT='"+ document.getElementById("txtUserDept").value +"' ";//RC0036 
	    	}else{//RC0036 
	    	strSql += "  AND C.DEPT='"+ document.getElementById("txtUserDept").value +"' ";//RC0036 
	    	strSql += "  AND C.USRBRCH='"+ document.getElementById("txtUserBrch").value +"' ";//RC0036 
	    	}                                                                          //RC0036 
	    }	                                                                                                                         //RC0036
		if (document.getElementById("Para_Currency").value != "" )
		{
			strSql += " AND B.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value +"'" ;
		}
	}
	else
	{	//�u��d�ۤv�ҿ�J�����
		strSql  = "SELECT A.PAYR_NO, A.PAYR_POLICY_NO, A.PAYR_APP_NAME, A.PAYR_SERV_BRANCH, A.PAYR_ITEM, A.PAYR_DEF_AMOUNT, A.PAYR_DIV_AMOUNT, A.PAYR_LOAN, A.PAYR_UNPERIOD_PREM, B.PAY_METHOD,";
		strSql += "B.PAY_CONFIRM_DATE1, A.PAYR_REV_PREM, B.PAY_SOURCE_CODE, A.PAYR_SERV_AGENT, A.PAYR_CURR_PREM,A.PAYR_OVER_RETURN, A.PAYR_EXTRA_WORDING,B.ENTRY_DATE,B.PAY_CHECK_M1,B.PAY_CHECK_M2, ";
		strSql += "A.PAYR_EXTRA_AMOUNT, A.PAYR_LOAN_CAPITAL, A.PAYR_UPDATE_USER, A.PAYR_LOAN_INTEREST, A.PAYR_APL, A.PAYR_APL_INTEREST, A.PAYR_OFF_WORDING, A.PAYR_OFF_AMOUNT,";
		strSql += "A.PAYR_OFF_AMOUNT1, A.PAYR_OFF_AMOUNT2, A.PAYR_OFF_AMOUNT3,B.PAY_CURRENCY,B.PAY_NAME,B.PENGNAME";//R90474
       	strSql += ",C.USRNAM,C.USRBRCH,C.DEPT,CASE WHEN TRIM(REPLACE(T1.FLD0004,'�@',''))  = '' THEN T2.FLD0004 ELSE T1.FLD0004 END AS UNITNM ";                                                        //RC0036  
		strSql += ",C.DEPT as PAY_DEPT,'" + document.getElementById("txtUserRight").value + "' AS USERRIGHT ,'" + document.getElementById("txtUserDept").value + "' AS USERDEPT ";
		// R60463
		strSql += ",B.PAY_PAYCURR,B.PAY_PAYAMT,B.PAY_PAYRATE,B.PAY_FEEWAY,B.PAY_NAME,B.PENGNAME,B.PAY_REMIT_BANK,B.PAY_REMIT_ACCOUNT, B.PAY_SWIFT ";
		strSql += " ,A.PAYR_ANN_AMOUNT     ";//EB0469
		strSql += ",B.PDISPATCH ";                                                               //RC0036
		strSql += " ,B.PAY_SRC_NAME, D.BKNM   ";
		strSql += " ,IFNULL(CASE WHEN B.PPAYRATE = 0 THEN 1 ELSE B.PPAYRATE END,1) AS PPAYRATE "//RC0036
		strSql += " from CAPPAYRF A LEFT OUTER JOIN CAPPAYF B ON A.PNO = B.PNO left outer join USER C  on C.USRID=B.ENTRY_USER   ";
		strSql += " LEFT JOIN CAPCCBF D on D.BKNO = B.PRBANK   ";
        strSql += " LEFT OUTER JOIN ORDUET T1 ON  T1.FLD0003 = C.USRBRCH";    //RC0036
        strSql += " LEFT OUTER JOIN ORDUET T2 ON  T2.FLD0003 = C.DEPT  "; //RC0036
		strSql += " WHERE  B.ENTRY_USER= '" + document.getElementById("txtUserId").value  + "' AND B.PCFMDT1 <> 0 AND B.PCFMDT2 = 0 AND B.PVOIDABLE = '' ";
        strSql += "  AND T1.FLD0002 = 'DEPT'  AND T2.FLD0002 = 'DEPT'    ";//RC0036  
        strSql += "   AND  B.PDISPATCH = '" + document.getElementById("selDispatch").value +"'" ; //RC0036
		if (document.getElementById("Para_Currency").value != "" )
		{
			strSql += " AND B.PAY_CURRENCY = '"+ document.getElementById("Para_Currency").value +"'" ;
		}
	}
	//EB0097 �۰ʽT�{�|�a���Ӥ�
	strSql += " AND B.PAY_CONFIRM_DATE1 <= " + document.getElementById("para_PSRCDT").value;
    
	document.getElementById("ReportSQL").value = strSql;
}

function mapValue(){
	document.getElementById("para_PSRCDT").value = rocDate2String(document.getElementById("txtPSRCDT").value);
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain" method="post" name="frmMain">
<!--RC0036 <TABLE border="1" width="350" id="inquiryArea">-->
<!--RC0036--> 
<TABLE border="1" width="500" id="inquiryArea">
	<TR>
		<TD align="right" class="TableHeading" width="80">��J����G</TD>
		<TD width="150">
			<INPUT class="Data" size="11" type="text"maxlength="11" id="txtPSRCDT" name="txtPSRCDT" value="" readOnly >
			<a href="javascript:show_calendar('frmMain.txtPSRCDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
			<INPUT type="hidden" name="para_PSRCDT" id="para_PSRCDT" value="">
		</TD>
		<!--RC0036--> 		
		<TD align="right" class="TableHeading" width="50">���G</TD>		
		<TD width="100">
		    <select size="1" name="selDispatch" id="selDispatch">
					<option value="" selected></option>
					<option value="Y">Y</option>
					<!--<option value="N"></option>-->
			</select>
		</TD>
		
		<TD align="right" class="TableHeading" width="50">���O�G</TD>
		<TD valign="middle">
			<select size="1" name="para_Currency" id="para_Currency">
				<%=sbCurrCash.toString()%>
			</select>
		</TD>
	</TR>
</TABLE>
<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBPDrawBackDetails.rpt">
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBPDrawBackDetails.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
<INPUT type="hidden" id="txtUserBrch" name="txtUserBrch" value="<%=strUserBrch%>"> <!-- RC0036 -->
<INPUT type="hidden" id="txtUserArea" name="txtUserArea" value="<%=strUserArea%>"> <!-- RC0036 -->
<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">	
<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">	
</FORM>
</BODY>
</HTML>