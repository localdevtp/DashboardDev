<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml AccScripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

  <xsl:output method="xml" omit-xml-declaration="yes" />

  <xsl:include href="EasyListStaffHelper.xslt" />

  <xsl:variable name="LoginID" select="umbraco.library:Session('easylist-username')" />

  <xsl:param name="currentPage"/>

  <xsl:template match="/">

    <!-- DEBUG
<xsl:value-of select="$currentPage/@nodeName"/>
	-
<xsl:value-of select="$currentPage/@level"/>
	-
<xsl:value-of select="$currentPage/@id"/>
	-
<xsl:value-of select="$currentPage/@parentID"/>
-->

    <!-- <xsl:variable name="StaffGroupList" select="AccScripts:GetStaffAccountGroupList()" /> -->
    <xsl:variable name="StaffGroup" select="AccScripts:GetStaffAccountGroup($LoginID,1)" />
    <xsl:variable name="IsGodLevel" select="AccScripts:IsAuthorized('EasySales Admin')" />
    <xsl:variable name="IsESSupport" select="AccScripts:IsAuthorized('ESSupport')" />
    <xsl:variable name="UserMenuList" select="AccScripts:GetUserMenuList()" />
    <!--textarea>
		<xsl:value-of select="$UserMenuList/MenuAccessList/AccesssNewListing" />
		<xsl:value-of select="$UserMenuList/MenuAccessList/AccessViewListing" />
	</textarea-->

    <div id="nav">
      <a href="#nav" class="nav-icon">
        <i class="icon-menu">
          <xsl:text>
		</xsl:text>
        </i> MENU
      </a>
      <nav>
        <ul>
          <li>
            <xsl:if test="$currentPage/@id = 1046">
              <xsl:attribute name="class">current</xsl:attribute>
            </xsl:if>
            <a href="/">
              <i class="icon-dashboard">
                <xsl:text>
					</xsl:text>
              </i>Dashboard
            </a>
          </li>

          <xsl:call-template name="MyProfile" />

          <xsl:if test="$UserMenuList/MenuAccessList/AccessViewLeadSettings = 'true'">
            <xsl:call-template name="Settings" />
          </xsl:if>

          <xsl:if test="$UserMenuList/MenuAccessList/AccesssNewListingRetail = 'true'">
            <xsl:call-template name="NewListingRetail" />
          </xsl:if>

          <xsl:if test="$UserMenuList/MenuAccessList/AccesssNewListing = 'true'">
            <xsl:call-template name="NewListing" />
          </xsl:if>

          <!--<xsl:if test="$UserMenuList/MenuAccessList/AccesssNewListing = 'true'">
					<xsl:call-template name="BulkUpload" />
				</xsl:if>-->

          <xsl:if test="$UserMenuList/MenuAccessList/AccessViewListing = 'true' or $UserMenuList/MenuAccessList/AccesssNewListingRetail = 'true'">
            <xsl:call-template name="Listing" />
          </xsl:if>

          <xsl:if test="$UserMenuList/MenuAccessList/AccesssNewListingRetail = 'true'">
            <xsl:call-template name="AccountingRetail" />
          </xsl:if>

          <xsl:if test="$UserMenuList/MenuAccessList/AccessViewAccounting = 'true'">
            <xsl:call-template name="Accounting" />
          </xsl:if>

          <xsl:if test="$UserMenuList/MenuAccessList/AccessViewStaff = 'true'">
            <xsl:call-template name="Staff" />
          </xsl:if>

          <xsl:if test="$UserMenuList/MenuAccessList/AccessViewDealer = 'true'">
            <xsl:call-template name="Dealers" />
          </xsl:if>

          <xsl:if test="$UserMenuList/MenuAccessList/AccessViewListing = 'true'">
            <xsl:call-template name="Leads" />
          </xsl:if>
          
          <xsl:if test="$UserMenuList/MenuAccessList/AccessPerformanceReport = 'true'">
            <xsl:call-template name="Reporting" />
          </xsl:if>
          
          <xsl:if test="$IsGodLevel = 'true' or $IsESSupport = 'true'">
            <xsl:call-template name="Messaging" />
          </xsl:if>


        </ul>
      </nav>
    </div>

  </xsl:template>

  <xsl:template name="MyProfile">
    <li>
      <xsl:if test="$currentPage/@parentID = 1124 or $currentPage/@id = 1124">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/user/profile">
        <i class="icon-params">
          <xsl:text>
		</xsl:text>
        </i>My Profile
      </a>
    </li>
  </xsl:template>

  <xsl:template name="Settings">
    <li>
      <xsl:if test="$currentPage/@parentID = 9999 or $currentPage/@id = 1389">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/settings/safety-and-privacy">
        <i class="icon-settings">
          <xsl:text>
		</xsl:text>
        </i>Settings
      </a>
    </li>
  </xsl:template>

  <xsl:template name="NewListingRetail">
    <li>
      <xsl:if test="$currentPage/@id = 1305 or $currentPage/@id = 1310 or $currentPage/@id = 1091">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/listings/landing">
        <i class="icon-asterisk">
          <xsl:text>
		</xsl:text>
        </i>New Listing
      </a>
    </li>
  </xsl:template>

  <xsl:template name="NewListing">
    <li>
      <xsl:if test="$currentPage/@id = 1091">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/listings/create">
        <i class="icon-asterisk">
          <xsl:text>
		</xsl:text>
        </i>New Listing
      </a>
    </li>
  </xsl:template>

  <xsl:template name="BulkUpload">
    <li>
      <xsl:if test="$currentPage/@parentID = 1365 or $currentPage/@id = 1365">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/bulk-upload">
        <i class="icon-stack-1">
          <xsl:text>
		</xsl:text>
        </i>Bulk Upload
      </a>
    </li>
  </xsl:template>

  <xsl:template name="Listing">
    <li>
      <!--<xsl:if test="($currentPage/@parentID = 1089 or $currentPage/@id = 1089)">-->
      <xsl:if test="($currentPage/@id = 1089 or $currentPage/@id = 1090 or $currentPage/@id = 1365 or $currentPage/@id = 1418 or $currentPage/@id = 1427 or $currentPage/@id = 1428 or $currentPage/@id = 1429 or $currentPage/@id = 1444 or $currentPage/@id = 1445)">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <!--<a href="/listings?ListingType=Car&amp;Status=Active"><i class="icon-list-2"><xsl:text>-->
      <a href="/listings?Status=Active">
        <i class="icon-list-2">
          <xsl:text>
		</xsl:text>
        </i>Listings
      </a>
    </li>
  </xsl:template>

  <xsl:template name="Accounting">
    <li>
      <xsl:if test="$currentPage/@parentID = 1162 or $currentPage/@id = 1162">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/account">
        <i class="icon-notebook">
          <xsl:text>
		</xsl:text>
        </i>Account
      </a>
    </li>
  </xsl:template>

  <xsl:template name="AccountingRetail">
    <li>
      <xsl:if test="$currentPage/@parentID = 1162 or $currentPage/@id = 1162">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <!--<a href="/account/retail-view-invoices.aspx">-->
      <a href="/account/retail-view-payments.aspx">
        <i class="icon-notebook">
          <xsl:text>
		</xsl:text>
        </i>Account
      </a>
    </li>
  </xsl:template>

  <xsl:template name="Staff">
    <li>
      <xsl:if test="$currentPage/@parentID = 1148 or $currentPage/@id = 1148">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/staff">
        <i class="icon-users">
          <xsl:text>
		</xsl:text>
        </i>Staff
      </a>
    </li>
  </xsl:template>

  <xsl:template name="Dealers">
    <li>
      <xsl:if test="$currentPage/@parentID = 1204 or $currentPage/@id = 1204">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/dealers">
        <i class="icon-user-3">
          <xsl:text>
		</xsl:text>
        </i>Customers
      </a>
    </li>
  </xsl:template>

  <xsl:template name="Messaging">
    <li>
      <xsl:if test="$currentPage/@parentID = 1286 or $currentPage/@id = 1286">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/messaging">
        <i class="icon-paperplane">
          <xsl:text>
		</xsl:text>
        </i>Messages
      </a>
    </li>
  </xsl:template>

  <xsl:template name="Leads">
    <li>
      <xsl:if test="$currentPage/@parentID = 1098 or $currentPage/@id = 1098">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/leads">
        <i class="icon-bars">
          <xsl:text>
		</xsl:text>
        </i>Leads
      </a>
    </li>
  </xsl:template>

  <xsl:template name="Reporting">
    <li>
      <xsl:if test="$currentPage/@id = 1467">
        <xsl:attribute name="class">current</xsl:attribute>
      </xsl:if>
      <a href="/reporting">
        <i class="icon-file-powerpoint">
          <xsl:text>
		</xsl:text>
        </i>Reports
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>