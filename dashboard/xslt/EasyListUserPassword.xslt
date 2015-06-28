<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="EasyListStaffHelper.xslt" /> 

<xsl:variable name="LoginID" select="umbraco.library:Session('easylist-username')" />
<xsl:variable name="IsPostBack" select="umbraco.library:Request('change-password')" />

<xsl:param name="currentPage"/>

<xsl:template match="/">
	<xsl:if test="$IsPostBack = 'true'"> <!-- Update Account -->
		<xsl:variable name="ChangePasswordResponse" select="AccScripts:AccountChangePassword($LoginID)" />
		<xsl:choose>
		  <!-- Check if error message is not empty -->
		  <xsl:when test="string-length($ChangePasswordResponse) &gt; 0">
			  <div class="alert alert-error">
				  <button data-dismiss="alert" class="close" type="button">×</button>
				  <strong>Failed!</strong> <xsl:copy-of select="$ChangePasswordResponse" />
			  </div>
		  </xsl:when>
		  <!-- Success without error -->
		  <xsl:otherwise>
			  <div class="alert alert-success">
				  <button data-dismiss="alert" class="close" type="button">×</button>
				  <strong>Success!</strong> You have changed your password.
			  </div>
		  </xsl:otherwise>
		</xsl:choose>
	</xsl:if>

	<xsl:call-template name="ChangePasswordTemplate">
	</xsl:call-template>

</xsl:template>

<xsl:template name="ChangePasswordTemplate">
	<div class="widget-box">
	  <div class="widget-title"><h2><i class="icon-key">&nbsp;</i> Change Password</h2></div>
	  <div class="widget-content">
		<form class="form-horizontal" autocomplete="off" method="post" runat="server">

		  <div class="control-group">
			<label class="control-label"><span class="important">*</span> Current Password</label>
			<div class="controls">
				<input type="password" name="CurrentPassword" id="CurrentPassword" value="" class="input-xlarge">
					<xsl:attribute name="data-validate">{required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter current password!'}}</xsl:attribute>
				</input>
			</div>
		  </div>
		  <div class="control-group">
			<label class="control-label"><span class="important">*</span> New Password</label>
			<div class="controls">
				<input type="password" name="NewPassword" id="NewPassword" value="" class="input-xlarge" data-password-meter="true">
					<!--<xsl:attribute name="data-validate"><![CDATA[{regex:/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[\w\s!@#$%^&*]{8,20}$/ ,required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter new password!', regex:'Please enter at least 8 characters with one or more of each: uppercase[A-Z], lowercase[a-z], number[0-9] and symbols[!@#$%^&]'}}]]></xsl:attribute>-->
					<xsl:attribute name="data-validate">{required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter new password!'}}</xsl:attribute>
				</input>
			</div>
		  </div>
		  <div class="control-group">
			<label class="control-label"><span class="important">*</span> Re-type New Password</label>
			<div class="controls">
				<input type="password" name="ConfirmPassword" id="ConfirmPassword" value="" class="input-xlarge">
					<xsl:attribute name="data-validate">{equalTo: '#NewPassword', minlength: 8, maxlength: 20}</xsl:attribute>
				</input>
			</div>
		  </div>
		  <input type="hidden" id="change-password" name="change-password" value="true" />
					
		  <div class="form-actions center">
			  <button type="submit" name="submit" class="btn btn-large btn-success">Submit</button>
		  </div>
		</form>
	  </div>
	</div>

</xsl:template>

</xsl:stylesheet>