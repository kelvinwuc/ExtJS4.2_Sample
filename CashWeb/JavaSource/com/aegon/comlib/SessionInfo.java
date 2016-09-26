package com.aegon.comlib;

import java.io.*;
import java.sql.*;
import java.text.*;
import java.util.*;

public class SessionInfo extends RootClass
{
	private UserInfo uiSessionUserInfo = null;
	private AuditLogBean auditLogBean = null;

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
public SessionInfo() {
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
public SessionInfo(DbFactory thisDbFactory) 
{
	super();

	this.setDebugFileName(thisDbFactory.getGlobalEnviron().getDebugFileName());
	this.setDebug(thisDbFactory.getGlobalEnviron().getDebug());
	this.setSessionId(thisDbFactory.getSessionId());
	uiSessionUserInfo = new UserInfo( thisDbFactory );
	
}/**
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
public SessionInfo(DbFactory thisDbFactory,String strThisUserId) 
{
	super();

	this.setDebugFileName(thisDbFactory.getGlobalEnviron().getDebugFileName());
	this.setDebug(thisDbFactory.getGlobalEnviron().getDebug());
	this.setSessionId(thisDbFactory.getSessionId());
	uiSessionUserInfo = new UserInfo(  strThisUserId, thisDbFactory );
	
}/**
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
public SessionInfo(GlobalEnviron thisEnv) 
{
	super();

	this.setDebugFileName(thisEnv.getDebugFileName());
	this.setDebug(thisEnv.getDebug());
	this.setSessionId(thisEnv.getSessionId());
	uiSessionUserInfo = new UserInfo( thisEnv );
	
}/**
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
public SessionInfo(GlobalEnviron thisEnv,String strThisUserId) 
{
	super();

	this.setDebugFileName(thisEnv.getDebugFileName());
	this.setDebug(thisEnv.getDebug());
	this.setSessionId(thisEnv.getSessionId());
	uiSessionUserInfo = new UserInfo( thisEnv , strThisUserId);
	
}/**
 * 方法名稱：。
 * 方法功能：。
 * 建立日期： (2001/3/4 上午 08:38:53)
 * 傳入參數：
 * 傳回值  ：
 * 修改紀錄：
 * 日   期    修 改 者     修      改      內       容
 * ========= =========== ===========================================================
 * 
 * @return com.ns.comlib.NsUserInfo
 */         
public UserInfo getUserInfo() 
{
	return uiSessionUserInfo;
}

public void setAuditLogBean( AuditLogBean objThisAuditLogBean )
{
	if( objThisAuditLogBean != null )
		auditLogBean = objThisAuditLogBean;
}

public AuditLogBean getAuditLogBean()
{
	return auditLogBean;
}

}