<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393        Leo Huang    			2010/09/20           現在時間取Capsil營運時間
 *  =============================================================================
 */
%>
<%@ page contentType="text/html;charset=Big5" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.aegon.servlet.*" %>
<%@ page import="org.apache.xml.serialize.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.apache.xerces.parsers.*" %>
<%@ page import="org.xml.sax.*" %>


<%!
//在此定義calss variable

	public String strThisProgId = new String("getServerInformation");		//本程式代號
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
    Calendar cldCalendar = null;
    CommonUtil commonUtil =null;
//R00393  Edit by Leo Huang (EASONTECH) End
	public SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss",java.util.Locale.TAIWAN);
	public DecimalFormat dFormatter = new DecimalFormat("###,###,###");

	class DataClass extends Object 
	{
		//資料庫相關欄位變數(本程式主要欄位)
		String strObjectName = new String("");				//物件名稱
		String strAttributeName = new String("");			//屬性名稱
		

		public SessionInfo siThisSessionInfo = null;				//每一支程式所在的Session information	

		//資料庫連結變數
		public Connection conDb = null;					//jdbc connection
		
		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			
			//R00393  Edit by Leo Huang(EASONTECH) Start
			
			commonUtil = new CommonUtil(siSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());
			cldCalendar = commonUtil.getBizDateByRCalendar();
			//R00393  Edit by Leo Huang(EASONTECH) End
			//將 Date type 的變數設定為初始資料
			
//			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
		}

		//destructor
		public void finalize()
		{
//			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":finalize()","Destructor enter");
			releaseConnection();
		}

		//自 DbFactory 中取得一個 Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("getServerInformation.DataClass.getConnection()");
			if(conDb==null){
				conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("getServerInformation.DataClass.getConnection()");
			}
			if( conDb == null )
				bReturnStatus = false;
/*			if( bReturnStatus )
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getConnection()","getConnection O.K.");
			else
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":getConnection()","siThisSessionInfo.getUserInfo().getDbFactory().getConnection() return null error!!");
*/
			return bReturnStatus;

		}

		public void releaseConnection()
		{
			if( conDb != null )
				siThisSessionInfo.getUserInfo().getDbFactory().releaseConnection(conDb);
			conDb = null;
		}
	}

%>
<%!
//本程式之獨立函數在此定義
/**
函數名稱:	getInputParameter( Document xmlDom , DataCalss objThisData ) 
函數功能:	將Client端傳入之各欄位值存入objThisData中
傳入參數:	Document xmlDom : Client傳入之資料
	DataClass objThisData : 本程式所有的欄位值
傳回值:		若有任一欄位錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean getInputParameter( Document xmlDom ,DataClass objThisData)
{
	boolean bReturnStatus = true;
	String strTmp = new String("");
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//CommonUtil commonUtil = new CommonUtil();
	//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
	//R00393  Edit by Leo Huang (EASONTECH) End


//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
	//取得Client端之資料,存入DataClass中
	objThisData.strObjectName = xmlDom.getElementsByTagName("ObjectName").item(0).getFirstChild().getNodeValue();
	objThisData.strAttributeName = xmlDom.getElementsByTagName("AttributeName").item(0).getFirstChild().getNodeValue();
/*
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status true The object name = '"+objThisData.strObjectName+"' and the attribute name ='"+objThisData.strAttributeName+"'");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status false");
*/	return bReturnStatus;
}


/**
函數名稱:	moveToXML(Document xmlDom,DataClass objThisData)
函數功能:	將Server中之物件轉入xml中
傳入參數:	Document xmlDom			: 傳回之xmlDom
	DataClass objThisData		: 所有前端變數之資料結構
傳 回 值:	strReturn			: 若為空白,則表示成功.否則傳回錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean moveToXML(Document xmlDom,DataClass objThisData)
{
/*
	boolean bReturn = true;
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//CommonUtil commonUtil = new CommonUtil();
	//R00393  Edit by Leo Huang (EASONTECH) End
	org.w3c.dom.Node nodeOneNode = null;
	org.w3c.dom.Node nodeRoot = null;
	org.w3c.dom.Node nodeOneElement = null;
	org.w3c.dom.Text textTmp = null ;
	String strTmp = new String("");
	int i;

//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Enter");
	nodeRoot = xmlDom.getDocumentElement();
	if( objThisData.strObjectName.equalsIgnoreCase("session") )
	{
		Enumeration enuAttributeNames = session.getAttributeNames();
		nodeOneNode = xmlDom.createElement(objThisData.strObjectName);
		while( enuAttributeNames.hasMoreElements() )
		{
			strTmp = (String)enuAttributeNames.nextElement();
			if( !objThisData.strAttributeName.equals("") )
				if( !strTmp.equalsIgnoreCase( objThisData.strAttributeName ) )
					continue;
			nodeOneElement = xmlDom.createElement(strTmp);
			textTmp = xmlDom.createTextNode((session.getAttribute(strTmp)).toString());	
			nodeOneElement.appendChild( (org.w3c.dom.Node) textTmp );
			nodeOneNode.appendChild(nodeOneElement);
		}
		nodeRoot.appendChild(nodeOneNode);
	}
	else if( objThisData.strObjName.equalsIgnoreCase("application") )
	{
		Enumeration enuAttributeNames = application.getAttributeNames();
		nodeOneNode = xmlDom.createElement(objThisData.strObjectName);
		while( enuAttributeNames.hasMoreElements() )
		{
			strTmp = (String)enuAttributeNames.nextElement();
			if( !objThisData.strAttributeName.equals("") )
				if( !strTmp.equalsIgnoreCase( objThisData.strAttributeName ) )
					continue;
			nodeOneElement = xmlDom.createElement(strTmp);
			textTmp = xmlDom.createTextNode((application.getAttribute(strTmp)).toString());	
			nodeOneElement.appendChild( (org.w3c.dom.Node) textTmp );
			nodeOneNode.appendChild(nodeOneElement);
		}
		nodeRoot.appendChild(nodeOneNode);
	}

//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Exit");
	return bReturn;
*/
	return true;	
}


/**
函數名稱:	validDom( DataClass objThisData , Document xmlDom )
函數功能:	將 DOM 中之每一 Element 都加上 Text
傳入參數:	objThisData	: 所有前端變數之資料結構
			xmlDom		: XML資料結構
傳 回 值:	strReturn		: 若為空白,則表示成功.否則傳回錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean validDom( DataClass objThisData , Document xmlDom )
{
	boolean bReturn = true;
     //R00393 Edit by Leo Huang (EASONTECH) Start
	//CommonUtil commonUtil = new CommonUtil();
     //R00393  Edit by Leo Huang (EASONTECH) End
//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":validDom()","Enter");
	try
	{	
		Element elmtRoot = xmlDom.getDocumentElement();
		if( elmtRoot.hasChildNodes() )
		{
			createNodeText( objThisData , (Node)elmtRoot );
		}
		else
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":validDom()","Input dom is empty  ");
			bReturn = false;
		}
	}
	catch(Exception ex)
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":validDom()","Exception : "+ex.getMessage());
		bReturn = false;
	}
//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":validDom()","Exit");
	return bReturn;
}


/**
函數名稱:	createNodeText( DataClass objThisData , Node xmlDom )
函數功能:	將 DOM 中之每一 Element 都加上 Text
傳入參數:	objThisData	: 所有前端變數之資料結構
			xmlDom		: XML資料結構
傳 回 值:	strReturn		: 若為空白,則表示成功.否則傳回錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean createNodeText( DataClass objThisData , Node nodeInput )
{
	boolean bReturn = true;
	String strStep = new String("0");

//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":createNodeText()","Enter");
	if( nodeInput.getChildNodes().getLength() != 0 )
	{
		for(int i=0;i< nodeInput.getChildNodes().getLength();i++)
		{
			Node nodeTmp = nodeInput.getChildNodes().item(i);
			if( nodeTmp.getNodeType() == Node.ELEMENT_NODE )
			{
				if( nodeTmp.getFirstChild() == null )
				{
					org.w3c.dom.Text textTmp = nodeInput.getOwnerDocument().createTextNode("");
					nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
				}
				else
					createNodeText( objThisData , nodeTmp );
			}
		}
	}
//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":createNodeText()","Exit");
	return bReturn;
}




%>
<%	
   
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
	}
        
	//自session中將SessionInfo取回,該物件內存有全部全域變數資料(global environmental information)
	siThisSessionInfo = (SessionInfo)session.getAttribute(Constant.SESSION_INFO);
	if( siThisSessionInfo == null )
	{//siThisSessionInfo為null表示未經過登錄程序,轉至Ｌｏｇｏｎ頁面
		request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=301").forward(request,response);
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
					siThisSessionInfo.writeDebugLog(Constant.DEBUG_WARNING,"CheckLogonCommon.jsp","The input parameter of txtDebug is invalid txtDebug = '"+request.getParameter("txtDebug")+"',it must between 0 to "+String.valueOf(Constant.MAX_DEBUG_LEVEL));
			}
			catch( Exception e )
			{
				siThisSessionInfo.setLastError("CheckLogonCommon.jsp","The format of input parameter of txtDebug is invalid txtDebug = '"+request.getParameter("txtDebug")+"'");
			}
		}
            
		if( siThisSessionInfo.getUserInfo() == null )
		{
			request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=302").forward(request,response);
		}
		else
		{
			uiThisUserInfo = siThisSessionInfo.getUserInfo();
			uiThisUserInfo.setDebug(siThisSessionInfo.getDebug());
		}
	}

	//Server端程式由此正式開始
	//本程式主要之變數
	String strClientMsg = new String("");				//傳回給Client之訊息
	boolean bReturnStatus = true;						//各函數執行之結果

   //R00393 edit by Leo Huang start
	//java.util.Date dteToday = cldCalendar.getTime();		//目前日期時間
	 //R00393 edit by Leo Huang start
 
	DataClass objThisData = new DataClass(siThisSessionInfo);	//本程式主要各欄位資料

//	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
 
	//將前端傳來之資料轉為 Document 物件
	Document xmlDom = null;
	org.apache.xerces.parsers.DOMParser parser = new org.apache.xerces.parsers.DOMParser();

	try
	{	
		org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource( new InputStreamReader(request.getInputStream(),"UTF-8") );
		parser.parse( inputSource );
	}
	catch( Exception ex )
	{
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":service()","parser Exception : "+ex.getMessage());
	}


	xmlDom = parser.getDocument();

	validDom( objThisData , xmlDom );
	
%>
<%
	if( !getInputParameter( xmlDom , objThisData) )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
%>
<%  
	int i = 0;
	boolean bHasData = false;
	Statement stmMainStatement = null;
	ResultSet rstMainResultSet = null;

	//If there is no error, process the report, otherwise send the error message to client.
	if( strClientMsg.equals("") )
	{
		if( objThisData.strObjectName.equals("") )
		{
			strClientMsg = new String("Empty ObjectName ");
		}
		
		if( strClientMsg.equals("") )
		{
			org.w3c.dom.Node nodeOneNode = null;
			org.w3c.dom.Node nodeRoot = null;
			org.w3c.dom.Node nodeOneElement = null;
			org.w3c.dom.Text textTmp = null ;
			String strTmp = new String("");
		
			nodeRoot = xmlDom.getDocumentElement();
			if( objThisData.strObjectName.equalsIgnoreCase("session") )
			{
				Enumeration enuAttributeNames = session.getAttributeNames();
				nodeOneNode = xmlDom.createElement(objThisData.strObjectName);
				while( enuAttributeNames.hasMoreElements() )
				{
					strTmp = (String)enuAttributeNames.nextElement();
					if( !objThisData.strAttributeName.equals("") )
						if( !strTmp.equalsIgnoreCase( objThisData.strAttributeName ) )
							continue;
					nodeOneElement = xmlDom.createElement(strTmp);
					textTmp = xmlDom.createTextNode((session.getAttribute(strTmp)).toString());	
					nodeOneElement.appendChild( (org.w3c.dom.Node) textTmp );
					nodeOneNode.appendChild(nodeOneElement);
				}
				nodeRoot.appendChild(nodeOneNode);
			}
			else if( objThisData.strObjectName.equalsIgnoreCase("application") )
			{
				Enumeration enuAttributeNames = application.getAttributeNames();
				nodeOneNode = xmlDom.createElement(objThisData.strObjectName);
				while( enuAttributeNames.hasMoreElements() )
				{
					strTmp = (String)enuAttributeNames.nextElement();
					if( !objThisData.strAttributeName.equals("") )
						if( !strTmp.equalsIgnoreCase( objThisData.strAttributeName ) )
							continue;
					nodeOneElement = xmlDom.createElement(strTmp);
					textTmp = xmlDom.createTextNode((application.getAttribute(strTmp)).toString());	
					nodeOneElement.appendChild( (org.w3c.dom.Node) textTmp );
					nodeOneNode.appendChild(nodeOneElement);
				}
				nodeRoot.appendChild(nodeOneNode);
			}
			else if( objThisData.strObjectName.equalsIgnoreCase("UserInfo") )
			{
				nodeOneNode = xmlDom.createElement(objThisData.strObjectName);
				for(i=0;i<uiThisUserInfo.getSizeOfUserFuncTree();i++ )
				{
					if( !objThisData.strAttributeName.equals("") )
						if( !uiThisUserInfo.getFunctionIdDown(i).equalsIgnoreCase( objThisData.strAttributeName ) )
							continue;
					nodeOneElement = xmlDom.createElement(uiThisUserInfo.getFunctionIdDown(i));
					textTmp = xmlDom.createTextNode(uiThisUserInfo.getSubFunction(uiThisUserInfo.getFunctionIdDown(i)));	
					nodeOneElement.appendChild( (org.w3c.dom.Node) textTmp );
					nodeOneNode.appendChild(nodeOneElement);
				}
				nodeRoot.appendChild(nodeOneNode);
			}
		}
	}

	org.w3c.dom.Node nodeTmp = null ;
	org.w3c.dom.Text textTmp = null ;
	if( xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild() == null)
	{
		nodeTmp = xmlDom.getElementsByTagName("txtMsg").item(0);
		textTmp = xmlDom.createTextNode("");
		nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
	}
	xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild().setNodeValue( strClientMsg );
	
//	XMLSerializer ser = new XMLSerializer( response.getOutputStream() , new OutputFormat() );
	XMLSerializer ser = new XMLSerializer( out , new OutputFormat("xml","BIG5",true) );
	ser.serialize( xmlDom );
//	response.getOutputStream().close();

//	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side exit");
%>
