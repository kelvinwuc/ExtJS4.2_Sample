<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393        Leo Huang    	    2010/09/23          ������|��۹���|
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

<%! String strThisProgId = "FileUpload"; 
        String ActionTarget = "servlet/CASHFileUploadS"; %>

<TITLE>�䲼�U���I�{ - �ɮפW�ǧ@�~</TITLE>

<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientR.js"></SCRIPT>

<SCRIPT>
function WindowOnLoad() 
{
	strFunctionKeyInitial = "";			//
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "";
	
}
</SCRIPT>

</HEAD>
<BODY onload="WindowOnLoad()">
<!--R00393 edit by Leo Huang 
<FORM METHOD="POST" ACTION="/CashWeb/<%= ActionTarget %>" enctype="multipart/form-data" >
-->
<FORM METHOD="POST" ACTION="../<%= ActionTarget %>" enctype="multipart/form-data" >
<!--R00393 edit by Leo Huang -->
<TABLE border="0">
	<TBODY>
		<TR>
			<TD bgcolor="#8080ff">�䲼�U���I�{ - �ɮפW�ǧ@�~</TD>
		</TR>
	</TBODY>
</TABLE>
�ɮצW��:<BR>
	<INPUT TYPE='FILE' name='upload0'><BR>
	<BR>
<INPUT TYPE="hidden" NAME="ProgId" VALUE="<%= strThisProgId %>"> 
<INPUT TYPE=SUBMIT VALUE='�W��'> <INPUT TYPE=RESET VALUE='RESET'><BR>
</FORM>
</BODY>
</HTML>
