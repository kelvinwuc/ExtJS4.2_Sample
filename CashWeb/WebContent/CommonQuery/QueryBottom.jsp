<!--DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"-->
<%@ page contentType="text/html;charset=BIG5" %>
<%@ page import="java.text.*" %>
<%@ include file="../Logon/Init.inc" %>
<%@ include file="../Logon/CheckLogonCommon.jsp" %><%!
	DecimalFormat df = new DecimalFormat("###.00");
	DecimalFormat df4 = new DecimalFormat("###.0000");
	NumberFormat idf = new DecimalFormat( "###,###,###,###,##0" );
%><%
//	System.out.println(System.getProperty("file.encoding"));
	String strDelimiter = new String(",");//delimeter for the displayfields and returnfields
	String strClientMsg = new String("");
	//R00393
	DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
	String strHeading = new String("");
	String strDisplayFields = new String("");
	String strSql = new String("");
	String strReturnFields = new String("");
	int iRowPerPage = 0;
	int iTableWidth = 0;

	if(request.getQueryString() != null )
	{	// called from the other program
		strHeading = (String)session.getAttribute("Heading");
		strDisplayFields = (String)session.getAttribute("DisplayFields");
		strReturnFields = (String)session.getAttribute("ReturnFields");
		strSql = (String)session.getAttribute("Sql");
		
		if(request.getParameter("parm") != null && request.getParameter("parm").equals("parm"))
		{
			strHeading = (String)session.getAttribute("Heading2");
			strDisplayFields = (String)session.getAttribute("DisplayFields2");
			strReturnFields = (String)session.getAttribute("ReturnFields2");
		}
		iRowPerPage = Integer.parseInt(request.getParameter("RowPerPage"));
		iTableWidth = Integer.parseInt(request.getParameter("TableWidth"));
	}
	else
	{	// called from self
		strHeading = request.getParameter("txtHeading");
		strDisplayFields = request.getParameter("txtDisplayFields");
		strSql = request.getParameter("txtSql");
		strReturnFields = request.getParameter("txtReturnFields");
		iRowPerPage = Integer.parseInt(request.getParameter("txtRowPerPage"));
		iTableWidth = Integer.parseInt(request.getParameter("txtTableWidth"));
	}
    strSql = strSql.replace('^','%');
	int iPageNo = 1;
	int iEndOfData = 0;
	String strAction = new String("");

	if(request.getParameter("txtPageNo") != null )
		iPageNo = Integer.parseInt(request.getParameter("txtPageNo"));
	
	if(request.getParameter("txtAction") != null )
		strAction = request.getParameter("txtAction");
	
	Connection con = null;
	ResultSet rs   = null;
	Statement stmt = null;
	try{
		con = dbFactory.getConnection("QueryBottom");
	}catch(Exception ex){
		ex.printStackTrace();
		strClientMsg = "Exception in getting connection"+ex.getMessage();
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,"QueryBottom.jsp",strClientMsg);
	}

	try
	{
		System.out.println("QuerySql="+strSql);
		stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		rs = stmt.executeQuery(strSql);				
	}
	catch(SQLException sq)
	{
		sq.printStackTrace();
		strClientMsg = "SQL exception"+sq.getMessage();
		siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,"QueryBottom.jsp",strClientMsg);
	} 

/*
		J:Previous
		K:Next
		Y:First				
		Z:Last
*/	
	if(strAction.equals("J"))
	{
		if( iPageNo > 1 )
			iPageNo--;
	}
	else if(strAction.equals("K"))		//下一頁
	{
		iPageNo++;
	}
	else if(strAction.equals("Y"))		//最前頁
	{
		iPageNo = 1;
	}
	else if(strAction.equals("Z"))		//最終頁
	{
		iPageNo = 0;
	}

	// R00217 台幣匯款手續費
	String queryType = request.getParameter( "queryType" );
	String queryCurr = request.getParameter( "queryCurr" );
	String strMaxRemFee = "0";
	boolean showRemFeeArea = false;

	if( queryType != null && queryType.equals( "RemittanceFee" ) ) {
	    if( queryCurr != null && queryCurr.length() > 0 ) {

	    	String sql = "SELECT FLD003, FLD004 FROM BANKFEE WHERE FLD002 = '" + queryCurr + "' ORDER BY FLD004 DESC";

	    	Statement mtStat = null;
	    	ResultSet myRs = null;
	    	try{
	    	    mtStat = con.createStatement();
	    	    myRs = mtStat.executeQuery( sql );
	    	    if( myRs.next() )
	    	        strMaxRemFee = idf.format( myRs.getInt( "FLD004" ) );

	    	    showRemFeeArea = true;

	    	} catch(SQLException sq) {
	    		sq.printStackTrace();
	    		strClientMsg = "SQL exception"+sq.getMessage();
	    		siThisSessionInfo.writeDebugLog(Constant.DEBUG_ERROR,"QueryBottom.jsp",strClientMsg);
	    	} finally {

	    	    if( myRs != null )
	    	        try{ myRs.close(); } catch( Exception e ) {}
	    	    if( mtStat != null )
	    	        try{ mtStat.close(); } catch( Exception e ) {}

	    	}
	    }
	}
%>
<HTML>
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" >
<!--
var oToolBar = "";
var iToolBar = 0;
var iInterval = "";
var winToolBar = "";
var strFunctionKeyFirstPage = "KZE";
var strFunctionKeyLastPage = "JYE";
var strFunctionKeyOnlyOnePageAndNoData = "E";
var strFunctionKeyNormal = "YKJZE";

function OnLoad()
{
	var i,j;
	var strThisFunctionKey = "";
	var iEndOfData = parseInt(document.getElementById("txtEndOfData").value);
	var iPageNo = parseInt(document.getElementById("txtPageNo").value);
	var showRemFeeArea = <%= showRemFeeArea %>;

	window.parent.returnValue = "";
	if( document.getElementById("txtMsg").value != "" )
	{
		alert( document.getElementById("txtMsg").value );
		window.parent.close();
	}

	if( iEndOfData == 1 )
	{
		if( iPageNo == 1 )
			strThisFunctionKey = strFunctionKeyOnlyOnePageAndNoData;
		else
			strThisFunctionKey = strFunctionKeyLastPage;
	}
	else
	{
		if( iPageNo == 1 )
			strThisFunctionKey = strFunctionKeyFirstPage;
		else
			strThisFunctionKey = strFunctionKeyNormal;
	}

	if( window.parent.frames.length != 0 )
	{
		i = 0;
		while( i < window.parent.frames.length )
		{
			var winTarget = window.parent.frames[i];
			if( winTarget.name == 'top' )
			{
				iToolBar = i;
				oToolBar = window.setInterval("checkTopWindowState('"+strThisFunctionKey+"')",100);
			}
			i++;
		} 
	}

	//
	if( showRemFeeArea ) {
		var ele = document.getElementById("remittanceFeeDataArea");
		if( ele )
			ele.style.display = "block";
	}
}

function OnClick( strReturnValue )
{
	window.parent.returnValue = strReturnValue;
	window.parent.close();
}

function ToolBarOnClick( strButtonTag )
{
	if( iInterval != "" )
	{
		window.clearInterval(iInterval);
		iInterval = "";
	}
	if( strButtonTag == "J" )			//上一頁
	{
		document.getElementById("txtAction").value = strButtonTag ;
		document.getElementById("frmMain").submit();
	}
	else if( strButtonTag == "K" )		//下一頁
	{
		document.getElementById("txtAction").value = strButtonTag ;
		document.getElementById("frmMain").submit();
	}
	else if( strButtonTag == "Y")		//最前頁
	{
		document.getElementById("txtAction").value = strButtonTag ;
		document.getElementById("frmMain").submit();
	}
	else if( strButtonTag == "Z" )		//最終頁
	{
		document.getElementById("txtAction").value = strButtonTag ;
		document.getElementById("frmMain").submit();
	}
	else if( strButtonTag == "E" )		//離開鈕
	{
		window.parent.close();
	}
	else
	{//若有未處理的按鈕值,顯示錯誤訊息
		alert("The button flag = '"+strButtonTag+"' unhandled");
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY onload="OnLoad();">

<div id="remittanceFeeDataArea" style="display: none; margin: 15px;" >
	<table>
		<tbody>
			<tr>
				<td width="150">
					<span style="martin-top: 8px; padding-left: 5px;">匯款金額上限</span>
				</td>
				<td width="450" >
						幣別 <input type="text" value="<%= queryCurr %>" disabled="disabled" style="width: 60px;">
						金額<input type="text" value="<%= strMaxRemFee %>" disabled="disabled" style="width: 200px;">
				</td>
			</tr>
		</tbody>
	</table>
</div>

<TABLE align=center border=1 width="<%=iTableWidth%>">
	<THEAD class=queryHead>
		<TR>
<%
	String strTmpHeading = "";
	try{
		strTmpHeading = new String(strHeading.getBytes((String)System.getProperty("file.encoding")),"BIG5");
	}catch(Exception ex){
		System.err.println(ex.getMessage());
	}
	String strOneHeading = new String("");
	String strTmpDisplayFields = new String(strDisplayFields);
	String strOneField = new String("");
	Vector vDisplayFields  = new Vector();
	int i = 0;
	String strTmpReturnFields = new String(strReturnFields);
	Vector vReturnFields  = new Vector();

	while(!strTmpReturnFields.equals(""))
	{
		if( strTmpReturnFields.indexOf(strDelimiter) == -1 )
		{
			strOneField = strTmpReturnFields;
			strTmpReturnFields = new String("");
		}
		else
		{
			strOneField = strTmpReturnFields.substring(0,strTmpReturnFields.indexOf(strDelimiter));
			strTmpReturnFields = strTmpReturnFields.substring(strTmpReturnFields.indexOf(strDelimiter)+1,strTmpReturnFields.length());
		}
		vReturnFields.addElement(strOneField);
	}

	i = 0;
	while(!strTmpDisplayFields.equals(""))
	{
		if( strTmpDisplayFields.indexOf(strDelimiter) == -1 )
		{
			strOneField = strTmpDisplayFields;
			strTmpDisplayFields =new String("");
		}
		else
		{
			strOneField = strTmpDisplayFields.substring(0,strTmpDisplayFields.indexOf(strDelimiter));
			strTmpDisplayFields = strTmpDisplayFields.substring(strTmpDisplayFields.indexOf(strDelimiter)+1,strTmpDisplayFields.length());
		}
		vDisplayFields.addElement(strOneField);
	}
	
	while(!strTmpHeading.equals(""))
	{
		if( strTmpHeading.indexOf(strDelimiter) == -1 )
		{
			strOneHeading = strTmpHeading;
			strTmpHeading = new String("");
		}
		else
		{
			strOneHeading = strTmpHeading.substring(0,strTmpHeading.indexOf(strDelimiter));
			strTmpHeading = strTmpHeading.substring(strTmpHeading.indexOf(strDelimiter)+1,strTmpHeading.length());
		}
		out.println("<TD align=center><font face=\"MingLiu\">"+strOneHeading+"</font></TD>");
	}
%>
		</TR>
	<TBODY class=queryBody>
<%
	String strReturnValue = new String("");
	String strTmpStr = new String("");
	CommonUtil commonUtil = new CommonUtil();
	int iCurrentRow = 0;
	int iRecordCount = 0;

	if( iPageNo == 0 ) //lastpage
	{
		//to get the total record count
		rs.last();
		iRecordCount = rs.getRow();
		rs.beforeFirst();

		int iTmpPageNo = (int)Math.ceil( (double)iRecordCount / iRowPerPage );
		iPageNo = iTmpPageNo;
	}
	iCurrentRow = ((iPageNo-1) * iRowPerPage);
	if( iCurrentRow < 0 )
		iCurrentRow = 0;

	if(rs.first())//check whether the resultset is empty
	{
		if(iCurrentRow != 0)
			rs.absolute(iCurrentRow);
		else
			rs.previous();//to compensate for rs.first()		
	}else{
		strClientMsg = "無符合條件之資料";
	}
	if(rs.isAfterLast())
	{
		strClientMsg = "無符合條件之資料";
	}	
	int iRowProcessed = 0;
	
	String strFieldName = null;
	
	Hashtable htDisplayFields = new Hashtable();

	while(rs.next())
	{
		out.println("<TR>");
		strReturnValue = "";
		htDisplayFields.clear();
		for( int iIndex=1;iIndex <= rs.getMetaData().getColumnCount() ; iIndex++ )
		{
			strFieldName = rs.getMetaData().getColumnName(iIndex);
			int FieldScale = rs.getMetaData().getScale(iIndex);
			if( !vReturnFields.contains( strFieldName ) && !vDisplayFields.contains( strFieldName ) )
				continue;

			switch(rs.getMetaData().getColumnType(rs.findColumn(strFieldName)))
			{
				case Types.DATE:
					strTmpStr = commonUtil.checkDateFomat(commonUtil.convertWesten2ROCDate(rs.getDate(strFieldName)));
					break;
				case Types.TIMESTAMP:
					strTmpStr = commonUtil.checkDateFomat(commonUtil.convertWesten2ROCDate(rs.getDate(strFieldName)));
					break;	
				case Types.TINYINT:	
				case Types.SMALLINT:	
					strTmpStr = String.valueOf(rs.getByte(strFieldName));
					break;
				case Types.INTEGER:	
					strTmpStr = String.valueOf(rs.getInt(strFieldName));
					break;
				case Types.BIGINT:
					strTmpStr = String.valueOf(rs.getInt(strFieldName));
					break;
				case Types.REAL:
					strTmpStr = String.valueOf(rs.getDouble(strFieldName));
					break;
				case Types.FLOAT:	
					strTmpStr = String.valueOf(rs.getFloat(strFieldName));
					break;
				case Types.DOUBLE:	
				case Types.DECIMAL:	
				case Types.NUMERIC:
					if(FieldScale==4){
					   strTmpStr = df4.format(rs.getDouble(strFieldName));
					}else{
					   strTmpStr = df.format(rs.getDouble(strFieldName));
					}
					break;
				default:	
					strTmpStr = (String)rs.getObject(strFieldName);
					break;
			}

			if( vReturnFields.contains( strFieldName ) )
			{
				if( strReturnValue != "" )
					strReturnValue += ",";

			    if(strFieldName.equals("PDATE")||strFieldName.equals("PCSHDT")||strFieldName.equals("PCFMDT1")||strFieldName.equals("PCFMDT2")||strFieldName.equals("ENTRYDT")||strFieldName.equals("PCSHCM")||strFieldName.equals("CHEQUE_USED_DATE")||strFieldName.equals("CHEQUE_DATE")){
			    	if(strTmpStr!=null)
			    		strTmpStr=commonUtil.checkDateFomat(strTmpStr.trim());
			    }

				if( strTmpStr != null )
					strReturnValue += strTmpStr.trim();
				else
				{
					strTmpStr = "";
					strReturnValue += strTmpStr;
				}
			}
			if( vDisplayFields.contains( strFieldName ) )
			{
				if( strTmpStr == null )
					strTmpStr = new String("");

			    if(strFieldName.equals("ENTRYDT")||strFieldName.equals("CUSEDT")||strFieldName.equals("PCSHCM")||strFieldName.equals("ENTRY_DATE"))
					strTmpStr=commonUtil.checkDateFomat(strTmpStr.trim());

				htDisplayFields.put( strFieldName , strTmpStr.trim() );
			}
			
		}
		for( int j=0;j<vDisplayFields.size();j++)
			out.print("<TD><A href=# onclick=\"OnClick('"+strReturnValue.trim()+"');\">"+(String)htDisplayFields.get((String)vDisplayFields.elementAt(j))+"</A></TD>");

		out.println("</TR>");
		if( rs.isAfterLast())
			iEndOfData = 1;
		if( ++iRowProcessed >= iRowPerPage )
			break;
	}
	rs.close();
%>
	</TBODY>
</TABLE>
<%
    if( rs != null )
        try{ rs.close(); }catch( Exception e ) {}
    if( stmt != null )
        try{ stmt.close(); }catch( Exception e ) {}
    if( con != null )
		try{ uiThisUserInfo.getDbFactory().releaseConnection(con); }catch( Exception e ) {}
	
%>	

<FORM id="frmMain" name="frmMain" action="QueryBottom.jsp" method="post">
	<INPUT type=hidden id="txtAction"  name="txtAction" value="<%=strAction%>" >
	<INPUT type=hidden id="txtPageNo"  name="txtPageNo" value="<%=iPageNo%>" >
	<INPUT type=hidden id="txtEndOfData" name="txtEndOfData" value="<%=iEndOfData%>" >
	<INPUT type=hidden id="txtHeading" name="txtHeading" value="<%=strHeading%>" >
	<INPUT type=hidden id="txtDisplayFields" name="txtDisplayFields" value="<%=strDisplayFields%>" >
	<INPUT type=hidden id="txtSql" name="txtSql" value="<%=strSql%>" >
	<INPUT type=hidden id="txtReturnFields" name="txtReturnFields" value="<%=strReturnFields%>" >
	<INPUT type=hidden id="txtRowPerPage" name="txtRowPerPage" value="<%=iRowPerPage%>" >
	<INPUT type=hidden id="txtRecordCount" name="txtRecordCount" value="<%=iRecordCount%>" >
	<INPUT type=hidden id="txtTableWidth" name="txtTableWidth" value="<%=iTableWidth%>" >
	<INPUT type=hidden id="txtMsg" name="txtMsg" value="<%=strClientMsg%>" >
	<INPUT type=hidden id="queryType" name="queryType" value="<%=queryType%>" >
	<INPUT type=hidden id="queryCurr" name="queryCurr" value="<%=queryCurr%>" >
</FORM>
</BODY>
</HTML>