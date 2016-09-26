package com.aegon.disb.disbcheck;

/**
 * System   :
 * 
 * Function : ���ڶ}��
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.8 $$
 * 
 * Author   : Elsa Huang
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * $$Log: DISBCheckOpenServlet.java,v $
 * $Revision 1.8  2013/12/24 02:17:18  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.7  2013/01/08 04:24:05  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.6.4.1  2012/12/06 06:28:26  MISSALLY
 * $RA0102�@PA0041
 * $�t�X�k�O�ק�S����I�@�~
 * $
 * $Revision 1.6  2011/10/21 10:04:37  MISSALLY
 * $R10260---�~���ǲΫ��O��ͦs�����I�@�~
 * $
 * $Revision 1.5  2011/08/29 06:56:47  MISSALLY
 * $Q10183
 * $���ڶ}�߮ɭY�J��n�����ڧ帹�ɻݤH�u�Ŀ�, �ץ����t�Φ۰ʧ@�~
 * $
 * $Revision 1.4  2011/07/14 11:34:05  MISSALLY
 * $Q10183
 * $���ڶ}�߮ɭY�J��n�����ڧ帹�ɻݤH�u�Ŀ�, �ץ����t�Φ۰ʧ@�~
 * $
 * $Revision 1.3  2010/11/23 06:27:42  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.2  2009/12/03 04:10:42  missteven
 * $R90628 ���ڮw�s�s�W
 * $
 * $Revision 1.1  2006/06/29 09:40:37  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.12  2005/06/01 10:40:33  miselsa
 * $R30530�̳��� ��J�̤ΫO�渹�X�Ƨ�
 * $
 * $Revision 1.1.2.11  2005/04/28 08:56:24  miselsa
 * $R30530������ժ��ק�
 * $
 * $Revision 1.1.2.10  2005/04/04 07:02:22  miselsa
 * $R30530 ��I�t��
 * $$
 *  
 */

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBCheckControlInfoVO;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.DISBCheckDetailVO;

public class DISBCheckOpenServlet extends InitDBServlet {

	private int iChecked = 0;

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String strAction = request.getParameter("txtAction");
		if (strAction != null)
			strAction = CommonUtil.AllTrim(strAction);
		else
			strAction = "";

		try {
			if (strAction.equals("I"))
				inquiryDBProcess(request, response);
			else if (strAction.equals("DISBCheckOpen"))
				checkOpenProcess(request, response);
			else
				System.err.println("Hello, that's not a valid UseCase!");
		} catch (Exception e) {
			System.err.println("Application Exception >>> " + e);
		}
		return;
	}

	/** ���ڶ}�� */
	private synchronized void checkOpenProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		RequestDispatcher dispatcher = null;
		Connection con = dbFactory.getAS400Connection("DISBCheckOpenServlet.checkOpenProcess()");
		String strReturnMsg = "";
		List alEmptyCheckBook = new ArrayList();
		List alCheckInfo = new ArrayList(); //�s�񲼾ک��Ӹ��
		DISBCheckControlInfoVO objCControlVO = null;

		int iUpdDate = Integer.parseInt((String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime = Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));

		/* �����e�����w�q */
		String strOCBNo = "";	//��l���ڧ帹
		String strOCSNo = "";	//��l�䲼�_�l��
		String strOCount = "";	//��l�i�Υ��
		int iOCount = 0;		//��l�i�Υ��

		strOCBNo = request.getParameter("txtOCBNo");
		if (strOCBNo != null)
			strOCBNo = CommonUtil.AllTrim(strOCBNo);
		else
			strOCBNo = "";

		strOCSNo = request.getParameter("txtOCSNo");
		if (strOCSNo != null)
			strOCSNo = CommonUtil.AllTrim(strOCSNo);
		else
			strOCSNo = "";

		strOCount = request.getParameter("txtOCount");
		if (strOCount != null)
			strOCount = CommonUtil.AllTrim(strOCount);
		else
			strOCount = "";
		if (!strOCount.equals(""))
			iOCount = Integer.parseInt(strOCount);

		/*  �P�_�O�_���ťդ䲼�i�ΤΥi�αi�ƤΤ䲼���O�_�۲� */
		alEmptyCheckBook = getEmptyCheckBook(request, response);
		if (alEmptyCheckBook.size() > 0) {
			/*�P�_��Ӫ���ƬO�_�ۦP*/
			strReturnMsg = (String) alEmptyCheckBook.get(0);
			if (strReturnMsg.equals("")) {

				String strNCBNo = "";
				String strNCSNo = "";
				int iNCount = 0;
				for(int i=1; i<alEmptyCheckBook.size(); i++) {
					objCControlVO = (DISBCheckControlInfoVO) alEmptyCheckBook.get(i);

					strNCBNo += "/" + CommonUtil.AllTrim(objCControlVO.getStrCBNo());
					strNCSNo += "/" + CommonUtil.AllTrim(objCControlVO.getStrCSNo());
					iNCount += objCControlVO.getIEmptyCheck();
				}
				strNCBNo = (strNCBNo.length()>0)?strNCBNo.substring(1):"";
				strNCSNo = (strNCSNo.length()>0)?strNCSNo.substring(1):"";

				System.out.println("strOCBNo=" + strOCBNo);
				System.out.println("strNCBNo=" + strNCBNo);
				System.out.println("strOCSNo=" + strOCSNo);
				System.out.println("strNCSNo=" + strNCSNo);
				System.out.println("iOCount=" + iOCount);
				System.out.println("iNCount=" + iNCount);

				if (!(strOCBNo.equals(strNCBNo) && strOCSNo.equals(strNCSNo) && iOCount == iNCount)) {
					strReturnMsg = "�i�Ϊťդ䲼��Ƥ���, �Э��s�d��";
				}
			}
		} else {
			strReturnMsg = "�I�s�d�ߪťդ䲼����";
		}

		try {
			if (strReturnMsg.equals("")) {
				/*�N�䲼���t����I�ץ�*/
				alCheckInfo = maintainPList(request, response, alEmptyCheckBook);
				/*��s��Ʈw*/
				if (alCheckInfo.size() > 0) {
					/*��s���ک����� */
					strReturnMsg = updateCheckInfo(alCheckInfo, iUpdDate, con);
					if (strReturnMsg.equals("")) {
						/*��s��I�D��*/
						strReturnMsg = updatePDetails(alCheckInfo, iUpdDate, iUpdTime, strLogonUser, con);
					}
				} else {
					strReturnMsg = "��Ʀ��~, �Э���";
				}
			}
			if (!strReturnMsg.equals("")) {
				if (isAEGON400) {
					con.rollback();
				}
			}
		} catch (SQLException e) {
			strReturnMsg = "�T�{����-->" + e;
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		//�p�GstrReturnMsg���ť�, �h�N���ڶ}�ߵ{�����\, �ݰ������
		if (!strReturnMsg.equals("")) {
			request.setAttribute("txtMsg", strReturnMsg);
			session.removeAttribute("PDetailListTemp");
			session.removeAttribute("PDetailList");
			session.removeAttribute("CheckControlList");
			request.setAttribute("txtAction", "DISBCheckOpen");
		} else {
			//���沼�ڦC�L
			request.setAttribute("ReportName", "ChequeRpt.rpt");
			request.setAttribute("OutputFileName", "ChequeRpt.rpt");
			request.setAttribute("OutputType", "TXT");

			//��X�n�C�L������
			String strCheckNo = "";
			String strCheckNoS = "";
			String strCheckNoE = "";
			DISBCheckDetailVO tempVO = null;
			for(int i=0; i<alCheckInfo.size(); i++) {
				tempVO = (DISBCheckDetailVO) alCheckInfo.get(i);
				strCheckNo += "'" + tempVO.getStrCNo() + "',";

				if(i == 0)
					strCheckNoS = tempVO.getStrCNo();
				if(i == (alCheckInfo.size()-1))
					strCheckNoE = tempVO.getStrCNo();
			}
			strCheckNo = (strCheckNo.length() > 0)?strCheckNo.substring(0, strCheckNo.length()-1):"";

			System.out.println("�_�� : " + strCheckNoS);
			System.out.println("��� : " + iChecked);
			System.out.println("���� : " + strCheckNoE);

			request.setAttribute("para_Cheque", strCheckNo);
			request.setAttribute("para_rePrtFlag", "N");
			request.setAttribute("txtAction", "CheckReport");
		}

		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckOpen.jsp");
		dispatcher.forward(request, response);
		return;
	}

	/**	�d�� */
	private void inquiryDBProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;

		List alEmptyCheckBook = new ArrayList();
		List alPDetail = new ArrayList();

		String strReturnMsg = "";

		session.removeAttribute("PDetailListTemp");
		session.removeAttribute("PDetailList");
		session.removeAttribute("CheckControlList");

		/*  �����o���ťդ䲼�������䲼��-->�i�αi�� */
		alEmptyCheckBook = getEmptyCheckBook(request, response);
		if (alEmptyCheckBook.size() > 0) {
			strReturnMsg = (String) alEmptyCheckBook.get(0);
			alEmptyCheckBook.remove(0);
		} else {
			strReturnMsg = "�I�s�d�ߪťո�ƥ���";
		}
		if (strReturnMsg.equals("")) {
			/* ���o������L�䲼�}�ߪ���I�D�ɸ�� */
			alPDetail = inquiryPDetails(request, response);
			if (alPDetail.size() > 0) {
				strReturnMsg = (String) alPDetail.get(0);
				alPDetail.remove(0);
			} else {
				strReturnMsg = "�I�s�d�ߤ�I�D�ɥ���";
			}
		}
		if (!strReturnMsg.equals("")) {
			request.setAttribute("txtMsg", strReturnMsg);
		} else {
			session.setAttribute("PDetailListTemp", alPDetail);
			session.setAttribute("PDetailList", alPDetail);
			session.setAttribute("CheckControlList", alEmptyCheckBook);
		}

		request.setAttribute("txtAction", "I");
		dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckOpen.jsp");
		dispatcher.forward(request, response);
		return;
	}

	/**	���o������L�䲼�}�ߪ���I�D�ɸ�� */
	private List inquiryPDetails(HttpServletRequest request, HttpServletResponse response) {
		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;

		String strSql = ""; //SQL String
		String strReturnMsg = "";

		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();

		/* �����e�����w�q */
		String strPStartDate = "";	//��I�T�{����_��
		String strPEndDate = "";	//��I�T�{�������
		String strDispatch = "";	//���_

		strPStartDate = request.getParameter("txtPStartDate");
		if (strPStartDate != null)
			strPStartDate = CommonUtil.AllTrim(strPStartDate);
		else
			strPStartDate = "";

		strPEndDate = request.getParameter("txtPEndDate");
		if (strPEndDate != null)
			strPEndDate = CommonUtil.AllTrim(strPEndDate);
		else
			strPEndDate = "";

		strDispatch = request.getParameter("selDispatch");
		if (strDispatch != null)
			strDispatch = CommonUtil.AllTrim(strDispatch);
		else
			strDispatch = "";

		strSql = "select A.ENTRYDT,A.PAMT,A.PCFMDT1,A.PCFMTM1,A.PCFMDT2,A.PCFMTM2,A.PDATE,A.UPDDT,A.UPDTM,";
		strSql += "A.APPNO,A.POLICYNO,A.ENTRYUSR,A.PAUTHCODE,A.PBACCOUNT,A.PBBANK,A.PCFMUSR1,A.PCFMUSR2,";
		strSql += "A.PCHECKNO,A.PCRDEFFMY,A.PCRDNO,A.PCRDTYPE,A.PDESC,A.PDISPATCH,A.PID,A.PMETHOD,A.PNAME,";
		strSql += "A.PNO,A.PNOH,A.PRACCOUNT,A.PRBANK,A.PSRCGP,A.PSRCCODE,A.PSTATUS,A.PVOIDABLE,A.PDISPATCH,";
		strSql += "A.BRANCH,B.DEPT ";
		strSql += " from CAPPAYF A ";
		strSql += " left outer join USER B  on B.USRID=A.ENTRYUSR "; //���Ƨ� 
		strSql += " WHERE A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>'' ";
		strSql += " AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>''  AND A.PSTATUS=''  AND A.PCHECKNO='' ";
		strSql += " AND A.PVOIDABLE<>'Y'  AND A.PMETHOD='A'  ";

		if (!strPStartDate.equals("") && !strPEndDate.equals("")) {
			strSql += " and A.PCFMDT2  between " + strPStartDate + "  and " + strPEndDate;
		} else if (!strPStartDate.equals("") && strPEndDate.equals("")) {
			strSql += " and A.PCFMDT2 >= " + strPStartDate;
		} else if (strPStartDate.equals("") && !strPEndDate.equals("")) {
			strSql += " and A.PCFMDT2 <= " + strPEndDate;
		}

		if (strDispatch.equals("Y")) {
			strSql += "  and A.PDISPATCH= '" + strDispatch + "' ";
		} else if (strDispatch.equals("N")) {
			strSql += "  and A.PDISPATCH='' ";
		}

		// �̳��� ��J�̤ΫO�渹�X�Ƨ�  RA0102 �W�[��I�Ǹ�
		strSql += " order by B.DEPT,A.ENTRYUSR,A.POLICYNO,A.PNO ";

		System.out.println("DISBCheckOpenServlet.inqueryDB()--> strSql =" + strSql);

		try {
			con = dbFactory.getAS400Connection("DISBCheckOpenServlet.inqueryDB()");
			stmt = con.createStatement();
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setIPAMT(rs.getDouble("PAMT"));	//��I���B
				objPDetailVO.setIPDate(rs.getInt("PDATE"));		//�I�ڤ��
				objPDetailVO.setStrAppNo(rs.getString("APPNO"));//�n�O�Ѹ��X
				objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));	//�O�渹�X
				objPDetailVO.setStrPDesc(rs.getString("PDESC"));//��I�y�z
				objPDetailVO.setStrPDispatch(rs.getString("PDISPATCH"));//���_
				objPDetailVO.setStrPId(rs.getString("PID"));	//���ڤHID
				objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));	//�I�ڤ覡
				objPDetailVO.setStrPName(rs.getString("PNAME"));//���ڤH�m�W
				objPDetailVO.setStrPNO(rs.getString("PNO"));	//��I�Ǹ�
				objPDetailVO.setStrPNoH(rs.getString("PNOH"));	//���I�Ǹ�
				objPDetailVO.setStrPStatus(rs.getString("PSTATUS"));	//�I�ڪ��A
				objPDetailVO.setStrBranch(rs.getString("BRANCH"));		//�O����ݳ��
				objPDetailVO.setStrPVoidable(rs.getString("PVOIDABLE"));//�@�o�_
				alPDetail.add(objPDetailVO);
			}
			rs.close();
			stmt.close();
			if (alPDetail.size() > 0) {
				strReturnMsg = "";
			} else {
				strReturnMsg = "�d�L�������";
			}
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			alPDetail = null;
		} finally {
			dbFactory.releaseAS400Connection(con);
		}
		alPDetail.add(0, strReturnMsg);
		return alPDetail;
	}

	/**	���o�ťդ䲼�� */
	private synchronized List getEmptyCheckBook(HttpServletRequest request, HttpServletResponse response) {

		Connection con = null;
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; //SQL String

		DISBCheckControlInfoVO objCControlVOTemp = null;
		DISBCheckControlInfoVO objCControlVO = null;
		List alReturnInfo = new ArrayList();
		List alCControll = new ArrayList();
		String strReturnMsg = "";

		/* �����e�����w�q */
		String strCBKNo = "";	//�Ȧ��w
		String strCAccount = "";//�Ȧ�b��

		/*���o�e�������*/
		strCBKNo = request.getParameter("txtPBBank");
		if (strCBKNo != null)
			strCBKNo = CommonUtil.AllTrim(strCBKNo);
		else
			strCBKNo = "";
		request.setAttribute("PBBank", strCBKNo);

		strCAccount = request.getParameter("txtPBAccount");
		if (strCAccount != null)
			strCAccount = CommonUtil.AllTrim(strCAccount);
		else
			strCAccount = "";
		request.setAttribute("PBAccount", strCAccount);

		try {
			con = dbFactory.getAS400Connection("DISBCheckStockServlet.inquiryDB()");
			stmt = con.createStatement();

			/*1.���o�ثe�����ťդ䲼���䲼��*/
			strSql = "SELECT DISTINCT A.CBNO,A.CACCOUNT,A.CBKNO,A.CHKSNO,A.CHKENO,A.APPROVSTA ";
			strSql += "FROM CAPCKNOF A ";
			strSql += "LEFT OUTER JOIN CAPCHKF B ON A.CBKNO = B.CBKNO AND A.CACCOUNT=B.CACCOUNT AND A.CBNO = B.CBNO ";
			strSql += "WHERE B.CSTATUS = '' AND B.CHNDFLG<>'Y' AND A.CBKNO='" + strCBKNo + "' ";
			strSql += "AND A.CACCOUNT='" + strCAccount + "'  AND A.APPROVSTA <> 'E' ";
			System.out.println(" inside DISBCheckOpenServlet.inquiryDB() 1--> strSql =" + strSql);
			rs = stmt.executeQuery(strSql);
			while (rs.next()) {
				objCControlVOTemp = new DISBCheckControlInfoVO();
				objCControlVOTemp.setStrCBKNo(rs.getString("CBKNO"));		//�Ȧ��w	
				objCControlVOTemp.setStrCAccount(rs.getString("CACCOUNT"));	//�Ȧ�b��
				objCControlVOTemp.setStrCBNo(rs.getString("CBNO"));		//���ڧ帹
				objCControlVOTemp.setStrCSNo(rs.getString("CHKSNO"));	//���ڰ_��
				objCControlVOTemp.setStrCENo(rs.getString("CHKENO"));	//���ڰW��
				objCControlVOTemp.setStrApprovStat(rs.getString("APPROVSTA"));	//���ڪ��AR90628
				alCControll.add(objCControlVOTemp);
			}
			rs.close();

			if (alCControll.size() > 0) {
				for (int i = 0; i < alCControll.size(); i++) 
				{ //for 1
					objCControlVOTemp = (DISBCheckControlInfoVO) alCControll.get(i);
					if (!"N".equals(objCControlVOTemp.getStrApprovStat())) 
					{
						/*2.�P�_�O�_�����Q�ιL*/
//						int iCSNoTemp = Integer.parseInt(CommonUtil.AllTrim(objCControlVOTemp.getStrCSNo()).substring(2));
//						int iCENoTemp = Integer.parseInt(CommonUtil.AllTrim(objCControlVOTemp.getStrCENo()).substring(2));
//						int iCheckCount = (iCENoTemp - iCSNoTemp) + 1;
						strSql = " select count(CNO) AS CNOCOUNT ";
						strSql += " from  CAPCHKF ";
						strSql += " WHERE  1=1 AND  CBKNO='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBKNo()) + "' ";
						strSql += " AND CACCOUNT='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCAccount()) + "' ";
						strSql += " AND CBNO='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBNo()) + "'  AND CSTATUS='' ";
						System.out.println(" inside DISBCheckOpenServlet.inquiryDB() 2--> strSql =" + strSql);
						rs = stmt.executeQuery(strSql);
						if (rs.next()) 
						{ // if2
//							if (rs.getInt("CNOCOUNT") < iCheckCount) 
//							{ //if 3
								/*3.��X�|���Q�ιL��*/
								strSql = "select a.CNO AS CNO ";
								strSql += "from CAPCHKF a ";
								strSql += "where CBKNO='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBKNo()) + "' ";
								strSql += "AND CACCOUNT='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCAccount()) + "' ";
								strSql += "AND CBNO='" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBNo()) + "'  ";
								strSql += "AND CSTATUS='' ";
								System.out.println(" inside DISBCheckOpenServlet.inquiryDB() 3--> strSql =" + strSql);
								rs.close();
								rs = stmt.executeQuery(strSql);
								objCControlVO = new DISBCheckControlInfoVO();
								List alTemp = new ArrayList();
								Set emptyCheckNo = new TreeSet();
								while (rs.next()) {
									alTemp.add(rs.getString("CNO"));
									emptyCheckNo.add(rs.getString("CNO"));
								}
								rs.close();
								if (alTemp.size() > 0) {
									//�����
									objCControlVO.setIEmptyCheck(alTemp.size());
									objCControlVO.setStrCAccount(objCControlVOTemp.getStrCAccount());
									objCControlVO.setStrCBKNo(objCControlVOTemp.getStrCBKNo());
									objCControlVO.setStrCBNo(objCControlVOTemp.getStrCBNo());
									objCControlVO.setEmptyCheckNo(emptyCheckNo);
									if (alTemp.size() == 1) {
										objCControlVO.setStrCSNo((String) alTemp.get(0));
										objCControlVO.setStrCENo((String) alTemp.get(0));
									} else {
										for (int j = 0; j < alTemp.size(); j++) {
											if (j == 0)
												objCControlVO.setStrCSNo((String) alTemp.get(0));
											else if (j == alTemp.size() - 1)
												objCControlVO.setStrCENo((String) alTemp.get(j));
										}
									}
									alReturnInfo.add(objCControlVO);
//									break;
								} //�����
//							} //if 3
//							else {
								//�ӥ��|�������ιL
//								objCControlVOTemp.setIEmptyCheck(iCheckCount);
//								alReturnInfo.add(objCControlVOTemp);
//								break;
//							} //if 3
						} //if 2
					} else {
						strReturnMsg = "���ڧ帹�G" + CommonUtil.AllTrim(objCControlVOTemp.getStrCBNo()) + "�A���A���֭�ӽФ��C\n�Ч����֭�ӽЧ@�~�A���s����}���@�~!";
					}
					rs.close();
				} //for 1	
			} else {
				strReturnMsg = "�w�s���L�i�Ϊťդ䲼��";
			}
		} catch (SQLException ex) {
			strReturnMsg = "�d�ߥ���:" + ex;
			alCControll = null;
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception ex1) { }
			try { if (stmt != null) stmt.close(); } catch (Exception ex1) { }
			try { if (con != null) dbFactory.releaseAS400Connection(con); } catch (Exception ex1) { }
		}
		alReturnInfo.add(0, strReturnMsg);
		return alReturnInfo;
	}

	/** ���t�䲼 */
	private List maintainPList(HttpServletRequest request, HttpServletResponse response, List emptyCheckBook) {
		List alReturn = new ArrayList();

		HttpSession session = request.getSession(true);
		List alPDetail = (List) session.getAttribute("PDetailListTemp");
		int iSize = (alPDetail != null)?alPDetail.size():0;

		iChecked = 0;

		DISBCheckControlInfoVO objCControlVO = null;
		DISBCheckDetailVO objCDetailVO = null;
		String strIsChecked = "";
		String strCBKNo = "";		//�Ȧ��w
		String strCAccount = "";	//�Ȧ�b��
		String strCBNo = "";		//���ڧ帹
		String strCNo = "";			//�䲼���X

		int preCount = 0;
		boolean isNextNo = false;
		boolean isBreak = false;
		for(int i=1; i<emptyCheckBook.size(); i++) 
		{
			objCControlVO = (DISBCheckControlInfoVO) emptyCheckBook.get(i);

			strCBKNo = objCControlVO.getStrCBKNo();
			if (strCBKNo != null)
				strCBKNo = CommonUtil.AllTrim(strCBKNo);
			else
				strCBKNo = "";

			strCAccount = objCControlVO.getStrCAccount();
			if (strCAccount != null)
				strCAccount = CommonUtil.AllTrim(strCAccount);
			else
				strCAccount = "";

			strCBNo = objCControlVO.getStrCBNo();
			if (strCBNo != null)
				strCBNo = CommonUtil.AllTrim(strCBNo);
			else
				strCBNo = "";

			for(Iterator it=objCControlVO.getEmptyCheckNo().iterator(); it.hasNext(); ) 
			{
				strCNo = CommonUtil.AllTrim((String) it.next());

				for (int j = 0; j < iSize; j++) 
				{
					if(isNextNo) {
						isNextNo = false;
						j = preCount + 1;
					}
					strIsChecked = request.getParameter("ch" + j);
					if (strIsChecked != null && strIsChecked.equalsIgnoreCase("Y")) {
						objCDetailVO = new DISBCheckDetailVO();
						DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO) alPDetail.get(j);
						objCDetailVO.setStrPNO(objPDetailVO.getStrPNO());
						objCDetailVO.setStrCNm(objPDetailVO.getStrPName());
						objCDetailVO.setICAmt(objPDetailVO.getIPAMT());
						objCDetailVO.setIChequeDt(objPDetailVO.getIPDate());
						objCDetailVO.setStrCAccount(strCAccount);
						objCDetailVO.setStrCBKNo(strCBKNo);
						objCDetailVO.setStrCBNo(strCBNo);
						objCDetailVO.setStrCNo(strCNo);
						alReturn.add(objCDetailVO);
						iChecked++;
						isNextNo = true;
					}
					preCount = j;
					if(isNextNo)
						break;

				}  //end request checkbox loop
				if((preCount +1) == iSize) {
					isBreak = true;
					break;
				}

				if(isNextNo)
					continue;

			}  //end empty checkno loop
			if(isBreak)
				break;

		}  //end empty book loop

		return alReturn;
	}

	/**	��s������ */
	private String updateCheckInfo(List alCheckInfo, int iUpdDate, Connection con) throws ServletException, IOException {
		System.out.println("@@@@@inside updateCheckInfo");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; //SQL String
		String strReturnMsg = "";

		try {
			if (alCheckInfo != null) 
			{ //0
				if (alCheckInfo.size() > 0) 
				{ //1
					for (int i = 0; i < alCheckInfo.size(); i++) 
					{ //2
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo.get(i);
						String strPNO = (String) objCDetailVO.getStrPNO();
						if (strPNO != null)
							strPNO = CommonUtil.AllTrim(strPNO);
						else
							strPNO = "";

						strSql = " update CAPCHKF  set CNM='" + CommonUtil.AllTrim(objCDetailVO.getStrCNm()) + "'";
						strSql += ",CAMT=" + objCDetailVO.getICAmt() + " ";
						strSql += ",CHEQUEDT=" + objCDetailVO.getIChequeDt() + " ";
						strSql += ",CUSEDT=" + iUpdDate + " ";
						strSql += ",PNO='" + CommonUtil.AllTrim(objCDetailVO.getStrPNO()) + "' ";
						strSql += ",CSTATUS='D' ";
						strSql += " where CNO ='" + CommonUtil.AllTrim(objCDetailVO.getStrCNo()) + "'  ";
						strSql += " AND CBKNO='" + CommonUtil.AllTrim(objCDetailVO.getStrCBKNo()) + "' ";
						strSql += " AND CACCOUNT='" + CommonUtil.AllTrim(objCDetailVO.getStrCAccount()) + "' ";
						strSql += " AND CBNO='" + CommonUtil.AllTrim(objCDetailVO.getStrCBNo()) + "' ";

						System.out.println(" inside DISBCheckCreateServlet.updateCheckInfo()--> strSql =" + strSql + "_" + CommonUtil.AllTrim(objCDetailVO.getStrCNm()) + "_" + objCDetailVO.getICAmt() + "_" + objCDetailVO.getIChequeDt() + "_" + iUpdDate + "_" + objCDetailVO.getStrPNO() + "_" + objCDetailVO.getStrCNo() + "_" + objCDetailVO.getStrCBKNo() + "_" + objCDetailVO.getStrCAccount() + "_" + objCDetailVO.getStrCBNo());

						pstmtTmp = con.prepareStatement(strSql);
						int iupdate = pstmtTmp.executeUpdate();
						if (iupdate == 1) {
							System.out.println("updateCheckInfo_executeUpdate���\");
						} else {
							strReturnMsg = "��s���ک����ɥ���";
							return strReturnMsg;
						}
						pstmtTmp.close();
					} //2 END OF FOR
				} //1
			} //0
		} catch (SQLException ex) {
			strReturnMsg = "��s���ک����ɥ���:ex=" + ex;
		}
		return strReturnMsg;
	}

	/**	��s��I�� */
	private String updatePDetails(List alCheckInfo, int iUpdDate, int iUpdTime, String strLogonUser, Connection con) throws ServletException, IOException {
		System.out.println("@@@@@inside updatePConfirmed");
		PreparedStatement pstmtTmp = null;

		String strSql = ""; //SQL String
		String strReturnMsg = "";
		DISBBean disbBean = new DISBBean(dbFactory);

		try {
			if (alCheckInfo != null) {
				if (alCheckInfo.size() > 0) {

					for (int i = 0; i < alCheckInfo.size(); i++) {
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo.get(i);

						strSql = " update CAPPAYF set PBBANK = ?, PBACCOUNT = ?, PCHECKNO = ?, PCSHDT = ? ";
						strSql += ",PSTATUS = 'B', UPDDT = ?, UPDTM = ?, UPDUSR = ?  where PNO = ?";

						//�Ulog
						strReturnMsg = disbBean.insertCAPPAYFLOG(CommonUtil.AllTrim(objCDetailVO.getStrPNO()), strLogonUser, iUpdDate, iUpdTime, con);
						if (strReturnMsg.equals("")) {
							pstmtTmp = con.prepareStatement(strSql);
							pstmtTmp.setString(1, CommonUtil.AllTrim(objCDetailVO.getStrCBKNo()));
							pstmtTmp.setString(2, CommonUtil.AllTrim(objCDetailVO.getStrCAccount()));
							pstmtTmp.setString(3, CommonUtil.AllTrim(objCDetailVO.getStrCNo()));
							pstmtTmp.setInt(4, iUpdDate);
							pstmtTmp.setInt(5, iUpdDate);
							pstmtTmp.setInt(6, iUpdTime);
							pstmtTmp.setString(7, strLogonUser);
							pstmtTmp.setString(8,CommonUtil.AllTrim(objCDetailVO.getStrPNO()));

							if (pstmtTmp.executeUpdate() < 1) {
								strReturnMsg = "��s��I�D�ɥ���";
								return strReturnMsg;
							}
							pstmtTmp.close();
						} else {
							return strReturnMsg;
						}
					}
				}
			}
		} catch (SQLException e) {
			strReturnMsg = "��s��I�D�ɥ���: e=" + e;
		}
		return strReturnMsg;
	}

}
