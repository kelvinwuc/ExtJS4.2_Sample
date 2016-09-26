<!--
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393    Leo Huang    			2010/09/23          絕對路徑轉相對路徑
 *  =============================================================================
 */

-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page 
language="java"
contentType="text/html; charset=BIG5"
pageEncoding="BIG5"
%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.text.*" %>
<%@ include file="../Logon/Init.inc" %>
<%@ include file="../Logon/CheckLogon.inc" %>
<%! 
    String strThisProgId = "FileUpload";  
	DecimalFormat df = new DecimalFormat(",000.00");   //added for Q50088 -->金額過太導致上傳失敗的問題
%>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="../Theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>CASHFileUploadResult.jsp</TITLE>
</HEAD>
<BODY>
<%
    Vector v = (Vector)request.getAttribute("UPLOADFILE");
    int success = 0;
    int fail = 0;
    int backit = 0;
    float sAmt = 0;
    float fAmt = 0;
    float bAmt = 0;
    
    for(int i = 0; i < v.size(); i++) {
        Hashtable line = (Hashtable)v.elementAt(i);
        String strType = (String)line.get("FLD0008");
        String strAmt = (String)line.get("FLD0004");
       // int intAmt = Integer.parseInt(strAmt); marked for Q50088 -->金額過太導致上傳失敗的問題
       double dAmt = Double.parseDouble(strAmt); //added for Q50088 -->金額過太導致上傳失敗的問題
        
        if(strType.equals("1")) {
            success++;
            //sAmt = sAmt + (float)intAmt/100.0f; marked for Q50088 -->金額過太導致上傳失敗的問題
            sAmt = sAmt + (float)dAmt/100.0f; //added for Q50088 -->金額過太導致上傳失敗的問題
        } else if(strType.equals("2")) {
            fail++;
            //fAmt = fAmt + (float)intAmt/100.0f; marked for Q50088 -->金額過太導致上傳失敗的問題
            fAmt = fAmt + (float)dAmt/100.0f; //added for Q50088 -->金額過太導致上傳失敗的問題
        } else if(strType.equals("3")) {
            backit++;
            //bAmt = bAmt + (float)intAmt/100.0f;  marked for Q50088 -->金額過太導致上傳失敗的問題
            bAmt =bAmt + (float)dAmt/100.0f;  //added for Q50088 -->金額過太導致上傳失敗的問題
        }
    }
%>
檔案上傳成功!
<TABLE border="1" width="397" height="50">
	<TBODY>
		<TR>
			<TD colspan="3" bgcolor="#c0c0c0">支票託收兌現 - 檔案上傳作業</TD>
		</TR>
		<TR>
			<TD width="36%" bgcolor="#c0c0c0"></TD>
			<TD bgcolor="#c0c0c0" align="center" width="27%">筆數</TD>
			<TD bgcolor="#c0c0c0" align="center" width="41%">金額</TD>
		</TR>
		<TR>
			<TD width="36%" bgcolor="#8080ff">兌現</TD>
			<TD align="right" width="27%"><%= success %></TD>
			<TD align="right" width="41%"><%= df.format(sAmt) %></TD>
		</TR>
		<TR>
			<TD width="36%" bgcolor="#8080ff">退票</TD>
			<TD align="right" width="27%"><%= fail %></TD>
			<TD align="right" width="41%"><%= df.format(fAmt) %></TD>
		</TR>
		<TR>
			<TD width="36%" bgcolor="#8080ff">領回</TD>
			<TD align="right" width="27%"><%= backit %></TD>
			<TD align="right" width="41%"><%= df.format(bAmt) %></TD>
		</TR>
		<TR>
			<TD width="36%" bgcolor="#8080ff">全部</TD>
			<TD align="right" width="27%"><%= v.size() %></TD>
			<TD align="right" width="41%"><%= df.format(sAmt + fAmt + bAmt)%></TD>
		</TR>
	</TBODY>
</TABLE>
<!--R00393
<a href="/CashWeb/BBSShow/PersonalNews.jsp">回首頁</a>
-->
<a href="../BBSShow/PersonalNews.jsp">回首頁</a>
</BODY>
</HTML>
