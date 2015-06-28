<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:AccScripts="urn:AccScripts.this" 
	xmlns:ActScripts="urn:ActScripts.this" 
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="EasyListStaffHelper.xslt" /> 
<xsl:include href="EasyListAccountHelper.xslt" />

<xsl:variable name="UserID" select="umbraco.library:RequestQueryString('UserID')" /> 
<xsl:variable name="ResetKey" select="umbraco.library:RequestQueryString('ResetKey')" /> 
<xsl:variable name="Email" select="umbraco.library:Request('email')" />
<xsl:variable name="MobileNo" select="umbraco.library:Request('mobileno')" />
<!-- User request password recovery -->
<xsl:variable name="IsPostBack" select="umbraco.library:Request('submit-reset')" /> 
<!-- User click email link and submit reset password -->
<xsl:variable name="IsPostBackSecAns" select="umbraco.library:Request('submit-reset-secanswer')" />

<xsl:param name="currentPage"/>

<!-- start writing XSLT -->
<xsl:template match="/">
	<xsl:choose>
		<xsl:when test="string-length($ResetKey) &gt; 0 and $IsPostBackSecAns != 'true'">
			<xsl:call-template name="forgotten-form-reset" />
		</xsl:when>
		<!-- User request password recovery -->
		<xsl:when test="$IsPostBack = 'true'"> 
			<xsl:variable name="RequestReset" select="AccScripts:UserRequestResetPassword()" />
			<xsl:choose>
				<xsl:when test="string-length($RequestReset/UserReset/ErrorMessage) &gt; 0"> <!-- Error -->
					<div class="alert alert-error">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Error</strong><xsl:value-of select="$RequestReset/UserReset/ErrorMessage" />
					</div>
					<xsl:call-template name="forgotten-form" />
				</xsl:when>
				<!-- <xsl:when test="string-length($RequestReset/UserReset/SecQuestion) &gt; 0">
					<xsl:call-template name="forgotten-form-secQnA">
						<xsl:with-param name="RequestReset" select="$RequestReset"></xsl:with-param>
					</xsl:call-template>
				</xsl:when> -->
				<xsl:otherwise>
					<xsl:call-template name="Email-Success-Send" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<!-- User click email link and submit reset password -->
		<xsl:when test="$IsPostBackSecAns = 'true'"> 
			<xsl:variable name="RequestResetSecAnswer" select="AccScripts:UserRequestResetPasswordSecAnswer($ResetKey)" />
			<xsl:choose>
				<xsl:when test="string-length($RequestResetSecAnswer/error) &gt; 0"> <!-- Error -->
					<div class="alert alert-error">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Error</strong><xsl:value-of select="$RequestResetSecAnswer/error" />
					</div>
					<xsl:call-template name="forgotten-form-reset" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="Reset-Success" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>	
			<xsl:call-template name="forgotten-form" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="forgotten-form">
	<div class="widget-box">
		<div class="widget-title">
			<h2>Password Recovery</h2>
		</div>
		<div class="widget-content">
			<h4>Forgotten your password?</h4>
			<p>
				You can recover your password easilly with the following steps:
			</p>
			<ol>
				<li>Enter your user name.</li>
				<li>We’ll email you a secure link to your mailbox to reset your password.</li>
				<!--<li>Once you click the secure link, one time pin (OTP) will be send to your mobile no.</li>-->
				<li>Enter new password.</li>
			</ol>
			
			<br />
			
			<form class="form-horizontal break-desktop" method="Post">
				<fieldset>
					<legend><i class="icon-envelop">&nbsp;</i> Enter your user name</legend>
					<p>
						<i class="icon-info-2 info">&nbsp;</i> Type in the user name you used when you registered with Tradingpost.
					</p>
					<br />
					<div class="control-group">
						<label class="control-label"><span class="important">*&nbsp;</span>User Name</label>
						<div class="controls">
							<input type="text" id="username" name="username" class="input-large required">
								<xsl:attribute name="value"><xsl:value-of select="$UserID" /></xsl:attribute>
							</input>
							<!-- <div class="control-note">
								<a href="#">Forgotten your email address?</a>
							</div> -->
						</div>
					</div>
				</fieldset>
				
				<div class="form-actions center">
					<button class="btn btn-success" type="submit" name="submit-reset" value="true" id="submit-reset">Submit</button>
				</div>
				
			</form>
			
		</div>
	</div>
	<!-- /widget-box -->

</xsl:template>

<xsl:template name="forgotten-form-secQnA">
	<xsl:param name="RequestReset"/>
	<div class="widget-box">
		<div class="widget-title">
			<h2>Password Recovery</h2>
		</div>
		<div class="widget-content">
			<form class="form-horizontal break-desktop" method="Post">
				<fieldset>
					<legend><i class="icon-envelop">&nbsp;</i> Security question and answer</legend>
					<p>
						<i class="icon-info-2 info">&nbsp;</i> Type in security answer you used when you registered with Tradingpost.
					</p>
					<br />
					<div class="control-group">					
						<label class="control-label">Security Question</label>
						<div class="controls">
							<h4><xsl:value-of select="$RequestReset/UserReset/SecQuestion" /></h4>
							<!-- <input type="text" id="secanswer" name="secanswer" class="input-large required" /> -->
						</div>
					</div>
					<div class="control-group">					
						<label class="control-label"><span class="important">*&nbsp;</span>Security Answer</label>
						<div class="controls">
							<input type="text" id="secanswer" name="secanswer" class="input-large required" />
						</div>
					</div>
				</fieldset>
				<input type="hidden" id="username" name="username" >
					<xsl:attribute name="value">
						<xsl:value-of select="$RequestReset/UserReset/UserName" />
					</xsl:attribute>
				</input>
				<input type="hidden" id="secquestion" name="secquestion" >
					<xsl:attribute name="value">
						<xsl:value-of select="$RequestReset/UserReset/SecQuestion" />
					</xsl:attribute>
				</input>
				<div class="form-actions center">
					<button class="btn btn-success" type="submit" name="submit-reset-secanswer" value="true" id="submit-reset-secanswer">Submit</button>
				</div>
				
			</form>
			
		</div>
	</div>
	<!-- /widget-box -->

</xsl:template>

<xsl:template name="forgotten-form-reset">
	<xsl:variable name="RequestResetLoad" select="AccScripts:UserRequestResetPasswordLoad($ResetKey, $IsPostBackSecAns)" />
	<div class="widget-box">
		<div class="widget-title">
			<h2>Password Recovery</h2>
		</div>
		<div class="widget-content">
			
			<form class="form-horizontal break-desktop" style="margin-top:-10px;" method="post">
				
				<fieldset>
					<legend><i class="icon-key">&nbsp;</i> Set your new password</legend>
					<div class="control-group">
						<label class="control-label">Your Login ID</label>
						<div class="controls">
							<label><xsl:value-of select="$RequestResetLoad/User/LoginName" /></label>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label"><span class="important required">*</span> New Password</label>
						<div class="controls">
							<input type="password" id="new-password" name="new-password" class="input-large" data-password-meter="true" >
								<!--<xsl:attribute name="data-validate"><![CDATA[{regex:/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[\w\s!@#$%^&*]{8,20}$/ ,required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter the password.', regex:'Please enter at least 8 characters with one or more of each: uppercase[A-Z], lowercase[a-z], number[0-9] and symbols[!@#$%^&]'}}]]></xsl:attribute>-->
								<xsl:attribute name="data-validate"><![CDATA[{required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter the password.'}}]]></xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label"><span class="important required">*</span> Repeat New Password</label>
						<div class="controls">
							<input type="password" id="new-password-confirm" name="new-password-confirm" class="input-large" >
								<xsl:attribute name="data-validate">{equalTo: '#new-password', minlength: 8, maxlength: 20}</xsl:attribute>
							</input>
						</div>
					</div>
				</fieldset>
				
				<!-- <fieldset>
					<legend><i class="icon-question">&nbsp;</i> Answer your security question</legend>
					<p>
						<i class="icon-info-2 info">&nbsp;</i> We need to verify your account before changing your password.
					</p>
					
					<br />
					
					<div class="control-group">
						<label class="control-label">Question</label>
						<div class="controls">
							<label>What was the name of your first pet?</label>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label"><span class="important">*</span> Answer</label>
						<div class="controls">
							<input type="text" id="security-answer" name="security-answer" class="span6 required" />
						</div>
					</div>
				</fieldset> -->
				
<!-- 				<fieldset>
					<legend><i class="icon-mobile">&nbsp;</i> Enter your OTP (One Time Password)</legend>
					<p>
						<i class="icon-info-2 info">&nbsp;</i> We just sent an SMS to your mobile with a 4-digit number.
					</p>

					<div class="control-group">
						<label class="control-label">Enter the number (Ref = <strong><span id="OTPLoginRefCode">
						<xsl:value-of select="$RequestResetLoad/User/OTPReferenceNo" /></span></strong>)</label>
						<div class="controls">
							<input type="text" id="easylist-OTP" name="easylist-OTP" class="required" value="" placeholder="4-digit number">
								<xsl:attribute name="data-validate"><![CDATA[{regex:/^[\d]{4}$/ , messages: { regex:'The OTP code should be 4-digit between 0-9.'}}]]></xsl:attribute>
							</input>
						</div>
					</div>
					
					<div class="control-group">
						<div class="controls">
							<a id="request-otp" class="btn" href="#" tabindex="-1" style="font-size:13px;width:200px;">Didn't receive the SMS? <span class="inner-btn btn-success">Resend</span></a>
						</div>
					</div>
					
				</fieldset> -->
				
				<div class="form-actions center">
					<button class="btn btn-success" type="submit" name="submit-reset-secanswer" id="submit-reset-secanswer">Submit</button>
				</div>
				
			</form>
			
		</div>
	</div>
	<!-- /widget-box -->
</xsl:template>

<xsl:template name="Email-Success-Send">
	<div class="widget-box">
		<div class="widget-title">
			<h2>Password Recovery</h2>
		</div>
		<div class="widget-content">
			<div class="alert alert-success">
				<strong>Info</strong>Please check your mailbox and click the secure link to reset your password!
			</div>			
		</div>
	</div>
	<!-- /widget-box -->

</xsl:template>


<xsl:template name="Reset-Success">
	<div class="widget-box">
		<!--<div class="widget-title">
			<h2>Password Recovery</h2>
		</div>
		<div class="widget-content">
			<div class="alert alert-success">
				<strong>Info</strong>Password reset successfully!
			</div>			
		</div>-->
		
		<div class="widget-title">
			<h2>Password Recovery</h2>
		</div>
		<div class="widget-content">
			<p>Password reset successfully!<br/>
				Please click the link below to login.
			</p>
			
			<div class="form-actions center">
				<a class="btn btn-success" href="/"><i class="icon-dashboard">&nbsp;</i> Login</a>
			</div>
		</div>
		
	</div>
	<!-- /widget-box -->

</xsl:template>

</xsl:stylesheet>