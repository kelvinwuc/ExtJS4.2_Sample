<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : �d��SWIFT CODE
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.9 $
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 2010/11/23 02:21:59
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DISBCAPswiftInq.jsp,v $
 * Revision 1.9  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.8  2013/04/12 06:10:25  MISSALLY
 * RA0074 FNE�����ͦs�����q�H�b��ε��I
 *
 * Revision 1.7  2013/02/26 10:10:36  ODCWilliam
 * william wu
 * RA0074
 *
 * Revision 1.6  2012/08/29 07:07:59  ODCWilliam
 * *** empty log message ***
 *
 * Revision 1.5  2012/08/29 03:43:42  ODCWilliam
 * modify:william
 * date:2012-08-12
 *
 * Revision 1.4  2012/06/18 09:35:40  MISSALLY
 * QA0132-�����ɮפ� SWIFT CODE�ɮ׺��@
 * 1.�\��u�s�W����X�v�W�[�ˮ֤��o���ŭȡC
 * 2.�\��u����Ȧ��ɡv
 *    2.1��~SWIFT CODE�e�����áC
 *    2.2�W�[�ˮ֤��o�W�Ǫ��ɡC
 *    2.3�W�[�ˮ֪���N�X���ץ�����7��Ʀr�A�_�h��ܥ��Ѫ��O���F�Y����ɦ����~�T���h��������s�A�B��ܥ��Ѫ��O���C
 *
 *  
 */
%><%!String strThisProgId = "DISBCAPswiftInq"; //���{���N��%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�޲z�t��--�d�߰�~����Ȧ�SWIFT CODE��</TITLE>
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
	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ); //�d��I
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
	    %>
		//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:600px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" ) {		
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtBKNO").value = returnArray[0];
			document.getElementById("txtSWFT").value = returnArray[1];				
			document.getElementById("txtBKNM").value = returnArray[2];			

			document.getElementById("txtBKNO").readOnly = true;
			document.getElementById("txtSWFT").readOnly = true;
			document.getElementById("txtBKNM").readOnly = true;

			WindowOnLoadCommon( document.title, '', strDISBFunctionKeyExit, '' ) ; //���}
		}
	}
}

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBCAPswiftInq.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<FORM id="frmMain" name="frmMain" method="post">
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
</FORM>
</BODY>
</HTML>