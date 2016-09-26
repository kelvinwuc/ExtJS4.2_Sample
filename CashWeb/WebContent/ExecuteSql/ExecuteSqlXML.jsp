<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *  R00393       Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
 *  =============================================================================
 */
%>
<%@ page contentType="text/html;charset=Big5" %>
<%@ include file="../Logon/Init1.jsp" %>
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

	public String strThisProgId = new String("ExecuteSqlXML");		//���{���N��
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//public Calendar cldCalendar = Calendar.getInstance(TimeZone.getDefault(),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
	
	public SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss",java.util.Locale.TAIWAN);
	public DecimalFormat dFormatter = new DecimalFormat("###,###,###");
	public final String strRowTagNamePreFix = new String("ExecuteSqlXMLRow");
	
	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;

	class DataClass extends RootClass 
	{
		//��Ʈw��������ܼ�(���{���D�n���)
		int iLineCnt = 0;								//How many lines had been output in this page, including subtotal line.
		public String strSql = new String("");				//Input sql string
		public String strConnectionType = "";				//connection type about this sql statement
		

		public SessionInfo siThisSessionInfo = null;				//�C�@��{���Ҧb��Session information	

		//��Ʈw�s���ܼ�
		public Connection conDb = null;					//db_basic��jdbc connection
		
		//constructor
		public DataClass()
		{
			super();
			//�N Date type ���ܼƳ]�w����l���
			
//			globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:DataClass()","Constructor normal exit");
		}

		//destructor
		public void finalize()
		{
//			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:finalize()","Destructor enter");
			releaseConnection();
		}

		//�� DbFactory �����o�@�� Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
			conDb = dbFactory.getConnection("ExecuteSqlXML.DataClass.getConnection()");
			if(conDb==null){
				conDb = dbFactory.getConnection("ExecuteSqlXML.DataClass.getConnection()");
			}
			if( conDb == null )
				bReturnStatus = false;

			return bReturnStatus;

		}

		public void releaseConnection()
		{
			if( conDb != null ){
				dbFactory.releaseConnection(conDb);
			}
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
//R00393   Edit by Leo Huang (EASONTECH) Start
	//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End

//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:getInputParameter()","Enter");
	//���oClient�ݤ����,�s�JDataClass��
	objThisData.strSql = xmlDom.getElementsByTagName("txtSql").item(0).getFirstChild().getNodeValue();
	if( objThisData.strSql == null )
		objThisData.strSql = "";	
		
	objThisData.strConnectionType = xmlDom.getElementsByTagName("txtConnectionType").item(0).getFirstChild().getNodeValue();
	if( objThisData.strConnectionType == null )
		objThisData.strConnectionType = "S" ;
/*
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:getInputParameter()","Exit with status true The sql = '"+objThisData.strSql+"'");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:getInputParameter()","Exit with status false");
*/		
	return bReturnStatus;
}


/**
��ƦW��:	moveToXML(Document xmlDom,ResultSet rstResultSet,DataClass objThisData,int iRowProcessed)
��ƥ\��:	�NResultSet��������Jxml��
�ǤJ�Ѽ�:	Document xmlDom			: �Ǧ^��xmlDom
		ResultSet rstResultSet		: ��Ʈw������ƶ�
		DataClass objThisData		: �Ҧ��e���ܼƤ���Ƶ��c
		int iRowProcessed		: �w���h�ֵ���ƳB�z�L
�� �^ ��:	strReturn		: �Y���ť�,�h��ܦ��\.�_�h�Ǧ^���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean moveToXML(Document xmlDom,ResultSet rstResultSet,DataClass objThisData,int iRowProcessed)
{
	boolean bReturn = true;

	org.w3c.dom.Node nodeOneNode = null;
	org.w3c.dom.Node nodeRoot = null;
	org.w3c.dom.Node nodeOneRow = null;
	org.w3c.dom.Text textTmp = null ;
	String strTmp = new String("");
	ResultSetMetaData mdMetaData = null;
	int iColumnCount = 0;
	int i;

//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Enter");
	try
	{
		mdMetaData = rstResultSet.getMetaData();
		iColumnCount = mdMetaData.getColumnCount();
		nodeRoot = xmlDom.getDocumentElement();
		nodeOneRow = xmlDom.createElement(strRowTagNamePreFix+String.valueOf(iRowProcessed));
		textTmp = xmlDom.createTextNode("");	
		nodeOneRow.appendChild( (org.w3c.dom.Node) textTmp );
		nodeRoot.appendChild(nodeOneRow);
	

		for(i=1;i<=iColumnCount;i++)
		{
			nodeOneNode = xmlDom.createElement(mdMetaData.getColumnName(i));
			switch( mdMetaData.getColumnType(i) )
			{
				case java.sql.Types.DATE:
				case 93:						//DateTime
					if( rstResultSet.getDate(i) != null )
						strTmp = sdfDateFormatter.format(rstResultSet.getDate(i));
					else
						strTmp = new String("");
					break;
				default :
					if( rstResultSet.getObject(i) == null )
						strTmp = new String("");
					else
						strTmp = rstResultSet.getObject(i).toString();
					break;
			}
			textTmp = xmlDom.createTextNode(strTmp);	
			nodeOneNode.appendChild( (org.w3c.dom.Node) textTmp );
			nodeOneRow.appendChild( nodeOneNode );
		}
	}
	catch(Exception e)
	{
		objThisData.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":moveToXML()","Exception : "+e.getMessage());
		bReturn = false;
	}

//	objThisData.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Exit");
	return bReturn;
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

//	objThisData.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":validDom()","Enter");
	try
	{	
		Element elmtRoot = xmlDom.getDocumentElement();
		if( elmtRoot.hasChildNodes() )
		{
			createNodeText( objThisData , (Node)elmtRoot );
		}
		else
		{
			objThisData.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":validDom()","Input dom is empty  ");
			bReturn = false;
		}
	}
	catch(Exception ex)
	{
		objThisData.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":validDom()","Exception : "+ex.getMessage());
		bReturn = false;
	}
//	objThisData.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":validDom()","Exit");
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

//	objThisData.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":createNodeText()","Enter");
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
//	objThisData.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":createNodeText()","Exit");
	return bReturn;
}




%>
<%	
//	System.out.println("1");
	//Server�ݵ{���Ѧ������}�l
	//���{���D�n���ܼ�
	String strClientMsg = new String("");				//�Ǧ^��Client���T��
	boolean bReturnStatus = true;						//�U��ư��椧���G
//	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
	/*
		92/12/04 Added by Disen: add global object reference !
	*/
	if(globalEnviron == null){
		globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
	}
	if(dbFactory == null){
		dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
	}
	if(commonUtil == null){
		commonUtil = new CommonUtil(globalEnviron);
	}

	/*
		91/08/01 Added by Andy : change for WAS 3.5.6 connection can't be used cross thread
	*/
	Connection conNewConnection = null;
	//R00393   Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();		//�ثe����ɶ�
    //R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass();	//���{���D�n�U�����

	globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:service()","Server side Enter");
	

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
		globalEnviron.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":service()","parser Exception : "+ex.getMessage());
	}


	xmlDom = parser.getDocument();

	validDom( objThisData , xmlDom );
	
%>
<%
	//�����o��Ʈw�s�u
	/*	91/08/01 remarked by Andy : change for WAS 3.5.6 connection can't be used cross thread
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	*/
	if( !getInputParameter( xmlDom , objThisData) )
	{
		strClientMsg = globalEnviron.getLastErrorMessage();
	}
	
	// get connection 
	try
	{
		if(objThisData.strConnectionType.equals("4")){
			conNewConnection = dbFactory.getAS400Connection("ExecuteSqlXML.service()");
		}else{
			conNewConnection = dbFactory.getConnection("ExecuteSqlXML.service()");
		}
	}
	catch( Exception exc)
	{
		strClientMsg = exc.getMessage();
	}


%>
<%  
	int i = 0;
	boolean bHasData = false;
	Statement stmMainStatement = null;
	ResultSet rstMainResultSet = null;
	int iRowProcessed = 1;

	//If there is no error, process the report, otherwise send the error message to client.
	if( strClientMsg.equals("") )
	{
		if( !objThisData.strSql.equals("") )
		{
			try
			{
				/* 91/08/01 remarked by Andy : change for WAS 3.5.6 connection can't be used cross thread
				stmMainStatement = objThisData.conDb.createStatement();
				*/
				stmMainStatement = conNewConnection.createStatement();
				rstMainResultSet = stmMainStatement.executeQuery(objThisData.strSql); 
			}
			catch( Exception e )
			{
				//siThisSessionInfo.setLastError(strThisProgId+":execute sql",e);
				//strClientMsg = siThisSessionInfo.getLastErrorMessage();
				strClientMsg = strThisProgId+":execute sql:"+e.getMessage();
			}
		}
		else
		{
			strClientMsg = new String("Empty sql ");
		}
		
		if( strClientMsg.equals("") )
		{
			while( rstMainResultSet.next() )
			{
				moveToXML(xmlDom,rstMainResultSet,objThisData,iRowProcessed);
				iRowProcessed++;
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
	//�N�@�B�z�X���Ʀr�Ǧ^
	org.w3c.dom.Node nodeRoot = xmlDom.getDocumentElement();
	nodeTmp = xmlDom.createElement("txtRowCount");
	textTmp = xmlDom.createTextNode(String.valueOf(iRowProcessed-1));	
	nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
	nodeRoot.appendChild(nodeTmp);

	
	XMLSerializer ser = new XMLSerializer( out , new OutputFormat("xml","BIG5",true) );
	ser.serialize( xmlDom );

	//release the connection before exit
//	objThisData.releaseConnection();
	if(objThisData.strConnectionType.equals("4")){
		dbFactory.releaseAS400Connection(conNewConnection);
	}else{
		dbFactory.releaseConnection(conNewConnection);
	}
//	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:service()","Server side exit");
%>
