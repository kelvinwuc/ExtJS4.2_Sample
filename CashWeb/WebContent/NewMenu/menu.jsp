<%@  page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"  %>
<%//@ page contentType="text/html;charset=BIG5" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="com.aegon.servlet.*" %>
<%
/**
�{���W��:	CheckLogon.jsp
�{���\��:	�ˬd�C�@��{���O�_�g�L���`��Logon�{��,�Y�S��,�hredirect��Logon.jsp
		����槹����,�h�|�w�q��ӭ��n������:
			siThisSessionInfo:���ε{����Session����
			uiThisUserInfo:	���ε{�����ϥΪ̸�ƪ���
�ǤJ�Ѽ�:
�Ǧ^��:
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
        
	String strTmpStrLogon = null;
	SessionInfo siThisSessionInfo = null;
	UserInfo uiThisUserInfo = null;
        
	if( session.isNew() )
	{//�Ysession�O�s�]��,�h��ܥ��gLogon�{��,�����\����
		strTmpStrLogon = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/NSOASIS/Logon/Logon.jsp?txtMsg=300";
		response.sendRedirect(strTmpStrLogon);
                
	}
        
	//��session���NSessionInfo���^,�Ӫ��󤺦s�����������ܼƸ��(global environmental information)
	siThisSessionInfo = (SessionInfo)session.getAttribute(Constant.SESSION_INFO);
	if( siThisSessionInfo == null )
	{//siThisSessionInfo��null��ܥ��g�L�n���{��,��ܢڢ����������
		strTmpStrLogon = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/FinWeb/Logon/StaffLogon.jsp?txtMsg=301";
		response.sendRedirect(strTmpStrLogon);
	}
	else
	{//�ˬd�O�_���ڢ�������L
        
		if( request.getParameter("txtDebug") != null )
		{
			try
			{
				int i;
				i = Integer.parseInt( request.getParameter("txtDebug") );
				if( i >= 0 &&  i <= Constant.MAX_DEBUG_LEVEL )
					siThisSessionInfo.setDebug(i);
				else
					siThisSessionInfo.writeDebugLog(Constant.DEBUG_WARNING,"CheckLogon.jsp","The input parameter of txtDebug is invalid txtDebug = '"+request.getParameter("txtDebug")+"',it must between 0 to "+String.valueOf(Constant.MAX_DEBUG_LEVEL));
			}
			catch( Exception e )
			{
				siThisSessionInfo.setLastError("CheckLogon.jsp","The format of input parameter of txtDebug is invalid txtDebug = '"+request.getParameter("txtDebug")+"'");
			}
		}
            
		if( siThisSessionInfo.getUserInfo() == null )
		{
			strTmpStrLogon = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/NSOASIS/Logon/Logon.jsp?txtMsg=302";
			response.sendRedirect(strTmpStrLogon);
		}
		else
		{
                       
			uiThisUserInfo = siThisSessionInfo.getUserInfo();
                        
			uiThisUserInfo.setDebug(siThisSessionInfo.getDebug());
                        
            
			if( !uiThisUserInfo.isPasswordChecked() )
			{
				strTmpStrLogon = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/CashWeb/Logon/StaffLogon.jsp?txtMsg=303";
				response.sendRedirect(strTmpStrLogon);
			}
                      
//			if( !uiThisUserInfo.checkPrivilege(strThisProgId) )
  //                      {//�ˬd�ӨϥΪ̬O�_���v���楻�{��
	//			strTmpStrLogon = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/NSOASIS/Logon/Logon.jsp?txtMsg=304";
	//			response.sendRedirect(strTmpStrLogon);
	//		}
                        
		}
        
	}
	MenuBean thisMenu = new MenuBean( siThisSessionInfo.getUserInfo());
        
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<HTML>
<HEAD>
<META name="GENERATOR" content="IBM WebSphere Page Designer V3.5 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>
menu page
</TITLE>
<link rel="stylesheet" href="../Theme/menu.css"></link>

<!--<BODY  background="../images/misc/AegonLight.gif">-->
<script>
var oTitle = "";
var iTitle = 0;

//HV Menu- by Ger Versluis (http://www.burmees.nl/)
//Submitted to Dynamic Drive (http://www.dynamicdrive.com)
//Visit http://www.dynamicdrive.com for this script and more

//function Go(){return}
function disableAllSelect()
{
	var objDocument = window.top.contentFrame.document;
	var formSelects = objDocument.getElementsByTagName("SELECT");
	if( formSelects != null )
	{
		for(var i=0;i< formSelects.length;i++)
		{
			formSelects.item(i).style.display = "none";
		}
	}
	
}

function enableAllSelect()
{
	var objDocument = window.top.contentFrame.document;
	var formSelects = objDocument.getElementsByTagName("SELECT");
	if( formSelects != null )
	{
		for(var i=0;i< formSelects.length;i++)
		{
			formSelects.item(i).style.display = "block";
		}
	}
	
}

function HitCount(strLabel,strHitCountUrl)
{
	var i,j;
	try
	{
		if( window.top.frames.length != 0 )
		{
			i = 0;
			while( i < window.top.frames.length )
			{
				var winTarget = window.top.frames[i];
				if( winTarget.name == 'titleFrame' )
				{
					iTitle = i;
					oTitle = window.setInterval("checkTitleWindow('"+strLabel+"','"+strHitCountUrl+"')",1000);
				}
				i++;
			}
		} 
	}
	catch(e)
	{
	}
}

/*
��ƦW��:	checkTitleWindow(strLabel,strHitCountUrl)
��ƥ\��:	�ˬdtitle frame�������O�_ready,�btitle frame ready��,�p�ƾ�
�ǤJ�Ѽ�:	string	strLabel : �p�ƾ��W��
			string  strHitCountUrl: �p�ƾ�url
�Ǧ^��:		�L
�ק����:	�ק���	�ק��	��   ��   �K   �n
		---------	----------	-----------------------------------------
*/
function checkTitleWindow(strLabel,strHitCountUrl)
{
	winTitle = window.parent.frames['titleFrame'];
	if( winTitle.document.getElementById("MainBody") != null )
	{
		if( oTitle != "" )
		{
			window.clearInterval(oTitle);
			oTitle = "";
		}
		//winTitle.HitCount(strLabel,strHitCountUrl);
	}
}




</script>
<script type='text/javascript' >
/***********************************************************************************
*	(c) Ger Versluis 2000 version 5.411 24 December 2001 (updated Jan 31st, 2003 by Dynamic Drive for Opera7)
*	For info write to menus@burmees.nl		          *
*	You may remove all comments for faster loading	          *		
***********************************************************************************/

	var LowBgColor='#2183D0';			// Background color when mouse is not over
	var LowSubBgColor='#2183D0';			// Background color when mouse is not over on subs
	var HighBgColor='#999999';			// Background color when mouse is over
	var HighSubBgColor='#999999';			// Background color when mouse is over on subs
	var FontLowColor='white';			// Font color when mouse is not over
	var FontSubLowColor='white';			// Font color subs when mouse is not over
	var FontHighColor='white';			// Font color when mouse is over
	var FontSubHighColor='white';			// Font color subs when mouse is over
	var BorderColor='white';			// Border color
	var BorderSubColor='white';			// Border color for subs
	var BorderWidth=1;				// Border width
	var BorderBtwnElmnts=1;			// Border between elements 1 or 0
	var FontFamily="�ө���,�s�ө���,�з���"	// Font family menu items
	var FontSize=10;				// Font size menu items
	var FontBold=0;				// Bold menu items 1 or 0
	var FontItalic=0;				// Italic menu items 1 or 0
	var MenuTextCentered='left';			// Item text position 'left', 'center' or 'right'
	var MenuCentered='left';			// Menu horizontal position 'left', 'center' or 'right'
	var MenuVerticalCentered='top';		// Menu vertical position 'top', 'middle','bottom' or static
	var ChildOverlap=.2;				// horizontal overlap child/ parent
	var ChildVerticalOverlap=.2;			// vertical overlap child/ parent
	var StartTop=0;				// Menu offset x coordinate
	var StartLeft=0;				// Menu offset y coordinate
	var VerCorrect=5;				// Multiple frames y correction
	var HorCorrect=0;				// Multiple frames x correction
	var LeftPaddng=2;				// Left padding
	var TopPaddng=4;				// Top padding
	var FirstLineHorizontal=0;			// SET TO 1 FOR HORIZONTAL MENU, 0 FOR VERTICAL
	var MenuFramesVertical=1;			// Frames in cols or rows 1 or 0
	var DissapearDelay=1000;			// delay before menu folds in
	var TakeOverBgColor=1;			// Menu frame takes over background color subitem frame
	var FirstLineFrame='menuFrame';			// Frame where first level appears
	var SecLineFrame='contentFrame';			// Frame where sub levels appear
	var DocTargetFrame='contentFrame';			// Frame where target documents appear
	var TargetLoc='';				// span id for relative positioning
	var HideTop=0;				// Hide first level when loading new document 1 or 0
	var MenuWrap=1;				// enables/ disables menu wrap 1 or 0
	var RightToLeft=0;				// enables/ disables right to left unfold 1 or 0
	var UnfoldsOnClick=0;			// Level 1 unfolds onclick/ onmouseover
	var WebMasterCheck=0;			// menu tree checking on or off 1 or 0
	var ShowArrow=1;				// Uses arrow gifs when 1
	var KeepHilite=0;				// Keep selected path highligthed
	var Arrws=['../images/misc/tri.gif',5,10,'../images/misc/tridown.gif',10,5,'../images/misc/trileft.gif',5,10];	// Arrow source, width and height
	var HitCountHeight=25;			//�p�ƾ�����
	var HitCountWidth=120;			//�p�ƾ��e��

<%
	out.println("\tvar NoOffFirstLineMenus="+thisMenu.getNoOffFirstLineMenus()+";			// Number of first level items");
%>


function BeforeStart(){return}
function AfterBuild()
{
	return;
}
function BeforeFirstOpen()
{
	disableAllSelect();
}
function AfterCloseAll(){enableAllSelect();}


// Menu tree
//	MenuX=new Array(Text to show, Link, background image (optional), number of sub elements, height, width);
//	For rollover images set "Text to show" to:  "rollover:Image1.jpg:Image2.jpg"

<%
	if( siThisSessionInfo == null )
	{
		%>
		alert("<H1>The siThisSessionInfo is null</H1>");
		<%
	}
	else
	{
		if( siThisSessionInfo.getUserInfo() == null )
		{
			%>
			alert("<H1>The UserInfo of siThisSessionInfo is null</H1>");
			<%
		}
		else
		{
			if( thisMenu == null )
			{
				%>
				alert("thisMenu is null ");
				<%
			}
			else
			{
				out.println(thisMenu.getHvMenuHtml(20,119));
			}
		}
	}
%>

function logoff(){
	window.open("../Logon/CloseWindow.jsp","dummy");		
}
</script>
<script type='text/javascript' src='../ScriptLibrary/Menu.js'></script>
</HEAD>
<BODY style="background-color:#DFDFDF" onunload="logoff()">
<IFRAME id='dummy' name='dummy' width='0' height='0' src='blank1.html'></IFRAME>
</BODY>
</HTML>
