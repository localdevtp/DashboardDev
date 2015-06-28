<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:scripts="urn:scripts.this"
	xmlns:RESTscripts="urn:RESTscripts.this"
	xmlns:LocalInline="urn:LocalInline"
	xmlns:AccScripts="urn:AccScripts.this"
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

		/********** Constants **********/
		private const int ITEM_PER_PAGE = 10;
		private const int MAX_PAGE_ALLOWED = 1000;

		/********** Enums **********/
		public enum ProcessResultType { 
			Error, 
			Nop, 
			NotAuthorized, 
			Empty, 
			Found, 
			GodLevelSmsFound, 
			NotGodLevelSmsFound,
			GodLevelEmailFound,
			NotGodLevelEmailFound
		}

  		/********** Classes **********/
		public class IdValue {
			public string Id { get; set; }
			public string Value { get; set; }
		}
		public class EmailHistoryQueryResultItemEx : EmailHistoryQueryResultItem { 
			public List<string> AttachmentsAsStringList { get; set; }
		}

		/********** Private members **********/
		private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();
		private List<IdValue> SMSTemplateList = new List<IdValue>();
		private List<IdValue> SMSGatewayList = new List<IdValue>();
		private List<IdValue> EmailTemplateList = new List<IdValue>();

		/********** Properties **********/
		public string GlobalCrudRestUrl { get { return ConfigurationManager.AppSettings["GlobalCrudRestUrl"]; } }
		public string GlobalCrudRestKey { get { return ConfigurationManager.AppSettings["GlobalCrudRestKey"]; } }	
		public string MessagingCrudRestUrl { get { return ConfigurationManager.AppSettings["MessagingCrudRestUrl"]; } }
		public HttpRequest Request { get { return HttpContext.Current.Request; } }
		public HttpResponse Response { get { return HttpContext.Current.Response; } }
		public HttpSessionState Session { get { return HttpContext.Current.Session; } }
		public string UserName { get { return (Session != null) ? Session["easylist-username"].ToString() : ""; } }
		public string UserCode { get { return (Session != null) ? Session["easylist-usercode"].ToString() : ""; } }
		public XmlDocument SearchResult { get; set; }
		public string ErrorMessage { get; set; }
		public int TotalPage { get; set; }
		public IRepository Repo { get { return RepositorySetup.Setup(); } }
		public string DealerPhone { get { return Repo.Single<Users>(u => u.UserName == UserName).DealerPhone; } }
		public string Email { get { return Repo.Single<Users>(u => u.UserName == UserName).Email; } }
		public int Page { get { int result; return int.TryParse(Request["page"], out result) ? result : 1; } }
		public bool IsPostBack { get { return Request["IsPostBack"] == "true"; } }
		public bool IsSearchTypeSms { get { return Request["SearchType"] == "sms"; } }
		public bool IsSearchTypeEmail { get { return Request["SearchType"] == "email"; } }
		public bool IsTooManyResult { get; set; }
		public string FreeText { get; set; }
		public long TotalCount { get; set; }
		public string ResendMessage { get; set; }
		public string ResendError { get; set; }

		/********** Instance getter methods for XSLT **********/
		public string GetResendError() { return (ResendError == null) ? string.Empty : ResendError; }
		public string GetResendMessage() { return (ResendMessage == null) ? string.Empty : ResendMessage; }
		public int GetTotalPage() { return TotalPage; }
		public string GetErrorMessage() { return (ErrorMessage == null) ? "" : ErrorMessage; }
		public XmlDocument GetSearchResult() { return (SearchResult == null) ? new XmlDocument() : SearchResult; }
		public int GetPage() { return Page; }
		public bool GetIsTooManyResult() { return IsTooManyResult; }
		public string GetUserName() { return ( (UserName == null) ? "" : UserName ); }
		public string GetUserCode() { return ( (UserCode == null) ? "" : UserCode ); }
		public string GetFreeText() { return ( (FreeText == null) ? "" : FreeText ); }
		public int Get_MAX_PAGE_ALLOWED() { return MAX_PAGE_ALLOWED; }
		public long GetTotalCount() { return TotalCount; }
		public XmlDocument ListSMSTemplateMinimal() { return DataMarshallingHelper.ToXmlDocument(SMSTemplateList); }
		public XmlDocument ListSMSGatewayMinimal() { return DataMarshallingHelper.ToXmlDocument(SMSGatewayList); }
		public XmlDocument ListEmailTemplateMinimal() { return DataMarshallingHelper.ToXmlDocument(EmailTemplateList); }
		public string GetEnumMessagingPriorityNames() { return string.Join(",", Enum.GetNames(typeof(MessagingPriority))); }
		public string GetEnumSMSLogStatusTypeNames() { return string.Join(",", Enum.GetNames(typeof(SMSLogStatusType))); }
		public string GetEnumEmailLogStatusNames() { return string.Join(",", Enum.GetNames(typeof(EmailLogStatusType))); }

		/********** Instance helper methods for XSLT **********/
		public string TrimStart(string s) {
			return s.TrimStart();
		}
		public string GetPrettyDateTime(string dateTimeString) {
   			return DateTime.Parse(dateTimeString).ToString("dd/MM/yyyy hh:mm:ss tt");
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
		public string Replace(string s, string a, string b) {
			return s.Replace(a, b);
		}
		public bool HasSearchResult() {
			return SearchResult != null;
		}

		public string Process(bool isAuthorized, bool isGodLevel) {
			if (!isAuthorized) { return ProcessResultType.NotAuthorized.ToString(); }

			try {

				LoadSMSTemplateList();
				LoadSMSGatewayList();
				LoadEmailTemplateList();
	
 				if (IsPostBack && IsSearchTypeSms) {
					SmsHistoryQuery query = CreateSmsHistoryQuery();
					query.Sorting = CreateSmsSorting();
					query.Limit = ITEM_PER_PAGE;
					query.Skip = GetSkip();

  					//if (isGodLevel) {
						ProcessSMSResend();
  					//}

					//if (!isGodLevel) { // none-god-level user can only see their own logs
					//query.UserAgent = new StringCriteria() { StringValue = "ToUser" };
					//query.UserRef = new StringCriteria() { StringValue = UserCode, RegularExpression = @"([,]|[ ]*)?\b{0}\b([,]|[ ]*)?" };
					//}
	
					GetUserSmsHistoryResponse response = 
						EasyList.Queue.Helpers.HttpInvocation.PostRequest<GetUserSmsHistoryResponse>(
						MessagingCrudRestUrl + "/GetUserSmsHistory",
						GlobalCrudRestKey,
						new GetUserSmsHistoryRequest() {
							SmsHistoryQuery = query
						}
					);

					if (response.ResponseCode == ResponseCodeType.Fail) {
						if (response.InvalidFieldEntries != null) {
							//throw new Exception(response.InvalidFieldEntries[0].FieldName + " - " + response.InvalidFieldEntries[0].Message);
							throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
						} else {
							throw new Exception(response.ResponseDescription);
						}
					}

					LocalizeDateValues(response.results);

					int totalPageFromResponse = (int)Math.Ceiling((double)response.TotalCount / ITEM_PER_PAGE);

					IsTooManyResult = (totalPageFromResponse > MAX_PAGE_ALLOWED);
					TotalPage = Math.Min(MAX_PAGE_ALLOWED, totalPageFromResponse);
					SearchResult = DataMarshallingHelper.ToXmlDocument<SmsHistoryQueryResultItem>(response.results);
					TotalCount = response.TotalCount;
	 				
					if (response.TotalCount == 0) { 
						return ProcessResultType.Empty.ToString();
					}

  					//if (isGodLevel) {
						return ProcessResultType.GodLevelSmsFound.ToString();
  					//}

  					//return ProcessResultType.NotGodLevelSmsFound.ToString();
 				} else if (IsPostBack && IsSearchTypeEmail) {
					EmailHistoryQuery query = CreateEmailHistoryQuery();
					query.Sorting = CreateEmailSorting();
					query.Limit = ITEM_PER_PAGE;
					query.Skip = GetSkip();

  					//if (isGodLevel) {
						ProcessEmailResend();
  					//}

					//if (!isGodLevel) { // none-god-level user can only see their own logs
					//query.UserAgent = new StringCriteria() { StringValue = "ToUser" };
					//query.UserRef = new StringCriteria() { StringValue = UserCode, RegularExpression = @"([,]|[ ]*)?\b{0}\b([,]|[ ]*)?" };
					//}

					GetUserEmailHistoryResponse response =
						EasyList.Queue.Helpers.HttpInvocation.PostRequest<GetUserEmailHistoryResponse>(
							MessagingCrudRestUrl + "/GetUserEmailHistory",
							GlobalCrudRestKey,
							new GetUserEmailHistoryRequest() {
								EmailHistoryQuery = query
							}
					);

					if (response.ResponseCode == ResponseCodeType.Fail) {
						if (response.InvalidFieldEntries != null) {
							throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
						} else {
							throw new Exception(response.ResponseDescription);
						}
					}
					
					LocalizeDateValues(response.results);
				
					int totalPageFromResponse = (int)Math.Ceiling((double)response.TotalCount / ITEM_PER_PAGE);

					IsTooManyResult = (totalPageFromResponse > MAX_PAGE_ALLOWED);
					TotalPage = Math.Min(MAX_PAGE_ALLOWED, totalPageFromResponse);
					SearchResult = DataMarshallingHelper.ToXmlDocument<EmailHistoryQueryResultItemEx>(
						ProcessEmailHistoryQueryResultItems(response.results)
					);
					TotalCount = response.TotalCount;

					if (response.TotalCount == 0) { 
						return ProcessResultType.Empty.ToString();
					}
				
					//if (isGodLevel) {
						return ProcessResultType.GodLevelEmailFound.ToString();
					//}
				
					//return ProcessResultType.NotGodLevelEmailFound.ToString();
				}
			} catch (InvalidFieldException exception) {
				ErrorMessage = exception.InvalidFieldEntries[0].FieldName + " - " + exception.InvalidFieldEntries[0].Message;
				return ProcessResultType.Error.ToString();
			} catch (Exception exception) {
				logger.ErrorException("EasyListMessaging.xslt", exception);
				ErrorMessage = exception.Message;
				return ProcessResultType.Error.ToString();
			}

			return ProcessResultType.Nop.ToString();
		}

		private void ProcessEmailResend() {
			ResendEmailRequest request = new ResendEmailRequest();

			request.EmailLogIds = GetResendIds();

			if (request.EmailLogIds.Count == 0) { return; }

			ResendEmailResponse response = 
				HttpInvocation.PostRequest<ResendEmailResponse>(
					MessagingCrudRestUrl + "/ResendEmail",
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				ResendError = response.ResponseDescription;
			}

			ResendMessage = "Successfully resend messages";
		}

		private void ProcessSMSResend() {
			ResendSMSRequest request = new ResendSMSRequest();

			request.SMSLogIds = GetResendIds();

			if (request.SMSLogIds.Count == 0) { return; }

			ResendSMSResponse response = 
				HttpInvocation.PostRequest<ResendSMSResponse>(
					MessagingCrudRestUrl + "/ResendSMS",
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				ResendError = response.ResponseDescription;
			}

			ResendMessage = "Successfully resend messages";
		}

		private List<string> GetResendIds() {
			List<string> result = new List<string>();

			if (!string.IsNullOrWhiteSpace(Request["resend-ids"])) {
				result.AddRange(Request["resend-ids"].Split(','));
			}

			return result;
		}

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
				logger.ErrorException("EasyListMessaging.xslt", exception);
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
				logger.ErrorException("EasyListMessaging.xslt", exception);
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
				logger.ErrorException("EasyListMessaging.xslt", exception);
				throw exception;
			}
		}

		private int GetSkip() {
			int page = Page - 1;

			page = Math.Max(0, page);

			return page * ITEM_PER_PAGE;			
		}

		private Sorting CreateSmsSorting() {
			if (!string.IsNullOrWhiteSpace(Request["SortField"]) && 
				!string.IsNullOrWhiteSpace(Request["SortDirection"])) {

				return new Sorting() { 
					FieldName = Request["SortField"],  
					Order = (Request["SortDirection"] == "Ascending") ? Sorting.SortingOrder.Ascending : Sorting.SortingOrder.Descending
				};
			}

			return new Sorting() { FieldName = "RequestTimestamp", Order = Sorting.SortingOrder.Descending };
		}

		private Sorting CreateEmailSorting() {
			if (!string.IsNullOrWhiteSpace(Request["SortField"]) && 
				!string.IsNullOrWhiteSpace(Request["SortDirection"])) {

				return new Sorting() { 
					FieldName = Request["SortField"],  
					Order = (Request["SortDirection"] == "Ascending") ? Sorting.SortingOrder.Ascending : Sorting.SortingOrder.Descending
				};
			}

			return new Sorting() { FieldName = "RequestTimestamp", Order = Sorting.SortingOrder.Descending };
		}

		private EmailHistoryQuery CreateEmailHistoryQuery() {
			EmailHistoryQuery result = new EmailHistoryQuery();

			if (!string.IsNullOrWhiteSpace(Request["UserRef"])) {
				result.UserRef = new StringCriteria() { StringValue = Request["UserRef"] };
			}

			if (!string.IsNullOrWhiteSpace(Request["RequestTimestampFromDateTime"]) ||
				!string.IsNullOrWhiteSpace(Request["RequestTimestampToDateTime"])) {
				
				DateTime datetimeResult;
			
				if (!string.IsNullOrWhiteSpace(Request["RequestTimestampFromDateTime"])) {
				if (DateTime.TryParseExact(
						Request["RequestTimestampFromDateTime"].ToString(), 
						"dd/MM/yyyy hh:mm tt", 
						CultureInfo.InvariantCulture, 
						DateTimeStyles.None, 
						out datetimeResult)) {
			
					result.RequestTimestamp = new DateTimeRangeCriteria();
					result.RequestTimestamp.FromDateTimeValue = datetimeResult;
				} else {
					throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() { 
						FieldName="RequestTimestamp", 
   						RawMessage="Please supply a dd/mm/yyyy hh:mm tt instead of {0} RequestTimestamp from" ,
						Parameters=new object[1] { Request["RequestTimestampFromDateTime"].ToString() }
					});
				}
				}
			
				if (!string.IsNullOrWhiteSpace(Request["RequestTimestampToDateTime"])) { 
				if (DateTime.TryParseExact(
						Request["RequestTimestampToDateTime"].ToString(), 
						"dd/MM/yyyy hh:mm tt", 
						CultureInfo.InvariantCulture, 
						DateTimeStyles.None, 
						out datetimeResult)) {
			
					if (result.RequestTimestamp == null) { result.RequestTimestamp = new DateTimeRangeCriteria(); }
					result.RequestTimestamp.ToDateTimeValue = datetimeResult;
				} else {
   					throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() { 
						FieldName="RequestTimestamp", 
   						RawMessage="Please supply a dd/mm/yyyy hh:mm tt instead of {0} RequestTimestamp to" ,
						Parameters=new object[1] { Request["RequestTimestampToDateTime"].ToString() }
					});
				}
				}
			}
		
			if (!string.IsNullOrWhiteSpace(Request["UserIP"])) {
				result.UserIP = new StringCriteria() { StringValue = Request["UserIP"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["UserAgent"])) {
				result.UserAgent = new StringCriteria() { StringValue = Request["UserAgent"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["TemplateId"]) && Request["TemplateId"] != "all") {
				result.TemplateId = new ObjectIdCriteria() { ObjectIdStringValue = Request["TemplateId"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["Priority"]) && Request["Priority"] != "all") {
				result.Priority = new EnumCriteria();
				result.Priority.Add<MessagingPriority>((MessagingPriority)Enum.Parse(typeof(MessagingPriority), Request["Priority"]));
			}

			if (!string.IsNullOrWhiteSpace(Request["To"])) {
				result.To = new StringCriteria() { StringValue = Request["To"] };
			}

			if (!string.IsNullOrWhiteSpace(Request["CC"])) {
				result.CC = new StringCriteria() { StringValue = Request["CC"] };
			}

			if (!string.IsNullOrWhiteSpace(Request["BCC"])) {
				result.BCC = new StringCriteria() { StringValue = Request["BCC"] };
			}

			if (!string.IsNullOrWhiteSpace(Request["Subject"])) {
				result.Subject = new StringCriteria() { StringValue = Request["Subject"] };
			}

			if (!string.IsNullOrWhiteSpace(Request["MessagePlaintext"])) {
				result.MessagePlaintext = new StringCriteria() { StringValue = Request["MessagePlaintext"] };
			}

			if (!string.IsNullOrWhiteSpace(Request["Attachments"])) {
				result.Attachments = new ArrayItemStringCriteria() { StringValue = Request["Attachments"], ArrayItemFieldName = "URL" };
			}

			if (!string.IsNullOrWhiteSpace(Request["EmailLogStatus"]) && Request["EmailLogStatus"] != "all") {
				result.EmailLogStatus = new EnumCriteria();
				result.EmailLogStatus.Add<EmailLogStatusType>((EmailLogStatusType)Enum.Parse(typeof(EmailLogStatusType), Request["EmailLogStatus"]));
			}

			return result;
		}

		private SmsHistoryQuery CreateSmsHistoryQuery() {
			SmsHistoryQuery result = new SmsHistoryQuery();
		
			if (!string.IsNullOrWhiteSpace(Request["UserRef"])) {
				result.UserRef = new StringCriteria() { StringValue = Request["UserRef"] };
			}

			if (!string.IsNullOrWhiteSpace(Request["RequestTimestampFromDateTime"]) ||
				!string.IsNullOrWhiteSpace(Request["RequestTimestampToDateTime"])) {
				
				DateTime datetimeResult;
			
				if (!string.IsNullOrWhiteSpace(Request["RequestTimestampFromDateTime"])) {
				if (DateTime.TryParseExact(
						Request["RequestTimestampFromDateTime"].ToString(), 
						"dd/MM/yyyy hh:mm tt", 
						CultureInfo.InvariantCulture, 
						DateTimeStyles.None, 
						out datetimeResult)) {
			
					result.RequestTimestamp = new DateTimeRangeCriteria();
					result.RequestTimestamp.FromDateTimeValue = datetimeResult;
				} else {
					throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() { 
						FieldName="RequestTimestamp", 
   						RawMessage="Please supply a dd/mm/yyyy hh:mm tt instead of {0} RequestTimestamp from" ,
						Parameters=new object[1] { Request["RequestTimestampFromDateTime"].ToString() }
					});
				}
				}
			
				if (!string.IsNullOrWhiteSpace(Request["RequestTimestampToDateTime"])) { 
				if (DateTime.TryParseExact(
						Request["RequestTimestampToDateTime"].ToString(), 
						"dd/MM/yyyy hh:mm tt", 
						CultureInfo.InvariantCulture, 
						DateTimeStyles.None, 
						out datetimeResult)) {
			
					if (result.RequestTimestamp == null) { result.RequestTimestamp = new DateTimeRangeCriteria(); }
					result.RequestTimestamp.ToDateTimeValue = datetimeResult;
				} else {
   					throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() { 
						FieldName="RequestTimestamp", 
   						RawMessage="Please supply a dd/mm/yyyy hh:mm tt instead of {0} RequestTimestamp to" ,
						Parameters=new object[1] { Request["RequestTimestampToDateTime"].ToString() }
					});
				}
				}
			}
		
			if (!string.IsNullOrWhiteSpace(Request["UserIP"])) {
				result.UserIP = new StringCriteria() { StringValue = Request["UserIP"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["UserAgent"])) {
				result.UserAgent = new StringCriteria() { StringValue = Request["UserAgent"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["TemplateId"]) && Request["TemplateId"] != "all") {
				result.TemplateId = new ObjectIdCriteria() { ObjectIdStringValue = Request["TemplateId"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["Priority"]) && Request["Priority"] != "all") {
				result.Priority = new EnumCriteria();
				result.Priority.Add<MessagingPriority>((MessagingPriority)Enum.Parse(typeof(MessagingPriority), Request["Priority"]));
			}
		
			if (!string.IsNullOrWhiteSpace(Request["GatewayId"]) && Request["GatewayId"] != "all") {
				result.GatewayId = new ObjectIdCriteria() { ObjectIdStringValue = Request["GatewayId"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["ToNumber"])) {
				result.ToNumber = new StringCriteria() { StringValue = Request["ToNumber"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["Message"])) {
				result.Message = new StringCriteria() { StringValue = Request["Message"] };
			}
		
			if (!string.IsNullOrWhiteSpace(Request["SMSLogStatus"]) && Request["SMSLogStatus"] != "all") {
				result.SMSLogStatus = new EnumCriteria();
				result.SMSLogStatus.Add<SMSLogStatusType>((SMSLogStatusType)Enum.Parse(typeof(SMSLogStatusType), Request["SMSLogStatus"]));
			}
		
			return result;
		}

		/********** Helper instance methods **********/
		public void LocalizeDateValues(List<SmsHistoryQueryResultItem> items) {
			foreach (SmsHistoryQueryResultItem item in items) {
				item.RequestTimestamp = item.RequestTimestamp.ToLocalTime();
				item.FirstProcessedTimestamp = item.FirstProcessedTimestamp.ToLocalTime();
				item.SentTimestamp = item.SentTimestamp.ToLocalTime();
				item.LastProcessingTimestamp = item.LastProcessingTimestamp.ToLocalTime();
			}
		}
		public void LocalizeDateValues(List<EmailHistoryQueryResultItem> items) {
   			foreach (EmailHistoryQueryResultItem item in items) {
				item.RequestTimestamp = (item.RequestTimestamp==null) ? item.RequestTimestamp : item.RequestTimestamp.ToLocalTime();
				item.FirstProcessedTimestamp = (item.FirstProcessedTimestamp == null) ? item.FirstProcessedTimestamp : item.FirstProcessedTimestamp.ToLocalTime();
				item.SentTimestamp = (item.SentTimestamp == null) ? item.SentTimestamp : item.SentTimestamp.ToLocalTime();
				item.LastProcessingTimestamp = (item.LastProcessingTimestamp == null) ? item.LastProcessingTimestamp : item.LastProcessingTimestamp.ToLocalTime();
   			}
		}
		public List<EmailHistoryQueryResultItemEx> ProcessEmailHistoryQueryResultItems(List<EmailHistoryQueryResultItem> items) {
			List<EmailHistoryQueryResultItemEx> result = new List<EmailHistoryQueryResultItemEx>();

			foreach (EmailHistoryQueryResultItem item in items) {
				result.Add(new EmailHistoryQueryResultItemEx() { 
					_id = item._id,
					UserRef = item.UserRef,
					RequestTimestamp = item.RequestTimestamp,
					FirstProcessedTimestamp = item.FirstProcessedTimestamp,
					UserIP = item.UserIP,
					UserAgent = item.UserAgent,
					TemplateId = item.TemplateId,
					To = item.To,
					CC = item.CC,
					BCC = item.BCC,
					Subject = item.Subject,
					MessageHtml = item.MessageHtml,
					MessagePlaintext = item.MessagePlaintext,
					Priority = item.Priority,
					Attachments = item.Attachments,
					AttachmentsAsStringList = GetAttachementsAsString(item.Attachments),
					EmailLogStatus = item.EmailLogStatus,
					SentTimestamp = item.SentTimestamp,
					RetryCount = item.RetryCount,
					LastProcessingTimestamp = item.LastProcessingTimestamp,
					RetryAfter = item.RetryAfter
				});
			}

			return result;
		}
		public List<string> GetAttachementsAsString(List<AttachmentInfo> attachments) {
			if (attachments == null) { return null; }
			
			List<string> result = new List<string>();

			foreach (AttachmentInfo attachment in attachments) {
				StringBuilder tmpStr = new StringBuilder();
				tmpStr
					.Append("Name = ").Append(attachment.Name).Append(", ")
					.Append("MediaType = ").Append(attachment.MediaType).Append(", ")
	 				.Append("URL = ").Append(attachment.URL);
				result.Add(tmpStr.ToString());
			}

			return result;
		}

		]]>
	</msxml:script>
<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Inline C# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->
		
<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

	<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('EasySales Admin,ESSupport')" />
	<xsl:variable name="IsGodLevel" select="AccScripts:IsAuthorized('EasySales Admin')" />
	<xsl:variable name="IsESSupport" select="AccScripts:IsAuthorized('ESSupport')" />
	<xsl:variable name="ProcessResult" select="LocalInline:Process($IsAuthorized, $IsGodLevel)" />
	<xsl:variable name="pageNumber" select="LocalInline:GetPage()" />
	
<!--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Variables declaration ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-->

	<xsl:param name="currentPage"/>

	<xsl:template match="/">

		<ul	class="nav nav-pills">
			<li class="active"><a href="/messaging"><i class="icon-clock">&nbsp;</i>History</a></li>
			<xsl:if test="$IsGodLevel != false">
			<li><a href="/messaging/config"><i class="icon-cog">&nbsp;</i>Configuration</a></li>
			<li><a href="/messaging/api"><i class="icon-code">&nbsp;</i>API</a></li>
			<li><a href="/messaging/templates"><i class="icon-insert-template">&nbsp;</i>Templates</a></li>
			</xsl:if>
		</ul>		
		
		<xsl:if test="$IsAuthorized = false">
			<div class="alert alert-error">
				<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
			</div>
		</xsl:if>
		
		<xsl:if test="$IsAuthorized = 'true'">
			<xsl:call-template name="LoadPage" />
		</xsl:if>

	</xsl:template>

	<!-- LOADPAGE TEMPLATE -->
	<xsl:template name="LoadPage" >

		<div class="widget-box">
			<div class="widget-title">
				<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
					<li class="active">
						<a id="SMSTab" href="#SMS" data-toggle="tab">
							<i class="icon-mobile">
								<xsl:text>
								</xsl:text>
							</i> SMS
						</a>
					</li>
					<li>
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
			
			<div id="detail-panel" class="tab-content widget-content no-padding loading-container">
				<div id="SMS" class="tab-pane active ">
					<xsl:call-template name="loader" />
					
					<xsl:call-template name="search">
						<xsl:with-param name="type">sms</xsl:with-param>
					</xsl:call-template>
				</div>
				<!-- /SMS Tab Content -->
				
				<div id="Email" class="tab-pane">
					<xsl:call-template name="loader" />
					
					<xsl:call-template name="search">
						<xsl:with-param name="type">email</xsl:with-param>
					</xsl:call-template>
				</div>
				<!-- /Email Tab Content -->

				<xsl:if test="$ProcessResult = 'Nop'">
					<div id="search-result" class="alert alert-info" style="margin:10px">
						Please search/filter messaging history
					</div>
				</xsl:if>

				<xsl:call-template name="searchResult" />
				
				<xsl:call-template name="paging">
					<xsl:with-param name="numberOfPages"><xsl:value-of select="LocalInline:GetTotalPage()" /></xsl:with-param>
				</xsl:call-template>
				


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
		
		<div>
			<div class="toolbars">
				<a class="btn btn-info collapsed" data-toggle="collapse">
					<xsl:attribute name="data-target">#search-filter-<xsl:value-of select="$type" /></xsl:attribute>
					<i class="icon-filter">&nbsp;</i> Search / Filter / Sort Result
				</a>
			</div>
			<div class="widget-collapse-options collapse">
				<xsl:attribute name="id">search-filter-<xsl:value-of select="$type" /></xsl:attribute>
				<div class="widget-collapse-options-inner">

					<form class="form-horizontal">
					
						<!--<xsl:if test="$type = 'sms' and $IsGodLevel = 'true'">-->
						<xsl:if test="$type = 'sms'">
							<div class="control-group">
								<label class="control-label">User Ref</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="UserRef" name="UserRef" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Request Timestamp</label>
								<div class="controls">
									<input class="text" type="datetime-local" maxlength="150" id="RequestTimestampFromDateTime" name="RequestTimestampFromDateTime" />
									&nbsp;<small>from</small>
								</div>
								<div class="controls">
									<input class="text" type="datetime-local" maxlength="150" id="RequestTimestampToDateTime" name="RequestTimestampToDateTime" />
									&nbsp;<small>to (excluded)</small>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">User IP</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="UserIP" name="UserIP" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">User Agent</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="UserAgent" name="UserAgent" />
								</div>
							</div>							
							
							<div class="control-group">
								<label class="control-label">Template Id</label>
								<div class="controls">
								<select name="TemplateId" id="TemplateId" class="input-large">
									<option value="all">All</option>
								  <xsl:for-each select="LocalInline:ListSMSTemplateMinimal()/ArrayOfIdValue/IdValue">
									<option value="{Id}"><xsl:value-of select="Value" /></option>
								  </xsl:for-each>
								</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Priority</label>
								<div class="controls">
									<select name="Priority" id="Priority">
										<option value="all">All</option>
									  <xsl:for-each select="umbraco.library:Split(LocalInline:GetEnumMessagingPriorityNames(), ',')/*">
										<option value="{.}"><xsl:value-of select="."/></option>
									  </xsl:for-each>
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Gateway Id</label>
								<div class="controls">
									<select name="GatewayId" id="GatewayId" class="input-large">
										<option value="all">All</option>
								  		<xsl:for-each select="LocalInline:ListSMSGatewayMinimal()/ArrayOfIdValue/IdValue">
											<option value="{Id}"><xsl:value-of select="Value" /></option>
								  		</xsl:for-each>
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">To Number</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="ToNumber" name="ToNumber" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Message</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="Message" name="Message" />
								</div>
							</div>	
							
							<div class="control-group">
								<label class="control-label">SMS Log Status</label>
								<div class="controls">
									<select name="SMSLogStatus">
										<option value="all">All</option>
									  <xsl:for-each select="umbraco.library:Split(LocalInline:GetEnumSMSLogStatusTypeNames(), ',')/*">
										<option value="{.}"><xsl:value-of select="."/></option>
									  </xsl:for-each>
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Sort Result by</label>
								<div class="controls">
									<select name="SortField" id="SortField" class="input-large">
										<xsl:call-template name="optionlist">
											<xsl:with-param name="options">RequestTimestamp,UserRef,ToNumber,Message,UserAgent,SMSLogStatus</xsl:with-param>
											<xsl:with-param name="value">RequestTimestamp</xsl:with-param>
										</xsl:call-template>										
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Sort Order</label>
								<div class="controls">
									<select name="SortDirection" id="SortDirection">
										<xsl:call-template name="optionlist">
											<xsl:with-param name="options">Ascending,Descending</xsl:with-param>
											<xsl:with-param name="value">Descending</xsl:with-param>
										</xsl:call-template>
									</select>
								</div>
							</div>
							
							<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
							<input type="hidden" id="SearchType" name="SearchType" value="sms" />
							
							<input type="hidden" id="resend-ids" name="resend-ids" value="" />
							
							<div class="control-group form-actions">
								<div class="controls">
									<button type="submit" id="search" class="btn btn-large">Submit</button>
								</div>
							</div>
						</xsl:if>
						
						<!--<xsl:if test="$type = 'sms' and $IsGodLevel = false">							
							<div class="control-group">
								<label class="control-label">Request Timestamp</label>
								<div class="controls">
									<input class="text" type="datetime-local" maxlength="150" id="RequestTimestampFromDateTime" name="RequestTimestampFromDateTime" />
									&nbsp;<small>from</small>
								</div>
								<div class="controls">
									<input class="text" type="datetime-local" maxlength="150" id="RequestTimestampToDateTime" name="RequestTimestampToDateTime" />
									&nbsp;<small>to</small>
								</div>
							</div>
														
							<div class="control-group">
								<label class="control-label">To Number</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="ToNumber" name="ToNumber" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Message</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="Message" name="Message" />
								</div>
							</div>	
							
							<div class="control-group">
								<label class="control-label">SMS Log Status</label>
								<div class="controls">
									<select name="SMSLogStatus">
										<option value="all">All</option>
									  <xsl:for-each select="umbraco.library:Split(LocalInline:GetEnumSMSLogStatusTypeNames(), ',')/*">
										<option value="{.}"><xsl:value-of select="."/></option>
									  </xsl:for-each>
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Sort Result by</label>
								<div class="controls">
									<select name="SortField" id="SortField" class="input-large">
										<xsl:call-template name="optionlist">
											<xsl:with-param name="options">RequestTimestamp,ToNumber,Message,SMSLogStatus</xsl:with-param>
											<xsl:with-param name="value">RequestTimestamp</xsl:with-param>
										</xsl:call-template>										
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Sort Order</label>
								<div class="controls">
									<select name="SortDirection" id="SortDirection">
										<xsl:call-template name="optionlist">
											<xsl:with-param name="options">Ascending,Descending</xsl:with-param>
											<xsl:with-param name="value">Descending</xsl:with-param>
										</xsl:call-template>
									</select>
								</div>
							</div>
							
							<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
							<input type="hidden" id="SearchType" name="SearchType" value="sms" />
							
							<input type="hidden" id="resend-ids" name="resend-ids" value="" />
							
							<div class="control-group form-actions">
								<div class="controls">
									<button type="submit" id="search" class="btn btn-large">Submit</button>
								</div>
							</div>
						</xsl:if>-->
						
						<!--<xsl:if test="$type = 'email' and $IsGodLevel = 'true'">-->
						<xsl:if test="$type = 'email'">
							<div class="control-group">
								<label class="control-label">UserRef</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="UserRef" name="UserRef" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Request Timestamp</label>
								<div class="controls">
									<input class="text" type="datetime-local" maxlength="150" id="RequestTimestampFromDateTime" name="RequestTimestampFromDateTime" />
									&nbsp;<small>from</small>
								</div>
								<div class="controls">
									<input class="text" type="datetime-local" maxlength="150" id="RequestTimestampToDateTime" name="RequestTimestampToDateTime" />
									&nbsp;<small>to (excluded)</small>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">User IP</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="UserIP" name="UserIP" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">User Agent</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="UserAgent" name="UserAgent" />
								</div>
							</div>							
							
							<div class="control-group">
								<label class="control-label">Template Id</label>
								<div class="controls">
								<select name="TemplateId" id="TemplateId" class="input-large">
									<option value="all">All</option>
								  <xsl:for-each select="LocalInline:ListEmailTemplateMinimal()/ArrayOfIdValue/IdValue">
									<option value="{Id}"><xsl:value-of select="Value" /></option>
								  </xsl:for-each>
								</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Priority</label>
								<div class="controls">
									<select name="Priority" id="Priority">
										<option value="all">All</option>
									  <xsl:for-each select="umbraco.library:Split(LocalInline:GetEnumMessagingPriorityNames(), ',')/*">
										<option value="{.}"><xsl:value-of select="."/></option>
									  </xsl:for-each>
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">To</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="To" name="To" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">CC</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="CC" name="CC" />
								</div>
							</div>

							<div class="control-group">
								<label class="control-label">BCC</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="BCC" name="BCC" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Subject</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="Subject" name="Subject" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Message Plaintext</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="MessagePlaintext" name="MessagePlaintext" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Attachments</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="Attachments" name="Attachments" />
									&nbsp;<small>URL</small>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Email Log Status</label>
								<div class="controls">
									<select name="EmailLogStatus">
										<option value="all">All</option>
									  <xsl:for-each select="umbraco.library:Split(LocalInline:GetEnumEmailLogStatusNames(), ',')/*">
										<option value="{.}"><xsl:value-of select="."/></option>
									  </xsl:for-each>
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Sort Result by</label>
								<div class="controls">
									<select name="SortField" id="SortField" class="input-large">
										<xsl:call-template name="optionlist">
											<xsl:with-param name="options">RequestTimestamp,UserRef,To,Subject,UserAgent,EmailLogStatus</xsl:with-param>
											<xsl:with-param name="value">RequestTimestamp</xsl:with-param>
										</xsl:call-template>										
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Sort Order</label>
								<div class="controls">
									<select name="SortDirection" id="SortDirection">
										<xsl:call-template name="optionlist">
											<xsl:with-param name="options">Ascending,Descending</xsl:with-param>
											<xsl:with-param name="value">Descending</xsl:with-param>
										</xsl:call-template>
									</select>
								</div>
							</div>

							<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
							<input type="hidden" id="SearchType" name="SearchType" value="email" />
							
							<input type="hidden" id="resend-ids" name="resend-ids" value="" />
							
							<div class="control-group form-actions">
								<div class="controls">
									<button type="submit" id="search" class="btn btn-large">Submit</button>
								</div>
							</div>
						</xsl:if>
						
						<!--<xsl:if test="$type = 'email' and $IsGodLevel = false">
							<div class="control-group">
								<label class="control-label">RequestTimestamp</label>
								<div class="controls">
									<input class="text" type="datetime-local" maxlength="150" id="RequestTimestampFromDateTime" name="RequestTimestampFromDateTime" />
									&nbsp;<small>from</small>
								</div>
								<div class="controls">
									<input class="text" type="datetime-local" maxlength="150" id="RequestTimestampToDateTime" name="RequestTimestampToDateTime" />
									&nbsp;<small>to (excluded)</small>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">To</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="To" name="To" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Subject</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="Subject" name="Subject" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Message Plaintext</label>
								<div class="controls">
									<input class="text" type="text" maxlength="150" id="MessagePlaintext" name="MessagePlaintext" />
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Email Log Status</label>
								<div class="controls">
									<select name="EmailLogStatus">
										<option value="all">All</option>
									  <xsl:for-each select="umbraco.library:Split(LocalInline:GetEnumEmailLogStatusNames(), ',')/*">
										<option value="{.}"><xsl:value-of select="."/></option>
									  </xsl:for-each>
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Sort Result by</label>
								<div class="controls">
									<select name="SortField" id="SortField" class="input-large">
										<xsl:call-template name="optionlist">
											<xsl:with-param name="options">RequestTimestamp,To,Subject,EmailLogStatus</xsl:with-param>
											<xsl:with-param name="value">RequestTimestamp</xsl:with-param>
										</xsl:call-template>										
									</select>
								</div>
							</div>
							
							<div class="control-group">
								<label class="control-label">Sort Order</label>
								<div class="controls">
									<select name="SortDirection" id="SortDirection">
										<xsl:call-template name="optionlist">
											<xsl:with-param name="options">Ascending,Descending</xsl:with-param>
											<xsl:with-param name="value">Descending</xsl:with-param>
										</xsl:call-template>
									</select>
								</div>
							</div>

							<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
							<input type="hidden" id="SearchType" name="SearchType" value="email" />
							
							<input type="hidden" id="resend-ids" name="resend-ids" value="" />
							
							<div class="control-group form-actions">
								<div class="controls">
									<button type="submit" id="search" class="btn btn-large">Submit</button>
								</div>
							</div>
						</xsl:if>-->
						

					</form>
				</div>
			</div>
		</div>
	</xsl:template>
	<!-- /SEARCH OPTIONS TEMPLATE -->

	<!-- SEARCH RESULT TEMPLATE -->
	<xsl:template name="searchResult">
		<xsl:if test="$ProcessResult = 'Empty'">
			<div id="search-result" class="alert alert-info" style="margin:10px">
				Search yield no result
			</div>
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'Error'">
			<div id="search-result" class="alert alert-error">
				<strong><xsl:value-of select="LocalInline:GetErrorMessage()" /></strong>
			</div>
		</xsl:if>
		
		<xsl:if test="LocalInline:GetResendMessage() != ''">
			<div id="resend-message" class="alert alert-info">
				<strong><xsl:value-of select="LocalInline:GetResendMessage()" /></strong>
			</div>
		</xsl:if>
		
		<xsl:if test="LocalInline:GetResendError() != ''">
			<div id="resend-message" class="alert alert-error">
				<strong><xsl:value-of select="LocalInline:GetResendError()" /></strong>
			</div>
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'GodLevelSmsFound'">
			<xsl:call-template name="godLevelSmsResult" />
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'NotGodLevelSmsFound'">
			<xsl:call-template name="nonGodLevelSmsResult" />
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'GodLevelEmailFound'">
			<xsl:call-template name="godLevelEmailResult" />
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'NotGodLevelEmailFound'">
			<xsl:call-template name="nonGodLevelEmailResult" />
		</xsl:if>
		
	</xsl:template>
	<!-- /SEARCH RESULT TEMPLATE -->
		
	<xsl:template name="nonGodLevelSmsResult">
		<table id="search-result" class="footable">
			<thead>
				<tr>				
					<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">RequestTimestamp</th>
					<th data-sort-ignore="true" data-hide="">ToNumber</th>
					<th data-sort-ignore="true" data-hide="" data-class="leftalign" class="leftalign">Message</th>					
					<th data-sort-ignore="true" data-hide="">SMSLogStatus</th>
					
					<th data-sort-ignore="true" data-hide="all">_id</th>
					<th data-sort-ignore="true" data-hide="all">UserRef</th>
					<th data-sort-ignore="true" data-hide="all">FirstProcessedTimestamp</th>
					<th data-sort-ignore="true" data-hide="all">UserIP</th>
					<th data-sort-ignore="true" data-hide="all">TemplateId</th>
					<th data-sort-ignore="true" data-hide="all">Priority</th>
					<th data-sort-ignore="true" data-hide="all">GatewayId</th>
					<th data-sort-ignore="true" data-hide="all">RetryCount</th>
					<th data-sort-ignore="true" data-hide="all">LastProcessingTimestamp</th>
				</tr>
			</thead>
			
			<tbody>
				<xsl:for-each select="LocalInline:GetSearchResult()/ArrayOfSmsHistoryQueryResultItem/SmsHistoryQueryResultItem">
					<tr>
						<td><xsl:value-of select="LocalInline:GetPrettyDateTime(RequestTimestamp)"/></td>
						<td><xsl:value-of select="ToNumber"/></td>
						<td><xsl:value-of select="Message"/></td>
						<xsl:if test="SMSLogStatus = 'Sent'">
							<td><span class="label label-success"><xsl:value-of select="SMSLogStatus"/></span></td>
						</xsl:if>
						<xsl:if test="SMSLogStatus = 'Unsent'">
							<td><span class="label"><xsl:value-of select="SMSLogStatus"/></span></td>
						</xsl:if>
						<xsl:if test="SMSLogStatus = 'SendError'">
							<td><span class="label label-important"><xsl:value-of select="SMSLogStatus"/></span></td>
						</xsl:if>
						
						<td><xsl:value-of select="_id"/></td>
						<td><xsl:value-of select="UserRef"/></td>
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
	</xsl:template>

	<xsl:template name="nonGodLevelEmailResult">
		<table id="search-result" class="footable">
			<thead>
				<tr>				
					<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">RequestTimestamp</th>
					<th data-sort-ignore="true" data-hide="">To</th>
					<th data-sort-ignore="true" data-hide="" data-class="leftalign" class="leftalign">Subject</th>
					<th data-sort-ignore="true" data-hide="">EmailLogStatus</th>

					<th data-sort-ignore="true" data-hide="all">_id</th>
					<th data-sort-ignore="true" data-hide="all">UserRef</th>					
					<th data-sort-ignore="true" data-hide="all">FirstProcessedTimestamp</th>
					<th data-sort-ignore="true" data-hide="all">UserIP</th>
					<th data-sort-ignore="true" data-hide="all">TemplateId</th>
					<th data-sort-ignore="true" data-hide="all">Priority</th>
					<th data-sort-ignore="true" data-hide="all">Message</th>
					<th data-sort-ignore="true" data-hide="all">Attachments</th>
					<th data-sort-ignore="true" data-hide="all">RetryCount</th>
					<th data-sort-ignore="true" data-hide="all">LastProcessingTimestamp</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="LocalInline:GetSearchResult()/ArrayOfEmailHistoryQueryResultItemEx/EmailHistoryQueryResultItemEx">
					<tr>
						<td><xsl:value-of select="LocalInline:GetPrettyDateTime(RequestTimestamp)"/></td>
						<td><xsl:value-of select="To"/></td>
						<td><xsl:value-of select="Subject"/></td>
						<xsl:if test="EmailLogStatus = 'Sent'">
							<td><span class="label label-success"><xsl:value-of select="EmailLogStatus"/></span></td>
						</xsl:if>
						<xsl:if test="EmailLogStatus = 'Unsent'">
							<td><span class="label"><xsl:value-of select="EmailLogStatus"/></span></td>
						</xsl:if>
						<xsl:if test="EmailLogStatus = 'SendError'">
							<td><span class="label label-important"><xsl:value-of select="EmailLogStatus"/></span></td>
						</xsl:if>
						
						<td><xsl:value-of select="_id"/></td>
						<td><xsl:value-of select="UserRef"/></td>						
						<td><xsl:value-of select="LocalInline:GetPrettyDateTime(FirstProcessedTimestamp)"/></td>
						<td><xsl:value-of select="UserIP"/></td>
						<td><xsl:value-of select="LocalInline:GetEmailTemplateName(TemplateId)"/> (<xsl:value-of select="TemplateId" />)</td>
						<td><xsl:value-of select="Priority"/></td>
						<td>
							<div style="width:300px;">
							<div class="text-ellipsis"><xsl:value-of select="LocalInline:TrimStart(MessagePlaintext)"/></div>
							&nbsp;<a href="#" class="popover-email-content" data-content="{LocalInline:TrimStart(MessagePlaintext)}"><span class="label"><small>Text</small></span></a>
							</div>
						</td>
						<td>
							<xsl:for-each select="AttachmentsAsStringList/string">
								<div><xsl:value-of select="." /></div>
							</xsl:for-each>
						</td>
						<td><xsl:value-of select="RetryCount"/></td>
						<td><xsl:value-of select="LocalInline:GetPrettyDateTime(LastProcessingTimestamp)"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
		
	<xsl:template name="godLevelEmailResult">
		<table id="search-result" class="footable">
			<thead>
				<tr>				
					<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">RequestTimestamp</th>
					<th data-sort-ignore="true" data-hide="">UserRef</th>
					<th data-sort-ignore="true" data-hide="">To</th>
					<th data-sort-ignore="true" data-hide="" data-class="leftalign" class="leftalign">Subject</th>
					<th data-sort-ignore="true" data-hide="">UserAgent</th>
					<th data-sort-ignore="true" data-hide="">EmailLogStatus</th>
					<th data-sort-ignore="true" data-hide="" style="width: 75px">
						<div class="dropup">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#">
								<span class="label label-warning"><small>Action<span class="caret" /></small></span>
							</a>
							<ul class="dropdown-menu pull-right pull-up" role="menu" aria-labelledby="dLabel">
								<li><a href="#" id="select-all-menu"><small>Select All</small></a></li>
								<li><a href="#" id="unselect-all-menu"><small>Unselect All</small></a></li>
								<li class="divider"></li>
								<li><a href="#" id="resend-menu"><small>Resend</small></a></li>
							</ul>
						</div>
					</th>

					<th data-sort-ignore="true" data-hide="all">_id</th>
					<th data-sort-ignore="true" data-hide="all">FirstProcessedTimestamp</th>
					<th data-sort-ignore="true" data-hide="all">UserIP</th>
					<th data-sort-ignore="true" data-hide="all">TemplateId</th>
					<th data-sort-ignore="true" data-hide="all">Priority</th>
					<th data-sort-ignore="true" data-hide="all">CC</th>
					<th data-sort-ignore="true" data-hide="all">BCC</th>
					<th data-sort-ignore="true" data-hide="all">Message</th>
					<th data-sort-ignore="true" data-hide="all">Attachments</th>
					<th data-sort-ignore="true" data-hide="all">RetryCount</th>
					<th data-sort-ignore="true" data-hide="all">LastProcessingTimestamp</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="LocalInline:GetSearchResult()/ArrayOfEmailHistoryQueryResultItemEx/EmailHistoryQueryResultItemEx">
					<tr>
						<td><xsl:value-of select="LocalInline:GetPrettyDateTime(RequestTimestamp)"/></td>
						<td><xsl:value-of select="UserRef"/></td>
						<td><xsl:value-of select="To"/></td>
						<td><xsl:value-of select="Subject"/></td>
						<td><xsl:value-of select="UserAgent"/></td>
						<td>
							<xsl:if test="EmailLogStatus = 'Sent'">
								<span class="label label-success"><xsl:value-of select="EmailLogStatus"/></span>
							</xsl:if>
							<xsl:if test="EmailLogStatus = 'Unsent'">
								<span class="label"><xsl:value-of select="EmailLogStatus"/></span>
							</xsl:if>
							<xsl:if test="EmailLogStatus = 'SendError'">
								<span class="label label-important"><xsl:value-of select="EmailLogStatus"/></span>
							</xsl:if>
							<xsl:if test="EmailLogStatus = 'ErrResend'">
								<span class="label label-warning"><xsl:value-of select="EmailLogStatus"/></span>
							</xsl:if>
						</td>
						<td>
							<input type="checkbox" class="cls-resend-chk" name="resend-chk">
								<xsl:attribute name="value">
									<xsl:value-of select="_id"/>
								</xsl:attribute>
							</input>
						</td>
						
						<td><xsl:value-of select="_id"/></td>
						<td><xsl:value-of select="LocalInline:GetPrettyDateTime(FirstProcessedTimestamp)"/></td>
						<td><xsl:value-of select="UserIP"/></td>
						<td><xsl:value-of select="LocalInline:GetEmailTemplateName(TemplateId)"/> (<xsl:value-of select="TemplateId" />)</td>
						<td><xsl:value-of select="Priority"/></td>
						<td><xsl:value-of select="CC"/></td>
						<td><xsl:value-of select="BCC"/></td>
						<td>
							<div style="width:300px;">
							<div class="text-ellipsis"><xsl:value-of select="LocalInline:TrimStart(MessagePlaintext)"/></div>
							&nbsp;<a href="#" class="popover-email-content" data-content="{LocalInline:TrimStart(MessagePlaintext)}"><span class="label"><small>Text</small></span></a>
							&nbsp;<a href="#" class="popover-email-content" data-content="{LocalInline:TrimStart(MessageHtml)}"><span class="label"><small>HTML</small></span></a>
							</div>
						</td>
						<td>
							<xsl:for-each select="AttachmentsAsStringList/string">
								<div><xsl:value-of select="." /></div>
							</xsl:for-each>
						</td>
						<td><xsl:value-of select="RetryCount"/></td>
						<td><xsl:value-of select="LocalInline:GetPrettyDateTime(LastProcessingTimestamp)"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
		
	<!-- MANAGER SMS RESULT TEMPLATE -->
	<xsl:template name="godLevelSmsResult">
		<table id="search-result" class="footable">
			<thead>
				<tr>				
					<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">RequestTimestamp</th>
					<th data-sort-ignore="true" data-hide="">UserRef</th>
					<th data-sort-ignore="true" data-hide="">ToNumber</th>
					<th data-sort-ignore="true" data-hide="" data-class="leftalign" class="leftalign">Message</th>
					<th data-sort-ignore="true" data-hide="">UserAgent</th>
					<th data-sort-ignore="true" data-hide="">SMSLogStatus</th>
					<th data-sort-ignore="true" data-hide="" style="width: 75px">
						<div class="dropup">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#">
								<span class="label label-warning"><small>Action</small><span class="caret"></span></span>
							</a>
							<ul class="dropdown-menu pull-right" role="menu" aria-labelledby="dLabel">
								<li><a href="#" id="select-all-menu">Select All</a></li>
								<li><a href="#" id="unselect-all-menu">Unselect All</a></li>
								<li class="divider"></li>
								<li><a href="#" id="resend-menu">Resend</a></li>
							</ul>
						</div>
					</th>
					
					<th data-sort-ignore="true" data-hide="all">_id</th>
					<th data-sort-ignore="true" data-hide="all">FirstProcessedTimestamp</th>
					<th data-sort-ignore="true" data-hide="all">UserIP</th>
					<th data-sort-ignore="true" data-hide="all">TemplateId</th>
					<th data-sort-ignore="true" data-hide="all">Priority</th>
					<th data-sort-ignore="true" data-hide="all">GatewayId</th>
					<th data-sort-ignore="true" data-hide="all">RetryCount</th>
					<th data-sort-ignore="true" data-hide="all">LastProcessingTimestamp</th>
				</tr>
			</thead>
			
			<tbody>
				<xsl:for-each select="LocalInline:GetSearchResult()/ArrayOfSmsHistoryQueryResultItem/SmsHistoryQueryResultItem">
					<tr>
						<td><xsl:value-of select="LocalInline:GetPrettyDateTime(RequestTimestamp)"/></td>
						<td><xsl:value-of select="UserRef"/></td>
						<td><xsl:value-of select="ToNumber"/></td>
						<td><xsl:value-of select="Message"/></td>
						<td><xsl:value-of select="UserAgent"/></td>
						<td>
							<xsl:if test="SMSLogStatus = 'Sent'">
								<span class="label label-success"><xsl:value-of select="SMSLogStatus"/></span>
							</xsl:if>
							<xsl:if test="SMSLogStatus = 'Unsent'">
								<span class="label"><xsl:value-of select="SMSLogStatus"/></span>
							</xsl:if>
							<xsl:if test="SMSLogStatus = 'SendError'">
								<span class="label label-important"><xsl:value-of select="SMSLogStatus"/></span>
							</xsl:if>
							<xsl:if test="SMSLogStatus = 'ErrResend'">
								<span class="label label-warning"><xsl:value-of select="SMSLogStatus"/></span>
							</xsl:if>
						</td>

						<td>
							<input type="checkbox" class="cls-resend-chk" name="resend-chk">
								<xsl:attribute name="value">
									<xsl:value-of select="_id"/>
								</xsl:attribute>
							</input>
						</td>
						
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
	</xsl:template>
	<!-- /MANAGER SMS RESULT TEMPLATE -->

	<!-- EMAIL RESULT TEMPLATE -->
	<!--<xsl:template name="emailMessaging">
		<table class="footable">

				<thead>
					<tr>
						<th data-sort-ignore="true" data-hide="all">User Ref.</th>
						<th data-sort-ignore="true" data-hide="" data-class="expand leftalign text-ellipsis" class="leftalign" style="width:120px; max-width:120px;">To</th>
						<th data-sort-ignore="true" data-hide="phone,tablet" style="width:70px;">CC</th>
						<th data-sort-ignore="true" data-hide="phone,tablet" style="width:70px;">BCC</th>
						<th data-sort-ignore="true" data-hide="phone" data-class="leftalign" class="leftalign">Subject</th>
						<th data-sort-ignore="true" data-hide="all">Message</th>
						<th data-sort-ignore="true" data-hide="" style="width:70px;">Status</th>
						<th data-sort-ignore="true" data-hide="" style="width:70px;">Sent</th>
						<th data-sort-ignore="true" data-hide="all">Request Timestamp</th>
						<th data-sort-ignore="true" data-hide="all">First Request Timestamp</th>
						<th data-sort-ignore="true" data-hide="phone,tablet">Retry Count</th>
						<th data-sort-ignore="true" data-hide="phone,tablet" style="width:70px;">Retry After</th>
						<th data-sort-ignore="true" data-hide="all">User IP</th>
						<th data-sort-ignore="true" data-hide="all">User Agent</th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td>000000000</td>
						<td style="width:120px; max-width:120px;">john.doe@gmail.com</td>
						<td></td>
						<td></td>
						<td>Welcome To Tradingpost</td>
						<td>Hi Test, Thank you for confirming your account details for the new Tradingpost.com.au system powered by EasyList.</td>
						<td><span class="label label-important">Sent Error</span></td>
						<td data-value="2013-06-26T10:47:20.377+10:00">-</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td>10</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td>127.0.0.1</td>
						<td>Chrome</td>
					</tr>
					<tr>
						<td>000000000</td>
						<td style="width:120px; max-width:120px;">this.is.super.duper.long.email.john.doe@gmail.com</td>
						<td></td>
						<td></td>
						<td>Welcome To Tradingpost</td>
						<td>Hi Test, Thank you for confirming your account details for the new Tradingpost.com.au system powered by EasyList.</td>
						<td><span class="label label-warning">Unsent</span></td>
						<td data-value="2013-06-26T10:47:20.377+10:00">-</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td>10</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td>127.0.0.1</td>
						<td>Chrome</td>
					</tr>
					<tr>
						<td>000000000</td>
						<td style="width:120px; max-width:120px;">lara.croft@gmail.com</td>
						<td></td>
						<td></td>
						<td>Welcome To Tradingpost</td>
						<td>Hi Test, Thank you for confirming your account details for the new Tradingpost.com.au system powered by EasyList.</td>
						<td><span class="label label-success">Sent</span></td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td>10</td>
						<td data-value="2013-06-26T10:47:20.377+10:00">26-06-2013 10:47 AM</td>
						<td>127.0.0.1</td>
						<td>Chrome</td>
					</tr>
				</tbody>
			
		</table>
	</xsl:template>-->
	<!-- /EMAIL RESULT TEMPLATE -->

	<!-- PAGING TEMPLATE (SAMPLE - see EasyListEditAllListings.xslt for live implementation) -->
	<!--<xsl:template name='paging'>
	<div id="easylist-pagination" class="pagination pagination-centered">
		<ul id="easylist-page-links">
			<li class="first-page"><a href="/messaging?page=1"><i class="icon-first">&nbsp;</i><span class="hidden-phone">Page 1</span></a></li>
			<li class="prev-page"><a href="/messaging?page=5"><i class="icon-backward">&nbsp;</i></a></li>
			<li class="hidden-tablet hidden-phone"><a href="/messaging?page=1">1</a></li>
			<li class="hidden-tablet hidden-phone"><a href="/messaging?page=2">2</a></li>
			<li class="hidden-tablet hidden-phone"><a href="/messaging?page=3">3</a></li>
			<li class="hidden-tablet hidden-phone"><a href="/messaging?page=4">4</a></li>
			<li><a href="/messaging?page=5">5</a></li>
			<li class="current"><a href="/messaging?page=6">6</a></li>
			<li><a href="/messaging?page=7">7</a></li>
			<li class="hidden-tablet hidden-phone"><a href="/messaging?page=8">8</a></li>
			<li class="hidden-tablet hidden-phone"><a href="/messaging?page=9">9</a></li>
			<li class="hidden-tablet hidden-phone"><a href="/messaging?page=10">10</a></li>
			<li class="hidden-tablet hidden-phone"><a href="/messaging?page=11">11</a></li>
			<li class="next-page"><a href="/messaging?page=7"><i class="icon-forward">&nbsp;</i></a></li>
			<li class="last-page"><a href="/messaging?page=205"><span class="hidden-phone">Page 205</span>&nbsp;<i class="icon-last">&nbsp;</i></a></li>
		</ul>
	</div>
	</xsl:template>-->
	<xsl:template name="for.loop">
		<xsl:param name="i"/>
		<xsl:param name="count"/>
		<xsl:param name="page"/>
		<xsl:if test="$i &lt;= $count">
			<li>  
				<xsl:choose>
					<xsl:when test="$page = ($i + 1)">
						<xsl:attribute name="class"><xsl:value-of select="'current'"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="($page &gt; ($i + 2)) or ($page &lt; $i)">
						<xsl:attribute name="class"><xsl:value-of select="'hidden-tablet hidden-phone'"/></xsl:attribute>
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
					
					<!-- Previous link -->  
					<!-- <xsl:if test="$pageNumber > 1">
						<li>
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $prevPageNum)}"> 
								<span class="arrow-w">&nbsp;</span> Previous Page &nbsp;</a>
						</li>
					</xsl:if> -->
					
					<!-- <xsl:if test="$pageNumber = 1">
							 <li>
					<a class="more-results" href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $nextPageNum)}">
					&nbsp; View More Search Results <span class="arrow-e">&nbsp;</span>
					</a>
					</li> 
						  </xsl:if> -->
					
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
							<i class="icon-first">&nbsp;</i><span class="hidden-phone">Page 1</span></a>
						</li>
					
						<li class="prev-page">
							<a href="page={$prevPageNum}">
							<i class="icon-backward">&nbsp;</i></a>
						</li>
					</xsl:if>
					
					<!--
					<xsl:if test="$startPage &gt; 1">
						<li>
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, 1)}">1...</a>
						</li>
					</xsl:if>
					-->
					
					<xsl:call-template name="for.loop">
						<xsl:with-param name="i" select="$startPage" />
						<xsl:with-param name="page" select="$pageNumber +1"></xsl:with-param>
						<xsl:with-param name="count" select="$endPage"></xsl:with-param>
					</xsl:call-template> 
					
					<!--
					<xsl:if test="$numberOfPages &gt; $endPage">
						<li>
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $numberOfPages)}" >...<xsl:value-of select="$numberOfPages" /></a>
						</li>
					</xsl:if>
					-->
					
					<xsl:if test="$pageNumber &lt; $numberOfPages"> 
						<!-- <li>
							<a class="next-page" href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $nextPageNum)}">
								&nbsp; Next Page <span class="arrow-e">&nbsp;</span></a>
						</li> -->
						<li class="next-page">
							<a href="page={$nextPageNum}">
							<i class="icon-forward">&nbsp;</i></a>
						</li>
							<li class="last-page">
							<a href="page={$numberOfPages}">
							<span class="hidden-phone">Page <xsl:value-of select="$numberOfPages" /></span>&nbsp;<i class="icon-last">&nbsp;</i></a>
						</li>
					</xsl:if>
				</ul>
				
				<xsl:if test="LocalInline:GetTotalCount() > 0 and ($IsGodLevel = 'true' or $IsESSupport = 'true')">
					<br /><br />
					<div>
						Total records count: <span class="badge badge-info"><xsl:value-of select="LocalInline:GetTotalCount()" /></span>
					</div>
				</xsl:if>
				
				<xsl:if test="LocalInline:GetIsTooManyResult() = 'true'">
					<br /><small>Your search yields many results, please refine your search filter(s), because maximum pages is capped at <xsl:value-of select="LocalInline:Get_MAX_PAGE_ALLOWED()" />.</small>
				</xsl:if>
			</div>  
		</xsl:if>
	</xsl:template>
	<!-- /PAGING TEMPLATE -->

</xsl:stylesheet>