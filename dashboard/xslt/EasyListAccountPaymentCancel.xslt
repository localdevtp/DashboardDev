<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:param name="currentPage"/>
  <xsl:template match="/">

    <div class="widget-box">
      <div class="widget-title">
        <h2>
          <i class="icon-close">&nbsp;</i> Payment Failed
        </h2>
      </div>
      <div class="widget-content no-padding">
        <table class="table table-balance table-balance-info">
          <tbody>
            <tr>
              <td colspan="2">
                <div class="alert alert-error">
                  Sorry, we are unable to process your payment. Please review your payment information and try again. If you need futher assistance, please contact Customer Service.
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="form-actions center">
          <a href="/user" class="btn btn-large">
            <i class="icon-redo">&nbsp;</i> Try Again
          </a>
        </div>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>