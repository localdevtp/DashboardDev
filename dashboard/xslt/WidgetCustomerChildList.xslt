<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:AccScripts="urn:AccScripts.this"
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListStaffHelper.xslt" /> 
	
	<xsl:template name="CustomerChildList">

		<!-- start writing XSLT -->
		<xsl:variable name="CustomerChildDropdown" select="AccScripts:GetCustomerChildDropdown()" />
		<div class="control-group">
			<label class="control-label"><span class="important">*</span> Customer account</label>
			<div class="controls">
				<select class="drop-down" name="DealerUserCode">
					<xsl:call-template name="optionlistDropdownValue">
						<xsl:with-param name="options"><xsl:value-of select="$CustomerChildDropdown" /></xsl:with-param>
						<xsl:with-param name="value">
							<!-- <xsl:choose>
						  <xsl:when test="$IsPostBack = 'true'">
						   <xsl:value-of select="$LstConditionDesc" />
						  </xsl:when>
						  <xsl:otherwise>
						   <xsl:value-of select="$data/ConditionDesc" />
						  </xsl:otherwise>
							</xsl:choose> -->
						</xsl:with-param>
					</xsl:call-template>
				</select>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="optionlistDropdownValue">
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
		
		
</xsl:stylesheet>