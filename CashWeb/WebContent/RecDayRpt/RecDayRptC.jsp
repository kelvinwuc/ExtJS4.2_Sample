<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true"  %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CASHWEB
 * 
 * Function : �w�P�b���Ӫ�
 * 
 * Remark   : ��b����
 * 
 * Revision : $$Revision: 1.16 $$
 * 
 * Author   : $$Author: MISSALLY $$
 * 
 * Create Date : $$Date: 2014/02/25 09:04:20 $$
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $$Log: RecDayRptC.jsp,v $
 * $Revision 1.16  2014/02/25 09:04:20  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��-03
 * $�٭�
 * $
 * $Revision 1.15  2014/02/25 03:41:56  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��-03
 * $�٭�
 * $
 * $Revision 1.14  2014/02/19 08:52:30  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��-03
 * $�٭�
 * $
 * $Revision 1.13  2014/02/10 02:09:32  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��-02
 * $BugFix---�ץ������ܰ��D
 * $
 * $Revision 1.12  2014/02/06 09:52:59  MISSALLY
 * $RB0806---�ק���ȴC�黼�e��
 * $$
 *  
 */
%><%! String strThisProgId = "RecDayRpt"; //���{���N�� %><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

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
sbCurrCash.append("<option value=\"\">����</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equals("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected >").append(strValue).append("</option>");
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
<TITLE>�w�P�b���Ӫ�C�L</TITLE>
<META http-equiv="Content-Style-Type" content="text/css">
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

	WindowOnLoadCommon( document.title, '', 'H', '' );
	window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
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

function getImpDay1(){
	show_calendar('frmMain.dspImpDay1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function getImpDay2(){
	show_calendar('frmMain.dspImpDay2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function getEntDay1(){
	show_calendar('frmMain.dspEntDay1','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function getEntDay2(){
	show_calendar('frmMain.dspEntDay2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}

function confirmAction()
{
	mapValue();

	if(document.getElementById("txtEBKCD").value == "" && 
		document.getElementById("txtEATNO").value == "" && 
		document.getElementById("txtCURRENCY").value == "" &&
		document.getElementById("para_ImpDay1").value == "0010101" &&
		document.getElementById("para_ImpDay2").value == "9991231" &&
		document.getElementById("para_EntDay1").value == "0010101" &&
		document.getElementById("para_EntDay2").value == "9991231") 
	{
		alert("�п�J�d�߱���!!");
		return false;
	}
	if(document.frmMain.rdReportForm[0].checked)
	{
		document.frmMain.OutputType.value = "PDF" ;
		document.frmMain.OutputFileName.value = "DailyCas.pdf" ;
	}
	else
	{
		document.frmMain.OutputType.value = "XLS" ;
		document.frmMain.OutputFileName.value = "DailyCas.XLS" ;
	}

	getSqlstm();
	if(document.getElementById("chkOpenNew").checked) {
		document.getElementById("frmMain").target="_blank";
	} else {
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

function mapValue()
{
	document.getElementById("para_ImpDay1").value = rocDate2String(document.getElementById("dspImpDay1").value);
	document.getElementById("para_ImpDay2").value = rocDate2String(document.getElementById("dspImpDay2").value);
	document.getElementById("para_BnkNo").value = document.getElementById("txtEBKCD").value;
	document.getElementById("para_BnkAcct").value = document.getElementById("txtEATNO").value;
	document.getElementById("para_EntDay1").value = rocDate2String(document.getElementById("dspEntDay1").value);
	document.getElementById("para_EntDay2").value = rocDate2String(document.getElementById("dspEntDay2").value);
	document.getElementById("para_ParmRemk").value = document.getElementById("ParmRemk").value;
}

function checkClientField(objThisItem,bShowMsg)
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";

	if( objThisItem.name == "dspImpDay1" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "�Ȧ�״ڰ_��-����榡���~";
	        bReturnStatus = false;			
        }
	}
	if( objThisItem.name == "dspImpDay2" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "�Ȧ�״ڨ���-����榡���~";
	        bReturnStatus = false;			
        }
	}
	if( objThisItem.name == "dspEntDay1" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "���y�J�b�_��-����榡���~";
	        bReturnStatus = false;			
        }
	}
	if( objThisItem.name == "dspEntDay2" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "���y�J�b����-����榡���~";
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

function getSqlstm()
{
	var strSql = " SELECT A.BKNAME,B.EBKCD,B.EATNO,B.EBKRMD,B.ENTAMT,B.EAEGDT,B.ECRDAY,B.EUSREM ,B.EUSREM2,B.CSHFAU,B.CSHFAD,B.CSHFAT,B.CSHFUD,B.CSHFUT,B.CSHFUU,B.CROTYPE,B.CSHFCURR,B.CSHFPOCURR ";
	strSql += " FROM CAPBNKF A ";
	strSql += " JOIN CAPCSHF B ON A.BKCODE = B.EBKCD AND A.BKATNO = B.EATNO AND A.BKCURR=B.CSHFCURR ";
	strSql += " WHERE B.EAEGDT>0 AND B.EBKRMD BETWEEN " + document.getElementById("para_ImpDay1").value + " and " +document.getElementById("para_ImpDay2").value;
	strSql += " AND B.EAEGDT BETWEEN " + document.getElementById("para_EntDay1").value + " and " + document.getElementById("para_EntDay2").value;

	if (document.getElementById("txtEBKCD").value != "") {
		strSql += " AND A.BKCODE = '" + document.getElementById("txtEBKCD").value +"'";
	}
	if (document.getElementById("txtEATNO").value != "") {
		strSql += " AND A.BKATNO = '" + document.getElementById("txtEATNO").value +"'";
	}
	if (document.getElementById("txtCURRENCY").value != "") {
		strSql += " AND A.BKCURR = '" + document.getElementById("txtCURRENCY").value +"'";
	}
	if (document.getElementById("ParmRemk").value != "") {
		strSql += " AND B.EUSREM2 LIKE '%" + document.getElementById("ParmRemk").value +"%'";
	}
	//R80338 �O����O
	if (document.getElementById("para_POCURR").value != "") {
		strSql += " AND B.CSHFPOCURR = '" + document.getElementById("para_POCURR").value +"'";
	}

	strSql += " order by B.ENTAMT,B.EBKCD,B.EATNO,B.EBKRMD,B.EAEGDT ";	 

	document.getElementById("ReportSQL").value = strSql;
}
// ���} Button
function exitAction() 
{
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
<BODY onload="WindowOnLoad()">
<P></P>
<DIV id="inputArea">
<FORM name='frmMain' method='POST' target="_self" action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS">
<TABLE border="0">
	<TR>
		<TD>�п�ܳ���榡�G</TD>
		<TD width="305">
			<input type="radio" name="rdReportForm" id="rdReportForm" value="PDF" class="Data" checked>PDF 
			<input type="radio" name="rdReportForm" id="rdReportForm" value="XLS" class="Data">EXCEL</TD>
		<TD>&nbsp;</TD>
	</TR>	
	<TR>
		<TD>���ĳ��N�X :</TD>
		<TD><INPUT type="text" id="txtEBKCD" name="txtEBKCD" size="4" maxlength="4" value=""> <INPUT type="button" id="btnGetBankCode" name="btnGetBankCode" onClick="getBankCode()" value="�N�X�d��"></TD>
		<TD>(�п�J���ꤤ�ߥN�X)<INPUT type="hidden" name="para_BnkNo" id="para_BnkNo" value=""></TD>
	</TR>
	<TR>
		<TD>���ĳ��N�� :</TD>
		<TD><INPUT type="text" id="txtEATNO" name="txtEATNO" size="17" maxlength="17" value=""></TD>
		<TD><INPUT type="hidden" name="para_BnkAcct" id="para_BnkAcct" value=""></TD>
	</TR>
	<TR>
		<TD>���O :</TD>
		<TD><INPUT type="text" id="txtCURRENCY" name="txtCURRENCY" size="3" maxlength="2" value="" class="Key"></TD>
		<TD>&nbsp;</TD>
	</TR>
	<TR>
		<TD>�Ȧ�״ڰ_�� :</TD>
		<TD><INPUT type="text" id="dspImpDay1" name="dspImpDay1" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getImpDay1()"></A><INPUT type="hidden" name="para_ImpDay1" id="para_ImpDay1" value=""></TD>
	</TR>
	<TR>
		<TD>�Ȧ�״ڨ��� :</TD>
		<TD><INPUT type="text" id="dspImpDay2" name="dspImpDay2" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getImpDay2()"></A><INPUT type="hidden" name="para_ImpDay2" id="para_ImpDay2" value=""></TD>
	</TR>
	<TR>
		<TD>���y�J�b�_�� :</TD>
		<TD><INPUT type="text" id="dspEntDay1" name="dspEntDay1" size="9" maxlength="9" class="Data" value="001/01/01" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEntDay1()"></A><INPUT type="hidden" name="para_EntDay1" id="para_EntDay1" value=""></TD>
	</TR>
	<TR>
		<TD>���y�J�b���� :</TD>
		<TD><INPUT type="text" id="dspEntDay2" name="dspEntDay2" size="9" maxlength="9" class="Data" value="999/12/31" onblur="checkClientField(this,true);"></TD>
		<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getEntDay2()"></A><INPUT type="hidden" name="para_EntDay2" id="para_EntDay2" value=""></TD>
	</TR>
	<TR>
		<TD>�P�b�Ƶ� :</TD>
		<TD><INPUT type="text" id="ParmRemk" name="ParmRemk" size="40" maxlength="40" value=""></TD>
		<TD><INPUT type="hidden" name="para_ParmRemk" id="para_ParmRemk" value=""></TD>	
	</TR>
	<TR>
		<TD>�־P�ӷ� :</TD>
		<TD>
			<select id="para_CROTYPE1" name="para_CROTYPE1">
			    <option value="">����</option>
				<option value="C">Capsil</option>
				<option value="G">GTMS</option>
				<option value="F">FF</option><!--R90149-->	
				<option value="T">�O�G�~</option> <!--R80413-->					
				<option value="O">Others</option>
			</select>
		</TD>
		<TD>&nbsp;</TD>
	</TR>
	<TR>
		<TD>�O����O :</TD>
		<TD>
			<select id="para_POCURR" name="para_POCURR">
				<%=sbCurrCash.toString()%>																									
			</select>
		</TD>							
		<TD>&nbsp;</TD>
	</TR>		
</TABLE>
<!--���VRAS�Ҧb��m,report�]�n��b�ҫ����|--> 
<INPUT id="ReportName" name="ReportName" value="RecDayRpt.rpt" type="hidden"> 
<INPUT id="OutputType" name="OutputType" value="PDF" type="hidden"> 
<INPUT id="OutputFileName" name="OutputFileName"  type="hidden" value="SusDetailRpt.pdf">
<INPUT id="ReportSQL" type="hidden" name="ReportSQL" value="">
<INPUT id="ReportPath" type="hidden" name="ReportPath" value="<%=globalEnviron.getRootPath()%>RecDayRpt\\">
</FORM>
<BR>
<input id="chkByAmt" name="chkByAmt" type="checkbox">&nbsp;�̪��B�Ƨ�
<input id="chkOpenNew" name="chkOpenNew" type="checkbox">&nbsp;�}�ҷs����
<INPUT id="txtMsg" name="txtMsg" value=""type="hidden"></DIV>
<IFRAME id="outputFrame" name="outputFrame" height="0" width="0"></IFRAME>
</BODY>
</HTML>
