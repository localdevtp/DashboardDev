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
		/********** Classes **********/
		public class IdValue {
			public string Id { get; set; }
			public string Value { get; set; }
		}

		public class rule {
			public string pattern { get; set; }
			public string priority { get; set; }
			public string gateway { get; set; }
		}

		/********** Enums **********/
		public enum ProcessResultType {
			Error,
			SMSConfigurationError,
			EmailConfigurationError,
			OTPConfigurationError,
			GatewayRedoxygenConfigurationError,
			GatewaySybase365ConfigurationError,
			GatewayRulesError,
			Success,
			NotPostBack,
			NotAuthorized
		};

		/********** Instance's members **********/
		private Dictionary<string, string> _Values = new Dictionary<string, string>();
		private List<IdValue> _SMSGatewayList = new List<IdValue>();
		private List<GatewayRule> _GatewayRules = new List<GatewayRule>();

		/********** Properties **********/
		public string Error { get; set; }
		public string GlobalCrudRestUrl { get { return ConfigurationManager.AppSettings["GlobalCrudRestUrl"]; } }
		public string GlobalCrudRestKey { get { return ConfigurationManager.AppSettings["GlobalCrudRestKey"]; } }	
		public string MessagingCrudRestUrl { get { return ConfigurationManager.AppSettings["MessagingCrudRestUrl"]; } }
		public HttpRequest Request { get { return HttpContext.Current.Request; } }
		
		public HttpResponse Response { get { return HttpContext.Current.Response; } }
		public HttpSessionState Session { get { return HttpContext.Current.Session; } }
		public bool IsPostBack { get { return Request["IsPostBack"] == "true"; } }
		
		/********** XSLT getters **********/
		public string GetError() { return (Error == null) ? string.Empty : Error; }
		public XmlDocument ListSMSGatewayMinimal() { return DataMarshallingHelper.ToXmlDocument(_SMSGatewayList); }
		public XmlDocument ListGatewayRules() { return DataMarshallingHelper.ToXmlDocument(_GatewayRules); }
		public string GetEnumMessagingPriorityNames() { return string.Join(",", Enum.GetNames(typeof(MessagingPriority))); }
		public string GetValue(string name) {
			if (name == null || !_Values.ContainsKey(name)) {
				return string.Empty;
			}

			return _Values[name];
		}
		public string GetSMSGatewayName(string id) {
			return _SMSGatewayList.Find(i => i.Id == id).Value;
		}

		/********** Instance's private methods **********/
		private void LoadSMSGatewayList() {
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
				_SMSGatewayList.Add(new IdValue() { Id = smsGateway._id.ToString(), Value = smsGateway.GatewayName } );
			}
		}

		private void LoadConfigurationsFromDB() {
			{
				GetEmailConfigurationsResponse response =
					HttpInvocation.PostRequest<GetEmailConfigurationsResponse> (
						GlobalCrudRestUrl + "/GetEmailConfigurations", 
						GlobalCrudRestKey, 
						new GetEmailConfigurationsRequest(), 
						3
					);

				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}

				_Values["email-retry"] = response.EmailConfigurations.Retry.ToString();
				_Values["email-max-allowed-retry"] = response.EmailConfigurations.MaxAllowedRetry.ToString();
				_Values["email-low-priority-reschedule"] = response.EmailConfigurations.LowPriorityRescheduleInSecond.ToString();
				_Values["email-normal-priority-reschedule"] = response.EmailConfigurations.NormalPriorityRescheduleInSecond.ToString();
				_Values["email-high-priority-reschedule"] = response.EmailConfigurations.HighPriorityRescheduleInSecond.ToString();
				_Values["email-download-timeout"] = response.EmailConfigurations.AttachmentDownloadTimeoutInSecond.ToString();
			}

			{
				GetSMSConfigurationsResponse response =
					HttpInvocation.PostRequest<GetSMSConfigurationsResponse> (
						GlobalCrudRestUrl + "/GetSMSConfigurations", 
						GlobalCrudRestKey, 
						new GetSMSConfigurationsRequest(), 
						3
					);

				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}

				_Values["sms-retry"] = response.SMSConfigurations.Retry.ToString();
				_Values["sms-max-allowed-retry"] = response.SMSConfigurations.MaxAllowedRetry.ToString();
				_Values["sms-low-priority-reschedule"] = response.SMSConfigurations.LowPriorityRescheduleInSecond.ToString();
				_Values["sms-normal-priority-reschedule"] = response.SMSConfigurations.NormalPriorityRescheduleInSecond.ToString();
				_Values["sms-high-priority-reschedule"] = response.SMSConfigurations.HighPriorityRescheduleInSecond.ToString();
			}

			{
				GetOTPConfigurationsResponse response =
					HttpInvocation.PostRequest<GetOTPConfigurationsResponse> (
						GlobalCrudRestUrl + "/GetOTPConfigurations",
						GlobalCrudRestKey,
						new GetOTPConfigurationsRequest(),
						3
					);

				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}

				_Values["otp-reference-code-length"] = response.OTPConfigurations.ReferenceCodeLength.ToString();
				_Values["otp-length"] = response.OTPConfigurations.Length.ToString();
				_Values["otp-validity-minute"] = response.OTPConfigurations.ValidityInMinute.ToString();
				_Values["otp-min-interval-second"] = response.OTPConfigurations.MinIntervalInSeconds.ToString();
			}

			{
				GetRedOxygenConfigurationsResponse response =
					HttpInvocation.PostRequest<GetRedOxygenConfigurationsResponse> (
	  					MessagingCrudRestUrl + "/GetRedOxygenConfigurations",
						GlobalCrudRestKey,
						new GetRedOxygenConfigurationsRequest(),
						3
					);

				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}

				_Values["gateway-redoxygen-url"] = response.RedOxygenConfigurations.Url.ToString();
				_Values["gateway-redoxygen-account-id"] = response.RedOxygenConfigurations.AccountId;
				_Values["gateway-redoxygen-password"] = response.RedOxygenConfigurations.Password;
				_Values["gateway-redoxygen-timeout"] = response.RedOxygenConfigurations.Timeout.ToString();
			}

			{
				GetSybase365ConfigurationsResponse response =
					HttpInvocation.PostRequest<GetSybase365ConfigurationsResponse> (
						MessagingCrudRestUrl + "/GetSybase365Configurations",
						GlobalCrudRestKey,
						new GetSybase365ConfigurationsRequest(),
						3
					);

				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}

				_Values["gateway-sybase365-url"] = response.Sybase365Configurations.Url.ToString();
				_Values["gateway-sybase365-login"] = response.Sybase365Configurations.Login;
				_Values["gateway-sybase365-password"] = response.Sybase365Configurations.Password;
				_Values["gateway-sybase365-timeout"] = response.Sybase365Configurations.Timeout.ToString();
			}

			{
				GetDefaultSMSGatewayResponse response =
					HttpInvocation.PostRequest<GetDefaultSMSGatewayResponse> (
						MessagingCrudRestUrl + "/GetDefaultSMSGateway",
						GlobalCrudRestKey,
						new GetDefaultSMSGatewayRequest(),
						3
					);
			
				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}
			
				_Values["gateway-default"] = response.GatewayId;
			}

			{
				GetGatewayRulesConfigurationsResponse response =
					HttpInvocation.PostRequest<GetGatewayRulesConfigurationsResponse> (
						MessagingCrudRestUrl + "/GetGatewayRulesConfigurations",
						GlobalCrudRestKey,
						new GetGatewayRulesConfigurationsRequest(),
						3
					);
			
				if (response.ResponseCode == ResponseCodeType.Fail) {
					throw new Exception(response.ResponseDescription);
				}

				_GatewayRules = response.GatewayRulesConfigurations.GatewayRules;
			}
		}

		public void ReadFormData() {
			_Values["sms-retry"] = Request.Form["sms-retry"];
			_Values["sms-max-allowed-retry"] = Request.Form["sms-max-allowed-retry"];
			_Values["sms-low-priority-reschedule"] = Request.Form["sms-low-priority-reschedule"];
			_Values["sms-normal-priority-reschedule"] = Request.Form["sms-normal-priority-reschedule"];
			_Values["sms-high-priority-reschedule"] = Request.Form["sms-high-priority-reschedule"];

			_Values["email-retry"] = Request.Form["email-retry"];
			_Values["email-max-allowed-retry"] = Request.Form["email-max-allowed-retry"];
			_Values["email-download-timeout"] = Request.Form["email-download-timeout"];
			_Values["email-low-priority-reschedule"] = Request.Form["email-low-priority-reschedule"];
			_Values["email-normal-priority-reschedule"] = Request.Form["email-normal-priority-reschedule"];
			_Values["email-high-priority-reschedule"] = Request.Form["email-high-priority-reschedule"];
		
			_Values["otp-reference-code-length"] = Request.Form["otp-reference-code-length"];
			_Values["otp-length"] = Request.Form["otp-length"];
			_Values["otp-validity-minute"] = Request.Form["otp-validity-minute"];
			_Values["otp-min-interval-second"] = Request.Form["otp-min-interval-second"];

			_Values["gateway-redoxygen-url"] = Request.Form["gateway-redoxygen-url"];
			_Values["gateway-redoxygen-account-id"] = Request.Form["gateway-redoxygen-account-id"];
			_Values["gateway-redoxygen-password"] = Request.Form["gateway-redoxygen-password"];
			_Values["gateway-redoxygen-timeout"] = Request.Form["gateway-redoxygen-timeout"];

			_Values["gateway-sybase365-url"] = Request.Form["gateway-sybase365-url"];
			_Values["gateway-sybase365-login"] = Request.Form["gateway-sybase365-login"];
			_Values["gateway-sybase365-password"] = Request.Form["gateway-sybase365-password"];
			_Values["gateway-sybase365-timeout"] = Request.Form["gateway-sybase365-timeout"];

			_Values["gateway-default"] = Request.Form["gateway-default"];

			List<rule> rules = 
				DataMarshallingHelper.FromXmlTo<List<rule>>(
					"<ArrayOfRule>" + HttpUtility.HtmlDecode(Request.Form["gateway-rules-data"]) + "</ArrayOfRule>"
				);

			foreach (rule r in rules) {
				_GatewayRules.Add(new GatewayRule() {
					Pattern = r.pattern,
					Priority = (MessagingPriority)Enum.Parse(typeof(MessagingPriority), r.priority),
					GatewayId = r.gateway
				});
			}
		}
 
		private void SetSMSConfigurations(bool isValidationOnly) {
			string errorMessage = "";
			SetSMSConfigurationsRequest request = new SetSMSConfigurationsRequest();
			request.SMSConfigurations = new SMSConfigurations();
			request.IsValidationOnly = isValidationOnly;

			try {
				errorMessage = "Retry must be of valid integer value only";
				request.SMSConfigurations.Retry = int.Parse(_Values["sms-retry"]);

				errorMessage = "Max allowed retry must be of valid integer value only";
				request.SMSConfigurations.MaxAllowedRetry = int.Parse(_Values["sms-max-allowed-retry"]);

				errorMessage = "Low priority must be of valid integer value only";
				request.SMSConfigurations.LowPriorityRescheduleInSecond = int.Parse(_Values["sms-low-priority-reschedule"]);

				errorMessage = "Normal priority must be of valid integer value only";
				request.SMSConfigurations.NormalPriorityRescheduleInSecond = int.Parse(_Values["sms-normal-priority-reschedule"]);

				errorMessage = "High priority must be of valid integer value only";
				request.SMSConfigurations.HighPriorityRescheduleInSecond = int.Parse(_Values["sms-high-priority-reschedule"]);
			} catch (Exception) {
				throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() {
					FieldName = ProcessResultType.SMSConfigurationError.ToString(),
					RawMessage = errorMessage
				});
			}

			SetSMSConfigurationsResponse response =
				HttpInvocation.PostRequest<SetSMSConfigurationsResponse> (
					GlobalCrudRestUrl + "/SetSMSConfigurations", 
					GlobalCrudRestKey, 
					request, 
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					response.InvalidFieldEntries[0].RawMessage = 
						response.InvalidFieldEntries[0].FieldName + " - " +
						response.InvalidFieldEntries[0].RawMessage;

					response.InvalidFieldEntries[0].FieldName = ProcessResultType.SMSConfigurationError.ToString();

					throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
				} else {
					throw new Exception(response.ResponseDescription);
				}
			}
		}

		private void SetEmailConfigurations(bool isValidationOnly) {
			string errorMessage = "";
			SetEmailConfigurationsRequest request = new SetEmailConfigurationsRequest();
			request.EmailConfigurations = new EmailConfigurations();
			request.IsValidationOnly = isValidationOnly;

			try {
				errorMessage = "Retry must be of valid integer value only";
				request.EmailConfigurations.Retry = int.Parse(_Values["email-retry"]);

				errorMessage = "Max allowed retry must be of valid integer value only";
				request.EmailConfigurations.MaxAllowedRetry = int.Parse(_Values["email-max-allowed-retry"]);

				errorMessage = "Attachment download time out must be of valid integer value only";
				request.EmailConfigurations.AttachmentDownloadTimeoutInSecond = int.Parse(_Values["email-download-timeout"]);

				errorMessage = "Low priority must be of valid integer value only";
				request.EmailConfigurations.LowPriorityRescheduleInSecond = int.Parse(_Values["email-low-priority-reschedule"]);

				errorMessage = "Normal priority must be of valid integer value only";
				request.EmailConfigurations.NormalPriorityRescheduleInSecond = int.Parse(_Values["email-normal-priority-reschedule"]);

				errorMessage = "High priority must be of valid integer value only";
				request.EmailConfigurations.HighPriorityRescheduleInSecond = int.Parse(_Values["email-high-priority-reschedule"]);
			} catch (Exception) {
				throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() {
					FieldName = ProcessResultType.EmailConfigurationError.ToString(),
					RawMessage = errorMessage
				});
			}

			SetEmailConfigurationsResponse response =
				HttpInvocation.PostRequest<SetEmailConfigurationsResponse> (
					GlobalCrudRestUrl + "/SetEmailConfigurations", 
					GlobalCrudRestKey, 
					request, 
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					response.InvalidFieldEntries[0].RawMessage = 
						response.InvalidFieldEntries[0].FieldName + " - " +
						response.InvalidFieldEntries[0].RawMessage;

					response.InvalidFieldEntries[0].FieldName = 
						ProcessResultType.EmailConfigurationError.ToString();

					throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
				} else {
					throw new Exception(response.ResponseDescription);
				}
			}
		}

		private void SetOTPConfigurations(bool isValidationOnly) {
			string errorMessage = "";
			SetOTPConfigurationsRequest request = new SetOTPConfigurationsRequest();
			request.OTPConfigurations = new OTPConfigurations();
			request.IsValidationOnly = isValidationOnly;

			try {
				errorMessage = "Reference code length must be of valid integer value only";
				request.OTPConfigurations.ReferenceCodeLength = int.Parse(_Values["otp-reference-code-length"]);

				errorMessage = "Length must be of valid integer value only";
				request.OTPConfigurations.Length = int.Parse(_Values["otp-length"]);

				errorMessage = "Validity in minute must be of valid integer value only";
				request.OTPConfigurations.ValidityInMinute = int.Parse(_Values["otp-validity-minute"]);

				errorMessage = "Min interval in second must be of valid integer value only";
				request.OTPConfigurations.MinIntervalInSeconds = int.Parse(_Values["otp-min-interval-second"]);

			} catch (Exception) {
				throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() {
					FieldName = ProcessResultType.OTPConfigurationError.ToString(),
					RawMessage = errorMessage
				});
			}

			SetOTPConfigurationsResponse response =
				HttpInvocation.PostRequest<SetOTPConfigurationsResponse>(
					GlobalCrudRestUrl + "/SetOTPConfigurations", 
					GlobalCrudRestKey, 
					request, 
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					response.InvalidFieldEntries[0].RawMessage = 
						response.InvalidFieldEntries[0].FieldName + " - " +
						response.InvalidFieldEntries[0].RawMessage;

					response.InvalidFieldEntries[0].FieldName = 
						ProcessResultType.OTPConfigurationError.ToString();

					throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
				} else {
					throw new Exception(response.ResponseDescription);
				}
			}
		}

		private void SetRedOxygenConfigurations(bool isValidationOnly) {
			string errorMessage = "";
			SetRedOxygenConfigurationsRequest request = new SetRedOxygenConfigurationsRequest();
			request.RedOxygenConfigurations = new RedOxygenConfigurations();
			request.IsValidationOnly = isValidationOnly;

			request.RedOxygenConfigurations.Url = _Values["gateway-redoxygen-url"];
			request.RedOxygenConfigurations.AccountId = _Values["gateway-redoxygen-account-id"];
			request.RedOxygenConfigurations.Password = _Values["gateway-redoxygen-password"];

			try {
				errorMessage = "RedOxygen's Timeout must be of valid integer value only";
				request.RedOxygenConfigurations.Timeout = int.Parse(_Values["gateway-redoxygen-timeout"]);

			} catch (Exception) {
				throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() {
					FieldName = ProcessResultType.GatewayRedoxygenConfigurationError.ToString(),
					RawMessage = errorMessage
				});
			}

			SetRedOxygenConfigurationsResponse response =
				HttpInvocation.PostRequest<SetRedOxygenConfigurationsResponse> (
					MessagingCrudRestUrl + "/SetRedOxygenConfigurations", 
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					response.InvalidFieldEntries[0].RawMessage = 
						"RedOxygen's " +
						response.InvalidFieldEntries[0].FieldName + " - " +
						response.InvalidFieldEntries[0].RawMessage;

					response.InvalidFieldEntries[0].FieldName = 
						ProcessResultType.GatewayRedoxygenConfigurationError.ToString();

					throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
				} else {
					throw new Exception(response.ResponseDescription);
				}
			}
		}

		private void SetSybase365Configurations(bool isValidationOnly) {
			string errorMessage = "";
			SetSybase365ConfigurationsRequest request = new SetSybase365ConfigurationsRequest();
			request.Sybase365Configurations = new Sybase365Configurations();
			request.IsValidationOnly = isValidationOnly;

			request.Sybase365Configurations.Url = _Values["gateway-sybase365-url"];
			request.Sybase365Configurations.Login = _Values["gateway-sybase365-login"];
			request.Sybase365Configurations.Password = _Values["gateway-sybase365-password"];

			try {
				errorMessage = "Sybase365's Timeout must be of valid integer value only";
				request.Sybase365Configurations.Timeout = int.Parse(_Values["gateway-sybase365-timeout"]);

			} catch (Exception) {
				throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() {
					FieldName = ProcessResultType.GatewaySybase365ConfigurationError.ToString(),
					RawMessage = errorMessage
				});
			}

			SetSybase365ConfigurationsResponse response =
				HttpInvocation.PostRequest<SetSybase365ConfigurationsResponse> (
					MessagingCrudRestUrl + "/SetSybase365Configurations", 
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					response.InvalidFieldEntries[0].RawMessage = 
						"Sybase365's " +
						response.InvalidFieldEntries[0].FieldName + " - " +
						response.InvalidFieldEntries[0].RawMessage;

					response.InvalidFieldEntries[0].FieldName = 
						ProcessResultType.GatewaySybase365ConfigurationError.ToString();

					throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
				} else {
					throw new Exception(response.ResponseDescription);
				}
			}
		}

		private void SetDefaultSMSGateway(bool isValidationOnly) {
			SetDefaultSMSGatewayRequest request = new SetDefaultSMSGatewayRequest();
			request.IsValidationOnly = isValidationOnly;
			request.GatewayId = _Values["gateway-default"];

			SetDefaultSMSGatewayResponse response =
				HttpInvocation.PostRequest<SetDefaultSMSGatewayResponse> (
					MessagingCrudRestUrl + "/SetDefaultSMSGateway", 
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					response.InvalidFieldEntries[0].RawMessage = 
						response.InvalidFieldEntries[0].FieldName +
						response.InvalidFieldEntries[0].RawMessage;

					response.InvalidFieldEntries[0].FieldName = 
						ProcessResultType.GatewayRulesError.ToString();

					throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
				} else {
					throw new Exception(response.ResponseDescription);
				}
			}
		}

		private void SetGatewayRules(bool isValidationOnly) {
			SetGatewayRulesConfigurationsRequest request = new SetGatewayRulesConfigurationsRequest();
			request.IsValidationOnly = isValidationOnly;
			request.GatewayRulesConfigurations = new GatewayRulesConfigurations() {
				GatewayRules = _GatewayRules
			};

			SetGatewayRulesConfigurationsResponse response =
				HttpInvocation.PostRequest<SetGatewayRulesConfigurationsResponse> (
					MessagingCrudRestUrl + "/SetGatewayRulesConfigurations", 
					GlobalCrudRestKey,
					request,
					3
				);

			if (response.ResponseCode == ResponseCodeType.Fail) {
				if (response.InvalidFieldEntries != null) {
					response.InvalidFieldEntries[0].RawMessage = 
						response.InvalidFieldEntries[0].FieldName +
						response.InvalidFieldEntries[0].RawMessage;

					response.InvalidFieldEntries[0].FieldName = 
						ProcessResultType.GatewayRulesError.ToString();

					throw InvalidFieldException.CreateSingle(response.InvalidFieldEntries[0]);
				} else {
					throw new Exception(response.ResponseDescription);
				}
			}
		}

		private void ValidateFormData() {
			bool isValidationOnly = true;

			SetSMSConfigurations(isValidationOnly);
			SetEmailConfigurations(isValidationOnly);
			SetOTPConfigurations(isValidationOnly);
			SetRedOxygenConfigurations(isValidationOnly);
			SetSybase365Configurations(isValidationOnly);
			SetDefaultSMSGateway(isValidationOnly);
			SetGatewayRules(isValidationOnly);
		}

		private void UpdateData() {
			bool isValidationOnly = false;

			SetSMSConfigurations(isValidationOnly);
			SetEmailConfigurations(isValidationOnly);
			SetOTPConfigurations(isValidationOnly);
			SetRedOxygenConfigurations(isValidationOnly);
 			SetSybase365Configurations(isValidationOnly);
 			SetDefaultSMSGateway(isValidationOnly);
 			SetGatewayRules(isValidationOnly);
		}

		public string Process(bool isAuthorized) {
			if (!isAuthorized) { return ProcessResultType.NotAuthorized.ToString(); }

			try {
				LoadSMSGatewayList();

				if (IsPostBack) {
					ReadFormData();
					ValidateFormData();
					UpdateData();

					return ProcessResultType.Success.ToString();
				}
				
				LoadConfigurationsFromDB();
	
				return ProcessResultType.NotPostBack.ToString();
			} catch (InvalidFieldException exception) {
				Error = exception.InvalidFieldEntries[0].Message;
				return exception.InvalidFieldEntries[0].FieldName;
			} catch (Exception exception) {
				Error = exception.Message;
			}

			return ProcessResultType.Error.ToString();
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
		
		<ul	class="nav nav-pills">
			<li><a href="/messaging"><i class="icon-clock">&nbsp;</i>History</a></li>
			<xsl:if test="$IsAuthorized != false">
			<li class="active dropdown"><a href="/messaging/config" class="downdown-toggle" data-toggle="dropdown"><i class="icon-cog">&nbsp;</i>Configuration <i class="icon-vmenu"><xsl:text>
			</xsl:text></i></a>
				<ul class="dropdown-menu">
					<li><a href="/messaging/config#sms-config">SMS Configuration</a></li>
					<li><a href="/messaging/config#email-config">Email Configuration</a></li>
					<li><a href="/messaging/config#otp-config">OTP Configuration</a></li>
					<li><a href="/messaging/config#gateway-config">Gateway Configuration</a></li>
					<li><a href="/messaging/config#gateway-rules">Gateway Rules</a></li>
				</ul>
			</li>
			<li><a href="/messaging/api"><i class="icon-code">&nbsp;</i>API</a></li>
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
				<xsl:call-template name="LoadPage">
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- LOADPAGE TEMPLATE -->
	<xsl:template name="LoadPage" >

		<xsl:if test="$ProcessResult = 'Success'">
			<div class="alert alert-info">
				<strong>Configurations saved successfully</strong>
			</div>
		</xsl:if>
		
		<xsl:if test="$ProcessResult = 'Error'">
			<div class="alert alert-error">
				<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
			</div>
		</xsl:if>
		
		<div class="widget-box">
			<div class="widget-title">
				<h2><i class="icon-cog">&nbsp;</i> Messaging Configuration</h2>
			</div>
			
			<!-- /widget-title -->

			<div class="widget-content">
				<!-- HANDLE YOUR PAGE POST PROCESSING HERE -->
				<xsl:call-template name="config-form" />
				
			</div>
			<!-- /widget-content -->

		</div>
		<!-- /widget-box -->
		
		<!-- Modal dialog for saving configurations confirmation -->
		<div id="save-confirmation-modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h3 id="myModalHeader">Confirm to save configurations</h3>
			</div>
			<div class="modal-body">
				<p>Are you sure you want to save configurations?</p>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
				<button id="confirm-save-btn" class="btn btn-primary">Yes</button>
			</div>
		</div>

	</xsl:template>	
	<!-- /LOADPAGE TEMPLATE -->

	<!-- MESSAGING CONFIGURATION FORM TEMPLATE -->
	<xsl:template name="config-form">
		<form id="config-form" class="form-horizontal break-desktop-large" method="POST">

			<!-- SMS Configuration -->
			<fieldset style="margin-top:-10px;" id="sms-config">
				<legend>SMS Configuration (requires SMS Worker Service restart)</legend>

				<xsl:if test="$ProcessResult = 'SMSConfigurationError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
				
				<div class="form-left">

					<div class="control-group">
						<label class="control-label">Retry</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="sms-retry">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('sms-retry')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Max allowed retry</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="sms-max-allowed-retry">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('sms-max-allowed-retry')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

				</div>
				<div class="form-right">

					<div class="control-group">
						<div class="controls">
							<label><h4>Reschedule (in seconds):</h4></label>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Low priority</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="sms-low-priority-reschedule">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('sms-low-priority-reschedule')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Normal priority</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="sms-normal-priority-reschedule">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('sms-normal-priority-reschedule')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">High priority</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="sms-high-priority-reschedule">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('sms-high-priority-reschedule')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

				</div>

			</fieldset>
			<!-- /SMS Configuration -->

			<!-- Email Configuration -->
			<fieldset id="email-config">
				<legend>Email Configuration (requires Email Worker Service restart)</legend>

				<xsl:if test="$ProcessResult = 'EmailConfigurationError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
				
				<div class="form-left">

					<div class="control-group">
						<label class="control-label">Retry</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="email-retry">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('email-retry')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Max allowed retry</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="email-max-allowed-retry">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('email-max-allowed-retry')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
					
					<div class="control-group">
						<label class="control-label">Attachment download time out (in seconds)</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="email-download-timeout">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('email-download-timeout')" />
								</xsl:attribute>
							</input>
						</div>
					</div>
				</div>
				<div class="form-right">

					<div class="control-group">
						<div class="controls">
							<label><h4>Reschedule (in seconds):</h4></label>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Low priority</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="email-low-priority-reschedule">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('email-low-priority-reschedule')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Normal priority</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="email-normal-priority-reschedule">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('email-normal-priority-reschedule')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">High priority</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="email-high-priority-reschedule">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('email-high-priority-reschedule')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

				</div>

			</fieldset>
			<!-- /Email Configuration -->

			<!-- OTP Configurations -->
			<fieldset id="otp-config">
				<legend>OTP Configuration</legend>

				<xsl:if test="$ProcessResult = 'OTPConfigurationError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
				
				<div class="form-left">

					<div class="control-group">
						<label class="control-label">Reference code length</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="otp-reference-code-length">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('otp-reference-code-length')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Length</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="otp-length">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('otp-length')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

				</div>

				<div class="form-right">

					<div class="control-group">
						<label class="control-label">Validity in minute</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="otp-validity-minute">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('otp-validity-minute')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label">Min interval in second</label>
						<div class="controls">
							<input type="text" class="input-xlarge digits" name="otp-min-interval-second">
								<xsl:attribute name="value">
									<xsl:value-of select="LocalInline:GetValue('otp-min-interval-second')" />
								</xsl:attribute>
							</input>
						</div>
					</div>

				</div>

			</fieldset>
			<!-- /OTP Configurations -->

			<!-- Gateway Configurations -->
			<fieldset id="gateway-config">
				<legend>Gateway Configuration</legend>
				
				<xsl:if test="$ProcessResult = 'GatewayRedoxygenConfigurationError' or $ProcessResult = 'GatewaySybase365ConfigurationError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>

				<!-- redoxygen -->
				<header><h4 data-toggle="collapse" data-target="#redoxygen"><i class="icon-data">&nbsp;</i>REDOXYGEN</h4></header>
				<section id="redoxygen" class="collapse in">
					<div class="form-left">

						<div class="control-group">
							<label class="control-label">URL</label>
							<div class="controls">
								<input type="text" class="input-xlarge" name="gateway-redoxygen-url">
									<xsl:attribute name="value">
										<xsl:value-of select="LocalInline:GetValue('gateway-redoxygen-url')" />
									</xsl:attribute>
								</input>
							</div>
						</div>

						<div class="control-group">
							<label class="control-label">Account ID</label>
							<div class="controls">
								<input type="text" class="input-xlarge" name="gateway-redoxygen-account-id">
									<xsl:attribute name="value">
										<xsl:value-of select="LocalInline:GetValue('gateway-redoxygen-account-id')" />
									</xsl:attribute>
								</input>
							</div>
						</div>

					</div>

					<div class="form-right">

						<div class="control-group">
							<label class="control-label">Password</label>
							<div class="controls">
								<input type="text" class="input-xlarge" name="gateway-redoxygen-password">
									<xsl:attribute name="value">
										<xsl:value-of select="LocalInline:GetValue('gateway-redoxygen-password')" />
									</xsl:attribute>
								</input>
							</div>
						</div>

						<div class="control-group">
							<label class="control-label">Timeout</label>
							<div class="controls">
								<input type="text" class="input-xlarge digits" name="gateway-redoxygen-timeout">
									<xsl:attribute name="value">
										<xsl:value-of select="LocalInline:GetValue('gateway-redoxygen-timeout')" />
									</xsl:attribute>
								</input>
								&nbsp;<small>ms</small>
							</div>							
						</div>

					</div>
				</section>
				<!-- /redoxygen -->
				
				<!-- sybase 365 -->
				<header><h4 data-toggle="collapse" data-target="#sybase365"><i class="icon-data">&nbsp;</i>SYBASE365</h4></header>
				<section id="sybase365" class="collapse in">
					<div class="form-left">

						<div class="control-group">
							<label class="control-label">URL</label>
							<div class="controls">
								<input type="text" class="input-xlarge" name="gateway-sybase365-url">
									<xsl:attribute name="value">
										<xsl:value-of select="LocalInline:GetValue('gateway-sybase365-url')" />
									</xsl:attribute>
								</input>
							</div>
						</div>

						<div class="control-group">
							<label class="control-label">Login</label>
							<div class="controls">
								<input type="text" class="input-xlarge" name="gateway-sybase365-login">
									<xsl:attribute name="value">
										<xsl:value-of select="LocalInline:GetValue('gateway-sybase365-login')" />
									</xsl:attribute>
								</input>
							</div>
						</div>

					</div>

					<div class="form-right">

						<div class="control-group">
							<label class="control-label">Password</label>
							<div class="controls">
								<input type="text" class="input-xlarge" name="gateway-sybase365-password">
									<xsl:attribute name="value">
										<xsl:value-of select="LocalInline:GetValue('gateway-sybase365-password')" />
									</xsl:attribute>
								</input>
							</div>
						</div>

						<div class="control-group">
							<label class="control-label">Timeout</label>
							<div class="controls">
								<input type="text" class="input-xlarge digits" name="gateway-sybase365-timeout">
									<xsl:attribute name="value">
										<xsl:value-of select="LocalInline:GetValue('gateway-sybase365-timeout')" />
									</xsl:attribute>
								</input>
								&nbsp;<small>ms</small>
							</div>
						</div>

					</div>
				</section>
				<!-- /sybase 365 -->

			</fieldset>
			<!-- /Gateway Configurations -->

			<!-- Gateway Rules -->
			<fieldset id="gateway-rules">
				<legend>Gateway Rules</legend>
				
				<xsl:if test="$ProcessResult = 'GatewayRulesError'">
					<div class="alert alert-error" id="process-result">
						<strong><xsl:value-of select="LocalInline:GetError()" /></strong>
					</div>
				</xsl:if>
				
				<div class="control-group">
					<label class="control-label">Default SMS Gateway</label>
					<div class="controls">
						<select name="gateway-default">
							<option value="">
								<xsl:if test="LocalInline:GetValue('gateway-default') = ''">
									<xsl:attribute name="selected"/>
								</xsl:if>
								No default gateway
							</option>
							<xsl:for-each select="LocalInline:ListSMSGatewayMinimal()/ArrayOfIdValue/IdValue">
								<option value="{Id}">
									<xsl:if test="LocalInline:GetValue('gateway-default') = Id">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:value-of select="Value" />
								</option>
							</xsl:for-each>
						</select>
						<br />
						<small>Please set a default gateway, this act as the ultimate fallback if no rules can be matched.</small>
					</div>
				</div>
				
				<hr/>

				<input type="hidden" id="gateway-rules-data" name="gateway-rules-data" />

				<table id="gateway-rules-table" class="table table-bordered table-striped table-input">
					<thead>
						<tr>
							<th>Pattern</th>
							<th>Priority</th>
							<th>Gateway</th>
							<th width="118">Actions</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="LocalInline:ListGatewayRules()/ArrayOfGatewayRule/GatewayRule">
							<tr>
								<td><xsl:value-of select="Pattern" /><div id="row-pattern" style="display: none"><xsl:value-of select="Pattern" /></div></td>
								<td><xsl:value-of select="Priority" /><div id="row-priority" style="display: none"><xsl:value-of select="Priority" /></div></td>
								<td><xsl:value-of select="LocalInline:GetSMSGatewayName(GatewayId)" /><div id="row-gateway" style="display: none"><xsl:value-of select="GatewayId" /></div></td>
								<td>
									<button type="button" class="btn btn-small gateway-sort-up"><i class="icon-chevron-up"><xsl:text>
									</xsl:text></i></button>&nbsp;
									<button type="button" class="btn btn-small gateway-sort-down"><i class="icon-chevron-down"><xsl:text>
									</xsl:text></i></button>&nbsp;
									<button type="button" class="btn btn-small btn-danger gateway-remove"><i class="icon-remove"><xsl:text>
									</xsl:text></i></button>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
					<tfoot>
						<tr>
							<td>
								<input type="text" placeholder="Pattern" id="gateway-rules-pattern" name="gateway-rules-pattern" />
							</td>
							<td>
								<select id="gateway-rules-priority" name="gateway-rules-priority">
									<option value="">Priority</option>
									<xsl:for-each select="umbraco.library:Split(LocalInline:GetEnumMessagingPriorityNames(), ',')/*">
										<option value="{.}"><xsl:value-of select="."/></option>
									</xsl:for-each>
								</select>
							</td>
							<td>
								<select id="gateway-rules-gateway" name="gateway-rules-gateway">
									<option value="">Gateway</option>
									<xsl:for-each select="LocalInline:ListSMSGatewayMinimal()/ArrayOfIdValue/IdValue">
										<option value="{Id}"><xsl:value-of select="Value" /></option>
									</xsl:for-each>
								</select>
							</td>
							<td>
								<button type="button" id="gateway-rules-add" name="gateway-rules-add" class="btn btn-small btn-success"><i class="icon-plus"><xsl:text>
								</xsl:text></i></button>
							</td>
						</tr>
					</tfoot>
				</table>

			</fieldset>
			<!-- /Gateway Rules -->


			<!-- Form Actions -->
			<div class="form-actions center">
				<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
				<button type="button" id="save-configurations-btn" class="btn btn-large btn-success"><i class="icon-checkmark">&nbsp;</i> Save Changes</button>
			</div>
			<!-- /Form Actions -->

		</form>
	</xsl:template>
	<!-- /MESSAGING CONFIGURATION FORM TEMPLATE -->

</xsl:stylesheet>