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
		<msxml:assembly name="MongoDB.Bson" />
		<msxml:assembly name="EasyList.Queue.Repo.Entity"/>
		<msxml:assembly name="EasyList.Queue.Repo"/>
		
		<msxml:using namespace="EasyList.Queue.Helpers" />
		<msxml:using namespace="EasyList.Global.APIKeyCrud" />
		<msxml:using namespace="EasyList.Global.Config" />
		<msxml:using namespace="System.Configuration" />
		<msxml:using namespace="System.Collections.Generic" />
		<msxml:using namespace="System.Xml" />
		<msxml:using namespace="System.Web" />
		<msxml:using namespace="System.Web.SessionState" />
		<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.Queue" />
		<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.OTP" />
		<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.REST" />
		<msxml:using namespace="EasyList.Data.DAL.Repository"/>
		<msxml:using namespace="EasyList.Data.DAL.Repository.Entity"/>
		<msxml:using namespace="System.Globalization"/>
		
		<![CDATA[ 
		/********** Enums **********/
		public enum ProcessResultType {
			Error,
			Success,
			SuccessEmpty,
			NotAuthorized,
			NoOperation
		};
		enum LoadResult {
			Success,
			SuccessEmpty
		};

		/********** Properties **********/
		public string Error { get; set; }
		public string GlobalCrudRestUrl { get { return ConfigurationManager.AppSettings["GlobalCrudRestUrl"]; } }
		public string GlobalCrudRestKey { get { return ConfigurationManager.AppSettings["GlobalCrudRestKey"]; } }	
		public string MessagingCrudRestUrl { get { return ConfigurationManager.AppSettings["MessagingCrudRestUrl"]; } }
		public HttpRequest Request { get { return HttpContext.Current.Request; } }
		public HttpResponse Response { get { return HttpContext.Current.Response; } }
		public HttpSessionState Session { get { return HttpContext.Current.Session; } }
		public List<SMSTemplateEntry> SMSTemplateEntries { get; set; }
		public List<EmailTemplateEntry> EmailTemplateEntries { get; set; }
		public string QueryType { get { return Request["type"]; } }
		public bool IsSmsQuery { get { return QueryType == "SMS"; } }
		public bool IsEmailQuery { get { return QueryType == "Email"; } }

		/********** XSLT getter **********/
		public string GetError() { return (Error == null) ? "" : Error; }
		public XmlDocument GetSMSTemplateEntries() { return (SMSTemplateEntries == null) ? new XmlDocument() : DataMarshallingHelper.ToXmlDocument(SMSTemplateEntries); }
		public XmlDocument GetEmailTemplateEntries() { return (EmailTemplateEntries == null) ? new XmlDocument() : DataMarshallingHelper.ToXmlDocument(EmailTemplateEntries); }
		public bool GetIsSmsQuery() { return IsSmsQuery; }
		public bool GetIsEmailQuery() { return IsEmailQuery; }

		private LoadResult LoadSMSTemplateList() {
			ListSMSTemplateResponse response =
				HttpInvocation.PostRequest<ListSMSTemplateResponse> (
					MessagingCrudRestUrl + "/ListSMSTemplate", 
					GlobalCrudRestKey, 
					new ListSMSTemplateRequest(), 
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				throw new Exception(response.ResponseDescription);
			}

			SMSTemplateEntries = response.SMSTemplateEntries;

			if (SMSTemplateEntries.Count == 0) { return LoadResult.SuccessEmpty; }

			return LoadResult.Success;
		}

		private LoadResult LoadEmailTemplateList() {
			ListEmailTemplateResponse response =
				HttpInvocation.PostRequest<ListEmailTemplateResponse> (
					MessagingCrudRestUrl + "/ListEmailTemplate", 
					GlobalCrudRestKey, 
					new ListEmailTemplateRequest(), 
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				throw new Exception(response.ResponseDescription);
			}

			EmailTemplateEntries = response.EmailTemplateEntries;

			if (EmailTemplateEntries.Count == 0) { return LoadResult.SuccessEmpty; }

			return LoadResult.Success;
		}

		public string Process(bool isAuthorized) {
			if (!isAuthorized) { return ProcessResultType.NotAuthorized.ToString(); }

			try {
				if (IsSmsQuery || (!IsSmsQuery && !IsEmailQuery)) {
					if (LoadSMSTemplateList() == LoadResult.Success) {
						return ProcessResultType.Success.ToString();
					} else {
						return ProcessResultType.SuccessEmpty.ToString();
					}
				} else if (IsEmailQuery) {
					if (LoadEmailTemplateList() == LoadResult.Success) {
						return ProcessResultType.Success.ToString();
					} else {
						return ProcessResultType.SuccessEmpty.ToString();
					}
				}
			} catch (Exception exception) {
				Error = exception.Message;
				return ProcessResultType.Error.ToString();
			}

			return ProcessResultType.NoOperation.ToString();
		}
		]]>
	</msxml:script>
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Inline C# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	
	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('EasySales Admin')" />
	<xsl:variable name="ProcessResult" select="LocalInline:Process($IsAuthorized)" />
	
	<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		
		<ul class="nav nav-pills">
			<li><a href="/messaging"><i class="icon-clock">&nbsp;</i>History</a></li>
			<xsl:if test="$IsAuthorized != false">
				<li><a href="/messaging/config"><i class="icon-cog">&nbsp;</i>Configuration</a></li>
				<li><a href="/messaging/api"><i class="icon-code">&nbsp;</i>API</a></li>
				<li class="active"><a href="/messaging/templates"><i class="icon-insert-template">&nbsp;</i>Templates</a></li>
			</xsl:if>
		</ul>   
		
		<xsl:choose>
			<xsl:when test="$IsAuthorized = false">
				<div class="alert alert-error">
					<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="LoadPage" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!-- LOADPAGE TEMPLATE -->
	<xsl:template name="LoadPage" >
		
		<div class="widget-box">
			<div class="widget-title">
				<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
					<!--<li class="active">-->
					<li>
						<xsl:if test="LocalInline:GetIsSmsQuery() = 'true' or (LocalInline:GetIsSmsQuery() = false and LocalInline:GetIsEmailQuery() = false)">
							<xsl:attribute name="class">active</xsl:attribute>
						</xsl:if>
						<a id="SMSTab" href="#SMS" data-toggle="tab">
							<i class="icon-mobile">
								<xsl:text>
								</xsl:text>
							</i> SMS
						</a>
					</li>
					<li>
						<xsl:if test="LocalInline:GetIsEmailQuery() = 'true'">
							<xsl:attribute name="class">active</xsl:attribute>
						</xsl:if>
						<a id="EmailTab" href="#Email" data-toggle="tab">
							<i class="icon-envelop">
								<xsl:text>
								</xsl:text>
							</i> Email
						</a>
					</li>
				</ul>
			</div>
			<!-- /widget-title -->
			
			<div class="tab-content widget-content no-padding loading-container">
				
				<xsl:if test="LocalInline:GetIsSmsQuery() = 'true' or (LocalInline:GetIsSmsQuery() = false and LocalInline:GetIsEmailQuery() = false)">
					<div id="SMS">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="LocalInline:GetIsSmsQuery() = 'true' or (LocalInline:GetIsSmsQuery() = false and LocalInline:GetIsEmailQuery() = false)">tab-pane active</xsl:when>
								<xsl:otherwise>tab-pane</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						
						<xsl:call-template name="loader" />
						
						<xsl:call-template name="smsTemplate" />
						
					</div>
					<!-- /SMS Tab Content -->
				</xsl:if>
				
				<xsl:if test="LocalInline:GetIsEmailQuery() = 'true'">
					<div id="Email">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="LocalInline:GetIsEmailQuery() = 'true'">tab-pane active</xsl:when>
								<xsl:otherwise>tab-pane</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						
						<xsl:call-template name="loader" />
						
						<xsl:call-template name="emailTemplate" />
						
					</div>
					<!-- /Email Tab Content -->
				</xsl:if>
				
			</div>
			<!-- /widget-content -->
			
		</div>
		<!-- /widget-box -->
		
	</xsl:template> 
	<!-- /LOADPAGE TEMPLATE -->
	
	<!-- LOADING TEMPLATE -->
	<xsl:template name="loader">
		<!-- Loaders -->
		<div id="loading-bg" style="display:none">
			<xsl:text>
			</xsl:text>
		</div>
		<div id="loading" style="display:none">
			<img class="retina" src="/images/spinner.png" />
		</div>
		<!-- /Loaders --> 
	</xsl:template>
	<!-- /LOADING TEMPLATE -->
	
	<!-- SMS TEMPLATE -->
	<xsl:template name="smsTemplate">
		<div class="toolbars">
			<a class="btn btn-success" href="/messaging/templates/create?type=sms">
				<i class="icon-plus">&nbsp;</i> Add New SMS Template
			</a>
		</div>
		<!-- Maybe some check for records here? -->				
		
		<xsl:if test="$ProcessResult = 'Error'">
			<div class="alert alert-error" id="ListResult">
				<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
			</div>
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'SuccessEmpty'">
			<div class="alert alert-info" id="ListResult">
				<strong>No templates</strong>
			</div>
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'Success'">
			<xsl:call-template name="smsTemplateItems">
				<xsl:with-param name="template">sms</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- /SMS TEMPLATE -->
	
	<!-- EMAIL TEMPLATE -->
	<xsl:template name="emailTemplate">
		<div class="toolbars">
			<a class="btn btn-success" href="/messaging/templates/create?type=email">
				<i class="icon-plus">&nbsp;</i> Add New Email Template
			</a>
		</div>
		<!-- Maybe some check for records here? -->
		
		<xsl:if test="$ProcessResult = 'Error'">
			<div class="alert alert-error" id="ListResult">
				<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
			</div>
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'SuccessEmpty'">
			<div class="alert alert-info" id="ListResult">
				<strong>No templates</strong>
			</div>
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'Success'">
			<xsl:call-template name="emailTemplateItems">
				<xsl:with-param name="template">email</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- /EMAIL TEMPLATE -->
	
	<!-- SMS TEMPLATE ITEMS -->
	<xsl:template name="smsTemplateItems">
		<xsl:param name="template" />
		
		<div class="widget-collapse-options"><xsl:text>
			</xsl:text></div>
	
		<table class="footable" id="ListResult">
			<thead>
				<tr>
					<th data-class="leftalign">Template Name</th>
					<th data-hide="phone" data-class="leftalign" class="leftalign">Message Template (NVelocity format)</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="LocalInline:GetSMSTemplateEntries()/ArrayOfSMSTemplateEntry/SMSTemplateEntry" >
					<tr>
						<td><a href="/messaging/templates/edit?type={$template}&amp;item={Id}"><xsl:value-of select="TemplateName" /></a></td>
						<td><xsl:value-of select="MessageTemplate" /></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	<!-- /SMS TEMPLATE ITEMS -->  
	
	<xsl:template name="emailTemplateItems">
		<xsl:param name="template" />
		
		<div class="widget-collapse-options"><xsl:text>
			</xsl:text></div>
		<table class="footable" id="ListResult">
			<thead>
				<tr>
					<th data-class="leftalign">Template Name</th>
					<th data-hide="phone" data-class="leftalign" class="leftalign">Subject Template (NVelocity format)</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="LocalInline:GetEmailTemplateEntries()/ArrayOfEmailTemplateEntry/EmailTemplateEntry" >
					<tr>
						<td><a href="/messaging/templates/edit?type={$template}&amp;item={Id}"><xsl:value-of select="TemplateName" /></a></td>
						<td><xsl:value-of select="SubjectTemplate" /></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	
</xsl:stylesheet>