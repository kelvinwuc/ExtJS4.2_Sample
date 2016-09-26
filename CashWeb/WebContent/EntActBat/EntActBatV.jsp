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
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */
%><%! String strThisProgId = "EntActBatB"; //���{���N�� %><% 
String strMsg = (request.getAttribute("txtMsg") == null)?"":(String)request.getAttribute("txtMsg");
BankTemplateDTO dto = (BankTemplateDTO)request.getAttribute("DTO");
%>
<html>
<head>
<title>�Ȧ�n�b�榡�ҪO�i�ܭ���</title>
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
			<TD>����²�X:*</TD>
			<TD><%=dto.getBankCode()%><input type="hidden" name="BKALAT" id="BKALAT" value="<%=dto.getBankCode()%>"></TD>
		</TR>
		<TR>
			<TD>�W�ǵn�b��������:</TD>
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
			<TD>���Τ��ɤ覡:</TD>
			<TD>
				<%if("F".equals(dto.getSplitFileType())){%>
                                                           ���w��
				<%}else if("S".equals(dto.getSplitFileType())){%>
                      ;���j
				<%}else if("C".equals(dto.getSplitFileType())){%>
                      ,���j
				<%}%>
			</TD>
		</TR>
		<%if("F".equals(dto.getSplitFileType())){ %>
		<TR>
			<TD>������榡:</TD>
			<TD>
				<%if("M".equals(dto.getDateTpye())){ %>
                                                                        ����~
				<%}else if("B".equals(dto.getDateTpye())){ %>
                                                                        ����~���X
				<%}else{ %>
                                                                       �褸�~
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>����O�_�����j�Ÿ�"/"</TD>
			<TD>
				<%if("Y".equals(dto.getIsSlant())){ %>
                                                                      �O                                          
				<%}else{ %>
                                                                     �_                                             
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>������B���:</TD>
			<TD>�_��:&nbsp;<%=dto.getFeeStart() %>&nbsp;�X�X����&nbsp;<%=dto.getFeeEnd()%></TD>
		</TR> 
		<TR>
			<TD>������B���զ����c:</TD>
			<TD>
				<%if("Y".equals(dto.getIsLeftZero())){ %>
                                                                    �k�a���ɹs&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsLeftSpace())){ %>
                                                                    �k�a���ɪ�&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsPoint())){ %>
                                                                    �p���I&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsTwoNum())){ %>
                                                                    ���p��&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsPermille())){ %>
                                                                    �d����&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIsFristNum())){ %>
                                                                    ��1�X�����t��&nbsp;
				<%}%>
				<%if("Y".equals(dto.getIslastNum())){ %>
                                                                    �̫�1�X�t���Ϊť�&nbsp;
				<%}%>
			</TD>
		</TR>
		<TR>
			<TD>�Ƶ����:</TD>
			<TD>�_��:&nbsp;<%=dto.getConStart() %>&nbsp;�X�X����&nbsp;<%=dto.getConEnd()%></TD>
		</TR> 
		<%}else{ %>
		<TR>
			<TD>������榡:</TD>
			<TD>
				<%if("M".equals(dto.getDateTpye())){ %>
                                                                        ����~
				<%}else if("B".equals(dto.getDateTpye())){ %>
                                                                        ����~���X
				<%}else{ %>
                                                                       �褸�~
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>����O�_�����j�Ÿ�"/"</TD>
			<TD>
				<%if("Y".equals(dto.getIsSlant())){ %>
                                                                      �O                                          
				<%}else{ %>
                                                                     �_                                             
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>���j����:</TD>
			<TD><%=dto.getSplitNum() %></TD>
		</TR>   
		<TR>
			<TD>������ƦC��:</TD>
			<TD><%=dto.getDateIndex()%></TD>
		</TR> 
		<TR>
			<TD>������B��ƦC��:</TD>
			<TD><%=dto.getFeeIndex()%></TD>
		</TR>  
		<TR>
			<TD>������B��즳�d����:</TD>
			<TD>
				<%if("Y".equals(dto.getIsPermille())){%>
                                                                    �O
				<%}else{ %>
                                                                   �_
				<%} %>
			</TD>
		</TR> 
		<TR>
			<TD>�Ƶ��ƦC��:</TD>
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