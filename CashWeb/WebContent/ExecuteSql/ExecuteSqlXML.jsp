<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *  R00393       Leo Huang    			2010/09/20           現在時間取Capsil營運時間
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
//在此定義calss variable

	public String strThisProgId = new String("ExecuteSqlXML");		//本程式代號
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
		//資料庫相關欄位變數(本程式主要欄位)
		int iLineCnt = 0;								//How many lines had been output in this page, including subtotal line.
		public String strSql = new String("");				//Input sql string
		public String strConnectionType = "";				//connection type about this sql statement
		

		public SessionInfo siThisSessionInfo = null;				//每一支程式所在的Session information	

		//資料庫連結變數
		public Connection conDb = null;					//db_basic之jdbc connection
		
		//constructor
		public DataClass()
		{
			super();
			//將 Date type 的變數設定為初始資料
			
//			globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:DataClass()","Constructor normal exit");
		}

		//destructor
		public void finalize()
		{
//			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:finalize()","Destructor enter");
			releaseConnection();
		}

		//自 DbFactory 中取得一個 Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
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
//R00393   Edit by Leo Huang (EASONTECH) Start
	//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End

//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:getInputParameter()","Enter");
	//取得Client端之資料,存入DataClass中
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
函數名稱:	moveToXML(Document xmlDom,ResultSet rstResultSet,DataClass objThisData,int iRowProcessed)
函數功能:	將ResultSet中之值轉入xml中
傳入參數:	Document xmlDom			: 傳回之xmlDom
		ResultSet rstResultSet		: 資料庫中之資料集
		DataClass objThisData		: 所有前端變數之資料結構
		int iRowProcessed		: 已有多少筆資料處理過
傳 回 值:	strReturn		: 若為空白,則表示成功.否則傳回錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
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
	//Server端程式由此正式開始
	//本程式主要之變數
	String strClientMsg = new String("");				//傳回給Client之訊息
	boolean bReturnStatus = true;						//各函數執行之結果
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
	//java.util.Date dteToday = cldCalendar.getTime();		//目前日期時間
    //R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass();	//本程式主要各欄位資料

	globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG,"ExecuteSqlXML.jsp:service()","Server side Enter");
	

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
		globalEnviron.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":service()","parser Exception : "+ex.getMessage());
	}


	xmlDom = parser.getDocument();

	validDom( objThisData , xmlDom );
	
%>
<%
	//先取得資料庫連線
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
	//將共處理幾筆數字傳回
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
