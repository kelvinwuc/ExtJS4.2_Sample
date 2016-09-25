package com.aegon.web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginController extends HttpServlet {

	public LoginController() {
		super();
	}

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");
		out.print("    This is ");
		out.print(this.getClass());
		out.println(", using the GET method");
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setCharacterEncoding("utf-8");
		
		String userName = request.getParameter("userName");
		String passWord = request.getParameter("passWord");
		String result = "";
		/**
		 * 判断用户名存不存在到思路：通过用户名那个去查找用户表，如果没有找到记录说明不存在用户
		 * 如果存在，取出记录（唯一的）核对密码，通过则登录成功，否则密码错误
		 * */
		if(userName.equals("admin")){ 
			if(passWord.equals("pwd")){
				/**
				 * 通过JSONObject构造返回到数据
				 * JSONObject json = new JSONObject();
				 * json.element("success", true);
				 * json.element("text", "登录成功!");
				 * **/
				
				result = "{success : true,text : \"登录成功!\"}";
			}else{
				/**
				 * JSONObject json = new JSONObject();
				 * json.element("failure", true);
				 * json.element("text", "密码错误!");
				 * **/
				result = "{failure : true,text : \"密码错误!\"}";
			}
		}else{
			/**
			 * JSONObject json = new JSONObject();
			 * json.element("failure", true);
			 * json.element("text", \""+userName+"用户不存在!\");
			 * **/
			result = "{failure : true,text : \""+userName+"用户不存在!\"}";
		}
		
		/**
		 * response.getWriter().print(json.toString());
		 * json.toString()输出到就是"{fail : true,text : \"密码错误!\"}"格式到字符串
		 * 输出结构怎么样去构造，根据实际需求来，直接用字符串的形式很高效。前提是你的输出结果很简单
		 * 如果所复杂的结果就必须借助与JSONObject对象来了，开发GridPanel到时候就得用到JSONObject对象准备数据了
		 * */
		response.getWriter().print(result);
		response.getWriter().close();
	}

	public void init() throws ServletException {
		// Put your code here
	}

}
