<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ include file="/Logon/Init.inc" %>
<%@ include file="/Logon/CheckLogonCommon.jsp" %>
<%!
/**
 * System   : 
 * 
 * Function : 使用者資料維護
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.7 $$
 * 
 * Author   : Sally Hong
 * 
 * Create Date: ${date}
 * 
 * Request ID : 
 * 
 * CVS History:
 * 
 * $Log: UserMaintainS.jsp,v $
 * Revision 1.7  2014/07/18 07:42:31  misariel
 * EC0342-RC0036新增分公司行政人員使用CAPSIL
 *
 * Revision 1.6  2011/08/09 01:34:10  MISSALLY
 * Q10256　 有關CASH系統錯誤無法跑出報表
 *
 *  
 */
%><%
String strThisProgId = "UserMaintain";		//本程式代號
String strClientMsg = "";

CommonUtil commonUtil = new CommonUtil(uiThisUserInfo.getDbFactory().getGlobalEnviron());
Calendar cldCalendar = commonUtil.getBizDateByRCalendar();

String strAction = request.getParameter("txtAction");
String strUserId = request.getParameter("txtUserId");				//使用者代號
String strUserName = request.getParameter("txtUserName");			//使用者姓名
String strPassword = request.getParameter("txtPassword");			//使用者密碼
String strPasswordConfirm = request.getParameter("txtPasswordConfirm");		//確認使用者密碼
String strUserStatus = request.getParameter("radUserStatus");		//使用者狀態:'A':active,'I':inactive, 'R':Registration
String strUserType = request.getParameter("selUserType");			//使用者類型
String strDefaultGroup = request.getParameter("selDefaultGroup");	//功能群組
String strUserDept = request.getParameter("selUserDept");			//使用者部門
String strUserRight = request.getParameter("selUserRight");			//使用者權限
String strRemark = request.getParameter("txtRemark");				//備註
String strEmail = request.getParameter("txtEmail");					//email
String strPasswordValidDay = request.getParameter("txtPasswordValidDay");	//密碼有效日數
String strUserStatusDate = request.getParameter("txtUserStatusDate");		//使用者狀態日期
String strLastPasswordDate = request.getParameter("txtLastPasswordDate");	//最後一次改改密碼日期
String strRegDate = request.getParameter("txtRegDate");				//註冊日期
String strPassNotifyDate = request.getParameter("txtPassNotifyDate");		//密碼通知函日期
String strLastLogonDate = request.getParameter("txtLastLogonDate");	//最後一次logon日期
String strORGLastPasswordDate = request.getParameter("txtOrgPWDT");	//Q80438原始最後一次改改密碼日期
String strUserArea = request.getParameter("selUserArea");			//RC0036
String strUserBrch = request.getParameter("selUserBrch");			//RC0036

java.util.Date dteUserStatusDate = null;
java.util.Date dteLastPasswordDate = null;
java.util.Date dteRegDate = null;
java.util.Date dtePassNotifyDate = null;
java.util.Date dteLastLogonDate = null;
java.util.Date dteORGLastPasswordDate = null;

int iPasswordValidDay = 0;

boolean bPasswordEncryption = uiThisUserInfo.getDbFactory().getGlobalEnviron().getPasswordEncrypted();
EncryptionBean encoder = new EncryptionBean( uiThisUserInfo.getDbFactory() );
boolean bCaseSenstive = uiThisUserInfo.getDbFactory().getGlobalEnviron().getPasswordCaseSenstivity();

if( strAction == null )
	strAction = "";
if( strUserId == null )
	strUserId = "";
if( strUserName == null )
	strUserName = "";
if( strPassword == null )
	strPassword = "";
if( strPasswordConfirm == null )
	strPasswordConfirm = "";
if( strUserStatus == null )
	strUserStatus = "A";
if( strUserType == null )
	strUserType = "";	
if( strDefaultGroup == null )
	strDefaultGroup = "";	
if( strRemark == null )
	strRemark = "";	
if( strEmail == null )
	strEmail = "";	
if( strUserDept == null )
	strUserDept = "";		
if( strUserRight == null )
	strUserRight = "";		
	
/*RC0036*/
if( strUserArea == null )
	strUserArea = "";	
if( strUserBrch == null )
	strUserBrch = "";	


	
if( strUserStatusDate == null || strUserStatusDate.equals("") )
	dteUserStatusDate = cldCalendar.getTime();
else
	dteUserStatusDate = commonUtil.convertROC2WestenDate(strUserStatusDate);
if( strLastPasswordDate == null || strLastPasswordDate.equals("") )
	dteLastPasswordDate = cldCalendar.getTime();
else
	dteLastPasswordDate = commonUtil.convertROC2WestenDate(strLastPasswordDate);
if( strLastLogonDate == null || strLastLogonDate.equals("") )
	dteLastLogonDate = cldCalendar.getTime();
else
	dteLastLogonDate = commonUtil.convertROC2WestenDate(strLastLogonDate);
if( strRegDate == null || strRegDate.equals("") )
	dteRegDate = cldCalendar.getTime();
else
	dteRegDate = commonUtil.convertROC2WestenDate(strRegDate);
if( strPassNotifyDate == null || strPassNotifyDate.equals("") )
	dtePassNotifyDate = cldCalendar.getTime();
else
	dtePassNotifyDate = commonUtil.convertROC2WestenDate(strPassNotifyDate);
//Q80438	
if( strORGLastPasswordDate == null || strORGLastPasswordDate.equals("") )
	dteORGLastPasswordDate = cldCalendar.getTime();
else
	dteORGLastPasswordDate = commonUtil.convertROC2WestenDate(strORGLastPasswordDate);

if( strPasswordValidDay == null || strPasswordValidDay.equals("") )
	iPasswordValidDay = 30;
else
	iPasswordValidDay = Integer.parseInt(strPasswordValidDay);

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rst = null;


String strInquirySql = "select * from USER where USRID = ? ";
//RC0036 String strInsertSqlWithPwd = "insert into USER (USRID,USRNAM,PWD,STAT,STSDTE,USRTYP,PWDVAL,DFTGRP,LLOGD,REMARK,REGDTE,Email,DEPT,USRAUTH) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
//RC0036
String strInsertSqlWithPwd = "insert into USER (USRID,USRNAM,PWD,STAT,STSDTE,USRTYP,PWDVAL,DFTGRP,LLOGD,REMARK,REGDTE,Email,DEPT,USRAUTH,USRAREA,USRBRCH) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
//RC0036 String strInsertSqlNoPwd = "insert into USER (USRID,USRNAM,STAT,STSDTE,USRTYP,PWDVAL,DFTGRP,LLOGD,REMARK,REGDTE,Email,DEPT,USRAUTH) values (?,?,?,?,?,?,?,?,?,?,?,?,?) ";
//RC0036 
String strInsertSqlNoPwd = "insert into USER (USRID,USRNAM,STAT,STSDTE,USRTYP,PWDVAL,DFTGRP,LLOGD,REMARK,REGDTE,Email,DEPT,USRAUTH,USRAREA,USRBRCH) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
//RC0036 String strUpdateSqlWithPwd = "update USER set USRID=?,USRNAM=?,PWD=?,STAT=?,STSDTE=?,USRTYP=?,LPWDTE=?,PWDVAL=?,DFTGRP=?,LLOGD=?,REMARK=?,Email=?,DEPT=?,USRAUTH=? where USRID=? ";
//RC0036 
String strUpdateSqlWithPwd = "update USER set USRID=?,USRNAM=?,PWD=?,STAT=?,STSDTE=?,USRTYP=?,LPWDTE=?,PWDVAL=?,DFTGRP=?,LLOGD=?,REMARK=?,Email=?,DEPT=?,USRAUTH=?,USRAREA=?,USRBRCH=? where USRID=? ";
//RC0036 String strUpdateSqlNoPwd = "update USER set USRID=?,USRNAM=?,STAT=?,STSDTE=?,USRTYP=?,LPWDTE=?,PWDVAL=?,DFTGRP=?,LLOGD=?,REMARK=?,Email=?,DEPT=?,USRAUTH=? where USRID=? ";
//RC0036 
String strUpdateSqlNoPwd = "update USER set USRID=?,USRNAM=?,STAT=?,STSDTE=?,USRTYP=?,LPWDTE=?,PWDVAL=?,DFTGRP=?,LLOGD=?,REMARK=?,Email=?,DEPT=?,USRAUTH=?,USRAREA=?,USRBRCH=? where USRID=? ";
String strDeleteSql = "delete from USER where USRID = ? ";


if(strAction.equalsIgnoreCase("A"))			//新增
{	System.out.println("新增");
	if( strUserId.equals("") )
	{
		strClientMsg = "使用者代號不可空白";
	}
	if( !strPassword.equals(strPasswordConfirm) )
	{
		strClientMsg = "使用者密碼必須要與確認密碼相同";
	}
	if(strClientMsg.equals("")) {
		//檢查鍵值是否存在,如果存在則傳回錯誤訊息,否則將改筆資料新增至資料庫中
		try {
			conn = uiThisUserInfo.getDbFactory().getConnection("UserMaintain");
			pstmt = conn.prepareStatement(strInquirySql);
			pstmt.setString(1, strUserId);
			rst = pstmt.executeQuery();
			if( rst.next() ) {
				strClientMsg = "使用者代號 '"+strUserId+"' 已存在於資料庫中";
			} else {
				if(strPassword.equals("")) {
					pstmt = conn.prepareStatement(strInsertSqlNoPwd);
					pstmt.setString(1, strUserId);
					pstmt.setString(2, strUserName);
					pstmt.setString(3, strUserStatus);
					pstmt.setString(4, commonUtil.convertWesten2ROCDate1(dteUserStatusDate));
					pstmt.setString(5, strUserType);
					pstmt.setString(6, String.valueOf(iPasswordValidDay));
					pstmt.setString(7, strDefaultGroup);
					pstmt.setString(8, commonUtil.convertWesten2ROCDate1(dteLastLogonDate));
					pstmt.setString(9, strRemark);
					pstmt.setString(10, commonUtil.convertWesten2ROCDate1(dteRegDate));
					pstmt.setString(11, strEmail);
					pstmt.setString(12, strUserDept);
					pstmt.setString(13, strUserRight);					
					pstmt.setString(14, strUserArea);  //RC0036
					pstmt.setString(15, strUserBrch); //RC0036
				} else {
					System.out.println("B PWD="+strPassword);
					if( !bCaseSenstive )
						strPassword = strPassword.toUpperCase();
					if( bPasswordEncryption )
						strPassword = encoder.getEncryptedPassword(strPassword);
					System.out.println("A PWD="+strPassword);

					pstmt = conn.prepareStatement(strInsertSqlWithPwd);
					pstmt.setString(1, strUserId);
					pstmt.setString(2, strUserName);
					pstmt.setString(3, strPassword);
					pstmt.setString(4, strUserStatus);
					pstmt.setString(5, commonUtil.convertWesten2ROCDate1(dteUserStatusDate));
					pstmt.setString(6, strUserType);
					pstmt.setString(7, String.valueOf(iPasswordValidDay));
					pstmt.setString(8, strDefaultGroup);
					pstmt.setString(9, commonUtil.convertWesten2ROCDate1(dteLastLogonDate));
					pstmt.setString(10, strRemark);
					pstmt.setString(11, commonUtil.convertWesten2ROCDate1(dteRegDate));
					pstmt.setString(12, strEmail);
					pstmt.setString(13, strUserDept);
					pstmt.setString(14, strUserRight);
					pstmt.setString(15, strUserArea);  //RC0036
					pstmt.setString(16, strUserBrch); //RC0036 
					
				}
				if(pstmt.executeUpdate() != 1) {
					strClientMsg = "使用者代號 '"+strUserId+"' 寫入資料庫超過1筆!";
				} else {
					strClientMsg = "'"+strUserId+"'新增完成";
				}
			}
		} catch (SQLException ex) {
			siThisSessionInfo.setLastError(strThisProgId, ex);
		} finally {
			try { if(rst != null) rst.close(); } catch (Exception e) { }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) { }
			try { if(conn != null) uiThisUserInfo.getDbFactory().releaseConnection(conn); } catch (Exception e) { }
		}
	}
}
else if(strAction.equalsIgnoreCase("U"))	//修改
{
	if( strUserId.equals("") )
	{
		strClientMsg = "使用者代號不可空白";
	}
	if( !strPassword.equals(strPasswordConfirm) )
	{
		strClientMsg = "使用者密碼必須要與確認密碼相同";
	}
	if(strClientMsg.equals("")) {
		//先檢查該筆資料是否存在於資料庫中,若不存在,則傳回錯誤訊息,否則進行資料庫更新
		try {
			conn = uiThisUserInfo.getDbFactory().getConnection("UserMaintain");
			pstmt = conn.prepareStatement(strInquirySql);
			pstmt.setString(1, strUserId);
			rst = pstmt.executeQuery();
			if( !rst.next() ) {
				strClientMsg = "使用者代號 '"+strUserId+"' 未存在於資料庫中";
			} else {
				if(dteLastPasswordDate == dteORGLastPasswordDate)
					strLastPasswordDate = "";
				else
					strLastPasswordDate = commonUtil.convertWesten2ROCDate1(dteLastPasswordDate);

				if(strPassword.equals("")) {
					pstmt = conn.prepareStatement(strUpdateSqlNoPwd);
					pstmt.setString(1, strUserId);
					pstmt.setString(2, strUserName);
					pstmt.setString(3, strUserStatus);
					pstmt.setString(4, commonUtil.convertWesten2ROCDate1(dteUserStatusDate));
					pstmt.setString(5, strUserType);
					pstmt.setString(6, strLastPasswordDate);
					pstmt.setString(7, String.valueOf(iPasswordValidDay));
					pstmt.setString(8, strDefaultGroup);
					pstmt.setString(9, commonUtil.convertWesten2ROCDate1(dteLastLogonDate));
					pstmt.setString(10, strRemark);
					pstmt.setString(11, strEmail);
					pstmt.setString(12, strUserDept);
					pstmt.setString(13, strUserRight);
					pstmt.setString(14, strUserArea);  //RC0036
					pstmt.setString(15, strUserBrch); //RC0036 
					pstmt.setString(16, strUserId); //RC0036
					//RC0036 pstmt.setString(14, strUserId);
				} else {
					System.out.println("B PWD="+strPassword);
					if( !bCaseSenstive )
						strPassword = strPassword.toUpperCase();
					if( bPasswordEncryption )
						strPassword = encoder.getEncryptedPassword(strPassword);
					System.out.println("A PWD="+strPassword);

					pstmt = conn.prepareStatement(strUpdateSqlWithPwd);
					pstmt.setString(1, strUserId);
					pstmt.setString(2, strUserName);
					pstmt.setString(3, strPassword);
					pstmt.setString(4, strUserStatus);
					pstmt.setString(5, commonUtil.convertWesten2ROCDate1(dteUserStatusDate));
					pstmt.setString(6, strUserType);
					pstmt.setString(7, strLastPasswordDate);
					pstmt.setString(8, String.valueOf(iPasswordValidDay));
					pstmt.setString(9, strDefaultGroup);
					pstmt.setString(10, commonUtil.convertWesten2ROCDate1(dteLastLogonDate));
					pstmt.setString(11, strRemark);
					pstmt.setString(12, strEmail);
					pstmt.setString(13, strUserDept);
					pstmt.setString(14, strUserRight);
					pstmt.setString(15, strUserArea);  //RC0036
					pstmt.setString(16, strUserBrch); //RC0036 
					pstmt.setString(17, strUserId); //RC0036
					//RC0036 pstmt.setString(15, strUserId);
				}
				if(pstmt.executeUpdate() != 1) {
					strClientMsg = "使用者代號 '"+strUserId+"' 更新資料庫超過1筆!";
				} else {
					strClientMsg = "'"+strUserId+"'修改完成";
				}
			}
		} catch (SQLException ex) {
			siThisSessionInfo.setLastError(strThisProgId, ex);
		} finally {
			try { if(rst != null) rst.close(); } catch (Exception e) { }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) { }
			try { if(conn != null) uiThisUserInfo.getDbFactory().releaseConnection(conn); } catch (Exception e) { }
		}
	}
}
else if(strAction.equalsIgnoreCase("D"))	//刪除
{
	//先檢查該筆資料是否存在於資料庫中,若不存在,則傳回錯誤訊息,否則進行資料庫刪除
	try {
		conn = uiThisUserInfo.getDbFactory().getConnection("UserMaintain");
		pstmt = conn.prepareStatement(strInquirySql);
		pstmt.setString(1, strUserId);
		rst = pstmt.executeQuery();
		if( !rst.next() ) {
			strClientMsg = "使用者代號 '"+strUserId+"' 未存在於資料庫中";
		} else {
			pstmt = conn.prepareStatement(strDeleteSql);
			pstmt.setString(1, strUserId);
			if(pstmt.executeUpdate() != 1) {
				strClientMsg = "使用者代號 '"+strUserId+"' 刪除資料庫超過1筆!";
			} else {
				strClientMsg = "'"+strUserId+"'刪除完成";
			}
		}
	} catch (SQLException ex) {
		siThisSessionInfo.setLastError(strThisProgId, ex);
	} finally {
		try { if(rst != null) rst.close(); } catch (Exception e) { }
		try { if(pstmt != null) pstmt.close(); } catch (Exception e) { }
		try { if(conn != null) uiThisUserInfo.getDbFactory().releaseConnection(conn); } catch (Exception e) { }
	}
}
else if(strAction.equalsIgnoreCase("I"))	//查詢
{ System.out.println("strInquirySql");
	try {
		conn = uiThisUserInfo.getDbFactory().getConnection("UserMaintain");
		pstmt = conn.prepareStatement(strInquirySql);
		pstmt.setString(1, strUserId);
		rst = pstmt.executeQuery();
		if( !rst.next() ) {
			strClientMsg = "使用者代號 '"+strUserId+"' 未存在於資料庫中";
		} else {
		}
	} catch (SQLException ex) {
		siThisSessionInfo.setLastError(strThisProgId, ex);
	} finally {
		try { if(rst != null) rst.close(); } catch (Exception e) { }
		try { if(pstmt != null) pstmt.close(); } catch (Exception e) { }
		try { if(conn != null) uiThisUserInfo.getDbFactory().releaseConnection(conn); } catch (Exception e) { }
	}
}
else
{
	strClientMsg = "執行代碼'"+strAction+"'錯誤";
}
siThisSessionInfo.getAuditLogBean().writeAuditLog(strThisProgId,strUserId,strAction,strUserId);

request.getRequestDispatcher("UserMaintainC.jsp?txtMsg="+strClientMsg).forward(request,response);
return;
%>