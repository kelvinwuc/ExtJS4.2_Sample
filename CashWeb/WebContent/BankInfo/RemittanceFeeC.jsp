<%@ page language="java" contentType="text/html; charset=BIG5"
	pageEncoding="BIG5"%>
<%@ page autoFlush="true"%>

<%!/*
	 * System   : CashWeb
	 * 
	 * Function : 匯款限額及手續費維護
	 * 
	 * Remark   : 
	 * 
	 * Revision : $Revision: 1.3 $
	 * 
	 * Author   : $Author: MISSALLY $
	 * 
	 * Create Date : $Date: 2013/12/24 03:35:04 $
	 * 
	 * Request ID :
	 * 
	 * CVS History:
	 * 
	 * $Log: RemittanceFeeC.jsp,v $
	 * Revision 1.3  2013/12/24 03:35:04  MISSALLY
	 * R00135---PA0024---CASH年度專案
	 *
	 *  
	 */%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>匯款限額及手續費維護</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css">
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/Calendar.js"></SCRIPT>
<script type="text/javascript">

	var strFirstKey 			= "txtRemAmtFrom";			//第一個可輸入之Key欄位名稱
	var strFirstData 			= "txtRemAmtFrom";			//第一個可輸入之Data欄位名稱
	var strServerProgram 		= "RemittanceFeeS.jsp";		//Post至Server時,要呼叫之程式名稱
	var myInitFuncKey 			= "A,I,E";

	//*************************************************************
	/*
	 函數名稱:	WindowOnLoad()
	 函數功能:	當前端程式開始時,本函數會被執行
	 傳入參數:	無
	 傳回值:	無
	 修改紀錄:	修改日期	修改者	修   改   摘   要
	 ---------	----------	-----------------------------------------
	 */
	function WindowOnLoad() {
		if (document.getElementById("txtMsg").value != "")
			window.alert(document.getElementById("txtMsg").value);
		WindowOnLoadCommon(document.title, '', myInitFuncKey, '');
		window.status = "請先選擇新增或查詢功能鍵,若要修改或刪除資料,可經由查詢功能後再進入";
		disableKey();
		disableData();
		
	}

	// 表[查詢]時被呼叫的 function
	function inquiryAction() {

		//winToolBar.ShowButton( "H,E" );

		resetAction();
		//enableQueryFields("txtRemAmtFrom,txtRemAmtTo");
		document.getElementById("txtAction").value = "I";
		//if (strFirstKey != "") {
		//	if (document.getElementById(strFirstKey) != null)
		//		document.getElementById(strFirstKey).focus();
		//}
		confirmAction();
		disableAll();
	}

	function addAction() {
		window.status = "";
		document.getElementById( "txtAction" ).value = "A";
		winToolBar.ShowButton( strFunctionKeyAdd );
		disableKey();
		enableData();
		document.getElementById( "txtRemFee" ).disabled = "disabled";
		if( strFirstKey != "" ) {
			if( document.getElementById(strFirstData) != null )
				document.getElementById(strFirstData).focus() ;
		}
	}

	function updateAction() {
		
		window.status = "";
		document.getElementById( "txtAction" ).value = "U";
		winToolBar.ShowButton( strFunctionKeyUpdate );
		disableKey();
		enableData();
		document.getElementById( "txtRemFee" ).disabled = "disabled";
		if( strFirstKey != "" ) {
			if( document.getElementById(strFirstData) != null )
				document.getElementById(strFirstData).focus() ;
		}
	}

	function exitAction() {

		var currentAction = document.getElementById("txtAction").value;

		resetAction();
		winToolBar.ShowButton(myInitFuncKey);
		document.getElementById("txtAction").value = "";
		disableAll();

	}

	function confirmAction() {

		if (document.getElementById("txtAction").value == "I") {
			/*	執行 QueryFrameSet.jsp 時,各 QueryString 參數之意義
				RowPerPage		: 每一頁有幾列
				Heading			: 表頭欄位名稱,以逗號','分開每一欄位
				DisplayFields	: 要顯示之資料庫欄位名稱,以逗號分開每一欄位,與Heading相對應
				ReturnFields	: 傳回哪些欄位之值,以逗號分開每一欄位
				Sql				: 待執行之SQL,亦可加入where條件
				TableWidth		: 整個Table之寬度
			
			 	modalDialog 會傳回使用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開
			
			 */
			 
			var strSql = "select FLD001,FLD002,FLD003,FLD004,FLD005,FLD006,FLD007,FLD008 from BANKFEE where 1 = 1 ";
			var curr = document.getElementById("txtCurr").value;
			if (document.getElementById("txtCurr").value != "")
				strSql += " and FLD002 = '" + curr + "' ";
			//
			strSql += " ORDER BY FLD002, FLD003";

			var strQueryString = "?RowPerPage=20&Sql=" + strSql + "&TableWidth=650&queryType=RemittanceFee&queryCurr=" + curr;

		<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	    session.setAttribute("Heading","幣別,金額(起),金額(訖),銀行手續費,金資手續費,匯款手續費,備註");
	    session.setAttribute("DisplayFields", "FLD002,FLD003,FLD004,FLD005,FLD006,FLD007,FLD008");
	    session.setAttribute("ReturnFields", "FLD001,FLD002,FLD003,FLD004,FLD005,FLD006,FLD007,FLD008");
	    %>
			//modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
			var strReturnValue = window.showModalDialog(
					"../CommonQuery/QueryFrameSet.jsp" + strQueryString, "",
					"dialogWidth:700px;dialogHeight:500px;center:yes");

			if (strReturnValue != "") {
				enableAll();
				var returnArray = string2Array(strReturnValue, ",");
				document.getElementById("txtSeq").value = returnArray[0];
				document.getElementById("txtCurr").value = returnArray[1];
				document.getElementById("txtRemAmtFrom").value = formatInteger( returnArray[2] );
				document.getElementById("txtRemAmtTo").value = formatInteger( returnArray[3] );
				document.getElementById("txtBankFee").value = formatInteger( returnArray[4] );
				document.getElementById("txtFiscFee").value = formatInteger( returnArray[5] );
				document.getElementById("txtRemFee").value = formatInteger( returnArray[6] );
				document.getElementById("txtMemo").value = returnArray[7];

				document.getElementById("txtOldCurr").value = returnArray[1];
				document.getElementById("txtOldRemAmtFrom").value = returnArray[2];
				document.getElementById("txtOldRemAmtTo").value = returnArray[3];
				
				document.getElementById("txtAction").value = "I";
				winToolBar.ShowButton( "U,E" );
				window.status = "目前為查詢狀態,若要修改或刪除資料,請先選擇修改或刪除功能鍵";
				//	document.getElementById("frmMain").submit();
			}

		}

	}

	function resetAction() {
		document.getElementById("txtSeq").value = "";
		document.getElementById("txtCurr").value = "NT";
		document.getElementById("txtRemAmtFrom").value = "";
		document.getElementById("txtRemAmtTo").value = "";
		document.getElementById("txtBankFee").value = "";
		document.getElementById("txtFiscFee").value = "";
		document.getElementById("txtRemFee").value = "";
		document.getElementById("txtMemo").value = "";
		
		document.getElementById("txtOldCurr").value = "";
		document.getElementById("txtOldRemAmtFrom").value = "";
		document.getElementById("txtOldRemAmtTo").value = "";
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
		// 先加上匯款金額
		var bankFee = parseInt( document.getElementById("txtBankFee").value.replace(/,/g, ""), 10 );
		var fiscFee = parseInt( document.getElementById("txtFiscFee").value.replace(/,/g, ""), 10 ); 
		document.getElementById("txtRemFee").value = formatInteger( bankFee + fiscFee + "" );
		
		// 一律由 server 判斷處理
		document.getElementById("frmMain").submit();
	}
	
	function runSubmit() {
		
		// get ajax request object
		var myHttpRequest;
		
		if( window.XMLHttpRequest ){	//Mozilla,IE7.0
			myHttpRequest = new XMLHttpRequest();
			if(myHttpRequest.overrideMimeType){
				myHttpRequest.overrideMimeType("text/xml");
			}
		}else if(window.ActiveXObject){//IE
			try{
				myHttpRequest = new ActiveXObject("Msxml2.XMLHTTP");
			}catch(e){
			try{
				myHttpRequest = new ActiveXObject("Microsoft.XMLHTTP");
			}catch(e){}
			}
		}
		
		// get request data
		var myFields = [ "txtCurr", "txtRemAmtFrom", "txtRemAmtTo", 
		                 "txtBankFee", "txtFiscFee", "txtRemFee", 
		                 "txtMemo", "txtSeq", "txtAction", 
		                 "txtOldCurr", "txtOldRemAmtFrom", "txtOldRemAmtTo" ];
		var queryString = "";
		var i;
		for( i = 0 ; i < myFields.length ; i++ ) {
			queryString = queryString 
						+ myFields[i] 
						+ "=" + document.getElementById(myFields[i]).value + "&";
		}
		
		// send data
		myHttpRequest.open( "POST", strServerProgram, false );	
		myHttpRequest.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		myHttpRequest.send( queryString );	//呼叫 Server 端程式, 並等待回應
		
		// show result message
		var respText = myHttpRequest.responseText;
		if( respText.substring( 0, 10 ) == "UpdateMsg=" )	// 為正常控制下的回應
			respText = respText.substring( 10 );
		else
			respText = myHttpRequest.responseText;			// 失控下的回應, 可能是 HTML code
		respText = respText.replace(/(^\s*)|(\s*$)/g, "");
			
		if( myHttpRequest.status < 300 ) {	// HTTP 的 2XX 大致上為 NORMAL
			
			alert( respText );
		
			winToolBar.ShowButton( "U,E" );
			disableAll();
			// 成功後把主要 key 值抄起來, 才方便連續修改
			document.getElementById( "txtOldCurr" ).value = document.getElementById( "txtCurr" ).value;
			document.getElementById( "txtOldRemAmtFrom" ).value = document.getElementById( "txtRemAmtFrom" ).value;
			document.getElementById( "txtOldRemAmtTo" ).value = document.getElementById( "txtRemAmtTo" ).value;
			
		} else {
			alert( "存檔失敗： " + respText );
		}
	}
	
	// 毫無彈性, 功能相當狹隘的 function
	function formatInteger( numString ) {
	    
		var num = parseInt( numString.replace(/(^\s*)|(\s*$)/g, "") );
		if( isNaN( num ) )
			return numString;
		
		var intStr = num + "";
		var step = 3;
		var pos = intStr.length % step;
		var output = "";
		if( pos > 0 )
			output += ( intStr.substring( 0, pos ) );
		while( pos < intStr.length ) {
			if( pos > 0 )
				output += ",";
			output += intStr.substring( pos, pos+3 );
			pos+=3;
		}
		return output;
	}
</script>
</head>
<body onload="WindowOnLoad()">

<div style="margin-top: 30px; margin-left: 30px;">
<form id="frmMain" name="frmMain" method="post" action="javascript: runSubmit();">
<TABLE border="0" >
	<TBODY>
		<TR>
			<TD>幣別：</TD>
			<TD>
				<INPUT type="text" id="txtCurr" name="txtCurr" size="4"
					maxlength="2" value="NT" class="Key" disabled="disabled">
			</TD>
		</TR>
		<TR>
			<TD>匯款金額 *：</TD>
			<TD>
				&nbsp;起：<INPUT type="text" id="txtRemAmtFrom" name="txtRemAmtFrom" size="20"
					maxlength="20" value="" class="Data">
				&nbsp;訖：<INPUT type="text" id="txtRemAmtTo" name="txtRemAmtTo" size="20"
					maxlength="20" value="" class="Data">
			</TD>
		</TR>
		<TR>
			<TD>銀行手續費 *：</TD>
			<TD>
				<INPUT type="text" id="txtBankFee" name="txtBankFee" size="10"
					maxlength="10" value="" class="Data">
			</TD>
		</TR>
		<TR>
			<TD>金資手續費 *：</TD>
			<TD><INPUT type="text" id="txtFiscFee" name="txtFiscFee" size="10"
					maxlength="10" value="" class="Data">
			</TD>
		</TR>
		<TR>
			<TD>匯款手續費 *：</TD>
			<TD><INPUT type="text" id="txtRemFee" name="txtRemFee" size="10"
					maxlength="10" value="" class="Data" disabled="disabled">
			</TD>
		</TR>
		<TR>
			<TD>備註：</TD>
			<TD><INPUT type="text" id="txtMemo" name="txtMemo" size="40"
				maxlength="40" value="" class="Data" ></TD>
		</TR>
	</TBODY>
</TABLE>


<INPUT name="txtSeq" 			id="txtSeq"			type="hidden" value=""> 
<INPUT name="txtAction" 		id="txtAction" 		type="hidden" value=""> 
<INPUT name="txtMsg" 			id="txtMsg" 		type="hidden" value="">
<INPUT name="txtOldCurr" 		id="txtOldCurr" 	type="hidden" value="">
<INPUT name="txtOldRemAmtFrom" 	id="txtOldRemAmtFrom" type="hidden" value="">
<INPUT name="txtOldRemAmtTo" 	id="txtOldRemAmtTo" type="hidden" value="">


</form>
</body>
</div>
</html>