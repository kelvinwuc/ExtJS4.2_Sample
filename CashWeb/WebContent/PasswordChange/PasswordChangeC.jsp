<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.SessionInfo" %>
<%@ page import="com.aegon.comlib.UserInfo" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%!
/**
 * System   : 
 * 
 * Function : �ӤH��ƺ��@
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.5 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date: ${date}
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: PasswordChangeC.jsp,v $
 * Revision 1.5  2013/12/24 04:12:48  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.4  2012/08/31 09:26:01  taipei\ODCKain
 * prepare WAS8 dev env
 *
 * Revision 1.3  2012/08/29 10:45:23  ODCWilliam
 * modify: william
 * date: 2012-08-28
 * issue: session expiry
 *
 * Revision 1.2  2012/08/24 02:39:32  ODCWilliam
 * *** empty log message ***
 *
 * Revision 1.1  2011/08/09 01:34:09  MISSALLY
 * Q10256�@ ����CASH�t�ο��~�L�k�]�X����
 *
 *  
 */
%><%
String strMsg = request.getParameter("txtMsg")==null?"":request.getParameter("txtMsg");
int iPasswordStatus = Integer.parseInt(String.valueOf(session.getAttribute("PasswordAging")));
String strPasswordAgingMsg = String.valueOf(session.getAttribute("PasswordAgingMsg"));
String strUserId = String.valueOf(session.getAttribute(Constant.LOGON_USER_ID));
String orgPwdStat = request.getParameter("txtorgPwdStat")==null?String.valueOf(iPasswordStatus):request.getParameter("txtorgPwdStat");
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>�ӤH��ƺ��@</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 	 = "";						//�Ĥ@�ӥi��J��Key���W��
var strFirstData 	 = "txtPassword";			//�Ĥ@�ӥi��J��Data���W��

var iPasswordStatus  = 0;			            // 0:�K�X����, 1:�������K�X, 2:ĵ�i��, 9:�Ĥ@���n��
var strMustChangeMsg = "�z���K�X�w�g�L��,�Х����K�X��A�i���L�@�~";
var strWarningMsg    = "�z���K�X�֭n�L���F,�O�_�n�ߨ�ק�K�X?";
var strFirstTimeMsg  = " �Ĥ@���i�J�t��,�Эק�K�X�νT�{�ӤH���";
var strPasswordAgingMsg = "";
var strNextUrl       = "<%=request.getContextPath()%>/NewMenu/index.html";

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
	strFunctionKeyInitial = "H,R,E";			//�T�w,�M��,���}
	if( document.getElementById("txtMsg").value != "" )
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;

	iPasswordStatus = "<%=iPasswordStatus%>";
	strPasswordAgingMsg = "<%=strPasswordAgingMsg%>";

	if( iPasswordStatus != 0 )
	{
		alert( strPasswordAgingMsg );
//		if( iPasswordStatus == 1 )	//���ݧ��K�X
//		{
//			alert( strPasswordAgingMsg );
//		}
//		else if( iPasswordStatus == 2 )	//�W�Lĵ�i��
//		{
//			var bPasswordChange = window.confirm( strPasswordAgingMsg );
//			if( !bPasswordChange )
//			{
			//	alert("here_1");
			//	window.top.navigate( strNextUrl );
//			window.top.navigate("../Logon/Logon.jsp");
//			}
//		}
//		else if( iPasswordStatus == 9 ) //�Ĥ@���n���t��
//		{
//			alert( strPasswordAgingMsg );
//		}
	}
	else
	{
		if( document.getElementById("txtorgPwdStat").value != "0" )
			window.top.navigate( strNextUrl );
	}
	window.status = "��J�K�X�νT�{�K�X��,���T�w�s�Y�i���K�X";
	enableData();

	document.getElementById("txtEmail").value = "<%=uiThisUserInfo.getEmail()%>";
	document.getElementById("txtSecretQuestion").value = "<%=uiThisUserInfo.getSecretQuestion()%>";
	document.getElementById("txtSecretAnswer").value = "<%=uiThisUserInfo.getSecretAnswer()%>";
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
	if( objThisItem.name == "txtPassword" )
	{
		if( objThisItem.value == "" )
		{
			if( iPasswordStatus == 1 || iPasswordStatus == 9 ) //�K�X�w�L���βĤ@���n�J�����ק�K�X
			{
				strTmpMsg = "�s�K�X���i�ť�";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.name == "txtConfirmPassword" )
	{
		if( objThisItem.value != document.all("txtPassword").value )
		{
			strTmpMsg = "�T�{�s�K�X�����P�s�K�X�ۦP";
			bReturnStatus = false;
		}
	}
	else if(objThisItem.name == "txtSecretAnswer")
	{
		if(alltrim(objThisItem.value) == ""){
			strTmpMsg += "�K�X���ܰ��D�����סA���i�ť� !";
			bReturnStatus = false ;
		}
	}
	else if( objThisItem.name == "txtSecretQuestion" )
	{
		if(alltrim(objThisItem.value) == ""){
			strTmpMsg += "�K�X���ܻy���D�A���i�ť� !";
			bReturnStatus = false ;
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
�Ǧ^��     :	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
*/
function exitAction()
{
	window.location = '<%=request.getContextPath()%>/Logon/Logoff.jsp';
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
	enableAll();
	if( areAllFieldsOK() )
	{
		document.getElementById("txtAction").value = "U";
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}

function PickQuestion()
{
	if(document.getElementById("divPickQuestion").style.display == "block"){
		document.getElementById("divPickQuestion").style.display = "none";
	}else{
		document.getElementById("divPickQuestion").style.display = "block";
		changeQuestion(document.getElementsByTagName("SELECT").item(0));
	}
}

function changeQuestion(thisSelection)
{
	if( thisSelection.selectedIndex != 0 )
		document.getElementById("txtSecretQuestion").value = thisSelection.options.item( thisSelection.selectedIndex ).text;
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnLoad();">
<form id="frmMain" name="frmMain" method="post" action="PasswordChangeS.jsp">
<CENTER>
<table border="0" width=730 cellspacing="0" cellpadding="0" >
	<tr><td><font color=red>�Ъ`�N�G</font></td></tr>			
	<tr><td><font color=red>�@�@�@�E�K�X�����^��r���j�p�g�O���P���C</font></td></tr>
	<tr><td><font color=red>�@�@�@�E�K�X�����ץ�����7-15�X�A�䤤�]�t�^��r���Ϊ��ԧB�Ʀr�C</font></td></tr>
	<tr><td><font color=red>�@�@�@�@(�Ҧp �K�Xperson888�A����׬�9�A�P�ɥ]�t�^��r���Ϊ��ԧB�Ʀr)</font></td></tr>
</table>
<br>
<TABLE width="730" border="1">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="302">�s �K �X(�p�����,�N�O���ť�)�G</TD>
			<TD width="420"><INPUT class="Data" size="30" type="password" maxlength="15" id="txtPassword" name="txtPassword" value="" onblur="checkClientField(this,true);"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="302">�s�K�X�T�{�G</TD>
			<TD width="420"><INPUT class="Data" size="30" type="password" maxlength="15" id="txtConfirmPassword" name="txtConfirmPassword" value="" onblur="checkClientField(this,true);"></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="302">email�b���G</TD>
			<TD width="420"><INPUT class="Data" size="30" type="text" maxlength="60" id="txtEmail" name="txtEmail" value="" onblur="checkClientField(this,true);"></TD>
		</TR>
	</TBODY>
</TABLE>
<TABLE border="1" width="730" height="51">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="296">�K�X���ܻy���D�G</TD>
			<TD align='left' width="265"><INPUT class="Data" size="32" maxlength="60" id="txtSecretQuestion" name="txtSecretQuestion" value="" onblur="checkClientField(this,false);"></TD>
			<TD align='center'>
				<DIV id="divPickQuestion" Style="display: block">
					<SELECT class="Data" id='tmpSelect' name='tmpSelect' onChange="changeQuestion(this);">
						<OPTION>�Ѧ��D��</OPTION>
						<OPTION>�ڪ��X�ͤ��?</OPTION>
						<OPTION>�ڳ̳��w������?</OPTION>
						<OPTION>�ڪ����B�g�~��?</OPTION>
						<OPTION>�ڤӤӪ��ͤ�?</OPTION>
					</SELECT>
				</DIV>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="296">�K�X���ܰ��D�����סG</TD>
			<TD colspan='3'><INPUT class="Data" size='32' maxlength="60" id="txtSecretAnswer" name="txtSecretAnswer" value="" onblur="checkClientField(this,false);"></TD>
		</TR>
	</TBODY>
</TABLE><br>


<table border="0" width=730 cellspacing="0" cellpadding="0" id="copyright">
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
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
<INPUT type="hidden" id="txtorgPwdStat" name="txtorgPwdStat" value="<%=orgPwdStat%>">
</FORM>
</BODY>
</HTML>