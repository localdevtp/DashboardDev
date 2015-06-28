<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:AccScripts="urn:AccScripts.this"
xmlns:ActScripts="urn:ActScripts.this"
xmlns:leadsapi="urn:leadsapi"
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
exclude-result-prefixes="msxml leadsapi umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:include href="EasyListStaffHelper.xslt" />
  <xsl:include href="EasyListAccountHelper.xslt" />
  <xsl:include href="LeadsAPIHelper.xslt" />

  <xsl:variable name="LoginID" select="umbraco.library:Session('easylist-username')" />
  <xsl:variable name="IsPostBack" select="umbraco.library:Request('update-account')" />

  <xsl:variable name="LeadsNotificationBy" select="umbraco.library:Request('LeadsNotificationBy')" />
  <xsl:variable name="LeadsEmail" select="umbraco.library:Request('LeadsEmail')" />
  <xsl:variable name="LeadsPhoneNo" select="umbraco.library:Request('LeadsPhoneNo')" />
  <xsl:variable name="LeadSetting" select="umbraco.library:Request('LeadSetting')" />
  <xsl:variable name="IsRetailUser" select="AccScripts:IsRetailUser()" />
  <xsl:variable name="IsBlockAccess" select="leadsapi:GetIsBlockAccess()" />

  <xsl:param name="currentPage"/>

  <xsl:template match="/">

    <!--<xsl:variable name="IsAuthorized" select="true"/>-->
    <xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,RetailUser')" />
   
    <xsl:choose>
      <xsl:when test="$IsAuthorized = false">
        <div class="alert alert-error">
          <strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
        </div>
      </xsl:when>
      <xsl:when test="$IsBlockAccess = 'true'">
        <div class="alert alert-error">
          <strong>Unfortunately, you are blocked from accessing this resource at this point in time.</strong>
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
        <!-- Update Account -->
        <xsl:variable name="UpdateResponse" select="AccScripts:UpdateLeadsSettings()" />
        <xsl:choose>
          <!-- Check if error message is not empty -->
          <xsl:when test="string-length($UpdateResponse) &gt; 0">
            <div class="alert alert-error">
              <button data-dismiss="alert" class="close" type="button">×</button>
              <strong>Failed!</strong> Failed to update your leads settings. Error : <xsl:copy-of select="$UpdateResponse" />
            </div>
            <xsl:call-template name="DealerEditor">
              <xsl:with-param name="HasError">
                <xsl:text>True</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <!-- Success without error -->
          <xsl:otherwise>
            <div class="alert alert-success">
              <button data-dismiss="alert" class="close" type="button">×</button>
              <strong>Success!</strong> Your leads settings was updated successfully.
            </div>
            <xsl:call-template name="DealerEditor">
              <xsl:with-param name="HasError">
                <xsl:text>False</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="DealerEditor">
          <xsl:with-param name="HasError">
            <xsl:text>False</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="DealerEditor">
    <xsl:param name="HasError"/>

    <xsl:variable name="DealerAccountingInfo" select="ActScripts:GetDealerAccountInfo($LoginID, 1)" />
    <xsl:variable name="DealerActInfo" select="$DealerAccountingInfo/ELAccInfo" />

    <xsl:variable name="DealerCustInfo" select="AccScripts:GetCustomerInfo($LoginID)" />
    <xsl:variable name="DealerCustParent" select="AccScripts:GetCustomerParent($LoginID)" />

    <div class="widget-box">
      <div class="widget-title">
        <h2>
          <i class="icon-bars">&nbsp;</i> Leads Settings
        </h2>
      </div>
      <div class="widget-content">
        <fieldset style="margin-top:-10px;">
          <legend>Leads Notification Settings</legend>
          <div class="form-left">
            <!-- <textarea>
						<xsl:value-of select="$LoginID"/>
						<xsl:value-of select="$DealerCustParent"/>
					</textarea> -->
            <xsl:if test="$DealerCustParent/Users/UserName != ''">
              <div class="control-group">
                <label class="control-label"> Lead Settings</label>
                <div class="controls">
                  <input type="radio" name="LeadSetting" value="OwnSet" onclick="$('.LeadSettingsGroup').show();">
                    <xsl:choose>
                      <xsl:when test="$IsPostBack = 'true'">
                        <xsl:if test="$LeadSetting = 'OwnSet'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </xsl:when>
                      <xsl:when test="$DealerCustInfo/Users/LeadSetting = 'OwnSet'">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="checked">checked</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    Own settings
                  </input>
                  <br/>
                  <input type="radio" name="LeadSetting" value="Inherit" onclick="$('.LeadSettingsGroup').hide();">
                    <xsl:choose>
                      <xsl:when test="$IsPostBack = 'true'">
                        <xsl:if test="$LeadSetting = 'Inherit'">
                          <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                      </xsl:when>
                      <xsl:when test="$DealerCustInfo/Users/LeadSetting = 'Inherit'">
                        <xsl:attribute name="checked">checked</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    Inherit from <xsl:value-of select="$DealerCustParent/Users/DealerName" />
                  </input>
                </div>
              </div>
            </xsl:if>
            <div class="control-group LeadSettingsGroup">
              <xsl:if test="$DealerCustInfo/Users/LeadSetting = 'Inherit'">
                <xsl:attribute name="style">display: none;</xsl:attribute>
              </xsl:if>
              <label class="control-label"> Lead Notifications By</label>
              <div class="controls">
                <select class="input-xlarge" id="LeadsNotificationBy" name="LeadsNotificationBy">
                  <xsl:call-template name="optionlist">
                    <xsl:with-param name="options">None,Email,SMS,Email and SMS</xsl:with-param>
                    <xsl:with-param name="value">
                      <xsl:choose>
                        <xsl:when test="$IsPostBack = 'true'">
                          <xsl:value-of select="$LeadsNotificationBy" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:choose>
                            <xsl:when test="$DealerActInfo/SalesLead_Type = ''">Email and SMS</xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="$DealerActInfo/SalesLead_Type" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:with-param>
                  </xsl:call-template>
                </select>
              </div>
            </div>
          </div>
          <div class="form-right LeadSettingsGroup">
            <xsl:if test="$DealerCustInfo/Users/LeadSetting = 'Inherit'">
              <xsl:attribute name="style">display: none;</xsl:attribute>
            </xsl:if>
            <div class="LeadsEmailSet">
              <div class="control-group">
                <label class="control-label">
                  <span class="important">*</span>&nbsp;Email Leads to
                  <i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="This is the email address lead notifications will be sent to.">
                    <xsl:text>
								</xsl:text>
                  </i>
                </label>
                <div class="controls">
                  <input type="text" id="LeadsEmail1" name="LeadsEmail" class="input-xlarge email">
                    <xsl:attribute name="value">
                      <xsl:choose>
                        <xsl:when test="$IsPostBack = 'true'">
                          <xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,1)" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,1)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </input>
                </div>
              </div>
              <!-- <textarea>
							<xsl:value-of select="$IsRetailUser" />
						</textarea> -->
              <xsl:if test="$IsRetailUser != 'true'">
                <div class="control-group">
                  <label class="control-label">and:</label>
                  <div class="controls">
                    <input type="text" id="LeadsEmail2" name="LeadsEmail" class="input-xlarge email">
                      <xsl:attribute name="value">
                        <xsl:choose>
                          <xsl:when test="$IsPostBack = 'true'">
                            <xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,2)" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,2)" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                    </input>
                  </div>
                </div>
                <xsl:if test="AccScripts:GetValueByCommaPos($LeadsEmail,3) != '' or AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,3) != ''" >
                  <div class="control-group LeadsEmailDiv3">
                    <label class="control-label">
                      <button type="button" id="RemoveEmailLead3" class="btn btn-danger btn-small">
                        <i class="icon-minus">&nbsp;</i>&nbsp;&nbsp;Remove
                      </button>
                      &nbsp;and:
                    </label>
                    <div class="controls">
                      <input type="text" id="LeadsEmail3" name="LeadsEmail" class="input-xlarge email">
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                              <xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,3)" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,3)" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </input>
                    </div>
                  </div>
                </xsl:if>
                <xsl:if test="AccScripts:GetValueByCommaPos($LeadsEmail,4) != '' or AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,4) != ''" >
                  <div class="control-group LeadsEmailDiv4">
                    <label class="control-label">
                      <button type="button" id="RemoveEmailLead4" class="btn btn-danger btn-small">
                        <i class="icon-minus">&nbsp;</i>&nbsp;&nbsp;Remove
                      </button>
                      &nbsp;and:
                    </label>
                    <div class="controls">
                      <input type="text" id="LeadsEmail4" name="LeadsEmail" class="input-xlarge email">
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                              <xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,4)" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,4)" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </input>
                    </div>
                  </div>
                </xsl:if>
                <xsl:if test="AccScripts:GetValueByCommaPos($LeadsEmail,5) != '' or AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,5) != ''" >
                  <div class="control-group LeadsEmailDiv5">
                    <label class="control-label">
                      <button type="button" id="RemoveEmailLead5" class="btn btn-danger btn-small">
                        <i class="icon-minus">&nbsp;</i>&nbsp;&nbsp;Remove
                      </button>
                      &nbsp;and:
                    </label>
                    <div class="controls">
                      <input type="text" id="LeadsEmail5" name="LeadsEmail" class="input-xlarge email">
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                              <xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,5)" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,5)" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </input>
                    </div>
                  </div>
                </xsl:if>
                <xsl:if test="AccScripts:GetValueByCommaPos($LeadsEmail,6) != '' or AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,6) != ''" >
                  <div class="control-group LeadsEmailDiv6">
                    <label class="control-label">
                      <button type="button" id="RemoveEmailLead6" class="btn btn-danger btn-small">
                        <i class="icon-minus">&nbsp;</i>&nbsp;&nbsp;Remove
                      </button>
                      &nbsp;and:
                    </label>
                    <div class="controls">
                      <input type="text" id="LeadsEmail6" name="LeadsEmail" class="input-xlarge email">
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="$IsPostBack = 'true'">
                              <xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsEmail,6)" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Email,6)" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </input>
                    </div>
                  </div>
                </xsl:if>
              </xsl:if>
            </div>
            <xsl:if test="$IsRetailUser != 'true'">
              <div class="control-group" id="email-leads-add">
                <div class="controls">
                  <button type="button" id="AddNewEmailLead" class="btn btn-info btn-small">
                    <i class="icon-plus">&nbsp;</i>&nbsp;&nbsp;Add another email address
                  </button>
                </div>
              </div>
            </xsl:if>
            <div class="control-group">
              <label class="control-label">
                SMS Leads to
                <i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="This is the mobile phone number lead notifications will be SMS'd to.">&nbsp;</i>
              </label>
              <div class="controls">
                <input type="text" id="LeadsPhoneNo1" name="LeadsPhoneNo" class="input-xlarge">
                  <xsl:attribute name="value">
                    <xsl:choose>
                      <xsl:when test="$IsPostBack = 'true'">
                        <xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsPhoneNo,1)" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Phone,1)" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:attribute name="data-validate">{required: false, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The lead mobile no entered is invalid'}}</xsl:attribute>
                  <!-- <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Billing Contact Phone No.'}}</xsl:attribute> -->
                </input>
              </div>
            </div>
            <xsl:if test="$IsRetailUser != 'true'">
              <div class="control-group">
                <label class="control-label"> and : &nbsp; </label>
                <div class="controls">
                  <input type="text" id="LeadsPhoneNo2" name="LeadsPhoneNo" class="input-xlarge">
                    <xsl:attribute name="value">
                      <xsl:choose>
                        <xsl:when test="$IsPostBack = 'true'">
                          <xsl:value-of select="AccScripts:GetValueByCommaPos($LeadsPhoneNo,2)" />
                        </xsl:when>
                        <xsl:otherwise>
                          <!-- <xsl:value-of select="$DealerActInfo/SalesLead_Phone" /> -->
                          <xsl:value-of select="AccScripts:GetValueByCommaPos($DealerActInfo/SalesLead_Phone,2)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="data-validate">{required: false, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The lead mobile no entered is invalid'}}</xsl:attribute>
                    <!-- <xsl:attribute name="data-validate">{required: false, minlength: 5, maxlength: 50, messages: {required: 'Please enter the Billing Contact Phone No.'}}</xsl:attribute> -->
                  </input>
                </div>
              </div>
            </xsl:if>
          </div>

        </fieldset>

        <br />

        <input type="hidden" id="update-account" name="update-account" value="true" />
        <input type="hidden" id="activate-account" name="activate-account" value="false" />

        <div class="form-actions center">
          <button type="submit" id="UpdateDealer" class="btn btn-large btn-success">
            <i class="icon-disk">&nbsp;</i> Save
          </button>
          <span class="hidden-phone">&nbsp;&nbsp;&nbsp;</span>
          <span class="visible-phone" style="display:block;height:10px;overflow:hidden">&nbsp;</span>
        </div>
        <!-- </form> -->
      </div>
    </div>

  </xsl:template>

  <!-- Drop-down options template -->
  <xsl:template name="optionlist">
    <xsl:param name="options"/>
    <xsl:param name="value"/>

    <xsl:for-each select="umbraco.library:Split($options,',')//value">
      <option>
        <xsl:attribute name="value">
          <xsl:value-of select="."/>
        </xsl:attribute>
        <!-- check to see whether the option should be selected-->
        <xsl:if test="$value =.">
          <xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test=". !=''">
            <xsl:value-of select="." />
          </xsl:when>
          <xsl:otherwise>Select</xsl:otherwise>
        </xsl:choose>
      </option>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>