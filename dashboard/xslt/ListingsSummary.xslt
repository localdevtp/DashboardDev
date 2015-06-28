<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:scripts="urn:scripts.this"
	xmlns:RESTscripts="urn:RESTscripts.this" 
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:randomTools="http://www.umbraco.org/randomTools"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml randomTools scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	
	<xsl:include href="EasyListRestHelper.xslt" />
	<xsl:include href="EasyListHelper.xslt" />
	<xsl:include href="EasyListStaffHelper.xslt" />
	
	<xsl:param name="currentPage"/>
	
	<xsl:variable name="dealerID" select="umbraco.library:Session('easylist-usercodelist')" />
	<xsl:variable name="recordsPerPage">2000</xsl:variable>
	<xsl:variable name="IsRetailUser" select="AccScripts:IsRetailUser()" />
	<xsl:variable name="IsUWSupport" select="AccScripts:IsAuthorized('EasySales Admin,ESSupport')" />
	<xsl:variable name="IsUWSupportSet" select="umbraco.library:Session('easylist-IsUWSupport')" />
	<xsl:variable name="UserSearchKeyword" select="umbraco.library:Request('UserSearchKeyword')" />
	<xsl:variable name="UserSearchAdNum" select="umbraco.library:Request('UserSearchAdNum')" />
	
	<xsl:template match="/">
		
		<xsl:variable name="TestData" select="umbraco.library:GetXmlDocumentByUrl('http://services.api.easylist.com.au/mobilehelpersV3/MobileCapabilities.aspx?ua=a', 1)"/>
		<!--<xsl:variable name="TestData" select="umbraco.library:GetXmlDocumentByUrl('http://glasses.api.easylist.com.au/EasyListGlass/AllMakes', 1)"/>-->
		<!--
		<textarea>
			<xsl:value-of select="$TestData"/>
		</textarea>
		-->
		<!-- Get *all active* listings for the dealer -->
		<!-- <xsl:variable name="dataURL" select="scripts:GetAllItemsUrl($dealerID)" /> -->
		<!-- <xsl:variable name="xmlData" select="umbraco.library:GetXmlDocumentByUrl($dataURL, 5)" /> -->
		<xsl:variable name="UserGroupList" select="umbraco.library:Session('easylist-usergrouplist')" />
		<textarea style="display:none"><xsl:value-of select="$UserGroupList" /></textarea>
		<!--<xsl:variable name="IsRetailUser" select="AccScripts:IsRetailUser()" /> -->
		<!--<textarea><xsl:value-of select="$IsRetailUser" /></textarea>-->
		<!--
			<textarea style="display:none">
			 <xsl:value-of select="$dataURL" disable-output-escaping="yes" />
			</textarea>
			-->
		<!-- <xsl:variable name="activeListings" select="count($xmlData/ArrayOfListingInfo/ListingInfo)" />
			<xsl:variable name="missingImages" select="count($xmlData/ArrayOfListingInfo/ListingInfo/Images[. = ''])" />
			<xsl:variable name="missingVideos" select="count($xmlData/ArrayOfListingInfo/ListingInfo/Videos[. = ''])" />
			<xsl:variable name="noPrice" select="count($xmlData/ArrayOfListingInfo/ListingInfo/Price[. = ''])" /> -->
		<!-- Summary Counts -->
		
		<!--<xsl:variable name="ListingStatUrl" select="RESTscripts:GetListingStatUrl($dealerID)"/>
		<xsl:variable name="ListingStatData" select="umbraco.library:GetXmlDocumentByUrl($ListingStatUrl, 2)" />
		<xsl:variable name="ListingStatDataResult" select="$ListingStatData/RESTStatus/Result" />
		<xsl:variable name="ListingStat" select="RESTscripts:ParseReponse($ListingStatDataResult)" />-->

		<!--<xsl:if test="$ListingStat/ListingStatistic/TotalPendingReview > 0" >-->
			<div class="alert alert-info"  style="display:none" id = "PendingReviewMessage">
				Your have 
				<span id="TotalPendingReviewMessage">&nbsp;</span>
				ad(s) under review, and will normally be published within 4 hours, or on the next business day outside these hours. 
				<br/> Click <a href="listings?ListingType=All&amp;PendingModeration=true">here</a> to view the pending ads.
			</div>
		<!--</xsl:if>-->
		
		<div class="row">
			<!--<xsl:if test="$dealerID !='RZBW2NLP' and $dealerID !='ZV6VLGXZ,TPIPHONE'">-->
			<!--<xsl:if test="$dealerID !='RZBW2NLP'">-->
			<div class="span3">

				<!--<textarea style="font-size:11px;height:100px;">
					<xsl:value-of select="$ListingStatUrl" /><xsl:text> | </xsl:text>
					<xsl:copy-of select="$ListingStat" />
				</textarea>
				-->
				<!--Active-->
				<ul class="list-stat">
					<li>
						<!--<a href="/listings?ListingType=All&amp;Status=Active" class="list-heading-active">-->
						<a href="/listings?ListingType=All&amp;Status=Active" class="list-heading-active">
							<span class="number" id="TotalActiveListing"><b class="inline-loading"><xsl:text>
							</xsl:text></b></span>
							<span class="text">Active Ads</span>
						</a>
					</li>
					<li>
						<a href="/listings?ListingType=All&amp;Status=Active&amp;MissingImage=true">
						<span class="number" id="TotalActiveMissingPhoto"><b class="inline-loading"><xsl:text>
							</xsl:text></b></span>
						<span class="text">Missing Photos</span>
						</a>
					</li>
					<li>
						<a href="/listings?ListingType=All&amp;Status=Active&amp;MissingVideo=true">
						<span class="number" id="TotalActiveMissingVideo"><b class="inline-loading"><xsl:text>
							</xsl:text></b></span>
						<span class="text">Missing Videos</span>
						</a>
					</li>
					<li>
						<a href="/listings?ListingType=All&amp;Status=Active&amp;NoPrice=true">
						<span class="number" id="TotalActiveNoPrice"><b class="inline-loading"><xsl:text>
							</xsl:text></b></span>
						<span class="text">No Price</span>
						</a>
					</li>
					<xsl:if test="$IsRetailUser ='true'">
						<li>
							<a href="/listings?ListingType=All&amp;Status=Active&amp;PendingModeration=true">
							<span class="number" id="TotalActivePendingReview"><b class="inline-loading"><xsl:text>
							</xsl:text></b></span>
							<span class="text">Pending Review</span>
							</a>
						</li>
					</xsl:if>
				</ul>
				<!--END Active-->

				<!--Inactive-->
				<ul class="list-stat">
					<li>
						<a href="#" class="list-heading-inactive">
						<span class="number" id="TotalInActiveListing"><b class="inline-loading"><xsl:text>
							</xsl:text></b></span>
						<span class="text">Inactive Ads</span>
						</a>
					</li>
					<xsl:if test="$IsRetailUser !='true'">
						<li>
							<a>
								<xsl:attribute name="href">
									<xsl:choose>
										<xsl:when test="$IsRetailUser ='true'"><xsl:text>/listings/landing</xsl:text></xsl:when>
										<xsl:otherwise>/listings?ListingType=All&amp;Status=Draft</xsl:otherwise>			
									</xsl:choose>
								</xsl:attribute>
								<span class="number" id="TotalInActiveDraft"><b class="inline-loading"><xsl:text>
							</xsl:text></b></span>
								<span class="text">Draft</span>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="$IsRetailUser ='true'">
						<li>
							<a href="/listings?ListingType=All&amp;HasException=&amp;PendingModeration=true">
							<span class="number" id="TotalInActivePendingReview"><b class="inline-loading"><xsl:text>
							</xsl:text></b></span>
							<span class="text">Pending Review</span>
							</a>
						</li>
					</xsl:if>
				</ul>
				<!--END Inactive-->

				<!--
				<div class="widget-box">
					<div class="widget-title">
						<h2><i class="icon-stats">&nbsp;</i> Listing Stats</h2>
					</div>
					<div class="widget-content no-padding">
						<table class="table clean-link" style="margin-bottom:0">
							<tbody>
								<tr>
									<td class="center">
										<a href="/listings?ListingType=All">Total Listings</a>
									</td>
									<td style="text-align:center">
										<span class="label label-info">
											<xsl:value-of select="$ListingStat/ListingStatistic/TotalListing" />
										</span>
									</td>
								</tr>
								<tr>
									<td class="center">
										<a href="/listings?ListingType=All&amp;Status=Active">Published Listings</a>
									</td>
									<td style="text-align:center">
										<span class="label label-success">
											<xsl:value-of select="$ListingStat/ListingStatistic/TotalPublishedListing" />
										</span>
									</td>
								</tr>
								<tr>
									<td class="center">
										<a href="listings?ListingType=All&amp;PendingModeration=true">Pending Review</a>
									</td>
									<td style="text-align:center">
										<span class="label label-success">
											<xsl:value-of select="$ListingStat/ListingStatistic/TotalPendingReview" />
										</span>
									</td>
								</tr>
								<tr>
									<td class="center">
										<a href="listings?ListingType=All&amp;MissingImage=true">Missing Photos</a>
									</td>
									<td style="text-align:center">
										<span class="label label-important">
											<xsl:value-of select="$ListingStat/ListingStatistic/TotalMissingPhoto" />
										</span>
									</td>
								</tr>
								<tr>
									<td class="center">
										<a href="listings?ListingType=All&amp;MissingVideo=true">Missing Videos</a>
									</td>
									<td style="text-align:center">
										<span class="label label-important">
											<xsl:value-of select="$ListingStat/ListingStatistic/TotalMissingVideo" />
										</span>
									</td>
								</tr>
								<tr>
									<td class="center">
										<a href="listings?ListingType=All&amp;NoPrice=true">No Price</a>
									</td>
									<td style="text-align:center">
										<span class="label label-important">
											<xsl:value-of select="$ListingStat/ListingStatistic/TotalNoPrice" />
										</span>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				-->

			</div>
			<!--</xsl:if>-->
			<!-- Latest Listings -->
			<div class="span9">
				<div class="widget-box">
					<div class="widget-title">
						<h2><i class="icon-stats">&nbsp;</i> Latest Published Listings</h2>
					</div>
					<div class="widget-content no-padding" style="min-height:185px">
						<!--<xsl:variable name="dataUrl" select="scripts:GetNewestItemsDataUrl($dealerID, 8, '', '')" />
							<xsl:variable name="data" select="umbraco.library:GetXmlDocumentByUrl($dataUrl, 20)" /> 
							-->
						<!-- Get the XML data -->
						<!--<xsl:variable name="ListingSearchUrl" select="RESTscripts:GetListingSearchUrl('XQ28XYS7', 1, 8, '', '', '', '', '', '', '', '', '', '', '', '', 'age-new', '')"/>-->
						<xsl:variable name="ListingSearchUrl" select="RESTscripts:GetListingSearchUrl($dealerID, 1, 10, '', '', '', '', '', '', '', '', '', '', '', '', 'age-new', 'Active', '',$IsRetailUser)"/>
						<xsl:variable name="ListingData" select="umbraco.library:GetXmlDocumentByUrl($ListingSearchUrl, 2)" />
						<xsl:variable name="ListingDataResult" select="$ListingData/RESTStatus/Result" />
						<xsl:variable name="ListingItems" select="RESTscripts:ParseReponse($ListingDataResult)" />
						<table class="clean-link footable" style="font-size: 12px;margin-bottom:0">
							<thead>
								<tr>
									<th style="width:50px" data-class="expand">Info</th>
									<th style="width:80px">Stock #</th>
									<!-- <th>Videos</th> -->
									<!-- <th>Leads</th> -->
									<th data-hide="phone" style="text-align:left" >Title</th>
									<th data-hide="phone,tablet" style="width:100px">Category</th>
									<th data-hide="phone" style="width:80px">Price</th>
									<th style="width:85px">Published</th>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="$ListingItems/PagedListOfListingInfo/Items/ListingInfo">
									<xsl:variable name="itemUrl">
										/listings/edit?listing=
										<xsl:value-of select="./Code"/>
									</xsl:variable>
									<xsl:variable name="videoCount" select="count(./Videos/VideoInfo)"/>
									<xsl:variable name="src">
										<xsl:choose>
											<xsl:when test="count(./Images/ImageInfo/Url) > 0">
												<xsl:value-of select="./Images/ImageInfo/Url[1]" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="'http://www.tradingpost.com.au/is-bin/intershop.static/WFS/Sensis-TradingPost-Site/-/en_AU/images/Resized/Resized330x235_no_image_available.jpg'" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="imgCount">
										<xsl:variable name="TempSrc" select="translate($src,':','')"/>
										<xsl:choose>
											<xsl:when test="contains($TempSrc, 'no-photo') or contains($TempSrc, 'no_image')">
												0
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="count(./Images/ImageInfo)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<tr>
										<xsl:attribute name="data-thumbnail">
											<xsl:value-of select="scripts:getThumbnail($src)"/>
										</xsl:attribute>
										<td class="center">
											<span>
												<!-- <xsl:variable name="imgCount" select="count(./Images/ImageInfo)" /> -->
												<xsl:choose>
													<xsl:when test="$imgCount &lt; 1">
														<xsl:attribute name="class">label label-image label-important</xsl:attribute>
													</xsl:when>
													<xsl:when test="$imgCount &lt; 5">
														<xsl:attribute name="class">label label-image label-warning</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="class">label label-image label-success</xsl:attribute>
													</xsl:otherwise>
												</xsl:choose>
												<i class="icon-camera-3">&nbsp;</i>
												<xsl:value-of select="$imgCount" />
											</span>
											<span>
												<!-- <xsl:variable name="videoCount" select="count(./Images/VideoInfo)" /> -->
												<xsl:choose>
													<xsl:when test="$videoCount &lt; 1">
														<xsl:attribute name="class">label label-video label-important</xsl:attribute>
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="class">label label-video label-success</xsl:attribute>
													</xsl:otherwise>
												</xsl:choose>
												<i class="icon-facetime-video">&nbsp;</i>
												<xsl:value-of select="$videoCount" />
											</span>
										</td>
										<td>
											<a href="{$itemUrl}">
												<xsl:choose>
													<xsl:when test="./StockNumber !=''">
														<xsl:value-of select="./StockNumber" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="./RegistrationNumber" />
													</xsl:otherwise>
												</xsl:choose>
											</a>
										</td>
										<!-- <td class="center"><span class="label">
											<xsl:value-of select="randomTools:GetRandom(0,10)" />
											</span>
											</td> -->
										<td  style="text-align:left" >
											<a href="{$itemUrl}">
												<xsl:value-of select="./Title" />
											</a>
										</td>
										<td style="">
											<a href="{$itemUrl}">
												<xsl:value-of select="./Category" />
											</a>
										</td>
										<td style="">
											<a href="{$itemUrl}">
												<xsl:value-of select="scripts:FormatPrice(./Price)" />
												<br/>
												<xsl:value-of select="./PriceQualifier" />
											</a>
										</td>
										<td style="">
											<xsl:attribute name="data-value">
												<xsl:value-of select="./PublishDate" />
											</xsl:attribute>
											<a href="{$itemUrl}">
												<xsl:value-of select="umbraco.library:FormatDateTime(./PublishDate, 'dd-MM-yyyy')" />
												<br />
												<xsl:value-of select="umbraco.library:FormatDateTime(./PublishDate, 'hh:mm tt')" />
											</a>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<xsl:if test="$IsUWSupport != false or $IsUWSupportSet = 'true'">
				<div class="span12">
					<div class="widget-box">
						<div class="widget-title">
							<h2><i class="icon-support">&nbsp;</i> Support Panel (Only for listing editing)</h2>
						</div>
						<div class="widget-content no-padding">
							<xsl:variable name="LoginName" select="AccScripts:GetLoginNameByUserCode()" />
							<xsl:variable name="UserList" select="AccScripts:SupportFindUserListing()" />
							<xsl:variable name="SetUserCode" select="AccScripts:SetSupportUserCode()" />
							<!-- <textarea>
								<xsl:value-of select="$UserList"/>
								</textarea> -->
							<form id ="SupportUserSearch" method="post" class="form-horizontal">
								<br/>
								<div class="control-group ">
									<label class="control-label">You are now impersonate as</label>
									<div class="controls">
										<input class="text" type="text" maxlength="50" name="CurrentLogin" disabled="disabled" value="{$LoginName}">
										</input>
									</div>
								</div>
								<div class="control-group ">
									<label class="control-label">Search by User info</label>
									<div class="controls">
										<input class="text" type="text" maxlength="50" name="UserSearchKeyword" value="{$UserSearchKeyword}" placeholder="User Name/First Name/Email/Phone"></input>
										&nbsp;
										<button onclick="$('#SearchType').val('SearchByUser');" class="btn ignore-load save update-listing btn-success" type="submit" id="submit-search" value="Search">
										<i class="icon-search">&nbsp;</i>Search
										</button>
									</div>
								</div>
								<div class="control-group ">
									<label class="control-label">Search by Ad Number</label>
									<div class="controls">
										<input class="text" type="text" maxlength="50" name="UserSearchAdNum" value="{$UserSearchAdNum}" placeholder="Src ID/Code"></input>
										&nbsp;
										<button onclick="$('#SearchType').val('SearchByListing');" class="btn ignore-load save update-listing btn-info" type="submit" id="submit-search" value="Search">
										<i class="icon-search">&nbsp;</i>Search
										</button>
									</div>
								</div>
								<div class="widget-collapse-options">
									<xsl:text>
									</xsl:text>
								</div>
								<table class="footable footable-compact">
									<thead>
										<tr>
											<th style="text-align:left;width:100px;max-width:100px;" data-class="expand">Login Name</th>
											<th data-hide="phone">First Name</th>
											<th data-hide="phone">User Code</th>
											<th data-hide="phone">Email</th>
											<th data-hide="phone">Contact Mobile</th>
											<th data-hide="phone">User Type</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each select="$UserList/ArrayOfUsers/Users">
											<tr>
												<td style="text-align:left;width:100px;max-width:100px;" class="text-ellipsis">
													<a class="EditListing" href="javascript:void(0);" onclick="$('#NewUserCode').val('{./UserCode}'); $('#NewUserID').val('{./UserName}');$('#SupportUserSearch').submit();" title="{./UserName}">
														<xsl:value-of select="./UserName"/>
													</a>
												</td>
												<td>
													<xsl:value-of select="./DealerName"/>
												</td>
												<td>
													<xsl:value-of select="./UserCode"/>
												</td>
												<td>
													<xsl:value-of select="./Email"/>
												</td>
												<td>
													<xsl:value-of select="./DealerPhone"/>
												</td>
												<td>
													<xsl:value-of select="./UserType"/>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
								<input type="hidden" id="NewUserCode" name="NewUserCode"/>
								<input type="hidden" id="NewUserID" name="NewUserID"/>
								<input type="hidden" id="SearchType" name="SearchType"/>
							</form>
						</div>
					</div>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<msxsl:script language="c#" implements-prefix="randomTools">
		<msxsl:assembly href="../bin/umbraco.dll"/>
		<![CDATA[
			/// <summary>
			/// Gets a random integer that falls between the specified limits
			/// </summary>
			/// <param name="lowerLimit">An integer that defines the lower-boundary of the range</param>
			/// <param name="upperLimit">An integer that defines the upper-boundary of the range</param>
			/// <returns>A random integer within the specified range</returns>
			public static int GetRandom(int lowerLimit,int upperLimit) {
			 Random r = umbraco.library.GetRandom();
			 int returnedNumber = 0;
			 lock (r)
			 {
			returnedNumber = r.Next(lowerLimit, upperLimit);
			 }
			 return returnedNumber;
			}
			]]>
	</msxsl:script>
	<!-- C# helper scripts -->
	<msxml:script language="C#" implements-prefix="scripts">
		<![CDATA[
			public string getThumbnail(string s) {
			if(string.IsNullOrEmpty(s))
			  return "http://www.tradingpost.com.au/is-bin/intershop.static/WFS/Sensis-TradingPost-Site/-/en_AU/images/Resized/Resized330x235_no_image_available.jpg";
			  //return s.Replace("Resized640x480", "Resized80x80");
			  s = s.Replace("Resized1280x720", "Resized108x108");
			  return s.Replace("Resized640x480", "Resized108x108");
			}
			]]>
	</msxml:script>
</xsl:stylesheet>