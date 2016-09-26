<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : �X�Ƕ״ڷ|�p����
 * 
 * Remark   : �޲z�t�΢w�]��
 * 
 * Revision : $Revision: 1.8 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  : 
 * 
 * CVS History:
 * 
 * $Log: DISBAccFinRmt.jsp,v $
 * Revision 1.8  2014/10/31 02:49:04  misariel
 * RC0036-�s�W��󪺿ﶵ
 *
 * Revision 1.7  2013/12/24 03:44:07  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */
%><%! String strThisProgId = "DISBAccFinRmt"; //���{���N��%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alCurrCash = new ArrayList();

if (session.getAttribute("CurrCashList") ==null){
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
}else{
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
Hashtable htTemp = null;
String strValue = null;
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"\">&nbsp;</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equals("NT"))
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("</option>");
		else
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}
	htTemp = null;
	strValue = null;
}
%>
<HTML>
<HEAD>
<TITLE>�޲z�t��--�X�Ƕ״ڷ|�p����</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" )
	{
		window.alert(document.getElementById("txtMsg").value) ;
	}

	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyDown,'' );
	window.status = "";
}

function mapValue()
{
	document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value) ;	    	 
   	document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value) ;	   
	document.getElementById("txtPStartDate2").value = rocDate2String(document.getElementById("txtPStartDateC2").value) ;	//R80338    	 
   	document.getElementById("txtPEndDate2").value = rocDate2String(document.getElementById("txtPEndDateC2").value) ;	//R80338    	     
}

function DISBDownloadAction()
{
    mapValue();
    if( areAllFieldsOK() )
	{	 
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}

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
			 	strTmpMsg = "�X�ǽT�{�骺�_�餣�o���ť�";
				bReturnStatus = false;
		} 
		else if( !isValidDate(objThisItem.value,'C') ) 
		{
		 	strTmpMsg = "�X�ǽT�{�骺�_�� - ����榡�����T";
			bReturnStatus = false;
		}
		else
		{
			if( document.getElementById("txtPEndDateC").value != "")
			{
				if (objThisItem.value  > document.getElementById("txtPEndDateC").value)
				{
				   	strTmpMsg = "�X�ǽT�{�骺�_�餣�o�j�󨴤�";
					bReturnStatus = false;
				}
			}
		}
	}
	else 	if( objThisItem.id == "txtPEndDateC" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "�X�ǽT�{�骺���餣�o���ť�";
				bReturnStatus = false;
		}
		else if( !isValidDate(objThisItem.value,'C') ) 
		{
		 	strTmpMsg = "�X�ǽT�{�骺���� - ����榡�����T";
			bReturnStatus = false;
		}
		else
		{
			if( objThisItem.value != "" && document.getElementById("txtPStartDateC").value != "")
			{
				if (objThisItem.value  < document.getElementById("txtPStartDateC").value)
				{
				   	strTmpMsg = "�X�ǽT�{�骺�_�餣�o�j�󨴤�";
					bReturnStatus = false;
				}
			}
		}			
	}
	// R80338 ��I�T�{��G(�|�p�T�{��)
	else 	if( objThisItem.id == "txtPStartDateC2" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "�|�p�T�{�骺�_�餣�o���ť�";
				bReturnStatus = false;
		}
		else if( !isValidDate(objThisItem.value,'C') ) 
		{
		 	strTmpMsg = "�|�p�T�{�骺�_�� - ����榡�����T";
			bReturnStatus = false;
		}
		else
		{
			if( objThisItem.value != "" && document.getElementById("txtPEndDateC2").value != "")
			{
				if (objThisItem.value  > document.getElementById("txtPEndDateC2").value)
				{
				   	strTmpMsg = "�|�p�T�{�骺�_�餣�o�j�󨴤�";
					bReturnStatus = false;
				}
			}
		}			
	}	
	else 	if( objThisItem.id == "txtPEndDateC2" )
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "�|�p�T�{�骺���餣�o���ť�";
				bReturnStatus = false;
		}
		else if( !isValidDate(objThisItem.value,'C') ) 
		{
		 	strTmpMsg = "�|�p�T�{�骺���� - ����榡�����T";
			bReturnStatus = false;
		}
		else
		{
			if( objThisItem.value != "" && document.getElementById("txtPStartDateC2").value != "")
			{
				if (objThisItem.value  < document.getElementById("txtPStartDateC2").value)
				{
				   	strTmpMsg = "�|�p�T�{�骺�_�餣�o�j�󨴤�";
					bReturnStatus = false;
				}
			}
		}			
	}		
	 else if (objThisItem.id =="selCurrency")
	{
		if(objThisItem.value  == "")
		{
			 	strTmpMsg = "���O���i�ť�";
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

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBMaintain/DISBAccFinRmt.jsp";
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbmaintain.DISBAccFinRmtServlet">
<br>
<TABLE border="1" width="452" id="inqueryArea">
	<TBODY>
		<TR>		
			<TD align="right" class="TableHeading" width="110">�X�ǽT�{��G</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC" name="txtPStartDateC" value="" 
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT	type="hidden" name="txtPStartDate" id="txtPStartDate"	value="">
				 ~
				  <INPUT class="Data" size="11" type="text" maxlength="11"	id="txtPEndDateC" name="txtPEndDateC" value="" 	onblur="checkClientField(this,true);">
				   <a 	href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
				 <INPUT	type="hidden" name="txtPEndDate" id="txtPEndDate" value="">
			
			</TD>
		</TR>
		<TR>  <!-- R80338 ��I�T�{��G -->		
			<TD align="right" class="TableHeading" width="110">(�|�p)��I�T�{��G</TD>
			<TD colspan=3 width="334"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC2" name="txtPStartDateC2" value="" 
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> 
				<INPUT	type="hidden" name="txtPStartDate2" id="txtPStartDate2"	value="">
				 ~
				  <INPUT class="Data" size="11" type="text" maxlength="11"	id="txtPEndDateC2" name="txtPEndDateC2" value="" 	onblur="checkClientField(this,true);">
				   <a 	href="javascript:show_calendar('frmMain.txtPEndDateC2','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a>
				 <INPUT	type="hidden" name="txtPEndDate2" id="txtPEndDate2" value="">
			
			</TD>
		</TR>
		<!-- RC0036 -->
		<TR>
			<TD align="right" class="TableHeading" width="110">���_�G</TD>
			<TD colspan=3 width="40">
				<select size="1" name="pDispatch" id="pDispatch">
					<option value="Y">�O</option>
					<option value="" selected>�_</option>
				</select>
			</TD>
		</TR>
    	<TR>
	        <TD align="right" class="TableHeading" width="110">�O����O�G</TD>
			<TD colspan=3 width="40">
				<select size="1" name="selCurrency" id="selCurrency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
		<TR> <!-- R80338 -->
	        <TD align="right" class="TableHeading" width="110">�I�ڤ覡�G</TD>
			<TD colspan=3 width="40">
			   <SELECT class="Data" id="PMethod" name="PMethod">
					<OPTION value="B">�Ȧ�״�</OPTION>
					<OPTION value="D">�~���״�</OPTION>
				</SELECT>
			</TD>
		</TR>    
	</TBODY>
</TABLE>

<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>