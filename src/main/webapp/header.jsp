<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<link id="headerCSS" type="text/css" href="css/header.css"
	rel="stylesheet" />

<script type='text/javascript'>
function adjustStyleHeader(width) {
    width = parseInt(width);
    if (width < 1300) {
        $("#headerCSS").attr("href", "css/header.1024.css");
    } else {
    		
    } 
}

$(function(){	
	adjustStyleHeader($(this).width());
	
	$("#signout").button({
		text : true,
		icons : {
			primary : "ui-icon-close"
		}
		
	}).click(function() {
		
		window.location.href = "logout.do";
		closeWindows();
		
	});
});

</script>
<div id="contHeaderbar">
	<div style="float: left;">
		<ul style="width: 100%;">
			<li class="liLogoTextStyle">SAVVAS Learning Company</li>
			<li style="padding-left: 75px;" class="liLogoTextStyle">Royalty
				Reports</li>

			<li id="greatingMsg" class="liTextStyle">Welcome!&nbsp; <c:out
					value="${headerInfo.userFirstName}" /> &nbsp;<c:out
					value="${headerInfo.userLastName}" />
			</li>
		</ul>
	</div>
	<div style="float: right; padding-top: 3px; display: inline;">

		<button style="border: 0px; padding: 0px 0px; height: 29px;"
			id="signout">Sign Out</button>
	</div>
</div>
<!-- HEADER - End -->
