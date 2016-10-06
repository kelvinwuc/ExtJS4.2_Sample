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
 * Function : ���n�b�B�z
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
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix---�W�[LOG
 *
 * Revision 1.5  2014/01/13 03:52:30  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
 * BugFix---�W�[LOG
 *
 * Revision 1.4  2014/01/03 02:49:52  MISSALLY
 * R00135---PA0024---CASH�~�ױM��-02
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
						log.info("processUploadFile����");
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
				req.setAttribute("txtError", "�n�b���\!!\r\n" + strSuccessMsg);
			}
		} catch (IOException ex) {
			System.err.println("Error: " + ex.getMessage());
			req.setAttribute("txtError", "Ū���]�w�Ȧ�榡���X�{���`���~!!");
		} catch (SQLException ex) {
			System.err.println("Error: " + ex.getMessage());
			req.setAttribute("txtError", "�s����Ʈw�X�{���`���~!!");
		} catch (FileUploadException ex) {
			System.err.println("Error: " + ex.getMessage());
			req.setAttribute("txtError", "�W�Ǥ��X�{���`���~!!");
		} catch (Exception ex) {
			System.err.println("Error: " + ex.getMessage());
			req.setAttribute("txtError", "���`���~!!");
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

	// �B�z�W�Ǭy���A�o�줺�e�A�J�n�b��
	private void processUploadFile(String fileName, InputStream in, int iSeq) throws IOException, SQLException {
		HashMap<String, BankTemplateDTO> map = this.getAllBankTempalte();
		List<CapcshfDTO> list = this.readOneFileChangeCapcshfDTO(in, map, fileName);
		if (list.size() > 0) {
			iCounter = 0;
			log.info("processUploadFile����");
			for (int i = 0; i < list.size(); i++) {
				log.info("processUploadFile����" + i);
				try {
					this.saveCapbnkf(list.get(i), iSeq);
					iSeq++;
					iCounter++;
				} catch (SQLException e) {
					PageMessage.append(fileName + " :���ɥ���" + "&nbsp;");
					System.err.println("���ɥ���: " + fileName + " �Ǹ�=" + iSeq);
					throw e;
				}
			}
			strSuccessMsg += getFileName(fileName) + " :���\�W�� " + iCounter + " ��;\r\n";
		}
	}

	// �B�z�W�Ǥ��A�ഫ�ƾڨ��H�A�ð��ƾ�����
	private List<CapcshfDTO> readOneFileChangeCapcshfDTO(InputStream in, HashMap<String, BankTemplateDTO> map, String fileName) throws SQLException, IOException {
		log.info("readOneFileChangeCapcshfDTO����");
		BufferedReader reader = new BufferedReader(new InputStreamReader(in));
		List<CapcshfDTO> list = new ArrayList<CapcshfDTO>();
		boolean juage = true;
		String oneRow = null;
		int index = 0;
		if (fileName.indexOf('.') < 0) {
			this.createErrorMessage(fileName, "", "�W�Ǥ��W����");
		} else {
			String bkalat = getFileName(fileName);
			log.info("bkalat�O" + bkalat);
			if (bkalat.toUpperCase().equals("BANK")) {
				while (true) {
					oneRow = reader.readLine();
					log.info("oneRow�O" + oneRow);
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
					this.createErrorMessage(fileName, "", "��󬰪šA�S�����e");
				}
				// ���@���ƾڿ��~�A�M��LIST�A���O�d����ƾ�
				if (!juage) {
					list.clear();
				}
			} else {
				CapbnkfVO cDTO = this.getBKALATForDTO(bkalat);
				// �ˬd����²�X
				if (null == cDTO) {
					this.createErrorMessage(fileName, "", "�d�L����²�X�]�w");
				} else {
					// ����Ȧ�N�X����
					if ("N".equals(cDTO.getBankStatus())) {
						this.createErrorMessage(fileName, "", "���ĳ�쪬�A������");
					} else if("N".equals(cDTO.getBankSpec())) {
						this.createErrorMessage(fileName, "", "���n�b�榡�]�w���D�Ȧ�榡�A�Хγq�ή榡�W��");
					} else {
						// �ˬd���L�榡
						BankTemplateDTO btDTO = map.get(bkalat);
						if (null == btDTO) {
							this.createErrorMessage(fileName, "", "�W�ǵn�b���S���������Ȧ�n�b�榡�B�z�A�Х��w�q�Ȧ�榡");
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
								log.info("oneRow�O" + oneRow);
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
								this.createErrorMessage(fileName, "", "��󬰪šA�S�����e");
							}
							// ���@���ƾڿ��~�A�M��LIST�A���O�d����ƾ�
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

	// �B�z�q�ή榡���
	private CapcshfDTO createCapcshfDTOForGeneral(String oneRow) throws SQLException {
		//System.out.println("oneRow�O" + oneRow);
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

	// �B�z�S��榡���
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

	// ����q�ή榡���
	private boolean checkCapcshfDTOForGeneral(CapcshfDTO cfDTO, String index, String fileName) {
		boolean res = true;
		if (cfDTO.getEBKCD().equals("0")) {
			res = false;
			this.createErrorMessage(fileName, index, "�d�L����²�X�]�w");
		} else if (cfDTO.getEBKCD().equals("1")) {
			res = false;
			this.createErrorMessage(fileName, index, "���ĳ�쪬�A������");
		}
		if (cfDTO.getEBKRMD() <= 0) {
			res = false;
			this.createErrorMessage(fileName, index, "�������榡���~");
		}
		if (cfDTO.getENTAMT() <= 0) {
			res = false;
			this.createErrorMessage(fileName, index, "������B�D�Ʀr�榡�Τp�󵥩�");
		}
		return res;
	}

	// ����S��榡���
	private boolean checkCapcshfDTO(CapcshfDTO cfDTO, String index, String fileName) {
		boolean res = true;
		if (cfDTO.getEBKRMD() <= 0) {
			res = false;
			this.createErrorMessage(fileName, index, "�������榡���~");
		}
		if (cfDTO.getENTAMT() <= 0) {
			res = false;
			this.createErrorMessage(fileName, index, "������B�D�Ʀr�榡�Τp�󵥩�");
		}
		return res;
	}

	// �c�ةҦ����~�O��
	private void createErrorMessage(String fileName, String count, String message) {
		if ("".equals(count)) {
			ErrorMessage = ErrorMessage.append(fileName + " :" + message + System.getProperty("line.separator"));
			PageMessage = PageMessage.append(fileName + " :�W�ǿ��~," + message + "\r\n");
		} else {
			ErrorMessage = ErrorMessage.append(fileName + "��" + count + "��: " + message + System.getProperty("line.separator"));
			PageMessage = PageMessage.append(fileName + " :�W�ǿ��~," + message + "\r\n");
		}

	}

	// �Ҧ����~�H���g�J���~�U������
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

	// ���o�Ҧ��Ȧ�榡��JMap
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

	// �Ȧ�榡�Ʋ���ƻȦ�榡��H
	private BankTemplateDTO arrayChangeBankTemplateDTO(String[] arr) {
		/*for(int i=0; i<arr.length; i++){
			System.out.println("arr[" + i + "]�O" + arr[i]);
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

	// �ϥΪ���²�X�a�X�����Ȧ�N�X�b����
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

	// �O�s�Ȧ���ɼƾڨ�n�b�־P��
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
		pstmt.setInt(11, iTime);	////���F��Key unique
		pstmt.setString(12, dto.getCSHFCURR());
		//pstmt.executeUpdate();
		//����
		System.out.println("EBKCD�O" + dto.getEBKCD());
		System.out.println("EATNO�O" + dto.getEATNO());
		System.out.println("EBKRMD�O" + dto.getEBKRMD());
		System.out.println("EAEGDT�O" + dto.getEAEGDT());
		System.out.println("ENTAMT�O" + dto.getENTAMT());
		System.out.println("ECRSRC�O" + dto.getECRSRC());
		System.out.println("ECRDAY�O" + dto.getECRDAY());
		System.out.println("EUSREM�O" + dto.getEUSREM());
		System.out.println("CSHFAU�O" + dto.getCSHFAU());
		System.out.println("CSHFAD�O" + dto.getCSHFAD());
		System.out.println("CSHFAT�O" + iTime);
		System.out.println("CSHFCURR�O" + dto.getCSHFCURR());

		if(pstmt != null) pstmt.close();
	}

	// �o�������
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
		// �P�_�褸�Ϊ̥���
		if ("X".equals(btDTO.getDateTpye())) {	//�褸
			date = Integer.parseInt(sDate) - 19110000;
		} else if("B".equals(btDTO.getDateTpye())) {	//����~���X
			date = Integer.parseInt("1"+sDate);
		} else {
			date = Integer.parseInt(sDate);
		}
		return date;
	}

	// �o�������B
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
		// ���ɹs
		if ("Y".equals(btDTO.getIsLeftZero())) {
			sAmount = sAmount.replaceAll("^(0+)", "");
		}
		// �Ĥ@�즳�S��Ÿ�
		if ("Y".equals(btDTO.getIsFristNum())) {
			sAmount = sAmount.substring(1, sAmount.length());
		}
		// �̫�@�즳�S��Ÿ�
		if ("Y".equals(btDTO.getIslastNum())) {
			sAmount = sAmount.substring(0, sAmount.length() - 1);
		}
		// �r�Ť����d����
		if ("Y".equals(btDTO.getIsPermille())) {
			sAmount = sAmount.replace(",", "");
		}
		// �����p��
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

	// �o��Ƶ��ƾ�
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
		remark = remark.replace(",", "�A");

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
