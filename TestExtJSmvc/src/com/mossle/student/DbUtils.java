
package com.mossle.student;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class DbUtils {
    static {
        try {
        	Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch(Exception ex) {
            System.err.println(ex);
        }
    }

    static Connection getConn() throws Exception {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/testextjs?useSSL=false", "root", "kk541000");
    }

    static void close(ResultSet rs, Statement state, Connection conn) {
        if (rs != null) {
            try {
                rs.close();
            } catch(SQLException ex) {
                ex.printStackTrace();
            }
            rs = null;
        }
        if (state != null) {
            try {
                state.close();
            } catch(SQLException ex) {
                ex.printStackTrace();
            }
            state = null;
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            conn = null;
        }
    }
}
