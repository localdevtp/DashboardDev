<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  	xmlns:scripts="urn:scripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml msxsl scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

	<xsl:include href="EasyListHelper.xslt" />
		
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
  	<xsl:variable name="userName" select="umbraco.library:Session('easylist-username')" />
  	<xsl:variable name="password" select="umbraco.library:Session('easylist-password')" />
	<xsl:variable name="recordsPerPage">2000</xsl:variable>
		<xsl:variable name="dealerID" />
		
<xsl:param name="currentPage"/>

<xsl:template match="/">

	<!--
		<xsl:variable name="VehicleSearchUrl" select="scripts:GetCarSearchUrl($dealerID, '1', $recordsPerPage,
							'', '','','','', '', '','','','', '','', '', '', '', '1', '')"/>
		<xsl:variable name="GMSearchUrl" select="scripts:GetGMSearchUrl($dealerID, '1', $recordsPerPage, '', '', 
					 '', '', '', '', '', '')"/>
			
    
        <xsl:variable name="VehicleData" select="umbraco.library:GetXmlDocumentByUrl($VehicleSearchUrl, 2)" />    
		<xsl:variable name="GMData" select="umbraco.library:GetXmlDocumentByUrl($GMSearchUrl, 2)" />    
      -->
	

	<div class="center" style="text-align: center;">					
		<ul class="stat-boxes">
			<li>
				<div class="left peity_bar_good"><span>2,4,9,7,12,10</span>+20%</div>
				<div class="right">
					<strong>6,094</strong>
					Listing Views
				</div>
			</li>
			<li>
				<div class="left peity_bar_neutral"><span>9,7,10,12,15,18</span>+53%</div>
				<div class="right">
					<strong>295</strong>
					Incoming Leads
				</div>
			</li>
			<li>
				<div class="left peity_bar_bad"><span>3,5,9,7,12,20,10</span>+3%</div>
				<div class="right">
					<strong>176</strong>
					Sales
				</div>
			</li>
			<li>
				<div class="left peity_pie"><span>12/48</span>25%</div>
				<div class="right">
					<strong>12</strong>
					Missing Photos
				</div>
			</li>
		</ul>
	</div>	

</xsl:template>

</xsl:stylesheet>