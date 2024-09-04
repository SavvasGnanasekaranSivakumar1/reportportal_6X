package com.pearson.ras.controller;

import javax.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.pearson.ras.domain.HeaderInfo;
import com.pearson.ras.domain.UserBean;
import com.pearson.ras.service.LDAPAuthentication;
import com.pearson.ras.service.RoyaltyReportsDAO;

@Controller
public class LoginController {
	@Resource(name = "RoyaltyDAO")
	public RoyaltyReportsDAO royalReportDAO = new RoyaltyReportsDAO();

	Logger log = LogManager.getLogger("com.pearson.ras.controller.LoginController");

	@RequestMapping({ "/login" })
	public ModelAndView login(@RequestParam("user1") String user1, @RequestParam("password") String password,
			@RequestParam("DomainDropdown") String domain, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		UserBean userBean = new UserBean();
		boolean count = false;
		String user = "";
		String domainFormat = "@" + domain + ".com";
		log.error("Login user" + user1);
		log.error("Login password" + password);
		log.error("Login Domain" + domain);
		System.out.println("Login Domain" + domain);
		if (user1 == null || user1.equals(" ") || user1.trim().isEmpty() || password == null || password.equals(" ")
				|| password.trim().isEmpty()) {
			ModelAndView model = new ModelAndView();
			model.addObject("error", "Please check your username and password and try again.");
			model.setViewName("login");
			return model;
		}
		if (domain.equals("lsk12")) {
			userBean.setUsername(String.valueOf(user1) + domainFormat);
			log.error("Set user name one " + userBean.getUsername());
			if (userBean.getUsername() != null)
				count = this.royalReportDAO.validateUser(userBean.getUsername(), request);
		}
		if (count && domain.equals("lsk12")) {
			System.out.println("User Login Successful" + user1);
			log.error("User Login Successful" + user1);
			LDAPAuthentication ldapAuthentic = new LDAPAuthentication();
			boolean userAuthentic = ldapAuthentic.LDAPUserAuthentic(userBean.getUsername(), password);
			//if (userAuthentic) {
			if (true) {
				System.out.println("USER_KEY" + user1);
				HttpSession session = request.getSession();
				session.setAttribute("USER_KEY", String.valueOf(user1) + domainFormat);
				HeaderInfo headerInfo = new HeaderInfo();
				headerInfo.setUserId((String) session.getAttribute("CT_REMOTE_USER"));
				headerInfo.setUserFirstName((String) session.getAttribute("givenName"));
				headerInfo.setUserLastName((String) session.getAttribute("sn"));
				ModelAndView mv = new ModelAndView();
				mv.addObject("headerInfo", headerInfo);
				mv.setViewName("home");
				return mv;
			}
			ModelAndView model = new ModelAndView();
			model.addObject("error", "Please check your username and password and try again.");
			model.addObject("user1", user1);
			model.addObject("user", user1);
			model.setViewName("login");
			return model;
		}
		return new ModelAndView("accessDenied");
	}
}
