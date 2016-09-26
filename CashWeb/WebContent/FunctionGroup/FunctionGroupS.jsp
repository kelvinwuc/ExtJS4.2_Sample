<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393       Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
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
//�b���w�qcalss variable

	String strThisProgId = new String("FunctionGroup");		//���{���N��
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	GlobalEnviron globalEnviron = null ;
	class DataClass extends Object 
	{
		//��Ʈw��������ܼ�(���{���D�n���)
		public String strGroup_id = new String("");				//�\��s�եN��
		//public String strFunc_id = new String("");				//�{���\��N��
		//public String strFunctionIdDown = new String("");			//�U�h�\��N��
		//public java.util.Date dteCreateDate = cldCalendar.getTime();		//�]�w���
		public Vector	vctItem = new Vector(10,10);				//�������Ӹ��

		public SessionInfo siThisSessionInfo = null;				//�C�@��{���Ҧb��Session information	
		public String strAction = new String("");				//Client�ݤ��\��n�D:'A':�s�W,'U':�ק�,'D':�R��,'I':�d��

		//��Ʈw�s���ܼ�
		public Connection conDb = null;										//AegonWeb��jdbc connection

		//�s����ƮwSQL
		public String strBasicSql = new String("select * from GRPFUN ");
		public String strSelectWhere = new String("where GRPID = ?");
		public String strEmptyWhere = new String("where 1 <> 1");
		
		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			//�N Date type ���ܼƳ]�w����l���
			//dteCreateDate.setTime(0);
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
		}

		//�� DbFactory �����o�@�� Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
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

		//���o���{���� Inquiry SQL
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
	
	/*
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Enter");
	if( objThisData.strUserId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�ϥΪ̥N�����i�ť�");
		bReturnStatus = false;
	}

	if( !objThisData.strPassword.equals(objThisData.strPasswordConfirm) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�ϥΪ̱K�X�����n�P�T�{�K�X�ۦP");
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
	int i;
	try
	{
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
		//���oClient�ݤ����,�s�JDataClass��

		objThisData.strAction = xmlDom.getElementsByTagName("txtAction").item(0).getFirstChild().getNodeValue();
		if( objThisData.strAction == null )
			objThisData.strAction = "";	

		objThisData.strGroup_id = xmlDom.getElementsByTagName("GRPID").item(0).getFirstChild().getNodeValue();
		if( objThisData.strGroup_id == null )
			objThisData.strGroup_id = "";	
		//�Ҧ������Ӹ�Ʀs�� vctItem ��
		if( xmlDom.getElementsByTagName("FUNID").getLength() != 0 )
		{	//�N�C�@��Row��J�@��Vector��
			Vector vctOneRow = new Vector(2,1);
			for(i=0;i<xmlDom.getElementsByTagName("FUNID").getLength();i++)
			{
				vctOneRow.add(xmlDom.getElementsByTagName("FUNID").item(i).getFirstChild().getNodeValue());
				//objThisData.vctItem.add(vctOneRow);
			}
			objThisData.vctItem=vctOneRow;	//�N�㵧�W�Ӹ�Ʀs��objThisData.vctItem��

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
��ƦW��:	insertDetail( DataClass objThisData )
��ƥ\��:	�N�O���餤����Ʒh���Ʈw��,�÷s�W��ƶ������,�s�WCallCenter..tauditdata_detail
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
	{	//insert��Ʀ�tgroup_function
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
	boolean bAutoCommit	= true;
	boolean isAEGON400 = false;
	if(globalEnviron.getActiveAS400DataSource().equals(Constant.AS400_DATA_SOURCE_NAME_AEGON400)){
		isAEGON400 = true ;
	}
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Enter");
	//���ˬd�ӵ���ƬO�_�s�b���Ʈw��,�Y���s�b,�h�Ǧ^���~�T��,�_�h�i���Ʈw��s
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","�ӵ���ƥ��s���Ʈw��,���ˬd");
		bReturnStatus = false;
	}
	else
	{
		try
		{	//���Nconnection��autoCommit���A�s��bAutoCommit��,�H�ݱN�Ӥ���_
			bAutoCommit = objThisData.conDb.getAutoCommit();
			if(isAEGON400){
				objThisData.conDb.setAutoCommit(false);	//�]���n����h�ӫ��O,�ҥH�NAutoCommit�]�w��false,commit�ѵ{������
			}
			//���Ndetail��ƶ��R��
			if( !deleteDetail( objThisData ) )		
			{		//�����\�Nrollback
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
					//���������\��~commit
					if(isAEGON400){
						objThisData.conDb.commit();
					}
				}
			}	
			objThisData.conDb.setAutoCommit(bAutoCommit);	//�NautoCommit�٭�
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
��ƦW��:	deleteDetail( DataClass objThisData )
��ƥ\��:	�N��ƶ�����detail��ƥ����R��,�R��CallCenter..tauditdata_detail�������
�ǤJ�Ѽ�:	DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
//			objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDetail()","detail�L��ƥi�ѧR��");
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
��ƦW��:	moveToXML( DataClass objThisData , Document xmlDom )
��ƥ\��:	�N�O�����ܼƤ�����Jxml��
�ǤJ�Ѽ�:	objThisData	: �Ҧ��e���ܼƤ���Ƶ��c
		xmlDom		: XML��Ƶ��c
�� �^ ��:strReturn	: �Y���ť�,�h��ܦ��\.�_�h�Ǧ^���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
		
		//���N���Ӷ������R��
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
	String strClientMsg = new String("");					//�Ǧ^��Client���T��
	boolean bReturnStatus = true;						//�U��ư��椧���G
    //R00393  Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();			//�ثe����ɶ�
	//R00393  Edit by Leo Huang (EASONTECH) End
	if(globalEnviron == null){
		globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
	}

	DataClass objThisData = new DataClass(siThisSessionInfo);		//���{���D�n�U�����

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
				strClientMsg = "'"+objThisData.strGroup_id+"'"+"�ק粒��";
				//strClientMsg = "�ק粒��";
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