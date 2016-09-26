<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.entCroInq.EntCroInqVO"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �n�P�b�d��
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.10 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntCroInq_1.jsp,v $
 * Revision 1.10  2014/03/12 05:56:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-04
 * �ץ����B��ܪ����D
 *
 * Revision 1.9  2014/02/21 07:33:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-03
 * �٭�
 *
 * Revision 1.8  2014/02/19 08:52:30  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-03
 * �٭�
 *
 * Revision 1.7  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%><%! String strThisProgId = "EntCroInq"; //���{���N�� %><%
GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
DecimalFormat df = new DecimalFormat("#,###,###,###,###.00");
Vector v = new Vector();
int pageNo = 0;
int pageSize = 30;
String sumAmt = "0";
if(request.getAttribute("VO")!=null){
  	v = (Vector)request.getAttribute("VO");
	pageNo = Integer.parseInt((String)request.getAttribute("PAGEINDEX"));
	sumAmt = (String)request.getAttribute("SUMAMT");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>�n�P�b�d��</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script language="javaScript">
<!--
function doSubmit(page) {
	if(page < 0 )
		page = 0;
	window.parent.document.mainForm.PAGEINDEX.value = page;
	window.parent.document.mainForm.submit();
}
//-->
</script>
</HEAD>
<body bgcolor="#ffffff">
<TABLE>
<TR align="right">
<TD>�`���� : <%=v.size()%> </TD><TD> �`���B : <%=sumAmt%></TD>
<TD>
<%if(pageNo > 0 ){
	out.println("<input type=button name='�W�@��' value='�W�@��' onClick='doSubmit("+(pageNo-1)+");' >");
  }else{
	out.println("<input type=button name='�W�@��' value='�W�@��' onClick='doSubmit("+(pageNo-1)+");' disabled>");
  }
  if((pageNo+1) * pageSize < v.size()){
  	out.println("<input type=button name='�U�@��' value='�U�@��' onClick='doSubmit("+(pageNo+1)+");' >");
  }else{
  	out.println("<input type=button name='�U�@��' value='�U�@��' onClick='doSubmit("+(pageNo+1)+");' disabled>");
  }
%>
</TD>
</TR>
</TABLE>
<%if(v.size()>0){%>
<TABLE width="80%" border=1>
	<THEAD>
		<TR align="center">
			<TD>NO.</TD>
			<TD>���ĳ��N�X</TD>
			<TD>�b��</TD>
			<TD>�״ڤ�</TD>
			<TD>�״ڪ��B</TD>
			<TD>���y�J�b��</TD>
			<TD>�P�b��</TD>
			<TD>�K�n</TD>
			<TD>�Ƶ�</TD>	
			<TD>�ӷ�</TD><!-- R80413 -->
			<TD>���O</TD><!-- Q60236�W�[���O-->
		</TR>
	</THEAD>
	<TBODY>
<%
int index = pageNo * pageSize ;
for(; index < v.size() && index < ((pageNo+1) * pageSize ) ; index++){
	EntCroInqVO vo =(EntCroInqVO)v.get(index);
%>
		<TR>
			<TD><%=index+1%></TD>
			<TD><%=vo.getEBKCD()%></TD>
			<TD><%=vo.getEATNO()%></TD>
			<!--R00231-->
			<TD><%=commonUtil.checkDateFomat(String.valueOf(vo.getEBKRMD()))%></TD>
			<TD align="right"><%=df.format(vo.getENTAMT())%></TD>
			<TD><%=commonUtil.checkDateFomat(String.valueOf(vo.getEAEGDT()))%></TD>
			<TD><%=commonUtil.checkDateFomat(String.valueOf(vo.getECRDAY()))%></TD>
			<TD><%=vo.getEUSREM()%></TD>
			<TD><%=vo.getEUSREM2()%></TD>
			<TD><%=vo.getCROTYPE()%></TD> 
			<TD><%=vo.getCSHFCURR()%></TD><!-- Q60236�W�[���O-->
		</TR>
<%}%>
	</TBODY>
</TABLE>
<%}
request.removeAttribute("VO");%>
</body>
</html>