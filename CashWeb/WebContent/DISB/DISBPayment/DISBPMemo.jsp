<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : ��I�Ƶ�
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.8 $
 * 
 * Author   : ANGEL CHEN
 * 
 * Create Date : $Date: 2013/12/18 07:22:52 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBPMemo.jsp,v $
 * Revision 1.8  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.2  2008/08/06 06:04:05  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.1  2006/06/29 09:40:49  MISangel
 * Init Project
 *
 * Revision 1.1.2.10  2006/04/27 09:33:48  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.9  2005/10/14 07:48:08  misangel
 * R50835:��I�\�ണ��
 *
 * Revision 1.1.2.8  2005/04/20 04:17:46  MISANGEL
 * R30530:��I�t��
 *
 * Revision 1.1.2.7  2005/04/04 07:02:21  miselsa
 * R30530 ��I�t��
 *  
 */
%><%!String strThisProgId = "DISBPMemo"; //���{���N��%><%
GlobalEnviron globalEnviron =(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
String strReturnMessage = (request.getParameter("txtMsg") != null)?request.getParameter("txtMsg"):"";

List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
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
<TITLE>��I�\��--��I�Ƶ�</TITLE>
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
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;

	if (document.getElementById("txtAction").value == "I")
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInquiry,'' ) ;
		document.getElementById("updateArea").style.display = "block"; 
		document.getElementById("inqueryArea").style.display = "none"; 
		disableKey();
		disableData();	    
	}
	else
	{
		document.getElementById("inqueryArea").display = "block"; 
		document.getElementById("updateArea").display = "none"; 
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;
		window.status = "�Х���ܬd�ߥ\����,�Y�n�ק���,�i�g�Ѭd�ߥ\���A�i�J";
		enableKey();
		enableData();  
	}
}

/* ��toolbar frame ����[���}]���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBPayment/DISBPMemo.jsp?";
}

/* ��toolbar frame ����[�d��]���s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
{
 	if( document.getElementById("txtAction").value == "I" )
	{
		/*	���� QueryFrameSet.jsp ��,�U QueryString �ѼƤ��N�q
			RowPerPage		: �C�@�����X�C
			Heading			: ���Y���W��,�H�r��','���}�C�@���
			DisplayFields	: �n��ܤ���Ʈw���W��,�H�r�����}�C�@���,�PHeading�۹���
			ReturnFields	: �Ǧ^������줧��,�H�r�����}�C�@���
			Sql				: �ݰ��椧SQL,��i�[�Jwhere����
			TableWidth		: ���Table���e��
	
		 modalDialog �|�Ǧ^�ϥΪ̿�w���Ϊ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}
		
		*/
		mapValue();

		var strSql = "";
			strSql = "SELECT A.PAY_NO,A.PAY_METHOD,CAST(A.PAY_DATE AS CHAR(7)) AS PAY_DATE ,A.PAY_NAME,A.PAY_ID,A.PAY_AMOUNT,A.PAY_STATUS,A.PAY_DESCRIPTION,A.PAY_SOURCE_GROUP,A.PAY_SOURCE_CODE,A.PAY_VOIDABLE,A.PAY_DISPATCH,A.ENTRY_USER,CAST(A.ENTRY_DATE AS CHAR(7)) AS ENTRY_DATE,A.PAY_CHECK_M1,A.PAY_CHECK_M2,A.PAY_REMIT_BANK,A.PAY_REMIT_ACCOUNT,A.PAY_CREDIT_CARD,A.PAY_CREDIT_TYPE,A.PAY_CARD_MMYYYY,A.PAY_AUTHORITY_CODE,A.POLICY_NO,A.APP_NO,A.PAY_MEMO,B.FLD0004 AS PSRCCDDESC, C.FLD0004 AS PSRCGPDESC,A.PAY_CURRENCY ";		
			strSql += " from CAPPAYF A ";
			strSql += " left outer join ORDUET B on B.FLD0001='  ' AND B.FLD0002='PAYCD' AND B.FLD0003=A.PAY_SOURCE_CODE ";
		    strSql += " left outer join ORDUET C on C.FLD0001='  ' AND C.FLD0002='SRCGP' AND C.FLD0003=A.PAY_SOURCE_GROUP ";
			strSql += " WHERE 1=1  ";

		if( document.getElementById("txtPolicyNo").value != "" ) {
			strSql += " AND POLICYNO = '" + document.getElementById("txtPolicyNo").value.toUpperCase() + "' ";
		}
		if( document.getElementById("txtAppNo").value != "" ) {
			strSql += "  AND  APPNO= '" + document.getElementById("txtAppNo").value.toUpperCase() + "' ";
		}
		if( document.getElementById("txtPName").value != "" ){
			strSql += "  AND PNAME like '^" +  document.getElementById("txtPName").value + "^' ";
		}
		if( document.getElementById("txtPid").value != "" ){
			strSql += "  AND  PID= '" + document.getElementById("txtPid").value.toUpperCase()  + "' ";
		}
		if( document.getElementById("txtPAMT").value != "" ) {
			strSql += " AND  PAMT = " + document.getElementById("txtPAMT").value + " ";
		}
		if( document.getElementById("txtPRBank").value != "" ) {
			strSql += "  AND  PRBANK= '" +  document.getElementById("txtPRBank").value + "' ";
		}
		if( document.getElementById("txtPRAccount").value != "" ) {
			strSql += " AND  PRACCOUNT = '" + document.getElementById("txtPRAccount").value + "' ";
		}
		if( document.getElementById("txtPCrdNo").value != "" ){
			strSql += "  AND  PCRDNO= '" + document.getElementById("txtPCrdNo").value + "' ";
		}
		if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value != "") {
			strSql += " AND  PAY_DATE BETWEEN " + document.getElementById("txtPStartDate").value + " and " + document.getElementById("txtPEndDate").value ;
		} else if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value == "") {
			strSql += "  AND PAY_DATE >= " + document.getElementById("txtPStartDate").value ;
		} else if (document.getElementById("txtPStartDate").value == "" && document.getElementById("txtPEndDate").value != "") {
			strSql += " AND  PAY_DATE <= " + document.getElementById("txtPEndDate").value ;
		}

		if (document.getElementById("txtEntryStartDate").value != "" && document.getElementById("txtEntryEndDate").value != "")  {
			strSql += " AND  ENTRY_DATE BETWEEN " + document.getElementById("txtEntryStartDate").value + " and " + document.getElementById("txtEntryEndDate").value ;
		} else if (document.getElementById("txtEntryStartDate").value != "" && document.getElementById("txtEntryEndDate").value == "") {
			strSql += "  AND ENTRY_DATE >= " + document.getElementById("txtEntryStartDate").value ;
		} else if (document.getElementById("txtEntryStartDate").value == "" && document.getElementById("txtEntryEndDate").value != "") {
			strSql += " AND  ENTRY_DATE <= " + document.getElementById("txtEntryEndDate").value;
		}

		if (document.getElementById("txtUpdStartDate").value != "" && document.getElementById("txtUpdEndDate").value != "") {
			strSql += "  AND UPDATE_DATE = '" + document.getElementById("txtUpdStartDate").value + " and " + document.getElementById("txtUpdEndDate").value;
		} else if (document.getElementById("txtUpdStartDate").value != "" && document.getElementById("txtUpdEndDate").value == "") {
			strSql += "  AND UPDATE_DATE >= " + document.getElementById("txtUpdStartDate").value;
		} else if (document.getElementById("txtUpdStartDate").value == "" && document.getElementById("txtUpdEndDate").value != "") {
			strSql += "  AND UPDATE_DATE <= " + document.getElementById("txtUpdEndDate").value;
		}

		if( document.getElementById("selPStatus").value != "" ) {
			strSql += "   AND PSTATUS= '" + document.getElementById("selPStatus").value + "' ";
		}
		if( document.getElementById("selPVoidable").value != "" ){
			strSql += "   AND PVOIDABLE= '" + document.getElementById("selPVoidable").value + "' ";
		}
		if( document.getElementById("selDispatch").value != "" ) {
			strSql += "   AND PDISPATCH= '" + document.getElementById("selDispatch").value + "' ";
		}	
		if( document.getElementById("selCurrency").value != "" ) {
			strSql += "   AND PCURR= '" + document.getElementById("selCurrency").value + "' ";
		}else {
		    // R80132  strSql += "   AND PCURR IN('NT','US')";
		    strSql += "   AND PCURR IN ('NT','US','AU','EU','HK','JP','NZ')";
		}

	  	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=820";
	  	<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	    session.setAttribute("Heading","�O�渹�X,�n�O�Ѹ��X,���ڤH�m�W,���ڤHID,��I���B,�I�ڤ覡,�I�ڤ��e,�I�ڪ��A,�@�o�_,���_,��J��,��J��");
	    session.setAttribute("DisplayFields", "POLICY_NO,APP_NO,PAY_NAME,PAY_ID,PAY_AMOUNT,PAY_METHOD,PAY_DESCRIPTION,PAY_STATUS,PAY_VOIDABLE,PAY_DISPATCH,ENTRY_USER,ENTRY_DATE");
	    session.setAttribute("ReturnFields", "PAY_NO,PAY_METHOD,PAY_DATE,PAY_NAME,PAY_ID,PAY_AMOUNT,PAY_STATUS,PAY_DESCRIPTION,PAY_SOURCE_GROUP,PAY_SOURCE_CODE,PAY_VOIDABLE,PAY_DISPATCH,PAY_CHECK_M1,PAY_CHECK_M2,PAY_REMIT_BANK,PAY_REMIT_ACCOUNT,PAY_CREDIT_CARD,PAY_CREDIT_TYPE,PAY_CARD_MMYYYY,PAY_AUTHORITY_CODE,POLICY_NO,APP_NO,PAY_MEMO,PSRCCDDESC,PSRCGPDESC,PAY_CURRENCY");
	    %>
		//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" )
		{
			//enableAll();
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtUPNO").value = returnArray[0];
			
			var strUPMethod = returnArray[1];
			if (strUPMethod == "A") {
				document.getElementById("txtUPMethod").value = "�䲼";
			} else if(strUPMethod == "B") {
				document.getElementById("txtUPMethod").value = "�״�";
			} else if(strUPMethod == "C") {
				document.getElementById("txtUPMethod").value = "�H�Υd";
			} else if(strUPMethod == "D") {
				document.getElementById("txtUPMethod").value = "�~���״�";
			} else if(strUPMethod == "E") {
				document.getElementById("txtUPMethod").value = "�{��";
			}
			document.getElementById("txtUPDate").value = returnArray[2];			
			document.getElementById("txtUPName").value = returnArray[3];
			document.getElementById("txtUPId").value = returnArray[4];
			document.getElementById("txtUPAMT").value = returnArray[5];		
			//var strUPStatus = returnArray[6];
			document.getElementById("txtUPDesc").value = returnArray[7];
			document.getElementById("txtUPSrcGp").value = returnArray[24];
			document.getElementById("txtUPSrcCode").value = returnArray[23];
			//var strUPVoidable = returnArray[10];
			//���_
			var strUPDispatch = returnArray[11];
			//alert(strUPDispatch);
			if (strUPDispatch == "Y") {
				document.getElementById("txtUDispatch_1").checked = true;
				document.getElementById("txtUDispatch_1").value = "Y";
			} else {
				document.getElementById("txtUDispatch_2").checked = true;
				document.getElementById("txtUDispatch_2").value = "";
			}
			//�䲼�T�I
			var strUPCHKM1 = returnArray[12];
			if (strUPCHKM1 == "Y") {
				document.getElementById("txtUPCHKM1_1").checked = true;
				document.getElementById("txtUPCHKM1_1").value = "Y";
			} else {
				document.getElementById("txtUPCHKM1_2").checked = true;
				document.getElementById("txtUPCHKM1_2").value = "";
			}
			//�䲼���u
			var strUPCHKM2 = returnArray[13];
			if (strUPCHKM2 == "Y") {
				document.getElementById("txtUPCHKM2_1").checked = true;
				document.getElementById("txtUPCHKM2_1").value = "Y";
			} else {
				document.getElementById("txtUPCHKM2_2").checked = true;
				document.getElementById("txtUPCHKM2_2").value = "";
			}

			document.getElementById("txtUPRBank").value = returnArray[14];
			document.getElementById("txtUPRAccount").value = returnArray[15];
			document.getElementById("txtUPCrdNo").value = returnArray[16];
			document.getElementById("txtUPCrdEffMY").value = returnArray[17];
			document.getElementById("txtUPAuthCode").value = returnArray[19];
			document.getElementById("txtUPolNo").value = returnArray[20];
			document.getElementById("txtUAppNo").value = returnArray[21];
			document.getElementById("txtUPMEMO").value = returnArray[22];
            document.getElementById("txtCurrency").value = returnArray[25];

			document.getElementById("txtAction").value = "U";
        	WindowOnLoadCommon( document.title+"(�ק�)" , '' , strFunctionKeyUpdate,'' ) ;
            disableAll(); 
	        document.getElementById("updateArea").style.display = "block"; 
	        document.getElementById("inqueryArea").style.display = "none"; 
		}
	}
}

/*
��ƦW��:	saveAction()
��ƥ\��:	��toolbar frame ����[�x�s]���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function saveAction()
{
	mapValue();
	document.getElementById("frmMain").submit();
}

function mapValue(){
	document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value);
	document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value);
	document.getElementById("txtEntryStartDate").value = rocDate2String(document.getElementById("txtEntryStartDateC").value);
   	document.getElementById("txtEntryEndDate").value = rocDate2String(document.getElementById("txtEntryEndDateC").value);
	document.getElementById("txtUpdStartDate").value = rocDate2String(document.getElementById("txtUpdStartDateC").value);
   	document.getElementById("txtUpdEndDate").value = rocDate2String(document.getElementById("txtUpdEndDateC").value);
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbpayment.DISBPMemoServlet" id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="452" height="333" id=inqueryArea >
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="134">���ڤH�m�W�G</TD>
			<TD width="310"><INPUT class="Data" size="17" type="text" maxlength="11" id="txtPName" name="txtPName" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="134">���ڤHID�G</TD>
			<TD width="310"><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPid" name="txtPid" value=""></TD>
		<TR>
			<TD align="right" class="TableHeading" width="134">��I���A�G</TD>
			<TD width="310"><select size="1" name="selPStatus" id="selPStatus">
				<option value=""></option>
				<option value="A">A:����</option>
				<option value="B">B:���\</option>
			</select></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="134">��I���B�G</TD>
			<TD width="310"><INPUT class="Data" size="11" type="text" maxlength="30" name="txtPAMT" id="txtPAMT" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="134">�I�ڤ���G</TD>
			<TD width="310"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtPStartDateC" name="txtPStartDateC" value=""
				readOnly> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> ~ <INPUT
				class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC"
				name="txtPEndDateC" value="" readOnly> <a
				href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtPEndDate" id="txtPEndDate" value=""></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="134">��J����G</TD>
			<TD width="310"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtEntryStartDateC" name="txtEntryStartDateC"
				value="" readOnly> <a
				href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtEntryStartDate" id="txtEntryStartDate"
				value=""> ~ <INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtEntryEndDateC" name="txtEntryEndDateC" value="" readOnly> <a
				href="javascript:show_calendar('frmMain.txtEntryEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtEntryEndDate" id="txtEntryEndDate" value="">
			</TD>
		</tr>

		<TR>
			<TD align="right" class="TableHeading" width="134">�״ڻȦ�N���G</TD>
			<TD width="310"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPRBank" id="txtPRBank" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="134">�״ڻȦ�b���G</TD>
			<TD width="310"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPRAccount" id="txtPRAccount" value=""></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="134">�H�Υd���X�G</TD>
			<TD width="310"><INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCrdNo" name="txtPCrdNo" value=""></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" width="134">���ʤ���G</TD>
			<TD width="310"><INPUT class="Data" size="11"
				type="text" maxlength="11" id="txtUpdStartDateC"
				name="txtUpdStartDateC" value="" readOnly> <a
				href="javascript:show_calendar('frmMain.txtUpdStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtUpdStartDate" id="txtUpdStartDate" value="">
			~ <INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtUpdEndDateC" name="txtUpdEndDateC" value="" readOnly> <a
				href="javascript:show_calendar('frmMain.txtUpdEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtUpdEndDate" id="txtUpdEndDate" value=""></TD>
		<TR>
			<TD align="right" class="TableHeading" width="134">�@�o�_�G</TD>
			<TD width="310"><select size="1" name="selPVoidable" id="selPVoidable">
				<option value=""></option>
				<option value="Y">�O</option>
				<option value="N">�_</option>
			</select></TD>
		<TR>
			<TD align="right" class="TableHeading" width="134">���_�G</TD>
			<TD width="310"><select size="1" name="selDispatch" id="selDispatch">
				<option value=""></option>
				<option value="Y">�O</option>
				<option value="N">�_</option>
			</select></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="134">�O�渹�X�G</TD>
			<TD width="310"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtPolicyNo" id="txtPolicyNo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="134">�n�O�Ѹ��X�G</TD>
			<TD height="24" width="310"><INPUT class="Data" size="11" type="text" maxlength="11" name="txtAppNo" id="txtAppNo" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="134">���O�G</TD>
			<TD width="310"><select size="1" name="selCurrency" id="selCurrency"><%=sbCurrCash.toString()%></select></TD>
		</TR>
	</TBODY>
</TABLE>

<TABLE border="1" width="500" id=updateArea name=updateArea style="display: none">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="150">��I�Ǹ��G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="25" name="txtUPNO" id="txtUPNO" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">��I���O�G</TD>
			<TD><INPUT class="DATA" size="50" type="text" maxlength="50" name="txtUPMEMO" id="txtUPMEMO"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">���ڤH�m�W�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="30" type="text" maxlength="30" id="txtUPName" name="txtUPName" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">���ڤHID�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPid" name="txtUPid" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">���O�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtCurrency" id="txtCurrency" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">��I���B�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPAMT" id="txtUPAMT" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24">�I�ڤ���G</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPDate" name="txtUPDate" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">��I�y�z�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="37" type="text" maxlength="11" name="txtUPDesc" id="txtUPDesc" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�I�ڤ覡�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPMethod" name="txtUPMethod" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�״ڻȦ�N���G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPRBank" id="txtUPRBank" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�״ڻȦ�b���G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="14" type="text" maxlength="11" name="txtUPRAccount" id="txtUPRAccount" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�H�Υd���X�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPCrdNo" name="txtUPCrdNo" value="" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�d�O�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtPUCrdType" name="txtPUCrdType" value="" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">���ĺI���~�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPCrdEffMY" name="txtUPCrdEffMY" value="" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">���v�X�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtUPAuthCode" name="txtUPAuthCode" value="" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">���_�G</TD>
			<TD><input type="radio" name="txtUDispatch"
				id="txtUDispatch_1" Value="Y" disabled>�O <input type="radio"
				name="txtUDispatch" id="txtUDispatch_2" Value="" disabled>�_</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�䲼�T�I�G</TD>
			<TD><input type="radio" name="txtUPCHKM1"
				id="txtUPCHKM1_1" Value="Y" disabled>�O <input type="radio"
				name="txtUPCHKM1" id="txtUPCHKM1_2" Value="" disabled>�_</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�䲼���u�G</TD>
			<TD><input type="radio" name="txtUPCHKM2"
				id="txtUPCHKM2_1" Value="Y" disabled>�O <input type="radio"
				name="txtUPCHKM2" id="txtUPCHKM2_2" Value="" disabled>�_</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�O�渹�X�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPolNo" id="txtUPolNo"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" height="24"> �n�O�Ѹ��X�G</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUAppNo" id="txtUAppNo"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">��I��]�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="28" type="text" maxlength="11" name="txtUPSrcCode" id="txtUPSrcCode" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading">�ӷ��s�աG</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtUPSrcGp" id="txtUPSrcGp" readOnly></TD>
		</TR>
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=request.getParameter("txtAction")%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>