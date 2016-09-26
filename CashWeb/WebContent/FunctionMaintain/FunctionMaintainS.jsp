<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393      Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
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
<%@ page import="com.aegon.servlet.*" %>
<%@ page import="org.apache.xml.serialize.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.apache.xerces.parsers.*" %>
<%@ page import="org.xml.sax.*" %>
<%!
//�b���w�qcalss variable

	String strThisProgId = new String("FunctionMaintain");		//���{���N��
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//CommonUtil commonUtil = null;
	//R00393  Edit by Leo Huang (EASONTECH) End
	class DataClass extends Object 
	{
		//��Ʈw��������ܼ�(���{���D�n���)
		public String strFuncId    = new String("");
		public String strFuncName  = new String("");
		public String strRemark    = new String("");
		public String strProperty  = new String("P");	
		public String strUrl       = new String("");				
		public String strTargetWindow = new String("arena");	
				
		public SessionInfo siThisSessionInfo = null;						//�C�@��{���Ҧb��Session information	
		
		public boolean bPasswordEncryption = false;
		public EncryptionBean encoder = null;
		public boolean bCaseSenstive = true;

		public String strAction = new String("");							//Client�ݤ��\��n�D:'A':�s�W,'U':�ק�,'D':�R��,'I':�d��

		//��Ʈw�s���ܼ�
		public Connection conDb = null;									//CashWeb��jdbc connection

		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			//�N Date type ���ܼƳ]�w����l���
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Password encrypted = '"+String.valueOf(bPasswordEncryption)+"'");
		}

		//�� DbFactory �����o�@�� Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getAS400Connection("UserMaintainS.DataClass.getConnection()");
			if( conDb == null )
				bReturnStatus = false;
			if( bReturnStatus )
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getConnection()","getConnection O.K.");
			else
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":getConnection()","siThisSessionInfo.getUserInfo().getDbFactory().getConnection() return null error!!");

			return bReturnStatus;
		}

		public boolean releaseConnection()
		{
			boolean bReturnStatus = true;
			if( conDb != null )
			{
				siThisSessionInfo.getUserInfo().getDbFactory().releaseAS400Connection(conDb);
				conDb = null;
			}

			return bReturnStatus;
		}

		//���o���{���� Insert SQL
		public String getInsertSql()
		{	
			String strReturn = new  String("");
				strReturn = "INSERT INTO FUNC (FUNID,FUNNAM,PROP,RUL,TWIN,REMK) values ('";
			strReturn = strReturn + strFuncId + "','" ;
			strReturn = strReturn + strFuncName + "','" ;
			strReturn = strReturn + strProperty + "','" ;
			strReturn = strReturn + strUrl + "','" ;
			strReturn = strReturn + strTargetWindow + "','" ;
			strReturn = strReturn + strRemark + "')" ;
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInsertSql()","The insert sql is '"+strReturn+"'");
	//		System.out.println("getInsertSql-->"+strReturn);
			return strReturn;
		}

		//���o���{���� Update SQL
		public String getUpdateSql()
		{	
			String strReturn = new  String("");
			strReturn = "update FUNC set ";
			strReturn = strReturn + " FUNNAM = '"+strFuncName + "'," ;
			strReturn = strReturn + " PROP = '"+strProperty + "'," ;
			strReturn = strReturn + " RUL = '"+strUrl + "'," ;
			strReturn = strReturn + " TWIN = '"+strTargetWindow + "'," ;
			strReturn = strReturn + " REMK = '"+strRemark + "' " ;
			strReturn = strReturn + " where FUNID = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getUpdateSql()","The update sql is '"+strReturn+"'");
		//	System.out.println("getUpdateSql-->"+strReturn);
			return strReturn;
		}

		//���o���{���� Delete SQL
		public String getDeleteSql()
		{	
		System.out.println("Begin Delete");
			String strReturn = new  String("");
			strReturn = "delete from FUNC where FUNID = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}


		//���o���{���� Inquiry SQL
		public String getInquirySql()
		{	
			String strReturn = new  String("");
			strReturn = "select * from FUNC where FUNID = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}
	}

%>
<%!
//���{�����W�ߨ�Ʀb���w�q
/**
��ƦW��:	checkFieldsServer( DataClass objThisData )
��ƥ\��:	�ˬd�Ҧ������,�Y�����@�����~,�h�Ǧ^false,�_�h�Ǧ^true
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����@�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean checkFieldsServer( DataClass objThisData )
{
	boolean bReturnStatus = true;

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Enter");
	if( objThisData.strFuncId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�\��N�����i�ť�");
		bReturnStatus = false;
	}

	if( bReturnStatus )	
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status false");
	return bReturnStatus;
}
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
	
	CommonUtil commonUtil = new CommonUtil();
    //R00393  Edit by Leo Huang (EASONTECH) Start
	//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
    //R00393  Edit by Leo Huang (EASONTECH) End
	try
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
		//���oClient�ݤ����,�s�JDataClass��
		
		objThisData.strAction = xmlDom.getElementsByTagName("txtAction").item(0).getFirstChild().getNodeValue();
			
		if( objThisData.strAction == null )
			objThisData.strAction = "";	

		objThisData.strFuncId = xmlDom.getElementsByTagName("txtFuncId").item(0).getFirstChild().getNodeValue();
		if( objThisData.strFuncId == null )
			objThisData.strFuncId = "";	

		objThisData.strFuncName = xmlDom.getElementsByTagName("txtFuncName").item(0).getFirstChild().getNodeValue();
		if( objThisData.strFuncName == null )
			objThisData.strFuncName = "";

		objThisData.strProperty = xmlDom.getElementsByTagName("radProperty").item(0).getFirstChild().getNodeValue();
		if( objThisData.strProperty == null )
			objThisData.strProperty = "M";	

		objThisData.strUrl = xmlDom.getElementsByTagName("txtUrl").item(0).getFirstChild().getNodeValue();
		if( objThisData.strUrl == null )
			objThisData.strUrl = "";	
			
		objThisData.strTargetWindow = xmlDom.getElementsByTagName("txtTwin").item(0).getFirstChild().getNodeValue();
		if( objThisData.strTargetWindow == null )
			objThisData.strTargetWindow = "";		

		objThisData.strRemark = xmlDom.getElementsByTagName("txtRemark").item(0).getFirstChild().getNodeValue();
		if( objThisData.strRemark == null )
			objThisData.strRemark = "";		


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
��ƦW��:	insertDb( DataClass objThisData )
��ƥ\��:	�N�@����Ʒs�W��tUser table ��
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean insertDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInsert = null;			//Insert tUser ��statement
	String strInsertSql = new String("");	//Insert tUser ��SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Enter");
	//���ˬd��ȬO�_�s�b,�p�G�s�b�h�Ǧ^���~�T��,�_�h�N�ﵧ��Ʒs�W�ܸ�Ʈw��
	if( isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","�\��N�� '"+objThisData.strFuncId+"' �w�s�b���Ʈw��");
		bReturnStatus = false;
	}
	else
	{
		try
		{
			strInsertSql = objThisData.getInsertSql();
			stmInsert = objThisData.conDb.createStatement();
			iReturn = stmInsert.executeUpdate(strInsertSql);
			if( iReturn != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","The insert sql return != 1 return = '"+String.valueOf(iReturn)+"'");
				bReturnStatus = false;
			}
		}
		catch( SQLException e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()",e);
			bReturnStatus = false;
		}
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Exit with status false");
	return bReturnStatus;
}
/**
��ƦW��:	updateDb( DataClass objThisData )
��ƥ\��:	��s�ӵ����
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean updateDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmUpdate = null;			//Update tUser ��statement
	String strUpdateSql = new String("");	//Update tUser ��SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Enter");
	//���ˬd�ӵ���ƬO�_�s�b���Ʈw��,�Y���s�b,�h�Ǧ^���~�T��,�_�h�i���Ʈw��s
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","�\��N�� '"+objThisData.strFuncId+"' ���s�b���Ʈw��");
		bReturnStatus = false;
	}
	else
	{
		try
		{
			strUpdateSql = objThisData.getUpdateSql();
			stmUpdate = objThisData.conDb.createStatement();
			iReturn = stmUpdate.executeUpdate(strUpdateSql);
			if( iReturn != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","The update sql return != 1 return = '"+String.valueOf(iReturn)+"'");
				bReturnStatus = false;
			}
		}
		catch( SQLException e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()",e);
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
��ƦW��:	inquiryDb( DataClass objThisData )
��ƥ\��:	�۸�Ʈw���d�ߤ@�����
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean inquiryDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInquiry = null;			//Inquiry tUser ��statement
	String strInquirySql = new String("");	//Inquiry tUser ��SQL
	ResultSet rstResultSet = null;		//Inquiry tUser �Ǧ^��ResultSet
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Enter");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstResultSet = stmInquiry.executeQuery(strInquirySql);
		if( rstResultSet.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Fetch 1 record successfully");
			objThisData.strFuncId = rstResultSet.getString("FUNID").trim();
			objThisData.strFuncName = rstResultSet.getString("FUNNAM").trim();
			objThisData.strProperty = rstResultSet.getString("PROP").trim();
			objThisData.strUrl = rstResultSet.getString("RUL").trim();
			objThisData.strTargetWindow = rstResultSet.getString("TWIN").trim();
			objThisData.strRemark = rstResultSet.getString("REMK").trim();
		}
		else
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","�\��N�� '"+objThisData.strFuncId+"' ���s�b���Ʈw��");
			bReturnStatus = false;
		}
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Exit with status false");
	return bReturnStatus;
}

/**
��ƦW��:	deleteDb( DataClass objThisData )
��ƥ\��:	�R���@�����
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean deleteDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmDelete = null;			//Delete tUser ��statement
	String strDeleteSql = new String("");	//Delete tUser ��SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Enter");
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","�\��N�� '"+objThisData.strFuncId+"' ���s�b���Ʈw��");
		bReturnStatus = false;
	}
	else
	{
		try
		{
			strDeleteSql = objThisData.getDeleteSql();
			stmDelete = objThisData.conDb.createStatement();
			iReturn = stmDelete.executeUpdate(strDeleteSql);
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","'"+String.valueOf(iReturn)+"' record deleted");
			if( iReturn != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","The update sql return != 1 return = '"+String.valueOf(iReturn)+"'");
				bReturnStatus = false;
			}
		}
		catch( SQLException e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()",e);
			bReturnStatus = false;
		}
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Exit with status false");
	return bReturnStatus;
}

/**
��ƦW��:	isKeyExist( DataClass objThisData )
��ƥ\��:	�ˮ֥D��ȬO�_�s�b���Ʈw��
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y���s�b�h�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean isKeyExist( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInquiry = null;				//inquiry tUser ��statement
	ResultSet rstUser = null;				//stmInquiry�Ǧ^��Resultset
	String strInquirySql = null;
												//�d��SQL
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the FuncId is '"+objThisData.strFuncId+"'");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstUser = stmInquiry.executeQuery(strInquirySql);
		if( !rstUser.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The FuncId '"+objThisData.strFuncId+"' is not exist in the database");
			bReturnStatus = false;
		}
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The FuncId '"+objThisData.strFuncId+"' is exist in the database");
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
��ƦW��:	moveToXML( DataClass objThisData , Document xmlDom )
��ƥ\��:	�N�O�����ܼƤ�����Jxml��
�ǤJ�Ѽ�:	objThisData	: �Ҧ��e���ܼƤ���Ƶ��c
			xmlDom		: XML��Ƶ��c
�� �^ ��:	strReturn		: �Y���ť�,�h��ܧ���.�_�h�Ǧ^���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean moveToXML( DataClass objThisData , Document xmlDom )
{
	boolean bReturn = true;
	CommonUtil commonUtil = new CommonUtil();

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Enter");
	try
	{	

		xmlDom.getElementsByTagName("txtAction").item(0).getFirstChild().setNodeValue( objThisData.strAction );
		xmlDom.getElementsByTagName("txtFuncId").item(0).getFirstChild().setNodeValue( objThisData.strFuncId );
		xmlDom.getElementsByTagName("txtFuncName").item(0).getFirstChild().setNodeValue( objThisData.strFuncName );
		xmlDom.getElementsByTagName("txtRemark").item(0).getFirstChild().setNodeValue( objThisData.strRemark );
		xmlDom.getElementsByTagName("radProperty").item(0).getFirstChild().setNodeValue( objThisData.strProperty );
		xmlDom.getElementsByTagName("txtUrl").item(0).getFirstChild().setNodeValue( objThisData.strUrl );
		xmlDom.getElementsByTagName("txtTwin").item(0).getFirstChild().setNodeValue( objThisData.strTargetWindow );

	}
	catch(Exception ex)
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":moveToXML()",ex);
		bReturn = false;
	}
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Exit");
	return bReturn;
}


/**
��ƦW��:	validDom( DataClass objThisData , Document xmlDom )
��ƥ\��:	�N DOM �����C�@ Element ���[�W Text
�ǤJ�Ѽ�:	objThisData	: �Ҧ��e���ܼƤ���Ƶ��c
			xmlDom		: XML��Ƶ��c
�� �^ ��:	strReturn		: �Y���ť�,�h��ܧ���.�_�h�Ǧ^���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean validDom( DataClass objThisData , Document xmlDom )
{
	boolean bReturn = true;
	CommonUtil ommonUtil = new CommonUtil();

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
�� �^ ��:	strReturn		: �Y���ť�,�h��ܧ���.�_�h�Ǧ^���~�T��
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
<%@ include file="../Logon/CheckLogon.inc" %>
<%	//Server�ݵ{���Ѧ������}�l
	//���{���D�n���ܼ�
	boolean bCallBySelf = false;						//�O�_���ۦ�I�s
	String strClientMsg = new String("");				//�Ǧ^��Client���T��
	boolean bReturnStatus = true;						//�U��ư��椧���G
    //R00393  Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();		//�ثe����ɶ�
     //R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass(siThisSessionInfo);	//���{���D�n�U�����
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//if(commonUtil == null){
	//	commonUtil = new CommonUtil();
	//}
     //R00393  Edit by Leo Huang (EASONTECH) End
	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
%>
<%
	/* 
		���ӥ\��B�z���
		1.��request���󤤱Nclient�Ǧ^����Ƹ��J�{��
		2.�ˮָ�ƥ��T��,�Y���o�{������~,�h�N���~�T����JstrClientMsg��
		3.����A,U,D,I���\��O,�i���Ʈw��s
	*/
	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");

	//�N�e�ݶǨӤ�����ର Document ����
	Document xmlDom = null;
	org.apache.xerces.parsers.DOMParser parser = new org.apache.xerces.parsers.DOMParser();

	try
	{	
//		java.io.Reader reader = loadXML( request , objThisData );
//		org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource( reader );
		org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource( new InputStreamReader(request.getInputStream(),"UTF-8") );
		parser.parse( inputSource );
	}
	catch( Exception ex )
	{
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":service()","loadXML Exception : "+ex.getMessage());
	}


	xmlDom = parser.getDocument();

	validDom( objThisData , xmlDom );

	
	//�����o��Ʈw�s�u
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
		//�Y�O�s�W�ʧ@��,���ˮ֦U�欰�O�_��J���T,�Y���T,�h�g��Ʈw
		if( objThisData.strAction.equalsIgnoreCase("A") )	//�s�W
		{//���ˬd�Ҧ����O�_���T
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing add function");
			if( !checkFieldsServer( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
			else
			{
				if( !insertDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				else
				{
					strClientMsg = "'"+objThisData.strFuncId+"'�s�W����";
					siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction,objThisData.strFuncId);
				}
			}
		}
		//�Y�O�ק�ʧ@��,���ˮ֦U�欰�O�_��J���T,�Y���T,�h�g��Ʈw
		if( objThisData.strAction.equalsIgnoreCase("U"))	//�ק�
		{//���ˬd�Ҧ����O�_���T
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
					strClientMsg = "'"+objThisData.strFuncId+"'�ק粒��";
					siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction,objThisData.strFuncId);
				}
			}
		}
		else if( objThisData.strAction.equalsIgnoreCase("D") )	//�R��
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing delete function");
			if( !deleteDb( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
			else
			{
				strClientMsg = "'"+objThisData.strFuncId+"'�R������";
				siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction,objThisData.strFuncId);
			}
		}
		else if( objThisData.strAction.equalsIgnoreCase("I") )	//�d��
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing inquiry function");
			if( !inquiryDb( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
			else
			{
				siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction,objThisData.strFuncId);
			}
		}
	}


	moveToXML( objThisData , xmlDom );
	org.w3c.dom.Node nodeTmp = null ;
	org.w3c.dom.Text textTmp = null ;
	if( xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild() == null)
	{
		nodeTmp = xmlDom.getElementsByTagName("txtMsg").item(0);
		textTmp = xmlDom.createTextNode("");
		nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
	}
	xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild().setNodeValue( strClientMsg );

	
	XMLSerializer ser = new XMLSerializer( out , new OutputFormat("xml","BIG5",true) );
	ser.serialize( xmlDom );
	objThisData.releaseConnection();
	
%>