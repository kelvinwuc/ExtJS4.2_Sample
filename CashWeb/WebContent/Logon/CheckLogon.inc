<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%	
	//String strThisProgId = "CheckLogon";
	String strTmpStrLogon = null;
	SessionInfo siThisSessionInfo = null;
	UserInfo uiThisUserInfo = null;
	String strLogonPageForwardURL = new String("../Logon/Logon.jsp");		// logon page url
	String strXMLForwardURL = new String("../Logon/ErrorXML.jsp");			// logon page url
	boolean bIsXml = false;
	if( request.getContentType() != null && request.getContentType().toLowerCase().indexOf("xml") != -1 )
	{
		bIsXml = true;
		strLogonPageForwardURL = strXMLForwardURL;
	}
        
	if( session.isNew() )
	{//若session是新設立,則表示未經Logon程式,不允許執行
		request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=300").forward(request,response);
		return;
	}
        
	//自session中將SessionInfo取回,該物件內存有全部全域變數資料(global environmental information)
	siThisSessionInfo = (SessionInfo)session.getAttribute(Constant.SESSION_INFO);
	if( siThisSessionInfo == null )
	{//siThisSessionInfo為null表示未經過登錄程序,轉至Ｌｏｇｏｎ頁面
		request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=301").forward(request,response);
		return;
	}
	else
	{//檢查是否有Ｌｏｇｏｎ過
        
		if( request.getParameter("txtDebug") != null )
		{
			try
			{
				int i;
				i = Integer.parseInt( request.getParameter("txtDebug") );
				if( i >= 0 &&  i <= Constant.MAX_DEBUG_LEVEL )
					siThisSessionInfo.setDebug(i);
				else
					siThisSessionInfo.writeDebugLog(Constant.DEBUG_WARNING,"CheckLogon.jsp","The input parameter of txtDebug is invalid txtDebug = '"+request.getParameter("txtDebug")+"',it must between 0 to "+String.valueOf(Constant.MAX_DEBUG_LEVEL));
			}
			catch( Exception e )
			{
				siThisSessionInfo.setLastError("CheckLogon.jsp","The format of input parameter of txtDebug is invalid txtDebug = '"+request.getParameter("txtDebug")+"'");
			}
		}
            
		if( siThisSessionInfo.getUserInfo() == null )
		{
			request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=302").forward(request,response);
			return;
		}
		else
		{
                       
			uiThisUserInfo = siThisSessionInfo.getUserInfo();
                        
			uiThisUserInfo.setDebug(siThisSessionInfo.getDebug());
                        
            
			if( !uiThisUserInfo.isPasswordChecked() || ((Integer)session.getAttribute("PasswordAging")).intValue() == 1)
			{
				request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=303").forward(request,response);
				return;
			}
                      
			if( !uiThisUserInfo.checkPrivilege(strThisProgId) )
            {//檢查該使用者是否有權執行本程式
				request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=304").forward(request,response);
				return;
			}
			else
			{	
				//update data source in globalEnviron 

			}
		}
        
	}
%>