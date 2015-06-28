<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:scripts="urn:scripts.this"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
  exclude-result-prefixes="msxml scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="html" omit-xml-declaration="yes"/>

    <xsl:variable name="videoID" select="/macro/videoID" />
    <xsl:variable name="width" select="/macro/ytWidth" />
    <xsl:variable name="height" select="/macro/ytHeight" />
    <xsl:variable name="suggestions" select="/macro/suggestions" />
    <xsl:variable name="hd" select="/macro/hd" />
    <xsl:variable name="privacy" select="/macro/privacy" />

<xsl:template match="/">

  <xsl:value-of select="scripts:GetYouTubeVideoLink($videoID, $width, $height, $suggestions, $hd, $privacy)" disable-output-escaping="yes" />
  
</xsl:template>
    
<!-- C# helper scripts -->
<msxml:script language="C#" implements-prefix="scripts">
  <msxml:using namespace="System.IO"/>
<![CDATA[

  public string GetYouTubeVideoLink(string id, string width, string height, string suggestions, string hd, string privacy)
  {
    string vars = "";
    if(suggestions != "1") vars = vars + "rel=0";
    if(hd == "1") vars = vars + (string.IsNullOrEmpty(vars) ? "hd=1" : "&amp;hd=1");
    return string.Format("<iframe width=\"{3}\" height=\"{4}\" src=\"https://www.{0}/embed/{1}?{2}\"></iframe>",
        privacy == "1" ? "youtube-nocookie.com" : "youtube.com",
        id, vars, width, height);
  }

]]>
</msxml:script>

</xsl:stylesheet>