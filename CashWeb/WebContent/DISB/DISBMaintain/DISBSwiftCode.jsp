<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : SWIFT CODE ���@�e��
 * 
 * Remark   : �޲z�t��-�]��
 * 
 * Revision : $Revision: 1.4 $
 * 
 * Author   : William wu
 * 
 * Create Date : 2013/02/18 
 * 
 * Request ID : RA0074
 * 
 * CVS History:
 * 
 * $Log: DISBSwiftCode.jsp,v $
 * Revision 1.4  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.3  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 *
 *  
 */
%><%!String strThisProgId = "DISBSwiftCode"; //���{���N��%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String)request.getAttribute("txtMsg"):"";
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�޲z�t��--��~ SWIFT CODE ���@</TITLE>
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
	if( document.getElementById("txtAction").value == "I" ) {
		var strSql = "select * from ORCHSWFT WHERE 1=1 ";
		if( document.getElementById("txtBKNO").value != "" ) {
			strSql += " AND BANK_NO = '" + document.getElementById("txtBKNO").value + "' ";
		}
		if( document.getElementById("txtSWFT").value != "" ) {
			strSql += " AND SWIFT_CODE LIKE '^" + document.getElementById("txtSWFT").value + "^' ";
		}
		if( document.getElementById("txtBKNM").value != "" ) {
			strSql += " AND BANK_NAME LIKE '^" + document.getElementById("txtBKNM").value + "^' ";
		}
		strSql += " ORDER BY BANK_NO,BANK_NAME,SWIFT_CODE ";

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
		<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	    session.setAttribute("Heading","���ľ��c�N�X,�Ȧ�W��,SWFIT CODE");
	    session.setAttribute("DisplayFields", "BANK_NO,BANK_NAME,SWIFT_CODE");
	    session.setAttribute("ReturnFields", "BANK_NO,BANK_NAME,SWIFT_CODE");
	    %>		//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:600px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" ) {		
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtBKNO").value = returnArray[0];
			document.getElementById("txtSWFT").value = returnArray[1];				
			document.getElementById("txtBKNM").value = returnArray[2];			

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

	if (document.getElementById("txtBKNO").value.length != 3 || !isNumber(document.getElementById("txtBKNO").value)) {
		strTmpMsg += "���ľ��c�N�X��3�X�Ʀr\r\n";
	}
	if (document.getElementById("txtBKNM").value == "") {
		strTmpMsg += "�Ȧ�W�٤��i�ť�\r\n";
	}
	if (document.getElementById("txtSWFT").value == "") {
		strTmpMsg += "SWIFT CODE���i�ť�\r\n";
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

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBSwiftCode.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post"  action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBSwiftCodeManageServlet">
<TABLE border="1" width="450">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="200">���ľ��c�N�X�G</TD>
			<TD><INPUT class="Key" size="7" type="text" maxlength="3" name="txtBKNO" id="txtBKNO" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="200">�Ȧ�W�١G</TD>
			<TD><INPUT class="Data" size="45" type="text" maxlength="60" name="txtBKNM" id="txtBKNM" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="200">SWIFT CODE�G</TD>
			<TD><INPUT class="Data" size="45" type="text" maxlength="11" name="txtSWFT" id="txtSWFT" value="" style="text-transform: uppercase;"></TD>
		</TR>
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>