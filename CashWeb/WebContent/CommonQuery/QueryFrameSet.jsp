<%@ page contentType="text/html;charset=BIG5" %>
<HTML>
<HEAD>
<TITLE>資料查詢</TITLE>
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
	<P>若要檢視此頁面，您需要一個支援框架的瀏覽器。</P>
</frameset>
</HTML>