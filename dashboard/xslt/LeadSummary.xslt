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

	<div class="row">
		<div class="span3">
			<!-- Leads Summary Stats -->
			<div class="widget-box">
				<div class="widget-title">
					<h2><i class="icon-bars"><xsl:text>
						</xsl:text></i>Leads</h2>
				</div>
				
				<div class="widget-content no-padding">
					<table class="table">
						<tbody>
							<tr>
								<td class="center">
									Unassigned
								</td>
								<td style="text-align:center"><span class="label label-important">13</span></td>
							</tr>
							<tr>
								
								<td class="center">
									Assigned
								</td>
								<td style="text-align:center"><span class="label label-warning">17</span></td>
							</tr>
							<tr>
								<td class="center">
									Follow Up
								</td>
								<td style="text-align:center"><span class="label label-info">43</span></td>
							</tr>
							<tr>
								
								<td class="center">
									Closed - Won
								</td>
								<td style="text-align:center"><span class="label label-success">176</span></td>
							</tr>
							<tr>
								
								<td class="center">
									Closed - Lost
								</td>
								<td style="text-align:center"><span class="label label-success">46</span></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- Leads Summary Stats -->
		</div>
		
		<div class="span9">

			<!-- Leads Summary -->
			<div class="widget-box">
				<div class="widget-title">
					<h2><i class="icon-bars"><xsl:text>
						</xsl:text></i>Latest Leads</h2>
				</div>
				
				<div class="widget-content no-padding" style="min-height:185px">
					<table class="clean-link footable" style="font-size: 12px;margin-bottom:0">
						<thead>
							<tr>
								<th data-sort-ignore="true" style="width:100px" data-class="expand">From</th>
								<th data-sort-ignore="true" style="width:100px">Status</th>
								<th data-sort-ignore="true" data-hide="phone" data-class="leftalign" class="leftalign">Buyer Message</th>
								<th data-sort-ignore="true" data-hide="phone" style="width:100px">Created</th>
								<th data-sort-ignore="true" data-hide="all">Listing Code</th>
								<th data-sort-ignore="true" data-hide="all">Listing Stock Number</th>
								<th data-sort-ignore="true" data-hide="all">Listing Title</th>
								<th data-sort-ignore="true" data-hide="all">Listing Price</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><a href="/leads/edit">Jose Hiquana</a></td>
								<td><span class="label label-important">Unassigned</span></td>
								<td><a href="/leads/edit">Hello, just wanting to know the best price you can do on this car please. I have a 2003 commodore to trade...</a></td>
								<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013<br />10:47 AM</td>
								<td>000000000</td>
								<td>000000000</td>
								<td>2009 FORD RANGER XL (4x2) PK C/CHAS</td>
								<td>$ 24,990</td>
							</tr>
							<tr>
								<td><a href="/leads/edit">Jose Hiquana</a></td>
								<td><span class="label label-warning">Assigned</span></td>
								<td><a href="/leads/edit">Hello, just wanting to know the best price you can do on this car please. I have a 2003 commodore to trade...</a></td>
								<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013<br />10:47 AM</td>
								<td>000000000</td>
								<td>000000000</td>
								<td>2009 FORD RANGER XL (4x2) PK C/CHAS</td>
								<td>$ 24,990</td>
							</tr>
							<tr>
								<td><a href="/leads/edit">Jose Hiquana</a></td>
								<td><span class="label label-success">Close - Won</span></td>
								<td><a href="/leads/edit">Hello, just wanting to know the best price you can do on this car please. I have a 2003 commodore to trade...</a></td>
								<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013<br />10:47 AM</td>
								<td>000000000</td>
								<td>000000000</td>
								<td>2009 FORD RANGER XL (4x2) PK C/CHAS</td>
								<td>$ 24,990</td>
							</tr>
							<tr>
								<td><a href="/leads/edit">Jose Hiquana</a></td>
								<td><span class="label label-info">Follow Up</span></td>
								<td><a href="/leads/edit">Hello, just wanting to know the best price you can do on this car please. I have a 2003 commodore to trade...</a></td>
								<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013<br />10:47 AM</td>
								<td>000000000</td>
								<td>000000000</td>
								<td>2009 FORD RANGER XL (4x2) PK C/CHAS</td>
								<td>$ 24,990</td>
							</tr>
							<tr>
								<td><a href="/leads/edit">Jose Hiquana</a></td>
								<td><span class="label label-success">Close - Lost</span></td>
								<td><a href="/leads/edit">Hello, just wanting to know the best price you can do on this car please. I have a 2003 commodore to trade...</a></td>
								<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013<br />10:47 AM</td>
								<td>000000000</td>
								<td>000000000</td>
								<td>2009 FORD RANGER XL (4x2) PK C/CHAS</td>
								<td>$ 24,990</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- Leads Summary -->

			
		</div>
		
	</div>

</xsl:template>

</xsl:stylesheet>