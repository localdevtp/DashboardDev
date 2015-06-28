<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:scripts="urn:scripts.this"
	xmlns:RESTscripts="urn:RESTscripts.this"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:LocalInline="urn:LocalInline"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListCommonTemplate.xslt" />
	<xsl:include href="EasyListRestHelper.xslt" />
	<xsl:include href="EasyListHelper.xslt" />
	<xsl:include href="EasyListStaffHelper.xslt" />

<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Inline C# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	<msxml:script language="C#" implements-prefix="LocalInline">
		<msxml:assembly name="EasyList.Queue.Helpers" />
		<msxml:assembly name="EasyList.Global" />
		<msxml:assembly name="System.Configuration" />
		<msxml:assembly name="EasyList.Data.DAL.Repository.Entity" />
		
		<msxml:using namespace="EasyList.Queue.Helpers" />
		<msxml:using namespace="EasyList.Global.APIKeyCrud" />
		<msxml:using namespace="System.Configuration" />
		<msxml:using namespace="System.Xml" />
		<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.OTP" />
		
		<![CDATA[
		private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

		public string GlobalCrudRestUrl { get { return ConfigurationManager.AppSettings["GlobalCrudRestUrl"]; } }
		public string GlobalCrudRestKey { get { return ConfigurationManager.AppSettings["GlobalCrudRestKey"]; } }	
		
		public string Replace(string s, string a, string b) {
			return s.Replace(a, b);
		}

		public XmlDocument GetAPIKeyItemList() {
			try {
				ListAPIKeyResponse listAPIKeyResponse =  HttpInvocation.PostRequest<ListAPIKeyResponse>(
					GlobalCrudRestUrl + "/ListAPIKey", 
					GlobalCrudRestKey, 
					new ListAPIKeyRequest(), 
					3
				);
				
				if (listAPIKeyResponse.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(listAPIKeyResponse.ResponseDescription);
				}

				listAPIKeyResponse.APIKeyItems.RemoveAll(x => x.Secret == GlobalCrudRestKey);

				return DataMarshallingHelper.ToXmlDocument<APIKeyItem>(listAPIKeyResponse.APIKeyItems);
			} catch (Exception exception) {
				logger.ErrorException("EasyListMessagingAPI.xslt", exception);
				throw exception;
			}
		}
		]]>
	</msxml:script>
<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Inline C# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('EasySales Admin')" />
	<xsl:variable name="APIKeyItemList" select="LocalInline:GetAPIKeyItemList()" />

<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

	<xsl:param name="currentPage"/>

	<xsl:template match="/">

		<ul	class="nav nav-pills">
			<li><a href="/messaging"><i class="icon-clock">&nbsp;</i>History</a></li>
			<xsl:if test="$IsAuthorized != false">
			<li><a href="/messaging/config"><i class="icon-cog">&nbsp;</i>Configuration</a></li>
			<li class="active"><a href="/messaging/api"><i class="icon-code">&nbsp;</i>API</a></li>
			<li><a href="/messaging/templates"><i class="icon-insert-template">&nbsp;</i>Templates</a></li>
			</xsl:if>
		</ul>		

		<xsl:choose>
			<xsl:when test="$IsAuthorized = false">
				<div class="alert alert-error">
					<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="count($APIKeyItemList/ArrayOfAPIKeyItem/APIKeyItem) &gt; 0">
						<xsl:call-template name="LoadPage">
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<div class="toolbars">
							<a class="btn btn-success" href="/messaging/api/create">
								<i class="icon-plus">&nbsp;</i> Add New API Key
							</a>
						</div>
						<div class="alert alert-info">No api keys to display</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- LOADPAGE TEMPLATE -->
	<xsl:template name="LoadPage" >

		<div class="widget-box">
			<div class="widget-title">
				<h2><i class="icon-code">&nbsp;</i> Messaging API</h2>
			</div>
			<!-- /widget-title -->

			<div class="widget-content no-padding loading-container">
				<xsl:call-template name="loader" />
				
				<div id="placeholder">
					<xsl:call-template name="apiList" />
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

	<!-- MESSAGING API FORM TEMPLATE -->
	<xsl:template name="LoadForm">
		<form class="form-horizontal break-large-desktop">
			<div class="form-left">
				&nbsp;
			</div>
			<div class="form-right">
				&nbsp;
			</div>
		</form>
	</xsl:template>
	<!-- /MESSAGING API FORM TEMPLATE -->

	<!-- MESSAGING API LIST TEMPLATE -->
	<xsl:template name="apiList">
		<div class="toolbars">
			<a class="btn btn-success" href="/messaging/api/create">
				<i class="icon-plus">&nbsp;</i> Add New API Key
			</a>
		</div>
		<div class="widget-collapse-options"><xsl:text>
		</xsl:text></div>
			<table class="footable">
				<thead>
					<tr>
						<th data-class="expand">Secret</th>
						<th>Description</th>
						<th data-hide="phone" data-class="leftalign" class="leftalign">Access List</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="$APIKeyItemList/ArrayOfAPIKeyItem/APIKeyItem">
					<tr>
						<td><a href="/messaging/api/edit?item={Secret}"><xsl:value-of select="Secret" /></a></td>
						<td><xsl:value-of select="Description" /></td>
						<td><xsl:value-of select="LocalInline:Replace(AccessList, ',', ', ')" /></td>
					</tr>
					</xsl:for-each>
				</tbody>
			</table>
	</xsl:template>
	<!-- /MESSAGING API LIST TEMPLATE -->

</xsl:stylesheet>