package com.aegon.entactbat;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;

import com.aegon.bankinfo.CapbnkfVO;
import com.aegon.comlib.CommonUtil;
import com.aegon.comlib.InitDBServlet;
import org.apache.log4j.Logger;

/**
 * System   : CashWeb
 * 
 * Function : 整批登帳處理
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.6 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date :
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntActBatServlet.java,v $
 * Revision 1.6  2014/01/14 06:00:29  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---增加LOG
 *
 * Revision 1.5  2014/01/13 03:52:30  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 * BugFix---增加LOG
 *
 * Revision 1.4  2014/01/03 02:49:52  MISSALLY
 * R00135---PA0024---CASH年度專案-02
 *
 *  
 */

public class EntActBatServlet extends InitDBServlet {
	
	private Logger log = Logger.getLogger(getClass());

	private static final long serialVersionUID = 2424017625773179173L;

	private String strTmpDir = "D:\\Uploads";
	private Connection con = null;

	private String FilePath = null;
	private String File = "\\WEB-INF\\ConfigFiles\\BankTemplateConfig.txt";
	private String FileError = "\\WEB-INF\\ConfigFiles\\BankTemplateError.txt";
	private StringBuffer ErrorMessage = new StringBuffer();
	private StringBuffer PageMessage = new StringBuffer();

	private String strSuccessMsg = "";
	private int iUpdateDate = 0;
	private int iCounter = 0;
	private int iSeq = 1;
	
	public void init() throws ServletException {
		super.init();
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
	{
		iUpdateDate = Integer.parseInt(commonUtil.convertWesten2ROCDate1(commonUtil.getBizDateByRDate()));
		
		FilePath = getServletContext().getRealPath("/");

		NumberFormat form = NumberFormat.getInstance();
		form.setParseIntegerOnly(true);
		form.setMinimumIntegerDigits(2);
		form.setMaximumIntegerDigits(2);

		File tmpDir = new File(strTmpDir);
		if (!tmpDir.isDirectory()) {
			tmpDir.mkdir();
		}

		DiskFileUpload fu = new DiskFileUpload();

		fu.setSizeMax(50000000);
		fu.setSizeThreshold(4096);
		fu.setRepositoryPath(strTmpDir);

		try {
			con = dbFactory.getAS400Connection("EntActBatServlet");

			List<FileItem> fileItems = fu.parseRequest(req);

			String oriFileName = "";
			Iterator<FileItem> i = fileItems.iterator();
			strSuccessMsg = "";

			while (i.hasNext()) {

				FileItem fi = (FileItem) i.next();
				if (!fi.isFormField()) {
					oriFileName = fi.getName();

					InputStream is = fi.getInputStream();
					if (!"".equals(oriFileName)) {
						log.info("processUploadFile執行");
						this.processUploadFile(oriFileName, is, iSeq);
						iSeq++;
					}
				}
			}

			this.writeErrorMessageToErrorFile();
			if (ErrorMessage.length() > 0) {
				ErrorMessage.delete(0, ErrorMessage.length());
				String pageError = PageMessage.toString();
				PageMessage.delete(0, PageMessage.length());
				req.setAttribute("txtError", pageError);
				req.setAttribute("error", "Y");
			} else {
				req.setAttribute("txtError", "登帳成功!!\r\n" + strSuccessMsg);
			}
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
			req.setAttribute("txtError", "讀取設定銀行格式文件出現異常錯誤!!");
		} catch (SQLException ex) {
			System.err.println("Error: " + ex.getMessage());
			req.setAttribute("txtError", "連結資料庫出現異常錯誤!!");
		} catch (FileUploadException ex) {
			System.err.println("Error: " + ex.getMessage());
			req.setAttribute("txtError", "上傳文件出現異常錯誤!!");
		} catch (Exception ex) {
			System.err.println("Error: " + ex.getMessage());
			req.setAttribute("txtError", "異常錯誤!!");
		} finally {
			if(con != null) dbFactory.releaseAS400Connection(con);
		}
		req.getRequestDispatcher("/EntActBat/EntActBatC.jsp").forward(req, resp);
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		FilePath = getServletContext().getRealPath("/");
		ServletOutputStream os = resp.getOutputStream();
		resp.setContentType("text/plain");
		resp.setHeader("Content-Disposition", "attachment; filename=Error.txt");

		String errorMessage = this.readerErrorFile();
		ByteArrayInputStream is = new ByteArrayInputStream(errorMessage.getBytes());
		int reader = 0;
		byte[] buffer = new byte[1 * 1024];
		try {
			while ((reader = is.read(buffer)) > 0) {
				os.write(buffer, 0, reader);
			}
		} catch (IOException e) {
			throw e;
		} finally {
			os.flush();
			os.close();
		}
	}

	// 處理上傳流文件，得到內容，入登帳檔
	private void processUploadFile(String fileName, InputStream in, int iSeq) throws IOException, SQLException {
		HashMap<String, BankTemplateDTO> map = this.getAllBankTempalte();
		List<CapcshfDTO> list = this.readOneFileChangeCapcshfDTO(in, map, fileName);
		if (list.size() > 0) {
			iCounter = 0;
			log.info("processUploadFile執行");
			for (int i = 0; i < list.size(); i++) {
				log.info("processUploadFile執行" + i);
				try {
					this.saveCapbnkf(list.get(i), iSeq);
					iSeq++;
					iCounter++;
				} catch (SQLException e) {
					PageMessage.append(fileName + " :轉檔失敗" + "&nbsp;");
					System.err.println("轉檔失敗: " + fileName + " 序號=" + iSeq);
					throw e;
				}
			}
			strSuccessMsg += getFileName(fileName) + " :成功上傳 " + iCounter + " 筆;\r\n";
		}
	}

	// 處理上傳文件，轉換數據到對象，並做數據檢驗
	private List<CapcshfDTO> readOneFileChangeCapcshfDTO(InputStream in, HashMap<String, BankTemplateDTO> map, String fileName) throws SQLException, IOException {
		log.info("readOneFileChangeCapcshfDTO執行");
		BufferedReader reader = new BufferedReader(new InputStreamReader(in));
		List<CapcshfDTO> list = new ArrayList<CapcshfDTO>();
		boolean juage = true;
		String oneRow = null;
		int index = 0;
		if (fileName.indexOf('.') < 0) {
			this.createErrorMessage(fileName, "", "上傳文件名有錯");
		} else {
			String bkalat = getFileName(fileName);
			log.info("bkalat是" + bkalat);
			if (bkalat.toUpperCase().equals("BANK")) {
				while (true) {
					oneRow = reader.readLine();
					log.info("oneRow是" + oneRow);
					if (oneRow == null) {
						break;
					}
					if (CommonUtil.AllTrim(oneRow).equals("")) {
						break;
					}
					byte[] input = oneRow.getBytes();
					index++;
					CapcshfDTO cfDTO = createCapcshfDTOForGeneral(new String(input, "BIG5"));
					list.add(cfDTO);
					if (!checkCapcshfDTOForGeneral(cfDTO,String.valueOf(index), fileName)) {
						juage = false;
					}
				}
				if (index == 0) {
					this.createErrorMessage(fileName, "", "文件為空，沒有內容");
				}
				// 當有一條數據錯誤，清空LIST，不保留任何數據
				if (!juage) {
					list.clear();
				}
			} else {
				CapbnkfVO cDTO = this.getBKALATForDTO(bkalat);
				// 檢查金融簡碼
				if (null == cDTO) {
					this.createErrorMessage(fileName, "", "查無金融簡碼設定");
				} else {
					// 檢驗銀行代碼停用
					if ("N".equals(cDTO.getBankStatus())) {
						this.createErrorMessage(fileName, "", "金融單位狀態為停用");
					} else if("N".equals(cDTO.getBankSpec())) {
						this.createErrorMessage(fileName, "", "整批登帳格式設定為非銀行格式，請用通用格式上傳");
					} else {
						// 檢查有無格式
						BankTemplateDTO btDTO = map.get(bkalat);
						if (null == btDTO) {
							this.createErrorMessage(fileName, "", "上傳登帳文件沒有對應的銀行登帳格式處理，請先定義銀行格式");
						} else {
							log.info(bkalat + ",btDTO.getBankCode():" + btDTO.getBankCode());
							log.info(bkalat + ",btDTO.getFileType():" + btDTO.getFileType());
							log.info(bkalat + ",btDTO.getSplitFileType():" + btDTO.getSplitFileType());
							log.info(bkalat + ",btDTO.getSplitNum():" + btDTO.getSplitNum());
							log.info(bkalat + ",btDTO.getDateStart():" + btDTO.getDateStart());
							log.info(bkalat + ",btDTO.getDateEnd():" + btDTO.getDateEnd());
							log.info(bkalat + ",btDTO.getDateIndex():" + btDTO.getDateIndex());
							log.info(bkalat + ",btDTO.getDateTpye():" + btDTO.getDateTpye());
							log.info(bkalat + ",btDTO.getIsSlant():" + btDTO.getIsSlant());
							log.info(bkalat + ",btDTO.getFeeStart():" + btDTO.getFeeStart());
							log.info(bkalat + ",btDTO.getFeeEnd():" + btDTO.getFeeEnd());
							log.info(bkalat + ",btDTO.getFeeIndex():" + btDTO.getFeeIndex());
							log.info(bkalat + ",btDTO.getIsLeftZero():" + btDTO.getIsLeftZero());
							log.info(bkalat + ",btDTO.getIsLeftSpace():" + btDTO.getIsLeftSpace());
							log.info(bkalat + ",btDTO.getIsFristNum():" + btDTO.getIsFristNum());
							log.info(bkalat + ",btDTO.getIslastNum():" + btDTO.getIslastNum());
							log.info(bkalat + ",btDTO.getIsPoint():" + btDTO.getIsPoint());
							log.info(bkalat + ",btDTO.getIsTwoNum():" + btDTO.getIsTwoNum());
							log.info(bkalat + ",btDTO.getIsPermille():" + btDTO.getIsPermille());
							log.info(bkalat + ",btDTO.getConStart():" + btDTO.getConStart());
							log.info(bkalat + ",btDTO.getConEnd():" + btDTO.getConEnd());
							log.info(bkalat + ",btDTO.getConIndex():" + btDTO.getConIndex());
							
							while (true) {
								oneRow = reader.readLine();
								log.info("oneRow是" + oneRow);
								if (oneRow == null) {
									break;
								}
								if (CommonUtil.AllTrim(oneRow).equals("")) {
									break;
								}
								index++;
								CapcshfDTO cfDTO = createCapcshfDTO(btDTO, oneRow, cDTO);
								list.add(cfDTO);
								if (!checkCapcshfDTO(cfDTO, String.valueOf(index), fileName)) {
									juage = false;
								}
							}
							if (index == 0) {
								this.createErrorMessage(fileName, "", "文件為空，沒有內容");
							}
							// 當有一條數據錯誤，清空LIST，不保留任何數據
							if (!juage) {
								list.clear();
							}
						}
					}
				}
			}
		}
		return list;
	}

	// 處理通用格式文件
	private CapcshfDTO createCapcshfDTOForGeneral(String oneRow) throws SQLException {
		//System.out.println("oneRow是" + oneRow);
		CapcshfDTO dto = new CapcshfDTO();
		String[] arr = oneRow.split(",");
		/*System.out.println("arr[0]" + arr[0]);
		System.out.println("arr[1]" + arr[1]);
		System.out.println("arr[2]" + arr[2]);
		System.out.println("arr[3]" + arr[3]);*/
		CapbnkfVO cDTO = this.getBKALATForDTO(arr[0]);
		if (cDTO == null) {
			dto.setEBKCD("0");
		} else if ("N".equals(cDTO.getBankStatus())) {
			dto.setEBKCD("1");
		} else {
			dto.setEBKCD(cDTO.getBankCode());
		}
		dto.setEATNO(cDTO.getBankAccount());
		dto.setCSHFCURR(cDTO.getBankCurr());
		dto.setCSHFAD(iUpdateDate);
		try {
			dto.setEBKRMD(Integer.parseInt(arr[1]));
		} catch (Exception e) {
			dto.setEBKRMD(0);
		}
		try {
			double amount = Double.parseDouble(arr[2]);
			dto.setENTAMT(amount);
		} catch (Exception e) {
			dto.setENTAMT(0);
		}
		try {
			dto.setEUSREM(CommonUtil.AllTrim(arr[3]).toUpperCase());
		} catch (Exception e) {
			dto.setEUSREM("");
		}
		return dto;
	}

	// 處理特殊格式文件
	private CapcshfDTO createCapcshfDTO(BankTemplateDTO btDTO, String oneRow, CapbnkfVO cDTO) {
		CapcshfDTO dto = new CapcshfDTO();
		dto.setEBKCD(cDTO.getBankCode());
		dto.setEATNO(cDTO.getBankAccount());
		dto.setCSHFCURR(cDTO.getBankCurr());
		dto.setCSHFAD(iUpdateDate);
		try {
			dto.setEBKRMD(this.getBankDate(btDTO, oneRow));
		} catch (Exception e) {
			dto.setEBKRMD(0);
		}
		try {
			dto.setENTAMT(this.getTransferAmount(btDTO, oneRow));
		} catch (Exception e) {
			dto.setENTAMT(0);
		}
		try {
			dto.setEUSREM(CommonUtil.AllTrim(this.getRemark(btDTO, oneRow.toUpperCase())).toUpperCase());
		} catch (Exception e) {
			dto.setEUSREM("");
		}

		return dto;
	}

	// 檢驗通用格式文件
	private boolean checkCapcshfDTOForGeneral(CapcshfDTO cfDTO, String index, String fileName) {
		boolean res = true;
		if (cfDTO.getEBKCD().equals("0")) {
			res = false;
			this.createErrorMessage(fileName, index, "查無金融簡碼設定");
		} else if (cfDTO.getEBKCD().equals("1")) {
			res = false;
			this.createErrorMessage(fileName, index, "金融單位狀態為停用");
		}
		if (cfDTO.getEBKRMD() <= 0) {
			res = false;
			this.createErrorMessage(fileName, index, "交易日期格式有誤");
		}
		if (cfDTO.getENTAMT() <= 0) {
			res = false;
			this.createErrorMessage(fileName, index, "交易金額非數字格式或小於等於０");
		}
		return res;
	}

	// 檢驗特殊格式文件
	private boolean checkCapcshfDTO(CapcshfDTO cfDTO, String index, String fileName) {
		boolean res = true;
		if (cfDTO.getEBKRMD() <= 0) {
			res = false;
			this.createErrorMessage(fileName, index, "交易日期格式有誤");
		}
		if (cfDTO.getENTAMT() <= 0) {
			res = false;
			this.createErrorMessage(fileName, index, "交易金額非數字格式或小於等於０");
		}
		return res;
	}

	// 構建所有錯誤記錄
	private void createErrorMessage(String fileName, String count, String message) {
		if ("".equals(count)) {
			ErrorMessage = ErrorMessage.append(fileName + " :" + message + System.getProperty("line.separator"));
			PageMessage = PageMessage.append(fileName + " :上傳錯誤," + message + "\r\n");
		} else {
			ErrorMessage = ErrorMessage.append(fileName + "第" + count + "筆: " + message + System.getProperty("line.separator"));
			PageMessage = PageMessage.append(fileName + " :上傳錯誤," + message + "\r\n");
		}

	}

	// 所有錯誤信息寫入錯誤下載文檔
	private void writeErrorMessageToErrorFile() throws IOException {
		FileWriter fw = new FileWriter(FilePath + FileError);
		fw.write(ErrorMessage.toString());
		fw.flush();
		fw.close();
	}

	private String readerErrorFile() throws IOException {
		StringBuffer su = new StringBuffer();

		BufferedReader br = new BufferedReader(new FileReader(new File(FilePath + FileError)));
		String templine = "";
		while ((templine = br.readLine()) != null) {
			su.append(templine + System.getProperty("line.separator"));
		}
		return su.toString();
	}

	// 取得所有銀行格式放入Map
	private HashMap<String, BankTemplateDTO> getAllBankTempalte() throws IOException {
		HashMap<String, BankTemplateDTO> hm = new HashMap<String, BankTemplateDTO>();
		BufferedReader br = new BufferedReader(new FileReader(new File(FilePath + File)));
		String templine = "";
		while ((templine = br.readLine()) != null) {
			String[] arr = templine.split("\\|", 22);
			BankTemplateDTO dto = this.arrayChangeBankTemplateDTO(arr);
			hm.put(dto.getBankCode(), dto);
		}
		return hm;
	}

	// 銀行格式數組轉化銀行格式對象
	private BankTemplateDTO arrayChangeBankTemplateDTO(String[] arr) {
		/*for(int i=0; i<arr.length; i++){
			System.out.println("arr[" + i + "]是" + arr[i]);
		}*/
		
		BankTemplateDTO dto = new BankTemplateDTO();
		dto.setBankCode(arr[0]);
		dto.setFileType(arr[1]);
		dto.setSplitFileType(arr[2]);
		dto.setSplitNum(arr[3]);
		dto.setDateStart(arr[4]);
		dto.setDateEnd(arr[5]);
		dto.setDateIndex(arr[6]);
		dto.setDateTpye(arr[7]);
		dto.setIsSlant(arr[8]);
		dto.setFeeStart(arr[9]);
		dto.setFeeEnd(arr[10]);
		dto.setFeeIndex(arr[11]);
		dto.setIsLeftZero(arr[12]);
		dto.setIsLeftSpace(arr[13]);
		dto.setIsFristNum(arr[14]);
		dto.setIslastNum(arr[15]);
		dto.setIsPoint(arr[16]);
		dto.setIsTwoNum(arr[17]);
		dto.setIsPermille(arr[18]);
		dto.setConStart(arr[19]);
		dto.setConEnd(arr[20]);
		dto.setConIndex(arr[21]);
		return dto;
	}

	// 使用金融簡碼帶出相關銀行代碼帳號檔
	private CapbnkfVO getBKALATForDTO(String bkALAT) throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;
		CapbnkfVO dto = null;
		String sql = "select BKCODE,BKATNO,BKALAT,BKSTAT,BKCURR,BKSPEC from CAPBNKF where BKALAT = '" + bkALAT + "'";
		System.out.println(sql);

		stmt = con.createStatement();
		rs = stmt.executeQuery(sql);
		if (rs.next()) {
			dto = new CapbnkfVO();
			dto.setBankCode(rs.getString("BKCODE"));
			dto.setBankAccount(rs.getString("BKATNO"));
			dto.setBankAlat(rs.getString("BKALAT"));
			dto.setBankStatus(rs.getString("BKSTAT"));
			dto.setBankCurr(rs.getString("BKCURR"));
			dto.setBankSpec(CommonUtil.AllTrim(rs.getString("BKSPEC")));
		}
		
		rs.close();
		stmt.close();
		return dto;
	}

	// 保存銀行文檔數據到登帳核銷檔
	private void saveCapbnkf(CapcshfDTO dto, int i) throws SQLException {

		String strTime = String.valueOf(commonUtil.getBizDateByRCalendar().getTimeInMillis());
		strTime = strTime.substring(7);
		int iTime = 100000+ i + Integer.parseInt(strTime);
		if(iTime > 999999) {
			iTime = iTime - 100000;
		}
		System.out.println("CSHFAT=" + iTime);
		
		PreparedStatement pstmt = null;
		String sql = "insert into CAPCSHF "
				+ "(EBKCD,EATNO,EBKRMD,EAEGDT,ENTAMT,ECRSRC,ECRDAY,EUSREM,CSHFAU,CSHFAD,CSHFAT,CSHFCURR)" 
				+ " values (?,?,?,?,?,?,?,?,?,?,?,?) ";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, dto.getEBKCD());
		pstmt.setString(2, dto.getEATNO());
		pstmt.setInt(3, dto.getEBKRMD());
		pstmt.setInt(4, dto.getEAEGDT());
		pstmt.setDouble(5, dto.getENTAMT());
		pstmt.setString(6, dto.getECRSRC());
		pstmt.setString(7, dto.getECRDAY());
		pstmt.setString(8, dto.getEUSREM());
		pstmt.setString(9, dto.getCSHFAU());
		pstmt.setInt(10, dto.getCSHFAD());
		pstmt.setInt(11, iTime);	////為了使Key unique
		pstmt.setString(12, dto.getCSHFCURR());
		//pstmt.executeUpdate();
		//測試
		System.out.println("EBKCD是" + dto.getEBKCD());
		System.out.println("EATNO是" + dto.getEATNO());
		System.out.println("EBKRMD是" + dto.getEBKRMD());
		System.out.println("EAEGDT是" + dto.getEAEGDT());
		System.out.println("ENTAMT是" + dto.getENTAMT());
		System.out.println("ECRSRC是" + dto.getECRSRC());
		System.out.println("ECRDAY是" + dto.getECRDAY());
		System.out.println("EUSREM是" + dto.getEUSREM());
		System.out.println("CSHFAU是" + dto.getCSHFAU());
		System.out.println("CSHFAD是" + dto.getCSHFAD());
		System.out.println("CSHFAT是" + iTime);
		System.out.println("CSHFCURR是" + dto.getCSHFCURR());

		if(pstmt != null) pstmt.close();
	}

	// 得到交易日期
	private int getBankDate(BankTemplateDTO btDTO, String oneRow) throws Exception {
		String sDate = "";
		String[] arr = null;
		int date = 0;
		byte[] tmp = null;
		if ("".equals(btDTO.getDateIndex())) {
			int start = Integer.parseInt(btDTO.getDateStart()) - 1;
			int end = Integer.parseInt(btDTO.getDateEnd());
			tmp = new byte[end-start];
			System.arraycopy( oneRow.getBytes(), start, tmp, 0, (end-start) );
			sDate = CommonUtil.AllTrim(new String(tmp));
			sDate = sDate.split(" ")[0].trim();
		} else {
			if ("s".equals(btDTO.getSplitFileType())) {
				arr = oneRow.split(";");
				sDate = arr[Integer.parseInt(btDTO.getDateIndex()) - 1];
				sDate = sDate.split(" ")[0].trim();
			} else {
				arr = oneRow.split(",");
				sDate = arr[Integer.parseInt(btDTO.getDateIndex()) - 1];
				sDate = sDate.split(" ")[0].trim();
			}
		}

		if ("Y".equals(btDTO.getIsSlant())) {
			sDate = sDate.replace("/", "");
		}
		// 判斷西元或者民國
		if ("X".equals(btDTO.getDateTpye())) {	//西元
			date = Integer.parseInt(sDate) - 19110000;
		} else if("B".equals(btDTO.getDateTpye())) {	//民國年後兩碼
			date = Integer.parseInt("1"+sDate);
		} else {
			date = Integer.parseInt(sDate);
		}
		return date;
	}

	// 得到交易金額
	private double getTransferAmount(BankTemplateDTO btDTO, String oneRow) throws Exception {
		double amount = 0;
		String sAmount = "";
		String[] arr = null;
		byte[] tmp = null;
		if ("".equals(btDTO.getFeeIndex())) {
			int start = Integer.parseInt(btDTO.getFeeStart()) - 1;
			int end = Integer.parseInt(btDTO.getFeeEnd());
			tmp = new byte[end-start];
			System.arraycopy( oneRow.getBytes(), start, tmp, 0, (end-start) );
			sAmount = new String(tmp);
		} else {
			if ("s".equals(btDTO.getSplitFileType())) {
				arr = oneRow.split(";");
				sAmount = arr[Integer.parseInt(btDTO.getFeeIndex()) - 1];
				sAmount = sAmount.trim();
			} else {
				arr = oneRow.split(",");
				sAmount = arr[Integer.parseInt(btDTO.getFeeIndex()) - 1];
				sAmount = sAmount.trim();
			}
		}
		// 左補零
		if ("Y".equals(btDTO.getIsLeftZero())) {
			sAmount = sAmount.replaceAll("^(0+)", "");
		}
		// 第一位有特殊符號
		if ("Y".equals(btDTO.getIsFristNum())) {
			sAmount = sAmount.substring(1, sAmount.length());
		}
		// 最後一位有特殊符號
		if ("Y".equals(btDTO.getIslastNum())) {
			sAmount = sAmount.substring(0, sAmount.length() - 1);
		}
		// 字符中有千分符
		if ("Y".equals(btDTO.getIsPermille())) {
			sAmount = sAmount.replace(",", "");
		}
		// 有兩位小數
		if ("Y".equals(btDTO.getIsTwoNum())) {
			if ("Y".equals(btDTO.getIsPoint())) {
				amount = Double.parseDouble(sAmount);
			} else {
				sAmount = sAmount.substring(0, sAmount.length() - 2) + "." + sAmount.substring(sAmount.length() - 2, sAmount.length());
				amount = Double.parseDouble(sAmount);
			}
		} else {
			if (sAmount.indexOf('.') < 0) {
				sAmount = sAmount + "." + "00";
				amount = Double.parseDouble(sAmount);
			} else {
				amount = Double.parseDouble(sAmount);
			}
		}

		return amount;
	}

	// 得到備註數據
	private String getRemark(BankTemplateDTO btDTO, String oneRow) throws Exception {
		String remark = "";
		String[] arr = null;
		byte[] tmp = null;
		if ("|".equals(btDTO.getConIndex())) {
			int start = Integer.parseInt(btDTO.getConStart()) - 1;
			int end = Integer.parseInt(btDTO.getConEnd());
			if(oneRow.length() < end)
				end = oneRow.length();
			remark = oneRow.substring(start, end).trim();
		} else {
			if ("S".equals(btDTO.getSplitFileType())) {
				arr = oneRow.split(";");
				remark = arr[Integer.parseInt(btDTO.getConIndex()) - 1];
			} else if ("C".equals(btDTO.getSplitFileType())) {
				arr = oneRow.split(",");
				remark = arr[Integer.parseInt(btDTO.getConIndex()) - 1];
			} else {
				int start = Integer.parseInt(btDTO.getConStart()) - 1;
				int end = Integer.parseInt(btDTO.getConEnd());
				if(oneRow.getBytes().length < end)
					end = oneRow.getBytes().length;
				tmp = new byte[end-start];
				System.arraycopy( oneRow.getBytes(), start, tmp, 0, (end-start) );
				remark = CommonUtil.AllTrim(new String(tmp));
			}
		}
		remark = remark.replace(",", "，");

		return remark;
	}

	private String getFileName(String filepath) {
		String fname = "";
		StringTokenizer st = null;
		filepath = filepath.split("\\.")[0];
		if(filepath.indexOf("\\") != -1) {
			st = new StringTokenizer(filepath, "\\");
		}
		if(filepath.indexOf("/") != -1) {
			st = new StringTokenizer(filepath, "/");
		}
		if(st != null) {
			while(st.hasMoreTokens()) {
				fname = st.nextToken();
			}
		}
		return fname;
	}

}
