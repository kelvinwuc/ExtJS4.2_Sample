<%
/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   �ݨD�渹       �ק��                �ק��    			  �ק鷺�e
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393      Leo Huang    			2010/09/17           �{�b�ɶ���Capsil��B�ɶ�
 *    R00393      Leo Huang    			2010/09/17           ������|��۹���|
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
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.DbFactory" %>
<%@ page import="com.aegon.disb.util.DISBPaymentDetailVO"%>

<%//R00393%>
<!--# include virtual="/Logon/Init.inc"-->
<!--# include virtual="/Logon/CheckLogonDISB.inc"-->

<%!String strThisProgId = "DISBCheckCreateBatch"; //���{���N��%>
<%
//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar cldCalendar = Calendar.getInstance(TimeZone.getTimeZone(Constant.TIME_ZONE),		Constant.CURRENT_LOCALE);
//R00393  Edit by Leo Huang (EASONTECH) End
SimpleDateFormat sdfDateFormatter =	new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", java.util.Locale.TAIWAN);
SimpleDateFormat sdfDate =	new SimpleDateFormat("yyyyMMdd", java.util.Locale.TAIWAN);
SimpleDateFormat sdfTime =	new SimpleDateFormat("hhmmss", java.util.Locale.TAIWAN);

GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
DbFactory dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);

DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
//R00393  Edit by Leo Huang (EASONTECH) Start
//java.util.Date dteToday = cldCalendar.getTime(); //�ثe����ɶ�
java.util.Date dteToday = new CommonUtil(globalEnviron).getBizDateByRDate();
//R00393  Edit by Leo Huang (EASONTECH) End
List alPDetail = new ArrayList();
int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
int itotalRecord = 0;

//System.out.println(iPageSize);
if(session.getAttribute("PDetailListTmpBatch") !=null)
{
  alPDetail = (List)session.getAttribute("PDetailListTmpBatch");
  if (alPDetail!=null)
   {
    if (alPDetail.size()>0)
    {
  		  for (int k = 0 ; k < alPDetail.size();k++)
         {
            	DISBPaymentDetailVO objPDetailCounter = (DISBPaymentDetailVO)alPDetail.get(k);
            	
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
  session.removeAttribute("PDetailListTmpBatch");
   String strRec = "";
  if (request.getAttribute("txtRec") != null) {
    strRec = (String) request.getAttribute("txtRec");
   }  
   String strSum = "";
  if (request.getAttribute("txtSum") != null) {
    strSum = (String) request.getAttribute("txtSum");
   }  
    

  String strAction = "";
  if (request.getAttribute("txtAction") != null) {
    strAction = (String) request.getAttribute("txtAction");
   }  
  
  String strReturnMessage = "";
  if (request.getAttribute("txtMsg") != null) {
    strReturnMessage = (String) request.getAttribute("txtMsg");
  }  
  //System.out.println("msg:" + strReturnMessage);
%>
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
 * Create Date : $Date: 2014/08/05 03:18:05 $
 * 
 * Request ID :
 * 
 
 */
-->

<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=BIG5">
<META name="GENERATOR" content="IBM WebSphere Studio">
<TITLE>�X�Ǩt��--���H�u�}��</TITLE>
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/theme.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/graph0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/color0.css">
<LINK REL="stylesheet" TYPE="text/css"	HREF="<%=request.getContextPath()%>/Theme/global/custom.css">
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">

var strFirstKey 			= "selPBBank";			//�Ĥ@�ӥi��J��Key���W��
var strFirstData 			= "txtPStartDateC";		//�Ĥ@�ӥi��J��Data���W��
var strServerProgram 		= "UserMaintainS.jsp";		//Post��Server��,�n�I�s���{���W��

// *************************************************************
/*
��ƦW��:	WindowOnLoad()
��ƥ\��:	��e�ݵ{���}�l��,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function WindowOnLoad() 
{
	
	if( document.getElementById("txtMsg").value != "")
	{
		window.alert(document.getElementById("txtMsg").value) ;
		//R00393 
		//window.location.href= "/CashWeb/DISB/DISBCheck/DISBCheckCreateBatch.jsp";
		window.location.href= "<%=request.getContextPath()%>/DISB/DISBCheck/DISBCheckCreateBatch.jsp";
	}	

     if (document.getElementById("txtAction").value == "I")
	{
     	//WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyCC,'' ) ;
     	WindowOnLoadCommon( document.title+"(�d��)" , '' , strFunctionKeyInquiry1,'' ) ;
     }	
     else
     {
     	//WindowOnLoadCommon( document.title+"(�d��)" , '' , strFunctionKeyInquiry1,'' ) ;
     	WindowOnLoadCommon( document.title , '' , strDISBFunctionKeyCC,'' ) ;
     }
   
}


/*
��ƦW��:	resetAction()
��ƥ\��:	��toolbar frame ����<�M��>���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/*
��ƦW��:	exitAction()
��ƥ\��:	��toolbar frame ����<���}>���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function exitAction()
{
	history.back();
/*	winToolBar.ShowButton( strFunctionKeyInitial );
	document.getElementById("txtAction").value = "";
	disableAll();
*/	
}

/*
��ƦW��:	confirmAction()
��ƥ\��:	��toolbar frame �����T�w���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function confirmAction()
{
       var strConfirmMsg = "�O�_�T�w�n����H�u�}���@�~?\n";
	    var bConfirm = window.confirm(strConfirmMsg);
		if( bConfirm )
		{
          document.getElementById("txtAction").value = "DISBCheckCreate";
          document.getElementById("frmMain2").submit();
		}
}
/*
��ƦW��:	DISBCCreateAction()
��ƥ\��:	��toolbar frame ����<�H�u�}��>���s�Q�I���,����Ʒ|�Q����
�ǤJ�Ѽ�:	�L
�Ǧ^��:	�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function DISBCCreateAction()
{
			document.getElementById("txtAction").value = "I";
			document.forms("frmMain").submit();			  
}
</SCRIPT>
</HEAD>
<BODY ONLOAD="WindowOnLoad()">
<% if(request.getAttribute("txtAction") == null){ %>
<!--R00393 Edit by Leo Huang (EASONTECH) Start
<form  ENCTYPE="multipart/form-data"  id="frmMain" method="post" name="frmMain" 
action="/CashWeb/servlet/com.aegon.disb.disbcheck.DISBCheckCreateBatchServlet?action=inquiry" >
-->
<form  ENCTYPE="multipart/form-data"  id="frmMain" method="post" name="frmMain" 
action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckCreateBatchServlet?action=inquiry" >
<!--R00393 Edit by Leo Huang (EASONTECH) Start-->
<TABLE border="1" width="452" id=inqueryArea name=inqueryArea>
	<TBODY>
		<TR>
		</tr>
		<TR>
			<TD align="right" class="TableHeading" width="101">�ɮצW�١G</TD>
			<TD>
	<INPUT TYPE="FILE"  name="UPFILE"  id="UPFILE"></TD>
		</TR>
	</TBODY>
</TABLE>
</form>
<%}%>

<!--R00393 Edit by Leo Huang (EASONTECH) Start
<form action="/CashWeb/servlet/com.aegon.disb.disbcheck.DISBCheckCreateBatchServlet"
	id="frmMain2" method="post" name="frmMain2">
	-->
<form action="<%=request.getContextPath()%>/servlet/com.aegon.disb.disbcheck.DISBCheckCreateBatchServlet"
	id="frmMain2" method="post" name="frmMain2">
<!--R00393 Edit by Leo Huang (EASONTECH) End-->
<BR>
<% if (alPDetail !=null)
    {//if1
      if(alPDetail.size()>0)
        {//if2
	        int icurrentRec = 0;
	        int icurrentPage = 0; // ��0�}�l�p
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
			           	  if((icurrentPage + 1) == 1){
	 	  				   %><div id=showPage<%=icurrentPage+1%> style="display:"><%
							}else{
							%><div id=showPage<%=icurrentPage+1%> style="display:none"><%}%>  
							  <table boder=1>
								<tr>
								<td><a href='javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage+1%>,1)'> &lt;&lt;&nbsp;&nbsp;</a></td>
								<td><a href='javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage+1%>,2)'>&lt;&nbsp;&nbsp;</a></td>
								<td><a href='javascript:ChangePage(<%=icurrentPage+2%>,<%=itotalpage%>,<%=icurrentPage+1%>,3)'>&gt;&nbsp;&nbsp;</a></td>
								<td><a href='javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage+1%>,4)'>&gt;&gt;&nbsp;&nbsp;</a></td>
								</tr>
								</table>
								<hr>															
								<table border="1" cellPadding="0" cellSpacing="0" width=""
										id="tblDetail" name='tblDetail' HEIGHT="100" >
										<tbody>		       
									       	<TR>
												<TD class="TableHeading" width="101">�O�渹�X</TD>
												<TD class="TableHeading" width="101">�I�ڤ��</TD>
												<TD class="TableHeading" width="101">���ڸ��X</TD>
												<TD class="TableHeading" width="101">�X�Ǥ��</TD>
												<TD class="TableHeading" width="101">���ڨ����</TD>
												<TD class="TableHeading" width="101">�׶O</TD>
												<TD class="TableHeading" width="101">��I���B</TD>
											</TR>
			         <%}			           		    			           				           		    
			           		   DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)alPDetail.get(icurrentRec);
					           String strPNo = "";
					           String strPolNo = "";
					           double iPAmt = 0;
					           String strPAmt="";
					           int iFee = 0;
					           String strFee="";
					           int iPDate = 0;
					           String strPDate ="";
					           int iCQDate = 0;
					           String strCQDate ="";
					           String strCheckNO = "";
					           int iCSHDate = 0;
					           String strCSHDate ="";
					           
					           //
					           iCSHDate = objPDetailVO.getIPCshDt();	  					          
					           if(iCSHDate != 0)
					           	   strCSHDate = Integer.toString(iCSHDate);
					           else
					           	   strCSHDate ="";
					           
					           //
					           if (objPDetailVO.getStrPolicyNo()!=null)
					           	  strPolNo = objPDetailVO.getStrPolicyNo();
			                   if(strPolNo!="")
			                   	  strPolNo= strPolNo.trim();		
					           	//
					           	 iPAmt = objPDetailVO.getIPAMT();
					           	 if (iPAmt == 0)
					           	   strPAmt = "";
					           	 else
					           	   //strPAmt = Integer.toString(iPAmt);   
					           	   strPAmt = Double.toString( iPAmt);
					           	//
					           	  iPDate = objPDetailVO.getIPDate();	  					          
					           	  if(iPDate != 0)
					           	   strPDate = Integer.toString(iPDate);
					           	  else
					           	   strPDate ="";
					           	//
					           	  iCQDate = objPDetailVO.getICQDate();	  					          
					           	  if(iCQDate != 0)
					           	   strCQDate = Integer.toString(iCQDate);
					           	  else
					           	   strCQDate ="";
                                //
                                if (objPDetailVO.getStrPCheckNO() != null)  
				           		    strCheckNO = objPDetailVO.getStrPCheckNO();						           			
				           		else
				           		    strCheckNO = "";
					           	//
					           	 iFee = objPDetailVO.getIRmtFee();
					           	 if (iFee == 0)
					           	   strFee = "";
					           	 else
					           	   strFee =Integer.toString(iFee);  
				           		    				           		
		                        %>
								<TR id=data>
									<TD><%=strPolNo%>&nbsp;</TD>
									<TD><%=strPDate%>&nbsp;</TD>
									<TD><%=strCheckNO%>&nbsp;</TD>
									<TD><%=strCSHDate%>&nbsp;</TD>
									<TD><%=strCQDate%>&nbsp;</TD>
									<TD><%=strFee%>&nbsp;</TD>
									<TD><%=strPAmt%>&nbsp;</TD>
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
        �`���� : <%=itotalpage%> &nbsp;&nbsp;�`��� : <%=strRec%> &nbsp;&nbsp;�`���B :<%=strSum%> &nbsp; 
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
													height="30" ><b><font size="2" face="�ө���">�O�渹�X</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><b><font size="2" face="�ө���">�I�ڤ��</font></b></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="30" ><font size="2" face="�ө���"><b>���ڸ��X</b></font></TD>
												<TD bgColor="#c0c0c0"
													style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
													 height="30"><font size="2" face="�ө���"><b>�X�Ǥ��</b></font></TD>
												<TD bgColor="#c0c0c0"
													style="border-right: 1px solid black; BORDER-LEFT: black 1px solid; border-top: 1px solid black; border-bottom: 1px solid black"
													 height="30"><font size="2" face="�ө���"><b>���ڨ����</b></font></TD>
												<TD bgColor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													height="30" ><font size="2" face="�ө���"><b>�׶O</b></font></TD>
												<TD bgcolor="#c0c0c0"
													style="BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid"
													 height="30"><b><font size="2" face="�ө���">��I���B</font></b></TD>
       	
		</TR>
			</tbody>
</table>
		<%}%>


<INPUT name="txtAction" id="txtAction" type="hidden"	value="<%=strAction%>"> 
<INPUT name="txtRec" id="txtRec" type="hidden"	value=""> 
<INPUT name="txtSum" id="txtSum" type="hidden"	value=""> 
<INPUT name="txtMsg"	id="txtMsg" type="hidden" value="<%=strReturnMessage%>">
</FORM>

</BODY>
</HTML>
