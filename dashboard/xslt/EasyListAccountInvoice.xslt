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

<xsl:variable name="InvNo" select="umbraco.library:RequestQueryString('InvNo')" /> 

<xsl:param name="currentPage"/>

<xsl:template match="/">
	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,RetailUser')" /> 
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
	
	<xsl:variable name="InvoiceInfo" select="ActScripts:GetInvoice($InvNo)" /> 
	<xsl:variable name="Inv" select="$InvoiceInfo/ELInvoice"/>

<!-- start writing XSLT -->
			
	<table class="print-table">
		<tbody>
			<tr>
				<td>
					<!-- Company Address -->
					<table class="print-company">
						<tr>
							<td>
								<strong>Easyco Pty Ltd</strong><br />
								ABN 49122658954<br />
								accounts@uniquewebsites.com.au
							</td>
						</tr>
					</table>
					<!-- /Company Address -->
				</td>
			</tr>
			<!-- /Company Address Line -->
			<tr>
				<td>
					<!-- Bill To & Invoice -->
					<table>
						<tr>
							<td>
								
								<!-- Bill To  -->
								<table class="print-detail">
									<tr>
										<td>
											<h4>Bill To</h4>
											<strong><xsl:value-of select="$Inv/AccDisplayName" /></strong><br />
											<xsl:value-of select="$Inv/AccDisplayAddressHtml" disable-output-escaping="yes"/>
										</td>
									</tr>
								</table>
								<!-- /Bill To  -->
								
							</td>
						</tr>
						<tr>
							<td>
								
								<!-- Invoice  -->
								<table class="print-detail">
									<tr>
										<td class="print-vtop">
											<h4> 
												<xsl:choose>
													<xsl:when test="$Inv/IsCreditNote = 'true'">
														CREDIT NOTE
													</xsl:when>
													<xsl:otherwise>	
														TAX INVOICE
													</xsl:otherwise>
												</xsl:choose>
												
												(No. <xsl:value-of select="$Inv/InvoiceNumber" />)</h4>
											<table class="print-meta">
												<tr>
													<th>Issued:</th>
													<td><xsl:value-of select="umbraco.library:FormatDateTime($Inv/IssueDate, 'dd MMM yyyy')" /></td>
												</tr>
												<xsl:if test="$Inv/IsCreditNote != 'true'">
													<tr>
														<th>Due:</th>
														<td><xsl:value-of select="umbraco.library:FormatDateTime($Inv/DueDate, 'dd MMM yyyy')" /></td>
													</tr>
												</xsl:if>
												<xsl:if test="$Inv/Discount &gt; 0">
													<tr>
														<th>Discount:</th>
														<td><xsl:value-of select="ActScripts:FormatPrice($Inv/Discount, '')" /></td>
													</tr>
												</xsl:if>
											</table>
										</td>
										<td colspan="4" class="print-big-total">
											<div>
												<xsl:choose>
													<xsl:when test="$Inv/IsCreditNote = 'true'">
														<span>Total Credited</span>
													</xsl:when>
													<xsl:otherwise>	
														<span>Total Due</span>
													</xsl:otherwise>
												</xsl:choose>
												<strong><xsl:value-of select="ActScripts:FormatPrice($Inv/TotalDue, '')" /></strong>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="5">&nbsp;</td>
									</tr>
									<!-- Invoice Details -->
									
									<tr class="print-detail-header">
										<th>TASK / DESCRIPTION</th>
										<th>BILLING CYCLE</th>
										<th>PRICE</th>
										<th>QTY</th>
										<th>AMOUNT</th>
									</tr>
									<!-- <textarea>
			<xsl:value-of select="$Inv/BillableItems" />
		   </textarea> -->
									<xsl:for-each select="$Inv/BillableItems/ELInvoiceItems">
										<tr class="print-detail-item">
											<td><xsl:value-of select="./Description" /></td>
											<td><xsl:value-of select="./BillingCycle" /></td>
											<td><xsl:value-of select="ActScripts:FormatPrice(./Price, '')" /></td>
											<td>1</td>
											<td><xsl:value-of select="ActScripts:FormatPrice(./Price, '')" /></td>
										</tr>
									</xsl:for-each>
									
									<tr class="print-detail-item-meta">
										<th colspan="4">SUB TOTAL</th>
										<td><xsl:value-of select="ActScripts:FormatPrice($Inv/SubTotal, '')" /></td>
									</tr>
									<tr class="print-detail-item-meta">
										<th colspan="4">GST</th>
										<td><xsl:value-of select="ActScripts:FormatPrice($Inv/Tax, '')" /></td>
									</tr>
									<tr class="print-detail-item-meta">
										<th colspan="4">
											<xsl:choose>
												<xsl:when test="$Inv/IsCreditNote = 'true'">
													<span>This Credit Note</span>
												</xsl:when>
												<xsl:otherwise>	
													<span>This Invoice</span>
												</xsl:otherwise>
											</xsl:choose>
										</th>
										<td><xsl:value-of select="ActScripts:FormatPrice($Inv/Total, '')" /></td>
									</tr>
									<xsl:if test="$Inv/Discount &gt; 0">
										<tr class="print-detail-item-meta">
											<th colspan="4">Discount</th>
											<td><xsl:value-of select="ActScripts:FormatPrice($Inv/Discount, '')" /></td>
										</tr>
									</xsl:if>
									
									<tr class="print-detail-item-meta">
										<th colspan="4">
											<xsl:choose>
												<xsl:when test="$Inv/IsCreditNote = 'true'">
													<span>Total Credited</span>
												</xsl:when>
												<xsl:otherwise>	
													<span>Total Due</span>
												</xsl:otherwise>
											</xsl:choose>
										</th>
										<td><xsl:value-of select="ActScripts:FormatPrice($Inv/TotalDue, '')" /></td>
									</tr>
									<!-- /Invoice Details -->
								</table>
								<!-- /Invoice  -->
								
								<br />
								<xsl:if test="$Inv/IsCreditNote != 'true' and $Inv/IsOverDue = 'true'">
									<div class="alert">
										This invoice is <xsl:value-of select="$Inv/StatusDescription" />. Please settle this invoice ASAP to ensure continuing services.
									</div>				
								</xsl:if>
							</td>
						</tr>
					</table>
					<!-- /Bill To & Invoice -->
				</td>
			</tr>
			<!-- /Bill To & Invoice Line -->
		</tbody>
	</table>

</xsl:template>

</xsl:stylesheet>