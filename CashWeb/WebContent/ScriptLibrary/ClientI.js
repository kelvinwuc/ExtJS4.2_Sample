var strErrMsg = "";				//batch�ˬd�����~�T��
var strFunctionKeyInitial="I,R";			//�{���w�]���\����:�d��

// added by elsa 2002/03/27 start
var strFunctionKeyReport="L,R";			//Report �W���d����
var strFunctionKeyInquiry_1="E";			//�d�߶s���U�ᤧ�\����:���}
var strFunctionKeyInquiry1="H,R,E";		//�d�߶s���U�ᤧ�\����:�T�w,�M��,���}
// added by elsa 2002/03/27 end

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
				PayHistory:ú�O�����d��
				PolicyLoan:�O��U�ک��Ӭd��
				PolicyLoanHistory:�O��U�ڬ����d��
				Apl:�۰ʹ�ú���Ӹ�Ƭd��
				AplHistory:�۰ʹ�ú������Ƭd��
				PolicyCnange:�����ܧ�i�׬d��
				PolicyChangeHistory:�������ʬ������v��Ƭd��
				InvestHistory:����������d��
				FundDetail:�ثe�U������ӤΧ��l�q�d��
				Claim:�z�߬����d��
				TransferHistory:�дڪ��p
				PolicyReport:�O���������  added by shirley 20040106
*/
//toolbar frame ���n��ܪ��\����,�|���ӱƦC���ǥX�{
//��ƦW��:	OnLoad( String strTitle, String strProgId, asThisFunctionKey )
//��ƥ\��:	��Client�ݵe���Ұʮ�,���楻���.
//		1.���btitle frame��ܵ{���N���ε{���W��,�{���N���ε{���W�٭n�b<BODY>tag���ק�
//		2.�YtxtClientMsg��줣���ťծ�, ��ܦ����~�T��,�ϥ�alert()��ܥ�
//		3.�btoolbar frame��ܥ\����
//�ǤJ�Ѽ�:	String strTitle: �{���W��,�m��title frame������,�o���ܼƬO�ϥΥ�������
//					document.title,���ק糧jsp��<TITLE>tag
//		String strProgId:	�{���N��,�m��title frame������.�ܼƨӷ���jsp��strThisProgId.
//		String asThisFunctionKey: �n��ܪ��\����N��,A:�s�W,U:�ק�,D:�R��,I:�d��,E:���},R:�M��
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
	else if (strButtonTag == "PayHistory" )
	{
		PayHistory();
	}
	else if (strButtonTag == "PolicyLoan" )
	{
		PolicyLoan();
	}
	else if (strButtonTag == "PolicyLoanHistory" )
	{
		PolicyLoanHistory();
	}
	else if (strButtonTag == "Apl" )
	{
		Apl();
	}
	else if (strButtonTag == "AplHistory" )
	{
		AplHistory();
	}
	else if (strButtonTag == "PolicyChange" )
	{
		PolicyChange();
	}
	else if (strButtonTag == "PolicyChangeHistory" )
	{
		PolicyChangeHistory();
	}
	else if (strButtonTag == "InvestHistory" )
	{
		InvestHistory();
	}
	else if (strButtonTag == "FundDetail" )
	{
		FundDetail();
	}
	else if (strButtonTag == "Claim" )
	{
		Claim();
	}
	else if (strButtonTag == "TransferHistory" )
	{
		TransferHistory();
	}
	else if (strButtonTag == "PolicyReport" )  // added by shirley 20040106
	{
		PolicyReport();
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
c	
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
			if( coll[k].className == "Key" )
				coll[k].disabled = true;
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("LELECT") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("SELECT");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" )
				coll[k].disabled = true;
		}
	}
	if( document.getElementById("frmMain").getElementsByTagName("TEXTAREA") != null )
	{
		var k=0;
		var coll = document.getElementById("frmMain").getElementsByTagName("TEXTAREA");
		for(k=0;k<coll.length;k++)
		{
			if( coll[k].className == "Key" )
				coll[k].disabled = true;
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
			if( coll[k].className == "Key" )
			{
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



