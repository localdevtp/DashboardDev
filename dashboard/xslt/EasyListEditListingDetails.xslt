<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:scripts="urn:scripts.this"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:easylist="urn:http://easylist.com.au/api"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
  exclude-result-prefixes="msxml  easylist scripts umbraco.library Exslt.ExsltCommon  Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions  Exslt.ExsltStrings Exslt.ExsltSets ">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

<xsl:include href="EasyListEditItem.xslt" />

<xsl:template match="/">
  
  <xsl:variable name="userName" select="umbraco.library:Session('easylist-username')" />
  <xsl:variable name="password" select="umbraco.library:Session('easylist-password')" />
  <xsl:variable name="listingCode" select="/macro/listingCode" />
  
  <xsl:choose>
    
    <xsl:when test="string-length(umbraco.library:RequestForm('update-listing')) &gt; 0">
      <!-- Update Listing Clicked -->
      <xsl:variable name="updateResponse" select="scripts:UpdateListing()" />
      
      <!--
      <h1>Listing Updated</h1>
      <textarea>
        <xsl:copy-of select="$updateResponse" />
      </textarea>
      -->
      
        <xsl:variable name="xmlData" select="scripts:GetListingEditData($userName, $password, $listingCode)" />
        <xsl:variable name="data" select="$xmlData/*" />
      
      <xsl:call-template name="chooseEditor">
        <xsl:with-param name="data" select="$data"/>
      </xsl:call-template>
    </xsl:when>
    
    <xsl:otherwise>
      
      <xsl:variable name="xmlData" select="scripts:GetListingEditData($userName, $password, $listingCode)" />
      <xsl:variable name="data" select="$xmlData/*" />
      
      <xsl:call-template name="chooseEditor">
        <xsl:with-param name="data" select="$data"/>
      </xsl:call-template>
    </xsl:otherwise>
    
  </xsl:choose>
  
</xsl:template>
    
    
<xsl:template name="chooseEditor">
  
      <!-- Get the listing edit data and render the form -->
      <xsl:variable name="data" select="scripts:GetListingEditData($userName, $password, $listingCode)" />
      <xsl:variable name="dataType" select="name($data/*)" />
          
      <!-- Render based on data type -->
      <xsl:choose>
        <xsl:when test="$dataType ='error'">
          An error ocurred.
        </xsl:when>
        <xsl:when test="$dataType = 'MotorcycleListingEditInfo'">
          <xsl:call-template name="motorcycleDetails">
            <xsl:with-param name="data" select="$data/*" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$dataType = 'AutomotiveListingEditInfo'">
          <xsl:call-template name="autoDetails">
            <xsl:with-param name="data" select="$data/*" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gmDetails">
            <xsl:with-param name="data" select="$data/*" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
  
</xsl:template>

</xsl:stylesheet>