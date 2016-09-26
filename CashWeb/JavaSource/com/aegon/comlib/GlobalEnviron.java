package com.aegon.comlib;

import javax.servlet.ServletContext;

public class GlobalEnviron extends RootClass {
	private String strAppHomeDir = null;
	private String strDbCharacterSet = null;
	private String strAS400DbJdbcDriverName = null;
	private String strAS400DbJdbcUrlAEGON400 = null;
	private String strAS400DbJdbcUrlAEGON401 = null;
	private String strAS400DbUserIdAEGON400 = null;
	private String strAS400DbUserIdAEGON401 = null;
	private String strAS400DbPasswordAEGON400 = null;
	private String strAS400DbPasswordAEGON401 = null;
	private String strAS400SystemNameAEGON400 = null;
	private String strAS400SystemNameAEGON401 = null;
	private String strAS400SystemUserNameAEGON400 = null;
	private String strAS400SystemUserNameAEGON401 = null;
	private String strAS400SystemPasswordAEGON400 = null;
	private String strAS400SystemPasswordAEGON401 = null;
	private String strAS400PCMLFileName = null;
	private String strAS400DataSourceNameAEGON400 = null;
	private String strAS400DataSourceNameAEGON401 = null;
	private int iAuditLogLevel = 0;
	private boolean bPasswordEncrypted = false;
	private boolean bPasswordCaseSenstivity = true;
	private String strActiveAS400DataSource = null;
	private ServletContext application = null;

	private boolean bCheckPasswordAging = true;
	private int iPasswordExpirationDay = 0;
	private int iPasswordExpirationWarnningDay = 0;

	// R00393 edit by Leo Huang
	private String strRootPath = null;
	private String strCapsilSwitch = null;
	private String strAppPath = null;
	// R00393 edit by Leo Huang
	private String strAS400Naming = "system";

	public GlobalEnviron() {
		super();
	}

	public GlobalEnviron(String strThisIniFileName) {
		super();

	}

	public String getAppHomeDir() {
		if (strAppHomeDir == null)
			return "";
		else
			return strAppHomeDir;
	}

	public void setAppHomeDir(String strThisAppHomeDir) {
		if (strThisAppHomeDir == null)
			strAppHomeDir = "";
		else
			strAppHomeDir = strThisAppHomeDir;
	}

	public void setDbCharacterSet(String strThisDbCharacterSet) {
		if (strThisDbCharacterSet == null)
			strDbCharacterSet = "";
		else
			strDbCharacterSet = strThisDbCharacterSet;
	}

	public String getDbCharacterSet() {
		if (strDbCharacterSet == null)
			return "";
		else
			return strDbCharacterSet;
	}

	public boolean getCheckPasswordCheck() {
		return bCheckPasswordAging;
	}

	public int getPasswordExpirationDay() {
		return iPasswordExpirationDay;
	}

	public int getPasswordValidWarnningDay() {
		return iPasswordExpirationWarnningDay;
	}

	public void setCheckPasswordAging(boolean bThisCheckPasswordAging) {
		bCheckPasswordAging = bThisCheckPasswordAging;
	}

	public void setPasswordExpirationDay(int iThisPasswordExpirationDay) {
		if (iThisPasswordExpirationDay >= 0)
			iPasswordExpirationDay = iThisPasswordExpirationDay;
	}

	public void setPasswordValidWarnningDay(int iThisPasswordValidWarnningDay) {
		if (iThisPasswordValidWarnningDay >= 0)
			iPasswordExpirationWarnningDay = iThisPasswordValidWarnningDay;
	}

	public void setAS400DbJdbcDriverName(String strThisAS400DbJdbcDriverName) {
		if (strThisAS400DbJdbcDriverName != null)
			strAS400DbJdbcDriverName = strThisAS400DbJdbcDriverName;
	}

	public String getAS400DbJdbcDriverName() {
		return strAS400DbJdbcDriverName;
	}

	public void setAS400DbJdbcUrlAEGON400(String strThisAS400DbJdbcUrlAEGON400) {
		if (strThisAS400DbJdbcUrlAEGON400 != null)
			strAS400DbJdbcUrlAEGON400 = strThisAS400DbJdbcUrlAEGON400;
	}

	public String getAS400DbJdbcUrlAEGON400() {
		return strAS400DbJdbcUrlAEGON400;
	}

	public void setAS400DbJdbcUrlAEGON401(String strThisAS400DbJdbcUrlAEGON401) {
		if (strThisAS400DbJdbcUrlAEGON401 != null)
			strAS400DbJdbcUrlAEGON401 = strThisAS400DbJdbcUrlAEGON401;
	}

	public String getAS400DbJdbcUrlAEGON401() {
		return strAS400DbJdbcUrlAEGON401;
	}

	public void setAS400DbUserIdAEGON400(String strThisAS400DbUserIdAEGON400) {
		if (strThisAS400DbUserIdAEGON400 != null)
			strAS400DbUserIdAEGON400 = strThisAS400DbUserIdAEGON400;
	}

	public String getAS400DbUserIdAEGON400() {
		return strAS400DbUserIdAEGON400;
	}

	public void setAS400DbUserIdAEGON401(String strThisAS400DbUserIdAEGON401) {
		if (strThisAS400DbUserIdAEGON401 != null)
			strAS400DbUserIdAEGON401 = strThisAS400DbUserIdAEGON401;
	}

	public String getAS400DbUserIdAEGON401() {
		return strAS400DbUserIdAEGON401;
	}

	public void setAS400DbPasswordAEGON400(String strThisAS400DbPasswordAEGON400) {
		if (strThisAS400DbPasswordAEGON400 != null)
			strAS400DbPasswordAEGON400 = strThisAS400DbPasswordAEGON400;
	}

	public String getAS400DbPasswordAEGON400() {
		return strAS400DbPasswordAEGON400;
	}

	public void setAS400DbPasswordAEGON401(String strThisAS400DbPasswordAEGON401) {
		if (strThisAS400DbPasswordAEGON401 != null)
			strAS400DbPasswordAEGON401 = strThisAS400DbPasswordAEGON401;
	}

	public String getAS400DbPasswordAEGON401() {
		return strAS400DbPasswordAEGON401;
	}

	public void setAS400SystemNameAEGON400(String strThisAS400SystemNameAEGON400) {
		if (strThisAS400SystemNameAEGON400 != null)
			strAS400SystemNameAEGON400 = strThisAS400SystemNameAEGON400;
	}

	public String getAS400SystemNameAEGON400() {
		return strAS400SystemNameAEGON400;
	}

	public void setAS400SystemNameAEGON401(String strThisAS400SystemNameAEGON401) {
		if (strThisAS400SystemNameAEGON401 != null)
			strAS400SystemNameAEGON401 = strThisAS400SystemNameAEGON401;
	}

	public String getAS400SystemNameAEGON401() {
		return strAS400SystemNameAEGON401;
	}

	public void setAS400SystemUserNameAEGON400(String strThisAS400SystemUserNameAEGON400) {
		if (strThisAS400SystemUserNameAEGON400 != null)
			strAS400SystemUserNameAEGON400 = strThisAS400SystemUserNameAEGON400;
	}

	public String getAS400SystemUserNameAEGON400() {
		return strAS400SystemUserNameAEGON400;
	}

	public void setAS400SystemUserNameAEGON401(String strThisAS400SystemUserNameAEGON401) {
		if (strThisAS400SystemUserNameAEGON401 != null)
			strAS400SystemUserNameAEGON401 = strThisAS400SystemUserNameAEGON401;
	}

	public String getAS400SystemUserNameAEGON401() {
		return strAS400SystemUserNameAEGON401;
	}

	public void setAS400SystemPasswordAEGON400(String strThisAS400SystemPasswordAEGON400) {
		if (strThisAS400SystemPasswordAEGON400 != null)
			strAS400SystemPasswordAEGON400 = strThisAS400SystemPasswordAEGON400;
	}

	public String getAS400SystemPasswordAEGON400() {
		return strAS400SystemPasswordAEGON400;
	}

	public void setAS400SystemPasswordAEGON401(String strThisAS400SystemPasswordAEGON401) {
		if (strThisAS400SystemPasswordAEGON401 != null)
			strAS400SystemPasswordAEGON401 = strThisAS400SystemPasswordAEGON401;
	}

	public String getAS400SystemPasswordAEGON401() {
		return strAS400SystemPasswordAEGON401;
	}

	public void setAS400PCMLFileName(String strThisAS400PCMLFileName) {
		if (strThisAS400PCMLFileName != null)
			strAS400PCMLFileName = strThisAS400PCMLFileName;
	}

	public String getAS400PCMLFileName() {
		return strAS400PCMLFileName;
	}

	public void setAS400DataSourceNameAEGON400(String strThisAS400DataSourceNameAEGON400) {
		if (strThisAS400DataSourceNameAEGON400 != null)
			strAS400DataSourceNameAEGON400 = strThisAS400DataSourceNameAEGON400;
	}

	public String getAS400DataSourceNameAEGON400() {
		return strAS400DataSourceNameAEGON400;
	}

	public void setAS400DataSourceNameAEGON401(String strThisAS400DataSourceNameAEGON401) {
		if (strThisAS400DataSourceNameAEGON401 != null)
			strAS400DataSourceNameAEGON401 = strThisAS400DataSourceNameAEGON401;
	}

	public String getAS400DataSourceNameAEGON401() {
		return strAS400DataSourceNameAEGON401;
	}

	public void setAuditLogLevel(int iThisAuditLogLevel) {
		iAuditLogLevel = iThisAuditLogLevel;
	}

	public int getAuditLogLevel() {
		return iAuditLogLevel;
	}

	public void setPasswordEncrypted(boolean bThisPasswordEncrypted) {
		bPasswordEncrypted = bThisPasswordEncrypted;
	}

	public boolean getPasswordEncrypted() {
		return bPasswordEncrypted;
	}

	public void setPasswordCaseSenstivity(boolean bThisPasswordCaseSenstivity) {
		bPasswordCaseSenstivity = bThisPasswordCaseSenstivity;
	}

	public boolean getPasswordCaseSenstivity() {
		return bPasswordCaseSenstivity;
	}

	public void setActiveAS400DataSource(String strThisActiveAS400DataSource) {
		strActiveAS400DataSource = strThisActiveAS400DataSource;
	}

	public String getActiveAS400DataSource() {
		return strActiveAS400DataSource;
	}

	public void setServletContext(ServletContext thisApplication) {
		if (thisApplication != null)
			application = thisApplication;
	}

	public ServletContext getServletContext() {
		return application;
	}

	public String getAS400Naming() {
		return strAS400Naming;
	}

	public void setAS400Naming(String string) {
		strAS400Naming = string;
	}

	// R00393 edit by Leo Huang
	public void setRootPath(String rootpath) {
		strRootPath = rootpath;
	}

	public String getRootPath() {
		return strRootPath;
	}

	public void setCapsilSwitch(String capsilswitch) {
		strCapsilSwitch = capsilswitch;
	}

	public String getCapsilSwitch() {
		return strCapsilSwitch;
	}

	public String getAppPath() {
		return strAppPath;
	}

	public void setAppPath(String apppath) {
		strAppPath = apppath;
	}

	// R00393

}