<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:RESTscripts="urn:RESTscripts.this"
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:scripts="urn:scripts.this"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	
	<xsl:include href="EasyListRestHelper.xslt" />
	
	<xsl:param name="currentPage"/>
	
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('IsPostBack') = 'true'" />
	
	<xsl:variable name="ccType" select="umbraco.library:Request('ccType')" />
	<xsl:variable name="ccNo" select="umbraco.library:Request('ccNo')" />
	<xsl:variable name="ccName" select="umbraco.library:Request('ccName')" />
	<xsl:variable name="ccMonth" select="umbraco.library:Request('ccMonth')" />
	<xsl:variable name="ccYear" select="umbraco.library:Request('ccYear')" />
	<xsl:variable name="TotalCost" select="umbraco.library:Request('TotalCost')" />
	
	<xsl:variable name="coupon" select="umbraco.library:Request('coupon')" />
	
	<!-- Load amount to pay based on temp listng, redirect back to New Listing Landing Page if not listing found -->
	<xsl:variable name="NewListingLoadResponse" select="RESTscripts:NewListingTempLoad()" />
	<xsl:variable name="data" select="$NewListingLoadResponse/ListingsRestInfo" />
		
	<xsl:template match="/">
		<!-- <textarea>
	 <xsl:value-of select="string-length($data) &gt; 0"/>
	</textarea> -->
		
		
		<xsl:choose>
			<xsl:when test="$IsPostBack = 'true'">
				<!-- Payment, publish listing amd then Redirect to listing editing page after payment success -->
				<xsl:variable name="PaymentResponse" select="RESTscripts:NewListingPayment()" />	
				
				<xsl:variable name="SaveUserNewsLetterSubscriptionFlagResponse" select="RESTscripts:SaveUserNewsLetterSubscriptionFlag()" />
				
				<xsl:choose>
					<!-- Success -->
					<xsl:when test="substring-before($PaymentResponse, ':') = 'SUCCESS'">
						<xsl:variable name="successUrl" select="concat('/listings/edit?IsNew=true&amp;listing=', substring-after($PaymentResponse, ':'))" />
						<!-- <xsl:value-of select="RESTscripts:RedirectTo($successUrl)" /> -->
						
						<div class="alert alert-success">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Thank you!</strong>Thank you for using the Trading Post to sell your item.
							<!--
							<br /><br />
							
							<br /><br />
							Your ad is now in the review queue, and will be normally published within 4 hours during business hours, or on the next business day outside these hours.
							<br /><br />
							You can check the status of your ad in the EasyList dashboard at <a href="https://dashboard.easylist.com.au/login">https://dashboard.easylist.com.au/login</a>.
							<br />Meanwhile, you can edit your ad <a href ="{$successUrl}">here</a>, or <a href ="/listings/landing">place another new ad.</a>
							<br /><br />
							Great to have you on board and good luck with your sale!
							-->
							<!--
							<strong>Success!</strong> Your new ad has now been successfully submitted, and will normally appear on the Tradingpost.com.au website within an hour.
							<br/>
							-->
							<!--<br/> Click <a href ="{$successUrl}">here</a> to edit the lisitng.
			  				<br/> Click <a href ="/listings/landing">here</a> to continue create new listing-->
							<!--<br/> Please click to <a href="/">go to your ad tools dashboard</a>, <a href ="{$successUrl}">edit your new ad</a>, or <a href ="/listings/landing">place another ad.</a>
							-->
						</div>
						<div class="">
							<br/>
							<p>
								<i class="icon-info">&nbsp;</i>
								<b>To help protect buyers and sellers from frauds, scams, and spam, all Trading Post ads are now human checked by our Review Team before they are sent live. </b>
								<br />&nbsp;&nbsp;
								Your ad is now in the review queue, and will be normally published within 4 hours during business hours, or on the next business day outside these hours.
							</p>
							<br/>
							<p>
								<i class="icon-info">&nbsp;</i>
								You can check the status of your ad in the EasyList dashboard at <a href="https://dashboard.easylist.com.au/login">https://dashboard.easylist.com.au/login</a>.
								<br />&nbsp;&nbsp;Meanwhile, you can edit your ad <a href ="{$successUrl}">here</a>, or <a href ="/listings/landing">place another new ad.</a>
								<br /><br />
								Great to have you on board and good luck with your sale!
							</p>
						</div>
						
						
						<xsl:if test="$TotalCost != '0.00' and $coupon = ''">
							<xsl:call-template name="PaymentSuccess"/>
						</xsl:if> 
					</xsl:when>
					<!-- Error -->
					<xsl:otherwise>
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Oops!</strong> There was a problem processing your payment: <xsl:copy-of select="$PaymentResponse" />
						</div>
						<xsl:call-template name="checkout"/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			<xsl:when test="string-length($data) &lt;= 0">
				<div class="alert alert-error">
					<button data-dismiss="alert" class="close" type="button">×</button>
					<strong>Oops!</strong> Too much time has passed, and we can no longer process your payment
					<br/>
					<br/> Please click <a href ="/listings/landing">here</a> to create new ad. 
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="checkout"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- CHECKOUT TEMPLATE -->
	<xsl:template name="checkout">
		<br/>
		<div class="widget-box">
			<div class="widget-title">
				<h2>
					<i class="icon-cart">
						<xsl:text>
						</xsl:text>
					</i><span class="break">&nbsp;</span> Checkout
				</h2>
			</div>
			<div class="widget-content">
				<form id="form-checkout" class= "form-horizontal break-desktop-large" method="post">
					<!-- FORM CONTENT TEMPLATE CALLS -->
					<div style="margin-top:-10px">
						<!--<xsl:call-template name="member-iframe" />-->
						<xsl:call-template name="package" />
						<div id="cc-check" class="hidden">
							<xsl:call-template name="coupon" />
							<xsl:call-template name="creditcard" />
						</div>
					</div>
							
					<!-- /FORM CONTENT TEMPLATE CALLS -->
					<div class="form-actions center" style="margin-top:0;">
						<input type="hidden" id="ListingPostAmount" name="ListingPostAmount" value="{$data/ListingPostAmount}" />   
						<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />      
						<!-- <button type="button" class="btn">Preview</button>
			&nbsp; -->
										
						<div style="text-align:left; margin-bottom:20px;">
							<input type="checkbox" name="UserNewsLetterSubscriptionFlag" id="UserNewsLetterSubscriptionFlag">
								 <xsl:if test="RESTscripts:GetUserNewsLetterSubscriptionFlag() = 'yes'">
									   <xsl:attribute name="checked">checked</xsl:attribute>
								   </xsl:if>
							</input> Subscribe to our newsletter
						</div>
						
						<input id="submit" class="btn btn-success" type="submit" value="Pay Now and Submit" />
						
						<div id="status">
							<xsl:text>
							</xsl:text>
						</div>
					</div>
					
					<div id="submitted">
						<xsl:text>
						</xsl:text>
					</div>
					
				</form>
			</div>
		</div>
		<!-- /widget-box -->
	</xsl:template>
	<!-- /CHECKOUT TEMPLATE -->
	
	<!-- ===== CONTENT TEMPLATES ===== -->
	<xsl:template name="member-iframe">
		<fieldset id="member-check">
			<legend>Have you sold on Tradingpost before?</legend>
			
			<div class="row-fluid" style="margin-bottom:10px;">
				<div class="span6">
					<button type="button" id="member-registered" class="btn btn-info pull-right" style="width:250px;">
						YES! I am already a registered member
					</button>
				</div>
				<div class="span6">
					<button type="button" id="member-registered" class="btn pull-left" style="width:250px;">
						No. This is my first ad and I need to sign up
					</button>
				</div>
			</div>
			
		</fieldset>
	</xsl:template>
	
	<xsl:template name="member">
		<fieldset id="member-check">
			<legend>Have you sold on Tradingpost before?</legend>
			
			<br />
			
			<label class="radio">
				<!--<a data-toggle="lightbox" href="#demoLightbox">Open Lightbox</a>
		<div id="demoLightbox" class="lightbox hide fade"  tabindex="-1" role="dialog" aria-hidden="true">
		  <div class='lightbox-content'>
			<img src="image.png"/>
			<div class="lightbox-caption"><p>Your caption here</p></div>
		  </div>
		</div>-->
				
				<input type="radio" name="member" value="true" class="required" /> <strong>YES! I am already a registered member</strong>
			</label>
			<label class="radio">
				<input type="radio" name="member" value="false" class="required" /> <strong>No. This is my first ad and I need to sign-up</strong>
			</label>
			
			<label for="member" generated="true" class="error" style="display:none">
				<xsl:text>
				</xsl:text>
			</label>
			
			<div id="member-login" class="well form-horizontal hidden" style="margin-bottom:10px">
				
				<div class="control-group">
					<label class="control-label">User Name</label>
					<div class="controls">
						<input type="text" name="username" class="input-xlarge" />
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Password</label>
					<div class="controls">
						<input type="password" name="password" class="input-xlarge" />
					</div>
				</div>
				
				<div class="control-group">
					<div class="controls">
						<button type="button" class="btn" id="new-member-submit">Login</button>
					</div>
				</div>
				
			</div>
			
			<div id="member-register" class="well form-horizontal hidden">
				
				<div class="control-group">
					<label class="control-label">Email</label>
					<div class="controls">
						<input type="text" name="email" class="input-xlarge email required" />
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Contact Mobile</label>
					<div class="controls">
						<input type="text" name="contact" class="input-xlarge">
							<xsl:attribute name="data-validate">{required: true, regex:/^((?:\s*\d\s*)){10}$/, messages: {regex: 'The contact mobile entered is invalid'}}</xsl:attribute>
						</input>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Password</label>
					<div class="controls">
						<input type="password" name="NewPassword" id="NewPassword" value="" class="input-xlarge" data-password-meter="true">
							<xsl:attribute name="data-validate"><![CDATA[{regex:/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[\w\s!@#$%^&*]{8,20}$/ ,required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter new password!', regex:'Please enter at least 8 characters with one or more of each: uppercase[A-Z], lowercase[a-z], number[0-9] and symbols[!@#$%^&]'}}]]></xsl:attribute>
						</input>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Re-enter Password</label>
					<div class="controls">
						<input type="password" name="ConfirmPassword" id="ConfirmPassword" value="" class="input-xlarge">
							<xsl:attribute name="data-validate">{equalTo: '#NewPassword', minlength: 8, maxlength: 20}</xsl:attribute>
						</input>
					</div>
				</div>
				
			</div>
			
			<br />
			
		</fieldset>
	</xsl:template>
	<!-- /MEMBER CHECK TEMPLATE -->
	
	<xsl:template name="package">
		
		<fieldset id="package">
			<legend>Choose your upgrade</legend>
			
			<div class="row-fluid">
				<div class="span6">
					<div class="well">
						<label class="packagebox" for="p1" data-price="0">
							<h2>
								Standard Ad
								<small>9 photos and unlimited changes to your ad</small>
							</h2>
							<div class="price">&nbsp;</div>
							<figure>
								<img src="/images/tp/checkout_standard.jpg" alt="" />
							</figure>
							<ul>
								<li>Advertise until sold</li>
								<li>Unlimited changes to your ad </li>
								<li>Up to 9 photos</li>
							</ul>
							<input id="p1" type="radio" class="hidden" name="package" value="standard">
								<xsl:attribute name="data-validate">{required: true, messages: { required: 'Please select your package.' }}</xsl:attribute>
							</input>
						</label>
					</div>
				</div>
				
				<div class="span6">
					<div class="well">
						<label class="packagebox" for="p2" data-price="20">
							<h2>
								Get noticed for only $20 extra!
								<small>All standard ad features plus more</small>
							</h2>
							<div class="price">&nbsp;</div>
							<figure>
								<img src="/images/tp/checkout_noticed.jpg" alt="" />
							</figure>
							<ul>
								<li>Stand out with <strong>Priority Ads Carousel</strong> in search results</li>
								<li>Get <strong>Blue Priority Badge</strong> on your ads</li>
								<li><strong>Plus</strong> all standard package features</li>
							</ul>
							<input id="p2" type="radio" class="hidden" name="package" value="noticed">
								<xsl:attribute name="data-validate">{required: true, messages: { required: 'Please select your package.' }}</xsl:attribute>
							</input>
						</label>
					</div>
				</div>
			</div>
			
			<div class="package-error">
				<label for="package" generated="true" class="error" style="display: none;">
					<xsl:text>
					</xsl:text>
				</label>
			</div>
			
			<div class="total-cost">
				<input id="TotalCost" name="TotalCost" type="hidden"  value="{scripts:FormatAmount($data/ListingPostAmount)}"/>
				<h3>
					Total amount due now
					<small>All prices are inclusive of GST</small>
					<strong>
						$<xsl:value-of select="scripts:FormatAmount($data/ListingPostAmount)"/>
					</strong>
				</h3>
			</div>
			
		</fieldset>
	</xsl:template>
	<!-- /PACKAGE TEMPLATE -->
	
	<xsl:template name="creditcard">
		<fieldset style="margin-bottom:20px;" id="CCCardInfo" >
			<legend>Paying for your ad</legend>
			<div class="cc-fields-reset">
				<div class="control-group">
					<label class="control-label">Credit Card Type</label>
					<div class="controls">
						<label class="radio inline">  
							<input type="radio" name="ccType" value="Mastercard" checked="checked" />
							<img class="retina" src="/images/payments/mastercard.png" alt="Mastercard" style="width:51px;height:32px" />
						</label>
						<label class="radio inline">  
							<input type="radio" name="ccType" value="Visa" />
							<img class="retina" src="/images/payments/visa.png" alt="Visa" style="width:51px;height:32px" />
						</label>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Credit Card No.</label>
					<div class="controls">
						<input type="text" class="input-xlarge required" id="ccNo" name="ccNo" value="" maxlength="16" autocomplete="off">
							<xsl:attribute name="data-validate">{required: false, regex:/^\d{16}$/, minlength: 16, maxlength: 16, messages: {required: 'Please enter the Credit Card No.'}}</xsl:attribute>
						</input>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Card Holder Name</label>
					<div class="controls">
						<input type="text" class="input-xlarge required" id="ccName" name="ccName" value="" autocomplete="off">
							<xsl:attribute name="data-validate">{required: false, minlength: 3, maxlength: 200, messages: {required: 'Please enter the Card Holder Name'}}</xsl:attribute>
						</input>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Expiry</label>
					<div class="controls">
						<select name="ccMonth" class="input-small">
							<option value="0">MM</option>
							<option value="01" selected="selected">01</option>
							<option value="02">02</option>
							<option value="03">03</option>
							<option value="04">04</option>
							<option value="05">05</option>
							<option value="06">06</option>
							<option value="07">07</option>
							<option value="08">08</option>
							<option value="09">09</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
						</select>
						&nbsp;
						<select name="ccYear" class="input-small">
							<option value="0">YYYY</option>
							<option value="2013">2013</option>
							<option value="2014">2014</option>
							<option value="2015">2015</option>
							<option value="2016">2016</option>
							<option value="2017">2017</option>
							<option value="2018" selected="selected">2018</option>
							<option value="2019">2019</option>
							<option value="2020">2020</option>
							<option value="2021">2021</option>
							<option value="2022">2022</option>
							<option value="2023">2023</option>
							<option value="2024">2024</option>
							<option value="2024">2025</option>
							<option value="2024">2026</option>
							<option value="2024">2027</option>
							<option value="2024">2028</option>
							<option value="2024">2029</option>
							<option value="2024">2030</option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">CVV2</label>
					<div class="controls">
						<input type="password" id="ccCvv2" name="ccCvv2" maxlength="3" value="" class="input-small required" autocomplete="off">
						</input>
						&nbsp;
						<span class="cvv2">
							<img class="retina" src="/images/payments/ccback.png" alt="CVV2" id="CVV2" style="height:16px" />
							&nbsp;<strong>last 3 digits</strong> on back of your credit card
						</span>
					</div>
				</div>
			</div>
		</fieldset>
	</xsl:template>
	<!-- /PAYMENT TEMPLATE -->
	
	<!-- PAYMENT SUCCESS -->
	<xsl:template name="PaymentSuccess">
		<div class="widget-box">
			<div class="widget-title"><h2><i class="icon-checkmark">&nbsp;</i> Payment Approved</h2></div>
			<div class="widget-content no-padding">
				<form>
					<table class="table table-balance table-balance-info table-balance-paid">
						<tbody>
							<tr>
								<th>Payment Type</th>
								<td>Credit Card</td>
							</tr>
							<tr>
								<th>Credit Card Type.</th>
								<td style="padding:2px 8px;">
									<xsl:choose>
										<xsl:when test="$ccType = 'Visa'">
											<img class="retina" src="/images/payments/visa.png" alt="Visa" style="width:51px;height:32px" />
										</xsl:when>
										<xsl:otherwise> 
											<img class="retina" src="/images/payments/mastercard.png" alt="Mastercard" style="width:51px;height:32px" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<th>Credit Card No.</th>
								<td><xsl:value-of select="$ccNo" /></td>
							</tr>
							<tr>
								<th>Card Holder Name</th>
								<td><xsl:value-of select="$ccName" /></td>
							</tr>
							<tr>
								<th>Charge Amount</th>
								<td>$<xsl:value-of select="$TotalCost"/></td>
							</tr>
							<tr class="notice">
								<td colspan="2">
									Thank you, your payment of $<xsl:value-of select="$TotalCost"/> has been processed.
									<br/>Please check your email for payment confirmation.
								</td>
							</tr>
						</tbody>
					</table>
					<div class="form-actions center">
						<a href="/listings" class="btn btn-large">Done</a>
						&nbsp;
						<!-- <a href="/user/receipt" class="btn btn-large"><i class="icon-print">&nbsp;</i> Print</a> -->
					</div>
				</form>
			</div>
		</div>
	</xsl:template>
	<!-- /PAYMENT SUCCESS -->
	
	<!-- COUPON TEMPLATE -->
	<xsl:template name="coupon">
		<fieldset id="cc-coupon" style="margin-bottom:20px;">
			<legend>Have a Coupon Code?</legend>
			
			<div class="control-group">
				<label class="control-label"><small>(optional)</small> Enter Coupon Code</label>
				<div class="controls">
					<input type="text" class="input-xlarge" id="coupon" name="coupon" autocomplete="off" />
				</div>
			</div>
			
		</fieldset>
	</xsl:template>
	<!-- /COUPON TEMPLATE -->
	
	<!-- C# helper scripts -->
	<msxml:script language="C#" implements-prefix="scripts">
		<![CDATA[
	
	public string FormatAmount(double Amount){
	  return string.Format("{0:0.00}", Amount);
	}
	
	

	]]>
	</msxml:script>
	
</xsl:stylesheet>