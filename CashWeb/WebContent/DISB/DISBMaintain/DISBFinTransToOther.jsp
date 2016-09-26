<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393        Leo Huang    		2010/09/21           �{�b�ɶ���Capsil��B�ɶ�
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
<%@ page import="com.aegon.disb.util.StringTool" %>
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
 * Revision : $Revision: 1.6 $
 * 
 * Author   : Odin Tsai
 * 
 * Create Date : $Date: 2013/12/24 03:44:07 $
 * 
 * Request ID : R80413
 * 
 * CVS History:
 * 
 * $Log: DISBFinTransToOther.jsp,v $
 * Revision 1.6  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.2  2008/11/10 08:42:57  MISODIN
 * R80413_�����b�ڹO�����L���J
 *
 * Revision 1.1  2008/10/31 10:01:13  MISODIN
 * R80413_�����b�ڹO�����L���J
 *
 *
 *  
 */
-->

<%! String strThisProgId = "DISBFinTransToOther"; //���{���N��%>
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
List alCurrCash = new ArrayList();

if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}
else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
  
  String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
    strReturnMessage = (String) request.getAttribute("txtMsg");
  }  
  
%>
<HTML>
<HEAD>
<TITLE>�����b�ڹO�G�~���L���J</TITLE>
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

	}
	
	   	WindowOnLoadCommon( document.title , '' , '','' ) ;
	    window.status = "";

}

function mapValue(){

	document.getElementById("para_PStartDate").value 
	   	= rocDate2String(document.getElementById("txtPStartDateC").value) ;	    	 
    document.getElementById("txtTransDate").value 
	   	= rocDate2String(document.getElementById("txtTransDateC").value) ;	         
}
/*
��ƦW��:	DISBDownloadAction()
��ƥ\��:	��toolbar frame �����U�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function DISBDownloadAction()
{
    mapValue();
    if( areAllFieldsOK() )
	{	 
	//R00393  Edit by Leo Huang (EASONTECH) Start
		//document.frmMain.action = "/CashWeb/servlet/com.aegon.disb.disbmaintain.DISBFinTransToOther";
		document.frmMain.action = "<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBFinTransToOther";
		//R00393  Edit by Leo Huang (EASONTECH) End
	    document.getElementById("frmMain").target="_blank"; 
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

	if( objThisItem.id == "txtPStartDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "�O��������o���ť�";
				bReturnStatus = false;
		}
	}
	
	if( objThisItem.id == "txtTransDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "�������������o���ť�";
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
/*
��ƦW��:	printRAction()
��ƥ\��:	��toolbar frame ����������s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function printRAction()
{
    mapValue(); 
    if( areAllFieldsOK() ) {
       getReportInfo();		
     //R00393  Edit by Leo Huang (EASONTECH) Start
	  //document.frmMain.action="/CashWeb/servlet/com.aegon.crystalreport.CreateReportRS";
	  document.frmMain.action="<%=request.getContextPath()%>/servlet/com.aegon.crystalreport.CreateReportRS";
	   //R00393  Edit by Leo Huang (EASONTECH) End
	  document.getElementById("frmMain").target="_blank";      
   	  document.frmMain.submit();
   	       
    } else {
		alert( strErrMsg );      
    }
			
}

function getReportInfo()
{

    iPStartDate = document.getElementById("para_PStartDate").value;
	iPStartDate2 = iPStartDate - 20000;  //�� 2�~
    iPStartDate3 = iPStartDate + 1110000;  // 970930 --> 2080930
 
    var ReportSQL = "";
    
    var strSql  = "SELECT B.BKNAME,A.EBKCD AS EBKCD,A.EATNO AS EATNO,B.GLACT AS GLACT,A.CSHFCURR,A.CERRATE AS CERRATE, ";
      strSql +=" SUM(A.ENTAMT) AS ENTAMT, SUM(A.CENTAMTNT) AS CENTAMTNT"; 
      strSql +=" FROM CAPCSHF A LEFT JOIN ";
      strSql +=" (SELECT DISTINCT BKNAME,BKCODE,BKATNO,GLACT,BKCURR FROM CAPBNKF) B ";
      strSql +=" ON A.EBKCD = B.BKCODE AND A.EATNO=B.BKATNO AND A.CSHFCURR=B.BKCURR ";     
      strSql +=" WHERE 1=1 AND A.CROTYPE='T' ";
      strSql += " AND A.EBKRMD < " +  iPStartDate2;	
 	  strSql += " GROUP BY EBKCD,EATNO,GLACT,BKNAME,CSHFCURR,CERRATE ";	
 	  strSql += " ORDER BY EBKCD,EATNO,GLACT,BKNAME,CSHFCURR,CERRATE ";	  	  
      
      document.getElementById("ReportSQL").value = strSql;  

}

</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<form
	action=""
	id="frmMain" method="post" name="frmMain">
<input type=button onclick="DISBDownloadAction()" name="btnDownload" id="btnDownload" value="�U��">	
<input type=button onclick="printRAction()" name="btnPrint" id="btnPrint" value="����">	
<!--R00393  Edit by  Leo Huang (EASONTECH) start
<input type=button onclick="window.location.href= '/CashWeb/DISB/DISBMaintain/DISBFinTransToOther.jsp' ;" name="btnExit" id="btnExit" value="���}">
-->
<input type=button onclick="window.location.href= '<%=request.getContextPath()%>/DISB/DISBMaintain/DISBFinTransToOther.jsp' ;" name="btnExit" id="btnExit" value="���}">
<!--R00393  Edit by  Leo Huang (EASONTECH) end-->
<br>
<br>
<TABLE border="1" width="452" id=inqueryArea name=inqueryArea>
	<TBODY>
	<tr>		
			<TD align="right" class="TableHeading" width="110">�O������G</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC" name="txtPStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT	type="hidden" name="para_PStartDate" id="para_PStartDate"	value="">			
			</TD>
	</tr>		 
	<tr>		
			<TD align="right" class="TableHeading" width="110">�����������G</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtTransDateC" name="txtTransDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtTransDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT	type="hidden" name="txtTransDate" id="txtTransDate"	value="">			
			</TD>
	</tr>		 	
	</TBODY>
</TABLE>
<INPUT id="ReportName" type="hidden" name="ReportName" value="DISBFinTransToOther.rpt">
<INPUT id="OutputType" name="OutputType" value="PDF" type="hidden"> 
<INPUT id="OutputFileName" name="OutputFileName" value="DISBFinTransToOther.pdf" type="hidden">
<!--R00393 
<INPUT id="ReportPath" type="hidden" name="ReportPath" value="D:\\WAS5APP\\CashWeb.ear\\CashWeb.war\\DISB\\DISBMaintain\\">
-->
<INPUT id="ReportPath" type="hidden" name="ReportPath" value="<%=globalEnviron.getRootPath()%>DISB\\DISBMaintain\\">

<INPUT id="ReportSQL" type="hidden" name="ReportSQL" value="">

<INPUT name="txtAction" id="txtAction" type="hidden" value=""> 
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>