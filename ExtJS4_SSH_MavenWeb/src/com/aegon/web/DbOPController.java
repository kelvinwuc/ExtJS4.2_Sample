package com.aegon.web;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.aegon.bean.Bean01;
import com.aegon.util.DbFactory;

//@Controller
//@RequestMapping(value = "/dbop")
public class DbOPController {
	
	private static final Log log = LogFactory.getLog(DbOPController.class);
	
	//@Autowired
	private DbFactory dbFactory; 
	
	//@Autowired
	private Bean01 bean01;
	
	//@RequestMapping(value = "/fetch/{policyNo}", method = RequestMethod.GET)
	public ModelAndView fetch(@PathVariable String policyNo){
		//http://localhost:9080/JDBCTest_Web/mvc/dbop/fetch/1234567890
		DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		ModelAndView mav = new ModelAndView();
		
		log.info("hello fetch," + bean01 + ",name:" + bean01.getName());
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM policy where policy_no = ?";
		try {
			//conn = dbFactory.getDsConnection();
			conn = dbFactory.getConnection();
			if(conn != null){
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, policyNo);
				rs = pstmt.executeQuery();
				while(rs.next()){
					log.info("policy_no:" + rs.getString("policy_no") + ",date:" + sdf.format(rs.getDate("last_update")));
					mav.setViewName("/dbop/fetch");
					mav.addObject("policyno", rs.getString("policy_no"));
					mav.addObject("date", sdf.format(rs.getDate("last_update")));
				}
			}
			dbFactory.closeConnection(rs, pstmt, conn);
		} catch (SQLException e) {
			log.error(e.getMessage(),e);
		} catch (Exception e) {
			log.error(e.getMessage(),e);
		}
		return mav;
	}

}
