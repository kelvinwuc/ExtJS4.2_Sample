package com.aegon.crooutbat;

/**
 * System   : CashWeb
 * 
 * Function : 整批銷帳處理
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.11 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date : $$Date: 2014/03/07 06:47:58 $$
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * $$Log: CroOutBatServlet.java,v $
 * $Revision 1.11  2014/03/07 06:47:58  MISSALLY
 * $R00135---PA0024---CASH年度專案-04
 * $修正銷GTMS銷到CAPSIL的
 * $
 * $Revision 1.10  2014/02/14 06:42:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---修正多對一時多筆不需銷帳的資料被銷到
 * $
 * $Revision 1.9  2014/02/11 09:05:48  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---修正多對一時多筆不需銷帳的資料被銷到
 * $
 * $Revision 1.8  2014/01/29 07:29:09  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---調整銷帳順序
 * $
 * $Revision 1.7  2014/01/28 10:31:47  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.6  2014/01/27 07:43:44  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.5  2014/01/24 07:11:58  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix
 * $
 * $Revision 1.4  2014/01/21 10:14:31  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---修正資料重覆問題
 * $
 * $Revision 1.3  2014/01/17 06:45:46  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---欄位不match
 * $
 * $Revision 1.2  2014/01/15 07:23:50  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---GTMS條件不用保單幣別
 * $
 * $Revision 1.1  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $$
 *  
 */

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;

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

import org.apache.log4j.Logger;

public class CroOutBatServlet extends InitDBServlet {
       
	private static final long serialVersionUID = 1464047546454134796L;
	
	private Logger log = Logger.getLogger(getClass());

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		String strMsg = "";

		HttpSession session = request.getSession(true);
		
		/* 接收前端的參數 */
		String strEAEGDT = (request.getParameter("txtEAEGDT") == null) ? "" : request.getParameter("txtEAEGDT");//全球人壽入帳日
		int iEAEGDT = (strEAEGDT.equals("")) ? 0 : Integer.parseInt(strEAEGDT);
		String strCROTYPE = (request.getParameter("selCROTYPE") == null) ? "" : request.getParameter("selCROTYPE");
		String strPOCURR = (request.getParameter("txtPOCURR") == null) ? "" : request.getParameter("txtPOCURR");

		String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
		String strUpdDate = strDateTime.substring(0, 7);
		String strUpdTime = "";
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		// CAPCSHFB 預備核銷檔
		String strSelectCAPCSHFBSQL = " SELECT CBKCD,CATNO,CBKRMD,CAEGDT,CSFBCURR,SUM(CROAMT) as sumCROAMT FROM CAPCSHFB ";
		//strSelectCAPCSHFBSQL += "WHERE CRODAY=0 AND CROSRC NOT IN ('2','3','4','8','F','G','H') AND CAEGDT=" + iEAEGDT;
		strSelectCAPCSHFBSQL += "WHERE CRODAY=0 AND (CROSRC NOT IN ('2','3','4','8','F','G','H') OR (CROSRC='4' AND CSFBAU='CAP1185BW')) AND CAEGDT=" + iEAEGDT;//EE0090:20160729,新增全國繳費網為可銷帳
		if(strCROTYPE.equals("G")) {
			strSelectCAPCSHFBSQL += " AND CROSRC='9' ";
		} else {
			strSelectCAPCSHFBSQL += " AND CROSRC<>'9' ";
			if(!strPOCURR.equals(""))    //R80338
				strSelectCAPCSHFBSQL += " AND CSFBPOCURR='" + strPOCURR + "' ";
		}
		strSelectCAPCSHFBSQL += "group by CBKCD,CATNO,CBKRMD,CAEGDT,CSFBCURR ";
		strSelectCAPCSHFBSQL += "order by CBKCD,CATNO,CBKRMD,CAEGDT,CSFBCURR " ;
		System.out.println("strSelectCAPCSHFBSQL="+strSelectCAPCSHFBSQL);
		log.info("strSelectCAPCSHFBSQL="+strSelectCAPCSHFBSQL);

		//String strQryCAPCSHFBSQL = " SELECT * FROM CAPCSHFB WHERE CRODAY=0 and CROSRC NOT IN ('2','3','4','8','F','G','H') and CBKCD=? AND CATNO=? AND CSFBCURR=? AND CBKRMD=? ";
		String strQryCAPCSHFBSQL = " SELECT * FROM CAPCSHFB WHERE CRODAY=0 and (CROSRC NOT IN ('2','3','4','8','F','G','H') OR (CROSRC='4' AND CSFBAU='CAP1185BW')) and CBKCD=? AND CATNO=? AND CSFBCURR=? AND CBKRMD=? "; //EE0090:20160729,新增全國繳費網為可銷帳
		if(strCROTYPE.equals("G")) {
			strQryCAPCSHFBSQL += " AND CROSRC='9' ";
		} else {
			strQryCAPCSHFBSQL += " AND CROSRC<>'9' ";
		}
		strQryCAPCSHFBSQL += " ORDER BY CBKCD,CATNO,CBKRMD,CAEGDT,CROAMT ";

		// 以 CAPCSHFB chain CAPCSHF 登帳檔
		String strQryCAPCSHFSQL = " SELECT * FROM CAPCSHF WHERE ECRDAY=0 and EBKCD=? AND EATNO=? AND CSHFCURR=? AND EBKRMD=? ORDER BY EBKCD,EATNO,EBKRMD,ENTAMT ";

		// 利用憑證檔找出對應關係
		String strQryByCertificateSQL = " select * from CAPCSHF a JOIN CAPBNKF c ON c.BKCODE=a.EBKCD and c.BKATNO=a.EATNO and c.BKCURR=a.CSHFCURR "
								+ "JOIN ORGNFBM d ON d.FBMACTBNK=c.BKALAT and d.FBMACTDT=a.EBKRMD and d.FBMFACAMT=a.ENTAMT "
								+ "JOIN ORGNFBDK1 e ON e.FBDNO=d.FBMNO "
								+ "JOIN CAPCSHFBK1 b ON b.CSFBRECTNO=e.FBDREPNO and b.CSFBRECSEQ=e.FBDREPSEQ and b.CROAMT<>a.ENTAMT "
								+ "WHERE a.ECRDAY=0 and b.CRODAY=0 ";
		if(iEAEGDT > 0) {
			strQryByCertificateSQL += "and b.CAEGDT=" + iEAEGDT + " ";
		}
		if(strCROTYPE.equals("G")) {
			strQryByCertificateSQL += "and b.CROSRC='9' ";
		} else {
			strQryByCertificateSQL += "and b.CROSRC<>'9' ";
		}
		if(!strPOCURR.equals("")) {
			strQryByCertificateSQL += "and b.CSFBPOCURR='" + strPOCURR + "' ";
		}
		strQryByCertificateSQL += "ORDER BY a.EBKCD,a.EATNO,a.EBKRMD,d.FBMNO,a.CSHFCURR,a.ENTAMT,b.CROAMT ";
		System.out.println("strQryByCertificateSQL="+strQryByCertificateSQL);
		log.info("strQryByCertificateSQL="+strQryByCertificateSQL);

		// UPDATE CAPCSHF 登帳檔
		String strUpdateCAPCSHFSQL = " UPDATE CAPCSHF SET EAEGDT=?,ECRDAY=?,CSHFUU=?,CSHFUD=?,CSHFUT=?,CSHFPOCURR=?,CROTYPE=? "
									+ "WHERE ECRDAY=0 and EBKCD=? AND EATNO=? AND CSHFCURR=? AND EBKRMD=? AND ENTAMT=? AND CSHFAU=? AND CSHFAD=? AND CSHFAT=? ";

		// UPDATE CAPCSHFB 預備核銷檔
		String strUpdateCAPCSHFBSQL = " UPDATE CAPCSHFB SET CRODAY=?,CSFBUU=?,CSFBUD=?,CSFBUT=?,CSFBAMTREF=?,CSFBPOCURR=? "
									+ "WHERE CRODAY=0 and CBKCD=? AND CATNO=? AND CSFBCURR=? AND CBKRMD=? AND CROAMT=? AND CSFBAU=? AND CSFBAD=? AND CSFBAT=? ";

		// UPDATE ORGNFBD 憑證明細檔
		String strUpdateORGNFBDSQL = " UPDATE ORGNFBD SET FBDSEQ=? WHERE FBDREPNO=? AND FBDREPSEQ=? ";

		Connection conn = null;
		PreparedStatement pstmtQF = null;
		PreparedStatement pstmtQFB = null;
		PreparedStatement pstmtFU = null;
		PreparedStatement pstmtFBU = null;
		PreparedStatement pstmtDU = null;
		Statement stmtFB = null;
		Statement stmtMT = null;
		ResultSet rstFB = null;
		ResultSet rstQF = null;
		ResultSet rstQFB = null;
		ResultSet rstMT = null;

		String strQueryGTMS = "select COUNT(CSFBAT),COUNT(DISTINCT CSFBAT) from CAPCSHFB where CROSRC='9' and CSFBAD=" + iEAEGDT + " having COUNT(CSFBAT)<>COUNT(DISTINCT CSFBAT) ";
		String strQueryRRNGTMS = "select RRN(CAPCSHFB) as seq from CAPCSHFB where CROSRC='9' and CSFBAD=" + iEAEGDT;
		String strUpdateGTMS = "UPDATE CAPCSHFB SET CSFBAT=? where CROSRC='9' and CSFBAD=? and RRN(CAPCSHFB)=? ";
		Statement stmtGTMS = null;
		PreparedStatement pstmtGTMSU = null;
		ResultSet rstGTMS = null;
		boolean isDuplicate = false;

		PreparedStatement pstmtPOCURR = null;
		String strUpdatePOCURR = "UPDATE CAPCSHFB SET CSFBPOCURR='NT' where CSFBPOCURR='' and CAEGDT=? ";

		try {
			
			conn = dbFactory.getAS400Connection("CroOutBatServlet");

			//處理GTMS新增時間重覆問題
			try {
				stmtGTMS = conn.createStatement();
				log.info("整批銷帳(處理GTMS新增時間重覆問題)step 1-1(strQueryGTMS):" + strQueryGTMS);
				rstGTMS = stmtGTMS.executeQuery(strQueryGTMS);
				if(rstGTMS.next()) {
					isDuplicate = true;
				}
				rstGTMS.close();
				stmtGTMS.close();
				if(isDuplicate) {
					stmtGTMS = conn.createStatement();
					log.info("整批銷帳(處理GTMS新增時間重覆問題,isDuplicate=true)step 1-2(strQueryRRNGTMS):" + strQueryRRNGTMS);
					rstGTMS = stmtGTMS.executeQuery(strQueryRRNGTMS);
					log.info("整批銷帳(處理GTMS新增時間重覆問題,isDuplicate=true)step 1-3(strUpdateGTMS):" + strUpdateGTMS);
					pstmtGTMSU = conn.prepareStatement(strUpdateGTMS);
					String  strRRN = "";
					String  strAT = "";
					while(rstGTMS.next()) {
						pstmtGTMSU.clearParameters();
	
						strRRN = rstGTMS.getString("seq");
						strAT = strRRN;
						if(strAT.length() > 6)
							strAT = strAT.substring(strAT.length()-6);
	
						pstmtGTMSU.setInt(1, Integer.parseInt(strAT));
						pstmtGTMSU.setInt(2, iEAEGDT);
						pstmtGTMSU.setInt(3, Integer.parseInt(strRRN));
						pstmtGTMSU.execute();
					}
				}
			} catch(Exception e) {
				System.err.println("處理GTMS新增時間重覆問題錯誤!!" + e.getMessage());
			} finally {
				if(pstmtGTMSU != null) pstmtGTMSU.close();
				if(rstGTMS != null) rstGTMS.close();
				if(stmtGTMS != null) stmtGTMS.close();
			}

			//處理保單幣別為空白
			try {
				log.info("整批銷帳(處理保單幣別為空白)step 2(strUpdatePOCURR):" + strUpdatePOCURR);
				pstmtPOCURR = conn.prepareStatement(strUpdatePOCURR);
				pstmtPOCURR.setInt(1, iEAEGDT);
				pstmtPOCURR.executeUpdate();
			} catch(Exception e) {
				System.err.println("處理保單幣別為空白問題錯誤!!" + e.getMessage());
			} finally {
				if(pstmtPOCURR != null) pstmtPOCURR.close();
			}

			pstmtFU = conn.prepareStatement(strUpdateCAPCSHFSQL);
			pstmtFBU = conn.prepareStatement(strUpdateCAPCSHFBSQL);
			pstmtDU = conn.prepareStatement(strUpdateORGNFBDSQL);

			CapcshfbVO fbVo = null;
			List<CapcshfbVO> tmpList = new ArrayList<CapcshfbVO>();

			int iSeq = 1;
			int icounter = 0;

			double dAmtF = 0.00;
			double dAmtFB = 0.00;
			double dSumAmt = 0.00;
			int iFAT = 0;
			int iFBAT = 0;

			//銷帳處理 BY 憑證
			stmtMT = conn.createStatement();
			log.info("整批銷帳(銷帳處理 BY 憑證)step 3(strQryByCertificateSQL):" + strQryByCertificateSQL);
			rstMT = stmtMT.executeQuery(strQryByCertificateSQL);
			while(rstMT.next()) 
			{
				if(dAmtF == rstMT.getDouble("ENTAMT") && 
						iFAT != rstMT.getInt("CSHFAT") && 
						dAmtFB == rstMT.getDouble("CROAMT") &&
						iFBAT == rstMT.getInt("CSFBAT"))
					continue;

				if(dAmtF != rstMT.getDouble("ENTAMT") ||
					(dAmtF == rstMT.getDouble("ENTAMT") && iFAT != rstMT.getInt("CSHFAT"))	) {
					dSumAmt = 0.00;
					if(!tmpList.isEmpty()) tmpList.clear();
				}

				iFAT = rstMT.getInt("CSHFAT");
				dAmtF = rstMT.getDouble("ENTAMT");

				iFBAT = rstMT.getInt("CSFBAT");
				dAmtFB = rstMT.getDouble("CROAMT");

				dSumAmt += rstMT.getDouble("CROAMT");

				fbVo = new CapcshfbVO();
				fbVo.setCBKCD(rstMT.getString("CBKCD"));
				fbVo.setCATNO(rstMT.getString("CATNO"));
				fbVo.setCBKRMD(rstMT.getInt("CBKRMD"));
				fbVo.setCCURR(rstMT.getString("CSFBCURR"));
				fbVo.setCAEGDT(rstMT.getInt("CAEGDT"));
				fbVo.setCROAMT(rstMT.getDouble("CROAMT"));
				fbVo.setCRODAY(rstMT.getInt("CRODAY"));
				fbVo.setPOCURR(rstMT.getString("CSFBPOCURR"));
				fbVo.setCSFBRECTNO(rstMT.getString("CSFBRECTNO"));
				fbVo.setCSFBRECSEQ(rstMT.getInt("CSFBRECSEQ"));
				fbVo.setCSFBPONO(rstMT.getString("CSFBPONO"));
				fbVo.setCSFBAU(rstMT.getString("CSFBAU"));
				fbVo.setCSFBAD(rstMT.getInt("CSFBAD"));
				fbVo.setCSFBAT(rstMT.getInt("CSFBAT"));

				tmpList.add(fbVo);

				if(dSumAmt == dAmtF)
				{
					strUpdTime = String.valueOf(commonUtil.getBizDateByRCalendar().getTimeInMillis());
					strUpdTime = strUpdTime.substring(7);
					int iTime = Integer.parseInt(strUpdTime);
					if(iTime > 999999) {
						iTime = iTime - 100000;
					}

					pstmtFU.clearParameters();
					pstmtFU.setInt(1, iEAEGDT);
					pstmtFU.setInt(2, Integer.parseInt(strUpdDate));
					pstmtFU.setString(3, strLogonUser);
					pstmtFU.setInt(4, Integer.parseInt(strUpdDate));
					pstmtFU.setInt(5, iTime);
					pstmtFU.setString(6, strPOCURR);
					pstmtFU.setString(7, strCROTYPE);
					pstmtFU.setString(8, rstMT.getString("EBKCD"));
					pstmtFU.setString(9, rstMT.getString("EATNO"));
					pstmtFU.setString(10, rstMT.getString("CSHFCURR"));
					pstmtFU.setInt(11, rstMT.getInt("EBKRMD"));
					pstmtFU.setDouble(12, dAmtF);
					pstmtFU.setString(13, rstMT.getString("CSHFAU"));
					pstmtFU.setInt(14, rstMT.getInt("CSHFAD"));
					pstmtFU.setInt(15, rstMT.getInt("CSHFAT"));
					log.info("整批銷帳step 4(strUpdateCAPCSHFSQL):" + strUpdateCAPCSHFSQL);
					pstmtFU.executeUpdate();

					for(int i=0; i<tmpList.size(); i++) 
					{
						fbVo = tmpList.get(i);

						pstmtFBU.clearParameters();
						pstmtFBU.setInt(1, Integer.parseInt(strUpdDate));
						pstmtFBU.setString(2, strLogonUser);
						pstmtFBU.setInt(3, Integer.parseInt(strUpdDate));
						pstmtFBU.setInt(4, iTime);
						pstmtFBU.setDouble(5, dAmtF);
						pstmtFBU.setString(6, strPOCURR);
						pstmtFBU.setString(7, fbVo.getCBKCD());
						pstmtFBU.setString(8, fbVo.getCATNO());
						pstmtFBU.setString(9, fbVo.getCCURR());
						pstmtFBU.setInt(10, fbVo.getCBKRMD());
						pstmtFBU.setDouble(11, fbVo.getCROAMT());
						pstmtFBU.setString(12, fbVo.getCSFBAU());
						pstmtFBU.setInt(13, fbVo.getCSFBAD());
						pstmtFBU.setInt(14, fbVo.getCSFBAT());
						log.info("整批銷帳step 5(strUpdateCAPCSHFBSQL):" + strUpdateCAPCSHFBSQL);
						pstmtFBU.executeUpdate();

						pstmtDU.clearParameters();
						pstmtDU.setInt(1, iSeq);
						pstmtDU.setString(2, fbVo.getCSFBRECTNO());
						pstmtDU.setInt(3, fbVo.getCSFBRECSEQ());
						log.info("整批銷帳step 6(strUpdateORGNFBDSQL):" + strUpdateORGNFBDSQL);
						pstmtDU.executeUpdate();

						iSeq++;
					}

					dSumAmt = 0.00;
					if(!tmpList.isEmpty()) tmpList.clear();
				}
			}

			pstmtQF = conn.prepareStatement(strQryCAPCSHFSQL);
			pstmtQFB = conn.prepareStatement(strQryCAPCSHFBSQL);

			stmtFB = conn.createStatement();
			rstFB = stmtFB.executeQuery(strSelectCAPCSHFBSQL);
			while(rstFB.next()) 
			{
				dAmtF = 0.00;

				pstmtQF.clearParameters();
				pstmtQF.setString(1, CommonUtil.AllTrim(rstFB.getString("CBKCD")));
				pstmtQF.setString(2, CommonUtil.AllTrim(rstFB.getString("CATNO")));
				pstmtQF.setString(3, CommonUtil.AllTrim(rstFB.getString("CSFBCURR")));
				pstmtQF.setInt(4, rstFB.getInt("CBKRMD"));
				log.info("整批銷帳step 7(strQryCAPCSHFSQL):" + strQryCAPCSHFSQL);
				rstQF = pstmtQF.executeQuery();
				while(rstQF.next())
				{
					dAmtF = rstQF.getDouble("ENTAMT");

					pstmtQFB.clearParameters();
					pstmtQFB.setString(1, rstQF.getString("EBKCD"));
					pstmtQFB.setString(2, rstQF.getString("EATNO"));
					pstmtQFB.setString(3, rstQF.getString("CSHFCURR"));
					pstmtQFB.setInt(4, rstQF.getInt("EBKRMD"));
					log.info("整批銷帳step 8(strQryCAPCSHFBSQL):" + strQryCAPCSHFBSQL);
					rstQFB = pstmtQFB.executeQuery();

					dAmtFB = 0.00;
					dSumAmt = 0.00;
					if(!tmpList.isEmpty()) tmpList.clear();

					while(rstQFB.next()) 
					{
						dAmtFB = rstQFB.getDouble("CROAMT");

						if(iEAEGDT != rstQFB.getInt("CAEGDT")) 
							continue;
						
						//一對一
						if(dAmtF == dAmtFB) 
						{
							icounter++;
							strUpdTime = String.valueOf(commonUtil.getBizDateByRCalendar().getTimeInMillis());
							strUpdTime = strUpdTime.substring(7);
							int iTime = 100000+ icounter + Integer.parseInt(strUpdTime);
							if(iTime > 999999) {
								iTime = iTime - 100000;
							}

							pstmtFU.clearParameters();
							pstmtFU.setInt(1, rstQFB.getInt("CAEGDT"));
							pstmtFU.setInt(2, Integer.parseInt(strUpdDate));
							pstmtFU.setString(3, strLogonUser);
							pstmtFU.setInt(4, Integer.parseInt(strUpdDate));
							pstmtFU.setInt(5, iTime);
							pstmtFU.setString(6, strPOCURR);
							pstmtFU.setString(7, strCROTYPE);
							pstmtFU.setString(8, rstQF.getString("EBKCD"));
							pstmtFU.setString(9, rstQF.getString("EATNO"));
							pstmtFU.setString(10, rstQF.getString("CSHFCURR"));
							pstmtFU.setInt(11, rstQF.getInt("EBKRMD"));
							pstmtFU.setDouble(12, dAmtF);
							pstmtFU.setString(13, rstQF.getString("CSHFAU"));
							pstmtFU.setInt(14, rstQF.getInt("CSHFAD"));
							pstmtFU.setInt(15, rstQF.getInt("CSHFAT"));
							log.info("整批銷帳step 9(strUpdateCAPCSHFSQL):" + strUpdateCAPCSHFSQL);
							pstmtFU.executeUpdate();

							pstmtFBU.clearParameters();
							pstmtFBU.setInt(1, Integer.parseInt(strUpdDate));
							pstmtFBU.setString(2, strLogonUser);
							pstmtFBU.setInt(3, Integer.parseInt(strUpdDate));
							pstmtFBU.setInt(4, iTime);
							pstmtFBU.setDouble(5, dAmtF);
							pstmtFBU.setString(6, strPOCURR);
							pstmtFBU.setString(7, rstQFB.getString("CBKCD"));
							pstmtFBU.setString(8, rstQFB.getString("CATNO"));
							pstmtFBU.setString(9, rstQFB.getString("CSFBCURR"));
							pstmtFBU.setInt(10, rstQFB.getInt("CBKRMD"));
							pstmtFBU.setDouble(11, dAmtFB);
							pstmtFBU.setString(12, rstQFB.getString("CSFBAU"));
							pstmtFBU.setInt(13, rstQFB.getInt("CSFBAD"));
							pstmtFBU.setInt(14, rstQFB.getInt("CSFBAT"));
							log.info("整批銷帳step 10(strUpdateCAPCSHFBSQL):" + strUpdateCAPCSHFBSQL);
							pstmtFBU.executeUpdate();

							pstmtDU.clearParameters();
							pstmtDU.setInt(1, iSeq);
							pstmtDU.setString(2, rstQFB.getString("CSFBRECTNO"));
							pstmtDU.setInt(3, rstQFB.getInt("CSFBRECSEQ"));
							log.info("整批銷帳step 11(strUpdateORGNFBDSQL):" + strUpdateORGNFBDSQL);
							pstmtDU.executeUpdate();

							iSeq++;

							break;
						}
						else
						{
							dSumAmt += rstQFB.getDouble("CROAMT");

							fbVo = new CapcshfbVO();
							fbVo.setCBKCD(rstQFB.getString("CBKCD"));
							fbVo.setCATNO(rstQFB.getString("CATNO"));
							fbVo.setCBKRMD(rstQFB.getInt("CBKRMD"));
							fbVo.setCCURR(rstQFB.getString("CSFBCURR"));
							fbVo.setCAEGDT(rstQFB.getInt("CAEGDT"));
							fbVo.setCROAMT(rstQFB.getDouble("CROAMT"));
							fbVo.setCRODAY(rstQFB.getInt("CRODAY"));
							fbVo.setPOCURR(rstQFB.getString("CSFBPOCURR"));
							fbVo.setCSFBRECTNO(rstQFB.getString("CSFBRECTNO"));
							fbVo.setCSFBRECSEQ(rstQFB.getInt("CSFBRECSEQ"));
							fbVo.setCSFBPONO(rstQFB.getString("CSFBPONO"));
							fbVo.setCSFBAU(rstQFB.getString("CSFBAU"));
							fbVo.setCSFBAD(rstQFB.getInt("CSFBAD"));
							fbVo.setCSFBAT(rstQFB.getInt("CSFBAT"));

							tmpList.add(fbVo);
						}
					}

					//一對多
					if(dSumAmt == dAmtF) {
						strUpdTime = String.valueOf(commonUtil.getBizDateByRCalendar().getTimeInMillis());
						strUpdTime = strUpdTime.substring(7);
						int iTime = Integer.parseInt(strUpdTime);
						if(iTime > 999999) {
							iTime = iTime - 100000;
						}

						pstmtFU.clearParameters();
						pstmtFU.setInt(1, fbVo.getCAEGDT());
						pstmtFU.setInt(2, Integer.parseInt(strUpdDate));
						pstmtFU.setString(3, strLogonUser);
						pstmtFU.setInt(4, Integer.parseInt(strUpdDate));
						pstmtFU.setInt(5, iTime);
						pstmtFU.setString(6, strPOCURR);
						pstmtFU.setString(7, strCROTYPE);
						pstmtFU.setString(8, rstQF.getString("EBKCD"));
						pstmtFU.setString(9, rstQF.getString("EATNO"));
						pstmtFU.setString(10, rstQF.getString("CSHFCURR"));
						pstmtFU.setInt(11, rstQF.getInt("EBKRMD"));
						pstmtFU.setDouble(12, dAmtF);
						pstmtFU.setString(13, rstQF.getString("CSHFAU"));
						pstmtFU.setInt(14, rstQF.getInt("CSHFAD"));
						pstmtFU.setInt(15, rstQF.getInt("CSHFAT"));
						log.info("整批銷帳step 12(strUpdateCAPCSHFSQL):" + strUpdateCAPCSHFSQL);
						pstmtFU.executeUpdate();

						for(int i=0; i<tmpList.size(); i++) {
							fbVo = tmpList.get(i);

							pstmtFBU.clearParameters();
							pstmtFBU.setInt(1, Integer.parseInt(strUpdDate));
							pstmtFBU.setString(2, strLogonUser);
							pstmtFBU.setInt(3, Integer.parseInt(strUpdDate));
							pstmtFBU.setInt(4, iTime);
							pstmtFBU.setDouble(5, dAmtF);
							pstmtFBU.setString(6, strPOCURR);
							pstmtFBU.setString(7, fbVo.getCBKCD());
							pstmtFBU.setString(8, fbVo.getCATNO());
							pstmtFBU.setString(9, fbVo.getCCURR());
							pstmtFBU.setInt(10, fbVo.getCBKRMD());
							pstmtFBU.setDouble(11, fbVo.getCROAMT());
							pstmtFBU.setString(12, fbVo.getCSFBAU());
							pstmtFBU.setInt(13, fbVo.getCSFBAD());
							pstmtFBU.setInt(14, fbVo.getCSFBAT());
							log.info("整批銷帳step 13(strUpdateCAPCSHFBSQL):" + strUpdateCAPCSHFBSQL);
							pstmtFBU.executeUpdate();

							pstmtDU.clearParameters();
							pstmtDU.setInt(1, iSeq);
							pstmtDU.setString(2, fbVo.getCSFBRECTNO());
							pstmtDU.setInt(3, fbVo.getCSFBRECSEQ());
							log.info("整批銷帳step 14(strUpdateORGNFBDSQL):" + strUpdateORGNFBDSQL);
							pstmtDU.executeUpdate();

							iSeq++;
						}

						dSumAmt = 0.00;
						if(!tmpList.isEmpty()) tmpList.clear();
						break;
					}
				}
			}

			strMsg = "整批銷帳作業處理完畢!!";
			
		} catch(Exception ex) {
			strMsg = "整批銷帳作業處理錯誤";
			System.err.println(ex.getMessage());
			try {
				if(isAEGON400)
					conn.rollback();
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				dbFactory.releaseAS400Connection(conn);
			}
		} finally {
			try { if(pstmtQF != null) pstmtQF.close(); } catch (SQLException e) {}
			try { if(pstmtQFB != null) pstmtQFB.close(); } catch (SQLException e) {}
			try { if(pstmtFU != null) pstmtFU.close(); } catch (SQLException e) {}
			try { if(pstmtFBU != null) pstmtFBU.close(); } catch (SQLException e) {}
			try { if(pstmtDU != null) pstmtDU.close(); } catch (SQLException e) {}
			try { if(stmtFB != null) stmtFB.close(); } catch (SQLException e) {}
			try { if(stmtMT != null) stmtMT.close(); } catch (SQLException e) {}
			try { if(rstFB != null) rstFB.close(); } catch (SQLException e) {}
			try { if(rstQF != null) rstQF.close(); } catch (SQLException e) {}
			try { if(rstQFB != null) rstQFB.close(); } catch (SQLException e) {}
			try { if(rstMT != null) rstMT.close(); } catch (SQLException e) {}

			dbFactory.releaseAS400Connection(conn);
		}

		request.setAttribute("txtMsg", strMsg);
		request.getRequestDispatcher("/CroOutBat/CroOutBatC.jsp").forward(request, response);

	}

}
