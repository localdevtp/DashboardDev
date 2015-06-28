<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:LocalInline="urn:LocalInline"
	xmlns:AccScripts="urn:AccScripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:include href="EasyListStaffHelper.xslt" />
		
<xsl:param name="currentPage"/>

<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Inline C# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
	<msxml:script language="C#" implements-prefix="LocalInline">
		<msxml:assembly name="EasyList.Queue.Helpers" />
		<msxml:assembly name="EasyList.Global" />
		<msxml:assembly name="System.Configuration" />
		<msxml:assembly name="EasyList.Data.DAL.Repository.Entity" />
		<msxml:assembly name="MongoDB.Bson" />
		<msxml:assembly name="EasyList.Queue.Repo.Entity"/>
		<msxml:assembly name="EasyList.Queue.Repo"/>
		<msxml:assembly name="System.Web"/>
		
		<msxml:using namespace="EasyList.Queue.Helpers" />
		<msxml:using namespace="EasyList.Global.APIKeyCrud" />
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
  		/********** Private instance members **********/
		private List<SmsHistoryQueryResultItem> _SmsHistories;
		private List<EmailHistoryQueryResultItem> _EmailHistories;
		private List<IdValue> SMSTemplateList = new List<IdValue>();
		private List<IdValue> SMSGatewayList = new List<IdValue>();
		private List<IdValue> EmailTemplateList = new List<IdValue>();

		/********** Classes **********/
		public class IdValue {
			public string Id { get; set; }
			public string Value { get; set; }
		}

		/********** Properties **********/
		public string GlobalCrudRestUrl { get { return ConfigurationManager.AppSettings["GlobalCrudRestUrl"]; } }
		public string GlobalCrudRestKey { get { return ConfigurationManager.AppSettings["GlobalCrudRestKey"]; } }	
		public string MessagingCrudRestUrl { get { return ConfigurationManager.AppSettings["MessagingCrudRestUrl"]; } }
		public HttpRequest Request { get { return HttpContext.Current.Request; } }
		public HttpResponse Response { get { return HttpContext.Current.Response; } }
		public string Error { get; set; }
		public HttpSessionState Session { get { return HttpContext.Current.Session; } }
		public string UserCode { get { return (Session != null) ? Session["easylist-usercode"].ToString() : ""; } }

		/********** Instance getter methods for XSLT **********/
		public string GetError() { return (Error == null) ? "" : Error; }
		public string TrimStart(string s) {
			return s.TrimStart();
		}
		public string GetPrettyDateTime(string dateTimeString) {
   			return DateTime.Parse(dateTimeString).ToString("dd/MM/yyyy hh:mm:ss tt");
		}
		public XmlDocument GetSmsHistories() {
			if (_SmsHistories == null) { return new XmlDocument(); }

			return DataMarshallingHelper.ToXmlDocument<SmsHistoryQueryResultItem>(_SmsHistories);
		}
		public XmlDocument GetEmailHistories() {
			if (_EmailHistories == null) { return new XmlDocument(); }

			return DataMarshallingHelper.ToXmlDocument<EmailHistoryQueryResultItem>(_EmailHistories);
		}
		public string GetSMSTemplateName(string id) {
			try {
				return SMSTemplateList.Find(i => i.Id == id).Value;
			} catch (Exception) {
				return string.Empty;
			}
		}
		public string GetSMSGatewayName(string id) {
			try {
				return SMSGatewayList.Find(i => i.Id == id).Value;
			} catch (Exception) {
				return string.Empty;
			}
		}
		public string GetEmailTemplateName(string id) {
			try {
				return EmailTemplateList.Find(i => i.Id == id).Value;
			} catch (Exception) {
				return string.Empty;
			}
		}
		public string GetEnumMessagingPriorityNames() { return string.Join(",", Enum.GetNames(typeof(MessagingPriority))); }
		public string GetEnumSMSLogStatusTypeNames() { return string.Join(",", Enum.GetNames(typeof(SMSLogStatusType))); }
		public string GetEnumEmailLogStatusNames() { return string.Join(",", Enum.GetNames(typeof(EmailLogStatusType))); }


		private void LoadSMSTemplateList() {
			try {
				ListSMSTemplateMinimalResponse response = HttpInvocation.PostRequest<ListSMSTemplateMinimalResponse>(
					MessagingCrudRestUrl + "/ListSMSTemplateMinimal", 
					GlobalCrudRestKey, 
					new ListSMSTemplateMinimalRequest(), 
					3
				);
			
				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}

				foreach (SMSTemplate smsTemplate in response.Results) {
					SMSTemplateList.Add(new IdValue() { Id = smsTemplate._id.ToString(), Value = smsTemplate.TemplateName } );
				}
			} catch (Exception exception) {
				throw exception;
			}
		}

		private void LoadEmailTemplateList() {
			try {
				ListEmailTemplateMinimalResponse response = HttpInvocation.PostRequest<ListEmailTemplateMinimalResponse>(
					MessagingCrudRestUrl + "/ListEmailTemplateMinimal", 
					GlobalCrudRestKey, 
					new ListEmailTemplateMinimalRequest(), 
					3
				);
			
				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}

				foreach (EmailTemplate emailTemplate in response.Results) {
					EmailTemplateList.Add(new IdValue() { Id = emailTemplate._id.ToString(), Value = emailTemplate.TemplateName } );
				}
			} catch (Exception exception) {
				throw exception;
			}
		}

		private void LoadSMSGatewayList() {
			try {
				ListSMSGatewayMinimalResponse response = HttpInvocation.PostRequest<ListSMSGatewayMinimalResponse>(
					MessagingCrudRestUrl + "/ListSMSGatewayMinimal", 
					GlobalCrudRestKey, 
					new ListSMSGatewayMinimalRequest(), 
					3
				);
			
				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}
			
				foreach (SMSGateway smsGateway in response.Results) {
					SMSGatewayList.Add(new IdValue() { Id = smsGateway._id.ToString(), Value = smsGateway.GatewayName } );
				}
			} catch (Exception exception) {
				throw exception;
			}
		}

		private void LoadSmsHistories(bool isGodLevel) {
			GetUserSmsHistoryRequest request;

			if (isGodLevel) {
				request = new GetUserSmsHistoryRequest() {
					SmsHistoryQuery = new SmsHistoryQuery() {
						Sorting = new Sorting() { FieldName = "RequestTimestamp", Order = Sorting.SortingOrder.Descending },
						Limit = 10,
						Skip = 0
					}
				};
			} else {
				request = new GetUserSmsHistoryRequest() {
					SmsHistoryQuery = new SmsHistoryQuery() {
						UserAgent = new StringCriteria() { StringValue = "ToUser" },
						UserRef = new StringCriteria() { StringValue = UserCode, RegularExpression = @"([,]|[ ]*)?\b{0}\b([,]|[ ]*)?" },
						Sorting = new Sorting() { FieldName = "RequestTimestamp", Order = Sorting.SortingOrder.Descending },
						Limit = 10,
						Skip = 0
					}
				};
			}

			GetUserSmsHistoryResponse response = 
				HttpInvocation.PostRequest<GetUserSmsHistoryResponse>(
					MessagingCrudRestUrl + "/GetUserSmsHistory",
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				throw new Exception(response.ResponseDescription);
			}

			_SmsHistories = response.results;
		}

		private void LoadEmailHistories(bool isGodLevel) {
			GetUserEmailHistoryRequest request;

			if (isGodLevel) {
				request = new GetUserEmailHistoryRequest() {
					EmailHistoryQuery = new EmailHistoryQuery() {
						Sorting = new Sorting() { FieldName = "RequestTimestamp", Order = Sorting.SortingOrder.Descending },
						Limit = 10,
						Skip = 0
					}
				};
			} else {
				request = new GetUserEmailHistoryRequest() {
					EmailHistoryQuery = new EmailHistoryQuery() {
						UserAgent = new StringCriteria() { StringValue = "ToUser" },
						UserRef = new StringCriteria() { StringValue = UserCode, RegularExpression = @"([,]|[ ]*)?\b{0}\b([,]|[ ]*)?" },
						Sorting = new Sorting() { FieldName = "RequestTimestamp", Order = Sorting.SortingOrder.Descending },
						Limit = 10,
						Skip = 0
					}
				};
			}

			GetUserEmailHistoryResponse response = 
				HttpInvocation.PostRequest<GetUserEmailHistoryResponse>(
					MessagingCrudRestUrl + "/GetUserEmailHistory",
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				throw new Exception(response.ResponseDescription);
			}

			_EmailHistories = response.results;
		}

		public string Process(bool isAuthorized, bool isGodLevel) {
			if (!isAuthorized) { return string.Empty; }

			try {
				LoadSMSGatewayList();
				LoadEmailTemplateList();
				LoadSMSTemplateList();

				LoadSmsHistories(isGodLevel);
				LoadEmailHistories(isGodLevel);
			
			} catch (Exception) { }


			return "";
		}

		]]>
	</msxml:script>
<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Inline C# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
		
<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('Manager,Editor,Sales,RetailUser')" />
	<xsl:variable name="IsGodLevel" select="AccScripts:IsAuthorized('EasySales Admin')" />
	<xsl:variable name="ProcessResult" select="LocalInline:Process($IsAuthorized, $IsGodLevel)" />
	
<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
		
<xsl:template match="/">	
	
	<xsl:if test="$IsGodLevel = false">
		<div class="row">			
			<div class="span6">
				<xsl:call-template name="smsMessaging" />
			</div>
			<div class="span6">
				<xsl:call-template name="emailMessaging" />
			</div>
		</div>
	</xsl:if>
	
	<xsl:if test="$IsGodLevel = 'true'">
		<div class="row">
			
			<div class="span6">
				<xsl:call-template name="smsMessagingGodLevel" />
			</div>
			<div class="span6">
				<xsl:call-template name="emailMessagingGodLevel" />
			</div>
			
			
		</div>
	</xsl:if>

</xsl:template>
		
<xsl:template name="emailMessaging">
	<div class="widget-box">
		<div class="widget-title">
			<h2><i class="icon-envelop">&nbsp;</i>Lastest Email Received</h2>
		</div>
		<div class="widget-content no-padding">
			
			<table class="clean-link footable">
				
				<thead>
					<tr>
						<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">Request Timestamp</th>
						<th data-sort-ignore="true" data-hide="" class="leftalign" data-class="leftalign">Subject</th>
						<th data-sort-ignore="true" data-hide="">Text Content</th>
					</tr>
				</thead>
				
				<tbody>
					<xsl:for-each select="LocalInline:GetEmailHistories()/ArrayOfEmailHistoryQueryResultItem/EmailHistoryQueryResultItem">
						<tr>
							<td><xsl:value-of select="LocalInline:GetPrettyDateTime(RequestTimestamp)" /></td>
							<td><xsl:value-of select="Subject" /></td>
							<td><a href="#emailContentModal" data-content="{LocalInline:TrimStart(MessagePlaintext)}"><span class="label">Show</span></a></td>
						</tr>
					</xsl:for-each>
				</tbody>
				
				
			</table>
			
		</div>
	</div>
</xsl:template>
		
<xsl:template name="smsMessaging">	
	<div class="widget-box">
		<div class="widget-title">
			<h2><i class="icon-mobile">&nbsp;</i>Lastest SMS Received</h2>
		</div>
		<div class="widget-content no-padding">
			
			<table class="clean-link footable">
				
				<thead>
					<tr>
						<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">Request Timestamp</th>
						<th data-sort-ignore="true" class="leftalign" data-class="leftalign">Message</th>
					</tr>
				</thead>
				
				<tbody>
					<xsl:for-each select="LocalInline:GetSmsHistories()/ArrayOfSmsHistoryQueryResultItem/SmsHistoryQueryResultItem">
						<tr>
							<td><xsl:value-of select="LocalInline:GetPrettyDateTime(RequestTimestamp)" /></td>
							<td><xsl:value-of select="Message" /></td>
						</tr>
					</xsl:for-each>
				</tbody>
				
			</table>
			
		</div>
	</div>
</xsl:template>


<xsl:template name="emailMessagingGodLevel">
	<div class="widget-box">
		<div class="widget-title">
			<h2><i class="icon-envelop">&nbsp;</i>Lastest Email</h2>
		</div>
		<div class="widget-content no-padding">
			
			<table class="clean-link footable">
				
				<thead>
					<tr>
						<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">Request Timestamp</th>
						<th data-sort-ignore="true" data-hide="" class="leftalign" data-class="leftalign">Subject</th>
						<th data-sort-ignore="true" data-hide="">Content</th>
						<th data-sort-ignore="true" data-hide="">Log Status</th>
						
						<th data-sort-ignore="true" data-hide="all">User Ref</th>
						<th data-sort-ignore="true" data-hide="all">To</th>
						<th data-sort-ignore="true" data-hide="all">User Agent</th>
						<th data-sort-ignore="true" data-hide="all">_id</th>
						<th data-sort-ignore="true" data-hide="all">First Processed Timestamp</th>
						<th data-sort-ignore="true" data-hide="all">User IP</th>
						<th data-sort-ignore="true" data-hide="all">Template Id</th>
						<th data-sort-ignore="true" data-hide="all">Priority</th>
						<th data-sort-ignore="true" data-hide="all">CC</th>
						<th data-sort-ignore="true" data-hide="all">BCC</th>						
						<th data-sort-ignore="true" data-hide="all">Retry Count</th>
						<th data-sort-ignore="true" data-hide="all">Last Processing Timestamp</th>
					</tr>
				</thead>
				
				<tbody>
					<xsl:for-each select="LocalInline:GetEmailHistories()/ArrayOfEmailHistoryQueryResultItem/EmailHistoryQueryResultItem">
						<tr>
							<td><xsl:value-of select="LocalInline:GetPrettyDateTime(RequestTimestamp)" /></td>
							<td><xsl:value-of select="Subject" /></td>
							
							<td>
								<a href="#emailContentModal" data-content="{LocalInline:TrimStart(MessagePlaintext)}"><span class="label"><small>Text</small></span></a>
								&nbsp;<a href="#emailContentModal" data-content="{LocalInline:TrimStart(MessageHtml)}"><span class="label"><small>HTML</small></span></a>
							</td>
							
							<xsl:if test="EmailLogStatus = 'Sent'">
								<td><span class="label label-success"><xsl:value-of select="EmailLogStatus"/></span></td>
							</xsl:if>
							<xsl:if test="EmailLogStatus = 'Unsent'">
								<td><span class="label"><xsl:value-of select="EmailLogStatus"/></span></td>
							</xsl:if>
							<xsl:if test="EmailLogStatus = 'SendError'">
								<td><span class="label label-important"><xsl:value-of select="EmailLogStatus"/></span></td>
							</xsl:if>
							
							<td><xsl:value-of select="UserRef"/></td>
							<td><xsl:value-of select="To"/></td>
							<td><xsl:value-of select="UserAgent"/></td>
							<td><xsl:value-of select="_id"/></td>
							<td><xsl:value-of select="LocalInline:GetPrettyDateTime(FirstProcessedTimestamp)"/></td>
							<td><xsl:value-of select="UserIP"/></td>
							<td><xsl:value-of select="LocalInline:GetEmailTemplateName(TemplateId)"/> (<xsl:value-of select="TemplateId" />)</td>
							<td><xsl:value-of select="Priority"/></td>
							<td><xsl:value-of select="CC"/></td>
							<td><xsl:value-of select="BCC"/></td>
							
							<td><xsl:value-of select="RetryCount"/></td>
							<td><xsl:value-of select="LocalInline:GetPrettyDateTime(LastProcessingTimestamp)"/></td>
						</tr>
					</xsl:for-each>
				</tbody>
				
				
			</table>
			
		</div>
	</div>
</xsl:template>
		
<xsl:template name="smsMessagingGodLevel">	
	<div class="widget-box">
		<div class="widget-title">
			<h2><i class="icon-mobile">&nbsp;</i>Lastest SMS</h2>
		</div>
		<div class="widget-content no-padding">
			
			<table class="clean-link footable">
				
				<thead>
					<tr>
						<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">Request Timestamp</th>
						<th data-sort-ignore="true" class="leftalign" data-class="leftalign">Message</th>
						<th data-sort-ignore="true" data-hide="">Log Status</th>
						
						<th data-sort-ignore="true" data-hide="all">User Ref</th>
						<th data-sort-ignore="true" data-hide="all">To Number</th>
						<th data-sort-ignore="true" data-hide="all">User Agent</th>
						<th data-sort-ignore="true" data-hide="all">_id</th>
						<th data-sort-ignore="true" data-hide="all">First Processed Timestamp</th>
						<th data-sort-ignore="true" data-hide="all">User IP</th>
						<th data-sort-ignore="true" data-hide="all">Template Id</th>
						<th data-sort-ignore="true" data-hide="all">Priority</th>
						<th data-sort-ignore="true" data-hide="all">Gateway Id</th>
						<th data-sort-ignore="true" data-hide="all">Retry Count</th>
						<th data-sort-ignore="true" data-hide="all">Last Processing Timestamp</th>
					</tr>
				</thead>
				
				<tbody>
					<xsl:for-each select="LocalInline:GetSmsHistories()/ArrayOfSmsHistoryQueryResultItem/SmsHistoryQueryResultItem">
						<tr>
							<td><xsl:value-of select="LocalInline:GetPrettyDateTime(RequestTimestamp)" /></td>
							<td><xsl:value-of select="Message" /></td>
							
							<xsl:if test="SMSLogStatus = 'Sent'">
								<td><span class="label label-success"><xsl:value-of select="SMSLogStatus"/></span></td>
							</xsl:if>
							<xsl:if test="SMSLogStatus = 'Unsent'">
								<td><span class="label"><xsl:value-of select="SMSLogStatus"/></span></td>
							</xsl:if>
							<xsl:if test="SMSLogStatus = 'SendError'">
								<td><span class="label label-important"><xsl:value-of select="SMSLogStatus"/></span></td>
							</xsl:if>
							
							<td><xsl:value-of select="UserRef"/></td>
							<td><xsl:value-of select="ToNumber"/></td>
							<td><xsl:value-of select="UserAgent"/></td>
							<td><xsl:value-of select="_id"/></td>
							<td><xsl:value-of select="LocalInline:GetPrettyDateTime(FirstProcessedTimestamp)"/></td>
							<td><xsl:value-of select="UserIP"/></td>
							<td><xsl:value-of select="LocalInline:GetSMSTemplateName(TemplateId)"/> (<xsl:value-of select="TemplateId" />)</td>
							<td><xsl:value-of select="Priority"/></td>
							<td><xsl:value-of select="LocalInline:GetSMSGatewayName(GatewayId)"/>  (<xsl:value-of select="GatewayId" />)</td>
							<td><xsl:value-of select="RetryCount"/></td>
							<td><xsl:value-of select="LocalInline:GetPrettyDateTime(LastProcessingTimestamp)"/></td>
						</tr>
					</xsl:for-each>
				</tbody>
				
			</table>
			
		</div>
	</div>
</xsl:template>
		
</xsl:stylesheet>