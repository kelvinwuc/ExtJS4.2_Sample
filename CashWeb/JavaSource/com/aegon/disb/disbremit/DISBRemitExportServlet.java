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
 * RD0440-�s�W�~�����w�Ȧ�-�x�W�Ȧ�:�Ȧ�״���TXT
 */
/**
 * System   : CashWeb
 * 
 * Function : ���״�
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
 * $RD0440-�s�W�~�����w�Ȧ�-�x�W�Ȧ�
 * $
 * $$Log: DISBRemitExportServlet.java,v $
 * $Revision 1.38  2015/12/03 02:41:38  001946
 * $*** empty log message ***
 * $
 * $Revision 1.37  2015/11/24 04:14:42  001946
 * $*** empty log message ***
 * $
 * $Revision 1.36  2015/04/30 02:19:42  001946
 * $RD0144-�Ͱ�Ȧ��ܧ�H�����N����SWIFT CODE
 * $
 * $Revision 1.35  2015/01/19 02:33:50  MISDAVID
 * $RD0020����H�U�״��ɷs�W����ʽ���O�T�w����S
 * $
 * $Revision 1.33  2014/10/07 06:25:11  misariel
 * $RC0036-�ץ���ǲŸ������D
 * $
 * $Revision 1.32  2014/08/19 04:04:08  missteven
 * $RC0036-2
 * $
 * $Revision 1.31  2014/08/08 03:41:34  missteven
 * $RC0036
 * $
 * $Revision 1.30  2014/07/18 07:17:26  misariel
 * $EC0342-RC0036�s�W�����q��F�H���ϥ�CAPSIL
 * $
 * $Revision 1.29  2014/02/26 06:39:32  MISSALLY
 * $EB0537 --- �s�W�U���Ȧ欰�~�����w�Ȧ�
 * $
 * $Revision 1.28  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH�~�ױM��-02
 * $
 * $Revision 1.27  2013/04/18 02:09:26  MISSALLY
 * $RA0074 FNE�����ͦs�����q�H�b��ε��I
 * $�ץ����H�״���
 * $
 * $Revision 1.26  2013/03/29 09:55:05  MISSALLY
 * $RB0062 PA0047 - �s�W���w�Ȧ� ���ƻȦ�
 * $
 * $Revision 1.25  2013/02/26 10:15:02  ODCWilliam
 * $william wu
 * $RA0074
 * $
 * $Revision 1.24  2013/01/08 04:24:03  MISSALLY
 * $�N���䪺�{��Merge��HEAD
 * $
 * $Revision 1.23.4.2  2012/12/06 06:28:27  MISSALLY
 * $RA0102�@PA0041
 * $�t�X�k�O�ק�S����I�@�~
 * $
 * $Revision 1.23.4.1  2012/09/06 02:03:47  MISSALLY
 * $RA0140---�s�W���׬��~�����w��A�̾ڻȦ�n�D�վ����N��
 * $
 * $Revision 1.23  2012/07/17 02:50:31  MISSALLY
 * $RA0043 / RA0081
 * $1.�@�ȥx�s�U���ɮ榡�վ�
 * $2.���ڮw�s���֭��v����Ū�]�w
 * $
 * $Revision 1.22  2011/11/08 09:16:39  MISSALLY
 * $Q10312
 * $�״ڥ\��-���״ڧ@�~
 * $1.�ץ��Ȧ�b�����@�P
 * $2.�վ���׶״���
 * $
 * $Revision 1.21  2011/04/22 01:46:26  MISSALLY
 * $R10068-P00026
 * $�s�W�w���Ȧ欰�~�׫��w�����O�ΤU���ɳ]�w
 * $
 * $Revision 1.20  2011/04/13 08:51:28  MISJIMMY
 * $R00566--���j�Ȧ�s�W�״���
 * $
 * $Revision 1.19  2010/11/23 06:50:41  MISJIMMY
 * $R00226-�ʦ~�M��
 * $
 * $Revision 1.18  2010/05/05 09:20:50  missteven
 * $R90735 FIX BUG
 * $
 * $Revision 1.17  2010/05/04 07:14:39  missteven
 * $R90735
 * $
 * $Revision 1.16  2008/08/12 06:57:03  misvanessa
 * $R80480_�W���Ȧ�~�������s�ɮ�
 * $
 * $Revision 1.15  2008/08/06 06:54:29  MISODIN
 * $R80338 �վ�CASH�t�� for �X�ǥ~���@��@�ݨD
 * $
 * $Revision 1.14  2008/06/12 09:41:35  misvanessa
 * $R80300_�������x�s,�s�W�W���ɮפγ���
 * $
 * $Revision 1.13  2008/04/30 07:48:45  misvanessa
 * $R80300_�������x�s,�s�W�U���ɮפγ���
 * $
 * $Revision 1.12  2007/09/07 10:25:20  MISVANESSA
 * $R70455_TARGET OUT
 * $
 * $Revision 1.11  2007/08/28 01:40:11  MISVANESSA
 * $R70574_SPUL�t���s�W�ץX�ɮ�
 * $
 * $Revision 1.10  2007/05/02 07:15:16  MISVANESSA
 * $R70088_SPUL�t�����H.���׮榡
 * $
 * $Revision 1.9  2007/03/16 01:44:19  MISVANESSA
 * $R70088_���׮榡�ק�
 * $
 * $Revision 1.8  2007/03/06 01:33:37  MISVANESSA
 * $R70088_SPUL�t���s�W�Ȥ�t�����O
 * $
 * $Revision 1.7  2007/01/31 08:01:31  MISVANESSA
 * $R70088_SPUL�t��
 * $
 * $Revision 1.6  2007/01/16 07:48:41  MISVANESSA
 * $R60550_����覡�ק�
 * $
 * $Revision 1.5  2007/01/05 07:24:01  MISVANESSA
 * $R60550_�ץX�ɮ�.����ק�
 * $
 * $Revision 1.4  2007/01/04 03:15:29  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.3  2006/11/30 09:15:14  MISVANESSA
 * $R60550_�t�XSPUL&�~���I�ڭק�
 * $
 * $Revision 1.2  2006/09/04 09:43:35  miselsa
 * $R60747_1.���״ڼW�[�X�ǽT�{�� 2.�ץX����״ڤ���אּ�X�ǽT�{�� 3.��I�d�ߥI�ڤ�����X�ǽT�{��
 * $
 * $Revision 1.1  2006/06/29 09:40:20  MISangel
 * $Init Project
 * $
 * $Revision 1.1.2.8  2006/04/28 02:08:38  misangel
 * $R50891:VA�����O��-��ܹ��O(�ק���B�W�L�d�U�ýX)
 * $
 * $Revision 1.1.2.7  2006/04/27 09:25:45  misangel
 * $R50891:VA�����O��-��ܹ��O
 * $
 * $Revision 1.1.2.6  2005/09/16 01:39:23  misangel
 * $R50427 : �״ڥ�̳���+�m�W+�b���X��(�ץ��״ڧǸ�)
 * $
 * $Revision 1.1.2.5  2005/08/19 06:56:18  misangel
 * $R50427 : �״ڥ�̳���+�m�W+�b���X��
 * $
 * $Revision 1.1.2.4  2005/04/04 07:02:27  miselsa
 * $R30530 ��I�t��
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

		/*R60747 �N�X�Ǥ��PCSHDT�אּ�X�ǽT�{��PCSHCM  START*/
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
		/*R60747 �N�X�Ǥ��PCSHDT�אּ�X�ǽT�{��PCSHCM  END*/
		System.out.println("PCSHCM="+Integer.parseInt(StringTool.removeChar(request.getParameter("PCSHCM"),'/')));
		
		Vector disbPaymentDetailVec = null;
		DISBRemitExportDAO dao = null;
		try {
			dao = new DISBRemitExportDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY));
			disbPaymentDetailVec =  dao.query(PCSHCM, company); /*R60747 �N�X�Ǥ��PCSHDT�אּ�X�ǽT�{��PCSHCM */
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

			//Ū���ثe�ҽ檺���O t:�~����b(�p��) r:�~���״�(���)
			//R80300 �s�W�H�Υd�U��  if(!BATNO.substring(0,1).equals("D"))
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
						//RE0189:�s�W�Ͱ�OIU�C�x�sOIU���״ڤ���b���P�@�ɮ�,�B�u���b�x�s�Ҥ�DBU/OBU�b���~�ݲ���,�G�u���ϥ�queryByBatNo��t�Ӭd�߸��
						if(BATNO.substring(0,1).equals("D") 
								&& (BATNO.substring(8,11).equals("822") || 
										BATNO.substring(8,11).equals("009") || 
										BATNO.substring(8,11).equals("004") || 
										BATNO.substring(8,11).equals("017") || 
										BATNO.substring(8,11).equals("809"))) 
						{
							//D:�~���״�,��b(�P��ۦs,��RBK��SWIFT CODE��5��6�X��TW)
							fileLOC = convertDownloadData(new DISBRemitExportDAO((DbFactory) getServletContext().getAttribute(Constant.DB_FACTORY)).queryByBatNo(BATNO,strPAYCURR,"t"),strPAYCURR,BATNO,"t",strLogonUser);
							if (!fileLOC.equals("")){
								downfile.add(fileLOC);
							}								
							//D:�~���״�,���״�
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
		//R80300 �H�Υd�s�W�״ڸ��
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
		//����H�U
		if(BKCode.equals("822")) {
			if (remitKind.equals("r"))
				fileLOC = convertDownloadData822r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			else
				fileLOC = convertDownloadData822t(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//�Ĥ@�Ȧ�
		if(BKCode.equals("007")){
			fileLOC = convertDownloadData007(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//���׻Ȧ�
		if(BKCode.equals("017")){
			String payBank = "";
			/*try{
				CaprmtfVO rmtVOtmp = (CaprmtfVO) payments.get(0);
				payBank = rmtVOtmp.getPACCT();
			}catch(Exception e){
				
			}*/
			//RD0382:OIU
			if(remitKind.equals("r")){
				//���״�,DISBRemitExportDAO.queryByBatNo()���P�_SWIFT CODE����5��6�X���i��TW
				fileLOC = convertDownloadData017r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}else{
				//��b,�P��ۦs(���״ڻȦ�SWIFT CODE����5��6�X��TW)
				fileLOC = convertDownloadData017t(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}			
		}
		//�s�˰ӻ�
		if(BKCode.equals("052")){
			fileLOC = convertDownloadData052(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//���׻Ȧ�
		if(BKCode.equals("807")){
			fileLOC = convertDownloadData807(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}		
		//R70574 �x�s�Ȧ�
		if(BKCode.equals("812")){
		    // R00386 �~���ɧﲣ�ͥt�@�خ榡�� XLS file
		    fileLOC = convertDownloadData812(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//R70574 �ثn�Ȧ�
		if(BKCode.equals("008")){
			fileLOC = convertDownloadData008(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//R80480 �W���Ȧ�
		if(BKCode.equals("011")){
		 	fileLOC = convertDownloadData011(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//R00566 ���j�Ȧ�
		if(BKCode.equals("806")) {
			fileLOC = convertDownloadData806(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//R10059 �w���Ȧ�
		if(BKCode.equals("816")) {
			fileLOC = convertDownloadData816(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//RB0062 ���ƻȦ�
		if(BKCode.equals("009")) {
			if (remitKind.equals("r"))
				//�״���
				fileLOC = convertDownloadData009r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			else
				//��b��
				fileLOC = convertDownloadData009t(payments,SelCURR,BATNO,remitKind,strLogonUser);
		}
		//EB0537 �Ͱ�(�U��)�Ȧ�
		if(BKCode.equals("809")) {
			if(remitKind.equals("r")){
				//RE0189
				//�״�����(�s�W,�P����layout�ۦP),�~���I��,809-OBU --> 809-DBU (�u�n�P�_���ڱb��O�_��DBU)
				fileLOC = convertDownloadData809r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			} else {
				//��b��(�J��)
				//RE0189:�~���I��,�u��809-OBU --> 809-OBU (�u�n�P�_���ڱb��O�_��OBU)�~���͸��ɮ�
				fileLOC = convertDownloadData809t(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}			
		}
		
		//RD0440 �O�W�Ȧ�
		if(BKCode.equals("004")) {
			
			if (remitKind.equals("r")){
				//�״���
				fileLOC = convertDownloadData004r(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}else{
				//��b��
				fileLOC = convertDownloadData004t(payments,SelCURR,BATNO,remitKind,strLogonUser);
			}
		}

		return fileLOC;
	}

	private String convertDownloadDataB(Vector payments, String selCURR, String BKCode, String BATNO, String rKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[payments.size()][18];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO;
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);
			String custRemitId = "";
			// ���ڤHID, x(11)�ť�
			for (int count = 0; count < 11; count++) {
				custRemitId += " ";
			}
			// SEQNO ���ɧǸ�X(6)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (6 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// �״ں���,x(2)
			String remitKind = rmtVO.getRTYPE();

			// �״ڦ�,x(7)
			String entBank = "";
			if (rmtVO.getRBK() != null && rmtVO.getRBK().length() >= 7) {
				entBank = rmtVO.getRBK().substring(0, 7);
			}
			for (int count = entBank.length(); count < 3; count++) {
				entBank = "0" + entBank;
			}
			// ���Bx(13)
			//RC0036-3 
			String remitAmt = Integer.toString((int) rmtVO.getRAMT());
			//String remitAmt = Double.toString(rmtVO.getRAMT()); 
			
			if (remitAmt.indexOf(".") > 0) {// �B�z"."
				remitAmt = remitAmt.substring(0, remitAmt.indexOf("."));
				// System.out.println( seqNo + ":" + remitAmt);
			}

			remitAmt += "00";// 999.00-->99900
			for (int count = remitAmt.length(); count < 13; count++) {
				remitAmt = "0" + remitAmt;
				// System.out.println(seqNo + ":" +remitAmt);
			}
			// ���ڤH�b��x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// ���ڤH��Wx(80) �]����W������ �ҥHentName.length()*2
			//QC0274String entName = rmtVO.getRNAME() != null ? rmtVO.getRNAME().trim() : "";// @R90735 FIX BUG
			String entName = (rmtVO.getRNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getRNAME()).toUpperCase();
			for (int count = entName.getBytes().length; count < 80; count++) {
				entName = entName + " ";
			}
			// �״ڤHID x(11)
			String custId = "70817744";
			for (int count = custId.length(); count < 11; count++) {
				custId += " ";
			}
			// �״ڤH�q�ܤΰϰ�x(10)
			String custPhoneNo = "0225068800";// @R90735 �󴫤��q�N��
			// �״ڤH�m�Wx(80)
			String custName = "���y�H�ثO�I�ѥ��������q";
			for (int count = custName.length() * 2; count < 80; count++) {
				custName += " ";
			}
			// ����x(80)
			String memo = rmtVO.getRMEMO() != null ? toFullChar(rmtVO.getRMEMO().replace('�@', ' ').trim()) : "";// R90735 FIX BUG
			if (memo.startsWith("�U�q�t�θ��")) {
				memo = "";
			}
			for (int count = memo.getBytes().length; count < 80; count++) {
				memo += " ";
			}
			// �״ڤ��x(6)
			String remitDate = rmtVO.getRMTDT();
			// R00231 edit by Leo Huang
			if (remitDate.length() > 6) {
				remitDate = remitDate.substring(1);
			}
			// R00231 edit by Leo Huang
			for (int count = remitDate.length(); count < 6; count++) {
				remitDate = "0" + remitDate;
			}
			// ����ˮְ�x(4)
			String chkCode = rmtVO.getRTRNCDE();
			for (int count = chkCode.length(); count < 4; count++) {
				chkCode += " ";
			}
			// �ǰe����x(3)
			String submitCount = rmtVO.getRTRNTM();
			for (int count = submitCount.length(); count < 3; count++) {
				submitCount += " ";
			}
			// �Ȥ�ǲ����Xx(10)
			String processNo = rmtVO.getCSTNO();
			for (int count = processNo.length(); count < 10; count++) {
				processNo += " ";
			}

			// �׶O�t��ϧO��x(1)
			String remitFeeCode = " ";
			// filler x(2)
			String filler = "  ";

			downloadInfo[index][0] = custRemitId;// ���ڤHID, x(11)�ť�
			downloadInfo[index][1] = seqNo;// SEQNO ���ɧǸ�,
			downloadInfo[index][2] = remitKind;// �״ں���,
			downloadInfo[index][3] = entBank;// ,?�ڦ� �״ڦ�,
			downloadInfo[index][4] = remitAmt;// ���B9(11)
			downloadInfo[index][5] = "2";// �K�n
			downloadInfo[index][6] = entAccountNo;// ���ڤH�b��
			downloadInfo[index][7] = entName;// ���ڤH��W
			downloadInfo[index][8] = custId;// �״ڤHID
			downloadInfo[index][9] = custPhoneNo;// �״ڤH�q�ܤΰϰ�
			downloadInfo[index][10] = custName;// �״ڤH�m�W
			downloadInfo[index][11] = memo;// ����
			downloadInfo[index][12] = remitDate;// �״ڤ��
			downloadInfo[index][13] = chkCode;// ����ˮְ�
			downloadInfo[index][14] = submitCount;// �ǰe����
			downloadInfo[index][15] = processNo;// �Ȥ�ǲ����X
			downloadInfo[index][16] = remitFeeCode;// �׶O�t��ϧO��
			downloadInfo[index][17] = filler;// filler

		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, rKind, strLogonUser);
		return fileLOC;
	}

	//RC0036
	private String convertDownloadDataU(Vector payments, String SelCURR, String BKCode, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC ="";
		//�x�s�Ȧ�
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
		// �L��Ƥ��B�z
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
              
			//���ڦ�w�N��
			String RBKO = rmtVO.getRBK();
			String RBK = RBKO.substring(0,6);
			for (int count = RBK.length(); count < 6; count++) {
				RBK = RBK + " ";
			}
			// �״ڪ��B9(11)v99
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
			
			// ����O
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

			// ���ڤH�b��x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 14; count++) {
			     entAccountNo = "0" + entAccountNo;
			}
			// ���ڤH�W�� x(30)
			//QC0274String entNameT = rmtVO.getRNAME() != null ? rmtVO.getRNAME().trim() : "";
			String entNameT = (rmtVO.getRNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getRNAME()).toUpperCase();
			for (int count = entNameT.getBytes().length; count < 30; count++) {
				entNameT = entNameT + " ";
			}

			// ����(���y�H��)
			String note = "���y�H��";
			for (int count = note.length(); count < 36; count++) {
				note = note + " ";
			}
	    	// �Ƶ�
			String fillerN = "";
			for (int count = fillerN.length(); count < 9; count++) {
				fillerN = "0" + fillerN ;
			}
			// �O�d���D
			String fillerD = "";
			for (int count = fillerD.length(); count < 33; count++) {
				fillerD = fillerD + " ";
			}
			
			//downloadInfo[index + 1][0] = "50"; // INDICATOR
			downloadInfo[index + 1][0] = RBK; // ���ڦ�w�N��
			downloadInfo[index + 1][1] = remitAmt; // �״ڪ��B
			downloadInfo[index + 1][2] = BankfeeT; // �浧����O
			downloadInfo[index + 1][3] = entAccountNo;// ���ڤH�b��
			downloadInfo[index + 1][4] = entNameT; // ���ڤH�W��
			downloadInfo[index + 1][5] = note; // ����
			downloadInfo[index + 1][6] = fillerN; // �Ƶ�
			downloadInfo[index + 1][7] = fillerD; // �O�d���
			downloadInfo[index + 1][8] = "0";  // �O�������аO
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
		// �״��`�B
		finalsaveAmt = (int) saveAmt;
		String totAmt = String.valueOf(finalsaveAmt);
		if (totAmt.indexOf(".") > 0) {
			totAmt = totAmt.substring(0, totAmt.indexOf("."));
		}
		totAmt += "00";
		for(int counter=totAmt.length(); counter<13; counter++) {
			totAmt = "0" + totAmt;
		}

		// ���ӵ���
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (7 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// ����O�`�B
		finalBankfee = (int) saveBankfee;
		String totBankfee = String.valueOf(finalBankfee);
		for (int count = 0; count < (6 - String.valueOf(finalBankfee).length()); count++) {
			totBankfee = "0" + totBankfee;
		}
		// �״ڤH�m�W
		String strNM = "���y�H�ثO�I�ѥ��������q";
		for (int count = strNM.length() * 2; count < 30; count++) {
			strNM += " ";
		}
		// �O�d��� x(64)
		String fillerH = "";
		for (int count = fillerH.length(); count < 64; count++) {
			fillerH = fillerH + " ";
		}
		
		downloadInfo[0][0] = "1";  // �X�O
		downloadInfo[0][1] = "0660"; // ���~�s��
		downloadInfo[0][2] = "06120001666600"; // �e��b��	                         
		downloadInfo[0][3] = strRMDT; // �w�w�״ڤ��
		downloadInfo[0][4] = "820";// ��b����
		downloadInfo[0][5] = totAmt; //  �״��`�B
		downloadInfo[0][6] = totCount; // �״ڵ���
		downloadInfo[0][7] = strNM; // �״ڤH�m�W
		downloadInfo[0][8] = totBankfee; // ����O�`���B
		downloadInfo[0][9] = fillerH; // �O�d���
		downloadInfo[0][10] = "0";  // �O�������аO
		for (int i = 11; i < 26; i++) {
			downloadInfo[0][i] = "";
		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, rKind, strLogonUser);
		return fileLOC;
	}
	
	
	//RC0036	
	private String convertDownloadData812E(Vector payments, String selCURR,String BATNO, String rKind, String strLogonUser) {

		
		String fileLOC = "";
		// �L��Ƥ��B�z
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
              
			//���ڦ�w�N��
			String RBKO = rmtVO.getRBK();
			String RBK = RBKO.substring(0,6);
			for (int count = RBK.length(); count < 6; count++) {
				RBK = RBK + " ";
			}
			// �״ڪ��Bx(13)
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
			
			// ����O
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
						
			// ���ڤH�b��x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 14; count++) {
			     entAccountNo = "0" + entAccountNo;
			}
			// ���ڤH�W�� x(30)
			//QC0274String entNameT = rmtVO.getRNAME() != null ? rmtVO.getRNAME().trim() : "";
			String entNameT = (rmtVO.getRNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getRNAME()).toUpperCase();
			//RC0036-3 for (int count = entNameT.getBytes().length; count < 31; count++) {
			for (int count = entNameT.getBytes().length; count < 30; count++) {
			     entNameT = entNameT + " ";
			}

			// ����(���y�H��)
			String note = "���y�H��";
			for (int count = note.length(); count < 36; count++) {
				note = note + " ";
			}

			// �Ƶ�
			String fillerN = "";
			for (int count = fillerN.length(); count < 9; count++) {
				fillerN = "0" + fillerN ;
			}
			// �O�d���D
			String fillerD = "";
			//RC0036-3 for (int count = fillerD.length(); count < 32; count++) {
            for (int count = fillerD.length(); count < 33; count++) {
			     fillerD = fillerD + " ";
			}

			downloadInfo[index + 1][0] = RBK; // ���ڦ�w�N��
			downloadInfo[index + 1][1] = remitAmt; // �״ڪ��B
			downloadInfo[index + 1][2] = BankfeeT; // �浧����O
			downloadInfo[index + 1][3] = entAccountNo;// ���ڤH�b��
			downloadInfo[index + 1][4] = entNameT; // ���ڤH�W��
			downloadInfo[index + 1][5] = note; // ����
			downloadInfo[index + 1][6] = fillerN; // �Ƶ�
			downloadInfo[index + 1][7] = fillerD; // �O�d���
			downloadInfo[index + 1][8] = "0";  // �O�������аO
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
		// �״��`�B
		finalsaveAmt = (int) saveAmt;
		String totAmt = String.valueOf(finalsaveAmt);
		if (totAmt.indexOf(".") > 0) {
			totAmt = totAmt.substring(0, totAmt.indexOf("."));
		}
		totAmt += "00";
		for(int counter=totAmt.length(); counter<13; counter++) {
			totAmt = "0" + totAmt;
		}

 		// ���ӵ���
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (7 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// ����O�`�B
		finalBankfee = (int) saveBankfee;
		String totBankfee = String.valueOf(finalBankfee);
		for (int count = 0; count < (6 - String.valueOf(finalBankfee).length()); count++) {
			totBankfee = "0" + totBankfee;
		}
		// �״ڤH�m�W
		String strNM = "���y�H�ثO�I�ѥ��������q";
		//RC0036-3 for (int count = strNM.length() * 2; count < 32; count++) {
		for (int count = strNM.length() * 2; count < 30; count++) {
     		strNM += " ";
		}
		// �O�d��� x(64)
		String fillerH = "";
		for (int count = fillerH.length(); count < 64; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "1";  // �X�O
		downloadInfo[0][1] = "0660"; // ���~�s��
		downloadInfo[0][2] = "06120001666600"; // �e��b��
		downloadInfo[0][3] = strRMDT; // �w�w�״ڤ��
		downloadInfo[0][4] = "820";// ��b����
		//RC0036-3 downloadInfo[0][5] = totAmt.substring(0, 11); //  �״��`�B
		downloadInfo[0][5] = totAmt; //  �״��`�B
		downloadInfo[0][6] = totCount; // �״ڵ���
		downloadInfo[0][7] = strNM; // �״ڤH�m�W
		downloadInfo[0][8] = totBankfee; // ����O�`���B
		//RC0036-3 downloadInfo[0][9] = fillerH+"  "; // �O�d���
		downloadInfo[0][9] = fillerH; // �O�d���
		downloadInfo[0][10] = "0";  // �O�������аO
		for (int i = 11; i < 26; i++) {
			downloadInfo[0][i] = "";
		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, rKind, strLogonUser);
		return fileLOC;
	}
	
	//R90735 �b��������^��
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
   
	// R80300 �H�Υd�s�W�U���ɮ�
	private String convertDownloadDataC(Vector payments, String selCURR, String BKCode, String BATNO, String rKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
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

			// �d��x(19)
			String crdNO = paymetVO.getStrPCrdNo();
			for (int count = crdNO.length(); count < 19; count++) {
				crdNO = crdNO + " ";
			}
			// �d�������x(4)
			String crdEFFYM = paymetVO.getStrPCrdEffMY() == null ? "" : paymetVO.getStrPCrdEffMY();
			if (!crdEFFYM.equals("")) {
				crdEFFYM = paymetVO.getStrPCrdEffMY().substring(0, 2) + paymetVO.getStrPCrdEffMY().substring(4, 6);
			}
			for (int count = crdEFFYM.length(); count < 4; count++) {
				crdEFFYM = crdEFFYM + " ";
			}
			// ���v�Xx(6)
			String authcode = paymetVO.getStrPAuthCode();
			for (int count = authcode.length(); count < 6; count++) {
				authcode = authcode + " ";
			}
			// ������Bx(12)
			String remitAmtT = df.format(paymetVO.getIPAMT());
			String remitAmt = remitAmtT.substring(0, 10) + remitAmtT.substring(11, 13);
			saveAmt = disbBean.DoubleAdd(saveAmt, paymetVO.getIPAMT());
			// �����x(8)
			String remitDT = Integer.toString((int) paymetVO.getIPCshDt());
			for (int count = remitDT.length(); count < 8; count++) {
				remitDT = "0" + remitDT;
			}
			String strRMDTTemp = Integer.toString(1911 + Integer.parseInt(remitDT.substring(0, 4))) + remitDT.substring(4, 6) + remitDT.substring(6, 8);
			// �Ƶ�x(60)
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

			downloadInfo[index][0] = "D"; // ������O X1
			downloadInfo[index][1] = "06"; // ������O X2
			downloadInfo[index][2] = "000812000104576";// �S���N�X X15
			downloadInfo[index][3] = "6300"; // �S�����N�X X4
			downloadInfo[index][4] = crdNO; // �d�����X X19
			downloadInfo[index][5] = crdEFFYM; // ���Ħ~�� X4 YYMM
			downloadInfo[index][6] = remitAmt; // ���B 10V2
			downloadInfo[index][7] = "00"; // ���v�^���X X2
			downloadInfo[index][8] = authcode; // ���v�X X6
			downloadInfo[index][9] = strRMDTTemp; // ������ X8 YYYYMMDD
			downloadInfo[index][10] = " "; // SSL/ SET flag X1
			downloadInfo[index][11] = "   "; // �d�����ҽX X3
			downloadInfo[index][12] = filler1; // SET XID X40
			downloadInfo[index][13] = remark; // �Ƶ� X60
			downloadInfo[index][14] = "02"; // ������� X2
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
		// �״��`�B
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 10) + totAmtT.substring(11, 13);
		// ���ӵ���
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (6 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		downloadInfo[saveCount][0] = "S"; // ������O
		downloadInfo[saveCount][1] = "000812000104576";// �D�S���N�X
		downloadInfo[saveCount][2] = "000000"; // �P�f��Ƶ���
		downloadInfo[saveCount][3] = "000000000000"; // �P�f��ƪ��B
		downloadInfo[saveCount][4] = totCount; // �h�f��Ƶ���
		downloadInfo[saveCount][5] = totAmt; // �h�f��ƪ��B
		for (int i = 6; i < 29; i++) {
			downloadInfo[saveCount][i] = "";
		}

		// -----Trail Record (�PSubtotal)-----
		downloadInfo[saveCount + 1][0] = "T"; // ������O
		downloadInfo[saveCount + 1][1] = "000812000104576";// �D�S���N�X
		downloadInfo[saveCount + 1][2] = "000000"; // �P�f��Ƶ���
		downloadInfo[saveCount + 1][3] = "000000000000"; // �P�f��ƪ��B
		downloadInfo[saveCount + 1][4] = totCount; // �h�f��Ƶ���
		downloadInfo[saveCount + 1][5] = totAmt; // �h�f��ƪ��B
		for (int i = 6; i < 29; i++) {
			downloadInfo[saveCount + 1][i] = "";
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, rKind, strLogonUser);
		return fileLOC;
	}

	// R60550 �~���ɮפU��(���H�~���״�)
	private String convertDownloadData822r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
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

			// 2.SEQNO ���ӧǸ�X(5)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (5 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 3.�״ڹ��O,X(3)
			String remitCURR = payCURR;
			for (int count = remitCURR.length(); count < 3; count++) {
				remitCURR = remitCURR + " ";
			}
			// 4.�״ڪ��Bx(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 13) + remitAmtT.substring(14, 16);
			// R70574 �״ڪ��B�[�`
			// R70455 saveAmt += Float.parseFloat(remitAmtT);
			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);// R70455
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);// R70455

			// 5.���q�H�b��x(35)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 35; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 6.���ڻȦ�SWIFT x(11)
			String remitSWIFTT = rmtVO.getSWIFTCODE() == null ? "" : rmtVO.getSWIFTCODE();
			String remitSWIFT = remitSWIFTT.trim();
			for (int count = remitSWIFT.length(); count < 11; count++) {
				remitSWIFT = remitSWIFT + " ";
			}
			// 7.���ڻȦ�W�� x(35)
			// 8.���ڻȦ�W�٩Φa�}2 x(35)
			// 9.���ڻȦ�a�}3 x(35)
			// 10.���ڻȦ�a�}4 x(35)
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
			// 11.���q�H�W�� x(35)
			// 12.���q�H�W��2 x(35)
			//QC0274
			//String entNameT = rmtVO.getPENGNAME() == null ? "" : rmtVO.getPENGNAME();
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			for (int count = entNameT.length(); count < 70; count++) {
				entNameT = entNameT + " ";
			}
			String entName1 = entNameT.substring(0, 35);
			String entName2 = entNameT.substring(35, 70);
			// 13.���q�H�a�}3 x(35)
			String entName3 = "";
			for (int count = entName3.length(); count < 35; count++) {
				entName3 = entName3 + " ";
			}
			// 14.���q�H�a�}4 x(35)
			String entName4 = "";
			for (int count = entName4.length(); count < 35; count++) {
				entName4 = entName4 + " ";
			}
			// 15.����1 x(35)
			String note1 = "";
			for (int count = note1.length(); count < 35; count++) {
				note1 = note1 + " ";
			}
			// 16.����2 x(35)
			String note2 = "";
			for (int count = note2.length(); count < 35; count++) {
				note2 = note2 + " ";
			}
			// 17.����3 x(35)
			String note3 = "";
			for (int count = note3.length(); count < 35; count++) {
				note3 = note3 + " ";
			}
			// 18.����4 x(35)
			String note4 = "";
			for (int count = note4.length(); count < 35; count++) {
				note4 = note4 + " ";
			}
			// 19.�״کʽ� x(03)
			// R70088 String rmtFUND = "129";�q129->693 960502 ���H�n�D
			String rmtFUND = "693";
			// 20.���ڰ�O�N�X x(02)
			String rmtCountry = remitSWIFT.substring(4, 6);
			for (int count = rmtCountry.length(); count < 2; count++) {
				rmtCountry = rmtCountry + " ";
			}
			// 21.�����ӥN�� x(20)
			String rmtVendor = "";
			for (int count = rmtVendor.length(); count < 20; count++) {
				rmtVendor = rmtVendor + " ";
			}
			// 22.���ڤHemail x(50)
			String rmtEmail = "";
			for (int count = rmtEmail.length(); count < 50; count++) {
				rmtEmail = rmtEmail + " ";
			}
			// 23.�O�_�[�o202 "Y"��ܻݥ[�o x(01)
			String rmtExtra = "Y";
			// 24.���ڦ椧�s�P��SWIFT�N�X x(11)
			String remitSWIFT2 = "";
			for (int count = remitSWIFT2.length(); count < 11; count++) {
				remitSWIFT2 = remitSWIFT2 + " ";
			}
			// 25.���O�O x(03)
			String remitFEEWAY = rmtVO.getRPAYFEEWAY();
			for (int count = remitFEEWAY.length(); count < 3; count++) {
				remitFEEWAY = remitFEEWAY + " ";
			}
			// 26.����ʽ���O x(02)
			// RD0020����H�U�״��ɷs�W����ʽ���O�T�w����S
			String remitTXNOTE = " S";
			
			// 27.�O�d��� x(20)
			String fillerD = "";
			for (int count = fillerD.length(); count < 20; count++) {
				fillerD = fillerD + " ";
			}

			downloadInfo[index + 1][0] = "D"; // ����Ӹ��
			downloadInfo[index + 1][1] = seqNo; // SEQNO ���ɧǸ�,
			downloadInfo[index + 1][2] = remitCURR; // �״ڹ��O,
			downloadInfo[index + 1][3] = remitAmt; // �״ڪ��B,
			downloadInfo[index + 1][4] = entAccountNo;// ���q�H�b��,
			downloadInfo[index + 1][5] = remitSWIFT; // ���ڻȦ�SWIFT,
			downloadInfo[index + 1][6] = entBank1; // ���ڻȦ�W��1,
			downloadInfo[index + 1][7] = entBank2; // ���ڻȦ�W��2,
			downloadInfo[index + 1][8] = entBank3; // ���ڻȦ�a�}3,
			downloadInfo[index + 1][9] = entBank4; // ���ڻȦ�a�}4,
			downloadInfo[index + 1][10] = entName1; // ���q�H�W��1,
			downloadInfo[index + 1][11] = entName2; // ���q�H�W��2,
			downloadInfo[index + 1][12] = entName3; // ���q�H�a�}3,
			downloadInfo[index + 1][13] = entName4; // ���q�H�a�}4,
			downloadInfo[index + 1][14] = note1; // ����1 ,
			downloadInfo[index + 1][15] = note2; // ����2 ,
			downloadInfo[index + 1][16] = note3; // ����3 ,
			downloadInfo[index + 1][17] = note4; // ����4 ,
			downloadInfo[index + 1][18] = rmtFUND; // �״کʽ�,
			downloadInfo[index + 1][19] = rmtCountry; // ���ڰ�O�N�X,
			downloadInfo[index + 1][20] = rmtVendor; // �����ӥN��,
			downloadInfo[index + 1][21] = rmtEmail; // ���ڤHemail,
			downloadInfo[index + 1][22] = rmtExtra; // �O�_�[�o202 "Y"��ܻݥ[�o,
			downloadInfo[index + 1][23] = remitSWIFT2;// ���ڦ椧�s�P��SWIFT�N�X,
			downloadInfo[index + 1][24] = remitFEEWAY;// ���O�O,
			downloadInfo[index + 1][25] = remitTXNOTE;// ����ʽ���O,
			downloadInfo[index + 1][26] = fillerD; // �O�d���
		}
		// -----HEAD-----
		// �Ȥ�νs
		String custID = "70817744";
		for (int count = custID.length(); count < 12; count++) {
			custID += " ";
		}
		// �״ڤ��
		String strRMDTTemp = null;
		String strRMDTTemp1 = null;
		if (saveRMDT.trim().length() < 7) {
			strRMDTTemp = "0" + saveRMDT; // 990505
		} else {
			strRMDTTemp = saveRMDT;		// 1000131
		}
		// �״ڤ���~�u����X000225
		strRMDTTemp1 = Integer.toString(1911 + Integer.parseInt(strRMDTTemp.substring(0, 3))) + strRMDTTemp.substring(3, 5) + strRMDTTemp.substring(5, 7);

		// R00231 edit by Leo Huang
		// �P������w�����ڱb��
		String custACCT = savePACCT;
		if (custACCT.length() > 12)
			custACCT = custACCT.substring(0, 12);
		for (int count = custACCT.length(); count < 12; count++) {
			custACCT += " ";
		}
		// �״��`�B
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 13) + totAmtT.substring(14, 16);
		// ���ӵ���
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (5 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// �O�d��� x(50)
		String fillerH = "";
		for (int count = fillerH.length(); count < 50; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "H"; // ����`���
		downloadInfo[0][1] = "BR"; // ����`��,
		downloadInfo[0][2] = "DBU"; // DBU/OBU
		downloadInfo[0][3] = custID; // �Ȥ�νs
		downloadInfo[0][4] = strRMDTTemp1;// �״ڤ��
		downloadInfo[0][5] = custACCT; // �P������w�����ڱb��
		downloadInfo[0][6] = payCURR; // �״ڹ��O
		downloadInfo[0][7] = totAmt; // �״��`�B
		downloadInfo[0][8] = totCount; // ���ӵ���
		downloadInfo[0][9] = fillerH; // �O�d���
		for (int i = 10; i < 27; i++) {
			downloadInfo[0][i] = "";
		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}// R60550 END 

	// R70088 �~���ɮפU��(���H�~����b)
	private String convertDownloadData822t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
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
		// R80132 String payCURR= disbBean.getCurr(selCURR,1);//���O 2�X�ର3�X
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

			// 2.SEQNO ���ӧǸ�X(5)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (5 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 3.���ڤHID, x(12)�ť�
			String custRemitId = rmtVO.getRID();
			;
			for (int count = custRemitId.length(); count < 12; count++) {
				custRemitId += " ";
			}
			// 4.���q�H�b��x(12)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 12)
				entAccountNo = entAccountNo.substring(0, 12);
			for (int count = entAccountNo.length(); count < 12; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 6.�״ڪ��Bx(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 13)
					+ remitAmtT.substring(14, 16);
			// R70574 �״ڪ��B�[�`
			// R70455 saveAmt += Float.parseFloat(remitAmtT);
			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);// R70455
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);// R70455

			// 7.�����ӥN�� x(20)
			String rmtVendor = "";
			for (int count = rmtVendor.length(); count < 20; count++) {
				rmtVendor = rmtVendor + " ";
			}
			// 8.������email x(30)
			String fillerD = "";
			for (int count = fillerD.length(); count < 30; count++) {
				fillerD = fillerD + " ";
			}
			// 9.������email x(20)
			String rmtEmail1 = "";
			for (int count = rmtEmail1.length(); count < 20; count++) {
				rmtEmail1 = rmtEmail1 + " ";
			}
			// 10.�O�d��� x(32)
			String rmtEmail2 = "";
			for (int count = rmtEmail2.length(); count < 32; count++) {
				rmtEmail2 = rmtEmail2 + " ";
			}

			downloadInfo[index + 1][0] = "D"; // ����Ӹ��
			downloadInfo[index + 1][1] = seqNo; // SEQNO ���ɧǸ�,
			downloadInfo[index + 1][2] = custRemitId; // ���ڤHid,
			downloadInfo[index + 1][3] = entAccountNo; // �J�b�b��,
			downloadInfo[index + 1][4] = payCURR; // �J�b���O
			downloadInfo[index + 1][5] = remitAmt; // �J�b���B
			downloadInfo[index + 1][6] = rmtVendor; // �����ӥN��,
			downloadInfo[index + 1][7] = rmtEmail1; // ������email,
			downloadInfo[index + 1][8] = rmtEmail2; // ������email,
			downloadInfo[index + 1][9] = fillerD; // �O�d���
			downloadInfo[index + 1][10] = ""; // �O�d���
		}
		// -----HEAD-----
		// �Ȥ�νs
		String custID = "70817744";
		for (int count = custID.length(); count < 12; count++) {
			custID += " ";
		}
		// �״ڤ��
		String strRMDTTemp = null;
		// R00231 Leo Huang
		if (saveRMDT.length() < 7)
			strRMDTTemp = "0" + saveRMDT;
		else
			strRMDTTemp = saveRMDT;

		String strRMDTTemp1 = Integer.toString(1911 + Integer.parseInt(strRMDTTemp.substring(0, 3))) + strRMDTTemp.substring(3, 5) + strRMDTTemp.substring(5, 7);

		// R00231 Leo Huang
		// �P������w�����ڱb��
		String custACCT = savePACCT;
		if (custACCT.length() > 12)
			custACCT = custACCT.substring(0, 12);
		for (int count = custACCT.length(); count < 12; count++) {
			custACCT += " ";
		}
		// �״��`�B
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 13) + totAmtT.substring(14, 16);
		// ���ӵ���
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (5 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// �O�d��� x(50)
		String fillerH = "";
		for (int count = fillerH.length(); count < 50; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "H"; // ����`���
		downloadInfo[0][1] = "BT"; // ����`��,
		downloadInfo[0][2] = "DBU"; // DBU/OBU
		downloadInfo[0][3] = custID; // �Ȥ�νs
		downloadInfo[0][4] = strRMDTTemp1;// �״ڤ��
		downloadInfo[0][5] = "D"; // �P������w�����ڱb��
		downloadInfo[0][6] = custACCT; // �P������w�����ڱb��
		downloadInfo[0][7] = payCURR; // �״ڹ��O
		downloadInfo[0][8] = totAmt; // �״��`�B
		downloadInfo[0][9] = totCount; // ���ӵ���
		downloadInfo[0][10] = fillerH; // �O�d���

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	// R00386
	private String convertDownloadData007(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		// layout ���� 15 ���, �� \r\n �᭱�{���|�۰ʰ�, �i�H�ٲ�
		String[][] downloadInfo = new String[payments.size()][14];
		DecimalFormat df = new DecimalFormat("0000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		// R80132 String payCURR= disbBean.getCurr(selCURR,3);//���O 2�X�ର�Ʀr�X
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

			// 2.�_�u��e�Ǹ�X(10)
			String seqNo = "";
			for (int count = seqNo.length(); count < 10; count++) {
				seqNo = seqNo + " ";
			}
			// 3.�b��x(11)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 11)
				entAccountNo = entAccountNo.substring(0, 11);
			for (int count = entAccountNo.length(); count < 11; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 4.�Τ@�s��X(10)
			String custID = CommonUtil.AllTrim(rmtVO.getRID());
			if(custID.length() == 8) {
				custID = "00" + custID;
			}
			for (int count = custID.length(); count < 10; count++) {
				custID = custID + " ";
			}
			// 5.�P�_�Τ@�s����� ����
			String customIdType = "0";
			try {
				pstmt.clearParameters();
				pstmt.setString(1, CommonUtil.AllTrim(rmtVO.getRID()));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					if(rs.getString("FLD0029").equalsIgnoreCase("C")) {
						customIdType = "1"; // ���q��
					} else if(rs.getString("FLD0029").equalsIgnoreCase("F") || rs.getString("FLD0029").equalsIgnoreCase("M")) {
						customIdType = "2"; // �ӤH��
					} else {
						customIdType = "0";	// ���ˬd
					}
				}
			} catch(SQLException ex) {
				System.err.println(ex.getMessage());
			}
			/*
			int customIdLen = custID.trim().length();
			if (customIdLen == 10)
				customIdType = "2"; // �����Ҧr�� ==> �ӤH��
			else if (customIdLen == 8)
				customIdType = "1"; // ���q�Τ@�s��
			else
				customIdType = "0"; // ���ˬd
			*/

			// 6.�״ڪ��Bx(15)
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() -
			// rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 13) + remitAmtT.substring(14, 16);
			// 7.�D���
			String pBank = rmtVO.getPBK();
			String pBranck;
			if (pBank == null)
				pBranck = "   ";
			else {
				// �Y���� 6 ��, ���ɨ��A��
				if (pBank.length() < 6)
					pBank = pBank + "      ".substring(0, 6 - pBank.length());
				pBranck = pBank.substring(3, 6);
			}

			// 11.�w�w�J�b��x(6)
			String remitDate = rmtVO.getRMTDT();
			for (int count = remitDate.length(); count < 6; count++) {
				remitDate = "0" + remitDate;
			}

			downloadInfo[index][0] = "5797"; // ����N�X
			downloadInfo[index][1] = seqNo; // �_�u��e�Ǹ��ť�
			downloadInfo[index][2] = entAccountNo; // �b��
			downloadInfo[index][3] = custID; // �Τ@�s��,
			downloadInfo[index][4] = customIdType; // �O�_�ˬd
			downloadInfo[index][5] = remitAmt; // ������B
			downloadInfo[index][6] = pBranck; // �D���
			downloadInfo[index][7] = payCURR; // ���O
			downloadInfo[index][8] = " "; // �b��O(�ť�)
			downloadInfo[index][9] = " "; // �J�ڧO(�ť�)
			downloadInfo[index][10] = "          "; // �O�d���
			downloadInfo[index][11] = " "; // �N���M��N�X
			downloadInfo[index][12] = "008"; // �T�w��, ��ܥ��y�H��
			downloadInfo[index][13] = " "; // �O�d��
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
    
	// R70088 SUPL�t�� ���׻Ȧ�,��b(�P��ۦs)
	private String convertDownloadData017t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
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
		// R80132 String payCURR= disbBean.getCurr(selCURR,4);//���O 2�X�ର�Ʀr�X
		String payCURR = disbBean.getETableDesc("CURR4", selCURR);// R80132
		// �o���� RA0140---005���������檺�N���A�Чאּ�n�ʪF������N��070
		String save070 = "070";
		for (int count = save070.length(); count < 8; count++) {
			save070 = save070 + " ";
		}
		// ������
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
			// ���b�� ����Ʀr
			if (saveRMDT.length() > 6)
				saveRMDT = saveRMDT.substring(1);

			// 3.�״ڹ��O,X(3)
			String remitCURR = payCURR;
			for (int count = remitCURR.length(); count < 3; count++) {
				remitCURR = remitCURR + " ";
			}
			// 4.�״ڪ��Bx(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 12) + remitAmtT.substring(13, 15);

			// 5.���q�H�b��x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 11.�O�d��� x(15)
			String fillerD1 = "";
			for (int count = 0; count < 15; count++) {
				fillerD1 = fillerD1 + " ";
			}
			// ���ڤHID, x(10)�ť�
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}
			// 14.�O�d��� x(12)
			String fillerD2 = "";
			for (int count = 0; count < 12; count++) {
				fillerD2 = fillerD2 + " ";
			}
			// 15.�O�d��� x(12)
			String fillerD = "";
			for (int count = 0; count < 12; count++) {
				fillerD = fillerD + " ";
			}

			downloadInfo[index + 1][0] = "2"; // ����Ӹ��
			downloadInfo[index + 1][1] = save070; // �o����
			downloadInfo[index + 1][2] = save017; // ������
			downloadInfo[index + 1][3] = "200"; // ��b���O
			downloadInfo[index + 1][4] = saveRMDT; // �J/���b��
			downloadInfo[index + 1][5] = entAccountNo;// �b��
			downloadInfo[index + 1][6] = remitAmt; // ������B
			downloadInfo[index + 1][7] = "70817744"; // ��Q�Ʒ~�Τ@�s��
			downloadInfo[index + 1][8] = "99"; // ���p�N��
			// 32�M�θ�ư�
			downloadInfo[index + 1][9] = "*C917"; // �K�n�N��
			downloadInfo[index + 1][10] = fillerD1; // �ť�15
			downloadInfo[index + 1][11] = custRemitId; // �s�ڤH�����Ҧr��
			downloadInfo[index + 1][12] = payCURR; // ���O�N��
			downloadInfo[index + 1][13] = fillerD2; // �ť�12
			downloadInfo[index + 1][14] = fillerD; // �ť���
			saveIndex = index + 2;
		}
		// -----HEAD-----
		// �ť��� x(91)
		String fillerH = "";
		for (int count = 0; count < 91; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "1"; // �����
		downloadInfo[0][1] = save070; // �o����
		downloadInfo[0][2] = save017; // ������
		downloadInfo[0][3] = "200"; // ��b���O
		downloadInfo[0][4] = saveRMDT; // �J���b��
		downloadInfo[0][5] = "1"; // �ʽ�O
		downloadInfo[0][6] = "32"; // ������O
		downloadInfo[0][7] = fillerH; // �ť���
		for (int i = 8; i < 15; i++) {
			downloadInfo[0][i] = "";
		}
		// -----FOOT-----
		// �����`���BX(16)
		String totAmtT = df2.format(saveAmt);
		String totAmt = totAmtT.substring(0, 14) + totAmtT.substring(15, 17);
		// �����`����X(10)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (10 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// �������`����X(16)��s
		String totAmtF = "";
		for (int count = 0; count < 16; count++) {
			totAmtF = "0" + totAmtF;
		}
		// �������`����X(10)��s
		String totCountF = "";
		for (int count = 0; count < 10; count++) {
			totCountF = "0" + totCountF;
		}
		// �ť��� x(42)
		String fillerF = "";
		for (int count = 0; count < 42; count++) {
			fillerF = fillerF + " ";
		}

		downloadInfo[saveIndex][0] = "3"; // �����
		downloadInfo[saveIndex][1] = save070; // �o����
		downloadInfo[saveIndex][2] = save017; // ������
		downloadInfo[saveIndex][3] = "200"; // ��b���O
		downloadInfo[saveIndex][4] = saveRMDT; // �J���b��
		downloadInfo[saveIndex][5] = totAmt; // �����`���B
		downloadInfo[saveIndex][6] = totCount; // �����`����
		downloadInfo[saveIndex][7] = totAmtF; // �������`���B
		downloadInfo[saveIndex][8] = totCountF; // �������`����
		downloadInfo[saveIndex][9] = fillerF; // �ť���
		for (int i = 10; i < 15; i++) {
			downloadInfo[saveIndex][i] = "";
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}
	
	//RD0382:OIU,���׶״���(���),SWIFT CODE��5��6�X���i��TW
	private String convertDownloadData017r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		
		String fileLOC = "";
		
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		// layout ���� 21 ���, �� \r\n �᭱�{���|�۰ʰ�, �i�H�ٲ�
		String[][] downloadInfo = new String[payments.size()][22];
		DecimalFormat df = new DecimalFormat("000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		
		String remitDateTmp = "";
		boolean remitDataChange = false;
		//���Ӹ��
		for (int index = 0; index < payments.size(); index++) {			
			rmtVO = (CaprmtfVO) payments.get(index);
			
			//���ڱb��
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			
			//RE0189-�P�_���ڱb���O�_������OBU
			/*String remitAcct = entAccountNo.trim();
			String remitBank = rmtVO.getRBK() == null ? "" : rmtVO.getRBK();
			Boolean isOBU4Remit017 = false;
			String codeOBU4Remit = "";			
			if(remitBank.length()>=3 && "017".equals(remitBank.subSequence(0, 3))) codeOBU4Remit = remitAcct.substring(3,5);
			if("17".equals(codeOBU4Remit) || "57".equals(codeOBU4Remit) || "58".equals(codeOBU4Remit)) isOBU4Remit017 = true;*/
			
			//���ڱb��
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
				
			
			//�νs/�����r��
			String custID = CommonUtil.AllTrim(rmtVO.getRID());			
			
			//�״ڪ��B		
			//log.info("rmtVO.getRPAYAMT()�O" + rmtVO.getRPAYAMT() + ",rmtVO.getRBENFEE()�O" + rmtVO.getRBENFEE());
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			//log.info("remitAmtNum�O" + remitAmtNum);
			String remitAmt = "";
			remitAmt = df.format(remitAmtNum);			
			
			//�I�ڱb��
			String payAccount = "";
			payAccount = CommonUtil.AllTrim(rmtVO.getPACCT());
			
			//SWIFT CODE
			String swiftCode = "";
			swiftCode = CommonUtil.AllTrim(rmtVO.getSWIFTCODE());
			
			//���ڦ��O
			/*String remitContryString = "";
			if(swiftCode.length()>=8) remitContryString = swiftCode.substring(4, 6);*/
			
			String country = "";
			if(!"".equals(swiftCode) && swiftCode.length()>=8) country = swiftCode.substring(4, 6);
			
			
			//�״ڹ��O
			String remitCurrency = "";
			remitCurrency = CommonUtil.AllTrim(rmtVO.getRPAYCURR());
			remitCurrency = disbBean.getETableDesc("CURRA", remitCurrency.trim());
			
			//�^��m�W
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			
			//���ڤH�^��a�}
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
			
			//��I��]�N�X
			String paySourceCode = "";
			paySourceCode = CommonUtil.AllTrim(rmtVO.getPaySourceCode());
			
			
			//CNAPS(CN)/ABA ROUTING(US)/TRANSIT(CA)/BSB(AU)/IBAN(��)
			String payBkVerifyNumber = "";
			payBkVerifyNumber = CommonUtil.AllTrim(rmtVO.getPayBkVerifyNumber());
			String IBAN = "";
			if(!"CN".equals(country) && !"US".equals(country) && !"CA".equals(country) && !"AU".equals(country) && !"TW".equals(country)) IBAN = payBkVerifyNumber;
			
			//SORT CODE
			String payBkSortCode = "";
			payBkSortCode = CommonUtil.AllTrim(rmtVO.getPayBkSortCode());
			
			//�w�w�ι�ڤJ�b��
			String remitDate = rmtVO.getRMTDT();
			if(index >0  && !remitDataChange){
				if(!remitDateTmp.equals(remitDate)) remitDataChange = true;
			}
			
			//����O��I�覡
			String rPAYFEEWAY = "";
			rPAYFEEWAY = CommonUtil.AllTrim(rmtVO.getRPAYFEEWAY());		
			
			remitDateTmp = remitDate;
			remitDateTmp = (Integer.parseInt(remitDateTmp.substring(0,3))+1911) + remitDateTmp.substring(3);
			downloadInfo[index][0] = remitDateTmp; //�״ڤ��,1
			downloadInfo[index][1] = payAccount + genSpace(11-payAccount.length()); //�I�ڱb��,2
			downloadInfo[index][2] = country + genSpace(2-country.length()); //���ڻȦ��O(��SWIFT CODE��5��6�X),3
			//log.info("paySourceCode�O" + paySourceCode + ",RACCT�O" + rmtVO.getRACCT());
			if("D1".equals(paySourceCode)){
				downloadInfo[index][3] = "                              129"; //129 �O�O��X,4
			}else{
				downloadInfo[index][3] = "                              399"; //129 �O�O��X,4
			}			
			downloadInfo[index][4] = genSpace(2); //na,5
			downloadInfo[index][5] = remitDateTmp + remitCurrency; //�״ڹ��O(��I�D�ɪ������״ڧ帹���O),7
			downloadInfo[index][6] = remitAmt; //�״ڪ��B (�p��2��),8
			downloadInfo[index][7] = "TWZ0066516"; //TWZ0066516,9			
			String company1 = "TRANSGLOBE LIFE INSURANCE INC. OFFSHORE INSURANCE BRANCH ";
			String payBkAddr1 = "16F, No.288, Sec. 6, Civic Blvd.,  Taipei City 110, Taiwan, R.O.C.";
			downloadInfo[index][8] = company1; //�I�ڻȦ�W��1,10
			downloadInfo[index][9] = payBkAddr1.toUpperCase(); //�I�ڻȦ�a�}1,12
			downloadInfo[index][10] = genSpace(193); //na,14
			swiftCode = "A" + swiftCode;
			downloadInfo[index][11] = swiftCode.trim() + genSpace(41-swiftCode.trim().length()); //SWIFT CODE,21
			downloadInfo[index][12] = payBkVerifyNumber.trim() + genSpace(31-payBkVerifyNumber.trim().length()); //CNAPS(CN)/ABA ROUTING(US)/TRANSIT(CA)/BSB(AU),22
			downloadInfo[index][13] = payBkSortCode + genSpace(104-payBkSortCode.length()); //SORT CODE(GB),23
			if(IBAN.length()>0){
				IBAN = "/" + IBAN;
				downloadInfo[index][14] = IBAN + genSpace(35-IBAN.length()); //IBAN(��),26
			}else{
				entAccountNo = "/" + entAccountNo;
				downloadInfo[index][14] = entAccountNo + genSpace(35-entAccountNo.length()); //���ڤH�b��(�״ڱb��),26
			}			
			downloadInfo[index][15] = entNameT.trim() + genSpace(35-entNameT.trim().length()); //���ڤH��W,27
			downloadInfo[index][16] = engAddr1.trim() + genSpace(105-engAddr1.trim().length()); //���ڤH�^��a�}1,28
			downloadInfo[index][17] = genSpace(0); //���ڤH�^��a�}2,29
			downloadInfo[index][18] = genSpace(0); //���ڤH�^��a�}3,30
			String memo = "PAY FULL AMOUNT";
			downloadInfo[index][19] = memo + genSpace(16-memo.trim().length()); //����,31
			downloadInfo[index][20] = genSpace(135); //na,32
			downloadInfo[index][21] = rPAYFEEWAY; //na,33,CAPRMTF.RPAYFEEWAY
		}//end for		
		
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}
	
	//RE0189:�Ͱ�-�״���
private String convertDownloadData809r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		
		String fileLOC = "";
		
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		// layout ���� 21 ���, �� \r\n �᭱�{���|�۰ʰ�, �i�H�ٲ�
		String[][] downloadInfo = new String[payments.size()][22];
		DecimalFormat df = new DecimalFormat("000000000000.00");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		
		String remitDateTmp = "";
		boolean remitDataChange = false;
		//���Ӹ��
		for (int index = 0; index < payments.size(); index++) {			
			rmtVO = (CaprmtfVO) payments.get(index);
			
			//���ڱb��
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			
			//���ڱb��
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
				
			
			//�νs/�����r��
			String custID = CommonUtil.AllTrim(rmtVO.getRID());			
			
			//�״ڪ��B		
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmt = "";
			remitAmt = df.format(remitAmtNum);			
			
			//�I�ڱb��
			String payAccount = "";
			payAccount = CommonUtil.AllTrim(rmtVO.getPACCT());
			
			//SWIFT CODE
			String swiftCode = "";
			swiftCode = CommonUtil.AllTrim(rmtVO.getSWIFTCODE());
			
			//���ڦ��O
			String remitContryString = "";
			if(swiftCode.length()>=8) remitContryString = swiftCode.substring(4, 6);
			
			String country = "";
			if(!"".equals(swiftCode) && swiftCode.length()>=8) country = swiftCode.substring(4, 6);
			
			
			//�״ڹ��O
			String remitCurrency = "";
			remitCurrency = CommonUtil.AllTrim(rmtVO.getRPAYCURR());
			remitCurrency = disbBean.getETableDesc("CURRA", remitCurrency.trim());
			
			//�^��m�W
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			
			//���ڤH�^��a�}
			String engAddr = "";
			engAddr = CommonUtil.AllTrim(rmtVO.getPayAddr());
			String engAddr1 = "";
			String engAddr2 = "";
			String engAddr3 = "";
			engAddr1 = engAddr;
			if(engAddr1.length() > 105) engAddr1 = engAddr.substring(1,105);
			
			//��I��]�N�X
			String paySourceCode = "";
			paySourceCode = CommonUtil.AllTrim(rmtVO.getPaySourceCode());
			
			
			//CNAPS(CN)/ABA ROUTING(US)/TRANSIT(CA)/BSB(AU)/IBAN(��)
			String payBkVerifyNumber = "";
			payBkVerifyNumber = CommonUtil.AllTrim(rmtVO.getPayBkVerifyNumber());
			String IBAN = "";
			if(!"CN".equals(country) && !"US".equals(country) && !"CA".equals(country) && !"AU".equals(country) && !"TW".equals(country)) IBAN = payBkVerifyNumber;
			
			//SORT CODE
			String payBkSortCode = "";
			payBkSortCode = CommonUtil.AllTrim(rmtVO.getPayBkSortCode());
			
			//�w�w�ι�ڤJ�b��
			String remitDate = rmtVO.getRMTDT();
			if(index >0  && !remitDataChange){
				if(!remitDateTmp.equals(remitDate)) remitDataChange = true;
			}
			
			//����O��I�覡
			String rPAYFEEWAY = "";
			rPAYFEEWAY = CommonUtil.AllTrim(rmtVO.getRPAYFEEWAY());		
			
			remitDateTmp = remitDate;
			remitDateTmp = (Integer.parseInt(remitDateTmp.substring(0,3))+1911) + remitDateTmp.substring(3);
			downloadInfo[index][0] = remitDateTmp; //�״ڤ��,1
			downloadInfo[index][1] = payAccount + genSpace(11-payAccount.length()); //�I�ڱb��,2
			downloadInfo[index][2] = country + genSpace(2-country.length()); //���ڻȦ��O(��SWIFT CODE��5��6�X),3
			downloadInfo[index][3] = "                              129"; //129 �O�O��X,4			
			downloadInfo[index][4] = genSpace(2); //na,5
			downloadInfo[index][5] = remitDateTmp + remitCurrency; //�״ڹ��O(��I�D�ɪ������״ڧ帹���O),7
			downloadInfo[index][6] = remitAmt; //�״ڪ��B (�p��2��),8
			downloadInfo[index][7] = "TWZ0066516"; //TWZ0066516,9			
			String company1 = "TRANSGLOBE LIFE INSURANCE INC. OFFSHORE INSURANCE BRANCH ";
			String payBkAddr1 = "16F, No.288, Sec. 6, Civic Blvd.,  Taipei City 110, Taiwan, R.O.C.";
			downloadInfo[index][8] = company1; //�I�ڻȦ�W��1,10
			downloadInfo[index][9] = payBkAddr1.toUpperCase(); //�I�ڻȦ�a�}1,12
			downloadInfo[index][10] = genSpace(193); //na,14
			swiftCode = "A" + swiftCode;
			downloadInfo[index][11] = swiftCode.trim() + genSpace(41-swiftCode.trim().length()); //SWIFT CODE,21
			downloadInfo[index][12] = payBkVerifyNumber.trim() + genSpace(31-payBkVerifyNumber.trim().length()); //CNAPS(CN)/ABA ROUTING(US)/TRANSIT(CA)/BSB(AU),22
			downloadInfo[index][13] = payBkSortCode + genSpace(104-payBkSortCode.length()); //SORT CODE(GB),23
			if(IBAN.length()>0){
				IBAN = "/" + IBAN;
				downloadInfo[index][14] = IBAN + genSpace(35-IBAN.length()); //IBAN(��),26
			}else{
				entAccountNo = "/" + entAccountNo;
				downloadInfo[index][14] = entAccountNo + genSpace(35-entAccountNo.length()); //���ڤH�b��(�״ڱb��),26
			}			
			downloadInfo[index][15] = entNameT.trim() + genSpace(35-entNameT.trim().length()); //���ڤH��W,27
			downloadInfo[index][16] = engAddr1.trim() + genSpace(105-engAddr1.trim().length()); //���ڤH�^��a�}1,28
			downloadInfo[index][17] = genSpace(0); //���ڤH�^��a�}2,29
			downloadInfo[index][18] = genSpace(0); //���ڤH�^��a�}3,30
			String memo = "PAY FULL AMOUNT";
			downloadInfo[index][19] = memo + genSpace(16-memo.trim().length()); //����,31
			downloadInfo[index][20] = genSpace(135); //na,32
			downloadInfo[index][21] = rPAYFEEWAY; //na,33,CAPRMTF.RPAYFEEWAY
		}//end for		
		
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	// R70088 SUPL�t�� �s�˰ӻ� 
	private String convertDownloadData052(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		DecimalFormat df = new DecimalFormat("0000000000000.00");
		String[][] downloadInfo = new String[payments.size()][5];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO;

		// 3.���Ox(3)
		// R80132 String payCURR =disbBean.getCurr(selCURR,1);//2�X��T��
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);// R80132 R80480 CURR1->CURRA

		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 1.���ڤH�m�Wx(70)
			//QC0274String entNameT = rmtVO.getPENGNAME() == null ? "" : rmtVO.getPENGNAME();
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			for (int count = entNameT.length(); count < 70; count++) {
				entNameT = entNameT + " ";
			}
			// 2.���ڤH�b��x(35)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 17)
				entAccountNo = entAccountNo.substring(0, 17);
			for (int count = entAccountNo.length(); count < 17; count++) {
				entAccountNo = entAccountNo + " ";
			}
			// 4.�״ڪ��Bx(15)
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() -
			// rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmt = df.format(remitAmtNum);
			// ���ڤHID, x(10)�ť�
			String custRemitId = rmtVO.getRID();

			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}

			downloadInfo[index][0] = entNameT; // �m�W,
			downloadInfo[index][1] = entAccountNo;// �b��
			downloadInfo[index][2] = payCURR; // ���O
			downloadInfo[index][3] = remitAmt; // ���B9(15)
			downloadInfo[index][4] = custRemitId; // �Ȥ�ID
		}

		fileLOC = disbBean.writeTOfileXLS(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	//	R70088 SUPL�t�� ���׻Ȧ�
	private String convertDownloadData807(Vector payments,String selCURR,String BATNO,String remitKind,String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;
		DecimalFormat df = new DecimalFormat("00000000000.00");
		String[][] downloadInfo = new String[payments.size()][17];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO;
		// R80132 String payCURR= disbBean.getCurr(selCURR,5);//���O 2�X�ର�Ʀr�X
		String payCURR = disbBean.getETableDesc("CURR5", selCURR);// R80132

		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 1.�B�z�妸X(04)
			String filler1 = "";
			for (int count = 0; count < 4; count++) {
				filler1 = filler1 + " ";
			}
			// 2.SEQNO �Ǹ�X(7)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (7 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 3.�Ȥ�b��x(14)�״ڱb��
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 4.������x(6) --> RA0241 x(07)
			String remitDate = rmtVO.getRMTDT();
			for (int count = remitDate.length(); count < 7; count++) {
				remitDate = "0" + remitDate;
			}
			// 5.�״ڪ��Bx(15)
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() -
			// rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 11) + remitAmtT.substring(12, 14);
			// 7���ڤHID, x(10)�ť�
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}
			// 8.�Ѳ����XX(6)�N�z�s�� --> 8.�O�dx(6)  RA0241 
			//String filler2 = "100267";
			String filler2 = "";
			for (int count = 0; count < 6; count++) {
				filler2 = filler2 + " ";
			}
			
			// 10.���b��x(14)��I�b��
			String entPAcctNo = rmtVO.getRACCT() == null ? "" : rmtVO.getPACCT();
			if (entPAcctNo.length() > 14)
				entPAcctNo = entPAcctNo.substring(0, 14);

			for (int count = entPAcctNo.length(); count < 14; count++) {
				entPAcctNo = entPAcctNo + " ";
			}
			// 11.�O�dX(14)
			String filler3 = "";
			for (int count = 0; count < 14; count++) {
				filler3 = filler3 + " ";
			}
			// 13.�O�dX(70) --> RA0241 x(34)
			String filler4 = "";
			for (int count = 0; count < 34; count++) {
				filler4 = filler4 + " ";
			}
			// 14.�N�z�s��x(6)  RA0241
			String filler5 = "100267";
			// 15.�O�dx(31)  RA0241
			String filler6 = "";
			for (int count = 0; count < 31; count++) {
				filler6 = filler6 + " ";
			}
			// 16.�w���N�Xx(14)
			String safeCode = disbBean.getSafeCode807(entAccountNo, remitAmt);
			// 17.�B�z�O��x(1)
			String filler7 = "0";

			downloadInfo[index][0] = filler1; // �B�z�妸
			downloadInfo[index][1] = seqNo; // �Ǹ���
			downloadInfo[index][2] = entAccountNo; // �Ȥ�b��
			downloadInfo[index][3] = remitDate; // ������
			downloadInfo[index][4] = remitAmt; // ������B
			downloadInfo[index][5] = "228"; // �K�n
			downloadInfo[index][6] = custRemitId; // �����Ҧr��
			downloadInfo[index][7] = filler2; // �Ѳ����X-->�O�d
			downloadInfo[index][8] = "99"; // ���A�X
			downloadInfo[index][9] = entPAcctNo;// ���b��
			downloadInfo[index][10] = filler3; // �O�d
			downloadInfo[index][11] = payCURR; // ���O
			downloadInfo[index][12] = filler4; // �O�d
			downloadInfo[index][13] = filler5; // �N�z�s��
			downloadInfo[index][14] = filler6; // �O�d
			downloadInfo[index][15] = safeCode; // �w���N�X
			downloadInfo[index][16] = filler7; // �B�z�O��
		}//end for
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}// R70088 END

	// R00386 �x�s�Ȧ� / �~���ɥΥt�@�خ榡
	private String convertDownloadData812(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		if (payments == null || payments.size() <= 0)
			return fileLOC;

		//String[][] downloadInfo = new String[payments.size() + 1][7]; // �h�d�@�浹���Y
		String[][] downloadInfo = new String[payments.size() + 1][8]; // �h�d�@�浹���Y
		NumberFormat df = new DecimalFormat("##############0.##");

		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);

		// �g�J���Y
		downloadInfo[0][0] = "������";
		downloadInfo[0][1] = "�J�ڱb��";
		downloadInfo[0][2] = "���ڱb��";
		downloadInfo[0][3] = "���O";
		downloadInfo[0][4] = "�J���b���B";
		downloadInfo[0][5] = "����ID";
		downloadInfo[0][6] = "�J�bID"; // RA0081
		downloadInfo[0][7] = "�ʽ�";

		// �g�J���
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// ����� - ��褸�~
			String trDateString = rmtVO.getRMTDT();
			int trDateNum = Integer.parseInt(trDateString); // �� handle exception, �ӷ����O���Ħ~��鰮�ܤ��n�X�ɮ�
			trDateNum += 19110000;
			trDateString = String.valueOf(trDateNum);

			// �״ڪ��B
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			// ��(��)�ڱb��
			String entPAcctNo = rmtVO.getRACCT() == null ? "" : rmtVO.getPACCT();
			// ���ڤH�b��
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			//
			int pos = index + 1;
			downloadInfo[pos][0] = trDateString; // �����
			downloadInfo[pos][1] = entAccountNo; // �J�ڱb��
			downloadInfo[pos][2] = entPAcctNo; // ���ڱb��
			downloadInfo[pos][3] = payCURR; // ���O
			downloadInfo[pos][4] = df.format(remitAmtNum); // �J���b���B
			downloadInfo[pos][5] = "70817744"; // ���� ID - ���q�s��,�ثe�S���`��,������...
			downloadInfo[pos][6] = rmtVO.getRID(); // ���ڤHID
			downloadInfo[pos][7] = "129";
		}

		fileLOC = disbBean.writeTOfileXLS(downloadInfo, BATNO, selCURR, remitKind, strLogonUser, true);
		return fileLOC;
	}

	// R70574 �ثn�Ȧ�
	private String convertDownloadData008(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;
		DecimalFormat df = new DecimalFormat("00000000000.00");
		String[][] downloadInfo = new String[payments.size()][9];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CaprmtfVO rmtVO;
		// R80132 String payCURR= disbBean.getCurr(selCURR,6);//���O 2�X�ର�Ʀr�X
		String payCURR = disbBean.getETableDesc("CURR6", selCURR);// R80132

		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 1.��b���x(6)
			String remitDate = rmtVO.getRMTDT();
			for (int count = remitDate.length(); count < 6; count++) {
				remitDate = "0" + remitDate;
			}
			// 4.���ڤH�b��x(12)�״ڱb��
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			for (int count = entAccountNo.length(); count < 12; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 5.������, x(10)�ť�
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}
			// 7.�״ڪ��Bx(15)
			// R70455 double remitAmtNum = rmtVO.getRPAYAMT() -
			// rmtVO.getRBENFEE();
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 11) + remitAmtT.substring(12, 14);
			// 8.��ƽs��X(10)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (10 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 9.�O�d��X(12) ���O 2+��b���� 2+�ť�
			String note = payCURR;
			for (int count = note.length(); count < 12; count++) {
				note += " ";
			}

			downloadInfo[index][0] = remitDate; // ��b���
			downloadInfo[index][1] = "1000"; // �D���
			downloadInfo[index][2] = "70817744  ";// ��Q�s��
			downloadInfo[index][3] = entAccountNo;// �b��
			downloadInfo[index][4] = custRemitId; // ������
			downloadInfo[index][5] = "110"; // ��b�O
			downloadInfo[index][6] = remitAmt; // ��b���B
			downloadInfo[index][7] = seqNo; // ��ƽs��
			downloadInfo[index][8] = note; // �O�d��
		}
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}// R70574 END

	// R80480 �W���Ȧ�
	private String convertDownloadData011(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
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
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);// ���O 2�X�ର3�X
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

			// 1.�y���Ǹ�X(6)
			String seqNo = String.valueOf(index + 1);
			for (int count = 0; count < (6 - String.valueOf(index + 1).length()); count++) {
				seqNo = "0" + seqNo;
			}
			// 4.�Ȥ�s��, x(10)�ť�
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}
			// 5.�J�b�b��x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 6.�J�b���O,X(3)
			String remitCURR = payCURR;
			for (int count = remitCURR.length(); count < 3; count++) {
				remitCURR += " ";
			}
			// 7.�J�b���Bx(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 13)
					+ remitAmtT.substring(14, 16);
			// 8.������x(8)
			String remitDate = rmtVO.getRMTDT();
			for (int count = remitDate.length(); count < 8; count++) {
				remitDate = "0" + remitDate;
			}
			strRMDTTemp = Integer.toString(1911 + Integer.parseInt(remitDate.substring(0, 4))) + remitDate.substring(4, 6) + remitDate.substring(6, 8);
			// 10.�T�w��� x(18)
			String filler = "";
			for (int count = 0; count < 18; count++) {
				filler += " ";
			}
			// 11.�Ƶ� x(14)
			String strNOTE = "���y�H��";
			for (int count = strNOTE.length() * 2; count < 14; count++) {
				strNOTE += " ";
			}

			downloadInfo[index + 1][0] = seqNo; // �y���Ǹ�
			downloadInfo[index + 1][1] = "020"; // ����O
			downloadInfo[index + 1][2] = " "; // �����O
			downloadInfo[index + 1][3] = custRemitId; // �Ȥ�s��
			downloadInfo[index + 1][4] = entAccountNo; // �J�b�b��
			downloadInfo[index + 1][5] = remitCURR; // �J�b���O
			downloadInfo[index + 1][6] = remitAmt; // �J�b���B
			downloadInfo[index + 1][7] = "1"; // �J���b�O
			downloadInfo[index + 1][8] = strRMDTTemp; // ������
			downloadInfo[index + 1][9] = filler; // �T�w���
			downloadInfo[index + 1][10] = strNOTE; // �Ƶ�
			downloadInfo[index + 1][11] = "0"; // �T�w���
		}
		// -----HEAD----
		// 3.��X����X(10)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (6 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// 4.��X�`���BX(16)
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 13) + totAmtT.substring(14, 16);

		// 5.�ť� x(21)
		String fillerD = "";
		for (int count = 0; count < 21; count++) {
			fillerD += "0";
		}
		// 6.�J�b�b��x(14)
		if (savePACCT.length() > 14)
			savePACCT = savePACCT.substring(0, 14);
		for (int count = savePACCT.length(); count < 14; count++) {
			savePACCT = "0" + savePACCT;
		}

		downloadInfo[0][0] = "HD    "; // ����
		downloadInfo[0][1] = strRMDTTemp; // ��b���
		downloadInfo[0][2] = fillerD; // �ťթ�s
		downloadInfo[0][3] = totCount; // ��X����
		downloadInfo[0][4] = totAmt; // ��X�`���B
		downloadInfo[0][5] = savePACCT; // ��X�b��
		downloadInfo[0][6] = fillerD; // �ťթ�s
		for (int i = 7; i < 12; i++) {
			downloadInfo[0][i] = "";
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}// R80480 END

	//R00566 ���j�Ȧ�~���״���
	private String convertDownloadData806(Vector payments,String selCURR,String BATNO,String remitKind,String strLogonUser) {
		String fileLOC = "";
		Statement stmt = null;
		ResultSet rs = null;
		// �L��Ƥ��B�z
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

		// ������
		String save806 = "806";
		for (int count = save806.length(); count < 8; count++) {
			save806 = save806 + " ";
		}
		// �O�d
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
			int trDateNum = Integer.parseInt(trDateString); // �� handle exception, �ӷ����O���Ħ~��鰮�ܤ��n�X�ɮ�
			trDateNum += 19110000;
			trDateString = String.valueOf(trDateNum);

			// 4.�״ڪ��Bx(15)
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(0, 12) + remitAmtT.substring(13, 15);

			// 5.���q�H�b��x(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14) {
				entAccountNo = entAccountNo.substring(0, 14);
			}
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo = "0" + entAccountNo;
			}
			// 10 �O�渹�X+���ڤH�������� &&14 ����Ƶ�
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
					// �O�渹�X
					POLICY_NO1 = rs.getString("POLICY_NO").trim();
					for (int count2 = POLICY_NO1.length(); count2 < 10; count2++) {
						POLICY_NO1 += " ";
					}
					// ����Ƶ�
					System.out.println("PAY_DESCRIPTION0" + PAY_DESCRIPTION1);
					PAY_DESCRIPTION1 = rs.getString("PAY_DESCRIPTION1").replace('�@', ' ').trim();
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
							PAY_DESCRIPTION1 = PAY_DESCRIPTION1 + "�@";

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

			// ���ڤHID, x(10)�ť�
			String custRemitId = rmtVO.getRID();
			for (int count2 = custRemitId.length(); count2 < 10; count2++) {
				custRemitId += " ";
			}

			// 11.�O�d��� x(15)
			String fillerD1 = "";
			for (int count = 0; count < 3; count++) {
				fillerD1 = fillerD1 + " ";
			}

			// 12.�״ڹ��O,X(3)
			String remitCURR = payCURR;
			for (int count = remitCURR.length(); count < 3; count++) {
				remitCURR = remitCURR + " ";
			}
			System.out.println(remitCURR);
			// 15.�O�d��� x(10)
			String fillerD = "";
			for (int count = 0; count < 10; count++) {
				fillerD = fillerD + " ";
			}

			downloadInfo[index + 1][0] = "2"; // ����Ӹ��-���O
			downloadInfo[index + 1][1] = save005; // �o����
			downloadInfo[index + 1][2] = save806; // ������
			downloadInfo[index + 1][3] = "257"; // ��b���O
			downloadInfo[index + 1][4] = trDateString; // �J/���b��
			downloadInfo[index + 1][5] = entAccountNo;// �b��
			downloadInfo[index + 1][6] = remitAmt; // ������B
			downloadInfo[index + 1][7] = "70817744"; // ��Q�Ʒ~�Τ@�s��
			downloadInfo[index + 1][8] = "9999"; // ���p�N��
			// 32�M�θ�ư�
			downloadInfo[index + 1][9] = POLICY_NO1 + custRemitId; // �K�n�N��
			downloadInfo[index + 1][10] = fillerD1; // �ť�3
			downloadInfo[index + 1][11] = remitCURR; // �״ڹ��O
			downloadInfo[index + 1][12] = "���y�H��"; // ���O�N��
			downloadInfo[index + 1][13] = PAY_DESCRIPTION1; // ����Ƶ�
			downloadInfo[index + 1][14] = fillerD; // �ť���
			saveIndex = index + 2;
		}
		// -----HEAD-----
		// �ť��� x(91)
		String fillerH = "";
		for (int count = 0; count < 91; count++) {
			fillerH = fillerH + " ";
		}
		downloadInfo[0][0] = "1"; // ���O
		downloadInfo[0][1] = save005; // �o����
		downloadInfo[0][2] = save806; // ������
		downloadInfo[0][3] = "257"; // ��b���O
		downloadInfo[0][4] = trDateString; // ��b��
		downloadInfo[0][5] = "1"; // ��Ʃʽ�O
		downloadInfo[0][6] = "   "; // ���~�N�X
		downloadInfo[0][7] = space1; // �O�d
		downloadInfo[0][8] = "R"; // �O�b�O
		for (int i = 9; i < 15; i++) {
			downloadInfo[0][i] = "";
		}

		// -----FOOT-----
		// �����`���BX(16)
		String totAmtT = df2.format(saveAmt);
		String totAmt = totAmtT.substring(0, 14) + totAmtT.substring(15, 17);
		// �����`����X(10)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (10 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}
		// �������`����X(16)��s
		String totAmtF = "";
		for (int count = 0; count < 16; count++) {
			totAmtF = "0" + totAmtF;
		}
		// �������`����X(10)��s
		String totCountF = "";
		for (int count = 0; count < 10; count++) {
			totCountF = "0" + totCountF;
		}
		// �ť��� x(41)
		String fillerF = "";
		for (int count = 0; count < 41; count++) {
			fillerF = fillerF + " ";
		}

		downloadInfo[saveIndex][0] = "3"; // �����
		downloadInfo[saveIndex][1] = save005; // �o����
		downloadInfo[saveIndex][2] = save806; // ������
		downloadInfo[saveIndex][3] = "257"; // ��b���O
		downloadInfo[saveIndex][4] = trDateString; // �J���b��
		downloadInfo[saveIndex][5] = totAmt; // �����`���B
		downloadInfo[saveIndex][6] = totCount; // �����`����
		downloadInfo[saveIndex][7] = totAmtF; // �������`���B
		downloadInfo[saveIndex][8] = totCountF; // �������`����
		downloadInfo[saveIndex][9] = fillerF; // �ť���
		downloadInfo[saveIndex][10] = "R"; // �O�b�O

		for (int i = 11; i < 15; i++) {
			downloadInfo[saveIndex][i] = "";
		}

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		
		return fileLOC;
	}
	  	
	// R10059 �w���Ȧ�
	private String convertDownloadData816(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";

		//�L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		//String[][] downloadInfo = new String[(payments.size() + 2)][8];	//HEAD+LAST
		String[][] downloadInfo = new String[(payments.size() + 2)][11];	//HEAD+LAST,RE0273
		DecimalFormat df = new DecimalFormat("000000000000.00");

		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);	//���O 2�X�ର3�X
		String remitDate = "";
		double remitAmtNum = 0;
		double saveAmtT = 0;
		double saveAmt = 0;
		int saveCount = 0;

		//DETAIL			
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			//3.��b��� x(7) �X�ǽT�{�� YYYMMDD(1000215)
			remitDate = CommonUtil.padLeadingZero(rmtVO.getRMTDT(), 7);

			//4.��b�b�� x(14) �״ڻȦ�b��
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			StringBuffer sbAccNo = new StringBuffer();
			sbAccNo.append(entAccountNo);
			for(int counter=entAccountNo.length(); counter < 14; counter++) {
				sbAccNo.append(" ");
			}
			entAccountNo = sbAccNo.toString();

			//5.��b���B x(12.2)
			remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			String remitAmtT = df.format(disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE()));
			String remitAmt = remitAmtT.substring(0, 12) + remitAmtT.substring(13, 15);

			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);
			saveCount = index + 1;

			//8.�Ƶ� x(14)
			StringBuffer sbNote = new StringBuffer();
			for(int counter=0; counter<14; counter++) {
				sbNote.append(" ");
			}
			
			//10.������, x(10)�ť�
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}

			downloadInfo[index + 1][0] = "2"; 			//�ϧO�X
			downloadInfo[index + 1][1] = "FX027601009"; //��b�էO
			downloadInfo[index + 1][2] = remitDate; 	//��b���
			downloadInfo[index + 1][3] = entAccountNo; 	//��b�b��
			downloadInfo[index + 1][4] = remitAmt; 		//��b���B
			downloadInfo[index + 1][5] = "2"; 			//�J���b�X
			downloadInfo[index + 1][6] = "99"; 			//��b���p
			//downloadInfo[index + 1][7] = sbNote.toString(); //�Ƶ�
			downloadInfo[index + 1][7] = payCURR; //���O,//RE0273
			downloadInfo[index + 1][8] = genSpace(32); //�Τ���O���,//RE0273
			downloadInfo[index + 1][9] = custRemitId; //�����Ҧr��,//RE0273
			downloadInfo[index + 1][10] = genSpace(15); //�ɨ��ť�,//RE0273
			
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
		downloadInfo[0][0] = "1";			//�ϧO�X
		downloadInfo[0][1] = "FX027601009"; //��b�էO
		downloadInfo[0][2] = remitDate; 	//��b���
		//downloadInfo[0][3] = "2"; 			//�J���b�X
		downloadInfo[0][3] = "3"; 			//�J���b�X,RE0273
		downloadInfo[0][4] = sbCusNo.toString(); //�Τ�b��/���w�N��
		//downloadInfo[0][5] = " "; 			//�Ƶ�
		//downloadInfo[0][6] = payCURR; 			//�Ƶ�
		//downloadInfo[0][7] = sbNote.toString(); //�Ƶ�
		downloadInfo[0][5] = sbNote.toString(); //�Ƶ�,//RE0273
		downloadInfo[0][6] = ""; //�Ƶ�,//RE0273
		downloadInfo[0][7] = ""; //�Ƶ�,//RE0273
		downloadInfo[0][8] = ""; //�Ƶ�,//RE0273
		downloadInfo[0][9] = ""; //�Ƶ�,//RE0273
		downloadInfo[0][10] = ""; //�Ƶ�,//RE0273

		//LAST
		//6.�J�b�`���� x(5)
		String totCount = CommonUtil.padLeadingZero(saveCount, 5);

		//7.�J�b�`���B x(12.2)
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 12) + totAmtT.substring(13, 15);

		//8.�Ƶ� x(7)
		sbNote = new StringBuffer();
		//for(int counter=0; counter<7; counter++) {
		for(int counter=0; counter<53; counter++) {
			sbNote.append(" ");
		}

		downloadInfo[payments.size() + 1][0] = "3";				//�ϧO�X
		downloadInfo[payments.size() + 1][1] = "FX027601009";	//��b�էO
		downloadInfo[payments.size() + 1][2] = remitDate;		//��b���
		downloadInfo[payments.size() + 1][3] = "00000";			//���b�`����
		downloadInfo[payments.size() + 1][4] = "00000000000000";//���b�`���B
		downloadInfo[payments.size() + 1][5] = totCount;		//�J�b�`����
		downloadInfo[payments.size() + 1][6] = totAmt;			//�J�b�`���B
		downloadInfo[payments.size() + 1][7] = sbNote.toString();//�Ƶ�
		downloadInfo[payments.size() + 1][8] = "";//�Ƶ�,//RE0273
		downloadInfo[payments.size() + 1][9] = "";//�Ƶ�,//RE0273
		downloadInfo[payments.size() + 1][10] = "";//�Ƶ�,//RE0273
		

		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}

	// RB0062 ���ƻȦ�~���״���(���)
	private String convertDownloadData009r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[(payments.size() + 2)][36];
		DecimalFormat df = new DecimalFormat("00000000000000.00");
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		CommonUtil commonutil = new CommonUtil(globalEnviron);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Constant.CURRENT_LOCALE);
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);	//��X��T�X���O
		CaprmtfVO rmtVO;
		String strRMD = "";
		String strTXDATE = "";
		int saveCount = 0;
		double saveAmt = 0;
		double saveAmtT = 0;

		// -----DETAIL-----
		for (int index = 0; index < payments.size(); index++) {
			rmtVO = (CaprmtfVO) payments.get(index);

			// 1. �ϧO�X X(01)
			// 2. �״ڪ��B 9(12)V9(02)
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(2, 14) + remitAmtT.substring(15, 17);

			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);

			// 8. VALUE DATE X(08) �褸�~YYYYMMDD
			String strRemitDate = rmtVO.getRMTDT();	//����~YYYMMDD
			String strVALDAY = sdf.format(commonutil.convertROC2WestenDate1(strRemitDate));

			strTXDATE = strVALDAY;
			strRMD = strRemitDate;

			// 9. ���ڤH�b�� X(34)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : CommonUtil.AllTrim(rmtVO.getRACCT());
			for (int count = entAccountNo.length(); count < 34; count++) {
				entAccountNo += " ";
			}

			// 10. ���ڤH�W�٦a�}�@ ~ �| X(35)
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

			// 14.���ڰ�O�N�X X(02)
			String rmtCountry = (rmtVO.getRBKCOUNTRY() == null) ? "" : CommonUtil.AllTrim(rmtVO.getRBKCOUNTRY()).toUpperCase();
			for (int count = rmtCountry.length(); count < 2; count++) {
				rmtCountry += " ";
			}

			// 16. ���ڻȦ�ABA(RECABA) X(11)
			String strRECABA = "";
			for (int count = strRECABA.length(); count < 11; count++) {
				strRECABA += " ";
			}

			// 17. ���ڻȦ�BIC(RECBIC) X(11)
			String remitSWIFT = (rmtVO.getSWIFTCODE() == null) ? "" : CommonUtil.AllTrim(rmtVO.getSWIFTCODE());
			for (int count = remitSWIFT.length(); count < 11; count++) {
				remitSWIFT += " ";
			}

			// 18. ���ڻȦ�W�٦a�}�@ ~ �| X(35)
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

			// 23. �����@ ~ �� X(35)
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

			// 29. �����Ȧ�ABA(INTRABA) X(11)
			String strINTRABA = "";
			for (int count = strINTRABA.length(); count < 11; count++) {
				strINTRABA += " ";
			}

			// 30. �����Ȧ�BIC(INTRBIC) X(11)
			String strINTRBIC = "";
			for (int count = strINTRBIC.length(); count < 11; count++) {
				strINTRBIC += " ";
			}

			// 31. �����Ȧ�W�٦a�}�@ ~ �| X(35)
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

			// 35. �Ƶ��@ ~ �G X(35)
			String strMEMO1 = "";
			String strMEMO2 = "";
			for (int count = strMEMO1.length(); count < 35; count++) {
				strMEMO1 += " ";
			}
			for (int count = strMEMO2.length(); count < 35; count++) {
				strMEMO2 += " ";
			}

			downloadInfo[index + 1][0] = "2";			// �ϧO�X x(01)
			downloadInfo[index + 1][1] = remitAmt;		// �״ڪ��B 9(12)V9(2)
			downloadInfo[index + 1][2] = "00000000000000"; // �~���I�����B 9(12)V9(2)
			downloadInfo[index + 1][3] = "0000000";		// ����O(��¦��) 9(05)V9(02)
			downloadInfo[index + 1][4] = "0000000";		// �l�q�O(��¦��) 9(05)V9(02)
			downloadInfo[index + 1][5] = "0000000";		// ��L���I��-�j��(��¦��) 9(05)V9(02)
			downloadInfo[index + 1][6] = "0000000";		// ��~�O��(���) 9(05)V9(02)
			downloadInfo[index + 1][7] = strVALDAY;		// VALUE DATE X(08)
			downloadInfo[index + 1][8] = entAccountNo;	// ���ڤH�b�� X(34)
			downloadInfo[index + 1][9] = strRECNM1;		// ���ڤH�W�٦a�}�@  X(35)
			downloadInfo[index + 1][10] = strRECNM2;	// ���ڤH�W�٦a�}�G  X(35)
			downloadInfo[index + 1][11] = strRECNM3;	// ���ڤH�W�٦a�}�T  X(35)
			downloadInfo[index + 1][12] = strRECNM4;	// ���ڤH�W�٦a�}�|  X(35)
			downloadInfo[index + 1][13] = rmtCountry;	// ���ڰ�O�N�X  X(02)
			downloadInfo[index + 1][14] = "1";			// ���ڤH�����O  X(01)
			downloadInfo[index + 1][15] = strRECABA;	// ���ڻȦ�ABA  X(11)
			downloadInfo[index + 1][16] = remitSWIFT;	// ���ڻȦ�BIC  X(11)
			downloadInfo[index + 1][17] = strRECBN1;	// ���ڻȦ�W�٦a�}�@  X(35)
			downloadInfo[index + 1][18] = strRECBN2;	// ���ڻȦ�W�٦a�}�G  X(35)
			downloadInfo[index + 1][19] = strRECBN3;	// ���ڻȦ�W�٦a�}�T  X(35)
			downloadInfo[index + 1][20] = strRECBN4;	// ���ڻȦ�W�٦a�}�|  X(35)
			downloadInfo[index + 1][21] = "693";		// �״ڤ����s��  X(03)
			downloadInfo[index + 1][22] = strNOTE1;		// �����@  X(35)
			downloadInfo[index + 1][23] = strNOTE2;		// �����G  X(35)
			downloadInfo[index + 1][24] = strNOTE3;		// �����T  X(35)
			downloadInfo[index + 1][25] = strNOTE4;		// �����|  X(35)
			downloadInfo[index + 1][26] = strNOTE5;		// ������  X(35)
			downloadInfo[index + 1][27] = strNOTE6;		// ������  X(35)
			downloadInfo[index + 1][28] = strINTRABA;	// �����Ȧ�ABA  X(11)
			downloadInfo[index + 1][29] = strINTRBIC;	// �����Ȧ�BIC  X(11)
			downloadInfo[index + 1][30] = strINTRBN1;	// �����Ȧ�W�٦a�}�@  X(35)
			downloadInfo[index + 1][31] = strINTRBN2;	// �����Ȧ�W�٦a�}�G  X(35)
			downloadInfo[index + 1][32] = strINTRBN3;	// �����Ȧ�W�٦a�}�T  X(35)
			downloadInfo[index + 1][33] = strINTRBN4;	// �����Ȧ�W�٦a�}�|  X(35)
			downloadInfo[index + 1][34] = strMEMO1;		// �Ƶ��@  X(35)
			downloadInfo[index + 1][35] = strMEMO2;		// �Ƶ��G  X(35)

			saveCount = index + 1;
		}

		// -----HEAD-----

		// 7. �״ڤH�Τ@�s�� X(11)
		String strIDNO = "70817744";
		for (int count = strIDNO.length(); count < 11; count++) {
			strIDNO += " ";
		}

		// 9. ��¦�����s�b�� X(14)
		String strBPBACT = "";
		for (int count = strBPBACT.length(); count < 14; count++) {
			strBPBACT += " ";
		}

		// 10. ĳ���s�� X(13)
		String strEXNO = "";
		for (int count = strEXNO.length(); count < 13; count++) {
			strEXNO += " ";
		}

		// 11. ���׫����s�� X(14)
		String strFXNO = "";
		for (int count = strFXNO.length(); count < 14; count++) {
			strFXNO += " ";
		}

		downloadInfo[0][0] = "1";				// �ϧO�X X(01)
		downloadInfo[0][1] = "666F5185";		// �o���� X(08)
		downloadInfo[0][2] = strTXDATE;			// �״ڤ�� X(08)
		downloadInfo[0][3] = "01";				// ����帹 X(02)
		downloadInfo[0][4] = "1";				// OBU�O�� X(01)
		downloadInfo[0][5] = payCURR;			// ���O X(03)
		downloadInfo[0][6] = strIDNO;			// �״ڤH�Τ@�s�� X(11)
		downloadInfo[0][7] = "21132239980600";	// ������s�b�� X(14)
		downloadInfo[0][8] = strBPBACT;			// ��¦�����s�b�� X(14)
		downloadInfo[0][9] = strEXNO;			// ĳ���s�� X(13)
		downloadInfo[0][10] = strFXNO;			// ���׫����s�� X(14)
		downloadInfo[0][11] = "73";				// �״ڤ覡 X(02)
		
		for (int i = 12; i < 36; i++) {
			downloadInfo[0][i] = "";
		}

		// -----FOOT-----

		// 2. �ץX�`���� 9(04)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (4 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}

		// 3. �ץX�`���B 9(14)V9(02)
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 14) + totAmtT.substring(15, 17);

		downloadInfo[saveCount+1][0] = "3";					// �ϧO�X X(01)
		downloadInfo[saveCount+1][1] = totCount;			// �ץX�`���� 9(04)
		downloadInfo[saveCount+1][2] = totAmt;				// �ץX�`���B 9(14)V9(02)
		downloadInfo[saveCount+1][3] = totAmt;				// �۳ƥ~���`���B 9(14)V9(02)
		downloadInfo[saveCount+1][4] = "0000000000000000";	// ���ʥ~���`���B 9(14)V9(02)
		downloadInfo[saveCount+1][5] = "00000000";			// ����O�`���B 9(06)V9(02)
		downloadInfo[saveCount+1][6] = "00000000";			// �l�q�O�`���B 9(06)V9(02)
		
		for (int i = 7; i < 36; i++) {
			downloadInfo[saveCount+1][i] = "";
		}

		String strBatchNo = BATNO.substring(0, 1) + strRMD + BATNO.substring(8);

		fileLOC = disbBean.writeTOfile(downloadInfo, strBatchNo, selCURR, remitKind, strLogonUser);

		return fileLOC;
	}

	// RB0062 ���ƻȦ�~����b��(�p��)
	private String convertDownloadData009t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
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

			// 5. ��� 9(08)
			String strRemitDate = rmtVO.getRMTDT();
			String strRMDT = sdf.format(commonutil.convertROC2WestenDate1(strRemitDate));

			saveRMDT = strRMDT;

			// 8. �ť��� X(05)
			String strEmpty = "";
			for(int count = strEmpty.length(); count < 5; count++) {
				strEmpty += " ";
			}

			// 9. �Ȧ�b�� 9(14)
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 14)
				entAccountNo = entAccountNo.substring(0, 14);
			for (int count = entAccountNo.length(); count < 14; count++) {
				entAccountNo += " ";
			}

			// 10. ���B 9(14)V9(02)
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());
			String remitAmtT = df.format(remitAmtNum);
			String remitAmt = remitAmtT.substring(2, 14) + remitAmtT.substring(15, 17);

			saveAmtT = disbBean.DoubleRound(remitAmtNum, 2);
			saveAmt = disbBean.DoubleAdd(saveAmt, saveAmtT);

			// 12. ������O(1) X(10)
			String strRemark1 = "���y�H��";
			byte[] bytRemark = strRemark1.getBytes();
			String strFill = "";
			for (int count = bytRemark.length; count < 10; count++) {
				strFill += " ";
			}
			strRemark1 += strFill;

			// 13. ������O(2) X(10)
			String strRemark2 = "";
			for (int count = strRemark2.length(); count < 10; count++) {
				strRemark2 += " ";
			}

			// 14. �����Ҧr�� X(10)
			String custRemitId = rmtVO.getRID();
			for (int count = custRemitId.length(); count < 10; count++) {
				custRemitId += " ";
			}

			// 15. �M�θ�ư� X(20)
			String strField15 = "";
			for (int count = strField15.length(); count < 20; count++) {
				strField15 += " ";
			}

			// 16. �������ˮְO�� X(01)
			String customIdType = "N";
			try {
				pstmt.clearParameters();
				pstmt.setString(1, CommonUtil.AllTrim(rmtVO.getRID()));
				rs = pstmt.executeQuery();
				if(rs.next()) {
					if(rs.getString("FLD0029").equalsIgnoreCase("C") || rs.getString("FLD0029").equalsIgnoreCase("F") || rs.getString("FLD0029").equalsIgnoreCase("M")) {
						customIdType = "Y"; // ���q��έӤH��
					}
				}
			} catch(SQLException ex) {
				System.err.println(ex.getMessage());
			}

			// 17. ���O X(02)
			String payCurr = selCURR.equals("NT") ? "" : disbBean.getETableDesc("CURR7", selCURR);
			for(int count=payCurr.length(); count < 2 ; count++) {
				payCurr += " ";
			}

			// 18. �ť��� X(21)
			String strField18 = "";
			for (int count = strField18.length(); count < 21; count++) {
				strField18 += " ";
			}
			
			downloadInfo[index + 1][0] = "2";			// �ϧO�X 9(01)
			downloadInfo[index + 1][1] = "666";			// ���~�s��(1) 9(03)
			downloadInfo[index + 1][2] = "F";			// ���~�s��(2) X(01)
			downloadInfo[index + 1][3] = "5185";		//����N�� 9(04)
			downloadInfo[index + 1][4] = strRMDT;		// ��� 9(08)
			downloadInfo[index + 1][5] = "2";			// �s���N�� 9(01)
			downloadInfo[index + 1][6] = "097";			// �K�n 9(03)
			downloadInfo[index + 1][7] = strEmpty;		// �ť��� X(05)
			downloadInfo[index + 1][8] = entAccountNo;	// �Ȧ�b�� 9(14)
			downloadInfo[index + 1][9] = remitAmt;		// ���B 9(14)V9(02)
			downloadInfo[index + 1][10] = "99";			// ���p�N�� 9(02)
			downloadInfo[index + 1][11] = strRemark1;	// ������O(1) X(10)
			downloadInfo[index + 1][12] = strRemark2;	// ������O(2) X(10)
			downloadInfo[index + 1][13] = custRemitId;	// �����Ҧr�� X(10)
			downloadInfo[index + 1][14] = strField15;	// �M�θ�ư� X(20)
			downloadInfo[index + 1][15] = customIdType;	// �������ˮְO�� X(01)
			downloadInfo[index + 1][16] = payCurr;		// ���O X(02)
			downloadInfo[index + 1][17] = strField18;	// �ť��� X(21)

			saveCount = index + 1;
		}

		// -----HEAD-----

		// 8. �Ϥ��ӷ� X(05)
		String strDiskSource = "CHB";
		for (int count = strDiskSource.length(); count < 5; count++) {
			strDiskSource += " ";
		}

		// 10. ���q�Τ@�s�� X(10)
		String strCompany = "70817744";
		for (int count = strCompany.length(); count < 10; count++) {
			strCompany += " ";
		}
		
		// 11. ���q�b��  
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

		// 12. �O�d�� X(79)
		String strField12 = "";
		for (int count = strField12.length(); count < 79; count++) {
			strField12 += " ";
		}

		downloadInfo[0][0] = "1";			// �ϧO�X 9(01)
		downloadInfo[0][1] = "666";			// ���~�s��(1) 9(03)
		downloadInfo[0][2] = "F";			// ���~�s��(2) X(01)
		downloadInfo[0][3] = "5185";		//����N�� 9(04)
		downloadInfo[0][4] = saveRMDT;		// ��� 9(08)
		downloadInfo[0][5] = "2";			// �s���N�� 9(01)
		downloadInfo[0][6] = "097";			// �K�n 9(03)
		downloadInfo[0][7] = strDiskSource; // �Ϥ��ӷ� X(05)
		downloadInfo[0][8] = "1"; 			// �ʽ�O 9(01)
		downloadInfo[0][9] = strCompany; 	// ���q�Τ@�s�� X(10)
		//downloadInfo[0][10] = "21132239980600";// ���q�b�� X(14)
		downloadInfo[0][10] = strPacct;// ���q�b�� X(14) QC0272
		downloadInfo[0][11] = strField12; 	// �O�d�� X(79)

		for (int i = 12; i < 18; i++) {
			downloadInfo[0][i] = "";
		}

		// -----FOOT-----

		// 8. �ť��� X(05)
		String strEmpty = "";
		for(int count = strEmpty.length(); count < 5; count++) {
			strEmpty += " ";
		}

		// 9. �`���B 9(14)V9(02)
		String totAmtT = df.format(saveAmt);
		String totAmt = totAmtT.substring(0, 14) + totAmtT.substring(15, 17);

		// 2. �ץX�`���� 9(10)
		String totCount = String.valueOf(saveCount);
		for (int count = 0; count < (10 - String.valueOf(saveCount).length()); count++) {
			totCount = "0" + totCount;
		}

		// 13. �ť��� X(52)
		String strField = "";
		for(int count = strField.length(); count < 52; count++) {
			strField += " ";
		}

		downloadInfo[saveCount+1][0] = "3";			// �ϧO�X 9(01)
		downloadInfo[saveCount+1][1] = "666";		// ���~�s��(1) 9(03)
		downloadInfo[saveCount+1][2] = "F";			// ���~�s��(2) X(01)
		downloadInfo[saveCount+1][3] = "5185";		//����N�� 9(04)
		downloadInfo[saveCount+1][4] = saveRMDT;	// ��� 9(08)
		downloadInfo[saveCount+1][5] = "2";			// �s���N�� 9(01)
		downloadInfo[saveCount+1][6] = "097";		// �K�n 9(03)
		downloadInfo[saveCount+1][7] = strEmpty;	// �ť��� X(05)
		downloadInfo[saveCount+1][8] = totAmt;		// �`���B 9(14)V9(02)
		downloadInfo[saveCount+1][9] = totCount;	// �`���� 9(10)
		downloadInfo[saveCount+1][10] = "0000000000000000";	// �������`���B 9(14)V9(02)
		downloadInfo[saveCount+1][11] = "0000000000";// �������`���� 9(8)V9(02)
		downloadInfo[saveCount+1][12] = strField;	// �ť��� X(52)

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

	//EB0537 �U���Ȧ� (���׶״ڤ��ݲ����ɮ�)
	private String convertDownloadData809t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		String fileLOC = "";
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		String[][] downloadInfo = new String[payments.size()][16];
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		String payCURR = disbBean.getETableDesc("CURRA", selCURR);	//��X��T�X���O
		
		//RD0144,�ק�U���H����CNY��CNH
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
			
			// ������x(8) �褸�~
			String remitDate = rmtVO.getRMTDT();
			remitDate = String.valueOf(Integer.parseInt(remitDate) + 19110000);

			//�O�I���q�b��x(12)
			String strAccount = CommonUtil.AllTrim(rmtVO.getPACCT());
			if(strAccount.length() > 12) {
				strAccount = strAccount.substring(0, 12);
			}
			for (int counter=strAccount.length(); counter < 12; counter++) {
				strAccount += " ";
			}

			//�Ǹ�9(6)
			String strDataSeq = String.valueOf(iDataSeq);
			for(int counter=strDataSeq.length(); counter<5; counter++) {
				strDataSeq = "0" + strDataSeq;
			}
			strDataSeq = "2" + strDataSeq;

			//���ڤH�~���b��x(12)
			String entAccountNo = CommonUtil.AllTrim(rmtVO.getRACCT());
			if(entAccountNo.length() > 12) {
				entAccountNo = entAccountNo.substring(0, 12);
			}
			for (int count = entAccountNo.length(); count < 12; count++) {
				entAccountNo += " ";
			}
			
			// ���ڤH�Τ@�s��x(11)
			String custRemitId = CommonUtil.AllTrim(rmtVO.getRID());
			for (int counter = custRemitId.length(); counter < 11; counter++) {
				custRemitId += " ";
			}
			
			// ������B9(13)v99
			String remitAmt = String.valueOf(rmtVO.getRAMT());
			// �B�z�p���I"." �Y 999.00-->99900
			if (remitAmt.indexOf(".") > 0) {
				remitAmt = remitAmt.substring(0, remitAmt.indexOf("."));
			}
			remitAmt += "00";
			for(int counter=remitAmt.length(); counter<15; counter++) {
				remitAmt = "0" + remitAmt;
			}

			//�ť�x(20)
			String strField13 = "";
			for (int counter = strField13.length(); counter < 20; counter++) {
				strField13 += " ";
			}
			//�^�аT���N��x(6)
			String strField14 = "";
			for (int counter = strField14.length(); counter < 6; counter++) {
				strField14 += " ";
			}
			//�^�аT�����x(120)
			String strField15 = "";
			for (int counter = strField15.length(); counter < 120; counter++) {
				strField15 += " ";
			}
			//�O�d���x(63)
			String strField16 = "";
			for (int counter = strField16.length(); counter < 63; counter++) {
				strField16 += " ";
			}

			iDataSeq++;
			
			downloadInfo[index][0] = "IN";	// �~�����O, �O�O�b�ȧ@�~
			downloadInfo[index][1] = "TG";	// �O�I���q�N��
			downloadInfo[index][2] = strSeq;// �帹
			downloadInfo[index][3] = remitDate;	// ������
			downloadInfo[index][4] = strAccount;// �O�I���q�b��
			downloadInfo[index][5] = "70817744   ";// �O�I���q�Τ@�s��
			downloadInfo[index][6] = payCURR;	// ���O
			downloadInfo[index][7] = strDataSeq;// �Ǹ�
			downloadInfo[index][8] = "+";		// �ɶU�O, �s�J
			downloadInfo[index][9] = entAccountNo;	// ���ڤH�~���b��
			downloadInfo[index][10] = custRemitId;	// ���ڤH�Τ@�s��
			downloadInfo[index][11] = remitAmt;		// ������B
			downloadInfo[index][12] = strField13;	//�O�渹�X, ����s��
			downloadInfo[index][13] = strField14;	// �^�аT���N��
			downloadInfo[index][14] = strField15;	// �^�аT�����
			downloadInfo[index][15] = strField16;	// �O�d���
		}
		if(downloadInfo != null)
			fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);

		return fileLOC;
	}

	//RD0440�O�W�Ȧ�,�Ѧ�convertDownloadData007(),�i�Ѧ�convertDownloadData009t()���Ȧ�header & detail
	private String convertDownloadData004t(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		//���ͥx����b��
		String fileLOC = "";
		
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		// layout ���� 21 ���, �� \r\n �᭱�{���|�۰ʰ�, �i�H�ٲ�
		String[][] downloadInfo = new String[payments.size()+1][21];
		DecimalFormat df = new DecimalFormat("0000000000.00");
		DecimalFormat df1 = new DecimalFormat("0000000000000");
		CaprmtfVO rmtVO;
		DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
		
		double remitAmtNumSum = 0;
		int remitCount = 0;
		String remitDateTmp = "";
		boolean remitDataChange = false;
		//���Ӹ��
		for (int index = 0; index < payments.size(); index++) {			
			rmtVO = (CaprmtfVO) payments.get(index);
			
			//�b��
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 16){
				entAccountNo = entAccountNo.substring(0, 16);
			}else if(entAccountNo.length() < 16){
				entAccountNo += genSpace(16-entAccountNo.length());
			}
				
			
			//�νs/�����r��
			String custID = CommonUtil.AllTrim(rmtVO.getRID());			
			
			//�״ڪ��B		
			//log.info("rmtVO.getRPAYAMT()�O" + rmtVO.getRPAYAMT() + ",rmtVO.getRBENFEE()�O" + rmtVO.getRBENFEE());
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			//log.info("remitAmtNum�O" + remitAmtNum);
			String remitAmt = df.format(remitAmtNum);
			remitAmt = remitAmt.replace(".", "");
			remitAmt = df1.format(Double.valueOf(remitAmt));
			
			//�D���
			String pBank = rmtVO.getPBK();
			String pBranck;
			if (pBank == null)
				pBranck = "   ";
			else {
				// �Y���� 6 ��, ���ɨ��A��
				if (pBank.length() < 6)
					pBank = pBank + "      ".substring(0, 6 - pBank.length());
				pBranck = pBank.substring(3, 6);
			}

			//�w�w�ι�ڤJ�b��
			String remitDate = rmtVO.getRMTDT();
			if(index >0  && !remitDataChange){
				if(!remitDateTmp.equals(remitDate)) remitDataChange = true;
			}
			remitDateTmp = remitDate;
			downloadInfo[index+1][0] = "2"; //��Ʈ榡,1
			downloadInfo[index+1][1] = String.format("%06d", new Integer(index+1)); //�y���s��,2
			downloadInfo[index+1][2] = genSpace(4); //�O�d,3
			downloadInfo[index+1][3] = entAccountNo; //�b��,4
			downloadInfo[index+1][4] = "1"; //�J���b�O��,5
			downloadInfo[index+1][5] = remitAmt; //���B,6
			downloadInfo[index+1][6] = remitDate; //�J���b��,7
			downloadInfo[index+1][7] = String.format("%07d", new Integer(0)); //��ڤJ���b��,8
			downloadInfo[index+1][8] = "���y�H��" + genSpace(8); //�Ƶ�,9
			downloadInfo[index+1][9] = genSpace(10); //�O�d,10
			downloadInfo[index+1][10] = custID; //�νs/�����r��,11
			downloadInfo[index+1][11] = genSpace(2); //�B�z���G,12
			downloadInfo[index+1][12] = genSpace(20); //�b��P�b���1,13
			downloadInfo[index+1][13] = genSpace(20); //�b��P�b���2,14
			downloadInfo[index+1][14] = genSpace(60); //�e�U���ۥθ��,15
			downloadInfo[index+1][15] = genSpace(7); //�O�d,16
			downloadInfo[index+1][16] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][17] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][18] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][19] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][20] = ""; //�ɻ�downloadInfo
			
			remitAmtNumSum += remitAmtNum;
			remitCount++;
		}//end for

		//�������
		downloadInfo[0][0] = "1"; //��Ʈ榡,1
		downloadInfo[0][1] = String.format("%07d", new Integer(2360015)); //�Ȥ�N��,2
		downloadInfo[0][2] = "Z15"; //��b���O,3
		downloadInfo[0][3] = "70817744" + genSpace(2); //�Τ@�s��,4
		if(remitDataChange){
			downloadInfo[0][4] = String.format("%07d", new Integer(0)); //�J���b��,5
		}else{
			downloadInfo[0][4] = String.format("%07d", Integer.valueOf(remitDateTmp)); //�J���b��,5
		}		
		
		String remitAmtNumSumStr = df.format(remitAmtNumSum);
		remitAmtNumSumStr = remitAmtNumSumStr.replace(".", "");
		remitAmtNumSumStr = df1.format(Double.valueOf(remitAmtNumSumStr));
		
		downloadInfo[0][5] = "1"; //�J���b�O��,6
		downloadInfo[0][6] = "���y�H��" + genSpace(16-"���y�H��".getBytes().length); //�Τ@�Ƶ�,7
		downloadInfo[0][7] = genSpace(10); //�O�d,8
		downloadInfo[0][8] = getCurrencyCode(selCURR); //���O,9
		downloadInfo[0][9] = String.format("%06d", new Integer(0)); //���b�`����,10
		downloadInfo[0][10] = df1.format(0); //���b�`���B,11
		downloadInfo[0][11] = String.format("%06d", new Integer(remitCount)); //�J�b�`����,12
		downloadInfo[0][12] = remitAmtNumSumStr; //�J�b�`���B,13
		downloadInfo[0][13] = String.format("%06d", new Integer(0)); //���b�����`����,14
		downloadInfo[0][14] = df1.format(0); //���b�����`���B,15
		downloadInfo[0][15] = String.format("%06d", new Integer(0)); //�J�b�����`����,16
		downloadInfo[0][16] = df1.format(0); //�J�b�����`���B,17
		downloadInfo[0][17] = "9"; //���A,18
		downloadInfo[0][18] = "                    695TW A" + genSpace(48-"                    695TW A".length()); //�e�U���ۥθ��,19
		downloadInfo[0][19] = genSpace(13); //�W�ǧ帹,20
		downloadInfo[0][20] = genSpace(5); //�O�d,21
		
		fileLOC = disbBean.writeTOfile(downloadInfo, BATNO, selCURR, remitKind, strLogonUser);
		return fileLOC;
	}
	
	private String convertDownloadData004r(Vector payments, String selCURR, String BATNO, String remitKind, String strLogonUser) {
		//���ͥx�ȶ״���
		String fileLOC = "";
		
		// �L��Ƥ��B�z
		if (payments.size() <= 0)
			return fileLOC;

		// layout ���� 21 ���, �� \r\n �᭱�{���|�۰ʰ�, �i�H�ٲ�
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
		//���Ӹ��
		for (int index = 0; index < payments.size(); index++) {
			
			rmtVO = (CaprmtfVO) payments.get(index);
			
			//�b��
			String entAccountNo = rmtVO.getRACCT() == null ? "" : rmtVO.getRACCT();
			if (entAccountNo.length() > 34){
				entAccountNo = entAccountNo.substring(0, 34);
			}else if(entAccountNo.length() < 34){
				entAccountNo += genSpace(16-entAccountNo.length());
			}
				
			
			//�νs/�����r��
			String custID = CommonUtil.AllTrim(rmtVO.getRID());	
			
			//����m�W
			String custName = CommonUtil.AllTrim(rmtVO.getRNAME());
			
			//�^��m�W
			String entNameT = (rmtVO.getPENGNAME() == null) ? "" : CommonUtil.AllTrim(rmtVO.getPENGNAME()).toUpperCase();
			
			//�״ڪ��B			
			double remitAmtNum = disbBean.DoubleSub(rmtVO.getRPAYAMT(), rmtVO.getRBENFEE());// R70455
			String remitAmt = df.format(remitAmtNum);
			
			//SWIFT CODE
			String swiftCode = rmtVO.getSWIFTCODE() == null ? "" : rmtVO.getSWIFTCODE();
			
			//�״ڦ�
			String rbk = rmtVO.getRBK() == null ? "" : rmtVO.getRBK().substring(0, 3);
			
			//�D���
			String pBank = rmtVO.getPBK();
			String pBranck;
			if (pBank == null)
				pBranck = "   ";
			else {
				// �Y���� 6 ��, ���ɨ��A��
				if (pBank.length() < 6)
					pBank = pBank + "      ".substring(0, 6 - pBank.length());
				pBranck = pBank.substring(3, 6);
			}

			//�w�w�ι�ڤJ�b��
			String remitDate = rmtVO.getRMTDT();
			if(index >0 && !remitDataChange){
				if(!remitDateTmp.equals(remitDate)) remitDataChange = true;
			}
			remitDateTmp = remitDate;
			downloadInfo[index+1][0] = String.format("%4d", new Integer(index+1)); //�s��,1
			downloadInfo[index+1][1] = genSpace(1); //���ϥ�,2
			downloadInfo[index+1][2] = "TransGlobe Life Insurance Inc." + genSpace(40); //�״ڥӽФH�W��,3
			downloadInfo[index+1][3] = "16F, No.288, Sec. 6, Civic Blvd., Taipei City 110, Taiwan, R.O.C." + genSpace(5); //�״ڥӽФH�a�},4
			downloadInfo[index+1][4] = "70817744" + genSpace(2); //�״ڤH�Ҹ�,5
			downloadInfo[index+1][5] = "TW"; //���ڤH��O,6
			downloadInfo[index+1][6] = "693"; //�״ڤ����s��,7
			downloadInfo[index+1][7] = "A"; //���ڦ�SWIFT�榡,8
			downloadInfo[index+1][8] = swiftCode + genSpace(105-swiftCode.length()); //���ڦ�W�٤Φa�}/SWIFT CODE,9
			downloadInfo[index+1][9] = genSpace(30); //���ڦ�Ȧ�s��,10
			downloadInfo[index+1][10] = entNameT + genSpace(70 - entNameT.getBytes().length); //���ڤH�W��,11
			downloadInfo[index+1][11] = genSpace(70); //���ڤH�a�},12
			downloadInfo[index+1][12] = entAccountNo + genSpace(34-entAccountNo.length()); //���ڤH�b��,13
			downloadInfo[index+1][13] = genSpace(12-remitAmt.length()) + remitAmt; //�״ڪ��B,14
			downloadInfo[index+1][14] = genSpace(140); //�Ƶ�,15
			downloadInfo[index+1][15] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][16] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][17] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][18] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][19] = ""; //�ɻ�downloadInfo
			downloadInfo[index+1][20] = ""; //�ɻ�downloadInfo
			
			remitAmtNumSum += remitAmtNum;
			remitCount++;
		}//end for

		//�������
		String Field00 = "�s��";
		String Field01 = " ";
		String Field02 = "�״ڥӽФH�W��                                                        ";
		String Field03 = "�״ڥӽФH�a�}                                                        ";
		String Field04 = "�״ڤH�Ҹ�";
		String Field05 = "��";
		String Field06 = "��  ";
		String Field07 = "SWIFT_CODE                                                                                               ";
		String Field08 = "";
		String Field09 = "���ڦ�Ȧ�s��                ";
		String Field10 = "���ڤH�W��                                                            ";
		String Field11 = "���ڤH�a�}                                                            ";
		String Field12 = "���ڤH�b��                        ";
		String Field13 = "�״ڪ��B    ";
		String Field14 = "�Ƶ�                                                                                                                                        ";
		
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
		downloadInfo[0][15] = ""; //�ɻ�downloadInfo
		downloadInfo[0][16] = ""; //�ɻ�downloadInfo
		downloadInfo[0][17] = ""; //�ɻ�downloadInfo
		downloadInfo[0][18] = ""; //�ɻ�downloadInfo
		downloadInfo[0][19] = ""; //�ɻ�downloadInfo
		downloadInfo[0][20] = ""; //�ɻ�downloadInfo
		
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