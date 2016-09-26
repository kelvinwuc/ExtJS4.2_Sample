/**
程式檔名：FileUploadS.jsp
程式功能：銀行匯款資料 UPLOAD
---------------------------------------------------------
Request  Date         Programer     Description
==========================================================
        2004/10/06   Jerry         修正 Key , 使 unique
R00393  2010/09/20    Leo Huang    現在時間取Capsil營運時間
R00143  2010/09/24    Leo Huang    中國信託轉帳下載格式變更，更正CASH 整批登帳格式
R00231  2010/09/25    Leo Huang    民國百年專案需求
==========================================================
*/

<%@ page contentType="text/html;charset=Big5" %>
<%@ page import="com.aegon.comlib.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.net.ftp.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.aegon.disb.util.DISBBean"%>
<%@ include file="../Logon/Init.inc" %>
<%@ include file="../Logon/CheckLogon.inc" %>



<%!

String strWorkingDir = "C:\\CashUpload\\";
String strTmpDir = "C:\\Temp";
String strThisProgId = "FileUpload";
String logFileName = "fileupload.log";
SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
SimpleDateFormat sdfDate = new SimpleDateFormat("yyyyMMdd",java.util.Locale.TAIWAN) ;
SimpleDateFormat sdfTime = new SimpleDateFormat("hhmmss",java.util.Locale.TAIWAN) ;
RootClass rootClass = new RootClass();
String userId = null;
Date now = null;
public int currentDate = 0 ; 
public int currentTime = 0 ; 

			
NumberFormat form = NumberFormat.getInstance();

String lineSep = System.getProperty("line.separator");

GlobalEnviron globalEnviron = null;
DbFactory dbFactory = null;
DISBBean disbBean = null;//Q80223
//R00393  Edit by Leo Huang (EASONTECH) Start
//Calendar thisCal = Calendar.getInstance();
//R00393  Edit by Leo Huang (EASONTECH) End


// Structure for CAPPRDF/BEL-AIR
class DataClass {

	public String EBKCD = null;
	public String EATNO = null;
	public String EBKRMD = null;
	public String EAEGDT = null;
	public String ENTAMT = null;
	public String ECRSRC = null;
	public String ECRDAY = null;
	public String EUSREM = null;
	public String CSHFAU = null;
	public String CSHFAD = null;
	public String CSHFAT = null;
	public String CSHFUU = null;
	public String CSHFUD = null;
	public String CSHFUT = null;
	public String CSHFCURR = null;//Q60236增加幣別
	

}

private String getFileName(String dir){

	return "";
}

private String save2Db(InputStream in, String fileName){
	int returnCode = -1;
    String msgBank="";
    int fileWrite = 0;
    String result = "";
    
	DataClass thisRow = new DataClass();
	Connection con = dbFactory.getAS400Connection("FileUpload.save2Db") ;
	PreparedStatement pstmt = null;
	String sqlInsert = "insert into CAPCSHF "
		+"(EBKCD,EATNO,EBKRMD,EAEGDT,ENTAMT,ECRSRC,ECRDAY,EUSREM,CSHFAU,CSHFAD,CSHFAT,CSHFUU,CSHFUD,CSHFUT,CSHFCURR)" //Q60236增加幣別 CSHFCURR
		+" values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";	
	
    globalEnviron.writeDebugLog(Constant.DEBUG_DEBUG,strThisProgId+":save2Db()","insert sql='"+sqlInsert+"'");
	//InputStreamReader isd = new InputStreamReader(in);
	int fileLength = 0;
	
	if (fileName.equalsIgnoreCase("CAP1185F1"))
	{//009彰銀
	//R00231 edit by Leo Huang start
         // fileLength = 122;
         fileLength = 130;
    //R00231 edit by Leo Huang end
          msgBank="彰銀";
		result = "彰化銀行";
    }
    
    if (fileName.equalsIgnoreCase("CAP1185F2"))
	{//008華南
	//R00231 edit by Leo Huang start
          //fileLength = 126;
          fileLength = 137;
    //R00231 edit by Leo Huang end
          msgBank="華南";
		result = "華南銀行";
    }
    
     if (fileName.equalsIgnoreCase("CAP1185F3"))
	{//006合庫
          fileLength = 99;
          msgBank="合庫";
		result = "合作金庫";
    }
    
     if (fileName.equalsIgnoreCase("CAP1185F4"))
	{//013世華
	//R00231 edit by Leo Huang start
          //fileLength = 82;   
          fileLength = 202;
          msgBank="世華";
		//result = "世華銀行";
		result = "國泰世華";
        //R00231 edit by Leo Huang start
    }
    
     if (fileName.equalsIgnoreCase("CAP1185F5"))
	{//050台企
	      fileLength = 82;
	      msgBank="台企";
		result = "台灣企銀";
    }
       
    if (fileName.equalsIgnoreCase("CAP1185FA"))
	{//812台新
//	      fileLength = 111;
	      fileLength = 112;
	      msgBank="台新";
		result = "台新銀行";
    }
    if (fileName.equalsIgnoreCase("CAP1185FD"))
	{//812台新
//	      fileLength = 111;
	      fileLength = 112;
	      msgBank="台新";
		result = "台新銀行";
    }    
    if (fileName.equalsIgnoreCase("CAP1185FG"))
	{//812台新
//	      fileLength = 111;
	      fileLength = 112;
	      msgBank="台新";
		result = "台新銀行";
    }

    if (fileName.equalsIgnoreCase("CAP1112F"))
	{//700郵局
	//R00231 edit by Leo Huang start
	      //fileLength = 82;
	  fileLength = 110;
	 //R00231 edit by Leo Huang end
	      msgBank="郵局";
		result = "郵局存匯";
    }

    if (fileName.equalsIgnoreCase("CAP1185FB"))
	{//822中國信託
	      fileLength = 94;
	      msgBank="中信";
		result = "中國信託";
    }
    if (fileName.equalsIgnoreCase("CAP1185FE"))
	{//822中國信託
	      fileLength = 94;
	      msgBank="中信";
		result = "中國信託";
    }
    //R70641 中信新增帳號
    if (fileName.equalsIgnoreCase("CAP1185FI"))
	{//822中國信託
	      fileLength = 94;
	      msgBank="中信";
		result = "中國信託";
    }
    if (fileName.equalsIgnoreCase("CAP1185FC"))
	{//007第一銀行
	      fileLength = 108;
	      msgBank="一銀";
		result = "第一銀行";
    }
    if (fileName.equalsIgnoreCase("CAP1185FF"))
	{//011上海銀行
	//R00231 edit by Leo Huang start
	     // fileLength = 77;
	    fileLength = 79;
	//R00231 edit by Leo Huang end
	      msgBank="上海";
		result = "上海銀行";
    }
    if (fileName.equalsIgnoreCase("CAP1185FH"))
	{//803聯邦銀行
	      fileLength = 74;
	      msgBank="聯邦";
		result = "聯邦銀行";
    }
        
    //byte[] buffer = new byte[fileLength]; 
      byte[] buffer = null;
	try{
		//con.setAutoCommit(false);	
		
		pstmt = con.prepareStatement(sqlInsert) ;
		
		int rowCount = 0;
		int succRowCount = 0;
		int failRowCount = 0;

		BufferedReader reader = new BufferedReader(new InputStreamReader(in)) ;
		String oneRow = null;

		while(true){
			oneRow = reader.readLine() ;
			if(oneRow == null){
				break;
			}
			buffer = oneRow.getBytes() ;
            if(buffer.length<fileLength)
		    {
		       for (int i=0;i<(fileLength-buffer.length);i++)
		       {
		          oneRow += (char)32;
		         
		       }
		        buffer=oneRow.getBytes();
		    }


  /*
 			buffer = null;
			buffer = new byte[fileLength];

			int byteRead = in.read(buffer);
				if(byteRead == -1){
				break;
			}
  */
			rowCount++;
			
			System.out.println("整批登帳-" + msgBank + "上傳第:" + rowCount + "筆");
			
			String s = new String(buffer);
			if (s.trim().length() <= 0) {
				continue;
			}
			
			// parse data
		if (fileName.equalsIgnoreCase("CAP1185F1"))
	     {//009彰銀
	        System.out.println(getStringCAP1185F1(buffer,7));
	        System.out.println(getStringCAP1185F1(buffer,8));
	        
		    thisRow.EBKCD = getStringCAP1185F1(buffer,1) ; 
			thisRow.EATNO = getStringCAP1185F1(buffer,2) ; 
			thisRow.EBKRMD = getStringCAP1185F1(buffer,4) ; 
			thisRow.ENTAMT = getStringCAP1185F1(buffer,6) ; 
		    thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223thisRow.EUSREM = getStringCAP1185F1(buffer,8);
   	  		thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185F1(buffer,8));//Q80223
	       	//thisRow.EUSREM = " ";
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(100000+ rowCount + currentTime);  //為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
	       	thisRow.CSHFCURR ="NT";//Q60236增加幣別
	      
	      
	        if  (!thisRow.EATNO.equalsIgnoreCase("53380109587010"))
	           {
				failRowCount++;
	            System.out.println("整批登帳-彰銀上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }
	          			
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
            pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			succRowCount++;
		}
		
		if (fileName.equalsIgnoreCase("CAP1185F2"))
	     {//008華南
		    thisRow.EBKCD = "008"; 
		    thisRow.EBKRMD = getStringCAP1185F2(buffer,1) ; 
		    //R00231 edit by Leo Huang 
		    int yyyy = Integer.parseInt(thisRow.EBKRMD.substring(0,4)) - 1911;
			String year = Integer.toString(yyyy);
			String mm = (thisRow.EBKRMD.substring(4,6));
			String dd = (thisRow.EBKRMD.substring(6,8));
			thisRow.EBKRMD = year+mm+dd;
		
		    //R00231
			thisRow.EATNO =  getStringCAP1185F2(buffer,3) ; 
			thisRow.ENTAMT = getStringCAP1185F2(buffer,5) ;
			//System.out.println(thisRow.ENTAMT); 
		    thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223thisRow.EUSREM = getStringCAP1185F2(buffer,7) ;
	       	//R00231 edit by Leo Huang start 取存款人前10碼保單號碼
   	  		thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185F2(buffer,7));//Q80223
   	  		//R00231 edit by Leo Huang end
	       	//thisRow.EUSREM = " ";
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(110000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
		    thisRow.CSHFCURR ="NT";//Q60236增加幣別
						
			// FOR DEBUG
	         if  (!thisRow.EATNO.equalsIgnoreCase("100100307256") && !thisRow.EATNO.equalsIgnoreCase("100100307232"))
	           {
				failRowCount++;
	            System.out.println("整批登帳-華南上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
            pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
            
			succRowCount++;
		}
		
		if (fileName.equalsIgnoreCase("CAP1185F3"))
	     {//006合庫	
	   	    thisRow.EBKCD = "006"; 
		    thisRow.EATNO = getStringCAP1185F3(buffer,1) ; 
	       	thisRow.EBKRMD = getStringCAP1185F3(buffer,3) ; 
			thisRow.ENTAMT = getStringCAP1185F3(buffer,5) ; 
	
		    thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223 thisRow.EUSREM = getStringCAP1185F3(buffer,7);
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185F3(buffer,7));//Q80223
	       	//thisRow.EUSREM = " ";
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(120000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
			  if  (!thisRow.EATNO.equalsIgnoreCase("0947717337856") && !thisRow.EATNO.equalsIgnoreCase("0800717271650"))     
	           {
				failRowCount++;
	            System.out.println("整批登帳-合庫上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }	
			
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			
			succRowCount++;
		}
		
		if (fileName.equalsIgnoreCase("CAP1185F4"))
	     {//013世華
	        thisRow.EBKCD = "013"; 
		    thisRow.EATNO = getStringCAP1185F4(buffer,1) ; 
	        thisRow.EBKRMD = getStringCAP1185F4(buffer,2) ;
	        //R00231 edit by Leo Huang 轉民國年
	        int yyyy = Integer.parseInt(thisRow.EBKRMD.substring(0,4)) - 1911;
			String year = Integer.toString(yyyy);
			String mm = (thisRow.EBKRMD.substring(4,6));
			String dd = (thisRow.EBKRMD.substring(6,8));
			thisRow.EBKRMD = year+mm+dd;
			
			//R00231
			thisRow.ENTAMT = getStringCAP1185F4(buffer,4) ; 
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223 thisRow.EUSREM = getStringCAP1185F4(buffer,6) ;
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185F4(buffer,6));//Q80223
	       	//thisRow.EUSREM = " ";
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(130000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
		    thisRow.CSHFCURR ="NT";//Q60236增加幣別
						
			// FOR DEBUG
		  if  (!thisRow.EATNO.equalsIgnoreCase("037035021541"))
	           {
				failRowCount++;
	            System.out.println("整批登帳-世華上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }		
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			succRowCount++;
		}
		
		if (fileName.equalsIgnoreCase("CAP1185F5"))
		{//050台企
		    thisRow.EBKCD = "050"; 
		    thisRow.EATNO = getStringCAP1185F5(buffer,1) ; 
		    thisRow.EBKRMD = getStringCAP1185F5(buffer,2) ; 
		    thisRow.ENTAMT = getStringCAP1185F5(buffer,4) ; 
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223thisRow.EUSREM = getStringCAP1185F5(buffer,6) ;
	       	//thisRow.EUSREM = " ";
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185F5(buffer,6));//Q80223
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(140000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
	       	thisRow.CSHFCURR ="NT";//Q60236增加幣別
	       	
		    if  (!thisRow.EATNO.equalsIgnoreCase("11012045291"))       
	           {
				failRowCount++;
	            System.out.println("整批登帳-台企上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }			
					
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			succRowCount++;
		}
		
		if (fileName.equalsIgnoreCase("CAP1185FA"))
		{//812台新
		    thisRow.EBKCD = "812"; 
		    thisRow.EATNO = "06101120058300"; ; 
		    
		    thisRow.EBKRMD = getStringCAP1185FA(buffer,1) ; 
		    int yyyy = Integer.parseInt(thisRow.EBKRMD.substring(0,4)) - 1911;
		    String year = Integer.toString(yyyy);
		    String mm = (thisRow.EBKRMD.substring(5,7));
		    String dd = (thisRow.EBKRMD.substring(8,10));
		   	thisRow.EBKRMD = year+mm+dd;
		   	//System.out.println(getStringCAP1185FA(buffer,4));
		   	thisRow.ENTAMT = getStringCAP1185FA(buffer,4) ; 
			//thisRow.ENTAMT = getStringCAP1185FA(buffer,3) ; 
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//System.out.println(getStringCAP1185FA(buffer,2));
	       	//Q80223 thisRow.EUSREM = getStringCAP1185FA(buffer,2);
	       	//thisRow.EUSREM = " ";
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FA(buffer,2));//Q80223
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(150000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
            
		    if  (!thisRow.EATNO.equalsIgnoreCase("06101120058300"))       
	           {
				failRowCount++;
	            System.out.println("整批登帳-台新上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }			
	       	
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			succRowCount++;
		}

		if (fileName.equalsIgnoreCase("CAP1185FD"))
		{//812台新
		    thisRow.EBKCD = "812"; 
		    thisRow.EATNO = "06101001190500"; ; 
		    
		    thisRow.EBKRMD = getStringCAP1185FD(buffer,1) ; 
		    int yyyy = Integer.parseInt(thisRow.EBKRMD.substring(0,4)) - 1911;
		    String year = Integer.toString(yyyy);	    
		    String mm = (thisRow.EBKRMD.substring(4,6));
		    String dd = (thisRow.EBKRMD.substring(6,8));
		   	thisRow.EBKRMD = year+mm+dd;
		   	//System.out.println(thisRow.EBKRMD);
		   	
			thisRow.ENTAMT = getStringCAP1185FD(buffer,3) ;
			//System.out.println(thisRow.ENTAMT);
			
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223 String strEUSREM = getStringCAP1185FD(buffer,5) ;
	       	//Q80223 thisRow.EUSREM = strEUSREM.replace(',',';');
	       	//thisRow.EUSREM = getStringCAP1185FD(buffer,5) ;
	       	//thisRow.EUSREM = " ";
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FD(buffer,5));//Q80223
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(160000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
            
		    if  (!thisRow.EATNO.equalsIgnoreCase("06101001190500"))       
	           {
				failRowCount++;
	            System.out.println("整批登帳-台新上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }			
	       	
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			succRowCount++;
		}

		if (fileName.equalsIgnoreCase("CAP1185FG"))
		{//812台新
		    thisRow.EBKCD = "812"; 
		    thisRow.EATNO = "00101071824100"; ; 
		    
		    thisRow.EBKRMD = getStringCAP1185FG(buffer,1) ; 
		    int yyyy = Integer.parseInt(thisRow.EBKRMD.substring(0,4)) - 1911;
		    String year = Integer.toString(yyyy);	    
		    String mm = (thisRow.EBKRMD.substring(4,6));
		    String dd = (thisRow.EBKRMD.substring(6,8));
		   	thisRow.EBKRMD = year+mm+dd;
		   	//System.out.println(thisRow.EBKRMD);
		   	
			thisRow.ENTAMT = getStringCAP1185FG(buffer,3) ;
			//System.out.println(thisRow.ENTAMT);
			
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	        //Q80223String strEUSREM = getStringCAP1185FG(buffer,5) ;
	        //Q80223thisRow.EUSREM = strEUSREM.replace(',',';');
	       	//thisRow.EUSREM = getStringCAP1185FG(buffer,5);
	       	//thisRow.EUSREM = " ";
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FG(buffer,5));//Q80223
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(220000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
            
		    if  (!thisRow.EATNO.equalsIgnoreCase("00101071824100"))       
	           {
				failRowCount++;
	            System.out.println("整批登帳-台新上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }			
	       	
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			succRowCount++;
		}




		
		if (fileName.equalsIgnoreCase("CAP1112F"))
		{//700郵局
		   
	        thisRow.EBKCD = "701"; 
		    thisRow.EATNO = getStringCAP1112F(buffer,1) ; 
		    thisRow.EBKRMD = getStringCAP1112F(buffer,2) ; 
			thisRow.ENTAMT = getStringCAP1112F(buffer,4) ; 
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	thisRow.EUSREM = " ";
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(170000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
		    thisRow.CSHFCURR ="NT";//Q60236增加幣別
						
			// FOR DEBUG
			 if ((!thisRow.EATNO.equalsIgnoreCase("19623652")) &&
			      (!thisRow.EATNO.equalsIgnoreCase("19633961")))   
	             
	           {
				failRowCount++;
	            System.out.println("整批登帳-郵局上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }	
			
			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			
			succRowCount++;
		}
		
		if (fileName.equalsIgnoreCase("CAP1185FB"))
		{//822中國信託
		   
		    thisRow.EBKCD = "822"; 
		    thisRow.EATNO = "635530015707" ; 
		   
		    thisRow.EBKRMD = getStringCAP1185FB(buffer,2) ; 
		    //R00143 Edit by Leo Huang start //年份超過百年存三碼		    
		    String yy = (thisRow.EBKRMD.substring(0,2));
		    int year = Integer.parseInt(yy);
		    if (year<90){
		    	year +=100;
		    	yy = Integer.toString(year);		    	
		    }
		    //R00143 Edit by Leo Huang end
		    String mm = (thisRow.EBKRMD.substring(2,4));
		    String dd = (thisRow.EBKRMD.substring(4,6));
		     
		   	thisRow.EBKRMD = yy+mm+dd;			
            String strENTAMT = getStringCAP1185FB(buffer,4) ; 
            thisRow.ENTAMT = strENTAMT.replace(' ','0') ;

			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223 String strEUSREM = getStringCAP1185FB(buffer,6);
	       	//Q80223 thisRow.EUSREM = strEUSREM.replace(',',';');
	       	//System.out.println(strEUSREM);
	       	//thisRow.EUSREM = getStringCAP1185FB(buffer,5);
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FB(buffer,6));//Q80223
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(180000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
		    if  (!thisRow.EATNO.equalsIgnoreCase("635530015707"))        
	           {
				failRowCount++;
	            System.out.println("整批登帳-中國信託上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }			

			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			succRowCount++;
			
		}		

		if (fileName.equalsIgnoreCase("CAP1185FE"))
		{//822中國信託
		   
		    thisRow.EBKCD = "822"; 
		    thisRow.EATNO = "635530015723" ; 
		    
		    thisRow.EBKRMD = getStringCAP1185FE(buffer,2) ; 
		    
		    
		    //R00143 Edit by Leo Huang start	//年份超過百年存三碼		    
		    String yy = (thisRow.EBKRMD.substring(0,2));
		    int year = Integer.parseInt(yy);
		    if (year<90){
		    	year +=100;
		    	yy = Integer.toString(year);		    	
		    }
		    //R00143 Edit by Leo Huang end
		    String mm = (thisRow.EBKRMD.substring(2,4));
		    String dd = (thisRow.EBKRMD.substring(4,6));
		   	thisRow.EBKRMD = yy+mm+dd;
			
			//thisRow.ENTAMT = getStringCAP1185FB(buffer,4) ;
            String strENTAMT = getStringCAP1185FE(buffer,4) ; 
            thisRow.ENTAMT = strENTAMT.replace(' ','0') ;
			
			
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//R70641 thisRow.EUSREM = " ";
	       	//Q80223String strEUSREM = getStringCAP1185FE(buffer,6);//R70641
	       	//Q80223thisRow.EUSREM = strEUSREM.replace(',',';');//R70641
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FE(buffer,6));//Q80223

	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(190000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
		    if  (!thisRow.EATNO.equalsIgnoreCase("635530015723"))        
	           {
				failRowCount++;
	            System.out.println("整批登帳-中國信託上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }			

			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			
			succRowCount++;
			
		}
		//R70641 中信新增帳號		
		if (fileName.equalsIgnoreCase("CAP1185FI"))
		{//822中國信託
		   
		    thisRow.EBKCD = "822"; 
		    thisRow.EATNO = "071540048108" ; 
		    
		    thisRow.EBKRMD = getStringCAP1185FI(buffer,2) ; 		    
		     //R00143 Edit by Leo Huang start	//年份超過百年存三碼		    
		    String yy = (thisRow.EBKRMD.substring(0,2));
		    int year = Integer.parseInt(yy);
		    if (year<90){
		    	year +=100;
		    	yy = Integer.toString(year);		    	
		    }
		    //R00143 Edit by Leo Huang end
		    String mm = (thisRow.EBKRMD.substring(2,4));
		    String dd = (thisRow.EBKRMD.substring(4,6));
		   	thisRow.EBKRMD = yy+mm+dd;			
            String strENTAMT = getStringCAP1185FI(buffer,4) ; 
            thisRow.ENTAMT = strENTAMT.replace(' ','0') ;

			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223String strEUSREM = getStringCAP1185FI(buffer,6);
	       	//Q80223thisRow.EUSREM = strEUSREM.replace(',',';');
	       	//System.out.println(strEUSREM);
      		thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FI(buffer,6));//Q80223
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(180000+ rowCount+ currentTime);
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";
		    if  (!thisRow.EATNO.equalsIgnoreCase("071540048108"))        
	           {
				failRowCount++;
	            System.out.println("整批登帳-中國信託上傳錯誤:" + thisRow.EATNO);      
				continue;
	           }			

			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);
			
			succRowCount++;			
		}//R70641 END
		
		if (fileName.equalsIgnoreCase("CAP1185FC"))
		{//007第一銀行
		   
		    thisRow.EBKCD = "007"; 
		    thisRow.EATNO = "14110079002" ; 
		    
		    thisRow.EBKRMD = getStringCAP1185FC(buffer,1) ; 
		    //System.out.println("bug1 : "+thisRow.EBKRMD);
		    //String yyyy = (thisRow.EBKRMD.substring(0,3));
		    //String mm = (thisRow.EBKRMD.substring(4,6));
		    //String dd = (thisRow.EBKRMD.substring(7,9));
		   	//thisRow.EBKRMD = yyyy+mm+dd;
			
			thisRow.ENTAMT = getStringCAP1185FC(buffer,3) ;
			
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223thisRow.EUSREM = getStringCAP1185FC(buffer,6) ;
	       	thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FC(buffer,6));//Q80223
	       	//thisRow.EUSREM = " ";
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(200000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
		    if  (!thisRow.EATNO.equalsIgnoreCase("14110079002"))    
	           {
				failRowCount++;
	            System.out.println("整批登帳-第一銀行上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }			

			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			
			succRowCount++;
			
		}				

		if (fileName.equalsIgnoreCase("CAP1185FF"))
		{//011上海銀行
		   
		    thisRow.EBKCD = "011"; 
		    thisRow.EATNO = getStringCAP1185FF(buffer,1) ; 
		    
		    thisRow.EBKRMD = getStringCAP1185FF(buffer,2) ; 
		    //System.out.println("bug1 : "+thisRow.EBKRMD);
		    //String yyyy = (thisRow.EBKRMD.substring(0,3));
		    //String mm = (thisRow.EBKRMD.substring(4,6));
		    //String dd = (thisRow.EBKRMD.substring(7,9));
		   	//thisRow.EBKRMD = yyyy+mm+dd;
			//R00231 edit by Leo Huang 轉民國年
	        int yyyy = Integer.parseInt(thisRow.EBKRMD.substring(0,4)) - 1911;
			String year = Integer.toString(yyyy);
			String mm = (thisRow.EBKRMD.substring(4,6));
			String dd = (thisRow.EBKRMD.substring(6,8));
			thisRow.EBKRMD = year+mm+dd;
			
			//R00231
			thisRow.ENTAMT = getStringCAP1185FF(buffer,5) ;
			
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223thisRow.EUSREM =  getStringCAP1185FF(buffer,8);//身分證號
       		thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FF(buffer,8));//Q80223
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(210000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
		    if  (!thisRow.EATNO.equalsIgnoreCase("20102000021221"))    
	           {
				failRowCount++;
	            System.out.println("整批登帳-上海銀行上傳錯誤:" + thisRow.EATNO);      
//	            return -1;
				continue;
	           }			

			// write to db
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別
			
			
			succRowCount++;
			
		}
		if (fileName.equalsIgnoreCase("CAP1185FH"))
		{//803聯邦銀行
		 //System.out.println("bug1 : "+getStringCAP1185FH(buffer,4));
		 if (getStringCAP1185FH(buffer,5).trim().equals("")){
		    thisRow.EBKCD = "803"; 
		    thisRow.EATNO = "026100007115" ; 
		    //System.out.println("bug1 : "+thisRow.EBKRMD);
		    String yyyy = getStringCAP1185FH(buffer,1);
		    String mm = getStringCAP1185FH(buffer,2);
		    String dd = getStringCAP1185FH(buffer,3);
		   	thisRow.EBKRMD = yyyy+mm+dd;
		    //System.out.println("bug1 : "+thisRow.EBKRMD); 
		    
		    String StrAmt =	getStringCAP1185FH(buffer,6).replace('*',' ').trim();		
		  	String StrAmt1="";
		  	for (int index=0 ; StrAmt.length() > index ; index++){
       	  	   //System.out.println("bug0 : " + index); 	
		  	   //System.out.println("bug1 : " + StrAmt.substring(index,index+1)); 
		  	   if ( !StrAmt.substring(index,index+1).equals(",")){
		  	      StrAmt1 =StrAmt1 + StrAmt.substring(index,index+1);
		  	   }
		  	}
			thisRow.ENTAMT = StrAmt1;
			//System.out.println("bug1 : "+thisRow.ENTAMT); 
			thisRow.EAEGDT = "0";
	       	thisRow.ECRSRC = "2";
	       	thisRow.ECRDAY = "0";
	       	//Q80223thisRow.EUSREM = getStringCAP1185FH(buffer,4);
   	  		thisRow.EUSREM = disbBean.replacePunct(getStringCAP1185FH(buffer,4));//Q80223
	       	//thisRow.EUSREM = " ";
	       	thisRow.CSHFAU = "EntActBatS";
	       	thisRow.CSHFAD = String.valueOf(currentDate);
	       	thisRow.CSHFAT = String.valueOf(220000+ rowCount+ currentTime);//為了使Key unique
	       	thisRow.CSHFUU = " ";
	       	thisRow.CSHFUD = "0";
	       	thisRow.CSHFUT = "0";
            thisRow.CSHFCURR ="NT";//Q60236增加幣別
			// write to db			
			pstmt.setString(1,thisRow.EBKCD);
			pstmt.setString(2,thisRow.EATNO);
			pstmt.setString(3,thisRow.EBKRMD);
			pstmt.setString(4,thisRow.EAEGDT);
			pstmt.setString(5,thisRow.ENTAMT);
			pstmt.setString(6,thisRow.ECRSRC);
			pstmt.setString(7,thisRow.ECRDAY);
			pstmt.setString(8,thisRow.EUSREM);
			pstmt.setString(9,thisRow.CSHFAU);
			pstmt.setString(10,thisRow.CSHFAD);
			pstmt.setString(11,thisRow.CSHFAT);
			pstmt.setString(12,thisRow.CSHFUU);
			pstmt.setString(13,thisRow.CSHFUD);
			pstmt.setString(14,thisRow.CSHFUT);
			pstmt.setString(15,thisRow.CSHFCURR);//Q60236增加幣別			
			
			succRowCount++;
		 }else{	
			thisRow.ENTAMT="0.0";
		 }	
		}	
		if ( !thisRow.ENTAMT.equals("0.0")){		
		    pstmt.executeUpdate() ;	     
		}     
	}
		//con.commit();
		returnCode = rowCount ;
		result = result + " : 成功 " + succRowCount + " 筆, 失敗 " + failRowCount + " 筆";
		//System.out.println("returnCode="+returnCode);
	}catch(IOException ex){
		globalEnviron.writeDebugLog(Constant.DEBUG_ERROR,"FileUpload",ex.getMessage());

	}catch(SQLException ex){
		globalEnviron.writeDebugLog(Constant.DEBUG_ERROR,"FileUpload",ex.getMessage());

	}finally{
		try{
			if(pstmt!=null) {pstmt.close();}
			if(con!=null){
				dbFactory.releaseAS400Connection(con);
			}
		}catch(SQLException ex){
			
		}
	}
	System.out.println("... here is return code..." + returnCode);
//	return returnCode ;
	return result;
}

      
//009彰銀
private String getStringCAP1185F1(byte[] ba, int index){
//R00231 edit by Leo Huang Start
 	//int[] start  = {0,3 ,17,19,25,26,39,74};
	//int[] len =    {3,14,2 ,6 ,1 ,11,35,10} ;
	//[次序,欄位,長度]=>[1,EBKCD,3],[2,EATNO,14],[4,EBKRMD,7],[6,ENTAMT,13]只取11碼，後2碼為小數不取,[8,EUSREM,20]
	int[] start  = {0,3 ,17,19,25,27,39,76}; 
	int[] len =    {3,14,2 ,7 ,1 ,11,35,10} ;
//R00231 edit by Leo Huang end
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){		
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

//008華南
private String getStringCAP1185F2(byte[] ba, int index){
//R00231 edit by Leo Huang Start
  	//int[] start  = {0,6,12,24,42,53,104};
	//int[] len =    {6,6,12,18,11,51,14} ;
	//[次序,欄位,長度]=>[1,EBKRMD,8],[3,EATNO,12],[5,ENTAMT,14]//第1碼正負，最後2碼為小數2位不取,[7,EUSREM,10]//取存款人前10碼保單號碼
	int[] start  = {0,6,14,24,44,53,106};
	int[] len =    {8,6,12,18,11,51,10} ;
//R00231 edit by Leo Huang end
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

//006合庫
private String getStringCAP1185F3(byte[] ba, int index){
	int[] start  = {0,13,14,21,46,56,75};
	int[] len =    {13,1,7,25,10,19,22} ;
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

//013世華
private String getStringCAP1185F4(byte[] ba, int index){
//R00231 edit by Leo Huang Start
	//int[] start  = {0,12,18,39,52,143};//@R90866
	//int[] len =    {12,6,21,13,14,20} ;//@R90866
	//[次序,欄位,長度]=>[1,EATNO,12],[2,EBKRMD,8],[4,ENTAMT,13],[6,EUSREM,20]
	int[] start  = {0,194,18,39,52,143};//@R90866
	int[] len =    {12,8,21,13,14,20} ;//@R90866
//R00231 edit by Leo Huang end
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

//050台企
private String getStringCAP1185F5(byte[] ba, int index){
	int[] start  = {0 ,11,18,22,35,57,73};
	int[] len =    {11,7 ,4 ,11,22,16,15} ;
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

//812台新
private String getStringCAP1185FA(byte[] ba, int index){
	int[] start  = {0 ,10,24,65,80};
	int[] len =    {10,14,41,15,55} ;
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

private String getStringCAP1185FD(byte[] ba, int index){
	int[] start  = {0,10,65,80,95};
	int[] len =    {10,55,15,5,20} ;
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

private String getStringCAP1185FG(byte[] ba, int index){
	int[] start  = {0 ,10,65,80,95};
	int[] len =    {10,55,15,5,20} ;
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

//7002郵局
private String getStringCAP1112F(byte[] ba, int index){
//R00231 edit by Leo Huang start
	//int[] start  = {0,8,14,32,43};
	//int[] len =    {8,6,18,11,38} ;
	//[次序,欄位,長度]=>[1,EATNO,8],[2,EBKRMD,7],[4,ENTAMT,11]
	int[] start  = {0,8,14,33,43};
	int[] len =    {8,7,18,11,38} ;
//R00231 edit by Leo Huang end
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

//822中國信託
private String getStringCAP1185FB(byte[] ba, int index){
//	int[] start  = {0 , 9,45,64,117};
//	int[] len =    {9 ,36,19,53, 20};
//R00143  Edit by Leo Huang Start
	//int[] start  = {0 ,12,18,35,45,60};
	//int[] len =    {12,6 ,17,10,15,30};
	//byte[] temp = new byte[len[index-1]];
	//for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){ 
	//	temp[j++] = ba[i++] ;
	//  if (ba.length <= i){
	 //    break;
	 // }  
		
	//}
	int[] start  = {0 ,12,18,35,76,76};
	int[] len =    {12,6 ,17,10,11,17};
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){ 
		temp[j++] = ba[i++] ;
	  if (ba.length <= i){
	     break;
	  }  
		
	}
	
//R00143  Edit by Leo Huang End
	String returnStr = new String(temp);
	return (returnStr) ;
}

//822中國信託
private String getStringCAP1185FE(byte[] ba, int index){
//R70641 int[] start  = {0 ,12,18,35,45,64,117};
//R70641	int[] len =    {12,6 ,17,10,19,53,20};
//R00143  Edit by Leo Huang Start
	//int[] start  = {0 ,12,18,35,45,60};
	//int[] len =    {12,6 ,17,10,15,30};
	//byte[] temp = new byte[len[index-1]];
	//for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){ 
	//	temp[j++] = ba[i++] ;
	//  if (ba.length <= i){
	 //    break;
	 // }  
		
	//}
	int[] start  = {0 ,12,18,35,76,76};
	int[] len =    {12,6 ,17,10,11,17};
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){ 
		temp[j++] = ba[i++] ;
	  if (ba.length <= i){
	     break;
	  }  
		
	}
	
//R00143  Edit by Leo Huang End
	String returnStr = new String(temp);
	return (returnStr) ;
}
//R70641 822中國信託新增帳號
private String getStringCAP1185FI(byte[] ba, int index){
	//R00143  Edit by Leo Huang Start
	//int[] start  = {0 ,12,18,35,45,60};
	//int[] len =    {12,6 ,17,10,15,30};
	//byte[] temp = new byte[len[index-1]];
	//for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){ 
	//	temp[j++] = ba[i++] ;
	//  if (ba.length <= i){
	 //    break;
	 // }  
		
	//}
	int[] start  = {0 ,12,18,35,76,76};
	int[] len =    {12,6 ,17,10,11,17};
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){ 
		temp[j++] = ba[i++] ;
	  if (ba.length <= i){
	     break;
	  }  
		
	}
	
//R00143  Edit by Leo Huang End
	String returnStr = new String(temp);
	return (returnStr) ;
}//R70641 END
//007第一銀行
private String getStringCAP1185FC(byte[] ba, int index){
	int[] start  = {0 ,7,52,49,68,86};
	int[] len =    {7,45,16,19,18,20};
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}
//011上海銀行
private String getStringCAP1185FF(byte[] ba, int index){
//R00231 edit by Leo Huang start
	//int[] start  = {0 ,14,20,28,29,40,42,45,55,61,72,74};//R60761修改上傳格式//R60761修改上傳格式
	//int[] len =    {14,6,8,1,11,2,3,10,6,11,2,3};//R60761修改上傳格式
	//[次序,欄位,長度]=>[1,EATNO,14],[2,EBKRMD,8],[5,ENTAMT,13]小數2位只取11碼,[8,EUSREM,16]
	int[] start  = {0 ,14,20,28,31,40,42,47,55,61,72,74};
	int[] len =    {14,8 ,8 ,1 ,11,2 ,3 ,16,6 ,11,2 ,3};
//R00231 edit by Leo Huang end
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}
//011聯邦銀行
private String getStringCAP1185FH(byte[] ba, int index){
	int[] start  = {1,4,7,10,19,37,55};
	int[] len =    {2,2,2, 9,17,14,18};
	byte[] temp = new byte[len[index-1]];
	for(int i = start[index-1], j=0, k=len[index-1]; j < k ;){
		temp[j++] = ba[i++] ;
	}
	String returnStr = new String(temp);
	return (returnStr) ;
}

private synchronized void writeJobLog(String message, String fileName, int rows){
	/*
	Connection con = dbFactory.getConnection("FileUpload.writeJobLog");
	PreparedStatement pstmt = null;
	String sqlInsert = 
		"insert into tUploadFileLog (CompanyNo, UploadTime, FileName, LineCount, Message) values (?,?,?,?,?)";
	try{
		pstmt = con.prepareStatement(sqlInsert);
		pstmt.setString(1,"TIGER");
		//R00393  Edit by Leo Huang (EASONTECH) Start
		//pstmt.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));
		pstmt.setTimestamp(2, new java.sql.Timestamp(new CommonUtil(dbFactory.getGlobalEnviron()).getBizDateByRDate().getTime()));
		//R00393Edit by Leo Huang (EASONTECH) End
		pstmt.setString(3,fileName);
		pstmt.setInt(4,rows);
		pstmt.setString(5,message);
		
		pstmt.executeUpdate();
	}catch(SQLException ex){
		System.err.println("Error : FileUploadS.writeJobLog ->"+ex.getMessage());
		globalEnviron.writeDebugLog(Constant.DEBUG_ERROR,"FileUploadS.writeJobLog->"+ex.getMessage());
	}finally{
		try{
			if(pstmt!=null){
				pstmt.close();
			}
			if(con!=null){
				dbFactory.releaseConnection(con);
			}
		}catch(SQLException ex1){
			System.err.println("Error: FileUploadS.writeJobLog ->"+ex1.getMessage());
			globalEnviron.writeDebugLog(Constant.DEBUG_ERROR,"FileUploadS.writeJobLog->"+ex1.getMessage());			
		}
	}
	*/
}
%>
<%
//R00393  Edit by Leo Huang (EASONTECH) Start
        //now = new java.util.Date(System.currentTimeMillis());
        if(dbFactory == null){
        	dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
        }
        now = new CommonUtil(dbFactory.getGlobalEnviron()).getBizDateByRDate();
        //R00393  Edit by Leo Huang (EASONTECH)End
        
        currentDate = Integer.parseInt(sdfDate.format(now),10) - 19110000 ;
        
        currentTime = Integer.parseInt(sdfTime.format(now),10) ;
        
        if(globalEnviron == null){
        	globalEnviron = (GlobalEnviron)application.getAttribute(Constant.GLOBAL_ENVIRON);
        }
       //R00393  Edit by Leo Huang (EASONTECH) Start
       // if(dbFactory == null){
        //	dbFactory = (DbFactory) application.getAttribute(Constant.DB_FACTORY);
        //}
        //R00393  Edit by Leo Huang (EASONTECH) End
		disbBean = new DISBBean(globalEnviron, dbFactory);//Q80223
        //
        form.setParseIntegerOnly(true);
        form.setMinimumIntegerDigits(2);
		form.setMaximumIntegerDigits(2);
		
	
		// check tmp directory
		File tmpDir = new File(strTmpDir);
		if(!tmpDir.isDirectory()){
			tmpDir.mkdir();
		}
        
        String outputMessage = "";
        DiskFileUpload fu = new DiskFileUpload();
        // maximum size before a FileUploadException will be thrown
        fu.setSizeMax(50000000);
        // maximum size that will be stored in memory
        fu.setSizeThreshold(4096);
        // the location for saving data that is larger than getSizeThreshold()
        fu.setRepositoryPath(strTmpDir);
        try {
            int allRowCount=0;
            List fileItems = fu.parseRequest(request);
            // assume we know there are two files. The first file is a small
            // text file, the second is unknown and is written to a file on
            // the server
            String oriFileName = "";
            String fieldName = "";
            Iterator i = fileItems.iterator();
            while (i.hasNext()) {
                //String comment = ((FileItem) i.next()).getString();


                FileItem fi = (FileItem) i.next();
                if(!fi.isFormField()){
                                
	                fieldName = fi.getFieldName();
	                System.out.println("檔案上傳作完:" + fieldName);
	                oriFileName = fi.getName();
	                InputStream is = fi.getInputStream();
	                int rowCount = 0;
	                String result = save2Db(is,fieldName);
	                allRowCount  = allRowCount + rowCount;
	            //   	outputMessage = "檔案上傳完成  共"+ allRowCount + "筆";
    	            //outputMessage = "檔案上傳完成";
					outputMessage = outputMessage + result + "\n";
	               }
               // writeJobLog(outputMessage,oriFileName, rowCount);
            }
            outputMessage = "< 整批登帳處理結果 >" + "\n\n" + outputMessage;
//            outputMessage = outputMessage + "檔案上傳完成!";
        } catch (Exception ex) {
            System.out.println("Error: " + ex.getMessage());
            outputMessage = ex.getMessage();
        }
        
        //RequestDispatcher dispatch = request.getRequestDispatcher("/FileUpload/ShowMessage.jsp?txtMsg="+outputMessage);
        System.out.println("outputMessage='"+outputMessage+"'");
        RequestDispatcher dispatch = request.getRequestDispatcher("/EntActBat/EntActBatC.jsp?txtMsg="+outputMessage);
        dispatch.forward(request, response);
        return ;
%>