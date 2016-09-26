<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%!
/**
 * System   : CashWeb
 * 
 * Function : 後收手續費->輸入維護
 * 
 * Remark   : 出納功能
 * 
 * Revision : $Revision: 1.14 $
 * 
 * Author   : Vanessa Liao
 * 
 * Create Date: $Date: 2013/12/24 03:50:11 $
 * 
 * Request ID : R60550
 * 
 * CVS History:
 * 
 * $Log: DISBRemitBackFee.jsp,v $
 * Revision 1.14  2013/12/24 03:50:11  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.7.4.1  2012/08/31 01:21:31  MISSALLY
 * RA0140---新增兆豐為外幣指定行
 *
 * Revision 1.7  2010/11/23 02:39:10  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.6  2008/08/06 07:04:52  MISODIN
 * R80338 調整CASH系統 for 出納外幣一對一需求
 *
 * Revision 1.5  2007/01/09 03:44:02  MISVANESSA
 * R60550_後收手續費修改
 *
 * Revision 1.4  2007/01/08 11:22:30  MISVANESSA
 * R60550_後收手續費修改
 *
 * Revision 1.3  2007/01/05 10:09:08  MISVANESSA
 * R60550_修改後不再提供修改
 *
 * Revision 1.2  2007/01/04 03:25:36  MISVANESSA
 * R60550_抓取方式修改
 *
 * Revision 1.1  2006/11/30 09:13:21  MISVANESSA
 * R60550_配合SPUL&外幣付款修改
 *
 */
%><%!String strThisProgId = "DISBRemitBackFee"; //本程式代號%><%
GlobalEnviron globalEnviron = (GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);

String strAction = (request.getAttribute("txtAction") != null)? (String) request.getAttribute("txtAction") : "";
String strReturnMessage = (request.getAttribute("txtMsg") != null) ? (String) request.getAttribute("txtMsg") : "";

//R80132 幣別挑選
List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") == null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
//R80132 END
Hashtable htTemp = null;
String strValue = null;
StringBuffer sbCurrCash = new StringBuffer();
sbCurrCash.append("<option value=\"\">&nbsp;</option>");
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
	}

	htTemp = null;
	strValue = null;
}
%>
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<TITLE>出納功能--後收手續費輸入作業</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
// *************************************************************
/*
函數名稱:	WindowOnLoad()
函數功能:	當前端程式開始時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value);
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitBackFee.jsp";
	}

	if (document.getElementById("txtAction").value == "")
	{
		document.getElementById("inquiryArea").style.display = "block";
		WindowOnLoadCommon( document.title, '', strDISBFunctionKeyInitial, '' );
		window.status = "";
	}
	else
	{
		WindowOnLoadCommon( document.title, '', strDISBFunctionKeySourceU, '' );
		window.status = "";
	}
}

/*
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之[離開]按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBRemit/DISBRemitBackFee.jsp?";
}

/*
函數名稱:	inquiryAction()
函數功能:	當toolbar frame 中之查詢鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function inquiryAction()
{
	// 查詢是不要求一定要有支付確認日, 但如果有輸入必需符合格式
	if( document.getElementById( "txtPCSHCMC" ).value != "" ) {
		var valid = checkClientField( document.getElementById( "txtPCSHCMC" ), true  );
		if( !valid )
			return;
	}

	/*	執行 QueryFrameSet.jsp 時,各 QueryString 參數之意義
			RowPerPage		: 每一頁有幾列
			Heading			: 表頭欄位名稱,以逗號','分開每一欄位
			DisplayFields	: 要顯示之資料庫欄位名稱,以逗號分開每一欄位,與Heading相對應
			ReturnFields	: 傳回哪些欄位之值,以逗號分開每一欄位
			Sql				: 待執行之SQL,亦可加入where條件
			TableWidth		: 整個Table之寬度
	
	 modalDialog 會傳回使用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開
	*/
	mapValue()
 	var strSql = "";
	strSql = "select CAST(A.RPAYMIDDT AS CHAR(7)) AS RPAYMIDDT,A.RPAYMIDFEE,A.RPAYMIDCUR,A.PACCT,A.RACCT,A.RNAME,A.RPAYCURR,";
	strSql += " A.RPAYAMT,A.RPAYFEEWAY,A.RMTDT,A.BATNO,A.SEQNO,CAST(B.PCSHCM AS CHAR(7)) AS PCSHCM,RPCURR";		
	strSql += " from CAPRMTF A ";
	strSql += " left outer join (SELECT DISTINCT PBATNO,BATSEQ,PCSHCM,PMETHOD FROM CAPPAYF) B on A.BATNO=B.PBATNO AND A.SEQNO = B.BATSEQ ";
	strSql += " WHERE B.PMETHOD = 'D' ";

	if( document.getElementById("txtInqPCSHCM").value != "" ) {
		strSql += " AND B.PCSHCM = " + document.getElementById("txtInqPCSHCM").value;
	}

	if( document.getElementById("txtInqRName").value != "" ){
		strSql += " AND A.RNAME like '^" +  document.getElementById("txtInqRName").value + "^' ";
	}

	if( document.getElementById("txtInqRENGName").value != "" ){
		strSql += " AND A.RENGNAME like '^" +  document.getElementById("txtInqRENGName").value + "^' ";
	}

	if( document.getElementById("txtInqRAcct").value != "" ) {
		strSql += " AND A.RACCT = '" + document.getElementById("txtInqRAcct").value + "' ";
	}

	if( document.getElementById("selCurrency").value != "" ) {
		strSql += " AND A.RPAYCURR = '" + document.getElementById("selCurrency").value + "' ";
	}

	//R80338
	if( document.getElementById("selPOCurr").value != "" ) {   
		strSql += " AND A.RPCURR = '" + document.getElementById("selPOCurr").value + "' ";
	}

	var strQueryString = "?RowPerPage=20&Sql="+strSql+"&TableWidth=820";
<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	session.setAttribute("Heading","匯款批號,付款帳號,受款人,受款人帳號,匯出幣別,外幣匯款金額,出納確認日,後收手續費日期,保單幣別");
	session.setAttribute("DisplayFields", "BATNO,PACCT,RACCT,RNAME,RPAYCURR,RPAYAMT,PCSHCM,RPAYMIDDT,RPCURR");
	session.setAttribute("ReturnFields", "RPAYMIDDT,RPAYMIDFEE,RPAYMIDCUR,PACCT,RACCT,RNAME,RPAYCURR,RPAYAMT,RPAYFEEWAY,RMTDT,BATNO,SEQNO,RPCURR");
%>
	var strReturnValue = window.showModalDialog( "<%=request.getContextPath()%>/CommonQuery/QueryFrameSet.jsp"+strQueryString , "" , "dialogWidth:550px;dialogHeight:600px;center:yes" );

	if( strReturnValue != "" )
	{
		var returnArray = string2Array(strReturnValue,",");

		if( returnArray[0] == "0")
		{
			document.getElementById("txtMFEEDT").value = "";
			document.getElementById("txtMFEEDTC").value = "";
		}
		else
		{
			document.getElementById("txtMFEEDT").value = returnArray[0];
			document.getElementById("txtMFEEDTC").value = string2RocDate(returnArray[0]);
		}
		document.getElementById("txtMFEEAMT").value = returnArray[1];

		if (returnArray[2]=="")
			returnArray[2]="NT";

		document.getElementById("selMFEECURR").value = returnArray[2];
		document.getElementById("txtPACCT").value = returnArray[3];
		document.getElementById("txtRACCT").value = returnArray[4];
		document.getElementById("txtRNAME").value = returnArray[5];			
		document.getElementById("txtRPAYCURR").value = returnArray[6];	
		document.getElementById("txtRPAYAMT").value = returnArray[7];	
		document.getElementById("txtPFEEWAY").value = returnArray[8];
		document.getElementById("txtRMTDT").value = returnArray[9];	
		document.getElementById("txtBATNO").value = returnArray[10];	
		document.getElementById("txtSEQNO").value = returnArray[11];	
		document.getElementById("txtPOCurr").value = returnArray[12];	  //R80338			

		document.getElementById("txtAction").value = "I";

		if (returnArray[8]=="BEN")
			document.getElementById("BENshow").style.display = "block"; 
		else
			document.getElementById("BENshow").style.display = "none"; 
		//如果已KEY後收手續費後,則不再提供修改				
		if (returnArray[1]>0)
			WindowOnLoadCommon( document.title, '', strDISBFunctionKeyExit, '' );
		else
			WindowOnLoadCommon( document.title, '', strDISBFunctionKeySourceU, '' );

		document.getElementById("updateArea").style.display = "block";
		document.getElementById("inquiryArea").style.display = "none"; 
	}
}

/*
函數名稱:	updateAction()
函數功能:	當toolbar frame 中之修改按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function updateAction()
{
	window.status = "";
	winToolBar.ShowButton( strFunctionKeyUpdate );

	disableKey();
	enableData();

	document.getElementById("txtAction").value = "U";
  	document.getElementById("imgShow").style.display = "block";
	document.getElementById("txtMFEEDTC").className = "Data";
	document.getElementById("txtMFEEAMT").className = "Data";
	document.getElementById("txtMFEEAMT").readOnly = false;
	document.getElementById("selMFEECURR").disabled = false;
}

/*
函數名稱:	saveAction()
函數功能:	當toolbar frame 中之儲存按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
---------	----------	-----------------------------------------
*/
function saveAction()
{
	strErrMsg = "";
	mapValue();
	enableAll();
	if(checkFieldOK())
	{	
		document.getElementById("frmMain").submit();
	}
	else
	{
		alert( strErrMsg );	
	}
}

function mapValue()
{
	if(document.getElementById("txtAction").value == "I")
	{
		document.getElementById("txtInqPCSHCM").value = rocDate2String(document.getElementById("txtPCSHCMC").value);
	}
	if(document.getElementById("txtAction").value == "U")
	{
		document.getElementById("txtMFEEDT").value = rocDate2String(document.getElementById("txtMFEEDTC").value);
	}
}

function checkFieldOK()
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	if(document.getElementById("txtMFEEDTC").value == "") {
		strTmpMsg = "請輸入後收手續費日期!\r\n";
		bReturnStatus = false;;
	} else {
		bReturnStatus = checkClientField( document.getElementById( "txtMFEEDTC" ), false );
	}
	if(document.getElementById("txtMFEEAMT").value==".00")
	{
		strTmpMsg += "請輸入後收手續費!\r\n";
		bReturnStatus = false;;
	}
	if(document.getElementById("selMFEECURR").value=="")
	{
		strTmpMsg += "請選擇後收手續費幣別!\r\n";
		bReturnStatus = false;;
	} 
	if( !bReturnStatus )
	{
		strErrMsg = strErrMsg + strTmpMsg + "\r\n";
	}
	return bReturnStatus;
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	//txtPCSHCMC
	var itemName = objThisItem.name;
	var itemDesc = null;
	if( itemName == "txtPCSHCMC" )
		itemDesc = "出納確認日";
	else if( itemName == "txtMFEEDTC" )
		itemDesc = "後收手續費日期";

	if( itemDesc ) {
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if ( bDate == false){
        	strTmpMsg = itemDesc + "-日期格式有誤";
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
<form id="frmMain" method="post" name="frmMain" action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbremit.DISBRemitBackFeeServlet">
<TABLE border="1" width="501" id="inquiryArea">
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="117">出納確認日</TD>
			<TD width="376">
				<INPUT class="Data" size="11" type="text" maxlength="11" id="txtPCSHCMC" name="txtPCSHCMC" > 
				<a href="javascript:show_calendar('frmMain.txtPCSHCMC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" width="24" height="21"></a>
				<INPUT type="hidden" id="txtInqPCSHCM" name="txtInqPCSHCM" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="117">受款人姓名</TD>
			<TD width="376"><INPUT class="Data" size="20" type="text" maxlength="20" id="txtInqRName" name="txtInqRName" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="117">受款人英文姓名</TD>
			<TD width="376"><INPUT class="Data" size="50" type="text" maxlength="70" id="txtInqRENGName" name="txtInqRENGName" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="117">受款人帳號</TD>
			<TD width="376"><INPUT class="Data" size="20" type="text" maxlength="17" name="txtInqRAcct" id="txtInqRAcct" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="117">匯出幣別</TD>
			<TD width="376">
				<select size="1" name="selCurrency" id="selCurrency">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
		<!-- R80338 保單幣別 -->
		<TR>
			<TD align="right" class="TableHeading" width="117">保單幣別</TD>
			<TD width="376">
				<select size="1" name="selPOCurr" id="selPOCurr">
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>		
	</TBODY>
</TABLE>
<DIV Id=updateArea style="display:none ">
<TABLE border="1" width="500" >
	<TBODY>
		<TR id="BENshow" style="display:none"><td colspan=2><font color="red">手續費支付方式為BEN不提供輸入後收手續費</font></td></TR>	
		<TR>
			<TD align="right" class="TableHeading" width="121">後收手續費日期</TD>
			<TD width="330">
				<INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" id="txtMFEEDTC" name="txtMFEEDTC">
				<a href="javascript:show_calendar('frmMain.txtMFEEDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" width="24" height="21" style="display:none" id="imgShow"></a>
				<INPUT type="hidden" name="txtMFEEDT" id="txtMFEEDT" value="">
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">後收手續費金額</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="20" id="txtMFEEAMT" name="txtMFEEAMT" value="" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">後收手續費幣別</TD>
			<TD width="330">
				<select size="1" name="selMFEECURR" id="selMFEECURR" disabled>
					<%=sbCurrCash.toString()%>
				</select>
			</TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">銀行帳號</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="20" id="txtPACCT" name="txtPACCT" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">受款人帳號</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="20" id="txtRACCT" name="txtRACCT" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">受款人名稱</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="50" type="text" maxlength="50" name="txtRNAME" id="txtRNAME" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">幣別</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="10" type="text" maxlength="10" name="txtRPAYCURR" id="txtRPAYCURR" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">匯款金額</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="20" name="txtRPAYAMT" id="txtRPAYAMT" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">手續費支付方式</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtFEEWAY" id="txtPFEEWAY" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">匯款日期</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="11" type="text" maxlength="11" name="txtRMTDT" id="txtRMTDT" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="101">匯款批號</TD>
			<TD width="330">
				<INPUT class="INPUT_DISPLAY" size="20" type="text" maxlength="20" name="txtBATNO" id="txtBATNO" readonly>
				<INPUT type="hidden" name="txtSEQNO" id="txtSEQNO" value="">
			</TD>
		</TR>
		<!-- R80338 保單幣別 -->
		<TR>
			<TD align="right" class="TableHeading" width="101">保單幣別</TD>
			<TD width="330"><INPUT class="INPUT_DISPLAY" size="10" type="text" maxlength="10" name="txtPOCurr" id="txtPOCurr" readonly></TD>
		</TR>
	</TBODY>
</TABLE>
</div>
<INPUT type="hidden" id="txtUpdateStatus" name="txtUpdateStatus" value=""> 
<INPUT type="hidden" id="txtAction" name="txtAction" value="<%=strAction%>"> 
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>
