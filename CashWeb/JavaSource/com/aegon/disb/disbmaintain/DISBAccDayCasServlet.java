package com.aegon.disb.disbmaintain;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import com.aegon.comlib.*;
import com.aegon.disb.util.DISBBean;
import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.StringTool;

import javax.servlet.ServletContext;
import java.sql.*;

public class DISBAccDayCasServlet extends HttpServlet {
	private GlobalEnviron globalEnviron = null;
	private DbFactory dbFactory = null;
	private CommonUtil commonUtil = null;
	private DISBBean disbBean = null;
	private boolean isAEGON400 = false;

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private String path = "";
	private DecimalFormat df = new DecimalFormat("0");
	//Initialize global variables
	/**
	* @see javax.servlet.GenericServlet#void ()
	*/
	public void init() throws ServletException {
		super.init();
		if (getServletContext().getAttribute(Constant.GLOBAL_ENVIRON)
			!= null) {
			globalEnviron =
				(GlobalEnviron) getServletContext().getAttribute(
					Constant.GLOBAL_ENVIRON);
		}
		if (getServletContext().getAttribute(Constant.DB_FACTORY) != null) {
			dbFactory =
				(DbFactory) getServletContext().getAttribute(
					Constant.DB_FACTORY);
		}

		if (globalEnviron
			.getActiveAS400DataSource()
			.equals(Constant.AS400_DATA_SOURCE_NAME_AEGON400)) {
			isAEGON400 = true;
		}

	}
	//Process the HTTP Get request
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	//Process the HTTP Post request
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType(CONTENT_TYPE);
		try{
				this.downloadProcess(request, response);
		}catch(Exception e){
			System.err.println(e.toString());	
			RequestDispatcher dispatcher = null;
			request.setAttribute("txtMsg",e.getMessage());		
			dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccDayCas.jsp");
			dispatcher.forward(request, response);
		}		
	}
	
	/**
	 * @param request
	 * @param response
	 */
	private void downloadProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, Exception{
		// TODO downloadProcess
		System.out.println("inside downloadProcess");
		List alDwnDetails = new ArrayList();
				
		alDwnDetails = (List)getUnNormalPayments(request,response,alDwnDetails);
		if(alDwnDetails.size()>0)
		{	
			ServletOutputStream os = response.getOutputStream();	
			try{
					
				/*ConvertData*/
				response.setContentType("text/plain");//text/plain
				response.setHeader("Content-Disposition","attachment; filename=AccCdDpDetails.txt" );
					String export = "";
					for(int i = 0; i<alDwnDetails.size(); i++){
						DISBAccCodeDetailVO objAccCodeDetail =(DISBAccCodeDetailVO)alDwnDetails.get(i);		  
						String strCheckDt = null;
						String strActCd2 = null;
						String strActCd3 = null;
						String strActCd5 = null;
						String strDesc = null;
						String strSlipNo = null;
						String strDAmt = null;
						String strCAmt = null;
						String strPCfmDt = null;
						String strCurrency = null;
						
						strCurrency =objAccCodeDetail.getStrCurr();
						strActCd2 = objAccCodeDetail.getStrActCd2();
						for(int count=strActCd2.length(); count<10 ;count++){
							strActCd2+=" ";
						}
						strActCd3 = objAccCodeDetail.getStrActCd3();
						for(int count=strActCd3.length(); count<3 ;count++){
							strActCd3+=" ";
						}		
						strActCd5 = objAccCodeDetail.getStrActCd5();
						for(int count=strActCd5.length(); count<26 ;count++){//R61017 ActCd5��13�X��26�X
							strActCd5+=" ";
						}		

						strPCfmDt = objAccCodeDetail.getStrDate1();
						for(int count=strPCfmDt.length(); count<10 ;count++){
							strPCfmDt+=" ";
						}
	
						strDAmt = objAccCodeDetail.getStrDAmt();
						for(int count=strDAmt.length(); count<13 ;count++){
							strDAmt =" " + strDAmt;
						}
		
						strCAmt = objAccCodeDetail.getStrCAmt();
						for(int count=strCAmt.length(); count<13 ;count++){
							strCAmt =" " + strCAmt;
						}
		
						//DESCRIPTION,x(30) �]������ �ҥHstrDesc.length()*2
						strDesc = objAccCodeDetail.getStrDesc()==null?"":objAccCodeDetail.getStrDesc();
						strDesc = strDesc.trim();
						if(strDesc.length() >15)
						{
							strDesc = strDesc.substring(0,15);
						}
						for(int count=strDesc.length()*2; count<30;count++ ){
								strDesc=strDesc+" ";
						}
							
						strCheckDt = objAccCodeDetail.getStrCheckDate();
						for(int count=strCheckDt.length(); count<8 ;count++){
							strCheckDt+=" ";
						}
						strSlipNo = objAccCodeDetail.getStrSlipNo();
						for(int count=strSlipNo.length(); count<9 ;count++){
							strSlipNo+=" ";
						}
						export+=	"Manual";//Category, x(6)				
						export+=	 "Spreadsheet";//Source,x(11)									
						export+=	 "TWD";//Currency,x(3),
						export+=	 "0";//ACTCD1,x(1)
						export+=	 strActCd2;//ACTCD2,x(10)
//						export+=	 "8223";//ACTCD3,x(4)
						export+=	 strActCd3;//ACTCD3,x(4)
						export+=	 "00";//ACTCD4,x(2)
//						export+=	 "0000000000000";//ACTCD5,x(13)
						export+=	 strActCd5;//ACTCD5,x(26) ,R61017 ActCd5��13�X��26�X
						export+=	 strPCfmDt;//��I�T�{�騴��,YYYY/MM/DD,x(10)
						export+=	 strCAmt;//�ɤ���B,x(12),�w�]��0,�����e�ɪť�, 000,000
						export+=	 strDAmt;//�U����B,x(12),�w�]��0,�����e�ɪť�, 000,000
						export+=	 strSlipNo;//SlipNo,x(9), ��I�T�{�騴�餧�褸�~��G�X+MMDD + 3�ӯS�w�X
						export+=	 strDesc;//Description ,x(30),������ɪť�
						export+=	 strCheckDt;//��I�T�{�騴��,YYYY/MM/DD,x(10)
						if(i<alDwnDetails.size()-1)
							export+=((char)13);//����
					}
					ByteArrayInputStream is = new ByteArrayInputStream(export.getBytes());
					int reader = 0;
					byte[] buffer = new byte[1 * 1024];
					while ((reader = is.read(buffer)) > 0) {
						os.write(buffer, 0, reader);
					}			
			}finally{
		
				os.flush();
				os.close();
			}
		}
		else
		{
		  //�d�L��Ʀ^�ǿ��~�T��
		 	 RequestDispatcher dispatcher = null;
		 	 request.setAttribute("txtMsg", "�d�L�i�U�����,�Э��s�d��!");
		 	dispatcher = request.getRequestDispatcher("/DISB/DISBMaintain/DISBAccRmtFail.jsp");
			dispatcher.forward(request, response);
		}
	}

	/**
	 * @param request
	 * @param response
	 * @return
	 */
	private List getUnNormalPayments(HttpServletRequest request, HttpServletResponse response,List alDwnDetails) {
	
	Connection con =	dbFactory.getAS400Connection("DISBCheckStockServlet.inquiryDB()");
	CommonUtil commonUtil = new CommonUtil();
	Statement stmt = null;
	ResultSet rs = null;
	String strSql = ""; //SQL String
	int iPDate = 0;
	double iPayAmt =0.0;
	List alReturn = new ArrayList();
	String strPDate = ""; // �t�Τ��
		
		strPDate = request.getParameter("txtPDate");
	if (strPDate != null)
		strPDate = strPDate.trim();
	else
		strPDate = "";
		
	iPDate = Integer.parseInt(strPDate) + 1110000;		
    System.out.println(iPDate);
	System.out.println(strPDate);
	String DateTemp = Integer.toString(1911 + Integer.parseInt(strPDate.substring(0,2))) + "/" + strPDate.substring(2,4) + "/" + strPDate.substring(4,6);
	String DateTemp1 = Integer.toString(1911 + Integer.parseInt(strPDate.substring(0,2))) +  strPDate.substring(2,4) +  strPDate.substring(4,6);
	
	/*0.�{���]ornbta�^_�{�ɾ��� */	
	//R70770 �H�UZZ�אּZZZ 
	try
	{
		strSql =
			"select SUM(PAYAMT) AS SPAMT";
			strSql += " from ORNBTA ";
			strSql += "WHERE 1=1  and PAYIND='0' and CASHBNK = '9998' ";
			strSql += " and crtdate = " + iPDate ;
		System.out.println("strSql_1"+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		alReturn = alDwnDetails;
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {				
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2("12000100ZZZ");
			objAccCodeDetail.setStrActCd3("0000");
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("��Ѣޢޡ��{�ɾ���");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
            objAccCodeDetail.setStrCurr("TWD");
		    objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}	
		}	
		rs.close();
		strSql = null;

		/*0.�{���]ornbta�^_�B�Q���M�ץ� */	
		strSql =
			"select SUM(PAYAMT) AS SPAMT";
			strSql += " from ORNBTA ";
			strSql += "WHERE 1=1  and PAYIND='0' and CASHBNK = '9999' ";
			strSql += " and crtdate = " + iPDate ;
		System.out.println("strSql_�B�Q���M�ץ�"+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2("12000100ZZZ");
			objAccCodeDetail.setStrActCd3("0000");
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("��ѢޢޡļB�Q���M�ץ�");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*RCPP_1. �״� */	
		strSql =
			"select a.cbkcd cbkcd,B.GLACT GLACT,SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a, capbnkf b ";
			strSql += " WHERE 1=1 and a.cbkcd = b.bkcode and  a.catno = b.bkatno and a.crosrc in ('11', '16', '17', '18') ";
			strSql += " and a.csfbau = 'CAPCSH01B'";
			strSql += " and a.caegdt = " + strPDate ;
			strSql += " group by a.cbkcd,b.glact";
			strSql += " order by cbkcd,glact";
		System.out.println("strSql_RCPP_1. �״� "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2("10172000ZZZ");
			objAccCodeDetail.setStrActCd3(rs.getString("GLACT").substring(8,11) + rs.getString("GLACT").substring(12,13));
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("��ѢޢޡĶ״�");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;
		
		/*RCPP_2. �䲼 */	
		    strSql =  " select SUM(payamt) AS SPAMT";
			strSql += " from ornbta ";
			strSql += " WHERE 1=1 and  payind = '2' ";			
		    strSql += " and crtdate = " + iPDate ;
		System.out.println("strSql_RCPP_2. �䲼 "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2("11000000ZZZ");
			objAccCodeDetail.setStrActCd3("0000");
			objAccCodeDetail.setStrActCd5("N1000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("��ѢޢޡĤ䲼");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*RCPP_3. (EDC) �H�Υd */	
		strSql =
			"select SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a, capbnkf b ";
			strSql += " WHERE 1=1 and a.cbkcd = b.bkcode and  a.catno = b.bkatno and a.crosrc ='13' ";
			strSql += " and a.csfbau = 'CAPCSH01B'";
			strSql += " and a.caegdt = " + strPDate ;
		System.out.println("strSql_RCPP_3. (EDC) �H�Υd "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2("11100000ZZZ");			                               
			objAccCodeDetail.setStrActCd3("0000");
			objAccCodeDetail.setStrActCd5("P1000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("��ѢޢޡīH�Υd");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*RCPP_5. ���� */	
		strSql =
			"select b.glact glact,SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a, capbnkf b ";
			strSql += " WHERE 1=1 and a.cbkcd = b.bkcode and  a.catno = b.bkatno and a.crosrc ='15' ";
			strSql += " and a.csfbau = 'CAPCSH01B'";
			strSql += " and a.caegdt = " + strPDate ;
			strSql += " group by glact";
		System.out.println("strSql_RCPP_5. ���� "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2("10172000ZZZ");
			objAccCodeDetail.setStrActCd3(rs.getString("GLACT").substring(8,11) + rs.getString("GLACT").substring(12,13));
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("��ѢޢޡĹ���");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*�妸�@�~_A. �l�� */		
		strSql =
			"select a.cbkcd cbkcd,b.glact glact, SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a, capbnkf b ";
			strSql += " WHERE 1=1 and a.cbkcd = b.bkcode and  a.catno = b.bkatno and a.crosrc not like '1%' ";
			strSql += " and a.csfbau = 'CAP1132B3'";
			strSql += " and a.caegdt = " + strPDate ;
			strSql += " group by a.cbkcd ,b.glact";
			strSql += " order by cbkcd ,glact";
		System.out.println("strSql_�妸�@�~_A.�l�� "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2(rs.getString("glact").substring(0,6) + "00ZZZ");
			objAccCodeDetail.setStrActCd3(rs.getString("GLACT").substring(8,11) + rs.getString("GLACT").substring(12,13));
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("�妸�Ķl��");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*�妸�@�~_B. �Ȧ� ATM & �״� */		
		strSql =
			"select a.cbkcd cbkcd,b.glact glact, SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a, capbnkf b ";
			strSql += " WHERE 1=1 and a.cbkcd = b.bkcode and  a.catno = b.bkatno ";
			strSql += " and a.crosrc not like '1%'"; 
			strSql += " and a.crosrc not like 'A%'";
			strSql += " and a.csfbau = 'CAP1185B3'";
			strSql += " and a.caegdt = " + strPDate ;
		    strSql += " group by a.cbkcd ,b.glact";
		    strSql += " order by cbkcd,glact"; 
		System.out.println("strSql_�妸�@�~_B. �Ȧ� ATM & �״� "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2(rs.getString("glact").substring(0,6) + "00ZZZ");
			objAccCodeDetail.setStrActCd3(rs.getString("GLACT").substring(8,11) + rs.getString("GLACT").substring(12,13));
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("�妸�ĻȦ�Ϣ�۶״�");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*�妸�@�~_C. �K�Q�ө��״� */		
		strSql =
			"select a.cbkcd cbkcd,b.glact glact, SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a, capbnkf b ";
			strSql += " WHERE 1=1 and a.cbkcd = b.bkcode and  a.catno = b.bkatno ";
			strSql += " and a.crosrc not like '1%'"; 
			strSql += " and a.crosrc like 'A%'";
			strSql += " and a.csfbau = 'CAP1185B3'";
			strSql += " and a.caegdt = " + strPDate ;
		    strSql += " group by a.cbkcd ,b.glact";
		    strSql += " order by cbkcd,glact ";
		System.out.println("strSql_�妸�@�~_C. �K�Q�ө��״� "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2("12000100ZZZ");
			objAccCodeDetail.setStrActCd3("0000");
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("�妸�īK�Q�ө��״�");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*�妸�@�~_D. �H�Υd��b */		
		strSql =
			"select a.cbkcd cbkcd,b.glact glact, SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a, capbnkf b ";
			strSql += " WHERE 1=1 and a.cbkcd = b.bkcode and  a.catno = b.bkatno ";
			strSql += " and a.crosrc not like '1%'"; 
			strSql += " and a.csfbau = 'CAPCSH02B'";
			strSql += " and a.caegdt = " + strPDate ;
		    strSql += " group by a.cbkcd ,b.glact";
		    strSql += " order by cbkcd,glact";
		System.out.println("strSql_�妸�@�~_D.�H�Υd��b "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2(rs.getString("glact").substring(0,6) + "00ZZZ");
			objAccCodeDetail.setStrActCd3("0000");
			objAccCodeDetail.setStrActCd5("P1000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("�妸�īH�Υd��b");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*�妸�@�~_E. �Ȧ���b */		
		strSql =
			"select a.cbkcd cbkcd,b.glact glact, SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a, capbnkf b ";
			strSql += " WHERE 1=1 and a.cbkcd = b.bkcode and  a.catno = b.bkatno ";
			strSql += " and a.crosrc not like '1%'"; 
			strSql += " and a.csfbau = 'CAPCSH03B'";
			strSql += " and a.caegdt = " + strPDate ;
		    strSql += " group by a.cbkcd ,b.glact";
		    strSql += " order by cbkcd,glact ";
		System.out.println("strSql_�妸�@�~_E. �Ȧ���b "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2(rs.getString("glact").substring(0,6) + "00ZZZ");
			objAccCodeDetail.setStrActCd3(rs.getString("GLACT").substring(8,11) + rs.getString("GLACT").substring(12,13));
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("�妸�ĻȦ���b");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;

		/*�妸�@�~_F.BD�妸 */		
		strSql =
			"select SUM(a.croamt) AS SPAMT";
			strSql += " from capcshfb a ";
			strSql += " WHERE 1=1 ";
			strSql += " and a.crosrc not like '1%'"; 
			strSql += " and a.csfbau = 'CAPCSH04B'";
			strSql += " and a.caegdt = " + strPDate ;
		System.out.println("strSql_�妸�@�~_F.BD�妸 "+strSql);
		stmt = con.createStatement();
		rs = stmt.executeQuery(strSql);
		while (rs.next()) {
			if (rs.getDouble("SPAMT") != 0.0 ) {
			DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
			objAccCodeDetail.setStrActCd2("10172000ZZZ");
			objAccCodeDetail.setStrActCd3("0000");
			objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
			objAccCodeDetail.setStrDesc("�妸�ĢТҧ妸");			
			objAccCodeDetail.setStrCAmt(df.format(rs.getDouble("SPAMT")));
			objAccCodeDetail.setStrDAmt("0");
			objAccCodeDetail.setStrCheckDate(DateTemp1);
			objAccCodeDetail.setStrDate1( DateTemp);
			objAccCodeDetail.setStrCurr("TWD");
			objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
			alReturn.add(objAccCodeDetail);
			iPayAmt  = iPayAmt + rs.getDouble("SPAMT");
			}
		}		
		rs.close();
		strSql = null;
		
		//�U��
		DISBAccCodeDetailVO objAccCodeDetail = new DISBAccCodeDetailVO();
		objAccCodeDetail.setStrActCd2("29003000ZZZ");
		objAccCodeDetail.setStrActCd3("0000");
		objAccCodeDetail.setStrActCd5("00000000000000000000000000");//R61017 ActCd5��13�X��26�X
		objAccCodeDetail.setStrDesc("");			
		objAccCodeDetail.setStrCAmt("0");
		objAccCodeDetail.setStrDAmt(df.format(iPayAmt));
		objAccCodeDetail.setStrCheckDate(DateTemp1);
		objAccCodeDetail.setStrDate1( DateTemp);
		objAccCodeDetail.setStrCurr("TWD");
		objAccCodeDetail.setStrSlipNo(DateTemp.substring(2,4) + DateTemp.substring(5,7) + DateTemp.substring(8) + "021");
		alReturn.add(objAccCodeDetail);
		
		
		
	//	System.out.println("4.alReturn.size()"+alReturn.size());
	} catch (SQLException ex) {
		request.setAttribute("txtMsg", "�d�ߥ���" + ex);
		alReturn = null;
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
		}
	}
	return alReturn;
	}


}
