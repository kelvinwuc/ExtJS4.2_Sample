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

	String strThisProgId = new String("GroupUser");		//���{���N��
	public final String DEFAULT_GROUP = "select default group";
	class DataClass extends Object 
	{
		public String strGroupId = new String("");
		public String strUserId = new String("");
		public String strSeqNo  = new String("");
		public String strSystemFlag=new String("");
		public String strDefaultGroup = new String("");	
		public String strCallingUrl = new String("");	
		public String strAllGroupIds = new String("");	
		public SessionInfo siThisSessionInfo = null;	
		public String strActionCode = new String("");	
		public Vector vGroupIds = new Vector();
		//��Ʈw�s���ܼ�
	
		public Connection conDb = null;					//jdbc connection
		public String szSysFlag = new String("");
		
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
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("GroupUser.DataClass.getConnection()");
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

		// Delete SQL
		public String getDeleteSql()
		{	
			String strReturn = new  String("");
			strReturn = "delete tgroup_user where user_id = '"+strUserId+"'" ;
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getDeleteSql()","The delete sql is '"+strReturn+"'");
			return strReturn;
		}
	
	}

%>
<%!
/**
��ƦW��:	getInputParameter( HttpServletRequest req, DataCalss objThisData ) 
��ƥ\��:	�NClient�ݶǤJ���U���Ȧs�JobjThisData��
�ǤJ�Ѽ�:	HttpServletRequest req: Client�ǤJ�� request object
		DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	�Y�����@�����~,�Ǧ^false,�_�h�Ǧ^true
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public boolean getInputParameter(HttpServletRequest req,DataClass objThisData,HttpSession userSession)
{
	boolean bReturnStatus = true;
	CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
		
	objThisData.strActionCode = req.getParameter("btnAction");
	if( objThisData.strActionCode == null )
		objThisData.strActionCode = "";	

	objThisData.strUserId = req.getParameter("txtUserId");
	if( objThisData.strUserId == null )
	{
		objThisData.strUserId = (String)userSession.getAttribute("TheUserId");
		if( objThisData.strUserId == null )
			objThisData.strUserId = "";	
	}

	objThisData.strGroupId = req.getParameter("txtGroupId");
	if( objThisData.strGroupId == null )
		objThisData.strGroupId = "";	

	objThisData.strCallingUrl = req.getParameter("txtCallingUrl");
	if( objThisData.strCallingUrl == null )
	{
		objThisData.strCallingUrl = req.getHeader("referer");
		if( objThisData.strCallingUrl == null )
			objThisData.strCallingUrl = new String("");
	}

	objThisData.strAllGroupIds = req.getParameter("N0_lst");
	if( objThisData.strAllGroupIds == null )
		objThisData.strAllGroupIds = "";	

	StringTokenizer stGroupIds = new StringTokenizer(objThisData.strAllGroupIds,",");
	while(stGroupIds.hasMoreTokens()) {
		objThisData.vGroupIds.addElement(stGroupIds.nextToken());
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
	try
	{
		for(int i=0;i<objThisData.vGroupIds.size();i++)
		{
			String szSeq = new String("");
			szSeq = Integer.toString(i+1);
			if(szSeq.length()<2)	{
				szSeq = "0"+szSeq;
			}
			strInsertSql = "insert into tgroup_user (user_id, seq ,"+
						"group_id) values ('"+objThisData.strUserId+"','"+szSeq+"','"+objThisData.vGroupIds.elementAt(i)+"')";

			stmInsert = objThisData.conDb.createStatement();
			iReturn = stmInsert.executeUpdate(strInsertSql);
			if( iReturn != 1 )
			{
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()","The insert sql return != 1 return = '"+String.valueOf(iReturn)+"'");
				bReturnStatus = false;
			}
		}
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":insertDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":insertDb()","Exit with status false");
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
	try
	{
		strDeleteSql = objThisData.getDeleteSql();
		stmDelete = objThisData.conDb.createStatement();
		iReturn = stmDelete.executeUpdate(strDeleteSql);
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","'"+String.valueOf(iReturn)+"' record deleted");
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":deleteDb()",e);
		bReturnStatus = false;
	}
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":deleteDb()","Exit with status false");
	return bReturnStatus;
}

public String getCurrentGroupIdList(DataClass objThisData)
{
	String strReturnHtml = new String("<SELECT name=\"N0\" size=\"14\">");					
	Statement stmStatement = null;
	ResultSet rstResultSet = null;
	String strSql = new String("");
	strSql = new String("select a.group_id,b.group_name  from tgroup_user a,tgroup b where a.user_id = '"+objThisData.strUserId+"'"
					+" and a.group_id = b.group_id");

	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery(strSql);
		while( rstResultSet.next() )
		{		
			if(rstResultSet.getString("group_id") != null )
			{
				strReturnHtml += "<OPTION value=\""+rstResultSet.getString("group_id")+"\"";
				strReturnHtml += ">"+rstResultSet.getString("group_id")+", "+rstResultSet.getString("group_name")+" </OPTION>\r\n";
			}
		}
		strReturnHtml += "</SELECT>";
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError("getCurrentGroupIdList()",e);
	}
	return strReturnHtml;
}

public String getAvailableGroupIdList(DataClass objThisData)
{
	String strReturnHtml = new String("<SELECT name=\"W0\" size=\"14\">");					
	Statement stmStatement = null;
	ResultSet rstResultSet = null;

	String strSql = new String("");
	strSql = new String("select group_id,group_name from tgroup where group_id not in"+
				     " (select group_id from tgroup_user where user_id = '"+objThisData.strUserId+"')"+
				     " and group_id not in (select default_group from tuser_id where user_id = '"+objThisData.strUserId+"')");

	try
	{
		stmStatement = objThisData.conDb.createStatement();
		rstResultSet = stmStatement.executeQuery(strSql);
		while( rstResultSet.next() )
		{		
			if(rstResultSet.getString("group_id") != null )
			{
				strReturnHtml += "<OPTION value=\""+rstResultSet.getString("group_id")+"\"";
				strReturnHtml += ">"+rstResultSet.getString("group_id")+", "+rstResultSet.getString("group_name")+"</OPTION>\r\n";
			}
		}
		strReturnHtml += "</SELECT>";
	}
	catch( SQLException e )
	{
		objThisData.siThisSessionInfo.setLastError("getAvailableGroupIdList()",e);
	}
	return strReturnHtml;
}
%>
<%
	HttpSession userSession = request.getSession(false); 
	//the main program begins...
	boolean bCallBySelf = false;						//�O�_���ۦ�I�s
	String strClientMsg = new String("");				//�Ǧ^��Client���T��
	boolean bReturnStatus = true;						//�U��ư��椧���G
	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());

	DataClass objThisData = new DataClass(siThisSessionInfo);	//���{���D�n�U�����
	objThisData.szSysFlag = (String)userSession.getAttribute("SYSTEM_FLAG");
	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");

%>
<%
	//�����o��Ʈw�s�u
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	if( !getInputParameter(request,objThisData,userSession) )
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
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Client request function is '"+objThisData.strActionCode+"'");
		if( objThisData.strActionCode.equalsIgnoreCase("S"))
		{
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing add function");
			if( !deleteDb( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}else{				
				if( !insertDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
				else
				{
					try
					{
						//strClientMsg = "'"+objThisData.strUserId+"' updated in tgroup_user";
						strClientMsg = "'"+objThisData.strUserId+"' �x�s����";
					}catch( Exception e ){
					}
				}
			}
		}
		else if( objThisData.strActionCode.equalsIgnoreCase("E") )	
		{
			if( !objThisData.strCallingUrl.equals("") )
				response.sendRedirect(objThisData.strCallingUrl);
		}
	}

%>
<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5.3 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>�s�ըϥΪ̺��@</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" VI6.0THEME="Global Marketing">
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
			if( winTarget.name == 'titleFrame' )
			{
				iTitle = i;
				oTitle = window.setInterval("checkTitleWindowState('"+strTitle+"','"+strProgId+"')",100);
			}
			if( winTarget.name == 'toolbarFrame' )
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
�ǤJ�Ѽ�:	String strButtonTag: 	E:Exit
						S:Save
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
	if( strButtonTag == "S" )	
	{
		document.getElementById("btnAction").value = "S";
		doSub(); 
		if( areAllFieldsOK() )
			document.getElementById("MainForm").submit();
		else
			alert(strErrMsg);
	}
	else if( strButtonTag == "E" )		
	{
		document.getElementById("btnAction").value = "E";
		location.replace("tGroupUserSelect.jsp");
		//document.forms("MainForm").submit();
	}
	else
	{
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
var strFunctionKey="E,S";		//toolbar frame ���n��ܪ��\����,�|���ӱƦC���ǥX�{
							//E:Exit, S:Save
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
			//strTmpMsg = "�п�J�M�ץN��";
			strTmpMsg   = "Hello ! Please fill the Group Id ";
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

function moveModule(o_col, d_col) 
{
  o_sl = document.MainForm[o_col].selectedIndex;
  d_sl = document.MainForm[d_col].length;
  if (o_sl != -1 && document.MainForm[o_col].options[o_sl].value > "") {
    oText = document.MainForm[o_col].options[o_sl].text;
    oValue = document.MainForm[o_col].options[o_sl].value;
    document.MainForm[o_col].options[o_sl] = null;
    document.MainForm[d_col].options[d_sl] = new Option (oText, oValue, false, true);
  } else {
    //alert("Please select a group id first");
     alert("�Х���ܤ@�Ӹs�եN��");

  }
}  

function orderModule(down, col) 
{
  sl = document.MainForm[col].selectedIndex;
  if (sl != -1 && document.MainForm[col].options[sl].value > "") {
    oText = document.MainForm[col].options[sl].text;
    oValue = document.MainForm[col].options[sl].value;
    if (document.MainForm[col].options[sl].value > "" && sl > 0 && down == 0) {
      document.MainForm[col].options[sl].text = document.MainForm[col].options[sl-1].text;
      document.MainForm[col].options[sl].value = document.MainForm[col].options[sl-1].value;
      document.MainForm[col].options[sl-1].text = oText;
      document.MainForm[col].options[sl-1].value = oValue;
      document.MainForm[col].selectedIndex--;
    } else if (sl < document.MainForm[col].length-1 && document.MainForm[col].options[sl+1].value > "" && down == 1) {
      document.MainForm[col].options[sl].text = document.MainForm[col].options[sl+1].text;
      document.MainForm[col].options[sl].value = document.MainForm[col].options[sl+1].value;
      document.MainForm[col].options[sl+1].text = oText;
      document.MainForm[col].options[sl+1].value = oValue;
      document.MainForm[col].selectedIndex++;
    }
  } else {
    //alert("Please select a group id first");
    alert("�Х���ܤ@�Ӹs�եN��");
    }
}

function xMod(col) 
{
  req = "";
  sl = document.MainForm[col].selectedIndex;
  if (sl != -1 && document.MainForm[col].options[sl].value > "") {
    if (req.indexOf(document.MainForm[col].options[sl].value) > -1) {
      alert ("You may not delete a required corporate module.");
    } else {
      if (confirm("This will delete the selected module.")) {
        if (document.MainForm[col].options[sl].value!=".none") {
          if (document.MainForm[col].length==1) {
            document.MainForm[col].options[0].text="";
            document.MainForm[col].options[0].value=".none";
          } else {
            document.MainForm[col].options[sl]=null; 
          } 
        } else {
          //alert("Please select a group id first");
	    alert("�Х���ܤ@�Ӹs�եN��");
	}
      }
    }
  }
}

function doSub() 
{
  layout = "W0N0";
  for (i=0; i < layout.length; i++) {
    if (layout.substr(i,1) == 'N' || layout.substr(i,1) == 'W') {
      col = layout.substr(i,2); 
      document.MainForm[col + "_lst"].value = makeList(col);
	//alert(document.MainForm[col + "_lst"].value);
    }
  }
  return true;
}

function makeList(col) 
{
  val = "";
  for (j=0; j<document.MainForm[col].length; j++) {
    if (val > "") { val += ","; }
    if (document.MainForm[col].options[j].value > "") val += document.MainForm[col].options[j].value;
  } 
  return val;
}

function sub_layout(layout) {
  document.MainForm['.commit'][0].value="";
  document.MainForm['.layout'].value=layout;
  doSub();
  document.MainForm.submit();
}
</SCRIPT>
</HEAD>
<BODY style="margin:0px" onload="OnLoad(document.title,'<%=strThisProgId%>',strFunctionKey,'txtProgramId')">
<FORM id="MainForm" name="MainForm" action="GroupUser.jsp">
<CENTER>
<p><b>�ϥΪ̥N��: <%=objThisData.strUserId%></b></p>
<table border=0 cellpadding=0 cellspacing=0 width="80%"><tr><td bgcolor=#666666>
<table border=0 cellpadding=2 cellspacing=1 width="100%">
<tr><td bgcolor="ffffff" align=center valign=top width="75%">
<input type=hidden name="W0_lst">
            <TABLE border="0" cellspacing="0" cellpadding="2" width="100%">
<tr>
                  <TD bgcolor="#999999" align="center"><font face="Arial" size=-1><b>�i�ѿ�ܪ��\��ﶵ</b></font></TD>
                </tr>
<tr><td align=center><table border=0 cellspacing=2 cellpadding=0>
<tr><td rowspan=2><%= getAvailableGroupIdList(objThisData)%></td>
<td valign=top><a href="javascript:moveModule('W0','N0');"><img src="../images/misc/right.gif" width=16 height=16 border=0 alt="Right" vspace=2></a><br><a href="javascript:moveModule('N0','W0');"><img src="/webapp/NanShan/Aes/misc/left.gif" width=16 height=16 border=0 alt="Left" vspace=2></a></td></tr>
<tr><td valign=bottom><br><br></td></tr></table></td></tr></TABLE>
            </td>
<td bgcolor="eeeeee" align=center valign=top width="25%">
<input type=hidden name="N0_lst">
<table border=0 cellspacing=0 cellpadding=2 width="100%">
<tr><td bgcolor=#999999 align=center><font face="Arial" size=-1><b>�ثe��ܪ��\��ﶵ</b></font></td></tr>
<tr><td align=center><table border=0 cellspacing=2 cellpadding=0>
<tr><td rowspan=2><%= getCurrentGroupIdList(objThisData)%></td>
<td valign=top><a href="javascript:orderModule(0,'N0');"><img src="../images/misc/up.gif" width=16 height=16 border=0 alt="Up" vspace=2></a><br>
<a href="javascript:orderModule(1,'N0');"><img src="../images/misc/down.gif" width=16 height=16 border=0 alt="Down" vspace=2></a></td></tr>
<tr><td valign=bottom><br><br></td></tr></table></td></tr></table></td></tr>
</table>
</td></tr></table>
</CENTER>
<INPUT name="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
<INPUT id=txtCallingUrl name=txtCallingUrl type=hidden value="<%=objThisData.strCallingUrl%>">
<INPUT name="btnAction" id="btnAction" type="hidden" value="<%=objThisData.strActionCode%>">
<INPUT name="txtClientMsg"  type="hidden" value="<%= strClientMsg %>">
<INPUT name="txtUserId"  type="hidden" value="<%=objThisData.strUserId%>">
<INPUT name="txtDebug"  type="hidden" value="0">
</FORM>
</BODY>
</HTML>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>
