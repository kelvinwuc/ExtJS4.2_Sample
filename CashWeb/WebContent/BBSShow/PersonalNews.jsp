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
	//LoadServerData();			//自Server端下載資料
	window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
	//disableKey();
	//disableData();
}


</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad()">
<INPUT TYPE="hidden" id="txtMsg" name="txtMsg" value=''>
</BODY>
</HTML>