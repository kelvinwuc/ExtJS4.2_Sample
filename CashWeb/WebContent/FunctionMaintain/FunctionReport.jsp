<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393     Leo Huang    			2010/09/20           現在時間取Capsil營運時間
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
	經過 CheckLogon.jsp 之處理後,每一支程式都會有 
		SessionInfo siThisSessionInfo
		UserInfo    uiThisUserInfo
-->
<%!
//在此定義calss variable

	public String strThisProgId = new String("FunctionReport");		//本程式代號
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
		
		public SessionInfo siThisSessionInfo = null;				//每一支程式所在的Session information	

		public String strActionCode = new String("J");				//Client端之功能要求:'E':離開,'I':上一頁,'J':下一頁,'P':列印,'H':確定

		//資料庫連結變數
		public Connection conDb = null;					//db_basic之jdbc connection
		
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

		//自 NsDbFactory 中取得一個 Connection
		public boolean getConnection()
		{
			boolean bReturnStatus = true;
			//先取得資料庫連結及準備SQL
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

		//取得本程式的 Inquiry SQL
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
函數名稱:	getInputParameter( HttpServletRequest req, DataCalss objThisData ) 
函數功能:	將Client端傳入之各欄位值存入objThisData中
傳入參數:	HttpServletRequest req: Client傳入之 request object
		DataClass objThisData : 本程式所有的欄位值
傳回值:	若有任一欄位錯誤,傳回false,否則傳回true
修改紀錄:	修改日期	修改者	修   改   摘   要
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
函數名稱:	printPageHeading(JspWriter out, DataClass objThisData ) throws IOException 
函數功能:	print the page heading
傳入參數:	JspWriter out : the output stream to the client
		DataClass objThisData : 本程式所有的欄位值
傳回值:	none
修改紀錄:	修改日期	修改者	修   改   摘   要
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
	//out.println("<TD align=\"left\" width=\"131\"><FONT size=\"1\" face=\"標楷體\"></FONT></TD>");
	out.println("<TD align=\"center\" width=\"638\"><FONT size=\"3\" face=\"標楷體\">全球人壽保險股份有限公司</FONT></TD>");
	out.println("</TR>");
	out.println("<TR>");
	//out.println("<TD align=\"left\" width=\"131\"><FONT size=\"1\" face=\"標楷體\"></FONT></TD>");
	out.println("<TD align=\"center\" width=\"638\"><FONT size=\"3\" face=\"標楷體\">功能選項一覽表</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE border=\"0\" width=\"600\" style=\"padding-top : 0pt;padding-left : 0pt;padding-right : 0pt;padding-bottom : 0pt;margin-top : 0pt;margin-left : 0pt;margin-right : 0pt;margin-bottom : 0pt;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.print("<TD width=\"241\"><FONT size=\"2\" face=\"標楷體\"> ");
	out.println("</FONT></TD>");
	out.println("<TD width=\"204\"></TD>");
	out.print("<TD align=\"left\" width=\"172\"><FONT size=\"2\" face=\"標楷體\">印表日期: ");
	out.println(objThisData.siThisSessionInfo.getROCDate());
	out.println("</TR>");
	out.println("<TR>");
	out.print("<TD width=\"241\"><FONT size=\"2\" face=\"標楷體\"> "); 
	out.println("</FONT></TD>");
	out.println("<TD  width=\"204\"></TD>");
	out.print("<TD align=\"left\" width=\"172\"><FONT size=\"2\" face=\"標楷體\">頁數: ");
	out.println(String.valueOf(objThisData.iCurrPage));
	out.println("</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"600\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.println("<TD align=\"left\" width=100% ><FONT size=\"2\" face=\"標楷體\">---------------------------------------------------------------------------------------------------</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"400\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	out.println("<TR >");

	out.println("<TD align=\"left\" width=\"200\"><FONT size=\"2\" face=\"標楷體\">功能選項代號</FONT></TD>");
	out.println("<TD align=\"left\" width=\"200\"><FONT size=\"2\" face=\"標楷體\">功能選項名稱</FONT></TD>");
	out.println("</TR>");
		
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"600\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.println("<TD align=\"left\" width=100% ><FONT size=\"2\" face=\"標楷體\">---------------------------------------------------------------------------------------------------</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
}

/**
函數名稱:	printDetailLine(JspWriter out, ResultSet rstMainResultSet, DataClass objThisData) throws IOException, SQLException 
函數功能:	print one detail line
傳入參數:	JspWriter out : the output stream to the client
		ResultSet rstMainResultSet: The current row which should be printed.
		DataClass objThisData : all the program memory variable
傳回值:	none
修改紀錄:	修改日期	修改者	修   改   摘   要
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
	out.println("<FONT size=\"2\" face=\"標楷體\">");
	if( rstMainResultSet.getString("func_id") != null ) 
		out.print(rstMainResultSet.getString("func_id"));
	out.println("</FONT>");
	out.println("</TD>");
	out.println("<TD align=\"left\" width=\"200\">");
	out.println("<FONT size=\"2\" face=\"標楷體\">");
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
	//Server端程式由此正式開始
	String strClientMsg = new String("");				//傳回給Client之訊息
	boolean bReturnStatus = true;						//各函數執行之結果
	
	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
    //R00393 Edit by Leo Huang (EASONTECH) Start
	//java.util.Date dteToday = cldCalendar.getTime();		//目前日期時間
    //R00393  Edit by Leo Huang (EASONTECH) End
	DataClass objThisData = new DataClass(siThisSessionInfo);	//本程式主要各欄位資料
	
	Statement stmMainStatement = null;
	ResultSet rstMainResultSet = null;

	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Server side Enter");
	
%>
<%
	//先取得資料庫連線
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
			objThisData.strActionCode.equalsIgnoreCase("J")	||		//上一頁 
			objThisData.strActionCode.equalsIgnoreCase("K") ||		//下一頁
			objThisData.strActionCode.equalsIgnoreCase("P")	)		//列印
		{//先檢查所有欄位是否正確
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
<title>功能選項一覽表</title>
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
var strFunctionKey="J,K,P";//		toolbar frame 中要顯示的功能鍵
//							H:確定, J:prev page, K:next page, P:print the report
/**
函數名稱:	OnLoad( String strTitle, String strProgId, strThisFunctionKey, strFirstField )
函數功能:	當Client端畫面啟動時,執行本函數.
		1.先在title frame顯示程式代號及程式名稱,程式代號及程式名稱要在<BODY>tag中修改
		2.若txtClientMsg欄位不為空白時, 表示有錯誤訊息,使用alert()顯示它
		3.在toolbar frame顯示功能鍵
傳入參數:	String strTitle: 程式名稱,置於title frame之中央,這個變數是使用本頁面之
					document.title,應修改本jsp之<TITLE>tag
		String strProgId:	程式代號,置於title frame之左側.變數來源為jsp之strThisProgId.
		String strThisFunctionKey: 要顯示的功能鍵代號
		String strFirstField: 輸入的第一個欄位
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
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
函數名稱:	ToolBarClick( String strButtonTag )
函數功能:	當toolbar frame中任一按鈕click時,就會執行本函數.當執行本函數時會傳入一個字串,
		該字串代表toolbar frame中哪一個按鈕被click
		當新增,修改按鈕時,先執行全部欄位檢查,若有任一欄位錯誤時,
		就顯示全部錯誤訊息,若正確時則將bntAction設定為傳入之參數值,
		並執行MainForm.submit(),將輸入之欄位傳送至web server
		若為查詢及刪除時,僅檢查鍵值是否正確,若正確,則將bntAction設定為傳入之參數值,
		並執行MainForm.submit(),將輸入之欄位傳送至web server
		若為清除時,則將各欄位清空.
傳入參數:	String strButtonTag: 	E:離開
							J:上一頁
							K:下一頁
							P:列印
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function ToolBarOnClick(strButtonTag)
{
	if( iInterval != "" )
	{
		window.clearInterval(iInterval);
		iInterval = "";
	}
	if( strButtonTag == "E" )//			離開
	{
		document.getElementById("btnAction").value = "E";
		document.getElementById("MainForm").submit();
	}
	else if( strButtonTag == "J" )//		上一頁
	{
		if( document.getElementById("MainForm").txtCurrPage.value == "1" )
		{
			alert("已是第一頁");
		}
		else
		{
			document.getElementById("btnAction").value = "J";
			document.getElementById("MainForm").submit();
		}
	}
	else if( strButtonTag == "K" )//		下一頁
	{
		if( document.getElementById("MainForm").txtEofMark.value == "yes" )
		{
			alert("已是最後一頁");
		}
		else
		{
			document.getElementById("btnAction").value = "K";
			document.getElementById("MainForm").submit();
		}
	}
	else if( strButtonTag == "P" )//		列印
	{
		document.getElementById("btnAction").value = "P";
		document.getElementById("MainForm").submit();
	}
	else
	{//若有未處理的按鈕值,顯示錯誤訊息
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
			strClientMsg = new String("無符合條件之資料");
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
