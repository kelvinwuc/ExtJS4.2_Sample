<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'HelloExtJS4.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" type="text/css" href="<%=basePath %>ExtJS4/resources/css/ext-all.css">
	<script type="text/javascript" src="<%=basePath %>ExtJS4/bootstrap.js"></script>
	<script type="text/javascript" src="<%=basePath %>ExtJS4/locale/ext-lang-zh_TW.js"></script>
	<script type="text/javascript" src="<%=basePath %>js/HelloExtJS4.js"></script>

  </head>
  
  <body>
    測試ExtJS4. <br>
  </body>
</html>
