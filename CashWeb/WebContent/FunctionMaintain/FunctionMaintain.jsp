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
		NsSessionInfo siThisSessionInfo
		NsUserInfo    uiThisUserInfo
-->
<%!

	String strThisProgId = new String("FunctionMaintain");		//���{���N��
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
	SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	public final String DEFAULT_GROUP = "select default group";
	class DataClass extends Object 
	{
		public String strFuncId    = new String("");
		public String strFuncName  = new String("");
		public String strColorName = new String("");
		public String strRemark    = new String("");
		public String strProperty  = new String("P");	
		public String strUrl       = new String("");				
		public String strTargetWindow = new String("arena");	
		public String strMenuOn    = new String("");	
		public String strMenuOff   = new String("");	
		public String strTopBar    = new String("");	
		public String strTopBarExt = new String("");	
		public String strSwoosh    = new String("");
		public Vector vFuncId      = new Vector();
		public Vector vFunction    = new Vector();
		public String strDefaultGroup = new String("");			
		public SessionInfo siThisSessionInfo = null;	
		public String strActionCode= new String("");	
				
		//��Ʈw�s���ܼ�
		public Connection conDb = null;					//db_basic��jdbc connection
		
		//constructor
		public DataClass(SessionInfo siSessionInfo)
		{
			super();
			siThisSessionInfo = siSessionInfo;
			siSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":DataClass()","Constructor normal exit");
		}

		//destructor
		public void finalize()
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":finalize()","Destructor enter");
			releaseConnection();
		}

		//�� NsDbFactory �����o�@�� Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//�����o��Ʈw�s���ηǳ�SQL
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("FunctionMaintain.DataClass.getConnection()");
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
			strReturn = "insert into db_eservice..tfunction (func_id,func_name,image_file_on,"+
			"image_file_off,top_bar,top_bar_extend,swoosh,property,url,remark,target_window) values ('";
			strReturn = strReturn + strFuncId + "','" ;
			strReturn = strReturn + strFuncName + "','" ;
			strReturn = strReturn + strMenuOn + "','" ;
			strReturn = strReturn + strMenuOff + "','" ;
			strReturn = strReturn + strTopBar + "','" ;
			strReturn = strReturn + strTopBarExt + "','" ;
			strReturn = strReturn + strSwoosh + "','" ;
			strReturn = strReturn + strProperty + "','" ;
			strReturn = strReturn + strUrl + "','" ;
			strReturn = strReturn + strRemark + "','" ;
			strReturn = strReturn + strTargetWindow + "')" ;
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInsertSql()","The insert sql is '"+strReturn+"'");
			return strReturn;
		}

		//���o���{���� Update SQL
		public String getUpdateSql()
		{	
			String strReturn = new  String("");
			strReturn = "update db_eservice..tfunction set ";
			strReturn = strReturn + " func_id = '"+strFuncId + "'," ;
			strReturn = strReturn + " func_name = '"+strFuncName + "'," ;
			strReturn = strReturn + " image_file_on = '"+strMenuOn + "'," ;
			strReturn = strReturn + " image_file_off = '"+strMenuOff + "'," ;
			strReturn = strReturn + " top_bar = '"+strTopBar + "'," ;
			strReturn = strReturn + " top_bar_extend = '"+strTopBarExt + "'," ;
			strReturn = strReturn + " swoosh = '"+strSwoosh + "'," ;
			strReturn = strReturn + " property = '"+strProperty + "'," ;
			strReturn = strReturn + " url = '"+strUrl + "'," ;
			strReturn = strReturn + " remark = '"+strRemark + "'," ;
			strReturn = strReturn + " target_window = '"+strTargetWindow + "' " ;
			strReturn = strReturn + " where func_id = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getUpdateSql()","The update sql is '"+strReturn+"'");
			return strReturn;
		}

		//���o���{���� Delete SQL
		public String getDeleteSql()
		{	
			String strReturn = new  String("");
			strReturn = "delete db_eservice..tfunction where func_id = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}


		//���o���{���� Inquiry SQL
		public String getInquirySql()
		{	
			String strReturn = new  String("");
			strReturn = "select a.func_id, a.func_name, a.property, a.target_window, a.url, a.remark, b.color_name"+
				     " from db_eservice..tfunction a, db_eservice..tmenu_color b  where a.func_id = '"+strFuncId+"'"+
				     "	and a.image_file_on*=b.menuitem_on"; 
			//strReturn = "select * from db_eservice..tfunction where func_id = '"+strFuncId+"'";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}
		
		// Report SQL
		public String getReportSql()
		{
			String strReturn = new String("");
			strReturn = "select func_id, func_name,property,target_window from db_eservice..tfunction ";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getReportSql()","The Report1 sql is '"+strReturn+"'");
			return strReturn;
		}
		
		//tmenu_color details
		public String getColorDetailsSql()
		{
			String strReturn = new String();
			strReturn = "select * from db_eservice..tmenu_color where color_name = '"+strColorName+"' ";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getColorDetailsSql()","The Report1 sql is '"+strReturn+"'");
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
	if( objThisData.strFuncId.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","Please enter the function id");
		bReturnStatus = false;
	}

	if( objThisData.strUrl.equals("") )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","�п�J URL ���e");
		bReturnStatus = false;
	}

	/*try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery("select group_id from db_eservice..tgroup where group_id = '"+objThisData.strDefaultGroup+"'");
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
			
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
	//���oClient�ݤ����,�s�JDataClass��
	//�����Nclient�ݤ��\������o
	objThisData.strActionCode = req.getParameter("btnAction");
	if( objThisData.strActionCode == null )
		objThisData.strActionCode = "";	

	objThisData.strFuncId = req.getParameter("txtFuncId");
	if( objThisData.strFuncId == null )
		objThisData.strFuncId = "";	

	objThisData.strFuncName = req.getParameter("txtFuncName");
	if( objThisData.strFuncName == null )
		objThisData.strFuncName = "";
	//������쥲���ϥ�getBytes("Big5")�~�|���T,�_�h�|�ܦ��ýX
	try
	{	
		objThisData.strFuncName = new String( objThisData.strFuncName.getBytes("Big5") );
	}
	catch( Exception e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
	}

	objThisData.strColorName = req.getParameter("cmbColorName");
	if( objThisData.strColorName == null )
		objThisData.strColorName = "";	

	objThisData.strProperty = req.getParameter("radProperty");
	if( objThisData.strProperty == null )
		objThisData.strProperty = "";
	else{
		if(objThisData.strProperty.equals("M"))
			objThisData.strColorName = "deepblue_m";
	}	
	objThisData.strUrl = req.getParameter("txtUrl");
	if( objThisData.strUrl == null )
		objThisData.strUrl = "";	

	objThisData.strTargetWindow = req.getParameter("cmbTargetWindow");
	if( objThisData.strTargetWindow == null )
		objThisData.strTargetWindow = "";	

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
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","�ϥΪ̥N�� '"+objThisData.strFuncId+"' �w�s�b���Ʈw��");
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
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":updateDb()","�ϥΪ̥N�� '"+objThisData.strFuncId+"' ���s�b���Ʈw��");
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
			if( rstResultSet.getString("func_id") != null )
				objThisData.strFuncId = rstResultSet.getString("func_id").trim();
			else
				objThisData.strFuncId = new String("");
			if( rstResultSet.getString("func_name") != null )
				objThisData.strFuncName = rstResultSet.getString("func_name").trim();
			else
				objThisData.strFuncName = new String("");
			if( rstResultSet.getString("remark") != null )
				objThisData.strRemark = rstResultSet.getString("remark").trim();
			else
				objThisData.strRemark = new String("");
			if( rstResultSet.getString("property") != null)
				objThisData.strProperty = rstResultSet.getString("property").trim();
			else
				objThisData.strProperty = new String("");
			if( rstResultSet.getString("url") != null )
				objThisData.strUrl = rstResultSet.getString("url");
			else
				objThisData.strUrl = new String("");
			if( rstResultSet.getString("color_name") != null )
				objThisData.strColorName = rstResultSet.getString("color_name");
			else
				objThisData.strColorName = new String("");
			if( rstResultSet.getString("target_window") != null )
				objThisData.strTargetWindow = rstResultSet.getString("target_window");
			else
				objThisData.strTargetWindow = new String("");

		}
		else
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","�ϥΪ̥N�� '"+objThisData.strFuncId+"' ���s�b���Ʈw��");
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
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()","�ϥΪ̥N�� '"+objThisData.strFuncId+"' ���s�b���Ʈw��");
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
			if( rstResultSet.getString("func_id") != null )
				objThisData.vFuncId.addElement(rstResultSet.getString("func_id").trim());
			else
				objThisData.vFuncId.addElement("");
			if( rstResultSet.getString("func_name") != null )
				objThisData.vFuncId.addElement(rstResultSet.getString("func_name").trim());
			else
				objThisData.vFuncId.addElement("");

			if( rstResultSet.getString("property") != null )
				objThisData.vFuncId.addElement(rstResultSet.getString("property").trim());
			else
				objThisData.vFuncId.addElement("");

			if( rstResultSet.getString("target_window") != null )
				objThisData.vFuncId.addElement(rstResultSet.getString("target_window").trim());
			else
				objThisData.vFuncId.addElement("");

			objThisData.vFunction.addElement(objThisData.vFuncId);
			objThisData.vFuncId = new Vector();
		}
		objThisData.strFuncId    = "";
 		objThisData.strFuncName  = "";
		objThisData.strColorName = "";
		objThisData.strUrl       = "";
		objThisData.strRemark    = "";
		objThisData.strTargetWindow = "";
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

//to get the top bar,swoosh,menu item details corresponding to the color selected by the user.

public boolean selectDbColorDetails(DataClass objThisData )
{
	boolean bReturnStatus = true;
	Statement stmInquiry = null;		
	String strSelectSql = new String("");	
	ResultSet rstResultSet = null;		
	int iReturn = 0;
		
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDbColorDetails()","Enter");
	try
	{
		strSelectSql = objThisData.getColorDetailsSql();
		stmInquiry = objThisData.conDb.createStatement();
		rstResultSet = stmInquiry.executeQuery(strSelectSql);
		while(rstResultSet.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDbColorDetails()","Fetched records successfully");
			if( rstResultSet.getString("menuitem_on") != null )
				objThisData.strMenuOn = rstResultSet.getString("menuitem_on").trim();
			else
				objThisData.strMenuOn = new String("");
			if( rstResultSet.getString("menuitem_off") != null )
				objThisData.strMenuOff = rstResultSet.getString("menuitem_off").trim();
			else
				objThisData.strMenuOff = new String("");

			if( rstResultSet.getString("top_bar") != null )
				objThisData.strTopBar = rstResultSet.getString("top_bar").trim();
			else
				objThisData.strTopBar = new String("");

			if( rstResultSet.getString("top_bar_extend") != null )
				objThisData.strTopBarExt = rstResultSet.getString("top_bar_extend").trim();
			else
				objThisData.strTopBarExt = new String("");

			if( rstResultSet.getString("swoosh_bar") != null )
				objThisData.strSwoosh = rstResultSet.getString("swoosh_bar").trim();
			else
				objThisData.strSwoosh = new String("");
		}
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":selectDbColorDetails()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDbColorDetails()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":selectDbColorDetails()","Exit with status false");
	return bReturnStatus;
}

//for displaying the available colors to the user

public String getColorList(DataClass objThisData )
{
	String strReturnHtml = new String("<SELECT name=\"cmbColorName\" id=\"cmbColorName\" size=\"1\"><OPTION value=\"\"></OPTION>\r\n");					// return html string
	Statement stmStatement = null;				//temperory statement
	ResultSet rstResultSet = null;				//temperory Resultset
	String strSql = new String("select distinct color_name from db_eservice..tmenu_color ");

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SelectInput.jsp:getColorList()","Enter the sql = '"+strSql+"'");
	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery(strSql);
		while( rstResultSet.next() )
		{
			if(rstResultSet.getString("color_name") != null )
			{
				strReturnHtml += "<OPTION value=\""+rstResultSet.getString("color_name")+"\"";
				if( rstResultSet.getString("color_name").trim().equals(objThisData.strColorName.trim()) )
					strReturnHtml += " selected ";
				strReturnHtml += ">"+rstResultSet.getString("color_name")+" </OPTION>\r\n";
			}
		}
		strReturnHtml += "</SELECT>";
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getColorList()",e);
	}
//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SelectInput.jsp:getColorList()","The actual return html = '"+strReturnHtml+"'");
	return strReturnHtml;
}

//for displaying the available target windows to the user

public String getTargetWindowList(DataClass objThisData )
{
	String strReturnHtml = new String("<SELECT name=\"cmbTargetWindow\" id=\"cmbTargetWindow\" size=\"1\"><OPTION value=\"\"></OPTION>\r\n");					// return html string
	Statement stmStatement = null;				//temperory statement
	ResultSet rstResultSet = null;				//temperory Resultset
	String strSql = new String("select distinct target_window from db_eservice..tfunction ");

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SelectInput.jsp:getTargetWindowList()","Enter the sql = '"+strSql+"'");
	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery(strSql);
		while( rstResultSet.next() )
		{
			if(rstResultSet.getString("target_window") != null )
			{
				strReturnHtml += "<OPTION value=\""+rstResultSet.getString("target_window")+"\"";
				if( rstResultSet.getString("target_window").trim().equals(objThisData.strTargetWindow.trim()) )
					strReturnHtml += " selected ";
				strReturnHtml += ">"+rstResultSet.getString("target_window")+" </OPTION>\r\n";
			}
		}
		strReturnHtml += "</SELECT>";
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getTargetWindowList()",e);
	}
//	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"SelectInput.jsp:getTargetWindowList()","The actual return html = '"+strReturnHtml+"'");
	return strReturnHtml;
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
	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the user_id is '"+objThisData.strFuncId+"'");
	try
	{
		strInquirySql = objThisData.getInquirySql();
		stmInquiry = objThisData.conDb.createStatement();
		rstUser = stmInquiry.executeQuery(strInquirySql);
		if( !rstUser.next() )
		{
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strFuncId+"' does not exist in the database");
			bReturnStatus = false;
		}
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strFuncId+"' exists in the database");
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
	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();		//�ثe����ɶ�
     //R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass(siThisSessionInfo);	//���{���D�n�U�����

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
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
					if(!selectDbColorDetails(objThisData ))
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
							strClientMsg = "'"+objThisData.strFuncId+"'�s�W����";
						}
						catch( Exception e )
						{
						}
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
					if(!selectDbColorDetails(objThisData ))
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
							strClientMsg = "'"+objThisData.strFuncId+"'�ק粒��";
						}
						catch( Exception e )
						{
						}
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
							strClientMsg = "'"+objThisData.strFuncId+"'�R������";
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
							strClientMsg = "'"+objThisData.strFuncId+"'�R������";
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
<TITLE>�\�����ɺ��@</TITLE>
<SCRIPT language="JavaScript" >
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

var strErrMsg = "";	
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
						L: Reports
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
		{
			alert(strErrMsg);
		}
			
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
			if( checkFieldsClient( document.getElementById("txtFuncId"),true ) )
				document.getElementById("MainForm").submit();
		}
	}
	else if( strButtonTag == "I" )		//�d�߶s
	{
		document.getElementById("btnAction").value = "I";
		document.getElementById("txtThisProgId").value = "COMTFunctionMaintain";
		if( checkFieldsClient( document.getElementById("txtFuncId"),true ) )
			{
				document.getElementById("MainForm").submit();
			}
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
	if( document.getElementsByTagName("SELECT") != null)
	{
		var m=0;
		var collm = document.getElementsByTagName("SELECT");
		for(m=0;m<collm.length;m++)
		{
			if( !checkCombo(collm[m],false) )
			{
				bReturnStatus = false;
			}
		}
	}
	return bReturnStatus;
}

function checkCombo(objThisItem,bShowMsg)
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	//objThisItem.value = objThisItem.options[objThisItem.selectedIndex].value;
		
	if(objThisItem.name == "cmbTargetWindow" )
	{
		if(objThisItem.value == "")
		{
			//strTmpMsg   = "Hello ! Please select a target window ";
			strTmpMsg   = "�п�J TARGET WINDOW";
			bReturnStatus = false;
		}
	}
	if(objThisItem.name == "cmbColorName" )
	{
		if(objThisItem.value == "")
		{
			//strTmpMsg   = "Hello ! Please select a color ";
			strTmpMsg   = "�п�J��t";
			bReturnStatus = false;
		}
	}
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
	if( objThisItem.name == "txtFuncId" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "�п�J�\��N��";
			//strTmpMsg   = "Hello ! Please fill the Func Id ";
			bReturnStatus = false;
		}
	}
	else if( objThisItem.name == "txtFuncName" )
	{
		if( objThisItem.value == "")
		{
			strTmpMsg = "�п�J�\��W��";
			//strTmpMsg = "Hello ! please fill the Func Name ";
			bReturnStatus = false;
		}
	}
	else if( objThisItem.name == "txtUrl" )
	{
		//if(document.getElementById("radProperty").value != "M")
		//{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "�п�J URL ���e";
				bReturnStatus = false;
			}
		//}			
	}
	
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
function disablecolor()
{
	document.getElementById("radProperty").value = "M";
	document.getElementById("cmbColorName").value = "deepblue_m";
	document.getElementById("cmbColorName").disabled = true;	
	//document.getElementById("cmbTargetWindow").disabled = true;
	//document.getElementById("txtUrl").value = "";
	//document.getElementById("txtUrl").disabled = true;
}
function enablecolor()
{	
	document.getElementById("cmbColorName").disabled = false;
	document.getElementById("cmbTargetWindow").disabled = false;	
	document.getElementById("txtUrl").disabled = false;
}
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" VI6.0THEME="Global Marketing">
</HEAD>
<BODY style="margin:0px" onload="OnLoad(document.title,'<%=strThisProgId%>',strFunctionKey,'txtProgramId')">
<FORM id="MainForm" name="MainForm" method="post" action="FunctionMaintain.jsp">
<CENTER>
 <table border="1" width="600">   
    <tbody>   
      <tr>   
        <td width="150" ><b>�\��N���G</b></td>    
        <td width="450" colspan="3"><input maxLength="20" type="text" name="txtFuncId" id="txtFuncId" value="<%=objThisData.strFuncId%>" onchange="checkFieldsClient(this,true);" size="20">    
        </td>    
      </tr>    
      <tr>    
        <td width="150" ><b>�\��W�١G</b></td>    
        <td width="450" colspan="3"><input maxLength="20" type="text" name="txtFuncName" id="txtFuncName" value="<%=objThisData.strFuncName%>" onchange="checkFieldsClient(this,true);" size="20">
	</td>    
      </tr>    
      <tr>  
        <td width="150" ><b>�ݩʡG</b></td>   
        <td width="150" ><input  id="radProperty" name="radProperty" <%if( objThisData.strProperty.equalsIgnoreCase("P") ) out.print("checked");%> onblur="checkFieldsClient(this,true);" type="radio" value="P" onclick="enablecolor();">Program   
          <input id="radProperty" name="radProperty" <%if( objThisData.strProperty.equalsIgnoreCase("M") ) out.print("checked");%> onblur="checkFieldsClient(this,true);" type="radio" value="M" onclick="disablecolor();">Menu</td>      
        <td width="150" ><b>Target Window:</b></td>     
        <td width="150" ><%=getTargetWindowList(objThisData)%></td>     
      </tr>     
      <tr>     
        <td width="150" ><b>Url:</b></td>      
        <td width="450"  colspan="3"><input maxLength="255" type="text" id="txtUrl" name="txtUrl" value="<%=objThisData.strUrl%>" onchange="checkFieldsClient(this,true);" size="70" >        
        </td>      
      </tr>     
      <tr>     
        <td width="150" ><b>�Ƶ��G</b></td>     
        <td width="450" colspan="3"><input maxLength="70" type="text" id="txtRemark" name="txtRemark" value="<%=objThisData.strRemark%>" onblur="checkFieldsClient(this,true);" size="70" >       
        </td>     
      </tr>    
    </tbody>    
  </table>    
<table border="0" cellPadding="0" cellSpacing="0" width="580">   
  <tbody>   
    <tr>   
        <td align="middle" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" width="120">   
        <div align="left">   
          <strong><font color="#000000" face="MingLiu" size="2">&nbsp;</font><font color="#000000" size="2">�\��N��</font><font color="#000000" face="MingLiu" size="2">&nbsp;&nbsp;</font></strong>   
        </div>   
      </td>   
      <td align="left" bgColor="#c0c0c0" colSpan="2" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="130"><b><font color="#000000" face="MingLiu" size="2">&nbsp;&nbsp;&nbsp;  
        </font><font color="#000000" size="2">�\��W��</font><font color="#000000" face="MingLiu" size="2">&nbsp;</font></b></td>   
      <td bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="100"><b><font size="2">&nbsp;&nbsp;    
        �ݩ�</font></b></td>    
      <td align="right" bgColor="#c0c0c0" height="20" style="BORDER-BOTTOM: black 1px solid; BORDER-TOP: black 1px solid" width="120"><b><font size="2">Target Window</font></b></td>    
      <td align="right" bgColor="#c0c0c0" height="20" style="border-right: 1px solid black; border-top: 1px solid black; border-bottom: 1px solid black" width="50">&nbsp;</td> 
    </tr> 
  </tbody> 
</table> 
&nbsp;<textarea rows="10" name="S1" cols="80" readonly>
<%
	for(int i=0;i<objThisData.vFunction.size();i++)
	{	
		objThisData.vFuncId = (Vector)objThisData.vFunction.elementAt(i);
		out.println(objThisData.vFuncId.elementAt(0)+"     "+objThisData.vFuncId.elementAt(1)+"              "+objThisData.vFuncId.elementAt(2)+"             "+objThisData.vFuncId.elementAt(3));		
       }
%>
</textarea>
</CENTER>
<INPUT name="txtThisProgId" id="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
<INPUT name="btnAction"  id="btnAction" type="hidden" value="<%=objThisData.strActionCode%>">
<INPUT name="txtClientMsg"  type="hidden" value="<%= strClientMsg %>">
<INPUT name="txtDebug"  type="hidden" value="0">
</FORM>
</BODY>
</HTML>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>
