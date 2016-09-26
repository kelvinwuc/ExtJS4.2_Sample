/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *  R00393  Leo Huang    			2010/09/16           現在時間取Capsil營運時間
 *  =============================================================================
 */
package com.aegon.comlib;

import java.sql.*;
import java.util.*;
import java.text.*;


/**
 * @author Administrator
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */
public class AuditLogBean extends RootClass 
{
	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private String strDbName = new String("CASH");
	private String strTableName = new String("AUDLOG");
	
	public AuditLogBean( GlobalEnviron objThisGlobalEnviron , DbFactory objThisDbFactory )
	{
		super();
		if( objThisGlobalEnviron != null )
		{
			globalEnviron = objThisGlobalEnviron;
			this.setDebug(globalEnviron.getDebug());
			this.setDebugFileName(globalEnviron.getDebugFileName());
			if(commonUtil == null){
				commonUtil = new CommonUtil(globalEnviron);
			}
		}
		if( objThisDbFactory != null )
			dbFactory = objThisDbFactory;
		else
		{
			dbFactory = new DbFactory( objThisGlobalEnviron );
		}
		
	}
	
	public AuditLogBean( GlobalEnviron objThisGlobalEnviron )
	{
		this ( objThisGlobalEnviron , null );
	}
	
	public AuditLogBean( DbFactory objThisDbFactory )
	{
		this( objThisDbFactory.getGlobalEnviron() ,objThisDbFactory );
	}
	
	public boolean writeAuditLog( String strProgId , String strUserId , String strAction , String strKey )
	{
		boolean bReturn = true;
		if( globalEnviron != null && globalEnviron.getAuditLogLevel() != Constant.AUDIT_LOG_NONE )
		{
			if( strProgId == null || strUserId == null || strAction == null || strKey == null )
			{
				setLastError(this.getClass().getName(),"ProgramId or UserId or Action or Key is null error ");
				bReturn = false;
			}
			else
			{
				if( (globalEnviron.getAuditLogLevel() == Constant.AUDIT_LOG_LOGON && strAction.equals("L")) ||
					(globalEnviron.getAuditLogLevel() == Constant.AUDIT_LOG_ALL )||
					(globalEnviron.getAuditLogLevel() == Constant.AUDIT_LOG_UPDATE && ( strAction.equals("A") || strAction.equals("U") || strAction.equals("D") ) ))
				{
					if( dbFactory == null )
					{
						setLastError(this.getClass().getName(),"dbFactory is null error");
						bReturn = false;
					}
					else
					{
						Connection conDb = null;
						try
						{
							conDb = dbFactory.getConnection("AuditLogBean.writeAuditLog()");
							if( conDb == null )
							{
								setLastError(this.getClass().getName(),dbFactory.getLastErrorMessage() );
								bReturn = false;
							}
							else
							{
								//R00393 Edit by Leo Huang (EAONTECH) Start 抓Capsil
								Calendar cldToday =commonUtil.getBizDateByRCalendar();
								//R00393  Edit by Leo Huang (EAONTECH) End
//								SimpleDateFormat sdfFormatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS");
								SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
								String strSql = "insert into "+strTableName+" (LOGDTE,USRID,FUNID,SUBFUN,KEYDAT) ";
								strSql += " values (?,?,?,?,?)";
//								strSql += " values ('"+sdfFormatter.format(cldToday.getTime())+"','"+strUserId+"','"+strProgId+"','"+strAction+"','"+strKey+"')";
//								writeDebugLog(Constant.DEBUG_DEBUG,this.getClass().getName(),strSql);
								PreparedStatement pstmtStatement = conDb.prepareStatement(strSql);
								pstmtStatement.setString(1,
									commonUtil.convertWesten2ROCDate1(cldToday.getTime())
									+sdfFormatter.format(cldToday.getTime()));
								pstmtStatement.setString(2,strUserId);
								pstmtStatement.setString(3,strProgId);
								pstmtStatement.setString(4,strAction);
								pstmtStatement.setString(5,strKey);
								if( pstmtStatement.executeUpdate() != 1 )
								{
									setLastError(this.getClass().getName() , "insert into "+strTableName+" failed");
									bReturn = false;
								}
								//dbFactory.releaseConnection(conDb);
							}
						}
						catch( Exception ex)
						{
							setLastError(this.getClass().getName(),ex);
							bReturn = false;
						}
						finally{
							dbFactory.releaseConnection(conDb);
						}
					}
				}
			}
		}
		
		return bReturn;
	}
	
	
}
