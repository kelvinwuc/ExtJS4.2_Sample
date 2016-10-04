<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%	
	//String strThisProgId = "CheckLogon";
	String strTmpStrLogon = null;
	SessionInfo siThisSessionInfo = null;
	UserInfo uiThisUserInfo = null;
	String strLogonPageForwardURL = new String("../../Logon/Logon.jsp");		// logon page url
	String strXMLForwardURL = new String("../../Logon/ErrorXML.jsp");			// logon page url
	boolean bIsXml = false;
	if( request.getContentType() != null && request.getContentType().toLowerCase().indexOf("xml") != -1 )
	{
		bIsXml = true;
		strLogonPageForwardURL = strXMLForwardURL;
	}
        
	if( session.isNew() )
	{//�Ysession�O�s�]��,�h���ܥ��gLogon�{��,�����\����
		request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=300").forward(request,response);
		return;
	}
        
	//��session���NSessionInfo���^,�Ӫ��󤺦s�����������ܼƸ��(global environmental information)
	siThisSessionInfo = (SessionInfo)session.getAttribute(Constant.SESSION_INFO);
	if( siThisSessionInfo == null )
	{//siThisSessionInfo��null���ܥ��g�L�n���{��,��ܢڢ����������
		request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=301").forward(request,response);
		return;
	}
	else
	{//�ˬd�O�_���ڢ�������L
        
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
            {//�ˬd�ӨϥΪ̬O�_���v���楻�{��
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