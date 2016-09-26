package com.aegon.comlib;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.aegon.security.Security;

public class DbFactory extends RootClass {
	private GlobalEnviron globalEnviron = new GlobalEnviron();
	// R00393 edit by Leo Huang
	private String RootFolder = "";
	// R00393 edit by Leo Huang
	private static DataSource dsAS400 = null;
	private static DataSource dsAS401 = null;
	private static Hashtable htAS400Connection = new Hashtable(10, 10);
	private static long warningDuration = 3 * 60 * 1000; // 3 miniutes
	private static long killDuration = 20 * 60 * 1000; // 20 miniutes

	public static final int AEGON400 = 1;
	public static final int AEGON401 = 2;

	// R00393 edit by Leo Huang
	public String getRootFolder() {
		return RootFolder;
	}

	public void setRootFolder(String RootFolder) {
		this.RootFolder = RootFolder;
	}
	// R00393 edit by Leo Huang

	private class ConnectionData {

		public long startTime = 0; // begin time of get connection
		public String programId = ""; // caller id
		public Connection con = null; // reference to this connection

		public ConnectionData(String progId) {
			this(progId, null);
		}

		public ConnectionData(String progId, Connection thisCon) {
			startTime = System.currentTimeMillis();
			programId = progId;
			con = thisCon;
		}

	}

	/**
	 * Constructor for DbFactory
	 */
	public DbFactory() {
		super();
	}

	/**
	 * Constructor for DbFactory
	 */
	public DbFactory(GlobalEnviron thisEnv) {
		super();
		if (thisEnv != null) {
			this.globalEnviron = thisEnv;
			this.setDebugFileName(thisEnv.getDebugFileName());
			this.setDebug(thisEnv.getDebug());
			this.setSessionId(thisEnv.getSessionId());
		}

		lookupDataSource();
	}

	/**
	 * Method lookupDataSource.
	 */
	private void lookupDataSource() {
		if (dsAS400 == null) {
			try {
				InitialContext initContext = new InitialContext();
				Context ctx = (Context) initContext.lookup("java:comp/env");
				dsAS400 = (DataSource) ctx.lookup(Constant.CAPSIL_DATA_SOURCE_AEGON400);
				globalEnviron.writeDebugLog(Constant.DEBUG_INFORMATION, "DbFactory.lookupDataSource()", "get " + Constant.CAPSIL_DATA_SOURCE_AEGON400 + " DataSource successfully");
			} catch (Exception e) {
				globalEnviron.setLastError("Getting " + Constant.CAPSIL_DATA_SOURCE_AEGON400 + " AS400 Data source Naming service exception: ", e);
			}
		}

		if (dsAS401 == null) {
			try {
				InitialContext initContext = new InitialContext();
				Context ctx = (Context) initContext.lookup("java:comp/env");
				dsAS401 = (DataSource) ctx.lookup(Constant.CAPSIL_DATA_SOURCE_AEGON401);
				globalEnviron.writeDebugLog(Constant.DEBUG_INFORMATION, "DbFactory.lookupDataSource()", "get " + Constant.CAPSIL_DATA_SOURCE_AEGON401 + " DataSource successfully");
			} catch (Exception e) {
				globalEnviron.setLastError("Getting " + Constant.CAPSIL_DATA_SOURCE_AEGON401 + " AS400 Data source Naming service exception: ", e);
			}
		}
	}

	public GlobalEnviron getGlobalEnviron() {
		return this.globalEnviron;
	}

	public Connection getConnection(String progId) {
		return getAS400Connection(progId);
	}

	public void releaseConnection(Connection conThisConnection) {
		releaseAS400Connection(conThisConnection);
	}

	public void setGlobalEnviron(GlobalEnviron thisGlobalEnviron) {
		if (thisGlobalEnviron != null) {
			this.globalEnviron = thisGlobalEnviron;
			this.setDebugFileName(thisGlobalEnviron.getDebugFileName());
			this.setDebug(thisGlobalEnviron.getDebug());
			this.setSessionId(thisGlobalEnviron.getSessionId());
		}
	}

	private Connection getAS400Connection(String progId, boolean useDataSource, int conServer) {
		Connection conTmp = null;

		String strCapsilUrl = null;
		String strCapsilUserId = null;
		String strCapsilPassword = null;

		if (conServer == AEGON400) {
			strCapsilUrl = globalEnviron.getAS400DbJdbcUrlAEGON400();
			strCapsilUserId = globalEnviron.getAS400DbUserIdAEGON400();
			strCapsilPassword = Security.decrypt(globalEnviron.getAS400DbPasswordAEGON400());
		} else if (conServer == AEGON401) {
			strCapsilUrl = globalEnviron.getAS400DbJdbcUrlAEGON401();
			strCapsilUserId = globalEnviron.getAS400DbUserIdAEGON401();
			strCapsilPassword = Security.decrypt(globalEnviron.getAS400DbPasswordAEGON401());
		} else if (globalEnviron.getActiveAS400DataSource().trim().equals(Constant.CAPSIL_DATA_SOURCE_AEGON400)) {
			strCapsilUrl = globalEnviron.getAS400DbJdbcUrlAEGON400();
			strCapsilUserId = globalEnviron.getAS400DbUserIdAEGON400();
			strCapsilPassword = Security.decrypt(globalEnviron.getAS400DbPasswordAEGON400());
		} else {
			strCapsilUrl = globalEnviron.getAS400DbJdbcUrlAEGON401();
			strCapsilUserId = globalEnviron.getAS400DbUserIdAEGON401();
			strCapsilPassword = Security.decrypt(globalEnviron.getAS400DbPasswordAEGON401());
		}
		// System.out.println("strCapsilPassword="+strCapsilPassword);
		try {
			try {
				Class.forName(globalEnviron.getAS400DbJdbcDriverName());
				Properties props = new Properties();

				props.put("user", strCapsilUserId);
				props.put("password", strCapsilPassword);
				props.put("naming", globalEnviron.getAS400Naming());
				conTmp = DriverManager.getConnection(strCapsilUrl, props);
				writeDebugLog(Constant.DEBUG_DEBUG, "DbFactory.getAS400Connection()5.2", "get one connection from '" + strCapsilUrl + "' suessfully. ID = '" + String.valueOf(conTmp.hashCode()) + "'");
			} catch (Exception ex) {
				setLastError("DbFactory.getAS400Connection()3", ex);
			}

			synchronized (htAS400Connection) {
				htAS400Connection.put(conTmp, new ConnectionData(progId, conTmp));
			}
		} catch (Exception ex) {
			setLastError("DbFactory.getAS400Connection()9", ex);
			return null;
		}
		return conTmp;
	}

	public void releaseAS400Connection(Connection conThisConnection) {
		if (conThisConnection != null) {
			try {
				synchronized (htAS400Connection) {
					long lElapsTime = 0;
					long now = System.currentTimeMillis();
					ConnectionData tmpConData = null;
					Enumeration keys = htAS400Connection.keys();
					while (keys.hasMoreElements()) {
						Connection conKey = (Connection) keys.nextElement();
						tmpConData = (ConnectionData) htAS400Connection.get(conKey);
						if (now - tmpConData.startTime > killDuration) {
							writeDebugLog(Constant.DEBUG_WARNING, "kill connection ID=" + tmpConData.con.hashCode() + " Program ID=" + tmpConData.programId + " over than " + killDuration / (1000 * 60) + " minutes"); tmpConData.con.close();
						} else if (now - tmpConData.startTime > warningDuration) {
							setLastError(this.getClass().getName() + ".releaseAS400Connection()", "(" + tmpConData.programId + ") This connection has been issued longer than " + warningDuration / (1000 * 60) + " minutes");
						}
					}
					htAS400Connection.remove(conThisConnection);
					writeDebugLog(Constant.DEBUG_DEBUG, "DbFactory.releaseAS400Connection()", "release one AS400 connection suessfully. ID = '" + String.valueOf(conThisConnection .hashCode()) + "'. Total elaps time is " + String.valueOf(lElapsTime) + " milliseconds.");
				}
				conThisConnection.close();
			} catch (Exception e) {
				setLastError("DbFactory.releaseAS400Connection()", e);
			}
		}
	}

	public Connection getAS400Connection(String strProgId) {
		writeDebugLog(Constant.DEBUG_DEBUG, "DbFactory.getAS400Connection()", strProgId);
		return this.getAS400Connection(strProgId, true, 0);
	}

	/**
	 * @param strProgId : 呼叫程式代號
	 * @param server : 欲連線的Server代號 (DbFactory.AEGON400 -> 1, DbFactory.AEGON401 -> 2)
	 * @return java.sql.Connection
	 */
	public Connection getAS400Connection(String strProgId, int server) {
		writeDebugLog(Constant.DEBUG_DEBUG, "DbFactory.getAS400Connection()", strProgId);
		return this.getAS400Connection(strProgId, true, server);
	}

}