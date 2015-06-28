<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
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
		
	<xsl:variable name="LoginID" select="umbraco.library:Session('easylist-username')" />
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('update-account')" />
	<xsl:variable name="FirstName" select="umbraco.library:Request('FirstName')" />
	<xsl:variable name="LastName" select="umbraco.library:Request('LastName')" />
	<xsl:variable name="Email" select="umbraco.library:Request('Email')" />
	
	<xsl:variable name="ToVerifyOTP" select="umbraco.library:Request('ToVerifyOTP')" />
	<xsl:variable name="OTPReferenceCode" select="umbraco.library:Request('OTPReferenceCode')" />
	<xsl:variable name="OTP" select="umbraco.library:Request('easylist-OTP')" />
	
	<xsl:variable name="EmailInvoicesTo" select="umbraco.library:Request('EmailInvoicesTo')" />
	<xsl:variable name="EmailCCInvoicesTo" select="umbraco.library:Request('EmailCCInvoicesTo')" />
	<xsl:variable name="CompanyName" select="umbraco.library:Request('CompanyName')" />
	
	<xsl:variable name="ContactPhone" select="umbraco.library:Request('ContactPhone')" />
	<xsl:variable name="ContactFax" select="umbraco.library:Request('ContactFax')" />
	<xsl:variable name="ContactMobile" select="umbraco.library:Request('ContactMobile')" />
	<xsl:variable name="AddressLine1" select="umbraco.library:Request('AddressLine1')" />
	<xsl:variable name="AddressLine2" select="umbraco.library:Request('AddressLine2')" />
	<!-- <xsl:variable name="LoginID" select="umbraco.library:Request('LoginID')" /> -->
	
	<xsl:variable name="CountryCode" select="umbraco.library:Request('address-country-code')" />
	<xsl:variable name="RegionID" select="umbraco.library:Request('address-region-id')" />
	<xsl:variable name="PostalCode" select="umbraco.library:Request('address-postalcode')" />
	<xsl:variable name="District" select="umbraco.library:Request('address-district')" />
	
	<xsl:variable name="ManagerGroupSet" select="umbraco.library:Request('ManagerGroup')" />
	<xsl:variable name="AccountsSet" select="umbraco.library:Request('Accounts')" />
	<xsl:variable name="EditorSet" select="umbraco.library:Request('Editor')" />
	<xsl:variable name="SalesSet" select="umbraco.library:Request('Sales')" />
	
	<xsl:param name="currentPage"/>
	
	<!-- start writing XSLT -->
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$IsPostBack = 'true'">
				<xsl:variable name="IsMobileChanged" select="AccScripts:StaffMobileNoChange($LoginID)" />
				<!-- <textarea>
					<xsl:value-of select="$ContactMobile" />
				</textarea> -->
				
				<xsl:choose>
					<xsl:when test="$IsMobileChanged = 'true' and $ToVerifyOTP != 'true'">
						<xsl:variable name="SendOTPResponse" select="AccScripts:SendOTP($ContactMobile,'ProfileResetMobile')" />
						<xsl:variable name="OTPRefCode" select="$SendOTPResponse/AccountInfo/OTPReferenceCode" />
						<!-- <textarea>
							<xsl:value-of select="$OTPRefCode" />
						</textarea> -->
						<xsl:call-template name="AccountEditorLoad">
							<xsl:with-param name="HasError"><xsl:text>False</xsl:text></xsl:with-param>
							<xsl:with-param name="EnterOTP"><xsl:text>true</xsl:text></xsl:with-param>
							<xsl:with-param name="OTPRefCode" select="$OTPRefCode"/>
						</xsl:call-template>
					</xsl:when>
					
					<xsl:otherwise>
						<!-- Update Account -->
						<xsl:choose>
							<xsl:when test="$ToVerifyOTP = 'true'">
								<xsl:variable name="VerifyOTPResponse" select="AccScripts:VerifyOTP($ContactMobile, $OTPReferenceCode, $OTP)" />
								<xsl:choose>
									<xsl:when test="string-length($VerifyOTPResponse) &gt; 0">
										<div class="alert alert-error">
											<button data-dismiss="alert" class="close" type="button">×</button>
											<strong>Failed!</strong> Invalid OTP. Please try again!
										</div>
										<xsl:call-template name="AccountEditorLoad">
											<xsl:with-param name="HasError">
												<xsl:text>True</xsl:text>
											</xsl:with-param>
											<xsl:with-param name="EnterOTP"><xsl:text>true</xsl:text></xsl:with-param>
											<xsl:with-param name="OTPRefCode" select="$OTPReferenceCode"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<!--  Save account -->
										<xsl:call-template name="AccountSave" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<!--  Save account -->
								<xsl:call-template name="AccountSave" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="AccountEditorLoad">
					<xsl:with-param name="HasError">
						<xsl:text>False</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Save Account -->
	<xsl:template name="AccountSave">
		<xsl:variable name="UpdateResponse" select="AccScripts:UpdateStaffAccount($LoginID, 1)" />
		<xsl:choose>
			<!-- Check if error message is not empty -->
			<xsl:when test="string-length($UpdateResponse) &gt; 0">
				<div class="alert alert-error">
					<button data-dismiss="alert" class="close" type="button">×</button>
					<strong>Failed!</strong> Failed to update staff account. Error : <xsl:copy-of select="$UpdateResponse" />
				</div>
				<xsl:call-template name="AccountEditorLoad">
					<xsl:with-param name="HasError">
						<xsl:text>True</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<!-- Success without error -->
			<xsl:otherwise>
				<xsl:variable name="IsRetailUser" select="AccScripts:IsRetailUser()" />
				<xsl:choose>
					<!-- Check if error message is not empty -->
					<xsl:when test="$IsRetailUser = 'true'">
						<!-- Continue update master account-->
						<xsl:variable name="UpdateMasterResponse" select="ActScripts:UpdateMasterAccountInfo($IsRetailUser)" />
						<xsl:choose>
							<xsl:when test="string-length($UpdateMasterResponse) &gt; 0">
								<div class="alert alert-error">
									<button data-dismiss="alert" class="close" type="button">×</button>
									<strong>Failed!</strong> Failed to update staff account. Error : <xsl:copy-of select="$UpdateMasterResponse" />
								</div>
								<xsl:call-template name="AccountEditorLoad">
									<xsl:with-param name="HasError">
										<xsl:text>True</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<div class="alert alert-success">
									<button data-dismiss="alert" class="close" type="button">×</button>
									<strong>Success!</strong> Your account is successfully updated!
								</div>
								<xsl:call-template name="AccountEditorLoad">
									<xsl:with-param name="HasError">
										<xsl:text>False</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<div class="alert alert-success">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Success!</strong> Your account is successfully updated.
						</div>
						<xsl:call-template name="AccountEditorLoad">
							<xsl:with-param name="HasError">
								<xsl:text>False</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="AccountEditorLoad">
		<xsl:param name="HasError"/>
		<xsl:param name="EnterOTP"/>
		<xsl:param name="OTPRefCode"/>
		
		<xsl:variable name="Staff" select="AccScripts:GetStaffAccount($LoginID, 1)" />
		<xsl:variable name="StaffGroup" select="AccScripts:GetStaffAccountGroup($LoginID, 1)" />
		<!-- <xsl:variable name="StaffAccInfo" select="ActScripts:GetAccountInfo()" /> -->
		<!-- <xsl:if test="string-length($StaffAccInfo/ELAccInfo) &gt; 0">
	<textarea>
	  <xsl:value-of select="$StaffAccInfo/ELAccInfo" />
	</textarea>
  </xsl:if> -->
	  <xsl:choose>
		  <xsl:when test="string-length($Staff/error) &gt; 0">
			  
			  <div class="alert alert-error">
				  <button data-dismiss="alert" class="close" type="button">×</button>
				  <strong>Failed!</strong>
				  <xsl:value-of select="$Staff/error" />
			  </div>
		  </xsl:when>
		  <xsl:otherwise>
			  <xsl:call-template name="AccountEditor">
				  <xsl:with-param name="HasError">
					  <xsl:text>False</xsl:text>
				  </xsl:with-param>
				  <xsl:with-param name="EnterOTP" select="$EnterOTP"/>
				  <xsl:with-param name="OTPRefCode" select="$OTPRefCode"/>
				  <xsl:with-param name="Staff" select="$Staff"/>
				  <xsl:with-param name="StaffGroup" select="$StaffGroup" />
				  <!-- <xsl:with-param name="StaffAccInfo" select="$StaffAccInfo" /> -->
			  </xsl:call-template>
		  </xsl:otherwise>
	  </xsl:choose>
	  </xsl:template>
	  
	  
	  <xsl:template name="AccountEditor">
		  <xsl:param name="HasError"/>
		  <xsl:param name="Staff"/>
		  <xsl:param name="StaffGroup"/>
		  <xsl:param name="EnterOTP"/>
		  <xsl:param name="OTPRefCode"/>
		  <!-- <xsl:param name="StaffAccInfo"/> -->
		  
		  <div class="widget-box">
			  <div class="widget-title">
				  <h2>
					  <i class="icon-params">&nbsp;</i> My Profile
				  </h2>
			  </div>
			  <div class="widget-content">
				  <form class="form-horizontal break-desktop-large" autocomplete="off" method="post" runat="server">
					  <div class="form-left">
						  <div class="control-group">
							  <label class="control-label">Login ID</label>
							  <div class="controls">
								  <input type="text" id="FormLoginID" name="FormLoginID" disabled="disabled"  value="" class="input-xlarge">
									  <xsl:attribute name="value">
										  <xsl:value-of select="$LoginID" />
									  </xsl:attribute>
									  <xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 20, messages: {required: 'Please enter the Login ID!'}}</xsl:attribute>
								  </input>
							  </div>
						  </div>
						 <!--  <xsl:if test="string-length($StaffAccInfo/ELAccInfo) &gt; 0">
							  <div class="control-group">
								  <label class="control-label"><span class="important">*</span> Company Name</label>
								  <div class="controls">
									  <input class="input-xlarge" maxlength="200" type="text" id = "CompanyName" name="CompanyName">
										  <xsl:attribute name="value">
											  <xsl:choose>
												  <xsl:when test="$IsPostBack = 'true'">
													  <xsl:value-of select="$CompanyName" />
												  </xsl:when>
												  <xsl:otherwise>
													  <xsl:value-of select="$StaffAccInfo/ELAccInfo/CompanyName" />
												  </xsl:otherwise>
											  </xsl:choose>
										  </xsl:attribute>
										  <xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 200, messages: {required: 'Please enter the Company Name'}}</xsl:attribute>
									  </input>
								  </div>
							  </div>
						  </xsl:if> -->
						  <div class="control-group">
							  <label class="control-label"><span class="important">*</span> First Name</label>
							  <div class="controls">
								  <input class="input-xlarge" maxlength="50" type="text" id = "FirstName" name="FirstName">
									  <xsl:attribute name="value">
										  <xsl:choose>
											  <xsl:when test="$IsPostBack = 'true'">
												  <xsl:value-of select="$FirstName" />
											  </xsl:when>
											  <xsl:otherwise>
												  <xsl:value-of select="$Staff/User/FirstName" />
											  </xsl:otherwise>
										  </xsl:choose>
									  </xsl:attribute>
									  <xsl:attribute name="data-validate">{required: true, regex:/^[a-zA-Z ]*$/, minlength: 2, maxlength: 50, messages: {required: 'Please enter the First Name', regex: 'Please enter only alphabets'}}</xsl:attribute>
								  </input>
							  </div>
						  </div>
						  <div class="control-group">
							  <label class="control-label"><span class="important">*</span> Last Name</label>
							  <div class="controls">
								  <input class="input-xlarge" maxlength="50" type="text" id = "LastName" name="LastName">
									  <xsl:attribute name="value">
										  <xsl:choose>
											  <xsl:when test="$IsPostBack = 'true'">
												  <xsl:value-of select="$LastName" />
											  </xsl:when>
											  <xsl:otherwise>
												  <xsl:value-of select="$Staff/User/LastName" />
											  </xsl:otherwise>
										  </xsl:choose>
									  </xsl:attribute>
									  <xsl:attribute name="data-validate">{required: true, regex:/^[a-zA-Z ]*$/, minlength: 2, maxlength: 50, messages: {required: 'Please enter the Last Name', regex: 'Please enter only alphabets'}}</xsl:attribute>
								  </input>
							  </div>
						  </div>
						  <div class="control-group">
							  <label class="control-label"><span class="important">*</span> Email</label>
							  <div class="controls">
								  <input type="text" name="Email" class="input-xlarge email required" value="">
									  <xsl:attribute name="value">
										  <xsl:choose>
											  <xsl:when test="$IsPostBack = 'true'">
												  <xsl:value-of select="$Email" />
											  </xsl:when>
											  <xsl:otherwise>
												  <xsl:value-of select="$Staff/User/EmailAddress" />
											  </xsl:otherwise>
										  </xsl:choose>
									  </xsl:attribute>
								  </input>
							  </div>
						  </div>
						  <div class="control-group">
							  <label class="control-label"><span class="important">*</span> Contact Mobile</label>
							  <div class="controls">
								  <!-- <input class="input-xlarge" maxlength="50" type="hidden" name="ContactMobile" value="{$Staff/User/ContactMobile}"/> -->
								  <input class="input-xlarge required" maxlength="50" type="text" name="ContactMobile">
									  <xsl:attribute name="value">
										  <xsl:choose>
											  <xsl:when test="$IsPostBack = 'true'">
												  <xsl:value-of select="$ContactMobile" />
											  </xsl:when>
											  <xsl:otherwise>
												  <xsl:value-of select="$Staff/User/ContactMobile" />
											  </xsl:otherwise>
										  </xsl:choose>
									  </xsl:attribute>
									  <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Contact Mobile'}}</xsl:attribute>
								  </input>
								  
								  <xsl:if test="$EnterOTP = 'true'">
									<div class="widget-box">
										<div class="widget-title">
											<h3><i class="icon-params">&nbsp;</i> Verify Mobile</h3>
										</div>
										<div class="widget-content">
											<p>
												You have changed your mobile number.<br/>
												We just sent an SMS to your mobile with a 4-digit number.
												<br /><br />Enter the number below (Ref = <strong><span id="OTPLoginRefCode"><xsl:value-of select="$OTPRefCode" /></span></strong>):
											</p>
											
											<div class="control-group">
												<input type="text" id="easylist-OTP" name="easylist-OTP" class="login-field required" value="" placeholder="Enter the 4-digit number">
													<xsl:attribute name="data-validate"><![CDATA[{regex:/^[\d]{4}$/ , messages: { regex:'The OTP code should be 4-digits between 0-9.'}}]]></xsl:attribute>
												</input>
												<!-- <label class="login-field-icon icon-asterisk" for="easylist-OTP">&nbsp;</label> -->
												<input type="hidden" name="ToVerifyOTP" id="ToVerifyOTP" value="true" />
												<input type="hidden" name="OTPReferenceCode" id="OTPReferenceCode" value="{$OTPRefCode}" />
											</div>
											<div class="control-group">
												<a id="request-otp" class="btn" href="#" tabindex="-1" style="font-size:0.8em">Didn't receive the SMS? <span class="inner-btn btn-danger">Resend</span></a>
											</div>
										</div>
									</div>
								  </xsl:if>
							  </div>
						  </div>
						  <div class="control-group">
							  <label class="control-label">Contact Phone</label>
							  <div class="controls">
								  <input class="input-xlarge" maxlength="50" type="text" name="ContactPhone">
									  <xsl:attribute name="value">
										  <xsl:choose>
											  <xsl:when test="$IsPostBack = 'true'">
												  <xsl:value-of select="$ContactPhone" />
											  </xsl:when>
											  <xsl:otherwise>
												  <xsl:value-of select="$Staff/User/ContactPhone" />
											  </xsl:otherwise>
										  </xsl:choose>
									  </xsl:attribute>
									  <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Contact Phone'}}</xsl:attribute>
								  </input>
							  </div>
						  </div>
						  <div class="control-group">
							  <label class="control-label">Contact Fax</label>
							  <div class="controls">
								  <input class="input-xlarge" maxlength="50" type="text" name="ContactFax">
									  <xsl:attribute name="value">
										  <xsl:choose>
											  <xsl:when test="$IsPostBack = 'true'">
												  <xsl:value-of select="$ContactFax" />
											  </xsl:when>
											  <xsl:otherwise>
												  <xsl:value-of select="$Staff/User/ContactFax" />
											  </xsl:otherwise>
										  </xsl:choose>
									  </xsl:attribute>
									  <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Contact Fax'}}</xsl:attribute>
								  </input>
							  </div>
						  </div>
						  
						  <!-- <xsl:if test="string-length($StaffAccInfo/ELAccInfo) &gt; 0">
							  <div class="control-group">
								  <label class="control-label">Email Invoices To</label>
								  <div class="controls">
									  <input type="text" name="EmailInvoicesTo" class="input-xlarge email required" value="">
										  <xsl:attribute name="value">
											  <xsl:choose>
												  <xsl:when test="$IsPostBack = 'true'">
													  <xsl:value-of select="$EmailInvoicesTo" />
												  </xsl:when>
												  <xsl:otherwise>
													  <xsl:value-of select="$StaffAccInfo/ELAccInfo/PrimaryEmail" />
												  </xsl:otherwise>
											  </xsl:choose>
										  </xsl:attribute>
									  </input>
								  </div>
							  </div>
							  <div class="control-group">
								  <label class="control-label"><span class="important">*</span> CC Invoices To</label>
								  <div class="controls">
									  <input type="text" name="EmailCCInvoicesTo" class="input-xlarge email required" value="">
										  <xsl:attribute name="value">
											  <xsl:choose>
												  <xsl:when test="$IsPostBack = 'true'">
													  <xsl:value-of select="$EmailCCInvoicesTo" />
												  </xsl:when>
												  <xsl:otherwise>
													  <xsl:value-of select="$StaffAccInfo/ELAccInfo/SecondaryEmail" />
												  </xsl:otherwise>
											  </xsl:choose>
										  </xsl:attribute>
									  </input>
								  </div>
							  </div>
						  </xsl:if> -->
					  </div>
					  <div class="form-right">
						  <div class="control-group">
							  <label class="control-label">Address line 1</label>
							  <div class="controls">
								  <!--<xsl:value-of select="$Staff/User/Address1" disable-output-escaping="yes" />-->
								  
								  <textarea id="AddressLine1" name="AddressLine1" class="input-xlarge" style="height:80px">
									  <xsl:choose>
										  <xsl:when test="$IsPostBack = 'true'">
											  <xsl:value-of select="$AddressLine1" />
										  </xsl:when>
										  <xsl:otherwise>
											  <xsl:value-of select="$Staff/User/Address1" />
										  </xsl:otherwise>
									  </xsl:choose>
									  <xsl:text>&nbsp;</xsl:text>
								  </textarea>
							  </div>
						  </div>
						  <div class="control-group">
							  <label class="control-label">Address line 2</label>
							  <div class="controls">
								  <textarea id="AddressLine2" name="AddressLine2" class="input-xlarge" style="height:80px">
									  <xsl:choose>
										  <xsl:when test="$IsPostBack = 'true'">
											  <xsl:value-of select="$AddressLine2" />
										  </xsl:when>
										  <xsl:otherwise>
											  <xsl:value-of select="$Staff/User/Address2" />
										  </xsl:otherwise>
									  </xsl:choose>
									  <xsl:text>&nbsp;</xsl:text>
								  </textarea>
							  </div>
						  </div>
						  <div id = "MyCountrySelectHere">
							  <span>
								  <xsl:text>
								  </xsl:text>
							  </span>
						  </div>
					  </div>
					  
					  <input type="hidden" id="HasError" name="HasError" value="" >
						  <xsl:attribute name="value">
							  <xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
								  <xsl:value-of select="$HasError" />
							  </xsl:if>
						  </xsl:attribute>
					  </input>
					  
					  <input type="hidden" id="address-country-code" name="address-country-code">
						  <xsl:attribute name="value">
							  <xsl:choose>
								  <xsl:when test="$IsPostBack = 'true'">
									  <xsl:value-of select="$CountryCode" />
								  </xsl:when>
								  <xsl:otherwise>
									  <xsl:value-of select="$Staff/User/CountryCode" />
								  </xsl:otherwise>
							  </xsl:choose>
						  </xsl:attribute>
					  </input>
					  
					  <input type="hidden" id="address-country-name" name="address-country-name" value="" />
					  
					  <input type="hidden" id="address-region-id" name="address-region-id" value="">
						  <xsl:attribute name="value">
							  <xsl:choose>
								  <xsl:when test="$IsPostBack = 'true'">
									  <xsl:value-of select="$RegionID" />
								  </xsl:when>
								  <xsl:otherwise>
									  <xsl:value-of select="$Staff/User/RegionID" />
								  </xsl:otherwise>
							  </xsl:choose>
						  </xsl:attribute>
					  </input>
					  <input type="hidden" id="address-region-name" name="address-region-name" value="" />
					  
					  <input type="hidden" id="address-postalcode" name="address-postalcode" value="">
						  <xsl:attribute name="value">
							  <xsl:choose>
								  <xsl:when test="$IsPostBack = 'true'">
									  <xsl:value-of select="$PostalCode" />
								  </xsl:when>
								  <xsl:otherwise>
									  <xsl:value-of select="$Staff/User/PostalCode" />
								  </xsl:otherwise>
							  </xsl:choose>
						  </xsl:attribute>
					  </input>
					  <input type="hidden" id="address-district" name="address-district" value="" >
						  <xsl:attribute name="value">
							  <xsl:choose>
								  <xsl:when test="$IsPostBack = 'true'">
									  <xsl:value-of select="$District" />
								  </xsl:when>
								  <xsl:otherwise>
									  <xsl:value-of select="$Staff/User/CityTown" />
								  </xsl:otherwise>
							  </xsl:choose>
						  </xsl:attribute>
					  </input>
					  
					  <input type="hidden" id="update-account" name="update-account" value="true" />
					  
					  <div class="form-actions center">
						  <button type="submit" id="UpdateAcc" class="btn btn-large btn-success">
							  <i class="icon-disk">&nbsp;</i> Update Profile
						  </button>
					  </div>
				  </form>
			  </div>
		  </div>
		  <!-- Create Accounts -->
		  
	  </xsl:template>
	  
	  
</xsl:stylesheet>