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
<xsl:param name="currentPage"/>

<xsl:variable name="HasChildList" select="AccScripts:HasChildList()"/>

	<xsl:variable name="dealerIDList" select="umbraco.library:Session('easylist-usercodelist')" />
	
<xsl:template match="/">

	 <!-- <textarea>
		<xsl:value-of select="$dealerIDList" />
	</textarea>  -->

<!-- start writing XSLT -->
	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,EasySales Admin')" /> 
<!-- 	<textarea>
		<xsl:value-of select="$IsAuthorized" />
	</textarea> -->
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
	
	<xsl:variable name="DealerStaffList" select="AccScripts:GetDealerStaff()" /> 
	<xsl:choose>
		<xsl:when test="string-length($DealerStaffList/error) &gt; 0">
			<div class="alert alert-error">
				<button data-dismiss="alert" class="close" type="button">×</button>
				<strong>Failed!</strong> <xsl:value-of select="$DealerStaffList/error" />
			</div>
		</xsl:when>
		<xsl:otherwise>
			<!-- Manage Accounts -->
			<xsl:variable name="DelID" select="umbraco.library:RequestQueryString('DelID')" />
			<xsl:if test="string-length($DelID) &gt; 0">
				<div class="alert alert-success">
					<button data-dismiss="alert" class="close" type="button">×</button>
					<strong>Success!</strong> The user <xsl:value-of select="$DelID"/> was deleted successfully!
				</div>
			</xsl:if>
			
			<xsl:if test="count($DealerStaffList/ArrayOfUserStaff/UserStaff) = 0">
				 <div id="easylist-no-results" class="alert alert-info">
					You haven't added any staff user logins to your account. Click Add New User to add a staff login to your account now.
				 </div>
			</xsl:if>
			
			<!-- <xsl:choose>
				<xsl:when test="$HasChildList = 'true'">
					<xsl:if test="count($DealerStaffList/ArrayOfUserStaff/UserStaff) = 0">
						 <div id="easylist-no-results" class="alert alert-info">
							You haven't added any staff user logins to your account. Click Add New User to add a staff login to your account now.
						 </div>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="count($DealerStaffList/ArrayOfUser/User) = 0">
						 <div id="easylist-no-results" class="alert alert-info">
							You haven't added any staff user logins to your account. Click Add New User to add a staff login to your account now.
						 </div>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose> -->
			
			<div class="widget-box">
				<div class="widget-title"><h2><i class="icon-users">&nbsp;</i>Manage Users</h2></div>
				<div class="widget-content no-padding">
					<div class="toolbars">
						<a class="btn btn-success" href="/staff/create">
							<i class="icon-user-add">&nbsp;</i> Add New User
						</a>
					</div>
					<div class="widget-collapse-options"><xsl:text>
					</xsl:text></div>
					<form>
						<table class="footable footable-compact">
							<thead>
								<tr>
									<xsl:choose>
										<xsl:when test="$HasChildList = 'true'">
											<th style="text-align:left;width:100px;max-width:100px;" data-class="expand">Dealer Name</th>
											<th data-hide="phone">Login Name</th>
										</xsl:when>
										<xsl:otherwise>
											<th style="text-align:left;width:100px;max-width:100px;" data-class="expand">Login Name</th>
										</xsl:otherwise>
									</xsl:choose>	
									<th data-hide="phone">First Name</th>
									<th data-hide="phone">Last Name</th>
									<th data-hide="phone">Email</th>
									<th data-hide="phone">Contact Mobile</th>
									<th>Date Created</th>
								</tr>
							</thead>							
							<tbody>
								<xsl:for-each select="$DealerStaffList/ArrayOfUserStaff/UserStaff" > 	
									<xsl:call-template name="Staff-List">
									  <xsl:with-param name="Staff" select="."></xsl:with-param>
									</xsl:call-template>
								</xsl:for-each>
							</tbody>							
						</table>
					</form>
				</div>
			</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

 <xsl:template name="Staff-List" match="User">
	<xsl:param name="Staff"/>
    <tr>
		<xsl:choose>
			<xsl:when test="$HasChildList = 'true'">
				<td>
					<xsl:value-of select="$Staff/EmpOfLoginName"/>
				</td>
				<td style="text-align:left;width:100px;max-width:100px;" class="text-ellipsis">
				  <a class="EditListing" href="/staff/edit?id={$Staff/LoginName}" title="{$Staff/LoginName}">
					<xsl:value-of select="$Staff/LoginName"/>
				  </a>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<td style="text-align:left;width:100px;max-width:100px;" class="text-ellipsis">
				  <a class="EditListing" href="/staff/edit?id={$Staff/LoginName}" title="{$Staff/LoginName}">
					<xsl:value-of select="$Staff/LoginName"/>
				  </a>
				</td>
			</xsl:otherwise>
		</xsl:choose>	
		
		<td>
			<xsl:value-of select="$Staff/FirstName"/>
		</td>
		<td>
			<xsl:value-of select="$Staff/LastName"/>
		</td>
		<td>
			<xsl:value-of select="$Staff/EmailAddress"/>
		</td>
		<td>
			<xsl:value-of select="$Staff/ContactMobile"/>
		</td>
		<td>
			<xsl:attribute name="data-value">
				<xsl:value-of select="$Staff/DateCreated" />
			</xsl:attribute>
			<xsl:value-of select="umbraco.library:FormatDateTime($Staff/DateCreated, 'dd-MM-yyyy hh:mm tt')" />
		</td>
	</tr>
</xsl:template>


</xsl:stylesheet>