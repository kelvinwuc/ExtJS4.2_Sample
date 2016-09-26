package com.aegon.disb.disbmaintain;

import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.*;
import java.util.zip.ZipOutputStream;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.GlobalEnviron;
import com.aegon.disb.util.DISBBean;

/**
 * System   : 
 * 
 * Function : ����h�׷|�p����
 * 
 * Remark   : �޲z�t��-�|�p
 * 
 * Revision : $$Revision: 1.3 $$
 * 
 * Author   : Steven Liu
 * 
 * Create Date : $$Date: 2013/12/24 03:02:35 $$
 * 
 * Request ID : R10314
 * 
 * CVS History:
 * 
 * $$Log: DISBAccRevRmtFailServlet.java,v $
 * $Revision 1.3  2013/12/24 03:02:35  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.2.1.2  2013/08/09 09:21:32  MISSALLY
 * $QB0216 �����O��h�צ����h�פ���O���D
 * $
 * $Revision 1.2.1.1  2013/07/19 08:22:43  MISSALLY
 * $EB0070 - �H������ꫬ�~���ӫ~
 * $
 * $Revision 1.2  2013/01/08 04:24:03  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.1.4.1  2012/12/06 06:28:25  MISSALLY
 * $RA0102�@PA0041
 * $�t�X�k�O�ק�S����I�@�~
 * $
 * $Revision 1.1  2012/05/18 09:47:36  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�
 * $$
 *  
 */


public class DISBAccRevRmtFailServlet extends HttpServlet {
	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private DecimalFormat df = new DecimalFormat("0");
	private DecimalFormat df1 = new DecimalFormat("#.0000");

	//Initialize global variables
	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON) != null) {
			globalEnviron = (GlobalEnviron) getServletContext().getAttribute(Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
		}
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
		} catch (Exception e) {
			System.err.println(e.getMessage());
			request.setAttribute("txtMsg", e.getMessage());
			RequestDispatcher dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccRevRmtFail.jsp");
			dispatcher.forward(request, response);
		}
	}

	/**
	 * @param request
	 * @param response
	 */
	private void downloadProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception {
		System.out.println("inside downloadProcess");
		// R10314 - �O����O��ܡ�NT���ð���U���ɮ׮ɡA�ݩ�����G���ɮ�
		List alDwnDetails = new ArrayList();
		List alDwnDetailsD = new ArrayList();

		String selCurrency = request.getParameter("selCurrency") != null ? request.getParameter("selCurrency") : "";

		// R10314
		Collection filesToSend = new ArrayList();

		if (selCurrency.equals("NT")) {
			alDwnDetails = this.getBPayments(request, response, alDwnDetails);
			alDwnDetailsD = this.getDPayments(request, response, alDwnDetailsD);
			this.exportToFile(request, response, alDwnDetails);
			this.exportToExFile(request, response, alDwnDetailsD);
			if (alDwnDetails.size() > 0)
				filesToSend.add(new File(globalEnviron.getAppPath() + "\\download\\AccRevRmtFailDetails.txt"));
			if (alDwnDetailsD.size() > 0)
				filesToSend.add(new File(globalEnviron.getAppPath() + "\\download\\AccRevRmtFailDetailsD.txt"));
		} else {
			alDwnDetails = this.getBPayments(request, response, alDwnDetails);
			alDwnDetails = this.getDPayments(request, response, alDwnDetails);
			this.exportToFile(request, response, alDwnDetails);
			filesToSend.add(new File(globalEnviron.getAppPath() + "\\download\\AccRevRmtFailDetails.txt"));
		}

		// R10314
		int cnt = alDwnDetails.size() + alDwnDetailsD.size();

		if (cnt > 0) {
			sendDownloadFile(request, response, filesToSend);
		} else {
			// �d�L��Ʀ^�ǿ��~�T��
			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg", "�d�L�i�U�����,�Э��s�d��!");
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccRevRmtFail.jsp");
			dispatcher.forward(request, response);
		}
	}
	
	private void sendDownloadFile(HttpServletRequest request, HttpServletResponse response,Collection filesToSend)throws ServletException,IOException {
		response.setContentType("application/zip");
		response.setStatus(HttpServletResponse.SC_OK);
		response.setHeader("Content-Disposition","attachment; filename=\"AccRevRmtFailDetails.zip\"");

		OutputStream os = null;
		BufferedOutputStream bos = null;
		ZipOutputStream zos = null;
		try {
			os = response.getOutputStream();
			bos = new BufferedOutputStream(os);
			zos = new ZipOutputStream(bos);
			zos.setLevel(ZipOutputStream.STORED);
			DISBAccRmtFailServlet darf = new DISBAccRmtFailServlet();
			darf.sendMultipleFiles(zos, filesToSend);
		} catch (IOException e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		} finally {
			if (zos != null) {
				zos.finish();
				zos.flush();
			}
		}
	}

	/**
	 * @param request
	 * @param response
	 */
	private void exportToFile(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) throws ServletException, IOException, Exception {
		FileWriter fstream = null;
		BufferedWriter out = null;
		String file_name = globalEnviron.getAppPath() + "\\download\\AccRevRmtFailDetails.txt";
		File file = new File(file_name);
		boolean exists = file.exists();
		if (!exists) {
			file.createNewFile();
		} else {
			file.delete();
			file.createNewFile();
		}
		if (alDwnDetails.size() > 0) {
			//R10314
			Collections.sort(alDwnDetails, new Comparator(){
				public int compare(Object o1, Object o2) {
					DISBAccCodeDetailVO p1 = (DISBAccCodeDetailVO) o1;
					DISBAccCodeDetailVO p2 = (DISBAccCodeDetailVO) o2;
					return p1.getSort().compareToIgnoreCase(p2.getSort());
				}
			});
			
			try {
				String export = "";
				DISBBean disbBean = new DISBBean(dbFactory);
				String strCheckDt = null;
				String strActCd2 = null;
				String strActCd3 = null;
				String strActCd4 = null;// R60550
				String strActCd5 = null;
				String strDesc = null;
				String strSlipNo = null;
				String strDAmt = null;
				String strCAmt = null;
				String strPCfmDt = null;
				String strCurrency = null;
				String strLedger = null;
				for (int i = 0; i < alDwnDetails.size(); i++) {
					DISBAccCodeDetailVO objAccCodeDetail = (DISBAccCodeDetailVO) alDwnDetails.get(i);

					strCurrency = objAccCodeDetail.getStrCurr();
					strLedger = disbBean.getLedger(CommonUtil.AllTrim(disbBean.getETableDesc("CURRC", strCurrency)));
					strActCd2 = objAccCodeDetail.getStrActCd2();
					for (int count = strActCd2.length(); count < 11; count++) {// 10->11
						strActCd2 += " ";
					}
					strActCd3 = objAccCodeDetail.getStrActCd3();
					for (int count = strActCd3.length(); count < 4; count++) { // R80656 3->4�X
						strActCd3 += " ";
					}
					strActCd4 = objAccCodeDetail.getStrActCd4();
					for (int count = strActCd4.length(); count < 2; count++) {
						strActCd4 += " ";
					}
					strActCd5 = objAccCodeDetail.getStrActCd5();
					for (int count = strActCd5.length(); count < 26; count++) {// R61017 ActCd5��13�X��26�X
						strActCd5 += " ";
					}

					strPCfmDt = objAccCodeDetail.getStrDate1();
					for (int count = strPCfmDt.length(); count < 10; count++) {
						strPCfmDt += " ";
					}

					strDAmt = objAccCodeDetail.getStrDAmt();
					if (strDAmt.equals("0")) {
						strDAmt = " ";
					}
					for (int count = strDAmt.length(); count < 13; count++) {
						strDAmt = " " + strDAmt;
					}

					strCAmt = objAccCodeDetail.getStrCAmt();
					if (strCAmt.equals("0")) {
						strCAmt = " ";
					}
					for (int count = strCAmt.length(); count < 13; count++) {
						strCAmt = " " + strCAmt;
					}

					strDesc = objAccCodeDetail.getStrDesc() == null ? "" : objAccCodeDetail.getStrDesc();
					strDesc = CommonUtil.AllTrim(strDesc);
					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}

					strCheckDt = objAccCodeDetail.getStrCheckDate();
					for (int count = strCheckDt.length(); count < 8; count++) {
						strCheckDt += " ";
					}

					strSlipNo = objAccCodeDetail.getStrSlipNo();
					for (int count = strSlipNo.length(); count < 15; count++) {
						strSlipNo += " ";
					}

					String count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) {
						count1 = "0" + count1;
					}

					if (!strDAmt.trim().equals("") || !strCAmt.trim().equals("")) {
						System.out.println(strDAmt.trim());
						System.out.println(strCAmt.trim());

						export += strLedger + ",";
						export += "Manual" + ",";// Category, x(6)
						export += "Spreadsheet" + ",";// Source,x(11)
						export += strCurrency + ",";
						export += "0" + ",";// ACTCD1,x(1)
						export += strActCd2.substring(0, 6) + ",";// ACTCD2,x(10)
						export += strActCd2.substring(6, 7) + ",";
						export += strActCd2.substring(7, 8) + ",";
						export += strActCd2.substring(8, 9) + ",";
						export += strActCd2.substring(9, 11) + ",";
						export += strActCd3.substring(0, 3) + ",";// ACTCD3,x(4)
						export += strActCd3.substring(3, 4) + ",";
						export += strActCd4.trim() + ",";// ACTCD4,x(2)
						export += strActCd5.substring(0, 2) + ",";// ACTCD5,x(26),R61017 ActCd5��13�X��26�X
						export += strActCd5.substring(2, 17) + ",";
						export += strActCd5.substring(17, 20) + ",";
						export += strActCd5.substring(20, 21) + ",";
						export += strActCd5.substring(21, 23) + ",";
						export += strActCd5.substring(23, 26) + ",";
						export += strPCfmDt.trim() + ",";// ��I�T�{�騴��,YYYY/MM/DD,x(10)
						export += strDAmt.trim() + ",";// �ɤ���B,x(12),�w�]��0,�����e�ɪť�, 000,000
						export += strCAmt.trim() + ",";// �U����B,x(12),�w�]��0,�����e�ɪť�, 000,000
						export += strSlipNo.trim() + ",";// SlipNo,x(11),��I�T�{�騴�餧�褸�~��G�X+MMDD+3�ӯS�w�X R80132 ��9 -->12 + ���O
						export += strDesc.trim() + ",";// Description,x(30),������ɪť�
						export += "User" + ","; // R80620 Conversion Type
						export += "1" + ","; // R80620 Conversion Rate
						export += strPCfmDt.trim() + ",";// ��I�T�{�騴��,YYYY/MM/DD,x(10)
						export += "BATCH,";
						export += count1;
						export += "\r\n";// ����
					}
				}
				fstream = new FileWriter(file_name);
				out = new BufferedWriter(fstream);
				out.write(export);
			} finally {
				if (out != null)
					out.close();
			}
		}
	}

	/**
	 * @param request
	 * @param response
	 */
	private void exportToExFile(HttpServletRequest request, HttpServletResponse response, List alDwnDetailsD) throws ServletException, IOException, Exception {
		FileWriter fstream = null;
		BufferedWriter out = null;
		String file_name = globalEnviron.getAppPath() + "\\download\\AccRevRmtFailDetailsD.txt";
		File file = new File(file_name);
		boolean exists = file.exists();
		if (!exists) {
			file.createNewFile();
		} else {
			file.delete();
			file.createNewFile();
		}
		if (alDwnDetailsD.size() > 0) {
			//R10314
			Collections.sort(alDwnDetailsD, new Comparator(){
				public int compare(Object o1, Object o2) {
					DISBAccCodeDetailVO p1 = (DISBAccCodeDetailVO) o1;
					DISBAccCodeDetailVO p2 = (DISBAccCodeDetailVO) o2;
					return p1.getSort().compareToIgnoreCase(p2.getSort());
				}
			});
			try {
				String export = "";
				for (int i = 0; i < alDwnDetailsD.size(); i++) {
					DISBAccCodeDetailVO objAccCodeDetail = (DISBAccCodeDetailVO) alDwnDetailsD.get(i);
					String strCheckDt = null;
					String strActCd2 = null;
					String strActCd3 = null;
					String strActCd4 = null;// R60550
					String strActCd5 = null;
					String strDesc = null;
					String strSlipNo = null;
					String strDAmt = null;
					String strCAmt = null;
					String strPCfmDt = null;
					String strCurrency = null;
					// R10314
					String strCDAmt = null;
					String strCCAmt = null;
					String strCRate = null;

					strCurrency = objAccCodeDetail.getStrCurr();
					strActCd2 = objAccCodeDetail.getStrActCd2();
					for (int count = strActCd2.length(); count < 11; count++) {
						strActCd2 += " ";
					}
					strActCd3 = objAccCodeDetail.getStrActCd3();
					for (int count = strActCd3.length(); count < 4; count++) {
						strActCd3 += " ";
					}
					strActCd4 = objAccCodeDetail.getStrActCd4();
					for (int count = strActCd4.length(); count < 2; count++) {
						strActCd4 += " ";
					}
					strActCd5 = objAccCodeDetail.getStrActCd5();
					for (int count = strActCd5.length(); count < 26; count++) {
						strActCd5 += " ";
					}
					strPCfmDt = objAccCodeDetail.getStrDate1();
					for (int count = strPCfmDt.length(); count < 10; count++) {
						strPCfmDt += " ";
					}
					strDAmt = objAccCodeDetail.getStrDAmt();
					if (strDAmt.equals("0")) {
						strDAmt = " ";
					}
					for (int count = strDAmt.length(); count < 13; count++) {
						strDAmt = " " + strDAmt;
					}
					strCAmt = objAccCodeDetail.getStrCAmt();
					if (strCAmt.equals("0")) {
						strCAmt = " ";
					}
					for (int count = strCAmt.length(); count < 13; count++) {
						strCAmt = " " + strCAmt;
					}
					// R10314
					strCDAmt = objAccCodeDetail.getConversionDebit();
					if (strCDAmt.equals("0")) {
						strCDAmt = " ";
					}
					for (int count = strCDAmt.length(); count < 13; count++) {
						strCDAmt = " " + strCDAmt;
					}
					strCCAmt = objAccCodeDetail.getConversionCredit();
					if (strCCAmt.equals("0")) {
						strCCAmt = " ";
					}
					for (int count = strCCAmt.length(); count < 13; count++) {
						strCCAmt = " " + strCCAmt;
					}
					strCRate = objAccCodeDetail.getStrConverRate();
					strDesc = objAccCodeDetail.getStrDesc() == null ? "" : objAccCodeDetail.getStrDesc();
					strDesc = CommonUtil.AllTrim(strDesc);
					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}
					strCheckDt = objAccCodeDetail.getStrCheckDate();
					for (int count = strCheckDt.length(); count < 8; count++) {
						strCheckDt += " ";
					}
					strSlipNo = objAccCodeDetail.getStrSlipNo();
					for (int count = strSlipNo.length(); count < 15; count++) {
						strSlipNo += " ";
					}
					String count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) {
						count1 = "0" + count1;
					}

					if (!strDAmt.trim().equals("") || !strCAmt.trim().equals("")) {
						System.out.println(strDAmt.trim());
						System.out.println(strCAmt.trim());
						/*
						if (strCurrency.equals("TWD")) {
							export += "TransGlobe Life Insurance Inc.,";
						} else if (strCurrency.equals("AUD")) {
							export += "TransGlobe Life Insurance AUD,";
						} else if (strCurrency.equals("USD")) {
							export += "TransGlobe Life Insurance USD,";
						} else {
							export += "                              ,";
						}
						*/
						export += "TransGlobe Life Insurance Inc.,";//R10314
						export += "Manual" + ",";// Category, x(6)
						export += "Spreadsheet" + ",";// Source,x(11)
						export += strCurrency + ",";
						export += "0" + ",";// ACTCD1,x(1)
						export += strActCd2.substring(0, 6) + ",";// ACTCD2,x(10)
						export += strActCd2.substring(6, 7) + ",";
						export += strActCd2.substring(7, 8) + ",";
						export += strActCd2.substring(8, 9) + ",";
						export += strActCd2.substring(9, 11) + ",";
						export += strActCd3.substring(0, 3) + ",";// ACTCD3,x(4)
						export += strActCd3.substring(3, 4) + ",";
						export += strActCd4.trim() + ",";// ACTCD4,x(2)
						export += strActCd5.substring(0, 2) + ",";
						export += strActCd5.substring(2, 17) + ",";
						export += strActCd5.substring(17, 20) + ",";
						export += strActCd5.substring(20, 21) + ",";
						export += strActCd5.substring(21, 23) + ",";
						export += strActCd5.substring(23, 26) + ",";
						export += strPCfmDt.trim() + ",";// ��I�T�{�騴��,YYYY/MM/DD,x(10)
						export += strDAmt.trim() + ",";// �ɤ���B,x(12),�w�]��0,�����e�ɪť�, 000,000
						export += strCAmt.trim() + ",";// �U����B,x(12),�w�]��0,�����e�ɪť�, 000,000
						export += strSlipNo.trim() + ",";// SlipNo,x(11),��I�T�{�騴�餧�褸�~��G�X+MMDD+ 3�ӯS�w�X R80132 ��9 -->12 + ���O
						export += strDesc.trim() + ",";// Description,x(30),������ɪť�
						export += "User" + ","; // R80620 Conversion Type
						export += strCRate + ",";
						export += strPCfmDt.trim() + ",";// ��I�T�{�騴��,YYYY/MM/DD,x(10)
						export += strCCAmt.trim() + ",";// �ɤ�ɤ���B,x(12),�w�]��0,�����e�ɪť�,// 000,000
						export += strCDAmt.trim() + ",";// �U����B,x(12),�w�]��0,�����e�ɪť�,// 000,000
						export += "BATCH,";
						export += count1;
						export += "\r\n";// ����
					}
				}
				fstream = new FileWriter(file_name);
				out = new BufferedWriter(fstream);
				out.write(export);
			} finally {
				if (out != null)
					out.close();
			}
		}
	}
		
	/**
	 * @param request
	 * @param response
	 * @param alDwnDetails
	 * @return
	 */
	private List getDPayments(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) {
		Connection con = dbFactory.getAS400Connection("DISBAccRevRmtFailServlet.getDPayments()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		List alReturn = new ArrayList();
		String strPStartDate = ""; // �װh���
		String strCurrency = "";
		String strActCd3 = "";// R80656
		DISBBean disbBean = new DISBBean(dbFactory);// R70088

		strPStartDate = request.getParameter("txtPStartDate");
		if (strPStartDate != null)
			strPStartDate = strPStartDate.trim();
		else
			strPStartDate = "";

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";

		// R10314
		String strPStartDateTemp = null;
		if (strPStartDate.length() < 7)
			strPStartDateTemp = "0" + strPStartDate;
		else
			strPStartDateTemp = strPStartDate;

		String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDateTemp.substring(0, 3))) + "/" + strPStartDateTemp.substring(3, 5) + "/" + strPStartDateTemp.substring(5, 7);
		String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDateTemp.substring(0, 3))) + strPStartDateTemp.substring(3, 5) + strPStartDateTemp.substring(5, 7);

		/* 1. ���o�ŦX�������ŦX�e�ݶװh����϶�����I���Ѥ��״ڸ��,�p�p���@��(�U��) */
		try {
			// �ɤ�ǲ��K�n�P�@����h�פ�B�P�@�I�ڻȦ�b���X�֤@������
			strSql = "SELECT DENSE_RANK() OVER (ORDER BY a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,A.PPAYCURR,b.FFEEWAY,a.REMITFAILD) AS SORT," ;			strSql += "SUM(a.PAMT) AS PAMT,a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,SUM(a.PPAYAMT) AS PPAYAMT,A.PPAYCURR,b.FFEEWAY,SUM(b.FPAYAMT) AS FPAYAMT,a.REMITFAILD ";
			strSql += " from CAPPAYF a left join caprfef b on a.pno=b.fpnoh ";
			strSql += "WHERE PMETHOD ='D' and PSTATUS = 'A' ";
			strSql += " and PBNKRFDT = " + strPStartDate;// R10314
			strSql += " and PCURR='" + strCurrency + "' ";
			strSql += " GROUP BY a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,A.PPAYCURR,b.FFEEWAY,a.REMITFAILD ";// R10314
			System.out.println("strSqlD_1" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetailC = new DISBAccCodeDetailVO();
				double PAMT = rs.getDouble("PAMT");// �x�����B
				double PPAYAMT = rs.getDouble("PPAYAMT");// �~�����B

				double PPAYRATE = rs.getDouble("PPAYRATE");// �ײv
				double FPAYAMT = rs.getDouble("FPAYAMT");// �װh�B�z�O
				double FeeAmtTp = 0.00;// ���q���I�װh����O���B
				double PAYAMTTp = 0;// ���q�Ȧ�s�ڪ��B�b
				double PAMTTp = 0;

				String PAYCURR = rs.getString("PPAYCURR");// R70366
				String FFEEWAY = rs.getString("FFEEWAY");// �װh�B�z�O�֭t��
				// R70279�p�G�L�װh�B�z�O
				if (FFEEWAY == null) {
					FFEEWAY = "";
				}
				if (FPAYAMT > 0) {
					if(strCurrency.equals("NT")) {
						FeeAmtTp = (int) (FPAYAMT * PPAYRATE + 0.5);
					} else {
						FeeAmtTp = disbBean.DoubleMul(FPAYAMT, PPAYRATE);
					}
				}
				PAYAMTTp = PAMT - FeeAmtTp;// ���`���B-�װh����O
				PAMTTp = PPAYAMT - FPAYAMT;

				strActCd3 = disbBean.getACTCDFinRmt(rs.getString("PBBANK").substring(0, 3), rs.getString("PBACCOUNT"), rs.getString("PPAYCURR").trim()) == null ? " " : disbBean.getACTCDFinRmt(rs.getString("PBBANK").substring(0, 3), rs.getString("PBACCOUNT"), rs.getString("PPAYCURR").trim()).trim();
				if (strActCd3.length() < 13)
					strActCd3 = rs.getString("PBBANK").substring(0, 3) + " ";
				else
					strActCd3 = rs.getString("PBBANK").substring(0, 3) + strActCd3.substring(12, 13);

				// R10314
				String strRFDate = "";
				if (rs.getString("REMITFAILD").length() < 7)
					strRFDate = "0" + rs.getString("REMITFAILD");
				else
					strRFDate = rs.getString("REMITFAILD");

				String DateTemp2 = Integer.toString(1911 + Integer.parseInt(strRFDate.substring(0, 3))) + "/" + strRFDate.substring(3, 5) + "/" + strRFDate.substring(5, 7);

				if (FFEEWAY.equals("BEN")) {
					objAccCodeDetailC.setStrActCd2(disbBean.getACTCD2(disbBean.getETableDesc("CURRA", PAYCURR.trim())));
					objAccCodeDetailC.setStrActCd3(strActCd3);
					objAccCodeDetailC.setStrActCd4("00");
					objAccCodeDetailC.setStrActCd5("00000000000000000000000000");
					objAccCodeDetailC.setStrDesc("RVS�h�צ^�s�w������" + DateTemp2);
					//objAccCodeDetailC.setStrCAmt(df.format(PAYAMTTp));
					objAccCodeDetailC.setStrDAmt("0");
					objAccCodeDetailC.setStrCheckDate(DateTemp1);
					objAccCodeDetailC.setStrDate1(DateTemp);
					objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));

					// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
					// RA0102 - 001-R->001R, 004-R->001-1R
					if ("NT".equals(strCurrency)) {
						objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
						objAccCodeDetailC.setStrCAmt(df1.format(PAMTTp));
						objAccCodeDetailC.setStrDAmt("0");
						objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001-1R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						objAccCodeDetailC.setStrConverRate(String.valueOf(PPAYRATE));
						objAccCodeDetailC.setConversionCredit("0");
						objAccCodeDetailC.setConversionDebit(df.format(PAYAMTTp));
					} else {
						objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						objAccCodeDetailC.setStrCAmt(df1.format(PAYAMTTp));
						objAccCodeDetailC.setStrConverRate("1");
						objAccCodeDetailC.setConversionCredit("0");
						objAccCodeDetailC.setConversionDebit("0");
					}

					if (!rs.getString("PCURR").trim().equals("NT")) {
						objAccCodeDetailC.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
					}
					objAccCodeDetailC.setSort("D"+rs.getString("PBBANK")+rs.getString("SORT"));
					alReturn.add(objAccCodeDetailC);

				} else {// OUR ,�S��SHA

					objAccCodeDetailC.setStrActCd2(disbBean.getACTCD2(disbBean.getETableDesc("CURRA", PAYCURR.trim())));
					objAccCodeDetailC.setStrActCd3(strActCd3);
					objAccCodeDetailC.setStrActCd4("00");
					objAccCodeDetailC.setStrActCd5("00000000000000000000000000");
					objAccCodeDetailC.setStrDesc("RVS�h�צ^�s�w������" + DateTemp2);
					objAccCodeDetailC.setStrCAmt(df.format(PAYAMTTp));
					objAccCodeDetailC.setStrDAmt("0");
					objAccCodeDetailC.setStrCheckDate(DateTemp1);
					objAccCodeDetailC.setStrDate1(DateTemp);
					objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
					// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
					// RA0102 - 001-R->001R, 004-R->001-1R
					if ("NT".equals(strCurrency)) {
						objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
						objAccCodeDetailC.setStrCAmt(df1.format(PAMTTp));
						objAccCodeDetailC.setStrDAmt("0");
						objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001-1R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						objAccCodeDetailC.setStrConverRate(String.valueOf(PPAYRATE));
						objAccCodeDetailC.setConversionCredit("0");
						objAccCodeDetailC.setConversionDebit(df.format(PAYAMTTp));
					} else {
						objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						objAccCodeDetailC.setStrConverRate("1");
						objAccCodeDetailC.setConversionCredit("0");
						objAccCodeDetailC.setConversionDebit("0");
					}
					
					if (!rs.getString("PCURR").trim().equals("NT")) {
						objAccCodeDetailC.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
					}
					objAccCodeDetailC.setSort("D"+rs.getString("PBBANK")+rs.getString("SORT"));
					alReturn.add(objAccCodeDetailC);

					// ���ͤ@���Ȥ���O
					if (FPAYAMT > 0) {
						DISBAccCodeDetailVO objAccCodeDetailC1 = new DISBAccCodeDetailVO();
						objAccCodeDetailC1.setStrActCd2("82550090ZZZ");
						objAccCodeDetailC1.setStrActCd3("0000");
						objAccCodeDetailC1.setStrActCd4("43");
						objAccCodeDetailC1.setStrActCd5("00000000000000000000000000");

						if ("NT".equals(strCurrency))
							objAccCodeDetailC1.setStrDesc("RVS�h�צ^�s�w������" + DateTemp2);
						else
							objAccCodeDetailC1.setStrDesc("�׶O");
						objAccCodeDetailC1.setStrCAmt(df.format(FeeAmtTp));
						objAccCodeDetailC1.setStrDAmt("0");
						objAccCodeDetailC1.setStrCheckDate(DateTemp1);
						objAccCodeDetailC1.setStrDate1(DateTemp);
						objAccCodeDetailC1.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
						// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
						// RA0102 - 001-R->001R, 004-R->001-1R
						if ("NT".equals(strCurrency)) {
							objAccCodeDetailC1.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
							objAccCodeDetailC1.setStrCAmt(df1.format(FPAYAMT));
							objAccCodeDetailC1.setStrDAmt("0");
							objAccCodeDetailC1.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001-1R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
							objAccCodeDetailC1.setStrConverRate(String.valueOf(PPAYRATE));
							objAccCodeDetailC1.setConversionCredit("0");
							objAccCodeDetailC1.setConversionDebit(df.format(FeeAmtTp));
						} else {
							objAccCodeDetailC1.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
							objAccCodeDetailC1.setStrConverRate("1");
							objAccCodeDetailC1.setConversionCredit("0");
							objAccCodeDetailC1.setConversionDebit("0");
						}

						if (!rs.getString("PCURR").trim().equals("NT")) {
							objAccCodeDetailC1.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						}
						objAccCodeDetailC1.setSort("D"+rs.getString("PBBANK")+rs.getString("SORT"));
						alReturn.add(objAccCodeDetailC1);
					}
				}
			}
			rs.close();
			strSql = null;

			//�U��
			strSql = "SELECT DENSE_RANK() OVER (ORDER BY a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,A.PNAME,A.PPAYCURR,b.FFEEWAY,a.REMITFAILD) AS SORT," ;			strSql += "SUM(a.PAMT) AS PAMT,a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,SUM(a.PPAYAMT) AS PPAYAMT,A.PNAME,A.POLICYNO,A.PPAYCURR,b.FFEEWAY,SUM(b.FPAYAMT) AS FPAYAMT,SUM(a.PAMTNT) AS PAYAMTNT,a.REMITFAILD ";
			strSql += " from CAPPAYF a left join caprfef b on a.pno=b.fpnoh ";
			strSql += "WHERE PMETHOD ='D' and PSTATUS = 'A' ";
			strSql += " and PBNKRFDT = " + strPStartDate;
			strSql += " and PCURR='" + strCurrency + "' ";
			strSql += " GROUP BY a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,A.PNAME,A.POLICYNO,A.PPAYCURR,b.FFEEWAY,a.REMITFAILD ";
			System.out.println("strSqlD_2" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			while (rs.next()) {
				double PAMT = rs.getDouble("PAMT");// �x�����B
				double PPAYAMT = rs.getDouble("PPAYAMT");// �~�����B
				double PAYAMTNT = rs.getDouble("PAYAMTNT");// ��I���B�x���Ѧҭ�

				double PPAYRATE = rs.getDouble("PPAYRATE");// �ײv
				double FPAYAMT = rs.getDouble("FPAYAMT");// �װh�B�z�O
				double FeeAmtTp = 0.00;// ���q���I�װh����O���B
				double PAYAMTTp = 0;// ���q�Ȧ�s�ڪ��B�b
				double PAMTTp = 0;

				String PAYCURR = rs.getString("PPAYCURR");// R70366
				String FFEEWAY = rs.getString("FFEEWAY");// �װh�B�z�O�֭t��
				// R70279�p�G�L�װh�B�z�O
				if (FFEEWAY == null) {
					FFEEWAY = "";
				}
				if (FPAYAMT > 0) {
					if(strCurrency.equals("NT")) {
						FeeAmtTp = (int) (FPAYAMT * PPAYRATE + 0.5);
					} else {
						FeeAmtTp = disbBean.DoubleMul(FPAYAMT, PPAYRATE);
					}
				}
				PAYAMTTp = PAMT - FeeAmtTp;// ���`���B-�װh����O
				PAMTTp = PPAYAMT - FPAYAMT;

				String strRFDate = "";
				if (rs.getString("REMITFAILD").length() < 7)
					strRFDate = "0" + rs.getString("REMITFAILD");
				else
					strRFDate = rs.getString("REMITFAILD");

				String DateTemp2 = Integer.toString(1911 + Integer.parseInt(strRFDate.substring(0, 3)))+ "/"+ strRFDate.substring(3, 5)+ "/"+ strRFDate.substring(5, 7);//�h�פ�

				if (FFEEWAY.equals("BEN")) {
					DISBAccCodeDetailVO objAccCodeDetailD = new DISBAccCodeDetailVO();
					objAccCodeDetailD.setStrActCd2("29004000ZZZ");
					objAccCodeDetailD.setStrActCd3("0000");
					objAccCodeDetailD.setStrActCd4("00");// R60550
					objAccCodeDetailD.setStrActCd5("00000000000000000000000000");
					objAccCodeDetailD.setStrDesc("RVS�h��" + rs.getString("PNAME").trim());
					//objAccCodeDetailD.setStrDAmt(df.format(PAYAMTTp));
					objAccCodeDetailD.setStrCAmt("0");
					objAccCodeDetailD.setStrCheckDate(DateTemp1);
					objAccCodeDetailD.setStrDate1(DateTemp);
					objAccCodeDetailD.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
					// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
					// RA0102 - 001-R->001R, 004-R->001-1R
					if ("NT".equals(strCurrency)) {
						objAccCodeDetailD.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
						objAccCodeDetailD.setStrDAmt(df1.format(PAMTTp));
						objAccCodeDetailD.setStrCAmt("0");
						objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001-1R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						objAccCodeDetailD.setStrConverRate(String.valueOf(PPAYRATE));
						objAccCodeDetailD.setConversionCredit(df.format(PAYAMTTp));
						objAccCodeDetailD.setConversionDebit("0");
					} else {
						objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						objAccCodeDetailD.setStrDAmt(df1.format(PAYAMTTp));
						objAccCodeDetailD.setStrConverRate("1");
						objAccCodeDetailD.setConversionCredit("0");
						objAccCodeDetailD.setConversionDebit("0");
					}

					if (!rs.getString("PCURR").trim().equals("NT")) {
						objAccCodeDetailD.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
					}
					objAccCodeDetailD.setSort("D"+rs.getString("PBBANK")+rs.getString("SORT"));
					alReturn.add(objAccCodeDetailD);
				} else {
					DISBAccCodeDetailVO objAccCodeDetailD = new DISBAccCodeDetailVO();
					objAccCodeDetailD.setStrActCd2("29004000ZZZ");
					objAccCodeDetailD.setStrActCd3("0000");
					objAccCodeDetailD.setStrActCd4("00");
					objAccCodeDetailD.setStrActCd5("00000000000000000000000000");
					objAccCodeDetailD.setStrDesc("RVS�h��" + rs.getString("PNAME").trim());
					objAccCodeDetailD.setStrDAmt(df.format(PAMT));
					objAccCodeDetailD.setStrCAmt("0");
					objAccCodeDetailD.setStrCheckDate(DateTemp1);
					objAccCodeDetailD.setStrDate1(DateTemp);
					objAccCodeDetailD.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
					
					// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
					// RA0102 - 001-R->001R, 004-R->001-1R
					if ("NT".equals(strCurrency)) {
						objAccCodeDetailD.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
						objAccCodeDetailD.setStrDAmt(df1.format(PPAYAMT));
						objAccCodeDetailD.setStrCAmt("0");
						objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001-1R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						objAccCodeDetailD.setStrConverRate(String.valueOf(PPAYRATE));
						objAccCodeDetailD.setConversionCredit(df.format(PAYAMTNT));// �U������A�h���ťաC
						objAccCodeDetailD.setConversionDebit("0");
					} else {
						objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
						objAccCodeDetailD.setStrConverRate("1.0000");
						objAccCodeDetailD.setConversionCredit("0");
						objAccCodeDetailD.setConversionDebit("0");
					}

					if (!rs.getString("PCURR").trim().equals("NT")) {
						objAccCodeDetailD.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
					}
					objAccCodeDetailD.setSort("D"+rs.getString("PBBANK")+rs.getString("SORT"));
					alReturn.add(objAccCodeDetailD);
				}
			}
			rs.close();
			strSql = null;

		} catch (SQLException ex) {
			System.err.println(ex.getMessage());
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			alReturn = null;
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
		return alReturn;
	}

	/**
	 * @param request
	 * @param response
	 * @return
	 */
	private List getBPayments(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) {
		Connection con = dbFactory.getAS400Connection("DISBAccRevRmtFailServlet.getBPayments()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		List alReturn = new ArrayList();
		String strPStartDate = ""; // �װh����_��
		String strCurrency = "";
		String strActCd3 = "";// R80656
		DISBBean disbBean = new DISBBean(dbFactory);// R70088

		strPStartDate = request.getParameter("txtPStartDate");
		if (strPStartDate != null)
			strPStartDate = strPStartDate.trim();
		else
			strPStartDate = "";

		strCurrency = request.getParameter("selCurrency");
		if (strCurrency != null)
			strCurrency = strCurrency.trim();
		else
			strCurrency = "";

		String strPStartDateTemp = null;
		if (strPStartDate.length() < 7)
			strPStartDateTemp = "0" + strPStartDate;
		else
			strPStartDateTemp = strPStartDate;

		String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDateTemp.substring(0, 3))) + "/" + strPStartDateTemp.substring(3, 5) + "/" + strPStartDateTemp.substring(5, 7);
		String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDateTemp.substring(0, 3))) + strPStartDateTemp.substring(3, 5) + strPStartDateTemp.substring(5, 7);

		/* 1. ���o�ŦX�������ŦX�e�ݶװh����϶�����I���Ѥ��״ڸ��,�p�p���@��(�U��) */

		try {
			strSql =
			// R70366 "select SUM(PAMT) AS SPAMT,PMETHOD,PCURR";
			// �ɤ�ǲ��K�n�P�@����h�פ�B�P�@�I�ڻȦ�b���X�֤@������
			"select SUM(PAMT) AS SPAMT,PBBANK,PBACCOUNT,PMETHOD,PCURR,PBNKRFDT,REMITFAILD,DENSE_RANK() OVER (ORDER BY PBBANK,PBACCOUNT,PMETHOD,PCURR,PBNKRFDT,REMITFAILD) AS SORT   ";// R70366 R10314
			strSql += " from CAPPAYF ";
			strSql += "WHERE 1=1  and PMETHOD ='B' and PSTATUS = 'A' ";
			// strSql += " and UPDDT between " + strPStartDate + "  and " +
			// strPEndDate ;
			strSql += " and PBNKRFDT = " + strPStartDate;// R10314
			strSql += " and PCURR='" + strCurrency + "'";
			// R70366strSql += " GROUP BY PMETHOD,PCURR ";
			strSql += " GROUP BY PBBANK,PBACCOUNT,PMETHOD,PCURR,PBNKRFDT,REMITFAILD ";// R70366

			System.out.println("strSql_1" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			while (rs.next()) {
				// System.out.println("test");
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				String PCURR = rs.getString("PCURR");// R70366
				strActCd3 = disbBean.getACTCDFinRmt(rs.getString("PBBANK").substring(0, 3), rs.getString("PBACCOUNT"), "NT") == null ? " " : disbBean.getACTCDFinRmt(rs.getString("PBBANK").substring(0, 3), rs.getString("PBACCOUNT"), "NT").trim();
				if (strActCd3.length() < 13)
					strActCd3 = rs.getString("PBBANK").substring(0, 3) + " ";
				else
					strActCd3 = rs.getString("PBBANK").substring(0, 3) + strActCd3.substring(12, 13);

				// R10314
				String strRFDate = "";
				if (rs.getString("REMITFAILD").length() < 7)
					strRFDate = "0" + rs.getString("REMITFAILD");
				else
					strRFDate = rs.getString("REMITFAILD");

				String DateTemp2 = Integer.toString(1911 + Integer.parseInt(strRFDate.substring(0, 3))) + "/" + strRFDate.substring(3, 5) + "/" + strRFDate.substring(5, 7);

				if (rs.getString("PMETHOD").trim().equals("B")) {
					objAccCodeDetail.setStrActCd2(disbBean.getACTCD2(disbBean.getETableDesc("CURRA", PCURR.trim())));// R80132
					objAccCodeDetail.setStrActCd3(strActCd3);// R80656
					objAccCodeDetail.setStrActCd4("00");// R60550
					objAccCodeDetail.setStrActCd5("00000000000000000000000000");
					objAccCodeDetail.setStrDesc("RVS�h�צ^�s-������" + DateTemp2);
				}
				objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
				objAccCodeDetail.setStrDAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				
				if (!rs.getString("PCURR").trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				objAccCodeDetail.setSort("A"+rs.getInt("SORT"));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;

			/* 1. ���o�ŦX�������ŦX�e�ݶװh����϶�����I���Ѥ��״ک��Ӹ��--�ɤ� */
			strSql = "select DENSE_RANK() OVER (ORDER BY PBBANK,PBACCOUNT,PMETHOD,PCURR,PBNKRFDT,REMITFAILD) AS SORT,PAMT ,PMETHOD,PNAME,PCURR ";
			strSql += " from CAPPAYF ";
			strSql += "WHERE 1=1 and PMETHOD ='B' and PSTATUS ='A' ";
			// strSql += " and UPDDT between " + strPStartDate + "  and " + strPEndDate ;
			strSql += " and PBNKRFDT = " + strPStartDate;// R10314
			strSql += " and PCURR='" + strCurrency + "'";
			System.out.println("strSql_4" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd3("0000");
				objAccCodeDetail.setStrActCd4("00");// R60550
				objAccCodeDetail.setStrActCd5("00000000000000000000000000");
				objAccCodeDetail.setStrDesc("RVS�h��" + rs.getString("PNAME").trim());
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("PAMT")));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));// R80132
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));

				if (!rs.getString("PCURR").trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				objAccCodeDetail.setSort("A"+rs.getInt("SORT"));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;

			// �H�Υd�״ڥ��ѡA�ɤ�ǲ��K�n�P�@����h�פ�B�P�@�I�ڻȦ�b���X�֤@������
			strSql = "select SUM(PAMT) AS SPAMT,PBBANK,PBACCOUNT,PMETHOD,PCURR,REMITFAILD ";// R10314
			strSql += ",DENSE_RANK() OVER (ORDER BY PBBANK,PBACCOUNT,PMETHOD,PCURR,REMITFAILD) AS SORT ";	//RA0102
			strSql += " from CAPPAYF ";
			strSql += "WHERE 1=1  and PMETHOD ='C' and PSTATUS = 'A' ";
			// strSql += " and UPDDT between " + strPStartDate + "  and " + strPEndDate ;
			strSql += " and PBNKRFDT = " + strPStartDate;// R10314
			strSql += " and PCURR='" + strCurrency + "'";
			strSql += " GROUP BY PBBANK,PBACCOUNT,PMETHOD,PCURR,REMITFAILD ";// R10314
			System.out.println("strSql_5" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			while (rs.next()) {
				// R10314
				String strRFDate = "";
				if (rs.getString("REMITFAILD").length() < 7)
					strRFDate = "0" + rs.getString("REMITFAILD");
				else
					strRFDate = rs.getString("REMITFAILD");

				String DateTemp2 = Integer.toString(1911 + Integer.parseInt(strRFDate.substring(0, 3))) + "/" + strRFDate.substring(3, 5) + "/" + strRFDate.substring(5, 7);

				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				if (rs.getString("PMETHOD").trim().equals("C")) {
					objAccCodeDetail.setStrActCd2("11100000ZZZ");
					objAccCodeDetail.setStrActCd3("0000");
					objAccCodeDetail.setStrActCd4("00");// R60550
					objAccCodeDetail.setStrActCd5("P1000000000000000000000000");
					// R10314
					// objAccCodeDetail.setStrDesc("�H�Υd�^�s");
					objAccCodeDetail.setStrDesc("RVS�H�Υd�^�s-������" + DateTemp2);
				}
				objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
				objAccCodeDetail.setStrDAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim())); // R80132
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));

				if (!rs.getString("PCURR").trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("P1000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				objAccCodeDetail.setSort("B"+rs.getInt("SORT"));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;

			/* 1. ���o�ŦX�������ŦX�e�ݶװh����϶�����I���Ѥ��H�Υd���Ӹ��--�ɤ� */
			strSql = "select PAMT ,PMETHOD,PNAME ,PCURR";
			strSql += ",DENSE_RANK() OVER (ORDER BY PBBANK,PBACCOUNT,PMETHOD,PCURR,REMITFAILD) AS SORT ";	//RA0102
			strSql += " from CAPPAYF ";
			strSql += "WHERE 1=1 and PMETHOD ='C' and PSTATUS ='A' ";
			// strSql += " and UPDDT between " + strPStartDate + "  and " +
			// strPEndDate ;
			strSql += " and PBNKRFDT = " + strPStartDate;// R10314
			strSql += " and PCURR='" + strCurrency + "'";
			System.out.println("strSql_6" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd3("0000");
				objAccCodeDetail.setStrActCd4("00");// R60550
				objAccCodeDetail.setStrActCd5("00000000000000000000000000");
				objAccCodeDetail.setStrDesc("RVS�h�׫H�Υd" + rs.getString("PNAME").trim());
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("PAMT")));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA",strCurrency.trim()));  // R80132		
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "001R" + disbBean.getETableDesc("CURRA", strCurrency.trim()));

				if (!rs.getString("PCURR").trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000" + disbBean.getETableDesc("CURRA", strCurrency.trim()));
				}
				objAccCodeDetail.setSort("B"+rs.getInt("SORT"));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			alReturn = null;
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
		return alReturn;
	}

}
