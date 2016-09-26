import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.io.IOException;
import java.util.*;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.RequestDispatcher;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.MultipartStream;
import org.apache.commons.fileupload.FileItem;

import com.aegon.comlib.*;
/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.1 $$
 * 
 * Author   : Vanessa Liao
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R80300
 * 
 * CVS History:
 * 
 * $$Log: DISBRemitCreditBackS.java,v $
 * $Revision 1.1  2008/06/12 09:40:55  misvanessa
 * $R80300_收單行轉台新,新增上傳檔案及報表
 * $
 * $$
 *  
 */
public class DISBRemitCreditBackS extends CASHServlet {

	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	private DbFactory dbFactory = null;
	public void init() {
		dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
	    
	}
	
	public void performTask(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
		String path = checkLogon(req, resp);
		Connection conn = null;
		
		if(!path.equals("")) {
			resp.setHeader("Window-target","_top");
			resp.sendRedirect(path);
			return;
		}
		//req.getRequestDispatcher("Logon/CheckLogoninc.inc").include(req, resp);
		DiskFileUpload fu = new DiskFileUpload();
		// maximum size before a FileUploadException will be thrown
		fu.setSizeMax(8000000);
		// maximum size that will be stored in memory
		fu.setSizeThreshold(4096);
		MultipartStream multi = null;
		// the location for saving data that is larger than getSizeThreshold()

		//fu.setRepositoryPath("C:\\tmp");
		String tempdir = System.getProperty("java.io.tmpdir");
		fu.setRepositoryPath(tempdir);
        try {
			conn = dbFactory.getAS400Connection("CASHFileSaveS.performTask()");
			List fileItems = fu.parseRequest(req);
			
			// assume we know there are two files. The first file is a small
			// text file, the second is unknown and is written to a file on
			// the server
			Iterator i = fileItems.iterator();
			FileItem fi = (FileItem) i.next();
			String comment = fi.getString();
			
			Vector vData = readUploadFile(comment);
			
			
			int uploadCNT = 0;
			if (vData == null) {
				throw new ServletException("上傳檔案資料截取失敗，請重新執行");
			}
			else{
				delCAPPAY812(conn);
				uploadCNT = insCAPPAY812(conn, vData);
			}
			
			dbFactory.releaseAS400Connection(conn);
			
			req.setAttribute("para_Count",String.valueOf(uploadCNT));
			req.setAttribute("txtAction","showPRT");
			RequestDispatcher rd = req.getRequestDispatcher("/DISB/DISBRemit/DISBRemitCreditBack.jsp");
			rd.forward(req, resp);

		} catch (Exception e) {
		e.printStackTrace();
		try {
			if (conn != null) {
				dbFactory.releaseAS400Connection(conn);
				}
			} catch (Exception ee) {
			}
			throw new ServletException(e.getMessage());
		}

	}
	
	private Vector readUploadFile(String content) {
		String line = "";
	    Vector upFile = null;
		//int count = 0;
		StringTokenizer st = null;
		if(content != null && content.length() > 215) {
			upFile = new Vector();
			st = new StringTokenizer(content, "\r\n");
			while(st.hasMoreTokens()) {
				Hashtable lineData = new Hashtable();
				line = st.nextToken();
				String FLD0001 = line.substring(0, 1).trim();
				
				if (FLD0001.equals("D")) {                         
					lineData.put("FLD0001", FLD0001);
					String FLD0002 = line.substring(1, 5).trim();                          
					lineData.put("FLD0002", FLD0002);
					String FLD0003 = line.substring(5, 20).trim();                            
					lineData.put("FLD0003", FLD0003);
					String FLD0004 = line.substring(20, 39).trim();                           
					lineData.put("FLD0004", FLD0004);
					String FLD0005 = line.substring(39, 43).trim();                           
					lineData.put("FLD0005", FLD0005);
					String FLD0006 = line.substring(43, 55).trim();                            
					lineData.put("FLD0006", FLD0006);
					String FLD0007 = line.substring(55, 69).trim();                           
					lineData.put("FLD0007", FLD0007);
					String FLD0008 = line.substring(69, 77).trim();                           
					lineData.put("FLD0008", FLD0008);
					String FLD0009 = line.substring(77, 85).trim();                           
					lineData.put("FLD0009", FLD0009);
					String FLD0010 = line.substring(85, 105).trim();                           
					lineData.put("FLD0010", FLD0010);
					String FLD0011 = line.substring(105, 113).trim();                           
					lineData.put("FLD0011", FLD0011);
					String FLD0012 = line.substring(113, 115).trim();                           
					lineData.put("FLD0012", FLD0012);
					String FLD0013 = line.substring(115, 121).trim();                           
					lineData.put("FLD0013", FLD0013);
					String FLD0014 = line.substring(121, 141).trim();                           
					lineData.put("FLD0014", FLD0014);
					String FLD0015 = line.substring(141, 215).trim();                           
					lineData.put("FLD0015", FLD0015);

					upFile.add(lineData);
				}
			}//END : while(st.hasMoreTokens()) 
		}//END : if(content != null && content.length() > 215)
		return upFile;
	}
	/**
	 * 清除 CAPPAY812 中的資料
	 * @param Connection  conn 資料庫連線物件
	 */
	 private void delCAPPAY812(Connection conn) throws Exception {
		try {
			PreparedStatement stmCAPPAY812 = null;
			String strCAPPAY812 ="DELETE FROM CAPPAY812";
			stmCAPPAY812 = conn.prepareStatement(strCAPPAY812);
			System.out.println("SQL String : " + strCAPPAY812);
			stmCAPPAY812.execute();
			stmCAPPAY812.close();
		} catch (Exception e) {
			throw e;
		}
	 }
	/**
		 * 新增資料至 CAPPAY812 
		 * @param Connection  conn 資料庫連線物件
		 * @param Vector vData 上傳資料
	*/ 	
	private int insCAPPAY812(Connection conn, Vector v) throws Exception {
	   try {
			PreparedStatement stmCAPPAY812 = null;
			int intCount =0;
			for (int i = 0; i < v.size(); i++) {
				Hashtable line = (Hashtable) v.elementAt(i);
				String strFLD0001 = (String) line.get("FLD0001"); //種類
				String strFLD0002 = (String) line.get("FLD0002"); //交易種類
				String strFLD0003 = (String) line.get("FLD0003"); //特店代號
				String strFLD0004 = (String) line.get("FLD0004"); //卡號
				String strFLD0005 = (String) line.get("FLD0005"); //有效年月
				String strFLD0006 = (String) line.get("FLD0006"); //交易金額
				String strFLD0007 = (String) line.get("FLD0007"); //手續費
				String strFLD0008 = (String) line.get("FLD0008"); //交易日
				String strFLD0009 = (String) line.get("FLD0009"); //請款日
				String strFLD0010 = (String) line.get("FLD0010"); //訂單編號
				String strFLD0011 = (String) line.get("FLD0011"); //終端機
				String strFLD0012 = (String) line.get("FLD0012"); //回銷狀況
				String strFLD0013 = (String) line.get("FLD0013"); //授權碼
				String strFLD0014 = (String) line.get("FLD0014"); //支付序號
				String strFLD0015 = (String) line.get("FLD0015"); //備註
				
				String strSql =
					"INSERT INTO CAPPAY812 (DETL,TYPE,AEGON,CRDNO,EXPYYMM,PAMT,COMM,PDATE,BDATE,ORDERNO,TERMID,STUS,AUTCD,PNO,PNOTE) VALUES ('"
						+ strFLD0001 +  "', '" + strFLD0002 +  "', '" + strFLD0003 +  "', '" + strFLD0004 +  "', '" + strFLD0005 +  "', " + strFLD0006 +  ", " 
						+ strFLD0007 +  ", '" + strFLD0008 +  "', '" + strFLD0009 +  "', '" + strFLD0010 +  "', '" + strFLD0011 +  "', '" + strFLD0012 +  "', '"
						+ strFLD0013 +  "', '" + strFLD0014 +  "', '" + strFLD0015 +  "')";         		        
				
				System.out.println("SQL INSERT :\n" + strSql);
				stmCAPPAY812 = conn.prepareStatement(strSql);
				stmCAPPAY812.execute();
				stmCAPPAY812.close();
				intCount=intCount+1;
			}
			return intCount;
	   } catch (Exception e) {
		   throw e;
	   }
	}
}
