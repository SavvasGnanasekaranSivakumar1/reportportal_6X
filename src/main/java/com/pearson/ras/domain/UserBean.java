package com.pearson.ras.domain;

public class UserBean {

	private String username;

	public UserBean() {
	}

	public UserBean(String username) {
		super();
		this.username = username;

	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	@Override
	public String toString() {
		return "UserBean [username=" + " username ]";
	}

}
