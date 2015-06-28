<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

<!-- start writing XSLT -->
	<div class="widget-box widget-print-hide">
		<div class="widget-title"><h2><i class="icon-file">&nbsp;</i>Receipt for Invoice 000000</h2></div>
		<div class="widget-content">
			
			<table class="print-table">
				<tbody>
					<tr>
						<td>
							<img class="paid retina" src="/images/paid-stamp.png" />
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
													<strong>Username</strong><br />
													16 Coonil Street<br />
													Oakleigh South Victoria AU 3167
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
													<h4>Receipt for Invoice (No. 000000)</h4>
													<table class="print-meta">
														<tr>
															<th>Issued:</th>
															<td>5th August 2012</td>
														</tr>
														<tr>
															<th>Due:</th>
															<td>7th August 2012</td>
														</tr><tr>
														<th>Paid:</th>
														<td>7th August 2012</td>
														</tr>
													</table>
												</td>
												<td colspan="4" class="print-big-total">
													<div>
														<span>TOTAL</span>
														<strong>$29.95</strong>
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
											<tr class="print-detail-item">
												<td>Monthly domain name, website &amp; email Service Maintenance</td>
												<td>Monthly</td>
												<td>$29.95</td>
												<td>1</td>
												<td>$29.95</td>
											</tr>
											<tr class="print-detail-item-meta">
												<th colspan="4">SUB TOTAL</th>
												<td>$27.23</td>
											</tr>
											<tr class="print-detail-item-meta">
												<th colspan="4">GST</th>
												<td>$2.72</td>
											</tr>
											<tr class="print-detail-item-meta">
												<th colspan="4">TOTAL</th>
												<td>$29.95</td>
											</tr>
											<!-- /Invoice Details -->
										</table>
										<!-- /Invoice  -->
										
									</td>
								</tr>
							</table>
							<!-- /Bill To & Invoice -->
						</td>
					</tr>
					<!-- /Bill To & Invoice Line -->
				</tbody>
			</table>
			
			<div class="form-actions center">
				<a href="/accounting/payment" class="btn btn-large"><i class="icon-chevron-left">&nbsp;</i> Back</a>
				&nbsp;
				<a href="#" class="btn btn-large" onclick="window.print();"><i class="icon-print">&nbsp;</i> Print Receipt</a>
			</div>
		</div>
	</div>
	<!-- /Receipt -->

</xsl:template>

</xsl:stylesheet>