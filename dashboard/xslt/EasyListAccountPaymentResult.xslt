<?xml version="1.agen0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
  xmlns:ActScripts="urn:ActScripts.this"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:include href="EasyListDashboardPaymentHelper.xslt" />
  
  <xsl:param name="currentPage"/>

  <xsl:variable name="AccessCode" select="umbraco.library:Request('AccessCode')" />
  <xsl:variable name="ID" select="umbraco.library:Request('ID')" />
  <xsl:variable name="SaveStatus" select="ActScripts:SaveCustomerTokenId($ID, $AccessCode)" />

  <xsl:template  match="/">
    <xsl:choose>
      <xsl:when test="$SaveStatus = 'true'">
        <xsl:call-template name="ShowCardInfo">
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <div class="alert alert-error">
          <strong>Unable to save your credit card info. Please contact our system administrator.</strong>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ShowCardInfo">

    <xsl:variable name="CCInfo" select="ActScripts:GetCustomerCreditCardById($ID)" /> 
    
    <div class="widget-box">
    <div class="widget-title">
      <h2>
        <i class="icon-checkmark">&nbsp;</i> Credit Credit securely saved.
      </h2>
    </div>
    <div class="widget-content no-padding">
      <form>
        <table class="table table-balance table-balance-info table-balance-paid">
          <tbody>

            <tr>
              <th>Payment Type</th>
              <td>
                <label>Credit Card</label>
              </td>
            </tr>
            <tr>
              <th>Credit Card No.</th>
              <td>
                <xsl:value-of select="$CCInfo/GetCustomerResponse/Customers/DirectPaymentCustomer/CardDetails/Number" />
              </td>
            </tr>
            <tr>
              <th>Card Holder Name</th>
              <td>
                <xsl:value-of select="$CCInfo/GetCustomerResponse/Customers/DirectPaymentCustomer/CardDetails/Name" />
              </td>
            </tr>
          
            
            <tr class="notice">
              <td colspan="2">
                Thank you.
              </td>
            </tr>
          </tbody>
        </table>
        <div class="form-actions center">
          <a href="/user" class="btn btn-large">Done</a>
          &nbsp;
          <a href="/user/receipt" class="btn btn-large">
            <i class="icon-print">&nbsp;</i> Print
          </a>
        </div>
      </form>
    </div>
  </div>
  <!-- /Payment Result -->
  </xsl:template>
</xsl:stylesheet>