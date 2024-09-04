<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<%
//Do this check for the jsp's which are accessible after login authentication

if (session.getAttribute("USER_KEY") == null) {
	System.out.println("USER KEY is null,redirecting to Login Page");
	response.sendRedirect("login.jsp");
	return;

}
%>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=8">
<title>Savvas: Royalty Reports</title>
<link type="text/css"
	href="css/ui-lightness/jquery-ui-1.8.18.custom.css" rel="stylesheet" />
<link type="text/css" href="css/jquery.treeview.css" rel="stylesheet" />
<link id="homeScreenCSS" type="text/css" href="css/home.screen.css"
	rel="stylesheet" />
<!-- <link id="homeIE7CSS" type="text/css" href="" rel="stylesheet" /> -->
<link type="text/css" href="css/jqueryuicsschanges.css" rel="stylesheet" />
<script type="text/javascript" src="scripts/jquery-1.7.2.min.js"></script>

<script type="text/javascript"
	src="scripts/jquery-ui-1.8.18.custom.min.js"></script>
<script type="text/javascript" src="scripts/jquery.printElement.js"></script>
<script type="text/javascript" src="scripts/jquery.numeric.js"></script>
<script type="text/javascript" src="scripts/jquery.treeview.async.js"></script>
<script type="text/javascript" src="scripts/jquery.treeview.js"></script>
<script type="text/javascript" src="scripts/jquery.treeview.sortable.js"></script>
<script type="text/javascript" src="scripts/jquery.highlight.js"></script>
<!-- For Google Analytics tracking -->
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-37389574-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

  function disableBackButton()
  {
    window.history.forward()
  }  
  disableBackButton();  
  window.onload=disableBackButton();  
  window.onpageshow=function(evt) { if(evt.persisted) disableBackButton() }  
  window.onunload=function() { void(0) } 

  </script>
</head>
<body onload="javascript:disableBackButton();">
	<script>
	function adjustStyle(width) {
	    width = parseInt(width);
	    if (width < 1300) {
	        $("#homeScreenCSS").attr("href", "css/home.screen.1024.css");
	    } else {	    
	    } 	    
	    if($.browser.msie && parseInt($.browser.version, 10) == 7) {	       
	    	 $("#homeIE7CSS").attr("href", "css/home.ie7.css");	    		    	
	    }  	
	}
	var g_rasprop = {	
		openWins: new Array(),	
		showOrHideSearch: false,	
		showSearchInPopup: false,	
		currentReportId: null,
		currentReportPath:null,
		viewerSearchInputVal: null,
		reportSearchInputVal: null,
		moreSearchResId:null
	};
	
	//Track open adds the new child window handle to the array.
	function trackOpen(winHan) {		
		g_rasprop.openWins[g_rasprop.openWins.length]=winHan;
	}
	
	function closeWindows() {
	    var openCount = g_rasprop.openWins.length;
	    for(var r=0;r<openCount;r++) {
	    	g_rasprop.openWins[r].close();
	    }
	}


	function errh(msg, exc) {
		 $("#loading").hide();
		 // alert("An error has occured. Error message is: " + msg + " - Error Details: " + dwr.util.toDescriptiveString(exc, 2));
		 alert("An error has occured. Error message is: " + msg);
	}
		
	$(function() {
		
		adjustStyle($(this).width());
		//dwr.engine.setErrorHandler(errh);
				
		$("#loading").hide();
		
		$("#addToFav").hide();
		
		$("#printableContentData").hide();

		$("#reportList").resizable({
			maxHeight : 1000,
			maxWidth : 250,
			minHeight : 500,
			minWidth : 200
		});

		$("#reportInformation").resizable({
			maxHeight : 1000,
			minWidth : 200,
			minHeight : 500,
			maxWidth : 800
		});

		$("#reportSearch").resizable({
			maxHeight : 1000,
			maxWidth : 250,
			minHeight : 500,
			minWidth : 250
		});

		$("#reportViewerDialog").dialog("destroy");

		$("#reportViewerDialog").dialog({
			autoOpen : false,				
			modal : true,
			height : 700,
			width : 1000,
			minWidth : 1000
		});					

		$("#reportPrintSelDialog").dialog({
			autoOpen : false,
			modal : true,
			height : 194,
			width : 800,
			minWidth : 800,
			resizable: false,
			maxHeight: 194
		});
		
		$("#filter").keydown(
				function(event) {
					if (event.keyCode == '13') {
						$("#loading").show();
											
						/* ReportsDAO.getGroupList($("#filter").val(), null,
								"REPORT", {
									callback : populateReportList
								}); */
						  var reportFilter = $('#filter').val();
						  ajaxCall(reportFilter,null, "REPORT");
								
					}
				});

		$("#filter").change(
				function(event) {
					if ($("#filter").val() == "") {
						$("#loading").show();
						
						/*ReportsDAO.getGroupList($("#filter").val(), null,
								"REPORT", {
									callback : populateReportList
								});*/
								 var reportFilter = $('#filter').val();
								 ajaxCall(reportFilter,null, "REPORT");
						
					}
				});

		$("#clear").button({
			text : false,
			icons : {
				primary : "ui-icon-circle-close"
			}
		}).click(function() {
			$("#loading").show();
			
			/*ReportsDAO.getGroupList(null, null, "REPORT", {
				callback : populateReportList
			});*/
			ajaxCall(null,null, "REPORT");
			

			$("#filter").val("");
		});

		$("#loading").show();
		
		
		/* ReportsDAO.getUserFavReports({
			callback : populateFavRepList
		}); */
				  var urlValue = 'getUserFavReports.do';    
		$.ajax({
			type: 'GET',
			dataType: 'text',
			Accept: "*/*",
		    'Content-Type': "application/json",			
			url : urlValue,				
								
            success: function (response) {
                	response=JSON.parse(response);
                //	alert("success");
                	populateFavRepList(response);
			},
			
            error : function(error) {
				console.log("ERROR: ", error);
            }

}); 
		 
		
		/*ReportsDAO.getGroupList(null, null, "REPORT", {
			callback : populateReportList
		});*/
		ajaxCall(null,null, "REPORT");
		
		renderAddToFavButton();

	});

	
	function ajaxCall(reportFilter, searchKeyword,level){
				  var urlValue = 'groupList.do';    
		$.ajax({
			type: 'GET',
			dataType: 'text',
			 Accept: "*/*",
			  'Content-Type': "application/json",
										 url : urlValue,	
						
			data: {
				reportFilter: reportFilter,
				searchKeyword: searchKeyword,
				level: level,
               },
					
                    success: function (response) {                	              	                  	
                    	populateReportList(response);
                	  
    			},
    			
                error : function(error) {
    				console.log("ERROR: ", error);
    							    			},
    			done : function() {
    				console.log("DONE");
    			}

      });
}
	
	// User favorite report list
	function populateFavRepList(collection) {		
		$("#favRepTree").empty();
		
		$("<li><span class='folder'>"
		+ "My Favorities"
		+ "</span><ul id='myFavList'></ul></li>")
			.appendTo("#favRepTree");		
		
		$.each(collection,
				function(index,reportObj) {			
			
			$(
					"<li><span class='file'><a onclick='getReportInformation("
							+ reportObj.reportId
							+ ")'>"
							+ reportObj.reportGroup + ">" + reportObj.reportName
							+ "</a></span></li>")
					.appendTo("#myFavList");
			});
		$("#favRepTree").treeview();
		
	}
	
	// Renders report list items
	function renderReportListItem(reportTreeNode,parentId) {
		
		var SubGrplist = reportTreeNode.children;
		var repList = reportTreeNode.reportList;
		
		//alert("childlength:" + SubGrplist.length + " parent id:" + parentId);
		
		if(SubGrplist != null && SubGrplist.length > 0) {
			$.each(
					SubGrplist,
					function(index, childTreeNode) {
						
													$(
									"<li><span class='folder'>"
											+ childTreeNode.name
											+ "</span><ul id=" + "repGroup" + childTreeNode.catId + "></ul></li>")
									.appendTo("#" + parentId);
							
							renderReportListItem(childTreeNode,"repGroup" + childTreeNode.catId);	
						
					});
		}
		
		if(repList != null && repList.length >0) {
		
			$.each( repList,
							function(index,
									reportListObject) {
								$(
										"<li><span class='file'><a onclick='getReportInformation("
												+ reportListObject.reportId
												+ ",\""+ reportListObject.reportGroup + "\")'>"
												+ reportListObject.reportName
												+ "</a></span></li>")
										.appendTo(
												"#"
														+ parentId);
							});
		
		}
		
	}
	
	function populateReportList(RootNode) {
		RootNode=JSON.parse(RootNode);
				console.log("ver" +RootNode);
		
		$("#reportTree").empty();		
		
		if(RootNode != null)
		renderReportListItem(RootNode,"reportTree");
		
		//$("#reportTree").treeview({collapsed: true});
		$("#reportTree").treeview();
		$("#loading").hide();
	}

	function getReportInformation(id,path) {
				currentReportPath = path;
		$("#loading").show();
	/*ReportsDAO.getReport(id, null, "VERSION", {
			callback : showReportInformation
		});*/
				
		    var urlValue = 'report.do';    
			$.ajax({
				type: 'GET',
				dataType: 'text',
				 Accept: "*/*",
				  'Content-Type': "application/json",
				  								 url : urlValue,				
				
				data: {
					reportId: id,
					searchKeyword: null,
					level: "VERSION",
	               },
						
	                    success: function (response) {
	                			showReportInformation(response);
	    			},
	    			
	                error : function(error) {
	    				console.log("ERROR: ", error);
	    							    			},
	    			done : function() {
	    				console.log("DONE");
	    			}

}); 
	}
	
	//var isFav = false;
	var isFav;
	var currReport;
	
	function initFavButton(report) {
		currReport = report; 
				if(report.favorite == true) {
			isFav = true;
			$("#addToFav").button("option", "label", "Remove from Fav");					
		}
		else {			
			isFav = false;
			$("#addToFav").button("option", "label", "Add To Fav");	
		}	
		
		
		$("#addToFav").show();
	}
	
	function renderAddToFavButton(){
				
		
		$("#addToFav").button({
			text : true
			
		}).click(function() {			
			
			//alert('inside fav button click isFav: ' + isFav);
			var currButLab = $("#addToFav").button("option", "label");
			
			if(isFav == false){
			/*	
				ReportsDAO.addReportToFav(currReport,
				{
					callback :function(collection) { 
					
												populateFavRepList(collection);
												$("#addToFav").button("option", "label","Remove from Fav");
												isFav = true;
												}
				}		
				);*/
				
								  var urlValue = 'addReportToFav.do';    
				$.ajax({
					type: 'POST',
					dataType: 'text',
					 Accept: "*/*",
					  'Content-Type': "application/json",
										 url : urlValue,				
					
					 data: {
							reportId: currReport.reportId
					 },
									       success:   function(collection) {		  
									       
														console.log(collection);
														 collection=JSON.parse(collection);
														populateFavRepList(collection);
														 $("#addToFav").button("option", "label","Remove from Fav");
														 isFav = true;
														},
		                error : function(error) {
		    				console.log("ERROR: ", error);
		                }

	});
}				
			else if(isFav == true){
			/*	ReportsDAO.removeReportFromFav(currReport,
				{
					callback : function(collection) {
											
											populateFavRepList(collection);
											 $("#addToFav").button("option", "label","Add To Fav");
											 isFav = false;
											}
				});*/
				
					var urlValue = 'removeReportFromFav.do';    
					$.ajax({
						type: 'POST',
						dataType: 'text',
					     Accept: "*/*",
						'Content-Type': "application/json",
						 url : urlValue,				
											               
								data: {
							reportId: currReport.reportId
							         }, 
						       success:function(collection) {
									   console.log(collection);
									    collection=JSON.parse(collection);							           
										populateFavRepList(collection);
										$("#addToFav").button("option", "label","Add To Fav");
									    isFav = false;
							},
			                error : function(error) {
			    				console.log("ERROR: ", error);
			                }

		});
				
			}				
						
			
		});				
			}
	
	function showReportInformation(report) {
		report=JSON.parse(report);
		/*ReportsDAO.isReportInFavs(report, {
			callback : initFavButton
		});	*/			
					  var urlValue = 'isReportInFavs.do';    
		$.ajax({
			type: 'GET',
			dataType: 'text',
			 Accept: "*/*",
			  'Content-Type': "application/json",
			 
						 url : urlValue,	
						 
						 data: {
							 reportId:report.reportId
							},
								
              success: function (response) {
            	//report.favorite=response;
               	//report.favorite=JSON.parse(report.favorite);
            	report.favorite=JSON.parse(response).favorite;
            	  initFavButton(report);
            	    	 			},
			
          error : function(error) {
				console.log("ERROR: ", error);
          }

});

		var html = "<br/> <b>Report Path:&nbsp;</b>" + report.reportGroup + "<h2>Report Name:&nbsp;"
				+ report.reportName + "</h2><br/><b>Report Description:&nbsp;</b>" + report.description
				+ "<hr/><br/><br/>" // Change Tata
				+ "<b>Versions</b><br/><br/>";  // Tata
		html = html + '<div id="reportInformationContainerScroll">';
		html = html + "<table id='versions'>";
		html = html
				+ "<tr><th>Create Date</th><th>Number of Pages</th><th>Options</th></tr>";
				
		var pdfRootPath = "<%=request.getContextPath()%>" + "/files/pdffile.do?fileloc="; 
		var pdfRootPrintPath = "<%=request.getContextPath()%>" + "/files/pdfprintingfile.do?fileloc="; 
		$
				.each(
						report.reportVersionsList,
						function(index, reportVersionObject) {
							html = html
									+ "<tr><td>"
									+ reportVersionObject.createDate
									+ "</td><td>"
									+ reportVersionObject.numberOfPages
									+ "</td><td><a href='javascript:openReportViewerPopUp("
									+ reportVersionObject.sno
									+ ")'>View</a>&nbsp;&nbsp;<a href='"+ pdfRootPath + reportVersionObject.pdfFileLocation 
									+ "'>Download as PDF</a> &nbsp;&nbsp;<a href='javascript:printReport("
									+reportVersionObject.numberOfPages 
									+"," 
									+ reportVersionObject.sno 
									+ ",\"" 
									+reportVersionObject.pdfFileLocation									
									+ "\")'>Print</a></td></tr>"; //Change Tata
									//+ ")'>View</a>&nbsp;&nbsp;<a href="#">Download as PDF</a></td></tr>"; 
						});

		html = html + "</table>";
		html = html + "</div>";
		$("#reportInformationContainer").html(html);

		$("#versions tr:odd").addClass("alt");

		g_rasprop.currentReportId = report.reportId;
		$("#loading").hide();

	}

	function openReportViewerPopUp(reportSNo,search) {
		
		$("#loading").show();
		
		if (search == true) {
			g_rasprop.showSearchInPopup = true;
		}
		else
		{
			g_rasprop.showSearchInPopup = false;	
		}		
		
		var w = 1003;
		var h = 600;
		
		var left = (screen.width/2)-(w/2);
		var top = (screen.height/2)-(h/2);
		
		
		var winOpt = 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=' + w +',height=' + h +',left = ' + left+',top =' +top;
				
		var URL = "<%=request.getContextPath()%>"+"/reportViewer.do?reportSno="+reportSNo;
		console.log(URL);
		//repWin = window.open(URL, 'reportViewer', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=1000,height=700,left = 183,top = 34');
		repWin = window.open(URL, 'reportViewer',winOpt);
		
		trackOpen(repWin);
		
		$("#loading").hide();	
	}	

	$(function() {
		$("#reportSearchInput")
				.keydown(
						function(event) {
							if (event.keyCode == '13') {
								if ($.trim($("#reportSearchInput").val()) != "") {
									g_rasprop.reportSearchInputVal = $("#reportSearchInput").val();
									if ($(":checked").val() == "current") {
										if (g_rasprop.currentReportId == null) {
											alert("Please select a Report.");
										} else {
											$("#loading").show();
											/*ReportsDAO.getReport(
															g_rasprop.currentReportId,
															$("#reportSearchInput").val(),"PAGE",
															{
																callback : populateCurrentReportSearchResults
															});
										
										*/

											
										var searchInput = $('#reportSearchInput').val();
										var urlValue = 'report.do';    
												$.ajax({
													type: 'GET',
													dataType: 'text',
													 Accept: "*/*",
													  'Content-Type': "application/json",
													 url : urlValue,				
													
													data: {
														reportId:g_rasprop.currentReportId,
														searchKeyword: searchInput,
														level: "PAGE",
										               },
															
										                    success: function (response) {
										                    	response=JSON.parse(response);										                    
										                    	populateCurrentReportSearchResults(response);
										    			},
										    			
										                error : function(xhr,status,error) {
										    				console.error("Ajax request failed ", status,error);
										    				console.log("XHR status:",xhr.status);
										    				console.log("XHR responsetext:",xhr.responseText);
										    				
										                }

									}); 
											
										}
									} else {
										$("#loading").show();
										//alert("click ok");
									/*	ReportsDAO.getAllRepSearchResults(0,0,$("#reportSearchInput").val(), {
											callback : populateAllRptSearchResults
										});	*/

											var urlValue = 'getAllRepSearchResults.do';    
											$.ajax({
												type: 'GET',
												dataType: 'text',
												Accept: "*/*",
												'Content-Type': "application/json",
												url : urlValue,				
												
												data: {
													istartIndex:0,
													iendIndex:0,
													searchKeyword:$("#reportSearchInput").val()
									               },
													    success: function (response) {
													    	//alert("succes");
									                    response=JSON.parse(response);									                    
									                    populateAllRptSearchResults(response);
									    			},
									    			
									                error : function(xhr,status,error) {
									    				console.error("Ajax request failed ", status,error);
									    				console.log("XHR status:",xhr.status);
									    				console.log("XHR responsetext:",xhr.responseText);
									    				
									                }

								});
									}
								}
							}
						});

		$("#radio1").click(
				function() {
					if ($.trim($("#reportSearchInput").val()) != "") {
						g_rasprop.reportSearchInputVal = $("#reportSearchInput").val();
						$("#loading").show();	
					/*	alert("ok");
						ReportsDAO.getAllRepSearchResults(0,0,$("#reportSearchInput").val(), {
							callback : populateAllRptSearchResults
						});*/

						    var urlValue = 'getAllRepSearchResults.do';    
							$.ajax({
								type: 'GET',
								dataType: 'text',
								 Accept: "*/*",
							     'Content-Type': "application/json",
								 url : urlValue,				
								
								data: {
									istartIndex:0,
									iendIndex:0,
									searchKeyword:$("#reportSearchInput").val()
					               },
									
							   success: function (response) {
					                    	response=JSON.parse(response);									                    
					                    	populateAllRptSearchResults(response);
					    			},
					    			error : function(xhr,status,error) {
					    				console.error("Ajax request failed ", status,error);
					    				console.log("XHR status:",xhr.status);
					    				console.log("XHR responsetext:",xhr.responseText);
					    				
					                }

				});
					}

				});

		$("#radio2")
				.click(
						function() {
							if ($.trim($("#reportSearchInput").val()) != "") {
								g_rasprop.reportSearchInputVal = $("#reportSearchInput").val();

								if (g_rasprop.currentReportId == null) {
									alert("Please select a Report.");
								} else {
									$("#loading").show();
									//alert("ok");
									/*ReportsDAO.getReport(
													g_rasprop.currentReportId,
													$("#reportSearchInput").val(),"PAGE",
													{
														callback : populateCurrentReportSearchResults
													});
*/
										  var searchInput = $('#reportSearchInput').val();
										
										  var urlValue = 'report.do';    
										$.ajax({
											type: 'GET',
											dataType: 'text',
											 Accept: "*/*",
											  'Content-Type': "application/json",
											 url : urlValue,				
											
											data: {
												reportId:g_rasprop.currentReportId,
												searchKeyword: searchInput,
												level: "PAGE",
								               },
													
								                    success: function (response) {
								                    	response=JSON.parse(response);								                    
								                    	populateCurrentReportSearchResults(response);
								    			},
								    			
								                error : function(xhr,status,error) {
								    				console.error("Ajax request failed ", status,error);
								    				console.log("XHR status:",xhr.status);
								    				console.log("XHR responsetext:",xhr.responseText);
								    				
								                }

							}); 
								}

							}
						});

		$("#reportSearchInput").change(function(event) {
			$("#reportSearchResults").html("");
			if ($("#reportSearchInput").val() == "") {
				$("#reportSearchResults").html("");
				$("#reportSearchInput").val("");
			}
		});

		$("#reportSearchClear").button({
			text : false,
			icons : {
				primary : "ui-icon-circle-close"
			}
		}).click(function() {
			$("#reportSearchResults").html("");
			$("#reportSearchInput").val("");
		});

		$("#searchChoice").buttonset();

	});

	function populateAllReportSearchResults(ResSetObj) {
		//alert("ResSetObj" +ResSetObj);
		var html = "";		
		
		if(ResSetObj == null)
			return html;
		
		searchResList = ResSetObj.searchResList;
		if(searchResList != null && searchResList.length >0) {		
			$.each( searchResList, 
					function(index, resListObj)
					{														
																			
							html = html + "<table><tr><td style='background: orange;'><b>"
							+ resListObj.reportPath
							+ "</b></td></tr>";				
						
							html = html + "<tr><td>";
							html = html
									+ "<i><b>Create Date: </b></i>"
									+ resListObj.createDate
									+ "<br/>";
							html = html
									+ "<i><b>Number of Pages: </b></i>"
									+ resListObj.totalPagesInReport
									+ "<br/>";
							html = html
									+ "<i><b>Number of Occurrences: </b></i>"
									+ resListObj.noOfOccurancesInReport
									+ "<br/>";
							html = html
									+ "<a href='javascript:openReportViewerPopUp("
									+ resListObj.reportSNo
									+ ",true)'>View Results</a>";
							html = html + "<br/><br/>";
							html = html + "</td></tr></table>";					

						});
			
						
						if(ResSetObj.moreResults == true) {
							var moreResId = "moreRes_" + ResSetObj.nextResListStartIndex + "_" + ResSetObj.nextResListEndIndex;
							html = html + "<div id='"+moreResId+ "'> </div>";
							
														
							if(g_rasprop.moreSearchResId == null) {
								html = html + "<table><tr><td><div id='moreResBut'><a href='javascript:moreSearchRes(\""
								+ moreResId + "\","
								+ ResSetObj.nextResListStartIndex + ","
								+ ResSetObj.nextResListEndIndex
								+ ")'>More>>></a></div></td></tr></table>";
							} else {
								var innHtml = "<a href='javascript:moreSearchRes(\""
									+ moreResId + "\","
									+ ResSetObj.nextResListStartIndex + ","
									+ ResSetObj.nextResListEndIndex
									+ ")'>More>>></a>";
								$("#moreResBut").html(innHtml);
								
								
							}
							
						} else {
							$("#moreResBut").html("No More Results Found");
							//$("#moreResBut").hide();
						}
						
		}		
		//alert(html);
		return html;
		
	}
	
	function moreSearchRes(id,startIndex,endIndex) {
		//alert("in moreSearchRes: " + id);
		g_rasprop.moreSearchResId = id;
		//alert(g_rasprop.reportSearchInputVal);
		//alert("in moreSearchRes " + "startIndex: " + startIndex + " endIndex: " + endIndex + " g_rasprop.moreSearchResId: " + g_rasprop.moreSearchResId);
		//alert("ok");
		/*ReportsDAO.getAllRepSearchResults(startIndex,endIndex,g_rasprop.reportSearchInputVal, {
			callback :populateMoreSearchRes 
		});*/
		

			  var urlValue = 'getAllRepSearchResults.do';    
			$.ajax({
				type: 'GET',
				dataType: 'text',
				 Accept: "*/*",
				'Content-Type': "application/json",
				 url : urlValue,				
				
				data: {
					istartIndex:startIndex,
					iendIndex:endIndex,
					searchKeyword:g_rasprop.reportSearchInputVal
	               },
					dataType:"json"	,
					 success: function (response) {
	                    //	response=JSON.parse(response);									                    
	                    	populateMoreSearchRes(response);
	    			},
	    			
	                error : function(xhr,status,error) {
	    				console.error("Ajax request failed ", status,error);
	    				console.log("XHR status:",xhr.status);
	    				console.log("XHR responsetext:",xhr.responseText);
	    				
	                }

});
			
			
	}
	
	function populateMoreSearchRes(object) {
		
		html = "";
		if(object != null) {
			html = populateAllReportSearchResults(object);
		}
		//alert("g_rasprop.moreSearchResId: "  + g_rasprop.moreSearchResId);
		var id = '#'+g_rasprop.moreSearchResId;
		//alert("insert: " + id);
		$(id).replaceWith(html);
		//$('"#'+g_rasprop.moreSearchResId+'"').after(html);
		
	}
	
	function populateCurrentReportSearchResults(object) {
	
		var html = "";

		html = html + "<tr><th>Search Results: " + g_rasprop.reportSearchInputVal
				+ "</th></tr>";
		if(object != null) {
			repHeader = object.reportName;	
			html = html + populateReportSearchResults(object,repHeader);
			html = "<table>" + html + "</table>";
		}
		
		$("#reportSearchResults").html(html);

		$("#reportSearchResults tr:odd").addClass("alt");
		$("#loading").hide();

		
	}

	function populateAllRptSearchResults(object) {

		var html = "";
		
		

		html = html + "<table><tr><th>Search Results: " + g_rasprop.reportSearchInputVal
				+ "</th></tr></table>";
		
			
		html = html + populateAllReportSearchResults(object);
		
		$("#reportSearchResults").html(html);

		$("#reportSearchResults tr:odd").addClass("alt");
		$("#loading").hide();

	}

	function populateReportSearchResults(report,repHeader) {
		
		
		var html = "";
		var printHeader = false;
		$
				.each(
						report.reportVersionsList,
						function(index, reportVersion) {
							if (reportVersion.reportPages.length > 0) {
								html = html + "<tr><td>";
								html = html
										+ "<i><b>Create Date: </b></i>"
										+ reportVersion.createDate
										+ "<br/>";
								html = html
										+ "<i><b>Number of Pages: </b></i>"
										+ reportVersion.numberOfPages
										+ "<br/>";
								html = html
										+ "<i><b>Number of Occurrences: </b></i>"
										+ reportVersion.reportPages.length
										+ "<br/>";
								html = html
										+ "<a href='javascript:openReportViewerPopUp("
										+ reportVersion.sno
										+ ",true)'>View Results</a>";
								html = html + "<br/><br/>";
								html = html + "</td></tr>";

								printHeader = true;

							}

						});

		if (printHeader) {
			html = "<tr><td style='background: orange;'><b>"
					+ repHeader
					+ "</b></td></tr>" + html;
		}
		
		

		return html;
	}
	
	function getReportPath(repTreeNode) {
		
		if((repTreeNode == null) || repTreeNode == undefined)
			return ""; 
			
		  return( getReportPath(repTreeNode.parent) + ">" + repTreeNode.name);	
		  		  
		
	}

	function populateViewerResults(reportPages) {
		var html = "";

		html = html + "<tr><th>Search Results: " + g_rasprop.viewerSearchInputVal
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

		$("#page").highlight(g_rasprop.viewerSearchInputVal);

		$("#loading").hide();

	}
	// Tata			
	
	var printPages;
	function printReport(numPages,repSno,reportNm) {
					
		
		// Print handler
		$("#print").button({
		text : true,
		icons : {
			primary : "ui-icon-print"
		}
		
	}).click(function() {
		//alert(reportName);
		var startPageNo  = $( "#pageslider" ).slider( "values", 0 );
		var endPageNo = $( "#pageslider" ).slider( "values", 1 );
		
		var pdfRootPrintPath = "<%=request.getContextPath()%>" + "/files/pdfprintingfile.do?fileloc=";
						var printFileLoc = pdfRootPrintPath + reportNm
								+ "&startPage=" + startPageNo + "&endPage="
								+ endPageNo;
						$('#printframe').attr('src', printFileLoc);
						$.browser.chrome = /chrom(e|ium)/
								.test(navigator.userAgent.toLowerCase());

						if ($.browser.chrome) {
							$('#printframe').css({
								'position' : 'absolute',
								'width' : '100%',
								'height' : '100%',
								'top' : '0',
								'z-index' : '9999'
							})
							$('#printframe').load(printFileLoc);
						}

						//	$('#printframe').load(function() {
						//		$('#spinner').show();
						//	});

						//	$('#printableContentData').empty();
						//	var printHtml = "";
						//	pageBreak = '<DIV style="page-break-after:always"></DIV>';

						//alert("repSno:" + repSno + "startPageNo" + startPageNo + "endPageNo" + endPageNo);

					});

			totalPagesHtml = "<p> Total Number of Pages in the report:"
					+ numPages + " </p>";
			$("#totalPages").html(totalPagesHtml);
			//alert("report no of pages:" + numPages + " rep serial no: " + repSno);
			var startPage = 1;

			var defEndPage;

			if (numPages > 10)
				defEndPage = 10;
			else
				defEndPage = numPages;

			html = "<p>Slected range from: " + startPage + " To: " + defEndPage
					+ "</p>";
			$("#selectedPageRange").html(html);

			$('#printableContentData').hide();

			var rangeInLowSel = $("#printRangeInputLow");
			var rangeInHighSel = $("#printRangeInputHigh");

			rangeInLowSel.val(startPage);
			rangeInHighSel.val(defEndPage);

			// Event handlers for text input boxes
			rangeInLowSel.change(function() {

				if (rangeInLowSel.val() > rangeInHighSel.val())
					rangeInHighSel.val(rangeInLowSel.val());

				$("#pageslider").slider("values", 0, rangeInLowSel.val());
				$("#pageslider").slider("values", 1, rangeInHighSel.val());
			});

			rangeInHighSel.change(function() {

				if (rangeInHighSel.val() < rangeInLowSel.val())
					rangeInLowSel.val(rangeInHighSel.val());

				$("#pageslider").slider("values", 0, rangeInLowSel.val());
				$("#pageslider").slider("values", 1, rangeInHighSel.val());
			});

			$("#pageslider").slider({
				range : true,
				min : startPage,
				max : numPages,
				values : [ rangeInLowSel.val(), rangeInHighSel.val() ],
				slide : function(event, ui) {

					rangeInLowSel.val(ui.values[0]);
					rangeInHighSel.val(ui.values[1]);

				}
			});

			$("#reportPrintSelDialog").dialog("open");

		}
		$(function() {
			var $iFrame = $("#printframe");
			$iFrame.load(function() {
				$("#spinner").hide();
			});
		});
	</script>
	<%@ include file="header.jsp"%>
	<div id="container">
		<div id="loading">Loading ...</div>
		<div id="reportList" class="ui-widget-content">
			<div id="extPad">
				<h3 class="ui-widget-header">Reports</h3>
			</div>
			<center>
				Filter: <input id="filter" type="text" />
				<button id="clear">Clear</button>
			</center>
			<div id="repTreeScrollingWrap">
				<div id="repTree">
					<ul id="favRepTree" class="filetree"></ul>
					<ul id="reportTree" class="filetree"></ul>
				</div>
			</div>
		</div>
		<div id="reportInformation" class="ui-widget-content">

			<h3 class="ui-widget-header">Report Information</h3>

			<button id="addToFav">Add To Fav</button>

			<div id="reportInformationContainer"></div>

		</div>
		<div id="reportSearch" class="ui-widget-content">
			<div id="extPad">
				<h3 class="ui-widget-header">Search</h3>
			</div>
			<center>
				<input id="reportSearchInput" type="text" />
				<button id="reportSearchClear">Clear</button>
				<div id="searchChoice">
					<input type="radio" id="radio1" name="radio" value="all"
						style="float: left;" /><label for="radio1">All Reports</label> <input
						type="radio" id="radio2" name="radio" checked="checked"
						value="current" style="float: left;" /><label for="radio2">Current
						Report</label>
				</div>
			</center>
			<br /> <br />
			<div id="searchScrollingWrap">
				<div id="reportSearchResults"></div>
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

				<button style="margin-top: 5px;" id="print">Print</button>

			</div>
			<div id="printableContentContainer">
				<div id="printableContentData"></div>

			</div>

		</div>
	</div>
	<iframe id="printframe" height="0" width="0" style="display: inline"></iframe>
	<div id="spinner" style="display: none;">
		<img id="img-spinner" src="css/images/ajax-loader.gif" alt="Loading" />
	</div>
</body>
</html>