<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.entactbat.CapcshfDTO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �浧�n�b�B�z
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.10 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntActOneC.jsp,v $
 * Revision 1.10  2014/01/21 09:07:15  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix---�O�d�W������T
 *
 * Revision 1.9  2014/01/15 02:30:38  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix---�O�d�W������T
 *
 * Revision 1.8  2014/01/08 10:59:15  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix---�O�d�W������T
 *
 * Revision 1.7  2014/01/07 10:31:57  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix---1.���v�����@���@��   2.���B���\���p���I
 *
 * Revision 1.6  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%><%! String strThisProgId = "EntActOne"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DecimalFormat df = new DecimalFormat("#,###,###,###,###.##");
String strMsg = (request.getAttribute("txtMsg")!=null?(String)request.getAttribute("txtMsg"):"");
CapcshfDTO preDto = (request.getAttribute("preDto")!=null?(CapcshfDTO)request.getAttribute("preDto"):null);
List<CapcshfDTO> list = (request.getAttribute("history")!=null?(List)request.getAttribute("history"):null);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>�浧�n�b</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 			= "txtEBKCD";		//�Ĥ@�ӥi��J��Key���W��
var strFirstData 			= "txtEUSREM";		//�Ĥ@�ӥi��J��Data���W��
var today = new Date();
// *************************************************************
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
	disableKey();
	disableData();
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtEBKCD" )
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
	else if( objThisItem.name == "txtEATNO" )
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
	else if( objThisItem.name == "dspEBKRMD" )
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
	else if( objThisItem.name == "txtENTAMT" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "�״ڪ��B���i�ť�";
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

/* ��toolbar frame �����s�W���s�Q�I���,����Ʒ|�Q���� */
function addAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
	document.getElementById("txtAction").value = "A"; // �����w�]��
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/* ��toolbar frame ����<�ק�>���s�Q�I���,����Ʒ|�Q���� */
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );

	enableKey();
	enableData();   
	
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
	enableQueryFields("txtEBKCD,txtEATNO,dspEBKRMD,txtENTAMT,txtCURRENCY");
	document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
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

	document.getElementById("txtEBKCD").value = "";
	document.getElementById("txtEATNO").value = "";
	document.getElementById("txtCURRENCY").value = "";
	document.getElementById("dspEBKRMD").value = "";
	document.getElementById("divWarning").style.display = "none";
}

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	document.getElementById("divWarning").style.display = "none";
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
		var strSql = "select EBKCD,EATNO,CAST(EBKRMD AS CHAR(7)) as EBKRMD,ENTAMT,EUSREM,CSHFAU,CAST(CSHFAD AS CHAR(8))AS CSHFAD,CAST(CSHFAT AS CHAR(6)) AS CSHFAT,EUSREM2,CSHFCURR,CAST(ECRDAY AS CHAR(8))AS ECRDAY from CAPCSHF where 1 = 1 ";
		if( document.getElementById("txtEBKCD").value != "" )
			strSql += " and EBKCD = '"+document.getElementById("txtEBKCD").value +"' ";

		if( document.getElementById("txtEATNO").value != "" )
			strSql += " and EATNO = '"+document.getElementById("txtEATNO").value +"' ";

		if( document.getElementById("txtCURRENCY").value != "" )
			strSql += " and CSHFCURR = '"+document.getElementById("txtCURRENCY").value +"' ";
			
		if( document.getElementById("dspEBKRMD").value != "" )
			strSql += " and EBKRMD = "+  rocDate2String(document.getElementById("dspEBKRMD").value) +" ";
		
 		if( document.getElementById("txtENTAMT").value != "" )
			strSql += " and ENTAMT = "+ document.getElementById("txtENTAMT").value +" ";

		strSql += " ORDER BY CSHFAD,CSHFAT ";

        var strQueryString = "?parm=parm&Time="+today.getTime()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading2","���ĳ��N��,���ĳ��b��,���ĳ��״ڤ�,�״ڪ��B,�K�n,�Ƶ�,���O");
	session.setAttribute("DisplayFields2", "EBKCD,EATNO,EBKRMD,ENTAMT,EUSREM,EUSREM2,CSHFCURR");
	session.setAttribute("ReturnFields2", "EBKCD,EATNO,EBKRMD,ENTAMT,EUSREM,CSHFAU,CSHFAD,CSHFAT,EUSREM2,CSHFCURR,ECRDAY");
%>
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		if( strReturnValue != "" )
		{
			enableAll();
			var returnArray = string2Array(strReturnValue,",");

			document.getElementById("txtEBKCD").value = returnArray[0];
			document.getElementById("txtEATNO").value = returnArray[1];
			document.getElementById("txtEBKRMD").value = returnArray[2];
			document.getElementById("txtENTAMT").value = returnArray[3];
			document.getElementById("txtEUSREM").value = returnArray[4];
			document.getElementById("txtCSHFAU").value = returnArray[5];
			document.getElementById("txtCSHFAD").value = returnArray[6];
			document.getElementById("txtCSHFAT").value = returnArray[7];
			document.getElementById("txtEUSREM2").value = returnArray[8];
            document.getElementById("txtCURRENCY").value = returnArray[9];

			document.getElementById("txtEBKCD_O").value = returnArray[0];
			document.getElementById("txtEATNO_O").value = returnArray[1];
			document.getElementById("txtEBKRMD_O").value = returnArray[2];
			document.getElementById("txtENTAMT_O").value = returnArray[3];
            document.getElementById("txtCURRENCY_O").value = returnArray[9];

			var varWarning = returnArray[10];
			if(varWarning > 0) {
				document.getElementById("divWarning").style.display = "block";
			}

			//�P�B������θ�����
			mapValue("D2P");

			winToolBar.ShowButton( strFunctionKeyInquiry );
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
		if( document.getElementById("txtAction").value != "A"
			&& document.getElementById("txtEBKRMD_O").value != document.getElementById("txtEBKRMD").value 
			&& document.getElementById("txtEUSREM2").value == "" )
		{
			alert("�ܧ�״ڤ�п�J�Ƶ�����!!");
		} else {
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
		document.getElementById("txtEBKRMD").value = rocDate2String(document.getElementById("dspEBKRMD").value) ;
	}else{
		//�۸������s������
		document.getElementById("dspEBKRMD").value = string2RocDate(document.getElementById("txtEBKRMD").value) ;
	}
	return ;
}

/*  �d�ߪ��ĳ��N�X�αb�� */
function getBankCode()
{
	if(document.getElementById("txtEBKCD").disabled){
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
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR,BKADDT,BKSTAT from CAPBNKF where 1 = 1 ";
	if( document.getElementById("txtEBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtEBKCD").value +"' ";
	if( document.getElementById("txtEATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtEATNO").value +"' ";
	strSql += " ORDER BY BKCODE,BKADDT ";

	var strQueryString = "?Time="+today.getMilliseconds()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading","���ĳ��N��,���ĳ��W��,���ĳ��b��,���O");
	session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR");
	session.setAttribute("ReturnFields", "BKCODE,BKATNO,BKCURR,BKSTAT");
%>
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
	if( strReturnValue != "" )
	{
		enableAll();
		var returnArray = string2Array(strReturnValue,",");
		if(returnArray[3] == "Y") {
			document.getElementById("txtEBKCD").value = returnArray[0];
			document.getElementById("txtEATNO").value = returnArray[1];
			document.getElementById("txtCURRENCY").value = returnArray[2];
		} else {
			alert("���ĳ�쪬�A������!!");
		}
	}
}
//-->
</script>
</HEAD>
<BODY  onload="WindowOnLoad();">
<P><BR></P>
<form method="post" id="frmMain" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.entactone.EntActOneServlet">
<%
String strEBKCD = "";
String strEATNO = "";
String strCURRENCY = "";
String strEBKRMD = "";
if(preDto != null) {
	strEBKCD = preDto.getEBKCD();
	strEATNO = preDto.getEATNO();
	strCURRENCY = preDto.getCSHFCURR();
	strEBKRMD = String.valueOf(preDto.getEBKRMD());
	if(CommonUtil.AllTrim(strEBKRMD).length() == 7) {
		strEBKRMD = strEBKRMD.substring(0,3) + "/" + strEBKRMD.substring(3,5) + "/" + strEBKRMD.substring(5,7);
	}
}
%>
<DIV id="divWarning" style="display: none;"><font color="red"><b>������Ƥw�P�b!!</b></font><BR></DIV>
<P><BR></P>
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
				<INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="<%=strEBKCD%>" class="Data">
				<INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode();" value="�N�X�d��">
			</TD>
			<TD>( �п�J���ꤤ�ߥN�X )</TD>
		</TR>
		<TR>
			<TD>���ĳ��b�� *:</TD>
			<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value="<%=strEATNO%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���O *:</TD>
			<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="5" maxlength="5" value="<%=strCURRENCY%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���ĳ��״ڤ� *:</TD>
			<TD><INPUT type="text" id="dspEBKRMD" name="dspEBKRMD" size="8" maxlength="9" value="<%=strEBKRMD%>" class="Data"  onblur="checkClientField(this,true);"><INPUT name="txtEBKRMD" id="txtEBKRMD"  type="hidden" value=""></TD>
			<TD><A href="javascript:show_calendar('frmMain.dspEBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"  ></A></TD>
		</TR>
		<TR>
			<TD>�״ڪ��B *:</TD>
			<TD><INPUT type="text" id="txtENTAMT" name="txtENTAMT" size="13" maxlength="13" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�K�n :</TD>
			<TD><INPUT type="text" id="txtEUSREM" name="txtEUSREM" size="20" maxlength="40" value="" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�Ƶ� :</TD>
			<TD><INPUT type="text" id="txtEUSREM2" name="txtEUSREM2" size="20" maxlength="40" value="" class="Data"></TD>
			<TD></TD>
		</TR>
	</TBODY>
</TABLE>
<BR>* ��������J����
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">

<INPUT type="hidden" id="txtEBKCD_O" name="txtEBKCD_O" value="">
<INPUT type="hidden" id="txtEATNO_O" name="txtEATNO_O" value="">
<INPUT type="hidden" id="txtCURRENCY_O" name="txtCURRENCY_O" value="">
<INPUT type="hidden" id="txtEBKRMD_O" name="txtEBKRMD_O" value="">
<INPUT type="hidden" id="txtENTAMT_O" name="txtENTAMT_O" value="">
<INPUT type="hidden" id="txtCSHFAU" name="txtCSHFAU">
<INPUT type="hidden" id="txtCSHFAD" name="txtCSHFAD">
<INPUT type="hidden" id="txtCSHFAT" name="txtCSHFAT">

</form>
<BR>
���̪��J��ƦC�� :
<TABLE id=displayTable name=displayTable width="80%" border=1>
	<THEAD>
		<TR>
			<TD align="center" width="15%">���ĳ��N�X</TD>
			<TD align="center" width="15%">�b��</TD>
			<TD align="center" width="10%">���O</TD>
			<TD width="10%" align="center">�״ڤ�</TD>
			<TD width="20%" align="center">�״ڪ��B</TD>
			<TD width="15%" align="center">�K�n</TD>
			<TD width="15%" align="center">�Ƶ�</TD>
		</TR>
	</THEAD>
	<TBODY id="displayBody" name="displayBody" align="center">
<% if(list!=null && list.size() > 0) {
	CapcshfDTO dto = null;
	for(int i=0; i<list.size(); i++) {
		dto = list.get(i); %>
		<TR>
			<TD><%=dto.getEBKCD()%></TD>
			<TD><%=dto.getEATNO()%></TD>
			<TD><%=dto.getCSHFCURR()%></TD>
			<TD><%=dto.getEBKRMD()%></TD>
			<TD><%=df.format(dto.getENTAMT())%></TD>
			<TD><%=(CommonUtil.AllTrim(dto.getEUSREM()).equals(""))?"&nbsp;":dto.getEUSREM()%></TD>
			<TD><%=(CommonUtil.AllTrim(dto.getEUSREM2()).equals(""))?"&nbsp;":dto.getEUSREM2()%></TD>
		</TR>
<% 	} %>
<% } %>
	</TBODY>
</TABLE>
</BODY>
</HTML>

