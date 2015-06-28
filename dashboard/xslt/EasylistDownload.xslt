<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:RESTscripts="urn:RESTscripts.this"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml RESTscripts AccScripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="EasyListRestHelper.xslt" />
<xsl:include href="EasyListStaffHelper.xslt" />

<xsl:param name="currentPage"/>
<xsl:variable name="IsRetailUser" select="AccScripts:IsRetailUser()" />
<xsl:variable name="docBrief" select="/macro/brief" />
<xsl:variable name="docIstallation" select="/macro/installation" />
<xsl:variable name="docRequirement" select="/macro/requirement" />
<xsl:variable name="docLink" select="/macro/link" />
<xsl:variable name="docOthers" select="/macro/others" />

<xsl:template match="/">

<!-- Check if it is a commercial customer (! retail) -->
	<xsl:choose>
			<xsl:when test="$IsRetailUser">
					<div class="alert alert-error">
							<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
					</div>
			</xsl:when>
			<xsl:otherwise>
					<xsl:call-template name="LoadPage" />
			</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<xsl:template name="LoadPage">

	<div class="widget-box">

		<div class="widget-title">
			<h2><i class="icon-download-2">&nbsp;</i> <xsl:value-of select="$currentPage/pageTitle" /></h2>	
		</div>

		<div class="widget-content">
			<xsl:choose>
				<xsl:when test="umbraco.library:RequestForm('download') != 'true'">
					<xsl:call-template name="first-load" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="download-installation" />
				</xsl:otherwise>
			</xsl:choose>
		</div>

	</div>

</xsl:template>

<!-- TEMPLATE: First load page (Briefs/Requirements/DownloadLink) -->
<xsl:template name="first-load">
	<xsl:if test="$docBrief != ''">
	<div class="download-brief">
		<xsl:value-of select="$docBrief" disable-output-escaping="yes" />
	</div>
	</xsl:if>

	<xsl:if test="$docRequirement != ''">
	<div class="download-req">
			<a href="#" data-target="#systemreq" data-toggle="collapse">System requirements</a> <small style="display:inline-block;position:relative;top:-2px;margin:0 0 0 10px;">(click to reveal)</small>
			<div id="systemreq" class="collapse">
				<xsl:value-of select="$docRequirement" disable-output-escaping="yes" />
			</div>
	</div>
	</xsl:if>	

	<xsl:if test="$docOthers != ''">
	<div class="download-others">
		<xsl:value-of select="$docOthers" disable-output-escaping="yes" />
	</div>
	</xsl:if>

	<xsl:if test="$docLink != ''">
	<div class="download-link form-actions center">
		<form method="post">
			<input type='hidden' name="download" value='true' />
			<button type='submit' class="btn btn-primary">Download Now&nbsp;&nbsp;<i class="icon-download-2"><xsl:text>&nbsp;</xsl:text></i></button>
		</form>
	</div>
	</xsl:if>		
</xsl:template>
<!-- /TEMPLATE: First load page (Briefs/Requirements/DownloadLink) -->

<!-- TEMPLATE: Download and Installation -->
<xsl:template name="download-installation">
	<xsl:if test="$docIstallation != ''">
	<div class="download-installation clearfix">
		<xsl:value-of select="$docIstallation" disable-output-escaping="yes" />
	</div>
	</xsl:if>
	<xsl:if test="$docLink != ''">
		<iframe width="1" height="1" frameborder="0" src="{$docLink}"><xsl:text>
		</xsl:text></iframe>
	</xsl:if>	
</xsl:template>
<!-- /TEMPLATE: Download and Installation -->

</xsl:stylesheet>