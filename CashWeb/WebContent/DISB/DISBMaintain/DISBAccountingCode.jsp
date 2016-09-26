<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393     Leo Huang    			2010/09/21           �{�b�ɶ���Capsil��B�ɶ�
 *   R00393       Leo Huang    			2010/09/21           ������|��۹���|
 *  =============================================================================
 */
%>
<%@ page language="java" contentType="text/html; charset=CP950" pageEncoding="CP950" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.DbFactory" %>

<%//R00393%>
<!--# include virtual="/Logon/Init.inc"-->
<!--# include virtual="/Logon/CheckLogonDISB.inc"-->
<!--
/*
 * System   : 
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.7 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2013/12/24 03:44:07 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBAccountingCode.jsp,v $
 * Revision 1.7  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.4  2012/05/18 09:49:51  MISSALLY
 * R10314 CASH�t�η|�p�@�~�ק�
 *
 * Revision 1.3  2010/11/23 02:21:59  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.2  2008/08/06 06:01:30  MISODIN
 * R80132 �վ�CASH�t��for 6�ع��O
 *
 * Revision 1.1  2006/06/29 09:40:14  MISangel
 * Init Project
 *
 * Revision 1.1.2.5  2006/04/27 09:38:42  misangel
 * R50891:VA�����O��-��ܹ��O
 *
 * Revision 1.1.2.4  2005/04/25 07:24:48  miselsa
 * R30530
 *
 * Revision 1.1.2.3  2005/04/04 07:02:25  miselsa
 * R30530 ��I�t��
 *
 *  
 */
-->

<%! String strThisProgId = "DISBAccountingCode"; //���{���N��%>
<%

//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
SimpleDateFormat sdfDateFormatter =
	new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", java.util.Locale.TAIWAN);
SimpleDateFormat sdfDate =
	new SimpleDateFormat("yyyyMMdd", java.util.Locale.TAIWAN);
SimpleDateFormat sdfTime =
	new SimpleDateFormat("hhmmss", java.util.Locale.TAIWAN);

GlobalEnviron globalEnviron =
	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	
	
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
//R00393  Edit by Leo Huang (EASONTECH) Start
//java.util.Date dteToday = cldCalendar.getTime(); //�ثe����ɶ�
//R00393  Edit by Leo Huang (EASONTECH) End
//List alPSrcCode = new ArrayList();

//alPSrcCode = (List) disbBean.getETable("PAYCD", "");

List alCurrCash = new ArrayList(); //R80132 ���O�D��

if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}
else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}//R80132 END

  
  String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
    strReturnMessage = (String) request.getAttribute("txtMsg");
  }  
  
%>
<HTML>
<HEAD>
<TITLE>�޲z�t��--�]�ȷ|�p����</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">

var strFirstKey 			= "txtUserId";			//�Ĥ@�ӥi��J��Key���W��
var strFirstData 			= "txtPassword";		//�Ĥ@�ӥi��J��Data���W��
var strServerProgram 			= "UserMaintainS.jsp";		//Post��Server��,�n�I�s���{���W��

// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" )
	{
		window.alert(document.getElementById("txtMsg").value) ;
	//	document.getElementById("btnDownload").style.display="block"; 
	//	document.getElementById("btnExit").style.display="none";
	//	document.getElementById("inqueryArea").style.display="block"; 
	}
	
	   	WindowOnLoadCommon( document.title , '' , '','' ) ;
	    window.status = "";

}

function mapValue(){
	document.getElementById("txtEntryStartDate").value 
	   	= rocDate2String(document.getElementById("txtEntryStartDateC").value) ;	    	 
	document.getElementById("txtPStartDate").value 
	   	= rocDate2String(document.getElementById("txtPStartDateC").value) ;	    	   
}
function DISBDownloadAction()
{
    mapValue();
    if( areAllFieldsOK() )
	{	
	  // 	document.getElementById("btnDownload").style.display="none"; 
	//	document.getElementById("btnExit").style.display="block";
	//	document.getElementById("inqueryArea").style.display="none"; 
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}
/**
��ƦW��:	checkClientField(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
	}	
	if( objThisItem.id == "txtEntryStartDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "��J������o���ť�";
				bReturnStatus = false;
		}
	}
	else	if( objThisItem.id == "txtPStartDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "��I�T�{�餣�o���ť�";
				bReturnStatus = false;
		}
	} else if (objThisItem.id =="selCurrency")
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "�O����O���i�ť�";
				bReturnStatus = false;
		}	
	}
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<!--R00393  Edit by Leo Huang (EASONTECH) Start
<form
	action="/CashWeb/servlet/com.aegon.disb.disbmaintain.DISBAccCodeServlet"
	id="frmMain" method="post" name="frmMain">
<input type=button onclick="DISBDownloadAction()" name="btnDownload" id="btnDownload" value="�U��">	
<input type=button onclick="window.location.href= '/CashWeb/DISB/DISBMaintain/DISBAccountingCode.jsp' ;" name="btnExit" id="btnExit" value="���}">
-->
<form
	action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBAccCodeServlet"
	id="frmMain" method="post" name="frmMain">
<input type=button onclick="DISBDownloadAction()" name="btnDownload" id="btnDownload" value="�U��">	
<input type=button onclick="window.location.href= '<%=request.getContextPath()%>/DISB/DISBMaintain/DISBAccountingCode.jsp' ;" name="btnExit" id="btnExit" value="���}">
<!--R00393  Edit by Leo Huang (EASONTECH) End-->
<br>
<br>
<TABLE border="1" width="452" id=inqueryArea name=inqueryArea>
	<TBODY>
<TR>
			<TD align="right" class="TableHeading" width="110">��J����G</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtEntryStartDateC" name="txtEntryStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtEntryStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT type="hidden" name="txtEntryStartDate" id="txtEntryStartDate" value=""> 
			</TD>
	</tr>
	<tr>		
			<TD align="right" class="TableHeading" width="110">��I�T�{��G</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC" name="txtPStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT	type="hidden" name="txtPStartDate" id="txtPStartDate"	value="">		
			</TD>
	</tr>		
    <TR>
	        <TD align="right" class="TableHeading" width="110">�O����O�G</TD>
			<TD colspan=3 width="40"><select size="1" name="selCurrency" id="selCurrency">
			<option value=""></option>
			<!--  <option value="NT">NT</option>
			<option value="US">US</option>  -->
			<% //R80132
				 if (alCurrCash.size() > 0) {
				     for (int i = 0; i < alCurrCash.size(); i++) {
				       	Hashtable htCurrCashTemp = (Hashtable) alCurrCash.get(i);
				        String strETValue = (String) htCurrCashTemp.get("ETValue");
		            	out.println("<option value="+ strETValue+ ">"+ strETValue+"</option>");
			            }
			       	}
			     else 
			       {
				   out.println("<option value=''></option>");
				   }
				%>										
			</select></TD>							
    
    </TR>
	</TBODY>
</TABLE>

<INPUT name="txtAction" id="txtAction" type="hidden" value=""> 
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>