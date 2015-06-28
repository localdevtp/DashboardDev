<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:scripts="urn:scripts.this" 
	xmlns:RESTscripts="urn:RESTscripts.this" 
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>
<xsl:include href="EasyListRestHelper.xslt" />

<xsl:template match="/">

<!-- start writing XSLT -->
	
	<xsl:variable name="OTPResponse" select="RESTscripts:ResendOTP()" />
	<xsl:variable name="AccInfo" select="$OTPResponse/AccountInfo" />
	
	<!--<textarea>	
		<xsl:value-of select="$OTPResponse/error"/>
	</textarea>	-->
	<xsl:choose>
		<xsl:when test="string-length($OTPResponse/error) &gt; 0 or $AccInfo/HasError = 'true'">
			<div class="alert alert-error">
				<strong>Error</strong>
				Unfortunately, your OTP resend failed at this point in time.<br/>
				Please try again.
				<!--<xsl:value-of select="$OTPResponse/error"/>-->
			</div>
		</xsl:when>
		<xsl:otherwise>
			<p>
				Your OTP Request is successful (<xsl:value-of select="$AccInfo/OTPResendTime" />).
			</p>
			<p>
				Your OTP code will be sent via SMS to your registered mobile phone number <strong><xsl:value-of select="$AccInfo/MobileNoMasked" /></strong>.
			</p>
			<div class="alert">
				If you did not request this or this is not your mobile please contact customer support.
			</div>
			
			<input type="hidden" value="{$AccInfo/OTPReferenceCode}" id="OTPRefCode" class="OTPRefCode" name="OTPRefCode" />
			
		</xsl:otherwise>
	</xsl:choose>

	
	
</xsl:template>

</xsl:stylesheet>