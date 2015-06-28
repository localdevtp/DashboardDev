<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>
<xsl:variable name="files" select="/macro/files"/>
<xsl:variable name="local" select="/macro/local"/>

<xsl:template match="/">
  
<xsl:choose>
  <xsl:when test="$local ='1'">
    <!-- split the list of files and output separate tags -->
    <xsl:for-each select="umbraco.library:Split($files, ',')/value">
      <link rel="stylesheet" type="text/css" href="/css/{.}.css" />
    </xsl:for-each>
  </xsl:when>
  <xsl:otherwise>
    <!-- split the list of files and output separate tags -->
    <xsl:for-each select="umbraco.library:Split($files, ',')/value">
	  <link rel="stylesheet" type="text/css" href="https://ba46a058e90a6e4f38d4-7df3b4aac605d9dbb410f2299a4445c5.ssl.cf2.rackcdn.com/css/{.}.css" />
    </xsl:for-each>
  </xsl:otherwise>
</xsl:choose>  

</xsl:template>

</xsl:stylesheet>