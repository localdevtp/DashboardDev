<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

	<!-- start writing XSLT -->

	<!--<select class="drop-down required valid" id="listing-catalog" name="listing-catalog"><option value="07a863bb-9833-4030-b709-4d9acac4fbb8">Test Catalog2 (3DT2RC6FWB)</option><option value="52fc0615-178b-479a-94fc-854962152b4a">test (LYW5TC7V56)</option><option value="506dc0fd-c3d1-4890-be2f-101b3ddba4ed">Test Catalog (6L7PV632DN)</option><option value="1d55dd0d-d8b6-4aac-adf3-04d70908df7f">test (WW3NB2XXT9)</option></select>-->
	
	
	
	<div class="widget-box">
	   	<div class="widget-content">
			
			<form id ="new-listing" class="form-horizontal break-desktop-large" method="post">
				<div class="AutomotiveListingTemplate">
					
					<fieldset id="AutomotiveListing">
						<legend>Select your spec</legend>
						<div class="loading-container">
							<div class="control-group">
								<!--<label class="control-label">
							   		<div class="controls">
							 			<input class="text" type="text" disabled="disabled" name="Current-Vlaue" value="Current Value" />
							 			<input class="text" type="text" disabled="disabled" name="Current-Vlaue" value="New Value" />
							   		</div>
							  	</label>-->
								<div class="controls">
									<span class="label-header hidden-phone">Current Value</span>
									<span class="label-header hidden-phone">New Value</span>
								</div>
							</div>
							
							<!-- Loaders -->
							<div id="loading-bg">
								<xsl:text>
								</xsl:text>
							</div>
							<div id="loading" style="display:none">
								<img class="retina" src="/images/spinner.png" />
							</div>
							<!-- /Loaders -->
							
							<div id="AutomotiveListingEdit">
								
								<div class="control-group">
									<label class="control-label">Makes</label>
									<div class="controls"><input class="text" type="text" disabled="disabled" name="Current-Make" value="" />&nbsp;&nbsp;
										<select id="easylist-Makes" class="" name="listing-make-sel" onchange="MakeModelYearStyleChange(this, 'Models', '#easylist-Models,#easylist-Years,#easylist-Styles,#easylist-Transmission,#easylist-Variant');" value="">
											<option value="">Select an option</option>
											</select>
										</div>
								</div>
								<div class="control-group">
									<label class="control-label">Model</label>
									<div class="controls"><input class="text" type="text" disabled="disabled" name="Current-Model" value="" />&nbsp;&nbsp;
										<select id="easylist-Models" class="" name="listing-model-sel" onchange="MakeModelYearStyleChange(this, 'Years', '#easylist-Years,#easylist-Styles,#easylist-Transmission,#easylist-Variant');" value="">
											<option value="">Select an option</option>
											</select>
										</div>
								</div>
								<div class="control-group"><label class="control-label">Year</label>
									<div class="controls"><input class="text" type="text" disabled="disabled" name="Current-Year" value="" />&nbsp;&nbsp;
										<select id="easylist-Years" class="" name="listing-year-sel" onchange="MakeModelYearStyleChange(this, 'Styles', '#easylist-Styles,#easylist-Transmission,#easylist-Variant');" value="">
											<option value="">Select an option</option>
											</select>
										</div>
								</div>
								<div class="control-group"><label class="control-label">Styles</label>
									<div class="controls"><input class="text" type="text" disabled="disabled" name="Current-Styles" value="" />&nbsp;&nbsp;
										<select id="easylist-Styles" class="" name="listing-body-style-sel" onchange="MakeModelYearStyleChange(this, 'Transmissions', '#easylist-Transmission,#easylist-Variant');" value="">
											<option value="">Select an option</option>
											</select>
										</div></div>
								<div class="control-group"><label class="control-label">Transmission</label>
									<div class="controls"><input class="text" type="text" disabled="disabled" name="Current-Transmission" value="" />&nbsp;&nbsp;
										<select id="easylist-Transmission" class="" name="listing-transmission-sel" onchange="TransmissionChange(this);" value="">
											<option value="">Select an option</option>
											</select>
										</div>
								</div>
								<div class="control-group"><label class="control-label">Variant</label>
									<div class="controls">
										<input class="text" type="text" disabled="disabled" name="Current-Variant" value="" />&nbsp;&nbsp;
										<select id="easylist-Variant" class="" name="listing-variant-glass" onchange="VariantEditChange(this);" value="">
											<option value="">Select an option</option>
											</select>
										</div>
								</div>
								
							</div>
						</div>
					</fieldset>
					
					<fieldset id="UpdateData">
						<legend>Update data</legend>
						<div class="control-group">
							<label class="control-label">Item Title</label>
							<div class="controls">
								<input class="text allow-lowercase span8" type="text" readonly="readonly" maxlength="200" name="listing-title" id="listing-title"/>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Standard Features</label>
							<div class="controls">
								<label class="checkbox">
									<input type="checkbox" id="OverwriteStdFeatures" name="stdFeatureOverwrite" checked="checked" value="OverwriteStdFeatures" />
									Overwrite standard features list
								</label>
							</div>
						</div>
						<div class="alert alert-error" id ="ErrMsgDiv" style="display:none;">
							<label id="ErrMsg"/>
						</div>
					</fieldset>
				</div>
				
				<div class="tab-submit">
					<input type="hidden" id="easylist-standard-features"/>
					<input type="hidden" id="easylist-optional-features"/>
					
                    <a class="btn btn-info push-bottom" id="ConfirmGlass" href="#">
						<i class="icon-checkmark">&nbsp;</i> Confirm
					</a>&nbsp;&nbsp;
					<a class="btn btn-danger push-bottom" id="CancelGlass" href="#">
						<i class="icon-close">&nbsp;</i> Cancel
					</a>
				</div>
			</form>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>