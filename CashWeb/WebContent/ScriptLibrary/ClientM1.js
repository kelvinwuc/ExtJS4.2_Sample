var strErrMsg = "";						//batch�ˬd�����~�T��
var strFunctionKeyInitial="A,I";			//�{���w�]���\����:�s�W,�d��
var strFunctionKeyAdd="S,R,E";			//�s�W�s���U�ᤧ�\����:�x�s,�M��,���}
var strFunctionKeyUpdate="S,E";			//�ק�s���U�ᤧ�\����:�x�s,���}
var strFunctionKeyInquiry="U,D,E";		//�d�߶s���U�ᤧ�\����:�ק�,�R��,���}
var strFunctionKeyDelete="H,E";			//�R���s���U�ᤧ�\����:�T�w,���}

// added by elsa 2002/03/27 start
var strFunctionKeyReport="L,R";			//Report �W���d����
var strFunctionKeyInquiry_1="E";		//�d�߶s���U�ᤧ�\����:���}
var strFunctionKeyInquiry1="H,R,E";		//�d�߶s���U�ᤧ�\����:�T�w,�M��,���}
// added by elsa 2002/03/27 end

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



