<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %><%
String message = "";
if(request.getParameter("message") != null) {
	message = request.getParameter("message");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�T������</TITLE>
<SCRIPT>
<!--
function windowOnLoad() {
	// �ˬd���ݵ����W��
	if(window.top == this) {
		document.getElementById("btnAction").value = "����" ;	
		document.getElementById("btnAction").attachEvent("onclick",closeWindow);
	} else {
//		document.getElementById("btnAction").value = "�^�W�@��" ;	
//		document.getElementById("btnAction").attachEvent("onclick",goBack);
		document.getElementById("btnAction").style.display = "none";
	}
}

function goBack() {
	//alert("back");
	window.history.back();
//
}

function closeWindow() {
	//alert("close window");
	window.close();
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="windowOnLoad();" >
<P align="center"><FONT color="red" face="�ө���" size="4"><%=message%></FONT>
<BR>
<BR>
<INPUT type="button" id="btnAction" name="btnAction" value="">
</P>
</BODY>
</HTML>