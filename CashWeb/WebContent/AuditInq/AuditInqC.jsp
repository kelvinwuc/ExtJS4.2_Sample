<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *     R00393      Leo Huang    	    2010/10/13             ������|��۹���|
 *  =============================================================================
 */
%>
<%@ page language="java" contentType="text/html; charset=CP950" pageEncoding="CP950" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.util.*" %>
<%
//R00393
GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">  
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5.3 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<title>�t�ν]�֬����d��/�C�L</title>
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientI.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/Calendar.js"></SCRIPT>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">

var strFirstKey 		= "txtLogStartDate";			//�Ĥ@�ӥi��J��Key���W��

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
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	LoadServerData();			//��Server�ݤU�����
	window.status = "�Х���J�d�߱����,�A���d�ߥ\����";
	enableAll();
}

function LoadServerData()
{
	//�t�Υ\��
	var strSql = "select FUNID,FUNNAM from FUNC";												//�n��
	var xmldomTmp = executeSql( strSql );                                                                 
	if( xmldomTmp.getElementsByTagName("txtMsg").length != 0 )                                            
	{                                                                                                     
		if( xmldomTmp.getElementsByTagName("txtMsg").item(0).text != "" )                                 
		{                                                                                                 
			alert( xmldomTmp.getElementsByTagName("txtMsg").item(0).text );                               
		}                                                                                                 
		else                                                                                              
		{                                                                                                 
			if( parseInt(xmldomTmp.getElementsByTagName("txtRowCount").item(0).text) > 0 )                
			{                                                                                             
				var j=0;                                                                                  
				for(j=document.getElementById("selFuncId").options.length-1;j>=0;j--)             //�n��
					document.getElementById("selFuncId").options.remove(j);                       //�n��
				var oOption = document.createElement("OPTION");                                       
				oOption.text = "����"; 
				oOption.value = "";    
				document.getElementById("selFuncId").add(oOption);                            
				for(j=0;j<xmldomTmp.getElementsByTagName("FUNID").length;j++)                    //�n��
				{                                                                                         
					var oOption = document.createElement("OPTION");                                       
					oOption.text = xmldomTmp.getElementsByTagName("FUNNAM").item(j).text;         //�n��
					oOption.value = xmldomTmp.getElementsByTagName("FUNID").item(j).text;        //�n��
					document.getElementById("selFuncId").add(oOption);                            //�n��
				}
			}
		}
	}
	else
	{
		alert("executeSql error : '"+strSql+"' ");
	}
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
	if( objThisItem.name == "txtLogStartDate" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "�_�l������i�ť�";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "txtLogEndDate" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "�I�������i�ť�";
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
��ƦW��:	inquiryAction()
��ƥ\��:	��toolbar frame �����d�߫��s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function inquiryAction()
{
	enableAll();
	if( areAllFieldsOK() )
	{
		document.getElementById("txtAction").value = "H";
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
}


/*
��ƦW��:	resetAction()
��ƥ\��:	��toolbar frame �����M�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/*
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
}



</SCRIPT>

<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css">
</head>
<BODY onload="WindowOnLoad();" >
<FORM action="ReportOutput.jsp" id="frmMain" method=post name="frmMain" >
<CENTER>
<TABLE border="1" width="320">
    <TBODY>
     	<TR>
     		<TD width=150 align="right" class="TableHeading">�_�l����G</TD>
     		<TD width=170>
	            	<INPUT class="Data" size="11" type="text" maxlength="11" id="txtLogStartDate" name="txtLogStartDate"  value="" readOnly onblur="checkClientField(this,true);">
	            	<a href="javascript:show_calendar('frmMain.txtLogStartDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');" ><IMG  src="../images/misc/show-calendar.gif" alt="�d��"></a> 
		</TD>
	</TR>
        <TR>
            <TD align="right" class="TableHeading" >�I�����G</TD>
     		<TD>
	            	<INPUT  class="Data" size="11" type="text" maxlength="11" id="txtLogEndDate" name="txtLogEndDate"  value="" readOnly onblur="checkClientField(this,true);">
	            	<a href="javascript:show_calendar('frmMain.txtLogEndDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');" ><img  src="../images/misc/show-calendar.gif" alt="�d��"></a> 
		</TD>
        </TR>
     	<TR>
     		<TD width=150 align="right" class="TableHeading">�\��W�١G</TD>
     		<TD width=170>
     			<SELECT class="Data" id="selFuncId" name="selFuncId">
     				<OPTION value="">����</OPTION>
     				<OPTION value="ENewsMemberInq">�q�l�Z����Ƭd�ߤΤU��</OPTION>
     				<OPTION value="ENewsMaintain">�q�l�Z�����e�W��</OPTION>
     				<OPTION value="ENewsSend">�q�l�Z���H�e�]�w</OPTION>
     				<OPTION value="PolicyInq">�O���Ƭd�ߧ@�~</OPTION>
     			</SELECT>
		</TD>
	</TR>
     	<TR>
     		<TD width=150 align="right" class="TableHeading">�ϥΪ̡G</TD>
     		<TD width=170>
	            	<INPUT  class="Data" size="10" type="text" maxlength="10" id="txtUserId" name="txtUserId"  value="" onblur="checkClientField(this,true);">
		</TD>
	</TR>
    </TBODY>
</TABLE><br>
<table border="0" width=320 cellspacing="0" cellpadding="0" id="copyright" name="copyright">
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'>
	        <Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: "�s�ө���";>�ۧ@�v�Ҧ����y�H��</font>
        </td>
	</tr>
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'><Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: "�s�ө���";> 
		<script language=JavaScript >
        var dteDate = new Date( document.lastModified );
        var strOut = '��s���:';
        if( dteDate.getMonth() + 1 < 10 )
    	    strOut += "0"+(dteDate.getMonth()+1)+"/";
        else
	        strOut += (dteDate.getMonth()+1)+"/";
        if( dteDate.getDate() < 10 )
	        strOut += "0"+dteDate.getDate()+"/";
        else
	        strOut += dteDate.getDate()+"/";
	        strOut += dteDate.getFullYear();
	        document.write( strOut );
		</script></font></td>
	</tr>
</table>
</CENTER>

<INPUT name="txtAction" id="txtAction"  type="hidden" value="">

</FORM>

</body>
</html>
