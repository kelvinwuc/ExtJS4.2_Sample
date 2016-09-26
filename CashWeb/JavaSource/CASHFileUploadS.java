import java.io.File;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import java.util.StringTokenizer;
import javax.servlet.Servlet;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.MultipartStream;
import org.apache.commons.fileupload.FileItem;

/**
 * @version 	1.0
 * @author
 */
public class CASHFileUploadS extends CASHServlet {

	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void performTask(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
		String path = checkLogon(req, resp);
		
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
			List fileItems = fu.parseRequest(req);
			
			// assume we know there are two files. The first file is a small
			// text file, the second is unknown and is written to a file on
			// the server
			Iterator i = fileItems.iterator();
			FileItem fi = (FileItem) i.next();
			String comment = fi.getString();
			Vector vData = readUploadFile(comment);
			if(vData != null) {
			    req.getSession().setAttribute("UPLOADFILE", vData);
			}
			
			String fileName = fi.getName();
            String uploadpath = getServletContext().getRealPath("/") + System.getProperty("file.separator") + "uploads";
            
			String fname = getFileName(fileName);
			
			
			//File ufile = new File("C:/Documents and Settings/MISJERRY/My Documents/IBM/wsappdev51/workspace/DCR/WebContent/upload/" + fname);
			
			File ufile = new File(uploadpath , fname);
			String absPath = ufile.getAbsolutePath();
			String abtPath = ufile.getPath();
			
            if( !fname.equals("") ) {
				fi.write(ufile);
			} else {
				System.out.println("錯誤，檔案名稱空白!");
			}
			RequestDispatcher rd = req.getRequestDispatcher("/FileUpload/CASHFileUploadReport.jsp");
			rd.forward(req, resp);

		} catch (Exception e) {
			e.printStackTrace();

		}

	}
	private String getFileName(String filepath) {
		String fname = "";
		StringTokenizer st = null;
		if(filepath.indexOf("\\")!=-1) {
			st = new StringTokenizer(filepath, "\\");
		}
		if(filepath.indexOf("/")!=-1) {
			st = new StringTokenizer(filepath, "/");
		}
		if(st != null) {
			while(st.hasMoreTokens()) {
				fname = st.nextToken();
			}
		}
		return fname;
	}
	private Vector readUploadFile(String content) {
		String line = "";
	    Vector upFile = null;
		//int count = 0;
		StringTokenizer st = null;
		if(content != null && content.length() > 70) {
			upFile = new Vector();
			st = new StringTokenizer(content, "\r\n");
			while(st.hasMoreTokens()) {
				Hashtable lineData = new Hashtable();
				line = st.nextToken();
				String FLD0001 = line.substring(0, 8).trim();                            //票據收受日期
				lineData.put("FLD0001", FLD0001);
				String FLD0002 = line.substring(8, 17).trim();                            //票據號碼
				lineData.put("FLD0002", FLD0002);
				String FLD0003 = line.substring(17, 28).trim();                            //存款帳號
				lineData.put("FLD0003", FLD0003);
				String FLD0004 = line.substring(28, 43).trim();                            //票據金額
				lineData.put("FLD0004", FLD0004);
				String FLD0005 = line.substring(43, 51).trim();                            //票據收妥日期
				lineData.put("FLD0005", FLD0005);
				String FLD0006 = line.substring(51, 59).trim();                            //票據到期日
				lineData.put("FLD0006", FLD0006);
				String FLD0007 = line.substring(59, 68).trim();                            //備註
				lineData.put("FLD0007", FLD0007);
				String FLD0008 = line.substring(68, 69).trim();                            //銷帳記號
				lineData.put("FLD0008", FLD0008);
				upFile.add(lineData);
			}//END : while(st.hasMoreTokens()) 
		}//END : if(content != null && content.length() > 70)
		return upFile;
	}

}
