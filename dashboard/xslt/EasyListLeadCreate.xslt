<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:scripts="urn:scripts.this"
	xmlns:RESTscripts="urn:RESTscripts.this"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListRestHelper.xslt" />
	<xsl:include href="EasyListHelper.xslt" />
	<xsl:include href="EasyListStaffHelper.xslt" />

<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->


<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

	<xsl:param name="currentPage"/>

	<xsl:template match="/">

		<!-- start writing XSLT -->
		<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Editor,Sales')" />
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

	<!-- LOADPAGE TEMPLATE -->
	<xsl:template name="LoadPage" >

		<div class="widget-box">
			<div class="widget-title">
				<h2>
					<i class="icon-plus">
						<xsl:text>
						</xsl:text>
					</i> Add New Lead
				</h2>
			</div>
			<!-- /widget-title -->

			<div class="widget-content">
				<xsl:call-template name="new-lead" />
			</div>
			<!-- /widget-content -->

		</div>
		<!-- /widget-box -->

	</xsl:template>	
	<!-- /LOADPAGE TEMPLATE -->

	<!-- ADD NEW LEAD TEMPLATE -->
	<xsl:template name="new-lead">
		<form id="new-lead" class="form-horizontal break-desktop-large">

			<!-- Lead Details -->
			<fieldset style="margin-top:-10px;">
				<legend>Lead Details</legend>
			
				<div class="form-left">

					<div class="control-group">
						<label class="control-label">Lead Created By</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="lead-created-by" disabled="disabled" value="EasyList" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">EasyList Dealer Code</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="easylist-dealer-code" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">EasyList Listing Code</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="easylist-listing-code" />
						</div>
					</div>

				</div>
				<div class="form-right">

					<div class="control-group">
						<label class="control-label">Prospect Source</label>
						<div class="controls">

							<select name="prospect-source" class="input-xlarge required">
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">
										Home Website,Mobile Website,tradingpost.com.au	
									</xsl:with-param>
								</xsl:call-template>
							</select>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Prospect Info</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="prospect-info" />
						</div>
					</div>

				</div>
			</fieldset>
			<!-- /Lead Details -->

			<!-- Buyer Details -->
			<fieldset>
				<legend>Buyer Details</legend>

				<div class="form-left">

					<div class="control-group">
						<label class="control-label">Buyer Name</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="buyer-name" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer Post Code</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="buyer-post-code" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer Email</label>
						<div class="controls">
							<input type="text" class="input-xlarge required email" name="buyer-email" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer Home Phone</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="buyer-home-phone">
								<xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50}</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer Mobile Phone</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="buyer-mobile-phone">
								<xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50}</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer Work Phone</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="buyer-work-phone">
								<xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50}</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer Message</label>
						<div class="controls">
							<textarea class="input-xlarge required" style="height:10em" name="buyer-message">
								<xsl:text>
								</xsl:text>
							</textarea>
						</div>
					</div>

				</div>

				<div class="form-right">

					<div class="control-group">
						<label class="control-label">Buyer Opt-Out Options</label>
						<div class="controls">
							<label class="checkbox inline"><input type="checkbox" name="buyer-dm-opt-out" /> DM</label>
							<label class="checkbox inline"><input type="checkbox" name="buyer-edm-opt-out" /> EDM</label>
							<label class="checkbox inline"><input type="checkbox" name="buyer-sms-opt-out" /> SMS</label>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer IP Address</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="buyer-ip-address" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer User Agent</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="buyer-user-agent" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer Geo Location Latitude</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="buyer-geo-location-latitude" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Buyer Geo Location Longitude</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="buyer-geo-location-longitude" />
						</div>
					</div>

					<!--
					<div id="additional-buyer"><xsl:text>
					</xsl:text></div>

					<div class="control-group">
						<div class="controls">
							<button type="button" id="add-buyer-fields" class="btn btn-info btn-small"><i class="icon-plus">&nbsp;</i>&nbsp;&nbsp;Add additional fields</button>
						</div>
					</div>
					-->

				</div>

			</fieldset>
			<!-- /Buyer Details -->

			<!-- Listing Details -->
			<fieldset>
				<legend>Listing Details</legend>

				<div class="form-left">

					<div class="control-group">
						<label class="control-label">Listing Code</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="listing-code" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Listing Stock Number</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="listing-stock-number" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Listing Title</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="listing-title" />
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Listing Price</label>
						<div class="controls">
							<div class="input-prepend inline">
								<span class="add-on">$</span>
								<input class="input-xlarge money required" type="text" maxlength="13" id="listing-price" name="listing-price">
									<xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
								</input>
							</div>
						</div>
					</div>

				</div>

				<div class="form-right">

					<div class="control-group lst-condition">
						<label class="control-label">Listing Condition</label>
						<div class="controls">
							<select class="required listing-condition input-xlarge" name="listing-condition">
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">New,Used,Demo</xsl:with-param>
								</xsl:call-template>
							</select>
							<br />
							<select class="listing-condition-desc input-xlarge" name="listing-condition-desc" style="">							
								<xsl:attribute name="style">
									margin-top:10px;display:none;
								</xsl:attribute>
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">Excellent,Very Good,Good,Fair</xsl:with-param>
								</xsl:call-template>
							</select>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Listing Location</label>
						<div class="controls">
							<input class="text allow-lowercase input-xlarge" type="text" maxlength="50" id="listing-location"  name="listing-location" autocomplete="off" placeholder="Suburb, State Postcode">
								<xsl:attribute name="data-validate">{required: false, minlength: 1, maxlength: 50, messages: {required: 'Please enter the location'}}</xsl:attribute>
							</input>
						</div>
					</div>

					<!--
					<div id="additional-listing"><xsl:text>
					</xsl:text></div>

					<div class="control-group">
						<div class="controls">
							<button type="button" id="add-listing-fields" class="btn btn-info btn-small"><i class="icon-plus">&nbsp;</i>&nbsp;&nbsp;Add additional fields</button>
						</div>
					</div>
					-->

				</div>

			</fieldset>
			<!-- /Listing Details -->

			<input type="hidden" name="buyer-location"  />
			<input type="hidden" name="browser-type"  />

			<!-- Form Actions -->
			<div class="form-actions center">
				<a href="/leads" class="btn btn-large"><i class="icon-chevron-left">&nbsp;</i> Back</a> &nbsp;
				<button type="submit" id="submit" class="btn btn-large btn-success"><i class="icon-plus">&nbsp;</i> Add New Lead</button>
			</div>
			<!-- /Form Actions -->
		</form>
	</xsl:template>
	<!-- /ADD NEW LEAD TEMPLATE -->

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