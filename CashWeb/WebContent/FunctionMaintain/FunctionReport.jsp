<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393     Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
 *  =============================================================================
 */
%>
<%@ page contentType="text/html;charset=BIG5" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
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
//�b���w�qcalss variable

	public String strThisProgId = new String("FunctionReport");		//���{���N��
	//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//public Calendar cldCalendar = Calendar.getInstance(TimeZone.getDefault(),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End

	public SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss",java.util.Locale.TAIWAN);
	public DecimalFormat dFormatter = new DecimalFormat("###,###,###");
	public int iRowPerPage = 20;							//How many rows of data in one page.
	public int iLinePerPage = 160;							//The maxmium lines per page before eject this page, heading lines are not included.

	class DataClass extends Object 
	{
		int iLineCnt = 0;								//How many lines had been output in this page, including subtotal line.
		public String strFuncId = new String("");
		public String strFuncName = new String("");
		public int iCurrRow = 0;								//current begin row count in the result set
		public int iCurrPage = 1;								//current page no.
		public int iTargetPage = 1;
		public String strEofMark = new String("");					//'yes':reach eof of result set, 'no':not yet eof
		
		public SessionInfo siThisSessionInfo = null;				//�C�@��{���Ҧb��Session information	

		public String strActionCode = new String("J");				//Client�ݤ��\��n�D:'E':���},'I':�W�@��,'J':�U�@��,'P':�C�L,'H':�T�w

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
			conDb = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("FunctionReport.DataClass.getConnection()");
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

		//���o���{���� Inquiry SQL
		public String getInquirySql()
		{	String strReturn = new  String("");
			strReturn = " select  func_id,func_name from tFunction ";
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strReturn+"'");
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
public boolean getInputParameter(HttpServletRequest req,DataClass objThisData)
{
	boolean bReturnStatus = true;
	CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());
	String strTmp = new String("");

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Enter");
	objThisData.strActionCode = req.getParameter("btnAction");
	if( objThisData.strActionCode == null )
		objThisData.strActionCode = "J";
	strTmp = req.getParameter("txtCurrRow");
	if( strTmp != null )
	{
		try
		{
			objThisData.iCurrRow = Integer.parseInt(strTmp);
		}
		catch( Exception e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
			bReturnStatus = false;
		}
	}
	else
		objThisData.iCurrRow = 0;
	strTmp = req.getParameter("txtCurrPage");
	if( strTmp != null )
	{
		try
		{
			objThisData.iCurrPage = Integer.parseInt(strTmp);
		}
		catch( Exception e )
		{
			objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",e);
			bReturnStatus = false;
		}
	}
	else
		objThisData.iCurrPage = 1;
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status false");
	return bReturnStatus;
}

/**
��ƦW��:	printPageHeading(JspWriter out, DataClass objThisData ) throws IOException 
��ƥ\��:	print the page heading
�ǤJ�Ѽ�:	JspWriter out : the output stream to the client
		DataClass objThisData : ���{���Ҧ�������
�Ǧ^��:	none
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public void printPageHeading(JspWriter out, DataClass objThisData ) throws IOException
{
	objThisData.iCurrPage++;
	if( !objThisData.strActionCode.equals("P") )
	{
		if( objThisData.iCurrPage != objThisData.iTargetPage )
			return;
	}
	CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());
	out.println("<TABLE border=\"0\" width=\"638\">");
	out.println("<TBODY>");
	out.println("<TR>");
	//out.println("<TD align=\"left\" width=\"131\"><FONT size=\"1\" face=\"�з���\"></FONT></TD>");
	out.println("<TD align=\"center\" width=\"638\"><FONT size=\"3\" face=\"�з���\">���y�H�ثO�I�ѥ��������q</FONT></TD>");
	out.println("</TR>");
	out.println("<TR>");
	//out.println("<TD align=\"left\" width=\"131\"><FONT size=\"1\" face=\"�з���\"></FONT></TD>");
	out.println("<TD align=\"center\" width=\"638\"><FONT size=\"3\" face=\"�з���\">�\��ﶵ�@����</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE border=\"0\" width=\"600\" style=\"padding-top : 0pt;padding-left : 0pt;padding-right : 0pt;padding-bottom : 0pt;margin-top : 0pt;margin-left : 0pt;margin-right : 0pt;margin-bottom : 0pt;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.print("<TD width=\"241\"><FONT size=\"2\" face=\"�з���\"> ");
	out.println("</FONT></TD>");
	out.println("<TD width=\"204\"></TD>");
	out.print("<TD align=\"left\" width=\"172\"><FONT size=\"2\" face=\"�з���\">�L����: ");
	out.println(objThisData.siThisSessionInfo.getROCDate());
	out.println("</TR>");
	out.println("<TR>");
	out.print("<TD width=\"241\"><FONT size=\"2\" face=\"�з���\"> "); 
	out.println("</FONT></TD>");
	out.println("<TD  width=\"204\"></TD>");
	out.print("<TD align=\"left\" width=\"172\"><FONT size=\"2\" face=\"�з���\">����: ");
	out.println(String.valueOf(objThisData.iCurrPage));
	out.println("</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"600\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.println("<TD align=\"left\" width=100% ><FONT size=\"2\" face=\"�з���\">---------------------------------------------------------------------------------------------------</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"400\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	out.println("<TR >");

	out.println("<TD align=\"left\" width=\"200\"><FONT size=\"2\" face=\"�з���\">�\��ﶵ�N��</FONT></TD>");
	out.println("<TD align=\"left\" width=\"200\"><FONT size=\"2\" face=\"�з���\">�\��ﶵ�W��</FONT></TD>");
	out.println("</TR>");
		
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"600\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.println("<TD align=\"left\" width=100% ><FONT size=\"2\" face=\"�з���\">---------------------------------------------------------------------------------------------------</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
}

/**
��ƦW��:	printDetailLine(JspWriter out, ResultSet rstMainResultSet, DataClass objThisData) throws IOException, SQLException 
��ƥ\��:	print one detail line
�ǤJ�Ѽ�:	JspWriter out : the output stream to the client
		ResultSet rstMainResultSet: The current row which should be printed.
		DataClass objThisData : all the program memory variable
�Ǧ^��:	none
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
public void printDetailLine(JspWriter out, ResultSet rstMainResultSet, DataClass objThisData) throws IOException, SQLException
{
	if( !objThisData.strActionCode.equals("P") )
	{
		if( objThisData.iCurrPage != objThisData.iTargetPage )
			return;
	}
	out.println("<TABLE  border=\"0\" width=\"400\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	if( objThisData.iLineCnt%2 == 0 )
		out.println("<TR  height=\"5\" >");
	else
		out.println("<TR  height=\"5\" bgcolor=\"#00ffff\">");
	
	out.println("<TD align=\"left\" width=\"200\">");
	out.println("<FONT size=\"2\" face=\"�з���\">");
	if( rstMainResultSet.getString("func_id") != null ) 
		out.print(rstMainResultSet.getString("func_id"));
	out.println("</FONT>");
	out.println("</TD>");
	out.println("<TD align=\"left\" width=\"200\">");
	out.println("<FONT size=\"2\" face=\"�з���\">");
	if( rstMainResultSet.getString("func_name") != null ) 
		out.print(rstMainResultSet.getString("func_name"));
	out.println("</FONT>");
	out.println("</TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
}

%>
<%
	//Server�ݵ{���Ѧ������}�l
	String strClientMsg = new String("");				//�Ǧ^��Client���T��
	boolean bReturnStatus = true;						//�U��ư��椧���G
	
	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
    //R00393 Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();		//�ثe����ɶ�
    //R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass(siThisSessionInfo);	//���{���D�n�U�����
	
	Statement stmMainStatement = null;
	ResultSet rstMainResultSet = null;

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
%>
<%
	//�����o��Ʈw�s�u
	if( !objThisData.getConnection() )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	if( !getInputParameter(request,objThisData) )
	{
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
	}
	else
	{
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Client request function is '"+objThisData.strActionCode+"'");
		if(	objThisData.strActionCode.equalsIgnoreCase("H")	||
			objThisData.strActionCode.equalsIgnoreCase("J")	||		//�W�@�� 
			objThisData.strActionCode.equalsIgnoreCase("K") ||		//�U�@��
			objThisData.strActionCode.equalsIgnoreCase("P")	)		//�C�L
		{//���ˬd�Ҧ����O�_���T
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing Ok function");
			try
			{
				stmMainStatement = objThisData.conDb.createStatement();
				rstMainResultSet = stmMainStatement.executeQuery(objThisData.getInquirySql());
			}
			catch( Exception e )
			{
				siThisSessionInfo.setLastError(strThisProgId+":service()",e);
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
		}
	}
%>

<html>
<head>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5.3 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<title>�\��ﶵ�@����</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css" VI6.0THEME="Global Marketing">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css" VI6.0THEME="Global Marketing">
<STYLE>
<!--
	
	.PageEject{page-break-after: always;}
-->
</STYLE>
<SCRIPT language="JavaScript" >
var strFunctionKey="J,K,P";//		toolbar frame ���n��ܪ��\����
//							H:�T�w, J:prev page, K:next page, P:print the report
/**
��ƦW��:	OnLoad( String strTitle, String strProgId, strThisFunctionKey, strFirstField )
��ƥ\��:	��Client�ݵe���Ұʮ�,���楻���.
		1.���btitle frame��ܵ{���N���ε{���W��,�{���N���ε{���W�٭n�b<BODY>tag���ק�
		2.�YtxtClientMsg��줣���ťծ�, ��ܦ����~�T��,�ϥ�alert()��ܥ�
		3.�btoolbar frame��ܥ\����
�ǤJ�Ѽ�:	String strTitle: �{���W��,�m��title frame������,�o���ܼƬO�ϥΥ�������
					document.title,���ק糧jsp��<TITLE>tag
		String strProgId:	�{���N��,�m��title frame������.�ܼƨӷ���jsp��strThisProgId.
		String strThisFunctionKey: �n��ܪ��\����N��
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
	if( document.getElementById("txtClientMsg") != null )
	{
		if( document.getElementById("txtClientMsg").value != "" )
		{
			alert( document.getElementById("txtClientMsg").value );
			window.history.back();
		}
	}
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
	window.parent.frames['contentframe'].focus();
	if( document.getElementById("btnAction").value == "P" )
	{
		if( window.navigator.appName.indexOf("Microsoft") != -1 )
		{
			window.print();
//			document.getElementById("btnAction").value = "J";
			document.getElementById("MainForm").action = "/webapp/NanShan/Aes/htmlshade/ltblue_frmset.html";
			document.getElementById("MainForm").target = "arena";
			document.getElementById("MainForm").submit();
		}
	}
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
�ǤJ�Ѽ�:	String strButtonTag: 	E:���}
							J:�W�@��
							K:�U�@��
							P:�C�L
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
	if( strButtonTag == "E" )//			���}
	{
		document.getElementById("btnAction").value = "E";
		document.getElementById("MainForm").submit();
	}
	else if( strButtonTag == "J" )//		�W�@��
	{
		if( document.getElementById("MainForm").txtCurrPage.value == "1" )
		{
			alert("�w�O�Ĥ@��");
		}
		else
		{
			document.getElementById("btnAction").value = "J";
			document.getElementById("MainForm").submit();
		}
	}
	else if( strButtonTag == "K" )//		�U�@��
	{
		if( document.getElementById("MainForm").txtEofMark.value == "yes" )
		{
			alert("�w�O�̫�@��");
		}
		else
		{
			document.getElementById("btnAction").value = "K";
			document.getElementById("MainForm").submit();
		}
	}
	else if( strButtonTag == "P" )//		�C�L
	{
		document.getElementById("btnAction").value = "P";
		document.getElementById("MainForm").submit();
	}
	else
	{//�Y�����B�z�����s��,��ܿ��~�T��
		alert("The button flag = '"+strButtonTag+"' unhandled");
	}
}



</SCRIPT>
</head>

<BODY style="margin:0px" onload="OnLoad(document.title,'<%=strThisProgId%>',strFunctionKey,'')">

<%  
	int i = 0;
	boolean bHasData = false;

	//reset to the begining if the request is printing.
	
	if( objThisData.strActionCode.equalsIgnoreCase("J") )
	{
		objThisData.iTargetPage = objThisData.iCurrPage - 1;
		if( objThisData.iTargetPage <= 1 )
			objThisData.iTargetPage = 1;
		objThisData.iCurrPage = 0;
	}
	else if( objThisData.strActionCode.equalsIgnoreCase("K") )
	{
		objThisData.iTargetPage = objThisData.iCurrPage + 1;
		objThisData.iCurrPage = 0;
	}
	else if( objThisData.strActionCode.equalsIgnoreCase("P") ) 			//print
	{//if the request is printing then reset the current page to the first
		objThisData.iCurrPage = 0;
		objThisData.iCurrRow = 0;
		objThisData.iTargetPage = 1;
	}
	//set eof mark on first, will be reset off later if it is not eof.
	objThisData.strEofMark = new String("yes");

	//If there is no error, process the report, otherwise send the error message to client.
	if( strClientMsg.equals("") )
	{
		while( rstMainResultSet.next() )
		{ 
			bHasData = true;
			if( objThisData.iLineCnt == 0 )
			{
				printPageHeading( out, objThisData );
			} 
			
			//check the office break first, then the page counter next.
				 objThisData.iLineCnt           +=3;
				  if( objThisData.iLineCnt++ > iLinePerPage )
				{
					if( !objThisData.strActionCode.equalsIgnoreCase("P") )
					{
						if( objThisData.iCurrPage == objThisData.iTargetPage )
						{
							objThisData.strEofMark = new String("no");
							break;
						}
					}
					else
						out.print("<P class=PageEject>&nbsp;</P>");
					objThisData.iLineCnt = 0;
					printPageHeading( out, objThisData );
				}
				printDetailLine(out, rstMainResultSet, objThisData );
			//check whether this page is full. if it is, eject the page and if not in printing mode, break the loop.
			
			if( objThisData.iLineCnt++ > iLinePerPage )
			{
				if( !objThisData.strActionCode.equalsIgnoreCase("P") )
				{
					if( objThisData.iCurrPage == objThisData.iTargetPage )
					{
					       
						objThisData.strEofMark = new String("no");
						break;
					}
				}
				
				else
				
					out.print("<P class=PageEject>&nbsp;</P>");
					objThisData.iLineCnt = 0;
				
			} 
			
			
		} //while( rstMainResultSet.next() )
		
		
		if( bHasData)
		{
			 if( objThisData.strEofMark.equalsIgnoreCase("yes") )
			{
				//printPageFooter(out, objThisData , false);
				//printReportFooter( out, objThisData );
			} 
		}
		else
		{
			strClientMsg = new String("�L�ŦX���󤧸��");
		}
	}//if( strClientMsg.equals("") )
%>  
<DIV align=left>
<FORM action="FunctionReport.jsp" id="MainForm" method="post" name="MainForm">
	<INPUT id=txtCurrRow name=txtCurrRow type=hidden value="<%=String.valueOf(objThisData.iCurrRow)%>">
	<INPUT id=txtCurrPage name=txtCurrPage type=hidden value="<%=String.valueOf(objThisData.iCurrPage)%>">
	<INPUT id=txtEofMark name=txtEofMark type=hidden value="<%=objThisData.strEofMark%>">
	<INPUT name="txtThisProgId" id="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
	<INPUT name="btnAction" id="btnAction"  type="hidden" value="<%=objThisData.strActionCode%>">
	<INPUT name="txtClientMsg" id="txtClientMsg"  type="hidden" value="<%= strClientMsg %>">
</FORM>
</DIV>
</body>
</html>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>
