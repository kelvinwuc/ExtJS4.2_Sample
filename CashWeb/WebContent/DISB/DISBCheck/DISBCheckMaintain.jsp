<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : ���ں��@
 * 
 * Remark   : �X�ǥ\��
 * 
 * Revision : $Revision: 1.10 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckMaintain.jsp,v $
 * Revision 1.10  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 * Revision 1.9  2013/02/22 03:21:35  ODCWilliam
 * william wu
 * PA0024
 * bill cash day
 *
 * Revision 1.8  2012/08/29 09:18:46  ODCKain
 * Character problem
 *
 * Revision 1.7  2012/08/29 03:38:54  ODCWilliam
 * modify:william
 * date:2012-08-28
 *
 * Revision 1.6  2010/11/23 02:17:05  MISJIMMY
 * R00226-�ʦ~�M��
 *
 * Revision 1.5  2009/08/27 06:23:26  misodin
 * Q90431 �������}�ݿ�J�ӽЭ��}User
 *
 * Revision 1.4  2009/01/21 02:05:17  misvanessa
 * Q90020_�ӽЭ��}USER�ϥ��I��覡
 *
 * Revision 1.3  2008/08/18 06:15:05  MISODIN
 * R80338 �վ�Ȧ�b����檺�w�]��
 *
 * Revision 1.2  2006/10/31 08:57:33  MISVANESSA
 * R60420_���ڲ��ʬ�"4"���},�ݿ�J�ӽЭ��}USER
 *
 * Revision 1.1  2006/06/29 09:40:44  MISangel
 * Init Project
 *
 * Revision 1.1.2.13  2005/10/31 03:32:03  misangel
 * R50820:��I�\�ണ��
 *
 * Revision 1.1.2.12  2005/08/08 01:48:09  misangel
 * �w�s���i�@�o
 *
 * Revision 1.1.2.10  2005/04/20 03:29:19  miselsa
 * R30530_�קﲼ�ڳƵ�
 *
 * Revision 1.1.2.9  2005/04/04 07:02:23  miselsa
 * R30530 ��I�t��
 *  
 */
%><%!String strThisProgId = "DISBCheckMaintain"; //���{���N��%><%
String strAction = (request.getAttribute("txtAction") == null)?"":(String) request.getAttribute("txtAction");
String strReturnMessage = (request.getAttribute("txtMsg") == null)?"":(String) request.getAttribute("txtMsg");

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPBBank = new ArrayList();
if (session.getAttribute("PBBankList") ==null) {
	alPBBank = (List) disbBean.getETable("PBKAT", "BANK");
	session.setAttribute("PBBankList",alPBBank);
} else {
	alPBBank =(List) session.getAttribute("PBBankList");
}

//Q90020 USER LIST
List alUSERid = new ArrayList();
if (session.getAttribute("USERList") == null) {
	alUSERid = (List) disbBean.getUSERList();
	session.setAttribute("USERList", alUSERid);
} else {
	alUSERid = (List) session.getAttribute("USERList");
}
//Q90020 END
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>�䲼�\��--���ڪ��A���@�@�~</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
/* ��e�ݵ{���}�l��,����Ʒ|�Q���� */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckMaintain.jsp";
	}	
	if (document.getElementById("txtAction").value == "")
	{
		document.getElementById("inquiryArea").style.display = "block";
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;
		window.status = "";
	}
	else
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyExit,'' ) ;
		window.status = "";
	}
}

/* ��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q���� */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckMaintain.jsp?";
}

/* ��toolbar frame ����<�d��>�s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
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
	mapValue();

	var strSql = "";
	strSql = " select CHEQUE_NO,CHEQUE_BOOK_NO,CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_NAME,CHEQUE_AMOUNT,CAST(CHEQUE_DATE AS CHAR(7))  AS CHEQUE_DATE,CAST(CHEQUE_CASH_DATE AS CHAR(7)) AS CASH_DATE,CAST(CHEQUE_RETURN_DATE AS CHAR(7)) AS CHEQUE_RETURN_DATE,CAST(CHEQUE_USED_DATE AS CHAR(7)) AS CHEQUE_USED_DATE,CAST(CHEQUE_BACK_DATE AS CHAR(7)) AS CHEQUE_BACK_DATE,CHEQUE_STATUS,PAY_NO,CHEQUE_ERROR_FLAG,CHEQUE_HAND_FLAG,CAST(ENTRY_DATE AS CHAR(7)) AS ENTRY_DATE,CAST(ENTRY_TIME AS CHAR(6)) AS ENTRY_TIME,ENTRY_USER,CHEQUE_MEMO,CHEQUE_CHG4USER ";
	strSql += " from  CAPCHKF ";
	strSql += " WHERE  1=1 ";
	if( document.getElementById("txtCBank").value != "" ) {
		strSql += " AND CHEQUE_BANK_NO = '" + document.getElementById("txtCBank").value + "' ";
	}
	if( document.getElementById("txtCAccount").value != "" ) {
		strSql += "  AND  CHEQUE_ACCOUNT= '" + document.getElementById("txtCAccount").value + "' ";
	}
	if( document.getElementById("txtCNo").value != "" ){
		strSql += "  AND CHEQUE_NO like '^" +  document.getElementById("txtCNo").value + "^' ";
	}

	var strQueryString = "?Time="+new Date()+"&RowPerPage=20&Sql="+strSql+"&TableWidth=500";
<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	session.setAttribute("Heading","�Ȧ��w,�Ȧ�b��,���ڧ帹,���ڸ��X,���ڪ��A,��J��,��J��");
	session.setAttribute("DisplayFields", "CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_BOOK_NO,CHEQUE_NO,CHEQUE_STATUS,ENTRY_USER,ENTRY_DATE");
	session.setAttribute("ReturnFields", "CHEQUE_NO,CHEQUE_BOOK_NO,CHEQUE_BANK_NO,CHEQUE_ACCOUNT,CHEQUE_NAME,CHEQUE_AMOUNT,CHEQUE_DATE,CASH_DATE,CHEQUE_RETURN_DATE,CHEQUE_USED_DATE,CHEQUE_BACK_DATE,CHEQUE_STATUS,PAY_NO,CHEQUE_ERROR_FLAG,CHEQUE_HAND_FLAG,CHEQUE_MEMO,CHEQUE_CHG4USER");
%>
	//modalDialog �|�Ǧ^�ϥΪ̿�w������,�Y���h������,�|�H�r�����}
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:550px;dialogHeight:600px;center:yes" );
	if( strReturnValue != "" )
	{
		var returnArray = string2Array(strReturnValue,",");

		document.getElementById("txtCNoU").value = returnArray[0];
		document.getElementById("txtCBNoU").value = returnArray[1];
		document.getElementById("txtCBkNoU").value = returnArray[2];
		document.getElementById("txtCAccountU").value = returnArray[3];
		document.getElementById("txtCNMU").value = returnArray[4];		
		document.getElementById("txtCAMTU").value = returnArray[5];	
		if( returnArray[6] == "0") {
			document.getElementById("txtChequeDtU").value = "";
		} else {
			document.getElementById("txtChequeDtU").value = returnArray[6];
		}
	    if( returnArray[7] == "0") {
	    	document.getElementById("txtCashDtU").value = "";
	    } else {
	    	document.getElementById("txtCashDtU").value = returnArray[7];
	    }
	    if( returnArray[8] == "0") {
	    	document.getElementById("txtCrtnDtU").value = "";
	    } else {
	    	document.getElementById("txtCrtnDtU").value = returnArray[8];
	    }
	    if( returnArray[9] == "0") {
	    	document.getElementById("txtCUseDtU").value = "";
	    } else {
	    	document.getElementById("txtCUseDtU").value = returnArray[9];
	    }
	    if( returnArray[10] == "0") {
	    	document.getElementById("txtCBckDtU").value = "";
	    } else {
	    	document.getElementById("txtCBckDtU").value = returnArray[10];
	    }
		var strCStatus = returnArray[11];
		document.getElementById("txtCStatusU").value = returnArray[11];
		document.getElementById("txtPNoU").value = returnArray[12];
		document.getElementById("txtCerFlagU").value = returnArray[13];
		document.getElementById("txtChndFlgU").value = returnArray[14];
		document.getElementById("txtCMEMO").value = returnArray[15];
		document.getElementById("txtC4User").value = returnArray[16];//R60420

		document.getElementById("txtAction").value = "I";
		WindowOnLoadCommon( document.title , '' , 'E','' ) ;
		document.getElementById("updateArea").style.display = "block";
		document.getElementById("inquiryArea").style.display = "none";

		/*�����Buttion ���e�{*/
		if(strCStatus == "") //�w�s���i�@�o
		{
			document.getElementById("UpdateV").style.display = "block";
		}
		if(strCStatus == "D")
		{
			document.getElementById("UpdateV").style.display = "block";
			document.getElementById("UpdateR").style.display = "block";
			document.getElementById("Update1").style.display = "block";
			document.getElementById("Update3").style.display = "block";
			document.getElementById("Update4").style.display = "block";
		}
		else  if(strCStatus == "R")
		{
			document.getElementById("Update1").style.display = "block";
			document.getElementById("Update2").style.display = "block";
			document.getElementById("Update4").style.display = "block";
		}
		else  if(strCStatus == "1")
		{
			document.getElementById("Update2").style.display = "block";
			document.getElementById("Update4").style.display = "block";
			document.getElementById("UpdateV").style.display = "block";
		}
		else  if(strCStatus == "2")
		{
			document.getElementById("Update4").style.display = "block";
			document.getElementById("UpdateV").style.display = "block";
		}
		else  if(strCStatus == "C")
		{
			document.getElementById("Update5").style.display = "block";
		}
		else  if(strCStatus == "5")
		{
			document.getElementById("Update6").style.display = "block";
		}
		//R60420 �ӽ�4�@�o���}��USER
		if (strCStatus =="4" || document.getElementById("Update4").style.display == "block")
		{
			document.getElementById("Update4User").style.display = "block";
			if (strCStatus != "4")
			{
				document.getElementById("txtC4User").className = "Data";
				document.getElementById("txtC4User").readOnly =  false;
			}
		}
		//Q90431 �ӽ�5�������}��USER
		if (strCStatus =="5" || document.getElementById("Update5").style.display == "block" || strCStatus =="6")
		{
			document.getElementById("Update4User").style.display = "block";
			if (strCStatus != "5" && strCStatus != "6")
			{
				document.getElementById("txtC4User").className = "Data";
				document.getElementById("txtC4User").readOnly =  false;
			}
		}
	}
}

/* ��s���ڪ��A���@�o: V */
function updateVAction()
{
	document.getElementById("txtAction").value = "UpdateV";
	document.getElementById("txtUpdateStatus").value = "V";
	document.getElementById("frmMain").submit();
}
/* ��s���ڪ��A���h�^: R */
function updateRAction()
{
	document.getElementById("txtAction").value = "UpdateR";
	document.getElementById("txtUpdateStatus").value = "R";
	document.getElementById("frmMain").submit();
}
/* ��s���ڪ��A���O�@�~: 1 */
function update1Action()
{
	document.getElementById("txtAction").value = "Update1";
	document.getElementById("txtUpdateStatus").value = "1";
	document.getElementById("frmMain").submit();
} 
/* ��s���ڪ��A���O�G�~: 2 */
function update2Action()
{
	document.getElementById("txtAction").value = "Update2";
	document.getElementById("txtUpdateStatus").value = "2";
	document.getElementById("frmMain").submit();
} 
/* ��s���ڪ��A�����L: 3 */
function update3Action()
{
	document.getElementById("txtAction").value = "Update3";
	document.getElementById("txtUpdateStatus").value = "3";
	document.getElementById("frmMain").submit();
} 
/* ��s���ڪ��A�����}:4 */
function update4Action()
{
	//R60420 ���}������J�ӽЪ�USER
	if (document.getElementById("txtC4User").value == "") {
		window.alert("���}���ڽп�J�ӽЪ�USER!");		
	} else {
		document.getElementById("txtAction").value = "Update4";
		document.getElementById("txtUpdateStatus").value = "4";
		document.getElementById("frmMain").submit();
	}
}
/* ��s���ڪ��A������: 5 */
function update5Action()
{
	//Q90431 ���}������J�ӽЪ�USER
	if (document.getElementById("txtC4User").value == "") {
		window.alert("���}���ڽп�J�ӽЪ�USER!");
	} else {
		document.getElementById("txtAction").value = "Update5";
		document.getElementById("txtUpdateStatus").value = "5";
		document.getElementById("frmMain").submit();
	}
} 
/* ��s���ڪ��A�����v�P�M: 6 */
function update6Action()
{
	document.getElementById("txtAction").value = "Update6";
	document.getElementById("txtUpdateStatus").value = "6";
	document.getElementById("frmMain").submit();
} 
/* �u�ק�Ƶ� */
function updateDataAction()
{
	document.getElementById("txtAction").value = "UpdateData";
	document.getElementById("frmMain").submit();
} 

function mapValue() {
	var BankAccount = document.getElementById("selCBank").value ;
	if(BankAccount !="")
	{
		var iindexof = BankAccount.indexOf('/');
		document.getElementById("txtCBank").value = BankAccount.substring(0,iindexof);
		document.getElementById("txtCAccount").value = BankAccount.substring(iindexof+1);	
	}  
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckMaintainServlet" id="frmMain" method="post" name="frmMain">
<TABLE border="1" width="452" id=inquiryArea name=inquiryArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">�I�ڱb���G</TD>
			<TD width="333"><select size="1" name="selCBank" id="selCBank">
                <option value="8220635/635300021303">8220635/635300021303-���H�ȴ_��</option><!--R80338-->
				<%if (alPBBank.size() > 0) {
	for (int i = 0; i < alPBBank.size(); i++) {
		Hashtable htPBBankTemp = (Hashtable) alPBBank.get(i);
		String strETVDesc = (String) htPBBankTemp.get("ETVDesc");
		String strETValue = (String) htPBBankTemp.get("ETValue");
		out.println("<option value=" + strETValue + ">" + strETValue + "-" + strETVDesc + "</option>");
	}
} else {%>
				<option value=""></option>
				<%}%>
			</select>
			<INPUT type="hidden" name="txtCBank" id="txtCBank"	value="">
			<INPUT type="hidden" name="txtCAccount" id="txtCAccount" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">���ڸ��X�G</TD>
			<TD><INPUT class="Data" size="20" type="text" maxlength="18" name="txtCNo" id="txtCNo" value="">(�ҽk���)</TD>
		</TR>
	</TBODY>
</TABLE>
<DIV Id=updateArea style="display:none ">
<table>
<tr>
<td id="UpdateV"  style="display:none" ><input type="button" name="btnUpdateV" id="btnUpdateV" onClick="updateVAction();" value="�@�o"></td>
<td id="UpdateR"  style="display:none" ><input type="button" name="btnUpdateR" id="btnUpdateR" onClick="updateRAction();" value="�h�^"></td>
<td id="Update1"  style="display:none" ><input type="button" name="btnUpdate1" id="btnUpdate1" onClick="update1Action();" value="�O�@�~��"></td>
<td id="Update2"  style="display:none" ><input type="button" name="btnUpdate2" id="btnUpdate2" onClick="update2Action();" value="�O�G�~��"></td>
<td id="Update3" style="display:none" ><input type="button" name="btnUpdate3" id="btnUpdate3" onClick="update3Action();" value="���L"></td>
<td id="Update4"  style="display:none" ><input type="button" name="btnUpdate4" id="btnUpdate4" onClick="update4Action();" value="���}"></td>
<td id="Update5" style="display:none" ><input type="button" name="btnUpdate5" id="btnUpdate5" onClick="update5Action();" value="����"></td>
<td id="Update6"  style="display:none" ><input type="button" name="btnUpdate6" id="btnUpdate6" onClick="update6Action();" value="���v�P�M"></td>
<td id="UpdateData"  style="" ><input type="button" name="btnUpdateData" id="btnUpdateData" onClick="updateDataAction();" value="�ק�Ƶ�"></td>
</tr>
</table>
<TABLE border="1" width="452" >
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">���ڸ��X�G</TD>
			<TD><INPUT  class="INPUT_DISPLAY" size="25" type="text" maxlength="25"
				name="txtCNoU" id="txtCNoU" value="" readonly></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="101">���ڧ帹�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				id="txtCBNoU" name="txtCBNoU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">�Ȧ��w�G</TD>
			<TD width="333"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="10" id="txtCBkNoU" name="txtCBkNoU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">�Ȧ�b���G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCAccountU" id="txtCAccountU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">���ک��Y�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50"
				name="txtCNMU" id="txtCNMU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">���ڪ��B�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCAMTU" id="txtCAMTU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">�����G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtChequeDtU" id="txtChequeDtU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">�I�{��G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCashDtU" id="txtCashDtU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">�^�P��G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCrtnDtU" id="txtCrtnDtU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">�}�ߤ�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCUseDtU" id="txtCUseDtU" readonly></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="101">�h�^��G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCBckDtU" id="txtCBckDtU" readonly></TD>
		</tr>		
		<tr>
			<TD align="right" class="TableHeading" width="101">�䲼���A�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCStatusU" id="txtCStatusU" readonly></TD>
		</tr>		
		<tr>
			<TD align="right" class="TableHeading" width="101">��I�Ǹ��G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="30" type="text" maxlength="11"
				name="txtPNoU" id="txtPNoU" readonly></TD>
		</tr>	
		<tr>
			<TD align="right" class="TableHeading" width="101">���D���ڡG</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCerFlagU" id="txtCerFlagU" readonly></TD>
		</tr>	
		<tr>
			<TD align="right" class="TableHeading" width="101">�H�u�}���ΡG</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtChndFlgU" id="txtChndFlgU" readonly></TD>
		</tr>									
		<tr>
			<TD align="right" class="TableHeading" width="101">�Ƶ� : </TD>
			<TD><INPUT class="DATA" size="50" type="text" maxlength="50"
				name="txtCMEMO" id="txtCMEMO" ></TD>
		</tr>
		<!--R60420 �ӽЭ��}��USER-->
		<tr id="Update4User" style="display:none">
			<TD align="right" class="TableHeading" width="101">�ӽЭ��}User : </TD>
			<TD><INPUT class="INPUT_DISPLAY" size="15" type="text" maxlength="10"
				name="txtC4User" id="txtC4User" 
				ONKEYUP="autoComplete(this,this.form.options,'value',true,'selList')">
		<!--Q90020 ����I��-->
			<span style="display: none" id="selList" name="selList">
			<SELECT
				NAME="options"
				onChange="this.form.txtC4User.value=this.options[this.selectedIndex].value"
				MULTIPLE SIZE=4 onblur="disableList('selList')" class="Data">
	<%if (alUSERid.size() > 0) {
			for (int i = 0; i < alUSERid.size(); i++) {
				Hashtable htUSERIDTemp = (Hashtable) alUSERid.get(i);
				String strETid = (String) htUSERIDTemp.get("USERid");
				String strETname = (String) htUSERIDTemp.get("USERname");
				out.println(
				"<option value="
					+ strETid
					+ ">"
					+ strETid + " / " + strETname
					+ "</option>");
			}
	} else {%>
		<option value=""></option>
	<%}%>
			</select> </span></TD>
		</tr>
	</TBODY>
</TABLE>
����(���ڪ��A����):
D:�w�}�BC:�I�{�BV:�@�o�BR:�h�^�B1:�O�@�~���B2:�O�G�~���B3:���L�B4:���}�B5:�����B6:���v�P�M
</div>
<INPUT name="txtUpdateStatus" id="txtUpdateStatus" type="hidden" value=""> 
<INPUT name="txtAction" id="txtAction" type="hidden" 	value="<%=strAction%>"> 
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>
