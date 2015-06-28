<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
    xmlns:RESTscripts="urn:RESTscripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="EasyListRestHelper.xslt" />

<xsl:param name="currentPage"/>

<xsl:template match="/">

<!-- start writing XSLT -->
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('IsPostBack') = 'true'" />
	
	<xsl:variable name="LstUserCode" select="umbraco.library:Request('listing-usercode')" />
	<xsl:variable name="LstCatalogID" select="umbraco.library:Request('listing-catalog')" />

	<xsl:variable name="SelectedUserCode">
		<xsl:if test="$IsPostBack = 'true'">
			<xsl:value-of select="$LstUserCode" />
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="SelectedUserCatalog">
		<xsl:if test="$IsPostBack = 'true'">
			<xsl:value-of select="$LstCatalogID" />
		</xsl:if>
	</xsl:variable>
	
	<!-- <xsl:value-of select="RESTscripts:GetUserCatalogListWithFeedInTemplateList($SelectedUserCode, $SelectedUserCatalog)"  disable-output-escaping="yes" /> -->
	
	<xsl:value-of select="RESTscripts:GetUserCatalogListWithFeedInTemplateListParentChild($SelectedUserCode, $SelectedUserCatalog, 1)"  disable-output-escaping="yes" />
</xsl:template>

</xsl:stylesheet>