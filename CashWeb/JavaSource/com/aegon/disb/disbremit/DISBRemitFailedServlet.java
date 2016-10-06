package com.aegon.disb.disbremit;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.GlobalEnviron;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.LapsePaymentVO;
import org.apache.log4j.Logger;

/**
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.16 $$
 * 
 * Author   : Vicky Hsu
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBRemitFailedServlet.java,v $
 * $Revision 1.16  2013/11/08 05:52:33  MISSALLY
 * $EB0194-PB0016-BC255利率變動型即期年金保險專案
 * $
 * $Revision 1.15.1.2  2013/08/09 09:21:32  MISSALLY
 * $QB0216 美元保單退匯扣除退匯手續費問題
 * $
 * $Revision 1.15.1.1  2013/07/19 08:22:43  MISSALLY
 * $EB0070 - 人民幣投資型年金商品
 * $
 * $Revision 1.15  2013/05/02 11:07:05  MISSALLY
 * $R10190 美元失效保單作業
 * $
 * $Revision 1.14  2013/02/27 05:35:33  ODCZheJun
 * $R10190 美元傳統型保單失效作業
 * $
 * $Revision 1.13  2013/01/08 04:24:03  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.12.4.1  2012/12/06 06:28:27  MISSALLY
 * $RA0102　PA0041
 * $配合法令修改酬佣支付作業
 * $
 * $Revision 1.12  2012/06/22 04:09:57  MISSALLY
 * $QA0215---執行退匯作業未將理賠編號帶入新支付資料
 * $
 * $Revision 1.11  2012/05/23 01:21:44  MISSALLY
 * $R10314 CASH系統會計作業修改-修正理賠付款金額的判斷
 * $
 * $Revision 1.10  2012/05/18 09:47:37  MISSALLY
 * $R10314 CASH系統會計作業修改
 * $
 * $Revision 1.9  2011/06/02 10:28:09  MISSALLY
 * $Q90585 / R90884 / R90989
 * $CASH系統匯退處理作業新增匯退原因欄位並修正退匯明細表
 * $
 * $Revision 1.8  2010/11/23 06:50:41  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.7  2008/11/18 02:24:01  MISODIN
 * $R80824
 * $
 * $Revision 1.6  2008/08/06 05:58:09  MISODIN
 * $R80132 調整CASH系統for 6種幣別
 * $
 * $Revision 1.5  2008/06/06 03:33:39  misvanessa
 * $R80391_請新增CASH系統信用卡退回
 * $
 * $Revision 1.4  2007/10/04 01:39:20  MISODIN
 * $R70477 外幣保單匯款手續費
 * $
 * $Revision 1.3  2007/01/04 03:16:32  MISVANESSA
 * $R60550_匯退規則修改
 * $
 * $Revision 1.2  2006/11/30 09:15:52  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.17  2006/04/27 09:25:45  misangel
 * $R50891:VA美元保單-顯示幣別
 * $
 * $Revision 1.1.2.16  2005/12/08 02:00:16  misangel
 * $R50727:團險資料入支付系統(新增部門:團險行政/團險理賠)
 * $
 * $Revision 1.1.2.15  2005/11/25 06:46:11  misangel
 * $R50727:團險資料入支付系統
 * $
 * $Revision 1.1.2.14  2005/09/05 07:14:49  misangel
 * $R50736:匯退處理含信用卡件
 * $
 * $Revision 1.1.2.13  2005/08/19 06:56:18  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併
 * $
 * $Revision 1.1.2.12  2005/06/15 04:19:17  MISANGEL
 * $R30530:匯退同時新增CAPPAYRF
 * $
 * $Revision 1.1.2.11  2005/04/28 08:56:26  miselsa
 * $R30530平行測試的修改
 * $
 * $Revision 1.1.2.10  2005/04/25 07:23:52  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.9  2005/04/22 01:56:35  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.8  2005/04/21 05:48:45  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.7  2005/04/04 07:02:27  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBRemitFailedServlet extends HttpServlet {
	
	private Logger log = Logger.getLogger(getClass());

	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private DISBBean disbBean = null;
	private boolean isAEGON400 = false;

	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON) != null) {
			globalEnviron = (GlobalEnviron) getServletContext().getAttribute(Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
		}

		if (globalEnviron.getActiveAS400DataSource().equals(Constant.AS400_DATA_SOURCE_NAME_AEGON400)) {
			isAEGON400 = true;
		}

		//R00393 
		commonUtil = new CommonUtil(globalEnviron);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String strAction = "";
		strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = strAction.trim();
		else
			strAction = "";
		log.info("strAction:" + strAction);
		try {
			if (strAction.equals("I"))
				inquiryDB(request, response);
			else if(strAction.equals("U"))
				inquiryDB4Update(request, response);
			else if (strAction.equals("DISBRemitFailed"))
				updateRemitFailed(request, response);
			else if (strAction.equals("DISBRemitFailedModify"))
				modifyRemitFailed(request, response);
			else if(strAction.equals("DISBRemitFailedInquiry"))
				inquiryRemitFailed(request, response);
			else
				System.out.println("Hello, that's not a valid UseCase!");
		} catch (Exception e) {
			System.out.println("Application Exception >>> " + e);
		}
	}

	private void inquiryDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; //SQL String

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* 接收前端欄位定義 */
		int iPDate = 0;
		String strPDate = "";	//付款日期
		String strPBBank = "";	//付款銀行
		String strPBAccount = ""; //付款帳號
		String strAMT = "";		//金額
		String strName = "";	//姓名	
		String strCurrency = "";//幣別
		String strRemitway = "";//R60550匯退方式
		String strPCSHCM = "";	//R80391出納確認日
		int iPCSHCM = 0;		//R80391出納確認日
		String strBRDate = "" ;//R10134 銀行退匯回存日期
		String company = ""; //RD0382:OIU

		//R60550
		String strFEECURR = "";
		strFEECURR = request.getParameter("txtFEECURR");
		if (strFEECURR != null)
			strFEECURR = strFEECURR.trim();
		else
			strFEECURR = "";

		strPDate = request.getParameter("txtPDate");
		if (strPDate != null)
			strPDate = strPDate.trim();
		else
			strPDate = "";
		if (!strPDate.equals(""))
			iPDate = Integer.parseInt(strPDate);

		//R80391出納確認日
		strPCSHCM = request.getParameter("txtPCSHCM");
		if (strPCSHCM != null)
			strPCSHCM = strPCSHCM.trim();
		else
			strPCSHCM = "";
		if (!strPCSHCM.equals(""))
			iPCSHCM = Integer.parseInt(strPCSHCM);

		strPBBank = request.getParameter("txtPBBank");
		if (strPBBank != null)
			strPBBank = strPBBank.trim();
		else
			strPBBank = "";

		strPBAccount = request.getParameter("txtPBAccount");
		if (strPBAccount != null)
			strPBAccount = strPBAccount.trim();
		else
			strPBAccount = "";

		strAMT = request.getParameter("txtAMT");
		if (strAMT != null)
			strAMT = strAMT.trim();
		else
			strAMT = "";

		strName = request.getParameter("txtNAME");
		if (strName != null)
			strName = strName.trim();
		else
			strName = "";

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";

		strRemitway = request.getParameter("selFEESHOW");
		if (strRemitway != null)
			strRemitway = strRemitway.trim();
		else
			strRemitway = "";
			
		//R10134
		strBRDate = request.getParameter("txtBRDate")!=null?request.getParameter("txtBRDate").trim():"";
		
		//R80132
		if (strRemitway.equals("NT")) {
			strPBBank = request.getParameter("txtPBBankP");
			if (strPBBank != null) {
				strPBBank = strPBBank.trim();
			} else {
				strPBBank = "";
			}

			strPBAccount = request.getParameter("txtPBAccountP");
			if (strPBAccount != null) {
				strPBAccount = strPBAccount.trim();
			} else {
				strPBAccount = "";
			}
		}
		if (strRemitway.equals("US")) {
			strPBBank = request.getParameter("txtPBBankD");
			if (strPBBank != null) {
				strPBBank = strPBBank.trim();
			} else {
				strPBBank = "";
			}

			strPBAccount = request.getParameter("txtPBAccountD");
			if (strPBAccount != null) {
				strPBAccount = strPBAccount.trim();
			} else {
				strPBAccount = "";
			}
		}
		
		//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}

		strSql = "select A.PNO,A.PNOH,A.PAMT,A.PSNAME,A.PDATE,A.PNAME,A.PID,A.PCURR,A.PMETHOD,A.PDESC";
		strSql += ",A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.PBACCOUNT,A.PBBANK,A.PRACCOUNT";
		strSql += ",A.PRBANK,A.APPNO,A.POLICYNO,A.BRANCH,A.RMTFEE,A.MEMO,A.ENTRYPGM,A.PPLANT,A.ENTRYUSR";
		strSql += ",A.BATSEQ,A.PPAYCURR,A.PPAYAMT,A.PPAYRATE,A.PINVDT,A.PSYMBOL,A.PSWIFT,A.PBKCOTRY";
		strSql += ",A.PBKCITY,A.PBKBRCH,A.PENGNAME,A.PFEEWAY,A.PBATNO, A.PCRDNO, B.RAMT,A.PMETHODO";
		strSql += ",A.PAMTNT,A.PORGAMT,A.PORGCRDNO,A.PROJECTCD,A.REMITFAILD,A.REMITFAILT,A.REMITFCODE";
		strSql += ",A.REMITFDESC,A.PCLMNUM,SRVBH,ANNPDATE ";
		strSql += " from CAPPAYF A ";
		strSql += " LEFT JOIN CAPRMTF B ON A.PBATNO=B.BATNO AND A.BATSEQ=B.SEQNO ";
		strSql += " WHERE A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  ";
		strSql += " and A.PCFMDT2<>0 AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>''  ";
		strSql += " AND A.PCSHDT <> 0 AND A.PSTATUS='B' ";

		if (strRemitway.equals("US")) {
			strSql += " AND A.PMETHOD ='D'";
		} else if (strRemitway.equals("C")) {
			strSql += " AND A.PBBANK='" + strPBBank + "' AND A.PBACCOUNT='" + strPBAccount + "' ";
			strSql += " AND A.PMETHOD ='C'";
		} else {
			strSql += " AND A.PBBANK='" + strPBBank + "' AND A.PBACCOUNT='" + strPBAccount + "' ";
			strSql += " AND A.PMETHOD ='B'";
		}

		if (!strPDate.equals(""))
			strSql += " and A.PDATE <= " + iPDate;

		if (!strPCSHCM.equals("")) //R80391
			strSql += " and A.PCSHCM = " + iPCSHCM;

		if (!strAMT.equals(""))
			strSql += " AND A.PAMT = " + Double.parseDouble(strAMT);

		if (!strName.equals(""))
			strSql += " AND A.PNAME LIKE '%" + strName + "%'";

		if (!strCurrency.equals(""))
			strSql += " AND A.PCURR = '" + strCurrency + "'";
		
		//RD0382:OIU
		if("6".equals(company)){
			strSql += " AND A.PAY_COMPANY = 'OIU' ";
		}else if("0".equals(company)){
			strSql += " AND A.PAY_COMPANY <> 'OIU' ";
		}

		strSql += "	ORDER BY A.PAMT ";

		System.out.println(" inside DISBRemitFailedServlet.inquiryDB()--> strSql =" + strSql);
		log.info(" inside DISBRemitFailedServlet.inquiryDB()--> strSql =" + strSql);
		try {
			con = dbFactory.getAS400Connection("DISBPMaintainServlet.inqueryDB()");
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rs.getString("PNO"));	//支付序號
				if (rs.getString("PNOH").trim().equals("")) {	//要記錄第一次的支付序號
					objPDetailVO.setStrPNoH(rs.getString("PNO")); //原支付序號
				} else {
					objPDetailVO.setStrPNoH(rs.getString("PNOH"));//原支付序號
				}
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	//支付金額	
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		//付款日期
				objPDetailVO.setStrPName(rs.getString("PNAME"));//付款人姓名
				objPDetailVO.setStrPSName(rs.getString("PSNAME")); //付款人原始姓名
				objPDetailVO.setStrPId(rs.getString("PID"));	//付款人ID
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));//幣別
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD")); //付款方式
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));	 //支付描述
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));	 //來源組群
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE")); //支付原因代碼					
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS")); //付款狀態
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));//作廢否
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));//急件否
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));//付款銀行
				objPDetailVO.setStrPBBank(rs.getString("PBBANK"));		//付款帳號
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));//匯款帳號
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));		//匯款銀行
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));		//要保書號碼
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	//保單號碼
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		//保單所屬單位
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));			//匯費(手續費)
				objPDetailVO.setStrMemo(rs.getString("MEMO"));			//備註
				objPDetailVO.setStrEntryPgm(rs.getString("ENTRYPGM"));	//輸入程式
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));		//險種類別
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));	//輸入者
				objPDetailVO.setStrBATSEQ(rs.getString("BATSEQ"));		//匯款序號
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));	//R60550匯出幣別
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));		//R60550匯出金額
				objPDetailVO.setIPPAYRATE(rs.getDouble("PPAYRATE"));	//R60550匯出匯率
				objPDetailVO.setIPINVDT(rs.getInt("PINVDT"));			//R60550投資起始日
				objPDetailVO.setStrPSYMBOL(rs.getString("PSYMBOL"));	//R60550SPUL註記
				objPDetailVO.setStrPSWIFT(rs.getString("PSWIFT"));		//R60550SWIFT
				objPDetailVO.setStrPBKCOTRY(rs.getString("PBKCOTRY"));	//R60550受款國別
				objPDetailVO.setStrPBKCITY(rs.getString("PBKCITY"));	//R60550受款銀行城市
				objPDetailVO.setStrPBKBRCH(rs.getString("PBKBRCH"));	//R60550受款銀行分行
				objPDetailVO.setStrPENGNAME(rs.getString("PENGNAME"));	//R60550英文姓名
				objPDetailVO.setStrPFEEWAY(rs.getString("PFEEWAY"));	//R60550付款方式
				objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO"));		//R80391 信用卡號
				objPDetailVO.setIRAMT(rs.getDouble("RAMT"));			//R80391匯款金額CAPRMTF
				objPDetailVO.setStrPMETHODO(rs.getString("PMETHODO"));	//R70600 原始支付方式
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));		//R70600 支付金額台幣參考
				objPDetailVO.setIPOrgAMT(rs.getDouble("PORGAMT"));		//R80824 原刷金額
				objPDetailVO.setStrPOrgCrdNo(rs.getString("PORGCRDNO"));//R80824 原始卡號
				objPDetailVO.setStrProjectCode(rs.getString("PROJECTCD"));//R80824 專案碼
				objPDetailVO.setRemitFailDate(rs.getInt("REMITFAILD"));		//R90884 退匯日期
				objPDetailVO.setRemitFailTime(rs.getInt("REMITFAILT"));		//R90884 退匯時間
				objPDetailVO.setRemitFailCode(rs.getString("REMITFCODE"));	//R90884 退匯代碼
				objPDetailVO.setRemitFailDesc(rs.getString("REMITFDESC"));	//R90884 退匯原因
				objPDetailVO.setClaimNumber(rs.getString("PCLMNUM"));		//理賠編號
				objPDetailVO.setServicingBranch(rs.getString("SRVBH"));
				objPDetailVO.setAnnuityPayDate(rs.getInt("ANNPDATE"));

				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "查無相關資料");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alPDetail = null;
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception ex1) {}
			try { if (stmt != null) stmt.close(); } catch (Exception ex1) {}
			try { if (con != null) dbFactory.releaseAS400Connection(con); } catch (Exception ex1) {}
		}

		request.setAttribute("txtAction", "I");
		request.setAttribute("txtFEECURR", strFEECURR); //R60550
		request.setAttribute("txtWAYSHOW", strRemitway); //R80391
		request.setAttribute("txtBRemitFailDate",strBRDate);//R10314
		dispatcher = request.getRequestDispatcher("/DISB/DISBRemit/DISBRemitFailed.jsp");
		dispatcher.forward(request, response);
	}

	private void inquiryDB4Update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; //SQL String

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* 接收前端欄位定義 */
		int iPDate = 0;
		String strPDate = "";	//付款日期
		String strPBBank = "";	//付款銀行
		String strPBAccount = ""; //付款帳號
		String strAMT = "";		//金額
		String strName = "";	//姓名	
		String strCurrency = "";//幣別
		String strRemitway = "";//匯退方式
		int iRemitFailDate = 0;		//退匯日期
		String strRemitFailDate = "";	//退匯日期

		strPDate = request.getParameter("txtPDate");
		if (strPDate != null)
			strPDate = strPDate.trim();
		else
			strPDate = "";
		if (!strPDate.equals(""))
			iPDate = Integer.parseInt(strPDate);

		strPBBank = request.getParameter("txtPBBank");
		if (strPBBank != null)
			strPBBank = strPBBank.trim();
		else
			strPBBank = "";

		strPBAccount = request.getParameter("txtPBAccount");
		if (strPBAccount != null)
			strPBAccount = strPBAccount.trim();
		else
			strPBAccount = "";

		strAMT = request.getParameter("txtAMT");
		if (strAMT != null)
			strAMT = strAMT.trim();
		else
			strAMT = "";

		strName = request.getParameter("txtNAME");
		if (strName != null)
			strName = strName.trim();
		else
			strName = "";

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";

		strRemitway = request.getParameter("selFEESHOW");
		if (strRemitway != null)
			strRemitway = strRemitway.trim();
		else
			strRemitway = "";
		if (strRemitway.equals("NT")) {
			strPBBank = request.getParameter("txtPBBankP");
			if (strPBBank != null) {
				strPBBank = strPBBank.trim();
			} else {
				strPBBank = "";
			}

			strPBAccount = request.getParameter("txtPBAccountP");
			if (strPBAccount != null) {
				strPBAccount = strPBAccount.trim();
			} else {
				strPBAccount = "";
			}
		}
		if (strRemitway.equals("US")) {
			strPBBank = request.getParameter("txtPBBankD");
			if (strPBBank != null) {
				strPBBank = strPBBank.trim();
			} else {
				strPBBank = "";
			}

			strPBAccount = request.getParameter("txtPBAccountD");
			if (strPBAccount != null) {
				strPBAccount = strPBAccount.trim();
			} else {
				strPBAccount = "";
			}
		}

		//退匯日期 R10314
		strRemitFailDate = request.getParameter("txtRDate");
		if (strRemitFailDate != null)
			strRemitFailDate = strRemitFailDate.trim();
		else
			strRemitFailDate = "";
		if (!strRemitFailDate.equals(""))
			iRemitFailDate = Integer.parseInt(strRemitFailDate);
		
		//R10134
		String strBRemitFaiDate = "";
		strBRemitFaiDate = request.getParameter("txtBRDate")!=null?request.getParameter("txtBRDate").trim():"";

		strSql = "select A.PNO,A.PNOH,A.PAMT,A.PSNAME,A.PDATE,A.PNAME,A.PID,A.PCURR,A.PMETHOD,A.PDESC";
		strSql += ",A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.PBACCOUNT,A.PBBANK,A.PRACCOUNT";
		strSql += ",A.PRBANK,A.APPNO,A.POLICYNO,A.BRANCH,A.RMTFEE,A.MEMO,A.ENTRYPGM,A.PPLANT,A.ENTRYUSR";
		strSql += ",A.BATSEQ,A.PPAYCURR,A.PPAYAMT,A.PPAYRATE,A.PINVDT,A.PSYMBOL,A.PSWIFT,A.PBKCOTRY";
		strSql += ",A.PBKCITY,A.PBKBRCH,A.PENGNAME,A.PFEEWAY,A.PBATNO,A.PCRDNO,B.RAMT,A.PMETHODO,A.PAMTNT";
		strSql += ",A.PORGAMT,A.PORGCRDNO,A.PROJECTCD,A.REMITFAILD,A.REMITFAILT,A.REMITFCODE,A.REMITFDESC,A.PCLMNUM,SRVBH,ANNPDATE ";
		strSql += " from CAPPAYF A ";
		strSql += " LEFT JOIN CAPRMTF B ON A.PBATNO=B.BATNO AND A.BATSEQ=B.SEQNO "; 				
		strSql += " WHERE A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  ";
		strSql += "   AND A.PCFMDT2<>0 AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>''  ";
		strSql += "   AND A.PCSHDT <> 0 AND A.PSTATUS='A'";

		if (strRemitway.equals("US")) {
			strSql += " AND A.PMETHOD ='D'";
		} else if (strRemitway.equals("C")) {
			strSql += " AND A.PMETHOD ='C'";
		} else {
			strSql += " AND A.PBBANK='" + strPBBank + "' AND A.PBACCOUNT='" + strPBAccount + "' ";
			strSql += " AND A.PMETHOD ='B'";
		}

		if (!strPDate.equals(""))
			strSql += " AND A.PDATE <= " + iPDate;

		if (!strAMT.equals(""))
			strSql += " AND A.PAMT = " + Double.parseDouble(strAMT);

		if (!strName.equals(""))
			strSql += " AND A.PNAME LIKE '%" + strName + "%'";

		if (!strCurrency.equals(""))
			strSql += " AND A.PCURR = '" + strCurrency + "'";

		if(!strRemitFailDate.equals(""))
			strSql += " AND A.REMITFAILD=" + iRemitFailDate;
		
		//R10314
		if(!strBRemitFaiDate.equals(""))
			strSql += " AND A.PBNKRFDT=" + strBRemitFaiDate;

		strSql += "	ORDER BY A.PAMT ";

		System.out.println(" inside DISBRemitFailedServlet.inquiryDB4Update()--> strSql =" + strSql);

		try {
			con = dbFactory.getAS400Connection("DISBPMaintainServlet.inquiryDB4Update()");
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rs.getString("PNO"));	//支付序號
				if (rs.getString("PNOH").trim().equals("")) {	//要記錄第一次的支付序號
					objPDetailVO.setStrPNoH(rs.getString("PNO")); //原支付序號
				} else {
					objPDetailVO.setStrPNoH(rs.getString("PNOH"));//原支付序號
				}
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	//支付金額	
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		//付款日期
				objPDetailVO.setStrPName(rs.getString("PNAME"));//付款人姓名
				objPDetailVO.setStrPSName(rs.getString("PSNAME")); //付款人原始姓名
				objPDetailVO.setStrPId(rs.getString("PID"));	//付款人ID
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));//幣別
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD")); //付款方式
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));	 //支付描述
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));	 //來源組群
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE")); //支付原因代碼					
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS")); //付款狀態
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));//作廢否
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));//急件否
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));//付款銀行
				objPDetailVO.setStrPBBank(rs.getString("PBBANK"));		//付款帳號
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));//匯款帳號
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));		//匯款銀行
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));		//要保書號碼
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	//保單號碼
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		//保單所屬單位
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));			//匯費(手續費)
				objPDetailVO.setStrMemo(rs.getString("MEMO"));			//備註
				objPDetailVO.setStrEntryPgm(rs.getString("ENTRYPGM"));	//輸入程式
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));		//險種類別
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));	//輸入者
				objPDetailVO.setStrBATSEQ(rs.getString("BATSEQ"));		//匯款序號
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));	//匯出幣別
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));		//匯出金額
				objPDetailVO.setIPPAYRATE(rs.getDouble("PPAYRATE"));	//匯出匯率
				objPDetailVO.setIPINVDT(rs.getInt("PINVDT"));			//投資起始日
				objPDetailVO.setStrPSYMBOL(rs.getString("PSYMBOL"));	//SPUL註記
				objPDetailVO.setStrPSWIFT(rs.getString("PSWIFT"));		//SWIFT
				objPDetailVO.setStrPBKCOTRY(rs.getString("PBKCOTRY"));	//受款國別
				objPDetailVO.setStrPBKCITY(rs.getString("PBKCITY"));	//受款銀行城市
				objPDetailVO.setStrPBKBRCH(rs.getString("PBKBRCH"));	//受款銀行分行
				objPDetailVO.setStrPENGNAME(rs.getString("PENGNAME"));	//英文姓名
				objPDetailVO.setStrPFEEWAY(rs.getString("PFEEWAY"));	//付款方式
				objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO"));		//信用卡號
				objPDetailVO.setIRAMT(rs.getDouble("RAMT"));			//匯款金額CAPRMTF
				objPDetailVO.setStrPMETHODO(rs.getString("PMETHODO"));	//原始支付方式
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));		//支付金額台幣參考
				objPDetailVO.setIPOrgAMT(rs.getDouble("PORGAMT"));		//原刷金額
				objPDetailVO.setStrPOrgCrdNo(rs.getString("PORGCRDNO"));//原始卡號
				objPDetailVO.setStrProjectCode(rs.getString("PROJECTCD"));//專案碼
				objPDetailVO.setRemitFailDate(rs.getInt("REMITFAILD"));		//R90884 退匯日期
				objPDetailVO.setRemitFailTime(rs.getInt("REMITFAILT"));		//R90884 退匯時間
				objPDetailVO.setRemitFailCode(rs.getString("REMITFCODE"));	//R90884 退匯代碼
				objPDetailVO.setRemitFailDesc(rs.getString("REMITFDESC"));	//R90884 退匯原因
				objPDetailVO.setClaimNumber(rs.getString("PCLMNUM"));		//理賠編號
				objPDetailVO.setServicingBranch(rs.getString("SRVBH"));
				objPDetailVO.setAnnuityPayDate(rs.getInt("ANNPDATE"));

				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "資料不存在，請重新輸入正確資料。如果是新增的退匯，請在『支付功能─退匯處理』新增此筆退匯資料。");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alPDetail = null;
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception ex1) {}
			try { if (stmt != null) stmt.close(); } catch (Exception ex1) {}
			try { if (con != null) dbFactory.releaseAS400Connection(con); } catch (Exception ex1) {}
		}

		request.setAttribute("txtAction", "U");
		request.setAttribute("txtRemitFailDate", strRemitFailDate);
		request.setAttribute("txtBRemitFailDate",strBRemitFaiDate);//R10314
		dispatcher = request.getRequestDispatcher("/DISB/DISBRemit/DISBRemitFailedMaintain.jsp");
		dispatcher.forward(request, response);
	}

	private void inquiryRemitFailed(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; //SQL String

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* 接收前端欄位定義 */
		int iPDate = 0;
		String strPDate = "";	//付款日期
		String strPBBank = "";	//付款銀行
		String strPBAccount = ""; //付款帳號
		String strAMT = "";		//金額
		String strName = "";	//姓名	
		String strCurrency = "";//幣別
		String strRemitway = "";//匯退方式
		int iRemitFailDate = 0;		//退匯日期
		String strRemitFailDate = "";	//退匯日期

		strPDate = request.getParameter("txtPDate");
		if (strPDate != null)
			strPDate = strPDate.trim();
		else
			strPDate = "";
		if (!strPDate.equals(""))
			iPDate = Integer.parseInt(strPDate);

		strPBBank = request.getParameter("txtPBBank");
		if (strPBBank != null)
			strPBBank = strPBBank.trim();
		else
			strPBBank = "";

		strPBAccount = request.getParameter("txtPBAccount");
		if (strPBAccount != null)
			strPBAccount = strPBAccount.trim();
		else
			strPBAccount = "";

		strAMT = request.getParameter("txtAMT");
		if (strAMT != null)
			strAMT = strAMT.trim();
		else
			strAMT = "";

		strName = request.getParameter("txtNAME");
		if (strName != null)
			strName = strName.trim();
		else
			strName = "";

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";

		strRemitway = request.getParameter("selFEESHOW");
		if (strRemitway != null)
			strRemitway = strRemitway.trim();
		else
			strRemitway = "";
		if (strRemitway.equals("NT")) {
			strPBBank = request.getParameter("txtPBBankP");
			if (strPBBank != null) {
				strPBBank = strPBBank.trim();
			} else {
				strPBBank = "";
			}

			strPBAccount = request.getParameter("txtPBAccountP");
			if (strPBAccount != null) {
				strPBAccount = strPBAccount.trim();
			} else {
				strPBAccount = "";
			}
		}
		if (strRemitway.equals("US")) {
			strPBBank = request.getParameter("txtPBBankD");
			if (strPBBank != null) {
				strPBBank = strPBBank.trim();
			} else {
				strPBBank = "";
			}

			strPBAccount = request.getParameter("txtPBAccountD");
			if (strPBAccount != null) {
				strPBAccount = strPBAccount.trim();
			} else {
				strPBAccount = "";
			}
		}

		strRemitFailDate = request.getParameter("txtRFDate");
		if (strRemitFailDate != null)
			strRemitFailDate = strRemitFailDate.trim();
		else
			strRemitFailDate = "";
		if (!strRemitFailDate.equals(""))
			iRemitFailDate = Integer.parseInt(strRemitFailDate);
		
		//RD0382:OIU
		String company = request.getParameter("selCompany");

		strSql = "select A.PNO,A.PNOH,A.PAMT,A.PSNAME,A.PDATE,A.PNAME,A.PID,A.PCURR,A.PMETHOD,A.PDESC,";
		strSql += "A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,A.PBACCOUNT,A.PBBANK,A.PRACCOUNT,";
		strSql += "A.PRBANK,A.APPNO,A.POLICYNO,A.BRANCH,A.RMTFEE,A.MEMO,A.ENTRYPGM,A.PPLANT,A.ENTRYUSR,";
		strSql += "A.BATSEQ,A.PPAYCURR,A.PPAYAMT,A.PPAYRATE,A.PINVDT,A.PSYMBOL,A.PSWIFT,A.PBKCOTRY,";
		strSql += "A.PBKCITY,A.PBKBRCH,A.PENGNAME,A.PFEEWAY,A.PBATNO, A.PCRDNO, B.RAMT,A.PMETHODO,";
		strSql += "A.PAMTNT,A.PORGAMT,A.PORGCRDNO,A.PROJECTCD,A.REMITFAILD,A.REMITFAILT,A.REMITFCODE,A.REMITFDESC,A.PCLMNUM,A.SRVBH,A.ANNPDATE ";
		strSql += " from CAPPAYF A ";
		strSql += " LEFT JOIN CAPRMTF B ON A.PBATNO=B.BATNO AND A.BATSEQ=B.SEQNO ";
		strSql += " WHERE A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  and A.PCFMDT2<>0 AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>''  AND A.PCSHDT <> 0 AND A.PSTATUS='A'";

		if (strRemitway.equals("US")) {
			strSql += " AND A.PMETHOD ='D'";
		} else if (strRemitway.equals("C")) {
			strSql += " AND A.PBBANK='" + strPBBank + "' AND A.PBACCOUNT='" + strPBAccount + "' ";
			strSql += " AND A.PMETHOD ='C'";
		} else {
			strSql += " AND A.PBBANK='" + strPBBank + "' AND A.PBACCOUNT='" + strPBAccount + "' ";
			strSql += " AND A.PMETHOD ='B'";
		}

		if (!strPDate.equals(""))
			strSql += " and A.PDATE <= " + iPDate;

		if (!strAMT.equals(""))
			strSql += " AND A.PAMT = " + Double.parseDouble(strAMT);

		if (!strName.equals(""))
			strSql += " AND A.PNAME LIKE '%" + strName + "%'";

		if (!strCurrency.equals(""))
			strSql += " AND A.PCURR = '" + strCurrency + "'";

		if(!strRemitFailDate.equals(""))
			strSql += " AND A.REMITFAILD=" + iRemitFailDate;
		
		//RD0382:OIU
		if("6".equals(company)){
			strSql += " AND A.PAY_COMPANY = 'OIU' ";
		}else if("0".equals(company)){
			strSql += " AND A.PAY_COMPANY <> 'OIU' ";
		}

		strSql += "	ORDER BY A.PAMT ";

		System.out.println(" inside DISBRemitFailedServlet.inquiryRemitFailed()--> strSql =" + strSql);
		log.info(" inside DISBRemitFailedServlet.inquiryRemitFailed()--> strSql =" + strSql);
		
		try {
			con = dbFactory.getAS400Connection("DISBPMaintainServlet.inquiryRemitFailed()");
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rs.getString("PNO"));	//支付序號
				if (rs.getString("PNOH").trim().equals("")) {	//要記錄第一次的支付序號
					objPDetailVO.setStrPNoH(rs.getString("PNO")); //原支付序號
				} else {
					objPDetailVO.setStrPNoH(rs.getString("PNOH"));//原支付序號
				}
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	//支付金額	
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		//付款日期
				objPDetailVO.setStrPName(rs.getString("PNAME"));//付款人姓名
				objPDetailVO.setStrPSName(rs.getString("PSNAME")); //付款人原始姓名
				objPDetailVO.setStrPId(rs.getString("PID"));	//付款人ID
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));//幣別
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD")); //付款方式
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));	 //支付描述
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));	 //來源組群
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE")); //支付原因代碼					
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS")); //付款狀態
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));//作廢否
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));//急件否
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));//付款銀行
				objPDetailVO.setStrPBBank(rs.getString("PBBANK"));		//付款帳號
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));//匯款帳號
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));		//匯款銀行
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));		//要保書號碼
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	//保單號碼
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		//保單所屬單位
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));			//匯費(手續費)
				objPDetailVO.setStrMemo(rs.getString("MEMO"));			//備註
				objPDetailVO.setStrEntryPgm(rs.getString("ENTRYPGM"));	//輸入程式
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));		//險種類別
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));	//輸入者
				objPDetailVO.setStrBATSEQ(rs.getString("BATSEQ"));		//匯款序號
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));	//匯出幣別
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));		//匯出金額
				objPDetailVO.setIPPAYRATE(rs.getDouble("PPAYRATE"));	//匯出匯率
				objPDetailVO.setIPINVDT(rs.getInt("PINVDT"));			//投資起始日
				objPDetailVO.setStrPSYMBOL(rs.getString("PSYMBOL"));	//SPUL註記
				objPDetailVO.setStrPSWIFT(rs.getString("PSWIFT"));		//SWIFT
				objPDetailVO.setStrPBKCOTRY(rs.getString("PBKCOTRY"));	//受款國別
				objPDetailVO.setStrPBKCITY(rs.getString("PBKCITY"));	//受款銀行城市
				objPDetailVO.setStrPBKBRCH(rs.getString("PBKBRCH"));	//受款銀行分行
				objPDetailVO.setStrPENGNAME(rs.getString("PENGNAME"));	//英文姓名
				objPDetailVO.setStrPFEEWAY(rs.getString("PFEEWAY"));	//付款方式
				objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO"));		//信用卡號
				objPDetailVO.setIRAMT(rs.getDouble("RAMT"));			//匯款金額CAPRMTF
				objPDetailVO.setStrPMETHODO(rs.getString("PMETHODO"));	//原始支付方式
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));		//支付金額台幣參考
				objPDetailVO.setIPOrgAMT(rs.getDouble("PORGAMT"));		//原刷金額
				objPDetailVO.setStrPOrgCrdNo(rs.getString("PORGCRDNO"));//原始卡號
				objPDetailVO.setStrProjectCode(rs.getString("PROJECTCD"));//專案碼
				objPDetailVO.setRemitFailDate(rs.getInt("REMITFAILD"));		//R90884 退匯日期
				objPDetailVO.setRemitFailTime(rs.getInt("REMITFAILT"));		//R90884 退匯時間
				objPDetailVO.setRemitFailCode(rs.getString("REMITFCODE"));	//R90884 退匯代碼
				objPDetailVO.setRemitFailDesc(rs.getString("REMITFDESC"));	//R90884 退匯原因
				objPDetailVO.setClaimNumber(rs.getString("PCLMNUM"));		//理賠編號
				objPDetailVO.setServicingBranch(rs.getString("SRVBH"));
				objPDetailVO.setAnnuityPayDate(rs.getInt("ANNPDATE"));

				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "查無相關資料");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alPDetail = null;
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception ex1) {}
			try { if (stmt != null) stmt.close(); } catch (Exception ex1) {}
			try { if (con != null) dbFactory.releaseAS400Connection(con); } catch (Exception ex1) {}
		}

		request.setAttribute("txtAction", "I");
		dispatcher = request.getRequestDispatcher("/DISB/DISBRemit/DISBRemitFailedMaintain.jsp");
		dispatcher.forward(request, response);
	}

	private void updateRemitFailed(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("@@@@@inside updateRemitFailed");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		Connection con = null;
		PreparedStatement pstmtTmp = null;
		String strSql = "";  //SQL String
		String strSql2 = ""; //R10190
		ResultSet rs = null; //R10190
		String strReturnMsg = "";
		List alCheckList = new ArrayList();
		alCheckList = (List) maintainPList(request, response);

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		int iRemitFailDate = 0;
		String strRemitFailDate = request.getParameter("txtRDate");	//退匯日期
		if(strRemitFailDate == null)
			strRemitFailDate = "";
		if(!strRemitFailDate.equals(""))
			iRemitFailDate = Integer.parseInt(strRemitFailDate);
		String strRemitFailCode = request.getParameter("selRFCode");	//退匯代碼
		if(strRemitFailCode == null)
			strRemitFailCode = "";
		String strRemitFailDesc = request.getParameter("txtRFDesc");	//退匯原因
		if(strRemitFailDesc == null)
			strRemitFailDesc = "";
		//R10314
		int iBRemitFailDate = 0;
		String strBRemitFailDate = request.getParameter("txtBRFDate");	//銀行退匯回存日期
		if(strBRemitFailDate == null)
			strBRemitFailDate = "";
		if(!strBRemitFailDate.equals(""))
			iBRemitFailDate = Integer.parseInt(strBRemitFailDate);

		try {
			if(strRemitFailCode.equals("") || strRemitFailDesc.equals("")) {
				request.setAttribute("txtMsg", "退匯處理失敗-->退匯代碼/原因不得為空值!!");
			} else if(strRemitFailCode.equals("99") && strRemitFailDesc.equals("")) {
				request.setAttribute("txtMsg", "退匯處理失敗-->退匯代碼99，請輸入退匯原因!!");
			} else {
				if (alCheckList != null) {
					if (alCheckList.size() > 0) {

						String strPNO = "";		//支付序號
						DISBPaymentDetailVO payment = null;
						LapsePaymentVO lapsePayVO = null;

						for (int i = 0; i < alCheckList.size(); i++) {
							payment = (DISBPaymentDetailVO) alCheckList.get(i);
							strPNO = payment.getStrPNO();
							if (strPNO != null)
								strPNO = strPNO.trim();
							else
								strPNO = "";

							strSql = " update CAPPAYF  set PSTATUS='A'  ";
							strSql += " , UPDDT=?, UPDTM=?, UPDUSR=?, MEMO=?, REMITFAILD=?, REMITFAILT=?, REMITFCODE=?, REMITFDESC=?, PBNKRFDT=? where PNO=? ";

							con = dbFactory.getAS400Connection("DISBRemitFailedServlet.updateRemitFailed()");
							//下log
							strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
							if (strReturnMsg.equals("")) {
								pstmtTmp = con.prepareStatement(strSql);
								pstmtTmp.setInt(1, iUpdDate);
								pstmtTmp.setInt(2, iUpdTime);
								pstmtTmp.setString(3, strLogonUser);
								pstmtTmp.setString(4, "匯款失敗--"+strRemitFailDesc);
								pstmtTmp.setInt(5, iRemitFailDate);
								pstmtTmp.setInt(6, iUpdTime);
								pstmtTmp.setString(7, strRemitFailCode);
								pstmtTmp.setString(8, strRemitFailDesc);
								pstmtTmp.setInt(9, iBRemitFailDate);
								pstmtTmp.setString(10, strPNO);
								log.info("strSql:" + strSql + ";UPDDT=" + iUpdDate + ",UPDTM=" + iUpdTime + ",UPDUSR=" + strLogonUser);
								if (pstmtTmp.executeUpdate() != 1) {
									strReturnMsg = "退匯處理失敗";
									request.setAttribute("txtMsg", "退匯處理失敗");
								} else {
									/* 將舊的支付資料新增一筆到支付主檔中, 如strReturnMsg為空白表成功*/
									strReturnMsg = createNewPayment(payment, strLogonUser, iUpdDate, iUpdTime, con);
								}
								pstmtTmp.close();
							}
							if (!strReturnMsg.equals("")) //如有錯誤時則 roll back
							{
								request.setAttribute("txtMsg", strReturnMsg);
								if (isAEGON400) {
									con.rollback();
								}
							} else {
								request.setAttribute("txtMsg", "退匯處理成功");

								//R10190 將外幣失效保單的匯款資訊寫入失效給付通知書工作檔
								if(payment.getStrPMethod() != null && CommonUtil.AllTrim(payment.getStrPMethod()).equals("D") && payment.getStrPSrcCode() != null && CommonUtil.AllTrim(payment.getStrPSrcCode()).equals("CE"))
								{
									boolean isSend = false;
									strSql2 = "select FLD0010,FLD0020,FLD0030,FLD0040,FLD0050,FLD0060,FLD0070,FLD0080,FLD0090,FLD0100,FLD0110 from ORCHLPPY where FLD0010=? ";
									pstmtTmp = con.prepareStatement(strSql2);
									pstmtTmp.setString(1, strPNO);
									rs = pstmtTmp.executeQuery();
									if(rs.next()) {
										isSend = rs.getInt("FLD0090") > 0;

										lapsePayVO = new LapsePaymentVO();
										lapsePayVO.setPNO(rs.getString("FLD0010"));			//支付序號
										lapsePayVO.setPolicyNo(rs.getString("FLD0020"));	//保單號碼
										lapsePayVO.setReceiverId(rs.getString("FLD0030"));	//受款人ID
										lapsePayVO.setReceiverName(rs.getString("FLD0040"));//受款人姓名
										lapsePayVO.setPaymentAmt(rs.getDouble("FLD0050"));	//給付金額
										lapsePayVO.setRemitDate(rs.getInt("FLD0060"));		//出納確認日
										lapsePayVO.setSendSwitch("N");						//是否寄送
										lapsePayVO.setRemitFailed(isSend?"Y":rs.getString("FLD0080"));//已寄送，但退匯
										lapsePayVO.setSendDate(rs.getInt("FLD0090"));		//寄送日期
										lapsePayVO.setUpdatedUser(strLogonUser);			//異動者
										lapsePayVO.setUpdatedDate(iUpdDate);				//異動日期

										disbBean.callCAP0314O(con, lapsePayVO);
									}
								}
							}
						}
					}
				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "退匯處理失敗-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) 
				dbFactory.releaseAS400Connection(con);
		}
		request.setAttribute("txtAction", "DISBRemitFailed");
		dispatcher = request.getRequestDispatcher("/DISB/DISBRemit/DISBRemitFailed.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private void modifyRemitFailed(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("@@@@@inside modifyRemitFailed");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		Connection con = null;
		PreparedStatement pstmtTmp = null;
		String strSql = ""; //SQL String
		String strReturnMsg = "";
		List alCheckList = new ArrayList();
		alCheckList = (List) session.getAttribute("PDetailListTemp");

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		String strRemitFailCode = request.getParameter("selRFCode");	//退匯代碼
		if(strRemitFailCode == null)
			strRemitFailCode = "";
		String strRemitFailDesc = request.getParameter("txtRFDesc");	//退匯原因
		if(strRemitFailDesc == null)
			strRemitFailDesc = "";
		//R10314
		int iBRemitFailDate = 0;
		String strBRemitFailDate = request.getParameter("txtBRFDate");	//銀行退匯回存日期
		if(strBRemitFailDate == null)
			strBRemitFailDate = "";
		if(!strBRemitFailDate.equals(""))
			iBRemitFailDate = Integer.parseInt(strBRemitFailDate);

		try {
			if(strRemitFailCode.equals("") || strRemitFailDesc.equals("")) {
				request.setAttribute("txtMsg", "退匯維護失敗-->退匯代碼/原因不得為空值!!");
			} else if(strRemitFailCode.equals("99") && strRemitFailDesc.equals("")) {
				request.setAttribute("txtMsg", "退匯維護失敗-->退匯代碼99，請輸入退匯原因!!");
			} else {
				if (alCheckList != null) {
					if (alCheckList.size() > 0) {

						String strPNO = "";		//支付序號
						for (int i = 0; i < alCheckList.size(); i++) {
							strPNO = (String) ((DISBPaymentDetailVO) alCheckList.get(i)).getStrPNO();
							if (strPNO != null)
								strPNO = strPNO.trim();
							else
								strPNO = "";

							strSql = " update CAPPAYF set UPDDT= ?, UPDTM = ?, UPDUSR =?, MEMO =?, REMITFCODE=?, REMITFDESC=?,PBNKRFDT=? where PNO =?";

							con = dbFactory.getAS400Connection("DISBPMaintainServlet.inqueryDB()");
							//下log
							strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
							if (strReturnMsg.equals("")) {
								pstmtTmp = con.prepareStatement(strSql);
								pstmtTmp.setInt(1, iUpdDate);
								pstmtTmp.setInt(2, iUpdTime);
								pstmtTmp.setString(3, strLogonUser);
								pstmtTmp.setString(4, "匯款失敗--"+strRemitFailDesc);
								pstmtTmp.setString(5, strRemitFailCode);
								pstmtTmp.setString(6, strRemitFailDesc);
								pstmtTmp.setInt(7, iBRemitFailDate);//R10314
								pstmtTmp.setString(8, strPNO);

								if (pstmtTmp.executeUpdate() != 1) {
									strReturnMsg = "退匯維護失敗";
									request.setAttribute("txtMsg", "退匯維護失敗");
								}
								pstmtTmp.close();
							}
							if (!strReturnMsg.equals("")) //如有錯誤時則 roll back
							{
								request.setAttribute("txtMsg", strReturnMsg);
								if (isAEGON400) {
									con.rollback();
								}
							} else {
								request.setAttribute("txtMsg", "退匯維護成功");
							}
						}
					}
				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "退匯維護失敗-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) 
				dbFactory.releaseAS400Connection(con);
		}
		request.setAttribute("txtAction", "DISBRemitFailedModify");
		dispatcher = request.getRequestDispatcher("/DISB/DISBRemit/DISBRemitFailedMaintain.jsp");
		dispatcher.forward(request, response);
		return;
	}

	private List maintainPList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		int iSize = 0;

		String strIsChecked = "";
		double douPAYAMT = 0;	//R60550
		String strFEEWAY = "";	//R60550
		boolean bIsChecked = false;
		List alCheckList = new ArrayList();
		List alPDetail = (List) session.getAttribute("PDetailListTemp");

		if (alPDetail != null)
			iSize = alPDetail.size();

		for (int i = 0; i < iSize; i++) {
			strIsChecked = request.getParameter("ch" + i);
			if ("Y".equalsIgnoreCase(strIsChecked)) {
				bIsChecked = true;
				((DISBPaymentDetailVO) alPDetail.get(i)).setChecked(bIsChecked);
				DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(i);
				strFEEWAY = request.getParameter("selFEEWAY" + i);
				douPAYAMT = Double.parseDouble(request.getParameter("txtFEEAMT" + i).trim());
				if (douPAYAMT != 0) {
					objPDetailVO.setFPAYAMT(douPAYAMT);
					objPDetailVO.setFFEEWAY(strFEEWAY);
				}
				alCheckList.add(objPDetailVO);
			}
		} // end of for loop........
		session.removeAttribute("PDetailList");
		session.setAttribute("PDetailList", alPDetail);

		return alCheckList;
	} // end of maintainPList method....

	private String createNewPayment(DISBPaymentDetailVO objPDetailVO, String strLogonUser, int iEntryDate, int iEntryTime, Connection con) throws ServletException, IOException {
		System.out.println("inside createNewPayment");

		String strReturnMsg = "";
		Hashtable htReturnInfo = new Hashtable();
		String strNewPNo = "";
		double douFPAYAMT = 0; //R60550
		int iFPAYAMT = 0; //R60550
		double dFPAYAMT = 0;

		/* 取得新的支付序號*/
		disbBean = new DISBBean(dbFactory);

		try {
			htReturnInfo = (Hashtable) disbBean.getDISBSeqNo("DISB", strLogonUser, con);
			strReturnMsg = (String) htReturnInfo.get("ReturnMsg");
			if (strReturnMsg.equals("")) {
				// R70477	
				String strSql_F =
					" insert into  CAPPAYF "
						+ " (PNO,PNOH,PAMT,PSNAME,PDATE,PNAME,PID,PCURR,PMETHOD,PDESC,PSRCGP,PSRCCODE,PVOIDABLE,PDISPATCH,"
						+ "PCHKM1,PCHKM2,PRACCOUNT,PRBANK,APPNO,POLICYNO,BRANCH,RMTFEE,MEMO,ENTRYPGM,PPLANT,ENTRYDT,ENTRYTM,ENTRYUSR"
						+ ",PPAYCURR,PPAYAMT,PPAYRATE,PSYMBOL,PINVDT,PSWIFT,PBKCOTRY,PBKCITY,PBKBRCH,PENGNAME,PFEEWAY,PORGAMT,PORGCRDNO,PROJECTCD,PMETHODO,PAMTNT,REMITFAILD,REMITFAILT,REMITFCODE,REMITFDESC,PCLMNUM,PBNKRFDT,SRVBH,ANNPDATE)" //R70600 R90884 R10134
						+" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,'Y','Y',?,?,?,?,?,0,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,0,0,'','',?,0,?,?)"; //R70600 R90884 R10134

				strNewPNo = (String) htReturnInfo.get("ReturnValue");
				PreparedStatement pstmtTmp = con.prepareStatement(strSql_F);
				pstmtTmp.setString(1, strNewPNo);
				System.out.println("NewPNO=" + strNewPNo);
				pstmtTmp.setString(2, objPDetailVO.getStrPNoH().trim()); //第一筆的支付序號

				if (objPDetailVO.getFPAYAMT() != 0 && objPDetailVO.getFFEEWAY().trim().equals("BEN")) {
//					iFPAYAMT = (int) ((objPDetailVO.getIPAMT() - (objPDetailVO.getFPAYAMT() * objPDetailVO.getIPPAYRATE()) + 0.5));
//					pstmtTmp.setDouble(3, iFPAYAMT);
					dFPAYAMT = disbBean.DoubleSub(objPDetailVO.getIPAMT(), disbBean.DoubleMul(objPDetailVO.getFPAYAMT(), objPDetailVO.getIPPAYRATE()));
					if(CommonUtil.AllTrim(objPDetailVO.getStrPCurr()).equals("NT")) {
						iFPAYAMT = (int) dFPAYAMT;
						pstmtTmp.setDouble(3, iFPAYAMT);
					} else {
						pstmtTmp.setDouble(3, dFPAYAMT);
					}
				} else {
					pstmtTmp.setDouble(3, objPDetailVO.getIPAMT());
				}
				pstmtTmp.setString(4, objPDetailVO.getStrPSName().trim());
				pstmtTmp.setInt(5, iEntryDate);
				pstmtTmp.setString(6, objPDetailVO.getStrPName().trim());
				pstmtTmp.setString(7, objPDetailVO.getStrPId().trim());
				pstmtTmp.setString(8, objPDetailVO.getStrPCurr().trim());
				pstmtTmp.setString(9, objPDetailVO.getStrPMethod().trim());
				pstmtTmp.setString(10, objPDetailVO.getStrPDesc().trim());
				pstmtTmp.setString(11, objPDetailVO.getStrPSrcGp().trim());
				pstmtTmp.setString(12, objPDetailVO.getStrPSrcCode().trim());
				pstmtTmp.setString(13, objPDetailVO.getStrPVoidable().trim());
				pstmtTmp.setString(14, objPDetailVO.getStrPDispatch().trim());
				pstmtTmp.setString(15, objPDetailVO.getStrPRAccount().trim());
				pstmtTmp.setString(16, objPDetailVO.getStrPRBank().trim());
				pstmtTmp.setString(17, objPDetailVO.getStrAppNo().trim());
				pstmtTmp.setString(18, objPDetailVO.getStrPolicyNo().trim());
				pstmtTmp.setString(19, objPDetailVO.getStrBranch().trim());
				pstmtTmp.setString(20, objPDetailVO.getStrMemo().trim());
				pstmtTmp.setString(21, objPDetailVO.getStrEntryPgm().trim());
				pstmtTmp.setString(22, objPDetailVO.getStrPPlant().trim());
				pstmtTmp.setInt(23, iEntryDate);
				pstmtTmp.setInt(24, iEntryTime);
				pstmtTmp.setString(25, objPDetailVO.getStrEntryUsr()); //R60550
				pstmtTmp.setString(26, objPDetailVO.getStrPPAYCURR().trim());
				if (objPDetailVO.getFPAYAMT() != 0 && objPDetailVO.getFFEEWAY().trim().equals("BEN")) {
//					douFPAYAMT = objPDetailVO.getIPPAYAMT() - objPDetailVO.getFPAYAMT();
					douFPAYAMT = disbBean.DoubleSub(objPDetailVO.getIPPAYAMT(), objPDetailVO.getFPAYAMT());
					pstmtTmp.setDouble(27, douFPAYAMT);
				} else
					pstmtTmp.setDouble(27, objPDetailVO.getIPPAYAMT());
				pstmtTmp.setDouble(28, objPDetailVO.getIPPAYRATE());
				pstmtTmp.setString(29, objPDetailVO.getStrPSYMBOL().trim());
				pstmtTmp.setInt(30, objPDetailVO.getIPINVDT());
				pstmtTmp.setString(31, objPDetailVO.getStrPSWIFT());
				pstmtTmp.setString(32, objPDetailVO.getStrPBKCOTRY());
				pstmtTmp.setString(33, objPDetailVO.getStrPBKCITY());
				pstmtTmp.setString(34, objPDetailVO.getStrPBKBRCH());
				pstmtTmp.setString(35, objPDetailVO.getStrPENGNAME());
				pstmtTmp.setString(36, objPDetailVO.getStrPFEEWAY());
				pstmtTmp.setDouble(37, objPDetailVO.getIPOrgAMT());		//R70600 原刷金額
				pstmtTmp.setString(38, objPDetailVO.getStrPOrgCrdNo());	//R70600 原刷卡號
				pstmtTmp.setString(39, objPDetailVO.getStrProjectCode());	//R70600 專案碼
				pstmtTmp.setString(40, objPDetailVO.getStrPMETHODO());	//R70600 原始支付方式
				pstmtTmp.setDouble(41, objPDetailVO.getIPAMTNT());		//R70600 支付金額台幣參考
				pstmtTmp.setString(42, objPDetailVO.getClaimNumber());
				pstmtTmp.setString(43, objPDetailVO.getServicingBranch());
				pstmtTmp.setInt(44, objPDetailVO.getAnnuityPayDate());

				if (pstmtTmp.executeUpdate() != 1) {
					strReturnMsg = "新增原支付資料到支付主檔失敗";
					System.out.println("strReturnMsg=UPDATE FAIL");
				}
				pstmtTmp.close();
				htReturnInfo = null;
			}
		} catch (SQLException e) {
			strReturnMsg = "新增原支付資料到支付主檔失敗:" + e;
			System.out.println("strReturnMsg=SQL EXCEPTION");
		} catch (Exception ex) {
			strReturnMsg = "新增原支付資料到支付主檔失敗:" + ex;
			System.out.println("strReturnMsg=EXCEPTION");
		}
		System.out.println("strReturnMsg=" + strReturnMsg);
		/*R60550新增匯退處理*/
		if (strReturnMsg.equals("") && objPDetailVO.getFPAYAMT() != 0) {
			String strSql_1 =
				" insert into  CAPRFEF "
					+ "(FPNO,FPAYCURR,FPAYAMT,FFEEWAY,FPNOH,ENTRYDT,ENTRYTM,ENTRYUSR)"
					+ " VALUES (?,?,?,?,?,?,?,?)";
			System.out.println(" inside DISBRemitFailedServlet.insertCAPRFEF()--> strSql_1 =" + strSql_1);
			try {
				PreparedStatement pstmtTmp = con.prepareStatement(strSql_1);
				pstmtTmp.setString(1, strNewPNo);
				pstmtTmp.setString(2, objPDetailVO.getStrPPAYCURR().trim());
				pstmtTmp.setDouble(3, objPDetailVO.getFPAYAMT());
				pstmtTmp.setString(4, objPDetailVO.getFFEEWAY().trim());
				pstmtTmp.setString(5, objPDetailVO.getStrPNoH().trim());
				pstmtTmp.setInt(6, iEntryDate);
				pstmtTmp.setInt(7, iEntryTime);
				pstmtTmp.setString(8, objPDetailVO.getStrEntryUsr());
				if (pstmtTmp.executeUpdate() < 1) {
					strReturnMsg = "新增CAPRFEF失敗";
				}
				pstmtTmp.close();
			} catch (SQLException e) {
				strReturnMsg = "新增CAPRFEF失敗:" + e;
			} catch (Exception ex) {
				strReturnMsg = "新增CAPRFEF失敗:" + ex;
			}
		}
		/*新增支付通知書檔CAPPAYRF**僅限來源=CAPSIL件*/
		if (objPDetailVO.getStrPSrcGp().trim().equals("CP")) {
			String strSql_2 =
				"insert into CAPPAYRF "
					+ "(PNO,POLICYNO,APPNM,INSNM,RECEIVER,MAILZIP,MAILAD,HMZIP,HMAD,SRVNM,SRVBH,ITEM,DEFAMT,DIVAMT,"
					+ " LOAN,UNPRDPRM,REVPRM,CURPRM,OVRRTN,PEWD,PEAMT,LANCAP,LANINT,APL,APLINT,OFFWD,OFFAMT,SNDNM,"
					+ " UPDDT,UPDTM,UPDUSR,APPID,APPSEX,OFFWD1,OFFAMT1,OFFWD2,OFFAMT2,OFFWD3,OFFAMT3,AWDRMK) "
					+ " select '" + strNewPNo + "', "
					+ " POLICYNO,APPNM,INSNM,RECEIVER,MAILZIP,MAILAD,HMZIP,HMAD,SRVNM,SRVBH,ITEM,DEFAMT,DIVAMT,"
					+ " LOAN,UNPRDPRM,REVPRM,CURPRM,OVRRTN,PEWD,PEAMT,LANCAP,LANINT,APL,APLINT,OFFWD,OFFAMT,SNDNM,"
					+ " UPDDT,UPDTM,UPDUSR,APPID,APPSEX,OFFWD1,OFFAMT1,OFFWD2,OFFAMT2,OFFWD3,OFFAMT3,AWDRMK "
					+ " from CAPPAYRF where PNO ='" + objPDetailVO.getStrPNoH().trim() + "'";

			System.out.println(" inside DISBRemitFailedServlet.insertCAPPAYRF()--> strSql_2 =" + strSql_2);
			try {
				PreparedStatement pstmtTmp = con.prepareStatement(strSql_2);
				if (pstmtTmp.executeUpdate() < 1) {
					strReturnMsg = "新增CAPPAYRF失敗";
				} else {
					strReturnMsg = "";
				}
			} catch (SQLException e) {
				strReturnMsg = "新增CAPPAYRF失敗" + e;
			}
		}
		return strReturnMsg;
	}
}