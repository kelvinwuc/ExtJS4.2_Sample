<%@ page contentType="application/json;charset=utf-8" import="com.mossle.student.*" %><%
    request.setCharacterEncoding("utf-8");
    response.setCharacterEncoding("utf-8");

    String dateField = request.getParameter("dateField");
    System.out.println("dateField:" + dateField);
    out.print("{success:true,msg:'" + dateField + "'}");
%>