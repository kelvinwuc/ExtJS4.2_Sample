<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : ���n�b�B�z
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
 * $Log: EntActBatC.jsp,v $
 * Revision 1.5  2013/12/24 04:02:15  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */
%><%! String strThisProgId = "EntActBatC"; //���{���N�� %><% 
String strMsg = (request.getAttribute("txtError") == null)?"":(String)request.getAttribute("txtError");
String strError = (request.getAttribute("error") == null)?"":(String)request.getAttribute("error");
%>
<html>
<head>
<title>���n�b�B�z</title>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientR.js"></SCRIPT>
<SCRIPT>
<!--
function WindowOnLoad() 
{
	if( document.getElementById("serverMessage").value != "")
		window.alert(document.getElementById("serverMessage").value);

	WindowOnLoadCommon( document.title , '', strFunctionKeyUpload, '' );
	window.status = "";
}

/* ��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q���� */
function resetAction()
{
	document.forms("frmMain").reset();
}

/* ��toolbar frame ����<�W��>���s�Q�I���,����Ʒ|�Q���� */
function uploadAction()
{
	if(CompareVal(GetVal())) {
		document.frmMain.submit();
	}
}

function GetVal() {
	var arrVal = new Array();
    for (var i = 1; i < 11; i++) {
    var temp = document.getElementById("FILE"+i).value;
        if (temp != "") {
            var ind = temp.lastIndexOf('\\');
            temp=temp.substring(ind+1, temp.length);
            arrVal.push(temp);
        }
    } 
    return arrVal;
}

function CompareVal(fnList) 
{
    var flag = true;
    var varMsg = "";
    for (var i = 0; i < fnList.length; i++) {
        for (var j = i+1; j < fnList.length; j++) {
            if (fnList[i] == fnList[j]) {
                varMsg += "��" + (i + 1) + "�ӤW�Ǥ��P��" + (j + 1) + "�ӤW�Ǥ�󪺦W�٬ۦP�A�Эק�䤤�@�Ӥ���W�ǡI\n\r";
                flag = false;
            }
        }
    }

    if(varMsg != "")
    	alert(varMsg);

    return flag;
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<FORM name="frmMain" METHOD="POST" ACTION="<%=request.getContextPath()%>/servlet/com.aegon.entactbat.EntActBatServlet" enctype="multipart/form-data">
<BR>��J�C���ɮ�*:<BR>
<TABLE>
	<TR>
		<TD align="right" class="TableHeading">1�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload1" ID="FILE1"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">2�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload2" ID="FILE2"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">3�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload3" ID="FILE3"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">4�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload4" ID="FILE4"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">5�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload5" ID="FILE5"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">6�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload6" ID="FILE6"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">7�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload7" ID="FILE7"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">8�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload8" ID="FILE8"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">9�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload9" ID="FILE9"></TD>
	</TR>
	<TR>
		<TD align="right" class="TableHeading">10�G</TD>
		<TD><INPUT TYPE="FILE" NAME="FileUpload10" ID="FILE10"></TD>
	</TR>
</TABLE>
<BR><HR><BR>
�W�Ǥ����ɰT���G<BR>
<%=strMsg%>
<BR>
<% if(strError.equals("Y")) { %>
<a href="<%=request.getContextPath()%>/servlet/com.aegon.EntActBat.EntActBatServlet" >�U���n�b���~�O������</a>
<% } %>
<INPUT type="hidden" id="serverMessage" name="serverMessage" value="<%=strMsg%>">
</FORM>
</BODY>
</HTML>
