package com.aegon.disb.disbremit;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.Constant;
import com.aegon.comlib.DbFactory;
import com.aegon.comlib.InitDBServlet;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.StringTool;

import org.apache.log4j.Logger;

/**
 * RD0440-新增外幣指定銀行-台灣銀行:銀行匯款檔TXT
 */
/**
 * System   : CashWeb
 * 
 * Function : 整批匯款
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.38 $$
 * 
 * Author   : Vicky Hsu
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R30530
 * 
 * CVS History:
 * 
 * * $$Log: DISBRemitExportServlet.java,v $
 * * $Revision 1.38  2015/12/03 02:41:38  001946
 * * $*** empty log message ***
 * * $
 * * $Revision 1.37  2015/11/24 04:14:42  001946
 * * $*** empty log message ***
 * * $
 * $Revision 1.37  2015/10/27 Kelvin Wu
 * $RD0440-新增外幣指定銀行-台灣銀行
 * $
 * $$Log: DISBRemitExportServlet.java,v $
 * $Revision 1.38  2015/12/03 02:41:38  001946
 * $*** empty log message ***
 * $
 * $Revision 1.37  2015/11/24 04:14:42  001946
 * $*** empty log message ***
 * $
 * $Revision 1.36  2015/04/30 02:19:42  001946
 * $RD0144-凱基銀行變更人民幣代號及SWIFT CODE
 * $
 * $Revision 1.35  2015/01/19 02:33:50  MISDAVID
 * $RD0020中國信託匯款檔新增交易性質註記固定給空S
 * $
 * $Revision 1.33  2014/10/07 06:25:11  misariel
 * $RC0036-修正科學符號的問題
 * $
 * $Revision 1.32  2014/08/19 04:04:08  missteven
 * $RC0036-2
 * $
 * $Revision 1.31  2014/08/08 03:41:34  missteven
 * $RC0036
 * $
 * $Revision 1.30  2014/07/18 07:17:26  misariel
 * $EC0342-RC0036新增分公司行政人員使用CAPSIL
 * $
 * $Revision 1.29  2014/02/26 06:39:32  MISSALLY
 * $EB0537 --- 新增萬泰銀行為外幣指定銀行
 * $
 * $Revision 1.28  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $
 * $Revision 1.27  2013/04/18 02:09:26  MISSALLY
 * $RA0074 FNE滿期生存金受益人帳戶及給付
 * $修正中信匯款檔
 * $
 * $Revision 1.26  2013/03/29 09:55:05  MISSALLY
 * $RB0062 PA0047 - 新增指定銀行 彰化銀行
 * $
 * $Revision 1.25  2013/02/26 10:15:02  ODCWilliam
 * $william wu
 * $RA0074
 * $
 * $Revision 1.24  2013/01/08 04:24:03  MISSALLY
 * $將分支的程式Merge至HEAD
 * $
 * $Revision 1.23.4.2  2012/12/06 06:28:27  MISSALLY
 * $RA0102　PA0041
 * $配合法令修改酬佣支付作業
 * $
 * $Revision 1.23.4.1  2012/09/06 02:03:47  MISSALLY
 * $RA0140---新增兆豐為外幣指定行，依據銀行要求調整分行代號
 * $
 * $Revision 1.23  2012/07/17 02:50:31  MISSALLY
 * $RA0043 / RA0081
 * $1.一銀台新下載檔格式調整
 * $2.票據庫存之核准權限改讀設定
 * $
 * $Revision 1.22  2011/11/08 09:16:39  MISSALLY
 * $Q10312
 * $匯款功能-整批匯款作業
 * $1.修正銀行帳號不一致
 * $2.調整兆豐匯款檔
 * $
 * $Revision 1.21  2011/04/22 01:46:26  MISSALLY
 * $R10068-P00026
 * $新增安泰銀行為外匯指定行手續費及下載檔設定
 * $
 * $Revision 1.20  2011/04/13 08:51:28  MISJIMMY
 * $R00566--元大銀行新增匯款檔
 * $
 * $Revision 1.19  2010/11/23 06:50:41  MISJIMMY
 * $R00226-百年專案
 * $
 * $Revision 1.18  2010/05/05 09:20:50  missteven
 * $R90735 FIX BUG
 * $
 * $Revision 1.17  2010/05/04 07:14:39  missteven
 * $R90735
 * $
 * $Revision 1.16  2008/08/12 06:57:03  misvanessa
 * $R80480_上海銀行外幣整批轉存檔案
 * $
 * $Revision 1.15  2008/08/06 06:54:29  MISODIN
 * $R80338 調整CASH系統 for 出納外幣一對一需求
 * $
 * $Revision 1.14  2008/06/12 09:41:35  misvanessa
 * $R80300_收單行轉台新,新增上傳檔案及報表
 * $
 * $Revision 1.13  2008/04/30 07:48:45  misvanessa
 * $R80300_收單行轉台新,新增下載檔案及報表
 * $
 * $Revision 1.12  2007/09/07 10:25:20  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.11  2007/08/28 01:40:11  MISVANESSA
 * $R70574_SPUL配息新增匯出檔案
 * $
 * $Revision 1.10  2007/05/02 07:15:16  MISVANESSA
 * $R70088_SPUL配息中信.永豐格式
 * $
 * $Revision 1.9  2007/03/16 01:44:19  MISVANESSA
 * $R70088_永豐格式修改
 * $
 * $Revision 1.8  2007/03/06 01:33:37  MISVANESSA
 * $R70088_SPUL配息新增客戶負擔手續費
 * $
 * $Revision 1.7  2007/01/31 08:01:31  MISVANESSA
 * $R70088_SPUL配息
 * $
 * $Revision 1.6  2007/01/16 07:48:41  MISVANESSA
 * $R60550_抓取方式修改
 * $
 * $Revision 1.5  2007/01/05 07:24:01  MISVANESSA
 * $R60550_匯出檔案.報表修改
 * $
 * $Revision 1.4  2007/01/04 03:15:29  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.3  2006/11/30 09:15:14  MISVANESSA
 * $R60550_配合SPUL&外幣付款修改
 * $
 * $Revision 1.2  2006/09/04 09:43:35  miselsa
 * $R60747_1.整批匯款增加出納確認日 2.匯出報表匯款日期改為出納確認日 3.支付查詢付款日期為出納確認日
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.8  2006/04/28 02:08:38  misangel
 * $R50891:VA美元保單-顯示幣別(修改金額超過千萬亂碼)
 * $
 * $Revision 1.1.2.7  2006/04/27 09:25:45  misangel
 * $R50891:VA美元保單-顯示幣別
 * $
 * $Revision 1.1.2.6  2005/09/16 01:39:23  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併(修正匯款序號)
 * $
 * $Revision 1.1.2.5  2005/08/19 06:56:18  misangel
 * $R50427 : 匯款件依部門+姓名+帳號合併
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:27  miselsa
 * $R30530 支付系統
 * $$
 *  
 */

public class DISBRemitExportServlet  extends InitDBServlet {
	
	Logger log = Logger.getLogger(getClass());
	
	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private String path = "";

	//Initialize global variables
	public void init() throws ServletException {
		super.init();
	}

	//Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	//Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		try {
			if("query".equals(request.getParameter("action"))) {
				this.query(request, response);			
				RequestDispatcher dispatcher = request.getRequestDispatcher(path);	
				dispatcher.forward(request, response);
			} else if("download".equals(request.getParameter("action"))) {
				this.download(request, response);
			}
		} catch(Exception e) {
			System.err.println(e.toString());	
			request.setAttribute("txtMsg",e.getMessage());
		}
	}

	private void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception{
		path = "/DISB/DISBRemit/DISBRemitDownload.jsp";

		/*R60747 將出納日期PCSHDT改為出納確認日PCSHCM  START*/
		int PCSHCM = Integer.parseInt(StringTool.removeChar(request.getParameter("PCSHCM"),'/'));
		//RD0382:OIU
		String company = "";//RD0382:OIU
		company = request.getParameter("selCompany");
		if (company != null){
			company = company.trim();
		}else{
			company = "";
		}
		//String company = request.getParameter("selCompany");
		/*R60747 將出納日期PCSHDT改為出納確認日PCSHCM  END*/
		System.out.println("PCSHCM="+Integer.parseInt(StringTool.removeChar(request.getParameter("PCSHCM"),'/')));
		
		Vector disbPaymentDetailVec = null;
		DISBRemitExportDAO dao = null;
		try {
			dao = new DISBRemitExportDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY));
			disbPaymentDetailVec =  dao.query(PCSHCM, company); /*R60747 將出納日期PCSHDT改為出納確認日PCSHCM */
			//disbPaymentDetailVec =  dao.query(PCSHCM, company);
		} catch(Exception e) {
			System.err.println(e.toString());			
		}
		request.setAttribute("vo" , disbPaymentDetailVec);
	}

	private void download(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException, Exception {
		try {
			HttpSession session = request.getSession(true);
			String strLogonUser = (String) session.getAttribute(Constant.LOGON_USER_ID);
			RequestDispatcher dispatcher = null;
			DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
			Vector downfile = new Vector();
			String fileLOC = "";
			String BATNO = request.getParameter("para_PBATNO");

			//讀取目前所賣的幣別 t:外幣轉帳(聯行) r:外幣匯款(跨行)
			//R80300 新增信用卡下載  if(!BATNO.substring(0,1).equals("D"))
			if(BATNO.substring(0,1).equals("C"))
			{
				fileLOC= convertDownloadData(new DISBRemitExportDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY)).queryByBatNoC(BATNO,"NT","t"),"NT",BATNO,"t",strLogonUser);
				if (!fileLOC.equals(""))
					downfile.add(fileLOC);
			}
			else if (!BATNO.substring(0,1).equals("D"))
			{
				fileLOC= convertDownloadData(new DISBRemitExportDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY)).queryByBatNo(BATNO,"NT","t"),"NT",BATNO,"t",strLogonUser);
				if (!fileLOC.equals(""))
					downfile.add(fileLOC);
			}
			else
			{
				List alPCURR = new ArrayList();
				//R80338 alPCURR = (List) disbBean.getETable("PCURR", "");
				alPCURR = (List) disbBean.getETable("CURRA", "");  //R80338
				if (alPCURR.size() > 0) {
					for (int i = 0; i < alPCURR.size(); i++) {
						Hashtable htPBBankTemp = (Hashtable) alPCURR.get(i);
						String strETValue = (String) htPBBankTemp.get("ETValue");
						String strPAYCURR = strETValue.substring(0,2);
						//RE0189:新增凱基OIU。台新OIU的匯款及轉帳為同一檔案,且只有在台新境內DBU/OBU帳號才需產生,故只有使用queryByBatNo的t來查詢資料
						if(BATNO.substring(0,1).equals("D") 
								&& (BATNO.substring(8,11).equals("822") || 
										BATNO.substring(8,11).equals("009") || 
										BATNO.substring(8,11).equals("004") || 
										BATNO.substring(8,11).equals("017") || 
										BATNO.substring(8,11).equals("809"))) 
						{
							//D:外幣匯款,轉帳(同行相存,限RBK的SWIFT CODE第5及6碼為TW)
							fileLOC = convertDownloadData(new DISBRemitExportDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY)).queryByBatNo(BATNO,strPAYCURR,"t"),strPAYCURR,BATNO,"t",strLogonUser);
							if (!fileLOC.equals("")){
								downfile.add(fileLOC);
							}								
							//D:外幣匯款,跨行匯款
							fileLOC = convertDownloadData(new DISBRemitExportDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY)).queryByBatNo(BATNO,strPAYCURR,"r"),strPAYCURR,BATNO,"r",strLogonUser);
							if (!fileLOC.equals("")){
								downfile.add(fileLOC);
							}								
						} else {
							fileLOC = convertDownloadData(new DISBRemitExportDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY)).queryByBatNo(BATNO,strPAYCURR,"t"),strPAYCURR,BATNO,"t",strLogonUser);
							if (!fileLOC.equals(""))
								downfile.add(fileLOC);
						}
					}
				}
			}
			checkXlsFile( request, BATNO, downfile );
            request.setAttribute("downdatalist", downfile);
			request.setAttribute("txtAction", "downReturn");
			dispatcher = request.getRequestDispatcher("/DISB/DISBRemit/DISBRemitDownload.jsp");
			dispatcher.forward(request, response);
			return;
		} catch(Exception e) {
			e.printStackTrace();
			System.err.println(e.toString());			
	  	}
	}

	private void checkXlsFile( HttpServletRequest request, String BATNO, List fileList ) throws SQLException {
        String bankCode = BATNO.substring( 8, 11 );
        String bankName = "";
        boolean xlsFileExist = false;

        for( int i = 0 ; i < fileList.size() ; i++ ) {
            String fileLoc = (String) fileList.get(i);
            if( fileLoc.length() >= 4 ) {
                String suffix = fileLoc.substring( fileLoc.length() - 4 );
                if( suffix.equalsIgnoreCase( ".xls" ) ) {
                    xlsFileExist = true;
                    break;
                }
            }
        }

    	DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
    	bankName = disbBean.getETableDesc("BANK", bankCode);

        request.setAttribute("downloadBankCode", bankCode );
        request.setAttribute("downloadBankName", bankName );
        request.setAttribute("xlsFileExist", xlsFileExist ? "Y" : "N" );
	}

	private String convertDownloadData(Vector payments, String strPAYCURR, String BATNO,String remitKind,String strLogonUser) {
		String fileLOC = "";
		if(BATNO.substring(0,1).equals("D"))
		{
			fileLOC = convertDownloadDataD(payments, strPAYCURR, BATNO.substring(8,11),BATNO,remitKind,strLogonUser);
		}
		//R80300 信用卡新增匯款資料
		else if(BATNO.substring(0,1).equals("C")) 
		{
			fileLOC = convertDownloadDataC(payments, strPAYCURR, BATNO.substring(8,11),BATNO,remitKind,strLogonUser);			
		}
		else
		{
			if( BATNO.substring(8,11).equals("812")){
			    fileLOC = convertDownloadDataU(payments, strPAYCURR, BATNO.substring(8,11),BATNO,remitKind,strLogonUser);				
			}else{
			    fileLOC = convertDownloadDataB(payments, strPAYCURR, BATNO.substring(8,11),BATNO,remitKind,strLogonUser);
			}		
		}
		return fileLOC;
	}

	private String convertDownloadDataD(Vector payments, String SelCURR, String BKCode,String BATNO,String remitKind,String strLogonUser) {
		String fileLOC ="";
		//中國信託
		if(BKCode.equals("822")) {
			if (remitKind.equals("r"))
				fileLOC = convertDownloadData822r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			else
				fileLOC = convertDownloadData822t(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//第一銀行
		if(BKCode.equals("007")){
			fileLOC = convertDownloadData007(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//兆豐銀行
		if(BKCode.equals("017")){
			String payBank = "";
			/*try{
				CaprmtfVO rmtVOtmp = (CaprmtfVO) payments.get(0);
				payBank = rmtVOtmp.getPACCT();
			}catch(Exception e){
				
			}*/
			//RD0382:OIU
			if(remitKind.equals("r")){
				//跨行匯款,DISBRemitExportDAO.queryByBatNo()有判斷SWIFT CODE的第5及6碼不可為TW
				fileLOC = convertDownloadData017r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}else{
				//轉帳,同行相存(限匯款銀行SWIFT CODE的第5及6碼為TW)
				fileLOC = convertDownloadData017t(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}			
		}
		//新竹商銀
		if(BKCode.equals("052")){
			fileLOC = convertDownloadData052(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//永豐銀行
		if(BKCode.equals("807")){
			fileLOC = convertDownloadData807(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}		
		//R70574 台新銀行
		if(BKCode.equals("812")){
		    // R00386 外幣時改產生另一種格式的 XLS file
		    fileLOC = convertDownloadData812(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//R70574 華南銀行
		if(BKCode.equals("008")){
			fileLOC = convertDownloadData008(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//R80480 上海銀行
		if(BKCode.equals("011")){
		 	fileLOC = convertDownloadData011(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//R00566 元大銀行
		if(BKCode.equals("806")) {
			fileLOC = convertDownloadData806(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//R10059 安泰銀行
		if(BKCode.equals("816")) {
			fileLOC = convertDownloadData816(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//RB0062 彰化銀行
		if(BKCode.equals("009")) {
			if (remitKind.equals("r"))
				//匯款檔
				fileLOC = convertDownloadData009r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			else
				//轉帳檔
				fileLOC = convertDownloadData009t(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//EB0537 凱基(萬泰)銀行
		if(BKCode.equals("809")) {
			if(remitKind.equals("r")){
				//RE0189
				//匯款檔檔(新增,與兆豐layout相同),外幣付款,809-OBU --> 809-DBU (只要判斷受款帳戶是否為DBU)
				fileLOC = convertDownloadData809r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			} else {
				//轉帳檔(既有)
				//RE0189:外幣付款,只有809-OBU --> 809-OBU (只要判斷受款帳戶是否為OBU)才產生該檔案
				fileLOC = convertDownloadData809t(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}			
		}
		
		//RD0440 臺灣銀行
		if(BKCode.equals("004")) {
			
			if (remitKind.equals("r")){
				//匯款檔
				fileLOC = convertDownloadData004r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}else{
				//轉帳檔
				fileLOC = convertDownloadData004t(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}
		}

		return fileLOC;
	}

	private String convertDownloadDataB(Vector payments, String selCURR, String BKCode, String BATNO, String rKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[payments.size()][18];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO;
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);
			String custRemitId = "";
			// 收款人ID, x(11)空白
			for (int count = 0; count < 11; count++) {
				custRemitId += " ";
			}
			// SEQNO 轉檔序號X(6)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (6 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 匯款種類,x(2)
			String remitKind = rmtVO.getRTYPE();

			// 匯款行,x(7)
			String entBank = "";
			if (rmtVO.getRBK() != null && rmtVO.getRBK().length() >= 7) {
				entBank = rmtVO.getRBK().substring(0, 7);
			}
			for (int count = entBank.length(); count < 3; count++) {
				entBank = "0" + entBank;
			}
			// 金額x(13)
			//RC0036-3 
			String remitAmt = Integer.toString((int) rmtVO.getRAMT());
			//String remitAmt = Double.toString(rmtVO.getRAMT()); 
			
			if (remitAmt.indexOf(".") > 0) {// 處理"."
				remitAmt = remitAmt.substring(0, remitAmt.indexOf("."));
				// System.out.println( seqNo + ":" + remitAmt);
			}

			remitAmt += "00";// 999.00-->99900
			for (int count = remitAmt.length(); count < 13; count++) {
				remitAmt = "0" + remitAmt;
				// System.out.println(seqNo + ":" +remitAmt);
			}
			// 收款人帳號x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 收款人戶名x(80) 因為戶名為全形 所以entName.length()*2
			//QC0274String entName = rmtVO.getRNAME() != null ? rmtVO.getRNAME().trim() : "";// @R90735 FIX BUG
			String entName = (rmtVO.getRNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getRNAME()).toUpperCase();
			for (int count = entName.getBytes().length; count < 80; count++) {
				entName = entName + " ";
			}
			// 匯款人ID x(11)
			String custId = "70817744";
			for (int count = custId.length(); count < 11; count++) {
				custId += " ";
			}
			// 匯款人電話及區馬x(10)
			String custPhoneNo = "0225068800";// @R90735 更換公司代表號
			// 匯款人姓名x(80)
			String custName = "全球人壽保險股份有限公司";
			for (int count = custName.length() * 2; count < 80; count++) {
				custName += " ";
			}
			// 附言x(80)
			String memo = rmtVO.getRMEMO() != null ? toFullChar(rmtVO.getRMEMO().replace('　', ' ').trim()) : "";// R90735 FIX BUG
			if (memo.startsWith("萬通系統資料")) {
				memo = "";
			}
			for (int count = memo.getBytes().length; count < 80; count++) {
				memo += " ";
			}
			// 匯款日期x(6)
			String remitDate = rmtVO.getRMTDT();
			// R00231 edit by Leo Huang
			if (remitDate.length() > 6) {
				remitDate = remitDate.substring(1);
			}
			// R00231 edit by Leo Huang
			for (int count = remitDate.length(); count < 6; count++) {
				remitDate = "0" + remitDate;
			}
			// 交易檢核馬x(4)
			String chkCode = rmtVO.getRTRNCDE();
			for (int count = chkCode.length(); count < 4; count++) {
				chkCode += " ";
			}
			// 傳送次數x(3)
			String submitCount = rmtVO.getRTRNTM();
			for (int count = submitCount.length(); count < 3; count++) {
				submitCount += " ";
			}
			// 客戶傳票號碼x(10)
			String processNo = rmtVO.getCSTNO();
			for (int count = processNo.length(); count < 10; count++) {
				processNo += " ";
			}

			// 匯費負擔區別馬x(1)
			String remitFeeCode = " ";
			// filler x(2)
			String filler = "  ";

			downloadInfo[index][0] = custRemitId;// 收款人ID, x(11)空白
			downloadInfo[index][1] = seqNo;// SEQNO 轉檔序號,
			downloadInfo[index][2] = remitKind;// 匯款種類,
			downloadInfo[index][3] = entBank;// ,?款行 匯款行,
			downloadInfo[index][4] = remitAmt;// 金額9(11)
			downloadInfo[index][5] = "2";// 摘要
			downloadInfo[index][6] = entAccountNo;// 收款人帳號
			downloadInfo[index][7] = entName;// 收款人戶名
			downloadInfo[index][8] = custId;// 匯款人ID
			downloadInfo[index][9] = custPhoneNo;// 匯款人電話及區馬
			downloadInfo[index][10] = custName;// 匯款人姓名
			downloadInfo[index][11] = memo;// 附言
			downloadInfo[index][12] = remitDate;// 匯款日期
			downloadInfo[index][13] = chkCode;// 交易檢核馬
			downloadInfo[index][14] = submitCount;// 傳送次數
			downloadInfo[index][15] = processNo;// 客戶傳票號碼
			downloadInfo[index][16] = remitFeeCode;// 匯費負擔區別馬
			downloadInfo[index][17] = filler;// filler

		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, rKind, strLogonUser);
		return fileLOC;
	}

	//RC0036
	private String convertDownloadDataU(Vector payments, String SelCURR, String BKCode, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC ="";
		//台新銀行
		if(BKCode.equals("812")) {
			if  (BATNO.substring(0,1).equals("B")){
				fileLOC = convertDownloadData812B(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}else{
				fileLOC = convertDownloadData812E(payments,SelCURR,BATNO,remitKind,strLogonUser);		
			}
		}	
		return fileLOC;
	}
	
    //RC0036	
	private String convertDownloadData812B(Vector payments, String selCURR, String BATNO, String rKind, String strLogonUser) {
		
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 1)][26];
		DecimalFormat df = new DecimalFormat("0000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		double saveAmt = 0;
		double saveBankfee = 0;
		double remitAmtD = 0;
		String remitAmtS = "";
		int saveCount = 0;
		String saveRMDT = "";
		String savePACCT = "";
		double saveAmtT = 0;
		double saveBankfeeT = 0;	
		int finalBankfee = 0;	
		int finalsaveAmt = 0;	
		
		String strSql = "SELECT * FROM BANKFEE WHERE FLD003 <= ? AND FLD004 >= ? ";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbFactory.getAS400Connection("DISBRemitExportServlet.convertDownloadData812B");
			pstmt = con.prepareStatement(strSql);
		} catch(SQLException ex) {
			System.err.println(ex.getMessage());
		}
		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			saveCount = index + 1;
			saveRMDT = rmtVO.getRMTDT();
              
			//收款行庫代號
			String RBKO = rmtVO.getRBK();
			String RBK = RBKO.substring(0,6);
			for (int count = RBK.length(); count < 6; count++) {
				RBK = RBK + " ";
			}
			// 匯款金額9(11)v99
			remitAmtD = rmtVO.getRAMT();
			remitAmtS = rmtVO.getRAMTS();//RC0036-3
			saveAmt = saveAmt + remitAmtD;
			//RC0036-3 String remitAmt = String.valueOf(rmtVO.getRAMT());	
			String remitAmt = remitAmtS;//RC0036-3 
			if (remitAmt.indexOf(".") > 0) {
				remitAmt = remitAmt.substring(0, remitAmt.indexOf("."));
			}
			remitAmt += "00";
			for(int counter=remitAmt.length(); counter<13; counter++) {
				remitAmt = "0" + remitAmt;
			}
			
			// 手續費
			double Bankfee = 0;
			try {
				   pstmt.clearParameters();
				   pstmt.setDouble(1, remitAmtD);
				   pstmt.setDouble(2, remitAmtD);
				   rs = pstmt.executeQuery();
				   if(rs.next()) {
					  Bankfee = rs.getDouble("FLD006");
				   }	
				   if (RBKO.substring(0,3).equals(rmtVO.getPBK().substring(0,3))) Bankfee = 0 ;
			} catch(SQLException ex) {
				    System.err.println(ex.getMessage());
			}
			String BankfeeT = String.valueOf(Bankfee);	
			saveBankfee = saveBankfee + Bankfee;
			if (BankfeeT.indexOf(".") > 0) {
				BankfeeT = BankfeeT.substring(0, BankfeeT.indexOf("."));
			}
			
			for(int counter=BankfeeT.length(); counter<5; counter++) {
				BankfeeT = "0" + BankfeeT;
			}

			// 收款人帳號x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 14; count++) {
			     entAccountNo = "0" + entAccountNo;
			}
			// 收款人名稱 x(30)
			//QC0274String entNameT = rmtVO.getRNAME() != null ? rmtVO.getRNAME().trim() : "";
			String entNameT = (rmtVO.getRNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getRNAME()).toUpperCase();
			for (int count = entNameT.getBytes().length; count < 30; count++) {
				entNameT = entNameT + " ";
			}

			// 附言(全球人壽)
			String note = "全球人壽";
			for (int count = note.length(); count < 36; count++) {
				note = note + " ";
			}
	    	// 備註
			String fillerN = "";
			for (int count = fillerN.length(); count < 9; count++) {
				fillerN = "0" + fillerN ;
			}
			// 保留欄位D
			String fillerD = "";
			for (int count = fillerD.length(); count < 33; count++) {
				fillerD = fillerD + " ";
			}
			
			//downloadInfo[index + 1][0] = "50"; // INDICATOR
			downloadInfo[index + 1][0] = RBK; // 收款行庫代號
			downloadInfo[index + 1][1] = remitAmt; // 匯款金額
			downloadInfo[index + 1][2] = BankfeeT; // 單筆手續費
			downloadInfo[index + 1][3] = entAccountNo;// 收款人帳號
			downloadInfo[index + 1][4] = entNameT; // 收款人名稱
			downloadInfo[index + 1][5] = note; // 附言
			downloadInfo[index + 1][6] = fillerN; // 備註
			downloadInfo[index + 1][7] = fillerD; // 保留欄位
			downloadInfo[index + 1][8] = "0";  // 記錄結束標記
			for (int i = 9; i < 26; i++) {
				downloadInfo[index + 1][i] = "";
			}
		}
		// -----HEADER-----
		String strRMDT = null;
		if (saveRMDT.trim().length() < 8) {
			strRMDT = "0" + saveRMDT; 
		} else {
			strRMDT = saveRMDT;		
		}
		// 匯款總額
		finalsaveAmt = (int) saveAmt;
		String totAmt = String.valueOf(finalsaveAmt);
		if (totAmt.indexOf(".") > 0) {
			totAmt = totAmt.substring(0, totAmt.indexOf("."));
		}
		totAmt += "00";
		for(int counter=totAmt.length(); counter<13; counter++) {
			totAmt = "0" + totAmt;
		}

		// 明細筆數
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (7 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// 手續費總額
		finalBankfee = (int) saveBankfee;
		String totBankfee = String.valueOf(finalBankfee);
		for (int count = 0; count < (6 - String.valueOf(finalBankfee).length()); count++) {
			totBankfee = "0" + totBankfee;
		}
		// 匯款人姓名
		String strNM = "全球人壽保險股份有限公司";
		for (int count = strNM.length() * 2; count < 30; count++) {
			strNM += " ";
		}
		// 保留欄位 x(64)
		String fillerH = "";
		for (int count = fillerH.length(); count < 64; count++) {
			fillerH = fillerH + " ";
		}
		
		downloadInfo[0][0] = "1";  // 碼別
		downloadInfo[0][1] = "0660"; // 企業編號
		downloadInfo[0][2] = "06120001666600"; // 委辦帳號	                         
		downloadInfo[0][3] = strRMDT; // 預定匯款日期
		downloadInfo[0][4] = "820";// 轉帳項目
		downloadInfo[0][5] = totAmt; //  匯款總額
		downloadInfo[0][6] = totCount; // 匯款筆數
		downloadInfo[0][7] = strNM; // 匯款人姓名
		downloadInfo[0][8] = totBankfee; // 手續費總金額
		downloadInfo[0][9] = fillerH; // 保留欄位
		downloadInfo[0][10] = "0";  // 記錄結束標記
		for (int i = 11; i < 26; i++) {
			downloadInfo[0][i] = "";
		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, rKind, strLogonUser);
		return fileLOC;
	}
	
	
	//RC0036	
	private String convertDownloadData812E(Vector payments, String selCURR,String BATNO, String rKind, String strLogonUser) {

		
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 1)][26];
		DecimalFormat df = new DecimalFormat("0000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		double saveAmt = 0;
		double saveBankfee = 0;
		double remitAmtD = 0;
		String remitAmtS = ""; //RC0036-3
		int saveCount = 0;
		String saveRMDT = "";
		String savePACCT = "";
		double saveAmtT = 0;
		double saveBankfeeT = 0;	
		int finalBankfee = 0;	
		int finalsaveAmt = 0;	
		
		String strSql = "SELECT * FROM BANKFEE WHERE FLD003 <= ? AND FLD004 >= ? ";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbFactory.getAS400Connection("DISBRemitExportServlet.convertDownloadData812B");
			pstmt = con.prepareStatement(strSql);
		} catch(SQLException ex) {
			System.err.println(ex.getMessage());
		}
		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			 rmtVO = (CaprmtfVO) payments.get(index);

			saveCount = index + 1;
			saveRMDT = rmtVO.getRMTDT();
              
			//收款行庫代號
			String RBKO = rmtVO.getRBK();
			String RBK = RBKO.substring(0,6);
			for (int count = RBK.length(); count < 6; count++) {
				RBK = RBK + " ";
			}
			// 匯款金額x(13)
			remitAmtD = rmtVO.getRAMT();
			remitAmtS = rmtVO.getRAMTS();//RC0036-3
			saveAmt = saveAmt + remitAmtD;
			//RC0036-3 String remitAmt = String.valueOf(rmtVO.getRAMT());	
			String remitAmt = remitAmtS;//RC0036-3
			if (remitAmt.indexOf(".") > 0) {
				remitAmt = remitAmt.substring(0, remitAmt.indexOf("."));
			}
			remitAmt += "00";
			for(int counter=remitAmt.length(); counter<13; counter++) {
				remitAmt = "0" + remitAmt;
			}
			
			// 手續費
			double Bankfee = 0;
			try {
				   pstmt.clearParameters();
				   pstmt.setDouble(1, remitAmtD);
				   pstmt.setDouble(2, remitAmtD);
				   rs = pstmt.executeQuery();
				   if(rs.next()) {
					  Bankfee = rs.getDouble("FLD006");
				   }
				   if (RBKO.substring(0,3).equals(rmtVO.getPBK().substring(0,3))) Bankfee = 0 ;
			} catch(SQLException ex) {
				    System.err.println(ex.getMessage());
			}
			String BankfeeT = String.valueOf(Bankfee);	
			saveBankfee = saveBankfee + Bankfee;
			if (BankfeeT.indexOf(".") > 0) {
				BankfeeT = BankfeeT.substring(0, BankfeeT.indexOf("."));
			}
			
			for(int counter=BankfeeT.length(); counter<5; counter++) {
				BankfeeT = "0" + BankfeeT;
			}
						
			// 收款人帳號x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 14; count++) {
			     entAccountNo = "0" + entAccountNo;
			}
			// 收款人名稱 x(30)
			//QC0274String entNameT = rmtVO.getRNAME() != null ? rmtVO.getRNAME().trim() : "";
			String entNameT = (rmtVO.getRNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getRNAME()).toUpperCase();
			//RC0036-3 for (int count = entNameT.getBytes().length; count < 31; count++) {
			for (int count = entNameT.getBytes().length; count < 30; count++) {
			     entNameT = entNameT + " ";
			}

			// 附言(全球人壽)
			String note = "全球人壽";
			for (int count = note.length(); count < 36; count++) {
				note = note + " ";
			}

			// 備註
			String fillerN = "";
			for (int count = fillerN.length(); count < 9; count++) {
				fillerN = "0" + fillerN ;
			}
			// 保留欄位D
			String fillerD = "";
			//RC0036-3 for (int count = fillerD.length(); count < 32; count++) {
            for (int count = fillerD.length(); count < 33; count++) {
			     fillerD = fillerD + " ";
			}

			downloadInfo[index + 1][0] = RBK; // 收款行庫代號
			downloadInfo[index + 1][1] = remitAmt; // 匯款金額
			downloadInfo[index + 1][2] = BankfeeT; // 單筆手續費
			downloadInfo[index + 1][3] = entAccountNo;// 收款人帳號
			downloadInfo[index + 1][4] = entNameT; // 收款人名稱
			downloadInfo[index + 1][5] = note; // 附言
			downloadInfo[index + 1][6] = fillerN; // 備註
			downloadInfo[index + 1][7] = fillerD; // 保留欄位
			downloadInfo[index + 1][8] = "0";  // 記錄結束標記
			//RC0036-3 for (int i = 11; i < 26; i++) {
            for (int i = 9; i < 26; i++) {
			downloadInfo[index + 1][i] = "";
			}
		}
		// -----HEADER-----
		String strRMDT = null;
		if (saveRMDT.trim().length() < 8) {
			strRMDT = "0" + saveRMDT; 
		} else {
			strRMDT = saveRMDT;		
		}
		// 匯款總額
		finalsaveAmt = (int) saveAmt;
		String totAmt = String.valueOf(finalsaveAmt);
		if (totAmt.indexOf(".") > 0) {
			totAmt = totAmt.substring(0, totAmt.indexOf("."));
		}
		totAmt += "00";
		for(int counter=totAmt.length(); counter<13; counter++) {
			totAmt = "0" + totAmt;
		}

 		// 明細筆數
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (7 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// 手續費總額
		finalBankfee = (int) saveBankfee;
		String totBankfee = String.valueOf(finalBankfee);
		for (int count = 0; count < (6 - String.valueOf(finalBankfee).length()); count++) {
			totBankfee = "0" + totBankfee;
		}
		// 匯款人姓名
		String strNM = "全球人壽保險股份有限公司";
		//RC0036-3 for (int count = strNM.length() * 2; count < 32; count++) {
		for (int count = strNM.length() * 2; count < 30; count++) {
     		strNM += " ";
		}
		// 保留欄位 x(64)
		String fillerH = "";
		for (int count = fillerH.length(); count < 64; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "1";  // 碼別
		downloadInfo[0][1] = "0660"; // 企業編號
		downloadInfo[0][2] = "06120001666600"; // 委辦帳號
		downloadInfo[0][3] = strRMDT; // 預定匯款日期
		downloadInfo[0][4] = "820";// 轉帳項目
		//RC0036-3 downloadInfo[0][5] = totAmt.substring(0, 11); //  匯款總額
		downloadInfo[0][5] = totAmt; //  匯款總額
		downloadInfo[0][6] = totCount; // 匯款筆數
		downloadInfo[0][7] = strNM; // 匯款人姓名
		downloadInfo[0][8] = totBankfee; // 手續費總金額
		//RC0036-3 downloadInfo[0][9] = fillerH+"  "; // 保留欄位
		downloadInfo[0][9] = fillerH; // 保留欄位
		downloadInfo[0][10] = "0";  // 記錄結束標記
		for (int i = 11; i < 26; i++) {
			downloadInfo[0][i] = "";
		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, rKind, strLogonUser);
		return fileLOC;
	}
	
	//R90735 半型轉全型英文
	private String toFullChar(String s) {
		if ( s == null || s.equals("")){
	  		return "";
		}
    
		char[] ca = s.toCharArray();
    
		for(int i = 0 ; i < ca.length; i++){
	  		if(ca[i] > '\200') continue;   
    
	 	 	if(ca[i] == 32){    
	 	 		ca[i] = (char)12288;        
	 	 		continue;                  
	 	 	} 
	  
	 	 	if(Character.isLetterOrDigit(ca[i])){   
				ca[i] = (char)(ca[i] + 65248); 
				continue;  
	  		}  
	  		ca[i] = (char)12288; 
		}
    	return String.valueOf(ca);
   }
   
	// R80300 信用卡新增下載檔案
	private String convertDownloadDataC(Vector payments, String selCURR, String BKCode, String BATNO, String rKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[payments.size() + 2][29];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		DISBPaymentDetailVO paymetVO;
		DecimalFormat df = new DecimalFormat("0000000000.00");
		double saveAmt = 0;
		int saveCount = 0;

		for (int index = 0; index < payments.size(); index++) {
			paymetVO = (DISBPaymentDetailVO) payments.get(index);
			saveCount = index + 1;

			// 卡號x(19)
			String crdNO = paymetVO.getStrPCrdNo();
			for (int count = crdNO.length(); count < 19; count++) {
				crdNO = crdNO + " ";
			}
			// 卡片到期日x(4)
			String crdEFFYM = paymetVO.getStrPCrdEffMY() == null ? "" : paymetVO.getStrPCrdEffMY();
			if (!crdEFFYM.equals("")) {
				crdEFFYM = paymetVO.getStrPCrdEffMY().substring(0, 2) + paymetVO.getStrPCrdEffMY().substring(4, 6);
			}
			for (int count = crdEFFYM.length(); count < 4; count++) {
				crdEFFYM = crdEFFYM + " ";
			}
			// 授權碼x(6)
			String authcode = paymetVO.getStrPAuthCode();
			for (int count = authcode.length(); count < 6; count++) {
				authcode = authcode + " ";
			}
			// 交易金額x(12)
			String remitAmtT = df.format(paymetVO.getIPAMT());
			String remitAmt = remitAmtT.substring(0, 10) + remitAmtT.substring(11, 13);
			saveAmt = disbBean.DoubleAdd(saveAmt, paymetVO.getIPAMT());
			// 交易日x(8)
			String remitDT = Integer.toString((int) paymetVO.getIPCshDt());
			for (int count = remitDT.length(); count < 8; count++) {
				remitDT = "0" + remitDT;
			}
			String strRMDTTemp = Integer.toString(1911 + Integer.parseInt(remitDT.substring(0, 4))) + remitDT.substring(4, 6) + remitDT.substring(6, 8);
			// 備註x(60)
			String remark = paymetVO.getStrPNO();
			for (int count = remark.length(); count < 60; count++) {
				remark = remark + " ";
			}
			// filler1
			String filler1 = "";
			for (int count = filler1.length(); count < 40; count++) {
				filler1 = filler1 + " ";
			}
			// filler2
			String filler2 = "";
			for (int count = filler2.length(); count < 83; count++) {
				filler2 = filler2 + " ";
			}

			downloadInfo[index][0] = "D"; // 資料類別 X1
			downloadInfo[index][1] = "06"; // 交易類別 X2
			downloadInfo[index][2] = "000812000104576";// 特店代碼 X15
			downloadInfo[index][3] = "6300"; // 特店類代碼 X4
			downloadInfo[index][4] = crdNO; // 卡片號碼 X19
			downloadInfo[index][5] = crdEFFYM; // 有效年日 X4 YYMM
			downloadInfo[index][6] = remitAmt; // 金額 10V2
			downloadInfo[index][7] = "00"; // 授權回應碼 X2
			downloadInfo[index][8] = authcode; // 授權碼 X6
			downloadInfo[index][9] = strRMDTTemp; // 交易日期 X8 YYYYMMDD
			downloadInfo[index][10] = " "; // SSL/ SET flag X1
			downloadInfo[index][11] = "   "; // 卡片驗證碼 X3
			downloadInfo[index][12] = filler1; // SET XID X40
			downloadInfo[index][13] = remark; // 備註 X60
			downloadInfo[index][14] = "02"; // 交易種類 X2
			downloadInfo[index][15] = "              "; // Store ID X14
			downloadInfo[index][16] = "            "; // Cash Rebate Order Code X12
			downloadInfo[index][17] = "0000000"; // Discount Rebate 7
			downloadInfo[index][18] = "000000000000"; // Discount Amount 10V2
			downloadInfo[index][19] = "000000000000"; // Actual Cost 10V2
			downloadInfo[index][20] = "0000000"; // Rebate 7
			downloadInfo[index][21] = "00"; // Installment Period 2
			downloadInfo[index][22] = "000000000000"; // Installment OrderNo X12
			downloadInfo[index][23] = "000000000000"; // First Period Amount 10V2
			downloadInfo[index][24] = "000000000000"; // Period Amount 10V2
			downloadInfo[index][25] = "000000000000"; // Process Fee 10V2
			downloadInfo[index][26] = "000000000000"; // First Period Process Fee 10V2
			downloadInfo[index][27] = "000000000000"; // Period Process Fee 10V2
			downloadInfo[index][28] = filler2; // filler X83
		}
		// -----Subtotal Record-----
		// 匯款總額
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 10) + totAmtT.substring(11, 13);
		// 明細筆數
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (6 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		downloadInfo[saveCount][0] = "S"; // 資料類別
		downloadInfo[saveCount][1] = "000812000104576";// 主特店代碼
		downloadInfo[saveCount][2] = "000000"; // 銷貨資料筆數
		downloadInfo[saveCount][3] = "000000000000"; // 銷貨資料金額
		downloadInfo[saveCount][4] = totCount; // 退貨資料筆數
		downloadInfo[saveCount][5] = totAmt; // 退貨資料金額
		for (int i = 6; i < 29; i++) {
			downloadInfo[saveCount][i] = "";
		}

		// -----Trail Record (同Subtotal)-----
		downloadInfo[saveCount + 1][0] = "T"; // 資料類別
		downloadInfo[saveCount + 1][1] = "000812000104576";// 主特店代碼
		downloadInfo[saveCount + 1][2] = "000000"; // 銷貨資料筆數
		downloadInfo[saveCount + 1][3] = "000000000000"; // 銷貨資料金額
		downloadInfo[saveCount + 1][4] = totCount; // 退貨資料筆數
		downloadInfo[saveCount + 1][5] = totAmt; // 退貨資料金額
		for (int i = 6; i < 29; i++) {
			downloadInfo[saveCount + 1][i] = "";
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, rKind, strLogonUser);
		return fileLOC;
	}

	// R60550 外幣檔案下載(中信外幣匯款)
	private String convertDownloadData822r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 1)][27];
		DecimalFormat df = new DecimalFormat("0000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		double saveAmt = 0;
		int saveCount = 0;
		String saveRMDT = "";
		String savePACCT = "";
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);// R80132
		double saveAmtT = 0;// R70455

		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// SAVE AREA
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() - rmtVO.getRPAYAMT();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			// R70574 saveAmt += remitAmtNum;
			saveCount = index + 1;
			saveRMDT = rmtVO.getRMTDT();
			savePACCT = rmtVO.getPACCT();

			// 2.SEQNO 明細序號X(5)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (5 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 3.匯款幣別,X(3)
			String remitCURR = payCURR;
			for (int count = remitCURR.length(); count < 3; count++) {
				remitCURR = remitCURR + " ";
			}
			// 4.匯款金額x(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 13) + remitAmtT.substring(14, 16);
			// R70574 匯款金額加總
			// R70455 saveAmt += Float.parseFloat(remitAmtT);
			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);// R70455
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);// R70455

			// 5.受益人帳號x(35)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 35; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 6.收款銀行SWIFT x(11)
			String remitSWIFTT = rmtVO.getSWIFTCODE() == null ? "" : rmtVO.getSWIFTCODE();
			String remitSWIFT = remitSWIFTT.trim();
			for (int count = remitSWIFT.length(); count < 11; count++) {
				remitSWIFT = remitSWIFT + " ";
			}
			// 7.收款銀行名稱 x(35)
			// 8.收款銀行名稱或地址2 x(35)
			// 9.收款銀行地址3 x(35)
			// 10.收款銀行地址4 x(35)
			String entBank1 = "";
			String entBank2 = "";
			String entBank3 = "";
			String entBank4 = "";
			String entBknameT = "";
			String entBkaddrT = "";
			for (int count = entBknameT.length(); count < 70; count++) {
				entBknameT = entBknameT + " ";
			}
			for (int count = entBkaddrT.length(); count < 150; count++) {
				entBkaddrT = entBkaddrT + " ";
			}

			// R80338 if (entBknameT.trim().length()<35) {
			if (entBknameT.trim().length() < 36) { // R80338
				entBank1 = entBknameT.substring(0, 35);
				entBank2 = entBkaddrT.substring(0, 35);
				entBank3 = entBkaddrT.substring(35, 70);
				entBank4 = entBkaddrT.substring(70, 105);
			} else {
				entBank1 = entBknameT.substring(0, 35);
				entBank2 = entBknameT.substring(35, 70);
				entBank3 = entBkaddrT.substring(0, 35);
				entBank4 = entBkaddrT.substring(35, 70);
			}
			// 11.受益人名稱 x(35)
			// 12.受益人名稱2 x(35)
			//QC0274
			//String entNameT = rmtVO.getPENGNAME() == null ? "" : rmtVO.getPENGNAME();
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			for (int count = entNameT.length(); count < 70; count++) {
				entNameT = entNameT + " ";
			}
			String entName1 = entNameT.substring(0, 35);
			String entName2 = entNameT.substring(35, 70);
			// 13.受益人地址3 x(35)
			String entName3 = "";
			for (int count = entName3.length(); count < 35; count++) {
				entName3 = entName3 + " ";
			}
			// 14.受益人地址4 x(35)
			String entName4 = "";
			for (int count = entName4.length(); count < 35; count++) {
				entName4 = entName4 + " ";
			}
			// 15.附言1 x(35)
			String note1 = "";
			for (int count = note1.length(); count < 35; count++) {
				note1 = note1 + " ";
			}
			// 16.附言2 x(35)
			String note2 = "";
			for (int count = note2.length(); count < 35; count++) {
				note2 = note2 + " ";
			}
			// 17.附言3 x(35)
			String note3 = "";
			for (int count = note3.length(); count < 35; count++) {
				note3 = note3 + " ";
			}
			// 18.附言4 x(35)
			String note4 = "";
			for (int count = note4.length(); count < 35; count++) {
				note4 = note4 + " ";
			}
			// 19.匯款性質 x(03)
			// R70088 String rmtFUND = "129";從129->693 960502 中信要求
			String rmtFUND = "693";
			// 20.受款國別代碼 x(02)
			String rmtCountry = remitSWIFT.substring(4, 6);
			for (int count = rmtCountry.length(); count < 2; count++) {
				rmtCountry = rmtCountry + " ";
			}
			// 21.供應商代號 x(20)
			String rmtVendor = "";
			for (int count = rmtVendor.length(); count < 20; count++) {
				rmtVendor = rmtVendor + " ";
			}
			// 22.受款人email x(50)
			String rmtEmail = "";
			for (int count = rmtEmail.length(); count < 50; count++) {
				rmtEmail = rmtEmail + " ";
			}
			// 23.是否加發202 "Y"表示需加發 x(01)
			String rmtExtra = "Y";
			// 24.收款行之存同行SWIFT代碼 x(11)
			String remitSWIFT2 = "";
			for (int count = remitSWIFT2.length(); count < 11; count++) {
				remitSWIFT2 = remitSWIFT2 + " ";
			}
			// 25.收費別 x(03)
			String remitFEEWAY = rmtVO.getRPAYFEEWAY();
			for (int count = remitFEEWAY.length(); count < 3; count++) {
				remitFEEWAY = remitFEEWAY + " ";
			}
			// 26.交易性質註記 x(02)
			// RD0020中國信託匯款檔新增交易性質註記固定給空S
			String remitTXNOTE = " S";
			
			// 27.保留欄位 x(20)
			String fillerD = "";
			for (int count = fillerD.length(); count < 20; count++) {
				fillerD = fillerD + " ";
			}

			downloadInfo[index + 1][0] = "D"; // 表明細資料
			downloadInfo[index + 1][1] = seqNo; // SEQNO 轉檔序號,
			downloadInfo[index + 1][2] = remitCURR; // 匯款幣別,
			downloadInfo[index + 1][3] = remitAmt; // 匯款金額,
			downloadInfo[index + 1][4] = entAccountNo;// 受益人帳號,
			downloadInfo[index + 1][5] = remitSWIFT; // 收款銀行SWIFT,
			downloadInfo[index + 1][6] = entBank1; // 收款銀行名稱1,
			downloadInfo[index + 1][7] = entBank2; // 收款銀行名稱2,
			downloadInfo[index + 1][8] = entBank3; // 收款銀行地址3,
			downloadInfo[index + 1][9] = entBank4; // 收款銀行地址4,
			downloadInfo[index + 1][10] = entName1; // 受益人名稱1,
			downloadInfo[index + 1][11] = entName2; // 受益人名稱2,
			downloadInfo[index + 1][12] = entName3; // 受益人地址3,
			downloadInfo[index + 1][13] = entName4; // 受益人地址4,
			downloadInfo[index + 1][14] = note1; // 附言1 ,
			downloadInfo[index + 1][15] = note2; // 附言2 ,
			downloadInfo[index + 1][16] = note3; // 附言3 ,
			downloadInfo[index + 1][17] = note4; // 附言4 ,
			downloadInfo[index + 1][18] = rmtFUND; // 匯款性質,
			downloadInfo[index + 1][19] = rmtCountry; // 受款國別代碼,
			downloadInfo[index + 1][20] = rmtVendor; // 供應商代號,
			downloadInfo[index + 1][21] = rmtEmail; // 受款人email,
			downloadInfo[index + 1][22] = rmtExtra; // 是否加發202 "Y"表示需加發,
			downloadInfo[index + 1][23] = remitSWIFT2;// 收款行之存同行SWIFT代碼,
			downloadInfo[index + 1][24] = remitFEEWAY;// 收費別,
			downloadInfo[index + 1][25] = remitTXNOTE;// 交易性質註記,
			downloadInfo[index + 1][26] = fillerD; // 保留欄位
		}
		// -----HEAD-----
		// 客戶統編
		String custID = "70817744";
		for (int count = custID.length(); count < 12; count++) {
			custID += " ";
		}
		// 匯款日期
		String strRMDTTemp = null;
		String strRMDTTemp1 = null;
		if (saveRMDT.trim().length() < 7) {
			strRMDTTemp = "0" + saveRMDT; // 990505
		} else {
			strRMDTTemp = saveRMDT;		// 1000131
		}
		// 匯款日期年只取兩碼000225
		strRMDTTemp1 = Integer.toString(1911 + Integer.parseInt(strRMDTTemp.substring(0, 3))) + strRMDTTemp.substring(3, 5) + strRMDTTemp.substring(5, 7);

		// R00231 edit by Leo Huang
		// 與本行約定之扣款帳號
		String custACCT = savePACCT;
		if (custACCT.length() > 12)
			custACCT = custACCT.substring(0, 12);
		for (int count = custACCT.length(); count < 12; count++) {
			custACCT += " ";
		}
		// 匯款總額
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 13) + totAmtT.substring(14, 16);
		// 明細筆數
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (5 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// 保留欄位 x(50)
		String fillerH = "";
		for (int count = fillerH.length(); count < 50; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "H"; // 表匯總資料
		downloadInfo[0][1] = "BR"; // 交易總類,
		downloadInfo[0][2] = "DBU"; // DBU/OBU
		downloadInfo[0][3] = custID; // 客戶統編
		downloadInfo[0][4] = strRMDTTemp1;// 匯款日期
		downloadInfo[0][5] = custACCT; // 與本行約定之扣款帳號
		downloadInfo[0][6] = payCURR; // 匯款幣別
		downloadInfo[0][7] = totAmt; // 匯款總額
		downloadInfo[0][8] = totCount; // 明細筆數
		downloadInfo[0][9] = fillerH; // 保留欄位
		for (int i = 10; i < 27; i++) {
			downloadInfo[0][i] = "";
		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}// R60550 END 

	// R70088 外幣檔案下載(中信外幣轉帳)
	private String convertDownloadData822t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 1)][11];
		DecimalFormat df = new DecimalFormat("0000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		double saveAmt = 0;
		double saveAmtT = 0;// R70455
		int saveCount = 0;
		String saveRMDT = "";
		String savePACCT = "";
		// R80132 String payCURR= disbBean.getCurr(selCURR,1);//幣別 2碼轉為3碼
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);// R80132

		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// SAVE AREA
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() - rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			// R70574 saveAmt += remitAmtNum;
			saveCount = index + 1;
			saveRMDT = rmtVO.getRMTDT();
			savePACCT = rmtVO.getPACCT();

			// 2.SEQNO 明細序號X(5)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (5 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 3.受款人ID, x(12)空白
			String custRemitId = rmtVO.getRID();
			;
			for (int count = custRemitId.length(); count < 12; count++) {
				custRemitId += " ";
			}
			// 4.受益人帳號x(12)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 12)
				entAccountNo = entAccountNo.substring(0, 12);
			for (int count = entAccountNo.length(); count < 12; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 6.匯款金額x(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 13)
					+ remitAmtT.substring(14, 16);
			// R70574 匯款金額加總
			// R70455 saveAmt += Float.parseFloat(remitAmtT);
			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);// R70455
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);// R70455

			// 7.供應商代號 x(20)
			String rmtVendor = "";
			for (int count = rmtVendor.length(); count < 20; count++) {
				rmtVendor = rmtVendor + " ";
			}
			// 8.供應商email x(30)
			String fillerD = "";
			for (int count = fillerD.length(); count < 30; count++) {
				fillerD = fillerD + " ";
			}
			// 9.供應商email x(20)
			String rmtEmail1 = "";
			for (int count = rmtEmail1.length(); count < 20; count++) {
				rmtEmail1 = rmtEmail1 + " ";
			}
			// 10.保留欄位 x(32)
			String rmtEmail2 = "";
			for (int count = rmtEmail2.length(); count < 32; count++) {
				rmtEmail2 = rmtEmail2 + " ";
			}

			downloadInfo[index + 1][0] = "D"; // 表明細資料
			downloadInfo[index + 1][1] = seqNo; // SEQNO 轉檔序號,
			downloadInfo[index + 1][2] = custRemitId; // 受款人id,
			downloadInfo[index + 1][3] = entAccountNo; // 入帳帳號,
			downloadInfo[index + 1][4] = payCURR; // 入帳幣別
			downloadInfo[index + 1][5] = remitAmt; // 入帳金額
			downloadInfo[index + 1][6] = rmtVendor; // 供應商代號,
			downloadInfo[index + 1][7] = rmtEmail1; // 供應商email,
			downloadInfo[index + 1][8] = rmtEmail2; // 供應商email,
			downloadInfo[index + 1][9] = fillerD; // 保留欄位
			downloadInfo[index + 1][10] = ""; // 保留欄位
		}
		// -----HEAD-----
		// 客戶統編
		String custID = "70817744";
		for (int count = custID.length(); count < 12; count++) {
			custID += " ";
		}
		// 匯款日期
		String strRMDTTemp = null;
		// R00231 Leo Huang
		if (saveRMDT.length() < 7)
			strRMDTTemp = "0" + saveRMDT;
		else
			strRMDTTemp = saveRMDT;

		String strRMDTTemp1 = Integer.toString(1911 + Integer.parseInt(strRMDTTemp.substring(0, 3))) + strRMDTTemp.substring(3, 5) + strRMDTTemp.substring(5, 7);

		// R00231 Leo Huang
		// 與本行約定之扣款帳號
		String custACCT = savePACCT;
		if (custACCT.length() > 12)
			custACCT = custACCT.substring(0, 12);
		for (int count = custACCT.length(); count < 12; count++) {
			custACCT += " ";
		}
		// 匯款總額
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 13) + totAmtT.substring(14, 16);
		// 明細筆數
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (5 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// 保留欄位 x(50)
		String fillerH = "";
		for (int count = fillerH.length(); count < 50; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "H"; // 表匯總資料
		downloadInfo[0][1] = "BT"; // 交易總類,
		downloadInfo[0][2] = "DBU"; // DBU/OBU
		downloadInfo[0][3] = custID; // 客戶統編
		downloadInfo[0][4] = strRMDTTemp1;// 匯款日期
		downloadInfo[0][5] = "D"; // 與本行約定之扣款帳號
		downloadInfo[0][6] = custACCT; // 與本行約定之扣款帳號
		downloadInfo[0][7] = payCURR; // 匯款幣別
		downloadInfo[0][8] = totAmt; // 匯款總額
		downloadInfo[0][9] = totCount; // 明細筆數
		downloadInfo[0][10] = fillerH; // 保留欄位

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	// R00386
	private String convertDownloadData007(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		// layout 應為 15 欄位, 但 \r\n 後面程式會自動做, 可以省略
		String[][] downloadInfo = new String[payments.size()][14];
		DecimalFormat df = new DecimalFormat("0000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		// R80132 String payCURR= disbBean.getCurr(selCURR,3);//幣別 2碼轉為數字碼
		String payCURR = disbBean.getETableDesc("CURR3", selCURR);// R80132

		String strSql = "SELECT FLD0029 FROM ORDUNA WHERE FLD0001='  ' AND FLD0002=? ";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbFactory.getAS400Connection("DISBRemitExportServlet.convertDownloadData007");
			pstmt = con.prepareStatement(strSql);
		} catch(SQLException ex) {
			System.err.println(ex.getMessage());
		}

		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 2.斷線後送序號X(10)
			String seqNo = "";
			for (int count = seqNo.length(); count < 10; count++) {
				seqNo = seqNo + " ";
			}
			// 3.帳號x(11)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 11)
				entAccountNo = entAccountNo.substring(0, 11);
			for (int count = entAccountNo.length(); count < 11; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 4.統一編號X(10)
			String custID = CommonUtil.AllTrim(rmtVO.getRID());
			if(custID.length() == 8) {
				custID = "00" + custID;
			}
			for (int count = custID.length(); count < 10; count++) {
				custID = custID + " ";
			}
			// 5.判斷統一編號欄位 種類
			String customIdType = "0";
			try {
				pstmt.clearParameters();
				pstmt.setString(1, CommonUtil.AllTrim(rmtVO.getRID()));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					if(rs.getString("FLD0029").equalsIgnoreCase("C")) {
						customIdType = "1"; // 公司戶
					} else if(rs.getString("FLD0029").equalsIgnoreCase("F") || rs.getString("FLD0029").equalsIgnoreCase("M")) {
						customIdType = "2"; // 個人戶
					} else {
						customIdType = "0";	// 不檢查
					}
				}
			} catch(SQLException ex) {
				System.err.println(ex.getMessage());
			}
			/*
			int customIdLen = custID.trim().length();
			if (customIdLen == 10)
				customIdType = "2"; // 身份證字號 ==> 個人戶
			else if (customIdLen == 8)
				customIdType = "1"; // 公司統一編號
			else
				customIdType = "0"; // 不檢查
			*/

			// 6.匯款金額x(15)
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() -
			// rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 13) + remitAmtT.substring(14, 16);
			// 7.主辦行
			String pBank = rmtVO.getPBK();
			String pBranck;
			if (pBank == null)
				pBranck = "   ";
			else {
				// 若不足 6 位, 先補足再取
				if (pBank.length() < 6)
					pBank = pBank + "      ".substring(0, 6 - pBank.length());
				pBranck = pBank.substring(3, 6);
			}

			// 11.預定入帳日x(6)
			String remitDate = rmtVO.getRMTDT();
			for (int count = remitDate.length(); count < 6; count++) {
				remitDate = "0" + remitDate;
			}

			downloadInfo[index][0] = "5797"; // 交易代碼
			downloadInfo[index][1] = seqNo; // 斷線後送序號空白
			downloadInfo[index][2] = entAccountNo; // 帳號
			downloadInfo[index][3] = custID; // 統一編號,
			downloadInfo[index][4] = customIdType; // 是否檢查
			downloadInfo[index][5] = remitAmt; // 交易金額
			downloadInfo[index][6] = pBranck; // 主辦行
			downloadInfo[index][7] = payCURR; // 幣別
			downloadInfo[index][8] = " "; // 帳戶別(空白)
			downloadInfo[index][9] = " "; // 入款別(空白)
			downloadInfo[index][10] = "          "; // 保留欄位
			downloadInfo[index][11] = " "; // 代收專戶代碼
			downloadInfo[index][12] = "008"; // 固定值, 表示全球人壽
			downloadInfo[index][13] = " "; // 保留項
		}

		try {
			if(pstmt != null)
				pstmt.close();
			if(con != null)
				dbFactory.releaseAS400Connection(con);
		} catch(Exception ex) {
			ex.printStackTrace();
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}
    
	// R70088 SUPL配息 兆豐銀行,轉帳(同行相存)
	private String convertDownloadData017t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 2)][15];
		DecimalFormat df = new DecimalFormat("000000000000.00");
		DecimalFormat df2 = new DecimalFormat("00000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		double saveAmt = 0;
		double saveAmtT = 0;// R70455
		int saveCount = 0;
		int saveIndex = 0;
		String saveRMDT = "";
		// R80132 String payCURR= disbBean.getCurr(selCURR,4);//幣別 2碼轉為數字碼
		String payCURR = disbBean.getETableDesc("CURR4", selCURR);// R80132
		// 發件單位 RA0140---005為忠孝分行的代號，請改為南京東路分行代號070
		String save070 = "070";
		for (int count = save070.length(); count < 8; count++) {
			save070 = save070 + " ";
		}
		// 收件單位
		String save017 = "017";
		for (int count = save017.length(); count < 8; count++) {
			save017 = save017 + " ";
		}

		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);// R70455
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);// R70455
			saveCount = index + 1;
			saveRMDT = rmtVO.getRMTDT();
			// 扣帳日 六位數字
			if (saveRMDT.length() > 6)
				saveRMDT = saveRMDT.substring(1);

			// 3.匯款幣別,X(3)
			String remitCURR = payCURR;
			for (int count = remitCURR.length(); count < 3; count++) {
				remitCURR = remitCURR + " ";
			}
			// 4.匯款金額x(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 12) + remitAmtT.substring(13, 15);

			// 5.受益人帳號x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 11.保留欄位 x(15)
			String fillerD1 = "";
			for (int count = 0; count < 15; count++) {
				fillerD1 = fillerD1 + " ";
			}
			// 受款人ID, x(10)空白
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}
			// 14.保留欄位 x(12)
			String fillerD2 = "";
			for (int count = 0; count < 12; count++) {
				fillerD2 = fillerD2 + " ";
			}
			// 15.保留欄位 x(12)
			String fillerD = "";
			for (int count = 0; count < 12; count++) {
				fillerD = fillerD + " ";
			}

			downloadInfo[index + 1][0] = "2"; // 表明細資料
			downloadInfo[index + 1][1] = save070; // 發件單位
			downloadInfo[index + 1][2] = save017; // 收件單位
			downloadInfo[index + 1][3] = "200"; // 轉帳類別
			downloadInfo[index + 1][4] = saveRMDT; // 入/扣帳日
			downloadInfo[index + 1][5] = entAccountNo;// 帳號
			downloadInfo[index + 1][6] = remitAmt; // 交易金額
			downloadInfo[index + 1][7] = "70817744"; // 營利事業統一編號
			downloadInfo[index + 1][8] = "99"; // 狀況代號
			// 32專用資料區
			downloadInfo[index + 1][9] = "*C917"; // 摘要代號
			downloadInfo[index + 1][10] = fillerD1; // 空白15
			downloadInfo[index + 1][11] = custRemitId; // 存款人身份證字號
			downloadInfo[index + 1][12] = payCURR; // 幣別代號
			downloadInfo[index + 1][13] = fillerD2; // 空白12
			downloadInfo[index + 1][14] = fillerD; // 空白欄
			saveIndex = index + 2;
		}
		// -----HEAD-----
		// 空白欄 x(91)
		String fillerH = "";
		for (int count = 0; count < 91; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "1"; // 表尾筆
		downloadInfo[0][1] = save070; // 發件單位
		downloadInfo[0][2] = save017; // 收件單件
		downloadInfo[0][3] = "200"; // 轉帳類別
		downloadInfo[0][4] = saveRMDT; // 入扣帳日
		downloadInfo[0][5] = "1"; // 性質別
		downloadInfo[0][6] = "32"; // 資料類別
		downloadInfo[0][7] = fillerH; // 空白欄
		for (int i = 8; i < 15; i++) {
			downloadInfo[0][i] = "";
		}
		// -----FOOT-----
		// 成交總金額X(16)
		String totAmtT = df2.format(saveAmt);
		String totAmt = totAmtT.substring(0, 14) + totAmtT.substring(15, 17);
		// 成交總筆數X(10)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (10 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// 未成交總筆數X(16)放零
		String totAmtF = "";
		for (int count = 0; count < 16; count++) {
			totAmtF = "0" + totAmtF;
		}
		// 未成交總筆數X(10)放零
		String totCountF = "";
		for (int count = 0; count < 10; count++) {
			totCountF = "0" + totCountF;
		}
		// 空白欄 x(42)
		String fillerF = "";
		for (int count = 0; count < 42; count++) {
			fillerF = fillerF + " ";
		}

		downloadInfo[saveIndex][0] = "3"; // 表尾筆
		downloadInfo[saveIndex][1] = save070; // 發件單位
		downloadInfo[saveIndex][2] = save017; // 收件單件
		downloadInfo[saveIndex][3] = "200"; // 轉帳類別
		downloadInfo[saveIndex][4] = saveRMDT; // 入扣帳日
		downloadInfo[saveIndex][5] = totAmt; // 成交總金額
		downloadInfo[saveIndex][6] = totCount; // 成交總筆數
		downloadInfo[saveIndex][7] = totAmtF; // 未成交總金額
		downloadInfo[saveIndex][8] = totCountF; // 未成交總筆數
		downloadInfo[saveIndex][9] = fillerF; // 空白欄
		for (int i = 10; i < 15; i++) {
			downloadInfo[saveIndex][i] = "";
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}
	
	//RD0382:OIU,兆豐匯款檔(跨行),SWIFT CODE第5及6碼不可為TW
	private String convertDownloadData017r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		
		String fileLOC = "";
		
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		// layout 應為 21 欄位, 但 \r\n 後面程式會自動做, 可以省略
		String[][] downloadInfo = new String[payments.size()][22];
		DecimalFormat df = new DecimalFormat("000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		
		String remitDateTmp = "";
		boolean remitDataChange = false;
		//明細資料
		for (int index = 0; index < payments.size(); index++) {			
			rmtVO = (CaprmtfVO) payments.get(index);
			
			//受款帳號
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			
			//RE0189-判斷受款帳號是否為兆豐OBU
			/*String remitAcct = entAccountNo.trim();
			String remitBank = rmtVO.getRBK() == null ? "" : rmtVO.getRBK();
			Boolean isOBU4Remit017 = false;
			String codeOBU4Remit = "";			
			if(remitBank.length()>=3 && "017".equals(remitBank.subSequence(0, 3))) codeOBU4Remit = remitAcct.substring(3,5);
			if("17".equals(codeOBU4Remit) || "57".equals(codeOBU4Remit) || "58".equals(codeOBU4Remit)) isOBU4Remit017 = true;*/
			
			//受款帳號
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
				
			
			//統編/身分字號
			String custID = CommonUtil.AllTrim(rmtVO.getRID());			
			
			//匯款金額		
			//log.info("rmtVO.getRPAYAMT()是" + rmtVO.getRPAYAMT() + ",rmtVO.getRBENFEE()是" + rmtVO.getRBENFEE());
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			//log.info("remitAmtNum是" + remitAmtNum);
			String remitAmt = "";
			remitAmt = df.format(remitAmtNum);			
			
			//付款帳號
			String payAccount = "";
			payAccount = CommonUtil.AllTrim(rmtVO.getPACCT());
			
			//SWIFT CODE
			String swiftCode = "";
			swiftCode = CommonUtil.AllTrim(rmtVO.getSWIFTCODE());
			
			//受款行國別
			/*String remitContryString = "";
			if(swiftCode.length()>=8) remitContryString = swiftCode.substring(4, 6);*/
			
			String country = "";
			if(!"".equals(swiftCode) && swiftCode.length()>=8) country = swiftCode.substring(4, 6);
			
			
			//匯款幣別
			String remitCurrency = "";
			remitCurrency = CommonUtil.AllTrim(rmtVO.getRPAYCURR());
			remitCurrency = disbBean.getETableDesc("CURRA", remitCurrency.trim());
			
			//英文姓名
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			
			//受款人英文地址
			String engAddr = "";
			engAddr = CommonUtil.AllTrim(rmtVO.getPayAddr());
			String engAddr1 = "";
			String engAddr2 = "";
			String engAddr3 = "";
			engAddr1 = engAddr;
			if(engAddr1.length() > 105) engAddr1 = engAddr.substring(1,105);
			/*if(engAddr.length()<=35) engAddr1 = engAddr;
			if(engAddr.length()>35 && engAddr.length()<=70) engAddr2 = engAddr.substring(35,engAddr.length());
			if(engAddr.length()>70) engAddr3 = engAddr.substring(70);*/
			
			//支付原因代碼
			String paySourceCode = "";
			paySourceCode = CommonUtil.AllTrim(rmtVO.getPaySourceCode());
			
			
			//CNAPS(CN)/ABA ROUTING(US)/TRANSIT(CA)/BSB(AU)/IBAN(歐)
			String payBkVerifyNumber = "";
			payBkVerifyNumber = CommonUtil.AllTrim(rmtVO.getPayBkVerifyNumber());
			String IBAN = "";
			if(!"CN".equals(country) && !"US".equals(country) && !"CA".equals(country) && !"AU".equals(country) && !"TW".equals(country)) IBAN = payBkVerifyNumber;
			
			//SORT CODE
			String payBkSortCode = "";
			payBkSortCode = CommonUtil.AllTrim(rmtVO.getPayBkSortCode());
			
			//預定及實際入帳日
			String remitDate = rmtVO.getRMTDT();
			if(index >0  && !remitDataChange){
				if(!remitDateTmp.equals(remitDate)) remitDataChange = true;
			}
			
			//手續費支付方式
			String rPAYFEEWAY = "";
			rPAYFEEWAY = CommonUtil.AllTrim(rmtVO.getRPAYFEEWAY());		
			
			remitDateTmp = remitDate;
			remitDateTmp = (Integer.parseInt(remitDateTmp.substring(0,3))+1911) + remitDateTmp.substring(3);
			downloadInfo[index][0] = remitDateTmp; //匯款日期,1
			downloadInfo[index][1] = payAccount + genSpace(11-payAccount.length()); //付款帳號,2
			downloadInfo[index][2] = country + genSpace(2-country.length()); //受款銀行國別(取SWIFT CODE第5及6碼),3
			//log.info("paySourceCode是" + paySourceCode + ",RACCT是" + rmtVO.getRACCT());
			if("D1".equals(paySourceCode)){
				downloadInfo[index][3] = "                              129"; //129 保費支出,4
			}else{
				downloadInfo[index][3] = "                              399"; //129 保費支出,4
			}			
			downloadInfo[index][4] = genSpace(2); //na,5
			downloadInfo[index][5] = remitDateTmp + remitCurrency; //匯款幣別(支付主檔的相關匯款批號幣別),7
			downloadInfo[index][6] = remitAmt; //匯款金額 (小數2位),8
			downloadInfo[index][7] = "TWZ0066516"; //TWZ0066516,9			
			String company1 = "TRANSGLOBE LIFE INSURANCE INC. OFFSHORE INSURANCE BRANCH ";
			String payBkAddr1 = "16F, No.288, Sec. 6, Civic Blvd.,  Taipei City 110, Taiwan, R.O.C.";
			downloadInfo[index][8] = company1; //付款銀行名稱1,10
			downloadInfo[index][9] = payBkAddr1.toUpperCase(); //付款銀行地址1,12
			downloadInfo[index][10] = genSpace(193); //na,14
			swiftCode = "A" + swiftCode;
			downloadInfo[index][11] = swiftCode.trim() + genSpace(41-swiftCode.trim().length()); //SWIFT CODE,21
			downloadInfo[index][12] = payBkVerifyNumber.trim() + genSpace(31-payBkVerifyNumber.trim().length()); //CNAPS(CN)/ABA ROUTING(US)/TRANSIT(CA)/BSB(AU),22
			downloadInfo[index][13] = payBkSortCode + genSpace(104-payBkSortCode.length()); //SORT CODE(GB),23
			if(IBAN.length()>0){
				IBAN = "/" + IBAN;
				downloadInfo[index][14] = IBAN + genSpace(35-IBAN.length()); //IBAN(歐),26
			}else{
				entAccountNo = "/" + entAccountNo;
				downloadInfo[index][14] = entAccountNo + genSpace(35-entAccountNo.length()); //受款人帳號(匯款帳號),26
			}			
			downloadInfo[index][15] = entNameT.trim() + genSpace(35-entNameT.trim().length()); //受款人戶名,27
			downloadInfo[index][16] = engAddr1.trim() + genSpace(105-engAddr1.trim().length()); //受款人英文地址1,28
			downloadInfo[index][17] = genSpace(0); //受款人英文地址2,29
			downloadInfo[index][18] = genSpace(0); //受款人英文地址3,30
			String memo = "PAY FULL AMOUNT";
			downloadInfo[index][19] = memo + genSpace(16-memo.trim().length()); //附言,31
			downloadInfo[index][20] = genSpace(135); //na,32
			downloadInfo[index][21] = rPAYFEEWAY; //na,33,CAPRMTF.RPAYFEEWAY
		}//end for		
		
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}
	
	//RE0189:凱基-匯款檔
private String convertDownloadData809r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		
		String fileLOC = "";
		
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		// layout 應為 21 欄位, 但 \r\n 後面程式會自動做, 可以省略
		String[][] downloadInfo = new String[payments.size()][22];
		DecimalFormat df = new DecimalFormat("000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		
		String remitDateTmp = "";
		boolean remitDataChange = false;
		//明細資料
		for (int index = 0; index < payments.size(); index++) {			
			rmtVO = (CaprmtfVO) payments.get(index);
			
			//受款帳號
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			
			//受款帳號
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
				
			
			//統編/身分字號
			String custID = CommonUtil.AllTrim(rmtVO.getRID());			
			
			//匯款金額		
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmt = "";
			remitAmt = df.format(remitAmtNum);			
			
			//付款帳號
			String payAccount = "";
			payAccount = CommonUtil.AllTrim(rmtVO.getPACCT());
			
			//SWIFT CODE
			String swiftCode = "";
			swiftCode = CommonUtil.AllTrim(rmtVO.getSWIFTCODE());
			
			//受款行國別
			String remitContryString = "";
			if(swiftCode.length()>=8) remitContryString = swiftCode.substring(4, 6);
			
			String country = "";
			if(!"".equals(swiftCode) && swiftCode.length()>=8) country = swiftCode.substring(4, 6);
			
			
			//匯款幣別
			String remitCurrency = "";
			remitCurrency = CommonUtil.AllTrim(rmtVO.getRPAYCURR());
			remitCurrency = disbBean.getETableDesc("CURRA", remitCurrency.trim());
			
			//英文姓名
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			
			//受款人英文地址
			String engAddr = "";
			engAddr = CommonUtil.AllTrim(rmtVO.getPayAddr());
			String engAddr1 = "";
			String engAddr2 = "";
			String engAddr3 = "";
			engAddr1 = engAddr;
			if(engAddr1.length() > 105) engAddr1 = engAddr.substring(1,105);
			
			//支付原因代碼
			String paySourceCode = "";
			paySourceCode = CommonUtil.AllTrim(rmtVO.getPaySourceCode());
			
			
			//CNAPS(CN)/ABA ROUTING(US)/TRANSIT(CA)/BSB(AU)/IBAN(歐)
			String payBkVerifyNumber = "";
			payBkVerifyNumber = CommonUtil.AllTrim(rmtVO.getPayBkVerifyNumber());
			String IBAN = "";
			if(!"CN".equals(country) && !"US".equals(country) && !"CA".equals(country) && !"AU".equals(country) && !"TW".equals(country)) IBAN = payBkVerifyNumber;
			
			//SORT CODE
			String payBkSortCode = "";
			payBkSortCode = CommonUtil.AllTrim(rmtVO.getPayBkSortCode());
			
			//預定及實際入帳日
			String remitDate = rmtVO.getRMTDT();
			if(index >0  && !remitDataChange){
				if(!remitDateTmp.equals(remitDate)) remitDataChange = true;
			}
			
			//手續費支付方式
			String rPAYFEEWAY = "";
			rPAYFEEWAY = CommonUtil.AllTrim(rmtVO.getRPAYFEEWAY());		
			
			remitDateTmp = remitDate;
			remitDateTmp = (Integer.parseInt(remitDateTmp.substring(0,3))+1911) + remitDateTmp.substring(3);
			downloadInfo[index][0] = remitDateTmp; //匯款日期,1
			downloadInfo[index][1] = payAccount + genSpace(11-payAccount.length()); //付款帳號,2
			downloadInfo[index][2] = country + genSpace(2-country.length()); //受款銀行國別(取SWIFT CODE第5及6碼),3
			downloadInfo[index][3] = "                              129"; //129 保費支出,4			
			downloadInfo[index][4] = genSpace(2); //na,5
			downloadInfo[index][5] = remitDateTmp + remitCurrency; //匯款幣別(支付主檔的相關匯款批號幣別),7
			downloadInfo[index][6] = remitAmt; //匯款金額 (小數2位),8
			downloadInfo[index][7] = "TWZ0066516"; //TWZ0066516,9			
			String company1 = "TRANSGLOBE LIFE INSURANCE INC. OFFSHORE INSURANCE BRANCH ";
			String payBkAddr1 = "16F, No.288, Sec. 6, Civic Blvd.,  Taipei City 110, Taiwan, R.O.C.";
			downloadInfo[index][8] = company1; //付款銀行名稱1,10
			downloadInfo[index][9] = payBkAddr1.toUpperCase(); //付款銀行地址1,12
			downloadInfo[index][10] = genSpace(193); //na,14
			swiftCode = "A" + swiftCode;
			downloadInfo[index][11] = swiftCode.trim() + genSpace(41-swiftCode.trim().length()); //SWIFT CODE,21
			downloadInfo[index][12] = payBkVerifyNumber.trim() + genSpace(31-payBkVerifyNumber.trim().length()); //CNAPS(CN)/ABA ROUTING(US)/TRANSIT(CA)/BSB(AU),22
			downloadInfo[index][13] = payBkSortCode + genSpace(104-payBkSortCode.length()); //SORT CODE(GB),23
			if(IBAN.length()>0){
				IBAN = "/" + IBAN;
				downloadInfo[index][14] = IBAN + genSpace(35-IBAN.length()); //IBAN(歐),26
			}else{
				entAccountNo = "/" + entAccountNo;
				downloadInfo[index][14] = entAccountNo + genSpace(35-entAccountNo.length()); //受款人帳號(匯款帳號),26
			}			
			downloadInfo[index][15] = entNameT.trim() + genSpace(35-entNameT.trim().length()); //受款人戶名,27
			downloadInfo[index][16] = engAddr1.trim() + genSpace(105-engAddr1.trim().length()); //受款人英文地址1,28
			downloadInfo[index][17] = genSpace(0); //受款人英文地址2,29
			downloadInfo[index][18] = genSpace(0); //受款人英文地址3,30
			String memo = "PAY FULL AMOUNT";
			downloadInfo[index][19] = memo + genSpace(16-memo.trim().length()); //附言,31
			downloadInfo[index][20] = genSpace(135); //na,32
			downloadInfo[index][21] = rPAYFEEWAY; //na,33,CAPRMTF.RPAYFEEWAY
		}//end for		
		
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	// R70088 SUPL配息 新竹商銀 
	private String convertDownloadData052(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		DecimalFormat df = new DecimalFormat("0000000000000.00");
		String[][] downloadInfo = new String[payments.size()][5];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO;

		// 3.幣別x(3)
		// R80132 String payCURR =disbBean.getCurr(selCURR,1);//2碼轉三嗎
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);// R80132 R80480 CURR1->CURRA

		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 1.受款人姓名x(70)
			//QC0274String entNameT = rmtVO.getPENGNAME() == null ? "" : rmtVO.getPENGNAME();
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			for (int count = entNameT.length(); count < 70; count++) {
				entNameT = entNameT + " ";
			}
			// 2.受款人帳號x(35)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 17)
				entAccountNo = entAccountNo.substring(0, 17);
			for (int count = entAccountNo.length(); count < 17; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 4.匯款金額x(15)
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() -
			// rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmt = df.format(remitAmtNum);
			// 受款人ID, x(10)空白
			String custRemitId = rmtVO.getRID();

			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}

			downloadInfo[index][0] = entNameT; // 姓名,
			downloadInfo[index][1] = entAccountNo;// 帳號
			downloadInfo[index][2] = payCURR; // 幣別
			downloadInfo[index][3] = remitAmt; // 金額9(15)
			downloadInfo[index][4] = custRemitId; // 客戶ID
		}

		fileLOC = disbBean.writeTOfileXLS(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	//	R70088 SUPL配息 永豐銀行
	private String convertDownloadData807(Vector payments,String selCURR,String BATNO,String remitKind,String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;
		DecimalFormat df = new DecimalFormat("00000000000.00");
		String[][] downloadInfo = new String[payments.size()][17];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO;
		// R80132 String payCURR= disbBean.getCurr(selCURR,5);//幣別 2碼轉為數字碼
		String payCURR = disbBean.getETableDesc("CURR5", selCURR);// R80132

		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 1.處理批次X(04)
			String filler1 = "";
			for (int count = 0; count < 4; count++) {
				filler1 = filler1 + " ";
			}
			// 2.SEQNO 序號X(7)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (7 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 3.客戶帳號x(14)匯款帳號
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 4.交易日期x(6) --> RA0241 x(07)
			String remitDate = rmtVO.getRMTDT();
			for (int count = remitDate.length(); count < 7; count++) {
				remitDate = "0" + remitDate;
			}
			// 5.匯款金額x(15)
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() -
			// rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 11) + remitAmtT.substring(12, 14);
			// 7受款人ID, x(10)空白
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}
			// 8.股票號碼X(6)代理編號 --> 8.保留x(6)  RA0241 
			//String filler2 = "100267";
			String filler2 = "";
			for (int count = 0; count < 6; count++) {
				filler2 = filler2 + " ";
			}
			
			// 10.對方帳號x(14)支付帳號
			String entPAcctNo = rmtVO.getRACCT() == null ? "" : rmtVO.getPACCT();
			if (entPAcctNo.length() > 14)
				entPAcctNo = entPAcctNo.substring(0, 14);

			for (int count = entPAcctNo.length(); count < 14; count++) {
				entPAcctNo = entPAcctNo + " ";
			}
			// 11.保留X(14)
			String filler3 = "";
			for (int count = 0; count < 14; count++) {
				filler3 = filler3 + " ";
			}
			// 13.保留X(70) --> RA0241 x(34)
			String filler4 = "";
			for (int count = 0; count < 34; count++) {
				filler4 = filler4 + " ";
			}
			// 14.代理編號x(6)  RA0241
			String filler5 = "100267";
			// 15.保留x(31)  RA0241
			String filler6 = "";
			for (int count = 0; count < 31; count++) {
				filler6 = filler6 + " ";
			}
			// 16.安全代碼x(14)
			String safeCode = disbBean.getSafeCode807(entAccountNo, remitAmt);
			// 17.處理記號x(1)
			String filler7 = "0";

			downloadInfo[index][0] = filler1; // 處理批次
			downloadInfo[index][1] = seqNo; // 序號號
			downloadInfo[index][2] = entAccountNo; // 客戶帳號
			downloadInfo[index][3] = remitDate; // 交易日期
			downloadInfo[index][4] = remitAmt; // 交易金額
			downloadInfo[index][5] = "228"; // 摘要
			downloadInfo[index][6] = custRemitId; // 身份證字號
			downloadInfo[index][7] = filler2; // 股票號碼-->保留
			downloadInfo[index][8] = "99"; // 狀態碼
			downloadInfo[index][9] = entPAcctNo;// 對方帳號
			downloadInfo[index][10] = filler3; // 保留
			downloadInfo[index][11] = payCURR; // 幣別
			downloadInfo[index][12] = filler4; // 保留
			downloadInfo[index][13] = filler5; // 代理編號
			downloadInfo[index][14] = filler6; // 保留
			downloadInfo[index][15] = safeCode; // 安全代碼
			downloadInfo[index][16] = filler7; // 處理記號
		}//end for
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}// R70088 END

	// R00386 台新銀行 / 外幣時用另一種格式
	private String convertDownloadData812(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		if (payments == null || payments.size() <= 0)
			return fileLOC;

		//String[][] downloadInfo = new String[payments.size() + 1][7]; // 多留一行給表頭
		String[][] downloadInfo = new String[payments.size() + 1][8]; // 多留一行給表頭
		NumberFormat df = new DecimalFormat("##############0.##");

		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);

		// 寫入表頭
		downloadInfo[0][0] = "交易日期";
		downloadInfo[0][1] = "入款帳號";
		downloadInfo[0][2] = "扣款帳號";
		downloadInfo[0][3] = "幣別";
		downloadInfo[0][4] = "入扣帳金額";
		downloadInfo[0][5] = "扣款ID";
		downloadInfo[0][6] = "入帳ID"; // RA0081
		downloadInfo[0][7] = "性質";

		// 寫入資料
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 交易日 - 轉西元年
			String trDateString = rmtVO.getRMTDT();
			int trDateNum = Integer.parseInt(trDateString); // 不 handle exception, 來源不是有效年月日乾脆不要出檔案
			trDateNum += 19110000;
			trDateString = String.valueOf(trDateNum);

			// 匯款金額
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			// 匯(扣)款帳號
			String entPAcctNo = rmtVO.getRACCT() == null ? "" : rmtVO.getPACCT();
			// 受款人帳號
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			//
			int pos = index + 1;
			downloadInfo[pos][0] = trDateString; // 交易日
			downloadInfo[pos][1] = entAccountNo; // 入款帳號
			downloadInfo[pos][2] = entPAcctNo; // 扣款帳號
			downloadInfo[pos][3] = payCURR; // 幣別
			downloadInfo[pos][4] = df.format(remitAmtNum); // 入扣帳金額
			downloadInfo[pos][5] = "70817744"; // 扣款 ID - 公司編號,目前沒有常數,先照舊...
			downloadInfo[pos][6] = rmtVO.getRID(); // 收款人ID
			downloadInfo[pos][7] = "129";
		}

		fileLOC = disbBean.writeTOfileXLS(downloadInfo, BATNO, selCURR, remitKind, strLogonUser, true);
		return fileLOC;
	}

	// R70574 華南銀行
	private String convertDownloadData008(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;
		DecimalFormat df = new DecimalFormat("00000000000.00");
		String[][] downloadInfo = new String[payments.size()][9];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO;
		// R80132 String payCURR= disbBean.getCurr(selCURR,6);//幣別 2碼轉為數字碼
		String payCURR = disbBean.getETableDesc("CURR6", selCURR);// R80132

		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 1.轉帳日期x(6)
			String remitDate = rmtVO.getRMTDT();
			for (int count = remitDate.length(); count < 6; count++) {
				remitDate = "0" + remitDate;
			}
			// 4.受款人帳號x(12)匯款帳號
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 12; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 5.身份證, x(10)空白
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}
			// 7.匯款金額x(15)
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() -
			// rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 11) + remitAmtT.substring(12, 14);
			// 8.資料編號X(10)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (10 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 9.保留欄X(12) 幣別 2+轉帳分類 2+空白
			String note = payCURR;
			for (int count = note.length(); count < 12; count++) {
				note += " ";
			}

			downloadInfo[index][0] = remitDate; // 轉帳日期
			downloadInfo[index][1] = "1000"; // 主辦行
			downloadInfo[index][2] = "70817744  ";// 營利編號
			downloadInfo[index][3] = entAccountNo;// 帳號
			downloadInfo[index][4] = custRemitId; // 身份證
			downloadInfo[index][5] = "110"; // 轉帳別
			downloadInfo[index][6] = remitAmt; // 轉帳金額
			downloadInfo[index][7] = seqNo; // 資料編號
			downloadInfo[index][8] = note; // 保留欄
		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}// R70574 END

	// R80480 上海銀行
	private String convertDownloadData011(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 1)][12];
		DecimalFormat df = new DecimalFormat("0000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		double saveAmt = 0;
		double saveAmtT = 0;
		int saveCount = 0;
		String savePACCT = "";
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);// 幣別 2碼轉為3碼
		String strRMDTTemp = "";

		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// SAVE AREA
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);
			saveCount = index + 1;
			savePACCT = rmtVO.getPACCT() == null ? "" : rmtVO.getPACCT();

			// 1.流水序號X(6)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (6 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 4.客戶編號, x(10)空白
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}
			// 5.入帳帳號x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 6.入帳幣別,X(3)
			String remitCURR = payCURR;
			for (int count = remitCURR.length(); count < 3; count++) {
				remitCURR += " ";
			}
			// 7.入帳金額x(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 13)
					+ remitAmtT.substring(14, 16);
			// 8.交易日期x(8)
			String remitDate = rmtVO.getRMTDT();
			for (int count = remitDate.length(); count < 8; count++) {
				remitDate = "0" + remitDate;
			}
			strRMDTTemp = Integer.toString(1911 + Integer.parseInt(remitDate.substring(0, 4))) + remitDate.substring(4, 6) + remitDate.substring(6, 8);
			// 10.固定資料 x(18)
			String filler = "";
			for (int count = 0; count < 18; count++) {
				filler += " ";
			}
			// 11.備註 x(14)
			String strNOTE = "全球人壽";
			for (int count = strNOTE.length() * 2; count < 14; count++) {
				strNOTE += " ";
			}

			downloadInfo[index + 1][0] = seqNo; // 流水序號
			downloadInfo[index + 1][1] = "020"; // 分行別
			downloadInfo[index + 1][2] = " "; // 市場別
			downloadInfo[index + 1][3] = custRemitId; // 客戶編號
			downloadInfo[index + 1][4] = entAccountNo; // 入帳帳號
			downloadInfo[index + 1][5] = remitCURR; // 入帳幣別
			downloadInfo[index + 1][6] = remitAmt; // 入帳金額
			downloadInfo[index + 1][7] = "1"; // 入扣帳別
			downloadInfo[index + 1][8] = strRMDTTemp; // 交易日期
			downloadInfo[index + 1][9] = filler; // 固定資料
			downloadInfo[index + 1][10] = strNOTE; // 備註
			downloadInfo[index + 1][11] = "0"; // 固定資料
		}
		// -----HEAD----
		// 3.轉出筆數X(10)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (6 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// 4.轉出總金額X(16)
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 13) + totAmtT.substring(14, 16);

		// 5.空白 x(21)
		String fillerD = "";
		for (int count = 0; count < 21; count++) {
			fillerD += "0";
		}
		// 6.入帳帳號x(14)
		if (savePACCT.length() > 14)
			savePACCT = savePACCT.substring(0, 14);
		for (int count = savePACCT.length(); count < 14; count++) {
			savePACCT = "0" + savePACCT;
		}

		downloadInfo[0][0] = "HD    "; // 表首筆
		downloadInfo[0][1] = strRMDTTemp; // 轉帳日期
		downloadInfo[0][2] = fillerD; // 空白放零
		downloadInfo[0][3] = totCount; // 轉出筆數
		downloadInfo[0][4] = totAmt; // 轉出總金額
		downloadInfo[0][5] = savePACCT; // 轉出帳號
		downloadInfo[0][6] = fillerD; // 空白放零
		for (int i = 7; i < 12; i++) {
			downloadInfo[0][i] = "";
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}// R80480 END

	//R00566 元大銀行外幣匯款檔
	private String convertDownloadData806(Vector payments,String selCURR,String BATNO,String remitKind,String strLogonUser) {
		String fileLOC = "";
		Statement stmt = null;
		ResultSet rs = null;
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;
		String[][] downloadInfo = new String[(payments.size() + 2)][15];
		DecimalFormat df = new DecimalFormat("000000000000.00");
		DecimalFormat df2 = new DecimalFormat("00000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		double saveAmt = 0;
		double saveAmtT = 0;// R70455
		int saveCount = 0;
		int saveIndex = 0;
		String trDateString = "";
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);

		//
		String save005 = "70817744";

		// 收件單位
		String save806 = "806";
		for (int count = save806.length(); count < 8; count++) {
			save806 = save806 + " ";
		}
		// 保留
		String space1 = "";
		for (int count = space1.length(); count < 89; count++) {
			space1 = space1 + " ";
		}

		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);
			saveCount = index + 1;

			trDateString = rmtVO.getRMTDT();
			int trDateNum = Integer.parseInt(trDateString); // 不 handle exception, 來源不是有效年月日乾脆不要出檔案
			trDateNum += 19110000;
			trDateString = String.valueOf(trDateNum);

			// 4.匯款金額x(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 12) + remitAmtT.substring(13, 15);

			// 5.受益人帳號x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14) {
				entAccountNo = entAccountNo.substring(0, 14);
			}
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 10 保單號碼+受款人身份正號 &&14 中文備註
			Connection con = dbFactory.getAS400Connection("DISBRemitExportServlet.convertDownloadData806()");
			String entBatNo = rmtVO.getBATNO() == null ? "" : rmtVO.getBATNO();
			String entSeqNo = rmtVO.getSEQNO() == null ? "" : rmtVO.getSEQNO();
			String POLICY_NO1 = "";
			String PAY_DESCRIPTION1 = "";
			String strSql = "";

			try {
				strSql = "SELECT SUBSTRING(B.FLD0004,9,8) PAY_DESCRIPTION1,A.POLICY_NO,A.PAY_SOURCE_CODE FROM CAPPAYF A "
						+ "INNER JOIN  ORDUET B on B.FLD0001 =''  and B.FLD0002 ='PAYCD' "
						+ "AND A.PAY_SOURCE_CODE=B.FLD0003 "
						+ " WHERE A.PAY_BATCH_NO='" + entBatNo + "' and A.BAT_SEQ='" + entSeqNo + "'";
				stmt = con.createStatement();
				rs = stmt.executeQuery(strSql);
				System.out.println(strSql);
				if (rs.next()) {
					// 保單號碼
					POLICY_NO1 = rs.getString("POLICY_NO").trim();
					for (int count2 = POLICY_NO1.length(); count2 < 10; count2++) {
						POLICY_NO1 += " ";
					}
					// 中文備註
					System.out.println("PAY_DESCRIPTION0" + PAY_DESCRIPTION1);
					PAY_DESCRIPTION1 = rs.getString("PAY_DESCRIPTION1").replace('　', ' ').trim();
					System.out.println("PAY_DESCRIPTION1" + PAY_DESCRIPTION1);
					// PAY_DESCRIPTION1=PAY_DESCRIPTION1.substring(8);

					if (PAY_DESCRIPTION1.getBytes().length >= 10) {
						int i = PAY_DESCRIPTION1.length();
						while (PAY_DESCRIPTION1.getBytes().length > 10) {
							PAY_DESCRIPTION1 = PAY_DESCRIPTION1.substring(0, i);
							i = i - 1;
						}
					} else {
						for (int count1 = PAY_DESCRIPTION1.getBytes().length; count1 < 10; count1 = count1 + 2) {
							PAY_DESCRIPTION1 = PAY_DESCRIPTION1 + "　";

						}
					}
				}
				rs.close();
				strSql = null;
			} catch (SQLException ex) {
				System.err.println(strSql);
				System.err.println("PAY_BATCH_NO='" + entBatNo + "' and A.BAT_SEQ='" + entSeqNo);
				System.err.println(ex.getMessage());
			} finally {
				try {
					if (rs != null) {
						rs.close();
					}
					if (stmt != null) {
						stmt.close();
					}
					if (con != null) {
						dbFactory.releaseAS400Connection(con);
					}
				} catch (Exception ex1) {
					System.err.println("Msg=" + ex1);
				}
			}

			// 受款人ID, x(10)空白
			String custRemitId = rmtVO.getRID();
			for (int count2 = custRemitId.length(); count2 < 10; count2++) {
				custRemitId += " ";
			}

			// 11.保留欄位 x(15)
			String fillerD1 = "";
			for (int count = 0; count < 3; count++) {
				fillerD1 = fillerD1 + " ";
			}

			// 12.匯款幣別,X(3)
			String remitCURR = payCURR;
			for (int count = remitCURR.length(); count < 3; count++) {
				remitCURR = remitCURR + " ";
			}
			System.out.println(remitCURR);
			// 15.保留欄位 x(10)
			String fillerD = "";
			for (int count = 0; count < 10; count++) {
				fillerD = fillerD + " ";
			}

			downloadInfo[index + 1][0] = "2"; // 表明細資料-錄別
			downloadInfo[index + 1][1] = save005; // 發件單位
			downloadInfo[index + 1][2] = save806; // 收件單位
			downloadInfo[index + 1][3] = "257"; // 轉帳類別
			downloadInfo[index + 1][4] = trDateString; // 入/扣帳日
			downloadInfo[index + 1][5] = entAccountNo;// 帳號
			downloadInfo[index + 1][6] = remitAmt; // 交易金額
			downloadInfo[index + 1][7] = "70817744"; // 營利事業統一編號
			downloadInfo[index + 1][8] = "9999"; // 狀況代號
			// 32專用資料區
			downloadInfo[index + 1][9] = POLICY_NO1 + custRemitId; // 摘要代號
			downloadInfo[index + 1][10] = fillerD1; // 空白3
			downloadInfo[index + 1][11] = remitCURR; // 匯款幣別
			downloadInfo[index + 1][12] = "全球人壽"; // 幣別代號
			downloadInfo[index + 1][13] = PAY_DESCRIPTION1; // 中文備註
			downloadInfo[index + 1][14] = fillerD; // 空白欄
			saveIndex = index + 2;
		}
		// -----HEAD-----
		// 空白欄 x(91)
		String fillerH = "";
		for (int count = 0; count < 91; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "1"; // 錄別
		downloadInfo[0][1] = save005; // 發件單位
		downloadInfo[0][2] = save806; // 收件單件
		downloadInfo[0][3] = "257"; // 轉帳類別
		downloadInfo[0][4] = trDateString; // 轉帳日
		downloadInfo[0][5] = "1"; // 資料性質別
		downloadInfo[0][6] = "   "; // 錯誤代碼
		downloadInfo[0][7] = space1; // 保留
		downloadInfo[0][8] = "R"; // 記帳別
		for (int i = 9; i < 15; i++) {
			downloadInfo[0][i] = "";
		}

		// -----FOOT-----
		// 成交總金額X(16)
		String totAmtT = df2.format(saveAmt);
		String totAmt = totAmtT.substring(0, 14) + totAmtT.substring(15, 17);
		// 成交總筆數X(10)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (10 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// 未成交總筆數X(16)放零
		String totAmtF = "";
		for (int count = 0; count < 16; count++) {
			totAmtF = "0" + totAmtF;
		}
		// 未成交總筆數X(10)放零
		String totCountF = "";
		for (int count = 0; count < 10; count++) {
			totCountF = "0" + totCountF;
		}
		// 空白欄 x(41)
		String fillerF = "";
		for (int count = 0; count < 41; count++) {
			fillerF = fillerF + " ";
		}

		downloadInfo[saveIndex][0] = "3"; // 表尾筆
		downloadInfo[saveIndex][1] = save005; // 發件單位
		downloadInfo[saveIndex][2] = save806; // 收件單件
		downloadInfo[saveIndex][3] = "257"; // 轉帳類別
		downloadInfo[saveIndex][4] = trDateString; // 入扣帳日
		downloadInfo[saveIndex][5] = totAmt; // 成交總金額
		downloadInfo[saveIndex][6] = totCount; // 成交總筆數
		downloadInfo[saveIndex][7] = totAmtF; // 未成交總金額
		downloadInfo[saveIndex][8] = totCountF; // 未成交總筆數
		downloadInfo[saveIndex][9] = fillerF; // 空白欄
		downloadInfo[saveIndex][10] = "R"; // 記帳別

		for (int i = 11; i < 15; i++) {
			downloadInfo[saveIndex][i] = "";
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		
		return fileLOC;
	}
	  	
	// R10059 安泰銀行
	private String convertDownloadData816(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";

		//無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		//String[][] downloadInfo = new String[(payments.size() + 2)][8];	//HEAD+LAST
		String[][] downloadInfo = new String[(payments.size() + 2)][11];	//HEAD+LAST,RE0273
		DecimalFormat df = new DecimalFormat("000000000000.00");

		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);	//幣別 2碼轉為3碼
		String remitDate = "";
		double remitAmtNum = 0;
		double saveAmtT = 0;
		double saveAmt = 0;
		int saveCount = 0;

		//DETAIL			
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			//3.轉帳日期 x(7) 出納確認日 YYYMMDD(1000215)
			remitDate = CommonUtil.padLeadingZero(rmtVO.getRMTDT(), 7);

			//4.轉帳帳號 x(14) 匯款銀行帳號
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			StringBuffer sbAccNo = new StringBuffer();
			sbAccNo.append(entAccountNo);
			for(int counter=entAccountNo.length(); counter < 14; counter++) {
				sbAccNo.append(" ");
			}
			entAccountNo = sbAccNo.toString();

			//5.轉帳金額 x(12.2)
			remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			String remitAmtT = df.format(disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE()));
			String remitAmt = remitAmtT.substring(0, 12) + remitAmtT.substring(13, 15);

			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);
			saveCount = index + 1;

			//8.備註 x(14)
			StringBuffer sbNote = new StringBuffer();
			for(int counter=0; counter<14; counter++) {
				sbNote.append(" ");
			}
			
			//10.身份證, x(10)空白
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}

			downloadInfo[index + 1][0] = "2"; 			//區別碼
			downloadInfo[index + 1][1] = "FX027601009"; //轉帳組別
			downloadInfo[index + 1][2] = remitDate; 	//轉帳日期
			downloadInfo[index + 1][3] = entAccountNo; 	//轉帳帳號
			downloadInfo[index + 1][4] = remitAmt; 		//轉帳金額
			downloadInfo[index + 1][5] = "2"; 			//入扣帳碼
			downloadInfo[index + 1][6] = "99"; 			//轉帳狀況
			//downloadInfo[index + 1][7] = sbNote.toString(); //備註
			downloadInfo[index + 1][7] = payCURR; //幣別,//RE0273
			downloadInfo[index + 1][8] = genSpace(32); //用戶註記資料,//RE0273
			downloadInfo[index + 1][9] = custRemitId; //身分證字號,//RE0273
			downloadInfo[index + 1][10] = genSpace(15); //補足空白,//RE0273
			
		}

		StringBuffer sbCusNo = new StringBuffer();
		sbCusNo.append("02710601009300");
		for(int counter=sbCusNo.length(); counter<20; counter++) {
			sbCusNo.append(" ");
		}
		StringBuffer sbNote = new StringBuffer();
		//for(int counter=0; counter<20; counter++) {
		for(int counter=0; counter<70; counter++) {//RE0273
			sbNote.append(" ");
		}

		//HEAD
		downloadInfo[0][0] = "1";			//區別碼
		downloadInfo[0][1] = "FX027601009"; //轉帳組別
		downloadInfo[0][2] = remitDate; 	//轉帳日期
		//downloadInfo[0][3] = "2"; 			//入扣帳碼
		downloadInfo[0][3] = "3"; 			//入扣帳碼,RE0273
		downloadInfo[0][4] = sbCusNo.toString(); //用戶帳號/約定代號
		//downloadInfo[0][5] = " "; 			//備註
		//downloadInfo[0][6] = payCURR; 			//備註
		//downloadInfo[0][7] = sbNote.toString(); //備註
		downloadInfo[0][5] = sbNote.toString(); //備註,//RE0273
		downloadInfo[0][6] = ""; //備註,//RE0273
		downloadInfo[0][7] = ""; //備註,//RE0273
		downloadInfo[0][8] = ""; //備註,//RE0273
		downloadInfo[0][9] = ""; //備註,//RE0273
		downloadInfo[0][10] = ""; //備註,//RE0273

		//LAST
		//6.入帳總筆數 x(5)
		String totCount = CommonUtil.padLeadingZero(saveCount, 5);

		//7.入帳總金額 x(12.2)
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 12) + totAmtT.substring(13, 15);

		//8.備註 x(7)
		sbNote = new StringBuffer();
		//for(int counter=0; counter<7; counter++) {
		for(int counter=0; counter<53; counter++) {
			sbNote.append(" ");
		}

		downloadInfo[payments.size() + 1][0] = "3";				//區別碼
		downloadInfo[payments.size() + 1][1] = "FX027601009";	//轉帳組別
		downloadInfo[payments.size() + 1][2] = remitDate;		//轉帳日期
		downloadInfo[payments.size() + 1][3] = "00000";			//扣帳總筆數
		downloadInfo[payments.size() + 1][4] = "00000000000000";//扣帳總金額
		downloadInfo[payments.size() + 1][5] = totCount;		//入帳總筆數
		downloadInfo[payments.size() + 1][6] = totAmt;			//入帳總金額
		downloadInfo[payments.size() + 1][7] = sbNote.toString();//備註
		downloadInfo[payments.size() + 1][8] = "";//備註,//RE0273
		downloadInfo[payments.size() + 1][9] = "";//備註,//RE0273
		downloadInfo[payments.size() + 1][10] = "";//備註,//RE0273
		

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	// RB0062 彰化銀行外幣匯款檔(跨行)
	private String convertDownloadData009r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 2)][36];
		DecimalFormat df = new DecimalFormat("00000000000000.00");
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CommonUtil commonutil = new CommonUtil(globalEnviron);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Constant.CURRENT_LOCALE);
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);	//兩碼轉三碼幣別
		CaprmtfVO rmtVO;
		String strRMD = "";
		String strTXDATE = "";
		int saveCount = 0;
		double saveAmt = 0;
		double saveAmtT = 0;

		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 1. 區別碼 X(01)
			// 2. 匯款金額 9(12)V9(02)
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(2, 14) + remitAmtT.substring(15, 17);

			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);

			// 8. VALUE DATE X(08) 西元年YYYYMMDD
			String strRemitDate = rmtVO.getRMTDT();	//民國年YYYMMDD
			String strVALDAY = sdf.format(commonutil.convertROC2WestenDate1(strRemitDate));

			strTXDATE = strVALDAY;
			strRMD = strRemitDate;

			// 9. 受款人帳號 X(34)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : CommonUtil.AllTrim(rmtVO.getRACCT());
			for (int count = entAccountNo.length(); count < 34; count++) {
				entAccountNo += " ";
			}

			// 10. 受款人名稱地址一 ~ 四 X(35)
			String strRECNM1 = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			String strRECNM2 = "";
			String strRECNM3 = "";
			String strRECNM4 = "";
			for (int count = strRECNM1.length(); count < 35; count++) {
				strRECNM1 += " ";
			}
			for (int count = strRECNM2.length(); count < 35; count++) {
				strRECNM2 += " ";
			}
			for (int count = strRECNM3.length(); count < 35; count++) {
				strRECNM3 += " ";
			}
			for (int count = strRECNM4.length(); count < 35; count++) {
				strRECNM4 += " ";
			}

			// 14.受款國別代碼 X(02)
			String rmtCountry = (rmtVO.getRBKCOUNTRY() == null) ? "" : CommonUtil.AllTrim(rmtVO.getRBKCOUNTRY()).toUpperCase();
			for (int count = rmtCountry.length(); count < 2; count++) {
				rmtCountry += " ";
			}

			// 16. 受款銀行ABA(RECABA) X(11)
			String strRECABA = "";
			for (int count = strRECABA.length(); count < 11; count++) {
				strRECABA += " ";
			}

			// 17. 受款銀行BIC(RECBIC) X(11)
			String remitSWIFT = (rmtVO.getSWIFTCODE() == null) ? "" : CommonUtil.AllTrim(rmtVO.getSWIFTCODE());
			for (int count = remitSWIFT.length(); count < 11; count++) {
				remitSWIFT += " ";
			}

			// 18. 受款銀行名稱地址一 ~ 四 X(35)
			String strRECBN1 = "";
			String strRECBN2 = "";
			String strRECBN3 = "";
			String strRECBN4 = "";
			for (int count = strRECBN1.length(); count < 35; count++) {
				strRECBN1 += " ";
			}
			for (int count = strRECBN2.length(); count < 35; count++) {
				strRECBN2 += " ";
			}
			for (int count = strRECBN3.length(); count < 35; count++) {
				strRECBN3 += " ";
			}
			for (int count = strRECBN4.length(); count < 35; count++) {
				strRECBN4 += " ";
			}

			// 23. 附言一 ~ 六 X(35)
			String strNOTE1 = "";
			String strNOTE2 = "";
			String strNOTE3 = "";
			String strNOTE4 = "";
			String strNOTE5 = "";
			String strNOTE6 = "";
			for (int count = strNOTE1.length(); count < 35; count++) {
				strNOTE1 += " ";
			}
			for (int count = strNOTE2.length(); count < 35; count++) {
				strNOTE2 += " ";
			}
			for (int count = strNOTE3.length(); count < 35; count++) {
				strNOTE3 += " ";
			}
			for (int count = strNOTE4.length(); count < 35; count++) {
				strNOTE4 += " ";
			}
			for (int count = strNOTE5.length(); count < 35; count++) {
				strNOTE5 += " ";
			}
			for (int count = strNOTE6.length(); count < 35; count++) {
				strNOTE6 += " ";
			}

			// 29. 中介銀行ABA(INTRABA) X(11)
			String strINTRABA = "";
			for (int count = strINTRABA.length(); count < 11; count++) {
				strINTRABA += " ";
			}

			// 30. 中介銀行BIC(INTRBIC) X(11)
			String strINTRBIC = "";
			for (int count = strINTRBIC.length(); count < 11; count++) {
				strINTRBIC += " ";
			}

			// 31. 中介銀行名稱地址一 ~ 四 X(35)
			String strINTRBN1 = "";
			String strINTRBN2 = "";
			String strINTRBN3 = "";
			String strINTRBN4 = "";
			for (int count = strINTRBN1.length(); count < 35; count++) {
				strINTRBN1 += " ";
			}
			for (int count = strINTRBN2.length(); count < 35; count++) {
				strINTRBN2 += " ";
			}
			for (int count = strINTRBN3.length(); count < 35; count++) {
				strINTRBN3 += " ";
			}
			for (int count = strINTRBN4.length(); count < 35; count++) {
				strINTRBN4 += " ";
			}

			// 35. 備註一 ~ 二 X(35)
			String strMEMO1 = "";
			String strMEMO2 = "";
			for (int count = strMEMO1.length(); count < 35; count++) {
				strMEMO1 += " ";
			}
			for (int count = strMEMO2.length(); count < 35; count++) {
				strMEMO2 += " ";
			}

			downloadInfo[index + 1][0] = "2";			// 區別碼 x(01)
			downloadInfo[index + 1][1] = remitAmt;		// 匯款金額 9(12)V9(2)
			downloadInfo[index + 1][2] = "00000000000000"; // 外幣兌換金額 9(12)V9(2)
			downloadInfo[index + 1][3] = "0000000";		// 手續費(基礎幣) 9(05)V9(02)
			downloadInfo[index + 1][4] = "0000000";		// 郵電費(基礎幣) 9(05)V9(02)
			downloadInfo[index + 1][5] = "0000000";		// 其他應付款-大陸(基礎幣) 9(05)V9(02)
			downloadInfo[index + 1][6] = "0000000";		// 國外費用(原幣) 9(05)V9(02)
			downloadInfo[index + 1][7] = strVALDAY;		// VALUE DATE X(08)
			downloadInfo[index + 1][8] = entAccountNo;	// 受款人帳號 X(34)
			downloadInfo[index + 1][9] = strRECNM1;		// 受款人名稱地址一  X(35)
			downloadInfo[index + 1][10] = strRECNM2;	// 受款人名稱地址二  X(35)
			downloadInfo[index + 1][11] = strRECNM3;	// 受款人名稱地址三  X(35)
			downloadInfo[index + 1][12] = strRECNM4;	// 受款人名稱地址四  X(35)
			downloadInfo[index + 1][13] = rmtCountry;	// 受款國別代碼  X(02)
			downloadInfo[index + 1][14] = "1";			// 受款人身分別  X(01)
			downloadInfo[index + 1][15] = strRECABA;	// 受款銀行ABA  X(11)
			downloadInfo[index + 1][16] = remitSWIFT;	// 受款銀行BIC  X(11)
			downloadInfo[index + 1][17] = strRECBN1;	// 受款銀行名稱地址一  X(35)
			downloadInfo[index + 1][18] = strRECBN2;	// 受款銀行名稱地址二  X(35)
			downloadInfo[index + 1][19] = strRECBN3;	// 受款銀行名稱地址三  X(35)
			downloadInfo[index + 1][20] = strRECBN4;	// 受款銀行名稱地址四  X(35)
			downloadInfo[index + 1][21] = "693";		// 匯款分類編號  X(03)
			downloadInfo[index + 1][22] = strNOTE1;		// 附言一  X(35)
			downloadInfo[index + 1][23] = strNOTE2;		// 附言二  X(35)
			downloadInfo[index + 1][24] = strNOTE3;		// 附言三  X(35)
			downloadInfo[index + 1][25] = strNOTE4;		// 附言四  X(35)
			downloadInfo[index + 1][26] = strNOTE5;		// 附言五  X(35)
			downloadInfo[index + 1][27] = strNOTE6;		// 附言六  X(35)
			downloadInfo[index + 1][28] = strINTRABA;	// 中介銀行ABA  X(11)
			downloadInfo[index + 1][29] = strINTRBIC;	// 中介銀行BIC  X(11)
			downloadInfo[index + 1][30] = strINTRBN1;	// 中介銀行名稱地址一  X(35)
			downloadInfo[index + 1][31] = strINTRBN2;	// 中介銀行名稱地址二  X(35)
			downloadInfo[index + 1][32] = strINTRBN3;	// 中介銀行名稱地址三  X(35)
			downloadInfo[index + 1][33] = strINTRBN4;	// 中介銀行名稱地址四  X(35)
			downloadInfo[index + 1][34] = strMEMO1;		// 備註一  X(35)
			downloadInfo[index + 1][35] = strMEMO2;		// 備註二  X(35)

			saveCount = index + 1;
		}

		// -----HEAD-----

		// 7. 匯款人統一編號 X(11)
		String strIDNO = "70817744";
		for (int count = strIDNO.length(); count < 11; count++) {
			strIDNO += " ";
		}

		// 9. 基礎幣活存帳號 X(14)
		String strBPBACT = "";
		for (int count = strBPBACT.length(); count < 14; count++) {
			strBPBACT += " ";
		}

		// 10. 議價編號 X(13)
		String strEXNO = "";
		for (int count = strEXNO.length(); count < 13; count++) {
			strEXNO += " ";
		}

		// 11. 遠匯契約編號 X(14)
		String strFXNO = "";
		for (int count = strFXNO.length(); count < 14; count++) {
			strFXNO += " ";
		}

		downloadInfo[0][0] = "1";				// 區別碼 X(01)
		downloadInfo[0][1] = "666F5185";		// 發件單位 X(08)
		downloadInfo[0][2] = strTXDATE;			// 匯款日期 X(08)
		downloadInfo[0][3] = "01";				// 交易批號 X(02)
		downloadInfo[0][4] = "1";				// OBU記號 X(01)
		downloadInfo[0][5] = payCURR;			// 幣別 X(03)
		downloadInfo[0][6] = strIDNO;			// 匯款人統一編號 X(11)
		downloadInfo[0][7] = "21132239980600";	// 原幣活存帳號 X(14)
		downloadInfo[0][8] = strBPBACT;			// 基礎幣活存帳號 X(14)
		downloadInfo[0][9] = strEXNO;			// 議價編號 X(13)
		downloadInfo[0][10] = strFXNO;			// 遠匯契約編號 X(14)
		downloadInfo[0][11] = "73";				// 匯款方式 X(02)
		
		for (int i = 12; i < 36; i++) {
			downloadInfo[0][i] = "";
		}

		// -----FOOT-----

		// 2. 匯出總筆數 9(04)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (4 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}

		// 3. 匯出總金額 9(14)V9(02)
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 14) + totAmtT.substring(15, 17);

		downloadInfo[saveCount+1][0] = "3";					// 區別碼 X(01)
		downloadInfo[saveCount+1][1] = totCount;			// 匯出總筆數 9(04)
		downloadInfo[saveCount+1][2] = totAmt;				// 匯出總金額 9(14)V9(02)
		downloadInfo[saveCount+1][3] = totAmt;				// 自備外匯總金額 9(14)V9(02)
		downloadInfo[saveCount+1][4] = "0000000000000000";	// 結購外匯總金額 9(14)V9(02)
		downloadInfo[saveCount+1][5] = "00000000";			// 手續費總金額 9(06)V9(02)
		downloadInfo[saveCount+1][6] = "00000000";			// 郵電費總金額 9(06)V9(02)
		
		for (int i = 7; i < 36; i++) {
			downloadInfo[saveCount+1][i] = "";
		}

		String strBatchNo = BATNO.substring(0, 1) + strRMD + BATNO.substring(8);

		fileLOC = disbBean.writeTOfile(downloadInfo, strBatchNo, selCURR, remitKind, strLogonUser);

		return fileLOC;
	}

	// RB0062 彰化銀行外幣轉帳檔(聯行)
	private String convertDownloadData009t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 2)][18];
		DecimalFormat df = new DecimalFormat("00000000000000.00");
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CommonUtil commonutil = new CommonUtil(globalEnviron);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Constant.CURRENT_LOCALE);
		CaprmtfVO rmtVO = null;
		double saveAmt = 0;
		double saveAmtT = 0;// R70455
		int saveCount = 0;
		String saveRMDT = "";

		String strSql = "SELECT FLD0029 FROM ORDUNA WHERE FLD0001='  ' AND FLD0002=? ";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = dbFactory.getAS400Connection("DISBRemitExportServlet.convertDownloadData009t");
			pstmt = con.prepareStatement(strSql);
		} catch(SQLException ex) {
			System.err.println(ex.getMessage());
		}

		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 5. 日期 9(08)
			String strRemitDate = rmtVO.getRMTDT();
			String strRMDT = sdf.format(commonutil.convertROC2WestenDate1(strRemitDate));

			saveRMDT = strRMDT;

			// 8. 空白欄 X(05)
			String strEmpty = "";
			for(int count = strEmpty.length(); count < 5; count++) {
				strEmpty += " ";
			}

			// 9. 銀行帳號 9(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo += " ";
			}

			// 10. 金額 9(14)V9(02)
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(2, 14) + remitAmtT.substring(15, 17);

			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);

			// 12. 交易註記(1) X(10)
			String strRemark1 = "全球人壽";
			byte[] bytRemark = strRemark1.getBytes();
			String strFill = "";
			for (int count = bytRemark.length; count < 10; count++) {
				strFill += " ";
			}
			strRemark1 += strFill;

			// 13. 交易註記(2) X(10)
			String strRemark2 = "";
			for (int count = strRemark2.length(); count < 10; count++) {
				strRemark2 += " ";
			}

			// 14. 身份證字號 X(10)
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}

			// 15. 專用資料區 X(20)
			String strField15 = "";
			for (int count = strField15.length(); count < 20; count++) {
				strField15 += " ";
			}

			// 16. 身份證檢核記號 X(01)
			String customIdType = "N";
			try {
				pstmt.clearParameters();
				pstmt.setString(1, CommonUtil.AllTrim(rmtVO.getRID()));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					if(rs.getString("FLD0029").equalsIgnoreCase("C") || rs.getString("FLD0029").equalsIgnoreCase("F") || rs.getString("FLD0029").equalsIgnoreCase("M")) {
						customIdType = "Y"; // 公司戶或個人戶
					}
				}
			} catch(SQLException ex) {
				System.err.println(ex.getMessage());
			}

			// 17. 幣別 X(02)
			String payCurr = selCURR.equals("NT") ? "" : disbBean.getETableDesc("CURR7", selCURR);
			for(int count=payCurr.length(); count < 2 ; count++) {
				payCurr += " ";
			}

			// 18. 空白欄 X(21)
			String strField18 = "";
			for (int count = strField18.length(); count < 21; count++) {
				strField18 += " ";
			}
			
			downloadInfo[index + 1][0] = "2";			// 區別碼 9(01)
			downloadInfo[index + 1][1] = "666";			// 企業編號(1) 9(03)
			downloadInfo[index + 1][2] = "F";			// 企業編號(2) X(01)
			downloadInfo[index + 1][3] = "5185";		//分行代號 9(04)
			downloadInfo[index + 1][4] = strRMDT;		// 日期 9(08)
			downloadInfo[index + 1][5] = "2";			// 存提代號 9(01)
			downloadInfo[index + 1][6] = "097";			// 摘要 9(03)
			downloadInfo[index + 1][7] = strEmpty;		// 空白欄 X(05)
			downloadInfo[index + 1][8] = entAccountNo;	// 銀行帳號 9(14)
			downloadInfo[index + 1][9] = remitAmt;		// 金額 9(14)V9(02)
			downloadInfo[index + 1][10] = "99";			// 狀況代號 9(02)
			downloadInfo[index + 1][11] = strRemark1;	// 交易註記(1) X(10)
			downloadInfo[index + 1][12] = strRemark2;	// 交易註記(2) X(10)
			downloadInfo[index + 1][13] = custRemitId;	// 身份證字號 X(10)
			downloadInfo[index + 1][14] = strField15;	// 專用資料區 X(20)
			downloadInfo[index + 1][15] = customIdType;	// 身份證檢核記號 X(01)
			downloadInfo[index + 1][16] = payCurr;		// 幣別 X(02)
			downloadInfo[index + 1][17] = strField18;	// 空白欄 X(21)

			saveCount = index + 1;
		}

		// -----HEAD-----

		// 8. 磁片來源 X(05)
		String strDiskSource = "CHB";
		for (int count = strDiskSource.length(); count < 5; count++) {
			strDiskSource += " ";
		}

		// 10. 公司統一編號 X(10)
		String strCompany = "70817744";
		for (int count = strCompany.length(); count < 10; count++) {
			strCompany += " ";
		}
		
		// 11. 公司帳號  
		// QC0272
		String payCurr = selCURR.equals("NT") ? "" : disbBean.getETableDesc("CURR7", selCURR);
		for(int count=payCurr.length(); count < 2 ; count++) {
			payCurr += " ";
		}
		
		String strPacct = "";
		if (!payCurr.equals("22")) {
		   strPacct = "21132239980600" ;	
		}else{
		   strPacct = "21132239980605" ;
		}

		// 12. 保留欄 X(79)
		String strField12 = "";
		for (int count = strField12.length(); count < 79; count++) {
			strField12 += " ";
		}

		downloadInfo[0][0] = "1";			// 區別碼 9(01)
		downloadInfo[0][1] = "666";			// 企業編號(1) 9(03)
		downloadInfo[0][2] = "F";			// 企業編號(2) X(01)
		downloadInfo[0][3] = "5185";		//分行代號 9(04)
		downloadInfo[0][4] = saveRMDT;		// 日期 9(08)
		downloadInfo[0][5] = "2";			// 存提代號 9(01)
		downloadInfo[0][6] = "097";			// 摘要 9(03)
		downloadInfo[0][7] = strDiskSource; // 磁片來源 X(05)
		downloadInfo[0][8] = "1"; 			// 性質別 9(01)
		downloadInfo[0][9] = strCompany; 	// 公司統一編號 X(10)
		//downloadInfo[0][10] = "21132239980600";// 公司帳號 X(14)
		downloadInfo[0][10] = strPacct;// 公司帳號 X(14) QC0272
		downloadInfo[0][11] = strField12; 	// 保留欄 X(79)

		for (int i = 12; i < 18; i++) {
			downloadInfo[0][i] = "";
		}

		// -----FOOT-----

		// 8. 空白欄 X(05)
		String strEmpty = "";
		for(int count = strEmpty.length(); count < 5; count++) {
			strEmpty += " ";
		}

		// 9. 總金額 9(14)V9(02)
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 14) + totAmtT.substring(15, 17);

		// 2. 匯出總筆數 9(10)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (10 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}

		// 13. 空白欄 X(52)
		String strField = "";
		for(int count = strField.length(); count < 52; count++) {
			strField += " ";
		}

		downloadInfo[saveCount+1][0] = "3";			// 區別碼 9(01)
		downloadInfo[saveCount+1][1] = "666";		// 企業編號(1) 9(03)
		downloadInfo[saveCount+1][2] = "F";			// 企業編號(2) X(01)
		downloadInfo[saveCount+1][3] = "5185";		//分行代號 9(04)
		downloadInfo[saveCount+1][4] = saveRMDT;	// 日期 9(08)
		downloadInfo[saveCount+1][5] = "2";			// 存提代號 9(01)
		downloadInfo[saveCount+1][6] = "097";		// 摘要 9(03)
		downloadInfo[saveCount+1][7] = strEmpty;	// 空白欄 X(05)
		downloadInfo[saveCount+1][8] = totAmt;		// 總金額 9(14)V9(02)
		downloadInfo[saveCount+1][9] = totCount;	// 總筆數 9(10)
		downloadInfo[saveCount+1][10] = "0000000000000000";	// 未成交總金額 9(14)V9(02)
		downloadInfo[saveCount+1][11] = "0000000000";// 未成交總筆數 9(8)V9(02)
		downloadInfo[saveCount+1][12] = strField;	// 空白欄 X(52)

		for (int i = 13; i < 18; i++) {
			downloadInfo[saveCount+1][i] = "";
		}

		try {
			if(pstmt != null)
				pstmt.close();
			if(con != null)
				dbFactory.releaseAS400Connection(con);
		} catch(Exception ex) {
			ex.printStackTrace();
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	//EB0537 萬泰銀行 (跨行匯匯款不需產生檔案)
	private String convertDownloadData809t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[payments.size()][16];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);	//兩碼轉三碼幣別
		
		//RD0144,修改萬泰人民幣CNY為CNH
		if("CN".equals(payCURR.substring(0,2))){
			payCURR = payCURR.substring(0,2) + "H";
		}		 

		String strSeq = "2" + BATNO.substring(4, 8) + "001";
		int iDataSeq = 1;

		CaprmtfVO rmtVO = null;
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			if(!rmtVO.getPBK().substring(0, 3).equals(rmtVO.getRBK().substring(0, 3))) {
				downloadInfo = null;
				break;
			}
			
			// 交易日期x(8) 西元年
			String remitDate = rmtVO.getRMTDT();
			remitDate = String.valueOf(Integer.parseInt(remitDate) + 19110000);

			//保險公司帳號x(12)
			String strAccount = CommonUtil.AllTrim(rmtVO.getPACCT());
			if(strAccount.length() > 12) {
				strAccount = strAccount.substring(0, 12);
			}
			for (int counter=strAccount.length(); counter < 12; counter++) {
				strAccount += " ";
			}

			//序號9(6)
			String strDataSeq = String.valueOf(iDataSeq);
			for(int counter=strDataSeq.length(); counter<5; counter++) {
				strDataSeq = "0" + strDataSeq;
			}
			strDataSeq = "2" + strDataSeq;

			//受款人外幣帳號x(12)
			String entAccountNo = CommonUtil.AllTrim(rmtVO.getRACCT());
			if(entAccountNo.length() > 12) {
				entAccountNo = entAccountNo.substring(0, 12);
			}
			for (int count = entAccountNo.length(); count < 12; count++) {
				entAccountNo += " ";
			}
			
			// 受款人統一編號x(11)
			String custRemitId = CommonUtil.AllTrim(rmtVO.getRID());
			for (int counter = custRemitId.length(); counter < 11; counter++) {
				custRemitId += " ";
			}
			
			// 交易金額9(13)v99
			String remitAmt = String.valueOf(rmtVO.getRAMT());
			// 處理小數點"." 即 999.00-->99900
			if (remitAmt.indexOf(".") > 0) {
				remitAmt = remitAmt.substring(0, remitAmt.indexOf("."));
			}
			remitAmt += "00";
			for(int counter=remitAmt.length(); counter<15; counter++) {
				remitAmt = "0" + remitAmt;
			}

			//空白x(20)
			String strField13 = "";
			for (int counter = strField13.length(); counter < 20; counter++) {
				strField13 += " ";
			}
			//回覆訊息代號x(6)
			String strField14 = "";
			for (int counter = strField14.length(); counter < 6; counter++) {
				strField14 += " ";
			}
			//回覆訊息欄位x(120)
			String strField15 = "";
			for (int counter = strField15.length(); counter < 120; counter++) {
				strField15 += " ";
			}
			//保留欄位x(63)
			String strField16 = "";
			for (int counter = strField16.length(); counter < 63; counter++) {
				strField16 += " ";
			}

			iDataSeq++;
			
			downloadInfo[index][0] = "IN";	// 業務類別, 保費帳務作業
			downloadInfo[index][1] = "TG";	// 保險公司代號
			downloadInfo[index][2] = strSeq;// 批號
			downloadInfo[index][3] = remitDate;	// 交易日期
			downloadInfo[index][4] = strAccount;// 保險公司帳號
			downloadInfo[index][5] = "70817744   ";// 保險公司統一編號
			downloadInfo[index][6] = payCURR;	// 幣別
			downloadInfo[index][7] = strDataSeq;// 序號
			downloadInfo[index][8] = "+";		// 借貸別, 存入
			downloadInfo[index][9] = entAccountNo;	// 受款人外幣帳號
			downloadInfo[index][10] = custRemitId;	// 受款人統一編號
			downloadInfo[index][11] = remitAmt;		// 交易金額
			downloadInfo[index][12] = strField13;	//保單號碼, 交易編號
			downloadInfo[index][13] = strField14;	// 回覆訊息代號
			downloadInfo[index][14] = strField15;	// 回覆訊息欄位
			downloadInfo[index][15] = strField16;	// 保留欄位
		}
		if(downloadInfo != null)
			fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);

		return fileLOC;
	}

	//RD0440臺灣銀行,參考convertDownloadData007(),可參考convertDownloadData009t()彰銀有header & detail
	private String convertDownloadData004t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		//產生台銀轉帳檔
		String fileLOC = "";
		
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		// layout 應為 21 欄位, 但 \r\n 後面程式會自動做, 可以省略
		String[][] downloadInfo = new String[payments.size()+1][21];
		DecimalFormat df = new DecimalFormat("0000000000.00");
		DecimalFormat df1 = new DecimalFormat("0000000000000");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		
		double remitAmtNumSum = 0;
		int remitCount = 0;
		String remitDateTmp = "";
		boolean remitDataChange = false;
		//明細資料
		for (int index = 0; index < payments.size(); index++) {			
			rmtVO = (CaprmtfVO) payments.get(index);
			
			//帳號
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 16){
				entAccountNo = entAccountNo.substring(0, 16);
			}else if(entAccountNo.length() < 16){
				entAccountNo += genSpace(16-entAccountNo.length());
			}
				
			
			//統編/身分字號
			String custID = CommonUtil.AllTrim(rmtVO.getRID());			
			
			//匯款金額		
			//log.info("rmtVO.getRPAYAMT()是" + rmtVO.getRPAYAMT() + ",rmtVO.getRBENFEE()是" + rmtVO.getRBENFEE());
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			//log.info("remitAmtNum是" + remitAmtNum);
			String remitAmt = df.format(remitAmtNum);
			remitAmt = remitAmt.replace(".", "");
			remitAmt = df1.format(Double.valueOf(remitAmt));
			
			//主辦行
			String pBank = rmtVO.getPBK();
			String pBranck;
			if (pBank == null)
				pBranck = "   ";
			else {
				// 若不足 6 位, 先補足再取
				if (pBank.length() < 6)
					pBank = pBank + "      ".substring(0, 6 - pBank.length());
				pBranck = pBank.substring(3, 6);
			}

			//預定及實際入帳日
			String remitDate = rmtVO.getRMTDT();
			if(index >0  && !remitDataChange){
				if(!remitDateTmp.equals(remitDate)) remitDataChange = true;
			}
			remitDateTmp = remitDate;
			downloadInfo[index+1][0] = "2"; //資料格式,1
			downloadInfo[index+1][1] = String.format("%06d", new Integer(index+1)); //流水編號,2
			downloadInfo[index+1][2] = genSpace(4); //保留,3
			downloadInfo[index+1][3] = entAccountNo; //帳號,4
			downloadInfo[index+1][4] = "1"; //入扣帳記號,5
			downloadInfo[index+1][5] = remitAmt; //金額,6
			downloadInfo[index+1][6] = remitDate; //入扣帳日,7
			downloadInfo[index+1][7] = String.format("%07d", new Integer(0)); //實際入扣帳日,8
			downloadInfo[index+1][8] = "全球人壽" + genSpace(8); //備註,9
			downloadInfo[index+1][9] = genSpace(10); //保留,10
			downloadInfo[index+1][10] = custID; //統編/身分字號,11
			downloadInfo[index+1][11] = genSpace(2); //處理結果,12
			downloadInfo[index+1][12] = genSpace(20); //帳單銷帳資料1,13
			downloadInfo[index+1][13] = genSpace(20); //帳單銷帳資料2,14
			downloadInfo[index+1][14] = genSpace(60); //委託單位自用資料,15
			downloadInfo[index+1][15] = genSpace(7); //保留,16
			downloadInfo[index+1][16] = ""; //補齊downloadInfo
			downloadInfo[index+1][17] = ""; //補齊downloadInfo
			downloadInfo[index+1][18] = ""; //補齊downloadInfo
			downloadInfo[index+1][19] = ""; //補齊downloadInfo
			downloadInfo[index+1][20] = ""; //補齊downloadInfo
			
			remitAmtNumSum += remitAmtNum;
			remitCount++;
		}//end for

		//首筆資料
		downloadInfo[0][0] = "1"; //資料格式,1
		downloadInfo[0][1] = String.format("%07d", new Integer(2360015)); //客戶代號,2
		downloadInfo[0][2] = "Z15"; //轉帳類別,3
		downloadInfo[0][3] = "70817744" + genSpace(2); //統一編號,4
		if(remitDataChange){
			downloadInfo[0][4] = String.format("%07d", new Integer(0)); //入扣帳日,5
		}else{
			downloadInfo[0][4] = String.format("%07d", Integer.valueOf(remitDateTmp)); //入扣帳日,5
		}		
		
		String remitAmtNumSumStr = df.format(remitAmtNumSum);
		remitAmtNumSumStr = remitAmtNumSumStr.replace(".", "");
		remitAmtNumSumStr = df1.format(Double.valueOf(remitAmtNumSumStr));
		
		downloadInfo[0][5] = "1"; //入扣帳記號,6
		downloadInfo[0][6] = "全球人壽" + genSpace(16-"全球人壽".getBytes().length); //統一備註,7
		downloadInfo[0][7] = genSpace(10); //保留,8
		downloadInfo[0][8] = getCurrencyCode(selCURR); //幣別,9
		downloadInfo[0][9] = String.format("%06d", new Integer(0)); //扣帳總筆數,10
		downloadInfo[0][10] = df1.format(0); //扣帳總金額,11
		downloadInfo[0][11] = String.format("%06d", new Integer(remitCount)); //入帳總筆數,12
		downloadInfo[0][12] = remitAmtNumSumStr; //入帳總金額,13
		downloadInfo[0][13] = String.format("%06d", new Integer(0)); //扣帳失敗總筆數,14
		downloadInfo[0][14] = df1.format(0); //扣帳失敗總金額,15
		downloadInfo[0][15] = String.format("%06d", new Integer(0)); //入帳失敗總筆數,16
		downloadInfo[0][16] = df1.format(0); //入帳失敗總金額,17
		downloadInfo[0][17] = "9"; //狀態,18
		downloadInfo[0][18] = "                    695TW A" + genSpace(48-"                    695TW A".length()); //委託單位自用資料,19
		downloadInfo[0][19] = genSpace(13); //上傳批號,20
		downloadInfo[0][20] = genSpace(5); //保留,21
		
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}
	
	private String convertDownloadData004r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		//產生台銀匯款檔
		String fileLOC = "";
		
		// 無資料不處理
		if (payments.size() <= 0)
			return fileLOC;

		// layout 應為 21 欄位, 但 \r\n 後面程式會自動做, 可以省略
		String[][] downloadInfo = new String[payments.size()+1][21];
		DecimalFormat dfFirst = new DecimalFormat("0000000000.00");
		DecimalFormat dfFirst1 = new DecimalFormat("0000000000.00");
		DecimalFormat df = new DecimalFormat("0.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		
		double remitAmtNumSum = 0;
		int remitCount = 0;
		String remitDateTmp = "";
		boolean remitDataChange = false;
		//明細資料
		for (int index = 0; index < payments.size(); index++) {
			
			rmtVO = (CaprmtfVO) payments.get(index);
			
			//帳號
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 34){
				entAccountNo = entAccountNo.substring(0, 34);
			}else if(entAccountNo.length() < 34){
				entAccountNo += genSpace(16-entAccountNo.length());
			}
				
			
			//統編/身分字號
			String custID = CommonUtil.AllTrim(rmtVO.getRID());	
			
			//中文姓名
			String custName = CommonUtil.AllTrim(rmtVO.getRNAME());
			
			//英文姓名
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			
			//匯款金額			
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmt = df.format(remitAmtNum);
			
			//SWIFT CODE
			String swiftCode = rmtVO.getSWIFTCODE() == null ? "" : rmtVO.getSWIFTCODE();
			
			//匯款行
			String rbk = rmtVO.getRBK() == null ? "" : rmtVO.getRBK().substring(0, 3);
			
			//主辦行
			String pBank = rmtVO.getPBK();
			String pBranck;
			if (pBank == null)
				pBranck = "   ";
			else {
				// 若不足 6 位, 先補足再取
				if (pBank.length() < 6)
					pBank = pBank + "      ".substring(0, 6 - pBank.length());
				pBranck = pBank.substring(3, 6);
			}

			//預定及實際入帳日
			String remitDate = rmtVO.getRMTDT();
			if(index >0 && !remitDataChange){
				if(!remitDateTmp.equals(remitDate)) remitDataChange = true;
			}
			remitDateTmp = remitDate;
			downloadInfo[index+1][0] = String.format("%4d", new Integer(index+1)); //編號,1
			downloadInfo[index+1][1] = genSpace(1); //未使用,2
			downloadInfo[index+1][2] = "TransGlobe Life Insurance Inc." + genSpace(40); //匯款申請人名稱,3
			downloadInfo[index+1][3] = "16F, No.288, Sec. 6, Civic Blvd., Taipei City 110, Taiwan, R.O.C." + genSpace(5); //匯款申請人地址,4
			downloadInfo[index+1][4] = "70817744" + genSpace(2); //匯款人證號,5
			downloadInfo[index+1][5] = "TW"; //受款人國別,6
			downloadInfo[index+1][6] = "693"; //匯款分類編號,7
			downloadInfo[index+1][7] = "A"; //收款行SWIFT格式,8
			downloadInfo[index+1][8] = swiftCode + genSpace(105-swiftCode.length()); //收款行名稱及地址/SWIFT CODE,9
			downloadInfo[index+1][9] = genSpace(30); //收款行銀行編號,10
			downloadInfo[index+1][10] = entNameT + genSpace(70 - entNameT.getBytes().length); //收款人名稱,11
			downloadInfo[index+1][11] = genSpace(70); //收款人地址,12
			downloadInfo[index+1][12] = entAccountNo + genSpace(34-entAccountNo.length()); //收款人帳號,13
			downloadInfo[index+1][13] = genSpace(12-remitAmt.length()) + remitAmt; //匯款金額,14
			downloadInfo[index+1][14] = genSpace(140); //備註,15
			downloadInfo[index+1][15] = ""; //補齊downloadInfo
			downloadInfo[index+1][16] = ""; //補齊downloadInfo
			downloadInfo[index+1][17] = ""; //補齊downloadInfo
			downloadInfo[index+1][18] = ""; //補齊downloadInfo
			downloadInfo[index+1][19] = ""; //補齊downloadInfo
			downloadInfo[index+1][20] = ""; //補齊downloadInfo
			
			remitAmtNumSum += remitAmtNum;
			remitCount++;
		}//end for

		//首筆資料
		String Field00 = "編號";
		String Field01 = " ";
		String Field02 = "匯款申請人名稱                                                        ";
		String Field03 = "匯款申請人地址                                                        ";
		String Field04 = "匯款人證號";
		String Field05 = "國";
		String Field06 = "匯  ";
		String Field07 = "SWIFT_CODE                                                                                               ";
		String Field08 = "";
		String Field09 = "收款行銀行編號                ";
		String Field10 = "收款人名稱                                                            ";
		String Field11 = "收款人地址                                                            ";
		String Field12 = "收款人帳號                        ";
		String Field13 = "匯款金額    ";
		String Field14 = "備註                                                                                                                                        ";
		
		downloadInfo[0][0] = Field00;
		downloadInfo[0][1] = Field01;
		downloadInfo[0][2] = Field02;
		downloadInfo[0][3] = Field03;
		downloadInfo[0][4] = Field04;
		downloadInfo[0][5] = Field05;
		downloadInfo[0][6] = Field06;
		downloadInfo[0][7] = Field07;
		downloadInfo[0][8] = Field08;
		downloadInfo[0][9] = Field09;
		downloadInfo[0][10] = Field10;
		downloadInfo[0][11] = Field11;
		downloadInfo[0][12] = Field12;
		downloadInfo[0][13] = Field13;
		downloadInfo[0][14] = Field14;
		downloadInfo[0][15] = ""; //補齊downloadInfo
		downloadInfo[0][16] = ""; //補齊downloadInfo
		downloadInfo[0][17] = ""; //補齊downloadInfo
		downloadInfo[0][18] = ""; //補齊downloadInfo
		downloadInfo[0][19] = ""; //補齊downloadInfo
		downloadInfo[0][20] = ""; //補齊downloadInfo
		
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}
	
	public String genSpace(int num){
		StringBuffer sb = new StringBuffer();
		for(int i=0; i<num; i++){
			sb.append(" ");
		}
		return sb.toString();
	}
	
	public String getCurrencyCode(String curr){
		String ret = "00";
		ret = (String) getCurrencyHash().get(curr);
		return ret;
	}
	
	public static Map getCurrencyHash(){
		Map currencyMap = new HashMap();
		currencyMap.put("TW", "00");
		currencyMap.put("US", "01");
		currencyMap.put("HK", "02");
		currencyMap.put("MY", "03");
		currencyMap.put("GB", "04");
		currencyMap.put("AU", "05");
		currencyMap.put("CA", "06");
		currencyMap.put("FR", "07");
		currencyMap.put("DE", "08");
		currencyMap.put("IT", "09");
		currencyMap.put("SG", "10");
		currencyMap.put("CH", "11");
		currencyMap.put("BE", "12");
		currencyMap.put("JP", "13");
		currencyMap.put("AT", "14");
		currencyMap.put("NL", "15");
		currencyMap.put("ZA", "16");
		currencyMap.put("SE", "17");
		currencyMap.put("ZN", "18");
		currencyMap.put("TH", "19");
		currencyMap.put("PH", "20");
		currencyMap.put("ID", "21");
		currencyMap.put("EU", "22");
		currencyMap.put("ES", "23");
		currencyMap.put("KR", "24");		
		currencyMap.put("CN", "25");
		
		return currencyMap;
	}
	
	//Clean up resources
	public void destroy() {
	}
}