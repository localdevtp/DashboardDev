<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:scripts="urn:scripts.this"
xmlns:RESTscripts="urn:RESTscripts.this"
xmlns:AccScripts="urn:AccScripts.this"
xmlns:asp="http://schemas.microsoft.com"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:easylist="urn:http://easylist.com.au/api"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
exclude-result-prefixes="msxml easylist scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
    
    <xsl:output method="html" omit-xml-declaration="yes" />
    <xsl:include href="EasyListRestHelper.xslt" />
    <xsl:include href="EasyListEditAPIHelper.xslt" />
    <xsl:include href="EasyListStaffHelper.xslt" />
    
    <xsl:variable name="userName" select="umbraco.library:Session('easylist-username')" />
    <xsl:variable name="password" select="umbraco.library:Session('easylist-password')" />
    <xsl:variable name="listingCode" select="/macro/listingCode" />
    
    <xsl:variable name="IsPostBack" select="umbraco.library:Request('update-listing') = 'true'" />
    <xsl:variable name="LstPostBackStatus" select="umbraco.library:Request('update-listing-state')" />
    
    <xsl:variable name="LstCatalogID" select="umbraco.library:Request('listing-catalog')" />
	<xsl:variable name="LstUserCode" select="umbraco.library:Request('listing-usercode')" />
    
    <xsl:variable name="LstTitle" select="umbraco.library:Request('listing-title')" />
    <xsl:variable name="LstSumDesc" select="umbraco.library:Request('listing-summary')" />
    <xsl:variable name="LstDesc" select="umbraco.library:Request('listing-description')" />
	
	<xsl:variable name="LstHasPrice" select="umbraco.library:Request('listing-has-price')" />
    <xsl:variable name="LstPrice" select="umbraco.library:Request('listing-price')" />
    <xsl:variable name="LstWasPrice" select="umbraco.library:Request('listing-was-price')" />
    <xsl:variable name="LstPriceQualifier" select="umbraco.library:Request('listing-price-qualifier-orig')" />
	
	<xsl:variable name="LstIsAccountLevel" select="umbraco.library:Request('listing-contact-setting')" />
	<xsl:variable name="LstContactName" select="umbraco.library:Request('listing-contact-name')" />
	<xsl:variable name="LstContactEmail" select="umbraco.library:Request('listing-contact-email')" />
	<xsl:variable name="LstContactPhone" select="umbraco.library:Request('listing-contact-phone')" />
	
    <xsl:variable name="LstCondition" select="umbraco.library:Request('listing-condition')" />
    <xsl:variable name="LstConditionDesc" select="umbraco.library:Request('listing-condition-desc')" />
    <xsl:variable name="LstStockNumber" select="umbraco.library:Request('listing-stock-number')" />
    <xsl:variable name="LstLocation" select="umbraco.library:Request('listing-location')" />
    <xsl:variable name="LstPublish" select="umbraco.library:Request('listing-publish')" />
    
    <xsl:variable name="LstBodyStyle" select="umbraco.library:Request('listing-body-style')" />
    <xsl:variable name="LstDoors" select="umbraco.library:Request('listing-doors')" />
    <xsl:variable name="LstSeats" select="umbraco.library:Request('listing-seats')" />
    <xsl:variable name="LstBodyDesc" select="umbraco.library:Request('listing-body-style-description')" />
    <xsl:variable name="LstExtColor" select="umbraco.library:Request('listing-exterior-colour')" />
    <xsl:variable name="LstIntColor" select="umbraco.library:Request('listing-interior-colour')" />
    <xsl:variable name="LstOdometer" select="umbraco.library:Request('listing-odometer-value')" />
    <xsl:variable name="LstOdometerUnit" select="umbraco.library:Request('listing-odometer-unit')" />
    <!-- <xsl:variable name="LstRegNo" select="umbraco.library:Request('listing-registration-number')" />
    <xsl:variable name="LstVinNumber" select="umbraco.library:Request('listing-vinnumber')" /> -->
    <xsl:variable name="LstRegType" select="umbraco.library:Request('listing-registration-type')" />
    <xsl:variable name="LstDriveType" select="umbraco.library:Request('listing-drive-type')" />
    <xsl:variable name="LstTransType" select="umbraco.library:Request('listing-transmission-type')" />
    <xsl:variable name="LstTransDesc" select="umbraco.library:Request('listing-transmission-description')" />
    <xsl:variable name="LstEngType" select="umbraco.library:Request('listing-engine-type-description')" />
    <xsl:variable name="LstEngCylinder" select="umbraco.library:Request('listing-engine-cylinders')" />
    <xsl:variable name="LstEngSize" select="umbraco.library:Request('listing-engine-size-description')" />
	<xsl:variable name="LstEngDesc" select="umbraco.library:Request('listing-engine-description')" />
    <xsl:variable name="LstFuelType" select="umbraco.library:Request('listing-fuel-type-description')" />
    <xsl:variable name="LstGears" select="umbraco.library:Request('listing-gears')" />
    
    <xsl:variable name="LstVehicleReg" select="umbraco.library:Request('listing-vehicle-registered')" />
    <xsl:variable name="LstRegExpMth" select="umbraco.library:Request('listing-vehicle-expiry-month')" />
    <xsl:variable name="LstRegExpYear" select="umbraco.library:Request('listing-vehicle-expiry-year')" />
    <xsl:variable name="LstRegNo" select="umbraco.library:Request('listing-vehicle-rego')" />
	<xsl:variable name="LstVinNo" select="umbraco.library:Request('listing-vehicle-VIN')" />
    <xsl:variable name="LstVinEngine" select="umbraco.library:Request('listing-vehicle-VinEngine')" />
    <!-- <xsl:variable name="LstVinEngineNo" select="umbraco.library:Request('listing-vehicle-VinEngine-No')" /> -->
	<xsl:variable name="LstVinEngineVinNo" select="umbraco.library:Request('listing-vehicle-VinEngine-VIN')" />
	<xsl:variable name="LstVinEngineEngineNo" select="umbraco.library:Request('listing-vehicle-VinEngine-Engine')" />
	
    <xsl:variable name="LstVehicleCert" select="umbraco.library:Request('listing-vehicle-cert')" />
    
    <xsl:variable name="LxTitle" select="umbraco.library:Request('lock-title')" />
	<xsl:variable name="LxImages" select="umbraco.library:Request('lock-photo')" />
	<xsl:variable name="LxVideos" select="umbraco.library:Request('lock-video')" />
	<xsl:variable name="LxVehicleFeatures" select="umbraco.library:Request('lock-features')" />
	
    <xsl:variable name="LxSumDesc" select="umbraco.library:Request('lock-summary-description')" />
    <xsl:variable name="LxDesc" select="umbraco.library:Request('lock-description')" />
    <xsl:variable name="LxPrice" select="umbraco.library:Request('lock-price')" />
	
	<xsl:variable name="LxDriveawayPrice" select="umbraco.library:Request('lock-driveaway-price')" />
	<xsl:variable name="LxSalePrice" select="umbraco.library:Request('lock-sale-price')" />
	<xsl:variable name="LxUnqualifiedPrice" select="umbraco.library:Request('lock-unqualified-price')" />
	
    <xsl:variable name="LxWasPrice" select="umbraco.library:Request('lock-was-price')" />
	
	<xsl:variable name="LstDriveAwayPrice" select="umbraco.library:Request('listing-driveaway-price')" />
	<xsl:variable name="LstSalePrice" select="umbraco.library:Request('listing-sale-price')" />
	<xsl:variable name="LstUnqualifiedPrice" select="umbraco.library:Request('listing-unqualified-price')" />
		
    <xsl:variable name="LxPriceQualifier" select="umbraco.library:Request('lock-price-qualifier')" />
    <xsl:variable name="LxCondition" select="umbraco.library:Request('lock-condition')" />
    <xsl:variable name="LxStkNo" select="umbraco.library:Request('lock-stock-number')" />
    <xsl:variable name="LxLocation" select="umbraco.library:Request('lock-location')" />
    
    <xsl:variable name="LxBodyStyle" select="umbraco.library:Request('lock-body-style')" />
    <xsl:variable name="LxDoors" select="umbraco.library:Request('lock-doors')" />
    <xsl:variable name="LxSeats" select="umbraco.library:Request('lock-seats')" />
    <xsl:variable name="LxBodyDesc" select="umbraco.library:Request('lock-body-style-description')" />
    <xsl:variable name="LxExtColor" select="umbraco.library:Request('lock-exterior-colour')" />
    <xsl:variable name="LxIntColor" select="umbraco.library:Request('lock-interior-colour')" />
    <xsl:variable name="LxOdometer" select="umbraco.library:Request('lock-odometer')" />
    <xsl:variable name="LxRegNo" select="umbraco.library:Request('lock-registration')" />
    <xsl:variable name="LxVinNumber" select="umbraco.library:Request('lock-vinnumber')" />
    <xsl:variable name="LxDriveType" select="umbraco.library:Request('lock-drive-type')" />
    <xsl:variable name="LxTransType" select="umbraco.library:Request('lock-transmission-type')" />
    <xsl:variable name="LxTransDesc" select="umbraco.library:Request('lock-transmission-description')" />
    <xsl:variable name="LxEngType" select="umbraco.library:Request('lock-engine-type-description')" />
    <xsl:variable name="LxEngCylinder" select="umbraco.library:Request('lock-engine-cylinders')" />
    <xsl:variable name="LxEngSize" select="umbraco.library:Request('lock-engine-size-description')" />
	<xsl:variable name="LxEngDesc" select="umbraco.library:Request('lock-engine-description')" />
	
    <xsl:variable name="LxFuelType" select="umbraco.library:Request('lock-fuel-type-description')" />
    <xsl:variable name="LxGears" select="umbraco.library:Request('lock-gears')" />
    
    <xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Editor,Sales,RetailUser')" />
    <!-- Sales group can view but cannot edit -->
    <xsl:variable name="IsManagerEditorGroup" select="AccScripts:IsAuthorized('Manager,Editor,RetailUser')" />
    <xsl:variable name="IsSalesGroup" select="AccScripts:IsAuthorized('Sales')" />
    
    <xsl:variable name="IsRetailUser" select="AccScripts:IsRetailUser()" />
	
	<xsl:variable name="dealerIDList" select="umbraco.library:Session('easylist-usercodelist')" />
	<xsl:variable name="HasChildList" select="scripts:HasChildList($dealerIDList)"/>
    
    <xsl:param name="currentPage"/>
    
    <xsl:template match="/">
		
		<xsl:variable name="ListingsLink">/listings?ListingType=<xsl:value-of select="umbraco.library:RequestQueryString('ListingType')"/>&amp;HasException=<xsl:value-of select="umbraco.library:RequestQueryString('HasException')"/>&amp;page=<xsl:value-of select="umbraco.library:RequestQueryString('page')"/>
		</xsl:variable>
		
		<ul class="breadcrumb">
			<li><a href="/"><i class="icon-home">&nbsp;</i> Home</a><i class="icon-dot">&nbsp;</i></li>
			<li><a href="{$ListingsLink}"><i class="icon-list-2">&nbsp;</i> Listings</a></li>
		</ul>
		
		<xsl:if test="$IsRetailUser != 'true'">
			<ul class="nav nav-pills">
				<li class="active">
					<a href="/listings?ListingType=Car"><i class="icon-list-2">&nbsp;</i> Listings</a>
				</li>
				<li>
					<a href="/bulk-upload"><i class="icon-stack-1">&nbsp;</i> Bulk Upload</a>
				</li>
				<li>
					<a href="/download"><i class="icon-download-2">&nbsp;</i> Download Photo Management App</a>
				</li>
			</ul>
		</xsl:if>
	
        <!-- start writing XSLT -->
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
        <xsl:if test="$IsManagerEditorGroup = false">
            <input type="hidden" id="ListingViewOnly"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="LoadPage" >
        
        
        
        <!-- 
  <div>
  <textarea>
    <xsl:value-of select="$IsPostBack" />
  </textarea>
  </div> -->
      <xsl:choose>
          <xsl:when test="string-length(umbraco.library:RequestForm('listing-code')) &gt; 0">
              
              <!-- Form has been submitted, work out which API calls are needed -->
              <xsl:choose>
                  <xsl:when test="umbraco.library:RequestForm('update-listing') = 'true'">
                      <xsl:variable name="listingResponse">
                          <xsl:choose>
                              <xsl:when test="$LstPostBackStatus = 'Cancel-Ad'">
                                    <xsl:value-of select="RESTscripts:UpdateListingStatus('Cancel-Ad')" />
                              </xsl:when>
                              
                              <xsl:when test="$LstPostBackStatus = 'Sold'">
                                    <xsl:value-of select="RESTscripts:UpdateListingStatus('Sold')" />
                              </xsl:when>
							  
							  <xsl:when test="$LstPostBackStatus = 'Withdrawn'">
                                    <xsl:value-of select="RESTscripts:UpdateListingStatus('Withdrawn')" />
                              </xsl:when>
                              
                              <!-- Save and Extend -->
                              <xsl:when test="$LstPostBackStatus = 'Extend-Ad'">
                                  <xsl:value-of select="RESTscripts:UpdateListing('Extend-Ad')" />
                              </xsl:when>
                              
                              <!-- Save and Publish -->
                              <xsl:when test="$LstPostBackStatus = 'Publish-Ad'">
                                  <xsl:value-of select="RESTscripts:UpdateListing('Publish-Ad')" />
                              </xsl:when>

                              <xsl:when test="$LstPostBackStatus = 'Relist-Ad'">
                                  <xsl:value-of select="RESTscripts:UpdateListingStatus('Relist-Ad')" />
                              </xsl:when>
                              
                              <xsl:otherwise>
                                  <xsl:value-of select="RESTscripts:UpdateListing('')" />
                              </xsl:otherwise>
                          </xsl:choose>
                      </xsl:variable>  
                      
                      <xsl:variable name="HasError">
                          <xsl:if test="string-length($listingResponse) = 0">
                              <xsl:text>False</xsl:text>
                          </xsl:if>
                          <xsl:if test="string-length($listingResponse) &gt; 0">
                              <xsl:text>True</xsl:text>
                          </xsl:if>
                      </xsl:variable>
                      <xsl:choose>
                          <!-- Check if error message is not empty -->
                          <xsl:when test="string-length($listingResponse) &gt; 0">
                              <div class="alert alert-error">
                                  <button data-dismiss="alert" class="close" type="button">×</button>
                                  <strong>Failed!</strong> Failed to update the listing. Error : <xsl:copy-of select="$listingResponse" />
                              </div>
                              <xsl:call-template name="listingEditor">
                                  <xsl:with-param name="HasError" select="$HasError" />
                              </xsl:call-template>
                          </xsl:when>
                          <!-- Success without error -->
                          <xsl:otherwise>
                              <div class="alert alert-success">
                                  <button data-dismiss="alert" class="close" type="button">×</button>
								  <xsl:choose>
										<!-- Commercial user message -->
										<xsl:when test="$IsRetailUser != 'true'">
											<strong>Success!</strong> The listing was updated successfully. Please note the changes will be displayed online in around 2 hours.
										</xsl:when>
										<!-- Private user message -->
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$LstPostBackStatus = 'Sold' or $LstPostBackStatus = 'Withdrawn'">
													<strong>Success!</strong> The listing was updated successfully.
												</xsl:when>
												<xsl:otherwise>
													<strong>Success!</strong> The listing was updated successfully. <b>It has now been submitted to the Review Team before it is sent live. </b>
												</xsl:otherwise>
											 </xsl:choose>
										</xsl:otherwise>
								  </xsl:choose>
                              </div>
                              <xsl:call-template name="listingEditor">
                                  <xsl:with-param name="HasError" select="$HasError" />
                              </xsl:call-template>
                          </xsl:otherwise>
                      </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                      
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:when>
          
          <xsl:otherwise>
              <!-- Redirect from Create New Listing Page -->
              <xsl:if test="umbraco.library:RequestQueryString('IsNew') = 'true'">
                  <div class="alert alert-success">
                      <button data-dismiss="alert" class="close" type="button">×</button>
                      <!-- <strong>Success!</strong> The listing was created successfully. Please continue to add photos to the listing and edit the listing information.. -->
                      <strong>Success!</strong> The listing was created successfully.
                  </div>
              </xsl:if>
              <!-- No form submitted, so just render the output -->
              <xsl:call-template name="listingEditor">
                  <xsl:with-param name="HasError">
                      <xsl:text>False</xsl:text>
                  </xsl:with-param>
              </xsl:call-template>
          </xsl:otherwise>
      </xsl:choose>
      
    </xsl:template>
    
    <xsl:template name="listingEditor">
        <xsl:param name="HasError"/>
        <!-- Get the listing edit data and render the form -->
        <xsl:variable name="UserID">
            <xsl:choose>
                <xsl:when test="umbraco.library:Session('easylist-username') != ''">
                    <xsl:value-of select="umbraco.library:Session('easylist-username')" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="UserCode">
            <xsl:choose>
                <xsl:when test="umbraco.library:Session('easylist-usercode') != ''">
                    <xsl:value-of select="umbraco.library:Session('easylist-usercode')" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="UserSign">
            <xsl:choose>
                <xsl:when test="umbraco.library:Session('easylist-userSignature') != ''">
                    <xsl:value-of select="umbraco.library:Session('easylist-userSignature')" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="UserSignDT">
            <xsl:choose>
                <xsl:when test="umbraco.library:Session('easylist-userSignatureDT') != ''">
                    <xsl:value-of select="umbraco.library:Session('easylist-userSignatureDT')" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="data" select="RESTscripts:GetListingEditData($listingCode, $UserID, $UserCode, $UserSign, $UserSignDT, $IsRetailUser)" />
        <xsl:variable name="dataType" select="name($data/*)" />
        <!-- <xsl:variable name="ListingType" select="$data/ListingsRestInfo/LstType" /> -->
        <input type="hidden" value="{$UserID}" name="UserID" />
		<input type="hidden" value="{$UserSign}" name="UserSign" />
		<input type="hidden" value="{$UserSignDT}" name="UserSignDT" />
		<input type="hidden" value="{$UserCode}" name="UserCode" />	
		
		<!-- Feed In Exception -->
		<!-- <textarea>
			<xsl:value-of select="count($data/ListingsRestInfo/ListingsDataFeedException/DataFeedException)"/>
		</textarea> -->
		
		<xsl:for-each select="$data/ListingsRestInfo/ListingsDataFeedException/DataFeedException">
			<xsl:choose>
				<xsl:when test="./ExType = 'Error'">
					<div class="alert alert-error">
						<strong>Error!</strong> <xsl:value-of select="./ExMessage" />
					</div>
				</xsl:when>
				<xsl:when test="./ExType = 'Warning'">
					<div class="alert alert-warning">
						<strong>Warning!</strong> <xsl:value-of select="./ExMessage" />
					</div>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<!-- Render based on data type -->
        <xsl:choose>
            <xsl:when test="$dataType ='error'">
                An error ocurred.!
               <!--  <textarea>
					<xsl:value-of select="$data/*" />
				</textarea> -->
                <!-- Added for debugging by Nathan -->
                <input type="hidden" value="{$UserID}" name="UserID" />
                <input type="hidden" value="{$UserSign}" name="UserSign" />
                <input type="hidden" value="{$UserSignDT}" name="UserSignDT" />
                <input type="hidden" value="{$UserCode}" name="UserCode" />
                
            </xsl:when>
            <xsl:when test="$data/ListingsRestInfo/LstType = 'Motorcycle'">
                <xsl:call-template name="motorcycle">
                    <xsl:with-param name="data" select="$data/*" />
                    <xsl:with-param name="HasError" select="$HasError" />
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$data/ListingsRestInfo/LstType = 'Car'">
                <xsl:call-template name="automotive">
                    <xsl:with-param name="data" select="$data/*" />
                    <xsl:with-param name="HasError" select="$HasError" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="gm">
                    <xsl:with-param name="data" select="$data/*" />
                    <xsl:with-param name="HasError" select="$HasError" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- GM Edit Template -->
    <xsl:template name="gm">
        <xsl:param name="data" />
        <xsl:param name="HasError"/>
        
        <!-- <xsl:variable name="showFieldLocks" select="$data/SrcName !=''" /> -->
		<xsl:variable name="showFieldLocks" select="$IsRetailUser != 'true'" />
		
        <xsl:variable name="imgCount" select="count($data/ListingsImageInfo/ImageEditInfo)"/>
        <xsl:variable name="vidCount" select="count($data/ListingsVideoInfo/VideoEditInfo)"/>
        <xsl:variable name="CustomHTML" select="RESTscripts:CustomListingHTML($data/CatID, $listingCode)" />
        <!--<textarea>
			<xsl:value-of select="$CustomHTML" />
		</textarea>-->
        <!-- <form method="post" class="form-horizontal" runat="server"> -->
        <form method="post" class="form-horizontal">
            
            <input type="hidden" id="max-photos" value="24" />
            <input type="hidden" id="max-videos" value="6" />
            <!--<input type="hidden" id="photosCount" value="{$imgCount}" />
      <input type="hidden" id="videosCount" value="{$vidCount}" />-->
	  
            <div class="widget-box">
                <div class="widget-title">
                    <ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
                        <li class="active">
                            <a href="#details" data-toggle="tab">
                                <i class="icon-pencil">&nbsp;</i> Ad Details
                            </a>
                        </li>
                        <xsl:if test ="$CustomHTML != ''">
                            <li class="">
                                <a href="#spec" data-toggle="tab">
                                    <i class="icon-pencil">&nbsp;</i> Specs
                                </a>
                            </li>
                        </xsl:if>
                        <li class="">
                            <a href="#photos" data-toggle="tab">
                                <i class="icon-camera-3">&nbsp;</i> Photos <span id="photosCount">
                                <xsl:choose>
                                    <xsl:when test="$imgCount &lt; 1">
                                        <xsl:attribute name="class">badge badge-important</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$imgCount &lt; 6">
                                        <xsl:attribute name="class">badge badge-warning</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="class">badge badge-success</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="$imgCount" />
                                </span>
                            </a>
                        </li>
                        <li class="">
                            <a href="#videos" data-toggle="tab">
                                <i class="icon-facetime-video">&nbsp;</i> Videos <span>
                                <xsl:choose>
                                    <xsl:when test="$vidCount &lt; 1">
                                        <xsl:attribute name="class">badge badge-important</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="class">badge badge-success</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="$vidCount" />
                                </span>
                            </a>
                        </li>
						
						<li class="">
                            <a href="#contactSetting" data-toggle="tab">
                                <i class="icon-phone">&nbsp;</i> Contacts
                            </a>
                        </li>
						
						<xsl:if test="$IsRetailUser != 'true'">
							<li>
								<a href="#distribution" data-toggle="tab">
									<i class="icon-share">&nbsp;</i> Ad Distribution
								</a>
							</li>
						</xsl:if>
                    </ul>
                </div>
                
                <div class="tab-content widget-content">
                    
                    <div id="details" class="tab-pane active">
                        <!-- Render the standard listing fields -->
                        <xsl:call-template name="standardfields">
                            <xsl:with-param name="data" select="$data" />
                            <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                        </xsl:call-template>
                    </div>
                    <xsl:if test ="$CustomHTML != ''">
                        <div id="spec" class="tab-pane">
                            
                            <xsl:value-of select="$CustomHTML" disable-output-escaping="yes" />
                            &nbsp;
                        </div>
                    </xsl:if>
                    <div id="photos" class="tab-pane">
                        <!-- Listing Images -->
                        <a id="ReloadImage" href="#" style="visibility: hidden">Reload Image</a>
                        
						<xsl:call-template name="listingImages">
							<xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
						</xsl:call-template>
					
                    </div>
                    <div id="videos" class="tab-pane">
                        <!-- Listing Videos-->
                        <xsl:call-template name="listingVideos">
                            <xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                        </xsl:call-template>
                    </div>
					
					<div id="contactSetting" class="tab-pane">
						 <xsl:call-template name="contactSetting">
							<xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
						 </xsl:call-template>
					</div>
					
					<xsl:if test="$IsRetailUser != 'true'">
						<div id="distribution" class="tab-pane">
							<xsl:call-template name="adsdistribution">
								<xsl:with-param name="data" select="$data" />
							</xsl:call-template>

							<p>
								<i class="icon-info">&nbsp;</i> Did you know we can distribute your ads to over 15 destinations and counting, for as little as $10 per week? Contact your sales rep today to ask about the options available to you.
							</p>
						</div>
                    </xsl:if>
					
                    <input type="hidden" name="listing-code" id="listing-code"  value="{$data/Code}" />
                    <!--<input type="hidden" name="listing-type" value="auto" />-->
                    
                    <input type="hidden" id="update-listing" name="update-listing" value="true" />
                    
                </div>
                <xsl:call-template name="FormAction">
                    <xsl:with-param name="data" select="$data" />
                </xsl:call-template>
                
            </div>
            
        </form>
    </xsl:template>
    
    <!-- Motorcycle Edit Template -->
    <xsl:template name="motorcycle">
        <xsl:param name="data" />
        <xsl:param name="HasError"/>
        
        <!-- <xsl:variable name="showFieldLocks" select="$data/SrcName !=''" /> -->
		<xsl:variable name="showFieldLocks" select="$IsRetailUser != 'true'" />
		
        <xsl:variable name="imgCount" select="count($data/ListingsImageInfo/ImageEditInfo)"/>
        <xsl:variable name="vidCount" select="count($data/ListingsVideoInfo/VideoEditInfo)"/>
        
        <form method="post" class="form-horizontal ">
            
            <input type="hidden" id="max-photos" value="24" />
            <input type="hidden" id="max-videos" value="6" />
            
            <div class="widget-box">
                
                <div class="widget-title">
                    
                    <ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
                        <li class="active">
                            <a href="#details" data-toggle="tab">
                                <i class="icon-pencil">&nbsp;</i> Ad Details
                            </a>
                        </li>
                        <li class="">
                            <a href="#specs" data-toggle="tab">
                                <i class="icon-file-3">&nbsp;</i> Specs
                            </a>
                        </li>
                        <li class="">
                            <a href="#features" data-toggle="tab">
                                <i class="icon-file-3">&nbsp;</i> Features
                            </a>
                        </li>
                        <li class="">
                            <a href="#photos" data-toggle="tab">
                                <i class="icon-camera-3">&nbsp;</i> Photos 
                                <span id="photosCount">
                                    <xsl:choose>
                                        <xsl:when test="$imgCount &lt; 1">
                                            <xsl:attribute name="class">badge badge-important</xsl:attribute>
                                        </xsl:when>
                                        <xsl:when test="$imgCount &lt; 6">
                                            <xsl:attribute name="class">badge badge-warning</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="class">badge badge-success</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="$imgCount" />
                                </span>
                            </a>
                        </li>
                        <li class="">
                            <a href="#videos" data-toggle="tab">
                                <i class="icon-facetime-video">&nbsp;</i> Videos <span>
                                <xsl:choose>
                                    <xsl:when test="$vidCount &lt; 1">
                                        <xsl:attribute name="class">badge badge-important</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="class">badge badge-success</xsl:attribute>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:value-of select="$vidCount" />
                                </span>
                            </a>
                        </li>
						
						<li class="">
                            <a href="#contactSetting" data-toggle="tab">
                                <i class="icon-phone">&nbsp;</i> Contacts
                            </a>
                        </li>
						
						<xsl:if test="$IsRetailUser != 'true'">
							<li>
								<a href="#distribution" data-toggle="tab">
									<i class="icon-share">&nbsp;</i> Ad Distribution
								</a>
							</li>
						</xsl:if>
                    </ul>
                </div>
                
                <div class="tab-content widget-content">
                    
                    <div id="details" class="tab-pane active">
                        <!-- Render the standard listing fields -->
                        <xsl:call-template name="standardfields">
                            <xsl:with-param name="data" select="$data" />
                            <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                        </xsl:call-template>
                    </div>
                    
                    <div id="specs" class="tab-pane">
						<xsl:if test="count($data/ListingsDataFeedException/DataFeedException) > 0 and $data/VehicleListing/NVIC = ''">
							<a class="btn btn-danger push-bottom" id="FixListingMotorSpec" href="#">
								<i class="icon-support">&nbsp;</i> Fix Listing Specs
							</a>
						</xsl:if>
						
                        <div class="control-group ">
                            <label class="control-label">Make</label>
                            <div class="controls">
                                <input class="text" type="text" readonly="readonly" maxlength="100" name="listing-make" id="listing-motor-make" value="{$data/VehicleListing/Make}" />
                            </div>
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">Model</label>
                            <div class="controls">
                                <input class="text" type="text" readonly="readonly" maxlength="100" name="listing-model" id="listing-motor-model" value="{$data/VehicleListing/Model}" />
                            </div>
                        </div>
						
						<div class="control-group">
							<label class="control-label">Variant</label>
							<div class="controls">
								<input class="text" type="text" readonly="readonly" maxlength="500" name="listing-variant" id="listing-motor-variant" value="{$data/VehicleListing/Variant}" />
							</div>
						</div>
						
						<div class="control-group">
							<label class="control-label">Series</label>
							<div class="controls">
								<input class="text" type="text" readonly="readonly" maxlength="100" name="listing-series" id="listing-motor-series" value="{$data/VehicleListing/Series}" />
							</div>
						</div>
                        
                        <div class="control-group">
                            <label class="control-label">Year</label>
                            <div class="controls">
                                <input class="text year" type="text" readonly="readonly" maxlength="4" name="listing-year" id="listing-motor-year" value="{$data/VehicleListing/Year}" />
                            </div>
                        </div>
						
						<!-- <div class="control-group">
							<label class="control-label">Variant</label>
							<div class="controls">
								<input class="text" type="text" readonly="readonly" name="listing-variant" id="listing-motor-variant" value="{$data/VehicleListing/Variant}" />
							</div>
						</div> -->
						
						
						<div class="control-group">
							<label class="control-label">Style</label>
							<div class="controls">
								<input class="text" type="text" maxlength="100" name="listing-body-style-description" id="listing-motor-body-style-description">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="$LstBodyDesc" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$data/VehicleListing/BodyDesc" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
								
								<xsl:if test="$showFieldLocks = '1'">
									<input type="checkbox" name="lock-body-style-description" value="true" class="lock-field">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:if test="$LxBodyDesc ='true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:if test="$data/VehicleListing/LxBodyDesc ='true'">
													<xsl:attribute name="checked">checked</xsl:attribute>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</xsl:if>
							</div>
						</div>
						
                        <div class="control-group">
                            <label class="control-label">Transmission</label>
                            <div class="controls">
                                <input class="text" type="text" maxlength="50" name="listing-transmission-description" id="listing-motor-transmission-description">
                                    <xsl:attribute name="data-validate">{required: false, maxlength: 50}</xsl:attribute>
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:value-of select="$LstTransDesc" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$data/VehicleListing/TrmDesc" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </input>
                                
                                <xsl:if test="$showFieldLocks = '1'">
                                    <input type="checkbox" name="lock-transmission-description" value="true" class="lock-field">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:if test="$LxTransDesc ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="$data/VehicleListing/LxTrmDesc ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </input>
                                </xsl:if>
                            </div>
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">Colour</label>
                            <div class="controls">
                                <input class="text" type="text" maxlength="50" name="listing-exterior-colour" >
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:value-of select="$LstExtColor" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$data/VehicleListing/ExteriorColour" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </input>
                                
                                <xsl:if test="$showFieldLocks = '1'">
                                    <input type="checkbox" name="lock-exterior-colour" value="true" class="lock-field">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:if test="$LxExtColor ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="$data/VehicleListing/LxExteriorColour ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </input>
                                </xsl:if>
                            </div>
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">No. of gears</label>
                            <div class="controls">
                                <!-- <input class="text" type="text" maxlength="50" name="listing-gears" value="{$data/VehicleListing/TrmGearCnt}" /> -->
                                <input class="text" type="text" maxlength="50" name="listing-gears">
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:value-of select="$LstGears" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$data/VehicleListing/TrmGearCnt" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </input>
                                <xsl:if test="$showFieldLocks = '1'">
                                    <input type="checkbox" name="lock-gears" value="true" class="lock-field">
                                        <!-- <xsl:if test="$data/VehicleListing/LxTrmGearsDesc ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:if test="$LxGears ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="$data/VehicleListing/LxTrmGearsDesc ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </input>
                                </xsl:if>
                            </div>
                        </div>
						
						<div class="control-group">
                            <label class="control-label">Engine</label>
                            <div class="controls">
                                <input class="text" type="text" maxlength="50" name="listing-engine-description" id="listing-motor-engine-description">
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:value-of select="$LstEngDesc" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$data/VehicleListing/EngDesc" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </input>
                                <xsl:if test="$showFieldLocks = '1'">
                                    <input type="checkbox" name="lock-engine-description" value="true" class="lock-field">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:if test="$LxEngDesc ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="$data/VehicleListing/LxEngDesc ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </input>
                                </xsl:if>
                            </div>
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">Engine CC's</label>
                            <div class="controls">
                                <input class="text" type="text" maxlength="50" name="listing-engine-size-description" id="listing-motor-engine-size-description">
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:value-of select="$LstEngSize" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$data/VehicleListing/EngSizeDesc" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </input>
                                <xsl:if test="$showFieldLocks = '1'">
                                    <input type="checkbox" name="lock-engine-size-description" value="true" class="lock-field">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:if test="$LxEngSize ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="$data/VehicleListing/LxEngSizeDesc ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </input>
                                </xsl:if>
                            </div>
                        </div>
                        
                        <div class="control-group">
                            <label class="control-label">No. of cylinders</label>
                            <div class="controls">
                                <input class="text" type="text" maxlength="50" name="listing-engine-cylinders" id="listing-motor-engine-cylinders">
                                    <xsl:attribute name="value">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:value-of select="$LstEngCylinder" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$data/VehicleListing/EngCylinders" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </input>
                                <xsl:if test="$showFieldLocks = '1'">
                                    <input type="checkbox" name="lock-engine-cylinders" value="true" class="lock-field">
                                        <xsl:choose>
                                            <xsl:when test="$IsPostBack = 'true'">
                                                <xsl:if test="$LxEngCylinder ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="$data/VehicleListing/LxEngCylinders ='true'">
                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </input>
                                </xsl:if>
                            </div>
                        </div>
                        <xsl:call-template name="ListingAdditionalInfo">
                            <xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                        </xsl:call-template>
                    </div>
                    
                    <div id="features" class="tab-pane">
                        <!-- Vehicle Features -->
                        <xsl:call-template name="MotorfeatureEditors">
                            <xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                        </xsl:call-template>
                    </div>
                    
                    <div id="photos" class="tab-pane">
                        
                        <!-- Listing Images -->
                        <a id="ReloadImage" href="#" style="visibility: hidden">Reload Image</a>
                        
						<xsl:call-template name="listingImages">
							<xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
						</xsl:call-template>
					
                    </div>
                    
                    <div id="videos" class="tab-pane">
                        <!-- Listing Videos-->
                        <xsl:call-template name="listingVideos">
                            <xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                        </xsl:call-template>
                    </div>
					
					<div id="contactSetting" class="tab-pane">
						 <xsl:call-template name="contactSetting">
							<xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
						 </xsl:call-template>
					</div>
					
					<xsl:if test="$IsRetailUser != 'true'">
						<div id="distribution" class="tab-pane">
							<xsl:call-template name="adsdistribution">
								<xsl:with-param name="data" select="$data" />
							</xsl:call-template>
						</div>
					</xsl:if>
					
					<!-- <input type="hidden" name="listing-variant" id="listing-motor-variant"  value="{$data/VehicleListing/Variant}" /> -->
                    
					<input type="hidden" name="listing-nvic" id="listing-nvic"  value="{$data/VehicleListing/NVIC}" />
                    <input type="hidden" name="listing-code" id="listing-code"  value="{$data/Code}" />
                    <!--<input type="hidden" name="listing-type" value="auto" />-->
                    <input type="hidden" id="update-listing" name="update-listing" value="true" />
                    
                </div>
                <xsl:call-template name="FormAction">
                    <xsl:with-param name="data" select="$data" />
                </xsl:call-template>
                
            </div>
        </form>
    </xsl:template>
    
    <!-- Auto Edit Template -->
    <xsl:template name="automotive">
        <xsl:param name="data" />
        <xsl:param name="HasError"/>
        
        <!-- <xsl:variable name="showFieldLocks" select="$data/SrcName !=''" /> -->
		<xsl:variable name="showFieldLocks" select="$IsRetailUser != 'true'" />
		
        <xsl:variable name="imgCount" select="count($data/ListingsImageInfo/ImageEditInfo)"/>
        <!-- <xsl:variable name="vidCount" select="count($data/Videos/ListingVideoEditInfo)"/> -->
        <xsl:variable name="vidCount" select="count($data/ListingsVideoInfo/VideoEditInfo)"/>
        
        <form method="post" class="form-horizontal break-desktop-large">
            
            <input type="hidden" id="max-photos" value="24" />
            <input type="hidden" id="max-videos" value="6" />
            
            <div class="widget-box">
                
                <div class="widget-title">
                    
                    <ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
                        <li class="active">
                            <a href="#details" data-toggle="tab">
                                <i class="icon-pencil">&nbsp;</i> Ad Details
                            </a>
                        </li>
                        <li class="">
                            <a href="#specs" data-toggle="tab">
                                <i class="icon-file-3">&nbsp;</i> Specs
                            </a>
                        </li>
                        <li class="">
                            <a href="#features" data-toggle="tab">
                                <i class="icon-list-2">&nbsp;</i> Features
                            </a>
                        </li>
                        <li class="">
                            <a href="#photos" data-toggle="tab">
                                <i class="icon-camera-3">&nbsp;</i> Photos
                                <span id="photosCount">
                                    <xsl:choose>
                                        <xsl:when test="$imgCount &lt; 1">
                                            <xsl:attribute name="class">badge badge-important</xsl:attribute>
                                        </xsl:when>
                                        <xsl:when test="$imgCount &lt; 6">
                                            <xsl:attribute name="class">badge badge-warning</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="class">badge badge-success</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="$imgCount" />
                                </span>
                            </a>
                        </li>
                        <li class="">
                            <a href="#videos" data-toggle="tab">
                                <i class="icon-facetime-video">&nbsp;</i> Videos
                                <span>
                                    <xsl:choose>
                                        <xsl:when test="$vidCount &lt; 1">
                                            <xsl:attribute name="class">badge badge-important</xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="class">badge badge-success</xsl:attribute>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="$vidCount" />
                                </span>
                            </a>
                        </li>
						
						<li class="">
                            <a href="#contactSetting" data-toggle="tab">
                                <i class="icon-phone">&nbsp;</i> Contacts
                            </a>
                        </li>
						
						<xsl:if test="$IsRetailUser != 'true'">
							<li>
								<a href="#distribution" data-toggle="tab">
									<i class="icon-share">&nbsp;</i> Ad Distribution
								</a>
							</li>
						</xsl:if>
                    </ul>
                </div>
                
                <div class="tab-content widget-content">
                    
                    <div id="details" class="tab-pane active">
                        <!-- Render the standard listing fields -->
                        <xsl:call-template name="standardfields">
                            <xsl:with-param name="data" select="$data" />
                            <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                            <xsl:with-param name="HasError" select="$HasError" />
                        </xsl:call-template>
                    </div>
                    
                    <div id="specs" class="tab-pane">
                        <div class="form-left">
							<xsl:if test="count($data/ListingsDataFeedException/DataFeedException) > 0 and $data/VehicleListing/NVIC = ''">
								<a class="btn btn-danger push-bottom" id="FixListingCarSpec" href="#">
									<i class="icon-support">&nbsp;</i> Fix Listing Specs
								</a>
							</xsl:if>
							
                            <div class="control-group ">
                                <label class="control-label">Make</label>
                                <div class="controls">
                                    <input class="text" type="text" readonly="readonly" maxlength="100" name="listing-make" id="listing-auto-make" value="{$data/VehicleListing/Make}"  />
                                </div>
                            </div>
                            
                            <div class="control-group">
                                <label class="control-label">Model</label>
                                <div class="controls">
                                    <input class="text" type="text" readonly="readonly" maxlength="100" name="listing-model" id="listing-auto-model" value="{$data/VehicleListing/Model}" />
                                </div>
                            </div>
                            
							 <!-- <xsl:if test="$data/VehicleListing/Variant !=''"> -->
                                <div class="control-group">
                                    <label class="control-label">Variant</label>
                                    <div class="controls">
                                        <input class="text" type="text" readonly="readonly" maxlength="100" name="listing-variant" id="listing-auto-variant" value="{$data/VehicleListing/Variant}" />
                                    </div>
                                </div>
                            <!-- </xsl:if> -->
                            
                            
                            <!-- <xsl:if test="$data/VehicleListing/Series !=''"> -->
                                <div class="control-group">
                                    <label class="control-label">Series</label>
                                    <div class="controls">
                                        <input class="text" type="text" readonly="readonly" maxlength="100" name="listing-series" id="listing-auto-series" value="{$data/VehicleListing/Series}" />
                                    </div>
                                </div>
                            <!-- </xsl:if> -->
                                                        
                            <div class="control-group">
                                <label class="control-label">Year</label>
                                <div class="controls">
                                    <input class="text year" type="text" readonly="readonly" maxlength="4" name="listing-year" id="listing-auto-year" value="{$data/VehicleListing/Year}" />
                                </div>
                            </div>
							
							<div class="control-group">
                                <label class="control-label">Body Type</label>
                                <div class="controls">
                                    <select class="drop-down" name="listing-body-style" id="listing-auto-body-style">
                                        <xsl:call-template name="optionlist">
                                            <xsl:with-param name="options">,4x4,Convertible,Coupe,Hatchback,People Mover,Roadster,SUV,Sedan,Sports,Truck/Bus,Ute,Van,Wagon</xsl:with-param>
                                            <xsl:with-param name="value">
                                                <!-- <xsl:value-of select="$data/VehicleListing/BodyStyle" /> -->
                                                <xsl:choose>
                                                    <xsl:when test="$IsPostBack = 'true'">
                                                        <xsl:value-of select="$LstBodyStyle" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$data/VehicleListing/BodyStyle" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </select>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-body-style" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxBodyStyle ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxBodyStyle ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxBodyStyle ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>

                            <div class="control-group">
                                <label class="control-label">Body Description</label>
                                <div class="controls">
                                    <!-- <input class="text" type="text" maxlength="100" name="listing-body-style-description" value="{$data/VehicleListing/BodyDesc}" /> -->
                                    <input class="text" type="text" maxlength="100" name="listing-body-style-description" id="listing-auto-body-style-description">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstBodyDesc" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/BodyDesc" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-body-style-description" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxBodyDesc ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxBodyDesc ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxBodyDesc ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
							
							 <div class="control-group">
                                <label class="control-label">Transmission Type</label>
                                <div class="controls">
                                    <select class="drop-down" name="listing-transmission-type" id="listing-auto-transmission-type">
                                        <xsl:call-template name="optionlist">
                                            <xsl:with-param name="options">,Automatic,Manual</xsl:with-param>
                                            <xsl:with-param name="value">
                                                <!-- <xsl:value-of select="$data/VehicleListing/TrmType" /> -->
                                                <xsl:choose>
                                                    <xsl:when test="$IsPostBack = 'true'">
                                                        <xsl:value-of select="$LstTransType" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$data/VehicleListing/TrmType" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </select>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-transmission-type" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxTrmType ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxTransType ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxTrmType ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                            
                            <div class="control-group">
                                <label class="control-label">Transmission Info</label>
                                <div class="controls">
                                    <!-- <input class="text" type="text" maxlength="20" name="listing-transmission-description" value="{$data/VehicleListing/TrmDesc}" /> -->
                                    <input class="text" type="text" maxlength="50" name="listing-transmission-description" id="listing-auto-transmission-description">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstTransDesc" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/TrmDesc" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-transmission-description" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxTrmDesc ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxTransDesc ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxTrmDesc ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
							
                            <div class="control-group">
                                <label class="control-label">No. of doors</label>
                                <div class="controls">
                                    <!-- <input class="text integer" type="text" maxlength="4" name="listing-doors" value="{$data/VehicleListing/Doors}" /> -->
                                    <input class="text integer" type="text" maxlength="4" name="listing-doors">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstDoors" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/Doors" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-doors" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxDoors ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxDoors ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxDoors ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                            
                            <div class="control-group">
                                <label class="control-label">Number of seats</label>
                                <div class="controls">
                                    <!-- <input type="text" maxlength="4" name="listing-seats" class="text integer" value="{$data/VehicleListing/Seats}" /> -->
                                    <input type="text" maxlength="4" name="listing-seats" class="text integer">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstSeats" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/Seats" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-seats" value="true" class="lock-field">
                                            <!--  <xsl:if test="$data/VehicleListing/LxSeats ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxSeats ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxSeats ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>

                            
                            <div class="control-group">
                                <label class="control-label">Exterior Colour</label>
                                <div class="controls">
                                    <!-- <input class="text" type="text" maxlength="100" name="listing-exterior-colour" value="{$data/VehicleListing/ExteriorColour}" /> -->
                                    <input class="text" type="text" maxlength="100" name="listing-exterior-colour" >
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstExtColor" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/ExteriorColour" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-exterior-colour" value="true" class="lock-field">
                                            <!--  <xsl:if test="$data/VehicleListing/LxExteriorColour ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxExtColor ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxExteriorColour ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                            
                            <div class="control-group">
                                <label class="control-label">Interior Colour</label>
                                <div class="controls">
                                    <!-- <input class="text" type="text" maxlength="100" name="listing-interior-colour" value="{$data/VehicleListing/InteriorColour}" /> -->
                                    <input class="text" type="text" maxlength="100" name="listing-interior-colour">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstIntColor" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/InteriorColour" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-interior-colour" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxInteriorColour ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxIntColor ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxInteriorColour ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                        </div>
                        <div class="form-right">
                            
                            <xsl:call-template name="ListingAdditionalInfo">
                                <xsl:with-param name="data" select="$data" />
                            </xsl:call-template>
                        
                            <!-- <div class="control-group">
                                <label class="control-label">Registration</label>
                                <div class="controls">
                                    <input type="text" maxlength="30" name="listing-registration-number" class="text inline">
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
                                    
                                    
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-registration" value="true" class="lock-field">
                                            
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxRegNo ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxRegNo ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div> -->
                            
                            <!-- <div class="control-group">
                                <label class="control-label">VIN Number</label>
                                <div class="controls">
                                    <input type="text" maxlength="30" name="listing-vinnumber" class="text inline">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstVinNumber" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/VinNumber" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-vinnumber" value="true" class="lock-field">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxVinNumber ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxVinNumber ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div> -->
                            
                            <div class="control-group">
                                <label class="control-label">Odometer</label>
                                <div class="controls">
                                    <!-- <input type="text" maxlength="9" name="listing-odometer-value" class="text integer inline" value="{$data/VehicleListing/Odometer}" /> -->
                                    <input type="text" maxlength="9" name="listing-odometer-value" class="text integer inline input-medium">
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
                                    </input>
                                    <select class="drop-down inline input-small" name="listing-odometer-unit">
                                        <xsl:call-template name="optionlist">
                                            <xsl:with-param name="options">,KM,MI</xsl:with-param>
                                            <xsl:with-param name="value">
                                                <!-- <xsl:value-of select="$data/VehicleListing/OdometerUOM" /> -->
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
                                    </select>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-odometer" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxOdometer ='true'">
                                              <xsl:attribute name="checked">checked</xsl:attribute>
                                            </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxOdometer ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxOdometer ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                            
                            <div class="control-group">
                                <label class="control-label">Drive Type</label>
                                <div class="controls">
                                    <select class="drop-down" name="listing-drive-type">
                                        <xsl:call-template name="optionlist">
                                            <xsl:with-param name="options">,4x2,4x4,4WD,AWD,FWD,RWD</xsl:with-param>
                                            <xsl:with-param name="value">
                                                <!-- <xsl:value-of select="$data/VehicleListing/DriveTypeDesc" /> -->
                                                <xsl:choose>
                                                    <xsl:when test="$IsPostBack = 'true'">
                                                        <xsl:value-of select="$LstDriveType" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$data/VehicleListing/DriveTypeDesc" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </select>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-drive-type" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxDriveTypeDesc ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxDriveType ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxDriveTypeDesc ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                                                    
                            <div class="control-group">
                                <label class="control-label">Engine Cylinders</label>
                                <div class="controls">
                                    <!-- <input class="text" type="text" maxlength="20" name="listing-engine-cylinders" value="{$data/VehicleListing/EngCylinders}" /> -->
                                    <input class="text" type="text" maxlength="20" name="listing-engine-cylinders">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstEngCylinder" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/EngCylinders" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-engine-cylinders" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxEngCylinders ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxEngCylinder ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxEngCylinders ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                                                    
                            <div class="control-group">
                                <label class="control-label">Engine Size</label>
                                <div class="controls">
                                    <!-- <input class="text" type="text" maxlength="20" name="listing-engine-size-description" value="{$data/VehicleListing/EngDesc}" /> -->
                                    <input class="text" type="text" maxlength="20" name="listing-engine-size-description">
                                        <xsl:attribute name="value">
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:value-of select="$LstEngSize" />
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$data/VehicleListing/EngSizeDesc" />
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </input>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-engine-size-description" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxEngDesc ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxEngSize ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxEngSizeDesc ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>

                            <div class="control-group">
                                <label class="control-label">Engine Type</label>
                                <div class="controls">
                                    <select class="drop-down" name="listing-engine-type-description">
                                        <xsl:call-template name="optionlist">
                                            <xsl:with-param name="options">,CARB,DIESEL,DIESEL FUEL INJECTED,DIESEL MPFI,DIESEL TURBO,DIESEL TURBO F/INJ,ELECTRONIC F/INJ,FUEL INJECTED,LPG,MILLER CYCLE,MULTI POINT F/INJ,S/C &amp; T/C MPFI,SINGLE POINT F/INJ,SUPERCHARGED MPFI,TURBO CDI,TURBO EFI,TURBO MPFI,TWIN CARB,TWIN TURBO MPFI</xsl:with-param>
                                            <xsl:with-param name="value">
                                                <!-- <xsl:value-of select="$data/VehicleListing/EngType" /> -->
                                                <xsl:choose>
                                                    <xsl:when test="$IsPostBack = 'true'">
                                                        <xsl:value-of select="$LstEngType" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$data/VehicleListing/EngType" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </select>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-engine-type-description" value="true" class="lock-field">
                                            <!-- <xsl:if test="$data/VehicleListing/LxEngType ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxEngType ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxEngType ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                                                    
                            <div class="control-group">
                                <label class="control-label">Fuel Type</label>
                                <div class="controls">
                                    <select class="drop-down" name="listing-fuel-type-description">
                                        <xsl:call-template name="optionlist">
                                            <xsl:with-param name="options">,DIESEL,LEADED PETROL,LIQUID PETROLEUM GAS,PETROL,Petrol &amp; Gas,Petrol &amp; LPG,Petrol or LPG (Dual),PREMIUM UNLEADED PETROL,UNLEADED PETROL</xsl:with-param>
                                            <xsl:with-param name="value">
                                                <!-- <xsl:value-of select="$data/VehicleListing/FuelTypeDesc" /> -->
                                                <xsl:choose>
                                                    <xsl:when test="$IsPostBack = 'true'">
                                                        <xsl:value-of select="$LstFuelType" />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$data/VehicleListing/FuelTypeDesc" />
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </select>
                                    <xsl:if test="$showFieldLocks = '1'">
                                        <input type="checkbox" name="lock-fuel-type-description" value="true" class="lock-field">
                                            <!--  <xsl:if test="$data/VehicleListing/LxFuelTypeDesc ='true'">
                      <xsl:attribute name="checked">checked</xsl:attribute>
                    </xsl:if> -->
                                            <xsl:choose>
                                                <xsl:when test="$IsPostBack = 'true'">
                                                    <xsl:if test="$LxFuelType ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:if test="$data/VehicleListing/LxFuelTypeDesc ='true'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </input>
                                    </xsl:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div id="features" class="tab-pane">
                        <!-- Vehicle Features -->
                        <xsl:call-template name="featureEditors">
                            <xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                        </xsl:call-template>
                    </div>
                    
                    <div id="photos" class="tab-pane">
                        
                        <!-- Listing Images -->
                        <a id="ReloadImage" href="#" style="visibility: hidden">Reload Image</a>
                        
						<xsl:call-template name="listingImages">
							<xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
						</xsl:call-template>
				   
                    </div>
                    
                    <div id="videos" class="tab-pane">
                        <!-- Listing Videos-->
                        <xsl:call-template name="listingVideos">
                            <xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
                        </xsl:call-template>
                    </div>
					
					<div id="contactSetting" class="tab-pane">
						 <xsl:call-template name="contactSetting">
							<xsl:with-param name="data" select="$data" />
							<xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
						 </xsl:call-template>
					</div>
					
					<xsl:if test="$IsRetailUser != 'true'">
						<div id="distribution" class="tab-pane">
							<xsl:call-template name="adsdistribution">
								<xsl:with-param name="data" select="$data" />
							</xsl:call-template>
						</div>
                    </xsl:if>
					
                    <input type="hidden" name="listing-code" id="listing-code"  value="{$data/Code}" />
                    <!--<input type="hidden" name="listing-type" value="auto" />-->
                    <input type="hidden" id="update-listing" name="update-listing" value="true" />
					<input type="hidden" name="listing-nvic" id="listing-nvic"  value="{$data/VehicleListing/NVIC}" />
                </div>
                
                <xsl:call-template name="FormAction">
                    <xsl:with-param name="data" select="$data" />
                </xsl:call-template>
            </div>
        </form>
    </xsl:template>
    
    <xsl:template name="FormAction">
        <xsl:param name="data" />
        <!-- <textarea>
            <xsl:value-of select="$data/ListingStatusDesc" />
        </textarea> -->
        <input type="hidden" id="update-listing-state" name="update-listing-state" value="" />
		<input type="hidden" id="listing-FeedOutDestList" name="listing-FeedOutDestList" value="{$data/FeedOutDestList}" /> 
		<input id="IsRetailUser" type="hidden" name="IsRetailUser" value="{$IsRetailUser}" />
		
		<input type="hidden" id="listing-has-exception" name="listing-has-exception">
			<xsl:attribute name="value">
				<xsl:choose>
					<!--<xsl:when test="count($data/ListingsDataFeedException/DataFeedException) > 0">true</xsl:when>-->
					<xsl:when test="$data/FeedInExceptionType > 1">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</input>
        
        <xsl:if test="$IsManagerEditorGroup != false">
            <div class="tab-submit">
                <xsl:if test="$data/ListingStatusDesc = 'Draft' or $data/ListingStatusDesc = 'Active'">
                    <button onclick = "$('.form-horizontal').removeClass('has-changes')" class="btn btn-large save update-listing btn-success" type="submit" id="submit-changes" value="Save Changes">
                        <i class="icon-checkmark">&nbsp;</i> Save Changes
                    </button>&nbsp;&nbsp;
                </xsl:if>
				<xsl:if test="$IsRetailUser != 'true'">
					<xsl:if test="$data/ListingStatusDesc = 'Draft'">
						<button onclick = "$('.form-horizontal').removeClass('has-changes')" class="btn btn-large save update-listing btn-danger" type="submit" id="Cancel-Ad" value="Cancel-Ad">
							<i class="icon-close">&nbsp;</i> Cancel Ad
						</button>&nbsp;&nbsp;
					</xsl:if>
					<xsl:if test="$data/ListingStatusDesc = 'Draft'">
						<div class="visible-phone" style="margin-top:10px;"><xsl:text>
						</xsl:text></div>
						<button onclick = "$('.form-horizontal').removeClass('has-changes')" class="btn btn-large save update-listing btn-info" type="submit" id="Publish-Ad" value="Publish-Ad">
							<i class="icon-checkmark">&nbsp;</i> Publish Ad
						</button>&nbsp;&nbsp;
					</xsl:if>
                    <xsl:if test="$data/ListingStatusDesc != 'Active' and $data/ListingStatusDesc != 'Draft'">
                        <div class="visible-phone" style="margin-top:10px;"><xsl:text>
						</xsl:text></div>
                        <button onclick = "$('.form-horizontal').removeClass('has-changes')" class="btn btn-large save update-listing btn-info" type="submit" id="Relist-Ad" value="Relist-Ad">
                            <i class="icon-checkmark">&nbsp;</i> Relist Ad
                        </button>&nbsp;&nbsp;
                    </xsl:if>
				</xsl:if>
                <xsl:if test="$data/ListingStatusDesc = 'Active'">
                    <button onclick = "$('.form-horizontal').removeClass('has-changes')" class="btn btn-large save update-listing btn-danger" type="submit" id="Sold" value="Sold">
                        <i class="icon-checkmark">&nbsp;</i> Mark this ad as Sold
                    </button>&nbsp;&nbsp;
					<button onclick = "$('.form-horizontal').removeClass('has-changes')" class="btn btn-large save update-listing btn-danger" type="submit" id="Withdrawn" value="Withdrawn">
                        <i class="icon-checkmark">&nbsp;</i> Mark this ad as Withdrawn
                    </button>&nbsp;&nbsp;
                </xsl:if>
                <xsl:if test="$data/ListingStatusDesc = 'Active' and scripts:IsToExtend($data/UnpubDate)">
                    <div class="visible-phone" style="margin-top:10px;"><xsl:text>
                    </xsl:text></div>
                    <button onclick = "$('.form-horizontal').removeClass('has-changes')" class="btn btn-large save update-listing btn-info" type="submit" id="Extend-Ad" value="Extend-Ad">
                        <i class="icon-checkmark">&nbsp;</i> Extend Ad
                    </button>
                </xsl:if>

                <xsl:if test="$IsRetailUser = 'true'">
                    <xsl:if test="$data/ListingStatusDesc != 'Active' and $data/ListingStatusDesc != 'Draft'">
                        <div class="visible-phone" style="margin-top:10px;"><xsl:text>
                        </xsl:text></div>
                        <button onclick = "$('.form-horizontal').removeClass('has-changes')" class="btn btn-large save update-listing btn-info" type="submit" id="Sell-Similar" value="Sell-Similar">
                            <i class="icon-checkmark">&nbsp;</i> Sell Similar
                        </button>&nbsp;&nbsp;

                        <xsl:variable name="TempListingExists" select="RESTscripts:TempListingExists()" />
                        <input type="hidden" id="TempListingExists" name="TempListingExists" value="{$TempListingExists}" />
                        <input type="hidden" id="ListingCode" name="ListingCode" value="{$listingCode}" />
                    </xsl:if>
                </xsl:if>
                
            </div>
        </xsl:if>
    </xsl:template>
    
    <!-- Automotive Additional Info -->
    <xsl:template name="ListingAdditionalInfo">
        <xsl:param name="data" />
		<xsl:param name="showFieldLocks" />
	
        <div class="AutomotiveListingAddInfo">
            <xsl:attribute name="style">
                <xsl:choose>
                    <xsl:when test="string-length($data/CatPath) &gt; 0 and ($data/CatID = '60' or $data/CatID = '67' or $data/CatID = '80' or $data/CatID = '600' or $data/CatID = '601')"></xsl:when>
                    <xsl:otherwise>display:none</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <div class="control-group">
                <label class="control-label">Vehicle registered
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
                        <xsl:if test="$showFieldLocks = '1'">
							<input type="checkbox" name="lock-registration" value="true" class="lock-field">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:if test="$LxRegNo ='true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$data/VehicleListing/LxRegNo ='true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</input>
						</xsl:if>
                    </div>
                </div>
				
				<div class="control-group">
                    <label class="control-label">VIN#
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
                        <xsl:if test="$showFieldLocks = '1'">
							<input type="checkbox" name="lock-VIN" value="true" class="lock-field">
								<xsl:choose>
									<xsl:when test="$IsPostBack = 'true'">
										<xsl:if test="$LxVinNumber ='true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="$data/VehicleListing/LxVinNumber ='true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</input>
						</xsl:if>
                    </div>
                </div>
				
				
                <div class="control-group">
                    <label class="control-label">Expiry date
                    </label>
                    <div class="controls">
                        <select class="drop-down input-small" id="listing-vehicle-expiry-month" name="listing-vehicle-expiry-month">
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
                            </input>Roadworthy certificate.
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
                            <!-- <xsl:with-param name="options">Select an option,Negotiable,Call for Price,Drive Away</xsl:with-param> -->
                            <xsl:with-param name="options">,VIN,Engine #</xsl:with-param>
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
						<xsl:attribute name="style">
							<xsl:if test="$data/VehicleListing/EngVinType != 'VIN'">display:none</xsl:if>
						</xsl:attribute>
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
					<input id="listing-vehicle-VinEngine-Engine" name="listing-vehicle-VinEngine-Engine" class="span" type="text" value ="">
						<xsl:attribute name="style">
							<xsl:if test="$data/VehicleListing/EngVinType = 'VIN'">display:none</xsl:if>
						</xsl:attribute>
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
                    <!-- <input id="listing-vehicle-VinEngine-No" name="listing-vehicle-VinEngine-No" class="span" type="text" value ="">
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
					<xsl:if test="$showFieldLocks = '1'">
						<input type="checkbox" name="lock-vinnumber" value="true" class="lock-field">
							<xsl:choose>
								<xsl:when test="$IsPostBack = 'true'">
									<xsl:if test="$LxVinNumber ='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$data/VehicleListing/LxVinNumber ='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</input>
					</xsl:if>
                </div>
            </div>
        </div>
    </xsl:template>
    
    <!-- Standard Listing Fields -->
    <xsl:template name="standardfields">
        <xsl:param name="data" />
        <xsl:param name="showFieldLocks" />
        <xsl:param name="HasError"/>
        
        <input type="hidden" id="listing-type" name="listing-type" value="{$data/LstType}">&nbsp;</input>
        <input type="hidden" id="listing-category-id" name="listing-category-id" value="{$data/CatID}">&nbsp;</input>
		
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
     		<xsl:value-of select="RESTscripts:GetUserCatalogList($SelectedUserCode, $SelectedUserCatalog, 1)"  disable-output-escaping="yes" />
        </xsl:if>
		
		<!--
		checking ~
		<xsl:value-of select="RESTscripts:GetUserCatalogList($LstUserCode, $LstCatalogID, 1)" />
		-->
		
		<div class ="control-group listingCatalog" style="display:none"><span style="display:none">&nbsp;</span></div>
		
        <div class="control-group">
            <label class="control-label">Status</label>
            <div class="controls">
                <input class="text allow-lowercase" id="listing-status" type="text" readonly = "readonly" name="listing-status">
					<xsl:attribute name="value">
						<xsl:value-of select="$data/ListingStatusDesc" />
						<xsl:variable name="LstDisplaySubStatus" select="scripts:GetListingStatus($data/ListingSubStatusDesc)" />					
						<xsl:if test="$LstDisplaySubStatus != ''">&nbsp;<xsl:value-of select="$LstDisplaySubStatus" />
						</xsl:if>
						<!-- <xsl:choose>
							<xsl:when test="$data/ListingSubStatusDesc = 'Active'"></xsl:when>
							<xsl:otherwise>
								<xsl:if test="$data/ListingSubStatusDesc != ''">&nbsp;(Pending Review)</xsl:if>
							</xsl:otherwise>
						</xsl:choose> -->
					</xsl:attribute>
                </input>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Category</label>
            <div class="controls">
                <input class="text allow-lowercase span8" id="listing-category-path" type="text" readonly = "readonly" name="listing-category-path" value="{$data/CatPath}">
                    <!-- <xsl:value-of select="$data/CatPath" /> -->
                </input>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label">
                Item Title&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Provide the brand and/or type of item you're selling">&nbsp;</i>
            </label>
            <div class="controls">
                <input class="text allow-lowercase span8" type="text" maxlength="200" name="listing-title" id="listing-title">
                    <xsl:if test="$data/CatPath = 'Automotive/Cars/Cars For Sale' or $data/CatPath='Automotive/Motorbikes/Motorbikes For Sale'">
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 200, messages: {required: 'Please enter the listing title'}}</xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <!-- <xsl:value-of select="$LstTitle" /> -->
                                <xsl:value-of select="scripts:FilterNasties($LstTitle)" />
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- <xsl:value-of select="$data/Title" /> -->
                                <xsl:value-of select="scripts:FilterNasties($data/Title)" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </input>
                <xsl:if test="$showFieldLocks = '1'">
                    <input type="checkbox" name="lock-title" value="true" class="lock-field">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:if test="$LxTitle ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$data/LxTitle ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>
                </xsl:if>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label">
                Summary Description&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Displayed in search results">&nbsp;</i>
            </label>
            <div class="controls">
                <textarea name="listing-summary" class="summary span8" rows="4" cols="40">
                    <xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 5000, messages: {required: 'Please enter a short summary description for display in search results'}}</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$IsPostBack = 'true'">
                            <xsl:value-of select="$LstSumDesc" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$data/SumDesc" />
                        </xsl:otherwise>
                    </xsl:choose>
                </textarea>
                <xsl:if test="$showFieldLocks = '1'">
                    <input type="checkbox" name="lock-summary-description" value="true" class="lock-field">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:if test="$LxSumDesc ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$data/LxSumDesc ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>
                </xsl:if>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label">
                Full Description&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="Displayed on the details screen">&nbsp;</i>
            </label>
            <div class="controls">
                <textarea id="listing-description" data-wysiwyg="true" name="listing-description" class="summary span8" rows="10" cols="40">
                    <!-- class="wysiwyg" -->
                    <xsl:attribute name="data-validate">{required: true, minlength: 6, messages: {required: 'Please enter a detailed description for display on the item details page'}}</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$IsPostBack = 'true'">
                            <xsl:value-of select="scripts:FilterNasties($LstDesc)" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="scripts:FilterNasties($data/DescWSYIWYG)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </textarea>
                <xsl:if test="$showFieldLocks = '1'">
                    <input type="checkbox" name="lock-description" value="true" class="lock-field">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:if test="$LxDesc ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$data/LxDesc ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>
                </xsl:if>
            </div>
        </div>
       
	    <div class="control-group" id="listing-has-pricing">
			<xsl:if test="$IsRetailUser = 'true'">
				<xsl:attribute name="style">display:none</xsl:attribute>
			</xsl:if>
			<label class="control-label">Does this item have a price?</label>
			<div class="controls">
				<label class="checkbox toggle well inline">
					<input type="checkbox" id="listing-has-price" name="listing-has-price" value="true">
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:if test="$LstHasPrice = 'true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$data/Price != '0' or $data/Price  != ''">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
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
        
		 <xsl:choose>
			<!-- Commercial customer with the following categories
					Automotive/Cars/Cars For Sale - 60			
					Motorbikes For Sale - 67
					Trucks and Buses For Sale - 80
					Automotive/Cars/Vintage Classic - 600
					Automotive/Cars/Hot Rods and Custom - 601
			-->
			<xsl:when test="$IsRetailUser != 'true' and ($data/CatID = '60' or $data/CatID = '67' or $data/CatID = '80' or $data/CatID = '600' or $data/CatID = '601')">
				<!-- <textarea>
					<xsl:value-of select ="$data/ListingsPricingInfo/PricingInfo[PriceType='DriveAway']/Amount" />
				</textarea> -->
				<div id="listing-pricing">
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
												<xsl:value-of select="scripts:FormatPrice($data/ListingsPricingInfo/PricingInfo[PriceType='DriveAway']/Amount)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
								<input id="listing-driveaway-price-orig" type="hidden" name="listing-driveaway-price-orig">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="scripts:FilterNasties($LstDriveAwayPrice)" /> 
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="scripts:FormatPrice($data/ListingsPricingInfo/PricingInfo[PriceType='DriveAway']/Amount)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
							<xsl:if test="$showFieldLocks = '1'">
								<input type="checkbox" name="lock-driveaway-price" value="true" class="lock-field">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test="$LxDriveawayPrice ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$data/ListingsPricingInfo/PricingInfo[PriceType='DriveAway']/Lock ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</input>
							</xsl:if>
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
												<xsl:value-of select="scripts:FormatPrice($data/ListingsPricingInfo/PricingInfo[PriceType='Sale']/Amount)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
								<input id="listing-sale-price-orig" type="hidden" name="listing-sale-price-orig">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="scripts:FilterNasties($LstSalePrice)" /> 
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="scripts:FormatPrice($data/ListingsPricingInfo/PricingInfo[PriceType='Sale']/Amount)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
							<xsl:if test="$showFieldLocks = '1'">
								<input type="checkbox" name="lock-sale-price" value="true" class="lock-field">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test="$LxSalePrice ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$data/ListingsPricingInfo/PricingInfo[PriceType='Sale']/Lock ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</input>
							</xsl:if>
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
												<xsl:value-of select="scripts:FormatPrice($data/ListingsPricingInfo/PricingInfo[PriceType='Unqualified']/Amount)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
								<input id="listing-unqualified-price-orig" type="hidden" name="listing-unqualified-price-orig">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="$IsPostBack = 'true'">
												<xsl:value-of select="scripts:FilterNasties($LstUnqualifiedPrice)" /> 
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="scripts:FormatPrice($data/ListingsPricingInfo/PricingInfo[PriceType='Unqualified']/Amount)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</div>
							<xsl:if test="$showFieldLocks = '1'">
								<input type="checkbox" name="lock-unqualified-price" value="true" class="lock-field">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test="$LxUnqualifiedPrice ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$data/ListingsPricingInfo/PricingInfo[PriceType='Unqualified']/Lock ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</input>
							</xsl:if>
						</div>
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div id="listing-pricing">
					<div class="control-group">
						<label class="control-label">Current Price</label>
						<div class="controls">
							<div class="input-prepend inline">
								<span class="add-on">$</span>
								<input class="text money" type="text" maxlength="13" id="listing-price" name="listing-price">
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
								<input type="hidden" id="listing-price-orig" name="listing-price-orig">
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
							<xsl:if test="$showFieldLocks = '1'">
								<input type="checkbox" name="lock-price" value="true" class="lock-field">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test="$LxPrice ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$data/LxPrice ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</input>
							</xsl:if>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">Original Price</label>
						<div class="controls">
							<div class="input-prepend inline">
								<span class="add-on">$</span>
								<input class="text money" type="text" maxlength="13" id="listing-was-price" name="listing-was-price">
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
								<input type="hidden" id="listing-was-price-orig" name="listing-was-price-orig">
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
							<xsl:if test="$showFieldLocks = '1'">
								<input type="checkbox" name="lock-was-price" value="true" class="lock-field">
									<xsl:choose>
										<xsl:when test="$IsPostBack = 'true'">
											<xsl:if test="$LxWasPrice ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="$data/LxWasPrice ='true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</input>
							</xsl:if>
						</div>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		
        <div class="control-group">
            <label class="control-label">Price Description</label>
            <div class="controls">
                <select class="drop-down" name="listing-price-qualifier" id="listing-price-qualifier">
					<xsl:choose>
						<xsl:when test="$IsPostBack = 'true'">
							<xsl:if test="$LstPriceQualifier = 'DriveAway'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$data/PriceType = 'DriveAway'"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				
                    <xsl:call-template name="optionlist">
                        <!-- <xsl:with-param name="options">,Negotiable,Call for Price,Drive Away</xsl:with-param> -->
                        <xsl:with-param name="options">,Negotiable</xsl:with-param>
                        <xsl:with-param name="value">
                            <xsl:choose>
                                <xsl:when test="$IsPostBack = 'true'">
                                    <xsl:value-of select="$LstPriceQualifier" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- <xsl:value-of select="$data/PriceQualifier" /> -->
									<xsl:value-of select="$data/PriceType" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </select>
				
				<input type="hidden" id="listing-price-qualifier-orig" name="listing-price-qualifier-orig">
					<xsl:attribute name="value">
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:value-of select="$LstPriceQualifier" />
							</xsl:when>
							<xsl:otherwise>
								<!-- <xsl:value-of select="$data/PriceQualifier" /> -->
								<xsl:value-of select="$data/PriceType" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</input>
				
                <xsl:if test="$showFieldLocks = '1'">
                    <input type="checkbox" name="lock-price-qualifier" value="true" class="lock-field">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:if test="$LxPriceQualifier ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$data/LxPriceQualifier ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>
                </xsl:if>
            </div>
        </div>
        
        <div class="control-group">
            <xsl:attribute name="style">
                <xsl:if test="$data/CatID = 528 or $data/CatID = 530 or $data/CatID = 532 or $data/CatID = 533 or $data/CatID = 536 or $data/CatID = 538">display:none</xsl:if>
            </xsl:attribute>
                    
            <label class="control-label">Condition</label>
            <div class="controls">
                <select class="drop-down listing-condition" name="listing-condition" style="width:112px">
                    <xsl:call-template name="optionlist">
                        <xsl:with-param name="options">New,Used,Demo</xsl:with-param>
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
                <select class="drop-down listing-condition-desc" name="listing-condition-desc" style="width:112px">
                    <xsl:attribute name="style">
                        <!-- <xsl:if test="$data/ConditionDesc != '' or $LstConditionDesc != ''">display:none</xsl:if> -->
                        <xsl:choose>
                            <xsl:when test="$data/Condition = 'New' or $LstCondition = 'New'">display:none</xsl:when>
                            <xsl:when test="$data/ConditionDesc != '' or $LstConditionDesc != ''"></xsl:when>
                            <xsl:otherwise>display:none</xsl:otherwise>
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
                <xsl:if test="$showFieldLocks = '1'">
                    <input type="checkbox" id="lock-condition" name="lock-condition" value="true" class="lock-field">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:if test="$LxCondition ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$data/LxCondition ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>
                    
                </xsl:if>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label">Stock Number/SKU
				<xsl:if test="$IsRetailUser != 'true'">
					<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="Stock number is a compulsory field, it can only contain alphanumeric characters and it can not be edited.">&nbsp;</i>
				</xsl:if>
			</label>
            <div class="controls">
                <input class="text allow-lowercase" type="text" maxlength="50" name="listing-stock-number-display">
                    <xsl:attribute name="data-validate">{required: false, minlength: 1, maxlength: 50, regex:/^[a-z0-9]+$/i, messages: {required: 'Please enter the stock number'}}</xsl:attribute>
					<xsl:if test="$IsRetailUser != 'true'">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
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
				<input type="hidden" name="listing-stock-number" value="{$data/StkNo}" />
				
                <!-- <xsl:if test="$showFieldLocks = '1'">
                    <input type="checkbox" name="lock-stock-number" value="true" class="lock-field">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:if test="$LxStkNo ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$data/LxStkNo ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>
                </xsl:if> -->
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label">Item Location</label>
            <div class="controls">
                <input class="text allow-lowercase" type="text" maxlength="50" id="listing-location"  name="listing-location" autocomplete="off" placeholder="Suburb, State Postcode">
                    <!--<xsl:attribute name="data-validate">{required: false, regex:/^(?:[A-Za-z0-9\s]*)(?:,)(?:[A-Za-z0-9\s]*)(?:\s)(?:[0-9]*)*$/, minlength: 1, maxlength: 50, messages: {required: 'Please enter the location', regex: 'Please enter a valid location (e.g. Sydney, NSW 2000)'}}</xsl:attribute>-->
                    <xsl:attribute name="data-validate">{required: true, minlength: 1, maxlength: 50, messages: {required: 'This field is required.'}}</xsl:attribute>
                    <xsl:attribute name="value">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:value-of select="$LstLocation" />
                            </xsl:when>
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
                <xsl:if test="$showFieldLocks = '1'">
                    <input type="checkbox" name="lock-location" value="true" class="lock-field">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:if test="$LxLocation ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$data/LxStkLoc ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>
                </xsl:if>
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
            <label class="control-label">Date Created</label>
            <div class="controls">
                <label class="value">
                    <xsl:value-of select="umbraco.library:FormatDateTime($data/DateCreated, 'd MMM yyyy, HH:mm:ss')" />
                </label>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label">Last Edited</label>
            <div class="controls">
                <label class="value">
                    <xsl:choose>
                        <xsl:when test="$data/DateEdited !=''">
                            <xsl:value-of select="umbraco.library:FormatDateTime($data/DateEdited, 'd MMM yyyy, HH:mm:ss')" />
                        </xsl:when>
                        <xsl:otherwise>
                            <i>(Never)</i>
                        </xsl:otherwise>
                    </xsl:choose>
                </label>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label">Data Source</label>
            <div class="controls">
                <label class="value">
                    <xsl:choose>
						<xsl:when test="$data/SrcName != ''">
                            <xsl:value-of select="$data/SrcName" />
                        </xsl:when>
                        <xsl:when test="$data/ExtLink != ''">
                            <a href="{$data/ExtLink}" target="_blank">
                                <xsl:value-of select="$data/ExtLink" />
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <i>N/A</i>
                        </xsl:otherwise>
                    </xsl:choose>
                </label>
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
                    <xsl:otherwise>[Select an option]</xsl:otherwise>
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
    
    <!-- Summary and full description editors -->
    <xsl:template name="descriptionEditors">
        <xsl:param name="data" />
        <xsl:param name="showFieldLocks" />
        
        <div class="group-box">
            <div class="underlay">
                <h1>
                    <span class="description">&nbsp;</span>Comments/Description
                </h1>
            </div>
            <ul class="full">
                <li>
                    <label class="on-top">
                        Summary Description <span>(Displayed in search results)</span>
                    </label>
                    <textarea name="listing-summary" class="summary">
                        <xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 250, messages: {required: 'Please enter a short summary description for display in search results'}}</xsl:attribute>
                        <xsl:value-of select="$data/SumDesc" />
                    </textarea>
                    <xsl:if test="$showFieldLocks = '1'">
                        <input type="checkbox" name="lock-summary-description" value="true" class="lock-field">
                            <xsl:if test="$data/LxSumDesc ='true'">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                            </xsl:if>
                        </input>
                    </xsl:if>
                </li>
                <li>
                    <label class="on-top">
                        Full Description <span>(Displayed on the details screen)</span>
                    </label>
                    <textarea id="listing-description" data-wysiwyg="true" name="listing-description" class="summary">
                        <!-- class="wysiwyg" -->
                        <xsl:attribute name="data-validate">{required: true, minlength: 6, messages: {required: 'Please enter a detailed description for display on the item details page'}}</xsl:attribute>
                        <xsl:value-of select="$data/Desc" />
                    </textarea>
                    <xsl:if test="$showFieldLocks = '1'">
                        <input type="checkbox" name="lock-description" value="true" class="lock-field">
                            <xsl:if test="$data/LxDesc ='true'">
                                <xsl:attribute name="checked">checked</xsl:attribute>
                            </xsl:if>
                        </input>
                    </xsl:if>
                </li>
            </ul>
            
            <div class="footer-underlay">
                <input class="button save update-listing" type="submit" value="Update Description/Comments" />
            </div>
        </div>
        
    </xsl:template>
    
    <!-- Automotive feature editors -->
    <xsl:template name="featureEditors">
        <xsl:param name="data" />
        <xsl:param name="showFieldLocks" />
		<xsl:if test="$showFieldLocks = '1'">
			<div class="FeaturesLock">
				<span style="font-size:160%;"><strong>Standard &amp; Optional Features</strong></span>
				<input type="checkbox" name="lock-features" value="true" class="lock-field">
					<xsl:choose>
						<xsl:when test="$IsPostBack = 'true'">
							<xsl:if test="$LxVehicleFeatures ='true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$data/VehicleListing/LxVehicleFeatures ='true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</div>
		</xsl:if>
        <div class="row-fluid">
            <textarea style="display:none">
                <xsl:copy-of select="$data"/>
            </textarea>
            <div class="span5 todo">
                <h5>Standard Features</h5>
				
				<xsl:if test="$data/ListingStatusDesc = 'Draft' or $data/ListingStatusDesc = 'Active'">
					<div class="input-append">
						<input type="text" id="new-standard-feature" class="text allow-lowercase">
							<xsl:attribute name="data-validate">{required: false}</xsl:attribute>
						</input>
						<a class="btn" href="#" id="add-standard-feature">Add</a>
					</div>
					<br /><br />
                </xsl:if>
				
                <ul class="todo-list" id="standard-features" name="standard-features">
                    <xsl:for-each select="$data/ListingsVehicleFeatures/FeatureInfo">
                        <xsl:if test="./FeatureType = 'standard'">
                            <li data-id="{./ID}">
								<xsl:choose>
									<xsl:when test="$data/ListingStatusDesc = 'Draft' or $data/ListingStatusDesc = 'Active'">
										<a href="#" class="select-item-delete btn btn-small btn-info" data-id="{./ID}"><i class="icon-remove"><xsl:text>
											</xsl:text></i></a>
									</xsl:when>
									<xsl:otherwise>-</xsl:otherwise>
								</xsl:choose>
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
                
                <h5>Optional Features</h5>
                
				<xsl:if test="$data/ListingStatusDesc = 'Draft' or $data/ListingStatusDesc = 'Active'">
					<div class="input-append">
						<input type="text" id="new-optional-feature" class="text allow-lowercase">
							<xsl:attribute name="data-validate">{required: false}</xsl:attribute>
						</input>
						<a class="btn" href="#" id="add-optional-feature">Add</a>
					</div>
					<br /><br />
                </xsl:if>
                
                
                <ul class="todo-list" id="optional-features">
                    <xsl:for-each select="$data/ListingsVehicleFeatures/FeatureInfo">
                        <xsl:if test="./FeatureType = 'optional'">
                            <li data-id="{./ID}">
								<xsl:choose>
									<xsl:when test="$data/ListingStatusDesc = 'Draft' or $data/ListingStatusDesc = 'Active'">
										<a href="#" class="select-item-delete btn btn-small btn-info" data-id="{./ID}"><i class="icon-remove"><xsl:text>
											</xsl:text></i></a>
									</xsl:when>
									<xsl:otherwise>-</xsl:otherwise>
								</xsl:choose>
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
            
			<!-- <xsl:if test="$showFieldLocks = '1'">
				<div class="span5 FeaturesLock">
					<span style="font-size:140%;">Lock Standard &amp; Optional Features</span>
					<input type="checkbox" name="lock-features" value="true" class="lock-field">
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:if test="$LxVehicleFeatures ='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$data/VehicleListing/LxVehicleFeatures ='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</input>
				</div>
			</xsl:if> -->
            
            <input class="hidden button save update-listing" type="submit" value="Update Listing Features" />
            
        </div>
        
        <input type="hidden" name="update-features" id="update-features" value="true" />
        <input type="hidden" name="listing-optional-features" id="listing-optional-features" />
        <input type="hidden" name="listing-standard-features" id="listing-standard-features" />
        
    </xsl:template>
    
    <!-- Automotive feature editors -->
    <xsl:template name="MotorfeatureEditors">
        <xsl:param name="data" />
		<xsl:param name="showFieldLocks" />
		
		 <!-- <h3>Features</h3> -->
		<xsl:if test="$showFieldLocks = '1'">
			<div class="FeaturesLock">
				<span style="font-size:200%;"><strong>Features</strong></span>
				<input type="checkbox" name="lock-features" value="true" class="lock-field">
					<xsl:choose>
						<xsl:when test="$IsPostBack = 'true'">
							<xsl:if test="$LxVehicleFeatures ='true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$data/VehicleListing/LxVehicleFeatures ='true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</div>
		</xsl:if>
		
        <div class="row-fluid">
            <div class="span5 todo">
                <h5>Features</h5>
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
                
				<!-- <xsl:if test="$showFieldLocks = '1'">
					<div class="span5 FeaturesLock">
						<span style="font-size:140%;">Lock Features</span>
						<input type="checkbox" name="lock-features" value="true" class="lock-field">
							<xsl:choose>
								<xsl:when test="$IsPostBack = 'true'">
									<xsl:if test="$LxVehicleFeatures ='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$data/VehicleListing/LxVehicleFeatures ='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</input>
					</div>
				</xsl:if> -->
				
            </div>
			
            <input class="hidden button save update-listing" type="submit" value="Update Listing Features" />
            
        </div>
        
        <input type="hidden" name="update-features" id="update-features" value="true" />
        <input type="hidden" name="listing-motor-standard-features" id="listing-motor-standard-features" />
        
    </xsl:template>

    <!-- Listing Videos Template -->
    <xsl:template name="listingVideos">
        <xsl:param name="data" />
		<xsl:param name="showFieldLocks" />
		
        <xsl:variable name="vidCount" select="count($data/ListingsVideoInfo/VideoEditInfo)"/>
        
        <xsl:if test="count($data/ListingsVideoInfo/VideoEditInfo[VideoSource='DMI']) &gt; 0">
            <div class="alert alert-info">
                You may get a security alert while viewing some video.<br />
                Please allow access to the content if you want to play the video. &nbsp;&nbsp;<a href="#" id="how-to-unsecure">How to do this?</a> 
            </div>
        </xsl:if>
        
        <div class="group-box">
            
            <ul class="row-fluid" id="video-thumbnails">
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
                                <a id="ViewVideo" href="mediaID={./VideoData}" 
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
        
        <div class="group-box">&nbsp;
			<xsl:if test="$data/ListingStatusDesc = 'Draft' or $data/ListingStatusDesc = 'Active'">
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
					<xsl:if test="$showFieldLocks = '1'">
						<input type="checkbox" name="lock-video" value="true" class="lock-field">
							<xsl:choose>
								<xsl:when test="$IsPostBack = 'true'">
									<xsl:if test="$LxVideos ='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$data/LxVideos ='true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</input>
					</xsl:if>
				</div>
			</xsl:if>
        </div>
        
    </xsl:template>
    
	<!-- Contact level setting -->
	<xsl:template name="contactSetting">
		<xsl:param name="data" />
		<xsl:param name="showFieldLocks" />
		
		<div class="control-group" id="div-contact-setting">
			<label class="control-label">Use Safety and Privacy settings</label>
			<div class="controls">
				<label class="checkbox toggle well inline">
					<input type="checkbox" id="listing-contact-setting" name="listing-contact-setting" value="true">
						<xsl:choose>	
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:if test="$LstIsAccountLevel ='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>							
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>	
									<xsl:when test="$data/ContactDisplayLevelSetting ='1'"></xsl:when>
									<xsl:otherwise><xsl:attribute name="checked">checked</xsl:attribute></xsl:otherwise>
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
		
		<div id="listing-level-contact">
			<xsl:attribute name="style">
				<xsl:choose>	
					<xsl:when test="$IsPostBack = 'true'">
						<xsl:if test="$LstIsAccountLevel ='true'">display:none</xsl:if>							
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>	
							<xsl:when test="$data/ContactDisplayLevelSetting ='1'"></xsl:when>
							<xsl:otherwise>display:none</xsl:otherwise>
						</xsl:choose>		
					</xsl:otherwise>
				</xsl:choose>					
			</xsl:attribute>
			
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
	</xsl:template>

    <!-- Listing Images Template -->
    <xsl:template name="listingImages">
        <xsl:param name="data" />
        <xsl:param name="showFieldLocks" />

        <!-- Loaders -->
        <div id="loading-bg-transparent" style="display:none">
            <xsl:text>
			</xsl:text>
        </div>
        <div id="loading-dialog" style="display:none">
            <img class="retina" src="/images/spinner.png" />
        </div>
        <!-- /Loaders -->

        <div id="manage-images" class="ajax" data-url="/ajax/manage-photos.aspx?listing={$data/Code}">

            <xsl:variable name="imgCount" select="count($data/ListingsImageInfo/ImageEditInfo)"/>
            <div class="group-box">
                <!-- Display existing thumbs -->
                <xsl:if test="$imgCount &gt; 0">
                    <ul class="row-fluid" id="listing-thumbnails">
                        <xsl:for-each select="$data/ListingsImageInfo/ImageEditInfo">
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

                                <a href="#" class="delete-image" data-image-id="{./ID}" title="Delete photo">
                                    <i class="icon-remove">
                                        <xsl:text>
										</xsl:text>
                                    </i>
                                </a>

                                <a href="#" class="rotate-image-left" data-image-id="{./ID}" title="Rotate Left">
                                    <i class="icon-undo-2">
                                        <xsl:text>
										</xsl:text>
                                    </i>
                                </a>
                                <a href="#" class="rotate-image-right" data-image-id="{./ID}" title="Rotate Right">
                                    <i class="icon-redo-2">
                                        <xsl:text>
										</xsl:text>
                                    </i>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>

                </xsl:if>

                <input type="hidden" id="update-photos" name="update-photos" value="true" />
                <input type="hidden" id="photo-order" name="photo-order" />
                <input type="hidden" id="photo-captions" name="photo-captions" />
                <input type="hidden" id="delete-photos" name="delete-photos" />

                <input type="submit" class="update-listing" value="Update Photos" style="display:none" />

            </div>

            <!-- <xsl:if test="$IsManagerEditorGroup != false">
				<p>
					<i class="icon-info">&nbsp;</i> You can sort the image via drag and drop.
				</p>

				<a class="btn btn-primary push-bottom" id="upload-photo" href="#">
					<i class="icon-camera">&nbsp;</i> Add a new Photo 
				</a>
				
				<xsl:if test="$showFieldLocks = '1'"> 
					<input type="checkbox" name="lock-photo" value="true" class="lock-field">
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:if test="$LxImages ='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$data/LxImages ='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</input>
				</xsl:if>
			</xsl:if> -->

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

        </div>
        <xsl:if test="$IsManagerEditorGroup != false">
            <xsl:if test="$data/ListingStatusDesc = 'Draft' or $data/ListingStatusDesc = 'Active'">
                <p>
                    <!-- <i class="icon-info">&nbsp;</i> You can sort the image via drag and drop. -->
					<i class="icon-info">&nbsp;</i> Use the left/right arrows to rotate your photos <br/>
					<i class="icon-info">&nbsp;</i> Drag and drop photos to change their sort order
                </p>

                <a class="btn btn-primary push-bottom" id="upload-photo" href="#">
                    <i class="icon-camera">&nbsp;</i> Add a new Photo
                </a>
				<xsl:if test="$showFieldLocks = '1'">
					<input type="checkbox" name="lock-photo" value="true" class="lock-field">
						<xsl:choose>
							<xsl:when test="$IsPostBack = 'true'">
								<xsl:if test="$LxImages ='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$data/LxImages ='true'">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</input>
				</xsl:if>
			
				<br/>
			    <a class="" id="upload-photo-basic" href="#">Having trouble? Try the Basic Uploader.</a>
			</xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- Ads Distribution Template -->
    <xsl:template name="adsdistribution">
        <xsl:param name="data" />
		
		<!-- Render Dynamically -->
		<xsl:variable name="UserList" select="RESTscripts:GetUserList()" />
		
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
		
		<xsl:variable name = "UserCatalogList">	
			<xsl:if test="string-length($UserList) &gt; 0 and $IsRetailUser != 'true'">
     			<xsl:value-of select="RESTscripts:GetUserCatalogList($SelectedUserCode, $SelectedUserCatalog, 1)" />
			</xsl:if>
		</xsl:variable>
		
		
		<xsl:variable name="FeedDestinationList" select="RESTscripts:GetUserCatalogListFeedDestination($SelectedUserCode, $SelectedUserCatalog, 1)" />

		<xsl:variable name="FeedDestination" select="RESTscripts:ParseReponse($FeedDestinationList)/*" />
		<xsl:choose>
		<xsl:when test="$FeedDestination != ''">
			<xsl:for-each select="$FeedDestination/Catalog">
				<xsl:call-template name="adsdistributionDestination">
					<xsl:with-param name="DestinationLabel"><xsl:value-of select="RESTscripts:SplitAtCapitalLetter(FeedDestinationName)" /></xsl:with-param>
					<xsl:with-param name="DestinationValue"><xsl:value-of select="FeedDestinationName" /></xsl:with-param>
					<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		</xsl:choose> 
		
		<!-- Render Dynamically -->
		
		<!--
        <xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>TradingPost</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>TradingPost</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
-->
		<!-- <div class="control-group">
			<xsl:attribute name="id">DIV-TradingPost</xsl:attribute>
            <label class="control-label">Trading Post</label>
            <div class="controls">
                <label class="checkbox toggle well inline">
                    <input type="checkbox" name="listing-publish-dest" value="TradingPost" disabled="disabled">
						<xsl:attribute name="id">listing-publish-dest-TradingPost</xsl:attribute>
                        <xsl:attribute name="checked">checked</xsl:attribute>
                    </input>
                    <p>
                        <span>Yes</span>
                        <span>No</span>
                    </p>
                    <a class="btn slide-button">&nbsp;</a>
                </label>
				<input type="hidden" name="listing-publish-dest" value="TradingPost" />
            </div>
        </div> -->
		
		<!--
		<xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>Unqiue Websites</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>UniqueWebsites</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
	   
	   <xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>Cars Guide</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>Carsguide</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>Dealer Solutions</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>DealerSolutions</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>Gumtree</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>Gumtree</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>Ebay</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>Ebay</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>Just Autos</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>JustAutos</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>Carsales</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>Carsales</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="adsdistributionDestination">
			<xsl:with-param name="DestinationLabel"><xsl:text>MyCarAds</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationValue"><xsl:text>MyCarAds</xsl:text></xsl:with-param>
			<xsl:with-param name="DestinationControlName"><xsl:text>listing-publish-dest</xsl:text></xsl:with-param>
		</xsl:call-template>
		-->
	   <!-- Tradingpost -->
        <!-- <div class="control-group">
            <label class="control-label">Trading Post</label>
            <div class="controls">
                
                <label class="checkbox toggle well inline">
                    <input type="checkbox" name="listing-publish-tp" value="true" id="listing-publish-tp">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                    </input>
                    <p>
                        <span>Yes</span>
                        <span>No</span>
                    </p>
                    
                    <a class="btn slide-button">&nbsp;</a>
                </label>
            </div>
        </div> -->
	  
        <!-- Unique Website -->
        <!-- <div class="control-group">
            <label class="control-label">Unique Websites</label>
            <div class="controls">
                
                <label class="checkbox toggle well inline">
                    <input type="checkbox" name="listing-publish" value="true" id="publish">
                        <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                                <xsl:if test="$LstPublish ='true'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$data/IsHidden ='false'">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </input>
                    <p>
                        <span>Yes</span>
                        <span>No</span>
                    </p>
                    
                    <a class="btn slide-button">&nbsp;</a>
                </label>
                <label class="value inline hidden">
                    &nbsp;<i class="icon-connection" style="color:#4486f5">&nbsp;</i>
                    <xsl:choose>
                        <xsl:when test="$data/PubDate !=''">
                            <xsl:choose>
                                <xsl:when test="$data/IsHidden ='false'">
                                    Published from
                                    <xsl:value-of select="umbraco.library:FormatDateTime($data/PubDate, 'd MMM yyyy, HH:mm:ss')" /> until <xsl:value-of select="umbraco.library:FormatDateTime($data/UnpubDate, 'd MMM yyyy, HH:mm:ss')" />
                                </xsl:when>
                                <xsl:otherwise>
                                    Last published on
                                    <xsl:value-of select="umbraco.library:FormatDateTime($data/PubDate, 'd MMM yyyy, HH:mm:ss')" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <i>N/A</i>
                        </xsl:otherwise>
                    </xsl:choose>
                </label>
            </div>
        </div> -->

    </xsl:template>
	
	 <!-- Listing Images Template -->
    <xsl:template name="adsdistributionDestination">
		<xsl:param name="DestinationLabel" />
		<xsl:param name="DestinationValue" />
		<xsl:param name="DestinationControlName" />
		
		<div class="control-group" style="display:none;">
			<xsl:attribute name="id">DIV-FeedDest-<xsl:value-of select="$DestinationValue" /></xsl:attribute>
            <label class="control-label"><xsl:value-of select="$DestinationLabel" /></label>
            <div class="controls">
                <label class="checkbox toggle well inline">
                    <input type="checkbox" name="{$DestinationControlName}" value="{$DestinationValue}" >
						<xsl:attribute name="id"><xsl:value-of select="$DestinationControlName" />-<xsl:value-of select="$DestinationValue" /></xsl:attribute>
                        <!-- <xsl:attribute name="checked">checked</xsl:attribute> -->
                    </input>
                    <p>
                        <span>Yes</span>
                        <span>No</span>
                    </p>
                    <a class="btn slide-button">&nbsp;</a>
                </label>
            </div>
        </div>
    </xsl:template>
	 
	
    <!-- C# helper scripts -->
    <msxml:script language="C#" implements-prefix="scripts">
        <![CDATA[

  public string GetListingStatus(string Status)
  {
  		var DisplayStatus = "";
        if (Status.ToLower().Contains("revision"))
        {
        	DisplayStatus = "(Need Revision)";
        }
		else if (Status.ToLower().Contains("cancelled_moderation"))
        {
			DisplayStatus = "";
        }
        else if (Status.ToLower().Contains("moderation") || Status.ToLower().Contains("draft_needssafetyscan"))
        {
            DisplayStatus = "(Pending Review)";
        }
        return DisplayStatus;
  }
  
public string FilterNasties(string s){
   //return s.Replace("<","").Replace(">","").Replace("\"","").Replace("&#38;","&").Replace("&quot;","'");
	
 	//return s.Replace("<","").Replace(">","").Replace("&#38;","&").Replace("&quot;","\"");

	return RemoveTroublesomeCharacters(s.Replace("<","").Replace(">","").Replace("&#38;","&").Replace("&quot;","\"").Replace((char)(0x1F), ' '));
}

 /// <summary>
 /// Removes control characters and other non-UTF-8 characters
 /// </summary>
 /// <param name="inString">The string to process</param>
 /// <returns>A string with no control characters or entities above 0x00FD</returns>
 public string RemoveTroublesomeCharacters(string inString)
 {
     if (inString == null) return null;

     StringBuilder newString = new StringBuilder();
     char ch;
     for (int i = 0; i < inString.Length; i++)
     {
        ch = inString[i];
        // remove any characters outside the valid UTF-8 range as well as all control characters
        // except tabs and new lines
        if ((ch < 0x00FD && ch > 0x001F) || ch == '\t' || ch == '\n' || ch == '\r')
        {
              newString.Append(ch);
        }
     }
     return newString.ToString();
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

public bool IsToExtend(DateTime UnPubDate)
{
    bool IsToExtend = false;

    if (DateTime.Now >= UnPubDate.AddDays(-7) && DateTime.Now < UnPubDate)
    {
        IsToExtend = true;
    }

    return IsToExtend;
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
