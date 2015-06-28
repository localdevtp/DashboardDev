<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	
	<!-- COMMON TEMPLATES -->
	
	<!-- ALERTS -->
	<xsl:template name="alert">
		<xsl:param name="type" />
		<xsl:param name="msg" />
		<div class="alert">
			<xsl:if test="$type != ''">
				<xsl:attribute name="class">alert alert-<xsl:value-of select="$type" /></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$msg" disable-output-escaping="yes" />
		</div>
	</xsl:template>
	<!-- /ALERTS -->
	
	<!-- DROPDOWN OPTIONS TEMPLATE -->
	<!-- Helper template for list a comma-seperated list into options -->
	<!-- options: set option value + name [option1,option2...] -->
	<!-- value  : set current option as selected [string] -->
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
	<!-- /DROPDOWN OPTIONS TEMPLATE -->
	
</xsl:stylesheet>