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
 * Function : 分公司付現
 * 
 * Remark   : 出納功能
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
 * $EC0342-RC0036新增分公司行政人員使用CAPSIL
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
		//strSql += " and USR.USRAREA <> '' "; //2RD046:0151007,Kelvin Wu,RD046:整合現金支付及分公司付現的查詢條件
		strSql += " and ((USR.USRAREA <> '') OR (a.PDISPATCH='Y'  and a.PCURR='NT'  and USR.DEPT='CSC')) "; //RD046:20151007,Kelvin Wu,RD046:整合現金支付及分公司付現的查詢條件
		strSql += " ORDER BY USR.DEPT,a.POLICYNO "; //RD046:20151007,Kelvin Wu,RD046:整合現金支付及分公司付現的查詢條件
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
				objPDetailVO.setStrPNO(rst.getString("PNO")); // 支付序號
				objPDetailVO.setStrPMethod(rst.getString("PMETHOD"));// 付款方式
				objPDetailVO.setIPDate(rst.getInt("PDATE")); // 付款日期
				objPDetailVO.setStrPName(rst.getString("PNAME"));// 受款人姓名
				objPDetailVO.setStrPId(rst.getString("PID")); // 受款人ID
				objPDetailVO.setStrPCurr(rst.getString("PCURR"));
				objPDetailVO.setIPAMT(rst.getDouble("PAMT")); // 支付金額
				objPDetailVO.setStrPSrcCode(rst.getString("PSRCCODE"));// 支付原因代碼
				objPDetailVO.setStrPolicyNo(rst.getString("POLICYNO"));// 保單號碼
				objPDetailVO.setStrAppNo(rst.getString("APPNO"));// 要保書號碼
				objPDetailVO.setStrPDispatch(rst.getString("PDISPATCH"));// 急件否
				objPDetailVO.setStrPVoidable(rst.getString("PVOIDABLE"));// 作廢否
				objPDetailVO.setStrPDesc(rst.getString("PDESC")); // 支付描述
				objPDetailVO.setStrUsrDept(rst.getString("USRDEPT")); // 承辦單位
				//log.info("USRDEPT是" + rst.getString("USRDEPT"));
				alPDetail.add(objPDetailVO);
			}

			if (alPDetail.size() > 0) {
				request.setAttribute("txtMsg", "");
				request.setAttribute("PDetailListTemp", alPDetail);
				path = "/DISB/DISBReports/DISBDeptCashConfirmList.jsp";
			} else {
				request.setAttribute("txtMsg", "查無相關資料");
				path = "/DISB/DISBReports/DISBDeptCashConfirmInq.jsp";
			}

		} catch (Exception ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
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
		String strPMETHOD = request.getParameter("PMETHOD").trim();// 付款方式
		
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
		String wsPNO = ""; // 支付序號
		
		//step 1:更新CAPPAYF的付款狀態PSTATUS='B'
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
		String wsBANK = "";  //收款銀行
		String wsBANKTemp = "";//收款銀行,QD0219
		String wsACCOUNT = ""; //收款帳號
		String wsPNAME = "全球人壽保險股份有限公司"; //收款人
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
		//CSC,20151007,Kelvin Wu,RD046:整合現金支付及分公司付現的查詢條件
		String wsCSCBANK = "0071510"; 
		String wsCSCACCOUNT = "15110066986"; 
		
		List ls = null;
		
		double wsAMT = 0;
		
		//檢核票號
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
					request.setAttribute("msg","支票號碼[" + strCNo + "]不存在!");
					return;
				}
			}
			
			int iUpdDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
			int iUpdTime = Integer.parseInt(sdf.format(cldToday.getTime()));
			String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

			//step1:更新CAPPAYF的付款狀態PSTATUS='B'
			con = dbFactory.getAS400Connection("DISBDeptCashConfirmServlet.update");
			pstmt = con.prepareStatement(strSql);
			
			String batNo = "";
			String strMsg = "";
			//log.info("strPNO.length是" + strPNO.length);
			for(int index=0; index<strPNO.length; index++) {
				DISBPaymentDetailVO payment = new DISBPaymentDetailVO();
				payment.setStrPNO(strPNO[index].trim());
				//step2:從CAPPAYF、ORDUET及USER查詢PNO有關記錄
				//log.info("strPNO[index].trim()是" + strPNO[index].trim());
				dao.query(payment);
				payment.setStrPBBank(strBank);
				payment.setStrPBAccount(strAccount);
				payment.setStrPMethod(strPMETHOD);
				payment.setStrBatNo(batNo);// 匯款批號
				payment.setIPCshDt(iUpdDate);// 出納日期
				payment.setIUpdDt(iUpdDate);// 異動日期
				payment.setIUpdTm(iUpdTime);// 異動時間
				payment.setStrUpdUsr(strLogonUser);// 異動者
				payment.setIPCSHCM(iPCSHCM);/*出納確認日欄位 */
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
				}else if(payment.getStrUsrDept().trim().equals("CSC")){ //20151007,Kelvin Wu,EDxxx:整合現金支付及分公司付現的查詢條件					
					wsBANK = wsCSCBANK;
					wsACCOUNT = wsCSCACCOUNT;	
					//log.info("CSC:" + wsBANK + "-" + wsACCOUNT);
				}
				//log.info("index是" + index + ",payment.getStrUsrDept().trim()是" + payment.getStrUsrDept().trim() + ",wsBANK:" + wsBANK);
				
				/*StringBuffer sbTmp = new StringBuffer();
				sbTmp.append("匯款批號batNo:" + batNo + ",");
				sbTmp.append("出納日期iUpdDate:" + iUpdDate + ",");
				sbTmp.append("異動日期iUpdDate:" + iUpdDate + ",");
				sbTmp.append("異動時間iUpdTime:" + iUpdTime + ",");
				sbTmp.append("異動者strLogonUser:" + strLogonUser + ",");
				sbTmp.append("出納確認日欄位iPCSHCM:" + iPCSHCM + ",");
				sbTmp.append("wsBANK是:" + wsBANK + ",");
				sbTmp.append("wsACCOUNT是:" + wsACCOUNT + ",");
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
				//只要其一條件成立，就進入
				if (!wsUsrDept.equals(payment.getStrUsrDept().trim()))
								//|| !wsENTRYUSR.equals(payment.getStrEntryUsr().trim())) 
				{
					//log.info("strPNO[" + index + "]是" + strPNO[index] + ":wsUsrDept.equals(payment.getStrUsrDept().trim())是不一樣的,wsUsrDept是" + wsUsrDept + ",payment.getStrUsrDept()是" + payment.getStrUsrDept() + ",wsBANK:" + wsBANK);
					rmtVO.setBATNO(batNo);
					rmtVO.setSEQNO(String.valueOf(ISeqNo));
					rmtVO.setPBK(strBank);
					rmtVO.setPACCT(strAccount);
					rmtVO.setRAMT(wsAMT);
					//step3:記算匯費
					//log.info("batNo計算匯費.....disbBean.getPFee(),rmtVO.getRBK():" + rmtVO.getRBK());
					wsBANKTemp = rmtVO.getRBK(); //RD046:整合現金支付及分公司付現:修正匯費計算錯誤
					//rmtVO.setRMTFEE((int) disbBean.getPFee(payment.getStrPBBank().trim(), wsBANK, wsAMT, payment.getStrPMethod().trim(), "", ""));
					//RD046:整合現金支付及分公司付現:修正匯費計算錯誤
					rmtVO.setRMTFEE((int) disbBean.getPFee(payment.getStrPBBank().trim(), wsBANKTemp, wsAMT, payment.getStrPMethod().trim(), "", ""));
					rmtVO.setENTRYDT(iUpdDate);// 輸入日期
					rmtVO.setENTRYTM(iUpdTime);// 輸入時間

					if (ls.size() > 0) {
						List rm = removeDuplicate(ls);
						for (int i = 0; i < rm.size(); i++) {
				     			wsRMEMO += (String) rm.get(i);
						}
					}

					rmtVO.setRMEMO(wsRMEMO);
					//step4:新增CAPRMTF記錄
					dao.insertRMTF(rmtVO);
					//log.info("新增CAPRMTF記錄:"+ rmtVO.getRBK());
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
					//log.info("strPNO[" + index + "]是" + strPNO[index] + ":wsUsrDept.equals(payment.getStrUsrDept().trim())是相同的,wsUsrDept是" + wsUsrDept + ",payment.getStrUsrDept()是" + payment.getStrUsrDept() + ",wsBANK:" + wsBANK);
					//合併相同受款帳號的金額
					wsAMT += payment.getIPAMT();
					if (ls == null){
						ls = new ArrayList();
					}
					
					ls.add((payment.getStrPDesc() != null ? payment.getStrPDesc().trim() : ""));
					//QD0219:修正wsBANK在FOR迴圈中未執行dao.insertRMTF(rmtVO)時,應該將wsBANK存於另外一個變數wsBANKTemp
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
				    pstmt.setString(8, batNo);// 批號
				    pstmt.setString(9, strCNo);
                    pstmt.setString(10, strPNO[index]);
				    pstmt.executeUpdate();	
				
					rowCount++;
					totalAmt += payment.getIRmtFee() + payment.getIPAMT();
					strMsg = "資料更新成功!!";
			} //end for

			rmtVO.setBATNO(batNo);
			rmtVO.setSEQNO(String.valueOf(ISeqNo));
			rmtVO.setPBK(strBank);
			rmtVO.setPACCT(strAccount);
			rmtVO.setRAMT(wsAMT);
			//log.info("batNo計算匯費.....disbBean.getPFee()");
			wsBANKTemp = rmtVO.getRBK(); //RD046:整合現金支付及分公司付現:修正匯費計算錯誤
			rmtVO.setRMTFEE((int) disbBean.getPFee(strBank.substring(0, 7), wsBANKTemp, wsAMT, strPMETHOD, "", ""));// 匯費,QD0219
			rmtVO.setENTRYDT(iUpdDate);// 輸入日期
			rmtVO.setENTRYTM(iUpdTime);// 輸入時間
			if (ls.size() > 0) {
				List rm = removeDuplicate(ls);
				for (int i = 0; i < rm.size(); i++) {
					wsRMEMO += (String) rm.get(i);
				}
			}
			rmtVO.setRMEMO(wsRMEMO);
			dao.insertRMTF(rmtVO);
			//log.info("新增CAPRMTF記錄:"+ rmtVO.getRBK());
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
			request.setAttribute("batNo", String.valueOf(batNo));// 批號

		} catch (Exception ex) {
			request.setAttribute("txtMsg", "查詢失敗" + ex);
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
	//匯款	   
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
//匯款	
	private List removeDuplicate(List list) {
		HashSet hs = new HashSet(list);
		list.clear();
		list.addAll(hs);
		return list;
	}

}
