package com.pearson.ras.domain;

import java.util.ArrayList;
import java.util.List;

public class ReportVersion {

	private int sno;

	private int reportId;

	private int numberOfPages;

	private String createDate;

	private String pdfFileLocation;

	private List<ReportPage> reportPages = new ArrayList<ReportPage>();

	public int getSno() {
		return sno;
	}

	public void setSno(int sno) {
		this.sno = sno;
	}

	public int getReportId() {
		return reportId;
	}

	public void setReportId(int reportId) {
		this.reportId = reportId;
	}

	public int getNumberOfPages() {
		return numberOfPages;
	}

	public void setNumberOfPages(int numberOfPages) {
		this.numberOfPages = numberOfPages;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getPdfFileLocation() {
		return pdfFileLocation;
	}

	public void setPdfFileLocation(String pdfFileLocation) {
		this.pdfFileLocation = pdfFileLocation;
	}

	public List<ReportPage> getReportPages() {
		return reportPages;
	}

	public void setReportPages(List<ReportPage> reportPages) {
		this.reportPages = reportPages;
	}

}
