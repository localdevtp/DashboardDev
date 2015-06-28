<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:scripts="urn:scripts.this"
xmlns:AccScripts="urn:AccScripts.this" 
xmlns:ActScripts="urn:ActScripts.this" 
xmlns:RESTscripts="urn:RESTscripts.this"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="html" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListCommonTemplate.xslt" />
	<xsl:include href="EasyListRestHelper.xslt" />
	<xsl:include href="EasyListHelper.xslt" />
	<xsl:include href="EasyListStaffHelper.xslt" />
	<xsl:include href="EasyListAccountHelper.xslt" />
	
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('IsPostBack')" />
	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('EasySales Admin')" />
	
	<xsl:variable name="ContactInfoSetting" select="umbraco.library:Request('ContactInfoSetting')" />
	<xsl:variable name="DisplayMobileOnAds" select="umbraco.library:Request('DisplayMobileOnAds')" />
	<xsl:variable name="DisplayNameOnAds" select="umbraco.library:Request('DisplayNameOnAds')" />
	<xsl:variable name="DisplayAddSettings" select="umbraco.library:Request('DisplayAddSettings')" />
	
	<xsl:variable name="RetailContactMobile" select="umbraco.library:Request('RetailContactMobile')" />
	<xsl:variable name="RetailFirstName" select="umbraco.library:Request('RetailFirstName')" />
	<xsl:variable name="RetailEmail" select="umbraco.library:Request('RetailEmail')" />
	
	<xsl:variable name="DisplayEmailOnAds" select="umbraco.library:Request('DisplayEmailOnAds')" />
	<xsl:variable name="DisplayEmailSettings" select="umbraco.library:Request('DisplayEmailSettings')" />
	
	<xsl:variable name="AddressLine1" select="umbraco.library:Request('AddressLine1')" />
	<xsl:variable name="AddressLine2" select="umbraco.library:Request('AddressLine2')" />
	<xsl:variable name="AddressSuburbStatePost" select="umbraco.library:Request('listing-location')" />
	
	<xsl:variable name="DisplayPhoneOnAds" select="umbraco.library:Request('DisplayPhoneOnAds')" />
	<xsl:variable name="BusinessPhoneNo" select="umbraco.library:Request('BusinessPhoneNo')" />
	<xsl:variable name="BusinessContactMobile" select="umbraco.library:Request('BusinessContactMobile')" />
	<xsl:variable name="DisplayFaxOnAds" select="umbraco.library:Request('DisplayFaxOnAds')" />
	<xsl:variable name="BusinessFaxNo" select="umbraco.library:Request('BusinessFaxNo')" />
	<xsl:variable name="BusinessName" select="umbraco.library:Request('BusinessName')" />
	<xsl:variable name="BusinessEmail" select="umbraco.library:Request('BusinessEmail')" />
	
	<xsl:variable name="DisplayAddLocMap" select="umbraco.library:Request('DisplayAddLocMap')" />
	
	<xsl:variable name="DisplayWebsiteOnAds" select="umbraco.library:Request('DisplayWebsiteOnAds')" />
	<xsl:variable name="DisplayWebsiteAdd" select="umbraco.library:Request('DisplayWebsiteAdd')" />
	
	<xsl:variable name="DisplaySumInfoOnAds" select="umbraco.library:Request('DisplaySumInfoOnAds')" />
	<xsl:variable name="DisplaySumInfo" select="umbraco.library:Request('DisplaySumInfo-textonly')" />
	<xsl:variable name="DisplaySumInfoWYSIWYG" select="umbraco.library:Request('DisplaySumInfo')" />
	
	<xsl:variable name="DisplayCompLogoOnAds" select="umbraco.library:Request('DisplayCompLogoOnAds')" />
	
	<xsl:variable name="DisplayCompABNACNOnAds" select="umbraco.library:Request('DisplayCompABNACNOnAds')" />
	<xsl:variable name="Company_TAC_Type" select="umbraco.library:Request('Company_TAC_Type')" />
	<xsl:variable name="Company_TAC_No" select="umbraco.library:Request('Company_TAC_No')" />
	
	<xsl:variable name="DisplayCompLicenseOnAds" select="umbraco.library:Request('DisplayCompLicenseOnAds')" />
	<xsl:variable name="CompDealerLicense" select="umbraco.library:Request('CompDealerLicense')" />
	
	<xsl:variable name="DisplayTradingHourOnAds" select="umbraco.library:Request('DisplayTradingHourOnAds')" />
	<xsl:variable name="DisplayTradingHourFrom" select="umbraco.library:Request('DisplayTradingHourFrom')" />
	<xsl:variable name="DisplayTradingHourTo" select="umbraco.library:Request('DisplayTradingHourTo')" />
	
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	
	
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		<!-- DO ANY PAGE LOAD PROCESSING HERE -->
		<xsl:call-template name="safety-and-privacy" />
		
	</xsl:template>
	
	<!-- SAFETY AND PRIVACY TEMPLATE -->
	<xsl:template name="safety-and-privacy" >
		<xsl:variable name="LoginID" select="umbraco.library:Session('easylist-username')" />
		
		<!-- Update if postback -->
		<xsl:if test="$IsPostBack = 'true'">
			<xsl:variable name="ErrMsg" select="AccScripts:UpdatePrivacyNSafety()" />
			<xsl:choose>
				<!-- Error -->
				<xsl:when test="string-length($ErrMsg) &gt; 0">
					<div class="alert alert-error">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Failed!</strong> Failed to update safety and privacy settings. Error : <xsl:copy-of select="$ErrMsg" />
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="alert alert-success">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Success!</strong> Your settings was updated successfully.
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		<xsl:variable name="DealerAccSource" select="AccScripts:GetDealerAccount($LoginID, 1)" />
		<xsl:variable name="DealerAcc" select="$DealerAccSource/User" />
		
		<xsl:variable name="DealerAccountingInfo" select="ActScripts:GetDealerAccountInfo($LoginID, 1)" />
		<xsl:variable name="DealerActInfo" select="$DealerAccountingInfo/ELAccInfo" />
		
		<xsl:variable name="DealerELUserInfoSource" select="AccScripts:GetMongoUserAccount($LoginID)" />
		<xsl:variable name="DealerELUserInfo" select="$DealerELUserInfoSource/Users" />
		<!-- 
  <textarea>
 <xsl:value-of select="$DealerAcc/UserType" />
 <xsl:value-of select="$DealerELUserInfo/DisplayCompTACNo" />
 <xsl:value-of select="$DealerActInfo/Company_TAC_No" />
 <xsl:value-of select="$DealerAccountingInfo" />
 
 <xsl:value-of select="not($DealerELUserInfo/ContactInfoSetting)" />
 <xsl:value-of select="($DealerELUserInfo/UserType ='Private' and (not($DealerELUserInfo/ContactInfoSetting) or $DealerELUserInfo/ContactInfoSetting = ''))" />
  </textarea> 
  -->
		<div class="widget-box">
			<div class="widget-title">
				<h2><i class="icon-eye-blocked">&nbsp;</i> Safety and Privacy Settings</h2>
			</div>      
			<!-- /widget-title -->
			
			<div class="widget-content">
				<form id="safety-and-privacy-form" class="form-horizontal" method="POST">
					
					<fieldset style="margin-top:-10px;">
						<legend title="How users are able to access your contact information?">How users are able to access your contact information?</legend>
						<label class="radio">
							<input type="radio" name="ContactInfoSetting" value="VERIFIEDMOBILE">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:if test = "$ContactInfoSetting = 'VERIFIEDMOBILE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
									</xsl:when> 
									<xsl:otherwise>
										<xsl:if test="$DealerELUserInfo/ContactInfoSetting = 'VERIFIEDMOBILE'  or ($DealerELUserInfo/UserType ='Private' and (not($DealerELUserInfo/ContactInfoSetting) or $DealerELUserInfo/ContactInfoSetting = ''))">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if> 
									</xsl:otherwise>
								</xsl:choose>
								Make my contact information available only to people who have verified their Australian mobile phone number.
							</input>
						</label>
						<label class="radio">
							<input type="radio" name="ContactInfoSetting" value="ALLUSER">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:if test = "$ContactInfoSetting = 'ALLUSER'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
									</xsl:when> 
									<xsl:otherwise>
										<xsl:if test="$DealerELUserInfo/ContactInfoSetting = 'ALLUSER' or ($DealerELUserInfo/UserType ='Business' and (not($DealerELUserInfo/ContactInfoSetting) or $DealerELUserInfo/ContactInfoSetting=''))">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if> 
									</xsl:otherwise>
								</xsl:choose>Make my contact information available to all buyers.
							</input>
						</label>
						<label class="radio">
							<input type="radio" name="ContactInfoSetting" value="HIDE">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:if test = "$ContactInfoSetting = 'HIDE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
									</xsl:when> 
									<xsl:otherwise>
										<xsl:if test="$DealerELUserInfo/ContactInfoSetting = 'HIDE'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if> 
									</xsl:otherwise>
								</xsl:choose>Do not show my contact information - I will provide it to buyers myself. Only show the email form to buyers.
							</input>
						</label>
						
						<br /><br />
					</fieldset>
					
					<!--  PRIVATE  -->
					<xsl:if test="$DealerAcc/UserType = 'Private'" >
						<fieldset>
							<legend title="What information you wish to publicly share with buyers?">What information you wish to publicly share with buyers?</legend>
							<label class="checkbox">
								<input type="checkbox" name="DisplayMobileOnAds-ForDisplayOnly" value="true" disabled="disabled" checked="checked">
                                    <!-- FREEM-80 mobile contact should always be made available to the public -->
									<!--<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayMobileOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayMobileOnAds = 'true' or not($DealerELUserInfo/DisplayMobileOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayMobileOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>-->
								</input>
                                <input type="hidden" name="DisplayMobileOnAds" value="true" />
								Display a phone number on my ads.
							</label>
							<aside class="child-controls"><label>Contact Phone: </label>
								<input type="text" name="RetailContactMobile" class="number">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$RetailContactMobile" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerActInfo/Display_ContactMobile" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
                                    <!-- FREEM-80 + FREEM-160 these make the mobile number a mandatory field -->
                                    <!--<xsl:attribute name="data-validate">{required: true, messages: {required: 'This field is required.'}}</xsl:attribute>-->
								</input>
								<label name='RetailContactMobileMsg'>This field is required.</label>
							</aside> 
							
							<label class="checkbox">
								<input type="checkbox" name="DisplayNameOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayNameOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayNameOnAds = 'true' or not($DealerELUserInfo/DisplayNameOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayNameOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Display my name on my ads.
							</label>
							<aside class="child-controls"><label>Name: </label>
								<input type="text" name="RetailFirstName" >
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$RetailFirstName" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerActInfo/Display_CompanyName" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</aside>
							
							<hr />
							
							<div class="fixed-controls">
								<label>Address line 1: </label>
								<textarea id="AddressLine1" name="AddressLine1" class="input-xlarge" style="height:50px">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$AddressLine1" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerActInfo/Display_Address1" />
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>&nbsp;</xsl:text>
								</textarea>
								<br/>
								<label>Address line 2: </label>
								<textarea id="AddressLine2" name="AddressLine2" class="input-xlarge" style="height:50px">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$AddressLine2" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerActInfo/Display_Address2" />
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>&nbsp;</xsl:text>
								</textarea>
								<br/>
								<label>Suburb, State Postcode: </label>
								<input class="text allow-lowercase" type="text" maxlength="50" id="listing-location"  name="listing-location" autocomplete="off" placeholder="Suburb, State Postcode" disable-output-escaping="yes">
									<!--<xsl:attribute name="data-validate">{required: false, regex:/^(?:[A-Za-z0-9\s]*)(?:,)(?:[A-Za-z0-9\s]*)(?:\s)(?:[0-9]*)*$/, minlength: 1, maxlength: 50, messages: {required: 'Please enter the location', regex: 'Please enter a valid location (e.g. Sydney, NSW 2000)'}}</xsl:attribute>-->
									<xsl:attribute name="data-validate">{required: false, minlength: 1, maxlength: 50, messages: {required: 'This field is required.'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$AddressSuburbStatePost" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="$DealerActInfo/Display_CityTown != '' and $DealerActInfo/Display_StateProvince != '' and $DealerActInfo/Display_PostalCode != ''">
														<xsl:value-of select="$DealerActInfo/Display_CityTown" />,<xsl:text> </xsl:text><xsl:value-of select="$DealerActInfo/Display_StateProvince" /><xsl:text> </xsl:text><xsl:value-of select="$DealerActInfo/Display_PostalCode" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:text> </xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
							
							<label class="radio">
								<input type="radio" name="DisplayAddSettings" value="CITYNSTATE">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayAddSettings = 'CITYNSTATE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:otherwise>
											<xsl:if test="$DealerELUserInfo/DisplayAddSettings = 'CITYNSTATE'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if> 
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Display my <strong>city and state</strong> only on my ads.
							</label>
							<label class="radio">
								<input type="radio" name="DisplayAddSettings" value="FULLADD"> 
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayAddSettings = 'FULLADD'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:otherwise>
											<xsl:if test="$DealerELUserInfo/DisplayAddSettings = 'FULLADD' or not($DealerELUserInfo/DisplayAddSettings)">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if> 
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Display my <strong>full street address</strong> on my ads.
							</label>
							<!--<aside class="child-controls"><label>Full street address: </label>
   <textarea name="share-street-address" style="height=10em;"><xsl:value-of select="$DealerAcc/Address1" /><xsl:value-of select="$DealerAcc/Address2" />
  </textarea></aside>-->
							
							<hr />
							<!-- TODO: Temoorary hide first -->
							<div style="display:none">
								<label class="checkbox">
									<input type="checkbox" name="DisplayEmailOnAds" value='true'> 
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test = "$DisplayEmailOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
											</xsl:when> 
											<xsl:when test="$DealerELUserInfo/DisplayEmailOnAds = 'true' or not($DealerELUserInfo/DisplayEmailOnAds)">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Display an email contact form on my ads.
								</label>
								<label class="radio">
									<input type="radio" name="DisplayEmailSettings" value="SHARE">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test = "$DisplayEmailSettings = 'SHARE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
											</xsl:when> 
											<xsl:when test="$DealerELUserInfo/DisplayEmailSettings = 'SHARE' or not($DealerELUserInfo/DisplayEmailSettings)">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:when> 
											<xsl:otherwise>
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Share my email address with buyers who contact me via email.
								</label>
								<aside class="child-controls">
									<label>Email address: </label>
									<input type="text" name="RetailEmail" class="email">
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'">
													<xsl:value-of select="$RetailEmail" />
												</xsl:when>
												<xsl:otherwise><xsl:value-of select="$DealerActInfo/Display_PrimaryEmail" /></xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</input>
								</aside>
								<label class="radio">
									<input type="radio" name="DisplayEmailSettings" value="NOTSHARE" >
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test = "$DisplayEmailSettings = 'NOTSHARE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
											</xsl:when> 
											<xsl:otherwise>
												<xsl:if test="$DealerELUserInfo/DisplayEmailSettings = 'NOTSHARE'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if> 
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Do not provide buyers with my email address.
								</label>
							</div>
							<br /><br />
						</fieldset>
					</xsl:if>
					<!-- /PRIVATE -->
					
					<!--  COMMERCIAL -->
					<xsl:if test="$DealerAcc/UserType = 'Business'" >
						<fieldset>
							<legend title="What information you wish to publicly display?">What information you wish to publicly display?</legend>
							<!-- Company Phone No -->
							<textarea style="display:none">
								<xsl:value-of select="$DealerELUserInfo/DisplayPhoneOnAds" />
								<xsl:value-of select="not($DealerELUserInfo/DisplayPhoneOnAds)" />
							</textarea>
							<label class="checkbox">
								
								<input type="checkbox" id="chkDisplayPhoneOnAds" name="DisplayPhoneOnAds-ForDisplayOnly" value="true" disabled=""  checked="checked">
									 <!-- FREEM-80 contact should always be made available to the public -->
                                    <!--<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayPhoneOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayPhoneOnAds = 'true' or not($DealerELUserInfo/DisplayPhoneOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayPhoneOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>-->
								</input>
                                <input type="hidden" name="DisplayPhoneOnAds" value="true" />
								Phone number.
							</label>
							
							<aside class="child-controls"><label>Phone number: </label>
								<input type="text" name="BusinessPhoneNo" class="number">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$BusinessPhoneNo" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerActInfo/Display_ContactPhone" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
                                    <!-- FREEM-80 + FREEM-160 these make the mobile number a mandatory field -->
                                    <!--<xsl:attribute name="data-validate">{required: true, messages: {required: 'This field is required.'}}</xsl:attribute>-->
								</input>
								<label name='BusinessPhoneNoMsg'>This field is required.</label>
							</aside> 
							<!-- Company Fax No -->
							<label class="checkbox">
								<input type="checkbox" name="DisplayFaxOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayFaxOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayFaxOnAds = 'true' or not($DealerELUserInfo/DisplayFaxOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayFaxOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Fax number.
							</label>
							<aside class="child-controls"><label>Fax number: </label>
								<input type="text" name="BusinessFaxNo" class="number">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$BusinessFaxNo" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerELUserInfo/DisplayFaxNo" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</aside>
							<!-- Company Mobile No -->
							<label class="checkbox">
								<input type="checkbox" name="DisplayMobileOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayMobileOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayMobileOnAds = 'true' or not($DealerELUserInfo/DisplayMobileOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayMobileOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Mobile number.
							</label>
							<aside class="child-controls"><label>Mobile number: </label>
								<input type="text" name="BusinessContactMobile" class="number">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$BusinessContactMobile" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerActInfo/Display_ContactMobile" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</aside> 
							<!-- Company Business Name -->
							<label class="checkbox">
								<input type="checkbox" name="DisplayNameOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayNameOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayNameOnAds = 'true' or not($DealerELUserInfo/DisplayNameOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayNameOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>  
								Business name.
							</label>
							<aside class="child-controls"><label>Business name: </label>
								<input type="text" name="BusinessName">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$BusinessName" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerActInfo/Display_CompanyName" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</aside>
							
							<hr />
							
							<div class="fixed-controls">
								<label>Address line 1: </label>
								<textarea id="AddressLine1" name="AddressLine1" class="input-xlarge" style="height:50px">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$AddressLine1" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerActInfo/Display_Address1" />
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>&nbsp;</xsl:text>
								</textarea>
								<br/>
								<label>Address line 2: </label>
								<textarea id="AddressLine2" name="AddressLine2" class="input-xlarge" style="height:50px">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$AddressLine2" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$DealerActInfo/Display_Address2" />
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>&nbsp;</xsl:text>
								</textarea>
								<br/>
								<label>Suburb, State Postcode: </label>
								<input class="text allow-lowercase" type="text" maxlength="50" id="listing-location"  name="listing-location" autocomplete="off" placeholder="Suburb, State Postcode" disable-output-escaping="yes">
									<!--<xsl:attribute name="data-validate">{required: false, regex:/^(?:[A-Za-z0-9\s]*)(?:,)(?:[A-Za-z0-9\s]*)(?:\s)(?:[0-9]*)*$/, minlength: 1, maxlength: 50, messages: {required: 'Please enter the location', regex: 'Please enter a valid location (e.g. Sydney, NSW 2000)'}}</xsl:attribute>-->
									<xsl:attribute name="data-validate">{required: true, minlength: 1, maxlength: 50, messages: {required: 'This field is required.'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$AddressSuburbStatePost" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="$DealerActInfo/Display_CityTown != '' and $DealerActInfo/Display_StateProvince != '' and $DealerActInfo/Display_PostalCode != ''">
														<xsl:value-of select="$DealerActInfo/Display_CityTown" />,<xsl:text> </xsl:text><xsl:value-of select="$DealerActInfo/Display_StateProvince" /><xsl:text> </xsl:text><xsl:value-of select="$DealerActInfo/Display_PostalCode" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:text> </xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
							
							<label class="radio">
								<input type="radio" name="DisplayAddSettings" value="CITYNSTATE">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayAddSettings = 'CITYNSTATE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:otherwise>
											<xsl:if test="$DealerELUserInfo/DisplayAddSettings = 'CITYNSTATE'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if> 
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Display my <strong>city and state</strong> only on my ads.
							</label>
							<label class="radio">
								<input type="radio" name="DisplayAddSettings" value="FULLADD"> 
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayAddSettings = 'FULLADD'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:otherwise>
											<xsl:if test="$DealerELUserInfo/DisplayAddSettings = 'FULLADD' or not($DealerELUserInfo/DisplayAddSettings)">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if> 
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Display my <strong>full street address</strong> on my ads.
							</label>
							
							<!-- <aside class="child-controls"><label>Full street address: </label><textarea name="share-com-street-address">&nbsp;</textarea></aside> -->
							
							<!-- TODO : Temporary hide -->
							<div>
								<label class="checkbox">
									<input type="checkbox" name="DisplayAddLocMap" value="true">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test="$DisplayAddLocMap = 'true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="$DealerELUserInfo/DisplayAddLocMap = 'true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Display a location map with directions feature.
								</label>
							</div>
							<hr />
							<!-- TODO: Temoorary hide first -->
							<div style="display:none">
								<label class="checkbox">
									<input type="checkbox" name="DisplayEmailOnAds" value='true'> 
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test = "$DisplayEmailOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
											</xsl:when> 
											<xsl:when test="$DealerELUserInfo/DisplayEmailOnAds = 'true' or not($DealerELUserInfo/DisplayEmailOnAds)">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:when>
											<xsl:when test="$DealerELUserInfo/DisplayEmailOnAds = 'false'"></xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Display an email contact form on my ads.
								</label>
								
								<label class="radio">
									<input type="radio" name="DisplayEmailSettings" value="SHARE">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test = "$DisplayEmailSettings = 'SHARE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
											</xsl:when> 
											<xsl:otherwise>
												<xsl:if test="$DealerELUserInfo/DisplayEmailSettings = 'SHARE' or not($DealerELUserInfo/DisplayEmailSettings)">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if> 
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Share my email address with buyers who contact me via email.
								</label>
								
								<aside class="child-controls">
									<label>Email address: </label>
									<!-- <input type="text" name="BusinessEmail" class="email"> -->
									<input type="text" name="BusinessEmail">
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'">
													<xsl:value-of select="$BusinessEmail" />
												</xsl:when>
												<xsl:otherwise><xsl:value-of select="$DealerActInfo/Display_PrimaryEmail" /></xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</input>
								</aside>
								
								<label class="radio">
									<input type="radio" name="DisplayEmailSettings" value="NOTSHARE" >
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test = "$DisplayEmailSettings = 'NOTSHARE'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
											</xsl:when> 
											<xsl:otherwise>
												<xsl:if test="$DealerELUserInfo/DisplayEmailSettings = 'NOTSHARE'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if> 
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Do not provide buyers with my email address.
								</label>
								
								<hr />
							</div>
							<label class="checkbox">
								<input type="checkbox" name="DisplayWebsiteOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayWebsiteOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayWebsiteOnAds = 'true' or not($DealerELUserInfo/DisplayWebsiteOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayWebsiteOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input> 
								Display my website address.
							</label>
							<aside class="child-controls">
								<label>Website address: </label>
								<input type="text" name="DisplayWebsiteAdd">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$DisplayWebsiteAdd" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerELUserInfo/DisplayWebsite" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</aside>
							
							<hr />
							
							<label class="checkbox">
								<input type="checkbox" name="DisplaySumInfoOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplaySumInfoOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplaySumInfoOnAds = 'true' or not($DealerELUserInfo/DisplaySumInfoOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplaySumInfoOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>  
								Display summary information about my business, products and services.
							</label>
							<aside class="child-controls">
								<textarea id="DisplaySumInfo" data-wysiwyg="true" name="DisplaySumInfo" class="summary span8" rows="10" cols="40">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$DisplaySumInfoWYSIWYG" /></xsl:when> 
										<xsl:otherwise><xsl:value-of select="$DealerELUserInfo/DisplaySumInfoWYSIWYG" /></xsl:otherwise>
									</xsl:choose>
									&nbsp;
								</textarea>
							</aside>
							
							<hr />
							
							<label class="checkbox">
								<input type="checkbox" name="DisplayCompLogoOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayCompLogoOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayCompLogoOnAds = 'true' or not($DealerELUserInfo/DisplayCompLogoOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayCompLogoOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>  
								Display my company logo.
							</label>
							<!-- <textarea>
 <xsl:value-of select="$DealerELUserInfo/DisplayCompLogo" />
  </textarea> -->
							<aside class="child-controls">
								<div class="clearfix">
									<!-- If you need to adjust the size, please do it in the inline css in umbraco template -->
									<div id ="DisplayCompLogoContainer" style="">
										<div class="thumbnail" style="">
											<!-- <img src="http://placehold.it/600x125&amp;text=Dealer+Banner" alt=""> -->
											<img alt="CompanyLogo">
												<xsl:attribute name="src">
													<xsl:choose>
														<xsl:when test="$DealerELUserInfo/DisplayCompLogo = ''or not($DealerELUserInfo/DisplayCompLogo)">
															<xsl:text>http://placehold.it/600x125&amp;text=Dealer+Banner</xsl:text>
														</xsl:when> 
														<xsl:when test="$DealerELUserInfo/DisplayCompLogo != ''">
															<xsl:value-of select="$DealerELUserInfo/DisplayCompLogo" />
														</xsl:when> 
														<xsl:otherwise>
															<xsl:text>http://placehold.it/600x125&amp;text=Dealer+Banner</xsl:text>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
											</img>
										</div>
									</div>
								</div>
								<!-- <input type="file" name="bulk-upload-file" title="Choose your image" class="file-input primary" />  -->
								<a class="btn btn-primary push-bottom" id="upload-photo" href="#">
									<i class="icon-camera">&nbsp;</i> Choose your image
								</a>
								<br /><br />
								<small>
									Update Settings to upload your new logo.<br />
									Only JPEG(.jpg,.jpeg) and PNG(.png) image are supported.
								</small>
							</aside>
							
							<hr />
							
							<label class="checkbox">
								<input type="checkbox" name="DisplayCompABNACNOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayCompABNACNOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayCompABNACNOnAds = 'true' or not($DealerELUserInfo/DisplayCompABNACNOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayCompABNACNOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Display my ABN/ACN number.
							</label>
							<aside class="child-controls">
								<label>Company Registration: </label>
								<!-- <input type="text" name="display-com-abn-acn-number">
 </input>
 <input type="text" name="CompABNACNNumber">
   <xsl:attribute name="value">
  <xsl:choose>
 <xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$CompABNACNNumber" /></xsl:when> 
 <xsl:otherwise><xsl:value-of select="$DealerActInfo/Company_TAC_No" /></xsl:otherwise>
  </xsl:choose>
   </xsl:attribute>
 </input> -->
								
								<select class="input-xlarge input-prefix-select" id="Company_TAC_Type" name="Company_TAC_Type">
									<xsl:call-template name="optionlist">
										<xsl:with-param name="options">ABN,ACN,RBN</xsl:with-param>
										<xsl:with-param name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$Company_TAC_Type" /></xsl:when> 
												<xsl:otherwise><xsl:value-of select="$DealerActInfo/Company_TAC_Type" /></xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
								</select>
								<input type="text" id="Company_TAC_No" name="Company_TAC_No" class="input-xlarge input-prefix-select">
									<xsl:attribute name="data-validate">{minlength: 6, maxlength: 20, messages: {required: 'Please enter the Company Registration No.'}}</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$Company_TAC_No" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerActInfo/Company_TAC_No" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
								
							</aside> 
							
							<label class="checkbox">
								<input type="checkbox" name="DisplayCompLicenseOnAds" value="true">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test = "$DisplayCompLicenseOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
										</xsl:when> 
										<xsl:when test="$DealerELUserInfo/DisplayCompLicenseOnAds = 'true' or not($DealerELUserInfo/DisplayCompLicenseOnAds)">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$DealerELUserInfo/DisplayCompLicenseOnAds = 'false'"></xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>
								Dealer license number.
							</label>
							<aside class="child-controls">
								<label>Dealer license number: </label>
								<input type="text" name="CompDealerLicense">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$CompDealerLicense" /></xsl:when> 
											<xsl:otherwise><xsl:value-of select="$DealerActInfo/Company_Dealer_License" /></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</aside>
							
							<hr />
							<!-- TODO : Temporary hide -->
							<div style="display:none">
								<label class="checkbox">
									<input type="checkbox" name="DisplayTradingHourOnAds" value="true">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test = "$DisplayTradingHourOnAds = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
											</xsl:when> 
											<xsl:when test="$DealerELUserInfo/DisplayTradingHourOnAds = 'true' or not($DealerELUserInfo/DisplayTradingHourOnAds)">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:when>
											<xsl:when test="$DealerELUserInfo/DisplayTradingHourOnAds = 'false'"></xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Display my trading hours.
								</label>
								<aside class="child-controls">
									<label>From: </label>
									<input type="time" name="DisplayTradingHourFrom">
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$DisplayTradingHourFrom" /></xsl:when> 
												<xsl:otherwise><xsl:value-of select="$DealerELUserInfo/DisplayTradingHourFrom" /></xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</input>
									<br />
									<label>To: </label>
									<input type="time" name="DisplayTradingHourTo">
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$DisplayTradingHourTo" /></xsl:when> 
												<xsl:otherwise><xsl:value-of select="$DealerELUserInfo/DisplayTradingHourTo" /></xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</input>
								</aside>
							</div>
							<br /><br />
						</fieldset>
					</xsl:if>
					<!-- /COMMERCIAL -->
					
					<!-- Form Actions -->
					<div class="form-actions center">
						<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
						<button type="submit" id="save-btn" class="btn btn-large btn-success"><i class="icon-disk">&nbsp;</i> Update Settings</button>
					</div>
					<!-- /Form Actions -->
				</form>
				
			</div>
			<!-- /widget-content -->
			
		</div>
		<!-- /widget-box -->
		
		
	</xsl:template>
	<!-- /SAFETY AND PRIVACY TEMPLATE -->
	
</xsl:stylesheet>