package com.aegon.logon;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Iterator;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;

import com.aegon.comlib.RootClass;


public class CheckPasswordClient extends RootClass {

	static String strServerUrl = "";

	/*
	public static void main(String[] args) {

		String[] result = getCheckResult("Testing", "Disen", "a456bbbC9", "N", "F");

		System.out.println("return code           :" + result[0]);
		System.out.println("return message english:" + result[1]);
		System.out.println("return message chinese:" + result[2]);

		try {
			System.out.println("getCheckMessageC:" + getCheckMessageC(new String("Sys123".getBytes("MS950"), "UTF8"),"Disen","a456bbbCk","N","F"));
		} catch (UnsupportedEncodingException ex) {
			System.out.println(ex.getMessage());
		}
	
//		System.out.println(getXML("Testing", "Disen", "a456bbbC9", "N", "F"));

		//test2(test1("Testing", "Disen", "a456bbbC9", "N", "F"));
	}
	 */
	public static boolean setServerUrl(String newUrl) {
		strServerUrl = newUrl;
		return true;
	}

	public static String getCheckCode(String strSystem,String strUserId,String strPassword,String strUserType,String strCaseSensitive) {

		String[] sa1 = getCheckResult(strSystem, strUserId, strPassword, strUserType, strCaseSensitive);

		return sa1[0];

	}

	public static String getCheckMessageE(String strSystem,String strUserId,String strPassword,String strUserType,String strCaseSensitive) {

		String[] sa1 = getCheckResult(strSystem, strUserId, strPassword, strUserType, strCaseSensitive);

		return sa1[1];

	}

	public static String getCheckMessageC(String strSystem,String strUserId,String strPassword,String strUserType,String strCaseSensitive) {

		String[] sa1 = getCheckResult(strSystem, strUserId, strPassword, strUserType, strCaseSensitive);

		return sa1[2];
	}

	public static String[] getCheckResult(String strSystem,String strUserId,String strPassword,String strUserType,String strCaseSensitive) {

		String[] sa1 = new String[3];

		org.jdom.Document docReturn = null;
		
		// for debug
		System.out.println(strSystem+","+strUserId+","+ strPassword+","+strUserType+","+ strCaseSensitive);

		checkParameter(strSystem, strUserId, strPassword, strUserType, strCaseSensitive);

		docReturn = checkPassword(strSystem, strUserId, strPassword, strUserType, strCaseSensitive);
		if (docReturn == null) {
			sa1[0] = "-99";
			sa1[1] = "Error occurred when connect to server !";
			sa1[2] = "無法取得回應 !";
			return sa1;
		}

		Iterator ite = docReturn.getRootElement().getChildren().iterator();
		for (int i = 0; ite.hasNext(); i++) {
			sa1[i] = ((org.jdom.Element) ite.next()).getText();
		}

		return sa1;
	}

	public static String getXML(String strSystem,String strUserId,String strPassword,String strUserType,String strCaseSensitive) {

		org.jdom.Document docReturn = checkPassword(strSystem, strUserId, strPassword, strUserType, strCaseSensitive);
		XMLOutputter fmt = new XMLOutputter();
		String result = null;

		result = new String(fmt.outputString(docReturn));

		return result;
	}

	private static void checkParameter(String strSystem,String strUserId,String strPassword,String strUserType,String strCaseSensitive) {

		if (strSystem == null)
			strSystem = "";
		if (strUserId == null)
			strUserId = "";
		if (strPassword == null)
			strPassword = "";
		if (strUserType == null)
			strUserType = "";
		if (strCaseSensitive == null)
			strCaseSensitive = "";
		return;
	}

	private static org.jdom.Document checkPassword(String strSystem,String strUserId,String strPassword,String strUserType,String strCaseSensitive) {

		// Create Document
		Document docReturn = null;
		Document docSend = new Document(new Element("request").addContent(new Element("systemId").setText(strSystem)).addContent(new Element("userId").setText(strUserId)).addContent(new Element("password").setText(strPassword)).addContent(new Element("userType").setText(strUserType)).addContent(new Element("caseSensitive").setText(strCaseSensitive)));

		// Connect Server
		URLConnection httpCon = null;
		URL httpServer = null;
		try {
			httpServer = new URL(strServerUrl);
			httpCon = httpServer.openConnection();
		} catch (IOException ex) {
			System.err.println("Error occurred when connect to server!");
			System.err.println("CheckPasswordClient: checkPassword() ->" + ex.getMessage());
			return null;
		}
		httpCon.setDoOutput(true);
		httpCon.setDoInput(true);

		//Send Message
		PrintWriter out = null;
		try {
			out = new PrintWriter(httpCon.getOutputStream());
			// Print XML
			XMLOutputter fmt = new XMLOutputter();
			fmt.output(docSend, out);
		} catch (IOException ioe) {
			System.err.println("Error occurred when Sending xml request !");
			ioe.printStackTrace(System.err);
		} finally {
			if(out!=null){
				out.close();
			}
		}

		SAXBuilder builder = new SAXBuilder();
		try {
			docReturn = builder.build(new InputStreamReader(httpCon.getInputStream(), "UTF-8"));
		} catch (UnsupportedEncodingException ex) {
			System.err.println("Error when create Document !(UnsupportedEncodingException)");
			System.err.println("CheckPasswordClient: checkPassword() ->" + ex.getMessage());
		} catch (JDOMException ex) {
			System.err.println("Error when create Document !(JDOMException)");
			System.err.println("CheckPasswordClient: checkPassword() ->" + ex.getMessage());

		} catch (IOException ex) {
			System.err.println("Error when create Document !(IOException)");
			System.err.println("CheckPasswordClient: checkPassword() ->" + ex.getMessage());
		}

		return docReturn;
	}


}
