var strErrMsg = "";						//batch�ˬd�����~�T��
var strFunctionKeyInitial="A,I";		//�{���w�]���\����:�s�W,�d��
var strFunctionKeyInitial1="AC,I";		//�{���w�]���\����:�s�WCAPSIL,�s�WFF,�d��
var strFunctionKeyAdd="S,R,E";			//�s�W�s���U�ᤧ�\����:�x�s,�M��,���}
var strFunctionKeyUpdate="S,E";			//�ק�s���U�ᤧ�\����:�x�s,���}
var strFunctionKeyInquiry="U,D,E";		//�d�߶s���U�ᤧ�\����:�ק�,�R��,���}
var strDISBFunctionKeyInitial="I";		//�{���w�]���\����:�d��
var strDISBFunctionKeyConfirm="I,DISBPaymentConfirm,E";	//�d�߶s���U�ᤧ�\����:�d��,��I�T�{,���}
var strDISBFunctionKeyInquiry="U,DISBPVoidable,E";		//�d�߶s���U�ᤧ�\����:�ק�,�@�o,���}
var strDISBFunctionKeyInquiry_1="DISBCancelConfirm,E";	//�d�߶s���U�ᤧ�\����:�����T�{,���}
var strDISBFunctionKeyExit="E";		//�d�߶s���U�ᤧ�\����:���}
var strDISBFunctionKeySourceU="U,E";//�d�߶s���U�ᤧ�\����:�ק�,���}
var strDISBFunctionKeySourceC="DISBPaymentConfirm,U,E";		//�d�߶s���U�ᤧ�\����:��I�T�{,�ק�,���}
var strDISBFunctionKeySDetailsU="DISBBack,U";				//�d�߶s���U�ᤧ�\����:�^�W�@�h,�ק�
var strDISBFunctionKeyRemitFailed="DISBRemitFailed,E";		//�d�߶s���U�ᤧ�\����:�װh,���}
var strDISBFunctionKeyRemit="DISBRemit,E";		//�d�߶s���U�ᤧ�\����:�d��,���״�,���}
var strDISBFunctionKeyCheck="DISBCheckOpen,E";	//�װh�s���U�ᤧ�\����:���ڶ}��,���}
var strDISBFunctionKeyCR="DISBCRejected,E";		//�d�߶s���U�ᤧ�\����:���ڰh�^,���}
var strDISBFunctionKeyCC="DISBCCreate,E";		//�d�߶s���U�ᤧ�\����:�H�u�}��,���}
var strDISBFunctionKeyNotice="U,L,E";			//�d�߶s���U�ᤧ�\����:�ק�,����,���}
var strDISBFunctionKeyRemitB="DISBDownload,L,E";//�d�߶s���U�ᤧ�\����:�U��,����,���}
var strDISBFunctionKeyRemitC="L,E";				//�d�߶s���U�ᤧ�\����:�U��,����,���}
var strDISBFunctionKeyCashed="DISBCheckCashed,E";//�װh�s���U�ᤧ�\����:���ڦ^�P,���}

var strFunctionKeyDelete="D,E";			//�d�߶s���U�ᤧ�\����:�R��,���}

var strFunctionKeyInquiry1="H,R,E";		//�d�߶s���U�ᤧ�\����:�T�w,�M��,���}
var strFunctionKeyReport="L";			//�{���w�]���\����:����
var strFunctionKeyInquiry2="H,R,E,L";	//�d�߶s���U�ᤧ�\����:�T�w,�M��,���},����  R60420
//var strRemitFailMaintainFunctionKey="U,I,R,E,L";		//�{���w�]���\����:�ק�,�d��,�M��,���},����  R90884
var strRemitFailMaintainFunctionKey="U,I,R,E";		//�{���w�]���\����:�ק�,�d��,�M��,���}  R10314
var strDISBFunctionKeyDown="DISBDownload,E";		//�U��,���}

//var keyBackgroundColor = "#F7EED9";
//var dataBackgroundColor = "white";

var keyBackgroundColor = null;
var dataBackgroundColor = null;
var queryBackgroundColor = null;

getDefaultColor();

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
				Q:�O��b����Ȭd��
				W:�O��b����Ⱦ��v��Ƭd��
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



/**
��ƦW��:	ToolBarClick( String strButtonTag )
��ƥ\��:	��toolbar frame�����@���sclick��,�N�|���楻���.����楻��Ʈɷ|�ǤJ�@�Ӧr��,
		�Ӧr��N��toolbar frame�����@�ӫ��s�Qclick
		��s�W,�ק���s��,�������������ˬd,�Y�����@�����~��,
		�N��ܥ������~�T��,�Y���T�ɫh�NbntAction�]�w���ǤJ���Ѽƭ�,
		�ð���MainForm.submit(),�N��J�����ǰe��web server
		�Y���d�ߤΧR����,���ˬd��ȬO�_���T,�Y���T,�h�NbntAction�]�w���ǤJ���Ѽƭ�,
		�ð���MainForm.submit(),�N��J�����ǰe��web server
		�Y���M����,�h�N�U���M��.
�ǤJ�Ѽ�:	String strButtonTag: 	A:�s�W���s
						U:�ק���s
						D:�R�����s
						I:�d�߫��s
						R:�M�����s
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function ToolBarOnClick(strButtonTag)
{
	if( iInterval != "" )
	{
		window.clearInterval(iInterval);
		iInterval = "";
	}
	if( strButtonTag == "A" )			//�s�W�s
	{
		document.getElementById("txtAction").value = strButtonTag ;
		addAction();
	}
	else if( strButtonTag == "AC" )			//�s�WCAPSIL�s
	{
		document.getElementById("txtAction").value = strButtonTag ;
		addAction();
	}
	else if( strButtonTag == "AF" )			//�s�WFF�s
	{
		document.getElementById("txtAction").value = strButtonTag ;
		addFAction();
	}
	else if( strButtonTag == "U" )		//�ק�s
	{
		document.getElementById("txtAction").value = strButtonTag ;
		updateAction();
	}
	else if( strButtonTag == "D" )		//�R���s
	{
		document.getElementById("txtAction").value = strButtonTag ;
		deleteAction();
	}
	else if( strButtonTag == "I" )		//�d�߶s
	{
		document.getElementById("txtAction").value = strButtonTag ;
		inquiryAction();
	}
	else if( strButtonTag == "E" )		//���}�s
	{
		exitAction();
	}
	else if( strButtonTag == "R" )		//�M���s
	{
	    resetAction();
	}
	else if( strButtonTag == "H" )		//�T�w
	{
		confirmAction();
	}
	else if( strButtonTag == "S" )		//�x�s
	{
		saveAction();
	}	
	else if ( strButtonTag == "L" )			//����Report  added by elsa 2002/03/27 start
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
		DISBDownloadAction(); // �U��
	}
	else if (strButtonTag == "DISBCancelConfirm" )
	{
		DISBCanConfirmAction(); // �����T�{
	}
	else if (strButtonTag == "DISBPaymentConfirm" )
	{
		DISBPConfirmAction(); // ��I�T�{
	}
	else if (strButtonTag == "DISBPVoidable" )
	{
		DISBPVoidableAction(); // �o��
	}
	else if (strButtonTag == "DISBRemitFailed" )
	{
	
		DISBRemitFailedAction(); // �װh
	}
	else if (strButtonTag == "DISBRemit" )
	{
	
		DISBRemitAction(); // ���״�
	}
	else if (strButtonTag == "DISBCheckOpen" )
	{
	
		DISBCheckOpenAction(); // ���ڶ}��
	}
	else if (strButtonTag == "DISBBack" )
	{
	
		DISBBackAction(); //�^�W�@�h
	}
	else if (strButtonTag == "DISBCRejected" )
	{
	
		DISBCRejectedAction(); //���ڰh�^
	}
	else if (strButtonTag == "DISBCCreate" )
	{
		DISBCCreateAction(); //�H�u�}��
	}
	else if (strButtonTag == "DISBCheckCashed" )
	{
		DISBCheckCashedAction(); //���ڦ^�P
	}
	//zhejun.he R00135
	else if (strButtonTag == "DISBUpdateRemark" ) 
	{
		DISBUpdateRemarkAction(); //�ק�Ƶ�
	}
	else if (strButtonTag == "DISBReopen" )
	{
		DISBReopenAction(); //���}
	}
	else if (strButtonTag == "DISBUpdateConfirm" )
	{
		DISBUpdateConfirmAction(); //�T�{�ק�
	}
	else if (strButtonTag == "DISBCancel" )
	{
		DISBCancelAction(); //����
	}
	else if (strButtonTag == "DISBReopenConfirm" )
	{
		DISBReopenConfirmAction(); //�T�{���}
	}
	//
	else
	{//�Y�����B�z�����s��,��ܿ��~�T��
		alert("The button flag = '"+strButtonTag+"' unhandled");
	}
}


/**
��ƦW��:	areAllFieldsOk()
��ƥ\��:	�I�scheckFieldsClient()�ˮ֩Ҧ����O�_��J���T
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
�P�_�O�_���ﶵ�Q�Ŀ�
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
        strTmpMsg ="�ܤ֭n�Ŀ�@������";
        bReturnStatus=false;
    }
    if( !bReturnStatus )
	{
			alert( strTmpMsg );
	}
	return bReturnStatus;
}
/*
�������s���B�z 2004/11/24  Elsa
*/
function ChangePage(ipage,iTpage,iCpage,iActionCode){
   var strid = "showPage"+ipage;
   var bReturnStatus = true;
   //�n���ܪ����� :ipage
   //�`����:iTpage
   //����:iCpage
   //����ʧ@:iActionCode   1-first 2-pre  3-next 4-last
 
  if((iActionCode == 1 || iActionCode == 2) && iCpage == 1)
  {
  		   bReturnStatus = false;
  			alert("�o�w�O�Ĥ@���F");       
  	
  }
  else   if((iActionCode == 3 || iActionCode == 4) && iCpage == iTpage)
  {
      bReturnStatus = false;
      	alert("�o�w�O�̫�@���F");   
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
���Ȫ�selected  2004/12/07  Elsa
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