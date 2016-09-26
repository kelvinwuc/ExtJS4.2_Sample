var strErrMsg = "";						//batch檢查之錯誤訊息
var strFunctionKeyInitial="A,I";		//程式預設之功能鍵:新增,查詢
var strFunctionKeyInitial1="AC,I";		//程式預設之功能鍵:新增CAPSIL,新增FF,查詢
var strFunctionKeyAdd="S,R,E";			//新增鈕按下後之功能鍵:儲存,清除,離開
var strFunctionKeyUpdate="S,E";			//修改鈕按下後之功能鍵:儲存,離開
var strFunctionKeyInquiry="U,D,E";		//查詢鈕按下後之功能鍵:修改,刪除,離開
var strDISBFunctionKeyInitial="I";		//程式預設之功能鍵:查詢
var strDISBFunctionKeyConfirm="I,DISBPaymentConfirm,E";	//查詢鈕按下後之功能鍵:查詢,支付確認,離開
var strDISBFunctionKeyInquiry="U,DISBPVoidable,E";		//查詢鈕按下後之功能鍵:修改,作廢,離開
var strDISBFunctionKeyInquiry_1="DISBCancelConfirm,E";	//查詢鈕按下後之功能鍵:取消確認,離開
var strDISBFunctionKeyExit="E";		//查詢鈕按下後之功能鍵:離開
var strDISBFunctionKeySourceU="U,E";//查詢鈕按下後之功能鍵:修改,離開
var strDISBFunctionKeySourceC="DISBPaymentConfirm,U,E";		//查詢鈕按下後之功能鍵:支付確認,修改,離開
var strDISBFunctionKeySDetailsU="DISBBack,U";				//查詢鈕按下後之功能鍵:回上一層,修改
var strDISBFunctionKeyRemitFailed="DISBRemitFailed,E";		//查詢鈕按下後之功能鍵:匯退,離開
var strDISBFunctionKeyRemit="DISBRemit,E";		//查詢鈕按下後之功能鍵:查詢,整批匯款,離開
var strDISBFunctionKeyCheck="DISBCheckOpen,E";	//匯退鈕按下後之功能鍵:票據開立,離開
var strDISBFunctionKeyCR="DISBCRejected,E";		//查詢鈕按下後之功能鍵:票據退回,離開
var strDISBFunctionKeyCC="DISBCCreate,E";		//查詢鈕按下後之功能鍵:人工開票,離開
var strDISBFunctionKeyNotice="U,L,E";			//查詢鈕按下後之功能鍵:修改,報表,離開
var strDISBFunctionKeyRemitB="DISBDownload,L,E";//查詢鈕按下後之功能鍵:下載,報表,離開
var strDISBFunctionKeyRemitC="L,E";				//查詢鈕按下後之功能鍵:下載,報表,離開
var strDISBFunctionKeyCashed="DISBCheckCashed,E";//匯退鈕按下後之功能鍵:票據回銷,離開

var strFunctionKeyDelete="D,E";			//查詢鈕按下後之功能鍵:刪除,離開

var strFunctionKeyInquiry1="H,R,E";		//查詢鈕按下後之功能鍵:確定,清除,離開
var strFunctionKeyReport="L";			//程式預設之功能鍵:報表
var strFunctionKeyInquiry2="H,R,E,L";	//查詢鈕按下後之功能鍵:確定,清除,離開,報表  R60420
//var strRemitFailMaintainFunctionKey="U,I,R,E,L";		//程式預設之功能鍵:修改,查詢,清除,離開,報表  R90884
var strRemitFailMaintainFunctionKey="U,I,R,E";		//程式預設之功能鍵:修改,查詢,清除,離開  R10314
var strDISBFunctionKeyDown="DISBDownload,E";		//下載,離開

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
	else if( strButtonTag == "AC" )			//新增CAPSIL鈕
	{
		document.getElementById("txtAction").value = strButtonTag ;
		addAction();
	}
	else if( strButtonTag == "AF" )			//新增FF鈕
	{
		document.getElementById("txtAction").value = strButtonTag ;
		addFAction();
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
	else if (strButtonTag == "W" )
	{
		PAQuiryAction(); // added by Kiwi 10/01/2002
	}
	else if (strButtonTag == "DISBDownload" )
	{
		DISBDownloadAction(); // 下載
	}
	else if (strButtonTag == "DISBCancelConfirm" )
	{
		DISBCanConfirmAction(); // 取消確認
	}
	else if (strButtonTag == "DISBPaymentConfirm" )
	{
		DISBPConfirmAction(); // 支付確認
	}
	else if (strButtonTag == "DISBPVoidable" )
	{
		DISBPVoidableAction(); // 廢止
	}
	else if (strButtonTag == "DISBRemitFailed" )
	{
	
		DISBRemitFailedAction(); // 匯退
	}
	else if (strButtonTag == "DISBRemit" )
	{
	
		DISBRemitAction(); // 整批匯款
	}
	else if (strButtonTag == "DISBCheckOpen" )
	{
	
		DISBCheckOpenAction(); // 票據開立
	}
	else if (strButtonTag == "DISBBack" )
	{
	
		DISBBackAction(); //回上一層
	}
	else if (strButtonTag == "DISBCRejected" )
	{
	
		DISBCRejectedAction(); //票據退回
	}
	else if (strButtonTag == "DISBCCreate" )
	{
		DISBCCreateAction(); //人工開票
	}
	else if (strButtonTag == "DISBCheckCashed" )
	{
		DISBCheckCashedAction(); //票據回銷
	}
	//zhejun.he R00135
	else if (strButtonTag == "DISBUpdateRemark" ) 
	{
		DISBUpdateRemarkAction(); //修改備註
	}
	else if (strButtonTag == "DISBReopen" )
	{
		DISBReopenAction(); //重開
	}
	else if (strButtonTag == "DISBUpdateConfirm" )
	{
		DISBUpdateConfirmAction(); //確認修改
	}
	else if (strButtonTag == "DISBCancel" )
	{
		DISBCancelAction(); //取消
	}
	else if (strButtonTag == "DISBReopenConfirm" )
	{
		DISBReopenConfirmAction(); //確認重開
	}
	//
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
	strFunctionKeyInquiry2 = updateFunctionString( strGrantedFunction,strFunctionKeyInquiry2);	//R60420
	
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
/*
判斷是否有選項被勾選
2004/11/10  Elsa
*/
function IsItemChecked()
{
    var iflag=0;
    var strTmpMsg = "";
    var bReturnStatus = true;
    for (i=0;i< iTotalrec;i++ )
    {
	    var checkId = "ch" + i ;
         if(document.getElementById(checkId).checked)
        {
	    	iflag = 1;
	    	bReturnStatus = true;
	    	break;
	    }
	 }
     if(iflag==0)
    {
        strTmpMsg ="至少要勾選一筆項目";
        bReturnStatus=false;
    }
    if( !bReturnStatus )
	{
			alert( strTmpMsg );
	}
	return bReturnStatus;
}
/*
分頁按鈕的處理 2004/11/24  Elsa
*/
function ChangePage(ipage,iTpage,iCpage,iActionCode){
   var strid = "showPage"+ipage;
   var bReturnStatus = true;
   //要改變的頁數 :ipage
   //總頁數:iTpage
   //本頁:iCpage
   //執行動作:iActionCode   1-first 2-pre  3-next 4-last
 
  if((iActionCode == 1 || iActionCode == 2) && iCpage == 1)
  {
  		   bReturnStatus = false;
  			alert("這已是第一頁了");       
  	
  }
  else   if((iActionCode == 3 || iActionCode == 4) && iCpage == iTpage)
  {
      bReturnStatus = false;
      	alert("這已是最後一頁了");   
  }
  if(bReturnStatus)
  {
          document.getElementById(strid).style.display = "block";
		  if(ipage>1)
		   {
			for(i=1;i<ipage;i++)
			{
				var stridi="showPage"+i;
				document.getElementById(stridi).style.display = "none";
			}
		   }
		   if(ipage < iTpage)
		   {
			for(j=iTpage;j>ipage;j--)
			{
				var stridj="showPage"+j;
				document.getElementById(stridj).style.display = "none";
			}
		   }
   }
} 
function CheckAll()
{
	 for (var i=0;i<document.frmMain.elements.length;i++)
	 {
	    var e = document.frmMain.elements[i];
	    if (e.name != 'allbox')
	               e.checked = !e.checked;           
	 }
 }
/*
欄位值的selected  2004/12/07  Elsa
*/
function  makedataSelected(fieldName,fieldValue)
{
   if(fieldName == "selPUCrdType")
   {
      fieldItemArray = ["","VC","MC","JCB","NCC"];
   }
   else if(fieldName == "selUPMethod")
   {
       fieldItemArray = ["A","B","C"];
   }
   else if(fieldName == "selUPCrdEffM")
   {
       fieldItemArray = ["","01","02","03","04","05","06","07","08","09","10","11","12"];
   }
    else if(fieldName == "selUPCrdEffY")
   {
       fieldItemArray = ["","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020"];
   }
   for(var i=0; i<document.getElementById(fieldName).length;i++)
   {
   		
   		if(fieldItemArray[i] == fieldValue)
   		{
   			document.getElementById(fieldName).options[i].selected = true;
   		}
   }
}

/*Auto Complete  */
//R60550function autoComplete(field, select, property, forcematch)
function autoComplete(field, select, property, forcematch, objname)
{
	 //r60550 document.getElementById("selList").style.display = ""; 
	document.getElementById(objname).style.display = ""; 
	var found = false;
	for(var i = 0;i < select.options.length;i++)
	{
		if(select.options[i][property].toUpperCase().indexOf(field.value.toUpperCase()) == 0){found=true;break;}}
		if(found){select.selectedIndex = i;}else{select.selectedIndex = -1;}if(field.createTextRange){if(forcematch && !found){field.value=field.value.substring(0,field.value.length-1);return;}var cursorKeys ="8;46;37;38;39;40;33;34;35;36;45;";if(cursorKeys.indexOf(event.keyCode+";") == -1){var r1 = field.createTextRange();var oldValue = r1.text;var newValue = found ? select.options[i][property] : oldValue;if(newValue != field.value){field.value = newValue;var rNew = field.createTextRange();rNew.moveStart('character', oldValue.length) ;rNew.select();}}}
}

//r60550function disableList()
function disableList(objname)
{
//r60550document.getElementById("selList").style.display = "none"; 
	document.getElementById(objname).style.display = "none"; 
}		