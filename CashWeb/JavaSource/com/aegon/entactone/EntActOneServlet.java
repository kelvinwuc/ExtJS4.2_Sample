package com.aegon.entactone;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.entactbat.CapcshfDTO;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EntActOneServlet extends InitDBServlet {

	private static final long serialVersionUID = 1198197717588250722L;

	public void init() throws ServletException {
		super.init();
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String strAction = CommonUtil.AllTrim(request.getParameter("txtAction"));

		if(checkBankInfo(request, response)) 
		{
			if( strAction.equalsIgnoreCase("A") )
			{
				insertDb(request, response);
			}
			else if( strAction.equalsIgnoreCase("U"))
			{
				updateDb(request, response);
			}
			else if( strAction.equalsIgnoreCase("D") )
			{
				deleteDb(request, response);
			}
		}

		queryHistory(request, response);

		request.getRequestDispatcher("/EntActOne/EntActOneC.jsp").forward(request, response);
	}

	private boolean checkBankInfo(HttpServletRequest request, HttpServletResponse response) {
		String strEBKCD = CommonUtil.AllTrim(request.getParameter("txtEBKCD"));
		String strEATNO = CommonUtil.AllTrim(request.getParameter("txtEATNO"));
		String strCURRENCY = CommonUtil.AllTrim(request.getParameter("txtCURRENCY"));

		boolean bReturnStatus = false;

		Connection conn = null;		
		PreparedStatement pstmt = null;
		ResultSet rst = null;

		String strSql = "select BKCODE,BKATNO,BKALAT,BKSTAT,BKCURR,BKSTAT from CAPBNKF where BKCODE=? and BKATNO=? and BKCURR=? ";
		String strMsg = "";

		try {
			conn = dbFactory.getAS400Connection("EntActOneServlet.checkBankInfo");
			pstmt = conn.prepareStatement(strSql);
			pstmt.setString(1, strEBKCD);
			pstmt.setString(2, strEATNO);
			pstmt.setString(3, strCURRENCY);
			rst = pstmt.executeQuery();
			if( rst.next() ) {
				if( CommonUtil.AllTrim(rst.getString("BKSTAT")).equals("Y") ) {
					bReturnStatus = true;
				}
			}
		} catch( SQLException e ) {
			System.err.println("EntActOneServlet.checkBankInfo= " + e);
			bReturnStatus = false;
		} finally {
			try { if(rst != null) rst.close(); } catch( SQLException e ) {}
			try { if(pstmt != null) pstmt.close(); } catch( SQLException e ) {}
			if(conn != null) dbFactory.releaseAS400Connection(conn);
		}

		if(!bReturnStatus) {
			strMsg = "帳號: "+strEBKCD+"-"+strEATNO+" ,幣別:"+strCURRENCY+" 金融單位狀態為停用!";
			request.setAttribute("txtMsg", strMsg);
		}

		return bReturnStatus;
	}

	private void insertDb(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();

		String strEBKCD = CommonUtil.AllTrim(request.getParameter("txtEBKCD"));
		String strEATNO = CommonUtil.AllTrim(request.getParameter("txtEATNO"));
		String strCURRENCY = CommonUtil.AllTrim(request.getParameter("txtCURRENCY"));
		String strEBKRMD = CommonUtil.AllTrim(request.getParameter("txtEBKRMD"));
		String strENTAMT = CommonUtil.AllTrim(request.getParameter("txtENTAMT"));
		String strEUSREM = CommonUtil.AllTrim(request.getParameter("txtEUSREM"));
		String strEUSREM2 = CommonUtil.AllTrim(request.getParameter("txtEUSREM2"));

		String strMsg = "";

		if( strEBKCD.equals("") ) {
			strMsg += "金融單位代號不可空白,";
		}
		if( strEATNO.equals("")) {
			strMsg += "金融單位帳號不可空白,";
		}
		if( strCURRENCY.equals("")) {
			strMsg += "幣別不可空白,";
		}
		if( strEBKRMD.equals("0") ) {
			strMsg += "銀行匯款日不可空白,";
		}
		if( Double.parseDouble(strENTAMT) < 0 ) {
			strMsg += "匯款金額不可小於0,";
		}

		if(strMsg.equals("")) 
		{
			String strInsertSql = "INSERT INTO CAPCSHF (EBKCD,EATNO,EBKRMD,EAEGDT,ENTAMT,ECRSRC,ECRDAY,EUSREM,CSHFAU,CSHFAD,CSHFAT,CSHFUU,CSHFUD,CSHFUT,EUSREM2,CSHFCURR) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

			Connection conn = null;		
			PreparedStatement pstmt = null;

			String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
			String strUpdDate = strDateTime.substring(0, 7);
			String strUpdTime = strDateTime.substring(7);
			String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

			try {
				DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
				strEUSREM = disbBean.replacePunct(strEUSREM);
				strEUSREM2 = disbBean.replacePunct(strEUSREM2);

				conn = dbFactory.getAS400Connection("EntActOneServlet.insertDb");
				pstmt = conn.prepareStatement(strInsertSql);
				pstmt.setString(1, strEBKCD);
				pstmt.setString(2, strEATNO);
				pstmt.setInt(3, Integer.parseInt(strEBKRMD));
				pstmt.setInt(4, 0);
				pstmt.setDouble(5, Double.parseDouble(strENTAMT));
				pstmt.setString(6, "0");
				pstmt.setInt(7, 0);
				pstmt.setString(8, strEUSREM);
				pstmt.setString(9, strLogonUser);
				pstmt.setInt(10, Integer.parseInt(strUpdDate));
				pstmt.setInt(11, Integer.parseInt(strUpdTime));
				pstmt.setString(12, strLogonUser);
				pstmt.setInt(13, Integer.parseInt(strUpdDate));
				pstmt.setInt(14, Integer.parseInt(strUpdTime));
				pstmt.setString(15, strEUSREM2);
				pstmt.setString(16, strCURRENCY);
				int iReturn = pstmt.executeUpdate();
				if( iReturn != 1 ) {
					strMsg = "新增失敗!!";
				} else {
					strMsg = "帳號: "+strEBKCD+"-"+strEATNO+" ,幣別:"+strCURRENCY+" ,匯款日:"+strEBKRMD+", 匯款金額:"+strENTAMT+" 新增完成!!";
				}
			} catch( SQLException e ) {
				System.err.println("EntActOneServlet.insertDb= " + e);
			} finally {
				try { if(pstmt != null) pstmt.close(); } catch( SQLException e ) {}
				if(conn != null) dbFactory.releaseAS400Connection(conn);
			}
		}

		CapcshfDTO dto = new CapcshfDTO();
		dto.setEBKCD(strEBKCD);
		dto.setEATNO(strEATNO);
		dto.setCSHFCURR(strCURRENCY);
		dto.setEBKRMD(Integer.parseInt(strEBKRMD));
		request.setAttribute("preDto", dto);
		
		request.setAttribute("txtMsg", strMsg);
	}

	private void updateDb(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();

		String strEBKCD_O = CommonUtil.AllTrim(request.getParameter("txtEBKCD_O"));
		String strEATNO_O = CommonUtil.AllTrim(request.getParameter("txtEATNO_O"));
		String strCURRENCY_O = CommonUtil.AllTrim(request.getParameter("txtCURRENCY_O"));
		String strEBKRMD_O = CommonUtil.AllTrim(request.getParameter("txtEBKRMD_O"));
		String strENTAMT_O = CommonUtil.AllTrim(request.getParameter("txtENTAMT_O"));
		String strCSHFAU = CommonUtil.AllTrim(request.getParameter("txtCSHFAU"));
		String strCSHFAD = CommonUtil.AllTrim(request.getParameter("txtCSHFAD"));
		String strCSHFAT = CommonUtil.AllTrim(request.getParameter("txtCSHFAT"));

		String strEBKCD = CommonUtil.AllTrim(request.getParameter("txtEBKCD"));
		String strEATNO = CommonUtil.AllTrim(request.getParameter("txtEATNO"));
		String strCURRENCY = CommonUtil.AllTrim(request.getParameter("txtCURRENCY"));
		String strEBKRMD = CommonUtil.AllTrim(request.getParameter("txtEBKRMD"));
		String strENTAMT = CommonUtil.AllTrim(request.getParameter("txtENTAMT"));
		String strEUSREM = CommonUtil.AllTrim(request.getParameter("txtEUSREM"));
		String strEUSREM2 = CommonUtil.AllTrim(request.getParameter("txtEUSREM2"));

		String strMsg = "";

		if( strEBKCD.equals("") ) {
			strMsg += "金融單位代號不可空白,";
		}
		if( strEATNO.equals("")) {
			strMsg += "金融單位帳號不可空白,";
		}
		if( strCURRENCY.equals("")) {
			strMsg += "幣別不可空白,";
		}
		if( strEBKRMD.equals("0") ) {
			strMsg += "銀行匯款日不可空白,";
		}
		if( Double.parseDouble(strENTAMT) < 0 ) {
			strMsg += "匯款金額不可小於0,";
		}

		if(strMsg.equals("")) 
		{
			String strUpdateSql = "UPDATE CAPCSHF SET EBKCD=?,EATNO=?,EBKRMD=?,EUSREM=?,CSHFUU=?,CSHFUD=?,CSHFUT=?,ENTAMT=?,EUSREM2=? WHERE EBKCD=? and EATNO=? and EBKRMD=? and ENTAMT=? and CSHFCURR=? and CSHFAU=? and CSHFAD=? and CSHFAT=? ";

			Connection conn = null;		
			PreparedStatement pstmt = null;

			String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
			String strUpdDate = strDateTime.substring(0, 7);
			String strUpdTime = strDateTime.substring(7);
			String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

			try {
				DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
				strEUSREM = disbBean.replacePunct(strEUSREM);
				strEUSREM2 = disbBean.replacePunct(strEUSREM2);

				conn = dbFactory.getAS400Connection("EntActOneServlet.updateDb");
				pstmt = conn.prepareStatement(strUpdateSql);
				pstmt.setString(1, strEBKCD);
				pstmt.setString(2, strEATNO);
				pstmt.setInt(3, Integer.parseInt(strEBKRMD));
				pstmt.setString(4, strEUSREM);
				pstmt.setString(5, strLogonUser);
				pstmt.setInt(6, Integer.parseInt(strUpdDate));
				pstmt.setInt(7, Integer.parseInt(strUpdTime));
				pstmt.setDouble(8, Double.parseDouble(strENTAMT));
				pstmt.setString(9, strEUSREM2);
				pstmt.setString(10, strEBKCD_O);
				pstmt.setString(11, strEATNO_O);
				pstmt.setInt(12, Integer.parseInt(strEBKRMD_O));
				pstmt.setDouble(13, Double.parseDouble(strENTAMT_O));
				pstmt.setString(14, strCURRENCY_O);
				pstmt.setString(15, strCSHFAU);
				pstmt.setInt(16, Integer.parseInt(strCSHFAD));
				pstmt.setInt(17, Integer.parseInt(strCSHFAT));
				int iReturn = pstmt.executeUpdate();
				if( iReturn != 1 ) {
					strMsg = "修改失敗!!";
				} else {
					strMsg = "帳號: "+strEBKCD+"-"+strEATNO+" ,幣別:"+strCURRENCY+" ,匯款日:"+strEBKRMD+", 匯款金額:"+strENTAMT+" 修改完成!!";
				}
			} catch( SQLException e ) {
				System.err.println("EntActOneServlet.updateDb= " + e);
			} finally {
				try { if(pstmt != null) pstmt.close(); } catch( SQLException e ) {}
				if(conn != null) dbFactory.releaseAS400Connection(conn);
			}
		}

		CapcshfDTO dto = new CapcshfDTO();
		dto.setEBKCD(strEBKCD);
		dto.setEATNO(strEATNO);
		dto.setCSHFCURR(strCURRENCY);
		dto.setEBKRMD(Integer.parseInt(strEBKRMD));
		request.setAttribute("preDto", dto);
		
		request.setAttribute("txtMsg", strMsg);
	}

	private void deleteDb(HttpServletRequest request, HttpServletResponse response) {
		String strEBKCD = CommonUtil.AllTrim(request.getParameter("txtEBKCD"));
		String strEATNO = CommonUtil.AllTrim(request.getParameter("txtEATNO"));
		String strCURRENCY = CommonUtil.AllTrim(request.getParameter("txtCURRENCY"));
		String strEBKRMD = CommonUtil.AllTrim(request.getParameter("txtEBKRMD"));
		String strENTAMT = CommonUtil.AllTrim(request.getParameter("txtENTAMT"));
		String strCSHFAU = CommonUtil.AllTrim(request.getParameter("txtCSHFAU"));
		String strCSHFAD = CommonUtil.AllTrim(request.getParameter("txtCSHFAD"));
		String strCSHFAT = CommonUtil.AllTrim(request.getParameter("txtCSHFAT"));

		String strMsg = "";

		String strDelSql = "DELETE FROM CAPCSHF WHERE EBKCD=? and EATNO=? and EBKRMD=? and ENTAMT=? and CSHFCURR=? and CSHFAU=? and CSHFAD=? and CSHFAT=? ";

		Connection conn = null;		
		PreparedStatement pstmt = null;

		try {
			conn = dbFactory.getAS400Connection("EntActOneServlet.deleteDb");
			pstmt = conn.prepareStatement(strDelSql);
			pstmt.setString(1, strEBKCD);
			pstmt.setString(2, strEATNO);
			pstmt.setInt(3, Integer.parseInt(strEBKRMD));
			pstmt.setDouble(4, Double.parseDouble(strENTAMT));
			pstmt.setString(5, strCURRENCY);
			pstmt.setString(6, strCSHFAU);
			pstmt.setInt(7, Integer.parseInt(strCSHFAD));
			pstmt.setInt(8, Integer.parseInt(strCSHFAT));
			int iReturn = pstmt.executeUpdate();
			if( iReturn != 1 ) {
				strMsg = "刪除失敗!!";
			} else {
				strMsg = "帳號: "+strEBKCD+"-"+strEATNO+" ,幣別:"+strCURRENCY+" ,匯款日:"+strEBKRMD+", 匯款金額:"+strENTAMT+" 刪除完成!!";
			}
		} catch( SQLException e ) {
			System.err.println("EntActOneServlet.deleteDb= " + e);
		} finally {
			try { if(pstmt != null) pstmt.close(); } catch( SQLException e ) {}
			if(conn != null) dbFactory.releaseAS400Connection(conn);
		}

		CapcshfDTO dto = new CapcshfDTO();
		dto.setEBKCD(strEBKCD);
		dto.setEATNO(strEATNO);
		dto.setCSHFCURR(strCURRENCY);
		dto.setEBKRMD(Integer.parseInt(strEBKRMD));
		request.setAttribute("preDto", dto);
		
		request.setAttribute("txtMsg", strMsg);
	}

	private void queryHistory(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();

		String strDateTime = commonUtil.convertWesten2ROCDateTime1(commonUtil.getBizDateByRDate());
		String strUpdDate = strDateTime.substring(0, 7);
		String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);

		String strQrySql = "SELECT EBKCD,EATNO,CSHFCURR,EBKRMD,CAST(ENTAMT AS CHAR(9)) AS ENTAMT,EUSREM,CSHFUT AS HID_UT,EUSREM2 FROM CAPCSHF WHERE CSHFUU=? and CSHFUD=? ORDER BY HID_UT DESC ";

		Connection conn = null;		
		PreparedStatement pstmt = null;
		ResultSet rst = null;

		List<CapcshfDTO> list = null;
		CapcshfDTO dto = null;
		
		try {
			conn = dbFactory.getAS400Connection("EntActOneServlet.queryHistory");
			pstmt = conn.prepareStatement(strQrySql);
			pstmt.setString(1, strLogonUser);
			pstmt.setInt(2, Integer.parseInt(strUpdDate));
			rst = pstmt.executeQuery();
			list = new ArrayList<CapcshfDTO>();
			while(rst.next()) {
				 dto = new CapcshfDTO();
				 dto.setEBKCD(rst.getString("EBKCD"));
				 dto.setEATNO(rst.getString("EATNO"));
				 dto.setCSHFCURR(rst.getString("CSHFCURR"));
				 dto.setEBKRMD(rst.getInt("EBKRMD"));
				 dto.setENTAMT(rst.getDouble("ENTAMT"));
				 dto.setEUSREM(rst.getString("EUSREM"));
				 dto.setEUSREM2(rst.getString("EUSREM2"));
				 list.add(dto);
			}
		} catch( SQLException e ) {
			System.err.println("EntActOneServlet.deleteDb= " + e);
		} finally {
			try { if(pstmt != null) pstmt.close(); } catch( SQLException e ) {}
			if(conn != null) dbFactory.releaseAS400Connection(conn);
		}

		request.setAttribute("history", list);
	}
}
