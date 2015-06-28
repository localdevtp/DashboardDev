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
	
	<xsl:variable name="ActivationKey" select="umbraco.library:RequestQueryString('ActivationKey')" /> 
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('activate-account')" />
	<xsl:variable name="IsPostBackTempPassword" select="umbraco.library:Request('activate-account-temppass')" />
	
	<xsl:variable name="UserActInfo" select="AccScripts:UserActivateAccountLoad($ActivationKey, $IsPostBack, $IsPostBackTempPassword)" />
	<xsl:variable name="LoginID" select="$UserActInfo/ActivationInfo/UserLoginID" />
	
	<xsl:variable name="DealerAccSource" select="AccScripts:GetDealerAccount($LoginID, 0)" />
	<xsl:variable name="DealerAcc" select="$DealerAccSource/User" />
	
	<xsl:variable name="DealerAccountingInfo" select="ActScripts:GetDealerAccountInfo($LoginID, 0)" />
	<xsl:variable name="DealerActInfo" select="$DealerAccountingInfo/ELAccInfo" />
	
	<xsl:variable name="FirstName" select="umbraco.library:Request('FirstName')" />
	<xsl:variable name="LastName" select="umbraco.library:Request('LastName')" />
	<xsl:variable name="SecPhrase" select="umbraco.library:Request('sec-phrase')" />
	<!-- <xsl:variable name="LoginEmail" select="umbraco.library:Request('LoginEmail')" />
 <xsl:variable name="LoginMobileNo" select="umbraco.library:Request('LoginMobileNo')" />
  -->
	<xsl:variable name="CompanyName" select="umbraco.library:Request('CompanyName')" />
	<xsl:variable name="CompanyRegistrationType" select="umbraco.library:Request('CompanyRegistrationType')" />	
	<xsl:variable name="CompanyRegistrationNo" select="umbraco.library:Request('CompanyRegistrationNo')" />	
	<xsl:variable name="CompanyDealerLicense" select="umbraco.library:Request('CompanyDealerLicense')" />	
	
	<xsl:variable name="DisplayCompanyName" select="umbraco.library:Request('DisplayCompanyName')" />	
	<xsl:variable name="DisplayPhoneNo" select="umbraco.library:Request('DisplayPhoneNo')" />	
	<xsl:variable name="DisplayEmail" select="umbraco.library:Request('DisplayEmail')" />	
	<!-- <xsl:variable name="DisplayMapCode" select="umbraco.library:Request('DisplayMapCode')" />	 -->
	<xsl:variable name="DisplayAddressLine1" select="umbraco.library:Request('DisplayAddressLine1')" />	
	<xsl:variable name="DisplayAddressLine2" select="umbraco.library:Request('DisplayAddressLine2')" />	
	
	<xsl:variable name="BillingContactName" select="umbraco.library:Request('BillingContactName')" />	
	<xsl:variable name="BillingMobileNo" select="umbraco.library:Request('BillingMobileNo')" />	
	<xsl:variable name="BillingPhoneNo" select="umbraco.library:Request('BillingPhoneNo')" />	
	<xsl:variable name="BillingContactPrimaryEmail" select="umbraco.library:Request('BillingContactPrimaryEmail')" />	
	<xsl:variable name="BillingContactSecondaryEmail" select="umbraco.library:Request('BillingContactSecondaryEmail')" />	
	<xsl:variable name="BillingAddressLine1" select="umbraco.library:Request('BillingAddressLine1')" />	
	<xsl:variable name="BillingAddressLine2" select="umbraco.library:Request('BillingAddressLine2')" />	
	
	<xsl:variable name="LeadsNotificationBy" select="umbraco.library:Request('LeadsNotificationBy')" />	
	<xsl:variable name="LeadsEmail" select="umbraco.library:Request('LeadsEmail')" />	
	<xsl:variable name="LeadsPhoneNo" select="umbraco.library:Request('LeadsPhoneNo')" />	
	
	
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		<!-- <textarea>
 1<xsl:value-of select="$IsPostBack" />
 2<xsl:value-of select="$IsPostBackTempPassword" />
</textarea> -->
		<xsl:choose>
			<xsl:when test="string-length($UserActInfo/error) &gt; 0">
				<xsl:choose>
					<xsl:when test="$UserActInfo/error = 'Redirect'"> <!-- Error -->
					</xsl:when>
					<xsl:otherwise>
						<div class="alert alert-error">
							<strong>Error</strong>
							Unfortunately, you activation failed at this point in time.<br/>
							Kindly contact your sales representative for further assistance.
							<!-- <br/><xsl:value-of select="$UserActInfo/error " /> -->
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$IsPostBackTempPassword = 'true'"> <!-- Activate Account - Postback from submit temporary password -->
				<xsl:variable name="ErrorMessage" select="AccScripts:UserActivateAccountValidateTempPass($ActivationKey)" />
				<xsl:choose>
					<xsl:when test="string-length($ErrorMessage) &gt; 0"> 
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Error</strong>
							<br/><xsl:value-of select="$ErrorMessage" />
						</div>
						<xsl:call-template name="activate-form-temp-password">
							<xsl:with-param name="HasError">
								<xsl:text>True</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="activate-form" />
					</xsl:otherwise> 
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$IsPostBack = 'true'"> <!-- Activate Account - Postback from activate account-->
				<xsl:variable name="ErrorMessage" select="AccScripts:UserActivateAccount($ActivationKey)" />
				<xsl:choose>
					<xsl:when test="string-length($ErrorMessage) &gt; 0"> <!-- Error -->
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Error</strong>Account activation failed!
							<br/><xsl:value-of select="$ErrorMessage" />
						</div>
						<xsl:call-template name="activate-form" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="activated" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$UserActInfo/ActivationInfo/UserActivationState = 'Activated'"> 
				<div class="alert alert-success">
					<strong>Info</strong>Your account settings have already been updated. Please go to the <a href="/login">Login Page</a> to continue.
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="activate-form-temp-password">
					<xsl:with-param name="HasError">
						<xsl:text>False</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="activate-form-temp-password">
		<xsl:param name="HasError"/>
		<xsl:if test="$HasError = 'False'">
			<xsl:variable name="SendSMS" select="AccScripts:SendSMSTempPassword($LoginID)" />
		</xsl:if>
		<div class="login">
			<div class="login-screen">
				<div class="login-form stage-2">
					<h4>
						<i class="icon-user">&nbsp;</i><strong><xsl:value-of select="$UserActInfo/ActivationInfo/UserLoginID" /></strong>
					</h4>
					We sent you an SMS with a temporary password, please enter it here. <br/><br/>
					<div class="control-group">
						<input type="password" maxlength="50" class="login-field required" name="easylist-pass" id="easylist-pass" value="" placeholder="Temporary Password" />
						<label class="login-field-icon icon-lock" for="easylist-pass">&nbsp;</label>
					</div>	
					<div class="control-group">
						<input type="hidden" id="activate-account-temppass" name="activate-account-temppass" value="false" />
						<button type="submit" id = "SubmitTempPass" name="SubmitTempPass" value="Submit" class="btn btn-large btn-primary btn-block">Submit</button>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="activate-form">
		
		<div class="widget-box">
			<div class="widget-title">
				<h2>Tradingpost Customer Settings</h2>
			</div>
			<div class="widget-content">
				<h3>Hi <xsl:value-of select="$UserActInfo/ActivationInfo/UserFirstName" />&nbsp;<xsl:value-of select="$UserActInfo/ActivationInfo/UserLastName" /></h3>
				<!-- <h4>Welcome to Tradingpost!</h4> -->
				<!-- <h4>Kindly complete the following information for activation.</h4> -->
				<p>
					Welcome to the new Tradingpost!<br/>
					Before you continue we need you to confirm some details for us.
				</p>
				
				<br />
				
				<!-- <form id="activation" class="form-horizontal break-desktop" autocomplete="off" method="post" runat="server"> -->
				<fieldset style="margin-top:-10px;">
					<legend>Login Details</legend>
					<div class="form-left">
						<div class="control-group">
							<label class="control-label">Your Login ID</label>
							<div class="controls">
								<label><xsl:value-of select="$UserActInfo/ActivationInfo/UserLoginID" /></label>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">First name</label>
							<div class="controls">
								<input type="text" id="FirstName" name="FirstName" class="input-xlarge">
									<xsl:attribute name="data-validate">{required: true, minlength: 2, maxlength: 30, messages: {required: 'Please enter the First Name!'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$FirstName" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerAcc/FirstName" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Last name</label>
							<div class="controls">
								<input type="text" id="LastName" name="LastName" class="input-xlarge">
									<xsl:attribute name="data-validate">{required: true, minlength: 2, maxlength: 30, messages: {required: 'Please enter the Last Name!'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$LastName" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerAcc/LastName" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
					</div>  
				</fieldset>
				<fieldset>
					<legend><i class="icon-key">&nbsp;</i> Set your new password</legend>
					
					<div class="control-group">
						<label class="control-label"><span class="important">*</span> New Password</label>
						<div class="controls">
							<input type="password" id="new-password" name="new-password" class="input-large" data-password-meter="true">
								<xsl:attribute name="data-validate"><![CDATA[{regex:/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[\w\s!@#$%^&*]{8,20}$/ ,required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter the password.', regex:'Please enter at least 8 characters with one or more of each: uppercase[A-Z], lowercase[a-z], number[0-9] and symbols[!@#$%^&]'}}]]></xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label"><span class="important">*</span> Repeat New Password</label>
						<div class="controls">
							<input type="password" id="new-password-confirm" name="new-password-confirm" class="input-large">
								<xsl:attribute name="data-validate">{equalTo: '#new-password', minlength: 8, maxlength: 20}</xsl:attribute>
							</input>
						</div>
					</div>
				</fieldset>
				
				<fieldset>
					<legend><i class="icon-question">&nbsp;</i> Set your secret word</legend>
					
					<div class="controls">
						<p>
							<i class="icon-info-2 info">&nbsp;</i> The secret word you enter here will be displayed by the Tradingpost website every time we prompt you to enter your password, so you can be sure it's us asking for your password, and not a phishing website.<br/>
						</p>
					</div>
					
					<div class="control-group">
						
						
						<label class="control-label"><span class="important">*</span> Secret Word</label>
						<div class="controls">
							
							<input type="text" id="sec-phrase" name="sec-phrase" class="input-large required">
								<xsl:attribute name="data-validate">{minlength: 5, maxlength: 25}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:if test="$IsPostBack = 'true'">
										<xsl:value-of select="$SecPhrase" />
									</xsl:if>
								</xsl:attribute>
							</input>
							<p>
								<br/>
								<i class="icon-warning important">&nbsp;</i>Your secret word should never be the same as your password, user name or email address, and should not provide any hints to your password!
							</p>
						</div>
					</div>
				</fieldset>
				<!--
  <fieldset>
   <legend><i class="icon-question">&nbsp;</i> Set your security question &amp; answer</legend>
   <p>
	<i class="icon-info-2 info">&nbsp;</i> You will need to provides security question &amp; answer for account verification if you forgot your password.
   </p>
   <div class="control-group">
	<label class="control-label"><span class="important">*</span> Select your question</label>
	<div class="controls">
  <select name="security-question" class="required span6">
   <option value="What was the name of your first pet?">What was the name of your first pet?</option>
   <option value="What was the name of the Suburb where you were born?">What was the name of the Suburb where you were born?</option>
   <option value="What was the year you were born?">What was the year you were born?</option>
   <option value="What are the last 5 numbers of your driver's licence?">What are the last 5 numbers of your driver's licence?</option>
   <option value="What is your favourite book/film?">What is your favourite book/film?</option>
   <option value="What is your favourite holiday destination?">What is your favourite holiday destination?</option>
   <option value="Who was your favourite school teacher? ">Who was your favourite school teacher? </option>
   <option value="What is the name of the street you first lived in?">What is the name of the street you first lived in?</option>
   <option value="What was the make and model of your first car?">What was the make and model of your first car?</option>
   <option value="What was the name of the first company you worked for?">What was the name of the first company you worked for?</option>
   <option value="What was the name of your childhood pet?">What was the name of your childhood pet?</option>
   <option value="What is your eldest child's first name?">What is your eldest child's first name?</option>
   <option value="What is your mother's maiden name?">What is your mother's maiden name?</option>
  </select>
	</div>
   </div>
   <div class="control-group">
	<label class="control-label"><span class="important">*</span> Your answer</label>
	<div class="controls">
  <input type="text" id="security-answer" name="security-answer" class="span6 required">
   <xsl:attribute name="data-validate">{minlength: 5, maxlength: 50}</xsl:attribute>
  </input>
	</div>
   </div>
  </fieldset>
  -->
				<!-- <fieldset>
   <legend><i class="icon-mobile">&nbsp;</i> Enter your OTP (One Time Password)</legend>
   <p>
	<i class="icon-info-2 info">&nbsp;</i> Please click on "Request OTP Code" if you did not receive it and we will send you a SMS with the OTP Code.
   </p>
   <br />
   <div class="control-group">
	<label class="control-label">Mobile No.</label>
	<div class="controls">
  <label><xsl:value-of select="$UserActInfo/ActivationInfo/UserContactMobile" /></label>
	</div>
   </div>
   <div class="control-group">
	<label class="control-label"><span class="important">*</span> OTP Code</label>
	<div class="controls">
  <input type="text" id="otp-code" name="otp-code" class="input-large required" />
	</div>
   </div>
   <div class="control-group">
	<div class="controls">
  <button class="btn" type="button" id="request-otp"><i class="icon-mobile">&nbsp;</i> Request OTP Code</button>
	</div>
   </div>
  </fieldset> -->
				<fieldset>
					<legend>Company</legend>
					<div class="form-left">
						<div class="control-group">
							<label class="control-label"><span class="important">*</span> Company Name</label>
							<div class="controls">
								<input type="text" id="CompanyName" name="CompanyName" class="input-xlarge">
									<xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 50, messages: {required: 'Please enter the Company Name.'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$CompanyName" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/CompanyName" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span> Company Registration</label>
							<div class="controls">
								<select class="input-xlarge input-prefix-select" id="CompanyRegistrationType" name="CompanyRegistrationType">
									<xsl:call-template name="optionlist">
										<xsl:with-param name="options">ABN,ACN,RBN</xsl:with-param>
										<xsl:with-param name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'">
													<xsl:value-of select="$CompanyRegistrationType" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$DealerActInfo/Company_TAC_Type" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
								</select>
								<input type="text" id="CompanyRegistrationNo" name="CompanyRegistrationNo" class="input-xlarge input-prefix-select">
									<xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 20, messages: {required: 'Please enter the Company Registration No.'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$CompanyRegistrationNo" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/Company_TAC_No" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						
					</div>
					<div class="form-right">
						<div class="control-group">
							<label class="control-label">Company Trading License</label>
							<div class="controls">
								<input type="text" id="CompanyDealerLicense" name="CompanyDealerLicense" class="input-xlarge">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$CompanyDealerLicense" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/Company_Dealer_License" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input><br/>
								<small>e.g. Motor Dealer License,Second-hand  <br/>dealer license, Pawnbroker license</small>
							</div>
						</div>
					</div>
				</fieldset>
				
				<br />
				
				<fieldset>
					<legend>Company Details</legend>
					<div class="form-left">
						<div class="control-group">
							<label class="control-label">Trading Display Name
								<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="This is the trading name that will be publicly displayed on the Tradingpost website.">&nbsp;</i>
							</label>
							<div class="controls">
								<input type="text" id="DisplayCompanyName" name="DisplayCompanyName" class="input-xlarge">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$DisplayCompanyName" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/Display_CompanyName" /> 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						
						<div id="MyCountrySelectHere">
							<span><xsl:text>
								</xsl:text></span>
						</div>
						<div class="control-group">
							<label class="control-label">Display Phone No.</label>
							<div class="controls">
								<input type="text" id="DisplayPhoneNo" name="DisplayPhoneNo" class="input-xlarge">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$DisplayPhoneNo" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/Display_ContactPhone" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Display Email</label>
							<div class="controls">
								<input type="text" id="DisplayEmail" name="DisplayEmail" class="input-xlarge" >
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$DisplayEmail" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/Display_PrimaryEmail" /> 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<!-- <div class="control-group">
  <label class="control-label">Google Maps Code
   <i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="">&nbsp;</i>
  </label>
  <div class="controls">
   <input type="text" id="DisplayMapCode" name="DisplayMapCode" class="input-xlarge">
	<xsl:attribute name="value">
	 <xsl:value-of select="$DealerActInfo/Display_MapCode" /> 
	</xsl:attribute>
   </input>
  </div>
	</div> -->
					</div>
					<div class="form-right">
						<div class="control-group">
							<label class="control-label">Display Address line 1</label>
							<div class="controls">
								<textarea id="DisplayAddressLine1" name="DisplayAddressLine1" class="input-xlarge" style="height:40px">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$DisplayAddressLine1" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerActInfo/Display_Address1" /> 
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>&nbsp;</xsl:text>
								</textarea>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Display Address line 2</label>
							<div class="controls">
								<textarea id="DisplayAddressLine2" name="DisplayAddressLine2" class="input-xlarge" style="height:40px">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$DisplayAddressLine2" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerActInfo/Display_Address2" /> 
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>&nbsp;</xsl:text>
								</textarea>
							</div>
						</div>
						<div id = "DisplayCountrySelection">
							<span>
								<xsl:text>
								</xsl:text>
							</span>
						</div>
					</div>
				</fieldset>
				
				<br />
				
				<fieldset>
					<legend>Billing Details</legend>
					<div class="form-left">
						<div id="MyCountrySelectHere2">
							<span><xsl:text>
								</xsl:text></span>
						</div>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span> Billing Contact Person</label>
							<div class="controls">
								<input type="text" id="BillingContactName" name="BillingContactName" value="" class="input-xlarge">
									<xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 50, messages: {required: 'Please enter the Billing Contact Name.'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$BillingContactName" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/BillingContactName" /> 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"> Billing Contact Mobile</label>
							<div class="controls">
								<input type="text" id="BillingMobileNo" name="BillingMobileNo" value="" class="input-xlarge">
									<!-- <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Billing Contact Mobile No.'}}</xsl:attribute> -->
									<xsl:attribute name="data-validate">{required: false, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The billing contact mobile no entered is invalid'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$BillingMobileNo" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/ContactMobile" /> 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"> Billing Contact Phone</label>
							<div class="controls">
								<input type="text" id="BillingPhoneNo" name="BillingPhoneNo" value="" class="input-xlarge">
									<xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Billing Contact Phone No.'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$BillingPhoneNo" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/ContactPhone" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span>  Primary Email <i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="Invoices will be sent to this email">&nbsp;</i>
							</label>
							<div class="controls">
								<input type="text" name="BillingContactPrimaryEmail" class="input-xlarge email required">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$BillingContactPrimaryEmail" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/PrimaryEmail" /> 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Secondary Email <i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="Copy of Invoices will be sent to this email">&nbsp;</i>
							</label>
							<div class="controls">
								<input type="text" name="BillingContactSecondaryEmail" class="input-xlarge email">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$BillingContactSecondaryEmail" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$DealerActInfo/SecondaryEmail" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
						</div>
					</div>
					<div class="form-right">
						<div class="control-group">
							<label class="control-label">Billing Address line 1</label>
							<div class="controls">
								<textarea id="BillingAddressLine1" name="BillingAddressLine1" class="input-xlarge" style="height:40px">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$BillingAddressLine1" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerActInfo/Address1" />
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>&nbsp;</xsl:text>
								</textarea>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Billing Address line 2</label>
							<div class="controls">
								<textarea id="BillingAddressLine2" name="BillingAddressLine2" class="input-xlarge" style="height:40px">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$BillingAddressLine2" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerActInfo/Address2" />
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>&nbsp;</xsl:text>
								</textarea>
							</div>
						</div>
						<div id = "BillingCountrySelection">
							<span>
								<xsl:text>
								</xsl:text>
							</span>
						</div>
					</div>
				</fieldset>
				<br />
				<fieldset>
					<legend>Lead Settings</legend>
					<div class="form-left">
						<div class="control-group">
							<label class="control-label"> Lead Notifications By</label>
							<div class="controls">
								<select class="input-xlarge" id="LeadsNotificationBy" name="LeadsNotificationBy">
									<xsl:call-template name="optionlist">
										<xsl:with-param name="options">Email,Email and SMS</xsl:with-param>
										<xsl:with-param name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'">
													<xsl:value-of select="$LeadsNotificationBy" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$DealerActInfo/SalesLead_Type" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
								</select>
							</div>
						</div>
					</div>
					<div class="form-right">
						<div class="LeadsEmailSet">
							<div class="control-group">
								<label class="control-label">
									<span class="important">*</span> Email Leads To
									<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="This is the email address lead notifications will be sent to.">&nbsp;</i>
								</label>
								<div class="controls">
									<input type="text" id="LeadsEmail" name="LeadsEmail" class="input-xlarge email">
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'">
													<xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,1)" />
												</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,1)" />
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
										</input>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">and:</label>
									<div class="controls">
										<input type="text" id="LeadsEmail2" name="LeadsEmail" class="input-xlarge email">
											<xsl:attribute name="value">
												<xsl:choose>
													<xsl:when test="$IsPostBack = 'true'">
														<xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,2)" />
													 </xsl:when>
													 <xsl:otherwise>
														 <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,2)" />
													 </xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
										</input>
									</div>
								</div>
								<xsl:if test="AccScripts:GetValueByCommaPos($LeadsEmail,3) != '' or AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,3) != ''" >
									<div class="control-group LeadsEmailDiv3">
										<label class="control-label">
											<button type="button" id="RemoveEmailLead3" class="btn btn-danger btn-small">
												<i class="icon-minus">&nbsp;</i>&nbsp;&nbsp;Remove
											</button>
											&nbsp;and:
										</label>
										<div class="controls">
											<input type="text" id="LeadsEmail3" name="LeadsEmail" class="input-xlarge email">
												<xsl:attribute name="value">
													<xsl:choose>
														<xsl:when test="$IsPostBack = 'true'">
															<xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,3)" />
														</xsl:when>
														 <xsl:otherwise>
															 <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,3)" />
														 </xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
											</input>
										</div>
									</div>
								</xsl:if>
								<xsl:if test="AccScripts:GetValueByCommaPos($LeadsEmail,4) != '' or AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,4) != ''" >
									<div class="control-group LeadsEmailDiv4">
										<label class="control-label">
											<button type="button" id="RemoveEmailLead4" class="btn btn-danger btn-small">
												<i class="icon-minus">&nbsp;</i>&nbsp;&nbsp;Remove
											</button>
											&nbsp;and:
										</label>
										<div class="controls">
											<input type="text" id="LeadsEmail4" name="LeadsEmail" class="input-xlarge email">
												<xsl:attribute name="value">
													<xsl:choose>
														<xsl:when test="$IsPostBack = 'true'">
															<xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,4)" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,4)" />
														 </xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
											</input>
										</div>
									</div>
								</xsl:if>
								<xsl:if test="AccScripts:GetValueByCommaPos($LeadsEmail,5) != '' or AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,5) != ''" >
									<div class="control-group LeadsEmailDiv5">
										<label class="control-label">
											<button type="button" id="RemoveEmailLead5" class="btn btn-danger btn-small">
												<i class="icon-minus">&nbsp;</i>&nbsp;&nbsp;Remove
											</button>
											&nbsp;and:
										</label>
										<div class="controls">
											<input type="text" id="LeadsEmail5" name="LeadsEmail" class="input-xlarge email">
												<xsl:attribute name="value">
													<xsl:choose>
														<xsl:when test="$IsPostBack = 'true'">
															<xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,5)" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,5)" />
														 </xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
											</input>
										</div>
									</div>
								</xsl:if>
								<xsl:if test="AccScripts:GetValueByCommaPos($LeadsEmail,6) != '' or AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,6) != ''" >
									<div class="control-group LeadsEmailDiv6">
										<label class="control-label">
											<button type="button" id="RemoveEmailLead6" class="btn btn-danger btn-small">
												<i class="icon-minus">&nbsp;</i>&nbsp;&nbsp;Remove
											</button>
											&nbsp;and:
										</label>
										<div class="controls">
											<input type="text" id="LeadsEmail6" name="LeadsEmail" class="input-xlarge email">
												<xsl:attribute name="value">
													<xsl:choose>
														<xsl:when test="$IsPostBack = 'true'">
															<xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,6)" />
														 </xsl:when>
														 <xsl:otherwise>
															 <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,6)" />
														 </xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
											</input>
										</div>
									</div>
								</xsl:if>
							</div>
							<div class="control-group" id="email-leads-add">
								<div class="controls">
									<button type="button" id="AddNewEmailLead" class="btn btn-info btn-small">
										<i class="icon-plus">&nbsp;</i>&nbsp;&nbsp;Add another email address
									</button>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label"> SMS Leads to
									<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="This is the mobile phone number lead notifications will be SMS'd to.">&nbsp;</i>
								</label>
								<div class="controls">
									<input type="text" id="LeadsPhoneNo1" name="LeadsPhoneNo" class="input-xlarge">
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'">
													<xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsPhoneNo,1)" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Phone,1)" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:attribute name="data-validate">{required: false, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The lead mobile no entered is invalid'}}</xsl:attribute>
										<!-- <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Billing Contact Phone No.'}}</xsl:attribute> -->
									</input>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label"> and : &nbsp; </label>
								<div class="controls">
									<input type="text" id="LeadsPhoneNo2" name="LeadsPhoneNo" class="input-xlarge">
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'">
													<xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsPhoneNo,2)" />
												</xsl:when>
												<xsl:otherwise>
													<!-- <xsl:value-of select="$DealerActInfo/SalesLead_Phone" /> -->
													<xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Phone,2)" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:attribute name="data-validate">{required: false, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The lead mobile no entered is invalid'}}</xsl:attribute>
										<!-- <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Billing Contact Phone No.'}}</xsl:attribute> -->
									</input>
								</div>
							</div>
						</div>
						
				</fieldset>
				
				<br />
				<xsl:if test="$DealerActInfo/CreditCardNo = ''">
					<fieldset>
						<legend>Payment Details</legend>
						<div class="payment-type">
							<div class="control-group">
								<label class="control-label">Payment Type</label>
								<div class="controls">
									<label class="radio inline">  
										<input type="radio" name="payment-method" value="BPay">
											<xsl:if test="$DealerActInfo/PaymentPreference ='BPay'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img class="retina" src="/images/payments/bpay.png" alt="BPay" style="width:74px;height:32px" />
									</label>
									<label class="radio inline">  
										<input type="radio" name="payment-method" value="CC">
											<xsl:if test="$DealerActInfo/PaymentPreference !='BPay'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img class="retina" src="/images/payments/mastercard.png" alt="Mastercard" style="width:51px;height:32px;margin-right:5px;" />
										<img class="retina" src="/images/payments/visa.png" alt="Visa" style="width:51px;height:32px" />
									</label>
								</div>
							</div>
						</div>
						<div class="cc-fields-reset">
							<xsl:attribute name="style">display:none</xsl:attribute>
							<!-- <xsl:if test="$DealerActInfo/CreditCardNo != ''">
						  <xsl:attribute name="style">display:none</xsl:attribute>
							</xsl:if> -->
						
							<div class="control-group">
								<label class="control-label">Credit Card Type</label>
								<div class="controls">
									<label class="radio inline">  
										<input type="radio" name="ccType" value="Mastercard" checked="checked" />
										<img class="retina" src="/images/payments/mastercard.png" alt="Mastercard" style="width:51px;height:32px" />
									</label>
									<label class="radio inline">  
										<input type="radio" name="ccType" value="Visa" />
										<img class="retina" src="/images/payments/visa.png" alt="Visa" style="width:51px;height:32px" />
									</label>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">Credit Card No.</label>
								<div class="controls">
									<input type="text" class="input-xlarge required" id="ccNo" name="ccNo" value="" maxlength="16" autocomplete="off">
										<xsl:attribute name="data-validate">{required: false, regex:/^\d{16}$/, minlength: 16, maxlength: 16, messages: {required: 'Please enter the Credit Card No.'}}</xsl:attribute>
									</input>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">Card Holder Name</label>
								<div class="controls">
									<input type="text" class="input-xlarge required" id="ccName" name="ccName" value="" autocomplete="off">
										<xsl:attribute name="data-validate">{required: false, minlength: 3, maxlength: 200, messages: {required: 'Please enter the Card Holder Name'}}</xsl:attribute>
									</input>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Expiry</label>
								<div class="controls">
									<select name="ccMonth" class="input-small">
										<option value="0">MM</option>
										<option value="01" selected="selected">01</option>
										<option value="02">02</option>
										<option value="03">03</option>
										<option value="04">04</option>
										<option value="05">05</option>
										<option value="06">06</option>
										<option value="07">07</option>
										<option value="08">08</option>
										<option value="09">09</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
									</select>
									&nbsp;
									<select name="ccYear" class="input-small">
										<option value="0">YYYY</option>
										<option value="2013">2013</option>
										<option value="2014">2014</option>
										<option value="2015">2015</option>
										<option value="2016">2016</option>
										<option value="2017">2017</option>
										<option value="2018" selected="selected">2018</option>
										<option value="2019">2019</option>
										<option value="2020">2020</option>
										<option value="2021">2021</option>
										<option value="2022">2022</option>
										<option value="2023">2023</option>
										<option value="2024">2024</option>
										<option value="2024">2025</option>
										<option value="2024">2026</option>
										<option value="2024">2027</option>
										<option value="2024">2028</option>
										<option value="2024">2029</option>
										<option value="2024">2030</option>
									</select>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">CVV2</label>
								<div class="controls">
									<input type="password" id="ccCvv2" name="ccCvv2" maxlength="3" value="" class="input-small required" autocomplete="off">
									</input>
									&nbsp;
									<span class="cvv2">
										<img class="retina" src="/images/payments/ccback.png" alt="CVV2" id="CVV2" style="height:16px" />
										&nbsp;<strong>last 3 digits</strong> on back of your credit card
									</span>
								</div>
							</div>
						</div>
					</fieldset>
				</xsl:if>
				
				<!-- BILLING PREFERENCE TEMPLATE -->
				<fieldset class="billing-preference">
					<xsl:if test="$DealerActInfo/CreditCardNo = '' or $DealerActInfo/PaymentPreference ='BPay'">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<legend><i class="icon-gift">&nbsp;</i> Introductory EasyList Bonus</legend>
					
					<div class="control-group">
						<label class="control-label">Select your preference</label>
						<div class="controls billing-preference-controls">
							
							<label class="radio">
								<input type="radio" id="billing-preference" name="billing-preference" value="Advance" class="required">
									<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								I want to pay by credit card in advance
							</label>
							<div class="well">
								<xsl:if test="$DealerActInfo/PaymentPreference != 'Advance'">
									<xsl:attribute name="class">well disabled</xsl:attribute>
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
								<h4>Select <u>TWO</u> bonuses from the lists below:</h4>
								<div class="row-fluid">
									<div class="span6">
										<h5>Bonus 1:</h5>
										<label class="radio">
											<!-- <textarea>
	<xsl:value-of select="$DealerActInfo/Bonus_ELIntegration"/>
   </textarea> -->
											<input type="radio" name="billing-preference-promotion-2a" value="ELIntegration">
												<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance' and $DealerActInfo/PaymentBonus1 = 'ELIntegration'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											Free EasyList SEO Inventory Integration
											<br /><small>Have your Tradingpost ads seamlessly integrated into your existing website!<br/>EasyList SEO Inventory Integration is designed to exactly match your websites existing theme, and provides powerful SEO features that drive Google search traffic to your website, under your own domain name.
											<br/>$300+GST Setup fee waived!
											<br/>$20+GST per week service fees waived!</small>
										</label>
										<label class="radio">
											<input type="radio" name="billing-preference-promotion-2a" value="OffsiteDisplay" >
												<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance' and $DealerActInfo/PaymentBonus1 = 'OffsiteDisplay'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											Free 3-month Run-of-site display campaign
											<br /><small>Have your brand featured throughout the Tradingpost.com.au website with a 3 month run-of-site display advertising campaign!
											<br />Your display advertisement will run in rotation across the Tradingpost website run-of-site display spots to provide valuable branding exposure and the ability for shoppers to click through to your own website or your Tradingpost ads.
											<br />$100+GST per week service fees waived!</small>
										</label>
										<label class="radio">
											<input type="radio" name="billing-preference-promotion-2a" value="Bonus_SEO" >
												<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance' and $DealerActInfo/PaymentBonus1 = 'Bonus_SEO'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											Free 3-month SEO campaign (2 Local Keywords)
											<br /><small>Get your website ranking in Google with zero pay per click fees!
											<br />Our SEO gurus will create a custom SEO marketing campaign to boost the Google ranking of your website for 2 local keywords relevant to your business, including detailed monthly performance reports to show campaign results.
											<br />$99 Setup Fee Waived!
											<br />$25+GST per week service fees waived!</small>
										</label>
										<label class="radio">
											<input type="radio" name="billing-preference-promotion-2a" value="Bonus_PromoteAdsPrivate" >
												<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance' and $DealerActInfo/PaymentBonus1 = 'Bonus_PromoteAdsPrivate'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											Free 3-month Promote your ads on private listings
											<br /><small>Have your ads promoted on the bottom of similar ads from private sellers to supercharge your Tradingpost results!
											<br />When shoppers view a private ad in detail, any similar ads from your catalogue are able to be displayed at the bottom of the private ad as a recommended alternative.
											<br />$25+GST per week service fees waived!</small>
										</label>
									</div>
									<div class="span6">
										<h5>Bonus 2 <small>(yes, you can double up!)</small></h5>
										<label class="radio">
											<input type="radio" name="billing-preference-promotion-2b" value="ELIntegration" >
												<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance' and $DealerActInfo/PaymentBonus2 = 'ELIntegration'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											Free EasyList SEO Inventory Integration
											<br /><small>Have your Tradingpost ads seamlessly integrated into your existing website!<br/>EasyList SEO Inventory Integration is designed to exactly match your websites existing theme, and provides powerful SEO features that drive Google search traffic to your website, under your own domain name.
											<br/>$300+GST Setup fee waived!
											<br/>$20+GST per week service fees waived!</small>
										</label>
										<label class="radio">
											<input type="radio" name="billing-preference-promotion-2b" value="OffsiteDisplay" >
												<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance' and $DealerActInfo/PaymentBonus2 = 'OffsiteDisplay'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											Free 3-month Run-of-site display campaign
											<br /><small>Have your brand featured throughout the Tradingpost.com.au website with a 3 month run-of-site display advertising campaign!
											<br />Your display advertisement will run in rotation across the Tradingpost website run-of-site display spots to provide valuable branding exposure and the ability for shoppers to click through to your own website or your Tradingpost ads.
											<br />$100+GST per week service fees waived!</small>
										</label>
										<label class="radio">
											<input type="radio" name="billing-preference-promotion-2b" value="Bonus_SEO" >
												<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance' and $DealerActInfo/PaymentBonus2 = 'Bonus_SEO'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											Free 3-month SEO campaign (2 Local Keywords)
											<br /><small>Get your website ranking in Google with zero pay per click fees!
											<br />Our SEO gurus will create a custom SEO marketing campaign to boost the Google ranking of your website for 2 local keywords relevant to your business, including detailed monthly performance reports to show campaign results.
											<br />$99 Setup Fee Waived!
											<br />$25+GST per week service fees waived!</small>
										</label>
										<label class="radio">
											<input type="radio" name="billing-preference-promotion-2b" value="Bonus_PromoteAdsPrivate" >
												<xsl:if test="$DealerActInfo/PaymentPreference = 'Advance' and $DealerActInfo/PaymentBonus2 = 'Bonus_PromoteAdsPrivate'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</input>
											Free 3-month Promote your ads on private listings
											<br /><small>Have your ads promoted on the bottom of similar ads from private sellers to supercharge your Tradingpost results!
											<br />When shoppers view a private ad in detail, any similar ads from your catalogue are able to be displayed at the bottom of the private ad as a recommended alternative.
											<br />$25+GST per week service fees waived!</small>
										</label>
									</div>
								</div>
							</div>
							<label class="radio">
								<input type="radio" name="billing-preference" value="Arrear">
									<xsl:if test="$DealerActInfo/PaymentPreference = 'Arrear'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								I want to pay by credit card in arrears
							</label>
							<div class="well">
								<xsl:if test="$DealerActInfo/PaymentPreference != 'Arrear'">
									<xsl:attribute name="class">well disabled</xsl:attribute>
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:if>
								<h4>Select <u>ONE</u> bonus from this list:</h4>
								
								<label class="radio">
									<input type="radio" name="billing-preference-promotion-1" value="ELIntegration" >
										<xsl:if test="$DealerActInfo/PaymentPreference = 'Arrear' and $DealerActInfo/PaymentBonus1 = 'ELIntegration'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									Free EasyList SEO Inventory Integration
									<br /><small>Have your Tradingpost ads seamlessly integrated into your existing website!<br/>EasyList SEO Inventory Integration is designed to exactly match your websites existing theme, and provides powerful SEO features that drive Google search traffic to your website, under your own domain name.
									<br/>$300+GST Setup fee waived!
									<br/>$20+GST per week service fees waived!</small>
								</label>
								<label class="radio">
									<input type="radio" name="billing-preference-promotion-1" value="OffsiteDisplay" >
										<xsl:if test="$DealerActInfo/PaymentPreference = 'Arrear' and $DealerActInfo/PaymentBonus1 = 'OffsiteDisplay'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									Free 3-month Run-of-site display campaign
									<br /><small>Have your brand featured throughout the Tradingpost.com.au website with a 3 month run-of-site display advertising campaign!
									<br />Your display advertisement will run in rotation across the Tradingpost website run-of-site display spots to provide valuable branding exposure and the ability for shoppers to click through to your own website or your Tradingpost ads.
									<br />$100+GST per week service fees waived!</small>
								</label>
								<label class="radio">
									<input type="radio" name="billing-preference-promotion-1" value="Bonus_SEO" >
										<xsl:if test="$DealerActInfo/PaymentPreference = 'Arrear' and $DealerActInfo/PaymentBonus1 = 'Bonus_SEO'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									Free 3-month SEO campaign (2 Local Keywords)
									<br /><small>Get your website ranking in Google with zero pay per click fees!
									<br />Our SEO gurus will create a custom SEO marketing campaign to boost the Google ranking of your website for 2 local keywords relevant to your business, including detailed monthly performance reports to show campaign results.
									<br />$99 Setup Fee Waived!
									<br />$25+GST per week service fees waived!</small>
								</label>
								<label class="radio">
									<input type="radio" name="billing-preference-promotion-1" value="Bonus_PromoteAdsPrivate" >
										<xsl:if test="$DealerActInfo/PaymentPreference = 'Arrear' and $DealerActInfo/PaymentBonus1 = 'Bonus_PromoteAdsPrivate'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									Free 3-month Promote your ads on private listings
									<br /><small>Have your ads promoted on the bottom of similar ads from private sellers to supercharge your Tradingpost results!
									<br />When shoppers view a private ad in detail, any similar ads from your catalogue are able to be displayed at the bottom of the private ad as a recommended alternative.
									<br />$25+GST per week service fees waived!</small>
								</label>
							</div>
						</div>
					</div>
					
				</fieldset>
				
				
				<input type="hidden" id="BillingCountryCode" name="BillingCountryCode" />
				<input type="hidden" id="BillingRegionID" name="BillingRegionID" />
				<input type="hidden" id="BillingRegionName" name="BillingRegionName" />
				<input type="hidden" id="BillingPostalCode" name="BillingPostalCode" />
				<input type="hidden" id="BillingDistrict" name="BillingDistrict" />
				
				<input type="hidden" id="DisplayCountryCode" name="DisplayCountryCode" />
				<input type="hidden" id="DisplayRegionID" name="DisplayRegionID" />
				<input type="hidden" id="DisplayRegionName" name="DisplayRegionName" />
				<input type="hidden" id="DisplayPostalCode" name="DisplayPostalCode" />
				<input type="hidden" id="DisplayDistrict" name="DisplayDistrict" />
				
				<input type="hidden" id="activate-account" name="activate-account" value="false" />
				
				<div class="form-actions center">
					<button class="btn btn-success" type="submit" name="submit" id="submit"><i class="icon-checkmark">&nbsp;</i> Save Settings</button>
				</div>
				
				<!-- </form>
 -->
			</div>
		</div>
		<!-- /widget-box -->
		
	</xsl:template>
	
	<xsl:template name="activated">
		
		<!-- Send Thank you email -->
		<xsl:variable name="SendThankyouEmail" select="AccScripts:SendThankyouEmail($LoginID)" />
		
		<div class="widget-box">
			<div class="widget-title">
				<h2>Tradingpost Customer Settings</h2>
			</div>
			<div class="widget-content">
				<h3>Hi <xsl:value-of select="$UserActInfo/ActivationInfo/UserFirstName" />&nbsp;<xsl:value-of select="$UserActInfo/ActivationInfo/UserLastName" />,</h3>
				<p>Congratulation on activating your Tradingpost Dashboard!<br/>
					Your account settings have already been updated. Please click the link below to login.
				</p>
				
				<div class="form-actions center">
					<a class="btn btn-success" href="/"><i class="icon-dashboard">&nbsp;</i> Login</a>
				</div>
				
			</div>
		</div>
		
	</xsl:template>
	<!-- Drop-down options template -->
	<xsl:template name="optionlist">
		<xsl:param name="options"/>
		<xsl:param name="value"/>
		
		<xsl:for-each select="umbraco.library:Split($options,',')//value">
			<option>
				<xsl:attribute name="value">
					<xsl:value-of select="."/>
				</xsl:attribute>
				<!-- check to see whether the option should be selected-->
				<xsl:if test="$value =.">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test=". !=''">
						<xsl:value-of select="." />
					</xsl:when>
					<xsl:otherwise>Select</xsl:otherwise>
				</xsl:choose>
			</option>
		</xsl:for-each>
		
	</xsl:template>
	
	
</xsl:stylesheet>