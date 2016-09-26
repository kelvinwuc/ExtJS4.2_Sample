package com.aegon.disb.disbmaintain;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.sql.*;
import java.text.DecimalFormat;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import com.aegon.comlib.*;
import com.aegon.disb.util.DISBBean;

/**
 * System   :
 * 
 * Function : �h�׷|�p����
 * 
 * Remark   : �޲z�t��-�|�p
 * 
 * Revision : $$Revision: 1.18 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:    //R00308 Oracle �W�Ǯ榡�ܧ�
 * 
 * $$Log: DISBAccRmtFailServlet.java,v $
 * $Revision 1.18  2013/12/24 03:02:35  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.17.1.2  2013/08/09 09:21:32  MISSALLY
 * $QB0216 �����O��h�צ����h�פ���O���D
 * $
 * $Revision 1.17.1.1  2013/07/19 08:22:43  MISSALLY
 * $EB0070 - �H������ꫬ�~���ӫ~
 * $
 * $Revision 1.17  2013/01/08 04:24:03  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.16.4.1  2012/12/06 06:28:25  MISSALLY
 * $RA0102�@PA0041
 * $�t�X�k�O�ק�S����I�@�~
 * $
 * $Revision 1.16  2012/05/18 09:47:35  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�
 * $
 * $Revision 1.15  2010/11/23 06:31:02  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.14  2010/10/25 07:09:22  MISJIMMY
 * $R00308 ORACLE�W���ɮ׮榡�ܧ�
 * $
 * $Revision 1.13  2008/11/03 09:00:14  MISODIN
 * $R80413 READ CAPBNKF �վ�
 * $
 * $Revision 1.12  2008/09/15 02:58:56  misvanessa
 * $R80656_ActCd3��ز�4�X���TABLE
 * $
 * $Revision 1.11  2008/08/15 04:09:49  misvanessa
 * $R80620_�|�p��ؤU���ɮ׷s�W3���
 * $
 * $Revision 1.10  2008/08/06 05:55:20  MISODIN
 * $R80132 �վ�CASH�t��for 6�ع��O
 * $
 * $Revision 1.9  2007/10/05 09:11:31  MISVANESSA
 * $R70770_ACTCD2 �X�� 11 �X
 * $
 * $Revision 1.8  2007/06/08 07:58:04  MISVANESSA
 * $R70366_�|�p��ةM�װh�|�p��حק�
 * $
 * $Revision 1.7  2007/04/13 06:07:05  MISVANESSA
 * $R70279_�װh����B�z
 * $
 * $Revision 1.6  2007/03/26 04:33:33  MISVANESSA
 * $R70088_SPUL�t��
 * $
 * $Revision 1.5  2007/01/31 08:19:08  MISVANESSA
 * $R70088_SPUL�t��
 * $
 * $Revision 1.4  2007/01/05 07:21:44  MISVANESSA
 * $R60550_�|�p��حק�
 * $
 * $Revision 1.3  2006/12/28 09:32:42  miselsa
 * $R60463��R60550_�W�[�~���󪺶װh�|�p����
 * $
 * $Revision 1.2  2006/11/07 07:53:54  miselsa
 * $R61017_ActCd5��13�X��26�X
 * $
 * $Revision 1.1  2006/06/29 09:40:15  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.4  2006/04/28 03:40:43  misangel
 * $R50891:VA�����O��-��ܹ��O(NTD -->TWD)
 * $
 * $Revision 1.1.2.3  2006/04/27 09:19:30  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.2  2005/09/05 07:15:52  misangel
 * $R50736:�ק�װh�ǲ����
 * $
 * $Revision 1.1.2.2  2005/04/28 08:56:27  miselsa
 * $R30530������ժ��ק�
 * $
 * $Revision 1.1.2.1  2005/04/25 07:25:28  miselsa
 * $R30530_�s�W���|�p�����\��
 * $
 * $Revision 1.1.2.3  2005/04/04 07:02:27  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

public class DISBAccRmtFailServlet extends HttpServlet {
	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private DecimalFormat df = new DecimalFormat("0");
	private DecimalFormat df1 = new DecimalFormat("#.0000");

	// Initialize global variables
	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON) != null) {
			globalEnviron = (GlobalEnviron) getServletContext().getAttribute(
					Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory = (DbFactory) getServletContext().getAttribute(
					Constant.DB_FACTORY);
		}
	}

	// Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	// Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		try {
			this.downloadProcess(request, response);
		} catch (Exception e) {
			System.err.println(e.toString());
			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg", e.getMessage());
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccRmtFail.jsp");
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

		Collection filesToSend = new ArrayList();

		if (selCurrency.equals("NT")) {
			alDwnDetails = this.getBPayments(request, response, alDwnDetails);
			alDwnDetailsD = this.getDPayments(request, response, alDwnDetailsD);
			this.exportToFile(request, response, alDwnDetails);
			this.exportToExFile(request, response, alDwnDetailsD);
			if (alDwnDetails.size() > 0) filesToSend.add(new File(globalEnviron.getAppPath()+ "\\download\\AccRmtFailDetails.txt"));
			if (alDwnDetailsD.size() > 0) filesToSend.add(new File(globalEnviron.getAppPath()+ "\\download\\AccRmtFailDetailsD.txt"));
		} else {
			alDwnDetails = this.getBPayments(request, response, alDwnDetails);
			alDwnDetails = this.getDPayments(request, response, alDwnDetails);
			this.exportToFile(request, response, alDwnDetails);
			filesToSend.add(new File(globalEnviron.getAppPath()+ "\\download\\AccRmtFailDetails.txt"));
		}

		// R10314
		int cnt = alDwnDetails.size()+alDwnDetailsD.size();
		
		if (cnt > 0){
			sendDownloadFile(request,response,filesToSend);
		}else{
			//�d�L��Ʀ^�ǿ��~�T��
			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg", "�d�L�i�U�����,�Э��s�d��!");
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccRmtFail.jsp");
			dispatcher.forward(request, response);
		}

	}
	
	private void sendDownloadFile(HttpServletRequest request, HttpServletResponse response,Collection filesToSend)throws ServletException,IOException{
		response.setContentType("application/zip");
		response.setStatus(HttpServletResponse.SC_OK);
		response.setHeader("Content-Disposition","attachment; filename=\"AccRmtFailDetails.zip\"");
			
		OutputStream os = null;
		BufferedOutputStream bos = null;
		ZipOutputStream zos = null;
		try {
			os = response.getOutputStream();
			bos = new BufferedOutputStream(os);
			zos = new ZipOutputStream(bos);
			zos.setLevel(ZipOutputStream.STORED);
			sendMultipleFiles(zos, filesToSend);
		} catch (IOException e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}finally {
			if (zos != null) {
				zos.finish();
				zos.flush();
			}
		}
	}

	private void exportToFile(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) throws ServletException, IOException, Exception {
		FileWriter fstream = null;
		BufferedWriter out = null;
		String file_name = globalEnviron.getAppPath()+ "\\download\\AccRmtFailDetails.txt";
		File file = new File(file_name);
		boolean exists = file.exists();
		if (!exists) {
			file.createNewFile();
		} else {
			file.delete();
			file.createNewFile();
		}
		if (alDwnDetails.size() > 0) {
			// ServletOutputStream os = response.getOutputStream();
			//R10314
			Collections.sort(alDwnDetails, new Comparator(){
 				public int compare(Object o1, Object o2) {
					DISBAccCodeDetailVO p1 = (DISBAccCodeDetailVO) o1;
					DISBAccCodeDetailVO p2 = (DISBAccCodeDetailVO) o2;
					return p1.getSort().compareToIgnoreCase(p2.getSort());
				}
			});
	
			try {

				/* ConvertData */
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
					for (int count = strActCd3.length(); count < 4; count++) { // R80656// 3->// 4�X
						strActCd3 += " ";
					}
					strActCd4 = objAccCodeDetail.getStrActCd4();
					for (int count = strActCd4.length(); count < 2; count++) {
						strActCd4 += " ";
					}
					strActCd5 = objAccCodeDetail.getStrActCd5();
					for (int count = strActCd5.length(); count < 26; count++) {// R61017// ActCd5��13�X��26�X
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

					// DESCRIPTION,x(30) �]������ �ҥHstrDesc.length()*2
					strDesc = objAccCodeDetail.getStrDesc() == null ? "": objAccCodeDetail.getStrDesc();
					strDesc = CommonUtil.AllTrim(strDesc);

					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}
					strCheckDt = objAccCodeDetail.getStrCheckDate();
					for (int count = strCheckDt.length(); count < 8; count++) {
						strCheckDt += " ";
					}
					strSlipNo = objAccCodeDetail.getStrSlipNo();
					for (int count = strSlipNo.length(); count < 15; count++) { // R80132 �� 9 -->12 R8062012-15
						strSlipNo += " ";
					}

					// R00308 Oracle �W�Ǯ榡�ܧ�
					String count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) {  // R80132 �� 9 -->12 R8062012-15
						count1 = "0" + count1;
					}

					if (!strDAmt.trim().equals("")|| !strCAmt.trim().equals("")) {
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
						export += strActCd5.substring(0, 2) + ",";// ACTCD5,x(26)/ ,R61017// ActCd5��13�X��26�X
						export += strActCd5.substring(2, 17) + ",";
						export += strActCd5.substring(17, 20) + ",";
						export += strActCd5.substring(20, 21) + ",";
						export += strActCd5.substring(21, 23) + ",";
						export += strActCd5.substring(23, 26) + ",";
						export += strPCfmDt.trim() + ",";// ��I�T�{�騴��,YYYY/MM/DD,x(10)
						export += strDAmt.trim() + ",";// �ɤ���B,x(12),�w�]��0,�����e�ɪť�,// 000,000
						export += strCAmt.trim() + ",";// �U����B,x(12),�w�]��0,�����e�ɪť�,// 000,000
						export += strSlipNo.trim() + ",";// SlipNo,x(11),// ��I�T�{�騴�餧�褸�~��G�X+MMDD// + 3�ӯS�w�X R80132 ��// 9 -->12 + ���O
						export += strDesc.trim() + ",";// Description ,x(30),������ɪť�
						export += "User" + ","; // R80620 Conversion Type
						export += "1" + ","; // R80620 Conversion Rate
						export += strPCfmDt.trim() + ",";// ��I�T�{�騴��,YYYY/MM/DD,x(10)
						export += "BATCH,";
						export += count1;
						export += "\r\n";// ����
					}
				}

				// R10314
				fstream = new FileWriter(file_name);
				out = new BufferedWriter(fstream);
				out.write(export);
			} finally {
				if (out != null)
					out.close();
			}
		}
	}

	private void exportToExFile(HttpServletRequest request, HttpServletResponse response, List alDwnDetailsD) throws ServletException, IOException, Exception {
		FileWriter fstream = null;
		BufferedWriter out = null;
		String file_name = globalEnviron.getAppPath()+ "\\download\\AccRmtFailDetailsD.txt";
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

					// R00308 Oracle �W�Ǯ榡�ܧ�
					String count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) {
						count1 = "0" + count1;
					}

					if (!strDAmt.trim().equals("") || !strCAmt.trim().equals("")) {
						System.out.println(strDAmt.trim());
						System.out.println(strCAmt.trim());

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
				// R10314
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
		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.getDPayments()");
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

		/* 1. ���o�ŦX�������ŦX�e�ݶװh����϶�����I���Ѥ��״ڸ��,�p�p���@��(�U��) */
		try {
			// �ɤ�ǲ��K�n�P�@����h�פ�B�P�@�I�ڻȦ�b���X�֤@������
			strSql = "SELECT DENSE_RANK() OVER (ORDER BY a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,A.PPAYCURR,b.FFEEWAY,a.REMITFAILD) AS SORT," ;
			strSql += "SUM(a.PAMT) AS PAMT,a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,SUM(a.PPAYAMT) AS PPAYAMT,A.PPAYCURR,b.FFEEWAY,SUM(b.FPAYAMT) AS FPAYAMT,a.REMITFAILD ";
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
				// �ɤ�
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

				String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ "/"+ strPStartDate.substring(3, 5)+ "/"+ strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ strPStartDate.substring(3, 5) + strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp2 = Integer.toString(1911 + Integer.parseInt(strRFDate.substring(0, 3)))+ "/"+ strRFDate.substring(3, 5)+ "/"+ strRFDate.substring(5, 7);//�h�פ�

				if (FFEEWAY.equals("BEN")) {
					objAccCodeDetailC.setStrActCd2(disbBean.getACTCD2(disbBean.getETableDesc("CURRA", PAYCURR.trim())));// R80132
					objAccCodeDetailC.setStrActCd3(strActCd3);// R80656
					objAccCodeDetailC.setStrActCd4("00");// R60550
					objAccCodeDetailC.setStrActCd5("00000000000000000000000000");
					//objAccCodeDetailC.setStrDAmt(df.format(PAYAMTTp));
					objAccCodeDetailC.setStrCAmt("0");
					// objAccCodeDetailC.setStrDesc("�װh�^�s");
					// R10314
					objAccCodeDetailC.setStrDesc("�h�צ^�s�w������" + DateTemp2);
					objAccCodeDetailC.setStrCheckDate(DateTemp1);
					objAccCodeDetailC.setStrDate1(DateTemp);
					objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));

					// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
					// RA0102 - 004->001-1
					if ("NT".equals(strCurrency)) {
						objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
						objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001-1"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						objAccCodeDetailC.setStrDAmt(df1.format(PAMTTp));
						objAccCodeDetailC.setStrCAmt("0");
						objAccCodeDetailC.setStrConverRate(String.valueOf(PPAYRATE));
						objAccCodeDetailC.setConversionCredit(df.format(PAYAMTTp));
						objAccCodeDetailC.setConversionDebit("0");
					} else {
						objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						objAccCodeDetailC.setStrDAmt(df1.format(PAYAMTTp));
						objAccCodeDetailC.setStrConverRate("1");
						objAccCodeDetailC.setConversionCredit("0");
						objAccCodeDetailC.setConversionDebit("0");
					}

					if (!rs.getString("PCURR").trim().equals("NT")) {
						objAccCodeDetailC.setStrActCd5("00000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
					}
					objAccCodeDetailC.setSort("D"+rs.getString("PBBANK"));
					alReturn.add(objAccCodeDetailC);

				} else {// OUR ,�S��SHA

					objAccCodeDetailC.setStrActCd2(disbBean.getACTCD2(disbBean.getETableDesc("CURRA", PAYCURR.trim())));// R80132
					objAccCodeDetailC.setStrActCd3(strActCd3);// R80656
					objAccCodeDetailC.setStrActCd4("00");// R60550
					objAccCodeDetailC.setStrActCd5("00000000000000000000000000");
					// objAccCodeDetailC.setStrDesc("�װh�^�s");
					// R10314
					objAccCodeDetailC.setStrDesc("�h�צ^�s�w������" + DateTemp2);
					//objAccCodeDetailC.setStrDAmt(df.format(PAYAMTTp));
					objAccCodeDetailC.setStrCAmt("0");
					objAccCodeDetailC.setStrCheckDate(DateTemp1);
					objAccCodeDetailC.setStrDate1(DateTemp);
					objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
					
					// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
					// RA0102 - 004->001-1
					if ("NT".equals(strCurrency)) {
						objAccCodeDetailC.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
						objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001-1"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						objAccCodeDetailC.setStrDAmt(df1.format(PAMTTp));
						objAccCodeDetailC.setStrCAmt("0");
						objAccCodeDetailC.setStrConverRate(String.valueOf(PPAYRATE));
						objAccCodeDetailC.setConversionCredit(df.format(PAYAMTTp));
						objAccCodeDetailC.setConversionDebit("0");
					} else {
						objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						objAccCodeDetailC.setStrDAmt(df1.format(PAYAMTTp));
						objAccCodeDetailC.setStrConverRate("1");
						objAccCodeDetailC.setConversionCredit("0");
						objAccCodeDetailC.setConversionDebit("0");
					}

					if (!rs.getString("PCURR").trim().equals("NT")) {
						objAccCodeDetailC.setStrActCd5("00000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
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
						// objAccCodeDetailC1.setStrDesc("�װh�^�s");
						// R10314
						if ("NT".equals(strCurrency))
							objAccCodeDetailC1.setStrDesc("�h�צ^�s�w������"+ DateTemp2);
						else
							objAccCodeDetailC1.setStrDesc("�׶O");
						objAccCodeDetailC1.setStrDAmt(df.format(FeeAmtTp));
						objAccCodeDetailC1.setStrCAmt("0");
						objAccCodeDetailC1.setStrCheckDate(DateTemp1);
						objAccCodeDetailC1.setStrDate1(DateTemp);
						objAccCodeDetailC1.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
						// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
						// RA0102 - 004->001-1
						if ("NT".equals(strCurrency)) {
							objAccCodeDetailC1.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
							objAccCodeDetailC1.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001-1"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
							objAccCodeDetailC1.setStrDAmt(df1.format(FPAYAMT));
							objAccCodeDetailC1.setStrConverRate(String.valueOf(PPAYRATE));
							objAccCodeDetailC1.setStrCAmt("0");
							objAccCodeDetailC1.setConversionCredit(df.format(FeeAmtTp));
							objAccCodeDetailC1.setConversionDebit("0");
						} else {
							objAccCodeDetailC1.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
							objAccCodeDetailC1.setStrConverRate("1");
							objAccCodeDetailC1.setConversionCredit("0");
							objAccCodeDetailC1.setConversionDebit("0");
						}

						if (!rs.getString("PCURR").trim().equals("NT")) {
							objAccCodeDetailC1.setStrActCd5("00000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						}
						objAccCodeDetailC1.setSort("D"+rs.getString("PBBANK")+rs.getString("SORT"));
						alReturn.add(objAccCodeDetailC1);
					}

				}

			}
			rs.close();
			strSql = null;

			//�U��
			strSql = "SELECT DENSE_RANK() OVER (ORDER BY a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,A.PNAME,A.PPAYCURR,b.FFEEWAY,a.REMITFAILD) AS SORT," ;
			strSql += "SUM(a.PAMT) AS PAMT,a.PBBANK,a.PBACCOUNT,a.PMETHOD,a.PCURR,a.PPAYRATE,SUM(a.PPAYAMT) AS PPAYAMT,A.PNAME,A.POLICYNO,A.PPAYCURR,b.FFEEWAY,SUM(b.FPAYAMT) AS FPAYAMT,SUM(a.PAMTNT) AS PAYAMTNT,a.REMITFAILD ";
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

				String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ "/"+ strPStartDate.substring(3, 5)+ "/"+ strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ strPStartDate.substring(3, 5) + strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp2 = Integer.toString(1911 + Integer.parseInt(strRFDate.substring(0, 3)))+ "/"+ strRFDate.substring(3, 5)+ "/"+ strRFDate.substring(5, 7);//�h�פ�

				if (FFEEWAY.equals("BEN")) {
					DISBAccCodeDetailVO objAccCodeDetailD = new DISBAccCodeDetailVO();
					objAccCodeDetailD.setStrActCd2("29004000ZZZ");
					objAccCodeDetailD.setStrActCd3("0000");
					objAccCodeDetailD.setStrActCd4("00");// R60550
					objAccCodeDetailD.setStrActCd5("00000000000000000000000000");
					//objAccCodeDetailD.setStrCAmt(df.format(PAYAMTTp));
					objAccCodeDetailD.setStrDAmt("0");
					objAccCodeDetailD.setStrDesc("�h��" + rs.getString("PNAME").trim());
					objAccCodeDetailD.setStrCheckDate(DateTemp1);
					objAccCodeDetailD.setStrDate1(DateTemp);
					objAccCodeDetailD.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
					
					// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
					// RA0102 004->001-1
					if ("NT".equals(strCurrency)) {
						objAccCodeDetailD.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
						objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001-1"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						objAccCodeDetailD.setStrCAmt(df1.format(PAMTTp));
						objAccCodeDetailD.setStrDAmt("0");
						objAccCodeDetailD.setStrConverRate(String.valueOf(PPAYRATE));
						objAccCodeDetailD.setConversionCredit("0");
						objAccCodeDetailD.setConversionDebit(df.format(PAYAMTTp));
					} else {
						objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						objAccCodeDetailD.setStrCAmt(df1.format(PAYAMTTp));
						objAccCodeDetailD.setStrConverRate("1");
						objAccCodeDetailD.setConversionCredit("0");
						objAccCodeDetailD.setConversionDebit("0");
					}
	
					if (!rs.getString("PCURR").trim().equals("NT")) {
						objAccCodeDetailD.setStrActCd5("00000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
					}
					objAccCodeDetailD.setSort("D"+rs.getString("PBBANK")+rs.getString("SORT"));
					alReturn.add(objAccCodeDetailD);

				} else {

					DISBAccCodeDetailVO objAccCodeDetailD = new DISBAccCodeDetailVO();
					objAccCodeDetailD.setStrActCd2("29004000ZZZ");
					objAccCodeDetailD.setStrActCd3("0000");
					objAccCodeDetailD.setStrActCd4("00");
					objAccCodeDetailD.setStrActCd5("00000000000000000000000000");
					objAccCodeDetailD.setStrDesc("�h��"+ rs.getString("PNAME").trim());
					objAccCodeDetailD.setStrCAmt(df.format(PAMT));// ��I�ڪ��B
					objAccCodeDetailD.setStrDAmt("0");
					objAccCodeDetailD.setStrCheckDate(DateTemp1);
					objAccCodeDetailD.setStrDate1(DateTemp);
					objAccCodeDetailD.setStrCurr(disbBean.getETableDesc("CURRA", strCurrency.trim()));
					// R10314 - �x���O��~���h�ץ�A�ǲ����Xxxxxxx004TWD
					// RA0102 - 004->001-1
					if ("NT".equals(strCurrency)) {
						objAccCodeDetailD.setStrCurr(disbBean.getETableDesc("CURRA", PAYCURR.trim()));
						objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001-1"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						objAccCodeDetailD.setStrCAmt(df1.format(PPAYAMT));// ��I�ڪ��B
						objAccCodeDetailD.setStrDAmt("0");
						objAccCodeDetailD.setStrConverRate(String.valueOf(PPAYRATE));
						objAccCodeDetailD.setConversionCredit("0");// �U������A�h���ťաC
						objAccCodeDetailD.setConversionDebit(df.format(PAYAMTNT));
					} else {
						objAccCodeDetailD.setStrConverRate("1");
						objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7)+ DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
						objAccCodeDetailD.setConversionCredit("0");
						objAccCodeDetailD.setConversionDebit("0");
					}
					// R80620if (rs.getString("PCURR").trim() != "NT"){
					if (!rs.getString("PCURR").trim().equals("NT")) {
						objAccCodeDetailD.setStrActCd5("00000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
					} // R80132 END
					objAccCodeDetailD.setSort("D"+rs.getString("PBBANK")+rs.getString("SORT"));
					alReturn.add(objAccCodeDetailD);
				}
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

	/**
	 * @param request
	 * @param response
	 * @return
	 */
	private List getBPayments(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) {

		Connection con = dbFactory.getAS400Connection("DISBCheckStockServlet.inquiryDB()");
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

		/* 1. ���o�ŦX�������ŦX�e�ݶװh����϶�����I���Ѥ��״ڸ��,�p�p���@��(�U��) */

		try {
			strSql =
			// R70366 "select SUM(PAMT) AS SPAMT,PMETHOD,PCURR";
			// �ɤ�ǲ��K�n�P�@����h�פ�B�P�@�I�ڻȦ�b���X�֤@������
			"select SUM(PAMT) AS SPAMT,PBBANK,PBACCOUNT,PMETHOD,PCURR,PBNKRFDT,REMITFAILD,DENSE_RANK() OVER (ORDER BY PBBANK,PBACCOUNT,PMETHOD,PCURR,PBNKRFDT,REMITFAILD) AS SORT   ";// R70366 R10314
			strSql += " from CAPPAYF ";
			strSql += "WHERE  PMETHOD ='B' and PSTATUS = 'A' ";
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
				strActCd3 = disbBean.getACTCDFinRmt(rs.getString("PBBANK").substring(0, 3), rs.getString("PBACCOUNT"), "NT") == null ? " ": disbBean.getACTCDFinRmt(rs.getString("PBBANK").substring(0, 3),rs.getString("PBACCOUNT"), "NT").trim();
				if (strActCd3.length() < 13)
					strActCd3 = rs.getString("PBBANK").substring(0, 3) + " ";
				else
					strActCd3 = rs.getString("PBBANK").substring(0, 3)+ strActCd3.substring(12, 13);

				// R10314
				String strRFDate = "";
				if (rs.getString("REMITFAILD").length() < 7)
					strRFDate = "0" + rs.getString("REMITFAILD");
				else
					strRFDate = rs.getString("REMITFAILD");

				String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ "/"+ strPStartDate.substring(3, 5)+ "/"+ strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ strPStartDate.substring(3, 5) + strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp2 = Integer.toString(1911 + Integer.parseInt(strRFDate.substring(0, 3)))+ "/"+ strRFDate.substring(3, 5)+ "/"+ strRFDate.substring(5, 7);//�h�פ�

				if (rs.getString("PMETHOD").trim().equals("B")) {
					objAccCodeDetail.setStrActCd2(disbBean.getACTCD2(disbBean.getETableDesc("CURRA", PCURR.trim())));// R80132
					objAccCodeDetail.setStrActCd3(strActCd3);// R80656
					objAccCodeDetail.setStrActCd4("00");// R60550
					objAccCodeDetail.setStrActCd5("00000000000000000000000000"); // R61017
																					// ActCd5��13�X��26�X
					objAccCodeDetail.setStrDesc("�h�צ^�s-������" + DateTemp2);
				}
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("SPAMT")));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				// R80132
				// objAccCodeDetail.setStrCurr(disbBean.getCurr(strCurrency.trim(),1));//R70088
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA",strCurrency.trim()));// R80132
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7) + DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA", strCurrency.trim()));
				// R80620 if (rs.getString("PCURR").trim() != "NT"){
				if (!rs.getString("PCURR").trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
				} // R80132 END
				objAccCodeDetail.setSort("A"+rs.getInt("SORT"));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;

			/* 1. ���o�ŦX�������ŦX�e�ݶװh����϶�����I���Ѥ��״ک��Ӹ��--�ɤ� */
			strSql = "select DENSE_RANK() OVER (ORDER BY PBBANK,PBACCOUNT,PMETHOD,PCURR,PBNKRFDT,REMITFAILD) AS SORT,PAMT ,PMETHOD,PNAME,PCURR,REMITFAILD ";//R10314
			strSql += " from CAPPAYF ";
			strSql += "WHERE  PMETHOD ='B' and PSTATUS ='A' ";
			// strSql += " and UPDDT between " + strPStartDate + "  and " +
			// strPEndDate ;
			strSql += " and PBNKRFDT = " + strPStartDate;// R10314
			strSql += " and PCURR='" + strCurrency + "'";
			System.out.println("strSql_4" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {

				String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ "/"+ strPStartDate.substring(3, 5)+ "/"+ strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ strPStartDate.substring(3, 5) + strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��

				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd3("0000");
				objAccCodeDetail.setStrActCd4("00");// R60550
				objAccCodeDetail.setStrActCd5("00000000000000000000000000"); // R61017
																				// ActCd5��13�X��26�X
				objAccCodeDetail.setStrDesc("�h��" + rs.getString("PNAME").trim());
				objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("PAMT")));
				objAccCodeDetail.setStrDAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				// R80132
				// objAccCodeDetail.setStrCurr(disbBean.getCurr(strCurrency.trim(),1));//R70088
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA",strCurrency.trim()));// R80132
				// R80132
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7) + DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA", strCurrency.trim()));
				// R80620 if (rs.getString("PCURR").trim() != "NT"){
				if (!rs.getString("PCURR").trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
				} // R80132 END
				objAccCodeDetail.setSort("A"+rs.getInt("SORT"));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;

			// �H�Υd�״ڥ��ѡA�ɤ�ǲ��K�n�P�@����h�פ�B�P�@�I�ڻȦ�b���X�֤@������
			strSql = "select SUM(PAMT) AS SPAMT,PBBANK,PBACCOUNT,PMETHOD,PCURR,REMITFAILD ";// R10314
			strSql += ",DENSE_RANK() OVER (ORDER BY PBBANK,PBACCOUNT,PMETHOD,PCURR,REMITFAILD) AS SORT ";	//RA0102
			strSql += " from CAPPAYF ";
			strSql += "WHERE  PMETHOD ='C' and PSTATUS = 'A' ";
			// strSql += " and UPDDT between " + strPStartDate + "  and " +
			// strPEndDate ;
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

				String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ "/"+ strPStartDate.substring(3, 5)+ "/"+ strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ strPStartDate.substring(3, 5) + strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp2 = Integer.toString(1911 + Integer.parseInt(strRFDate.substring(0, 3)))+ "/"+ strRFDate.substring(3, 5)+ "/"+ strRFDate.substring(5, 7);//�h�פ�

				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				if (rs.getString("PMETHOD").trim().equals("C")) {
					objAccCodeDetail.setStrActCd2("11100000ZZZ");
					objAccCodeDetail.setStrActCd3("0000");
					objAccCodeDetail.setStrActCd4("00");// R60550
					objAccCodeDetail.setStrActCd5("P1000000000000000000000000"); // R61017
																					// ActCd5��13�X��26�X
					// R10314
					// objAccCodeDetail.setStrDesc("�H�Υd�^�s");
					objAccCodeDetail.setStrDesc("�H�Υd�^�s-������" + DateTemp2);
				}
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("SPAMT")));
				objAccCodeDetail.setStrCAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA",strCurrency.trim())); // R80132
				// R80132
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7) + DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA", strCurrency.trim()));
				// R80620if (rs.getString("PCURR").trim() != "NT"){
				if (!rs.getString("PCURR").trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("P1000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
				} // R80132 END
				objAccCodeDetail.setSort("B"+rs.getInt("SORT"));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;

			/* 1. ���o�ŦX�������ŦX�e�ݶװh����϶�����I���Ѥ��H�Υd���Ӹ��--�ɤ� */
			strSql = "select PAMT ,PMETHOD,PNAME ,PCURR ";
			strSql += ",DENSE_RANK() OVER (ORDER BY PBBANK,PBACCOUNT,PMETHOD,PCURR,REMITFAILD) AS SORT ";	//RA0102
			strSql += " from CAPPAYF ";
			strSql += "WHERE  PMETHOD ='C' and PSTATUS ='A' ";
			// strSql += " and UPDDT between " + strPStartDate + "  and " +
			// strPEndDate ;
			strSql += " and PBNKRFDT = " + strPStartDate;// R10314
			strSql += " and PCURR='" + strCurrency + "'";
			System.out.println("strSql_6" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {

				String DateTemp = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ "/"+ strPStartDate.substring(3, 5)+ "/"+ strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��
				String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPStartDate.substring(0, 3)))+ strPStartDate.substring(3, 5) + strPStartDate.substring(5, 7);//�Ȧ�h�צ^�s��

				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrActCd2("29004000ZZZ");
				objAccCodeDetail.setStrActCd3("0000");
				objAccCodeDetail.setStrActCd4("00");// R60550
				objAccCodeDetail.setStrActCd5("00000000000000000000000000"); // R61017
																				// ActCd5��13�X��26�X
				objAccCodeDetail.setStrDesc("�h�׫H�Υd"+ rs.getString("PNAME").trim());
				objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("PAMT")));
				objAccCodeDetail.setStrDAmt("0");
				objAccCodeDetail.setStrCheckDate(DateTemp1);
				objAccCodeDetail.setStrDate1(DateTemp);
				objAccCodeDetail.setStrCurr(disbBean.getETableDesc("CURRA",strCurrency.trim()));  // R80132					
				// R80132
				objAccCodeDetail.setStrSlipNo(DateTemp.substring(2, 4)+ DateTemp.substring(5, 7) + DateTemp.substring(8)+ "001"+ disbBean.getETableDesc("CURRA", strCurrency.trim()));
				// R80620 if (rs.getString("PCURR").trim() != "NT"){
				if (!rs.getString("PCURR").trim().equals("NT")) {
					objAccCodeDetail.setStrActCd5("00000000000000000000000"+ disbBean.getETableDesc("CURRA",strCurrency.trim()));
				}
				objAccCodeDetail.setSort("B"+rs.getInt("SORT"));
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;

			// System.out.println("4.alReturn.size()"+alReturn.size());
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

	// R10314
	protected void sendMultipleFiles(ZipOutputStream zos, Collection filesToSend)
			throws IOException {
		Iterator iterator = null;
		FileInputStream fis = null;
		File f = null;
		byte bytes[] = new byte[2048];
		for (iterator = filesToSend.iterator(); iterator.hasNext();) {
			f = (File) iterator.next();
			try {
				fis = new FileInputStream(f);
				BufferedInputStream bis = new BufferedInputStream(fis);
				zos.putNextEntry(new ZipEntry(f.getName()));
				int bytesRead;
				while ((bytesRead = bis.read(bytes)) != -1) {
					zos.write(bytes, 0, bytesRead);
				}
			} catch (IOException e) {
				System.out.println("Cannot find " + f.getAbsolutePath());
			} finally {
				if (zos != null)
					zos.closeEntry();
			}
		}
	}

}
