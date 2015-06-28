<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
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
	
<xsl:output method="xml" omit-xml-declaration="yes"/>
	
<xsl:include href="EasyListStaffHelper.xslt" />
<xsl:include href="EasyListRestHelper.xslt" />
		
<xsl:variable name="UserGroup" select="/macro/UserGroup" />
	
<xsl:param name="currentPage"/>

<xsl:template match="/">

	<!-- start writing XSLT -->
	<!-- start writing XSLT -->
	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized($UserGroup)" />
	<xsl:choose>
		<xsl:when test="$IsAuthorized = false">
			<xsl:value-of select="RESTscripts:RedirectTo('/403.html')" />
			
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>
	
</xsl:stylesheet>