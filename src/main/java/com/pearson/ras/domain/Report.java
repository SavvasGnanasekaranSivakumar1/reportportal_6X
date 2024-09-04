package com.pearson.ras.domain;

import java.util.ArrayList;
import java.util.List;

public class Report {
	private int reportId;

	private ReportTreeNode parent;

	private int reportCatId;

	private String reportName;

	private String reportGroup;

	private String description;

	private String accessRole;

	private boolean favorite;

	private List<ReportVersion> reportVersionsList = new ArrayList<ReportVersion>();

	private int retentionPolicy;

	public int getReportId() {
		return reportId;
	}

	public void setReportId(int reportId) {
		this.reportId = reportId;
	}

	public String getReportName() {
		return reportName;
	}

	public void setReportName(String reportName) {
		this.reportName = reportName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAccessRole() {
		return accessRole;
	}

	public void setAccessRole(String accessRole) {
		this.accessRole = accessRole;
	}

	public int getRetentionPolicy() {
		return retentionPolicy;
	}

	public void setRetentionPolicy(int retentionPolicy) {
		this.retentionPolicy = retentionPolicy;
	}

	public List<ReportVersion> getReportVersionsList() {
		return reportVersionsList;
	}

	public void setReportVersions(List<ReportVersion> reportVersionsList) {
		this.reportVersionsList = reportVersionsList;
	}

	public boolean isFavorite() {
		return favorite;
	}

	public void setFavorite(boolean favorite) {
		this.favorite = favorite;
	}

	public void setReportVersionsList(List<ReportVersion> reportVersionsList) {
		this.reportVersionsList = reportVersionsList;
	}

	public int getReportCatId() {
		return reportCatId;
	}

	public void setReportCatId(int reportCatId) {
		this.reportCatId = reportCatId;
	}

	public String getReportGroup() {
		return reportGroup;
	}

	public void setReportGroup(String reportGroup) {
		this.reportGroup = reportGroup;
	}

	public ReportTreeNode getParent() {
		return parent;
	}

	public void setParent(ReportTreeNode parent) {
		this.parent = parent;
	}

}
