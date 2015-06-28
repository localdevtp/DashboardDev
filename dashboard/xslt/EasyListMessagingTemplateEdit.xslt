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
			SmsFieldsError,
			EmailTemplateFieldsError,
			TemplatesFieldsError,
			SenderFieldsError,
			SMTPFieldsError,
			Success,
			NotPostBack,
			NotAuthorized,
			Redirect,
			SendPreviewSuccess
		};

		/********** Private instance variables **********/
		private Dictionary<string, string> _Values = new Dictionary<string, string>();

		/********** Properties **********/
		public string Error { get; set; }
		public HttpSessionState Session { get { return HttpContext.Current.Session; } }
		public string RedirectLocation { get; set; }		
		public HttpRequest Request { get { return HttpContext.Current.Request; } }
		public HttpResponse Response { get { return HttpContext.Current.Response; } }
		public string GlobalCrudRestUrl { get { return ConfigurationManager.AppSettings["GlobalCrudRestUrl"]; } }
		public string GlobalCrudRestKey { get { return ConfigurationManager.AppSettings["GlobalCrudRestKey"]; } }	
		public string MessagingCrudRestUrl { get { return ConfigurationManager.AppSettings["MessagingCrudRestUrl"]; } }
		public bool IsPostBack {
			get {
				if (Request.Form["IsPostBack"] != null && Request.Form["IsPostBack"] =="true") {
					return true;
				}
				return false;
			}
		}
		public bool IsEditSMS {
			get {
				if (Request["type"] != null && Request["type"].Equals("SMS", StringComparison.InvariantCultureIgnoreCase) ) {
					return true;
				}
				return false;
			}
		}
		public bool IsEditEmail {
			get {
				if (Request["type"] != null && Request["type"].Equals("Email", StringComparison.InvariantCultureIgnoreCase) ) {
					return true;
				}
				return false;
			}
		}
		public bool IsUpdate {
			get {
				if (Request.Form["update-template"] != null && Request.Form["update-template"] == "true") {
					return true;
				}
				return false;
			}
		}
		public bool IsDelete {
			get {
				if (Request.Form["delete-template"] != null && Request.Form["delete-template"] == "true") {
					return true;
				}
				return false;
			}
		}
		public bool IsPreview {
			get {
				if (Request.Form["send-preview"] != null && Request.Form["send-preview"] == "true") {
					return true;
				}
				return false;
			}
		}

		/********** XSLT getter **********/
		public string GetError() { return (Error == null) ? "" : Error; }
		public string GetValue(string name) {
			if (_Values.ContainsKey(name)) {
				return _Values[name];
			}

			return string.Empty;
		}

		private void LoadSMSFormData() {
			_Values["item"] = (Request.Form["item"] == null) ? Request["item"] : Request.Form["item"];

			_Values["template-name"] = Request.Form["template-name"];
			_Values["gateway-reply-email-address"] = Request.Form["gateway-reply-email-address"];
			_Values["message-template"] = HttpUtility.HtmlDecode(Request.Form["message-template"]);
		}

		private void LoadEmailFormData() {
			_Values["item"] = (Request.Form["item"] == null) ? Request["item"] : Request.Form["item"];

			_Values["template-name"] = Request.Form["template-name"];
			_Values["subject-template"] = Request.Form["subject-template"];
			_Values["message-template-html"] = HttpUtility.HtmlDecode(Request.Form["message-template-html"]);
			_Values["message-template-plaintext"] = HttpUtility.HtmlDecode(Request.Form["message-template-plaintext"]);
			_Values["sender-display-name"] = Request.Form["sender-display-name"];
			_Values["sender-email-address"] = Request.Form["sender-email-address"];
			_Values["reply-to-address"] = Request.Form["reply-to-address"];
			_Values["smtp-server"] = Request.Form["smtp-server"];
			_Values["smtp-port"] = Request.Form["smtp-port"];
			_Values["smtp-use-ssl"] = string.IsNullOrWhiteSpace(Request.Form["smtp-use-ssl"]) ? "" : Request.Form["smtp-use-ssl"];
			_Values["smtp-user-name"] = Request.Form["smtp-user-name"];
			_Values["smtp-password"] = Request.Form["smtp-password"];
			_Values["timeout-in-seconds"] = Request.Form["timeout-in-seconds"];
		}

		private void LoadSMSData() {
			if (Request["item"] == "") {
				throw new Exception("item parameter was not passed in");
			}

			GetSMSTemplateEntryResponse response =
				HttpInvocation.PostRequest<GetSMSTemplateEntryResponse>(
					MessagingCrudRestUrl + "/GetSMSTemplateEntry",
					GlobalCrudRestKey,
					new GetSMSTemplateEntryRequest() { Id = Request["item"] },
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				throw new Exception(response.ResponseDescription);
			}

			_Values["item"] = response.SMSTemplateEntry.Id;
			_Values["template-name"] = response.SMSTemplateEntry.TemplateName;
			_Values["gateway-reply-email-address"] = response.SMSTemplateEntry.GatewayReplyEmailAddress;
			_Values["message-template"] = response.SMSTemplateEntry.MessageTemplate;
		}

		private void LoadEmailData() {
			if (Request["item"] == "") {
				throw new Exception("item parameter was not passed in");
			}

			GetEmailTemplateEntryResponse response =
				HttpInvocation.PostRequest<GetEmailTemplateEntryResponse>(
					MessagingCrudRestUrl + "/GetEmailTemplateEntry",
					GlobalCrudRestKey,
					new GetEmailTemplateEntryRequest() { Id = Request["item"] },
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				throw new Exception(response.ResponseDescription);
			}

			_Values["item"] = response.EmailTemplateEntry.Id;
			_Values["template-name"] = response.EmailTemplateEntry.TemplateName;
			_Values["subject-template"] = response.EmailTemplateEntry.SubjectTemplate;
			_Values["message-template-html"] = response.EmailTemplateEntry.MessageTemplateHTML;
			_Values["message-template-plaintext"] = response.EmailTemplateEntry.MessageTemplatePlaintext;
			_Values["sender-display-name"] = response.EmailTemplateEntry.SenderDisplayName;
			_Values["sender-email-address"] = response.EmailTemplateEntry.SenderEmailAddress;
			_Values["reply-to-address"] = response.EmailTemplateEntry.ReplyToAddress;
			_Values["smtp-server"] = response.EmailTemplateEntry.SMTPServer;
			_Values["smtp-port"] = response.EmailTemplateEntry.SMTPPort.ToString();
			_Values["smtp-use-ssl"] = response.EmailTemplateEntry.SMTPUseSSL ? "true" : "";
			_Values["smtp-user-name"] = response.EmailTemplateEntry.SMTPUserName;
			_Values["smtp-password"] = response.EmailTemplateEntry.SMTPPassword;
			_Values["timeout-in-seconds"] = response.EmailTemplateEntry.TimeoutInSeconds.ToString();
		}

		private string UpdateEmailTemplate() {
			UpdateEmailTemplateEntryRequest request = new UpdateEmailTemplateEntryRequest();
			request.EmailTemplateEntry = new EmailTemplateEntry();

			request.EmailTemplateEntry.Id = _Values["item"];
			request.EmailTemplateEntry.TemplateName = _Values["template-name"];
			request.EmailTemplateEntry.SubjectTemplate = _Values["subject-template"];
			request.EmailTemplateEntry.MessageTemplateHTML = _Values["message-template-html"];
			request.EmailTemplateEntry.MessageTemplatePlaintext = _Values["message-template-plaintext"];
			request.EmailTemplateEntry.SenderDisplayName = _Values["sender-display-name"];
			request.EmailTemplateEntry.SenderEmailAddress = _Values["sender-email-address"];
			request.EmailTemplateEntry.ReplyToAddress = _Values["reply-to-address"];
			request.EmailTemplateEntry.SMTPServer = _Values["smtp-server"];
			try {
   				request.EmailTemplateEntry.SMTPPort = int.Parse(_Values["smtp-port"]);
			} catch (Exception) {
				Error = "SMTPPort must be of valid integer value";
				return ProcessResultType.SMTPFieldsError.ToString();
			}
			request.EmailTemplateEntry.SMTPUseSSL = (_Values["smtp-use-ssl"] == "true");
			request.EmailTemplateEntry.SMTPUserName = _Values["smtp-user-name"];
			request.EmailTemplateEntry.SMTPPassword = _Values["smtp-password"];
			try {
				request.EmailTemplateEntry.TimeoutInSeconds = int.Parse(_Values["timeout-in-seconds"]);
			} catch (Exception) {
				Error = "TimeoutInSeconds must be of valid integer value";
				return ProcessResultType.SMTPFieldsError.ToString();
			}

			UpdateEmailTemplateEntryResponse response =
				HttpInvocation.PostRequest<UpdateEmailTemplateEntryResponse>(
					MessagingCrudRestUrl + "/UpdateEmailTemplateEntry",
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					Error = response.InvalidFieldEntries[0].Message;

	 				if ("TemplateName".IndexOf(response.InvalidFieldEntries[0].FieldName) != -1) {
						return ProcessResultType.EmailTemplateFieldsError.ToString();
					}

					if ("SubjectTemplate MessageTemplateHTML MessageTemplatePlaintext".IndexOf(response.InvalidFieldEntries[0].FieldName) != -1) {
						return ProcessResultType.TemplatesFieldsError.ToString();
					}

					if("SenderDisplayName SenderEmailAddress ReplyToAddress".IndexOf(response.InvalidFieldEntries[0].FieldName) != -1) {
						return ProcessResultType.SenderFieldsError.ToString();
					}
					
					if ("SMTPServer SMTPPort SMTPUserName SMTPPassword TimeoutInSeconds".IndexOf(response.InvalidFieldEntries[0].FieldName) != -1) {
						return ProcessResultType.SMTPFieldsError.ToString();
					}
				} else {
					throw new Exception(response.ResponseDescription);
				}
			}

			RedirectLocation = "/messaging/templates?type=Email";
			return ProcessResultType.Redirect.ToString();
		}

		private string UpdateSMSTemplate() {
			UpdateSMSTemplateEntryRequest request = new UpdateSMSTemplateEntryRequest();
			request.SMSTemplateEntry = new SMSTemplateEntry();

			request.SMSTemplateEntry.Id = _Values["item"];
			request.SMSTemplateEntry.TemplateName = _Values["template-name"];
			request.SMSTemplateEntry.GatewayReplyEmailAddress =	_Values["gateway-reply-email-address"];
			request.SMSTemplateEntry.MessageTemplate = _Values["message-template"];

			UpdateSMSTemplateEntryResponse response =
				HttpInvocation.PostRequest<UpdateSMSTemplateEntryResponse>(
					MessagingCrudRestUrl + "/UpdateSMSTemplateEntry",
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					Error = response.InvalidFieldEntries[0].Message;
					return ProcessResultType.SmsFieldsError.ToString();

				} else {
					throw new Exception(response.ResponseDescription);
				}
			}

			RedirectLocation = "/messaging/templates?type=SMS";
			return ProcessResultType.Redirect.ToString();
		}

		private string RemoveEmailTemplate() {
			if (string.IsNullOrWhiteSpace(_Values["item"])) {
				throw new Exception("item not supplied");
			}

			RemoveEmailTemplateEntryRequest request = new RemoveEmailTemplateEntryRequest();
			request.Id = _Values["item"];

			RemoveEmailTemplateEntryResponse response =
				HttpInvocation.PostRequest<RemoveEmailTemplateEntryResponse>(
					MessagingCrudRestUrl + "/RemoveEmailTemplateEntry",
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					Error = response.InvalidFieldEntries[0].Message;
					return ProcessResultType.SmsFieldsError.ToString();

				} else {
					throw new Exception(response.ResponseDescription);
				}
			}

			RedirectLocation = "/messaging/templates?type=Email";
			return ProcessResultType.Redirect.ToString();
		}

		private string RemoveSMSTemplate() {
			if (string.IsNullOrWhiteSpace(_Values["item"])) {
				throw new Exception("item not supplied");
			}

			RemoveSMSTemplateEntryRequest request = new RemoveSMSTemplateEntryRequest();
			request.Id = _Values["item"];

			RemoveSMSTemplateEntryResponse response =
				HttpInvocation.PostRequest<RemoveSMSTemplateEntryResponse>(
					MessagingCrudRestUrl + "/RemoveSMSTemplateEntry",
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					Error = response.InvalidFieldEntries[0].Message;
					return ProcessResultType.SmsFieldsError.ToString();

				} else {
					throw new Exception(response.ResponseDescription);
				}
			}

			RedirectLocation = "/messaging/templates?type=SMS";
			return ProcessResultType.Redirect.ToString();
		}

		private void SendSMSPreview() {
			SendSMSRequest request = new SendSMSRequest();

            request.Priority = MessagingPriority.Normal;
            request.TemplateName = _Values["template-name"];
            request.ToNumber = Request.Form["send-preview-to"];
            request.UserRef = "";

            SendSMSResponse response = HttpInvocation.PostRequest<SendSMSResponse>(
				MessagingCrudRestUrl + "/SendSMS",
				GlobalCrudRestKey,
				request,
				3,
				null,
				"Preview"
            );

            if (response.ResponseCode == ResponseCodeType.Fail) {
				throw new Exception(response.ResponseDescription);
			}
		}

		private void SendEmailPreview() {
			SendEmailRequest request = new SendEmailRequest();

            request.Priority = MessagingPriority.Normal;
            request.TemplateName = _Values["template-name"];
            request.To = Request.Form["send-preview-to"];
            request.UserRef = "";

            SendEmailResponse response = HttpInvocation.PostRequest<SendEmailResponse>(
				MessagingCrudRestUrl + "/SendEmail",
				GlobalCrudRestKey,
				request,
				3,
				null,
				"Preview"
            );

            if (response.ResponseCode == ResponseCodeType.Fail) {
				throw new Exception(response.ResponseDescription);
			}
		}

		public string Process(bool isAuthorized) {
			if (!isAuthorized) { return ProcessResultType.NotAuthorized.ToString(); }

			try {

				if (IsPostBack && IsEditSMS && IsUpdate) {
					LoadSMSFormData();
					return UpdateSMSTemplate();
				} else if (IsPostBack && IsEditEmail && IsUpdate) {
					LoadEmailFormData();
					return UpdateEmailTemplate();
				} else if (IsPostBack && IsEditSMS && IsDelete) {
					LoadEmailFormData();
					return RemoveSMSTemplate();
				} else if (IsPostBack && IsEditEmail && IsDelete) {
					LoadEmailFormData();
					return RemoveEmailTemplate();
				}

				if (IsPostBack && IsEditSMS && IsPreview) {
					LoadSMSFormData();
					string updateResult = UpdateSMSTemplate();
					if (updateResult == ProcessResultType.Redirect.ToString()) {
						SendSMSPreview();
						return ProcessResultType.SendPreviewSuccess.ToString();
					}

					return updateResult;
				} else if (IsPostBack && IsEditEmail && IsPreview) {
					LoadEmailFormData();
					string updateResult = UpdateEmailTemplate();
					if (updateResult == ProcessResultType.Redirect.ToString()) {
						SendEmailPreview();
						return ProcessResultType.SendPreviewSuccess.ToString();
					}

					return updateResult;
				}

				if (IsEditSMS) {
					LoadSMSData();
					return "LoadSMSData";
				} else if (IsEditEmail) {
					LoadEmailData();
					return "LoadEmailData";
				}

			} catch (Exception exception) {
				Error = exception.Message;
				return ProcessResultType.Error.ToString();
			}

			return ProcessResultType.NotPostBack.ToString();
		}

		public bool Redirect() {
			if (!string.IsNullOrWhiteSpace(RedirectLocation)) {
				Response.Redirect(RedirectLocation);
			}
			return true;
		}
		]]>
	</msxml:script>
<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Inline C# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
  
  <xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('EasySales Admin')" />
  <xsl:variable name="TemplateType" select="umbraco.library:RequestQueryString('type')" />
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
		<xsl:if test="$ProcessResult = 'Redirect'">
			<xsl:variable name="RedirectResult" select="LocalInline:Redirect()" />
		</xsl:if>
		  
        <xsl:if test="$ProcessResult != 'Redirect'">
          <xsl:call-template name="LoadPage">
          </xsl:call-template>
        </xsl:if>
	  
      </xsl:otherwise>
    </xsl:choose>

	<!-- Modal dialog for template delete confirmation -->
	<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 id="myModalHeader">Delete Template</h3>
		</div>
		<div class="modal-body">
			<p>Are you sure you want to delete this template "<xsl:value-of select="LocalInline:GetValue('template-name')" />" ?</p>
		</div>
		<div class="modal-footer">
			<button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
			<button id="confirm-delete-template" class="btn btn-primary">Yes</button>
		</div>
	</div>
	  
	<!-- Modal dialog for send preview confirmation -->
	<div id="sendPreviewModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 id="myModalHeader">Send Template</h3>
		</div>
		<div class="modal-body">
			<div>
				Send to (email address, phone number) <input type="text" id="send-preview-to-input" name="send-preview-to-input" />
			</div>
		</div>
		<div class="modal-footer">
			<button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
			<button id="send-preview-confirm" class="btn btn-primary">Send</button>
		</div>
	</div>
	  
  </xsl:template>

  <!-- LOADPAGE TEMPLATE -->
  <xsl:template name="LoadPage" >

	<xsl:if test="$ProcessResult = 'Error'">
		<div class="alert alert-error">
			<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
		</div>
	</xsl:if>
	  
	<xsl:if test="$ProcessResult = 'SendPreviewSuccess'">
		<div class="alert alert-info">
			<strong>Template saved and a message being queued to be process (send) successfully</strong>
		</div>	
	</xsl:if>
	    
	<div class="widget-box">
		<div class="widget-title">
			<h2><i class="icon-plus">&nbsp;</i> Edit/Delete Template</h2>
		</div>
		<!-- /widget-title -->
			  
		<!-- Loaders -->
		<div id="loading-bg" style="display:none">
			<xsl:text>
			</xsl:text>
		</div>
		<div id="loading" style="display:none">
			<img class="retina" src="/images/spinner.png" />
		</div>
		<!-- /Loaders -->

		<div class="widget-content">
			<!-- HANDLE YOUR PAGE POST PROCESSING HERE -->
					
			<xsl:choose>
				<xsl:when test="$TemplateType = 'sms'">
					<xsl:call-template name="sms-template-form" />
				</xsl:when>
				<xsl:when test="$TemplateType = 'email'">
					<xsl:call-template name="email-template-form" />
				</xsl:when>
				<xsl:otherwise>
					<!-- Not Valid Template Type Handling -->
				</xsl:otherwise>
			</xsl:choose>
			
		</div>
		<!-- /widget-content -->
		
	</div>
	<!-- /widget-box -->

  </xsl:template> 
  <!-- /LOADPAGE TEMPLATE -->

  <!-- MESSAGING SMS TEMPLATE FORM -->
  <xsl:template name="sms-template-form">

		<form id="template-form" class="form-horizontal break-desktop-large" method="POST">

			<input type="hidden" name="item">
				<xsl:attribute name="value">
					<xsl:value-of select="LocalInline:GetValue('item')" />
				</xsl:attribute>
			</input>
			
      		<!-- General -->
			<fieldset style="margin-top:-10px;" id="general">
				<legend>SMS Template</legend>

				<xsl:if test="$ProcessResult = 'SmsFieldsError'">
					<div class="alert alert-error">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
				
				<div class="form-left">

					<div class="control-group">
						<label class="control-label">Template Name</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="template-name">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('template-name')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

				</div>
				<div class="form-right">

					<div class="control-group">
						<label class="control-label">Gateway Reply Email Address</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="gateway-reply-email-address">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('gateway-reply-email-address')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

				</div>

				<div class="clearfix"><xsl:text>
				</xsl:text></div>

				<div class="control-group">
					<label class="control-label">Message Template</label>
					<div class="controls">
						<textarea name="message-template" class="input-block-level monospace" style="height:10em" onkeyup="UpdateCharCount(this)"><xsl:value-of select="LocalInline:GetValue('message-template')"/></textarea>
						<small id="char-count"></small>
					</div>
				</div>

			</fieldset>
			<!-- /General -->

			<!-- Form Actions -->
			<input type="hidden" name="type" value="SMS" />
			<input type="hidden" name="IsPostBack" value="true" />
			<input type="hidden" name="update-template" id="update-template" value="" />
			<input type="hidden" name="delete-template" id="delete-template" value="" />
			
			<input type="hidden" name="send-preview" id="send-preview" value="" />
			<input type="hidden" name="send-preview-to" id="send-preview-to" value="" />
			
			<div class="form-actions center">
				<a href="/messaging/templates" class="btn btn-large"><i class="icon-chevron-left">&nbsp;</i> Back</a>&nbsp;
				<button type="button" id="delete-template-btn" name="submit-btn" value="delete" class="btn btn-large btn-danger"><i class="icon-remove">&nbsp;</i> Delete</button>&nbsp;		  
				<button type="button" id="save-template-btn" class="btn btn-large btn-success"><i class="icon-plus">&nbsp;</i> Save</button>&nbsp;
				<div style="margin-top:5px;" class="visible-phone"><xsl:text>
				</xsl:text></div>
				<button type="button" id="send-preview-btn" class="btn btn-large btn-info"><i class="icon-paperplane">&nbsp;</i> Preview</button>
			</div>
			<!-- /Form Actions -->
			
		</form>
  </xsl:template>
  <!-- /MESSAGING SMS TEMPLATE FORM -->

  <!-- MESSAGING EMAIL TEMPLATE FORM -->
  <xsl:template name="email-template-form">

    	<form id="template-form" class="form-horizontal break-desktop-large" method="POST">

			<input type="hidden" name="item">
				<xsl:attribute name="value">
					<xsl:value-of select="LocalInline:GetValue('item')" />
				</xsl:attribute>
			</input>
			
      		<!-- General -->
			<fieldset style="margin-top:-10px;" id="general">
				<legend>Email Template</legend>
				
				<xsl:if test="$ProcessResult = 'EmailTemplateFieldsError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
				
				<div class="form-left">
					<div class="control-group">
					<label class="control-label">Template Name</label>
					<div class="controls">
						<input type="text" class="input-xlarge" name="template-name">
							<xsl:attribute name="value">
								<xsl:value-of select="LocalInline:GetValue('template-name')" />
							</xsl:attribute>
						</input>
					</div>
				</div>
				
				</div>
				
				<div class="clearfix"><xsl:text>
				</xsl:text></div>
			</fieldset>
			<!-- /General -->
			
			<!-- Templates -->
			<fieldset id="templates">
				<legend>Templates</legend>
				
				<xsl:if test="$ProcessResult = 'TemplatesFieldsError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
		
				<div class="control-group">
					<label class="control-label">Subject Template</label>
					<div class="controls">
						<input type="text" class="input-block-level" name="subject-template">
							<xsl:attribute name="value">
								<xsl:value-of select="LocalInline:GetValue('subject-template')" />
							</xsl:attribute>
						</input>
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">Message Template HTML</label>
					<div class="controls">
						<textarea id="message-template-html" name="message-template-html" class="input-block-level monospace" style="height:20em"><xsl:value-of select="LocalInline:GetValue('message-template-html')" /></textarea>
					</div>
				</div>
							
				<div class="control-group">
					<label class="control-label">Message Template Plaintext</label>
					<div class="controls">
						<textarea name="message-template-plaintext" class="input-block-level monospace" style="height:20em"><xsl:value-of select="LocalInline:GetValue('message-template-plaintext')"/></textarea>
					</div>
			</div>
			
			</fieldset>
			<!-- /Templates -->
			
			<!-- sender -->
			<fieldset id="sender">
				<legend>Sender</legend>
				
				<xsl:if test="$ProcessResult = 'SenderFieldsError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
				
				<div class="form-left">				
					<div class="control-group">
						<label class="control-label">Sender Display Name</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="sender-display-name">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('sender-display-name')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">Sender email address</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="sender-email-address">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('sender-email-address')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">Reply to Address</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="reply-to-address">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('reply-to-address')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
			
			</fieldset>
			<!-- /sender -->
			
			<!-- SMTP -->
			<fieldset id="text">
				<legend>SMTP</legend>
				
				<xsl:if test="$ProcessResult = 'SMTPFieldsError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
				
				<div class="form-left">
					<div class="control-group">
						<label class="control-label">SMTP Server</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="smtp-server">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('smtp-server')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
						
					<div class="control-group">
						<label class="control-label">SMTP Port</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="smtp-port">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('smtp-port')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
						
					<div class="control-group">
						<label class="control-label">SMTP Use SSL</label>
						<div class="controls">
							<input type="checkbox" class="input-xlarge" name="smtp-use-ssl" value="true">
								<xsl:if test="LocalInline:GetValue('smtp-use-ssl') = 'true'">
									<xsl:attribute name="checked" />
								</xsl:if>
							</input>
						</div>
					</div>	
				</div>
						
				<div class="form-right">
					<div class="control-group">
						<label class="control-label">SMTP User Name</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="smtp-user-name">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('smtp-user-name')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">SMTP Password</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="smtp-password">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('smtp-password')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">Timeout in Seconds</label>
						<div class="controls">
							<input type="text" class="input-xlarge" name="timeout-in-seconds">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('timeout-in-seconds')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
			</fieldset>
			<!-- /SMTP -->

			<!-- Form Actions -->
			<input type="hidden" name="type" value="Email" />
			<input type="hidden" name="IsPostBack" value="true" />
			<input type="hidden" name="update-template" id="update-template" value="" />
			<input type="hidden" name="delete-template" id="delete-template" value="" />
			
			<input type="hidden" name="send-preview" id="send-preview" value="" />
			<input type="hidden" name="send-preview-to" id="send-preview-to" value="" />

			
			<!--<div class="form-actions center">
				<input type="hidden" id="update-template" name="update-template" value="true" />
				<input type="hidden" id="delete-template" name="delete-template" value="false" />
				<a href="/messaging/templates" class="btn btn-large"><i class="icon-chevron-left">&nbsp;</i> Back</a>&nbsp;
				<button type="button" id="delete-template-btn" name="submit-btn" value="delete" class="btn btn-large btn-danger"><i class="icon-remove">&nbsp;</i> Delete</button>&nbsp;
				
				<div style="margin-top:5px;" class="visible-phone"><xsl:text>
				</xsl:text></div>
				
				<button type="submit" id="update-template-btn" name="submit-btn" value="save" class="btn btn-large btn-success"><i class="icon-plus">&nbsp;</i> Save</button>&nbsp;
				<button type="btn" id="send-preview-email" class="btn btn-large btn-info"><i class="icon-paperplane">&nbsp;</i> Preview</button>
			</div>-->
			
			<div class="form-actions center">
				<a href="/messaging/templates?type=Email" class="btn btn-large"><i class="icon-chevron-left">&nbsp;</i> Back</a>&nbsp;
				<button type="button" id="delete-template-btn" name="submit-btn" value="delete" class="btn btn-large btn-danger"><i class="icon-remove">&nbsp;</i> Delete</button>&nbsp;		  
				<button type="button" id="save-template-btn" class="btn btn-large btn-success"><i class="icon-plus">&nbsp;</i> Save</button>&nbsp;
				<div style="margin-top:5px;" class="visible-phone"><xsl:text>
				</xsl:text></div>
				<button type="button" id="send-preview-btn" class="btn btn-large btn-info"><i class="icon-paperplane">&nbsp;</i> Preview</button>
			</div>
			<!-- /Form Actions -->
		
		</form>
  </xsl:template>
  <!-- /MESSAGING EMAIL TEMPLATE FORM -->

</xsl:stylesheet>