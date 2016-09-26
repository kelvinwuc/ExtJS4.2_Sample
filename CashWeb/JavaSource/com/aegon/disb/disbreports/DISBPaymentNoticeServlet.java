package com.aegon.disb.disbreports;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Vector;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * System   : CashWeb
 * 
 * Function : 給付通知書
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.12 $$
 * 
 * Author   : VICKY HSU
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBPaymentNoticeServlet.java,v $
 * $Revision 1.12  2013/12/27 03:42:50  MISSALLY
 * $EB0194-PB0016---新增可修改給付通知書的收件人
 * $
 * $Revision 1.11  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255利率變動型即期年金保險專案
 * $
 * $Revision 1.10  2013/04/12 06:10:25  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $
 * $Revision 1.8  2010/11/23 07:01:22  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.7  2009/11/11 06:21:07  missteven
 * $R90474 修改CASH功能
 * $
 * $Revision 1.6  2009/04/23 06:39:51  missteven
 * $更新FF 環境Aegon119 to Aegon117
 * $
 * $Revision 1.5  2009/04/15 08:01:39  missteven
 * $R90172 Add FF service message return details
 * $
 * $Revision 1.4  2009/04/15 06:21:27  missteven
 * $R90172 FF系統支付選擇contract suspense，FF系統需同現行CAPSIL如實付為0，CASH亦可讓USER執行新增及列印給付通知書
 * $
 * $Revision 1.3  2007/04/20 03:16:45  MISODIN
 * $R60713 FOR AWD
 * $
 * $Revision 1.2  2006/12/05 10:20:24  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.1  2006/06/29 09:40:39  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.8  2005/10/14 07:48:56  misangel
 * $R50835:支付功能提升
 * $
 * $Revision 1.1.2.6  2005/04/12 10:08:05  miselsa
 * $R30530_支付通知書
 * $
 * $Revision 1.1.2.5  2005/04/04 07:02:19  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBPaymentNoticeServlet extends InitDBServlet {

	private DISBBean disbBean = null; // R60713
	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private String path = "";

	// Initialize global variables
	public void init() throws ServletException {
		super.init();
	}

	// Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	//Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		try {
			if ("query".equals(request.getParameter("action"))) {
				this.query(request, response); // R60713
			} else if ("queryZ".equals(request.getParameter("txtAction"))) {
				this.queryZ(request, response); // R60713
			} else if ("add".equals(request.getParameter("txtAction"))) {
				this.add(request, response);
			} else if ("queryNoticeZ".equals(request.getParameter("action"))) {
				this.queryNoticeZ(request, response);
			} else if ("queryNotice".equals(request.getParameter("action"))) {
				this.queryNotice(request, response);
			} else if ("update".equals(request.getParameter("action"))) {
				this.update(request, response);
				this.queryNotice(request, response); // R60713
			} else if ("updateZ".equals(request.getParameter("action"))) {
				this.update(request, response);
				this.queryNoticeZ(request, response);
			}
		} catch(Exception e) {
			System.err.println(e.getMessage());
			throw new ServletException(e.getMessage());	
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(path);	
		dispatcher.forward(request, response);
	}

	private void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
		HttpSession session = request.getSession(true);
		String LogonUser =(String) session.getAttribute(Constant.LOGON_USER_ID);
		String UserDept =(String) session.getAttribute(Constant.LOGON_USER_DEPT);
		String UserRight =(String) session.getAttribute(Constant.LOGON_USER_RIGHT);

		path = "/DISB/DISBReports/DISBPaymentDetail.jsp";
		String POLICYNO = request.getParameter("POLICYNO").toUpperCase();

		DISBPaymentNoticeDAO dao = new DISBPaymentNoticeDAO(dbFactory);
		Vector payments = dao.query(POLICYNO,LogonUser,UserDept,UserRight);
		if(payments.size()==0) {
			request.setAttribute("txtMsg","查到 0 筆資料");	
		}
		request.setAttribute("payments",payments);
	}

	// R60713
	private void queryZ(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
		HttpSession session = request.getSession(true);
		String LogonUser =(String) session.getAttribute(Constant.LOGON_USER_ID);
		String UserDept =(String) session.getAttribute(Constant.LOGON_USER_DEPT);
		String UserRight =(String) session.getAttribute(Constant.LOGON_USER_RIGHT);

		path = "/DISB/DISBReports/DISBPaymentDetailZ.jsp";
		String POLICYNO = request.getParameter("POLICYNO").toUpperCase();

		DISBPaymentNoticeDAO dao = new DISBPaymentNoticeDAO(dbFactory);		
		Vector payments = dao.queryZ(POLICYNO,LogonUser,UserDept,UserRight);
		if(payments.size()==0) {
			request.setAttribute("txtMsg","查到 0 筆資料");	
		}
		request.setAttribute("payments",payments);
	}

	private void queryNotice(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
		path = "/DISB/DISBReports/DISBPaymentNoticeMain.jsp";

		String PNO = request.getParameter("PNO");
		if(PNO == null && request.getParameter("para_PNO") != null) {
			PNO = request.getParameter("para_PNO");
		}

		DISBPaymentNoticeDAO dao = new DISBPaymentNoticeDAO(dbFactory);
		CAPPAYReportVO notice = dao.queryNotice(PNO);

		if(notice==null) {
			request.setAttribute("txtMsg","找不到該筆資料 [ PNO = "+PNO+" ]");	
		}
		request.setAttribute("notice",notice);
	}

	// R60713
	private void queryNoticeZ(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
		path = "/DISB/DISBReports/DISBPaymentNoticeMainZ.jsp";

		String PNO = request.getParameter("PNO");
		if(PNO == null && request.getParameter("para_PNO") != null){
			PNO = request.getParameter("para_PNO");
		}

		DISBPaymentNoticeDAO dao = new DISBPaymentNoticeDAO(dbFactory);
		CAPPAYReportVO notice = dao.queryNoticeZ(PNO);

		if(notice==null) {
			request.setAttribute("txtMsg","找不到該筆資料 [ PNO = "+PNO+" ]");	
		}
		request.setAttribute("notice",notice);
	}

	private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {		
		HttpSession session = request.getSession(true);
		String LogonUser =(String) session.getAttribute(Constant.LOGON_USER_ID);
		CAPPAYReportVO vo = new CAPPAYReportVO();
		vo.setPNO(request.getParameter("para_PNO"));			
		vo.setMAILZIP(request.getParameter("MAILZIP"));
		vo.setMAILAD(request.getParameter("MAILAD"));
		vo.setHMZIP(request.getParameter("HMZIP"));
		vo.setHMAD(request.getParameter("HMAD"));
		vo.setITEM(request.getParameter("ITEM"));
		vo.setSNDNM(request.getParameter("SNDNM"));
		vo.setUPDUSR(LogonUser.trim());
		
		if(request.getParameter("RECEIVER")!=null && !"".equals(request.getParameter("RECEIVER"))) {
			vo.setRECEIVER(CommonUtil.AllTrim(request.getParameter("RECEIVER")));
		}
		if(request.getParameter("DEFAMT")!=null && !"".equals(request.getParameter("DEFAMT"))) {
			vo.setDEFAMT(Double.parseDouble(request.getParameter("DEFAMT")));
		}
		if(request.getParameter("DIVAMT")!=null && !"".equals(request.getParameter("DIVAMT"))) {
			vo.setDIVAMT(Double.parseDouble(request.getParameter("DIVAMT")));
		}
		if(request.getParameter("LOAN")!=null && !"".equals(request.getParameter("LOAN"))) {
			vo.setLOAN(Double.parseDouble(request.getParameter("LOAN")));
		}
		if(request.getParameter("UNPRDPRM")!=null && !"".equals(request.getParameter("UNPRDPRM"))) {
			vo.setUNPRDPRM(Double.parseDouble(request.getParameter("UNPRDPRM")));
		}
		if(request.getParameter("REVPRM")!=null && !"".equals(request.getParameter("REVPRM"))) {
			vo.setREVPRM(Double.parseDouble(request.getParameter("REVPRM")));
		}
		if(request.getParameter("CURPRM")!=null && !"".equals(request.getParameter("CURPRM"))) {
			vo.setCURPRM(Double.parseDouble(request.getParameter("CURPRM")));
		}
		vo.setPEWD((String)request.getParameter("PEWD").trim());
		if(request.getParameter("PEAMT")!=null && !"".equals(request.getParameter("PEAMT"))) {
			vo.setPEAMT(Double.parseDouble(request.getParameter("PEAMT")));
		}
		if(request.getParameter("LANINT")!=null && !"".equals(request.getParameter("LANINT"))) {
			vo.setLANINT(Double.parseDouble(request.getParameter("LANINT")));
		}
		if(request.getParameter("LANCAP")!=null && !"".equals(request.getParameter("LANCAP"))) {
			vo.setLANCAP(Double.parseDouble(request.getParameter("LANCAP")));
		}
		if(request.getParameter("APL")!=null && !"".equals(request.getParameter("APL"))) {
			vo.setAPL(Double.parseDouble(request.getParameter("APL")));
		}
		if(request.getParameter("APLINT")!=null && !"".equals(request.getParameter("APLINT"))) {
			vo.setAPLINT(Double.parseDouble(request.getParameter("APLINT")));
		}		
		vo.setOFFWD((String)request.getParameter("OFFWD").trim());				
		if(request.getParameter("OFFAMT")!=null && !"".equals(request.getParameter("OFFAMT"))) {
			vo.setOFFAMT(Double.parseDouble(request.getParameter("OFFAMT")));
		}
		if(request.getParameter("OVRRTN")!=null && !"".equals(request.getParameter("OVRRTN"))) {
			vo.setOVRRTN(Double.parseDouble(request.getParameter("OVRRTN")));
		}
		//R90474
		if(request.getParameter("OFFWD1")!=null && !"".equals(request.getParameter("OFFWD1"))) {
			vo.setOFFWD1(request.getParameter("OFFWD1").trim());
		}
		if(request.getParameter("OFFAMT1")!=null && !"".equals(request.getParameter("OFFAMT1"))) {
			vo.setOFFAMT1(Double.parseDouble(request.getParameter("OFFAMT1")));
		}
		if(request.getParameter("OFFWD2")!=null && !"".equals(request.getParameter("OFFWD2"))) {
			vo.setOFFWD2(request.getParameter("OFFWD2").trim());
		}
		if(request.getParameter("OFFAMT2")!=null && !"".equals(request.getParameter("OFFAMT2"))) {
			vo.setOFFAMT2(Double.parseDouble(request.getParameter("OFFAMT2")));
		}
		if(request.getParameter("OFFWD3")!=null && !"".equals(request.getParameter("OFFWD3"))) {
			vo.setOFFWD3(request.getParameter("OFFWD3").trim());
		}
		if(request.getParameter("OFFAMT3")!=null && !"".equals(request.getParameter("OFFAMT3"))) {
			vo.setOFFAMT3(Double.parseDouble(request.getParameter("OFFAMT3")));
		}
		if(request.getParameter("ANNAMT")!=null && !"".equals(request.getParameter("ANNAMT"))) {
			vo.setANNAMT(Double.parseDouble(request.getParameter("ANNAMT")));
		}
		DISBPaymentNoticeDAO dao = new DISBPaymentNoticeDAO(dbFactory);
		int n  = dao.update(vo);

		request.setAttribute("txtMsg",n+"筆資料已修改");	
	}

	// R60713
	private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {		
		HttpSession session = request.getSession(true);

		String LogonUser =(String) session.getAttribute(Constant.LOGON_USER_ID);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
				
		path = "/DISB/DISBReports/DISBPaymentNoticeMainZ.jsp";
		String strPOLICYNO = request.getParameter("POLICYNO").toUpperCase();

		Connection con = dbFactory.getAS400Connection("DISBPMaintainServlet.insertDB()");

		int iEntryDate = 0; //輸入日期
		int iEntryTime = 0; //輸入時間
		String strPNO = "";
		String strSql = ""; 
		String strReturnMsg = "";
		String strBranch = "";//單位
		String strMailzip = "";	
		String strMailad= "";
		String strHMzip = "";	
		String strHMad= "";		
		String strSrvnm = "";							
		String strAppnm = "";	
		String strInsnm = "";	
		String strRevnm = "";			
		
		Hashtable htReturnInfo = new Hashtable();
		Hashtable htPolMailAdd= new Hashtable();

		strSql = "INSERT INTO CAPPAYRF "
				  +"(PNO,POLICYNO,APPNM,INSNM,RECEIVER,MAILZIP,MAILAD,HMZIP,HMAD,SRVNM,SRVBH,UPDDT,UPDTM,UPDUSR)"
				  +" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

		iEntryDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		iEntryTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		disbBean = new DISBBean(dbFactory);

		try {
			/* 取得支付序號*/
			//
			htReturnInfo = (Hashtable) disbBean.getDISBSeqNo("DISB", LogonUser, con);
			strReturnMsg = (String)htReturnInfo.get("ReturnMsg");
			if(strReturnMsg.equals(""))
			{
				strPNO = (String)htReturnInfo.get("ReturnValue");
				request.setAttribute("txtPNo", strPNO);
				/*取得保單單位*/
				htReturnInfo = null;
				if(!strPOLICYNO.equals(""))
				{
					htReturnInfo = (Hashtable)disbBean.getPolDiv(strPOLICYNO,con);
					strReturnMsg = (String)htReturnInfo.get("ReturnMsg");				
					if(strReturnMsg.equals(""))
					{
						strBranch =  (String)htReturnInfo.get("ReturnValue");
					}	
				}
				if(strReturnMsg.equals(""))
				{
					htPolMailAdd = (Hashtable)disbBean.getPolMailAdd(strPOLICYNO);	
					strMailzip =  (String)htPolMailAdd.get("mailzc");	
					strMailad =  (String)htPolMailAdd.get("mailad");	
					strHMzip =  (String)htPolMailAdd.get("mailzc");	
					strHMad =  (String)htPolMailAdd.get("mailad");		
								
					strSrvnm = (String)disbBean.getServiceNm(strPOLICYNO);	
					System.out.println("SRVNM = " +strSrvnm);
					strAppnm = (String)disbBean.getAppNm(strPOLICYNO);	
					System.out.println("APPNM = " +strAppnm);
					strRevnm = (String)disbBean.getAppNm(strPOLICYNO);	
					System.out.println("REVNM = " +strRevnm);					
					strInsnm = (String)disbBean.getInsuredNm(strPOLICYNO);	
					System.out.println("INSNM = " +strInsnm);											
	
					PreparedStatement pstmtTmp = con.prepareStatement(strSql);
					System.out.println("PNO = " +strPNO);
					System.out.println("POLICY = " +strPOLICYNO);					
					pstmtTmp.setString(1, strPNO);
					pstmtTmp.setString(2, strPOLICYNO);
					pstmtTmp.setString(3, strAppnm);
					pstmtTmp.setString(4, strInsnm);
					pstmtTmp.setString(5, strRevnm);														
					pstmtTmp.setString(6, strMailzip);
					pstmtTmp.setString(7, strMailad);
					pstmtTmp.setString(8, strHMzip);
					pstmtTmp.setString(9, strHMad);
					pstmtTmp.setString(10, strSrvnm);
					pstmtTmp.setString(11, strBranch);
					pstmtTmp.setInt(12, iEntryDate);
					pstmtTmp.setInt(13, iEntryTime);
					pstmtTmp.setString(14, LogonUser);

					if (pstmtTmp.executeUpdate() != 1) {
						strReturnMsg="新增失敗";
					} else {
						request.setAttribute("txtMsg", "新增成功, 支付序號為:"+ strPNO);
						request.setAttribute("isErr", "");
					}
					pstmtTmp.close();
				}
			}
			if (!strReturnMsg.equals("")) 
			{
				request.setAttribute("isErr", "Y");
				request.setAttribute("txtMsg", strReturnMsg);
				if (isAEGON400) {
					con.rollback();
				}
			}

		} 	catch (SQLException e) {
			request.setAttribute("txtMsg", "新增失敗:"+e);
			request.setAttribute("isErr", "Y");
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
	}

	//Clean up resources
	public void destroy() {
	}
	
}