package com.aegon.entactbat;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * System   : CashWeb
 * 
 * Function : 創建銀行模板控制器
 * 
 * Remark   : 
 * 
 * Revision : $Revision: 1.3 $
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date :
 * 
 * Request ID  : PA0024
 * 
 * CVS History:
 * 
 * $Log: EntActBatTemplateServlet.java,v $
 * Revision 1.3  2013/12/24 06:16:27  MISSALLY
 * R00135---PA0024---CASH年度專案
 *
 *  
 */

public class EntActBatTemplateServlet extends HttpServlet {

	private String File = "\\WEB-INF\\ConfigFiles\\BankTemplateConfig.txt";
	private String INSERTURL = "/EntActBat/EntActBatB.jsp";
	private String SEARCHURL = "/EntActBat/EntActBatTemplate.jsp";
	private String UPDATEURL = "/EntActBat/EntActBatU.jsp";
	private String VIEWURL = "/EntActBat/EntActBatV.jsp";
	private String Path = null;
	private String URL = "";

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Path = getServletContext().getRealPath("/");

		String pageType = req.getParameter("PAGETYPE");
		if ("SE".equals(pageType)) {
			String bkalat = req.getParameter("BKALAT").toUpperCase();
			HashMap<String, BankTemplateDTO> map;
			try {
				map = this.getAllBankTempalte();
				BankTemplateDTO dto = map.get(bkalat);
				if (null == dto) {
					req.setAttribute("txtMsg", "沒有找到相關銀行模板");
					URL = SEARCHURL;
				} else {
					req.setAttribute("DTO", dto);
					URL = VIEWURL;
				}
			} catch (IOException e) {
				req.setAttribute("txtMsg", "讀取銀行模板失敗");
				URL = SEARCHURL;
			}
		} else if ("IN".equals(pageType)) {
			BankTemplateDTO dto = this.setUpParameters(req);
			String tempalte = this.createBankTemplate(dto);
			try {
				String content = this.readBankTemplateForFile();
				writeBankTemplateToFile(tempalte, content);
				req.setAttribute("txtMsg", "模板創建成功");
				req.setAttribute("DTO", dto);
				URL = VIEWURL;
			} catch (Exception e) {
				req.setAttribute("txtMsg", "讀取配置文件有誤.");
				URL = INSERTURL;
			}
		} else if ("UP".equals(pageType)) {
			BankTemplateDTO dto = this.setUpParameters(req);
			try {
				this.updateBankTemplate(dto);
				req.setAttribute("txtMsg", "模板修改成功");
				req.setAttribute("DTO", dto);
				URL = VIEWURL;
			} catch (IOException e) {
				req.setAttribute("txtMsg", "讀取配置文件有誤.");
				URL = UPDATEURL;
			}
		} else if ("DE".equals(pageType)) {
			String bkalat = req.getParameter("BKALAT");
			try {
				this.deleteBankTemplate(bkalat);
				req.setAttribute("txtMsg", "刪除模板成功");
			} catch (Exception e) {
				req.setAttribute("txtMsg", "刪除配置文件有誤.");
			}
			URL = SEARCHURL;
		} else if ("UV".equals(pageType)) {
			String bkalat = req.getParameter("BKALAT");
			HashMap<String, BankTemplateDTO> map;
			try {
				map = this.getAllBankTempalte();
				BankTemplateDTO dto = map.get(bkalat);
				if (null == dto) {
					req.setAttribute("txtMsg", "沒有找到相關銀行模板");
					URL = SEARCHURL;
				} else {
					req.setAttribute("DTO", dto);
					URL = UPDATEURL;
				}
			} catch (IOException e) {
				req.setAttribute("txtMsg", "讀取銀行模板失敗");
			}
		}

		req.getRequestDispatcher(URL).forward(req, resp);
	}

	// 頁面參數設置到BankTemplateDTO對象
	private BankTemplateDTO setUpParameters(HttpServletRequest req) {
		BankTemplateDTO dto = new BankTemplateDTO();
		dto.setBankCode(req.getParameter("bkCode").toUpperCase());
		dto.setFileType(req.getParameter("fileType"));
		dto.setSplitFileType(req.getParameter("SPL"));
		if (null == req.getParameter("SPLNUM")) {
			dto.setSplitNum("");
		} else {
			dto.setSplitNum(req.getParameter("SPLNUM"));
		}

		dto.setDateTpye(req.getParameter("DTYPE"));
		dto.setIsSlant(req.getParameter("SLANT"));
		if (null == req.getParameter("dsnum")) {
			dto.setDateStart("");
		} else {
			dto.setDateStart(req.getParameter("dsnum"));
		}
		if (null == req.getParameter("denum")) {
			dto.setDateEnd("");
		} else {
			dto.setDateEnd(req.getParameter("denum"));
		}
		if (null == req.getParameter("asnum")) {
			dto.setFeeStart("");
		} else {
			dto.setFeeStart(req.getParameter("asnum"));
		}
		if (null == req.getParameter("aenum")) {
			dto.setFeeEnd("");
		} else {
			dto.setFeeEnd(req.getParameter("aenum"));
		}
		if (null == req.getParameter("csnum")) {
			dto.setConStart("");
		} else {
			dto.setConStart(req.getParameter("csnum"));
		}
		if (null == req.getParameter("cenum")) {
			dto.setConEnd("");
		} else {
			dto.setConEnd(req.getParameter("cenum"));
		}
		if (null == req.getParameter("DNUM")) {
			dto.setDateIndex("");
		} else {
			dto.setDateIndex(req.getParameter("DNUM"));
		}
		if (null == req.getParameter("ANUM")) {
			dto.setFeeIndex("");
		} else {
			dto.setFeeIndex(req.getParameter("ANUM"));
		}
		if (null == req.getParameter("CNUM")) {
			dto.setConIndex("");
		} else {
			dto.setConIndex(req.getParameter("CNUM"));
		}
		dto.setIsLeftZero(req.getParameter("LEFTZ"));
		dto.setIsPoint(req.getParameter("SPOT"));
		dto.setIsTwoNum(req.getParameter("TPOT"));
		dto.setIsPermille(req.getParameter("TSN"));
		dto.setIsLeftSpace(req.getParameter("LEFTS"));
		dto.setIsFristNum(req.getParameter("LEFTO"));
		dto.setIslastNum(req.getParameter("RIGO"));
		return dto;
	}

	// 模板寫入配置文件中
	private void writeBankTemplateToFile(String tempalte, String content) throws IOException {
		FileWriter fw = new FileWriter(Path + File);
		fw.write(content);
		fw.write(tempalte);
		fw.flush();
		fw.close();
	}

	// 讀取配置文件
	private String readBankTemplateForFile() throws IOException {

		StringBuffer su = new StringBuffer();

		BufferedReader br = new BufferedReader(new FileReader(new File(Path + File)));
		String templine = "";
		while ((templine = br.readLine()) != null) {
			su.append(templine + System.getProperty("line.separator"));
		}
		return su.toString();
	}

	// 構建銀行登帳模板
	private String createBankTemplate(BankTemplateDTO dto) {
		String template = "";
		template += dto.getBankCode() + "|";
		template += dto.getFileType() + "|";
		template += dto.getSplitFileType() + "|";
		template += dto.getSplitNum() + "|";
		template += dto.getDateStart() + "|";
		template += dto.getDateEnd() + "|";
		template += dto.getDateIndex() + "|";
		template += dto.getDateTpye() + "|";
		template += dto.getIsSlant() + "|";
		template += dto.getFeeStart() + "|";
		template += dto.getFeeEnd() + "|";
		template += dto.getFeeIndex() + "|";
		template += dto.getIsLeftZero() + "|";
		template += dto.getIsLeftSpace() + "|";
		template += dto.getIsFristNum() + "|";
		template += dto.getIslastNum() + "|";
		template += dto.getIsPoint() + "|";
		template += dto.getIsTwoNum() + "|";
		template += dto.getIsPermille() + "|";
		template += dto.getConStart() + "|";
		template += dto.getConEnd() + "|";
		template += dto.getConIndex();
		return template;

	}

	// 取得所有銀行模板放入Map
	private HashMap<String, BankTemplateDTO> getAllBankTempalte() throws IOException {
		HashMap<String, BankTemplateDTO> hm = new HashMap<String, BankTemplateDTO>();
		BufferedReader br = new BufferedReader(new FileReader(new File(Path + File)));
		String templine = "";
		while ((templine = br.readLine()) != null) {
			String[] arr = templine.split("\\|", 22);
			BankTemplateDTO dto = this.arrayChangeBankTemplateDTO(arr);
			hm.put(dto.getBankCode(), dto);
		}
		return hm;
	}

	// 銀行模板數組轉化銀行模板對象
	private BankTemplateDTO arrayChangeBankTemplateDTO(String[] arr) {
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

	// 刪除配置的銀行模板
	private void deleteBankTemplate(String bkalat) throws IOException {
		BufferedReader br = new BufferedReader(new FileReader(new File(Path + File)));
		String templine = "";
		StringBuffer content = new StringBuffer();
		boolean res = true;
		while ((templine = br.readLine()) != null) {
			String[] arr = templine.split("\\|", 22);
			String[] sarr = arr[0].split(",");
			for (int i = 0; i < sarr.length; i++) {
				if (bkalat.equals(sarr[i])) {
					res = false;
				}
			}
			if (res) {
				content = content.append(templine
						+ System.getProperty("line.separator"));
			}
		}
		this.writeBankTemplateToFile("", content.toString());
	}

	private void updateBankTemplate(BankTemplateDTO dto) throws IOException {
		BufferedReader br = new BufferedReader(new FileReader(new File(Path + File)));
		String templine = "";
		StringBuffer content = new StringBuffer();
		boolean res = true;
		while ((templine = br.readLine()) != null) {
			String[] arr = templine.split("\\|", 22);
			String[] sarr = arr[0].split(",");
			for (int i = 0; i < sarr.length; i++) {
				if (dto.getBankCode().equals(sarr[i])) {
					res = false;
				}
			}
			if (res) {
				content = content.append(templine + System.getProperty("line.separator"));
			}
		}
		String str = this.createBankTemplate(dto);
		this.writeBankTemplateToFile(str, content.toString());
	}

}
