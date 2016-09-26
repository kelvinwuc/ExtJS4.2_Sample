import java.io.IOException;
import javax.servlet.Servlet;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.*;
import java.io.*;

import java.io.PrintWriter;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;

public class NBC0181FNDownload extends  CASHServlet {

    private DbFactory dbFactory = null;
    
    public void init() {
	    dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
    }

	public void performTask(HttpServletRequest req, HttpServletResponse resp)
		throws ServletException, IOException {
		String path = checkLogon(req, resp);
		if(!path.equals("")) {
		    resp.setHeader("Window-target","_top");
			resp.sendRedirect(path);
			return;
		}
		
		String TT01 = null;
		String TT02 = null;
		String TT03 = null;
		String TT04 = null;
		String TT05 = null;
		String TT06 = null;
		String TT07 = null;
		String TT08 = null;
		String TT09 = null;
		String TT10 = null;
		String TT11 = null;
		String TT12 = null;
		String TT13 = null;
		String data = null;

		Connection conn = null;

		try {
			String downloadpath = getServletContext().getRealPath("/") + System.getProperty("file.separator") + "download";
			
            
           // 開啟檔案
			File file1 =
				new File(downloadpath, "TRF8.dat");
					
			PrintWriter pr =
				new PrintWriter(new BufferedWriter(new FileWriter(file1)));


            // 載入 JDBC驅動程式
			//Class.forName("com.ibm.as400.access.AS400JDBCDriver");
			
			// 連接資料庫
			//String url =
			//	"jdbc:as400://10.67.0.33;poolType=JdbcOdbc;logtype=2;naming=system;errors=full;date format=iso;extended dynamic=true;package=JDBCPKG;transaction isolation=none;package library=QTEMP;";
			//conn = DriverManager.getConnection(url, "WEBDCR", "DCRWEB");
			//conn = dbFactory.getAS400ConnectionNoDS("NBC0181FNDownload.performTask()");
			conn = dbFactory.getAS400Connection("NBC0181FNDownload.performTask()");
            // 建立 Statement 物件
			Statement stmt = conn.createStatement();
            // 執行 SQL
			String SQL = "SELECT * FROM NBC0181FN ";
			System.out.println("SQL : \n"+SQL);
			//String SQL = "SELECT * FROM CAPDCRF.NBC0181FN";
			ResultSet RS = stmt.executeQuery(SQL);
            // 取得搜尋結果
			int RowCounts = 0;
			while (RS.next()) {
				RowCounts++;
				TT01 = RS.getString("FLD0001");
				TT02 = RS.getString("FLD0002");
				TT03 = RS.getString("FLD0003");
				TT04 = RS.getString("FLD0004");
				TT05 = RS.getString("FLD0005");
				TT06 = RS.getString("FLD0006");
				TT07 = RS.getString("FLD0007");
				TT08 = RS.getString("FLD0008");
				TT09 = RS.getString("FLD0009");
				TT10 = RS.getString("FLD0010");
				TT11 = RS.getString("FLD0011");
				TT12 = RS.getString("FLD0012");
				TT13 = "  ";

				data =
					TT01
						+ TT02
						+ TT03
						+ TT04
						+ TT05
						+ TT06
						+ TT07
						+ TT08
						+ TT09
						+ TT10
						+ TT11
						+ TT12
						+ TT13;
						
				// 將資料寫入檔案
				pr.println(data);

			}
			req.setAttribute("servletparam", Integer.toString(RowCounts));

			pr.close();
			RS.close();
			stmt.close();
			//conn.close();
			dbFactory.releaseAS400Connection(conn);
			//dbFactory.releaseAS400ConnectionNoDS(conn);

			String str = "/FileDownload/NBC0181FN_downloadr.jsp";
			getServletContext().getRequestDispatcher(str).forward(req, resp);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
