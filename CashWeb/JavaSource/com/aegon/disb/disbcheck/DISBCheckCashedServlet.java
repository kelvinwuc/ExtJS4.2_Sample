package com.aegon.disb.disbcheck;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.InitDBServlet;
        
/**
 * System   :
 * 
 * Function : 票據回銷
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.4 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckCashedServlet.java,v $
 * $Revision 1.4  2013/12/24 02:17:18  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.3  2013/02/22 03:37:42  ODCWilliam
 * $william wu
 * $PA0024
 * $bill cash day
 * $
 * $Revision 1.2  2010/11/23 06:27:42  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.1  2006/06/29 09:40:37  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.6  2005/10/17 02:57:29  misangel
 * $R50781:玉山銀行支票回銷
 * $
 * $Revision 1.1.2.5  2005/10/14 07:52:15  misangel
 * $R50781:玉山銀行支票回銷
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:23  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBCheckCashedServlet  extends InitDBServlet  {

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private String path = "";
	private DecimalFormat df = new DecimalFormat("#.00");

	//Initialize global variables
	public void init() throws ServletException {
		super.init();
	}
	//Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	//Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);

		try{
			if("upload".equals(request.getParameter("action"))){
				this.upload(request, response);
			}
		}catch(Exception e){
			System.err.println(e.getMessage());
			throw new ServletException(e.getMessage());	
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(path);	
		dispatcher.forward(request, response);
	}

	private void upload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
		System.out.println("inside upload");
		path = "/DISB/DISBCheck/DISBCheckCashFailList.jsp";
		// Check that we have a file upload request
		boolean isMultipart = FileUpload.isMultipartContent(request);
		if (!isMultipart) {
			request.setAttribute("txtMsg", "It's not a file upload.");
			System.err.println("It's not a file upload.");
			return;
		}

		// Create a new file upload handler
		DiskFileUpload upload = new DiskFileUpload();

		// Parse the request
		List /* FileItem */items = upload.parseRequest(request);

		// Set upload parameters
		// sizeThreshold - The max size in bytes to be stored in memory.
		// sizeMax - The maximum allowed upload size, in bytes.
		// path - The location where the files should be stored.
		upload.setSizeThreshold(1024 * 300);
		upload.setSizeMax(1024 * 4);
		upload.setRepositoryPath("C:\\temp\\");

		// Process the uploaded items
		String CBKNO = "";
		String CACCOUNT = "";
		Iterator iter = items.iterator();
		Vector bankFeedback = new Vector();

		while (iter.hasNext()) {
			FileItem item = (FileItem) iter.next();

			if (item.isFormField()) {
				// Process a regular form field
				if ("PBBank".equals(item.getFieldName())) {
					try {
						CBKNO = item.getString().substring(0, 7);
						CACCOUNT = item.getString().substring(8);
					} catch (Exception e) {
						e.toString();
					}
				}

			} else {
				bankFeedback = processUploadedFile(item, CBKNO);
			}
		}

		DISBCheckCashedDAO dao = new DISBCheckCashedDAO(dbFactory);
		CommonUtil commonUtil = new CommonUtil(dbFactory.getGlobalEnviron());
		Calendar calendar = commonUtil.getBizDateByRCalendar();
		int currDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(calendar.getTime()));

		double successAmt = 0;
		double successCount = 0;
		double failAmt = 0;
		double failCount = 0;
		CAPCheckVO vo;
		Vector failCheck = new Vector();// 回銷失敗票據
		for (int index = 0; index < bankFeedback.size(); index++) {
			String[] data = (String[]) bankFeedback.get(index);
			vo = new CAPCheckVO();
			vo.setCBKNO(CBKNO);
			vo.setCACCOUNT(CACCOUNT);
			vo.setCASHDT(currDate);
			vo.setCCASHDT(Integer.parseInt(data[1]));
			vo.setCRTNDT(currDate);// 回銷日
			vo.setCNO(data[0]);//
			vo.setCAMT(Integer.parseInt(data[2]));// 票據金額
			if (dao.update(vo) < 1) {
				failCount++;
				failAmt += vo.getCAMT();
				failCheck.add(dao.query(vo));
			} else {
				successCount++;
				successAmt += vo.getCAMT();
			}
		}

		request.setAttribute("successCount", df.format(successCount));
		request.setAttribute("successAmt", df.format(successAmt));
		request.setAttribute("failCount", String.valueOf(failCount));
		request.setAttribute("failAmt", df.format(failAmt));
		request.setAttribute("failCheck", failCheck);

	}
	
	private Vector processUploadedFile(FileItem item, String CBKNO) throws Exception {

		Vector bankFeedback = new Vector();
		// Process a file upload
		if (!item.isFormField()) {
			String content = item.getString();
			String line = "";
			String[] data = null;
			StringTokenizer st = null;
			Vector ret = new Vector();
			if (content != null) {
				st = new StringTokenizer(content, "\r\n");
				while (st.hasMoreTokens()) {
					line = st.nextToken();
					if (!line.trim().equals("")) {
						if (CBKNO.equals("8220635")) {
							data = new String[3];
							data[0] = line.substring(6, 15).trim();// 票據號碼
							data[1] = line.substring(0, 6).trim();// 異動日期
							data[2] = line.substring(15, 26).trim();// 票據金額
							System.out.println(" data[1] : " + data[1]);
							int datayear = Integer.parseInt(data[1].substring(0, 2));
							if (datayear < 90) {
								data[1] = "1" + data[1];
							}
							System.out.println(" data[1] : " + data[1]);

							bankFeedback.add(data);
						} else if (CBKNO.equals("8080532")) {
							if (line.substring(21, 23).equals("DB")) {
								data = new String[3];
								data[0] = line.substring(59, 69).trim();// 票據號碼
								data[1] = line.substring(13, 21).trim();// 帳務日期
								data[2] = line.substring(23, 36).trim();// 交易金額

								bankFeedback.add(data);
							}
						}
					}
				}
			}

		}
		return bankFeedback;
	}
	
	//Clean up resources
	public void destroy() {
	}
	
}