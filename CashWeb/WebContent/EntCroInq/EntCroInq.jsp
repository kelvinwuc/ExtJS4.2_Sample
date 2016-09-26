<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �n�P�b�d��
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.8 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntCroInq.jsp,v $
 * Revision 1.8  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%><%! String strThisProgId = "EntCroInq"; //���{���N�� %><% 
String strMsg = (request.getAttribute("txtMsg") == null)?"":(String)request.getAttribute("txtMsg");

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>�n�P�b�d��</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientI.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script language="javaScript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	WindowOnLoadCommon(document.title, '', strFunctionKeyInitial, '');
	window.status = "";
}

/* ��toolbar frame ����<�d��>���s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
{
	var form1 =	document.mainForm ; 
	if(	form1.EBKCD.value=="" && form1.EATNO.value=="" && form1.EBKRMD.value=="" && form1.ENTAMT.value=="" ){
		alert("�п�J�d�߱���");
		return;
	}
	form1.PAGEINDEX.value = 0 ;
	form1.submit();
}

/* ��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q���� */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("mainForm").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*  �d�ߪ��ĳ��N�X�αb�� */
function getBankCode()
{
	//�ˬd�O�_��i�d�ߪ����A
	if(document.getElementById("EBKCD").disabled){
		return ;
	}

	/*	���� QueryFrameSet.jsp ��,�U QueryString �ѼƤ��N�q
			RowPerPage		: �C�@�����X�C
			Heading			: ���Y���W��,�H�r��','���}�C�@���
			DisplayFields	: �n��ܤ���Ʈw���W��,�H�r�����}�C�@���,�PHeading�۹���
			ReturnFields	: �Ǧ^������줧��,�H�r�����}�C�@���
			Sql				: �ݰ��椧SQL,��i�[�Jwhere����
			TableWidth		: ���Table���e��
	
		 modalDialog �|�Ǧ^�ϥΪ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}
	*/
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR,BKADDT from CAPBNKF where 1 = 1 ";
	if( document.getElementById("EBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("EBKCD").value +"' ";
	if( document.getElementById("EATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("EATNO").value +"' ";
	strSql +=" order by bkcode,bkaddt "       
	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";

	<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading","���ĳ��N��,���ĳ��W��,���ĳ��b��,���O");
	session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR");
	session.setAttribute("ReturnFields", "BKCODE,BKATNO,BKCURR");
	%>

	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );

	if( strReturnValue != "" )
	{
		var returnArray = string2Array(strReturnValue,",");
		document.getElementById("EBKCD").value = returnArray[0];
		document.getElementById("EATNO").value = returnArray[1];
		document.getElementById("CSHFCURR").value = returnArray[2];
	}
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
	var bDate = true;
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bReturnStatus = false;
	}	
	if( objThisItem.id == "EBKRMD" )
	{
		bDate = true ;		
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false){
			strTmpMsg = "���ĳ��״ڤ�(�_)-����榡���~";
			bReturnStatus = false;
		}		
	}
	if( objThisItem.id == "EBKRMD2" )
	{
		bDate = true ;		
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false){
			strTmpMsg = "���ĳ��״ڤ�(��)-����榡���~";
			bReturnStatus = false;
		}		
	}

	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
		{
    		strErrMsg += strTmpMsg + "\r\n";
		}
	}

	return bReturnStatus;
}	
//-->
</script>
</HEAD>
<body bgcolor="#ffffff" onload="WindowOnLoad();">
<form id="mainForm" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.entCroInq.EntCroInqServlet?act=query" name="mainForm" target="iframe" >
<TABLE border="0">
	<TBODY>		
		<TR>
			<TD>���ĳ��N�X :</TD>
			<TD>
				<INPUT type="text" id="EBKCD" name="EBKCD" size="4" maxlength="4" value="" class="Key">
				<INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode()" value="�N�X�d��" readOnly>
			</TD>
			<TD>( �п�J���ꤤ�ߥN�X )</TD>
		</TR>
		<TR>
			<TD>���ĳ��b�� :</TD>
			<TD><INPUT type="text" id="EATNO" name="EATNO" size="17" maxlength="17" value="" class="Key" ></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���O :</TD>
			<TD><INPUT type="text" id="CSHFCURR" name="CSHFCURR" size="3" maxlength="2" value="" class="Key" ></TD>
			<TD></TD>
		</TR>		
		<TR>
			<TD>���ĳ��״ڤ�(�_) :</TD>
            <TD><INPUT class="Data" size="11" type="text" maxlength="11"
				id="EBKRMD" name="EBKRMD" value="" onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('mainForm.EBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>				
			</TD>
			<TD>(YYY/MM/DD)</TD>	
		</TR>
		<TR>
			<TD>���ĳ��״ڤ�(��) :</TD>
            <TD><INPUT class="Data" size="11" type="text" maxlength="11"
				id="EBKRMD2" name="EBKRMD2" value="" onblur="checkClientField(this,true);"> 
				<a href="javascript:show_calendar('mainForm.EBKRMD2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>				
			</TD>
			<TD>(YYY/MM/DD)</TD>	
		</TR>
		<TR>
			<TD>�״ڪ��B :</TD>
			<TD><INPUT type="text" id="ENTAMT" name="ENTAMT" size="13" maxlength="13" value="" class="Key"></TD>
			<TD></TD>
		</TR>
	</TBODY>
</TABLE>              
<input type="hidden" id="PAGEINDEX" name="PAGEINDEX" value="0">
<input type="hidden" id="txtAction" name="txtAction" value="">
</form>
<iframe height="400" width="100%" name="iframe" frameborder="0"></iframe>
</body>
</html>