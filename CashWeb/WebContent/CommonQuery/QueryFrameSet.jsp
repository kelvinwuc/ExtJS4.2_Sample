<%@ page contentType="text/html;charset=BIG5" %>
<HTML>
<HEAD>
<TITLE>��Ƭd��</TITLE>
<%
session.setAttribute("Sql", request.getParameter("Sql"));

String strOutput = "QueryBottom.jsp?Time=" + request.getParameter("Time")
				+ "&RowPerPage=" + request.getParameter("RowPerPage")
	        	+ "&TableWidth="+request.getParameter("TableWidth")
	        	+ "&queryType=" + request.getParameter("queryType")
	        	+ "&parm=" + request.getParameter("parm");
System.out.println("url="+strOutput);
%>
<frameset framespacing="0" frameborder="0" border="0" marginwidth="0" marginheight="0" rows="40,*">
	<frame name="top" src="QueryTop.html" NORESIZE SCROLLING="auto" marginwidth="0"  marginheight="0" border="0">
	<frame name="bottom" src="<%= strOutput %>" NORESIZE SCROLLING="auto" marginwidth="0"  marginheight="0" border="0">
<noframes>
</noframes>
	<P>�Y�n�˵��������A�z�ݭn�@�Ӥ䴩�ج[���s�����C</P>
</frameset>
</HTML>