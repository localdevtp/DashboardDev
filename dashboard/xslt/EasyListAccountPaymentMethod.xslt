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
  
  
  <xsl:variable name="IsPostBackSaveCC" select="umbraco.library:Request('Save-CC')" />
	<xsl:variable name="IsPostBackDelCC" select="umbraco.library:Request('Delete-CC')" />
  <xsl:variable name="IsPostBackCreateCC" select="umbraco.library:Request('Create-CC')" />
  <xsl:variable name="StaffAccInfo" select="ActScripts:GetAccountInfo()" />
  <xsl:variable name="CCInfo" select="ActScripts:GetCustomerCreditCard()" />
  
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		<!-- start writing XSLT -->
		<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Account')" /> 
		<xsl:choose>
			<xsl:when test="$IsAuthorized = false">
				<div class="alert alert-error">
					<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="IsAccountExits" select="ActScripts:IsAccountExits()" /> 
				<xsl:choose>
					<xsl:when test="$IsAccountExits = false">
						<div class="alert">
							No master account exists for your login id.
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="LoadPage">
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- Modal dialog for cc delete confirmation -->
		<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h3 id="myModalLabel">Remove Payment Information</h3>
			</div>
			<div class="modal-body">
				<p>Are you sure want to remove the credit card data?</p>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
				<button id="ConfirmDeleteCC" class="btn btn-primary">Yes</button>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="LoadPage" >
		<xsl:call-template name="PaymentMethodEditor">
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="PaymentMethodEditor">
		<!-- /Payment Method Information -->
		<!--  <textarea>
	<xsl:value-of select="$IsPostBackDelCC" />
  </textarea>
	 -->
	<xsl:choose>
    
		<!-- Remove Credit Card -->
		<xsl:when test="$IsPostBackDelCC = 'true'"> 
			<xsl:variable name="DeleteResponse" select="ActScripts:DeleteCreditCard()" />
			<xsl:choose>
				<!-- Check if error message is not empty -->
				<xsl:when test="string-length($DeleteResponse) &gt; 0">
					<div class="alert alert-error">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Failed!</strong> Failed to remove credit card info. Error : <xsl:copy-of select="$DeleteResponse" />
					</div>
					<xsl:call-template name="PaymentMethodInfo">
						<xsl:with-param name="Show">
							<xsl:text>False</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="PaymentMethodEdit">
						<xsl:with-param name="Show">
							<xsl:text>True</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<!-- Success without error -->
				<xsl:otherwise>
					<div class="alert alert-success">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Success!</strong> The credit card info was remove successfully.
					</div>
					<xsl:call-template name="PaymentMethodInfo">
						<xsl:with-param name="Show">
							<xsl:text>True</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="PaymentMethodEdit">
						<xsl:with-param name="Show">
							<xsl:text>False</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		
		<!-- Save Credit Card -->
		<xsl:when test="$IsPostBackSaveCC = 'true'"> 
			<xsl:variable name="SaveResponse" select="ActScripts:UpdateCustomerCreditCard()" />
			<xsl:choose>
				<!-- Check if error message is not empty -->
				<xsl:when test="string-length($SaveResponse) &gt; 0">
					<div class="alert alert-error">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Failed!</strong> Failed to save credit card info. Error : <xsl:copy-of select="$SaveResponse" />
					</div>
					<xsl:call-template name="PaymentMethodInfo">
						<xsl:with-param name="Show">
							<xsl:text>False</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="PaymentMethodEdit">
						<xsl:with-param name="Show">
							<xsl:text>True</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<!-- Success without error -->
				<xsl:otherwise>
					<div class="alert alert-success">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Success!</strong> The credit card info was updated successfully.
					</div>
					<xsl:call-template name="PaymentMethodInfo">
						<xsl:with-param name="Show">
							<xsl:text>True</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="PaymentMethodEdit">
						<xsl:with-param name="Show">
							<xsl:text>False</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>

    <xsl:when test="$IsPostBackCreateCC = 'true'">
      <xsl:variable name="SaveResponse" select="ActScripts:CreateCustomerCreditCard()" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="PaymentMethodInfo">
				<xsl:with-param name="Show">
					<xsl:text>True</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="PaymentMethodEdit">
				<xsl:with-param name="Show">
					<xsl:text>False</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	
	  </xsl:template>
	  
	  <xsl:template name="PaymentMethodInfo">
      <xsl:param name="Show"/>
      <div id ="payment-info-div">
			  <xsl:if test="$Show ='False'">
				  <xsl:attribute name="style">display:none</xsl:attribute>
			  </xsl:if>
			  <xsl:choose>
				  <xsl:when test="string-length($StaffAccInfo/ELAccInfo/CustomerTokenId) &gt; 0">
					  <div class="widget-box" id="payment-info">
						  <div class="widget-title"><h2><i class="icon-credit">&nbsp;</i> Payment Information</h2></div>
						  <div class="widget-content no-padding">
							  <form id = "PaymentCCInfo" class="form-horizontal" name="paymentDeleteForm" autocomplete="off" method="post" runat="server" >
								  <table class="table table-balance table-balance-info">
									  <tbody>
										  <tr>
											  <th>Payment Type</th>
											  <td><label>Credit Card</label></td>
										  </tr>
										  <tr>
											  <th>Credit Card No.</th>
											  <td><xsl:value-of select="$CCInfo/GetCustomerResponse/Customers/DirectPaymentCustomer/CardDetails/Number" /></td>
										  </tr>
										  <tr>
											  <th>Card Holder Name</th>
											  <td><xsl:value-of select="$CCInfo/GetCustomerResponse/Customers/DirectPaymentCustomer/CardDetails/Name" /></td>
										  </tr>
									  </tbody>
								  </table>
								  <input type="hidden" id="Delete-CC" name="Delete-CC" value="false" />
                  <input type="hidden" id="Save-CC" name="Save-CC" value="true" />
								  <div class="form-actions center">
                    <button type="submit" id = "payment-save" name="submit" class="btn btn-large btn-success">
                      <i class="icon-disk">&nbsp;</i> Change
                    </button>
									  <!-- <button type="submit" id = "payment-remove" name="submitDelCC" class="btn btn-large btn-danger"><i class="icon-remove">&nbsp;</i> Remove</button> -->
								  </div>
							  </form>
						  </div>
					  </div>
				  </xsl:when>
				  <xsl:otherwise>
					  <div id="NewMessage" class="alert" style="margin-top:0;">
						  You do not have a valid payment method on file.<br />
						  Please configure your payment method now to ensure uninterrupted service.
					  </div>
			      
            <!-- <a href="#" id="payment-add" class="btn btn-large btn-success"><i class="icon-plus">&nbsp;</i> Add Credit Card</a> -->
      
            <form class="form-horizontal" id ="createCustomerCreditCardForm" name="createCustomerCreditCardForm" autocomplete="off" method="post" runat="server" >
              <input type="hidden" id="Create-CC" name="Create-CC" value="true" />
              <button type="submit" id = "payment-save" name="submit" class="btn btn-large btn-success">Add Credit Card</button>
            </form>
            
				  </xsl:otherwise>
			  </xsl:choose>
			  
		  </div>
		  <!-- /Payment Method Information -->
	  </xsl:template>
	  
	  <!-- Payment Edit Template -->
	  <xsl:template name="PaymentMethodEdit"> 
		  <xsl:param name="Show"/>
      <!--  <textarea>
	<xsl:value-of select="$Show" />
  </textarea>
 -->  <div class="widget-box" id="payment-edit-form">
	<xsl:if test="$Show ='False'">
		<xsl:attribute name="style">display:none</xsl:attribute>
	</xsl:if>
	
	<div class="widget-title"><h2><i class="icon-credit">&nbsp;</i> New Payment Information </h2></div>
	<div class="widget-content">
		<form class="form-horizontal" id ="paymentEditForm" name="paymentEditForm" autocomplete="off" method="post" runat="server" >
			<div class="control-group">
				<label class="control-label">Payment Type</label>
				<div class="controls">
					<label>Credit Card</label>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Credit Card No.</label>
				<div class="controls">
					<input type="text" id="ccNo" name="ccNo" maxlength="16" autocomplete="off">
						<xsl:attribute name="data-validate">{required: true, regex:/^\d{16}$/, minlength: 16, maxlength: 16, messages: {required: 'Please enter the Credit Card No.'}}</xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="$CCInfo/GetCustomerResponse/Customers/DirectPaymentCustomer/CardDetails/Number" /> </xsl:attribute>
          </input>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Card Holder Name</label>
				<div class="controls">
					<input type="text" id="ccName" name="ccName" autocomplete="off">
						<xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 200, messages: {required: 'Please enter the Card Holder Name'}}</xsl:attribute>
            <xsl:attribute name="value"><xsl:value-of select="$CCInfo/GetCustomerResponse/Customers/DirectPaymentCustomer/CardDetails/Name" /></xsl:attribute>
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
					<input type="password" name="ccCvv2" maxlength="3" value="" class="input-small" autocomplete="off">
						<xsl:attribute name="data-validate">{required: true, regex:/^\d{3}$/, minlength: 3, maxlength: 3, messages: {required: 'Please enter CVV2'}}</xsl:attribute>
					</input>
					&nbsp;
					<span class="cvv2">
						<img class="retina" src="/images/payments/ccback.png" alt="CVV2" id="CVV2" style="height:16px"  />
						&nbsp;<strong>last 3 digits</strong> on back of your credit card
					</span>
				</div>
			</div>
			
			<input type="hidden" id="Save-CC1" name="Save-CC1" value="true" />
			<div class="form-actions center">
				<a href="#" id="cancel-payment-edit" class="btn btn-large"><i class="icon-close">&nbsp;</i> Cancel</a>
				&nbsp;
				<button type="submit" id = "payment-save2" name="submit" class="btn btn-large btn-success"><i class="icon-disk">&nbsp;</i> Save</button>
			</div>
		</form>
	</div>
	</div>
	<!-- /Payment Edit -->
	  </xsl:template> 
	  
</xsl:stylesheet>