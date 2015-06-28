<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:AccScripts="urn:AccScripts.this"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListStaffHelper.xslt" /> 
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('easylist-register')" />
	
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		<!-- start writing XSLT -->
		<xsl:if test="$IsPostBack = 'true'">
			<xsl:variable name="NewUserRegisterResponse" select="AccScripts:NewUserRegister()" />
			
			<xsl:choose>
				<!-- Check if error message is not empty -->
				<xsl:when test="string-length($NewUserRegisterResponse) &gt; 0">
					<div class="alert alert-error">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Failed!</strong> Failed to register. Error : <xsl:copy-of select="$NewUserRegisterResponse" />
					</div>
				</xsl:when>
				<!-- Success without error -->
				<xsl:otherwise>
					<div class="alert alert-success">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Success!</strong> Your account had been registered successfully. <br/> Please check your email and click on the activation link to activate your account.
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:call-template name="register-form">
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="register-form">
		<form method="post" autocomplete="off">
			<div class="login-form stage-2">
				<p><strong>First Name</strong></p>
				<xsl:call-template name="FirstName" />
				
				<p><strong>Last Name</strong></p>
				<xsl:call-template name="LastName" />
				
				<p><strong>Login Email Address</strong></p>
				<xsl:call-template name="email" />
				<p>Please enter your personal email address. We will use this to send you a link which you'll need to activate your account.</p>
			
				<p><strong>Login Mobile number</strong></p>
				<xsl:call-template name="mobilenumber" />
				<p>Please enter your personal mobile phone number. We will use this to send you an SMS with a One Time Password you'll need to enter.</p>
				
				<input type="hidden" id="easylist-register" name="easylist-register" value="true" >
				</input>
				<div class="control-group">
					<button type="submit" name="Login" value="Submit_Register" class="btn btn-large btn-primary btn-block">Register</button>
				</div>
			</div>
		</form>
	</xsl:template>
	
	<xsl:template name="FirstName">
		<div class="control-group">
			<input type="text" id="easylist-FirstName" name="easylist-FirstName" class="login-field required no-icon" value="" placeholder="First Name">
				<xsl:attribute name="data-validate">{required: true, messages: {regex: 'The first name is required!'}}</xsl:attribute>
			</input>
			<!-- <label class="login-field-icon icon-mobile" for="easylist-mobilenumber">&nbsp;</label> -->
		</div>
	</xsl:template>
	
	<xsl:template name="LastName">
		<div class="control-group">
			<input type="text" id="easylist-LastName" name="easylist-LastName" class="login-field required no-icon" value="" placeholder="Last Name">
				<xsl:attribute name="data-validate">{required: true, messages: {regex: 'The last name is required!'}}</xsl:attribute>
			</input>
			<!-- <label class="login-field-icon icon-mobile" for="easylist-mobilenumber">&nbsp;</label> -->
		</div>
	</xsl:template>
	
	<xsl:template name="mobilenumber">
		<div class="control-group">
			<input type="text" id="easylist-MobileNo" name="easylist-MobileNo" class="login-field required" value="" placeholder="Mobile number">
				<xsl:attribute name="data-validate">{required: true, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The contact mobile entered is invalid'}}</xsl:attribute>
			</input>
			<label class="login-field-icon icon-mobile" for="easylist-mobilenumber">&nbsp;</label>
		</div>
	</xsl:template>
		
	<xsl:template name="email">
		<div class="control-group">
			<input type="text" id="easylist-Email" name="easylist-Email" class="login-field required email" value="" placeholder="E-mail" />
			<label class="login-field-icon icon-envelop" for="easylist-email">&nbsp;</label>
		</div>
	</xsl:template>
	
</xsl:stylesheet>