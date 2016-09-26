<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393       Leo Huang    			2010/09/20           現在時間取Capsil營運時間
 *  =============================================================================
 */
%>
<%@ page contentType="text/html;charset=Big5" %>
<%@ include file="../Logon/Init.inc" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.microsoft.*" %>
<%@ page import="com.aegon.servlet.*" %>
<%@ page import="org.apache.xml.serialize.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.apache.xerces.parsers.*" %>
<%@ page import="org.xml.sax.*" %>
<%!
//在此定義calss variable

	String strThisProgId = new String("FunctionGroup");		//本程式代號
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	GlobalEnviron globalEnviron = null ;
	class DataClass extends Object 
	{
		//資料庫相關欄位變數(本程式主要欄位)
		public String strGroup_id = new String("");				//功能群組代號
		//public String strFunc_id = new String("");				//程式功能代號
		//public String strFunctionIdDown = new String("");			//下層功能代號
		//public java.util.Date dteCreateDate = cldCalendar.getTime();		//設定日期
		public Vector	vctItem = new Vector(10,10);				//全部明細資料

		public SessionInfo siThisSessionInfo = null;				//每一支程式所在的Session information	
		public String strAction = new String("");				//Client端之功能要求:'A':新增,'U':修改,'D':刪除,'I':查詢

		//資料庫連結變數
		public Connection conDb = null;										//AegonWeb之jdbc connection

		//連結資料庫SQL
		public String strBasicSql = new String("select * from GRPFUN ");
		public String strSelectWhere = new String("where GRPID = ?");
		public String strEmptyWhere = new String("where 1 <> 1");
		
		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			//將 Date type 的變數設定為初始資料
			//dteCreateDate.setTime(0);
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
		}

		//自 DbFactory 中取得一個 Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("FunctionGroupS.DataClass.getConnection()");
			if( conDb == null )
				bReturnStatus = false;
			if( bReturnStatus )
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getConnection()","getConnection O.K.");
			else
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":getConnection()","siThisSessionInfo.getUserInfo().getDbFactory().getConnection() return null error!!");

			return bReturnStatus;
		}

		public boolean releaseConnection(){
			boolean bReturnStatus = true ;
			if(conDb!=null){
				siThisSessionInfo.getUserInfo().getDbFactory().releaseConnection(conDb);
			}
			return bReturnStatus ;
		}

		//取得本程式的 Inquiry SQL
		public String getInquirySql()
		{	
			String strReturn = new  String("");
			
			//strReturn = "select * from GRPFUN where GRPID = '"+strGroup_id+"'";
			strReturn = "select * from FGROUP where GRPID = '"+strGroup_id+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}
	}

%>
<%!
//本程式之獨立函數在此定義
/**
函數名稱:	checkFieldsServer( DataClass objThisData )
函數功能:	檢查所有的欄位,若有任一欄位錯誤,則傳回false,否則傳回true
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有任一欄位錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean checkFieldsServer( DataClass objThisData )
{
	boolean bReturnStatus = true;
	
	/*
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Enter");
	if( objThisData.strUserId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","使用者代號不可空白");
		bReturnStatus = false;
	}

	if( !objThisData.strPassword.equals(objThisData.strPasswordConfirm) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","使用者密碼必須要與確認密碼相同");
		bReturnStatus = false;
	}

	if( bReturnStatus )	
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status false");
	*/

	return bReturnStatus;
}
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
	CommonUtil commonUtil = new CommonUtil();
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
	//R00393  Edit by Leo Huang (EASONTECH) End
	int i;
	try
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
		//取得Client端之資料,存入DataClass中

		objThisData.strAction = xmlDom.getElementsByTagName("txtAction").item(0).getFirstChild().getNodeValue();
		if( objThisData.strAction == null )
			objThisData.strAction = "";	

		objThisData.strGroup_id = xmlDom.getElementsByTagName("GRPID").item(0).getFirstChild().getNodeValue();
		if( objThisData.strGroup_id == null )
			objThisData.strGroup_id = "";	
		//所有的明細資料存於 vctItem 中
		if( xmlDom.getElementsByTagName("FUNID").getLength() != 0 )
		{	//將每一個Row放入一個Vector中
			Vector vctOneRow = new Vector(2,1);
			for(i=0;i<xmlDom.getElementsByTagName("FUNID").getLength();i++)
			{
				vctOneRow.add(xmlDom.getElementsByTagName("FUNID").item(i).getFirstChild().getNodeValue());
				//objThisData.vctItem.add(vctOneRow);
			}
			objThisData.vctItem=vctOneRow;	//將整筆名細資料存於objThisData.vctItem中

			// DUMP VECTOR (****do not delete******)
			//Enumeration enu = vctOneRow.elements() ;
			//while(enu.hasMoreElements() ){
			//	System.out.println("Vctor:"+(String)enu.nextElement());
			//}
		}
	}
	catch( Exception e )
	{
		bReturnStatus = false;
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status true");
	else	
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status false");
	return bReturnStatus;
}

/**
函數名稱:	insertDetail( DataClass objThisData )
函數功能:	將記憶體中之資料搬到資料庫中,並新增資料集之資料,新增CallCenter..tauditdata_detail
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean insertDetail( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmtStatement = null;			
	ResultSet rstResultSet = null;
	String strSql = new String("");
	String strInsertSql = new String("");
	String StrSeqNo = new String("");
	int iRowInserted = 0;
	int i = 0;
	SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy/MM/dd",java.util.Locale.TAIWAN);
	try
	{	//insert資料至tgroup_function
		String strDetailSql = "insert into GRPFUN (GRPID,SEQ,FUNID,SUBFUN) values ";

		stmtStatement = objThisData.conDb.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDetail()","The sizeof vctItem is '"+String.valueOf(objThisData.vctItem.size())+"'");

		//System.out.println("DEBUG VctItem:"+(String)objThisData.vctItem.elementAt(0)); 

		for(i=0;i<objThisData.vctItem.size();i++)
		{
			if (i+1<10)
			{
				StrSeqNo="0"+String.valueOf(i+1);
			}
			else
			{
				StrSeqNo=String.valueOf(i+1);
			}
			strSql = strDetailSql + " ('"+objThisData.strGroup_id+"'";
			//strSql += ",'"+String.valueOf(i+1)+"'";
			strSql += ",'"+StrSeqNo+"'";
			strSql += ",'"+(String)objThisData.vctItem.elementAt(i)+"'";
			strSql += ",'')";
			//objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDetail()","The "+String.valueOf(i+1)+"-th insert Sql = '"+strSql+"'");
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDetail()","The "+StrSeqNo+"-th insert Sql = '"+strSql+"'");
			iRowInserted = stmtStatement.executeUpdate(strSql);
			if( iRowInserted != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDetail()","Statement.executeUpdate() return not equals 1");
				bReturnStatus = false;
				break;
			}
		}
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDetail()",e);
		bReturnStatus = false;
	}
	return bReturnStatus;
}


/**
函數名稱:	updateDb( DataClass objThisData )
函數功能:	更新該筆資料
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean updateDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	boolean bAutoCommit	= true;
	boolean isAEGON400 = false;
	if(globalEnviron.getActiveAS400DataSource().equals(Constant.AS400_DATA_SOURCE_NAME_AEGON400)){
		isAEGON400 = true ;
	}
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Enter");
	//先檢查該筆資料是否存在於資料庫中,若不存在,則傳回錯誤訊息,否則進行資料庫更新
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","該筆資料未存於資料庫中,請檢查");
		bReturnStatus = false;
	}
	else
	{
		try
		{	//先將connection之autoCommit狀態存於bAutoCommit中,以待將來之恢復
			bAutoCommit = objThisData.conDb.getAutoCommit();
			if(isAEGON400){
				objThisData.conDb.setAutoCommit(false);	//因為要執行多個指令,所以將AutoCommit設定為false,commit由程式控制
			}
			//先將detail資料集刪除
			if( !deleteDetail( objThisData ) )		
			{		//不成功就rollback
				if(isAEGON400){
					objThisData.conDb.rollback();
				}
				bReturnStatus = false;
			}
			else
			{
				if( !insertDetail( objThisData ) )
				{
					if(isAEGON400){
						objThisData.conDb.rollback();
					}
					bReturnStatus = false;
				}
				else
				{	
					//全部都成功後才commit
					if(isAEGON400){
						objThisData.conDb.commit();
					}
				}
			}	
			objThisData.conDb.setAutoCommit(bAutoCommit);	//將autoCommit還原
		}
		catch( Exception e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","set auto commit error");
			try
			{
				objThisData.conDb.setAutoCommit(bAutoCommit);
			}
			catch( Exception ex )
			{
			}
			bReturnStatus = false;
		}
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Exit with status false");
	return bReturnStatus;
}


/**
函數名稱:	deleteDetail( DataClass objThisData )
函數功能:	將資料集中之detail資料全部刪除,刪除CallCenter..tauditdata_detail中之資料
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若有錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean deleteDetail( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmtStatement = null;			
	ResultSet rstResultSet = null;
	String strSql = new String("");			
	int iReturn = 0;
	SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy/MM/dd",java.util.Locale.TAIWAN);
	try
	{
		strSql = new String("DELETE FROM GRPFUN where GRPID = '"+objThisData.strGroup_id+"'");
		//stmtStatement = objThisData.conDb.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		stmtStatement = objThisData.conDb.createStatement();
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDetail()"," The detail delete sql = '"+strSql+"'");
		iReturn = stmtStatement.executeUpdate(strSql);
		if( iReturn == 0 )
		{
//			objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDetail()","detail無資料可供刪除");
//			bReturnStatus = false;
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDetail()","There are '0' rows in detail table had been deleted");
		}
		else
		{
		    objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDetail()","There are '"+String.valueOf(iReturn)+"' rows in detail table had been deleted");
		}
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDetail()",e);
		bReturnStatus = false;
	}
	return bReturnStatus;
}

/**
函數名稱:	isKeyExist( DataClass objThisData )
函數功能:	檢核主鍵值是否存在於資料庫中
傳入參數:	DataClass objThisData : 本程式所有的欄位值
傳回值:	若不存在則傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public boolean isKeyExist( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInquiry = null;				//inquiry tuser 之statement
	ResultSet rstUser = null;				//stmInquiry傳回之Resultset
	String strInquirySql = null;
												//查詢SQL
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the group_id is '"+objThisData.strGroup_id+"'");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstUser = stmInquiry.executeQuery(strInquirySql);
		if( !rstUser.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The group_id '"+objThisData.strGroup_id+"' is not exist in the database");
			bReturnStatus = false;
		}
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The group_id '"+objThisData.strGroup_id+"' is exist in the database");
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkKey()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Exit with status false");
	return bReturnStatus;
}



/**
函數名稱:	moveToXML( DataClass objThisData , Document xmlDom )
函數功能:	將記憶體變數之值轉入xml中
傳入參數:	objThisData	: 所有前端變數之資料結構
		xmlDom		: XML資料結構
傳 回 值:strReturn	: 若為空白,則表示成功.否則傳回錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/

public boolean moveToXML( DataClass objThisData , Document xmlDom )
{
	boolean bReturn = true;
	CommonUtil commonUtil = new CommonUtil();
	int i;
	SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy/MM/dd",java.util.Locale.TAIWAN);

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"User.jsp:moveToXML()","Enter");
	try
	{	

		xmlDom.getElementsByTagName("GRPID").item(0).getFirstChild().setNodeValue( objThisData.strGroup_id );
		
		//先將明細項全部刪除
		org.w3c.dom.NodeList nlsDetails = xmlDom.getElementsByTagName("FUNID");
		org.w3c.dom.Node nodeOneNode = null;
		org.w3c.dom.Node nodeDetail = null;
		org.w3c.dom.Text textTmp = null ;
		
		if( nlsDetails.getLength() != 0 )
		{
			nodeDetail = nlsDetails.item(0);
			while( nodeDetail.hasChildNodes() )
				nodeDetail.removeChild( nodeDetail.getFirstChild() );
		}
		else
		{
			nodeDetail = xmlDom.createElement("FUNID");
			xmlDom.getDocumentElement().appendChild( nodeDetail );
		}
	
		i = 0;
		if( objThisData.vctItem.size() != 0 )
		{
			for( i=0;i< objThisData.vctItem.size();i++ )
			{
				Vector vctOneRow = (Vector)objThisData.vctItem.elementAt(i);
				nodeOneNode = xmlDom.createElement("FUNID");
				textTmp = xmlDom.createTextNode((String)vctOneRow.elementAt(0));	
				nodeOneNode.appendChild( (org.w3c.dom.Node) textTmp );
				nodeDetail.appendChild( nodeOneNode );
			}
		}
		
	}
	catch(Exception ex)
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,"User.jsp:moveToXML()","Exception : "+ex.getMessage());
		bReturn = false;
	}
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"User.jsp:moveToXML()","Exit");
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
	CommonUtil ommonUtil = new CommonUtil();

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":validDom()","Enter");
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
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":validDom()","Exit");
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

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":createNodeText()","Enter");
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
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":createNodeText()","Exit");
	return bReturn;
}
%>
<%@ include file="../Logon/CheckLogon.inc" %>
<%	//Server端程式由此正式開始
	//本程式主要之變數
	boolean bCallBySelf = false;						//是否為自行呼叫
	String strClientMsg = new String("");					//傳回給Client之訊息
	boolean bReturnStatus = true;						//各函數執行之結果
    //R00393  Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();			//目前日期時間
	//R00393  Edit by Leo Huang (EASONTECH) End
	if(globalEnviron == null){
		globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
	}

	DataClass objThisData = new DataClass(siThisSessionInfo);		//本程式主要各欄位資料

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
	//_jspx_cleared_due_to_forward = true;
%>
<%
	/* 
		按照功能處理資料
		1.自request物件中將client傳回之資料載入程式
		2.檢核資料正確性,若有發現任何錯誤,則將錯誤訊息放入strClientMsg中
		3.按照A,U,D,I之功能別,進行資料庫更新
	*/
	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");

	//將前端傳來之資料轉為 Document 物件
	Document xmlDom = null;
	org.apache.xerces.parsers.DOMParser parser = new org.apache.xerces.parsers.DOMParser();

	try
	{	
		//java.io.Reader reader = loadXML( request , objThisData );
		//org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource( reader );
		org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource( new InputStreamReader(request.getInputStream(),"UTF-8") );
		parser.parse( inputSource );
	}
	catch( Exception ex )
	{
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":service()","loadXML Exception : "+ex.getMessage());
	}


	xmlDom = parser.getDocument();
	// for debug
	XMLSerializer ser1 = new XMLSerializer( System.out , new OutputFormat("xml","BIG5",true) );
	ser1.serialize( xmlDom );

	validDom( objThisData , xmlDom );

	
	//先取得資料庫連線
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	else if( !getInputParameter( xmlDom , objThisData) )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	else
	{
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing update function");
		if( !checkFieldsServer( objThisData ) )
		{
			strClientMsg = siThisSessionInfo.getLastErrorMessage();
		}
		else
		{
			if( !updateDb( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
			else
			{
				strClientMsg = "'"+objThisData.strGroup_id+"'"+"修改完成";
				//strClientMsg = "修改完成";
				siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction," Group_id:"+objThisData.strGroup_id);
			}
		}
	}

	//moveToXML( objThisData , xmlDom );
	org.w3c.dom.Node nodeTmp = null ;
	org.w3c.dom.Text textTmp = null ;
	if( xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild() == null)
	{
		nodeTmp = xmlDom.getElementsByTagName("txtMsg").item(0);
		textTmp = xmlDom.createTextNode("");
		nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
	}
	xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild().setNodeValue( strClientMsg );

	//XMLSerializer ser = new XMLSerializer( response.getOutputStream() , new OutputFormat() );
	XMLSerializer ser = new XMLSerializer( out , new OutputFormat("xml","BIG5",true) );

	// ****** debug begin ****************//
	//XMLSerializer ser2 = new XMLSerializer( System.out , new OutputFormat("xml","Cp950",true) );
	//ser2.serialize(xmlDom);
	// ****** debug end *****************//
	ser.serialize( xmlDom );
	//ser.serialize( xmlDom );
	//response.getOutputStream().close();
	objThisData.releaseConnection();
%>