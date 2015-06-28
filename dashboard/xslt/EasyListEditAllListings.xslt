<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:scripts="urn:scripts.this"
xmlns:RESTscripts="urn:RESTscripts.this"
xmlns:AccScripts="urn:AccScripts.this"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
exclude-result-prefixes="msxml scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListRestHelper.xslt" />
	<xsl:include href="EasyListHelper.xslt" />
	<xsl:include href="EasyListStaffHelper.xslt" />
	
	
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	<xsl:variable name="userName" select="umbraco.library:Session('easylist-username')" />
	<xsl:variable name="password" select="umbraco.library:Session('easylist-password')" />
		
	<!-- Find the page number -->
	<xsl:variable name="pageNumber">
		<xsl:choose>
			<xsl:when test="umbraco.library:RequestQueryString('page') &lt;= 1 or string(umbraco.library:RequestQueryString('page')) = '' or string(umbraco.library:RequestQueryString('page')) = 'NaN'">
				<xsl:value-of select="number(1)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(umbraco.library:RequestQueryString('page'))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Dealer ID(s) -->
	<!-- <xsl:variable name="dealerID" select="umbraco.library:Session('easylist-usercode')" /> -->
	<!--<xsl:variable name="dealerID" select="umbraco.library:Session('easylist-usercodelist')" />-->
			
	<xsl:variable name="dealerID">
      <xsl:choose>
        <xsl:when test="umbraco.library:RequestQueryString('DealerIDs') = ''">
          <xsl:value-of select="umbraco.library:Session('easylist-usercodelist')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="umbraco.library:RequestQueryString('DealerIDs')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	
	<xsl:variable name="dealerIDAll" select="umbraco.library:Session('easylist-usercodelist')" />
	<xsl:variable name="HasChildList" select="scripts:HasChildList($dealerIDAll)"/>
	
	<xsl:variable name="priceMin">
		<xsl:choose>
			<xsl:when test="string(umbraco.library:RequestQueryString('price-min')) != ''">
				<xsl:value-of select="umbraco.library:RequestQueryString('price-min')"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="priceMax">
		<xsl:choose>
			<xsl:when test="string(umbraco.library:RequestQueryString('price-max')) != ''">
				<xsl:value-of select="umbraco.library:RequestQueryString('price-max')"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- <xsl:variable name="priceMax" select="umbraco.library:RequestQueryString('price-max')"/> -->
	<xsl:variable name="LstCatalogID" select="umbraco.library:Request('listing-catalog')" />
	
	<xsl:variable name="keywords" select="umbraco.library:RequestQueryString('q')"/>
	<xsl:variable name="sort" select="umbraco.library:RequestQueryString('sort')"/>
	
	<xsl:variable name="photos" select="umbraco.library:RequestQueryString('photos')"/>
	<xsl:variable name="StockNumber" select="umbraco.library:RequestQueryString('StockNumber')"/>
	<xsl:variable name="Makes">
		<xsl:choose>
			<xsl:when test="string(umbraco.library:RequestQueryString('Makes')) != 'Select'">
				<xsl:value-of select="umbraco.library:RequestQueryString('Makes')"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="Models">
		<xsl:choose>
			<xsl:when test="string(umbraco.library:RequestQueryString('Models')) != 'Select'">
				<xsl:value-of select="umbraco.library:RequestQueryString('Models')"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="condition">
		<xsl:choose>
			<xsl:when test="/macro/forceCondition != '' and /macro/forceCondition != 'None'">
				<xsl:value-of select="/macro/forceCondition" />
			</xsl:when>
			<xsl:when test="string(umbraco.library:RequestQueryString('condition')) = 'Select'">
			</xsl:when>
			<xsl:when test="string(umbraco.library:RequestQueryString('condition')) = 'All'">
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="umbraco.library:RequestQueryString('condition')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="Status">
		<xsl:choose>
			<xsl:when test="string(umbraco.library:RequestQueryString('Status')) = 'Select'">
			</xsl:when>
			<xsl:when test="string(umbraco.library:RequestQueryString('Status')) = 'All'">
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="umbraco.library:RequestQueryString('Status')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="HasException" select="umbraco.library:RequestQueryString('HasException')"/>
	<xsl:variable name="PendingModeration" select="umbraco.library:RequestQueryString('PendingModeration')"/>
	<xsl:variable name="MissingImage" select="umbraco.library:RequestQueryString('MissingImage')"/>
	<xsl:variable name="MissingVideo" select="umbraco.library:RequestQueryString('MissingVideo')"/>
	<xsl:variable name="NoPrice" select="umbraco.library:RequestQueryString('NoPrice')"/>
	
	<xsl:variable name="ExceptionTypeDesc" select="umbraco.library:RequestQueryString('ExceptionTypeDesc')"/>
	<xsl:variable name="ExceptionType">
		<xsl:choose>
			<xsl:when test="$ExceptionTypeDesc = 'Warning'">1</xsl:when>
			<xsl:when test="$ExceptionTypeDesc = 'Error'">2</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Rendering Options -->
	<xsl:variable name="usePopups">1</xsl:variable>
	<xsl:variable name="gmTitle">General Merhandise</xsl:variable>
	<xsl:variable name="carsTitle">Car Listings</xsl:variable>
	<xsl:variable name="motorbikesTitle">Motorcycle Listings</xsl:variable>
	<xsl:variable name="summaryCharacters">200</xsl:variable>
	<xsl:variable name="readMoreText">View Full Listing</xsl:variable>
	
	<!-- Find the selected category -->
	<xsl:variable name="category">
		<xsl:value-of select="umbraco.library:RequestQueryString('cat')"/>
	</xsl:variable>
	
	<!-- Number of records per page (from Macro but defaults to 20) -->
	<xsl:variable name="recordsPerPage">
		<xsl:choose>
			<xsl:when test="/macro/recordsPerPage">
				<xsl:value-of select="/macro/recordsPerPage"/>
			</xsl:when>
			<xsl:otherwise>10</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Display Options -->
	<xsl:variable name="thumbnailWidth">200</xsl:variable>
	<xsl:variable name="displayMetaData">1</xsl:variable>
	<xsl:variable name="displayMetaCondition">1</xsl:variable>
	<xsl:variable name="displayMetaMakeModel">1</xsl:variable>
	<xsl:variable name="displayMetaYear">1</xsl:variable>
	<xsl:variable name="displayMetaOdometer">1</xsl:variable>
	<xsl:variable name="displayMetaRegistration">1</xsl:variable>
	<xsl:variable name="displayMetaTransmission">1</xsl:variable>
	<xsl:variable name="displayMetaEngine">1</xsl:variable>
	<xsl:variable name="displayMetaFuelType">1</xsl:variable>
	<xsl:variable name="displayMetaColour">1</xsl:variable>
	<xsl:variable name="displayMetaBodyStyle">1</xsl:variable>
	<xsl:variable name="displayLocation">1</xsl:variable>
	<xsl:variable name="displayDealerName">1</xsl:variable>
	<xsl:variable name="displayMetaCategory">1</xsl:variable>
	
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	
	
	<xsl:variable name="quot">"</xsl:variable>
	<xsl:variable name="apos">'</xsl:variable>
	
	<xsl:param name="currentPage"/>
	
	<xsl:variable name="IsRetailUser" select="AccScripts:IsRetailUser()" />
	
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
	
	<xsl:template name="LoadPage" >
		<!--<textarea>
			<xsl:value-of select="$dealerID" />
		</textarea>
			-->
		<!-- Stock List Template -->
		<xsl:if test="$dealerID != ''">
			
			<xsl:variable name="includeSold">1</xsl:variable>
			<xsl:variable name="includeArchived">1</xsl:variable>
			<xsl:variable name="searchDescriptions">1</xsl:variable>
			
			<!-- debugging <textarea>
		   <xsl:value-of select="$userName" />, 
		   <xsl:value-of select="$password" />, 
		   <xsl:value-of select="$pageNumber" />, 
		   <xsl:value-of select="$recordsPerPage" />, 
		   <xsl:value-of select="$priceMin" />, 
		   <xsl:value-of select="$priceMax" />, 
		   <xsl:value-of select="$condition" />, 
		   <xsl:value-of select="$keywords" />, 
		   <xsl:value-of select="$category" />, 
		   <xsl:value-of select="$sort" />, 
		   <xsl:value-of select="$includeSold" />, 
		   <xsl:value-of select="$includeArchived" />, 
		   <xsl:value-of select="$searchDescriptions" />, 
		  </textarea>-->
					<!-- userName, password, page, pageSize,
		   minPrice,  maxPrice, condition,
		   keywords,  category,  sortOrder,  includeSold,  includeArchived,
		   searchDescriptions -->
					<!-- Get the search results -->
					<!--<xsl:variable name="data" select="scripts:SearchListings($userName, $password, 
		 $pageNumber, $recordsPerPage, $priceMin, $priceMax, $condition, $keywords, $category, 
		 $sort, $includeSold, $includeArchived, $searchDescriptions)" />-->
			
			<xsl:variable name="DealerInfoUrl" select="RESTscripts:GetDealerInfo($dealerID)"/>
			<xsl:variable name="DealerInfoData" select="umbraco.library:GetXmlDocumentByUrl($DealerInfoUrl, 2)" />
			<xsl:variable name="DealerInfoDataResult" select="$DealerInfoData/RESTStatus/Result" />
			<xsl:variable name="DealerInfoItems" select="RESTscripts:ParseReponse($DealerInfoDataResult)" />
			
			<xsl:variable name="IsSearch" select="umbraco.library:RequestQueryString('IsSearch')" />
			
			<!--
			<xsl:variable name="ListingType">
				<xsl:choose>
					<xsl:when test="umbraco.library:RequestQueryString('ListingType') = 'Car' and $DealerInfoItems/DealerSearchInfo/HasCars != 'true' and $IsSearch != '1'">
						<xsl:choose>	
							<xsl:when test="$DealerInfoItems/DealerSearchInfo/HasMotorcycles = 'true'">Motorcycle</xsl:when>
							<xsl:when test="$DealerInfoItems/DealerSearchInfo/HasGM = 'true'">General</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="umbraco.library:RequestQueryString('ListingType')">
						<xsl:value-of select="umbraco.library:RequestQueryString('ListingType')"/>
					</xsl:when>
					<xsl:otherwise>Car</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			-->
			<xsl:variable name="ListingType">
				<xsl:choose>
					<xsl:when test="umbraco.library:RequestQueryString('ListingType') != ''">
						<xsl:value-of select="umbraco.library:RequestQueryString('ListingType')"/>
					</xsl:when>
					<xsl:when test="$DealerInfoItems/DealerSearchInfo/HasCars = 'true'">Car</xsl:when>
					<xsl:when test="$DealerInfoItems/DealerSearchInfo/HasMotorcycles = 'true'">Motorcycle</xsl:when>
					<xsl:when test="$DealerInfoItems/DealerSearchInfo/HasGM = 'true'">All</xsl:when>
					<xsl:otherwise>General</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="NumberOfTabs" select="scripts:GetNumberOfTabs($DealerInfoItems/DealerSearchInfo/HasCars, $DealerInfoItems/DealerSearchInfo/HasMotorcycles, $DealerInfoItems/DealerSearchInfo/HasGM)"/>
			<!--<textarea> 
		   <xsl:value-of select="$ListingType" /> 
		  </textarea>-->
			<xsl:variable name="ListingSearchUrl" select="RESTscripts:GetListingSearchUrl($dealerID, $pageNumber, $recordsPerPage, $ListingType, 
				$category, $keywords, 'true', $condition, '', $Makes, $Models, '', $priceMin, $priceMax, $StockNumber, $sort, $Status, '', $IsRetailUser, $HasException, $ExceptionType, $MissingImage, $PendingModeration, $MissingVideo, $NoPrice)"/>
			
			<!-- Get the XML data -->
			<xsl:variable name="ListingData" select="umbraco.library:GetXmlDocumentByUrl($ListingSearchUrl, 2)" />
			<xsl:variable name="ListingDataResult" select="$ListingData/RESTStatus/Result" />
			<xsl:variable name="ListingItems" select="RESTscripts:ParseReponse($ListingDataResult)" />
			
			 <!--textarea>
				<xsl:value-of select ="$ListingItems/PagedListOfListingInfo/TotalPages"/>
			</textarea-->
			
			<!-- Check for zero results -->
			<!-- <xsl:if test="$ListingItems/PagedListOfListingInfo/TotalItems = ''
			or $ListingItems/PagedListOfListingInfo/TotalItems &lt; 1
			or count($ListingItems/PagedListOfListingInfo/Items/ListingInfo) = 0">
				<div id="easylist-no-results">
					<div class="alert alert-info">
						No Active listing to display
					</div>
				</div>
			</xsl:if> -->
 
			<!--<textarea>
  			<xsl:value-of select ="$ListingItems"/>
			</textarea>-->
			<!-- Vehicle/Non-vehicle -->
			<div class="widget-box">

				<!-- Hide it when there is zero result -->
				<!-- <xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="$ListingItems/PagedListOfListingInfo/TotalItems = ''
						or $ListingItems/PagedListOfListingInfo/TotalItems &lt; 1
						or count($ListingItems/PagedListOfListingInfo/Items/ListingInfo) = 0">
							widget-box hidden
						</xsl:when>
						<xsl:otherwise>
							widget-box
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute> -->
				
				<div class="widget-title">
					<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
						<xsl:if test="$DealerInfoItems/DealerSearchInfo/HasCars = 'true'">
							<li class="active">
								<xsl:attribute name="class">
									<xsl:if test="$ListingType = 'Car'">active</xsl:if>
								</xsl:attribute>
								<a id="VehicleTab" href="#Vehicle" data-toggle="tab">
									<i class="icon-steering-wheel">
										<xsl:text>
										</xsl:text>
									</i> Automotive
								</a>
							</li>
						</xsl:if>
						<xsl:if test="$DealerInfoItems/DealerSearchInfo/HasMotorcycles = 'true'">
							<li>
								<xsl:attribute name="class">
									<xsl:if test="$ListingType = 'Motorcycle'">active</xsl:if>
								</xsl:attribute>
								<a id="MotorTab" href="#Motor" data-toggle="tab">
									<i class="icon-motorbike">
										<xsl:text>
										</xsl:text>
									</i> Motorbikes
								</a>
							</li>
						</xsl:if>
						<xsl:if test="$NumberOfTabs > 0">
							<li>
								<xsl:attribute name="class">
									<xsl:if test="$ListingType = 'All' and $HasException != 'true'  and $PendingModeration != 'true'">active</xsl:if>
								</xsl:attribute>
								<a id="AllItemsTab" href="#AllItems" data-toggle="tab">
									<i class="icon-tags">
										<xsl:text>
										</xsl:text>
									</i> All
								</a>
							</li>
						</xsl:if>
						<xsl:if test="$IsRetailUser != 'true'">
							<li>
								<xsl:attribute name="class">
									<xsl:if test="$ListingType = 'All' and $HasException = 'true'">active</xsl:if>
								</xsl:attribute>
								<!--<a id="ExceptionItemsTab" href="#ExceptionItems" data-toggle="tab">-->
								<a id="ExceptionItemsTab" href="/listings?ListingType=All&amp;HasException=true&amp;Status=All" data-toggle="tab">
									<i class="icon-warning">
										<xsl:text>
										</xsl:text>
									</i> Exceptions
								</a>
							</li>
							<!-- <li>
								<a id="MissingPhotoTab" href="#MissingPhotos" data-toggle="tab">
									<i class="icon-photo">
										<xsl:text>
										</xsl:text>
									</i> Missing Photos
								</a>
							</li> -->
						</xsl:if>
						<xsl:if test="$IsRetailUser = 'true'">
							<li>
								<xsl:attribute name="class">
									<xsl:if test="$ListingType = 'All' and $PendingModeration = 'true'">active</xsl:if>
								</xsl:attribute>
								<a id="PendingModerationItemsTab" href="#PendingModeration" data-toggle="tab">
									<i class="icon-eye">
										<xsl:text>
										</xsl:text>
									</i> Ads Pending Review
								</a>
							</li>
							<!-- <li>
								<a id="MissingPhotoTab" href="#MissingPhotos" data-toggle="tab">
									<i class="icon-photo">
										<xsl:text>
										</xsl:text>
									</i> Missing Photos
								</a>
							</li> -->
						</xsl:if>
						<li class="pull-right hidden">
							<a href="/listings/create">
								<i class="icon-plus">
									<xsl:text>
									</xsl:text>
								</i> New Listing
							</a>
						</li>
					</ul>
				</div>
				
				<div class="tab-content widget-content no-padding">
					<div id="Vehicle" class="tab-pane active loading-container">
						
						<!-- Loaders -->
						<div id="loading-bg">
							<xsl:text>
							</xsl:text>
						</div>
						<div id="loading" style="display:none">
							<img class="retina" src="/images/spinner.png" />
						</div>
						<!-- /Loaders -->
						
						<!-- Display results -->
						<div id="EasyListDashboardListing">
							<!-- <textarea>
							<xsl:value-of select="$ListingType" />
							 </textarea> -->
							 
							 <xsl:if test="$PendingModeration != 'true'">
								 
								<!-- Result Filtering -->
								<div id="EasyListSearchFilter">
									<div class="toolbars">
										<!-- <a class="btn btn-info collapsed" data-toggle="collapse" href="#SearchFilterListing"> -->
										<a data-toggle="collapse" href="#SearchFilterListing">
											<xsl:attribute name="class">
												<xsl:choose>
													<xsl:when test="$ListingItems/PagedListOfListingInfo/TotalItems = ''
													or $ListingItems/PagedListOfListingInfo/TotalItems &lt; 1
													or count($ListingItems/PagedListOfListingInfo/Items/ListingInfo) = 0">btn btn-info active</xsl:when>
													<xsl:otherwise>btn btn-info collapsed</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<i class="icon-filter">&nbsp;</i> Search / Filter / Sort Result
										</a>
										<xsl:variable name="printUrl" select="concat('/listing-print/?dealerID=',$dealerID,'&amp;ListingType=',$ListingType,
																						'&amp;category=',$category,
																						'&amp;keywords=',$keywords,
																						'&amp;condition=',$condition,
																						'&amp;Makes=',$Makes,
																						'&amp;Models=',$Models,
																						'&amp;priceMin=',$priceMin,
																						'&amp;priceMax=',$priceMax,
																						'&amp;StockNumber=',$StockNumber,
																						'&amp;sort=',$sort,
																						'&amp;Status=',$Status,
																						'&amp;IsRetailUser=',$IsRetailUser,
																						'&amp;HasException=',$HasException,
																						'&amp;ExceptionType=',$ExceptionType,
																						'&amp;MissingImage=',$MissingImage,
																						'&amp;PendingModeration=',$PendingModeration,
																						'&amp;MissingVideo=',$MissingVideo,
																						'&amp;NoPrice=',$NoPrice,
																						'&amp;HasChildList=',$HasChildList)" />	
										
										<a class="user-help" modal-width="1000" style="float:right" href="{$printUrl}">
											Printable View
										</a>
									</div>
									
									<!-- <div id="SearchFilterListing" class="widget-collapse-options collapse" style="height: 0px;"> -->
									<div id="SearchFilterListing">
										<xsl:attribute name="class">
											<xsl:choose>
												<xsl:when test="$ListingItems/PagedListOfListingInfo/TotalItems = ''
												or $ListingItems/PagedListOfListingInfo/TotalItems &lt; 1
												or count($ListingItems/PagedListOfListingInfo/Items/ListingInfo) = 0">widget-collapse-options</xsl:when>
												<xsl:otherwise>widget-collapse-options collapse</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:attribute name="style">
											<xsl:choose>
												<xsl:when test="$ListingItems/PagedListOfListingInfo/TotalItems = ''
												or $ListingItems/PagedListOfListingInfo/TotalItems &lt; 1
												or count($ListingItems/PagedListOfListingInfo/Items/ListingInfo) = 0">height: auto;"</xsl:when>
												<xsl:otherwise>height: 0px;"</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<div class="widget-collapse-options-inner">
											
											<div class="form-horizontal">
												<xsl:if test="$IsRetailUser != 'true'">
													<xsl:value-of select="RESTscripts:GenerateCustomerChildDropdown('True')"  disable-output-escaping="yes" />
												</xsl:if>
												
												<div class="control-group">
													<label class="control-label">Keywords</label>
													<div class="controls">
														<input class="text" type="text" maxlength="100" id="Keywords" name="Keywords" />
													</div>
												</div>
												
												<div class="control-group">
													<label class="control-label">Stock Number</label>
													<div class="controls">
														<input class="text" type="text" maxlength="100" id="StockNumber" name="StockNumber" value="{$StockNumber}" />
													</div>
												</div>
												
												<div class="control-group">
													<label class="control-label">Condition</label>
													<div class="controls">
														<select class="drop-down" name="condition" id="condition">
															<xsl:call-template name="optionlist">
																<xsl:with-param name="options">All,New,Used,Demo</xsl:with-param>
																<xsl:with-param name="value">
																	<xsl:value-of select="$condition" />
																</xsl:with-param>
															</xsl:call-template>
														</select>
													</div>
												</div>
												<div class="control-group">
													<label class="control-label">Status</label>
													<div class="controls">
														<select class="drop-down" name="Status" id="Status">
															<xsl:call-template name="optionlist">
																<xsl:with-param name="options">All,Active,Draft,Sold,Cancelled,Expired,Suspended,Withdrawn</xsl:with-param>
																<xsl:with-param name="value">
																	<xsl:value-of select="$Status" />
																</xsl:with-param>
															</xsl:call-template>
														</select>
													</div>
												</div>
												<div class="control-group">
													<label class="control-label">Price range</label>
													<div class="controls">
														<input class="text" style="width:86px" type="text" maxlength="50" id="price-min" name="price-min" value="{$priceMin}" />
														&nbsp;to&nbsp;
														<input class="text" style="width:86px" type="text" maxlength="50" id="price-max" name="price-max" value="{$priceMax}" />
													</div>
												</div>
												
												<!-- <xsl:if test="$IsRetailUser != 'true'">
													<xsl:variable name="UserCatalog" select="RESTscripts:GetUserCatalog()" />
													<xsl:if test="string-length($UserCatalog) &gt; 0">
														<div class="control-group">
															<label class="control-label">Catalog</label>
															<div class="controls">
																<select class="drop-down" id="listing-catalog" name="listing-catalog">
																	<xsl:call-template name="optionlistValue">
																		<xsl:with-param name="options"><xsl:value-of select="$UserCatalog" /></xsl:with-param>
																		<xsl:with-param name="value">
																			<xsl:value-of select="$LstCatalogID" />
																		</xsl:with-param>
																	</xsl:call-template>
																</select>&nbsp;
															</div>
														</div>
													</xsl:if>
												</xsl:if> -->
												
												<xsl:if test="$ListingType = 'Car' or $ListingType = 'Motorcycle'">
												
													<div class="control-group">
														<xsl:attribute name="data-car-search">
															<xsl:choose>
																<xsl:when test="$ListingType = 'Car'">
																	<xsl:value-of select="umbraco.library:Replace($DealerInfoItems/DealerSearchInfo/CarMakeModelJson, $quot, $apos)" disable-output-escaping="yes" />
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="umbraco.library:Replace($DealerInfoItems/DealerSearchInfo/MotorcycleMakeModelJson, $quot, $apos)" disable-output-escaping="yes" />
																</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														
														<label class="control-label">Make</label>
														<div class="controls" id="MakeDiv">
															<select class="drop-down" name="Makes" id="Makes">
																<option value="Select">Any Make</option>
															</select>
														</div>
													</div>
													<div class="control-group">
														<label class="control-label">Model</label>
														<div class="controls" id="ModelDiv">
															<select class="drop-down" name="Models" id="Models">
																<option value="Select">(Select a Make)</option>
															</select>
														</div>
													</div>
												</xsl:if>
												
												
												<div class="control-group">
													<label class="control-label">Sort Result by</label>
													<div class="controls">
														<select name="sort" id="sort" class="drop-down">
															<xsl:choose>
																<xsl:when test="$ListingType = 'Car' or $ListingType = 'Motorcycle'">
																	<xsl:call-template name="optionlist">
																		<xsl:with-param name="options">Select,Title,Stock No,Rego,Condition,Category,Make/Model,Year,Price:Low to High,Price:High to Low,Edited,Published,Active</xsl:with-param>	
																		<xsl:with-param name="value">
																		</xsl:with-param>
																	</xsl:call-template>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:call-template name="optionlist">
																		<xsl:with-param name="options">Select,Title,Stock No,Condition,Category,Price:Low to High,Price:High to Low,Edited,Published,Active</xsl:with-param>
																		<xsl:with-param name="value">
																		</xsl:with-param>
																	</xsl:call-template>
																</xsl:otherwise>
															</xsl:choose>
														</select>
													</div>
												</div>
												
												<xsl:if test="$HasException = 'true'">
													<div class="control-group">
														<label class="control-label">Exception Type</label>
														<div class="controls">
															<select name="ExceptionTypeDesc" id="ExceptionTypeDesc" class="drop-down">
																<xsl:call-template name="optionlist">
																	<xsl:with-param name="options">All,Warning,Error</xsl:with-param>
																	<xsl:with-param name="value">
																	</xsl:with-param>
																</xsl:call-template>
															</select>
														</div>
													</div>
												</xsl:if>
												
												<div class="control-group">
													<label class="control-label">Missing Photos</label>
													<div class="controls">
														<label class="checkbox toggle well inline">
															<input type="checkbox" name="MissingImage" id="MissingImage" />
															<p>
																<span>Yes</span>
																<span>No</span>
															</p>
															<a class="btn slide-button">&nbsp;</a>
														</label>
													</div>
												</div>
												
												<div class="control-group">
													<label class="control-label">Missing Videos</label>
													<div class="controls">
														<label class="checkbox toggle well inline">
															<input type="checkbox" name="MissingVideo" id="MissingVideo" />
															<p>
																<span>Yes</span>
																<span>No</span>
															</p>
															<a class="btn slide-button">&nbsp;</a>
														</label>
													</div>
												</div>
												
												<div class="control-group">
													<label class="control-label">No Price</label>
													<div class="controls">
														<label class="checkbox toggle well inline">
															<input type="checkbox" name="NoPrice" id="NoPrice" />
															<p>
																<span>Yes</span>
																<span>No</span>
															</p>
															<a class="btn slide-button">&nbsp;</a>
														</label>
													</div>
												</div>
												
												<div class="control-group form-actions">
													<div class="controls">
														<a class="btn" id="ListingSearch" href="#" >Submit</a>
													</div>
												</div>
											</div>
											
										</div>
									</div>
								</div>
							
							</xsl:if>
							<div id="EasyListSearchResult">
								<!--<textarea>
								  <xsl:value-of select="$ListingSearchUrl"/>
								</textarea>-->
								<table class="footable have-default-hide clean-link" id="EasyListDashboardListingTable">
									<thead>
										<tr>
											<xsl:choose>
												<xsl:when test="$HasException = 'true'">
													<th data-class="expand" data-type="numeric" data-sort-ignore="true"  style="width:50px">Exp</th>
													<th data-class="" data-type="numeric" data-sort-ignore="true"  style="width:50px">Info</th>
												</xsl:when>
												<xsl:otherwise>
													<th data-class="expand" data-type="numeric" data-sort-ignore="true"  style="width:50px">Info</th>
												</xsl:otherwise>
											</xsl:choose>
											
											<!-- <th data-class="expand" data-type="numeric" data-sort-ignore="true"  style="width:50px">Info</th> -->
											
											<xsl:choose>
												<xsl:when test="$ListingType = 'Car'">
													<xsl:if test="$HasChildList = 'true'">
														<th data-hide="phone,tablet" data-sort-ignore="true" style="width:60px">Dealer</th>
													</xsl:if> 
													<th data-hide="phone" data-ignore="true" data-sort-ignore="true" style="width:70px">Stock #</th>
													<th data-hide="phone" data-ignore="true" data-sort-ignore="true" style="width:80px">Rego</th>
													<th data-hide="tablet,default" data-sort-ignore="true" data-ignore="true" class="double">
														<span>
															Stock#<br/>Rego
														</span>
													</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Condition</th>
													<th data-hide="phone,tablet" data-sort-ignore="true">Category</th>
													<th data-hide="phone" data-sort-ignore="true" data-ignore="true">Make</th>
													<th data-hide="phone" data-sort-ignore="true" data-ignore="true">Model</th>
													<th data-hide="tablet,default" data-sort-ignore="true" data-ignore="true" class="double">
														<span>
															Make<br />Model
														</span>
													</th>
													<th data-hide="phone" data-sort-ignore="true" data-type="numeric" style="width:50px">Year</th>
													<th data-hide="phone" data-sort-ignore="true" data-type="numeric" style="width:90px">Price</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Body</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Ext. Colour</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Edited</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Published</th>
													<th data-hide="phone" data-sort-ignore="true" style="width:80px">Status</th>
													<xsl:if test="$IsRetailUser = 'true'">
														<th data-hide="phone,tablet" data-sort-ignore="true" style="width:60px">Package</th>
													</xsl:if> 
													<!-- <xsl:if test="$IsRetailUser != 'true'">
														<th data-hide="phone" data-sort-ignore="true" style="width:60px">Dist</th>
													</xsl:if> -->
												</xsl:when>
												<xsl:when test="$ListingType = 'Motorcycle'">
													<xsl:if test="$HasChildList = 'true'">
														<th data-hide="phone,tablet" data-sort-ignore="true" style="width:60px">Dealer</th>
													</xsl:if> 
													<th data-hide="phone" data-sort-ignore="true" data-ignore="true" style="width:70px">Stock #</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Condition</th>
													<th data-hide="phone" data-sort-ignore="true" data-ignore="true">Make</th>
													<th data-hide="phone" data-sort-ignore="true" data-ignore="true">Model</th>
													<th data-hide="tablet,default" data-sort-ignore="true" data-ignore="true" class="double">
														<span>
															Make<br />Model
														</span>
													</th>
													<th data-hide="phone" data-sort-ignore="true" data-type="numeric" style="width:50px">Year</th>
													<th data-hide="phone" data-sort-ignore="true" data-type="numeric" style="width:90px">Price</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Edited</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Published</th>
													<th data-hide="phone" data-sort-ignore="true" style="width:80px">Status</th>
													<xsl:if test="$IsRetailUser = 'true'">
														<th data-hide="phone,tablet" data-sort-ignore="true" style="width:60px">Package</th>
													</xsl:if> 
													<!-- <xsl:if test="$IsRetailUser != 'true'">
														<th data-hide="phone" data-sort-ignore="true" style="width:60px">Dist</th>
													</xsl:if> -->
												</xsl:when>
												<xsl:otherwise>
													<xsl:if test="$HasChildList = 'true'">
														<th data-hide="phone,tablet" data-sort-ignore="true" style="width:60px">Dealer</th>
													</xsl:if> 
													<th data-hide="phone" data-sort-ignore="true" data-ignore="true" style="width:70px">Stock #</th>
													<th data-hide="" data-sort-ignore="true" style="text-align:left;">Title</th>
													<th data-hide="phone" data-sort-ignore="true">Condition</th>
													<th data-hide="" data-sort-ignore="true">Category</th>
													<th data-hide="" data-sort-ignore="true" data-type="numeric" style="width:90px">Price</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Edited</th>
													<th data-hide="phone,tablet" data-sort-ignore="true" style="width:80px">Published</th>
													<th data-hide="phone" data-sort-ignore="true" style="width:80px">Status</th>
													<xsl:if test="$IsRetailUser = 'true'">
														<th data-hide="phone,tablet" data-sort-ignore="true" style="width:60px">Package</th>
													</xsl:if> 
													<!-- <xsl:if test="$IsRetailUser != 'true'">
														<th data-hide="phone" data-sort-ignore="true" style="width:60px">Dist</th>
													</xsl:if> -->
												</xsl:otherwise>
											</xsl:choose>
										</tr>
									</thead>
									
									<tbody>
										
										<xsl:for-each select="$ListingItems/PagedListOfListingInfo/Items/ListingInfo">
											<xsl:call-template name="stock-item">
												<xsl:with-param name="item" select="."></xsl:with-param>
												<xsl:with-param name="ListingType"><xsl:value-of select="$ListingType" /></xsl:with-param>
											</xsl:call-template>
										</xsl:for-each>
										
									</tbody>
								</table>
								<!--<textarea>
	  <xsl:value-of select="$ListingItems/PagedListOfListingInfo/Items/ListingInfo"></xsl:value-of>
	</textarea>-->	
								<xsl:call-template name="Pagination">
									<xsl:with-param name="numberOfPages"><xsl:value-of select="$ListingItems/PagedListOfListingInfo/TotalPages"/></xsl:with-param>
									<xsl:with-param name="ListingType"><xsl:value-of select="$ListingType" /></xsl:with-param>
									<xsl:with-param name="TotalItems"><xsl:value-of select="$ListingItems/PagedListOfListingInfo/TotalItems" /></xsl:with-param>
								</xsl:call-template> 
								
								<input type="text" id="HasException" name="HasException" class="visuallyhidden" style="visibility:hidden;" value="{$HasException}"/>
							
								<xsl:if test="$ListingItems/PagedListOfListingInfo/TotalItems = ''
								or $ListingItems/PagedListOfListingInfo/TotalItems &lt; 1
								or count($ListingItems/PagedListOfListingInfo/Items/ListingInfo) = 0">
									<div id="easylist-no-results">
										<div class="alert alert-info">
											No <xsl:value-of select="$Status" /> listing to display
										</div>
									</div>
								</xsl:if>
							</div>
							</div>
							
							
						</div>
				</div>
			</div>
			
			<input type="text" id="ListingType" name="ListingType" class="visuallyhidden" style="visibility:hidden;" value="Car"/>

		</xsl:if>
		
	</xsl:template>
	<!--- end of Stock List temaplate -->
	
	<!-- Stock item LI template -->
	<xsl:template name="stock-item" match="ListingInfo">
		<xsl:param name="item"/>
		<xsl:param name="ListingType"/>
		
		<xsl:variable name="src">
			<xsl:choose>
				<xsl:when test="count($item/Images/ImageInfo/Url) > 0">
					<xsl:value-of select="$item/Images/ImageInfo/Url[1]" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'http://www.tradingpost.com.au/is-bin/intershop.static/WFS/Sensis-TradingPost-Site/-/en_AU/images/Resized/Resized330x235_no_image_available.jpg'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Cater for no-photo src -->
		<!--<xsl:variable name="imgCount" select="count($item/Images/ImageInfo)"/>-->
		
		<xsl:variable name="videoCount" select="count($item/Videos/VideoInfo)"/>
		
		<xsl:variable name="imgCount">
			<xsl:variable name="TempSrc" select="translate($src,':','')"/>
			<xsl:choose>
				<xsl:when test="contains($TempSrc, 'no-photo') or contains($TempSrc, 'no_image')">
					0
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count($item/Images/ImageInfo)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="EditLink">/listings/edit?listing=<xsl:value-of select="$item/Code" />&amp;ListingType=<xsl:value-of select="$ListingType" />&amp;HasException=<xsl:value-of select="$HasException" />&amp;page=<xsl:value-of select="$pageNumber" />
		</xsl:variable>
		<!--
		<textarea>
			<xsl:value-of select="$dealerID" />
		</textarea>
		-->
		
		<tr>
			<xsl:attribute name="data-thumbnail">
				<xsl:value-of select="scripts:getThumbnail($src)"/>
			</xsl:attribute>
			
			<xsl:if test="$HasException = 'true'">
				<td>
					<xsl:choose>
						<xsl:when test="$item/FeedInExceptionType = '1'">
							<span class="label label-warning"><i class="icon-warning"></i></span>
						</xsl:when>
						<xsl:when test="$item/FeedInExceptionType = '2'">
							<span class="label label-important"><i class="icon-close"></i></span>
						</xsl:when>
						<xsl:when test="$item/FeedInExceptionType = '3'">
							<span class="label label-warning"><i class="icon-warning">&nbsp;</i></span>&nbsp;
							<span class="label label-important"><i class="icon-close"></i></span>
						</xsl:when>
					</xsl:choose>
				</td>
			</xsl:if>
			
			<td style="">
				<span>
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="$imgCount > 5">label label-success label-image</xsl:when>
							<xsl:when test="$imgCount > 0">label label-warning label-image</xsl:when>
							<xsl:otherwise>label label-important label-image</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<i class="icon-camera-3">&nbsp;</i>
					<xsl:value-of select="$imgCount" />
				</span>
				<span>
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="$videoCount > 0">label label-success label-video</xsl:when>
							<xsl:otherwise>label label-important label-video</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<i class="icon-facetime-video">&nbsp;</i>
					<xsl:value-of select="$videoCount" />
				</span>
			</td>
			<xsl:if test="$HasChildList = 'true'">
				<td>
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/DealerName"/>
					</a>
				</td>
			</xsl:if> 
			<td>
				<a class="EditListing" href="{$EditLink}">
					<xsl:value-of select="$item/StockNumber"/>
				</a>
			</td>
			<xsl:if test="$ListingType = 'Car'">
				<td>
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/RegistrationNumber"/>
					</a>
				</td>
				<td>
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/StockNumber"/>&nbsp;<xsl:value-of select="$item/RegistrationNumber"/>
					</a>
				</td>
			</xsl:if>
			<xsl:if test="$ListingType = 'General' or $ListingType = 'All'">
				<td style="text-align:left;">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/Title" />
					</a>
				</td>
			</xsl:if>
			<td style="">
				<a class="EditListing" href="{$EditLink}">
					<xsl:value-of select="$item/Condition" />
				</a>
			</td>
			<xsl:if test="$ListingType != 'Motorcycle'">
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/Category" />
					</a>
				</td>
			</xsl:if>
			<xsl:if test="$ListingType = 'Car' or $ListingType = 'Motorcycle'">
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/Make" />
					</a>
				</td>
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/Model" />
					</a>
				</td>
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/Make" />&nbsp;<xsl:value-of select="$item/Model" />
					</a>
				</td>
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/Year" />
					</a>
				</td>
			</xsl:if>
			<td style="">
				<a class="EditListing" href="{$EditLink}">
					<xsl:value-of select="scripts:FormatPrice($item/Price)" />
					<br/>
					<xsl:value-of select="$item/PriceQualifier" />
				</a>
			</td>
			<xsl:if test="$ListingType = 'Car'">
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/BodyStyle" />
					</a>
				</td>
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/ExteriorColour" />
					</a>
				</td>
			</xsl:if>
			<td style="">
				<xsl:attribute name="data-value">
					<xsl:value-of select="$item/LastEdited" />
				</xsl:attribute>
				<a class="EditListing" href="{$EditLink}">
					<xsl:value-of select="umbraco.library:FormatDateTime($item/LastEdited, 'dd-MM-yyyy hh:mm tt')" />
				</a>
			</td>
			<td style="">
				<xsl:attribute name="data-value">
					<xsl:value-of select="$item/PublishDate" />
				</xsl:attribute>
				<a class="EditListing" href="{$EditLink}">
					<xsl:value-of select="umbraco.library:FormatDateTime($item/PublishDate, 'dd-MM-yyyy hh:mm tt')" />
				</a>
			</td>
			<td style="">
				<a class="EditListing" href="{$EditLink}">
					<!-- <xsl:value-of select="$item/Status" /> -->
					<xsl:choose>
						<xsl:when test="$item/Status = 'InStock'">Active</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$item/Status" />
						</xsl:otherwise>
					</xsl:choose>
					<!--<xsl:value-of select="$item/SubStatus" />-->
					<xsl:variable name="LstDisplaySubStatus" select="scripts:GetListingStatus($item/SubStatus)" />					
					<xsl:if test="$LstDisplaySubStatus != ''">
						<br /><xsl:value-of select="$LstDisplaySubStatus" />
					</xsl:if>
					<!--
					<xsl:choose>
						<xsl:when test="$item/SubStatus = 'InStock'"></xsl:when>
						<xsl:otherwise>
							<xsl:if test="$item/SubStatus != ''"><br/>(Pending Review)</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					-->
				</a>
			</td>
			<xsl:if test="$IsRetailUser = 'true'">
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:value-of select="$item/LstPackage" />
					</a>
				</td>
			</xsl:if>
			<!-- <td style="">
				<xsl:attribute name="data-value">
					<xsl:value-of select="$item/ListingStatusDesc" />
				</xsl:attribute>
				<a class="EditListing" href="{$EditLink}">
					<xsl:value-of select="umbraco.library:FormatDateTime($item/PublishDate, 'dd-MM-yyyy hh:mm tt')" />
				</a>
			</td> -->
			<!-- <xsl:if test="$IsRetailUser != 'true'">
				<td style="">
					<a class="EditListing" href="{$EditLink}">
						<xsl:choose>
							<xsl:when test="$item/IsHidden = 'true' or scripts:IsExpired($item/UnPublishDate)">
								<span class="label-status">Unpublished</span>
							</xsl:when>
							<xsl:otherwise>
								<span class="label-status active">Published</span>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</td>
			</xsl:if> -->
		</tr>
	</xsl:template>
	
	<!-- Meta Date Template -->
	<xsl:template name="listing-metadata">
		<xsl:param name="item" />
		<!-- Meta Data List -->
		<xsl:if test="$displayMetaData = '1'">
			<ol class="meta-data">
				
				<xsl:if test="$displayMetaCondition ='1' and $item/Condition != ''">
					<li>
						<span>Condition </span>
						<xsl:value-of select="$item/Condition" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaMakeModel ='1' and $item/Make !='' and $item/Model != ''">
					<li>
						<span>Make/Model </span>
						<xsl:value-of select="$item/Make" />&nbsp;<xsl:value-of select="$item/Model" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaYear ='1' and $item/Year != ''">
					<li>
						<span>Year </span>
						<xsl:value-of select="$item/Year" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaOdometer ='1' and $item/OdometerUnit !='' and $item/OdometerValue != ''">
					<li>
						<span>Odometer </span>
						<xsl:value-of select="$item/OdometerValue" />&nbsp;<xsl:value-of select="$item/OdometerUnit" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaRegistration ='1' and $item/RegistrationType !='' and $item/RegistrationNumber != ''">
					<li>
						<span>
							<xsl:value-of select="$item/RegistrationType" />&nbsp;
						</span>
						<xsl:value-of select="$item/RegistrationNumber" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaEngine ='1' and (($item/EngineCylinders !='' and $item/EngineSizeDescription !='') or $item/Engine != '')">
					<li class="engine">
						<span>Engine </span>
						<xsl:if test="$item/EngineCylinders !='' and $item/EngineSizeDescription !=''">
							<xsl:value-of select="$item/EngineSizeDescription" />&nbsp;<xsl:value-of select="$item/EngineCylinders" />
							<xsl:if test="$item/EnginePower !=''">
								, <xsl:value-of select="$item/EnginePower" />&nbsp;<xsl:value-of select="$item/EnginePowerUnit" />
							</xsl:if>
						</xsl:if>
						<xsl:if test="$item/Engine != ''">
							<xsl:value-of select="$item/Engine" /> cc
						</xsl:if>
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaTransmission ='1' and ($item/Transmission != '' or $item/TransmissionDescription != '')">
					<li>
						<span>Transmission </span>
						<xsl:value-of select="$item/Transmission" />
						<xsl:value-of select="$item/TransmissionDescription" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaFuelType ='1' and $item/FuelType !=''">
					<li>
						<span>Fuel Type </span>
						<xsl:value-of select="$item/FuelType" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaColour ='1' and $item/ExteriorColour !=''">
					<li>
						<span>Colour </span>
						<xsl:value-of select="$item/ExteriorColour" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaBodyStyle ='1' and $item/BodyStyle !=''">
					<li>
						<span>Body Style </span>
						<xsl:value-of select="$item/BodyStyle" />
					</li>
				</xsl:if>
				
				<xsl:if test="$displayLocation ='1'">
					<li class="location">
						<span>Location </span>
						<xsl:value-of select="$item/LocationRegion" />
						<xsl:if test="$item/LocationStateProvince != ''">
							, <xsl:value-of select="$item/LocationStateProvince" />
						</xsl:if>
						<xsl:if test="$item/LocationPostalCode != ''">
							, <xsl:value-of select="$item/LocationPostalCode" />
						</xsl:if>
					</li>
				</xsl:if>
				
				<xsl:if test="$displayMetaCategory ='1' and contains($item/CategoryPath, 'Automotive') = false">
					<li class="item-category">
						<span>Category </span>
						<a href="/for-sale/{scripts:UrlEncode($item/CategoryPath)}" class="easylist-menu">
							<xsl:value-of select="$item/Category" />
						</a>
					</li>
				</xsl:if>
				
				<xsl:if test="$displayDealerName ='1' and $item/DisplayName !=''">
					<li class="dealer-name">
						<span>Dealer </span>
						<xsl:value-of select="$item/DisplayName" />
					</li>
				</xsl:if>
				
			</ol>
		</xsl:if>
	</xsl:template>
	
	<!-- Generate Pagination Numbers Template -->
	<!-- <xsl:template name="for.loop">
		<xsl:param name="i"/>
		<xsl:param name="count"/>
		<xsl:param name="page"/>
		<xsl:if test="$i &lt;= $count">
			<li>
				<xsl:if test="$page = ($i + 1)">
					<xsl:attribute name="class">
						<xsl:value-of select="'current'"/>
					</xsl:attribute>
				</xsl:if>
				
				<a href="{scripts:GetSearchPageUrl($i, $priceMin, $priceMax, $condition, $category, $keywords, $sort)}" >
					
					<xsl:if test="$page = ($i + 1)">
						<xsl:attribute name="class">
							<xsl:value-of select="'current'"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$i" />
					
				</a>
				
			</li>
		</xsl:if>
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="for.loop">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1" />
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="page">
					<xsl:value-of select="$page"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> -->
	
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
	
	<xsl:template name="Pagination" match="Pagination">
		<!-- Add paging links -->    
		<xsl:param name="numberOfPages"/>
		<xsl:param name="ListingType"/>
		<xsl:param name="TotalItems"/>
		
		<!-- <xsl:variable name="numberOfPages" select="20" /> -->
		<!-- <xsl:variable name="pageNumber" select="$PageNo" /> -->
		
		<xsl:if test="$numberOfPages > 1">  
			
			<div id="easylist-pagination" class="pagination pagination-centered">
				<ul id="easylist-page-links">
					
					<xsl:variable name="prevPageNum" select="$pageNumber - 1" />
					<xsl:variable name="nextPageNum" select="$pageNumber + 1" />
					
					<!-- Numbered Pages -->
					<xsl:variable name="startPage">
						<xsl:choose>
							<xsl:when test="$numberOfPages &lt; 12">1</xsl:when>
							<xsl:when test="$pageNumber &lt; 7">1</xsl:when>
							<xsl:when test="$numberOfPages - $pageNumber &lt; 5">
								<xsl:value-of select="$numberOfPages -10" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$pageNumber -6" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="endPage">
						<xsl:choose>
							<xsl:when test="$numberOfPages &lt; 12">
								<xsl:value-of select="$numberOfPages" />
							</xsl:when>
							<xsl:when test="$pageNumber &lt; 7">11</xsl:when>
							<xsl:when test="$pageNumber +6 &gt; $numberOfPages">
								<xsl:value-of select="$numberOfPages" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$pageNumber +6" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:if test="$pageNumber != '1'"> 
						<li class="first-page">
							<a href="{RESTscripts:GetSearchPageUrl($ListingType, $StockNumber, 1, $priceMin, $priceMax, $condition, $keywords, $sort, $Makes, $Models, $category, $Status, $HasException, $ExceptionTypeDesc, $MissingImage, $PendingModeration, $MissingVideo, $NoPrice, $dealerID)}">
							<!-- <a href="{RESTscripts:GetListingSearchUrl($dealerID, 1, $recordsPerPage, $ListingType, 
								$category, $keywords, 'true', $condition, '', $Makes, $Models, '', $priceMin, $priceMax, $StockNumber, $sort, '')}"> -->
							<!-- <a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, 1)}"> -->
							<i class="icon-first">&nbsp;</i><span class="hidden-phone">Page 1</span></a>
						</li>
					
						<li class="prev-page">
							<a href="{RESTscripts:GetSearchPageUrl($ListingType, $StockNumber, $prevPageNum, $priceMin, $priceMax, $condition, $keywords, $sort, $Makes, $Models, $category, $Status, $HasException, $ExceptionTypeDesc, $MissingImage, $PendingModeration, $MissingVideo, $NoPrice, $dealerID)}">
							<!-- <a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $prevPageNum)}"> -->
							<i class="icon-backward">&nbsp;</i></a>
						</li>
					</xsl:if>
					
					<xsl:call-template name="for.loop">
						<xsl:with-param name="i" select="$startPage" />
						<xsl:with-param name="page" select="$pageNumber +1"></xsl:with-param>
						<xsl:with-param name="count" select="$endPage"></xsl:with-param>
						<xsl:with-param name="ListingType"><xsl:value-of select="$ListingType" /></xsl:with-param>
					</xsl:call-template> 
										
					<xsl:if test="$pageNumber &lt; $numberOfPages"> 
						<li class="next-page">
							<a href="{RESTscripts:GetSearchPageUrl($ListingType, $StockNumber, $nextPageNum, $priceMin, $priceMax, $condition, $keywords, $sort, $Makes, $Models, $category, $Status, $HasException, $ExceptionTypeDesc, $MissingImage, $PendingModeration, $MissingVideo, $NoPrice, $dealerID)}">
							<!-- <a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $nextPageNum)}"> -->
							<i class="icon-forward">&nbsp;</i></a>
						</li>
							<li class="last-page">
							<a href="{RESTscripts:GetSearchPageUrl($ListingType, $StockNumber, $numberOfPages, $priceMin, $priceMax, $condition, $keywords, $sort, $Makes, $Models, $category, $Status, $HasException, $ExceptionTypeDesc, $MissingImage, $PendingModeration, $MissingVideo, $NoPrice, $dealerID)}">
							<!-- <a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $numberOfPages)}"> -->
							<span class="hidden-phone">Page <xsl:value-of select="$numberOfPages" /></span>&nbsp;<i class="icon-last">&nbsp;</i></a>
						</li>
					</xsl:if>
				</ul>
				
				<div>Total records : <span class="badge badge-info"><xsl:value-of select="$TotalItems"/></span></div>
			</div>  
		</xsl:if>  
		
	</xsl:template >
	
	<xsl:template name="for.loop">
		<xsl:param name="i"/>
		<xsl:param name="count"/>
		<xsl:param name="page"/>
		<xsl:param name="ListingType"/>
		<!-- <textarea>
			<xsl:value-of select="$ListingType"/>
		</textarea> -->
		<xsl:if test="$i &lt;= $count">
			<li>  
				<xsl:choose>
					<xsl:when test="$page = ($i + 1)">
						<xsl:attribute name="class"><xsl:value-of select="'current'"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="($page &gt; ($i + 2)) or ($page &lt; $i)">
						<xsl:attribute name="class"><xsl:value-of select="'hidden-tablet hidden-phone'"/></xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<a href="{RESTscripts:GetSearchPageUrl($ListingType, $StockNumber, $i, $priceMin, $priceMax, $condition, $keywords, $sort, $Makes, $Models, $category, $Status, $HasException, $ExceptionTypeDesc, $MissingImage, $PendingModeration, $MissingVideo, $NoPrice, $dealerID)}">
				<!-- <a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $i)}" > -->
					<xsl:value-of select="$i" />
				</a>
			</li>
		</xsl:if>
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="for.loop">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1" />
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="page">
					<xsl:value-of select="$page"/>
				</xsl:with-param>
				<xsl:with-param name="ListingType">
					<xsl:value-of select="$ListingType"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
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
	
	<!-- END OF STOCK LISTING TEMPLATES -->
	
	
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
 
  public int GetNumberOfTabs(string HasCar, string HasMotor, string HasGM)
  {
 int NoOfTabs = 0;
  if (HasCar == "true") NoOfTabs++;
  if (HasMotor == "true") NoOfTabs++;
  if (HasGM == "true") NoOfTabs++;
  
  return NoOfTabs;
  }
 
  public bool IsExpired(DateTime UnPubDate)
  {
   bool IsExpired = true;

   if (UnPubDate > DateTime.Now)
   {
  IsExpired = false;
   }

   return IsExpired;
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