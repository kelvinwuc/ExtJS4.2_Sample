<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �Ȧ�n�b����
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
 * $Log: EntActRptC.jsp,v $
 * Revision 1.8  2014/02/25 09:04:20  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-03
 * �٭�
 *
 * Revision 1.7  2014/02/25 03:41:56  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-03
 * �٭�
 *
 * Revision 1.6  2014/02/19 08:52:30  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-03
 * �٭�
 *
 * Revision 1.5  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%><%! String strThisProgId = "EntActRptC"; //���{���N�� %><%
GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�Ȧ�n�b����</TITLE>
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
		window.alert(document.getElementById("txtMsg").value) ;
	WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' ) ;
}

/*  �d�ߪ��ĳ��N�X�αb��  */
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
	var strSql = "select BKCODE,BKNAME,BKATNO,BKCURR,BKADDT from CAPBNKF where 1 = 1 ";
	if( document.getElementById("txtEBKCD").value != "" )
		strSql += " and BKCODE = '"+document.getElementById("txtEBKCD").value +"' ";
	if( document.getElementById("txtEATNO").value != "" )
		strSql += " and BKATNO = '"+document.getElementById("txtEATNO").value +"' ";
	if( document.getElementById("txtCURRENCY").value != "" )
		strSql += " and BKCURR = '"+document.getElementById("txtCURRENCY").value +"' ";	
	strSql += " ORDER BY BKCODE,BKADDT";
	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=600&Time="+new Date();
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
		document.getElementById("txtCURRENCY").value = returnArray[2];
	}
}

function getEBKRMD_S1() {
	show_calendar('frmMain.dspEBKRMD_S1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
function getEBKRMD_E1() {
	show_calendar('frmMain.dspEBKRMD_E1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function confirmAction() {
	mapValue();

	if(document.getElementById("txtEBKCD").value == "" &&
		document.getElementById("txtEATNO").value == "" &&
		document.getElementById("txtCURRENCY").value == "" &&
		document.getElementById("para_EBKRMD_S1").value == "0010101" &&
		document.getElementById("para_EBKRMD_E1").value == "9991231")
	{
		alert("�п�J�d�߱���!!");
		return false;
	}

	getSqlstm();
	
	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF" ;
		document.frmMain.OutputFileName.value = "EntActRpt.pdf" ;
	}
	else
	{
		document.frmMain.OutputType.value = "XLS" ;
		document.frmMain.OutputFileName.value = "EntActRpt.XLS" ;
	}
	if(document.frmMain.rdRpType[0].checked)
	{
		document.getElementById("para_RpType").value ="1";
	}
	else
	{
		document.getElementById("para_RpType").value ="2";
	}

	if(document.getElementById("chkOpenNew").checked){
		document.getElementById("frmMain").target="_blank";
	}else{
		winToolBar.ShowButton( "E" );
		var objOutputFrame = document.getElementById("outputFrame") ;
		document.getElementById("frmMain").target="outputFrame";
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
	}

	// �s�@����
	document.getElementById("frmMain").submit();
}

function mapValue(){
	document.getElementById("para_EBKRMD_S1").value = rocDate2String(document.getElementById("dspEBKRMD_S1").value) ;	
	document.getElementById("para_EBKRMD_E1").value = rocDate2String(document.getElementById("dspEBKRMD_E1").value) ;	
	document.getElementById("para_BnkNo").value = document.getElementById("txtEBKCD").value ;	
	document.getElementById("para_BnkAcct").value = document.getElementById("txtEATNO").value ;	
	document.getElementById("para_CURRENCY").value = document.getElementById("txtCURRENCY").value ;		
}

function checkClientField(objThisItem,bShowMsg ){
	var bDate = true;
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
	}	
	if( objThisItem.id == "para_EBKRMD_S1" || objThisItem.id == "para_EBKRMD_E1")
	{
		bDate = true ;		
		bDate = isValidDate(objThisItem.value,'C');
		if (bDate == false){
			strTmpMsg = "����榡���~";
			bShowMsg = true;
		}		
	}
}

function getSqlstm(){
   var strSql ="";

	if(document.frmMain.rdRpType[0].checked)
	{
		strSql = " select * FROM CAPBNKF A, CAPCSHF B ";
	}
	else
	{
		strSql = " SELECT A.BKNAME,B.EBKCD, B.EATNO, B.EBKRMD,SUM(B.ENTAMT) AS ENTAMT,B.CSHFCURR FROM CAPBNKF A, CAPCSHF B ";
	}

	strSql += " WHERE a.bkcode = b.ebkcd and a.bkatno = b.eatno AND A.BKCURR=B.CSHFCURR ";
	if(document.getElementById("para_BnkNo").value != ""){
		strSql += " AND A.BKCODE = '" + document.getElementById("para_BnkNo").value + "' ";
	}
	if(document.getElementById("para_BnkAcct").value != ""){
		strSql += " AND A.BKATNO = '" + document.getElementById("para_BnkAcct").value + "' ";
	}
	if(document.getElementById("para_CURRENCY").value != ""){
		strSql += " AND A.BKCURR = '" + document.getElementById("para_CURRENCY").value + "' ";
	}
	if(document.getElementById("para_EBKRMD_S1").value != ""){
		strSql += " AND B.EBKRMD >= " + document.getElementById("para_EBKRMD_S1").value ;
	}
	if(document.getElementById("para_EBKRMD_E1").value != ""){
		strSql += " AND B.EBKRMD <= " + document.getElementById("para_EBKRMD_E1").value ;
	}
	if(document.frmMain.rdRpType[0].checked) {
		strSql +=" ORDER BY B.EBKCD, B.EATNO, B.EBKRMD";
	}
	else
	{
		strSql +=" GROUP BY A.BKNAME, B.EBKCD, B.EATNO, B.CSHFCURR,B.EBKRMD ORDER BY B.EBKCD, B.EATNO,B.EBKRMD";
	}

	document.getElementById("ReportSQL").value = strSql;
}

// ���} Button
function exitAction(){
	document.getElementById("outputFrame").height = 0;
	document.getElementById("outputFrame").width = 0 ;
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
<FORM name='frmMain' id="frmMain" method='POST' target="_self" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="0">
	<TR>	
		<TD>�п�ܳ���榡�G</TD>
		<TD width="305">
		  <input type="radio" name="rdReportForm" id="rdReportForm" Value="PDF" class="Data" checked>PDF 
		  <input type="radio" name="rdReportForm" id="rdReportForm" Value="XLS" class="Data">EXCEL</TD>
	</TR>
	<TR>
		<TD>�п��Query�G</TD>
		<TD width="305">
		  <input type="radio" name="rdRpType" id="rdRpType" Value="1" class="Data" checked>�n�b���� 
		  <input type="radio" name="rdRpType" id="rdRpType" Value="2" class="Data">�n�b�J�`<INPUT id="para_RpType" name="para_RpType" value="" type="hidden"></TD>
	</TR>		
	<TR>
		<TD>���ĳ��N�X :</TD>
		<TD><INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value="">
		    <INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode()" value="�N�X�d��"></TD>
		<TD>(�п�J���ꤤ�ߥN�X)<INPUT type="hidden" name="para_BnkNo" id="para_BnkNo" value=""></TD>
	</TR>
	<TR>
		<TD>���ĳ��N�� :</TD>
		<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value=""></TD>
		<TD><INPUT type="hidden" name="para_BnkAcct" id="para_BnkAcct" value=""></TD>
	</TR>
	<TR>
		<TD>���O :</TD>
		<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="17" maxlength="17" value=""></TD>
		<TD><INPUT type="hidden" name="para_CURRENCY" id="para_CURRENCY" value=""></TD>
	</TR>
	<TR>
		<TD>�Ȧ�״ڰ_�� :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_S1" name="dspEBKRMD_S1" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);" ></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEBKRMD_S1()"></A><INPUT type="hidden" name="para_EBKRMD_S1" id="para_EBKRMD_S1" value=""></TD>
	</TR>
	<TR>
		<TD>�Ȧ�״ڨ��� :</TD>
		<TD><INPUT type="text" id="dspEBKRMD_E1" name="dspEBKRMD_E1" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEBKRMD_E1()"></A><INPUT type="hidden" name="para_EBKRMD_E1" id="para_EBKRMD_E1" value=""></TD>
	</TR>
</TABLE>

<!--���VRAS�Ҧb��m,report�]�n��b�ҫ����|-->
<INPUT type="hidden" id="ReportName" name="ReportName" value="EntActRpt.rpt"> 
<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
<INPUT type="hidden" id="OutputFileName" name="OutputFileName" value="EntActRpt.pdf">
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
