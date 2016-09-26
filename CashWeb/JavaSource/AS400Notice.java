/**
 * 
 * �{���W�� : AS400Notice.java
 * �{���ت� : �I�s AP Server�W�� AegonJavaMail , �q���W�u���G
 * �@��           : Jerry
 * �W�u��� : 2004/09/20
 * �ǤJ�Ѽ� : �ѼƤ@ : �ݨD�渹
 *           �ѼƤG : �W�u�帹
 * �{���s���m : AS400 : javapgm�ؿ��U
 * ����           : �b�������� AEGON400 �� , http://10.67.0.35 �������� AP Server
 * 
 */

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

public class AS400Notice extends Object {

	// URL�n��令�۹�������m
	// public String urlJavaMail =
	// "http://10.67.0.21:9080/CashWeb/servlet/com.aegon.javamail.AegonJavaMail?";
	// RC0036 public String urlJavaMail = "http://10.67.0.35:9080/CashWeb/servlet/com.aegon.javamail.AegonJavaMail?";
	//RC0036
	public String urlJavaMail = "http://10.67.0.208:9080/CashWeb/servlet/com.aegon.javamail.AegonJavaMail?";

	public AS400Notice() {
		super();
	}

	public static void main(String[] args) {

		AS400Notice cb = new AS400Notice();
		cb.urlJavaMail += "Request=" + args[0] + "&RequestSEQ=" + args[1];
		URL webURL = null;
		try {
			webURL = new URL(cb.urlJavaMail);
			BufferedReader is = new BufferedReader(new InputStreamReader(webURL.openStream()));
			is.close();
		} catch (MalformedURLException e) {
			System.err.println("Load failed: " + e);
		} catch (IOException e) {
			System.err.println("IOException: " + e);
		}

	}

}
