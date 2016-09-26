var strErrMsg = "";						//batch檢查之錯誤訊息
var strFunctionKeyInitial="A,I";			//程式預設之功能鍵:新增,查詢
var strFunctionKeyAdd="S,R,E";			//新增鈕按下後之功能鍵:儲存,清除,離開
var strFunctionKeyUpdate="S,E";			//修改鈕按下後之功能鍵:儲存,離開
var strFunctionKeyInquiry="U,D,E";		//查詢鈕按下後之功能鍵:修改,刪除,離開
var strFunctionKeyDelete="H,E";			//刪除鈕按下後之功能鍵:確定,離開

// added by elsa 2002/03/27 start
var strFunctionKeyReport="L,R";			//Report 上的查詢鍵
var strFunctionKeyInquiry_1="E";		//查詢鈕按下後之功能鍵:離開
var strFunctionKeyInquiry1="H,R,E";		//查詢鈕按下後之功能鍵:確定,清除,離開
// added by elsa 2002/03/27 end

//var keyBackgroundColor = "#F7EED9";
//var dataBackgroundColor = "white";

var keyBackgroundColor = null;
var dataBackgroundColor = null;
var queryBackgroundColor = null;

getDefaultColor();

//toolbar frame 中要顯示的功能鍵,會按照排列順序出現
//A:新增,U:修改,D:刪除,I:查詢,B:新增細項,F:刪除細項E:離開,R:清除
/*              A:新增
				U:修改
				D:刪除
				I:查詢
				E:離開
				R:清除
				P:列印
				B:新增明細
				C:修改明細
				F:刪除明細
				G:查詢明細
				H:確定
				J:上一頁
				K:下一頁
				S:儲存
				L:報表Report
				Q:保單帳戶價值查詢
				W:保單帳戶價值歷史資料查詢
*/
//toolbar frame 中要顯示的功能鍵,會按照排列順序出現
//函數名稱:	OnLoad( String strTitle, String strProgId, strThisFunctionKey )
//函數功能:	當Client端畫面啟動時,執行本函數.
//		1.先在title frame顯示程式代號及程式名稱,程式代號及程式名稱要在<BODY>tag中修改
//		2.若txtClientMsg欄位不為空白時, 表示有錯誤訊息,使用alert()顯示它
//		3.在toolbar frame顯示功能鍵
//傳入參數:	String strTitle: 程式名稱,置於title frame之中央,這個變數是使用本頁面之
//					document.title,應修改本jsp之<TITLE>tag
//		String strProgId:	程式代號,置於title frame之左側.變數來源為jsp之strThisProgId.
//		String strThisFunctionKey: 要顯示的功能鍵代號,A:新增,U:修改,D:刪除,I:查詢,E:離開,R:清除
//		String strFirstField: 輸入的第一個欄位
//傳回值:	無
//修改紀錄:	修改日期	修改者	修   改   摘   要
//		---------	----------	-----------------------------------------



/**
函數名稱:	ToolBarClick( String strButtonTag )
函數功能:	當toolbar frame中任一按鈕click時,就會執行本函數.當執行本函數時會傳入一個字串,
		該字串代表toolbar frame中哪一個按鈕被click
		當新增,修改按鈕時,先執行全部欄位檢查,若有任一欄位錯誤時,
		就顯示全部錯誤訊息,若正確時則將bntAction設定為傳入之參數值,
		並執行MainForm.submit(),將輸入之欄位傳送至web server
		若為查詢及刪除時,僅檢查鍵值是否正確,若正確,則將bntAction設定為傳入之參數值,
		並執行MainForm.submit(),將輸入之欄位傳送至web server
		若為清除時,則將各欄位清空.
傳入參數:	String strButtonTag: 	A:新增按鈕
						U:修改按鈕
						D:刪除按鈕
						I:查詢按鈕
						R:清除按鈕
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function ToolBarOnClick(strButtonTag)
{
	if( iInterval != "" )
	{
		window.clearInterval(iInterval);
		iInterval = "";
	}
	if( strButtonTag == "A" )			//新增鈕
	{
		document.getElementById("txtAction").value = strButtonTag ;
		addAction();
	}
	else if( strButtonTag == "U" )		//修改鈕
	{
		document.getElementById("txtAction").value = strButtonTag ;
		updateAction();
	}
	else if( strButtonTag == "D" )		//刪除鈕
	{
		document.getElementById("txtAction").value = strButtonTag ;
		deleteAction();
	}
	else if( strButtonTag == "I" )		//查詢鈕
	{
		document.getElementById("txtAction").value = strButtonTag ;
		inquiryAction();
	}
	else if( strButtonTag == "E" )		//離開鈕
	{
		exitAction();
	}
	else if( strButtonTag == "R" )		//清除鈕
	{
	    resetAction();
	}
	else if( strButtonTag == "H" )		//確定
	{
		confirmAction();
	}
	else if( strButtonTag == "S" )		//儲存
	{
		saveAction();
	}	
	else if ( strButtonTag == "L" )			//報表Report  added by elsa 2002/03/27 start
	{
		document.getElementById("txtAction").value = strButtonTag ;
		printRAction(); // added by elsa 2002/03/27 end
	}
	else if( strButtonTag == "Q" )		
	{
		PAQuiryAction();
	}
	else if (strButtonTag == "W" )
	{
		PAQuiryAction(); // added by Kiwi 10/01/2002
	}
	else
	{//若有未處理的按鈕值,顯示錯誤訊息
		alert("The button flag = '"+strButtonTag+"' unhandled");
	}
}


/**
函數名稱:	areAllFieldsOk()
函數功能:	呼叫checkFieldsClient()檢核所有欄位是否輸入正確
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function areAllFieldsOK()
{
	var i=0;
	var bReturnStatus = true;
	strErrMsg = "";
	if( document.getElementById("frmMain").getElementsByTagName("INPUT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("INPUT");
		for(k=0;k<coll.length;k++)
		{
			if( !checkClientField(coll[k],false) )
			{
				bReturnStatus = false;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("SELECT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("SELECT");
		for(k=0;k<coll.length;k++)
		{
			if( !checkClientField(coll[k],false) )
			{
				bReturnStatus = false;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("TEXTAREA") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("TEXTAREA");
		for(k=0;k<coll.length;k++)
		{
			if( !checkClientField(coll[k],false) )
			{
				bReturnStatus = false;
			}
		}
	}
	return bReturnStatus;
}

function clearAll()
{
	var i=0;
	var bReturnStatus = true;
	strErrMsg = "";
	if( document.getElementById("frmMain").getElementsByTagName("INPUT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("INPUT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" || coll[k].className == "Data" )
				coll[k].value = "";
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("SELECT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("SELECT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" || coll[k].className == "Data" )
				coll[k].value = "";
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("TEXTAREA") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("TEXTAREA");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" || coll[k].className == "Data" )
				coll[k].value = "";
		}
	}
	return bReturnStatus;
	
}

function disableKey()
{
	var i=0;
	var bReturnStatus = true;
	if( document.getElementById("frmMain").getElementsByTagName("INPUT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("INPUT");
		for(k=0;k<coll.length;k++)
		{
			//coll[k].style.backgroundImage = "url(../images/misc/cal.gif)" ;
			if( coll[k].className == "Key" ){
				coll[k].style.backgroundColor = keyBackgroundColor ;			
				coll[k].disabled = true;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("SELECT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("SELECT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" ){
				coll[k].style.backgroundColor = keyBackgroundColor ;			
				coll[k].disabled = true;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("TEXTAREA") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("TEXTAREA");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" ){
				coll[k].style.backgroundColor = keyBackgroundColor ;			
				coll[k].disabled = true;
			}
		}
	}
	return bReturnStatus;
}

function disableData()
{
	var i=0;
	var bReturnStatus = true;

	if( document.getElementById("frmMain").getElementsByTagName("INPUT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("INPUT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Data" )
			{
				coll[k].style.backgroundColor = dataBackgroundColor ;
				if( !coll[k].disabled )
					coll[k].disabled = true;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("SELECT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("SELECT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Data" )
			{
				coll[k].style.backgroundColor = dataBackgroundColor ;
				if( !coll[k].disabled )
					coll[k].disabled = true;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("TEXTAREA") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("TEXTAREA");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Data" )
			{
				coll[k].style.backgroundColor = dataBackgroundColor ;
				if( !coll[k].disabled )
					coll[k].disabled = true;
			}
		}
	}
	return bReturnStatus;
}

function enableKey()
{
	var i=0;
	var bReturnStatus = true;
	if( document.getElementById("frmMain").getElementsByTagName("INPUT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("INPUT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" )
			{
//			coll[k].style.backgroundImage = "" ;
				coll[k].style.backgroundColor = keyBackgroundColor ;
				if( coll[k].disabled ){
					coll[k].disabled = false;
				}
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("SELECT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("SELECT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" )
			{
				coll[k].style.backgroundColor = keyBackgroundColor ;
				if( coll[k].disabled )
					coll[k].disabled = false;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("TEXTAREA") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("TEXTAREA");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" )
			{
				coll[k].style.backgroundColor = keyBackgroundColor ;
				if( coll[k].disabled )
					coll[k].disabled = false;
			}
		}
	}
	return bReturnStatus;
}

function enableData()
{
	var i=0;
	var bReturnStatus = true;
	if( document.getElementById("frmMain").getElementsByTagName("INPUT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("INPUT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Data" )
			{
				coll[k].style.backgroundColor = dataBackgroundColor ;
				if( coll[k].disabled )
					coll[k].disabled = false;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("SELECT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("SELECT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Data" )
			{
				coll[k].style.backgroundColor = dataBackgroundColor ;
				if( coll[k].disabled )
					coll[k].disabled = false;
			}
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("TEXTAREA") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("TEXTAREA");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Data" )
			{
				coll[k].style.backgroundColor = dataBackgroundColor ;
				if( coll[k].disabled )
					coll[k].disabled = false;
			}
		}
	}
	return bReturnStatus;
}

function disableAll()
{
	disableKey();
	disableData();
}

function enableAll()
{
	enableKey();
	enableData();
}

function enableField( objField )
{
	if( objField.disabled )
		objField.disabled = false;
}

function disableField( objField )
{
	if( !objField.disabled )
		objField.disabled = true;
}

function enableQueryFields(fieldList){

//	getDefaultColor();
	var objFields = stringToArray( fieldList, "," );
	var tmpFieldName = "";
	for(var i=0, j=objFields.length ; i<j ; i++){
		enableField(document.getElementById(objFields[i]));
		document.getElementById(objFields[i]).style.background  = queryBackgroundColor ;
	}
}

function disableFields( fileldList){
	var objFields = stringToArray( fieldList, "," );
	var tmpFieldName = "";
	for(var i=0, j=objFields.length ; i<j ; i++){
		disableField(document.getElementById(objFields[i]));
	}
}

function updatePrevilege( strGrantedFunction )
{
	strFunctionKeyInitial = updateFunctionString(strGrantedFunction,strFunctionKeyInitial);
	strFunctionKeyAdd = updateFunctionString( strGrantedFunction,strFunctionKeyAdd);
	strFunctionKeyUpdate = updateFunctionString( strGrantedFunction,strFunctionKeyUpdate);
	strFunctionKeyInquiry = updateFunctionString( strGrantedFunction,strFunctionKeyInquiry);
	strFunctionKeyDelete = updateFunctionString( strGrantedFunction,strFunctionKeyDelete);	
	strFunctionKeyReport = updateFunctionString( strGrantedFunction,strFunctionKeyReport);	
	strFunctionKeyInquiry_1 = updateFunctionString( strGrantedFunction,strFunctionKeyInquiry_1);	
	strFunctionKeyInquiry1 = updateFunctionString( strGrantedFunction,strFunctionKeyInquiry1);	
	
}

function getDefaultColor(){
//alert("BB");
//debugger ;
	if(dataBackgroundColor == null){
		for(i=0, j=document.styleSheets.length ; i<j ; i++){
			if(document.styleSheets[i].cssText.indexOf(".Data")!=-1){
				for(k = 0, l=document.styleSheets[i].rules.length ; k<l ; k++){
					if(document.styleSheets[i].rules[k].selectorText == ".Data"){
						dataBackgroundColor = 
							document.styleSheets[i].rules[k].style.backgroundColor ;
						break;
					}
				}
				break;
			}
		}
	}else{
	//	alert(dataBackgroundColor);
	}

//debugger ;
	if(keyBackgroundColor == null){
		for(i=0, j=document.styleSheets.length ; i<j ; i++){
			if(document.styleSheets[i].cssText.indexOf(".Key")!=-1){
				for(k = 0, l=document.styleSheets[i].rules.length ; k<l ; k++){
					if(document.styleSheets[i].rules[k].selectorText == ".Key"){
						keyBackgroundColor = 
							document.styleSheets[i].rules[k].style.backgroundColor ;
						break;
					}
				}
				break;
			}
		}
	}else{
	//	alert(keyBackgroundColor);
	}
	
	if(queryBackgroundColor == null){
		for(i=0, j=document.styleSheets.length ; i<j ; i++){
			if(document.styleSheets[i].cssText.indexOf(".Query")!=-1){
				for(k = 0, l=document.styleSheets[i].rules.length ; k<l ; k++){
					if(document.styleSheets[i].rules[k].selectorText == ".Query"){
						queryBackgroundColor = 
							document.styleSheets[i].rules[k].style.backgroundColor ;
						break;
					}
				}
				break;
			}
		}
	}else{
		//
	}	
}



