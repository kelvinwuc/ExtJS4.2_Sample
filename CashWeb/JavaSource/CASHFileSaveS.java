import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Hashtable;
import java.util.Vector;
import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;

/**
 * @version 	1.0
 * @author
 */
public class CASHFileSaveS extends CASHServlet {

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
				
				//使用者選擇之作業模式 1 : 新增資料, 2 : 覆蓋資料
				String typeValue = req.getParameter("WRITETYPE");
				if(typeValue.equals("2")) {
					 delCHKDEP(conn);
				}
			
				//逐行讀出上傳資料
				for (int i = 0; i < v.size(); i++) {
					Hashtable line = (Hashtable) v.elementAt(i);
					String strFLD0001 = (String) line.get("FLD0001"); //票據收受日期
					String strFLD0002 = (String) line.get("FLD0002"); //票據號碼
					String strFLD0003 = (String) line.get("FLD0003"); //存款帳號
					String strFLD0004 = (String) line.get("FLD0004"); //票據金額
					String strFLD0005 = (String) line.get("FLD0005"); //票據收妥到期日
					String strFLD0006 = (String) line.get("FLD0006"); //票據到期日
					String strFLD0007 = (String) line.get("FLD0007"); //備註
					String strFLD0008 = (String) line.get("FLD0008"); //銷帳記號
					//銷帳記號轉換為 CHKDEP FLD0001 的代號
					if (strFLD0008.equals("1")) {
						strFLD0008 = "3";
					} else if (strFLD0008.equals("2")) {
						strFLD0008 = "5";
					} else if (strFLD0008.equals("3")) {
						strFLD0008 = "4";
					}
					//票據金額，清除字串開頭的 '0', 並取 2 位小數點
					int s = 0;
					int e = s + 1;
					String value = "000";
					//清除字串開頭的 '0'
					while (value.length() > 2 && strFLD0004.substring(s, e).equals("0")) {
						value = strFLD0004.substring(e);
						s++;
						e++;
					}
					if (value.equals("00")) {
						value = "0.00";
					} else {
						//取二位小數點
						value =
							value.substring(0, value.length() - 2)
								+ "."
								+ value.substring(value.length() - 2);
					}

					//取得 BANK-CODE
					String[] tmp = getFLD0006(conn, strFLD0002, strFLD0004, strFLD0006);
					String FLD0006 = "";
					String FLD0007 = "";
					if(tmp != null) {
						FLD0006 = tmp[0];
						FLD0007 = tmp[1];
					}
					if (!FLD0006.equals("")) {
						FLD0006 = FLD0006.substring(2);
					}

					//準備 FLD0004 的值
					String FLD0004 = strFLD0007.substring(strFLD0007.length() - 1);
					if (!FLD0004.equals("1")
						&& !FLD0004.equals("2")
						&& !FLD0004.equals("3")) {
						FLD0004 = "";
					}

						String strCHKDEP =
							"INSERT INTO CHKDEP (FLD0001, FLD0002, FLD0003, FLD0004, FLD0005, FLD0006, FLD0007, FLD0008, FLD0009, FLD0010, FLD0011, FLD0012, FLD0013, FLD0014) VALUES ('"
								+ strFLD0008
								+ "', '"
								+ "09310120866', " //一銀帳號, 寫死
			+value + ", '" //金額
		+FLD0004
			+ "', '"
			+ new Integer(strFLD0006)
			+ "', '"
			+ FLD0006
			+ "', '"
			+ FLD0007
			+ "', '"
			+ strFLD0002
			+ "', '"
			+ new Integer(strFLD0005)
			+ "', '"
			+ "', '"
			+ "', '"
			+ "0931', '"
			+ "', '"
			+ "')";
		        
					//只寫入 strFLD0008 = 3 的筆數，其餘忽略(3 代表兌現成功的資料)
					if(strFLD0008.equals("3")) {
						System.out.println("SQL INSERT :\n" + strCHKDEP);
						PreparedStatement stmCHKDEP = null;
						stmCHKDEP = conn.prepareStatement(strCHKDEP);
						stmCHKDEP.execute();
						stmCHKDEP.close();
						System.out.println("insert CHKDEP done...........");
					}
				}
				req.setAttribute("UPLOADFILE", v);
				//下午恢復
				//dbFactory.releaseAS400ConnectionNoDS(conn);
				dbFactory.releaseAS400Connection(conn);
				//conn.close();
				
				RequestDispatcher rd =
					req.getRequestDispatcher("/FileUpload/CASHFileUploadResult.jsp");
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
	/**
	 * 以支票號碼及存款帳號尋找 ORNBTB 檔案，取得 BANK-CODE
	 * @param String  strFLD0002 支票號碼
	 * @param String  strFLD0004 票據金額
	 * @param String  strFLD0006 票據到期日
	 * @return String[]，值為 BANK-CODE, ACCOUNTCODE
	 */
	private String[] getFLD0006(
	    Connection conn,
		String strFLD0002,
	    String strFLD0004, 
	    String strFLD0006)
		throws Exception {
		String[] temp = null;
		String FLD0006 = "";
		String FLD0007 = "";
		try {
			PreparedStatement stmORNBTB = null;
			ResultSet resultORNBTB = null;
			String strORNBTB =
				"SELECT BANKCODE, ACCNTCODE FROM ORNBTB WHERE CHEQUECODE='"
					+ strFLD0002
					+ "' AND CHEQUEAMT="
			        + (float)Integer.parseInt(strFLD0004) / 100.0f
			        + " AND CHEQUEDATE="
			        + (Integer.parseInt(strFLD0006) + 1110000);
			System.out.println("Query : " + strORNBTB);
			
			stmORNBTB = conn.prepareStatement(strORNBTB);
			resultORNBTB = stmORNBTB.executeQuery();
			int records = 0;
			while (resultORNBTB.next()) {
				FLD0006 = resultORNBTB.getString("BANKCODE");
				FLD0007 = resultORNBTB.getString("ACCNTCODE");
				records++;
			}
			//System.out.println("records : "+records);
			temp = new String[2];
			temp[0] = FLD0006;
			temp[1] = FLD0007;
			stmORNBTB.close();
			resultORNBTB.close();
		} catch (Exception e) {
			throw e;
		}
		return temp;
	}
	/**
	 * 清除 CHKDEP 中的資料，當使用者選則覆蓋資料作業模式
	 * 時，本程式先清除 CHKDEP 中的內容，再將上傳檔案中的
	 * 資料新增入 CHKDEP
	 * @param Connection  conn 資料庫連線物件
	 */
	 private void delCHKDEP(Connection conn) throws Exception {
		try {
			PreparedStatement stmCHKDEP = null;
			String strCHKDEP ="DELETE FROM CHKDEP";
			stmCHKDEP = conn.prepareStatement(strCHKDEP);
			System.out.println("SQL String : " + strCHKDEP);
			stmCHKDEP.execute();
			stmCHKDEP.close();
		} catch (Exception e) {
		    throw e;
	    }
	 }

}
