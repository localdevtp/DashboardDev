<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:localScripts="urn:localScripts.this"
	xmlns:easylist="urn:easylist"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml localScripts easylist umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="EasyListRestHelper.xslt" />

<xsl:param name="currentPage"/>

	<!-- List of the Doc Types we'll render as a list -->
	<xsl:variable name="docTypes" select="'AdminVideo'"/>
	<xsl:variable name="vid" select="$currentPage/ancestor-or-self::*/AdminVideosPage" />

	<!-- Records per page -->
	<xsl:variable name="recordsPerPage">
		<xsl:choose>
			<xsl:when test="/macro/recordsPerPage !=''">
				<xsl:value-of select="/macro/recordsPerPage" />
			</xsl:when>
			<xsl:otherwise>10</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- render mode -->
	<xsl:variable name="render">
		<xsl:choose>
			<xsl:when test="/macro/render !=''">
				<xsl:value-of select="/macro/render" />
			</xsl:when>
			<xsl:otherwise>latest</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- latest news show more link -->
	<xsl:variable name="showmore">
		<xsl:choose>
			<xsl:when test="/macro/showmore !=''">
				<xsl:value-of select="/macro/showmore" />
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- isFeatured -->
	<xsl:variable name="isFeatured">
		<xsl:choose>
			<xsl:when test="/macro/isFeatured !=''">
				<xsl:value-of select="/macro/isFeatured" />
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

<xsl:template match="/">

		<xsl:choose>
			<xsl:when test="$render = 'latest'">
				<xsl:call-template name="latest" />
			</xsl:when>
			<xsl:when test="$render = 'single'">
				<xsl:call-template name="single" />
			</xsl:when>
		</xsl:choose>

</xsl:template>

<!-- RENDER: LATEST VIDEOS -->
<xsl:template name="latest">
		<!-- Current page number -->
		<xsl:variable name="pageNumber">
			<xsl:choose>
				<xsl:when test="umbraco.library:RequestQueryString('page') &lt;= 0 or string(umbraco.library:RequestQueryString('page')) = '' or string(umbraco.library:RequestQueryString('page')) = 'NaN'">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="umbraco.library:RequestQueryString('page')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- Count the number of child articles -->
		<xsl:variable name="numberOfRecords" select="count($vid//* [@isDoc
				and string(umbracoNaviHide) != '1'
				and contains(concat(', ', normalize-space($docTypes), ', '),concat(', ', name(), ', '))
				and (umbraco.library:IsProtected(@id, @path) = false() or umbraco.library:HasAccess(@id, @path) = true())
				and ($currentPage/@id != @id)
				and ($isFeatured != @id)
				])" />

		<ul>
		<!-- Loop through child articles -->
		<xsl:for-each select="$vid//* [@isDoc
				and string(umbracoNaviHide) != '1'
				and contains(concat(', ', normalize-space($docTypes), ', '),concat(', ', name(), ', '))
				and (umbraco.library:IsProtected(@id, @path) = false() or umbraco.library:HasAccess(@id, @path) = true())
				and ($currentPage/@id != @id)
				and ($isFeatured != @id)
				]">
				<!-- Sot by most recent publish/update date -->
				<xsl:sort select="@updateDate" order="descending" />

				<xsl:variable name="link" select="umbraco.library:NiceUrl(./@id)" />
				<xsl:variable name="videoId" select="localScripts:GetYouTube(./videoURL)" />

				<!-- Show the standard size -->
				<xsl:if test="position() &gt; $recordsPerPage * number($pageNumber) and
				position() &lt;= number($recordsPerPage * number($pageNumber) +	$recordsPerPage )">
					<!-- Render the item -->
					<li>
						<div class="video">
							<figure>
								<a href="{$link}">
									<img src="http://img.youtube.com/vi/{$videoId}/mqdefault.jpg" alt="{./pageTitle}" width="175" />
									<div class="play-icon"><img src="http://cdn.tradingpost.com.au/1.1.0.2/img/tp/play.png" width="32" height="32" /></div>
								</a>
							</figure>
							<a href="{$link}"><div class="header"><xsl:value-of select="./pageTitle" /></div></a>
							<div class="description"><xsl:value-of select="./videoDescription" disable-output-escaping="yes" /></div>
						</div>
					</li>
				</xsl:if>
		</xsl:for-each>
		</ul>

		<!-- Print out show more -->
		<xsl:if test="$showmore = 1 and $numberOfRecords &gt; $recordsPerPage">
			<xsl:variable name="newslink" select="umbraco.library:NiceUrl($vid/vidVideosPage [@isDoc]/@id)" />
			<br />
			<a href="{$newslink}" class="float-right">Show more &gt;&gt;</a>
		</xsl:if>

		<!-- Add Pagination Links -->
		<xsl:if test="$showmore = 0 and $numberOfRecords &gt; $recordsPerPage">
			<xsl:call-template name="pagination">
				<xsl:with-param name="pageNumber" select="$pageNumber"/>
				<xsl:with-param name="recordsPerPage" select="$recordsPerPage" />
				<xsl:with-param name="numberOfRecords" select="$numberOfRecords" />
			</xsl:call-template>
		</xsl:if>
</xsl:template>
<!-- /RENDER: LATEST VIDEOS -->

<!-- RENDER: SINGLE VIDEO -->
<xsl:template name="single">
	<xsl:if test="$currentPage/videoURL != ''">
		<xsl:variable name="videoId" select="localScripts:GetYouTube($currentPage/videoURL)" />
		<xsl:if test="$videoId != ''">
			<div class="hero-video">
				<iframe src="//www.youtube.com/embed/{$videoId}" frameborder="0" allowfullscreen="allowfullscreen"><xsl:text>
				</xsl:text></iframe>
			</div>
			<div class="description"><xsl:value-of select="$currentPage/videoDescription" disable-output-escaping="yes" /></div>
		</xsl:if>
	</xsl:if>
</xsl:template>
<!-- /RENDER: SINGLE VIDEO -->

<!-- PAGINATION TEMPLATE -->
<xsl:template name="pagination">
	<xsl:param name="pageNumber"/>
	<xsl:param name="recordsPerPage"/>
	<xsl:param name="numberOfRecords"/>

	<div class="paging">

		<!--
		<xsl:if test="$pageNumber &gt; 0">
			<a href="?page={$pageNumber -1}" class="prev">Prev</a>
		</xsl:if>
		-->

		<xsl:call-template name="for.loop">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="page" select="$pageNumber +1"></xsl:with-param>
			<xsl:with-param name="count" select="ceiling($numberOfRecords div $recordsPerPage)"></xsl:with-param>
		</xsl:call-template>

		<!--
		<xsl:if test="(($pageNumber +1 ) * $recordsPerPage) &lt; ($numberOfRecords)">
			<a href="?page={$pageNumber +1}" class="next">Next</a>
		</xsl:if>
		-->

	<xsl:text>
		</xsl:text>
	</div>

</xsl:template>

<xsl:template name="for.loop">
	<xsl:param name="i"/>
	<xsl:param name="count"/>
	<xsl:param name="page"/>
	<xsl:if test="$i &lt;= $count">

		<xsl:if test="$page != $i">
			<a href="{umbraco.library:NiceUrl($currentPage/@id)}?page={$i - 1}" >
				<xsl:value-of select="$i" />
			</a>
		</xsl:if>
		<xsl:if test="$page = $i">
			<a class="active" href="{umbraco.library:NiceUrl($currentPage/@id)}?page={$i - 1}" >
				<xsl:value-of select="$i" />
			</a>
		</xsl:if>
		<xsl:if test="$i &lt; $count">&nbsp;|&nbsp;</xsl:if>

	</xsl:if>

	<xsl:if test="$i &lt;= $count">
		<xsl:call-template name="for.loop">
			<xsl:with-param name="i">
				<xsl:value-of select="$i + 1"/>
			</xsl:with-param>
			<xsl:with-param name="count">
				<xsl:value-of select="$count"/>
			</xsl:with-param>

			<xsl:with-param name="page">
				<xsl:value-of select="$page"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
<!-- /PAGINATION TEMPLATE -->

<!-- C# helper scripts -->
<msxml:script language="C#" implements-prefix="localScripts">
<msxml:assembly name="System.Core"/>
<msxml:using namespace="System.Text"/>
<msxml:using namespace="System.Linq"/>
<![CDATA[

public string GetYouTube(string url)
{
	Match m;
	String v;
	if(Regex.IsMatch(url,@"youtube\.com\/watch\?v=([^\&\?\/]+)", RegexOptions.IgnoreCase)) {
		m = Regex.Match(url, @"youtube\.com\/watch\?v=([^\&\?\/]+)");
		v = m.Groups[1].Value;
	} else if(Regex.IsMatch(url,@"youtube\.com\/embed\/([^\&\?\/]+)", RegexOptions.IgnoreCase)) {
		m = Regex.Match(url, @"youtube\.com\/embed\/([^\&\?\/]+)");
		v = m.Groups[1].Value;
	} else if(Regex.IsMatch(url,@"youtu\.be\/([^\&\?\/]+)", RegexOptions.IgnoreCase)) {
		m = Regex.Match(url, @"youtu\.be\/([^\&\?\/]+)");
		v = m.Groups[1].Value;
	} else {
		return "";
	}

	return v;
}

]]>
</msxml:script>

</xsl:stylesheet>