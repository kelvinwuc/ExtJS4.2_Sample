<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393     Leo Huang    			2010/09/21          ������|��۹���|
 *    R00231     Leo Huang    			2010/09/25          ����ʦ~�M�רt�Τ�վ�Cash
 *  =============================================================================
 */
%>
<%@ page contentType="text/html;charset=Big5" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.*" %>

<HTML>
<HEAD>

<%@ include file="../Logon/Init.inc" %>
<%@ include file="../Logon/CheckLogon.inc" %>

<%! String strThisProgId = "EntActBatQ"; 
        String ActionTarget = "servlet/EntActBatS"; %>

<%
String para_Count = "";  
if (request.getAttribute("para_Count") != null) {
    para_Count = (String) request.getAttribute("para_Count");
  } 


%>        

<TITLE>���n�b - �ɮפW�ǧ@�~</TITLE>

<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientR.js"></SCRIPT>

<SCRIPT>
function WindowOnLoad() 
{
  if (document.getElementById("para_Count").value != "") {
  window.alert("���\�W�� : " + document.getElementById("para_Count").value + " ��") ;
  }	

	strFunctionKeyInitial = "";			//
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "";


}
</SCRIPT>


</HEAD>
<BODY onload="WindowOnLoad()">
<!--R00393  Edit by Leo Huang (EASONTECH) Start
<FORM METHOD="POST" ACTION="/CashWeb/<%= ActionTarget %>" enctype="multipart/form-data" >
-->
<FORM METHOD="POST" ACTION="../<%= ActionTarget %>" enctype="multipart/form-data" >
<!--R00393  Edit by Leo Huang (EASONTECH) End-->
<TABLE border="0">
	<TBODY>
		<TR>
			<TD bgcolor="#8080ff">���n�b - �ɮפW�ǧ@�~</TD>
		</TR>
				<TR>
			<TD align="right" class="TableHeading" width="101">�b���G</TD>
			<TD width="333"><select size="1" name="PBBank" id="PBBank">
				<option value="701-NT-19623637">�l��-19623637 </option>
				<!--R00231 edit by Leo Huang start
				<option value="701-NT-19623640">�l��-19623640 </option>
				<option value="701-NT-19640032">�l��-19640032 </option>				
				<option value="816-NT-00212606000300">�w��-00212606000300 </option>
				<option value="051-NT-2602016660000">IBT-2602016660000 </option>
				<option value="810-NT-002001248716">�_��-002001248716 </option>
				<option value="118-NT-04191313511770">�O�H-04191313511770 </option>
				<option value="805-NT-00300100013555">����-00300100013555 </option>
				<option value="808-NT-0303440007172">�ɤs-0303440007172 </option>
				<option value="815-NT-01701012861500">�鲱-01701012861500 </option>
				<option value="005-NT-079001025738">�g��-079001025738 </option>
				R00231 edit by Leo Huang end-->
				<option value="807-NT-12600100166607">����-12600100166607 </option>
				<!--R00231 edit by Leo Huang start
				<option value="809-NT-002118165505">�U��-002118165505 </option>
				<option value="108-NT-22420012599">���H-22420012599 </option>
				R00231 edit by Leo Huang end-->
				<option value="ALL-NT-0000000000">�q��-�t�Ȧ�b�� </option>
			</select>
			</TD>
		</tr>		
	</TBODY>
</TABLE>
�ɮצW��:<BR>
	<INPUT TYPE='FILE' name='upload0'><BR>
	<BR>
<INPUT TYPE="hidden" NAME="ProgId" VALUE="<%= strThisProgId %>">
<INPUT TYPE="hidden" NAME="PBBank" VALUE="">  
<INPUT TYPE="hidden" NAME="para_Count" VALUE="<%= para_Count %>">
<INPUT TYPE=SUBMIT VALUE='�W��'> <INPUT TYPE=RESET VALUE='RESET'><BR>
</FORM>
</BODY>
</HTML>
