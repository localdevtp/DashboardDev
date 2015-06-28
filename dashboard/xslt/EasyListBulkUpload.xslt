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
	<xsl:include href="EasyListCommonTemplate.xslt" />
	<xsl:include href="EasyListRestHelper.xslt" />
	<xsl:include href="EasyListHelper.xslt" />
	<xsl:include href="EasyListStaffHelper.xslt" />
	
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	
	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Editor,Sales')" />
	<xsl:variable name="UserMenuList" select="AccScripts:GetUserMenuList()" />
	
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		
		<xsl:choose>
			<xsl:when test="$IsAuthorized = false and not($UserMenuList/MenuAccessList/AccesssNewListing = 'true')">
				<div class="alert alert-error">
					<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
				</div>
			</xsl:when>
			<xsl:otherwise>       
				<xsl:call-template name="LoadPage" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!-- LOADPAGE TEMPLATE -->
	<xsl:template name="LoadPage" >
		
		<div class="widget-box">
			<div class="widget-title">
				<h2><i class="icon-stack-1">&nbsp;</i> Bulk Upload</h2>
			</div>
			<!-- /widget-title -->
			
			<div class="widget-content">
				<!-- HANDLE YOUR PAGE POST PROCESSING HERE -->
				<xsl:call-template name="bulk-upload" />
				
			</div>
			<!-- /widget-content -->
			
		</div>
		<!-- /widget-box -->
		
	</xsl:template> 
	<!-- /LOADPAGE TEMPLATE -->
	
	<!-- LOADING TEMPLATE -->
	<xsl:template name="loader">
		<!-- Loaders -->
		<div id="loading-bg">
			<xsl:text>
			</xsl:text>
		</div>
		<div id="loading" style="display:none">
			<img class="retina" src="/images/spinner.png" />
		</div>
		<!-- /Loaders --> 
	</xsl:template>
	<!-- /LOADING TEMPLATE -->
	
	<!-- BULK UPLOAD FORM TEMPLATE -->
	<xsl:template name="bulk-upload">
		<!--<form id="bulk-upload-form" class="form-horizontal" method="post" enctype="multipart/form-data" accept-charset="utf-8">-->
			
			<!-- Template CSV Files -->
			<!--
			<fieldset>
				<legend style="margin-top:-10px;">1. Download latest CSV file</legend>
				We have simplified our bulk ad import file to make filling out the form quicker and easier for you.<br />
				<br />
				<strong>Ensure you have the latest file by downloading from the link:</strong>
				<ul class="download-list">
					<li><a href="#"><i class="icon-file-xml">&nbsp;</i> Download the Advanced Import Sample File (CSV)</a></li>
					<li><a href="#"><i class="icon-file-excel">&nbsp;</i> Download the Advanced Import Sample File with Help (Excel)</a></li>
				</ul>
				<br />
				or, take a look at the <strong>2011 Example Files</strong>:<br />
				<i class="icon-file-excel">&nbsp;</i><a href="#">Category List (Excel)</a><br />
				<i class="icon-file-xml">&nbsp;</i><a href="#">Advanced Import Sample File (CSV)</a><br />
				<i class="icon-file-excel">&nbsp;</i><a href="#">Advanced Import Sample File with Help (Excel)</a><br />
				<i class="icon-file-pdf">&nbsp;</i><a href="#">Field Guide for Advance Ad Tools Plus (PDF)</a><br />
				<br />
				<i class="icon-question info">&nbsp;</i> <a href="http://en.wikipedia.org/wiki/Comma-separated_values" target="_blank">What is CSV file?</a>
				<br /><br />
			</fieldset>
			-->
			<!-- Template CSV Files -->
			
			<!-- Upload images -->
			<!-- <fieldset>
				<legend>2. Upload images for the bulk upload</legend>
				<div class="alert alert-info" style="margin-top:0">
					Ensure that you have uploaded all your images used in the bulk upload CSV.
				</div>
				<div class="group-box">
					<ul class="row-fluid" id="listing-thumbnails">
						<li class="span3 thumb list" data-photo-id="" data-photo-caption="">
							<div class="thumbnail">
								<img src="http://placehold.it/170x120/000000/ffffff" alt="" />
								<div class="caption" title="IMG-FILENAME.jpg">IMG-FILENAME.jpg</div>
							</div>
							<a href="#" class="lightbox view-image"><i class="icon-eye"><xsl:text>
								</xsl:text></i></a>
							<a href="#" id="delete-image-new" class="delete-image" data-image-id="3YJ8" title="Delete photo"><i class="icon-remove"><xsl:text>
								</xsl:text></i></a>
						</li>
						<li class="span3 thumb list" data-photo-id="" data-photo-caption="">
							<div class="thumbnail">
								<img src="http://placehold.it/170x120/000000/ffffff" alt="" />
								<div class="caption" title="IMG-FILENAME.jpg">IMG-FILENAME.jpg</div>
							</div>
							<a href="#" class="lightbox view-image"><i class="icon-eye"><xsl:text>
								</xsl:text></i></a>
							<a href="#" id="delete-image-new" class="delete-image" data-image-id="3YJ8" title="Delete photo"><i class="icon-remove"><xsl:text>
								</xsl:text></i></a>
						</li>
						<li class="span3 thumb list" data-photo-id="" data-photo-caption="">
							<div class="thumbnail">
								<img src="http://placehold.it/170x120/000000/ffffff" alt="" />
								<div class="caption" title="IMG-FILENAME.jpg">IMG-FILENAME.jpg</div>
							</div>
							<a href="#" class="lightbox view-image"><i class="icon-eye"><xsl:text>
								</xsl:text></i></a>
							<a href="#" id="delete-image-new" class="delete-image" data-image-id="3YJ8" title="Delete photo"><i class="icon-remove"><xsl:text>
								</xsl:text></i></a>
						</li>
						<li class="span3 thumb list" data-photo-id="" data-photo-caption="">
							<div class="thumbnail">
								<img src="http://placehold.it/170x120/000000/ffffff" alt="" />
								<div class="caption" title="IMG-FILENAME.jpg">IMG-FILENAME.jpg</div>
							</div>
							<a href="#" class="lightbox view-image"><i class="icon-eye"><xsl:text>
								</xsl:text></i></a>
							<a href="#" id="delete-image-new" class="delete-image" data-image-id="3YJ8" title="Delete photo"><i class="icon-remove"><xsl:text>
								</xsl:text></i></a>
						</li>
						<li class="span3 thumb list" data-photo-id="" data-photo-caption="">
							<div class="thumbnail">
								<img src="http://placehold.it/170x120/000000/ffffff" alt="" />
								<div class="caption" title="IMG-FILENAME.jpg">IMG-FILENAME.jpg</div>
							</div>
							<a href="#" class="lightbox view-image"><i class="icon-eye"><xsl:text>
								</xsl:text></i></a>
							<a href="#" id="delete-image-new" class="delete-image" data-image-id="3YJ8" title="Delete photo"><i class="icon-remove"><xsl:text>
								</xsl:text></i></a>
						</li>
					</ul>
				</div>
				<div style="margin-bottom:10px">
					<button type="button" class="btn btn-primary" id="upload-photo"><i class="icon-camera">&nbsp;</i> Upload images</button>
				</div>
			</fieldset> -->
			<!-- /Upload images -->
			
			<!-- Select your template file -->
			<fieldset>
				<legend style="margin-top:-10px;">1. Select your CSV file for the bulk upload</legend>
				<div class="alert alert-info" style="margin-top:0">
					Import files must be in .csv format. To create a .csv file select Save As and save as file type CSV.
				</div>
				<div style="margin-bottom:10px">
					<input type="file" name="bulk-upload-file" title="Choose your CSV file" class="file-input primary">
						<xsl:attribute name="data-validate">{ required: true , messages:{ required:'Please select your template file to upload.' }}</xsl:attribute>
					</input>
					<label for="bulk-upload-file" generated="true" class="error" style="display:none">&nbsp;</label>
				</div>
			</fieldset>
			<!-- Select your template file -->
			
			<!-- Publish How? -->
			<fieldset>
				<legend>2. Indicate how the ads should be treated</legend>
				<div class="well">
					<label class="radio">
						<input type="radio" name="bulk-upload-treatment" value="1" class="required" /> Publish ads now<br />
						<small>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
							tempor incididunt ut labore et dolore magna aliqua.</small>
					</label>
					<label class="radio">
						<input type="radio" name="bulk-upload-treatment" value="2" class="required" /> Publish ads now <strong>and delete live ads not in template</strong><br />
						<small>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
							tempor incididunt ut labore et dolore magna aliqua.</small>
					</label>
					<label class="radio">
						<input type="radio" name="bulk-upload-treatment" value="3" class="required" /> Store ads as draft<br />
						<small>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
							tempor incididunt ut labore et dolore magna aliqua.</small>
					</label> 
				</div>
				<label for="bulk-upload-treatment" generated="true" class="error" style="display:none">&nbsp;</label>
			</fieldset>
			<!-- /Publish How? -->
			
			<!-- Select your catalog -->
			<!-- <fieldset>
				<legend>4. Which catalog are these ads going into?</legend>
				<select id="bulk-upload-catalog" name="bulk-upload-catalog">
					<xsl:call-template name="optionlist">
						<xsl:with-param name="options">Account1,Account2,Account3</xsl:with-param>
					</xsl:call-template>
				</select>
			</fieldset> -->
			<!-- /Select your catalog -->
			
			<!-- Form Actions -->
			<!--<div class="form-actions center">
				<button type="submit" id="submit" class="btn btn-large btn-success"><i class="icon-upload">&nbsp;</i> Upload</button>
			</div>-->
			<!-- /Form Actions -->
			
		<!--</form>-->
	</xsl:template>
	<!-- /BULK UPLOAD FORM TEMPLATE -->
	
</xsl:stylesheet>