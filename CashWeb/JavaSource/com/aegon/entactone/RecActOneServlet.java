package com.aegon.entactone;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.crooutbat.CapcshfbVO;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class RecActOneServlet extends InitDBServlet {

	private static final long serialVersionUID = 1171328497522210489L;

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String strAction = CommonUtil.AllTrim(request.getParameter("txtAction"));
		
		
		if(strAction.equals("U")) {
			updateDB(request, response);
		}
	}

	private void updateDB(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();

		String strCBKCD_O = CommonUtil.AllTrim(request.getParameter("txtCBKCD_O"));
		String strCATNO_O = CommonUtil.AllTrim(request.getParameter("txtCATNO_O"));
		String strCURRENCY_O = CommonUtil.AllTrim(request.getParameter("txtCURRENCY_O"));
		String strCBKRMD_O = CommonUtil.AllTrim(request.getParameter("txtCBKRMD_O"));
		String strCROAMT_O = CommonUtil.AllTrim(request.getParameter("txtCROAMT_O"));
		String strCSFBAU = CommonUtil.AllTrim(request.getParameter("txtCSFBAU"));
		String strCSFBAD = CommonUtil.AllTrim(request.getParameter("txtCSFBAD"));
		String strCSFBAT = CommonUtil.AllTrim(request.getParameter("txtCSFBAT"));

		String strCATNO = CommonUtil.AllTrim(request.getParameter("txtCATNO"));
		String strCBKRMD = CommonUtil.AllTrim(request.getParameter("txtCBKRMD"));

		String strUpdateSql = "UPDATE CAPCSHFB SET CATNO=?,CBKRMD=?,CSFBUU=?,CSFBUD=?,CSFBUT=? WHERE CBKCD=? and CATNO=? and CBKRMD=? and CROAMT=? and CSFBCURR=? and CSFBAU=? and CSFBAD=? and CSFBAT=? ";

		Connection conn = null;
		PreparedStatement pstmt = null;
		String strMsg = "";

		String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
		String strUpdDate = strDateTime.substring(0, 7);
		String strUpdTime = strDateTime.substring(7);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		try{
			conn = dbFactory.getAS400Connection("RecActOneServlet.update");
			pstmt = conn.prepareStatement(strUpdateSql);
			pstmt.setString(1, strCATNO);
			pstmt.setInt(2, Integer.parseInt(strCBKRMD));
			pstmt.setString(3, strLogonUser);
			pstmt.setInt(4, Integer.parseInt(strUpdDate));
			pstmt.setInt(5, Integer.parseInt(strUpdTime));
			pstmt.setString(6, strCBKCD_O);
			pstmt.setString(7, strCATNO_O);
			pstmt.setInt(8, Integer.parseInt(strCBKRMD_O));
			pstmt.setDouble(9, Double.parseDouble(strCROAMT_O));
			pstmt.setString(10, strCURRENCY_O);
			pstmt.setString(11, strCSFBAU);
			pstmt.setInt(12, Integer.parseInt(strCSFBAD));
			pstmt.setInt(13, Integer.parseInt(strCSFBAT));
			pstmt.executeUpdate();

			strMsg = "修改成功!!";

			String strNextAction = CommonUtil.AllTrim(request.getParameter("nextAction"));
			if(strNextAction.equals("Writeoffs")) {
				strMsg += executeWriteoffs(request, response);
			}

		} catch(Exception ex) {
			strMsg = "修改失敗!!";
			System.err.println(ex.getMessage());
		} finally {
			try {if(pstmt != null) pstmt.close();} catch(Exception ex) {}
			if(conn != null) dbFactory.releaseAS400Connection(conn);
		}

		request.setAttribute("txtMsg", strMsg);
		request.getRequestDispatcher("/EntActOne/RecActOneC.jsp").forward(request, response);

	}

	private String executeWriteoffs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();

		String strReturn = "";

		String strCBKCD_O = CommonUtil.AllTrim(request.getParameter("txtCBKCD_O"));
		String strCATNO = CommonUtil.AllTrim(request.getParameter("txtCATNO"));
		String strCBKRMD = CommonUtil.AllTrim(request.getParameter("txtCBKRMD"));
		String strCURRENCY_O = CommonUtil.AllTrim(request.getParameter("txtCURRENCY_O"));

		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmtFBQ = null;
		PreparedStatement pstmtFU = null;
		PreparedStatement pstmtFBU = null;
		PreparedStatement pstmtDU = null;
		ResultSet rst = null;
		ResultSet rstFBQ = null;

		String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
		String strUpdDate = strDateTime.substring(0, 7);
		String strUpdTime = "";
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		String strQryCAPCSHFSQL = "SELECT * FROM CAPCSHF WHERE ECRDAY=0 and EBKCD=? AND EATNO=? AND EBKRMD=? AND CSHFCURR=? ORDER BY ENTAMT ";
		String strQryCAPCSHFBSQL = " SELECT * FROM CAPCSHFB WHERE CRODAY=0 and CBKCD=? AND CATNO=? AND CSFBCURR=? AND CBKRMD=? ORDER BY CAEGDT,CROAMT ";
		String strUpdateCAPCSHFSQL = " UPDATE CAPCSHF SET EAEGDT=?,ECRDAY=?,CSHFUU=?,CSHFUD=?,CSHFUT=?,CSHFPOCURR=?,CROTYPE=? "
									+ "WHERE ECRDAY=0 and EBKCD=? AND EATNO=? AND CSHFCURR=? AND EBKRMD=? AND ENTAMT=? AND CSHFAU=? AND CSHFAD=? AND CSHFAT=? ";
		String strUpdateCAPCSHFBSQL = " UPDATE CAPCSHFB SET CRODAY=?,CSFBUU=?,CSFBUD=?,CSFBUT=?,CSFBAMTREF=?,CSFBPOCURR=? "
									+ "WHERE CRODAY=0 and CBKCD=? AND CATNO=? AND CSFBCURR=? AND CBKRMD=? AND CROAMT=? AND CSFBAU=? AND CSFBAD=? AND CSFBAT=? ";
		String strUpdateORGNFBDSQL = " UPDATE ORGNFBD SET FBDSEQ=? WHERE FBDREPNO=? AND FBDREPSEQ=? ";

		try{

			double dAmtF = 0.00;
			double dAmtFB = 0.00;
			double dSumAmt = 0.00;
			int iSeq = 1;

			CapcshfbVO fbVo = null;
			List<CapcshfbVO> tmpList = null;

			conn = dbFactory.getAS400Connection("RecActOneServlet.executeWriteoffs");
			pstmt = conn.prepareStatement(strQryCAPCSHFSQL);
			pstmt.setString(1, strCBKCD_O);
			pstmt.setString(2, strCATNO);
			pstmt.setInt(3, Integer.parseInt(strCBKRMD));
			pstmt.setString(4, strCURRENCY_O);
			rst = pstmt.executeQuery();

			pstmtFBQ = conn.prepareStatement(strQryCAPCSHFBSQL);
			pstmtFU = conn.prepareStatement(strUpdateCAPCSHFSQL);
			pstmtFBU = conn.prepareStatement(strUpdateCAPCSHFBSQL);
			pstmtDU = conn.prepareStatement(strUpdateORGNFBDSQL);

			while(rst.next())
			{
				dAmtF = rst.getDouble("ENTAMT");

				pstmtFBQ.clearParameters();
				pstmtFBQ.setString(1, rst.getString("EBKCD"));
				pstmtFBQ.setString(2, rst.getString("EATNO"));
				pstmtFBQ.setString(3, rst.getString("CSHFCURR"));
				pstmtFBQ.setInt(4, rst.getInt("EBKRMD"));
				rstFBQ = pstmtFBQ.executeQuery();
				fbVo = null;
				tmpList = new ArrayList<CapcshfbVO>();

				dAmtFB = 0.00;
				dSumAmt = 0.00;

				while(rstFBQ.next()) 
				{
					dAmtFB = rstFBQ.getDouble("CROAMT");

					//一對一
					if(dAmtF == dAmtFB) 
					{
						strUpdTime = String.valueOf(commonUtil.getBizDateByRCalendar().getTimeInMillis());
						strUpdTime = strUpdTime.substring(7);
						int iTime = Integer.parseInt(strUpdTime);
						if(iTime > 999999) {
							iTime = iTime - 100000;
						}

						pstmtFU.clearParameters();
						pstmtFU.setInt(1, rstFBQ.getInt("CAEGDT"));
						pstmtFU.setInt(2, Integer.parseInt(strUpdDate));
						pstmtFU.setString(3, strLogonUser);
						pstmtFU.setInt(4, Integer.parseInt(strUpdDate));
						pstmtFU.setInt(5, iTime);
						pstmtFU.setString(6, strCURRENCY_O);
						pstmtFU.setString(7, "C");
						pstmtFU.setString(8, rst.getString("EBKCD"));
						pstmtFU.setString(9, rst.getString("EATNO"));
						pstmtFU.setString(10, rst.getString("CSHFCURR"));
						pstmtFU.setInt(11, rst.getInt("EBKRMD"));
						pstmtFU.setDouble(12, dAmtF);
						pstmtFU.setString(13, rst.getString("CSHFAU"));
						pstmtFU.setInt(14, rst.getInt("CSHFAD"));
						pstmtFU.setInt(15, rst.getInt("CSHFAT"));
						pstmtFU.executeUpdate();

						pstmtFBU.clearParameters();
						pstmtFBU.setInt(1, Integer.parseInt(strUpdDate));
						pstmtFBU.setString(2, strLogonUser);
						pstmtFBU.setInt(3, Integer.parseInt(strUpdDate));
						pstmtFBU.setInt(4, iTime);
						pstmtFBU.setDouble(5, dAmtF);
						pstmtFBU.setString(6, strCURRENCY_O);
						pstmtFBU.setString(7, rstFBQ.getString("CBKCD"));
						pstmtFBU.setString(8, rstFBQ.getString("CATNO"));
						pstmtFBU.setString(9, rstFBQ.getString("CSFBCURR"));
						pstmtFBU.setInt(10, rstFBQ.getInt("CBKRMD"));
						pstmtFBU.setDouble(11, dAmtFB);
						pstmtFBU.setString(12, rstFBQ.getString("CSFBAU"));
						pstmtFBU.setInt(13, rstFBQ.getInt("CSFBAD"));
						pstmtFBU.setInt(14, rstFBQ.getInt("CSFBAT"));
						pstmtFBU.executeUpdate();

						pstmtDU.clearParameters();
						pstmtDU.setInt(1, iSeq);
						pstmtDU.setString(2, rstFBQ.getString("CSFBRECTNO"));
						pstmtDU.setInt(3, rstFBQ.getInt("CSFBRECSEQ"));
						pstmtDU.executeUpdate();

						iSeq++;

						break;
					}
					else
					{
						dSumAmt += rstFBQ.getDouble("CROAMT");

						fbVo = new CapcshfbVO();
						fbVo.setCBKCD(rstFBQ.getString("CBKCD"));
						fbVo.setCATNO(rstFBQ.getString("CATNO"));
						fbVo.setCBKRMD(rstFBQ.getInt("CBKRMD"));
						fbVo.setCCURR(rstFBQ.getString("CSFBCURR"));
						fbVo.setCAEGDT(rstFBQ.getInt("CAEGDT"));
						fbVo.setCROAMT(rstFBQ.getDouble("CROAMT"));
						fbVo.setCRODAY(rstFBQ.getInt("CRODAY"));
						fbVo.setPOCURR(strCURRENCY_O);
						fbVo.setCSFBRECTNO(rstFBQ.getString("CSFBRECTNO"));
						fbVo.setCSFBRECSEQ(rstFBQ.getInt("CSFBRECSEQ"));
						fbVo.setCSFBPONO(rstFBQ.getString("CSFBPONO"));
						fbVo.setCSFBAU(rstFBQ.getString("CSFBAU"));
						fbVo.setCSFBAD(rstFBQ.getInt("CSFBAD"));
						fbVo.setCSFBAT(rstFBQ.getInt("CSFBAT"));

						tmpList.add(fbVo);
					}
				}

				//一對多
				if(dSumAmt == dAmtF) 
				{
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
					pstmtFU.setString(6, strCURRENCY_O);
					pstmtFU.setString(7, "C");
					pstmtFU.setString(8, rst.getString("EBKCD"));
					pstmtFU.setString(9, rst.getString("EATNO"));
					pstmtFU.setString(10, rst.getString("CSHFCURR"));
					pstmtFU.setInt(11, rst.getInt("EBKRMD"));
					pstmtFU.setDouble(12, dAmtF);
					pstmtFU.setString(13, rst.getString("CSHFAU"));
					pstmtFU.setInt(14, rst.getInt("CSHFAD"));
					pstmtFU.setInt(15, rst.getInt("CSHFAT"));
					pstmtFU.executeUpdate();

					for(int i=0; i<tmpList.size(); i++) {
						fbVo = tmpList.get(i);

						pstmtFBU.clearParameters();
						pstmtFBU.setInt(1, Integer.parseInt(strUpdDate));
						pstmtFBU.setString(2, strLogonUser);
						pstmtFBU.setInt(3, Integer.parseInt(strUpdDate));
						pstmtFBU.setInt(4, iTime);
						pstmtFBU.setDouble(5, dAmtF);
						pstmtFBU.setString(6, strCURRENCY_O);
						pstmtFBU.setString(7, fbVo.getCBKCD());
						pstmtFBU.setString(8, fbVo.getCATNO());
						pstmtFBU.setString(9, fbVo.getCCURR());
						pstmtFBU.setInt(10, fbVo.getCBKRMD());
						pstmtFBU.setDouble(11, fbVo.getCROAMT());
						pstmtFBU.setString(12, fbVo.getCSFBAU());
						pstmtFBU.setInt(13, fbVo.getCSFBAD());
						pstmtFBU.setInt(14, fbVo.getCSFBAT());
						pstmtFBU.executeUpdate();

						pstmtDU.clearParameters();
						pstmtDU.setInt(1, iSeq);
						pstmtDU.setString(2, fbVo.getCSFBRECTNO());
						pstmtDU.setInt(3, fbVo.getCSFBRECSEQ());
						pstmtDU.executeUpdate();

						iSeq++;
					}

					dSumAmt = 0.00;
					if(!tmpList.isEmpty()) tmpList.clear();
					break;
				}
			}

			strReturn = "\n\r銷帳作業處理完畢!!";

		} catch(Exception ex) {
			strReturn = "銷帳作業處理失敗!!";
			System.err.println("單筆入帳後銷帳失敗 =" + ex.getMessage());
		} finally {
			try {if(rst != null) rst.close();} catch(Exception ex) {}
			try {if(rstFBQ != null) rstFBQ.close();} catch(Exception ex) {}
			try {if(pstmt != null) pstmt.close();} catch(Exception ex) {}
			try {if(pstmtFBQ != null) pstmtFBQ.close();} catch(Exception ex) {}
			try {if(pstmtFU != null) pstmtFU.close();} catch(Exception ex) {}
			try {if(pstmtFBU != null) pstmtFBU.close();} catch(Exception ex) {}
			try {if(pstmtDU != null) pstmtDU.close();} catch(Exception ex) {}
			if(conn != null) dbFactory.releaseAS400Connection(conn);
		}

		return strReturn;
	}
}
