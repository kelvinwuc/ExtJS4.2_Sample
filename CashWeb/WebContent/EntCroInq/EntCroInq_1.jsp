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
 * Function : 登銷帳查詢
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
 * R00135---PA0024---CASH年度專案-04
 * 修正金額顯示的問題
 *
 * Revision 1.9  2014/02/21 07:33:37  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 還原
 *
 * Revision 1.8  2014/02/19 08:52:30  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 還原
 *
 * Revision 1.7  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%><%! String strThisProgId = "EntCroInq"; //本程式代號 %><%
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
<TITLE>登銷帳查詢</TITLE>
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
<TD>總筆數 : <%=v.size()%> </TD><TD> 總金額 : <%=sumAmt%></TD>
<TD>
<%if(pageNo > 0 ){
	out.println("<input type=button name='上一頁' value='上一頁' onClick='doSubmit("+(pageNo-1)+");' >");
  }else{
	out.println("<input type=button name='上一頁' value='上一頁' onClick='doSubmit("+(pageNo-1)+");' disabled>");
  }
  if((pageNo+1) * pageSize < v.size()){
  	out.println("<input type=button name='下一頁' value='下一頁' onClick='doSubmit("+(pageNo+1)+");' >");
  }else{
  	out.println("<input type=button name='下一頁' value='下一頁' onClick='doSubmit("+(pageNo+1)+");' disabled>");
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
			<TD>金融單位代碼</TD>
			<TD>帳號</TD>
			<TD>匯款日</TD>
			<TD>匯款金額</TD>
			<TD>全球入帳日</TD>
			<TD>銷帳日</TD>
			<TD>摘要</TD>
			<TD>備註</TD>	
			<TD>來源</TD><!-- R80413 -->
			<TD>幣別</TD><!-- Q60236增加幣別-->
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
			<TD><%=vo.getCSHFCURR()%></TD><!-- Q60236增加幣別-->
		</TR>
<%}%>
	</TBODY>
</TABLE>
<%}
request.removeAttribute("VO");%>
</body>
</html>