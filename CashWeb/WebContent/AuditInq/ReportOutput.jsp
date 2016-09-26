<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393            Leo Huang    			2010/09/15            現在時間讀取Capsil營運日期
 *  =============================================================================
 */
%>
<%@ page contentType="text/html;Charset=BIG5" pageEncoding="BIG5" %>
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
//在此定義class variable

	public String strThisProgId = new String("AuditInq");		//本程式代號
	//R00393  Edit by Leo Huang (EASONTECH) Start
	
	//public Calendar cldCalendar = Calendar.getInstance(TimeZone.getDefault(),Constant.CURRENT_LOCALE);

	//R00393  Edit by Leo Huang (EASONTECH) End
	public SimpleDateFormat sdfDateFormatter = new SimpleDateFormat("yyyy/MM/dd",java.util.Locale.TAIWAN);
	public DecimalFormat dFormatter = new DecimalFormat("###,###,###");
	public int iRowPerPage = 20;							//How many rows of data in one page.
	public int iLinePerPage = 14;//was 32							//The maxmium lines per page before eject this page, heading lines are not included.

	class DataClass extends Object 
	{
		//資料庫相關欄位變數(本程式主要欄位)
		public java.util.Date dteLogStartDate = null;				//起始日期
		public java.util.Date dteLogEndDate = null;				//截止日期
		public String strFuncId = new String("");				//功能代號
		public String strFuncName = new String("");				//功能名稱
		public String strUserId = new String("");				//使用者代號
		public String strUserName = new String("");				//使用者姓名


		int iLineCnt = 0;							//How many lines had been output in this page, including subtotal line.
		public String strCallingUrl = new String("");				//calling url
		public int iCurrRow = 0;						//current begin row count in the result set
		public int iCurrPage = 1;						//current page no.
		public int iTargetPage = 1;
		public String strEofMark = new String("");				//'yes':reach eof of result set, 'no':not yet eof


		public SessionInfo siThisSessionInfo = null;				//每一支程式所在的Session information	

		public String strActionCode = new String("");				//Client端之功能要求:'E':離開,'I':上一頁,'J':下一頁,'P':列印,'H':確定

		//資料庫連結變數
		public Connection conConnection = null;					//jdbc connection
		
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
			conConnection = siThisSessionInfo.getUserInfo().getDbFactory().getConnection("AuditInq.ReportOutput.DataClass.getConnection()");
			if( conConnection == null )
				bReturnStatus = false;
			if( bReturnStatus )
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getConnection()","getConnection O.K.");
			else
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,strThisProgId+":getConnection()","siThisSessionInfo.getUserInfo().getDbFactory().getConnection() return null error!!");

			return bReturnStatus;
		}

		public void releaseConnection()
		{
			if( conConnection != null )
				siThisSessionInfo.getUserInfo().getDbFactory().releaseConnection(conConnection);
			conConnection = null;
		}


		//取得本程式的 Inquiry SQL
		public String getInquirySql()
		{	
		    
			CommonUtil commonUtil = new CommonUtil();
			
			String strSql =new String("");
			//old--->strSql = "select a.UserId,b.UserName,a.LogDate,a.FuncId,c.func_name,a.SubFunction,a.KeyData from tAuditLog a, tUser b, tFunction c where a.UserId = b.UserId and a.FuncId = c.func_id ";
			strSql = "SELECT a.USRID, a.LOGDTE, a.FUNID, a.SUBFUN, a.KEYDAT, b.USRNAM, c.FUNNAM " ;
			strSql+= "FROM AUDLOG a LEFT OUTER JOIN FUNC c ON a.FUNID = c.FUNID LEFT OUTER JOIN ";
                        strSql+= "USER b ON a.USRID = b.USRID where 1=1 " ;
                          
			if( dteLogStartDate != null )
			{
				//strSql += " and convert(char(11),a.LogDate,111) >= '"+sdfDateFormatter.format( dteLogStartDate )+"' ";
//				strSql += "and a.LOGDTE >= '"+sdfDateFormatter.format( dteLogStartDate )+"' ";
				strSql += "and a.LOGDTE >= '"+commonUtil.convertWesten2ROCDateTime1(dteLogStartDate)+"' ";
			} 
			if( dteLogEndDate != null )
			{
				//strSql += " and convert(char(11),a.LogDate,111) <= '"+sdfDateFormatter.format( dteLogEndDate )+"' ";
				strSql += " and a.LOGDTE <= '"+commonUtil.convertWesten2ROCDateTime1( dteLogEndDate )+"' ";
			} 
			if( !strFuncId.equals("") )
			{
				strSql += " and a.FUNID = '"+strFuncId+"' ";
			} 
			if( !strUserId.equals("") )
			{
				strSql += " and a.USRID = '"+strUserId+"' ";
			} 
			
			strSql += " order by LOGDTE";
                        
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInquirySql()","The inquiry sql is '"+strSql+"'");
			return strSql;
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
	Statement stmStatement = null;
	ResultSet rstResultSet = null;

	objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Enter");

	if( bReturnStatus )	
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":checkFieldsServer()","Exit with Status false");
	return bReturnStatus;
}
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
	try
	{
		objThisData.strActionCode = req.getParameter("txtAction");
		if( objThisData.strActionCode == null )
			objThisData.strActionCode = "";	

		objThisData.strCallingUrl = req.getParameter("txtCallingUrl");
		if( objThisData.strCallingUrl == null )
		{
			objThisData.strCallingUrl = req.getHeader("referer");
			if( objThisData.strCallingUrl == null )
				objThisData.strCallingUrl = new String("");
		}
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
	

		if( !req.getParameter("txtLogStartDate").equals("") )
			objThisData.dteLogStartDate = commonUtil.convertROC2WestenDate(req.getParameter("txtLogStartDate"));	

		if( !req.getParameter("txtLogEndDate").equals("") )
			objThisData.dteLogEndDate = commonUtil.convertROC2WestenDate(req.getParameter("txtLogEndDate"));	

		objThisData.strFuncId = req.getParameter("selFuncId");
		objThisData.strUserId = req.getParameter("txtUserId");
	}
	catch(Exception ex)
	{
		objThisData.siThisSessionInfo.setLastError(strThisProgId+":getInputParameter()",ex);
		bReturnStatus = false;
	}

	
	if( bReturnStatus )
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status true");
	else
		objThisData.siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":getInputParameter()","Exit with status false");
	return bReturnStatus;
}

/**
函數名稱:	printPageHeading(JspWriter out, DataClass objThisData , ResultSet rstResultSet ) throws IOException 
函數功能:	print the page heading
傳入參數:	JspWriter out : the output stream to the client
		DataClass objThisData : 本程式所有的欄位值
傳回值:	none
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public void printPageHeading(JspWriter out, DataClass objThisData, ResultSet rstResultSet) throws IOException, SQLException
{
	if( !objThisData.strActionCode.equals("P") )
	{
		if( objThisData.iCurrPage != objThisData.iTargetPage )
			return;
	}
	CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());

	out.println("<TABLE border=\"0\" width=\"650\" >");
	out.println("<TBODY>");
	out.println("<TR>");
	out.println("<TD align=\"center\" width=\"650\"><FONT size=\"3\" >全球人壽保險股份有限公司</FONT></TD>");
	out.println("</TR>");
	out.println("<TR>");
	out.println("<TD align=\"center\" width=\"650\"><FONT size=\"3\" >系統稽核紀錄查詢/列印</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE border=\"0\" width=\"650\" style=\"padding-top : 0pt;padding-left : 0pt;padding-right : 0pt;padding-bottom : 0pt;margin-top : 0pt;margin-left : 0pt;margin-right : 0pt;margin-bottom : 0pt;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.println("<TD width=\"230\"><FONT size=\"2\">起訖日期: ");
	if( objThisData.dteLogStartDate != null )
		out.print(commonUtil.getROCDate(objThisData.dteLogStartDate));
	out.print(" - ");
	if( objThisData.dteLogEndDate != null )
		out.print(commonUtil.getROCDate(objThisData.dteLogEndDate));
	out.println("</FONT></TD>");
	out.println("<TD width=\"250\"></TD>");
	out.print("<TD align=\"left\" width=\"170\"><FONT size=\"2\">印表日期 : ");
	out.print(commonUtil.getROCDate());
	out.println("</FONT></TD>");
	out.println("</TR>");
	
	out.println("<TR>");
	out.println("<TD width=\"330\"><FONT size=\"2\">使用者　: ");
	if( !objThisData.strUserId.equals("") )
	{
		out.print(objThisData.strUserId+"  "+rstResultSet.getString("USRNAM"));
	}
	else
	{
		out.print("全選");
	}
	out.println("</FONT></TD>");
	out.println("<TD width=\"150\"></TD>");
	out.println("<TD align=\"left\" width=\"170\"><FONT size=\"2\" >");
	out.println("</FONT></TD>");
	out.println("</TR>");
    out.println("<TR>");
	out.println("<TD width=\"330\"><FONT size=\"2\">使用程式: ");
	if( !objThisData.strFuncId.equals("") )
	{
		out.print(objThisData.strFuncId+"  "+rstResultSet.getString("FUNNAM"));
	}
	else
	{
		out.print("全選");
	}
	out.println("</FONT></TD>");
	out.println("<TD width=\"150\"></TD>");
	out.println("<TD align=\"left\" width=\"170\"><FONT size=\"2\" >");
	out.println("</FONT></TD>");
	out.println("</TR>");
	out.println("<TR>");
	out.println("<TD width=\"230\">&nbsp;</TD>");
	out.println("<TD width=\"250\"></TD>");
	out.println("<TD align=\"left\" width=\"170\"><FONT size=\"2\">頁&nbsp;&nbsp;&nbsp;&nbsp;數 : ");
	out.print( String.valueOf( objThisData.iCurrPage ));
	out.println("</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"650\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.println("<TD align=\"left\" width=100% ><FONT size=\"2\">--------------------------------------------------------------------------------------------</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"650\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY class=queryHead>");
	out.println("<TR>");
	out.println("<TD align=\"center\" width=\"150\"><FONT size=\"3\">紀錄日期</FONT></TD>");
	out.println("<TD align=\"center\" width=\"100\"><FONT size=\"3\" >使用者</FONT></TD>");
	out.println("<TD align=\"center\" width=\"100\"><FONT size=\"3\">程式名稱</FONT></TD>");
	out.println("<TD align=\"center\" width=\"50\"><FONT size=\"3\">動作</FONT></TD>");
	out.println("<TD align=\"center\" width=\"250\"><FONT size=\"3\" >輸入資料</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"650\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	out.println("<TBODY>");
	out.println("<TR>");
	out.println("<TD align=\"left\" width=100% ><FONT size=\"2\" >--------------------------------------------------------------------------------------------</FONT></TD>");
	out.println("</TR>");
	out.println("</TBODY>");
	out.println("</TABLE>");
	out.println("<TABLE  border=\"0\" width=\"650\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
}

/**
函數名稱:	printDetailLine(JspWriter out, ResultSet rs, DataClass objThisData) throws java.io.IOException, SQLException 
函數功能:	print one detail line
傳入參數:	JspWriter out : the output stream to the client
		ResultSet rs: The current row which should be printed.
		DataClass objThisData : all the program memory variable
傳回值:	none
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/


public void printDetailLine(JspWriter out, ResultSet rs, DataClass objThisData) throws  java.io.IOException ,SQLException
{
	CommonUtil commonUtil = new CommonUtil(objThisData.siThisSessionInfo.getUserInfo().getDbFactory().getGlobalEnviron());
	SimpleDateFormat sdfDateFormatter1 = new SimpleDateFormat(" hh:mm:ss",java.util.Locale.US);
	DecimalFormat df = new DecimalFormat("###,###,###");
	if( !objThisData.strActionCode.equals("P") )
	{
		if( objThisData.iCurrPage != objThisData.iTargetPage )
			return;
	}

//	out.println("<TABLE  border=\"0\" width=\"650\" style=\"padding-top : 0px;padding-left : 0px;padding-right : 0px;padding-bottom : 0px;margin-top : 0px;margin-left : 0px;margin-right : 0px;margin-bottom : 0px;\">");
	if( (objThisData.iLineCnt % 2) == 0 )
		out.println("<TR Style=\"background-color:white;\">");
	else
		out.println("<TR Style=\"background-color:lightblue;\">");
		
	
	
	out.println("<TD align=\"center\" width=\"150\"><FONT size=\"3\" >");
//	out.print(commonUtil.convertWesten2ROCDate((java.util.Date)rs.getDate("LOGDTE")));
	out.print(parseDate(rs.getString("LOGDTE")));
//	out.print(sdfDateFormatter1.format(rs.getTime("LOGDTE")));
	out.println("</FONT></TD>");
	out.println("<TD width=\"100\"><FONT size=\"3\" >");
	out.print(rs.getString("USRNAM"));
	out.println("</FONT></TD>");
	out.println("<TD width=\"100\"><FONT size=\"3\">");
	out.print(rs.getString("FUNNAM"));
	out.println("</FONT></TD>");
	out.println("<TD align=\"center\" width=\"30\"><FONT size=\"3\">");
	out.print(rs.getString("SUBFUN"));
	out.println("</FONT></TD>");
	out.println("<TD width=\"270\"><FONT size=\"3\">");
	out.print(rs.getString("KEYDAT"));
	out.println("</FONT></TD>");
	out.println("</TR>");

		
//	out.println("</TABLE>");


}


/**
函數名稱:	printPageFooter(JspWriter out, DataClass objThisData ) 
函數功能:	print page footer
傳入參數:	JspWriter out : the output stream to the client
		DataClass objThisData : all the memory variable
		boolean bEject : true: eject the page after print out the page footer
傳回值:	none
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/


public void printPageFooter(JspWriter out, DataClass objThisData, boolean bEject )  throws java.io.IOException
{
	if( !objThisData.strActionCode.equals("P") )
	{
		if( objThisData.iCurrPage != objThisData.iTargetPage )
			return;
	}
	out.println("</TABLE>");
	if( bEject )
		out.println("<P class=PageEject>&nbsp;</P>");

}


/**
函數名稱:	printReportFooter(JspWriter out, DataClass objThisData ) throws java.io.IOException
函數功能:	print report footer
傳入參數:	JspWriter out : the output stream to the client
		DataClass objThisData : all the memory variable
傳回值:	none
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public void printReportFooter(JspWriter out, DataClass objThisData )  throws java.io.IOException
{
	if( !objThisData.strActionCode.equals("P") )
	{
		if( objThisData.iCurrPage != objThisData.iTargetPage )
			return;
	}

//	out.println("<P class=PageEject>&nbsp;</P>");

}

/**
函數名稱:	parseDate(String date)
函數功能:	將YYYMMDDHHmmss轉換為YYY/MM/DD HH:mm:ss
傳入參數:	String date : YYYMMDDHHmmss
傳回值:	String YYY/MM/DD HH:mm:ss
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
public String parseDate(String date)
{
	String str = "";
		if (date.length() == 13) {
			str =
				date.substring(0, 3)
					+ "/"
					+ date.substring(3, 5)
					+ "/"
					+ date.substring(5, 7)
					+ " "
					+ date.substring(7, 9)
					+ ":"
					+ date.substring(9, 11)
					+ ":"
					+ date.substring(11, 13);
		}
		return str;
}

%>





<%
	//Server端程式由此正式開始
	//本程式主要之變數
	String strClientMsg = new String("");				//傳回給Client之訊息
	boolean bReturnStatus = true;						//各函數執行之結果
	//R00393   Edit by Leo Huang (EASONTECH) Start
	CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
    Calendar cldCalendar = commonUtil.getBizDateByRCalendar();
   //R00393   Edit by Leo Huang (EASONTECH)End
	java.util.Date dteToday = cldCalendar.getTime();		//目前日期時間

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
		if( 	objThisData.strActionCode.equalsIgnoreCase("H") ||		//確定
			objThisData.strActionCode.equalsIgnoreCase("J")	||		//上一頁 
			objThisData.strActionCode.equalsIgnoreCase("K") ||		//下一頁
			objThisData.strActionCode.equalsIgnoreCase("P")	)		//列印
		{//先檢查所有欄位是否正確
			siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","Processing Ok function");
			if( !checkFieldsServer( objThisData ) )
			{
				strClientMsg = siThisSessionInfo.getLastErrorMessage();
			}
			else
			{
				try
				{
					stmMainStatement = objThisData.conConnection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
					rstMainResultSet = stmMainStatement.executeQuery(objThisData.getInquirySql());
					if (objThisData.strActionCode.equalsIgnoreCase("P"))
					{
						siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,siThisSessionInfo.getUserInfo().getUserId(),objThisData.strActionCode,commonUtil.getROCDate(objThisData.dteLogStartDate)+"-"+commonUtil.getROCDate(objThisData.dteLogEndDate)+":"+objThisData.strFuncId+":"+objThisData.strUserId);
					}	
				}
				catch( Exception e )
				{
					siThisSessionInfo.setLastError(strThisProgId+"",e);
					strClientMsg = siThisSessionInfo.getLastErrorMessage();
				}
			}
		}
		else if( objThisData.strActionCode.equalsIgnoreCase("E") ) 		//離開
		{
			if( !objThisData.strCallingUrl.equals("") )
				response.sendRedirect(objThisData.strCallingUrl);
		}
	}
%>

<html>
<head>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5.3 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css">
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientR.js"></SCRIPT>
<title>系統稽核紀錄查詢/列印</title>
<STYLE>
<!--
	
	.PageEject{page-break-after: always;}
-->
</STYLE>
<SCRIPT language="JavaScript" >
var strFunctionKey="J,K,P,E";		//toolbar frame 中要顯示的功能鍵
								//H:確定, J:prev page, K:next page, P:print the report

// *************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title , '' , strFunctionKey,'' ) ;
	window.parent.frames['contentFrame'].focus();
	if( document.getElementById("txtAction").value == "P" )
	{
		if( window.navigator.appName.indexOf("Microsoft") != -1 )
		{
			printDirect();
			alert("列印完成");
			document.getElementById("frmMain").action = document.getElementById("txtCallingUrl").value;
			document.getElementById("txtAction").value = "H";
			document.getElementById("frmMain").submit();
		}
	}
	if( document.getElementById("txtMsg") != null )
	{
		if( document.getElementById("txtMsg").value != "" )
		{
			alert( document.getElementById("txtMsg").value );
			document.getElementById("txtAction").value = "E";
			document.getElementById("frmMain").action = document.getElementById("txtCallingUrl").value;
			document.getElementById("frmMain").submit();
		}
	}
}


/**
函數名稱:	ToolBarClick( String strButtonTag )
函數功能:	當toolbar frame中任一按鈕click時,就會執行本函數.當執行本函數時會傳入一個字串,
			該字串代表toolbar frame中哪一個按鈕被click
			當新增,修改按鈕時,先執行全部欄位檢查,若有任一欄位錯誤時,
			就顯示全部錯誤訊息,若正確時則將bntAction設定為傳入之參數值,
			並執行frmMain.submit(),將輸入之欄位傳送至web server
			若為查詢及刪除時,僅檢查鍵值是否正確,若正確,則將bntAction設定為傳入之參數值,
			並執行frmMain.submit(),將輸入之欄位傳送至web server
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
	if( strButtonTag == "E" )			//離開
	{
		document.getElementById("txtAction").value = "E";
		document.getElementById("frmMain").action = document.getElementById("txtCallingUrl").value;
		document.getElementById("frmMain").submit();
	}
	else if( strButtonTag == "J" )		//上一頁
	{
		if( document.getElementById("frmMain").txtCurrPage.value == "1" )
		{
			alert("已是第一頁");
		}
		else
		{
			document.getElementById("txtAction").value = "J";
			document.getElementById("frmMain").submit();
		}
	}
	else if( strButtonTag == "K" )		//下一頁
	{
		if( document.getElementById("frmMain").txtEofMark.value == "yes" )
		{
			alert("已是最後一頁");
		}
		else
		{
			document.getElementById("txtAction").value = "K";
			document.getElementById("frmMain").submit();
		}
	}
	else if( strButtonTag == "P" )		//列印
	{
		document.getElementById("txtAction").value = "P";
		document.getElementById("frmMain").submit();
	}
	else
	{//若有未處理的按鈕值,顯示錯誤訊息
		alert("The button flag = '"+strButtonTag+"' unhandled");
	}
}




</SCRIPT>

</head>

<BODY style="margin:0px" onload="WindowOnLoad();">

<DIV align="center" >


<%  
	int i = 0;
	boolean bHasData = false;

	//reset to the begining if the request is printing.
	if( objThisData.strActionCode.equalsIgnoreCase("J") )
	{
		objThisData.iTargetPage = objThisData.iCurrPage - 1;
		if( objThisData.iTargetPage <= 1 )
			objThisData.iTargetPage = 1;
		objThisData.iCurrPage = 1;
	}
	else if( objThisData.strActionCode.equalsIgnoreCase("K") )
	{
		objThisData.iTargetPage = objThisData.iCurrPage + 1;
		objThisData.iCurrPage = 1;
	}
	else if( objThisData.strActionCode.equalsIgnoreCase("P") ) 			//print
	{//if the request is printing then reset the current page to the first
		objThisData.iCurrPage = 1;
		objThisData.iCurrRow = 0;
		objThisData.iTargetPage = 1;
	}
	else if( objThisData.strActionCode.equalsIgnoreCase("I") ) 			//Ok.
	{
		objThisData.iCurrPage = 1;
		objThisData.iCurrRow = 0;
		objThisData.iTargetPage = 1;
	}
	//set eof mark on first, will be reset off later if it is not eof.
	objThisData.strEofMark = new String("yes");
	siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":service()","CurrPage='"+String.valueOf(objThisData.iCurrPage)+",'TargetPage='"+String.valueOf(objThisData.iTargetPage)+"'");

	//If there is no error, process the report, otherwise send the error message to client.
	if( strClientMsg.equals("") )
	{
		try
		{
			while( rstMainResultSet.next() )
			{ 
				bHasData = true;
				// iLineCnt equals 0 means this is the first line of this page
				//	(either first time enter or just after page eject,
				//	line excess iLinePerPage or controling variable change, 
				//	print out the page header.
				if( objThisData.iLineCnt == 0 )
				{
					printPageHeading( out, objThisData , rstMainResultSet);
				} //if( objThisData.iLineCnt == 0 )
				printDetailLine(out, rstMainResultSet, objThisData );
				//check whether this page is full. if it is, eject the page and if not in printing mode, break the loop.
				if( ++objThisData.iLineCnt >= iLinePerPage )
				{
					if( !objThisData.strActionCode.equalsIgnoreCase("P") )
					{
						if( objThisData.iCurrPage == objThisData.iTargetPage )
						{
							objThisData.strEofMark = new String("no");
							printPageFooter(out, objThisData , false);
							break;
						}
					}
					else
						printPageFooter(out, objThisData , true);
					objThisData.iLineCnt = 0;
					objThisData.iCurrPage++;
				}
			} //while( rstMainResultSet.next() )
			if( bHasData)
			{
				if(	objThisData.strEofMark.equalsIgnoreCase("yes") )
				{
					printPageFooter(out, objThisData , false);
					printReportFooter( out, objThisData );
				}
			}
			else
			{
				strClientMsg = new String("無符合條件之資料");
			}
		}
		catch( Exception ex )
		{
			siThisSessionInfo.setLastError(strThisProgId+":service()",ex);
			strClientMsg = siThisSessionInfo.getLastErrorMessage();
		}
	}//if( strClientMsg.equals("") )
%>  
</DIV>
<DIV align=left>
<form action="ReportOutput.jsp" id="frmMain" method="post" name="frmMain">
	<INPUT id=txtCallingUrl name=txtCallingUrl type=hidden value="<%=objThisData.strCallingUrl%>">
	<INPUT id=txtCurrRow name=txtCurrRow type=hidden value="<%=String.valueOf(objThisData.iCurrRow)%>">
	<INPUT id=txtCurrPage name=txtCurrPage type=hidden value="<%=String.valueOf(objThisData.iCurrPage)%>">
	<INPUT id=txtEofMark name=txtEofMark type=hidden value="<%=objThisData.strEofMark%>">
	<INPUT name="txtThisProgId" id="txtThisProgId" type="hidden" value="<%= strThisProgId %>">
	<INPUT name="txtAction" id="txtAction"  type="hidden" value="<%=objThisData.strActionCode%>">
	<INPUT name="txtMsg" id="txtMsg"  type="hidden" value="<%= strClientMsg %>">
	<INPUT name="txtLogStartDate" id="txtLogStartDate"  type="hidden" value="<%= commonUtil.getROCDate(objThisData.dteLogStartDate) %>">
	<INPUT name="txtLogEndDate" id="txtLogEndDate"  type="hidden" value="<%= commonUtil.getROCDate(objThisData.dteLogEndDate) %>">
	<INPUT name="txtUserId" id="txtUserId"  type="hidden" value="<%= objThisData.strUserId %>">
	<INPUT name="selFuncId" id="selFuncId"  type="hidden" value="<%= objThisData.strFuncId %>">
</FORM>
</DIV>
</body>
</html>
<%
	//release the connection before exit
	objThisData.releaseConnection();
%>
