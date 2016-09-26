package com.aegon.balchkrpt;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.InitDBServlet;

public class BalanceRptServlet extends InitDBServlet {

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	

	public void init() throws ServletException {
		super.init();
	}

	// Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	// Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = "/BalChkRpt/BalDayRptC.jsp";
		response.setContentType(CONTENT_TYPE);
		
		if ("query".equals(request.getParameter("act"))) {
			try {
				query(request, response);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			path = "/BalChkRpt/BalDayRptC_1.jsp";
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	private void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {

		BalanceRptVO vo = new BalanceRptVO(request);
		BalanceRptDAO dao = new BalanceRptDAO(dbFactory);

		String EBKRMD_S1 = (request.getParameter("EBKRMD_S1") != null) ? request.getParameter("EBKRMD_S1") : "";
		String EBKRMD_S2 = (request.getParameter("EBKRMD_S2") != null) ? request.getParameter("EBKRMD_S2") : "";
		String EBKRMD_S3 = (request.getParameter("EBKRMD_S3") != null) ? request.getParameter("EBKRMD_S3") : "";
		String EBKRMD_E1 = (request.getParameter("EBKRMD_E1") != null) ? request.getParameter("EBKRMD_E1") : "";
		String EBKRMD_E2 = (request.getParameter("EBKRMD_E2") != null) ? request.getParameter("EBKRMD_E2") : "";
		String EBKRMD_E3 = (request.getParameter("EBKRMD_E3") != null) ? request.getParameter("EBKRMD_E3") : "";

		String EAEGDT_S1 = (request.getParameter("EAEGDT_S1") != null) ? request.getParameter("EAEGDT_S1") : "";
		String EAEGDT_S2 = (request.getParameter("EAEGDT_S2") != null) ? request.getParameter("EAEGDT_S2") : "";
		String EAEGDT_S3 = (request.getParameter("EAEGDT_S3") != null) ? request.getParameter("EAEGDT_S3") : "";
		String EAEGDT_E1 = (request.getParameter("EAEGDT_E1") != null) ? request.getParameter("EAEGDT_E1") : "";
		String EAEGDT_E2 = (request.getParameter("EAEGDT_E2") != null) ? request.getParameter("EAEGDT_E2") : "";
		String EAEGDT_E3 = (request.getParameter("EAEGDT_E3") != null) ? request.getParameter("EAEGDT_E3") : "";

		double ENTAMT1 = 0;
		double ENTAMT2 = 0;
		double ENTAMT3 = 0;

		double ENTAMT1_AMT = 0;
		double ENTAMT2_AMT = 0;
		double ENTAMT3_AMT = 0;

		DecimalFormat df = new DecimalFormat("0.00");

		Vector v = dao.query_bank(vo);
		for (int i = 0; i < v.size(); i++) {
			BalanceRptVO Balvo = (BalanceRptVO) v.get(i);
			ENTAMT1 = dao.querySummary(Balvo.getBKCODE(), Balvo.getBKATNO(), EBKRMD_S1, EBKRMD_E1, "", "", "1", Balvo.getBKCURR());
			ENTAMT2 = dao.querySummary(Balvo.getBKCODE(), Balvo.getBKATNO(), EBKRMD_S2, EBKRMD_E2, EAEGDT_S2, EAEGDT_E2, "2", Balvo.getBKCURR());
			ENTAMT3 = dao.querySummary(Balvo.getBKCODE(), Balvo.getBKATNO(), EBKRMD_S3, EBKRMD_E3, EAEGDT_S3, EAEGDT_E3, "2", Balvo.getBKCURR());

			ENTAMT1_AMT += ENTAMT1;
			ENTAMT2_AMT += ENTAMT2;
			ENTAMT3_AMT += ENTAMT3;

			Balvo.setAMT1(df.format(ENTAMT1));
			Balvo.setAMT2(df.format(ENTAMT2));
			Balvo.setAMT3(df.format(ENTAMT3));
		}

		request.setAttribute("ENTAMT1", df.format(ENTAMT1_AMT));
		request.setAttribute("ENTAMT2", df.format(ENTAMT2_AMT));
		request.setAttribute("ENTAMT3", df.format(ENTAMT3_AMT));
		request.setAttribute("EBKRMD_S1", EBKRMD_S1);
		request.setAttribute("EBKRMD_S2", EBKRMD_S2);
		request.setAttribute("EBKRMD_S3", EBKRMD_S3);
		request.setAttribute("EBKRMD_E1", EBKRMD_E1);
		request.setAttribute("EBKRMD_E2", EBKRMD_E2);
		request.setAttribute("EBKRMD_E3", EBKRMD_E3);
		request.setAttribute("EAEGDT_S1", EAEGDT_S1);
		request.setAttribute("EAEGDT_S2", EAEGDT_S2);
		request.setAttribute("EAEGDT_S3", EAEGDT_S3);
		request.setAttribute("EAEGDT_E1", EAEGDT_E1);
		request.setAttribute("EAEGDT_E2", EAEGDT_E2);
		request.setAttribute("EAEGDT_E3", EAEGDT_E3);

		request.setAttribute("VO", v);
	}

	// Clean up resources
	public void destroy() {
	}
}
