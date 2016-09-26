<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �浧�J�b�B�z
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : MISSALLY
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: RecActOneC.jsp,v $
 * Revision 1.3  2014/02/14 06:42:52  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix---�ץ��h��@�ɦh�����ݾP�b����ƳQ�P��
 *
 * Revision 1.2  2014/01/21 09:07:15  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix---�O�d�W������T
 *
 * Revision 1.1  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%><%! String strThisProgId = "RecActOne"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
String strMsg = (request.getAttribute("txtMsg")!=null?(String)request.getAttribute("txtMsg"):"");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>�浧�J�b�B�z</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 			= "txtCBKCD";		//�Ĥ@�ӥi��J��Key���W��
var strFirstData 			= "txtCATNO";		//�Ĥ@�ӥi��J��Data���W��
var today = new Date();
// *************************************************************
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial, '' ) ;
	disableKey();
	disableData();
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtCBKCD" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "���ĳ��N�X���i�ť�";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.name == "txtCATNO" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "���ĳ��b�����i�ť�";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.name == "txtCURRENCY" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "���O���i�ť�";
				bReturnStatus = false;
			}
		}
	}	
	else if( objThisItem.name == "dspCBKRMD" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "���ĳ��״ڤ餣�i�ť�";
				bReturnStatus = false;
			}
		}	 
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "���ĳ��״ڤ�-����榡���~";
	        bReturnStatus = false;			
        }
	}
	else if( objThisItem.name == "txtCROAMT" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "�J�b���B���i�ť�";
				bReturnStatus = false;
			}
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

/* ��toolbar frame ����<�ק�>���s�Q�I���,����Ʒ|�Q���� */
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );

	disableAll();
	enableQueryFields("txtCATNO,dspCBKRMD");

	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstData) != null )
			document.getElementById(strFirstData).focus() ;
	}

	document.getElementById("txtAction").value = "U";
}

/* ��toolbar frame ����<�d��>���s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
{
	winToolBar.ShowButton( strFunctionKeyInquiry1 );
	enableQueryFields("txtCBKCD,txtCATNO,dspCBKRMD,txtCROAMT,txtCURRENCY");
	document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/* ��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q���� */
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

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
}

/* ��toolbar frame ����<�T�w>���s�Q�I���,����Ʒ|�Q���� */
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
		var strSql = "select CBKCD,CATNO,CAST(CBKRMD AS CHAR(7)) as CBKRMD,CROAMT,CROSRC,CSFBAU,CAST(CSFBAD AS CHAR(8))AS CSFBAD,CAST(CSFBAT AS CHAR(6)) AS CSFBAT,CAST(CAEGDT AS CHAR(7)) as CAEGDT,CSFBRECTNO,CAST(CSFBRECSEQ as INT) as CSFBRECSEQ,CSFBPONO,CSFBCURR from CAPCSHFB where 1 = 1 ";
		if( document.getElementById("txtCBKCD").value != "" )
			strSql += " and CBKCD = '"+document.getElementById("txtCBKCD").value +"' ";

		if( document.getElementById("txtCATNO").value != "" )
			strSql += " and CATNO = '"+document.getElementById("txtCATNO").value +"' ";

		if( document.getElementById("txtCURRENCY").value != "" )
			strSql += " and CSFBCURR = '"+document.getElementById("txtCURRENCY").value +"' ";
			
		if( document.getElementById("dspCBKRMD").value != "" )
			strSql += " and CBKRMD = "+  rocDate2String(document.getElementById("dspCBKRMD").value) +" ";
		
 		if( document.getElementById("txtCROAMT").value != "" )
			strSql += " and CROAMT = "+ document.getElementById("txtCROAMT").value +" ";

		strSql += " ORDER BY CSFBAD,CSFBAT ";

        var strQueryString = "?parm=parm&Time="+today.getTime()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading2","���ĳ��N��,���ĳ��b��,���ĳ��״ڤ�,�״ڪ��B,���y�J�b��");
	session.setAttribute("DisplayFields2", "CBKCD,CATNO,CBKRMD,CROAMT,CAEGDT");
	session.setAttribute("ReturnFields2", "CBKCD,CATNO,CBKRMD,CROAMT,CROSRC,CSFBAU,CSFBAD,CSFBAT,CAEGDT,CSFBRECTNO,CSFBRECSEQ,CSFBPONO,CSFBCURR");
%>
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		if( strReturnValue != "" )
		{
			enableAll();
			var returnArray = string2Array(strReturnValue,",");

			document.getElementById("txtCBKCD").value = returnArray[0];
			document.getElementById("txtCATNO").value = returnArray[1];
			document.getElementById("txtCBKRMD").value = returnArray[2];
			document.getElementById("txtCROAMT").value = returnArray[3];
			document.getElementById("txtCROSRC").value = returnArray[4];
			document.getElementById("txtCSFBAU").value = returnArray[5];
			document.getElementById("txtCSFBAD").value = returnArray[6];
			document.getElementById("txtCSFBAT").value = returnArray[7];
			document.getElementById("txtCAEGDT").value = returnArray[8];
			document.getElementById("txtCSFBRECTNO").value = returnArray[9];
			document.getElementById("txtCSFBRECSEQ").value = returnArray[10];
			document.getElementById("txtCSFBPONO").value = returnArray[11];
            document.getElementById("txtCURRENCY").value = returnArray[12];

			document.getElementById("txtCBKCD_O").value = returnArray[0];
			document.getElementById("txtCATNO_O").value = returnArray[1];
			document.getElementById("txtCBKRMD_O").value = returnArray[2];
			document.getElementById("txtCROAMT_O").value = returnArray[3];
            document.getElementById("txtCURRENCY_O").value = returnArray[12];

			//�P�B������θ�����
			mapValue("D2P");
			disableAll();
			winToolBar.ShowButton( strDISBFunctionKeySourceU );
		}
	}
}

/* ��toolbar frame ����<�x�s>���s�Q�I���,����Ʒ|�Q���� */
function saveAction()
{
	enableAll();
	mapValue("P2D");
	if( areAllFieldsOK() )
	{
		if( document.getElementById("txtCATNO").value == "" ) {
			alert("���ĳ��b�����i�ť�!!");
		} else if( document.getElementById("txtCBKRMD").value == "" ) {
			alert("���ĳ��״ڤ餣�i�ť�!!");
		} else {
			if(document.getElementById("txtCROSRC").value != "9") {
				if (window.confirm("�x�s������A�O�_�n�־P�ӵ��J�b���?")) {
					document.getElementById("nextAction").value = "Writeoffs";
				}
			} else {
				alert("GTMS�Цܡu���P�b�B�z�v�־P�ӵ��J�b���!!");
			}
			document.getElementById("frmMain").submit();
		}
	}
	else
		alert( strErrMsg );
}

/*
��ƦW��:	mapValue( direction )
��ƥ\��:	�P�B������θ�����
�ǤJ�Ѽ�:	��ƦP�B����V (P2D: Display to Data, D2P: data to display )
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function mapValue(direction){
	if(direction.toUpperCase()=="P2D"){
		//�� �������s������
		document.getElementById("txtCBKRMD").value = rocDate2String(document.getElementById("dspCBKRMD").value) ;
	}else{
		//�۸������s������
		document.getElementById("dspCBKRMD").value = string2RocDate(document.getElementById("txtCBKRMD").value) ;
	}
	return ;
}

/*  �d�ߪ��ĳ��N�X�αb�� */
function getBankCode()
{
	if(document.getElementById("txtCBKCD").disabled){
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
	if( document.getElementById("txtCBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtCBKCD").value +"' ";
	if( document.getElementById("txtCATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtCATNO").value +"' ";
	strSql += " ORDER BY BKCODE,BKADDT ";

	var strQueryString = "?Time="+today.getMilliseconds()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading","���ĳ��N��,���ĳ��W��,���ĳ��b��,���O");
	session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR");
	session.setAttribute("ReturnFields", "BKCODE,BKATNO,BKCURR");
%>
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
	if( strReturnValue != "" )
	{
		enableAll();
		var returnArray = string2Array(strReturnValue,",");
		document.getElementById("txtCBKCD").value = returnArray[0];
		document.getElementById("txtCATNO").value = returnArray[1];
		document.getElementById("txtCURRENCY").value = returnArray[2];
	}
}
//-->
</script>
</HEAD>
<BODY  onload="WindowOnLoad();">
<P><BR></P>
<form method="post" id="frmMain" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.entactone.RecActOneServlet">
<TABLE border="0">
	<TBODY>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���ĳ��N�X *:</TD>
			<TD>
				<INPUT type="text" id="txtCBKCD" name="txtCBKCD" size="4" maxlength="4" value="" class="Data">
				<INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode();" value="�N�X�d��">
			</TD>
			<TD>( �п�J���ꤤ�ߥN�X )</TD>
		</TR>
		<TR>
			<TD>���ĳ��b�� *:</TD>
			<TD><INPUT type="text" id="txtCATNO" name="txtCATNO" size="17" maxlength="17" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���O *:</TD>
			<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="5" maxlength="5" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���ĳ��״ڤ� *:</TD>
			<TD><INPUT type="text" id="dspCBKRMD" name="dspCBKRMD" size="8" maxlength="9" value="" class="Data"  onblur="checkClientField(this,true);"><INPUT name="txtCBKRMD" id="txtCBKRMD"  type="hidden" value=""></TD>
			<TD><A href="javascript:show_calendar('frmMain.dspCBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"  ></A></TD>
		</TR>
		<TR>
			<TD>�J�b���B *:</TD>
			<TD><INPUT type="text" id="txtCROAMT" name="txtCROAMT" size="13" maxlength="13" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���y�J�b�� :</TD>
			<TD><INPUT type="text" id="txtCAEGDT" name="txtCAEGDT" size="8" maxlength="9" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�I�ڤ覡 :</TD>
			<TD><INPUT type="text" id="txtCROSRC" name="txtCROSRC" size="20" maxlength="40" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�e���渹�X :</TD>
			<TD><INPUT type="text" id="txtCSFBRECTNO" name="txtCSFBRECTNO" size="10" maxlength="9" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�e����Ǹ� :</TD>
			<TD><INPUT type="text" id="txtCSFBRECSEQ" name="txtCSFBRECSEQ" size="5" maxlength="3" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�O�渹�X :</TD>
			<TD><INPUT type="text" id="txtCSFBPONO" name="txtCSFBPONO" size="10" maxlength="10" value="" class="Data"></TD>
			<TD></TD>
		</TR>
	</TBODY>
</TABLE>              
<BR>* ��������J����
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="nextAction" name="nextAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">

<INPUT type="hidden" id="txtCBKCD_O" name="txtCBKCD_O" value="">
<INPUT type="hidden" id="txtCATNO_O" name="txtCATNO_O" value="">
<INPUT type="hidden" id="txtCURRENCY_O" name="txtCURRENCY_O" value="">
<INPUT type="hidden" id="txtCBKRMD_O" name="txtCBKRMD_O" value="">
<INPUT type="hidden" id="txtCROAMT_O" name="txtCROAMT_O" value="">
<INPUT type="hidden" id="txtCSFBAU" name="txtCSFBAU">
<INPUT type="hidden" id="txtCSFBAD" name="txtCSFBAD">
<INPUT type="hidden" id="txtCSFBAT" name="txtCSFBAT">

</form>
</BODY>
</HTML>

