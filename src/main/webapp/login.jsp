<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page contentType="text/html" import="java.util.*"%>
<%@ page import="com.pearson.ras.domain.UserBean"%>
<html>
<head>
<meta http-equiv="Expires" CONTENT="0">
<meta http-equiv="Cache-Control" CONTENT="no-cache">
<meta http-equiv="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1252">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<title>Savvas: Royalty Reports Login</title>
	<script language="JavaScript">
		function framebreakout() {
			if (top.location != location) {
				top.location.href = document.location.href;
			}
		}
		function doSubmit() {
			//ReportsDAO.validateUser()
			validateUserCall();
		}
		function callvalidate() {
			//ReportsDAO.validateUser();
			validateUserCall();

		}

		function validateUserCall() {
			var urlValue = 'login.do';
			$.ajax({
				type : 'POST',
				dataType : 'text',
				Accept : "*/*",
				'Content-Type' : "application/json",
				url : urlValue,

				data : {
					user1 : userName,
					password : password,
					domain : domain,
				},

				success : function(response) {

				},

				error : function(error) {
					console.log("ERROR: ", error);
				},
				done : function() {
					console.log("DONE");
				}

			});
		}

		function autosubmit(username, password, autosubmit) {
			alert("autosubmit");
			if (autosubmit == "true") {
				document.authForm.user.value = username;
				document.authForm.password.value = password;
				document.authForm.method = "post";
				document.authForm.action = "Login.jsp";
				document.authForm.submit();
				alert("submission");
			}

		}
		function convertUserName() {
			var userid = document.authForm.user1.value;
			var domainNameValue = document.authForm.DomainDropdown.options[document.authForm.DomainDropdown.selectedIndex].value;
			// To support NCSP and INFORMIT domain users.
			alert("print username");
			if (domainNameValue == "ncsp")
				domainNameValue = domainNameValue + ".LSK12";
			else if (domainNameValue == "informit")
				domainNameValue = domainNameValue + ".corporateroot";

			if (domainNameValue == "NON PEARSON") {
				document.authForm.user.value = userid;
			} else if (domainNameValue == "PEQA.LOCAL") {
				document.authForm.user.value = userid + "@peqa.local";
			} else {
				document.authForm.user.value = userid + "@" + domainNameValue
						+ ".com";
				;
			}
			document.authForm.action = "login.do";

			return validateLoginForm();
		}
	</script>
	<style type="text/css">
body {
	margin-top: 0px;
}

<%=new java.util.Date()%>#Table_01 tbody tr td #Table_02 tbody tr td p font .middle
	{
	color: #ebedf9;
}

#body_container_small {
	background-color: #eceef9;
	border-color: #2b2f88;
	border-style: solid;
	border-width: 5px;
	color: #FFFFFF;
	font: bold 16px/1.6em Arial, Verdana, Helvetica, sans-serif;
	margin: 0 auto;
	padding: 5px;
	width: 800px;
}

.loginbutton {
	background-color: #c6dfef;
	border: 0px;
	height: 29px;
	font: bold 12px Arial;
}

.loginbutton:hover {
	background-color: #d0e5f5;
}

DIV.align_left {
	FLOAT: left
}

DIV.align_center {
	FLOAT: center
}

DIV.align_right {
	FLOAT: right
}

.clr {
	PADDING-BOTTOM: 0px;
	LINE-HEIGHT: 0px;
	MARGIN: 0px;
	PADDING-LEFT: 0px;
	WIDTH: 100%;
	PADDING-RIGHT: 0px;
	CLEAR: both;
	FONT-SIZE: 0px;
	PADDING-TOP: 0px
}

.header {
	POSITION: relative;
	PADDING-BOTTOM: 24px;
	PADDING-LEFT: 8px;
	BACKGROUND: #2b2f88;
	PADDING-TOP: 12px;
	width: 100%;
}

.header_resize {
	BORDER-LEFT: #d7d7d7 1px solid;
	PADDING-BOTTOM: 0px;
	MARGIN: 0px auto;
	PADDING-LEFT: 0px;
	WIDTH: 970px;
	PADDING-RIGHT: 0px;
	BACKGROUND: url(../images/header_bgres.gif) #fff repeat-x 50% top;
	BORDER-RIGHT: #d7d7d7 1px solid;
	PADDING-TOP: 0px
}

.header .logo {
	WIDTH: auto;
	FLOAT: left
}

.header .menu UL {
	PADDING-BOTTOM: 0px;
	LIST-STYLE-TYPE: none;
	MARGIN: 87px 40px 0px 0px;
	PADDING-LEFT: 0px;
	WIDTH: auto;
	PADDING-RIGHT: 0px;
	FLOAT: right;
	LIST-STYLE-IMAGE: none;
	PADDING-TOP: 0px
}

.header .menu UL LI {
	MARGIN: 0px 4px;
	FLOAT: left
}

.header .menu UL LI A {
	BORDER-BOTTOM: #fff 1px solid;
	BORDER-LEFT: #fff 1px solid;
	PADDING-BOTTOM: 6px;
	MARGIN: 0px;
	PADDING-LEFT: 16px;
	PADDING-RIGHT: 16px;
	DISPLAY: block;
	COLOR: #5f5f5f;
	BORDER-TOP: #fff 1px solid;
	BORDER-RIGHT: #fff 1px solid;
	TEXT-DECORATION: none;
	PADDING-TOP: 6px
}

.header .menu UL LI A:hover {
	BORDER-BOTTOM-COLOR: #dedede;
	BORDER-TOP-COLOR: #dedede;
	BORDER-RIGHT-COLOR: #dedede;
	BORDER-LEFT-COLOR: #dedede
}

.header .menu UL LI.active A {
	BORDER-BOTTOM-COLOR: #dedede;
	BORDER-TOP-COLOR: #dedede;
	BORDER-RIGHT-COLOR: #dedede;
	BORDER-LEFT-COLOR: #dedede
}
</style>
	<style type="text/css">
.middle {
	TEXT-ALIGN: center
}

#Table_01 TBODY TR TD #Table_02 TBODY TR TD P FONT .middle {
	TEXT-ALIGN: center;
	FONT-SIZE: 11px
}

#Table_01 TBODY TR TD #Table_02 TBODY TR TD P FONT .middle {
	FONT-SIZE: 12px
}

#Table_01 TBODY TR TD #Table_02 TBODY TR TD P FONT .middle {
	FONT-SIZE: 12px
}

#Table_01 TBODY TR TD #Table_02 TBODY TR TD TABLE TBODY TR TD {
	TEXT-ALIGN: left
}
</style>
	<form name="authForm" action="login.do" method="POST"
		accept-charset="UTF-8">
		<!-- <form  name="authForm" id="idloginform" action="login.do" method="POST" onsubmit="validateUserCall()"
		accept-charset="UTF-8" > -->
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
			<table id="Table_01" border="0" cellspacing="0" cellpadding="0"
				width="800" align="center" height="493">
				<tbody>
					<tr>
						<td width="750"><table id="Table_02" border="0"
								cellspacing="0" cellpadding="0" width="750" align="center"
								height="294">
								<tbody>
									<tr>
										<td height="20" colspan="4"><strong
											style="text-align: left; font-family: Verdana, Geneva, sans-serif; font-size: 18px; color: #3A4491;">Welcome
												To Royalty Reports</strong></td>
									</tr>
									<tr>
										<td height="97" colspan="4"><strong
											style="text-align: left; font-family: Verdana, Geneva, sans-serif; font-size: 18px; color: #000000;">Member
												Login</strong><br> <br></td>
									</tr>
									<tr>
										<td valign="bottom" width="360" height="10px;"><div
												style="text-align: left; font-family: Verdana, Geneva, sans-serif; font-size: 12px; color: #000000;">
												<span style="font-size: 10px; color: #FFF;"></span>Username:
											</div></td>
										<td rowspan="3" width="68">&nbsp;</td>
										<td rowspan="3" width="373" colspan="2"><strong
											style="text-align: left; font-family: Verdana, Geneva, sans-serif; font-size: 12px; color: #3A4491;">
												Need Help?</strong>
											<p
												style="text-align: left; font-family: Verdana, Geneva, sans-serif; font-size: 12px; color: #000000;">
												Contact the Savvas Corporate Help Desk<br> <a
													href="mailto:savvas.it@savvas.com">savvas.it@savvas.com</a><br>
												Call:800-846-4925 or 5666(using Webex)
											</p></td>
									</tr>

									<tr>
										<td valign="top" height="5px;"><table>
												<tbody>
													<tr>
														<td width="97%"><input type="text" size="50"
															name="user1" tabindex="1" value="${user1}"> <input
															type="hidden" size="50" name="user" tabindex="1"></td>
													</tr>
												</tbody>
											</table></td>
									</tr>
									<tr>
										<td valign="top" rowspan="2" style="height: 20px;"><div
												style="text-align: left; font-family: Verdana, Geneva, sans-serif; font-size: 12px; color: #000000;">
												<span style="font-size: 10px; color: #FFF;"></span>Password:
											</div>
											<table>

												<tbody>
													<tr>
														<td width="369"><input tabindex="2" size="50"
															type="password" name="password"></td>
													</tr>
													<tr>
														<td><c:if test="${error != null}">
																<font size="-2" color="red"
																	face="Verdana, Trebuchet, Helvetica, sans-serif">
																	<b> ${error} </b>
																</font>
															</c:if></td>
													</tr>
												</tbody>
											</table></td>
									</tr>
								</tbody>
							</table>
							<div class="align_left" style="padding-left: 25px;">
								<div
									style="text-align: left; font-family: Verdana, Geneva, sans-serif; font-size: 12px; color: #000000;">
									Domain: &nbsp; <select style="width: 115px;"
										id="DomainDropdown" name="DomainDropdown">

										<option value="lsk12" selected>CORP</option>
									</select>
								</div>
							</div> <br> <br>
							<table align="left" style="padding-left: 25px;">
								<tbody>
									<tr>
										<td width="369" height="5px;"><button class="loginbutton"
												name="Log In" type="submit">Log In</button></td>
									</tr>
								</tbody>
							</table></td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</body>
</html>
