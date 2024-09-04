package com.pearson.ras.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import java.util.logging.Logger;

@Controller
public class ViewReportController {

	private static final Logger log = Logger.getLogger("com.pearson.ras.controllers.ViewReportController");

	@RequestMapping("/reportViewer")
	public ModelAndView showViewer(@RequestParam("reportSno") String reportSno, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		if (reportSno != null)
			reportSno.trim();

		log.info("*********************viewer reportSno: " + reportSno);
		ModelAndView mv = new ModelAndView();

		mv.addObject("reportSno", reportSno);
		mv.setViewName("reportViewer");

		return mv;

	}
}
