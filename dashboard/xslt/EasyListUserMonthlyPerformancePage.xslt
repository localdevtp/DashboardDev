<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:reportHelper="urn:reportHelper"
  xmlns:RESTscripts="urn:RESTscripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets reportHelper RESTscripts">


  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:include href="EasyListRestHelper.xslt" />
  <xsl:param name="currentPage"/>
  <xsl:variable name="userCode" select="umbraco.library:Session('easylist-usercode')" />
  <xsl:variable name="childUserCode" select="umbraco.library:RequestQueryString('childcodes')" />

  <xsl:template match="/">
    <xsl:variable name="reportList" select="reportHelper:GetAllReport($userCode,$childUserCode)" />
    <!--<textarea>
      <xsl:value-of select="$childUserCode"/>
      <xsl:copy-of select="$reportList" />
    </textarea>-->
    <div class="widget-box">
      <div class="widget-title">
        <h2>
          <i class="icon-bars">&nbsp;</i> Monthly Performance Report
        </h2>
      </div>
      <div class="widget-content no-padding">
        <div id="loading-bg" style="display: none;">
          <xsl:value-of select="normalize-space('')"/>
        </div>
        <div id="loading" style="display: none;">
          <img class="retina" src="/images/spinner.png" />
        </div>
        <xsl:call-template name="filterTemplate"></xsl:call-template>
        <xsl:call-template name="searchResult">
          <xsl:with-param name="reportList" select="$reportList" />
        </xsl:call-template>
      </div>
    </div>

  </xsl:template>

  <xsl:template name="filterTemplate">
    <div class="toolbars">
      <a data-toggle="collapse" href="#SearchReport" class="btn btn-info collapsed">
        <i class="icon-filter">&nbsp;</i> Search / Filter / Sort Result
      </a>
    </div>
    <div id="SearchReport" class="widget-collapse-options collapse">
      <div class="widget-collapse-options-inner">
        <div class="form-horizontal">
          <xsl:value-of select="RESTscripts:GenerateCustomerChildDropdown('True')"  disable-output-escaping="yes" />
          <div class="control-group form-actions">
            <div class="controls">
              <a class="btn" id="ReportSearch" href="#">Submit</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="searchResult">
    <xsl:param name="reportList" />
    <div id="EasyListReportList">
      <table class="footable have-default-hide clean-link footable-loaded default breakpoint">
        <thead>
          <tr>
            <th>Account Name</th>
            <th>Report Period</th>
            <th>Type</th>
            <th>Status</th>
            <th>&nbsp;</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="$reportList/ArrayOfReportDetail/ReportDetail">
            <tr>
              <xsl:attribute name="class">
                <xsl:if test="(position() mod 2) != 1">
                  <xsl:text>even</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <td>
                <xsl:value-of select="./AccountName"/>
              </td>
              <td>
                <xsl:value-of select="./Period"/>
              </td>
              <td>
                <xsl:value-of select="./ReportType"/>
              </td>
              <td>
                <xsl:value-of select="./Status"/>
              </td>
              <td>
                <a class="btn" style="color:white" target="_blank" href="/download-report.aspx?filename={./ReportPath}&amp;usercode={./UserCode}">Download Report</a>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
      <xsl:if test="count($reportList/ArrayOfReportDetail/ReportDetail) = 0">
        <div id="easylist-no-results">
          <div class="alert alert-info">
            There are no report generated for your account. Call our customer service to find out more about reporting
          </div>
        </div>
      </xsl:if>   
    </div>   
  </xsl:template>

  <msxml:script implements-prefix="reportHelper" language="C#">
    <msxml:assembly name="System.Web"/>
    <msxml:assembly name="EasyList.Data.DAL.Repository"/>
    <msxml:assembly name="EasyList.Reporting.Mongo.Entity"/>
    <msxml:assembly name="Componax.ExtensionMethods"/>
    <msxml:assembly name="NLog"/>
    <msxml:assembly name="System.Xml.Linq"/>
    <msxml:assembly name="System.Linq"/>
    <msxml:assembly name="System.IO"/>

    <msxml:using namespace="System.Web"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository"/>
    <msxml:using namespace="EasyList.Reporting.Mongo.Entity"/>
    <msxml:using namespace="Componax.ExtensionMethods"/>
    <msxml:using namespace="NLog"/>
    <msxml:using namespace="System.Xml"/>
    <msxml:using namespace="System.Xml.Linq"/>
    <msxml:using namespace="System.Xml.XPath"/>
    <msxml:using namespace="System.Linq"/>
    <msxml:using namespace="System.IO"/>
    <msxml:using namespace="System.Collections.Generic"/>
    <![CDATA[
static Logger log = LogManager.GetCurrentClassLogger();

public static XPathNodeIterator GetAllReport(string parentUserCode, string childUserCode = "")
        {
            try
            {
                var childUserCodes = childUserCode.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);               
                IRepository repo = RepositorySetup.Setup();
                IQueryable<ReportLog> reports;
                if(childUserCodes.Length == 0)reports= repo.All<ReportLog>(rs => rs.UserCode==parentUserCode && rs.Status == true).OrderBy(rs => rs.TimeStamp);
                else reports = repo.All<ReportLog>(rs => rs.UserCode == parentUserCode && childUserCodes.Contains(rs.OriginatedUserCode) && rs.Status == true).OrderBy(rs => rs.TimeStamp);
                var returnList = new List<ReportDetail>();

                string filePath, fileName, accountName, period;

                foreach (var rpt in reports)
                {
                    filePath = fileName = accountName = string.Empty;

                    ReportDetail repDetail = new ReportDetail();
                    repDetail.Status = (rpt.Status ? "Email Sent" : "Email fail to send");
                    repDetail.TimeSent = string.Format("{0} {1}", rpt.TimeStamp.ToShortDateString(), rpt.TimeStamp.ToShortTimeString());
                    if (rpt.Attachment.Count > 0)
                    {
                        filePath = rpt.Attachment[0];
                        fileName = Path.GetFileName(filePath);
                        string[] fileDetails = fileName.Split('_');
                        period = fileDetails[fileDetails.Length - 1].Substring(0,6);
                        var actualDate = new DateTime(period.Substring(0, 4).ToInt(), period.Substring(4).ToInt(), 1);
                        
                        for (var i = 2; i < fileDetails.Length - 1; i++)
                            accountName += string.Format(" {0}", fileDetails[i]);
                        repDetail.AccountName = accountName.Substring(1);
                        repDetail.Period = actualDate.ToString("MMMM yyyy");
                        repDetail.UserCode = fileDetails[0];
                        repDetail.ReportPath = fileName;
                        repDetail.ReportType = GetReportType(fileDetails[1]);
                    }                                                            
                    returnList.Add(repDetail);                    
                }
                return EasyList.Common.Helpers.Utils.XMLGetNodeIterator(returnList.ToXml());
            }
            catch (Exception ex)
            {
                log.Error("Error getting report: {0}", ex);
                return EasyList.Common.Helpers.Utils.XMLGetErrorIterator(ex.Message);
            }
           
        }

private static string GetReportType(string type)
{
    switch (type)
    {
        case "MA":
            return "Master Report";
        case "CH":
            return "Child Report";
        case "PR":
            return "Parent Report";
        default:
            return "Master Report";

    }
}

public class ReportDetail
{
    public string AccountName { get; set; }
    public string Period { get; set; }
    public string UserCode { get; set; }
    public string ReportType { get; set; }
    public string ReportPath { get; set; }
    public string Status { get; set; }
    public string TimeSent { get; set; }
}
]]>
  </msxml:script>
</xsl:stylesheet>