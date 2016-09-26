<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.aegon.disb.disbremit.CAPPaymentVO"%>
<!--
/*
 * System   : 
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.2 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2012/08/29 09:18:45 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckCashFailList.jsp,v $
 * Revision 1.2  2012/08/29 09:18:45  ODCKain
 * Character problem
 *
 * Revision 1.1  2006/06/29 09:40:45  MISangel
 * Init Project
 *
 * Revision 1.1.2.3  2005/04/04 07:02:24  miselsa
 * R30530 支付系統
 *
 *  
 */
-->

<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>支票功能--票據回銷作業</TITLE>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css"><script LANGUAGE="javascript">

</SCRIPT>
</HEAD>
<BODY>
<table>
<tr><td>票據回銷作業成功筆數:</td><td><%=request.getAttribute("successCount")%> </td></tr></table>
<table >
<tr><td>票據回銷作業成功總金額:</td><td><%=request.getAttribute("successAmt")%> </td></tr>
</table>
<table >
<tr><td>未完成票據回銷的不正常資料如下所示 :</td></tr>
</table>
<TABLE border="0" cellpadding="0" cellspacing="0" width="100%">
	<TBODY>
		<TR>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25"><B><FONT size="2" face="細明體">序號</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25" width="64"><B><FONT size="2" face="細明體">保單號碼</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25"><B><FONT size="2" face="細明體">要保書號碼</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25" width="75"><B><FONT size="2" face="細明體">受款人姓名</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25" width="71"><B><FONT size="2" face="細明體">受款人</FONT><FONT
				face="細明體">ID</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25" width="75"><B><FONT size="2" face="細明體">支付金額</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25" width="65"><B><FONT size="2" face="細明體">票據號碼</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25" width="67"><FONT size="2" face="細明體"><B>付款內容</B></FONT></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25" width="60"><B><FONT size="2" face="細明體">付款日期</FONT></B></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				height="25"><FONT size="2" face="細明體"><B>付款方式</B></FONT></TD>
			<TD bgcolor="#c0c0c0"
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				height="25" width="50"><FONT size="2" face="細明體"><B>急件否</B></FONT></TD>
		</TR>
		<%
		Vector v = (Vector)request.getAttribute("failCheck");
		CAPPaymentVO vo;
		for(int index=0; index<v.size(); index++){
			vo = (CAPPaymentVO)v.get(index);
		%>	
		<TR id="data1">
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				width="25">&nbsp;<%=index+1%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				width="64">&nbsp;<%=vo.getPolicyNo()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 width="68">&nbsp;<%=vo.getAppNo()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid">
				&nbsp;<%=vo.getPName()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 width="71">&nbsp;<%=vo.getPId()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 align="right" width="75">&nbsp;<%=vo.getPAMT()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 align="right" width="65">&nbsp;<%=vo.getPCheckNO()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 width="75">&nbsp;<%=vo.getPDesc()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid">
				&nbsp;<%=vo.getPDate()%></TD>
			<TD
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 width="60">&nbsp;
				<%
				if("A".equals(vo.getPMethod().trim())) out.print("支票"); 
				else if ("B".equals(vo.getPMethod().trim())) out.print("匯款");
				else if("B".equals(vo.getPMethod().trim())) out.print("信用卡");
				%></TD>
			<TD
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				 width="40"><%=("Y".equals(vo.getPDispatch().trim())?"是":"否")%></TD>
		</TR>

		<%}%>

	</TBODY>
</TABLE>
<table >
<tr>
<td>總件數 : <%=request.getAttribute("failCount")%> </td>
<td></td>
<td></td>
<td>總金額 : <%=request.getAttribute("failAmt")%></td></tr></table>

</BODY>
</HTML>
