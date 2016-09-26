/*	程式庫名稱:	NSCommon.js
	最後修改日期:89/01/10
	函數:
		函數名稱					寫作日期			主要功能
	===============================	======== =====================================
	1. ltrim(strInput)				89/01/10:傳回strInput字串左邊空白刪除後之字串
	2. rtrim(strInput)				99/01/10:傳回strInput字串右邊空白刪除後之字串
	3. NumFormat(nInput,strPatten)	89/01/10:傳回數字nInput按strPatten格式化之字串
*/

var strActiveTab = "";									//目前Active之頁面名稱	
var strStandardMenuColor = "blue";						//頁面(tab page)tag上文字之顏色
var strStandardMenuBackgroundColor = "lightyellow";		//頁面(tab page)tag底色



/*
	函數名稱: ltrim(strInput)
	主要功能: 將傳入字串左邊空白去掉後傳回
	輸入參數: string	strInput : 要刪除左邊空白之字串
	傳回值  : string			 : 刪除左邊空白後之字串
	寫作日期: 89/01/10
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
*/
function ltrim(strInput)
{
	var i = 0 
	var j = 0
	var strTmp = ""
	if( typeof(strInput) != "string")
	{
		return( strInput );
	}
	else
	{
		while( strInput.substr(j,1) == ' ' && j < strInput.length)
		{
			j++;
		}
		strTmp = "";
		for(i=j;i<strInput.length;i++)
		{
			strTmp = strTmp + strInput.substr(i,1);
		}
		return( strTmp );
	}
}


/*
	函數名稱: rtrim(strInput)
	主要功能: 將傳入字串右邊空白去掉後傳回
	輸入參數: string	strInput : 要刪除右邊空白之字串
	傳回值  : string			 : 刪除右邊空白後之字串
	寫作日期: 89/01/10
	修改記錄:
				修改者		修改日期			修改摘要

		============== =================== ====================================================
*/


function rtrim(strInput)
{
	var i = 0 
	var j = 0
	var strTmp = ""
	if( typeof(strInput) != "string")
	{
		return( strInput );
	}
	else
	{
		j = strInput.length;
		while( strInput.substr(j-1,1) == ' ' && j > 0)
		{
			j--;
		}
		strTmp = strInput.substr(0,j);
		return( strTmp );
	}
}

/*
函數名稱:	alltrim(strInput)
函數功能:	將傳入字串左右邊空白去掉後傳回
傳入參數:	string	strInput : 要刪除左右邊空白之字串
傳回值:		string			 : 刪除左右邊空白後之字串
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function alltrim(strInput)
{
	return ltrim(rtrim(strInput)) ;
}




/*
函數名稱:	checkTitleWindowState(strTitle,strProgId)
函數功能:	檢查title frame之網頁是否ready,在title frame ready後,顯示程式名稱
傳入參數:	string	strTitle : 要顯示於title視窗之程式名稱
			string  strProgId: 程式代號
傳回值:		無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkTitleWindowState(strTitle,strProgId)
{
	winTitle = window.parent.frames[iTitle];
	if( winTitle.document.getElementById("MainBody") != null )
	{
		var strCommand = "ShowTitle('"+strTitle+"','"+strProgId+"')";
		winTitle.iInterval = winTitle.setInterval(strCommand,1);
		if( oTitle != "" )
		{
			window.clearInterval(oTitle);
			oTitle = "";
		}
	}
}




/*
函數名稱:	checkToolBarWindowState(strThisFunctionKey)
函數功能:	檢查toolbar frame之網頁是否ready,在toolbar frame ready後,enable傳入之按鈕
傳入參數:	string	strThisFunctionKey : 要enable之功能鍵字串
傳回值:		無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkToolBarWindowState(strThisFunctionKey)
{
	winToolBar = window.parent.frames[iToolBar];
	if( winToolBar.document.getElementById("MainForm") != null )
	{
		var strCommand = "ShowButton('"+strThisFunctionKey+"')";
		winToolBar.iInterval = winToolBar.setInterval(strCommand,1);
		if( oToolBar != "")
		{
			window.clearInterval(oToolBar);
			oToolBar = "";
		}
	}
}



/*
函數名稱:	checkTopWindowState(strThisFunctionKey)
函數功能:	檢查toolbar frame之網頁是否ready,在toolbar frame ready後,enable傳入之按鈕,給查詢 dialog box 專用
傳入參數:	string	strThisFunctionKey : 要enable之功能鍵字串
傳回值:		無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkTopWindowState(strThisFunctionKey)
{
	winToolBar = window.parent.frames[iToolBar];
	if( winToolBar.document.getElementById("frmMain") != null )
	{
		var strCommand = "ShowButton('"+strThisFunctionKey+"')";
		winToolBar.iInterval = winToolBar.setInterval(strCommand,1);
		if( oToolBar != "")
		{
			window.clearInterval(oToolBar);
			oToolBar = "";
		}
	}
}




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

var oToolBar = "";
var oTitle = "";
var iToolBar = 0;
var iTitle = 0;
var iInterval = "";
var winTitle = "";
var winToolBar = "";


/*
函數名稱:	WindowOnLoadCommon(strTitle,strProgId,strThisFunctionKey,strFirstField)
函數功能:	各程式Window OnLoad時,執行本函數,測試title frame和toolbar frame是否ready,若ready則顯示程式名稱及功能鍵按鈕
傳入參數:	string	strTitle : 要顯示於title視窗之程式名稱
			string  strProgId: 程式代號
			string	strThisFunctionKey : 要enable之功能鍵字串
傳回值:		無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function WindowOnLoadCommon(strTitle,strProgId,strThisFunctionKey)
{
	// for MV menu
	if(parent.frames[0]&&parent.frames['menuFrame'].Go)
		parent.frames['menuFrame'].Go();

	var i,j;
	if( window.top.frames.length != 0 )
	{
		i = 0;
		while( i < window.top.frames.length )
		{
			var winTarget = window.top.frames[i];
			if( winTarget.name == 'titleFrame' )
			{
				iTitle = i;
				oTitle = window.setInterval("checkTitleWindowState('"+strTitle+"','"+strProgId+"')",100);
			}
			if( winTarget.name == 'toolbarFrame' )
			{
				iToolBar = i;
				oToolBar = window.setInterval("checkToolBarWindowState('"+strThisFunctionKey+"')",100);
			}
			i++;
		} 
	}
}

/*
函數名稱:	printDirect()
函數功能:	列印網頁
傳入參數:	無
傳回值:		無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function printDirect()
{
	/*
	document.body.insertAdjacentHTML("beforeEnd","<object id=\"idWBPrint\" width=0 height=0 classid=\"clsid:8856F961-340A-11D0-A96B-00C04FD705A2\"></object>");
	idWBPrint.ExecWB(6, 0x32 );
	idWBPrint.outerHTML = "";
	*/
	window.print();
}


/*
函數名稱:	padLeadingZero(strInput,iOutLength)
函數功能:	將傳入之字串左邊加0至需要之長度後傳回
傳入參數:	String strInput		: 待處理之字串
			int iOutLength		: 傳回字串之長度
傳回值:		String				: 處理後之新字串
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function padLeadingZero(strInput,iOutLength)
{
	if( strInput == null )
		strInput = '';
	var iLength = strInput.length;
	for(var i=iLength;i<iOutLength;i++)
		strInput = '0' + strInput;
	return strInput;
}

/*
函數名稱:	isNumber( strInput )
函數功能:	檢查字串是否為數值
傳入參數:	String strInput		: 待檢查之字串
傳回值:		true				: 輸入字串全為數字 , false : 輸入之字串不全是數字
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function isNumber( strInput )
{
	if( strInput == null || typeof( strInput ) != 'string' ) 
		return false;
 	if( strInput.length == 0 ) return false;
 	for( var loc=0; loc<strInput.length; loc++ )
 		if( (strInput.charAt(loc) < '0') || (strInput.charAt(loc) > '9') ) 
 			return false;
    if (parseInt(strInput , 10) < 0)
    {
		return false;
	} 
 	return true;
}

/**
函數名稱:	checkLength(objThisInputText)
函數功能:	檢核輸入欄位是否超過限制長度,To check whether the acture length is excessed the max length of this input field.
			The chinese character(in unicode form) is counted as two bytes of length.
傳入參數:	objThisInputText : 物件型態之欄位
傳回值:		true:acture length is not excess the max limited.
			false:acture length is excess the max length.
修改紀錄:	修改日期	修改者	修   改   摘   要
			---------	----------	-----------------------------------------
*/
function checkLength(objThisInputText)
{
	var iActureLength = 0;
	if( objThisInputText == null )
		return true;
	if( objThisInputText.maxLength == 'undefined' )
		return true;
	var strThisValue = objThisInputText.value;
	for(var i=0;i< strThisValue.length;i++)
	{
		if( strThisValue.charCodeAt(i) > 127)
			iActureLength += 2;
		else
			iActureLength++;
	}
	if( iActureLength > objThisInputText.maxLength )
		return false;
	else
		return true;
}

/**
函數名稱:	checkLength1(objThisInputText , numMaxLen)
函數功能:	檢核輸入欄位是否超過限制長度,To check whether the acture length is excessed the max length of this input field.
			The chinese character(in unicode form) is counted as two bytes of length.
傳入參數:	objThisInputText : 物件型態之欄位
            numMaxLen        : 最大長度
傳回值:		true:acture length is not excess the max limited.
			false:acture length is excess the max length.
修改紀錄:	修改日期	修改者	修   改   摘   要
			---------	----------	-----------------------------------------
*/
function checkLength1(objThisInputText , numMaxLen)
{
	var iActureLength = 0;
	if( objThisInputText == null )
		return true;
    if( numMaxLen == null )
		return true;		
	var strThisValue = objThisInputText.value;
	for(var i=0;i< strThisValue.length;i++)
	{
		if( strThisValue.charCodeAt(i) > 127)
			iActureLength += 2;
		else
			iActureLength++;
	}
	if( iActureLength > numMaxLen )
		return false;
	else
		return true;
}

// 閏年檢核
//     Parm :   n ==> YYY or "YYY" (民國年) or YYYY or "YYYY"(西元年)
//     Return : Boolean
function isLeapyear(n)
{
  var numTemp ;
  if (typeof n == "string")
     {
        //alert("string") ;
        numTemp = parseInt(n,10) ;
     }
  else if (typeof n == "number")
       {
         //alert("number") ;
         numTemp = n ;
       }
  else
       {
         //alert("other") ;
         return false;
       } 
  if (numTemp < 1000) 
     {
       numTemp = numTemp + 1911;
     } 
 // alert("numTemp='"+numTemp+"'");   
  if (numTemp % 4 == 0)
     {
       if (numTemp % 100 == 0)
          {
            if (numTemp % 400 == 0)
               {
                  return true;
               }
          }
// Q80145 閏年判斷修正
       else
          {  
          return true;
          }
     }
            
  return false;            
}

// 日期檢核
//    Parm1   : strDate(YYYMMDD or YYMMDD)--> 民國年  
//              strDate(YYYYMMDD)         --> 西元年
//    Return : Boolean

/**
函數名稱:	checkDate(strDate)
函數功能:	日期檢核
傳入參數:	strDate			: 待檢核之日期字串,格式為:YYYMMDD(國曆), YYMMDD(國曆) , YYYYMMDD(西曆)
傳回值:		true			: 合格之日期字串
			false			: 不合格之日期字串
修改紀錄:	修改日期	修改者	修   改   摘   要
			---------	----------	-----------------------------------------
*/
function checkDate(strDate) {
     var strYY , strMM , strDD , numYY , numMM , numDD;
//alert("strDate='"+strDate+"'");     
     if (strDate.length < 6 || !isNumber(strDate))
        {
          return false ;
        }
     else if  (strDate.length == 6 && isNumber(strDate))
        {
          strYY = strDate.substr(0,2);
          strMM = strDate.substr(2,2);
          strDD = strDate.substr(4,2);
          numYY = parseInt(strYY , 10) ;
          numMM = parseInt(strMM , 10) ;
          numDD = parseInt(strDD , 10) ;
        }
     else if  (strDate.length == 7 && isNumber(strDate))
        {
          strYY = strDate.substr(0,3);
          strMM = strDate.substr(3,2);
          strDD = strDate.substr(5,2);
          numYY = parseInt(strYY , 10) ;
          numMM = parseInt(strMM , 10) ;
          numDD = parseInt(strDD , 10) ;
        }
     else if  (strDate.length == 8 && isNumber(strDate))
        {
          strYY = strDate.substr(0,4);
          strMM = strDate.substr(4,2);
          strDD = strDate.substr(6,2);
          numYY = parseInt(strYY , 10) - 1911 ;
          numMM = parseInt(strMM , 10) ;
          numDD = parseInt(strDD , 10) ;
        }     
     else
        {
          return false ;
        } 
        if (numYY <= 0 || numYY > 999)
           { return false ;}
        if (numMM <= 0 || numMM > 12)
           { return false ;}
        if (numDD <= 0 || numDD > 31)
           { return false ;}
        switch (numMM){
          case 2  :
                  if (numDD > 30)
                     {
                       return false;
                     }
                  break;
          case 4  :
                  if (numDD > 30)
                     {
                       return false;
                     }
                  break;
          case 6  :
                  if (numDD > 30)
                     {
                       return false;
                     }
                  break;
          case 9  :
                  if (numDD > 30)
                     {
                       return false;
                     }
                  break;        
          case 11  :
                  if (numDD > 30)
                     {
                       return false;
                     }
                  break;                
          default :
		  			break;
                          
        } 
        if (numMM == 2 )
           {
            if (isLeapyear(numYY))
               {
                if (numDD > 29)
                   {
                     return false;
                   }
               }
             else
               {
                 if (numDD > 28)
                   {
                     return false;
                   }
               }  
           }
  return true ;

}

/*
函數名稱:	checkDate(strDate)
函數功能:	日期檢核
傳入參數:	strDate			: 待檢核之日期字串,格式為:YYYMMDD(國曆), YYMMDD(國曆) , YYYYMMDD(西曆)
傳回值:		true			: 合格之日期字串
			false			: 不合格之日期字串

*/
function isValidDate(strDate, strType){
	if(strType == null){
		strType = "C";
	}
	var checkDate = null;
	var returnStatus = true;
	if(strType=="C"){
		// Chinese date format
		checkDate = strDate.substring(0,3)+strDate.substring(4,6)+strDate.substring(7,9) ;
//alert("checkDate='"+checkDate+"'");		
	}else{
		// 西元年格式
		checkDate = strDate.substring(0,4)+strDate.substring(5,7)+strDate.substring(8,10);
	}

	if(this.checkDate(checkDate)){
		returnStatus = true;
	}else{
		returnStatus = false;
	}
	
	return returnStatus ;
	
}

/*
	函數名稱: toWestenDateString(strInput)
	主要功能: 將國曆日期轉為西曆日期
	輸入參數: string	strROCDate	: 國曆日期 YYYMMDD or YYY/MM/DD
	傳回值  : string				: 西曆日期 YYYY/MM/DD
	寫作日期: 91/03/18
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
*/
function toWestenDateString( strROCDate )
{
	var strReturn = "";
	if( strROCDate != null )
	{
		if( typeof( strROCDate ) == "string" )
		{
			if( strROCDate.length == 6 || strROCDate.length == 8)
				strROCDate = "0" + strROCDate;
			var iYY = parseInt(strROCDate.substr( 0 , 3 ),10);
			if( strROCDate.length == 7 )
				strReturn = NumFormat( iYY + 1911 , "9999" ) +"/"+ strROCDate.substr( 3, 2) + "/" + strROCDate.substr( 5, 2);
			else
				strReturn = NumFormat( iYY + 1911 , "9999" ) + strROCDate.substr( 3 , strROCDate.length-1 );
		}
	}
	return strReturn;
}


/*
	函數名稱: NumFormat(nInput,strPatten)
	主要功能: 將傳入之數字按照設定之樣板予以格式化
	輸入參數: numeric	nInput	 : 輸入之數字
			  string	strPatten: 格式之樣板
									格式字元		說明
									=============	===============================================
									9				一位數字,當該數字為零時會輸出0
									Z				一位數字,當該數字為零時不會輸出(suppress leading zero)
									$				一位數字,與Z相同,最左邊會加一$,
									.				小數點
									,				千位分格號
									-				一位數字,與Z相同,左邊會加負號
									+				一位數字,與Z相同,左邊會加正號
									
	傳回值  : string			 : 格式化之字串
	寫作日期: 89/01/10
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
*/



function NumFormat( nInput,strPatten )
{
	var strTmpPatten = ltrim(rtrim(strPatten))
	var iTmpPos = 0
	var nTmpInput = 0
	var i = 0
	var strReturnString = ""
	var iPrecision = 0
	var iTmpDigit = 0
	var cDecimalPoint = "."
	var cComma = ","
	var cOneDigit = "9"
	var cDollarSign = "$"
	var cSupressLeadingZero = "Z"
	var cSpace = " "
	var cPlusSign = "+"
	var cMinusSign = "-"
	var bHasSign = false
	var bOverflow = false
	var cOverflowChar = "#"
	var strTmpStr = ""
	if(( typeof( nInput ) != "number" ) || ( typeof( strPatten ) != "string" ))
		return "";
	iTmpPos = strTmpPatten.lastIndexOf(cDecimalPoint);
	if( iTmpPos == -1 )
	{//all will be out in integer format
		nTmpInput = Math.floor( Math.abs(nInput) );
		iPrecision = 0;
	}
	else
	{
		nTmpInput = Math.abs(nInput);
		iPrecision = strTmpPatten.length - iTmpPos - 1;
	}
	for(i=strTmpPatten.length-1;i>=0;i--)
	{
		if( iPrecision > 0 )
		{
			nTmpInput = Math.abs(nInput) * Math.pow(10,iPrecision);
		}
		else
		{
			nTmpInput = Math.abs(nInput)/ Math.pow(10,Math.abs(iPrecision));
			if( nTmpInput < 0 )
				nTmpInput = 0;
		}
		if( i==0 && nTmpInput >= 10 )
			bOverflow = true;
		iPrecision--;
		iTmpDigit = Math.floor(nTmpInput) % 10;
		switch(strTmpPatten.charAt(i))
		{
			case cOneDigit :
				strReturnString = iTmpDigit.toString() + strReturnString;
				break;
			case cSupressLeadingZero :
			case cPlusSign :
			case cMinusSign :
			case cDollarSign :
				if( iTmpDigit == 0 && iPrecision < 0 && nTmpInput < 10)
				{
					if( strTmpPatten.charAt(i) == cDollarSign && 
						strReturnString.charAt(0) != cDollarSign && 
						strReturnString.charAt(0) != cSpace)
					{
						strReturnString = cDollarSign + strReturnString;
					}
					else
						strReturnString = cSpace + strReturnString;
				}
				else
				{
					if( !(iPrecision > 0 && strReturnString.length == 0 && iTmpDigit == 0) )
						strReturnString = iTmpDigit.toString() + strReturnString;
				}
				if( strTmpPatten.charAt(i) == cPlusSign || strTmpPatten.charAt(i) == cMinusSign)
					bHasSign = true;
				break;
			case cComma :
				if( strReturnString.charAt(0) != cSpace )
					strReturnString = cComma + strReturnString;
				iPrecision++;
				break;
			case cDecimalPoint :
				strReturnString = cDecimalPoint + strReturnString;
				iPrecision++;
				break;
			default :
				strReturnString = strTmpPatten.charAt(i) + strReturnString;
				break;
		}
	}
	//check the final result
	for(i=0;i<strReturnString.length;i++)
	{
		if( strReturnString.charCodeAt(i) >= 0x30 && strReturnString.charCodeAt(i) <= 0x3a )
			break;
		if( strReturnString.charAt(i) == cComma )
		{
			strReturnString = strReturnString.substr(0,i) + strReturnString.substr(i+1,strReturnString.length-1);
		}
	}
	if( bHasSign || nInput < 0)
	{
		if( nInput < 0 )
			strReturnString = cMinusSign + strReturnString;
		else
			strReturnString = cPlusSign + strReturnString;
		 
	}
	strTmpStr = "";
	if( bOverflow )
	{
		for(i=0;i<strReturnString.length;i++)
		{
			if( strReturnString.charCodeAt(i) >= 0x30 && strReturnString.charCodeAt(i) <= 0x3a )
				strTmpStr = strTmpStr + cOverflowChar;
			else
				strTmpStr = strTmpStr + strReturnString.charAt(i);
		}
		strReturnString = strTmpStr;
	}
	
	return( ltrim(strReturnString) );
}


/*
	函數名稱: getSqlDate(dteDate)
	主要功能: 將日期物件轉為資料庫可以接受的格式
	輸入參數: string	dteDate	: 日期物件 
	傳回值  : string			: YYYY/MM/DD
	寫作日期: 91/03/23
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
*/
function getSqlDate( dteDate )
{
	if( typeof( dteDate ) != "object" )
	{
		return "";
	}
	var strSqlDate =  NumFormat( dteDate.getFullYear() , "9999" ) + "/" + NumFormat( dteDate.getMonth()+1 , "99" ) + "/" + NumFormat( dteDate.getDate() , "99" ) ; 
	return strSqlDate;
}


/*
	函數名稱: getSqlDateTime(dteDate)
	主要功能: 將日期物件轉為資料庫可以接受的格式
	輸入參數: string	dteDate	: 日期物件 
	傳回值  : string			: YYYY/MM/DD HH:MM:SS
	寫作日期: 91/03/23
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
*/
function getSqlDateTime( dteDate )
{
	if( typeof( dteDate ) != "object" )
	{
		return "";
	}
	var strSqlDateTime =  NumFormat( dteDate.getFullYear() , "9999" ) + "/" + NumFormat( dteDate.getMonth()+1 , "99" ) + "/" + NumFormat( dteDate.getDate() , "99" ) + " " + NumFormat( dteDate.getHours() , "99" )+":" + NumFormat( dteDate.getMinutes() , "99" )+":" + NumFormat( dteDate.getSeconds() , "99" ); 
	return strSqlDateTime;
}

/*
	函數名稱: getROCDateTime( iType , dteDate )
	主要功能: 將日期轉為國曆
	輸入參數: Date	dteDate		: 日期物件 
	傳回值  : string			: 
						output format : iType = 0 : YYY/MM/DD
										iType = 1 : YYY/MM/DD HH:MM:SS
										iType = 2 : YYYMMDD
										iType = 3 : YYYMMDDHHMMSS
										iType = 4 : YY/MM/DD
										iType = 5 : YY/MM/DD HH:MM:SS
										iType = 6 : YYMMDD
										iType = 7 : YYMMDD HHMMSS
	寫作日期: 91/03/23
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
					
*/
function getROCDateTime( iType , dteDate )
{
	if( typeof( dteDate ) != "object" )
	{
		return "not a date : " + typeof( dteDate );
	}
	var strROCDateTime = "";
	if( dteDate.getFullYear() < 1911 )
		dteDate.setFullYear(1911);
	switch( iType )
	{
		case 0 :  		// YYY/MM/DD
			strROCDateTime =  NumFormat( dteDate.getFullYear()-1911 , "999" ) + "/" + NumFormat( dteDate.getMonth()+1 , "99" ) + "/" + NumFormat( dteDate.getDate() , "99" ) ; 
			break;
		case 1 : 		// YYY/MM/DD HH:MM:SS
			strROCDateTime =  NumFormat( dteDate.getFullYear()-1911 , "999" ) + "/" + NumFormat( dteDate.getMonth()+1 , "99" ) + "/" + NumFormat( dteDate.getDate() , "99" ) + " " + NumFormat( dteDate.getHours() , "99" )+":" + NumFormat( dteDate.getMinutes() , "99" )+":" + NumFormat( dteDate.getSeconds() , "99" ); 
			break;
		case 2 : 		// YYYMMDD
			strROCDateTime =  NumFormat( dteDate.getFullYear()-1911 , "999" ) +  NumFormat( dteDate.getMonth()+1 , "99" ) +  NumFormat( dteDate.getDate() , "99" ) ; 
			break;
		case 3 : 		// YYYMMDDHHMMSS
			strROCDateTime =  NumFormat( dteDate.getFullYear()-1911 , "999" ) + NumFormat( dteDate.getMonth()+1 , "99" ) + NumFormat( dteDate.getDate() , "99" ) + NumFormat( dteDate.getHours() , "99" ) + NumFormat( dteDate.getMinutes() , "99" )+ NumFormat( dteDate.getSeconds() , "99" ); 
			break;
		case 4 : 		// YY/MM/DD
			strROCDateTime =  NumFormat( dteDate.getFullYear()-1911 , "99" ) + "/" + NumFormat( dteDate.getMonth()+1 , "99" ) + "/" + NumFormat( dteDate.getDate() , "99" ) ; 
			break;
		case 5 : 		// YY/MM/DD HH:MM:SS
			strROCDateTime =  NumFormat( dteDate.getFullYear()-1911 , "99" ) + "/" + NumFormat( dteDate.getMonth()+1 , "99" ) + "/" + NumFormat( dteDate.getDate() , "99" ) + " " + NumFormat( dteDate.getHours() , "99" )+":" + NumFormat( dteDate.getMinutes() , "99" )+":" + NumFormat( dteDate.getSeconds() , "99" ); 
			break;
		case 6 : 		// YYMMDD
			strROCDateTime =  NumFormat( dteDate.getFullYear()-1911 , "99" ) + NumFormat( dteDate.getMonth()+1 , "99" ) + NumFormat( dteDate.getDate() , "99" ) ; 
			break;
		case 7 : 		// YYMMDD HHMMSS
			strROCDateTime =  NumFormat( dteDate.getFullYear()-1911 , "99" ) + NumFormat( dteDate.getMonth()+1 , "99" ) + NumFormat( dteDate.getDate() , "99" ) + " " + NumFormat( dteDate.getHours() , "99" ) + NumFormat( dteDate.getMinutes() , "99" )+ NumFormat( dteDate.getSeconds() , "99" ); 
			break;
	}
	return strROCDateTime;
}

/*
	函數名稱: rocString2Date( iType , strDate )
	主要功能: 將國曆字串轉為日期
	輸入參數: String	strDate		: 日期物件 
						output format : iType = 0 : YYY/MM/DD
										iType = 1 : YYY/MM/DD HH:MM:SS
										iType = 2 : YYYMMDD
										iType = 3 : YYYMMDDHHMMSS
										iType = 4 : YY/MM/DD
										iType = 5 : YY/MM/DD HH:MM:SS
										iType = 6 : YYMMDD
										iType = 7 : YYMMDD HHMMSS

	傳回值  : Date			: 
	寫作日期: 92/09/18
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
					
*/
function rocString2Date( iType , strDate )
{
	// check parameter
	if(iType == null || strDate==null){
		return null;
	}
	
	var iYYYY = 0;
	var iMM = 0;
	var iDD = 0;
	var iHH = 0;
	var imm = 0;
	var iSS = 0;
	var dteReturn = new Date();

	switch( iType )
	{
		case 0 :  		// YYY/MM/DD
			iYYYY = parseInt(strDate.substring(0,3),10)+1911 ;
			iMM   = parseInt(strDate.substring(4,6),10)-1 ;
			iDD   = parseInt(strDate.substring(7,9),10) ;
			break;
		case 1 : 		// YYY/MM/DD HH:MM:SS
			iYYYY = parseInt(strDate.substring(0,3),10)+1911 ;
			iMM   = parseInt(strDate.substring(4,6),10)-1 ;
			iDD   = parseInt(strDate.substring(7,9),10) ;
			iHH   = parseInt(strDate.substring(10,12),10);
			imm   = parseInt(strDate.substring(13,15),10);
			iSS   = parseInt(strDate.substring(16,18),10);		
			break;
		case 2 : 		// YYYMMDD
			iYYYY = parseInt(strDate.substring(0,3),10)+1911 ;
			iMM   = parseInt(strDate.substring(3,5),10)-1 ;
			iDD   = parseInt(strDate.substring(5,7),10) ;
			break;
		case 3 : 		// YYYMMDDHHMMSS
			iYYYY = parseInt(strDate.substring(0,3),10)+1911 ;
			iMM   = parseInt(strDate.substring(3,5),10)-1 ;
			iDD   = parseInt(strDate.substring(5,7),10) ;
			iHH   = parseInt(strDate.substring(7,9),10);
			imm   = parseInt(strDate.substring(9,11),10);
			iSS   = parseInt(strDate.substring(11,13),10);		
			break;
		case 4 : 		// YY/MM/DD
			iYYYY = parseInt(strDate.substring(0,2),10)+1911 ;
			iMM   = parseInt(strDate.substring(3,5),10)-1 ;
			iDD   = parseInt(strDate.substring(6,8),10) ;
			break;
		case 5 : 		// YY/MM/DD HH:MM:SS
			iYYYY = parseInt(strDate.substring(0,2),10)+1911 ;
			iMM   = parseInt(strDate.substring(3,5),10)-1 ;
			iDD   = parseInt(strDate.substring(6,8),10) ;
			iHH   = parseInt(strDate.substring(9,11),10);
			imm   = parseInt(strDate.substring(12,14),10);
			iSS   = parseInt(strDate.substring(15,17),10);		
			break;
		case 6 : 		// YYMMDD
			iYYYY = parseInt(strDate.substring(0,2),10)+1911 ;
			iMM   = parseInt(strDate.substring(2,4),10)-1 ;
			iDD   = parseInt(strDate.substring(4,6),10) ;
			break;
		case 7 : 		// YYMMDD HHMMSS
			iYYYY = parseInt(strDate.substring(0,2),10)+1911 ;
			iMM   = parseInt(strDate.substring(2,4),10)-1 ;
			iDD   = parseInt(strDate.substring(4,6),10) ;
			iHH   = parseInt(strDate.substring(7,9),10);
			imm   = parseInt(strDate.substring(9,11),10);
			iSS   = parseInt(strDate.substring(11,13),10);		
			break;
	}
	
	dteReturn.setFullYear(iYYYY);
	dteReturn.setMonth(iMM);
	dteReturn.setDate(iDD);
	dteReturn.setHours(iHH);
	dteReturn.setMinutes(imm);
	dteReturn.setSeconds(iSS);
	
	return dteReturn;
}

/*
	函數名稱: westernString2Date( iType , strDate )
	主要功能: 將西曆字串轉為西曆日期
	輸入參數: String	strDate		: 日期物件 
						output format : iType = 0 : YYYY/MM/DD 或 YYYY-MM-DD
										iType = 1 : YYYY/MM/DD HH:MM:SS 或 YYYY-MM-DD HH:MM:SS
										iType = 2 : YYYYMMDD
										iType = 3 : YYYYMMDDHHMMSS

	傳回值  : Date			: 
	寫作日期: 92/09/18
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
					
*/
function westernString2Date( iType , strDate )
{
	// check parameter
	if(iType == null || strDate==null){
		return null;
	}
	var iYYYY = 0;
	var iMM = 0;
	var iDD = 0;
	var iHH = 0;
	var imm = 0;
	var iSS = 0;
	var dteReturn = new Date();

	switch( iType )
	{
		case 0 :  		// YYYY/MM/DD
			iYYYY = parseInt(strDate.substring(0,4),10) ;
			iMM   = parseInt(strDate.substring(5,7),10)-1 ;
			iDD   = parseInt(strDate.substring(8,10),10) ;
			break;
		case 1 : 		// YYYY/MM/DD HH:MM:SS
			iYYYY = parseInt(strDate.substring(0,4),10) ;
			iMM   = parseInt(strDate.substring(5,7),10)-1 ;
			iDD   = parseInt(strDate.substring(8,10),10) ;
			iHH   = parseInt(strDate.substring(11,13),10);
			imm   = parseInt(strDate.substring(14,16),10);
			iSS   = parseInt(strDate.substring(17,19),10);		
			break;
		case 2 : 		// YYYYMMDD
			iYYYY = parseInt(strDate.substring(0,4),10) ;
			iMM   = parseInt(strDate.substring(4,6),10)-1 ;
			iDD   = parseInt(strDate.substring(6,8),10) ;
			break;
		case 3 :  		// YYYYMMDDHHMMSS
			iYYYY = parseInt(strDate.substring(0,4),10) ;
			iMM   = parseInt(strDate.substring(4,6),10)-1 ;
			iDD   = parseInt(strDate.substring(6,8),10) ;
			iHH   = parseInt(strDate.substring(8,10),10);
			imm   = parseInt(strDate.substring(10,12),10);
			iSS   = parseInt(strDate.substring(12,14),10);		
			break;
	}
	
	dteReturn.setFullYear(iYYYY);
	dteReturn.setMonth(iMM);
	dteReturn.setDate(iDD);
	dteReturn.setHours(iHH);
	dteReturn.setMinutes(imm);
	dteReturn.setSeconds(iSS);
	return dteReturn;
}

function checkLogon( strProgram )
{
	var strUrl = Application("VirtualDirectory") + "/Default.asp";
	var strChangePasswordUrl = Application("VirtualDirectory") + "/ChangePassword.asp";
	if( strProgram == "" )
	{
		Response.Redirect(strUrl+"?Error=checkLogon():程式代號不可空白");
	}
	if( Session("UserId") == null )
	{
		Response.Redirect(strUrl+"?Error=checkLogon():使用者代號為空白,可能停留時間過長,超過"+Session.Timeout+"分鐘未異動,請重新登錄");
	}
	if( Session("PasswordStatus") == "1" )	//使用者密碼已過期
	{
		Response.Redirect(strChangePasswordUrl+"ReturnUrl=MainFrameSet.asp&Action=1");
	}
	if( Session("uiThisUserInfo") == null )
	{
		Response.Redirect( strUrl+"?Error=checkLogon():使用者資訊物件為空白,請先登錄系統");
	}
	var uiThisUserInfo = Session("uiThisUserInfo");
	if( !uiThisUserInfo.checkPrivilege(strProgram) )
	{
		Response.Redirect( strUrl+"?Error=checkLogon():使用者無權限執行本功能");
	}
	
}


/**
	函數名稱: executeSql(strSql)
	主要功能: 由Client端至Server執行傳入之SQL Statement
	備    註: 執行SQL Statement 後,Server 傳回執行結果都會放在 XMLDOM 物件中,呼叫的程式要自行檢查是否成功,
			最先檢查 txtMsg 欄位,若該欄位不為空白,表示有錯誤發生
			再檢查 txtRowCount, 是一個數字,該欄位表示傳入之 SQL Statement 執行後總共讀取多少 rows
			若是 txtRowCount > 1 , 表示有多筆資料被傳回, 若要讀取整個 row , 可以取得 ExecuteSqlXMLRowN , 
			其中最後一個字母的 N 表示第幾筆記錄, 例如:第一筆記錄為 ExecuteSqlXMLRow1 , 第二筆記錄為 ExecuteSqlXMLRow2 ,
			請參考下面的使用範例
	輸入參數: String strSql	: 待執行之 SQL Statement 
	傳回值  : Microsoft.XMLDOM 物件			: 
	寫作日期: 91/09/25
	修改記錄:
				修改者		修改日期			修改摘要
			============== =================== ====================================================
					
	Sample :	var strSql = "select * from CallCenter..tuser where user_id = '"+document.getElementById("txtUserId").value+"'";
			var xmlDom = executeSql( strSql );
			if( xmlDom.getElementsByTagName("txtMsg").item(0).text != "" )
			{
				alert( xmlDom.getElementsByTagName("txtMsg").item(0).text );
				bReturnStatus = false;
			}
			else
			{
				if( xmlDom.getElementsByTagName("txtRowCount").item(0).text =="0" )
				{
					strTmpMsg = "使用者代號 '"+objThisItem.value+"' 位存於系統中,請重新輸入";
					bReturnStatus = false;
				}
				else
				{
					document.getElementById("txtUserName").value = xmlDom.getElementsByTagName("user_name").item(0).text;
				}
			}
*/

function executeSql(strSql,connectionType)
{
	var strUrl = '../ExecuteSql/ExecuteSqlXML.jsp';
	var objTable = document.createElement("TABLE");
	var objDiv = document.createElement("DIV");
	var xmldomData = new ActiveXObject("Microsoft.XMLDOM");
	var xmldomResponseData = new ActiveXObject("Microsoft.XMLDOM");
	var oRootNode = xmldomData.createElement("XML");
	var conType = null;
	
	if(connectionType == "4"){
		conType = "4";
	}else{
		conType = "S";
	}

	var strStatus = window.status;
	window.status = "至 Server 查詢資料中,請稍候....";
	xmldomData.appendChild( oRootNode );
	//將sql,txtMsg先存入 XMLDOM 物件中
	var oTmpNode = xmldomData.createElement("txtSql");
	oTmpNode.text = strSql;
	oRootNode.appendChild( oTmpNode );
	oTmpNode = xmldomData.createElement("txtMsg");
	oTmpNode.text = "";
	oRootNode.appendChild( oTmpNode );
	oTmpNode = xmldomData.createElement("txtConnectionType");
	oTmpNode.text = conType;
	oRootNode.appendChild( oTmpNode );

	var xmlHttp = new ActiveXObject( "msxml2.XMLHTTP" );
	//設定 Server 端程式, 第一個參數為 POST 表示使用 POST 呼叫 Server , 第二個參數為 Server 端程式名稱, 如果 menu 是使用 Cache 時,須使用 full path , 否則會找不到程式
	// 第三個參數是表示是否使用非同步呼叫,若使用 false 時,則在下面使用 send() 呼叫時會等 Server 會應完成後才繼續進行
	xmlHttp.open('POST',strUrl, false );	

	xmlHttp.setRequestHeader("Content-type","text/xml");
	
	//呼叫 Server 端程式, 並等待回應
	xmlHttp.send( xmldomData );

//	alert( xmlHttp.responseText );
//	document.getElementById("txtShow").outerHTML = xmlHttp.responseText;

	// xmlHttp.status 表示 Server 回應碼, 為一般之 HTTP 回應碼, 小於 300 表示正常, 通常是 200 
	if( xmlHttp.status < 300 )
	{	// Server 端程式正常結束
		// xmlhttp.responseText 中存放著 Server 端回應之 XML 資料, 使用 loadXML() 將該資料載入 XMLDOM 物件中
		if( xmlHttp.responseText.indexOf("<HTML>") >= 0 )
		{
			if( showServerError( xmlHttp.responseText ) > 0 )
			{
				xmldomResponseData = null;
				top.open( "../Logon/Logon.jsp","_self" );
			}
		}
		else
		{
			xmldomResponseData.loadXML( xmlHttp.responseText );
			// 若 txtMsg 不為空白(一般都不為空白), 則先顯示訊息
			if( xmldomResponseData.getElementsByTagName("txtMsg").length != 0 )
			{
				if( xmldomResponseData.getElementsByTagName("txtMsg").item(0).text != "" )
				{
					alert(xmldomResponseData.getElementsByTagName("txtMsg").item(0).text );
				}
				if( xmldomResponseData.getElementsByTagName("txtMsgNo").length != 0 )
				{
					var iMsgNo = parseInt(xmldomResponseData.getElementsByTagName("txtMsgNo").item(0).text,10);
					if( iMsgNo == 300 || 
						iMsgNo == 301 ||
						iMsgNo == 302 ||
						iMsgNo == 303 ||
						iMsgNo == 304 ||
						iMsgNo == 305 	)
					{
						xmldomResponseData = null;
						top.open( "../Logon/Logon.jsp","_self" );
					}
				}
			}	
			else
			{
				oRootNode = xmldomResponseData.createElement("XML");
				oTmpNode = xmldomResponseData.createElement("txtMsg");
				oTmpNode.text = "Server Error Status = "+xmlHttp.status + " :"+xmlHttp.statusText+"\r\n"+xmlHttp.responseText;
				oRootNode.appendChild( oTmpNode );
				oTmpNode = xmldomResponseData.createElement("txtMsg");
				oTmpNode.text = "Server Error Status = "+xmlHttp.status + " :"+xmlHttp.statusText+"\r\n"+xmlHttp.responseText;
				oRootNode.appendChild( oTmpNode );
				oTmpNode = xmldomResponseData.createElement("txtRowCount");
				oTmpNode.text = "0";
				oRootNode.appendChild( oTmpNode );
				xmldomResponseData.appendChild( oRootNode );
			}
		}
	}
	else
	{	// xmlHttp.responseText 中存放著 Server 端傳回之錯誤畫面, 使用 alert() 並不十分恰當, 以後可再改善
		showServerError( xmlHttp.responseText );
		oRootNode = xmldomResponseData.createElement("XML");
		oTmpNode = xmldomResponseData.createElement("txtMsg");
		oTmpNode.text = "Server Error Status = "+xmlHttp.status + " :"+xmlHttp.statusText+"\r\n"+xmlHttp.responseText;
		oRootNode.appendChild( oTmpNode );
		oTmpNode = xmldomResponseData.createElement("txtRowCount");
		oTmpNode.text = "0";
		oRootNode.appendChild( oTmpNode );
		xmldomResponseData.appendChild( oRootNode );
	}
	window.status = strStatus;
	return xmldomResponseData;
}



/*
函數名稱:	switchTab(strTabName,strMenuName)
函數功能:	更換目前Active頁面,同時更換menu項目之反白及內容頁面之更換
傳入參數:	strTabName 	: 下半部內容頁面之頁面id
			strMenuName	: 上半部menu頁面之頁面id
傳回值:		無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function switchTab(strTabName,strMenuName)
{
	//若該頁面已是Active則立刻返回
	if( strTabName == strActiveTab )
		return;
	var objDiv = document.getElementById( strTabName );
	if( objDiv == null )
	{
		alert( strTabName+" is not in the document");
		return;
	}
	//取得全部之DIV
	var objAllDiv = document.getElementsByTagName("DIV");
	if( objAllDiv != null )
	{
		for( i=0;i<objAllDiv.length;i++)
		{
			//只處理class為tab_panel(下半部)及MenuClass(上半部)之DIV
			if( objAllDiv.item(i).className != "tab_panel" && objAllDiv.item(i).className != 'MenuClass' )
				continue;
			//tab_panel下半部內容頁面
			if(  objAllDiv.item(i).className == 'tab_panel' )
			{
				//找到了就將display屬性設為block,否則都設為none
				if( objAllDiv.item(i).id == strTabName )
				{
					objAllDiv.item(i).style.display = "block";
					strActiveTab = strTabName;
				}
				else
				{
					objAllDiv.item(i).style.display = "none";
				}
			}
			else if( objAllDiv.item(i).className == 'MenuClass' )
			{
			//MenuClass上半部Menu名稱
				//將Active頁面反白(使用之Fore Ground Color 為 strStandardMenuBackgroundColor, Back Ground Color 為 strStandardMenuColor),其餘改為正常
				if( strMenuName == objAllDiv.item(i).id )
				{
					objAllDiv.item(i).style.backgroundColor = strStandardMenuColor;
					objAllDiv.item(i).style.color = strStandardMenuBackgroundColor;
				}
				else
				{
					objAllDiv.item(i).style.backgroundColor = strStandardMenuBackgroundColor;
					objAllDiv.item(i).style.color = strStandardMenuColor;
				}
			}
		}
	}
	var objTabMenu = document.getElementById("tabMenu");
	var iTotalWidth = objTabMenu.clientWidth;
	//重新計算每一個menu之寬度
	if( objTabMenu != null )
	{
		var objAllColumns = objTabMenu.getElementsByTagName("TD");
		var iTotalColumn = 0;
		for(i=0;i<objAllColumns.length;i++)
		{
			if( objAllColumns.item(i).style.display != 'none' )
				iTotalColumn++;
		}
		var iAllocatedWidth = 0;
		for(i=0;i<objAllColumns.length;i++)
		{
			if( objAllColumns.item(i).style.display != 'none' )
			{
				if( i != objAllColumns.length-1 )
				{
					objAllColumns.item(i).width = Math.round( iTotalWidth / iTotalColumn );
					objAllColumns.item(i).children(0).style.pixelWidth = Math.round( iTotalWidth / iTotalColumn );
					iAllocatedWidth += Math.round( iTotalWidth / iTotalColumn );
				}
				else
				{
					objAllColumns.item(i).width = iTotalWidth - iAllocatedWidth;
					objAllColumns.item(i).children(0).style.pixelWidth = iTotalWidth - iAllocatedWidth;
				}
				objAllColumns.item(i).children(0).style.textAlign = 'center';
				objAllColumns.item(i).children(0).style.verticalAlign = 'middle';
			}
		}
	}

}


/**
函數名稱:	validId()
函數功能:	身份證號碼檢核
傳入參數:	inparm1 : 身份證號碼  (String-X10) 
傳回值:	        true(bol)  : Ok
傳回值:	        false(bol) : Fail
Author:         Tender
CreatedDate :   90/08/14
 		91/09/19
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function validId(inparm1) 
{
	var FirstEng,FirstNumber,Flag,X=0;
	//var CheckStr="ABCDEFGHJKLMNPQRSTUVWXYZIO";
	var CheckStr="ABCDEFGHJKLMNPQRSTUVXYWZIO";//Tender 修改
	var SaveArray=new Array();
	if (inparm1=='') 
	  {
	//	alert("身分證號碼欄位請勿空白");
		return false;
	  }
	//判斷身分證的長度
	if (inparm1.length != 10)
	  {
		return false;
	  } 
	//判斷身分證第一個字母是否為英文字母
	FirstEng=inparm1.substring(0,1).toUpperCase();
	if (FirstEng.charCodeAt()<65 || FirstEng.charCodeAt()>90) 
	  {
	//	alert("第一個字母要為英文字母");
		return false;
	  }
	if (isNumber(inparm1.substr(1,9)))
	  {
		for( var i=2;i<11;i++)
		{
			SaveArray[i]=inparm1.substr(i-1,1);
		}
	  }
	else 
	  {
	//	alert("除了開頭第一個字為英文字母外,其餘皆為數字");
		return false;
	  }	 
	Flag=CheckStr.indexOf(FirstEng)+10;
	Flag=Flag+inparm1;
	SaveArray[0]=Flag.substr(0,1);
	SaveArray[1]=Flag.substr(1,1);
	for(var j=1;j<10;j++){
		X=X+(SaveArray[j]*(10-j));
	  }
	if (((X+parseInt(SaveArray[0],10)+parseInt(SaveArray[10],10))%10)==0){
	//	alert("身分證號碼為正確!!");
		return true;
	   }
	else
	  {
	//	alert("身分證號碼為錯誤!!")
		return false;
	  }
}

/*
函數名稱:	getLogonErrorMsg( strMsg )
函數功能:	由傳入之訊息中,找出登錄畫面(Logon.jsp)傳回之錯誤訊息代號,將該代號轉為錯誤訊息
傳入參數:	strMsg			: 錯誤訊息兼代號
傳回值:		strReturnMsg	: 錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function getLogonErrorMsg( strMsg )
{
	var strReturnMsg = "";
	var iReturnStatus = 0;
	if( strMsg.indexOf("300") >= 0 )
	{//300:session是新設立
		strReturnMsg = "未登錄過,或登錄之連結已過時,請重新登錄本系統(300)";
		iReturnStatus = 300;
	}
	else if( strMsg.indexOf("301") >= 0 )
	{//301:siThisSessionInfo為null
		strReturnMsg = "NsSessionInfo為空白,請重新登錄本系統(301)";
		iReturnStatus = 301;
	}
	else if( strMsg.indexOf("302") >= 0 )
	{//302:uiThisUserInfo為null
		strReturnMsg = "NsUserInfo為空白,請重新登錄本系統(302)";
		iReturnStatus = 302;
	}
	else if( strMsg.indexOf("303") >= 0 )
	{//303:checkPassword() failed
		strReturnMsg = "未登錄OK,請重新登錄本系統(303)";
		iReturnStatus = 303;
	}
	else if( strMsg.indexOf("304") >= 0 )
	{//304:checkPrivilege() failed
		strReturnMsg = "無權限執行該程式(304)";
		iReturnStatus = 304;
	}
	else if( strMsg.indexOf("305") >= 0 )
	{//305:system shutted down failed
		strReturnMsg = "系統關閉中(305)";
		iReturnStatus = 305;
	}
	else
	{
		strReturnMsg = strMsg;
		iReturnStatus = 399;
	}
	return strReturnMsg;
}



/*
函數名稱:	showServerError( strHTML )
函數功能:	由傳入之訊息中,找出登錄畫面(Logon.jsp)傳回之錯誤訊息代號,將該代號轉為錯誤訊息
傳入參數:	strMsg			: 錯誤訊息兼代號
傳回值:		strReturnMsg	: 錯誤訊息
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function showServerError( strHTML )
{
	var iReturnStatus = 0;
	var oPopUp = window.createPopup();
	var strBody = strHTML;
	if( strHTML.indexOf("<BODY") >= 0 )
	{
		strBody = strHTML.substring( strHTML.indexOf("<BODY") , strHTML.indexOf("</BODY") );
		strBody = strBody.substring( strBody.indexOf(">")+1 , strBody.length );
		oPopUp.document.body.innerHTML =  strBody ;
	}
	if( oPopUp.document.getElementById("txtMsg") != null )
	{
		var strMsg = "";
		strMsg = oPopUp.document.getElementById("txtMsg").value;
		var strErrorMessage = getLogonErrorMsg( strMsg );
		alert( strErrorMessage );
		iReturnStatus = 1;
	}
	else
	{
		oPopUp.document.body.innerHTML =  strBody ;
		oPopUp.show( 50 , 50 , window.screen.width-100 , window.screen.height-100 , null );
	}
	return iReturnStatus;
}



/*
函數名稱:	getInsuredAge(strDOB,iDateType)
函數功能:	傳回投保年齡
傳入參數:	strDOB		: 生日
			iDateType	: 第一個參數個格式
						   iDataType 1 : 19970529 		CCYYMMDD 	西曆
						   iDataType 2 : 970529			YYMMDD		西曆
						   iDataType 3 : 29/05/1997		DD/MM/CCYY	西曆
						   iDataType 4 : 29/05/97		DD/MM/YY	西曆
						   iDataType 5 : 091/05/29		YYY/MM/DD	國曆
						   iDataType 6 : 90/05/29		YY/MM/DD	國曆
						   iDataType 7 : 0910529		YYYMMDD		國曆
						   iDataType 8 : 910529			YYMMDD		國曆
傳回值:		iInsuredAge	: 投保年齡
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function getInsuredAge(strDOB,iDateType) 
{
    var now = new Date();
    var today = new Date(now.getYear(),now.getMonth(),now.getDate());

    var yearNow = now.getYear();
    var monthNow = now.getMonth();
    var dateNow = now.getDate();
    var dateDOB = new Date();

    if (iDateType == 1)
        var dateDOB = new Date(strDOB.substring(0,4),
                            strDOB.substring(4,6)-1,
                            strDOB.substring(6,8));
    else if (iDateType == 2)
   	{
   		if( parseInt(strDOB.substring(0,2)) > 10 )
   		{
        	dateDOB = new Date((parseInt(strDOB.substring(0,2),10)+1900).valueOf(),
            	               strDOB.substring(2,4)-1,
                	           strDOB.substring(4,6));
        }
        else
        {
        	dateDOB = new Date((parseInt(strDOB.substring(0,2),10)+2000).valueOf(),
            	               strDOB.substring(2,4)-1,
                	           strDOB.substring(4,6));
        }
    }
    else if (iDateType == 3)
        dateDOB = new Date(strDOB.substring(6,10),
                            strDOB.substring(3,5)-1,
                            strDOB.substring(0,2));
    else if (iDateType == 4)
    {
   		if( parseInt(strDOB.substring(6,8)) > 10 )
   		{
	        dateDOB = new Date((parseInt(strDOB.substring(6,8),10)+1900).valueOf(),
    	                        strDOB.substring(3,5)-1,
        	                    strDOB.substring(0,2));
       	}
       	else
       	{
	        dateDOB = new Date((parseInt(strDOB.substring(6,8),10)+2000).valueOf(),
    	                        strDOB.substring(3,5)-1,
        	                    strDOB.substring(0,2));
       	}
    }
	else if ( iDateType == 5 )  //YYY/MM/DD
		dateDOB = new Date( (parseInt(strDOB.substring(0,3),10)+1911).valueOf(),
							strDOB.substring(4,6)-1,
							strDOB.substring(7,9) );
	else if ( iDateType == 6 )	//YY/MM/DD
		dateDOB = new Date( (parseInt(strDOB.substring(0,2),10)+1911).valueOf(),
							strDOB.substring(3,5)-1,
							strDOB.substring(6,8) );
	else if ( iDateType == 7 )	//YYYMMDD
		dateDOB = new Date( (parseInt(strDOB.substring(0,3),10)+1911).valueOf(),
							strDOB.substring(3,5)-1,
							strDOB.substring(5,7) );
	else if ( iDateType == 8 )	//YYMMDD
		dateDOB = new Date( (parseInt(strDOB.substring(0,2),10)+1911).valueOf(),
							strDOB.substring(2,4)-1,
							strDOB.substring(4,6) );
    else
        return -1;

    var yearDob = dateDOB.getFullYear();
    var monthDob = dateDOB.getMonth();
    var dateDob = dateDOB.getDate();

    yearAge = yearNow - yearDob;

    if (monthNow >= monthDob)
        var monthAge = monthNow - monthDob;
    else {
        yearAge--;
        var monthAge = 12 + monthNow -monthDob;
    }

    if (dateNow >= dateDob)
        var dateAge = dateNow - dateDob;
    else {
        monthAge--;
        var dateAge = 31 + dateNow - dateDob;

        if (monthAge < 0) {
            monthAge = 11;
            yearAge--; 
        }
    }

	// yearAge 	表示實際年齡
	// monthAge	表示超出實際年齡的月份
	// dateAge	表示超出實際年齡扣掉超出月份的日數

	if( monthAge > 6 )	//若超過六個月以上則投保年齡要加一歲
		yearAge++;
	else if( monthAge == 6 && dateAge > 0 )	//超過六個月零一天以上就要加一歲
		yearAge++;
	return yearAge;
}


/*
函數名稱:	getActualAge(strDOB,iDateType)
函數功能:	傳回年齡
傳入參數:	strDOB		: 生日
			iDateType	: 第一個參數個格式
						   iDataType 1 : 19970529 		CCYYMMDD 	西曆
						   iDataType 2 : 970529			YYMMDD		西曆
						   iDataType 3 : 29/05/1997		DD/MM/CCYY	西曆
						   iDataType 4 : 29/05/97		DD/MM/YY	西曆
						   iDataType 5 : 091/05/29		YYY/MM/DD	國曆
						   iDataType 6 : 90/05/29		YY/MM/DD	國曆
						   iDataType 7 : 0910529		YYYMMDD		國曆
						   iDataType 8 : 910529			YYMMDD		國曆
傳回值:		iActureAge	: 年齡
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function getActualAge(strDOB,iDateType) 
{
    var now = new Date();
    var today = new Date(now.getYear(),now.getMonth(),now.getDate());

    var yearNow = now.getYear();
    var monthNow = now.getMonth();
    var dateNow = now.getDate();
    var dateDOB = new Date();

    if (iDateType == 1)
        var dateDOB = new Date(strDOB.substring(0,4),
                            strDOB.substring(4,6)-1,
                            strDOB.substring(6,8));
    else if (iDateType == 2)
   	{
   		if( parseInt(strDOB.substring(0,2)) > 10 )
   		{
        	dateDOB = new Date((parseInt(strDOB.substring(0,2),10)+1900).valueOf(),
            	               strDOB.substring(2,4)-1,
                	           strDOB.substring(4,6));
        }
        else
        {
        	dateDOB = new Date((parseInt(strDOB.substring(0,2),10)+2000).valueOf(),
            	               strDOB.substring(2,4)-1,
                	           strDOB.substring(4,6));
        }
    }
    else if (iDateType == 3)
        dateDOB = new Date(strDOB.substring(6,10),
                            strDOB.substring(3,5)-1,
                            strDOB.substring(0,2));
    else if (iDateType == 4)
    {
   		if( parseInt(strDOB.substring(6,8)) > 10 )
   		{
	        dateDOB = new Date((parseInt(strDOB.substring(6,8),10)+1900).valueOf(),
    	                        strDOB.substring(3,5)-1,
        	                    strDOB.substring(0,2));
       	}
       	else
       	{
	        dateDOB = new Date((parseInt(strDOB.substring(6,8),10)+2000).valueOf(),
    	                        strDOB.substring(3,5)-1,
        	                    strDOB.substring(0,2));
       	}
    }
	else if ( iDateType == 5 )  //YYY/MM/DD
		dateDOB = new Date( (parseInt(strDOB.substring(0,3),10)+1911).valueOf(),
							strDOB.substring(4,6)-1,
							strDOB.substring(7,9) );
	else if ( iDateType == 6 )	//YY/MM/DD
		dateDOB = new Date( (parseInt(strDOB.substring(0,2),10)+1911).valueOf(),
							strDOB.substring(3,5)-1,
							strDOB.substring(6,8) );
	else if ( iDateType == 7 )	//YYYMMDD
		dateDOB = new Date( (parseInt(strDOB.substring(0,3),10)+1911).valueOf(),
							strDOB.substring(3,5)-1,
							strDOB.substring(5,7) );
	else if ( iDateType == 8 )	//YYMMDD
		dateDOB = new Date( (parseInt(strDOB.substring(0,2),10)+1911).valueOf(),
							strDOB.substring(2,4)-1,
							strDOB.substring(4,6) );
    else
        return -1;

    var yearDob = dateDOB.getFullYear();
    var monthDob = dateDOB.getMonth();
    var dateDob = dateDOB.getDate();

    yearAge = yearNow - yearDob;

    if (monthNow >= monthDob)
        var monthAge = monthNow - monthDob;
    else {
        yearAge--;
        var monthAge = 12 + monthNow -monthDob;
    }

    if (dateNow >= dateDob)
        var dateAge = dateNow - dateDob;
    else {
        monthAge--;
        var dateAge = 31 + dateNow - dateDob;

        if (monthAge < 0) {
            monthAge = 11;
            yearAge--; 
        }
    }

	// yearAge 	表示實際年齡
	// monthAge	表示超出實際年齡的月份
	// dateAge	表示超出實際年齡扣掉超出月份的日數

	return yearAge;
}


/*
函數名稱:	getServerInformation()
函數功能:	自Server端取得session或application之資料
傳入參數:	strObjectName		: Server端物件名稱, 'session' 或 'application'
			strAttributeName	: Server物件中之屬性名稱, 若本欄空白時,則將Server物件中所有屬性均下載
傳回值:		xmlDom				: Server物件之屬性值,例如: <?xml version=\"1.0\"?> <XML><ObjectName>session</ObjectName><AttributeName></AttributeName><txtMsg></txtMsg><session><PasswordAging>2</PasswordAging><PasswordAgingMsg>nsoasis 的密碼還剩 5 天就要到期,是否要更改密碼?</PasswordAgingMsg></session></XML>

修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function getServerInformation( strObjectName , strAttributeName )
{
	var strUrl = '../ServerInformation/getServerInformation.jsp';
	var objTable = document.createElement("TABLE");
	var objDiv = document.createElement("DIV");
	var xmldomData = new ActiveXObject("Microsoft.XMLDOM");
	var xmldomResponseData = new ActiveXObject("Microsoft.XMLDOM");
	var oRootNode = xmldomData.createElement("XML");

	var strStatus = window.status;
	window.status = "至 Server 查詢資料中,請稍候....";
	xmldomData.appendChild( oRootNode );
	//將 ObjectName, AttributeName, txtMsg先存入 XMLDOM 物件中
	var oTmpNode = xmldomData.createElement("ObjectName");
	oTmpNode.text = strObjectName;
	oRootNode.appendChild( oTmpNode );
	var oTmpNode = xmldomData.createElement("AttributeName");
	oTmpNode.text = strAttributeName;
	oRootNode.appendChild( oTmpNode );
	oTmpNode = xmldomData.createElement("txtMsg");
	oTmpNode.text = "";
	oRootNode.appendChild( oTmpNode );

	var xmlHttp = new ActiveXObject( "msxml2.XMLHTTP" );
	//設定 Server 端程式, 第一個參數為 POST 表示使用 POST 呼叫 Server , 第二個參數為 Server 端程式名稱, 如果 menu 是使用 Cache 時,須使用 full path , 否則會找不到程式
	// 第三個參數是表示是否使用非同步呼叫,若使用 false 時,則在下面使用 send() 呼叫時會等 Server 會應完成後才繼續進行
	xmlHttp.open('POST',strUrl, false );	

	xmlHttp.setRequestHeader("Content-type","text/xml");
	
	//呼叫 Server 端程式, 並等待回應
	xmlHttp.send( xmldomData );

//	alert( xmlHttp.responseText );
//	document.getElementById("txtShow").outerHTML = xmlHttp.responseText;

	// xmlHttp.status 表示 Server 回應碼, 為一般之 HTTP 回應碼, 小於 300 表示正常, 通常是 200 
	if( xmlHttp.status < 300 )
	{	// Server 端程式正常結束
		// xmlhttp.responseText 中存放著 Server 端回應之 XML 資料, 使用 loadXML() 將該資料載入 XMLDOM 物件中
		if( xmlHttp.responseText.indexOf("HTML") >= 0 )
		{
			if( showServerError( xmlHttp.responseText ) > 0 )
			{
				top.open( "../Logon/Logon.jsp","_self" );
				xmldomResponseData = null;
			}
		}
		else
		{
			xmldomResponseData.loadXML( xmlHttp.responseText );
			// 若 txtMsg 不為空白(一般都不為空白), 則先顯示訊息
			if( xmldomResponseData.getElementsByTagName("txtMsg").length != 0 )
			{
				if( xmldomResponseData.getElementsByTagName("txtMsg").item(0).text != "" )
				{
					alert(xmldomResponseData.getElementsByTagName("txtMsg").item(0).text );
				}
				if( xmldomResponseData.getElementsByTagName("txtMsgNo").length != 0 )
				{
					var iMsgNo = parseInt(xmldomResponseData.getElementsByTagName("txtMsgNo").item(0).text,10);
					if( iMsgNo == 300 || 
						iMsgNo == 301 ||
						iMsgNo == 302 ||
						iMsgNo == 303 ||
						iMsgNo == 304 ||
						iMsgNo == 305 	)
					{
						xmldomResponseData = null;
						top.open( "../Logon/Logon.jsp","_self" );
					}
				}
			}	
			else
			{
				oRootNode = xmldomResponseData.createElement("XML");
				oTmpNode = xmldomResponseData.createElement("txtMsg");
				oTmpNode.text = "Server Error Status = "+xmlHttp.status + " :"+xmlHttp.statusText+"\r\n"+xmlHttp.responseText;
				oRootNode.appendChild( oTmpNode );
				oTmpNode = xmldomResponseData.createElement("txtRowCount");
				oTmpNode.text = "0";
				oRootNode.appendChild( oTmpNode );
				xmldomResponseData.appendChild( oRootNode );
			}
		}
	}
	else
	{	// xmlHttp.responseText 中存放著 Server 端傳回之錯誤畫面, 使用 alert() 並不十分恰當, 以後可再改善
		showServerError( xmlHttp.responseText );
		oRootNode = xmldomResponseData.createElement("XML");
		oTmpNode = xmldomResponseData.createElement("txtMsg");
		oTmpNode.text = "Server Error Status = "+xmlHttp.status + " :"+xmlHttp.statusText+"\r\n"+xmlHttp.responseText;
		oRootNode.appendChild( oTmpNode );
		xmldomResponseData.appendChild( oRootNode );
	}
	window.status = strStatus;
	return xmldomResponseData;
}


function pause(numberMillis) {
        var dialogScript = 
           'window.setTimeout(' +
           ' function () { window.close(); }, ' + numberMillis + ');';
        var result = window.showModalDialog('javascript:document.writeln(' +
            '"<script>' + dialogScript + '<' + '/script>")');
/* For NN6, but it requires a trusted script.
         openDialog(
           'javascript:document.writeln(' +
            '"<script>' + dialogScript + '<' + '/script>"',
           'pauseDialog', 'modal=1,width=10,height=10');
 */

}

function string2Array(inputString, delimiter){
	if(inputString==null){
		return ;
	}
	if(delimiter==null){
		delemeter = ",";
	}
	
	// check array size
	//debugger ;
	var arraySize = 1 ;
	var i=inputString.indexOf(delimiter);
	var j=i+1;
	while(i!=-1){
		arraySize++;
		i = inputString.indexOf(delimiter,j) ;
		j=i+1 ;
	}
	
	var returnArray = new Array(arraySize);
	var beginIndex = 0;
	var endIndex = 0 ;
	for(i=0; i<arraySize-1 ; i++){
		endIndex = inputString.indexOf(delimiter,beginIndex) ;
		returnArray[i] = inputString.substring(beginIndex,endIndex);
		beginIndex = endIndex+1 ;
	}
	returnArray[i] = inputString.substring(beginIndex,inputString.length) ;
	
	return returnArray ;
		
}

/*
函數名稱:	string2RocDate()
函數功能:	轉換 日期字串至民國年的格式(YYY/MM/DD)
傳入參數:	strDate	    : 欲轉換的字串
			type	    : 輸入字串的格式 "W:西元年, C:民國年"
傳回值:		RocString	: 輸換後的民國年字串

修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function string2RocDate(strDate, type){
	//debugger;
	var returnString = null;
	
	// check parameter
	if(strDate == null){
		return "";
	}else{
		strDate = alltrim(strDate);
	}
	
	if(type == null){
		type = "C";
	}
	
	var dateLength  = strDate.length ;
	var yy = "0";
	var mm = "00";
	var dd = "00";
	
	if(dateLength >= 5){
		dd = strDate.substring(dateLength - 2, dateLength) ;
		mm = strDate.substring(dateLength - 4, dateLength - 2);
		yy = strDate.substring(0, dateLength - 4);
	}		

	if(type.toUpperCase()=="W"){
		yy = parseInt(yy,10)-1911 ;
	}
	
	yy = padLeadingZero(yy,3);
	
	returnString = yy+"/"+mm+"/"+dd ;
	
	return returnString ;	
}

/*
函數名稱:	rocDate2String()
函數功能:	轉換 民國年格式(YYY/MM/DD)的字串，至西元年或民國年字串
傳入參數:	strDate	      : 欲轉換的字串
			type		  : 輸出字串的型態 (W:西元年,C:民國年）
傳回值:		returnString  : 轉換後的輸出字串

修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function rocDate2String(strRocDate, type){
	// 檢查參數
	if(strRocDate.length!=9){
		return "";
	}
	if(type==null){
		type = "C";
	}
	var yy = strRocDate.substring(0,3);
	var mm = strRocDate.substring(4,6);
	var dd = strRocDate.substring(7,9);
	
	if(type=="C"){
		yy = parseInt(yy,10);
		if(yy < 10) {
			yy = "00" + yy + "";
		} else if(yy < 100) {
			yy = "0" + yy + "";
		} else {
			yy = yy + "";
		}
	}  //R80338
	else if(type=="3"){   //R80338
	    yy = parseInt(yy,10)+111 + "";	//R80338
	}else{
		yy = parseInt(yy,10)+1911 + "";
	}
	return yy+mm+dd ;
}

function updateFunctionString( strGrantedFunction,strThisFunction )
{
	var strReturn;
	var aCheckFunctionCode = new Array("A","U","D","I","P");
	var aThisFunction = stringToArray(strThisFunction,",");
	var aReturn = new Array();
	var iReturnArrayMax = 0;
	var aGrantedFunction = stringToArray( strGrantedFunction,"," );
	for(i=0;i<aThisFunction.length;i++)
	{
		var bFound = false;
		// check 是否要檢查(是否為A,U,D,I,P)
		for(j=0;j<aCheckFunctionCode.length;j++)
		{
			if( aThisFunction[i] == aCheckFunctionCode[j] )
			{
				bFound = true;
				break;
			}
		}
		if( bFound )	//要檢查
		{
			//檢查該項子功能是否被授權
			for(j=0;j<aGrantedFunction.length;j++)
			{
				if( aThisFunction[i] == aGrantedFunction[j] )
				{	//被授權之子功能,將他加入傳回子功能陣列
					aReturn[iReturnArrayMax++] = aThisFunction[i];
					break;
				}
			}
		}
		else
		{	//該項button不是授權項目,直接加入傳回之子功能陣列
			aReturn[iReturnArrayMax++] = aThisFunction[i];
		}
	}
	//將被授權之子功能陣列轉為字串型態傳回
	strReturn = arrayToString( aReturn , "," );
	return strReturn;
}

function stringToArray( strThisFunction, strDelemiter )
{
	var aReturn = new Array();
	var iCurrPos = 0,iArrayMax=0;
	while( strThisFunction.length != 0 )
	{
		iCurrPos = strThisFunction.indexOf(strDelemiter);
		if( iCurrPos != -1 )
		{
			aReturn[iArrayMax++] = strThisFunction.substring(0,iCurrPos++);
			strThisFunction = strThisFunction.substring(iCurrPos,strThisFunction.length);
		}
		else
		{
			aReturn[iArrayMax++] = strThisFunction.substring(0,strThisFunction.length);
			strThisFunction = "";
		}
	}
	return aReturn;
}

function arrayToString( aThisFunction, strDelemiter )
{
	var strReturn = "";
	for(i=0;i<aThisFunction.length;i++)
	{
		if( strReturn == "" )
		{
			strReturn += aThisFunction[i];
		}
		else
		{
			strReturn = strReturn+strDelemiter+aThisFunction[i];
		}
	}
	return strReturn;
}