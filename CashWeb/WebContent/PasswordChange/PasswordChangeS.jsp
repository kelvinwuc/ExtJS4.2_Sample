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
 * Function : 個人資料維護
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
 * RB0302---新增付款方式現金
 *
 * Revision 1.3  2011/08/09 01:34:10  MISSALLY
 * Q10256　 有關CASH系統錯誤無法跑出報表
 *
 *  
 */
%><%
SessionInfo siThisSessionInfo = (SessionInfo)session.getAttribute(Constant.SESSION_INFO);
UserInfo uiThisUserInfo = siThisSessionInfo.getUserInfo();

String strThisProgId = "PasswordChange"; //本程式代號
String strCheckPasswordUrl = "http://10.67.0.110:9080/CSIS/servlet/com.aegon.logon.CheckPassword";

String strClientMsg = "";
String strAction = request.getParameter("txtAction");

String strUserId = uiThisUserInfo.getUserId();
String strUserType = "H";		//使用者類別
String strPassword = request.getParameter("txtPassword");		//使用者密碼
String strConfirmPassword = request.getParameter("txtConfirmPassword"); //確認使用者密碼
String strEmail = request.getParameter("txtEmail");				//email帳號
String strSecretQuestion = request.getParameter("txtSecretQuestion");	//密碼提示語問題
String strSecretAnswer = request.getParameter("txtSecretAnswer");		//密碼提示語答案

String strOrgPwdStat = request.getParameter("txtorgPwdStat");

boolean bPasswordEncryption = uiThisUserInfo.getDbFactory().getGlobalEnviron().getPasswordEncrypted();
EncryptionBean encoder = new EncryptionBean(uiThisUserInfo.getDbFactory());
boolean bCaseSenstive = uiThisUserInfo.getDbFactory().getGlobalEnviron().getPasswordCaseSenstivity();

CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
Calendar cldCalendar = commonUtil.getBizDateByRCalendar();

if(strAction != null && strAction.equalsIgnoreCase("U")) {
	//檢查所有的欄位
	if (strPassword.equals("") && strConfirmPassword.equals("")) {
		//不修改密碼
	} else {
		if (!strPassword.equals(strConfirmPassword)) {
			strClientMsg = "使用者密碼必須要與確認密碼相同";
			siThisSessionInfo.setLastError(strThisProgId + ":checkFieldsServer()", "使用者密碼必須要與確認密碼相同");
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
			//檢核主鍵值是否存在於資料庫中
			pstmt = conn.prepareStatement("select * from USER where USRID = ?");
			pstmt.setString(1, strUserId);
			rst = pstmt.executeQuery();
			if (!rst.next()) {
				strClientMsg = "使用者代號 '" + strUserId + "' 未存在於資料庫中";
				siThisSessionInfo.setLastError(strThisProgId + ":updateDb()", "使用者代號 '" + strUserId + "' 未存在於資料庫中");
			} else {
				//更新該筆資料
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
					strClientMsg = "'" + strUserId + "'修改成功";
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