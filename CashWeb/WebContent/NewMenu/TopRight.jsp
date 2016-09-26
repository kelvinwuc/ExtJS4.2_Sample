<%@ page import="com.aegon.comlib.*" %>
<%
	String imgUrl = "images/misc/top_02.jpg";

	if(session.getAttribute(Constant.LOGON_USER_TYPE)!=null){
		String userType = (String)session.getAttribute(Constant.LOGON_USER_TYPE);
		if(userType.equalsIgnoreCase("A")){
			imgUrl = "images/misc/top_02.jpg";
		}else if(userType.equalsIgnoreCase("B")){
			imgUrl = "images/misc/AgencyTop.jpg";
		}else if(userType.equalsIgnoreCase("C")){
			imgUrl = "images/misc/BrTop.jpg";
		}else if(userType.equalsIgnoreCase("D")){
			imgUrl = "images/misc/BrTop.jpg";
		}else if(userType.equalsIgnoreCase("E")){
			imgUrl = "images/misc/BdTop.jpg";
		}else if(userType.equalsIgnoreCase("F")){
			imgUrl = "images/misc/BdTop.jpg";
		}else if(userType.equalsIgnoreCase("G")){
			imgUrl = "images/misc/StaffTop.jpg";
		}else if(userType.equalsIgnoreCase("H")){
			imgUrl = "images/misc/StaffTop.jpg";
		}else if(userType.equalsIgnoreCase("I")){
			imgUrl = "images/misc/TigerTop.jpg";
		}else if(userType.equalsIgnoreCase("J")){
			imgUrl = "images/misc/TigerTop.jpg";
		}
	}			
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page 
language="java"
contentType="text/html; charset=BIG5"
pageEncoding="BIG5"
%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft FrontPage 4.0">

</HEAD>
<BODY  background="" style="background-repeat:no-repeat;background-position: center center;margin:0">
<IMG src="<%=imgUrl%>" width="249" height="80">

<P>&nbsp;</P>

</BODY>
</HTML>

