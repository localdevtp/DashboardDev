<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:RESTscripts="urn:RESTscripts.this"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListRestHelper.xslt" />
	
	<xsl:param name="currentPage"/>
	<xsl:variable name="adminTemplate" select="/macro/AdminTemplate"/>
	
	<xsl:template match="/">
		<xsl:variable name="TempListingExists" select="RESTscripts:TempListingExists()" />
		<!--<textarea>
			<xsl:value-of select="$TempListingExists" />
		</textarea>-->
		<input type="hidden" id="TempListingExists" name="TempListingExists" value="{$TempListingExists}" />
		<!-- start writing XSLT -->
		
		<xsl:choose>
			<xsl:when test="$adminTemplate = false">
				<div class="masthead">
					<div class="container">
						<h1>
							Sell your ads at Tradingpost<br />
							<span>Select the item you're selling...</span>
						</h1>
						
						<xsl:call-template name="landing" />
						
						<!--<div class="action">
						  <h3>Not a member?</h3>
						  <a href="/login" class="btn btn-primary btn-large">Sign up for free</a>
						</div>-->
					</div>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="landing" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="landing">
		<div class="category-grid">
			<div class="row-fluid">
				<div class="span6">
					<div class="well">
						<h2>Cars, Caravans, Trucks &amp; Buses</h2>
						<ul class="quick-select">
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Automotive/Cars/Cars For Sale">Used Car</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Automotive/Cars/Hot Rods and Custom">Hot Rods and Custom Car</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Automotive/Cars/Vintage Classic">Vintage and Classic Car</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Automotive/Trucks and Buses/Trucks and Buses For Sale">Truck or Bus</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Caravans/Caravans">Caravan or Camper Trailer</a></li>
						</ul>
						<div class="select">
							<select class="selectpicker" data-style="btn-primary" data-width="100%" name="">
								<option value="">Select an item</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Cars/Cars For Sale">Used car</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Cars/Hot Rods and Custom">Hot Rods and Custom Car</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Cars/Vintage Classic">Vintage and Classic Car</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Trucks and Buses/Trucks and Buses For Sale">Truck or Bus</option>
								<option value="/listings/create.aspx?CatPath=Caravans/Caravans">Caravan or Camper Trailer</option>
							</select>
						</div>
						<div class="price">
							<strong>Total Cost</strong>
							<span>$50</span>
						</div>
					</div>
				</div>
				<div class="span6">
					<div class="well">
						<h2>Motorbikes, Boats &amp; More Auto</h2>
						<ul class="quick-select">
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Automotive/Motorbikes/Motorbikes For Sale">Motorbike or ATV</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Boats and Marine&amp;CatSel=1">Boat</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Industry&amp;CatSel=1">Heavy machinery or farm equipment</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Automotive/Go Karts and Buggies">Go kart or buggy</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Caravans/Relocatables">Relocatable</a></li>
						</ul>
						<div class="select">
							<select class="selectpicker" data-style="btn-primary" data-width="100%" name="">
								<option value="">Select an item</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Motorbikes/Motorbikes For Sale">Motorbike or ATV</option>
								<option value="/listings/create.aspx?CatPath=Boats and Marine&amp;CatSel=1">Boat</option>
								<option value="/listings/create.aspx?CatPath=Industry&amp;CatSel=1">Heavy machinery or farm equipment</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Go Karts and Buggies">Go kart or buggy</option>
								<option value="/listings/create.aspx?CatPath=Caravans/Relocatables">Relocatable</option>
							</select>
						</div>
						<div class="price">
							<strong>Total Cost</strong>
							<span>$40</span>
						</div>
					</div>
				</div>
			</div>
			<div class="row-fluid">
				<div class="span6">
					<div class="well">
						<h2>Household items, Pets &amp; Auto Accessories</h2>
						<ul class="quick-select">
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Automotive/Trailers">Trailer</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Automotive&amp;CatSel=1">Wheel, car part or accessory</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=House and Garden&amp;CatSel=1">Household, garden or outdoor item</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Sports and Leisure&amp;CatSel=1">Sport, leisure or travel item</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=Pets and Horses&amp;CatSel=1">Pet</a></li>
							<li><i class="icon-tag-2">&nbsp;</i><a href="/listings/create.aspx?CatPath=">Other</a></li>
						</ul>
						<div class="select">
							<select class="selectpicker dropup" data-style="btn-primary" data-width="100%" name="">
								<option value="">Select an item</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Trailers">Trailer</option>
								<option value="/listings/create.aspx?CatPath=Automotive&amp;CatSel=1">Wheel, car part or accessory</option>
								<option value="/listings/create.aspx?CatPath=House and Garden&amp;CatSel=1">Household, garden or outdoor item</option>
								<option value="/listings/create.aspx?CatPath=Sports and Leisure&amp;CatSel=1">Sport, leisure or travel item</option>
								<option value="/listings/create.aspx?CatPath=Pets and Horses&amp;CatSel=1">Pet</option>
								<option value="/listings/create.aspx?CatPath=">Other</option>
							</select>
						</div>
						<div class="price">
							<strong>Total Cost</strong>
							<span>$20</span>
						</div>
					</div>
				</div>
				<div class="span6">
					<div class="well">
						<h2>Or sell items priced under $500 for FREE</h2>
						<p>If the item you are selling is priced under $500, it is FREE to list on Tradingpost. 
							Excludes live animals.<br /><br /><a href="#">Fair use policy</a> applies.</p>
						<div class="select">
							<select class="selectpicker dropup" data-style="btn-primary" data-width="100%" name=""> 
								<option value="">Select an item</option>
								<option value="/listings/create.aspx?CatPath=House and Garden&amp;CatSel=1">Household item</option> 
								<option value="/listings/create.aspx?CatPath=House and Garden&amp;CatSel=1">Home renovation item</option> 
								<option value="/listings/create.aspx?CatPath=House and Garden&amp;CatSel=1">Garden or outdoor item</option> 
								<option value="/listings/create.aspx?CatPath=Sports and Leisure&amp;CatSel=1">Sport or leisure item</option> 
								<option value="/listings/create.aspx?CatPath=Sports and Leisure&amp;CatSel=1">Travel item</option>
								<option value="/listings/create.aspx?CatPath=Industry&amp;CatSel=1">Heavy machinery</option> 
								<option value="/listings/create.aspx?CatPath=Industry&amp;CatSel=1">Farm equipment</option>
								<option value="/listings/create.aspx?CatPath=Automotive&amp;CatSel=1">Parts or accessories</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Motorbikes">Motorbike or ATV</option>
								<option value="/listings/create.aspx?CatPath=Boats and Marine&amp;CatSel=1=">Boat</option>Caravan 
								<option value="/listings/create.aspx?CatPath=Automotive/Trailers">Trailer</option>
								<option value="/listings/create.aspx?CatPath=Automotive/Cars/Cars For Sale">Used car</option> 
								<option value="/listings/create.aspx?CatPath=Automotive/Cars/Vintage Classic">Classic or unique car</option>
								<option value="/listings/create.aspx?CatPath=Trucks and Buses/Trucks and Buses For Sale">Truck or bus</option>
								<option value="/listings/create.aspx?CatPath=">Other</option>
							</select>
								</div>
								<div class="price">
									<strong>Total Cost</strong>
									<span>$0</span>
								</div>
							</div>
						</div>
					</div>
				</div>
	</xsl:template>
	
</xsl:stylesheet>