package com.pearson.ras.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import java.util.logging.Logger;
import com.pearson.ras.domain.HeaderInfo;

@Controller
public class MainController {

	Logger log = Logger.getLogger("com.pearson.ras.controllers.MainController");

	@RequestMapping("/showHome")
	public ModelAndView showHome(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String ssoUserID = ReqParamHelper.getssoUserID(request);
		String ssoUserFirstName = ReqParamHelper.getUserFirstName(request);
		String ssoUserLastName = ReqParamHelper.getUserLastName(request);

		if (ssoUserID == "test") {
			ModelAndView loginmv = new ModelAndView();
			loginmv.setViewName("login");
			return loginmv;
		}
		log.info("userid: " + ssoUserID + " First Name: " + ssoUserFirstName + " last name: " + ssoUserLastName);
		System.out.println(
				"userid: " + ssoUserID + " First Name: " + ssoUserFirstName + " last name: " + ssoUserLastName);
		HeaderInfo headerInfo = new HeaderInfo();
		headerInfo.setUserFirstName(ssoUserFirstName);
		headerInfo.setUserLastName(ssoUserLastName);
		headerInfo.setUserId(ssoUserID);
		ModelAndView mv = new ModelAndView();
		mv.addObject("headerInfo", headerInfo);
		mv.setViewName("home");

		return mv;

	}
}
