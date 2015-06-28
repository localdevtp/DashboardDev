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
	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Account')" /> 
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

<!-- start writing XSLT -->
	
	<xsl:call-template name="Load-Invoice-List">
	</xsl:call-template>
</xsl:template>

 <xsl:template name="Load-Invoice-List" match="Invoice">

	<xsl:variable name="InvoiceList" select="ActScripts:GetInvoiceList()" /> 
	<xsl:choose>
		<xsl:when test="string-length($InvoiceList/error) &gt; 0">
			<div class="alert">
				<xsl:value-of select="$InvoiceList/error" />
			</div>
		</xsl:when>
		<xsl:otherwise>
			<!-- /Invoice History -->
			<xsl:if test="count($InvoiceList/ArrayOfELInvoice/ELInvoice) > 0">
			<div class="widget-box">
				<div class="widget-title"><h2><i class="icon-file">&nbsp;</i> Invoice History</h2></div>
				<div class="widget-content no-padding">
					<table class="footable footable-compact">
						<thead>
							<tr>
								<th style="width:50px;">Paid</th>
								<th>Invoice</th>
								<th>Due Date</th>
								<th>Amount Due</th>
								<th style="width:140px" data-hide="phone">Status</th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="$InvoiceList/ArrayOfELInvoice/ELInvoice">
								<xsl:call-template name="Invoice-item">
								  <xsl:with-param name="ElInv" select="."></xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</div>
			</xsl:if>
			<xsl:if test="count($InvoiceList/ArrayOfELInvoice/ELInvoice) = 0">
				 <div id="easylist-no-results" class="alert">
					You don't have any invoices to display.
				 </div>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>


 <xsl:template name="Invoice-item" match="ElInv">
	<xsl:param name="ElInv"/>
    <tr>
		<td>
			<xsl:choose>
				<xsl:when test="$ElInv/IsPaid = 'true'">
					<i class="icon-checkmark success">&nbsp;</i>
				</xsl:when>
				<xsl:otherwise>	
					<i class="icon-close fail">&nbsp;</i>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<td>
			<a class="EditListing" target="_blank" href="/print/tp-invoice?id={$ElInv/InvoiceNumber}">
				<xsl:value-of select="$ElInv/InvoiceNumber"/>
			</a>
		</td>
		<td>
			<xsl:value-of select="umbraco.library:FormatDateTime($ElInv/DueDate, 'yyyy-MM-dd')" />
		</td>
		<td>
			<xsl:value-of select="ActScripts:FormatPrice($ElInv/Total, '')"/>
		</td>
		<td>
			<xsl:value-of select="$ElInv/StatusDescription"/>
		</td>
	</tr>
</xsl:template>


</xsl:stylesheet>