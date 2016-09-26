package com.aegon.logon;

import java.io.IOException;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import com.aegon.comlib.AuditLogBean;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.EncryptionBean;
import com.aegon.comlib.GlobalEnviron;
import com.aegon.comlib.RootClass;
import com.aegon.comlib.SessionInfo;
import com.aegon.comlib.UserInfo;

public class LogonBean extends HttpServlet {

	final static int AUTH_TYPE_PASSWORD = 1;
	final static int AUTH_TYPE_SECRET_WORD = 2;
	final static int AUTH_TYPE_USER_DEFINE = 3;
	final static String strPasswordChangeUrl = "/PasswordChange/index.html";

	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CurrentUserList currentUserList = null;
	private EncryptionBean encoder = null;

	class LogonBindingListener extends RootClass implements HttpSessionBindingListener, Serializable {

		// constructor
		public LogonBindingListener() {
		}

		public synchronized void valueBound(HttpSessionBindingEvent event) {
			currentUserList.add(event.getSession());
			log("Binding --> " + event.getSession().getId() + System.getProperty("line.separator") + currentUserList.dumpData());
		}

		public synchronized void valueUnbound(HttpSessionBindingEvent event) {
			currentUserList.remove(event.getSession());
			log("Unbinding --> " + event.getSession().getId() + System.getProperty("line.separator") + currentUserList.dumpData());
		}

		private void log(String logMessage) {
			System.out.println(System.getProperty("line.separator") + "==========" + System.getProperty("line.separator") + logMessage + System.getProperty("line.separator") + "==========" + System.getProperty("line.separator"));
		}

	}

	private class DataClass {
		// Input parameter
		public String userId = "";
		public String userPassword = "";
		public int authType = AUTH_TYPE_PASSWORD; // default setting
		public String nextUrl = "/NewMenu/index.html"; // next page for valid user
		public String callerUrl = "";
		public String errorUrl = ""; // error page for invalid user
		public String secretAnswer = "";
		public boolean isRemoveAll = false; // 是否移除同一 User id 的 session

		// result
		public boolean passCheck = false; // 檢核結果
		public int checkResultCode = 0; // 檢核結果代碼
		public String checkResultMessage = null; // message to caller

		//
		public HttpSession session = null;
		public SessionInfo sessionInfo = null;
		public boolean checkConcurrentUser = true; // 是否需檢查 concurrent user

		// constructor
		public DataClass(HttpSession thisSession, HttpServletRequest req) {
			session = thisSession;
		}
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession(true);
		RequestDispatcher dispatcher = null;

		// create parameter object
		DataClass thisData = new DataClass(session, req);

		dbFactory.setRootFolder(req.getContextPath());

		// get input parameter
		if (getInputParameter(req, thisData)) {
			// process logon
			checkLogon(thisData);
			// setting session attribute
			session.setAttribute("PasswordAging", new Integer(0));
			session.setAttribute("PasswordAgingMsg", "");
			session.setAttribute(Constant.LOGON_USER_ID, thisData.userId);
			session.setAttribute(Constant.LOGON_USER_NAME, thisData.sessionInfo.getUserInfo().getUserName());
			session.setAttribute(Constant.LOGON_USER_TYPE, thisData.sessionInfo.getUserInfo().getUserType());
			session.setAttribute(Constant.LOGON_USER_DEPT, thisData.sessionInfo.getUserInfo().getUserDept());
			session.setAttribute(Constant.LOGON_USER_AREA, thisData.sessionInfo.getUserInfo().getUserArea());//RC0036
			session.setAttribute(Constant.LOGON_USER_BRCH, thisData.sessionInfo.getUserInfo().getUserBrch());//RC0036
			session.setAttribute(Constant.LOGON_USER_RIGHT, thisData.sessionInfo.getUserInfo().getUserRight());
			session.setAttribute(Constant.ACTIVE_USER_ID, thisData.userId);
			session.setAttribute(Constant.ACTIVE_USER_NAME, thisData.sessionInfo.getUserInfo().getUserName());
			session.setAttribute(Constant.ACTIVE_USER_TYPE, thisData.sessionInfo.getUserInfo().getUserType());
			session.setAttribute(Constant.COMPANY_CODE, "  ");
			session.setAttribute(Constant.SESSION_INFO, thisData.sessionInfo);

			AuditLogBean auditLogBean = new AuditLogBean(globalEnviron, dbFactory);

			auditLogBean.setSessionId(session.getId());
			thisData.sessionInfo.setAuditLogBean(auditLogBean);

			if (thisData.passCheck) {

				// ok -> add current user -> next page
				if (thisData.isRemoveAll) {
					currentUserList.removeAll(thisData.userId);
				}

				// check current user
				if (thisData.checkConcurrentUser) {
					if (currentUserList.isExist(thisData.userId)) {
						thisData.nextUrl = thisData.callerUrl;
						// thisData.callerUrl = "/Test/Hello.jsp";
						req.setAttribute("txtConfirmMessage", "帳號 " + thisData.userId + " 已登入本系統，是否繼續作業 ? ");
						// System.out.println("thisData.callerUrl='" + thisData.callerUrl + "' ");
						thisData.sessionInfo.getAuditLogBean().writeAuditLog("Logon", thisData.userId, "L", "重覆登入 !");
						thisData.callerUrl = addParameter(thisData.callerUrl);
						dispatcher = req.getRequestDispatcher(thisData.callerUrl);
						dispatcher.forward(req, resp);
						// resp.sendRedirect(thisData.callerUrl);
						return;
					}
				}
				// check password aging
				if (thisData.checkResultCode != 0) {
					req.setAttribute("txtReturnCode", String.valueOf(thisData.checkResultCode));
					session.setAttribute("PasswordAging", new Integer(thisData.checkResultCode));
					session.setAttribute("PasswordAgingMsg", thisData.checkResultMessage);
					switch (thisData.checkResultCode) {
					case 1: // 1:密碼過期,2:進入警告期,9:第一次登錄系統
					case 2:
					case 9:
						thisData.nextUrl = strPasswordChangeUrl.trim();
						break;
					}
				}
				// add this user to concurrent user list
				session.setAttribute("binding.listener", new LogonBindingListener());
				thisData.sessionInfo.getAuditLogBean().writeAuditLog("Logon", thisData.userId, "L", "Logon successful!");
				System.out.println("thisData.nextUrl='" + thisData.nextUrl + "'");
				dispatcher = req.getRequestDispatcher(thisData.nextUrl);
				dispatcher.forward(req, resp);
				return;
			} else {
				// fail -> send error message -> caller
				if (thisData.checkResultMessage != null) {
					req.setAttribute("txtMsg", thisData.checkResultMessage);
				}
				thisData.sessionInfo.getAuditLogBean().writeAuditLog("Logon", thisData.userId, "L", thisData.checkResultMessage);
				thisData.callerUrl = addParameter(thisData.callerUrl);
				dispatcher = req.getRequestDispatcher(thisData.callerUrl);
				dispatcher.forward(req, resp);
				return;
			}

		} else {
			// error occurred when getting input parameters
			// System.out.println("thisData.errorUrl='" + thisData.errorUrl + "' ");
			thisData.sessionInfo.getAuditLogBean().writeAuditLog("Logon", thisData.userId, "L", thisData.checkResultMessage);
			dispatcher = req.getRequestDispatcher(thisData.errorUrl);
			dispatcher.forward(req, resp);
			return;
		}
	}

	private void checkLogon(DataClass thisData) {

		UserInfo thisUserInfo = thisData.sessionInfo.getUserInfo();

		if (thisUserInfo == null) {
			thisData.checkResultMessage = "Can't create UserInfo object !";
			return;
		}
		thisUserInfo.setSessionId(thisData.session.getId());
		thisUserInfo.setDebug(thisData.sessionInfo.getDebug());

		if (thisUserInfo.setUserId(thisData.userId)) {
			if (thisUserInfo.checkUserStatus()) {

				boolean hasError = false;
				if (!hasError) {
					int authType = thisData.authType;
					switch (authType) {
					case (AUTH_TYPE_PASSWORD):
						thisUserInfo.setCheckPasswordAging(true);
						int iPasswordAging = thisUserInfo.checkPassword(thisData.userPassword);
						// iPasswordAging == 0 密碼正確
						// iPasswordAging == 1 密碼已超過36天期限, 36天在
						// AppStartUpServlet.servlet 中設定
						// iPasswordAging == 2 密碼更改期限已少於7天警告期 , 7天在
						// AppStartUpServlet.servlet 中設定
						// iPasswordAging == 9 密碼正確,第一次登錄系統
						// 其餘均有錯誤

						if (iPasswordAging == 0 || iPasswordAging == 1
								|| iPasswordAging == 2 || iPasswordAging == 9) {
							thisData.passCheck = true;
							thisData.checkResultCode = iPasswordAging;
							thisData.checkResultMessage = thisUserInfo.getLastErrorMessage();
						} else {
							thisData.passCheck = false;
							thisData.checkResultCode = iPasswordAging;
							thisData.checkResultMessage = thisUserInfo.getLastErrorMessage();
						}
						break;
					case (AUTH_TYPE_SECRET_WORD):
						if (checkAnswer(thisData)) {
							thisData.passCheck = true;
							thisData.checkResultCode = 0;
							thisData.checkResultMessage = "";
							// reset password
							if (!resetPassword(thisData)) {
								thisData.passCheck = false;
								thisData.checkResultCode = -1;
								thisData.checkResultMessage = "重設密碼失敗 !";
							}
						} else {
							thisData.passCheck = false;
							thisData.checkResultCode = -1;
							thisData.checkResultMessage = "密碼提示語答案不正確 !";
						}
						break;
					case (AUTH_TYPE_USER_DEFINE):
						break;
					}
				} else {
					// agent status is invalid
					thisData.passCheck = false;
					thisData.checkResultCode = -1;
					thisData.checkResultMessage = thisUserInfo.getLastErrorMessage();
				}
			} else {
				// user status error
				// thisData.sessionInfo.getAuditLogBean().writeAuditLog("Logon", thisData.userId, "L", thisUserInfo.getLastErrorMessage());
				thisData.passCheck = false;
				thisData.checkResultCode = -1;
				thisData.checkResultMessage = thisUserInfo.getLastErrorMessage();
			}
		} else {
			// error occurred when setting user id
			thisData.passCheck = false;
			thisData.checkResultCode = -1;
			thisData.checkResultMessage = thisUserInfo.getLastErrorMessage();
		}
	}

	/**
	 * Method checkAnswer.
	 * 
	 * @param thisData
	 * @return boolean
	 * 
	 *         檢查密碼提示語答案是否正確
	 */
	private boolean checkAnswer(DataClass thisData) {
		boolean returnStatus = true;
		String strSql = "select SCTA fro USER where USRID='" + thisData.userId + "' ";
		Connection con = dbFactory.getConnection("LogonBean.checkAnswer()");
		Statement stmt = null;
		ResultSet rst = null;
		try {
			stmt = con.createStatement();
			rst = stmt.executeQuery(strSql);
			String strAnswer = "";
			if (rst.next()) {
				strAnswer = rst.getString("SCTA");
			}
			if (strAnswer != null && thisData.secretAnswer != null && strAnswer.equals(thisData.secretAnswer)) {
				returnStatus = true;
			} else {
				returnStatus = false;
			}
		} catch (SQLException ex) {
			returnStatus = false;
			thisData.sessionInfo.writeDebugLog(Constant.DEBUG_ERROR, "Logon.checkAnswer()", ex.getMessage());
		} finally {
			try {
				if (rst != null) {
					rst.close();
				}
				if (stmt != null) {
					stmt.close();
				}
				if (con != null) {
					dbFactory.releaseConnection(con);
				}
			} catch (Exception ex1) {
				thisData.sessionInfo.writeDebugLog(Constant.DEBUG_ERROR, "Logon.checkAnswer()", ex1.getMessage());
			}
		}
		return returnStatus;
	}

	/**
	 * Method resetPassword.
	 * 
	 * @param thisData
	 * @return boolean
	 * 
	 *         將新設定的密碼存入 tUser
	 */
	private boolean resetPassword(DataClass thisData) {
		boolean returnStatus = true;
		Connection con = dbFactory.getConnection("LogonBean.resetPassword()");
		Statement stmt = null;
		String sqlUpdate = "update USER set PWD='" + encoder.getEncryptedPassword(thisData.userPassword) + "' where USRID='" + thisData.userId + "' ";
		try {
			stmt = con.createStatement();
			if (stmt.executeUpdate(sqlUpdate) < 1) {
				returnStatus = false;
				thisData.sessionInfo.writeDebugLog(Constant.DEBUG_DEBUG, "Logon.resetPassword()", "Nothing update!");
			}
		} catch (SQLException ex) {
			returnStatus = false;
			thisData.sessionInfo.writeDebugLog(Constant.DEBUG_ERROR, "Logon.resetPassword()", ex.getMessage());
		} finally {
			try {
				if (stmt != null) {
					stmt.close();
				}
				if (con != null) {
					dbFactory.releaseConnection(con);
				}
			} catch (SQLException ex1) {
			}
		}

		return returnStatus;
	}

	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON) != null) {
			globalEnviron = (GlobalEnviron) getServletContext().getAttribute(Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);

		}
		if (encoder == null) {
			encoder = new EncryptionBean(dbFactory);
		}
		if (currentUserList == null) {
			// currentUserList = CurrentUserList.getInstance();
			if (getServletContext().getAttribute("currentUserList") != null) {
				try {
					currentUserList = (CurrentUserList) getServletContext().getAttribute("currentUserList");
				} catch (ClassCastException ex) {
				}
			}
			if (currentUserList == null) {
				currentUserList = new CurrentUserList();
				getServletContext().setAttribute("currentUserList", currentUserList);
			}
		}
	}

	private boolean getInputParameter(HttpServletRequest request, DataClass dataObject) {

		boolean returnStatus = true;
		String urlPrefix = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();

		if (request.getParameter("txtUserId") != null) {
			dataObject.userId = request.getParameter("txtUserId").trim();
			String tmpLogonUserId = null;
			SessionInfo tmpSessionInfo = null;

			// Process with SessionInfo object
			System.out.println("Session ID=" + request.getSession().getId());
			if (request.getSession().getAttribute(Constant.SESSION_INFO) != null) {
				tmpSessionInfo = (SessionInfo) request.getSession(false).getAttribute(Constant.SESSION_INFO);
				tmpLogonUserId = tmpSessionInfo.getUserInfo().getUserId();
			}
			if (tmpLogonUserId == null || !tmpLogonUserId.equals(dataObject.userId)) {
				// dataObject.sessionInfo = new SessionInfo(dbFactory, dataObject.userId);
				dataObject.sessionInfo = new SessionInfo(dbFactory);
			} else {
				dataObject.sessionInfo = tmpSessionInfo;
			}

			if (request.getParameter("txtPassword") != null) {
				dataObject.userPassword = request.getParameter("txtPassword").trim();
			}
			if (request.getParameter("txtAuthType") != null) {
				try {
					dataObject.authType = Integer.parseInt(request.getParameter("txtAuthType").trim(), 10);
				} catch (NumberFormatException ex) {
					returnStatus = false;
					dataObject.checkResultMessage = "認證方式代碼錯誤 !";
				}
			}
			if (request.getParameter("txtNextUrl") != null) {
				dataObject.nextUrl = urlPrefix + request.getParameter("txtNextUrl").trim();
			}
			if (request.getParameter("txtCallerUrl") != null) {
				// dataObject.callerUrl = urlPrefix + request.getParameter("txtCallerUrl");
				dataObject.callerUrl = request.getParameter("txtCallerUrl");
			} else {
				dataObject.callerUrl = request.getHeader("referer");
				if (dataObject.callerUrl == null) {
					dataObject.callerUrl = "";
				}
			}

			if (request.getParameter("txtErrorUrl") != null) {
				dataObject.errorUrl = urlPrefix + request.getParameter("txtErrorUrl").trim();
			} else {
				dataObject.errorUrl = dataObject.callerUrl;
			}

			if (request.getParameter("txtSecretAnswer") != null) {
				dataObject.secretAnswer = request.getParameter("txtSecretAnswer").trim();
			}
			if (request.getParameter("txtRemoveAll") != null) {
				if (request.getParameter("txtRemoveAll").equalsIgnoreCase("TRUE")) {
					dataObject.isRemoveAll = true;
				} else {
					dataObject.isRemoveAll = false;
				}
			}

		} else {
			dataObject.checkResultMessage = "帳號空白 !";
			returnStatus = false;
		}

		return returnStatus;

	}

	private String addParameter(String thisUrl) {
		StringBuffer sb = new StringBuffer(thisUrl);
		if (thisUrl.indexOf('?') != -1) {
			sb.append("&fromLogonBean=true");
		} else {
			sb.append("?fromLogonBean=true");
		}
		return sb.toString();
	}

}
