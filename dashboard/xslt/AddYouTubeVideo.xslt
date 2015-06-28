<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:scripts="urn:scripts.this"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
  exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="YouTubeVideoLink.xslt" />
<xsl:param name="currentPage"/>

<xsl:template match="/">

  <xsl:variable name="listingCode" select="/macro/listing" />
  <xsl:variable name="youtubeUrl" select="/macro/youtubeUrl" />
  <xsl:variable name="youtubeID" select="scripts:GetVideoID($youtubeUrl)" />

    <div class="group-box">
      <div class="underlay">
        <h1><span class="videos">&nbsp;</span>Add a YouTube video
          <xsl:if test="$youtubeID != ''">
            <a href="#" class="button save" type="submit" value="Add Video" id="add-video-button">
              Add YouTube Video</a>
          </xsl:if>
        </h1>
      </div>
      
      <xsl:choose>
        <xsl:when test="$youtubeID =''">
          The link entered was not recognised as a YouTube video, please close this pop-up and try again.
        </xsl:when>
        <xsl:otherwise>
          <!-- Insert a Preview of the Video -->
          <div style="width: 100%; text-align: center">
            <xsl:value-of select="scripts:GetYouTubeVideoLink($youtubeID, '320', '240', '0', '1', '1')" disable-output-escaping="yes" />
          </div>
           
              <ul class="full">
                <xsl:call-template name="youtubeDetails">
                  <xsl:with-param name="videoID" select="$youtubeID" />
                </xsl:call-template>
              </ul>
              <input type="hidden" id="youtube-id" value="{$youtubeID}" />
         </xsl:otherwise>
        </xsl:choose>
      </div>

  
</xsl:template>
    
<xsl:template name="youtubeDetails">
  <xsl:param name="videoID" />
  <!-- https://gdata.youtube.com/feeds/api/videos/S_gG6Cgd7Fo -->
  <xsl:variable name="videoXmlUrl">https://gdata.youtube.com/feeds/api/videos/<xsl:value-of select="$videoID" /></xsl:variable>
  <xsl:variable name="videoXml" select="umbraco.library:GetXmlDocumentByUrl($videoXmlUrl, 600)" />
  
  <li>
    <label><b>Video Title</b></label>
    <input type="text" id="video-title" class="text" value="{$videoXml/*[local-name()='entry']/*[local-name()='title']}">
      <xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 100, messages: {required: 'Please enter the video title'}}</xsl:attribute>
    </input>
  </li>
  <li>
    <label><b>Description</b></label>
    <textarea id="video-description">
      <xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 2500, messages: {required: 'Please enter the video description'}}</xsl:attribute>
      <xsl:value-of select="$videoXml/*[local-name()='entry']/*[local-name()='content']" />
    </textarea>
  </li>
  
</xsl:template>
    
<!-- C# helper scripts -->
<msxml:script language="C#" implements-prefix="scripts">
<msxml:using namespace="System.Text.RegularExpressions"/>
<![CDATA[

        public string GetVideoID(string url)
        {
            string expression = @"https?:\/\/(?:www\.|m\.)?(?:youtu\.be\/|youtube\.com\S*[^\w\-\s])([\w\-]{11})(?=[^\w\-]|$)(?![?=&+%\w]*(?:[\'""][^<>]*>|<\/a>))[?=&+%\w]*";
            RegexOptions options = RegexOptions.None;
            Regex regex = new Regex(expression, options);
            foreach (Match match in regex.Matches(url))
            {
                if (match.Success)
                    return match.Groups[1].Value;
            }
            return string.Empty;
        }

]]>
</msxml:script>

</xsl:stylesheet>