<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:scripts="urn:scripts.this" 
xmlns:RESTscripts="urn:RESTscripts.this" 
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
  
<xsl:output method="xml" omit-xml-declaration="yes"/>
    
<!-- C# helper scripts -->
<msxml:assembly name="NLog" />
<msxml:assembly name="System.Xml.Linq"/>
<msxml:assembly name="EasyList.Common.Helpers"/>


<xsl:include href="EasyListEditAPIHelper.xslt" />
<xsl:include href="EasyListRestHelper.xslt" />

<xsl:variable name="successUrl">
  <xsl:choose>
    <xsl:when test="umbraco.library:RequestQueryString('go') !=''">
      <xsl:value-of select="umbraco.library:RequestQueryString('go')"/>?<xsl:value-of select="umbraco.library:RequestQueryString('q')"/>
    </xsl:when>
    <xsl:when test="/macro/landingPage != ''">
      <xsl:value-of select="umbraco.library:NiceUrl(/macro/landingPage)" />
    </xsl:when>
    <xsl:otherwise>/</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="logout">
  <xsl:choose>
    <xsl:when test="umbraco.library:RequestQueryString('logout') ='1'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:param name="currentPage"/>

<xsl:template match="/">

	<xsl:if test="$logout = '1'">
		<!-- Clear the logged on user session vars -->
		<xsl:value-of select="scripts:SetUserSessionVars('', '', '', '', '')" />
		<xsl:value-of select="scripts:ClearSessionInfoVars()" />
		
		<div class="login-alert alert alert-info">
			<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
			You have logged out.
		</div>
	</xsl:if>
	
	<div class="login-alert alert alert-error flash">
		<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
		Some error message.<br />
		<a href="#">Error link</a>
	</div>
	
	<form method="post" action="" autocomplete="off">
		
		<xsl:call-template name="stage-2-form" />
		
	</form>

</xsl:template>

<xsl:template name="stage-2-form">
	<div class="login-form stage-2">
		
		<h4>
			<i class="icon-user">&nbsp;</i><strong>Username</strong>
		</h4>
		
		<xsl:call-template name="secure-phrase" />
		
		<xsl:call-template name="otp" />
		
		<xsl:call-template name="qna" />
		
		<xsl:call-template name="mobilenumber" />
		
		<xsl:call-template name="email" />
		
		<xsl:call-template name="password" />

		
		<div class="control-group">
			<button type="submit" name="logon" value="Submit" class="btn btn-large btn-primary btn-block">Submit</button>
		</div>
	</div>
</xsl:template>
	
<xsl:template name="secure-phrase">
	<p class="important" style="font-size:12px;">
		Is this your chosen security phrase?<br />If <strong>NOT</strong>, please <strong>DO NOT</strong> enter your password.
	</p>
	
	<div class="secure-code">
		<i class="icon-key">&nbsp;</i>YOUR SECURITY PHRASE
		<strong>TIMECOP2149</strong>
	</div>
</xsl:template>
	
<xsl:template name="otp">
	<div class="control-group">
		<input type="text" class="login-field login-field-action required" value="" placeholder="Enter OTP Code" id="otp" name="otp" />
		<label class="login-field-icon icon-asterisk" for="otp">&nbsp;</label>
		<label class="login-field-btn">
			<a id="request-otp" class="btn btn-block" href="#" tabindex="-1">Didn't received OTP Code?</a>
		</label>
	</div>
</xsl:template>
	
<xsl:template name="qna">
	<p>What was the name of your first pet?</p>
	<div class="control-group">
		<input type="text" class="login-field required" name="easylist-qna" id="easylist-qna" value="" placeholder="Security answer" />
		<label class="login-field-icon icon-shield" for="easylist-qna">&nbsp;</label>
	</div>
</xsl:template>
	
<xsl:template name="mobilenumber">
	<div class="control-group">
		<input type="text" class="login-field required" name="easylist-mobilenumber" id="easylist-mobilenumber" value="" placeholder="Mobile number" />
		<label class="login-field-icon icon-mobile" for="easylist-mobilenumber">&nbsp;</label>
	</div>
</xsl:template>
	
<xsl:template name="email">
	<div class="control-group">
		<input type="text" class="login-field required email" name="easylist-email" id="easylist-email" value="" placeholder="E-mail" />
		<label class="login-field-icon icon-envelop" for="easylist-email">&nbsp;</label>
	</div>
</xsl:template>
	
<xsl:template name="password">
	<div class="control-group">
		<input type="password" maxlength="50" class="login-field required" name="easylist-pass" id="easylist-pass" value="" placeholder="Password" />
		<label class="login-field-icon icon-lock" for="easylist-pass">&nbsp;</label>
	</div>	
</xsl:template>
  
</xsl:stylesheet>