package com.aegon.javamail;

/**
 * 
 * 程式名稱 : AegonJavaMail.java
 * 程式目的 : 傳送 E-mail, 通知上線結果
 * 作者     : Jerry Lin
 * 上線日期 : 2004/09/20
 * 傳入參數 : 參數一 : 需求單號
 *            參數二 : 上線批號
 * 
 */

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.Date;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;

public class AegonJavaMail extends HttpServlet {

	String Request = "";
	String RequestSEQ = "";

	private DbFactory dbFactory = null;

	public void init() {
		dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Connection conn = null; // 建立連線物件

		try {

			Request = request.getParameter("Request");
			RequestSEQ = request.getParameter("RequestSEQ");


			conn = dbFactory.getAS400Connection("AegonJavaMail"); // 連接資料庫

			Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); // 建立 SQL Statement 物件

			String SQL = "SELECT A.UMSTAS, B.UUEMAL, C.MSRDSC "
					+ "FROM MISTOOLS/MISUPGMF A, MISTOOLS/MISUSRPF B, MISTOOLS/MISSRPF C "
					+ "where A.UMKUSR=B.UUAS and A.UMSRNO= C.MSRID and UMSRNO='" + Request + "' and UMUPNO= '" + RequestSEQ + "'";

			ResultSet RS = stmt.executeQuery(SQL); // 執行 SQL , 產生 ResultSet

			String to = null;
			String MainDesc = null;
			if (RS.next()) {
				to = RS.getString("UUEMAL"); // 取得收件人 E-mail address
				MainDesc = RS.getString("MSRDSC"); // 需求內容
			}
			RS.close();

			StringBuffer sendMsg = new StringBuffer();

			/*------------------------------------------------------------------------
			 * 信件內容  第一段通知上線結果
			 *------------------------------------------------------------------------*/

			sendMsg.append("<TABLE border=1>");
			sendMsg.append("<TR bgcolor=#B0C4DE><TD>需求單號</TD><TD>上線批號</TD><TD>需求內容</TD><TD>上線結果</TD></TR>");
			sendMsg.append("<TR bgcolor=#DCDCDC><TD>").append(Request).append("</TD><TD>").append(RequestSEQ).append("</TD><TD>").append(MainDesc).append("</TD><TD>已上線完畢 , 請檢查上線結果是否正確!</TD></TR>");
			sendMsg.append("</TABLE>");
			sendMsg.append("<BR><BR>");

			/*------------------------------------------------------------------------
			 * 信件內容  第二段通知上線明細
			 *------------------------------------------------------------------------*/
			SQL = "SELECT  UGSTS,UGSRCM, UGOBJL, UGRECP, UGMSG , UGUDAY, UGUTIM , UGUUSR "
					+ "FROM MISTOOLS/MISUPLOG "
					+ "where UGSRNO='" + Request + "' and UGUPNO= '" + RequestSEQ + "'";
			RS = stmt.executeQuery(SQL);

			if (RS.next()) {
				sendMsg.append("<TABLE border=1>");
				sendMsg.append("<TR><TD bgcolor=#CC9933 colspan='7' align='center' valign='center'><B>程式上線 Log</B></TD></TR>");
				sendMsg.append("<TR bgcolor=#CCCC33><TD>OBJECT</TD><TD>LIBRARY</TD><TD>PROCESS</TD><TD>RECOMPILE</TD><TD>上線日期</TD><TD>上線時間</TD><TD>執行者</TD></TR>");

				String ugsrcm = null;
				String ugobjl = null;
				String ugmsg = null;
				String ugrecp = null;
				String uguday = null;
				String ugutim = null;
				String uguusr = null;

				RS.beforeFirst();
				while (RS.next()) {

					ugsrcm = RS.getString("UGSRCM");
					ugobjl = RS.getString("UGOBJL");
					if (RS.getString("UGSTS").equals("Y")) {
						ugmsg = RS.getString("UGMSG");
					} else {
						ugmsg = "<FONT COLOR=#FF0033><B>" + RS.getString("UGMSG") + "</B></FONT>";
					}
					ugrecp = RS.getString("UGRECP").toUpperCase();
					uguday = RS.getString("UGUDAY");
					ugutim = RS.getString("UGUTIM");
					uguusr = RS.getString("UGUUSR");

					if (ugrecp.equals("Y")) {
						ugrecp = "Recompile";
					} else {
						ugrecp = "　";
					}

					sendMsg.append("<TR  bgcolor=#FFFF99><TD>").append(ugsrcm).append("</TD><TD>").append(ugobjl).append("</TD><TD>").append(ugmsg).append("</TD><TD>").append(ugrecp).append("</TD><TD>").append(uguday).append("</TD><TD>").append(ugutim).append("</TD><TD>").append(uguusr).append("</TD></TR>");

				}
				sendMsg.append("</TABLE>");
			}

			RS.close();

			/*--------------------------------------------------------------
			 * 設定各種發信參數
			 *--------------------------------------------------------------*/

			response.setContentType("text/html;charset=big5");
			request.setCharacterEncoding("big5");
			String subject = "AS400 程式上線通知 (";

			String from = "Computer@transglobe.com.tw";
			String personal = "Computer Center";
//			String cc = null;
//			String bcc = null;
			String smtphost = "PMWES1"; // SMTP Server

			String smtpusrid = "aegon.hinet";
			String smtpusrpsw = "70817744";
			String mailer = "My Java mailer"; // 寄件軟体名

			// 設定 SMTP伺服器
			Properties props = System.getProperties();
			props.put("mail.smtp.host", smtphost);
			props.put("mail.send.user", smtpusrid);
			props.put("mail.send.password", smtpusrpsw);
			props.put("mail.smtp.auth", "false"); // 表示要使用id logon in
			props.put("mail.smtp.connectiontimeout", "100000"); // connection time out, default is infinite wail, but seem not work. unit is milliseconds.
			props.put("mail.smtp.timeout", "100000"); // Socket I/O timeout value in milliseconds. Default is infinite timeout.

			Session s = Session.getDefaultInstance(props, null); // 取得 Session物件
			MimeMessage msg = new MimeMessage(s);

			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to)); // 設定收件人

/*
			if (cc != null) {
				msg.addRecipient(Message.RecipientType.CC, new InternetAddress(cc)); // 設定收件人CC
			}

			if (bcc != null) {
				msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(bcc)); //設定收件人BCC
			}
*/
			msg.setFrom(new InternetAddress(from, personal)); // 設定發信人

			msg.setContent(sendMsg.toString(), "text/html;charset=Big5");
			msg.setSubject(subject + Request + "-" + RequestSEQ + ")", "Big5");
			msg.setHeader("X-Mailer", mailer); // 設定發信的郵件軟体

			msg.setSentDate(new Date()); // 設定日期

			Transport.send(msg); // 送出

		} catch (SQLException ee) {
			System.err.println("AS400 程式上線通知 SQLException" + ee.getMessage());
			ee.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(conn != null)
				dbFactory.releaseAS400Connection(conn);
		}
	}

}
