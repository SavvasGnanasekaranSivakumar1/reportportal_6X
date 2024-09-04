package com.pearson.ras.domain;

import java.util.Collection;

public class AllReportSearch {

	private Collection<RepSearchRes> searchResList;

	private boolean moreResults;
	private int nextResListStartIndex;

	private int nextResListEndIndex;

	public Collection<RepSearchRes> getSearchResList() {
		return searchResList;
	}

	public void setSearchResList(Collection<RepSearchRes> searchResList) {
		this.searchResList = searchResList;
	}

	public boolean isMoreResults() {
		return moreResults;
	}

	public void setMoreResults(boolean moreResults) {
		this.moreResults = moreResults;
	}

	public int getNextResListStartIndex() {
		return nextResListStartIndex;
	}

	public void setNextResListStartIndex(int nextResListStartIndex) {
		this.nextResListStartIndex = nextResListStartIndex;
	}

	public int getNextResListEndIndex() {
		return nextResListEndIndex;
	}

	public void setNextResListEndIndex(int nextResListEndIndex) {
		this.nextResListEndIndex = nextResListEndIndex;
	}

}
