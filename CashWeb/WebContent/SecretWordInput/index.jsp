<%
	String strUrl = request.getParameter("txtUrl");
	if(strUrl==null || strUrl.equals("")){
		strUrl = "SecretWordShow.jsp";
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Policy Inquiry</title>
</head>
<frameset rows="80,*" cols="*" framespacing="0" frameborder="no" border="0">
		<frameset rows="*" cols="150,*,250" framespacing="0" frameborder="no" border="0">
			<frame src="../NewMenu/topLeft.html" name="topLeftFrame" scrolling="NO" noresize > 
			<frame src="../NewMenu/title.html" name="titleFrame" scrolling="NO" noresize >
			<frame src="../NewMenu/TopRight.jsp" name="topRightFrame" scrolling="NO" noresize > 		
		</frameset> 
		<frameset rows="*" cols="120,*" framespacing="0" frameborder="no" border="0">
			<frame src="../NewMenu/menu.html" name="menuFrame" scrolling="auto" noresize >
			<frameset rows="30,*" cols="*" framespacing="0" frameborder="NO" border="0"> 
				<frame src="../NewMenu/toolbar.html" name="toolbarFrame" scrolling="NO" noresize >
				<frame src="<%=strUrl%>" name="contentFrame">
			</frameset>
		</frameset> 
</frameset>

<!--
<frameset rows="*" cols="180,*" framespacing="0" frameborder="no" border="0">
		<frameset rows="86,*" cols="*" framespacing="0" frameborder="no" border="0">
			<frame src="../NewMenu/logo.html" name="logoFrame" scrolling="NO" noresize > 
			<frame src="menu.html" name="menuFrame" scrolling="NO" noresize >
		</frameset> 
		<frameset rows="46,*" cols="*" framespacing="0" frameborder="no" border="0">
			<frame src="../NewMenu/title.html" name="titleFrame" scrolling="NO" noresize >
			<frameset rows="40,*" cols="*" framespacing="0" frameborder="NO" border="0"> 
				<frame src="../NewMenu/toolbar.html" name="toolbarFrame" scrolling="NO" noresize >
				<frame src="<%=strUrl%>" name="contentFrame">
			</frameset>
		</frameset> 
</frameset>
-->

<body>
</body>
</html>
