package com.aegon.disb.disbmaintain;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.StringTool;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * System   : CASHWEB
 * 
 * Function : 應收帳款逾二年轉其他收入
 * 
 * Remark   : 出納功能
 * 
 * Revision : $$Revision: 1.4 $$
 * 
 * Author   : Odin Tsai
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R80413
 * 
 * CVS History:
 * 
 * $$Log: DISBFinTransToOther.java,v $
 * $Revision 1.4  2014/03/05 08:05:39  MISSALLY
 * $R00135---PA0024---CASH年度專案-04
 * $修正銀行帳號已停用導致分錄資料產生不完整
 * $
 * $Revision 1.3  2010/11/23 06:31:02  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.2  2009/11/19 03:13:19  missteven
 * $Q90528 應收帳款修改為未達帳
 * $
 * $Revision 1.1  2008/10/31 09:47:36  MISODIN
 * $R80413_應收帳款逾期轉其他收入
 * $
 * $$
 *  
 */

public class DISBFinTransToOther extends InitDBServlet {

	private static final long serialVersionUID = 2730286314377303685L;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

	private DecimalFormat df2 = new DecimalFormat("0.00");
	private DecimalFormat df3 = new DecimalFormat("0.0000"); //R80338 匯率	
	
	private SimpleDateFormat sdfDate = new SimpleDateFormat("yyyyMMdd",java.util.Locale.TAIWAN) ;
	private SimpleDateFormat sdfTime = new SimpleDateFormat("HHmmss",java.util.Locale.TAIWAN) ;

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
		try {
			this.downloadProcess(request, response);
			this.updateProcess(request, response);
		} catch (Exception e) {
			System.err.println(e.toString());
			request.setAttribute("txtMsg", e.getMessage());

			RequestDispatcher dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBFinTransToOther.jsp");
			dispatcher.forward(request, response);
		}
	}

	private void updateProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception{
		System.out.println("inside updateProcess");

		Connection con = dbFactory.getAS400Connection("DISBFinTransToOther.update");
		PreparedStatement pstmtTmp = null;

		DISBBean disbBean = new DISBBean(dbFactory);
		String strUpdateSql = null; // Update tUser 之SQL
		String strPStartDate = null;
		String strPStartDateTemp = null;
		int iPStartDate = 0;
		int iPStartDate2 = 0;
		int iPStartDate3 = 0;
		int currentDate = 0; 	// 系統日期yyyymmdd
		int currentTime = 0; 	// 系統時間hhmmss
		double iConverRate = 0;// 匯率
		String DateTemp1 = "";

		String strTransDate = null;

		Date now = commonUtil.getBizDateByRDate();

		currentDate = Integer.parseInt(sdfDate.format(now), 10) - 19110000;
		currentTime = Integer.parseInt(sdfTime.format(now), 10);

		strPStartDate = request.getParameter("para_PStartDate");
		if (strPStartDate != null)
			strPStartDate = strPStartDate.trim();
		else
			strPStartDate = "";

		if (strPStartDate.length() < 7) {
			strPStartDateTemp = "0" + strPStartDate;
		} else {
			strPStartDateTemp = strPStartDate;
		}
		iPStartDate = Integer.parseInt(strPStartDateTemp.substring(0, 7)); // 文字轉數字
		iPStartDate2 = iPStartDate - 20000; // 減 2年
		iPStartDate3 = iPStartDate + 1110000; // 970930 --> 2080930

		strTransDate = request.getParameter("txtTransDate");
		if (strTransDate != null)
			strTransDate = strTransDate.trim();
		else
			strTransDate = "";

		// 本次轉其他收入
		strUpdateSql = "update CAPCSHF set EAEGDT = ?,ECRDAY=?,CSHFUD=?,CSHFUT=?,CROTYPE=?,CSHFPOCURR=? ";
		strUpdateSql += "where EAEGDT = 0 and EBKRMD < ? ";

		pstmtTmp = con.prepareStatement(strUpdateSql);
		pstmtTmp.setInt(1, iPStartDate);
		pstmtTmp.setInt(2, currentDate);
		pstmtTmp.setInt(3, currentDate);
		pstmtTmp.setInt(4, currentTime);
		pstmtTmp.setString(5, "T");
		pstmtTmp.setString(6, "NT");
		pstmtTmp.setInt(7, iPStartDate2);

		System.out.println(" update counts=" + pstmtTmp.executeUpdate());

		pstmtTmp.close();
		// ---------------------------------------------------------------------------------------------
		// 最新匯率更新
		List alCurrCash = new ArrayList();
		alCurrCash = (List) disbBean.getETable("CURR", "CASH");

		if (alCurrCash.size() > 0) {
			for (int i = 0; i < alCurrCash.size(); i++) {
				Hashtable htCurrCashTemp = (Hashtable) alCurrCash.get(i);
				String strETValue = (String) htCurrCashTemp.get("ETValue");
				strUpdateSql = null;
				strUpdateSql = "update CAPCSHF set CERRATE=? ";
				strUpdateSql += "where CROTYPE= 'T'  and CSHFCURR = '" + strETValue.trim() + "'";

				DateTemp1 = Integer.toString(iPStartDate3);
				if (strETValue.trim().equals("NT")) {
					iConverRate = 1;
				} else {
					iConverRate = disbBean.getERRate(strETValue.trim(), DateTemp1, "B");
				}
				System.out.println("iConverRate=" + iConverRate);

				pstmtTmp = con.prepareStatement(strUpdateSql);

				pstmtTmp.setDouble(1, iConverRate);
				System.out.println(" update counts2=" + pstmtTmp.executeUpdate());
				pstmtTmp.close();
			}
		} // alCurrCash.size() > 0
		// -------------------------------------------------------------------------------------------------------
		// 換算台幣
		// 因為以 CENTAMTNT= ENTAMT * ? 的方式會造成 ENTAMT ( 小數 2 ) X ? ( 小數 4 ) = ( 小數
		// 2 )
		// 所以台幣換算獨立出來做
		strUpdateSql = null;
		strUpdateSql = "update CAPCSHF set CENTAMTNT= ENTAMT * CERRATE ";
		strUpdateSql += "where CROTYPE= 'T' ";

		pstmtTmp = con.prepareStatement(strUpdateSql);

		System.out.println(" update counts3=" + pstmtTmp.executeUpdate());

		pstmtTmp.close();

	}  // updateProcess
	
	private void downloadProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception{
		System.out.println("inside downloadProcess");
		List alDwnDetails = new ArrayList();

		alDwnDetails = (List) getNormalPayments(request, response, alDwnDetails);
		System.out.println("alDwnDetails=" + alDwnDetails.size());

		if (alDwnDetails.size() > 0) {
			ServletOutputStream os = response.getOutputStream();
			try {

				/* ConvertData */
				response.setContentType("text/plain");
				response.setHeader("Content-Disposition", "attachment; filename=AccFinTransToOther.txt");
				String export = "";
				for (int i = 0; i < alDwnDetails.size(); i++) {
					DISBAccCodeDetailVO objAccCodeDetail = (DISBAccCodeDetailVO) alDwnDetails.get(i);
					String strActCd1 = null;
					String strActCd2 = null;
					String strActCd3 = null;
					String strActCd4 = null;
					String strActCd5 = null;
					String strDesc = null;
					String strSlipNo = null;
					String strDAmt = null;
					String strCAmt = null;
					String strPCfmDt = null;
					String strPAYCurrency = null;
					String strConverRate = null;

					strPAYCurrency = objAccCodeDetail.getStrCurr();

					strActCd1 = objAccCodeDetail.getStrActCd1();
					for (int count = strActCd1.length(); count < 5; count++) {
						strActCd1 += " ";
					}

					strActCd2 = objAccCodeDetail.getStrActCd2();
					for (int count = strActCd2.length(); count < 6; count++) {
						strActCd2 += " ";
					}

					strActCd3 = objAccCodeDetail.getStrActCd3();
					for (int count = strActCd3.length(); count < 4; count++) {
						strActCd3 += " ";
					}

					strActCd4 = objAccCodeDetail.getStrActCd4();
					for (int count = strActCd4.length(); count < 4; count++) {
						strActCd4 += " ";
					}

					strActCd5 = objAccCodeDetail.getStrActCd5();
					for (int count = strActCd5.length(); count < 3; count++) {
						strActCd5 += " ";
					}

					strPCfmDt = objAccCodeDetail.getStrDate1();
					for (int count = strPCfmDt.length(); count < 10; count++) {
						strPCfmDt += " ";
					}
					strDAmt = objAccCodeDetail.getStrDAmt();
					for (int count = strDAmt.length(); count < 13; count++) {
						strDAmt = " " + strDAmt;
					}

					strCAmt = objAccCodeDetail.getStrCAmt();
					for (int count = strCAmt.length(); count < 13; count++) {
						strCAmt = " " + strCAmt;
					}

					// DESCRIPTION,x(30) 因為中文的問題, 所以長度需用strDesc.getBytes().length取得
					strDesc = objAccCodeDetail.getStrDesc() == null ? "" : objAccCodeDetail.getStrDesc();
					strDesc = CommonUtil.AllTrim(strDesc);
					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}

					strSlipNo = objAccCodeDetail.getStrSlipNo();
					for (int count = strSlipNo.length(); count < 15; count++) {
						strSlipNo += " ";
					}

					strConverRate = objAccCodeDetail.getStrConverRate();
					for (int count = strConverRate.length(); count < 7; count++) {
						strConverRate = " " + strConverRate;
					}

					export += "Manual";// Category, x(06)
					export += "Spreadsheet";// Source,x(11)
					export += strPAYCurrency;// Currency,x(03), 幣別
					export += "0";// ACTCD1,x(1)
					export += strActCd2;// ACTCD2,x(06) , 幣別
					export += strActCd1;// ACTCD2,x(05) 00ZZZ,90ZZZ
					export += strActCd3;// ACTCD3,x(04) , 銀行別
					export += strActCd4;// ACTCD4,x(04)
					export += "000000000000000";
					export += "000";
					export += "0";
					export += "00";
					export += strActCd5; // ACTCD5,x(03), 幣別
					export += strPCfmDt;// 執行日,YYYY/MM/DD,x(10)
					export += strCAmt;// 借方金額,x(12),預設為0,不足前補空白, 000,000.00
					export += strDAmt;// 貸方金額,x(12),預設為0,不足前補空白, 000,000.00
					export += strSlipNo;// SlipNo,x(15), 執行日之西元年後二碼+MMDD + 3個特定碼 + 保單幣別 + 3 碼空白
					export += strDesc;// Description ,x(30),不足後補空白
					export += "User";
					export += strConverRate;// 1/ 匯率 = 00.1234
					export += strSlipNo;

					if (i < alDwnDetails.size() - 1)
						export += ((char) 13);// 換行
				}
				ByteArrayInputStream is = new ByteArrayInputStream(export.getBytes());
				int reader = 0;
				byte[] buffer = new byte[1 * 1024];
				while ((reader = is.read(buffer)) > 0) {
					os.write(buffer, 0, reader);
				}
			} catch (Exception e) {
				System.err.println(e.toString());
				throw e;
			} finally {
				os.flush();
				os.close();
			}
		} else {
			// 查無資料回傳錯誤訊息
			request.setAttribute("txtMsg", "查無可下載資料,請重新查明!");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBFinTransToOther.jsp");
			dispatcher.forward(request, response);
		}
	}

	private List getNormalPayments(HttpServletRequest request, HttpServletResponse response,List alDwnDetails) {
		Connection con = dbFactory.getAS400Connection("DISBFinTransToOther.getNormalPayments()");

		DISBBean disbBean = new DISBBean(dbFactory);
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		List alReturn = new ArrayList();
		List alReturnTemp = new ArrayList(); // 反轉分錄暫存區
		String strPStartDate = "";
		String strPStartDateTemp = "";
		String strTransDate = "";
		String strTransDateTemp = "";
		String strSlipCode = "";
		String DateTemp = ""; // 執行日--西元年
		String DateTemp1 = ""; // 執行日--民國年

		String strPPAYCURR_Keep_1 = "";
		String strPBK_Keep_1 = "";
		String strPACCT_Keep_1 = "";
		String strPPAYCURR_Keep_2 = "";
		String strPBK_Keep_2 = "";
		String strPACCT_Keep_2 = "";

		int iPStartDate = 0;
		int iPStartDate3 = 0;
		int iTransDate = 0;

		double iConverRate = 0; // 匯率

		double iPayAmt_NT = 0;
		double iPayAmt_TOT_1 = 0; // 金額
		double iPayAmt_TOT_2 = 0; // 金額

		strTransDate = request.getParameter("txtTransDate");
		if (strTransDate != null)
			strTransDate = strTransDate.trim();
		else
			strTransDate = "";

		if (strTransDate.length() < 7) {
			strTransDateTemp = "0" + strTransDate;
		} else {
			strTransDateTemp = strTransDate;
		}
		iTransDate = Integer.parseInt(strTransDateTemp.substring(0, 7)); // 文字轉數字

		strPStartDate = request.getParameter("para_PStartDate");
		if (strPStartDate != null)
			strPStartDate = strPStartDate.trim();
		else
			strPStartDate = "";

		if (strPStartDate.length() < 7) {
			strPStartDateTemp = "0" + strPStartDate;
		} else {
			strPStartDateTemp = strPStartDate;
		}
		iPStartDate = Integer.parseInt(strPStartDateTemp.substring(0, 7)); // 文字轉數字
		iPStartDate3 = iPStartDate + 1110000; // 970930 --> 2080930
		iPStartDate = iPStartDate - 20000; // 減 2年

		try {
			alReturn = alDwnDetails;

			strSql = null;

			strSql = "SELECT A.EBKCD AS EBKCD, A.EATNO AS EATNO, A.EBKRMD AS EBKRMD, A.ENTAMT AS ENTAMT, A.CSHFCURR AS CSHFCURR";
			strSql += " FROM CAPCSHF A";
			strSql += " WHERE 1=1 AND (A.EAEGDT = 0 OR A.CROTYPE='T') ";
			strSql += " AND A.EBKRMD < " + iPStartDate;
			// strSql += " ORDER BY EBKCD,EATNO,CSHFCURR";
			strSql += " ORDER BY CSHFCURR,EBKCD,EATNO";

			System.out.println("strSql_1_B" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);

			// 相同幣別帳號彙總成一筆, 外幣金額需換算成台幣

			while (rs.next()) {

				strPPAYCURR_Keep_1 = rs.getString("CSHFCURR");
				strPBK_Keep_1 = rs.getString("EBKCD");
				strPACCT_Keep_1 = rs.getString("EATNO");

				if (!strPPAYCURR_Keep_2.trim().equals(strPPAYCURR_Keep_1.trim())
						|| !strPBK_Keep_2.trim().equals(strPBK_Keep_1.trim())
						|| !strPACCT_Keep_2.trim().equals(strPACCT_Keep_1.trim())) 
				{
					// 金額彙總成一筆
					if (iPayAmt_TOT_1 > 0) {

						List alDwnDetails2 = new ArrayList();
						List alDwnDetails3 = new ArrayList(); // 反轉分錄
						iPayAmt_TOT_1 = Math.round(iPayAmt_TOT_1); // 四捨五入

						alDwnDetails2 = (List) getRAMTSumforD(strPPAYCURR_Keep_2, strPBK_Keep_2, strPACCT_Keep_2, iPStartDate, iPayAmt_TOT_1, alDwnDetails2);
						alDwnDetails3 = (List) getRAMTSumforD2(strPPAYCURR_Keep_2, strPBK_Keep_2, strPACCT_Keep_2, iTransDate, iPayAmt_TOT_1, alDwnDetails2); // 反轉分錄

						iPayAmt_TOT_2 = iPayAmt_TOT_2 + iPayAmt_TOT_1;
						iPayAmt_TOT_1 = 0;

						alReturn.addAll(alDwnDetails2);
						alReturnTemp.addAll(alDwnDetails3); // 反轉分錄
					} // 金額彙總成一筆

					strPPAYCURR_Keep_2 = strPPAYCURR_Keep_1;
					strPBK_Keep_2 = strPBK_Keep_1;
					strPACCT_Keep_2 = strPACCT_Keep_1;

				} // Keep_1 <> Keep_2
				// ---------------------------------------------------------------------------------------------------

				if (strPPAYCURR_Keep_1.trim().equals("NT")) {
					iConverRate = 1;
				} else {
					DateTemp1 = Integer.toString(iPStartDate3);
					iConverRate = disbBean.getERRate(strPPAYCURR_Keep_1.trim(), DateTemp1, "B");
				}

				iPayAmt_NT = rs.getDouble("ENTAMT") * iConverRate; // 金額換算成台幣
				// iPayAmt_NT= Math.round(iPayAmt_NT); // 四捨五入
				iPayAmt_TOT_1 = iPayAmt_TOT_1 + iPayAmt_NT;
				// iPayAmt_TOT_2= iPayAmt_TOT_2 + iPayAmt_NT;
			} // rs.next

			if (iPayAmt_TOT_1 > 0) {

				List alDwnDetails2 = new ArrayList();
				List alDwnDetails3 = new ArrayList(); // 反轉分錄
				iPayAmt_TOT_1 = Math.round(iPayAmt_TOT_1); // 四捨五入

				alDwnDetails2 = (List) getRAMTSumforD(strPPAYCURR_Keep_1, strPBK_Keep_1, strPACCT_Keep_1, iPStartDate, iPayAmt_TOT_1, alDwnDetails2);
				alDwnDetails3 = (List) getRAMTSumforD2(strPPAYCURR_Keep_1, strPBK_Keep_1, strPACCT_Keep_1, iTransDate, iPayAmt_TOT_1, alDwnDetails2); // 反轉分錄

				iPayAmt_TOT_2 = iPayAmt_TOT_2 + iPayAmt_TOT_1;

				alReturn.addAll(alDwnDetails2);
				alReturnTemp.addAll(alDwnDetails3); // 反轉分錄
			} // iPayAmt_TOT_1>0

			// 794410 彙總成一筆
			if (iPayAmt_TOT_2 > 0) {

				// 借方
				DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();

				objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));

				objAccCodeDetailM.setStrActCd2("794401");
				objAccCodeDetailM.setStrActCd1("90ZZZ");

				objAccCodeDetailM.setStrActCd3("0000");
				objAccCodeDetailM.setStrActCd4("0000");
				objAccCodeDetailM.setStrActCd5("000");

				DateTemp = Integer.toString(19110000 + iTransDate);
				objAccCodeDetailM.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
				objAccCodeDetailM.setStrCAmt(df2.format(iPayAmt_TOT_2));
				objAccCodeDetailM.setStrDAmt("0");
				strSlipCode = "230";
				objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");

				objAccCodeDetailM.setStrDesc("迴轉未達帳逾二年轉其他收入");// Q90574
				objAccCodeDetailM.setStrConverRate(df3.format(1));

				alReturnTemp.add(objAccCodeDetailM);
				// -----------------------------------------------------------------------------------------
				// 貸方

				DISBAccCodeDetailVO objAccCodeDetailM2 = new DISBAccCodeDetailVO();

				objAccCodeDetailM2.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));

				objAccCodeDetailM2.setStrActCd2("794401");
				objAccCodeDetailM2.setStrActCd1("90ZZZ");

				objAccCodeDetailM2.setStrActCd3("0000");
				objAccCodeDetailM2.setStrActCd4("0000");
				objAccCodeDetailM2.setStrActCd5("000");

				DateTemp = Integer.toString(19110000 + 20000 + iPStartDate); // 加回 2年 = 執行日
				objAccCodeDetailM2.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
				objAccCodeDetailM2.setStrCAmt("0");
				objAccCodeDetailM2.setStrDAmt(df2.format(iPayAmt_TOT_2));
				strSlipCode = "230";
				objAccCodeDetailM2.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");

				objAccCodeDetailM2.setStrDesc("未達帳逾二年轉其他收入");// Q90574
				objAccCodeDetailM2.setStrConverRate(df3.format(1));

				alReturn.add(objAccCodeDetailM2);

			} // iPayAmt_TOT_2>0

			alReturn.addAll(alReturnTemp);

			rs.close();

		} catch (SQLException ex) {
			System.err.println("ex" + ex);
			request.setAttribute("txtMsg", "查詢失敗" + ex);
			alReturn = null;
		} catch (Exception ex) {
			System.err.println("FinTransToOther.getNormalPayments() ex=" + ex);
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (stmt != null) {
					stmt.close();
				}
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			} catch (Exception ex1) {
			}
		}

		System.out.println("alReturn=" + alReturn.size());
		return alReturn;
	}

	private List getRAMTSumforD(String CURRENCY,String PBK,String PACCT,int PSTARTDATE,double PAYAMT1,List alDwnDetails2){
		List alReturn2 = new ArrayList();
		DISBBean disbBean = new DISBBean(dbFactory);
		String strBankCode = "";
		String strActCode3 = "";
		String strSlipCode = "";
		String DateTemp = "";

		// 借方
		DISBAccCodeDetailVO objAccCodeDetailM = new DISBAccCodeDetailVO();

		objAccCodeDetailM.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
		objAccCodeDetailM.setStrActCd1("00ZZZ");
		strBankCode = PBK.substring(0, 3);
		strActCode3 = getACTCDFinRmt(strBankCode, PACCT, CURRENCY);

		if (strBankCode.trim().equals("039") && PACCT.trim().equals("1375350")) {
			strActCode3 = "101720-003901";
		}

		objAccCodeDetailM.setStrActCd2(strActCode3.substring(0, 6));
		// System.out.println("BANK="+strBankCode+" ACCT= "+PACCT+" ActCode="+strActCode3);

		if (strBankCode.trim().equals("701")) {
			objAccCodeDetailM.setStrActCd3("700" + strActCode3.substring(12, 13));
		} else {
			objAccCodeDetailM.setStrActCd3(strBankCode + strActCode3.substring(12, 13));
		}

		objAccCodeDetailM.setStrActCd4("0000");
		objAccCodeDetailM.setStrActCd5("000");

		DateTemp = Integer.toString(19110000 + 20000 + PSTARTDATE); // 加回 2年 = 執行日
		objAccCodeDetailM.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
		objAccCodeDetailM.setStrCAmt(df2.format(PAYAMT1));
		objAccCodeDetailM.setStrDAmt("0");
		strSlipCode = "230";
		objAccCodeDetailM.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");

		objAccCodeDetailM.setStrDesc("未達帳逾二年轉其他收入");// Q90574
		objAccCodeDetailM.setStrConverRate(df3.format(1));

		alReturn2.add(objAccCodeDetailM);

		return alReturn2;
	}

	private List getRAMTSumforD2(String CURRENCY,String PBK,String PACCT,int PSTARTDATE,double PAYAMT1,List alDwnDetails2){
		List alReturn2 = new ArrayList();
		DISBBean disbBean = new DISBBean(dbFactory);
		String strBankCode = "";
		String strActCode3 = "";
		String strSlipCode = "";
		String DateTemp = "";

		// 貸方
		DISBAccCodeDetailVO objAccCodeDetailM2 = new DISBAccCodeDetailVO();

		objAccCodeDetailM2.setStrCurr(disbBean.getETableDesc("CURRA", "NT"));
		objAccCodeDetailM2.setStrActCd1("00ZZZ");
		strBankCode = PBK.substring(0, 3);
		strActCode3 = getACTCDFinRmt(strBankCode, PACCT, CURRENCY);

		if (strBankCode.trim().equals("039") && PACCT.trim().equals("1375350")) {
			strActCode3 = "101720-003901";
		}

		objAccCodeDetailM2.setStrActCd2(strActCode3.substring(0, 6));

		if (strBankCode.trim().equals("701")) {
			objAccCodeDetailM2.setStrActCd3("700" + strActCode3.substring(12, 13));
		} else {
			objAccCodeDetailM2.setStrActCd3(strBankCode + strActCode3.substring(12, 13));
		}

		objAccCodeDetailM2.setStrActCd4("0000");
		objAccCodeDetailM2.setStrActCd5("000");

		DateTemp = Integer.toString(19110000 + PSTARTDATE);
		objAccCodeDetailM2.setStrDate1(DateTemp.substring(0, 4) + "/" + DateTemp.substring(4, 6) + "/" + DateTemp.substring(6, 8));
		objAccCodeDetailM2.setStrCAmt("0");
		objAccCodeDetailM2.setStrDAmt(df2.format(PAYAMT1));
		strSlipCode = "230";
		objAccCodeDetailM2.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(4, 6) + DateTemp.substring(6, 8) + strSlipCode + "      ");

		objAccCodeDetailM2.setStrDesc("迴轉未達帳逾二年轉其他收入");// Q90574
		objAccCodeDetailM2.setStrConverRate(df3.format(1));

		alReturn2.add(objAccCodeDetailM2);
		// -------------------------------------------------------------------------------------------------

		return alReturn2;
	}

	private String getACTCDFinRmt(String strBankCode, String strBKAcctNo, String strCurrency) {
		String strACTCDFinRmt = "";
		String strSql = "";

		strSql = "SELECT GLACT ";
		strSql += " FROM CAPBNKF ";
		strSql += " WHERE BKCODE ='" + strBankCode + "' ";
		strSql += " AND BKATNO ='" + strBKAcctNo + "' ";
		strSql += " AND BKCURR ='" + strCurrency + "' ";

		Connection conDb = null;
		Statement stmtStatement = null;
		ResultSet rstResultSet = null;
		try {
			conDb = dbFactory.getAS400Connection("getACTCDFinRmt()");
			if (conDb != null) {
				stmtStatement = conDb.createStatement();
				rstResultSet = stmtStatement.executeQuery(strSql);
				if (rstResultSet.next()) {
					strACTCDFinRmt = (String) rstResultSet.getString("GLACT").replace('　', ' ').trim();
				}
				rstResultSet.close();
				stmtStatement.close();
			}
		} catch (Exception ex) {
			System.err.println("TransToOther.getACTCDFinRmt ex="+ex.getMessage());
			if (conDb != null)
				dbFactory.releaseAS400Connection(conDb);
		} finally {
			if (conDb != null) 
				dbFactory.releaseAS400Connection(conDb);
		}

		return strACTCDFinRmt;
	}

}
