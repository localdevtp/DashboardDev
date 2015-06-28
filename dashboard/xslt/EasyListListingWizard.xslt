<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
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

  <xsl:param name="currentPage"/>
  <xsl:template match="/">
    <!--  <textarea>  
  <xsl:copy-of select="umbraco.library:RequestForm('listing-category-path')" />
  </textarea> -->

    <xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Editor')" />
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
      <xsl:when test="string-length(umbraco.library:RequestForm('listing-category-id')) &gt; 0">
        <xsl:variable name="NewListingResponse" select="RESTscripts:NewListing()" />

        <xsl:choose>
          <!-- Success -->
          <!--<xsl:when test="string-length($NewListingResponse) &gt; 0">-->
          <xsl:when test="substring-before($NewListingResponse, ':') = 'SUCCESS'">
            <!--<xsl:variable name="successUrl" select="concat('/listings/edit?IsNew=true&amp;listing=', substring-after($NewListingResponse, ':'))" />
            <xsl:value-of select="scripts:RedirectTo($successUrl)" />
			-->
            <!--<textarea><xsl:copy-of select="substring-after($NewListingResponse, ':')" /></textarea>-->
            <!-- <div class="alert alert-success">
			  <button data-dismiss="alert" class="close" type="button">×</button>
			  <strong>Success!</strong> The listing was created successfully. Please note the changes will be displayed online in around 2 hours.
			   </div>
			   <div>
			  <p><a href="/listings/create">Continue to create a new listing.</a></p>
			   </div>
			   <div>
			  <p><xsl:element name="a">
			 <xsl:attribute name="href">
			   <xsl:value-of select="concat('/listings/edit?listing=', substring-after($NewListingResponse, ':'))"/>
			 </xsl:attribute>
			 Continue to add photos to the listing and edit the listing information.
			 </xsl:element></p>
			   </div> -->
          </xsl:when>
          <!-- Error -->
          <xsl:otherwise>
            <div class="alert alert-error">
              <button data-dismiss="alert" class="close" type="button">×</button>
              <strong>Failed!</strong> Failed to create new listing. Error : <xsl:copy-of select="$NewListingResponse" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!--^^^^^^^ No form post, new listing ^^^^^^^ -->
        <xsl:call-template name="NewListingEditor" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="NewListingEditor">
    <div class="widget-box">

      <!--
   <xsl:variable name="GetCatUI" select="LiScripts:GetCatUI()" />
	  <xsl:value-of select="$GetCatUI" disable-output-escaping="yes" />
   -->

      <div class="widget-title">
        <h2>
          <i class="icon-plus">
            <xsl:text>
						</xsl:text>
          </i><span class="break">&nbsp;</span> Create New Listing
        </h2>
      </div>

      <div class="widget-content">
        <form id="listing-wizard" class="form-horizontal wizard break-desktop-large" method="post">

          <div id="category" class="step" style="display:none;">
            <div class="form-left">
              <div class="control-group">
                <label class="control-label">Select Listing Category</label>
                <div class="controls">
                  <div id="CategorySelection">

                    <select id="CatLvl1" class="required" style="display:none" name="listing-cat1" onchange='CatChange(this, 1);'>
                      <option value="">Select a Category</option>
                    </select>
                  </div>
                </div>
              </div>

              <!--<div id="CatUI">
                &nbsp;
              </div>-->
              <input id="UIEditorLink" name="listing-UIEditorLink" type="hidden" class="link" value="GM" />
            </div>
            <div class="form-right">
				<div id="CustomAttribute"><xsl:text>
				</xsl:text>
              </div>
            </div>
          </div>

          <!--<div id="CustomAttribute" class="step" style="display:none">
            &nbsp;
            <input id="CustomAttributeListingLink" type="hidden" class="link" value="GM" />
          </div>-->

          <div id="AutomotiveListing" class="step" style="display:none">
            <label class="">Select your car attributes</label>
            <div class="control-group">
              <label class="control-label">Makes</label>
              <div class="controls">
                <select id="easylist-Makes" class="required" name="listing-make" onchange="MakeModelYearStyleChange(this, 'Models', '#easylist-Models');">
                  <option value="">Select an option</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Models</label>
              <div class="controls">
                <select id="easylist-Models" class="required" name="listing-model" onchange="MakeModelYearStyleChange(this, 'Years', '#easylist-Years');">
                  <option value="">Select an option</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Years</label>
              <div class="controls">
                <select id="easylist-Years" class="required" name="listing-year" onchange="MakeModelYearStyleChange(this, 'Styles', '#easylist-Styles');">
                  <option value="">Select an option</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Styles</label>
              <div class="controls">
                <select id="easylist-Styles" class="required" name="listing-body-style" onchange="MakeModelYearStyleChange(this, 'Transmissions', '#easylist-Transmission');">
                  <option value="">Select an option</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Transmission</label>
              <div class="controls">
                <select id="easylist-Transmission" class="required" name="listing-transmission" onchange="TransmissionChange(this);">
                  <option value="">Select an option</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Variant</label>
              <div class="controls">
                <select id="easylist-Variant" class="required" name="listing-variant-glass" onchange="VariantChange(this);">
                  <option value="">Select an option</option>
                </select>
              </div>
              <input type="hidden" id="listing-variant" name="listing-variant" value="" />
            </div>

            <!-- Confirm standard car features -->

            <div class="control-group" id="group-standard-features">
              <label class="control-label">Confirm the standard features that came with your car</label>
              <div id="easylist-standard-features" class="controls">
                <xsl:text>1</xsl:text>
              </div>
            </div>
            <div class="control-group" id="group-optional-features">
              <label class="control-label">Confirm the optional features that came with your car</label>
              <div id="easylist-optional-features" class="controls">
                <xsl:text>2</xsl:text>
              </div>
            </div>
            <div id="easylist-specs">
              <xsl:text>3</xsl:text>
            </div>
            <input id="AutomotiveListingLink" type="hidden" class="link" value="GM" />
          </div>

          <div id="MotorcycleListing" class="step" style="display:none">
            <label class="">Select your motorcycle attributes</label>
            <div class="control-group">
              <label class="control-label">Makes</label>
              <div class="controls">
                <select id="easylist-Motor-Makes" class="required" name="listing-motor-make" onchange="MotorMakeModelYearChange(this, 'Models', '#easylist-Motor-Models');">
                  <option value="">Select an option</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Models</label>
              <div class="controls">
                <select id="easylist-Motor-Models" class="required" name="listing-motor-model" onchange="MotorMakeModelYearChange(this, 'Years', '#easylist-Motor-Years');">
                  <option value="">Select an option</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Years</label>
              <div class="controls">
                <select id="easylist-Motor-Years" class="required" name="listing-motor-year" onchange="MotorYearChange(this);">
                  <option value="">Select an option</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Variant</label>
              <div class="controls">
                <select id="easylist-Motor-Variant" class="required" name="listing-motor-variant-glass" onchange="MotorVariantChange(this);">
                  <option value="">Select an option</option>
                </select>
              </div>
              <input type="hidden" id="listing-motor-variant" name="listing-motor-variant" value="" />
            </div>
            <!-- Populate from MotorVariantChange -->
            <div id="easylist-Motor-specs">
              <xsl:text>3</xsl:text>
            </div>
            <input id="MotorcycleListingLink" type="hidden" class="link" value="GM" />
          </div>

          <div id="GM" class="step" style="display:none">
            <div class="control-group">
              <label class="control-label">Category</label>
              <div class="controls">
                <input id="listing-category-id" type="hidden" name="listing-category-id" />
                <input id="listing-category-name" type="hidden" maxlength="100" name="listing-category-name" />
                <label id="listing-category-path">&nbsp;</label>
                <!-- <input id="listing-category-path" class="uneditable-input" name="listing-category-path" /> -->
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Item Title&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Provide the brand and/or type of item you're selling">&nbsp;</i>
              </label>
              <div class="controls">
                <input id="listing-title" class="span8 required" type="text" maxlength="100" name="listing-title">
                  <xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 100, messages: {required: 'Please enter the listing title'}}</xsl:attribute>
                </input>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">
                Summary Description&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Displayed in search results">&nbsp;</i>
              </label>
              <div class="controls">
                <textarea id="listing-summary" name="listing-summary" class="summary span8" rows="4" cols="40">
                  <xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 250, messages: {required: 'Please enter a short summary description for display in search results'}}</xsl:attribute>
                  <xsl:text>&nbsp;</xsl:text>
                </textarea>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Full Description&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Displayed on the details screen">&nbsp;</i>
              </label>
              <div class="controls">
                <textarea class="span8" rows="10" cols="40" id="listing-description" name="listing-description">
                  <xsl:attribute name="data-validate">{required: false, minlength: 6, maxlength: 5000, messages: {required: 'Please enter a detailed description for display on the item details page'}}</xsl:attribute>
                  <xsl:text>&nbsp;</xsl:text>
                </textarea>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Price</label>
              <div class="controls">
                <div class="input-prepend inline">
                  <span class="add-on">$</span>
                  <input class="span2 required number" id="listing-price" type="text" maxlength="13" name="listing-price">
                    <xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
                  </input>
                </div>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Price Description</label>
              <div class="controls">
                <select class="span3 inline" name="listing-price-attribute">
                  <option value="">Select an option</option>
                  <option value="Negotiable">Negotiable</option>
                  <option value="Call for price">Call for Price</option>
                  <option value="Drive Away">Drive Away</option>
                </select>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Condition</label>
              <div class="controls">
                <select class="span2 required listing-condition" name="listing-condition">
                  <option value="">Select an option</option>
                  <option value="New">New</option>
                  <option value="Used">Used</option>
                  <option value="Demo">Demo</option>
                </select>
                <select class="span2 listing-condition-desc" name="listing-condition-desc">
                  <option value="">Select an option</option>
                  <option value="Excellent">Excellent</option>
                  <option value="Very Good">Very Good</option>
                  <option value="Good">Good</option>
                  <option value="Fair">Fair</option>
                </select>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Terms and Condtions</label>
              <div class="controls">
                <label class="checkbox">
                  <input class="required" type="checkbox" name="terms-and-conditions" value="accept" />
                  I accept the <a href="/docs/terms-and-conditions" target="_blank">terms and conditions of sale</a>
                </label>
              </div>
            </div>

          </div>

          <div class="form-actions center">
            <input id="back" class="btn" type="reset" value="Back" />&nbsp;
            <input id="next" class="btn btn-success" type="submit" value="Next" />

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
  </xsl:template>

</xsl:stylesheet>