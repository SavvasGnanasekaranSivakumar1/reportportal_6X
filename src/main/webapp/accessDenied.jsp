<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page contentType="text/html" import="java.util.*"%>
<html>
<head>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1252">
<title>Access Denied</title>
</head>
<body leftmargin="0" topmargin="0">

	<style type="text/css">
body {
	
}

<%=new java.util.Date()%> #Table_01 tbody tr td #Table_02 tbody tr td {
	text-align: center;
}

#Table_01 {
	text-align: center;
}

#Table_01 tbody tr #Table_01 p font {
	
}

#Table_01 tbody tr #Table_01 p font b {
	text-align: center;
}

#Table_01 tbody tr #Table_01 img {
	text-align: center;
}

#Table_01 tbody tr #Table_01 br {
	text-align: center;
}

#Table_01 tbody tr td p font {
	
}

a:link {
	color: #00C;
}

a:visited {
	color: #00C;
}

a:hover {
	color: #00C;
}

a:active {
	color: #00C;
}

.middle {
	text-align: center;
}

#Table_01 tbody tr td p font strong2 {
	font-size: 24px;
}

#Table_01 tbody tr td p font strong new {
	font-size: 24px;
}

#body_container_small {
	background-color: #ECEEF9;
	border-color: #2B2F88;
	border-style: solid;
	border-width: 5px;
	color: #FFFFFF;
	font: bold 16px/1.6em Arial, Verdana, Helvetica, sans-serif;
	margin: 0 auto;
	padding: 5px;
	width: 800px;
}

DIV.align_left {
	float: left;
}

DIV.align_right {
	float: right;
}

.clr {
	clear: both;
	font-size: 0;
	line-height: 0;
	margin: 0;
	padding: 0;
	width: 100%;
}

.header {
	background: none repeat scroll 0 0 #2B2F88;
	padding-bottom: 24px;
	padding-left: 8px;
	padding-top: 12px;
	position: relative;
	width: 100%;
}
</style>

	<script>
		function actOnLoad() {
			var tempQryString = new Array();
			var errValue = new Array();
			var i = 0;
			newText = "";

			strText = window.top.location.search.substring(1);
			tempQryString = strText.split('&');
			if (tempQryString.length > 0) {
				for (i = 0; i < tempQryString.length; i++) {
					if (tempQryString[i].length > 0) {
						errValue = tempQryString[i].split('=');
						if (errValue[0].length > 0) {
							if (errValue[0] == "axmErrCode") {
								newText = "Error Code : " + escape(errValue[1]);
								abc = new String(unescape(decodeURI(newText)));
								abc = abc.replace(/</g, "&lt;");
								abc = abc.replace(/>/g, "&gt;");
								document.getElementById('axmErrCode').textContent = abc;
								document.getElementById('axmErrCode').innerText = abc;
							}
							if (errValue[0] == "axmErrDesc") {
								newText = "Error Description : "
										+ escape(errValue[1]);
								abc = abc.replace(/</g, "&lt;");
								abc = abc.replace(/>/g, "&gt;");
								abc = new String(unescape(decodeURI(newText)));
								document.getElementById('axmErrDesc').textContent = abc;
								document.getElementById('axmErrDesc').innerText = abc;
							}
						}
					}
				}
			}
		}
	</script>
	<div class="header">
		<!-- LOGO - begin -->
		<div style="LINE-HEIGHT: 11pt" class="align_left">
			<img src="css/images/savvaslogo.gif">
			<div class="clr"></div>
		</div>
	</div>
	<!-- BODY - begin -->
	<br>
	<div id="body_container_small">
		<table id="Table_01" height="493" cellspacing="0" cellpadding="0"
			width="750" align="center" border="0">
			<tbody>

				<tr>
					<td><p>&nbsp;</p>
						<p>&nbsp;</p>
						<p>
							<strong><font color="#21358c" size="-1"
								face="Verdana, Trebuchet, Helvetica, sans-serif"
								style="font-size: 24px">Access Denied</font></strong>
						</p>
						<blockquote>
							<blockquote>
								<blockquote>
									<blockquote>
										<p align="left" class="middle">
											<font face="Verdana, Trebuchet, Helvetica, sans-serif"
												color="#21358c" size="-1">You do not have an account
												to access this Application.<br>

											</font>
										</p>
									</blockquote>
								</blockquote>
							</blockquote>
						</blockquote>
						<p align="left" class="middle">
							<font face="Verdana, Trebuchet, Helvetica, sans-serif"
								color="#21358c" size="-1"><b class="middle">For
									assistance, contact the Savvas Corporate Help Desk</b><br> <a
								href="mailto:savvas.it@savvas.com">savvas.it@savvas.com</a><br>
								Call:800-846-4925 or 5666(using Webex) <br> </font>
						</p>
						<p align="left" class="middle">&nbsp;</p>
						<p align="left" class="middle">&nbsp;</p></td>
				</tr>

			</tbody>
		</table>
	</div>

</body>
</html>
