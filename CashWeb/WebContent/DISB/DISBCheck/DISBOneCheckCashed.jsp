<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393       Leo Huang    			2010/09/20           �{�b�ɶ���Capsil��B�ɶ�
 *	 R00393  	  Leo Huang    			2010/09/21           ������|��۹���|
 *   R00231       Leo Huang    			2010/09/26           ����ʦ~�M��
 *  =============================================================================
 */
%>
<%@ page language="java" contentType="text/html; charset=CP950" pageEncoding="CP950" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>
<%@ page import="com.aegon.disb.util.DISBCheckControlInfoVO"%>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.DbFactory" %>

<%//R00393%>
<!--# include virtual="/Logon/Init.inc"-->
<!--# include virtual="/Logon/CheckLogonDISB.inc"-->
<!--
/*
 * System   : 
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $Revision: 1.9 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2014/07/18 07:25:51 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBOneCheckCashed.jsp,v $
 * Revision 1.9  2014/07/18 07:25:51  misariel
 * EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 *
 * Revision 1.8  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.2  2008/08/18 06:15:51  MISODIN
 * R80338 �վ�Ȧ�b����檺�w�]��
 *
 * Revision 1.1  2006/06/29 09:40:44  MISangel
 * Init Project
 *
 * Revision 1.1.2.3  2005/04/04 07:02:23  miselsa
 * R30530 ��I�t��
 *
 *  
 */
-->

<%! String strThisProgId = "DISBOneCheckCashed"; //���{���N��%>
<%
//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
SimpleDateFormat sdfDateFormatter =
	new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", java.util.Locale.TAIWAN);
SimpleDateFormat sdfDate =
	new SimpleDateFormat("yyyyMMdd", java.util.Locale.TAIWAN);
SimpleDateFormat sdfTime =
	new SimpleDateFormat("hhmmss", java.util.Locale.TAIWAN);

GlobalEnviron globalEnviron =
	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
//R00393  Edit by Leo Huang (EASONTECH) Start
//java.util.Date dteToday = cldCalendar.getTime(); //�ثe����ɶ�
//R00393  Edit by Leo Huang (EASONTECH) End
List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") ==null)
{
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList",alPBBank);
}
else
{
	alPBBank =(List) session.getAttribute("PBBankList");
}

List alPDetail = new ArrayList();
int iPageSize = 10;
 int itotalpage = 0;
 int itotalCount = 0;
 double iSumAmt = 0;//�`���B
if(session.getAttribute("PDetailList") !=null)
{
alPDetail = (List)session.getAttribute("PDetailList");

 if (alPDetail!=null)
 {
	if (alPDetail.size()>0)
	 {
	  		  for (int k = 0 ; k < alPDetail.size();k++)
	         {
	            	DISBPaymentDetailVO objPDetailCounter = (DISBPaymentDetailVO)alPDetail.get(k);
	            	iSumAmt = iSumAmt + objPDetailCounter.getIPAMT();
	         }
	    	itotalCount = alPDetail.size();
    }	
  if(itotalCount%iPageSize == 0)
    {
        itotalpage = itotalCount/iPageSize;
    }
    else
    {
         itotalpage = itotalCount/iPageSize + 1;
    }	
 }

 }
 session.removeAttribute("PDetailList");
 
 List alCControl = new ArrayList();
if(session.getAttribute("CheckControlList") !=null)
{
	alCControl = (List)session.getAttribute("CheckControlList");
 }
 session.removeAttribute("CheckControlList");
 
String strCBNoOld = ""; 
String strCSNoOld = "";
String strEmptyCheckCount = "";
if(alCControl.size()>0)
{
		DISBCheckControlInfoVO objCControlVO = (DISBCheckControlInfoVO)alCControl.get(0);
		strCBNoOld = (String)objCControlVO.getStrCBNo().trim();
		strCSNoOld = (String)objCControlVO.getStrCSNo().trim();
		if(objCControlVO.getIEmptyCheck() >0)
			strEmptyCheckCount = Integer.toString(objCControlVO.getIEmptyCheck());
}


String strAction = "";
if (request.getAttribute("txtAction") != null) {
    strAction = (String) request.getAttribute("txtAction");
  }  
  
String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
    strReturnMessage = (String) request.getAttribute("txtMsg");
  }  
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>�䲼�\��--���ڳ浧�^�P�@�~</TITLE>
<!--edit by Leo Huang 
<LINK REL="stylesheet" TYPE="text/css"
	HREF="/CashWeb/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="/CashWeb/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="/CashWeb/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="/CashWeb/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="/CashWeb/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/CashWeb/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/CashWeb/ScriptLibrary/Calendar.js"></SCRIPT>
-->
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"
	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<!--edit by Leo Huang-->
<script LANGUAGE="javascript">
var iTotalrec =<%=itotalCount%>;
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
		{
			window.alert(document.getElementById("txtMsg").value) ;
			//R00393 edit by Leo Huang
			//window.location.href= "/CashWeb/DISB/DISBCheck/DISBOneCheckCashed.jsp";
			window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBOneCheckCashed.jsp";
			//R00393 edit by Leo Huang
		}	
	
	if(document.getElementById("txtAction").value == "I")
	{
	      WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyCashed,'' ) ;
			document.getElementById("inquiryArea").style.display = "none";
			document.getElementById("updateArea").style.display = "block";
	  }
	  else
	  {
	       	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' ) ;
	  	  document.getElementById("inquiryArea").style.display = "block"; 
	  	  document.getElementById("updateArea").style.display = "none";
	     
	  }
	    window.status = "";
	
//	disableKey();
//	disableData();
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
	document.getElementById("txtAction").value = "";
	disableAll();
	//R00393 edit by Leo Huang 
	//window.location.href= "/CashWeb/DISB/DISBCheck/DISBOneCheckCashed.jsp";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBOneCheckCashed.jsp";
	//R00393 edit by Leo Huang 
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
	if( areAllFieldsOK() )
	{	
	//{
		/*	���� QueryFrameSet.jsp ��,�U QueryString �ѼƤ��N�q
			RowPerPage		: �C�@�����X�C
			Heading			: ���Y���W��,�H�r��','���}�C�@���
			DisplayFields	: �n��ܤ���Ʈw���W��,�H�r�����}�C�@���,�PHeading�۹���
			ReturnFields	: �Ǧ^������줧��,�H�r�����}�C�@���
			Sql				: �ݰ��椧SQL,��i�[�Jwhere����
			TableWidth		: ���Table���e��
	
		 modalDialog �|�Ǧ^�ϥΪ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}
		
		*/
		/*RC0036
		document.getElementById("txtAction").value = "I";*/   
	 	mapValue();

 		var strSql = "";
	
			strSql = "SELECT CBKNO,CACCOUNT,CBNO,CNO,CNM,CAMT,CAST(CHEQUEDT AS CHAR(7)) as CHEQUEDT,CAST(CUSEDT AS CHAR(7)) as CUSEDT,PNO,CHNDFLG,CAST(ENTRYDT AS CHAR(7)) as ENTRYDT,ENTRYUSR ";		
			strSql += " from CAPCHKF ";
	         strSql += " WHERE 1=1 AND CRTNDT =0 AND CBCKDT =0 AND CSTATUS='D'  ";
	         strSql += " AND  CHEQUEDT <= " + document.getElementById("txtChequeDT").value ;
			strSql += " AND  CBKNO = '" + document.getElementById("txtPBBank").value + "' " ;
			strSql += " AND  CACCOUNT = '" + document.getElementById("txtPBAccount").value + "' " ;

   	    var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=830";
		<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	    session.setAttribute("Heading","�Ȧ��w,�Ȧ�b��,���ڸ��X,���ک��Y,�}�ߤ��,��I�Ǹ�,��J��,��J��");
	    session.setAttribute("DisplayFields", "CBKNO,CACCOUNT,CNO,CNM,CUSEDT,PNO,ENTRYUSR,ENTRYDT");
	    session.setAttribute("ReturnFields", "CBKNO,CACCOUNT,CBNO,CNO,CNM,CAMT,CUSEDT,CHEQUEDT,PNO");
	    %>
		//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:830px;dialogHeight:600px;center:yes" );
		
		if( strReturnValue != "" )
		{
			//enableAll();
			var returnArray = string2Array(strReturnValue,",");

			document.getElementById("txtUCBKNO").value = returnArray[0];
			document.getElementById("txtUCACCOUNT").value = returnArray[1];
			document.getElementById("txtUCBNO").value = returnArray[2];
			document.getElementById("txtUCNO").value = returnArray[3];
			document.getElementById("txtUCNM").value = returnArray[4];		
			document.getElementById("txtUCAMT").value = returnArray[5];
			//R00231 edit by Leo Huang �}�ߤ�M�������
		   //document.getElementById("txtUCUSEDT").value = string2RocDate(returnArray[6]);
		   //document.getElementById("txtUCHEQUEDT").value = string2RocDate(returnArray[7]);
		   document.getElementById("txtUCHEQUEDT").value = string2RocDate(returnArray[6]);
		   document.getElementById("txtUCUSEDT").value = string2RocDate(returnArray[7]);
		   document.getElementById("txtUPNO").value = returnArray[8];
	
			document.getElementById("txtAction").value = "I";
			
		  WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyCashed,'' ) ;		 
       	    
	
	    document.getElementById("updateArea").style.display = "block"; 
	    document.getElementById("inquiryArea").style.display = "none"; 
//			disableAll();
	
	}
  }
  	else
	{
		alert( strErrMsg );
	}	
}
/*
��ƦW��:	DISBCheckOpenAction()
��ƥ\��:	��toolbar frame ����[���ڶ}��]���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/

function DISBCheckCashedAction()
{
  if( areAllFieldsOK() )
	{
	    var strConfirmMsg = "�O�_�T�w����浧�^�P�@�~?\n";
	    var bConfirm = window.confirm(strConfirmMsg);
		if( bConfirm )
		{
  		  enableAll();
		document.getElementById("txtAction").value = "DISBCheckCashed";
			mapValue();
				document.getElementById("frmMain").submit();
		}
	}
	else
	{
		alert( strErrMsg );
	}	
}
/**
��ƦW��:	checkClientField(objThisItem,bShowMsg)
��ƥ\��:	�ˮֶǤJ�����O�_���T
�ǤJ�Ѽ�:	objThisItem:�ݴ��ժ���쪫��
			bShowMsg:true:�Y����ܿ��~�T��,false:���n�Y����ܿ��~�T��,�N���~�T���ֿn��strErrMsg��
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if( objThisItem == null )
	{
		objThisItem = window.event.srcElement;
		bShowMsg = true;
	}	
	if(document.getElementById("txtAction").value =="I")
	{
		if( objThisItem.id == "txtCashDTC" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "�I�{������i�ť�";
				bReturnStatus = false;
			}
		}	
	}
	else
	{
		if( objThisItem.id == "txtChequeDTC" )
		{
			if( objThisItem.value == "" )
			{
				strTmpMsg = "���ڨ��������i�ť�";
				bReturnStatus = false;
			}
		}		
	}
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
function mapValue(){
     var BankAccount = document.getElementById("selPBBank").value ;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtPBBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtPBAccount").value = BankAccount.substring(iindexof+1);	
	}
	document.getElementById("txtChequeDT").value 
		= rocDate2String(document.getElementById("txtChequeDTC").value) ;
	document.getElementById("txtCashDT").value 
		= rocDate2String(document.getElementById("txtCashDTC").value) ;	
  }

</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<!--R00393  Edit by Leo Huang (EASONTECH) Start
<form
	action="/CashWeb/servlet/com.aegon.disb.disbcheck.DISBOneCCreateServlet"
	id="frmMain" method="post" name="frmMain">
-->
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBOneCCreateServlet"
	id="frmMain" method="post" name="frmMain">
<!--R00393  Edit by Leo Huang (EASONTECH) End-->
<TABLE border="1" width="393" id=inquiryArea name=inquiryArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="104">�I�ڱb���G</TD>
			<TD width="281"><select size="1" name="selPBBank" id="selPBBank">
                <option value="8220635/635300021303">8220635/635300021303-���H�ȴ_��</option><!--R80338-->			
				<%if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		Hashtable htPBBankTemp = (Hashtable) alPBBank.get(i);
		String strETVDesc = (String) htPBBankTemp.get("ETVDesc");
		String strETValue = (String) htPBBankTemp.get("ETValue");
		out.println(
			"<option value="
				+ strETValue
				+ ">"
				+ strETValue
				+ "-"
				+ strETVDesc
				+ "</option>");
	}
} else {%>
				<option value=""></option>
				<%}%>
			</select> <INPUT type="hidden" name="txtPBBank" id="txtPBBank"
				value=""> <INPUT type="hidden" name="txtPBAccount" id="txtPBAccount"
				value=""></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" width="104">���ڨ����G</TD>
			<TD width="281"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtChequeDTC" name="txtChequeDTC" value=""
				readOnly onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtChequeDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<!--R00393  Edit by Leo Huang (EASONTECH) Start
				<IMG src="/CashWeb/images/misc/show-calendar.gif" alt="�d��">
				-->
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��">
				<!--R00393 Edit by Leo Huang (EASONTECH) End-->
				</a> 
				 <INPUT
				type="hidden" name="txtChequeDT" id="txtChequeDT" value=""></TD>
		</TR>
	</TBODY>
</TABLE>
<TABLE border="1" width="488" id="updateArea" name="updateArea" style="display: none">
	<TBODY>
			<TR>
			<TD align="right" class="TableHeading" width="161">�пﲼ�ڧI�{��G</TD>
			<TD width="319"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtCashDTC" name="txtCashDTC" value=""
				readOnly > <a
				href="javascript:show_calendar('frmMain.txtCashDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<!--R00393  Edit by Leo Huang (EASONTECH) Start
				<IMG src="/CashWeb/images/misc/show-calendar.gif" alt="�d��">
				-->
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��">
				<!--R00393  Edit by Leo Huang (EASONTECH) End-->
			    </a> 
				 <INPUT
				type="hidden" name="txtCashDT" id="txtCashDT" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="161">�Ȧ��w�G</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="8" type="text"
				maxlength="7" name="txtUCBKNO" id="txtUCBKNO" value="" readonly></TD>
		</TR>

		<tr>
			<TD align="right" class="TableHeading" width="161">�Ȧ�b���G</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="16" id="txtUCACCOUNT" name="txtUCACCOUNT" ></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="161">���ڧ帹�G</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="6" id="txtUCBNO" name="txtUCBNO"></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="161">���ڸ��X�G</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="18" name="txtUCNO" id="txtUCNO" readonly></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="161">���ک��Y�G</TD>
		<TD width="319"><INPUT class="INPUT_DISPLAY" size="30" type="text"
				maxlength="20" name="txtUCNM" id="txtUCNM" readonly></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="161">�������B�G</TD>
		<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="18" name="txtUCAMT" id="txtUCAMT" readonly></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" width="161">�}�ߤ�G</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="18" name="txtUCUSEDT" id="txtUCUSEDT" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="161">�����G</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="18" name="txtUCHEQUEDT" id="txtUCHEQUEDT" readonly></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="161">��I���X�G</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="30" type="text"
				maxlength="30" name="txtUPNO" id="txtUPNO" value="" readonly></TD>
		</tr>

	</TBODY>
</TABLE>
<INPUT name="txtAction" id="txtAction"  type="hidden" value="<%=strAction%>">
	 <INPUT name="txtMsg"
	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">

<IFRAME id="outputFrame" name="outputFrame" height="0" width="0"></IFRAME>
	
</FORM>
</BODY>
</HTML>
