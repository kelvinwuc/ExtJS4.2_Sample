package com.aegon.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.aegon.web.DbOPController;

public final class DbFactory {
	
	private static final Log log = LogFactory.getLog(DbFactory.class);
	
	private static String mysqlDriver = "";
	private static String url = "";
	private static String user = "";
	private static String password = "";
	private static String jndiName = "";
	private static Context initCtx = null;
	private static DataSource ds = null;
	//private static ThreadLocal<Connection> connectionHolder = null;
	
	private DbFactory() {
	}

	static {
		Properties properties = new Properties();
		String configFile = "config.properties";
		File file = new File(configFile);
		log.info(file.getAbsolutePath());
		try{
			properties.load(new FileInputStream(file));
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
		
		mysqlDriver = properties.getProperty("db.mysql.driver");
		url = properties.getProperty("db.mysql.url");
		user = properties.getProperty("db.mysql.user");
		password = properties.getProperty("db.mysql.password");
		jndiName = properties.getProperty("db.WAS.jndiName");
		
		try {
			Class.forName(mysqlDriver);
			
			initCtx = new InitialContext(); //for WAS
			//Context envCtx = (Context) initCtx.lookup("java:comp/env"); //for tomcat
			ds = (DataSource)initCtx.lookup(jndiName);
			
		} catch (ClassNotFoundException e) {
			log.error(e.getMessage(), e);
		} catch(NamingException e) {
			log.error(e.getMessage(), e);
		}
	}	

	public static Connection getConnection() {
		 Connection conn = null;
		 try{
			 conn = DriverManager.getConnection(url, user, password);
			 log.info("obtain db connection.");
		 } catch (SQLException e) {
			log.error(e.getMessage(),e);
		 } catch(Exception e) {
			log.error(e.getMessage(),e);
		 }	     
		return conn;
	}
	
	public static Connection getDsConnection() {
		Connection conn = null;
		try{
			 conn = ds.getConnection();
			 log.info("obtain db connection from WAS DataSource.");
		 } catch (SQLException e) {
			log.error(e.getMessage(),e);
		 } catch(Exception e) {
			log.error(e.getMessage(),e);
		 }
		return conn;
	}
	
	public static void closeConnection(ResultSet rs, Statement stmt, Connection conn) {
		try {
			if (rs != null)
				rs.close();
			log.info("close ResultSet.");
		} catch (SQLException e) {
			log.error(e.getMessage(),e);
		} catch(Exception e) {
			log.error(e.getMessage(),e);
		}
		
		try {
			if (stmt != null)
				stmt.close();
			log.info("close Statement.");
		} catch (SQLException e) {
			log.error(e.getMessage(),e);
		} catch(Exception e) {
			log.error(e.getMessage(),e);
		}
		
		try {
			if (conn != null)
				conn.close();
			log.info("colose Connection.");
		} catch (SQLException e) {
			log.error(e.getMessage(),e);
		} catch(Exception e) {
			log.error(e.getMessage(),e);
		} 		
	}
	
	public static void closeConnection(Statement stmt, Connection conn) {		
		try {
			if (stmt != null)
				stmt.close();
			log.info("close Statement.");
		} catch (SQLException e) {
			log.error(e.getMessage(),e);
		} catch(Exception e) {
			log.error(e.getMessage(),e);
		}
		
		try {
			if (conn != null)
				conn.close();
			log.info("colose Connection.");
		} catch (SQLException e) {
			log.error(e.getMessage(),e);
		} catch(Exception e) {
			log.error(e.getMessage(),e);
		} 		
	}

	public static void closeConnection(Connection conn) {		
		try {
			if (conn != null)
				conn.close();
			log.info("close Connection.");
		} catch (SQLException e) {
			log.error(e.getMessage(),e);
		} catch(Exception e) {
			log.error(e.getMessage(),e);
		} 		
	}

}
