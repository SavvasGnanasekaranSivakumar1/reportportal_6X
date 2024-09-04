package com.pearson.ras.domain;

import java.sql.Date;

public class RepSearchRes {

	private String reportSNo;

	private int totalPagesInReport;

	private int noOfOccurancesInReport;

	private String reportPath;

	private int reportId;

	private Date createDate;

	public String getReportSNo() {
		return reportSNo;
	}

	public void setReportSNo(String reportSNo) {
		this.reportSNo = reportSNo;
	}

	public String getReportPath() {
		return reportPath;
	}

	public void setReportPath(String reportPath) {
		this.reportPath = reportPath;
	}

	public int getReportId() {
		return reportId;
	}

	public void setReportId(int reportId) {
		this.reportId = reportId;
	}

	public int getTotalPagesInReport() {
		return totalPagesInReport;
	}

	public void setTotalPagesInReport(int totalPagesInReport) {
		this.totalPagesInReport = totalPagesInReport;
	}

	public int getNoOfOccurancesInReport() {
		return noOfOccurancesInReport;
	}

	public void setNoOfOccurancesInReport(int noOfOccurancesInReport) {
		this.noOfOccurancesInReport = noOfOccurancesInReport;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

}
