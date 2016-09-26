<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393        Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
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
//�b���w�qcalss variable

	public String strThisProgId = new String("getServerInformation");		//���{���N��
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
    Calendar cldCalendar = null;
    CommonUtil commonUtil =null;
//R00393  Edit by Leo Huang (EASONTECH) End
	public SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss",java.util.Locale.TAIWAN);
	public DecimalFormat dFormatter = new DecimalFormat("###,###,###");

	class DataClass extends Object 
	{
		//��Ʈw��������ܼ�(���{���D�n���)
		String strObjectName = new String("");				//����W��
		String strAttributeName = new String("");			//�ݩʦW��
		

		public SessionInfo siThisSessionInfo = null;				//�C�@��{���Ҧb��Session information	

		//��Ʈw�s���ܼ�
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
			//�N Date type ���ܼƳ]�w����l���
			
//			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
		}

		//destructor
		public void finalize()
		{
//			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":finalize()","Destructor enter");
			releaseConnection();
		}

		//�� DbFactory �����o�@�� Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
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
//���{�����W�ߨ�Ʀb���w�q
/**
��ƦW��:	getInputParameter( Document xmlDom , DataCalss objThisData ) 
��ƥ\��:	�NClient�ݶǤJ���U���Ȧs�JobjThisData��
�ǤJ�Ѽ�:	Document xmlDom : Client�ǤJ�����
	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:		�Y�����@�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
	//���oClient�ݤ����,�s�JDataClass��
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
��ƦW��:	moveToXML(Document xmlDom,DataClass objThisData)
��ƥ\��:	�NServer����������Jxml��
�ǤJ�Ѽ�:	Document xmlDom			: �Ǧ^��xmlDom
	DataClass objThisData		: �Ҧ��e���ܼƤ���Ƶ��c
�� �^ ��:	strReturn			: �Y���ť�,�h��ܦ��\.�_�h�Ǧ^���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	validDom( DataClass objThisData , Document xmlDom )
��ƥ\��:	�N DOM �����C�@ Element ���[�W Text
�ǤJ�Ѽ�:	objThisData	: �Ҧ��e���ܼƤ���Ƶ��c
			xmlDom		: XML��Ƶ��c
�� �^ ��:	strReturn		: �Y���ť�,�h��ܦ��\.�_�h�Ǧ^���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	createNodeText( DataClass objThisData , Node xmlDom )
��ƥ\��:	�N DOM �����C�@ Element ���[�W Text
�ǤJ�Ѽ�:	objThisData	: �Ҧ��e���ܼƤ���Ƶ��c
			xmlDom		: XML��Ƶ��c
�� �^ ��:	strReturn		: �Y���ť�,�h��ܦ��\.�_�h�Ǧ^���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
	{//�Ysession�O�s�]��,�h��ܥ��gLogon�{��,�����\����
		request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=300").forward(request,response);
	}
        
	//��session���NSessionInfo���^,�Ӫ��󤺦s�����������ܼƸ��(global environmental information)
	siThisSessionInfo = (SessionInfo)session.getAttribute(Constant.SESSION_INFO);
	if( siThisSessionInfo == null )
	{//siThisSessionInfo��null��ܥ��g�L�n���{��,��ܢڢ����������
		request.getRequestDispatcher(strLogonPageForwardURL+"?txtMsg=301").forward(request,response);
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

	//Server�ݵ{���Ѧ������}�l
	//���{���D�n���ܼ�
	String strClientMsg = new String("");				//�Ǧ^��Client���T��
	boolean bReturnStatus = true;						//�U��ư��椧���G

   //R00393 edit by Leo Huang start
	//java.util.Date dteToday = cldCalendar.getTime();		//�ثe����ɶ�
	 //R00393 edit by Leo Huang start
 
	DataClass objThisData = new DataClass(siThisSessionInfo);	//���{���D�n�U�����

//	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
 
	//�N�e�ݶǨӤ�����ର Document ����
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
