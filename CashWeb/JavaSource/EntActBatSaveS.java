/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393          Leo Huang    	 2010/09/23           現在時間取Capsil營運時間
 *    R00231          Leo Huang    	 2010/09/26           民國百年專案問題
 *  =============================================================================
 */
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.*;


/**
 * @version 	1.0
 * @author
 */
public class EntActBatSaveS extends CASHServlet {

	//下午恢復
	 
	private DbFactory dbFactory = null;
	public void init() {
	    dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
	    
	}
	/**
	* @see javax.servlet.http.HttpServlet#void (javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	*/
	public void performTask(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
			HttpSession session = req.getSession();
			//讀出上傳檔案資料
			Vector v = (Vector) session.getAttribute("UPLOADFILE");
			if (v == null) {
				throw new ServletException("上傳檔案資料截取失，請重新執行");
			}
			Date now = null;
		
			SimpleDateFormat sdfDate = new SimpleDateFormat("yyyyMMdd",java.util.Locale.TAIWAN) ;
			SimpleDateFormat sdfTime = new SimpleDateFormat("hhmmss",java.util.Locale.TAIWAN) ;
            //R00393 edit by Leo Huang
             now = new CommonUtil(dbFactory.getGlobalEnviron()).getBizDateByRDate();
			//now = new java.util.Date(System.currentTimeMillis());
			//R00393 edit by Leo Huang 
			int currentDate = Integer.parseInt(sdfDate.format(now),10) - 19110000 ;
        
			int currentTime = Integer.parseInt(sdfTime.format(now),10) ;
	        
			int intCount =0;
			Connection conn = null;
			try {
				//準備 JDBC 連線物件
				//Class.forName("com.ibm.as400.access.AS400JDBCDriver");
				//-------------------------------------------------------------------
				//線上環境
				//String url =
				//	"jdbc:as400://10.67.0.32;poolType=JdbcOdbc;logtype=2;naming=system;errors=full;date format=iso;extended dynamic=true;package=JDBCPKG;transaction isolation=none;package library=CAPDCRF;";
				//conn = DriverManager.getConnection(url, "WEBDCR", "DCRWEB");
				//-------------------------------------------------------------------
				//本機測試環境
				//String url =
				//"jdbc:as400://10.67.0.32;poolType=JdbcOdbc;logtype=2;naming=system;errors=full;date format=iso;extended dynamic=true;package=JDBCPKG;transaction isolation=none;package library=CAPBASF;";
				//conn = DriverManager.getConnection(url, "MISBROKER", "BROKER");
				//-------------------------------------------------------------------
				
				//下午恢復
				//conn = dbFactory.getAS400ConnectionNoDS("CASHFileSaveS.performTask()");
				conn = dbFactory.getAS400Connection("CASHFileSaveS.performTask()");
			    int rowCount =0;
				//逐行讀出上傳資料
				for (int i = 0; i < v.size(); i++) {
					Hashtable line = (Hashtable) v.elementAt(i);
					String strFLD0001 = (String) line.get("FLD0001"); //行庫
					String strFLD0002 = (String) line.get("FLD0002"); //帳號
					String strFLD0003 = (String) line.get("FLD0003"); //交易日期
					// R00231 edit by Leo Huang 
				    //String strYY = strFLD0003.substring(0,2);		
					//String strMM = strFLD0003.substring(3,5);
					//String strDD = strFLD0003.substring(6,8);
					String strYY ="";
					String strMM ="";
					String strDD="";
					//日期格式 
					//郵局YYY/MM/DD
					//永豐YYYY/MM/DD
					//郵局YYY.MM.DD
					String strSign ="";
					//檢查用那種符號區分年月日
					if(strFLD0003.indexOf("/")>0){
						strSign ="/";
					}else{
						strSign =".";
					}
					strYY = strFLD0003.substring(0,strFLD0003.indexOf(strSign)) ;
					//西元年轉民國年
					if(Integer.parseInt(strYY)>1000){
						strYY = String.valueOf(Integer.parseInt(strYY)-1911);//轉民國年
					}
				    strFLD0003 = strFLD0003.substring(strFLD0003.indexOf(strSign)+1); 
					strMM = strFLD0003.substring(0,strFLD0003.indexOf(strSign));
					if(strMM.length()<2)
						strMM = "0"+strMM;
					strDD =  strFLD0003.substring(strFLD0003.indexOf(strSign)+1);
					if(strDD.length()<2)
						strDD = "0"+strDD;

                    //R00231 edit by Leo Huang 
					String strDate = strYY+strMM+strDD ;

					String strFLD0004 = (String) line.get("FLD0004"); //備註
					String strFLD0005 = (String) line.get("FLD0005"); //正負號
					String strFLD0006 = (String) line.get("FLD0006"); //金額
					String strFLD0007 = (String) line.get("FLD0007"); //幣別R60761
					
					rowCount=currentTime + i;
					
					String strSql =
							"INSERT INTO CAPCSHF (EBKCD,EATNO, EBKRMD,EAEGDT,ENTAMT,ECRSRC,ECRDAY,EUSREM,CSHFAU, CSHFAD, CSHFAT, CSHFUU, CSHFUD, CSHFUT,CROTYPE,CSHFCURR) VALUES ('"
								+ strFLD0001
								+ "', '"
								+ strFLD0002 + "',"
			                    + strDate + ","
			                    + "0,"
			                    + strFLD0006 + ", '" //金額
                                +"2',0,'"+ strFLD0004
                                +"','EntActBatS',"
                                + currentDate +"," 
                                + rowCount +",'',0,0,''"
                                + ",'" + strFLD0007 +"'" //幣別R60761                      
                        		+ ")";
		        
						System.out.println("SQL INSERT :\n" + strSql);
						PreparedStatement stmCSHF = null;
						stmCSHF = conn.prepareStatement(strSql);
						stmCSHF.execute();
						stmCSHF.close();
						intCount=intCount+1;
						//System.out.println("insert CAPCSHF done...........");
				}
								
				req.setAttribute("para_Count",String.valueOf(intCount));
				req.setAttribute("UPLOADFILE", v);
				//下午恢復
				//dbFactory.releaseAS400ConnectionNoDS(conn);
				dbFactory.releaseAS400Connection(conn);
				//conn.close();
				
				RequestDispatcher rd =
					req.getRequestDispatcher("/EntActBat/EntActBatQ.jsp");
				rd.forward(req, resp);
			} catch (Exception e) {
				e.printStackTrace();
				try {
					if (conn != null) {
						dbFactory.releaseAS400Connection(conn);
						//dbFactory.releaseAS400ConnectionNoDS(conn);
						//conn.close();
					}
				} catch (Exception ee) {

				}
				throw new ServletException(e.getMessage());
			}
	}

}
