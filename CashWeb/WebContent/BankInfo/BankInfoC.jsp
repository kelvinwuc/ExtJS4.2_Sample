<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.bankinfo.CapbnkfVO" %>
<%@ page import="org.apache.log4j.Logger"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : ���ĳ���ƺ��@
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.5 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * RD0382-OIU�M��:20150909,Kelvin Wu,�s�W�i�b����ݤ��q�O�j
 *
 * $Log: BankInfoC.jsp,v $
 * Revision 1.5  2015/11/09 09:01:31  001946
 * *** empty log message ***
 *
 * Revision 1.4  2014/02/26 06:39:32  MISSALLY
 * EB0537 --- �s�W�U���Ȧ欰�~�����w�Ȧ�
 *
 * Revision 1.3  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%>
<%
Logger log = Logger.getLogger(getClass());
//log.info("���ĳ���ƺ��@");
 %>
<%! String strThisProgId = "BankInfoC"; //���{���N�� %><% 
String strMsg = (request.getAttribute("txtMsg") == null)?"":((String)request.getAttribute("txtMsg"));

CapbnkfVO vo = (request.getAttribute("bankVo") != null)?((CapbnkfVO) request.getAttribute("bankVo")):null;
String strBankCode = "";
String strBankAccount = "";
String strBankGlAct = "";
String strBankCurr = "";
String strBankName = "";
String strBankAlat = "";
String strBankCred = "";
String strBankPacb = "";
String strBankBatc = "";
String strBankGpCd = "";
String strBankSpec = "";
String strBankStatus = "";
String strBankMemo = "";
String strCompanyType =""; //RD0382

if(vo != null) {
	strBankCode = CommonUtil.AllTrim(vo.getBankCode());
	strBankAccount = CommonUtil.AllTrim(vo.getBankAccount());
	strBankGlAct = CommonUtil.AllTrim(vo.getBankGlAct());
	strBankCurr = CommonUtil.AllTrim(vo.getBankCurr());
	strBankName = CommonUtil.AllTrim(vo.getBankName());
	strBankAlat = CommonUtil.AllTrim(vo.getBankAlat());
	strBankCred = CommonUtil.AllTrim(vo.getBankCred());
	strBankPacb = CommonUtil.AllTrim(vo.getBankPacb());
	strBankBatc = CommonUtil.AllTrim(vo.getBankBatc());
	strBankGpCd = CommonUtil.AllTrim(vo.getBankGpCd());
	strBankSpec = CommonUtil.AllTrim(vo.getBankSpec());
	strBankStatus = CommonUtil.AllTrim(vo.getBankStatus());
	strBankMemo = CommonUtil.AllTrim(vo.getBankMemo());
	//strCompanyType = CommonUtil.AllTrim(vo.getCompanyType());
	strCompanyType = "";
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>���ĳ���ƺ��@</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">
<!--
var strFirstKey 	 = "txtBkCode";			//�Ĥ@�ӥi��J��Key���W��
var strFirstData 	 = "txtBkName";			//�Ĥ@�ӥi��J��Data���W��

/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
	disableAll();
}

/* �ˮֶǤJ�����O�_���T */
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtBkCode" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "���ĳ��N�X���i�ť�";
				bReturnStatus = false;
			}
			else
			{
				re = /^[0-9]{3}$/;
				if (!re.test(objThisItem.value))
				{
					strTmpMsg = "���ĳ��N�X���ŦX 999 ���榡";
					bReturnStatus = false;
				}
			}
		}
	}
	else if( objThisItem.name == "txtBkName" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "���ĳ��W�٤��i�ť�";
				bReturnStatus = false;
			}
		}
	}
	else if( objThisItem.name == "txtBkAtNo" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "���ĳ��b�����i�ť�";
				bReturnStatus = false;
			}
			else
			{
				re = /^\d{1,17}$/;
				if (!re.test(objThisItem.value))
				{
					strTmpMsg = "���ĳ��b�������Ʀr";
					bReturnStatus = false;
				}
			}
		}
	}
	else if( objThisItem.name == "txtGlAct" )
	{
		if( document.getElementById("txtAction").value != "I" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "�|�p��ؤ��i�ť�";
				bReturnStatus = false;
			}
			else
			{
				re = /^[A-Z0-9]{6}-[A-Z0-9]{6}$/;
				if (!re.test(objThisItem.value))
				{
					strTmpMsg = "�|�p��ؤ��ŦX 999999-999999 ���榡";
					bReturnStatus = false;
				}
			}
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

/* ��toolbar frame ����<�s�W>���s�Q�I���,����Ʒ|�Q���� */
function addAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
	document.getElementById("txtAction").value = "A";

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
	disableKey();
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
	enableQueryFields("txtBkCode,txtBkName,txtBkAtNo,txtGlAct");
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

	var elements = document.forms("frmMain");
	for(var i=0; i<elements.length; i++) {
		field_type = elements[i].type.toLowerCase();
		switch(field_type) {
			case "text":
			case "password":
			case "textarea":
			case "hidden":
				elements[i].value = "";
				break;
			case "radio":
			case "checkbox":
				if (elements[i].checked) {
					elements[i].checked = false;
				}
				break;
			case "select-one":
			case "select-multi":
				elements[i].selectedIndex = -1;
				break;
			default:
				break;
		}
	}

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
	document.getElementById("txtAction").value = "";
	document.getElementById("txtMsg").value = "";
	WindowOnLoad();
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
		var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR,GLACT,BKALAT,BKCRED,BKPACB,BKBATC,BKGPCD,CASE BKSPEC WHEN 'Y' THEN BKSPEC ELSE 'N' END as BKSPEC,CASE BKSTAT WHEN 'Y' THEN '�ҥ�' ELSE '����' END as STATDESC,CASE BKSTAT WHEN 'Y' THEN BKSTAT ELSE 'N' END as BKSTAT,BKMEMO,CASE COMPANY WHEN 'OIU' THEN COMPANY ELSE '�`���q' END as COMPANY from CAPBNKF where 1 = 1 ";//RD0382
		if( document.getElementById("txtBkCode").value != "" )
			strSql += " and BKCODE = '"+document.getElementById("txtBkCode").value +"' ";

		if( document.getElementById("txtBkName").value != "" )
			strSql += " and BKNAME = '"+document.getElementById("txtBkName").value +"' ";

		if( document.getElementById("txtBkAtNo").value != "" )
			strSql += " and BKATNO = '"+document.getElementById("txtBkAtNo").value +"' ";

		if( document.getElementById("txtGlAct").value != "" )
			strSql += " and GLACT = '"+document.getElementById("txtGlAct").value +"' ";

		var strQueryString = "?Time="+new Date()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=650";

	<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading","���ĳ��N��,���ĳ��W��,���ĳ��b��,���O,�|�p���,����²�X,�H�Υd�Ȧ�X,�Ȧ���b�дڽX,�妸�J�b�Ȧ�X,GTMS�{�����O,���A,�b����ݤ��q�O");//RD0382
	session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR,GLACT,BKALAT,BKCRED,BKPACB,BKBATC,BKGPCD,STATDESC,COMPANY");//RD0382
	session.setAttribute("ReturnFields", "BKCODE,BKNAME,BKATNO,BKCURR,GLACT,BKALAT,BKCRED,BKPACB,BKBATC,BKGPCD,BKSPEC,BKSTAT,BKMEMO,COMPANY");//RD0382
	%>

		var strReturnValue = window.showModalDialog( "../CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		
		if( strReturnValue != "" )
		{
			disableAll();
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtBkCode").value = returnArray[0];
			document.getElementById("txtBkName").value = returnArray[1];
			document.getElementById("txtBkAtNo").value = returnArray[2];
			document.getElementById("txtBkCurr").value = returnArray[3];
			document.getElementById("txtGlAct").value = returnArray[4];
			document.getElementById("txtBkAlat").value = returnArray[5];
			document.getElementById("txtBkCred").value = returnArray[6];
			document.getElementById("txtBkPacb").value = returnArray[7];
			document.getElementById("txtBkBatc").value = returnArray[8];
			document.getElementById("txtBkGpCd").value = returnArray[9];
			//document.getElementById("txtCompanyType").value = returnArray[13];//RD0382

			var varTmp = returnArray[10];
			var objSelect = document.getElementById("txtBkSpEc");
			for (var i = 0; i < objSelect.options.length; i++) {
				if (objSelect.options[i].value == varTmp) {
					objSelect.options[i].selected = true;
					break;
				}
			}

			varTmp = returnArray[11];
			objSelect = document.getElementById("txtBkStAt");
			for (var i = 0; i < objSelect.options.length; i++) {
				if (objSelect.options[i].value == varTmp) {
					objSelect.options[i].selected = true;
					break;
				}
			}
			
			//RD0382:�s�WOIU
			varTmp = returnArray[13];
			objSelect = document.getElementById("txtCompanyType");
			for (var i = 0; i < objSelect.options.length; i++) {
				if (objSelect.options[i].value == varTmp) {
					objSelect.options[i].selected = true;
					break;
				}
			}

			document.getElementById("txtBkMeMo").value = returnArray[12];

			document.getElementById("txtAction").value = "I";
			winToolBar.ShowButton( strFunctionKeyInquiry );
			window.status = "�ثe���d�ߪ��A,�Y�n�ק�ΧR�����,�Х���ܭק�ΧR���\����";
		}
	}
}

/* ��toolbar frame ����<�x�s>���s�Q�I���,����Ʒ|�Q���� */
function saveAction()
{
	enableAll();
	if( areAllFieldsOK() )
	{
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnLoad();">
<P><B>���ĳ���ƺ��@</B></P>
<P><BR></P>
<form id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.bankinfo.BankInfoServlet" >
<TABLE border="0">
	<TBODY>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���ĳ��N�X�@ *:</TD>
			<TD><INPUT type="text" id="txtBkCode" name="txtBkCode" size="4" maxlength="4" value="<%=strBankCode%>" class="Key"></TD>
			<TD>( �п�J���ꤤ�ߥN�X )</TD>
		</TR>
		<TR>
			<TD>���ĳ��W�١@ *:</TD>
			<TD><INPUT type="text" id="txtBkName" name="txtBkName" size="30" maxlength="30" value="<%=strBankName%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�b����ݤ��q�O�@ *:</TD>
			<TD>
				<select id="txtCompanyType" name="txtCompanyType" class="Data">
					<option value="" <%=strCompanyType.equals("")?" selected":""%>>�`���q</option>
					<option value="OIU" <%=strCompanyType.equals("OIU")?" selected":""%>>OIU</option>
				</select>
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���ĳ��b���@ *:</TD>
			<TD><INPUT type="text" id="txtBkAtNo" name="txtBkAtNo" size="17" maxlength="17" value="<%=strBankAccount%>" class="Key"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���O�@ *:</TD>
			<TD><INPUT type="text" id="txtBkCurr" name="txtBkCurr" size="5" maxlength="2" value="<%=strBankCurr.equals("")?"NT":strBankCurr%>" class="Key" ></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�|�p��ء@�@�@ *:</TD>
			<TD><INPUT type="text" id="txtGlAct" name="txtGlAct" size="15" maxlength="15" value="<%=strBankGlAct%>" class="Key"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>����²�X�@�@�@   :</TD>
			<TD><INPUT type="text" id="txtBkAlat" name="txtBkAlat" size="4" maxlength="4" value="<%=strBankAlat%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�H�Υd�Ȧ�X�@   :</TD>
			<TD><INPUT type="text" id="txtBkCred" name="txtBkCred" size="4" maxlength="4" value="<%=strBankCred%>" class="Data"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�Ȧ���b�дڽX   :</TD>
			<TD><INPUT type="text" id="txtBkPacb" name="txtBkPacb" size="4" maxlength="4" value="<%=strBankPacb%>" class="Data"></TD>
			<TD>( �s�W��ƻݻP�O�O��F�T�{ -�Ȧ���b )</TD>
		</TR>
		<TR>
			<TD>�妸�J�b�Ȧ�X   :</TD>
			<TD><INPUT type="text" id="txtBkBatc" name="txtBkBatc" size="17" maxlength="17" value="<%=strBankBatc%>" class="Data"></TD>
			<TD>( �s�W��ƻݻP�O�O��F�T�{ -�����b�� )</TD>
		</TR>
		<TR>
			<TD>GTMS�{�����O   :</TD>
			<TD><INPUT type="text" id="txtBkGpCd" name="txtBkGpCd" size="2" maxlength="1" value="<%=strBankGpCd%>" class="Data"></TD>
			<TD>( �p�ӱb���笰GTMS�ϥΪ�,�ݿ�J��{�����O )</TD>
		</TR>
		<TR>
			<TD>���n�b�榡    *:</TD>
			<TD>
				<select id="txtBkSpEc" name="txtBkSpEc" class="Data">
					<option value="N" <%=strBankSpec.equals("N")?" selected":""%>>�q�ή榡</option>
					<option value="Y" <%=strBankSpec.equals("Y")?" selected":""%>>�Ȧ�榡</option>
				</select>
			</TD>
			<TD></TD>
		</TR>
		<TR>  
			<TD>�b�����A          *:</TD>
			<TD>
				<select id="txtBkStAt" name="txtBkStAt" class="Data">
					<option value="N" <%=strBankStatus.equals("N")?" selected":""%>>����</option>
					<option value="Y" <%=strBankStatus.equals("Y")?" selected":""%>>�ҥ�</option>
				</select>
			</TD>
	        <TD></TD>	
		</TR>
		<TR>
		    <TD>�Ƶ�   :</TD>
			<TD><INPUT type="text" id="txtBkMeMo" name="txtBkMeMo" size="30" maxlength="100" value="<%=strBankMemo%>" class="Data"></TD>
            <TD></TD>		 
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">

</form>
<P><BR>* ��������J����</P>
<P><BR></P>
</BODY>
</HTML>
