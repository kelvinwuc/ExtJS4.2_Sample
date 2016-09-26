<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �Ȧ��b�J�`��(�U�Ȧ楼�P�w�P�b�J�`��)
 * 
 * Remark   : ��b����
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
 * $Log: BalDayRptC.jsp,v $
 * Revision 1.8  2014/02/19 08:52:30  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-03
 * �٭�
 *
 * Revision 1.7  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%><%! String strThisProgId = "BalDayRptC"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar = commonUtil.getBizDateByRCalendar();
%>
<HTML>
<HEAD>
<TITLE>�U�Ȧ楼�P�w�P�b�J�`��</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' ) ;
}

/* �d�ߪ��ĳ��N�X�αb��  */
function getBankCode()
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
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR from CAPBNKF where 1 = 1 ";
	if( document.getElementById("txtEBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtEBKCD").value +"' ";
	if( document.getElementById("txtEATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtEATNO").value +"' ";
	strSql += " ORDER BY BKCODE";

	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600";
<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
    session.setAttribute("Heading","���ĳ��N��,���ĳ��W��,���ĳ��b��,���O");
    session.setAttribute("DisplayFields", "BKCODE,BKNAME,BKATNO,BKCURR");
    session.setAttribute("ReturnFields", "BKCODE,BKATNO,BKCURR");
%>
	var strReturnValue = window.showModalDialog( "../CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );

	if( strReturnValue != "" )
	{
		enableAll();
		var returnArray = string2Array(strReturnValue,",");
		document.getElementById("txtEBKCD").value = returnArray[0];
		document.getElementById("txtEATNO").value = returnArray[1];
		document.getElementById("txtCURRENCY").value = returnArray[2];
	}
}

//R00393
function getEBKRMD_S1() {
	show_calendar('frmMain.dspEBKRMD_S1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_E1() {
	show_calendar('frmMain.dspEBKRMD_E1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_S2() {
	show_calendar('frmMain.dspEBKRMD_S2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_E2() {
	show_calendar('frmMain.dspEBKRMD_E2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_S3() {
	show_calendar('frmMain.dspEBKRMD_S3','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_E3() {
	show_calendar('frmMain.dspEBKRMD_E3','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_S1() {
	show_calendar('frmMain.dspEAEGDT_S1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_E1() {
	show_calendar('frmMain.dspEAEGDT_E1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_S2() {
	show_calendar('frmMain.dspEAEGDT_S2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_E2() {
	show_calendar('frmMain.dspEAEGDT_E2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_S3() {
	show_calendar('frmMain.dspEAEGDT_S3','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEAEGDT_E3() {
	show_calendar('frmMain.dspEAEGDT_E3','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function confirmAction() {
	mapValue();

	if(document.getElementById("txtEBKCD").value == "" &&
		document.getElementById("txtEATNO").value == "" &&
		document.getElementById("txtCURRENCY").value == "" &&
		document.getElementById("EBKRMD_S1").value == "0010101" &&
		document.getElementById("EBKRMD_E1").value == "9991231" &&	
		document.getElementById("EBKRMD_S2").value == "0010101" &&
		document.getElementById("EBKRMD_E2").value == "9991231" &&	
		document.getElementById("EBKRMD_S3").value == "0010101" &&
		document.getElementById("EBKRMD_E3").value == "9991231" &&
		document.getElementById("EAEGDT_S1").value == "0010101" &&
		document.getElementById("EAEGDT_E1").value == "9991231" &&	
		document.getElementById("EAEGDT_S2").value == "0010101" &&
		document.getElementById("EAEGDT_E2").value == "9991231" &&	
		document.getElementById("EAEGDT_S3").value == "0010101" &&
		document.getElementById("EAEGDT_E3").value == "9991231")
	{
		alert("�п�J�d�߱���!!");
		return false;
	}

	winToolBar.ShowButton( "E" );
	var objOutputFrame = document.getElementById("outputFrame") ;
	objOutputFrame.height="100%";
	objOutputFrame.width="100%";
	objOutputFrame.src="<%=request.getContextPath()%>/reportProcessing.html";
	document.getElementById("inputArea").style.display="none";
	while(true){
		if(objOutputFrame.readyState=='complete'){
			break;
		}else{
			window.showModalDialog( '<%=request.getContextPath()%>/NewMenu/blank_close.html');
		}
	}
	document.getElementById("frmMain").submit();
}

function mapValue() {
	document.getElementById("EBKRMD_S1").value = rocDate2String(document.getElementById("dspEBKRMD_S1").value) ;	
	document.getElementById("EBKRMD_E1").value = rocDate2String(document.getElementById("dspEBKRMD_E1").value) ;	
	document.getElementById("EBKRMD_S2").value = rocDate2String(document.getElementById("dspEBKRMD_S2").value) ;
	document.getElementById("EBKRMD_E2").value = rocDate2String(document.getElementById("dspEBKRMD_E2").value) ;	
	document.getElementById("EBKRMD_S3").value = rocDate2String(document.getElementById("dspEBKRMD_S3").value) ;
	document.getElementById("EBKRMD_E3").value = rocDate2String(document.getElementById("dspEBKRMD_E3").value) ;
	document.getElementById("EAEGDT_S1").value = rocDate2String(document.getElementById("dspEAEGDT_S1").value) ;
	document.getElementById("EAEGDT_E1").value = rocDate2String(document.getElementById("dspEAEGDT_E1").value) ;	
	document.getElementById("EAEGDT_S2").value = rocDate2String(document.getElementById("dspEAEGDT_S2").value) ;
	document.getElementById("EAEGDT_E2").value = rocDate2String(document.getElementById("dspEAEGDT_E2").value) ;	
	document.getElementById("EAEGDT_S3").value = rocDate2String(document.getElementById("dspEAEGDT_S3").value) ;
	document.getElementById("EAEGDT_E3").value = rocDate2String(document.getElementById("dspEAEGDT_E3").value) ;	
	document.getElementById("EBKCD").value = document.getElementById("txtEBKCD").value ;	
	document.getElementById("EATNO").value = document.getElementById("txtEATNO").value ;	
	document.getElementById("CURRENCY").value = document.getElementById("txtCURRENCY").value ;		
}

function checkClientField(objThisItem,bShowMsg) {

	var bReturnStatus = true;
	var strTmpMsg = "";
	var bDate = true;
	if( objThisItem.name == "dspEBKRMD_S1" || objThisItem.name == "dspEBKRMD_E1" || objThisItem.name == "dspEBKRMD_S2" ||
	    objThisItem.name == "dspEBKRMD_E2" || objThisItem.name == "dspEBKRMD_S3" || objThisItem.name == "dspEBKRMD_E3" ||
	    objThisItem.name == "dspEAEGDT_S1" || objThisItem.name == "dspEAEGDT_E1" || objThisItem.name == "dspEAEGDT_S2" ||
	    objThisItem.name == "dspEAEGDT_E2" || objThisItem.name == "dspEAEGDT_S3" || objThisItem.name == "dspEAEGDT_E3")
	{
		bDate = true ;		
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false){
			strTmpMsg = "����榡���~";
			bReturnStatus = false;
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

// ���} Button
function exitAction() {
	document.getElementById("outputFrame").height = 0;
	document.getElementById("outputFrame").width = 0;
	document.getElementById("inputArea").style.display="block";
	// ��ܽT�{��
	winToolBar.ShowButton( "H,R,E" );
}

/* ��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q���� */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<P></P>
<DIV id="inputArea">
<FORM id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.balchkrpt.BalanceRptServlet?act=query">
<TABLE border="0">
	<TR>
		<TD>���ĳ��N�X :</TD>
		<TD><INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="">
		    <INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode();" value="�N�X�d��"></TD>
		<TD>(�п�J���ꤤ�ߥN�X)<INPUT type="hidden" name="EBKCD" id="EBKCD" value=""></TD>
	</TR>
	<TR>
		<TD>���ĳ��N�� :</TD>
		<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value=""></TD>
		<TD><INPUT type="hidden" name="EATNO" id="EATNO" value=""></TD>
	</TR>
	<TR>
		<TD>���O :</TD>
		<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="3" maxlength="2" value="" ></TD>
		<TD><INPUT type="hidden" name="CURRENCY" id="CURRENCY" value=""></TD>
	</TR>
    <TR><TD class="TableHeading">���P�b:</TD></TR>
	<TR>
		<TD>�Ȧ�״ڰ_�� :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_S1" name="dspEBKRMD_S1" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEBKRMD_S1();"></A><INPUT type="hidden" name="EBKRMD_S1" id="EBKRMD_S1" value=""></TD>
	</TR>
	<TR>
		<TD>�Ȧ�״ڨ��� :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_E1" name="dspEBKRMD_E1" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEBKRMD_E1();"></A><INPUT type="hidden" name="EBKRMD_E1" id="EBKRMD_E1" value=""></TD>
	</TR>
	<TR>
		<TD>���y�J�b�_�� :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_S1" name="dspEAEGDT_S1" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEAEGDT_S1();"></A><INPUT type="hidden" name="EAEGDT_S1" id="EAEGDT_S1" value=""></TD>
	</TR>
	<TR>
		<TD>���y�J�b���� :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_E1" name="dspEAEGDT_E1" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEAEGDT_E1();"></A><INPUT type="hidden" name="EAEGDT_E1" id="EAEGDT_E1" value=""></TD>
	</TR>
	<TR><TD class="TableHeading">�w�P�b(1):</TD></TR>
	<TR>
		<TD>�Ȧ�״ڰ_�� :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_S2" name="dspEBKRMD_S2" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEBKRMD_S2();"></A><INPUT type="hidden" name="EBKRMD_S2" id="EBKRMD_S2" value=""></TD>
	</TR>
	<TR>
		<TD>�Ȧ�״ڨ��� :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_E2" name="dspEBKRMD_E2" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEBKRMD_E2();"></A><INPUT type="hidden" name="EBKRMD_E2" id="EBKRMD_E2" value=""></TD>
	</TR>
	<TR>
		<TD>���y�J�b�_�� :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_S2" name="dspEAEGDT_S2" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEAEGDT_S2();"></A><INPUT type="hidden" name="EAEGDT_S2" id="EAEGDT_S2" value=""></TD>
	</TR>
	<TR>
		<TD>���y�J�b���� :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_E2" name="dspEAEGDT_E2" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEAEGDT_E2();"></A><INPUT type="hidden" name="EAEGDT_E2" id="EAEGDT_E2" value=""></TD>
	</TR>
	<TR>
    <TD class="TableHeading">�w�P�b(2):</TD>
    </TR>
	<TR>
		<TD>�Ȧ�״ڰ_�� :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_S3" name="dspEBKRMD_S3" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEBKRMD_S3();"></A><INPUT type="hidden" name="EBKRMD_S3" id="EBKRMD_S3" value=""></TD>
	</TR>
	<TR>
		<TD>�Ȧ�״ڨ��� :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_E3" name="dspEBKRMD_E3" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEBKRMD_E3();"></A><INPUT type="hidden" name="EBKRMD_E3" id="EBKRMD_E3" value=""></TD>
	</TR>
	<TR>
		<TD>���y�J�b�_�� :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_S3" name="dspEAEGDT_S3" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEAEGDT_S3();"></A><INPUT type="hidden" name="EAEGDT_S3" id="EAEGDT_S3" value=""></TD>
	</TR>
	<TR>
		<TD>���y�J�b���� :</TD>
		<TD><INPUT type="text" id="dspEAEGDT_E3" name="dspEAEGDT_E3" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEAEGDT_E3();"></A><INPUT type="hidden" name="EAEGDT_E3" id="EAEGDT_E3" value=""></TD>
	</TR>
</TABLE>

<!--���VRAS�Ҧb��m,report�]�n��b�ҫ����|-->
<INPUT type="hidden" id="ReportName" name="ReportName" value="BalanceRpt.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="BalanceRpt.pdf">
<INPUT type="hidden" id="ReportSQL" name="ReportSQL" value="">
<INPUT type="hidden" id="ReportPath" name="ReportPath" value="<%=globalEnviron.getRootPath()%>BalChkRpt\\">
</FORM>

<BR>
<INPUT type="checkbox" id="chkOpenNew" name="chkOpenNew">&nbsp;�}�ҷs����
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
</DIV>
<IFRAME id="outputFrame" name="outputFrame" height="0" width="0"></IFRAME>
</BODY>
</HTML>