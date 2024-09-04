package com.pearson.ras.controller;

import jakarta.servlet.http.HttpServletRequest;

public class ReqParamHelper {
	public ReqParamHelper() {
		super();
	}

	public static String getssoUserID(HttpServletRequest request) {
		String ssoUserID = request.getHeader("CT_REMOTE_USER");

		System.out.println("The user id is :" + ssoUserID);

		if (ssoUserID == null)
			ssoUserID = "test"; // TODO

		else
			ssoUserID = ssoUserID.trim();
		return ssoUserID.toLowerCase();
	}

	public static String getUserFirstName(HttpServletRequest request) {
		String ssoUserFirstName = request.getHeader("givenName");
		System.out.println("The first name id :" + ssoUserFirstName);

		if (ssoUserFirstName == null)
			ssoUserFirstName = " "; // TODO
		else
			ssoUserFirstName = ssoUserFirstName.trim();

		return ssoUserFirstName;
	}

	public static String getUserLastName(HttpServletRequest request) {
		String ssoUserLastName = request.getHeader("sn");
		System.out.println("The last name id :" + ssoUserLastName);

		if (ssoUserLastName == null)
			ssoUserLastName = " "; // TODO
		else
			ssoUserLastName = ssoUserLastName.trim();

		return ssoUserLastName;
	}

}
