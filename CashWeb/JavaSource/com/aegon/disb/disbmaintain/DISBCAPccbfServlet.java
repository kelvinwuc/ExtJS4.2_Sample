package com.aegon.disb.disbmaintain;
        
import java.io.IOException;
import java.sql.Connection;
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
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.regexp.RE;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;

import org.apache.log4j.Logger;

/**
 * System   : CashWeb
 * 
 * Function : 國內金資檔
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.8 $$
 * 
 * Author   : Angel Chen
 * 
 * Create Date : 
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $$Log: DISBCAPccbfServlet.java,v $
 * $Revision 1.8  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.6  2012/06/18 09:35:41  MISSALLY
 * $QA0132-金資檔案及 SWIFT CODE檔案維護
 * $1.功能「新增金資碼」增加檢核不得為空值。
 * $2.功能「金資銀行檔」
 * $   2.1國外SWIFT CODE畫面隱藏。
 * $   2.2增加檢核不得上傳空檔。
 * $   2.3增加檢核金資代碼長度必須為7位數字，否則顯示失敗的記錄；若執行時有錯誤訊息則全部不更新，且顯示失敗的記錄。
 * $$
 *  
 */

public class DISBCAPccbfServlet  extends InitDBServlet  {
	
	private Logger log = Logger.getLogger(getClass());

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private String path = "";
	private DecimalFormat df = new DecimalFormat("###,###");

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
		HttpSession session = request.getSession(true);

		try {
			// Check that is a file upload request
			if (FileUpload.isMultipartContent(request)) 
			{
				path = "/DISB/DISBMaintain/DISBCAPccbf.jsp";
				log.info("test01");
				this.upload(request, response, session);
			}
			else
			{
				path = "/DISB/DISBMaintain/DISBCAPccbfCreate.jsp";

				Calendar cldToday = commonUtil.getBizDateByRCalendar();
				String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
				int iUpdDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
				int iUpdTime = Integer.parseInt(commonUtil.convertWesten2ROCDateTime1(cldToday.getTime()).substring(7));

				/* 接收前端欄位定義 */
				String strBKNO = (request.getParameter("txtBKNO") == null) ? "" : CommonUtil.AllTrim(request.getParameter("txtBKNO"));	// 金資代碼
				String strFNM = (request.getParameter("txtBKFNM") == null) ? "" : CommonUtil.AllTrim(request.getParameter("txtBKFNM"));	// 銀行全名
				String strNM = (request.getParameter("txtBKNM") == null) ? "" : CommonUtil.AllTrim(request.getParameter("txtBKNM"));	// 銀行簡稱

				CAPccbfVO vo = new CAPccbfVO();
				vo.setBKNO(strBKNO);	// 銀行代碼
				vo.setBKFNM(strFNM);	// 銀行全名
				vo.setBKNM(strNM);		// 銀行簡稱
				vo.setENTRYDT(iUpdDate);
				vo.setENTRYTM(iUpdTime);
				vo.setENTRYUSR(strLogonUser);

				String strReturnMsg = "";
				if (request.getParameter("txtAction").equals("C")) 
				{
					strReturnMsg = this.insert(vo);
				}
				else if (request.getParameter("txtAction").equals("D")) {
					strReturnMsg = this.delete(vo);
				}
				else if (request.getParameter("txtAction").equals("S")) {
					strReturnMsg = this.update(vo);
				}

				request.setAttribute("txtMsg", strReturnMsg);
			}

		} catch (Exception e) {
			System.err.println(e.getMessage());
			throw new ServletException(e.getMessage());
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	private String insert(CAPccbfVO vo) throws ServletException, IOException, Exception 
	{
		String strMsg = "";

		boolean bStatus = vo.getBKNO().equals("") || vo.getBKFNM().equals("") || vo.getBKNM().equals("");

		if(bStatus) {
			strMsg = "不得有空值";
		} else {
			Connection conn = dbFactory.getAS400Connection("DISBCAPccbfServlet");
			DISBCAPccbfDAO dao = new DISBCAPccbfDAO();
			dao.setConnection(conn);

			if (dao.insert(vo) != 1) {
				strMsg = "新增失敗";
			} else {
				strMsg = "新增成功";
			}

			dbFactory.releaseAS400Connection(conn);
		}

		return strMsg;
	}

	private String update(CAPccbfVO vo) throws ServletException, IOException, Exception 
	{
		String strMsg = "";

		boolean bStatus = vo.getBKNO().equals("") || vo.getBKFNM().equals("") || vo.getBKNM().equals("");

		if(bStatus) {
			strMsg = "不得有空值";
		} else {
			Connection conn = dbFactory.getAS400Connection("DISBCAPccbfServlet");
			DISBCAPccbfDAO dao = new DISBCAPccbfDAO();
			dao.setConnection(conn);

			if (dao.update(vo) != 1) {
				strMsg = "修改失敗";
			} else {
				strMsg = "修改成功";
			}

			dbFactory.releaseAS400Connection(conn);
		}

		return strMsg;
	}

	private String delete(CAPccbfVO vo) throws ServletException, IOException, Exception 
	{
		String strMsg = "";

		boolean bStatus = vo.getBKNO().equals("");

		if(bStatus) {
			strMsg = "金資代碼不得為空值";
		} else {
			Connection conn = dbFactory.getAS400Connection("DISBCAPccbfServlet");
			DISBCAPccbfDAO dao = new DISBCAPccbfDAO();
			dao.setConnection(conn);

			if (dao.delete(vo) != 1) {
				strMsg = "刪除失敗";
			} else {
				strMsg = "刪除成功";
			}

			dbFactory.releaseAS400Connection(conn);
		}

		return strMsg;
	}

	private void upload(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException, Exception 
	{
		// Create a new file upload handler
		DiskFileUpload upload = new DiskFileUpload();

		// Set upload parameters
		// sizeThreshold - The max size in bytes to be stored in memory.
		// sizeMax - The maximum allowed upload size, in bytes.
		// path - The location where the files should be stored.
		System.out.println(upload.getSizeThreshold());
		upload.setSizeThreshold(1024 * 300);
//		upload.setSizeMax(1024 * 4);
		upload.setRepositoryPath(globalEnviron.getAppPath() + "uploads\\");

		// Parse the request
		List items = upload.parseRequest(request);

		// Process the uploaded items
		Iterator iter = items.iterator();
		Vector banklist = new Vector();

		FileItem item = null;
		//log.info(item.getSize());
		while (iter.hasNext()) {
			item = (FileItem) iter.next();
			banklist = processUploadedFile(item);
			if (!banklist.isEmpty())
				break;
		}

		int totalCount = 0;		// 總筆數
		int successCount = 0;	// 更新筆數
		int failCount = 0;		// 失敗筆數
		int insertCount = 0;	// 新增筆數
		String failRec = "";

		if(banklist.size() > 0)
		{
			Connection conn = dbFactory.getAS400Connection("DISBCAPccbfServlet");
			DISBCAPccbfDAO dao = new DISBCAPccbfDAO();
			dao.setConnection(conn);

			Calendar cldToday = commonUtil.getBizDateByRCalendar();
			int iUpdDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
			int iUpdTime = Integer.parseInt(commonUtil
					.convertWesten2ROCDateTime1(cldToday.getTime())
					.substring(7));
			String strLogonUser = (String) session
					.getAttribute(Constant.LOGON_USER_ID);

			RE re = new RE("^[0-9]*$");

			CAPccbfVO vo = new CAPccbfVO();
			System.out.println("@@@刪除CAPCCBF.");
			if (dao.deleteAll() >= 0) {
				System.out.println("@@@逐筆新增CAPCCBF.");
				for (int index = 0; index < banklist.size(); index++) {
					totalCount++;
					String[] data = (String[]) banklist.get(index);
					if (data[0].length() > 3) {
						//QA0132 金資碼必須為7碼的數字
						if(data[0].length() == 7 && re.match(data[0])) {
							log.info("data[0]:" + data[0] + ",data[1]:" + data[1] + ",data[2]:" + data[2]);
							vo.setBKNO(data[0]); // 銀行代碼
							vo.setBKFNM(data[1]);// 銀行全名
							vo.setBKNM(data[2]); // 銀行簡稱
							vo.setENTRYDT(iUpdDate);
							vo.setENTRYTM(iUpdTime);
							vo.setENTRYUSR(strLogonUser);

							if (dao.insert(vo) == 1) {
								insertCount++;
							} else {
								failCount++;
								failRec += "\"" + data[0] + "\",";
								System.out.println("新增失敗的銀行代碼=" + data[0]);
							}
						} else {
							failCount++;
							failRec += "\"" + data[0] + "\",";
							System.out.println("新增失敗的銀行代碼=" + data[0]);
						}
					}
				}
			}

			if(failRec.length() > 0)
				failRec = failRec.substring(0, failRec.length()-1);

			if(conn != null)
				dbFactory.releaseAS400Connection(conn);
		}

		request.setAttribute("txtMsg", "Msg");
		request.setAttribute("insertCount", df.format(insertCount));
		request.setAttribute("successCount", df.format(successCount));
		request.setAttribute("failCount", df.format(failCount));
		request.setAttribute("totalCount", df.format(totalCount));
		request.setAttribute("failRec", failRec);
	}

	private Vector processUploadedFile(FileItem item) throws Exception {
		Vector banklist = new Vector();
		// Process a file upload
		if (!item.isFormField()) {
			String content = item.getString();
			String line = "";
			StringTokenizer st = null;
			if (content != null) {
				//log.info("content是" + content);
				st = new StringTokenizer(content, "\r\n");
				while (st.hasMoreTokens()) {
					line = st.nextToken();
					line = line.replace((char) 39, ' '); // 轉 " ' " 為空白
					String[] data = new String[3];
					//data = split(line, ",");
					data = splitV2(line); //銀行下載檔案由中信銀更改為彰銀
					String[] data1 = new String[3];
					for (int index = 0; index < data.length; index++) {
						data1[index] = "";
						// System.out.println(data[index]);
						data1[index] = data[index].substring(1, data[index].length() - 1);
					}
					//log.info("data[0]:" + data[0] + ",data[1]:" + data[1] + ",data[2]:" + data[2]);
					//log.info("data1[0]:" + data1[0] + ",data1[1]:" + data1[1] + ",data1[2]:" + data1[2]);
					//banklist.add(data1);
					banklist.add(data);
				}
			}

		}
		return banklist;
	}

	/**
	 * str = "123","456","789A"; reg = , 用來切割字串的辨識字元
	 */
	public String[] split(String str, String reg) {
		int e = 0;
		Vector v = new Vector();
		while (true) {
			e = str.indexOf(reg);
			if (e == -1) {
				v.add(str);
				break;
			} else {
				v.add(str.substring(0, e));
				str = str.substring(e + 1);
			}
		}
		return (String[]) v.toArray(new String[v.size()]);
	}
	
	/***
	 * 
	 * @date:2016/4/6
	 * @description:銀行下載檔案由中信銀更改為彰銀
	 */
	public String[] splitV2(String str) {
		Vector v = new Vector();
		
		v.add(str.substring(1, 9).replace("　", "").trim()); //銀行代碼
		//v.add(str.substring(9, 29).replace("　", "").trim()); //銀行全名
		v.add(((str.substring(9, 29).replace("　", "").trim()).replace("（", "(")).replace("）", ")")); //銀行全名
		v.add(str.substring(29, 34).replace("　", "").trim()); //銀行簡稱			
		
		return (String[]) v.toArray(new String[v.size()]);
	}

	//Clean up resources
	public void destroy() {
	}

}