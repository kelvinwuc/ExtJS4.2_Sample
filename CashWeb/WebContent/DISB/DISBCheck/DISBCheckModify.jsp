<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393      Leo Huang    			2010/09/17           現在時間取Capsil營運時間
 *    R00393      Leo Huang    			2010/09/17           絕對路徑轉相對路徑
 *  =============================================================================
 */
%>
<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
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
 * Revision : $Revision: 1.4 $
 * 
 * Author   : Angel Chen
 * 
 * Create Date : $Date: 2012/08/29 09:18:45 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 * $Log: DISBCheckModify.jsp,v $
 * Revision 1.4  2012/08/29 09:18:45  ODCKain
 * Character problem
 *
 * Revision 1.3  2010/11/23 02:17:04  MISJIMMY
 * R00226-百年專案
 *
 * Revision 1.1  2006/06/29 09:40:44  MISangel
 * Init Project
 *
 *
 *  
 */
-->

<%! 
String strThisProgId = "DISBCheckModify"; //本程式代號
DecimalFormat df = new DecimalFormat("#.00");
%>
<%
//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar =Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),Constant.CURRENT_LOCALE);
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
            	iSumAmt = iSumAmt + objPDetailCounter.getIPAMT() + objPDetailCounter.getIRmtFee() ;
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

String strAction = "";
if (request.getAttribute("txtAction") != null) {
    strAction = (String) request.getAttribute("txtAction");
  }  
  
String strReturnMessage = "";
if (request.getAttribute("txtMsg") != null) {
    strReturnMessage = (String) request.getAttribute("txtMsg");
  }  

String strChequeNo = "";
if (request.getAttribute("txtChequeNo") != null) {
    strChequeNo = (String) request.getAttribute("txtChequeNo");
  }    
  
String strUserDept ="";
if (session.getAttribute("LogonUserDept") != null)
	strUserDept=(String)session.getAttribute("LogonUserDept");
if(!strUserDept.equals(""))
		strUserDept=strUserDept.trim();
		
String strUserRight ="";
if (session.getAttribute("LogonUserRight") != null)
	strUserRight=(String)session.getAttribute("LogonUserRight");
if(!strUserRight.equals(""))
		strUserRight=strUserRight.trim();

//System.out.println("strChequeNo:"+strChequeNo);  
%>
<HTML>
<HEAD>
<TITLE>出納功能--票據還原</TITLE>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<!--R00393  Edit by Leo Huang (EASONTECH) Start
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
<SCRIPT language="JavaScript" src="/CashWeb/ScriptLibrary/Calendar.js"></SCRIPT>-->
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


<!--R00393  Edit by Leo Huang (EASONTECH) End-->
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
		//R00393  Edit by Leo Huang (EASONTECH) Start
	//	window.location.href= "/CashWeb/DISB/DISBCheck/DISBCheckModify.jsp";
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckModify.jsp";
		//R00393  Edit by Leo Huang (EASONTECH) End
	}	
	
	// R80244  if(document.getElementById("txtUserDept").value != "FIN")
	if(document.getElementById("txtUserDept").value != "FIN" && document.getElementById("txtUserDept").value != "ACCT")  // R80244	
	 {
		alert("無執行此報表權限");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	 } else { 
	   if (document.getElementById("txtAction").value == "I"){	
     	WindowOnLoadCommon( document.title , '' , strFunctionKeyInquiry1,'' ) ;
       } else {
       WindowOnLoadCommon( document.title+"(查詢)" , '' , strDISBFunctionKeyInitial,'' ) ;
       }
     }  
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
  document.getElementById("txtAction").value = "I";
  document.getElementById("frmMain").submit();

}



function confirmAction()
{
      var strConfirmMsg = "是否確定要執行?\n";
      var bConfirm = window.confirm(strConfirmMsg);
		if( bConfirm )
		{
		  enableAll();
		  document.getElementById("txtAction").value = "DISBCheckModify";
			//mapValue();
		  document.getElementById("frmMain").submit();
        }
	
}
function DISBCCreateAction()
{
      if(IsItemInputed())
    {
       var strConfirmMsg = "是否確定要執行還原?\n";
	    var bConfirm = window.confirm(strConfirmMsg);
		if( bConfirm )
		{
			enableAll();
			document.getElementById("txtAction").value = "DISBCheckModify";
			document.getElementById("frmMain").submit();
		}
    
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
	//R00393  Edit by Leo Huang (EASONTECH) Start
	//window.location.href= "/CashWeb/DISB/DISBCheck/DISBCheckModify.jsp";
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckModify.jsp";
	//R00393  Edit by Leo Huang (EASONTECH) End
}


</script>
</HEAD>
<BODY onload="WindowOnload()">
<!--R00393  Edit by Leo Huang (EASONTECH) Start
<form
	action="/CashWeb/servlet/com.aegon.disb.disbcheck.DISBCheckModifyServlet"
	id="frmMain" method="post" name="frmMain">
	-->
<form 	action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckModifyServlet"
	id="frmMain" method="post" name="frmMain">
<!--R00393  Edit by Leo Huang (EASONTECH) End-->
<TABLE border="1" id=inqueryArea	name=inqueryArea>
	<TBODY>
		<TR>
			<TD align="right" class="TableHeading" width="74">票據號碼：</TD>
			<TD><INPUT class="Data" size="11" type="text" maxlength="11"
				name="txtChequeNo" id="txtChequeNo" value="<%=strChequeNo%>"></TD>
		</TR>		
	    <TR><TD  colspan=2 ><font color="#FF0000" ><b>限人工開票件且狀態為開立(D)之票據使用</TD></TR>
	</TBODY>
</TABLE>
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
													 height="30"><b><font size="2" face="細明體">受款人姓名</font></b></TD>
												<TD bgcolor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><b><font size="2" face="細明體">支付金額</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><font size="2" face="細明體"><b>支付描述</b></font></TD>
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
					           String strPName = "";
					           double iPAmt = 0;
					           double iRmtFee = 0;
					           String strPdesc = "";
					           int iCshDate = 0;
					           String strCshDate ="";
					           
					            if (objPDetailVO.getStrPNO()!=null)
					           		strPNo = objPDetailVO.getStrPNO();
			                   if(strPNo!="")
			                   		strPNo= strPNo.trim();		
					           
					           if (objPDetailVO.getStrPolicyNo()!=null)
					           		strPolNo = objPDetailVO.getStrPolicyNo();
			                   if(strPolNo!="")
			                   		strPolNo= strPolNo.trim();		
			          		
								if (objPDetailVO.getStrPName()!=null)
					           		strPName = objPDetailVO.getStrPName();
					           	if(strPName !="")
					           		strPName = strPName.trim();	
					           		
								if (objPDetailVO.getStrPDesc()!=null)
					           		strPdesc = objPDetailVO.getStrPDesc();	
			                    if(strPdesc!="")
			                    	strPdesc = strPdesc.trim();
					           	iPAmt = objPDetailVO.getIPAMT();
					           	iRmtFee = objPDetailVO.getIRmtFee();	
					           	iCshDate = objPDetailVO.getIPCshDt();
					           	
					           	if(iCshDate == 0)
					           		strCshDate = "";
					           	else
				           			strCshDate = Integer.toString(iCshDate);					           	    	  		

					           if (objPDetailVO.getStrPCheckNO()!=null)
					           		strChequeNo = objPDetailVO.getStrPCheckNO();
			                   if(strChequeNo!="")
			                   		strChequeNo= strChequeNo.trim();		
				           			
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
										><%=strPName%>&nbsp;</TD>
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
										><%=strChequeNo%><INPUT  name="txtCNo<%=icurrentRec%>"  id="txtCNo<%=icurrentRec%>"  type="hidden" value="<%=strChequeNo%>"  size="9" maxlength="9" readOnly>&nbsp;
									   <INPUT name="txtPNo<%=icurrentRec%>" id="txtPNo<%=icurrentRec%>"  type="hidden" value="<%=strPNo%>"></TD>
									 <TD
										style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
										><%=strCshDate%>
										 <INPUT class="Data" size="11" type="hidden" 	maxlength="11" id="ttxtUPCshDtC<%=icurrentRec%>" name="txtUPCshDtC<%=icurrentRec%>" value ="<%=strCshDate%>" readOnly>                                       
		                            </TD> 
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										><%=df.format(iRmtFee)%><INPUT type="hidden" name="txtFee<%=icurrentRec%>"  id="txtFee<%=icurrentRec%>" value="<%=df.format(iRmtFee)%>"  size="9" maxlength="9" readOnly>&nbsp; 
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
        總頁數 : <%=itotalpage%> &nbsp;&nbsp;總件數 : <%=itotalCount%> &nbsp;&nbsp;&nbsp;&nbsp;總金額:<%=df.format(iSumAmt)%> 
           <%
            } //end of if2 
           }//end of if1
%>

<INPUT name="txtTpage" id="txtTpage"  type="hidden" value="<%=itotalpage%>">
<INPUT name="txtPaySeq" id="txtPaySeq" type="hidden" value="">
<INPUT name="txtUserDept" 	id="txtUserDept" type="hidden" value="<%=strUserDept%>">
<INPUT name="txtAction" id="txtAction" type="hidden" value="<%=strAction%>"> 
<INPUT name="txtMsg"    id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>
</BODY>
</HTML>