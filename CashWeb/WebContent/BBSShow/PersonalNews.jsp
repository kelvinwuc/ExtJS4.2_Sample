<%@ page contentType="text/html;charset=BIG5" %>
<HTML>
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT>
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;
	WindowOnLoadCommon( document.title , '' , '','' ) ;
	//LoadServerData();			//��Server�ݤU�����
	window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
	//disableKey();
	//disableData();
}


</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad()">
<INPUT TYPE="hidden" id="txtMsg" name="txtMsg" value=''>
</BODY>
</HTML>