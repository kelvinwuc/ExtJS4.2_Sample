<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CASHWEB
 * 
 * Function : ���P�b
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : 
 * 
 * Create Date : $Date: 2014/01/03 02:51:37 $
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $$Log: CroOutBatC.jsp,v $
 * $Revision 1.3  2014/01/03 02:51:37  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��-02
 * $$
 *  
 */
%><%!String strThisProgId = "CroOutBat"; //���{���N��%><%
String strMsg = (request.getAttribute("txtMsg") == null)?"":((String)request.getAttribute("txtMsg"));
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();

Hashtable htTemp = null;
String strValue = null;

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
List alCurrCash = new ArrayList(); 
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList", alCurrCash);
} else {
	alCurrCash = (List) session.getAttribute("CurrCashList");
}
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"\">����</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equals("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("</option>");
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
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>���P�b</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title, '', 'H', '' );
	window.status = "";
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "dspEAEGDT"  )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
        strTmpMsg = "���y�H�ؤJ�b��-����榡���~";
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

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	document.getElementById("outputFrame").height=0;
	document.getElementById("outputFrame").weight=0;
	winToolBar.ShowButton("H");
}

/* ��toolbar frame ����<�T�w>���s�Q�I���,����Ʒ|�Q���� */
function confirmAction()
{
	if(document.getElementById("dspEAEGDT").value == "") {
		alert("���y�J�b�餣�i�ť�!!");
		return false;
	}

	winToolBar.ShowButton("E");
	var objOutputFrame=document.getElementById("outputFrame");
	objOutputFrame.height="100%";
	objOutputFrame.width="100%";
	objOutputFrame.src="<%=request.getContextPath()%>/batProcessing.html";
	document.getElementById("outputArea").style.display="block";
	mapValue("P2D");
	document.getElementById("txtAction").value = "H";
	while(true){
		if(objOutputFrame.readyState=='complete') {
			break;
		} else {
			window.showModalDialog( '<%=request.getContextPath()%>/NewMenu/blank_close.html');
		}
	}
	document.getElementById("frmMain").submit();
}

function mapValue(direction)
{
	if(direction.toUpperCase()=="P2D") {
		//�� �������s������
		document.getElementById("txtEAEGDT").value = rocDate2String(document.getElementById("dspEAEGDT").value) ;
	} else {
		//�۸������s������
		document.getElementById("dspEAEGDT").value = string2RocDate(document.getElementById("txtEAEGDT").value) ;
	}
	return;
}

function getRmd()
{
	show_calendar('frmMain.dspEAEGDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
}
//-->
</script>
</HEAD>
<BODY onload="WindowOnLoad();">
<FORM name="frmMain" method="POST" action="<%=request.getContextPath()%>/servlet/com.aegon.crooutbat.CroOutBatServlet" target="_self">
	<TABLE border="0">
		<TR>
			<TD>���y�H�ؤJ�b�� :</TD>
			<TD><INPUT type="text" id="dspEAEGDT" name="dspEAEGDT" size="8" maxlength="9" value="999/12/31" class="Data" onblur="checkClientField(this,true);"></TD>
			<TD><A href="#"><img src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��" onClick="getRmd()"></A></TD>	
		</TR>
		<TR>
			<TD>������O :</TD>
			<TD colspan=2>
				<select id="selCROTYPE" name="selCROTYPE">
					<option value="C">Capsil</option>
					<option value="G">GTMS</option>				
				</select>
			</TD>	
			<TD>�O����O :</TD>
			<TD>
				<select id="txtPOCURR" name="txtPOCURR" class="Data">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
	</TABLE>

	<INPUT type="hidden" id="txtEAEGDT"	name="txtEAEGDT" value=""> 
	<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
	<INPUT type="hidden" id="txtAction" name="txtAction" value="">
</FORM>
<DIV id="outputArea" style="display: none;"><IFRAME id="outputFrame" name="outputFrame" height="0" width="0"></IFRAME></DIV>
</BODY>
</HTML>