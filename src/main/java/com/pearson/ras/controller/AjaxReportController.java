package com.pearson.ras.controller;

import java.io.IOException;
import java.lang.reflect.Type;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.Collection;
import java.util.Date;
import java.util.logging.Logger;

import javax.annotation.Resource;
//import javax.servlet.http.HttpServletRequest;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.pearson.ras.domain.AllReportSearch;
import com.pearson.ras.domain.Report;
import com.pearson.ras.domain.ReportPage;
import com.pearson.ras.domain.ReportTreeNode;
import com.pearson.ras.domain.ReportVersion;
import com.pearson.ras.service.FetchLevel;
import com.pearson.ras.service.RoyaltyReportsDAO;

@Controller
public class AjaxReportController {

	@Resource(name = "RoyaltyDAO")
	public RoyaltyReportsDAO royaltyReportsDAO = new RoyaltyReportsDAO();

	private static final Logger log = Logger.getLogger("com.pearson.ras.controller.AjaxReportController");

	// get the list of all report in groups
	@RequestMapping(value = { "/groupList" }, method = RequestMethod.GET)
	public @ResponseBody String getGroupList(@RequestParam String reportFilter, @RequestParam String searchKeyword,
			@RequestParam FetchLevel level, HttpServletRequest request) throws Exception {
		log.info(" Ajax call Report " + " reportFilter= " + reportFilter + " search keyword= " + searchKeyword
				+ " FetchLevel= " + level);
		ReportTreeNode reportTreeNode = null;
		reportTreeNode = royaltyReportsDAO.getGroupList(reportFilter, searchKeyword, level, request);
		Gson gson = new Gson();
		String json = gson.toJson(reportTreeNode);
		System.out.println("test json " + json);
		return json;
	}

	// get the reports in favorites folder
	@RequestMapping(value = { "/getUserFavReports" }, method = { RequestMethod.GET })
	public @ResponseBody String getUserFavReports(HttpServletRequest req) {
		log.info(" Ajax call Report ");
		Collection<Report> report = null;
		report = royaltyReportsDAO.getUserFavReports(req);
		Gson gson = new Gson();
		String json = gson.toJson(report);
		System.out.println("test json " + json);
		return json;
	}

	// get the report object
	@RequestMapping(value = { "/report" }, method = { RequestMethod.GET })
	public @ResponseBody String getReport(@RequestParam int reportId, @RequestParam String searchKeyword,
			@RequestParam FetchLevel level) {
		log.info(" Ajax call Report " + " reportId= " + reportId + " search keyword= " + searchKeyword + " FetchLevel= "
				+ level);
		Report report = null;
		report = royaltyReportsDAO.getReport(reportId, searchKeyword, level);
		Gson gson = new Gson();
		String json = gson.toJson(report);
		System.out.println("test json " + json);
		return json;
	}

	// get the report version
	@RequestMapping(value = { "/reportVersion" }, method = { RequestMethod.GET })
	public @ResponseBody String getReportVersion(@RequestParam int sno, @RequestParam FetchLevel level) {
		log.info(" Ajax call Report " + " sno= " + sno + " FetchLevel= " + level);
		ReportVersion reportVersion = null;
		reportVersion = royaltyReportsDAO.getReportVersion(sno, level);
		Gson gson = new Gson();
		String json = gson.toJson(reportVersion);
		System.out.println("test json " + json);
		return json;
	}

	// get the list of report pages
	@RequestMapping(value = { "/getReportPagesList" }, method = { RequestMethod.GET })
	public @ResponseBody String getReportPagesList(@RequestParam long sno, @RequestParam String searchKeyword,
			@RequestParam FetchLevel level) {
		log.info(" Ajax call Report " + " sno=" + sno + " search keyword= " + searchKeyword + " FetchLevel= " + level);
		Collection<ReportPage> reportPage = null;
		reportPage = royaltyReportsDAO.getReportPagesList(sno, searchKeyword, level);
		Gson gson = new Gson();
		String json = gson.toJson(reportPage);
		System.out.println("test json " + json);
		return json;
	}

	// get the report page
	@RequestMapping(value = { "/reportPage" }, method = { RequestMethod.GET })
	public @ResponseBody String getReportPage(@RequestParam int sno, @RequestParam int page_no) {
		log.info(" Ajax call Report " + " sno= " + sno + " page_no= " + page_no);
		ReportPage reportPage = null;
		reportPage = royaltyReportsDAO.getReportPage(sno, page_no);
		Gson gson = new Gson();
		String json = gson.toJson(reportPage);
		System.out.println("test json " + json);
		return json;
	}

	// check where the report is in favorite
	@RequestMapping(value = { "/isReportInFavs" }, method = { RequestMethod.GET })
	public @ResponseBody String isReportInFavs(@ModelAttribute Report report, HttpServletRequest req) {
		log.info(" Ajax call Report " + " report = " + report);
		Report report1 = royaltyReportsDAO.isReportInFavs(report, req);
		Gson gson = new Gson();
		String json = gson.toJson(report);
		System.out.println("test json " + json);
		return json;
	}

	// remove the report from favorite
	@RequestMapping(value = { "/removeReportFromFav" }, method = { RequestMethod.POST })
	public @ResponseBody String removeReportFromFav(@ModelAttribute Report report, HttpServletRequest req) {
		log.info(" Ajax call Report " + " report = " + report);
		Collection<Report> report2 = null;
		report2 = royaltyReportsDAO.removeReportFromFav(report, req);
		Gson gson = new Gson();
		String json = gson.toJson(report2);
		System.out.println("test json " + json);
		return json;
	}

	// add the report in favorite
	@RequestMapping(value = { "/addReportToFav" }, method = { RequestMethod.POST })
	public @ResponseBody String addReportToFav(@ModelAttribute Report report, HttpServletRequest req) {
		log.info(" Ajax call Report " + " report = " + report);
		Collection<Report> reportFav = null;
		reportFav = royaltyReportsDAO.addReportToFav(report, req);
		Gson gson = new Gson();
		String json = gson.toJson(reportFav);
		System.out.println("test json " + json);
		return json;
	}

	// get all reports searchresult
	@RequestMapping(value = { "/getAllRepSearchResults" }, method = { RequestMethod.GET })
	public @ResponseBody String getAllRepSearchResults(@RequestParam int istartIndex, @RequestParam int iendIndex,
			@RequestParam String searchKeyword, HttpServletRequest req) {
		log.info(" Ajax call Report " + " istartIndex = " + istartIndex + " iendIndex = " + iendIndex
				+ " searchKeyword = " + searchKeyword);
		AllReportSearch allReportSearch = null;
		allReportSearch = royaltyReportsDAO.getAllRepSearchResults(istartIndex, iendIndex, searchKeyword, req);
		Gson gson = new GsonBuilder().setDateFormat("E MMM dd yyyy HH:mm:ss 'GMT' Z '('zzzz')'").create();
		String json = gson.toJson(allReportSearch);
		System.out.println("test json " + json);
		return json;
	}
}
