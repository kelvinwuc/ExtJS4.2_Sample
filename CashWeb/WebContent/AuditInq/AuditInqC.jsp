<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *     R00393      Leo Huang    	    2010/10/13             絕對路徑轉相對路徑
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
<title>系統稽核紀錄查詢/列印</title>
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientI.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/Calendar.js"></SCRIPT>
<script ID="clientEventHandlersJS" LANGUAGE="javascript">

var strFirstKey 		= "txtLogStartDate";			//第一個可輸入之Key欄位名稱

// *************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	LoadServerData();			//自Server端下載資料
	window.status = "請先輸入查詢條件後,再按查詢功能鍵";
	enableAll();
}

function LoadServerData()
{
	//系統功能
	var strSql = "select FUNID,FUNNAM from FUNC";												//要改
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
				for(j=document.getElementById("selFuncId").options.length-1;j>=0;j--)             //要改
					document.getElementById("selFuncId").options.remove(j);                       //要改
				var oOption = document.createElement("OPTION");                                       
				oOption.text = "全選"; 
				oOption.value = "";    
				document.getElementById("selFuncId").add(oOption);                            
				for(j=0;j<xmldomTmp.getElementsByTagName("FUNID").length;j++)                    //要改
				{                                                                                         
					var oOption = document.createElement("OPTION");                                       
					oOption.text = xmldomTmp.getElementsByTagName("FUNNAM").item(j).text;         //要改
					oOption.value = xmldomTmp.getElementsByTagName("FUNID").item(j).text;        //要改
					document.getElementById("selFuncId").add(oOption);                            //要改
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
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
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
			strTmpMsg = "起始日期不可空白";
			bReturnStatus = false;
		}
	}
	if( objThisItem.name == "txtLogEndDate" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "截止日期不可空白";
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
函數名稱:	inquiryAction()
函數功能:	當toolbar frame 中之查詢按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
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
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
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
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
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
     		<TD width=150 align="right" class="TableHeading">起始日期：</TD>
     		<TD width=170>
	            	<INPUT class="Data" size="11" type="text" maxlength="11" id="txtLogStartDate" name="txtLogStartDate"  value="" readOnly onblur="checkClientField(this,true);">
	            	<a href="javascript:show_calendar('frmMain.txtLogStartDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');" ><IMG  src="../images/misc/show-calendar.gif" alt="查詢"></a> 
		</TD>
	</TR>
        <TR>
            <TD align="right" class="TableHeading" >截止日期：</TD>
     		<TD>
	            	<INPUT  class="Data" size="11" type="text" maxlength="11" id="txtLogEndDate" name="txtLogEndDate"  value="" readOnly onblur="checkClientField(this,true);">
	            	<a href="javascript:show_calendar('frmMain.txtLogEndDate','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');" ><img  src="../images/misc/show-calendar.gif" alt="查詢"></a> 
		</TD>
        </TR>
     	<TR>
     		<TD width=150 align="right" class="TableHeading">功能名稱：</TD>
     		<TD width=170>
     			<SELECT class="Data" id="selFuncId" name="selFuncId">
     				<OPTION value="">全部</OPTION>
     				<OPTION value="ENewsMemberInq">電子刊物資料查詢及下載</OPTION>
     				<OPTION value="ENewsMaintain">電子刊物內容上傳</OPTION>
     				<OPTION value="ENewsSend">電子刊物寄送設定</OPTION>
     				<OPTION value="PolicyInq">保單資料查詢作業</OPTION>
     			</SELECT>
		</TD>
	</TR>
     	<TR>
     		<TD width=150 align="right" class="TableHeading">使用者：</TD>
     		<TD width=170>
	            	<INPUT  class="Data" size="10" type="text" maxlength="10" id="txtUserId" name="txtUserId"  value="" onblur="checkClientField(this,true);">
		</TD>
	</TR>
    </TBODY>
</TABLE><br>
<table border="0" width=320 cellspacing="0" cellpadding="0" id="copyright" name="copyright">
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'>
	        <Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: "新細明體";>著作權所有全球人壽</font>
        </td>
	</tr>
	<tr> 
		<td width="100%" valign="middle" align="right" height="11" class='TableDeclare'><Font Style="font-size: 12px; line-height: 16px; color: #666666; font-family: "新細明體";> 
		<script language=JavaScript >
        var dteDate = new Date( document.lastModified );
        var strOut = '更新日期:';
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
