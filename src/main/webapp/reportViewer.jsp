<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title>Report Viewer</title>

<link type="text/css"
	href="css/ui-lightness/jquery-ui-1.8.18.custom.css" rel="stylesheet" />
<script type="text/javascript" src="scripts/jquery-1.7.2.min.js"></script>
<script type="text/javascript"
	src="scripts/jquery-ui-1.8.18.custom.min.js"></script>
<script type="text/javascript" src="scripts/jquery.highlight.js"></script>
<script type="text/javascript" src="scripts/jquery.printElement.js"></script>

<style>
body {
	font-family: Arial;
	font-size: 12px;
}

buttonStyle {
	height: 19px;
}

#loading {
	background: pink;
	position: absolute;
	align: center;
	top: 0px;
	width: 80px;
	left: 900px;
	padding: 2px;
	z-index: 2;
}

#reportViewerContainer {
	height: 100%;
	width: 100%;
	margin-top: 0.5em;
	margin-left: auto;
	margin-right: auto;
}

#extPad {
	padding: 0.5em;
	padding-bottom: 0em;
}

#reportViewer {
	width: 100%;
	height: 100%;
	position: center;
	left: 5px;
	right: 5px;
	background-color: white;
	background-image: url("/royaltyreports/images/mid_bar.png");
}

#page {
	background: #ffffff;
	border: 10px solid grey;
	min-height: 500px;
	max-height: 500px;
	width: 97%;
	padding: 5px;
	float: left;
	height: 500px;
	overflow: scroll;
}

#searchSidebar {
	width: 22%;
	height: 100%;
	max-height: 528px;
	min-height: 528px;
	padding: 0em;
	margins: 2px;
	float: right;
	background-image: url("/royaltyreports/images/said_bar3.png");
}

#searchSidebar h3 {
	text-align: center;
	margin: 0;
	font-size: 16px;
}

#scrollingWrap {
	overflow: auto;
	height: 500px;
}

#printableContentContainer {
	height: 10%;
	width: 100%;
}

#printOptionsToolbar {
	padding: 10px 4px;
}

#printableContentData {
	background: none repeat scroll 0 0 #FFFFFF;
	border: 20px solid grey;
	float: left;
	height: 100%;
	overflow: scroll;
	padding: 10px;
	width: 93%;
}

.alt {
	background: #c3c9eb;
}

table {
	width: 100%;
	border-top: 1px solid #939393;
	border-bottom: 1px solid #939393;
	border-collapse: collapse;
}

th {
	height: 30px;
	padding-left: 10px;
	text-align: left;
	border-bottom: 2px solid #939393;
}

td {
	padding-left: 10px;
	height: 30px;
}

.highlight {
	background-color: #ffff38;
}

#toolbar {
	height: 100%;
	width: 99%;
	margin-left: auto;
	margin-right: auto;
	padding: 5px 5px;
	height: 25px;
	border: 0px;
	display: inline-block;
}
</style>

<script type='text/javascript'>
function errh(msg, exc) {
	 $("#loading").hide();
	//  alert("An error has occured. Error message is: " + msg + " - Error Details: " + dwr.util.toDescriptiveString(exc, 2));
        alert("An error has occured. Error message is: " + msg);
}

var showOrHide = false;
var showSearch = window.opener.g_rasprop.showSearchInPopup;

var reportSearchInputVal = window.opener.g_rasprop.reportSearchInputVal;

//alert('showSearch: ' + showSearch + 'reportSearchInputVal: ' + reportSearchInputVal);

$(function() {
	
	//dwr.engine.setErrorHandler(errh);	
	$("#loading").hide();
	$("#printableContentData").hide();
	$("#reportPrintSelDialog").dialog({
		autoOpen : false,
		modal : true,
		height : 184,
		width : 800,
		minWidth : 800,
		resizable: false,
		maxHeight: 184
	});
	
	$("#seekfirst").button({
		text : false,
		icons : {
			primary : "ui-icon-seek-first"
		}
	}).click(function() {
		loadFirstPage();
	});
	$("#back").button({
		text : false,
		icons : {
			primary : "ui-icon-triangle-1-w"
		}
	}).click(function() {
		loadPreviousPage();
	});
	$("#forward").button({
		text : false,
		icons : {
			primary : "ui-icon-triangle-1-e"
		}
	}).click(function() {
		loadNextPage();
	});
	$("#seeklast").button({
		text : false,
		icons : {
			primary : "ui-icon-seek-end"
		}
	}).click(function() {
		loadLastPage();
	});
	$("#searchSidebar").hide();
	$("#search").button({
		text : true,
		icons : {
			primary : "ui-icon-circle-zoomin"
		}
	}).click(function() {

		if (showOrHide == true) {
			$("#searchSidebar").hide();
			showOrHide = false;
			$("#page").css('width', '97%');
			$("#search").button("option", "label", "Search");
			//$("#searchButtonDiv").css('padding-left','650px');
		} else {
			$("#searchSidebar").show();
			showOrHide = true;
			$("#page").css('width', '74%');
			$("#search").button("option", "label", "Hide Search");
			//$("#searchButtonDiv").css('padding-left','610px');
		}

	});
	$("#pageNumber").keydown(
			function(event) {
				if (event.keyCode == '13') {
					event.preventDefault();
					if (isNaN(parseInt($("#pageNumber").val()))
							|| loadPage(parseInt($("#pageNumber").val())) == false) {
						alert("Invalid page number");
						$("#pageNumber").val(currentPage);
					}
				}
			});

	$("#viewerSearch")
			.keydown(
					function(event) {
						if (event.keyCode == '13') {
							if ($.trim($("#viewerSearch").val()) != "") {
								viewerSearchInputVal = $("#viewerSearch").val();
								$("#loading").show();
								/*ReportsDAO.getReportPagesList(
												reportPages[0].sno,
												viewerSearchInputVal,
												"REPORT",
												{
													callback : populateViewerResults
												});*/
															  var urlValue = 'getReportPagesList.do';    
								$.ajax({
									type: 'GET',
									dataType: 'text',
	    							 Accept: "*/*",
									 'Content-Type': "application/json",
									  url : urlValue,				
									
									data: {
										sno:reportPages[0].sno,
										searchKeyword:viewerSearchInputVal,
										level: "REPORT",
						             },
											
						             success: function (response) {
						                	 response=JSON.parse(response);
						              	  	 populateViewerResults(response);
						  			 },
						  			
						            error : function(error) {
						  				console.log("ERROR: ", error);
					    			}
						  	   });
																		
							}
						}
					});

	$("#viewerSearch").change(function(event) {
		//$("#searchResults").html("");
		if ($.trim($("#viewerSearch").val()) == "") {
			$("#searchResults").html("");
			$("#viewerSearch").val("");
			$("#page").unhighlight();
		}
		$("#page").unhighlight();
	});

	$("#viewerSearchClear").button({
		text : false,
		icons : {
			primary : "ui-icon-circle-close"
		}
	}).click(function() {
		$("#searchResults").html("");
		$("#viewerSearch").val("");
		$("#page").unhighlight();
	});
	
	
	getReportVersion(<c:out value="${reportSno}"/>);
});


function getReportVersion(sno) {	

	/*
ReportsDAO.getReportVersion(sno, "VERSION", {
		callback : showReportVersion
	});*/
	
		  var urlValue = 'reportVersion.do';    
	
	$.ajax({
			type : 'GET',
			dataType : 'text',
			Accept : "*/*",
			'Content-Type' : "application/json",
			url : urlValue,

			data : {
				sno : sno,
				level : "VERSION",
			},

			success : function(response) {
				response = JSON.parse(response);
				showReportVersion(response);
			},

			error : function(error) {
				console.log("ERROR: ", error);
			},
			done : function() {
				console.log("DONE");
			}

		});
	}

	function printReport(numPages, repSno) {

		// Print handler
		$("#print").button({
			text : true,
			icons : {
				primary : "ui-icon-print"
			}
		}).click(
				function() {

					var startPageNo = $("#pageslider").slider("values", 0);
					var endPageNo = $("#pageslider").slider("values", 1);

					//pdfLoc = reportVersion.pdfFileLocation;	

					var pdfRootPrintPath = "<%=request.getContextPath()%>" + "/files/pdfprintingfile.do?fileloc="; 
	
	// var printFileLoc = pdfRootPrintPath +"&startPage="+startPageNo+"&endPage="+endPageNo;
	   var printFileLoc = pdfRootPrintPath + pdfLoc +"&startPage="+startPageNo+"&endPage="+endPageNo;
	$('#printframe').attr('src', printFileLoc);	
	 $.browser.chrome�=�/chrom(e|ium)/.test(navigator.userAgent.toLowerCase());�

		if($.browser.chrome){
			$('#printframe').css({
				'position' : 'absolute',
				'width' : '100%',
				'height' : '100%',
				'top' : '0',
				'display' :'block',
				'z-index' : '9999'
			})
			$('#printframe').load(printFileLoc);
		} 
		
}
	);
	
	
	totalPagesHtml = "<p> Total Number of Pages in the report:"+ numPages +" </p>";
	$("#totalPages").html(totalPagesHtml);
	//alert("report no of pages:" + numPages + " rep serial no: " + repSno);
	var startPage = 1;
	
	var defEndPage;
	
	if(numPages > 10)
		defEndPage = 10;
	else
		defEndPage = numPages;
		
	
	$('#printableContentData').hide();
	
	var rangeInLowSel = $( "#printRangeInputLow" );
	var rangeInHighSel = $( "#printRangeInputHigh" );
	
	rangeInLowSel.val(startPage);
	rangeInHighSel.val(defEndPage);
	
	
	// Event handlers for text input boxes
	rangeInLowSel.change(function() {
		
		if(rangeInLowSel.val() > rangeInHighSel.val())
			rangeInHighSel.val(rangeInLowSel.val());
		
		$( "#pageslider" ).slider( "values" , 0 , rangeInLowSel.val() );
		$( "#pageslider" ).slider( "values" , 1 , rangeInHighSel.val() );
	});
	
	rangeInHighSel.change(function() {
		
		if(rangeInHighSel.val() < rangeInLowSel.val())
			rangeInLowSel.val(rangeInHighSel.val());
		
		$( "#pageslider" ).slider( "values" , 0 , rangeInLowSel.val() );
		$( "#pageslider" ).slider( "values" , 1 , rangeInHighSel.val() );
	});
	
	$( "#pageslider" ).slider({
		range: true,
		min: startPage,
		max: numPages,
		values: [ rangeInLowSel.val(), rangeInHighSel.val() ],
		slide: function( event, ui ) {						
			html = "<p>Slected range from: " + ui.values[0] + " To: " + ui.values[1] + "</p>";
			
			rangeInLowSel.val(ui.values[0]);
			rangeInHighSel.val(ui.values[1]);
			$("#selectedPageRange").html(html);
		}
	});			
	
	$("#reportPrintSelDialog").dialog("open");
	
}

var currentPage;
var reportPages;
var reportVersionSNO;

function renderPDFDownloadButton(pdfLoc){	
	
	var pdfRootPath = "<%=request.getContextPath()%>"
				+ "/files/pdffile.do?fileloc=";
		//	alert("pdf rooth path"+ pdfRootPath);
		//alert("loc"+pdfLoc);

		$("#pdfDownload").attr('href', pdfRootPath + pdfLoc);

	}

	function loadViewer(pages, rSNo) {
		$("#numberOfPages").html(pages.length);

		// Print handler
		$("#printReport").button({
			icons : {
				primary : "ui-icon-print"
			}

		}).click(function() {
			printReport(pages.length, rSNo);
		});

		reportPages = pages;
		//$("#page").html(pages[0].pageData);
		loadPage(1, false);
	}

	function loadPage(pageNumber, highlight) {
		if (pageNumber >= 1 && pageNumber <= reportPages.length) {
			$("#pageNumber").val(pageNumber);
			//fetch the page
			currentPage = pageNumber;
			if (reportPages[pageNumber - 1] == undefined) {
				$("#loading").show();

				/*	
					ReportsDAO.getReportPage(reportVersionSNO, pageNumber, {
						callback : function(page) {
							reportPages[pageNumber - 1] = page;
							$("#page").html(reportPages[pageNumber - 1].pageData);
							if (highlight == true) {
								$("#page").highlight($("#viewerSearch").val());
							}
							$("#loading").hide();
						}
					});*/

				var urlValue = 'reportPage.do';
				$.ajax({
					type : 'GET',
					dataType : 'text',
					Accept : "*/*",
					'Content-Type' : "application/json",
					url : urlValue,

					data : {
						sno : reportVersionSNO,
						page_no : pageNumber,
					},
					success : function(page) {
						page = JSON.parse(page);
						reportPages[pageNumber - 1] = page;
						$("#page").html(reportPages[pageNumber - 1].pageData);
						if (highlight == true) {
							$("#page").highlight($("#viewerSearch").val());
						}
						$("#loading").hide();

					},

					error : function(error) {
						console.log("ERROR: ", error);
					}

				});
			} else {
				$("#page").html(reportPages[pageNumber - 1].pageData);
				if (highlight == true) {
					$("#page").highlight($("#viewerSearch").val());
				}
			}

			return true;
		} else {
			return false;
		}
	}

	function loadLastPage() {
		//$("#pageNumber").val(reportPages.length);
		//$("#page").html(reportPages[reportPages.length-1].pageData);
		//currentPage = reportPages.length;
		loadPage(reportPages.length, false);

	}

	function loadFirstPage() {
		//$("#pageNumber").val("1");
		//$("#page").html(reportPages[0].pageData);
		//currentPage = 1;
		loadPage(1, false);
	}

	function loadNextPage() {
		if (currentPage != reportPages.length) {
			currentPage++;
			//$("#pageNumber").val(currentPage);
			//$("#page").html(reportPages[currentPage-1].pageData);
			loadPage(currentPage);
		}
	}

	function loadPreviousPage() {
		if (currentPage != 1) {
			currentPage--;
			//$("#pageNumber").val(currentPage);
			//$("#page").html(reportPages[currentPage-1].pageData);
			loadPage(currentPage, false);
		}
	}

	function populateViewerResults(reportPages) {
		var html = "";
		$("#page").unhighlight();
		html = html + "<tr><th>Search Results: " + viewerSearchInputVal
				+ "</th></tr>";
		$.each(reportPages, function(index, reportPage) {
			if (index == 0) {
				loadPage(reportPage.pageNumber, true);
			}
			html = html + "<tr><td><a href='#' onclick='loadPage("
					+ reportPage.pageNumber + ",true)'>Page "
					+ reportPage.pageNumber + "</a></td></tr>";
		});

		$("#searchResults").html(html);

		$("#searchResults tr:odd").addClass("alt");

		$("#page").highlight(viewerSearchInputVal);

		$("#loading").hide();

	}

	function showReportVersion(reportVersion) {

		reportPages = new Array(reportVersion.numberOfPages);
		reportVersionSNO = reportVersion.sno;
		pdfLoc = reportVersion.pdfFileLocation;
		//load the first page
		loadViewer(reportPages, reportVersionSNO);
		//alert(reportVersionSNO);
		renderPDFDownloadButton(reportVersion.pdfFileLocation);
		var version = reportVersion.createDate;

		//get the report title and show the dialog

		/*ReportsDAO.getReport(reportVersion.reportId, null, "REPORT", {
			callback : function(report) {
				window.title = "Report Viewer: " + report.reportGroup + " > "
						+ report.reportName + " > " + version;

				if (showSearch == true) {
					viewerSearchInputVal = reportSearchInputVal;
					$("#viewerSearch").val(reportSearchInputVal);

					ReportsDAO.getReportPagesList(reportVersionSNO, $(
							"#viewerSearch").val(), "REPORT", {
						callback : populateViewerResults
					});
					
				});*/
				
				if (showSearch == true) {
					viewerSearchInputVal = reportSearchInputVal;
					$("#viewerSearch").val(reportSearchInputVal);
				}
		var urlValue = 'report.do';
		$.ajax({
			type : 'GET',
			dataType : 'text',
			Accept : "*/*",
			'Content-Type' : "application/json",
			url : urlValue,

			data : {
				reportId : reportVersion.reportId,
				searchKeyword : null,
				level : "REPORT",
			},

			success : function(report) {
				report = JSON.parse(report);
				console.log(report);
				var version = reportVersion.createDate;
				window.title = "Report Viewer: " + report.reportGroup + " > "
						+ report.reportName + " > " + version;
				/* if (showSearch == true) {
					viewerSearchInputVal = report.reportSearchInputVal;
					$("#viewerSearch").val(reportSearchInputVal); */
            
					//make an ajax call for ReportSDAO.getReportPagesList
					
					urlValue = 'getReportPagesList.do';
					$.ajax({
						type : 'GET',
						dataType : "text",

						url : urlValue,

						data : {
							sno : reportVersionSNO,
							searchKeyword : $("#viewerSearch").val(),
							level : "REPORT",
						},

						success : function(response) {
							response = JSON.parse(response)
							populateViewerResults(response);
						},

						error : function(error) {
							console.log("ERROR: ", error);
						}
					});
				//}
			}
		/*  error : function(error) {
				console.log("ERROR: ", error);
							    			} */

		});

		if (!showOrHide) {
			$("#search").click();
		}
		//}
		else {
			$("#viewerSearch").val("");
			$("#searchResults").html("");
			if (showOrHide) {
				$("#search").click();
			}
		}

		showSearch = false;

	}
	//});

	//}
</script>
<!-- For Google Analytics tracking -->
<script type="text/javascript">
	var _gaq = _gaq || [];
	_gaq.push([ '_setAccount', 'UA-37389574-1' ]);
	_gaq.push([ '_trackPageview' ]);

	(function() {
		var ga = document.createElement('script');
		ga.type = 'text/javascript';
		ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl'
				: 'http://www')
				+ '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0];
		s.parentNode.insertBefore(ga, s);
	})();
</script>

</head>
<body>

	<div id="reportViewer">
		<div id="toolbar" class="ui-widget-header ui-corner-all">
			<div style="padding-bottom: 2px; float: left">
				<button style="height: 23px; border: 0px; padding: 0px;"
					id="seekfirst">First Page</button>
				<button style="height: 23px; border: 0px; padding: 0px;" id="back">Previous
					Page</button>
				&nbsp; Page <input type="text" id="pageNumber"
					style="padding-bottom: 2px; text-align: center; line-height: 18px; width: 25px; height: 18px;" />
				of <span id="numberOfPages"></span> &nbsp;&nbsp;
				<button style="height: 23px; border: 0px; padding: 0px;"
					id="forward">Next Page</button>
				<button style="height: 23px; border: 0px; padding: 0px;"
					id="seeklast">Last Page</button>

				&nbsp;&nbsp;
				<button style="height: 23px; border: 0px; padding: 0px;"
					id="printReport">Print</button>
				&nbsp;&nbsp; <a href="#"
					style="height: 23px; border: 0px; padding: 0px;" id="pdfDownload">Download
					As PDF</a>

			</div>
			<div style="float: right; position: relative; display: block;">
				<button style="height: 23px; border: 0px; padding: 0px;" id="search">Search</button>
			</div>
			<div style="clear: both;">leave empty</div>
		</div>
		<div id="loading">Loading ...</div>
		<div id="reportViewerContainer">
			<div id="page"></div>
			<div id="searchSidebar" class="ui-widget-content">
				<div id="extPad">
					<h3 class="ui-widget-header">Search</h3>
				</div>
				<center style="margin: 2px;">
					<input id="viewerSearch" type="text"
						style="width: 150px; height: 23px;" />
					<button style="height: 29px;" id="viewerSearchClear">Clear</button>
				</center>
				<div id="scrollingWrap">
					<table id="searchResults">

					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="reportPrintSelDialog" title="Report Print Selection">

		<div id="printOptionsToolbar">
			<div id="totalPages"></div>

			<div id="pageslider"></div>
			<br />
			<div id="rangeInput">
				From: <input id="printRangeInputLow" type="text" size="10" />
				&nbsp; To: <input id="printRangeInputHigh" type="text" size="10" />
			</div>

			<div id="selectedPageRange"></div>

			<button style="margin-top: 5px;" id="print">Print</button>

		</div>
		<div id="printableContentContainer">
			<div id="printableContentData"></div>

		</div>
	</div>
	<iframe id="printframe" height="0" width="0" style="display: inline"></iframe>
</body>
</html>