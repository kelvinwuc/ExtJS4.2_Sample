<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *   R00393       Leo Huang    			2010/09/17           現在時間取Capsil營運時間
 *   R00393       Leo Huang    			2010/09/17           絕對路徑轉相對路徑
 *   R00231       Leo Huang    			2010/09/26           民國百年專案問題
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
 * Revision : $Revision: 1.7 $
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $Date: 2014/07/18 07:25:19 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckCreate.jsp,v $
 * Revision 1.7  2014/07/18 07:25:19  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.6  2013/12/24 03:40:20  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 * Revision 1.2  2008/07/10 03:42:01  misvanessa
 * R80518_人工開票票據到期日修改
 *
 * Revision 1.1  2006/06/29 09:40:45  MISangel
 * Init Project
 *
 * Revision 1.1.2.10  2006/04/10 05:46:16  misangel
 * R60200:出納功能提升
 *
 * Revision 1.1.2.9  2005/12/23 02:12:01  misangel
 * R50820:支付功能提升,修正bug
 *
 * Revision 1.1.2.8  2005/04/04 07:02:23  miselsa
 * R30530 支付系統
 *
 *  
 */
-->

<%! 
String strThisProgId = "DISBCheckCreate"; //本程式代號
DecimalFormat df = new DecimalFormat("#.00");
%>
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
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
//R00393  Edit by Leo Huang (EASONTECH) Start
//java.util.Date dteToday = cldCalendar.getTime(); //目前日期時間
Calendar  calendar = new CommonUtil(globalEnviron).getBizDateByRCalendar();
java.util.Date dteToday = new CommonUtil(globalEnviron).getBizDateByRDate();
//R00393  Edit by Leo Huang (EASONTECH) End
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

//List alPSrcCode = new ArrayList();

//alPSrcCode = (List) disbBean.getETable("PAYCD", "");
    String strAction = "";
if (request.getAttribute("txtAction") != null) {
    strAction = (String) request.getAttribute("txtAction");
    //System.out.println(strAction);
  }  
  
String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
    strReturnMessage = (String) request.getAttribute("txtMsg");
  }  
%>
<HTML>
<HEAD>
<TITLE>出納功能--人工開票</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<!--R00393 Edit by Leo Huang (EASONTECH) Start
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
<!--R00393 Edit by Leo Huang (EASONTECH) Start-->
<script LANGUAGE="javascript">
var iTotalrec =<%=itotalCount%>;
var iMehodA = 0 ;
var iAMTA = 0 ;
var iCountA = 0;
var iMehodB = 0 ;
var iAMTB = 0 ;
var iCountB= 0;
var iMehodC = 0 ;
var iAMTC = 0 ;
var iCountC= 0;
function WindowOnload()
{	
	if( document.getElementById("txtMsg").value != "")
	{
		
		window.alert(document.getElementById("txtMsg").value) ;
		//window.location.href= "/CashWeb/DISB/DISBCheck/DISBCheckCreate.jsp";	
	}	

     if (document.getElementById("txtAction").value == "I")
	{
     	document.getElementById("inqueryArea").style.display = "none"; 
        document.getElementById("chkedtArea").style.display = "none"; //R80518
     	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyCC,'' ) ;
     } else if (document.getElementById("txtAction").value == "ChequeCheck"){	
       	document.getElementById("inqueryArea").style.display = "none"; //R80518
        document.getElementById("chkedtArea").style.display = "block"; //R80518
        WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' ) ;
     } else {     
        document.getElementById("inqueryArea").style.display = "block"; //R80518
        document.getElementById("chkedtArea").style.display = "none"; //R80518
         WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' )     	
     }
 
}
/*
函數名稱:	inquiryAction()
函數功能:	當toolbar frame 中之<查詢>按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function inquiryAction()
{
	document.getElementById("txtAction").value = "I";
	mapValue();
	if( areAllFieldsOK() )
	{	
		document.getElementById("frmMain").submit();
	}
	else
		alert( strErrMsg );
	
}
/*
函數名稱:	confirmAction()
函數功能:	當toolbar frame 中之<確定>按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function confirmAction()
{
     //R80518 if(IsItemInputed())
     if(IsItemInputed("DISBCheckCreate"))
    {
       var strConfirmMsg = "是否確定要執行人工開票作業?\n";
	    var bConfirm = window.confirm(strConfirmMsg);
		if( bConfirm )
		{
			enableAll();					
		    document.getElementById("txtAction").value = "DISBCheckCreate";
			mapValue();
			document.getElementById("frmMain").submit();
		}    
    }
}
/*
函數名稱:	DISBCCreateAction()
函數功能:	當toolbar frame 中之<人工開票>按鈕被點選時,本函數會被執行
傳入參數:	無
傳回值:	無
修改紀錄:	修改日期	修改者	修   改   摘   要
		---------	----------	-----------------------------------------
*/
function DISBCCreateAction()
{
      //R80518if(IsItemInputed())
     if(IsItemInputed("ChequeCheck"))
    {      
			enableAll();						
 			document.getElementById("txtAction").value = "ChequeCheck";
			mapValue();
			document.getElementById("frmMain").submit();
    }
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
	//R00393 Edit by Leo Huang (EASONTECH) Start
	//window.location.href= "/CashWeb/DISB/DISBCheck/DISBCheckCreate.jsp";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckCreate.jsp";
	//R00393  Edit by Leo Huang (EASONTECH) End
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
   if( objThisItem.id == "txtPDateC" )
	{
		if( objThisItem.value == "" )
		{
			strTmpMsg = "付款日期不可空白";
			bReturnStatus = false;
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
 	document.getElementById("txtPDate").value 
		= rocDate2String(document.getElementById("txtPDateC").value) ;
//R80518	票據到期日
 	document.getElementById("txtCHKEDT").value 
		= rocDate2String(document.getElementById("txtCHKEDTC").value) ;
//	if(document.getElementById("txtAction").value == "DISBCheckCreate")
	if(document.getElementById("txtAction").value == "DISBCheckCreate" || document.getElementById("txtAction").value == "ChequeCheck")
	{
		  for (i=0;i< iTotalrec;i++ )
   		 {
		    var pCshDtId = "txtUPCshDt" + i ;
		    var pCshDtCId = "txtUPCshDtC" + i ;
	         if(document.getElementById(pCshDtCId).value !="")
	        {
		    	document.getElementById(pCshDtId).value 
					= rocDate2String(document.getElementById(pCshDtCId).value) ;
		    }
	 	}
	}	
}

/*
判斷票據號碼欄位至少要輸入一個 2004/11/24  Elsa
*/
//R80518function IsItemInputed()
function IsItemInputed(objName)
{
    var iflag=0;
    var strTmpMsg = "";
    var bReturnStatus = true;
    for (i=0;i< iTotalrec;i++ )
    {
	    var checkId = "txtCNo" + i ;
	    var pCshDtCId = "txtUPCshDtC" + i ;
	    var FeeId ="txtFee" + i ;
	     if(document.getElementById(checkId).value !="" && document.getElementById(pCshDtCId).value !="")
        {
	    	iflag = 1;
	    	bReturnStatus = true;
	    	break;
	    }
	    if (document.getElementById(FeeId).value =="" )
	    {
	       document.getElementById(FeeId).value = "0";
	    }
	 }
     if(iflag==0)
    {
        strTmpMsg ="至少要輸入一組票據號碼及出納日期";
        bReturnStatus=false;
    }
    //R80518 票據到期日
    if (objName == "DISBCheckCreate")
    {
		if (document.getElementById("txtCHKEDTC").value =="")
		{        
		strTmpMsg +="\r\n請輸入票據到期日";
        bReturnStatus=false;
		}
    }
    if( !bReturnStatus )
	{
			alert( strTmpMsg );
	}
	return bReturnStatus;
}

</script>
</HEAD>
<BODY onload="WindowOnload()">
<!--R00393  Edit by Leo Huang (EASONTECH) Start
<form
	action="/CashWeb/servlet/com.aegon.disb.disbcheck.DISBCheckCreateServlet"
	id="frmMain" method="post" name="frmMain">
	-->
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckCreateServlet"
	id="frmMain" method="post" name="frmMain">
<!--R00393  Edit by Leo Huang (EASONTECH) End-->
<TABLE border="1" id=inqueryArea	name=inqueryArea>
	<TBODY>
		<TR>
			<TD colspan="8"><a href="\\pmwcash2\WASApp\CashWeb.ear\CashWeb.war\download" target="_blank">下載急件給付清單【檔名：YYYYMMDDHHmm急件給付清單.xls】</a></TD>
		<TR>
		<TR>
			<TD align="right" class="TableHeading" width="112">會計確認日期：</TD>
			<TD colspan=3 width="128"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtPDateC" name="txtPDateC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtPDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> <INPUT
				type="hidden" name="txtPDate" id="txtPDate" value=""></TD>
	        <TD align="right" class="TableHeading" width="48">急件：</TD>
			<TD colspan=3 width="13"><select size="1" name="selDispatch" id="selDispatch">
			<option value=""></option>
			<option value="Y">是</option>
			<option value="N">否</option>
			</select></TD>
		</TR>		
	
	</TBODY>
</TABLE>
<!--R80581新增票據到期日-->
<TABLE border="1" id=chkedtArea	name=chkedtArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="111">票據到期日：</TD>
			<TD colspan=3 width="129"><INPUT class="Data" size="11" type="text" maxlength="11"
				id="txtCHKEDTC" name="txtCHKEDTC" value="" readOnly
				onblur="checkClientField(this,true);"> <a
				href="javascript:show_calendar('frmMain.txtCHKEDTC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG
				src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> <INPUT
				type="hidden" name="txtCHKEDT" id="txtCHKEDT" value=""></TD>
		</TR>			
	</TBODY>
</TABLE>
<!--
<TABLE border=0 width="181">
<TR>
<TD width="73">
<INPUT type=button name="inquryBTN" id="inquryBTN" value="查詢" onclick="inqueryAction()" >&nbsp;

</TD>
<TD>
<INPUT type=button name="confirmBTN" id="confirmBTN" value="支付確認" onclick="confirmAction()"></TD>
</TR>
</TABLE>-->

<BR>
	
		<% if (alPDetail !=null)
		      {//if1
		        if(alPDetail.size()>0)
		        {//if2
		        int icurrentRec = 0;
		        int icurrentPage = 0; // 由0開始計
		        int iSeqNo = 0;
		       for (int i=0; i<itotalpage;i++)
		       {
		          icurrentPage = i ;
       	            for (int j = 0 ; j < iPageSize;j++)
			        {
			            iSeqNo ++;
						icurrentRec = icurrentPage * iPageSize + j ; 
			           if(icurrentRec < alPDetail.size())
			           {
			           		    if( j == 0) // show table head
			           		    {
			           		    	   if((icurrentPage + 1) == 1)
	 	  				               {
			              %>
											<div id=showPage<%=icurrentPage+1%> style="display:">
							<%
									}
								   else 
								   {
							%>		
							  			    <div id=showPage<%=icurrentPage+1%> style="display:none">
							   <%}%>  
							       <table boder=1>
										<tr>
											<td><a href='javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage+1%>,1)'> &lt;&lt;&nbsp;&nbsp;</a></td>
											<td><a href='javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage+1%>,2)'>&lt;&nbsp;&nbsp;</a></td>
											<td><a href='javascript:ChangePage(<%=icurrentPage+2%>,<%=itotalpage%>,<%=icurrentPage+1%>,3)'>&gt;&nbsp;&nbsp;</a></td>
											<td><a href='javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage+1%>,4)'>&gt;&gt;&nbsp;&nbsp;</a></td>
										</tr>
									</table>
															<hr>
															
									<table border="0" cellPadding="0" cellSpacing="0" width=""
										id="tblDetail" name='tblDetail'>
										<tbody>		       
									       	<TR>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="30"><b><font size="2" face="細明體">序號</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="30" ><b><font size="2" face="細明體">保單號碼</font></b></TD>
												<TD bgcolor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><b><font size="2" face="細明體">要保書號碼</font></b></TD>
												<TD bgcolor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
												<TD bgcolor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="30" ><b><font size="2" face="細明體">受款人ID</font></b></TD>
												<TD bgcolor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><b><font size="2" face="細明體">支付金額</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><font size="2" face="細明體"><b>支付描述</b></font></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><b><font size="2" face="細明體">付款日期</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><b><font size="2" face="細明體">付款方式</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><font size="2" face="細明體"><b>急件否</b></font></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="30" ><font size="2" face="細明體"><b>票據號碼</b></font></TD>
												<TD bgColor="#c0c0c0"
													style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
													 height="30"><font size="2" face="細明體"><b>出納日期</b></font></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="30" ><font size="2" face="細明體"><b>匯費</b></font></TD>

											</TR>
	
			         <%
			           		    
			           		    }
			           		    
			           		   DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)alPDetail.get(icurrentRec);
					           String strPNo = "";
					           String strPolNo = "";
					           String strAppNo = "";
					           String strPName = "";
					           String strPId = "";
					           String strPCshDate="";
					           String strCheckNO="";
					           double iPAmt = 0;
					           int iFee = 0;
					           String strFee = "";
					           String strPdesc = "";
					           String strPMethod="";
					           String strPMethodDesc = "";
					           int iPDate = 0;
					           int iPCshDate = 0;
					           String strPDate ="";
					           String strPDispatch = "";
					           String strPDispatchD = "";
					           
					            if (objPDetailVO.getStrPNO()!=null)
					           		strPNo = objPDetailVO.getStrPNO();
			                   if(strPNo!="")
			                   		strPNo= strPNo.trim();		
					           
					           if (objPDetailVO.getStrPolicyNo()!=null)
					           		strPolNo = objPDetailVO.getStrPolicyNo();
			                   if(strPolNo!="")
			                   		strPolNo= strPolNo.trim();		
			          		
								if (objPDetailVO.getStrAppNo()!=null)
					           		strAppNo = objPDetailVO.getStrAppNo();
					           	if(strAppNo!="")
					           		strAppNo=strAppNo.trim();	
					           		
								if (objPDetailVO.getStrPName()!=null)
					           		strPName = objPDetailVO.getStrPName();
					           	if(strPName !="")
					           		strPName = strPName.trim();	
					           		
								if (objPDetailVO.getStrPId()!=null)
					           		strPId = objPDetailVO.getStrPId();
			                     if(strPId!="")
			                     	strPId = strPId.trim();		         
			                     	  		
								if (objPDetailVO.getStrPDesc()!=null)
					           		strPdesc = objPDetailVO.getStrPDesc();	
			                    if(strPdesc!="")
			                    	strPdesc = strPdesc.trim();
			                    	 		           			      
								if (objPDetailVO.getStrPMethod()!=null)
					           		strPMethod = objPDetailVO.getStrPMethod();	
					           	if(strPMethod!="")
					           	{			
					           		strPMethod = strPMethod.trim();
					           		if (strPMethod.equals("A"))
					           			strPMethodDesc = "支票";
					           		if (strPMethod.equals("B"))
					           			strPMethodDesc = "匯款";
					           		if (strPMethod.equals("C"))
					           			strPMethodDesc = "信用卡";		
					           		if (strPMethod.equals("E"))         //RC0036
					           			strPMethodDesc = "現金";	        //RC0036
					           	}	
					           		
					           	if (objPDetailVO.getStrPDispatch()!=null)
					           		strPDispatch = objPDetailVO.getStrPDispatch();
			                     if(strPDispatch!="")
			                     {
			                     	strPDispatch = strPDispatch.trim();		
			                     	if (strPDispatch.equals("Y"))
			                     		strPDispatchD ="是";
			                     	else
			                     		strPDispatchD = "否";	
			                     }	  
					           	iPAmt = objPDetailVO.getIPAMT();	
					           	iPDate = objPDetailVO.getIPDate();	  
					           	if(iPDate == 0)
					           		strPDate = "";
					           	else
				           			strPDate =Integer.toString(iPDate);

                                iPCshDate = objPDetailVO.getIPCshDt();	  
					           	if(iPCshDate == 0){
					           		strPCshDate = "";
					           	}else{
					           	    //strPCshDate = Integer.toString(iPCshDate);
					           	//R00231 edit by Leo Huang					           	   
				           		//strPCshDate = "0" + Integer.toString(iPCshDate).substring(0,2)+"/" ;
				           		//strPCshDate += Integer.toString(iPCshDate).substring(2,4)+"/" ;
				           		//strPCshDate += Integer.toString(iPCshDate).substring(4);
				           			strPCshDate	= Integer.toString(iPCshDate);
				           			if(strPCshDate.length()<7){
				           				strPCshDate = "0" + Integer.toString(iPCshDate).substring(0,2)+"/" ;
				           				strPCshDate += Integer.toString(iPCshDate).substring(2,4)+"/" ;
				           				strPCshDate += Integer.toString(iPCshDate).substring(4);
				           			}else{
				           				strPCshDate =  Integer.toString(iPCshDate).substring(0,3)+"/" ;
				           				strPCshDate += Integer.toString(iPCshDate).substring(3,5)+"/" ;
				           				strPCshDate += Integer.toString(iPCshDate).substring(5);
				           		
				           			}
				           		}
				           		//R00231 edit by Leo Huang		
				           		//System.out.println(strPCshDate); 
                                iFee = (int) objPDetailVO.getIRmtFee() ;
                                strFee = Integer.toString (iFee);
                                //System.out.println(iFee);
								if (objPDetailVO.getStrPCheckNO() !=null)
					           		strCheckNO = objPDetailVO.getStrPCheckNO();
			                     if(strPId!="")
			                     	strCheckNO = strCheckNO.trim();		         
                                				           			
                                 				           			
		%>

								<TR id=data>
						          <TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=icurrentRec+1%></TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=strPolNo%>&nbsp;</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=strAppNo%>&nbsp;</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=strPName%>&nbsp;</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=strPId%>&nbsp;</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=df.format(iPAmt)%>&nbsp;
										<INPUT name="txtPAMT<%=icurrentRec%>" id="txtPAMT<%=icurrentRec%>"  type="hidden" value="<%=iPAmt%>">
									</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=strPdesc%>&nbsp;</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=iPDate%>&nbsp;</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=strPMethodDesc%>&nbsp;
										<INPUT name="txtPMethod<%=icurrentRec%>" id="txtPMethod<%=icurrentRec%>"  type="hidden" value="<%=strPMethod%>">
									</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=strPDispatchD%>&nbsp;</TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><INPUT type="text" name="txtCNo<%=icurrentRec%>"  id="txtCNo<%=icurrentRec%>" value="<%=strCheckNO%>"  size="9" maxlength="9">&nbsp;
									   <INPUT name="txtPNo<%=icurrentRec%>" id="txtPNo<%=icurrentRec%>"  type="hidden" value="<%=strPNo%>"></TD>
									 <TD
										style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
										><!--
										 <INPUT class="Data" size="11" type="text" 	maxlength="11" id="ttxtUPCshDtC<%=icurrentRec%>" name="txtUPCshDtC<%=icurrentRec%>"  value="<%=strPCshDate%>" readOnly	onblur="checkClientField(this,true);">-->
										 <INPUT class="Data" size="11" type="text" 	maxlength="11" id="txtUPCshDtC<%=icurrentRec%>" name="txtUPCshDtC<%=icurrentRec%>"  value="<%=strPCshDate%>" readOnly	onblur="checkClientField(this,true);">
										 <a	href="javascript:show_calendar('frmMain.txtUPCshDtC<%=icurrentRec%>','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');">
										 <!-- R00393 edit by Leo Huang-->
											<IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" width="24"	height="21">
										 </a> <INPUT type="hidden" name="txtUPCshDt<%=icurrentRec%>"	id="txtUPCshDt<%=icurrentRec%>" value="<%=strPCshDate%>">
		                            </TD> 
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><INPUT type="text" name="txtFee<%=icurrentRec%>"  id="txtFee<%=icurrentRec%>" value="<%=strFee%>"  size="9" maxlength="9">&nbsp;
									   </TD>


								</TR>
				<%			
    				  if((iSeqNo == iPageSize) || (icurrentRec == (alPDetail.size()-1) ) || (iSeqNo%iPageSize == 0))    
    			        {
			       %> 
				        	</tbody>
						</table>
					</div>		
			     <%   
			    	    }
			         } // end of if --> inowRec < alPDetail.size()
			       }// end of for -- show detail      
              }//end of for
            %>
        <!--   <input name="allbox" type="checkbox" onClick="CheckAll();" checked>-->
        總頁數 : <%=itotalpage%> &nbsp;&nbsp;總件數 : <%=itotalCount%> &nbsp;&nbsp;&nbsp;&nbsp;總金額:<%=df.format(iSumAmt)%> 
           <%
            } //end of if2 
           }//end of if1
           else
           {
       %>
<table border="0" cellPadding="0" cellSpacing="0" width=""
	id="tblDetail" name='tblDetail'>
	<tbody>		       
       	<TR>
			<TD bgColor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><b><font size="2" face="細明體">序號</font></b></TD>
			<TD bgColor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><b><font size="2" face="細明體">保單號碼</font></b></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><b><font size="2" face="細明體">要保書號碼</font></b></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><b><font size="2" face="細明體">受款人姓名</font></b></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><b><font size="2" face="細明體">受款人</font><font face="細明體">ID</font></b></TD>
			<TD bgcolor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><b><font size="2" face="細明體">支付金額</font></b></TD>
			<TD bgColor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><font size="2" face="細明體"><b>支付描述</b></font></TD>
			<TD bgColor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><b><font size="2" face="細明體">付款日期</font></b></TD>
			<TD bgColor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><b><font size="2" face="細明體">付款方式</font></b></TD>
			<TD bgColor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><font size="2" face="細明體"><b>急件否</b></font></TD>
			<TD bgColor="#c0c0c0"
				style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
				 ><font size="2" face="細明體"><b>票據號碼</b></font></TD>
			<TD bgColor="#c0c0c0"
				style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
				 ><font size="2" face="細明體"><b>出納日期</b></font></TD>	
		</TR>
			</tbody>
</table>
		<%}%>
		
<INPUT name="txtTpage" id="txtTpage"  type="hidden" value="<%=itotalpage%>">
<INPUT name="txtPaySeq" id="txtPaySeq" type="hidden" value=""> <INPUT
	name="txtAction" id="txtAction" type="hidden"
	value="<%=strAction%>"> <INPUT name="txtMsg"
	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>