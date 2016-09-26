<%
  if(request.getCharacterEncoding() == null){            
  	request.setCharacterEncoding(System.getProperty("file.encoding")); // 通常這是 JSP 或 Servlet 的編碼
  } 
%>
