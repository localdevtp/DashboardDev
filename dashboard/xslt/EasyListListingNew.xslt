<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:scripts="urn:scripts.this"
xmlns:RESTscripts="urn:RESTscripts.this"
xmlns:AccScripts="urn:AccScripts.this"
xmlns:LiScripts="urn:LiScripts.this"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="html" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListCategoryTree.xslt" />
	<xsl:include href="EasyListRestHelper.xslt" />
	<xsl:include href="EasyListStaffHelper.xslt" />
	<xsl:include href="EasyListListingHelper.xslt" />
	
	<xsl:variable name="UserType" select="/macro/UserType" />
	
	<xsl:variable name="IsRetailUser" select="AccScripts:IsRetailUser()" />
	
	<xsl:variable name="dealerIDList" select="umbraco.library:Session('easylist-usercodelist')" />
	<xsl:variable name="HasChildList" select="scripts:HasChildList($dealerIDList)"/>
	
	<xsl:variable name="CatPath" select="umbraco.library:RequestQueryString('CatPath')" />
	<xsl:variable name="CatInfo" select="RESTscripts:GetCatInfo($CatPath)" />
	<xsl:variable name="CatSel" select="umbraco.library:RequestQueryString('CatSel')" />
	
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('IsPostBack') = 'true'" />
	<xsl:variable name="PublishListing" select="umbraco.library:Request('PublishListing') = 'true'" />
	<xsl:variable name="CheckoutListing" select="umbraco.library:Request('CheckoutListing') = 'true'" />
	
	<xsl:variable name="LstCatalogID" select="umbraco.library:Request('listing-catalog')" />
	<xsl:variable name="LstUserCode" select="umbraco.library:Request('listing-usercode')" />
	
	<xsl:variable name="LstTitle" select="umbraco.library:Request('listing-title')" />
	<xsl:variable name="LstSumDesc" select="umbraco.library:Request('listing-summary')" />
	<xsl:variable name="LstDesc" select="umbraco.library:Request('listing-description')" />
	
	<xsl:variable name="LstPrice" select="umbraco.library:Request('listing-price')" />
	<xsl:variable name="LstWasPrice" select="umbraco.library:Request('listing-was-price')" />
	
	<xsl:variable name="LstDriveAwayPrice" select="umbraco.library:Request('listing-driveaway-price')" />
	<xsl:variable name="LstSalePrice" select="umbraco.library:Request('listing-sale-price')" />
	<xsl:variable name="LstUnqualifiedPrice" select="umbraco.library:Request('listing-unqualified-price')" />
	
	<xsl:variable name="LstContactName" select="umbraco.library:Request('listing-contact-name')" />
	<xsl:variable name="LstContactEmail" select="umbraco.library:Request('listing-contact-email')" />
	<xsl:variable name="LstContactPhone" select="umbraco.library:Request('listing-contact-phone')" />
	
	<xsl:variable name="LstPriceQualifier" select="umbraco.library:Request('listing-price-qualifier')" />
	<xsl:variable name="LstCondition" select="umbraco.library:Request('listing-condition')" />
	<xsl:variable name="LstConditionDesc" select="umbraco.library:Request('listing-condition-desc')" />
	<xsl:variable name="LstStockNumber" select="umbraco.library:Request('listing-stock-number')" />
	<xsl:variable name="LstLocation" select="umbraco.library:Request('listing-location')" />
	<xsl:variable name="LstPublish" select="umbraco.library:Request('listing-publish')" />
	
	<xsl:variable name="LstVehicleReg" select="umbraco.library:Request('listing-vehicle-registered')" />
	<xsl:variable name="LstRegExpMth" select="umbraco.library:Request('listing-vehicle-expiry-month')" />
	<xsl:variable name="LstRegExpYear" select="umbraco.library:Request('listing-vehicle-expiry-year')" />
	<xsl:variable name="LstRegNo" select="umbraco.library:Request('listing-vehicle-rego')" />
	<xsl:variable name="LstVinNo" select="umbraco.library:Request('listing-vehicle-VIN')" />
	
	<xsl:variable name="LstVinEngine" select="umbraco.library:Request('listing-vehicle-VinEngine')" />
	
<!-- 	<xsl:variable name="LstVinEngineNo" select="umbraco.library:Request('listing-vehicle-VinEngine-No')" /> -->
	<xsl:variable name="LstVinEngineVinNo" select="umbraco.library:Request('listing-vehicle-VinEngine-VIN')" />
	<xsl:variable name="LstVinEngineEngineNo" select="umbraco.library:Request('listing-vehicle-VinEngine-Engine')" />
	
	<xsl:variable name="LstVehicleCert" select="umbraco.library:Request('listing-vehicle-cert')" />
	
	<xsl:variable name="LstBodyStyle" select="umbraco.library:Request('listing-body-style')" />
	<xsl:variable name="LstDoors" select="umbraco.library:Request('listing-doors')" />
	<xsl:variable name="LstSeats" select="umbraco.library:Request('listing-seats')" />
	<xsl:variable name="LstBodyDesc" select="umbraco.library:Request('listing-body-style-description')" />
	<xsl:variable name="LstExtColor" select="umbraco.library:Request('listing-exterior-colour')" />
	<xsl:variable name="LstIntColor" select="umbraco.library:Request('listing-interior-colour')" />
	<xsl:variable name="LstOdometer" select="umbraco.library:Request('listing-odometer-value')" />
	<xsl:variable name="LstOdometerUnit" select="umbraco.library:Request('listing-odometer-unit')" />
	<!-- <xsl:variable name="LstRegNo" select="umbraco.library:Request('listing-registration-number')" /> -->
	<xsl:variable name="LstVinNumber" select="umbraco.library:Request('listing-vinnumber')" />
	<xsl:variable name="LstRegType" select="umbraco.library:Request('listing-registration-type')" />
	<xsl:variable name="LstDriveType" select="umbraco.library:Request('listing-drive-type')" />
	<xsl:variable name="LstTransType" select="umbraco.library:Request('listing-transmission-type')" />
	<xsl:variable name="LstTransDesc" select="umbraco.library:Request('listing-transmission-description')" />
	<xsl:variable name="LstEngType" select="umbraco.library:Request('listing-engine-type-description')" />
	<xsl:variable name="LstEngCylinder" select="umbraco.library:Request('listing-engine-cylinders')" />
	<xsl:variable name="LstEngSize" select="umbraco.library:Request('listing-engine-size-description')" />
	<xsl:variable name="LstFuelType" select="umbraco.library:Request('listing-fuel-type-description')" />
	<xsl:variable name="LstGears" select="umbraco.library:Request('listing-gears')" />
	
	<xsl:variable name="TermsAndConditions" select="umbraco.library:Request('terms-and-conditions')" />
	
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		
		<xsl:call-template name="LoadPage" />
		
	</xsl:template>
	
	<xsl:template name="LoadPage">
		<xsl:choose>
			<xsl:when test="$CheckoutListing = 'true'">
				<!-- Save listing and redirec to checkout -->
				<xsl:variable name="NewListingTempDraftResponse" select="RESTscripts:NewListingTempDraft($IsRetailUser)" />
				<xsl:choose>
					<!-- Success -->
					<xsl:when test="substring-before($NewListingTempDraftResponse, ':') = 'SUCCESS'">
						<xsl:value-of select="scripts:RedirectTo('checkout')" />
					</xsl:when>
					<!-- Error -->
					<xsl:otherwise>
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Failed!</strong> Failed to create new listing. Error : <xsl:copy-of select="$NewListingTempDraftResponse" />
						</div>
						<xsl:call-template name="NewListingEditor" />
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			
			<xsl:when test="$PublishListing = 'true'">
				<xsl:variable name="NewListingTempPubResponse" select="RESTscripts:NewListingTempPublish($IsRetailUser)" />
				<xsl:choose>
					<!-- Success -->
					<xsl:when test="substring-before($NewListingTempPubResponse, ':') = 'SUCCESS'">
						<xsl:variable name="successUrl" select="concat('/listings/edit?IsNew=true&amp;listing=', substring-after($NewListingTempPubResponse, ':'))" />
						<xsl:value-of select="scripts:RedirectTo($successUrl)" />
					</xsl:when>
					<!-- Error -->
					<xsl:otherwise>
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Failed!</strong> Failed to publish new listing. Error : <xsl:copy-of select="$NewListingTempPubResponse" />
						</div>
						<xsl:call-template name="NewListingEditor" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="$IsPostBack = 'true'">
				<xsl:variable name="NewListingTempDraftResponse" select="RESTscripts:NewListingTempDraft($IsRetailUser)" />
				<xsl:choose>
					<!-- Success -->
					<xsl:when test="substring-before($NewListingTempDraftResponse, ':') = 'SUCCESS'">
						<xsl:choose>
							<xsl:when test="$IsRetailUser != 'true'">
								<xsl:variable name="successUrl" select="concat('/listings/edit?IsNew=true&amp;listing=', substring-after($NewListingTempDraftResponse, ':'))" />
								<xsl:value-of select="scripts:RedirectTo($successUrl)" />
							</xsl:when>
							<xsl:otherwise>
								<div class="alert alert-success">
									<button data-dismiss="alert" class="close" type="button">×</button>
									<strong>Success!</strong> Success! Your ad has been saved for 48 hours. <br/> To retrieve it, just select New Listing from the homepage.
								</div>
								<xsl:call-template name="NewListingEditor" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- Error -->
					<xsl:otherwise>
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Failed!</strong> Failed to create new listing. Error : <xsl:copy-of select="$NewListingTempDraftResponse" />
						</div>
						<xsl:call-template name="NewListingEditor" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when> 
			<xsl:otherwise>
				<xsl:call-template name="NewListingEditor">
					<xsl:with-param name="copyFrom" select="umbraco.library:RequestQueryString('copyFrom')" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="NewListingEditor">
		<xsl:param name="copyFrom" />
		
		<xsl:variable name="NewListingLoadResponse">
			<xsl:choose>
				<xsl:when test="$copyFrom != '' and $IsRetailUser = 'true'">
					<xsl:copy-of select="RESTscripts:NewListingCopyFrom($IsRetailUser, $copyFrom)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="RESTscripts:NewListingTempLoad()" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<!-- Success -->
			<xsl:when test="string-length(msxml:node-set($NewListingLoadResponse)/error) &gt; 0 and $copyFrom != '' and $IsRetailUser = 'true'">
				<div class="alert alert-error">
					<button data-dismiss="alert" class="close" type="button">×</button>
					<strong>Failed!</strong> Failed to create new listing. Error : <xsl:copy-of select="msxml:node-set($NewListingLoadResponse)/error" />
				</div>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:variable name="data" select="msxml:node-set($NewListingLoadResponse)/ListingsRestInfo" />
				
				<div class="widget-box">
					<div class="widget-title">
						<h2>
							<i class="icon-asterisk">
								<xsl:text>
								</xsl:text>
							</i> Create New Listing
						</h2>
					</div>
					
					<div class="widget-content">
						<form id ="new-listing" class="form-horizontal break-desktop-large" method="post">
							
							<!-- FORM CONTENT TEMPLATE CALLS -->
							<div style="margin-top:-10px">
								<xsl:call-template name="Catalog">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="Category">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="GMListingTpm">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="AutomotiveListing">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="MotorcycleListing">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="CustomMakeModelListing">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="ListingAdditionalInfo">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="GeneralDetails">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="ContactDetails">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="MediaImages">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<xsl:call-template name="MediaVideos">
									<xsl:with-param name="data" select="$data" />
								</xsl:call-template>
								<!-- <xsl:call-template name="AdsDistribution" /> -->
							</div>
							<!-- /FORM CONTENT TEMPLATE CALLS -->
							
							<div class="form-actions center">
								<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
								<input type="hidden" id="PublishListing" name="PublishListing" value="false" />
								<input type="hidden" id="CheckoutListing" name="CheckoutListing" value="false" />
								<input id="IsRetailUser" type="hidden" name="IsRetailUser" value="{$IsRetailUser}" />
								
								<input type="hidden" id="reset-car-attr" name="reset-car-attr">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$data/LstType = 'Car' and string-length($data/VehicleListing/Make) &gt; 0">false</xsl:when>
											<xsl:when test="$data/LstType = 'Motorcycle' and string-length($data/VehicleListing/Make) &gt; 0">false</xsl:when>
											<xsl:when test="$data/LstType = 'General'">false</xsl:when>
											<xsl:otherwise>true</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
								
								<xsl:choose>
									<xsl:when test="$IsRetailUser = 'true'">
										<button type="submit" id="submit" class="btn btn-large btn-success ignore-load">
											<i class="icon-disk">&nbsp;</i> Save for later
										</button>
										<span class="hidden-phone">&nbsp;&nbsp;&nbsp;</span>
										<span class="visible-phone" style="display:block;height:10px;overflow:hidden">&nbsp;</span>
										
										<button type="submit" id="checkout" class="btn btn-large btn-info ignore-load">
											<i class="icon-checkmark">&nbsp;</i>Checkout
										</button>
									</xsl:when>
									<xsl:when test="$IsRetailUser != 'true'">
										<button type="submit" id="submit" class="btn btn-large btn-success ignore-load">
											<i class="icon-disk">&nbsp;</i> Save as Draft
										</button>
										<span class="hidden-phone">&nbsp;&nbsp;&nbsp;</span>
										<span class="visible-phone" style="display:block;height:10px;overflow:hidden">&nbsp;</span>
										
										<button type="submit" id="publish" class="btn btn-large btn-info ignore-load">
											<i class="icon-checkmark">&nbsp;</i>Publish Ad
										</button>
									</xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
								<div id="status">
									<xsl:text>
									</xsl:text>
								</div>
							</div>
							
							<div id="submitted">
								<xsl:text>
								</xsl:text>
							</div>
							
						</form>
					</div>
				</div>
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:template>
	
	<!-- ===== CONTENT TEMPLATES ===== -->
	
	<xsl:template name="GeneralDetails">
		<xsl:param name="data" />
		
		<fieldset id="general" class="step">
			<legend>Listing details</legend>
			<div class="control-group hidden">
				<label class="control-label">Category</label>
				
				<div class="controls">
					<xsl:choose>
						<xsl:when test="string-length($data/CatPath) &gt; 0">
							<input id="listing-category-id" type="hidden" name="listing-category-id">
								<xsl:attribute name="value">
									<xsl:value-of select="$data/CatID" />
								</xsl:attribute>
							</input>
							<input id="listing-category-name" type="hidden" maxlength="200" name="listing-category-name" />
							<input id="listing-category-path" type="hidden" maxlength="200" name="listing-category-path" >
								<xsl:attribute name="value">
									<xsl:value-of select="$data/CatPath" />
								</xsl:attribute>
							</input>
						</xsl:when>
						<xsl:otherwise>
							<input id="listing-category-id" type="hidden" name="listing-category-id">
								<xsl:attribute name="value">
									<xsl:value-of select="$CatInfo/Categories/ID" />
								</xsl:attribute>
							</input>
							<input id="listing-category-name" type="hidden" maxlength="200" name="listing-category-name">
								<xsl:attribute name="value">
									<xsl:value-of select="$CatInfo/Categories/Name" />
								</xsl:attribute>
							</input>
							<input id="listing-category-path" type="hidden" maxlength="200" name="listing-category-path" >
								<xsl:attribute name="value">
									<xsl:value-of select="$CatInfo/Categories/Path" />
								</xsl:attribute>
							</input>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label">Item Title&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Provide the brand and/or type of item you're selling">&nbsp;</i>
				</label>
				<div class="controls">
					<input id="listing-title" class="span8 required" type="text" maxlength="100" name="listing-title">
						<xsl:if test="$data/CatPath = 'Automotive/Cars/Cars For Sale'">
							<xsl:attribute name="readonly">readonly</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="data-validate">{required: false, minlength: 3, maxlength: 100, messages: {required: 'Please enter the listing title'}}</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="$IsPostBack = 'true'">
									<xsl:value-of select="scripts:FilterNasties($LstTitle)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="scripts:FilterNasties($data/Title)" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					Summary Description&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Displayed in search results">&nbsp;</i>
				</label>
				<div class="controls">
					<textarea id="listing-summary" name="listing-summary" class="summary span8" rows="4" cols="40">
						<xsl:attribute name="data-validate">{required: false, minlength: 6, maxlength: 250, messages: {required: 'Please enter a short summary description for display in search results'}}</xsl:attribute>
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:value-of select="$LstSumDesc" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$data/SumDesc" />
							</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label">Full Description&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Displayed on the details screen">&nbsp;</i>
				</label>
				<div class="controls">
					<!-- <textarea class="span8" rows="10" cols="40" data-wysiwyg="true" id="listing-description" name="listing-description"> -->
					<textarea class="span8" rows="10" cols="40" id="listing-description"  data-wysiwyg="true" name="listing-description">
						<xsl:attribute name="data-validate">{required: true, minlength: 6, messages: {required: 'Please enter a detailed description for display on the item details page'}}</xsl:attribute>
						<!-- <xsl:text>&nbsp;</xsl:text> -->
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:value-of select="scripts:FilterNasties($LstDesc)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="scripts:FilterNasties($data/Desc)" />
							</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>
			</div>
			
			<div class="control-group" id="listing-has-pricing">
				<xsl:if test="$IsRetailUser = 'true'">
					<xsl:attribute name="style">display:none</xsl:attribute>
				</xsl:if>
				<label class="control-label">Does this item have a price?</label>
				<div class="controls">
					<label class="checkbox toggle well inline">
						<input type="checkbox" id="listing-has-price" name="listing-has-price" value="true" checked="checked"></input>
						<p>
							<span>Yes</span>
							<span>No</span>
						</p>
						<a class="btn slide-button">&nbsp;</a>
					</label>
				</div>
			</div>
			
			<div id="standard-pricing">
				<div class="control-group">
					<label class="control-label">Current Price&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="The current price is what you're now selling this item for, and is always required.">&nbsp;</i>
					</label>
					<div class="controls">
						<div class="input-prepend inline">
							<span class="add-on">$</span>
							<input id="listing-price" type="text" maxlength="13" name="listing-price">
								<xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="scripts:FilterNasties($LstPrice)" /> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="scripts:FormatPrice($data/Price)" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Original Price&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="If you have dropped the price since originally advertising the item, enter the Original Price as well so buyer's can see the discount you're offering.">&nbsp;</i>
					</label>
					<div class="controls">
						<div class="input-prepend inline">
							<span class="add-on">$</span>
							<input class="" id="listing-was-price" type="text" maxlength="13" name="listing-was-price">
								<xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="scripts:FilterNasties($LstWasPrice)" /> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="scripts:FormatPrice($data/WasPrice)" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
			</div>
			<div id="custom-pricing" style="display:none">
				<div class="control-group">
					<label class="control-label">Drive away price</label>
					<div class="controls">
						<div class="input-prepend inline">
							<span class="add-on">$</span>
							<input id="listing-driveaway-price" type="text" maxlength="13" name="listing-driveaway-price">
								<xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="scripts:FilterNasties($LstDriveAwayPrice)" /> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="scripts:FormatPrice($data/Price)" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Sale price</label>
					<div class="controls">
						<div class="input-prepend inline">
							<span class="add-on">$</span>
							<input id="listing-sale-price" type="text" maxlength="13" name="listing-sale-price">
								<xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="scripts:FilterNasties($LstSalePrice)" /> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="scripts:FormatPrice($data/Price)" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Unqualified Price</label>
					<div class="controls">
						<div class="input-prepend inline">
							<span class="add-on">$</span>
							<input id="listing-unqualified-price" type="text" maxlength="13" name="listing-unqualified-price">
								<xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="scripts:FilterNasties($LstUnqualifiedPrice)" /> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="scripts:FormatPrice($data/Price)" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label">Price Description</label>
				<div class="controls">
					<!-- <select name="listing-price-attribute">
   <option value="">Select an option</option>
   <option value="Negotiable">Negotiable</option>
   <option value="Call for price">Call for Price</option>
   <option value="Drive Away">Drive Away</option>
  </select> -->
					<select class="drop-down" name="listing-price-qualifier" id="listing-price-qualifier">
						<xsl:call-template name="optionlist">
							<!-- <xsl:with-param name="options">Select an option,Negotiable,Call for Price,Drive Away</xsl:with-param> -->
							<xsl:with-param name="options">,Negotiable</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstPriceQualifier" />
									</xsl:when>
									<xsl:when test="$data/PriceQualifier != ''">
										<xsl:value-of select="$data/PriceQualifier" />
									</xsl:when>
									<xsl:otherwise>Negotiable</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</select>
					
				</div>
			</div>
			
			<div class="control-group lst-condition">
				<xsl:attribute name="style">
					<xsl:if test="$data/CatID = 528 or $data/CatID = 530 or $data/CatID = 532 or $data/CatID = 533 or $data/CatID = 536 or $data/CatID = 538">display:none</xsl:if>
				</xsl:attribute>
				
				<label class="control-label">Condition</label>
				<div class="controls">
					<select class="required listing-condition" name="listing-condition" style="width:112px">
						<xsl:call-template name="optionlist">
							<xsl:with-param name="options">Used,New,Demo</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstCondition" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$data/Condition" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</select>
					&nbsp;
					<select class="listing-condition-desc" name="listing-condition-desc" style="margin-top:10px">
						<xsl:attribute name="style">
							<!-- <xsl:if test="$data/ConditionDesc != '' or $LstConditionDesc != ''">display:none</xsl:if> -->
							<xsl:choose>
								<xsl:when test="$data/Condition = 'New' or $LstCondition = 'New'">display:none</xsl:when>
								<xsl:when test="$data/ConditionDesc != '' or $LstConditionDesc != ''"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						
						<xsl:call-template name="optionlist">
							<xsl:with-param name="options">Excellent,Very Good,Good,Fair</xsl:with-param>
							<xsl:with-param name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstConditionDesc" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$data/ConditionDesc" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</select>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label">Stock Number/SKU
					<xsl:if test="$IsRetailUser != 'true'">
						<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="Stock number is a compulsory field, it can only contain alphanumeric characters and it can not be edited.">&nbsp;</i>
					</xsl:if>
				</label>
				<div class="controls">
					<input class="text allow-lowercase" type="text" maxlength="50" name="listing-stock-number">
						<xsl:attribute name="data-validate">{required: false, minlength: 1, maxlength: 50, regex:/^[a-z0-9]+$/i, messages: {required: 'Please enter the stock number'}}</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="$IsPostBack = 'true'">
									<xsl:value-of select="$LstStockNumber" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$data/StkNo" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label">Item Location</label>
				<div class="controls">
					<input class="text allow-lowercase" type="text" maxlength="50" id="listing-location"  name="listing-location" autocomplete="off" placeholder="Suburb, State Postcode">
						<!-- <xsl:attribute name="data-validate">{required: false, regex:/^(?:[A-Za-z0-9\s]*)(?:,)(?:[A-Za-z0-9\s]*)(?:\s)(?:[0-9]*)*$/, minlength: 1, maxlength: 50, messages: {required: 'Please enter the location', regex: 'Please enter a valid location (e.g. Sydney, NSW 2000)'}}</xsl:attribute> -->
						<xsl:attribute name="data-validate">{required: true, minlength: 1, maxlength: 50, messages: {required: 'This field is required.'}}</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="$IsPostBack = 'true'"><xsl:value-of select="$LstLocation" /></xsl:when>
								<xsl:otherwise>
									<xsl:if test="$data/LocRegion != ''">
										<xsl:value-of select="$data/LocRegion"/>,<xsl:text> </xsl:text>
									</xsl:if>
									<xsl:if test="$data/LocRegion != '' and $data/LocRegion != ''">
										<xsl:value-of select="$data/LocStateProvince" /><xsl:text> </xsl:text><xsl:value-of select="$data/LocPostalCode" />
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
					<label id="listing-location-validate" class="error" style="display:none">Please enter a valid location (e.g. Sydney, NSW 2000)</label>
					<input id="listing-location-validator" type="hidden">
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="$data/LocRegion != ''">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
				</div>
			</div>
			
			<div class="control-group">
				<label class="control-label">Terms and Condtions</label>
				<div class="controls">
					<!-- <textarea><xsl:value-of select="$TermsAndConditions" /></textarea> -->
					<label class="checkbox">
						<input class="required" type="checkbox" name="terms-and-conditions" value="accept">
							<xsl:if test="$TermsAndConditions = 'accept'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
						</input>
						I accept the <a href="/docs/terms-and-conditions" target="_blank">terms and conditions of sale</a>
					</label>
					<label style="display: none;" class="error" generated="true" for="terms-and-conditions">This field is required.</label>
				</div>
			</div>
			
		</fieldset>
	</xsl:template>
	<!-- /GeneralDetails -->
	
	<!-- Listing Contact Details -->
	<xsl:template name="ContactDetails">
		<xsl:param name="data" />
		<fieldset id="contact-details" class="step">
			<legend>How can buyers contact you?</legend>
			
			<div class="control-group" id="div-contact-setting">
				<p>
					<i class="icon-info">&nbsp;</i>
					Select 'Yes' to display <a href='/settings/safety-and-privacy' target="_blank">your normal contact details</a> on this ad. <br/>
					If you would like to display a different contact phone number, name or email address for this ad, select No and then enter the custom contact details to display on this ad.
				</p>
				
				<label class="control-label"><a href='/settings/safety-and-privacy' target="_blank">Safety and Privacy</a></label>
				
				<div class="controls">
					<label class="checkbox toggle well inline">
						<input type="checkbox" id="listing-contact-setting" name="listing-contact-setting" value="true" checked="checked"></input>
						<p>
							<span>Yes</span>
							<span>No</span>
						</p>
						<a class="btn slide-button">&nbsp;</a>
					</label>
				</div>
			</div>
			
			<div id="listing-level-contact" style="display:none">
				<div class="control-group" id="div-contact-name">
					<label class="control-label">Display Contact Name</label>
					<div class="controls">
						<input class="text allow-lowercase" type="text" maxlength="50" name="listing-contact-name">
							<xsl:attribute name="data-validate">{required: false, minlength: 1, maxlength: 50, messages: {required: 'Please enter the display contact name'}}</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstContactName" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$data/ContactDisplaySellerName" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
					</div>
				</div>
				
				<div class="control-group" id="div-contact-email">
					<label class="control-label">Display Contact Email</label>
					<div class="controls">
						<input class="text allow-lowercase email" type="text" maxlength="50" name="listing-contact-email">
							<xsl:attribute name="data-validate">{required: false, minlength: 1, maxlength: 50, messages: {required: 'Please enter the display contact email'}}</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstContactEmail" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$data/ContactDisplaySellerEmail" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
					</div>
				</div>
				
				<div class="control-group" id="div-contact-phone">
					<label class="control-label">Display Contact Phone</label>
					<div class="controls">
						<input class="text allow-lowercase" type="text" maxlength="50" name="listing-contact-phone">
							<xsl:attribute name="data-validate">{required: false, minlength: 1, maxlength: 50, messages: {required: 'Please enter the display contact phone'}}</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstContactPhone" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$data/ContactDisplaySellerPhone" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
					</div>
				</div>
			</div>
		</fieldset>
	</xsl:template>
	
	<!-- Listing Images Template -->
	<xsl:template name="MediaImages">
		<xsl:param name="data" />
		
		<fieldset id="media-image" class="step">
			<legend>Add Images</legend>
			
			<!-- Loaders -->
			<div id="loading-bg-transparent" style="display:none">
				<xsl:text>
				</xsl:text>
			</div>
			<div id="loading-dialog" style="display:none">
				<img class="retina" src="/images/spinner.png" />
			</div>
			<!-- /Loaders -->
			
			<div class="group-box">
				<!-- Display existing thumbs -->
				<a id="ReloadImage" href="#" style="visibility: hidden">Reload Image</a>
				<ul class="row-fluid" id="listing-thumbnails">
					<xsl:text>&nbsp;</xsl:text>
					<!-- <xsl:for-each select="$data/ListingsImageInfo/ImageEditInfo">
   <li class="span3 thumb" data-photo-id="{./ID}">
	<xsl:attribute name="data-photo-caption">
  <xsl:choose>
   <xsl:when test="./ImageTitle !=''">
	<xsl:value-of select="./ImageTitle" />
   </xsl:when>
   <xsl:otherwise>&nbsp;</xsl:otherwise>
  </xsl:choose>
	</xsl:attribute>
	
	<div class="thumbnail">
  <img src="{scripts:GetImageUrl(./ImageUrl, 108, 108)}" alt="{$data/ImageTitle}" />
	</div>
	
	<a href="{./ImageUrl}" class="lightbox view-image">
  <i class="icon-eye">
   <xsl:text>
   </xsl:text>
  </i>
	</a>
	
	<a href="http://rest.beta.mongodbv1.dev.easylist.com.au/ListingTemp/Image/{$data/UserCode}/{./ImageTitle}" class="delete-image IsNew" data-image-id="{./ID}" title="Delete photo">
  <i class="icon-remove">
   <xsl:text>
   </xsl:text>
  </i>
	</a>
   </li>
  </xsl:for-each> -->
				</ul>
				
				<input type="hidden" id="update-photos" name="update-photos" value="true" />
				<input type="hidden" id="photo-order" name="photo-order" />
				<input type="hidden" id="photo-captions" name="photo-captions" />
				<input type="hidden" id="delete-photos" name="delete-photos" />
				
				<input type="submit" class="update-listing" value="Update Photos" style="display:none" />
				
			</div>
			
			<p>
				<!-- <i class="icon-info">&nbsp;</i> You can sort the image via drag and drop. -->
				<i class="icon-info">&nbsp;</i> Use the left/right arrows to rotate your photos <br/>
				<i class="icon-info">&nbsp;</i> Drag and drop photos to change their sort order
			</p>
			
			<a class="btn btn-primary push-bottom" id="upload-photo" href="#">
				<i class="icon-camera">&nbsp;</i> Add a new Photo
			</a>
			&nbsp;&nbsp;&nbsp;
			<a class="" id="upload-photo-basic" href="#">Having trouble? Try the Basic Uploader.</a>
			
			<input name="add-photo" type="file" style="visibility:hidden" />
			
			<div id="ImageUploadDialog" title="Image Upload dialog">
				<span>&nbsp;</span>
			</div>
			
			<!-- Image Caption Edit -->
			<div id="caption-edit" data-photo-id="" class="hidden group-box small">
				<div class="underlay">
					<h1>
						<span class="photos">&nbsp;</span>Edit Photo Caption
					</h1>
				</div>
				<div id="caption-image">
					<!--<img src="#" alt="image" />-->
					<xsl:text>
					</xsl:text>
				</div>
				<input type="text" maxlength="100" class="text" id="image-caption">
					<xsl:attribute name="data-validate">{required: false, minlength: 3, maxlength: 100}</xsl:attribute>
				</input>
				<a id="set-image-caption" href="#" class="button">Set Caption</a>
			</div>
			
		</fieldset>
	</xsl:template>
	<!-- /Listing Images Template -->
	
	<!-- Listing Videos Template -->
	<xsl:template name="MediaVideos">
		<xsl:param name="data" />
		<fieldset id="media-video" class="step">
			<legend>Add Videos</legend>
			
			<div class="group-box">
				
				<ul class="row-fluid" id="video-thumbnails">
					<xsl:text>&nbsp;</xsl:text>
					<xsl:for-each select="$data/ListingsVideoInfo/VideoEditInfo">
						<li class="span3 thumb" data-video-id="{./VideoData}">
							<div class="thumbnail">
								<xsl:choose>
									<xsl:when test="./VideoSource != 'DMI'">
										<img src="//img.youtube.com/vi/{./VideoData}/1.jpg" width="108" height="81" alt="Video thumbnail 1" />
									</xsl:when>
									<xsl:otherwise>
										<img src="/images/video-icon.jpg" width="108" height="81" alt="Video thumbnail 1" />
									</xsl:otherwise>
								</xsl:choose>
								<!-- <img src="http://img.youtube.com/vi/{./VideoData}/1.jpg" width="108" height="81" alt="Video thumbnail 1" /> -->
							</div>
							<xsl:choose>
								<xsl:when test="./VideoSource != 'DMI'">
									<a id="ViewVideo" href="https://www.youtube.com/embed/{./VideoData}" class="video-viewer" data-video-source="{./VideoSource}" 
									data-video-data="{./VideoData}" title="View video">
										<i class="icon-eye">
											<xsl:text>
											</xsl:text>
										</i>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a id="ViewVideo" href="{./VideoData}" 
									class="video-viewer" data-video-source="{./VideoSource}" data-video-data="{./VideoData}" title="View video">
										<i class="icon-eye">
											<xsl:text>
											</xsl:text>
										</i>
									</a>
								</xsl:otherwise>
							</xsl:choose>
							<a href="#" class="delete-video" data-video-id="{./ID}" title="Delete video">
								<i class="icon-remove">
									<xsl:text>
									</xsl:text>
								</i>
							</a>
						</li>
					</xsl:for-each>
				</ul>
				
				<input type="hidden" id="delete-videos" name="delete-videos" />
				<input type="hidden" id="update-videos" name="update-videos" value="true" />
				<input type="hidden" id="video-order" name="video-order" />
				<input type="hidden" id="video-captions" name="video-captions" />
				<input type="hidden" id="video-descriptions" name="video-descriptions" />
				<input type="hidden" id="insert-video" name="insert-video" />
				<input type="hidden" id="insert-video-title" name="insert-video-title" />
				<input type="hidden" id="insert-video-description" name="insert-video-description " />
				
			</div>
			
			<div class="group-box">
				<p>
					<i class="icon-info">&nbsp;</i> You can sort the via via drag and drop.
				</p>
				<p>
					<i class="icon-info">&nbsp;</i> Copy and paste the full link to the youtube video you'd like to add, then click the add youtube video button.
				</p>
				<div class="youtube-input input-append">
					<label>
						<b>Youtube link:</b>
					</label>
					<input type="text" class="text allow-lowercase span6" name="youtube-url" id="youtube-url" />
					<a class="btn btn-primary" id="Add-Video" href="#">
						<i class="icon-play">&nbsp;</i> Add a youtube video
					</a>
				</div>
			</div>
			
		</fieldset>
		
	</xsl:template>
	<!-- /Listing Video Template -->
	
	<xsl:template name="Catalog">
		<xsl:param name="data" />
		
		<xsl:variable name="UserList" select="RESTscripts:GetUserList()" />
		<!-- <xsl:if test="string-length($UserList) &gt; 0 and $HasChildList = 'true'"> -->
		<xsl:if test="string-length($UserList) &gt; 0 and $IsRetailUser != 'true'">
			<xsl:variable name="SelectedUserCode">
				<xsl:choose>
					<xsl:when test="$IsPostBack = 'true'">
						<xsl:value-of select="$LstUserCode" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$data/UserCode" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="SelectedUserCatalog">
				<xsl:choose>
					<xsl:when test="$IsPostBack = 'true'">
						<xsl:value-of select="$LstCatalogID" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$data/CatalogID" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div style="height:10px"><xsl:text>
			</xsl:text></div>
			<xsl:value-of select="RESTscripts:GetUserCatalogList($SelectedUserCode, $SelectedUserCatalog, 1)"  disable-output-escaping="yes" />
			<!--<textarea>
 <xsl:value-of select="RESTscripts:GetUserCatalogList($SelectedUserCode, $SelectedUserCatalog, 1)"  disable-output-escaping="yes" />
   </textarea>-->
		</xsl:if>
		
		<div class ="control-group listingCatalog" style="display:none"><span style="display:none">&nbsp;</span>
		</div>
		
	</xsl:template>
	
	<xsl:template name="Category">
		<xsl:param name="data" />
		<fieldset id="category" class="step">
			<legend>Show listing at</legend>
			
			<div class="form-left">
				<input type="hidden" value="{$CatInfo/Categories/ID}" id="CatPathSet" name="CatPathSet" />
				<input type="hidden" value="{$data/Code}" id="ListingCode" name="ListingCode" />
				
				<xsl:if test="(string-length($data/Code) &gt; 0) or (string-length($data/CatPath) &gt; 0 or (string-length($CatPath) &gt; 0 and $CatSel != '1'))">
					<div class="control-group CatSelected">
						<label class="control-label">Listing Category</label>
						<div class="controls">
							<label>
								<xsl:choose>
									<xsl:when test="string-length($data/CatPath) &gt; 0"><xsl:value-of select="$data/CatPath" /></xsl:when>
									<xsl:when test="string-length($CatPath) &gt; 0"><xsl:value-of select="$CatPath" /></xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</label>
							<a class="btn btn-primary btn-danger" id="ResetCat" href="#" Style="Width:400px;">
								<i class="icon-undo">&nbsp;</i> Not what you wanted? Click here to start again
							</a>
						</div>
					</div>
				</xsl:if>
				<div id="CatSelection">
					<xsl:attribute name="style">
						<xsl:if test="(string-length($data/Code) &gt; 0) or (string-length($data/CatPath) &gt; 0 or (string-length($CatPath) &gt; 0  and $CatSel != '1') )">display:none</xsl:if>
					</xsl:attribute>
					<div class="control-group">
						<label class="control-label">Listing Category</label>
						<div class="controls">
							<div id="CategorySelection">
								
								<select id="CatLvl1" class="" style="display:none" name="listing-cat1" onchange='CatChange(this, 1);'>
									<option value="">Select a Category</option>
								</select>
							</div>
						</div>
					</div>
					<input id="UIEditorLink" name="listing-UIEditorLink" type="hidden" class="link">
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="string-length($data/LstType) &gt; 0">
									<xsl:choose>
										<xsl:when test="$data/LstType = 'Car'">AutomotiveListing</xsl:when>
										<xsl:when test="$data/LstType = 'Motorcycle'">MotorcycleListing</xsl:when>
										<xsl:otherwise>GM</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$CatInfo/Categories/ID = '60'">AutomotiveListing</xsl:when>
										<xsl:when test="$CatInfo/Categories/ID = '80'">AutomotiveListing</xsl:when>
										<xsl:when test="$CatInfo/Categories/ID = '600'">AutomotiveListing</xsl:when>
										<xsl:when test="$CatInfo/Categories/ID = '601'">AutomotiveListing</xsl:when>
										<xsl:when test="$CatInfo/Categories/ID = '67'">MotorcycleListing</xsl:when>
										<xsl:otherwise>GM</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
				</div>
			</div>
			<!-- <div class="form-right">
 <div id="CustomAttribute">
  <xsl:text>&nbsp;</xsl:text>
  <xsl:if test ="$data/Code != '' and $data/CatID != ''">
   <xsl:call-template name="GMListing">
	<xsl:with-param name="data" select="$data" />
   </xsl:call-template>
  </xsl:if>
 </div>
   </div> -->
		</fieldset>
		
	</xsl:template>
	
	<xsl:template name="GMListingTpm">
		<xsl:param name="data" />
		<fieldset id="GMListing" class="step GMListingTemplate">
			<xsl:choose>
				<xsl:when test="($data/CatID != '' and $data/Code != '')">
					<xsl:variable name="CustomHTML" select="RESTscripts:CustomListingHTML($data/CatID, $data/Code)" />
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test ="$data/LstType = 'General' and $CustomHTML != ''"></xsl:when>
							<xsl:otherwise>display:none</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<legend>Select your item attributes</legend>
					<div id="CustomAttr">
						<!-- <textarea>
	<xsl:value-of select="$CustomHTML"/>
   </textarea> -->
						<xsl:if test ="$CustomHTML != ''">
							<div id="spec" class="tab-pane">
								<xsl:value-of select="$CustomHTML" disable-output-escaping="yes" />
								&nbsp;
							</div>
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:when test="$CatPath != ''">
					<xsl:variable name="CustomHTMLNew" select="RESTscripts:CustomListingHTMLNew($CatPath)" />
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test ="$CustomHTMLNew != ''"></xsl:when>
							<xsl:otherwise>display:none</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<legend>Select your item attributes</legend>
					<div id="CustomAttr">
						<xsl:if test ="$CustomHTMLNew != ''">
							<div id="spec" class="tab-pane">
								<xsl:value-of select="$CustomHTMLNew" disable-output-escaping="yes" />
								&nbsp;
							</div>
						</xsl:if>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="style">display:none</xsl:attribute>
					<legend>Select your item attributes</legend>
					<div id="CustomAttr">&nbsp;</div>
				</xsl:otherwise>
			</xsl:choose>
		</fieldset>
	</xsl:template>
	
	<xsl:template name="AutomotiveListing">
		<xsl:param name="data" />
		
		<div class="AutomotiveListingTemplateSelected">
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="$data/LstType = 'Car' and string-length($data/VehicleListing/Make) &gt; 0 and ($data/CatID = '60')">&nbsp;</xsl:when>
					<xsl:otherwise>display:none</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<fieldset id="AutomotiveListing" class="step">
				<legend>Your selected car attributes</legend>
				<div class="form-left">
					<div class="control-group">
						<label class="control-label">Make</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" maxlength="100" id="listing-make-dis" name="listing-make-dis" value="{$data/VehicleListing/Make}" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Model</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" maxlength="100" id="listing-model-dis" name="listing-model-dis" value="{$data/VehicleListing/Model}" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Year</label>
						<div class="controls">
							<input class="text year" type="text" disabled="disabled" maxlength="4" id="listing-year-dis" name="listing-year-dis" value="{$data/VehicleListing/Year}" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Styles</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" id="listing-body-style-dis" name="listing-body-style-dis" value="{$data/VehicleListing/BodyStyle}" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Transmission</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" id="listing-transmission-dis" name="listing-transmission-dis" value="{$data/VehicleListing/TrmDesc}" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Variant</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" id="listing-variant2-dis" name="listing-variant2-dis" value="{$data/VehicleListing/Variant}" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Series</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" id="listing-series2-dis" name="listing-series2-dis" value="{$data/VehicleListing/Series}" />
						</div>
					</div>
				</div>
			</fieldset>
			<fieldset id="selected-features">
				<legend>Your car features</legend>
				<xsl:call-template name="featureEditors">
					<xsl:with-param name="data" select="$data" />
				</xsl:call-template>
			</fieldset>
		</div>
		
		<div class="AutomotiveListingTemplate">
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="string-length($data) = 0 and $CatInfo/Categories/ID = '60'">&nbsp;</xsl:when>
					<xsl:otherwise>display:none</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<fieldset id="AutomotiveListing" class="step">
				<legend>Select your car attributes</legend>
				<div class="control-group">
					<label class="control-label">Makes</label>
					<div class="controls">
						<select id="easylist-Makes" class="" name="listing-make-sel" onchange="MakeModelYearStyleChange(this, 'Models', '#easylist-Models');"  value="{$data/VehicleListing/Make}" >
							<option value="">Select an option</option>
						</select>
					</div>
				</div>
				<div class="control-group hidden">
					<label class="control-label">Models</label>
					<div class="controls">
						<select id="easylist-Models" class="" name="listing-model-sel" onchange="MakeModelYearStyleChange(this, 'Years', '#easylist-Years');">
							<option value="">Select an option</option>
						</select>
					</div>
				</div>
				<div class="control-group hidden">
					<label class="control-label">Years</label>
					<div class="controls">
						<select id="easylist-Years" class="" name="listing-year-sel" onchange="MakeModelYearStyleChange(this, 'Styles', '#easylist-Styles');">
							<option value="">Select an option</option>
						</select>
					</div>
				</div>
				<div class="control-group hidden">
					<label class="control-label">Styles</label>
					<div class="controls">
						<select id="easylist-Styles" class="" name="listing-body-style-sel" onchange="MakeModelYearStyleChange(this, 'Transmissions', '#easylist-Transmission');">
							<option value="">Select an option</option>
						</select>
					</div>
				</div>
				<div class="control-group hidden">
					<label class="control-label">Transmission</label>
					<div class="controls">
						<select id="easylist-Transmission" class="" name="listing-transmission-sel" onchange="TransmissionChange(this);">
							<option value="">Select an option</option>
						</select>
					</div>
				</div>
				<div class="control-group hidden">
					<label class="control-label">Variant</label>
					<div class="controls">
						<select id="easylist-Variant" class="" name="listing-variant-glass" onchange="VariantChange(this);">
							<option value="">Select an option</option>
						</select>
					</div>
					<input type="hidden" id="listing-variant-sel" name="listing-variant-sel" value="" />
				</div>
			</fieldset>
			
			<fieldset id="group-standard-features" style="display: none;">
				<legend>Select your car features</legend>
				<div class="form-left">
					<div class="control-group">
						<label class="control-label">Standard Features</label>
						<div id="easylist-standard-features" class="controls">
							<xsl:text>1</xsl:text>
						</div>
					</div>
				</div>
				<div class="form-right">
					<div id="group-optional-features" class="control-group">
						<label class="control-label">Optional Features</label>
						<div id="easylist-optional-features" class="controls">
							<xsl:text>2</xsl:text>
						</div>
					</div>
				</div>
				<br />
			</fieldset>
			
			<input id="AutomotiveListingLink" type="hidden" class="link" value="GM" />
			
			<input id="listing-make" name="listing-make" type="hidden" value="{$data/VehicleListing/Make}" />
			<input id="listing-model" name="listing-model" type="hidden" value="{$data/VehicleListing/Model}" />
			<input id="listing-year" name="listing-year" type="hidden" value="{$data/VehicleListing/Year}" />
			<input id="listing-body-style" name="listing-body-style" type="hidden" value="{$data/VehicleListing/BodyDesc}" />
			<input id="listing-transmission" name="listing-transmission" type="hidden" value="{$data/VehicleListing/TrmDesc}" />
			<input id="listing-variant" name="listing-variant" type="hidden" value="{$data/VehicleListing/Variant}" />
			<input id="listing-series" name="listing-series" type="hidden" value="{$data/VehicleListing/Series}" />
			
			<div id="easylist-specs" name="easylist-specs" >
				<input name="vehicle-price-1" type="hidden" value="" />
				<input name="vehicle-price-2" type="hidden" value="" />
				<input name="vehicle-nvic" type="hidden" value="{$data/VehicleListing/NVIC}" />
				<input name="vehicle-vin" type="hidden" value="" />
				<input name="vehicle-doors" type="hidden" value="{$data/VehicleListing/Doors}" />
				<input name="vehicle-seats" type="hidden" value="{$data/VehicleListing/Seats}" />
				<input name="vehicle-drive-type" type="hidden" value="{$data/VehicleListing/DriveType}" />
				<input name="vehicle-transmission-type" type="hidden" value="" />
				<input name="vehicle-transmission-info" type="hidden" value="" />
				<input name="vehicle-engine-type" type="hidden" value="{$data/VehicleListing/EngType}" />
				<input name="vehicle-engine-cc" type="hidden" value="{$data/VehicleListing/EngDesc}" />
				<input name="vehicle-engine-size" type="hidden" value="{$data/VehicleListing/EngSizeDesc}" />
				<input name="vehicle-engine-cylinders" type="hidden" value="{$data/VehicleListing/EngCylinders}" />
				<input name="vehicle-fuel-type" type="hidden" value="{$data/VehicleListing/FuelType}" />
				<input name="vehicle-fuel-highway" type="hidden" value="" />
				<input name="vehicle-fuel-city" type="hidden" value="" />
				<input name="vehicle-valve-gear" type="hidden" value="" />
			</div>
			
			<!-- <div id="easylist-specs" name="easylist-specs" >&nbsp;</div> -->
			<!-- 
   <input id="listing-doors" name="listing-doors" type="hidden" value="{$data/VehicleListing/Doors}" />
   <input id="listing-seats" name="listing-seats" type="hidden" value="{$data/VehicleListing/Seats}" />
   <input id="listing-drive-type" name="listing-drive-type" type="hidden" value="{$data/VehicleListing/DriveTypeDesc}" />
   <input id="listing-engine-cylinders" name="listing-engine-cylinders" type="hidden" value="{$data/VehicleListing/EngCylinders}" />
   <input id="listing-engine-type-description" name="listing-engine-type-description" type="hidden" value="{$data/VehicleListing/EngType}" />
   <input id="listing-engine-size-description" name="listing-engine-size-description" type="hidden" value="{$data/VehicleListing/EngSizeDesc}" />
   <input id="listing-fuel-type-description" name="listing-fuel-type-description" type="hidden" value="{$data/VehicleListing/FuelTypeDesc}" />
   <input id="listing-nvic" name="listing-nvic" type="hidden" value="{$data/VehicleListing/NVIC}" /> 
   -->
			
		</div>
	</xsl:template>
	<!-- /AutomotiveListing -->
	
	<!-- Automotive Spec -->
	<xsl:template name="ListingAdditionalInfo">
		<xsl:param name="data" />
		<!-- <textarea>
   <xsl:value-of select="$CatPath" />
   <xsl:if test="$CatPath = 'Automotive/Cars/Cars For Sale'">true</xsl:if>
  </textarea> -->
		<div class="AutomotiveListingAddInfo">
			<xsl:attribute name="style">
				<xsl:choose>
					<!-- Check on saved category if already exists -->
					<xsl:when test="string-length($data/CatPath) &gt; 0">
						<xsl:choose>
							<xsl:when test="$data/CatID = '60' or $data/CatID = '67' or $data/CatID = '80' or $data/CatID = '600' or $data/CatID = '601'"></xsl:when>
							<xsl:otherwise>display:none</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$CatPath = 'Automotive/Cars/Cars For Sale'"></xsl:when>
							<xsl:when test="$CatPath = 'Automotive/Motorbikes/Motorbikes For Sale'"></xsl:when>
							<xsl:when test="$CatPath = 'Automotive/Cars/Hot Rods and Custom'"></xsl:when>
							<xsl:when test="$CatPath = 'Automotive/Cars/Vintage Classic'"></xsl:when>
							<xsl:when test="$CatPath = 'Automotive/Trucks and Buses/Trucks and Buses For Sale'"></xsl:when>
							<xsl:when test="$CatPath = 'Caravans/Caravans'"></xsl:when>
							<xsl:otherwise>display:none</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<fieldset id="group-car-spec">
				<legend>Additional info</legend>
				<div class="control-group">
					<label class="control-label">Is your vehicle registered
						<!-- <i class="icon-info-2" data-toggle="tooltip" title="Provide the brand and/or type of item you're selling">&nbsp;</i> -->
					</label>
					<div class="controls">
						<label class="checkbox toggle well inline">
							<input type="checkbox" id="listing-vehicle-registered" name="listing-vehicle-registered" value="true">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:if test="$LstVehicleReg ='true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="$data/VehicleListing/VehicleRegistered !='true'"></xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</input>
							<p>
								<span>Yes</span>
								<span>No</span>
							</p>
							
							<a class="btn slide-button">&nbsp;</a>
						</label>
						
					</div>
				</div>
				<div class="VehicleRegistered">
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:if test="$LstVehicleReg !='true'">display:none</xsl:if>
							</xsl:when>
							<xsl:when test="$data/VehicleListing/VehicleRegistered ='false'">display:none</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<div class="control-group">
						<label class="control-label">Rego
						</label>
						<div class="controls">
							<input id="listing-vehicle-rego" name="listing-vehicle-rego" class="" type="text">
								<xsl:attribute name="data-validate">{required: false, messages: {required: 'Please enter either Rego or VIN#'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$LstRegNo" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$data/VehicleListing/RegNo" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">VIN #
						</label>
						<div class="controls">
							<input id="listing-vehicle-VIN" name="listing-vehicle-VIN" class="" type="text" maxlength="17">
								<xsl:attribute name="data-validate">{required: false, regex:/^[a-zA-Z0-9]*$/, minlength: 17, maxlength: 17, messages: {required: 'Please enter VIN# (17 characters with no space)', regex: 'Please enter VIN# (17 characters with no space)'}}</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$LstVinNo" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$data/VehicleListing/VinNumber" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</input>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Expiry date
						</label>
						<div class="controls">
							<select class="drop-down input-small" id="listing-vehicle-expiry-month" name="listing-vehicle-expiry-month" style="margin-right:5px;">
								<option value="">MM</option>
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">1,2,3,4,5,6,7,8,9,10,11,12</xsl:with-param>
									<xsl:with-param name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$LstRegExpMth" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$data/VehicleListing/RegExpMth" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
							</select>&nbsp;
							<select class="drop-down input-small" id="listing-vehicle-expiry-year" name="listing-vehicle-expiry-year">
								<option value="">YYYY</option>
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">2012,2013,2014,2015,2016,2017,2018,2019,2020</xsl:with-param>
									<xsl:with-param name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$LstRegExpYear" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$data/VehicleListing/RegExpYear" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
							</select>
							<label for="listing-vehicle-expiry-month" generated="true" class="error" style="display: none;">&nbsp;</label>
							<label for="listing-vehicle-expiry-year"  generated="true" class="error" style="display: none;">&nbsp;</label>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">&nbsp;</label>
						<div class="controls">
							<label class="checkbox">
								<input class="" type="checkbox" name="listing-vehicle-cert" value="true">
									<xsl:choose>
										<xsl:when test="$LstVehicleCert = 'true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:when test="$data/VehicleListing/RoadworthyCertificate = 'true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
									<!-- <xsl:if test="$LstVehicleCert = 'true'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if> -->
								</input>(Optional) Yes, my vehicle has a roadworthy certificate.
							</label>
						</div>
					</div>
				</div>
				<div class="control-group VehicleNotRegistered">
					<xsl:attribute name="style">
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:if test="$LstVehicleReg = 'true'">display:none</xsl:if>
							</xsl:when>
							<xsl:when test="$data/VehicleListing/VehicleRegistered ='false'"></xsl:when>
							<xsl:otherwise>display:none</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<label class="control-label">VIN or Engine #
					</label>
					<div class="controls">
						<select class="drop-down" id="listing-vehicle-VinEngine" name="listing-vehicle-VinEngine" style="width:160px">
							<xsl:call-template name="optionlist">
								<xsl:with-param name="options">VIN,Engine #</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$LstVinEngine" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$data/VehicleListing/EngVinType" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</select>&nbsp;
						
						<input id="listing-vehicle-VinEngine-VIN" name="listing-vehicle-VinEngine-VIN" class="" type="text" maxlength="17">
							<xsl:attribute name="data-validate">{required: false, regex:/^[a-zA-Z0-9]*$/, minlength: 17, maxlength: 17, messages: {required: 'Please enter VIN# (17 characters with no space)', regex: 'Please enter VIN# (17 characters with no space)'}}</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstVinEngineVinNo" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$data/VehicleListing/VinNumber" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
						<input id="listing-vehicle-VinEngine-Engine" name="listing-vehicle-VinEngine-Engine" class="span" type="text" value ="" style="display:none">
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstVinEngineEngineNo" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$data/VehicleListing/EngNo" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
						<!-- 
						<input id="listing-vehicle-VinEngine-No" name="listing-vehicle-VinEngine-No" class="span" type="text" value ="">
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:choose>
											<xsl:when test="$LstVinEngine = 'VIN'">
												<xsl:value-of select="$LstVinEngineNo" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$LstVinEngineNo" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="$data/VehicleListing/EngVinType = 'VIN'">
												<xsl:value-of select="$data/VehicleListing/VinNumber" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$data/VehicleListing/EngNo" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input> -->
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Odometer</label>
					<div class="controls">
						<!-- <input type="text" maxlength="9" name="listing-odometer-value" class="text integer inline" value="{$data/VehicleListing/Odometer}" /> -->
						<input type="text" maxlength="9" name="listing-odometer-value" id="listing-odometer-value" class="text integer inline input-medium">
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:value-of select="$LstOdometer" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$data/VehicleListing/Odometer" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>&nbsp;KM
						<!-- <select class="drop-down inline input-small" name="listing-odometer-unit" id="listing-odometer-unit" style="width:160px">
							<xsl:call-template name="optionlist">
								<xsl:with-param name="options">,KM,MI</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:value-of select="$LstOdometerUnit" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$data/VehicleListing/OdometerUOM" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</select> -->
						
					</div>
				</div>
			</fieldset>
		</div>
	</xsl:template>
	
	<xsl:template name="CustomMakeModelListing">
		<xsl:param name="data" />
		
		<div class="CustomMakeModelListingTemplateSelected">
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="$data/LstType = 'Car' and (string-length($data/VehicleListing/Make) &gt; 0) and ($data/CatID = '80' or $data/CatID = '600' or $data/CatID = '601')">&nbsp;</xsl:when>
					<xsl:otherwise>display:none</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<fieldset id="CustomMakeModelListingTemplate" class="step">
				<legend>Your selected car attributes</legend>
				<div class="form-left">
					<div class="control-group">
						<label class="control-label">Make</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" maxlength="100" id="listing-custom-make-dis" name="listing-custom-make-dis" value="{$data/VehicleListing/Make}" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Model</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" maxlength="100" id="listing-custom-model-dis" name="listing-custom-model-dis" value="{$data/VehicleListing/Model}" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Year</label>
						<div class="controls">
							<input class="text" type="text" disabled="disabled" maxlength="5" id="listing-custom-year-dis" name="listing-custom-year-dis" value="{$data/VehicleListing/Year}" />
						</div>
					</div>
				</div>
			</fieldset>
		</div>
		
		<fieldset id="CustomMakeModelListing" class="CustomMakeModelListingTemplate step">
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="$data/LstType = 'Car' and (string-length($data/VehicleListing/Make) &gt; 0) and ($data/CatID = '60' or $data/CatID = '80' or $data/CatID = '600' or $data/CatID = '601')">display:none</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$CatPath = 'Automotive/Cars/Hot Rods and Custom'"></xsl:when>
							<xsl:when test="$CatPath = 'Automotive/Cars/Vintage Classic'"></xsl:when>
							<xsl:when test="$CatPath = 'Automotive/Trucks and Buses/Trucks and Buses For Sale'"></xsl:when>
							<xsl:otherwise>display:none</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<legend>Select your automotive custom attributes</legend>
			<div class="control-group">
				<label class="control-label">Makes</label>
				<div class="controls">
					<select id="easylist-custom-Makes" class="" name="listing-custom-make-sel" onchange="LoadAllCustomModelChange(this, '#easylist-custom-Models');">
						<option value="">Select an option</option>
					</select> 
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Models</label>
				<div class="controls">
					<select id="easylist-custom-Models" class="" name="listing-custom-model-sel" onchange="">
						<option value="">Select an option</option>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Year</label>
				<div class="controls">
					<input id="easylist-custom-Year" name="listing-custom-Year-sel" maxlength="4" class="" type="text" value="">
						<xsl:attribute name="data-validate">{required: false, regex:/^\d{4}$/, minlength: 4, maxlength: 4, messages: {required: 'Please enter the year', regex: 'Please enter a valid year'}}</xsl:attribute>
					</input>
				</div>
			</div>
		</fieldset>
		
		<input id="listing-odometer-unit" name="listing-odometer-unit" type="hidden" value="KM" />
		
		<input id="listing-custom-make" name="listing-custom-make" type="hidden" value="{$data/VehicleListing/Make}" />
		<input id="listing-custom-model" name="listing-custom-model" type="hidden" value="{$data/VehicleListing/Model}" />
		<input id="listing-custom-year" name="listing-custom-year" type="hidden" value="{$data/VehicleListing/Year}" />
	</xsl:template>
	
	<xsl:template name="MotorcycleListing">
		<xsl:param name="data" />
		<xsl:if test="$data/LstType = 'Motorcycle' and string-length($data/VehicleListing/Make) &gt; 0">
			<div class="MotorcycleListingTemplateSelected">
				<fieldset id="MotorcycleListingAttr" class="step">
					<legend>Your selected motorcycle attributes</legend>
					<div class="form-left">
						<div class="control-group">
							<label class="control-label">Make</label>
							<div class="controls">
								<input class="text" type="text" disabled="disabled" maxlength="100" id="listing-motor-make-dis" name="listing-motor-make-dis" value="{$data/VehicleListing/Make}" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Model</label>
							<div class="controls">
								<input class="text" type="text" disabled="disabled" maxlength="100" id="listing-motor-model-dis" name="listing-motor-model-dis" value="{$data/VehicleListing/Model}" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Year</label>
							<div class="controls">
								<input class="text year" type="text" disabled="disabled" maxlength="4" id="listing-motor-year-dis" name="listing-motor-year-dis" value="{$data/VehicleListing/Year}" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Variant</label>
							<div class="controls">
								<input class="text year" type="text" disabled="disabled" maxlength="4" id="listing-motor-variant-glass-dis" name="listing-motor-variant-glass-dis" value="{$data/VehicleListing/Variant}" />
							</div>
							<input type="hidden" id="listing-motor-variant-dis" name="listing-motor-variant-dis" value="" />
						</div>
					</div>
				</fieldset>
				<fieldset id="selected-features">
					<legend>Your motorcycle features</legend>
					<xsl:call-template name="MotorfeatureEditors">
						<xsl:with-param name="data" select="$data" />
					</xsl:call-template>
				</fieldset>
			</div>
		</xsl:if>
		
		<fieldset id="MotorcycleListing" class="MotorcycleListingTemplate step">
			<xsl:attribute name="style">
				<xsl:choose>
					<!-- <xsl:when test="string-length($data) = 0 and $data/CatID = '67'">&nbsp;</xsl:when> -->
					<xsl:when test="string-length($data) = 0 and $CatPath = 'Automotive/Motorbikes/Motorbikes For Sale'">&nbsp;</xsl:when>
					<xsl:otherwise>display:none</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<legend>Select your motorcycle attributes</legend>
			<div class="control-group">
				<label class="control-label">Makes</label>
				<div class="controls">
					<select id="easylist-Motor-Makes" class="" name="listing-motor-make-sel" onchange="MotorMakeModelYearChange(this, 'Models', '#easylist-Motor-Models');">
						<option value="">Select an option</option>
					</select>
				</div>
			</div>
			<div class="control-group hidden">
				<label class="control-label">Models</label>
				<div class="controls">
					<select id="easylist-Motor-Models" class="" name="listing-motor-model-sel" onchange="MotorMakeModelYearChange(this, 'Years', '#easylist-Motor-Years');">
						<option value="">Select an option</option>
					</select>
				</div>
			</div>
			<div class="control-group hidden">
				<label class="control-label">Years</label>
				<div class="controls">
					<select id="easylist-Motor-Years" class="" name="listing-motor-year-sel" onchange="MotorYearChange(this);">
						<option value="">Select an option</option>
					</select>
				</div>
			</div>
			<div class="control-group hidden">
				<label class="control-label">Variant</label>
				<div class="controls">
					<select id="easylist-Motor-Variant" class="" name="listing-motor-variant-glass-sel" onchange="MotorVariantChange(this);">
						<option value="">Select an option</option>
					</select>
				</div>
				<input type="hidden" id="listing-motor-variant-sel" name="listing-motor-variant-sel" value="" />
			</div>
		</fieldset>
		<fieldset id="group-motor-features">
			<xsl:attribute name="style">
				<xsl:choose>
					<xsl:when test="$data/CatID = '67'">display:none</xsl:when>
					<xsl:when test="string-length($data) != 0 and $CatInfo/Categories/ID = '67'">&nbsp;</xsl:when>
					<!-- <xsl:when test="$CatInfo/Categories/ID = '67'">&nbsp;</xsl:when> -->
					<xsl:otherwise>display:none</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<legend>Select your motorcycle features</legend>
			<div class="form-left">
				<div class="control-group">
					<label class="control-label">Features</label>
					<div id="easylist-motor-features" class="controls">
						<xsl:text>&nbsp;</xsl:text>
					</div>
				</div>
			</div>
			<br />
		</fieldset>
		<!-- <fieldset id="group-motor-spec">
   <legend>Select your motor spec</legend>
   <div class="control-group">
 <label class="control-label">Specification</label>
 <div id="easylist-Motor-specs" class="controls">
  <xsl:text>3</xsl:text>
 </div>
   </div>
   <br />
  </fieldset> -->
		
		<input id="listing-motor-make" name="listing-motor-make" type="hidden" value="{$data/VehicleListing/Make}" />
		<input id="listing-motor-model" name="listing-motor-model" type="hidden" value="{$data/VehicleListing/Model}" />
		<input id="listing-motor-year" name="listing-motor-year" type="hidden" value="{$data/VehicleListing/Year}" />
		<input id="listing-motor-variant" name="listing-motor-variant" type="hidden" value="{$data/VehicleListing/Variant}" />
		<input id="listing-motor-series" name="listing-motor-series" type="hidden" value="{$data/VehicleListing/Series}" />
		
		<div id="easylist-Motor-specs" name="easylist-Motor-specs" >
			<input type="hidden" name="vehicle-Motor-BodyDesc" value="{$data/VehicleListing/BodyDesc}" />
			<input type="hidden" name="vehicle-Motor-BodyStyles" value="{$data/VehicleListing/BodyStyle}" />
			<input type="hidden" name="vehicle-Motor-Transmission-type" value="{$data/VehicleListing/TrmType}" />
			<input type="hidden" name="vehicle-Motor-Transmission-desc" value="{$data/VehicleListing/TrmDesc}" />
			<input type="hidden" name="vehicle-Motor-NVIC" value="{$data/VehicleListing/NVIC}" />
			<input type="hidden" name="vehicle-Motor-GlassCode" value="{$data/VehicleListing/GlassesCode}" />
			<input type="hidden" name="vehicle-Motor-Cylinder" value="{$data/VehicleListing/EngCylinders}" />
			<input type="hidden" name="vehicle-Motor-Engine" value="{$data/VehicleListing/EngDesc}" />
			<input type="hidden" name="vehicle-Motor-EngineCC" value="{$data/VehicleListing/EngSizeDesc}" />
		</div>
		
		<input id="MotorcycleListingLink" type="hidden" class="link" value="GM" />
	</xsl:template>
	<!-- /MotorcycleListing -->
	
	<!-- Ads Distribution Template -->
	<xsl:template name="AdsDistribution">
		<xsl:param name="data" />
		<fieldset id="media-video" class="step">
			<legend>Ads Distribution</legend>
			
			<!-- Tradingpost -->
			<div class="control-group">
				<label class="control-label">Tradingpost</label>
				<div class="controls">
					
					<label class="checkbox toggle well inline">
						<input type="checkbox" name="listing-publish-tp" value="true" id="listing-publish-tp" disabled="disabled">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</input>
						<p>
							<span>Yes</span>
							<span>No</span>
						</p>
						
						<a class="btn slide-button">&nbsp;</a>
					</label>
					
				</div>
			</div>
			
			<!-- Unique Website -->
			<div class="control-group">
				<label class="control-label">Unique Websites</label>
				<div class="controls">
					
					<label class="checkbox toggle well inline">
						<input type="checkbox" name="listing-publish" value="true" id="publish">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</input>
						<p>
							<span>Yes</span>
							<span>No</span>
						</p>
						
						<a class="btn slide-button">&nbsp;</a>
					</label>
					
				</div>
			</div>
			
		</fieldset>
		
	</xsl:template>
	<!-- /Ads Distribution Template -->
	
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
					<xsl:otherwise>Select an option</xsl:otherwise>
				</xsl:choose>
			</option>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="optionlistValue">
		<xsl:param name="options"/>
		<xsl:param name="value"/>
		
		<xsl:for-each select="umbraco.library:Split($options,',')//value">
			<option>
				<xsl:attribute name="value">
					<xsl:value-of select="substring-before(., '|')" />
				</xsl:attribute>
				<!-- check to see whether the option should be selected-->
				<xsl:if test="$value=substring-before(., '|')">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test=". !=''">
						<xsl:value-of select="substring-after(., '|')" />
						<!-- <xsl:value-of select="." /> -->
					</xsl:when>
					<xsl:otherwise>Select an option</xsl:otherwise>
				</xsl:choose>
			</option>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="optionlistValue2">
		<xsl:param name="options"/>
		<xsl:param name="value"/>
		
		<xsl:for-each select="umbraco.library:Split($options,'|')//value">
			<option>
				<xsl:attribute name="value">
					<xsl:value-of select="substring-before(., ';')" />
				</xsl:attribute>
				<!-- check to see whether the option should be selected-->
				<xsl:if test="$value=substring-before(., ';')">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test=". !=''">
						<xsl:value-of select="substring-after(., ';')" />
					</xsl:when>
					<xsl:otherwise>Select an option</xsl:otherwise>
				</xsl:choose>
			</option>
		</xsl:for-each>
	</xsl:template>
	
	
	<!-- Automotive feature editors -->
	<xsl:template name="featureEditors">
		<xsl:param name="data" />
		<div class="row-fluid">
			
			<!-- <textarea style="display:none">
 <xsl:copy-of select="$data"/>
   </textarea> -->
			
			<div class="span5 todo">
				
				<h3>Standard Features</h3>
				
				<div class="input-append">
					<input type="text" id="new-standard-feature" class="text allow-lowercase">
						<xsl:attribute name="data-validate">{required: false}</xsl:attribute>
					</input>
					<a class="btn" href="#" id="add-standard-feature">Add</a>
				</div>
				
				<br /><br />
				
				<ul class="todo-list" id="standard-features" name="standard-features">
					<xsl:for-each select="$data/ListingsVehicleFeatures/FeatureInfo">
						<xsl:if test="./FeatureType = 'standard'">
							<li data-id="{./ID}">
								<a href="#" class="select-item-delete btn btn-small btn-info" data-id="{./ID}"><i class="icon-remove"><xsl:text>
									</xsl:text></i></a>
								&nbsp;
								<span>
									<xsl:value-of select="./FeatureDesc" />
								</span>
							</li>
						</xsl:if>
					</xsl:for-each>
					<xsl:text>
					</xsl:text>
				</ul>
				
			</div>
			
			<div class="span5 offset1 todo">
				
				<h3>Optional Features</h3>
				
				<div class="input-append">
					<input type="text" id="new-optional-feature" class="text allow-lowercase">
						<xsl:attribute name="data-validate">{required: false}</xsl:attribute>
					</input>
					<a class="btn" href="#" id="add-optional-feature">Add</a>
				</div>
				
				<br /><br />
				
				<ul class="todo-list" id="optional-features">
					<xsl:for-each select="$data/ListingsVehicleFeatures/FeatureInfo">
						<xsl:if test="./FeatureType = 'optional'">
							<li data-id="{./ID}">
								<a href="#" class="select-item-delete btn btn-small btn-info" data-id="{./ID}"><i class="icon-remove"><xsl:text>
									</xsl:text></i></a>
								&nbsp;
								<span>
									<xsl:value-of select="./FeatureDesc" />
								</span>
							</li>
						</xsl:if>
					</xsl:for-each>
					<xsl:text>
					</xsl:text>
				</ul>
				
			</div>
			
			<input class="hidden button save update-listing" type="submit" value="Update Listing Features" />
			
		</div>
		
		<input type="hidden" name="update-features" id="update-features" value="true" />
		<input type="hidden" name="listing-optional-features" id="listing-optional-features" />
		<input type="hidden" name="listing-standard-features" id="listing-standard-features" />
		
	</xsl:template>
	
	<!-- Automotive feature editors -->
	<xsl:template name="MotorfeatureEditors">
		<xsl:param name="data" />
		<div class="row-fluid">
			<div class="span5 todo">
				
				<h3>Features</h3>
				
				<div class="input-append">
					<input type="text" id="new-motor-standard-feature" class="text allow-lowercase">
						<xsl:attribute name="data-validate">{required: false}</xsl:attribute>
					</input>
					<a class="btn" href="#" id="add-motor-standard-feature">Add</a>
				</div>
				
				<br /><br />
				
				<ul class="todo-list" id="standard-motor-features" name="standard-motor-features">
					<xsl:for-each select="$data/ListingsVehicleFeatures/FeatureInfo">
						<xsl:if test="./FeatureType = 'standard'">
							<li data-id="{./ID}">
								<a href="#" class="select-item-delete btn btn-small btn-info" data-id="{./ID}"><i class="icon-remove"><xsl:text>
									</xsl:text></i></a>
								&nbsp;
								<span>
									<xsl:value-of select="./FeatureDesc" />
								</span>
							</li>
						</xsl:if>
					</xsl:for-each>
					<xsl:text>
					</xsl:text>
				</ul>
				
			</div>
			<input class="hidden button save update-listing" type="submit" value="Update Listing Features" />
			
		</div>
		
		<input type="hidden" name="update-features" id="update-features" value="true" />
		<input type="hidden" name="listing-motor-standard-features" id="listing-motor-standard-features" />
		
	</xsl:template>
	
	<!-- C# helper scripts -->
	<msxml:script language="C#" implements-prefix="scripts">
		<![CDATA[

 public string FilterNasties(string s){
 return s.Replace("<","").Replace(">","").Replace("\"","").Replace("&#38;","&").Replace("&quot;","'");
 }

 public string searchDescription(string category, string keywords, string min, string max, string prefix){

 if(string.IsNullOrEmpty(category.Trim())
 && string.IsNullOrEmpty(keywords.Trim())
 && string.IsNullOrEmpty(min.Trim())
 && string.IsNullOrEmpty(max.Trim())){
 // Displaying all items..
 return "";
 }

 if(!string.IsNullOrEmpty(category.Trim())
 && string.IsNullOrEmpty(keywords.Trim())
 && string.IsNullOrEmpty(min.Trim())
 && string.IsNullOrEmpty(max.Trim())){
 // Displaying a category..
 return fixCategory(category);
 }

 if(string.IsNullOrEmpty(min.Trim()) && string.IsNullOrEmpty(max.Trim())){
 return string.Format("{0}{1}",
 string.IsNullOrEmpty(keywords.Trim()) ? "All Items" : "Displaying results for \""+ keywords.Trim() +"\"",
 string.IsNullOrEmpty(category.Trim()) ? "" : " in " + fixCategory(category) +" ");
 }

 string searchedFor = string.IsNullOrEmpty(keywords.Trim()) ? "All Items" : "\""+ keywords.Trim() +"\"";
 string inCategory = string.IsNullOrEmpty(category.Trim()) ? "" : " in " + fixCategory(category) +" ";
 string startPrice = string.IsNullOrEmpty(min.Trim()) ? "any price" : string.Format("${0}.00", min.Trim());
 string endPrice = string.IsNullOrEmpty(max.Trim()) ? "any price" : string.Format("${0}.00", max.Trim());
 return string.Format("{0} {1} from {2}, to {3}",
  prefix, searchedFor + inCategory, startPrice, endPrice);
 }


 public string fixCategory(string s){
 return s.Replace("/", " > ").Replace("-", " ");
 }

 public string getThumbnail(string s) {
 if(string.IsNullOrEmpty(s))
 return "http://www.tradingpost.com.au/is-bin/intershop.static/WFS/Sensis-TradingPost-Site/-/en_AU/images/Resized/Resized330x235_no_image_available.jpg";
 //return s.Replace("Resized640x480", "Resized80x80");
 s = s.Replace("Resized1280x720", "Resized108x108");
 return s.Replace("Resized640x480", "Resized108x108");
 }

public string HasChildList(string dealerID)
{
 string HasChildList = "false";
 if (dealerID.IndexOf(',') > 0)
 {
  HasChildList = "true";
 }
 return HasChildList;
}


 ]]>
	</msxml:script>
	
</xsl:stylesheet>