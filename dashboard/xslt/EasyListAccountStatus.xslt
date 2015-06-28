<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:ActScripts="urn:ActScripts.this"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:InlineScript="urn:InlineScript.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:include href="EasyListAccountHelper.xslt" />
  <xsl:include href="EasyListStaffHelper.xslt" />

  <xsl:variable name="LoginID" select="umbraco.library:Session('easylist-username')" />
  <xsl:variable name="IsPostBack" select="umbraco.library:Request('submit-payment')" />

  <xsl:variable name="StaffAccInfo" select="ActScripts:GetAccountInfo()" />

  <!-- 
<xsl:variable name="CCInfo" select="ActScripts:GetCreditCard()" /> -->

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
        <xsl:variable name="IsAccountExits" select="ActScripts:IsAccountExits()" />

        <xsl:choose>
          <xsl:when test="$IsAccountExits = false">
            <div class="alert">
              No master account exists for your login id.
            </div>
          </xsl:when>

          <xsl:when test="string-length($StaffAccInfo/error) &gt; 0">
            <div class="alert">
              <xsl:value-of select="$StaffAccInfo/error" />
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="LoadPage">
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="LoadPage" >

    <!-- start writing XSLT -->
    <!-- <textarea>
		<xsl:value-of select="$IsPostBack" />
	</textarea> -->
    <xsl:choose>
      <!-- Process Payment -->
      <xsl:when test="$IsPostBack = 'true'">
        <xsl:variable name="PaymentResponse" select="ActScripts:ProcesPayment()" />
        <xsl:choose>
          <!-- Check if error message is not empty -->
          <xsl:when test="string-length($PaymentResponse) &gt; 0">
            <xsl:call-template name="PaymentFailed">
              <xsl:with-param name="ErrMsg">
                <xsl:value-of select="$PaymentResponse" />
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>
          <!-- Success without error -->
          <xsl:otherwise>
            <xsl:call-template name="PaymentSuccess">
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- Load Payment Info -->
      <xsl:otherwise>
        <xsl:call-template name="AccountStatusLoad">
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="AccountStatusLoad">
    <input type="hidden" id="OutstandingBalance" name="OutstandingBalance">
      <xsl:attribute name="value">
        <xsl:value-of select="$StaffAccInfo/ELAccInfo/CurrentOutstandingBalance" />
      </xsl:attribute>
    </input>

    <xsl:if test="string-length($StaffAccInfo/ELAccInfo/CustomerTokenId) &gt; 0">
      <!--	<div class="alert alert-error"><xsl:value-of select="$CCInfo/error" /></div> -->
      <input type="hidden" id="CCInfoExists" name="CCInfoExists">
        <xsl:attribute name="value">True</xsl:attribute>
      </input>
    </xsl:if>

    <div class="widget-box" id="account-status">
      <div class="widget-title">
        <h2>
          <i class="icon-calculate">&nbsp;</i> Account Status
        </h2>
      </div>
      <div class="widget-content no-padding">
        <div class="row-custom">
          <div class="widget-infobox">
            <span>Current Due</span>
            <strong>
              <xsl:value-of select="ActScripts:FormatPrice($StaffAccInfo/ELAccInfo/CurrentOutstandingBalance,'')"/>
            </strong>
          </div>
        </div>
        <table class="table table-balance table-balance-info">
          <tbody>
            <tr>
              <th>Account name</th>
              <td>
                <xsl:value-of select="$StaffAccInfo/ELAccInfo/CompanyName"/>
              </td>
            </tr>
            <tr>
              <th>Address</th>
              <td>
                <xsl:value-of select="$StaffAccInfo/ELAccInfo/DisplayAddressHtml" disable-output-escaping="yes"/>
              </td>
            </tr>
            <tr>
              <th>Primary Email</th>
              <td>
                <xsl:value-of select="$StaffAccInfo/ELAccInfo/PrimaryEmail"/>
              </td>
            </tr>
            <tr>
              <th>Secondary Email</th>
              <td>
                <xsl:value-of select="$StaffAccInfo/ELAccInfo/SecondaryEmail"/>
              </td>
            </tr>
            <tr>
              <th>Contact Phone</th>
              <td>
                <xsl:value-of select="$StaffAccInfo/ELAccInfo/ContactPhone"/>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="form-actions center">
          <a href="#" class="btn btn-large btn-success" id="confirm-payment">
            <i class="icon-credit">&nbsp;</i> Pay Balance Due
          </a>
        </div>
      </div>
    </div>
    <!-- /Account Status -->

    <div class="widget-box" id="confirm-payment-form" style="display:none;">
      <div class="widget-title">
        <h2>
          <i class="icon-credit">&nbsp;</i> Confirm Payment Details
        </h2>
      </div>
      <div class="widget-content no-padding">
        <form class="form-horizontal break-desktop-large" autocomplete="off" method="post" runat="server">
          <table class="table table-balance table-balance-info">
            <tbody>
              <tr>
                <th>Payment Type</th>
                <td>Credit Card</td>
              </tr>
              <tr class="total">
                <th>Charge Amount</th>
                <td>
                  <span class='credit'>
                    <xsl:value-of select="ActScripts:FormatPrice($StaffAccInfo/ELAccInfo/CurrentOutstandingBalance,'')"/>
                  </span>
                </td>
              </tr>
              <tr class="tnc">
                <td colspan="2">
                  <label class="checkbox">
                    <input class="required" type="checkbox" name="paymentTnc" />
                    <span class="important">*</span> I accept the <a target="_blank" href="/docs/terms-and-conditions">terms and conditions of payment</a>
                  </label>
                </td>
              </tr>
            </tbody>
          </table>

          <input type="hidden" id="submit-payment" name="submit-payment" value="true" />
          <div class="form-actions center">
            <a href="#" class="btn btn-large" id="cancel-confirm-payment">
              <i class="icon-chevron-left">&nbsp;</i> Back
            </a>
            &nbsp;
            <button type="submit" class="btn btn-large btn-success">
              <i class="icon-credit">&nbsp;</i> Pay Now
            </button>
          </div>
        </form>
      </div>
    </div>
    <!-- /Confirm Payment -->

  </xsl:template>

  <xsl:template name="PaymentSuccess">

    <!-- PAYMENT SUCCESS -->
    <div class="widget-box">
      <div class="widget-title">
        <h2>
          <i class="icon-checkmark">&nbsp;</i> Payment Approved
        </h2>
      </div>
      <div class="widget-content no-padding">
        <form>
          <table class="table table-balance table-balance-info table-balance-paid">
            <tbody>

              <tr>
                <th></th>
                <td>
                  <br />
                  <br />
                </td>
              </tr>
              <tr>
                <th>Charge Amount</th>
                <td>
                  <xsl:value-of select="ActScripts:FormatPrice($StaffAccInfo/ELAccInfo/CurrentOutstandingBalance,'')"/>
                </td>
              </tr>
              <tr class="notice">
                <td colspan="2">
                  Thank you, your payment of <xsl:value-of select="ActScripts:FormatPrice($StaffAccInfo/ELAccInfo/CurrentOutstandingBalance,'')"/> has been accepted.
                  <br/>Please check your mailbox for payment confirmation.
                </td>
              </tr>
            </tbody>
          </table>
          <div class="form-actions center">
            <a href="/accounting/status" class="btn btn-large">Done</a>
            &nbsp;
            <!-- <a href="/user/receipt" class="btn btn-large"><i class="icon-print">&nbsp;</i> Print</a> -->
          </div>
        </form>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="PaymentFailed">
    <xsl:param name="ErrMsg"/>

    <div class="widget-box">
      <div class="widget-title">
        <h2>
          <i class="icon-close">&nbsp;</i> Payment Failed
        </h2>
      </div>
      <div class="widget-content no-padding">
        <table class="table table-balance table-balance-info">
          <tbody>
            <tr class="total">
              <th>Charge Amount</th>
              <td>
                <span class='credit'>
                  <xsl:value-of select="ActScripts:FormatPrice($StaffAccInfo/ELAccInfo/CurrentOutstandingBalance,'')"/>
                </span>
              </td>
            </tr>


            <tr>
              <td colspan="2">
                <div class="alert alert-error">
                  <xsl:value-of select="$ErrMsg" /><br/>
                  Sorry, we are unable to process your payment. Please review your payment information and try again. If you need futher assistance, please contact Customer Service.

                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="form-actions center">
          <a href="/accounting/status" class="btn btn-large">
            <i class="icon-redo">&nbsp;</i> Try Again
          </a>
        </div>
      </div>
    </div>
  </xsl:template>


  <!-- C# helper scripts -->
  <msxml:script language="C#" implements-prefix="InlineScript">
    <![CDATA[

       

		]]>
  </msxml:script>

</xsl:stylesheet>