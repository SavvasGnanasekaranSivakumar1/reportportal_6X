package com.pearson.ras.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LogoutController {

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession();

		// Invalidate the session and removes any attribute related to it
		// if(session != null)
		session.removeAttribute("USER_KEY");
		session.removeAttribute("CT_REMOTE_USER");
		session.removeAttribute("givenName");
		session.removeAttribute("sn");
		session = request.getSession(false);
		session.invalidate();

		// Get an HttpSession related to this request, if no session exist don't

		// create a new one. This is just a check to see after invalidation the

		// session will be null.

		session = request.getSession(false);

		response.getWriter().println("Session : " + session);

		// response.sendRedirect();
		// System.out.println("*********************session ivalidated");
		/*
		 * ModelAndView mv = new ModelAndView(); mv.setViewName("login");
		 */

		// System.out.println( "After invalidate" +
		// session.getAttribute("CT_REMOTE_USER"));
		return new ModelAndView("login");

	}

}
