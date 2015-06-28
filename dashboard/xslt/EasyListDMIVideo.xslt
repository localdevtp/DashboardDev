<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:msxsl="urn:schemas-microsoft-com:xslt"
xmlns:scripts="urn:scripts.this"
xmlns:RESTscripts="urn:RESTscripts.this"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
exclude-result-prefixes="msxml scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListHelper.xslt" />
	<xsl:include href="EasyListRestHelper.xslt" />
	
	<!-- Listing Vars -->
	<xsl:variable name="dealerID" select="/macro/dealerID" />
	<xsl:variable name="listingCode" select="umbraco.library:RequestQueryString('id')"/>
	
	<xsl:variable name="cacheDuration">
		<xsl:choose>
			<xsl:when test="/macro/cacheDuration !=''">
				<xsl:value-of select="number(/macro/cacheDuration)"/>
			</xsl:when>
			<xsl:otherwise>30</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Video Options -->
	<xsl:variable name="videoWidth">
		<xsl:choose>
			<xsl:when test="/macro/videoWidth != ''">
				<xsl:value-of select="number(/macro/videoWidth)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(715)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="videoHeight">
		<xsl:choose>
			<xsl:when test="/macro/videoHeight != ''">
				<xsl:value-of select="number(/macro/videoHeight)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(536)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="relatedItemsCount">
		<xsl:choose>
			<xsl:when test="/macro/relatedItemsCount != ''">
				<xsl:value-of select="number(/macro/relatedItemsCount)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(4)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		
		<!-- Get the product XML -->
		<!-- <xsl:variable name="dataUrl" select="scripts:GetItemDataUrl($dealerID, $listingCode, $relatedItemsCount)" />
		<xsl:variable name="xmlData" select="umbraco.library:GetXmlDocumentByUrl($dataUrl, $cacheDuration)" /> -->
		
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
		
		<xsl:variable name="data" select="RESTscripts:GetListingEditData($listingCode, $UserID, $UserCode, $UserSign, $UserSignDT, false)" />
		<xsl:variable name="dataType" select="name($data/*)" />
		<xsl:variable name="ListingType" select="$data/ListingsRestInfo/LstType" />
		
		
		<!-- debugging 
	<textarea>
	<xsl:copy-of select="$ListingType"/>
	</textarea> -->

	<xsl:choose>
		<!-- <xsl:when test="not($xmlData/ListingInfo) and not($xmlData/AutomotiveListingInfo) and not($xmlData/MotorcycleListingInfo)"> -->
		<xsl:when test="$dataType ='error'">
			<!-- Invalid ad number / No data -->
			
			<!-- Display the full item markup -->
			<div id="trading-post-item-details">
				<h3>Oops, the item you were looking for was not found</h3>
				<p>The item you were looking for has most likely been sold.<br />
					However, we always have new stock coming in so please visit our <a href="/">home page</a> to see what's new!</p>
			</div>
			
		</xsl:when>
		<xsl:otherwise>
			
			<!-- Process based on Data type -->
			<xsl:choose>
				<!-- <xsl:when test="$xmlData/AutomotiveListingInfo"> -->
				<xsl:when test="$ListingType = 'Car'">
					<xsl:call-template name="itemDetails">
						<!-- <xsl:with-param name="data" select="$xmlData/AutomotiveListingInfo" /> -->
						<xsl:with-param name="data" select="$data/*" />
					</xsl:call-template>
				</xsl:when>
				<!-- <xsl:when test="$xmlData/MotorcycleListingInfo"> -->
				<xsl:when test="$ListingType = 'Motorcycle'">
					<xsl:call-template name="itemDetails">
						<!-- <xsl:with-param name="data" select="$xmlData/MotorcycleListingInfo" /> -->
						<xsl:with-param name="data" select="$data/*" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="itemDetails">
						<!-- <xsl:with-param name="data" select="$xmlData/ListingInfo" /> -->
						<xsl:with-param name="data" select="$data/*" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	  
	<!-- Item details template -->
	<xsl:template name="itemDetails">
		  <xsl:param name="data" />
		
		  <!-- Check for videos -->
		  <xsl:variable name="hasVideo" select="count($data/ListingsVideoInfo/VideoEditInfo) &gt; 0" />
		  <xsl:if test="$hasVideo ='1'">      
			   
			  <xsl:for-each select="$data/ListingsVideoInfo/VideoEditInfo">
			  
<!-- 	<textarea>
		<xsl:copy-of select="./VideoData "/>
		</textarea>  -->
				  <xsl:choose>
					  <xsl:when test="./VideoSource = 'DMI'">
						  <!-- Insert DMI Video -->
						  <!--
						  <script type="text/javascript" src="https://www.dmotorworks.com.au/dmivideo/deployment/?{./VideoData}"><xsl:text>
							  </xsl:text></script>
						  -->
						   <!--
						   <textarea>
							<xsl:copy-of select="./VideoData"/>
							</textarea>  -->
						  <div id="dmivideo{position()}" class="dmi-video">
							  <span style="color:white">Loading DMI video, please wait...</span>
						  </div>
						  
						  <script type="text/javascript">
							(function(d, t) {
							var s = d.createElement(t);
							s.src = ('https:' == d.location.protocol ? 'https://' : 'http://') + 'www.dmotorworks.com.au/dmivideo/deployment/?mediaID=<xsl:value-of select="./VideoData" />';
							s.onload = s.onreadystatechange = function() {
							var rs = this.readyState; if (rs) if (rs != 'complete') if (rs != 'loaded') return;
							  try { 
							  var LTVPlayerTarget='dmivideo<xsl:value-of select="position()" />';
							  var LTVPlayerWidth=<xsl:value-of select="$videoWidth" />;
							  var LTVPlayerHeight=<xsl:value-of select="$videoHeight" />;
							  var LTVSplashScreen = '';
							  var LTVAutoPlay='';
							  dmiVideoLink(LTVPlayerTarget, LTVPlayerHeight, LTVPlayerWidth, "flash", LTVAutoPlay);
							  } catch (e) {}};
							var scr = d.getElementsByTagName(t)[0], par = scr.parentNode; par.insertBefore(s, scr);
							})(document, 'script');
						  </script>
						  
						  <!--
						  <script type="text/javascript">
							  var LTVPlayerTarget='dmivideoc';
							  var LTVPlayerWidth=<xsl:value-of select="$videoWidth" />;
							  var LTVPlayerHeight=<xsl:value-of select="$videoHeight" />;
							  var LTVSplashScreen = '';
							  var LTVAutoPlay='';
							  //DMiVideo();
						  </script>
						  -->
						  
					  </xsl:when>
					  <!--
			<xsl:when test="./VideoSource = 'YouTube'">
			  <xsl:variable name="trueValue">1</xsl:variable>
			  <xsl:variable name="falseValue">0</xsl:variable>
			  <xsl:value-of select="scripts:GetYouTubeVideoLink(./VideoData, string($videoWidth), string($videoHeight))" disable-output-escaping="yes" />
			</xsl:when>
			-->
				  </xsl:choose>
				  
			  </xsl:for-each>
			  
		  </xsl:if>
		  
		  
	  </xsl:template>
	  
	  
	  
	  
	  
	  
	  
</xsl:stylesheet>