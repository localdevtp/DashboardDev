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
	
	<xsl:variable name="LoginID" select="umbraco.library:RequestQueryString('id')" /> 
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('update-account')" />
	
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
		
		<!--<xsl:variable name="IsAuthorized" select="true"/>-->
		<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Account')" /> 
		
		<xsl:choose>
			<xsl:when test="$IsAuthorized = false">
				<div class="alert alert-error">
					<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="LoadPage">
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="LoadPage" >
		<xsl:choose>
			<xsl:when test="$IsPostBack = 'true'"> <!-- Update Account -->
				<xsl:variable name="UpdateResponse" select="AccScripts:UpdateDealerAccount($LoginID, 1, 0)" />
				<xsl:choose>
					<!-- Check if error message is not empty -->
					<xsl:when test="string-length($UpdateResponse) &gt; 0">
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Failed!</strong> Failed to update your account info. Error : <xsl:copy-of select="$UpdateResponse" />
						</div>
						<xsl:call-template name="DealerEditor">
							<xsl:with-param name="HasError">
								<xsl:text>True</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<!-- Success without error -->
					<xsl:otherwise>
						<div class="alert alert-success">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Success!</strong> Your account info was updated successfully.
						</div>
						<xsl:call-template name="DealerEditor">
							<xsl:with-param name="HasError">
								<xsl:text>False</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="DealerEditor">
					<xsl:with-param name="HasError">
						<xsl:text>False</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="DealerEditor">
		<xsl:param name="HasError"/>
		
		<xsl:variable name="DealerAccSource" select="AccScripts:GetDealerAccount($LoginID, 1)" />
		<xsl:variable name="DealerAcc" select="$DealerAccSource/User" />
		
		<xsl:variable name="DealerAccountingInfo" select="ActScripts:GetDealerAccountInfo($LoginID, 1)" />
		<xsl:variable name="DealerActInfo" select="$DealerAccountingInfo/ELAccInfo" />
		
		<!--  <textarea>
		<xsl:value-of select="$DealerAccountingInfo" />
		</textarea>  -->
	<div class="widget-box">
		<div class="widget-title"><h2><i class="icon-paragraph-justify">&nbsp;</i> Account Details</h2></div>
		<div class="widget-content">
			<fieldset style="margin-top:-10px;">
				<legend>Company</legend>
				<div class="form-left">
					<div class="control-group">
						<label class="control-label"><span class="important">*</span> Company Name</label>
						<div class="controls">
							<input type="text" id="CompanyName" name="CompanyName" class="input-xlarge">
								<xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 50, messages: {required: 'Please enter the Company Name.'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="$DealerActInfo/CompanyName" />
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
										<!-- <xsl:choose>
		   <xsl:when test="$IsPostBack = 'true'">
			 <xsl:value-of select="$LstPriceQualifier" />
		   </xsl:when>
		   <xsl:otherwise>
			 <xsl:value-of select="$data/PriceQualifier" />
		   </xsl:otherwise>
			</xsl:choose> -->
										<xsl:value-of select="$DealerActInfo/Company_TAC_Type" />
									</xsl:with-param>
								</xsl:call-template>
							</select>
							<input type="text" id="CompanyRegistrationNo" name="CompanyRegistrationNo" class="input-xlarge input-prefix-select">
								<xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 20, messages: {required: 'Please enter the Company Registration No.'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="$DealerActInfo/Company_TAC_No" />
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
				<div class="form-right">
					<div class="control-group">
						<label class="control-label">Company License</label>
						<div class="controls">
							<input type="text" id="CompanyDealerLicense" name="CompanyDealerLicense" class="input-xlarge">
								<xsl:attribute name="value">
									<xsl:value-of select="$DealerActInfo/Company_Dealer_License" />
								</xsl:attribute>
							</input>
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
						<label class="control-label">Display Map Code</label>
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
					<!-- <div class="control-group">
				   <label class="control-label">Display Address</label>
				   <div class="controls">
					<input type="text" id="DisplayAddress" name="DisplayAddress" placeholder="Suburb, Postcode, State"/>
				   </div>
				  </div> -->
					<div class="control-group">
						<label class="control-label">Display Address line 1</label>
						<div class="controls">
							<!--<xsl:value-of select="$Staff/User/Address1" disable-output-escaping="yes" />-->
							
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
					<!-- <div class="control-group">
	   <label class="control-label"><span class="important">*</span> Billing Address</label>
	   <div class="controls">
		<input type="text" id="BillingAddress" name="BillingAddress" value="" class="input-xlarge">
		 <xsl:attribute name="data-validate">{required: true, messages: {required: 'Please enter the Billing Address.'}}</xsl:attribute>
		</input>
	   </div>
	  </div> -->
					<div id="MyCountrySelectHere2">
						<span><xsl:text>
							</xsl:text></span>
					</div>
					<div class="control-group">
						<label class="control-label"><span class="important">*</span> Billing Contact Name</label>
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
						<label class="control-label"> Billing Contact Mobile No.</label>
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
			<!--
			<br />
			
			<fieldset>
				<legend>Lead Settings</legend>
				<div class="form-left">
					<div class="control-group">
						<label class="control-label"> Lead Notification By</label>
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
										<span class="important">*</span>&nbsp;Email Leads to
										<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="This is the email address lead notifications will be sent to."><xsl:text>
										</xsl:text></i>
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
													<xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Phone,2)" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:attribute name="data-validate">{required: false, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The lead mobile no entered is invalid'}}</xsl:attribute>
									</input>
								</div>
							</div>
						</div>
			</fieldset>
			-->
			<br />
			
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
			
			
			<input type="hidden" id="update-account" name="update-account" value="true" />
			<input type="hidden" id="activate-account" name="activate-account" value="false" />
			
			<div class="form-actions center">
				<button type="submit" id="UpdateDealer" class="btn btn-large btn-success"><i class="icon-disk">&nbsp;</i> Save</button>
				<span class="hidden-phone">&nbsp;&nbsp;&nbsp;</span>
				<span class="visible-phone" style="display:block;height:10px;overflow:hidden">&nbsp;</span>
			</div>
			<!-- </form> -->
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