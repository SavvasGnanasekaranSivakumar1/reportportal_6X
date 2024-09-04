package com.pearson.ras.domain;

import java.util.ArrayList;
import java.util.List;

public class ReportTreeNode {

	private ReportTreeNode parent;

	private List<ReportTreeNode> children;

	private List<Report> reportList = new ArrayList<Report>();

	private String name;

	private int catId;

	private String path;

	public ReportTreeNode getParent() {
		return parent;
	}

	public void setParent(ReportTreeNode parent) {
		this.parent = parent;
	}

	public List<ReportTreeNode> getChildren() {
		return children;
	}

	public void setChildren(List<ReportTreeNode> children) {
		this.children = children;
	}

	public void addChild(ReportTreeNode childNode) {
		if (children == null)
			children = new ArrayList<ReportTreeNode>();

		children.add(childNode);

	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getCatId() {
		return catId;
	}

	public void setCatId(int catId) {
		this.catId = catId;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public List<Report> getReportList() {
		return reportList;
	}

	public void setReportList(List<Report> reportList) {
		this.reportList = reportList;
	}

}
