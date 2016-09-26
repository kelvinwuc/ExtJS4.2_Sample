package com.aegon.disb.util;

import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

public class DISBCSubjectTool {

	public static String proPath = "com/aegon/disb/util/DISBCDetailsReports.properties"; //properties�����|
	public static String inOneYear = "101T10"; //�O�@�~����^��إN�X
	public static String overOneYear = "299000";  //�O�G�~����^��إN�X
	public static String inFlagDate = "794401"; //
	public static String flagDate = "2009/03/01"; //

	public static String getSubject(String statusCode, Calendar calendar, String payCode,Calendar nowDate) {
		String retCode = "";
		try {
			// �[��properties���
			Properties prop = getProperties();
			long monthDif;
			// �P�_���ڪ��A��V,2,4�����p
			if (("V").equals(statusCode)) { // ���A���@�o
				monthDif = getMonthDiff(calendar, nowDate);
				if (monthDif >= 0 && monthDif < 12) { // �@�~�H��
					retCode = inOneYear;
				} else if (monthDif >= 12 && monthDif < 24) { // �O�@�~
					retCode = overOneYear;
				} else { // �O��~
					retCode = dealWithOverTwoYear(calendar, payCode, prop);
				}
			} else if (("2").equals(statusCode)) { // ���ڪ��A�X���O2�~
				retCode = dealWithOverTwoYear(calendar, payCode, prop);
			} else if (("4").equals(statusCode)) {// ���ڪ��A�X�����}
				monthDif = getMonthDiff(calendar, nowDate);
				if (monthDif >= 0 && monthDif < 12) { // �@�~�H��
					retCode = inOneYear;
				} else if (monthDif >= 12 && monthDif < 24) { // �O�@�~
					retCode = overOneYear;
				} else { // �O��~
					retCode = dealWithOverTwoYear(calendar, payCode, prop);
				}
			} else if (("").equals(statusCode)) {
				retCode = "";
			} else {
				retCode = prop.getProperty(statusCode);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return retCode;
	}
	   public static void main(String [] argv) throws Exception {
		// Calendar c = new CommonUtil().getBizDateByRCalendar();
		// System.out.println(c.getTime());
		// String startDate = "1900-10-21";
		// String endDate = "1901-10-21";
		// SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
		// Date startDate1 = fmt.parse(startDate);
		// Calendar starCal = Calendar.getInstance();
		// starCal.setTime(startDate1);
		//
		// Date endDate1 = fmt.parse(endDate);
		// Calendar endCal = Calendar.getInstance();
		// endCal.setTime(endDate1);
		// System.out.println(getMonthDiff(starCal, endCal));
		//String strACTCD2C = "29004000ZZZ";
		//System.out.println(strACTCD2C.substring(6, strACTCD2C.length()));
	}

	//�P�_�ۮt�X�Ӥ�
	public static long getMonthDiff(Calendar starCal, Calendar endCal) throws ParseException {
		long monthday;
		int sYear = starCal.get(Calendar.YEAR);
		int sMonth = starCal.get(Calendar.MONTH);
		int sDay = starCal.get(Calendar.DAY_OF_MONTH);
		int eYear = endCal.get(Calendar.YEAR);
		int eMonth = endCal.get(Calendar.MONTH);
		int eDay = endCal.get(Calendar.DAY_OF_MONTH);
		monthday = ((eYear - sYear) * 12 + (eMonth - sMonth));

		if (sDay < eDay) {
			monthday = monthday + 1;
		}

		return monthday;
	}

	//�B�z�O2�~�޿�
	public static String dealWithOverTwoYear (Calendar calendar,String payCode,Properties prop) throws Exception{
		String retCode = "";
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd");
		Date date1 = fmt.parse(flagDate);
		Calendar starCal = Calendar.getInstance();
		starCal.setTime(date1);
		long monthDif = getMonthDiff(starCal, calendar);
		if (monthDif <= 0) {
			retCode = inFlagDate;
		} else {
			retCode = prop.getProperty(payCode);
		}
		return retCode;
	}

	public static Properties getProperties() throws Exception {
		Properties prop = new Properties();
		InputStream fis = DISBCSubjectTool.class.getClassLoader().getResourceAsStream(proPath);
		prop.load(fis);
		return prop;
	}
}
