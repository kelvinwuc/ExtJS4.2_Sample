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
 * $EB0194-PB0016-BC255�Q�v�ܰʫ��Y���~���O�I�M��
 * $
 * $Revision 1.15.1.2  2013/08/09 09:21:32  MISSALLY
 * $QB0216 �����O��h�צ����h�פ���O���D
 * $
 * $Revision 1.15.1.1  2013/07/19 08:22:43  MISSALLY
 * $EB0070 - �H������ꫬ�~���ӫ~
 * $
 * $Revision 1.15  2013/05/02 11:07:05  MISSALLY
 * $R10190 �������īO��@�~
 * $
 * $Revision 1.14  2013/02/27 05:35:33  ODCZheJun
 * $R10190 �����ǲΫ��O�楢�ħ@�~
 * $
 * $Revision 1.13  2013/01/08 04:24:03  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.12.4.1  2012/12/06 06:28:27  MISSALLY
 * $RA0102�@PA0041
 * $�t�X�k�O�ק�S����I�@�~
 * $
 * $Revision 1.12  2012/06/22 04:09:57  MISSALLY
 * $QA0215---����h�ק@�~���N�z�߽s���a�J�s��I���
 * $
 * $Revision 1.11  2012/05/23 01:21:44  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�-�ץ��z�ߥI�ڪ��B���P�_
 * $
 * $Revision 1.10  2012/05/18 09:47:37  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�
 * $
 * $Revision 1.9  2011/06/02 10:28:09  MISSALLY
 * $Q90585 / R90884 / R90989
 * $CASH�t�ζװh�B�z�@�~�s�W�װh��]���íץ��h�ש��Ӫ�
 * $
 * $Revision 1.8  2010/11/23 06:50:41  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.7  2008/11/18 02:24:01  MISODIN
 * $R80824
 * $
 * $Revision 1.6  2008/08/06 05:58:09  MISODIN
 * $R80132 �վ�CASH�t��for 6�ع��O
 * $
 * $Revision 1.5  2008/06/06 03:33:39  misvanessa
 * $R80391_�зs�WCASH�t�ΫH�Υd�h�^
 * $
 * $Revision 1.4  2007/10/04 01:39:20  MISODIN
 * $R70477 �~���O��״ڤ���O
 * $
 * $Revision 1.3  2007/01/04 03:16:32  MISVANESSA
 * $R60550_�װh�W�h�ק�
 * $
 * $Revision 1.2  2006/11/30 09:15:52  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.17  2006/04/27 09:25:45  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.16  2005/12/08 02:00:16  misangel
 * $R50727:���I��ƤJ��I�t��(�s�W����:���I��F/���I�z��)
 * $
 * $Revision 1.1.2.15  2005/11/25 06:46:11  misangel
 * $R50727:���I��ƤJ��I�t��
 * $
 * $Revision 1.1.2.14  2005/09/05 07:14:49  misangel
 * $R50736:�װh�B�z�t�H�Υd��
 * $
 * $Revision 1.1.2.13  2005/08/19 06:56:18  misangel
 * $R50427 : �״ڥ�̳���+�m�W+�b���X��
 * $
 * $Revision 1.1.2.12  2005/06/15 04:19:17  MISANGEL
 * $R30530:�װh�P�ɷs�WCAPPAYRF
 * $
 * $Revision 1.1.2.11  2005/04/28 08:56:26  miselsa
 * $R30530������ժ��ק�
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
 * $R30530 ��I�t��
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

		/* �����e�����w�q */
		int iPDate = 0;
		String strPDate = "";	//�I�ڤ��
		String strPBBank = "";	//�I�ڻȦ�
		String strPBAccount = ""; //�I�ڱb��
		String strAMT = "";		//���B
		String strName = "";	//�m�W	
		String strCurrency = "";//���O
		String strRemitway = "";//R60550�װh�覡
		String strPCSHCM = "";	//R80391�X�ǽT�{��
		int iPCSHCM = 0;		//R80391�X�ǽT�{��
		String strBRDate = "" ;//R10134 �Ȧ�h�צ^�s���
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

		//R80391�X�ǽT�{��
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
				objPDetailVO.setStrPNO(rs.getString("PNO"));	//��I�Ǹ�
				if (rs.getString("PNOH").trim().equals("")) {	//�n�O���Ĥ@������I�Ǹ�
					objPDetailVO.setStrPNoH(rs.getString("PNO")); //���I�Ǹ�
				} else {
					objPDetailVO.setStrPNoH(rs.getString("PNOH"));//���I�Ǹ�
				}
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	//��I���B	
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		//�I�ڤ��
				objPDetailVO.setStrPName(rs.getString("PNAME"));//�I�ڤH�m�W
				objPDetailVO.setStrPSName(rs.getString("PSNAME")); //�I�ڤH��l�m�W
				objPDetailVO.setStrPId(rs.getString("PID"));	//�I�ڤHID
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));//���O
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD")); //�I�ڤ覡
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));	 //��I�y�z
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));	 //�ӷ��ոs
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE")); //��I��]�N�X					
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS")); //�I�ڪ��A
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));//�@�o�_
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));//���_
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));//�I�ڻȦ�
				objPDetailVO.setStrPBBank(rs.getString("PBBANK"));		//�I�ڱb��
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));//�״ڱb��
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));		//�״ڻȦ�
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));		//�n�O�Ѹ��X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	//�O�渹�X
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		//�O����ݳ��
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));			//�׶O(����O)
				objPDetailVO.setStrMemo(rs.getString("MEMO"));			//�Ƶ�
				objPDetailVO.setStrEntryPgm(rs.getString("ENTRYPGM"));	//��J�{��
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));		//�I�����O
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));	//��J��
				objPDetailVO.setStrBATSEQ(rs.getString("BATSEQ"));		//�״ڧǸ�
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));	//R60550�ץX���O
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));		//R60550�ץX���B
				objPDetailVO.setIPPAYRATE(rs.getDouble("PPAYRATE"));	//R60550�ץX�ײv
				objPDetailVO.setIPINVDT(rs.getInt("PINVDT"));			//R60550���_�l��
				objPDetailVO.setStrPSYMBOL(rs.getString("PSYMBOL"));	//R60550SPUL���O
				objPDetailVO.setStrPSWIFT(rs.getString("PSWIFT"));		//R60550SWIFT
				objPDetailVO.setStrPBKCOTRY(rs.getString("PBKCOTRY"));	//R60550���ڰ�O
				objPDetailVO.setStrPBKCITY(rs.getString("PBKCITY"));	//R60550���ڻȦ櫰��
				objPDetailVO.setStrPBKBRCH(rs.getString("PBKBRCH"));	//R60550���ڻȦ����
				objPDetailVO.setStrPENGNAME(rs.getString("PENGNAME"));	//R60550�^��m�W
				objPDetailVO.setStrPFEEWAY(rs.getString("PFEEWAY"));	//R60550�I�ڤ覡
				objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO"));		//R80391 �H�Υd��
				objPDetailVO.setIRAMT(rs.getDouble("RAMT"));			//R80391�״ڪ��BCAPRMTF
				objPDetailVO.setStrPMETHODO(rs.getString("PMETHODO"));	//R70600 ��l��I�覡
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));		//R70600 ��I���B�x���Ѧ�
				objPDetailVO.setIPOrgAMT(rs.getDouble("PORGAMT"));		//R80824 �����B
				objPDetailVO.setStrPOrgCrdNo(rs.getString("PORGCRDNO"));//R80824 ��l�d��
				objPDetailVO.setStrProjectCode(rs.getString("PROJECTCD"));//R80824 �M�׽X
				objPDetailVO.setRemitFailDate(rs.getInt("REMITFAILD"));		//R90884 �h�פ��
				objPDetailVO.setRemitFailTime(rs.getInt("REMITFAILT"));		//R90884 �h�׮ɶ�
				objPDetailVO.setRemitFailCode(rs.getString("REMITFCODE"));	//R90884 �h�ץN�X
				objPDetailVO.setRemitFailDesc(rs.getString("REMITFDESC"));	//R90884 �h�׭�]
				objPDetailVO.setClaimNumber(rs.getString("PCLMNUM"));		//�z�߽s��
				objPDetailVO.setServicingBranch(rs.getString("SRVBH"));
				objPDetailVO.setAnnuityPayDate(rs.getInt("ANNPDATE"));

				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "�d�L�������");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
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

		/* �����e�����w�q */
		int iPDate = 0;
		String strPDate = "";	//�I�ڤ��
		String strPBBank = "";	//�I�ڻȦ�
		String strPBAccount = ""; //�I�ڱb��
		String strAMT = "";		//���B
		String strName = "";	//�m�W	
		String strCurrency = "";//���O
		String strRemitway = "";//�װh�覡
		int iRemitFailDate = 0;		//�h�פ��
		String strRemitFailDate = "";	//�h�פ��

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

		//�h�פ�� R10314
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
				objPDetailVO.setStrPNO(rs.getString("PNO"));	//��I�Ǹ�
				if (rs.getString("PNOH").trim().equals("")) {	//�n�O���Ĥ@������I�Ǹ�
					objPDetailVO.setStrPNoH(rs.getString("PNO")); //���I�Ǹ�
				} else {
					objPDetailVO.setStrPNoH(rs.getString("PNOH"));//���I�Ǹ�
				}
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	//��I���B	
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		//�I�ڤ��
				objPDetailVO.setStrPName(rs.getString("PNAME"));//�I�ڤH�m�W
				objPDetailVO.setStrPSName(rs.getString("PSNAME")); //�I�ڤH��l�m�W
				objPDetailVO.setStrPId(rs.getString("PID"));	//�I�ڤHID
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));//���O
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD")); //�I�ڤ覡
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));	 //��I�y�z
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));	 //�ӷ��ոs
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE")); //��I��]�N�X					
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS")); //�I�ڪ��A
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));//�@�o�_
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));//���_
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));//�I�ڻȦ�
				objPDetailVO.setStrPBBank(rs.getString("PBBANK"));		//�I�ڱb��
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));//�״ڱb��
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));		//�״ڻȦ�
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));		//�n�O�Ѹ��X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	//�O�渹�X
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		//�O����ݳ��
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));			//�׶O(����O)
				objPDetailVO.setStrMemo(rs.getString("MEMO"));			//�Ƶ�
				objPDetailVO.setStrEntryPgm(rs.getString("ENTRYPGM"));	//��J�{��
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));		//�I�����O
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));	//��J��
				objPDetailVO.setStrBATSEQ(rs.getString("BATSEQ"));		//�״ڧǸ�
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));	//�ץX���O
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));		//�ץX���B
				objPDetailVO.setIPPAYRATE(rs.getDouble("PPAYRATE"));	//�ץX�ײv
				objPDetailVO.setIPINVDT(rs.getInt("PINVDT"));			//���_�l��
				objPDetailVO.setStrPSYMBOL(rs.getString("PSYMBOL"));	//SPUL���O
				objPDetailVO.setStrPSWIFT(rs.getString("PSWIFT"));		//SWIFT
				objPDetailVO.setStrPBKCOTRY(rs.getString("PBKCOTRY"));	//���ڰ�O
				objPDetailVO.setStrPBKCITY(rs.getString("PBKCITY"));	//���ڻȦ櫰��
				objPDetailVO.setStrPBKBRCH(rs.getString("PBKBRCH"));	//���ڻȦ����
				objPDetailVO.setStrPENGNAME(rs.getString("PENGNAME"));	//�^��m�W
				objPDetailVO.setStrPFEEWAY(rs.getString("PFEEWAY"));	//�I�ڤ覡
				objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO"));		//�H�Υd��
				objPDetailVO.setIRAMT(rs.getDouble("RAMT"));			//�״ڪ��BCAPRMTF
				objPDetailVO.setStrPMETHODO(rs.getString("PMETHODO"));	//��l��I�覡
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));		//��I���B�x���Ѧ�
				objPDetailVO.setIPOrgAMT(rs.getDouble("PORGAMT"));		//�����B
				objPDetailVO.setStrPOrgCrdNo(rs.getString("PORGCRDNO"));//��l�d��
				objPDetailVO.setStrProjectCode(rs.getString("PROJECTCD"));//�M�׽X
				objPDetailVO.setRemitFailDate(rs.getInt("REMITFAILD"));		//R90884 �h�פ��
				objPDetailVO.setRemitFailTime(rs.getInt("REMITFAILT"));		//R90884 �h�׮ɶ�
				objPDetailVO.setRemitFailCode(rs.getString("REMITFCODE"));	//R90884 �h�ץN�X
				objPDetailVO.setRemitFailDesc(rs.getString("REMITFDESC"));	//R90884 �h�׭�]
				objPDetailVO.setClaimNumber(rs.getString("PCLMNUM"));		//�z�߽s��
				objPDetailVO.setServicingBranch(rs.getString("SRVBH"));
				objPDetailVO.setAnnuityPayDate(rs.getInt("ANNPDATE"));

				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				session.setAttribute("PDetailListTemp", alPDetail);
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "��Ƥ��s�b�A�Э��s��J���T��ơC�p�G�O�s�W���h�סA�Цb�y��I�\��w�h�׳B�z�z�s�W�����h�׸�ơC");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
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

		/* �����e�����w�q */
		int iPDate = 0;
		String strPDate = "";	//�I�ڤ��
		String strPBBank = "";	//�I�ڻȦ�
		String strPBAccount = ""; //�I�ڱb��
		String strAMT = "";		//���B
		String strName = "";	//�m�W	
		String strCurrency = "";//���O
		String strRemitway = "";//�װh�覡
		int iRemitFailDate = 0;		//�h�פ��
		String strRemitFailDate = "";	//�h�פ��

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
				objPDetailVO.setStrPNO(rs.getString("PNO"));	//��I�Ǹ�
				if (rs.getString("PNOH").trim().equals("")) {	//�n�O���Ĥ@������I�Ǹ�
					objPDetailVO.setStrPNoH(rs.getString("PNO")); //���I�Ǹ�
				} else {
					objPDetailVO.setStrPNoH(rs.getString("PNOH"));//���I�Ǹ�
				}
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	//��I���B	
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		//�I�ڤ��
				objPDetailVO.setStrPName(rs.getString("PNAME"));//�I�ڤH�m�W
				objPDetailVO.setStrPSName(rs.getString("PSNAME")); //�I�ڤH��l�m�W
				objPDetailVO.setStrPId(rs.getString("PID"));	//�I�ڤHID
				objPDetailVO.setStrPCurr(rs.getString("PCURR"));//���O
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD")); //�I�ڤ覡
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));	 //��I�y�z
				objPDetailVO.setStrPSrcGp(rs.getString("PSRCGP"));	 //�ӷ��ոs
				objPDetailVO.setStrPSrcCode(rs.getString("PSRCCODE")); //��I��]�N�X					
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS")); //�I�ڪ��A
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));//�@�o�_
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));//���_
				objPDetailVO.setStrPBAccount(rs.getString("PBACCOUNT"));//�I�ڻȦ�
				objPDetailVO.setStrPBBank(rs.getString("PBBANK"));		//�I�ڱb��
				objPDetailVO.setStrPRAccount(rs.getString("PRACCOUNT"));//�״ڱb��
				objPDetailVO.setStrPRBank(rs.getString("PRBANK"));		//�״ڻȦ�
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));		//�n�O�Ѹ��X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	//�O�渹�X
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		//�O����ݳ��
				objPDetailVO.setIRmtFee(rs.getInt("RMTFEE"));			//�׶O(����O)
				objPDetailVO.setStrMemo(rs.getString("MEMO"));			//�Ƶ�
				objPDetailVO.setStrEntryPgm(rs.getString("ENTRYPGM"));	//��J�{��
				objPDetailVO.setStrPPlant(rs.getString("PPLANT"));		//�I�����O
				objPDetailVO.setStrEntryUsr(rs.getString("ENTRYUSR"));	//��J��
				objPDetailVO.setStrBATSEQ(rs.getString("BATSEQ"));		//�״ڧǸ�
				objPDetailVO.setStrPPAYCURR(rs.getString("PPAYCURR"));	//�ץX���O
				objPDetailVO.setIPPAYAMT(rs.getDouble("PPAYAMT"));		//�ץX���B
				objPDetailVO.setIPPAYRATE(rs.getDouble("PPAYRATE"));	//�ץX�ײv
				objPDetailVO.setIPINVDT(rs.getInt("PINVDT"));			//���_�l��
				objPDetailVO.setStrPSYMBOL(rs.getString("PSYMBOL"));	//SPUL���O
				objPDetailVO.setStrPSWIFT(rs.getString("PSWIFT"));		//SWIFT
				objPDetailVO.setStrPBKCOTRY(rs.getString("PBKCOTRY"));	//���ڰ�O
				objPDetailVO.setStrPBKCITY(rs.getString("PBKCITY"));	//���ڻȦ櫰��
				objPDetailVO.setStrPBKBRCH(rs.getString("PBKBRCH"));	//���ڻȦ����
				objPDetailVO.setStrPENGNAME(rs.getString("PENGNAME"));	//�^��m�W
				objPDetailVO.setStrPFEEWAY(rs.getString("PFEEWAY"));	//�I�ڤ覡
				objPDetailVO.setStrPCrdNo(rs.getString("PCRDNO"));		//�H�Υd��
				objPDetailVO.setIRAMT(rs.getDouble("RAMT"));			//�״ڪ��BCAPRMTF
				objPDetailVO.setStrPMETHODO(rs.getString("PMETHODO"));	//��l��I�覡
				objPDetailVO.setIPAMTNT(rs.getDouble("PAMTNT"));		//��I���B�x���Ѧ�
				objPDetailVO.setIPOrgAMT(rs.getDouble("PORGAMT"));		//�����B
				objPDetailVO.setStrPOrgCrdNo(rs.getString("PORGCRDNO"));//��l�d��
				objPDetailVO.setStrProjectCode(rs.getString("PROJECTCD"));//�M�׽X
				objPDetailVO.setRemitFailDate(rs.getInt("REMITFAILD"));		//R90884 �h�פ��
				objPDetailVO.setRemitFailTime(rs.getInt("REMITFAILT"));		//R90884 �h�׮ɶ�
				objPDetailVO.setRemitFailCode(rs.getString("REMITFCODE"));	//R90884 �h�ץN�X
				objPDetailVO.setRemitFailDesc(rs.getString("REMITFDESC"));	//R90884 �h�׭�]
				objPDetailVO.setClaimNumber(rs.getString("PCLMNUM"));		//�z�߽s��
				objPDetailVO.setServicingBranch(rs.getString("SRVBH"));
				objPDetailVO.setAnnuityPayDate(rs.getInt("ANNPDATE"));

				alPDetail.add(objPDetailVO);
			}
			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				session.setAttribute("PDetailList", alPDetail);
			} else {
				request.setAttribute("txtMsg", "�d�L�������");
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
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
		String strRemitFailDate = request.getParameter("txtRDate");	//�h�פ��
		if(strRemitFailDate == null)
			strRemitFailDate = "";
		if(!strRemitFailDate.equals(""))
			iRemitFailDate = Integer.parseInt(strRemitFailDate);
		String strRemitFailCode = request.getParameter("selRFCode");	//�h�ץN�X
		if(strRemitFailCode == null)
			strRemitFailCode = "";
		String strRemitFailDesc = request.getParameter("txtRFDesc");	//�h�׭�]
		if(strRemitFailDesc == null)
			strRemitFailDesc = "";
		//R10314
		int iBRemitFailDate = 0;
		String strBRemitFailDate = request.getParameter("txtBRFDate");	//�Ȧ�h�צ^�s���
		if(strBRemitFailDate == null)
			strBRemitFailDate = "";
		if(!strBRemitFailDate.equals(""))
			iBRemitFailDate = Integer.parseInt(strBRemitFailDate);

		try {
			if(strRemitFailCode.equals("") || strRemitFailDesc.equals("")) {
				request.setAttribute("txtMsg", "�h�׳B�z����-->�h�ץN�X/��]���o���ŭ�!!");
			} else if(strRemitFailCode.equals("99") && strRemitFailDesc.equals("")) {
				request.setAttribute("txtMsg", "�h�׳B�z����-->�h�ץN�X99�A�п�J�h�׭�]!!");
			} else {
				if (alCheckList != null) {
					if (alCheckList.size() > 0) {

						String strPNO = "";		//��I�Ǹ�
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
							//�Ulog
							strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
							if (strReturnMsg.equals("")) {
								pstmtTmp = con.prepareStatement(strSql);
								pstmtTmp.setInt(1, iUpdDate);
								pstmtTmp.setInt(2, iUpdTime);
								pstmtTmp.setString(3, strLogonUser);
								pstmtTmp.setString(4, "�״ڥ���--"+strRemitFailDesc);
								pstmtTmp.setInt(5, iRemitFailDate);
								pstmtTmp.setInt(6, iUpdTime);
								pstmtTmp.setString(7, strRemitFailCode);
								pstmtTmp.setString(8, strRemitFailDesc);
								pstmtTmp.setInt(9, iBRemitFailDate);
								pstmtTmp.setString(10, strPNO);
								log.info("strSql:" + strSql + ";UPDDT=" + iUpdDate + ",UPDTM=" + iUpdTime + ",UPDUSR=" + strLogonUser);
								if (pstmtTmp.executeUpdate() != 1) {
									strReturnMsg = "�h�׳B�z����";
									request.setAttribute("txtMsg", "�h�׳B�z����");
								} else {
									/* �N�ª���I��Ʒs�W�@�����I�D�ɤ�, �pstrReturnMsg���ťժ��\*/
									strReturnMsg = createNewPayment(payment, strLogonUser, iUpdDate, iUpdTime, con);
								}
								pstmtTmp.close();
							}
							if (!strReturnMsg.equals("")) //�p�����~�ɫh roll back
							{
								request.setAttribute("txtMsg", strReturnMsg);
								if (isAEGON400) {
									con.rollback();
								}
							} else {
								request.setAttribute("txtMsg", "�h�׳B�z���\");

								//R10190 �N�~�����īO�檺�״ڸ�T�g�J���ĵ��I�q���Ѥu�@��
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
										lapsePayVO.setPNO(rs.getString("FLD0010"));			//��I�Ǹ�
										lapsePayVO.setPolicyNo(rs.getString("FLD0020"));	//�O�渹�X
										lapsePayVO.setReceiverId(rs.getString("FLD0030"));	//���ڤHID
										lapsePayVO.setReceiverName(rs.getString("FLD0040"));//���ڤH�m�W
										lapsePayVO.setPaymentAmt(rs.getDouble("FLD0050"));	//���I���B
										lapsePayVO.setRemitDate(rs.getInt("FLD0060"));		//�X�ǽT�{��
										lapsePayVO.setSendSwitch("N");						//�O�_�H�e
										lapsePayVO.setRemitFailed(isSend?"Y":rs.getString("FLD0080"));//�w�H�e�A���h��
										lapsePayVO.setSendDate(rs.getInt("FLD0090"));		//�H�e���
										lapsePayVO.setUpdatedUser(strLogonUser);			//���ʪ�
										lapsePayVO.setUpdatedDate(iUpdDate);				//���ʤ��

										disbBean.callCAP0314O(con, lapsePayVO);
									}
								}
							}
						}
					}
				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�h�׳B�z����-->" + e);
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

		String strRemitFailCode = request.getParameter("selRFCode");	//�h�ץN�X
		if(strRemitFailCode == null)
			strRemitFailCode = "";
		String strRemitFailDesc = request.getParameter("txtRFDesc");	//�h�׭�]
		if(strRemitFailDesc == null)
			strRemitFailDesc = "";
		//R10314
		int iBRemitFailDate = 0;
		String strBRemitFailDate = request.getParameter("txtBRFDate");	//�Ȧ�h�צ^�s���
		if(strBRemitFailDate == null)
			strBRemitFailDate = "";
		if(!strBRemitFailDate.equals(""))
			iBRemitFailDate = Integer.parseInt(strBRemitFailDate);

		try {
			if(strRemitFailCode.equals("") || strRemitFailDesc.equals("")) {
				request.setAttribute("txtMsg", "�h�׺��@����-->�h�ץN�X/��]���o���ŭ�!!");
			} else if(strRemitFailCode.equals("99") && strRemitFailDesc.equals("")) {
				request.setAttribute("txtMsg", "�h�׺��@����-->�h�ץN�X99�A�п�J�h�׭�]!!");
			} else {
				if (alCheckList != null) {
					if (alCheckList.size() > 0) {

						String strPNO = "";		//��I�Ǹ�
						for (int i = 0; i < alCheckList.size(); i++) {
							strPNO = (String) ((DISBPaymentDetailVO) alCheckList.get(i)).getStrPNO();
							if (strPNO != null)
								strPNO = strPNO.trim();
							else
								strPNO = "";

							strSql = " update CAPPAYF set UPDDT= ?, UPDTM = ?, UPDUSR =?, MEMO =?, REMITFCODE=?, REMITFDESC=?,PBNKRFDT=? where PNO =?";

							con = dbFactory.getAS400Connection("DISBPMaintainServlet.inqueryDB()");
							//�Ulog
							strReturnMsg = disbBean.insertCAPPAYFLOG(strPNO, strLogonUser, iUpdDate, iUpdTime, con);
							if (strReturnMsg.equals("")) {
								pstmtTmp = con.prepareStatement(strSql);
								pstmtTmp.setInt(1, iUpdDate);
								pstmtTmp.setInt(2, iUpdTime);
								pstmtTmp.setString(3, strLogonUser);
								pstmtTmp.setString(4, "�״ڥ���--"+strRemitFailDesc);
								pstmtTmp.setString(5, strRemitFailCode);
								pstmtTmp.setString(6, strRemitFailDesc);
								pstmtTmp.setInt(7, iBRemitFailDate);//R10314
								pstmtTmp.setString(8, strPNO);

								if (pstmtTmp.executeUpdate() != 1) {
									strReturnMsg = "�h�׺��@����";
									request.setAttribute("txtMsg", "�h�׺��@����");
								}
								pstmtTmp.close();
							}
							if (!strReturnMsg.equals("")) //�p�����~�ɫh roll back
							{
								request.setAttribute("txtMsg", strReturnMsg);
								if (isAEGON400) {
									con.rollback();
								}
							} else {
								request.setAttribute("txtMsg", "�h�׺��@���\");
							}
						}
					}
				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "�h�׺��@����-->" + e);
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

		/* ���o�s����I�Ǹ�*/
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
				pstmtTmp.setString(2, objPDetailVO.getStrPNoH().trim()); //�Ĥ@������I�Ǹ�

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
				pstmtTmp.setDouble(37, objPDetailVO.getIPOrgAMT());		//R70600 �����B
				pstmtTmp.setString(38, objPDetailVO.getStrPOrgCrdNo());	//R70600 ���d��
				pstmtTmp.setString(39, objPDetailVO.getStrProjectCode());	//R70600 �M�׽X
				pstmtTmp.setString(40, objPDetailVO.getStrPMETHODO());	//R70600 ��l��I�覡
				pstmtTmp.setDouble(41, objPDetailVO.getIPAMTNT());		//R70600 ��I���B�x���Ѧ�
				pstmtTmp.setString(42, objPDetailVO.getClaimNumber());
				pstmtTmp.setString(43, objPDetailVO.getServicingBranch());
				pstmtTmp.setInt(44, objPDetailVO.getAnnuityPayDate());

				if (pstmtTmp.executeUpdate() != 1) {
					strReturnMsg = "�s�W���I��ƨ��I�D�ɥ���";
					System.out.println("strReturnMsg=UPDATE FAIL");
				}
				pstmtTmp.close();
				htReturnInfo = null;
			}
		} catch (SQLException e) {
			strReturnMsg = "�s�W���I��ƨ��I�D�ɥ���:" + e;
			System.out.println("strReturnMsg=SQL EXCEPTION");
		} catch (Exception ex) {
			strReturnMsg = "�s�W���I��ƨ��I�D�ɥ���:" + ex;
			System.out.println("strReturnMsg=EXCEPTION");
		}
		System.out.println("strReturnMsg=" + strReturnMsg);
		/*R60550�s�W�װh�B�z*/
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
					strReturnMsg = "�s�WCAPRFEF����";
				}
				pstmtTmp.close();
			} catch (SQLException e) {
				strReturnMsg = "�s�WCAPRFEF����:" + e;
			} catch (Exception ex) {
				strReturnMsg = "�s�WCAPRFEF����:" + ex;
			}
		}
		/*�s�W��I�q������CAPPAYRF**�ȭ��ӷ�=CAPSIL��*/
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
					strReturnMsg = "�s�WCAPPAYRF����";
				} else {
					strReturnMsg = "";
				}
			} catch (SQLException e) {
				strReturnMsg = "�s�WCAPPAYRF����" + e;
			}
		}
		return strReturnMsg;
	}
}