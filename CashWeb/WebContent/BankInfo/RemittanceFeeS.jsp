<%@page import="java.util.Enumeration"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.aegon.comlib.Constant"%>
<%@page import="com.aegon.comlib.DbFactory"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="org.apache.regexp.RE"%>
<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%!
/*
 * System   : CashWeb
 * 
 * Function : �״ڤ���O���@
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.2 $
 * 
 * Author   : $Author: MISSALLY $
 * 
 * Create Date : $Date: 2013/12/24 03:35:04 $
 * 
 * Request ID : R00217
 * 
 * CVS History:
 * 
 * $Log: RemittanceFeeS.jsp,v $
 * Revision 1.2  2013/12/24 03:35:04  MISSALLY
 * R00135---PA0024---CASH�~�ױM��
 *
 *  
 */
%>

<%!

	private static final NumberFormat amtFmt = new DecimalFormat( "###,###,###,###,##0" );
	private static final String myProgramID = "RemittanceFee";
	private static final String messagePrefix = "UpdateMsg=";
	private static final RE re1 = new RE( "," );

	private static int parsePositiveInteger( String fieldName, String fieldValue ) {
	    
	    String errMsg = messagePrefix + "[" + fieldName + "] �����T";
	    
	    try{
	        String s = fieldValue.trim();
	        s = re1.subst( s, "" );
	        int value = Integer.parseInt( s );
	        if( value < 1 )
	            throw new IllegalArgumentException();
	        
	        return value;
	    }catch( RuntimeException e ) {
	        throw new RuntimeException( errMsg );
	    }
	    
	}
	
	private static String getCheckedMessage( Connection conn, String curr ) throws SQLException {
	    
	    String errorMsgPrefix = "���O [" + curr + "] ����Ƥ��s��";
	    String sql = "SELECT FLD003, FLD004 FROM BANKFEE WHERE FLD002 = ? ORDER BY FLD003";
	    PreparedStatement stat = null;
	    ResultSet result = null;
	    
	    try{
	        stat = conn.prepareStatement( sql );
	        stat.setString( 1, curr );
	        result = stat.executeQuery();
	        int count = 0;
	        int prevMinValue = 0;
	        int prevMaxValue = 0;
	        while( result.next() ) {
	            
	            count++;
	            int minValue = result.getInt( "FLD003" );
	            int maxValue = result.getInt( "FLD004" );
	            if( count == 1 && minValue != 1 ) 
	                return errorMsgPrefix + "�A�״ڪ��B (�_) �å��� 1  �}�l�]�w";
	            else if( minValue - prevMaxValue != 1 )
	                return errorMsgPrefix 
	                	+ "�A�״ڪ��B " + amtFmt.format( prevMinValue ) + " - " + amtFmt.format( prevMaxValue )
	                	+ " �P " + amtFmt.format( minValue ) + " - " + amtFmt.format( maxValue )
	                	+ " ���]�w���A��";
	          
	            prevMinValue = minValue;
	            prevMaxValue = maxValue;
	        }
	    }finally{
		    if( result != null )
		        try{ result.close(); } catch( Exception e ) {}
		    if( stat != null )
			    try{ stat.close(); } catch( Exception e ) {}
	    }
	    
	    return null;
	}
%>

<%
	// ���L html code, �u�^���B�z�N�X�P���p
	int status = -1;

	DbFactory dbFactory = null;
	Connection conn = null;
	ResultSet result1 = null;
	ResultSet result2 = null;
	ResultSet result3 = null;
	PreparedStatement stat1 = null;
	PreparedStatement stat2 = null;
	PreparedStatement stat3 = null;
	String sql;
	List outputMsgList = new ArrayList();

	try{
	   	// 1. ���ˬd���
/*
// for testing	   	
Enumeration enu = request.getParameterNames();
while( enu.hasMoreElements() ) {
    String name = (String)enu.nextElement();
    String value = request.getParameter( name );
    System.out.println( name + "=" + value );
}
*/
	   	
	    // action code 
		String actionCode = request.getParameter( "txtAction" );
	   	boolean updateMode = false;
	   	boolean insertMode = false;
		if( actionCode == null )
		    actionCode = "";
		if( actionCode.equals( "U" ) )
		    updateMode = true;
		else if( actionCode.equals( "A" ) )
		    insertMode = true;
		else
		    throw new RuntimeException( messagePrefix + "����N�X�����T" );
		
		// ���O
		String txtCurr = request.getParameter( "txtCurr" );
		if( txtCurr == null || txtCurr.length() > 2 )
		    throw new RuntimeException( messagePrefix + "���O�����T" ); 
		// �״ڪ��B
		String txtRemAmtFrom = request.getParameter( "txtRemAmtFrom" );
		int remAmtFrom = parsePositiveInteger( "�״ڪ��B (�_)", txtRemAmtFrom );
		String txtRemAmtTo = request.getParameter( "txtRemAmtTo" );
		int remAmtTo = parsePositiveInteger( "�״ڪ��B (�W)", txtRemAmtTo );
		if( remAmtFrom >= remAmtTo )
		    throw new RuntimeException( messagePrefix + "�״ڪ��B (�_)���p��״ڪ��B (�W)" );
		// ����O
		String txtBankFee = request.getParameter( "txtBankFee" );
		int bankFee = parsePositiveInteger( "�Ȧ����O", txtBankFee );
		String txtFiscFee = request.getParameter( "txtFiscFee" );
		int fiscFee = parsePositiveInteger( "�������O", txtFiscFee );
		String txtRemFee = request.getParameter( "txtRemFee" );
		int remFee = parsePositiveInteger( "�״ڤ���O", txtRemFee );
		if( bankFee + fiscFee != remFee )
		    throw new RuntimeException( messagePrefix + "�״ڤ���O�����T" ); 
		// �Ƶ�, �i���i�L, �����n null
		String txtMemo = request.getParameter( "txtMemo" );
		if( txtMemo == null )
		    txtMemo = "";
		else
		    txtMemo = txtMemo.trim();
		
		// �ק蠟�e���O - for update 
		String txtOldCurr = request.getParameter( "txtOldCurr" );
		if( updateMode ) {
			if( txtCurr == null || txtCurr.length() > 2 )
		    	throw new RuntimeException( messagePrefix + "��l���O�����T" );
		}
		// �ק蠟�e�״ڪ��B - for update 
		String txtOldRemAmtFrom = request.getParameter( "txtOldRemAmtFrom" );
		String txtOldRemAmtTo = request.getParameter( "txtOldRemAmtTo" );
		int oldRemAmtFrom = 0;
		int oldRemAmtTo = 0;
		if( updateMode ) {
		    oldRemAmtFrom = parsePositiveInteger( "��l�״ڪ��B (�_)", txtOldRemAmtFrom );
		    oldRemAmtTo = parsePositiveInteger( "��l�״ڪ��B (�W)", txtOldRemAmtTo );
		}
	
		
		
		// 2. �ˬd DB �{����, �ݬ� request �O�_�X�z
		status = -2;
		
		dbFactory = (DbFactory)application.getAttribute(Constant.DB_FACTORY);
		conn = dbFactory.getConnection( "myProgramID" );
		
		// a. �s�W�e���ˬd�O�_�w�s�b
		// (�o�˥i�H��ۤv�Q�n�����~�T��, �Ӥ��O SQLException �����C���K�T��)
		if( insertMode ) {
			sql = "SELECT FLD002, FLD003 FROM BANKFEE WHERE FLD002 = ? AND FLD003 = ?";
			stat1 = conn.prepareStatement(sql);
			stat1.setString( 1, txtCurr );
			stat1.setInt( 2, remAmtFrom );
			result1 = stat1.executeQuery();
			if( result1.next() ) 
		    	throw new RuntimeException( messagePrefix + "������Ƥw�s�b, �L�k�����s�W�@�~" );
		}
		
		// �䥦 BRD �W����������L���ˬd, �H�K user �ܦ��L�k�ק�
		// �� update �������������ˬd�@��, ���� user
		
		// 3. �u�������ܧ�
		if( insertMode ) {
		    sql = "INSERT INTO BANKFEE VALUES ( ?,?,?,?,?,?,?,? )";
		    stat3 = conn.prepareStatement( sql );
		    stat3.setString( 1, "     " );
		    stat3.setString( 2, txtCurr );
		    stat3.setInt( 3, remAmtFrom );
		    stat3.setInt( 4, remAmtTo );
		    stat3.setInt( 5, bankFee );
		    stat3.setInt( 6, fiscFee );
		    stat3.setInt( 7, remFee );
		    stat3.setString( 8, txtMemo );
		    stat3.executeUpdate();
		    outputMsgList.add( "�s�W����" );
		} else {
		    // update
		    sql = "UPDATE BANKFEE SET FLD002=?,FLD003=?,FLD004=?,FLD005=?,FLD006=?,FLD007=?,FLD008=? "
		        + " WHERE FLD002=? AND FLD003=? AND FLD004=?";
		    stat3 = conn.prepareStatement( sql );
		    stat3.setString( 1, txtCurr );
		    stat3.setInt( 2, remAmtFrom );
		    stat3.setInt( 3, remAmtTo );
		    stat3.setInt( 4, bankFee );
		    stat3.setInt( 5, fiscFee );
		    stat3.setInt( 6, remFee );
		    stat3.setString( 7, txtMemo );
		    stat3.setString( 8, txtOldCurr );
		    stat3.setInt( 9, oldRemAmtFrom );
		    stat3.setInt( 10, oldRemAmtTo );
		    int count = stat3.executeUpdate();
		    if( count == 0 )
		        throw new RuntimeException( messagePrefix + "���ܧ������" );
		    outputMsgList.add( "�ק粒��" );
		}
		
		// 4. �ˬd�ثe�]�w�O�_�X�z
		String checkedMsg = getCheckedMessage( conn, txtCurr );
		if( checkedMsg != null )
		    outputMsgList.add( checkedMsg );
		/* 
		�ثe���O����ק�, �ҥH�H�U�ˬd���ݭn
		�Y���O�i�H�ק�, �h�H�U�ݭn����
		checkedMsg = getCheckedMessage( conn, txtOldCurr );
		if( checkedMsg != null )
		    outputMsgList.add( checkedMsg );
		*/
		
		// 5. output
		if( outputMsgList.size() == 1 )
		    out.println( outputMsgList.get(0) );
		else {
		    for( int i = 0 ; i < outputMsgList.size() ; i++ )
		        out.println( "�� " + outputMsgList.get(i) );
		}
	}catch( Exception e ) {
	    
	    String errmsg = e.getMessage();
	    // �Y���ۦ� handle ���T��, ���ݦ^�� http response error
	    if( errmsg != null && errmsg.startsWith( messagePrefix ) ) {
	        errmsg = errmsg.substring( messagePrefix.length() );
	        response.setStatus( HttpServletResponse.SC_BAD_REQUEST );
	        out.println( errmsg );
	    } else {
	        e.printStackTrace();
	        response.setStatus( HttpServletResponse.SC_INTERNAL_SERVER_ERROR );
	        out.println( "���A���o�Ϳ��~" );
	    }
	} finally {
	    if( result1 != null )
	        try{ result1.close(); } catch( Exception e ) {}
	    if( result2 != null )
	        try{ result2.close(); } catch( Exception e ) {}
	    if( result3 != null )
	        try{ result3.close(); } catch( Exception e ) {}
	    if( stat1 != null )
		    try{ stat1.close(); } catch( Exception e ) {}
	    if( stat2!= null )
		    try{ stat2.close(); } catch( Exception e ) {}
	    if( stat3 != null )
		    try{ stat3.close(); } catch( Exception e ) {}
	    if( conn != null )
	        try{ dbFactory.releaseConnection( conn ); } catch( Exception e ) {}
	}
%>