package com.aegon.crooutone;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.crooutbat.CapcshfbVO;
import com.aegon.entactbat.CapcshfDTO;

import org.apache.log4j.Logger;

/**
 * System : CashWeb
 * 
 * Function : 單筆銷帳處理
 * 
 * Remark :
 * 
 * Revision : $$Revision: 1.15 $$
 * 
 * Author : ODCWILLIAM
 * 
 * Create Date : $$Date: 2014/02/19 08:52:30 $$
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * $$Log: CroOutOneServlet.java,v $
 * $Revision 1.15  2014/02/19 08:52:30  MISSALLY
 * $R00135---PA0024---CASH年度專案-03
 * $還原
 * $
 * $Revision 1.14  2014/02/14 06:42:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---修正多對一時多筆不需銷帳的資料被銷到
 * $
 * $Revision 1.13  2014/02/11 09:05:48  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---修正多對一時多筆不需銷帳的資料被銷到
 * $
 * $Revision 1.12  2014/02/07 04:29:49  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.11  2014/01/28 10:31:47  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.10  2014/01/28 06:37:34  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.9  2014/01/27 07:43:44  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.7  2014/01/22 08:34:28  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---調整顯示全球入帳日以登帳檔為主
 * $
 * $Revision 1.6  2014/01/21 09:07:15  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---保留上次的資訊
 * $
 * $Revision 1.5  2014/01/15 02:30:38  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---保留上次的資訊
 * $
 * $Revision 1.4  2014/01/14 06:01:14  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---修改資料排序問題
 * $
 * $Revision 1.3  2014/01/14 01:49:43  MISSALLY
 * $R00135---PA0024---CASH年度專案
 * $非保費帳處理
 * $
 * $Revision 1.2  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $$
 * 
 */

public class CroOutOneServlet extends InitDBServlet {

	private static final long serialVersionUID = 4760546335855851723L;
	
	private Logger log = Logger.getLogger(getClass());

	private Connection conDb = null;

	private String errorUrl = "/CroOutOne/CroOutOneC.jsp";		// 失敗跳轉頁面路徑
	private String viewUrl = "/CroOutOne/CroOutOneV.jsp";		// 單筆銷帳

	private String strDateTime = "";
	private String strUpdDate = "";
	private String strUpdTime = "";
	private String strLogonUser = "";

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
	{
		HttpSession session = req.getSession();

		String strAction = (req.getParameter("txtAction") != null)?CommonUtil.AllTrim(req.getParameter("txtAction")):"";

		try
		{
			conDb = dbFactory.getAS400Connection("CroOutOneServlet");

			if (conDb == null) 
			{
				req.setAttribute("txtMsg", "資料庫連接失敗!!");
				req.getRequestDispatcher(errorUrl).forward(req, resp);
			} 
			else 
			{
				String strMsg = "";
				strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
				strUpdDate = strDateTime.substring(0, 7);
				strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

				CroOutOneConditionDTO coocDTO = null;

				if(strAction.equals("I"))
				{
					// 頁面參數存放入傳輸對象
					//CroOutOneC.jsp,<確定>按鈕被點選時
					coocDTO = this.setCroOutOneConditionDTO(req);
					System.out.println("url:" + req.getContextPath());					
				}
				else if(strAction.equals("SAVE"))
				{
					//CroOutOneV.jsp,<確定>按鈕被點選時
					
					//若strAction.equals("I")的fList有找到資料,coocDTO則有值
					coocDTO = (CroOutOneConditionDTO) session.getAttribute("condition");

					if(session.getAttribute("fData") != null){
						log.info("fData有值");
					}else{
						log.info("fData是null");
					}
					if(session.getAttribute("fbData") != null){
						log.info("fbData有值");
					}else{
						log.info("fbData是null");
					}
					List<CapcshfDTO> orgData = (session.getAttribute("fData") != null)?((List<CapcshfDTO>) session.getAttribute("fData")):null;
					List<CapcshfbVO> fbData = (session.getAttribute("fbData") != null)?((List<CapcshfbVO>) session.getAttribute("fbData")):null;

					List<CapcshfDTO> list = this.getRequestData(req, orgData);

					strMsg = executeWriteoffs(list, fbData);

					req.setAttribute("PoCurr", req.getParameter("txtPoCurr"));
					req.setAttribute("CroType", req.getParameter("txtCroType"));
					session.removeAttribute("DefaultAegDt");
					session.setAttribute("DefaultAegDt", req.getParameter("txtDefaultEAEGDT"));
				}
				else if(strAction.equals("CANCEL"))
				{
					coocDTO = (CroOutOneConditionDTO) session.getAttribute("condition");

					List<CapcshfDTO> orgData = (session.getAttribute("fData") != null)?((List<CapcshfDTO>) session.getAttribute("fData")):null;
					List<CapcshfbVO> fbData = (session.getAttribute("fbData") != null)?((List<CapcshfbVO>) session.getAttribute("fbData")):null;

					CapcshfDTO obj = orgData.get(Integer.parseInt(req.getParameter("txtCurrentRec")));

					strMsg = cancelWriteoffs(req, obj, fbData);

					session.removeAttribute("CurrentPage");
					session.setAttribute("CurrentPage", req.getParameter("txtCurrentPage"));
				}

				//查詢登帳資訊CAPCSHF
				List<CapcshfDTO> fList = this.getCapcshfData(qryCAPCSHF(coocDTO));//qryCAPCSHF是將前端的查詢條件置入SQL(CAPCSHF)
				List<CapcshfbVO> fbList = this.getCapcshfbData(qryByCertificate(coocDTO), qryCAPCSHFB(coocDTO));//qryByCertificate是將前端的查詢條件置入SQL(CAPBNKF,ORGNFBM,ORGNFBDK1,CAPCSHFBK1[phyisical file是CAPCSHFB]);qryCAPCSHFB是將前端的查詢條件置入SQL(CAPCSHFB)

				session.removeAttribute("fData");
				session.removeAttribute("fbData");
				session.removeAttribute("condition");

				if (fList.size() > 0) {
					session.setAttribute("fData", fList);
					session.setAttribute("fbData", fbList);
					session.setAttribute("condition", coocDTO);
					req.setAttribute("txtMsg", strMsg);
					req.getRequestDispatcher(viewUrl).forward(req, resp);
				} else {
					req.setAttribute("txtMsg", "查無資料!!");
					req.getRequestDispatcher(errorUrl).forward(req, resp);
				}
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			req.setAttribute("txtMsg", "異常錯誤!!");
			req.getRequestDispatcher(errorUrl).forward(req, resp);
		} finally {
			if(conDb != null) dbFactory.releaseAS400Connection(conDb);
		}
	}

	private List<CapcshfDTO> getCapcshfData(String strSql) throws SQLException {
		List<CapcshfDTO> list = new ArrayList<CapcshfDTO>();

		Connection con = null;
		Statement stm = null;
		ResultSet rst = null;

		try {
			CapcshfDTO fDTO = null;
			con = dbFactory.getAS400Connection("CroOutOneServlet.getfData");
			stm = con.createStatement();

			//登帳資訊
			log.info("登帳資訊:" + strSql);
			rst = stm.executeQuery(strSql);
			while (rst.next()) {
				fDTO = new CapcshfDTO();

				fDTO.setEBKCD(CommonUtil.AllTrim(rst.getString("EBKCD")));//1
				fDTO.setEATNO(CommonUtil.AllTrim(rst.getString("EATNO")));//2
				fDTO.setEBKRMD(rst.getInt("EBKRMD"));//3
				fDTO.setEAEGDT(rst.getInt("EAEGDT"));//4
				fDTO.setENTAMT(rst.getDouble("ENTAMT"));//5
				fDTO.setCSHFCURR(rst.getString("CSHFCURR"));//6
				fDTO.setEUSREM(CommonUtil.AllTrim(rst.getString("EUSREM")));//7
				fDTO.setEUSREM2(CommonUtil.AllTrim(rst.getString("EUSREM2")));//8
				fDTO.setECRDAY(CommonUtil.AllTrim(rst.getString("ECRDAY")));//9
				fDTO.setCSHFAU(CommonUtil.AllTrim(rst.getString("CSHFAU")));//10
				fDTO.setCSHFAD(rst.getInt("CSHFAD"));//11
				fDTO.setCSHFAT(rst.getInt("CSHFAT"));//12
				fDTO.setCSHFUT(rst.getInt("CSHFUT"));//13
				log.info("fDTO.setEBKCD:" + rst.getString("EBKCD")//1
						+ ",fDTO.setEATNO:" + rst.getString("EATNO")//2
						+ ",fDTO.setEBKRMD:" + rst.getInt("EBKRMD")//3
						+ ",fDTO.setEAEGDT:" + rst.getInt("EAEGDT")//4
						+ ",fDTO.setENTAMT:" + rst.getDouble("ENTAMT")//5
						+ ",fDTO.setCSHFCURR:" + rst.getString("CSHFCURR")//6
						+ ",fDTO.setEUSREM:" + CommonUtil.AllTrim(rst.getString("EUSREM"))//7
						+ ",fDTO.setEUSREM2:" + CommonUtil.AllTrim(rst.getString("EUSREM2"))//8
						+ ",fDTO.setECRDAY:" + CommonUtil.AllTrim(rst.getString("ECRDAY"))//9
						+ ",fDTO.setCSHFAU:" + CommonUtil.AllTrim(rst.getString("CSHFAU"))//10
						+ ",fDTO.setCSHFAD:" + rst.getInt("CSHFAD")//11
						+ ",fDTO.setCSHFAT:" + rst.getInt("CSHFAT")//12
						+ ",fDTO.setCSHFUT:" + rst.getInt("CSHFUT"));//13
				list.add(fDTO);
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			if (rst != null) rst.close();
			if (stm != null) stm.close();
			if (con != null) dbFactory.releaseAS400Connection(con);
		}

		return list;
	}

	private List<CapcshfbVO> getCapcshfbData(String strSql1, String strSql2) throws SQLException {
		List<CapcshfbVO> list = new ArrayList<CapcshfbVO>();

		Connection con = null;
		Statement stm = null;
		ResultSet rst = null;

		try {
			CapcshfbVO fbDTO = null;
			con = dbFactory.getAS400Connection("CroOutOneServlet.getfbData");
			stm = con.createStatement();

			//保費入帳資訊
			//憑證
			log.info("保費入帳資訊-憑證:" + strSql1);
			rst = stm.executeQuery(strSql1);
			while (rst.next()) {
				fbDTO = new CapcshfbVO();

				fbDTO.setCBKCD(CommonUtil.AllTrim(rst.getString("CBKCD")));//1
				fbDTO.setCATNO(CommonUtil.AllTrim(rst.getString("CATNO")));//2
				fbDTO.setCBKRMD(rst.getInt("CBKRMD"));//3
				fbDTO.setCAEGDT(rst.getInt("CAEGDT"));//4
				fbDTO.setCROAMT(rst.getDouble("CROAMT"));//5
				fbDTO.setCRODAY(rst.getInt("CRODAY"));//6
				fbDTO.setCCURR(CommonUtil.AllTrim(rst.getString("CSFBCURR")));//7
				fbDTO.setCSFBRECTNO(CommonUtil.AllTrim(rst.getString("CSFBRECTNO")));//8
				fbDTO.setCSFBRECSEQ(rst.getInt("CSFBRECSEQ"));//9
				fbDTO.setCSFBPONO(CommonUtil.AllTrim(rst.getString("CSFBPONO")));//10
				fbDTO.setCSFBAU(CommonUtil.AllTrim(rst.getString("CSFBAU")));//11
				fbDTO.setCSFBAD(rst.getInt("CSFBAD"));//12
				fbDTO.setCSFBAT(rst.getInt("CSFBAT"));//13
				fbDTO.setCSFBUT(rst.getInt("CSFBUT"));//14

				log.info("fbDTO.setCBKCD:" + CommonUtil.AllTrim(rst.getString("CBKCD"))//1
						+ ",fbDTO.setCATNO:" + CommonUtil.AllTrim(rst.getString("CATNO"))//2
						+ ",fbDTO.setCBKRMD:" + rst.getInt("CBKRMD")//3
						+ ",fbDTO.setCAEGDT:" + rst.getInt("CAEGDT")//4
						+ ",fbDTO.setCROAMT:" + rst.getDouble("CROAMT")//5
						+ ",fbDTO.setCRODAY:" + rst.getInt("CRODAY")//6
						+ ",fbDTO.setCCURR:" + CommonUtil.AllTrim(rst.getString("CSFBCURR"))//7
						+ ",fbDTO.setCSFBRECTNO:" + CommonUtil.AllTrim(rst.getString("CSFBRECTNO"))//8
						+ ",fbDTO.setCSFBRECSEQ:" + rst.getInt("CSFBRECSEQ")//9
						+ ",fbDTO.setCSFBPONO:" + CommonUtil.AllTrim(rst.getString("CSFBPONO"))//10
						+ ",fbDTO.setCSFBAU:" + CommonUtil.AllTrim(rst.getString("CSFBAU"))//11
						+ ",fbDTO.setCSFBAD:" + rst.getInt("CSFBAD")//12
						+ ",fbDTO.setCSFBAT:" + rst.getInt("CSFBAT")//13
						+ ",fbDTO.setCSFBUT:" + rst.getInt("CSFBUT"));//14
				list.add(fbDTO);
			}

			if(list.isEmpty()) {
				//一對一
				log.info("保費入帳資訊-一對一:" + strSql2);
				rst = stm.executeQuery(strSql2);
				while (rst.next()) {
					fbDTO = new CapcshfbVO();

					fbDTO.setCBKCD(CommonUtil.AllTrim(rst.getString("CBKCD")));//1
					fbDTO.setCATNO(CommonUtil.AllTrim(rst.getString("CATNO")));//2
					fbDTO.setCBKRMD(rst.getInt("CBKRMD"));//3
					fbDTO.setCAEGDT(rst.getInt("CAEGDT"));//4
					fbDTO.setCROAMT(rst.getDouble("CROAMT"));//5
					fbDTO.setCRODAY(rst.getInt("CRODAY"));//6
					fbDTO.setCCURR(CommonUtil.AllTrim(rst.getString("CSFBCURR")));//7
					fbDTO.setCSFBPONO(CommonUtil.AllTrim(rst.getString("CSFBPOCURR")));//8
					fbDTO.setCSFBRECTNO(CommonUtil.AllTrim(rst.getString("CSFBRECTNO")));//9
					fbDTO.setCSFBRECSEQ(rst.getInt("CSFBRECSEQ"));//10
					fbDTO.setCSFBAU(CommonUtil.AllTrim(rst.getString("CSFBAU")));//11
					fbDTO.setCSFBAD(rst.getInt("CSFBAD"));//12
					fbDTO.setCSFBAT(rst.getInt("CSFBAT"));//13
					fbDTO.setCSFBUT(rst.getInt("CSFBUT"));//14

					log.info("fbDTO.setCBKCD:" + CommonUtil.AllTrim(rst.getString("CBKCD"))//1
							+ ",fbDTO.setCATNO:" + CommonUtil.AllTrim(rst.getString("CATNO"))//2
							+ ",fbDTO.setCBKRMD:" + rst.getInt("CBKRMD")//3
							+ ",fbDTO.setCAEGDT:" + rst.getInt("CAEGDT")//4
							+ ",fbDTO.setCROAMT:" + rst.getDouble("CROAMT")//5
							+ ",fbDTO.setCRODAY:" + rst.getInt("CRODAY")//6
							+ ",fbDTO.setCCURR:" + CommonUtil.AllTrim(rst.getString("CSFBCURR"))//7
							+ ",fbDTO.setCSFBPONO:" + CommonUtil.AllTrim(rst.getString("CSFBPOCURR"))//8
							+ ",fbDTO.setCSFBRECTNO:" + CommonUtil.AllTrim(rst.getString("CSFBRECTNO"))//9
							+ ",fbDTO.setCSFBRECSEQ:" + rst.getInt("CSFBRECSEQ")//10
							+ ",fbDTO.setCSFBAU:" + CommonUtil.AllTrim(rst.getString("CSFBAU"))//11
							+ ",fbDTO.setCSFBAD:" + rst.getInt("CSFBAD")//12
							+ ",fbDTO.setCSFBAT:" + rst.getInt("CSFBAT")//13
							+ ",fbDTO.setCSFBUT:" + rst.getInt("CSFBUT"));//14
					list.add(fbDTO);
				}
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			if (rst != null) rst.close();
			if (stm != null) stm.close();
			if (con != null) dbFactory.releaseAS400Connection(con);
		}
		return list;
	}

	private String qryByCertificate(CroOutOneConditionDTO coocDTO) {
		String strSql = "";
		strSql = "SELECT * ";
		strSql += "FROM CAPBNKF A  ";
		strSql += "LEFT JOIN ORGNFBM E ON E.FBMACTBNK=A.BKALAT and E.FBMACTDT=" + coocDTO.getRmtDate() + " and E.FBMFACAMT=" + coocDTO.getRmtAmt() + " ";
		strSql += "LEFT JOIN ORGNFBDK1 F ON F.FBDNO=E.FBMNO ";
		strSql += "LEFT JOIN CAPCSHFBK1 G ON G.CSFBRECTNO=F.FBDREPNO and G.CSFBRECSEQ=F.FBDREPSEQ and G.CROAMT<>E.FBMFACAMT ";
		strSql += "WHERE G.CBKCD IS NOT NULL ";
		strSql += " and A.BKCODE = '" + coocDTO.getBkCode() + "' ";

		if(!"".equals(coocDTO.getAccount())) {
			strSql += " and A.BKATNO = '" + coocDTO.getAccount() + "' ";
		}
		if (!"all".equals(coocDTO.getCurrency())) {
			strSql += " and A.BKCURR = '" + coocDTO.getCurrency() + "' ";
		}
		if (coocDTO.getAegDate() != 0) {
			strSql += " and G.CAEGDT =" + coocDTO.getAegDate();
		}

		strSql += " ORDER BY G.CBKCD,G.CATNO,G.CBKRMD,G.CSFBCURR,G.CROAMT,G.CSFBAT ";

		System.out.println("CroOutOne Qry_BY_Certificate_SQL="+strSql);
		return strSql;
	}

	private String qryCAPCSHF(CroOutOneConditionDTO coocDTO) {
		String strSql = "";
		strSql = "SELECT a.EBKCD,a.EATNO,a.EBKRMD,a.ENTAMT,a.EAEGDT,a.ECRDAY,a.CSHFAU,a.CSHFAD,a.CSHFAT,a.EUSREM,a.EUSREM2,a.CROTYPE,a.CSHFCURR,a.CSHFPOCURR,a.CSHFUT ";
		strSql += "FROM CAPCSHF a ";
		strSql += "WHERE a.EBKCD = '" + coocDTO.getBkCode() + "' ";

		if(!"".equals(coocDTO.getAccount())) {
			strSql += " and a.EATNO = '" + coocDTO.getAccount() + "' ";
		}
		if (!"all".equals(coocDTO.getCurrency())) {
			strSql += " and a.CSHFCURR = '" + coocDTO.getCurrency() + "' ";
		}
		if (coocDTO.getRmtDate() != 0) {
			strSql += " and a.EBKRMD = " + coocDTO.getRmtDate();
		}
		if (coocDTO.getRmtAmt() != 0) {
			strSql += " and a.ENTAMT =" + coocDTO.getRmtAmt();
		}
		if (coocDTO.getAegDate() != 0) {
			strSql += " and a.EAEGDT =" + coocDTO.getAegDate();
		}

		strSql += " ORDER BY a.EBKCD,a.EATNO,a.EBKRMD,a.CSHFCURR,a.ENTAMT,a.CSHFAT ";

		System.out.println("CroOutOne Qry_CAPCSHF_SQL="+strSql);
		log.info("CroOutOne Qry_CAPCSHF_SQL="+strSql);
		return strSql;
	}

	private String qryCAPCSHFB(CroOutOneConditionDTO coocDTO) {
		String strSql = "";
		strSql = "SELECT b.CBKCD,b.CATNO,b.CBKRMD,b.CROAMT,b.CAEGDT,b.CRODAY,b.CROSRC,b.CSFBCURR,b.CSFBPOCURR,b.CSFBRECTNO,b.CSFBRECSEQ,b.CSFBPONO,b.CSFBAU,b.CSFBAD,b.CSFBAT,b.CSFBUT,b.CSFBAMTREF ";
		strSql += "FROM CAPCSHFB b ";
		strSql += "WHERE b.CBKCD='" + coocDTO.getBkCode() + "' ";
		if(!"".equals(coocDTO.getAccount())) {
			strSql += " and b.CATNO = '" + coocDTO.getAccount() + "' ";
		}
		if (!"all".equals(coocDTO.getCurrency())) {
			strSql += " and b.CSFBCURR = '" + coocDTO.getCurrency() + "' ";
		}
		if (coocDTO.getRmtDate() != 0) {
			strSql += " and b.CBKRMD = " + coocDTO.getRmtDate();
		}
		if (coocDTO.getRmtAmt() != 0) {
			strSql += " and b.CROAMT =" + coocDTO.getRmtAmt();
		}
		if (coocDTO.getAegDate() != 0) {
			strSql += " and b.CAEGDT =" + coocDTO.getAegDate();
		}
		strSql += " ORDER BY b.CBKCD,b.CATNO,b.CBKRMD,b.CAEGDT,b.CSFBCURR,b.CROAMT,b.CSFBAT ";

		System.out.println("CroOutOne Qry_CAPCSHFB_SQL="+strSql);
		return strSql;
	}

	// 頁面參數存放入傳輸對象
	private CroOutOneConditionDTO setCroOutOneConditionDTO(HttpServletRequest req) {
		CroOutOneConditionDTO cooc = new CroOutOneConditionDTO();

		String logMsgString = "";
		cooc.setType(req.getParameter("radType"));
		logMsgString+="cooc.setType:" + req.getParameter("radType");

		cooc.setBkCode(req.getParameter("txtEBKCD"));
		logMsgString+=",cooc.setBkCode:" + req.getParameter("txtEBKCD");
		cooc.setAccount(req.getParameter("txtEATNO"));
		logMsgString+=",cooc.setAccount:" + req.getParameter("txtEATNO");
		cooc.setCurrency(req.getParameter("txtCURRENCY"));
		logMsgString+=",cooc.setCurrency:" + req.getParameter("txtCURRENCY");

		if (!"".equals(req.getParameter("txtEBKRMD"))) {
			cooc.setRmtDate(Integer.parseInt(req.getParameter("txtEBKRMD")));
			logMsgString+=",cooc.setRmtDate:" + req.getParameter("txtEBKRMD");
		}

		if (!"".equals(req.getParameter("txtENTAMT"))) {
			cooc.setRmtAmt(Double.parseDouble(req.getParameter("txtENTAMT")));
			logMsgString+=",cooc.setRmtAmt:" + req.getParameter("txtENTAMT");
		}

		if (!"".equals(req.getParameter("txtEAEGDT"))) {
			cooc.setAegDate(Integer.parseInt(req.getParameter("txtEAEGDT")));
			logMsgString+=",cooc.setAegDate:" + req.getParameter("txtEAEGDT");
		}
		
		log.info("coocDTO(CroOutOneConditionDTO)設定--> " + logMsgString);
		return cooc;
	}

	private String executeWriteoffs(List<CapcshfDTO> list1, List<CapcshfbVO> list2) throws SQLException 
	{

		String strMsg = "";

		Connection con = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		CapcshfDTO dto1 = null;
		CapcshfbVO dto2 = null;
		int iSeq = 1;

		try 
		{
			con = dbFactory.getAS400Connection("CroOutOneServlet.executeWriteoffs");
			pstmt1 = con.prepareStatement(getUpdateSqlForCAPCSHF());
			pstmt2 = con.prepareStatement(getUpdateSqlForCAPCSHFB());

			for(int i=0; i<list1.size(); i++)
			{
				dto1 = list1.get(i);

				strUpdTime = String.valueOf(commonUtil.getBizDateByRCalendar().getTimeInMillis());
				strUpdTime = strUpdTime.substring(7);
				int iTime = i + Integer.parseInt(strUpdTime);
				if(iTime > 999999) {
					iTime = iTime - 100000;
				}

				//更新登帳檔CAPCSHF-登帳核銷檔資料
				/**
				 * UPDATE CAPCSHF SET 
					EAEGDT=?, //1,全球入帳日
					ECRDAY=?, //2,核銷帳作業日
					CSHFUU=?, //3,資料更新者
					CSHFUD=?, //4,資料更新日期
					CSHFUT=?, //5,資料更新時間
					CSHFPOCURR=?, //6,保單幣別
					CROTYPE=?, //7,資料類別
					EUSREM2=? //8,登帳備註２
					WHERE 
					ECRDAY=0 and //核銷帳作業日
					EBKCD=? AND //9,銀行代碼
					EATNO=? AND //10,銀行帳號
					CSHFCURR=? AND //11,幣別
					EBKRMD=? AND //12,銀行匯款日
					ENTAMT=? AND //13,核銷金額
					CSHFAU=? AND //14,資料產生者
					CSHFAD=? AND //15,資料產生日期
					CSHFAT=? //16,資料產生時間
				 */
				pstmt1.clearParameters();
				String logMsg = "";
				pstmt1.setInt(1, dto1.getEAEGDT());//EAEGDT(全球入帳日)
				logMsg += dto1.getEAEGDT();
				pstmt1.setInt(2, Integer.parseInt(strUpdDate));//ECRDAY(核銷帳作業日)=
				logMsg += "," + Integer.parseInt(strUpdDate);
				pstmt1.setString(3, strLogonUser);//CSHFUU(資料更新者)=
				logMsg += "," + strLogonUser;
				pstmt1.setInt(4, Integer.parseInt(strUpdDate));//CSHFUD(資料更新日期)=
				logMsg += "," + Integer.parseInt(strUpdDate);
				pstmt1.setInt(5, iTime);//CSHFUT(資料更新時間)=
				logMsg += "," + iTime;
				pstmt1.setString(6, dto1.getCSHFPOCURR());//CSHFPOCURR(保單幣別)
				logMsg += "," + dto1.getCSHFPOCURR();
				pstmt1.setString(7, dto1.getCROTYPE());//CROTYPE(資料類別)
				logMsg += "," + dto1.getCROTYPE();
				pstmt1.setString(8, dto1.getEUSREM2());//EUSREM2(登帳備註２)
				logMsg += "," + dto1.getEUSREM2();
				pstmt1.setString(9, dto1.getEBKCD());//EBKCD(銀行代碼)
				logMsg += "," + dto1.getEBKCD();
				pstmt1.setString(10, dto1.getEATNO());//EATNO(CSHFCURR)
				logMsg += "," + dto1.getEATNO();
				pstmt1.setString(11, dto1.getCSHFCURR());//CSHFCURR(幣別)
				logMsg += "," + dto1.getCSHFCURR();
				pstmt1.setInt(12, dto1.getEBKRMD());//EBKRMD(銀行匯款日)
				logMsg += "," + dto1.getEBKRMD();
				pstmt1.setDouble(13, dto1.getENTAMT());//ENTAMT(核銷金額)
				logMsg += "," + dto1.getENTAMT();
				pstmt1.setString(14, dto1.getCSHFAU());//CSHFAU(資料產生者)
				logMsg += "," + dto1.getCSHFAU();
				pstmt1.setInt(15, dto1.getCSHFAD());//CSHFAD(資料產生日期)
				logMsg += "," + dto1.getCSHFAD();
				pstmt1.setInt(16, dto1.getCSHFAT());//CSHFAT(資料產生時間)
				logMsg += "," + dto1.getCSHFAT();
				
				log.info("更新登帳檔CAPCSHF-登帳核銷檔資料:" + getUpdateSqlForCAPCSHF() + "," + logMsg);
				pstmt1.executeUpdate();

				//更新預備核銷檔CAPCSHFB
				/**
				 * UPDATE CAPCSHFB SET 
					CRODAY=?, //1,核銷帳作業日
					CSFBUU=?, //2,資料更新者
					CSFBUD=?, //3,資料更新日期
					CSFBUT=?, //4,資料更新時間
					CSFBPOCURR=?, //5,保單幣別
					CSFBAMTREF=?, //6,參考核銷金額
					CAEGDT=? //7,全球入帳日
					WHERE 
					CRODAY=0 and //核銷帳作業日
					CBKCD=? AND //8,銀行代碼
					CATNO=? AND //9,銀行帳號
					CSFBCURR=? AND //10,幣別
					CBKRMD=? AND //11,銀行匯款日
					CROAMT=? AND //12,核銷金額
					CSFBAU=? AND //13,資料產生者
					CSFBAD=? AND //14,資料產生日期
					CSFBAT=? //15,資料產生時間
				 */
				if(list2.size()==0){
					log.info("list2-[fbData]無值!! 不會update CAPCSHFB及ORGNFBD");
				}
				for(int j=0; j<list2.size(); j++)
				{
					dto2 = list2.get(j);

					if(dto2.getCRODAY() > 0)
						continue;
					if(dto2.getCROAMT() != dto1.getENTAMT())
						continue;

					pstmt2.clearParameters();
					String logMsg2 = "";
					pstmt2.setInt(1, Integer.parseInt(strUpdDate));//CRODAY(核銷帳作業日)=
					logMsg2 += Integer.parseInt(strUpdDate);
					pstmt2.setString(2, strLogonUser);//CSFBUU(資料更新者)=
					logMsg2 += "," + strLogonUser;
					pstmt2.setInt(3, Integer.parseInt(strUpdDate));//CSFBUD(資料更新日期)=
					logMsg2 += "," + Integer.parseInt(strUpdDate);
					pstmt2.setInt(4, Integer.parseInt(strUpdTime));//CSFBUT(資料更新時間)=
					logMsg2 += "," + Integer.parseInt(strUpdTime);
					pstmt2.setString(5, dto1.getCSHFPOCURR());//CSFBPOCURR(保單幣別)
					logMsg2 += "," + dto1.getCSHFPOCURR();
					pstmt2.setDouble(6, dto1.getENTAMT());//CSFBAMTREF(參考核銷金額)
					logMsg2 += "," + dto1.getENTAMT();
					pstmt2.setInt(7, dto1.getEAEGDT());//CAEGDT(全球入帳日)
					logMsg2 += "," + dto1.getEAEGDT();
					pstmt2.setString(8, dto2.getCBKCD());//CBKCD(銀行代碼)=
					logMsg2 += "," + dto2.getCBKCD();
					pstmt2.setString(9, dto2.getCATNO());//CATNO(銀行帳號)=
					logMsg2 += "," + dto2.getCATNO();
					pstmt2.setString(10, dto2.getCCURR());//CSFBCURR(幣別)=
					logMsg2 += "," + dto2.getCCURR();
					pstmt2.setInt(11, dto2.getCBKRMD());//CBKRMD(銀行匯款日)=
					logMsg2 += "," + dto2.getCBKRMD();
					pstmt2.setDouble(12, dto2.getCROAMT());//CROAMT(核銷金額)=
					logMsg2 += "," + dto2.getCROAMT();
					pstmt2.setString(13, dto2.getCSFBAU());//CSFBAU(資料產生者)=
					logMsg2 += "," + dto2.getCSFBAU();
					pstmt2.setInt(14, dto2.getCSFBAD());//CSFBAD(資料產生日期)=
					logMsg2 += "," + dto2.getCSFBAD();
					pstmt2.setInt(15, dto2.getCSFBAT());//CSFBAT(資料產生時間)=
					logMsg2 += "," + dto2.getCSFBAT();
					
					log.info("更新預備核銷檔CAPCSHFB:" + getUpdateSqlForCAPCSHFB() + "," + logMsg2);
					pstmt2.executeUpdate();

					//更新憑證明細檔ORGNFBD, RCPP入帳憑証關聯明細檔
					/**
					 * UPDATE ORGNFBD //RCPP入帳憑証關聯明細檔
						SET FBDSEQ=? //憑証流水號
						WHERE 
						FBDREPNO=? and //送金單
						FBDREPSEQ=? //送金單序號
					 */
					pstmt2.clearParameters();
					String logMsg3 = "";
					pstmt2 = con.prepareStatement(getUpdateSqlForORGNFBD());
					pstmt2.setInt(1, iSeq);
					logMsg3 += iSeq;
					pstmt2.setString(2, dto2.getCSFBRECTNO());
					logMsg3 += "," + dto2.getCSFBRECTNO();
					pstmt2.setInt(3, dto2.getCSFBRECSEQ());
					logMsg3 += "," + dto2.getCSFBRECSEQ();
					
					log.info("更新憑證明細檔ORGNFBD:" + getUpdateSqlForORGNFBD() + "," + logMsg3);
					pstmt2.executeUpdate();
					iSeq++;

					break;
				} 
			}

			strMsg = "執行銷帳完成!!";

		} catch (SQLException e) {
			strMsg = "執行銷帳發生異常錯誤!!";
			throw e;
		} finally {
			if(pstmt2 != null) pstmt2.close();
			if(pstmt1 != null) pstmt1.close();
			if(con != null) dbFactory.releaseAS400Connection(con);
		}

		return strMsg;
	}

	//更新預備核銷檔CAPCSHFB
	private String getUpdateSqlForCAPCSHFB() {
		String strSqlFB = " UPDATE CAPCSHFB SET CRODAY=?,CSFBUU=?,CSFBUD=?,CSFBUT=?,CSFBPOCURR=?,CSFBAMTREF=?,CAEGDT=? "
							+ "WHERE CRODAY=0 and CBKCD=? AND CATNO=? AND CSFBCURR=? AND CBKRMD=? AND CROAMT=? AND CSFBAU=? AND CSFBAD=? AND CSFBAT=? ";
		return strSqlFB;
	}

	//更新登帳檔CAPCSHF
	private String getUpdateSqlForCAPCSHF() {
		String strSqlF = " UPDATE CAPCSHF SET EAEGDT=?,ECRDAY=?,CSHFUU=?,CSHFUD=?,CSHFUT=?,CSHFPOCURR=?,CROTYPE=?,EUSREM2=? "
							+ "WHERE ECRDAY=0 and EBKCD=? AND EATNO=? AND CSHFCURR=? AND EBKRMD=? AND ENTAMT=? AND CSHFAU=? AND CSHFAD=? AND CSHFAT=? ";
		return strSqlF;
	}

	//更新登帳檔ORGNFBD
	private String getUpdateSqlForORGNFBD() {
		String strSqlD = "UPDATE ORGNFBD SET FBDSEQ=? WHERE FBDREPNO=? and FBDREPSEQ=? ";
		return strSqlD;
	}

	private List<CapcshfDTO> getRequestData(HttpServletRequest req, List<CapcshfDTO> orgData) {
		List<CapcshfDTO> list = new ArrayList<CapcshfDTO>();

		CapcshfDTO dto = null;

		String strChecked = "";

		if(orgData != null)
		{
			for(int i=0; i<orgData.size(); i++)
			{
				strChecked = (req.getParameter("ch"+i) != null)?CommonUtil.AllTrim(req.getParameter("ch"+i)):"";
				if(strChecked.equals("Y")) {
					String logMsg = "";
					dto = orgData.get(i);
					dto.setEBKCD(req.getParameter("txtBKCODE"+i));//1
					logMsg+="dto.setEBKCD:" + req.getParameter("txtBKCODE"+i);
					dto.setEATNO(req.getParameter("txtBKACNT"+i));//2
					logMsg+=",dto.setEATNO:" + req.getParameter("txtBKACNT"+i);
					dto.setEBKRMD(Integer.parseInt(req.getParameter("txtRMDT"+i)));//3
					logMsg+=",dto.setEBKRMD:" + req.getParameter("txtRMDT"+i);
					dto.setEAEGDT(Integer.parseInt(req.getParameter("txtEAEGDT"+i)));//4
					logMsg+=",dto.setEAEGDT:" + req.getParameter("txtEAEGDT"+i);
					dto.setENTAMT(Double.parseDouble(req.getParameter("txtMAMT"+i)));//5
					logMsg+=",dto.setENTAMT:" + req.getParameter("txtMAMT"+i);
					if(req.getParameter("EN"+i) != null){
						dto.setEUSREM2(req.getParameter("EN"+i));//6
						logMsg+=",dto.setEUSREM2:" + req.getParameter("EN"+i);
					}						

					dto.setCROTYPE(req.getParameter("txtCroType"));//7
					logMsg+=",dto.setCROTYPE:" + req.getParameter("txtCroType");
					
					if(req.getParameter("txtPoCurr") != null && !req.getParameter("txtPoCurr").equals("")){
						dto.setCSHFPOCURR(req.getParameter("txtPoCurr"));//8
						logMsg+=",dto.setCSHFPOCURR:" + req.getParameter("txtPoCurr");
					}

					log.info("dto(CapcshfDTO)是" + logMsg);
					list.add(dto);
				}
			}
		}

		return list;
	}

	// 取消核銷
	private String cancelWriteoffs(HttpServletRequest req, CapcshfDTO dto, List<CapcshfbVO> list) throws SQLException {
		String strMsg = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		CapcshfbVO fbdto = null;

		String strSqlF1= "UPDATE CAPCSHF SET EAEGDT=0, ECRDAY=0, CSHFUU=?, CSHFUD=?, CSHFUT=0 WHERE EBKCD=? and EATNO=? and EBKRMD=? and ENTAMT=? and CSHFAU=? and CSHFAD=? and CSHFAT=? ";
		String strSqlFB = "UPDATE CAPCSHFB SET CRODAY=0, CSFBAMTREF=0, CSFBUU=?, CSFBUD=?, CSFBUT=0 WHERE CBKCD=? and CATNO=? and CBKRMD=? and CROAMT=? and CSFBAU=? and CSFBAD=? and CSFBAT=? ";

		try {
			con = dbFactory.getAS400Connection("CroOutOneServlet.cancelWriteoffs");
			pstmt = con.prepareStatement(strSqlF1);
			pstmt.setString(1, strLogonUser);
			pstmt.setString(2, strUpdDate);
			pstmt.setString(3, req.getParameter("txtBKCODE"));
			pstmt.setString(4, req.getParameter("txtBKACNT"));
			pstmt.setString(5, req.getParameter("txtRMDT"));
			pstmt.setDouble(6, dto.getENTAMT());
			pstmt.setString(7, dto.getCSHFAU());
			pstmt.setInt(8, dto.getCSHFAD());
			pstmt.setInt(9, dto.getCSHFAT());
			pstmt.executeUpdate();

			if(list != null) {
				for(int i=0; i<list.size(); i++) {
					fbdto = (CapcshfbVO) list.get(i);

					if(fbdto.getCRODAY() > 0)
						continue;
					if(fbdto.getCROAMT() != dto.getENTAMT())
						continue;

					pstmt.clearParameters();
					pstmt = con.prepareStatement(strSqlFB);
					pstmt.setString(1, strLogonUser);
					pstmt.setString(2, strUpdDate);
					pstmt.setString(3, req.getParameter("txtBKCODE"));
					pstmt.setString(4, req.getParameter("txtBKACNT"));
					pstmt.setString(5, req.getParameter("txtRMDT"));
					pstmt.setDouble(6, fbdto.getCROAMT());
					pstmt.setString(7, fbdto.getCSFBAU());
					pstmt.setInt(8, fbdto.getCSFBAD());
					pstmt.setInt(9, fbdto.getCSFBAT());
					pstmt.executeUpdate();

					pstmt.clearParameters();
					pstmt = con.prepareStatement(getUpdateSqlForORGNFBD());
					pstmt.setInt(1, 0);
					pstmt.setString(2, fbdto.getCSFBRECTNO());
					pstmt.setInt(3, fbdto.getCSFBRECSEQ());
					pstmt.executeUpdate();

					break;
				}
			}

			strMsg = "取消銷帳完成!!";

		} catch (SQLException e) {
			strMsg = "執行取消發生異常錯誤!!";
			throw e;
		} finally {
			if (pstmt != null) pstmt.close();
			if (con != null) dbFactory.releaseAS400Connection(con);
		}

		return strMsg;
	}

}
