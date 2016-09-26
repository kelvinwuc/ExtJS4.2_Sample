<%@ page language="java"  contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page import="com.aegon.comlib.*" %>

<%@ page import="java.util.*" %>

<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>功能資料檔維護</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript" >
var strFirstKey 			= "txtFuncId";		//第一個可輸入之Key欄位名稱
var strFirstData 			= "txtFuncName";		//第一個可輸入之Data欄位名稱
var strServerProgram 		= "FunctionMaintainS.jsp";	//Post至Server時,要呼叫之程式名稱
// *************************************************************
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
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;
	
	// 93/04/01 added by Andy : 檢核該使用者是否有相關權限
//	var domServerInformation = getServerInformation("UserInfo",strProgId);
//	updatePrevilege(domServerInformation.getElementsByTagName(strProgId).item(0).text);
	// end of 93/04/01
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
	disableKey();
	disableData();
}
/*
函數名稱:	addAction()
函數功能:	當toolbar frame 中之新增按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function addAction()
{
  	window.status = "";
	winToolBar.ShowButton( strFunctionKeyAdd );
	enableAll();
	document.getElementById("txtAction").value = "A";
	
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}
}

/*
函數名稱:	updateAction()
函數功能:	當toolbar frame 中之修改按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );
	disableKey();
	enableData();
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstData) != null )
			document.getElementById(strFirstData).focus() ;
	}
	document.getElementById("txtAction").value = "U";
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
	winToolBar.ShowButton( strFunctionKeyInquiry1 );
	enableKey();
	document.getElementById("txtAction").value = "I";
	if( strFirstKey != "" )
	{
		if( document.getElementById(strFirstKey) != null )
			document.getElementById(strFirstKey).focus() ;
	}

}

/*
函數名稱:	deleteAction()
函數功能:	當toolbar frame 中之刪除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function deleteAction()
{
	var bConfirm = window.confirm("是否確定刪除該筆資料?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "D";
		document.getElementById("frmMain").submit();
	}
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

/*
函數名稱:	confirmAction()
函數功能:	當toolbar frame 中之確定按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function confirmAction()
{
	if( document.getElementById("txtAction").value == "I" )
	{
		/*	執行 QueryFrameSet.jsp 時,各 QueryString 參數之意義
			RowPerPage		: 每一頁有幾列
			Heading			: 表頭欄位名稱,以逗號','分開每一欄位
			DisplayFields	: 要顯示之資料庫欄位名稱,以逗號分開每一欄位,與Heading相對應
			ReturnFields	: 傳回哪些欄位之值,以逗號分開每一欄位
			Sql				: 待執行之SQL,亦可加入where條件
			TableWidth		: 整個Table之寬度
	
		 modalDialog 會傳回使用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開
		
		*/
		var strSql = "select * from FUNC where 1 = 1 ";
		if( document.getElementById("txtFuncId").value != "" )
			strSql += " and FUNID like '^"+document.getElementById("txtFuncId").value +"^' ";

		//var strQueryString = "?RowPerPage=20&Heading=功能代號,功能名稱,功能類別,備註&DisplayFields=FUNID,FUNNAM,PROP,REMK&ReturnFields=FUNID&Sql="+strSql+"&TableWidth=600";

		//var strReturnValue = window.showModalDialog( "../CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	    session.setAttribute("Heading","功能代號,功能名稱,功能類別,備註");
	    session.setAttribute("DisplayFields", "FUNID,FUNNAM,PROP,REMK");
	    session.setAttribute("ReturnFields", "FUNID");
	    session.setAttribute("TableWidth", "600"); 		  
	    %>
	    var fmenu=window.parent.frames["menuFrame"];
		   var ftoolbar=window.parent.frames["toolbarFrame"];
		   appendDiv(fmenu);
		   appendDiv(ftoolbar); 
		   $.showModalDialog({
		   	     url: "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp?RowPerPage=20&Search=all&Sql="+strSql,
		   	     height: 500,
		   	     width: 700,
		   	     position: 'center',
		   	     scrollable: false,
		   	     onClose: function(){
		   	    	      var strReturnValue = this.returnValue;
		   			      removeDiv(fmenu);
		   			      removeDiv(ftoolbar);
		   			      if(strReturnValue != null){
		   			    	enableAll();
		   					document.getElementById("txtFuncId").value = strReturnValue;
		   					document.getElementById("txtAction").value = "I";
		   					document.getElementById("frmMain").submit();	                             
		   			    	}	   			    	  
		   			 }   
		    	});
	}
}

/*
函數名稱:	saveAction()
函數功能:	當toolbar frame 中之儲存按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function saveAction()
{
	enableAll();
	mapValue();
//	if( areAllFieldsOK() )
//	{
//		alert("3");
		document.getElementById("frmMain").submit();
//	}
//	else
//		alert( strErrMsg );
}
/*
函數名稱:	postToServer()
函數功能:	將Client之資料以 XMLHTTP 之方式傳送到 Server 端,並接收傳回之訊息
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function postToServer()
{
	var xmldomData = new ActiveXObject("Microsoft.XMLDOM");
	//將畫面上之資料先存入 XMLDOM 物件中
	if( pushToXML( xmldomData ) != 0 )
		return;
	var xmlHttp = new ActiveXObject( "msxml2.XMLHTTP" );
	//設定 Server 端程式, 第一個參數為 POST 表示使用 POST 呼叫 Server , 第二個參數為 Server 端程式名稱
	// 第三個參數是表示是否使用非同步呼叫,若使用 false 時,則在下面使用 send() 呼叫時會等 Server 會應完成後才繼續進行
	xmlHttp.open('POST',strServerProgram, false );	
	xmlHttp.setRequestHeader("Content-type","text/xml");
	//呼叫 Server 端程式, 並等待回應
	xmlHttp.send( xmldomData );
//	alert( xmlHttp.responseText );
//	document.getElementById("txtShow").outerHTML = xmlHttp.responseText;
	// xmlHttp.status 表示 Server 回應碼, 為一般之 HTTP 回應碼, 小於 300 表示正常, 通常是 200 
	if( xmlHttp.status < 300 )
	{	// Server 端程式正常結束
		var xmldomResponseData = new ActiveXObject("Microsoft.XMLDOM");
		// xmlhttp.responseText 中存放著 Server 端回應之 XML 資料, 使用 loadXML() 將該資料載入 XMLDOM 物件中
		xmldomResponseData.loadXML( xmlHttp.responseText );
		// 若 txtMsg 不為空白(一般都不為空白), 則先顯示訊息
		if( xmldomResponseData.getElementsByTagName("txtMsg").length != 0 )
		{
			if( xmldomResponseData.getElementsByTagName("txtMsg").item(0).text != "" )
				alert(xmldomResponseData.getElementsByTagName("txtMsg").item(0).text );
		}
		// 若是為查詢時,則設定為查詢功能鍵,並將傳回之資料搬到畫面上,否則為標準之功能鍵
		if( document.getElementById("txtAction").value == "I" )
		{
			moveToForm( xmldomResponseData );
			winToolBar.ShowButton( strFunctionKeyInquiry );
			window.status = "目前為查詢狀態,若要修改或刪除資料,請先選擇修改或刪除功能鍵";
		}
		else
		{
			winToolBar.ShowButton( strFunctionKeyInitial );
			window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
		}
		disableKey();
		disableData();

	}
	else
	{	// xmlHttp.responseText 中存放著 Server 端傳回之錯誤畫面, 使用 alert() 並不十分恰當, 以後可再改善
		alert( xmlHttp.responseText );
	}
}

/*
函數名稱:	pushToXML( xmldomData )
函數功能:	將畫面中要上傳之欄位資料存入 xmldomData 中
傳入參數:	XMLDOM xmldomData	: 要存入之 xmldom 資料結構物件
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function pushToXML( xmldomData )
{
	var oRootNode = xmldomData.createElement("XML");
	xmldomData.appendChild( oRootNode );
	//將 FORM 中所有之 INPUT 資料, 以其原來之 id 為 tag name 存入 XML 中
	var formMain = document.getElementsByTagName("FORM").item(0);
	var formInputs = formMain.getElementsByTagName("INPUT");
	if( formInputs != null )
	{
		for(var i=0;i< formInputs.length;i++)
		{
			if( formInputs.item(i).type == 'radio' )
				if( !formInputs.item(i).checked )
					continue;
			var oTmpNode = xmldomData.createElement(formInputs.item(i).id);
			oTmpNode.text = formInputs.item(i).value;
			oRootNode.appendChild( oTmpNode );
		}
		// radio type 之 input 在沒有點選(checked)時,就不會進入 oRootNode 中,一定要另外加入
		if( oRootNode.getElementsByTagName("radProperty").length == 0 )
		{
			var oTmpNode = xmldomData.createElement("radProperty");
			oTmpNode.text = "";
			oRootNode.appendChild( oTmpNode );
		}		
	}
	//將 FORM 中所有之 SELECT 資料, 以其原來之 id 為 tag name 存入 XML 中
	var formSelects = formMain.getElementsByTagName("SELECT");
	if( formSelects != null )
	{
		for(var i=0;i< formSelects.length;i++)
		{
			var oTmpNode = xmldomData.createElement(formSelects.item(i).id);
			oTmpNode.text = formSelects.item(i).value;
			oRootNode.appendChild( oTmpNode );
		}
	}
	return 0;
}

/*
函數名稱:	moveToForm( xmldomData )
函數功能:	當 Server 傳回資料後,將 xmldomData 資料搬到畫面上
傳入參數:	XMLDOM xmldomData	: Server 傳回之資料
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function moveToForm( xmldomData )
{
	document.getElementById("txtFuncId").value = xmldomData.getElementsByTagName("txtFuncId").item(0).text;
	document.getElementById("txtFuncName").value = xmldomData.getElementsByTagName("txtFuncName").item(0).text;
	document.getElementById("txtTwin").value = xmldomData.getElementsByTagName("txtTwin").item(0).text;
	document.getElementById("txtUrl").value = xmldomData.getElementsByTagName("txtUrl").item(0).text;
	document.getElementById("txtRemark").value = xmldomData.getElementsByTagName("txtRemark").item(0).text;
	for(var i=0;i< document.getElementsByName("radProperty").length;i++)
	{
		if( xmldomData.getElementsByTagName("radProperty").item(0).text == document.getElementsByName("radProperty").item(i).value )
		{	
			document.getElementsByName("radProperty").item(i).checked = true;
			break;
		}
	}
}
function mapValue()
{
	if (document.getElementsByName("radProperty").value == 'P')
		document.getElementsByName("txtTwin").value = "contentFrame";
	else
		document.getElementsByName("txtTwin").value = "";	
}

</SCRIPT>

</HEAD>
<BODY onload="WindowOnLoad()">
<form action="javascript:postToServer();" id="frmMain" method="post" name="frmMain">
 <table border="1" width="600">   
    <tbody>   
      <tr>   
        <td width="150"  class="TableHeading"><b>功能代號：</b></td>    
        <td width="450" ><input class="Key" maxLength="20" type="text" name="txtFuncId" id="txtFuncId" value="" size="20">    
        </td>    
      </tr>    
      <tr>    
        <td width="150" class="TableHeading"><b>功能名稱：</b></td>    
        <td width="450" ><input class="Data" maxLength="20" type="text" name="txtFuncName" id="txtFuncName" value=""  size="20">
	</td>    
      </tr>    
     <tr>     
        <td width="150" class="TableHeading"><b>屬性:</b></td>      
        <td width="450" >     <input id="radProperty" name="radProperty"  type="radio" value="P"  checked>Program   
          <input id="radProperty" name="radProperty"  type="radio" value="M" >Menu       
        </td>      
      </tr>      
      <tr>     
        <td width="150" class="TableHeading"><b>Url:</b></td>      
        <td width="450" ><input maxLength="255" type="text" id="txtUrl" name="txtUrl" value=""  size="70" >        
        </td>      
      </tr>     
      <tr>     
        <td width="150" class="TableHeading"><b>備註：</b></td>     
        <td width="450" ><input maxLength="70" type="text" id="txtRemark" name="txtRemark" value="" size="70" >       
        </td>     
      </tr>    
    </tbody>    
  </table>   
  <input type="hidden" id="txtTwin" name="txtTwin" value="" > 
   <INPUT name="txtAction" id="txtAction"  type="hidden" value="">
<INPUT name="txtMsg" id="txtMsg"  type="hidden" value="">
</FORM>
</BODY>
</HTML>
