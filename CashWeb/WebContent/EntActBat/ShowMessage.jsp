<%
if(request.getCharacterEncoding() == null){            
  	request.setCharacterEncoding("Big5"); // 通常這是 JSP 或 Servlet 的編碼
} 
String clientMessage = "";
if(request.getParameter("txtMsg")!=null){
	clientMessage = request.getParameter("txtMsg");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>ErrorMessage.jsp</TITLE>
<SCRIPT>
function WindowOnLoad()
{
	if(document.getElementById("txtMsg").value!=""){
		alert(document.getElementById("txtMsg").value);
	}
}
</SCRIPT>

</HEAD>
<BODY onload="return WindowOnLoad()">
<INPUT id=txtMsg name=txtMsg value="<%=clientMessage%>" type=hidden>
</BODY>
</HTML>
