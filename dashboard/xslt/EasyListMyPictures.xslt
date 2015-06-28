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
				<h2><i class="icon-photo">&nbsp;</i> My Pictures</h2>
			</div>
			<!-- /widget-title -->
			
			<div class="widget-content">
				<!-- HANDLE YOUR PAGE POST PROCESSING HERE -->
				<xsl:call-template name="my-pictures" />
				
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
	
	<!-- MY PICTURES FORM TEMPLATE -->
	<xsl:template name="my-pictures">
		<form id="my-pictures-form" class="form-horizontal" method="post" enctype="multipart/form-data" accept-charset="utf-8">
			
			<!-- Upload images -->
			<fieldset style="margin-top:-10px">
				<legend>Upload images for the bulk upload</legend>
				<div class="alert alert-info" style="margin-top:0">
					Ensure that you have uploaded all your images used in the bulk upload CSV.
				</div>
				<!-- Sample images list when uploaded -->
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
				<!-- /Sample images list when uploaded -->
				<div style="margin-bottom:10px">
					<button type="button" class="btn btn-primary" id="upload-photo"><i class="icon-camera">&nbsp;</i> Upload images</button>
				</div>
			</fieldset>
			<!-- /Upload images -->
			
			<!-- Form Actions -->
			<div class="form-actions center">
				<button type="submit" id="submit" class="btn btn-large btn-success"><i class="icon-disk">&nbsp;</i> Save Images</button>
			</div>
			<!-- /Form Actions -->
			
		</form>
	</xsl:template>
	<!-- /MY PICTURES FORM TEMPLATE -->
	
</xsl:stylesheet>