<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ include file="/Logon/Init.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : �޲z�\��--����Ȧ�
 * 
 * Remark   : ��ܰT��
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
 * QA0132-�����ɮפ� SWIFT CODE�ɮ׺��@
 * 1.�\��u�s�W����X�v�W�[�ˮ֤��o���ŭȡC
 * 2.�\��u����Ȧ��ɡv
 *    2.1��~SWIFT CODE�e�����áC
 *    2.2�W�[�ˮ֤��o�W�Ǫ��ɡC
 *    2.3�W�[�ˮ֪���N�X���ץ�����7��Ʀr�A�_�h��ܥ��Ѫ��O���F�Y����ɦ����~�T���h��������s�A�B��ܥ��Ѫ��O���C
 *
 *  
 */
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�޲z�\��--����Ȧ�</TITLE>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
</HEAD>
<BODY>
<table><tr><td>�s�W���\����:</td><td><%=request.getAttribute("insertCount")%> </td></tr></table>
<table><tr><td>��s���\����:</td><td><%=request.getAttribute("successCount")%> </td></tr></table>
<table><tr><td>���ѵ���:</td><td><%=request.getAttribute("failCount")%> </td></tr></table>
<table><tr><td>���ѰO��:</td><td><%=request.getAttribute("failRec")!=null?request.getAttribute("failRec"):"N/A"%> </td></tr></table>
<table><tr><td>�`��� : <%=request.getAttribute("totalCount")%> </td></tr></table>
</BODY>
</HTML>
