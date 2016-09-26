/**
 * 
 * 程式名稱 : AS400Notice.java
 * 程式目的 : 呼叫 AP Server上的 AegonJavaMail , 通知上線結果
 * 作者           : Jerry
 * 上線日期 : 2004/09/20
 * 傳入參數 : 參數一 : 需求單號
 *           參數二 : 上線批號
 * 程式存放位置 : AS400 : javapgm目錄下
 * 說明           : 在正式環境 AEGON400 時 , http://10.67.0.35 正式環境 AP Server
 * 
 */

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

public class AS400Notice extends Object {

	// URL要更改成相對應的位置
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
