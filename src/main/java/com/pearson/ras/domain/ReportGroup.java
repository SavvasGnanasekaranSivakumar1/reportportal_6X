package com.pearson.ras.domain;

import java.util.ArrayList;
import java.util.List;

public class ReportGroup {

	private String reportGroup;

	private List<Report> reportList = new ArrayList<Report>();

	public String getReportGroup() {
		return reportGroup;
	}

	public void setReportGroup(String reportGroup) {
		this.reportGroup = reportGroup;
	}

	public List<Report> getReportList() {
		return reportList;
	}

	public void setReportList(List<Report> reportList) {
		this.reportList = reportList;
	}

}
