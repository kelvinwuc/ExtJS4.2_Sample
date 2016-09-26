<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="com.aegon.entactbat.BankTemplateDTO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.2 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : 
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntActBatU.jsp,v $
 * Revision 1.2  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 *
 *  
 */
%><%! String strThisProgId = "EntActBatB"; //���{���N�� %><% 
String strMsg = (request.getAttribute("txtMsg") == null)?"":(String)request.getAttribute("txtMsg");
BankTemplateDTO dto = (BankTemplateDTO)request.getAttribute("DTO");
%>
<html>
<head>
<title>�Ȧ�n�b�ҪO�קﭶ��</title>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientM1.js"></SCRIPT>
<SCRIPT>
<!--
function WindowOnLoad() 
{
	if(document.getElementById("txtMsg").value!=""){
		alert(document.getElementById("txtMsg").value);
	}
	WindowOnLoadCommon( document.title , '' , strFunctionKeyUpdate,'' ) ;
}

function exitAction() 
{
	document.getElementById("PAGETYPE").value ="";
	window.location.href = "<%=request.getContextPath()%>/EntActBat/EntActBatTemplate.jsp";
}

function defineValue() {
	var res = document.getElementById("fileType").value;
	if(res == "C"){
		document.getElementById("txt1").style.display="none";
		document.getElementById("txt3").style.display="none";
		document.getElementById("txt2").style.display="";
		document.getElementById("txt4").style.display="";
		document.getElementById("coa").checked ="checked";
		document.getElementById("M4").checked ="checked";
	    document.getElementById("N4").checked ="checked";
	} else {
		document.getElementById("txt1").style.display="";
		document.getElementById("txt3").style.display="";
		document.getElementById("txt2").style.display="none";
		document.getElementById("txt4").style.display="none";
		document.getElementById("fix").checked ="checked";
		document.getElementById("M3").checked ="checked";
		document.getElementById("N3").checked ="checked";
	}
}

function check(res){
	if(res == "F"){
		document.getElementById("txt1").style.display="";
		document.getElementById("txt3").style.display="";
		document.getElementById("txt2").style.display="none";
		document.getElementById("txt4").style.display="none";
		document.getElementById("M3").checked ="checked";
		document.getElementById("N3").checked ="checked";
	}else{
		document.getElementById("txt1").style.display="";
        document.getElementById("txt3").style.display="none";
	    document.getElementById("txt2").style.display="none";
		document.getElementById("txt4").style.display="";
		document.getElementById("M4").checked ="checked";
	    document.getElementById("N4").checked ="checked";
	}
}

function saveAction() {
	var code = document.getElementById("bkCode").value;
	var sDate = document.getElementById("dsnum").value;
	var eDate = document.getElementById("denum").value;
	var sAmount = document.getElementById("asnum").value;
	var eAmount = document.getElementById("aenum").value;
	var speNum = document.getElementById("SPLNUM").value;
	var dNum = document.getElementById("DNUM").value;
	var aNum = document.getElementById("ANUM").value;
	var cNum = document.getElementById("CNUM").value;
	var ftype = document.getElementsByName("g");
	var radio = "";
	for(var i = 0;i < ftype.length; i++){
		if(ftype[i].checked == true){
			radio = ftype[i].value;
			document.getElementById("SPL").value = radio;
		}
	}
	if(code == ""){
		alert("�Ȧ�N�X���ର��");
	}else{
		if(radio == "F"){
			if(sDate == "" || eDate ==""){
				alert("����_����줣����");
			}else{
				if(sAmount =="" || eAmount ==""){
					alert("������B�_����줣����");
				}else{
					AssignmentHidden(radio);
					document.frmMain.submit();
				}
			}
		}else{
			if(speNum == ""){
				alert("���j���Ƥ�����");
			}else{
				if(dNum == ""){
					alert("������ƦC�줣�ର��");
				}else{
					if(aNum ==""){
						alert("������B�ƦC�줣�ର��");
					}else{
						if(cNum ==""){
							alert("�Ƶ��ƦC�줣�ର��");
						}else{
							AssignmentHidden(radio);
							document.frmMain.submit();
						}
					}
				}
			}
		}
	}
}

function AssignmentHidden(sel) {
	if(sel == "F"){
		//���o��ܤ�������� ��ȵ����é�
		var ytype = document.getElementsByName("year3");
		for(var i =0;i<ytype.length;i++){
			if(ytype[i].checked == true){
				document.getElementById("DTYPE").value =ytype[i].value;
			}
		}
		//���o��ܤ���O�_�s�b���βŭ� ��ȵ����é�
		var jtype = document.getElementsByName("judge3");
		for(var i =0;i<jtype.length;i++){
			if(jtype[i].checked == true){
				document.getElementById("SLANT").value =jtype[i].value;
			}
		}
		//���o���ĥ�����B�զ����� ��ȵ����é�
		var atype = document.getElementsByName("amount");
		for(var i = 0;i < atype.length; i++){
			if(atype[i].checked == true){
				type = atype[i].value;
				if(type =="LRO"){
					document.getElementById("LEFTZ").value = "Y";
				}
				if(type =="DEC"){
					document.getElementById("TPOT").value ="Y";
				}
				if(type =="OPT"){
					document.getElementById("SPOT").value ="Y";
				}
				if(type =="TSN"){
					document.getElementById("TSN").value ="Y";
				}
				if(type =="LRS"){
					document.getElementById("LEFTS").value ="Y";
				}
				if(type =="PNN"){
					document.getElementById("LEFTO").value ="Y";
				}
				if(type =="RRS"){
					document.getElementById("RIGO").value ="Y";
				}
			}
		}
	}else{
		//���o��ܤ�������� ��ȵ����é�
		var ytype = document.getElementsByName("year4");
		for(var i =0;i<ytype.length;i++){
			if(ytype[i].checked == true){
				document.getElementById("DTYPE").value =ytype[i].value;
			}
		}
		//���o��ܤ���O�_�s�b���βŭ� ��ȵ����é�
		var jtype = document.getElementsByName("judge4");
		for(var i =0;i<jtype.length;i++){
			if(jtype[i].checked == true){
				document.getElementById("SLANT").value =jtype[i].value;
			}
		}
		//���o��ܤ���O�_�s�b���βŭ� ��ȵ����é�
		var atype = document.getElementsByName("amount4");
		for(var i =0;i<atype.length;i++){
			if(atype[i].checked == true){
				type = atype[i].value;
				if(type =="DEC"){
					document.getElementById("TPOT").value ="Y";
				}
				if(type =="OPT"){
					document.getElementById("SPOT").value ="Y";
				}
				if(type =="TSN"){
					document.getElementById("TSN").value ="Y";
				}
				if(type =="LRS"){
					document.getElementById("LEFTS").value ="Y";
				}
				if(type =="PNN"){
					document.getElementById("LEFTO").value ="Y";
				}
				if(type =="RRS"){
					document.getElementById("RIGO").value ="Y";
				}
			}
		}
	}
}
//-->
</SCRIPT>
</HEAD>
<BODY onload="WindowOnLoad();">
<BR>
<FORM name="frmMain" METHOD="POST" ACTION="<%=request.getContextPath()%>/servlet/com.aegon.entactbat.EntActBatTemplateServlet" >
<DIV>
	<TABLE>
		<TR>
			<TD>����²�X:*</TD>
			<TD><input type="text" id="bkCode" name="bkCode" value="<%=dto.getBankCode()%>"></TD>
		</TR>
		<TR>
			<TD>�W�ǵn�b��������:*</TD>
			<TD>
				<select id="fileType"  name="fileType" onchange="defineValue();">
					<option value="T" <%=(dto.getFileType().equals("T"))?" selected":""%>>TXT</option>
					<option value="C" <%=(dto.getFileType().equals("C"))?" selected":""%>>CSV</option>
					<option value="F" <%=(dto.getFileType().equals("F"))?" selected":""%>>FLT</option>
					<option value="D" <%=(dto.getFileType().equals("D"))?" selected":""%>>DAT</option>
				</select>
			</TD>
		</TR>
	</TABLE>
</DIV>
<%if("C".equals(dto.getSplitFileType())){ %>
<DIV id="txt1" style="display:none;">
	<TABLE>
		<TR>
			<TD>���Τ��ɤ覡:*</TD>
			<TD><input type="radio"  id ="fix" name="g" value="F"  onchange="check('F')">���w��&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="sem" name="g" value="S" onchange="check('S')">;���j</TD>
		</TR>
	</TABLE>
</DIV>
<DIV id="txt2">
	<TABLE>
		<TR>
			<TD>���Τ��ɤ覡:*</TD>
			<TD><input type="radio" id="coa" name="g" value="C" checked="checked">,���j</TD>
		</TR>
	</TABLE>
</DIV>
<%}else{ %>
<DIV id="txt1">
	<TABLE>
		<TR>
			<TD>���Τ��ɤ覡:*</TD>
			<%if("F".equals(dto.getSplitFileType())){ %>
			<TD><input type="radio"  id ="fix" name="g" value="F"  checked="checked" onchange="check('F')">���w��&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="sem" name="g" value="S" onchange="check('S')">;���j</TD>
			<%}else{%>
			<TD><input type="radio"  id ="fix" name="g" value="F"   onchange="check('F')">���w��&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="sem" name="g" value="S" checked="checked" onchange="check('S')">;���j</TD>
			<%} %>
		</TR>
	</TABLE>
</DIV>
<DIV id="txt2" style="display:none;">
	<TABLE>
		<TR>
			<TD>���Τ��ɤ覡:*</TD>
			<TD><input type="radio" id="coa" name="g" value="C" >,���j</TD>
		</TR>
	</TABLE>
</DIV>
<%} 
if("F".equals(dto.getSplitFileType())){%>
<DIV id="txt3">
	<TABLE>
		<TR>
			<TD>������:*</TD>
			<TD>�_��:<input  type="text" id="dsnum" name="dsnum" value="<%=dto.getDateStart() %>">�X�X����<input type="text" id="denum" name="denum" value="<%=dto.getDateEnd() %>"></TD>
		</TR>
		<TR>
			<TD>������榡:*</TD>
			<%if("M".equals(dto.getDateTpye())){ %>
			<TD><input type="radio" id="M3" name="year3" value="M" checked="checked">����~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X3" name="year3" value="X">�褸�~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year3" value="B">����~���X</TD>
			<%}else if("B".equals(dto.getDateTpye())){ %>
			<TD><input type="radio" id="M3" name="year3" value="M" >����~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X3" name="year3" value="X">�褸�~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year3" value="B" checked="checked">����~���X</TD>
			<%}else{ %>
			<TD><input type="radio" id="M3" name="year3" value="M" >����~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X3" name="year3" value="X" checked="checked">�褸�~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year3" value="B">����~���X</TD>
			<%} %>
		</TR>
		<TR>
			<TD>����O�_�����j�Ÿ�"/"*</TD>
			<%if("N".equals(dto.getIsSlant())){ %>
			<TD><input type="radio" id="N3" name="judge3" value="N" checked="checked">�_&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="Y3" name="judge3" value="Y">�O</TD>
			<%}else{ %>
			<TD><input type="radio" id="N3" name="judge3" value="N" >�_&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="Y3" name="judge3" value="Y" checked="checked">�O</TD>
			<%} %>
		</TR>
		<TR>
			<TD>������B���:*</TD>
			<TD>�_��:<input  type="text" id="asnum" name="asnum" value="<%=dto.getFeeStart() %>">�X�X����<input type="text" id="aenum" name="aenum" value="<%=dto.getFeeEnd()%>"></TD>
		</TR>
		<TR>
			<TD>������B���զ����c(�h�ﶵ):*</TD>
			<TD>
				<%if("Y".equals(dto.getIsLeftZero())){ %>
				<input type="checkbox" id="O" name="amount" value="LRO" checked="checked">�k�a���ɹs&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount" value="LRO">�k�a���ɹs&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIsLeftSpace())){ %>
				<input type="checkbox" id="O" name="amount" value="LRS" checked="checked">�k�a���ɪ�&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount" value="LRS">�k�a���ɪ�&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIsTwoNum())){ %>
				<input type="checkbox" id="O" name="amount" value="DEC" checked="checked">���p��&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount" value="DEC">���p��&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIsPoint())){ %>
				<input type="checkbox" id="O" name="amount" value="OPT" checked="checked">�p���I&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount" value="OPT">�p���I&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIsPermille())){ %>
				<input type="checkbox" id="O" name="amount" value="TSN" checked="checked">�d����&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount" value="TSN">�d����&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIsFristNum())){ %>
				<input type="checkbox" id="O" name="amount" value="PNN" checked="checked">��1�X�����t��&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount" value="PNN">��1�X�����t��&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIslastNum())){ %>
				<input type="checkbox" id="O" name="amount" value="RRS" checked="checked">�̫�1�X�t���Ϊť�
				<%}else{ %>
				<input type="checkbox" id="O" name="amount" value="RRS">�̫�1�X�t���Ϊť�
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>�Ƶ����:*</TD>
			<TD>�_��:<input  type="text" id="csnum" name="csnum" value="<%=dto.getConStart()%>">�X�X����<input type="text" id="cenum" name="cenum" value="<%=dto.getConEnd()%>"></TD>
		</TR>
		<TR>
		</TR>
	</TABLE>
</DIV>
<DIV id="txt4" style="display:none;">
	<TABLE>
		<TR>
			<TD>���j����:*</TD>
			<TD><input  type="text" id="SPLNUM" name="SPLNUM"></TD>
		</TR>
		<TR>
			<TD>������榡:*</TD>
			<TD><input type="radio" id="M4" name="year4" value="M" checked="checked">����~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X4" name="year4" value="X">�褸�~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year3" value="B">����~���X</TD>
		</TR>
		<TR>
			<TD>����O�_�����j�Ÿ�"/":*</TD>
			<TD><input type="radio" id="N4" name="judge4" value="N" checked="checked">�_&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="Y4" name="judge4" value="Y">�O</TD>
		</TR>
		<TR>
			<TD>������ƦC��:*</TD>
			<TD><input type="text" id="DNUM" name="DNUM" value="" >
		</TR>
		<TR>
			<TD>������B��ƦC��:*</TD>
			<TD><input type="text" id="ANUM" name="ANUM" value="" >
		</TR>
		<TR>
			<TD>������B��즳�d����:</TD>
			<TD><input type="radio" id="Y" name="amount4" value="Y">�O&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="N" name="amount4" value="N">�_</TD>
		</TR>
		<TR>
			<TD>�Ƶ��ƦC��:*</TD>
			<TD><input type="text" id="CNUM" name="CNUM" value="" >
		</TR>
	</TABLE>
</DIV>
<%}else{%>
<DIV id="txt3" style="display:none;" >
	<TABLE>
		<TR>
			<TD>������:*</TD>
			<TD>�_��:<input  type="text" id="dsnum" name="dsnum">�X�X����<input type="text" id="denum" name="denum"></TD>
		</TR>
		<TR>
			<TD>������榡:*</TD>
			<TD><input type="radio" id="M3" name="year3" value="M" checked="checked">����~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X3" name="year3" value="X">�褸�~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year3" value="B">����~���X</TD>
		</TR>
		<TR>
			<TD>����O�_�����j�Ÿ�"/"*</TD>
			<TD><input type="radio" id="N3" name="judge3" value="N" checked="checked">�_&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="Y3" name="judge3" value="Y">�O</TD>
		</TR>
		<TR>
			<TD>������B���:*</TD>
			<TD>�_��:<input  type="text" id="asnum" name="asnum">�X�X����<input type="text" id="aenum" name="aenum"></TD>
		</TR>
		<TR>
			<TD>������B���զ����c(�h�ﶵ):*</TD>
			<TD>
				<input type="checkbox" id="O" name="amount" value="LRO">�k�a����0&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="O" name="amount" value="DEC">���p��&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" id="O" name="amount" value="OPT">�p���I&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="O" name="amount" value="TSN">�d����&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" id="O" name="amount" value="LRS">�k�a���ɪ�&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="O" name="amount" value="PNN">��1�X�����t��&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" id="O" name="amount" value="RRS">�̫�1�X�t���Ϊť�
			</TD>
		</TR>
		<TR>
			<TD>�Ƶ����:*</TD>
			<TD>�_��:<input  type="text" id="csnum" name="csnum">�X�X����<input type="text" id="cenum" name="cenum"></TD>
		</TR>
	</TABLE>
</DIV>
<DIV id="txt4">
	<TABLE >
		<TR>
			<TD>���j����:*</TD>
			<TD><input  type="text" id="SPLNUM" name="SPLNUM" value="<%=dto.getSplitNum()%>"></TD>
		</TR>
		<TR>
			<TD>������榡:*</TD>
			<%if("M".equals(dto.getDateTpye())){ %>
			<TD><input type="radio" id="M3" name="year4" value="M" checked="checked">����~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X3" name="year4" value="X">�褸�~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year4" value="B">����~���X</TD>
			<%}else if("B".equals(dto.getDateTpye())){ %>
			<TD><input type="radio" id="M3" name="year4" value="M">����~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X3" name="year4" value="X">�褸�~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year4" value="B" checked="checked">����~���X</TD>
			<%}else{ %>
			<TD><input type="radio" id="M3" name="year4" value="M" >����~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X3" name="year4" value="X" checked="checked">�褸�~&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year4" value="B">����~���X</TD>
			<%} %>
		</TR>
		<TR>
			<TD>����O�_�����j�Ÿ�"/"*</TD>
			<%if("Y".equals(dto.getIsSlant())){ %>
			<TD><input type="radio" id="Y3" name="judge4" value="Y" checked="checked">�O&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="N3" name="judge4" value="N">�_</TD>
			<%}else{ %>
			<TD><input type="radio" id="Y3" name="judge4" value="Y">�O&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="N3" name="judge4" value="N" checked="checked">�_</TD>
			<%} %>
		</TR>
		<TR>
			<TD>������ƦC��:*</TD>
			<TD><input type="text" id="DNUM" name="DNUM" value="<%=dto.getDateIndex()%>" >
		</TR>
		<TR>
			<TD>������B��ƦC��:*</TD>
			<TD><input type="text" id="ANUM" name="ANUM" value="<%=dto.getFeeIndex()%>" >
		</TR>
		<TR>
			<TD>������B���զ����c(�h�ﶵ):*</TD>
			<TD>
				<%if("Y".equals(dto.getIsTwoNum())){ %>
				<input type="checkbox" id="O" name="amount4" value="DEC" checked="checked">���p��&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount4" value="DEC">���p��&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIsPoint())){ %>
				<input type="checkbox" id="O" name="amount4" value="OPT" checked="checked">�p���I&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount4" value="OPT">�p���I&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIsPermille())){ %>
				<input type="checkbox" id="O" name="amount4" value="TSN" checked="checked">�d����&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount4" value="TSN">�d����&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIsFristNum())){ %>
				<input type="checkbox" id="O" name="amount4" value="PNN" checked="checked">��1�X�����t��&nbsp;&nbsp;&nbsp;&nbsp;
				<%}else{ %>
				<input type="checkbox" id="O" name="amount4" value="PNN">��1�X�����t��&nbsp;&nbsp;&nbsp;&nbsp;
				<%} %>
				<%if("Y".equals(dto.getIslastNum())){ %>
				<input type="checkbox" id="O" name="amount4" value="RRS" checked="checked">�̫�1�X�t���Ϊť�
				<%}else{ %>
				<input type="checkbox" id="O" name="amount4" value="RRS">�̫�1�X�t���Ϊť�
				<%} %>
			</TD>
		</TR>
		<TR>
			<TD>�Ƶ��ƦC��:*</TD>
			<TD><input type="text" id="CNUM" name="CNUM" value="<%=dto.getConIndex() %>" >
		</TR>
	</TABLE>
</DIV>
<%} %>
<!-- ����������  �w��F �r������C ��������S-->
<input type="hidden" id="SPL"  name="SPL" value="" />
<!-- �������  �褸X  ����M -->
<input type="hidden" id="DTYPE" name="DTYPE" value="" /> 
<!-- ����O�_�׽u���j��  Y N-->
<input type="hidden" id="SLANT" name="SLANT" value="" /> 
<!-- �O�_�k�a����0 -->
<input type="hidden" id="LEFTZ" name="LEFTZ" value="N" /> 
<!-- �O�_�p���I -->
<input type="hidden" id="SPOT" name="SPOT" value="N" /> 
<!-- �O�_�p�ƨ�� -->
<input type="hidden" id="TPOT" name="TPOT" value="N" /> 
<!-- �O�_�d����-->
<input type="hidden" id="TSN" name="TSN" value="N" /> 
<!-- �O�_�k�a���ɪ� -->
<input type="hidden" id="LEFTS" name="LEFTS" value="N" /> 
<!-- �O�_�k��1�X�����t��-->
<input type="hidden" id="LEFTO" name="LEFTO" value="N" /> 
<!-- �O�_�̫�1�X�t���Ϊť�-->
<input type="hidden" id="RIGO" name="RIGO" value="N" />

<!-- �����ѼƳ]�w  -->
<input type="hidden" id="PAGETYPE" name="PAGETYPE" value="UP" />
<INPUT type="hidden" id="txtAction" name="txtAction" value="">   
<INPUT name="txtMsg" id="txtMsg"  type="hidden" value="<%=strMsg%>">

</FORM>
<BR>*�N����ﶵ�A���ର�ũΤ����<BR>
</BODY>
</HTML>
