<%@ page language="java" contentType="text/html; charset=BIG5"
	pageEncoding="BIG5"%>
<%@ page autoFlush="true"%>

<%!/*
	 * System   : CashWeb
	 * 
	 * Function : �״ڭ��B�Τ���O���@
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
	 * R00135---PA0024---CASH�~�ױM��
	 *
	 *  
	 */%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<title>�״ڭ��B�Τ���O���@</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../Theme/global/custom.css">
<SCRIPT language="JavaScript" src="../ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="../ScriptLibrary/Calendar.js"></SCRIPT>
<script type="text/javascript">

	var strFirstKey 			= "txtRemAmtFrom";			//�Ĥ@�ӥi��J��Key���W��
	var strFirstData 			= "txtRemAmtFrom";			//�Ĥ@�ӥi��J��Data���W��
	var strServerProgram 		= "RemittanceFeeS.jsp";		//Post��Server��,�n�I�s���{���W��
	var myInitFuncKey 			= "A,I,E";

	//*************************************************************
	/*
	 ��ƦW��:	WindowOnLoad()
	 ��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
	 �ǤJ�Ѽ�:	�L
	 �Ǧ^��:	�L
	 �ק����:	�ק���	�ק��	��   ��   �K   �n
	 ---------	----------	-----------------------------------------
	 */
	function WindowOnLoad() {
		if (document.getElementById("txtMsg").value != "")
			window.alert(document.getElementById("txtMsg").value);
		WindowOnLoadCommon(document.title, '', myInitFuncKey, '');
		window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
		disableKey();
		disableData();
		
	}

	// ��[�d��]�ɳQ�I�s�� function
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
			/*	���� QueryFrameSet.jsp ��,�U QueryString �ѼƤ��N�q
				RowPerPage		: �C�@�����X�C
				Heading			: ���Y���W��,�H�r��','���}�C�@���
				DisplayFields	: �n��ܤ���Ʈw���W��,�H�r�����}�C�@���,�PHeading�۹���
				ReturnFields	: �Ǧ^������줧��,�H�r�����}�C�@���
				Sql				: �ݰ��椧SQL,��i�[�Jwhere����
				TableWidth		: ���Table���e��
			
			 	modalDialog �|�Ǧ^�ϥΪ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}
			
			 */
			 
			var strSql = "select FLD001,FLD002,FLD003,FLD004,FLD005,FLD006,FLD007,FLD008 from BANKFEE where 1 = 1 ";
			var curr = document.getElementById("txtCurr").value;
			if (document.getElementById("txtCurr").value != "")
				strSql += " and FLD002 = '" + curr + "' ";
			//
			strSql += " ORDER BY FLD002, FLD003";

			var strQueryString = "?RowPerPage=20&Sql=" + strSql + "&TableWidth=650&queryType=RemittanceFee&queryCurr=" + curr;

		<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	    session.setAttribute("Heading","���O,���B(�_),���B(�W),�Ȧ����O,�������O,�״ڤ���O,�Ƶ�");
	    session.setAttribute("DisplayFields", "FLD002,FLD003,FLD004,FLD005,FLD006,FLD007,FLD008");
	    session.setAttribute("ReturnFields", "FLD001,FLD002,FLD003,FLD004,FLD005,FLD006,FLD007,FLD008");
	    %>
			//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
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
				window.status = "�ثe���d�ߪ��A,�Y�n�ק�ΧR�����,�Х���ܭק�ΧR���\����";
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
	��ƦW��:	saveAction()
	��ƥ\��:	��toolbar frame �����x�s���s�Q�I���,����Ʒ|�Q����
	�ǤJ�Ѽ�:	�L
	�Ǧ^��:	�L
	�ק����:	�ק���	�ק��	��   ��   �K   �n
	---------	----------	-----------------------------------------
	*/
	function saveAction()
	{
		// ���[�W�״ڪ��B
		var bankFee = parseInt( document.getElementById("txtBankFee").value.replace(/,/g, ""), 10 );
		var fiscFee = parseInt( document.getElementById("txtFiscFee").value.replace(/,/g, ""), 10 ); 
		document.getElementById("txtRemFee").value = formatInteger( bankFee + fiscFee + "" );
		
		// �@�ߥ� server �P�_�B�z
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
		myHttpRequest.send( queryString );	//�I�s Server �ݵ{��, �õ��ݦ^��
		
		// show result message
		var respText = myHttpRequest.responseText;
		if( respText.substring( 0, 10 ) == "UpdateMsg=" )	// �����`����U���^��
			respText = respText.substring( 10 );
		else
			respText = myHttpRequest.responseText;			// �����U���^��, �i��O HTML code
		respText = respText.replace(/(^\s*)|(\s*$)/g, "");
			
		if( myHttpRequest.status < 300 ) {	// HTTP �� 2XX �j�P�W�� NORMAL
			
			alert( respText );
		
			winToolBar.ShowButton( "U,E" );
			disableAll();
			// ���\���D�n key �ȧ۰_��, �~��K�s��ק�
			document.getElementById( "txtOldCurr" ).value = document.getElementById( "txtCurr" ).value;
			document.getElementById( "txtOldRemAmtFrom" ).value = document.getElementById( "txtRemAmtFrom" ).value;
			document.getElementById( "txtOldRemAmtTo" ).value = document.getElementById( "txtRemAmtTo" ).value;
			
		} else {
			alert( "�s�ɥ��ѡG " + respText );
		}
	}
	
	// �@�L�u��, �\��۷�U�i�� function
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
			<TD>���O�G</TD>
			<TD>
				<INPUT type="text" id="txtCurr" name="txtCurr" size="4"
					maxlength="2" value="NT" class="Key" disabled="disabled">
			</TD>
		</TR>
		<TR>
			<TD>�״ڪ��B *�G</TD>
			<TD>
				&nbsp;�_�G<INPUT type="text" id="txtRemAmtFrom" name="txtRemAmtFrom" size="20"
					maxlength="20" value="" class="Data">
				&nbsp;�W�G<INPUT type="text" id="txtRemAmtTo" name="txtRemAmtTo" size="20"
					maxlength="20" value="" class="Data">
			</TD>
		</TR>
		<TR>
			<TD>�Ȧ����O *�G</TD>
			<TD>
				<INPUT type="text" id="txtBankFee" name="txtBankFee" size="10"
					maxlength="10" value="" class="Data">
			</TD>
		</TR>
		<TR>
			<TD>�������O *�G</TD>
			<TD><INPUT type="text" id="txtFiscFee" name="txtFiscFee" size="10"
					maxlength="10" value="" class="Data">
			</TD>
		</TR>
		<TR>
			<TD>�״ڤ���O *�G</TD>
			<TD><INPUT type="text" id="txtRemFee" name="txtRemFee" size="10"
					maxlength="10" value="" class="Data" disabled="disabled">
			</TD>
		</TR>
		<TR>
			<TD>�Ƶ��G</TD>
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