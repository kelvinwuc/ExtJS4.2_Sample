package com.mossle.student;

import java.sql.*;

public class JdbcTest {

	public static void main(String[] args) {
		String sql = "select * from student where id>=? ";
		Connection conn = null;
		PreparedStatement pstat = null;
		ResultSet rs = null;
		try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test?useSSL=false", "root", "kk541000");
            pstat = conn.prepareStatement(sql);
            pstat.setLong(1, 1L);
            rs = pstat.executeQuery();
            while(rs.next()){
            	System.out.println(rs.getString("name"));
            }
        } catch(Exception ex) {
            System.err.println(ex);
        } finally{
        	try{
        		if(rs!=null) rs.close();
        	} catch(Exception e){
        		e.printStackTrace();
        	}
        	try{
        		if(pstat!=null) rs.close();
        	} catch(Exception e){
        		e.printStackTrace();
        	}
        	try{
        		if(conn!=null) rs.close();
        	} catch(Exception e){
        		e.printStackTrace();
        	}
        }

	}

}
