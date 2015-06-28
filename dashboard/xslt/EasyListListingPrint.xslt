<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
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
	<!--xsl:include href="EasyListStaffHelper.xslt" /-->
	<!--variables-->
	
	<xsl:variable name="dealerID" select="umbraco.library:RequestQueryString('dealerID')" />
	<xsl:variable name="ListingType" select="umbraco.library:RequestQueryString('ListingType')" />
	<xsl:variable name="category" select="umbraco.library:RequestQueryString('category')" />
	<xsl:variable name="keywords" select="umbraco.library:RequestQueryString('keywords')" />
	<xsl:variable name="condition" select="umbraco.library:RequestQueryString('condition')" />
	<xsl:variable name="Makes" select="umbraco.library:RequestQueryString('Makes')" />
	<xsl:variable name="Models" select="umbraco.library:RequestQueryString('Models')" />
	<xsl:variable name="priceMin" select="umbraco.library:RequestQueryString('priceMin')" />
	<xsl:variable name="priceMax" select="umbraco.library:RequestQueryString('priceMax')" />
	<xsl:variable name="StockNumber" select="umbraco.library:RequestQueryString('StockNumber')" />
	<xsl:variable name="sort" select="umbraco.library:RequestQueryString('sort')" />
	<xsl:variable name="Status" select="umbraco.library:RequestQueryString('Status')" />
	<xsl:variable name="IsRetailUser" select="umbraco.library:RequestQueryString('IsRetailUser')" />
	<xsl:variable name="HasException" select="umbraco.library:RequestQueryString('HasException')" />
	<xsl:variable name="ExceptionType" select="umbraco.library:RequestQueryString('ExceptionType')" />
	<xsl:variable name="MissingImage" select="umbraco.library:RequestQueryString('MissingImage')" />
	<xsl:variable name="PendingModeration" select="umbraco.library:RequestQueryString('PendingModeration')" />
	<xsl:variable name="MissingVideo" select="umbraco.library:RequestQueryString('MissingVideo')" />
	<xsl:variable name="NoPrice" select="umbraco.library:RequestQueryString('NoPrice')" />
	<xsl:variable name="HasChildList" select="umbraco.library:RequestQueryString('HasChildList')" />
	
	<xsl:variable name="ListingSearchUrl" select="RESTscripts:GetListingSearchUrl($dealerID, 0, 1000, $ListingType, 
				$category, $keywords, 'true', $condition, '', $Makes, $Models, '', $priceMin, $priceMax, $StockNumber, $sort, $Status, '', $IsRetailUser, $HasException, $ExceptionType, $MissingImage, $PendingModeration, $MissingVideo, $NoPrice)"/>
	<xsl:variable name="ListingData" select="umbraco.library:GetXmlDocumentByUrl($ListingSearchUrl, 2)" />
	<xsl:variable name="ListingDataResult" select="$ListingData/RESTStatus/Result" />
	<xsl:variable name="ListingItems" select="RESTscripts:ParseReponse($ListingDataResult)" />
<xsl:param name="currentPage"/>

<xsl:template match="/">
<!--textarea>
	<xsl:value-of select ="$ListingItems/PagedListOfListingInfo/TotalPages"/>
</textarea-->
<!-- start writing XSLT -->
<table border="1" style="width:100%">
	<thead>
		<tr style="font-weight:bold">
			<xsl:choose>
				<xsl:when test="$ListingType = 'Car'">
					<xsl:if test="$HasChildList = 'true'">
						<td>Dealer</td>
					</xsl:if> 
					<td>Stock #</td>
					<td>Rego</td>
					<!--th data-hide="tablet,default" data-sort-ignore="true" data-ignore="true" class="double">
						<span>
							Stock#<br/>Rego
						</span>
					</th-->
					<td>Condition</td>
					<td>Category</td>
					<td>Make</td>
					<td>Model</td>
					<td>
						<span>
							Make<br />Model
						</span>
					</td>
					<td>Year</td>
					<td>Price</td>
					<td>Body</td>
					<td>Ext. Colour</td>
					<td>Edited</td>
					<td>Published</td>
					<td>Status</td>
					<xsl:if test="$IsRetailUser = 'true'">
						<td>Package</td>
					</xsl:if> 
				</xsl:when>
				<xsl:when test="$ListingType = 'Motorcycle'">
					<xsl:if test="$HasChildList = 'true'">
						<td>Dealer</td>
					</xsl:if> 
					<td>Stock #</td>
					<td>Condition</td>
					<td>Make</td>
					<td>Model</td>
					<td>
						<span>
							Make<br />Model
						</span>
					</td>
					<td>Year</td>
					<td>Price</td>
					<td>Edited</td>
					<td>Published</td>
					<td>Status</td>
					<xsl:if test="$IsRetailUser = 'true'">
						<td>Package</td>
					</xsl:if> 
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$HasChildList = 'true'">
						<td>Dealer</td>
					</xsl:if> 
					<td>Stock #</td>
					<td>Title</td>
					<td>Condition</td>
					<td>Category</td>
					<td>Price</td>
					<td>Edited</td>
					<td>Published</td>
					<td>Status</td>
					<xsl:if test="$IsRetailUser = 'true'">
						<td>Package</td>
					</xsl:if> 
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
</xsl:template>

<xsl:template name="stock-item" match="ListingInfo">
	<xsl:param name="item"/>
	<xsl:param name="ListingType"/>
	<tr>
		<xsl:if test="$HasChildList = 'true'">
			<td>
				<xsl:value-of select="$item/DealerName"/>
			</td>
		</xsl:if>
			<td>
				<xsl:value-of select="$item/StockNumber"/>
			</td>		
		<xsl:if test="$ListingType = 'Car'">
			<td>			
				<xsl:value-of select="$item/RegistrationNumber"/>
			</td>
		</xsl:if>		
		<xsl:if test="$ListingType = 'General' or $ListingType = 'All'">
			<td style="text-align:left;">
				<xsl:value-of select="$item/Title" />
			</td>
		</xsl:if>
		<td>
			<xsl:value-of select="$item/Condition" />
		</td>
		<xsl:if test="$ListingType != 'Motorcycle'">
			<td>
				<xsl:value-of select="$item/Category" />
			</td>
		</xsl:if>
		<xsl:if test="$ListingType = 'Car' or $ListingType = 'Motorcycle'">
			<td>
				<xsl:value-of select="$item/Make" />
			</td>
			<td>
				<xsl:value-of select="$item/Model" />
			</td>
			<td>
				<xsl:value-of select="$item/Make" />&nbsp;<xsl:value-of select="$item/Model" />
			</td>
			<td>
				<xsl:value-of select="$item/Year" />
			</td>
		</xsl:if>
		<td>
			<xsl:value-of select="scripts:FormatPrice($item/Price)" />
			<br/>
			<xsl:value-of select="$item/PriceQualifier" />
		</td>
		<xsl:if test="$ListingType = 'Car'">
			<td>
				<xsl:value-of select="$item/BodyStyle" />
			</td>
			<td>
				<xsl:value-of select="$item/ExteriorColour" />
			</td>
		</xsl:if>
		<td>
			<xsl:attribute name="data-value">
				<xsl:value-of select="$item/LastEdited" />
			</xsl:attribute>
			<xsl:value-of select="umbraco.library:FormatDateTime($item/LastEdited, 'dd-MM-yyyy hh:mm tt')" />
		</td>
		<td>
			<xsl:attribute name="data-value">
				<xsl:value-of select="$item/PublishDate" />
			</xsl:attribute>
			<xsl:value-of select="umbraco.library:FormatDateTime($item/PublishDate, 'dd-MM-yyyy hh:mm tt')" />
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="$item/Status = 'InStock'">Active</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$item/Status" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:variable name="LstDisplaySubStatus" select="scripts:GetListingStatus($item/SubStatus)" />					
			<xsl:if test="$LstDisplaySubStatus != ''">
				<br /><xsl:value-of select="$LstDisplaySubStatus" />
			</xsl:if>
		</td>
	</tr>
</xsl:template>
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


]]>
</msxml:script>
</xsl:stylesheet>