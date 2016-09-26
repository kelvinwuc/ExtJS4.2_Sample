<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.codeAttr.CodeAttr" %>
<%@ page import="com.aegon.codeAttr.RemittancePayRule" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : 匯款功能--整批匯款作業(確認)
 * 
 * Remark   : 出納功能-整批匯款
 * 
 * Revision : $Revision: 1.21 $
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $Date: 2014/08/25 02:16:25 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBRemitDisposeList.jsp,v $
 * Revision 1.21  2014/08/25 02:16:25  missteven
 * RC0036-3
 *
 * Revision 1.20  2014/07/18 07:31:02  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.19  2014/02/26 06:39:32  MISSALLY
 * EB0537 --- 新增萬泰銀行為外幣指定銀行
 *
 * Revision 1.18  2013/03/29 09:55:05  MISSALLY
 * RB0062 PA0047 - 新增指定銀行 彰化銀行
 *
 * Revision 1.17  2012/08/29 02:57:53  ODCKain
 * Calendar problem
 *
 * Revision 1.16  2012/05/18 10:07:42  MISSALLY
 * BUG-FIX 去除金額前的空白
 *
 * Revision 1.15  2011/11/08 09:16:39  MISSALLY
 * Q10312
 * 匯款功能-整批匯款作業
 * 1.修正銀行帳號不一致
 * 2.調整兆豐匯款檔
 *
 * Revision 1.14  2011/10/24 07:59:03  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 * FIX 出納確認日與支付確認日比對，支付確認日的前面增加帶空白
 *
 * Revision 1.13  2011/10/24 03:53:33  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 *
 * Revision 1.12  2011/10/21 10:04:38  MISSALLY
 * R10260---外幣傳統型保單生存金給付作業
 *
 * Revision 1.10  2008/08/18 06:16:30  MISODIN
 * R80338 調整銀行帳號選單的預設值
 *
 * Revision 1.9  2008/08/07 05:08:10  MISODIN
 * R80338 調整CASH系統 for 出納外幣一對一需求
 *
 * Revision 1.8  2008/08/06 07:07:02  MISODIN
 * R80338 調整CASH系統 for 出納外幣一對一需求
 *
 * Revision 1.7  2007/08/03 10:12:22  MISODIN
 * R70477 外幣保單匯款手續費
 *
 * Revision 1.6  2007/03/06 01:49:55  MISVANESSA
 * R70088_SPUL配息抓取全名支付銀行並帶入
 *
 * Revision 1.5  2006/12/07 22:00:57  miselsa
 * R60463及R60550外幣及SPUL保單
 *
 * Revision 1.4  2006/11/29 08:07:41  miselsa
 * R60463及R60550外幣及SPUL保單
 *
 * Revision 1.3  2006/09/25 06:36:15  miselsa
 * R60747處理畫面上加總金額Nan的問題
 *
 * Revision 1.2  2006/09/04 09:47:07  miselsa
 * R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 *
 * Revision 1.1  2006/06/29 09:39:46  MISangel
 * Init Project
 *
 * Revision 1.1.2.5  2006/04/27 09:41:44  misangel
 * R50891:VA美元保單-顯示幣別
 *
 * Revision 1.1.2.4  2005/04/18 08:54:28  MISANGEL
 * R30530:支付系統
 *
 * Revision 1.1.2.3  2005/04/04 07:02:25  miselsa
 * R30530 支付系統
 *  
 */
%><%! String strThisProgId = "DISBRemitDispose"; //本程式代號 %><%
DecimalFormat df = new DecimalFormat("#.00");
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

List alPBBankD = new ArrayList(); //R70477
List alPBBankP = new ArrayList(); //R80338
List alPBBankFR = new ArrayList();

if (session.getAttribute("PBBankListD") == null) {
	//R00386 - 配息 
	//if ("B01T01F".equals(request.getAttribute("payRule")!=null?(String)request.getAttribute("payRule"):"")){
		alPBBankD = (List) disbBean.getETable("PBKAT", "BANKDC");
	//}else if ("B01T01B".equals(request.getAttribute("payRule")!=null?(String)request.getAttribute("payRule"):"")){ //非配息
	//	Hashtable htETtable = new Hashtable();
	//	htETtable.put("ETType","PBKAT");
	//	htETtable.put("ETValue","8220635/635131008304");
	//	htETtable.put("ETVDesc","中信銀復興 ");
	//	alPBBankD.add(htETtable);
	//}else{
	//	alPBBankD.addAll( disbBean.getETable("BNKPR", "BANKPR") );	// R00386, 加入傳統型美元保單用的匯款銀行
	//}
	session.setAttribute("PBBankListD",alPBBankD);
} else {
	alPBBankD =(List) session.getAttribute("PBBankListD");
}
// R80338
if (session.getAttribute("PBBankListP") == null) {
	alPBBankP = (List) disbBean.getETable("PBKAT", "BANKP");
	session.setAttribute("PBBankListP",alPBBankP);
} else {
	alPBBankP =(List) session.getAttribute("PBBankListP");
}

if (session.getAttribute("fcTriBankCodeList") == null) {
	alPBBankFR = (List) disbBean.getETable("BNKFR", "BANKFRC");
	session.setAttribute("fcTriBankCodeList", alPBBankFR );
} else {
	alPBBankFR = (List) session.getAttribute("fcTriBankCodeList");
}

double total = 0;
List vo = (List)request.getAttribute("vo");
int count = (vo == null?0:vo.size());

Hashtable htTemp = null;
String strValue = null;
String strDesc = null;


StringBuffer sbBankCode = new StringBuffer();
if(request.getAttribute("PMETHOD").equals("B")) 
{	   
	if(request.getAttribute("pDispatch").equals("Y")) {//RC0036 
       sbBankCode.append("<option value=\"8120610/06120001666600\">8120610/06120001666600-台新西門</option>");//RC0036
    }else{//RC0036
	   sbBankCode.append("<option value=\"8220635/635530015707\">8220635/635530015707-中信銀復興</option>");
	}                                              //RC0036 
	if (alPBBankP.size() > 0) {
		for (int i = 0; i < alPBBankP.size(); i++) {
			htTemp = (Hashtable) alPBBankP.get(i);
			strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
			strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));
			if(strValue.equals(request.getAttribute("SELPRBank")))
				sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
			else
				sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
		}
	} else {  
		sbBankCode.append("<option value=\"\">&nbsp;</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
else if(request.getAttribute("PMETHOD").equals("D"))
{
	sbBankCode.append("<option value=\"\">&nbsp;</option>");

	if (alPBBankD != null && alPBBankD.size() > 0) {
		for (int i = 0; i < alPBBankD.size(); i++) {
			htTemp = (Hashtable) alPBBankD.get(i);
			strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
			strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));
			if(strValue.equals(request.getAttribute("SELPRBank")))
				sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
			else
				sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
		}
	}

	htTemp = null;
	strValue = null;
	strDesc = null;

	if (alPBBankFR != null && alPBBankFR.size() > 0) {
		for (int i = 0; i < alPBBankFR.size(); i++) {
			htTemp = (Hashtable) alPBBankFR.get(i);
			strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
			strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));
			if(strValue.equals(request.getAttribute("SELPRBank")))
				sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
			else
				sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
		}
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
else 
{
	if (alPBBankP.size() > 0) {
    	for (int i = 0; i < alPBBankP.size(); i++) {
			htTemp = (Hashtable) alPBBankP.get(i);
			strValue = CommonUtil.AllTrim((String) htTemp.get("ETValue"));
			strDesc = CommonUtil.AllTrim((String) htTemp.get("ETVDesc"));
			if(strValue.equals(request.getAttribute("SELPRBank")))
				sbBankCode.append("<option value=\"").append(strValue).append("\" selected=\"selected\">").append(strValue).append("-").append(strDesc).append("</option>");
			else
				sbBankCode.append("<option value=\"").append(strValue).append("\">").append(strValue).append("-").append(strDesc).append("</option>");
		}
	} else {
		sbBankCode.append("<option value=\"\">&nbsp;</option>");
	}

	htTemp = null;
	strValue = null;
	strDesc = null;
}
%>

<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>匯款功能--整批匯款作業</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<SCRIPT language="JavaScript">
<!--
// *************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值     :	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' );
	window.status = "";
}

function DISBRemitAction()
{
    WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyRemitL,'' );
}

function confirmAction()
{
	mapValue();
	if(checkField()){
		document.frmMain.submit();
	}
}

function resetAction()
{
	alert("yes, u just click the reset button,\n but i didnt done it yet");
}

function exitAction()
{
	history.back(-1);
}

/**
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function checkField()
{
	var bReturnStatus = false;
	var strTmpMsg = "";
	if(document.getElementById("txtPCSHCMC").value=="")
	{
	   alert( "請輸入出納確認日!" );
	   return bReturnStatus;
	}
	<%if (request.getAttribute("PMETHOD").equals("B") &&
		      request.getAttribute("pDispatch").equals("Y") &&
		      request.getAttribute("selCurrency").equals("NT")){%>
	if(document.getElementById("txtCHKNO").value=="")
	{
	   alert( "請輸入支票號碼!" );
	   return bReturnStatus;
	}
	<%}%>
	var chk = document.getElementsByName("PNO");
	for(var index = 0; index<chk.length; index++){
		if(chk[index].checked){
			bReturnStatus = true;
			break;
		}
	}
	if(!bReturnStatus){
		alert( "請勾選欲匯款的保單!" );
	}
	
	// 加入出納確認日的判斷
	bReturnStatus = checkPayDate();
	
	return bReturnStatus;
}

// R00386
function checkPayDate() 
{
	// 這是針對外幣匯款而做的檢查
	var payMethod = document.getElementById( "PMETHOD" ).value;
	if( payMethod != "D" )
		return true;
	
	// 比較出納確認日與支付確認日
	var chk = document.getElementsByName("PNO");
	var index, seqNo;
	var hightlight;
	var warnCount = 0;
	var errorMsg = "";
	var tooManyErrMsg = "";
	var payDateStr = document.getElementById( "txtPCSHCMC" ).value;	// 表單上輸入的出納確認日
	var payDate = parseInt( payDateStr.replace( /[/]/g, "" ), 10 );
	// 挑選有打勾的來比較
	for( index = 0; index < chk.length; index++ )
	{
		seqNo = index + 1;
		hightlight = false;

		if( chk[index].checked ){
			var checkedPayDate = document.getElementById( "CheckedPayDate_" + seqNo ).innerHTML;
			if( payDate != checkedPayDate ) {
				warnCount++;
				hightlight = true;
				if( warnCount > 10 )
					tooManyErrMsg = "\n    (超過顯示上限，本列表至多顯示 10 筆資料，其餘部份請直接由資料表中查詢)";
				else
					errorMsg += ( "\n    ● 第 " + seqNo + " 筆, 出納確認日應為 " + checkedPayDate );
			}
		}

		var currentRow = document.getElementById( "dataRow_" + seqNo );
		if( hightlight )
			currentRow.style.background = "yellow";
		else
			currentRow.style.background = "";
	}

	if( warnCount == 0 )
		return true;

	errorMsg += tooManyErrMsg;
	errorMsg += "\n\n是否仍要執行整批匯款";
	errorMsg += "\n    『是』將出納確認日寫支付資料";
	errorMsg += "\n    『否』不將出納確認日寫支付資料";
	errorMsg = ( "WARNING!!! 檢核出納確認日共有 " + warnCount + " 筆不符合 (以黃底色標記)，內容如下：\n" ) + errorMsg;
	return confirm( errorMsg );
}

function calculateAmt()
{
	var amt = 0.00;
	var count = 0;
	var t1 = document.all("tbl").childNodes[0];

	var chk = document.getElementsByName("PNO");
	for(var index=0; index<chk.length ; index++ ){
		if(chk[index].checked){
			count = count+1;
			amt = amt + parseFloat(t1.rows[index+1].cells[6].innerHTML.substr(3));
		}
	}

	var t2 = document.all("tbl2").childNodes[0];
	t2.rows[0].cells[1].innerHTML = count;
	t2.rows[0].cells[5].innerHTML = amt;
}

function mapValue()
{
	document.getElementById("txtPCSHCM").value = rocDate2String(document.getElementById("txtPCSHCMC").value);
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitDisposeServlet?action=update" id="frmMain" method="post" name="frmMain">
<INPUT type="hidden" id="txtPaySeq" name="txtPaySeq" value=""> 
<INPUT type="hidden" id="txtAction" name="txtAction" value=""> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="">
<INPUT type="hidden" id="PMETHOD" name="PMETHOD" value="<%=request.getAttribute("PMETHOD")%>">
<INPUT type="hidden" id="pDispatch" name="pDispatch" value="<%=request.getAttribute("pDispatch")%>"> <!-- RC0036 -->
<% if(vo.size() > 0){ %>
<TABLE border="1" width="452">
	</TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="101">出納確認日：</TD>
			<TD>
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCSHCMC" name="txtPCSHCMC" value="" >
				<a href="javascript:show_calendar('frmMain.txtPCSHCMC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a>
				<INPUT type="hidden" name="txtPCSHCM" id="txtPCSHCM" value=""> 
			</TD>
		</TR>
		 <TR>
			<TD align="right" class="TableHeading" width="101">付款帳號：</TD>
			<TD width="333">
				<select size="1" name="PBBANK" id="PBBANK" class="Data">
					<%=sbBankCode.toString()%>
				</select>
			</TD>
		</TR>
		<%if (request.getAttribute("PMETHOD").equals("B") &&
		      request.getAttribute("pDispatch").equals("Y") &&
		      request.getAttribute("selCurrency").equals("NT")){%>
		<TR>
			<TD align="right" class="TableHeading" width="101">支票號碼：</TD>
			<TD width="333">
				<input type="text" name="txtCHKNO" size="15"/>
			</TD>
		</TR>
		<%}%>	
	</TBODY>
</TABLE>
<br>
<TABLE id="tbl" border="0" cellpadding="0" cellspacing="0" width="850">
	<TBODY>
		<TR>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><B><FONT size="2" face="細明體">序號</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="25"><B><FONT size="2" face="細明體">勾選</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="64"><B><FONT size="2" face="細明體">保單號碼</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="68"><B><FONT size="2" face="細明體">要保書號碼</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="77"><B><FONT size="2" face="細明體">受款人姓名</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="71"><B><FONT size="2" face="細明體">受款人ID</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="82"><B><FONT size="2" face="細明體">支付金額</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="67"><B><FONT size="2" face="細明體">付款內容</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="75"><B><FONT size="2" face="細明體">付款日期</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="70"><B><FONT size="2" face="細明體">付款方式</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="65"><B><FONT size="2" face="細明體">急件否</FONT></B></TD>
<%	if(request.getAttribute("PMETHOD").equals("D") && request.getAttribute("SYMBOL").equals("S")) { %>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="82"><B><FONT size="2" face="細明體">外幣金額</FONT></B></TD>
			<TD bgcolor="#c0c0c0" style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="56" width="82"><B><FONT size="2" face="細明體">測試欄位</FONT></B></TD>
<%	} %>	
		</TR>
<%	DISBPaymentDetailVO paymentDetail = null;
	String strPayMethodCode = "";
	String strPayMethodDesc = "";
	for(int index = 0 ; index < vo.size() ; index++) {
		paymentDetail = (DISBPaymentDetailVO)vo.get(index);
		total += paymentDetail.getIPAMT();
	
		strPayMethodCode = CommonUtil.AllTrim(paymentDetail.getStrPMethod());
		if("A".equals(strPayMethodCode)) {
			strPayMethodDesc = "支票";
		} else if("B".equals(strPayMethodCode)) {
			strPayMethodDesc = "匯款";					
		} else if("C".equals(strPayMethodCode)) {
			strPayMethodDesc = "信用卡";					
		} else if("D".equals(strPayMethodCode)) {
			strPayMethodDesc = "國外匯款";					
		} %>
		<TR id="dataRow_<%=index+1%>" >
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><%=index+1%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="25"><INPUT type="checkbox" checked name="PNO" id="PNO" value="<%=paymentDetail.getStrPNO()%>" onClick="calculateAmt();"></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="64">&nbsp;<%=paymentDetail.getStrPolicyNo()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="68">&nbsp;<%=paymentDetail.getStrAppNo()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="77">&nbsp;<%=paymentDetail.getStrPName()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="71">&nbsp;<%=paymentDetail.getStrPId()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="82" id="PAMT"><%=paymentDetail.getStrPCurr()%><%=df.format(paymentDetail.getIPAMT())%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="67">&nbsp;<%=paymentDetail.getStrPDesc()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="58">&nbsp;<%=paymentDetail.getIPDate()%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="70">&nbsp;<%=strPayMethodDesc%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="65">&nbsp;<%=("Y".equals(paymentDetail.getStrPDispatch())?"是":"否")%></TD>
<%		if(request.getAttribute("PMETHOD").equals("D") && request.getAttribute("SYMBOL").equals("S")) { %>			
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="82"><%=paymentDetail.getStrPPAYCURR()%><%=df.format(paymentDetail.getIPPAYAMT())%></TD>
			<TD style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid" height="35" width="82"><span id="CheckedPayDate_<%= index + 1 %>"><%=paymentDetail.getCheckedPayDate() %></span></TD>
<%		} %>	
		</TR>
<%	} %>
	</TBODY>
</TABLE>
<BR>
<table id="tbl2">
	<tr><td>總件數 :  </td><td><%=count %></td><td></td><td></td><td>總金額 : </td><td><%=df.format(total)%></td></tr>
</table>
<% } %>

<input type="hidden" id="PMETHOD" name="PMETHOD" value="<%=request.getAttribute( "PMETHOD" )%>">
</FORM>
</BODY>
</HTML>