package com.aegon.disb.disbremit;

/**
 * RD0440-新增外幣指定銀行-台灣銀行:手續費計算,將call DISBBean.getETable();
 */

/**
 * System   :
 * 
 * Function : 出納功能-整批匯款
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.26 $$
 * 
 * Author   : Vicky Hsu
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBRemitDisposeServlet.java,v $
 * $Revision 1.26  2015/11/24 04:15:47  001946
 * $*** empty log message ***
 * $
 * $Revision 1.25  2014/08/25 01:52:38  missteven
 * $RC0036-3
 * $
 * $Revision 1.24  2014/07/18 07:16:38  misariel
 * $EC0342-RC0036新增分公司行政人員使用CAPSIL
 * $
 * $Revision 1.23  2013/05/02 11:07:05  MISSALLY
 * $R10190 美元失效保單作業
 * $
 * $Revision 1.22  2013/02/27 05:35:34  ODCZheJun
 * $R10190 美元傳統型保單失效作業
 * $
 * $Revision 1.21  2013/01/08 04:24:03  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.20.4.2  2012/09/06 02:03:07  MISSALLY
 * $QA0281---修正一銀手續費因手續費支付方式若為BEN而沒有計算到的問題
 * $
 * $Revision 1.20.4.1  2012/08/31 01:21:30  MISSALLY
 * $RA0140---新增兆豐為外幣指定行
 * $
 * $Revision 1.20  2011/11/08 09:16:39  MISSALLY
 * $Q10312
 * $匯款功能-整批匯款作業
 * $1.修正銀行帳號不一致
 * $2.調整兆豐匯款檔
 * $
 * $Revision 1.19  2011/05/12 06:13:07  MISJIMMY
 * $R00440 SN滿期金
 * $
 * $Revision 1.17  2010/11/23 06:50:42  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.16  2010/05/04 07:12:14  missteven
 * $R90735
 * $
 * $Revision 1.15  2008/08/06 06:53:25  MISODIN
 * $R80338 調整CASH系統 for 出納外幣一對一需求
 * $
 * $Revision 1.14  2007/09/07 10:24:36  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.13  2007/08/03 09:54:43  MISODIN
 * $R70477 外幣保單匯款手續費
 * $
 * $Revision 1.12  2007/03/16 01:52:57  MISVANESSA
 * $R70088_SPUL配息修改手續費rule
 * $
 * $Revision 1.11  2007/03/08 10:11:33  MISVANESSA
 * $R70088_SPUL配息修改手續費
 * $
 * $Revision 1.10  2007/03/06 01:36:26  MISVANESSA
 * $R70088_SPUL配息新增客戶負擔手續費
 * $
 * $Revision 1.9  2007/01/31 07:58:10  MISVANESSA
 * $R70088_SPUL配息
 * $
 * $Revision 1.8  2007/01/09 04:06:01  miselsa
 * $R60550_整批匯款金額改為小數點4位
 * $
 * $Revision 1.7  2007/01/05 01:46:04  miselsa
 * $R60550_外幣匯款件始須特別篩選是否為SPUL
 * $
 * $Revision 1.6  2007/01/03 08:32:51  miselsa
 * $R60550_SPUL 投資起始日之前 增加 客戶匯出銀行條件
 * $
 * $Revision 1.5  2006/12/27 09:51:43  miselsa
 * $R60463及R60550_SPUL保單投資起始日前的匯費
 * $
 * $Revision 1.4  2006/12/07 22:00:34  miselsa
 * $R60463及R60550外幣及SPUL保單
 * $
 * $Revision 1.3  2006/11/30 09:16:46  miselsa
 * $R60463及R60550外幣及SPUL保單
 * $
 * $Revision 1.2  2006/09/04 09:43:35  miselsa
 * $R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.8  2006/04/27 09:25:45  misangel
 * $R50891:VA美元保單-顯示幣別
 * $
 * $Revision 1.1.2.7  2005/08/19 06:56:18  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併
 * $
 * $Revision 1.1.2.6  2005/04/08 02:56:54  MISANGEL
 * $R30530:支付系統
 * $
 * $Revision 1.1.2.5  2005/04/04 07:02:27  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.RemittanceFeeNotFoundException;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBCheckDetailVO;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.LapsePaymentVO;
import com.aegon.disb.util.StringTool;
import org.apache.log4j.Logger;

public class DISBRemitDisposeServlet extends InitDBServlet {
	
	private Logger log = Logger.getLogger(getClass());

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

	// Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);

		if ("query".equals(request.getParameter("action"))) {
			this.query(request, response);
		} else if ("update".equals(request.getParameter("action"))) {
			this.update(request, response);
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	private void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String PMETHOD = request.getParameter("pMethod");
		String pDate1 = request.getParameter("pDate1");
		String pDate2 = request.getParameter("pDate2");
		String pDispatch = request.getParameter("pDispatch");
		String strCurrency = request.getParameter("selCurrency");
		String SYMBOL = request.getParameter("txtSYMBOL");
		// String BeforePINVDT = request.getParameter("selBeforePINVDT");
		String PRBank = request.getParameter("txtPRBank");// 客戶匯出銀行
		String PCURR = request.getParameter("selCurrency");// R70477 保單幣別
		// String ProjectCode = request.getParameter("selProjectCode");//R80338 // 專案碼
		String payRule = request.getParameter("txtPayRule"); // R00386 付款規則

		Vector disbPaymentDetailVec = null;
		DISBRemitDisposeDAO dao = null;
		try {
			dao = new DISBRemitDisposeDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY));

			disbPaymentDetailVec = dao.query(PMETHOD,
					Integer.parseInt(StringTool.removeChar(pDate1, '/')),
					Integer.parseInt(StringTool.removeChar(pDate2, '/')),
					pDispatch,
					// R80338 strCurrency,SYMBOL,BeforePINVDT,PRBank);
					strCurrency, SYMBOL, PRBank, payRule); // R80338
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.removeConn();
		}
		if (disbPaymentDetailVec == null || disbPaymentDetailVec.size() <= 0) {
			request.setAttribute("msg", "查無資料");
			path = "/DISB/DISBRemit/DISBRemitDispose.jsp";
		} else {
			path = "/DISB/DISBRemit/DISBRemitDisposeList.jsp";
		}
		request.setAttribute("vo", disbPaymentDetailVec);
		request.setAttribute("PMETHOD", PMETHOD);
		request.setAttribute("SYMBOL", SYMBOL);
		request.setAttribute("SELPRBank", PRBank); // R70088
		request.setAttribute("selCurrency", PCURR); // R70477
		request.setAttribute("payRule", payRule); // R00386
		request.setAttribute("pDispatch", pDispatch); // RC0036
	}

	private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String PMETHOD = request.getParameter("PMETHOD").trim();// 付款方式

		if (PMETHOD.equals("D")) {
			updateD(request, response);
		} else {
			updateB(request, response);
		}

	}

	/**
	 * @param request
	 * @param response
	 */
	private void updateB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		path = "/DISB/DISBRemit/DISBRemitDispose.jsp";
		String[] PNO = request.getParameterValues("PNO");
		String PBANK = request.getParameter("PBBANK").trim();// 付款銀行,付款帳號
		String PMETHOD = request.getParameter("PMETHOD").trim();// 付款方式

		/* R60747 增加出納確認日欄位 Start */
		String PCSHCM = request.getParameter("txtPCSHCM");
		int iPCSHCM = 0;
		if (PCSHCM != null)
			PCSHCM = PCSHCM.trim();
		else
			PCSHCM = "";
		if (!PCSHCM.equals(""))
			iPCSHCM = Integer.parseInt(PCSHCM);
		/* R60747 增加出納確認日欄位 End */
		
		String strCNo = request.getParameter("txtCHKNO")!=null?request.getParameter("txtCHKNO"):"";

		DbFactory dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
		DISBRemitDisposeDAO dao = new DISBRemitDisposeDAO(dbFactory);
		DISBBean disBBean = new DISBBean(dbFactory);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		int updateDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int updateTime = Integer.parseInt((new SimpleDateFormat("HHmmss")).format(cldToday.getTime()));
		String logonUser = (String) request.getSession().getAttribute(Constant.LOGON_USER_ID);
		String batNo = disBBean.getPBatNo(PMETHOD, updateDate, updateTime, PBANK);
		int count = 0;// 匯款筆數
		double amt = 0;// 匯款總金額
		double amtFee = 0;// 匯費總金額
		String wsPNO = ""; // 支付序號
		String wsBANK = ""; // 收款銀行
		String wsACCOUNT = ""; // 收款帳號
		String wsPNAME = ""; // 收款人
		String wsENTRYUSR = "";// 輸入者
		//String wsPDESC = "";// 支付描述@R90735
		String wsRMEMO = "";// @R90735
		List ls = null;// @R90735
		double wsAMT = 0;
		int ISeqNo = 0;
		String strCBNO = "" ;
		CaprmtfVO rmtVO = new CaprmtfVO();
		
		//檢核票號
		Connection con = dbFactory.getAS400Connection("DISBRemitDisposeServlet.updateB()");
		PreparedStatement pstmtTmp = null;
		ResultSet rs = null;
		StringBuffer buffer = new StringBuffer();
		
		try {
			if (!"".equals(strCNo)){
				buffer.append("select A.CBKNO,A.CBNO from CAPCHKF A,CAPCKNOF B ");
				buffer.append("WHERE CNO = '" + strCNo + "' ");
				buffer.append("AND A.CBKNO = B.CBKNO ");
				buffer.append("AND A.CACCOUNT = B.CACCOUNT AND A.CBNO = B.CBNO AND B.APPROVSTA <> 'E' ");
				pstmtTmp = con.prepareStatement(buffer.toString());
				rs = pstmtTmp.executeQuery();
				if (rs.next()) {
					strCBNO = rs.getString("CBNO");
				}else{
					request.setAttribute("msg","支票號碼[" + strCNo + "]不存在!");
					return;
				}
			}
			
			for (int index = 0; index < PNO.length; index++) {
				DISBPaymentDetailVO payment = new DISBPaymentDetailVO();

				payment.setStrPNO(PNO[index].trim());
				dao.query(payment);// QUERY 支付金額

				payment.setStrPBBank(PBANK.substring(0, 7));
				payment.setStrPBAccount(PBANK.substring(8));
				payment.setStrPMethod(PMETHOD);
				payment.setStrBatNo(batNo);// 匯款批號
				payment.setIPCshDt(updateDate);// 出納日期
				payment.setIUpdDt(updateDate);// 異動日期
				payment.setIUpdTm(updateTime);// 異動時間
				payment.setStrUpdUsr(logonUser);// 異動者
				payment.setIPCSHCM(iPCSHCM);/* R60747 增加出納確認日欄位 */
				payment.setStrPCheckNO(strCNo);//RC0036

				if (PMETHOD.equals("B")) {// 台幣匯款
					if (index == 0) {
						// 序號@R90735
						ISeqNo += 1;
						wsPNO = payment.getStrPNO() != null ? payment.getStrPNO().trim() : "";
						wsBANK = payment.getStrPRBank() != null ? payment.getStrPRBank().trim() : "";
						wsACCOUNT = payment.getStrPRAccount() != null ? payment.getStrPRAccount().trim() : "";
						wsPNAME = payment.getStrPName() != null ? payment.getStrPName().replace('　', ' ').trim() : "";
						wsENTRYUSR = payment.getStrEntryUsr() != null ? payment.getStrEntryUsr().trim() : "";
						// wsPDESC = payment.getStrPDesc()!=null?payment.getStrPDesc().trim():"";
						rmtVO = prepareData(payment);
					}
					// 國內匯款加總規則 -->同一銀行同一帳號 同一受款人 同一輸入者
					if (!wsBANK.equals(payment.getStrPRBank().trim())
							|| !wsACCOUNT.equals(payment.getStrPRAccount().trim())
							|| !wsPNAME.equals(payment.getStrPName().replace('　', ' ').trim())
							|| !wsENTRYUSR.equals(payment.getStrEntryUsr().trim())) 
					{
						rmtVO.setBATNO(batNo);// 匯款批號
						rmtVO.setSEQNO(String.valueOf(ISeqNo));// 序號
						rmtVO.setPBK(PBANK.substring(0, 7));// 付款銀行
						rmtVO.setPACCT(PBANK.substring(8));// 付款帳號
						rmtVO.setRAMT(wsAMT);// 金額x(13)
						rmtVO.setRMTFEE((int) disBBean.getPFee(payment.getStrPBBank().trim(), wsBANK, wsAMT, payment.getStrPMethod().trim(), "", ""));// 匯費
						rmtVO.setENTRYDT(updateDate);// 輸入日期
						rmtVO.setENTRYTM(updateTime);// 輸入時間

						// R90735
						if (ls.size() > 0) {
							List rm = removeDuplicate(ls);
							for (int i = 0; i < rm.size(); i++) {
								wsRMEMO += (String) rm.get(i);
							}
						}

						rmtVO.setRMEMO(wsRMEMO);

						dao.insertRMTF(rmtVO);
						
						amtFee += rmtVO.getRMTFEE();

						rmtVO = new CaprmtfVO();
						rmtVO = prepareData(payment);
						wsAMT = 0;
						wsRMEMO = "";// @R90735
						wsAMT += payment.getIPAMT(); // @R90735
						ISeqNo += 1;
						wsBANK = payment.getStrPRBank() != null ? payment.getStrPRBank().trim() : "";
						wsACCOUNT = payment.getStrPRAccount() != null ? payment.getStrPRAccount().trim() : "";
						wsPNAME = payment.getStrPName() != null ? payment.getStrPName().replace('　', ' ').trim() : "";
						wsENTRYUSR = payment.getStrEntryUsr() != null ? payment.getStrEntryUsr().trim() : "";
						//wsPDESC = payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : "";
						ls.clear();
						if (wsBANK.startsWith("822") && PBANK.startsWith("822"))
							ls.add("ＣＴＣＢ" + (payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
						else
							ls.add((payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
					} else {
						wsAMT += payment.getIPAMT();
						// @R90735
						if (ls == null)
							ls = new ArrayList();

						if (wsBANK.startsWith("822") && PBANK.startsWith("822"))
							ls.add("ＣＴＣＢ" + (payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
						else
							ls.add((payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
					}

				}

				// 寫入log檔
				disBBean.insertCAPPAYFLOG(payment.getStrPNO(), logonUser, updateDate, updateTime);

				count += dao.update(payment, String.valueOf(ISeqNo));
				amt += payment.getIRmtFee() + payment.getIPAMT();
			}

			rmtVO.setBATNO(batNo);// 匯款批號
			rmtVO.setSEQNO(String.valueOf(ISeqNo));
			rmtVO.setPBK(PBANK.substring(0, 7));// 付款銀行
			rmtVO.setPACCT(PBANK.substring(8));// 付款帳號
			rmtVO.setRAMT(wsAMT);// 金額x(13)
			rmtVO.setRMTFEE((int) disBBean.getPFee(PBANK.substring(0, 7), wsBANK, wsAMT, PMETHOD, "", ""));// 匯費
			rmtVO.setENTRYDT(updateDate);// 輸入日期
			rmtVO.setENTRYTM(updateTime);// 輸入時間
			// R90735 附言
			if (ls.size() > 0) {
				List rm = removeDuplicate(ls);
				for (int i = 0; i < rm.size(); i++) {
					wsRMEMO += (String) rm.get(i);
				}
			}
			rmtVO.setRMEMO(wsRMEMO);
			dao.insertRMTF(rmtVO);
			amtFee += rmtVO.getRMTFEE();
			//RC0036
			if (!"".equals(strCNo)){
				pstmtTmp = con.prepareStatement("update CAPCHKF  set CNM=?,CAMT=?,CHEQUEDT=?,CUSEDT=?,PNO=? ,CSTATUS='D' where CNO =? AND CBKNO=? AND CACCOUNT=? AND CBNO=? ");					
				pstmtTmp.setString(1, wsPNAME);
				pstmtTmp.setDouble(2, amt+amtFee);
				pstmtTmp.setInt(3, updateDate);
				pstmtTmp.setInt(4, updateDate);
				pstmtTmp.setString(5, wsPNO);
				pstmtTmp.setString(6, strCNo);
				pstmtTmp.setString(7, PBANK.substring(0, 7));
				pstmtTmp.setString(8, PBANK.substring(8));
				pstmtTmp.setString(9, strCBNO);
				pstmtTmp.executeUpdate();
			}
		} catch (Exception e) {
			System.err.println(e.toString());
		} finally {
			dao.removeConn();
		}
		request.setAttribute("count", String.valueOf(count));// 匯款筆數
		request.setAttribute("amt", String.valueOf(amt));// 匯款總金額
		request.setAttribute("batNo", batNo);// 匯款批號

	}

	// R90735
	private List removeDuplicate(List list) {
		HashSet hs = new HashSet(list);
		list.clear();
		list.addAll(hs);
		return list;
	}

	/**
	 * @param request
	 * @param response
	 */
	private void updateD(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		path = "/DISB/DISBRemit/DISBRemitDispose.jsp";
		String[] PNO = request.getParameterValues("PNO");
		String PBANK = request.getParameter("PBBANK").trim();// 付款銀行,付款帳號
		String PMETHOD = request.getParameter("PMETHOD").trim();// 付款方式
		DecimalFormat df = new DecimalFormat("###,###,##0.0000");

		/* R60747 增加出納確認日欄位 Start */
		String PCSHCM = request.getParameter("txtPCSHCM");
		int iPCSHCM = 0;
		if (PCSHCM != null)
			PCSHCM = PCSHCM.trim();
		else
			PCSHCM = "";
		if (!PCSHCM.equals(""))
			iPCSHCM = Integer.parseInt(PCSHCM);
		/* R60747 增加出納確認日欄位 End */

		DbFactory dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
		DISBRemitDisposeDAO dao = new DISBRemitDisposeDAO(dbFactory);
		DISBBean disBBean = new DISBBean(dbFactory);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		int updateDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int updateTime = Integer.parseInt((new SimpleDateFormat("HHmmss")).format(cldToday.getTime()));

		// R00393
		String logonUser = (String) request.getSession().getAttribute(Constant.LOGON_USER_ID);
		String batNo = disBBean.getPBatNo(PMETHOD, updateDate, updateTime, PBANK);
		int count = 0;// 匯款筆數
		double amt = 0;// 匯款總金額
		double RPAYamt = 0;// 外幣匯款總金額
		String wsSWIFT = ""; // SWIFTCODE
		String wsBANK = "";// 客戶匯入銀行
		String wsACCOUNT = ""; // 收款帳號
		String wsPNAME = ""; // 收款人
		String wsPID = ""; // 收款人ID R70088
		String wsPENGNAME = "";// 收款人英文名字
		String wsENTRYUSR = "";// 輸入者
		String wsPAYFEEWAY = "";// 外幣加入收續費支付方式
		String wsPPAYCURR = "";// 外幣幣?
		String wsPBKBRCH = "";// 分行
		String wsPBKCITY = "";// 城市
		String wsPCOUNTRY = "";// 國別
		double wsRPAYAMT = 0;// 外幣金額
		double wsRPAYRATE = 0;// 外幣匯率R70088
		double wsRBENFEE = 0;// 客戶負擔手續費R70088
		String wsPSRCCODE = "";// 支付原因碼R70088
		String wsSWITCH = "";// 判斷是否為投資起始日前或配息件R70088
		String wsRPCURR = "";// R70477保單幣別
		double wsAMT = 0;
		int ISeqNo = 0;
		int wsEntryDt = 0;// 輸入日
		int wsPINVDT = 0;// 投資起始日
		String wsPSYMBOL = "";// 是否為SPUL保單
		CaprmtfVO rmtVO = new CaprmtfVO();

		double wsTEMPamt = 0;// R70455
		boolean wsFcTri = false;
		boolean currFcTri = false;

		try {
			LapsePaymentVO lapsePayVO = null;
			List listlapsePay = new ArrayList();
			for (int index = 0; index < PNO.length; index++) {
				DISBPaymentDetailVO payment = new DISBPaymentDetailVO();

				payment.setStrPNO(PNO[index].trim());
				dao.query(payment);// QUERY 支付金額
				payment.setStrPBBank(PBANK.substring(0, 7));
				payment.setStrPBAccount(PBANK.substring(8));
				payment.setStrPMethod(PMETHOD);
				payment.setStrBatNo(batNo);// 匯款批號
				payment.setIPCshDt(updateDate);// 出納日期
				payment.setIUpdDt(updateDate);// 異動日期
				payment.setIUpdTm(updateTime);// 異動時間
				payment.setStrUpdUsr(logonUser);// 異動者
				payment.setIPCSHCM(iPCSHCM);/* R60747 增加出納確認日欄位 */
				payment.setStrPCheckNO("");//RC0036
				currFcTri = (payment.getStrPPlant().equals(" ") && !payment.getStrPCurr().equals("NT")); // R00386 美元傳統型保單

				if (index == 0) {
					ISeqNo += 1;// 序號

					wsSWIFT = payment.getStrPSWIFT().trim();// SWIFT CODE
					wsBANK = payment.getStrPRBank();
					wsACCOUNT = payment.getStrPRAccount().trim();
					wsPNAME = payment.getStrPName().replace('　', ' ').trim();
					wsPID = payment.getStrPId().trim();// R70088 SPUL配息
					wsENTRYUSR = payment.getStrEntryUsr().trim();
					wsPAYFEEWAY = payment.getStrPFEEWAY();// 外幣加入收續費支付方式
					wsPPAYCURR = payment.getStrPPAYCURR(); // 匯出幣別
					wsPENGNAME = payment.getStrPENGNAME();// 英文姓名
					wsPBKBRCH = payment.getStrPBKBRCH();// 分行
					wsPBKCITY = payment.getStrPBKCITY();// 城市
					wsPCOUNTRY = payment.getStrPBKCOTRY();// 國別
					wsAMT = payment.getIPAMT();
					// R70455先四捨五入再加總 wsRPAYAMT = payment.getIPPAYAMT();//外幣金額
					wsRPAYAMT = disBBean.DoubleRound(payment.getIPPAYAMT(), 2);// R70455
					wsRPAYRATE = payment.getIPPAYRATE();// 外幣匯率R70088
					wsPSRCCODE = payment.getStrPSrcCode().trim();// 支付原因碼R70088
					wsEntryDt = payment.getIEntryDt();
					wsPINVDT = payment.getIPINVDT();
					wsPSYMBOL = payment.getStrPSYMBOL();
					wsRPCURR = payment.getStrPCurr(); // R70477保單幣別
					wsFcTri = currFcTri;
					rmtVO = prepareData(payment);
				}
				/*
				 * 國外匯款加總規則 -->同一SWIFT CODE 同一帳號 同一受款人 同一輸入者 同一受款人英文姓名 同一城市 同一分行
				 * 同一幣別
				 */
				if (index > 0) {

					if (!wsSWIFT.equals(payment.getStrPSWIFT().trim())
							|| !wsACCOUNT.equals(payment.getStrPRAccount().trim())
							|| !wsPNAME.replace('　', ' ').trim().equals(payment.getStrPName().replace('　', ' ').trim())
							|| !wsENTRYUSR.equals(payment.getStrEntryUsr().trim())
							|| !wsPENGNAME.replace('　', ' ').trim().equals(payment.getStrPENGNAME().replace('　', ' ').trim())
							|| !wsPBKBRCH.replace('　', ' ').trim().equals(payment.getStrPBKBRCH().replace('　', ' ').trim())
							|| !wsPBKCITY.replace('　', ' ').trim().equals(payment.getStrPBKCITY().replace('　', ' ').trim())
							|| !wsPPAYCURR.replace('　', ' ').trim().equals(payment.getStrPPAYCURR().replace('　', ' ').trim())
							|| wsFcTri != currFcTri) // R00386 傳統型與投資型 用的手續費不同, 分開算
					{
						wsFcTri = currFcTri;

						rmtVO.setBATNO(batNo);// 匯款批號
						rmtVO.setSEQNO(String.valueOf(ISeqNo));// 序號
						rmtVO.setPBK(PBANK.substring(0, 7));// 付款銀行
						rmtVO.setPACCT(PBANK.substring(8));// 付款帳號
						rmtVO.setRID(wsPID);// 受款人ID
						rmtVO.setRAMT(wsAMT);// 金額x(13)
						rmtVO.setRPCURR(wsRPCURR);// R70477 保單幣別
						// 匯費(公司負擔)SPUL保單投資起始日之前的支付件和客戶負擔匯費為0 ,BEN:中信自己會從支付金額扣款
						// R70088改為BEN->就是由客戶負擔,匯費為零
						// OUR->公司負擔,若為中信且SWIFTCODE=CTCBTW打頭者或配息匯費為零,其餘中信件匯費為500
						// 一銀100;花旗10us
						// R70455 if(wsPSYMBOL.equals("S") &&
						// (wsEntryDt<=wsPINVDT || wsPSRCCODE.equals("B8"))){
						// R00440 SN滿期金 if(wsPSYMBOL.equals("S") &&
						// (wsEntryDt<=wsPINVDT || wsPSRCCODE.equals("B8") ||
						// wsPSRCCODE.equals("B9"))){
						if (wsPSYMBOL.equals("S")
								&& (wsEntryDt <= wsPINVDT
										|| wsPSRCCODE.equals("BB")
										|| wsPSRCCODE.equals("B8") 
										|| wsPSRCCODE.equals("B9"))) 
						{// R00440 SN滿期金
							wsSWITCH = "Y";
						} else {
							wsSWITCH = "";
						}
						if (wsPAYFEEWAY.equals("OUR") || wsPAYFEEWAY.equals("SHA")) {
							try {
								//RD0440:新增外幣指定銀行-台灣銀行
								if(PBANK.substring(0, 3).equals("004")) {
									//rmtVO.setRMTFEE((int) disBBean.getPayFee004(payment.getStrPBBank(), wsBANK, wsACCOUNT, wsAMT, PCSHCM));
									rmtVO.setRMTFEE((int) disBBean.getPayFee004(payment.getStrPBBank(), wsBANK, wsACCOUNT, wsAMT, PCSHCM, wsPPAYCURR, wsRPAYRATE));
								}else{
									rmtVO.setRMTFEE((int) disBBean.getPayFee(payment.getStrPBBank(), wsBANK, wsACCOUNT));
								}	
							} catch (RemittanceFeeNotFoundException e) {
								rmtVO.setRMTFEE((int) disBBean.getPFee(payment.getStrPBBank().trim(), wsBANK, wsAMT, payment.getStrPMethod().trim(), wsSWIFT, wsSWITCH));
							}
						} else {
							rmtVO.setRMTFEE((int) 0);
						}
						rmtVO.setENTRYDT(updateDate);// 輸入日期
						rmtVO.setENTRYTM(updateTime);// 輸入時間
						// 客戶負擔匯費R70088
						if (wsPAYFEEWAY.equals("BEN")) {
							// try{
							// wsRBENFEE = disBBean.getPayFee(
							// payment.getStrPBBank(), wsBANK, wsACCOUNT );
							// }catch( RemittanceFeeNotFoundException e ) {
							// wsRBENFEE = (double)
							// disBBean.getPFeeBEN(payment.getStrPBBank().trim(),
							// wsRPAYRATE);
							rmtVO.setRMTFEE(0);
							wsRBENFEE = 0;
						}

						//QA0281 付款銀行為一銀時有手續費產生
						if(PBANK.substring(0, 3).equals("007")) {
							try {
								rmtVO.setRMTFEE((int) disBBean.getPayFee(payment.getStrPBBank(), wsBANK, wsACCOUNT));
							} catch (RemittanceFeeNotFoundException e) {
								rmtVO.setRMTFEE((int) disBBean.getPFee(payment.getStrPBBank().trim(), wsBANK, wsAMT, payment.getStrPMethod().trim(), wsSWIFT, wsSWITCH));
							}
						}

						wsRBENFEE = 0;
						rmtVO.setRBENFEE(wsRBENFEE);
						rmtVO.setRPAYRATE(wsRPAYRATE);

						rmtVO.setRPAYFEEWAY(wsPAYFEEWAY);// 手續費付款方式
						rmtVO.setRPAYAMT(wsRPAYAMT);// 外幣金額加總
						rmtVO.setRPAYCURR(wsPPAYCURR);// 外幣幣別
						rmtVO.setSWIFTCODE(wsSWIFT); // SWIFT CODE
						rmtVO.setPENGNAME(wsPENGNAME);// 英文姓名
						rmtVO.setRBKBRCH(wsPBKBRCH); // 分行
						rmtVO.setRBKCITY(wsPBKCITY);// 城市
						rmtVO.setRBKCOUNTRY(wsPCOUNTRY);// 國別
						// System.out.println("0wsRPAYAMT="+wsRPAYAMT);
						/* 前面相同的加總資料 */
						dao.insertRMTF(rmtVO);

						rmtVO = new CaprmtfVO();
						rmtVO = prepareData(payment);
						wsAMT = 0;
						wsAMT += payment.getIPAMT();
						// System.out.println("1wsRPAYAMT="+wsRPAYAMT);
						// System.out.println("1payment.getIPPAYAMT()="+payment.getIPPAYAMT());
						wsRPAYAMT = 0;// R70088
						// R70455先四捨五入再加總 wsRPAYAMT += payment.getIPPAYAMT();//外幣金額
						wsTEMPamt = disBBean.DoubleRound(payment.getIPPAYAMT(), 2);
						wsRPAYAMT = disBBean.DoubleAdd(wsRPAYAMT, wsTEMPamt);// R70455  外幣金額
						// System.out.println("2wsRPAYAMT="+wsRPAYAMT);
						// 序號
						ISeqNo += 1;

						wsSWIFT = payment.getStrPSWIFT().trim();// SWIFT CODE
						wsBANK = payment.getStrPRBank();
						wsACCOUNT = payment.getStrPRAccount().trim();
						wsPNAME = payment.getStrPName().replace('　', ' ').trim();
						wsPID = payment.getStrPId().trim();// R70088
						wsENTRYUSR = payment.getStrEntryUsr().trim();
						wsPAYFEEWAY = payment.getStrPFEEWAY();// 外幣加入收續費支付方式
						wsPPAYCURR = payment.getStrPPAYCURR(); // 匯出幣別
						wsPENGNAME = payment.getStrPENGNAME();// 英文姓名
						wsPBKBRCH = payment.getStrPBKBRCH();// 分行
						wsPBKCITY = payment.getStrPBKCITY(); // 城市
						wsPCOUNTRY = payment.getStrPBKCOTRY();// 國別
						wsRPAYRATE = payment.getIPPAYRATE();// 外幣匯率R70088
						wsPSRCCODE = payment.getStrPSrcCode().trim();// 支付原因碼R70088
						wsEntryDt = payment.getIEntryDt();// 輸入日期R70088
						wsRPCURR = payment.getStrPCurr(); // R70477保單幣別
					} else {
						wsAMT += payment.getIPAMT();
						// System.out.println("3wsRPAYAMT="+wsRPAYAMT);
						// System.out.println("3payment.getIPPAYAMT()="+payment.getIPPAYAMT());
						// R70455先四捨五入再加總 wsRPAYAMT += payment.getIPPAYAMT();
						wsTEMPamt = disBBean.DoubleRound(payment.getIPPAYAMT(), 2);
						wsRPAYAMT = disBBean.DoubleAdd(wsRPAYAMT, wsTEMPamt);// R70455 外幣金額
						// System.out.println("4wsRPAYAMT="+wsRPAYAMT);
						/*
						 * 0:OUR, 1:SHA, 2:BEN 如手續費收費方式不同時的決定規則 , OUR --> SHA
						 * -->BEN
						 */
						if (getPayFeeWaySeq(wsPAYFEEWAY) < getPayFeeWaySeq(payment.getStrPFEEWAY())) {
							wsPAYFEEWAY = payment.getStrPFEEWAY();
						}
						wsFcTri = currFcTri;
					}
				}

				// 寫入log檔
				disBBean.insertCAPPAYFLOG(payment.getStrPNO(), logonUser, updateDate, updateTime);

				count += dao.update(payment, String.valueOf(ISeqNo));
				amt += payment.getIRmtFee() + payment.getIPAMT();
				// R70455 RPAYamt += payment.getIPPAYAMT();
				wsTEMPamt = disBBean.DoubleRound(payment.getIPPAYAMT(), 2);
				RPAYamt = disBBean.DoubleAdd(RPAYamt, wsTEMPamt);// R70455 外幣金額

				//R10190 將外幣失效保單的匯款資訊寫入失效給付通知書工作檔 
				if(payment.getStrPMethod() != null && payment.getStrPMethod().equals("D") && payment.getStrPSrcCode() != null && payment.getStrPSrcCode().equals("CE")) {
					lapsePayVO = new LapsePaymentVO();
					lapsePayVO.setPNO(payment.getStrPNO());				//支付序號
					lapsePayVO.setPolicyNo(payment.getStrPolicyNo());	//保單號碼
					lapsePayVO.setReceiverId(payment.getStrPId());		//受款人ID
					lapsePayVO.setReceiverName(payment.getStrPName());	//受款人姓名
					lapsePayVO.setPaymentAmt(payment.getIPAMT());		//給付金額
					lapsePayVO.setRemitDate(iPCSHCM);					//出納確認日
					lapsePayVO.setSendSwitch("Y");						//是否寄送
					lapsePayVO.setRemitFailed("N" );					//已寄送，但退匯
					lapsePayVO.setSendDate(0);							//寄送日期
					lapsePayVO.setUpdatedUser(logonUser);				//異動者
					lapsePayVO.setUpdatedDate(updateDate);				//異動日期

					listlapsePay.add(lapsePayVO);
				}

			}//end for

			rmtVO.setBATNO(batNo);// 匯款批號
			rmtVO.setSEQNO(String.valueOf(ISeqNo));
			rmtVO.setPBK(PBANK.substring(0, 7));// 付款銀行
			rmtVO.setPACCT(PBANK.substring(8));// 付款帳號
			rmtVO.setRID(wsPID);// 受款人ID
			rmtVO.setRAMT(wsAMT);// 金額x(13)
			rmtVO.setRPCURR(wsRPCURR);// R70477 保單幣別
			// 匯費 SPUL保單投資起始日之前的支付件 匯費為0
			// R70088改為BEN->就是由客戶負擔,匯費為零
			// OUR->公司負擔,若為中信且SWIFTCODE=CTCBTW打頭者匯費為零,其餘中信件匯費為500
			// 一銀100;花旗10us
			// R70455 if(wsPSYMBOL.equals("S") && (wsEntryDt<=wsPINVDT ||
			// wsPSRCCODE.equals("B8"))){
			// R00440 SN滿期金 if(wsPSYMBOL.equals("S") && (wsEntryDt<=wsPINVDT ||
			// wsPSRCCODE.equals("B8") || wsPSRCCODE.equals("B9")) ){
			if (wsPSYMBOL.equals("S")
					&& (wsEntryDt <= wsPINVDT 
							|| wsPSRCCODE.equals("BB")
							|| wsPSRCCODE.equals("B8") 
							|| wsPSRCCODE.equals("B9"))) 
			{// R00440 SN滿期金
				wsSWITCH = "Y";
			} else {
				wsSWITCH = "";
			}
			// R70477外幣保單, 同行相轉, 匯款手續費擔方式變更為OUR
			if (wsPSYMBOL.equals("D") && wsBANK.substring(0, 3).equals(PBANK.substring(0, 3))) {
				wsPAYFEEWAY = "OUR";
			}
			if (wsPAYFEEWAY.equals("OUR") || wsPAYFEEWAY.equals("SHA")) {
				try {
					//RD0440:新增外幣指定銀行-台灣銀行
					if(PBANK.substring(0, 3).equals("004")) {
						//rmtVO.setRMTFEE((int) disBBean.getPayFee004(PBANK.substring(0, 7), wsBANK, wsACCOUNT, wsAMT, PCSHCM));
						rmtVO.setRMTFEE((int) disBBean.getPayFee004(PBANK.substring(0, 7), wsBANK, wsACCOUNT, wsAMT, PCSHCM, wsPPAYCURR, wsRPAYRATE));
					}else{
						rmtVO.setRMTFEE((int) disBBean.getPayFee(PBANK.substring(0, 7), wsBANK, wsACCOUNT));
					}					
				} catch (RemittanceFeeNotFoundException e) {
					rmtVO.setRMTFEE((int) disBBean.getPFee(PBANK.substring(0, 7), wsBANK, wsAMT, PMETHOD, wsSWIFT, wsSWITCH));
				}
			} else {
				rmtVO.setRMTFEE((int) 0);
			}
			
			rmtVO.setENTRYDT(updateDate);// 輸入日期
			rmtVO.setENTRYTM(updateTime);// 輸入時間
			// 客戶負擔匯費R70088
			if (wsPAYFEEWAY.equals("BEN")) {
				// try{
				// wsRBENFEE = disBBean.getPayFee( PBANK.substring(0,7), wsBANK,
				// wsACCOUNT );
				rmtVO.setRMTFEE(0);
				wsRBENFEE = 0;
				// }catch( RemittanceFeeNotFoundException e ) {
				// wsRBENFEE = (double) disBBean.getPFeeBEN(
				// PBANK.substring(0,7), wsRPAYRATE);
			}

			//QA0281 付款銀行為一銀時有手續費產生
			if(PBANK.substring(0, 3).equals("007")) {
				try {
					rmtVO.setRMTFEE((int) disBBean.getPayFee(PBANK.substring(0, 7), wsBANK, wsACCOUNT));
				} catch (RemittanceFeeNotFoundException e) {
					rmtVO.setRMTFEE((int) disBBean.getPFee(PBANK.substring(0, 7), wsBANK, wsAMT, PMETHOD, wsSWIFT, wsSWITCH));
				}
			}		

			wsRBENFEE = 0;
			rmtVO.setRBENFEE(wsRBENFEE);
			rmtVO.setRPAYRATE(wsRPAYRATE);

			// System.out.println("5wsRPAYAMT="+wsRPAYAMT);
			rmtVO.setRPAYFEEWAY(wsPAYFEEWAY);// 手續費付款方式
			rmtVO.setRPAYAMT(wsRPAYAMT);// 外幣金額加總
			rmtVO.setRPAYCURR(wsPPAYCURR);// 外幣幣別
			rmtVO.setSWIFTCODE(wsSWIFT); // SWIFT CODE
			rmtVO.setPENGNAME(wsPENGNAME);// 英文姓名
			rmtVO.setRBKBRCH(wsPBKBRCH); // 分行
			rmtVO.setRBKCITY(wsPBKCITY);// 城市
			rmtVO.setRBKCOUNTRY(wsPCOUNTRY);// 國別

			/* 最後一筆的彙總資料 */
			dao.insertRMTF(rmtVO);

			//R10190 將外幣失效保單的匯款資訊寫入失效給付通知書工作檔
			if(!listlapsePay.isEmpty()) {
				Connection conn = dbFactory.getAS400Connection("DISBRemitDisposeServlet.updateD");
				for(Iterator it=listlapsePay.iterator(); it.hasNext();) {
					disBBean.callCAP0314O(conn, ((LapsePaymentVO) it.next()));
				}
				dbFactory.releaseAS400Connection(conn);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dao.removeConn();
		}

		request.setAttribute("count", String.valueOf(count));	// 匯款筆數
		request.setAttribute("amt", String.valueOf(amt));		// 匯款總金額
		request.setAttribute("RPAYAMT", df.format(RPAYamt));	// 外幣匯款總金額
		request.setAttribute("batNo", batNo);	// 匯款批號
	}

	/**
	 * @param wsPAYFEEWAY
	 * @return
	 */
	private int getPayFeeWaySeq(String wsPAYFEEWAY) {
		int iFeeWay = 0;
		if (wsPAYFEEWAY.equals("OUR")) {
			iFeeWay = 0;
		} else if (wsPAYFEEWAY.equals("SHA")) {
			iFeeWay = 1;
		} else if (wsPAYFEEWAY.equals("BEN")) {
			iFeeWay = 2;
		}
		return 0;
	}

	private CaprmtfVO prepareData(DISBPaymentDetailVO payment) throws Exception {
		
		CaprmtfVO rmtVO = new CaprmtfVO();
		rmtVO.setRID("");// 受款人ID
		rmtVO.setRTYPE(payment.getStrPRBank() != null && payment.getStrPRBank().startsWith("822") ? "01" : "11");// 匯款種類
		// ?款行 匯款行,x(3)@todo
		String entBank = "";
		if (payment.getStrPRBank() != null && payment.getStrPRBank().length() >= 7) {
			entBank = payment.getStrPRBank().substring(0, 7);
		}
		for (int Ecount = entBank.length(); Ecount < 7; Ecount++) {
			entBank = "0" + entBank;
		}
		rmtVO.setRBK(entBank);
		// 收款人帳號x(14)
		if (payment.getStrPRAccount() == null) {
			rmtVO.setRACCT("");
		} else if (payment.getStrPRAccount().length() > 14) {
			rmtVO.setRACCT(payment.getStrPRAccount().substring(0, 14));
		} else {
			rmtVO.setRACCT(payment.getStrPRAccount());
		}

		// rmtVO.setRACCT(payment.getStrPRAccount()==null?"":payment.getStrPRAccount());

		// 收款人戶名x(80) 因為戶名為全形 所以entName.length()*2 @R90735
		String entName = payment.getStrPName() == null ? "" : payment.getStrPName().replace('　', ' ').trim();
		for (int Ecount = entName.getBytes().length; Ecount < 80; Ecount++) {
			entName = entName + " ";
		}
		rmtVO.setRNAME(entName);
		rmtVO.setMEMO("");// 附註
		// 匯款日期x(6)
		/* R60747 匯款日期由出納日期PCshDt改為出納確認日PCSHCM Start */
		// String remitDate = String.valueOf(payment.getIPCshDt());
		String remitDate = String.valueOf(payment.getIPCSHCM());
		/* R60747 匯款日期由出納日期PCshDt改為出納確認日PCSHCM End */

		for (int Ecount = remitDate.length(); Ecount < 6; Ecount++) {
			remitDate = "0" + remitDate;
		}
		rmtVO.setRMTDT(remitDate);

		rmtVO.setRTRNCDE("");// 交易檢核馬x(4)
		rmtVO.setRTRNTM("");// 傳送次數x(3)
		rmtVO.setCSTNO("");// 客戶傳票號碼x(10)
		rmtVO.setRMTCDE("");// 匯費負擔區別馬x(1)
		rmtVO.setENTRYUSR(payment.getStrEntryUsr());// 輸入者
		return rmtVO;
	}

	// Clean up resources
	public void destroy() {
	}

}