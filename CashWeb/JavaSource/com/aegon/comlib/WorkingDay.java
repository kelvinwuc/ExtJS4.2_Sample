/** =============================================================================
 *  ------------------------------------------------------------------------------------------------------------------
 *   需求單號       修改者                修改日    			  修改內容
 *  ------------------------------------------------------------------------------------------------------------------
 *    R00393      Leo Huang    			2010/11/09           現在時間取Capsil營運時間
 *  =============================================================================
 */
package com.aegon.comlib;


import java.sql.*;
import java.util.*;

/**
 *
 */
public class WorkingDay {

    final static String thisProgId = "WorkingDay";

    int[] workingDate = null; // yyyymmdd 工作日的陣列
    int beginYearMonth = -1; // 己載入陣列的資料開始年份
    int endYearMonth = -1; // 己載入陣列的資料結束年份

    int beginYearMonthDb = 199701; // 工作檔(NB00010F)所存資料的最小年月份
    int endYearMonthDb = -1; // 工作檔(NB00010F)所存資料的最大年月份

    int retryCounter = 0; // 當呼叫 nextDay 傳回 NULL 值時，要遞迴呼叫的控制旗標

	private DbFactory dbFactory;
	//R00393 
	private GlobalEnviron globalEnviron = null;

    static WorkingDay thisWorkDate = null;

    /**
     * Constructor for Single pattern 
     */
    public WorkingDay( DbFactory dbFactory) throws SQLException {
        super();
        this.dbFactory = dbFactory;
        globalEnviron = this.dbFactory.getGlobalEnviron();//R00393
        
        init();
    }

    private void init() throws SQLException {
        Connection con = null;
        Statement stmt = null;
        ResultSet rst = null;
       
        String sql =
            "SELECT MIN((CEWRKYR+1800)*100+CEWRKMT) AS BEGYYMM,MAX((CEWRKYR+1800)*100+CEWRKMT) AS ENDYYMM "
                + " FROM NB00010F "
                + " WHERE CEWRKYR*100+CEWRKMT<>19210 ";

        // 設定資料庫內資料的起迄範圍
        try {
			con = dbFactory.getConnection( thisProgId );
            stmt = con.createStatement();
            rst = stmt.executeQuery(sql);
            if (rst.next()) {
                beginYearMonthDb = rst.getInt("BEGYYMM");
                endYearMonthDb = rst.getInt("ENDYYMM");
            }

            // 載入預設的資料範圍 (今年 1-12月)
            //R00393 edit by Leo Huang
           //Calendar thisCale = Calendar.getInstance();
		   Calendar thisCale = new CommonUtil(globalEnviron).getBizDateByRCalendar();
            int thisYear = thisCale.get(Calendar.YEAR);

            loadTable(thisYear * 100 + 1, thisYear * 100 + 12);

        } finally {
            try {
                if( rst != null ) rst.close();
            } catch (Exception ex1) {}
            try {
                if( stmt != null ) stmt.close();
            } catch (Exception ex1) {}
            try {
                if( con != null ) dbFactory.releaseConnection(con);
            } catch (Exception ex1) {
            }
        }
    }

    /**
     * 傳回offset 參數所指的工作日，並以 yyyymmdd 的格式傳回
     * 
     * @param refDate
     * @param offset
     * @return
     * @throws SQLException 
     */
    public int nextDay(int refDate, int offset) throws SQLException {

        String tmpRefDate = String.valueOf(refDate);
        int workDate = -1;
        int tmpYyyy, tmpMm, tmpDd = -1;

        tmpYyyy = Integer.parseInt(tmpRefDate.substring(0, 4), 10);
        tmpMm = Integer.parseInt(tmpRefDate.substring(4, 6), 10);
        tmpDd = Integer.parseInt(tmpRefDate.substring(6, 8), 10);
        Calendar tmpCal = Calendar.getInstance();
        tmpCal.set(tmpYyyy, tmpMm - 1, tmpDd);
        java.util.Date nDay = nextDay(tmpCal.getTime(), offset);
        tmpCal.setTime(nDay);

        workDate =
            tmpCal.get(Calendar.YEAR) * 10000
                + (tmpCal.get(Calendar.MONTH) + 1) * 100
                + tmpCal.get(Calendar.DAY_OF_MONTH);

        return workDate;
    }

    /**
     * 傳回 offset 參數所指的，工作日
     * 
     * @param refDate
     * @param offset
     * @return
     * @throws SQLException 
     */
    public java.util.Date nextDay(java.util.Date refDate, int offset) throws SQLException {
        java.util.Date workDate = null;

        if (offset == 0) {
        	if(isWorkingDay(refDate))
            	return refDate;
            else
            	offset = 1;
        }

        // 判斷是否需重載陣列資料
        if (needLoadTable(refDate, offset)) {
            loadTable(refDate, offset);
        }

        Calendar cale = Calendar.getInstance();
        cale.setTime(refDate);
        int tmpChkDate =
            cale.get(Calendar.YEAR) * 10000
                + (cale.get(Calendar.MONTH) + 1) * 100
                + cale.get(Calendar.DAY_OF_MONTH);

        // 判斷是否超出陣列範圍
        int pointer = 0; // refDate 在陣列中的位置
        boolean outOfBound = false;
        if (tmpChkDate < workingDate[0] || tmpChkDate > workingDate[workingDate.length - 1]) {
            // 超出陣列
            outOfBound = true;
        } else {
            for (int i = 0, j = workingDate.length; i < j; i++) {
                if (workingDate[i] > tmpChkDate) {
                    if (offset >= 0) {
                        pointer = i - 1;
                    } else {
                        pointer = i;
                    }
                    break;
                } else if (workingDate[i] == tmpChkDate) {
                    pointer = i;
                    break;
                }
            }

            if (offset >= 0 && (pointer + offset) > (workingDate.length-1)) {
                // 超出陣列
                outOfBound = true;
            } else {
                // offset 為負數
                if (pointer + offset < 0) {
                    // 超出陣列
                    outOfBound = true;
                }
            }
        }

        if (outOfBound) {
            // 超出陣列範圍
            if (offset >= 0) {
                for (int i = 0; i < offset; i++) {
                    cale.add(Calendar.DATE, 1);
                    if (cale.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY
                        || cale.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
                        i--;
                    }
                }
            } else {
                for (int i = 0; i > offset; i--) {
                    cale.add(Calendar.DATE, -1);
                    if (cale.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY
                        || cale.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
                        i++;
                    }
                }
            }
            workDate = cale.getTime();
        } else {
            // 未超出陣列範圍
            String returnDate = String.valueOf(workingDate[pointer + offset]);
            int returnY = Integer.parseInt(returnDate.substring(0, 4));
            int returnM = Integer.parseInt(returnDate.substring(4, 6));
            int returnD = Integer.parseInt(returnDate.substring(6, 8));
            Calendar tmpCale = Calendar.getInstance();
            tmpCale.set(returnY, returnM - 1, returnD, cale.get(Calendar.HOUR_OF_DAY), cale.get(Calendar.MINUTE), cale.get(Calendar.SECOND));
            workDate = tmpCale.getTime();
        }

        // 若 workDate 是 null 則 loadTable 再做一次
        if (workDate == null && retryCounter == 0) {
            retryCounter = 1;
            loadTable(refDate, offset);
            workDate = nextDay(refDate, offset);
            retryCounter = 0;
        }

        return workDate;
    }

    public boolean isWorkingDay(int chkDate) throws SQLException {
        boolean returnValue = false;

        String tmpRefDate = String.valueOf(chkDate);
        //int workDate = -1;
        int tmpYyyy, tmpMm, tmpDd = -1;

        tmpYyyy = Integer.parseInt(tmpRefDate.substring(0, 4), 10);
        tmpMm = Integer.parseInt(tmpRefDate.substring(4, 6), 10);
        tmpDd = Integer.parseInt(tmpRefDate.substring(6, 8), 10);
        Calendar tmpCal = Calendar.getInstance();
        tmpCal.set(tmpYyyy, tmpMm - 1, tmpDd);
        if (isWorkingDay(tmpCal.getTime())) {
            returnValue = true;
        } else {
            returnValue = false;
        }
        return returnValue;
    }

    /**
     * 
     * 
     * @param chkDate
     * @return
     * @throws SQLException 
     */
    public boolean isWorkingDay(java.util.Date chkDate) throws SQLException {
        boolean status = false;

        Calendar cale = Calendar.getInstance();
        cale.setTime(chkDate);
        int tmpChkDate =
            cale.get(Calendar.YEAR) * 10000
                + (cale.get(Calendar.MONTH) + 1) * 100
                + cale.get(Calendar.DAY_OF_MONTH);

        // 判斷是否需重載陣列資料
        if (needLoadTable(chkDate, 0)) {
            loadTable(cale.get(Calendar.YEAR) * 100 + 1, cale.get(Calendar.YEAR) * 100 + 12);
        }

        // 判斷是否超出陣列範圍
        if (tmpChkDate < beginYearMonth * 100 + 1 || tmpChkDate > endYearMonth * 100 + 12) {
            // 超出陣列範圍
            if (cale.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY
                || cale.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
                status = false;
            } else {
                status = true;
            }
        } else {
            // 未超出陣列範圍
            for (int i = 0, j = workingDate.length; i < j; i++) {
                if (workingDate[i] > tmpChkDate) {
                    break;
                }
                if (tmpChkDate == workingDate[i]) {
                    status = true;
                    break;
                }
                // for debug
                //System.out.println(i + " : " + workingDate[i]);
            }
        }
        return status;
    }

    /**
     * 載入工作檔 (NB00010F) 內的資料至陣列 (workingDate)中
     * 
     * @param startYear
     * @param endYear
     * @return
     * @throws SQLException 
     */
    synchronized boolean loadTable(int startYYYYMM, int endYYYYMM) throws SQLException {
        boolean status = false;

        // 檢查及修正資料範圍
        int oldBeginYearMonth = beginYearMonth;
        int oldEndYearMonth = endYearMonth;
        //int thisMonth = thisCale.get(Calendar.MONTH) + 1;
        if ((startYYYYMM) < beginYearMonthDb) {
            beginYearMonth = beginYearMonthDb;
        } else if ((startYYYYMM) > endYearMonthDb) {
            //beginYearMonth = -1;
        } else {
            beginYearMonth = startYYYYMM;
        }

        if ((endYYYYMM) < beginYearMonthDb) {
            //endYearMonth = -1;
        } else if ((endYYYYMM) > endYearMonthDb) {
            endYearMonth = endYearMonthDb;
        } else {
            endYearMonth = endYYYYMM;
        }

        // 若陣列範圍?有變動則不需重新載入資料
        if (oldBeginYearMonth == beginYearMonth && oldEndYearMonth == endYearMonth) {
            return true;
        }

        // 載入 Table 資料
		Connection con = null;
        Statement stmt = null;
        ResultSet rst = null;
        String sql =
            "select * from nb00010f where (cewrkyr+1800)*100+cewrkmt >="
                + String.valueOf(beginYearMonth)
                + " and (cewrkyr+1800)*100+cewrkmt <="
                + String.valueOf(endYearMonth);

        try {
			con = dbFactory.getConnection(thisProgId);
            stmt = con.createStatement();
            rst = stmt.executeQuery(sql);

            int tmpYear = 0;
            int tmpMonth = 0;
            //int tmpDay = 0;

            List tmpList = new ArrayList(365);

            while (rst.next()) {
                tmpYear = rst.getInt("CEWRKYR") + 1800;
                tmpMonth = rst.getInt("CEWRKMT");
                for (int i = 1; i <= 31; i++) {
                    if (rst.getString(i + 2).equalsIgnoreCase("Y")) {
                        tmpList.add(new Integer(tmpYear * 10000 + tmpMonth * 100 + i));
                    }
                }
            }

            workingDate = new int[tmpList.size()];
            for (int i = 0, j = tmpList.size(); i < j; i++) {
                workingDate[i] = ((Integer) tmpList.get(i)).intValue();
            }
            status = true;
        } finally {
            try {
                if( rst != null ) rst.close();
            } catch (Exception ex1) {}
            try {
                if( stmt != null ) stmt.close();
            } catch (Exception ex1) {}
            try {
                if( con != null ) dbFactory.releaseConnection(con);
            } catch (Exception ex1) {}
        }

        return status;
    }

    /**
     * 
     * 
     * @param refDate
     * @param offset
     * @return
     * @throws SQLException 
     */
    boolean loadTable(java.util.Date refDate, int offset) throws SQLException {
        //boolean status = false;
        Calendar cale1 = Calendar.getInstance();
        Calendar cale2 = Calendar.getInstance();
        cale1.setTime(refDate);

        cale2.setTime(refDate);
        cale2.add(Calendar.DATE, offset);

        Calendar tmpCale = null;
        if (cale1.after(cale2)) {
            tmpCale = cale1;
            cale1 = cale2;
            cale2 = tmpCale;
        }

        return loadTable(
            cale1.get(Calendar.YEAR) * 100 + cale1.get(Calendar.MONTH) + 1,
            cale2.get(Calendar.YEAR) * 100 + cale2.get(Calendar.MONTH) + 1);
    }

    /**
     * 判斷是否需要自 DB 載入資料至 Array
     * 
     * @param chkDate
     * @param offset
     * @return
     */
    boolean needLoadTable(java.util.Date chkDate, int offset) {
        boolean status = false;

        Calendar cale1 = Calendar.getInstance();
        Calendar cale2 = Calendar.getInstance();
        cale1.setTime(chkDate);

        cale2.setTime(chkDate);
        cale2.add(Calendar.DATE, offset);

        Calendar tmpCale = null;
        if (cale1.after(cale2)) {
            tmpCale = cale1;
            cale1 = cale2;
            cale2 = tmpCale;
        }

        int beginYM = cale1.get(Calendar.YEAR) * 100 + (cale1.get(Calendar.MONTH) + 1);
        int endYM = cale2.get(Calendar.YEAR) * 100 + (cale2.get(Calendar.MONTH) + 1);

        if ((beginYM > beginYearMonth) && (endYM < endYearMonth)) {
            // 不需重新調整陣列範圍
            status = false;
        } else {
            status = true;
        }
        return status;
    }

}
