package com.aegon.filter;

import java.io.IOException;
import java.util.Date;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

public class SetHtmlHeader implements Filter {
	
	String defaultCharSet = "big5";
	String charSet = null;
	private ServletContext context;
	private Logger logger = Logger.getLogger(getClass());
	private String LogFlag = "";
	
	/**
	* @see javax.servlet.Filter#void ()
	*/
	public void destroy() {

	}

	/**
	* @see javax.servlet.Filter#void (javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	*/
	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
		throws ServletException, IOException {
			
		if(resp instanceof HttpServletResponse){
			HttpServletResponse response = (HttpServletResponse)resp;
			response.setHeader("charset",charSet);
		}
		
		if (LogFlag.equalsIgnoreCase("y")){
			HttpServletRequest hreq = (HttpServletRequest)req;
			HttpSession session = hreq.getSession();
			String sUID = "";
		
			sUID = String.valueOf(new Date().getTime())+session.getId();
			long oBeginTime= new Date().getTime();
			//logger layout==> type,UID,URI,ExcutedTime
			logger.info(",S,"+sUID+","+((HttpServletRequest)req).getRequestURI()+","+(oBeginTime-oBeginTime));
			chain.doFilter(req, resp);
			long oEndTime= new Date().getTime();
			logger.info(",E,"+sUID+","+((HttpServletRequest)req).getRequestURI()+","+(oEndTime-oBeginTime));
		}else{
			chain.doFilter(req, resp);
		}
	}

	/**
	* Method init.
	* @param config
	* @throws javax.servlet.ServletException
	*/
	public void init(FilterConfig config) throws ServletException {
		charSet = System.getProperty("file.encoding");
		context = config.getServletContext();
		try{
			String path = context.getRealPath("/");
			//String log4jpropfile = path + "\\WEB-INF\\classes\\log4j.properties";
			String log4jpropfile = path + "\\WEB-INF\\log4j.properties";

			if (config.getInitParameter("logflag")!=null) {
				LogFlag = config.getInitParameter("logflag");
			}

			// Initialize log4j
			PropertyConfigurator.configure(log4jpropfile);        
			if(charSet==null){
				charSet = defaultCharSet;
			}
		}catch(Exception ex){
			System.err.println("[Load Properties Failure]");
			ex.printStackTrace();
			
		}
	}

}
