package com.aegon.disb.disbmaintain;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.ArrayList;
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

/**
 * System   : CashWeb
 * 
 * Function : 國外SWIFT CODE
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.4 $$
 * 
 * Author   : William Wu
 * 
 * Create Date : 2013/02/18 
 * 
 * Request ID : RA0074
 * 
 * CVS History:
 * 
 * $$Log: DISBSwiftCodeManageServlet.java,v $
 * $Revision 1.4  2013/12/24 03:02:35  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $
 * $Revision 1.3  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $$
 *  
 */

public class DISBSwiftCodeManageServlet extends InitDBServlet {
	
	private static final long serialVersionUID = -6254031499228781153L;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

	private String PathUrl = "";

	private String errorMessage = "";

	private DecimalFormat df = new DecimalFormat("###,###");

	public void init() throws ServletException {
		super.init();
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,IOException 
	{
		response.setContentType(CONTENT_TYPE);
		HttpSession session = request.getSession(true);

		try {
			// Check that is a file upload request
			if (FileUpload.isMultipartContent(request)) 
			{
				PathUrl = "/DISB/DISBMaintain/DISBSwiftCodeUpload.jsp";

				this.upload(request, response, session);
			}
			else
			{
				PathUrl = "/DISB/DISBMaintain/DISBSwiftCode.jsp";

				Calendar cldToday = commonUtil.getBizDateByRCalendar();
				String strUpdDate = commonUtil.convertWesten2ROCDate1(cldToday.getTime());
				String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

				/* 接收前端欄位定義 */
				String strBKNO = "";	// 金融機構代碼
				String strBKNM = "";	// 銀行名稱
				String strSWFT = "";	// SWIFT CODE

				/* 取得前端欄位資料 */
				strBKNO = (request.getParameter("txtBKNO") == null) ? "" : CommonUtil.AllTrim(request.getParameter("txtBKNO"));
				strBKNM = (request.getParameter("txtBKNM") == null) ? "" : CommonUtil.AllTrim(request.getParameter("txtBKNM"));
				strSWFT = (request.getParameter("txtSWFT") == null) ? "" : CommonUtil.AllTrim(request.getParameter("txtSWFT"));

				CAPswiftVO vo = new CAPswiftVO();
				vo.setBankNo(strBKNO);
				vo.setSwiftCode(strSWFT);
				vo.setBankName(strBKNM);
				vo.setEntryDate(strUpdDate);
				vo.setEntryID(strLogonUser);
				vo.setUpdateDate(strUpdDate);
				vo.setUpdateID(strLogonUser);

				if (request.getParameter("txtAction").equals("C")) 
				{
					errorMessage = this.insert(vo);
				}
				else if (request.getParameter("txtAction").equals("D")) {
					errorMessage = this.delete(vo);
				}
				else if (request.getParameter("txtAction").equals("S")) {
					errorMessage = this.update(vo);
				}
			}

			request.setAttribute("txtMsg", errorMessage);

		} catch (Exception e) {
			System.err.println(e.getMessage());
			throw new ServletException(e.getMessage());
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(PathUrl);
		dispatcher.forward(request, response);
	}

	private String insert(CAPswiftVO vo) throws ServletException, IOException, Exception 
	{
		errorMessage = "";

		boolean bStatus = vo.getBankNo().equals("") || vo.getSwiftCode().equals("") || vo.getBankName().equals("");

		if(bStatus) {
			errorMessage = "不得有空值.";
		} else {
			Connection conn = dbFactory.getAS400Connection("DISBSwiftCodeManageServlet");
			DISBSwiftCodeDAO dao = new DISBSwiftCodeDAO();
			dao.setConnection(conn);

			if (dao.insert(vo) != 1) {
				errorMessage = "新增失敗.";
			} else {
				errorMessage = "新增成功.";
			}

			dbFactory.releaseAS400Connection(conn);
		}

		return errorMessage;
	}

	private String update(CAPswiftVO vo) throws ServletException, IOException, Exception 
	{
		errorMessage = "";

		boolean bStatus = vo.getBankNo().equals("") || vo.getSwiftCode().equals("") || vo.getBankName().equals("");

		if(bStatus) {
			errorMessage = "不得有空值.";
		} else {
			Connection conn = dbFactory.getAS400Connection("DISBSwiftCodeManageServlet");
			DISBSwiftCodeDAO dao = new DISBSwiftCodeDAO();
			dao.setConnection(conn);

			if (dao.update(vo) != 1) {
				errorMessage = "修改失敗.";
			} else {
				errorMessage = "修改成功.";
			}

			dbFactory.releaseAS400Connection(conn);
		}

		return errorMessage;
	}

	private String delete(CAPswiftVO vo) throws ServletException, IOException, Exception 
	{
		errorMessage = "";

		boolean bStatus = vo.getBankNo().equals("") || vo.getSwiftCode().equals("") || vo.getBankName().equals("");

		if(bStatus) {
			errorMessage = "不得有空值.";
		} else {
			Connection conn = dbFactory.getAS400Connection("DISBSwiftCodeManageServlet");
			DISBSwiftCodeDAO dao = new DISBSwiftCodeDAO();
			dao.setConnection(conn);

			if (dao.delete(vo) != 1) {
				errorMessage = "刪除失敗.";
			} else {
				errorMessage = "刪除成功.";
			}

			dbFactory.releaseAS400Connection(conn);
		}

		return errorMessage;
	}

	private void upload(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException, Exception 
	{
		errorMessage = "";

		// Create a new file upload handler
		DiskFileUpload upload = new DiskFileUpload();

		int totalCount = 0;		// 總筆數
		int successCount = 0;	// 更新筆數
		int failCount = 0;		// 失敗筆數
		int insertCount = 0;	// 新增筆數
		String failRec = "";
		
		try {
			
		// Set upload parameters
		// sizeThreshold - The max size in bytes to be stored in memory.
		// sizeMax - The maximum allowed upload size, in bytes.
		// path - The location where the files should be stored.
		upload.setSizeThreshold(1024 * 300);
		upload.setSizeMax(1024 * 4);
		upload.setRepositoryPath(globalEnviron.getAppPath() + "uploads\\");

		// Parse the request
		List items = upload.parseRequest(request);

		// Process the uploaded items
		Iterator iter = items.iterator();

		List banklist = null;
		FileItem item = null;
		while (iter.hasNext()) {
			item = (FileItem) iter.next();
			banklist = processUploadFile(item.getInputStream());
			if (!banklist.isEmpty())
				break;
		}

//		int totalCount = 0;		// 總筆數
//		int successCount = 0;	// 更新筆數
//		int failCount = 0;		// 失敗筆數
//		int insertCount = 0;	// 新增筆數
//		String failRec = "";
		
//		try {
			if(banklist.size() > 0) 
			{
				if(check(banklist)) 
				{
					Connection conn = dbFactory.getAS400Connection("DISBSwiftCodeManageServlet");
					DISBSwiftCodeDAO dao = new DISBSwiftCodeDAO();
					dao.setConnection(conn);

					Calendar cldToday = commonUtil.getBizDateByRCalendar();
					String iUpdDate = commonUtil.convertWesten2ROCDate1(cldToday.getTime());
					String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

					CAPswiftVO vo = new CAPswiftVO();
					System.out.println("@@@刪除ORCHSWFT.");
					if (dao.deleteAll() >= 0) {
						System.out.println("@@@逐筆新增ORCHSWFT.");
						for (int index = 0; index < banklist.size(); index++) {
							totalCount++;
							String[] data = (String[]) banklist.get(index);
							vo.setBankNo(data[2]);
							vo.setBankName(data[0]);
							vo.setSwiftCode(data[1]);
							vo.setEntryDate(iUpdDate);
							vo.setEntryID(strLogonUser);

							if (checkBankCodeExist(data[2])) {
								errorMessage += errorMessage + "第" + index + "行：金融機構代碼已經存在<BR/>";
								failCount++;
								continue;
							}

							if (dao.insert(vo) == 1) {
								insertCount++;
							} else {
								failCount++;
								failRec += "\"" + data[0] + "\",";
							}
						}
					}

					if(failRec.length() > 0)
						failRec = failRec.substring(0, failRec.length()-1);

					if(conn != null)
						dbFactory.releaseAS400Connection(conn);

					errorMessage = "上傳成功."; 
				}
            }
			else
			{
				errorMessage = "讀取上傳文件為空.";
			}
		} catch (SQLException e) {
			errorMessage = "操作數據庫失敗.";
		} catch (ArrayIndexOutOfBoundsException e){
			errorMessage = "上傳文件格式有誤.";
		} catch (Exception e) {
			errorMessage = e.toString();
			e.printStackTrace();
		}

		request.setAttribute("insertCount", df.format(insertCount));
		request.setAttribute("successCount", df.format(successCount));
		request.setAttribute("failCount", df.format(failCount));
		request.setAttribute("totalCount", df.format(totalCount));
		request.setAttribute("failRec", failRec);
	}

	private List processUploadFile(InputStream in) throws IOException, ArrayIndexOutOfBoundsException {
		BufferedReader reader = new BufferedReader(new InputStreamReader(in));
		List list = new ArrayList();
		String oneRow = reader.readLine();	//去掉表頭
		String[] arr = null;
		while (true) {
			oneRow = reader.readLine();
			if (oneRow == null) {
				break;
			}
			arr = split(oneRow, ",");

			list.add(arr);
		}

		return list;
	}

	private static String[] split(String input,String regex) {
		String[] strReturn = new String[3];
		StringTokenizer st = new StringTokenizer(input, regex);
		int i = 0;
		while (st.hasMoreTokens()) {
			strReturn[i] = st.nextToken();
			i++;
		}
		return strReturn;
	}

	private boolean check(List list) throws SQLException {
		boolean res = true;
		int index = 0;
		String[] data = new String[3];
		RE re = new RE("^[0-9]*$");
		for (int i = 0; i < list.size(); i++) {
			index = i + 2;
			data = (String[]) list.get(i);
			if (data[2].equals("")) {
				errorMessage = errorMessage + "第" + index + "行：金融機構代碼不能為空值<BR/>";
				res = false;
			} else {
				if (data[2].length() != 3) {
					errorMessage = errorMessage + "第" + index + "行：金融機構代碼只能為3位<BR/>";
					res = false;
				} 
				if(!re.match(data[2])) {
					errorMessage += errorMessage + "第" + index + "行：金融機構代碼只能為數字<BR/>";
					res = false;
				}
			}
			if (data[0].equals("")) {
				errorMessage += errorMessage + "第" + index + "行：銀行名稱不能為空<BR/>";
				res = false;
			}
			if (data[1].equals("")) {
				errorMessage += errorMessage + "第" + index + "行：SWIFT CODE不能為空<BR/>";
				res = false;
			}
		}

		return res;
	}

	private boolean checkBankCodeExist(String strBKNO) throws SQLException {
		boolean result = true;
		Connection con = dbFactory.getAS400Connection("DISBSwiftCodeManageServlet.checkBankCodeExist");
		DISBSwiftCodeDAO dao = new DISBSwiftCodeDAO();
		dao.setConnection(con);
		result = dao.query(strBKNO);
		if(con != null) dbFactory.releaseAS400Connection(con);
		return result;
	}

	//Clean up resources
	public void destroy() {
	}

}
