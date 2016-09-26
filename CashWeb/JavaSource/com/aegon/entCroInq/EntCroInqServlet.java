package com.aegon.entCroInq;

import java.io.IOException;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.DbFactory;
import com.aegon.comlib.InitDBServlet;

public class EntCroInqServlet extends InitDBServlet {

	private static final long serialVersionUID = -2747677235678401435L;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

	// Initialize global variables
	public void init() throws ServletException {
		super.init();
	}

	// Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	// Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = "/EntCroInq/EntCroInq.jsp";
		response.setContentType(CONTENT_TYPE);
		if ("query".equals(request.getParameter("act"))) {
			query(request, response);
			path = "/EntCroInq/EntCroInq_1.jsp";
		}
		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	private void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		EntCroInqVO vo = new EntCroInqVO(request);
		EntCroInqDAO dao = new EntCroInqDAO((DbFactory) getServletContext().getAttribute("dbFactory"));
		Vector v = dao.query(vo);
		request.setAttribute("VO", v);
		request.setAttribute("SUMAMT", v.size() > 0 ? ((Object) (dao.querySummary(vo))) : "");
		request.setAttribute("PAGEINDEX", request.getParameter("PAGEINDEX"));
	}

}