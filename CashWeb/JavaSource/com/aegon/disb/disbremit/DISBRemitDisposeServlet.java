package com.aegon.disb.disbremit;

/**
 * RD0440-�s�W�~�����w�Ȧ�-�x�W�Ȧ�:����O�p��,�Ncall DISBBean.getETable();
 */

/**
 * System   :
 * 
 * Function : �X�ǥ\��-���״�
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
 * $EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 * $
 * $Revision 1.23  2013/05/02 11:07:05  MISSALLY
 * $R10190 �������īO��@�~
 * $
 * $Revision 1.22  2013/02/27 05:35:34  ODCZheJun
 * $R10190 �����ǲΫ��O�楢�ħ@�~
 * $
 * $Revision 1.21  2013/01/08 04:24:03  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.20.4.2  2012/09/06 02:03:07  MISSALLY
 * $QA0281---�ץ��@�Ȥ���O�]����O��I�覡�Y��BEN�ӨS���p��쪺���D
 * $
 * $Revision 1.20.4.1  2012/08/31 01:21:30  MISSALLY
 * $RA0140---�s�W���׬��~�����w��
 * $
 * $Revision 1.20  2011/11/08 09:16:39  MISSALLY
 * $Q10312
 * $�״ڥ\��-���״ڧ@�~
 * $1.�ץ��Ȧ�b�����@�P
 * $2.�վ���׶״���
 * $
 * $Revision 1.19  2011/05/12 06:13:07  MISJIMMY
 * $R00440 SN������
 * $
 * $Revision 1.17  2010/11/23 06:50:42  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.16  2010/05/04 07:12:14  missteven
 * $R90735
 * $
 * $Revision 1.15  2008/08/06 06:53:25  MISODIN
 * $R80338 �վ�CASH�t�� for �X�ǥ~���@��@�ݨD
 * $
 * $Revision 1.14  2007/09/07 10:24:36  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.13  2007/08/03 09:54:43  MISODIN
 * $R70477 �~���O��״ڤ���O
 * $
 * $Revision 1.12  2007/03/16 01:52:57  MISVANESSA
 * $R70088_SPUL�t���ק����Orule
 * $
 * $Revision 1.11  2007/03/08 10:11:33  MISVANESSA
 * $R70088_SPUL�t���ק����O
 * $
 * $Revision 1.10  2007/03/06 01:36:26  MISVANESSA
 * $R70088_SPUL�t���s�W�Ȥ�t�����O
 * $
 * $Revision 1.9  2007/01/31 07:58:10  MISVANESSA
 * $R70088_SPUL�t��
 * $
 * $Revision 1.8  2007/01/09 04:06:01  miselsa
 * $R60550_���״ڪ��B�אּ�p���I4��
 * $
 * $Revision 1.7  2007/01/05 01:46:04  miselsa
 * $R60550_�~���״ڥ�l���S�O�z��O�_��SPUL
 * $
 * $Revision 1.6  2007/01/03 08:32:51  miselsa
 * $R60550_SPUL ���_�l�餧�e �W�[ �Ȥ�ץX�Ȧ����
 * $
 * $Revision 1.5  2006/12/27 09:51:43  miselsa
 * $R60463��R60550_SPUL�O����_�l��e���׶O
 * $
 * $Revision 1.4  2006/12/07 22:00:34  miselsa
 * $R60463��R60550�~����SPUL�O��
 * $
 * $Revision 1.3  2006/11/30 09:16:46  miselsa
 * $R60463��R60550�~����SPUL�O��
 * $
 * $Revision 1.2  2006/09/04 09:43:35  miselsa
 * $R60747_1.���״ڼW�[�X�ǽT�{�� 2.�ץX����״ڤ���אּ�X�ǽT�{�� 3.��I�d�ߥI�ڤ�����X�ǽT�{��
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.8  2006/04/27 09:25:45  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.7  2005/08/19 06:56:18  misangel
 * $R50427 : �״ڥ�̳���+�m�W+�b���X��
 * $
 * $Revision 1.1.2.6  2005/04/08 02:56:54  MISANGEL
 * $R30530:��I�t��
 * $
 * $Revision 1.1.2.5  2005/04/04 07:02:27  miselsa
 * $R30530 ��I�t��
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
		String PRBank = request.getParameter("txtPRBank");// �Ȥ�ץX�Ȧ�
		String PCURR = request.getParameter("selCurrency");// R70477 �O����O
		// String ProjectCode = request.getParameter("selProjectCode");//R80338 // �M�׽X
		String payRule = request.getParameter("txtPayRule"); // R00386 �I�ڳW�h

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
			request.setAttribute("msg", "�d�L���");
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
		String PMETHOD = request.getParameter("PMETHOD").trim();// �I�ڤ覡

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
		String PBANK = request.getParameter("PBBANK").trim();// �I�ڻȦ�,�I�ڱb��
		String PMETHOD = request.getParameter("PMETHOD").trim();// �I�ڤ覡

		/* R60747 �W�[�X�ǽT�{����� Start */
		String PCSHCM = request.getParameter("txtPCSHCM");
		int iPCSHCM = 0;
		if (PCSHCM != null)
			PCSHCM = PCSHCM.trim();
		else
			PCSHCM = "";
		if (!PCSHCM.equals(""))
			iPCSHCM = Integer.parseInt(PCSHCM);
		/* R60747 �W�[�X�ǽT�{����� End */
		
		String strCNo = request.getParameter("txtCHKNO")!=null?request.getParameter("txtCHKNO"):"";

		DbFactory dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
		DISBRemitDisposeDAO dao = new DISBRemitDisposeDAO(dbFactory);
		DISBBean disBBean = new DISBBean(dbFactory);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		int updateDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int updateTime = Integer.parseInt((new SimpleDateFormat("HHmmss")).format(cldToday.getTime()));
		String logonUser = (String) request.getSession().getAttribute(Constant.LOGON_USER_ID);
		String batNo = disBBean.getPBatNo(PMETHOD, updateDate, updateTime, PBANK);
		int count = 0;// �״ڵ���
		double amt = 0;// �״��`���B
		double amtFee = 0;// �׶O�`���B
		String wsPNO = ""; // ��I�Ǹ�
		String wsBANK = ""; // ���ڻȦ�
		String wsACCOUNT = ""; // ���ڱb��
		String wsPNAME = ""; // ���ڤH
		String wsENTRYUSR = "";// ��J��
		//String wsPDESC = "";// ��I�y�z@R90735
		String wsRMEMO = "";// @R90735
		List ls = null;// @R90735
		double wsAMT = 0;
		int ISeqNo = 0;
		String strCBNO = "" ;
		CaprmtfVO rmtVO = new CaprmtfVO();
		
		//�ˮֲ���
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
					request.setAttribute("msg","�䲼���X[" + strCNo + "]���s�b!");
					return;
				}
			}
			
			for (int index = 0; index < PNO.length; index++) {
				DISBPaymentDetailVO payment = new DISBPaymentDetailVO();

				payment.setStrPNO(PNO[index].trim());
				dao.query(payment);// QUERY ��I���B

				payment.setStrPBBank(PBANK.substring(0, 7));
				payment.setStrPBAccount(PBANK.substring(8));
				payment.setStrPMethod(PMETHOD);
				payment.setStrBatNo(batNo);// �״ڧ帹
				payment.setIPCshDt(updateDate);// �X�Ǥ��
				payment.setIUpdDt(updateDate);// ���ʤ��
				payment.setIUpdTm(updateTime);// ���ʮɶ�
				payment.setStrUpdUsr(logonUser);// ���ʪ�
				payment.setIPCSHCM(iPCSHCM);/* R60747 �W�[�X�ǽT�{����� */
				payment.setStrPCheckNO(strCNo);//RC0036

				if (PMETHOD.equals("B")) {// �x���״�
					if (index == 0) {
						// �Ǹ�@R90735
						ISeqNo += 1;
						wsPNO = payment.getStrPNO() != null ? payment.getStrPNO().trim() : "";
						wsBANK = payment.getStrPRBank() != null ? payment.getStrPRBank().trim() : "";
						wsACCOUNT = payment.getStrPRAccount() != null ? payment.getStrPRAccount().trim() : "";
						wsPNAME = payment.getStrPName() != null ? payment.getStrPName().replace('�@', ' ').trim() : "";
						wsENTRYUSR = payment.getStrEntryUsr() != null ? payment.getStrEntryUsr().trim() : "";
						// wsPDESC = payment.getStrPDesc()!=null?payment.getStrPDesc().trim():"";
						rmtVO = prepareData(payment);
					}
					// �ꤺ�״ڥ[�`�W�h -->�P�@�Ȧ�P�@�b�� �P�@���ڤH �P�@��J��
					if (!wsBANK.equals(payment.getStrPRBank().trim())
							|| !wsACCOUNT.equals(payment.getStrPRAccount().trim())
							|| !wsPNAME.equals(payment.getStrPName().replace('�@', ' ').trim())
							|| !wsENTRYUSR.equals(payment.getStrEntryUsr().trim())) 
					{
						rmtVO.setBATNO(batNo);// �״ڧ帹
						rmtVO.setSEQNO(String.valueOf(ISeqNo));// �Ǹ�
						rmtVO.setPBK(PBANK.substring(0, 7));// �I�ڻȦ�
						rmtVO.setPACCT(PBANK.substring(8));// �I�ڱb��
						rmtVO.setRAMT(wsAMT);// ���Bx(13)
						rmtVO.setRMTFEE((int) disBBean.getPFee(payment.getStrPBBank().trim(), wsBANK, wsAMT, payment.getStrPMethod().trim(), "", ""));// �׶O
						rmtVO.setENTRYDT(updateDate);// ��J���
						rmtVO.setENTRYTM(updateTime);// ��J�ɶ�

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
						wsPNAME = payment.getStrPName() != null ? payment.getStrPName().replace('�@', ' ').trim() : "";
						wsENTRYUSR = payment.getStrEntryUsr() != null ? payment.getStrEntryUsr().trim() : "";
						//wsPDESC = payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : "";
						ls.clear();
						if (wsBANK.startsWith("822") && PBANK.startsWith("822"))
							ls.add("�Ѣ�Ѣ�" + (payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
						else
							ls.add((payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
					} else {
						wsAMT += payment.getIPAMT();
						// @R90735
						if (ls == null)
							ls = new ArrayList();

						if (wsBANK.startsWith("822") && PBANK.startsWith("822"))
							ls.add("�Ѣ�Ѣ�" + (payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
						else
							ls.add((payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
					}

				}

				// �g�Jlog��
				disBBean.insertCAPPAYFLOG(payment.getStrPNO(), logonUser, updateDate, updateTime);

				count += dao.update(payment, String.valueOf(ISeqNo));
				amt += payment.getIRmtFee() + payment.getIPAMT();
			}

			rmtVO.setBATNO(batNo);// �״ڧ帹
			rmtVO.setSEQNO(String.valueOf(ISeqNo));
			rmtVO.setPBK(PBANK.substring(0, 7));// �I�ڻȦ�
			rmtVO.setPACCT(PBANK.substring(8));// �I�ڱb��
			rmtVO.setRAMT(wsAMT);// ���Bx(13)
			rmtVO.setRMTFEE((int) disBBean.getPFee(PBANK.substring(0, 7), wsBANK, wsAMT, PMETHOD, "", ""));// �׶O
			rmtVO.setENTRYDT(updateDate);// ��J���
			rmtVO.setENTRYTM(updateTime);// ��J�ɶ�
			// R90735 ����
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
		request.setAttribute("count", String.valueOf(count));// �״ڵ���
		request.setAttribute("amt", String.valueOf(amt));// �״��`���B
		request.setAttribute("batNo", batNo);// �״ڧ帹

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
		String PBANK = request.getParameter("PBBANK").trim();// �I�ڻȦ�,�I�ڱb��
		String PMETHOD = request.getParameter("PMETHOD").trim();// �I�ڤ覡
		DecimalFormat df = new DecimalFormat("###,###,##0.0000");

		/* R60747 �W�[�X�ǽT�{����� Start */
		String PCSHCM = request.getParameter("txtPCSHCM");
		int iPCSHCM = 0;
		if (PCSHCM != null)
			PCSHCM = PCSHCM.trim();
		else
			PCSHCM = "";
		if (!PCSHCM.equals(""))
			iPCSHCM = Integer.parseInt(PCSHCM);
		/* R60747 �W�[�X�ǽT�{����� End */

		DbFactory dbFactory = (DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY);
		DISBRemitDisposeDAO dao = new DISBRemitDisposeDAO(dbFactory);
		DISBBean disBBean = new DISBBean(dbFactory);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		int updateDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int updateTime = Integer.parseInt((new SimpleDateFormat("HHmmss")).format(cldToday.getTime()));

		// R00393
		String logonUser = (String) request.getSession().getAttribute(Constant.LOGON_USER_ID);
		String batNo = disBBean.getPBatNo(PMETHOD, updateDate, updateTime, PBANK);
		int count = 0;// �״ڵ���
		double amt = 0;// �״��`���B
		double RPAYamt = 0;// �~���״��`���B
		String wsSWIFT = ""; // SWIFTCODE
		String wsBANK = "";// �Ȥ�פJ�Ȧ�
		String wsACCOUNT = ""; // ���ڱb��
		String wsPNAME = ""; // ���ڤH
		String wsPID = ""; // ���ڤHID R70088
		String wsPENGNAME = "";// ���ڤH�^��W�r
		String wsENTRYUSR = "";// ��J��
		String wsPAYFEEWAY = "";// �~���[�J����O��I�覡
		String wsPPAYCURR = "";// �~����?
		String wsPBKBRCH = "";// ����
		String wsPBKCITY = "";// ����
		String wsPCOUNTRY = "";// ��O
		double wsRPAYAMT = 0;// �~�����B
		double wsRPAYRATE = 0;// �~���ײvR70088
		double wsRBENFEE = 0;// �Ȥ�t�����OR70088
		String wsPSRCCODE = "";// ��I��]�XR70088
		String wsSWITCH = "";// �P�_�O�_�����_�l��e�ΰt����R70088
		String wsRPCURR = "";// R70477�O����O
		double wsAMT = 0;
		int ISeqNo = 0;
		int wsEntryDt = 0;// ��J��
		int wsPINVDT = 0;// ���_�l��
		String wsPSYMBOL = "";// �O�_��SPUL�O��
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
				dao.query(payment);// QUERY ��I���B
				payment.setStrPBBank(PBANK.substring(0, 7));
				payment.setStrPBAccount(PBANK.substring(8));
				payment.setStrPMethod(PMETHOD);
				payment.setStrBatNo(batNo);// �״ڧ帹
				payment.setIPCshDt(updateDate);// �X�Ǥ��
				payment.setIUpdDt(updateDate);// ���ʤ��
				payment.setIUpdTm(updateTime);// ���ʮɶ�
				payment.setStrUpdUsr(logonUser);// ���ʪ�
				payment.setIPCSHCM(iPCSHCM);/* R60747 �W�[�X�ǽT�{����� */
				payment.setStrPCheckNO("");//RC0036
				currFcTri = (payment.getStrPPlant().equals(" ") && !payment.getStrPCurr().equals("NT")); // R00386 �����ǲΫ��O��

				if (index == 0) {
					ISeqNo += 1;// �Ǹ�

					wsSWIFT = payment.getStrPSWIFT().trim();// SWIFT CODE
					wsBANK = payment.getStrPRBank();
					wsACCOUNT = payment.getStrPRAccount().trim();
					wsPNAME = payment.getStrPName().replace('�@', ' ').trim();
					wsPID = payment.getStrPId().trim();// R70088 SPUL�t��
					wsENTRYUSR = payment.getStrEntryUsr().trim();
					wsPAYFEEWAY = payment.getStrPFEEWAY();// �~���[�J����O��I�覡
					wsPPAYCURR = payment.getStrPPAYCURR(); // �ץX���O
					wsPENGNAME = payment.getStrPENGNAME();// �^��m�W
					wsPBKBRCH = payment.getStrPBKBRCH();// ����
					wsPBKCITY = payment.getStrPBKCITY();// ����
					wsPCOUNTRY = payment.getStrPBKCOTRY();// ��O
					wsAMT = payment.getIPAMT();
					// R70455���|�ˤ��J�A�[�` wsRPAYAMT = payment.getIPPAYAMT();//�~�����B
					wsRPAYAMT = disBBean.DoubleRound(payment.getIPPAYAMT(), 2);// R70455
					wsRPAYRATE = payment.getIPPAYRATE();// �~���ײvR70088
					wsPSRCCODE = payment.getStrPSrcCode().trim();// ��I��]�XR70088
					wsEntryDt = payment.getIEntryDt();
					wsPINVDT = payment.getIPINVDT();
					wsPSYMBOL = payment.getStrPSYMBOL();
					wsRPCURR = payment.getStrPCurr(); // R70477�O����O
					wsFcTri = currFcTri;
					rmtVO = prepareData(payment);
				}
				/*
				 * ��~�״ڥ[�`�W�h -->�P�@SWIFT CODE �P�@�b�� �P�@���ڤH �P�@��J�� �P�@���ڤH�^��m�W �P�@���� �P�@����
				 * �P�@���O
				 */
				if (index > 0) {

					if (!wsSWIFT.equals(payment.getStrPSWIFT().trim())
							|| !wsACCOUNT.equals(payment.getStrPRAccount().trim())
							|| !wsPNAME.replace('�@', ' ').trim().equals(payment.getStrPName().replace('�@', ' ').trim())
							|| !wsENTRYUSR.equals(payment.getStrEntryUsr().trim())
							|| !wsPENGNAME.replace('�@', ' ').trim().equals(payment.getStrPENGNAME().replace('�@', ' ').trim())
							|| !wsPBKBRCH.replace('�@', ' ').trim().equals(payment.getStrPBKBRCH().replace('�@', ' ').trim())
							|| !wsPBKCITY.replace('�@', ' ').trim().equals(payment.getStrPBKCITY().replace('�@', ' ').trim())
							|| !wsPPAYCURR.replace('�@', ' ').trim().equals(payment.getStrPPAYCURR().replace('�@', ' ').trim())
							|| wsFcTri != currFcTri) // R00386 �ǲΫ��P��ꫬ �Ϊ�����O���P, ���}��
					{
						wsFcTri = currFcTri;

						rmtVO.setBATNO(batNo);// �״ڧ帹
						rmtVO.setSEQNO(String.valueOf(ISeqNo));// �Ǹ�
						rmtVO.setPBK(PBANK.substring(0, 7));// �I�ڻȦ�
						rmtVO.setPACCT(PBANK.substring(8));// �I�ڱb��
						rmtVO.setRID(wsPID);// ���ڤHID
						rmtVO.setRAMT(wsAMT);// ���Bx(13)
						rmtVO.setRPCURR(wsRPCURR);// R70477 �O����O
						// �׶O(���q�t��)SPUL�O����_�l�餧�e����I��M�Ȥ�t��׶O��0 ,BEN:���H�ۤv�|�q��I���B����
						// R70088�אּBEN->�N�O�ѫȤ�t��,�׶O���s
						// OUR->���q�t��,�Y�����H�BSWIFTCODE=CTCBTW���Y�̩ΰt���׶O���s,��l���H��׶O��500
						// �@��100;��X10us
						// R70455 if(wsPSYMBOL.equals("S") &&
						// (wsEntryDt<=wsPINVDT || wsPSRCCODE.equals("B8"))){
						// R00440 SN������ if(wsPSYMBOL.equals("S") &&
						// (wsEntryDt<=wsPINVDT || wsPSRCCODE.equals("B8") ||
						// wsPSRCCODE.equals("B9"))){
						if (wsPSYMBOL.equals("S")
								&& (wsEntryDt <= wsPINVDT
										|| wsPSRCCODE.equals("BB")
										|| wsPSRCCODE.equals("B8") 
										|| wsPSRCCODE.equals("B9"))) 
						{// R00440 SN������
							wsSWITCH = "Y";
						} else {
							wsSWITCH = "";
						}
						if (wsPAYFEEWAY.equals("OUR") || wsPAYFEEWAY.equals("SHA")) {
							try {
								//RD0440:�s�W�~�����w�Ȧ�-�x�W�Ȧ�
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
						rmtVO.setENTRYDT(updateDate);// ��J���
						rmtVO.setENTRYTM(updateTime);// ��J�ɶ�
						// �Ȥ�t��׶OR70088
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

						//QA0281 �I�ڻȦ欰�@�Ȯɦ�����O����
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

						rmtVO.setRPAYFEEWAY(wsPAYFEEWAY);// ����O�I�ڤ覡
						rmtVO.setRPAYAMT(wsRPAYAMT);// �~�����B�[�`
						rmtVO.setRPAYCURR(wsPPAYCURR);// �~�����O
						rmtVO.setSWIFTCODE(wsSWIFT); // SWIFT CODE
						rmtVO.setPENGNAME(wsPENGNAME);// �^��m�W
						rmtVO.setRBKBRCH(wsPBKBRCH); // ����
						rmtVO.setRBKCITY(wsPBKCITY);// ����
						rmtVO.setRBKCOUNTRY(wsPCOUNTRY);// ��O
						// System.out.println("0wsRPAYAMT="+wsRPAYAMT);
						/* �e���ۦP���[�`��� */
						dao.insertRMTF(rmtVO);

						rmtVO = new CaprmtfVO();
						rmtVO = prepareData(payment);
						wsAMT = 0;
						wsAMT += payment.getIPAMT();
						// System.out.println("1wsRPAYAMT="+wsRPAYAMT);
						// System.out.println("1payment.getIPPAYAMT()="+payment.getIPPAYAMT());
						wsRPAYAMT = 0;// R70088
						// R70455���|�ˤ��J�A�[�` wsRPAYAMT += payment.getIPPAYAMT();//�~�����B
						wsTEMPamt = disBBean.DoubleRound(payment.getIPPAYAMT(), 2);
						wsRPAYAMT = disBBean.DoubleAdd(wsRPAYAMT, wsTEMPamt);// R70455  �~�����B
						// System.out.println("2wsRPAYAMT="+wsRPAYAMT);
						// �Ǹ�
						ISeqNo += 1;

						wsSWIFT = payment.getStrPSWIFT().trim();// SWIFT CODE
						wsBANK = payment.getStrPRBank();
						wsACCOUNT = payment.getStrPRAccount().trim();
						wsPNAME = payment.getStrPName().replace('�@', ' ').trim();
						wsPID = payment.getStrPId().trim();// R70088
						wsENTRYUSR = payment.getStrEntryUsr().trim();
						wsPAYFEEWAY = payment.getStrPFEEWAY();// �~���[�J����O��I�覡
						wsPPAYCURR = payment.getStrPPAYCURR(); // �ץX���O
						wsPENGNAME = payment.getStrPENGNAME();// �^��m�W
						wsPBKBRCH = payment.getStrPBKBRCH();// ����
						wsPBKCITY = payment.getStrPBKCITY(); // ����
						wsPCOUNTRY = payment.getStrPBKCOTRY();// ��O
						wsRPAYRATE = payment.getIPPAYRATE();// �~���ײvR70088
						wsPSRCCODE = payment.getStrPSrcCode().trim();// ��I��]�XR70088
						wsEntryDt = payment.getIEntryDt();// ��J���R70088
						wsRPCURR = payment.getStrPCurr(); // R70477�O����O
					} else {
						wsAMT += payment.getIPAMT();
						// System.out.println("3wsRPAYAMT="+wsRPAYAMT);
						// System.out.println("3payment.getIPPAYAMT()="+payment.getIPPAYAMT());
						// R70455���|�ˤ��J�A�[�` wsRPAYAMT += payment.getIPPAYAMT();
						wsTEMPamt = disBBean.DoubleRound(payment.getIPPAYAMT(), 2);
						wsRPAYAMT = disBBean.DoubleAdd(wsRPAYAMT, wsTEMPamt);// R70455 �~�����B
						// System.out.println("4wsRPAYAMT="+wsRPAYAMT);
						/*
						 * 0:OUR, 1:SHA, 2:BEN �p����O���O�覡���P�ɪ��M�w�W�h , OUR --> SHA
						 * -->BEN
						 */
						if (getPayFeeWaySeq(wsPAYFEEWAY) < getPayFeeWaySeq(payment.getStrPFEEWAY())) {
							wsPAYFEEWAY = payment.getStrPFEEWAY();
						}
						wsFcTri = currFcTri;
					}
				}

				// �g�Jlog��
				disBBean.insertCAPPAYFLOG(payment.getStrPNO(), logonUser, updateDate, updateTime);

				count += dao.update(payment, String.valueOf(ISeqNo));
				amt += payment.getIRmtFee() + payment.getIPAMT();
				// R70455 RPAYamt += payment.getIPPAYAMT();
				wsTEMPamt = disBBean.DoubleRound(payment.getIPPAYAMT(), 2);
				RPAYamt = disBBean.DoubleAdd(RPAYamt, wsTEMPamt);// R70455 �~�����B

				//R10190 �N�~�����īO�檺�״ڸ�T�g�J���ĵ��I�q���Ѥu�@�� 
				if(payment.getStrPMethod() != null && payment.getStrPMethod().equals("D") && payment.getStrPSrcCode() != null && payment.getStrPSrcCode().equals("CE")) {
					lapsePayVO = new LapsePaymentVO();
					lapsePayVO.setPNO(payment.getStrPNO());				//��I�Ǹ�
					lapsePayVO.setPolicyNo(payment.getStrPolicyNo());	//�O�渹�X
					lapsePayVO.setReceiverId(payment.getStrPId());		//���ڤHID
					lapsePayVO.setReceiverName(payment.getStrPName());	//���ڤH�m�W
					lapsePayVO.setPaymentAmt(payment.getIPAMT());		//���I���B
					lapsePayVO.setRemitDate(iPCSHCM);					//�X�ǽT�{��
					lapsePayVO.setSendSwitch("Y");						//�O�_�H�e
					lapsePayVO.setRemitFailed("N" );					//�w�H�e�A���h��
					lapsePayVO.setSendDate(0);							//�H�e���
					lapsePayVO.setUpdatedUser(logonUser);				//���ʪ�
					lapsePayVO.setUpdatedDate(updateDate);				//���ʤ��

					listlapsePay.add(lapsePayVO);
				}

			}//end for

			rmtVO.setBATNO(batNo);// �״ڧ帹
			rmtVO.setSEQNO(String.valueOf(ISeqNo));
			rmtVO.setPBK(PBANK.substring(0, 7));// �I�ڻȦ�
			rmtVO.setPACCT(PBANK.substring(8));// �I�ڱb��
			rmtVO.setRID(wsPID);// ���ڤHID
			rmtVO.setRAMT(wsAMT);// ���Bx(13)
			rmtVO.setRPCURR(wsRPCURR);// R70477 �O����O
			// �׶O SPUL�O����_�l�餧�e����I�� �׶O��0
			// R70088�אּBEN->�N�O�ѫȤ�t��,�׶O���s
			// OUR->���q�t��,�Y�����H�BSWIFTCODE=CTCBTW���Y�̶׶O���s,��l���H��׶O��500
			// �@��100;��X10us
			// R70455 if(wsPSYMBOL.equals("S") && (wsEntryDt<=wsPINVDT ||
			// wsPSRCCODE.equals("B8"))){
			// R00440 SN������ if(wsPSYMBOL.equals("S") && (wsEntryDt<=wsPINVDT ||
			// wsPSRCCODE.equals("B8") || wsPSRCCODE.equals("B9")) ){
			if (wsPSYMBOL.equals("S")
					&& (wsEntryDt <= wsPINVDT 
							|| wsPSRCCODE.equals("BB")
							|| wsPSRCCODE.equals("B8") 
							|| wsPSRCCODE.equals("B9"))) 
			{// R00440 SN������
				wsSWITCH = "Y";
			} else {
				wsSWITCH = "";
			}
			// R70477�~���O��, �P�����, �״ڤ���O��覡�ܧ�OUR
			if (wsPSYMBOL.equals("D") && wsBANK.substring(0, 3).equals(PBANK.substring(0, 3))) {
				wsPAYFEEWAY = "OUR";
			}
			if (wsPAYFEEWAY.equals("OUR") || wsPAYFEEWAY.equals("SHA")) {
				try {
					//RD0440:�s�W�~�����w�Ȧ�-�x�W�Ȧ�
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
			
			rmtVO.setENTRYDT(updateDate);// ��J���
			rmtVO.setENTRYTM(updateTime);// ��J�ɶ�
			// �Ȥ�t��׶OR70088
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

			//QA0281 �I�ڻȦ欰�@�Ȯɦ�����O����
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
			rmtVO.setRPAYFEEWAY(wsPAYFEEWAY);// ����O�I�ڤ覡
			rmtVO.setRPAYAMT(wsRPAYAMT);// �~�����B�[�`
			rmtVO.setRPAYCURR(wsPPAYCURR);// �~�����O
			rmtVO.setSWIFTCODE(wsSWIFT); // SWIFT CODE
			rmtVO.setPENGNAME(wsPENGNAME);// �^��m�W
			rmtVO.setRBKBRCH(wsPBKBRCH); // ����
			rmtVO.setRBKCITY(wsPBKCITY);// ����
			rmtVO.setRBKCOUNTRY(wsPCOUNTRY);// ��O

			/* �̫�@�����J�`��� */
			dao.insertRMTF(rmtVO);

			//R10190 �N�~�����īO�檺�״ڸ�T�g�J���ĵ��I�q���Ѥu�@��
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

		request.setAttribute("count", String.valueOf(count));	// �״ڵ���
		request.setAttribute("amt", String.valueOf(amt));		// �״��`���B
		request.setAttribute("RPAYAMT", df.format(RPAYamt));	// �~���״��`���B
		request.setAttribute("batNo", batNo);	// �״ڧ帹
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
		rmtVO.setRID("");// ���ڤHID
		rmtVO.setRTYPE(payment.getStrPRBank() != null && payment.getStrPRBank().startsWith("822") ? "01" : "11");// �״ں���
		// ?�ڦ� �״ڦ�,x(3)@todo
		String entBank = "";
		if (payment.getStrPRBank() != null && payment.getStrPRBank().length() >= 7) {
			entBank = payment.getStrPRBank().substring(0, 7);
		}
		for (int Ecount = entBank.length(); Ecount < 7; Ecount++) {
			entBank = "0" + entBank;
		}
		rmtVO.setRBK(entBank);
		// ���ڤH�b��x(14)
		if (payment.getStrPRAccount() == null) {
			rmtVO.setRACCT("");
		} else if (payment.getStrPRAccount().length() > 14) {
			rmtVO.setRACCT(payment.getStrPRAccount().substring(0, 14));
		} else {
			rmtVO.setRACCT(payment.getStrPRAccount());
		}

		// rmtVO.setRACCT(payment.getStrPRAccount()==null?"":payment.getStrPRAccount());

		// ���ڤH��Wx(80) �]����W������ �ҥHentName.length()*2 @R90735
		String entName = payment.getStrPName() == null ? "" : payment.getStrPName().replace('�@', ' ').trim();
		for (int Ecount = entName.getBytes().length; Ecount < 80; Ecount++) {
			entName = entName + " ";
		}
		rmtVO.setRNAME(entName);
		rmtVO.setMEMO("");// ����
		// �״ڤ��x(6)
		/* R60747 �״ڤ���ѥX�Ǥ��PCshDt�אּ�X�ǽT�{��PCSHCM Start */
		// String remitDate = String.valueOf(payment.getIPCshDt());
		String remitDate = String.valueOf(payment.getIPCSHCM());
		/* R60747 �״ڤ���ѥX�Ǥ��PCshDt�אּ�X�ǽT�{��PCSHCM End */

		for (int Ecount = remitDate.length(); Ecount < 6; Ecount++) {
			remitDate = "0" + remitDate;
		}
		rmtVO.setRMTDT(remitDate);

		rmtVO.setRTRNCDE("");// ����ˮְ�x(4)
		rmtVO.setRTRNTM("");// �ǰe����x(3)
		rmtVO.setCSTNO("");// �Ȥ�ǲ����Xx(10)
		rmtVO.setRMTCDE("");// �׶O�t��ϧO��x(1)
		rmtVO.setENTRYUSR(payment.getStrEntryUsr());// ��J��
		return rmtVO;
	}

	// Clean up resources
	public void destroy() {
	}

}