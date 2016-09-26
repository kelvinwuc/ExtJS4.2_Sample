<%@ page contentType="text/html;charset=BIG5" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page import="java.text.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.aegon.servlet.*" %>
<%@ include file="../Logon/CheckLogon.inc" %>
<!--
	SessionInfo siThisSessionInfo
	UserInfo    uiThisUserInfo
-->
<%!
	String strThisProgId = new String("GroupUser");
	class DataClass extends Object 
	{
		public String strUserId    = new String("");
		public String strUserStatus = new String("");
		public String strStaffName  = new String("");
		public String strBranchCode = new String("");
		public String strDefaultGroup = new String("");	
		public String strBranchName = new String("");
		public String strGroupName = new String("");	
		public String strSystemFlag= new String("");

		public SessionInfo siThisSessionInfo = null;	
		public String strActionCode= new String("");	
				
		public Connection conDb = null;
						
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

		
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("GroupUserSelect.DataClass.getConnection()");
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
		public String getInquirySqlAES()
		{	
			String strReturn = new  String("");
			//strReturn = "select user_id, staff_name, default_group, branch_code "+
			//	     " from db_eservice..tuser_id where user_id = '"+strUserId+"'";

			strReturn = "select a.user_id, a.user_status, a.staff_name, a.default_group, a.branch_code, "+
				     " b.group_name, c.branch_name from tuser_id a, tgroup b, "+
				     " tbranch c where a.user_id = '"+strUserId+"' and a.default_group = b.group_id "+
				     " and a.branch_code *= c.branch_code ";

			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySqlAES()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}
		public String getInquirySqlCES()
		{	
			String strReturn = new  String("");
			strReturn = "select a.user_id, a.user_status, a.staff_name, a.default_group, a.branch_code, "+
				     " b.group_name, c.branch_name from tcis_user_id a, tcis_group b, "+
				     " tbranch c where a.user_id = '"+strUserId+"' and a.default_group = b.group_id "+
				     " and a.branch_code *= c.branch_code ";

			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySqlCES()","The inquiry sql is '"+strReturn+"'");
			return strReturn;
		}

	}
	
	public boolean checkFieldsServer( DataClass objThisData )
	{
		boolean bReturnStatus  = true;
		Statement stmStatement = null;
		ResultSet rstResultSet = null;
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Enter");
		if( objThisData.strUserId.equals("") )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":checkFieldsServer()","Please enter the user id");
			bReturnStatus = false;
		}
		if( bReturnStatus )	
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status true");
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,"tGroupUser...jsp:checkFieldsServer()","Exit with Status false");
		return bReturnStatus;
	}

	public boolean getInputParameter(HttpServletRequest req,DataClass objThisData)
	{
		boolean bReturnStatus = true;
		CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());
			
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
		
		objThisData.strActionCode = req.getParameter("btnAction");
		if( objThisData.strActionCode == null )
			objThisData.strActionCode = "";	

		objThisData.strUserId = req.getParameter("txtUserId");
		if( objThisData.strUserId == null )
			objThisData.strUserId = "";	

		if( bReturnStatus )
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status true");
		else
			objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status false");
		return bReturnStatus;
	}
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
			if(objThisData.strSystemFlag.equals("AES"))
			{
				strInquirySql = objThisData.getInquirySqlAES();
			}
			else if(objThisData.strSystemFlag.equals("CES"))
			{
				strInquirySql = objThisData.getInquirySqlCES();
			}

			stmInquiry = objThisData.conDb.createStatement();
			rstResultSet = stmInquiry.executeQuery(strInquirySql);
			if( rstResultSet.next() )
			{
				objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":inquiryDb()","Fetch 1 record successfully");
				if( rstResultSet.getString("user_id") != null )
				objThisData.strUserId = rstResultSet.getString("user_id").trim();
				else
					objThisData.strUserId = new String("");

				if( rstResultSet.getString("user_status") != null )
				objThisData.strUserStatus = rstResultSet.getString("user_status").trim();
				else
					objThisData.strUserStatus = new String("");
				
				if(objThisData.strUserStatus.equals("I"))
				{
					objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","The user id '"+objThisData.strUserId+"' is not active");
					objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","此使用者已失效");
					bReturnStatus = false;
				}
				if(bReturnStatus)
				{
					if( rstResultSet.getString("default_group") != null )
						objThisData.strDefaultGroup = rstResultSet.getString("default_group").trim();
					else
						objThisData.strDefaultGroup = new String("");

					if( rstResultSet.getString("staff_name") != null )
						objThisData.strStaffName = rstResultSet.getString("staff_name").trim();
					else
						objThisData.strStaffName = new String("");

					if( rstResultSet.getString("branch_code") != null)
						objThisData.strBranchCode = rstResultSet.getString("branch_code").trim();
					else
						objThisData.strBranchCode = new String("");
				
					if( rstResultSet.getString("branch_name") != null)
						objThisData.strBranchName = rstResultSet.getString("branch_name").trim();
					else
						objThisData.strBranchName = new String("");

					if( rstResultSet.getString("group_name") != null)
						objThisData.strGroupName = rstResultSet.getString("group_name").trim();
					else
						objThisData.strGroupName = new String("");
				}

			}
			else
			{
				//objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","The user id '"+objThisData.strUserId+"' not found in database");
				objThisData.siThisSessionInfo.setLastError(strThisProgId+":inquiryDb()","此使用者代號不存在於資料庫中");
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
	public boolean isKeyExist( DataClass objThisData )
	{
		boolean bReturnStatus = true;
		Statement stmInquiry = null;				
		ResultSet rstUser = null;				
		String strInquirySql = null;
									
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","Enter the user_id is '"+objThisData.strUserId+"'");
		try
		{
			if(objThisData.strSystemFlag.equals("AES"))
			{
				strInquirySql = objThisData.getInquirySqlAES();
			}
			else if(objThisData.strSystemFlag.equals("CES"))
			{
				strInquirySql = objThisData.getInquirySqlCES();
			}
			stmInquiry = objThisData.conDb.createStatement();
			rstUser = stmInquiry.executeQuery(strInquirySql);
			if( !rstUser.next() )
			{
				objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strUserId+"' does not exist in the database");
				bReturnStatus = false;
			}
			else
				objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":isKeyExist()","The project id '"+objThisData.strUserId+"' exists in the database");
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
	HttpSession userSession = request.getSession(false); 
	String strClientMsg = new String("");
	boolean bReturnStatus = true;
	boolean bCallBySelf = false;	
	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
	DataClass objThisData = new DataClass(siThisSessionInfo);
	objThisData.strSystemFlag = (String)userSession.getAttribute("SYSTEM_FLAG");	
	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	if( request.getParameter("txtThisProgId") != null )
	{	
		if(request.getParameter("txtThisProgId").equalsIgnoreCase(strThisProgId))
			bCallBySelf = true;
	}
	
	if( bCallBySelf )
	{
		if( !getInputParameter(request,objThisData) )
		{
			strClientMsg = siThisSessionInfo.getLastErrorMessage();
		}
		else
		{
			if( objThisData.strActionCode.equalsIgnoreCase("U"))
			{
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing inquiry function");
				if(!inquiryDb(objThisData))
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}else{
					userSession.setAttribute("TheUserId",objThisData.strUserId);
					response.sendRedirect(strThisProgId+"");
				}
			}
			else if( objThisData.strActionCode.equalsIgnoreCase("I") )
			{
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing inquiry function");
				if( !inquiryDb( objThisData ) )
				{
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
			}
		}
	}

%>
<html>
<head>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5.3 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Type" content="text/html;charset=Big5">
<title>群組使用者維護</title>
<SCRIPT language="JavaScript" >
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


function ToolBarOnClick(strButtonTag)
{
	if( iInterval != "" )
	{
		window.clearInterval(iInterval);
		iInterval = "";
	}

	if(strButtonTag == "I" )		
	{
		document.getElementById("btnAction").value = "I";
		if( areAllFieldsOK() )
			document.getElementById("MainForm").submit();
		else
			alert(strErrMsg);
	}
	if(strButtonTag == "U" )		
	{
		document.getElementById("btnAction").value = "U";
		if( areAllFieldsOK() )
		{
			document.getElementById("MainForm").submit();
			//UserId = document.getElementById("MainForm").txtUserId.value;
			//location.replace(strThisProgId+"?txtUserId="+UserId);
		}else{
			alert(strErrMsg);
		}
	}
	if(strButtonTag == "R" )
	{
		if(document.getElementById("MainForm") != null )
		{
			var j=0;
			if( document.getElementsByTagName("INPUT") != null )
			{
				var k=0;
				var coll = document.getElementsByTagName("INPUT");
				for(k=0;k<coll.length;k++)
				{
					if( coll[k].type == "text" || coll[k].type == "password")
						coll[k].value = "";
				}
			}
		}
	}
	
}

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
			if(!checkFieldsClient(coll[k],false) )
			{
				bReturnStatus = false;
			}
		}
	}
	return bReturnStatus;
}

var strFunctionKey="UIR";
		
function checkFieldsClient(objThisItem,bShowMsg)
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem.name == "txtUserId" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg   = "請輸入使用者代號";
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
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" VI6.0THEME="Global Marketing">
</head>
<body style="margin:0px" onload="OnLoad(document.title,'<%=strThisProgId%>',strFunctionKey,'txtProgramId')">
<FORM id="MainForm" name="MainForm" method="post" action="GroupUserSelect.jsp">
<CENTER>
  <table border="1" width="600">     
    <tbody>     
      <tr>     
        <td width="150" >使用者代號：</td>    
        <td width="150" ><input maxLength="10" name="txtUserId"  onblur="checkFieldsClient(this,true);" size="10" value="<%=objThisData.strUserId%>" style="font-size:  12pt">&nbsp;     
        </td>    
        <td width="150" >預設群組：     
        </td>    
        <td width="150" ><input maxLength="10" name="txtDefaultGroup"  onblur="checkFieldsClient(this,true);" size="10" value="<%=objThisData.strDefaultGroup%>" style="font-size: 12pt;  background-color: #C0C0C0">     
        </td>    
      </tr>    
      <tr>     
        <td width="150" >使用者名稱：</td>    
        <td width="150" ><input maxLength="10" name="txtStaffName"  onblur="checkFieldsClient(this,true);" size="10" value="<%=objThisData.strStaffName%>" style="font-size:  12pt;  background-color: #C0C0C0">&nbsp;     
        </td>    
        <td width="150" >分公司代碼：     
        </td>    
        <td width="150" ><input maxLength="10" name="txtBranchCode"  onblur="checkFieldsClient(this,true);" size="10" value="<%=objThisData.strBranchCode%>" style="font-size: 12pt;  background-color: #C0C0C0">     
        </td>    
      </tr> 
	<tr>     
        <td width="150" >群組名稱：</td>    
        <td width="150" ><input maxLength="10" name="txtGroupName"  onblur="checkFieldsClient(this,true);" size="10" value="<%=objThisData.strGroupName%>" style="font-size:  12pt;  background-color: #C0C0C0">&nbsp;     
        </td>    
        <td width="150" >分公司名稱：</td>    
        <td width="150" ><input maxLength="10" name="txtBranchName"  onblur="checkFieldsClient(this,true);" size="10" value="<%=objThisData.strBranchName%>" style="font-size: 12pt;  background-color: #C0C0C0">     
        </td>    
      </tr> 

    </tbody> 
  </table> </CENTER>
<INPUT name="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
<INPUT name="btnAction"  id="btnAction" type="hidden" value="<%=objThisData.strActionCode%>">
<INPUT name="txtClientMsg"  type="hidden" value="<%= strClientMsg %>">
</FORM>
</body>
</html>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>