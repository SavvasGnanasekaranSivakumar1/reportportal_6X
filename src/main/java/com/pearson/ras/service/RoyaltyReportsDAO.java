package com.pearson.ras.service;

import java.sql.Clob;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import java.util.stream.Collectors;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import javax.sql.DataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.pearson.ras.domain.AllReportSearch;
import com.pearson.ras.domain.HeaderInfo;
import com.pearson.ras.domain.RepSearchRes;
import com.pearson.ras.domain.Report;
import com.pearson.ras.domain.ReportPage;
import com.pearson.ras.domain.ReportTreeNode;
import com.pearson.ras.domain.ReportVersion;

public class RoyaltyReportsDAO {

	private JdbcTemplate jdbcTemplate;
	private DataSource datasource;

	private static final Logger log = LogManager.getLogger("com.pearson.ras.service.RoyaltyReportsDAO");

	private String ssoUser;

	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public void setssoUser(String ssoUser) {
		this.ssoUser = ssoUser;
	}

	public String getssoUser(String ssoUser) {
		return this.ssoUser;
	}

	public Collection<Report> getUserFavReports(HttpServletRequest req) {

		String ssoUserID = getUserIdFromReq(req);

		log.info("requested user: " + ssoUserID);

		String sql = "select rl.report_id, rl.report_group_name, rl.report_name, rl.cat_id from roy_reports.user_fav_reports ufa JOIN roy_reports.report_list rl ON (ufa.report_id = rl.report_id AND ufa.user_id=?) order by rl.report_name asc";

		Collection<Report> reports = this.jdbcTemplate.query(sql, new Object[] { new String(ssoUserID) },
				new RowMapper() {

					@Override
					public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
						Report report = new Report();
						report.setFavorite(false); // TODO
						report.setReportId(rs.getInt("report_id"));
						report.setReportGroup(getFavRepPath(rs.getInt("cat_id")));
						report.setReportName(rs.getString("report_name"));

						return report;
					}
				});

		return reports;

	}

	private String getFavRepPath(final int catId) {

		if (catId == 0) {
			return "";
		}
		String path = "";
		String sql = "select parent_id from roy_reports.report_cat_tree where (cat_id  = ?)";

		Integer parentCatId1 = this.jdbcTemplate.queryForObject(sql, new Object[] { new Integer(catId) },
				Integer.class);
		int parentCatId = (parentCatId1 != null) ? parentCatId1 : 0;
		Object o = this.jdbcTemplate.queryForObject("select name from roy_reports.report_cat_tree where (cat_id  = ?)",
				new Object[] { new Integer(catId) }, String.class);

		path = (String) o;
		path = getFavRepPath(parentCatId) + ">" + path;

		return path;

	}

	public Report isReportInFavs(final Report report, HttpServletRequest req) {

		String ssoUserID = getUserIdFromReq(req);

		String sql = "select count(*) from roy_reports.user_fav_reports where (user_id  = ? AND report_id=?)";

		int count = this.jdbcTemplateQueryForInt(sql,
				new Object[] { new String(ssoUserID), new Integer(report.getReportId()) });

		if (count > 0) {
			report.setFavorite(true);
			return report;
		} else {
			report.setFavorite(false);

			return report;
		}
	}

	public Collection<Report> addReportToFav(final Report report, HttpServletRequest req) {

		String ssoUserID = getUserIdFromReq(req);

		String sql = "INSERT INTO roy_reports.user_fav_reports " + "(user_id, report_id) VALUES (?, ?)";

		this.jdbcTemplate.update(sql, new Object[] { ssoUserID, report.getReportId() });

		return getUserFavReports(req);

	}

	public Collection<Report> removeReportFromFav(final Report report, HttpServletRequest req) {

		String ssoUserID = getUserIdFromReq(req);

		this.jdbcTemplate.update("DELETE from roy_reports.user_fav_reports where user_id= ? AND report_id = ?",
				new Object[] { ssoUserID, report.getReportId() });

		return getUserFavReports(req);
	}

	public Collection<Report> getReportList(final ReportTreeNode parent, final String reportFilter,
			final String searchKeyword, final FetchLevel level, final String userId) throws SQLException {

		log.info("inside getReportList");

		final String reportGroup = getReportPath(parent);
		int catId = parent.getCatId();

		String sqlrole = "select role_id from roy_reports.report_users where user_id=?";

		int roleId = jdbcTemplateQueryForInt(sqlrole, new Object[] { new String(userId) });

		if (roleId == 0)
			return null;

		String sql = "";
		Object[] fillers;
		if (roleId == 1) {

			sql = "select report_id,cat_id,report_name from roy_reports.report_list where cat_id =?";

			// if (reportFilter != null) {
			if (reportFilter != null && !reportFilter.equals("null")) {
				sql = sql + " and REGEXP_LIKE(report_name,?,'i')";
				fillers = new Object[] { new Integer(catId), new String(reportFilter) };
			} else {
				fillers = new Object[] { new Integer(catId) };
			}

		} else {
			sql = "select report_id,cat_id,report_name from roy_reports.report_list where cat_id =? AND report_id IN (select REPORT_ID from roy_reports.report_list_user_roles where role_id=? )";

			if (reportFilter != null) {
				sql = sql + " and REGEXP_LIKE(report_name,?,'i')";

				fillers = new Object[] { new Integer(catId), new Integer(roleId), new String(reportFilter) };
			} else {
				fillers = new Object[] { new Integer(catId), new Integer(roleId) };
			}

		}
		sql = sql + " order by report_name asc";

		Collection<Report> reports = this.jdbcTemplate.query(sql, fillers, new RowMapper() {
			@Override
			public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
				Report report = new Report();
				// report.setParent(parent);
				report.setParent(null);
				report.setFavorite(false); // TODO
				report.setReportId(rs.getInt("report_id"));
				report.setReportCatId(rs.getInt("cat_id"));
				report.setReportName(rs.getString("report_name"));
				report.setReportGroup(reportGroup);
				if (level != FetchLevel.REPORT && level != FetchLevel.GROUP) {
					report.getReportVersionsList()
							.addAll(getReportVersionList(rs.getInt("report_id"), searchKeyword, level));
				}
				return report;
			}
		});
		log.info("End of getReportList");
		return reports;

	}

	public Report getReport(int reportId, final String searchKeyword, final FetchLevel level) {
		try {
			log.info("Fetch level: " + level);
			Report report = (Report) this.jdbcTemplate.queryForObject(
					"select * from roy_reports.report_list where report_id = ?", new Object[] { new Integer(reportId) },
					new RowMapper() {
						@Override
						public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
							Report report = new Report();
							report.setFavorite(false); // TODO
							report.setReportId(rs.getInt("report_id"));
							report.setReportGroup(getFavRepPath(rs.getInt("cat_id")));
							report.setReportName(rs.getString("report_name"));
							report.setDescription(rs.getString("description"));
							report.setAccessRole(rs.getString("access_role"));
							if (level != FetchLevel.REPORT && level != FetchLevel.GROUP) {
								report.getReportVersionsList()
										.addAll(getReportVersionList(rs.getInt("report_id"), searchKeyword, level));
							}
							System.out.print("Search Result : " + report);

							return report;
						}
					});

			return report;
		} catch (Exception ex) {
			return null;
		}
	}

	public Collection<ReportVersion> getReportVersionList(int reportId, final String searchKeyword,
			final FetchLevel level) {

		log.info("Fetch Level: " + level + " Search keyword: " + searchKeyword);

		try {
			Collection<ReportVersion> reportVersions = this.jdbcTemplate.query(
					"select report_s_no, report_id, number_of_pages, TO_CHAR(create_date, 'yyyy-mm-dd hh24:mi:ss') AS create_date, pdf_file_location from roy_reports.report_version where report_id = ? order by create_date desc",
					new Object[] { new Integer(reportId) }, new RowMapper() {
						@Override
						public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
							ReportVersion reportVersion = new ReportVersion();
							reportVersion.setSno(rs.getInt("report_s_no"));
							reportVersion.setReportId(rs.getInt("report_id"));
							reportVersion.setNumberOfPages(rs.getInt("number_of_pages"));
							reportVersion.setCreateDate(rs.getString("create_date"));
							reportVersion.setPdfFileLocation(rs.getString("pdf_file_location"));
							if ((level == FetchLevel.PAGE) || (level == FetchLevel.REPSEARCH)) {
								reportVersion.getReportPages()
										.addAll(getReportPagesList(rs.getInt("report_s_no"), searchKeyword, level));
							}
							System.out.print("Search report version list : " + reportVersion + " ");

							return reportVersion;
						}
					});
			System.out.println("Report Version List 2 : " + reportVersions + " ");
			return reportVersions;
		} catch (Exception ex) {
			log.error("Exception: " + ex.getMessage());
			return null;
		}
	}

	public ReportVersion getReportVersion(final int sno, final FetchLevel level) {

		log.info("Requested report info sequence no: " + sno);
		ReportVersion reportVersion = (ReportVersion) this.jdbcTemplate.queryForObject(
				"select report_s_no, report_id, number_of_pages,TO_CHAR(create_date, 'yyyy-mm-dd hh24:mi:ss') AS create_date,pdf_file_location from roy_reports.report_version where report_s_no = ?",
				new Object[] { new Integer(sno) }, new RowMapper() {
					@Override
					public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
						ReportVersion reportVersion = new ReportVersion();
						reportVersion.setSno(rs.getInt("report_s_no"));
						reportVersion.setReportId(rs.getInt("report_id"));
						reportVersion.setNumberOfPages(getReportPageCount(sno));
						reportVersion.setCreateDate(rs.getString("create_date"));
						reportVersion.setPdfFileLocation(rs.getString("pdf_file_location"));
						if ((level == FetchLevel.PAGE) || (level == FetchLevel.REPSEARCH)) {
							reportVersion.getReportPages()
									.addAll(getReportPagesList(rs.getInt("report_s_no"), null, level));
						}
						return reportVersion;
					}
				});

		return reportVersion;

	}

	public Collection<ReportPage> getReportPagesList(long sno, String searchKeyword, final FetchLevel level) {
		PreparedStatementCreator psc = null;
		PreparedStatementSetter pss = null;
		log.info("report sequence no: " + sno + " searchkeword: " + searchKeyword + " fetch level: " + level);
		String sql = "select * from roy_reports.report_pages where report_s_no = ?";
		Object[] fillers;
		if (searchKeyword != null) {
			sql = sql + " and CONTAINS(page_data,?,1)>0";
			fillers = new Object[] { new Long(sno), searchKeyword };
			sql = sql + " order by page_no asc";

			final long fsno = sno;
			final String fSearchKeyword = searchKeyword;

			pss = new PreparedStatementSetter() {
				public void setValues(PreparedStatement ps) throws SQLException {

					ps.setLong(1, fsno);
					ps.setString(2, "'{" + fSearchKeyword + "'}");

				}
			};

		} else {
			sql = sql + " order by page_no asc";
			// fillers = new Object[] { new Long(sno) };

			final long fsno = sno;
			final String fSearchKeyword = searchKeyword;

			pss = new PreparedStatementSetter() {
				public void setValues(PreparedStatement ps) throws SQLException {

					ps.setLong(1, fsno);

				}
			};

		}

		Collection<ReportPage> reportPages = this.jdbcTemplate.query(sql, pss, new RowMapper() {
			@Override
			public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

				ReportPage reportPage = new ReportPage();
				reportPage.setSno(rs.getInt("report_s_no"));
				reportPage.setPageNumber(rs.getInt("page_no"));
				reportPage.setReportId(rs.getInt("report_id"));

				Clob pageData = rs.getClob("page_data");
				if (level != FetchLevel.REPSEARCH) {
					int length = (int) pageData.length();
					reportPage.setPageData(pageData.getSubString((long) 1, length));
				}
				return reportPage;
			}
		});

		return reportPages;
	}

	@SuppressWarnings("unchecked")
	public ReportPage getReportPage(int sno, int page_no) {

		log.info(" Report Sno: " + sno + " page no: " + page_no);

		ReportPage reportPage = this.jdbcTemplate.queryForObject(
				"select * from roy_reports.report_pages where report_s_no = ? and page_no = ?",
				new Object[] { new Integer(sno), new Integer(page_no) }, new RowMapper<ReportPage>() {
					@Override
					public ReportPage mapRow(ResultSet rs, int rowNum) throws SQLException {
						ReportPage reportPage = new ReportPage();
						reportPage.setSno(rs.getInt("report_s_no"));
						reportPage.setPageNumber(rs.getInt("page_no"));
						reportPage.setReportId(rs.getInt("report_id"));

						Clob pageData = rs.getClob("page_data");
						int length = (int) pageData.length();
						reportPage.setPageData(pageData.getSubString((long) 1, length));

						return reportPage;
					}
				});

		return reportPage;
	}

	public int getReportPageCount(int sno) {
		return this.jdbcTemplate.queryForObject(
				"select count(*) from 	 roy_reports.report_pages where report_s_no = ?", new Object[] { sno },
				Integer.class);

	}

	public int getReportTreeMaxLevels() throws Exception {
		return this.jdbcTemplate.queryForObject("select max(node_level) from  roy_reports.report_cat_tree",
				Integer.class);

	}

	public ReportTreeNode getGroupList(final String reportFilter, final String searchKeyword, final FetchLevel level,
			HttpServletRequest req) throws Exception {

		String ssoUserID = getUserIdFromReq(req);
		int maxNodeLevels = getReportTreeMaxLevels();
		ReportTreeNode rootNode = new ReportTreeNode();
		rootNode.setParent(null);
		rootNode.setName("reports");
		String path = "";
		int startLevel = 1;

		getReportTreeNode(rootNode, startLevel, path, maxNodeLevels, reportFilter, searchKeyword, level, ssoUserID);

		return rootNode;

	}

	public ReportTreeNode getReportTreeNode(ReportTreeNode parent, final int level, final String path,
			final int maxLevel, final String reportFilter, final String searchKeyword, final FetchLevel flevel,
			final String userId) throws SQLException {

		final ReportTreeNode tmpParent = parent;
		if (flevel != FetchLevel.GROUP) {
			log.info("grouplist");

			Collection<Report> repList = getReportList(parent, reportFilter, searchKeyword, flevel, userId);
			if (repList != null)
				parent.getReportList().addAll(repList);
		}

		if (level > maxLevel)
			return null;
		log.info("path" + path);
		String lookPath = path + "%/";
		log.info("lookPath" + lookPath);
		Collection<ReportTreeNode> childNodes = this.jdbcTemplate.query(
				"select cat_id,name,path from roy_reports.report_cat_tree where node_level = ? and path like  ?",
				new Object[] { new Integer(level), new String(lookPath) }, new RowMapper() {
					@Override
					public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
						ReportTreeNode childNode = new ReportTreeNode();
						// childNode.setParent(tmpParent);
						childNode.setParent(null);
						childNode.setCatId(rs.getInt("cat_id"));
						childNode.setName(rs.getString("name"));
						childNode.setPath(rs.getString("path"));
						int nextLevel = level + 1;
						getReportTreeNode(childNode, nextLevel, rs.getString("path"), maxLevel, reportFilter,
								searchKeyword, flevel, userId);

						return childNode;
					}
				});

		/*
		 * for (ReportTreeNode cn : childNodes) { cn.setParent(parent); }
		 */

		List aColl = (List) childNodes;
		parent.setChildren(aColl);

		return parent;
	}

	public static void main(String[] args) {

		RoyaltyReportsDAO rrDao = new RoyaltyReportsDAO();
		DriverManagerDataSource ds = new DriverManagerDataSource();
		ds.setDriverClassName("oracle.jdbc.driver.OracleDriver");
		/*
		 * ds.setUrl("jdbc:oracle:thin:@192.168.14.196:1521:diafeed1");
		 * ds.setUsername("raspoc"); ds.setPassword("raspoc");
		 */
		/*
		 * ds.setUrl("jdbc:oracle:thin:@//10.16.110.28:1521/RASUAT");
		 * ds.setUsername("roy_reports"); ds.setPassword("roy_reports");
		 */

		ds.setUrl("jdbc:oracle:thin:@//10.16.106.37:1521/RASDEV");
		ds.setUsername("roy_reports");
		ds.setPassword("roy_reports");

		log.info("ds " + ds);
		rrDao.setDataSource(ds);
		log.info("rrDAo " + rrDao);

	}

	private String getReportPath(ReportTreeNode treeNode) {

		if ((treeNode == null))
			return "";
		return (getReportPath(treeNode.getParent()) + ">" + treeNode.getName());

	}

	private int jdbcTemplateQueryForInt(String sql, Object[] args) {

		try {

			return this.jdbcTemplate.queryForObject(sql, args, Integer.class);
		} catch (Exception IncorrectResultSizeDataAccessException) {

			log.error("Exception while retriving int value from DB: "
					+ IncorrectResultSizeDataAccessException.getMessage());
			return 0;
		}

	}

	public AllReportSearch getAllRepSearchResults(final int istartIndex, final int iendIndex, String searchKeyword,
			HttpServletRequest req) {

		try {
			int resultSetCount = 100;
			int startIndex = istartIndex;
			int endIndex = iendIndex;

			if (searchKeyword == null || searchKeyword.isEmpty()) {

				return null;

			}

			String ssoUserID = getUserIdFromReq(req);

			String sqlrole = "select role_id from roy_reports.report_users where user_id=?";
			int roleId = this.jdbcTemplateQueryForInt(sqlrole, new Object[] { new String(ssoUserID) });

			if (roleId == 0)
				return null;

			if (startIndex > endIndex)
				return null;

			if (startIndex == 0 && endIndex == 0) {
				endIndex = resultSetCount;
			}

			String innersql = "";
			String sql = "";
			PreparedStatementSetter pss = null;
			PreparedStatementCreator psc = null;
			Object[] fillers;
			AllReportSearch allRepSearch = new AllReportSearch();

			final int fStartIndex = startIndex;
			final int fEndIndex = endIndex;
			final String fSearchKeyword = searchKeyword;
			final int froleId = roleId;
			if (froleId == 1) {

				innersql = "select rp.report_id,"
						+ "(SELECT rv.NUMBER_OF_PAGES from roy_reports.REPORT_VERSION rv where rv.REPORT_S_NO=rp.report_s_no) NUM_OF_PAGES,(SELECT rvt.create_date from roy_reports.REPORT_VERSION rvt where rvt.REPORT_S_NO=rp.report_s_no) CRE_DATE,(SELECT SYS_CONNECT_BY_PATH(rct.name, '>') FROM roy_reports.report_cat_tree rct  where rct.cat_id IN (select cat_id from roy_reports.report_list rl where (rl.report_id=rp.report_id)) start with parent_id is null CONNECT BY PRIOR cat_id = parent_id) path,rp.report_s_no, COUNT(DISTINCT rp.page_no) occurances from roy_reports.report_pages rp where CONTAINS(rp.page_data,?,1)>0 group by rp.report_id,rp.report_s_no";

				sql = "select * from (SELECT  tmp.*, rownum as row_no FROM (" + innersql
						+ ") tmp ) where row_no between ? AND ?";

				pss = new PreparedStatementSetter() {
					public void setValues(PreparedStatement ps) throws SQLException {
						ps.setString(1, "'{" + fSearchKeyword + "}'");
						ps.setInt(2, fStartIndex);
						ps.setInt(3, fEndIndex);

					}
				};

			} else {
				innersql = "select rp.report_id,(SELECT rv.NUMBER_OF_PAGES from roy_reports.REPORT_VERSION rv where rv.REPORT_S_NO=rp.report_s_no) NUM_OF_PAGES,(SELECT rvt.create_date from roy_reports.REPORT_VERSION rvt where rvt.REPORT_S_NO=rp.report_s_no) CRE_DATE,(SELECT SYS_CONNECT_BY_PATH(rct.name, '>') FROM roy_reports.report_cat_tree rct  where rct.cat_id IN (select cat_id from roy_reports.report_list rl where (rl.report_id=rp.report_id)) start with parent_id is null CONNECT BY PRIOR cat_id = parent_id) path,rp.report_s_no, COUNT(DISTINCT rp.page_no) occurances from roy_reports.report_pages rp where CONTAINS(rp.page_data,?,1)>0 AND rp.report_id IN (select REPORT_ID from roy_reports.report_list_user_roles where role_id=? ) group by rp.report_id,rp.report_s_no";
				sql = "select * from (SELECT  tmp.*, rownum as row_no FROM (" + innersql
						+ ") tmp ) where row_no between ? AND ?";

				pss = new PreparedStatementSetter() {
					public void setValues(PreparedStatement ps) throws SQLException {
						ps.setString(1, "'{" + fSearchKeyword + "'}");
						ps.setInt(2, froleId);
						ps.setInt(3, fStartIndex);
						ps.setInt(4, fEndIndex);

					}
				};
			}

			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			Collection<RepSearchRes> searchResults = this.jdbcTemplate.query(sql, pss, new RowMapper() {
				@Override
				public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
					RepSearchRes rsr = new RepSearchRes();
					rsr.setReportId(rs.getInt("report_id"));
					rsr.setReportPath(rs.getString("path"));
					rsr.setReportSNo(rs.getString("report_s_no"));
					rsr.setTotalPagesInReport(rs.getInt("NUM_OF_PAGES"));
					rsr.setNoOfOccurancesInReport(rs.getInt("occurances"));
					rsr.setCreateDate(rs.getDate(("CRE_DATE")));
					System.out.print("RepSearchRes ...!!!");

					return rsr;
				}
			});

			if (searchResults != null) {

				allRepSearch.setSearchResList(searchResults);

				if (resultSetCount > searchResults.size()) {
					allRepSearch.setMoreResults(false);
					allRepSearch.setNextResListStartIndex(0);
					allRepSearch.setNextResListEndIndex(0);

				} else {
					allRepSearch.setMoreResults(true);
					allRepSearch.setNextResListStartIndex(endIndex + 1);
					allRepSearch.setNextResListEndIndex(endIndex + resultSetCount);
				}
			}

			return allRepSearch;

		} catch (Exception ex) {
			log.error("Exception in search: " + ex.getMessage());
			return null;
		}

	}

	private String getUserIdFromReq(HttpServletRequest req) {

		HttpSession session = req.getSession();

		String ssoUserID = (String) session.getAttribute("USER_KEY");

		if (ssoUserID != null) {
			ssoUserID = ssoUserID.toLowerCase().trim();
		} else {
			ssoUserID = "test"; // TODO
		}

		return ssoUserID;
	}

	private void printReportTreeNode(ReportTreeNode rtn, int indent) {

		List<ReportTreeNode> rtlist = rtn.getChildren();
		List<Report> repList = rtn.getReportList();

		if (repList.size() > 0) {

			for (Report rep : repList) {

				for (int i = 0; i < indent; i++)
					System.out.print("\t");
				System.out.println(rep.getReportName());
			}
		}

		for (int i = 0; i < indent; i++)
			System.out.print("\t");

		System.out.println(rtn.getName());

		if (rtlist == null)
			return;

		if (rtlist.size() <= 0)
			return;
		int nextIndent = indent + 1;
		for (ReportTreeNode rt : rtlist) {
			printReportTreeNode(rt, nextIndent);
		}

	}

	public String escapeSQLString(String inputStr) {

		String out = "";

		return out;
	}

	public boolean validateUser(String user, HttpServletRequest request) throws SQLException {

		System.out.println("Inside validateUser validate");

		log.error("Inside validateUser validate");

		System.out.println("user:::" + user);

		log.error("user:::" + user);
		String sql = "SELECT count(USER_ID) FROM roy_reports.REPORT_USERS where USER_ID =?";
		int test1 = 5;

		test1 = this.jdbcTemplateQueryForInt(sql, new Object[] { new String(user) });
		System.out.println("test1::::::" + test1);

		log.error("test1::::::" + test1);

		if (test1 > 0) {
			sql = "SELECT USER_ID, FIRST_NAME, LAST_NAME FROM roy_reports.REPORT_USERS where USER_ID =?";
			Collection<HeaderInfo> headerInfo = this.jdbcTemplateQueryForString(sql, user);
			for (Iterator iterator = headerInfo.iterator(); iterator.hasNext();) {
				HeaderInfo headerInfoItera = (HeaderInfo) iterator.next();
				System.out.println(headerInfoItera.getUserFirstName());
				System.out.println(headerInfoItera.getUserLastName());

				HttpSession session = request.getSession(true);
				session.setAttribute("CT_REMOTE_USER", user);
				session.setAttribute("givenName", headerInfoItera.getUserFirstName());
				session.setAttribute("sn", headerInfoItera.getUserLastName());
			}

			return true;
		} else {
			return false;
		}

	}

	private Collection<HeaderInfo> jdbcTemplateQueryForString(String sql, String userName) {
		try {

			Collection<HeaderInfo> headerInfo = this.jdbcTemplate.query(sql, new Object[] { new String(userName) },
					new RowMapper() {
						@Override
						public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
							HeaderInfo headerInfo = new HeaderInfo();
							headerInfo.setUserFirstName(rs.getString("FIRST_NAME")); // TODO
							headerInfo.setUserLastName(rs.getString("LAST_NAME"));
							headerInfo.setUserId(rs.getString("USER_ID"));
							return headerInfo;
						}
					});

			return headerInfo;
		} catch (Exception IncorrectResultSizeDataAccessException) {

			log.error("Exception while retriving int value from DB: "
					+ IncorrectResultSizeDataAccessException.getMessage());
			return null;
		}
	}

}
