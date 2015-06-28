<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:scripts="urn:scripts.this"
	xmlns:RESTscripts="urn:RESTscripts.this"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:leadsapi="urn:leadsapi"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml leadsapi umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:include href="EasyListCommonTemplate.xslt" />
  <xsl:include href="EasyListRestHelper.xslt" />
  <xsl:include href="EasyListHelper.xslt" />
  <xsl:include href="EasyListStaffHelper.xslt" />
  <xsl:include href="LeadsAPIHelper.xslt" />


  <!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
  <xsl:variable name="IsPostback" select="leadsapi:GetIsPostback()" />
  <xsl:variable name="pageNumber" select="leadsapi:GetPage()" />
  <xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Editor,Sales,RetailUser')" />
  <!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

  <xsl:param name="currentPage"/>

  <xsl:template match="/">

    <!-- start writing XSLT -->

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

  <!-- LOADPAGE TEMPLATE -->
  <xsl:template name="LoadPage" >

    <div class="widget-box">
      <div class="widget-title">
        <h2>
          <i class="icon-bars">
            <xsl:text>
						</xsl:text>
          </i> Manage Leads
        </h2>
      </div>
      <!-- /widget-title -->

      <div id="detail-panel" class="widget-content no-padding loading-container">
        <div id="placeholder">

          <xsl:call-template name="loader" />

          <xsl:call-template name="search">
            <xsl:with-param name="type">leads</xsl:with-param>
          </xsl:call-template>

          <xsl:if test="$IsPostback = false">
            <!--<div id="search-result" class="alert alert-info" style="margin:10px">
                Please search/filter messaging history
              </div>-->       
          </xsl:if>
             
              <xsl:call-template name="leads">
              </xsl:call-template>
           


          <xsl:call-template name="paging">
            <xsl:with-param name="numberOfPages">
              <xsl:value-of select="leadsapi:GetTotalPage()" />
            </xsl:with-param>
          </xsl:call-template>

        </div>

      </div>
      <!-- /widget-content -->

    </div>
    <!-- /widget-box -->

  </xsl:template>
  <!-- /LOADPAGE TEMPLATE -->

  <!-- LOADING TEMPLATE -->
  <xsl:template name="loader">
    <!-- Loaders -->
    <div id="loading-bg">
      <xsl:text>
			</xsl:text>
    </div>
    <div id="loading" style="display:none">
      <img class="retina" src="/images/spinner.png" />
    </div>
    <!-- /Loaders -->
  </xsl:template>
  <!-- /LOADING TEMPLATE -->

  <!-- SEARCH OPTIONS TEMPLATE -->
  <xsl:template name="search">
    <xsl:param name="type" />

    <div id="search-filter-dealer">
      <div class="toolbars">
        <a class="btn btn-info" data-toggle="collapse">
          <xsl:attribute name="data-target">
            <xsl:value-of select="concat('#search-filter-', $type)"/>
          </xsl:attribute>
          <i class="icon-filter">&nbsp;</i> Search / Filter / Sort Result
        </a>
      </div>
      <div class="widget-collapse-options collapse">
        <xsl:attribute name="id">
          <xsl:value-of select="concat('search-filter-', $type)"/>
        </xsl:attribute>
        <div class="widget-collapse-options-inner">

          <form class="form-horizontal">

            <div class="control-group">
              <label class="control-label">Keyword</label>
              <div class="controls">
                <input class="text" type="text" maxlength="150" id="Keyword" name="Keyword" />
              </div>
            </div>

            <xsl:value-of select="leadsapi:GenerateCustomerChildDropdown('True')"  disable-output-escaping="yes" />

            <div class="control-group">
              <label class="control-label">Lead Status</label>
              <div class="controls">
                <select name="LeadStatus" id="LeadStatus" multiple="multiple">
                  <xsl:call-template name="optionlist">
                    <xsl:with-param name="options">All,Unassigned,Assigned,Follow Up,Closed - Won,Closed - Lost</xsl:with-param>
                  </xsl:call-template>
                </select>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Created</label>
              <div class="controls">
                <input class="text" type="date" maxlength="150" id="FromDate" name="FromDate" />
                &nbsp;<small>from</small>
              </div>
              <div class="controls">
                <input class="text" type="date" maxlength="150" id="ToDate" name="ToDate" />
                &nbsp;<small>to</small>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Assigned To</label>
              <div class="controls">
                <input class="text" type="text" maxlength="150" id="AssignedTo" name="AssignedTo" />
              </div>
            </div>

            <!-- hide this column for the time being.
            <div class="control-group">
              <label class="control-label">Prospect Source</label>
              <div class="controls">
                <input class="text" type="text" maxlength="150" id="ProspectSource" name="ProspectSource" />
              </div>
            </div>
-->

            <div class="control-group">
              <label class="control-label">Sort Result by</label>
              <div class="controls">
                <select name="SortBy" id="SortBy">
                  <xsl:call-template name="optionlist">
                    <xsl:with-param name="options">Created,Last Updated,Buyer Name,Listing Stock Number</xsl:with-param>
                    <xsl:with-param name="value">Created</xsl:with-param>
                  </xsl:call-template>
                </select>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">Sort Order</label>
              <div class="controls">
                <select name="SortOrder" id="SortOrder">
                  <xsl:call-template name="optionlist">
                    <xsl:with-param name="options">Ascending,Descending</xsl:with-param>
                    <xsl:with-param name="value">Descending</xsl:with-param>
                  </xsl:call-template>
                </select>
              </div>
            </div>

            <input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
            <div class="control-group form-actions">
              <div class="controls">
                <button type="submit" id="search" class="btn btn-large">Submit</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </xsl:template>
  <!-- /SEARCH OPTIONS TEMPLATE -->

  <!-- LEADS RESULT TEMPLATE -->
  <xsl:template name="leads">
    <xsl:variable name="dealerCode">
      <xsl:choose>
        <xsl:when test="$IsPostback = false">
          <xsl:value-of select="umbraco.library:Session('easylist-usercodelist')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="leadsapi:GetFormValue('listing-usercode')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="from" select="leadsapi:GetFormValue('FromDate')" />
    <xsl:variable name="to" select="leadsapi:GetFormValue('ToDate')" />
    <xsl:variable name="leadStatus" select="leadsapi:GetFormValue('LeadStatus')" />
    <xsl:variable name="assignedTo" select="leadsapi:GetFormValue('AssignedTo')" />
    <xsl:variable name="prospectSource" select="leadsapi:GetFormValue('ProspectSource')" />
    <xsl:variable name="keywords" select="leadsapi:GetFormValue('Keyword')" />
    <xsl:variable name="sort" select="leadsapi:GetSortOrder()" />
    <xsl:variable name="skip" select="string(leadsapi:GetSkip())" />
    <xsl:variable name="take" select="string(leadsapi:GetItemPerPage())" />


    <xsl:variable name="data" select="leadsapi:SearchLeads($dealerCode, $from, $to, $leadStatus, $assignedTo, $prospectSource, $keywords, $sort, $skip, $take)" />

    <xsl:choose>
      <xsl:when test="$data/error">
        <div id="search-result" class="alert alert-error">
          <strong>
            <xsl:value-of select="$data/error" />
          </strong>
        </div>

      </xsl:when>
      <xsl:when test="$data/SearchResults/TotalResults = 0">
        <div id="search-result" class="alert alert-info" style="margin:10px">
          Search yield no result
        </div>

      </xsl:when>
      <xsl:otherwise>
        <table id="search-result" class="footable">
          <thead>
            <tr>
              <th data-sort-ignore="true" data-hide="" data-class="expand" style="width:70px;">Listing Code</th>
              <th data-sort-ignore="true" data-hide="" style="width:70px;">Listing Stock Number</th>
              <th data-sort-ignore="true" data-hide="phone" data-class="leftalign" class="leftalign">Listing Title</th>
              <th data-sort-ignore="true" data-hide="phone" style="width:70px;">Listing Price</th>
              <th data-sort-ignore="true" data-hide="phone,tablet" data-class="text-ellipsis" style="width:70px;">Assigned To</th>
              <th data-sort-ignore="true" data-hide="phone,tablet" data-class="text-ellipsis" style="width:70px;">Prospect Source</th>
              <th data-sort-ignore="true" data-hide="" data-class="text-ellipsis" style="width:70px;">Lead Type</th>
              <th data-sort-ignore="true" data-hide="phone,tablet" data-class="text-ellipsis" style="width:70px;">Buyer Name</th>
              <th data-sort-ignore="true" data-hide="phone" style="width:70px;">Created</th>
              <th data-sort-ignore="true" data-hide="phone" style="width:70px;">Last Updated</th>
              <th data-sort-ignore="true" data-hide="" style="width:70px;">Status</th>
            </tr>
          </thead>
          <tbody>


            <xsl:for-each select="$data/SearchResults/Results/LeadSummary">
              <tr>
                <td>
                  <a href="/leads/edit?id={./LeadCode}">
                    <xsl:value-of select="./ListingCode" />
                  </a>
                </td>
                <td>
                  <xsl:value-of select="./ListingStockNumber"/>
                </td>
                <td>
                  <xsl:value-of select="./ListingTitle" />
                </td>
                <td>
                  <xsl:value-of select="./ListingPrice" />
                </td>

                <td style="width:70px; max-width:70px;" title="Assigned To">
                  <xsl:value-of select="./AssignedTo" />
                </td>
                <td style="width:70px; max-width:70px;" title="Prospect Source">
                  <xsl:value-of select="./ProspectSource" />
                </td>
                <td style="width:70px; max-width:70px;" title="Lead Type">
                  <xsl:value-of select="./LeadType" />
                </td>
                <td style="width:70px; max-width:70px;" title="Buyer Name/Phone">
                  <xsl:choose>
                    <xsl:when test="./BuyerName !='' and ./BuyerName !='N/A'">
                      <xsl:value-of select="./BuyerName" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="./BuyerMobilePhone" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>

                <td data-value="{./LeadCreated}">
                  <xsl:value-of select="umbraco.library:FormatDateTime(./LeadCreated, 'dd/MM/yyyy')"/>
                  <br />
                  <xsl:value-of select="umbraco.library:FormatDateTime(./LeadCreated, 'HH:mm')"/>
                </td>
                <td data-value="{./LeadLastUpdated}">
                  <xsl:value-of select="umbraco.library:FormatDateTime(./LeadLastUpdated, 'dd/MM/yyyy')"/>
                  <br />
                  <xsl:value-of select="umbraco.library:FormatDateTime(./LeadLastUpdated, 'HH:mm')"/>
                </td>
                <td>
                  <span>
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="./MasterStatus = 'Unassigned'">label label-important</xsl:when>
                        <!-- TODO: Add more appropriate status classes -->

                        <xsl:otherwise>label label-success</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="./MasterStatus"/>
                  </span>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  <!-- /LEADS RESULT TEMPLATE -->

  <xsl:template name="for.loop">
    <xsl:param name="i"/>
    <xsl:param name="count"/>
    <xsl:param name="page"/>
    <xsl:if test="$i &lt;= $count">
      <li>
        <xsl:choose>
          <xsl:when test="$page = ($i + 1)">
            <xsl:attribute name="class">
              <xsl:value-of select="'current'"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="($page &gt; ($i + 2)) or ($page &lt; $i)">
            <xsl:attribute name="class">
              <xsl:value-of select="'hidden-tablet hidden-phone'"/>
            </xsl:attribute>
          </xsl:when>
        </xsl:choose>
        <a href="page={$i}" >
          <xsl:value-of select="$i" />
        </a>
      </li>
    </xsl:if>
    <xsl:if test="$i &lt;= $count">
      <xsl:call-template name="for.loop">
        <xsl:with-param name="i">
          <xsl:value-of select="$i + 1" />
        </xsl:with-param>
        <xsl:with-param name="count">
          <xsl:value-of select="$count"/>
        </xsl:with-param>
        <xsl:with-param name="page">
          <xsl:value-of select="$page"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="paging" match="paging">
    <!-- Add paging links -->
    <xsl:param name="numberOfPages"/>
    <!-- <xsl:variable name="numberOfPages" select="20" /> -->
    <!-- <xsl:variable name="pageNumber" select="$PageNo" /> -->

    <xsl:if test="$numberOfPages > 1">

      <div id="easylist-pagination" class="pagination pagination-centered">
        <ul id="easylist-page-links">

          <xsl:variable name="prevPageNum" select="$pageNumber - 1" />
          <xsl:variable name="nextPageNum" select="$pageNumber + 1" />


          <!-- Numbered Pages -->

          <xsl:variable name="startPage">
            <xsl:choose>
              <xsl:when test="$numberOfPages &lt; 12">1</xsl:when>
              <xsl:when test="$pageNumber &lt; 7">1</xsl:when>
              <xsl:when test="$numberOfPages - $pageNumber &lt; 5">
                <xsl:value-of select="$numberOfPages -10" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$pageNumber -6" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="endPage">
            <xsl:choose>
              <xsl:when test="$numberOfPages &lt; 12">
                <xsl:value-of select="$numberOfPages" />
              </xsl:when>
              <xsl:when test="$pageNumber &lt; 7">11</xsl:when>
              <xsl:when test="$pageNumber +6 &gt; $numberOfPages">
                <xsl:value-of select="$numberOfPages" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$pageNumber +6" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:if test="$pageNumber != '1'">
            <li class="first-page">
              <a href="page=1">
                <i class="icon-first">&nbsp;</i>
                <span class="hidden-phone">Page 1</span>
              </a>
            </li>

            <li class="prev-page">
              <a href="page={$prevPageNum}">
                <i class="icon-backward">&nbsp;</i>
              </a>
            </li>
          </xsl:if>

          <xsl:call-template name="for.loop">
            <xsl:with-param name="i" select="$startPage" />
            <xsl:with-param name="page" select="$pageNumber +1"></xsl:with-param>
            <xsl:with-param name="count" select="$endPage"></xsl:with-param>
          </xsl:call-template>


          <xsl:if test="$pageNumber &lt; $numberOfPages">

            <li class="next-page">
              <a href="page={$nextPageNum}">
                <i class="icon-forward">&nbsp;</i>
              </a>
            </li>
            <li class="last-page">
              <a href="page={$numberOfPages}">
                <span class="hidden-phone">
                  Page <xsl:value-of select="$numberOfPages" />
                </span>&nbsp;<i class="icon-last">&nbsp;</i>
              </a>
            </li>
          </xsl:if>
        </ul>

        <xsl:if test="leadsapi:GetTotalCount() > 0">
          <br />
          <br />
          <div>
            Total records count: <span class="badge badge-info">
              <xsl:value-of select="leadsapi:GetTotalCount()" />
            </span>
          </div>
        </xsl:if>



        <xsl:if test="leadsapi:GetIsTooManyResult() = 'true'">
          <br />
          <small>
            Your search yields many results, please refine your search filter(s), because maximum pages is capped at <xsl:value-of select="leadsapi:Get_MAX_PAGE_ALLOWED()" />.
          </small>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>
  <!-- /PAGING TEMPLATE -->

</xsl:stylesheet>