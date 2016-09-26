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
 * ��k�W�١G�C
 * ��k�\��G�C
 * �إߤ���G (2001/3/3 �U�� 04:39:01)
 * �ǤJ�ѼơG
 * �Ǧ^��  �G
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 */
public SessionInfo() {
	super();
	
}
/**
 * ��k�W�١G�C
 * ��k�\��G�C
 * �إߤ���G (2001/3/3 �U�� 04:39:01)
 * �ǤJ�ѼơG
 * �Ǧ^��  �G
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
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
 * ��k�W�١G�C
 * ��k�\��G�C
 * �إߤ���G (2001/3/3 �U�� 04:39:01)
 * �ǤJ�ѼơG
 * �Ǧ^��  �G
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
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
 * ��k�W�١G�C
 * ��k�\��G�C
 * �إߤ���G (2001/3/3 �U�� 04:39:01)
 * �ǤJ�ѼơG
 * �Ǧ^��  �G
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
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
 * ��k�W�١G�C
 * ��k�\��G�C
 * �إߤ���G (2001/3/3 �U�� 04:39:01)
 * �ǤJ�ѼơG
 * �Ǧ^��  �G
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
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
 * ��k�W�١G�C
 * ��k�\��G�C
 * �إߤ���G (2001/3/4 �W�� 08:38:53)
 * �ǤJ�ѼơG
 * �Ǧ^��  �G
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
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