package com.aegon.disb.disbreports;

import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.disbremit.CaprmtfVO;
import com.aegon.disb.disbremit.DISBRemitDisposeDAO;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

/**
 * System   : CashWeb
 * 
 * Function : �����q�I�{
 * 
 * Remark   : �X�ǥ\��
 * 
 * Revision : $$Revision: 1.5 $$
 * 
 * Author   : Ariel Wei
 * 
 * Create Date : $$Date: 2015/10/28 02:56:30 $$
 * 
 * Request ID : RC0036
 * 
 * CVS History:
 * 
 * $$Log: DISBDeptCashConfirmServlet.java,v $
 * $Revision 1.5  2015/10/28 02:56:30  001946
 * $*** empty log message ***
 * $
 * $Revision 1.4  2015/10/14 05:53:19  001946
 * $*** empty log message ***
 * $
 * $Revision 1.3  2015/10/06 08:24:42  001946
 * $*** empty log message ***
 * $
 * $Revision 1.2  2014/08/25 02:08:05  missteven
 * $RC0036-3
 * $
 * $Revision 1.1  2014/07/18 07:17:59  misariel
 * $EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 * $
 *  
 */

public class DISBDeptCashConfirmServlet extends InitDBServlet {
	
	Logger log = Logger.getLogger(getClass());

	private static final long serialVersionUID = 6004644124210565207L;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";

	private String path = "";

	public DISBDeptCashConfirmServlet() {
        super();
    }

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);

		if ("I".equals(request.getParameter("txtAction"))) {
			query(request, response);
		} else if ("H".equals(request.getParameter("txtAction"))) {
			update(request, response);
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	private void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String strDateS = request.getParameter("txtStartDate");
		String strDateE = request.getParameter("txtEndDate");

		String strSql = "SELECT a.PNO,a.PMETHOD,a.PDATE,a.PNAME,a.PID,a.PCURR,a.PAMT,a.PSRCCODE,a.POLICYNO,a.APPNO,a.PDISPATCH,a.PVOIDABLE,substring(et.FLD0004,8,6) as PDESC,USR.DEPT as USRDEPT ";
		strSql += "FROM CAPPAYF a ";
		strSql += "JOIN ORDUET et on et.FLD0001='  ' and et.FLD0002='PAYCD' and et.FLD0003=a.PSRCCODE ";
		strSql += "JOIN USER USR on USR.USRID = a.PAY_CONFIRM_USER1 ";
		strSql += "WHERE a.PMETHOD='E' and a.PCFMDT1>0 and a.PCFMUSR1<>'' and a.PCFMDT2>0 and a.PCFMUSR2<>'' ";
		strSql += " and a.PSTATUS='' and a.PVOIDABLE<>'Y' and a.PAMT>0 ";
		strSql += " and a.PCFMDT2 between " + strDateS + " and " + strDateE + " ";
		//strSql += " and USR.USRAREA <> '' "; //2RD046:0151007,Kelvin Wu,RD046:��X�{����I�Τ����q�I�{���d�߱���
		strSql += " and ((USR.USRAREA <> '') OR (a.PDISPATCH='Y'  and a.PCURR='NT'  and USR.DEPT='CSC')) "; //RD046:20151007,Kelvin Wu,RD046:��X�{����I�Τ����q�I�{���d�߱���
		strSql += " ORDER BY USR.DEPT,a.POLICYNO "; //RD046:20151007,Kelvin Wu,RD046:��X�{����I�Τ����q�I�{���d�߱���
		System.out.println("DISBDeptCashConfirmServlet.querySql=" + strSql);

		Connection con = null;
		Statement stmt = null;
		ResultSet rst = null;
		DISBPaymentDetailVO objPDetailVO = null;
		List<DISBPaymentDetailVO> alPDetail = new ArrayList<DISBPaymentDetailVO>();

		try {
			con = dbFactory.getAS400Connection("DISBDeptCashConfirmServlet.query");
			stmt = con.createStatement();
			rst = stmt.executeQuery(strSql);

			while(rst.next()) {
				objPDetailVO = new DISBPaymentDetailVO();
				objPDetailVO.setStrPNO(rst.getString("PNO")); // ��I�Ǹ�
				objPDetailVO.setStrPMethod(rst.getString("PMETHOD"));// �I�ڤ覡
				objPDetailVO.setIPDate(rst.getInt("PDATE")); // �I�ڤ��
				objPDetailVO.setStrPName(rst.getString("PNAME"));// ���ڤH�m�W
				objPDetailVO.setStrPId(rst.getString("PID")); // ���ڤHID
				objPDetailVO.setStrPCurr(rst.getString("PCURR"));
				objPDetailVO.setIPAMT(rst.getDouble("PAMT")); // ��I���B
				objPDetailVO.setStrPSrcCode(rst.getString("PSRCCODE"));// ��I��]�N�X
				objPDetailVO.setStrPolicyNo(rst.getString("POLICYNO"));// �O�渹�X
				objPDetailVO.setStrAppNo(rst.getString("APPNO"));// �n�O�Ѹ��X
				objPDetailVO.setStrPDispatch(rst.getString("PDISPATCH"));// ���_
				objPDetailVO.setStrPVoidable(rst.getString("PVOIDABLE"));// �@�o�_
				objPDetailVO.setStrPDesc(rst.getString("PDESC")); // ��I�y�z
				objPDetailVO.setStrUsrDept(rst.getString("USRDEPT")); // �ӿ���
				//log.info("USRDEPT�O" + rst.getString("USRDEPT"));
				alPDetail.add(objPDetailVO);
			}

			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				request.setAttribute("PDetailListTemp", alPDetail);
				path = "/DISB/DISBReports/DISBDeptCashConfirmList.jsp";
			} else {
				request.setAttribute("txtMsg", "�d�L�������");
				path = "/DISB/DISBReports/DISBDeptCashConfirmInq.jsp";
			}

		} catch (Exception ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
			alPDetail = null;
		} finally {
			try {
				if (rst != null) {
					rst.close();
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
	}

	private void update(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		path = "/DISB/DISBReports/DISBDeptCashConfirmInq.jsp";

		String strDate = request.getParameter("txtPCSHCM");
	    String strBank = request.getParameter("txtPBBank");
		String strAccount = request.getParameter("txtPBAccount");

		String[] strPNO = request.getParameterValues("PNO");
		String strPMETHOD = request.getParameter("PMETHOD").trim();// �I�ڤ覡
		
		String strPCSHCM = request.getParameter("txtPCSHCM");
		int iPCSHCM = 0;
		if (strPCSHCM != null)
			strPCSHCM = strPCSHCM.trim();
		else
			strPCSHCM = "";
		if (!strPCSHCM.equals(""))
			iPCSHCM = Integer.parseInt(strPCSHCM);
		
		String strCNo = request.getParameter("txtCHKNO")!=null?request.getParameter("txtCHKNO"):"";
		String strCBNO = "" ;
		String wsPNO = ""; // ��I�Ǹ�
		
		//step 1:��sCAPPAYF���I�ڪ��APSTATUS='B'
		String strSql = "UPDATE CAPPAYF SET PSTATUS='B',PBBANK=?,PBACCOUNT=?,PCSHDT=?,PCSHCM=?,UPDDT=?,UPDTM=?,UPDUSR=?,PBATNO=?,PCHECKNO=? WHERE PNO=? ";
		System.out.println("DISBDeptCashConfirmServlet.updateSql=" + strSql);
		
		Connection con = null;
		PreparedStatement pstmt = null;

		HttpSession session = request.getSession(true);
		Calendar cldToday = commonUtil.getBizDateByRCalendar();
		SimpleDateFormat sdf = new SimpleDateFormat("HHmmss");
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO = new CaprmtfVO();
		DISBRemitDisposeDAO dao = new DISBRemitDisposeDAO(dbFactory);

		int rowCount = 0;
		double totalAmt = 0;
		double totalFee = 0;
		int ISeqNo = 0;
		String wsBANK = "";  //���ڻȦ�
		String wsBANKTemp = "";//���ڻȦ�,QD0219
		String wsACCOUNT = ""; //���ڱb��
		String wsPNAME = "���y�H�ثO�I�ѥ��������q"; //���ڤH
		String wsENTRYUSR = "";
		String wsRMEMO = "";
		String wsUsrDept = "";
		//TYB
		String wsTYBBANK = "0041724"; 
		String wsTYBACCOUNT = "172001036961"; 
		//TCB
		String wsTCBBANK = "8120078"; 
		String wsTCBACCOUNT = "00701070183000"; 
		//TNB
		String wsTNBBANK = "0061472"; 
		String wsTNBACCOUNT = "1472717018080"; 
		//KHB
		String wsKHBBANK = "0060590"; 
		String wsKHBACCOUNT = "0590717120258"; 
		//CSC,20151007,Kelvin Wu,RD046:��X�{����I�Τ����q�I�{���d�߱���
		String wsCSCBANK = "0071510"; 
		String wsCSCACCOUNT = "15110066986"; 
		
		List ls = null;
		
		double wsAMT = 0;
		
		//�ˮֲ���
		con = dbFactory.getAS400Connection("DISBRemitDisposeServlet.updateB()");
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
			
			int iUpdDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
			int iUpdTime = Integer.parseInt(sdf.format(cldToday.getTime()));
			String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

			//step1:��sCAPPAYF���I�ڪ��APSTATUS='B'
			con = dbFactory.getAS400Connection("DISBDeptCashConfirmServlet.update");
			pstmt = con.prepareStatement(strSql);
			
			String batNo = "";
			String strMsg = "";
			//log.info("strPNO.length�O" + strPNO.length);
			for(int index=0; index<strPNO.length; index++) {
				DISBPaymentDetailVO payment = new DISBPaymentDetailVO();
				payment.setStrPNO(strPNO[index].trim());
				//step2:�qCAPPAYF�BORDUET��USER�d��PNO�����O��
				//log.info("strPNO[index].trim()�O" + strPNO[index].trim());
				dao.query(payment);
				payment.setStrPBBank(strBank);
				payment.setStrPBAccount(strAccount);
				payment.setStrPMethod(strPMETHOD);
				payment.setStrBatNo(batNo);// �״ڧ帹
				payment.setIPCshDt(iUpdDate);// �X�Ǥ��
				payment.setIUpdDt(iUpdDate);// ���ʤ��
				payment.setIUpdTm(iUpdTime);// ���ʮɶ�
				payment.setStrUpdUsr(strLogonUser);// ���ʪ�
				payment.setIPCSHCM(iPCSHCM);/*�X�ǽT�{����� */
				batNo = disbBean.getPBatNo(strPMETHOD, iUpdDate, iUpdTime, strBank);
				
				if (payment.getStrUsrDept().trim().equals("TYB")){
					wsBANK = wsTYBBANK;
					wsACCOUNT = wsTYBACCOUNT;
				}else if(payment.getStrUsrDept().trim().equals("TCB")){
					wsBANK = wsTCBBANK;
					wsACCOUNT = wsTCBACCOUNT;
				}else if(payment.getStrUsrDept().trim().equals("TNB")){
					wsBANK = wsTNBBANK;
					wsACCOUNT = wsTNBACCOUNT;
				}else if(payment.getStrUsrDept().trim().equals("KHB")){
					wsBANK = wsKHBBANK;
					wsACCOUNT = wsKHBACCOUNT;								
				}else if(payment.getStrUsrDept().trim().equals("CSC")){ //20151007,Kelvin Wu,EDxxx:��X�{����I�Τ����q�I�{���d�߱���					
					wsBANK = wsCSCBANK;
					wsACCOUNT = wsCSCACCOUNT;	
					//log.info("CSC:" + wsBANK + "-" + wsACCOUNT);
				}
				//log.info("index�O" + index + ",payment.getStrUsrDept().trim()�O" + payment.getStrUsrDept().trim() + ",wsBANK:" + wsBANK);
				
				/*StringBuffer sbTmp = new StringBuffer();
				sbTmp.append("�״ڧ帹batNo:" + batNo + ",");
				sbTmp.append("�X�Ǥ��iUpdDate:" + iUpdDate + ",");
				sbTmp.append("���ʤ��iUpdDate:" + iUpdDate + ",");
				sbTmp.append("���ʮɶ�iUpdTime:" + iUpdTime + ",");
				sbTmp.append("���ʪ�strLogonUser:" + strLogonUser + ",");
				sbTmp.append("�X�ǽT�{�����iPCSHCM:" + iPCSHCM + ",");
				sbTmp.append("wsBANK�O:" + wsBANK + ",");
				sbTmp.append("wsACCOUNT�O:" + wsACCOUNT + ",");
				log.info(sbTmp.toString());*/
				if (index == 0) {
					ISeqNo += 1;
					wsPNO = payment.getStrPNO() != null ? payment.getStrPNO().trim() : "";
					wsENTRYUSR = payment.getStrEntryUsr() != null ? payment.getStrEntryUsr().trim() : "";
					wsUsrDept = payment.getStrUsrDept() != null ? payment.getStrUsrDept().trim() : "";
					rmtVO = prepareData(payment);
				    rmtVO.setRBK(wsBANK);
					rmtVO.setRACCT(wsACCOUNT);
					rmtVO.setRNAME(wsPNAME);
				}
				//�u�n��@���󦨥ߡA�N�i�J
				if (!wsUsrDept.equals(payment.getStrUsrDept().trim()))
								//|| !wsENTRYUSR.equals(payment.getStrEntryUsr().trim())) 
				{
					//log.info("strPNO[" + index + "]�O" + strPNO[index] + ":wsUsrDept.equals(payment.getStrUsrDept().trim())�O���@�˪�,wsUsrDept�O" + wsUsrDept + ",payment.getStrUsrDept()�O" + payment.getStrUsrDept() + ",wsBANK:" + wsBANK);
					rmtVO.setBATNO(batNo);
					rmtVO.setSEQNO(String.valueOf(ISeqNo));
					rmtVO.setPBK(strBank);
					rmtVO.setPACCT(strAccount);
					rmtVO.setRAMT(wsAMT);
					//step3:�O��׶O
					//log.info("batNo�p��׶O.....disbBean.getPFee(),rmtVO.getRBK():" + rmtVO.getRBK());
					wsBANKTemp = rmtVO.getRBK(); //RD046:��X�{����I�Τ����q�I�{:�ץ��׶O�p����~
					//rmtVO.setRMTFEE((int) disbBean.getPFee(payment.getStrPBBank().trim(), wsBANK, wsAMT, payment.getStrPMethod().trim(), "", ""));
					//RD046:��X�{����I�Τ����q�I�{:�ץ��׶O�p����~
					rmtVO.setRMTFEE((int) disbBean.getPFee(payment.getStrPBBank().trim(), wsBANKTemp, wsAMT, payment.getStrPMethod().trim(), "", ""));
					rmtVO.setENTRYDT(iUpdDate);// ��J���
					rmtVO.setENTRYTM(iUpdTime);// ��J�ɶ�

					if (ls.size() > 0) {
						List rm = removeDuplicate(ls);
						for (int i = 0; i < rm.size(); i++) {
				     			wsRMEMO += (String) rm.get(i);
						}
					}

					rmtVO.setRMEMO(wsRMEMO);
					//step4:�s�WCAPRMTF�O��
					dao.insertRMTF(rmtVO);
					//log.info("�s�WCAPRMTF�O��:"+ rmtVO.getRBK());
					totalFee += rmtVO.getRMTFEE(); 

					rmtVO = new CaprmtfVO();
					rmtVO = prepareData(payment);
				    rmtVO.setRBK(wsBANK);
					rmtVO.setRACCT(wsACCOUNT);
					rmtVO.setRNAME(wsPNAME);
					wsAMT = 0;
					wsRMEMO = "";
					wsAMT += payment.getIPAMT(); 
					ISeqNo += 1;
					wsUsrDept = payment.getStrUsrDept() != null ? payment.getStrUsrDept().trim() : "";
					wsENTRYUSR = payment.getStrEntryUsr() != null ? payment.getStrEntryUsr().trim() : "";
					ls.clear();
                    ls.add((payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
                    
				} else {
					//log.info("strPNO[" + index + "]�O" + strPNO[index] + ":wsUsrDept.equals(payment.getStrUsrDept().trim())�O�ۦP��,wsUsrDept�O" + wsUsrDept + ",payment.getStrUsrDept()�O" + payment.getStrUsrDept() + ",wsBANK:" + wsBANK);
					//�X�֬ۦP���ڱb�������B
					wsAMT += payment.getIPAMT();
					if (ls == null){
						ls = new ArrayList();
					}
					
					ls.add((payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
					//QD0219:�ץ�wsBANK�bFOR�j�餤������dao.insertRMTF(rmtVO)��,���ӱNwsBANK�s��t�~�@���ܼ�wsBANKTemp
					//wsBANKTemp = wsBANK;
			    }

			    
				    disbBean.insertCAPPAYFLOG(strPNO[index],strLogonUser,iUpdDate,iUpdTime,con);
				
				    pstmt.clearParameters();
				    pstmt.setString(1, strBank);
				    pstmt.setString(2, strAccount);
				    pstmt.setInt(3, iUpdDate);
				    pstmt.setInt(4, Integer.parseInt(strDate));
				    pstmt.setInt(5, iUpdDate);
				    pstmt.setInt(6, iUpdTime);
				    pstmt.setString(7, strLogonUser);
				    pstmt.setString(8, batNo);// �帹
				    pstmt.setString(9, strCNo);
                    pstmt.setString(10, strPNO[index]);
				    pstmt.executeUpdate();	
				
					rowCount++;
					totalAmt += payment.getIRmtFee() + payment.getIPAMT();
					strMsg = "��Ƨ�s���\!!";
			} //end for

			rmtVO.setBATNO(batNo);
			rmtVO.setSEQNO(String.valueOf(ISeqNo));
			rmtVO.setPBK(strBank);
			rmtVO.setPACCT(strAccount);
			rmtVO.setRAMT(wsAMT);
			//log.info("batNo�p��׶O.....disbBean.getPFee()");
			wsBANKTemp = rmtVO.getRBK(); //RD046:��X�{����I�Τ����q�I�{:�ץ��׶O�p����~
			rmtVO.setRMTFEE((int) disbBean.getPFee(strBank.substring(0, 7), wsBANKTemp, wsAMT, strPMETHOD, "", ""));// �׶O,QD0219
			rmtVO.setENTRYDT(iUpdDate);// ��J���
			rmtVO.setENTRYTM(iUpdTime);// ��J�ɶ�
			if (ls.size() > 0) {
				List rm = removeDuplicate(ls);
				for (int i = 0; i < rm.size(); i++) {
					wsRMEMO += (String) rm.get(i);
				}
			}
			rmtVO.setRMEMO(wsRMEMO);
			dao.insertRMTF(rmtVO);
			//log.info("�s�WCAPRMTF�O��:"+ rmtVO.getRBK());
			totalFee += rmtVO.getRMTFEE(); 
			
			//RC0036
			if (!"".equals(strCNo)){
				pstmtTmp = con.prepareStatement("update CAPCHKF  set CNM=?,CAMT=?,CHEQUEDT=?,CUSEDT=?,PNO=? ,CSTATUS='D' where CNO =? AND CBKNO=? AND CACCOUNT=? AND CBNO=? ");					
				pstmtTmp.setString(1, wsPNAME);
				pstmtTmp.setDouble(2, totalAmt+totalFee);
				pstmtTmp.setInt(3, iUpdDate);
				pstmtTmp.setInt(4, iUpdDate);
				pstmtTmp.setString(5, wsPNO);
				pstmtTmp.setString(6, strCNo);
				pstmtTmp.setString(7, strBank);
				pstmtTmp.setString(8, strAccount);
				pstmtTmp.setString(9, strCBNO);
				pstmtTmp.executeUpdate();
			}

			request.setAttribute("txtMsg", strMsg);
			request.setAttribute("rowCount", String.valueOf(rowCount));
			request.setAttribute("totalAmt", String.valueOf(totalAmt));
			request.setAttribute("batNo", String.valueOf(batNo));// �帹

		} catch (Exception ex) {
			request.setAttribute("txtMsg", "�d�ߥ���" + ex);
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (con != null) {
					dbFactory.releaseAS400Connection(con);
				}
			} catch (Exception ex1) {
			}
			dao.removeConn();
		}

	}
	//�״�	   
	private CaprmtfVO prepareData(DISBPaymentDetailVO payment) throws Exception {
		
		CaprmtfVO rmtVO = new CaprmtfVO();

		String remitDate = String.valueOf(payment.getIPCSHCM());

		for (int Ecount = remitDate.length(); Ecount < 6; Ecount++) {
			remitDate = "0" + remitDate;
		}
		rmtVO.setRID("");
		rmtVO.setRTYPE("11");
		rmtVO.setMEMO("");
		rmtVO.setRMTDT(remitDate);
		rmtVO.setRTRNCDE("");
		rmtVO.setRTRNTM("");
		rmtVO.setCSTNO("");
		rmtVO.setRMTCDE("");
		rmtVO.setENTRYUSR(payment.getStrEntryUsr());
		return rmtVO;
	}
//�״�	
	private List removeDuplicate(List list) {
		HashSet hs = new HashSet(list);
		list.clear();
		list.addAll(hs);
		return list;
	}

}
