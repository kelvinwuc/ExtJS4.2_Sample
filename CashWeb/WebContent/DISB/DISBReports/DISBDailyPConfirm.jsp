<!--DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"-->
<%@ page contentType="text/html;charset=BIG5" %>
<%@ page import="java.text.*" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<html>
<head>
<title>每日付款明細報表</title>
<meta http-equiv="Content-Type" content="text/html; charset=BIG5">
<style type="text/css">
<!--
div.tableContainer {
	width: 100%;		/* table width will be 99% of this*/
	height: 426px; 	/* must be greater than tbody*/
	overflow: auto;
	margin: 0 auto;
}

table>tbody	{  /* child selector syntax which IE6 and older do not support*/
	overflow: auto; 
	height: 430px;
	overflow-x: hidden;
}
	
thead tr	{
	position:relative; 
	top: expression(offsetParent.scrollTop); /*IE5+ only*/
}
	
thead td, thead th {
	text-align: center;
	font-size: 10px; 
	background-color: #d8d8d8;
	border-top: solid 1px #d8d8d8;
}	
.Message {  font-size: 9pt; text-decoration: none; BORDER:0; BACKGROUND-COLOR: Transparent ;BORDER-STYLE:Solid;}
-->
</style>
<script type="text/JavaScript">
<!--
function checkBoxChe(){
	var boxs = document.getElementsByName("PNO");
	var boxStr="";
	for(var i = 0 ; i < boxs.length ; i++){
		if(boxs[i].checked==true){
			boxStr+=boxs[i].value+",";
		}
	}
	if(boxStr.length>0)
		boxStr=boxStr.substr(0,boxStr.length-1);
	return boxStr;
}
	
function checkChild(name,chk){
	var list = document.getElementsByName(name);
	for(var i=0 ; i < list.length ; i++)
		list[i].checked = chk;
}

function chkup(){
	count = 0 ;
	for (var i = 0 ; i < document.getElementsByName("PNO").length ; i++){
  		if (document.getElementsByName("PNO")[i].checked){
  			var id = document.getElementsByName("PNO")[i].value ;
     		var pamt = document.getElementsByName("PAMT"+id)[0].value ;
     		var pmethod = document.getElementsByName("PMETHOD"+id)[0].value ;
     		var pdispatch = document.getElementsByName("PDISPATCH"+id)[0].value ;
     		if (document.getElementsByName("CHK"+id)[0]!= 'undefined'){
     			if (pmethod == 'A' && pdispatch == 'Y' && parseInt(pamt) < 1000000){
     				if (document.getElementsByName("CHK"+id)[0].value == ''){
     					alert("您尚未填寫支票號碼") ;
     					document.getElementsByName("CHK"+id)[0].focus();
  						return false ;
     				}else{
     					if (document.getElementsByName("CHK"+id)[0].value.indexOf('GA',0) == -1
     						&& document.getElementsByName("CHK"+id)[0].value.indexOf('GB',0) == -1){
     						alert("支票號碼輸入錯誤") ;
     						document.getElementsByName("CHK"+id)[0].focus();
  							return false ;
  						}
     				}
     			}
     		}
     		count++;
     	}
	}
	
	if (count < 1){
  		alert("您尚未選取任何付款項目") ;
  		return false ;
	}
	document.frmMain.submit() ; 
}
//-->
</script>
</head>
<body>
<%!String strThisProgId = "DISBPSourceConfirm"; //本程式代號%>
<%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar calendar  =commonUtil.getBizDateByRCalendar();
int iCurrentDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(calendar.getTime()));
String strSql = request.getParameter("ReportSQL");
String strFromBatch = request.getParameter("para_FromBatch");
String strDISPATCH = request.getParameter("para_DISPATCH");
String strEntryDate = request.getParameter("para_EntryDate")!=null?request.getParameter("para_EntryDate"):commonUtil.convertWesten2ROCDate1(calendar.getTime());
String strPDate = request.getParameter("para_PDate")!=null?request.getParameter("para_PDate"):commonUtil.convertWesten2ROCDate1(calendar.getTime());
String strReportName = request.getParameter("ReportName");
java.text.NumberFormat fmt = new java.text.DecimalFormat("0");	
DecimalFormat dfmt = new DecimalFormat("##,###,###,###,##0"); 			
Connection con = null;
ResultSet rs   = null;
Statement stmt = null;
int iRowProcessed = 1;
double t1 = 0.0 ;
try{
	con = dbFactory.getAS400Connection("DISBPSourceConfirm");
	System.out.println("QuerySql="+strSql);
	stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	rs = stmt.executeQuery(strSql);			
%>
	<FORM id="frmMain" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbreports.DISBDailyPRServlet" method="post">
	<input type="button" name="報表" value="報表" onClick="javascript:chkup();">
	<div class="tableContainer"> 
	<table border="1" cellPadding="1" cellSpacing="1" width="950" id="tblDetail">
		<thead>
			<TR>
				<TD height="36" width="30"><b><font size="2" face="細明體">序號</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="30"><b><font size="2" face="細明體"><input type="checkbox" class="icon_menu" onClick="checkChild('PNO',this.checked)" checked/></font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="60"><b><font size="2" face="細明體">承辦單位<br>承辦人員</font></b></TD>
			    <TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="64"><b><font size="2" face="細明體">保單號碼</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="78"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
				<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="69"><b><font size="2" face="細明體">支付金額</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="80"><b><font size="2" face="細明體">支付描述</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="64"><b><font size="2" face="細明體">付款日期</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="60"><b><font size="2" face="細明體">付款方式</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="60"><b><font size="2" face="細明體">銀行</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="60"><b><font size="2" face="細明體">銀行帳號<br>支票號碼</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="53"><b><font size="2" face="細明體">急件否</font></b></TD>
				<TD bgColor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="53"><b><font size="2" face="細明體">幣別</font></b></TD>
			</TR>
		 </thead>
		 <tbody>
			<%
			while(rs.next()){
				String strMethod = rs.getString("PAY_METHOD")!=null?rs.getString("PAY_METHOD").trim():"";
				if ("N".equals(strFromBatch)){
					if (rs.getInt("ENTRY_DATE") > Integer.parseInt(strEntryDate) && !"".equals(rs.getString("PAY_VOIDABLE"))) continue ;
				}else if (!"A".equals(strMethod) && "Y".equals(strFromBatch)){
					if (rs.getInt("PAY_DATE") > Integer.parseInt(strPDate)) continue ;
				}else if (!"A".equals(strMethod) && "N".equals(strFromBatch)){
					if (rs.getInt("PAY_DATE") != Integer.parseInt(strPDate)) continue ;
				}else if ("A".equals(strMethod) && ("BB".equals(rs.getString("PAY_SOURCE_CODE")) ||
												    "B8".equals(rs.getString("PAY_SOURCE_CODE")) ||
												    "B9".equals(rs.getString("PAY_SOURCE_CODE")) ||
												    "BI".equals(rs.getString("PAY_SOURCE_CODE")) ||
												    "BJ".equals(rs.getString("PAY_SOURCE_CODE"))) 
											    &&  "Y".equals(strFromBatch)){
					if (rs.getInt("PAY_DATE") > iCurrentDate) continue ;
				}else if ("A".equals(strMethod) && ("BB".equals(rs.getString("PAY_SOURCE_CODE")) ||
												    "B8".equals(rs.getString("PAY_SOURCE_CODE")) ||
												   	"B9".equals(rs.getString("PAY_SOURCE_CODE")) ||
												   	"BI".equals(rs.getString("PAY_SOURCE_CODE")) ||
												   	"BJ".equals(rs.getString("PAY_SOURCE_CODE"))) 
											    &&  "N".equals(strFromBatch)){ 
					if (rs.getInt("PAY_DATE") != Integer.parseInt(strPDate)) continue ;
				}else{ 
					if (rs.getInt("ENTRY_DATE") != Integer.parseInt(strEntryDate)) continue ;
				}
			%>
			<TR>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="30"><div class="message"><%=iRowProcessed%></div></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="30"><input type="checkbox" id="PNO" name="PNO" value="<%=rs.getString("PAY_NO")%>" CHECKED></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="60"><div class="message"><%=rs.getString("USERDEPT")%><br><%=rs.getString("ENTRY_USER")%></div></TD>
			    <TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="64"><INPUT type="text" readOnly name="POLICY<%=rs.getString("PAY_NO")%>" size=10 value="<%=rs.getString("POLICY_NO")%>" class=message></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="78"><div class="message"><%=rs.getString("PAY_NAME")%></div></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="69">
					<div class="message" align="right">
						<%=fmt.format(rs.getDouble("PAY_AMOUNT"))%>
					</div>
					<INPUT type="hidden" name="PAMT<%=rs.getString("PAY_NO")%>" value="<%=fmt.format(rs.getDouble("PAY_AMOUNT"))%>">
				</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="80"><div class="message"><%=rs.getString("PAY_DESCRIPTION")%></div></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="64"><INPUT type="text" readOnly name="PDATE<%=rs.getString("PAY_NO")%>" size=8 value="<%=rs.getInt("PAY_DATE")%>" class=message></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="60">
					<div class="message">
					<%
					if ("A".equals(strMethod))
						out.write("支票");
					else if ("B".equals(strMethod))
						out.write("銀行匯款");
					else if ("C".equals(strMethod))
						out.write("信用卡");
					else if ("D".equals(strMethod))
						out.write("外幣匯款");
					else if ("E".equals(strMethod))
						out.write("現金");
					else
						out.write(strMethod);
					%>
					</div>
					<INPUT type="hidden" name="PMETHOD<%=rs.getString("PAY_NO")%>" value="<%=strMethod%>">
				</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="60"><div class="message"><%=rs.getString("PAY_REMIT_BANK")!=null?rs.getString("PAY_REMIT_BANK")+"&nbsp;":"&nbsp;"%></div></TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="60">
					<%if ("A".equals(strMethod) && "Y".equals(rs.getString("PAY_DISPATCH").trim())){%>
						<input type="text" name="CHK<%=rs.getString("PAY_NO")%>" size="15">
					<%}else{%>
						<div class="message"><%=rs.getString("PAY_REMIT_ACCOUNT")!=null?rs.getString("PAY_REMIT_ACCOUNT"):"&nbsp;"%></div>
					<%}%>
					<INPUT type="hidden" name="RMTFEE<%=rs.getString("PAY_NO")%>" value="<%=fmt.format(rs.getDouble("REMIT_FEE"))%>">
				</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="53">
					<div class="message" align="center">
						<%="Y".equals(rs.getString("PAY_DISPATCH").trim())?"是":"否"%>
					</div>
					<INPUT type="hidden" name="PDISPATCH<%=rs.getString("PAY_NO")%>" value="<%=rs.getString("PAY_DISPATCH")%>">
					<INPUT type="hidden" name="DEPT<%=rs.getString("PAY_NO")%>" value="<%=rs.getString("PAY_DEPT")%>">
				</TD>
				<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="36" width="53"><div class="message" align="center"><%=rs.getString("PAY_CURRENCY")%></div></TD>
			</TR>	
			<%
				t1 = t1 + rs.getDouble("PAY_AMOUNT");
				iRowProcessed++ ;
			}%>
		</tbody>
	</table>
	</div>
	<table>
		<tr>
			<td align="left">
				<font size="3">
					總計：&nbsp;<b><font color="red"><%=iRowProcessed-1%></font>&nbsp;</b>(筆)，總金額：&nbsp;<b><font color="red"><%=dfmt.format(t1)%></font></b>
				</font>
			</td>
		</tr>
	</table>
	<INPUT type="hidden" id="action" name="action" value="DISBPSourceConfirm"> 
	<INPUT type="hidden" id="ReportName" name="ReportName" value="<%=strReportName%>"> 
	<INPUT type="hidden" id="ReportPath" name="ReportPath"	value="<%=globalEnviron.getRootPath()%>DISB\\DISBReports\\">
	<INPUT type="hidden" id="OutputType" name="OutputType" value="PDF"> 
	<INPUT type="hidden" id="para_EntryDate" name="para_EntryDate" value="<%=strEntryDate%>"> 
	<INPUT type="hidden" id="para_PDate" name="para_PDate" value="<%=strPDate%>"> 
	<INPUT type="hidden" id="para_FromBatch" name="para_FromBatch" value="<%=strFromBatch%>">
	<INPUT type="hidden" id="para_DISPATCH" name="para_DISPATCH" value="<%=strDISPATCH%>">
	<INPUT type="hidden" id="para_NextWorkDT" name="para_NextWorkDT" value="<%=iCurrentDate%>">
	</FORM>
<%
}catch(Exception ex){
	ex.printStackTrace();
}finally{
	if( rs != null )
        try{ rs.close(); }catch( Exception e ) {}
    if( stmt != null )
        try{ stmt.close(); }catch( Exception e ) {}
    if( con != null )
		try{ dbFactory.releaseAS400Connection(con); }catch( Exception e ) {}
}
%>
</body>
</html>