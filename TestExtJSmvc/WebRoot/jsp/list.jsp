<%@ page contentType="application/json;charset=utf-8" import="com.mossle.student.*" %><%
    request.setCharacterEncoding("utf-8");
    response.setCharacterEncoding("utf-8");
    int start = 0;
    try {
        start = Integer.parseInt(request.getParameter("start"));
        //System.out.println("start:" + start);
    } catch(Exception ex) {
        System.err.println(ex);
    }
    int limit = 13;
    try {
        limit = Integer.parseInt(request.getParameter("limit"));
        //System.out.println("limit:" + limit);
    } catch(Exception ex) {
        System.err.println(ex);
    }
    String sort = request.getParameter("sort");
    String dir = request.getParameter("dir");

    StudentDao dao = StudentDao.getInstance();
    Page pager = dao.pagedQuery(start, limit, sort, dir);

    out.print(pager.toString());
%>