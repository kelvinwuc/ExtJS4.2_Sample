package com.aegon.disb.disbreports;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

import com.aegon.comlib.*;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.StringTool;

import java.text.DecimalFormat;

import javax.servlet.ServletContext;

import java.sql.*;
/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$ $$
 * 
 * Author   : Vanessa Liao
 * 
 * Create Date : $$date$$
 * 
 * Request ID : Q80432
 * 
 * CVS History:
 * 
 * $$Log: DISBDailyPRServlet.java,v $
 * $Revision 1.3  2014/10/30 06:37:17  misariel
 * $QC0343-支票張數改為不重複計算(調整SQL)
 * $
 * $Revision 1.2  2014/08/05 03:13:52  missteven
 * $RC0036
 * $
 * $Revision 1.1  2008/08/21 09:17:20  misvanessa
 * $Q80432_XFILE檢核
 * $
 * $$
 *  
 */
public class DISBDailyPRServlet  extends com.aegon.comlib.InitDBServlet {

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private String path = "";
	  
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
			
			if("query".equals(request.getParameter("action"))){
				this.queryXFILE(request, response);
			}
			
			if("DISBPSourceConfirm".equals(request.getParameter("action"))){
				this.updatePayments(request, response);
			}
			
		}catch(Exception e){
			System.err.println(e.toString());	
			request.setAttribute("txtMsg",e.getMessage());		
		}		
	}
	
	private void queryXFILE(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception{
		Vector downfile = new Vector();
		String strSql = new String("");
		RequestDispatcher dispatcher = null;
		
		strSql = "select POLICYNO" ;
		strSql += " from CAPPAYF WHERE 1=1 AND PID LIKE 'X-%' AND PCFMDT2 =0 AND PCFMDT1 <> 0 AND PVOIDABLE<> 'Y' ";
		
		Connection conDb = null;
		try
			{
				conDb = dbFactory.getAS400Connection("getXFILEList()");
				if( conDb != null )
				{
					Statement stmtStatement = conDb.createStatement();
					ResultSet rstResultSet = stmtStatement.executeQuery( strSql );
					while(rstResultSet.next())
					{					
						downfile.add((String)rstResultSet.getString("POLICYNO").trim());
					}	
					rstResultSet.close();
					stmtStatement.close();
				}				
		}
		catch( Exception ex )
		{
			System.out.println("Application Exception >>> " + ex);
			if( conDb != null )
				dbFactory.releaseAS400Connection(conDb);
		} finally {
				if (conDb != null) {
					dbFactory.releaseAS400Connection(conDb);
			}
		}
		request.setAttribute("XPol" , downfile);
		request.setAttribute("txtAction", "returnXPOL");
		dispatcher = request.getRequestDispatcher("/DISB/DISBReports/DISBDailyPReports.jsp");
		dispatcher.forward(request, response);
		return;	
	}
	
	//RC0036
	private void updatePayments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception{
		HttpSession session = request.getSession(false);
		RequestDispatcher dispatcher = null;
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection conDb = null;
		PreparedStatement stmt = null;
		String[] pno = request.getParameterValues("PNO");
		String disPatch= request.getParameter("para_DISPATCH")!=null?request.getParameter("para_DISPATCH"):"";
		String uid = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmm");
		java.util.Date current = new java.util.Date();
		try{
				conDb = dbFactory.getAS400Connection("updatePayments()");
				if( conDb != null )
				{
					for (int i = 0 ; i < pno.length ; i++){		
						stmt = conDb.prepareStatement("insert into cappayf2 values(?,?,?,?)");
						stmt.setString(1,uid);
						stmt.setString(2,pno[i]);
						stmt.setString(3,request.getParameter("CHK"+pno[i])!=null?request.getParameter("CHK"+pno[i]):"");
						stmt.setString(4,strLogonUser);
						stmt.executeUpdate();
					}	
				}				
		}
		catch( Exception ex )
		{
			System.out.println("Application Exception >>> " + ex);
		} finally {
			if (conDb != null) {
				dbFactory.releaseAS400Connection(conDb);
			}
		}
		
		//急件付款，產生Excel下載檔 
		if ("Y".equals(disPatch)){
			WriteExcel wx = new WriteExcel() ;
			wx.setOutputFile(globalEnviron.getAppPath()+"\\download\\"+sdf.format(current)+"急件給付清單.xls");
			wx.write(request,response);
		}
		
		/*QC0343 SQL調整*/
		String ReportSQL = "SELECT A.*,B.DEPT as PAY_DEPT,'89' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM,D.CNO,B.USRBRCH AS USRBRCH,B.USRAREA AS USRAREA,B.USRNAM,E.FLD0004 AS DEPTNM,F.FLD0004 AS BRCHNM,G.* "+ 
						   "from CAPPAYF A left outer join USER B  on B.USRID=A.ENTRY_USER "+
				           "left outer join CAPCCBF C on C.BKNO=A.PRBANK "+
				           "left outer join ORDUET E on E.FLD0002 = 'DEPT' AND E.FLD0003 = B.DEPT "+
						   "left outer join ORDUET F on F.FLD0002 = 'DEPT' AND F.FLD0003 = B.USRBRCH "+
						   "left join (SELECT MAX(A.PNO) AS PNO,COUNT(DISTINCT CNO) AS CNT from CAPPAYF A "+
						   "left outer join USER B on B.USRID=A.ENTRY_USER,CAPPAYF2 D "+
						   "WHERE A.PNO = D.PNO AND D.SID = '"+uid+"' "+
						   "AND D.CNO <> '' "+
						   "GROUP BY CNO) G "+
						   "on A.PNO = G.PNO ,CAPPAYF2 D "+
						   "WHERE A.PNO = D.PNO "+
						   "AND D.SID = '"+uid+"' "+
						   "ORDER BY B.DEPT,B.USRBRCH,A.ENTRY_USER ASC ";
		request.setAttribute("ReportSQL", ReportSQL);
		dispatcher = request.getRequestDispatcher("/servlet/com.aegon.crystalreport.CreateReportRS");
		dispatcher.forward(request, response);
		return;
	}
	  	
	//Clean up resources
	public void destroy() {
	}
}