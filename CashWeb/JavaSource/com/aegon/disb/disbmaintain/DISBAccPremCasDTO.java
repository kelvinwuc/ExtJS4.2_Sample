package com.aegon.disb.disbmaintain;

/**
 * System   : CashWeb
 * 
 * Function : 保費收入現金帳分錄
 * 
 * Remark   : 管理系統─財務
 * 
 * Revision : $$Revision: 1.2 $$
 * 
 * Author   : ODCWILLIAM
 * 
 * Create Date : $$Date: 2014/01/29 07:40:01 $$
 * 
 * Request ID : PA0024
 * 
 * CVS History:
 * 
 * $$Log: DISBAccPremCasDTO.java,v $
 * $Revision 1.2  2014/01/29 07:40:01  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $BugFix---0->00
 * $
 * $Revision 1.1  2014/01/03 02:49:52  MISSALLY
 * $R00135---PA0024---CASH年度專案-02
 * $$
 *  
 */

public class DISBAccPremCasDTO implements Comparable<DISBAccPremCasDTO> {

	public DISBAccPremCasDTO(String currency, String enrtyDate) {
		this.category = "Manual";
		this.source = "Spreadsheet";
		this.currency = currency;
		this.company = "0";
		this.channel = "0";
		this.lob = "0";
		this.period = "Z";
		this.planCode = "ZZ";
		this.investment = "000";
		this.investmentSql = "0";
		this.department = "00";
		this.partner = "00";
		this.future1 = "000000000000000";
		this.future2 = "000";
		this.future3 = "0";
		this.future4 = "00";
		this.future5 = "000";
		this.accountingDate = enrtyDate.substring(0, 4) + "/"
				+ enrtyDate.substring(4, 6) + "/" + enrtyDate.substring(6, 8);
		this.debit = 0;
		this.credit = 0;
		this.journalName = enrtyDate.substring(2) + "211" + currency;
		this.conversionType = "User";
		this.conversionRate = 1.0000;
		this.conversionDate = enrtyDate.substring(0, 4) + "/"
				+ enrtyDate.substring(4, 6) + "/" + enrtyDate.substring(6, 8);
		this.batchName = "";
		this.sort = "2Z";

	}

	private String category;

	private String source;

	private String currency;

	private String company;

	private String mainAccount;

	private String channel;

	private String lob;

	private String period;

	private String planCode;

	private String investment;

	private String investmentSql;

	private String department;

	private String partner;

	private String future1;

	private String future2;

	private String future3;

	private String future4;

	private String future5;

	private String accountingDate;

	private double debit;

	private double credit;

	private String journalName;

	private String lineDescription;

	private String conversionType;

	private double conversionRate;

	private String conversionDate;

	private String batchName;

	private String paymentType;

	private String sort;

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getMainAccount() {
		return mainAccount;
	}

	public void setMainAccount(String mainAccount) {
		this.mainAccount = mainAccount;
	}

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}

	public String getLob() {
		return lob;
	}

	public void setLob(String lob) {
		this.lob = lob;
	}

	public String getPeriod() {
		return period;
	}

	public void setPeriod(String period) {
		this.period = period;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public String getInvestment() {
		return investment;
	}

	public void setInvestment(String investment) {
		this.investment = investment;
	}

	public String getInvestmentSql() {
		return investmentSql;
	}

	public void setInvestmentSql(String investmentSql) {
		this.investmentSql = investmentSql;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getPartner() {
		return partner;
	}

	public void setPartner(String partner) {
		this.partner = partner;
	}

	public String getFuture1() {
		return future1;
	}

	public void setFuture1(String future1) {
		this.future1 = future1;
	}

	public String getFuture2() {
		return future2;
	}

	public void setFuture2(String future2) {
		this.future2 = future2;
	}

	public String getFuture3() {
		return future3;
	}

	public void setFuture3(String future3) {
		this.future3 = future3;
	}

	public String getFuture4() {
		return future4;
	}

	public void setFuture4(String future4) {
		this.future4 = future4;
	}

	public String getFuture5() {
		return future5;
	}

	public void setFuture5(String future5) {
		this.future5 = future5;
	}

	public String getAccountingDate() {
		return accountingDate;
	}

	public void setAccountingDate(String accountingDate) {
		this.accountingDate = accountingDate;
	}

	public double getDebit() {
		return debit;
	}

	public void setDebit(double d) {
		this.debit = d;
	}

	public double getCredit() {
		return credit;
	}

	public void setCredit(double d) {
		this.credit = d;
	}

	public String getJournalName() {
		return journalName;
	}

	public void setJournalName(String journalName) {
		this.journalName = journalName;
	}

	public String getLineDescription() {
		return lineDescription;
	}

	public void setLineDescription(String lineDescription) {
		this.lineDescription = lineDescription;
	}

	public String getConversionType() {
		return conversionType;
	}

	public void setConversionType(String conversionType) {
		this.conversionType = conversionType;
	}

	public double getConversionRate() {
		return conversionRate;
	}

	public void setConversionRate(double d) {
		this.conversionRate = d;
	}

	public String getConversionDate() {
		return conversionDate;
	}

	public void setConversionDate(String conversionDate) {
		this.conversionDate = conversionDate;
	}

	public String getBatchName() {
		return batchName;
	}

	public void setBatchName(String batchName) {
		this.batchName = batchName;
	}

	public String getPaymentType() {
		return paymentType;
	}

	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String string) {
		this.sort = string;
	}

	public int compareTo(DISBAccPremCasDTO o) {
		return this.getSort().compareTo(o.getSort());
    }
}
