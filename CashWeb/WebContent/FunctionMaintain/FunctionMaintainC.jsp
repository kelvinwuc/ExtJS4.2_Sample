<%@ page language="java"  contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page import="com.aegon.comlib.*" %>

<%@ page import="java.util.*" %>

<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>�\�����ɺ��@</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript" >
var strFirstKey 			= "txtFuncId";		//�Ĥ@�ӥi��J��Key���W��
var strFirstData 			= "txtFuncName";		//�Ĥ@�ӥi��J��Data���W��
var strServerProgram 		= "FunctionMaintainS.jsp";	//Post��Server��,�n�I�s���{���W��
// *************************************************************
// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value) ;
	
	// 93/04/01 added by Andy : �ˮָӨϥΪ̬O�_�������v��
//	var domServerInformation = getServerInformation("UserInfo",strProgId);
//	updatePrevilege(domServerInformation.getElementsByTagName(strProgId).item(0).text);
	// end of 93/04/01
	WindowOnLoadCommon( document.title , '' , strFunctionKeyInitial,'' ) ;
	window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
	disableKey();
	disableData();
}
/*
��ƦW��:	addAction()
��ƥ\��:	��toolbar frame �����s�W���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	updateAction()
��ƥ\��:	��toolbar frame �����ק���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	inquiryAction()
��ƥ\��:	��toolbar frame �����d�߫��s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	deleteAction()
��ƥ\��:	��toolbar frame �����R�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function deleteAction()
{
	var bConfirm = window.confirm("�O�_�T�w�R���ӵ����?");
	if( bConfirm )
	{
		enableAll();
		document.getElementById("txtAction").value = "D";
		document.getElementById("frmMain").submit();
	}
}

/*
��ƦW��:	resetAction()
��ƥ\��:	��toolbar frame �����M�����s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame �������}���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
}

/*
��ƦW��:	confirmAction()
��ƥ\��:	��toolbar frame �����T�w���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function confirmAction()
{
	if( document.getElementById("txtAction").value == "I" )
	{
		/*	���� QueryFrameSet.jsp ��,�U QueryString �ѼƤ��N�q
			RowPerPage		: �C�@�����X�C
			Heading			: ���Y���W��,�H�r��','���}�C�@���
			DisplayFields	: �n��ܤ���Ʈw���W��,�H�r�����}�C�@���,�PHeading�۹���
			ReturnFields	: �Ǧ^������줧��,�H�r�����}�C�@���
			Sql				: �ݰ��椧SQL,��i�[�Jwhere����
			TableWidth		: ���Table���e��
	
		 modalDialog �|�Ǧ^�ϥΪ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}
		
		*/
		var strSql = "select * from FUNC where 1 = 1 ";
		if( document.getElementById("txtFuncId").value != "" )
			strSql += " and FUNID like '^"+document.getElementById("txtFuncId").value +"^' ";

		//var strQueryString = "?RowPerPage=20&Heading=�\��N��,�\��W��,�\�����O,�Ƶ�&DisplayFields=FUNID,FUNNAM,PROP,REMK&ReturnFields=FUNID&Sql="+strSql+"&TableWidth=600";

		//var strReturnValue = window.showModalDialog( "../CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:700px;dialogHeight:500px;center:yes" );
		<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	    session.setAttribute("Heading","�\��N��,�\��W��,�\�����O,�Ƶ�");
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
��ƦW��:	saveAction()
��ƥ\��:	��toolbar frame �����x�s���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
��ƦW��:	postToServer()
��ƥ\��:	�NClient����ƥH XMLHTTP ���覡�ǰe�� Server ��,�ñ����Ǧ^���T��
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function postToServer()
{
	var xmldomData = new ActiveXObject("Microsoft.XMLDOM");
	//�N�e���W����ƥ��s�J XMLDOM ����
	if( pushToXML( xmldomData ) != 0 )
		return;
	var xmlHttp = new ActiveXObject( "msxml2.XMLHTTP" );
	//�]�w Server �ݵ{��, �Ĥ@�ӰѼƬ� POST ��ܨϥ� POST �I�s Server , �ĤG�ӰѼƬ� Server �ݵ{���W��
	// �ĤT�ӰѼƬO��ܬO�_�ϥΫD�P�B�I�s,�Y�ϥ� false ��,�h�b�U���ϥ� send() �I�s�ɷ|�� Server �|��������~�~��i��
	xmlHttp.open('POST',strServerProgram, false );	
	xmlHttp.setRequestHeader("Content-type","text/xml");
	//�I�s Server �ݵ{��, �õ��ݦ^��
	xmlHttp.send( xmldomData );
//	alert( xmlHttp.responseText );
//	document.getElementById("txtShow").outerHTML = xmlHttp.responseText;
	// xmlHttp.status ��� Server �^���X, ���@�뤧 HTTP �^���X, �p�� 300 ��ܥ��`, �q�`�O 200 
	if( xmlHttp.status < 300 )
	{	// Server �ݵ{�����`����
		var xmldomResponseData = new ActiveXObject("Microsoft.XMLDOM");
		// xmlhttp.responseText ���s��� Server �ݦ^���� XML ���, �ϥ� loadXML() �N�Ӹ�Ƹ��J XMLDOM ����
		xmldomResponseData.loadXML( xmlHttp.responseText );
		// �Y txtMsg �����ť�(�@�볣�����ť�), �h����ܰT��
		if( xmldomResponseData.getElementsByTagName("txtMsg").length != 0 )
		{
			if( xmldomResponseData.getElementsByTagName("txtMsg").item(0).text != "" )
				alert(xmldomResponseData.getElementsByTagName("txtMsg").item(0).text );
		}
		// �Y�O���d�߮�,�h�]�w���d�ߥ\����,�ñN�Ǧ^����Ʒh��e���W,�_�h���зǤ��\����
		if( document.getElementById("txtAction").value == "I" )
		{
			moveToForm( xmldomResponseData );
			winToolBar.ShowButton( strFunctionKeyInquiry );
			window.status = "�ثe���d�ߪ��A,�Y�n�ק�ΧR�����,�Х���ܭק�ΧR���\����";
		}
		else
		{
			winToolBar.ShowButton( strFunctionKeyInitial );
			window.status = "�Х���ܷs�W�άd�ߥ\����,�Y�n�ק�ΧR�����,�i�g�Ѭd�ߥ\���A�i�J";
		}
		disableKey();
		disableData();

	}
	else
	{	// xmlHttp.responseText ���s��� Server �ݶǦ^�����~�e��, �ϥ� alert() �ä��Q�����, �H��i�A�ﵽ
		alert( xmlHttp.responseText );
	}
}

/*
��ƦW��:	pushToXML( xmldomData )
��ƥ\��:	�N�e�����n�W�Ǥ�����Ʀs�J xmldomData ��
�ǤJ�Ѽ�:	XMLDOM xmldomData	: �n�s�J�� xmldom ��Ƶ��c����
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function pushToXML( xmldomData )
{
	var oRootNode = xmldomData.createElement("XML");
	xmldomData.appendChild( oRootNode );
	//�N FORM ���Ҧ��� INPUT ���, �H���Ӥ� id �� tag name �s�J XML ��
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
		// radio type �� input �b�S���I��(checked)��,�N���|�i�J oRootNode ��,�@�w�n�t�~�[�J
		if( oRootNode.getElementsByTagName("radProperty").length == 0 )
		{
			var oTmpNode = xmldomData.createElement("radProperty");
			oTmpNode.text = "";
			oRootNode.appendChild( oTmpNode );
		}		
	}
	//�N FORM ���Ҧ��� SELECT ���, �H���Ӥ� id �� tag name �s�J XML ��
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
��ƦW��:	moveToForm( xmldomData )
��ƥ\��:	�� Server �Ǧ^��ƫ�,�N xmldomData ��Ʒh��e���W
�ǤJ�Ѽ�:	XMLDOM xmldomData	: Server �Ǧ^�����
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
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
        <td width="150"  class="TableHeading"><b>�\��N���G</b></td>    
        <td width="450" ><input class="Key" maxLength="20" type="text" name="txtFuncId" id="txtFuncId" value="" size="20">    
        </td>    
      </tr>    
      <tr>    
        <td width="150" class="TableHeading"><b>�\��W�١G</b></td>    
        <td width="450" ><input class="Data" maxLength="20" type="text" name="txtFuncName" id="txtFuncName" value=""  size="20">
	</td>    
      </tr>    
     <tr>     
        <td width="150" class="TableHeading"><b>�ݩ�:</b></td>      
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
        <td width="150" class="TableHeading"><b>�Ƶ��G</b></td>     
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
