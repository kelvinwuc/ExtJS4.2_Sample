/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393    Leo Huang    			2010/09/16           現在時間取Capsil營運時間
 *    R00393    Leo Huang    			2010/10/01           絕對路徑轉相對路徑
 *  =============================================================================
 */
package com.aegon.comlib;

import java.io.*;
import java.sql.*;
import java.text.*;
import java.util.*;



public class UserInfo extends RootClass {
	private String strPassword = new String("");
	private String strResetPasswordFlag = new String("");
	private String strUserId = new String("");
	private String strUserName = new String("");
	private String strUserStatus = new String("");
	private String strUserType = new String("");
	private String strUserDept = new String("");
	private String strUserArea = new String("");//RC0036
	private String strUserBrch = new String("");//RC0036
	private String strUserRight = new String("");	
	private String strDefaultGroup = new String("");
	private String strBranchCode = new String("");
	private boolean bAutoRefresh = true;
	private boolean bRefreshed = false;
	private Connection conDbConnection = null;
	private DbFactory dbFactory = null;
	private String strUserSql = new String("");
	private java.util.Date dteCreateDate = null;
	private java.util.Date dteLastLoginDate = null;
	private java.util.Date dteLastPasswordDate = null;
	private String strRemark = new String("");
	private String strResetPasswdFlag = new String("");
	private String strUpdateUserId = new String("");
	private boolean bCaseSenstive = true;
	private boolean bCheckPasswordAging = true;
	private int iPasswordWarningDays = 7;
	private int iPasswordExpirationDays = 36;
	private boolean bPasswordChecked = false;

	private String strEmail = "";
	private String strSQ = "";
	private String strSA = "";

	private CommonUtil commonUtil = null;
	/*
		private String strDbName = new String("AegonWeb");
		private String strUserIdTableName = new String("tUser");
		private String strGroupFunctionTableName = new String("tgroup_function");
		private String strFunctionTreeTableName = new String("tfunction_tree");
		private String strUserGroupTableName = new String("tuser_group");
		private String strFunctionTableName = new String("tFunction");
		private String strUserIdFieldName = new String("UserId");
		private String strUserNameFieldName = new String("UserName");
		private String strDefaultGroupFieldName = new String("DefaultGroupId");
		private String strPasswordFieldName = new String("Password");
		private String strLastPasswordDateFieldName = new String("LastPasswordDate");
		private String strLastLoginDateFieldName = new String("LastLogonDate");
		private String strPasswordValidDaysFieldName = new String("PasswordValidDay");
		private String strUserTypeFieldName = new String("UserType");
		private String strUserStatusFieldName = "UserStatus";
		private String strHitCountUrlFieldName = new String("hit_count_url");
		private String strSubFunctionFieldName = new String("SubFunction");
	
		private String strDpDskFieldName = new String("");
		private String strOfficeFieldName = new String("");
		private String strBranchFieldName = new String("");
		private String strBranch = new String("");
		private String strDpDsk = new String("");
		private String strOffice = new String("");
	*/
	private SimpleDateFormat sdfDateFormatter =
		new SimpleDateFormat("yyyy/MM/dd HH:mm:ss", java.util.Locale.TAIWAN);
	private int passwordErrorCounter = 0;
	private int maxPasswordError = 5;

	public class stFunction {
		protected String strFunctionIdUp = new String("");
		protected String strFuncNameUp = new String("");
		protected String strImageFileOnUp = new String("");
		protected String strImageFileOffUp = new String("");
		protected String strRemarkUp = new String("");
		protected String strHitCountUrlUp = new String("");
		protected String strSubFunctionUp = null;
		protected String strSeq = new String("");
		protected String strFunctionIdDown = new String("");
		protected String strFuncName = new String("");
		protected String strImageFileOn = new String("");
		protected String strImageFileOff = new String("");
		protected String strProperty = new String("");
		protected String strUrl = new String("");
		protected String strTargetWindow = new String("");
		protected String strRemark = new String("");
		protected String strHitCountUrl = new String("");
		protected String strSubFunction = null;
	}
	private Vector vtFunctionTree = new Vector(10, 10);
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 */
	public UserInfo() {
		super();
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 */
	public UserInfo(String strThisUserId) {
		super();

		if (strThisUserId == null) {
			setLastError(
				"UserInfor.UserInfo()",
				"input parameter of constructor is null");
			return;
		}
		this.setUserId(strThisUserId);
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 */
	public UserInfo(DbFactory thisDbFactory) {
		super();

		this.setDebugFileName(
			thisDbFactory.getGlobalEnviron().getDebugFileName());
		this.setDebug(thisDbFactory.getGlobalEnviron().getDebug());
		this.setSessionId(thisDbFactory.getSessionId());
		this.setDbFactory(thisDbFactory);
		bCaseSenstive =
			thisDbFactory.getGlobalEnviron().getPasswordCaseSenstivity();
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 */
	public UserInfo(GlobalEnviron thisEnv) {

		super();
		if (thisEnv != null) {
			this.setDebugFileName(thisEnv.getDebugFileName());
			this.setDebug(thisEnv.getDebug());
			this.setSessionId(thisEnv.getSessionId());
			dbFactory = new DbFactory(thisEnv);
			bCaseSenstive =
				dbFactory.getGlobalEnviron().getPasswordCaseSenstivity();
			// 		if( conDbConnection == null )
			//		{
			//			conDbConnection = DbFactory.getConnection();
			//		}
		} else {
			setLastError(
				"UserInfo.UserInfo()",
				"The input parameter Env is null");
		}
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 */
	public UserInfo(GlobalEnviron thisEnv, String strThisUserId) {

		super();
		if (thisEnv != null) {
			this.setDebugFileName(thisEnv.getDebugFileName());
			this.setDebug(thisEnv.getDebug());
			this.setSessionId(thisEnv.getSessionId());
			dbFactory = new DbFactory(thisEnv);
			bCaseSenstive =
				dbFactory.getGlobalEnviron().getPasswordCaseSenstivity();
		} else {
			setLastError(
				"UserInfo.UserInfo()",
				"The input parameter Env is null");
		}
		this.setUserId(strThisUserId);
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 */
	public UserInfo(String strThisUserId, DbFactory thisDbFactory) {
		super();

		this.setDebugFileName(
			thisDbFactory.getGlobalEnviron().getDebugFileName());
		this.setDebug(thisDbFactory.getGlobalEnviron().getDebug());
		this.setSessionId(thisDbFactory.getSessionId());
		//	writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.UserInfo()","Constructor Enter");
		if (strThisUserId == null) {
			setLastError(
				"UserInfor.UserInfo()",
				"input parameter of constructor is null");
			return;
		}
		this.setDbFactory(thisDbFactory);
		bCaseSenstive =
			thisDbFactory.getGlobalEnviron().getPasswordCaseSenstivity();
		this.setUserId(strThisUserId);
		//	writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.UserInfo()","Constructor Exit");
	}

	public boolean getAutoRefresh() {
		return bAutoRefresh;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/3 下午 04:39:01)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 */

	public String getPassword() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserName()",
				"Not Refresh yet, wrong state");
			strPassword = "";
		}
		return strPassword;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/3 下午 04:39:01)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 */
	public String getUserId() {
		if (strUserId != null)
			return strUserId;
		else
			return "";
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/3 下午 04:39:01)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 */
	public String getUserName() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserName()",
				"Not Refresh yet, wrong state");
			strUserName = "";
		}
		return strUserName;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/3 下午 04:39:01)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 */
	public String getUserStatus() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserName()",
				"Not Refresh yet, wrong state");
			strUserStatus = "";
		}
		return strUserStatus;
	}
	public String getBranchCode() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getBranchCode()",
				"Not Refresh yet, wrong state");
			strBranchCode = "";
		}
		return strBranchCode;
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String getUserType() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserName()",
				"Not Refresh yet, wrong state");
			strUserType = "";
		}
		return strUserType;
	} 
	
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String getUserDept() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserDept()",
				"Not Refresh yet, wrong state");
			strUserDept = "";
		}
		return strUserDept;
	} 
	/**RC0036
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2014/6/27)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String getUserArea() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserArea()",
				"Not Refresh yet, wrong state");
			strUserArea = "";
		}
		return strUserArea;
	} 
	/**RC0036
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2014/6/27)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String getUserBrch() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserBrch()",
				"Not Refresh yet, wrong state");
	    	strUserBrch = "";
		}
		return strUserBrch;
	} 


	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String getUserRight() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserRight()",
				"Not Refresh yet, wrong state");
			strUserRight = "";
		}
		return strUserRight;
	} 
	
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 */
	public boolean refresh() {
		PreparedStatement pstmTmp = null;
		ResultSet rstTmp = null;
		boolean bReturnStatus = true;
		//	writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","Enter ");
		if (dbFactory == null) {
			setLastError(
				"UserInfo.refresh()",
				"The DbFactory is empty, can't refresh");
			bReturnStatus = false;
		} else {
			if (commonUtil == null) {
				commonUtil = new CommonUtil(dbFactory.getGlobalEnviron());
			}
		}

		if (bReturnStatus) {
			//		writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","dbFactory is O.K. ");
			if (this.getUserId().equals("")) {
				setLastError("UserInfo.refresh()", "帳號未設定");
				bReturnStatus = false;
			}
		}

		if (bReturnStatus) {
			//		writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","user id = '"+this.getUserId()+"'");
			if (conDbConnection == null) {
				conDbConnection = dbFactory.getConnection("UserInfo.refresh()");
				if (conDbConnection == null) {
					setLastError(
						"UserInfo.refresh()",
						dbFactory.getLastErrorMessage());
					bReturnStatus = false;
				}
			}
		}

		if (bReturnStatus) {
			//		writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","pass connection check ");
			try {
				strUserSql =
					"select * from "
						+ (String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.TABLE_NAME_USER_ID)
						+ " where "
						+ (String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_USER_ID)
						+ " = ?";
				pstmTmp = conDbConnection.prepareStatement(strUserSql);
			} catch (SQLException e) {
				setLastError("UserInfo.refresh()", e);
				bReturnStatus = false;
			}
		}

		if (bReturnStatus) {
			//		writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","pass create statement ");
			try {
				pstmTmp.setString(1, this.getUserId());
			} catch (SQLException e) {
				setLastError("UserInfo.refresh()", e);
				bReturnStatus = false;
			}
		}

		if (bReturnStatus) {
			//		writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","pass set parameter ");
			try {
				rstTmp = pstmTmp.executeQuery();
			} catch (SQLException e) {
				setLastError("UserInfo.refresh()", e);
				bReturnStatus = false;
			}
		}

		if (bReturnStatus) {
			//		writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","pass execute statement ");
			try {
				if (rstTmp.next()) {
					strEmail = CommonUtil.AllTrim(rstTmp.getString("EMAIL"));
					strSQ = CommonUtil.AllTrim(rstTmp.getString("SCTQ"));
					strSA = CommonUtil.AllTrim(rstTmp.getString("SCTA"));

					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_USER_NAME))) {
						if (rstTmp
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_USER_NAME))
							!= null)
							strUserName =
								rstTmp
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_USER_NAME))
									.trim();
						else
							strUserName = new String("");
					}
					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_DEFAULT_GROUP_ID))) {
						if (rstTmp
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_DEFAULT_GROUP_ID))
							!= null)
							strDefaultGroup =
								rstTmp
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant
												.FIELD_NAME_DEFAULT_GROUP_ID))
									.trim();
						else
							strDefaultGroup = new String("");
					}
					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_PASSWORD))) {
						if (rstTmp
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_PASSWORD))
							!= null)
							strPassword =
								rstTmp
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_PASSWORD))
									.trim();
						else
							strPassword = new String("");
					}
					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_LAST_PASSWORD_DATE))) {
						//					if( rstTmp.getDate(strLastPasswordDateFieldName) != null )
						dteLastPasswordDate =
							commonUtil.convertROC2WestenDate1(
								rstTmp.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant
											.FIELD_NAME_LAST_PASSWORD_DATE)));
						//					else
						//						dteLastPasswordDate		= new java.util.Date();
					}

					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_PASSWORD_VALID_DAY))) {
						if (rstTmp
							.getInt(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_PASSWORD_VALID_DAY))
							!= 0)
							iPasswordExpirationDays =
								rstTmp.getInt(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant
											.FIELD_NAME_PASSWORD_VALID_DAY));
					}
					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_USER_TYPE))) {
						if (rstTmp
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_USER_TYPE))
							!= null)
							strUserType =
								rstTmp
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_USER_TYPE))
									.trim();
						else
							strUserType = new String("");
					}
					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_USER_DEPT))) {
						if (rstTmp
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_USER_DEPT))
							!= null)
							strUserDept =
								rstTmp
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_USER_DEPT))
									.trim();
						else
							strUserDept = new String("");
					}
/*RC0036*/			if (checkForFieldName(rstTmp,
							(String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.FIELD_NAME_USER_AREA))) {
							if (rstTmp
								.getString(
									(String) dbFactory
							    		.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_USER_AREA))
								!= null)
								strUserArea =
									rstTmp
										.getString(
											(String) dbFactory
												.getGlobalEnviron()
												.getServletContext()
												.getAttribute(
												Constant.FIELD_NAME_USER_AREA))
										.trim();
							else
								strUserArea = new String("");
						}
/*RC0036*/			if (checkForFieldName(rstTmp,
		                     (String) dbFactory
			                     .getGlobalEnviron()
			                     .getServletContext()
			                     .getAttribute(
		                         Constant.FIELD_NAME_USER_BRCH))) {
		                     if (rstTmp
			                     .getString(
				                     (String) dbFactory
					                     .getGlobalEnviron()
					                     .getServletContext()
					                     .getAttribute(
					                     Constant.FIELD_NAME_USER_BRCH))
			                     != null)
			                     strUserBrch =
				                     rstTmp
				                         .getString(
						                     (String) dbFactory
					                        	 .getGlobalEnviron()
							                     .getServletContext()
							                     .getAttribute(
						                         Constant.FIELD_NAME_USER_BRCH))
					                     .trim();
		                      else
			                      strUserBrch = new String("");
	                    }

					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_USER_RIGHT))) {
						if (rstTmp
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_USER_RIGHT))
							!= null)
							strUserRight =
								rstTmp
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_USER_RIGHT))
									.trim();
						else
							strUserRight = new String("");
					}
					if (checkForFieldName(rstTmp,
						(String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_USER_STATUS))) {
						if (rstTmp
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_USER_STATUS))
							!= null)
							strUserStatus =
								rstTmp
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_USER_STATUS))
									.trim();
						else
							strUserStatus = new String("");
					}
				} else {
					setLastError(
						"UserInfo.refresh()",
						"帳號 '" + this.getUserId() + "' 不存在於資料庫中");
					bReturnStatus = false;
				}
			} catch (SQLException e) {
				setLastError("UserInfo.refresh()", e);
				bReturnStatus = false;
			}
		}

		try {
			if (pstmTmp != null)
				pstmTmp.close();
			if (rstTmp != null)
				rstTmp.close();
		} catch (SQLException e) {
			setLastError("UserInfo.refresh()", e);
		}

		/*	 先要設定為以完成refresh,因為retriveProgramStructure()會檢核此一flag*/
		if (bReturnStatus) {
			bRefreshed = true;
		}

		if (bReturnStatus)
			bReturnStatus = retriveProgramStructure();

		/*	 若retriveProgramStructure()回應有錯誤再將bRefreshed旗標設定回未Refresh*/
		if (!bReturnStatus)
			bRefreshed = false;

		bPasswordChecked = false;
		if (conDbConnection != null) {
			try {
				if (conDbConnection.isClosed()) {
					writeDebugLog(
						Constant.DEBUG_WARNING,
						"UserInfo.refresh()",
						"The connection has been closed already");
					conDbConnection = null;
				} else {
					dbFactory.releaseConnection(conDbConnection);
					conDbConnection = null;
				}
			} catch (Exception e) {
				setLastError("UserInfo.refresh()", e);
			}
		}
		//	if( bReturnStatus )
		//		writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","Exit with status true ");
		//	else
		//		writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.refresh()","Exit with status false ");
		return bReturnStatus;
	}

	public void setAutoRefresh(boolean bThisAutoRefresh) {
		bAutoRefresh = bThisAutoRefresh;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/3 下午 05:16:43)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @param thisDbFactory dbFactory
			 */
	public void setDbFactory(DbFactory thisDbFactory) {
		if (thisDbFactory == null) {
			setLastError("UserInfo.setDbFactory()", "input parameter is null");
		} else {
			dbFactory = thisDbFactory;
			this.setDebugFileName(
				thisDbFactory.getGlobalEnviron().getDebugFileName());
			this.setDebug(thisDbFactory.getGlobalEnviron().getDebug());
			this.setSessionId(thisDbFactory.getSessionId());
		}

	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/3 下午 04:37:51)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @param strThisUserId java.lang.String
			 */
	public java.util.Date getLastLoginDate() {
		if (!bRefreshed) {
			setLastError(
				"UserInfo.getUserName()",
				"Not Refresh yet, wrong state");
			dteLastLoginDate = null;
		}
		return dteLastLoginDate;
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	/* 
	 *
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:39:01)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public boolean checkUserStatus() {
		boolean bReturn = true;

		//	writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.checkUserStatus()","Enter");
		if (!bRefreshed) {
			if (!this.refresh())
				bReturn = false;
		}

		if (bReturn) {
			writeDebugLog(
				Constant.DEBUG_DEBUG,
				"UserInfo.checkUserStatus()",
				"The user id = '"
					+ this.getUserId()
					+ "', status = '"
					+ this.getUserStatus()
					+ "'");
			if (!this.getUserStatus().equals("A")) {
				setLastError("UserInfo.checkUserStatus()", "使用者暫時失效");
				bReturn = false;
			}
		}
		return bReturn;
	}

	public boolean getOneFunction(String strFuncId, String strSubFunction) {
	
		
		boolean bReturnStatus = true;
		String strFunctionTreeSql =
			new String(
				"select "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_FUNCTION_ID_UP)
					+ ","
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_SEQ)
					+ ","
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_FUNCTION_ID_DOWN)
					+ " from "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.TABLE_NAME_FUNCTION_TREE)
					+ " where "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_FUNCTION_ID_UP)
					+ " = ?");

		System.out.print("strFunctionTreeSql==>"+strFunctionTreeSql);	//test		
		String strFunctionDetailSql =
			new String(
				"select * from "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.TABLE_NAME_FUNCTION)
					+ " where "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_FUNCTION_ID)
					+ " = ?");
		System.out.print("strFunctionDetailSql==>"+strFunctionDetailSql);	//test
		PreparedStatement pstmFunctionTree = null;
		PreparedStatement pstmFunctionDetail = null;
		ResultSet rstFunctionTree = null;
		ResultSet rstFunctionDetail = null;
		String strLocation = new String("");

		try {
			strLocation = "UserInfo.getOneFunction1";
			pstmFunctionTree =
				conDbConnection.prepareStatement(strFunctionTreeSql);
			pstmFunctionTree.setString(1, strFuncId);
			rstFunctionTree = pstmFunctionTree.executeQuery();
			boolean bIsMenu = false;
			while (rstFunctionTree.next()) {
				int i;
				boolean bFound = false;
				stFunction objTmp = null;
				bIsMenu = true;
				for (i = 0; i < vtFunctionTree.size(); i++) {
					objTmp = (stFunction) vtFunctionTree.elementAt(i);
					if (objTmp
						.strFunctionIdUp
						.equals(
							rstFunctionTree
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_FUNCTION_ID_UP))
								.trim())
						&& objTmp.strSeq.equals(
							rstFunctionTree
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_SEQ))
								.trim())
						&& objTmp.strFunctionIdDown.equals(
							rstFunctionTree
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_FUNCTION_ID_DOWN))
								.trim())) {
						bFound = true;
						break;
					}
				} //for
				if (bFound)
					break;
				//先將上層的程式明細載入系統中
				strLocation = "UserInfo.getOneFunction2";
				stFunction tmpStFunction = new stFunction();
				tmpStFunction.strFunctionIdUp =
					rstFunctionTree
						.getString(
							(String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.FIELD_NAME_FUNCTION_ID_UP))
						.trim();
				tmpStFunction.strSeq =
					rstFunctionTree
						.getString(
							(String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.FIELD_NAME_SEQ))
						.trim();
				tmpStFunction.strFunctionIdDown =
					rstFunctionTree
						.getString(
							(String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.FIELD_NAME_FUNCTION_ID_DOWN))
						.trim();
				if (pstmFunctionDetail == null)
					pstmFunctionDetail =
						conDbConnection.prepareStatement(strFunctionDetailSql);
				strLocation = "UserInfo.getOneFunction3";
				pstmFunctionDetail.setString(1, tmpStFunction.strFunctionIdUp);
				rstFunctionDetail = pstmFunctionDetail.executeQuery();
				if (rstFunctionDetail.next()) {
					tmpStFunction.strFuncNameUp =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_FUNCTION_NAME))
							.trim();
					tmpStFunction.strRemarkUp =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_REMARK))
							.trim();
					tmpStFunction.strHitCountUrlUp =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_HIT_COUNT_URL))
							.trim();
					// 93/03/29 added by Andy : 將程式權限加入,若早期的系統沒有使用程式權限,就會產生exception,忽略它
					try {
						int iColumn =
							rstFunctionDetail.findColumn(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_FUNCTION_SUB_FUNCTION));
						tmpStFunction.strSubFunctionUp =
							rstFunctionDetail.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_FUNCTION_SUB_FUNCTION));
					} catch (SQLException ex) {
					}
					// 93/03/29 added by Andy : end
				} else {
					this.setLastError(
						"UserInfo.getOneFunction()",
						"Function id '"
							+ tmpStFunction.strFunctionIdUp
							+ "'未存於tfunction中");
					bReturnStatus = false;
				}
				//再將下層的程式明細載入系統中
				strLocation = "UserInfo.getOneFunction4";
				pstmFunctionDetail.setString(
					1,
					tmpStFunction.strFunctionIdDown);
				rstFunctionDetail = pstmFunctionDetail.executeQuery();
				if (rstFunctionDetail.next()) {
					strLocation = "UserInfo.getOneFunction5";
					tmpStFunction.strFuncName =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_FUNCTION_NAME))
							.trim();
					tmpStFunction.strProperty =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_PROPERTY))
							.trim();
				    //R00393 edit by Leo Huang		
				    /*  
					tmpStFunction.strUrl =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_URL))
							.trim();*/
					tmpStFunction.strUrl =dbFactory.getRootFolder()+
						rstFunctionDetail
							 .getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_URL))
							.trim();					
					//R00393 edit by Leo Huang
					tmpStFunction.strTargetWindow =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_TARGET_WINDOW))
							.trim();
					tmpStFunction.strRemark =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_REMARK))
							.trim();
					tmpStFunction.strHitCountUrl =
						rstFunctionDetail
							.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_HIT_COUNT_URL))
							.trim();
					// 93/03/29 added by Andy : 將程式權限加入,若早期的系統沒有使用程式權限,就會產生exception,忽略它
					try {
						int iColumn =
							rstFunctionDetail.findColumn(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_FUNCTION_SUB_FUNCTION));
						tmpStFunction.strSubFunction =
							rstFunctionDetail.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_FUNCTION_SUB_FUNCTION));
					} catch (SQLException ex) {
					}
					vtFunctionTree.addElement(tmpStFunction);
					/*				
									writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.getOneFunction()",
										"func_id_up = '"+
										rstFunctionTree.getString("func_id_up").trim()+
										"', func_id_down = '"+
										rstFunctionTree.getString("func_id_down").trim()+
										"', func_name = '"+rstFunctionDetail.getString("func_name").trim()+
										"', image_file_on = '"+tmpStFunction.strImageFileOn+
										"', image_file_off = '"+tmpStFunction.strImageFileOff+
										"', property = '"+tmpStFunction.strProperty+
										"', url = '"+tmpStFunction.strUrl+
										"', target_window = '"+tmpStFunction.strTargetWindow+
										"', remark = '"+tmpStFunction.strRemark+"'");
					*/
					if (rstFunctionDetail
						.getString(
							(String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.FIELD_NAME_PROPERTY))
						.equalsIgnoreCase("M"))
						getOneFunction(tmpStFunction.strFunctionIdDown, null);
				} else {
					this.setLastError(
						"UserInfo.getOneFunction()",
						"Function id '"
							+ tmpStFunction.strFunctionIdDown
							+ "'未存於"
							+ (String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.TABLE_NAME_FUNCTION)
							+ "中");
					bReturnStatus = false;
				}
			} //while (rstFunctionTree.next())
			if (!bIsMenu) {
				int i;
				boolean bFound = false;
				stFunction objTmp = null;
				for (i = 0; i < vtFunctionTree.size(); i++) {
					objTmp = (stFunction) vtFunctionTree.elementAt(i);
					if (objTmp.strFunctionIdDown.equals(strFuncId.trim())) {
						// 93/03/29 added by Andy : 若是該程式是由前面傳入之程式名稱,權限亦是由前面傳入,由group_function中所定義之權限
						objTmp.strSubFunction = strSubFunction;
						bFound = true;
						break;
					}
				} //for (i = 0; i < vtFunctionTree.size(); i++)
				if (!bFound) {
					stFunction tmpStFunction = new stFunction();
					tmpStFunction.strFunctionIdUp = new String("");
					tmpStFunction.strSeq = new String("");
					tmpStFunction.strFunctionIdDown = strFuncId.trim();
					strLocation = "UserInfo.getOneFunction6";
					if (pstmFunctionDetail == null)
						pstmFunctionDetail =
							conDbConnection.prepareStatement(
								strFunctionDetailSql);
					pstmFunctionDetail.setString(
						1,
						tmpStFunction.strFunctionIdDown);
					//				writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.getOneFunction()","func_id_down = '"+tmpStFunction.strFunctionIdDown+"'");
					rstFunctionDetail = pstmFunctionDetail.executeQuery();
					if (rstFunctionDetail.next()) {
						strLocation = "UserInfo.getOneFunction7";
						tmpStFunction.strFuncName =
							rstFunctionDetail
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_FUNCTION_NAME))
								.trim();
						strLocation = "UserInfo.getOneFunction71";
						tmpStFunction.strProperty =
							rstFunctionDetail
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_PROPERTY))
								.trim();
						//R00393 edit by Leo Huang 
						/*
						tmpStFunction.strUrl =
							rstFunctionDetail
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_URL))
								.trim();*/
						tmpStFunction.strUrl =dbFactory.getRootFolder()+
								rstFunctionDetail
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_URL))
								.trim();							
//						R00393 edit by Leo Huang 
						tmpStFunction.strTargetWindow =
							rstFunctionDetail
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_TARGET_WINDOW))
								.trim();
						tmpStFunction.strRemark =
							rstFunctionDetail
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_REMARK))
								.trim();
						tmpStFunction.strHitCountUrl =
							rstFunctionDetail
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_HIT_COUNT_URL))
								.trim();
						// 93/03/29 added by Andy : 若是該程式是由前面傳入之程式名稱,權限亦是由前面傳入,由group_function中所定義之權限
						tmpStFunction.strSubFunction = strSubFunction;
						vtFunctionTree.addElement(tmpStFunction);
					} else {
						this.setLastError(
							"UserInfo.getOneFunction()",
							"Function id '"
								+ tmpStFunction.strFunctionIdDown
								+ "'未存於"
								+ (String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.TABLE_NAME_FUNCTION)
								+ "中");
						bReturnStatus = false;
					}
				} //if (!bFound)
			} //if (!bIsMenu)
		} //try
		catch (SQLException e) {
			setLastError(strLocation, e);
			bReturnStatus = false;
		}
		return bReturnStatus;
	}

	public boolean retriveProgramStructure() {
		boolean bReturnStatus = true;
		PreparedStatement pstmTmp = null;
		ResultSet rstTmp = null;
		String strUserGroupSql =
			new String(
				"select * from "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.TABLE_NAME_USER_GROUP)
					+ " where "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_USER_GROUP_USER_ID)
					+ " = ?");
		String strGroupFunctionSql =
			new String(
				"select * from "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.TABLE_NAME_GROUP_FUNCTION)
					+ " where "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_GROUP_ID)
					+ " = ?");
		PreparedStatement pstmUserGroup = null;
		PreparedStatement pstmGroupFunction = null;
		ResultSet rstUserGroup = null;
		ResultSet rstGroupFunction = null;

		if (!bRefreshed)
			if (!this.refresh())
				bReturnStatus = false;
		vtFunctionTree.setSize(0);
		if (bReturnStatus) {
			if (conDbConnection == null)
				conDbConnection =
					dbFactory.getAS400Connection(
						"UserInfo.retriveProgramStructure()");
			if (conDbConnection == null)
				bReturnStatus = false;
			if (bReturnStatus) {
				try {
					//				writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.retriveProgramStructure()","Begin to retrive the function tree");
					//				writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.retriveProgramStructure()","The default group is '"+strDefaultGroup+"'");
					if (!strDefaultGroup.equals("")) {
						if (pstmGroupFunction == null)
							pstmGroupFunction =
								conDbConnection.prepareStatement(
									strGroupFunctionSql);
						pstmGroupFunction.setString(1, strDefaultGroup);
						rstGroupFunction = pstmGroupFunction.executeQuery();
						while (rstGroupFunction.next()) {
							// 93/03/29 added by Andy : 將程式權限加入,若早期的系統沒有使用程式權限,就會產生exception,忽略它
							String strSubFunction = null;
							try {
								int iColumn =
									rstGroupFunction.findColumn(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant
												.FIELD_NAME_GROUP_FUNCTION_SUB_FUNCTION));
								strSubFunction =
									rstGroupFunction.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant
												.FIELD_NAME_GROUP_FUNCTION_SUB_FUNCTION));
							} catch (SQLException ex) {
							}
							boolean bTmp =
								getOneFunction(
									rstGroupFunction.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_FUNCTION_ID)),
									strSubFunction);
							if (!bTmp)
								bReturnStatus = bTmp;
						}
					}
					pstmUserGroup =
						conDbConnection.prepareStatement(strUserGroupSql);
					pstmUserGroup.setString(1, this.getUserId());
					rstUserGroup = pstmUserGroup.executeQuery();
					while (rstUserGroup.next()) {
						if (pstmGroupFunction == null)
							pstmGroupFunction =
								conDbConnection.prepareStatement(
									strGroupFunctionSql);
						pstmGroupFunction.setString(
							1,
							rstUserGroup.getString(
								(String) dbFactory
									.getGlobalEnviron()
									.getServletContext()
									.getAttribute(
									Constant.FIELD_NAME_GROUP_ID)));
						rstGroupFunction = pstmGroupFunction.executeQuery();
						while (rstGroupFunction.next()) {
							// 93/03/29 added by Andy : 將程式權限加入,若早期的系統沒有使用程式權限,就會產生exception,忽略它
							String strSubFunction = null;
							try {
								int iColumn =
									rstGroupFunction.findColumn(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant
												.FIELD_NAME_GROUP_FUNCTION_SUB_FUNCTION));
								strSubFunction =
									rstGroupFunction.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant
												.FIELD_NAME_GROUP_FUNCTION_SUB_FUNCTION));
							} catch (SQLException ex) {
							}
							boolean bTmp =
								getOneFunction(
									rstGroupFunction.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_FUNCTION_ID)),
									strSubFunction);
							if (!bTmp)
								bReturnStatus = bTmp;
						}
					}
				} catch (SQLException e) {
					setLastError("UserInfo.retriveProgramStructure", e);
					bReturnStatus = false;
				}
			}
		} //if (bReturnStatus)
		/*
		 * 93/03/30 added by Andy : 增加 UserFunction 中之權限
		 * */
		if (bReturnStatus
			&& dbFactory.getGlobalEnviron().getServletContext().getAttribute(
				Constant.TABLE_NAME_USER_FUNCTION)
				!= null) {
			String strUserFunctionSql =
				new String(
					"select * from "
						+ (String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.TABLE_NAME_USER_FUNCTION)
						+ " where "
						+ (String) dbFactory
							.getGlobalEnviron()
							.getServletContext()
							.getAttribute(
							Constant.FIELD_NAME_USER_ID)
						+ " = ?");
			
			PreparedStatement pstmUserFunction = null;
			ResultSet rstUserFunction = null;
			try {
				if (conDbConnection == null)
					conDbConnection =
						dbFactory.getAS400Connection(
							"UserInfo.retriveProgramStructure()");
				if (conDbConnection == null)
					bReturnStatus = false;
				if (bReturnStatus) {
					stFunction objTmp = null;
					boolean bFound = false;
					pstmUserFunction =
						conDbConnection.prepareStatement(strUserFunctionSql);
					pstmUserFunction.setString(1, this.getUserId());
					rstUserFunction = pstmUserFunction.executeQuery();
					while (rstUserFunction.next()) {
						bFound = false;
						int iIndex = 0;
						for (iIndex = 0;
							iIndex < vtFunctionTree.size();
							iIndex++) {
							objTmp =
								(stFunction) vtFunctionTree.elementAt(iIndex);
							if (objTmp
								.strFunctionIdDown
								.equals(
									rstUserFunction
										.getString(
											(String) dbFactory
												.getGlobalEnviron()
												.getServletContext()
												.getAttribute(
												Constant
													.FIELD_NAME_SUB_FUNCTION_FUNCTION_ID))
										.trim())) {
								bFound = true;
								break;
							}
						} //for
						//原先就存在之程式功能只要更新SubFunction,不存在的程式功能就要將其新增至結構中
						//若是 exclude 為 'Y' 表示要將該功能刪除,否則表示要加入
						if (bFound) {
							if (rstUserFunction
								.getString(
									(String) dbFactory
										.getGlobalEnviron()
										.getServletContext()
										.getAttribute(
										Constant.FIELD_NAME_EXCLUDE))
								!= null
								&& rstUserFunction
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_EXCLUDE))
									.trim()
									.equals("Y"))
								vtFunctionTree.remove(iIndex);
							else {
								objTmp =
									(stFunction) vtFunctionTree.elementAt(
										iIndex);
								objTmp.strSubFunction =
									rstUserFunction
										.getString(
											(String) dbFactory
												.getGlobalEnviron()
												.getServletContext()
												.getAttribute(
												Constant
													.FIELD_NAME_SUB_FUNCTION))
										.trim();
								vtFunctionTree.set(iIndex, objTmp);
							}
						} else {
							PreparedStatement pstmFunctionDetail = null;
							ResultSet rstFunctionDetail = null;
							String strFunctionDetailSql =
								new String(
									"select * from "
										+ (String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.TABLE_NAME_FUNCTION)
										+ " where "
										+ (String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_FUNCTION_ID)
										+ " = ?");
						
							if (pstmFunctionDetail == null)
								pstmFunctionDetail =
									conDbConnection.prepareStatement(
										strFunctionDetailSql);
							pstmFunctionDetail.setString(
								1,
								rstUserFunction
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant
												.FIELD_NAME_SUB_FUNCTION_FUNCTION_ID))
									.trim());
							rstFunctionDetail =
								pstmFunctionDetail.executeQuery();
							if (rstFunctionDetail.next()) {
								if (rstFunctionDetail
									.getString(
										(String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.FIELD_NAME_PROPERTY))
									.equalsIgnoreCase("M"))
									getOneFunction(
										rstUserFunction
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_SUB_FUNCTION_FUNCTION_ID))
											.trim(),
										null);
								else {
									stFunction tmpStFunction = new stFunction();
									tmpStFunction.strFunctionIdDown =
										rstFunctionDetail
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_SUB_FUNCTION_FUNCTION_ID))
											.trim();
									tmpStFunction.strFuncName =
										rstFunctionDetail
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_FUNCTION_NAME))
											.trim();
									tmpStFunction.strProperty =
										rstFunctionDetail
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_PROPERTY))
											.trim();
									tmpStFunction.strUrl =
										rstFunctionDetail
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant.FIELD_NAME_URL))
											.trim();
									tmpStFunction.strTargetWindow =
										rstFunctionDetail
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_TARGET_WINDOW))
											.trim();
									tmpStFunction.strRemark =
										rstFunctionDetail
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_REMARK))
											.trim();
									tmpStFunction.strHitCountUrl =
										rstFunctionDetail
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_HIT_COUNT_URL))
											.trim();
									tmpStFunction.strSubFunction =
										rstUserFunction
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_SUB_FUNCTION))
											.trim();
									vtFunctionTree.addElement(tmpStFunction);
								}
							} // if (rstFunctionDetail.next())
							else {
								this.setLastError(
									"retriveProgramStructure()",
									"Function id '"
										+ rstUserFunction
											.getString(
												(String) dbFactory
													.getGlobalEnviron()
													.getServletContext()
													.getAttribute(
													Constant
														.FIELD_NAME_SUB_FUNCTION_FUNCTION_ID))
											.trim()
										+ "'未存於"
										+ (String) dbFactory
											.getGlobalEnviron()
											.getServletContext()
											.getAttribute(
											Constant.TABLE_NAME_FUNCTION)
										+ "中");
								bReturnStatus = false;
							}
						} //if( bFound && rstUserFunction.getString((String)dbFactory.getGlobalEnviron().getServletContext().getAttribute(Constant.FIELD_NAME_EXCLUDE)).trim().equals("Y"))
					} //while(rstUserFunction.next())
				} //if (bReturnStatus)
			} //try
			catch (SQLException ex) {
				setLastError(
					"UserInfo.retriveProgramStructure():UserFunction",
					ex);
				bReturnStatus = false;
			} //catch( SQLException ex )
		} //if( bReturnStatus )
		else {
			writeDebugLog(
				Constant.DEBUG_DEBUG,
				"UserInfo.retriveProgramStructure()",
				"This System has no UserFunc extention ");
		}

		for (int i = 0; i < vtFunctionTree.size(); i++) {
			writeDebugLog(
				Constant.DEBUG_DEBUG,
				"UserInfo.retriveProgramStructure()",
				"The '"
					+ String.valueOf(i)
					+ "'th func_id_up = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strFunctionIdUp
					+ "', seq = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strSeq
					+ "', func_id_down = '"
					+ (
						(stFunction) vtFunctionTree.elementAt(
							i)).strFunctionIdDown
					+ "', func_name_up = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strFuncNameUp
					+ "', image_file__on_up = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strImageFileOnUp
					+ "', image_file__off_up = '"
					+ (
						(stFunction) vtFunctionTree.elementAt(
							i)).strImageFileOffUp
					+ "', remark_up = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strRemarkUp
					+ "', sub_function_up = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strSubFunctionUp
					+ "', func_name = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strFuncName
					+ "', image_file_on = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strImageFileOn
					+ "', image_file_off = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strImageFileOff
					+ "', utl = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strUrl
					+ "', property = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strProperty
					+ "', target_window = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strTargetWindow
					+ "', sub_function = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strSubFunction
					+ "', remark = '"
					+ ((stFunction) vtFunctionTree.elementAt(i)).strRemark
					+ "'");
		}
		return bReturnStatus;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/7 下午 09:21:32)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.util.Vector
			 */
	public Vector getUserFunctionTree() {
		return vtFunctionTree;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/3 下午 04:39:01)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 */
	public boolean setUserId(String strThisUserId) {
		boolean bReturnStatus = true;
		if (strThisUserId != null) {
			//		if( !strThisUserId.equals( strUserId ) )
			//		{
			//			writeDebugLog(Constant.DEBUG_INFORMATION,"UserInfo.setUserid()","User id has been set from '"+this.getUserId()+"' to '"+strThisUserId+"' successfully");
			strUserId = strThisUserId;
			bRefreshed = false;
			bPasswordChecked = false;
			if (bAutoRefresh)
				bReturnStatus = this.refresh();
			//		}
			//		else
			//			writeDebugLog(Constant.DEBUG_INFORMATION,"UserInfo.setUserid()","User id has not been set because the input user id '"+strThisUserId+"' is identical to original user id '"+this.getUserId()+"'.");
		} else {
			strUserId = "";
			bRefreshed = false;
			bPasswordChecked = false;
			//		writeDebugLog(Constant.DEBUG_WARNING,"UserInfo.setUserid()","The input User id is null set to '"+this.getUserId()+"'.");
		}
		return bReturnStatus;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期：(2001/3/8 下午 01:22:38)
			 * 傳入參數：
			 * 建立者  ：Administrator
			 * 傳回值  ： 
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * 
			 * @return boolean
			 */
	public boolean hasAnyProgramExecute() {
		boolean bReturnStatus = true;
		if (!bRefreshed)
			bReturnStatus = this.refresh();
		if (bReturnStatus) {
			if (vtFunctionTree.size() == 0)
				bReturnStatus = false;
			else {
				int i;
				bReturnStatus = false;
				for (i = 0; i < vtFunctionTree.size(); i++) {
					if (((stFunction) vtFunctionTree.elementAt(i))
						.strProperty
						.equalsIgnoreCase("P")) {
						bReturnStatus = true;
						break;
					}
				}
			}
		}
		return bReturnStatus;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getFuncName(int iIndex) {
		if (iIndex < this.getSizeOfUserFuncTree())
			return ((stFunction) vtFunctionTree.elementAt(iIndex)).strFuncName;
		else {
			setLastError(
				"UserInfo.getFuncName()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getFuncNameUp(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strFuncNameUp;
		else {
			setLastError(
				"UserInfo.getFuncNameIdUp()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getFunctionIdDown(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(
					iIndex)).strFunctionIdDown;
		else {
			setLastError(
				"UserInfo.getFunctionIdDown()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getFunctionIdUp(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strFunctionIdUp;
		else {
			setLastError(
				"UserInfo.getFunctionIdUp()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getImageFileOn(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strImageFileOn;
		else {
			setLastError(
				"UserInfo.getImageFile()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}
	public String getImageFileOff(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strImageFileOff;
		else {
			setLastError(
				"UserInfo.getImageFile()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/9 上午 04:25:31)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 * @param iIndex int
	 */
	public String getImageFileOnUp(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strImageFileOnUp;
		else {
			setLastError(
				"UserInfo.getIamgeFileUp()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}
	public String getImageFileOffUp(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(
					iIndex)).strImageFileOffUp;
		else {
			setLastError(
				"UserInfo.getIamgeFileUp()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/9 上午 04:25:31)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 * @param iIndex int
	 */
	public String getProperty(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return ((stFunction) vtFunctionTree.elementAt(iIndex)).strProperty;
		else {
			setLastError(
				"UserInfo.getProperty()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getRemark(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return ((stFunction) vtFunctionTree.elementAt(iIndex)).strRemark;
		else {
			setLastError(
				"UserInfo.getRemark()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}
	public String getHitCountUrl(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strHitCountUrl;
		else {
			setLastError(
				"UserInfo.getHitCountUrl()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getRemarkUp(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return ((stFunction) vtFunctionTree.elementAt(iIndex)).strRemarkUp;
		else {
			setLastError(
				"UserInfo.getRemarkUp()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}
	public String getHitCountUrlUp(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strHitCountUrlUp;
		else {
			setLastError(
				"UserInfo.getHitCountUrlUp()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getSeq(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return ((stFunction) vtFunctionTree.elementAt(iIndex)).strSeq;
		else {
			setLastError(
				"UserInfo.getSeq()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:23:22)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return int
			 */
	public int getSizeOfUserFuncTree() {
		return vtFunctionTree.size();
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getTargetWindow(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strTargetWindow;
		else {
			setLastError(
				"UserInfo.getTargetWindow()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/9 上午 04:25:31)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return java.lang.String
			 * @param iIndex int
			 */
	public String getUrl(int iIndex) {
		if (iIndex < vtFunctionTree.size()) 
			return ((stFunction) vtFunctionTree.elementAt(iIndex)).strUrl;
		else {
			setLastError(
				"UserInfo.getUrl()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}

	public String getSubFunctionUp(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strSubFunctionUp;
		else {
			setLastError(
				"UserInfo.getSubFunctionUp()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}

	public String getSubFunction(int iIndex) {
		if (iIndex < vtFunctionTree.size())
			return (
				(stFunction) vtFunctionTree.elementAt(iIndex)).strSubFunction;
		else {
			setLastError(
				"UserInfo.getSubFunction()",
				"The size of vtFunctionTree is '"
					+ String.valueOf(vtFunctionTree.size())
					+ "', input index is '"
					+ String.valueOf(iIndex)
					+ "' out of range");
			return null;
		}
	}

	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/3 下午 04:41:18)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return boolean
	 * @param strThisPassword java.lang.String
	 */
	public int checkPassword(String strThisPassword) {
		int iReturnStatus = 1;
		boolean bTmpStatus = false;
		PreparedStatement pstmUpdateTuser = null;
		String strUpdateTuserSql =
			new String(
				"update "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.TABLE_NAME_USER_ID)
					+ " set "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_LAST_LOGON_DATE)
					+ " = ? where "
					+ (String) dbFactory
						.getGlobalEnviron()
						.getServletContext()
						.getAttribute(
						Constant.FIELD_NAME_USER_ID)
					+ " = ?");
		EncryptionBean encoder =
			new EncryptionBean(dbFactory.getGlobalEnviron(), dbFactory);
		String strEncryptedPassword = new String("");

		bPasswordChecked = false;
		if (strThisPassword != null) {
			writeDebugLog(
				Constant.DEBUG_DEBUG,
				"UserInfo.checkPassword()",
				"Input password is '"
					+ strThisPassword
					+ "', the password in database is '"
					+ this.getPassword()
					+ "'");
			writeDebugLog(
				Constant.DEBUG_DEBUG,
				"UserInfo.checkPassword()",
				"The last password date = '"
					+ getROCDate(dteLastPasswordDate)
					+ "' password expiration days is '"
					+ String.valueOf(iPasswordExpirationDays)
					+ "', password warning days is '"
					+ String.valueOf(iPasswordWarningDays)
					+ "'");
			if (!bCaseSenstive)
				strThisPassword = strThisPassword.toUpperCase();
			if (dbFactory.getGlobalEnviron().getPasswordEncrypted())
				strEncryptedPassword =
					encoder.getEncryptedPassword(strThisPassword);
			else
				strEncryptedPassword = strThisPassword;
			writeDebugLog(
				Constant.DEBUG_DEBUG,
				"UserInfo.checkPassword()",
				"The Encrypted password is '" + strEncryptedPassword + "'");
			bTmpStatus = strEncryptedPassword.equals(this.getPassword());
			if (bTmpStatus) {
				bPasswordChecked = true;
				Connection conDb = null;
				//R00393 Edit by Leo Huang (EAONTECH) Start
				//Calendar cldToday = Calendar.getInstance();
				Calendar cldToday = commonUtil.getBizDateByRCalendar();
				System.out.println(cldToday.getTime());
//	R00393			Edit by Leo Huang (EAONTECH) Start
				try {
					conDb = dbFactory.getConnection("UserInfo.checkPassword()");
					
					if (conDb != null) {
						pstmUpdateTuser =
							conDb.prepareStatement(strUpdateTuserSql);
						pstmUpdateTuser.setString(
							1,
							commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
						pstmUpdateTuser.setString(2, strUserId);
						int i = pstmUpdateTuser.executeUpdate();
						if (i != 1) {
							setLastError(
								this.getClass().getName() + "checkPassword()",
								"Update USER LLOGD fiail");
						}
					}
					dbFactory.releaseConnection(conDb);
				} catch (Exception ex) {
					setLastError(
						this.getClass().getName() + "checkPassword()",
						ex);
					if (conDb != null)
						dbFactory.releaseConnection(conDb);
				}
				iReturnStatus = 0;
				if (bCheckPasswordAging) {
					if (dteLastPasswordDate != null) {
						long lDaysLeft =
							CommonUtil.diffDate(
								cldToday.getTime(),
								dteLastPasswordDate);
						//					writeDebugLog(Constant.DEBUG_DEBUG,"UserInfo.checkPassword()","The Days left is '"+String.valueOf(lDaysLeft)+"'");
						if (lDaysLeft > iPasswordExpirationDays) {
							//已過期
							iReturnStatus = 1;
							setLastError(
								"UserInfo.checkPassword()",
								strUserId
									+ " 的密碼已過期:前次更改密碼時間為 "
									+ getROCDate(dteLastPasswordDate)
									+ " , 已超過 "
									+ String.valueOf(iPasswordExpirationDays)
									+ " 天以上,請先更改密碼再進行其他作業");
//密碼到期警告功能不全,暫時取消
//						} else {
//							if (lDaysLeft
//								> (iPasswordExpirationDays
//									- iPasswordWarningDays)) {
								//要警告
//								iReturnStatus = 2;
//								setLastError(
//									"UserInfo.checkPassword()",
//									strUserId
//										+ " 的密碼還剩 "
//										+ String.valueOf(
//											iPasswordExpirationDays
//												- lDaysLeft)
//										+ " 天就要到期,是否要更改密碼?");
//							}
						}
					} else {
						//					bPasswordChecked = false;
						iReturnStatus = 9; //第一次登錄
						setLastError(
							"UserInfo.checkPassword()",
							strUserId + "第一次登入系統,請更新密碼及確認個人資料;密碼未更新,則無法操作其它功能");
					}
				}
				// 將密碼錯誤次數歸零
				passwordErrorCounter = 0;
			} else {
				bPasswordChecked = false;
				iReturnStatus = 10;
				if (strUserType != null && strUserType.equalsIgnoreCase("K")) {
					// 屬於經代大眾的使用者不需鎖定密碼錯誤次數
					passwordErrorCounter = 0;
				}
				
				if (++passwordErrorCounter >= maxPasswordError) {
					// Change user status to invalid --> I
					String sqlUpdateStatus =
						"update "
							+ (String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.TABLE_NAME_USER_ID)
							+ " set "
							+ (String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.FIELD_NAME_USER_STATUS)
							+ " = 'I' where "
							+ (String) dbFactory
								.getGlobalEnviron()
								.getServletContext()
								.getAttribute(
								Constant.FIELD_NAME_USER_ID)
							+ " ='"
							+ strUserId
							+ "' ";
					Connection con = null;
					Statement stmt = null;
					try {
						con =
							dbFactory.getConnection("UserInfo.checkPassword()");
						stmt = con.createStatement();
						if (stmt.executeUpdate(sqlUpdateStatus) > 0) {
							setLastError(
								"UserInfo.checkPassword()",
								strUserId
									+ " 密碼錯誤次數超過 "
									+ String.valueOf(maxPasswordError)
									+ " 帳號將鎖定 !");
						}
					} catch (SQLException ex) {
						writeDebugLog(
							Constant.DEBUG_ERROR,
							"UserInfo.checkPassword()",
							ex.getMessage());
					} finally {
						try {
							if (stmt != null)
								stmt.close();
							if (con != null)
								dbFactory.releaseConnection(con);
						} catch (SQLException ex) {
						}
					}
				} else {
					setLastError(
						"UserInfo.checkPassword()",
						strUserId + " 密碼錯誤(請檢查您輸入密碼的大小寫)");
				}

			}
		} else {
			//		writeDebugLog(Constant.DEBUG_WARNING,"UserInfo.checkPassword()","Input password is null");
			bPasswordChecked = false;
			iReturnStatus = 1;
		}
		return iReturnStatus;
		//	bPasswordChecked = true;
		//	return 0;
	} /**
			 * 方法名稱：。
			 * 方法功能：。
			 * 建立日期： (2001/3/17 上午 08:24:57)
			 * 傳入參數：
			 * 傳回值  ：
			 * 修改紀錄：
			 * 日   期    修 改 者     修      改      內       容
			 * ========= =========== ===========================================================
			 * 
			 * @return boolean
			 * @param strFuncId java.lang.String
			 */
	public boolean checkPrivilege(String strFuncId) {
		int i;
		boolean bReturnStatus = true;

		if (strFuncId == null) {
			setLastError("checkPrivilege()", "The input parameter is null");
		} else {
			if (!bRefreshed)
				bReturnStatus = this.refresh();

			bReturnStatus = isPasswordChecked();

			if (bReturnStatus) {
				bReturnStatus = false;
				if (this.getSizeOfUserFuncTree() > 0) {
					for (i = 0; i < this.getSizeOfUserFuncTree(); i++) {
						if (this.getFunctionIdDown(i).equals(strFuncId)) {
							bReturnStatus = true;
							break;
						}
					}
				}
			}
		}
		return bReturnStatus;
	}

	public boolean checkPrivilegeAndSubFunction(
		String strFuncId,
		String strSubFunction) {
		int iIndex = 0;
		boolean bReturnStatus = true;

		if (strFuncId == null || strSubFunction == null) {
			setLastError(
				"checkPrivilegeAndSubFunction()",
				"The function id or sub function is null");
		} else {
			if (!bRefreshed)
				bReturnStatus = this.refresh();

			bReturnStatus = isPasswordChecked();

			if (bReturnStatus) {
				bReturnStatus = false;
				if (this.getSizeOfUserFuncTree() > 0) {
					for (iIndex = 0;
						iIndex < this.getSizeOfUserFuncTree();
						iIndex++) {
						if (this.getFunctionIdDown(iIndex).equals(strFuncId)) {
							bReturnStatus = true;
							break;
						}
					}
				}
				/*
				 *	93/03/30 added by Andy : 再檢核該程式之子功能 
				 */
				if (bReturnStatus) {
					if (this.getSubFunction(this.getFunctionIdDown(iIndex))
						!= null) {
						if (this
							.getSubFunction(this.getFunctionIdDown(iIndex))
							.toLowerCase()
							.indexOf(strSubFunction.toUpperCase())
							== -1)
							bReturnStatus = false;
					} else
						bReturnStatus = false;
				}
			}
		}
		return bReturnStatus;
	}

	/**
		 * 方法名稱：。
		 * 方法功能：。
		 * 建立日期： (2001/3/10 下午 11:07:38)
		 * 傳入參數：
		 * 傳回值  ：
		 * 修改紀錄：
		 * 日   期    修 改 者     修      改      內       容
		 * ========= =========== ===========================================================
		 * 
		 * @return com.aegon.comlib.dbFactory
		 */
	public DbFactory getDbFactory() {
		return dbFactory;
	}
	public String getFuncName(String strThisFuncId) {
		int i;
		String strReturnFuncName = new String("");

		if (strThisFuncId != null) {
			for (i = 0; i < this.getSizeOfUserFuncTree(); i++) {
				if (strThisFuncId.equals(this.getFunctionIdUp(i))) {
					strReturnFuncName = this.getFuncNameUp(i);
					break;
				} else if (strThisFuncId.equals(this.getFunctionIdDown(i))) {
					strReturnFuncName = this.getFuncName(i);
					break;
				}
			}
			if (i >= this.getSizeOfUserFuncTree()) {
				strReturnFuncName =
					"'" + strThisFuncId + "' not found in function tree";
			}
		} else {
			setLastError("UserInfo.getFuncName()", "The input func id is null");
		}
		return strReturnFuncName;
	}

	public boolean isPasswordChecked() {
		return bPasswordChecked;
	}

	/**
		 * 方法名稱：。
		 * 方法功能：。
		 * 建立日期： (2001/3/11 下午 07:41:32)
		 * 傳入參數：
		 * 傳回值  ：
		 * 修改紀錄：
		 * 日   期    修 改 者     修      改      內       容
		 * ========= =========== ===========================================================
		 * 
		 * @param bThisCaseSenstive boolean
		 */
	public void setCaseSenstive(boolean bThisCaseSenstive) {
		bCaseSenstive = bThisCaseSenstive;
	}
	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/11 下午 07:49:43)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @param bThisCheckPasswordAging boolean
	 */
	public void setCheckPasswordAging(boolean bThisCheckPasswordAging) {
		bCheckPasswordAging = bThisCheckPasswordAging;
	}

	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/9 上午 04:25:31)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 * @param iIndex int
	 */
	public String getDefaultGroup() {
		return strDefaultGroup;
	}

	/**
	 * 方法名稱：。
	 * 方法功能：。
	 * 建立日期： (2001/3/11 下午 07:49:43)
	 * 傳入參數：
	 * 傳回值  ：
	 * 修改紀錄：
	 * 日   期    修 改 者     修      改      內       容
	 * ========= =========== ===========================================================
	 * 
	 * @param bThisPasswordChecked boolean
	 */
	public void setPasswordChecked(boolean bThisPasswordChecked) {
		bPasswordChecked = bThisPasswordChecked;
	}

	/**
		 * 請於此處加入方法的說明。
		 * 建立日期： (2002/9/26 上午 08:47:31)
		 * @return int
		 */
	public int getPasswordExpirationDays() {
		return iPasswordExpirationDays;
	}
	/**
		 * 請於此處加入方法的說明。
		 * 建立日期： (2002/10/3 下午 02:41:04)
		 * @return java.lang.String
		 * @param strThisDpDsk java.lang.String
		 */
	public void setPasswordExpirationDays(int iThisPasswordExpirationDays) {
		if (iThisPasswordExpirationDays >= 0)
			iPasswordExpirationDays = iThisPasswordExpirationDays;
	} /**
			 * 請於此處加入方法的說明。
			 * 建立日期： (2002/10/3 下午 02:43:13)
			 * @param strThisOffice java.lang.String
			 */

	public boolean checkForFieldName(ResultSet rstInput, String strFieldName) {
		boolean bReturnStatus = false;
		try {
			ResultSetMetaData mdInput = rstInput.getMetaData();
			int i = 0;
			for (i = 1; i <= mdInput.getColumnCount(); i++) {
				if (strFieldName.equalsIgnoreCase(mdInput.getColumnName(i)))
					break;
			}
			if (i <= mdInput.getColumnCount())
				bReturnStatus = true;
		} catch (SQLException e) {
			setLastError("UserInfo.checkForFieldName()", e);
		}
		return bReturnStatus;
	}

	public int getPasswordWarningDays() {
		return iPasswordWarningDays;
	}

	public void setPassowrdWarningDays(int iThisPassowrdWarningDays) {
		if (iThisPassowrdWarningDays >= 0)
			iPasswordWarningDays = iThisPassowrdWarningDays;
	}

	public String getSubFunction(String strThisFuncId) {
		int i;
		String strReturnSubFunction = new String("");

		if (strThisFuncId != null) {
			for (i = 0; i < this.getSizeOfUserFuncTree(); i++) {
				if (strThisFuncId.equals(this.getFunctionIdDown(i))) {
					strReturnSubFunction = this.getSubFunction(i);
					break;
				}
			}
			if (i >= this.getSizeOfUserFuncTree()) {
				strReturnSubFunction =
					"'" + strThisFuncId + "' not found in function tree";
			}
		} else {
			setLastError(
				"UserInfo.getSubFunction()",
				"The input func id is null");
		}
		return strReturnSubFunction;
	}

	public String getEmail() {
		return strEmail;
	}
	public void setEmail(String email) {
		this.strEmail = email;
	}
	public String getSecretQuestion() {
		return strSQ;
	}
	public void setSecretQuestion(String sq) {
		this.strSQ = sq;
	}
	public String getSecretAnswer() {
		return strSA;
	}
	public void setSecretAnswer(String sa) {
		this.strSA = sa;
	}

}