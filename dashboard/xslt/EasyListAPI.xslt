<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:scripts="urn:scripts.this"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
  exclude-result-prefixes="msxml scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:variable name="api" select="umbraco.library:RequestQueryString('api')" />
<xsl:variable name="ContentType" >
	<xsl:choose>
		<xsl:when test="umbraco.library:RequestQueryString('ContentType') !=''" >
			<xsl:value-of select="umbraco.library:RequestQueryString('ContentType')" />
		</xsl:when>
		<xsl:otherwise>application/json</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="GeneralAPIurl">http://general.api.easylist.com.au</xsl:variable>
<xsl:variable name="SearchAPIurl">http://search.api.easylist.com.au</xsl:variable>
<xsl:variable name="GlassesAPIurl">http://glasses.api.easylist.com.au</xsl:variable>
	  
<xsl:template match="/">

	<xsl:variable name="dataUrl">
		<xsl:choose>
			<!-- Image Manipulation -->
			<xsl:when test="$api='ImageToRotate'"><xsl:value-of select="$GeneralAPIurl" />/Listing/ImageToRotate?id=<xsl:value-of select="umbraco.library:RequestQueryString('id')"/>&amp;imgFileName=<xsl:value-of select="umbraco.library:RequestQueryString('imgFileName')"/>&amp;imgRotation=<xsl:value-of select="umbraco.library:RequestQueryString('imgRotation')"/></xsl:when>
			<xsl:when test="$api='NewImageToRotate'"><xsl:value-of select="$GeneralAPIurl" />/ListingTemp/ImageToRotate?UserCode=<xsl:value-of select="umbraco.library:RequestQueryString('UserCode')"/>&amp;UserTempKey=<xsl:value-of select="umbraco.library:RequestQueryString('UserTempKey')"/>&amp;ImgCode=<xsl:value-of select="umbraco.library:RequestQueryString('ImgCode')"/>&amp;imgRotation=<xsl:value-of select="umbraco.library:RequestQueryString('imgRotation')"/></xsl:when>
			
			<!-- Category -->
			<xsl:when test="$api='RootCategory'"><xsl:value-of select="$GeneralAPIurl" />/Category/rootlevelHTML</xsl:when>
			<xsl:when test="$api='CatInfo'"><xsl:value-of select="$GeneralAPIurl" />/Category/CatInfo?CatID=<xsl:value-of select="umbraco.library:RequestQueryString('CatID')"/></xsl:when>
			<xsl:when test="$api='CatUI'"><xsl:value-of select="$GeneralAPIurl" />/Category/CatUI?CatID=<xsl:value-of select="umbraco.library:RequestQueryString('CatID')"/>&amp;Mode=<xsl:value-of select="umbraco.library:RequestQueryString('Mode')"/></xsl:when>
			<xsl:when test="$api='SubLevelHTML'"><xsl:value-of select="$GeneralAPIurl" />/Category/SubLevelHTML?ParentCatID=<xsl:value-of select="umbraco.library:RequestQueryString('ParentCatID')"/></xsl:when>
			
			<!-- Listing temp -->
			<xsl:when test="$api='ListingTempLoad'"><xsl:value-of select="$GeneralAPIurl" />/ListingTemp/Image/<xsl:value-of select="umbraco.library:RequestQueryString('UserCode')"/>/<xsl:value-of select="umbraco.library:RequestQueryString('UserTempKey')"/>?ImageOrder=<xsl:value-of select="umbraco.library:RequestQueryString('ImageOrder')"/></xsl:when>
			<xsl:when test="$api='ListingTempDel'"><xsl:value-of select="$GeneralAPIurl" />/ListingTemp/Image/<xsl:value-of select="umbraco.library:RequestQueryString('UserCode')"/>/<xsl:value-of select="umbraco.library:RequestQueryString('UserTempKey')"/>/<xsl:value-of select="umbraco.library:RequestQueryString('ImgCode')"/></xsl:when>
			
			<!-- Listing -->
			<xsl:when test="$api='ListingStat'"><xsl:value-of select="$GeneralAPIurl" />/Listing/ListingStatV3?DealerIDs=<xsl:value-of select="scripts:GetUserCode()" /></xsl:when>
			
			<!-- Location -->
			<xsl:when test="$api='LocSearch'"><xsl:value-of select="$SearchAPIurl" />/Location/Search?query=<xsl:value-of select="umbraco.library:RequestQueryString('query')"/></xsl:when>
			<xsl:when test="$api='LocInfo'"><xsl:value-of select="$SearchAPIurl" />/Location/LocInfo?Location=<xsl:value-of select="umbraco.library:RequestQueryString('Location')"/></xsl:when>
			
			<!-- EL Customers-->
			<xsl:when test="$api='ELCustomers'"><xsl:value-of select="$SearchAPIurl" />/ELCustomers/Search?query=<xsl:value-of select="umbraco.library:RequestQueryString('query')"/></xsl:when>
		
			<!-- Glasses - Automotive -->
			<xsl:when test="$api='AllMakes'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/AllMakes</xsl:when>
			<xsl:when test="$api='Info'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/Info?Type=<xsl:value-of select="umbraco.library:RequestQueryString('Type')"/>&amp;Make=<xsl:value-of select="umbraco.library:RequestQueryString('Make')"/>&amp;Model=<xsl:value-of select="umbraco.library:RequestQueryString('Model')"/>&amp;Year=<xsl:value-of select="scripts:ParseToInt(umbraco.library:RequestQueryString('Year'))"/>&amp;Series=<xsl:value-of select="umbraco.library:RequestQueryString('Series')"/>&amp;Style=<xsl:value-of select="umbraco.library:RequestQueryString('Style')"/>&amp;Transmission=<xsl:value-of select="umbraco.library:RequestQueryString('Transmission')"/></xsl:when>
			<xsl:when test="$api='MatchingVehicle'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/MatchingVehicle?Make=<xsl:value-of select="umbraco.library:RequestQueryString('Make')"/>&amp;Model=<xsl:value-of select="umbraco.library:RequestQueryString('Model')"/>&amp;Year=<xsl:value-of select="scripts:ParseToInt(umbraco.library:RequestQueryString('Year'))"/>&amp;Style=<xsl:value-of select="umbraco.library:RequestQueryString('Style')"/>&amp;Transmission=<xsl:value-of select="umbraco.library:RequestQueryString('Transmission')"/></xsl:when>
			<xsl:when test="$api='MatchingVehicleFeatures'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/MatchingVehicleFeatures?GlassCode=<xsl:value-of select="umbraco.library:RequestQueryString('GlassCode')"/>&amp;Make=<xsl:value-of select="umbraco.library:RequestQueryString('Make')"/>&amp;Model=<xsl:value-of select="umbraco.library:RequestQueryString('Model')"/>&amp;Year=<xsl:value-of select="scripts:ParseToInt(umbraco.library:RequestQueryString('Year'))"/>&amp;Style=<xsl:value-of select="umbraco.library:RequestQueryString('Style')"/>&amp;Transmission=<xsl:value-of select="umbraco.library:RequestQueryString('Transmission')"/>&amp;Variant=<xsl:value-of select="umbraco.library:RequestQueryString('Variant')"/>&amp;Series=<xsl:value-of select="umbraco.library:RequestQueryString('Series')"/>&amp;Cylinder=<xsl:value-of select="umbraco.library:RequestQueryString('Cylinder')"/>&amp;Engine=<xsl:value-of select="umbraco.library:RequestQueryString('Engine')"/>"/></xsl:when>
			<xsl:when test="$api='EditGlassInfoHTML'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/EditGlassInfoHTML?Make=<xsl:value-of select="umbraco.library:RequestQueryString('Make')"/>&amp;Model=<xsl:value-of select="umbraco.library:RequestQueryString('Model')"/>&amp;Year=<xsl:value-of select="scripts:ParseToInt(umbraco.library:RequestQueryString('Year'))"/>&amp;Style=<xsl:value-of select="umbraco.library:RequestQueryString('Style')"/>&amp;Transmission=<xsl:value-of select="umbraco.library:RequestQueryString('Transmission')"/>&amp;Variant=<xsl:value-of select="umbraco.library:RequestQueryString('Variant')"/></xsl:when>
			<xsl:when test="$api='EditGlassMotorInfoHTML'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/EditGlassMotorInfoHTML?Make=<xsl:value-of select="umbraco.library:RequestQueryString('Make')"/>&amp;Model=<xsl:value-of select="umbraco.library:RequestQueryString('Model')"/>&amp;Year=<xsl:value-of select="scripts:ParseToInt(umbraco.library:RequestQueryString('Year'))"/>&amp;Style=<xsl:value-of select="umbraco.library:RequestQueryString('Style')"/>&amp;Transmission=<xsl:value-of select="umbraco.library:RequestQueryString('Transmission')"/>&amp;Variant=<xsl:value-of select="umbraco.library:RequestQueryString('Variant')"/></xsl:when>

			
			<!-- Glasses - Motors -->
			<xsl:when test="$api='AllMotorMakes'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/AllMotorMakes</xsl:when>
			<xsl:when test="$api='MotorInfo'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/MotorInfo?Type=<xsl:value-of select="umbraco.library:RequestQueryString('Type')"/>&amp;Make=<xsl:value-of select="umbraco.library:RequestQueryString('Make')"/>&amp;Model=<xsl:value-of select="umbraco.library:RequestQueryString('Model')"/>&amp;Year=<xsl:value-of select="scripts:ParseToInt(umbraco.library:RequestQueryString('Year'))"/>&amp;Series=<xsl:value-of select="umbraco.library:RequestQueryString('Series')"/>&amp;Style=<xsl:value-of select="umbraco.library:RequestQueryString('Style')"/>&amp;Transmission=<xsl:value-of select="umbraco.library:RequestQueryString('Transmission')"/></xsl:when>
			<xsl:when test="$api='MatchingMotor'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/MatchingMotor?Make=<xsl:value-of select="umbraco.library:RequestQueryString('Make')"/>&amp;Model=<xsl:value-of select="umbraco.library:RequestQueryString('Model')"/>&amp;Year=<xsl:value-of select="scripts:ParseToInt(umbraco.library:RequestQueryString('Year'))"/>&amp;Style=<xsl:value-of select="umbraco.library:RequestQueryString('Style')"/>&amp;Transmission=<xsl:value-of select="umbraco.library:RequestQueryString('Transmission')"/></xsl:when>
			<xsl:when test="$api='MatchingMotorFeatures'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/MatchingMotorFeatures?GlassCode=<xsl:value-of select="umbraco.library:RequestQueryString('GlassCode')"/></xsl:when>
			
			<!-- Glasses - Custom Models -->
			<xsl:when test="$api='AllCustomMakes'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/AllCustomMakes?Type=<xsl:value-of select="umbraco.library:RequestQueryString('Type')"/></xsl:when>
			<xsl:when test="$api='CustomModels'"><xsl:value-of select="$GlassesAPIurl" />/EasyListGlass/CustomModels?Type=<xsl:value-of select="umbraco.library:RequestQueryString('Type')"/>&amp;Make=<xsl:value-of select="umbraco.library:RequestQueryString('Make')"/></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="RequestMethod">
		<xsl:choose>
			<xsl:when test="$api='ImageToRotate'">DELETE</xsl:when>
			<xsl:when test="$api='NewImageToRotate'">DELETE</xsl:when>
			<xsl:when test="$api='ListingTempDel'">DELETE</xsl:when>
			<xsl:otherwise>GET</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="url" select="$dataUrl" />
	<xsl:if test="$url !=''">			
		<xsl:value-of select="scripts:GetData($url, $ContentType, $RequestMethod)" />
	</xsl:if>
</xsl:template>


<!-- C# helper scripts -->
<msxml:script language="C#" implements-prefix="scripts"> 

<msxml:assembly name="NLog" />
<msxml:assembly name="System.Xml.Linq"/>
<msxml:assembly name="System.Web"/>
<msxml:assembly name="System.Net"/>
<msxml:assembly name="System.ServiceModel"/>
<msxml:assembly name="System.ServiceModel.Web"/>
<msxml:assembly name="System.Core"/>
<msxml:assembly name="System.Xml.Linq"/>
	
<msxml:using namespace="System.Collections.Generic"/>
<msxml:using namespace="System.Net"/>
<msxml:using namespace="System.Linq"/>
<msxml:using namespace="System.Web"/>
<msxml:using namespace="System.Web.Caching"/>
<msxml:using namespace="System.Net"/>
<msxml:using namespace="System.ServiceModel"/>
<msxml:using namespace="System.ServiceModel.Web"/>
<msxml:using namespace="System.Xml"/>
<msxml:using namespace="System.Xml.Linq"/>
<msxml:using namespace="System.Xml.XPath"/>
<msxml:using namespace="System.Text.RegularExpressions"/>
<msxml:using namespace="System.IO"/>
<msxml:using namespace="NLog" />  


  
<![CDATA[
    static Logger log = LogManager.GetCurrentClassLogger();

	public int ParseToInt(string Text)
	{
		int Num = 0;

		if (int.TryParse(Text, out Num))
		{
			return Num;
		}

		return Num;
	}

	public string GetUserCode()
	{
		var SessionUserCode = HttpContext.Current.Session["easylist-usercodelist"];
		if (SessionUserCode != null) 
			return SessionUserCode.ToString();
		return "";
	}

	public void GetData(string url, string contentType, string RequestMethod = "GET")
	{
		try
		{
			HttpContext.Current.Response.Clear();

   			//WebRequest request = WebRequest.Create(url);
   			//request.ContentType = contentType ;
			
		  	HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
		   	request.ContentType = contentType ;
			request.Method = RequestMethod;
   
			// Get the response
			using (WebResponse response = request.GetResponse())
			{
				// Get the input stream
				using (Stream inStream = response.GetResponseStream())
				{
					HttpContext.Current.Response.ContentType = contentType ;
					HttpContext.Current.Response.AddHeader("Content-Length", response.ContentLength.ToString());

					log.Debug("Transferring a total of " + response.ContentLength + " bytes...");

					// Inititialize the read buffer and counters
					int bufferSize = 1024;
					byte[] buffer = new byte[bufferSize];
					int bytesRead = 0;
					int totalRead = 0;

					// Read from the input stream
					while ((bytesRead = inStream.Read(buffer, 0, bufferSize)) > 0)
					{
						// Write to the output stream
						log.Debug("Writing a chunk of " + bytesRead + " bytes..");
						HttpContext.Current.Response.OutputStream.Write(buffer, 0, bytesRead);
						totalRead += bytesRead;

					}
					log.Debug("All bytes written.");
				}
			}
			//Response.End();
		}
		catch (Exception ex)
		{
			HttpContext.Current.Response.Write("URL:" + url +" .Error proxying GetData: " + ex);
			log.Error("URL" + url +".Error proxying GetData: " + ex);
		}
	}
]]>
  
</msxml:script>

	
</xsl:stylesheet>