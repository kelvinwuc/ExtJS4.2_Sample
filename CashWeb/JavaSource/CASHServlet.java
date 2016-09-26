import java.io.IOException;
import javax.servlet.Servlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.*;
import java.sql.*;
import com.aegon.comlib.*;

/**
 * @version 	1.0
 * @author
 */
public class CASHServlet extends HttpServlet implements Servlet {

	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
	    doPost(req, resp);
	}

	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
		String targetPath = "";
		setEncoding(req, resp);
		performTask(req, resp);
	}
	private void setEncoding(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
			if(req.getCharacterEncoding() == null){            
				req.setCharacterEncoding(System.getProperty("file.encoding")); // 通常這是 JSP 或 Servlet 的編碼
			}
	}
	public String checkLogon(HttpServletRequest req, HttpServletResponse resp)
	    throws ServletException, IOException {
			  String path = "";
	    	  //String strThisProgId = "CheckLogon";
			  String strTmpStrLogon = null;
			  SessionInfo siThisSessionInfo = null;
			  UserInfo uiThisUserInfo = null;
			  String strLogonPageForwardURL = new String("Logon/Logon.jsp");		// logon page url
			  String strXMLForwardURL = new String("Logon/ErrorXML.jsp");			// logon page url
			  boolean bIsXml = false;
			  if( req.getContentType() != null && req.getContentType().toLowerCase().indexOf("xml") != -1 )
			  {
				  bIsXml = true;
				  strLogonPageForwardURL = strXMLForwardURL;
			  }
			  HttpSession session = req.getSession(false);
			  if(session == null) {
				path = strLogonPageForwardURL+"?txtMsg=300";
				return path;
			  }
			  //String sessionid = session.getId();
			  //System.out.println("sessionid : "+sessionid);
			  if( session.isNew() )
			  {//若session是新設立,則表示未經Logon程式,不允許執行
				  //req.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=300").forward(req,resp);
				  path = strLogonPageForwardURL+"?txtMsg=300";
			  }
        
			  //自session中將SessionInfo取回,該物件內存有全部全域變數資料(global environmental information)
			  siThisSessionInfo = (SessionInfo)session.getAttribute(Constant.SESSION_INFO);
			  if( siThisSessionInfo == null )
			  {//siThisSessionInfo為null表示未經過登錄程序,轉至Ｌｏｇｏｎ頁面
				  //req.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=301").forward(req,resp);
				  path = strLogonPageForwardURL+"?txtMsg=301";
			  }
			  else
			  {//檢查是否有Ｌｏｇｏｎ過
				  if( req.getParameter("txtDebug") != null )
				  {
					  try
					  {
						  int i;
						  i = Integer.parseInt( req.getParameter("txtDebug") );
						  if( i >= 0 &&  i <= Constant.MAX_DEBUG_LEVEL )
							  siThisSessionInfo.setDebug(i);
						  else
							  siThisSessionInfo.writeDebugLog(Constant.DEBUG_WARNING,"CheckLogon.jsp","The input parameter of txtDebug is invalid txtDebug = '"+req.getParameter("txtDebug")+"',it must between 0 to "+String.valueOf(Constant.MAX_DEBUG_LEVEL));
					  }
					  catch( Exception e )
					  {
						  siThisSessionInfo.setLastError("CheckLogon.jsp","The format of input parameter of txtDebug is invalid txtDebug = '"+req.getParameter("txtDebug")+"'");
					  }
				  }
            
				  if( siThisSessionInfo.getUserInfo() == null )
				  {
				  	  //req.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=302").forward(req,resp);
					  path = strLogonPageForwardURL+"?txtMsg=302";
				  }
				  else
				  {
                       
					  uiThisUserInfo = siThisSessionInfo.getUserInfo();
                        
					  uiThisUserInfo.setDebug(siThisSessionInfo.getDebug());
                        
            
					  if( !uiThisUserInfo.isPasswordChecked() || ((Integer)session.getAttribute("PasswordAging")).intValue() == 1)
					  {
						  //req.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=303").forward(req,resp);
						  path = strLogonPageForwardURL+"?txtMsg=303";
					  }
					  String strThisProgId = req.getParameter("ProgId");
					  if(strThisProgId == null) {
					  	strThisProgId = "";
					  }
					  System.out.println("ProgId 000000000 : "+ strThisProgId);
					  /*if( !uiThisUserInfo.checkPrivilege(strThisProgId) )
					  {//檢查該使用者是否有權執行本程式
						  //req.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=304").forward(req,resp);
						  path = strLogonPageForwardURL+"?txtMsg=304";
					  }*//*
					  else
					  {	//update data source in globalEnviron
						  ServletContext application = getServletContext(); 
						  try
						  {
							  Connection conSqlServer = ((DbFactory)application.getAttribute(Constant.DB_FACTORY)).getConnection("CheckLogon");
							  Statement stmtSystemConfig = conSqlServer.createStatement();
							  ResultSet rstTmp = stmtSystemConfig.executeQuery("select * from DCR..tSystemConfig");
							  if( rstTmp.next() )
							  {
								  GlobalEnviron globalEnviron = (GlobalEnviron)application.getAttribute(Constant.GLOBAL_ENVIRON);
								  globalEnviron.setActiveAS400DataSource(rstTmp.getString("CapsilDataSource").trim());
								  java.util.Date dteTmp = Calendar.getInstance().getTime();
								  synchronized ( getServletContext() )
								  {
									  application.setAttribute(Constant.GLOBAL_ENVIRON, globalEnviron);
									  application.setAttribute(Constant.CAPSIL_DATA_SOURCE_DATE,(java.util.Date)rstTmp.getDate("CapsilDataSourceDate"));
									  if( globalEnviron.getActiveAS400DataSource().equals(Constant.CAPSIL_DATA_SOURCE_AEGON400) )
										  application.setAttribute(Constant.AS400_DATA_DATE,dteTmp);
									  else
										  application.setAttribute(Constant.AS400_DATA_DATE,(java.util.Date)rstTmp.getDate("CapsilDate"));
								  }
							  }
							  rstTmp.close();
							  ((DbFactory)application.getAttribute(Constant.DB_FACTORY)).releaseConnection(conSqlServer);
						  }
						  catch( Exception ex )
						  {
							  ((DbFactory)application.getAttribute(Constant.DB_FACTORY)).setLastError("DbFactory.getAS400Connection()",ex);
						  }
					  }*/
				  }
				  
			  }
			  return path;
	}
	public void performTask(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
	}

}
