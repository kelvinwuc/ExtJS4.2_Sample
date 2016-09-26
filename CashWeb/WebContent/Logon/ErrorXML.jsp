<%@ page contentType="text/html; charset=Big5"%>
<%@ include file="Init.inc" %>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%@ page import="java.sql.*" %>

<%@ page import="org.apache.xml.serialize.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.apache.xerces.parsers.*" %>
<%@ page import="org.xml.sax.*" %>

<%
		String strMsg = request.getParameter("txtMsg");
		int iMsgNo = 0;
		try
		{
			iMsgNo = Integer.parseInt( strMsg );
		}
		catch( Exception ex)
		{
			log("ErrorXML.jsp"+ex.getMessage() );
		}
		Document xmlDom = null;
		org.apache.xerces.parsers.DOMParser parser = new org.apache.xerces.parsers.DOMParser();
		strMsg = new String("");
		if( iMsgNo == 300 )
		{//300:session�O�s�]��
			strMsg = "���n���L,�εn�����s���w�L��,�Э��s�n�����t��(300)";
		}
		else if( iMsgNo == 301 )
		{//301:siThisSessionInfo��null
			strMsg = "SessionInfo���ť�,�Э��s�n�����t��(301)";
		}
		else if( iMsgNo == 302 )
		{//302:uiThisUserInfo��null
			strMsg = "UserInfo���ť�,�Э��s�n�����t��(302)";
		}
		else if( iMsgNo == 303 )
		{//303:checkPassword() failed
			strMsg = "���n��OK,�Э��s�n�����t��(303)";
		}
		else if( iMsgNo == 304 )
		{//304:checkPrivilege() failed
			strMsg = "�L�v������ӵ{��(304)";
		}
		else if( iMsgNo == 305 )
		{//305:system shutted down failed
			strMsg = "�t��������(305)";
		}

		try
		{	
			org.xml.sax.InputSource inputSource = new org.xml.sax.InputSource( new InputStreamReader(request.getInputStream(),"UTF-8" ) );
			parser.parse( inputSource );
			xmlDom = parser.getDocument();
			org.w3c.dom.Node nodeTmp = null ;
			org.w3c.dom.Text textTmp = null ;
			if( xmlDom.getElementsByTagName("txtMsg") != null && xmlDom.getElementsByTagName("txtMsg").getLength() != 0 )
			{
				if( xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild() == null)
				{
					nodeTmp = xmlDom.getElementsByTagName("txtMsg").item(0);
					textTmp = xmlDom.createTextNode("");
					nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
				}
			}
			else
			{
				Element elmtRoot = xmlDom.getDocumentElement();
				nodeTmp = xmlDom.createElement("txtMsg");
				textTmp = xmlDom.createTextNode("");
				nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
				elmtRoot.appendChild( nodeTmp );
			}
			xmlDom.getElementsByTagName("txtMsg").item(0).getFirstChild().setNodeValue( strMsg );
			if( xmlDom.getElementsByTagName("txtMsgNo") != null && xmlDom.getElementsByTagName("txtMsgNo").getLength() != 0 )
			{
				if( xmlDom.getElementsByTagName("txtMsgNo").item(0).getFirstChild() == null)
				{
					nodeTmp = xmlDom.getElementsByTagName("txtMsgNo").item(0);
					textTmp = xmlDom.createTextNode("");
					nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
				}
			}
			else
			{
				Element elmtRoot = xmlDom.getDocumentElement();
				nodeTmp = xmlDom.createElement("txtMsgNo");
				textTmp = xmlDom.createTextNode("");
				nodeTmp.appendChild( (org.w3c.dom.Node) textTmp );
				elmtRoot.appendChild( nodeTmp );
			}
			xmlDom.getElementsByTagName("txtMsgNo").item(0).getFirstChild().setNodeValue( String.valueOf(iMsgNo) );

			XMLSerializer ser = new XMLSerializer( out , new OutputFormat("xml","BIG5",true) );
			ser.serialize( xmlDom );
		}
		catch( Exception ex )
		{
			log("ErrorXML.jsp Exception: '"+ex.getMessage()+"'");
			ex.printStackTrace();
		}
%>
