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
	
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('create-account')" />
	<xsl:variable name="FirstName" select="umbraco.library:Request('FirstName')" />
	<xsl:variable name="LastName" select="umbraco.library:Request('LastName')" />
	<xsl:variable name="Email" select="umbraco.library:Request('Email')" />
	<xsl:variable name="ContactPhone" select="umbraco.library:Request('ContactPhone')" />
	<xsl:variable name="ContactFax" select="umbraco.library:Request('ContactFax')" />
	<xsl:variable name="ContactMobile" select="umbraco.library:Request('ContactMobile')" />
	<xsl:variable name="AddressLine1" select="umbraco.library:Request('AddressLine1')" />
	<xsl:variable name="AddressLine2" select="umbraco.library:Request('AddressLine2')" />
	<xsl:variable name="LoginID" select="umbraco.library:Request('LoginID')" />
	
	<xsl:variable name="CountryCode" select="umbraco.library:Request('address-country-code')" />
	<xsl:variable name="RegionID" select="umbraco.library:Request('address-region-id')" />
	<xsl:variable name="PostalCode" select="umbraco.library:Request('address-postalcode')" />
	<xsl:variable name="District" select="umbraco.library:Request('address-district')" />
	
	<xsl:variable name="ManagerGroupSet" select="umbraco.library:Request('ManagerGroup')" />
	<xsl:variable name="AccountsSet" select="umbraco.library:Request('Accounts')" />
	<xsl:variable name="EditorSet" select="umbraco.library:Request('Editor')" />
	<xsl:variable name="SalesSet" select="umbraco.library:Request('Sales')" />
	<xsl:variable name="SalesRepSet" select="umbraco.library:Request('ESSalesRep')" />
	<xsl:variable name="ESSupportSet" select="umbraco.library:Request('ESSupport')" />
	
	<xsl:variable name="HasChildList" select="AccScripts:HasChildList()"/>
	
	<xsl:param name="currentPage"/>
	
	<!-- start writing XSLT -->
	<xsl:template match="/">
		<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,EasySales Admin')" /> 
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
		
		<xsl:choose>
			<xsl:when test="$IsPostBack = 'true'">
				<xsl:variable name="CreateResponse" select="AccScripts:CreateNewStaff()" />
				<xsl:choose>
					<!-- Check if error message is not empty -->
					<xsl:when test="string-length($CreateResponse) &gt; 0">
						<div class="alert alert-error">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Failed!</strong> Failed to create new user. Error : <xsl:copy-of select="$CreateResponse" />
						</div>
						<xsl:call-template name="NewAccountCreator">
							<xsl:with-param name="HasError">
								<xsl:text>True</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<!-- Success without error -->
					<xsl:otherwise>
						<div class="alert alert-success">
							<button data-dismiss="alert" class="close" type="button">×</button>
							<strong>Success!</strong> The user was added successfully.
						</div>
						<xsl:call-template name="NewAccountCreator">
							<xsl:with-param name="HasError">
								<xsl:text>False</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="NewAccountCreator">
					<xsl:with-param name="HasError">
						<xsl:text>False</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="NewAccountCreator">
		<xsl:param name="HasError"/>
		
		<div class="widget-box">
			<div class="widget-title"><h2><i class="icon-user-add">&nbsp;</i> Add New User</h2></div>
			<div class="widget-content">
				<form id="NewAccountForm" class="form-horizontal break-desktop-large" autocomplete="off" method="post" runat="server">
					<div class="form-left">
						<xsl:if test="$HasChildList = 'true'">
							<xsl:variable name="CustomerChildDropdown" select="AccScripts:GetCustomerChildDropdown()" />
							<div class="control-group">
								<label class="control-label"><span class="important">*</span> Customer account</label>
								<div class="controls">
									<select class="drop-down" name="DealerUserCode">
										<xsl:call-template name="optionlistValue">
											<xsl:with-param name="options"><xsl:value-of select="$CustomerChildDropdown" /></xsl:with-param>
											<xsl:with-param name="value">
												<!-- <xsl:choose>
													<xsl:when test="$IsPostBack = 'true'">
														<xsl:value-of select="$LstConditionDesc" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$data/ConditionDesc" />
													</xsl:otherwise>
												</xsl:choose> -->
											</xsl:with-param>
										</xsl:call-template>
									</select>
								</div>
							</div>
						</xsl:if>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span> First Name</label>
							<div class="controls">
								<input class="input-xlarge" maxlength="50" type="text" id = "FirstName" name="FirstName">
									<xsl:attribute name="value">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
											<xsl:value-of select="$FirstName" />
										</xsl:if>
									</xsl:attribute>
									<xsl:attribute name="data-validate">{required: true, regex:/^[a-zA-Z ]*$/, minlength: 3, maxlength: 50, messages: {required: 'Please enter the First Name', regex: 'Please enter only alphabets'}}</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span> Last Name</label>
							<div class="controls">
								<input class="input-xlarge" maxlength="50" type="text" id = "LastName" name="LastName">
									<xsl:attribute name="value">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
											<xsl:value-of select="$LastName" />
										</xsl:if>
									</xsl:attribute>
									<xsl:attribute name="data-validate">{required: true, regex:/^[a-zA-Z ]*$/, minlength: 3, maxlength: 50, messages: {required: 'Please enter the Last Name', regex: 'Please enter only alphabets'}}</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span> Email</label>
							<div class="controls">
								<input type="text" name="Email" class="input-xlarge email required" value="">
									<xsl:attribute name="value">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
											<xsl:value-of select="$Email" />
										</xsl:if>
									</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span>Contact Mobile</label>
							<div class="controls">
								<input class="input-xlarge" maxlength="50" type="text" name="ContactMobile">
									<xsl:attribute name="value">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
											<xsl:value-of select="$ContactMobile" />
										</xsl:if>
									</xsl:attribute>
									<xsl:attribute name="data-validate">{required: true, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The contact mobile entered is invalid'}}</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Contact Phone</label>
							<div class="controls">
								<input class="input-xlarge" maxlength="50" type="text" name="ContactPhone">
									<xsl:attribute name="value">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
											<xsl:value-of select="$ContactPhone" />
										</xsl:if>
									</xsl:attribute>
									<xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Contact Phone'}}</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Contact Fax</label>
							<div class="controls">
								<input class="input-xlarge" maxlength="50" type="text" name="ContactFax">
									<xsl:attribute name="value">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
											<xsl:value-of select="$ContactFax" />
										</xsl:if>
									</xsl:attribute>
									<xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Contact Fax'}}</xsl:attribute>
								</input>
							</div>
						</div>
						
						<div class="control-group">
							<label class="control-label">Address line 1</label>
							<div class="controls">
								<textarea id="AddressLine1" name="AddressLine1" class="input-xlarge" style="height:80px">
									<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
										<xsl:value-of select="$AddressLine1" />
									</xsl:if>
									<xsl:text> </xsl:text>
								</textarea>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Address line 2</label>
							<div class="controls">
								<textarea id="AddressLine2" name="AddressLine2" class="input-xlarge" style="height:80px">
									<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
										<xsl:value-of select="$AddressLine2" />
									</xsl:if>
									<xsl:text> </xsl:text>
								</textarea>
							</div>
						</div>
						<div id = "MyCountrySelectHere">
							<span></span>
						</div>
					</div>
					<div class="form-right">
						<div class="control-group">
							<label class="control-label"><span class="important">*</span>Login ID</label>
							<div class="controls">
								<input type="text" name="LoginID" value="" class="input-xlarge required">
									<xsl:attribute name="value">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
											<xsl:value-of select="$LoginID" />
										</xsl:if>
									</xsl:attribute>
									<xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 50, messages: {required: 'Please enter the Login ID!'}}</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span> Password</label>
							<div class="controls">
								<input type="password" name="NewPassword" id="NewPassword" value="" class="input-xlarge required" data-password-meter="true" data-password-meter-placement="top">
									<xsl:attribute name="data-validate"><![CDATA[{regex:/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[\w\s!@#$%^&*]{8,20}$/ ,required: false, minlength: 8, maxlength: 20, messages: {required: 'Please enter the password.', regex:'Please enter at least 8 characters with one or more of each: uppercase[A-Z], lowercase[a-z], number[0-9] and symbols[!@#$%^&]'}}]]></xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label"><span class="important">*</span> Re-enter Password</label>
							<div class="controls">
								<input type="password" name="ConfirmPassword" value="" class="input-xlarge">
									<xsl:attribute name="data-validate">{equalTo: '#NewPassword', minlength: 6, maxlength: 20}</xsl:attribute>
								</input>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">Roles&nbsp;&nbsp;<i id="roles-help" class="icon-info-2 info"><xsl:text>
								</xsl:text></i></label>
							<div class="controls">
								<label class="checkbox">
									<input type="checkbox" id ="ManagerGroup" name ="ManagerGroup"  value="true">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True' and $ManagerGroupSet = 'true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									Manager
								</label>
								<label class="checkbox">
									<input type="checkbox" id="Accounts" name ="Accounts"  value="true">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True' and $AccountsSet = 'true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>Account
								</label>
								<label class="checkbox">
									<input type="checkbox" id="Editor" name ="Editor"  value="true">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True' and $EditorSet = 'true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>Editor
								</label>
								<label class="checkbox">
									<input type="checkbox" id="Sales" name ="Sales"  value="true">
										<xsl:if test="$IsPostBack = 'true' and $HasError = 'True' and $SalesSet = 'true'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>Sales
								</label>
								<xsl:variable name="IsESAdmin" select="AccScripts:IsAuthorized('EasySales Admin')" /> 
								<xsl:if test="$IsESAdmin != false">
									<label class="checkbox">
										<input type="checkbox" id="ESSalesRep" name ="ESSalesRep"  value="true">
											<xsl:if test="$IsPostBack = 'true' and $HasError = 'True' and $SalesRepSet = 'true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>UW Sales Rep
									</label>
									<label class="checkbox">
										<input type="checkbox" id="ESSupport" name ="ESSupport"  value="true">
											<xsl:if test="$IsPostBack = 'true' and $HasError = 'True' and $ESSupportSet = 'true'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>UW Support
									</label>
								</xsl:if>
							</div>
						</div>
					</div>
					
					<input type="hidden" id="HasError" name="HasError" value="" >
						<xsl:attribute name="value">
							<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
								<xsl:value-of select="$HasError" />
							</xsl:if>
						</xsl:attribute>
					</input>
					
					<input type="hidden" id="address-country-code" name="address-country-code">
						<xsl:attribute name="value">
							<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
								<xsl:value-of select="$CountryCode" />
							</xsl:if>
						</xsl:attribute>
					</input>
					
					<input type="hidden" id="address-country-name" name="address-country-name" value="" />
					
					<input type="hidden" id="address-region-id" name="address-region-id" value="">
						<xsl:attribute name="value">
							<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
								<xsl:value-of select="$RegionID" />
							</xsl:if>
						</xsl:attribute>
					</input>
					<input type="hidden" id="address-region-name" name="address-region-name" value="" />
					
					<input type="hidden" id="address-postalcode" name="address-postalcode" value="">
						<xsl:attribute name="value">
							<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
								<xsl:value-of select="$PostalCode" />
							</xsl:if>
						</xsl:attribute>
					</input>
					<input type="hidden" id="address-district" name="address-district" value="" >
						<xsl:attribute name="value">
							<xsl:if test="$IsPostBack = 'true' and $HasError = 'True'">
								<xsl:value-of select="$District" />
							</xsl:if>
						</xsl:attribute>
					</input>
					
					<input type="hidden" id="create-account" name="create-account" value="true" />
					<div class="form-actions center">
						<a href="/staff" class="btn btn-large"><i class="icon-chevron-left">&nbsp;</i> Back</a>&nbsp;
						<button type="submit" id="add-account" name="submit" class="btn btn-large btn-success"><i class="icon-plus">&nbsp;</i> Add New User</button>
					</div>
				</form>
			</div>
		</div>
		<!-- Create Accounts -->
		
	</xsl:template>
	
	<xsl:template name="optionlistValue">
        <xsl:param name="options"/>
        <xsl:param name="value"/>
        
        <xsl:for-each select="umbraco.library:Split($options,'|')//value">
            <option>
                <xsl:attribute name="value">
                    <xsl:value-of select="substring-before(., ';')" />
                </xsl:attribute>
                <!-- check to see whether the option should be selected-->
                <xsl:if test="$value=substring-before(., ';')">
                    <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test=". !=''">
                        <xsl:value-of select="substring-after(., ';')" />
                    </xsl:when>
                    <xsl:otherwise>Select an option</xsl:otherwise>
                </xsl:choose>
            </option>
        </xsl:for-each>
    </xsl:template>
	
</xsl:stylesheet>