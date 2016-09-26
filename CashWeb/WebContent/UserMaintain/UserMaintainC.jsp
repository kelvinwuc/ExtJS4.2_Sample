<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%!
/**
 * System   : 
 * 
 * Function : �ϥΪ̸�ƺ��@
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.10 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date: ${date}
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: UserMaintainC.jsp,v $
 * Revision 1.10  2014/07/18 07:38:25  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.9  2013/12/24 04:17:10  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.8  2013/01/09 03:28:12  MISSALLY
 * 1.Calendar problem
 * 2.showModalDialog
 *
 * Revision 1.7  2013/01/08 04:25:58  MISSALLY
 * �N���䪺�{��Merge��HEAD
 *
 * Revision 1.3.4.1  2012/12/06 06:28:29  MISSALLY
 * RA0102�@PA0041
 * �t�X�k�O�ק�S����I�@�~
 *
 * Revision 1.3  2011/08/31 07:28:19  MISSALLY
 * R10231
 * CASH�t�ηs�W�U���z�ߵ��I���Ӫ�
 *
 * Revision 1.2  2011/08/09 01:34:10  MISSALLY
 * Q10256�@ ����CASH�t�ο��~�L�k�]�X����
 *
 *  
 */
%><%
String strMsg = request.getParameter("txtMsg")==null?"":request.getParameter("txtMsg");
CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
Calendar  calendar = commonUtil.getBizDateByRCalendar();

Connection conn = null;
Statement stmt = null;
PreparedStatement pstmt = null;
ResultSet rst = null;
StringBuffer sbUserType = new StringBuffer();
StringBuffer sbGroup = new StringBuffer();

String strAction = request.getParameter("txtAction");
if( strAction == null )
	strAction = "";
String strUserId = request.getParameter("txtUserId");
if( strUserId == null )
	strUserId = "";
String strUserName = "";
String strUserStatus = "";
String strUserType = "";
String strDefaultGroup = "";
String strUserDept = "";
String strUserRight = "";
String strRemark = "";
String strEmail = "";
String strPasswordValidDay = "";
String strUserStatusDate = "";
String strLastPasswordDate = "";
String strRegDate = "";
String strLastLogonDate = "";
String strORGLastPasswordDate = "";
/*RC0036*/
String strUserArea = "";
String strUserBrch = "";

try {
	conn = uiThisUserInfo.getDbFactory().getConnection("UserMaintain");

	if(strAction.equalsIgnoreCase("I"))	//�d��
	{
		pstmt = conn.prepareStatement("select * from USER where USRID = ? ");
		pstmt.setString(1, strUserId);
		rst = pstmt.executeQuery();
		if( !rst.next() ) {
			strMsg = "�ϥΪ̥N�� '"+strUserId+"' ���s�b���Ʈw��";
		} else {
			strUserName = CommonUtil.AllTrim(rst.getString("USRNAM"));
			strUserStatus = CommonUtil.AllTrim(rst.getString("STAT"));
			strUserType = CommonUtil.AllTrim(rst.getString("USRTYP"));
			strDefaultGroup = CommonUtil.AllTrim(rst.getString("DFTGRP"));
			strUserDept = CommonUtil.AllTrim(rst.getString("DEPT"));
			strUserRight = CommonUtil.AllTrim(rst.getString("USRAUTH"));
			strRemark = CommonUtil.AllTrim(rst.getString("REMARK"));
			strEmail = CommonUtil.AllTrim(rst.getString("Email"));
			strPasswordValidDay = CommonUtil.AllTrim(rst.getString("PWDVAL"));
			strUserStatusDate = CommonUtil.AllTrim(rst.getString("STSDTE"));
			strLastPasswordDate = CommonUtil.AllTrim(rst.getString("LPWDTE"));
			strRegDate = CommonUtil.AllTrim(rst.getString("REGDTE"));
			strLastLogonDate = CommonUtil.AllTrim(rst.getString("LLOGD"));
			strUserArea = CommonUtil.AllTrim(rst.getString("USRAREA")); //RC0036
			strUserBrch = CommonUtil.AllTrim(rst.getString("USRBRCH")); //RC0036
			strORGLastPasswordDate = strLastLogonDate;
		}
	}

	stmt = conn.createStatement();
	rst = stmt.executeQuery("select * from USERTYPE");
	while (rst.next()) {
		if(CommonUtil.AllTrim(rst.getString("USRTYP")).equalsIgnoreCase(strUserType))
			sbUserType.append("<option value=\"").append(rst.getString("USRTYP")).append("\" selected=\"selected\">").append(rst.getString("TYPNME")).append("</option>");
		else
			sbUserType.append("<option value=\"").append(rst.getString("USRTYP")).append("\">").append(rst.getString("TYPNME")).append("</option>");
	}

	rst = stmt.executeQuery("select * from FGROUP");
	while (rst.next()) {
		if(CommonUtil.AllTrim(rst.getString("GRPID")).equalsIgnoreCase(strDefaultGroup))
			sbGroup.append("<option value=\"").append(rst.getString("GRPID")).append("\" selected=\"selected\">").append(rst.getString("GRPNAM")).append("</option>");
		else
			sbGroup.append("<option value=\"").append(rst.getString("GRPID")).append("\">").append(rst.getString("GRPNAM")).append("</option>");
	}
} catch (SQLException ex) {
	System.err.println(ex);
} finally {
	try { if(rst != null) rst.close(); } catch (Exception e) { }
	try { if(pstmt != null) pstmt.close(); } catch (Exception e) { }
	try { if(stmt != null) stmt.close(); } catch (Exception e) { }
	try { if(conn != null) uiThisUserInfo.getDbFactory().releaseConnection(conn); } catch (Exception e) { }
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<META http-equiv="Content-Style-Type" content="text/css">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>�ϥΪ̸�ƺ��@</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 			= "txtUserId";			//�Ĥ@�ӥi��J��Key���W��
var strFirstData 			= "txtPassword";		//�Ĥ@�ӥi��J��Data���W��

//*************************************************************
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
	if( document.getElementById("txtMsg").value != "" ) {
		window.alert(document.getElementById("txtMsg").value);
		document.getElementById("txtMsg").value = "";
	}

	if( document.getElementById("txtAction").value == "I" ) {
		WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry,'' ) ;
		window.status = "�ثe���d�ߪ��A,�Y�n�ק�ΧR�����,�Х���ܭק�ΧR���\����";
	} else {
		WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' );
		window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
	}
	disableAll();
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
	if( objThisItem.name == "txtUserId" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg += "�ϥΪ̥N�����i�ť�\r\n";
				bReturnStatus = false;
			}
		}
	}
	if( objThisItem.name == "txtPasswordConfirm" )
	{
		if( objThisItem.value != document.all("txtPassword").value )
		{
			strTmpMsg += "�T�{�ϥΪ̱K�X�����P�ϥΪ̱K�X�ۦP\r\n";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "txtPasswdValidDays" )
	{
		if( objThisItem.value == "" )
		{
			objThisItem.value = "0";
		}
		var i=0;
		for(i=0;i<objThisItem.value.length;i++)
		{
			if( objThisItem.value.charAt(i) > '9'  || objThisItem.value.charAt(i) < '0' )
			{
				strTmpMsg += "�K�X���Ĥ�ƥ������Ʀr\r\n";
				bReturnStatus = false;
			}
		}
	}
	if( objThisItem.name == "selUserType" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg += "�п�ܨϥΪ����O\r\n";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "selDefaultGroup" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg += "�п�ܥ\��s��\r\n";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "selUserDept" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg += "�п�ܨϥΪ̳���\r\n";
			bReturnStatus = false;
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

/*
��ƦW��:	addAction()
��ƥ\��:	��toolbar frame �����s�W���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function addAction()
{
	var dteDate = new Date();
	strOut =  "0000"+ (dteDate.getFullYear() - 1911) + "/" ;
	strOut = strOut.substring(strOut.length-4,strOut.length);
	if( dteDate.getMonth() + 1 < 10 ) {
		strOut += "0"+(dteDate.getMonth()+1)+"/";
	} else {
		strOut += (dteDate.getMonth()+1)+"/";
	}
	if( dteDate.getDate() < 10 ) {
		strOut += "0"+dteDate.getDate();
	} else {
		strOut += dteDate.getDate();
	}

	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
	document.getElementById("txtAction").value = "A";
	// �����w�]��
	document.getElementById("txtUserStatusDate").value = strOut;
	document.getElementById("txtRegDate").value = strOut;
	//�]�w���ť�, �j���U��Logon�ݭק�K�X
	document.getElementById("txtLastPasswordDate").value = "";

	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/*
��ƦW��:	inquiryAction()
��ƥ\��:	��toolbar frame �����d�߫��s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function inquiryAction()
{
	winToolBar.ShowButton( strFunctionKeyInquiry1 );
	enableKey();
	enableData();
	document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus();
	}
}

/*
��ƦW��:	resetAction()
��ƥ\��:	��toolbar frame �����M�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/*
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��    :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function exitAction()
{
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	WindowOnLoad();
}

/*
��ƦW��:	confirmAction()
��ƥ\��:	��toolbar frame �����T�w���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function confirmAction()
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

		 modalDialog �|�Ǧ^�ϥΪ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}
		*/
		var strSql = "select * from USER where 1 = 1 ";
		if( document.getElementById("txtUserId").value != "" )
			strSql += " and USRID = '"+document.getElementById("txtUserId").value.toUpperCase() +"' ";
		if( document.getElementById("txtUserName").value != "" )
			strSql += " and USRNAM = '"+document.getElementById("txtUserName").value +"' ";

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading","�ϥΪ̥N��,�ϥΪ̩m�W,�s�եN��,�̪�n�����");
	session.setAttribute("DisplayFields", "USRID,USRNAM,DFTGRP,LLOGD");
	session.setAttribute("ReturnFields", "USRID");
%>
		//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		if( strReturnValue != "" )
		{
			enableAll();
			document.getElementById("txtUserId").value = strReturnValue;
			document.getElementById("txtAction").value = "I";
			document.getElementById("frmMain").action = "UserMaintainC.jsp";
			document.getElementById("frmMain").submit();
		}
	}
}

/*
��ƦW��:	updateAction()
��ƥ\��:	��toolbar frame �����ק���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );
	disableKey();
	enableData();
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstData) != null )
			document.getElementById(strFirstData).focus() ;
	}
	document.getElementById("txtAction").value = "U";
}

/*
��ƦW��:	saveAction()
��ƥ\��:	��toolbar frame �����x�s���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function saveAction()
{
	enableAll();
	if( areAllFieldsOK() )
	{
		document.getElementById("txtUserId").value = document.getElementById("txtUserId").value.toUpperCase();
		document.getElementById("frmMain").action = "UserMaintainS.jsp";
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}

/*
��ƦW��:	deleteAction()
��ƥ\��:	��toolbar frame �����R�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function deleteAction()
{
	var bConfirm = window.confirm("�O�_�T�w�R���ӵ����?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "D";
		document.getElementById("frmMain").action = "UserMaintainS.jsp";
		document.getElementById("frmMain").submit();
	}
}
//-->
</script>
</head>
<body onload="WindowOnLoad();">
<form id="frmMain" name="frmMain" method="post" action="">
<CENTER>
<TABLE width="630" border="1">
	<TBODY>
    	<TR>
        	<TD width="120" align="right" class="TableHeading">�ϥΪ̥N���G</TD>
            <TD width="200" align="left"><INPUT class="Key" size="10" type="text" maxlength="10" id="txtUserId" name="txtUserId"  value="<%=strUserId%>" onblur="checkClientField(this,true);"></TD>
            <TD width="160" align="right" class="TableHeading">�ϥΪ̱K�X�G</TD>
            <TD width="150" align="left"><INPUT  class="Data" size="12" type="password" maxlength="12" id="txtPassword" name="txtPassword"  value=""  onblur="checkClientField(this,true);"></TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">�ϥΪ̦W�١G</TD>
            <TD align="left"><INPUT  class="Data" size="18" type="text" maxlength="30" id="txtUserName" name="txtUserName"  value="<%=strUserName%>"  onblur="checkClientField(this,true);"></TD>
            <TD align="right" class="TableHeading">�T�{�ϥΪ̱K�X�G</TD>
            <TD align="left"><INPUT  class="Data" size="12" type="password" maxlength="12" id="txtPasswordConfirm" name="txtPasswordConfirm"  value=""  onblur="checkClientField(this,true);"></TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">�ϥΪ̪��A�G</TD>
            <TD align="left">
            	<INPUT  class="Data" type="radio" id="radUserStatus" name="radUserStatus" value="A"  onblur="checkClientField(this,true);"  <%=strUserStatus.equalsIgnoreCase("A")?"checked=\"checked\"":""%>>���` 
            	<INPUT  class="Data" type="radio" id="radUserStatus" name="radUserStatus"  value="I"  onblur="checkClientField(this,true);"  <%=strUserStatus.equalsIgnoreCase("I")?"checked=\"checked\"":""%>>����
            	<BR><INPUT  class="Data" type="radio" id="radUserStatus" name="radUserStatus"  value="R"  onblur="checkClientField(this,true);"  <%=strUserStatus.equalsIgnoreCase("R")?"checked=\"checked\"":""%>>���U��
            	<input  class="Data" type="radio" id="radUserStatus" name="radUserStatus"  value="E"  onBlur="checkClientField(this,true);"  <%=strUserStatus.equalsIgnoreCase("E")?"checked=\"checked\"":""%>>��¾
            </TD>
            <TD align="right" class="TableHeading">���A�ͮĤ��:</TD>
            <TD align="left"><INPUT  class="Data" size="10" type="text" maxlength="10" id="txtUserStatusDate" name="txtUserStatusDate"  readonly value="<%=strUserStatusDate%>"  onblur="checkClientField(this,true);"></TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">�K�X���Ĥ��:</TD>
            <TD align="left"><INPUT class="Data" size="3" type="text" maxlength="4" id="txtPasswordValidDay" name="txtPasswordValidDay"  value="30"  onblur="checkClientField(this,true);"></TD>
            <TD align="right" class="TableHeading">�̪�K�X�ק����G</TD>
            <TD align="left">
            	<INPUT  class="Data" size="10" type="text" maxlength="10" id="txtLastPasswordDate" name="txtLastPasswordDate"  readonly value="<%=strLastPasswordDate%>"  onblur="checkClientField(this,true);">
            	<a href="javascript:show_calendar('frmMain.txtLastPasswordDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');" ><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
            </TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">�ϥΪ����O�G</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserType" name="selUserType">
            		<option value="">�п��</option>
            		<%=sbUserType.toString()%>
            	</SELECT>
            </TD>
            <TD align="right" class="TableHeading">���U���:</TD>
            <TD align="left">
            	<INPUT class="Data" size="10" type="text" maxlength="10" id="txtRegDate" name="txtRegDate"  value="<%=strRegDate%>"  onblur="checkClientField(this,true);">
            	<a href="javascript:show_calendar('frmMain.txtRegDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');" ><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
            </TD>
        </TR>
        <TR>
            <TD align="right" class="TableHeading">�\��s�աG</TD>
            <TD align="left">
            	<SELECT class="Data" id="selDefaultGroup" name="selDefaultGroup">
            		<option value="">�п��</option>
            		<%=sbGroup.toString()%>
            	</SELECT>
            </TD>
            <TD  align="right" class="TableHeading">��I��Ƭd���v��:</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserRight" name="selUserRight">
            		<option value="99" <%=strUserRight.equalsIgnoreCase("99")?"selected=\"selected\"":""%>>�Ҧ����</option>
            		<option value="89" <%=strUserRight.equalsIgnoreCase("89")?"selected=\"selected\"":""%>>���ݳ������</option>
            		<option value="79" <%=strUserRight.equalsIgnoreCase("79")?"selected=\"selected\"":""%>>���ݿ�J�H�����</option>
            	</SELECT>
            </TD>
        </TR>
        <TR>
            <TD  align="right" class="TableHeading">�ϥΪ̳����G</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserDept" name="selUserDept">
            		<option value="">�п��</option>
            	  	<option value="MIS" <%=strUserDept.equalsIgnoreCase("MIS")?"selected=\"selected\"":""%>>MIS</option>
            		<option value="FIN" <%=strUserDept.equalsIgnoreCase("FIN")?"selected=\"selected\"":""%>>FIN</option>
            		<option value="ACCT" <%=strUserDept.equalsIgnoreCase("ACCT")?"selected=\"selected\"":""%>>ACCT</option>            		
            		<option value="CSC" <%=strUserDept.equalsIgnoreCase("CSC")?"selected=\"selected\"":""%>>CSC</option>
            		<option value="NB" <%=strUserDept.equalsIgnoreCase("NB")?"selected=\"selected\"":""%>>NB</option>
            		<option value="PA" <%=strUserDept.equalsIgnoreCase("PA")?"selected=\"selected\"":""%>>PA</option>
            		<option value="GP" <%=strUserDept.equalsIgnoreCase("GP")?"selected=\"selected\"":""%>>���I��F</option>
            		<option value="GPH" <%=strUserDept.equalsIgnoreCase("GPH")?"selected=\"selected\"":""%>>���I�z��</option>
            		<option value="CLM" <%=strUserDept.equalsIgnoreCase("CLM")?"selected=\"selected\"":""%>>���I�z��</option>
            		<option value="080" <%=strUserDept.equalsIgnoreCase("080")?"selected=\"selected\"":""%>>080</option>
            		<option value="CLH" <%=strUserDept.equalsIgnoreCase("CLH")?"selected=\"selected\"":""%>>���</option>
            		<option value="MDS" <%=strUserDept.equalsIgnoreCase("MDS")?"selected=\"selected\"":""%>>MDS</option>
            		<option value="IA" <%=strUserDept.equalsIgnoreCase("IA")?"selected=\"selected\"":""%>>�]��</option>
            		<option value="SPA" <%=strUserDept.equalsIgnoreCase("SPA")?"selected=\"selected\"":""%>>�~�ȳW����F�B</option>
<!--RC0036-->    	<option value="PCD" <%=strUserDept.equalsIgnoreCase("PCD")?"selected=\"selected\"":""%>>���O�B</option>
<!--RC0036-->       <option value="TYB" <%=strUserDept.equalsIgnoreCase("TYB")?"selected=\"selected\"":""%>>�������q</option>
<!--RC0036-->       <option value="TCB" <%=strUserDept.equalsIgnoreCase("TCB")?"selected=\"selected\"":""%>>�x�������q</option>
<!--RC0036-->       <option value="TNB" <%=strUserDept.equalsIgnoreCase("TNB")?"selected=\"selected\"":""%>>�x�n�����q</option>
<!--RC0036-->       <option value="KHB" <%=strUserDept.equalsIgnoreCase("KHB")?"selected=\"selected\"":""%>>���������q</option>
            	</SELECT>
            </TD>
            <TD  align="right" class="TableHeading">�̪�@���n�����:</TD>
            <TD align="left"><INPUT  class="Data" size="10" type="text" maxlength="10" name="txtLastLogonDate" id="txtLastLogonDate"  readonly value="<%=strLastLogonDate%>"  onblur="checkClientField(this,true);"></TD>
        </TR>
<!--RC0036-->        
        <TR>
            <TD  align="right" class="TableHeading">¾��G</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserArea" name="selUserArea">
            		<option value="">�п��</option>
           	        <option value="   " <%=strUserArea.equalsIgnoreCase("   ")?"selected=\"selected\"":""%>>   </option>            
                    <option value="LIO" <%=strUserArea.equalsIgnoreCase("LIO")?"selected=\"selected\"":""%>>LIO</option>
            		<option value="CS1" <%=strUserArea.equalsIgnoreCase("CS1")?"selected=\"selected\"":""%>>CS1</option>
 		            		
            	</SELECT>
            </TD>
<!--RC0036-->               
            <TD  align="right" class="TableHeading">���B:</TD>
            <TD align="left">
            	<SELECT class="Data" id="selUserBrch" name="selUserBrch">
            		<option value="">�п��</option>
                    <option value="   " <%=strUserBrch.equalsIgnoreCase("   ")?"selected=\"selected\"":""%>>   </option>   
            	    <option value="TPE" <%=strUserBrch.equalsIgnoreCase("TPE")?"selected=\"selected\"":""%>>TPE</option>
            		<option value="PCH" <%=strUserBrch.equalsIgnoreCase("PCH")?"selected=\"selected\"":""%>>PCH</option>
            	    <option value="KL" <%=strUserBrch.equalsIgnoreCase("KL")?"selected=\"selected\"":""%>>KL</option>
            		<option value="IL" <%=strUserBrch.equalsIgnoreCase("IL")?"selected=\"selected\"":""%>>IL</option>            		
            	    <option value="HC" <%=strUserBrch.equalsIgnoreCase("HC")?"selected=\"selected\"":""%>>HC</option>
            		<option value="ML" <%=strUserBrch.equalsIgnoreCase("ML")?"selected=\"selected\"":""%>>ML</option>
            	    <option value="CTN" <%=strUserBrch.equalsIgnoreCase("CTN")?"selected=\"selected\"":""%>>CTN</option>
            		<option value="CH" <%=strUserBrch.equalsIgnoreCase("CH")?"selected=\"selected\"":""%>>CH</option>
            		<option value="YL" <%=strUserBrch.equalsIgnoreCase("YL")?"selected=\"selected\"":""%>>YL</option>
            	    <option value="CY" <%=strUserBrch.equalsIgnoreCase("CY")?"selected=\"selected\"":""%>>CY</option>
            		<option value="XY" <%=strUserBrch.equalsIgnoreCase("XY")?"selected=\"selected\"":""%>>XY</option>            		
            	    <option value="PT" <%=strUserBrch.equalsIgnoreCase("PT")?"selected=\"selected\"":""%>>PT</option>
            		<option value="HL" <%=strUserBrch.equalsIgnoreCase("HL")?"selected=\"selected\"":""%>>HL</option>
            	    <option value="TTG" <%=strUserBrch.equalsIgnoreCase("TTG")?"selected=\"selected\"":""%>>TTG</option>
            		<option value="KMN" <%=strUserBrch.equalsIgnoreCase("KMN")?"selected=\"selected\"":""%>>KMN</option>
            		<option value="PH" <%=strUserBrch.equalsIgnoreCase("PH")?"selected=\"selected\"":""%>>PH</option>                  		      		            		            		
            	</SELECT>
            </TD>
        </TR>
        <TR>
            <TD  align="right" class="TableHeading">�ơ@ ���G</TD>
            <TD align="left"><INPUT  class="Data" size="18" type="text" maxlength="200" id="txtRemark" name="txtRemark"  value="<%=strRemark%>"  onblur="checkClientField(this,true);"></TD>
            <TD  align="right" class="TableHeading"><font size=2>�q�l�l�c�b���G</font></TD>
            <TD align="left"><INPUT  class="Data" size="20" type="text" maxlength="60" id="txtEmail" name="txtEmail"  value="<%=strEmail%>"  onblur="checkClientField(this,true);"></TD>
        </TR>
    </TBODY>
</TABLE><br>
<table border="0" width=630 cellspacing="0" cellpadding="0" id="copyright">
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'>
	        <Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: �s�ө���;">�ۧ@�v�Ҧ����y�H��</font>
        </td>
	</tr>
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'><Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: �s�ө���;"> 		
		<script language=JavaScript >
        var dteDate = new Date( document.lastModified );
        var strOut = '��s���:';
        if( dteDate.getMonth() + 1 < 10 )
    	    strOut += "0"+(dteDate.getMonth()+1)+"/";
        else
	        strOut += (dteDate.getMonth()+1)+"/";
        if( dteDate.getDate() < 10 )
	        strOut += "0"+dteDate.getDate()+"/";
        else
	        strOut += dteDate.getDate()+"/";
	        strOut += dteDate.getFullYear();
	        document.write( strOut );
		</script></font></td>
	</tr>
</table>
</CENTER>
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
<INPUT type="hidden" id="txtOrgPWDT" name="txtOrgPWDT" value="<%=strORGLastPasswordDate%>">
</FORM>
</body>
</html>