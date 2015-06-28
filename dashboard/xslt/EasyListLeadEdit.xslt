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
	xmlns:leadsapi="urn:leadsapi"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml leadsapi umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:include href="EasyListRestHelper.xslt" />
  <xsl:include href="EasyListHelper.xslt" />
  <xsl:include href="EasyListStaffHelper.xslt" />
  <xsl:include href="LeadsAPIHelper.xslt" />

  <!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->


  <!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

  <xsl:param name="currentPage"/>

  <!--<xsl:variable name="dealerCode" select="umbraco.library:Session('easylist-usercode')" />-->
  <xsl:variable name="dealerCode" select="leadsapi:CustomerChildList()" />

  <xsl:variable name="leadCode" select="umbraco.library:RequestQueryString('id')" />
  <xsl:variable name="markAsViewed">0</xsl:variable>
  <xsl:variable name="userName" select="umbraco.library:Session('easylist-username')" />
  <xsl:variable name="displayName" select="umbraco.library:Session('easylist-displayname')" />

  <xsl:template match="/">

    <!-- start writing XSLT -->
    <xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Editor,Sales,RetailUser')" />
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

    <!-- Check for post-back -->
    <xsl:variable name="submit" select="umbraco.library:RequestForm('submit')" />

    <!-- Get the Lead data -->
    <xsl:choose>
      <xsl:when test="$submit='save'">
        <xsl:variable name="data" select="leadsapi:SaveLead($dealerCode, $leadCode, $userName, $displayName)" />
        <xsl:choose>
          <xsl:when test="$data/Lead">
            <div class="alert alert-success">
              <button data-dismiss="alert" class="close" type="button">×</button>
              <strong>Changes Saved</strong> Your changes were saved successfully.
            </div>
            <div class="widget-box">
              <div class="widget-title">
                <h2>
                  <i class="icon-pencil">
                    <xsl:text>
												</xsl:text>
                  </i> Edit Lead
                </h2>
              </div>
              <div class="widget-content">
                <xsl:call-template name="edit-lead">
                  <xsl:with-param name="data" select="$data/Lead" />
                </xsl:call-template>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="alert alert-error">
              <button data-dismiss="alert" class="close" type="button">×</button>
              <strong>Oops!</strong> Something went wrong when saving your lead - please try again.
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:variable name="data" select="leadsapi:GetLead($dealerCode, $leadCode, $markAsViewed, $userName)" />
        <xsl:choose>
          <xsl:when test="$data/Lead">

           <xsl:variable name="warningMessage" select="$data/Lead/Moderation_Remark" />
   
            <xsl:if test="$warningMessage != ''">
                <div class="alert alert-warning" id="WarningMessage">
				    <xsl:value-of select="$warningMessage" disable-output-escaping="yes" />
			    </div>
            </xsl:if>
              
            <div class="widget-box">
              <div class="widget-title">
                <h2>
                  <i class="icon-pencil">
                    <xsl:text>
												</xsl:text>
                  </i> Edit Lead
                </h2>
              </div>
              <div class="widget-content">
                <xsl:call-template name="edit-lead">
                  <xsl:with-param name="data" select="$data/Lead" />
                </xsl:call-template>
              </div>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="alert alert-error">
              <button data-dismiss="alert" class="close" type="button">×</button>
              <strong>Oops!</strong> The lead you're trying to view either doesn't exist, or you don't have permissions to view it.
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  <!-- /LOADPAGE TEMPLATE -->

  <!-- EDIT LEAD TEMPLATE -->
  <xsl:template name="edit-lead">

    <xsl:param name="data" />

    <form id="edit-lead" method="post" class="form-horizontal break-desktop-large">
      <input type="hidden" name="id" value="{$data/LeadCode}" />
      <input type="hidden" name="dealerid" value="{$data/DealerCode}" />
      <!-- Lead Details -->
      <fieldset style="margin-top:-10px;">
        <legend>Lead Details</legend>

        <div class="form-left">

          <div class="control-group">
            <label class="control-label">Lead ID</label>
            <div class="controls">
              <input type="text" class="input-xlarge required" name="leadCode" disabled="disabled">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/LeadCode"/>
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Assigned To</label>
            <div class="controls">

              <label class="value">
                <xsl:choose>
                  <xsl:when test="$data/AssignedTo">
                    <xsl:value-of select="$data/AssignedTo" />
                  </xsl:when>
                  <xsl:otherwise>Unassigned</xsl:otherwise>
                </xsl:choose>
              </label>

              <!--
							<input type="text" class="input-xlarge" name="lead-assigned-to">
								<xsl:attribute name="value"><xsl:value-of select="$data/AssignedTo"/></xsl:attribute>
							</input>
							-->

            </div>
          </div>

          <div class="control-group">
            <label class="control-label">
              <xsl:choose>
                <xsl:when test="$data/AssignedTo">Re-Assign Lead To</xsl:when>
                <xsl:otherwise>Assign Lead To</xsl:otherwise>
              </xsl:choose>
            </label>

            <div class="controls">
              <select name="assignedTo" class="input-xlarge">

                <option value="">
                  <xsl:choose>
                    <xsl:when test="$data/AssignedTo">Don't re-assign the lead</xsl:when>
                    <xsl:otherwise>Don't assign the lead</xsl:otherwise>
                  </xsl:choose>
                </option>
                <option value="{$userName}">
                  <xsl:if test="$userName = $data/AssignedTo">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                  </xsl:if>
                  Assign to me
                </option>               
                <xsl:variable name="DealerStaffList" select="AccScripts:GetDealerStaff()" />
                <xsl:choose>
                  <xsl:when test="string-length($DealerStaffList/error) &gt; 0">
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="$DealerStaffList/ArrayOfUserStaff/UserStaff">
                      <option value="{./LoginName}">
                        <xsl:if test="./LoginName= $data/AssignedTo">
                          <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="./FirstName" />&nbsp;<xsl:value-of select="./LastName" />
                      </option>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </select>

            </div>
          </div>
			
           <div class="control-group">
            <label class="control-label">Lead Status</label>
            <div class="controls">

              <select name="masterStatus" class="input-xlarge required">
                <xsl:choose>
                  <xsl:when test="$data/MasterStatus='Unassigned'">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                    <option value="Unassigned" selected="selected">Unassigned</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="optionlist">
                      <xsl:with-param name="options">Assigned,Follow Up,Closed – Won,Closed – Lost</xsl:with-param>
                      <xsl:with-param name="value">
                        <xsl:value-of select="$data/MasterStatus"/>
                      </xsl:with-param>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </select>
            </div>
          </div>

        </div>
        <div class="form-right">

          <div class="control-group">
            <!--<label class="control-label">Lead Age</label>
						<div class="controls">
							<label class="value">TBA</label>
							<input type="text" class="input-xlarge required" name="lead-created-by" disabled="disabled">
								<xsl:attribute name="value"><xsl:value-of select="$data/LastEditedBy"/></xsl:attribute>
							</input>
						</div>-->
            <label class="control-label">Lead Received</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="lead-received" disabled="disabled">
                <xsl:attribute name="value">
                  <xsl:value-of select="umbraco.library:FormatDateTime($data/Created, 'd MMM yyyy, HH:mm:ss')" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Lead Type</label>
            <div class="controls">
              <label class="value">
                <xsl:value-of select="$data/LeadType"/>
              </label>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Lead Source</label>
            <div class="controls">
              <label class="value">
                <xsl:choose>
                  <xsl:when test="$data/SourceInfo !='' and $data/SourceInfo !='NaN'">
                    <a href="{$data/SourceInfo}" target="_blank">
                      <xsl:value-of select="$data/Source"/>
                    </a>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$data/Source"/>
                  </xsl:otherwise>
                </xsl:choose>
              </label>
            </div>
          </div>

			 <xsl:variable name="BuyerMessageFormatted" select="umbraco.library:Replace($data/BuyerMessage,'&#xD;&#xA;','%0D%0A')"/>
		  
          <xsl:if test="$data/BuyerEmail !='' and contains($data/BuyerEmail, '@')">
            <div class="control-group">
              <div class="controls">
                  <a href="mailto:{$data/BuyerEmail}?subject=RE: {$data/ListingTitle}&amp;body=%0D%0A%0D%0A&gt;&gt;&gt;Original Message&gt;&gt;&gt;%0D%0A{$BuyerMessageFormatted}" class="btn btn-large btn-success">
                  <i class="icon-mail">&nbsp;</i>Reply to this lead now
                </a>
              </div>
            </div>
          </xsl:if>

          <!--
					<div class="control-group">
						<label class="control-label">EasyList Listing Code</label>
						<div class="controls">
							<input type="text" class="input-xlarge required" name="easylist-listing-code" disabled="disabled">
								<xsl:attribute name="value"><xsl:value-of select="$data/ListingCode"/></xsl:attribute>
							</input>
						</div>
					</div>
					-->



        </div>
      </fieldset>
      <!-- /Lead Details -->


      <!-- Listing Details -->
      <fieldset>
        <legend>Listing Details</legend>

        <div>
          <div class="control-group">
            <label class="control-label">Listing</label>
            <div class="controls">
              <label class="value">
                <a target="_blank" href="/listings/edit?listing={$data/ListingCode}">
                  <xsl:value-of select="$data/ListingTitle" />
                </a>
              </label>
            </div>
          </div>
        </div>

        <div class="form-left">

          <!--
					<div class="control-group">
						<label class="control-label">Listing</label>
						<div class="controls">
							<label class="value"><a target="_blank" href="/listings/edit?listing={$data/ListingCode}"><xsl:value-of select="$data/ListingCode" /></a></label>
						</div>
					</div>
-->

          <div class="control-group">
            <label class="control-label">Stock Number</label>
            <div class="controls">
              <label class="value">
                <xsl:value-of select="$data/ListingStockNum" />
              </label>
            </div>
          </div>
          <!--
					<div class="control-group">
						<label class="control-label">Listing Title</label>
						<div class="controls">
							<label class="value"><xsl:value-of select="$data/ListingTitle" /></label>
						</div>
					</div>-->

          <div class="control-group">
            <label class="control-label">Original Price</label>
            <div class="controls">
              <label class="value">
                <xsl:value-of select="$data/ListingPrice"/>
              </label>
              <!--
							<div class="input-prepend inline">
								<span class="add-on">$</span>
								<input class="input-xlarge required money" type="text" maxlength="13" id="listing-price" name="listing-price">
									<xsl:attribute name="data-validate">{required: true, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
								</input>
							</div>
							-->
            </div>
          </div>

        </div>

        <div class="form-right">

          <div class="control-group lst-condition">
            <label class="control-label">Condition</label>
            <div class="controls">
              <label class="value">
                <xsl:value-of select="$data/ListingCond" />
              </label>
              <!--
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
							-->
            </div>
          </div>

          <div class="control-group lst-condition">
            <label class="control-label">Stock Location</label>
            <div class="controls">
              <label class="value">
                <xsl:value-of select="$data/ListingLoc" />
              </label>
            </div>
          </div>

          <!--
					<div class="control-group">
						<label class="control-label">Listing Location</label>
						<div class="controls">
							<input class="text allow-lowercase input-xlarge" type="text" maxlength="50" id="listing-location"  name="listing-location" autocomplete="off" placeholder="Suburb, State Postcode">
								<xsl:attribute name="data-validate">{required: false, regex:/^(?:[A-Za-z0-9\s]*)(?:,)(?:[A-Za-z0-9\s]*)(?:\s)(?:[0-9]*)$/,minlength: 1, maxlength: 50, messages: {regex:'Please enter a valid location (e.g. Sydney, NSW 2000)' ,required: 'Please enter the location'}}</xsl:attribute>
							</input>
						</div>
					</div>
					-->

          <!-- ADDITIONAL FIELDS?
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



      <!-- Buyer Details -->
      <fieldset>
        <legend>Buyer Details</legend>

        <div class="form-left">

          <div class="control-group">
            <label class="control-label">Buyer Title</label>
            <div class="controls">

              <select name="buyerTitle" class="input-xlarge required">
                <xsl:call-template name="optionlist">
                  <xsl:with-param name="options">
                    Mr,Mrs,Ms,Dr
                  </xsl:with-param>
                </xsl:call-template>
              </select>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Buyer Name</label>
            <div class="controls">
              <input type="text" class="input-xlarge required" name="buyerName">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/BuyerName" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Buyer Email</label>
            <div class="controls">
              <input type="text" class="input-xlarge email" name="buyerEmail">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/BuyerEmail" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Buyer Home Phone</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="buyerHPhone">
                <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50}</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/BuyerHPhone" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Buyer Mobile Phone</label>
            <div class="controls">
				<input type="text" class="input-xlarge" name="buyerMPhone" id="buyerMPhone">
                <xsl:attribute name="data-validate">{required: false, minlength: ($('#buyerMPhone').val() == 'N/A') ? 0 : 5, maxlength: 50}</xsl:attribute>
                <xsl:attribute name="value">
                   <xsl:value-of select="$data/BuyerMPhone" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Buyer Work Phone</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="buyerWPhone">
                <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50}</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/BuyerWPhone" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Buyer Type</label>
            <div class="controls">

              <select name="buyerType" class="input-xlarge required">
                <xsl:call-template name="optionlist">
                  <xsl:with-param name="options">
                    Private,
                    Company,
                    Company - Retail,
                    Company - Fleet,
                    Government,
                    Government - Retail,
                    Government - Fleet
                  </xsl:with-param>
                  <xsl:with-param name="value">
                    <xsl:value-of select="$data/BuyerType"/>
                  </xsl:with-param>
                </xsl:call-template>
              </select>
            </div>
          </div>


        </div>

        <div class="form-right">

          <div class="control-group">
            <label class="control-label">Buyer Campaign Opt-Ins</label>
            <div class="controls">
              <label class="checkbox inline">
                <input type="checkbox" name="buyerDMOptIn">
                  <xsl:if test="$data/BuyerDMOptIn='1'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input> DM
              </label>
              <label class="checkbox inline">
                <input type="checkbox" name="buyerEDMOptIn">
                  <xsl:if test="$data/BuyerEDMOptIn='1'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input> EDM
              </label>
              <label class="checkbox inline">
                <input type="checkbox" name="buyerSMSOptIn">
                  <xsl:if test="$data/BuyerSMSOptIn='1'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input> SMS
              </label>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Buyer Message</label>
            <div class="controls">
              <textarea class="input-xlarge" style="height:10em">
                <xsl:choose>
                  <xsl:when test="$data/BuyerMessage !=''">
                    <xsl:value-of select="$data/BuyerMessage" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>
								</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </textarea>
            </div>
          </div>

          <!--
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
					-->
          <div class="control-group">
            <label class="control-label">Buyer Location</label>
            <div class="controls">

              <textarea class="input-xlarge" style="height:5em" name="buyerLocation">
                <xsl:choose>
                  <xsl:when test="$data/BuyerLocation !=''">
                    <xsl:value-of select="$data/BuyerLocation" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>
								</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </textarea>
              <!--
							<input class="text allow-lowercase input-xlarge" type="text" maxlength="50" id="buyer-location"  name="buyer-location" autocomplete="off" placeholder="Suburb, State Postcode">
								<xsl:attribute name="data-validate">{required: false, regex:/^(?:[A-Za-z0-9\s]*)(?:,)(?:[A-Za-z0-9\s]*)(?:\s)(?:[0-9]*)$/,minlength: 1, maxlength: 50, messages: {regex:'Please enter a valid location (e.g. Sydney, NSW 2000)' ,required: 'Please enter the location'}}</xsl:attribute>
								<xsl:attribute name="value" select="$data/BuyerLocation" />
							</input>
-->
            </div>
          </div>

          <!-- ADDITIONAL FIELDS?
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


      <!-- Company Details -->
      <fieldset>
        <legend>Company Details</legend>

        <div class="form-left">

          <div class="control-group">
            <label class="control-label">Company Name</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="companyName">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/CompanyName" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Company Position</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="companyPos">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/CompanyPos" />
                </xsl:attribute>
              </input>
            </div>
          </div>

        </div>

        <div class="form-right">

          <div class="control-group">
            <label class="control-label">Company Address</label>
            <div class="controls">
              <textarea class="input-xlarge" style="height:5em" name="companyAddress">
                <xsl:choose>
                  <xsl:when test="$data/CompanyAddress !=''">
                    <xsl:value-of select="$data/CompanyAddress" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>
								</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </textarea>
            </div>
          </div>

        </div>


      </fieldset>
      <!-- /Company Details -->


      <fieldset>
        <legend>Notes/Comments</legend>
        <div class="form">
          <div class="control-group">
            <label class="control-label">Notes/Comments</label>
            <div class="controls">
              <textarea type="text" class="input-xlarge" name="sellerComments">
                <xsl:value-of select="$data/SellerComments" />&nbsp;
              </textarea>
            </div>
          </div>
        </div>
      </fieldset>

      <!-- Trade In Details -->
      <fieldset>
        <legend>Trade In Details</legend>

        <div class="form-left">

          <div class="control-group">
            <label class="control-label">Trade In Make</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="tradeInMake">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/TradeInMake" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Trade In Model</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="tradeInModel">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/TradeInModel" />
                </xsl:attribute>
              </input>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Trade In Year</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="tradeInYear">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/TradeInYear" />
                </xsl:attribute>
              </input>
            </div>
          </div>

        </div>

        <div class="form-right">

          <div class="control-group">
            <label class="control-label">Trade In Odometer</label>
            <div class="controls">
              <input type="text" maxlength="9" name="tradeInOdo" class="text integer inline input-medium">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/TradeInOdo" />
                </xsl:attribute>
              </input>
              <!--
							<select class="inline input-small" name="trade-in-odometer-unit" style="margin-left:10px;">
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">KM,MI</xsl:with-param>
								</xsl:call-template>
							</select>-->
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Trade In Valuation</label>
            <div class="controls">
              <div class="input-prepend inline">
                <span class="add-on">$</span>
                <input class="input-xlarge money" type="text" maxlength="13" id="trade-in-price" name="tradeInValue">
                  <xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$data/TradeInValue" />
                  </xsl:attribute>
                </input>

              </div>
            </div>
          </div>

          <div class="control-group">
            <label class="control-label">Trade In Valuation Expiry Date</label>
            <div class="controls">
              <input type="text" class="input-xlarge" name="tradeInValueExpiry">
                <xsl:attribute name="value">
                  <xsl:value-of select="$data/TradeInValueExpiry" />
                </xsl:attribute>
              </input>
              <!--
							<select class="drop-down input-small" id="listing-vehicle-expiry-month" name="trade-in-valuation-expiry-month">
								<option value="">MM</option>
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">1,2,3,4,5,6,7,8,9,10,11,12</xsl:with-param>
								</xsl:call-template>
							</select>
							<select class="drop-down input-small" id="listing-vehicle-expiry-year" name="trade-in-valuation-expiry-year" style="margin-left:10px;">
								<option value="">YYYY</option>
								<xsl:call-template name="optionlist">
									<xsl:with-param name="options">2012,2013,2014,2015</xsl:with-param>
								</xsl:call-template>
							</select>
							-->
            </div>
          </div>

        </div>

      </fieldset>
      <!-- /Trade In Details -->



      <!-- Form Actions -->
      <div class="form-actions center">
        <a href="/leads" class="btn btn-large">
          <i class="icon-chevron-left">&nbsp;</i> Back
        </a> &nbsp;
        <button type="submit" name="submit" value="save" id="submit" class="btn btn-large btn-success">
          <i class="icon-checkmark">&nbsp;</i> Save Changes
        </button>
      </div>
      <!-- /Form Actions -->
    </form>
  </xsl:template>
  <!-- /EDIT LEAD TEMPLATE -->

  <!-- Drop-down options template -->
  <xsl:template name="optionlist">
    <xsl:param name="options"/>
    <xsl:param name="value"/>

    <xsl:for-each select="umbraco.library:Split($options,',')//value">

      <xsl:variable name="trimmed" select="umbraco.library:Replace(umbraco.library:Replace(.,'–',''),' ','')"/>
      <option>
        <xsl:attribute name="value">
          <xsl:value-of select="$trimmed"/>
        </xsl:attribute>
        <!-- check to see whether the option should be selected-->
        <xsl:if test="$value = $trimmed">
          <xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test=". !=''">
            <xsl:value-of select="." />
          </xsl:when>
          <xsl:otherwise>[Select an option]</xsl:otherwise>
        </xsl:choose>
      </option>
    </xsl:for-each>
  </xsl:template>

  <!--
	<xsl:template name="optionlistValue">
		<xsl:param name="options"/>
		<xsl:param name="value"/>
		
		<xsl:for-each select="umbraco.library:Split($options,',')//value">
			<option>
				<xsl:attribute name="value">
					<xsl:value-of select="substring-before(., '|')" />
				</xsl:attribute>

				<xsl:if test="$value=substring-before(., '|')">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test=". !=''">
						<xsl:value-of select="substring-after(., '|')" />
					</xsl:when>
					<xsl:otherwise>Select an option</xsl:otherwise>
				</xsl:choose>
			</option>
		</xsl:for-each>
	</xsl:template>
	-->
</xsl:stylesheet>