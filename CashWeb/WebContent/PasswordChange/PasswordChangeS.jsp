<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5" %>
<%@ page autoFlush="true"  %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.aegon.comlib.Constant" %>
<%@ page import="com.aegon.comlib.CommonUtil" %>
<%@ page import="com.aegon.comlib.EncryptionBean" %>
<%@ page import="com.aegon.comlib.SessionInfo" %>
<%@ page import="com.aegon.comlib.UserInfo" %>
<%@ page import="com.aegon.logon.CheckPasswordClient"%>
<%@ include file="/Logon/Init.inc" %>
<%!
/**
 * System   : 
 * 
 * Function : �ӤH��ƺ��@
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.4 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date: ${date}
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: PasswordChangeS.jsp,v $
 * Revision 1.4  2013/12/18 07:22:52  MISSALLY
 * RB0302---�s�W�I�ڤ覡�{��
 *
 * Revision 1.3  2011/08/09 01:34:10  MISSALLY
 * Q10256�@ ����CASH�t�ο��~�L�k�]�X����
 *
 *  
 */
%><%
SessionInfo siThisSessionInfo = (SessionInfo)session.getAttribute(Constant.SESSION_INFO);
UserInfo uiThisUserInfo = siThisSessionInfo.getUserInfo();

String strThisProgId = "PasswordChange"; //���{���N��
String strCheckPasswordUrl = "http://10.67.0.110:9080/CSIS/servlet/com.aegon.logon.CheckPassword";

String strClientMsg = "";
String strAction = request.getParameter("txtAction");

String strUserId = uiThisUserInfo.getUserId();
String strUserType = "H";		//�ϥΪ����O
String strPassword = request.getParameter("txtPassword");		//�ϥΪ̱K�X
String strConfirmPassword = request.getParameter("txtConfirmPassword"); //�T�{�ϥΪ̱K�X
String strEmail = request.getParameter("txtEmail");				//email�b��
String strSecretQuestion = request.getParameter("txtSecretQuestion");	//�K�X���ܻy���D
String strSecretAnswer = request.getParameter("txtSecretAnswer");		//�K�X���ܻy����

String strOrgPwdStat = request.getParameter("txtorgPwdStat");

boolean bPasswordEncryption = uiThisUserInfo.getDbFactory().getGlobalEnviron().getPasswordEncrypted();
EncryptionBean encoder = new EncryptionBean(uiThisUserInfo.getDbFactory());
boolean bCaseSenstive = uiThisUserInfo.getDbFactory().getGlobalEnviron().getPasswordCaseSenstivity();

CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
Calendar cldCalendar = commonUtil.getBizDateByRCalendar();

if(strAction != null && strAction.equalsIgnoreCase("U")) {
	//�ˬd�Ҧ������
	if (strPassword.equals("") && strConfirmPassword.equals("")) {
		//���ק�K�X
	} else {
		if (!strPassword.equals(strConfirmPassword)) {
			strClientMsg = "�ϥΪ̱K�X�����n�P�T�{�K�X�ۦP";
			siThisSessionInfo.setLastError(strThisProgId + ":checkFieldsServer()", "�ϥΪ̱K�X�����n�P�T�{�K�X�ۦP");
		} else {
			CheckPasswordClient.setServerUrl(strCheckPasswordUrl);
			String[] chkPassReturn = CheckPasswordClient.getCheckResult("CashWeb", strUserId, strPassword, strUserType, "F");
			if (!chkPassReturn[0].equals("0")) {
				strClientMsg = chkPassReturn[2];
				siThisSessionInfo.setLastError(strThisProgId + ":checkFieldsServer()", chkPassReturn[2]);
			}
		}
	}
	if (!strClientMsg.equals("")) {
		strClientMsg = siThisSessionInfo.getLastErrorMessage();
		session.setAttribute("PasswordAging", new Integer(3));
		session.setAttribute("PasswordAgingMsg", strClientMsg);
	} else {
		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rst = null;
		try {
			conn = uiThisUserInfo.getDbFactory().getConnection("PasswordChange");
			//�ˮ֥D��ȬO�_�s�b���Ʈw��
			pstmt = conn.prepareStatement("select * from USER where USRID = ?");
			pstmt.setString(1, strUserId);
			rst = pstmt.executeQuery();
			if (!rst.next()) {
				strClientMsg = "�ϥΪ̥N�� '" + strUserId + "' ���s�b���Ʈw��";
				siThisSessionInfo.setLastError(strThisProgId + ":updateDb()", "�ϥΪ̥N�� '" + strUserId + "' ���s�b���Ʈw��");
			} else {
				//��s�ӵ����
				String strUpdateSql = "update USER set ";
				strUpdateSql += " Email = '" + strEmail + "' ";
				strUpdateSql += ", SCTQ = '" + strSecretQuestion + "'";
				strUpdateSql += ", SCTA = '" + strSecretAnswer + "'";
				strUpdateSql += ", LUPDT = '" + commonUtil.convertWesten2ROCDate1(cldCalendar.getTime()) + "'";
				if (!strPassword.equals("")) {
					if (!bCaseSenstive)
						strPassword = strPassword.toUpperCase();
					if (bPasswordEncryption)
						strUpdateSql += ", PWD = '" + encoder.getEncryptedPassword(strPassword) + "' ";
					else
						strUpdateSql += ", PWD = '" + strPassword + "' ";

					strUpdateSql += ", LPWDTE = '" + commonUtil.convertWesten2ROCDate1(cldCalendar.getTime()) + "' ";
				}
				strUpdateSql += " where USRID = '" + strUserId + "'";
				siThisSessionInfo.writeDebugLog(Constant.DEBUG_DEBUG, "UPDATE USER SQL="+strUpdateSql);

				stmt = conn.createStatement();
				int iReturn = stmt.executeUpdate(strUpdateSql);
				if (iReturn != 1) {
					strClientMsg = "The update sql return != 1 return = '" + String.valueOf(iReturn) + "'";
					siThisSessionInfo.setLastError(strThisProgId + ":updateDb()", "The update sql return != 1 return = '" + String.valueOf(iReturn) + "'");
				} else {
					strClientMsg = "'" + strUserId + "'�ק令�\";
					siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId, strUserId, strAction, strUserId);
					session.setAttribute("PasswordAging", new Integer(0));
					session.setAttribute("PasswordAgingMsg", "");
				}
			}
		} catch (SQLException ex) {
			siThisSessionInfo.setLastError(strThisProgId, ex);
		} finally {
			try { if(rst != null) rst.close(); } catch (Exception e) { }
			try { if(stmt != null) stmt.close(); } catch (Exception e) { }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) { }
			try { if(conn != null) uiThisUserInfo.getDbFactory().releaseConnection(conn); } catch (Exception e) { }
		}
	}
}

request.getRequestDispatcher("PasswordChangeC.jsp?txtMsg="+strClientMsg+"&txtorgPwdStat="+strOrgPwdStat).forward(request,response);
return;
%>