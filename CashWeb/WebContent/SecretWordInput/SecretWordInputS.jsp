<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393      Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
 *  =============================================================================
 */
%>
<%@ page contentType="text/html; charset=Big5" pageEncoding="Big5"%>
<%@ include file="../Logon/Init.inc" %>

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

	String strThisProgId = new String("SecretWordInput");		//���{���N��
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393   Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	class DataClass extends Object 
	{
		//��Ʈw��������ܼ�(���{���D�n���)
		public String strUserId = new String("");		//�ϥΪ̥N��
		public String strSecretWordQuestion = "";		//�K�X���ܻy���D
		public String strSecretWordAnswer = "";			//�K�X���ܰ��D������

		public SessionInfo siThisSessionInfo = null;						//�C�@��{���Ҧb��Session information	
		public String strAction = new String("");							//Client�ݤ��\��n�D:'A':�s�W,'U':�ק�,'D':�R��,'I':�d��

		//��Ʈw�s���ܼ�
		public Connection conDb = null;									//CallCenter��jdbc connection

		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			//�N Date type ���ܼƳ]�w����l���
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
		}

		//�� DbFactory �����o�@�� Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("SecretWordInputS.DataClass.getConnection()");
			if( conDb == null )
				bReturnStatus = false;
			if( bReturnStatus )
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getConnection()","getConnection O.K.");
			else
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":getConnection()","siThisSessionInfo.getUserInfo().getDbFactory().getConnection() return null error!!");

			return bReturnStatus;
		}
		
		// ���� Connection
		public boolean releaseConnection()
		{
			boolean bReturnStatus = true ;
			if(conDb!=null){
				siThisSessionInfo.getUserInfo().getDbFactory().releaseConnection(conDb);
			}
			return bReturnStatus ;	
		}

		//���o���{���� Insert SQL
		public String getInsertSql()
		{	
			String strReturn = new  String("");
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInsertSql()","The insert sql is '"+strReturn+"'");
			return strReturn;
		}

		//���o���{���� Update SQL
		public String getUpdateSql()
		{	
			String strReturn = 
				"update USER set "
					+" SCTQ='"+strSecretWordQuestion+"', "
					+" SCTA='"+strSecretWordAnswer+"' "
					+" where USRID='"+strUserId+"' ";
					
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getUpdateSql()","The update sql is '"+strReturn+"'");
			return strReturn;
		}

		//���o���{���� Delete SQL
		public String getDeleteSql()
		{	
			String strReturn = new  String("");
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}


		//���o���{���� Inquiry SQL
		public String getInquirySql()
		{	
			String strReturn = 
				"select 1 from USER where USRID='"+strUserId+"' ";
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
	if( objThisData.strUserId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�ϥΪ̥N�����i�ť�");
		bReturnStatus = false;
	}

	if( objThisData.strSecretWordQuestion.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�K�X���ܻy���D���i�ť�");
		bReturnStatus = false;
	}

	if( objThisData.strSecretWordAnswer.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�K�X���ܰ��D�����פ��i�ť�");
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
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//CommonUtil commonUtil = new CommonUtil();
	//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
	//R00393  Edit by Leo Huang (EASONTECH) End

	try
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
		//���oClient�ݤ����,�s�JDataClass��
		
		objThisData.strAction = xmlDom.getElementsByTagName("txtAction").item(0).getFirstChild().getNodeValue();
			
		if( objThisData.strAction == null )
			objThisData.strAction = "";	

		objThisData.strSecretWordQuestion = xmlDom.getElementsByTagName("txtSecretWordQuestion").item(0).getFirstChild().getNodeValue();
		if( objThisData.strSecretWordQuestion == null )
			objThisData.strSecretWordQuestion = "";

		objThisData.strSecretWordAnswer = xmlDom.getElementsByTagName("txtSecretWordAnswer").item(0).getFirstChild().getNodeValue();
		if( objThisData.strSecretWordAnswer == null )
			objThisData.strSecretWordAnswer = "";	
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
��ƥ\��:	�N�@����Ʒs�W��tuser table ��
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean insertDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	/*
	Statement stmInsert = null;			//Insert tuser ��statement
	String strInsertSql = new String("");	//Insert tuser ��SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Enter");
	//���ˬd��ȬO�_�s�b,�p�G�s�b�h�Ǧ^���~�T��,�_�h�N�ﵧ��Ʒs�W�ܸ�Ʈw��
	if( isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","�ϥΪ̥N�� '"+objThisData.strUserId+"' �w�s�b���Ʈw��");
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
	*/
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
	Statement stmUpdate = null;			//Update tuser ��statement
	String strUpdateSql = new String("");	//Update tuser ��SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Enter");
	//���ˬd�ӵ���ƬO�_�s�b���Ʈw��,�Y���s�b,�h�Ǧ^���~�T��,�_�h�i���Ʈw��s
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","�ϥΪ̥N�� '"+objThisData.strUserId+"' ���s�b���Ʈw��");
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
	/*
	Statement stmInquiry = null;			//Inquiry tuser ��statement
	String strInquirySql = new String("");	//Inquiry tuser ��SQL
	ResultSet rstResultSet = null;		//Inquiry tuser �Ǧ^��ResultSet
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
			objThisData.strUserId = rstResultSet.getString("user_id").trim();
			objThisData.strUserName = rstResultSet.getString("user_name").trim();
			objThisData.strPassword = rstResultSet.getString("password").trim();
			objThisData.strPasswordConfirm = objThisData.strPassword;
			objThisData.dteCreateDate = rstResultSet.getDate("create_date");
			objThisData.strUserStatus = rstResultSet.getString("user_status").trim();
			objThisData.strUserType = rstResultSet.getString("user_type").trim();
			objThisData.dteLastLoginDate = rstResultSet.getDate("last_login_date");
			objThisData.dteLastPasswdDate = rstResultSet.getDate("last_password_date");
			objThisData.strRemark = rstResultSet.getString("remark").trim();
			objThisData.iPasswordValidDay = rstResultSet.getInt("password_valid_day");
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Password valid days = '"+String.valueOf(objThisData.iPasswordValidDay)+"'");
		}
		else
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","�ϥΪ̥N�� '"+objThisData.strUserId+"' ���s�b���Ʈw��");
			bReturnStatus = false;
		}
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Exit with status false");
	*/
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
	/*
	Statement stmDelete = null;			//Delete tuser ��statement
	String strDeleteSql = new String("");	//Delete tuser ��SQL
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Enter");
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","�ϥΪ̥N�� '"+objThisData.strUserId+"' ���s�b���Ʈw��");
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
	*/
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
	Statement stmInquiry = null;				//inquiry tuser ��statement
	ResultSet rstUser = null;				//stmInquiry�Ǧ^��Resultset
	String strInquirySql = null;
												//�d��SQL
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the user_id is '"+objThisData.strUserId+"'");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstUser = stmInquiry.executeQuery(strInquirySql);
		if( !rstUser.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The user_id '"+objThisData.strUserId+"' is not exist in the database");
			bReturnStatus = false;
		}
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The user_id '"+objThisData.strUserId+"' is exist in the database");
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

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":moveToXML()","Enter");
	try
	{	
		xmlDom.getElementsByTagName("txtAction").item(0).getFirstChild().setNodeValue( objThisData.strAction );
		xmlDom.getElementsByTagName("txtSecretWordQuestion").item(0).getFirstChild().setNodeValue( objThisData.strSecretWordQuestion );
		xmlDom.getElementsByTagName("txtSecretWordAnswer").item(0).getFirstChild().setNodeValue( objThisData.strSecretWordAnswer );
	}
	catch(Exception ex)
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":moveToXML()","Exception : "+ex.getMessage());
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
<%	//Server�ݵ{���Ѧ������}�l
	//���{���D�n���ܼ�
	boolean bCallBySelf = false;						//�O�_���ۦ�I�s
	String strClientMsg = new String("");				//�Ǧ^��Client���T��
	boolean bReturnStatus = true;						//�U��ư��椧���G
    //R00393  Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();		//�ثe����ɶ�
//R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass(siThisSessionInfo);	//���{���D�n�U�����
	
	objThisData.strUserId = siThisSessionInfo.getUserInfo().getUserId();

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
	//_jspx_cleared_due_to_forward = true;
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
					strClientMsg = "'"+objThisData.strUserId+"'�s�W����";
					siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction,"Q = '"+objThisData.strSecretWordQuestion+"' <BR> A = '"+objThisData.strSecretWordAnswer+"'");
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
					strClientMsg = ""+objThisData.strUserId+"�ק粒��";
					siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strAction,"Q = '"+objThisData.strSecretWordQuestion+"' <BR> A = '"+objThisData.strSecretWordAnswer+"'");
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
				strClientMsg = "'"+objThisData.strUserId+"'�R������";
		}
		else if( objThisData.strAction.equalsIgnoreCase("I") )	//�d��
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing inquiry function");
			if( !inquiryDb( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
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
	XMLSerializer ser = new XMLSerializer(out, new OutputFormat("xml","BIG5",true) );
	ser.serialize( xmlDom );
	objThisData.releaseConnection();
%>