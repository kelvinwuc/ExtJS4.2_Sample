package com.aegon.disb.disbmaintain;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import org.apache.log4j.Logger;

/**
 * System   : CashWeb
 * 
 * Function : �䲼���ʷ|�p����
 * 
 * Remark   : �޲z�t�΢w�]��
 * 
 * Revision : $$Revision: 1.13 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:              
 * 
 * $$Log: DISBCStatusAccCdServlet.java,v $
 * $Revision 1.13  2013/12/24 03:02:35  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.12  2013/02/26 03:17:13  ODCZheJun
 * $R00135 BRD5-5----5-9
 * $
 * $Revision 1.11  2010/11/23 06:44:07  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.10  2010/11/18 12:22:51  MISJIMMY
 * $R00386 �����O��
 * $
 * $Revision 1.9  2010/10/25 07:06:16  MISJIMMY
 * $R00308
 * $
 * $Revision 1.9 2010/09/03 09:00:43  MISJIMMY
 * $//R00308 Oracle �W�Ǯ榡�ܧ�
 * $
 * * $$Log: DISBCStatusAccCdServlet.java,v $
 * * $Revision 1.13  2013/12/24 03:02:35  MISSALLY
 * * $R00135---PA0024---CASH�~�ױM��
 * * $
 * * $Revision 1.12  2013/02/26 03:17:13  ODCZheJun
 * * $R00135 BRD5-5----5-9
 * * $
 * * $Revision 1.11  2010/11/23 06:44:07  MISJIMMY
 * * $R00226-�ʦ~�M��
 * * $
 * * $Revision 1.10  2010/11/18 12:22:51  MISJIMMY
 * * $R00386 �����O��
 * * $
 * * $Revision 1.9  2010/10/25 07:06:16  MISJIMMY
 * * $R00308
 * * $
 * $Revision 1.8  2008/11/03 09:00:43  MISODIN
 * $R80413 READ CAPBNKF �վ�
 * $
 * $Revision 1.7  2008/09/15 02:59:18  misvanessa
 * $R80656_ActCd3��ز�4�X���TABLE
 * $
 * $Revision 1.6  2008/08/15 04:10:18  misvanessa
 * $R80620_�|�p��ؤU���ɮ׷s�W3���
 * $
 * $Revision 1.5  2007/10/05 09:11:50  MISVANESSA
 * $R70770_ACTCD2 �X�� 11 �X
 * $
 * $Revision 1.4  2006/11/07 07:53:54  miselsa
 * $R61017_ActCd5��13�X��26�X
 * $
 * $Revision 1.3  2006/08/25 05:58:14  miselsa
 * $Q60159_1.���ڪ��AC->5 �|�p��حק�
 * $              2.���ڪ��A5->6 �|�p��حק�
 * $              3.�ɬ�101T�M101720�����,�~�|�a�Ȧ�N�X,�_�h��0000
 * $                 ,���p���ڪ��A5->6�ɻȦ�N�X�T�w��8223
 * $               4.�s�W�Ȧ�N�X8083
 * $               5.D->V,D->4,1->4,2->4�|�p����ܧ�
 * $               6.�s�W��ղ��|�p����
 * $
 * $Revision 1.2  2006/08/14 08:13:41  miselsa
 * $Q60159_�|�p�����ɶU��V���~�ηs�W��ղ��@�o���|�p����
 * $
 * $Revision 1.1  2006/06/29 09:40:14  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.6  2005/11/03 08:36:22  misangel
 * $R50820:��I�\�ണ��-�����䲼����魭��
 * $
 * $Revision 1.1.2.5  2005/04/25 07:23:52  miselsa
 * $R30530
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:27  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

public class DISBCStatusAccCdServlet extends InitDBServlet {
	
	private Logger log = Logger.getLogger(getClass());

	private DISBBean disbBean = null;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private DecimalFormat df = new DecimalFormat("0");

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		try {
			this.downloadProcess(request, response);
		} catch (Exception e) {
			System.err.println(e.toString());

			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg", e.getMessage());
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBCStatusAccCode.jsp");
			dispatcher.forward(request, response);
		}
	}
	
	private void downloadProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception{
		System.out.println("inside downloadProcess");
		List alDwnDetails = new ArrayList();

		/* 1.���o�ŦX����骺���ک��Ӹ��, �ñN�������B�[�`, �ò��ͤG���ɶU�|�p��� */

		String strCheqDtS = request.getParameter("txtCheqDtS");
		String strCheqDtE = request.getParameter("txtCheqDtE");
		if (!strCheqDtS.trim().equals("") || !strCheqDtE.trim().equals("")) {
			System.out.println("inside downloadProcess: txtCheqDtS" + strCheqDtS);
			System.out.println("inside downloadProcess: txtCheqDtE" + strCheqDtE);
			alDwnDetails = (List) getCDetailByExDt(request, response, alDwnDetails); // Q60159�N���ڨ����אּ�_����
		}

		/* 2.���o�ŦX���ʤ�����䲼���ʷ|�p��� */
		String strUpdDt = request.getParameter("txtUpdDt");
		if (strUpdDt != null)
			strUpdDt = strUpdDt.trim();
		else
			strUpdDt = "";
		if (!strUpdDt.equals(""))
			alDwnDetails = (List) getDwnDetailByUpdDt(request, response, alDwnDetails);
		
		/*String company = "";//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}*/

		if (alDwnDetails.size() > 0) {
			System.out.println("1_alDwnDetails.size()=" + alDwnDetails.size());
			ServletOutputStream os = response.getOutputStream();
			try {
				/* ConvertData */
				response.setContentType("text/plain");// text/plain
				response.setHeader("Content-Disposition", "attachment; filename=CheckStatusDetails.txt");
				String export = "";
				disbBean = new DISBBean(dbFactory);

				String strCate = null;
				String strSource = null;
				String strCurr = null;
				String strActCd1 = null;
				String strActCd2 = null;
				String strActCd3 = null;
				String strActCd4 = null;
				String strActCd5 = null;
				String strDate1 = null;
				String strDAmt = null;
				String strCAmt = null;
				String strSlipNo = null;
				String strDesc = null;
				String strLedger = null;

				for (int i = 0; i < alDwnDetails.size(); i++) {

					DISBAccCodeDetailVO objAccCodeDetail = (DISBAccCodeDetailVO) alDwnDetails.get(i);
					
					//RD0382:OIU
					String company = "";
					company = objAccCodeDetail.getPayCompany().trim();

					strCate = objAccCodeDetail.getStrCategory();
					for (int count = strCate.length(); count < 6; count++) {
						strCate += " ";
					}

					strSource = objAccCodeDetail.getStrSource();
					for (int count = strSource.length(); count < 11; count++) {
						strSource += " ";
					}

					strCurr = objAccCodeDetail.getStrCurr();
					for (int count = strCurr.length(); count < 3; count++) {
						strCurr += " ";
					}

					strLedger = disbBean.getLedger(CommonUtil.AllTrim(disbBean.getETableDesc("CURRC", strCurr)));	

					strActCd1 = objAccCodeDetail.getStrActCd1();
					for (int count = strActCd1.length(); count < 1; count++) {
						strActCd1 += " ";
					}

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

					strDate1 = objAccCodeDetail.getStrDate1();
					for (int count = strDate1.length(); count < 10; count++) {
						strDate1 += " ";
					}

					strDAmt = objAccCodeDetail.getStrDAmt();
					if (strDAmt.equals("0")) {
						strDAmt = " ";
					}
					for (int count = strDAmt.length(); count < 13; count++) {
						strDAmt = " " + strDAmt;
					}

					strCAmt = objAccCodeDetail.getStrCAmt();
					System.out.println(strCAmt);
					if (strCAmt.equals("0")) {
						strCAmt = " ";
					}
					for (int count = strCAmt.length(); count < 13; count++) {
						strCAmt = " " + strCAmt;
					}

					strSlipNo = objAccCodeDetail.getStrSlipNo();
					for (int count = strSlipNo.length(); count < 15; count++) {
						strSlipNo += " ";
					}

					strDesc = objAccCodeDetail.getStrDesc() == null ? "" : objAccCodeDetail.getStrDesc();
					strDesc = CommonUtil.AllTrim(strDesc);
					for (int count = strDesc.getBytes().length; count < 30; count++) {
						strDesc = strDesc + " ";
					}

					String count1 = String.valueOf(i + 1);
					for (int count = String.valueOf(i + 1).length(); count < 5; count++) {
						count1 = "0" + count1;
					}

					if (!strDAmt.trim().equals("") || !strCAmt.trim().equals("")) 
					{
						//if("6".equals(company)){
						if("OIU".equals(company)){
							String currency = strLedger.substring(strLedger.length()-3);
							if("nc.".equals(currency)){
								export += strLedger + " OIU,";
							}else{
								export += strLedger.substring(0, strLedger.length()-3) + " OIU " + currency + ",";
							}
							export += "" + ",";
						}else /*if("0".equals(company))*/{
							export += strLedger + ",";
						}
						
						export += strCate + ",";// Category, x(6)
						export += strSource + ",";// Source,x(11)
						export += strCurr + ",";// Currency,x(3),
						export += strActCd1 + ",";// ACTCD1,x(1)
						export += strActCd2.substring(0, 6) + ",";// ACTCD2,x(10),F��
						//RE0298-�O2�~�䲼���ব�J�|�p���,�t�λݰ��վ�
						if("299000".equals(strActCd2.substring(0, 6))){
							export += "0" + ",";//channel,G��
							export += "0" + ",";//LOB,H��
						}else{
							export += strActCd2.substring(6, 7) + ",";//channel,G��
							export += strActCd2.substring(7, 8) + ",";//LOB,H��
						}
						
						export += strActCd2.substring(8, 9) + ","; //Z,I��
						export += strActCd2.substring(9, 11) + ",";//ZZ,J��
						export += strActCd3.substring(0, 3) + ",";// ACTCD3,x(4)
						export += strActCd3.substring(3, 4) + ",";
						if("299000".equals(strActCd2.substring(0, 6))){
							export += "00" + ",";//dept.,M��
						}else{
							export += strActCd4 + ",";// ACTCD4,x(2)
						}
						
						export += strActCd5.substring(0, 2) + ",";// ACTCD5,x(26),R61017 ActCd5��13�X��26�X
						export += strActCd5.substring(2, 17) + ",";
						export += strActCd5.substring(17, 20) + ",";
						export += strActCd5.substring(20, 21) + ",";
						export += strActCd5.substring(21, 23) + ",";
						export += strActCd5.substring(23, 26) + ",";
						export += strDate1.trim() + ",";// ��I�T�{�騴��,YYYY/MM/DD,x(10)
						export += strDAmt.trim() + ",";// �ɤ���B,x(12),�w�]��0,�����e�ɪť�, 000,000
						export += strCAmt.trim() + ",";// �U����B,x(12),�w�]��0,�����e�ɪť�, 000,000
						export += strSlipNo.trim() + ",";// SlipNo,x(9), ��I�T�{�騴�餧�褸�~��G�X+MMDD + 3�ӯS�w�X
						export += strDesc.trim() + ",";// Description ,x(30),������ɪť�
						export += "User" + ","; // R80620 Conversion Type
						export += "1" + ","; // R80620 Conversion Rate
						export += strDate1.trim() + ",";// ��I�T�{�騴��,YYYY/MM/DD,x(10)
						export += "BATCH,";
						export += count1;
						export += "\r\n";
					}

				}
				ByteArrayInputStream is = new ByteArrayInputStream(export.getBytes());
				int reader = 0;
				byte[] buffer = new byte[1 * 1024];
				while ((reader = is.read(buffer)) > 0) {
					os.write(buffer, 0, reader);
				}
			} finally {
				os.flush();
				os.close();
			}
		} else {
			// �d�L��Ʀ^�ǿ��~�T��
			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg", "�d�L�i�U�����,�Э��s�d��!");
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBCStatusAccCode.jsp");
			dispatcher.forward(request, response);
		}

	}

	private List getDwnDetailByUpdDt(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) {

		Connection con = dbFactory.getAS400Connection("DISBCStatusAccCdServlet.getDwnDetailByUpdDt()");
		CommonUtil commonUtil = new CommonUtil();
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = "";
		List alReturn = new ArrayList();
		String strUpdDt = "";
		double iAmt = 0;

		strUpdDt = request.getParameter("txtUpdDt");
		if (strUpdDt != null)
			strUpdDt = strUpdDt.trim();
		else
			strUpdDt = "";
		
		String company = "";//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}

		try {
			strSql = "select CATEG,ACNTSOUR,ACNTCURR,ACTCD1,ACTCD2,ACTCD3,ACTCD4,ACTCD5,DATE1,CREAMT,DEBAMT,SLIPNO,DESPTXT1 ";
			strSql += " from CAPCHAF C ";
			// R00135 �Ȼݲ���XXXXXX002TWD�ǲ����X���|�p����
			strSql += "WHERE SLIPNO like '%002TWD%' and ENTRYDT	=" + strUpdDt;
			
			
			//RD0382:OIU
			if("6".equals(company)){
				strSql += " AND TRIM(SUBSTR(DESPTXT1,0,LOCATE('(',DESPTXT1))) IN(SELECT B.PAY_CHECK_NO FROM CAPCHKF A LEFT OUTER JOIN CAPPAYF B ON A.PAY_NO = B.PAY_NO AND B.PAY_COMPANY='6') ";//RD0382:OIU
			}else if("0".equals(company)){
				strSql += " AND TRIM(SUBSTR(DESPTXT1,0,LOCATE('(',DESPTXT1))) IN(SELECT B.PAY_CHECK_NO FROM CAPCHKF A LEFT OUTER JOIN CAPPAYF B ON A.PAY_NO = B.PAY_NO AND B.PAY_COMPANY<>'6') ";//RD0382:OIU
			}
			
			strSql += " ORDER BY DESPTXT1,CREAMT ";

			System.out.println("strSql1=" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			while (rs.next()) {
				DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
				objAccCodeDetail.setStrCategory(rs.getString("CATEG").trim());
				objAccCodeDetail.setStrSource(rs.getString("ACNTSOUR").trim());
				objAccCodeDetail.setStrCurr(rs.getString("ACNTCURR").trim());
				objAccCodeDetail.setStrActCd1(rs.getString("ACTCD1").trim());
				objAccCodeDetail.setStrActCd2(rs.getString("ACTCD2"));
				objAccCodeDetail.setStrActCd3(rs.getString("ACTCD3").trim());
				objAccCodeDetail.setStrActCd4(rs.getString("ACTCD4"));
				objAccCodeDetail.setStrActCd5(rs.getString("ACTCD5").trim());
				objAccCodeDetail.setStrDate1(rs.getString("DATE1").trim());
				objAccCodeDetail.setStrDAmt(df.format(rs.getDouble("DEBAMT")));
				objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("CREAMT")));
				
				if("6".equals(company)){
					objAccCodeDetail.setStrSlipNo(rs.getString("SLIPNO").trim().substring(0, 6) + "OIU" + rs.getString("SLIPNO").trim().substring(6));
				}else if("0".equals(company)){
					objAccCodeDetail.setStrSlipNo(rs.getString("SLIPNO").trim());
				}
				
				objAccCodeDetail.setStrDesc(rs.getString("DESPTXT1").trim());
				alReturn.add(objAccCodeDetail);
			}
			rs.close();
			strSql = null;

			// System.out.println("4.alReturn.size()"+alReturn.size());
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			System.err.println("err Msg=" + ex);
			log.error(ex.getMessage(), ex);
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

	private List getCDetailByExDt(HttpServletRequest request, HttpServletResponse response, List alDwnDetails) {

		Connection con = dbFactory.getAS400Connection("DISBCStatusAccCdServlet.getCDetailByExDt()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; // SQL String
		List alReturn = new ArrayList();
		String strCheqDt = "";
		String strCheqDtS = ""; // ����� Q60159 �אּ�_����,�_��
		String strCheqDtE = ""; // ����� Q60159 �אּ�_����,����
		String strActCd3 = ""; // R80656

		strCheqDt = request.getParameter("txtCheqDt");
		if (strCheqDt != null)
			strCheqDt = strCheqDt.trim();
		else
			strCheqDt = "";

		strCheqDtS = request.getParameter("txtCheqDtS");
		if (strCheqDtS != null)
			strCheqDtS = strCheqDtS.trim();
		else
			strCheqDtS = "";

		strCheqDtE = request.getParameter("txtCheqDtE");
		if (strCheqDtE != null)
			strCheqDtE = strCheqDtE.trim();
		else
			strCheqDtE = "";
		
		String company = "";//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}

		/* Q60159 ���ڨ����אּ�϶� ��������ڨ���餧���� Start */
		String strCheqDtTemp = strCheqDtE;
		if (strCheqDtTemp.length() < 7)
			strCheqDtTemp = "0" + strCheqDtTemp;
		String DateTemp = Integer.toString(1911 + Integer.parseInt(strCheqDtTemp.substring(0, 3))) + "/" + strCheqDtTemp.substring(3, 5) + "/" + strCheqDtTemp.substring(5, 7);
		/* Q60159 ���ڨ����אּ�϶� End */

		try {
			/* Q60159 ���ڨ����אּ�϶�,group by �W�[CHEQUEDT��� Start */
			strSql = "select SUM(B.CAMT) AS SCAMT,SUBSTRING(B.CBKNO, 1, 3) AS CBKNO,B.CACCOUNT,B.CHEQUEDT ";
			strSql += ",IFNULL(A.PAY_COMPANY,'') AS PAY_COMPANY ";//RD0382:OIU
			strSql += "from CAPCHKF B ";
			strSql += " LEFT OUTER JOIN CAPPAYF A ON A.PAY_NO = B.PAY_NO "; //RD0382:OIU
			strSql += " WHERE 1=1 ";
			if (!strCheqDtS.equals("")) {
				strSql += " and B.CHEQUEDT >=   " + Integer.parseInt(strCheqDtS);
			}
			if (!strCheqDtE.equals("")) {
				strSql += " and B.CHEQUEDT <=   " + Integer.parseInt(strCheqDtE);
			}

			strSql += " AND B.CSTATUS IN('D','C') ";
			
			//RD0382:OIU
			if("6".equals(company)){
				strSql += " AND A.PAY_COMPANY='6' ";
			}else if("0".equals(company)){
				strSql += " AND A.PAY_COMPANY<>'6' ";
			}
			
			strSql += " GROUP BY B.CBKNO,B.CACCOUNT,B.CHEQUEDT";
			strSql += ",A.PAY_COMPANY "; //RD0382:OIU
			/* Q60159 ���ڨ����אּ�϶�,group by �W�[CHEQUEDT��� End */

			System.out.println("strSql2=" + strSql);
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			alReturn = alDwnDetails;
			disbBean = new DISBBean(dbFactory);
			while (rs.next()) {
				
				String payCompany = "";//RD0382:OIU
				payCompany = rs.getString("PAY_COMPANY").trim();//RD0382:OIU
				
				/* ���ͤ@���U��|�p��� */
				strActCd3 = disbBean.getACTCDFinRmt(rs.getString("CBKNO"), rs.getString("CACCOUNT"), "NT") == null ? " " : disbBean.getACTCDFinRmt(rs.getString("CBKNO"), rs.getString("CACCOUNT"), "NT").trim();

				if (strActCd3.length() < 13)
					strActCd3 = rs.getString("CBKNO") + " ";
				else
					strActCd3 = rs.getString("CBKNO") + strActCd3.substring(12, 13);

				DISBAccCodeDetailVO objAccCodeDetailD = new DISBAccCodeDetailVO();
				objAccCodeDetailD.setPayCompany(payCompany);//RD0382:OIU
				objAccCodeDetailD.setStrCategory("Manual");
				objAccCodeDetailD.setStrSource("Spreadsheet");
				objAccCodeDetailD.setStrCurr("TWD");
				
				if("6".equals(company)){
					objAccCodeDetailD.setStrActCd1("6");
				}else {
					objAccCodeDetailD.setStrActCd1("0");
				}				
				
				objAccCodeDetailD.setStrActCd2("101T1000ZZZ");
				objAccCodeDetailD.setStrActCd3(strActCd3);
				objAccCodeDetailD.setStrActCd4("00");
				objAccCodeDetailD.setStrActCd5("00000000000000000000000000"); // R61017 ActCd5��13�X��26�X
				objAccCodeDetailD.setStrDate1(DateTemp);
				objAccCodeDetailD.setStrCAmt(df.format(rs.getDouble("SCAMT")));
				objAccCodeDetailD.setStrDAmt("0");
				
				if("6".equals(company)){
					objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "500" + "TWD   ");// R80620�[�W���O
				}else {
					objAccCodeDetailD.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "500" + "TWD   ");// R80620�[�W���O
				}
				
				objAccCodeDetailD.setStrDesc(DateTemp + "NP" + rs.getString("CBKNO") + "3");

				alReturn.add(objAccCodeDetailD);
				objAccCodeDetailD = null;

				/* ���ͤ@���ɤ�|�p��� */
				DISBAccCodeDetailVO objAccCodeDetailC = new DISBAccCodeDetailVO();
				objAccCodeDetailD.setPayCompany(payCompany);//RD0382:OIU
				objAccCodeDetailC.setStrCategory("Manual");
				objAccCodeDetailC.setStrSource("Spreadsheet");
				objAccCodeDetailC.setStrCurr("TWD");
				
				if("6".equals(company)){
					objAccCodeDetailC.setStrActCd1("6");
				}else {
					objAccCodeDetailC.setStrActCd1("0");
				}				
				
				objAccCodeDetailC.setStrActCd2("27100000ZZZ");
				objAccCodeDetailC.setStrDate1(DateTemp);
				objAccCodeDetailC.setStrActCd3("0000");
				objAccCodeDetailC.setStrActCd4("00");
				objAccCodeDetailC.setStrActCd5("00000000000000000000000000"); // R61017 ActCd5��13�X��26�X
				objAccCodeDetailC.setStrDAmt(df.format(rs.getDouble("SCAMT")));
				objAccCodeDetailC.setStrCAmt("0");
				
				if("6".equals(company)){
					objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "OIU" + "500" + "TWD   ");// R80620�[�W���O
				}else {
					objAccCodeDetailC.setStrSlipNo(DateTemp.substring(2, 4) + DateTemp.substring(5, 7) + DateTemp.substring(8) + "500" + "TWD   ");// R80620�[�W���O
				}
				
				objAccCodeDetailC.setStrDesc(DateTemp + "NP" + rs.getString("CBKNO") + "3");// Q60159 �ɤ�Desc�����ť�,�אּ�M�U��Desc �ۦP 20060815
				alReturn.add(objAccCodeDetailC);
				objAccCodeDetailC = null;
			}
			rs.close();
			strSql = null;

		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			System.err.println("errMsg=" + ex);
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
