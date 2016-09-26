<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : �s�W�ꤺ������
 * 
 * Remark   : �޲z�t��-�]��
 * 
 * Revision : $Revision: 1.10 $
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 2010/11/23 02:21:59
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DISBCAPccbfCreate.jsp,v $
 * Revision 1.10  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.9  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 *
 * Revision 1.5  2012/06/18 09:35:41  MISSALLY
 * QA0132-�����ɮפ� SWIFT CODE�ɮ׺��@
 * 1.�\��u�s�W����X�v�W�[�ˮ֤��o���ŭȡC
 * 2.�\��u����Ȧ��ɡv
 *    2.1��~SWIFT CODE�e�����áC
 *    2.2�W�[�ˮ֤��o�W�Ǫ��ɡC
 *    2.3�W�[�ˮ֪���N�X���ץ�����7��Ʀr�A�_�h��ܥ��Ѫ��O���F�Y����ɦ����~�T���h��������s�A�B��ܥ��Ѫ��O���C
 *
 *  
 */
%><%!String strThisProgId = "DISBCAPccbf"; //���{���N��%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�޲z�t��--���@����Ȧ���</TITLE>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" )
	{
		alert(document.getElementById("txtMsg").value);
	}

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' );	//�s�WA+�d��I
	window.status = "�Y�n�ק���,�i�g�Ѭd�ߥ\���A�i�J";

	if ( document.getElementById("txtAction").value == "U" ) {
		WindowOnLoadCommon( document.title , '' , strFunctionKeyUpdate,'' );//�x�sS+���}E
	}
}

/* ��toolbar frame ����<�d��>���s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
{
	// R60463
	if( document.getElementById("txtAction").value == "I" ) {
		var strSql = "select * from CAPCCBF WHERE 1=1 ";
		if( document.getElementById("txtBKNO").value != "" ) {
			strSql += " AND BANK_NO = '" + document.getElementById("txtBKNO").value + "' ";
		}
		if( document.getElementById("txtBKNM").value != "" ) {
			strSql += " AND BANK_NAME LIKE '^" + document.getElementById("txtBKNM").value + "^' ";
		}
		if( document.getElementById("txtBKFNM").value != "" ) {
			strSql += " AND BANK_F_NAME LIKE '^" + document.getElementById("txtBKFNM").value + "^' ";
		}
		strSql += " ORDER BY BANK_NO,BANK_F_NAME,BANK_NAME ";

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
		<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	    session.setAttribute("Heading","����X,²��,���W");
	    session.setAttribute("DisplayFields", "BANK_NO,BANK_NAME,BANK_F_NAME");
	    session.setAttribute("ReturnFields", "BANK_NO,BANK_NAME,BANK_F_NAME");
	    %>
		//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:600px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" ) {		
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtBKNO").value = returnArray[0];
			document.getElementById("txtBKNM").value = returnArray[1];			
			document.getElementById("txtBKFNM").value = returnArray[2];				

			disableAll();
			WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry,'' ) ; //�ק�,�R��,���}
		}
	}
}

/* ��toolbar frame ����<�s�W>���s�Q�I���,����Ʒ|�Q���� */
function addAction()
{
	document.getElementById("txtAction").value = "C";

	if( areAllFieldsOK() ) {
		document.getElementById("frmMain").submit();
	}
}

/* ��toolbar frame ����<�ק�>�s�Q�I���,����Ʒ|�Q���� */
function updateAction() 
{
	enableData();
	WindowOnLoadCommon( document.title, '', strFunctionKeyUpdate, '' );// �x�sS+���}E
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
	document.getElementById("txtMsg").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBCAPccbfCreate.jsp";
}

/* ��toolbar frame ����<�x�s>���s�Q�I���,����Ʒ|�Q���� */
function saveAction()
{
	document.getElementById("txtAction").value = "S";

	enableAll();
	if( areAllFieldsOK() ) {
		document.getElementById("frmMain").submit();
	}
}

function areAllFieldsOK()
{
	var strTmpMsg = "";

	if (document.getElementById("txtBKNO").value.length != 7) {
		strTmpMsg += "����X��7�X�Ʀr\r\n";
	}
	if (document.getElementById("txtBKNM").value == "") {
		strTmpMsg += "�Ȧ�²�٤��i�ť�\r\n";
	}
	if (document.getElementById("txtBKFNM").value == "") {
		strTmpMsg += "�Ȧ���W���i�ť�\r\n";
	}

	if(strTmpMsg != "") {
		alert(strTmpMsg);
		return false;
	} else {
		return true;
	}
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
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBCAPccbfServlet">
<TABLE border="1" width="450">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="74">����N�X�G</TD>
			<TD><INPUT class="Key" size="7" type="text" maxlength="7" name="txtBKNO" id="txtBKNO" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="74">�Ȧ�²�١G</TD>
			<TD><INPUT class="Data" size="10" type="text" maxlength="5" name="txtBKNM" id="txtBKNM" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="74">�Ȧ���W�G</TD>
			<TD><INPUT class="Data" size="40" type="text" maxlength="20" name="txtBKFNM" id="txtBKFNM" value=""></TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>