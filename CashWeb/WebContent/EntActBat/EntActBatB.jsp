<%@ page language="java" contentType="text/html; charset=BIG5"  pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
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
 * $Log: EntActBatB.jsp,v $
 * Revision 1.2  2013/12/24 04:02:15  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */
%><%! String strThisProgId = "EntActBatB"; //本程式代號 %><% 
String strMsg = (request.getAttribute("txtMsg") == null)?"":(String)request.getAttribute("txtMsg");
%>
<html>
<head>
<title>銀行上傳登帳檔定義格式</title>
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
	if(document.getElementById("txtMsg").value!="") {
		alert(document.getElementById("txtMsg").value);
	}

	WindowOnLoadCommon(document.title , '' , strFunctionKeyAdd, '');
}

function defineValue() 
{
	var res = document.getElementById("fileType").value;
	if(res == "C") {
		document.getElementById("txt1").style.display = "none";
		document.getElementById("txt3").style.display = "none";
		document.getElementById("txt2").style.display = "";
		document.getElementById("txt4").style.display = "";
		document.getElementById("coa").checked = "checked";
		document.getElementById("M4").checked = "checked";
	    document.getElementById("N4").checked = "checked";
	} else {
		document.getElementById("txt1").style.display = "";
		document.getElementById("txt3").style.display = "";
		document.getElementById("txt2").style.display = "none";
		document.getElementById("txt4").style.display = "none";
		document.getElementById("fix").checked = "checked";
		document.getElementById("M3").checked ="checked";
		document.getElementById("N3").checked ="checked";
	}
}

function check(res)
{
	if(res == "F") {
		document.getElementById("txt1").style.display = "";
		document.getElementById("txt3").style.display = "";
		document.getElementById("txt2").style.display = "none";
		document.getElementById("txt4").style.display = "none";
		document.getElementById("M3").checked = "checked";
		document.getElementById("N3").checked = "checked";
	} else {
		document.getElementById("txt1").style.display = "";
		document.getElementById("txt3").style.display = "none";
		document.getElementById("txt2").style.display = "none";
		document.getElementById("txt4").style.display = "";
		document.getElementById("M4").checked = "checked";
		document.getElementById("N4").checked = "checked";
	}
}

function resetAction()
{
	document.forms("frmMain").reset();
}

function saveAction()
{
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
	for(var i = 0;i < ftype.length; i++) {
		if(ftype[i].checked == true) {
			radio = ftype[i].value;
			document.getElementById("SPL").value = radio;
		}
	}
	if(code == "") {
		alert("銀行代碼不能為空");
	} else {
		if(radio == "F"){
			if(sDate == "" || eDate =="") {
				alert("日期起迄欄位不能位空");
			} else {
				if(sAmount =="" || eAmount =="") {
					alert("交易金額起迄欄位不能位空");
				} else {
					AssignmentHidden(radio);
					document.frmMain.submit();
				}
			}
		} else {
			if(speNum == "") {
				alert("分隔欄位數不能位空");
			} else {
				if(dNum == "") {
					alert("日期欄位排列位不能為空");
				} else {
					if(aNum =="") {
						alert("交易金額排列位不能為空");
					} else {
						if(cNum =="") {
							alert("備註排列位不能為空");
						} else {
							AssignmentHidden(radio);
							document.frmMain.submit();
						}
					}
				}
			}
		}
	}
}

function AssignmentHidden(sel)
{
	if(sel == "F") {
		//取得選擇日期類型值 賦值給隱藏於
		var ytype = document.getElementsByName("year3");
		for(var i =0;i<ytype.length;i++){
			if(ytype[i].checked == true){
				document.getElementById("DTYPE").value =ytype[i].value;
			}
		}
		//取得選擇日期是否存在分割符值 賦值給隱藏於
		var jtype = document.getElementsByName("judge3");
		for(var i =0;i<jtype.length;i++){
			if(jtype[i].checked == true){
				document.getElementById("SLANT").value =jtype[i].value;
			}
		}
		//取得金融交易金額組成類型 賦值給隱藏於
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
		//取得選擇日期類型值 賦值給隱藏於
		var ytype = document.getElementsByName("year4");
		for(var i =0;i<ytype.length;i++){
			if(ytype[i].checked == true){
				document.getElementById("DTYPE").value =ytype[i].value;
			}
		}
		//取得選擇日期是否存在分割符值 賦值給隱藏於amount4
		var jtype = document.getElementsByName("judge4");
		for(var i =0;i<jtype.length;i++){
			if(jtype[i].checked == true){
				document.getElementById("SLANT").value =jtype[i].value;
			}
		}
		//取得選擇日期是否存在分割符值 賦值給隱藏於
		var atype = document.getElementsByName("amount4");
		for(var i =0;i<atype.length;i++){
			if(atype[i].checked == true){
				document.getElementById("TSN").value =atype[i].value;
			}
		}
	}
}

function exitAction()
{
	document.getElementById("PAGETYPE").value ="";
	window.location.href = "<%=request.getContextPath()%>/EntActBat/EntActBatTemplate.jsp";
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
			<TD>金融簡碼:*</TD>
			<TD><input type="text" id="bkCode" name="bkCode"></TD>
		</TR>
		<TR>
			<TD>上傳登帳文檔類型:*</TD>
			<TD>
				<select id="fileType"  name="fileType" onchange="defineValue();">
					<option value="T">TXT</option>
					<option value="C">CSV</option>
					<option value="F">FLT</option>
					<option value="D">DAT</option>
				</select>
			</TD>
		</TR>
	</TABLE>
</DIV>
<DIV id="txt1">
	<TABLE>
		<TR>
			<TD>分割文檔方式:*</TD>
			<TD><input type="radio"  id ="fix" name="g" value="F"  checked="checked" onchange="check('F')">取定長&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="sem" name="g" value="S" onchange="check('S')">;分隔</TD>
		</TR>
	</TABLE>
</DIV>
<DIV id="txt2"  style="display:none;">
	<TABLE>
		<TR>
			<TD>分割文檔方式:*</TD>
			<TD><input type="radio" id="coa" name="g" value="C" >,分隔</TD>
		</TR>
	</TABLE>
</DIV>
<DIV id="txt3">
	<TABLE >
		<TR>
			<TD>日期欄位:*</TD>
			<TD>起位:<input  type="text" id="dsnum" name="dsnum">——迄位<input type="text" id="denum" name="denum"></TD>
		</TR>
		<TR>
			<TD>日期欄位格式:*</TD>
			<TD><input type="radio" id="M3" name="year3" value="M" checked="checked">民國年&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X3" name="year3" value="X">西元年&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year3" value="B">民國年後兩碼</TD>
		</TR>
		<TR>
			<TD>日期是否有分隔符號"/"*</TD>
			<TD><input type="radio" id="N3" name="judge3" value="N" checked="checked">否&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="Y3" name="judge3" value="Y">是</TD>
		</TR>
		<TR>
			<TD>交易金額欄位:*</TD>
			<TD>起位:<input  type="text" id="asnum" name="asnum">——迄位<input type="text" id="aenum" name="aenum"></TD>
		</TR>
		<TR>
			<TD>交易金額欄位組成結構(多選項):*</TD>
			<TD>
				<input type="checkbox" id="O" name="amount" value="LRO">右靠左補0&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="O" name="amount" value="DEC">兩位小數&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" id="O" name="amount" value="OPT">小數點&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="O" name="amount" value="TSN">千分號&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" id="O" name="amount" value="LRS">右靠左補空&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="O" name="amount" value="PNN">第1碼為正負號&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="checkbox" id="O" name="amount" value="RRS">最後1碼負號或空白
			</TD>
		</TR>
		<TR>
			<TD>備註欄位:*</TD>
			<TD>起位:<input  type="text" id="csnum" name="csnum">——迄位<input type="text" id="cenum" name="cenum"></TD>
		</TR>
	</TABLE>
</DIV>
<DIV id="txt4" style="display:none;"  >
	<TABLE >
		<TR>
			<TD>分隔欄位數:*</TD>
			<TD><input  type="text" id="SPLNUM" name="SPLNUM"></TD>
		</TR>
		<TR>
			<TD>日期欄位格式:*</TD>
			<TD><input type="radio" id="M4" name="year4" value="M" checked="checked">民國年&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="X4" name="year4" value="X">西元年&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="B3" name="year3" value="B">民國年後兩碼</TD>
		</TR>
		<TR>
			<TD>日期是否有分隔符號"/":*</TD>
			<TD><input type="radio" id="N4" name="judge4" value="N" checked="checked">否&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="Y4" name="judge4" value="Y">是</TD>
		</TR>
		<TR>
			<TD>日期欄位排列位:*</TD>
			<TD><input type="text" id="DNUM" name="DNUM" value="" >
		</TR>
		<TR>
			<TD>交易金額位排列位:*</TD>
			<TD><input type="text" id="ANUM" name="ANUM" value="" >
		</TR>
		<TR>
			<TD>交易金額欄位有千分號:</TD>
			<TD><input type="radio" id="Y" name="amount4" value="Y">是&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" id="N" name="amount4" value="N">否</TD>
		</TR>
		<TR>
			<TD>備註排列位:*</TD>
			<TD><input type="text" id="CNUM" name="CNUM" value="" >
		</TR>
	</TABLE>
</DIV>
<!-- 文件分割類型  定長F 逗號分割C 分號分割S-->
<input type="hidden" id="SPL"  name="SPL" value="" />
<!-- 時間類型  西元X  民國M -->
<input type="hidden" id="DTYPE" name="DTYPE" value="" /> 
<!-- 時間是否斜杠分隔符  Y N-->
<input type="hidden" id="SLANT" name="SLANT" value="" /> 
<!-- 是否右靠左補0 -->
<input type="hidden" id="LEFTZ" name="LEFTZ" value="N" /> 
<!-- 是否小數點 -->
<input type="hidden" id="SPOT" name="SPOT" value="N" /> 
<!-- 是否小數兩位 -->
<input type="hidden" id="TPOT" name="TPOT" value="N" /> 
<!-- 是否千分號-->
<input type="hidden" id="TSN" name="TSN" value="N" /> 
<!-- 是否右靠左補空 -->
<input type="hidden" id="LEFTS" name="LEFTS" value="N" /> 
<!-- 是否右第1碼為正負號-->
<input type="hidden" id="LEFTO" name="LEFTO" value="N" /> 
<!-- 是否最後1碼負號或空白-->
<input type="hidden" id="RIGO" name="RIGO" value="N" />
<!-- 頁面參數設定  -->
<input type="hidden" id="PAGETYPE" name="PAGETYPE" value="IN" />
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
               
</FORM>
<BR>*代表必填選項，不能為空或不選擇<BR>
</BODY>
</HTML>
