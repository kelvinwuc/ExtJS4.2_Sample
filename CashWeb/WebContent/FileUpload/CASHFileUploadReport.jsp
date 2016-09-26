<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393    Leo Huang    			2010/09/23          ������|��۹���|
 *  =============================================================================
 */

-->

<HTML>
<HEAD>
<%@ page 
language="java"
contentType="text/html; charset=BIG5"
pageEncoding="BIG5"
%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ include file="../Logon/Init.inc" %>
<%@ include file="../Logon/CheckLogon.inc" %>
<%! String strThisProgId = "FileUpload"; 
        String ActionTarget = "CASHFileSaveS"; %>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="../Theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>CASHFileUploadReport.jsp</TITLE>
<SCRIPT>
         function setTag(tagValue) { 
              document.form1.TAG.value=tagValue;
              alter(document.form1.TAG.value);
        } 
        
        function setAction(){
        
             with (document.from1){
                     ACTION='CASHFileUpload.jsp';
                     alter(ACTION);
                     return true;
             }
        }
</SCRIPT>
</HEAD>
<BODY>
<%
    //System.out.println("11");
    Vector v = (Vector)session.getAttribute("UPLOADFILE");
    DecimalFormat df = new DecimalFormat(",000");
    int success = 0;
    int fail = 0;
    int backit = 0;
    double sAmt = 0;
    double fAmt = 0;
    double bAmt = 0;
    
    for(int i = 0; i < v.size(); i++) {
        Hashtable line = (Hashtable)v.elementAt(i);
        String strType = (String)line.get("FLD0008");
        String strAmt = (String)line.get("FLD0004");
        double dAmt = Double.parseDouble(strAmt);  //added for Q50088 -->���B�L�ӾɭP�W�ǥ��Ѫ����D
      //  int intAmt = Integer.parseInt(strAmt);  marked for Q50088 -->���B�L�ӾɭP�W�ǥ��Ѫ����D
        
        if(strType.equals("1")) {
            success++;
           // sAmt = sAmt + intAmt/100.0;marked for Q50088 -->���B�L�ӾɭP�W�ǥ��Ѫ����D
            sAmt = sAmt + dAmt/100.0;//added for Q50088 -->���B�L�ӾɭP�W�ǥ��Ѫ����D
        } else if(strType.equals("2")) {
            fail++;
           // fAmt = fAmt + iAmt/100.0;marked for Q50088 -->���B�L�ӾɭP�W�ǥ��Ѫ����D
            fAmt = fAmt + dAmt/100.0;//added for Q50088 -->���B�L�ӾɭP�W�ǥ��Ѫ����D
        } else if(strType.equals("3")) {
            backit++;
           // bAmt = bAmt + iAmt/100.0;marked for Q50088 -->���B�L�ӾɭP�W�ǥ��Ѫ����D
            bAmt = bAmt + dAmt/100.0;//added for Q50088 -->���B�L�ӾɭP�W�ǥ��Ѫ����D
        }
    }

%>
<!--R00393
<FORM NAME="form1" METHOD="post" ACTION="/CashWeb/servlet/<%= ActionTarget %>" >
-->
<FORM NAME="form1" METHOD="post" ACTION="../servlet/<%= ActionTarget %>" >
<TABLE border="1" width="400" >
<!--�W���ɮ׸�T-->
<TBODY>
		<TR>
			<TD colspan="3" bgcolor="#c0c0c0" align="center">�䲼�U���I�{ - �ɮפW�ǧ@�~</TD>
		</TR>
		<TR>
			<TD width="40%" bgcolor="#c0c0c0"></TD>
			<TD bgcolor="#c0c0c0" align="center" width="26%">����</TD>
			<TD bgcolor="#c0c0c0" align="center" width="36%">���B</TD>
		</TR>
		<TR>
			<TD width="40%" bgcolor="#8080ff" align="center">�I�{</TD>
			<TD align="right" width="26%"><%= success %></TD>
			<TD align="right" width="36%"><%= df.format(sAmt) %></TD>
		</TR>
		<TR>
			<TD width="40%" bgcolor="#8080ff" align="center">�h��</TD>
			<TD align="right" width="26%"><%= fail %></TD>
			<TD align="right" width="36%"><%= df.format(fAmt) %></TD>
		</TR>
		<TR>
			<TD width="40%" bgcolor="#8080ff" align="center">��^</TD>
			<TD align="right" width="26%"><%= backit %></TD>
			<TD align="right" width="36%"><%= df.format(bAmt) %></TD>
		</TR>
		<TR>
			<TD width="40%" bgcolor="#8080ff" align="center">����</TD>
			<TD align="right" width="26%"><%= v.size() %></TD>
			<TD align="right" width="36%"><%= df.format(sAmt+fAmt+bAmt) %></TD>
		</TR>
		<TR>
			<TD colspan="3" align="center" bgcolor="#c0c0c0">�п�ܤW�ǧ@�~�Ҧ�</TD>
		</TR>
		<TR>
			<TD width="40%" bgcolor="#8080ff" align="center">�s�W���</TD>
			<TD colspan="2" align="left"><INPUT type="radio" name="WRITETYPE"
				value="1" checked></TD>
		</TR>
		<TR>
			<TD width="40%" bgcolor="#8080ff" align="center">�л\���</TD>
			<TD colspan="2" align="left"><INPUT type="radio" name="WRITETYPE"
				value="2"></TD>
		</TR>
	</TBODY>
</TABLE>
<BR>
<INPUT TYPE="HIDDEN" NAME="TAG">
<INPUT TYPE=HIDDEN NAME='ProgId' VALUE='<%= ActionTarget %>'> 
<INPUT TYPE="SUBMIT" NAME="OK" VALUE="�T�w">
<!--<INPUT TYPE="SUBMIT" NAME="CANCEL" VALUE="�����W��" onClick="setAction()">-->
</FORM>
<!--R00393
<FORM NAME="form2" METHOD="post" ACTION="/CashWeb/FileUpload/CASHFileUploadDetail.jsp">
-->
<FORM NAME="form2" METHOD="post" ACTION="../FileUpload/CASHFileUploadDetail.jsp">
<INPUT TYPE="SUBMIT" NAME="DEDATA" VALUE="���Ӹ��" >
</FORM>
<!--R00393
<FORM NAME="form3" METHOD="post" ACTION="/CashWeb/BBSShow/PersonalNews.jsp">

-->
<FORM NAME="form3" METHOD="post" ACTION="../BBSShow/PersonalNews.jsp">
<INPUT TYPE="SUBMIT" NAME="BUTTON" VALUE="�^����" >
</FORM>
</BODY>
</HTML>
