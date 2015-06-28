<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:ActScripts="urn:ActScripts.this"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="EasyListAccountHelper.xslt" /> 
<xsl:include href="EasyListStaffHelper.xslt" /> 
<xsl:param name="currentPage"/>

<xsl:template match="/">
	

<!-- start writing XSLT -->
	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Account')" /> 
<!-- 	<textarea>
		<xsl:value-of select="$IsAuthorized" />
	</textarea> -->
	<xsl:choose>
		<xsl:when test="$IsAuthorized = false">
			<div class="alert alert-error">
				<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
			</div>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="LoadPage">
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

 <xsl:template name="LoadPage" >	

	<xsl:call-template name="Load-Payment-List">
	</xsl:call-template>
</xsl:template>	

 <xsl:template name="Load-Payment-List" match="Payment">
 
	<xsl:variable name="PaymentList" select="ActScripts:GetPaymentList()" /> 
	<xsl:choose>
		<xsl:when test="string-length($PaymentList/error) &gt; 0">
			<div class="alert">
				<xsl:value-of select="$PaymentList/error" />
			</div>
		</xsl:when>
		<xsl:otherwise>
			<!-- /Invoice History -->
			<xsl:if test="count($PaymentList/ArrayOfELPayment/ELPayment) > 0">
			<div class="widget-box">
				<div class="widget-title"><h2><i class="icon-file">&nbsp;</i> Payment History</h2></div>
				<div class="widget-content no-padding">
					<table class="footable footable-compact">
						<thead>
							<tr>
								<th data-class="expand">Payment Date</th>
								<!-- <th>For Invoice</th> -->
								<th>Amount</th>
								<th data-hide="phone">Method</th>
								<th style="width:140px" data-hide="phone">Status</th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="$PaymentList/ArrayOfELPayment/ELPayment">
								<xsl:call-template name="Payment-item">
								  <xsl:with-param name="ElPay" select="."></xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</div>
			</xsl:if>
			<xsl:if test="count($PaymentList/ArrayOfELPayment/ELPayment) = 0">
				 <div id="easylist-no-results" class="alert">
					You don't have any payment to display!
				 </div>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

 <xsl:template name="Payment-item" match="ElPay">
	<xsl:param name="ElPay"/>
	
	<tr>
		<td>
			<xsl:value-of select="umbraco.library:FormatDateTime($ElPay/PaymentDate, 'yyyy-MM-dd')" />
		</td>
		<td>
			<xsl:value-of select="ActScripts:FormatPrice($ElPay/PaymentAmount, '')"/>
		</td>
		<td>
			<xsl:value-of select="$ElPay/PaymentMethod"/>
		</td>
		<td>
			<xsl:value-of select="$ElPay/StatusDescription"/>
		</td>
	</tr>

</xsl:template>

</xsl:stylesheet>