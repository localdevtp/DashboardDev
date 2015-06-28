<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:AccScripts="urn:AccScripts.this" 
xmlns:ActScripts="urn:ActScripts.this" 
xmlns:scripts="urn:scripts.this"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListAccountHelper.xslt" /> 
	<xsl:include href="EasyListStaffHelper.xslt" />
	
	<xsl:variable name="LoginID" select="umbraco.library:RequestQueryString('id')" /> 
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('update-account')" />
	<xsl:variable name="IsPostBackActAcc" select="umbraco.library:Request('activate-account')" />
	
	<xsl:variable name="FirstName" select="umbraco.library:Request('FirstName')" />
	<xsl:variable name="LastName" select="umbraco.library:Request('LastName')" />
	<xsl:variable name="LoginEmail" select="umbraco.library:Request('LoginEmail')" />
	<xsl:variable name="LoginMobileNo" select="umbraco.library:Request('LoginMobileNo')" />
	
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
	
	<xsl:variable name="PaymentMethod" select="umbraco.library:Request('payment-method')" />	
	
	<xsl:variable name="CustomerChildSourcePostBack" select="umbraco.library:Request('CustomerChildSource')" />	
	<xsl:variable name="LeadSetting" select="umbraco.library:Request('LeadSetting')" />	
		
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		
		<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('EasySales Admin,ESSalesRep,ESSupport')" /> 
		
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
			<xsl:when test="$IsPostBackActAcc = 'true'"> <!-- Activate Account -->
				<xsl:variable name="ErrMsg" select="AccScripts:ActivateDealerAccount($LoginID)" />
				<xsl:choose>
				  <xsl:when test="string-length($ErrMsg) &gt; 0">
					<div class="alert alert-error">
					  <button data-dismiss="alert" class="close" type="button">×</button>
					  <strong>Failed!</strong> Failed to send the activation email. Please contact support personnel.
					  Error : <xsl:value-of select="$ErrMsg" />
					</div>
				  </xsl:when>
				  <xsl:otherwise>
					<div class="alert alert-success">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Success!</strong> Please advise the customer to check their mailbox for an activation email.
					</div>
				  </xsl:otherwise>
				</xsl:choose> 
				<xsl:call-template name="DealerEditor">
				  <xsl:with-param name="HasError">
				  <xsl:text>False</xsl:text>
				  </xsl:with-param>
				 </xsl:call-template>
			</xsl:when>
			<xsl:when test="$IsPostBack = 'true'"> <!-- Update Account -->
				<xsl:variable name="UpdateResponse" select="AccScripts:UpdateDealerAccount($LoginID, 0, 0)" />
				<xsl:choose>
					<!-- Check if error message is not empty -->
					<xsl:when test="string-length($UpdateResponse) &gt; 0">
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Failed!</strong> Failed to update customer account. Error : <xsl:copy-of select="$UpdateResponse" />
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
							<strong>Success!</strong> The customer account was updated successfully.
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
		
		<xsl:variable name="DealerAccSource" select="AccScripts:GetDealerAccount($LoginID, 0)" />
		<xsl:variable name="DealerAcc" select="$DealerAccSource/User" />
		
		<xsl:variable name="DealerAccountingInfo" select="ActScripts:GetDealerAccountInfo($LoginID, 0)" />
		<xsl:variable name="DealerActInfo" select="$DealerAccountingInfo/ELAccInfo" />
		
		<xsl:variable name="DealerCustChildListSource" select="AccScripts:GetCustomerChildList($LoginID)" />
		<xsl:variable name="DealerCustChildList" select="$DealerCustChildListSource" />
		
		<xsl:variable name="DealerCustInfo" select="AccScripts:GetCustomerInfo($LoginID)" />
		<xsl:variable name="DealerCustParent" select="AccScripts:GetCustomerParent($LoginID)" />
		
		<!-- <textarea>
		  <xsl:value-of select="$DealerCustParent" />
		  </textarea> --> 
	<div class="widget-box">
		<div class="widget-title"><h2><i class="icon-pencil">&nbsp;</i> Edit Customer</h2></div>
		<div class="widget-content">
			<!-- <form id="DealerForm" class="form-horizontal break-desktop-large" style="margin-top:-10px;" autocomplete="off" method="post" runat="server">
	-->	
			<xsl:if test="$DealerAcc/UserActivationState ='PendingActivation'">
				<fieldset style="margin-top:-10px;">
					<legend>Activation Info</legend>
					<div class="control-group">
						<label class="control-label">Activation link</label>
						<div class="controls">
							<a target="_blank">
								<xsl:attribute name="href">
									<xsl:value-of select="$DealerAcc/LoginMethod" />
								</xsl:attribute>
								<xsl:value-of select="$DealerAcc/LoginMethod" />
							</a>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Temporary SMS Password</label>
						<div class="controls">
							<input type="text" id="UserActivationTempPassword" name="UserActivationTempPassword" disabled="disabled" class="input-xlarge">
								<xsl:attribute name="value">
									<xsl:value-of select="$DealerAcc/UserActivationTempPassword" />
								</xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Activated By</label>
						<div class="controls">
							<input type="text" id="UserActivationBy" name="UserActivationBy" disabled="disabled" class="input-xlarge">
								<xsl:attribute name="value">
									<xsl:value-of select="$DealerAcc/UserActivationBy" />
								</xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Activated Time</label>
						<div class="controls">
							<input type="text" id="UserActivationTime" name="UserActivationTime" disabled="disabled" class="input-xlarge">
								<xsl:attribute name="value">
									<!-- <xsl:value-of select="$DealerAcc/UserActivationTime" /> -->
									<xsl:value-of select="umbraco.library:FormatDateTime($DealerAcc/UserActivationTime, 'yyyy-MM-dd HH:mm:ss')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
				</fieldset>
				<br />
			</xsl:if>
			<fieldset style="margin-top:-10px;">
				<legend>Login Details</legend>
				<div class="form-left">
					<div class="control-group">
						<label class="control-label">Login ID</label>
						<div class="controls">
							<input type="text" id="LoginID" name="LoginID" disabled="disabled" class="input-xlarge">
								<xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 20, messages: {required: 'Please enter the Login ID!'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="$DealerAcc/LoginName" />
								</xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">First name</label>
						<div class="controls">
							<input type="text" id="FirstName" name="FirstName" class="input-xlarge">
								<xsl:attribute name="data-validate">{required: false, minlength: 2, maxlength: 30, messages: {required: 'Please enter the First Name!'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
								<xsl:attribute name="data-validate">{required: false, minlength: 2, maxlength: 30, messages: {required: 'Please enter the Last Name!'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
					<div class="control-group">
						<label class="control-label"><span class="important">*</span> Login Email
							<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="Please make sure the email address is correct and that the customer actively uses it. Account activation emails will be sent to this address.">&nbsp;</i>
						</label>
						<div class="controls">
							<input type="text" id="LoginEmail" name="LoginEmail" class="input-xlarge email">
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
											<xsl:value-of select="$LoginEmail" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerAcc/EmailAddress" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label"><span class="important">*</span> Login Mobile No.
							<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="Please make sure the mobile number is correct. Security related SMS's the customer must receive in order to login will be sent to this number.">&nbsp;</i>
						</label>
						<div class="controls">
							<input type="text" id="LoginMobileNo" name="LoginMobileNo" class="input-xlarge">
								<xsl:attribute name="data-validate">{required: false, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'Please enter login mobile no'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
											<xsl:value-of select="$LoginMobileNo" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerAcc/ContactMobile" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>  
			</fieldset>
			
			<br />
			
			<fieldset>
				<legend>Company</legend>
				<div class="form-left">
					<div class="control-group">
						<label class="control-label"><span class="important">*</span> Company Name</label>
						<div class="controls">
							<input type="text" id="CompanyName" name="CompanyName" class="input-xlarge">
								<xsl:attribute name="data-validate">{required: false, minlength: 3, maxlength: 50, messages: {required: 'Please enter the Company Name.'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
											<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
								<xsl:attribute name="data-validate">{required: false, minlength: 6, maxlength: 20, messages: {required: 'Please enter the Company Registration No.'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
					<!--<div class="control-group">
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
					</div>-->
				</div>
				<div class="form-right">
					<div class="control-group">
						<label class="control-label">Display Address line 1</label>
						<div class="controls">
							<textarea id="DisplayAddressLine1" name="DisplayAddressLine1" class="input-xlarge" style="height:40px">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
									<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
								<xsl:attribute name="data-validate">{required: false, minlength: 2, maxlength: 50, messages: {required: 'Please enter the Billing Contact Name.'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
						<label class="control-label"> Billing Contact Phone No.</label>
						<div class="controls">
							<input type="text" id="BillingPhoneNo" name="BillingPhoneNo" value="" class="input-xlarge">
								<xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Billing Contact Phone No.'}}</xsl:attribute>
								<xsl:attribute name="value">
									<!-- <xsl:value-of select="$DealerActInfo/ContactPhone" /> -->
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
						<label class="control-label"><span class="important">*</span> Primary Email <i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="Invoices will be sent to this email">&nbsp;</i>
						</label>
						<div class="controls">
							<input type="text" id="BillingContactPrimaryEmail" name="BillingContactPrimaryEmail" class="input-xlarge email">
								<xsl:attribute name="value">
									<!-- <xsl:value-of select="$DealerActInfo/PrimaryEmail" /> -->
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
						<label class="control-label"> Secondary Email <i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="A copy of Invoices will be sent to this email">&nbsp;</i>
						</label>
						<div class="controls">
							<input type="text" id="BillingContactSecondaryEmail" name="BillingContactSecondaryEmail" class="input-xlarge email">
								<xsl:attribute name="value">
									<!-- <xsl:value-of select="$DealerActInfo/SecondaryEmail" /> -->
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
									<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
					<div class="control-group">
						<div id = "BillingCountrySelection">
							<span>
								<xsl:text>
								</xsl:text>
							</span>
						</div>
					</div>
				</div>
			</fieldset>
			<br />
			<fieldset>
				<legend>Lead Settings</legend>
				<div class="form-left">
					<xsl:if test="$DealerCustParent/Users/UserName != ''">
						<div class="control-group">
							<label class="control-label"> Lead Settings</label>
							<div class="controls">
								<input type="radio" name="LeadSetting" value="OwnSet" onclick="$('.LeadSettingsGroup').show();"> 
									 <xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
											<xsl:if test="$LeadSetting = 'OwnSet'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when>
										<xsl:when test="$DealerCustInfo/Users/LeadSetting = 'OwnSet'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:when> 
										<xsl:otherwise><xsl:attribute name="checked">checked</xsl:attribute></xsl:otherwise>
									</xsl:choose>
									Own settings
								</input>
								<br/>
								<input type="radio" name="LeadSetting" value="Inherit" onclick="$('.LeadSettingsGroup').hide();"> 
									 <xsl:choose>
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
											<xsl:if test="$LeadSetting = 'Inherit'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when>
										<xsl:when test="$DealerCustInfo/Users/LeadSetting = 'Inherit'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:when> 
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
									Inherit from <xsl:value-of select="$DealerCustParent/Users/DealerName" />
								</input>
							</div>
						</div>
					</xsl:if>
					<div class="control-group LeadSettingsGroup">
						<xsl:if test="$DealerCustInfo/Users/LeadSetting = 'Inherit'"><xsl:attribute name="style">display: none;</xsl:attribute></xsl:if> 
						<label class="control-label"> Lead Notifications By</label>
						<div class="controls">
							<select class="input-xlarge" id="LeadsNotificationBy" name="LeadsNotificationBy">
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">None,Email,Email and SMS</xsl:with-param>
									<xsl:with-param name="value">
										 <xsl:choose>
											<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
				<div class="form-right LeadSettingsGroup">
					<xsl:if test="$DealerCustInfo/Users/LeadSetting = 'Inherit'"><xsl:attribute name="style">display: none;</xsl:attribute></xsl:if> 
					<div class="LeadsEmailSet">
						<div class="control-group">
							<label class="control-label">
								<span class="important">*</span>&nbsp;Email Leads to
								<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="This is the email address lead notifications will be sent to."><xsl:text>
								</xsl:text></i>
							</label>
							<div class="controls">
								<input type="text" id="LeadsEmail1" name="LeadsEmail" class="input-xlarge email">
									<xsl:attribute name="value">
										 <xsl:choose>
											<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
											<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
												<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
												<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
												<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
												<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
										<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
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
			<!-- Return "No Parent found!" for error-->
			<xsl:if test="$DealerCustParent/error != ''">	
				<fieldset>
				 <!-- <textarea>
					<xsl:value-of select="$DealerCustParent/error" />
				</textarea>  -->
					<legend>Customer grouping</legend>
					<div class="form-left">
						<div class="CustomerChildList">
							<div class="control-group">
								<label class="control-label">
									&nbsp;Search customer
								</label>
								<div class="controls">
									<input type="text" id="SearchCustomer" class="input-xlarge" placeholder="Company Name/Login">
									</input>
								</div><br/>
								<div class="controls">
									<button type="button" id="AddNewCustChild" class="btn btn-info btn-small">
										<i class="icon-plus">&nbsp;</i>&nbsp;&nbsp;Add customer to the group
									</button>
								</div>
							</div>
							
							<!-- <textarea>
								<xsl:value-of select="$DealerCustChildList"/>
							</textarea> -->
							
							<xsl:choose>
								<xsl:when test="$IsPostBack = 'true' or $IsPostBackActAcc = 'true'">
									<xsl:for-each select="umbraco.library:Split($CustomerChildSourcePostBack,',')//value">
										<xsl:if test=". != ''">
											<xsl:variable name="NewControl" select="position()" />
											<div>
												<xsl:attribute name="class">control-group CustomerChildDiv<xsl:value-of select="$NewControl"/></xsl:attribute>
												<label class="control-label">
													<button type="button" class="btn btn-danger btn-small">
														 <xsl:attribute name="id">RemoveCustChild<xsl:value-of select="$NewControl"/></xsl:attribute>
														 <xsl:attribute name="onclick">$(".CustomerChildDiv<xsl:value-of select="$NewControl"/>").remove();</xsl:attribute> 
														<i class="icon-minus">&nbsp;</i>&nbsp;Remove</button>
												</label>
												<div class="controls">
													<input type="text" name="CustomerChildName" class="input-xlarge CustomerChildName" readonly="readonly">
														<xsl:attribute name="id">CustChild<xsl:value-of select="$NewControl"/></xsl:attribute>
														<xsl:attribute name="value"><xsl:value-of select="scripts:FixComma(.)"/></xsl:attribute>
													</input>
													<input type="hidden" name="CustomerChild" value ="{scripts:GetUserID(.)}" /> 
													<input type="hidden" name="CustomerChildSource" value ="{.}" />
												</div> 
											</div>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="$DealerCustChildList/ArrayOfCustUserInfo/CustUserInfo">
										<xsl:variable name="NewControl" select="position()" />
										<div>
											<xsl:attribute name="class">control-group CustomerChildDiv<xsl:value-of select="$NewControl"/></xsl:attribute>
											<label class="control-label">
												<button type="button" class="btn btn-danger btn-small">
													 <xsl:attribute name="id">RemoveCustChild<xsl:value-of select="$NewControl"/></xsl:attribute>
													 <xsl:attribute name="onclick">$(".CustomerChildDiv<xsl:value-of select="$NewControl"/>").remove();</xsl:attribute> 
													<i class="icon-minus">&nbsp;</i>&nbsp;Remove</button>
											</label>
											<div class="controls">
												<input type="text" name="CustomerChildName" class="input-xlarge CustomerChildName" readonly="readonly">
													<xsl:attribute name="id">CustChild<xsl:value-of select="$NewControl"/></xsl:attribute>
													<xsl:attribute name="value"><xsl:value-of select="./UserID"/>, <xsl:value-of select="./UserName"/></xsl:attribute>
												</input>
												<input type="hidden" name="CustomerChild" value ="{./UserID}" /> 
												<input type="hidden" name="CustomerChildSource" value ="{./UserID}|{./UserName}" />
											</div> 
										</div>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</div>
				</fieldset>
				<br />
			</xsl:if>
			<fieldset>
				<legend>Payment Details</legend>
				<xsl:if test="$DealerActInfo/CreditCardNo != ''">
					<div class="cc-fields radius" style=" padding: 10px 0 5px; margin-bottom: 20px; background: #EEE; ">
						<div class="control-group" style="margin:0">
							<label class="control-label"> Current Credit Card Info</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<xsl:choose>
								<xsl:when test="$DealerActInfo/CreditCardType = 'Visa'">
									<img class="retina" src="/images/payments/visa.png" alt="Visa" style="width:51px;height:32px" />
								</xsl:when>
								<xsl:otherwise> 
									<img class="retina" src="/images/payments/mastercard.png" alt="Mastercard" style="width:51px;height:32px" />
								</xsl:otherwise>
							</xsl:choose>&nbsp;&nbsp;<xsl:value-of select="$DealerActInfo/CreditCardNo" />
						</div>
					</div>
				</xsl:if>
				<div class="payment-type">
					<div class="control-group">
						<label class="control-label">
							<xsl:if test="$DealerActInfo/CreditCardNo != ''">
								Reset 
							</xsl:if>
							Payment Type</label>
						<div class="controls">
							<!-- <textarea>
								<xsl:value-of select="$DealerActInfo/PaymentPreference"/>
							</textarea> -->
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
									<xsl:if test="$DealerActInfo/PaymentPreference = '' or $DealerActInfo/PaymentPreference !='BPay'">
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
							<input type="text" class="input-xlarge" id="ccNo" name="ccNo" value="" maxlength="16" autocomplete="off">
								<xsl:attribute name="data-validate">{required: false, regex:/^\d{16}$/, minlength: 16, maxlength: 16, messages: {required: 'Please enter the Credit Card No.'}}</xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Card Holder Name</label>
						<div class="controls">
							<input type="text" class="input-xlarge" id="ccName" name="ccName" value="" autocomplete="off">
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
							<input type="password" id="ccCvv2" name="ccCvv2" maxlength="3" value="" class="input-small" autocomplete="off">
								<!-- <xsl:attribute name="data-validate">{required: true, regex:/^\d{3}$/, minlength: 3, maxlength: 3, messages: {required: 'Please enter CVV2'}}</xsl:attribute> -->
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
							<input type="radio" name="billing-preference" value="Advance">
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
			
			
			<input type="hidden" id="update-account" name="update-account" value="true" />
			<input type="hidden" id="activate-account" name="activate-account" value="false" />
			
			<div class="form-actions center">
				<!-- <a href="/dealers" class="btn btn-large"><i class="icon-chevron-left">&nbsp;</i> Back</a>
				&nbsp; -->
				<button type="submit" id="UpdateDealer" class="btn btn-large btn-success"><i class="icon-disk">&nbsp;</i> Save</button>
				<span class="hidden-phone">&nbsp;&nbsp;&nbsp;</span>
				<span class="visible-phone" style="display:block;height:10px;overflow:hidden">&nbsp;</span>
				
<!-- 				<xsl:if test="$DealerAcc/UserActivationState ='NotActivated'">
					<button type="submit" id="ActivateAcc" class="btn btn-large btn-info"><i class="icon-checkmark">&nbsp;</i>Send Activation Email/SMS</button>
				</xsl:if >
 -->		
				<button type="submit" id="ActivateAcc" class="btn btn-large btn-info"><i class="icon-checkmark">&nbsp;</i>Send Activation Email/SMS</button>
				<xsl:choose>
					<xsl:when test="$DealerAcc/UserActivationState ='NotActivated'">
						<!-- <button type="submit" id="ActivateAcc" class="btn btn-large btn-info"><i class="icon-checkmark">&nbsp;</i>Send Activation Email/SMS</button>--> 
					</xsl:when>
					<xsl:otherwise>
						<!-- Temporary Password : <xsl:value-of select="$DealerAcc/UserActivationTempPassword" /> -->
					</xsl:otherwise>
				</xsl:choose>
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
    
    <!-- C# helper scripts -->
    <msxml:script language="C#" implements-prefix="scripts">
        <![CDATA[
			public string FixComma(string s){
				return s.Replace("|", ",");
			}
			
			public string GetUserID(string s){
				var arrayData = s.Split('|');
				return arrayData[0].ToString();
			}
			
			public string GetUserName(string s){
				var arrayData = s.Split('|');
				var UserName = "";
				if (arrayData.Length > 1) UserName = arrayData[1].ToString();
				return UserName;
			}
		]]>
    </msxml:script>
		
</xsl:stylesheet>