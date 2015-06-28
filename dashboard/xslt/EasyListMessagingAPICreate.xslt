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
		<msxml:assembly name="Umbraco" />
		<msxml:assembly name="interfaces" />
		
		<msxml:using namespace="EasyList.Queue.Helpers" />
		<msxml:using namespace="EasyList.Global.APIKeyCrud" />
		<msxml:using namespace="System.Configuration" />
		<msxml:using namespace="System.Xml" />
		<msxml:using namespace="System.Xml.XPath" />
		<msxml:using namespace="System.Web" />
		<msxml:using namespace="System.Collections.Generic" />
		<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.OTP" />
		<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.REST" />
		<msxml:using namespace=" System.Web.SessionState" />
		
		<msxml:using namespace="umbraco.NodeFactory" />
		
		
		<![CDATA[
		private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

		private enum ProcessPostBackResult {
			Unknown, IsQuery, IsPostBackSuccess, IsPostBackError, IsPostBackFieldError
		};
		
		public string GlobalCrudRestUrl { get { return ConfigurationManager.AppSettings["GlobalCrudRestUrl"]; } }
		public string GlobalCrudRestKey { get { return ConfigurationManager.AppSettings["GlobalCrudRestKey"]; } }	
		public HttpRequest Request { get { return HttpContext.Current.Request; } }
		public HttpResponse Response { get { return HttpContext.Current.Response; } }
		public HttpSessionState Session { get { return HttpContext.Current.Session; } }
		public bool IsPost { get { return Request.RequestType.Equals("POST", StringComparison.OrdinalIgnoreCase); } }
		public string Error { get; set; }
		public XmlDocument InvalidFieldEntries { get; set; }
		public string GetError() { return Error; }
		public XmlDocument GetInvalidFieldEntries() { return InvalidFieldEntries; }
		public Dictionary<string, string> FormValues = new Dictionary<string, string>();
		
		public string GetFormValue(string name) {
			if (IsPost && !string.IsNullOrEmpty(Request.Form["submit"]) && Request.Form[name] != null) { return Request.Form[name]; }

			if (FormValues.ContainsKey(name)) { return FormValues[name]; }

			return "";
		}

		public bool IsFormContains(string name, string value) {
			foreach (string v in GetFormValue(name).Split(',')) {
				if (v.Trim() == value) { return true; }
			}

			return false;
		}

		public string DoublePostPrevention() {
			string result = Guid.NewGuid().ToString();
		
			Session["EasyListMessagingAPIEdit.DoublePostPrevention"] = result;
		
			return result;
		}
		
		public bool IsNotDoublePost {
			get {
				if (Request.Form["DoublePostPrevention"] == null) { return false; }
			
				if (Session["EasyListMessagingAPIEdit.DoublePostPrevention"] == null) { return false; }
			
				if (Request.Form["DoublePostPrevention"] != (Session["EasyListMessagingAPIEdit.DoublePostPrevention"] as string)) { return false; }
			
				return true;
			}
		}

  		////////////////////////////////////////////////////////////////////////////////////////////////////

		private enum AclNames {
			SendOTP, 
			ValidateOTP, 
			SendSMS,
			SendEmail,
			OTPCRUD,
			MessagingCRUD,
			GlobalCRUD,
			MessagingLog
		};

		public string ProcessRequest(bool IsAuthorized) {
			if (!IsAuthorized) { return ProcessPostBackResult.Unknown.ToString(); }

   			///////////////////////////////////////////////////////////////////////

			Error = String.Empty;
   			InvalidFieldEntries = null;
			FormValues["secret"] = Guid.NewGuid().ToString();

			try {
				if (IsPost && IsNotDoublePost && Request.Form["submit"] == "add") {
					SaveAPIKeyRequest saveAPIKeyRequest = new SaveAPIKeyRequest() {
						APIKeyItem = new APIKeyItem() {
							Secret = String.IsNullOrEmpty(Request.Params["secret"]) ? "" : Request.Params["secret"],
							Description = String.IsNullOrEmpty(Request.Form["description"]) ? "" : Request.Form["description"],
							AccessList = String.IsNullOrEmpty(Request.Form["access-list"]) ? "" : Request.Form["access-list"]
						}
					};
	
					SaveAPIKeyResponse saveAPIKeyResponse = HttpInvocation.PostRequest<SaveAPIKeyResponse>(
						GlobalCrudRestUrl + "/SaveAPIKey",
						GlobalCrudRestKey,
						saveAPIKeyRequest,
						3
					);

					if (saveAPIKeyResponse.ResponseCode == ResponseCodeType.Fail) {
						if (saveAPIKeyResponse.InvalidFieldEntries != null) {
							Error = saveAPIKeyResponse.InvalidFieldEntries[0].FieldName + " - " + saveAPIKeyResponse.InvalidFieldEntries[0].Message;
							return ProcessPostBackResult.IsPostBackFieldError.ToString();
						} else {
							Error = saveAPIKeyResponse.ResponseDescription;
							return ProcessPostBackResult.IsPostBackError.ToString();
						}
					}

					return ProcessPostBackResult.IsPostBackSuccess.ToString();
				}
			} catch (Exception exception) {
				logger.Error("EasyListMessagingAPICreate.xslt", exception);
				Error = exception.ToString();
				return ProcessPostBackResult.IsPostBackError.ToString();
			}

			return ProcessPostBackResult.IsQuery.ToString();
		}

		public bool Redirect() {
			Response.Redirect("/messaging/api");
			return true;
		}
		]]>
	</msxml:script>

<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Inline C# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('EasySales Admin')" />
	<xsl:variable name="ProcessRequestResult" select="LocalInline:ProcessRequest($IsAuthorized)" />

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
					<xsl:when test="$ProcessRequestResult != 'IsPostBackSuccess'">
						<xsl:call-template name="LoadPage">
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="RedirectResult" select="LocalInline:Redirect()" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
		
	<!-- LOADPAGE TEMPLATE -->
	<xsl:template name="LoadPage" >

		<div class="widget-box">
			<div class="widget-title">
				<h2><i class="icon-code">&nbsp;</i> Add New Messaging API</h2>
			</div>
			<!-- /widget-title -->

			<div class="widget-content loading-container">
				<xsl:call-template name="LoadForm" />
			</div>
			<!-- /widget-content -->

		</div>
		<!-- /widget-box -->

	</xsl:template>	
	<!-- /LOADPAGE TEMPLATE -->

	<!-- MESSAGING API FORM TEMPLATE -->
	<xsl:template name="LoadForm">
		<xsl:if test="not(LocalInline:GetError() = '')">
			<div class="alert alert-error">
				<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
			</div>
		</xsl:if>
		
		<form  method="post" class="form-horizontal break-desktop-large">
			<input type="hidden" name="DoublePostPrevention" value="{LocalInline:DoublePostPrevention()}" />
			
			<div class="form-left">				
				
				<!-- Secret Field -->	
				<div class="control-group">
					<label class="control-label">Secret</label>
					<div class="controls">
						<input type="text" name="secret" value="{LocalInline:GetFormValue('secret')}" disabled="disabled" />&nbsp;
						<!--<button type="button" class="btn btn-info btn-inline" id="generate-secret"><i class="icon-loop"><xsl:text>
						</xsl:text></i></button>-->
						<input type="hidden" name="secret" value="{LocalInline:GetFormValue('secret')}" />
					</div>
				</div>

				<!-- Description Field -->	
				<div class="control-group">
					<label class="control-label">Description</label>
					<div class="controls">
						<input type="text" name="description" value="{LocalInline:GetFormValue('description')}" />
					</div>
				</div>
			
			</div>
			<div class="form-right">
				
				<!-- Access List -->	
				<div class="control-group">
					<label class="control-label">Access List</label>
					<div class="controls">
						<label class="checkbox">
							<input type="checkbox" name="access-list" value="SendOTP">
								<xsl:if test="LocalInline:IsFormContains('access-list', 'SendOTP') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
							SendOTP
						</label>
						<label class="checkbox">
							<input type="checkbox" name="access-list" value="ValidateOTP">
								<xsl:if test="LocalInline:IsFormContains('access-list', 'ValidateOTP') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
							ValidateOTP
						</label>
						<label class="checkbox">
							<input type="checkbox" name="access-list" value="SendSMS">
								<xsl:if test="LocalInline:IsFormContains('access-list', 'SendSMS') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
							SendSMS
						</label>
						<label class="checkbox">
							<input type="checkbox" name="access-list" value="SendEmail">
								<xsl:if test="LocalInline:IsFormContains('access-list', 'SendEmail') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
							SendEmail
						</label>
						<label class="checkbox">
							<input type="checkbox" name="access-list" value="OTPCRUD">
								<xsl:if test="LocalInline:IsFormContains('access-list', 'OTPCRUD') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
							OTPCRUD
						</label>
						<label class="checkbox">
							<input type="checkbox" name="access-list" value="MessagingCRUD">
								<xsl:if test="LocalInline:IsFormContains('access-list', 'MessagingCRUD') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
							MessagingCRUD
						</label>
						<label class="checkbox">
							<input type="checkbox" name="access-list" value="GlobalCRUD">
								<xsl:if test="LocalInline:IsFormContains('access-list', 'GlobalCRUD') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
							GlobalCRUD
						</label>
						<label class="checkbox">
							<input type="checkbox" name="access-list" value="MessagingLog">
								<xsl:if test="LocalInline:IsFormContains('access-list', 'MessagingLog') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
							MessagingLog
						</label>
					</div>
				</div>

			</div>
			<!-- Form Actions -->
			<div class="form-actions center">
				<a href="/messaging/api" class="btn btn-large"><i class="icon-chevron-left">&nbsp;</i> Back</a> &nbsp;
				
				<button type="submit" id="submit" name="submit" value="add" class="btn btn-large btn-success"><i class="icon-plus">&nbsp;</i> Add</button>
			</div>
			<!-- /Form Actions -->
		</form>
	</xsl:template>
	<!-- /MESSAGING API FORM TEMPLATE -->		
		
</xsl:stylesheet>