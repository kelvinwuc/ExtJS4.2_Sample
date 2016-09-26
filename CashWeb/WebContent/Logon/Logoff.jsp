<%@ page import="com.aegon.comlib.*" %>
<%
String userType = null;
String logonPage = null;
String callerUrl = null;

if (session.getAttribute(Constant.ACTIVE_USER_TYPE) != null) {
	userType = (String) session.getAttribute(Constant.LOGON_USER_TYPE);
} else {
	if(session.getAttribute(Constant.LOGON_USER_TYPE)!= null){
		userType = (String) session.getAttribute(Constant.LOGON_USER_TYPE);
	}else{
		userType = "no";
	}
}

callerUrl = request.getParameter("txtCallerUrl");

System.out.println("userType is '" + userType + "'");
System.out.println("txtCallerUrl='" + callerUrl + "'");

if (userType.equalsIgnoreCase("A")) {
	logonPage = "/Logon/Logon.jsp";
} else if (userType.equalsIgnoreCase("B")) {
	logonPage = "/Logon/AgencyLogon.jsp";
} else if (userType.equalsIgnoreCase("C")) {
	logonPage = "/Logon/BrLogon.jsp";
} else if (userType.equalsIgnoreCase("D")) {
	logonPage = "/Logon/BrLogon.jsp";
} else if (userType.equalsIgnoreCase("E")) {
	logonPage = "/Logon/BdLogon.jsp";
} else if (userType.equalsIgnoreCase("F")) {
	logonPage = "/Logon/BdLogon.jsp";
} else if (userType.equalsIgnoreCase("G")) {
	logonPage = "/Logon/AgencyLogon.jsp";
} else if (userType.equalsIgnoreCase("H")) {
	logonPage = "/Logon/StaffLogon.jsp";
} else if (userType.equalsIgnoreCase("I")) {
	logonPage = "/Logon/TigerLogon.jsp";
} else if (userType.equalsIgnoreCase("J")) {
	logonPage = "/Logon/TigerLogon.jsp";
} else if (userType.equalsIgnoreCase("K")) {
	logonPage = "/Logon/BrLogon.jsp";
} else {
	logonPage = "/Logon/Logon.jsp";
}

RequestDispatcher dispatcher = request.getRequestDispatcher(logonPage);
dispatcher.forward(request, response);
%>
