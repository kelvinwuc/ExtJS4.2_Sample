package com.aegon.comlib;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

/**
 * System   : CASHWEB
 * 
 * Function : �\�Τ���
 * 
 * Remark   : 
 * 
 * Revision : $$Revision: 1.5 $$
 * 
 * Author   : $$Author: MISSALLY $$
 * 
 * Create Date : $$Date: 2013/12/24 02:15:24 $$
 * 
 * Request ID  : 
 * 
 * CVS History :
 * 
 * $$Log: CommonUtil.java,v $
 * $Revision 1.5  2013/12/24 02:15:24  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��
 * $
 * $Revision 1.4  2013/01/08 04:23:59  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.3.4.1  2012/12/06 06:28:26  MISSALLY
 * $RA0102�@PA0041
 * $�t�X�k�O�ק�S����I�@�~
 * $
 * $Revision 1.3  2012/05/18 09:47:36  MISSALLY
 * $R10314 CASH�t�η|�p�@�~�ק�
 * $$
 *  
 */

public class CommonUtil extends RootClass {

	static final byte shiftOut_ = 0x0E;	// Byte used to shift-out of single byte mode @E7C
	static final byte shiftIn_ = 0x0F;	// Byte used to shift-in to single byte mode @E7C
	static final byte space_ = 0x40;	// Byte for padding for shift-in and shift-out

	private GlobalEnviron globalEnviron = null;
 	private DbFactory dbFactory = null;

	/**
	 * CommonUtil �غc�l���ѡC
	 */
	public CommonUtil() {
		super();
	}

	public CommonUtil(GlobalEnviron thisEnv) {
		super();
		if (thisEnv != null) {
			globalEnviron = thisEnv;
			this.setDebugFileName(thisEnv.getDebugFileName());
			this.setDebug(thisEnv.getDebug());
			this.setSessionId(thisEnv.getSessionId());
		} else {
			setLastError("CommonUtil.CommonUtil()", "The input parameter globalEnviron is null");
		}
	}

	/**
	 * ��k�W�١GconvertWesten2ROCDate(java.util.Date dteInputDate)�C
	 * ��k�\��G�N�ǤJ��������ഫ�����إ������C
	 * �إߤ���G (2001/2/17 �U�� 06:03:03)
	 * �ǤJ�ѼơGjava.util.Date dteInputDate:���ഫ���褸���
	 * �Ǧ^��  �GString strDate : ������,�榡�� YYY/MM/DD
	 * �ק�����G
	 * ��   ��    �� �� ��     ��      ��      ��       �e
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String convertWesten2ROCDate(Date dteInputDate) {
		String strTmpDate = new String("");
		Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(), Constant.CURRENT_LOCALE);
		DecimalFormat df = new DecimalFormat();

		if (dteInputDate != null) {
			thisCalendar.setTime(dteInputDate);
			df.applyPattern("000");
			strTmpDate = df.format(thisCalendar.get(Calendar.YEAR) - 1911) + "/";
			df.applyPattern("00");
			strTmpDate = strTmpDate + df.format(thisCalendar.get(Calendar.MONTH) + 1) + "/" + df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
			if (strTmpDate.equals("-1909/12/31"))
				strTmpDate = new String("�L");
		} else {
			writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertWesten2ROCDate()", "Input Date is null");
		}
		return strTmpDate;
	}
	
	/**
	 * ��k�W�١GconvertWesten2ROCDate1(java.util.Date dteInputDate)�C
	 * ��k�\��G�N�ǤJ��������ഫ�����إ������C
	 * �إߤ���G (2004/5/7 �U�� 02:30:00)
	 * �ǤJ�ѼơGjava.util.Date dteInputDate:���ഫ���褸���
	 * �Ǧ^��  �GString strDate : ������,�榡�� YYYMMDD
	 * �ק�����G
	 * ��   ��    �� �� ��     ��      ��      ��       �e
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String convertWesten2ROCDate1(Date dteInputDate) {
		String strTmpDate = new String("");
		Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(), Constant.CURRENT_LOCALE);
		DecimalFormat df = new DecimalFormat();

		if (dteInputDate != null) {
			thisCalendar.setTime(dteInputDate);
			df.applyPattern("000");
			strTmpDate = df.format(thisCalendar.get(Calendar.YEAR) - 1911);
			df.applyPattern("00");
			strTmpDate = strTmpDate + df.format(thisCalendar.get(Calendar.MONTH) + 1) + df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
			if (strTmpDate.equals("-1909/12/31"))
				strTmpDate = new String("�L");
		} else {
			writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertWesten2ROCDate1()", "Input Date is null");
		}
		return strTmpDate;
	}

	/**
	 * ��k�W�١GconvertWesten2ROCDateTime(java.util.Date dteInputDate)�C
	 * ��k�\��G�N�ǤJ��������ɶ��ഫ�����إ������ɶ��C
	 * �إߤ���G (2001/2/17 �U�� 06:03:03)
	 * �ǤJ�ѼơGjava.util.Date dteInputDate:���ഫ���褸����ɶ�
	 * �Ǧ^��  �GString strDate : �������ɶ�,�榡�� YYY/MM/DD HH:MM:SS
	 * �ק�����G
	 * ��   ��    �� �� ��     ��      ��      ��       �e
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String convertWesten2ROCDateTime(Date dteInputDate) {
		String strTmpDate = new String("");
		Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(), Constant.CURRENT_LOCALE);
		DecimalFormat df = new DecimalFormat();

		if (dteInputDate != null) {
			thisCalendar.setTime(dteInputDate);
			df.applyPattern("000");
			strTmpDate = df.format(thisCalendar.get(Calendar.YEAR) - 1911) + "/";
			df.applyPattern("00");
			strTmpDate = strTmpDate + df.format(thisCalendar.get(Calendar.MONTH) + 1) + "/" + df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
			strTmpDate = strTmpDate + " " + df.format(thisCalendar.get(Calendar.HOUR_OF_DAY)) + ":";
			strTmpDate = strTmpDate + df.format(thisCalendar.get(Calendar.MINUTE)) + ":" + df.format(thisCalendar.get(Calendar.SECOND));
		} else {
			writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertWesten2ROCDateTime()", "Input Date is null");
		}
		return strTmpDate;
	}

	/**
	 * ��k�W�١GconvertWesten2ROCDateTime(java.util.Date dteInputDate)�C
	 * ��k�\��G�N�ǤJ��������ɶ��ഫ�����إ������ɶ��C
	 * �إߤ���G (2004/5/12 �W�� 10:56:00)
	 * �ǤJ�ѼơGjava.util.Date dteInputDate:���ഫ���褸����ɶ�
	 * �Ǧ^��  �GString strDate : �������ɶ�,�榡�� YYYMMDDHHMMSS
	 * �ק�����G
	 * ��   ��    �� �� ��     ��      ��      ��       �e
	 * ========= =========== ===========================================================
	 * 
	 * @return java.lang.String
	 */
	public String convertWesten2ROCDateTime1(Date dteInputDate) {
		String strTmpDate = new String("");
		Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(), Constant.CURRENT_LOCALE);
		DecimalFormat df = new DecimalFormat();

		if (dteInputDate != null) {
			thisCalendar.setTime(dteInputDate);
			df.applyPattern("000");
			strTmpDate = df.format(thisCalendar.get(Calendar.YEAR) - 1911);
			df.applyPattern("00");
			strTmpDate = strTmpDate + df.format(thisCalendar.get(Calendar.MONTH) + 1) + df.format(thisCalendar.get(Calendar.DAY_OF_MONTH));
			strTmpDate = strTmpDate + df.format(thisCalendar.get(Calendar.HOUR_OF_DAY));
			strTmpDate = strTmpDate + df.format(thisCalendar.get(Calendar.MINUTE)) + df.format(thisCalendar.get(Calendar.SECOND));
		} else {
			writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertWesten2ROCDateTime()", "Input Date is null");
		}
		return strTmpDate;
	}

	/**
	 * ��k�W�١GconvertROC2WestenDate(String strROCDate)�C
	 * ��k�\��G�N�ǤJ���������ɶ��ഫ��������C
	 * �إߤ���G (2001/2/17 �U�� 06:03:03)
	 * �ǤJ�ѼơGString strROCDate:���ഫ��������,�榡�� YYY/MM/DD
	 * �Ǧ^��  �Gjava.util.Date dteDate : �����
	 * �ק�����G
	 * ��   ��    �� �� ��     ��      ��      ��       �e
	 * ========= =========== ===========================================================
	 * 
	 */
	public Date convertROC2WestenDate(String strROCDate) {
		Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(), Constant.CURRENT_LOCALE);
		SimpleDateFormat sdteFormat = new SimpleDateFormat("yyyy/MM/dd", Constant.CURRENT_LOCALE);
		DecimalFormat dcmFormat = new DecimalFormat();
		String strTmpStr = new String("");
		Date dteReturnDate = null;
		int iTmpInt = 0;

		if (strROCDate != null) {
			if (strROCDate.length() >= Constant.DATE_FORMAT_LENGTH) {
				try {
					if (strROCDate.indexOf(Constant.DATE_DELIMITER) == -1)
						writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertROC2WestenDate()", "Input Date format is wrong ");
					else {
						strTmpStr = strROCDate.substring(0, strROCDate.indexOf(Constant.DATE_DELIMITER));
						iTmpInt = 1911 + Integer.parseInt(strTmpStr);
						dcmFormat.applyPattern("0000");
						thisCalendar.setTime(sdteFormat.parse(dcmFormat.format(iTmpInt) + strROCDate.substring(strROCDate.indexOf(Constant.DATE_DELIMITER), strROCDate.length())));
						dteReturnDate = thisCalendar.getTime();
					}
				} catch (Exception e) {
					setLastError("ComonUtil.convertROCtoWestenDate()", e);
				}
			} else {
				writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertROC2WestenDate()", "Input Date is '" + strROCDate + "' < " + String.valueOf(Constant.DATE_FORMAT_LENGTH) + " error");
			}
		} else {
			writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertROC2WestenDate()", "Input Date is null");
		}
		return dteReturnDate;
	}

	/**
	 * ��k�W�١GconvertROC2WestenDate1(String strROCDate)�C
	 * ��k�\��G�N�ǤJ���������ɶ��ഫ��������C
	 * �إߤ���G (2001/2/17 �U�� 06:03:03)
	 * �ǤJ�ѼơGString strROCDate:���ഫ��������,�榡�� YYYMMDD
	 * �Ǧ^��  �Gjava.util.Date dteDate : �����
	 * �ק�����G
	 * ��   ��    �� �� ��     ��      ��      ��       �e
	 * ========= =========== ===========================================================
	 * 
	 */
	public Date convertROC2WestenDate1(String strROCDate) {
		String strRoc1 = "";
		if (strROCDate.length() == 7) {
			strRoc1 = strROCDate.substring(0, 3) + "/" + strROCDate.substring(3, 5) + "/" + strROCDate.substring(5, 7);
			return convertROC2WestenDate(strRoc1);
		}
		return null;
	}

	/**
	 * ��k�W�١GconvertROC2WestenDateTime(String strROCDate)�C
	 * ��k�\��G�N�ǤJ���������ɶ��ഫ��������C
	 * �إߤ���G (2001/2/17 �U�� 06:03:03)
	 * �ǤJ�ѼơGString strROCDate:���ഫ��������,�榡�� YYY/MM/DD
	 * �Ǧ^��  �Gjava.util.Date dteDate : �����
	 * �ק�����G
	 * ��   ��    �� �� ��     ��      ��      ��       �e
	 * ========= =========== ===========================================================
	 * 
	 */
	public Date convertROC2WestenDateTime(String strROCDate) {
		Calendar thisCalendar = Calendar.getInstance(TimeZone.getDefault(), Constant.CURRENT_LOCALE);
		SimpleDateFormat sdteFormat = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss", Constant.CURRENT_LOCALE);
		DecimalFormat dcmFormat = new DecimalFormat();
		String strTmpStr = new String("");
		Date dteReturnDate = null;
		int iTmpInt = 0;

		if (strROCDate != null) {
			if (strROCDate.length() >= Constant.DATE_FORMAT_LENGTH) {
				try {
					if (strROCDate.indexOf(Constant.DATE_DELIMITER) == -1)
						writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertROC2WestenDate()", "Input Date format is wrong ");
					else {
						strTmpStr = strROCDate.substring(0, strROCDate.indexOf(Constant.DATE_DELIMITER));
						iTmpInt = 1911 + Integer.parseInt(strTmpStr);
						dcmFormat.applyPattern("0000");
						thisCalendar.setTime(sdteFormat.parse(dcmFormat.format(iTmpInt) + strROCDate.substring(strROCDate.indexOf(Constant.DATE_DELIMITER), strROCDate.length())));
						dteReturnDate = thisCalendar.getTime();
					}
				} catch (Exception e) {
					setLastError("ComonUtil.convertROCtoWestenDate()", e);
				}
			} else {
				writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertROC2WestenDate()", "Input Date is '" + strROCDate + "' < " + String.valueOf(Constant.DATE_FORMAT_LENGTH) + " error");
			}
		} else {
			writeDebugLog(Constant.DEBUG_WARNING, "CommonUtil.convertROC2WestenDate()", "Input Date is null");
		}
		return dteReturnDate;
	}

	public static long diffDate(Date dteDate1, Date dteDate2) {
		long lReturnDays = 0;
		if (dteDate1 != null && dteDate2 != null) {
			SimpleDateFormat sdfFormat = new SimpleDateFormat();
			sdfFormat.applyPattern("yyyy/MM/dd");
			Calendar cldTmpDate = Calendar.getInstance();
			long lDate1, lDate2, lDiff;
			try {
				cldTmpDate.setTime(dteDate1);
				cldTmpDate.setTime(sdfFormat.parse(sdfFormat.format(cldTmpDate.getTime())));
				lDate1 = cldTmpDate.getTime().getTime();
				cldTmpDate.setTime(dteDate2);
				cldTmpDate.setTime(sdfFormat.parse(sdfFormat.format(cldTmpDate.getTime())));
				lDate2 = cldTmpDate.getTime().getTime();
				lDiff = lDate1 - lDate2;
				lReturnDays = (long) (lDiff / (60 * 60 * 1000 * 24));
			} catch (Exception e) {
			}
		}
		return lReturnDays;
	}

	public static Date convertCapsilDate(int iYear, int iMonth, int iDay) throws NumberFormatException {
		Calendar cldTmpDate = Calendar.getInstance();
		if (iYear == 0 && iMonth == 0 && iDay == 0) {
			cldTmpDate.set(0, 0, 0, 0, 0, 0);
		} else {
			if (iYear > 400) {
				iYear = 999 - iYear;
				iMonth = 99 - iMonth;
				iDay = 99 - iDay;
			}
			if (iYear < 111) {
				NumberFormatException ex = new NumberFormatException("convertCapsilDate():The input year is '" + String.valueOf(iYear) + "', less than 111");
				throw ex;
			}
			if (iMonth < 1 || iMonth > 12) {
				NumberFormatException ex = new NumberFormatException("convertCapsilDate():The input month is '" + String.valueOf(iMonth) + "', invalid");
				throw ex;
			}
			if (iDay < 1 || iDay > 31) {
				NumberFormatException ex = new NumberFormatException("convertCapsilDate():The input day is '" + String.valueOf(iDay) + "', invalid");
				throw ex;
			}
			cldTmpDate.set(iYear + 1800, iMonth - 1, iDay);
		}
		return cldTmpDate.getTime();
	}

	public static Date convertCapsilDate(String strYear, String strMonth, String strDay) throws NumberFormatException {
		if (strYear == null || strYear.trim().equals(""))
			strYear = "0";
		if (strMonth == null || strMonth.trim().equals(""))
			strYear = "0";
		if (strDay == null || strDay.trim().equals(""))
			strYear = "0";

		return convertCapsilDate(Integer.parseInt(strYear), Integer.parseInt(strMonth), Integer.parseInt(strDay));
	}

	/**
	 * input format is "YYYMMDD" ex: "2020901" means 2002/09/01  , "1920101" means 1992/01/01
	 */
	public static Date convertCapsilDate(String strCapsilDate) throws NumberFormatException {
		Date dteReturnDate = null;
		if (strCapsilDate != null) {
			if (strCapsilDate.length() != 7) {
				NumberFormatException ex = new NumberFormatException("convertCapsilDate():The input capsil date is '" + strCapsilDate + "', length is equal 7, invalid");
				throw ex;
			} else {
				String strYYY = strCapsilDate.substring(0, 3);
				String strMM = strCapsilDate.substring(3, 5);
				String strDD = strCapsilDate.substring(5, 7);
				int iYYY = Integer.parseInt(strYYY);
				int iMM = Integer.parseInt(strMM);
				int iDD = Integer.parseInt(strDD);
				if (iYYY > 400) {
					iYYY = 999 - iYYY;
					iMM = 99 - iMM;
					iDD = 99 - iDD;
				}
				Calendar cldTmpDate = Calendar.getInstance();
				cldTmpDate.set(iYYY + 1800, iMM - 1, iDD);
				dteReturnDate = cldTmpDate.getTime();
			}
		}

		return dteReturnDate;
	}

	public static Date convertCapsilDate(int iCapsilDate) throws NumberFormatException {
		Date dteReturnDate = DATE_IS_NOT_AVAILABLE;
		if (iCapsilDate != 0) {
			DecimalFormat df = new DecimalFormat("0000000");
			dteReturnDate = convertCapsilDate(df.format(iCapsilDate));
		} else {
			Calendar cldTmpDate = Calendar.getInstance();
			cldTmpDate.set(0, 0, 0, 0, 0, 0);
			dteReturnDate = cldTmpDate.getTime();
		}
		return dteReturnDate;
	}
	
	//R00393   Edit by Leo Huang (EASONTECH) Start
	/**
	 * ��k�W�١GgetBizDateByRCalendar()�C
	 * ��k�\��G���o�{�b�ӷ~��B��� yyymmdd ((����~+111)���))�C
	 * �إߤ���G (2010/9/15 �U�� 17:36:23)
	 * �ǤJ�ѼơG 
	 * �Ǧ^��  �GCalendar �{�b�ӷ~��B���
	 * �ק�����G
	 * ��   ��             �� �� ��                    ��      ��      ��       �e
	 * ========= =========== ===========================================================
	 * 
	 */
	public Calendar getBizDateByRCalendar() {

		String sDate = null;
		Calendar rcalendar = Calendar.getInstance();

		rcalendar.setLenient(false);
		Connection conn = null;
		Statement stmt = null;
		ResultSet rst = null;

		if (globalEnviron.getCapsilSwitch().equals("T")) {

			try {
				if (globalEnviron != null) {
					dbFactory = new DbFactory(globalEnviron);
					conn = dbFactory.getConnection("getBizDate");
					if (!conn.isClosed()) {
						stmt = conn.createStatement();
						rst = stmt.executeQuery("select FLD0003 from ORDUMC");
						rst.next();
						sDate = rst.getString("FLD0003");
						System.out.println("sDate=" + sDate);
						System.out.println(sDate.substring(0, 3));
						rcalendar.set((Integer.parseInt(sDate.substring(0, 3)) + 1800), (Integer.parseInt(sDate.substring(3, 5)) - 1), Integer.parseInt(sDate.substring(5)));
					}
				}
			} catch (Exception ex) {
				System.err.println(ex.getMessage());
			} finally {
				if(conn != null)
					dbFactory.releaseConnection(conn);
			}
		}
		System.out.println("�{�b�ɶ��G" + rcalendar.get(Calendar.YEAR) + "�~" + (rcalendar.get(Calendar.MONTH) + 1) + "��" + rcalendar.get(Calendar.DAY_OF_MONTH) + "��");
		return rcalendar;
	}

	/**
	 * ��k�W�١GgetBizDateByAegonRDate()�C 
	 * ��k�\��G���o�{�b�ӷ~��B��� yyymmdd ((����~+111)���))�C
	 * �إߤ���G (2010/9/15 �W�� 11:26:03) 
	 * �ǤJ�ѼơG �Ǧ^�� �Gjava.util.Date �{�b�ӷ~��B��� 
	 * �ק�����G 
	 * ��� �� �� �� �� �� �� �e
	 * ========= =========== ===========================================================
	 * 
	 */
	public Date getBizDateByRDate() {
		Date rDate = null;
		try {
			rDate = getBizDateByRCalendar().getTime();
		} catch (Exception ex) {
			System.err.println(ex.getMessage());
		}
		return rDate;
	}

	/**
	 * ��k�W�١GcheckDateFomat(String inputdate)�C 
	 * ��k�\��G�ˬd�������7�X yyymmdd ((����~+111)���))�C 
	 * �إߤ���G (2010/9/25 �W�� 12:26:03) 
	 * �ǤJ�ѼơGinputdate����r�� 
	 * �Ǧ^��     �Ginputdate �ˬd��������ת�����r�� 
	 * �ק�����G 
	 * �� �� �� �� �� �� �� �� �e
	 * ========= =========== ===========================================================
	 * 
	 */
	public String checkDateFomat(String inputdate) {
		if (inputdate.length() == 6) {
			inputdate = "0" + inputdate;
		}
		return inputdate;
	}
	//R00393  Edit by Leo Huang (EASONTECH) END

	public static String RTrim(String strInput) {
		String strReturn = null;

		if (strInput != null) {
			int i = 0;
			for (i = strInput.length() - 1; i >= 0; i--) {
				if ((strInput.charAt(i) == '\u3000')
					|| (strInput.charAt(i) == '\u0020')
					|| (strInput.charAt(i) == '\u003F'))
					continue;
				else
					break;
			}
			strReturn = strInput.substring(0, i + 1);
		}
		return strReturn;
	}

	public static String LTrim(String strInput) {
		String strReturn = null;
		if (strInput != null) {
			int i = 0;
			for (i = 0; i < strInput.length(); i++) {
				if ((strInput.charAt(i) == '\u3000')
					|| (strInput.charAt(i) == '\u0020')
					|| (strInput.charAt(i) == '\u003F'))
					continue;
				else
					break;
			}
			strReturn = strInput.substring(i, strInput.length());
		}
		return strReturn;
	}

	public static String AllTrim(String strInput) {
		String strTmp = LTrim(RTrim(strInput));
		if(strTmp == null)
			strTmp = "";
		return strTmp;
	}

	public static String getChannelName(String strChannelCode) {
		String strChannelName = null;
		if (strChannelCode != null) {
			if (strChannelCode.equals("A"))
				strChannelName = "���y�H��";
			else if (strChannelCode.equals("B") || strChannelCode.equals("BR"))
				strChannelName = "�g�N";
			else if (strChannelCode.equals("C") || strChannelCode.equals("AD"))
				strChannelName = "�Ȧ�O�N";
			else if (strChannelCode.equals("D") || strChannelCode.equals("TG"))
				strChannelName = "�x�s�Ȧ�";
			else
				strChannelName = strChannelCode;
		} else
			strChannelName = "";
		return strChannelName;
	}

	public static String getChannelCode(String strAgencyCode) {
		String strChannelCode = "";
		if (strAgencyCode != null) {
			if (strAgencyCode.equals("AEGON")
				|| strAgencyCode.equals("AFLAC")
				|| strAgencyCode.equals("CITIC")
				|| strAgencyCode.equals("SHINF")) {
				strChannelCode = "A";
			} else if (
				strAgencyCode.equals("YBORK")
					|| strAgencyCode.equals("WONDR")
					|| strAgencyCode.equals("YUMIN")) {
				strChannelCode = "B";
			} else if (
				strAgencyCode.equals("ABORK") || strAgencyCode.equals("AD")) {
				strChannelCode = "C";
			} else if (strAgencyCode.equals("TIGER")) {
				strChannelCode = "D";
			} else {
				//strChannelCode = strChannelCode;
			}
		} else {
			strChannelCode = "";
		}
		return strChannelCode;
	}

	public static String getBASChannelCode(String strAgencyCode) {
		String strChannelCode = "";
		if (strAgencyCode != null) {
			if (strAgencyCode.equals("YBORK")
				|| strAgencyCode.equals("WONDR")
				|| strAgencyCode.equals("YUMIN")) {
				strChannelCode = "BR";
			} else if (
				strAgencyCode.equals("ABORK") || strAgencyCode.equals("AD")) {
				strChannelCode = "AD";
			} else if (strAgencyCode.equals("TIGER")) {
				strChannelCode = "TG";
			} else {
				//strChannelCode = strChannelCode;
			}
		} else {
			strChannelCode = "";
		}
		return strChannelCode;
	}

	public static boolean equalDatePart(Date dteFirstDate, Date dteSecondDate) {
		boolean bReturn = false;
		if (dteFirstDate != null && dteSecondDate != null) {
			Calendar cldFirst = Calendar.getInstance();
			Calendar cldSecond = Calendar.getInstance();
			cldFirst.setTime(dteFirstDate);
			cldSecond.setTime(dteSecondDate);
			if (cldFirst.get(Calendar.YEAR) == cldSecond.get(Calendar.YEAR)
				&& cldFirst.get(Calendar.MONTH) == cldSecond.get(Calendar.MONTH)
				&& cldFirst.get(Calendar.DAY_OF_MONTH)
					== cldSecond.get(Calendar.DAY_OF_MONTH))
				bReturn = true;
		}
		return bReturn;
	}

	/**
	 * Method convertCapsilString
	 * @param dteIn : ���ഫ�����
	 * @param type  : �ഫ�����A (S --> ���V, R --> �ϦV )
	 * @return String
	 */
	public static String convertCapsilString(Date dteIn, String type) {
		Calendar tmpCalendar = Calendar.getInstance();
		tmpCalendar.setTime(dteIn);
		int iYYYY = tmpCalendar.get(Calendar.YEAR);
		int iMM = tmpCalendar.get(Calendar.MONTH) + 1;
		int iDD = tmpCalendar.get(Calendar.DATE);
		if (type.equalsIgnoreCase("S")) {
			iYYYY -= 1800;
		} else {
			iYYYY -= 1800;
			iYYYY = 999 - iYYYY;
			iMM = 99 - iMM;
			iDD = 99 - iDD;
		}

		return String.valueOf(iYYYY * 10000 + iMM * 100 + iDD);
	}

	/**
	 * �ˬd�ҶǤJ���r��O�_���X�k�����
	 * 
	 * @param dateString ���ˮ֪��r��
	 * @param dateType �ǤJ�r�ꪺ���A <br>C -> ����~���(yyy/mm/dd)<br>W -> �褸�~���(yyyy/mm/dd)
	 * @return boolean 
	 */
	public boolean isValidDate(String dateString, String dateType) {
		// check parameter
		if (dateString == null || dateType == null) {
			return false;
		}

		boolean returnStatus = true;
		if (dateType.equalsIgnoreCase("C")) {
			// ����~���A
			if (convertWesten2ROCDate(convertROC2WestenDate(dateString)).equalsIgnoreCase(dateString)) {
				returnStatus = true;
			} else {
				returnStatus = false;
			}
		} else {
			// �褸�~���A
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
			try {
				if (sdf.format(sdf.parse(dateString)).equals(dateString)) {
					returnStatus = true;
				} else {
					returnStatus = false;
				}
			} catch (ParseException ex) {
				returnStatus = false;
			}
		}

		return returnStatus;
	}

	public static byte[] addSpaceToAS400String(byte[] aInput, int iStart) {
		byte[] aOutput = new byte[0];

		if (iStart >= 0 && iStart < aInput.length && aInput.length > 0) {
			int iSoSiCnt = 0;
			//���p���`�@���X��SO,SI
			for (int i = iStart; i < aInput.length; i++) {
				if (aInput[i] == shiftOut_ || aInput[i] == shiftIn_)
					iSoSiCnt++;
			}
			//�Ǧ^��byte array�`�����ǤJ�`���[�WSO,SI���`�X(�]���C�@��SO��SI���n�W�[�@��space)
			aOutput = new byte[aInput.length + iSoSiCnt - iStart];
			//�C�@��SO���e���n�[�W�@��EBCDIC��space(0x40),�C�@��SI���᭱�n�[�@��EBCDIC��space
			int iOutPos = 0;
			for (int i = iStart; i < aInput.length; i++) {
				if (aInput[i] == shiftOut_) {
					aOutput[iOutPos++] = space_;
					aOutput[iOutPos++] = aInput[i];
				} else if (aInput[i] == shiftIn_) {
					aOutput[iOutPos++] = aInput[i];
					aOutput[iOutPos++] = space_;
				} else {
					aOutput[iOutPos++] = aInput[i];
				}
			}
		}
		return aOutput;
	}

	public static byte[] addSpaceToAS400String(byte[] aInput) {
		return addSpaceToAS400String(aInput, 0);
	}

	/**
	 * �N��Jbyte array ����r���b�Τ�r�ର���ΡA�ḛ̀Ѽƪ��׿�X
	 * 
	 * @param oriString
	 * @param length
	 * @return
	 */
	
	public static byte[] toCp950Upper(byte[] source, int length) {
		if (length <= 0) {
			return null;
		}
		// �ץ��D���ƪ���X����
		if (length % 2 != 0) {
			length--;
		}
		byte[] returnArray = new byte[length];
		// �p�g�r�X��from 32(space) -> 126(~)
		int[] upper =
			{
				161,
				64,
				161,
				73,
				161,
				168,
				161,
				173,
				162,
				67,
				162,
				72,
				161,
				174,
				161,
				166,
				161,
				93,
				161,
				94,
				161,
				175,
				161,
				207,
				161,
				65,
				161,
				208,
				161,
				68,
				161,
				254,
				162,
				175,
				162,
				176,
				162,
				177,
				162,
				178,
				162,
				179,
				162,
				180,
				162,
				181,
				162,
				182,
				162,
				183,
				162,
				184,
				161,
				71,
				161,
				70,
				161,
				213,
				161,
				215,
				161,
				214,
				161,
				72,
				162,
				73,
				162,
				207,
				162,
				208,
				162,
				209,
				162,
				210,
				162,
				211,
				162,
				212,
				162,
				213,
				162,
				214,
				162,
				215,
				162,
				216,
				162,
				217,
				162,
				218,
				162,
				219,
				162,
				220,
				162,
				221,
				162,
				222,
				162,
				223,
				162,
				224,
				162,
				225,
				162,
				226,
				162,
				227,
				162,
				228,
				162,
				229,
				162,
				230,
				162,
				231,
				162,
				232,
				161,
				101,
				162,
				64,
				161,
				102,
				161,
				115,
				161,
				196,
				161,
				166,
				162,
				233,
				162,
				234,
				162,
				235,
				162,
				236,
				162,
				237,
				162,
				238,
				162,
				239,
				162,
				240,
				162,
				241,
				162,
				242,
				162,
				243,
				162,
				244,
				162,
				245,
				162,
				246,
				162,
				247,
				162,
				248,
				162,
				249,
				162,
				250,
				162,
				251,
				162,
				252,
				162,
				253,
				162,
				254,
				163,
				64,
				163,
				65,
				163,
				66,
				163,
				67,
				161,
				97,
				161,
				85,
				161,
				98,
				161,
				227 };
		for (int i = 0, j = 0; j < length;) {
			if (i >= source.length) {
				// ��J���Ϊť� 0xA140
				returnArray[j++] = (byte) 161;
				returnArray[j++] = (byte) 64;
				i++;
			} else {
				// �P�_�O�_���b��byte, �Yhi-bit��off
				if ((source[i] & 0x80) != 0x80) {
					returnArray[j++] = (byte) upper[(source[i] - 32) * 2];
					returnArray[j++] = (byte) upper[(source[i] - 32) * 2 + 1];
					i += 1;
				} else {
					returnArray[j++] = source[i];
					returnArray[j++] = source[i + 1];
					i += 2;
				}
			}
		}

		return returnArray;
	}

	public static String padLeadingZero(String source, int length) {

		if (source == null) {
			source = "";
		}
		StringBuffer sb = new StringBuffer(source.trim());
		for (int i = 0, j = length - sb.length(); i < j; i++) {
			sb.insert(0, "0");
		}
		return sb.toString();
	}

	public static String padLeadingZero(int source, int length) {

		StringBuffer sb = new StringBuffer(String.valueOf(source).trim());
		for (int i = 0, j = length - sb.length(); i < j; i++) {
			sb.insert(0, "0");
		}
		return sb.toString();
	}
	
	//R10314
	public String convertROCDate(String strROCDate) {
		String strRoc1 = "";
		if (strROCDate.length() == 7) {
			strRoc1 =
				strROCDate.substring(0, 3)
					+ "/"
					+ strROCDate.substring(3, 5)
					+ "/"
					+ strROCDate.substring(5, 7);
			return strRoc1;
		}
		return null;
	}
}