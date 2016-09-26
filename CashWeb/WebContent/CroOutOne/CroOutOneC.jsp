<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.crooutone.CroOutOneConditionDTO" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �浧�P�b�B�z
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.8 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: CroOutOneC.jsp,v $
 * Revision 1.8  2014/01/24 07:11:58  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix
 *
 * Revision 1.7  2014/01/14 01:49:43  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 * �D�O�O�b�B�z
 *
 * Revision 1.6  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%><%! String strThisProgId = "CroOutOne"; //���{���N�� %><%
String strMsg = (request.getAttribute("txtMsg") == null)?"":((String)request.getAttribute("txtMsg"));

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

String strBKCD = "";
String strATNO = "";
String strCURR = "";
String strRMDDT = "";
String strAEGDT = "";
String strAMOUNT = "";
CroOutOneConditionDTO coocDTO = (session.getAttribute("condition") == null)?null:(CroOutOneConditionDTO) session.getAttribute("condition");
if(coocDTO != null) {
	session.removeAttribute("condition");

	strBKCD = coocDTO.getBkCode();
	strATNO = coocDTO.getAccount();
	strCURR = coocDTO.getCurrency();
	strAMOUNT = String.valueOf(coocDTO.getRmtAmt());
	strRMDDT = String.valueOf(coocDTO.getRmtDate());
	strAEGDT = String.valueOf(coocDTO.getAegDate());

	strAMOUNT = strAMOUNT.equals("0")?"":strAMOUNT;
	strRMDDT = strRMDDT.equals("0")?"":strRMDDT.substring(0,3)+"/"+strRMDDT.substring(3,5)+"/"+strRMDDT.substring(5,7);
	strAEGDT = strAEGDT.equals("0")?"":strAEGDT.substring(0,3)+"/"+strAEGDT.substring(3,5)+"/"+strAEGDT.substring(5,7);
}

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") ==null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
Hashtable htTemp = null;
String strValue = null;
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"all\">����</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equals(strCURR))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>�浧�P�b</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var strFirstKey 			= "txtEBKCD";		//�Ĥ@�ӥi��J��Key���W��
var strFirstData 			= "dspEAEGDT";		//�Ĥ@�ӥi��J��Data���W��

// *************************************************************
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;

	WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '');
	window.status = "";
	disableAll();
}

/**
��ƦW��:	checkClientField(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
---------	----------	-----------------------------------------
93/06/2      Jerry      �]��user�n��P�b�P������_�����P�b, �ҥH�������y�J�b�餣�i�ťժ��ˬd
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";

	if( objThisItem.name == "dspEBKRMD" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "���ĳ��״ڤ�-����榡���~";
	        bReturnStatus = false;			
        }
	}
	if( objThisItem.name == "dspEAEGDT" )
	{
		if (objThisItem.value != "000/00/00") {
			bDate = true;
			bDate = isValidDate(objThisItem.value,'C');
			if (bDate == false) {
				strTmpMsg = "���y�H�ؤJ�b��-����榡���~";
				bReturnStatus = false;
			}
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

/* ��toolbar frame ����<�d��>���s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
{
	enableAll();
	winToolBar.ShowButton( strFunctionKeyInquiry1 );
    document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus();
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
	document.frmMain.radType[0].checked = true;
}

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	winToolBar.ShowButton('I');
	document.getElementById("txtAction").value = "";
	disableAll();
}

/* �d�ߪ��ĳ��N�X�αb��  */
function getBankCode()
{
	//�ˬd�O�_��i�d�ߪ����A
	if(document.getElementById("txtEBKCD").disabled) {
		return;
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
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR from CAPBNKF where 1 = 1 ";
	if( document.getElementById("txtEBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtEBKCD").value +"' ";
	if( document.getElementById("txtEATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtEATNO").value +"' ";
	strSql += " ORDER BY BKCODE,BKADDT ";

	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
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
		document.getElementById("txtEBKCD").value = returnArray[0];
		document.getElementById("txtEATNO").value = returnArray[1];
		for(var i=0;i< document.getElementById("txtCURRENCY").options.length;i++)
		{
			if( returnArray[2]== document.getElementById("txtCURRENCY").options.item(i).value )
			{
				document.getElementById("txtCURRENCY").options.item(i).selected = true;
				break;
			}
		}
	}
}

function getRmd() {
	if(document.getElementById("dspEAEGDT").disabled){
		return ;
	}else{
		show_calendar('frmMain.dspEAEGDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
	}
}
	
function getRmd2(){
	if(document.getElementById("dspEBKRMD").disabled){
		return ;
	}else{
		show_calendar('frmMain.dspEBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
	}
}

/* ��toolbar frame ����<�T�w>���s�Q�I���,����Ʒ|�Q���� */
function confirmAction()
{
	mapValue();

	var varMsg = "";
	if(document.getElementById("txtEBKCD").value == "") {
		varMsg += "���ĳ��N�X���i�ť�\n\r";
	}
	if(document.getElementById("dspEBKRMD").value == "" && document.getElementById("txtENTAMT").value == "") {
		varMsg += "���ĳ��״ڤ�P�״ڪ��B���i�P�ɪť�\n\r";
	} else if(document.getElementById("dspEBKRMD").value != "" && !isValidDate(document.getElementById("dspEBKRMD").value,'C')) {
		varMsg += "���ĳ��״ڤ�-����榡���~\n\r";
	}
	if(document.getElementById("dspEAEGDT").value != "") {
		if(!isValidDate(document.getElementById("dspEAEGDT").value,'C')) {
			varMsg += "���y�H�ؤJ�b��-����榡���~\n\r";
		}
	}

	if(varMsg != "") {
		alert(varMsg);
		return false;
	} else {
		if(document.frmMain.radType[1].checked == true) {
			var varMsg = "�нT�{�O�_�w�g�s�W����J�b��ơA\n\r";
			varMsg += "�Y�w�s�W�A�п�ܡu�@��P�b�B�z�v�Фŭ��зs�W!!";
			if(confirm(varMsg)) {
				document.getElementById("frmMain").submit();
			}
		} else {
			document.getElementById("frmMain").submit();
		}
	}
}

function mapValue() 
{
	if(document.getElementById("dspEBKRMD").value != "") {
		document.getElementById("txtEBKRMD").value = rocDate2String(document.getElementById("dspEBKRMD").value);
	}
	if(document.getElementById("dspEAEGDT").value != "") {
		document.getElementById("txtEAEGDT").value = rocDate2String(document.getElementById("dspEAEGDT").value);
	}
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnLoad();">
<P><BR></P>
<form id="frmMain" name="frmMain" method="post" action="<%=request.getContextPath()%>/servlet/com.aegon.crooutone.CroOutOneServlet">
<TABLE border="0">
	<TBODY>
		<TR><TD colspan="4"><INPUT TYPE="radio" ID="radType" NAME="radType" VALUE="<%=CroOutOneConditionDTO.NORMAL%>" checked="checked" class="Key" />�@�@��P�b�B�z</TD></TR>
		<TR><TD colspan="4"><INPUT TYPE="radio" ID="radType" NAME="radType" VALUE="<%=CroOutOneConditionDTO.SPECIAL_I%>" class="Key" />�@�s�WI.����妸�J�b���</TD></TR>
		<TR><TD colspan="4"><INPUT TYPE="radio" ID="radType" NAME="radType" VALUE="<%=CroOutOneConditionDTO.NONE_PREM_CASE%>" class="Key" />�@�D�O�O�P�b�B�z</TD></TR>
	</TBODY>
</TABLE>
<BR>
<TABLE border="0">
	<TBODY>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���ĳ��N�X* :</TD>
			<TD>
				<INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="<%=strBKCD%>" class="Key">
				<INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode();" value="�N�X�d��" class="Key">
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���ĳ��b�� :</TD>
			<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value="<%=strATNO%>" class="Key"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���O :</TD>
			<TD>
				<select size="1" name="txtCURRENCY" id="txtCURRENCY" class="Key">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>���ĳ��״ڤ�* :</TD>
			<TD><INPUT type="text" id="dspEBKRMD" name="dspEBKRMD" size="8" maxlength="9" value="<%=strRMDDT%>" class="Key" onblur="checkClientField(this,true);"  ></TD>
			<TD><A href="javascript:show_calendar('frmMain.dspEBKRMD','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getRmd2();" ></A></TD>
		</TR>
		<TR>
			<TD>�״ڪ��B* :</TD>
			<TD><INPUT type="text" id="txtENTAMT" name="txtENTAMT" size="13" maxlength="13" value="<%=strAMOUNT%>" class="Key"></TD> 
			<TD></TD>
		</TR>
		<TR>
			<TD>���y�H�ؤJ�b�� :</TD>
			<TD><INPUT type="text" id="dspEAEGDT" name="dspEAEGDT" size="8" maxlength="9" value="<%=strAEGDT%>" class="Data" onblur="checkClientField(this,true);"></TD>
			<TD><A href="javascript:show_calendar('frmMain.dspEAEGDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getRmd();" ></A></TD>
		</TR>
		<TR><TD colspan="4"><BR></TD></TR>
		<TR><TD colspan="4"><BR></TD></TR>
		<TR><TD colspan="4">*���������A���ĳ��״ڤ�P�״ڪ��B�G�ܤ@</TD></TR>
	</TBODY>
</TABLE>              

<INPUT type="hidden" id="txtEBKRMD" name="txtEBKRMD" value="">
<INPUT type="hidden" id="txtEAEGDT" name="txtEAEGDT" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="I">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
</form>
</BODY>
</HTML>
