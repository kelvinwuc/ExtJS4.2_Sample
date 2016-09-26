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

import com.aegon.disb.util.DISBBean;//Q80223
import java.io.*;
import java.util.*;
import java.sql.*;
import com.aegon.comlib.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * @version 	1.0
 * @author
 */
public class EntActBatS extends CASHServlet {
	private GlobalEnviron globalEnviron = null;//Q80223
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private DISBBean disbBean = null;
	private boolean isAEGON400 = false;
	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void performTask(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
		String path = checkLogon(req, resp);

		disbBean = new DISBBean(globalEnviron, dbFactory);//Q80223
		
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
			//FileItem fi = (FileItem) i.next();

			//Process the uploaded items
			String CBKNO 	= "";
			String CACCOUNT = "";
			String CCURR = ""; //R60761新增幣別

			 while (i.hasNext()) {
				 FileItem fi = (FileItem) i.next();
	
				 if (fi.isFormField()) {
					//Process a regular form field
					
					String name = fi.getFieldName();
					String value = fi.getString();
					if("PBBank".equals(fi.getFieldName())){
						try{
						//	CBKNO = fi.getString().substring(0,3);
						//	CACCOUNT = fi.getString().substring(4);		
						//	CCURR = value.substring(4,2);
						//	CACCOUNT = value.substring(7);					
						StringTokenizer st = new StringTokenizer(fi.getString(),"-");
													while(st.hasMoreTokens()) {
														CBKNO = st.nextToken();
														CCURR = st.nextToken();
														CACCOUNT = st.nextToken();
													}
						}catch(Exception e){
							e.toString();
						}
					  }	
				  }else {
					String comment = fi.getString();					
                    Vector vData = readUploadFile(comment,CBKNO,CACCOUNT,CCURR);
                    if(vData != null) {
	                   req.getSession().setAttribute("UPLOADFILE", vData);
                       }
			
                     String fileName = fi.getName();
                     //String uploadpath = getServletContext().getRealPath("/") + System.getProperty("file.separator") + "uploads";
					String uploadpath="C:\\temp\\";
                     String fname = getFileName(fileName);
                     File ufile = new File(uploadpath , fname);
                     String absPath = ufile.getAbsolutePath();
                     String abtPath = ufile.getPath();
			
                     if( !fname.equals("") ) {
	                    fi.write(ufile);
                     } else {
	                      System.out.println("錯誤，檔案名稱空白!");
                     }
                      RequestDispatcher rd = req.getRequestDispatcher("/EntActBat/EntActBatDetailQ.jsp");
                      rd.forward(req, resp);
				  }
				}
			   }catch (Exception e) {
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
	private Vector readUploadFile(String content, String CBKNO,String CACCOUNT,String CCURR) {
		String line = "";
	    Vector upFile = null;
		//int count = 0;
		StringTokenizer st = null;
		System.out.println("LEN="+content.length());	 	
	// R70757
	//	if(content != null && content.length() > 70) {
		if(content != null && content.length() > 50) {
			upFile = new Vector();
			st = new StringTokenizer(content, "\r\n");
			while(st.hasMoreTokens()) {
				String[] data = new String[6];
				line = st.nextToken();
				data = split(line , ",") ;
			  if (! data[0].trim().equals("")){ 
				if (CBKNO.equals("701")) {//郵局
				  if ( !data[5].trim().equals("") ){	 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[3]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[3])); //備註
				   lineData.put("FLD0005", data[4]); //正負號
				   lineData.put("FLD0006", data[5]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  } 
				}
				if (CBKNO.equals("816")) {//安泰
				  if ( !data[4].trim().equals("") ){	
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[2]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[2])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[4]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  } 
				}
				if (CBKNO.equals("051")) {//IBT
				  if ( !data[4].trim().equals("") ){	 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[2]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[2])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[4]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  } 
				}
				if (CBKNO.equals("810")) {//寶華
				 if ( !data[3].trim().equals("") ){	  
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[5]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[5])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[3]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				 } 
				}
				if (CBKNO.equals("118")) {//板信
				  if (! data[3].trim().equals("")){
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);				   
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[5]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[5])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[3]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  }
				}
				if (CBKNO.equals("805")) {//遠銀
				  if ( !data[3].trim().equals("") ){				 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[5]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[5])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[3]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  }
				}
				if (CBKNO.equals("808")) {//玉山
				  if ( !data[3].trim().equals("") ){				 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[5]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[5])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[3]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  }
				}
				if (CBKNO.equals("815")) {//日盛
				  if ( !data[3].trim().equals("") ){				 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[5]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[5])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[3]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  }
				}
				if (CBKNO.equals("005")) {//土銀
				  if ( !data[3].trim().equals("") ){				 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[5]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[5])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[3]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  }
				}
				//R61058 新增永豐 , 萬泰 , 陽信
				if (CBKNO.equals("807")) {//永豐
				  if ( !data[3].trim().equals("") ){				 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[5]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[5])); //備註				   
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[3]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  }
				}
				if (CBKNO.equals("809")) {//萬泰
				  if ( !data[1].trim().equals("") ){				 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[1]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[1])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[4]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  }
				}
				if (CBKNO.equals("108")) {//陽信
				  if ( !data[2].trim().equals("") ){				 
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",CBKNO );
				   lineData.put("FLD0002", CACCOUNT);
				   lineData.put("FLD0003", data[0]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[5]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[5])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[2]); //金額
				   lineData.put("FLD0007", CCURR); //幣別
				   upFile.add(lineData);
				  }
				}
            // R70757 新增通用格式
				if (CBKNO.equals("ALL")) {//通用格式	
				   Hashtable lineData = new Hashtable();				
				   lineData.put("FLD0001",data[0] );
				   lineData.put("FLD0002",data[1]);
				   lineData.put("FLD0003", data[4]); //交易日期
				   //Q80223 lineData.put("FLD0004", data[3]); //備註
				   lineData.put("FLD0004", disbBean.replacePunct(data[3])); //備註
				   lineData.put("FLD0005", ""); //正負號
				   lineData.put("FLD0006", data[5]); //金額
				   lineData.put("FLD0007", data[2]); //幣別
				   upFile.add(lineData);
				}
																																																																			
			  }	
			}//END : while(st.hasMoreTokens()) 
		}//END : if(content != null && content.length() > 70)
		return upFile;
	}
	
	/**
	 * str = 123,456,789A; 
	 * reg = , 用來切割字串的辨識字元
	 */
	public String[] split(String str, String reg){
		int e = 0;		
		java.util.Vector v = new java.util.Vector();		
		while(1==1){
			e = str.indexOf(reg);
			if(e==-1){
				v.add(str);
				break;
			}else{				
				v.add(str.substring(0,e));
				str = str.substring(e+1);
			}									
		}
		return (String[])v.toArray(new String[v.size()]);
	}
	/**Q80223
	* @see javax.servlet.GenericServlet#void ()
	*/
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

	}

	

}
