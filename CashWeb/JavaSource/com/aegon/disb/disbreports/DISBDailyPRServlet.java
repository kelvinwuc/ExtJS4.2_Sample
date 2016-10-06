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

//import org.apache.openjpa.lib.log.Log;
//import org.eclipse.jst.jsp.core.internal.Logger;

import java.sql.*;
import org.apache.log4j.Logger;

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
	
	private Logger log = Logger.getLogger(getClass());

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
		//uid="20140807104557";//測試
		String ReportSQL = "SELECT A.*,";
		/*String ReportSQL = "SELECT ";
		ReportSQL += "A.PAY_NO,";//OK
		ReportSQL += "A.PAY_METHOD,";//OK
		ReportSQL += "A.PAY_DATE,";//OK
		ReportSQL += "A.PAY_NAME,";//OK
		ReportSQL += "A.PAY_SRC_NAME,";//OK
		ReportSQL += "A.PAY_ID,";//OK
		ReportSQL += "A.PAY_CURRENCY,";//OK
		ReportSQL += "A.PAY_AMOUNT,";//OK
		ReportSQL += "A.PAY_STATUS,";//OK
		ReportSQL += "A.PAY_CONFIRM_DATE1,";//OK
		ReportSQL += "A.PAY_CONFIRM_TIME1,";//OK
		ReportSQL += "A.PAY_CONFIRM_USER1,";//OK
		ReportSQL += "A.PAY_CONFIRM_DATE2,";//OK
		ReportSQL += "A.PAY_CONFIRM_TIME2,";//OK
		ReportSQL += "A.PAY_CONFIRM_USER2,";//OK
		ReportSQL += "A.PAY_DESCRIPTION,";//OK
		ReportSQL += "A.PAY_SOURCE_GROUP,";//OK
		ReportSQL += "A.PAY_SOURCE_CODE,";//OK
		ReportSQL += "A.PAY_PLAN_TYPE,";//OK
		ReportSQL += "A.PAY_SOURCE_PGM,";//OK
		ReportSQL += "A.PAY_VOIDABLE,";//OK
		ReportSQL += "A.PAY_DISPATCH,";//OK
		ReportSQL += "A.PAY_BUDGET_BANK,";//OK
		ReportSQL += "A.PAY_BUDGET_ACCOUNT,";//OK
		ReportSQL += "A.PAY_CHECK_NO,";//OK
		ReportSQL += "A.PAY_CHECK_M1,";//OK
		ReportSQL += "A.PAY_CHECK_M2,";//OK
		ReportSQL += "A.PAY_REMIT_BANK,";//OK
		ReportSQL += "A.PAY_REMIT_ACCOUNT,";//OK
		ReportSQL += "A.PAY_CREDIT_CARD,";//OK
		ReportSQL += "A.PAY_CREDIT_TYPE,";//OK
		ReportSQL += "A.PAY_AUTHORITY_DATE,";//OK
		ReportSQL += "A.PAY_AUTHORITY_CODE,";//OK
		ReportSQL += "A.PAY_CARD_MMYYYY,";//OK
		ReportSQL += "A.POLICY_NO,";//OK
		ReportSQL += "A.APP_NO,";//OK
		ReportSQL += "A.PAY_BRANCH,";//OK
		ReportSQL += "A.REMIT_FEE,";//OK
		ReportSQL += "A.PAY_CASH_DATE,";//OK
		ReportSQL += "A.PAY_BATCH_NO,";//OK
		ReportSQL += "A.PAY_NO_HISTORY,";//OK
		ReportSQL += "A.ENTRY_DATE,";//OK
		ReportSQL += "A.ENTRY_TIME,";//OK
		ReportSQL += "A.ENTRY_USER,";//OK
		ReportSQL += "A.ENTRY_PROGRAM,";//OK
		ReportSQL += "A.UPDATE_DATE,";//OK
		ReportSQL += "A.UPDATE_TIME,";//OK
		ReportSQL += "A.UPDATE_USER,";//OK
		ReportSQL += "A.PAY_MEMO,";//OK
		ReportSQL += "A.BAT_SEQ,";//OK
		ReportSQL += "A.PAY_CASH_CONFIRM,";//OK
		ReportSQL += "A.PAY_PAYCURR,";//OK
		ReportSQL += "A.PAY_PAYAMT,";//OK
		ReportSQL += "A.PAY_PAYRATE,";//OK
		ReportSQL += "A.PAY_FEEWAY,";//OK
		ReportSQL += "A.PAY_SYMBOL,";//OK
		ReportSQL += "A.PAY_INV_DATE,";//OK
		ReportSQL += "A.PAY_SWIFT,";//OK
		ReportSQL += "A.PAY_BK_COUNTRY,";//OK
		ReportSQL += "A.PAY_BK_CITY,";
		ReportSQL += "A.PAY_BK_BRCH,";
		ReportSQL += "A.PAY_ENG_NAME,";//OK
		ReportSQL += "A.PAY_ORGPAMT,";//OK
		ReportSQL += "A.PAY_ORGCRDNO,";//OK
		ReportSQL += "A.PAY_PROJECT_CODE,";//OK
		ReportSQL += "A.PAY_REMIT_BACK,";//OK
		ReportSQL += "A.PAY_BACK_REMARK,";//OK
		ReportSQL += "A.PAY_METHOD_ORG,";//OK
		ReportSQL += "A.PAY_AMOUNT_NT,";//OK
		ReportSQL += "A.PAY_REMITFAIL_DATE,";//OK
		ReportSQL += "A.PAY_REMITFAIL_TIME,";//OK
		ReportSQL += "A.PAY_REMITFAIL_CODE,";//OK
		ReportSQL += "A.PAY_REMITFAIL_DESC,";//OK
		ReportSQL += "A.PAY_CLAM_CCLMNUM,";//OK
		ReportSQL += "A.BANK_REMITFAIL_DATE,";//OK
		ReportSQL += "A.PAY_SERVICING_BRANCH,";//OK
		ReportSQL += "A.ANNUITY_PAY_DATE,";*/ //OK

		ReportSQL += "B.DEPT as PAY_DEPT,'89' AS USERRIGHT ,B.DEPT AS USERDEPT,A.PDESC,C.BKNM,D.CNO,B.USRBRCH AS USRBRCH,B.USRAREA AS USRAREA,B.USRNAM,E.FLD0004 AS DEPTNM,F.FLD0004 AS BRCHNM,G.* "+ 
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
		log.info("ReportSQL是" + ReportSQL);
		request.setAttribute("ReportSQL", ReportSQL);
		dispatcher = request.getRequestDispatcher("/servlet/com.aegon.crystalreport.CreateReportRS");
		try{
			dispatcher.forward(request, response);
		}catch(Exception e){
			log.error(e.getMessage(), e);
		}
		
		return;
	}
	  	
	//Clean up resources
	public void destroy() {
	}
}