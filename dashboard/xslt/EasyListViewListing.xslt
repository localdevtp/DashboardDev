<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:scripts="urn:scripts.this"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
  exclude-result-prefixes="msxml scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="EasyListHelper.xslt" />
    
    <!-- Listing Vars -->
    <xsl:variable name="dealerID" select="umbraco.library:Session('easylist-usercode')" />
    <xsl:variable name="listingCode" select="umbraco.library:RequestQueryString('listing')"/>
	  
	  <!--
    <xsl:variable name="make" select="umbraco.library:RequestQueryString('make')"/>
    <xsl:variable name="model" select="umbraco.library:RequestQueryString('model')"/>
    <xsl:variable name="category" select="umbraco.library:RequestQueryString('cat')"/>
    <xsl:variable name="type" select="umbraco.library:RequestQueryString('type')" />
-->
    
    <xsl:variable name="usePopups">1</xsl:variable>
    <xsl:variable name="cacheDuration">
      <xsl:choose>
        <xsl:when test="/macro/cacheDuration !=''">
          <xsl:value-of select="number(/macro/cacheDuration)"/>
        </xsl:when>
        <xsl:otherwise>30</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- Display Options -->
    <xsl:variable name="relatedItemsTitle" select="/macro/relatedItemsTitle" />  
    <xsl:variable name="relatedCarsTitle" select="/macro/relatedCarsTitle" />
    <xsl:variable name="relatedMotorbikesTitle" select="/macro/relatedMotorbikesTitle" />
    <xsl:variable name="hideRetailPrice" select="/macro/hideRetailPrice" />
    <xsl:variable name="footerContentTemplate" select="/macro/footerContentTemplate" />
    <xsl:variable name="footerContentTemplateGM" select="/macro/footerContentTemplateGM" />
    
    <xsl:variable name="sentencesPerParagraph">
      <xsl:choose>
        <xsl:when test="/macro/sentencesPerParagraph !=''">
          <xsl:value-of select="/macro/sentencesPerParagraph" />
        </xsl:when>
        <xsl:otherwise>3</xsl:otherwise>
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
          <xsl:value-of select="number(0)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="maxThumbnails">
      <xsl:choose>
        <xsl:when test="/macro/maxThumbnails != ''">
          <xsl:value-of select="number(/macro/maxThumbnails)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(60)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="displayBrochure" select="/macro/displayBrochure" />
    <xsl:variable name="displaySpecs" select="/macro/displaySpecs" />
    <xsl:variable name="displayFeatures" select="/macro/displayFeatures" />
    <xsl:variable name="displayMap" select="/macro/displayMap" />
    <xsl:variable name="displayItemLocation" select="/macro/displayItemLocation" />
    <xsl:variable name="displayFinanceCalculator" select="/macro/displayFinanceCalculator" />
    <xsl:variable name="displayEmailFriend" select="/macro/displayEmailFriend" />
    <xsl:variable name="displayLightboxImages" select="/macro/displayLightboxImages" />

    <!-- Rendering Options -->
    <xsl:variable name="renderMode" select="/macro/renderMode"/> <!-- not currently used -->
    <xsl:variable name="renderingStyle" select="/macro/renderingStyle"/>
    <xsl:variable name="gmTitle" select="/macro/gmTitle"/>
    <xsl:variable name="carsTitle" select="/macro/carsTitle"/>
    <xsl:variable name="motorbikesTitle" select="/macro/motorbikesTitle"/>
    
    <!-- Display Options -->
    <xsl:variable name="displayMetaCondition" select="/macro/displayMetaCondition" />
    <xsl:variable name="displayMetaMakeModel" select="/macro/displayMetaMakeModel" />
    <xsl:variable name="displayMetaYear" select="/macro/displayMetaYear" />
    <xsl:variable name="displayMetaOdometer" select="/macro/displayMetaOdometer" />
    <xsl:variable name="displayMetaRegistration" select="/macro/displayMetaRegistration" />
    <xsl:variable name="displayMetaTransmission" select="/macro/displayMetaTransmission" />
    <xsl:variable name="displayMetaEngine" select="/macro/displayMetaEngine" />
    <xsl:variable name="displayMetaFuelType" select="/macro/displayMetaFuelType" />
    <xsl:variable name="displayMetaColour" select="/macro/displayMetaColour" />
    <xsl:variable name="displayMetaBodyStyle" select="/macro/displayMetaBodyStyle" />
    <xsl:variable name="displayMetaInteriorColour" select="/macro/displayMetaInteriorColour" />
    <xsl:variable name="displayDealerName" select="/macro/displayDealerName" />
    <xsl:variable name="displayMetaCategory" select="/macro/displayMetaCategory" />
    <xsl:variable name="displayManufacturer" select="/macro/displayManufacturer" />
    
    <!-- Image Gallery Options -->
    <xsl:variable name="imageWidth">
      <xsl:choose>
        <xsl:when test="/macro/imageWidth != ''">
          <xsl:value-of select="number(/macro/imageWidth)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(80)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="imageHeight">
      <xsl:choose>
        <xsl:when test="/macro/imageHeight!= ''">
          <xsl:value-of select="number(/macro/imageHeight)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(80)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="thumbnailWidth">
      <xsl:choose>
        <xsl:when test="/macro/thumbnailWidth!= ''">
          <xsl:value-of select="number(/macro/thumbnailWidth)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(80)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="thumbnailHeight">
      <xsl:choose>
        <xsl:when test="/macro/thumbnailHeight!= ''">
          <xsl:value-of select="number(/macro/thumbnailHeight)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number(80)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    
    <xsl:variable name="seoLocation" select="/macro/seoLocation" />

      <!-- Get the product XML -->
  <xsl:variable name="dataUrl" select="scripts:GetItemDataUrl($dealerID, $listingCode, $relatedItemsCount)" />
  <xsl:variable name="xmlData" select="umbraco.library:GetXmlDocumentByUrl($dataUrl, $cacheDuration)" />
 
<xsl:param name="currentPage"/>

<xsl:template match="/">


    <!-- -->
    <textarea style="display: none;">
    <xsl:copy-of select="$xmlData"/>
    </textarea>
 


  <xsl:choose>
    <xsl:when test="not($xmlData/ListingInfo) and not($xmlData/AutomotiveListingInfo) and not($xmlData/MotorcycleListingInfo)">
      
      
      
      <!-- Invalid ad number / No data -->

          <!--
          <xsl:variable name="redirect">/for-sale/<xsl:value-of select="$category" /></xsl:variable>
          <xsl:value-of select="scripts:Do301Redirect($redirect)" />
          -->
          
          <div id="trading-post-item-details">
            
            <xsl:value-of select="scripts:Set404Response()" />
            
            <h3>Oops, the item you were looking for was not found</h3>
            <p>The item you were looking for has most likely been sold.<br />
            However, we always have new stock coming in so please visit our <a href="/">home page</a> to see what's new!</p>
            <script type="text/javascript">
              $(document).ready(function(){$('#enquiry-form').css({visibility:'hidden'});});
            </script>
          </div>
          
        

       

        
        
    </xsl:when>
    <xsl:otherwise>
       
          <!-- Process based on Data type -->
          <xsl:choose>
            <xsl:when test="$xmlData/AutomotiveListingInfo">
              <xsl:call-template name="itemDetails">
                <xsl:with-param name="data" select="$xmlData/AutomotiveListingInfo" />
                <xsl:with-param name="relatedItemsTitle" select="$relatedCarsTitle" />
              </xsl:call-template>
            </xsl:when>
            <xsl:when test="$xmlData/MotorcycleListingInfo">
              <xsl:call-template name="itemDetails">
                <xsl:with-param name="data" select="$xmlData/MotorcycleListingInfo" />
                <xsl:with-param name="relatedItemsTitle" select="$relatedMotorbikesTitle" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="itemDetails">
                <xsl:with-param name="data" select="$xmlData/ListingInfo" />
                <xsl:with-param name="relatedItemsTitle" select="$relatedItemsTitle" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
     
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
        
    
    
    
    
    
    
<!-- Item details template -->
<xsl:template name="itemDetails">
  <xsl:param name="data" />
  <xsl:param name="relatedItemsTitle" />

  
  <!-- Get the SEO Url -->
  <xsl:variable name="itemUrl" select="scripts:GetProductUrl($data/CategoryPath, $data/Make, $data/Model, $data/UrlTitle, $data/Code)" />

	  
	<div class="box-header">
		<h2><i class="halflings-icon white list">&nbsp;</i><span class="break">&nbsp;</span><xsl:value-of select="$data/Title" /></h2>
	</div>
	
	<div class="box-content">
					
			
    
    <!-- Check for videos -->
    <xsl:variable name="hasVideo" select="count($data/Videos/VideoInfo) &gt; 0" />
    

        <xsl:choose>
			<xsl:when test="count($data/Images/ImageInfo/Url) > 0">
				
				<div class="row-fluid">
				
				<xsl:for-each select="$data/Images/ImageInfo/Url">
                    <img class="avatar medium" src="{scripts:GetImageUrl(., 80, 80)}" width="80" height="80" alt="{$data/Title}" />
                   
                </xsl:for-each>
				</div>
			  
          </xsl:when>
          
          <xsl:otherwise>
            
            <!-- Display "no image" -->
 
            
          </xsl:otherwise>
        </xsl:choose>  
  
  
  
    <!-- Add Video -->
    <xsl:if test="$hasVideo ='1'">      
      <div class="tab-content" style="background:#eee;padding:5px;">
        <xsl:for-each select="$data/Videos/VideoInfo">
          <xsl:choose>
            <xsl:when test="./VideoSource = 'DMI'">
             <!-- Insert DMI Video IFrame -->             
              <iframe style="float:left;" frameborder="0" scrolling="no" width="{$videoWidth}" height="{$videoHeight}" src="/easylist/details/dmi-video.aspx?id={$listingCode}">
                <xsl:text>
                </xsl:text>
                
               
                 <!-- Insert the Flash video player so we can get Google video results -->
                 <xsl:variable name="dmiUrl" select="umbraco.library:UrlEncode(scripts:GetDMIVideoLink(./VideoData))" />
              
                <noframes>
                  <div id="flashvideo">     
                    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                    width="{$videoWidth}"
                    height="{$videoHeight}"
                    id="Player">
                      <param name="allowScriptAccess" value="always" />
                      <param name="flashvars" value="ListingDataURL={$dmiUrl}&amp;AutoPlay=false&amp;FullScreen=true&amp;SessionModuleID=60515818&amp;LanguageID=1" />
                      <param name="wmode" value="transparent" />
                      <param name="allowFullScreen" value="true" />
                      <param name="movie" value="http://v.liquidus.net/swfs/RTPlayer.swf" />
                      <embed src="http://v.liquidus.net/swfs/RTPlayer.swf"
                        wmode="transparent" quality="high" bgcolor="#333333"
                        width="{$videoWidth}" height="{$videoHeight}" name="Player"
                        flashvars="ListingDataURL={$dmiUrl}&amp;AutoPlay=false&amp;FullScreen=true&amp;SessionModuleID=60515818&amp;LanguageID=1"
                        allowscriptaccess="always" allowfullscreen="true" type="application/x-shockwave-flash" />
                    </object>
                  </div>
                </noframes>
                
              </iframe>

            </xsl:when>
            <xsl:when test="./VideoSource = 'YouTube'">
              <xsl:variable name="trueValue">1</xsl:variable>
              <xsl:variable name="falseValue">0</xsl:variable>
              <xsl:value-of select="scripts:GetYouTubeVideoLink(./VideoData, string($videoWidth), string($videoHeight))" disable-output-escaping="yes" />
            </xsl:when>
          </xsl:choose>   
        </xsl:for-each>
        </div>
    </xsl:if>
      



    
    <!-- Specs -->
    <div class="row-fluid">
      <xsl:call-template name="listing-metadata">
        <xsl:with-param name="item" select="$data" />
      </xsl:call-template>
    </div>
    
    <!-- Product Details -->
    <div class="row-fluid">
      <meta itemprop="name" content="{$data/Title}" />
      <h3 class="segment-title">Description/Comments</h3>
      <xsl:value-of select="$data/Description" disable-output-escaping="yes" />
      
    </div>
    
    <!-- Features -->
    <xsl:if test="count($data/Features/AutomotiveFeatureInfo) &gt; 0">
      <div class="row-fluid">
        <h3 class="segment-title">Features</h3>
        <xsl:call-template name="item-features">
          <xsl:with-param name="item" select="$data" />
        </xsl:call-template>
      </div>
    </xsl:if>
    

    


    
  </div>
  
  <!-- Track the listing view in Google Analytics 
  <script type="text/javascript">
    <![CDATA[ _gaq.push(['_trackEvent', 'EasyList', 'View Listing', ']]><xsl:value-of select="$data/Code" /><![CDATA[']);]]>
  </script>-->
      
</xsl:template>


          
<!-- Meta Data Template -->
<xsl:template name="listing-metadata">
<xsl:param name="item" />
  


    <h3 class="segment-title">Details</h3>
      <ul class="meta-data">
          
         <xsl:if test="$item/Make !='' and $item/Model != ''">
           <li class="vehicle">
             <strong>Vehicle </strong>
             <xsl:value-of select="$item/Year" />&nbsp;<xsl:value-of select="$item/Make" />&nbsp;<xsl:value-of select="$item/Model" />&nbsp;<xsl:value-of select="$item/Variant" />&nbsp;<xsl:value-of select="$item/Series" />
           </li>
         </xsl:if>
          
         <xsl:if test="($item/Price != '' or $item/PriceQualifier !='')">
           <li class="price">
             <strong>Price </strong>
             <xsl:value-of select="scripts:FormatPrice($item/Price, $item/PriceQualifier, '')" />&nbsp;
              <xsl:if test="$item/WasPrice !='' and number($item/WasPrice) &gt; number($item/Price)">
                <span class="was-price" style="width: auto; margin: 0 10px 0 0;">
                  <xsl:value-of select="scripts:FormatPrice($item/WasPrice, '', '')" />
                </span>
              </xsl:if>
             
             <xsl:if test="$item/PriceQualifier != ''">
              <span class="price-info">
                <xsl:value-of select="$item/PriceQualifier"/>
              </span>
            </xsl:if>
             
           </li>
         </xsl:if>
          
         <xsl:if test="$item/Condition != ''">
           <li class="condition">
             <strong>Condition </strong>
             <xsl:value-of select="$item/Condition" />
           </li>
         </xsl:if>
          
         <xsl:if test="$item/Year != ''">
           <li class="year">
             <strong>Year </strong>
             <xsl:value-of select="$item/Year" />
           </li>
         </xsl:if>
          
          <xsl:if test="$item/OdometerUnit !='' and $item/OdometerValue != ''">
            <li class="odometer">
              <strong>Odometer </strong>
              <xsl:value-of select="$item/OdometerValue" />&nbsp;<xsl:value-of select="$item/OdometerUnit" />
            </li>
          </xsl:if>
          
          <xsl:if test="$item/RegistrationType !='' and $item/RegistrationNumber != ''">
            <li class="rego">
              <strong><xsl:value-of select="$item/RegistrationType" />&nbsp;</strong>
              <xsl:value-of select="$item/RegistrationNumber" />
            </li>
          </xsl:if>
          
          <xsl:if test="(($item/EngineCylinders !='' and $item/EngineSizeDescription !='') or $item/Engine != '')">
            <li class="engine">
              <strong>Engine </strong>
              <xsl:if test="$item/EngineCylinders !='' and $item/EngineSizeDescription !=''">
                <xsl:value-of select="$item/EngineSizeDescription" />&nbsp;<xsl:value-of select="$item/EngineCylinders" />
                <xsl:if test="$item/EnginePower !=''">
                 , <xsl:value-of select="$item/EnginePower" />&nbsp;<xsl:value-of select="$item/EnginePowerUnit" />
                </xsl:if>
              </xsl:if>
              <xsl:if test="$item/Engine != ''"><xsl:value-of select="$item/Engine" /> cc</xsl:if>
            </li>
          </xsl:if>
          
          <xsl:if test="($item/Transmission != '' or $item/TransmissionDescription != '')">
            <li class="transmission">
              <strong>Transmission </strong>
              <xsl:value-of select="$item/Transmission" /><xsl:value-of select="$item/TransmissionDescription" />
            </li>
          </xsl:if>
            
          <xsl:if test="$item/FuelType !=''">
            <li class="fuel">
              <strong>Fuel Type </strong>
              <xsl:value-of select="$item/FuelType" />           
            </li>
          </xsl:if>
          
          <xsl:if test="$item/ExteriorColour !=''">
            <li class="ext-colour">
              <strong>Colour </strong>
              <xsl:value-of select="$item/ExteriorColour" />           
            </li>
          </xsl:if>
          
          <xsl:if test="$item/InteriorColour !=''">
            <li class="int-colour">
              <strong>Interior Colour </strong>
              <xsl:value-of select="$item/InteriorColour" />           
            </li>
          </xsl:if>
          
          <xsl:if test="$item/BodyStyle !=''">
            <li class="body-style">
              <strong>Body Style </strong>
              <xsl:value-of select="$item/BodyStyle" />           
            </li>
          </xsl:if>
        
         
            <li class="item-category">
              <strong>Category </strong>

                <xsl:value-of select="$item/Category" />
            
            </li>
          
          
          
            <li class="location">
              <strong>Location </strong>
              <xsl:value-of select="$item/DealerAddress" />
            </li>
          
          
          
          
        </ul>
  
      
</xsl:template>
    
<!-- Features (options) template -->
<xsl:template name="item-features">
  <xsl:param name="item" />
  <xsl:if test="$item/Features">
    <ul class="item-features">
      <xsl:for-each select="$item/Features/AutomotiveFeatureInfo">
        <li class="{./FeatureType}">
          <xsl:value-of select="./Feature" />
        </li>
      </xsl:for-each>
    </ul>
  </xsl:if>
</xsl:template>
    
</xsl:stylesheet>