<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:leadsapi="urn:leadsapi"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml leadsapi umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <msxml:script language="C#" implements-prefix="leadsapi">
    <msxml:assembly name="NLog" />
    <msxml:assembly name="EasyList.Common.Helpers"/>
    <msxml:assembly name="EasyList.Data.DAL.Repository"/>
    <msxml:assembly name="EasyList.Data.DAL.Repository.Entity"/>
    <msxml:assembly name="System.Web"/>
    <msxml:assembly name="EasyList.LeadManagement.BL" />
    <msxml:assembly name="EasyList.LeadManagement.API.Client" />
    <msxml:assembly name="Componax.ExtensionMethods" />
    <msxml:assembly name="System.Runtime.Serialization" />
    <msxml:assembly name="System.Core"/>

    <msxml:assembly name="EasyList.Common.Helpers"/>
	<msxml:assembly name="Uniquemail.SingleSignOn"/>
	
    <msxml:using namespace="System.Collections.Generic"/>
    <msxml:using namespace="System.Web"/>
    <msxml:using namespace="System.Net"/>
    <msxml:using namespace="System.IO"/>
    <msxml:using namespace="System.Xml"/>
    <msxml:using namespace="System.Runtime.Serialization"/>
    <msxml:using namespace="NLog" />
    <msxml:using namespace="EasyList.Data.DAL.Repository"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity.LeadManagement" />
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity.Helpers" />
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity.REST" />
    <msxml:using namespace="EasyList.LeadManagement.BL" />
    <msxml:using namespace="EasyList.LeadManagement.API.Client" />
    <msxml:using namespace="Componax.ExtensionMethods" />
    <msxml:using namespace="EasyList.Common.Helpers.Web"/>
    <msxml:using namespace="System.Globalization"/>
	<msxml:using namespace="Uniquemail.SingleSignOn" />
	
    <![CDATA[

        static Logger log = LogManager.GetCurrentClassLogger();
        static string baseURL = "http://leads.api.easylist.com.au/LeadManagementService.svc";
        static string key = "";
        
        /********** Constants **********/
        private const int ITEM_PER_PAGE = 10;
		    private const int MAX_PAGE_ALLOWED = 1000;

        /********** Properties **********/
        public HttpRequest Request { get { return HttpContext.Current.Request; } }
        public HttpResponse Response { get { return HttpContext.Current.Response; } }
        public int TotalPage { get; set; }
        public long TotalCount { get; set; }
		public bool IsPostBack 
		{ 
			get 
			{ 
				bool result = false;
				if (Request["IsPostBack"] != null) 
				{
					if (Request["IsPostBack"].ToString() == "true")
					{
						result = true;
					}
				}
	 			return result;
			}	
		}
    
    public bool IsBlockAccess
    {
      get
      {
         bool result = false;
              
              try
              {
                IRepository repo = RepositorySetup.Setup();
		
			          string userCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
                if (!String.IsNullOrEmpty(userCode))
		  		      {
                  var ELUser = repo.Single<Users>(u => u.UserCode == userCode);

			            if (ELUser != null)
			            {
				            result = ELUser.BlockAccessLeadsSettings;
			            }
 						}
          
              }
              catch(Exception ex)
              {
              
              }
			      
              return result;   
      }
    }
        public bool IsTooManyResult { get; set; }
        public int Page { get { int result; return int.TryParse(Request["page"], out result) ? result : 1; } }
      
        
       
        /********** Instance getter methods for XSLT **********/
		    public int GetTotalPage() { return TotalPage; }
        public int GetPage() { return Page; }
        public bool GetIsTooManyResult() { return IsTooManyResult; }
        public int Get_MAX_PAGE_ALLOWED() { return MAX_PAGE_ALLOWED; }
        public int GetItemPerPage() { return ITEM_PER_PAGE; }
        public bool GetIsPostback() { return IsPostBack; }
        public long GetTotalCount() { return TotalCount; }
        public bool GetIsBlockAccess() { return IsBlockAccess; }
                
        /********** Instance helper methods for XSLT **********/
        /// <summary>
        /// Specifies the REST Method when making API requests
        /// </summary>
        public enum RESTMethod
        {
            GET = 1,
            POST = 2,
            PUT = 3,
            DELETE = 4
        }
        
        public int GetSkip() 
        {
			    int page = Page - 1;
			    page = Math.Max(0, page);
			    return page * ITEM_PER_PAGE;			
		    }
        
        public string GetFormValue(string name)
        {
            string result = "";
            if (!string.IsNullOrWhiteSpace(Request[name])) 
            { 
                result = Request[name].ToString();
            }
            return result;        
        }
        
        public XPathNodeIterator CreateLead(NewLeadInfo lead)
        {
            string url = string.Format("{0}/lead/new", baseURL);
            var response = PostRequest<LeadResponse>(url, lead);
            if (response.Lead != null)
            {
                return EasyList.Common.Helpers.Utils.XMLGetNodeIterator(response.Lead.ToXml());
            }
            return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>" + response.Message + "</error>");
        }

			/// Saves a lead....
			public XPathNodeIterator SaveLead(string dealerCode, string id, string userName, string displayName = "")
			{
				bool markAsViewed = true;
				string getLeadUrl = string.Format("{0}/lead?dealer={1}&code={2}&markAsViewed={3}&user={4}", baseURL, dealerCode, id, markAsViewed ? "1" : "0", userName);
				var getLeadResponse = GetRequest<LeadResponse>(getLeadUrl);
			
				if(getLeadResponse.Lead == null)
				{
					return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>The lead was not found</error>");
				}
				
				string originalAssignedTo = getLeadResponse.Lead.AssignedTo;
				
				var l = getLeadResponse.Lead;
				l.AssignedTo = HTTPFormHelpers.GetString("assignedTo");
				l.MasterStatus = GetFormStatus();
				l.BuyerTitle = HTTPFormHelpers.GetString("buyerTitle");
				l.BuyerName = HTTPFormHelpers.GetString("buyerName");
				l.BuyerEmail = HTTPFormHelpers.GetString("buyerEmail");
				l.BuyerHPhone = HTTPFormHelpers.GetString("buyerHPhone");
				l.BuyerMPhone = HTTPFormHelpers.GetString("buyerMPhone");
				l.BuyerWPhone = HTTPFormHelpers.GetString("buyerWPhone");
				l.BuyerType = GetFormBuyerType();
				l.BuyerLocation = HTTPFormHelpers.GetString("buyerLocation").Trim();
				l.CompanyName = HTTPFormHelpers.GetString("companyName");
				l.CompanyPos = HTTPFormHelpers.GetString("companyPos");
				l.CompanyAddress = HTTPFormHelpers.GetString("companyAddress").Trim();
				l.SellerComments = HTTPFormHelpers.GetString("sellerComments");
				l.TradeInMake = HTTPFormHelpers.GetString("tradeInMake");
				l.TradeInModel = HTTPFormHelpers.GetString("tradeInModel");
				l.TradeInYear = HTTPFormHelpers.GetString("tradeInYear");
				l.TradeInOdo = HTTPFormHelpers.GetString("tradeInOdo");
				l.TradeInValue = HTTPFormHelpers.GetString("tradeInValue");
				l.TradeInValueExpiry = HTTPFormHelpers.GetString("tradeInValueExpiry");
			
				if(l.FirstView == null)
				{
					l.FirstView = DateTime.Now;
					l.FirstViewBy = userName;
				}
				
				if(l.MasterStatus == LeadMasterStatus.Unassigned 
					&& !string.IsNullOrWhiteSpace(l.AssignedTo))
				{
					l.MasterStatus = LeadMasterStatus.Assigned;
					l.AssignedBy = userName;
					l.FirstAssigned = DateTime.Now;
				}
				
				LeadAssigneeNotificationInfo leadAssigneeNotificationInfo = null;
			
				if (!string.IsNullOrWhiteSpace(l.AssignedTo))
				{
					if (originalAssignedTo != l.AssignedTo)
					{
						var assignee = SSOHelper.GetUser(l.AssignedTo);
						if (assignee != null)
						{
							leadAssigneeNotificationInfo = new LeadAssigneeNotificationInfo();
							leadAssigneeNotificationInfo.LeadCode = l.LeadCode;
							leadAssigneeNotificationInfo.AssigneeName = assignee.FirstName + " " + assignee.LastName;
							leadAssigneeNotificationInfo.AssignorName = displayName;
							leadAssigneeNotificationInfo.NotificationEmailAddress = assignee.EmailAddress;							
						}
					}
				}
				
				return UpdateLead(l, leadAssigneeNotificationInfo);
			}

			public LeadMasterStatus GetFormStatus()
			{
				switch(HTTPFormHelpers.GetString("masterStatus"))
				{
				
          case "Assigned": 
            return LeadMasterStatus.Assigned;
            break;
          case "FollowUp":
            return LeadMasterStatus.FollowUp;
            break;
          case "ClosedWon":
            return LeadMasterStatus.ClosedWon;
            break;
          case "ClosedLost":
            return LeadMasterStatus.ClosedLost;
            break;			
					default:
						return LeadMasterStatus.Unassigned;
            break;
				}
			}

			public BuyerType GetFormBuyerType()
			{
				switch(HTTPFormHelpers.GetString("buyerType").Trim())
				{
					case "Company" : return BuyerType.Company;
					case "CompanyRetail" : return BuyerType.CompanyRetail;
					case "CompanyFleet" : return BuyerType.CompanyFleet;
					case "Government" : return BuyerType.Government;
					case "GovernmentRetail" : return BuyerType.GovernmentRetail;
					case "GovernmentFleet" : return BuyerType.GovernmentFleet;
					case "Private":
					default:
						return BuyerType.Private;
				}
			}

            public XPathNodeIterator UpdateLead(Lead lead, LeadAssigneeNotificationInfo leadNotificationInfo = null)
            {
                string url = string.Format("{0}/lead", baseURL);
                var response = PostRequest<LeadResponse>(url, lead);
                if (response.Lead != null)
                {
					//send notification to the lead assignee
					if (leadNotificationInfo != null)
					{
						try
						{
							url = string.Format("{0}/notifyleadassignee", baseURL);
							var notifyResult = PostRequest<bool>(url, leadNotificationInfo);
						}
						catch(Exception notificationEx)
						{
							log.Error("Error sending notification to lead assignee: "+ notificationEx);
						}
					}
				
                    return EasyList.Common.Helpers.Utils.XMLGetNodeIterator(response.Lead.ToXml());
                }
                return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>" + response.Message + "</error>");
            }
			
            public XPathNodeIterator GetLead(string dealerCode, string id, bool markAsViewed, string userName)
            {
                string url = string.Format("{0}/lead?dealer={1}&code={2}&markAsViewed={3}&user={4}", baseURL, dealerCode, id, markAsViewed ? "1" : "0", userName);
                var response = GetRequest<LeadResponse>(url);
                if (response.Lead != null)
                {
                    return EasyList.Common.Helpers.Utils.XMLGetNodeIterator(response.Lead.ToXml());
                }
                return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>" + response.Message + "</error>");
            }

            public XPathNodeIterator SearchLeads(string dealerCode, string from, string to, string leadStatus, string assignedTo, string prospectSource, string keywords, string sort, string skip, string take)
            {                       
				      try
				      {
                  log.Info("Searching leads for dealer: "+ dealerCode);
                             
                  DateTime datetimeResult;
                  if (!string.IsNullOrWhiteSpace(from)) 
                  {                    								            
				              if (DateTime.TryParseExact(
						              from, 
						              "dd/MM/yyyy", 
						              CultureInfo.InvariantCulture, 
						              DateTimeStyles.None, 
						              out datetimeResult)) {
                          
                          from = datetimeResult.ToString("yyyyMMdd", CultureInfo.InvariantCulture);
							      
				              } else {
					              throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() { 
						              FieldName="Created", 
   						              RawMessage="Please supply a dd/mm/yyyy instead of {0} Create from" ,
						              Parameters=new object[1] { from }
					              });
				              }				                              
                  }
                  
                  if (!string.IsNullOrWhiteSpace(to)) 
                  {                    								            
				              if (DateTime.TryParseExact(
						              to, 
						              "dd/MM/yyyy", 
						              CultureInfo.InvariantCulture, 
						              DateTimeStyles.None, 
						              out datetimeResult)) {
                          
                           to = datetimeResult.ToString("yyyyMMdd", CultureInfo.InvariantCulture);
							      
				              } else {
					              throw InvalidFieldException.CreateSingle(new InvalidFieldEntry() { 
						              FieldName="Created", 
   						              RawMessage="Please supply a dd/mm/yyyy instead of {0} Create to" ,
						              Parameters=new object[1] { to }
					              });
				              }
                  }                                       
              					                  
					        string[] keywordsArray = string.IsNullOrWhiteSpace(keywords)
						      ? new string[] { }
						      : keywords.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
	        
                              
  					      // CreeatAsc is reverse in API program
                            
                var p = new SearchParameters
					      {
						      AssignedTo = assignedTo,
						      DealerCode = dealerCode,
						      FromDate = from,
						      Keywords = keywordsArray,
						      LeadStatus = ParseStatusArray(leadStatus),
						      ProspectSource = prospectSource,
						      Skip = string.IsNullOrEmpty(skip) ? 0 : int.Parse(skip),
						      SortOrder = ParseSortOrder(sort),
						      Take = string.IsNullOrEmpty(take) ? 100 : int.Parse(take),
						      ToDate = to
	 				      };         

					      string url = string.Format("{0}/search", baseURL);
					      log.Info("Using URL: "+ url);
					      var response = PostRequest<SearchResponse>(url, p);
					      log.Info("Search Leads Response: "+ response);

					      if(response != null)
                {
                log.Info("State: "+ response.State);
                log.Info("Message: "+ response.Message);
                log.Info("Results: "+ response.Results);


					                if (response.Results != null)
					                {
						                log.Info("Search leads response: "+ response.Results);
                            
                            	int totalPageFromResponse = (int)Math.Ceiling((double)response.Results.TotalResults / ITEM_PER_PAGE);

					                    IsTooManyResult = (totalPageFromResponse > MAX_PAGE_ALLOWED);
					                    TotalPage = Math.Min(MAX_PAGE_ALLOWED, totalPageFromResponse);
                              TotalCount = response.Results.TotalResults;
                            
						                return EasyList.Common.Helpers.Utils.XMLGetNodeIterator(response.Results.ToXml());
					                }
                }
					      return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>" + response.Message + "</error>");
				      }
              catch(InvalidFieldException ifex)
              {
                 return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>" + ifex.InvalidFieldEntries[0].FieldName + " - " + ifex.InvalidFieldEntries[0].Message + "</error>");
              }
				      catch(Exception ex)
				      {
					      log.Error("Error searching leads: "+ ex);
					      return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>" + ex.Message + "</error>");
				      }
            }

            public XPathNodeIterator GetListingLeads(string dealerCode, string listingCode)
            {
                string url = string.Format("{0}/leads/{1}/{2}", baseURL, dealerCode, listingCode);
                var response = GetRequest<SearchResponse>(url);
                if (response.Results != null)
                {
                    return EasyList.Common.Helpers.Utils.XMLGetNodeIterator(response.Results.ToXml());
                }
                return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>" + response.Message + "</error>");
            }
  

            public XPathNodeIterator GetSummaryReport(string dealerCode, string userName, string from, string to)
            {
                string url = string.Format("{0}/reports/summary?dealer={1}&from={2}&to={3}&user={4}", 
                    baseURL, dealerCode, from, to, userName);
                var response = PostRequest<LeadSummaryResponse>(url, new object());
                if (response.Report != null)
                {
                    return EasyList.Common.Helpers.Utils.XMLGetNodeIterator(response.Report.ToXml());
                }
                return EasyList.Common.Helpers.Utils.XMLGetNodeIterator("<error>" + response.Message + "</error>");
            }

            public T PostRequest<T>(string url, object requestData)
            {
                return HttpRequest<T>(url, key, RESTMethod.POST, requestData, null);
            }

            public T PutRequest<T>(string url, object requestData)
            {
                return HttpRequest<T>(url, key, RESTMethod.PUT, requestData, null);
            }

            public T GetRequest<T>(string url)
            {
                return HttpRequest<T>(url, key, RESTMethod.GET, null, null);
            }

            public T HttpRequest<T>(string url, string key, RESTMethod method, object requestData, string proxyUrl)
            {
                HttpWebRequest request = WebRequest.Create(url) as HttpWebRequest;
                request.Method = method.ToString();

				log.Info(method.ToString() +" request to: "+ url);
				if(requestData != null)
				{
					log.Info("Request Data: "+ requestData.ToXml());
				}
                request.Headers.Add("Authorization", string.Format("secret {0}", key));
                if (proxyUrl != null)
                {
                    request.Proxy = new WebProxy(proxyUrl);
                }
                request.ContentType = "application/xml";
                request.Accept = "application/xml";

                if (requestData != null)
                {
                    byte[] postData = ToXmlBytes(requestData);

					log.Info("POST data: "+ Encoding.UTF8.GetString(postData));

                    request.ContentLength = postData.Length;
                    using (Stream postDataStream = request.GetRequestStream())
                    {
                        postDataStream.Write(postData, 0, postData.Length);
                    }
                }

                HttpWebResponse response = request.GetResponse() as HttpWebResponse;

                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    string xmlString = reader.ReadToEnd();
					log.Info("Response XML: "+ xmlString);
                    return ToObject<T>(xmlString);
                }
            }




            private T ToObject<T>(string xmlString)
            {
                using (MemoryStream stream = new MemoryStream())
                {
                    byte[] bytes = Encoding.UTF8.GetBytes(xmlString);

                    stream.Write(bytes, 0, bytes.Length);
                    DataContractSerializer ser = new DataContractSerializer(typeof(T));
                    stream.Position = 0;
                    return (T)ser.ReadObject(stream);
                }
            }

            private byte[] ToXmlBytes(Object obj)
            {
                byte[] result;

                using (MemoryStream stream = new MemoryStream())
                {
                    DataContractSerializer ser = new DataContractSerializer(obj.GetType());
                    ser.WriteObject(stream, obj);
                    result = new byte[stream.Position];
                    Array.Copy(stream.ToArray(), result, (int)stream.Position);
                }

                return result;
            }

            private string ToXmlString(Object obj)
            {
                byte[] bytes = ToXmlBytes(obj);

                return Encoding.UTF8.GetString(bytes);
            }

        
        #region Helpers

        public bool ParseBool(string s)
        {
            if (string.IsNullOrWhiteSpace(s)) return false;
            return XmlConvert.ToBoolean(s);
        }

        public DateTime? ParseDateTime(string s)
        {
            if (string.IsNullOrWhiteSpace(s))
                return null;

            return XmlConvert.ToDateTime(s, "dd/MM/yyyy");
        }

        /// <summary>
        /// Parses a string into a BuyerType
        /// </summary>
        public BuyerType ParseBuyerType(string str)
        {
            if(string.IsNullOrWhiteSpace(str))
                return BuyerType.Private;

            switch(str.Trim())
            {
                case "Company" : return BuyerType.Company; 
                case "CompanyRetail" : return BuyerType.CompanyRetail;
                case "CompanyFleet": return BuyerType.CompanyFleet;
                case "Government" : return BuyerType.Government;
                case "GovernmentRetail":return BuyerType.GovernmentRetail;
                case "GovernmentFleet" : return BuyerType.GovernmentFleet;
                case "Private" : 
                default: return BuyerType.Private;
            }
        }

        /// <summary>
        /// Parses a string into a LeadMasterStatus
        /// </summary>
        public LeadMasterStatus ParseStatus(string status)
        {
            if (string.IsNullOrWhiteSpace(status))
            {
                return LeadMasterStatus.Unassigned;
            }

            var str = status.Trim();
            switch (str)
            {

                case "Assigned": return LeadMasterStatus.Assigned;
                case "Follow Up": return LeadMasterStatus.FollowUp;
                case "Closed - Won": return LeadMasterStatus.ClosedWon;
                case "Closed - Lost": return LeadMasterStatus.ClosedLost;
                case "Unassigned":
                default:
                    return LeadMasterStatus.Unassigned;
            }
        }

        /// <summary>
        /// Parses a CSV string into a LeadMasterStatus array
        /// </summary>
        public LeadMasterStatus[] ParseStatusArray(string status)
        {
            if(string.IsNullOrWhiteSpace(status))
            {
                return new LeadMasterStatus[] { LeadMasterStatus.Assigned, LeadMasterStatus.ClosedLost, LeadMasterStatus.ClosedWon,
                    LeadMasterStatus.FollowUp, LeadMasterStatus.Unassigned };
            }

            var response = new List<LeadMasterStatus>();
            foreach (string s in status.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
            {
                var str = s.Trim();
                switch (str)
                {
                    case "Unassigned":
                        response.Add(LeadMasterStatus.Unassigned);
                        break;

                    case "Assigned":
                        response.Add(LeadMasterStatus.Assigned);
                        break;

                    case "Follow Up":
                        response.Add(LeadMasterStatus.FollowUp);
                        break;

                    case "Closed - Won":
                        response.Add(LeadMasterStatus.ClosedWon);
                        break;

                    case "Closed - Lost":
                        response.Add(LeadMasterStatus.ClosedLost);
                        break;

                }
            }
            return response.ToArray();
        }

        /// <summary>
        /// Parses a string into a SortOrder
        /// </summary>
        public string GetSortOrder()
        {
              string result = "CreatedDesc";
        
            	if (!string.IsNullOrWhiteSpace(Request["SortBy"]) && !string.IsNullOrWhiteSpace(Request["SortOrder"])) 
              {   
                  string sortBy = Request["SortBy"].ToString();
                  string sortOrder = Request["SortOrder"].ToString();
             
                  if (sortOrder == "Ascending")
                  {
                      switch(sortBy)
                      {
                          case "Created":
                            result = "CreeatAsc";
                            break;
                          case "Last Updated":
                            result = "UpdatedAsc";
                            break;
                          case "Buyer Name":
                            result = "BuyerAsc";
                            break;
                          case "Listing Stock Number":
                            result = "StockNumAsc";
                            break;
                      }
                  }
                  else
                  {
                      switch(sortBy)
                      {
                          case "Created":
                            result = "CreatedDesc";
                            break;
                          case "Last Updated":
                            result = "UpdatedDesc";
                            break;
                          case "Buyer Name":
                            result = "BuyerDesc";
                            break;
                          case "Listing Stock Number":
                            result = "StockNumDesc";
                            break;
                      }
                  }
            }
            
            return result;
        }
        
         /// <summary>
        /// Parses a string into a SortOrder
        /// </summary>
        public SortOrder ParseSortOrder(string str)
        {
            if (string.IsNullOrWhiteSpace(str))
                return SortOrder.CreatedDesc;

            switch (str.Trim())
            {
                case "CreeatAsc": return SortOrder.CreeatAsc;
                case "UpdatedAsc": return SortOrder.UpdatedAsc;
                case "UpdatedDesc": return SortOrder.UpdatedDesc;
                case "BuyerAsc": return SortOrder.BuyerAsc;
                case "BuyerDesc": return SortOrder.BuyerDesc;
                case "StockNumAsc": return SortOrder.StockNumAsc;
                case "StockNumDesc": return SortOrder.StockNumDesc;
                case "CreatedDesc":
                default: return SortOrder.CreatedDesc;
            }
        }
        
        

		//-----------------------------------------------------------
		// Build parent-child
		//-----------------------------------------------------------

		public string CustomerChildList()
        {
			var UserCodeList = "";
		  	
			try
		   	{
				var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				if (!String.IsNullOrEmpty(UserCode))
		  		{
					UserCodeList = UserCode;
					IRepository repo = RepositorySetup.Setup();
	
					var UserInfo = repo.Single<Users>(u => u.UserCode == UserCode);
		
					if (UserInfo != null)
					{
			 			// Check for all child list
			 			var ChildList = repo.All<Users>(u => u.ParentUserID == UserInfo._id);
	 
			 			if (ChildList.Count() > 0 )
			 			{
			  				
			  				foreach(var user in ChildList)
			  				{
			   					if (UserCodeList != "") UserCodeList += ",";
			   					UserCodeList += user.UserCode;
			  				}
			  
				 		}
					}
				}
		   }
		   catch (Exception ex)
		   {
				log.Error("Failed! Error : " + ex);
		   }

		  	//-----------------------------------------------------------
			return UserCodeList;
		}
    
    
    
    public string GenerateCustomerChildDropdown(bool includeAll)
    {              
			    var HTMLControl = "";
			    try
			    {
				    IRepository repo = RepositorySetup.Setup();

				    var UserCodeList =  HttpContext.Current.Session["easylist-usercodelist"].ToString();
	
				    var UCList = UserCodeList.Split(',');
				
				    HTMLControl = "<div class='control-group'>";
				    HTMLControl += "<label class='control-label'>Customer account</label>";
				    HTMLControl += "<div class='controls'>";
				    HTMLControl += "<select id='listing-usercode' name='listing-usercode' multiple='multiple'>";
			
            if (includeAll)
            {
                HTMLControl += "<option value='" + UserCodeList + "' selected='selected'>All</option>";
            }
      
      
				    foreach (var usercode in UCList)
				    {
					    var UserInfo = repo.Single<Users>(u => u.UserCode == usercode);
			
					    if (UserInfo != null)
					    {   						
						    UserInfo.DealerName = UserInfo.DealerName.Replace("\"", "").Replace("\'", "");
						    HTMLControl += "<option value='" + usercode + "'>" + UserInfo.DealerName + " (" + UserInfo.UserName + ")</option>";
					    }
				    }
		       }
		       catch (Exception ex)
		       {
				    log.Error("Failed! Error : " + ex);
		       }
		       finally
		       {
				    HTMLControl += "</select>&nbsp;";
				    HTMLControl += "</div>";
				    HTMLControl += "</div>";
		       }
		        return HTMLControl;
		}
		
	
        #endregion



]]>

  </msxml:script>
</xsl:stylesheet>