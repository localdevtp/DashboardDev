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

	<xsl:variable name="invoiceID" select="number(umbraco.library:RequestQueryString('id'))" />
	<xsl:variable name="url">http://invoices.api.easylist.com.au/api.aspx?id=<xsl:value-of select="$invoiceID"/></xsl:variable>
	<xsl:variable name="cacheDuration">60</xsl:variable>
	<xsl:variable name="data" select="umbraco.library:GetXmlDocumentByUrl($url, $cacheDuration)" />    

	<table class="print-table trading-post">
		<tbody>
			<tr>
				<td>
					<!-- Company Address / Bill To / Tax Invoice Line -->
					<table>
						<tr>
							<td style="vertical-align:top;">

								<!-- Company Address -->
								<table class="print-company">
									<tr>
										<td>
											<img src="/images/uw/unique-websites-logo.png" style="height:100px" class="uw" alt="Trading Post" /><br />
											<small>Unique Websites&nbsp;&nbsp;-&nbsp;&nbsp;ABN 49 136 905 381</small>
										</td>
									</tr>
								</table>
								<!-- /Company Address -->
								<xsl:choose>	
									<xsl:when test="$data/InvoiceInfo/UserType='Business'">
										<strong>Tax Invoice Issue Date <xsl:value-of select="$data/InvoiceInfo/InvoiceDate" /></strong>
									</xsl:when>
									<xsl:otherwise>
										<strong>Issue Date <xsl:value-of select="$data/InvoiceInfo/InvoiceDate" /></strong>
									</xsl:otherwise>
								</xsl:choose>
											
								

								<!-- Bill To  -->
								<table class="print-detail print-bill-to" style="margin-top:100px">
									<tr>
										<td>
											<xsl:value-of select="$data/InvoiceInfo/CompanyName" /><br />
											<xsl:value-of select="$data/InvoiceInfo/CompanyAddress" disable-output-escaping="yes" />										
										</td>
									</tr>
								</table>
								<!-- /Bill To  -->
							</td>
							<td align="right" rowspan="2">

								<table class="print-company">
									<tr>
										<td align="right">
											<img src="/images/tp/tp-logo-2x.png" style="margin-top: 30px;" alt="Trading Post" /><br />
											<small>A division of Unique Websites</small>
										</td>
									</tr>
								</table>

								<br /><br />

								<!-- Tax Invoice -->
								<table class="print-tax-invoice">
									<caption>
										<xsl:choose>
											<xsl:when test="$data/InvoiceInfo/UserType='Business'">TAX INVOICE</xsl:when>
											<xsl:otherwise>RECEIPT</xsl:otherwise>
										</xsl:choose>
									</caption>
									<tr>
										<th><div>Account Number</div></th>
										<td><div><xsl:value-of select="$data/InvoiceInfo/AccountNumber" /></div></td>
									</tr>
									<tr>
										<th><div>Reference Number</div></th>
										<td><div><xsl:value-of select="$data/InvoiceInfo/CustomerRef" /></div></td>
									</tr>
									<tr>
										<th>
											<div>
												<xsl:choose>	
													<xsl:when test="$data/InvoiceInfo/UserType='Business'">Invoice Number</xsl:when>
													<xsl:otherwise>Receipt Number</xsl:otherwise>
												</xsl:choose>
											</div>
										</th>
										<td><div><xsl:value-of select="$data/InvoiceInfo/InvoiceNumber" />TP</div></td>
									</tr>
								</table>
								<!-- /Tax Invoice -->

								<br />

								<!-- Enquiries -->
								<xsl:if test="$data/InvoiceInfo/UserType='Business'">
									<div class="print-enquiries">
										<header>Enquiries</header>
										<dl>
											<xsl:if test="$data/InvoiceInfo/AccountManager !=''">
											<dt>Area Sales Manager</dt>
											<dd><xsl:value-of select="$data/InvoiceInfo/AccountManager" /></dd>
											</xsl:if>
											<dt>Direct Line</dt>
											<dd>1800 810 514</dd>
											<dt>Account Enquiries</dt>
											<dd>accounts@uniquewebsites.com.au</dd>
											<dt>Customer Service</dt>
											<dd>onlinecare@tradingpost.com.au</dd>
										</dl>
										<footer>
										<div style="padding: 5px; text-align: center; width: 100%; font-weight: normal; font-size: 0.65em;">7/150 Lonsdale Street, Melbourne. 3000</div>
										
										</footer>
									</div>
									
									<table class="print-enquiries hidden">
										<tr>
											<td>Enquiries</td>
										</tr>
										<tr>
											<td>
												<table style="font-size:12px;">
													<xsl:if test="$data/InvoiceInfo/AccountManager !=''">
														<tr>
															<td style="text-align:right;color:maroon;">Area Sales Manager</td>
															<td style="text-align:left"><xsl:value-of select="$data/InvoiceInfo/AccountManager" /></td>
														</tr>
													</xsl:if>
													<tr>
														<td style="text-align:right;color:maroon;">Direct Line</td>
														<td style="text-align:left">1800 810 514</td>
													</tr>
													<tr>
														<td style="text-align:right;color:maroon;">Account Enquiries</td>
														<td style="text-align:left">accounts@tradingpost.com.au</td>
													</tr>
													<tr>
														<td style="text-align:right;color:maroon;">Customer Service</td>
														<td style="text-align:left">customerservice@tradingpost.com.au</td>
													</tr>
												</table>
											</td>
										</tr>
										<!--
										<tr>
											<td>
												www.tradingpost.com.au
											</td>
										</tr>
										-->
									</table>
									<!-- /Enquiries -->
									
								</xsl:if>

							</td>
						</tr>
						<xsl:if test="$data/InvoiceInfo/UserType='Business'">
							<tr>
								<td style="vertical-align:bottom">
	
									<!-- Ad-Hoc Notice (background color class: bg-success, bg-important, bg-warning, bg-info) -->
									<div class="print-notice bg-important radius" style="margin-right:20px;background-color:#FFFFFF !important">
										Important! Do not pay Telstra for this invoice! This invoice is from Unique Websites, the new operators of Tradingpost.com.au and is for your <xsl:value-of select="$data/InvoiceInfo/BillingPeriod" /> services.
									</div>
									<!-- /Ad-Hoc Notice -->
	
								</td>
							</tr>
						</xsl:if>
					</table>
					<!-- /Company Address / Bill To / Tax Invoice Line -->

				</td>
			</tr>
			<tr>
				<!-- Adjust this height to fit your wkhtmltopdf version, this is based on 0.10.0 rc2 -->
				<td style="height:830px;vertical-align:top;">
					<!--Account Avtivity -->
					<table class="print-detail">
						<tr class="print-detail-header">
							<th>Account Activity</th>
						</tr>
						<tr>
							<td>

								<table>
									<tr>
										<td style="width:50%;padding-top:10px;vertical-align:top;">
											<xsl:if test="$data/InvoiceInfo/UserType='Business'">
											<!-- Receipt -->
											<table class="print-receipt">
												<!--
												<tr>
													<td>Previous Balance</td>
													<td align="right"><xsl:value-of select="$data/InvoiceInfo/PreviousBalance" /></td>
												</tr>
												<tr>
													<td>Payments Received</td>
													<td align="right"><xsl:value-of select="$data/InvoiceInfo/PaymentsReceived" /></td>
												</tr>
												<tr>
													<td>Adjustments<br /><small>(See over for breakdown)</small></td>
													<td align="right" style="vertical-align:top;"><xsl:value-of select="$data/InvoiceInfo/Adjustments" /></td>
												</tr>
												<tr>
													<td colspan="2">
														<div class="seperator">&nbsp;</div>
													</td>
												</tr>
												-->
												<tr>
													<td>Previous Balance</td>
													<td align="right"><xsl:value-of select="$data/InvoiceInfo/AccountBalance" /></td>
												</tr>
												<tr>
													<td>New Charges<br /><small>(See over for breakdown)</small></td>
													<td align="right" style="vertical-align:top;"><xsl:value-of select="$data/InvoiceInfo/NewCharges" /></td>
												</tr>
												<tr>
													<td>&nbsp;</td>
													<td>&nbsp;</td>
												</tr>
												<tr class="total">
													<td>Total</td>
													<td align="right"><xsl:value-of select="$data/InvoiceInfo/TotalDue" /></td>
												</tr>
												
													<tr>
														<td align="right">GST included in new charges</td>
														<td align="right"><xsl:value-of select="$data/InvoiceInfo/NewGST" /></td>
													</tr>
												
											</table>
												
											</xsl:if>
											<!-- /Receipt -->

										</td>
										<td align="right" style="width:50%;">

											<br />

											<!-- Total -->
											<div class="print-total-border">
												<table class="print-total">
													<tr>
														<td>Total to be Paid</td>
														<td><xsl:value-of select="$data/InvoiceInfo/TotalDue" /></td>
													</tr>
													<xsl:if test="$data/InvoiceInfo/UserType='Business' and $data/InvoiceInfo/TotalDue != '$ 0.00'">
														<tr>
															<td>Pay By</td>
															<td><xsl:value-of select="$data/InvoiceInfo/DueDate" /></td>
														</tr>
														<xsl:if test="$data/InvoiceInfo/AutoPayDate !=''">
															<tr>
																<td>Automatic Payment Date</td>
																<td><xsl:value-of select="$data/InvoiceInfo/AutoPayDate" /></td>
															</tr>
														</xsl:if>
													</xsl:if>
												</table>
											</div>
											<!-- Total -->

											<br />

											<!-- Total Notice -->
											<xsl:if test="$data/InvoiceInfo/UserType='Business' and $data/InvoiceInfo/TotalDue != '$ 0.00'">
												<div class="print-total-notice radius bg-success"> <!-- Remove hidden class to reveal -->
													<xsl:if test="$data/InvoiceInfo/PaymentMethod !='Credit Card'">
														<xsl:attribute name="class">print-total-notice radius bg-success hidden</xsl:attribute>
													</xsl:if>
													Your account will be automatically paid using the saved payment method you have on file with us.
													Please ensure that you have sufficient funds available prior to the automatic payment date to prevent
													any service interruption.
													<br /><br />
													This payment will appear on your financial institution statement as being from Unique Websites.
												</div>
	
												<br />
	
												<div class="print-total-notice radius bg-important">
													<xsl:if test="$data/InvoiceInfo/PaymentMethod ='Credit Card' and $data/InvoiceInfo/TotalDue != '$ 0.00'">
														<xsl:attribute name="class">print-total-notice radius bg-success hidden</xsl:attribute>
													</xsl:if>
													Your account does not appear to have a valid automatic payment method associated with it.
													Please ensure you make payment via BPay prior to the
													Pay By date to avoid service interruption and any recovery action.
													<br /><br />
													Biller Code: 218628<br/>
													Ref: <xsl:value-of select="$data/InvoiceInfo/CustomerRef" />
												</div>
												<!-- Total Notice -->
											</xsl:if>

										</td>
									</tr>
								</table>

							</td>
						</tr>
					</table>
					<!--/Account Avtivity -->

					<!-- How to Pay -->
					<xsl:if test="$data/InvoiceInfo/UserType='Business'">
						<table class="trading-post print-table-footer">
							<tr>
								<td colspan="2"><h3>How To Pay</h3></td>
							</tr>
							<tr>
								<xsl:if test="$data/InvoiceInfo/PaymentMethod !='Credit Card'">
									<td width="30%">
										<div class="bpay-box">
											<div class="bpay-billercode">218628</div>
											<div class="bpay-ref"><xsl:value-of select="$data/InvoiceInfo/CustomerRef" /></div>
										</div>
									</td>
								</xsl:if>
								<td>
									<div class="cc-box">
										<header>
											<img src="/images/payments/credit.png" />Credit Card
										</header>
										<p>
											You can manage or update your Credit Card on file by logging into your account at:<br /><br />
											<strong><a href="https://dahsboard.easylist.com.au">https://dashboard.easylist.com.au</a></strong>
										</p>
									</div>
								</td>
							</tr>
						</table>
						<!-- /How to Pay -->
					</xsl:if>
				</td>
			</tr>
		</tbody>
	</table>
	<!-- /trading-post [Page 1] -->

	<table class="print-table break trading-post">
		<tbody>
			<tr>
				<td>

					<br />
					<br />

					<!--New Charges Breakdown -->
					<table align="left" style="margin-bottom:20px;width:50%;font-weight:bold;">
						<tr>
							<td>Issue Date</td>
							<td><xsl:value-of select="$data/InvoiceInfo/InvoiceDate" /></td>
						</tr>
						<tr>
							<td>Billing Period</td>
							<td><xsl:value-of select="$data/InvoiceInfo/BillingPeriod" /></td>
						</tr>
					</table>

					<!--New Charges Breakdown Details -->
					<table class="print-detail">
						<tr class="print-detail-header">
							<th>New Charges Breakdown</th>
						</tr>
						
						<xsl:for-each select="$data/InvoiceInfo/Items/BookingInfo">
							<xsl:variable name="bookingDesc" select="./Description" />
						
						<tr>
							<td style="padding:10px 0;">
								<table style="width:50%;">
									<xsl:if test="./ClientAccountNumber !=''">
									<tr>
										<td>Customer Account:</td>
										<td><xsl:value-of select="./ClientAccountNumber" /></td>
									</tr>
									</xsl:if>
									<xsl:if test="./ClientAccountName !=''">
									<tr>
										<td>Customer Name:</td>
										<td><xsl:value-of select="./ClientAccountName" /></td>
									</tr>
									</xsl:if>
									<tr>
										<td>Sales Order:</td>
										<td><xsl:value-of select="./BookingNumber" /></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								<!-- New Charges Breakdown Detail Table -->
								<table class="print-new-charges">
									<!--
									<thead>
										<tr>
											<th>Product</th>
											<th width="150">Weekly Price</th>
											<th width="50">Days</th>
											<th width="150">Total (Incl. GST)*</th>
										</tr>
									</thead>
									-->
									<tbody>
										<!--
										<tr>
											<td>One off Booking Fee (Set up fee)</td>
											<td></td>
											<td></td>
											<td>$ 100.00</td>
										</tr>
										-->
										
										<tr>
											<th colspan="4"><xsl:value-of select="./Description" /></th>
										</tr>
										
										<xsl:for-each select="./Items/BillableItemInfo">
										
											<xsl:choose>
												<xsl:when test="./BillingFrequency = 'Weekly'">
													<tr>
														<th>Product</th>
														<th width="150">Weekly Price</th>
														<th width="50">Days</th>
														<th width="150">Total (Incl. GST)*</th>
													</tr>
													<tr>
														<td class="subs"><xsl:value-of select="./Description" />
															<xsl:if test="./NormalPrice !=''">
																<br /><small class="reduce">Normal Price <xsl:value-of select="./NormalPrice" /></small>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="./FromDate !='' and ./ToDate !=''">
																	<br /><small>Booking Duration <xsl:value-of select="./FromDate" /> - <xsl:value-of select="./ToDate"/></small>
																</xsl:when>
																<xsl:when test="./ToDate !=''">
																	<br /><small>Booking Finished <xsl:value-of select="./ToDate"/></small>
																</xsl:when>
																<xsl:when test="./FromDate !=''">
																	<br /><small>Booking Started <xsl:value-of select="./FromDate" /></small>
																</xsl:when>
															</xsl:choose>
														</td>
														<td><xsl:value-of select="./Price" /></td>
														<td><xsl:value-of select="./Days"/></td>
														<td><xsl:value-of select="./Total"/></td>
													</tr>	
												</xsl:when>
												
												<xsl:when test="./BillingFrequency = 'Monthly'">
													<tr>
														<th colspan="2">Product</th>
														<th width="150">Monthly Price</th>
														<th width="150">Total (Incl. GST)*</th>
													</tr>
													<tr>
														<td class="subs" colspan="2"><xsl:value-of select="./Description" />
															<xsl:if test="./NormalPrice !=''">
																<br /><small class="reduce">Normal Price <xsl:value-of select="./NormalPrice" /></small>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="./FromDate !='' and ./ToDate !=''">
																	<br /><small>Booking Duration <xsl:value-of select="./FromDate" /> - <xsl:value-of select="./ToDate"/></small>
																</xsl:when>
																<xsl:when test="./ToDate !=''">
																	<br /><small>Booking Finished <xsl:value-of select="./ToDate"/></small>
																</xsl:when>
																<xsl:when test="./FromDate !=''">
																	<br /><small>Booking Started <xsl:value-of select="./FromDate" /></small>
																</xsl:when>
															</xsl:choose>
														</td>
														<td><xsl:value-of select="./Price" /></td>
														<!--<td><xsl:value-of select="./Days"/></td>-->
														<td><xsl:value-of select="./Total"/></td>
													</tr>	
												</xsl:when>
												
												<xsl:when test="./BillingFrequency = 'Yearly'">
													<tr>
														<th colspan="2">Product</th>
														<th width="150">Yearly Price</th>
														<th width="150">Total (Incl. GST)*</th>
													</tr>
													<tr>
														<td class="subs" colspan="2"><xsl:value-of select="./Description" />
															<xsl:if test="./NormalPrice !=''">
																<br /><small class="reduce">Normal Price <xsl:value-of select="./NormalPrice" /></small>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="./FromDate !='' and ./ToDate !=''">
																	<br /><small>Booking Duration <xsl:value-of select="./FromDate" /> - <xsl:value-of select="./ToDate"/></small>
																</xsl:when>
																<xsl:when test="./ToDate !=''">
																	<br /><small>Booking Finished <xsl:value-of select="./ToDate"/></small>
																</xsl:when>
																<xsl:when test="./FromDate !=''">
																	<br /><small>Booking Started <xsl:value-of select="./FromDate" /></small>
																</xsl:when>
															</xsl:choose>
														</td>
														<td><xsl:value-of select="./Price" /></td>
														<!--<td><xsl:value-of select="./Days"/></td>-->
														<td><xsl:value-of select="./Total"/></td>
													</tr>	
												</xsl:when>
												
												<xsl:when test="./BillingFrequency = 'Once Only'">
													<tr>
														<th colspan="2">Product</th>
														<th width="150">Price</th>
														<th width="150">Total</th>
													</tr>
													<tr>
														<td class="subs" colspan="2"><xsl:value-of select="./Description" />
															<xsl:if test="./NormalPrice !=''">
																<br /><small class="reduce">Normal Price <xsl:value-of select="./NormalPrice" /></small>
															</xsl:if>
															<xsl:choose>
																<!--
																<xsl:when test="./FromDate !='' and ./ToDate !=''">
																	<br /><small>Booking Duration <xsl:value-of select="./FromDate" /> - <xsl:value-of select="./ToDate"/></small>
																</xsl:when>
																<xsl:when test="./ToDate !=''">
																	<br /><small>Booking Finished <xsl:value-of select="./ToDate"/></small>
																</xsl:when>
																-->
																<xsl:when test="./FromDate !=''">
																	<br /><small>Booked On <xsl:value-of select="./FromDate" /></small>
																</xsl:when>
															</xsl:choose>
														</td>
														<td><xsl:value-of select="./Price" /></td>
														<!--<td><xsl:value-of select="./Days"/></td>-->
														<td><xsl:value-of select="./Total"/></td>
													</tr>	
												</xsl:when>
												
											</xsl:choose>
											
										</xsl:for-each>
											
										<!--
										<tr>
											<td class="subs">1300-to-Mobile<br /><small class="reduce">Normal Price $50.00</small></td>
											<td>$ 176.00</td>
											<td>14</td>
											<td>$ 46.00</td>
										</tr>
-->
										<!--
										<tr>
											<th colspan="4">Promote Me - NSW - Used Cars</th>
										</tr>
										<tr>
											<td class="subs">50 Items</td>
											<td>$ 176.00</td>
											<td>2</td>
											<td>$ 50.26</td>
										</tr>
										<tr>
											<td class="subs">1300-to-Mobile</td>
											<td>$ 23.00</td>
											<td>2</td>
											<td>$ 6.57</td>
										</tr>
										<tr class="subtotal">
											<th>Total</th>
											<th colspan="3">$ 554.86</th>
										</tr>
										-->
									</tbody>
								</table>
							</td>
							</tr>
						</xsl:for-each>
						
						<xsl:if test="$data/InvoiceInfo/Discount != '$ 0.00'">
							<tr>
								<td>
									<table class="print-new-charges">
										<tbody>
											<tr>
												<td colspan="4">
													<div class="total">
														<table>
															<tr>
																<td>Sub Total Inc. GST</td>
																<td><xsl:value-of select="$data/InvoiceInfo/SubTotal" /></td>
															</tr>
														</table>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
									<!-- /New Charges Breakdown Details Table -->
								</td>
							</tr>
							
							<tr>
								<td>
									<table class="print-new-charges">
										<tbody>
											<tr>
												<td>SubTotal Ex. GST</td>
												<td><xsl:value-of select="$data/InvoiceInfo/SubTotalExGST" /></td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table class="print-new-charges">
										<tbody>
											<tr>
												<td>Discount (<xsl:value-of select="$data/InvoiceInfo/DiscountPercent"/>)</td>
												<td><xsl:value-of select="$data/InvoiceInfo/Discount" /></td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							
						</xsl:if>
						
						<!-- New Charges -->
						<tr>
							<td>
								<table class="print-new-charges">
									<tbody>
										<tr>
											<td colspan="4">
												<div class="total">
													<table>
														<tr>
															<td>
																<xsl:choose>
																	<xsl:when test="$data/InvoiceInfo/UserType='Business'">Total New Charges Inc. GST</xsl:when>
																	<xsl:otherwise>Total Charges</xsl:otherwise>
																</xsl:choose>
															</td>
															<td><xsl:value-of select="$data/InvoiceInfo/NewCharges" /></td>
														</tr>
													</table>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
								<!-- /New Charges Breakdown Details Table -->
							</td>
						</tr>
					</table>
					<!--/New Charges Breakdown Detail -->

					<!-- Payment Breakdown -->
					<!--
					<table class="print-detail">
						<tr class="print-detail-header">
							<th>Payment Breakdown</th>
						</tr>
						<tr>
							<table class="print-payments">
								<thead>
									<tr>
										<th>Payment Date</th>
										<th>Payment Method</th>
										<th>Amount</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>18/06/2013</td>
										<td>Bpay</td>
										<td>-$ 1,054.44</td>
									</tr>
									<tr class="total">
										<th>&nbsp;</th>
										<th>Total Payments</th>
										<th>-$ 1,054.44</th>
									</tr>
								</tbody>
							</table>
						</tr>
					</table>-->
					<!-- /Payment Breakdown -->

				</td>
			</tr>
		</tbody>
	</table>
	<!-- /trading-post [Page 2] -->


</xsl:template>

</xsl:stylesheet>