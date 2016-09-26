<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393       Leo Huang    			2010/09/20           現在時間取Capsil營運時間
 *	 R00393  	  Leo Huang    			2010/09/21           絕對路徑轉相對路徑
 *   R00231       Leo Huang    			2010/09/26           民國百年專案
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
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.8  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.2  2008/08/18 06:15:51  MISODIN
 * R80338 調整銀行帳號選單的預設值
 *
 * Revision 1.1  2006/06/29 09:40:44  MISangel
 * Init Project
 *
 * Revision 1.1.2.3  2005/04/04 07:02:23  miselsa
 * R30530 支付系統
 *
 *  
 */
-->

<%! String strThisProgId = "DISBOneCheckCashed"; //本程式代號%>
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
//java.util.Date dteToday = cldCalendar.getTime(); //目前日期時間
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
 double iSumAmt = 0;//總金額
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
<TITLE>支票功能--票據單筆回銷作業</TITLE>
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
函數名稱:	resetAction()
函數功能:	當toolbar frame 中之清除按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*
函數名稱:	exitAction()
函數功能:	當toolbar frame 中之離開按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
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
函數名稱:	confirmAction()
函數功能:	當toolbar frame 中之確定按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function confirmAction()
{
	if( areAllFieldsOK() )
	{	
	//{
		/*	執行 QueryFrameSet.jsp 時,各 QueryString 參數之意義
			RowPerPage		: 每一頁有幾列
			Heading			: 表頭欄位名稱,以逗號','分開每一欄位
			DisplayFields	: 要顯示之資料庫欄位名稱,以逗號分開每一欄位,與Heading相對應
			ReturnFields	: 傳回哪些欄位之值,以逗號分開每一欄位
			Sql				: 待執行之SQL,亦可加入where條件
			TableWidth		: 整個Table之寬度
	
		 modalDialog 會傳回使用者選定之欄位值(根據ReturnFields所指定之欄位),若有多個欄位時,會以逗號分開
		
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
		<%	// 將 QueryString 改為 session attribute 以避免 QueryString 過長造成 ie 問題  
	    session.setAttribute("Heading","銀行行庫,銀行帳號,票據號碼,票據抬頭,開立日期,支付序號,輸入者,輸入日");
	    session.setAttribute("DisplayFields", "CBKNO,CACCOUNT,CNO,CNM,CUSEDT,PNO,ENTRYUSR,ENTRYDT");
	    session.setAttribute("ReturnFields", "CBKNO,CACCOUNT,CBNO,CNO,CNM,CAMT,CUSEDT,CHEQUEDT,PNO");
	    %>
		//modalDialog 會傳回使用者選定之欄位值,若有多個欄位時,會以逗號分開
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
			//R00231 edit by Leo Huang 開立日和到期日對調
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
函數名稱:	DISBCheckOpenAction()
函數功能:	當toolbar frame 中之[票據開立]按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/

function DISBCheckCashedAction()
{
  if( areAllFieldsOK() )
	{
	    var strConfirmMsg = "是否確定執行單筆回銷作業?\n";
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
函數名稱:	checkClientField(objThisItem,bShowMsg)
函數功能:	檢核傳入之欄位是否正確
傳入參數:	objThisItem:待測試的欄位物件
			bShowMsg:true:即時顯示錯誤訊息,false:不要即時顯示錯誤訊息,將錯誤訊息累積至strErrMsg中
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
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
				strTmpMsg = "兌現日期不可空白";
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
				strTmpMsg = "票據到期日期不可空白";
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
			<TD align="right" class="TableHeading" width="104">付款帳號：</TD>
			<TD width="281"><select size="1" name="selPBBank" id="selPBBank">
                <option value="8220635/635300021303">8220635/635300021303-中信銀復興</option><!--R80338-->			
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
			<TD align="right" class="TableHeading" width="104">票據到期日：</TD>
			<TD width="281"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtChequeDTC" name="txtChequeDTC" value=""
				readOnly onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtChequeDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<!--R00393  Edit by Leo Huang (EASONTECH) Start
				<IMG src="/CashWeb/images/misc/show-calendar.gif" alt="查詢">
				-->
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
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
			<TD align="right" class="TableHeading" width="161">請選票據兌現日：</TD>
			<TD width="319"><INPUT class="Data" size="11" type="text"
				maxlength="11" id="txtCashDTC" name="txtCashDTC" value=""
				readOnly > <a
				href="javascript:show_calendar('frmMain.txtCashDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
				<!--R00393  Edit by Leo Huang (EASONTECH) Start
				<IMG src="/CashWeb/images/misc/show-calendar.gif" alt="查詢">
				-->
				<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢">
				<!--R00393  Edit by Leo Huang (EASONTECH) End-->
			    </a> 
				 <INPUT
				type="hidden" name="txtCashDT" id="txtCashDT" value=""></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="161">銀行行庫：</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="8" type="text"
				maxlength="7" name="txtUCBKNO" id="txtUCBKNO" value="" readonly></TD>
		</TR>

		<tr>
			<TD align="right" class="TableHeading" width="161">銀行帳號：</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="16" id="txtUCACCOUNT" name="txtUCACCOUNT" ></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="161">票據批號：</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="11" type="text"
				maxlength="6" id="txtUCBNO" name="txtUCBNO"></TD>
		</tr>
		<tr>
			<TD align="right" class="TableHeading" width="161">票據號碼：</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="18" name="txtUCNO" id="txtUCNO" readonly></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" height="24" width="161">票據抬頭：</TD>
		<TD width="319"><INPUT class="INPUT_DISPLAY" size="30" type="text"
				maxlength="20" name="txtUCNM" id="txtUCNM" readonly></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="161">票面金額：</TD>
		<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="18" name="txtUCAMT" id="txtUCAMT" readonly></TD>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" width="161">開立日：</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="18" name="txtUCUSEDT" id="txtUCUSEDT" readonly></TD>
		</TR>
		<TR>
			<TD align="right" class="TableHeading" width="161">到期日：</TD>
			<TD width="319"><INPUT class="INPUT_DISPLAY" size="20" type="text"
				maxlength="18" name="txtUCHEQUEDT" id="txtUCHEQUEDT" readonly></TD>
		</TR>
		<tr>
			<TD align="right" class="TableHeading" width="161">支付號碼：</TD>
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
