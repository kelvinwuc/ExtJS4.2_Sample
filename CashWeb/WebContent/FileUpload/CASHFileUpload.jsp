<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393        Leo Huang    	    2010/09/23          絕對路徑轉相對路徑
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

<TITLE>支票託收兌現 - 檔案上傳作業</TITLE>

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
			<TD bgcolor="#8080ff">支票託收兌現 - 檔案上傳作業</TD>
		</TR>
	</TBODY>
</TABLE>
檔案名稱:<BR>
	<INPUT TYPE='FILE' name='upload0'><BR>
	<BR>
<INPUT TYPE="hidden" NAME="ProgId" VALUE="<%= strThisProgId %>"> 
<INPUT TYPE=SUBMIT VALUE='上傳'> <INPUT TYPE=RESET VALUE='RESET'><BR>
</FORM>
</BODY>
</HTML>
