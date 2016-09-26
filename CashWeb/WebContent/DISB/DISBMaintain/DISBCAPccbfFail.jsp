<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 管理功能--金資銀行
 * 
 * Remark   : 顯示訊息
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 2010/11/23 02:21:59
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: DISBCAPccbfFail.jsp,v $
 * Revision 1.3  2012/06/18 09:35:40  MISSALLY
 * QA0132-金資檔案及 SWIFT CODE檔案維護
 * 1.功能「新增金資碼」增加檢核不得為空值。
 * 2.功能「金資銀行檔」
 *    2.1國外SWIFT CODE畫面隱藏。
 *    2.2增加檢核不得上傳空檔。
 *    2.3增加檢核金資代碼長度必須為7位數字，否則顯示失敗的記錄；若執行時有錯誤訊息則全部不更新，且顯示失敗的記錄。
 *
 *  
 */
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>管理功能--金資銀行</TITLE>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
</HEAD>
<BODY>
<table><tr><td>新增成功筆數:</td><td><%=request.getAttribute("insertCount")%> </td></tr></table>
<table><tr><td>更新成功筆數:</td><td><%=request.getAttribute("successCount")%> </td></tr></table>
<table><tr><td>失敗筆數:</td><td><%=request.getAttribute("failCount")%> </td></tr></table>
<table><tr><td>失敗記錄:</td><td><%=request.getAttribute("failRec")!=null?request.getAttribute("failRec"):"N/A"%> </td></tr></table>
<table><tr><td>總件數 : <%=request.getAttribute("totalCount")%> </td></tr></table>
</BODY>
</HTML>
