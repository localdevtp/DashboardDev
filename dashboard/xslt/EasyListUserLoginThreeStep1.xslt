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
<!-- 		<xsl:value-of select="umbraco.library:NiceUrl(/macro/landingPage)" /> -->
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
		<!-- <textarea>
			<xsl:value-of select="umbraco.library:RequestForm('logon')" />
		</textarea> -->
		<xsl:choose>
			
			<xsl:when test="$logout != '1' and string-length(umbraco.library:RequestForm('logon')) &gt; 0">
				
				<!-- Process login -->
				<xsl:variable name="userName" select="umbraco.library:RequestForm('easylist-user')" />

				<xsl:variable name="logonResponse" select="RESTscripts:LogonUserIDOnly($userName)" />
				
				<xsl:variable name="dataType" select="name($logonResponse/*)" />
				<xsl:if test="$dataType ='error'">
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$dataType = 'AccountInfo'">  
						<xsl:variable name="user-name" select="$logonResponse/AccountInfo/DisplayName" />

						<!-- Redirect to the target URL -->
						<xsl:value-of select="scripts:RedirectTo('https://dashboard.easylist.com.au/login/step-2.aspx')" />
					</xsl:when>
					<xsl:otherwise>
						<div class="login-alert alert alert-error flash">
							<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
							<strong>Login Failed</strong> Please check your username, then try again.
						</div>
						<xsl:call-template name="stage-1-form" />
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="stage-1-form" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="stage-1-form">
		<form method="post" >
			<div class="login-form stage-1">
				<div class="control-group">
					<input type="text" maxlength="100" class="login-field" name="easylist-user" id="username" placeholder="Enter your username" />
					<label class="login-field-icon icon-user" for="login-name">&nbsp;</label>
					<label class="checkbox" for="public-flag">
						<input type="checkbox" id="public-flag" name="public-flag" />This is a public or shared device
					</label>
				</div>
				
				<br />
				
				<div class="control-group">
					<button type="submit" name="logon" value="login" class="btn btn-large btn-primary btn-block">Next</button>
				</div>
			</div>
		</form>
	</xsl:template>
	
</xsl:stylesheet>