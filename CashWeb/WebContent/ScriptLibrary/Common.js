/*	�{���w�W��:	NSCommon.js
	�̫�ק���:89/01/10
	���:
		��ƦW��					�g�@���			�D�n�\��
	===============================	======== =====================================
	1. ltrim(strInput)				89/01/10:�Ǧ^strInput�r�ꥪ��ťէR���ᤧ�r��
	2. rtrim(strInput)				99/01/10:�Ǧ^strInput�r��k��ťէR���ᤧ�r��
	3. NumFormat(nInput,strPatten)	89/01/10:�Ǧ^�ƦrnInput��strPatten�榡�Ƥ��r��
*/

var strActiveTab = "";									//�ثeActive�������W��	
var strStandardMenuColor = "blue";						//����(tab page)tag�W��r���C��
var strStandardMenuBackgroundColor = "lightyellow";		//����(tab page)tag����



/*
	��ƦW��: ltrim(strInput)
	�D�n�\��: �N�ǤJ�r�ꥪ��ťեh����Ǧ^
	��J�Ѽ�: string	strInput : �n�R������ťդ��r��
	�Ǧ^��  : string			 : �R������ťիᤧ�r��
	�g�@���: 89/01/10
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
	��ƦW��: rtrim(strInput)
	�D�n�\��: �N�ǤJ�r��k��ťեh����Ǧ^
	��J�Ѽ�: string	strInput : �n�R���k��ťդ��r��
	�Ǧ^��  : string			 : �R���k��ťիᤧ�r��
	�g�@���: 89/01/10
	�ק�O��:
				�ק��		�ק���			�ק�K�n

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
��ƦW��:	alltrim(strInput)
��ƥ\��:	�N�ǤJ�r�ꥪ�k��ťեh����Ǧ^
�ǤJ�Ѽ�:	string	strInput : �n�R�����k��ťդ��r��
�Ǧ^��:		string			 : �R�����k��ťիᤧ�r��
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function alltrim(strInput)
{
	return ltrim(rtrim(strInput)) ;
}




/*
��ƦW��:	checkTitleWindowState(strTitle,strProgId)
��ƥ\��:	�ˬdtitle frame�������O�_ready,�btitle frame ready��,��ܵ{���W��
�ǤJ�Ѽ�:	string	strTitle : �n��ܩ�title�������{���W��
			string  strProgId: �{���N��
�Ǧ^��:		�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	checkToolBarWindowState(strThisFunctionKey)
��ƥ\��:	�ˬdtoolbar frame�������O�_ready,�btoolbar frame ready��,enable�ǤJ�����s
�ǤJ�Ѽ�:	string	strThisFunctionKey : �nenable���\����r��
�Ǧ^��:		�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	checkTopWindowState(strThisFunctionKey)
��ƥ\��:	�ˬdtoolbar frame�������O�_ready,�btoolbar frame ready��,enable�ǤJ�����s,���d�� dialog box �M��
�ǤJ�Ѽ�:	string	strThisFunctionKey : �nenable���\����r��
�Ǧ^��:		�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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




//toolbar frame ���n��ܪ��\����,�|���ӱƦC���ǥX�{
//A:�s�W,U:�ק�,D:�R��,I:�d��,B:�s�W�Ӷ�,F:�R���Ӷ�E:���},R:�M��
/*              A:�s�W
				U:�ק�
				D:�R��
				I:�d��
				E:���}
				R:�M��
				P:�C�L
				B:�s�W����
				C:�ק����
				F:�R������
				G:�d�ߩ���
				H:�T�w
				J:�W�@��
				K:�U�@��
				S:�x�s
				L:����Report
*/
//toolbar frame ���n��ܪ��\����,�|���ӱƦC���ǥX�{
//��ƦW��:	OnLoad( String strTitle, String strProgId, strThisFunctionKey )
//��ƥ\��:	��Client�ݵe���Ұʮ�,���楻���.
//		1.���btitle frame��ܵ{���N���ε{���W��,�{���N���ε{���W�٭n�b<BODY>tag���ק�
//		2.�YtxtClientMsg��줣���ťծ�, ��ܦ����~�T��,�ϥ�alert()��ܥ�
//		3.�btoolbar frame��ܥ\����
//�ǤJ�Ѽ�:	String strTitle: �{���W��,�m��title frame������,�o���ܼƬO�ϥΥ�������
//					document.title,���ק糧jsp��<TITLE>tag
//		String strProgId:	�{���N��,�m��title frame������.�ܼƨӷ���jsp��strThisProgId.
//		String strThisFunctionKey: �n��ܪ��\����N��,A:�s�W,U:�ק�,D:�R��,I:�d��,E:���},R:�M��
//		String strFirstField: ��J���Ĥ@�����
//�Ǧ^��:	�L
//�ק����:	�ק���	�ק��	��   ��   �K   �n
//		---------	----------	-----------------------------------------

var oToolBar = "";
var oTitle = "";
var iToolBar = 0;
var iTitle = 0;
var iInterval = "";
var winTitle = "";
var winToolBar = "";


/*
��ƦW��:	WindowOnLoadCommon(strTitle,strProgId,strThisFunctionKey,strFirstField)
��ƥ\��:	�U�{��Window OnLoad��,���楻���,����title frame�Mtoolbar frame�O�_ready,�Yready�h��ܵ{���W�٤Υ\������s
�ǤJ�Ѽ�:	string	strTitle : �n��ܩ�title�������{���W��
			string  strProgId: �{���N��
			string	strThisFunctionKey : �nenable���\����r��
�Ǧ^��:		�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	printDirect()
��ƥ\��:	�C�L����
�ǤJ�Ѽ�:	�L
�Ǧ^��:		�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	padLeadingZero(strInput,iOutLength)
��ƥ\��:	�N�ǤJ���r�ꥪ��[0�ܻݭn�����׫�Ǧ^
�ǤJ�Ѽ�:	String strInput		: �ݳB�z���r��
			int iOutLength		: �Ǧ^�r�ꤧ����
�Ǧ^��:		String				: �B�z�ᤧ�s�r��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	isNumber( strInput )
��ƥ\��:	�ˬd�r��O�_���ƭ�
�ǤJ�Ѽ�:	String strInput		: ���ˬd���r��
�Ǧ^��:		true				: ��J�r������Ʀr , false : ��J���r�ꤣ���O�Ʀr
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	checkLength(objThisInputText)
��ƥ\��:	�ˮֿ�J���O�_�W�L�������,To check whether the acture length is excessed the max length of this input field.
			The chinese character(in unicode form) is counted as two bytes of length.
�ǤJ�Ѽ�:	objThisInputText : ���󫬺A�����
�Ǧ^��:		true:acture length is not excess the max limited.
			false:acture length is excess the max length.
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	checkLength1(objThisInputText , numMaxLen)
��ƥ\��:	�ˮֿ�J���O�_�W�L�������,To check whether the acture length is excessed the max length of this input field.
			The chinese character(in unicode form) is counted as two bytes of length.
�ǤJ�Ѽ�:	objThisInputText : ���󫬺A�����
            numMaxLen        : �̤j����
�Ǧ^��:		true:acture length is not excess the max limited.
			false:acture length is excess the max length.
�ק����:	�ק���	�ק��	��   ��   �K   �n
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

// �|�~�ˮ�
//     Parm :   n ==> YYY or "YYY" (����~) or YYYY or "YYYY"(�褸�~)
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
// Q80145 �|�~�P�_�ץ�
       else
          {  
          return true;
          }
     }
            
  return false;            
}

// ����ˮ�
//    Parm1   : strDate(YYYMMDD or YYMMDD)--> ����~  
//              strDate(YYYYMMDD)         --> �褸�~
//    Return : Boolean

/**
��ƦW��:	checkDate(strDate)
��ƥ\��:	����ˮ�
�ǤJ�Ѽ�:	strDate			: ���ˮ֤�����r��,�榡��:YYYMMDD(���), YYMMDD(���) , YYYYMMDD(���)
�Ǧ^��:		true			: �X�椧����r��
			false			: ���X�椧����r��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	checkDate(strDate)
��ƥ\��:	����ˮ�
�ǤJ�Ѽ�:	strDate			: ���ˮ֤�����r��,�榡��:YYYMMDD(���), YYMMDD(���) , YYYYMMDD(���)
�Ǧ^��:		true			: �X�椧����r��
			false			: ���X�椧����r��

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
		// �褸�~�榡
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
	��ƦW��: toWestenDateString(strInput)
	�D�n�\��: �N������ର�����
	��J�Ѽ�: string	strROCDate	: ����� YYYMMDD or YYY/MM/DD
	�Ǧ^��  : string				: ����� YYYY/MM/DD
	�g�@���: 91/03/18
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
	��ƦW��: NumFormat(nInput,strPatten)
	�D�n�\��: �N�ǤJ���Ʀr���ӳ]�w���˪O���H�榡��
	��J�Ѽ�: numeric	nInput	 : ��J���Ʀr
			  string	strPatten: �榡���˪O
									�榡�r��		����
									=============	===============================================
									9				�@��Ʀr,��ӼƦr���s�ɷ|��X0
									Z				�@��Ʀr,��ӼƦr���s�ɤ��|��X(suppress leading zero)
									$				�@��Ʀr,�PZ�ۦP,�̥���|�[�@$,
									.				�p���I
									,				�d����渹
									-				�@��Ʀr,�PZ�ۦP,����|�[�t��
									+				�@��Ʀr,�PZ�ۦP,����|�[����
									
	�Ǧ^��  : string			 : �榡�Ƥ��r��
	�g�@���: 89/01/10
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
	��ƦW��: getSqlDate(dteDate)
	�D�n�\��: �N��������ର��Ʈw�i�H�������榡
	��J�Ѽ�: string	dteDate	: ������� 
	�Ǧ^��  : string			: YYYY/MM/DD
	�g�@���: 91/03/23
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
	��ƦW��: getSqlDateTime(dteDate)
	�D�n�\��: �N��������ର��Ʈw�i�H�������榡
	��J�Ѽ�: string	dteDate	: ������� 
	�Ǧ^��  : string			: YYYY/MM/DD HH:MM:SS
	�g�@���: 91/03/23
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
	��ƦW��: getROCDateTime( iType , dteDate )
	�D�n�\��: �N����ର���
	��J�Ѽ�: Date	dteDate		: ������� 
	�Ǧ^��  : string			: 
						output format : iType = 0 : YYY/MM/DD
										iType = 1 : YYY/MM/DD HH:MM:SS
										iType = 2 : YYYMMDD
										iType = 3 : YYYMMDDHHMMSS
										iType = 4 : YY/MM/DD
										iType = 5 : YY/MM/DD HH:MM:SS
										iType = 6 : YYMMDD
										iType = 7 : YYMMDD HHMMSS
	�g�@���: 91/03/23
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
	��ƦW��: rocString2Date( iType , strDate )
	�D�n�\��: �N���r���ର���
	��J�Ѽ�: String	strDate		: ������� 
						output format : iType = 0 : YYY/MM/DD
										iType = 1 : YYY/MM/DD HH:MM:SS
										iType = 2 : YYYMMDD
										iType = 3 : YYYMMDDHHMMSS
										iType = 4 : YY/MM/DD
										iType = 5 : YY/MM/DD HH:MM:SS
										iType = 6 : YYMMDD
										iType = 7 : YYMMDD HHMMSS

	�Ǧ^��  : Date			: 
	�g�@���: 92/09/18
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
	��ƦW��: westernString2Date( iType , strDate )
	�D�n�\��: �N���r���ର�����
	��J�Ѽ�: String	strDate		: ������� 
						output format : iType = 0 : YYYY/MM/DD �� YYYY-MM-DD
										iType = 1 : YYYY/MM/DD HH:MM:SS �� YYYY-MM-DD HH:MM:SS
										iType = 2 : YYYYMMDD
										iType = 3 : YYYYMMDDHHMMSS

	�Ǧ^��  : Date			: 
	�g�@���: 92/09/18
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
		Response.Redirect(strUrl+"?Error=checkLogon():�{���N�����i�ť�");
	}
	if( Session("UserId") == null )
	{
		Response.Redirect(strUrl+"?Error=checkLogon():�ϥΪ̥N�����ť�,�i�ఱ�d�ɶ��L��,�W�L"+Session.Timeout+"����������,�Э��s�n��");
	}
	if( Session("PasswordStatus") == "1" )	//�ϥΪ̱K�X�w�L��
	{
		Response.Redirect(strChangePasswordUrl+"ReturnUrl=MainFrameSet.asp&Action=1");
	}
	if( Session("uiThisUserInfo") == null )
	{
		Response.Redirect( strUrl+"?Error=checkLogon():�ϥΪ̸�T���󬰪ť�,�Х��n���t��");
	}
	var uiThisUserInfo = Session("uiThisUserInfo");
	if( !uiThisUserInfo.checkPrivilege(strProgram) )
	{
		Response.Redirect( strUrl+"?Error=checkLogon():�ϥΪ̵L�v�����楻�\��");
	}
	
}


/**
	��ƦW��: executeSql(strSql)
	�D�n�\��: ��Client�ݦ�Server����ǤJ��SQL Statement
	��    ��: ����SQL Statement ��,Server �Ǧ^���浲�G���|��b XMLDOM ����,�I�s���{���n�ۦ��ˬd�O�_���\,
			�̥��ˬd txtMsg ���,�Y����줣���ť�,��ܦ����~�o��
			�A�ˬd txtRowCount, �O�@�ӼƦr,������ܶǤJ�� SQL Statement ������`�@Ū���h�� rows
			�Y�O txtRowCount > 1 , ��ܦ��h����ƳQ�Ǧ^, �Y�nŪ����� row , �i�H���o ExecuteSqlXMLRowN , 
			�䤤�̫�@�Ӧr���� N ��ܲĴX���O��, �Ҧp:�Ĥ@���O���� ExecuteSqlXMLRow1 , �ĤG���O���� ExecuteSqlXMLRow2 ,
			�аѦҤU�����ϥνd��
	��J�Ѽ�: String strSql	: �ݰ��椧 SQL Statement 
	�Ǧ^��  : Microsoft.XMLDOM ����			: 
	�g�@���: 91/09/25
	�ק�O��:
				�ק��		�ק���			�ק�K�n
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
					strTmpMsg = "�ϥΪ̥N�� '"+objThisItem.value+"' ��s��t�Τ�,�Э��s��J";
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
	window.status = "�� Server �d�߸�Ƥ�,�еy��....";
	xmldomData.appendChild( oRootNode );
	//�Nsql,txtMsg���s�J XMLDOM ����
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
	//�]�w Server �ݵ{��, �Ĥ@�ӰѼƬ� POST ��ܨϥ� POST �I�s Server , �ĤG�ӰѼƬ� Server �ݵ{���W��, �p�G menu �O�ϥ� Cache ��,���ϥ� full path , �_�h�|�䤣��{��
	// �ĤT�ӰѼƬO��ܬO�_�ϥΫD�P�B�I�s,�Y�ϥ� false ��,�h�b�U���ϥ� send() �I�s�ɷ|�� Server �|��������~�~��i��
	xmlHttp.open('POST',strUrl, false );	

	xmlHttp.setRequestHeader("Content-type","text/xml");
	
	//�I�s Server �ݵ{��, �õ��ݦ^��
	xmlHttp.send( xmldomData );

//	alert( xmlHttp.responseText );
//	document.getElementById("txtShow").outerHTML = xmlHttp.responseText;

	// xmlHttp.status ��� Server �^���X, ���@�뤧 HTTP �^���X, �p�� 300 ��ܥ��`, �q�`�O 200 
	if( xmlHttp.status < 300 )
	{	// Server �ݵ{�����`����
		// xmlhttp.responseText ���s��� Server �ݦ^���� XML ���, �ϥ� loadXML() �N�Ӹ�Ƹ��J XMLDOM ����
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
			// �Y txtMsg �����ť�(�@�볣�����ť�), �h����ܰT��
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
	{	// xmlHttp.responseText ���s��� Server �ݶǦ^�����~�e��, �ϥ� alert() �ä��Q�����, �H��i�A�ﵽ
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
��ƦW��:	switchTab(strTabName,strMenuName)
��ƥ\��:	�󴫥ثeActive����,�P�ɧ�menu���ؤ��ϥդΤ��e��������
�ǤJ�Ѽ�:	strTabName 	: �U�b�����e����������id
			strMenuName	: �W�b��menu����������id
�Ǧ^��:		�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function switchTab(strTabName,strMenuName)
{
	//�Y�ӭ����w�OActive�h�ߨ��^
	if( strTabName == strActiveTab )
		return;
	var objDiv = document.getElementById( strTabName );
	if( objDiv == null )
	{
		alert( strTabName+" is not in the document");
		return;
	}
	//���o������DIV
	var objAllDiv = document.getElementsByTagName("DIV");
	if( objAllDiv != null )
	{
		for( i=0;i<objAllDiv.length;i++)
		{
			//�u�B�zclass��tab_panel(�U�b��)��MenuClass(�W�b��)��DIV
			if( objAllDiv.item(i).className != "tab_panel" && objAllDiv.item(i).className != 'MenuClass' )
				continue;
			//tab_panel�U�b�����e����
			if(  objAllDiv.item(i).className == 'tab_panel' )
			{
				//���F�N�Ndisplay�ݩʳ]��block,�_�h���]��none
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
			//MenuClass�W�b��Menu�W��
				//�NActive�����ϥ�(�ϥΤ�Fore Ground Color �� strStandardMenuBackgroundColor, Back Ground Color �� strStandardMenuColor),��l�אּ���`
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
	//���s�p��C�@��menu���e��
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
��ƦW��:	validId()
��ƥ\��:	�����Ҹ��X�ˮ�
�ǤJ�Ѽ�:	inparm1 : �����Ҹ��X  (String-X10) 
�Ǧ^��:	        true(bol)  : Ok
�Ǧ^��:	        false(bol) : Fail
Author:         Tender
CreatedDate :   90/08/14
 		91/09/19
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function validId(inparm1) 
{
	var FirstEng,FirstNumber,Flag,X=0;
	//var CheckStr="ABCDEFGHJKLMNPQRSTUVWXYZIO";
	var CheckStr="ABCDEFGHJKLMNPQRSTUVXYWZIO";//Tender �ק�
	var SaveArray=new Array();
	if (inparm1=='') 
	  {
	//	alert("�����Ҹ��X���ФŪť�");
		return false;
	  }
	//�P�_�����Ҫ�����
	if (inparm1.length != 10)
	  {
		return false;
	  } 
	//�P�_�����ҲĤ@�Ӧr���O�_���^��r��
	FirstEng=inparm1.substring(0,1).toUpperCase();
	if (FirstEng.charCodeAt()<65 || FirstEng.charCodeAt()>90) 
	  {
	//	alert("�Ĥ@�Ӧr���n���^��r��");
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
	//	alert("���F�}�Y�Ĥ@�Ӧr���^��r���~,��l�Ҭ��Ʀr");
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
	//	alert("�����Ҹ��X�����T!!");
		return true;
	   }
	else
	  {
	//	alert("�����Ҹ��X�����~!!")
		return false;
	  }
}

/*
��ƦW��:	getLogonErrorMsg( strMsg )
��ƥ\��:	�ѶǤJ���T����,��X�n���e��(Logon.jsp)�Ǧ^�����~�T���N��,�N�ӥN���ର���~�T��
�ǤJ�Ѽ�:	strMsg			: ���~�T���ݥN��
�Ǧ^��:		strReturnMsg	: ���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function getLogonErrorMsg( strMsg )
{
	var strReturnMsg = "";
	var iReturnStatus = 0;
	if( strMsg.indexOf("300") >= 0 )
	{//300:session�O�s�]��
		strReturnMsg = "���n���L,�εn�����s���w�L��,�Э��s�n�����t��(300)";
		iReturnStatus = 300;
	}
	else if( strMsg.indexOf("301") >= 0 )
	{//301:siThisSessionInfo��null
		strReturnMsg = "NsSessionInfo���ť�,�Э��s�n�����t��(301)";
		iReturnStatus = 301;
	}
	else if( strMsg.indexOf("302") >= 0 )
	{//302:uiThisUserInfo��null
		strReturnMsg = "NsUserInfo���ť�,�Э��s�n�����t��(302)";
		iReturnStatus = 302;
	}
	else if( strMsg.indexOf("303") >= 0 )
	{//303:checkPassword() failed
		strReturnMsg = "���n��OK,�Э��s�n�����t��(303)";
		iReturnStatus = 303;
	}
	else if( strMsg.indexOf("304") >= 0 )
	{//304:checkPrivilege() failed
		strReturnMsg = "�L�v������ӵ{��(304)";
		iReturnStatus = 304;
	}
	else if( strMsg.indexOf("305") >= 0 )
	{//305:system shutted down failed
		strReturnMsg = "�t��������(305)";
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
��ƦW��:	showServerError( strHTML )
��ƥ\��:	�ѶǤJ���T����,��X�n���e��(Logon.jsp)�Ǧ^�����~�T���N��,�N�ӥN���ର���~�T��
�ǤJ�Ѽ�:	strMsg			: ���~�T���ݥN��
�Ǧ^��:		strReturnMsg	: ���~�T��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	getInsuredAge(strDOB,iDateType)
��ƥ\��:	�Ǧ^��O�~��
�ǤJ�Ѽ�:	strDOB		: �ͤ�
			iDateType	: �Ĥ@�ӰѼƭӮ榡
						   iDataType 1 : 19970529 		CCYYMMDD 	���
						   iDataType 2 : 970529			YYMMDD		���
						   iDataType 3 : 29/05/1997		DD/MM/CCYY	���
						   iDataType 4 : 29/05/97		DD/MM/YY	���
						   iDataType 5 : 091/05/29		YYY/MM/DD	���
						   iDataType 6 : 90/05/29		YY/MM/DD	���
						   iDataType 7 : 0910529		YYYMMDD		���
						   iDataType 8 : 910529			YYMMDD		���
�Ǧ^��:		iInsuredAge	: ��O�~��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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

	// yearAge 	��ܹ�ڦ~��
	// monthAge	��ܶW�X��ڦ~�֪����
	// dateAge	��ܶW�X��ڦ~�֦����W�X��������

	if( monthAge > 6 )	//�Y�W�L���Ӥ�H�W�h��O�~�֭n�[�@��
		yearAge++;
	else if( monthAge == 6 && dateAge > 0 )	//�W�L���Ӥ�s�@�ѥH�W�N�n�[�@��
		yearAge++;
	return yearAge;
}


/*
��ƦW��:	getActualAge(strDOB,iDateType)
��ƥ\��:	�Ǧ^�~��
�ǤJ�Ѽ�:	strDOB		: �ͤ�
			iDateType	: �Ĥ@�ӰѼƭӮ榡
						   iDataType 1 : 19970529 		CCYYMMDD 	���
						   iDataType 2 : 970529			YYMMDD		���
						   iDataType 3 : 29/05/1997		DD/MM/CCYY	���
						   iDataType 4 : 29/05/97		DD/MM/YY	���
						   iDataType 5 : 091/05/29		YYY/MM/DD	���
						   iDataType 6 : 90/05/29		YY/MM/DD	���
						   iDataType 7 : 0910529		YYYMMDD		���
						   iDataType 8 : 910529			YYMMDD		���
�Ǧ^��:		iActureAge	: �~��
�ק����:	�ק���	�ק��	��   ��   �K   �n
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

	// yearAge 	��ܹ�ڦ~��
	// monthAge	��ܶW�X��ڦ~�֪����
	// dateAge	��ܶW�X��ڦ~�֦����W�X��������

	return yearAge;
}


/*
��ƦW��:	getServerInformation()
��ƥ\��:	��Server�ݨ��osession��application�����
�ǤJ�Ѽ�:	strObjectName		: Server�ݪ���W��, 'session' �� 'application'
			strAttributeName	: Server���󤤤��ݩʦW��, �Y����ťծ�,�h�NServer���󤤩Ҧ��ݩʧ��U��
�Ǧ^��:		xmlDom				: Server�����ݩʭ�,�Ҧp: <?xml version=\"1.0\"?> <XML><ObjectName>session</ObjectName><AttributeName></AttributeName><txtMsg></txtMsg><session><PasswordAging>2</PasswordAging><PasswordAgingMsg>nsoasis ���K�X�ٳ� 5 �ѴN�n���,�O�_�n���K�X?</PasswordAgingMsg></session></XML>

�ק����:	�ק���	�ק��	��   ��   �K   �n
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
	window.status = "�� Server �d�߸�Ƥ�,�еy��....";
	xmldomData.appendChild( oRootNode );
	//�N ObjectName, AttributeName, txtMsg���s�J XMLDOM ����
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
	//�]�w Server �ݵ{��, �Ĥ@�ӰѼƬ� POST ��ܨϥ� POST �I�s Server , �ĤG�ӰѼƬ� Server �ݵ{���W��, �p�G menu �O�ϥ� Cache ��,���ϥ� full path , �_�h�|�䤣��{��
	// �ĤT�ӰѼƬO��ܬO�_�ϥΫD�P�B�I�s,�Y�ϥ� false ��,�h�b�U���ϥ� send() �I�s�ɷ|�� Server �|��������~�~��i��
	xmlHttp.open('POST',strUrl, false );	

	xmlHttp.setRequestHeader("Content-type","text/xml");
	
	//�I�s Server �ݵ{��, �õ��ݦ^��
	xmlHttp.send( xmldomData );

//	alert( xmlHttp.responseText );
//	document.getElementById("txtShow").outerHTML = xmlHttp.responseText;

	// xmlHttp.status ��� Server �^���X, ���@�뤧 HTTP �^���X, �p�� 300 ��ܥ��`, �q�`�O 200 
	if( xmlHttp.status < 300 )
	{	// Server �ݵ{�����`����
		// xmlhttp.responseText ���s��� Server �ݦ^���� XML ���, �ϥ� loadXML() �N�Ӹ�Ƹ��J XMLDOM ����
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
			// �Y txtMsg �����ť�(�@�볣�����ť�), �h����ܰT��
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
	{	// xmlHttp.responseText ���s��� Server �ݶǦ^�����~�e��, �ϥ� alert() �ä��Q�����, �H��i�A�ﵽ
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
��ƦW��:	string2RocDate()
��ƥ\��:	�ഫ ����r��ܥ���~���榡(YYY/MM/DD)
�ǤJ�Ѽ�:	strDate	    : ���ഫ���r��
			type	    : ��J�r�ꪺ�榡 "W:�褸�~, C:����~"
�Ǧ^��:		RocString	: �鴫�᪺����~�r��

�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	rocDate2String()
��ƥ\��:	�ഫ ����~�榡(YYY/MM/DD)���r��A�ܦ褸�~�Υ���~�r��
�ǤJ�Ѽ�:	strDate	      : ���ഫ���r��
			type		  : ��X�r�ꪺ���A (W:�褸�~,C:����~�^
�Ǧ^��:		returnString  : �ഫ�᪺��X�r��

�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function rocDate2String(strRocDate, type){
	// �ˬd�Ѽ�
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
		// check �O�_�n�ˬd(�O�_��A,U,D,I,P)
		for(j=0;j<aCheckFunctionCode.length;j++)
		{
			if( aThisFunction[i] == aCheckFunctionCode[j] )
			{
				bFound = true;
				break;
			}
		}
		if( bFound )	//�n�ˬd
		{
			//�ˬd�Ӷ��l�\��O�_�Q���v
			for(j=0;j<aGrantedFunction.length;j++)
			{
				if( aThisFunction[i] == aGrantedFunction[j] )
				{	//�Q���v���l�\��,�N�L�[�J�Ǧ^�l�\��}�C
					aReturn[iReturnArrayMax++] = aThisFunction[i];
					break;
				}
			}
		}
		else
		{	//�Ӷ�button���O���v����,�����[�J�Ǧ^���l�\��}�C
			aReturn[iReturnArrayMax++] = aThisFunction[i];
		}
	}
	//�N�Q���v���l�\��}�C�ର�r�ꫬ�A�Ǧ^
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