<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ page autoFlush="true" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.aegon.crooutone.CroOutOneConditionDTO" %>
<%@ page import="com.aegon.crooutbat.CapcshfbVO" %>
<%@ page import="com.aegon.entactbat.CapcshfDTO" %>
<%@ page import="com.aegon.disb.util.DISBBean" %>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonDISB.inc" %>
<%
/**
 * System   : CashWeb
 * 
 * Function : 單筆銷帳處理
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.11 $
 * 
 * Author   : 
 * 
 * Create Date : 
 * 
 * Request ID  :
 * 
 * CVS History:
 * 
 * $Log: CroOutOneV.jsp,v $
 * Revision 1.11  2014/03/05 08:29:26  MISSALLY
 * R00135---PA0024---CASH年度專案-04
 * 修正無法取銷銷帳
 *
 * Revision 1.10  2014/02/20 06:39:22  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 還原
 *
 * Revision 1.9  2014/02/19 08:52:30  MISSALLY
 * R00135---PA0024---CASH年度專案-03
 * 還原
 *
 * Revision 1.8  2014/02/14 06:42:52  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---修正多對一時多筆不需銷帳的資料被銷到
 *
 * Revision 1.7  2014/01/28 10:34:14  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix
 *
 * Revision 1.6  2014/01/28 10:31:47  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix
 *
 * Revision 1.5  2014/01/28 06:37:34  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix
 *
 * Revision 1.4  2014/01/21 09:07:15  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---保留上次的資訊
 *
 * Revision 1.3  2014/01/15 02:30:38  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---保留上次的資訊
 *
 * Revision 1.2  2014/01/14 01:49:43  MISSALLY
 * R00135---PA0024---CASH年度專案
 * 非保費帳處理
 *
 * Revision 1.1  2014/01/03 02:51:37  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */
%><%! String strThisProgId = "CroOutOne"; //本程式代號 %><%
String strMsg = (request.getAttribute("txtMsg") == null)?"":((String)request.getAttribute("txtMsg"));
GlobalEnviron globalEnviron =	(GlobalEnviron) application.getAttribute(Constant.GLOBAL_ENVIRON);
CommonUtil commonUtil = new CommonUtil(globalEnviron);
Calendar  calendar = commonUtil.getBizDateByRCalendar();
DecimalFormat df = new DecimalFormat("#,###,###,###,###.##");
List<CapcshfDTO> fList = (session.getAttribute("fData") != null)?((List) session.getAttribute("fData")):null;
List<CapcshfbVO> fbList = (session.getAttribute("fbData") != null)?((List) session.getAttribute("fbData")):null;
CroOutOneConditionDTO coocDTO = (session.getAttribute("condition") != null)?((CroOutOneConditionDTO) session.getAttribute("condition")):null;
String strCurrentPage = (session.getAttribute("CurrentPage") != null)?((String)session.getAttribute("CurrentPage")):"1";
String defaultDate = (session.getAttribute("DefaultAegDt") != null)?((String)session.getAttribute("DefaultAegDt")):"";
if(defaultDate.length() == 7) {
	defaultDate = defaultDate.substring(0,3) + "/" + defaultDate.substring(3,5) + "/" + defaultDate.substring(5,7);
}
String strCroType = (request.getAttribute("CroType") != null)?((String)request.getAttribute("CroType")):"";
String strPoCurr = (request.getAttribute("PoCurr") != null)?((String)request.getAttribute("PoCurr")):"";

DISBBean disbBean = new DISBBean(globalEnviron);

List alCurrCash = new ArrayList();
if (session.getAttribute("CurrCashList") ==null) {
	alCurrCash = (List) disbBean.getETable("CURR", "CASH");
	session.setAttribute("CurrCashList",alCurrCash);
} else {
	alCurrCash =(List) session.getAttribute("CurrCashList");
}
Hashtable htTemp = null;
String strValue = null;
StringBuffer sbCurrCash = new StringBuffer();
if (alCurrCash.size() > 0) {
	for (int i = 0; i < alCurrCash.size(); i++) {
		htTemp = (Hashtable) alCurrCash.get(i);
		strValue = (String) htTemp.get("ETValue");
		if(strValue.equals(strPoCurr)) {
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("</option>");
		} else if(strValue.equals("NT")) {
			sbCurrCash.append("<option value=\"").append(strValue).append("\" selected>").append(strValue).append("</option>");
		} else {
			sbCurrCash.append("<option value=\"").append(strValue).append("\">").append(strValue).append("</option>");
		}
	}

	htTemp = null;
	strValue = null;
}

int iPageSize = 10;
int itotalpage = 0;
int itotalCount = 0;
double iSumAmt = 0.00;
if (fList != null)
{
	itotalCount = fList.size();
	if(itotalCount%iPageSize == 0) {
		itotalpage = itotalCount/iPageSize;
	} else {
		itotalpage = itotalCount/iPageSize + 1;
	}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=big5">
<TITLE>單筆銷帳處理</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/theme.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/graph0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/color0.css" >
<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/Theme/global/custom.css" >
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/ClientDISB.js"></SCRIPT>
<SCRIPT language="JavaScript" src="<%=request.getContextPath()%>/ScriptLibrary/Calendar.js"></SCRIPT>
<script LANGUAGE="javascript">
<!--
var iTotalrec =<%=itotalCount%>;
// *************************************************************
/* 當前端程式開始時,本函數會被執行 */
function WindowOnLoad() 
{
	if( document.getElementById("txtMsg").value != "")
		window.alert(document.getElementById("txtMsg").value);

	WindowOnLoadCommon( document.title, '', strFunctionKeyInquiry1, '' );
	window.status = "";
}

function checkClientField( objThisItem,bShowMsg )
{
	var bReturnStatus = true;
	var strTmpMsg = "";
	
	if( objThisItem.name == "bDspEAEGDT" )
	{
        bDate = true ;		
        bDate = isValidDate(objThisItem.value,'C');
        if (bDate == false){
	        strTmpMsg = "預設全球人壽入帳日-日期格式有誤";
	        bReturnStatus = false;			
        }
	}
	if( !bReturnStatus )
	{
		if( bShowMsg )
			alert( strTmpMsg );
		else
		{
    		strErrMsg += strTmpMsg + "\r\n";
		}
	}

	return bReturnStatus;
}

/* 當toolbar frame 中之<清除>按鈕被點選時,本函數會被執行 */
function resetAction()
{
	var strSaveAction = document.getElementById("txtAction").value;
	document.forms("frmMain").reset();
	document.getElementById("txtAction").value = strSaveAction;
}

/* 當toolbar frame 中之<離開>按鈕被點選時,本函數會被執行 */
function exitAction()
{
	document.getElementById("txtAction").value = "";
	document.frmMain.action="<%=request.getContextPath()%>/CroOutOne/CroOutOneC.jsp";
	document.frmMain.submit();
}

function getRmd() {
	if(document.getElementById("bDspEAEGDT").disabled) {
		return ;
	} else {
		show_calendar('frmMain.bDspEAEGDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');
	}
}

function CheckAll() {
	for ( var i = 0; i < document.frmMain.elements.length; i++) {
		var e = document.frmMain.elements[i];
		if (e.name != "chkAll")
			e.checked = !e.checked;
	}
} 

/* 當toolbar frame 中之<確定>按鈕被點選時,本函數會被執行 */
function confirmAction()
{
	mapValue();

	var varChecked = 0;
	for (var i = 0; i < iTotalrec; i++) {
		var checkId = "ch" + i;
		if (document.getElementById(checkId).checked) {
			varChecked++;
			if(document.getElementById("EN"+i) != null && document.getElementById("EN"+i).value == "") {
				document.getElementById("EN"+i).value = document.getElementById("precon").value;
			}
			document.getElementById("txtEAEGDT"+i).value = document.getElementById("txtDefaultEAEGDT").value;
		}
	}

	if(varChecked == 0) {
		alert("請勾選銷帳資料!!");
		return false;
	} else if(document.getElementById("txtDefaultEAEGDT").value == "") {
		alert("請選擇全球人壽入帳日!!");
		return false;
	} else {
		if(<%=coocDTO.getType().equals(CroOutOneConditionDTO.SPECIAL_I)%>) {
			var varMsg = "請確認是否已經新增團體入帳資料，\n\r";
			varMsg += "若已新增，請選擇「一般銷帳處理」請勿重覆新增!!";
			if(confirm(varMsg)) {
				document.getElementById("txtAction").value = "SAVE";
				document.getElementById("frmMain").submit();
			}
		} else if(<%=coocDTO.getType().equals(CroOutOneConditionDTO.NONE_PREM_CASE)%>) {
			if(document.getElementById("txtCroType").value == "C" || 
				document.getElementById("txtCroType").value == "G") {
				alert("核銷來源不正確唷!!");
				return false;
			} else {
				document.getElementById("txtAction").value = "SAVE";
				document.getElementById("frmMain").submit();
			}
		} else {
			document.getElementById("txtAction").value = "SAVE";
			document.getElementById("frmMain").submit();
		}
	}
}

function mapValue() 
{
	if(document.getElementById("bDspEAEGDT").value != "") {
		document.getElementById("txtDefaultEAEGDT").value = rocDate2String(document.getElementById("bDspEAEGDT").value);
	}
}

//取消銷帳
function cancelWriteoffs(thisRec,thisPage)
{
	var bConfirm = window.confirm("是否取消銷帳序號 " + (thisRec+1) + " ?");
	if( bConfirm )
	{
		document.getElementById("txtAction").value = "CANCEL";
		document.getElementById("txtBKCODE").value = document.getElementById("txtBKCODE"+thisRec).value;
		document.getElementById("txtBKACNT").value = document.getElementById("txtBKACNT"+thisRec).value;
		document.getElementById("txtRMDT").value = document.getElementById("txtRMDT"+thisRec).value;
		document.getElementById("txtCurrentRec").value = thisRec;
		document.getElementById("txtCurrentPage").value = thisPage;
		document.getElementById("frmMain").submit();
	}
}
//-->
</script>
</HEAD>
<BODY  onload="WindowOnLoad();">
<P><BR></P>
<form action="<%=request.getContextPath()%>/servlet/com.aegon.crooutone.CroOutOneServlet" id="frmMain" method="post" name="frmMain">
<TABLE border="0">
	<TBODY>
<% if(coocDTO.getType().equals(CroOutOneConditionDTO.SPECIAL_I)) { %>
		<TR>
			<TD colspan="6" bgcolor="#FFFF00">新增I.團體批次入帳資料</TD>
		</TR>
<% } %>
		<TR>
			<TD>預設全球人壽入帳日 :</TD>
			<TD><INPUT type="text" id="bDspEAEGDT" name="bDspEAEGDT" size="8" maxlength="9" value="<%=defaultDate.equals("")?"":defaultDate%>" class="Data" onblur="checkClientField(this,true);"><INPUT type="hidden" id="txtDefaultEAEGDT" name="txtDefaultEAEGDT" value=""></TD>
			<TD><A href="javascript:show_calendar('frmMain.bDspEAEGDT','<%=request.getContextPath()%>','<%=calendar.get(Calendar.YEAR)%>','<%=calendar.get(Calendar.MONTH)%>','<%=calendar.get(Calendar.DAY_OF_MONTH)%>');"><img  src="<%=request.getContextPath()%>/images/misc/show-calendar.gif" alt="查詢" onClick="getRmd();" ></A></TD>
			<TD>&nbsp;&nbsp;預設備註:</TD>
		    <TD><INPUT type="text" id="precon" name="precon" size="20" maxlength="40" value="" class="Data"></TD>
		    <TD>&nbsp;&nbsp;1.當同一筆登帳且多筆入帳資料時，備註欄同時輸入不同資料會以排列序號較大者儲存</TD>
		</TR>
		<TR>
			<TD>核銷來源 :</TD>
			<TD>
				<select id="txtCroType" name="txtCroType" class="Data">
					<option value="C" <%=strCroType.equals("C")?" selected=\"selected\"":""%>>Capsil</option>
					<option value="G" <%=strCroType.equals("G")?" selected=\"selected\"":""%>>GTMS</option>
					<option value="F" <%=strCroType.equals("F")?" selected=\"selected\"":""%>>FF</option>		
					<option value="T" <%=strCroType.equals("T")?" selected=\"selected\"":""%>>逾二年</option>						
					<option value="O" <%=strCroType.equals("O")?" selected=\"selected\"":""%>>Others</option>
				</select>
			</TD>
			<TD>&nbsp;&nbsp;保單幣別 :</TD>
			<TD><select size="1" name="txtPoCurr" id="txtPoCurr" class="Data"><%=sbCurrCash.toString()%></select></TD>
			<TD>&nbsp;</TD>
			<TD>&nbsp;&nbsp;2.備註欄僅限於未銷帳時才能輸入或修改</TD>
		</TR>
		<TR>
			<TD colspan="5">&nbsp;</TD>
			<TD>&nbsp;&nbsp;3.若該筆備註欄不為空白時，雖預設備註有輸入但不會更新備註欄資訊</TD>
		</TR>			
	</TBODY>
</TABLE>  
<BR>
<%	
	if (fList !=null)
	{//if1
		itotalCount = fList.size();
		if(itotalCount%iPageSize == 0) {
			itotalpage = itotalCount/iPageSize;
		} else {
			itotalpage = itotalCount/iPageSize + 1;
		}

		if(fList.size()>0)
		{//if2
			int icurrentPage = 0; // 由0開始計
			int iSeqNo = 0;
			int icurrentRec = 0;
			CapcshfDTO fdto = null;
			for (int i=0; i<itotalpage;i++)
			{
				icurrentPage = i ;
				for (int j = 0 ; j < iPageSize;j++)
				{
					iSeqNo ++;
					icurrentRec = icurrentPage * iPageSize + j ;
					if(icurrentRec < fList.size())
					{
						if( j == 0) // show table head
						{  %>
<div id="showPage<%=(icurrentPage+1)%>" <%=((icurrentPage + 1) == Integer.parseInt(strCurrentPage))?" ":" style=\"display:none\""%>>
	<table>
		<tr>
			<td><a href='javascript:ChangePage(1,<%=itotalpage%>,<%=icurrentPage+1%>,1)'> &lt;&lt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=icurrentPage%>,<%=itotalpage%>,<%=icurrentPage+1%>,2)'>&lt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=icurrentPage+2%>,<%=itotalpage%>,<%=icurrentPage+1%>,3)'>&gt;&nbsp;&nbsp;</a></td>
			<td><a href='javascript:ChangePage(<%=itotalpage%>,<%=itotalpage%>,<%=icurrentPage+1%>,4)'>&gt;&gt;&nbsp;&nbsp;</a></td>
		</tr>
	</table>
	<hr>
	<TABLE border="0">
		<TBODY>
			<TR>
				<TD>序號</TD>
				<TD>選擇</TD>
				<TD>金融單位</TD>
				<TD>帳號</TD>
				<TD>全球人壽入帳日</TD>
				<TD>金融單位匯款日</TD>
				<TD>幣別</TD>
				<TD>匯款金額</TD>
				<TD>銷帳日</TD>
				<TD>摘要</TD>
				<TD>備註</TD>
				<TD>取消銷帳</TD>
			</TR>
<%						}
						fdto = (CapcshfDTO)fList.get(icurrentRec); %>
			<TR align="center">
				<TD><%=icurrentRec+1%></TD>
				<TD><input type="checkbox" id="ch<%=icurrentRec%>" name="ch<%=icurrentRec%>" value="Y"></TD>
				<TD><%=fdto.getEBKCD()%><INPUT type="hidden" id="txtBKCODE<%=icurrentRec%>" name="txtBKCODE<%=icurrentRec%>" value="<%=fdto.getEBKCD()%>"></TD>
				<TD><%=fdto.getEATNO()%><INPUT type="hidden" id="txtBKACNT<%=icurrentRec%>" name="txtBKACNT<%=icurrentRec%>" value="<%=fdto.getEATNO()%>"></TD>
				<TD><%=(fdto.getEAEGDT() ==0)?"":String.valueOf(fdto.getEAEGDT() )%><INPUT type="hidden" id="txtEAEGDT<%=icurrentRec%>" name="txtEAEGDT<%=icurrentRec%>" value="<%=(fdto.getEAEGDT() ==0)?"":String.valueOf(fdto.getEAEGDT())%>"></TD>
				<TD><%=(fdto.getEBKRMD()==0)?"":String.valueOf(fdto.getEBKRMD())%><INPUT type="hidden" id="txtRMDT<%=icurrentRec%>" name="txtRMDT<%=icurrentRec%>" value="<%=fdto.getEBKRMD()%>"></TD>
				<TD><%=fdto.getCSHFCURR()%></TD>
				<TD align="right"><%=df.format(fdto.getENTAMT())%><INPUT type="hidden" id="txtMAMT<%=icurrentRec%>" name="txtMAMT<%=icurrentRec%>" value="<%=fdto.getENTAMT()%>"></TD>
				<TD><%=(fdto.getECRDAY().equals("0"))?"":fdto.getECRDAY()%></TD>
				<TD align="left"><%=fdto.getEUSREM()%></TD>
				<TD align="left"><input type="text" id="EN<%=icurrentRec%>" name="EN<%=icurrentRec%>" value="<%=fdto.getEUSREM2()%>" size="30"></TD>
<% 						if(fdto.getECRDAY().equals("0")) {  %>
				<TD>&nbsp;</TD>
<% 						} else {  %>
				<TD><INPUT type="button" name="cancelButtom" value="取消" onclick="cancelWriteoffs(<%=icurrentRec%>,<%=icurrentPage+1%>);"></TD>
<% 						}  %>
			</TR>
<%						if((iSeqNo == iPageSize) || (icurrentRec == (fList.size()-1) ) || (iSeqNo%iPageSize == 0) ) { %>
		</TBODY>
	</TABLE>
</div>		
<%						}
					} // end of if --> inowRec < list.size()
				}// end of for -- show detail
			}//end of for  %>
<TABLE border="0">
	<TBODY>
		<TR>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD colspan="2"><input type="checkbox" id="chkAll" name="chkAll" onclick="CheckAll();"></TD>
			<TD>&nbsp;&nbsp;全選</TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD>總筆數:<%=itotalCount%></TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD>總頁數:<%=itotalpage%></TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD colspan="5">&nbsp;</TD>
		</TR>
	</TBODY>
</TABLE>
<%		} //end of if2
	}//end of if1

	CapcshfbVO fbdto = null;
	if(fbList !=null && fbList.size() > 0) {  %>
<BR><BR><hr>
<TABLE border="0">
	<TBODY>
		<TR><TD colspan="9">保費入帳資訊</TD></TR>
		<TR>
			<TD>金融單位</TD>
			<TD>帳號</TD>
			<TD>全球人壽入帳日</TD>
			<TD>金融單位匯款日</TD>
			<TD>幣別</TD>
			<TD>匯款金額</TD>
			<TD>送金單號碼</TD>
			<TD>送金單序號</TD>
			<TD>保單號碼</TD>
		</TR>
<%		for(int i=0; i<fbList.size(); i++) {
			fbdto = (CapcshfbVO)fbList.get(i);  %>
		<TR align="center">
			<TD><%=fbdto.getCBKCD()%><INPUT type="hidden" id="txtCBKCD<%=i%>" name="txtCBKCD<%=i%>" value="<%=fbdto.getCBKCD()%>"></TD>
			<TD><%=fbdto.getCATNO()%><INPUT type="hidden" id="txtCATNO<%=i%>" name="txtCATNO<%=i%>" value="<%=fbdto.getCATNO()%>"></TD>
			<TD><%=(fbdto.getCAEGDT()==0)?"":String.valueOf(fbdto.getCAEGDT())%><INPUT type="hidden" id="txtCAEGDT<%=i%>" name="txtCAEGDT<%=i%>" value="<%=(fbdto.getCAEGDT()==0)?"":String.valueOf(fbdto.getCAEGDT())%>"></TD>
			<TD><%=(fbdto.getCBKRMD()==0)?"":String.valueOf(fbdto.getCBKRMD())%><INPUT type="hidden" id="txtCBKRMD<%=i%>" name="txtCBKRMD<%=i%>" value="<%=fbdto.getCBKRMD()%>"></TD>
			<TD><%=fbdto.getCCURR()%></TD>
			<TD align="right"><%=df.format(fbdto.getCROAMT())%></TD>
			<TD><%=fbdto.getCSFBRECTNO()%></TD>
			<TD><%=fbdto.getCSFBRECSEQ()%></TD>
			<TD><%=fbdto.getCSFBPONO()%></TD>
		</TR>
<%		}  %>
	</TBODY>
</TABLE>
<%	}  %>

<INPUT type="hidden" id="txtBKCODE" name="txtBKCODE" value="">
<INPUT type="hidden" id="txtBKACNT" name="txtBKACNT" value="">
<INPUT type="hidden" id="txtRMDT" name="txtRMDT" value="">
<INPUT type="hidden" id="txtCurrentRec" name="txtCurrentRec" value="">
<INPUT type="hidden" id="txtCurrentPage" name="txtCurrentPage" value="">
<INPUT type="hidden" id="txtAction" name="txtAction" value="">
<INPUT type="hidden" id="txtMsg" name="txtMsg" value="<%=strMsg%>">
</form>
</BODY>
</HTML>