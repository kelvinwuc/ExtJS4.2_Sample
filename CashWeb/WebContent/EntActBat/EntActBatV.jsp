<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.entactbat.BankTemplateDTO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.2 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntActBatV.jsp,v $
 * Revision 1.2  2013/12/24 04:02:50  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */
%><%! String strThisProgId = "EntActBatB"; //本程式代號 %><% 
String strMsg = (request.getAttribute("txtMsg") == null)?"":(String)request.getAttribute("txtMsg");
BankTemplateDTO dto = (BankTemplateDTO)request.getAttribute("DTO");
%>
<html>
<head>
<title>銀行登帳格式模板展示頁面</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT>
<!--
function WindowOnLoad() 
{
	if(document.getElementById("txtMsg").value!="") {
		alert(document.getElementById("txtMsg").value);
	}

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry,'' ) ;
	window.status = "";
}

function updateAction()
{
	document.getElementById("PAGETYPE").value ="UV";
	document.frmMain.submit();
}

function deleteAction()
{
	document.getElementById("PAGETYPE").value ="DE"; 
    document.frmMain.submit();
}

function exitAction()
{
	document.getElementById("PAGETYPE").value ="";
	window.location.href = "<%=request.getContextPath()%>/EntActBat/EntActBatTemplate.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<BR>
<FORM name="frmMain" METHOD="POST" ACTION="<%=request.getContextPath()%>/servlet/com.aegon.entactbat.EntActBatTemplateServlet" >
<div>
	<table>
		<TR>
			<TD>金融簡碼:*</TD>
			<TD><%=dto.getBankCode()%><input type="hidden" name="BKALAT" id="BKALAT" value="<%=dto.getBankCode()%>"></TD>
		</TR>
		<TR>
			<TD>上傳登帳文檔類型:</TD>
			<TD>
				<% if("T".equals(dto.getFileType())){ %>      
                        TXT
				<%}else if("C".equals(dto.getFileType())){%>	
                        CSV
				<%}else if("F".equals(dto.getFileType())){%>	
                        FLT
				<%}else if("D".equals(dto.getFileType())){%>
                        DAT
				<%}%>
			</TD>
		</TR>
		<TR>
			<TD>分割文檔方式:</TD>
			<TD>
				<%if("F".equals(dto.getSplitFileType())){%>
                                                           取定長
				<%}else if("S".equals(dto.getSplitFileType())){%>
                      ;分隔
				<%}else if("C".equals(dto.getSplitFileType())){%>
                      ,分隔
				<%}%>
			</TD>
		</TR>
		<%if("F".equals(dto.getSplitFileType())){ %>
		<TR>
			<TD>日期欄位格式:</TD>
			<TD>
				<%if("M".equals(dto.getDateTpye())){ %>
                                                                        民國年
				<%}else if("B".equals(dto.getDateTpye())){ %>
                                                                        民國年後兩碼
				<%}else{ %>
                                                                       西元年
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>日期是否有分隔符號"/"</TD>
			<TD>
				<%if("Y".equals(dto.getIsSlant())){ %>
                                                                      是                                          
				<%}else{ %>
                                                                     否                                             
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>交易金額欄位:</TD>
			<TD>起位:&nbsp;<%=dto.getFeeStart() %>&nbsp;——迄位&nbsp;<%=dto.getFeeEnd()%></TD>
		</TR> 
		<TR>
			<TD>交易金額欄位組成結構:</TD>
			<TD>
				<%if("Y".equals(dto.getIsLeftZero())){ %>
                                                                    右靠左補零&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsLeftSpace())){ %>
                                                                    右靠左補空&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsPoint())){ %>
                                                                    小數點&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsTwoNum())){ %>
                                                                    兩位小數&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsPermille())){ %>
                                                                    千分號&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsFristNum())){ %>
                                                                    第1碼為正負號&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIslastNum())){ %>
                                                                    最後1碼負號或空白&nbsp;
				<%}%>
			</TD>
		</TR>
		<TR>
			<TD>備註欄位:</TD>
			<TD>起位:&nbsp;<%=dto.getConStart() %>&nbsp;——迄位&nbsp;<%=dto.getConEnd()%></TD>
		</TR> 
		<%}else{ %>
		<TR>
			<TD>日期欄位格式:</TD>
			<TD>
				<%if("M".equals(dto.getDateTpye())){ %>
                                                                        民國年
				<%}else if("B".equals(dto.getDateTpye())){ %>
                                                                        民國年後兩碼
				<%}else{ %>
                                                                       西元年
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>日期是否有分隔符號"/"</TD>
			<TD>
				<%if("Y".equals(dto.getIsSlant())){ %>
                                                                      是                                          
				<%}else{ %>
                                                                     否                                             
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>分隔欄位數:</TD>
			<TD><%=dto.getSplitNum() %></TD>
		</TR>   
		<TR>
			<TD>日期欄位排列位:</TD>
			<TD><%=dto.getDateIndex()%></TD>
		</TR> 
		<TR>
			<TD>交易金額位排列位:</TD>
			<TD><%=dto.getFeeIndex()%></TD>
		</TR>  
		<TR>
			<TD>交易金額欄位有千分號:</TD>
			<TD>
				<%if("Y".equals(dto.getIsPermille())){%>
                                                                    是
				<%}else{ %>
                                                                   否
				<%} %>
			</TD>
		</TR> 
		<TR>
			<TD>備註排列位:</TD>
			<TD><%=dto.getConIndex()%></TD>
		</TR>   
		<%} %>
	</TABLE>
</div>
<input type="hidden" id="PAGETYPE" name="PAGETYPE"> 
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<input type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>"> 
</FORM>
</BODY>
</HTML>