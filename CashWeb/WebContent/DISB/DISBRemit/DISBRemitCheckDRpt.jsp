<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
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
 * Function : �~���״ڸ���ˮ֩��Ӫ�
 * 
 * Remark   : �X�ǥ\��--�~���״��ˮֳ���
 * 
 * Revision : $1.1$
 * 
 * Author   : Vanessa Liao
 * 
 * Create Date : $Date: 2014/01/03 02:32:02 $
 * 
 * Request ID :R70088
 * 
 * CVS History:
 * 
 * $Log: DISBRemitCheckDRpt.jsp,v $
 * Revision 1.10  2014/01/03 02:32:02  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.2  2013/04/18 02:16:07  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 *
 * Revision 1.9  2013/04/18 02:09:26  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 * �ץ����H�״���
 *
 * Revision 1.8  2012/08/29 02:57:53  ODCKain
 * Calendar problem
 *
 * Revision 1.7  2011/11/08 09:16:39  MISSALLY
 * Q10312
 * �״ڥ\��-���״ڧ@�~
 * 1.�ץ��Ȧ�b�����@�P
 * 2.�վ���׶״���
 *
 * Revision 1.5  2008/08/06 07:05:50  MISODIN
 * R80338 �վ�CASH�t�� for �X�ǥ~���@��@�ݨD
 *
 * Revision 1.4  2007/09/07 10:42:18  MISVANESSA
 * R70455_TARGET OUT
 *
 * Revision 1.3  2007/03/16 01:39:51  MISVANESSA
 * R70088_SPUL�t���ק�rule
 *
 * Revision 1.2  2007/03/06 01:51:28  MISVANESSA
 * R70088_SPUL�t���s�W�`��
 *
 * Revision 1.1  2007/01/31 08:05:28  MISVANESSA
 * R70088_SPUL�t��
 *  
 */
%><%! String strThisProgId = "DISBRemitCheckDRpt"; //���{���N��%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory); //R80338

String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";
String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserDept")):"";
String strUserRight = (session.getAttribute("LogonUserRight") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserRight")):"";
String strUserId = (session.getAttribute("LogonUserId") != null)?CommonUtil.AllTrim((String)session.getAttribute("LogonUserId")):"";

//R80338 ���O�D��
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}//R80338 END

Hashtable htTemp = null;
String strValue = null;
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
<TITLE>�X�ǥ\��--�~���״ڸ���ˮ֩��Ӫ�</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/DateUtil.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title , '' , strFunctionKeyReport,'' );
	window.status = "";
}
/* ��toolbar frame ����[����]���s�Q�I���,����Ʒ|�Q���� */
function printRAction()
{  
	window.status = "";
	strErrMsg = "";
	mapValue();
	if(checkFieldOK())
	{
		document.getElementById("txtAction").value = "L";
		WindowOnLoadCommon( document.title , '' , 'E','' );
		getReportInfo();
		document.getElementById("frmMain").target="_blank";
		document.getElementById("frmMain").submit();
		document.getElementById("frmMain1").target="_blank";
		document.getElementById("frmMain1").submit();
	}
	else
	{
		alert( strErrMsg );	
	}
}

function getReportInfo()
{
	var SWspul = "";

	// R00365 ��H�I�ڳW�h�Ϥ�
    var payRule = document.getElementById("selPayRule").value;
	var sqlCond = "";
	if( payRule == "<%= RemittancePayRule.PLANV_DIV.getCode()%>" ) {
		// ��ꫬ-�t��
		SWspul = "B";
		//R00440 SN������    	sqlCond += " AND PPLANT <> ' ' AND ( A.PSRCCODE IN ('B8','B9') OR A.ENTRYDT <= A.PINVDT)";
		sqlCond += " AND PPLANT <> ' ' AND ( A.PSRCCODE IN ('B8','B9','BB') OR A.ENTRYDT <= A.PINVDT)";//R00440 SN������
	} else if ( payRule == "<%= RemittancePayRule.PLANV_NODIV.getCode()%>" ) {
		SWspul = "A";
		//R00440 SN������ sqlCond += " AND PPLANT <> ' ' AND A.PSRCCODE NOT IN ('B8','B9') AND A.ENTRYDT > A.PINVDT";
		sqlCond += " AND PPLANT <> ' ' AND A.PSRCCODE NOT IN ('B8','B9','BB') AND A.ENTRYDT > A.PINVDT";//R00440 SN������
	} else if ( payRule == "<%= RemittancePayRule.PLANT.getCode()%>" ) {
		SWspul = "";
		sqlCond += " AND PPLANT = ' ' ";
	}	// �I�ڳW�h�ť� - �����z��

	// R80338    �O����O
	if (document.getElementById("txtPOCurrency").value != "" ) {
		sqlCond += " AND A.PCURR = '"+ document.getElementById("txtPOCurrency").value +"'";
	}

	// SQL Command �ܤ@�I��...���T�h
	var strSql = " SELECT U.*, TN.FLD0004 AS PBBANKNAME_CHECKED "
				+ " FROM ( "
				+ "     SELECT DISTINCT T.*,  "
				//+ "     SELECT  T.*,  "
				+ "         CASE WHEN PAYRULECODE = '1' THEN "
				+ "             CASE WHEN T1.FLD0004 IS NOT NULL THEN T.PBBANKCODE "
				+ "             ELSE '822' END "
				+ "         WHEN PAYRULECODE = '2' THEN SUBSTR(T2.FLD0004,1,3)  "
				+ "         WHEN PAYRULECODE = '3' THEN  "
				+ "             CASE WHEN T3.FLD0004 IS NOT NULL THEN T.PBBANKCODE "
				+ "             ELSE '822' END "
				+ "         ELSE '822' "
				+ "         END AS PBBANKCODE_CHECKED "
				+ "     FROM (  "
				+ "         SELECT A.PNO,A.PNAME,A.PAMT,A.PBBANK,A.PBACCOUNT,A.PRBANK,A.PRACCOUNT,A.PBATNO,A.PPAYCURR as PCURR2,E.FLD0004 as PPAYCURR,G.FLD0004 as PPCURRDesc,A.PPAYAMT,A.RMTFEE,A.PCFMDT2,A.PDISPATCH,B.BKNM AS RBKNM,C.BKNM AS BBKNM ,A.PCURR as CURR2,D.FLD0004 as PCURR,F.FLD0004 as PCURRDesc,A.PPLANT, A.ENTRYDT, A.PINVDT, A.PSRCCODE   "
				//R00440 SN������+ "         ,CASE WHEN A.PPLANT = ' ' AND A.PCURR <> 'NT'  THEN '3'    WHEN A.PPLANT = 'V' AND ( A.PSRCCODE IN ('B8','B9') OR A.ENTRYDT <= A.PINVDT ) THEN '1'     WHEN A.PPLANT = 'V' AND A.PSRCCODE NOT IN ('B8','B9') AND A.ENTRYDT > A.PINVDT THEN '2'     ELSE '4'  END AS PAYRULECODE   "
				//R00440 SN������+ "         ,CASE WHEN A.PPLANT = ' ' AND A.PCURR <> 'NT' THEN '�ǲΫ�'     WHEN A.PPLANT = 'V' AND ( A.PSRCCODE IN ('B8','B9') OR A.ENTRYDT <= A.PINVDT ) THEN '��ꫬ-�t��'     WHEN A.PPLANT = 'V' AND A.PSRCCODE NOT IN ('B8','B9') AND A.ENTRYDT > A.PINVDT THEN '��ꫬ-�D�t��'     ELSE '�䥦'  END AS PAYRULE   "
				+ "         ,CASE WHEN A.PPLANT = ' ' AND A.PCURR <> 'NT'  THEN '3'    WHEN A.PPLANT = 'V' AND ( A.PSRCCODE IN ('B8','B9','BB') OR A.ENTRYDT <= A.PINVDT ) THEN '1'     WHEN A.PPLANT = 'V' AND A.PSRCCODE NOT IN ('B8','B9','BB') AND A.ENTRYDT > A.PINVDT THEN '2'     ELSE '4'  END AS PAYRULECODE   "//R00440 SN������
				+ "         ,CASE WHEN A.PPLANT = ' ' AND A.PCURR <> 'NT' THEN '�ǲΫ�'     WHEN A.PPLANT = 'V' AND ( A.PSRCCODE IN ('B8','B9','BB') OR A.ENTRYDT <= A.PINVDT ) THEN '��ꫬ-�t��'     WHEN A.PPLANT = 'V' AND A.PSRCCODE NOT IN ('B8','B9','BB') AND A.ENTRYDT > A.PINVDT THEN '��ꫬ-�D�t��'     ELSE '�䥦'  END AS PAYRULE   "//R00440 SN������
				+ "         ,SUBSTR(A.PRBANK,1,3) AS PBBANKCODE "
				+ "         FROM CAPPAYF A  "
				+ "         LEFT JOIN CAPCCBF B on A.PRBANK = B.BKNO  "
				+ "         LEFT JOIN CAPCCBF C on A.PBBANK = C.BKNO  "
				+ "         LEFT JOIN ORDUET D on D.FLD0001='  ' and D.FLD0002='CURRA' and D.FLD0003=A.PCURR  "
				+ "         LEFT JOIN ORDUET E on E.FLD0001='  ' and E.FLD0002='CURRA' and E.FLD0003=A.PPAYCURR  "
				+ "         LEFT JOIN ORDUET F on F.FLD0001='  ' and F.FLD0002='CURRN' and F.FLD0003=A.PCURR  "
				+ "         LEFT JOIN ORDUET G on G.FLD0001='  ' and G.FLD0002='CURRN' and G.FLD0003=A.PPAYCURR  "
				//+ "         WHERE A.PMETHOD='D' AND A.PSTATUS <>'A' AND PVOIDABLE<>'Y'  "
				+ "         WHERE A.PMETHOD='D' AND PVOIDABLE<>'Y'  "	//FIN�Ʊ椣���h�׼v�T
				+ "         " + sqlCond
				+ "         AND A.PCFMDT2 = " + document.getElementById("txtFINCOMDT").value
				+ "     ) T "
				+ "     LEFT JOIN ORDUET T1 ON T1.FLD0002 = 'PBKAT' AND SUBSTR(T1.FLD0003,1,1) = 'F' AND SUBSTR(T1.FLD0004,1,3) = T.PBBANKCODE "
				+ "     LEFT JOIN ORDUET T2 ON T2.FLD0002 = 'PBKAT' AND T2.FLD0003 = 'F0004'  "
				// + "     LEFT JOIN ORDUET T3 ON T3.FLD0002 = 'BNKFR' AND T3.FLD0003 = trim(T.PCURR) || trim(T.PBBANKCODE) "
				+ "     LEFT JOIN ORDUET T3 ON T3.FLD0002 = 'BNKFR' AND substr(T3.FLD0003,3,3) = trim(T.PBBANKCODE) "
				+ " ) U "
				+ " LEFT JOIN ORDUET TN ON TN.FLD0002 = 'BANK' AND TN.FLD0003 = U.PBBANKCODE_CHECKED "
				+ " ORDER BY U.PCURR,U.PAYRULECODE,U.PBBANKCODE_CHECKED,U.PPAYCURR,U.PRBANK,U.PRACCOUNT,U.PNAME ";

	// ����褸�~
	var dateUtil = new DateUtil();
	dateUtil.formater.fillZero = true;
	var currentDate = dateUtil.parseDate( document.getElementById("txtFINCOMDT").value, true );
	var dateString = dateUtil.formatDate( currentDate, false );

	//���Ӫ�
	document.frmMain.ReportSQL.value = strSql;
	document.frmMain.para_PCOMDT.value = dateString;
	document.frmMain.para_SPULCK.value = SWspul;
	//�`��
	document.frmMain1.ReportSQL.value = strSql;
	document.frmMain1.para_PCOMDT.value = dateString;
	document.frmMain1.para_SPULCK.value = SWspul;
}

/* ��toolbar frame �������}���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitCheckDRpt.jsp";
}

function mapValue()
{
	document.getElementById("txtFINCOMDT").value = rocDate2String(document.getElementById("txtFINCOMDTC").value);
}

function checkFieldOK()
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if(document.getElementById("txtFINCOMDTC").value=="")
	{
		strTmpMsg = "�п�J��I�T�{��!\r\n";
		bReturnStatus = false;;
	} else {
		bReturnStatus = checkClientField( document.getElementById("txtFINCOMDTC"), false );
	}

	if( !bReturnStatus )
	{
		strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtFINCOMDTC"  ) {
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
        	strTmpMsg = "��I�T�{��-����榡���~";
        	bReturnStatus = false;			
        }
	}

	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg += strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain" name="frmMain" method="post">
<TABLE border="1" width="500" id=inqueryArea>
	<TBODY>
		<TR>
			<TD align="left" class="TableHeading" width="100">��I�T�{��G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11" id="txtFINCOMDTC" name="txtFINCOMDTC" value="" > 
				<a href="javascript:show_calendar('frmMain.txtFINCOMDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>  
				<INPUT type="hidden" name="txtFINCOMDT" id="txtFINCOMDT" value="" >
			</TD>
		</TR>
        <!-- R80338 -->
		<TR>
			<TD align="left" class="TableHeading" width="100">�O����O�G</TD>
            <TD>
            	<select size="1" name="txtPOCurrency" id="txtOPCurrency" >
            		<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
		<!-- R00365-P0026 �����M�׽X�P����, �t�W�I�ڳW�h���N -->
		<TR>
			<TD align="left" class="TableHeading" width="100">�I�ڳW�h�G</TD>
			<TD>
				<select size="1" name="selPayRule" id="selPayRule">
					<option value="ALL" selected>�ť�</option>
				<%
				CodeAttr[] payRules = RemittancePayRule.getAllCodeAttr();
				for( int i = 0 ; i < payRules.length ; i++ ) {
				    CodeAttr attr = payRules[i];
				    out.println("<option value=\"" + attr.getCode()+ "\">"+ attr.getName() + "&nbsp;" + attr.getCode() + "</option>");
				}
				%>
				</select>
			</TD>
		</TR>		
	</TBODY>
</TABLE>
	<!-- �~���״ڸ���ˮ֩��Ӫ� -->
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitCheckD.rpt">
	<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF">
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBRemitCheckD.pdf">
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBRemit\\">
	<INPUT type="hidden" id="txtAction"	name="txtAction" value="<%=strAction%>">
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
	<INPUT type="hidden" id="txtUserDept" name="txtUserDept" value="<%=strUserDept%>">
	<INPUT type="hidden" id="txtUserRight" name="txtUserRight" value="<%=strUserRight%>">	
	<INPUT type="hidden" id="txtUserId" name="txtUserId" value="<%=strUserId%>">
	<INPUT type="hidden" id="para_PCOMDT" name="para_PCOMDT" value="">
	<INPUT type="hidden" id="para_SPULCK" name="para_SPULCK" value="">
</FORM>
	<!-- �~���״ڸ���ˮ��`�� -->
<FORM action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS" id="frmMain1" name="frmMain1" method="post">
	<INPUT type="hidden" id="ReportName" name="ReportName" value="DISBRemitCheckDTot.rpt"> 
	<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
	<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="DISBRemitCheckDTot.pdf"> 
	<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value=""> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBRemit\\"> 
	<INPUT type="hidden" id="para_PCOMDT" name="para_PCOMDT" value="">
	<INPUT type="hidden" id="para_SPULCK" name="para_SPULCK" value="">
</FORM>
</BODY>
</HTML>