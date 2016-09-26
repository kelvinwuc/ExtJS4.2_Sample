package com.aegon.javamail;

/**
 * 
 * �{���W�� : AegonJavaMail.java
 * �{���ت� : �ǰe E-mail, �q���W�u���G
 * �@��     : Jerry Lin
 * �W�u��� : 2004/09/20
 * �ǤJ�Ѽ� : �ѼƤ@ : �ݨD�渹
 *            �ѼƤG : �W�u�帹
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

		Connection conn = null; // �إ߳s�u����

		try {

			Request = request.getParameter("Request");
			RequestSEQ = request.getParameter("RequestSEQ");


			conn = dbFactory.getAS400Connection("AegonJavaMail"); // �s����Ʈw

			Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); // �إ� SQL Statement ����

			String SQL = "SELECT A.UMSTAS, B.UUEMAL, C.MSRDSC "
					+ "FROM MISTOOLS/MISUPGMF A, MISTOOLS/MISUSRPF B, MISTOOLS/MISSRPF C "
					+ "where A.UMKUSR=B.UUAS and A.UMSRNO= C.MSRID and UMSRNO='" + Request + "' and UMUPNO= '" + RequestSEQ + "'";

			ResultSet RS = stmt.executeQuery(SQL); // ���� SQL , ���� ResultSet

			String to = null;
			String MainDesc = null;
			if (RS.next()) {
				to = RS.getString("UUEMAL"); // ���o����H E-mail address
				MainDesc = RS.getString("MSRDSC"); // �ݨD���e
			}
			RS.close();

			StringBuffer sendMsg = new StringBuffer();

			/*------------------------------------------------------------------------
			 * �H�󤺮e  �Ĥ@�q�q���W�u���G
			 *------------------------------------------------------------------------*/

			sendMsg.append("<TABLE border=1>");
			sendMsg.append("<TR bgcolor=#B0C4DE><TD>�ݨD�渹</TD><TD>�W�u�帹</TD><TD>�ݨD���e</TD><TD>�W�u���G</TD></TR>");
			sendMsg.append("<TR bgcolor=#DCDCDC><TD>").append(Request).append("</TD><TD>").append(RequestSEQ).append("</TD><TD>").append(MainDesc).append("</TD><TD>�w�W�u���� , ���ˬd�W�u���G�O�_���T!</TD></TR>");
			sendMsg.append("</TABLE>");
			sendMsg.append("<BR><BR>");

			/*------------------------------------------------------------------------
			 * �H�󤺮e  �ĤG�q�q���W�u����
			 *------------------------------------------------------------------------*/
			SQL = "SELECT  UGSTS,UGSRCM, UGOBJL, UGRECP, UGMSG , UGUDAY, UGUTIM , UGUUSR "
					+ "FROM MISTOOLS/MISUPLOG "
					+ "where UGSRNO='" + Request + "' and UGUPNO= '" + RequestSEQ + "'";
			RS = stmt.executeQuery(SQL);

			if (RS.next()) {
				sendMsg.append("<TABLE border=1>");
				sendMsg.append("<TR><TD bgcolor=#CC9933 colspan='7' align='center' valign='center'><B>�{���W�u Log</B></TD></TR>");
				sendMsg.append("<TR bgcolor=#CCCC33><TD>OBJECT</TD><TD>LIBRARY</TD><TD>PROCESS</TD><TD>RECOMPILE</TD><TD>�W�u���</TD><TD>�W�u�ɶ�</TD><TD>�����</TD></TR>");

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
						ugrecp = "�@";
					}

					sendMsg.append("<TR  bgcolor=#FFFF99><TD>").append(ugsrcm).append("</TD><TD>").append(ugobjl).append("</TD><TD>").append(ugmsg).append("</TD><TD>").append(ugrecp).append("</TD><TD>").append(uguday).append("</TD><TD>").append(ugutim).append("</TD><TD>").append(uguusr).append("</TD></TR>");

				}
				sendMsg.append("</TABLE>");
			}

			RS.close();

			/*--------------------------------------------------------------
			 * �]�w�U�صo�H�Ѽ�
			 *--------------------------------------------------------------*/

			response.setContentType("text/html;charset=big5");
			request.setCharacterEncoding("big5");
			String subject = "AS400 �{���W�u�q�� (";

			String from = "Computer@transglobe.com.tw";
			String personal = "Computer Center";
//			String cc = null;
//			String bcc = null;
			String smtphost = "PMWES1"; // SMTP Server

			String smtpusrid = "aegon.hinet";
			String smtpusrpsw = "70817744";
			String mailer = "My Java mailer"; // �H��n�^�W

			// �]�w SMTP���A��
			Properties props = System.getProperties();
			props.put("mail.smtp.host", smtphost);
			props.put("mail.send.user", smtpusrid);
			props.put("mail.send.password", smtpusrpsw);
			props.put("mail.smtp.auth", "false"); // ��ܭn�ϥ�id logon in
			props.put("mail.smtp.connectiontimeout", "100000"); // connection time out, default is infinite wail, but seem not work. unit is milliseconds.
			props.put("mail.smtp.timeout", "100000"); // Socket I/O timeout value in milliseconds. Default is infinite timeout.

			Session s = Session.getDefaultInstance(props, null); // ���o Session����
			MimeMessage msg = new MimeMessage(s);

			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to)); // �]�w����H

/*
			if (cc != null) {
				msg.addRecipient(Message.RecipientType.CC, new InternetAddress(cc)); // �]�w����HCC
			}

			if (bcc != null) {
				msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(bcc)); //�]�w����HBCC
			}
*/
			msg.setFrom(new InternetAddress(from, personal)); // �]�w�o�H�H

			msg.setContent(sendMsg.toString(), "text/html;charset=Big5");
			msg.setSubject(subject + Request + "-" + RequestSEQ + ")", "Big5");
			msg.setHeader("X-Mailer", mailer); // �]�w�o�H���l��n�^

			msg.setSentDate(new Date()); // �]�w���

			Transport.send(msg); // �e�X

		} catch (SQLException ee) {
			System.err.println("AS400 �{���W�u�q�� SQLException" + ee.getMessage());
			ee.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(conn != null)
				dbFactory.releaseAS400Connection(conn);
		}
	}

}
