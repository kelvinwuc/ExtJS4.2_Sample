package com.aegon.comlib;

import javax.servlet.ServletException;
import javax.servlet.http.*;

public class InitDBServlet extends HttpServlet {
//	====
	protected GlobalEnviron globalEnviron = null;
	protected DbFactory dbFactory = null;
	//R00393
	protected CommonUtil commonUtil =null;
	protected boolean isAEGON400 = false;
	/**
	 * 
	 */
	public InitDBServlet() {
//		this.initDB();
		// TODO 自動產生建構子 stub
	}

//	====
	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON)
			!= null) {
			globalEnviron =
				(GlobalEnviron) getServletContext().getAttribute(
					Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory =
				(DbFactory) getServletContext().getAttribute(
					Constant.DB_FACTORY);
		}

		if (globalEnviron
			.getActiveAS400DataSource()
			.equals(Constant.AS400_DATA_SOURCE_NAME_AEGON400)) {
			isAEGON400 = true;
		}
		//R00393 edit by Leo 
		commonUtil = new CommonUtil(globalEnviron);
		

	}
}
