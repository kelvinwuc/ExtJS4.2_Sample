package com.aegon.comlib;

import java.io.*;
import java.text.*;
import java.util.*;
import java.sql.Date;
import java.util.zip.*;

/**
 * @com.register ( clsid=E2B67AF7-72AE-40BB-B25F-4F16FEF86B20, typelib=9592EEBF-75E4-4F22-ADDC-6FDD81A15960 )
 */
public class RootClass {
			
	
	
			

	
	
		private java.lang.String strCharacterSet = new String("big5");
		private static final int DEBUG_FILE_SIZE_LIMIT = 5120000;
		private static final int DATE_FORMAT_ROC_YYYMMDD = 1;
		private static final int DATE_FORMAT_ROC_YYYMMDDHHMMSS = 2;
		private static final int DATE_FORMAT_ROC_YYYMMDDHHMMSSMMM = 3;
		private static final int DATE_FORMAT_ROC_YYY_MM_DD = 4;
		private static final int DATE_FORMAT_ROC_YYY_MM_DD_HH_MM_SS = 5;
		private static final int DATE_FORMAT_ROC_YYY_MM_DD_HH_MM_SS_MMM = 6;
		private static final int DATE_FORMAT_WESTEN_YYYYMMDD = 7;
		private static final int DATE_FORMAT_WESTEN_YYYYMMDDHHMMSS = 8;
		private static final int DATE_FORMAT_WESTEN_YYYYMMDDHHMMSSMMM = 9;
		private static final int DATE_FORMAT_WESTEN_YYYY_MM_DD = 10;
		private static final int DATE_FORMAT_WESTEN_YYYY_MM_DD_HH_MM_SS = 11;
		private static final int DATE_FORMAT_WESTEN_YYYY_MM_DD_HH_MM_SS_MMM = 12;

		protected String strDebugFileName = new String("");
		static protected FileOutputStream foDebug = null;
		protected String strLastErrorMessage = new String("");
		protected String strLastWarningMessage = new String("");
		protected String strLastErrorMethod = new String("");
		protected String strLastWarningMethod = new String("");
		private int iDebugLevel = 0;	
		private java.lang.String strSessionId = new String("");
		
		static public java.util.Date DATE_IS_NOT_AVAILABLE	= null;
		static public String strDataIsNotAvailable = "Not available";




/**
 * RootClass �غc�l���ѡC
 */
public RootClass() {
	super();
	try
	{
		strOsName = System.getProperty("os.name");
		strFileSeparator = System.getProperty("file.separator");
		strPathSeparator = System.getProperty("path.separator");
		strLineSeparator = System.getProperty("line.separator");
		openDebugFile();
		java.util.Calendar cldTmp = java.util.Calendar.getInstance();
		cldTmp.set(0,0,0,0,0,0);
		DATE_IS_NOT_AVAILABLE = cldTmp.getTime();
	}
	catch( SecurityException e )
	{
		setLastError( this.getClass().getName()+".RootClass()",e);
		strOsName = new String("");
		strFileSeparator = new String("");
		strPathSeparator = new String("");
		strLineSeparator = new String("");
	}
}
/**
 * ��k�W�١GbyteToHexString(byte[] abInput)�C
 * ��k�\��G�Ninput byte array convert to hex string�C
 * �إߤ���G (2001/2/13 �U�� 09:51:49)
 * �ǤJ�ѼơGbyte[] abInput : ���ഫ��byte array
 * �Ǧ^��  �G�N��byte[] abInput ��Hex string 
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @return java.lang.String
 * @param abInput byte[]
 */
public String byteToHexString(byte[] abInput) {
	String sReturn = new String("");
	int i;

	for(i=0;i<abInput.length;i++)
		sReturn = sReturn + " " + byteToHexString( abInput[i] );
	
	return sReturn;
}
/**
 * ��k�W�١GbyteToHexString(byte[] abInput)�C
 * ��k�\��G�Ninput byte array convert to hex string�C
 * �إߤ���G (2001/2/13 �U�� 09:51:49)
 * �ǤJ�ѼơGbyte[] abInput : ���ഫ��byte array
 * �Ǧ^��  �G�N��byte[] abInput ��Hex string 
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @return java.lang.String
 * @param abInput byte[]
 */
public String byteToHexString(byte bInput) {
	int iTmp ;
	String sReturn;

	sReturn = "";
	iTmp = (bInput & 0xF0) >> 4;
	switch( iTmp )
	{
		case 0 :
			sReturn = "0";
			break;
		case 1 :
			sReturn = "1";
			break;
		case 2 :
			sReturn = "2";
			break;
		case 3 :
			sReturn = "3";
			break;
		case 4 :
			sReturn = "4";
			break;
		case 5 :
			sReturn = "5";
			break;
		case 6 :
			sReturn = "6";
			break;
		case 7 :
			sReturn = "7";
			break;
		case 8 :
			sReturn = "8";
			break;
		case 9 :
			sReturn = "9";
			break;
		case 10 :
			sReturn = "A";
			break;
		case 11 :
			sReturn = "B";
			break;
		case 12 :
			sReturn = "C";
			break;
		case 13 :
			sReturn = "D";
			break;
		case 14 :
			sReturn = "E";
			break;
		case 15 :
			sReturn = "F";
			break;
		default :
			sReturn = "X";
			break;
	}
	iTmp = bInput & 0x0F;
	switch( iTmp )
	{
		case 0 :
			sReturn = sReturn + "0";
			break;
		case 1 :
			sReturn = sReturn + "1";
			break;
		case 2 :
			sReturn = sReturn + "2";
			break;
		case 3 :
			sReturn = sReturn + "3";
			break;
		case 4 :
			sReturn = sReturn + "4";
			break;
		case 5 :
			sReturn = sReturn + "5";
			break;
		case 6 :
			sReturn = sReturn + "6";
			break;
		case 7 :
			sReturn = sReturn + "7";
			break;
		case 8 :
			sReturn = sReturn + "8";
			break;
		case 9 :
			sReturn = sReturn + "9";
			break;
		case 10 :
			sReturn = sReturn + "A";
			break;
		case 11 :
			sReturn = sReturn + "B";
			break;
		case 12 :
			sReturn = sReturn + "C";
			break;
		case 13 :
			sReturn = sReturn + "D";
			break;
		case 14 :
			sReturn = sReturn + "E";
			break;
		case 15 :
			sReturn = sReturn + "F";
			break;
		default :
			sReturn = sReturn + "X";
			break;
	}
	
	return sReturn;
}
/**
 * ��k�W�١GcloseDebugFile()
 * ��k�\��G����debug�ɡC
 * �إߤ���G (2001/2/13 �U�� 09:20:14)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 */
public void closeDebugFile() 
{
	if( foDebug != null )
	{
		try
		{
			foDebug.flush();
			foDebug.close();
			foDebug = null;
		}
		catch( IOException e )
		{
			setLastError(this.getClass().getName()+":closeDebugFile",e);
		}
	}
}
/**
 * �Щ󦹳B�[�J��k�������C
 * �إߤ���G (2001/2/13 �U�� 08:49:25)
 */
public boolean openDebugFile() {
	boolean bReturnStatus = false;

	if( foDebug == null )
	{
		if( !strDebugFileName.equals("") )
		{
			try
			{
				foDebug = new FileOutputStream( strDebugFileName , true );
				writeDebugLog(Constant.DEBUG_INFORMATION,this.getClass().getName(),"Debug file open successfully, debug file name is '"+strDebugFileName+"'");
				bReturnStatus = true;
			}
			catch( FileNotFoundException e )
			{
				strLastErrorMessage = strDebugFileName + " not found error !!";
				strLastErrorMethod = "openDebugFile()";
			}
			catch( SecurityException e )
			{
				strLastErrorMessage = strDebugFileName + " permission deny error !!";
				strLastErrorMethod = "openDebugFile()";
			}
			catch( Exception e )
			{
				strLastErrorMessage = strDebugFileName + " open debug file error !!";
				strLastErrorMethod = "openDebugFile()";
			}
		
		}
	}
	return bReturnStatus;
}


/**
 * ��k�W�١Gfinalize()�C
 * ��k�\��GRootClass finalize method�C
 * �إߤ���G (2001/2/17 �W�� 08:02:20)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 */
public void finalize() 
{
	/*
	if( foDebug != null )
	{
		try
		{
			foDebug.flush();
			foDebug.close();
		}
		catch( IOException e)
		{
			setLastError(this.getClass().getName()+":finalize",e);
		}
	}
	*/
	return;
}
/**
 * ��k�W�١GgetCharacterSet()�C
 * ��k�\��G�Ǧ^�ثe�{�����r����(Character set)�]�w,for encoding�C
 * �إߤ���G (2001/2/17 �W�� 07:36:11)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �GString �ثe���r�����]�w
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 */  
public String getCharacterSet() {
	return strCharacterSet;
}
 

 
/**
 * ��k�W�١GgetDebugFileName()�C
 * ��k�\��G�Ǧ^�ثe�{�������������ɦW�C
 * �إߤ���G (2001/2/17 �W�� 07:36:11)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �GString �ثe���������ɦW
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @return java.lang.String
 */ 
public String getDebugFileName() {
	return strDebugFileName;
}
 
/**
 * ��k�W�١GsetCharacterSet(String strThisCharacterSet)�C
 * ��k�\��G���s�]�w�ثe�r����(Character set), for character encoding�C
 * �إߤ���G (2001/2/17 �W�� 07:33:54)
 * �ǤJ�ѼơGString strThisCharacterSet : �s���r����
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 */ 
public void setCharacterSet(String strThisCharacterSet) 
{
	if( strThisCharacterSet != null )
	{
		strCharacterSet = strThisCharacterSet;
	}
	return;
}
 
/**
 * ��k�W�١GsetDebugFileName(String strThisDbugFileName)�C
 * ��k�\��G���s�]�w�ثe���������ɦW�C
 * �إߤ���G (2001/2/17 �W�� 07:33:54)
 * �ǤJ�ѼơGString strThisDebugFileName : �s�����������ɦW
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @param strThisDebugFile java.lang.String
 */ 
public void setDebugFileName(String strThisDebugFileName) 
{
	if( strThisDebugFileName != null )
	{
		if( strDebugFileName != strThisDebugFileName )
		{
			strDebugFileName = strThisDebugFileName;
			openDebugFile();
		}
	}
	else
	{
		writeDebugLog(Constant.DEBUG_WARNING,this.getClass().getName()+".setDebugFileName()","The input file name is null");
	}
	return;
} 
																				private String strFileSeparator = null;		private String strLineSeparator = null;		private String strOsName = null;		private String strPathSeparator = null;		
public String getLastErrorMessage() 
{
	return strLastErrorMessage;	
}
/**
 * ��k�W�١GgetLastErrorMethod()�C
 * ��k�\��G�d�̫߳���~�T���o�ͤ���k�C
 * �إߤ���G (2001/2/19 �U�� 09:37:02)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �GString �̫���~�T���o�ͤ���k
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 */        
public String getLastErrorMethod() 
{
	return strLastErrorMethod;	
}
/**
 * ��k�W�١GgetROCDate()�C
 * ��k�\��G���o�ثe�����,�榡��YYY/MM/DD�C
 * �إߤ���G (2001/2/17 �U�� 06:03:03)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �GString strROCDate : ���t�Τ��,�榡��YYY/MM/DD
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @return java.lang.String
 */        
public String getROCDate() 
{
	String strTmpDate = new String("");
	Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(),Constant.CURRENT_LOCALE);
	DecimalFormat df = new DecimalFormat();

	df.applyPattern("000");
	strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911)+"/";
	df.applyPattern("00");
	strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
					"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
	return strTmpDate;
}
/**
 * ��k�W�١GgetTime()�C
 * ��k�\��G���o�ثe�t�ήɶ�,�榡��HH:MM:SS�C
 * �إߤ���G (2001/2/17 �U�� 06:03:03)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �GString strTime : �ثe�t�ήɶ�,�榡��HH:MM:SS
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @return java.lang.String
 */             
public String getTime() 
{
	String strTmpDate = new String("");
	Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(),Constant.CURRENT_LOCALE);
	DecimalFormat df = new DecimalFormat();

//	strTmpDate = thisCalendar.YEAR
	df.applyPattern("00");
	strTmpDate = df.format(thisCalendar.get(Calendar.HOUR_OF_DAY))+":";
	strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MINUTE))+
					":"+df.format(thisCalendar.get(Calendar.SECOND));
	return strTmpDate;
}
/**
 * ��k�W�١GsetLastError(Exception e)�C
 * ��k�\��G�NException�����~�T���ƻs��strErrorMessage���C
 * �إߤ���G (2001/2/19 �U�� 09:43:13)
 * �ǤJ�ѼơGException e :�{�����Ү� ���줧Exception
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @param e java.lang.Exception
 */           
public void setLastError(Exception e) 
{
	strLastErrorMessage = e.getMessage();
	e.printStackTrace();
	strLastErrorMethod = "";
	writeDebugLog(Constant.DEBUG_ERROR,this.getClass().getName()+".setLastError()","error method = '"+strLastErrorMethod+"',error message = '"+strLastErrorMessage+"'");	
}
/**
 * ��k�W�١GsetLastError(String strTmp , Exception e)�C
 * ��k�\��G�N�o�Ϳ��~����}�ƻs��strLastErrorMethod��,�ñNException�����~�T���ƻs��strErrorMessage���C
 * �إߤ���G (2001/2/19 �U�� 09:43:13)
 * �ǤJ�ѼơGString strMethod : �o�Ϳ��~���a��
 *			 Exception e :�{�����Ү����줧Exception
 *			 
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @param e java.lang.Exception
 */         
public void setLastError(String strMethod , Exception e) 
{
	strLastErrorMethod = strMethod ;
//	strLastErrorMessage = e.getMessage();	
	strLastErrorMessage = e.toString();	
	e.printStackTrace();
	writeDebugLog(Constant.DEBUG_ERROR,this.getClass().getName()+".setLastError()","error method = '"+strLastErrorMethod+"',error message = '"+strLastErrorMessage+"'");	
}
/**
 * ��k�W�١GsetLastError(String strTmp , String strMsg)�C
 * ��k�\��G�N�o�Ϳ��~����}�ƻs��strLastErrorMethod��,�ñNstrMsg���~�T���ƻs��strErrorMessage���C
 * �إߤ���G (2001/2/19 �U�� 09:43:13)
 * �ǤJ�ѼơGString strMethod : �o�Ϳ��~���a��
 *			 String strMsg :�{���������~�T��
 *			 
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @param e java.lang.Exception
 */          
public void setLastError(String strMethod , String strMsg ) 
{
	strLastErrorMethod = strMethod ;
	strLastErrorMessage = strMsg;	
	writeDebugLog(Constant.DEBUG_WARNING,this.getClass().getName()+".setLastError()","error method = '"+strLastErrorMethod+"',error message = '"+strLastErrorMessage+"'");	
}
/**
 * ��k�W�١GgetDebug()�C
 * ��k�\��G�Ǧ^�ثe�{����Debug�]�w�C
 * �إߤ���G (2001/2/17 �W�� 07:30:26)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �Gboolean ���A��Debug�]�w���A
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @return boolean
 */ 
public int getDebug() {
	return iDebugLevel;
}

public String getROCDate(java.util.Date dteInputDate) 
{
	String strTmpDate = new String("");
	Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(),Constant.CURRENT_LOCALE);
	DecimalFormat df = new DecimalFormat();

	if( dteInputDate != null )
	{
		thisCalendar.setTime(dteInputDate);
		df.applyPattern("000");
		strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911)+"/";
		df.applyPattern("00");
		strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
					"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
	}
	return strTmpDate;
}


public String getROCDate(int iFormatType, java.util.Date dteInputDate) 
{
/*	
		private static int DATE_FORMAT_ROC_YYYMMDD = 1;
		private static int DATE_FORMAT_ROC_YYYMMDDHHMMSS = 2;
		private static int DATE_FORMAT_ROC_YYYMMDDHHMMSSMMM = 3;
		private static int DATE_FORMAT_ROC_YYY_MM_DD = 4;
		private static int DATE_FORMAT_ROC_YYY_MM_DD_HH_MM_SS = 5;
		private static int DATE_FORMAT_ROC_YYY_MM_DD_HH_MM_SS_MMM = 6;
		private static int DATE_FORMAT_WESTEN_YYYYMMDD = 7;
		private static int DATE_FORMAT_WESTEN_YYYYMMDDHHMMSS = 8;
		private static int DATE_FORMAT_WESTEN_YYYYMMDDHHMMSSMMM = 9;
		private static int DATE_FORMAT_WESTEN_YYYY_MM_DD = 10;
		private static int DATE_FORMAT_WESTEN_YYYY_MM_DD_HH_MM_SS = 11;
		private static int DATE_FORMAT_WESTEN_YYYY_MM_DD_HH_MM_SS_MMM = 12;
*/		
	String strTmpDate = new String("");
	Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(),Constant.CURRENT_LOCALE);
	DecimalFormat df = new DecimalFormat();

	if( dteInputDate != null )
	{
		switch( iFormatType )
		{
			case DATE_FORMAT_ROC_YYYMMDD :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911);
				df.applyPattern("00");
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
						df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				break;
			case DATE_FORMAT_ROC_YYYMMDDHHMMSS :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911);
				df.applyPattern("00");
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
						df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				strTmpDate += df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MINUTE))+
						df.format(thisCalendar.get(Calendar.SECOND));
				break;
			case DATE_FORMAT_ROC_YYYMMDDHHMMSSMMM :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911);
				df.applyPattern("00");
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
						df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				strTmpDate += df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MINUTE))+
						df.format(thisCalendar.get(Calendar.SECOND));
				df.applyPattern("000");
				strTmpDate += df.format(thisCalendar.get(Calendar.MILLISECOND));
				break;
			case DATE_FORMAT_ROC_YYY_MM_DD :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911);
				df.applyPattern("00");
				strTmpDate = strTmpDate +"/"+df.format(thisCalendar.get(Calendar.MONTH)+1)+
						"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				break;
			case DATE_FORMAT_ROC_YYY_MM_DD_HH_MM_SS :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911);
				df.applyPattern("00");
				strTmpDate = strTmpDate +"/"+df.format(thisCalendar.get(Calendar.MONTH)+1)+
						"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				strTmpDate += " "+df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
				strTmpDate = strTmpDate +":"+df.format(thisCalendar.get(Calendar.MINUTE))+
						":"+df.format(thisCalendar.get(Calendar.SECOND));
				break;
			case DATE_FORMAT_ROC_YYY_MM_DD_HH_MM_SS_MMM :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911);
				df.applyPattern("00");
				strTmpDate = strTmpDate +"/"+df.format(thisCalendar.get(Calendar.MONTH)+1)+
						"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				strTmpDate += " "+df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
				strTmpDate = strTmpDate +":"+df.format(thisCalendar.get(Calendar.MINUTE))+
						":"+df.format(thisCalendar.get(Calendar.SECOND));
				df.applyPattern("000");
				strTmpDate += "."+df.format(thisCalendar.get(Calendar.MILLISECOND));
				break;
			case DATE_FORMAT_WESTEN_YYYYMMDD :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("0000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR));
				df.applyPattern("00");
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
						df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				break;
			case DATE_FORMAT_WESTEN_YYYYMMDDHHMMSS :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("0000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR));
				df.applyPattern("00");
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
						df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				strTmpDate += df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MINUTE))+
						df.format(thisCalendar.get(Calendar.SECOND));
				break;
			case DATE_FORMAT_WESTEN_YYYYMMDDHHMMSSMMM :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("0000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR));
				df.applyPattern("00");
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
						df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				strTmpDate += df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
				strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MINUTE))+
						df.format(thisCalendar.get(Calendar.SECOND));
				df.applyPattern("000");
				strTmpDate += df.format(thisCalendar.get(Calendar.MILLISECOND));
				break;
			case DATE_FORMAT_WESTEN_YYYY_MM_DD :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("0000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911);
				df.applyPattern("00");
				strTmpDate = strTmpDate +"/"+df.format(thisCalendar.get(Calendar.MONTH)+1)+
						"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				break;
			case DATE_FORMAT_WESTEN_YYYY_MM_DD_HH_MM_SS :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("0000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR));
				df.applyPattern("00");
				strTmpDate = strTmpDate +"/"+df.format(thisCalendar.get(Calendar.MONTH)+1)+
						"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				strTmpDate += " "+df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
				strTmpDate = strTmpDate +":"+df.format(thisCalendar.get(Calendar.MINUTE))+
						":"+df.format(thisCalendar.get(Calendar.SECOND));
				break;
			case DATE_FORMAT_WESTEN_YYYY_MM_DD_HH_MM_SS_MMM :
				thisCalendar.setTime(dteInputDate);
				df.applyPattern("0000");
				strTmpDate = df.format(thisCalendar.get(Calendar.YEAR));
				df.applyPattern("00");
				strTmpDate = strTmpDate +"/"+df.format(thisCalendar.get(Calendar.MONTH)+1)+
						"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
				strTmpDate += " "+df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
				strTmpDate = strTmpDate +":"+df.format(thisCalendar.get(Calendar.MINUTE))+
						":"+df.format(thisCalendar.get(Calendar.SECOND));
				df.applyPattern("000");
				strTmpDate += "."+df.format(thisCalendar.get(Calendar.MILLISECOND));
				break;
			
		}
	}
	return strTmpDate;
}

/**
 * ��k�W�١GgetTime()�C
 * ��k�\��G���o�ثe�t�ήɶ�,�榡��HH:MM:SS�C
 * �إߤ���G (2001/2/17 �U�� 06:03:03)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �GString strTime : �ثe�t�ήɶ�,�榡��HH:MM:SS
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @return java.lang.String
 */           
public String getROCDateTime(java.util.Date dteInputDate) 
{
	String strTmpDate = new String("");
	Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(),Constant.CURRENT_LOCALE);
	DecimalFormat df = new DecimalFormat();

	thisCalendar.setTime(dteInputDate);
	df.applyPattern("000");
	strTmpDate = df.format(thisCalendar.get(Calendar.YEAR)-1911)+"/";
	df.applyPattern("00");
	strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MONTH)+1)+
					"/"+df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
	strTmpDate = strTmpDate +" "+df.format(thisCalendar.get(Calendar.HOUR_OF_DAY))+":";
	strTmpDate = strTmpDate +df.format(thisCalendar.get(Calendar.MINUTE))+
					":"+df.format(thisCalendar.get(Calendar.SECOND));
	return strTmpDate;
}
/**
 * ��k�W�١GgetTime()�C
 * ��k�\��G���o�ثe�t�ήɶ�,�榡��HH:MM:SS�C
 * �إߤ���G (2001/2/17 �U�� 06:03:03)
 * �ǤJ�ѼơG�L
 * �Ǧ^��  �GString strTime : �ثe�t�ήɶ�,�榡��HH:MM:SS
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @return java.lang.String
 */    

public String getSessionId() {
	return strSessionId;
}

/**
 * �Щ󦹳B�[�J��k�������C
 * �إߤ���G (2001/2/13 �U�� 08:52:25)
 */    
public boolean setDebug(int iThisDebug) {
	boolean bReturnStatus = false;
	if( iThisDebug != iDebugLevel )
	{
		if( iThisDebug >= 0 && iThisDebug <= Constant.MAX_DEBUG_LEVEL )
		{
			writeDebugLog(Constant.DEBUG_INFORMATION,this.getClass().getName()+".setDebug()","The debug level has been set from '"+String.valueOf(iDebugLevel)+"' to '"+String.valueOf(iThisDebug)+"'");
			iDebugLevel = iThisDebug ;
			bReturnStatus = true;
		}
	}
	return bReturnStatus;
}

/**
 * ��k�W�١G�C
 * ��k�\��G�C
 * �إߤ���G (2001/4/4 �U�� 08:51:57)
 * �ǤJ�ѼơG
 * �Ǧ^��  �G
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 */    
public void setSessionId(String strThisSessionId) 
{
	strSessionId = strThisSessionId;
}

/**
 * �Щ󦹳B�[�J��k�������C
 * �إߤ���G (2001/2/13 �U�� 08:40:55)
 * @param strMsg java.lang.String
 */    
public void writeDebugLog(int iThisDebug , String strMsg) 
{
	writeDebugLog(iThisDebug,"",strMsg);
}

/**
 * ��k�W�١GwriteDebugLog(int iLevel,String strProgId,String strMsg)�C
 * ��k�\��G�g�@���O���ܰ����O���ɤ��C
 * �إߤ���G (2001/2/17 �W�� 07:33:54)
 * �ǤJ�ѼơGint iLevel		  : ���~����,0:Error,1:Warning,2:Information,3:Debug
 			 String strProgId : �{���Ψ�Ʀ�m�W��
 			 String strMsg    : �ݬ������T��
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 * @param strThisDebugFile java.lang.String
 */     
public void writeDebugLog(int iThisDebug , String strProgId,String strMsg) 
{
	/*
	SimpleDateFormat formatter = new SimpleDateFormat("hh:mm:ss",java.util.Locale.TAIWAN);
	java.util.Date dt = new java.util.Date();

	if( iThisDebug <= this.getDebug() )
	{
		if( strProgId == null )
			strProgId = new String("");
		if( strProgId.length() < Constant.DEBUG_PROG_ID_LENGTH )
		{
			int i;
			for(i=strProgId.length();i<Constant.DEBUG_PROG_ID_LENGTH;i++)
				strProgId = strProgId + " ";
		}
		else if( strProgId.length() > Constant.DEBUG_PROG_ID_LENGTH )
			strProgId = strProgId.substring(0,Constant.DEBUG_PROG_ID_LENGTH);
		
		if( strMsg == null )
			strMsg = new String(" ");
		try
		{
			write( getROCDate() );
			write( (Constant.DEBUG_FIELD_DELEMITER) );
			write( formatter.format( dt ) );
			if( this.getSessionId() != null )
			{
				if( !this.getSessionId().equals("") )
				{
					write(Constant.DEBUG_FIELD_DELEMITER+this.getSessionId().trim());
				}
			}
			if( iThisDebug == Constant.DEBUG_ERROR )
				write( Constant.DEBUG_FIELD_DELEMITER+"E"+Constant.DEBUG_FIELD_DELEMITER );
			else if( iThisDebug == Constant.DEBUG_WARNING )
				write( Constant.DEBUG_FIELD_DELEMITER+"W"+Constant.DEBUG_FIELD_DELEMITER );
			else if( iThisDebug == Constant.DEBUG_INFORMATION )
				write( Constant.DEBUG_FIELD_DELEMITER+"I"+Constant.DEBUG_FIELD_DELEMITER );
			else if( iThisDebug == Constant.DEBUG_DEBUG )
				write( Constant.DEBUG_FIELD_DELEMITER+"D"+Constant.DEBUG_FIELD_DELEMITER );
			else
			{
				write( Constant.DEBUG_FIELD_DELEMITER );
				write( String.valueOf(iThisDebug) );
				write( Constant.DEBUG_FIELD_DELEMITER );
			}
			write( strProgId);
			write( Constant.DEBUG_FIELD_DELEMITER );
			write( strMsg );
			write( "\r\n" );

			String strArcheveDebug = new String("");
		
			synchronized (foDebug)
			{
				File file = new File(strDebugFileName);
				if( file.length() > DEBUG_FILE_SIZE_LIMIT )
				{
					try
					{
						foDebug.close();
						foDebug = null;
						String strPath = file.getParent();
						String strFileName = file.getName();
						if( strFileName.lastIndexOf(".") != -1 )
							strFileName = strFileName.substring(0,strFileName.lastIndexOf("."));
						File newFile = File.createTempFile(strFileName+getROCDate(DATE_FORMAT_ROC_YYYMMDD,Calendar.getInstance().getTime()),".txt",new File(strPath));
						newFile.delete();
						boolean bStatus = file.renameTo( newFile );
						if( bStatus )
							strArcheveDebug = newFile.getPath();
						openDebugFile();
					}
					catch( Exception ex )
					{
						System.out.println(ex.toString() );
					}
				}
			}
			if( !strArcheveDebug.equals("") )
			{	//�N���v�����Y
				String strFile = strArcheveDebug;
				if( strArcheveDebug.lastIndexOf(".txt") != -1 )
					strFile = strArcheveDebug.substring(0,strArcheveDebug.lastIndexOf(".txt"));
				ZipOutputStream zipFile = new ZipOutputStream( new FileOutputStream( strFile+".zip") );
				zipFile.putNextEntry(new ZipEntry(strArcheveDebug));
				FileInputStream in = new FileInputStream(strArcheveDebug);
				byte[] buffer = new byte[10240];
				int iBytesRead = 0;
				while( (iBytesRead = in.read( buffer )) >= 0 )
				{
					zipFile.write(buffer,0,iBytesRead);
				}
				in.close() ;
				File file = new File(strArcheveDebug);
				file.delete();
				zipFile.close(); 
			}
		}
		catch( IOException e )
		{
				setLastError(e);
		}
	}
	*/
}

private void write(String strInput) throws IOException
{
	if( foDebug == null )
	{
		System.out.print( strInput );
		System.out.flush();
	}
	else
	{
		foDebug.write( strInput.getBytes(strCharacterSet) );
		foDebug.flush();
	}
}

private void write(byte[] abInput) throws IOException
{
	if( foDebug == null )
	{
		System.out.print( new String( abInput ) );
		System.out.flush();
	}
	else
	{
		foDebug.write( abInput );
		foDebug.flush();
	}
}

/**
 * ��k�W�١GwriteDebugLogHex(String strProgId,String strMsg)�C
 * ��k�\��G�ϥΤQ���i��g�@���O���ܰ����O���ɤ��C
 * �إߤ���G (2001/2/17 �W�� 07:33:54)
 * �ǤJ�ѼơGString strProgId : �{���Ψ�Ʀ�m�W��
 			 String strMsg    : �ݬ������T��
 * �Ǧ^��  �G�L
 * �ק�����G
 * ��   ��    �� �� ��     ��      ��      ��       �e
 * ========= =========== ===========================================================
 * 
 */           
public void writeDebugLogHex(int iThisDebug,String strProgId,String strMsg) 
{
	if( strMsg != null )
	{
		try
		{
			writeDebugLog( iThisDebug, strProgId , byteToHexString( strMsg.getBytes(strCharacterSet) ) );
		}
		catch( UnsupportedEncodingException e )
		{
//			setLastError(e);
		}
	}
	else
		writeDebugLog( iThisDebug, strProgId , strMsg );
	return;
}

}