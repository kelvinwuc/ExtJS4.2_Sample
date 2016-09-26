<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393      Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
 *  =============================================================================
 */
%>
<%@ page contentType="text/html;charset=BIG5" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.aegon.servlet.*" %>
<%@ include file="../Logon/CheckLogon.inc" %>
<!--
	�g�L CheckLogon.jsp ���B�z��,�C�@��{�����|�� 
		SessionInfo siThisSessionInfo
		UserInfo    uiThisUserInfo
-->
<%!

	String strThisProgId = new String("GroupMaintain");		//���{���N��
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
    Calendar cldCalendar = null;
    CommonUtil commonUtil =null;
//R00393  Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	public final String DEFAULT_GROUP = "select default group";
	class DataClass extends Object 
	{
		public String strGroupId = new String("");
		public String strDefUserId = new String("");
		public String strGroupName = new String("");
		public String strRemark = new String("");
		public String strUpdateId = new String("");	
		public String strCreateDate = new String("");				
		public String strAllGroupIds = new String("");			
		public String strAllGroupNames = new String("");
		public Vector vGroupId    = new Vector();
		public Vector vGroupName  = new Vector();			
		public String strDefaultGroup = new String("");			
		public SessionInfo siThisSessionInfo = null;	
		public String strActionCode = new String("");	
		public java.util.Date dteStartDate = cldCalendar.getTime();			
		
		public String szSysFlag = new String("");
		//��Ʈw�s���ܼ�
		public Connection conDb = null;					//jdbc connection
		
		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			//R00393   Edit by Leo Huang (EASONTECH) Start
			commonUtil = new CommonUtil(siSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());
			cldCalendar = commonUtil.getBizDateByRCalendar();
			//R00393  Edit by Leo Huang (EASONTECH) End
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
			
		}

		//destructor
		public void finalize()
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":finalize()","Destructor enter");
			releaseConnection();
		}

		//�� DbFactory �����o�@�� Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("GroupMaintain.DataClass.getConnection()");
			if( conDb == null )
				bReturnStatus = false;
			if( bReturnStatus )
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getConnection()","getConnection O.K.");
			else
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":getConnection()","siThisSessionInfo.getUserInfo().getDbFactory().getConnection() return null error!!");

			return bReturnStatus;
		}

		public void releaseConnection()
		{
			if( conDb != null )
				siThisSessionInfo.getUserInfo().getDbFactory().releaseConnection(conDb);
			conDb = null;
		}


		//���o���{���� Insert SQL
		public String getInsertSql()
		{	
			String strReturn = new  String("");
			strReturn = "insert into tgroup (group_id,group_name,create_date,update_user_id,remark) values ('";
			strReturn = strReturn + strGroupId + "','" ;
			strReturn = strReturn + strGroupName + "','" ;
			strReturn = strReturn + sdfDateFormatter.format(dteStartDate) + "','" ;
			strReturn = strReturn + strDefUserId + "','" ;
			strReturn = strReturn + strRemark + "')" ;
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInsertSql()","The insert sql is '"+strReturn+"'");
			return strReturn;
		}

		//���o���{���� Update SQL
		public String getUpdateSql()
		{	
			String strReturn = new  String("");
			strReturn = "update tgroup set ";
			strReturn = strReturn + " group_id = '"+strGroupId + "'," ;
			strReturn = strReturn + " group_name = '"+strGroupName + "'," ;
			strReturn = strReturn + " create_date = '"+sdfDateFormatter.format(dteStartDate)+ "'," ;
			strReturn = strReturn + " update_user_id = '"+strDefUserId + "'," ;
			strReturn = strReturn + " remark = '"+strRemark + "' " ;
			strReturn = strReturn + " where group_id = '"+strGroupId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getUpdateSql()","The update sql is '"+strReturn+"'");
			return strReturn;
		}

		//���o���{���� Delete SQL
		public String getDeleteSql()
		{	
			String strReturn = new  String("");
			strReturn = "delete tgroup where group_id = '"+strGroupId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}


		//���o���{���� Inquiry SQL
		public String getInquirySql()
		{	
			String strReturn = new  String("");
			strReturn = "select * from tgroup where group_id = '"+strGroupId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}
		
		// Report SQL
		public String getReportSql()
		{
			String strReturn = new String("");
			strReturn = "select group_id, group_name from tgroup ";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getReportSql()","The Report1 sql is '"+strReturn+"'");
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
	boolean bReturnStatus  = true;
	Statement stmStatement = null;
	ResultSet rstResultSet = null;
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Enter");
	if( objThisData.strGroupId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�п�J�M�ץN��");
		bReturnStatus = false;
	}

	/*if( objThisData.strProjectUrl.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�п�J�M�׻����������}");
		bReturnStatus = false;
	}

	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery("select group_id from tgroup where group_id = '"+objThisData.strDefaultGroup+"'");
		if( !rstResultSet.next() )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�w�]�s��'"+objThisData.strDefaultGroup+"'���s��s��s���ɤ�");
			bReturnStatus = false;
		}
		rstResultSet.close();
		stmStatement.close();
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()",e);
		bReturnStatus = false;
	}*/
	
	if( bReturnStatus )	
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status false");
	return bReturnStatus;
}
/**
��ƦW��:	getInputParameter( HttpServletRequest req, DataCalss objThisData ) 
��ƥ\��:	�NClient�ݶǤJ���U���Ȧs�JobjThisData��
�ǤJ�Ѽ�:	HttpServletRequest req: Client�ǤJ�� request object
		DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����@�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean getInputParameter(HttpServletRequest req,DataClass objThisData)
{
	boolean bReturnStatus = true;
	CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());

	HttpSession userSession = req.getSession(false);
	objThisData.strDefUserId = (String)userSession.getAttribute("UserId");
	if( objThisData.strDefUserId == null )
		objThisData.strDefUserId = "";
			
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
	//���oClient�ݤ����,�s�JDataClass��
	//�����Nclient�ݤ��\������o
	objThisData.strActionCode = req.getParameter("btnAction");
	if( objThisData.strActionCode == null )
		objThisData.strActionCode = "";	

	objThisData.strGroupId = req.getParameter("txtGroupId");
	if( objThisData.strGroupId == null )
		objThisData.strGroupId = "";	
	objThisData.strGroupName = req.getParameter("txtGroupName");
	if( objThisData.strGroupName == null )
		objThisData.strGroupName = "";
	//������쥲���ϥ�getBytes("Big5")�~�|���T,�_�h�|�ܦ��ýX
	try
	{	
		objThisData.strGroupName = new String( objThisData.strGroupName.getBytes("Big5") );
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
	}
	objThisData.strRemark = req.getParameter("txtRemark");
	if( objThisData.strRemark == null )
		objThisData.strRemark = "";	
	try
	{	
		objThisData.strRemark = new String( objThisData.strRemark.getBytes("Big5") );
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
	}

	objThisData.dteStartDate = commonUtil.convertROC2WestenDate(req.getParameter("txtCreateDate"));
	if( objThisData.dteStartDate== null )
		objThisData.dteStartDate = cldCalendar.getTime();	
	objThisData.strUpdateId = req.getParameter("txtUpdateId");
	if( objThisData.strUpdateId== null )
		objThisData.strUpdateId= "";	
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
	Statement stmInsert = null;	
	String strInsertSql = new String("");
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Enter");
	//���ˬd��ȬO�_�s�b,�p�G�s�b�h�Ǧ^���~�T��,�_�h�N�ﵧ��Ʒs�W�ܸ�Ʈw��
	if( isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","�ϥΪ̥N�� '"+objThisData.strGroupId+"' �w�s�b���Ʈw��");
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
	Statement stmUpdate = null;
	String strUpdateSql = new String("");
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":updateDb()","Enter");
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","�ϥΪ̥N�� '"+objThisData.strGroupId+"' ���s�b���Ʈw��");
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
	Statement stmInquiry = null;		
	String strInquirySql = new String("");	
	ResultSet rstResultSet = null;		
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
			if( rstResultSet.getString("group_id") != null )
				objThisData.strGroupId = rstResultSet.getString("group_id").trim();
			else
				objThisData.strGroupId = new String("");
			if( rstResultSet.getString("group_name") != null )
				objThisData.strGroupName = rstResultSet.getString("group_name").trim();
			else
				objThisData.strGroupName = new String("");
			if( rstResultSet.getString("remark") != null )
				objThisData.strRemark = rstResultSet.getString("remark").trim();
			else
				objThisData.strRemark = new String("");
			if( rstResultSet.getString("update_user_id") != null)
				objThisData.strUpdateId = rstResultSet.getString("update_user_id").trim();
			else
				objThisData.strUpdateId = new String("");
			if( rstResultSet.getDate("create_date") != null )
				objThisData.dteStartDate = rstResultSet.getDate("create_date");
			else
				objThisData.dteStartDate = null;
		}
		else
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","�ϥΪ̥N�� '"+objThisData.strGroupId+"' ���s�b���Ʈw��");
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
	Statement stmDelete = null;
	String strDeleteSql = new String("");
	int iReturn = 0;
	
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Enter");
	if( !isKeyExist( objThisData ) )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","�ϥΪ̥N�� '"+objThisData.strGroupId+"' ���s�b���Ʈw��");
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

public boolean selectDb( DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInquiry = null;		
	String strReportSql = new String("");	
	ResultSet rstResultSet = null;		
	int iReturn = 0;
		
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDb()","Enter");
	try
	{
		strReportSql = objThisData.getReportSql();
		stmInquiry = objThisData.conDb.createStatement();
		rstResultSet = stmInquiry.executeQuery(strReportSql);
		while(rstResultSet.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDb()","Fetched records successfully");
			if( rstResultSet.getString("group_id") != null )
				objThisData.strAllGroupIds = rstResultSet.getString("group_id").trim();
			else
				objThisData.strAllGroupIds = new String("");
			if( rstResultSet.getString("group_name") != null )
				objThisData.strAllGroupNames = rstResultSet.getString("group_name").trim();
			else
				objThisData.strAllGroupNames = new String("");
			objThisData.vGroupId.addElement(objThisData.strAllGroupIds);
			objThisData.vGroupName.addElement(objThisData.strAllGroupNames);
		}
		
		objThisData.strGroupId    = "";
 		objThisData.strGroupName  = "";
		objThisData.strRemark     = "";
		objThisData.strUpdateId   = "";
		objThisData.strCreateDate = "";
		
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":selectDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDb()","Exit with status false");
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
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the user_id is '"+objThisData.strGroupId+"'");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstUser = stmInquiry.executeQuery(strInquirySql);
		if( !rstUser.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strGroupId+"' does not exist in the database");
			bReturnStatus = false;
		}
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strGroupId+"' exists in the database");
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

%>
<%
	//the main program begins...
	//Server�ݵ{���Ѧ������}�l
	//���{���D�n���ܼ�
	boolean bCallBySelf = false;						//�O�_���ۦ�I�s
	String strClientMsg = new String("");				//�Ǧ^��Client���T��
	boolean bReturnStatus = true;						//�U��ư��椧���G
	
	//R00393   Edit by Leo Huang (EASONTECH) Start
	//CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());

	//java.util.Date dteToday = cldCalendar.getTime();		//�ثe����ɶ�

	//DataClass objThisData = new DataClass(siThisSessionInfo);	//���{���D�n�U�����
	
	DataClass objThisData = new DataClass(siThisSessionInfo);	//���{���D�n�U�����
	if(commonUtil==null){
		commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
		cldCalendar = commonUtil.getBizDateByRCalendar();
	}
	
	//R00393  Edit by Leo Huang (EASONTECH) End
	HttpSession userSession = request.getSession(false);
	objThisData.szSysFlag = (String)userSession.getAttribute("SYSTEM_FLAG");

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
%>
<%
	//�����o��Ʈw�s�u
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	//�ˬd�O�_�����{���ۦ�I�s
	if( request.getParameter("txtThisProgId") != null )
	{	
		if(request.getParameter("txtThisProgId").equalsIgnoreCase(strThisProgId))
			bCallBySelf = true;
	}

	/* 
		�Y�O�ۦ�I�s,�h�n���ӥ\��B�z���
		1.��request���󤤱Nclient�Ǧ^����Ƹ��J�{��
		2.�ˮָ�ƥ��T��,�Y���o�{������~,�h�N���~�T����JstrClientMsg��
		3.����A,U,D,I���\��O,�i���Ʈw��s
	*/
	if( bCallBySelf )
	{
		if( !getInputParameter(request,objThisData) )
		{
			strClientMsg = siThisSessionInfo.getLastErrorMessage();
		}
		else
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Client request function is '"+objThisData.strActionCode+"'");
			//�Y�O�s�W�ʧ@��,���ˮ֦U�欰�O�_��J���T,�Y���T,�h�g��Ʈw
			if( objThisData.strActionCode.equalsIgnoreCase("A") )	//�s�W
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
						try
						{
							strClientMsg = "'"+objThisData.strGroupId+"'�s�W����";
						}
						catch( Exception e )
						{
						}
					}
				}
			}
			//�Y�O�ק�ʧ@��,���ˮ֦U�欰�O�_��J���T,�Y���T,�h�g��Ʈw
			if( objThisData.strActionCode.equalsIgnoreCase("U"))	//�ק�
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
						try
						{
							strClientMsg = "'"+objThisData.strGroupId+"'�ק粒��";
						}
						catch( Exception e )
						{
						}
					}
				}
			}
			else if( objThisData.strActionCode.equalsIgnoreCase("D") )	//�R��
			{
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing delete function");
				if( !deleteDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				else
				{
						try
						{
							strClientMsg = "'"+objThisData.strGroupId+"'�R������";
						}
						catch( Exception e )
						{
						}
				}
			}
			else if( objThisData.strActionCode.equalsIgnoreCase("I") )	//�d��
			{
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing inquiry function");
				if( !inquiryDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
			}
			else if( objThisData.strActionCode.equalsIgnoreCase("L") )	//For the reports
			{
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing report function");
				if( !selectDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				/*else
				{
						try
						{
							strClientMsg = "'"+objThisData.strGroupId+"'�R������";
						}
						catch( Exception e )
						{
						}
				}*/
			}

		}
	}

	

%>
<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>�s�ո�ƺ��@</TITLE>
<SCRIPT language="JavaScript" >
var strErrMsg = "";				//Batch�ˬd�����~�T��,���ܼƥi���Ʀs�b

/**
��ƦW��:	OnLoad( String strTitle, String strProgId, strThisFunctionKey )
��ƥ\��:	��Client�ݵe���Ұʮ�,���楻���.
		1.���btitle frame��ܵ{���N���ε{���W��,�{���N���ε{���W�٭n�b<BODY>tag���ק�
		2.�YtxtClientMsg��줣���ťծ�, ��ܦ����~�T��,�ϥ�alert()��ܥ�
		3.�btoolbar frame��ܥ\����
�ǤJ�Ѽ�:	String strTitle: �{���W��,�m��title frame������,�o���ܼƬO�ϥΥ�������
					document.title,���ק糧jsp��<TITLE>tag
		String strProgId:	�{���N��,�m��title frame������.�ܼƨӷ���jsp��strThisProgId.
		String strThisFunctionKey: �n��ܪ��\����N��,A:�s�W,U:�ק�,D:�R��,I:�d��,E:���},R:�M��
		String strFirstField: ��J���Ĥ@�����
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
var oToolBar = "";
var oTitle = "";
var iToolBar = 0;
var iTitle = 0;
var iInterval = "";
function OnLoad(strTitle,strProgId,strThisFunctionKey,strFirstField)
{
	var i,j;
	if( window.parent.frames.length != 0 )
	{
		i = 0;
		while( i < window.parent.frames.length )
		{
			var winTarget = window.parent.frames[i];
			if( winTarget.name == 'title' )
			{
				iTitle = i;
				oTitle = window.setInterval("checkTitleWindowState('"+strTitle+"','"+strProgId+"')",100);
			}
			if( winTarget.name == 'toolbar' )
			{
				iToolBar = i;
				oToolBar = window.setInterval("checkToolBarWindowState('"+strThisFunctionKey+"')",100);
			}
			i++;
		} 
	}
	if( document.getElementById("txtClientMsg") != null )
		if( document.getElementById("txtClientMsg").value != "" )
			alert( document.getElementById("txtClientMsg").value );
	if( document.getElementById(strFirstField) != null )
		document.getElementById(strFirstField).focus();
			
}

function checkTitleWindowState(strTitle,strProgId)
{
	var winTarget = window.parent.frames[iTitle];
	if( winTarget.document.getElementById("MainBody") != null )
	{
		var strCommand = "ShowTitle('"+strTitle+"','"+strProgId+"')";
		winTarget.iInterval = winTarget.setInterval(strCommand,1);
		if( oTitle != "" )
		{
			window.clearInterval(oTitle);
			oTitle = "";
		}
	}
}

function checkToolBarWindowState(strThisFunctionKey)
{
	var winTarget = window.parent.frames[iToolBar];
	if( winTarget.document.getElementById("MainForm") != null )
	{
		var strCommand = "ShowButton('"+strThisFunctionKey+"')";
		winTarget.iInterval = winTarget.setInterval(strCommand,1);
		if( oToolBar != "")
		{
			window.clearInterval(oToolBar);
			oToolBar = "";
		}
	}
}

/**
��ƦW��:	ToolBarClick( String strButtonTag )
��ƥ\��:	��toolbar frame�����@���sclick��,�N�|���楻���.����楻��Ʈɷ|�ǤJ�@�Ӧr��,
		�Ӧr��N��toolbar frame�����@�ӫ��s�Qclick
		��s�W,�ק���s��,�������������ˬd,�Y�����@�����~��,
		�N��ܥ������~�T��,�Y���T�ɫh�NbntAction�]�w���ǤJ���Ѽƭ�,
		�ð���MainForm.submit(),�N��J�����ǰe��web server
		�Y���d�ߤΧR����,���ˬd��ȬO�_���T,�Y���T,�h�NbntAction�]�w���ǤJ���Ѽƭ�,
		�ð���MainForm.submit(),�N��J�����ǰe��web server
		�Y���M����,�h�N�U���M��.
�ǤJ�Ѽ�:	String strButtonTag: 	A:�s�W���s
						U:�ק���s
						D:�R�����s
						I:�d�߫��s
						R:�M�����s
						L:Reports
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function ToolBarOnClick(strButtonTag)
{
	if( iInterval != "" )
	{
		window.clearInterval(iInterval);
		iInterval = "";
	}

	if( strButtonTag == "A" )			//�s�W�s
	{
		document.getElementById("btnAction").value = "A";
		if( areAllFieldsOK() )
			document.getElementById("MainForm").submit();
		else
			alert(strErrMsg);
	}
	else if( strButtonTag == "U" )		//�ק�s
	{
		document.getElementById("btnAction").value = "U";
		if( areAllFieldsOK() )
			document.getElementById("MainForm").submit();
		else
			alert(strErrMsg);
	}
	else if( strButtonTag == "D" )		//�R���s
	{
		var bAnswer = confirm("�O�_�T�w�n�R���ӵ����?");
		if( bAnswer )
		{
			document.getElementById("btnAction").value = "D";
			if( checkFieldsClient( document.getElementById("txtGroupId"),true ) )
				document.getElementById("MainForm").submit();
		}
	}
	else if( strButtonTag == "I" )		//�d�߶s
	{
		document.getElementById("btnAction").value = "I";
		if( checkFieldsClient( document.getElementById("txtGroupId"),true ) )
			document.getElementById("MainForm").submit();
	}
	else if( strButtonTag == "E" )		//���}�s
	{
		document.getElementById("btnAction").value = "E";
	}
	else if( strButtonTag == "L" )		//���}�s
	{
		document.getElementById("btnAction").value = "L";
		document.getElementById("MainForm").submit();
	}
	else if( strButtonTag == "R" )		//�M���s
	{//�L�k�����ϥ�forms.reset()
		if( document.getElementById("MainForm") != null )
		{
			var j=0;
			if( document.getElementsByTagName("INPUT") != null )
			{
				var k=0;
				var coll = document.getElementsByTagName("INPUT");
				for(k=0;k<coll.length;k++)
				{//�ȱNtext��password�����M��
					if( coll[k].type == "text" || coll[k].type == "password")
						coll[k].value = "";
				}
			}
		}
	}
	else
	{//�Y�����B�z�����s��,��ܿ��~�T��
		alert("The button flag = '"+strButtonTag+"' unhandled");
	}
}


/**
��ƦW��:	areAllFieldsOk()
��ƥ\��:	�I�scheckFieldsClient()�ˮ֩Ҧ����O�_��J���T
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function areAllFieldsOK()
{
	var i=0;
	var bReturnStatus = true;
	strErrMsg = "";
	if( document.getElementsByTagName("INPUT") != null )
	{
		var k=0;
		var coll = document.getElementsByTagName("INPUT");
		for(k=0;k<coll.length;k++)
		{
			if( !checkFieldsClient(coll[k],false) )
			{
				bReturnStatus = false;
			}
		}
	}
	return bReturnStatus;
}

</SCRIPT>
<SCRIPT language=JavaScript >
var strFunctionKey="AUDIRL";		//toolbar frame ���n��ܪ��\����,�|���ӱƦC���ǥX�{
							//A:�s�W,U:�ק�,D:�R��,I:�d��,E:���},R:�M��
/**
��ƦW��:	checkFieldsClient(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
		bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function checkFieldsClient(objThisItem,bShowMsg)
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtGroupId" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "�п�J�s�եN��";
			//strTmpMsg   = "Hello ! Please fill the Group Id ";
			bReturnStatus = false;
		}
	}
	else if( objThisItem.name == "txtGroupName" )
	{
		if( objThisItem.value.length < 1)
		{
			strTmpMsg = "�п�J�s�զW��";
			//strTmpMsg = "Hello ! Please fill the Group Name ";
			bReturnStatus = false;
		}
	}
	/*else if( objThisItem.name == "txtRemark" )
	{
		if( objThisItem.value == "" )
		{
			//strTmpMsg = "�п�J�M�׻���";
			strTmpMsg   = "Hello ! Please fill the Remark ";
			bReturnStatus = false;
		}
	}*/
	/*else if( objThisItem.name == "txtUpdateId" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "�п�J�M�׻����������}";
			bReturnStatus = false;
		}
		
	}*/
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
</SCRIPT>
</HEAD>
<BODY style="margin:0px" onload="OnLoad(document.title,'<%=strThisProgId%>',strFunctionKey,'txtProgramId')">
<FORM id="MainForm" name="MainForm" action="GroupMaintain.jsp">
<CENTER>
<TABLE border="1" width="600" height="100">
    <TBODY>
        <TR>
            <TD width="150">�s�եN���G</TD>
            <TD width="450" colspan="3"><FONT><INPUT size="10" type="text" maxlength="10" name="txtGroupId" id="txtGroupId" value="<%=objThisData.strGroupId%>" onchange="checkFieldsClient(this,true);"></FONT></TD>
            </TR>
        <TR>
            <TD width="150">�s�զW�١G</TD>
      <TD width="450" colspan="3"><INPUT size="30" type="text" maxlength="20" name="txtGroupName" value="<%=objThisData.strGroupName%>" onchange="checkFieldsClient(this,true);"></TD>
    </TR>
        <TR>
            <TD width="150">�Ƶ��G</TD>
            <TD width="450" colspan="3"><INPUT size="60" type="text" maxlength="50" name="txtRemark" value="<%=objThisData.strRemark%>" onblur="checkFieldsClient(this,true);"></TD>
        </TR>
        <TR>
            <TD width="150">�ק�̥N�� �G</TD>
            <TD width="150"><INPUT size="10" type="text" maxlength="10" name="txtUpdateId" value="<%=objThisData.strUpdateId%>" onblur="checkFieldsClient(this,true);" readonly></TD>
		<TD width="150">��Ƨ�s����G</TD>
            <TD width="150"><INPUT size="10" type="text" maxlength="10" name="txtCreateDate" value="<%=commonUtil.convertWesten2ROCDate(objThisData.dteStartDate)%>" onblur="checkFieldsClient(this,true);" readonly></TD>

        </TR>
       
     </TBODY>
</TABLE>
<br>
<table border="0" align="middle" cellPadding="0" cellSpacing="0" height="20" width="580">    
  <tbody>    
    <tr>    
       <td align="middle" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" width="120">    
        <div align="left">    
          <strong>    
          <font color="#000000" face="MingLiu" size="2">&nbsp;</font><font color="#000000" size="2">�s�եN��</font>    
          </strong>    
        </div>    
      </td>    
      <td align="left" bgColor="#c0c0c0" colSpan="2" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="130"><b><font color="#000000" size="2">�s�զW��</font></b></td>    
      <td bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="100">&nbsp;</td>    
      <td align="right" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="80">&nbsp;</td>    
      <td align="right" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid" width="120">&nbsp;</td>    
    </tr>    
  </tbody>    
</table>
&nbsp;<textarea rows="10" name="S1" cols="80" readonly>
<%
	for(int i=0;i<objThisData.vGroupId.size();i++)
	{
		out.println(objThisData.vGroupId.elementAt(i)+"        "+objThisData.vGroupName.elementAt(i));		
       }
%>
</textarea>
</CENTER>
<INPUT name="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
<INPUT name="btnAction" id="btnAction" type="hidden" value="<%=objThisData.strActionCode%>">
<INPUT name="txtClientMsg"  type="hidden" value="<%= strClientMsg %>">
<INPUT name="txtDebug"  type="hidden" value="0">
</FORM>
</BODY>
</HTML>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>
