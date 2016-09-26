package com.aegon;

import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.GlobalEnviron;

public class AppStartUpServlet extends javax.servlet.http.HttpServlet
{
	private GlobalEnviron globalEnviron = null;
	private ServletContext application = null;
	private DbFactory dbFactory = null;

	public void destroy() {
		super.destroy();
	}

	public void init(ServletConfig sc) throws ServletException {
		super.init(sc);
		application = getServletContext();
		globalEnviron = new GlobalEnviron();
		globalEnviron.setServletContext(application);

		String strInitParameterValue = "";
		String strInitParameterName = "";
		log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " AppStartUpServlet start");
		Enumeration scNames = sc.getInitParameterNames();

		try {
			while (scNames.hasMoreElements()) {
				strInitParameterName = (String) scNames.nextElement();
				strInitParameterValue = sc.getInitParameter(strInitParameterName);
				if (strInitParameterName != null) {
					if (strInitParameterName.equalsIgnoreCase(Constant.APP_HOME_DIRECTORY)) {
						globalEnviron.setAppHomeDir(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AppHomeDirectory '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.DEBUG)) {
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load Debug '" + strInitParameterValue + "'");
						int iTmpDebugLevel = 0;
						try {
							iTmpDebugLevel = Integer.parseInt(strInitParameterValue);
							if (iTmpDebugLevel < 0 || iTmpDebugLevel > Constant.MAX_DEBUG_LEVEL) {
								log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " invalid Debug level set to 0(ERROR)");
								iTmpDebugLevel = Constant.DEBUG_ERROR;
							}
						} catch (Exception e) {
							log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " invalid Debug level set to 0(ERROR)");
							iTmpDebugLevel = Constant.DEBUG_ERROR;
						}
						globalEnviron.setDebug(iTmpDebugLevel);
					} else if (strInitParameterName.equalsIgnoreCase(Constant.DEBUG_FILE_NAME)) {
						globalEnviron.setDebugFileName(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load DebugFileName '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.CHECK_PASSWORD_AGING)) {
						if (strInitParameterValue.equalsIgnoreCase("yes") || strInitParameterValue.equalsIgnoreCase("true"))
							globalEnviron.setCheckPasswordAging(true);
						else
							globalEnviron.setCheckPasswordAging(false);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load CheckPasswordAging '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.PASSWORD_VALID_DAY)) {
						int iTmpPasswordValidDay = 0;
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load PasswordValidDay '" + strInitParameterValue + "'");
						try {
							iTmpPasswordValidDay = Integer.parseInt(strInitParameterValue);
							if (iTmpPasswordValidDay < 0) {
								log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " invalid PasswordValidDay set to 0");
								iTmpPasswordValidDay = 0;
							}
						} catch (Exception e) {
							log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " invalid PasswordValidDay set to 0");
							iTmpPasswordValidDay = 0;
						}
						globalEnviron.setPasswordExpirationDay(iTmpPasswordValidDay);
					} else if (strInitParameterName.equalsIgnoreCase(Constant.PASSWORD_VALID_WARNNING_DAY)) {
						int iTmpPasswordValidWarnningDay = 0;
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load PasswordValidWarnningDay '" + strInitParameterValue + "'");
						try {
							iTmpPasswordValidWarnningDay = Integer.parseInt(strInitParameterValue);
							if (iTmpPasswordValidWarnningDay < 0) {
								log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " invalid PasswordValidWarnningDay set to 0");
								iTmpPasswordValidWarnningDay = 0;
							}
						} catch (Exception e) {
							log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " invalid PasswordValidWarnningDay set to 0");
							iTmpPasswordValidWarnningDay = 0;
						}
						globalEnviron.setPasswordValidWarnningDay(iTmpPasswordValidWarnningDay);
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DB_USER_ID_AEGON400)) {
						globalEnviron.setAS400DbUserIdAEGON400(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DbUserIdAEGON400 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DB_USER_ID_AEGON401)) {
						globalEnviron.setAS400DbUserIdAEGON401(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DbUserIdAEGON401 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DB_PASSWORD_AEGON400)) {
						globalEnviron.setAS400DbPasswordAEGON400(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DbPasswordAEGON400 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DB_PASSWORD_AEGON401)) {
						globalEnviron.setAS400DbPasswordAEGON401(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DbPasswordAEGON401 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DB_JDBC_DRIVER_NAME)) {
						globalEnviron.setAS400DbJdbcDriverName(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DbJdbcDriverName '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DB_JDBC_URL_AEGON400)) {
						globalEnviron.setAS400DbJdbcUrlAEGON400(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DBJdbcNameAEGON400 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DB_JDBC_URL_AEGON401)) {
						globalEnviron.setAS400DbJdbcUrlAEGON401(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DBJdbcNameAEGON401 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_SYSTEM_NAME_AEGON400)) {
						globalEnviron.setAS400SystemNameAEGON400(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400SystemNameAEGON400 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_SYSTEM_NAME_AEGON401)) {
						globalEnviron.setAS400SystemNameAEGON401(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400SystemNameAEGON401 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_SYSTEM_USER_NAME_AEGON400)) {
						globalEnviron.setAS400SystemUserNameAEGON400(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400SystemUserNameAEGON400 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_SYSTEM_USER_NAME_AEGON401)) {
						globalEnviron.setAS400SystemUserNameAEGON401(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400SystemUserNameAEGON401 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_SYSTEM_PASSWORD_AEGON400)) {
						globalEnviron.setAS400SystemPasswordAEGON400(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400SystemPasswordAEGON400 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_SYSTEM_PASSWORD_AEGON401)) {
						globalEnviron.setAS400SystemPasswordAEGON401(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400SystemPasswordAEGON401 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_PCML_FILE_NAME)) {
						globalEnviron.setAS400PCMLFileName(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400PCMLFileName '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DATA_SOURCE_NAME_AEGON400)) {
						globalEnviron.setAS400DataSourceNameAEGON400(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DataSourceNameAEGON400 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AS400_DATA_SOURCE_NAME_AEGON401)) {
						globalEnviron.setAS400DataSourceNameAEGON401(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400DataSourceNameAEGON401 '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.AUDIT_LOG_PARAMETER)) {
						int iTmpAuditLogLevel = 0;
						try {
							iTmpAuditLogLevel = Integer.parseInt(strInitParameterValue);
							if (iTmpAuditLogLevel < 0 || iTmpAuditLogLevel > Constant.AUDIT_LOG_MAX) {
								log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " invalid AuditLogLevel set to 0");
								iTmpAuditLogLevel = 0;
							}
						} catch (Exception e) {
							log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " invalid AuditLogLevel set to 0");
							iTmpAuditLogLevel = 0;
						}
						globalEnviron.setAuditLogLevel(iTmpAuditLogLevel);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AuditLogLevel '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.PASSWORD_ENCRYPTED)) {
						if (strInitParameterValue.equalsIgnoreCase("true") || strInitParameterValue.equalsIgnoreCase("yes"))
							globalEnviron.setPasswordEncrypted(true);
						else
							globalEnviron.setPasswordEncrypted(false);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load PasswordEncrypted '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.PASSWORD_CASE_SENSTIVITY)) {
						if (strInitParameterValue.equalsIgnoreCase("true") || strInitParameterValue.equalsIgnoreCase("yes"))
							globalEnviron.setPasswordCaseSenstivity(true);
						else
							globalEnviron.setPasswordCaseSenstivity(false);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load PasswordCaseSenstivity '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.ACTIVE_DATA_SOURCE)) {
						globalEnviron.setActiveAS400DataSource(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AS400ActiveDataSource '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.ROOTPATH)) {
						globalEnviron.setRootPath(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load RootPath '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.CAPSILSWITCH)) {
						globalEnviron.setCapsilSwitch(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load CapsilSwitch '" + strInitParameterValue + "'");
					} else if (strInitParameterName.equalsIgnoreCase(Constant.APPPATH)) {
						globalEnviron.setAppPath(strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load AppPath '" + strInitParameterValue + "'");
					} else {
						this.getServletContext().setAttribute(strInitParameterName, strInitParameterValue);
						log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " Load " + strInitParameterName + " '" + strInitParameterValue + "'");
					}
				}
			}
		} catch (Exception ex) {
			globalEnviron.setLastError("AppStartUpServlet.init()", ex);
		}

		Calendar thisCalendar = new CommonUtil(globalEnviron).getBizDateByRCalendar();
		Date dteAppStartUpDateTime = thisCalendar.getTime();
		DbFactory dbFactory = new DbFactory(globalEnviron);

		log("set the capsil data source to " + globalEnviron.getActiveAS400DataSource());
		application.setAttribute(Constant.GLOBAL_ENVIRON, globalEnviron);
		application.setAttribute(Constant.APP_STARTUP_DATE_TIME, dteAppStartUpDateTime);
		application.setAttribute(Constant.DB_FACTORY, dbFactory);
		application.log(globalEnviron.getROCDate() + " " + globalEnviron.getTime() + " global environ ready");

		return;
	}

	public void performTask(HttpServletRequest request, HttpServletResponse response) {
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) {
		globalEnviron.setSessionId(request.getSession().getId());
		dbFactory.setSessionId(request.getSession().getId());
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		doGet(request, response);
	}

	public void service(HttpServletRequest request, HttpServletResponse response) {
		doGet(request, response);
	}
}