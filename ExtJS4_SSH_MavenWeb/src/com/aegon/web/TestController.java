package com.aegon.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.WebUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.aegon.bean.Bean01;
import com.aegon.dao.Policy;
import com.aegon.dao.ReturnMsg;
import com.aegon.dao.Student;

@Controller
public class TestController {
	
	private static final Log log = LogFactory.getLog(TestController.class);
	
	/***
	 * 
	 * @Description: 1. WebSphere的Console URL :
	 *               	http://localhost:9060/ibm/console 
	 *               2. WebSphere
	 *               DataSource的connection pool size:資源-->JDBC-->資料來源-->data
	 *               source name(MySQLDB)-->連線儲存區:連線數目上下限
	 */
	
	DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	/*@Autowired
	private Bean01 bean01;*/
	
	@RequestMapping(value = "/hello", method = RequestMethod.GET)
	public ModelAndView hello(){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/hello
		//http://localhost:8080/Spring3Test/mvc/hello
		System.out.println("hello Spring");
		log.info("hello Spring");
		/*bean01.setName("KK");
		log.info("hello Spring," + bean01 + ",name:" + bean01.getName());*/
		return new ModelAndView("hello Spring..");
	}
	
	//produces = "application/json"不見得要設定
	@RequestMapping(value = "/hellojson", method = RequestMethod.GET, produces = "application/json")
	public @ResponseBody Student helloJsonV01(){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/hellojson
		//http://localhost:8080/Spring3Test/mvc/hellojson,IE:下載JSON,chrome直接顯示
		System.out.println("hello JSON:Student");
		log.info("hello JSON:Student");
		Student student = new Student();
		student.setName("KK");
		student.setPhone(new String[]{"123", "456"});
		return student;
	}
	
	@RequestMapping(value = "{name}", method = RequestMethod.GET)
	public @ResponseBody Student helloJsonV02(@PathVariable String name){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/KelvinWu
		//http://localhost:8080/Spring3Test/mvc/KelvinWu,IE:下載JSON,chrome直接顯示
		System.out.println("hello JSON:Student");
		log.info("hello JSON:Student");
		Student student = new Student();
		student.setName(name);
		student.setPhone(new String[]{"123", "456"});
		return student;
	}
	
	@RequestMapping(value = "/hellojson/{name}", method = RequestMethod.GET)
	public @ResponseBody Student helloJsonV03(@PathVariable String name){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/hellojson/KelvinWu
		//http://localhost:8080/Spring3Test/mvc/hellojson/KelvinWu,IE:下載JSON,chrome直接顯示
		//Spring 3.x 企业应用开发实战.pdf, p.522(pdf的p.546)
		System.out.println("hello JSON:Student");
		log.info("hello JSON:Student");
		Student student = new Student();
		student.setName(name);
		student.setPhone(new String[]{"123", "456"});
		return student;
	}
	
	@RequestMapping(value="/downimg", method=RequestMethod.GET)
	public void downImg(OutputStream os){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/downimg
		//http://localhost:8080/Spring3Test/mvc/downimg
		log.info("down img.");
		Resource res = new ClassPathResource("./imgs/01.jpg");
		try {
			FileCopyUtils.copy(res.getInputStream(), new java.io.BufferedOutputStream(os));
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/downimgV2/{imgId}", method=RequestMethod.GET)
	public byte[] downImgV02(@PathVariable String imgId){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/downimgV2/01
		//http://localhost:8080/Spring3Test/mvc/downimg2/123
		//Spring 3.x 企业应用开发实战.pdf, p.526(pdf的p.550)
		log.info("down img.:" + imgId);
		Resource res = new ClassPathResource("./imgs/" + imgId + ".jpg");
		byte[] fileData = null;
		try {
			fileData = FileCopyUtils.copyToByteArray(new java.io.BufferedInputStream(res.getInputStream()));
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
		return fileData;
	}
	
	@RequestMapping(value="/getdata/{policyNo}", method=RequestMethod.GET)
	public @ResponseBody Policy getDbData(@PathVariable String policyNo){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/getdata/1234567890
		//http://localhost:8080/Spring3Test/mvc/getdata
		log.info("connect to db.");
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "SELECT * FROM policy where policy_no = ?";
		Policy policy = new Policy();
		try {
			Context initCtx = new InitialContext();
			//tomcat
			//Context envCtx = (Context) initCtx.lookup("java:comp/env");
			//DataSource ds = (DataSource)envCtx.lookup("jdbc/mysql");
			
			//WAS
			DataSource ds = (DataSource)initCtx.lookup("jdbc/mysql");
			
			conn = ds.getConnection();
			if(conn != null) {
				log.info("get db connection !!");
				pstmt = conn.prepareStatement(sql);
				//pstmt.setString(1, "1234567890");
				pstmt.setString(1, policyNo);
				rs = pstmt.executeQuery();
				
				while(rs.next()){
					policy.setPolicyId(rs.getString("policy_id"));
					policy.setPolicyNo(rs.getString("policy_no"));
					policy.setLastUpdate(sdf.format(rs.getDate("last_update")));
					log.info("policy_no:" + rs.getString("policy_no") + ",date:" + sdf.format(rs.getDate("last_update")));
				}
				rs.close();
				pstmt.close();
				conn.close();
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		
		return policy;
	}
	
	@RequestMapping(value="/saveimg/{imgId}", method=RequestMethod.GET)
	public @ResponseBody ReturnMsg saveImg(HttpServletRequest request, @PathVariable String imgId){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/saveimg/01
		//http://localhost:8080/Spring3Test/mvc/saveimg
		ReturnMsg ret = new ReturnMsg();
		log.info("connect to db.");
		DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Connection conn = null;
		PreparedStatement pstmt = null;
		int total = 0;
		String sql = "INSERT file_repo(id, name, conten_type, data) values(?,?,?,?)";
		try {
			Context initCtx = new InitialContext();
			//for tomcat
			//Context envCtx = (Context) initCtx.lookup("java:comp/env");
			//DataSource ds = (DataSource)envCtx.lookup("jdbc/mysql");
			
			//for WAS
			DataSource ds = (DataSource)initCtx.lookup("jdbc/mysql");
			
			conn = ds.getConnection();
			if(conn != null) {
				log.info("get db connection !!");
				//檔案在C:\Program Files (x86)\IBM\WebSphere\AppServer\profiles\AppSrv01\imgs
				/*String path = request.getContextPath();
				String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";*/
				ServletContext context = request.getServletContext();
				String appPath = context.getRealPath("");
				log.info("appPath:" + appPath);
				File file = new File(appPath + "WEB-INF\\classes\\imgs",imgId + ".jpg");
				
				log.info("imgId:" + imgId + ",file.getAbsolutePath():" + file.getAbsolutePath());
				
				ret.setRet("file.getAbsolutePath():" + file.getAbsolutePath());
				ret.setUpdateDate(sdf.format(new Date()));
				InputStream is = new java.io.BufferedInputStream(new FileInputStream(file));
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(imgId));
				pstmt.setString(2, imgId);
				pstmt.setString(3, "jpg");
				pstmt.setBlob(4, is);
				total = pstmt.executeUpdate();
				//log.info("total:" + total);
				pstmt.close();
				conn.close();
				is.close();
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		
		return ret;
	}
	
	@ResponseBody
	@RequestMapping(value="/getimg/{imgId}", method=RequestMethod.GET)
	public byte[] getImgV2(@PathVariable String imgId){
		//http://localhost:9080/ExtJS4_SSH_MavenWeb/mvc/getimg/01
		//http://localhost:9080/Spring3Test/mvc/getimg/03
		log.info("connect to db.");
		DateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		byte[] fileData = null;
		java.io.InputStream is = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from file_repo where id = ? limit 1";
		try {
			Context initCtx = new InitialContext();
			//for tomcat
			//Context envCtx = (Context) initCtx.lookup("java:comp/env");
			//DataSource ds = (DataSource)envCtx.lookup("jdbc/mysql");
			
			//for WAS
			DataSource ds = (DataSource)initCtx.lookup("jdbc/mysql");
			
			conn = ds.getConnection();
			if(conn != null) {
				log.info("get db connection !!");					
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(imgId));
				rs = pstmt.executeQuery();
				while(rs.next()){
					Blob blob = rs.getBlob("data");
					is = new java.io.BufferedInputStream(blob.getBinaryStream());
				}
				rs.close();
				pstmt.close();
				conn.close();
				
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		
		
		try {
			fileData = FileCopyUtils.copyToByteArray(is);
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
		
		if(is != null){
			try {
				is.close();
			} catch (IOException e) {
				log.error(e.getMessage(), e);
			}
		}
			
		return fileData;
	}
}
