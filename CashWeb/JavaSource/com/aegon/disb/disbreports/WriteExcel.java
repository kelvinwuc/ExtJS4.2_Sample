package com.aegon.disb.disbreports;

import java.io.File;
import java.io.IOException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.CellView;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;


public class WriteExcel {

  private WritableCellFormat timesBoldUnderline;
  private WritableCellFormat times;
  private String inputFile;
  
  public void setOutputFile(String inputFile) {
	  this.inputFile = inputFile;
  }

  public void write(HttpServletRequest request, HttpServletResponse response) throws IOException, WriteException {
	File file = new File(inputFile);
    WorkbookSettings wbSettings = new WorkbookSettings();
    wbSettings.setLocale(new Locale("zh", "TW"));
	WritableWorkbook workbook = Workbook.createWorkbook(file, wbSettings);
	try{
		workbook.createSheet("急件給付清單", 0);
		WritableSheet excelSheet = workbook.getSheet(0);
		createLabel(excelSheet);
		createContent(excelSheet,request,response);
		workbook.write();
	}finally{
		if (workbook != null) workbook.close();
	}
  }

  private void createLabel(WritableSheet sheet)
      throws WriteException {
    WritableFont times10pt = new WritableFont(WritableFont.TIMES, 10);
    times = new WritableCellFormat(times10pt);
    times.setWrap(true);
    
    WritableFont times10ptBoldUnderline = new WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false,
    UnderlineStyle.SINGLE);
    timesBoldUnderline = new WritableCellFormat(times10ptBoldUnderline);

    CellView cv = new CellView();
    cv.setFormat(times);
    cv.setFormat(timesBoldUnderline);
    cv.setAutosize(true);
    
    addCaption(sheet, 0, 0, "支票號碼");
    addCaption(sheet, 1, 0, "保單號碼");
    addCaption(sheet, 2, 0, "支付金額");
    addCaption(sheet, 3, 0, "匯費");
    addCaption(sheet, 4, 0, "日期");
    addCaption(sheet, 5, 0, "付款方式");
  }

  private void createContent(WritableSheet sheet,HttpServletRequest request, HttpServletResponse response) throws WriteException,
      RowsExceededException {
	int k = 1 ;
	String[] pno = request.getParameterValues("PNO");
	String strDEPT = "" ;
	for (int i = 0 ; i < pno.length ; i++){	
		strDEPT = request.getParameter("DEPT"+pno[i]);
		if ("E".equals(request.getParameter("PMETHOD"+pno[i])) && !(strDEPT.trim().equals("PCD") 
				 													|| strDEPT.trim().equals("TYB") 
				 													|| strDEPT.trim().equals("TCB") 
				 													|| strDEPT.trim().equals("TNB") 
				 													|| strDEPT.trim().equals("KHB"))){ 
			continue ;
		}
		addLabel(sheet, 0, k, request.getParameter("CHK"+pno[i])!=null?request.getParameter("CHK"+pno[i]):"");
		addLabel(sheet, 1, k, request.getParameter("POLICY"+pno[i]));
		addLabel(sheet, 2, k, request.getParameter("PAMT"+pno[i]));
		addLabel(sheet, 3, k, request.getParameter("RMTFEE"+pno[i]));
		addLabel(sheet, 4, k, request.getParameter("PDATE"+pno[i]));
		if ("A".equals(request.getParameter("PMETHOD"+pno[i])))
			addLabel(sheet, 5, k, "支票");
		else if ("B".equals(request.getParameter("PMETHOD"+pno[i])))
			addLabel(sheet, 5, k, "銀行匯款");
		else if ("C".equals(request.getParameter("PMETHOD"+pno[i])))
			addLabel(sheet, 5, k, "信用卡");
		else if ("D".equals(request.getParameter("PMETHOD"+pno[i])))
			addLabel(sheet, 5, k, "外幣匯款");
		else if ("E".equals(request.getParameter("PMETHOD"+pno[i])))
			addLabel(sheet, 5, k, "現金");
		else
			addLabel(sheet, 5, k, request.getParameter("PMETHOD"+pno[i]));
		k++ ;
	}
  }

  private void addCaption(WritableSheet sheet, int column, int row, String s)
      throws RowsExceededException, WriteException {
    Label label;
    label = new Label(column, row, s, timesBoldUnderline);
    sheet.addCell(label);
  }

  private void addNumber(WritableSheet sheet, int column, int row,
      Integer integer) throws WriteException, RowsExceededException {
    Number number;
    number = new Number(column, row, integer, times);
    sheet.addCell(number);
  }

  private void addLabel(WritableSheet sheet, int column, int row, String s)
      throws WriteException, RowsExceededException {
    Label label;
    label = new Label(column, row, s, times);
    sheet.addCell(label);
  }
} 
