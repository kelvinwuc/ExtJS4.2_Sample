package com.aegon.disb.disbcheck;
        
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.text.*;
import java.util.*;

import com.aegon.comlib.*;
import com.aegon.disb.util.DISBBean;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;

import com.aegon.disb.util.DISBPaymentDetailVO;
import com.aegon.disb.util.DISBCheckDetailVO;

import java.sql.*;

/*
 * System   :
 * 
 * Function :
 * 
 * Remark   :
 * 
 * Revision : $$Revision: 1.7 $$
 * 
 * Author   : Angel chen
 * 
 * Create Date : $$date$$
 * 
 * Request ID : R50
 * 
  
 */
public class DISBCheckCreateBatchServlet  extends com.aegon.comlib.InitDBServlet  {

	private static final String CONTENT_TYPE = "text/html; charset=Big5";
	private String path = "";
	private DecimalFormat df = new DecimalFormat("#.00");
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
		
		try{
			if("inquiry".equals(request.getParameter("action"))){				
				this.inquiryDB(request, response);
			 }
			if("DISBCheckCreate".equals(request.getParameter("txtAction"))){
			    this.checkCreateProcess(request, response);
			} 
		}catch(Exception e){
			System.err.println(e.getMessage());
			throw new ServletException(e.getMessage());	
		}
		
		//RequestDispatcher dispatcher = request.getRequestDispatcher(path);	
		//dispatcher.forward(request, response);
	}
	
	private void inquiryDB(HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException, Exception {
		HttpSession session = request.getSession(true);
		//Check that we have a file upload request
		RequestDispatcher dispatcher = null;
		boolean isMultipart = FileUpload.isMultipartContent(request);
		if(!isMultipart){
			request.setAttribute("txtMsg","It's not a file upload.");
			System.err.println("It's not a file upload.");
			return;
		}		
		Connection con =
		dbFactory.getAS400Connection("DISBPMaintainServlet.inqueryDB()");
	    Statement stmt = null;
	    ResultSet rs = null;
	    String strSql = ""; //SQL String
			
		//Create a new file upload handler
		DiskFileUpload upload = new DiskFileUpload();

		//Parse the request
		List /* FileItem */ items = upload.parseRequest(request);
		
		//Set upload parameters
		//sizeThreshold - The max size in bytes to be stored in memory.
		//sizeMax - The maximum allowed upload size, in bytes.
		//path - The location where the files should be stored. 
		upload.setSizeThreshold(1024*300);
		upload.setSizeMax(1024*4);
		upload.setRepositoryPath("C:\\temp\\");
      
		//Process the uploaded items
		Iterator iter = items.iterator();
		Vector Chequelist = new Vector();
		
		 //while (iter.hasNext()) {
			 FileItem item = (FileItem) iter.next();
		     Chequelist = processUploadedFile(item);
		// }
		DISBCheckCashedDAO dao = new DISBCheckCashedDAO(dbFactory);				 
	
		
	
//R00393		Edit by Leo Huang (EASONTECH) Start
		//CommonUtil commonUtil = new CommonUtil();
		//int currDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(Calendar.getInstance().getTime()));

		Calendar calendar = commonUtil.getBizDateByRCalendar();
		int currDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(calendar.getTime()));
//R00393		Edit by Leo Huang (EASONTECH) End
			
		DISBPaymentDetailVO objPDetailVO = null;
		List alPDetail = new ArrayList();
		List alPDetailTemp = new ArrayList();
		DISBCheckDetailVO objCDetailVO = null;
		//票據號碼,保單號碼,金額,匯費,付款日期
		String strChequeNo ="";
		String strPolicyNo ="";
		String strAmt ="";
		String strFee="";
		String strPDate="";
		String strCQDate="";//RC0036 - 到期日
		String strChequeNoTmp="";
		
		int intAmt =0;
		int intFee=0;
		int intPDate=0;
		int intCQDate=0;//RC0036
		double intAmtTOT = 0;
		double intTotalSum = 0;
		int intTotalRec = 0;					  		
	   
	   for(int index = 0; index< Chequelist.size(); index++){
		 String[] data = (String[])Chequelist.get(index);
		 strChequeNo = data[0];
		 if (strChequeNo != null)
			strChequeNo = strChequeNo.trim();
		 else
			strChequeNo="";
		//不同支票,累加金額歸0	
		 if (index == 0)
		   strChequeNoTmp = strChequeNo ;  
		
		 if ( index != 0 && !strChequeNo.equals(strChequeNoTmp)){
			objPDetailVO = new DISBPaymentDetailVO();
			objPDetailVO.setIPAMT(intAmtTOT);
			alPDetail.add(objPDetailVO);
			strChequeNoTmp = strChequeNo ;
			intAmtTOT = 0 ; 
		 } 
		
		strPolicyNo = data[1];
		 if (strPolicyNo != null)
		    strPolicyNo = strPolicyNo.trim();
		 else
		   strPolicyNo ="";
		 
		 strAmt = data[2];
		 if (strAmt != null){
		   strAmt = strAmt.trim();
		   intAmt =Integer.parseInt(strAmt);}
		 else{
		   strAmt="";
		   intAmt =0;}
		     
		 strFee = data[3];
		 if (strFee != null){
		 	strFee = strFee.trim();
		 	intFee = Integer.parseInt(strFee);}
		 else{
		    strFee = "";
		    intFee = 0;}	

		strPDate = data[4];
  	    if (strPDate != null){
			strPDate = strPDate.trim();
			intPDate = Integer.parseInt(strPDate) - 19110000 ;}
		else{
			strPDate = "";
			intPDate = 0;}	
  	    
  	    //RC0036
  	    strCQDate = data[5];
	    if (strCQDate != null){
	    	strCQDate = strCQDate.trim();
			intCQDate = Integer.parseInt(strCQDate) - 19110000 ;}
		else{
			strCQDate = "";
			intCQDate = 0;}	
		 			
//RC0036		strSql = "select A.PNO,A.PAMT,A.PNAME,A.PDATE,A.POLICYNO";
//RC0036		strSql += " from CAPPAYF A ";
//RC0036  	    strSql += "WHERE 1=1 and A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  and A.PCFMDT2<>0 AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>''  AND A.PCSHDT = 0 AND A.PMETHOD in('A','B','E')  AND A.PVOIDABLE<>'Y' AND PDISPATCH = 'Y' ";

  	    /*RC0036*/		
  	    strSql = "select A.PNO,A.PAMT,A.PNAME,A.PDATE,A.POLICYNO,A.PMETHOD,B.DEPT,B.USRAREA";
  	    strSql += " from CAPPAYF A, USER B ";
	    strSql += "WHERE 1=1 and A.PCFMDT1<>0 AND A.PCFMTM1<>0 AND A.PCFMUSR1 <>''  and A.PCFMDT2<>0 AND A.PCFMTM2<>0 AND A.PCFMUSR2 <>'' AND A.PCFMUSR1 = B.USRID AND A.PCSHDT = 0 AND A.PMETHOD in('A','B','E')  AND A.PVOIDABLE<>'Y' AND PDISPATCH = 'Y' ";
		strSql += " and A.POLICYNO = '" + strPolicyNo +"' and PAMT =" + intAmt ;
		
		//System.out.println(strSql);
		try {
			  stmt = con.createStatement();
			  rs = stmt.executeQuery(strSql);
			  String strAnswer = "";
			  while (rs.next()) {
			   objPDetailVO = new DISBPaymentDetailVO();
			   objPDetailVO.setStrPNO(rs.getString("PNO"));//支付序號
			   objPDetailVO.setStrPolicyNo(rs.getString("POLICYNO"));//保單號碼
			   objPDetailVO.setIPAMT(rs.getDouble("PAMT")); //支付金額	
			   objPDetailVO.setIPDate(rs.getInt("PDATE")); //付款日期
			   objPDetailVO.setIRmtFee(intFee);//匯費
			   objPDetailVO.setStrPCheckNO(strChequeNo);//支票號碼
			   objPDetailVO.setIPCshDt(intPDate);//出納日期
			   objPDetailVO.setICQDate(intCQDate);//RC0036 到期日
			   objPDetailVO.setStrPName(rs.getString("PNAME"));
			   objPDetailVO.setStrPMethod(rs.getString("PMETHOD"));// RC0036 付款方式
			   objPDetailVO.setStrUsrDept(rs.getString("DEPT")); // RC0036 承辦部門
			   objPDetailVO.setStrUsrArea(rs.getString("USRAREA")); // RC0036 承辦職域
			   alPDetail.add(objPDetailVO);
			   alPDetailTemp.add(objPDetailVO);
			   intAmtTOT = intAmtTOT + rs.getDouble("PAMT") + intFee;
			   intTotalSum = intTotalSum + rs.getDouble("PAMT") + intFee;
			   intTotalRec ++;			   			  
		      }
		} catch (SQLException ex) {
			request.setAttribute("txtMsg", "查詢失敗"+ex);
			alPDetail = null;
		} finally {
		}
	  }//end for
	  try {
		if (intAmtTOT != 0){
		  objPDetailVO = new DISBPaymentDetailVO();
		  objPDetailVO.setIPAMT(intAmtTOT);
		  alPDetail.add(objPDetailVO);
   		  }
	  	
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

	  if(alPDetail.size()>0)
	  {
		  session.setAttribute("PDetailListBatch", alPDetailTemp);
		  session.setAttribute("PDetailListTmpBatch", alPDetail);
	  }
	  else
	  {
		  request.setAttribute("txtMsg", "查無資料");
	  }	
	 
	  request.setAttribute("txtAction", "I");
	  request.setAttribute("txtSum", df.format(intTotalSum));
	  request.setAttribute("txtRec", df.format(intTotalRec));
	  dispatcher = request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckCreateBatch.jsp");
	  dispatcher.forward(request, response);
			
      return;
	  	 
	}
	
	
	private Vector processUploadedFile(FileItem item) throws Exception{
		Vector Chequelist = new Vector();
		//		Process a file upload
		if (!item.isFormField()) {			
			String content = item.getString();
			String line = "";
			StringTokenizer st = null;
			Vector ret = new Vector();
			if(content != null) {
				st = new StringTokenizer(content, "\r\n");
				while(st.hasMoreTokens()) {				
					line = st.nextToken();
					String[] data = new String[6];
					data = split(line , ",") ; 
					String[] data1 = new String[6] ;
					for(int index = 0 ; index < data.length ; index++)
					{						
            			data1[index] = "";
            			//System.out.println(data[index]);
            			data1[index] = data[index];
					}												
					Chequelist.add(data1);
				} 
			}
		 }
		return Chequelist;
	}
	

	/**
	 * str = 123,456,789A; 
	 * reg = , 用來切割字串的辨識字元
	 */
	public String[] split(String str, String reg){
		int e = 0;		
		java.util.Vector v = new java.util.Vector();		
		while(1==1){
			e = str.indexOf(reg);
			if(e==-1){
				v.add(str);
				break;
			}else{				
				v.add(str.substring(0,e));
				str = str.substring(e+1);
			}									
		}
		return (String[])v.toArray(new String[v.size()]);
	}

	private void checkCreateProcess(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {
	
		System.out.println("@@@@@inside checkCreation");
		HttpSession session = request.getSession(true);
		RequestDispatcher dispatcher = null;
		//R00393  Edit by Leo Huang (EASONTECH) Start
	//	Calendar cldToday = Calendar.getInstance(Constant.CURRENT_LOCALE);
    	
	    Calendar cldToday = commonUtil.getBizDateByRCalendar();
//R00393		Edit by Leo Huang (EASONTECH) End
		SimpleDateFormat sdfFormatter = new SimpleDateFormat("HHmmss");
		String strLogonUser =
			(String) session.getAttribute(Constant.LOGON_USER_ID);
		Connection con =
			dbFactory.getAS400Connection("DISBCheckCreateServlet.checkCreation()");
		PreparedStatement pstmtTmp = null;
//R00393		Edit by Leo Huang (EASONTECH) Start
		//CommonUtil commonUtil = new CommonUtil();
//R00393		Edit by Leo Huang (EASONTECH) End
		String strSql = ""; //SQL String
		String strReturnMsg = "";
		boolean bContinue = true;
		boolean bFlag = true;
		List alReturnInfo = new ArrayList();
		List alCheckList = new ArrayList();
		List alCheckInfo = new ArrayList();
		List alPayList = new ArrayList();
		alCheckList = (List) maintainPList(request, response);		
		
		List alPDetail =(List) session.getAttribute("PDetailListBatch");
		int iUpdDate =
			Integer.parseInt(
				(String) commonUtil.convertWesten2ROCDate1(cldToday.getTime()));
		int iUpdTime =
			Integer.parseInt((String) sdfFormatter.format(cldToday.getTime()));
		try {
			if (alCheckList != null) {
				if (alCheckList.size() > 0) {
					
					for (int i = 0; i < alCheckList.size(); i++) {
						DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckList.get(i);
						/*判斷票號是否存在 / 是否為人工票 / 是否已被使用*/
						alReturnInfo = (List)this.getCheckInfo(objCDetailVO);
						String strReturnFlag = (String)alReturnInfo.get(0);
						String strReturnMsgTemp = (String)alReturnInfo.get(1);
						if(!strReturnFlag.equals("0"))
						{
							strReturnMsg += strReturnMsgTemp ;
							bContinue = false;
						}
						else
						{
							alCheckInfo.add((DISBCheckDetailVO) alReturnInfo.get(2));
							alPayList.add((DISBPaymentDetailVO) alPDetail.get(i));
							bContinue = true;
						}
					}	 
				   if(bContinue)
				   {
						/*更新支票明細檔*/
						//strReturnMsg = updateCheckInfo(alCheckInfo,alPDetail,iUpdDate,con);
						strReturnMsg = updateCheckInfo(alCheckInfo,alPayList,iUpdDate,con);
						if(strReturnMsg.equals(""))
						{
							/*更新支付主檔及下LOG*/
							
							//strReturnMsg = updatePDetails(alCheckInfo, alPDetail, iUpdDate, iUpdTime, strLogonUser, con);
							strReturnMsg = updatePDetails(alCheckInfo, alPayList, iUpdDate, iUpdTime, strLogonUser, con);
							if(strReturnMsg.equals(""))
							{
								request.setAttribute("txtMsg", "人工開票成功");
								bContinue = true;
							}							
							else
							{//更新支付主檔及下LOG失敗
								bContinue = false;
							}	
						}
						else
						{//更新支票明細檔失敗
							bContinue = false;
						}
				   }//bContinue
				   if (!bContinue) //如有錯誤時則 roll back
				   {
					   request.setAttribute("txtMsg",strReturnMsg);
					   if (isAEGON400) {
						   con.rollback();
					   }
					request.setAttribute("txtAction", "DISBCheckCreate");
					dispatcher =request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckCreateBatch.jsp");
					dispatcher.forward(request, response);
					 return;
				   }

				}
			}
		} catch (SQLException e) {
			request.setAttribute("txtMsg", "人工開票失敗-->" + e);
			if (con != null)
				dbFactory.releaseAS400Connection(con);
		} finally {
			if (con != null) {
				dbFactory.releaseAS400Connection(con);
			}
		}
		request.setAttribute("txtAction", "DISBCheckCreate");
		dispatcher =
			request.getRequestDispatcher("/DISB/DISBCheck/DISBCheckCreateBatch.jsp");
		dispatcher.forward(request, response);
		 return;
	}

	private List maintainPList(
		HttpServletRequest request,
		HttpServletResponse response)
		throws ServletException, IOException {
			HttpSession session = request.getSession(true);
		int x = 0;
		int j = 1;
		int pageNo = 0;
		int iSize = 0;

		String strCNoTemp= "";
		String strPCshDtTemp="";
		String strFee="";
		boolean bIsChecked = false;
		DISBCheckDetailVO objCDetailVO = null;		
		List alCheckList = new ArrayList();
		List alPDetail =(List) session.getAttribute("PDetailListBatch");
		//	(List) session.getAttribute("PDetailListBatch");
		
		if (alPDetail != null)
			iSize = alPDetail.size();
	
		for (int i = 0; i <iSize; i++) {
										
			DISBPaymentDetailVO objPDetailVO = (DISBPaymentDetailVO)alPDetail.get(i);
										
			if ( objPDetailVO.getStrPNO() != null){
			 if(!objPDetailVO.getStrPNO().equals("")){
				    objCDetailVO = new DISBCheckDetailVO();
					objCDetailVO.setStrPNO(objPDetailVO.getStrPNO());
					objCDetailVO.setStrCNm(objPDetailVO.getStrPName());
					objCDetailVO.setICAmt(objPDetailVO.getIPAMT());
					//RC0036
					//objCDetailVO.setIChequeDt(objPDetailVO.getIPDate());
					objCDetailVO.setIChequeDt(objPDetailVO.getICQDate());
					objCDetailVO.setICUseDt(objPDetailVO.getIPCshDt());
					objCDetailVO.setStrPMethod(objPDetailVO.getStrPMethod());//RC0036
					objCDetailVO.setStrUsrDept(objPDetailVO.getStrUsrDept());//RC0036	
					objCDetailVO.setStrUsrArea(objPDetailVO.getStrUsrArea());//RC0036	
					objCDetailVO.setStrCNo(objPDetailVO.getStrPCheckNO());					
					alCheckList.add(objCDetailVO);
			  }	
			}
			//	} 
		} // end of for loop........
		return alCheckList;
	} // end of maintainPList method....
	

	private List getCheckInfo(
		DISBCheckDetailVO objCDetailVO)
		throws ServletException, IOException {
	
		Connection con =
		dbFactory.getAS400Connection("DISBPMaintainServlet.getCheckInfo()");
		Statement stmt = null;
		ResultSet rs = null;
		String strSql = ""; //SQL String

		List alReturnInfo = new ArrayList();
		Hashtable htCheckInfo = new Hashtable();
		String strReturnFlag = "";
		String strReturnMsg = "";
		String strCNo = "";
		//System.out.println(objCDetailVO.getStrCNo().trim());
		if (objCDetailVO.getStrCNo() != null){
		  strCNo = (String)objCDetailVO.getStrCNo().trim();
		} 
		
		
	//  strSql = "select A.CBKNO,A.CACCOUNT,A.CBNO,A.CNO,A.CNM,A.CAMT,A.CHEQUEDT,A.CASHDT,A.CRTNDT,A.CUSEDT,A.CBCKDT,A.CSTATUS,A.PNO,A.CERFLG,A.CHNDFLG,A.ENTRYDT,A.ENTRYTM,A.ENTRYUSR ";
	  strSql = "select A.CBKNO,A.CACCOUNT,A.CBNO,A.CNO,A.CSTATUS,A.PNO,A.CHNDFLG,B.APPROVSTA ";
	  strSql += " from CAPCHKF A,CAPCKNOF B ";
	  strSql += "WHERE CNO ='" + strCNo+ "'  AND A.CBKNO = B.CBKNO AND A.CACCOUNT = B.CACCOUNT AND A.CBNO = B.CBNO AND B.APPROVSTA <> 'E' ";//R90628

		//	System.out.println(
		//		" inside DISBCheckCreateServlet.getCheckInfo()--> strSql ="
		//		+ strSql);
			try {
				stmt = con.createStatement();
			
				rs = stmt.executeQuery(strSql);
				if (rs.next()) {
					//R90628
					if ("N".equals(rs.getString("APPROVSTA"))){
						strReturnFlag = "5";
						strReturnMsg = "支票號碼[" + strCNo +"]，狀態為核准申請中。請完成核准申請作業後，重新執行人工開票作業!\n";
						alReturnInfo.add(0,strReturnFlag);
						alReturnInfo.add(1,strReturnMsg);
					}else{
						if(rs.getString("CHNDFLG").equals("Y"))
					 	{//人工票號
							if(!rs.getString("CSTATUS").trim().equals(""))
							{//票號已被使用
								strReturnFlag = "1";
								strReturnMsg = "支票號碼[" + strCNo +"]已被使用\n";
								alReturnInfo.add(0,strReturnFlag);
								alReturnInfo.add(1,strReturnMsg);						
							}else{//查詢成功
								strReturnFlag = "0";
								strReturnMsg = "";
								objCDetailVO.setStrCBKNo(rs.getString("CBKNO")); //銀行行庫
								objCDetailVO.setStrCAccount(rs.getString("CACCOUNT")); //銀行帳號
								objCDetailVO.setStrCBNo(rs.getString("CBNO")); //票據批號
								objCDetailVO.setStrCStatus(rs.getString("CSTATUS")); //支票狀態
								objCDetailVO.setStrChndFlg(rs.getString("CHNDFLG")); //人工開票否
								alReturnInfo.add(0,strReturnFlag);
								alReturnInfo.add(1,strReturnMsg);
								alReturnInfo.add(2,objCDetailVO);
							}
					 	}else{
							strReturnFlag = "2";
							strReturnMsg = "支票號碼[" + strCNo +"]非人工開票用票\n";
							alReturnInfo.add(0,strReturnFlag);
							alReturnInfo.add(1,strReturnMsg);
						}
					}
				}else{//票號不存在
					strReturnFlag = "3";
					strReturnMsg = "支票號碼[" + strCNo +"]不存在\n";
					alReturnInfo.add(0,strReturnFlag);
					alReturnInfo.add(1,strReturnMsg);
				}
			} catch (SQLException ex) {
				alReturnInfo.add(0,"4");
				alReturnInfo.add(1,ex);
	//			System.out.println("ex="+ex);
	
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
			
		return alReturnInfo;
		}
	/**
	 * @param request
	 * @param response
	 */
	private String updateCheckInfo(List alCheckInfo,List alPDetail,int iUpdDate,Connection con)
		throws ServletException, IOException {
			System.out.println("@@@@@inside updateCheckInfo");
		PreparedStatement pstmtTmp = null;
		String strSql = ""; //SQL String
		String strReturnMsg = "";
		boolean bContinue = true;
		boolean bFlag = true;
		List alReturnInfo = new ArrayList();
	   try
	   {
		if (alCheckInfo != null) {//0
			if (alCheckInfo.size() > 0) {//1
				for (int i = 0; i < alCheckInfo.size(); i++) {//2
					DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo.get(i);
					String	strPNO =(String)objCDetailVO.getStrPNO();
						if (strPNO != null)
							strPNO = strPNO.trim();
						else
							strPNO = "";
							
					String	strCNm =(String)objCDetailVO.getStrCNm();
					if (strCNm != null)
						strCNm = strCNm.trim();
					else
						strCNm = "";	
					String	strCNo =	(String)objCDetailVO.getStrCNo();
					if (strCNo != null)
						strCNo = strCNo.trim();
					else
						strCNo = "";	
					String	strCBKNo =	(String)objCDetailVO.getStrCBKNo();
					if (strCBKNo != null)
						strCBKNo = strCBKNo.trim();
					else
						strCBKNo = "";	
						
					String	strCAccount =	(String)objCDetailVO.getStrCAccount() ;
					if (strCAccount != null)
						strCAccount = strCAccount.trim();
					else
						strCAccount = "";	
						
					String	strCBNo =	(String)objCDetailVO.getStrCBNo();
					if (strCBNo != null)
						strCBNo = strCBNo.trim();
					else
						strCBNo = "";			
					
					double iCAmt = objCDetailVO.getICAmt() ; 
					int iChequeDt = objCDetailVO.getIChequeDt();
					int iCUseDt = objCDetailVO.getICUseDt();
					String UsrDept = (String) objCDetailVO.getStrUsrDept();//RC0036
					String PMethod = (String) objCDetailVO.getStrPMethod();//RC0036
					String UsrArea = (String) objCDetailVO.getStrUsrArea();//RC0036

					
	
						strSql = " update CAPCHKF  set CNM=?,CAMT=CAMT+?,CHEQUEDT=?,CUSEDT=?,PNO=? ,CSTATUS='D' ";
						strSql	+= " where CNO =?  AND CBKNO=? AND CACCOUNT=? AND CBNO=? ";
	
					//	System.out.println(
					//		" inside DISBCheckCreateServlet.updateCheckInfo()--> strSql ="
					//			+ strSql);
						   //RC0036
						    if ( !UsrArea.trim().equals("") && PMethod.trim().equals("E")){
						         strCNm = "全球人壽保險股份有限公司";
					    	}
							pstmtTmp = con.prepareStatement(strSql);
							pstmtTmp.setString(1, strCNm);
							pstmtTmp.setDouble(2, iCAmt+((DISBPaymentDetailVO) alPDetail.get(i)).getIRmtFee());
							pstmtTmp.setInt(3, iChequeDt);
							//pstmtTmp.setInt(4, iUpdDate);
							pstmtTmp.setInt(4, iCUseDt);
							pstmtTmp.setString(5, strPNO);
							pstmtTmp.setString(6, strCNo);
							pstmtTmp.setString(7, strCBKNo);
							pstmtTmp.setString(8, strCAccount);
							pstmtTmp.setString(9, strCBNo);
		
							if (pstmtTmp.executeUpdate() < 1) {//3
								strReturnMsg = "更新票據明細檔失敗";
									return strReturnMsg;
							}//3
						pstmtTmp.close();
					}//2 END OF FOR
			   }//1
			}//0
	   }
	   catch (SQLException ex)
	   {
			strReturnMsg = "更新票據明細檔失敗:ex=" + ex;
	   }	
		return strReturnMsg;
	}
	/**
	 * @param request
	 * @param response
	 */
	private String updatePDetails(List alCheckInfo,List alPDetail, int iUpdDate,int iUpdTime,String strLogonUser,Connection con)
		throws ServletException, IOException {
	System.out.println("@@@@@inside updatePConfirmed");
	PreparedStatement pstmtTmp = null;
	String strReturmMessage = "";
	DISBBean disbBean = new DISBBean(globalEnviron, dbFactory);
	String strSql = ""; //SQL String
	String strReturnMsg = "";
	boolean bContinue = false;
	try {	
		if(alCheckInfo !=null)
		{
			if(alCheckInfo.size()>0)
			{
					
				for(int i=0;i<alCheckInfo.size();i++)
				{
					DISBCheckDetailVO objCDetailVO = (DISBCheckDetailVO) alCheckInfo.get(i);
					DISBPaymentDetailVO paymentVO = (DISBPaymentDetailVO) alPDetail.get(i);
					
					strSql = " update CAPPAYF  set PBBANK = ? , PBACCOUNT = ? , PCHECKNO=? ,PCSHDT=?,PSTATUS='B' ";
					strSql += "  , UPDDT= ? , UPDTM = ?, UPDUSR =?, REMIT_FEE=?  where PNO =?";
	
				//	System.out.println(
				//		" inside DISBCheckCreateServlet.updatePDetails()--> "
				//			+ strSql);
							
							
					//下log
					strReturnMsg =disbBean.insertCAPPAYFLOG(
					objCDetailVO.getStrPNO().trim(),
						strLogonUser,
						iUpdDate,
						iUpdTime,
						con);
					if (strReturnMsg.equals("")) {
						pstmtTmp = con.prepareStatement(strSql);
						pstmtTmp.setString(1, objCDetailVO.getStrCBKNo().trim());
						pstmtTmp.setString(2, objCDetailVO.getStrCAccount().trim());
						pstmtTmp.setString(3, objCDetailVO.getStrCNo().trim());
						//pstmtTmp.setInt(4, iUpdDate);
						pstmtTmp.setInt(4, objCDetailVO.getICUseDt());
						pstmtTmp.setInt(5, iUpdDate);
						pstmtTmp.setInt(6, iUpdTime);
						pstmtTmp.setString(7, strLogonUser);
						pstmtTmp.setInt(8, paymentVO.getIRmtFee());
						pstmtTmp.setString(9, objCDetailVO.getStrPNO().trim());		
						
						if (pstmtTmp.executeUpdate() < 1) {
								strReturnMsg ="更新支付主檔失敗";
								return strReturnMsg;
							} 
						pstmtTmp.close();
					}
					else
					{
						return strReturnMsg;
					}
				}
	
			}
		}
	} catch (SQLException e) {
		strReturnMsg = "更新支付主檔失敗: e=" + e;
	
	} 
	return strReturnMsg;
}
//Clean up resources
public void destroy() {
}

}
	
