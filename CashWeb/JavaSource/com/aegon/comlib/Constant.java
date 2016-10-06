package com.aegon.comlib;

import java.util.Locale;

public class Constant extends RootClass {

	public static final String APP_HOME_DIRECTORY = "AppHomeDirectory";
	public static final String DEBUG = "Debug";
	public static final String DEBUG_FILE_NAME = "DebugFileName";
	public static final String GLOBAL_ENVIRON = "globalEnviron";
	public static final String DB_FACTORY = "dbFactory";
	public static final String APP_STARTUP_DATE_TIME = "AppStartUpDateTime";
	public static final String USER_INFO = "userInfo";
	public static final String SESSION_INFO = "sessionInfo";
	public static final Locale CURRENT_LOCALE = Locale.TAIWAN;
	public static final String DEBUG_ALL = "*";
	public static final int DEBUG_DEBUG = 3;
	public static final int DEBUG_ERROR = 0;
	public static final String DEBUG_FIELD_DELEMITER = "\t";
	public static final int DEBUG_INFORMATION = 2;
	public static final int DEBUG_PROG_ID_LENGTH = 30;
	public static final int DEBUG_SESSION_POS = 2;
	public static final String DEBUG_SYSTEM = "SYSTEM";
	public static final int DEBUG_WARNING = 1;
	public static final int MAX_DEBUG_LEVEL = 3;
	public static final String TIME_ZONE = "CST";
	public static final String DATE_DELIMITER = "/";
	public static final String TIME_DELIMITER = ":";
	public static final int DATE_FORMAT_LENGTH = 9;
	public static final String CHECK_PASSWORD_AGING = "CheckPasswordAging";
	public static final String PASSWORD_VALID_DAY = "PasswordValidDay";
	public static final String PASSWORD_VALID_WARNNING_DAY = "PasswordValidWarnningDay";
	public static final String AS400_DB_JDBC_DRIVER_NAME = "AS400DbJdbcDriverName";
	public static final String AS400_DB_PASSWORD_AEGON400 = "AS400DbPasswordAEGON400";
	public static final String AS400_DB_PASSWORD_AEGON401 = "AS400DbPasswordAEGON401";
	public static final String AS400_DB_USER_ID_AEGON400 = "AS400DbUserIdAEGON400";
	public static final String AS400_DB_USER_ID_AEGON401 = "AS400DbUserIdAEGON401";
	public static final String AS400_DB_JDBC_URL_AEGON400 = "AS400DbJdbcUrlAEGON400";
	public static final String AS400_DB_JDBC_URL_AEGON401 = "AS400DbJdbcUrlAEGON401";
	public static final String AS400_SYSTEM_NAME_AEGON400 = "AS400SystemNameAEGON400";
	public static final String AS400_SYSTEM_NAME_AEGON401 = "AS400SystemNameAEGON401";
	public static final String AS400_SYSTEM_USER_NAME_AEGON400 = "AS400SystemUserNameAEGON400";
	public static final String AS400_SYSTEM_USER_NAME_AEGON401 = "AS400SystemUserNameAEGON401";
	public static final String AS400_SYSTEM_PASSWORD_AEGON400 = "AS400SystemPasswordAEGON400";
	public static final String AS400_SYSTEM_PASSWORD_AEGON401 = "AS400SystemPasswordAEGON401";
	public static final String AS400_PCML_FILE_NAME = "AS400PCMLFileName";
	public static final String AS400_DATA_SOURCE_NAME_AEGON400 = "AS400DataSourceNameAEGON400";
	public static final String AS400_DATA_SOURCE_NAME_AEGON401 = "AS400DataSourceNameAEGON401";
	public static final String AS400_NAMING = "AS400Naming";
	public static final String LOGON_USER_ID = "LogonUserId";
	public static final String LOGON_USER_NAME = "LogonUserName";
	public static final String LOGON_USER_TYPE = "LogonUserType";
	public static final String LOGON_USER_DEPT = "LogonUserDept";
	public static final String LOGON_USER_RIGHT = "LogonUserRight";
	public static final String LOGON_USER_BRCH = "LogonUserBrch";	//RC0036
	public static final String LOGON_USER_AREA = "LogonUserArea";	//RC0036
	public static final String ACTIVE_USER_TYPE = "ActiveUserType";
	public static final String ACTIVE_USER_ID = "ActiveUserId";
	public static final String ACTIVE_USER_NAME = "ActiveUserName";
	public static final String AS400_DATA_DATE = "AS400DataDate";
	public static final String COMPANY_CODE = "CompanyCode";
	public static final int AUDIT_LOG_NONE = 0;
	public static final int AUDIT_LOG_LOGON = 1;
	public static final int AUDIT_LOG_UPDATE = 2;
	public static final int AUDIT_LOG_ALL = 3;
	public static final int AUDIT_LOG_MAX = 3;
	public static final String AUDIT_LOG_PARAMETER = "AuditLogLevel";
	public static final String AUDIT_LOG_OBJECT_NAME = "MyAuditLogBean";
	public static final String PASSWORD_ENCRYPTED = "PasswordEncrypted";
	public static final String PASSWORD_CASE_SENSTIVITY = "PasswordCaseSenstivity";
	public static final String CAPSIL_DATA_SOURCE = "CapsilDataSource";
	public static final String CAPSIL_DATA_SOURCE_DATE = "CapsilDataSourceDate";
	public static final String CAPSIL_DATE = "CapsilDate";
	public static final String CAPSIL_DATA_SOURCE_AEGON400 = "jdbc/AEGON400";
	public static final String CAPSIL_DATA_SOURCE_AEGON401 = "jdbc/AEGON401";
	// R00393 edit by Leo Huang
	public static final String ROOTPATH = "RootPath";
	public static final String CAPSILSWITCH = "CapsilSwitch";
	public static final String APPPATH = "AppPath";
	// table name of system related table
	public static final String TABLE_NAME_USER_ID = "TableNameUserId";
	public static final String TABLE_NAME_FUNCTION = "TableNameFunction";
	public static final String TABLE_NAME_GROUP = "TableNameGroup";
	public static final String TABLE_NAME_FUNCTION_TREE = "TableNameFunctionTree";
	public static final String TABLE_NAME_GROUP_FUNCTION = "TableNameGroupFunction";
	public static final String TABLE_NAME_USER_GROUP = "TableNameUserGroup";
	public static final String TABLE_NAME_USER_FUNCTION = "TableNameUserFunction";
	public static final String TABLE_NAME_SUB_FUNCTION = "TableNameSubFunction";
	// field name of system related table
	public static final String FIELD_NAME_USER_ID = "FieldNameUserId";
	public static final String FIELD_NAME_USER_NAME = "FieldNameUserName";
	public static final String FIELD_NAME_DEFAULT_GROUP_ID = "FieldNameDefaultGroupId";
	public static final String FIELD_NAME_PASSWORD = "FieldNamePassword";
	public static final String FIELD_NAME_LAST_PASSWORD_DATE = "FieldNameLastPasswordDate";
	public static final String FIELD_NAME_LAST_LOGON_DATE = "FieldNameLastLogonDate";
	public static final String FIELD_NAME_PASSWORD_VALID_DAY = "FieldNamePasswordValidDay";
	public static final String FIELD_NAME_USER_TYPE = "FieldNameUserType";
	public static final String FIELD_NAME_USER_DEPT = "FieldNameUserDept";
	public static final String FIELD_NAME_USER_BRCH = "FieldNameUserBrch";//RC0036
    public static final String FIELD_NAME_USER_AREA = "FieldNameUserArea";//RC0036
	public static final String FIELD_NAME_USER_RIGHT = "FieldNameUserRight";
	public static final String FIELD_NAME_USER_STATUS = "FieldNameUserStatus";
	public static final String FIELD_NAME_HIT_COUNT_URL = "FieldNameHitCountUrl";
	public static final String FIELD_NAME_SUB_FUNCTION = "FieldNameSubFunction";
	public static final String FIELD_NAME_SUB_FUNCTION_NAME = "FieldNameSubFunctionName";
	public static final String FIELD_NAME_FUNCTION_ID = "FieldNameFunctionId";
	public static final String FIELD_NAME_FUNCTION_ID_UP = "FieldNameFunctionIdUp";
	public static final String FIELD_NAME_SEQ = "FieldNameSeq";
	public static final String FIELD_NAME_FUNCTION_ID_DOWN = "FieldNameFunctionIdDown";
	public static final String FIELD_NAME_FUNCTION_NAME = "FieldNameFunctionName";
	public static final String FIELD_NAME_REMARK = "FieldNameRemark";
	public static final String FIELD_NAME_PROPERTY = "FieldNameProperty";
	public static final String FIELD_NAME_URL = "FieldNameUrl";
	public static final String FIELD_NAME_TARGET_WINDOW = "FieldNameTargetWindow";
	public static final String FIELD_NAME_GROUP_ID = "FieldNameGroupId";
	public static final String FIELD_NAME_USER_GROUP_USER_ID = "FieldNameUserGroupUserId";
	public static final String FIELD_NAME_SUB_FUNCTION_FUNCTION_ID = "FieldNameSubFunctionFunctionId";
	public static final String FIELD_NAME_EXCLUDE = "FieldNameExclude";
	public static final String FIELD_NAME_GROUP_FUNCTION_SUB_FUNCTION = "FieldNameGroupFunctionSubFunction";
	public static final String FIELD_NAME_FUNCTION_SUB_FUNCTION = "FieldNameFunctionSubFunction";

	public static final String ACTIVE_DATA_SOURCE = "ActiveDataSource";

	//RB0030
	//public static final String Batch_PAY_SRCCODE = "'B1','B2','B3','B4','B5','B6','B7','B8','B9','BA','BB','BC','BD','BE','BI','BJ'";
    //EB0469 ADD BG/BH 
	//PC0004 ADD BF 
	//public static final String Batch_PAY_SRCCODE = "'B1','B2','B3','B4','B5','B6','B7','B8','B9','BA','BB','BC','BD','BE','BI','BJ','BH','BG','BF'";
	//PC0020-BC275活力一生終身醫療商品專案:新增BK,DISBSChangePDateServlet.class及DISBDailyPReports.jsp會使用到
	public static final String Batch_PAY_SRCCODE = "'B1','B2','B3','B4','B5','B6','B7','B8','B9','BA','BB','BC','BD','BE','BI','BJ','BH','BG','BF','BK'";

	/**
	 * Constant 建構子註解。
	 */
	public Constant() {
		super();
	}

}
