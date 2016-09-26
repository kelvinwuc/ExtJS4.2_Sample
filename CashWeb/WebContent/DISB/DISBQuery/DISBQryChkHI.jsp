<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : ���v���ڬd��
 * 
 * Remark   : ��I�d��
 * 
 * Revision : $Revision: 1.7 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: DISBQryChkHI.jsp,v $
 * Revision 1.7  2013/12/24 03:48:55  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */
%><%! String strThisProgId = "DISBQryChkHI"; //���{���N��%><%
String strReturnMessage = (request.getAttribute("txtMsg") != null)?(String) request.getAttribute("txtMsg"):"";
String strAction = (request.getAttribute("txtAction") != null)?(String) request.getAttribute("txtAction"):"";

String strUserDept = (session.getAttribute("LogonUserDept") != null)?CommonUtil.AllTrim((String) session.getAttribute("LogonUserDept")):"";

GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	

DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alUSERid = new ArrayList();
if (session.getAttribute("USERList") == null) {
	alUSERid = (List) disbBean.getUSERList();
	session.setAttribute("USERList", alUSERid);
} else {
	alUSERid = (List) session.getAttribute("USERList");
}
Hashtable htTemp = null;
String strValue = null;
String strDesc = null;
StringBuffer sbUserId = new StringBuffer();
if (alUSERid.size() > 0) {
	for (int i = 0; i < alUSERid.size(); i++) {
		htTemp = (Hashtable) alUSERid.get(i);
		strValue = (String) htTemp.get("USERid");
		strDesc = (String) htTemp.get("USERname");
		sbUserId.append("<option value=\"").append(strValue).append("\">").append(strValue).append(" / ").append(strDesc).append("</option>");
	}
} else {
	sbUserId.append("<option value=\"\">&nbsp;</option>");
}
%>
<HTML>
<HEAD>
<TITLE>���ڬd��--���v���</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
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
		window.alert(document.getElementById("txtMsg").value);

	if (document.getElementById("txtAction").value == "")
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' );
		document.getElementById("updateArea").style.display = "none";
		document.getElementById("inqueryArea").style.display = "block";
	}
	else
	{
		WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyExit,'' ) ;	     
		document.getElementById("updateArea").display = "block";
		document.getElementById("inqueryArea").display = "none"; 
	}
}

/* ��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q���� */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBQuery/DISBQryChkHI.jsp?";
}

/* ��toolbar frame ����<�d��>���s�Q�I���,����Ʒ|�Q���� */
function inquiryAction()
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
	
		 modalDialog �|�Ǧ^�ϥΪ̿�w���Ϊ̿�w������(�ھ�ReturnFields�ҫ��w�����),�Y���h������,�|�H�r�����}
		*/
		mapValue();

		var strSql = "SELECT CBKNO,CACCOUNT,CNO,CNM,CAMT,CAST(CHEQUEDT AS CHAR(7)) AS CHEQUEDT,";
		strSql += " CAST(CUSEDT AS CHAR(7)) AS CUSEDT,CSTATUS,MEMO,DTAFRM,";
		strSql += " CAST(CRTNDT AS CHAR(7)) AS CRTNDT,ENTRYUSR,ENTRYDT,CBNO,CHG4USER";
		strSql += " FROM CAPCHKFHI ";
		strSql += " WHERE 1=1 ";
		if ( document.getElementById("txtCHEQUE").value != "" ) {
			strSql += "   AND CNO= '" + document.getElementById("txtCHEQUE").value.toUpperCase() + "' ";						
		}
		if( document.getElementById("txtPName").value != "" ) {
			strSql += "  AND CNM like '^" +  document.getElementById("txtPName").value + "^' ";
		}
		if( document.getElementById("txtPAMT").value != "" ) {
			strSql += " AND  CAMT = " + document.getElementById("txtPAMT").value + " ";
		}
		if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value != "") {
			strSql += " AND  CHEQUEDT BETWEEN " + document.getElementById("txtPStartDate").value + " and " + document.getElementById("txtPEndDate").value;
		} else if (document.getElementById("txtPStartDate").value != "" && document.getElementById("txtPEndDate").value == "") {
			strSql += "  AND CHEQUEDT >= " + document.getElementById("txtPStartDate").value ;
		} else if (document.getElementById("txtPStartDate").value == "" && document.getElementById("txtPEndDate").value != "") {
			strSql += " AND  CHEQUEDT <= " + document.getElementById("txtPEndDate").value ;
		}

		var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=820";
		<%	// �N QueryString �אּ session attribute �H�קK QueryString �L���y�� ie ���D  
	    session.setAttribute("Heading","���ڤH�m�W,��I���B,���ڪ��A,�����,�}�ߤ�");
	    session.setAttribute("DisplayFields", "CNM,CAMT,CSTATUS,CHEQUEDT,CUSEDT");
	    session.setAttribute("ReturnFields", "CBKNO,CACCOUNT,CNO,CNM,CAMT,CHEQUEDT,CUSEDT,CSTATUS,MEMO,DTAFRM,CRTNDT,ENTRYUSR,ENTRYDT,CBNO,CHG4USER");
	    %>
		var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:820px;dialogHeight:600px;center:yes" );
		if( strReturnValue != "" )
		{
			var returnArray = string2Array(strReturnValue,",");
			document.getElementById("txtUBKNO").value = returnArray[0];
			document.getElementById("txtUACCOUNT").value = returnArray[1];			
			document.getElementById("txtCHEQUE_NO").value = returnArray[2];
			document.getElementById("txtUPName").value = returnArray[3];
			document.getElementById("txtUPAMT").value = returnArray[4];
			document.getElementById("txtCHEQUE_DATE").value = returnArray[5];			
			document.getElementById("txtCHEQUE_USED_DATE").value = returnArray[6];
			document.getElementById("txtChequeMEMO").value = returnArray[8];
			document.getElementById("txtCHEQUE_RETURN_DATE").value = returnArray[10];
			document.getElementById("txtENTRYUSR").value = returnArray[11];
			document.getElementById("txtENTRYDT").value = returnArray[12];
			document.getElementById("txtC4User").value = returnArray[14];
			document.getElementById("txtCBNO").value = returnArray[13];
            //��ƨӷ�
			var strDataFrom =returnArray[9];
			if(strDataFrom =="WT"){
				document.getElementById("txtDataFrom").value ="�U�q�t��";
			} else if (strDataFrom ="DC") {
				document.getElementById("txtDataFrom").value ="�����t��";
			}
			//���ڪ��A			            
            var strChqST =returnArray[7];
            if (strChqST =="D"){
            	document.getElementById("txtCHEQUE_STATUS").value ="�}��";
            } else if (strChqST =="C") {
            	document.getElementById("txtCHEQUE_STATUS").value ="�I�{";
            } else if (strChqST =="R") {
            	document.getElementById("txtCHEQUE_STATUS").value ="�h�^";
            } else if (strChqST =="V") {
            	document.getElementById("txtCHEQUE_STATUS").value ="�@�o";
            } else if (strChqST =="1") {
            	document.getElementById("txtCHEQUE_STATUS").value ="�O�@�~";
            } else if (strChqST =="2") {
            	document.getElementById("txtCHEQUE_STATUS").value ="�O�G�~";
            } else if (strChqST =="3") {
            	document.getElementById("txtCHEQUE_STATUS").value ="���L";
            } else if (strChqST =="4") {
            	document.getElementById("txtCHEQUE_STATUS").value ="���}";
            } else if (strChqST =="5") {
            	document.getElementById("txtCHEQUE_STATUS").value ="����";
            } else if (strChqST =="6") {
            	document.getElementById("txtCHEQUE_STATUS").value ="���v�P�M";
            } else {
            	document.getElementById("txtCHEQUE_STATUS").value ="�w�s";
            }

			if("<%=strUserDept%>" == "FIN") {
				document.getElementById("buttonArea").style.display = "block";

				document.getElementById("txtChequeMEMO").className = "DATA";

				if(strChqST != "4")
				{
					document.getElementById("Update4").style.display = "block";
				}

				if (strChqST == "4" || document.getElementById("Update4").style.display == "block")
				{
					document.getElementById("Update4User").style.display = "block";
					if (strChqST != "4")
					{
						document.getElementById("txtC4User").className = "Data";
						document.getElementById("txtC4User").readOnly =  false;
					}
				}
			}

			WindowOnLoadCommon( document.title , '' , 'E', '' );
			document.getElementById("updateArea").style.display = "block"; 
			document.getElementById("inqueryArea").style.display = "none"; 
		}
	}
}

function mapValue() {
	document.getElementById("txtPStartDate").value = rocDate2String(document.getElementById("txtPStartDateC").value) ;
	document.getElementById("txtPEndDate").value = rocDate2String(document.getElementById("txtPEndDateC").value) ;	
}

//�ק�Ƶ�
function updateDataAction() {
	document.getElementById("txtAction").value = "UpdateData";
	document.getElementById("frmMain").submit();
}
//���}
function update4Action() 
{
	if (document.getElementById("txtC4User").value == "")
	{
		alert("���}���ڽп�J�ӽЪ�USER!");
	}
	else
	{
		document.getElementById("txtAction").value = "Update4";
		document.getElementById("txtUpdateStatus").value = "4";
		document.getElementById("frmMain").submit();
	}
}

function checkClientField(objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";

	if( objThisItem.name == "txtPStartDateC" ||  objThisItem.name == "txtPEndDateC" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
        strTmpMsg = "�t�Τ��-����榡���~";
        bReturnStatus = false;			
        }
	}

	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
			strErrMsg += strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbquery.DISBQryChkHIServlet">
<TABLE border="1" width="452"  id="inqueryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">���ڤH�m�W�G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="25" width="333"
				id="txtPName" name="txtPName" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">��I���B�G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11"
				name="txtPAMT" id="txtPAMT" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�������G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPStartDateC" name="txtPStartDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtPStartDate" id="txtPStartDate" value=""> ~ <INPUT
				class="Data" size="11" type="text" maxlength="11" id="txtPEndDateC"
				name="txtPEndDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="�d��"></a> <INPUT
				type="hidden" name="txtPEndDate" id="txtPEndDate" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">�䲼���X�G</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="16"
				name="txtCHEQUE" id="txtCHEQUE" value=""></TD>
		</TR>		
	</TBODY>
</TABLE>
<TABLE id="buttonArea" style="display:none">
	<TR>
		<TD id="Update4" style="display:none"><INPUT type="button" name="btnUpdate4" id="btnUpdate4" onClick="update4Action();" value="���}"></TD>
		<TD id="UpdateData"><INPUT type="button" name="btnUpdateData" id="btnUpdateData" onClick="updateDataAction();" value="�ק�Ƶ�"></TD>
	</TR>
</TABLE>
<TABLE border="1" width="600" id="updateArea" style="display:none">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="120">���ڤH�m�W�G</TD>
			<TD width="180"><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="11"
				id="txtUPName" name="txtUPName" ></TD>
			<TD align="right" class="TableHeading" width="120">��I���B�G</TD>
			<TD width="180"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtUPAMT" id="txtUPAMT" ></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >��w�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="25" type="text" maxlength="11"
				id="txtUBKNO" name="txtUBKNO" ></TD>
			<TD align="right" class="TableHeading" >�b���G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtUACCOUNT" id="txtUACCOUNT" ></TD>
		</TR>		
		<TR>
			<TD align="right" class="TableHeading" >�����G</TD>
			<TD ><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="11" id="txtCHEQUE_NO" name="txtCHEQUE_NO" value="" ></TD>
			<TD align="right" class="TableHeading" >�}�ߤ���G</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="11" id="txtCHEQUE_USED_DATE" name="txtCHEQUE_USED_DATE" readOnly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >�䲼���A�G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCHEQUE_STATUS" id="txtCHEQUE_STATUS" readOnly>
				<INPUT type="hidden" 
				name="txtCHEQUE_STATUS_HIDE" id="txtCHEQUE_STATUS_HIDE" value="2" />
				</TD>
			<TD align="right" class="TableHeading" >���ڨ����G</TD>
			<TD><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11"
				name="txtCHEQUE_DATE" id="txtCHEQUE_DATE" readOnly></TD>
		</TR>		
		<TR>
			<TD align="right" class="TableHeading" >�I�{����G</TD>
			<TD height="24"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="11" id="txtCHEQUE_RETURN_DATE" name="txtCHEQUE_RETURN_DATE" readOnly></TD>
			<TD align="right" class="TableHeading" >���ʤH���G</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtENTRYUSR" name="txtENTRYUSR" ></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >��ƨӷ��G</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" id="txtDataFrom"  name="txtDataFrom" ></TD>		
			<TD align="right" class="TableHeading" >���ʤ���G</TD>
			<TD><INPUT class="INPUT_DISPLAY" type="text" name="txtENTRYDT" id="txtENTRYDT" ></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" >���ڳƵ��G</TD>
			<TD colspan="3"><INPUT class="INPUT_DISPLAY" type="text" id="txtChequeMEMO" name="txtChequeMEMO" size="50" maxlength="50"></TD>
		</TR>
		<TR id="Update4User" style="display:none">
			<TD align="right" class="TableHeading">�ӽЭ��} User�G</TD>
			<TD colspan="3">
				<INPUT class="INPUT_DISPLAY" size="15" type="text" maxlength="10" name="txtC4User" id="txtC4User" ONKEYUP="autoComplete(this,this.form.options,'value',true,'selList')">
				<span style="display: none" id="selList">
					<SELECT NAME="options" onChange="this.form.txtC4User.value=this.options[this.selectedIndex].value" MULTIPLE SIZE=4 onblur="disableList('selList')" class="Data">
						<%=sbUserId.toString()%>
					</SELECT>
				</span>
			</TD>
		</TR>
	</TBODY>
</TABLE>
<INPUT type="hidden" id="txtCBNO" name="txtCBNO" value="">
<INPUT type="hidden" id="txtUpdateStatus" name="txtUpdateStatus" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>