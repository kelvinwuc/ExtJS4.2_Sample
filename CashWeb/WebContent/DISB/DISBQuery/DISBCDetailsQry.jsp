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
<%@ page import="com.aegon.disb.util.DISBCheckDetailVO"%>
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
 * Author   : Angel Chen
 * 
 * Create Date : $Date: 2013/12/24 03:48:55 $
 * 
 * Request ID :
 * 
 * CVS History:
 * 
 *  
 */
-->
<%! String strThisProgId = "DISBCDetailsQry"; //本程式代號
    DecimalFormat df = new DecimalFormat("#,###.00");%>
<%
GlobalEnviron globalEnviron =
	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();	
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
//R00393  Edit by Leo Huang (EASONTECH) Start
//java.util.Date dteToday = cldCalendar.getTime(); //目前日期時間
//R00393  Edit by Leo Huang (EASONTECH) End
String strReturnMessage = "";
if(request.getParameter("txtMsg") !=null)
{
	strReturnMessage = request.getParameter("txtMsg") ;
}
else
{
   strReturnMessage="";
}
String strAction = "";
if (request.getAttribute("txtAction") != null) {
    strAction = (String) request.getAttribute("txtAction");
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

String strUserId ="";
if (session.getAttribute("LogonUserId") != null)
	strUserId=(String)session.getAttribute("LogonUserId");
if(!strUserId.equals(""))
		strUserId=strUserId.trim();
		
String strOption ="";
if (request.getAttribute("rdReport") != null) {
    strOption = (String) request.getAttribute("rdReport");
  }  

String strDateType ="";
if (request.getAttribute("para_DateType") != null) {
    strDateType = (String) request.getAttribute("para_DateType");
  } 

String strChkDateS ="";
if (request.getAttribute("para_ChkDateS") != null) {
    strChkDateS = (String) request.getAttribute("para_ChkDateS");
  }else
   strChkDateS="094/06/01"; 

String strChkDateE ="";
if (request.getAttribute("para_ChkDateE") != null) {
    strChkDateE = (String) request.getAttribute("para_ChkDateE");
  }  
			
//取得統計資料
List alCDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
double iSumAmt = 0;//總金額

if(session.getAttribute("CheckControlList") !=null)
{
alCDetail = (List)session.getAttribute("CheckControlList");

 if (alCDetail!=null)
 {
	if (alCDetail.size()>0)
	 {
    	itotalCount = alCDetail.size();
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
 session.removeAttribute("CheckControlList");

	
%>
<HTML>
<HEAD>
<TITLE>應付票據統計</TITLE>
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
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "" && document.getElementById("txtMsg").value !=null)
		window.alert(document.getElementById("txtMsg").value) ;

	if(document.getElementById("txtUserDept").value != "FIN" && document.getElementById("txtUserDept").value != "ACCT")  // R80244
	{
		alert("無執行此報表權限");
		window.location.href= "<%=request.getContextPath()%>/BBSShow/PersonalNews.jsp";
	}
	else
	{
		if (document.getElementById("txtAction").value == "")
    	{
	       WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyInitial,'' ) ;	       
	    }
	    else
	    {	   	  
	   	  WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyExit,'' ) ;	
	    } 	
	    window.status = "";
	 }   
}
/* 當toolbar frame 中之<報表>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	winToolBar.ShowButton( strDISBFunctionKeyInitial );
	document.getElementById("txtAction").value = "";	 
	disableAll();
	window.location.href= "<%=request.getContextPath()%>/DISB/DISBQuery/DISBCDetailsQry.jsp?";
}

function checkClientField(objThisItem,bShowMsg ){

	var bReturnStatus = true;
	var bDate = true;
	var strTmpMsg = "";

	if( objThisItem.name == "txtCheckStartDateC" ||  objThisItem.name == "txtCheckEndDateC" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
        strTmpMsg = "系統日期-日期格式有誤";
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
function inquiryAction()
{
   mapValue();
   window.status = "";
   WindowOnLoadCommon( document.title , '' , 'E','' ) ;
   document.getElementById("frmMain").submit();
}

function mapValue(){
	document.getElementById("para_ChkDateS").value = rocDate2String(document.getElementById("txtCheckStartDateC").value) ;
	document.getElementById("para_ChkDateE").value = rocDate2String(document.getElementById("txtCheckEndDateC").value) ;		
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad();">
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbquery.DISBCDetailServlet" id="frmMain" method="post" name="frmMain">	

<TABLE border="1" width="452" id="inquiryArea">
		<TR>
			<TD align="right" class="TableHeading" width="180">請選擇Query：</TD>
			<TD width="305">			
			<input type="radio" name="rdReport" id="rdReport" Value="A"  class="Data"<% if (strOption.equals("A") || strOption.equals("")){%> checked <%}%>  >票據統計			
            <input type="radio" name="rdReport" id="rdReport" Value="B"  class="Data"<% if (strOption.equals("B")){%> checked <%}%>  >歷史票據統計			
	        </TD>
		</TR>
		<TR rowspan=2>
			<TD align="right" class="TableHeading" width="122" rowspan="2" >日期別：</TD>
			<TD width="314">
			<input type="radio" name="para_DateType" id="para_DateType" Value="A" class="Data" <%if (strDateType.equals("A") || strDateType.equals("")){%>checked<%}%>>票據開立日
			<input type="radio" name="para_DateType" id="para_DateType" Value="B"  class="Data" <%if (strDateType.equals("B")){%> checked <%}%>>到期日
			<input type="radio" name="para_DateType" id="para_DateType" Value="C"  class="Data"<%if (strDateType.equals("C")){%> checked <%}%>>狀態日
	        </TD>
		</TR>
		<tr>
		<td><INPUT class="Data" size="11" type="text" maxlength="11" id="txtCheckStartDateC" name="txtCheckStartDateC"   onblur="checkClientField(this,true);" value=<%=strChkDateS %>>
		    <a href="javascript:show_calendar('frmMain.txtCheckStartDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
		    <INPUT	type="hidden" name="para_ChkDateS" id="para_ChkDateS" value=""> ~ 
			<INPUT class="Data" size="11" type="text" maxlength="11" id="txtCheckEndDateC" name="txtCheckEndDateC"   onblur="checkClientField(this,true);" value=<%=strChkDateE %>>
			<a	href="javascript:show_calendar('frmMain.txtCheckEndDateC','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><IMG src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢"></a> 
			<INPUT	type="hidden" name="para_ChkDateE" id="para_ChkDateE" value="">
		</td>
		</tr>
</table>

<BR>	
		<% 
		  String strAccountHold =""; 
		  if (alCDetail !=null)		      
		      {//if1
		        if(alCDetail.size()>0)
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
			           if(icurrentRec < alCDetail.size())
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
									<table border="0" cellPadding="0" cellSpacing="0" width="816"
										id="tblDetail" name='tblDetail'>
										<tbody>		       
									       	<TR>
												<TD bgcolor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="56" width="69"><b><font size="2" face="細明體">匯款銀行</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="56" width="67"><font size="2" face="細明體"><b>匯款帳號</b></font></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="56" width="64"><b><font size="2" face="細明體">票據狀態</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="56" width="64"><b><font size="2" face="細明體">總筆數</font></b></TD>	
												<TD bgColor="#c0c0c0"
													style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
													height="56" width="53"><font size="2" face="細明體"><b>總金額</b></font></TD>
											</TR>
			         <%    
			           		    }
			           		    DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO)alCDetail.get(icurrentRec);
					           String strBank="";
					           String strAccount = "";					           
                               String strStatus =""; 
                               String strStatusDes ="";                                     
					           double iPAmt = 0;
					           String strCDcnt ="" ; 
					           
			                   	if (objCDetailVO.getStrCBKNo() !=null)
					           		strBank = objCDetailVO.getStrCBKNo();
			                       if(strBank!="")
			                     	strBank = strBank.trim();
			                     					                     		    
			                     	
			                   	if (objCDetailVO.getStrCAccount() !=null)
					           		strAccount = objCDetailVO.getStrCAccount();
			                       if(strAccount!="")
			                     	strAccount = strAccount.trim();	

			                   	if (objCDetailVO.getStrCStatus() !=null)
					           		strStatus = objCDetailVO.getStrCStatus();
			                       if(strStatus!="")
			                     	strStatus = strStatus.trim();
			                    
			                    if (strStatus.equals("D"))
			                       strStatusDes="開立";
                                else if (strStatus.equals("C"))
                                   strStatusDes ="兌現";
                                else if (strStatus.equals("R"))
                                   strStatusDes ="退回";
                                else if (strStatus.equals("V"))
                                   strStatusDes ="作廢";
                                else if (strStatus.equals("1"))
                                   strStatusDes ="逾一年";
                                else if (strStatus.equals("2"))
                                   strStatusDes ="逾二年";
                                else if (strStatus.equals("3"))
                                   strStatusDes ="重印";
                                else if (strStatus.equals("4"))
                                   strStatusDes="重開";
                                else if (strStatus.equals("5"))
                                   strStatusDes ="掛失";
                                else if (strStatus.equals("6"))
                                   strStatusDes ="除權判決";
                                else
                                   strStatusDes ="庫存";            
					           	iPAmt = objCDetailVO.getICAmt();					           	
					           	strCDcnt = objCDetailVO.getStrCNo();
					           	
					           	if	( !strAccount.equals(strAccountHold)){
					           	  strAccountHold = strAccount.trim() ;
					           	%><tr></tr><tr></tr><tr></tr><%
					           	}					           	  
		%>

								<TR id=data>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										height="35" width="67"><%=strBank%></TD>
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										height="35" width="67"><%=strAccount%>&nbsp;</TD>										
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
										height="35" width="64"><%=strStatus%>:<%=strStatusDes%>&nbsp;</TD>
									<TD
										style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
										height="35" width="53"><%=strCDcnt%>&nbsp;</TD>	
									<TD
										style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid;border-bottom: 1px solid black"
										height="35" width="69"><%=df.format(iPAmt)%>&nbsp;
									</TD>	

								</TR>
				<%			
    				  if((iSeqNo == iPageSize) || (icurrentRec == (alCDetail.size()-1) ) || (iSeqNo%iPageSize == 0) )    
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
           總頁數 : <%=itotalpage%> 
	        <% 
            } //end of if2 
           }//end of if1 
           
           %>

                                                                                       

<INPUT name="txtAction" id="txtAction" type="hidden"	value="<%=strAction%>">
<INPUT name="txtMsg" 	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
<INPUT name="txtUserDept" 	id="txtUserDept" type="hidden" value="<%=strUserDept%>">
<INPUT name="txtUserRight" 	id="txtUserRight" type="hidden" value="<%=strUserRight%>">	
<INPUT name="txtUserId" 	id="txtUserId" type="hidden" value="<%=strUserId%>">


</FORM>
</BODY>
</HTML>