<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxml="urn:schemas-microsoft-com:xslt"

  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:AccScripts="urn:AccScripts.this"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
  exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <!-- C# helper scripts -->

  <msxml:script language="C#" implements-prefix="AccScripts">
    <msxml:assembly name="NLog" />
    <msxml:assembly name="System.Xml.Linq"/>
    <msxml:assembly name="EasyList.Common.Helpers"/>
    <msxml:assembly name="EasyList.Data.DAL.Repository"/>
    <msxml:assembly name="EasyList.Data.DAL.Repository.Entity"/>
    <msxml:assembly name="EasyList.Data.BL"/>
    <msxml:assembly name="System.Web"/>
    <msxml:assembly name="System.Net"/>
    <msxml:assembly name="System.ServiceModel"/>
    <msxml:assembly name="System.ServiceModel.Web"/>
    <msxml:assembly name="Uniquemail.SingleSignOn"/>
    <msxml:assembly name="EasyList.Dashboard.Helpers"/>
    <msxml:assembly name="Componax.ExtensionMethods"/>
    <msxml:assembly name="Componax.Utils"/>
    <msxml:assembly name="System.Core"/>
    <msxml:assembly name="System.Xml.Linq"/>
    <msxml:assembly name="EasySales.Accounts"/>
    <msxml:assembly name="EasyList.Queue.Repo"/>
    <msxml:assembly name="EasyList.Queue.Repo.Driver"/>
    <msxml:assembly name="EasyList.Queue.Repo.Entity"/>
    <msxml:assembly name="EasyList.Queue.Helpers"/>
    <msxml:assembly name="EasySales.EwayAPI"/>
    <msxml:assembly name="MongoDB.Bson"/>
    <msxml:assembly name="MongoDB.Driver"/>

    <msxml:using namespace="System.Collections.Generic"/>
    <msxml:using namespace="System.Net"/>
    <msxml:using namespace="System.Linq"/>
    <msxml:using namespace="System.Web"/>
    <msxml:using namespace="System.Web.Caching"/>
    <msxml:using namespace="System.Net"/>
    <msxml:using namespace="System.ServiceModel"/>
    <msxml:using namespace="System.ServiceModel.Web"/>
    <msxml:using namespace="System.Xml"/>
    <msxml:using namespace="System.Xml.Linq"/>
    <msxml:using namespace="System.Xml.XPath"/>
    <msxml:using namespace="System.Text.RegularExpressions"/>
    <msxml:using namespace="EasyList.Data.BL"/>
    <msxml:using namespace="EasyList.Common.Helpers"/>
    <msxml:using namespace="EasyList.Common.Helpers.Web"/>
    <msxml:using namespace="EasyList.Common.Helpers.Web.REST"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity.Queue"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity.OTP"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity.Helpers"/>
    <msxml:using namespace="NLog" />
    <msxml:using namespace="Uniquemail.SingleSignOn" />
    <msxml:using namespace="EasyList.Dashboard.Helpers" />
    <msxml:using namespace="Componax.ExtensionMethods" />
    <msxml:using namespace="EasySales.Accounts"/>
    <msxml:using namespace="EasySales.EwayAPI" />
    <msxml:using namespace="EasyList.Queue.Repo.Entity"/>
    <msxml:using namespace="EasyList.Queue.Repo"/>
    <msxml:using namespace="EasyList.Queue.Helpers"/>

    <msxml:using namespace="MongoDB.Driver"/>
    <msxml:using namespace="MongoDB.Driver.Builders"/>
    <msxml:using namespace="MongoDB.Bson"/>
    <msxml:using namespace="MongoDB.Bson.Serialization"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository.Storage.Mongo"/>


    <![CDATA[
    static Logger log = LogManager.GetCurrentClassLogger();
    
    string SiteName = "easylist.com.au";   
	string AppID = "MyEasyListAppID";
	string AppSecretID = "MyEasyListSecretKey";  

 	//string URL = "http://rest.beta.mongodbv1.dev.easylist.com.au/"; 
 	string URL = "http://general.api.easylist.com.au/"; 

	string Protocol = "http";
	string Host = "messaging.api.easylist.com.au";
	string Secret = "EB78CAA0-474D-499E-9FD1-B3FA85534180";

	RESTStatus rs = new RESTStatus();

	public string SetSupportUserCode()
	{
		string ErrMessage = "";
		try
		{
			var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
			var NewUserCode = HTTPFormHelpers.GetString("NewUserCode");
			var NewUserID = HTTPFormHelpers.GetString("NewUserID");
			
			if (!String.IsNullOrEmpty(NewUserCode))
			{
				HttpContext.Current.Session["easylist-usercode"] = NewUserCode; 
				HttpContext.Current.Session["easylist-username"] = NewUserID; 
				HttpContext.Current.Session["easylist-displayname"] = NewUserID; 
				HttpContext.Current.Session["easylist-SupportUsername"] = UserID; 

				HttpContext.Current.Session["easylist-IsUWSupport"] = "true"; 

				var UserCodeChildList = CustomerChildList(NewUserCode);
				HttpContext.Current.Session["easylist-usercodelist"] = UserCodeChildList; 

  				var UserInfo = SSOHelper.GetUser(NewUserID);

 				// Set IsRetailUserCache
				if (UserInfo == null)
				{
					HttpContext.Current.Session["easylist-IsRetailUser"] = "false";
				}
				
				if (UserInfo.UserType == "Private")
				{
					HttpContext.Current.Session["easylist-IsRetailUser"] = "true";
				}else
				{
					HttpContext.Current.Session["easylist-IsRetailUser"] = "false";
				}

			 	var UserSignatureDateTime = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss");
				var UserSignature = EasyList.Common.Helpers.Web.REST.Signature.GenerateAPIUserSignature(NewUserID, NewUserCode, UserInfo.LoginPassword, UserSignatureDateTime);
				
				HttpContext.Current.Session["easylist-userSignatureDT"] = UserSignatureDateTime; 
				HttpContext.Current.Session["easylist-userSignature"] = UserSignature; 

				Logging.AuditLog(UserID, SecurityController.IPAddress,
					LogEvent.Create, "Set UserCode", "User : " + UserID + " set UserCode:" + NewUserCode + "; ID:" + NewUserID, "", NewUserCode);

				HttpContext.Current.Response.Redirect("/");
				ErrMessage = "SUCCESS";
			}
		}
		catch (Exception ex)
      	{
        	ErrMessage = "Set user code failed! Error : " + ex.ToString();
        	log.Error(ErrMessage);
      	}
      	return ErrMessage;
	}
  
	public string GetLoginNameByUserCode()
	{
		string LoginName = "";
		string ErrMessage = "";
		try
		{
			IRepository repo = RepositorySetup.Setup();

			var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
			if (!String.IsNullOrEmpty(UserCode))
			{
				var UserInfo = repo.Single<Users>(u => u.UserCode == UserCode);
				LoginName = UserInfo.UserName;
			}
		}
		catch (Exception ex)
      	{
        	ErrMessage = "Find user failed! Error : " + ex.ToString();
        	log.Error(ErrMessage);
      	}
      	return LoginName;
	}

	public XPathNodeIterator SupportFindUserListing()
    { 
		XPathNodeIterator nodeIterator = null;
		string strErrMessage = "";
		nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		try
		{
			IRepository repo = RepositorySetup.Setup();

			var SearchType = HTTPFormHelpers.GetString("SearchType");
			var UserSearchKeyword = HTTPFormHelpers.GetString("UserSearchKeyword");
			var UserSearchAdNum = HTTPFormHelpers.GetString("UserSearchAdNum");
			
			string StaffInfoListXML = "";
			List<Users> StaffInfoList = new List<Users>();
   			if (!string.IsNullOrWhiteSpace(UserSearchKeyword) || !string.IsNullOrWhiteSpace(UserSearchAdNum))	
			{
				// Search by LoginName/FirstName/UserCode/EmailAddress/ContractMobile

				if (SearchType == "SearchByUser")
				{

						

						var UserList = SSOHelper.SelectUsers("easylist.com.au", 0, 10, "", "", UserSearchKeyword);
						foreach (var u in UserList.Items)
						{
							var MongoUserInfo = new Users();
							MongoUserInfo.UserName = u.LoginName;
							MongoUserInfo.DealerName = u.CompanyName;
							MongoUserInfo.UserCode = u.UserCode;
							MongoUserInfo.DealerPhone = u.ContactMobile;
							MongoUserInfo.Email = u.EmailAddress;
							MongoUserInfo.UserType = u.UserType;

							StaffInfoList.Add(MongoUserInfo);
						}

   						// Try to find by user code
						var UserInfo = SSOHelper.FindUserByUserCode(UserSearchKeyword);

                        if (UserInfo != null)
                        {
    						var MongoUserInfo = new Users();
							MongoUserInfo.UserName = UserInfo.LoginName;
							MongoUserInfo.DealerName = UserInfo.CompanyName;
							MongoUserInfo.UserCode = UserInfo.UserCode;
							MongoUserInfo.DealerPhone = UserInfo.ContactMobile;
							MongoUserInfo.Email = UserInfo.EmailAddress;
							MongoUserInfo.UserType = UserInfo.UserType;

							StaffInfoList.Add(MongoUserInfo);
						}
						
	 					 /* StaffInfoList = repo.All<Users>(u => (
											((u.UserName != null) && (u.UserName.ToLower().Contains(UserSearchKeyword)))||
											((u.DealerName != null) && (u.DealerName.ToLower().Contains(UserSearchKeyword))) ||
											((u.DealerPhone != null) && (u.DealerPhone.ToLower().Contains(UserSearchKeyword))) ||
											((u.Email != null) && (u.Email.ToLower().Contains(UserSearchKeyword)))
						  )).Take(20).ToList();

						*/

   						//StaffInfoList = repo.All<Users>(u => u.UserName == UserSearchKeyword).Take(20).ToList();

						/*
						var MongoRepo = (MongoRepository)repo;

						var MongoQueries = new List<IMongoQuery>();
						var regex = new Regex(@"^(?=.*?\b" + UserSearchKeyword + @"\b).*$", RegexOptions.IgnoreCase);
						
   						//MongoQueries.Add(Query.And(Query.NE("UserName", BsonNull.Value), Query.Matches("UserName", BsonRegularExpression.Create(regex))));
   						//MongoQueries.Add(Query.Matches("UserName", BsonRegularExpression.Create(regex)));
   						//MongoQueries.Add(Query.EQ("UserName", UserSearchKeyword ));
						MongoQueries.Add(Query.EQ("UserName", "/^" + UserSearchKeyword + "$/i"));

						var UserQuery = Query.And(MongoQueries);
					
						SortByBuilder MongoSortList = new SortByBuilder();
						var StaffInfoListMongoResult = MongoRepo.All("Users", UserQuery, MongoSortList, 0 , 20, "").ToList();	
				
						foreach (var o in StaffInfoListMongoResult)
            		    {
							var u = BsonSerializer.Deserialize<Users>(o);
							StaffInfoList.Add(u);
	  					}*/
			
				}
				else
				{
					var listing = repo.Single<Listings>(l => l.Code == UserSearchAdNum || l.SrcID == UserSearchAdNum);
					if (listing != null)
					{
						StaffInfoList = repo.All<Users>(u => u.UserCode == listing.UserCode).ToList();
					}
				}
	
				if (StaffInfoList != null)
				{
					var StaffInfoListFilter = StaffInfoList.Select(u => new 
						Users { 
							UserName = u.UserName,
							DealerName = u.DealerName,
							UserCode = u.UserCode,
							DealerPhone = u.DealerPhone,
							Email = u.Email,
							UserType = u.UserType
					}).ToList();
	
					StaffInfoListXML = StaffInfoListFilter.ToXml();
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(StaffInfoListXML);
					return nodeIterator;
				}
				else
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("No user found for : " + UserSearchKeyword + "!");
					return nodeIterator;
				}
			}else
			{
				StaffInfoListXML = StaffInfoList.ToXml();
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(StaffInfoListXML);
				return nodeIterator;
			}
      	}
      	catch (Exception ex)
      	{
        	strErrMessage = "Find user failed! Error : " + ex.ToString();
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(strErrMessage);
        	log.Error(strErrMessage);
      	}
      	return nodeIterator;
	 }


 	//--------------------------------------------------------------------------------------------
 	// New User Account Register
	//--------------------------------------------------------------------------------------------
	public string NewUserRegister()
    { 
      string strErrMessage = "";
      try
      {
		log.Info("Registering New User");
		
		IRepository repo = RepositorySetup.Setup();
	
        var FirstName = HTTPFormHelpers.GetString("easylist-FirstName");
        var LastName = HTTPFormHelpers.GetString("easylist-LastName");
        var Email = HTTPFormHelpers.GetString("easylist-Email");
		var ContactMobile = HTTPFormHelpers.GetString("easylist-MobileNo");
        
        //-------------------------------------------------------------------------------
        // Validation
        //-------------------------------------------------------------------------------
        if (string.IsNullOrEmpty(FirstName)){ return "First Name is required field!"; }
        if (string.IsNullOrEmpty(LastName)){ return "Last Name is required field!"; }
        if (string.IsNullOrEmpty(Email)){ return "Email is required field!"; }
        if (string.IsNullOrEmpty(ContactMobile)){ return "Contact mobile no is required field!"; }
		  
        // Try to check if userID exists!
        Uniquemail.SingleSignOn.User exUserInfo = SSOHelper.GetUser(Email);
		if (exUserInfo != null)
        {
          return "The login email already in used, please use other login email!";
		}

		Account accInfo = AccountHelper.GetAccount(Email);
        if (accInfo != null)
        {
            return "The login email already in used, please use other login email!";
        }

  		/*		  		
  		// Check if Email was used
		Uniquemail.SingleSignOn.User exUserInfoVerifyEmail = SSOHelper.FindUserByEmail(Email);
        if (exUserInfoVerifyEmail != null)
        {
			 return "The Email already been used, please use other Email address!";
        }

		// Check if Contact mobile was used
		Uniquemail.SingleSignOn.User exUserInfoVerifyMobile = SSOHelper.FindUserByContactMobile(ContactMobile);
        if (exUserInfoVerifyMobile != null)
        {
			  return "The Contact Mobile no already been used, please use other contact mobile no!";
        }
  		*/
          
        List<string> UserGroupList = new List<string>();  
        UserGroupList.Add("RetailUser");
		//-------------------------------------------------------------------------------       

        string SecQuestion = "";
        string SecAnswer = "";
        int BirthYear = 0;
        string UserGroup = "";
        string CompanyName = Email;
        string JobTitle = "";
        string IPAddress = "";
        string UserAgent = "";
        string URL = "";
 //string NewPassword = "Qwer!234";
        string NewPassword = "Z*$z!234";
		string AddressLine1 = "";
		string AddressLine2 = "";
		string District = "";
		string RegionName = "";
		int RegionID = 0;
		string CountryCode = "";
		string Postalcode = "";
		string ContactPhone = "";
		string ContactFax = "";
		long EmployeeOf = 0;
      
        // User register function as it has included validation!
        Uniquemail.SingleSignOn.SessionInfo ssInfo = 
          SSOHelper.RegisterUserMD5(SiteName, Email, NewPassword,
            Email, FirstName, LastName, SecQuestion, 
            SecAnswer, BirthYear, UserGroupList,
            CompanyName, JobTitle, AddressLine1, AddressLine2,
            District, RegionName, RegionID, CountryCode,
            Postalcode, ContactPhone, ContactFax, ContactMobile,
            IPAddress, UserAgent, URL, Guid.NewGuid(), EmployeeOf );

        if (ssInfo != null)
        {
          	if (ssInfo.HadErrors)
          	{
             	return ssInfo.Message;
          	}

			//-------------------------------------
  		   	// Create new mongo account
			//-------------------------------------
			UsersBiz myBiz = new UsersBiz();
			myBiz.ProviderSource = "NewEasyList";
            myBiz.SourceDealerID = Email;
            myBiz.DealerEmail = Email;
            myBiz.DealerName = FirstName + " " + LastName;

            var NewUser = myBiz.CreateNewUser();
		
   			// Get User Code
         	myBiz.ProviderSource = "NewEasyList";
            myBiz.SourceDealerID = Email;

            var existingUser = myBiz.FindUser();
			
			existingUser.UserName = Email;
			existingUser.Email = Email;
			existingUser.DealerName = FirstName;
			existingUser.DealerPhone = ContactMobile;
			existingUser.EnquiryFromEmailAddress = Email;
			existingUser.UserSource = "NewEasyList";
   			existingUser.UserType = "Private";
			existingUser.IsDisabled = false;
			existingUser.UserSource = "EasyListDashboard";
			repo.Save<Users>(existingUser);

   			//-------------------------------------
 		   	// Create new account AccountsDB
			//-------------------------------------

 			var NewAccInfo = new EasySales.Accounts.Account();
			NewAccInfo.MemberID = Email;
			NewAccInfo.VendorID = 1;
			NewAccInfo.CustomerRef = "Unassigned";
			NewAccInfo.UserCode = existingUser.UserCode;
			
			NewAccInfo.AgencyID = 1;
			NewAccInfo.AccountStatusID = 0;
			NewAccInfo.InvoiceMethodID = 0;

			NewAccInfo.FirstName = FirstName;
			NewAccInfo.LastName = LastName;
			NewAccInfo.ContactMobile = ContactMobile;

			NewAccInfo.BillingCurrencyCode = "AUD";
			NewAccInfo.PaysGST = true;
			NewAccInfo.TotalInvoiced = 0;
			NewAccInfo.TotalPaid = 0;
			
			NewAccInfo.Address1 = "";
			NewAccInfo.Address2 = "";

	 		NewAccInfo.CompanyName = CompanyName;
			NewAccInfo.PrimaryEmail = Email;

			NewAccInfo.Save();

   			//-------------------------------------
   			// Generate Activation Key
			//-------------------------------------
			DateTime UserActivationTime = DateTime.Now;
            string ActivationKey = string.Format("{0}|{1}", UserActivationTime.ToString("yyyyMMddHHmmss"), Email);
            string ActivationKeyEnc = ActivationKey.Encrypt("EasylistAwesome", "Easylist");
			
			//-------------------------------------
		   	// Update user code info
			//-------------------------------------
		   	Uniquemail.SingleSignOn.User NewUserInfo = SSOHelper.GetUser(Email);
			NewUserInfo.UserCode = existingUser.UserCode;
			NewUserInfo.UserActivationState = "PendingActivation";
			NewUserInfo.UserActivationTime = UserActivationTime;
			NewUserInfo.UserType = "Private";
			var UpdatedUserInfo = SSOHelper.UpdateUser(NewUserInfo);
	
   			//-------------------------------------
   			// Send Email
			//-------------------------------------
			var ActURL = "https://dashboard.easylist.com.au/login?ActivationKey=";
			
			SendEmailRequest sendEmailRequest = new SendEmailRequest();
            sendEmailRequest.NameValues.Add("UserID", Email);
            sendEmailRequest.NameValues.Add("FirstName", FirstName);
            sendEmailRequest.NameValues.Add("LastName", LastName);
   			sendEmailRequest.NameValues.Add("activationUrl", string.Format("{0}{1}", ActURL, ActivationKeyEnc));
            sendEmailRequest.Priority = MessagingPriority.Normal;
            sendEmailRequest.TemplateName = "TradingpostActivation";
            sendEmailRequest.To = Email;
            sendEmailRequest.UserRef = "NewUserRegister";

			SendEmailResponse response = EasyList.Queue.Helpers.HttpInvocation.PostRequest<SendEmailResponse>(
                    string.Format("{0}://{1}/MessagingImpl.svc/SendEmail", Protocol, Host),
                    Secret, /* ********** A valid key with valid ACL ********** */
                    sendEmailRequest);
			
			if (response.ResponseCode != ResponseCodeType.OK)
			{
				return "Failed to send email!";
			}

        }
        else
        {
          return "Account creation failed! No session info return!";
        }
	  }
      catch (Exception ex)
      {
        strErrMessage = "New account register failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return strErrMessage;
    }


 	//--------------------------------------------------------------------------------------------
 	// Staff
	//--------------------------------------------------------------------------------------------
    public string CreateNewStaff()
    { 
      string strErrMessage = "";
      try
      {

        var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();

        if(string.IsNullOrEmpty(UserID)) 
        {
			  strErrMessage = "User ID not exists!";
			  log.Error(strErrMessage);
			  return strErrMessage;
        }
        
        Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);
  
        //***********************************************
        // Security
        //***********************************************
  		//if (!(userInfo.IsMemberOf("Manager") || userInfo.IsMemberOf("EasySales Admin"))){
		if (!IsAuthorized("Manager,EasySales Admin")){
			  return "Unauthorized access for User ID " + UserID + " !";
        }
        //***********************************************


        var LoginID = HTTPFormHelpers.GetString("LoginID");
        var NewPassword = HTTPFormHelpers.GetString("NewPassword");
        var ConfirmPassword = HTTPFormHelpers.GetString("ConfirmPassword");

        var FirstName = HTTPFormHelpers.GetString("FirstName");
        var LastName = HTTPFormHelpers.GetString("LastName");
        var Email = HTTPFormHelpers.GetString("Email");
		var ContactMobile = HTTPFormHelpers.GetString("ContactMobile");
        var ContactPhone = HTTPFormHelpers.GetString("ContactPhone");
        var ContactFax = HTTPFormHelpers.GetString("ContactFax");
        
        var AddressLine1 = HTTPFormHelpers.GetString("AddressLine1");
        var AddressLine2 = HTTPFormHelpers.GetString("AddressLine2");

        var CountryCode = HTTPFormHelpers.GetString("address-country-code");
        var RegionID = HTTPFormHelpers.GetIntNotNull("address-region-id");
        var RegionName = HTTPFormHelpers.GetString("address-region-name");
        var Postalcode = HTTPFormHelpers.GetString("address-postalcode");
        var District = HTTPFormHelpers.GetString("address-district");

        var ManagerGroupSet = HTTPFormHelpers.GetBool("ManagerGroup");
        var AccountGroupSet = HTTPFormHelpers.GetBool("Accounts");
        var EditorGroupSet = HTTPFormHelpers.GetBool("Editor");
        var SalesGroupSet = HTTPFormHelpers.GetBool("Sales");
		var ESSalesRepSet = HTTPFormHelpers.GetBool("ESSalesRep");
		var ESSupportSet = HTTPFormHelpers.GetBool("ESSupport");
        
        /*
        log.Info("ManagerGroupSet " + ManagerGroupSet);
        log.Info("New account " + LoginID);
        log.Info("New account RegionID => " + RegionID);
        log.Info("New account RegionName => " + RegionName);
        log.Info("New account Postalcode => " + Postalcode);
        log.Info("New account District => " + District);*/

        //-------------------------------------------------------------------------------
        // Validation
        //-------------------------------------------------------------------------------
        if (userInfo == null){  return "Master User ID " + UserID + " account not exists!";  }
        
        if (string.IsNullOrEmpty(LoginID)){ return "Login ID is required field!"; }
        if (string.IsNullOrEmpty(NewPassword)){ return "Password is required field!"; }
        if (string.IsNullOrEmpty(FirstName)){ return "First Name is required field!"; }
        if (string.IsNullOrEmpty(LastName)){ return "Last Name is required field!"; }
        if (string.IsNullOrEmpty(Email)){ return "Email is required field!"; }
        if (string.IsNullOrEmpty(ContactMobile)){ return "Contact mobile no is required field!"; }
		  
        if (NewPassword != ConfirmPassword){ return "New password and confirm password must be same!"; }

        // Try to check if userID exists!
        Uniquemail.SingleSignOn.User exUserInfo = SSOHelper.GetUser(LoginID);
        if (exUserInfo != null)
        {
			  return "The login ID already registered, please use other login ID!";
        }

  		//-------------------------------------------------------------
  		// Support for user grouping
  		//-------------------------------------------------------------
		long EmployeeOf = 0;
		if (HasChildList())
		{
			var DealerUserCode = HTTPFormHelpers.GetString("DealerUserCode");
			if (string.IsNullOrEmpty(DealerUserCode))
        	{
		 		return "Please select customer account!";
        	}
			
   			// Override user code
			UserCode = DealerUserCode;

			var StaffInfo = SSOHelper.FindUserByUserCode(DealerUserCode);
			if (StaffInfo != null)
			{
				EmployeeOf = SSOHelper.FindRootEmployeeID(StaffInfo.LoginName);
			}
			else
			{
				return "User not found for user code " + DealerUserCode + ".";
			}
		}
		else
		{
			EmployeeOf = SSOHelper.FindRootEmployeeID(UserID);
		}

        if (EmployeeOf == 0)
        {
			  return "User ID " + UserID + " employee of not exists!";
        }

  		// Check if Email was used
		/*Uniquemail.SingleSignOn.User exUserInfoVerifyEmail = SSOHelper.FindUserByEmail(Email);
        if (exUserInfoVerifyEmail != null)
        {
			  return "The Email already been used, please use other Email address!";
        }

		// Check if Contact mobile was used
  		Uniquemail.SingleSignOn.User exUserInfoVerifyMobile = SSOHelper.FindUserByContactMobile(ContactMobile);
        if (exUserInfoVerifyMobile != null)
        {
			  return "The Contact Mobile no already been used, please use other contact mobile no!";
		}*/
          
        List<string> UserGroupList = new List<string>();  
        if (ManagerGroupSet) UserGroupList.Add("Manager");
        if (AccountGroupSet) UserGroupList.Add("Account");
        if (EditorGroupSet) UserGroupList.Add("Editor");
        if (SalesGroupSet) UserGroupList.Add("Sales");
		if (ESSalesRepSet) UserGroupList.Add("ESSalesRep");
		if (ESSupportSet) UserGroupList.Add("ESSupport");

		if (UserGroupList.Count() == 0)
		{
			return "Please set at least one of the user roles. ";
		}
		//-------------------------------------------------------------------------------       


        string SecQuestion = "";
        string SecAnswer = "";
        int BirthYear = 0;
        string UserGroup = "";
        string CompanyName = userInfo.CompanyName;
        string JobTitle = "";
        string IPAddress = "";
        string UserAgent = "";
        string URL = "";
      
        // User register function as it has included validation!
        Uniquemail.SingleSignOn.SessionInfo ssInfo = 
          SSOHelper.RegisterUserMD5(SiteName, LoginID, NewPassword,
            Email, FirstName, LastName, SecQuestion, 
            SecAnswer, BirthYear, UserGroupList,
            CompanyName, JobTitle, AddressLine1, AddressLine2,
            District, RegionName, RegionID, CountryCode,
            Postalcode, ContactPhone, ContactFax, ContactMobile,
            IPAddress, UserAgent, URL, Guid.NewGuid(), EmployeeOf );

        /*
          var Success = SSOHelper.InsertUserMD5(SiteName, LoginID, NewPassword,
          Email, FirstName, LastName, SecQuestion, SecAnswer, 
          BirthYear, UserGroup,
          CompanyName, JobTitle, AddressLine1, AddressLine2,
          District, RegionName, RegionID, CountryCode,
          Postalcode, ContactPhone, ContactFax, ContactMobile,
          IPAddress, UserAgent, URL, Guid.Empty, EmployeeOf );
        */

        if (ssInfo != null)
        {
          if (ssInfo.HadErrors)
          {
             return ssInfo.Message;
          }
          

          // Set UserCode setting to XML
          Uniquemail.SingleSignOn.User NewUserInfo = SSOHelper.GetUser(LoginID);
          NewUserInfo.UserCode = UserCode;
	      NewUserInfo.UserActivationState = "NotActivated";
 		  NewUserInfo.UserType = "Business"; // Only commercial user allow to create staff

		  var UpdatedUserInfo = SSOHelper.UpdateUser(NewUserInfo);

          // Try to read if UserCode is set!  
		  //Uniquemail.SingleSignOn.User SavedUserInfo = SSOHelper.GetUser(LoginID);
		  //var SavedUserCode = SavedUserInfo.GetUserSetting("UserCode");
		  
		  var SavedUserCode = UpdatedUserInfo.UserCode;
          if (SavedUserCode != UserCode)
          {
				return "Account creation failed! User code failed to save!";
          }
        }
        else
        {
          return "Account creation failed! No session info return!";
        }
      }     
      catch (Exception ex)
      {
        strErrMessage = "New staff creation failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return strErrMessage;
    }

	public string VerifyOTP(string MobileNo, string OTPReferenceCode, string OTP)
	{
		XPathNodeIterator nodeIterator = null;
		string ErrMsg = "";
		try
		{
			EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());

			rc.URL = string.Format("{0}Account/MobileVerifyOTP?MobileNo={1}&OTPRefCode={2}&OTPCode={3}&UserOTPType={4}",
				URL, MobileNo, OTPReferenceCode, OTP , "ResetPassword");
		 	
			rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
			rc.RequestType = "application/xml";
			rc.ResponseType = "application/xml";

			log.Info("UserRequestResetPasswordSecAnswer => " + rc.URL);
		 
			rs = rc.SendRequest();
		 
			if (rs.State == RESTState.Success)
			{
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
				if (nodeIterator.Current.SelectSingleNode("/AccountInfo/HasError").Value == "true")
				{		
					return "Invalid OTP!";
				}else
				{ 
					HttpContext.Current.Session["OTPType"] = "";
					HttpContext.Current.Session["OTPVerifyByMobile"] = "";
					HttpContext.Current.Session["NewMobileNo"] = "";
					HttpContext.Current.Session["CustomTemplate"] = "";
					return "";
				}
			}
			else
			{
				 return "Invalid OTP!";
			}
		}
		catch (Exception ex)
      	{
			log.Error("Verify OTP Failed! Error : " + ex.ToString());
			return "Verify OTP Failed! Error : " + ex.ToString();
      	}

		return ErrMsg;
	}

	public XPathNodeIterator SendOTP(string MobileNo, string CustomTemplateName)
	{
		XPathNodeIterator nodeIterator = null;
        nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		try
		{
			EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
		
			rc.URL = URL + "Account/MobileSendOTP?MobileNo=" + MobileNo + "&ResendOTPType=ResetPassword" ;
			
			if (!string.IsNullOrEmpty(CustomTemplateName))
				rc.URL += "&CustomTemplateName=" + CustomTemplateName;
		
			log.Info("User changed mobile number to => " + MobileNo);
	
			rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
			rc.RequestType = "application/xml";
			rc.ResponseType = "application/xml";
		
			rs = rc.SendRequest();
		
			if (rs.State == RESTState.Success)
			{
 				// For resend purpose
				HttpContext.Current.Session["OTPType"] = "ResetPassword";
				HttpContext.Current.Session["OTPVerifyByMobile"] = "true";
				HttpContext.Current.Session["CustomTemplate"] = "ProfileResetMobile";
				HttpContext.Current.Session["NewMobileNo"] = MobileNo;

				log.Debug("OTP Send Success! ");
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
			}
			else
			{
				log.Debug("OTP Send Failed! Error:" + rs.Message);
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
			}
		}
		catch (Exception ex)
      	{
			log.Error("User change mobile number! Error : " + ex.ToString());
			return ErrorNodeIterator("User change mobile number! Error : " + ex.ToString());
      	}
      	return nodeIterator;
	}

	public bool StaffMobileNoChange(string LoginID)
	{
		string ErrMessage = "";
		bool IsChanged = false;
		try
		{
			var NewContactMobile = HTTPFormHelpers.GetString("ContactMobile");

			Uniquemail.SingleSignOn.User exUserInfo = SSOHelper.GetUser(LoginID);
			if (exUserInfo != null)
			{
				if (exUserInfo.ContactMobile != NewContactMobile)
				{
					IsChanged = true;
				}
			}
		}
		catch (Exception ex)
      	{
        	ErrMessage = "Staff MobileNo Change check failed! Error : " + ex.ToString();
        	log.Error(ErrMessage);
      	}	
		return IsChanged;
	}

    public string UpdateStaffAccount(string LoginID, bool IsProfileMtn = false)
    { 
      string strErrMessage = "";
      try
      {
  		IRepository repo = RepositorySetup.Setup();
		
        var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
		
        if(string.IsNullOrEmpty(UserID)) 
        {
          strErrMessage = "User ID not exists!";
          log.Error(strErrMessage);
          return strErrMessage;
        }

 		// Only need to update master account info for easylist, if is staff no need maintain record in mongo
 		var ELUserInfo = repo.Single<Users>(u => u.UserName == UserID);
		if (ELUserInfo == null)
		{
			log.Error("EasyList user : " + UserID + ". User not exists!");
		}
        
        Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);

        log.Info("LoginID=>"+LoginID);

        var FirstName = HTTPFormHelpers.GetString("FirstName");
        var LastName = HTTPFormHelpers.GetString("LastName");
        var Email = HTTPFormHelpers.GetString("Email");
        var ContactPhone = HTTPFormHelpers.GetString("ContactPhone");
        var ContactFax = HTTPFormHelpers.GetString("ContactFax");
        var ContactMobile = HTTPFormHelpers.GetString("ContactMobile");
        var AddressLine1 = HTTPFormHelpers.GetString("AddressLine1");
        var AddressLine2 = HTTPFormHelpers.GetString("AddressLine2");

        var CountryCode = HTTPFormHelpers.GetString("address-country-code");
        var RegionID = HTTPFormHelpers.GetIntNotNull("address-region-id");
        var RegionName = HTTPFormHelpers.GetString("address-region-name");
        var Postalcode = HTTPFormHelpers.GetString("address-postalcode");
        var District = HTTPFormHelpers.GetString("address-district");

        bool ManagerGroupSet = false; bool AccountGroupSet = false; bool EditorGroupSet = false; bool SalesGroupSet = false; bool ESSalesRepGroupSet = false; bool ESSupportGroupSet = false;
        bool ResetPassword = false; string NewPassword = ""; string ConfirmPassword = ""; 
        if (!IsProfileMtn)
        {
          ResetPassword = HTTPFormHelpers.GetBool("ResetPassword");
          NewPassword = HTTPFormHelpers.GetString("NewPassword");
          ConfirmPassword = HTTPFormHelpers.GetString("ConfirmPassword");

          ManagerGroupSet = HTTPFormHelpers.GetBool("ManagerGroup");
          AccountGroupSet = HTTPFormHelpers.GetBool("Accounts");
          EditorGroupSet = HTTPFormHelpers.GetBool("Editor");
          SalesGroupSet = HTTPFormHelpers.GetBool("Sales");
	      ESSalesRepGroupSet = HTTPFormHelpers.GetBool("ESSalesRep");
		  ESSupportGroupSet = HTTPFormHelpers.GetBool("ESSupport");
        }

        //-------------------------------------------------------------------------------
        // Validation
        //-------------------------------------------------------------------------------
        if (userInfo == null){  return "Your account with Login ID " + UserID + " not exists!";  }
        
        if (string.IsNullOrEmpty(LoginID)){ return "Login ID is required field!"; }
        if (string.IsNullOrEmpty(FirstName)){ return "First Name is required field!"; }
        if (string.IsNullOrEmpty(LastName)){ return "Last Name is required field!"; }
        if (string.IsNullOrEmpty(Email)){ return "Email is required field!"; }
        if (string.IsNullOrEmpty(ContactMobile)){ return "Contact mobile no is required field!"; }

        if (!IsProfileMtn && ResetPassword)
        {
          if (string.IsNullOrEmpty(NewPassword)){ return "Password is required field!"; }
          if (NewPassword != ConfirmPassword){ return "New password and confirm password must be same!"; }

          Uniquemail.SingleSignOn.GenericResponse ValidPassword = SSOHelper.IsPasswordValid(SiteName, NewPassword, Email, FirstName, LastName, 0);
          if (ValidPassword.HadErrors)
          {
            return ValidPassword.Message;
          }
        }

        // Try to check if userID exists!
        Uniquemail.SingleSignOn.User exUserInfo = SSOHelper.GetUser(LoginID);
        if (exUserInfo == null)
        {
          return "Account for login ID " + LoginID + " not exists!";
        }

		// Check if Email was used
		/*Uniquemail.SingleSignOn.User exUserInfoVerifyEmail = SSOHelper.FindUserByEmail(Email);
        if (exUserInfoVerifyEmail != null)
        {
			if (exUserInfoVerifyEmail.LoginName != LoginID)
			  return "The Email already been used, please use other Email address!";
        }

		// Check if Contact mobile was used
  		Uniquemail.SingleSignOn.User exUserInfoVerifyMobile = SSOHelper.FindUserByContactMobile(ContactMobile);
        if (exUserInfoVerifyMobile != null)
        {
			if (exUserInfoVerifyMobile.LoginName != LoginID)
			  return "The Contact Mobile no already been used, please use other contact mobile no!";
		}*/
  
        //-------------------------------------------------------------------------------

        exUserInfo.FirstName = FirstName;
        exUserInfo.LastName = LastName;
        exUserInfo.FirstName = FirstName;
        exUserInfo.EmailAddress = Email;
        exUserInfo.ContactPhone = ContactPhone;
        exUserInfo.ContactFax = ContactFax;
        
   		exUserInfo.ContactMobile = ContactMobile;  // Not allow to change mobile no untill implement feature to verify mobile no again
        
		exUserInfo.Address1 = AddressLine1;
        exUserInfo.Address2 = AddressLine2;

        exUserInfo.CountryCode = CountryCode;
        exUserInfo.RegionID = RegionID;
        exUserInfo.Region = RegionName;
        exUserInfo.PostalCode = Postalcode;
        exUserInfo.CityTown = District;

        if (!IsProfileMtn)
        {
			if (HasChildList())
			{
				var DealerUserCode = HTTPFormHelpers.GetString("DealerUserCode");
				if (string.IsNullOrEmpty(DealerUserCode))
				{
					return "Please select customer account!";
				}
				
				long EmployeeOf = 0;
				var StaffInfo = SSOHelper.FindUserByUserCode(DealerUserCode);
				if (StaffInfo != null)
				{
					EmployeeOf = SSOHelper.FindRootEmployeeID(StaffInfo.LoginName);
				}
				else
				{
					return "User not found for user code " + DealerUserCode + ".";
				}
				 if (EmployeeOf == 0)
				{
					  return "User ID " + UserID + " employee of not exists!";
				}
				
				// Override user code
				exUserInfo.UserCode = DealerUserCode;
				exUserInfo.EmployeeOf = EmployeeOf;
			}

          	log.Info("ResetPassword => " + ResetPassword);
          	if (ResetPassword)
			{
				exUserInfo.LoginPassword = NewPassword;
			}

          	List<string> UserGroupList = new List<string>();  
          	if (ManagerGroupSet) UserGroupList.Add("Manager");
          	if (AccountGroupSet) UserGroupList.Add("Account");
          	if (EditorGroupSet) UserGroupList.Add("Editor");
         	if (SalesGroupSet) UserGroupList.Add("Sales");
		  	if (ESSalesRepGroupSet) UserGroupList.Add("ESSalesRep");
		  	if (ESSupportGroupSet) UserGroupList.Add("ESSupport");

			if (UserGroupList.Count() == 0)
			{
				return "Please set at least one of the user roles. ";
			}

          	var UpdatedUserInfo = SSOHelper.UpdateUserAndGroups(exUserInfo, UserGroupList, ResetPassword, true);
		}else
		{
		  log.Info("Profile info saving to db....");
		  var UpdatedUserInfo = SSOHelper.UpdateUser(exUserInfo);
		}

  		if (ELUserInfo != null)
		{
			if (ResetPassword)
			{
				 ELUserInfo.PasswordMD5 = NewPassword;
			}
		 
			// 
			if (IsRetailUser())
			{
			 	ELUserInfo.DealerName = FirstName;
			 	ELUserInfo.EnquiryFromEmailAddress = Email;
			 	ELUserInfo.DealerPhone = ContactMobile;
			}
			ELUserInfo.DealerAddress = AddressLine1;
			ELUserInfo.DealerPostCode = Postalcode;
			ELUserInfo.DealerLocCountryCode = CountryCode;
			ELUserInfo.DealerLocStateProvince = RegionName;
			ELUserInfo.DealerLocRegion = District;
			ELUserInfo.Email = Email;
		 
			repo.Save(ELUserInfo);
		   
		}
		
        //-------------------------------------------------------------------------------       

      }     
      catch (Exception ex)
      {
        strErrMessage = "Staff editing failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return strErrMessage;
    }

    public string DeleteStaffAccount(string LoginID)
        { 
      string strErrMessage = "";
      try
      {
        var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();      
        
        Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(LoginID);
        
        if (StaffInfo == null)
        {
          log.Error("No user found for login ID " + LoginID + "!");
          return "No user found for login ID " + LoginID + "!";
        }

        // Check if the staff is belongs to the same dealer
  		//var SavedUserCode = StaffInfo.GetUserSetting("UserCode");
  		/* var SavedUserCode = StaffInfo.UserCode;
        if (SavedUserCode != UserCode)
        {
          return "You are not authorize to access the login " + LoginID;
		}*/
			
		var SavedUserCode = StaffInfo.UserCode;
		bool ValidUser = false;
		var UserCodeChildList = "";
		if (HasChildList())
		{
			UserCodeChildList = HttpContext.Current.Session["easylist-usercodelist"].ToString(); 
		   	if (UserCodeChildList.IndexOf(SavedUserCode) >= 0)
		   	{
				ValidUser = true;
		   	}
		}
		else
	 	{
		   	if (SavedUserCode == UserCode)
			{
				ValidUser = true;
		   	}
		}

		if (!ValidUser)
		{
			return "User code is different for login ID " + LoginID + "! Logon user code = " + UserCode + " vs saved user code " + SavedUserCode;
		}

        if (!SSOHelper.DeleteUser(StaffInfo))
        {
          return "Failed to delete user " + LoginID;
        }
      }     
      catch (Exception ex)
      {
        strErrMessage = "Staff deletion failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return strErrMessage;
    }

    public XPathNodeIterator GetStaffAccount(string LoginID = "", bool IsProfileMtn = false)
    { 
      XPathNodeIterator nodeIterator = null;
      nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
      string strErrMessage = "";
      try
      {
        var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();

        if (IsProfileMtn)
        {
            // Profile page
          LoginID = UserID ;
        }else
        {
            // Staff maintenance page
          if (string.IsNullOrEmpty(LoginID))
          {
            log.Error("Account login ID is empty!");
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Account login ID is empty!");
            return nodeIterator;
          }

          if (LoginID.ToUpper() == UserID.ToUpper())
          {
            log.Error("Unauthorized access to own account maintenanace!");
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Unauthorized access to own account maintenanace!");
            return nodeIterator;
          }
        }
  
        Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(LoginID);
        
        if (StaffInfo == null)
        {
          log.Error("No user found for login ID " + LoginID + "!");
          nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("No user found for login ID " + LoginID + "!");
          return nodeIterator;
        }

        // Check if the staff is belongs to the same dealer
  		//var SavedUserCode = StaffInfo.GetUserSetting("UserCode");

		var SavedUserCode = StaffInfo.UserCode;

		bool ValidUser = false;
		var UserCodeChildList = "";
		if (HasChildList())
		{
			UserCodeChildList = HttpContext.Current.Session["easylist-usercodelist"].ToString(); 
		   	if (UserCodeChildList.IndexOf(SavedUserCode) >= 0)
		   	{
				ValidUser = true;
		   	}
		}
		else
	 	{
		   	if (SavedUserCode == UserCode)
			{
				ValidUser = true;
		   	}
		}

		if (!ValidUser)
		{
			log.Error("User code is different for login ID " + LoginID + "! Logon user code = " + UserCode + " vs saved user code " + SavedUserCode);
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("You are not authorize to access the login " + LoginID + ":" + SavedUserCode + " vs "+ UserCodeChildList + ".." + UserCodeChildList.IndexOf(SavedUserCode).ToString());
			return nodeIterator;
		}

        var StaffInfoXML = StaffInfo.ToXml();
        nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(StaffInfoXML);
      }     
      catch (Exception ex)
      {
        strErrMessage = "Staff editing failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return nodeIterator;
    }

    public XPathNodeIterator GetStaffAccountGroup()
        { 
      XPathNodeIterator nodeIterator = null;
      nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
      string GroupList = "";
      try
      {
        var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();      
        Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(UserID);
        
        if (StaffInfo != null)
        { 
          if (!string.IsNullOrEmpty(StaffInfo.GroupMemberships))
          {
            Object[] StaffGroup = EasyList.Common.Helpers.Utils.StringDelimitedToObjectArray(StaffInfo.GroupMemberships, ',');
            List<string> StaffGroupList = StaffGroup.Select(i => i.ToString().Trim()).ToList();
            GroupList = String.Join(",", StaffGroupList.ToArray());
          }
        }else
        {
          log.Info("No user account exists for login ID " + UserID);
        }

      }     
      catch (Exception ex)
      {
        log.Error("GetStaffAccountGroup failed. Error "  + ex.ToString());
      }
      return nodeIterator;
    }

    public string GetStaffAccountGroup(string LoginID = "", bool IsProfileMtn = false)
        { 
      string GroupList = "";
      try
      {
        if (HttpContext.Current.Session["easylist-username"] == null) return "";

        var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();      
        Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(LoginID);
        
        if (IsProfileMtn)
        {
            // Profile page
          LoginID = UserID ;
        }else
        {
            // Staff maintenance page
          if (string.IsNullOrEmpty(LoginID))
          {
            log.Error("Account login ID is empty!");
          }

          if (LoginID.ToUpper() == UserID.ToUpper())
          {
            log.Error("Unauthorized access to own account maintenanace!");
          }
        }

        if (StaffInfo != null)
        { 
          
          // Check if the staff is belongs to the same dealer
		  //var SavedUserCode = StaffInfo.GetUserSetting("UserCode");
		  var SavedUserCode = StaffInfo.UserCode;
          if (SavedUserCode != UserCode)
          {
            log.Error("User code is different for login ID " + LoginID + "! Logon user code = " + UserCode + " vs saved user code " + SavedUserCode);
            return "";
          }

          if (!string.IsNullOrEmpty(StaffInfo.GroupMemberships))
          {
            Object[] StaffGroup = EasyList.Common.Helpers.Utils.StringDelimitedToObjectArray(StaffInfo.GroupMemberships, ',');
            List<string> StaffGroupList = StaffGroup.Select(i => i.ToString().Trim()).ToList();
            GroupList = String.Join(",", StaffGroupList.ToArray());
          }else
          {
            log.Info("No membership infor for login ID " + LoginID);
          }
        }else
        {
          log.Info("No user account exists for login ID " + LoginID);
        }

      }     
      catch (Exception ex)
      {
        log.Error("GetStaffAccountGroup failed. Error "  + ex.ToString());
      }
      return GroupList;
    }

    public XPathNodeIterator GetStaffAccountGroupList(string LoginID = "")
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            try
            {
                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                var UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
                Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(LoginID);

                if (StaffInfo != null)
                {

                    // Check if the staff is belongs to the same dealer
	 				//var SavedUserCode = StaffInfo.GetUserSetting("UserCode");
					var SavedUserCode = StaffInfo.UserCode;

					bool ValidUser = false;
					if (HasChildList())
					{
						var UserCodeChildList = HttpContext.Current.Session["easylist-usercodelist"].ToString(); 
						if (UserCodeChildList.IndexOf(SavedUserCode) >= 0)
						{
							ValidUser = true;
						}
					}
					else
					{
						if (SavedUserCode == UserCode)
                    	{
							ValidUser = true;
						}
					}

                    if (ValidUser)
					{
                        if (!string.IsNullOrEmpty(StaffInfo.GroupMemberships))
                        {
                            Object[] StaffGroup = EasyList.Common.Helpers.Utils.StringDelimitedToObjectArray(StaffInfo.GroupMemberships, ',');
                            List<string> StaffGroupList = StaffGroup.Select(i => i.ToString().Trim()).ToList();

                            var StaffGroupListXML = StaffGroupList.ToXml();

                            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(StaffGroupListXML);
                        }
                    }
                }
                else
                {
                    log.Info("No user account exists for login ID " + UserID);
          nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("No user account exists for login ID " + UserID);
                }

            }
            catch (Exception ex)
            {
                log.Error("GetStaffAccountGroupList failed. Error " + ex.ToString());
                nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("GetStaffAccountGroupList failed. Error " + ex.ToString());
            }
            return nodeIterator;
        }

    public XPathNodeIterator GetStaffAccountGroupList()
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            try
            {
                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                var UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
                Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(UserID);

                if (StaffInfo != null)
                {

                    // Check if the staff is belongs to the same dealer
					//var SavedUserCode = StaffInfo.GetUserSetting("UserCode");
                    var SavedUserCode = StaffInfo.UserCode;
					if (SavedUserCode == UserCode)
                    {
                        if (!string.IsNullOrEmpty(StaffInfo.GroupMemberships))
                        {
                            Object[] StaffGroup = EasyList.Common.Helpers.Utils.StringDelimitedToObjectArray(StaffInfo.GroupMemberships, ',');
                            List<string> StaffGroupList = StaffGroup.Select(i => i.ToString().Trim()).ToList();

                            var StaffGroupListXML = StaffGroupList.ToXml();

                            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(StaffGroupListXML);
                        }
                    }
                }
                else
                {
                    log.Info("No user account exists for login ID " + UserID);
                }

            }
            catch (Exception ex)
            {
                log.Error("GetStaffAccountGroupList failed. Error " + ex.ToString());
                nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("GetStaffAccountGroupList failed. Error " + ex.ToString());
            }
            return nodeIterator;
        }

    public string AccountChangePassword(string LoginID)
        { 
      string strErrMessage = "";
      try
      {
        var CurrentPassword = HTTPFormHelpers.GetString("CurrentPassword");
        var NewPassword = HTTPFormHelpers.GetString("NewPassword");
        var ConfirmPassword = HTTPFormHelpers.GetString("ConfirmPassword");
        
        //-------------------------------------------------------------------------------
        // Validation
        //-------------------------------------------------------------------------------
        if(string.IsNullOrEmpty(CurrentPassword)){ return "Current Password is empty!"; }
        if(string.IsNullOrWhiteSpace(NewPassword)){ return "New Password is empty!"; }
        if(string.IsNullOrEmpty(ConfirmPassword)){ return "Re-type New Password is empty!"; } 
        if(string.IsNullOrEmpty(LoginID)){ return "Login ID not exists!"; }
      
        if (NewPassword != ConfirmPassword)
        {   
          return "New password is different! Please re-type password.";
        }
        if (NewPassword == CurrentPassword)
        {   
          return "New password cannot be the same with the current password.";
        }
      
        Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(LoginID);
  
        if (StaffInfo == null)
        {
          return "No Account exists for login ID " + LoginID + "!";
        }

		bool hashPassword = true;
		bool ValidPassword = false;
		string CurrentPasswordHash = CurrentPassword;
        ValidPassword =  SSOHelper.PasswordValidation(StaffInfo, ref CurrentPasswordHash, hashPassword);

  		//if (StaffInfo.LoginPassword != CurrentPassword.MD5())
		if (!ValidPassword)
        {
          log.Info("Staff existing password " + StaffInfo.LoginPassword + " vs new password " + CurrentPasswordHash);
          return "Invalid current password.";
        }

	    var NewPasswordCheck = SSOHelper.IsPasswordValid(SiteName, NewPassword, StaffInfo.EmailAddress, StaffInfo.FirstName, StaffInfo.LastName, 0);
        if (NewPasswordCheck.HadErrors)
        {
          return NewPasswordCheck.Message;
		}
        //-------------------------------------------------------------------------------
        
  		//StaffInfo.LoginPassword = NewPassword.MD5();
		int phType = 0;
		StaffInfo.LoginPassword = SSOHelper.PasswordHashing(StaffInfo.LoginName, NewPassword, ref phType);
        StaffInfo.PasswordHashType = phType;

        var UpdatedUserInfo = SSOHelper.UpdateUser(StaffInfo);
      
      }     
      catch (Exception ex)
      {
        strErrMessage = "Staff deletion failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return strErrMessage;
    }

    public XPathNodeIterator GetDealerStaff()
    {
      XPathNodeIterator nodeIterator = null;
      nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
      try
      {
        var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        if(string.IsNullOrEmpty(UserID)) 
        {
          log.Error("User ID not exists!"); 
          nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("User ID not exists!");
          return nodeIterator;
        }
        
        Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);
        
        if (userInfo == null)
        { 
          log.Error("User ID " + UserID + " account not exists!"); 
          nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("User ID " + UserID + " account not exists!");
          return nodeIterator;
        }

        //***********************************************
        // Security (Second level check, first level check in xslt)
        //***********************************************
  		//if (!(userInfo.IsMemberOf("Manager") || userInfo.IsMemberOf("EasySales Admin"))){
		if (!IsAuthorized("Manager,EasySales Admin")){
          log.Error("Unauthorized access for User ID " + UserID + " !"); 
          nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Unauthorized access for User ID " + UserID + " !");
          return nodeIterator;
        }
        //***********************************************

        var EmpOf = SSOHelper.FindRootEmployeeID(UserID);
  
        if (EmpOf == 0)
        {
          log.Error("User ID " + UserID + " employee of not exists!"); 
          nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("User ID " + UserID + " employee of not exists!");
          return nodeIterator;
        }

		string UserCodeChildList = "";
		if (HttpContext.Current.Session["easylist-usercodelist"] != null)
		{
			UserCodeChildList = HttpContext.Current.Session["easylist-usercodelist"].ToString(); 
		}

		string DealerStaffListXML = "";
  		
		if (!string.IsNullOrEmpty(UserCodeChildList) && (UserCodeChildList.IndexOf(',') > 0))
		{
			var AgentStaffList = SSOHelper.FindAgentEmployees(UserCodeChildList);
			// User should not manage own account to prevent user delete their own account.
			var DealerStaffListFilter = AgentStaffList.Where(u => u.LoginName != UserID).Select(u => new 
				Uniquemail.SingleSignOn.UserStaff { 
					EmployeeOf = u.EmployeeOf,
					EmpOfLoginName = u.EmpOfLoginName,
					EmpOfFirstName = u.EmpOfFirstName,
					EmpOfLastName = u.EmpOfLastName,
	
					LoginName = u.LoginName,
					FirstName = u.FirstName,
					LastName = u.LastName,
					ContactMobile = u.ContactMobile,
					ContactPhone = u.ContactPhone,
					EmailAddress = u.EmailAddress,
					DateCreated = u.DateCreated
			}).ToList();

			DealerStaffListXML = DealerStaffListFilter.ToXml();
		}
  	    else
		{
			var DealerStaffList = SSOHelper.FindEmployees(EmpOf);
			
			// User should not manage own account to prevent user delete their own account.
			var DealerStaffListFilter = DealerStaffList.Where(u => u.LoginName != UserID).Select(u => new 
				Uniquemail.SingleSignOn.UserStaff { 
					LoginName = u.LoginName,
					FirstName = u.FirstName,
					LastName = u.LastName,
					ContactMobile = u.ContactMobile,
					ContactPhone = u.ContactPhone,
					EmailAddress = u.EmailAddress,
					DateCreated = u.DateCreated
			}).ToList();

			DealerStaffListXML = DealerStaffListFilter.ToXml();
		}

  		// log.Debug("EmpOf : " + EmpOf);
  		// log.Debug("DealerStaffListFilter =>" + DealerStaffListFilter.FirstOrDefault().ToPropertiesString());
        
        nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(DealerStaffListXML);
      }     
      catch (Exception ex)
      {
        log.Error("Read getting dealer staff list! Error:" + ex.ToString());
      }
      return nodeIterator;
    }

	//=======================================================================================================================
	// Forgotten Password
	//=======================================================================================================================
	public XPathNodeIterator UserRequestResetPassword()
    { 
	  XPathNodeIterator nodeIterator = null;
	  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
	  UserReset ur = new UserReset();
      string strErrMessage = "";
      try
      {
		var UserName = HTTPFormHelpers.GetString("username");

		log.Info("User name " + UserName);
        
		string PasswordResetURL = @"https://dashboard.easylist.com.au/action/password-recovery.aspx";

        //-------------------------------------------------------------------------------
        // Validation
        //-------------------------------------------------------------------------------
        if(string.IsNullOrEmpty(UserName)){ 
			ur.ErrorMessage = "User Name is required!";
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(ur.ToXml());
			return nodeIterator;
		}
 		
 		Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserName);
		if (userInfo == null)
		{
			ur.ErrorMessage = "Password recovery failed!!";
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(ur.ToXml());
			return nodeIterator;
		}
		 
  //if (!string.IsNullOrEmpty(userInfo.UserActivationState) && userInfo.UserActivationState.ToUpper() == "ACTIVATED")
  //{
 			// User Activated, direct send email
			// TODO: Send to EMAIL

			
			string ResetURL = "https://dashboard.easylist.com.au/action/password-recovery.aspx";
			DateTime UserResetTime = DateTime.Now;
		
			string ResetKey = string.Format("{0}|{1}", UserResetTime.ToString("yyyyMMddHHmmss"), UserName);
			string ResetKeyEnc = ResetKey.Encrypt("EasylistAwesome", "Easylist");
		
			log.Info("ResetKeyEnc => " + ResetKeyEnc);
		
			string ResetLink = string.Format("{0}?ResetKey={1}", ResetURL, ResetKeyEnc);
		   
			log.Info("Sending Email");

			// TODO : Send Email
			/*EmailJob emailJob = new EmailJob()
			{
				 Sender = "support@easylist.com.au",
				 Recipient = userInfo.EmailAddress,
				 Subject = "Tradingpost account reset password",
				 TemplateName = @"\email\activation\TradingPostActivation.vm"
			};
		 
			emailJob.NameValues["UserID"] = UserName;
			emailJob.NameValues["FirstName"] = userInfo.FirstName;
			emailJob.NameValues["LastName"] = userInfo.LastName;
	 		emailJob.NameValues["activationUrl"] = ResetLink;
		 
			using (IEasyListQueueClient client = Core.CreateClient("/messaging/email"))
			{
			 client.Post(Utils.ObjectToJSON(emailJob));
			}*/


			SendEmailRequest sendEmailRequest = new SendEmailRequest();
            sendEmailRequest.NameValues.Add("UserID", UserName);
            sendEmailRequest.NameValues.Add("FirstName", userInfo.FirstName);
            sendEmailRequest.NameValues.Add("LastName", userInfo.LastName);
            sendEmailRequest.NameValues.Add("Link", ResetLink);
            sendEmailRequest.NameValues.Add("LinkDesc", ResetLink);
            sendEmailRequest.Priority = MessagingPriority.Normal;
            sendEmailRequest.TemplateName = "TradingpostResetPassword";
            sendEmailRequest.To = userInfo.EmailAddress;
            sendEmailRequest.UserRef = "UserRequestResetPassword";

			SendEmailResponse response = EasyList.Queue.Helpers.HttpInvocation.PostRequest<SendEmailResponse>(
                    string.Format("{0}://{1}/MessagingImpl.svc/SendEmail", Protocol, Host),
                    Secret, /* ********** A valid key with valid ACL ********** */
                    sendEmailRequest);
			
			if (response.ResponseCode != ResponseCodeType.OK)
			{
				ur.ErrorMessage = "Password recovery failed!!";
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(ur.ToXml());
				return nodeIterator;
			}

  //}
		/*else
		{
   			
			if (string.IsNullOrEmpty(userInfo.SecurityQuestion))
			{
				// User Activated, direct send email
				// TODO: Send to EMAIL
			}
			else
			{
 				// Prompt for security answer
				ur.UserName = UserName;
				ur.SecQuestion = userInfo.SecurityQuestion;

				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(ur.ToXml());
			}
			
		}
		*/

		  /*
	   DateTime UserResetTime = DateTime.Now;
	
	   string ActivationKey = string.Format("{0}|{1}", UserResetTime.ToString("yyyyMMddHHmmss"), LoginID);
	   string ActivationKeyEnc = ActivationKey.Encrypt("EasylistAwesome", "Easylist");
	
		log.Info("ActivationKeyEnc => " + ActivationKeyEnc);
	
	   ActivationLink = string.Format("{0}?ActivationKey={1}", ActivationURL, ActivationKeyEnc);
	   
	   userInfo.UserActivationState = "PendingActivation";
	   userInfo.UserActivationTime = UserActivationTime;
	   userInfo.UserActivationBy = UserID;
	   
	   var UpdatedUserInfo = SSOHelper.UpdateUser(userInfo);
	   */
	

		/*
        Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(LoginID);
  
        if (StaffInfo == null)
        {
          return "No Account exists for login ID " + LoginID + "!";
        }

        if (StaffInfo.LoginPassword != CurrentPassword.MD5())
        {
          log.Info("Staff existing password " + StaffInfo.LoginPassword + " vs new password " + CurrentPassword.MD5());
          return "Invalid current password.";
        }

        var ValidPassword = SSOHelper.IsPasswordValid(SiteName, NewPassword, StaffInfo.EmailAddress, StaffInfo.FirstName, StaffInfo.LastName, 0);
        if (ValidPassword.HadErrors)
        {
          return ValidPassword.Message;
        }
        //-------------------------------------------------------------------------------
        
        StaffInfo.LoginPassword = NewPassword.MD5();
        var UpdatedUserInfo = SSOHelper.UpdateUser(StaffInfo);
	    */
      }     
      catch (Exception ex)
      {
        strErrMessage = "Reset password request failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
		ur.ErrorMessage = strErrMessage;
		nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(ur.ToXml());
		
      }
      return nodeIterator;
    }


	public XPathNodeIterator UserRequestResetPasswordLoad(string ResetKeyEnc, string IsPostBackSecAns)
    {
		XPathNodeIterator nodeIterator = null;
        nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		try
		{
   			//log.Info("IsPostBackSecAns : " + IsPostBackSecAns);
			string ResetUserID = "";
			string ErrMessage = ValidateResetKey(ResetKeyEnc, out ResetUserID);
	
			if (ErrMessage != "") return ErrorNodeIterator(ErrMessage);

			if (string.IsNullOrEmpty(ResetUserID))
			{
				log.Info("ResendOTP failed! User ID is empty!");
				return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Resend OTP Failed. No User ID exist!");
  			}

   			// Disable OTP
			//-----------------------------------------------
   			// SEND OTP
   	  		/*
			if (IsPostBackSecAns != "true")
			{
				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
	
				rc.URL = URL + "Account/SendOTP?UserID=" + ResetUserID + "&ResendOTPType=ResetPassword" ;
				
				log.Info("UserRequestResetPasswordLoad => " + rc.URL);

				rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
				rc.RequestType = "application/xml";
				rc.ResponseType = "application/xml";
			 
				rs = rc.SendRequest();
			 
				if (rs.State == RESTState.Success)
				{
  					//log.Debug("OTP Send Success! " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserCode").Value);
					log.Debug("OTP Send Success! ");
					 nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
				}
				else
				{
					 log.Debug("OTP Send Failed! Error:" + rs.Message);
					 nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
				}
   			}*/
			//-----------------------------------------------

			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(ResetUserID);
			if (userInfo == null)
			{
				log.Info("Failed! User account not exists!");
				return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed! User account not exists!");
  			}

			// Masked contact mobile
			string ContactMobile = userInfo.ContactMobile;
			string ContactMobileMasked = "";
			if (!string.IsNullOrEmpty(ContactMobile))
			{
				int ContactLength = ContactMobile.Length;
            	int ContactMaskStart = ContactMobile.Length / 3 ;
            	int ContactMaskEnd = ContactMobile.Length / 2;
            	string ContactToMask = ContactMobile.Substring(ContactMaskStart, ContactMaskEnd);
				//ContactMobileMasked = ContactMobile.Replace(ContactToMask, new String('*', ContactMaskEnd));
				ContactMobileMasked= ContactMobile.Remove(ContactMaskStart, ContactMaskEnd).Insert(ContactMaskStart, new String('*', ContactMaskEnd));
			}
			userInfo.ContactMobile = ContactMobileMasked;

   			//-----------------------------------------------------------------
   			// Store in session for OTP Resend
			HttpContext.Current.Session["LoginUserID"] = ResetUserID; 
			HttpContext.Current.Session["OTPType"] = "ResetPassword"; 
			//-----------------------------------------------------------------

			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(userInfo.ToXml());

		}
      	catch (Exception ex)
      	{
			log.Error("User requeset reset password loading failed! Error : " + ex.ToString());
			return ErrorNodeIterator("Account reset password failed! Error : " + ex.ToString());
      	}
      	return nodeIterator;
	}

	public XPathNodeIterator UserRequestResetPasswordSecAnswer(string ResetKeyEnc)
    {  
	  XPathNodeIterator nodeIterator = null;
	  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
      string strErrMessage = "";
      try
      {
			var NewPassword = HTTPFormHelpers.GetString("new-password");
			var NewPasswordConfirm = HTTPFormHelpers.GetString("new-password-confirm");
			var OTPCode = HTTPFormHelpers.GetString("easylist-OTP");
			
			string ResetUserID = "";
			string ErrMessage = ValidateResetKey(ResetKeyEnc, out ResetUserID);
			if (ErrMessage != "") return ErrorNodeIterator(ErrMessage);
			
   			//------------------------------
   			// Validation
 			//------------------------------
			if (string.IsNullOrWhiteSpace(NewPassword))
			{
				return ErrorNodeIterator("Please enter new password!");
			}

			if (NewPassword.Length < 8)
			{
				return ErrorNodeIterator("Password must be at least 8 characters !");
			}

			if (string.IsNullOrWhiteSpace(NewPasswordConfirm))
			{
				return ErrorNodeIterator("Please enter confirm new password!");
			}
			if (NewPassword != NewPasswordConfirm)
			{
				return ErrorNodeIterator("New password and repeat new password must be the same!");
			}
   			/*
			if (string.IsNullOrEmpty(OTPCode))
			{
				return ErrorNodeIterator("Please enter OTP Code!");
   			}*/
			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(ResetUserID);
			if (userInfo == null)
			{
				log.Info("Failed! User account not exists!");
				return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed! User account not exists!");
  			}

   			// Disable OTP
			//-----------------------------------------------
   			// Verify OTP
   			/*
			EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());

			rc.URL = string.Format("{0}Account/VerifyOTP?UserID={1}&OTPRefCode={2}&OTPCode={3}&UserOTPType={4}",
				URL, ResetUserID, userInfo.OTPReferenceNo, OTPCode , "ResetPassword");
		 	
			rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
			rc.RequestType = "application/xml";
			rc.ResponseType = "application/xml";

			log.Info("UserRequestResetPasswordSecAnswer => " + rc.URL);
		 
			rs = rc.SendRequest();
		 
			if (rs.State == RESTState.Success)
			{
 				//log.Debug("Password reset! " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserCode").Value);

				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
				log.Debug(nodeIterator.Current.SelectSingleNode("/AccountInfo/HasError").Value);
				if (nodeIterator.Current.SelectSingleNode("/AccountInfo/HasError").Value == "true")
				{		
					return ErrorNodeIterator("Invalid OTP!");
				}else
				{ 
				 	nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
				}
			}
			else
			{
				 log.Debug("Password reset Failed! Error:" + rs.Message);
  				 //nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
				 return ErrorNodeIterator("Password reset Failed! Invalid OTP!");
			}
   			*/
			//-----------------------------------------------

	 		/*
			Uniquemail.SingleSignOn.GenericResponse ValidPassword = SSOHelper.IsPasswordValid(SiteName, NewPassword, Email, FirstName, LastName, 0);
          	if (ValidPassword.HadErrors)
         	{
				return ErrorNodeIterator("Invalid password " + ValidPassword.Message);
			}
			*/

   			// userInfo.LoginPassword = NewPassword.MD5();
			int phType = 0;
			userInfo.LoginPassword = SSOHelper.PasswordHashing(userInfo.LoginName, NewPassword, ref phType);
        	userInfo.PasswordHashType = phType;

			var UpdatedUserInfo = SSOHelper.UpdateUser(userInfo);
			
	  }     
      catch (Exception ex)
      {
        strErrMessage = "Password reset Failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
		return ErrorNodeIterator(strErrMessage);
      }
      return nodeIterator;
    }


	public string ValidateResetKey(string ResetKeyEnc, out string ResetUserID)
	{
 		ResetUserID = "";
		string ErrMessage = "";

		if(string.IsNullOrEmpty(ResetKeyEnc))
		{
			return "Invalid reset key. Error(000)";
 		}

		ResetKeyEnc = ResetKeyEnc.Replace(" ", "+");

		string ResetKey = ResetKeyEnc.Decrypt("EasylistAwesome", "Easylist");
   			
		if (ResetKey.Split('|').Count() != 2)
		{
			return "Invalid reset key. Error(001)";
		}

		string ResetDTText = ResetKey.Split('|')[0];
	    ResetUserID = ResetKey.Split('|')[1];

        DateTime ResetDT = DateTime.Now;
        if (!DateTime.TryParseExact(ResetDTText, "yyyyMMddHHmmss", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out ResetDT))
        {
			return "Invalid reset key. Error(002)";
        }

        Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(ResetUserID);
		if (userInfo == null)
		{
			return "Invalid reset key. Error(003)";
		}
	
		return ErrMessage;
	}


	public class UserReset {
		public string UserName {get;set;}
		public string SecQuestion {get;set;}
		public string ErrorMessage {get;set;}
	}


	//=======================================================================================================================
	// Dealers
	//=======================================================================================================================

	public string GetDealerPageURL(string CompanyName, string State, string ActivationState, string SortOrder, string PageNo)
	{
		try
		{
			
			string URL = "/dealers";
			
			if (string.IsNullOrEmpty(CompanyName)) CompanyName = "";
			if (string.IsNullOrEmpty(State)) State = "";
			if (string.IsNullOrEmpty(ActivationState)) ActivationState = "";
			if (string.IsNullOrEmpty(SortOrder)) SortOrder = "";
			if (string.IsNullOrEmpty(PageNo)) PageNo = "";
			
			return string.Format(@"{0}?company-name={1}&company-active={2}&company-state={3}&SortOrder={4}&PageNo={5}&IsPostBack=true",
				URL, CompanyName, ActivationState, State, SortOrder, PageNo);
		}
		catch (Exception ex)
		{
			log.Error("GetDealerPageURL failed! Error:" + ex.ToString());
		}
		return "";
	} 


	public XPathNodeIterator GetActiveDealerList(string CompanyName, string State, string ActivateState, string PageNo, string SortOrder)
    {
		  XPathNodeIterator nodeIterator = null;
		  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		  try
		  {
   			// Default show empty list
   			if (State == "") return nodeIterator;
			if (State.ToUpper() == "ALL STATES") State = "";

			string [] Keywords = null;
			if (!string.IsNullOrEmpty(CompanyName)) Keywords = CompanyName.Split(' ');
	
			var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
			if(string.IsNullOrEmpty(UserID)) 
			{
			  log.Error("User ID not exists!"); 
			  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("User ID not exists!");
			  return nodeIterator;
			}
			if(!string.IsNullOrEmpty(ActivateState)) 
			{
				if (ActivateState.ToUpper() == "ALL") ActivateState = "";
			}

			
			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);
			
			if (userInfo == null)
			{ 
			  log.Error("User ID " + UserID + " account not exists!"); 
			  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("User ID " + UserID + " account not exists!");
			  return nodeIterator;
			}
	
			//****************************************************************************
			// Security (Second level check, first level check in xslt)
			//****************************************************************************
   			//if (!(userInfo.IsMemberOf("EasySales Admin") || userInfo.IsMemberOf("ESSalesRep"))){
			if (!IsAuthorized("EasySales Admin,ESSalesRep,ESSupport")){
			  log.Error("Unauthorized access for User ID " + UserID + " !"); 
			  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Unauthorized access for User ID " + UserID + " !");
			  return nodeIterator;
			}
			//****************************************************************************
				
			//log.Info("Keywords " + string.Join(",", Keywords));
			log.Info("State " + State);
			if (State.Trim() == "All States") State = "";
			int PageNumber = 1;
			if(!int.TryParse(PageNo, out PageNumber))
			{
	 			PageNumber = 1;
			}

			List<Uniquemail.SingleSignOn.User> DealersList = SSOHelper.FindUserType("Business", "", ActivateState, State, PageNumber, 10, SortOrder, Keywords);
			
			log.Info(DealersList.Count());
			// User should not manage own account to prevent user delete their own account.
	
			var DealerStaffListFilter = DealersList.Select(u => new 
				Uniquemail.SingleSignOn.User { 
					LoginName = u.LoginName,
					CompanyName = u.CompanyName,
					FirstName = u.FirstName,
					LastName = u.LastName,
					ContactPhone = u.ContactPhone,
					EmailAddress = u.EmailAddress,
					State = u.State,
					PostalCode = u.PostalCode,
					CityTown = u.CityTown,
					DateCreated = u.DateCreated,
					UserActivationState = u.UserActivationState
				}).ToList();
			
	
			 //log.Debug("EmpOf : " + EmpOf);
		     //log.Debug("DealerStaffListFilter =>" + DealerStaffListFilter.FirstOrDefault().ToPropertiesString());
	
			var DealerStaffListXML = DealerStaffListFilter.ToXml();
			
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(DealerStaffListXML);
		  }     
		  catch (Exception ex)
		  {
			log.Error("Read getting active dealer list! Error:" + ex.ToString());
		  }
		  return nodeIterator;
    }

	public XPathNodeIterator GetActiveDealerListCount(string CompanyName, string State, string ActivateState)
    {
		  XPathNodeIterator nodeIterator = null;
		  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		  try
		  {
   			// Default show empty list
   			if (State == "") return nodeIterator;
			if (State.ToUpper() == "ALL STATES") State = "";

			string [] Keywords = null;
			if (!string.IsNullOrEmpty(CompanyName)) Keywords = CompanyName.Split(' ');
	
			var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
			if(string.IsNullOrEmpty(UserID)) 
			{
			  log.Error("User ID not exists!"); 
			  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("User ID not exists!");
			  return nodeIterator;
			}
			if(!string.IsNullOrEmpty(ActivateState)) 
			{
				if (ActivateState.ToUpper() == "ALL") ActivateState = "";
			}

			
			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);
			
			if (userInfo == null)
			{ 
			  log.Error("User ID " + UserID + " account not exists!"); 
			  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("User ID " + UserID + " account not exists!");
			  return nodeIterator;
			}
	
			//****************************************************************************
			// Security (Second level check, first level check in xslt)
			//****************************************************************************
   			//if (!(userInfo.IsMemberOf("EasySales Admin") || userInfo.IsMemberOf("ESSalesRep"))){
			if (!IsAuthorized("EasySales Admin,ESSalesRep")){
			  log.Error("Unauthorized access for User ID " + UserID + " !"); 
			  nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Unauthorized access for User ID " + UserID + " !");
			  return nodeIterator;
			}
			//****************************************************************************
				
			if (State.Trim() == "All States") State = "";
			
			int DealersListCount = SSOHelper.FindUserTypeCount("Business", "", ActivateState, State, Keywords);
			
   			int TotalPages = Convert.ToInt32(Math.Ceiling((double)DealersListCount / 10));

			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(TotalPages.ToXml());
		  }     
		  catch (Exception ex)
		  {
			log.Error("Read getting active dealer list count! Error:" + ex.ToString());
		  }
		  return nodeIterator;
    }

 	//--------------------------------------------------------------------------------------------------------------
 	// Parent - Child relationship for Customer grouping
	//--------------------------------------------------------------------------------------------------------------

	public XPathNodeIterator GetCustomerParent(string LoginID)
	{
		XPathNodeIterator nodeIterator = null;
      	nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		string CustomerChildList = "";
		string strErrMessage = "";
		try
		{	
			IRepository repo = RepositorySetup.Setup();

			var CustInfo = repo.Single<Users>(u => u.UserName == LoginID);

			if (CustInfo != null)
			{
				var ParentInfo = repo.Single<Users>(u => u._id == CustInfo.ParentUserID);
				if (ParentInfo != null)
				{
 					var ParentInfoXML = ParentInfo.ToXml();
        			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(ParentInfoXML);
				}else
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("No Parent found!");
				}
			}

		}	
		catch (Exception ex)
      	{
	        strErrMessage = "GetCustomerParent failed! Error : " + ex.ToString();
    	    log.Error(strErrMessage);
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator(strErrMessage);
      	}
		return nodeIterator;
 	}

	public XPathNodeIterator GetCustomerInfo(string LoginID)
	{
		XPathNodeIterator nodeIterator = null;
      	nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		string CustomerChildList = "";
		string strErrMessage = "";
		try
		{	
			IRepository repo = RepositorySetup.Setup();

			var CustInfo = repo.Single<Users>(u => u.UserName == LoginID);

			if (CustInfo != null)
			{
				var CustInfoXML = CustInfo.ToXml();
        		nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(CustInfoXML);
			}else
			{
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("No customer info found!");
			}

		}	
		catch (Exception ex)
      	{
	        strErrMessage = "GetCustomerInfo failed! Error : " + ex.ToString();
    	    log.Error(strErrMessage);
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator(strErrMessage);
      	}
		return nodeIterator;
 	}

 	public XPathNodeIterator GetCustomerChildList(string LoginID)
	{
		XPathNodeIterator nodeIterator = null;
      	nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		string CustomerChildList = "";
		string strErrMessage = "";
		try
		{	
			IRepository repo = RepositorySetup.Setup();

			var ParentCustInfo = repo.Single<Users>(u => u.UserName == LoginID);

			if (ParentCustInfo != null)
			{
				var AllCustChild = repo.All<Users>(u => u.ParentUserID == ParentCustInfo._id)
					.Select( u =>
						new CustUserInfo { UserID = u.UserName, UserName = u.DealerName}
					).ToList();

 				var AllCustChildXML = AllCustChild.ToXml();
        		nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(AllCustChildXML);
			}

		}	
		catch (Exception ex)
      	{
	        strErrMessage = "GetCustomerChildList failed! Error : " + ex.ToString();
    	    log.Error(strErrMessage);
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator(strErrMessage);
      	}
		return nodeIterator;
 	}

	//==========================================================================================
 	// Privacy and Safety settings 
	//==========================================================================================

	public string UpdatePrivacyNSafety()
	{
		string ErrMessage = "";
		try
      	{
			IRepository repo = RepositorySetup.Setup();

			var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
			
			//-----------------------
			// Private User
			//-----------------------
			var ContactInfoSetting = HTTPFormHelpers.GetString("ContactInfoSetting");
			var DisplayMobileOnAds = HTTPFormHelpers.GetBool("DisplayMobileOnAds");
			var DisplayNameOnAds = HTTPFormHelpers.GetBool("DisplayNameOnAds");
			var DisplayAddSettings = HTTPFormHelpers.GetString("DisplayAddSettings");
			
			var RetailContactMobile = HTTPFormHelpers.GetString("RetailContactMobile");
			var RetailFirstName = HTTPFormHelpers.GetString("RetailFirstName");
			var RetailEmail = HTTPFormHelpers.GetString("RetailEmail");

			bool DisplayEmailOnAds = HTTPFormHelpers.GetBool("DisplayEmailOnAds");
			string DisplayEmailSettings = HTTPFormHelpers.GetString("DisplayEmailSettings");

			//-----------------------
   			// Commercial user
			//-----------------------
			var DisplayPhoneOnAds = HTTPFormHelpers.GetBool("DisplayPhoneOnAds");
			var DisplayFaxOnAds = HTTPFormHelpers.GetBool("DisplayFaxOnAds");
	
			var BusinessPhoneNo = HTTPFormHelpers.GetString("BusinessPhoneNo");
			var BusinessFaxNo = HTTPFormHelpers.GetString("BusinessFaxNo");
			var BusinessContactMobile = HTTPFormHelpers.GetString("BusinessContactMobile");
			var BusinessName = HTTPFormHelpers.GetString("BusinessName");
			var BusinessEmail = HTTPFormHelpers.GetString("BusinessEmail");

			var AddressLine1 = HTTPFormHelpers.GetString("AddressLine1");
			var AddressLine2 = HTTPFormHelpers.GetString("AddressLine2");

			if (AddressLine1.Length > 200) AddressLine1 = AddressLine1.Substring(0,200);
			if (AddressLine2.Length > 200) AddressLine2 = AddressLine2.Substring(0,200);
			
			var DisplayAddLocMap = HTTPFormHelpers.GetBool("DisplayAddLocMap");

			var DisplayWebsiteOnAds = HTTPFormHelpers.GetBool("DisplayWebsiteOnAds");
			var DisplayWebsiteAdd = HTTPFormHelpers.GetString("DisplayWebsiteAdd");

			var DisplaySumInfoOnAds = HTTPFormHelpers.GetBool("DisplaySumInfoOnAds");
			var DisplaySumInfo = HTTPFormHelpers.GetString("DisplaySumInfo-textonly");
			var DisplaySumInfoWYSIWYG = HTTPFormHelpers.GetString("DisplaySumInfo");

			var DisplayCompLogoOnAds = HTTPFormHelpers.GetBool("DisplayCompLogoOnAds");

			var DisplayCompABNACNOnAds = HTTPFormHelpers.GetBool("DisplayCompABNACNOnAds");
			var Company_TAC_Type = HTTPFormHelpers.GetString("Company_TAC_Type");	
  			var Company_TAC_No = HTTPFormHelpers.GetString("Company_TAC_No");

			var DisplayCompLicenseOnAds = HTTPFormHelpers.GetBool("DisplayCompLicenseOnAds");
			var CompDealerLicense = HTTPFormHelpers.GetString("CompDealerLicense");	

			var DisplayTradingHourOnAds = HTTPFormHelpers.GetBool("DisplayTradingHourOnAds");
			var DisplayTradingHourFrom = HTTPFormHelpers.GetString("DisplayTradingHourFrom");
			var DisplayTradingHourTo = HTTPFormHelpers.GetString("DisplayTradingHourTo");

			Users MongoUserInfo = new Users();
			Uniquemail.SingleSignOn.User SQLUserInfo = new Uniquemail.SingleSignOn.User();
			Account AccUserInfo = new Account();

			//--------------------------------------------------------------------------
			// Validation
			//--------------------------------------------------------------------------
			ErrMessage = ReadUserAccount(UserID, out MongoUserInfo, out SQLUserInfo, out AccUserInfo);
			if (!string.IsNullOrEmpty(ErrMessage)) return ErrMessage;		

			string LocRegion; string LocState; int LocPostcodeNo; 
			ErrMessage = getLocInfo(HTTPFormHelpers.GetString("listing-location"), out LocRegion, out LocState, out LocPostcodeNo);
			if (!string.IsNullOrEmpty(ErrMessage)) return ErrMessage + ";" + LocRegion + ";" + LocState + ";" + LocPostcodeNo;	
			
			if (MongoUserInfo != null)
			{
				//--------------------------------------------------------------------------
 				// Update Mongo DB
				//--------------------------------------------------------------------------
				if (MongoUserInfo.UserType == "Private")
				{
					MongoUserInfo.ContactInfoSetting = ContactInfoSetting;

	 				MongoUserInfo.DisplayMobileOnAds = DisplayMobileOnAds;
					MongoUserInfo.DisplayMobileNo = RetailContactMobile;
 					MongoUserInfo.DealerPhone = RetailContactMobile;			// Should be separate setting

	 				MongoUserInfo.DisplayNameOnAds = DisplayNameOnAds;
					MongoUserInfo.DisplayName = RetailFirstName;
					
					MongoUserInfo.DisplayAddSettings = DisplayAddSettings;

					// Address info
					MongoUserInfo.DisplayAddLine1 = AddressLine1.Trim();
					MongoUserInfo.DisplayAddLine2 = AddressLine2.Trim();
					MongoUserInfo.DisplayAddCountry = "AU";
					MongoUserInfo.DisplayAddPostalCode = LocPostcodeNo.ToString();
					MongoUserInfo.DisplayAddStateProvince = LocState;
					MongoUserInfo.DisplayAddCityTown = LocRegion;
					
					MongoUserInfo.DisplayEmailOnAds = DisplayEmailOnAds;
					MongoUserInfo.DisplayEmailSettings = DisplayEmailSettings;
  					
					//MongoUserInfo.EnquiryFromEmailAddress = RetailEmail;
					MongoUserInfo.DisplayEmail = RetailEmail;
  					
					AccUserInfo.Display_ContactMobile = RetailContactMobile;
					AccUserInfo.Display_CompanyName = RetailFirstName;

					AccUserInfo.Display_Address1 = AddressLine1;
					AccUserInfo.Display_Address2 = AddressLine2;
					AccUserInfo.Display_CityTown = LocRegion;
					AccUserInfo.Display_StateProvince = LocState;
					AccUserInfo.Display_PostalCode = LocPostcodeNo.ToString();
					AccUserInfo.Display_Country = "AU";

					AccUserInfo.Display_PrimaryEmail = RetailEmail;
				}
				else
				{
					MongoUserInfo.ContactInfoSetting = ContactInfoSetting;

					MongoUserInfo.DisplayPhoneOnAds = DisplayPhoneOnAds;
					MongoUserInfo.DisplayPhoneNo = BusinessPhoneNo;
					MongoUserInfo.DealerDisplayPhoneNo = BusinessPhoneNo;
				
					//MongoUserInfo.DealerPhone = BusinessPhoneNo;	// This is Sales Lead Phone, cannot overwrite!
					//MongoUserInfo.EnquiryFromEmailAddress 		//This is sales lead email, cannot overwrite!

					MongoUserInfo.DisplayFaxOnAds = DisplayFaxOnAds;
					MongoUserInfo.DisplayFaxNo = BusinessFaxNo;

					MongoUserInfo.DisplayMobileOnAds = DisplayMobileOnAds;
					MongoUserInfo.DisplayMobileNo = BusinessContactMobile;

					MongoUserInfo.DisplayNameOnAds = DisplayNameOnAds;
					MongoUserInfo.DisplayName = BusinessName;
					MongoUserInfo.DealerName = BusinessName;

					MongoUserInfo.DisplayAddSettings = DisplayAddSettings;
					
					// Address info
					MongoUserInfo.DisplayAddLine1 = AddressLine1.Trim();
					MongoUserInfo.DisplayAddLine2 = AddressLine2.Trim();
					MongoUserInfo.DisplayAddCountry = "AU";
					MongoUserInfo.DisplayAddPostalCode = LocPostcodeNo.ToString();
					MongoUserInfo.DisplayAddStateProvince = LocState;
					MongoUserInfo.DisplayAddCityTown = LocRegion;

					MongoUserInfo.DisplayAddLocMap = DisplayAddLocMap;
	
					MongoUserInfo.DisplayEmailOnAds = DisplayEmailOnAds;
					MongoUserInfo.DisplayEmailSettings = DisplayEmailSettings;
					MongoUserInfo.DisplayEmail = BusinessEmail;

					MongoUserInfo.DisplayWebsiteOnAds = DisplayWebsiteOnAds;
					MongoUserInfo.DisplayWebsite = DisplayWebsiteAdd;

					MongoUserInfo.DisplaySumInfoOnAds = DisplaySumInfoOnAds;
					MongoUserInfo.DisplaySumInfo = DisplaySumInfo;
					MongoUserInfo.DisplaySumInfoWYSIWYG = DisplaySumInfoWYSIWYG;

					MongoUserInfo.DisplayCompLogoOnAds = DisplayCompLogoOnAds;

					MongoUserInfo.DisplayCompABNACNOnAds = DisplayCompABNACNOnAds;
					MongoUserInfo.DisplayCompTACNo = Company_TAC_No;
  					MongoUserInfo.DisplayCompTACType = Company_TAC_Type;

					MongoUserInfo.DisplayCompLicenseOnAds = DisplayCompLicenseOnAds;
					MongoUserInfo.DealerLicense = CompDealerLicense;

					MongoUserInfo.DisplayTradingHourOnAds = DisplayTradingHourOnAds;
					MongoUserInfo.DisplayTradingHourFrom = DisplayTradingHourFrom;
					MongoUserInfo.DisplayTradingHourTo = DisplayTradingHourTo;

  					// SQL DB
					// USER ACCOUNT for commercial user is for billing info

  					// Account DB
					AccUserInfo.Display_ContactPhone = BusinessPhoneNo;
					AccUserInfo.ContactFax = BusinessFaxNo;
					AccUserInfo.Display_ContactMobile = BusinessContactMobile;
					AccUserInfo.Display_CompanyName = BusinessName;

					AccUserInfo.Display_Address1 = AddressLine1;
					AccUserInfo.Display_Address2 = AddressLine2;
					AccUserInfo.Display_CityTown = LocRegion;
					AccUserInfo.Display_StateProvince = LocState;
					AccUserInfo.Display_PostalCode = LocPostcodeNo.ToString();
					AccUserInfo.Display_Country = "AU";

					AccUserInfo.Display_PrimaryEmail = BusinessEmail;

					AccUserInfo.Company_TAC_No = Company_TAC_No;
					AccUserInfo.Company_TAC_Type = Company_TAC_Type;

				}
				repo.Save<Users>(MongoUserInfo);

				//--------------------------------------------------------------------------
 				// Update SQL DB
				//--------------------------------------------------------------------------
				
 				var UpdatedUserInfo = SSOHelper.UpdateUser(SQLUserInfo);

				//--------------------------------------------------------------------------
 				// Update AccountsDB
				//--------------------------------------------------------------------------
				
				AccUserInfo.Save();

 				return ""; //Success
			}
		}
		catch (Exception ex)
		{
			ErrMessage = "Update failed! Error " + ex.ToString();
		}
		return ErrMessage;
	}



	public XPathNodeIterator GetMongoUserAccount(string LoginID = "")
    { 
      XPathNodeIterator nodeIterator = null;
      nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
      string ErrMessage = "";
      try
      {
		string UserID = "";
		string UserCode =  "";

		UserID =  HttpContext.Current.Session["easylist-username"].ToString();
		UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
	
		Users MongoUserInfo = new Users();
		Uniquemail.SingleSignOn.User SQLUserInfo = new Uniquemail.SingleSignOn.User();
		Account AccUserInfo = new Account();
		ErrMessage = ReadUserAccount(UserID, out MongoUserInfo, out SQLUserInfo, out AccUserInfo);

		if (MongoUserInfo != null)
		{
			if (!String.IsNullOrEmpty(MongoUserInfo.DisplayCompLogo))
			{
  				var CompanyLogoXML = Utils.XMLToObject<ImageInfo>(MongoUserInfo.DisplayCompLogo);
				MongoUserInfo.DisplayCompLogo = CompanyLogoXML.Url;
			}

        	var MongoUserInfoXML = MongoUserInfo.ToXml();
        	nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(MongoUserInfoXML);
		}
		else
		{
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator(ErrMessage);
		}
      }     
      catch (Exception ex)
      {
        ErrMessage = "GetDealerAccount failed! Error : " + ex.ToString();
        log.Error(ErrMessage);
      }
      return nodeIterator;
    }

	public string ReadUserAccount(string UserID, 
		out Users MongoUserInfo, 
		out Uniquemail.SingleSignOn.User SQLUserInfo,
		out Account AccUserInfo	)
	{
		IRepository repo = RepositorySetup.Setup();

		MongoUserInfo = new Users();
		SQLUserInfo = new Uniquemail.SingleSignOn.User();
		AccUserInfo = new Account();

		string ReadErr = "";

		var userInfo = SSOHelper.GetUser(UserID);
	
		if (userInfo.UserType == "Private")
		{
			MongoUserInfo = repo.Single<Users>(u => u.UserCode == userInfo.UserCode);
			if (MongoUserInfo == null)
			{
				ReadErr = "Retail user record not found!";
				return ReadErr;
			}

			SQLUserInfo = SSOHelper.GetUser(UserID);
			AccUserInfo = AccountHelper.GetAccount(UserID);
		}
		else
		{
			// Find root employee account info
			long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
			if (MainEmpID != 0)
			{
				var userMainInfo = SSOHelper.GetUser(MainEmpID);
				if (userMainInfo != null)
				{
					// Check if EmployeeOf is null, then check if have binding to account
					if ((userMainInfo.EmployeeOf == null) && (!string.IsNullOrEmpty(userMainInfo.LoginName)))
					{	
   						//LoginID = userMainInfo.LoginName;

						MongoUserInfo = repo.Single<Users>(u => u.UserName == userMainInfo.LoginName);
						SQLUserInfo = SSOHelper.GetUser(userMainInfo.LoginName);
						AccUserInfo = AccountHelper.GetAccount(userMainInfo.LoginName);
					}else
					{
						ReadErr = "Master account record not found!";
						return ReadErr;
					}	
				}
				else
				{
					ReadErr = "Master account record not found!";
					return ReadErr;
				}
		   }
		   else
		   {
				ReadErr = "Master account record not found!";
				return ReadErr;
		   }
		}
		return ReadErr;
	}

 	public XPathNodeIterator GetDealerAccount(string LoginID = "", bool IsProfileMtn = false)
    { 
      XPathNodeIterator nodeIterator = null;
      nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
      string strErrMessage = "";
      try
      {
		string UserID = "";
		string UserCode =  "";

        if (HttpContext.Current.Session["easylist-usercode"] != null)
        {
			UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
		}

  		// User maintain own user account
		if (IsProfileMtn && !IsRetailUser()){
			UserID =  HttpContext.Current.Session["easylist-username"].ToString();

   			// Find root employee account info
			long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
            if (MainEmpID != 0)
            {
				Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(MainEmpID);
				 if (userInfo != null)
				 {
					  // Check if EmployeeOf is null, then check if have binding to account
					  if ((userInfo.EmployeeOf == null) && (!string.IsNullOrEmpty(userInfo.LoginName)))
					  {	
  							LoginID = userInfo.LoginName;
					  }else
					  {
							log.Error("Master account record not found!");
            				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Master account not found!");
            				return nodeIterator;
					  }	
				}
				else
				{
					log.Error("Master account record not found!");
            		nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Master account not found!");
            		return nodeIterator;
				}
			}
			else
			{
				log.Error("Master account not found!");
            	nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Master account not found!");
            	return nodeIterator;
			}
		}
  		log.Info("LoginID => " + LoginID);
        // Staff maintenance page
        if (string.IsNullOrEmpty(LoginID))
        {
            log.Error("Account login ID is empty!");
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Account login ID is empty!");
            return nodeIterator;
        }
		
        if (!IsProfileMtn && LoginID.ToUpper() == UserID.ToUpper())
        {
            log.Error("Unauthorized access to own account maintenanace!");
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Unauthorized access to own account maintenanace!");
            return nodeIterator;
        }

        Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(LoginID);
        
        if (StaffInfo == null)
        {
        	log.Error("No user found for login ID " + LoginID + "!");
          	nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("No user found for login ID " + LoginID + "!");
          	return nodeIterator;
        }

 		//----------------------------------------------------------------------------
		// Generate back Activation Link, for sales rep/staff do own activation
		//----------------------------------------------------------------------------
		if (StaffInfo.UserActivationTime != null)
 		{
			string ActivationLink = GenerateActivationURL((DateTime)StaffInfo.UserActivationTime, LoginID);
  			StaffInfo.LoginMethod = ActivationLink; // Temporay use LoginMethod to output Activation link in XSLT
		}
		//----------------------------------------------------------------------------

        var StaffInfoXML = StaffInfo.ToXml();
  		//log.Info(StaffInfo.ToXml());
        nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(StaffInfoXML);
      }     
      catch (Exception ex)
      {
        strErrMessage = "GetDealerAccount failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return nodeIterator;
    }

	public string GenerateActivationURL(DateTime UserActivationTime, string LoginID)
	{
  		//DateTime UserActivationTime = DateTime.Now;
		string ActivationURL = "https://dashboard.easylist.com.au/action/activation.aspx";

		string ActivationKey = string.Format("{0}|{1}", UserActivationTime.ToString("yyyyMMddHHmmss"), LoginID);
		string ActivationKeyEnc = ActivationKey.Encrypt("EasylistAwesome", "Easylist");
		
		string ActivationLink = string.Format("{0}?ActivationKey={1}", ActivationURL, ActivationKeyEnc);
		log.Info("ActivationLink => " + ActivationLink);
			
		return ActivationLink;
	}

	public string ActivateDealerAccount(string LoginID)
    {
		string ErrMsg = "";
		try
		{
   			// Get current sales rep ID
			var UserID =  HttpContext.Current.Session["easylist-username"].ToString();

   			// Confirm update dealer account before activation
			string strErrMessage = UpdateDealerAccount(LoginID, false, true);

			if (strErrMessage != "")
			{	
				ErrMsg = "Failed! " + strErrMessage;
				log.Error(ErrMsg);
				return ErrMsg;
			}

 			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(LoginID);
			if (userInfo != null)
			{
				if (!string.IsNullOrEmpty(userInfo.UserActivationState) && userInfo.UserActivationState.ToUpper() == "ACTIVATED")
				{	
					ErrMsg = "Login account " + LoginID + " is already activated!";
					log.Error(ErrMsg);
					return ErrMsg;
				}

				DateTime UserActivationTime = DateTime.Now;

 				//string ActivationKey = string.Format("{0}|{1}", UserActivationTime.ToString("yyyyMMddHHmmss"), LoginID);
 				//string ActivationKeyEnc = ActivationKey.Encrypt("EasylistAwesome", "Easylist");
  				//log.Info("ActivationKeyEnc => " + ActivationKeyEnc);
				
				string ActivationLink = GenerateActivationURL(UserActivationTime, LoginID);
 				//string ActivationLink = string.Format("{0}?ActivationKey={1}", ActivationURL, ActivationKeyEnc);
			
				userInfo.UserActivationState = "PendingActivation";
				userInfo.UserActivationTime = UserActivationTime;
				userInfo.UserActivationBy = UserID;
			
				var UpdatedUserInfo = SSOHelper.UpdateUser(userInfo);

				// TODO: Send to EMAIL
				log.Info("Sending Email for dealer " + LoginID + " , email address: " + userInfo.EmailAddress);

				/*EmailJob emailJob = new EmailJob()
				{
					Sender = "support@easylist.com.au",
					Recipient = userInfo.EmailAddress,
					Subject = "Tradingpost account activation (" + LoginID + ")",
					TemplateName = @"\email\activation\TradingPostActivation.vm"
				};
	
				emailJob.NameValues["UserID"] = LoginID;
				emailJob.NameValues["FirstName"] = UpdatedUserInfo.FirstName;
				emailJob.NameValues["LastName"] = UpdatedUserInfo.LastName;
				emailJob.NameValues["activationUrl"] = ActivationLink;
	
				 using (IEasyListQueueClient client = Core.CreateClient("/messaging/email"))
				{
					client.Post(Utils.ObjectToJSON(emailJob));
				}*/

				SendEmailRequest sendEmailRequest = new SendEmailRequest();
				sendEmailRequest.NameValues.Add("UserID", LoginID);
				sendEmailRequest.NameValues.Add("FirstName", UpdatedUserInfo.FirstName);
				sendEmailRequest.NameValues.Add("LastName", UpdatedUserInfo.LastName);
				sendEmailRequest.NameValues.Add("activationUrl", ActivationLink);
				sendEmailRequest.Priority = MessagingPriority.Normal;
				sendEmailRequest.TemplateName = "TradingpostActivation";
				sendEmailRequest.To = userInfo.EmailAddress;
				sendEmailRequest.UserRef = "ActivateDealerAccount";
	
				SendEmailResponse response = EasyList.Queue.Helpers.HttpInvocation.PostRequest<SendEmailResponse>(
						string.Format("{0}://{1}/MessagingImpl.svc/SendEmail", Protocol, Host),
						Secret, /* ********** A valid key with valid ACL ********** */
						sendEmailRequest);
				
				if (response.ResponseCode != ResponseCodeType.OK)
				{
					ErrMsg = "Failed to send activation email!";
					log.Error(ErrMsg);
					return ErrMsg;
				}

 				// Send SMS
				SendSMSTempPassword(LoginID);
			}
		}     
		catch (Exception ex)
		{
			ErrMsg = "Account activation failed!";
			log.Error("Account activation failed! Error : " + ex.ToString());
		}
		return ErrMsg;
	}


    public string UpdateDealerAccount(string LoginID, bool IsProfileMtn = false, bool ToActivateAcc = false)
    { 

	  IRepository repo = RepositorySetup.Setup();

      string strErrMessage = "";
	  bool CheckRequired = false;
		
      try
      {
        var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();

        if(string.IsNullOrEmpty(UserID)) 
        {
          strErrMessage = "User ID not exists!";
          log.Error(strErrMessage);
          return strErrMessage;
        }

		// User maintain own user account
		if (IsProfileMtn) {

			// Find root employee account info
			long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
            if (MainEmpID != 0)
            {
				Uniquemail.SingleSignOn.User ExUserInfo = SSOHelper.GetUser(MainEmpID);
				 if (ExUserInfo != null)
				 {
					  // Check if EmployeeOf is null, then check if have binding to account
					  if ((ExUserInfo.EmployeeOf == null) && (!string.IsNullOrEmpty(ExUserInfo.LoginName)))
					  {	
  							LoginID = ExUserInfo.LoginName;
					  }else
					  {
						return "Master account record not found!";
					  }	
				}
				else
				{
					return "Master account record not found!";
				}
			}
			else
			{
            	return "Master account not found!";
			}

 		   //LoginID = UserID;
		}
		
        Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);

		Uniquemail.SingleSignOn.User TempUserInfo = SSOHelper.GetUser(LoginID);
		if (ToActivateAcc || TempUserInfo.UserActivationState != "NotActivated")
		{
			CheckRequired  = true;
		}

  		/*log.Info("ToActivateAcc => " + ToActivateAcc.ToString());
		log.Info("userInfo.UserActivationState => " + userInfo.UserActivationState);
  		log.Info("CheckRequired => " + CheckRequired);*/

        log.Info("UpdateDealerAccount LoginID => "+LoginID);

		string LoginEmail = "";
		string FirstName = "";
		string LastName = "";
		string LoginMobileNo = "";
		if (!IsProfileMtn)
		{
			FirstName = HTTPFormHelpers.GetString("FirstName");
			LastName = HTTPFormHelpers.GetString("LastName");
			LoginEmail = HTTPFormHelpers.GetString("LoginEmail");
			LoginMobileNo = HTTPFormHelpers.GetString("LoginMobileNo");
	    }

		var CompanyName = HTTPFormHelpers.GetString("CompanyName");
        var CompanyRegistrationType = HTTPFormHelpers.GetString("CompanyRegistrationType");
        var CompanyRegistrationNo = HTTPFormHelpers.GetString("CompanyRegistrationNo");
		var CompanyDealerLicense = HTTPFormHelpers.GetString("CompanyDealerLicense");
 		
		var DisplayCompanyName = HTTPFormHelpers.GetString("DisplayCompanyName");
        var DisplayPhoneNo = HTTPFormHelpers.GetString("DisplayPhoneNo");
		var DisplayEmail = HTTPFormHelpers.GetString("DisplayEmail");
  		//var DisplayMapCode = HTTPFormHelpers.GetString("DisplayMapCode");
		var DisplayAddressLine1 = HTTPFormHelpers.GetString("DisplayAddressLine1");
		var DisplayAddressLine2 = HTTPFormHelpers.GetString("DisplayAddressLine2");

		var DisplayCountryCode = HTTPFormHelpers.GetString("DisplayCountryCode");
        var DisplayRegionID = HTTPFormHelpers.GetIntNotNull("DisplayRegionID");
        var DisplayRegionName = HTTPFormHelpers.GetString("DisplayRegionName");
        var DisplayPostalcode = HTTPFormHelpers.GetString("DisplayPostalcode");
		var DisplayDistrict = HTTPFormHelpers.GetString("DisplayDistrict");
        
		var BillingContactName = HTTPFormHelpers.GetString("BillingContactName");
		var BillingMobileNo = HTTPFormHelpers.GetString("BillingMobileNo");
		var BillingPhoneNo = HTTPFormHelpers.GetString("BillingPhoneNo");
		var BillingContactPrimaryEmail = HTTPFormHelpers.GetString("BillingContactPrimaryEmail");
		var BillingContactSecondaryEmail = HTTPFormHelpers.GetString("BillingContactSecondaryEmail");
		var BillingAddressLine1 = HTTPFormHelpers.GetString("BillingAddressLine1");
		var BillingAddressLine2 = HTTPFormHelpers.GetString("BillingAddressLine2");
		
		var BillingCountryCode = HTTPFormHelpers.GetString("BillingCountryCode");
        var BillingRegionID = HTTPFormHelpers.GetIntNotNull("BillingRegionID");
        var BillingRegionName = HTTPFormHelpers.GetString("BillingRegionName");
        var BillingPostalcode = HTTPFormHelpers.GetString("BillingPostalcode");
		var BillingDistrict = HTTPFormHelpers.GetString("BillingDistrict");

  		var LeadsNotificationBy = HTTPFormHelpers.GetString("LeadsNotificationBy");
		var LeadsEmail = HTTPFormHelpers.GetString("LeadsEmail");
		var LeadsPhoneNo = HTTPFormHelpers.GetString("LeadsPhoneNo");

		var CustomerChildList = HTTPFormHelpers.GetString("CustomerChild");
		var LeadSetting = HTTPFormHelpers.GetString("LeadSetting");

		var PaymentMethod = HTTPFormHelpers.GetString("payment-method");
		var BillingPfr = HTTPFormHelpers.GetString("billing-preference");
		var BillingPfrOpt1 = HTTPFormHelpers.GetString("billing-preference-promotion-1");
		var BillingPfrOpt2a = HTTPFormHelpers.GetString("billing-preference-promotion-2a");
		var BillingPfrOpt2b = HTTPFormHelpers.GetString("billing-preference-promotion-2b");

		log.Info("BillingPfrOpt2a => " + BillingPfrOpt2a);
		log.Info("BillingPfrOpt2a => " + BillingPfrOpt2b);

  		bool ResetCC = false;
		string ccType = "";
		string ccNo = "";
		string ccName = "";
		string ccMonth = "";
		string ccYear = "";
		string ccCvv2 = "";

		if (!IsProfileMtn && PaymentMethod !="BPay")
		{
			ccNo = HTTPFormHelpers.GetString("ccNo");
			if (!string.IsNullOrEmpty(ccNo))
			{
				ResetCC = true;
			}
			log.Info("ccNo => " + ccNo);
			log.Info("ResetCC => " + ResetCC);
			if (ResetCC)
			{
				ccType = HTTPFormHelpers.GetString("ccType");
				ccName = HTTPFormHelpers.GetString("ccName");
				ccMonth = HTTPFormHelpers.GetString("ccMonth");
				ccYear = HTTPFormHelpers.GetString("ccYear");
				ccCvv2 = HTTPFormHelpers.GetString("ccCvv2");
			}
		}
        //-------------------------------------------------------------------------------
        // Validation
        //-------------------------------------------------------------------------------
        if (userInfo == null){  return "Your account with Login ID " + UserID + " not exists!";  }

		if (!IsProfileMtn)
		{
        	if (string.IsNullOrEmpty(LoginID)){ return "Login ID is required field!"; }

			if (CheckRequired)
			{
				if (string.IsNullOrEmpty(LoginEmail)){ return "Login Email is required field!"; }
				if (string.IsNullOrEmpty(LoginMobileNo)){ return "Login Mobile No is required field!"; }
			}
		}
		
  		/**********************
		if (string.IsNullOrEmpty(CompanyName)){ return "Company name is required field!"; }
		if (string.IsNullOrEmpty(CompanyRegistrationType)){ return "Company registration type is required field!"; }
		if (string.IsNullOrEmpty(CompanyRegistrationNo)){ return "Company registration No is required field!"; }
		if (string.IsNullOrEmpty(CompanyDealerLicense)){ return "Company  dealer license is required field!"; }
		**********************/
  	
  		//---------------------------------------------------------------------------------------------
  		// Regex checking
		//---------------------------------------------------------------------------------------------
		Match match = null;
		string PhoneRx = @"^(?=.*04)((?:\s*\d\s*)){10}$";
 		//string EmailRx = @"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$";
		string EmailRx = @"^([\w\.\-]+)@(.*)((\.(\w){2,3})+)$";
		
		/**********************
		if (!string.IsNullOrEmpty(LoginEmail))
		{
			match = Regex.Match(LoginEmail, EmailRx);
			if (!match.Success) return "Please enter valid Login Email!";
		}
		if (!string.IsNullOrEmpty(BillingContactPrimaryEmail))
		{
			match = Regex.Match(BillingContactPrimaryEmail, EmailRx);
			if (!match.Success) return "Please enter valid Primary Email!";
		}
		if (!string.IsNullOrEmpty(BillingContactSecondaryEmail))
		{
			match = Regex.Match(BillingContactSecondaryEmail, EmailRx);
			if (!match.Success) return "Please enter valid Secondary Email!";
		}
  		**********************/

	   	if (!string.IsNullOrEmpty(LoginMobileNo))
   		{
			match = Regex.Match(LoginMobileNo, PhoneRx);
			if (!match.Success) return "Please enter valid login mobile no!";
   		}
  
		if (!string.IsNullOrEmpty(BillingMobileNo))
		{
			match = Regex.Match(BillingMobileNo, PhoneRx);
			if (!match.Success) return "Please enter valid biling mobile no!";
		}
		
		if (!IsProfileMtn)
		{
			if (!string.IsNullOrEmpty(LeadsEmail))
			{
				string[] LeadsEmailArray = LeadsEmail.Split(',');
	 
				int e = 0;
				foreach (string lEmail in LeadsEmailArray)
				{
					e++;
					if (!string.IsNullOrEmpty(lEmail))
					{
						match = Regex.Match(lEmail, EmailRx);
						if (!match.Success) return "Please enter valid lead email address for no " + e + "!";
					}
				}
			}
	
			if (!string.IsNullOrEmpty(LeadsPhoneNo))
			{
				string[] LeadsPhoneNoArray = LeadsPhoneNo.Split(',');
	 
				int p = 0;
				foreach (string lPhoneNo in LeadsPhoneNoArray)
				{
					p++;
					if (!string.IsNullOrEmpty(lPhoneNo))
					{
						match = Regex.Match(lPhoneNo, PhoneRx);
						if (!match.Success) return "Please enter valid lead mobile number for no " + p + "!";
					}
				}
			}
		}

		//--------------------------------------------------------------	
 		// Customer child list
		//--------------------------------------------------------------
 		bool IsParent = false;
		Users ParentCustInfo = new Users();
		string[] CustomerChildListArray = null;

		if (!IsProfileMtn)
		{
			ParentCustInfo = repo.Single<Users>(u => u.UserName == LoginID);
			if (ParentCustInfo != null)
			{
				if (String.IsNullOrEmpty(ParentCustInfo.ParentUserID))
					IsParent = true;
			}
			
			if (!string.IsNullOrEmpty(CustomerChildList))
			{
				// Check if current account already child to other customer
				if (!IsParent)
				{	
					var TempCustInfo = repo.Single<Users>(u => u._id == ParentCustInfo.ParentUserID);
					return "This account is already under customer group " + TempCustInfo.DealerName ;
				}
	
				// Validate each dealer
				CustomerChildListArray = CustomerChildList.Split(',');
				foreach (string custchild in CustomerChildListArray)
				{
					if (LoginID.ToUpper() == custchild.ToUpper())
					{
						return "Not allow to bind to own user account!";
					}
	
					var CustInfo = repo.Single<Users>(u => u.UserName == custchild);
					if (CustInfo == null)	
					{
						return "Invalid customer " + custchild;
					}
					else
					{
						if (CustInfo.ParentUserID != null && CustInfo.ParentUserID != ParentCustInfo._id)
						{
							return "Customer " + custchild + " already bind to other customer group!";
						}
					}
				}
			}
		}
		//--------------------------------------------------------------	


  		//-------------------------------	
 		// Billing Preference
		//-------------------------------	
		if (!IsProfileMtn)
		{
   			/*if (string.IsNullOrEmpty(BillingPfr))
			{
				return "Please choose one of the billing preference!";
			}
			
			if (BillingPfr.ToUpper() =="ADVANCE")
			{
				if (string.IsNullOrEmpty(BillingPfrOpt2a))
					return "Please choose one of the bonus 1!";
	
				if (string.IsNullOrEmpty(BillingPfrOpt2b))
					return "Please choose one of the bonus 2!";
	
 				//if (BillingPfrOpt2a == BillingPfrOpt2b)
 				//return "Please choose different option for bonus 2!";
			}else
			{
				if (string.IsNullOrEmpty(BillingPfrOpt1))
					return "Please choose one of the bonus!";
   			}*/
		}

		if (!IsProfileMtn && ResetCC)
		{
			if (string.IsNullOrEmpty(ccType)) return "Please choose Credit Card Type!";
			if (string.IsNullOrEmpty(ccNo)) return "Please enter Credit Card No!";
			if (string.IsNullOrEmpty(ccName)) return "Please enter Card Holder Name!";
			if (string.IsNullOrEmpty(ccMonth)) return "Please choose expiry month!";	
			if (string.IsNullOrEmpty(ccYear)) return "Please  choose expiry year!";
            if (string.IsNullOrEmpty(ccCvv2)) return "Please enter CVV2 No!";

			if (ccNo.Length != 16)
            {
                return "Invalid Credit Card No!";
            }
            long CCNoValid;
            if (!long.TryParse(ccNo, out CCNoValid))
            {
                return "Credit Card No must contains only number!";
            }
            int ccMonthValid = 0; int ccYearValid = 0;
            if (!int.TryParse(ccMonth, out ccMonthValid))
            {
                return "Invalid Card Expiry Month!";
            }

            if (!int.TryParse(ccYear, out ccYearValid))
            {
                return "Invalid Card Expiry Year!";
            }
	
   			// TODO Pass in vendor ID
   			/*
			EWayHelper eway = new EWayHelper("19095741");
			PaymentResponse PmtResponse = eway.ProcessPreAuthWithCVN(
 				1.00m, // Transaction Amount
 				ccName, // Card Holder	
				ccNo, // Card Number
 				ccCvv2, // CVN
				ccMonthValid, // Expiry Month
				ccYearValid, // Expiry Year
				"Credit Card Validation" //invoiceReference
			);

			log.Info("PmtResponse.Status => "+ PmtResponse.Status);
	        if (!PmtResponse.Status)
            {
                // Display the error
                return "You had entered invalid credit card info!";
            }
			*/
		}

		//-------------------------------------------------------------------------------
        // Try to check if userID exists!
		//-------------------------------------------------------------------------------
        Uniquemail.SingleSignOn.User exUserInfo = SSOHelper.GetUser(LoginID);
        if (exUserInfo == null)
        {
			return "User account for login ID " + LoginID + " not exists!";
        }

		//-------------------------------------------------------------------------------
  		// Check Crypto Key and  create if not exists
		//-------------------------------------------------------------------------------
        string key = exUserInfo.GetUserSetting("crypto-key");
        if (string.IsNullOrEmpty(key))
        {
            // Generate a new crypto key and save it
            key = Componax.Utils.PasswordHelper.GeneratePassword(32);
            exUserInfo.SetUserSetting("crypto-key", key);
        }

		
		//-------------------------------------------------------------------------------
  		// Update Account info
		//-------------------------------------------------------------------------------

  		Account accInfo = AccountHelper.GetAccount(LoginID);

		if (accInfo == null)
        {
   			//return "Account " + LoginID + " not exists!";

			log.Info("Account not exists! Creating new record for Login ID "+ LoginID);

			accInfo = new Account();
   			accInfo.VendorID = 1; // TODO set vendor
			accInfo.AgencyID = 1; // TODO set agency
   			accInfo.CustomerRef = "Unassigned";
			accInfo.MemberID = LoginID;
			accInfo.AccountStatusID = 1;
			accInfo.InvoiceMethodID = 1;
			accInfo.TotalInvoiced = 0;
			accInfo.TotalPaid = 0;
			accInfo.BillingCurrencyCode = "AUD";
			accInfo.PaysGST = true;
			accInfo.PrimaryEmail = "";

   			accInfo.Save(); // Save first 
			
   			// Read again to generate Customer Ref
			accInfo = AccountHelper.GetAccount(LoginID);
        }
		if (accInfo != null)
		{ 
	
			// Generate new customer ref
			if (string.IsNullOrEmpty(accInfo.CustomerRef) || accInfo.CustomerRef == "Unassigned")
			{
				accInfo.CustomerRef = Mod10Helper.CalculateCustomerRef(accInfo.VendorID, accInfo.AgencyID == null ? 0 : (long)accInfo.AgencyID, accInfo.ID);
			}
			
			accInfo.CompanyName = CompanyName;
			accInfo.Company_TAC_Type = CompanyRegistrationType;
			accInfo.Company_TAC_No = CompanyRegistrationNo;
			accInfo.Company_Dealer_License = CompanyDealerLicense;

			var D_StateCode = "";
			var D_StateName = "";
			GetStateInfo(DisplayRegionID.ToString(), out D_StateCode, out D_StateName);
	
			accInfo.Display_CompanyName = DisplayCompanyName;
			//accInfo.Display_ContactMobile = DisplayPhoneNo;
			accInfo.Display_ContactPhone = DisplayPhoneNo;
			accInfo.Display_PrimaryEmail = DisplayEmail;
			//accInfo.Display_MapCode = DisplayMapCode;
			accInfo.Display_Address1 = DisplayAddressLine1;
			accInfo.Display_Address2 = DisplayAddressLine2;
			accInfo.Display_Country = DisplayCountryCode;
			accInfo.Display_StateProvince = D_StateCode;
			accInfo.Display_StateProvinceName = D_StateName;
			accInfo.Display_PostalCode = DisplayPostalcode;
			accInfo.Display_CityTown = DisplayDistrict;

			var StateCode = "";
			var StateName = "";
			GetStateInfo(BillingRegionID.ToString(), out StateCode, out StateName);
	
			accInfo.BillingContactName = BillingContactName;
			accInfo.ContactMobile = BillingMobileNo;
			accInfo.ContactPhone = BillingPhoneNo;
			accInfo.PrimaryEmail = BillingContactPrimaryEmail;
			accInfo.SecondaryEmail = BillingContactSecondaryEmail;
			accInfo.Address1 = BillingAddressLine1;
			accInfo.Address2 = BillingAddressLine2;
			accInfo.Country = BillingCountryCode;
			accInfo.StateProvince = StateCode;
			accInfo.StateProvinceName = StateName;
			accInfo.PostalCode = BillingPostalcode;
			accInfo.CityTown = BillingDistrict;
	
	  		//log.Info("LeadsPhoneNo => " + LeadsPhoneNo);
	  		//log.Info("LeadsEmail => " + LeadsEmail);
						
			if (!IsProfileMtn)
			{
				accInfo.SalesLead_Type = LeadsNotificationBy;
				accInfo.SalesLead_Email = LeadsEmail;
				accInfo.SalesLead_Phone = LeadsPhoneNo;

				//---------------------------------
				// Billing Preference
				//---------------------------------
	
				if(PaymentMethod =="BPay")
				{
					accInfo.PaymentPreference = "BPay";
					accInfo.PaymentBonus1 = accInfo.PaymentBonus2 = "";
				}
				else
				{
					accInfo.PaymentPreference = BillingPfr;
			
					if (!string.IsNullOrEmpty(BillingPfr))
					{  		
						if (BillingPfr.ToUpper() == "ADVANCE")
						{
							accInfo.PaymentBonus1 = BillingPfrOpt2a;
							accInfo.PaymentBonus2 = BillingPfrOpt2b;
						}
						else
						{
							accInfo.PaymentBonus1 = BillingPfrOpt1;
							accInfo.PaymentBonus2 = "";
						}
					}
				}
			}
	
			if (!IsProfileMtn && ResetCC)
			{
				 CreditCardInfo newCCInfo = new CreditCardInfo();
				 newCCInfo.CardType = ccType;
				 newCCInfo.CardNumber = ccNo;
				 newCCInfo.CardHolderName = ccName;
				 newCCInfo.ExpiryMonth = int.Parse(ccMonth);
				 newCCInfo.ExpiryYear = int.Parse(ccYear);
				 newCCInfo.SecurityNumber = ccCvv2;
	
				 accInfo.SetPrimaryCreditCard();
			}
	
			accInfo.Save();
		}

		//-------------------------------------------------------------------------------
  		// Update SSO DB info
		//-------------------------------------------------------------------------------
  		// Only update profile info if in dealer maintainance page
		if (!IsProfileMtn)
		{
			exUserInfo.FirstName = FirstName;
			exUserInfo.LastName = LastName;
			exUserInfo.ContactPhone = BillingPhoneNo;
   			//exUserInfo.ContactMobile = BillingMobileNo;
			exUserInfo.ContactMobile = LoginMobileNo;

			exUserInfo.Address1 = BillingAddressLine1;
			exUserInfo.Address2 = BillingAddressLine2;
			exUserInfo.CountryCode = BillingCountryCode;
			exUserInfo.RegionID = BillingRegionID;
			exUserInfo.Region = BillingRegionName;
			
			exUserInfo.State = StateTranslation(BillingRegionID);
	
			exUserInfo.PostalCode = BillingPostalcode;
			exUserInfo.CityTown = BillingDistrict;
	
			exUserInfo.EmailAddress = LoginEmail;

			string SMSTempPassword = GenerateTempSMSPassword(userInfo);
			exUserInfo.UserActivationTempPassword = SMSTempPassword;
	
			log.Info("Profile info saving to db....");
			 
			var UpdatedUserInfo = SSOHelper.UpdateUser(exUserInfo);
			//-------------------------------------------------------------------------------       

		}

	   //-------------------------------------------------------------------------------
	   // Update Mongo
	   //-------------------------------------------------------------------------------
 		//IRepository repo = RepositorySetup.Setup();
	   var ELUserInfo = repo.Single<Users>(u => u.UserName == LoginID);
	   if (ELUserInfo != null)
	   {	
			var D_StateCode = "";
			var D_StateName = "";
			GetStateInfo(DisplayRegionID.ToString(), out D_StateCode, out D_StateName);

			ELUserInfo.Email = BillingContactPrimaryEmail;
			
			ELUserInfo.DealerAddress = BillingAddressLine1;
			
			ELUserInfo.DealerLocCountryCode = BillingCountryCode;
			ELUserInfo.DealerLocStateProvince = BillingRegionName;
			ELUserInfo.DealerLocRegion = BillingDistrict;
			
			ELUserInfo.DealerName = DisplayCompanyName;

   			// Display Address 1 & 2
			if (!string.IsNullOrEmpty(DisplayAddressLine1))
		 	{
		 		ELUserInfo.DealerAddress = DisplayAddressLine1;
			}
			if (!string.IsNullOrEmpty(DisplayAddressLine2))
			{
		 		if (!string.IsNullOrEmpty(DisplayAddressLine2)) ELUserInfo.DealerAddress += ",";
		 		if (ELUserInfo.DealerAddress == null) ELUserInfo.DealerAddress = "";
		 		ELUserInfo.DealerAddress += DisplayAddressLine2;
			}
			
			if (!string.IsNullOrEmpty(CompanyDealerLicense))
			{
			 	ELUserInfo.DealerLicense = CompanyDealerLicense;
			}
	
			if (!string.IsNullOrEmpty(DisplayPostalcode))
			{
			 	ELUserInfo.DealerPostCode = DisplayPostalcode;
			}

		 	if (!string.IsNullOrEmpty(DisplayPhoneNo))
            {
            	ELUserInfo.DealerDisplayPhoneNo = DisplayPhoneNo;
            }

			if (!string.IsNullOrEmpty(DisplayEmail))
			{
		 		ELUserInfo.DealerDisplayEmail = DisplayEmail;
			}

			
			if (!string.IsNullOrEmpty(DisplayCountryCode))
			{
			 	ELUserInfo.DealerLocCountryCode = DisplayCountryCode;
			}

			if (!string.IsNullOrEmpty(D_StateCode))
			{
			 	ELUserInfo.DealerLocStateProvince = D_StateCode;
			}

			if (!string.IsNullOrEmpty(DisplayDistrict))
			{
			 	ELUserInfo.DealerLocRegion = DisplayDistrict;
			}

			//--------------------------------------------------------------	
			// Customer child list
			//--------------------------------------------------------------
			if (!IsProfileMtn)
			{
				if (!string.IsNullOrEmpty(LeadsPhoneNo))
				{
					if (LeadsPhoneNo == ",") LeadsPhoneNo = "";
					ELUserInfo.DealerPhone = LeadsPhoneNo.TrimEnd(',');
				}

				if (!string.IsNullOrEmpty(LeadsNotificationBy))
				{
					ELUserInfo.DealerSalesLeadType = LeadsNotificationBy;
				}
	
				if (!string.IsNullOrEmpty(LeadsEmail))
				{
					if (LeadsEmail == ",") LeadsEmail = "";
					ELUserInfo.EnquiryFromEmailAddress = LeadsEmail;
					ELUserInfo.EnquiryFromEmailAddress = ELUserInfo.EnquiryFromEmailAddress.TrimEnd(',');
				}				

				if (!IsParent)
				{
					ELUserInfo.LeadSetting = LeadSetting;
				}
			}
		
			repo.Save(ELUserInfo);
	    }

		//--------------------------------------------------------------	
 		// Customer child list
		//--------------------------------------------------------------
 		if (!IsProfileMtn)
		{
			if (IsParent)
			{
				// De-Reference existing dealer bind to it, to handle if got account removed
				var AllCustChildList = repo.All<Users>(u => u.ParentUserID == ParentCustInfo._id);
				foreach (var childInfo in AllCustChildList)
				{
					if (childInfo != null)	
					{
						childInfo.ParentUserID = null;
						repo.Save(childInfo);
					}
				}
		
				Users ChildCustInfo = new Users();
				if (!string.IsNullOrEmpty(CustomerChildList))
				{
					// Validate each dealer
					CustomerChildListArray = CustomerChildList.Split(',');
					foreach (string custchild in CustomerChildListArray)
					{
						ChildCustInfo = repo.Single<Users>(u => u.UserName == custchild);
						if (ChildCustInfo != null)	
						{
							ChildCustInfo.ParentUserID = ParentCustInfo._id;
		
							repo.Save(ChildCustInfo);
						}
					}
				}
			}
	
 		}
		//--------------------------------------------------------------	

        //-------------------------------------------------------------------------------
	}     
      catch (Exception ex)
      {
        strErrMessage = "Dealer updating failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return strErrMessage;
    }

	public void GetStateInfo(string ID, out string StateCode, out string StateName)
        {
            StateCode = "";
            StateName = "";
            switch (ID)
            {
                case "2353":
                    StateCode = "ACT";
                    StateName = "Australian Capital Territory";
                    break;
                case "23155":
                    StateCode = "NSW";
                    StateName = "New South Wales";
                    break;
                case "23745":
                    StateCode = "NT";
                    StateName = "Northern Territory";
                    break;
                case "27085":
                    StateCode = "ALD";
                    StateName = "Queensland";
                    break;
                case "31398":
                    StateCode = "SA";
                    StateName = "South Australia";
                    break;
                case "32840":
                    StateCode = "TAS";
                    StateName = "Tasmania";
                    break;
                case "35121":
                    StateCode = "VIC";
                    StateName = "Victoria";
                    break;
                case "36233":
                    StateCode = "WA";
                    StateName = "Western Australia";
                    break;
                default:
                    break;
            }
        }

	public void SetBillingPreference(string Preference,
            ref bool Bonus_ELIntegration,
            ref bool Bonus_OffsiteDisplay,
            ref bool Bonus_SEO,
            ref bool Bonus_PromoteAdsPrivate)
        {
            switch (Preference)
            {
                case "ELIntegration":
                    Bonus_ELIntegration = true;
                    break;
                case "OffsiteDisplay":
                    Bonus_OffsiteDisplay = true;
                    break;
                case "Bonus_SEO":
                    Bonus_SEO = true;
                    break;
                case "Bonus_PromoteAdsPrivate":
                    Bonus_PromoteAdsPrivate = true;
                    break;
                default:
                    break;
            }
        }

	public string UpdateLeadsSettings()
    { 
 		IRepository repo = RepositorySetup.Setup();

      	string strErrMessage = "";
		
      	try
      	{
        	var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
        	var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();

			log.Info("UpdateLeadsSettings UserID => "+UserID);

        	if(string.IsNullOrEmpty(UserID)) 
        	{
          		strErrMessage = "User ID not exists!";
          		log.Error(strErrMessage);
          		return strErrMessage;
        	}
			var RetailUser = IsRetailUser();

			if (!RetailUser)
			{
				// Find root employee account info
				long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
				if (MainEmpID != 0)
				{
					Uniquemail.SingleSignOn.User ExUserInfo = SSOHelper.GetUser(MainEmpID);
					 if (ExUserInfo != null)
					 {
						  // Check if EmployeeOf is null, then check if have binding to account
						  if ((ExUserInfo.EmployeeOf == null) && (!string.IsNullOrEmpty(ExUserInfo.LoginName)))
						  {	
								UserID = ExUserInfo.LoginName; // Set UserID to parent account login
								log.Info("UpdateLeadsSettings Parent User ID => "+UserID);
						  }else
						  {
							return "Master account record not found!";
						  }	
					}
					else
					{
						return "Master account record not found!";
					}
				}
				else
				{
					return "Master account not found!";
				}
			}
 		   
			var LeadsNotificationBy = HTTPFormHelpers.GetString("LeadsNotificationBy");
			var LeadsEmail = HTTPFormHelpers.GetString("LeadsEmail");
			var LeadsPhoneNo = HTTPFormHelpers.GetString("LeadsPhoneNo");
			var LeadSetting = HTTPFormHelpers.GetString("LeadSetting");
		
			//---------------------------------------------------------------------------------------------
  			// Regex checking
			//---------------------------------------------------------------------------------------------
			Match match = null;
			string PhoneRx = @"^(?=.*04)((?:\s*\d\s*)){10}$";
			string EmailRx = @"^([\w\.\-]+)@(.*)((\.(\w){2,3})+)$";

			if (!string.IsNullOrEmpty(LeadsEmail))
			{
				string[] LeadsEmailArray = LeadsEmail.Split(',');
	 
				int e = 0;
				foreach (string lEmail in LeadsEmailArray)
				{
					e++;
					if (!string.IsNullOrEmpty(lEmail))
					{
						match = Regex.Match(lEmail, EmailRx);
						if (!match.Success) return "Please enter valid lead email address for no " + e + "!";
					}
				}
			}
	
			if (!string.IsNullOrEmpty(LeadsPhoneNo))
			{
				string[] LeadsPhoneNoArray = LeadsPhoneNo.Split(',');
	 
				int p = 0;
				foreach (string lPhoneNo in LeadsPhoneNoArray)
				{
					p++;
					if (!string.IsNullOrEmpty(lPhoneNo))
					{
						match = Regex.Match(lPhoneNo, PhoneRx);
						if (!match.Success) return "Please enter valid lead mobile number for no " + p + "!";
					}
				}
			}
			
			//-------------------------------------------------------------------------------
			// Update Account info
			//-------------------------------------------------------------------------------
  			Account accInfo = AccountHelper.GetAccount(UserID);
			if (accInfo == null)
			{ 
				return "Account info not found!";
			}

			if (accInfo != null)
			{ 
				accInfo.SalesLead_Type = LeadsNotificationBy;
				accInfo.SalesLead_Email = LeadsEmail;
				accInfo.SalesLead_Phone = LeadsPhoneNo;
			
				accInfo.Save();
			}
	
	   		//-------------------------------------------------------------------------------
	   		// Update Mongo
	   		//-------------------------------------------------------------------------------
 			
	   		var ELUserInfo = repo.Single<Users>(u => u.UserName == UserID);
	   		if (ELUserInfo != null)
	   		{	
				if (!string.IsNullOrEmpty(LeadsNotificationBy))
			{
			 	ELUserInfo.DealerSalesLeadType = LeadsNotificationBy;
			}

			if (!string.IsNullOrEmpty(LeadsEmail))
			{
			 	if (LeadsEmail == ",") LeadsEmail = "";
			 	ELUserInfo.EnquiryFromEmailAddress = LeadsEmail;
			 	ELUserInfo.EnquiryFromEmailAddress = ELUserInfo.EnquiryFromEmailAddress.TrimEnd(',');
			}

			if (!string.IsNullOrEmpty(LeadsPhoneNo))
            {
			 	if (LeadsPhoneNo == ",") LeadsPhoneNo = "";
			 	ELUserInfo.DealerPhone = LeadsPhoneNo.TrimEnd(',');
			}
	
			//--------------------------------------------------------------	
			// Customer child list
			//--------------------------------------------------------------
			if (RetailUser)
			{
				ELUserInfo.LeadSetting = "OwnSet";
			}
			else
			{
				bool IsParent = false;
				var ParentCustInfo = repo.Single<Users>(u => u.UserName == UserID);
				if (ParentCustInfo != null)
				{
					if (String.IsNullOrEmpty(ParentCustInfo.ParentUserID))
						IsParent = true;
				}
	
				if (!IsParent)
				{
					ELUserInfo.LeadSetting = LeadSetting;
				}
			}
		
			repo.Save(ELUserInfo);
	    }

        //-------------------------------------------------------------------------------
	}     
      catch (Exception ex)
      {
        strErrMessage = "Dealer updating failed! Error : " + ex.ToString();
        log.Error(strErrMessage);
      }
      return strErrMessage;
	}	

	public string SendThankyouEmail(string LoginID)
	{
		string ErrMsg = "";
		try
		{	
			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(LoginID);

   			/*EmailJob emailJob = new EmailJob()
			{
				 Sender = "support@easylist.com.au",
				 Recipient = userInfo.EmailAddress,
				 Subject = "Welcome to the new Tradingpost (" + LoginID + ")",
				 TemplateName = @"\email\activation\thankYou.vm"
			};
		 
			emailJob.NameValues["UserID"] = LoginID;
			emailJob.NameValues["FirstName"] = userInfo.FirstName;
			emailJob.NameValues["LastName"] = userInfo.LastName;
  			emailJob.NameValues["EasyListUrl"] = "https://dashboard.easylist.com.au/";
		 
			using (IEasyListQueueClient client = Core.CreateClient("/messaging/email"))
			{
			    client.Post(Utils.ObjectToJSON(emailJob));
   			}*/

			SendEmailRequest sendEmailRequest = new SendEmailRequest();
            sendEmailRequest.NameValues.Add("UserID", LoginID);
            sendEmailRequest.NameValues.Add("FirstName", userInfo.FirstName);
            sendEmailRequest.NameValues.Add("LastName", userInfo.LastName);
            sendEmailRequest.NameValues.Add("EasyListUrl", "https://dashboard.easylist.com.au/");
            sendEmailRequest.Priority = MessagingPriority.Normal;
            sendEmailRequest.TemplateName = "TradingpostThankYou";
            sendEmailRequest.To = userInfo.EmailAddress;
            sendEmailRequest.UserRef = "SendThankyouEmail";

			SendEmailResponse response = EasyList.Queue.Helpers.HttpInvocation.PostRequest<SendEmailResponse>(
			  string.Format("{0}://{1}/MessagingImpl.svc/SendEmail", Protocol, Host),
			  Secret, /* ********** A valid key with valid ACL ********** */
			  sendEmailRequest);
			
			if (response.ResponseCode != ResponseCodeType.OK)
			{
				 ErrMsg = "Failed to send activation email!";
				 log.Error(ErrMsg);
				 return ErrMsg;
			}
		}
      	catch (Exception ex)
      	{
			ErrMsg = "Send thank you email failed! Error : " + ex.ToString();
			log.Error(ErrMsg);
			return ErrMsg;
      	}
      	return ErrMsg;
	}

	public string SendSMSTempPassword(string LoginID)
	{
		string ErrMsg = "";
		try
		{	
			// Generate SMS temporary password to verify 
			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(LoginID);
			string SMSTempPassword = "";
			if (string.IsNullOrEmpty(userInfo.UserActivationTempPassword))
			{
				 SMSTempPassword = Componax.Utils.PasswordHelper.GenerateAlphaNumericCode(8);
				 userInfo.UserActivationTempPassword = SMSTempPassword;
				 var UpdatedUserInfo = SSOHelper.UpdateUser(userInfo);
			}else
			{
				 SMSTempPassword = userInfo.UserActivationTempPassword;
			}
		
			// Testing!
			string RecipientMobileNo = userInfo.ContactMobile.Replace(" ","");
			if (RecipientMobileNo == "0499999999" )
			{
				 RecipientMobileNo = "+60163184188";
			}else
			{
				 RecipientMobileNo = "+61" + RecipientMobileNo;
			}

			log.Info("Send SMS to " + LoginID + ", mobile no : " + RecipientMobileNo);

			/*
   			EmailJob emailJob = new EmailJob()
			{
			  Sender = "",
			  Recipient = RecipientMobileNo,
			  Subject = "Your Tradingpost.com.au temporary password is: " + SMSTempPassword,
			  TemplateName = @""
			};
			
			using (IEasyListQueueClient client = Core.CreateClient("/messaging/sms"))
			{
			 client.Post(Utils.ObjectToJSON(emailJob));
   			}
			*/

   			SendSMSRequest sendSMSRequest = new SendSMSRequest();
            sendSMSRequest.NameValues.Add("password", SMSTempPassword);
            sendSMSRequest.Priority = MessagingPriority.Normal;
            sendSMSRequest.TemplateName = "tempPasswordTemplate";
            sendSMSRequest.ToNumber = RecipientMobileNo;
            sendSMSRequest.UserRef = "SendSMSTempPassword";

			SendSMSResponse response = EasyList.Queue.Helpers.HttpInvocation.PostRequest<SendSMSResponse>(
			   string.Format("{0}://{1}/MessagingImpl.svc/SendSMS", Protocol, Host),
			   Secret,
	  			sendSMSRequest);

			if (response.ResponseCode != ResponseCodeType.OK)
			{
				return "Failed to send SMS!";
			}
		}
      	catch (Exception ex)
      	{
			ErrMsg = "Send SMS failed! Error : " + ex.ToString();
			log.Error(ErrMsg);
			return ErrMsg;
      	}
      	return ErrMsg;
	
	}

	public string GenerateTempSMSPassword(Uniquemail.SingleSignOn.User userInfo)
	{
		string SMSTempPassword = "";
		if (string.IsNullOrEmpty(userInfo.UserActivationTempPassword))
		{
	 	  	SMSTempPassword = Componax.Utils.PasswordHelper.GenerateAlphaNumericCode(8);
		}else
		{
	   		SMSTempPassword = userInfo.UserActivationTempPassword;
		}
		return SMSTempPassword;
	}

	public XPathNodeIterator UserActivateAccountLoad(string ActivationKeyEnc, string IsPostBack, string IsPostBackTempPassword)
    {
		XPathNodeIterator nodeIterator = null;
        nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
		try
		{
		   //log.Info("IsPostBack => " + IsPostBack);
		   //log.Info("IsPostBackTempPassword => " + IsPostBackTempPassword);

			string ActivateUserID = "";
			string ErrMessage = ValidateActivationKey(ActivationKeyEnc, out ActivateUserID);
			log.Error("ErrMessage = > " + ErrMessage);
			if (ErrMessage != "") return ErrorNodeIterator(ErrMessage);

   			//---------------------------------------------------
   			// Generate SMS temporary password to verify 
			//---------------------------------------------------
			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(ActivateUserID);
			string SMSTempPassword = GenerateTempSMSPassword(userInfo);
			if (string.IsNullOrEmpty(userInfo.UserActivationTempPassword) || userInfo.UserActivationTempPassword !=SMSTempPassword)
			{
	   			userInfo.UserActivationTempPassword = SMSTempPassword;
	   			var UpdatedUserInfo = SSOHelper.UpdateUser(userInfo);
			}

   			/*if (string.IsNullOrEmpty(userInfo.UserActivationTempPassword))
			{
				SMSTempPassword = Componax.Utils.PasswordHelper.GenerateAlphaNumericCode(8);
				userInfo.UserActivationTempPassword = SMSTempPassword;
				var UpdatedUserInfo = SSOHelper.UpdateUser(userInfo);
			}else
			{
				SMSTempPassword = userInfo.UserActivationTempPassword;
  			}*/
			//---------------------------------------------------

   			//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   			// TODO : SEND SMS
		
   			// Send SMS on first load only
   			if (!(IsPostBack == "true" || IsPostBackTempPassword == "true"))
			{
 				//log.Info("Send SMS!!!");
				// Testing!
				/*string RecipientMobileNo = userInfo.ContactMobile.Replace(" ","");
				if (RecipientMobileNo == "0499999999" )
				{
					RecipientMobileNo = "+60163184188";
				}else
				{
					RecipientMobileNo = "+61" + RecipientMobileNo;
				}
					
	
				EmailJob emailJob = new EmailJob()
				{
					 Sender = "",
					 Recipient = RecipientMobileNo,
					 Subject = "Your Tradingpost.com.au temporary password is: " + SMSTempPassword,
					 TemplateName = @""
				};
				 
				using (IEasyListQueueClient client = Core.CreateClient("/messaging/sms"))
				{
				 client.Post(Utils.ObjectToJSON(emailJob));
				}*/
   			}
			//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


   			// Masked contact mobile
			string ContactMobile = userInfo.ContactMobile;
			string ContactMobileMasked = "";
			if (!string.IsNullOrEmpty(ContactMobile))
			{
				int ContactLength = ContactMobile.Length;
            	int ContactMaskStart = ContactMobile.Length / 3 ;
            	int ContactMaskEnd = ContactMobile.Length / 2;
            	string ContactToMask = ContactMobile.Substring(ContactMaskStart, ContactMaskEnd);
				//ContactMobileMasked = ContactMobile.Replace(ContactToMask, new String('*', ContactMaskEnd));
				ContactMobileMasked= ContactMobile.Remove(ContactMaskStart, ContactMaskEnd).Insert(ContactMaskStart, new String('*', ContactMaskEnd));
			}	
			var UserActicationInfo = new ActivationInfo
				{
					UserLoginID = ActivateUserID,
                	UserFirstName = userInfo.FirstName,
                    UserLastName = userInfo.LastName,
                    UserContactMobile = ContactMobileMasked,
					UserActivationState = userInfo.UserActivationState					
				};

			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(UserActicationInfo.ToXml());
			
		}
      	catch (Exception ex)
      	{
			log.Error("Account activation failed! Error : " + ex.ToString());
			return ErrorNodeIterator("Account activation failed! Error : " + ex.ToString());
      	}
      	return nodeIterator;
    }

	public string ValidateActivationKey(string ActivationKeyEnc, out string ActivateUserID)
	{
 		ActivateUserID = "";
		string ErrMessage = "";

		try
		{
			if(string.IsNullOrEmpty(ActivationKeyEnc))
			{
				//RedirectTo("/");
				//return ErrorNodeIterator("Invalid activation key. Error(000)");
				return "Invalid activation key. Error(000)";
			}
	
			ActivationKeyEnc = ActivationKeyEnc.Replace(" ", "+");
	
			//log.Info("ActivationKeyEnc => "+ ActivationKeyEnc);
			string ActivationKey = ActivationKeyEnc.Decrypt("EasylistAwesome", "Easylist");
				
			if (ActivationKey.Split('|').Count() != 2)
			{
				return "Invalid activation key. Error(001)";
			}
	
			string ActivateDTText = ActivationKey.Split('|')[0];
			ActivateUserID = ActivationKey.Split('|')[1];
	
			DateTime ActivationDT = DateTime.Now;
			if (!DateTime.TryParseExact(ActivateDTText, "yyyyMMddHHmmss", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out ActivationDT))
			{
				return "Invalid activation key. Error(002)";
			}
	
			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(ActivateUserID);
			if (userInfo == null)
			{
				return "Invalid activation key. Error(003)";
			}
				
			DateTime ServerActivationDT = DateTime.Now;
			string ServerActivationDTText = "";
			if (userInfo.UserActivationTime == null)
			{
				return "Invalid activation key. Error(004)";
			}
			else
			{
				if (!DateTime.TryParse(userInfo.UserActivationTime.ToString(), System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out ServerActivationDT))
				{
					return "Invalid activation key. Error(005)";
				}
				ServerActivationDTText = ServerActivationDT.ToString("yyyyMMddHHmmss");
			}
			log.Info("ServerActivationDTText vs ActivateDTText => " + ServerActivationDTText + " & " + ActivateDTText);
			if (ServerActivationDTText != ActivateDTText)
			{
				return "Invalid activation key. Error(006)";
			}
			//return "Invalid activation key. Error(007)";
		}
      	catch (Exception ex)
      	{
		   ErrMessage = "ValidateActivationKey failed! Error : " + ex.ToString();
		   log.Error(ErrMessage);
      	}

		return ErrMessage;
	}

	public string UserActivateAccountValidateTempPass(string ActivationKeyEnc)
    {
		string strErrMessage = "";
		try
		{	
			var SMSTempPassword = HTTPFormHelpers.GetString("easylist-pass");
		
			if (string.IsNullOrEmpty(SMSTempPassword)) return "Please enter SMS Temporary password.";

			string ActivateUserID = "";
			string ErrMessage = ValidateActivationKey(ActivationKeyEnc, out ActivateUserID);
			if (ErrMessage != "") return ErrMessage;

   			// Generate SMS temporary password to verify 
			Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(ActivateUserID);
			if (userInfo == null)
			{
				return "Invalid activation key!";
			}
			log.Info("SMS Temp Password " + userInfo.UserActivationTempPassword + " vs " +  SMSTempPassword);
	  
			// TODO: Send SMS + Enable Temp password checking
			if (userInfo.UserActivationTempPassword != SMSTempPassword)
			{
				return "Invalid SMS Temporary Password!";
		   }
		}
      	catch (Exception ex)
      	{
		   //strErrMessage = "Account activation failed! Error : " + ex.ToString();
		   //log.Error(strErrMessage);
      	}
      	return strErrMessage;
    }

	public string UserActivateAccount(string ActivationKeyEnc)
    {
		string strErrMessage = "";
		try
		{
			var FirstName = HTTPFormHelpers.GetString("FirstName");
			var LastName = HTTPFormHelpers.GetString("LastName");

			var NewPassword = HTTPFormHelpers.GetString("new-password");
			var NewPasswordConfirm = HTTPFormHelpers.GetString("new-password-confirm");
			var SecPhrase = HTTPFormHelpers.GetString("sec-phrase");

			var CompanyName = HTTPFormHelpers.GetString("CompanyName");
			var CompanyRegistrationType = HTTPFormHelpers.GetString("CompanyRegistrationType");
			var CompanyRegistrationNo = HTTPFormHelpers.GetString("CompanyRegistrationNo");
			var CompanyDealerLicense = HTTPFormHelpers.GetString("CompanyDealerLicense");
			
			var DisplayCompanyName = HTTPFormHelpers.GetString("DisplayCompanyName");
			var DisplayPhoneNo = HTTPFormHelpers.GetString("DisplayPhoneNo");
			var DisplayEmail = HTTPFormHelpers.GetString("DisplayEmail");
			//var DisplayMapCode = HTTPFormHelpers.GetString("DisplayMapCode");
			var DisplayAddressLine1 = HTTPFormHelpers.GetString("DisplayAddressLine1");
			var DisplayAddressLine2 = HTTPFormHelpers.GetString("DisplayAddressLine2");
	
			var DisplayCountryCode = HTTPFormHelpers.GetString("DisplayCountryCode");
			var DisplayRegionID = HTTPFormHelpers.GetIntNotNull("DisplayRegionID");
			var DisplayRegionName = HTTPFormHelpers.GetString("DisplayRegionName");
			var DisplayPostalcode = HTTPFormHelpers.GetString("DisplayPostalcode");
			var DisplayDistrict = HTTPFormHelpers.GetString("DisplayDistrict");
			
			var BillingContactName = HTTPFormHelpers.GetString("BillingContactName");
			var BillingMobileNo = HTTPFormHelpers.GetString("BillingMobileNo");
			var BillingPhoneNo = HTTPFormHelpers.GetString("BillingPhoneNo");
			var BillingContactPrimaryEmail = HTTPFormHelpers.GetString("BillingContactPrimaryEmail");
			var BillingContactSecondaryEmail = HTTPFormHelpers.GetString("BillingContactSecondaryEmail");
			var BillingAddressLine1 = HTTPFormHelpers.GetString("BillingAddressLine1");
			var BillingAddressLine2 = HTTPFormHelpers.GetString("BillingAddressLine2");
			
			var BillingCountryCode = HTTPFormHelpers.GetString("BillingCountryCode");
			var BillingRegionID = HTTPFormHelpers.GetIntNotNull("BillingRegionID");
			var BillingRegionName = HTTPFormHelpers.GetString("BillingRegionName");
			var BillingPostalcode = HTTPFormHelpers.GetString("BillingPostalcode");
			var BillingDistrict = HTTPFormHelpers.GetString("BillingDistrict");
	
			var LeadsNotificationBy = HTTPFormHelpers.GetString("LeadsNotificationBy");
			var LeadsEmail = HTTPFormHelpers.GetString("LeadsEmail");
			var LeadsPhoneNo = HTTPFormHelpers.GetString("LeadsPhoneNo");
		
			var ccNo = HTTPFormHelpers.GetString("ccNo");
			var ccType = HTTPFormHelpers.GetString("ccType");
			var ccName = HTTPFormHelpers.GetString("ccName");
			var ccMonth = HTTPFormHelpers.GetString("ccMonth");
			var ccYear = HTTPFormHelpers.GetString("ccYear");
			var ccCvv2 = HTTPFormHelpers.GetString("ccCvv2");
			
   			/*var SecQuestion = HTTPFormHelpers.GetString("security-question");
			var SecAnswer = HTTPFormHelpers.GetString("security-answer");
   			var OtpCode = HTTPFormHelpers.GetString("otp-code");*/

			var PaymentMethod = HTTPFormHelpers.GetString("payment-method");
			var BillingPfr = HTTPFormHelpers.GetString("billing-preference");
			var BillingPfrOpt1 = HTTPFormHelpers.GetString("billing-preference-promotion-1");
			var BillingPfrOpt2a = HTTPFormHelpers.GetString("billing-preference-promotion-2a");
			var BillingPfrOpt2b = HTTPFormHelpers.GetString("billing-preference-promotion-2b");

			//---------------------------------------------------------------------------------------------
			// Regex checking
			//---------------------------------------------------------------------------------------------
			Match match = null;
			string PhoneRx = @"^(?=.*04)((?:\s*\d\s*)){10}$";
   			
			//string EmailRx = @"[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}";
   			//string EmailRx = @"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$";
			string EmailRx = @"^([\w\.\-]+)@(.*)((\.(\w){2,3})+)$";
			
			if (!string.IsNullOrEmpty(BillingMobileNo))
			{
				match = Regex.Match(BillingMobileNo, PhoneRx);
				if (!match.Success) return "Please enter valid biling mobile no!";
			}
			if (!string.IsNullOrEmpty(LeadsEmail))
			{
				string[] LeadsEmailArray = LeadsEmail.Split(',');
	 
				int e = 0;
				foreach (string lEmail in LeadsEmailArray)
				{
					e++;
					if (!string.IsNullOrEmpty(lEmail))
					{
						match = Regex.Match(lEmail, EmailRx);
						if (!match.Success) return "Please enter valid lead email address for no " + e + "!";
					}
				}
			}
	
			if (!string.IsNullOrEmpty(LeadsPhoneNo))
			{
				string[] LeadsPhoneNoArray = LeadsPhoneNo.Split(',');
	 
				int p = 0;
				foreach (string lPhoneNo in LeadsPhoneNoArray)
				{
					p++;
					if (!string.IsNullOrEmpty(lPhoneNo))
					{
						match = Regex.Match(lPhoneNo, PhoneRx);
						if (!match.Success) return "Please enter valid lead mobile number for no " + p + "!";
					}
				}
			}

			

   			//------------------------------------------------------------------------------------------------------------
			// Validation
			//------------------------------------------------------------------------------------------------------------
  			string ActivateUserID = "";
			string ErrMessage = ValidateActivationKey(ActivationKeyEnc, out ActivateUserID);
			if (ErrMessage != "") return ErrMessage;

			if (string.IsNullOrEmpty(CompanyName)){ return "Company name is required field!"; }
			if (string.IsNullOrEmpty(CompanyRegistrationType)){ return "Company registration type is required field!"; }
			if (string.IsNullOrEmpty(CompanyRegistrationNo)){ return "Company registration No is required field!"; }

			if (string.IsNullOrEmpty(NewPassword)) return "Please enter New Password!";
			if (string.IsNullOrEmpty(SecPhrase)) return "Please enter security phrase!";
   			/*if (string.IsNullOrEmpty(SecQuestion)) return "Please select security question!";
	 		if (string.IsNullOrEmpty(SecAnswer)) return "Please enter security answer!";
   			if (string.IsNullOrEmpty(OtpCode)) return "Please enter OTP code!";*/
			
			if (NewPassword != NewPasswordConfirm) return "New password and repeat new password is different!";
			
   			if (SecPhrase.IndexOf(NewPassword, 0, StringComparison.CurrentCultureIgnoreCase) != -1)
			{
				return "Security phrase must not containing password!";
			}
			/*if (SecAnswer.IndexOf(NewPassword, 0, StringComparison.CurrentCultureIgnoreCase) != -1)
			{
				return "Security answer must not containing password!";
   			}*/

			Account accInfo = AccountHelper.GetAccount(ActivateUserID);

			//----------------------------------------------------------------------------
   			// Credit card validation
			//----------------------------------------------------------------------------
   			// Lee Meng : 20130704 - Validation only if user has no credit card info
			CreditCardInfo ccInfo = accInfo.PrimaryCreditCard();
			if(PaymentMethod != "BPay")
			{
				
				if (ccInfo == null){
					if (string.IsNullOrEmpty(ccType)) return "Please choose Credit Card Type!";
					if (string.IsNullOrEmpty(ccNo)) return "Please enter Credit Card No!";
					if (string.IsNullOrEmpty(ccName)) return "Please enter Card Holder Name!";
					if (string.IsNullOrEmpty(ccMonth)) return "Please choose expiry month!";	
					if (string.IsNullOrEmpty(ccYear)) return "Please  choose expiry year!";
					if (string.IsNullOrEmpty(ccCvv2)) return "Please enter CVV2 No!";
		
					if (ccNo.Length != 16)
					{
						return "Invalid Credit Card No!";
					}
					long CCNoValid;
					if (!long.TryParse(ccNo, out CCNoValid))
					{
						return "Credit Card No must contains only number!";
					}
					int ccMonthValid = 0; int ccYearValid = 0;
					if (!int.TryParse(ccMonth, out ccMonthValid))
					{
						return "Invalid Card Expiry Month!";
					}
		
					if (!int.TryParse(ccYear, out ccYearValid))
					{
						return "Invalid Card Expiry Year!";
					}
		
    /*
					EWayHelper eway = new EWayHelper("19095741");
					PaymentResponse PmtResponse = eway.ProcessPreAuthWithCVN(
						1.00m, // Transaction Amount
						ccName, // Card Holder	
						ccNo, // Card Number
						ccCvv2, // CVN
						ccMonthValid, // Expiry Month
						ccYearValid, // Expiry Year
						"Credit Card Validation" //invoiceReference
					);
		
					log.Info("PmtResponse.Status => "+ PmtResponse.Status);
					if (!PmtResponse.Status)
					{
						// Display the error
						return "You had entered invalid credit card info!";
					}
          */
          
				}
			}
			//----------------------------------------------------------------------------
			
			Uniquemail.SingleSignOn.User exUserInfo = SSOHelper.GetUser(ActivateUserID);
        	if (exUserInfo == null)
        	{
				return "User account for login ID " + ActivateUserID + " not exists!";
        	}

			//-------------------------------	
			// Billing Preference
			//-------------------------------	
			if (string.IsNullOrEmpty(BillingPfr) && PaymentMethod !="BPay")
			{
				return "Please choose one of the billing preference!";
			}
	
			if(PaymentMethod != "BPay")
			{
				if (BillingPfr.ToUpper() =="ADVANCE")
				{
					if (string.IsNullOrEmpty(BillingPfrOpt2a))
						return "Please choose one of the bonus 1!";
		
					if (string.IsNullOrEmpty(BillingPfrOpt2b))
						return "Please choose one of the bonus 2!";
		
					/*if (BillingPfrOpt2a == BillingPfrOpt2b)
						return "Please choose different option for bonus 2!";*/
				}else
				{
					if (string.IsNullOrEmpty(BillingPfrOpt1))
						return "Please choose one of the bonus!";
				}
			}
				
			//-------------------------------------------------------------------------------
			// Check Crypto Key and  create if not exists
			//-------------------------------------------------------------------------------
			string key = exUserInfo.GetUserSetting("crypto-key");
			if (string.IsNullOrEmpty(key))
			{
				// Generate a new crypto key and save it
				key = Componax.Utils.PasswordHelper.GeneratePassword(32);
				exUserInfo.SetUserSetting("crypto-key", key);
			}

			//---------------------------
			// Validate OTP code
			//---------------------------
   			// Todo validate OTP code
			
			//=================================================================================================================
			// Save to DB
			//=================================================================================================================
			//-------------------------------
  			// Update SSO DB info
			//-------------------------------

			//exUserInfo.LoginPassword = NewPassword.MD5();
			int phType = 0;
			exUserInfo.LoginPassword = SSOHelper.PasswordHashing(exUserInfo.LoginName, NewPassword, ref phType);
        	exUserInfo.PasswordHashType = phType;

			exUserInfo.SecuriyLoginPhrase = SecPhrase;
   			exUserInfo.UserActivationState = "Activated";
			exUserInfo.ActivatedByUserOn = DateTime.Now;
	
			exUserInfo.FirstName = FirstName;
			exUserInfo.LastName = LastName;

   			exUserInfo.ContactPhone = BillingPhoneNo;
   			//exUserInfo.ContactMobile = BillingMobileNo;  // Login Mobile No from dealer activation page

			exUserInfo.Address1 = BillingAddressLine1;
			exUserInfo.Address2 = BillingAddressLine2;
			exUserInfo.CountryCode = BillingCountryCode;
			exUserInfo.RegionID = BillingRegionID;
			exUserInfo.Region = BillingRegionName;
			exUserInfo.State = StateTranslation(BillingRegionID);
			exUserInfo.PostalCode = BillingPostalcode;
			exUserInfo.CityTown = BillingDistrict;
	
   			//exUserInfo.EmailAddress = DisplayEmail; // Email from dealer activation page

			var UpdatedUserInfo = SSOHelper.UpdateUser(exUserInfo);

			//-------------------------------
  			// Update Account info
			//-------------------------------
			if (accInfo == null)
			{
				log.Info("Account not exists! Creating new record for Login ID "+ ActivateUserID);
	
				accInfo = new Account();
				accInfo.VendorID = 1;
				accInfo.AgencyID = 1;
				accInfo.CustomerRef = "Unassigned";
				accInfo.MemberID = ActivateUserID;
				accInfo.AccountStatusID = 1;
				accInfo.InvoiceMethodID = 1;
				accInfo.TotalInvoiced = 0;
				accInfo.TotalPaid = 0;
				accInfo.BillingCurrencyCode = "AUD";
				accInfo.PaysGST = true;
	
				accInfo.Save(); // Save first 
				
				// Read again to generate Customer Ref
				accInfo = AccountHelper.GetAccount(ActivateUserID);
			}
	 
			// Generate new customer ref
			if (accInfo.CustomerRef == "Unassigned")
			{
				accInfo.CustomerRef = Mod10Helper.CalculateCustomerRef(accInfo.VendorID, accInfo.AgencyID == null ? 0 : (long)accInfo.AgencyID, accInfo.ID);
			}
			
			accInfo.CompanyName = CompanyName;
			accInfo.Company_TAC_Type = CompanyRegistrationType;
			accInfo.Company_TAC_No = CompanyRegistrationNo;
			accInfo.Company_Dealer_License = CompanyDealerLicense;
	
			accInfo.Display_CompanyName = DisplayCompanyName;
			accInfo.Display_ContactPhone = DisplayPhoneNo;
			accInfo.Display_PrimaryEmail = DisplayEmail;
			//accInfo.Display_MapCode = DisplayMapCode;
			accInfo.Display_Address1 = DisplayAddressLine1;
			accInfo.Display_Address2 = DisplayAddressLine2;
			accInfo.Display_Country = DisplayCountryCode;
			accInfo.Display_StateProvince = DisplayRegionID.ToString();
			accInfo.Display_StateProvinceName = DisplayRegionName;
			accInfo.Display_PostalCode = DisplayPostalcode;
			accInfo.Display_CityTown = DisplayDistrict;
	
			accInfo.BillingContactName = BillingContactName;
			accInfo.ContactMobile = BillingMobileNo;
			accInfo.ContactPhone = BillingPhoneNo;
			accInfo.PrimaryEmail = BillingContactPrimaryEmail;
			accInfo.SecondaryEmail = BillingContactSecondaryEmail;
			accInfo.Address1 = BillingAddressLine1;
			accInfo.Address2 = BillingAddressLine2;
			accInfo.Country = BillingCountryCode;
			accInfo.StateProvince = BillingRegionID.ToString();
			accInfo.StateProvinceName = BillingRegionName;
			accInfo.PostalCode = BillingPostalcode;
			accInfo.CityTown = BillingDistrict;
	
			accInfo.SalesLead_Type = LeadsNotificationBy;
			accInfo.SalesLead_Email = LeadsEmail;
			accInfo.SalesLead_Phone = LeadsPhoneNo;

			//---------------------------------
			// Billing Preference
			//---------------------------------
			if(PaymentMethod == "BPay")
			{
				accInfo.PaymentPreference = "BPay";
				accInfo.PaymentBonus1 = accInfo.PaymentBonus2 = "";
			}
			else
			{
				accInfo.PaymentPreference = BillingPfr;
				if (BillingPfr.ToUpper() == "ADVANCE")
				{
					accInfo.PaymentBonus1 = BillingPfrOpt2a;
					accInfo.PaymentBonus2 = BillingPfrOpt2b;
				}
				else
				{
					accInfo.PaymentBonus1 = BillingPfrOpt1;
					accInfo.PaymentBonus2 = "";
				}
				
	
				// Lee Meng : 20130704 - Save only if user has no credit card info
				if (ccInfo == null){
					CreditCardInfo newCCInfo = new CreditCardInfo();
					newCCInfo.CardType = ccType;
					newCCInfo.CardNumber = ccNo;
					newCCInfo.CardHolderName = ccName;
					newCCInfo.ExpiryMonth = int.Parse(ccMonth);
					newCCInfo.ExpiryYear = int.Parse(ccYear);
					newCCInfo.SecurityNumber = ccCvv2;
		
					accInfo.SetPrimaryCreditCard();
				}
			}

			accInfo.Save();

			//-------------------------------
  			// Update Mongo
			//-------------------------------
			IRepository repo = RepositorySetup.Setup();
			var ELUserInfo = repo.Single<Users>(u => u.UserName == ActivateUserID);
			if (ELUserInfo != null)
			{	
				var D_StateCode = "";
				var D_StateName = "";
				GetStateInfo(DisplayRegionID.ToString(), out D_StateCode, out D_StateName);
	
				ELUserInfo.Email = BillingContactPrimaryEmail;
											
				ELUserInfo.DealerName = DisplayCompanyName;
	
				// Display Address 1 & 2
				if (!string.IsNullOrEmpty(DisplayAddressLine1))
				{
					ELUserInfo.DealerAddress = DisplayAddressLine1;
				}
				if (!string.IsNullOrEmpty(DisplayAddressLine2))
				{
					if (!string.IsNullOrEmpty(DisplayAddressLine2)) ELUserInfo.DealerAddress += ",";
					if (ELUserInfo.DealerAddress == null) ELUserInfo.DealerAddress = "";
					ELUserInfo.DealerAddress += DisplayAddressLine2;
				}
	
				if (!string.IsNullOrEmpty(LeadsPhoneNo))
				{
					if (LeadsPhoneNo == ",") LeadsPhoneNo = "";
					ELUserInfo.DealerPhone = LeadsPhoneNo.TrimEnd(',');
				}
	
				if (!string.IsNullOrEmpty(CompanyDealerLicense))
				{
					ELUserInfo.DealerLicense = CompanyDealerLicense;
				}
		
				if (!string.IsNullOrEmpty(DisplayPostalcode))
				{
					ELUserInfo.DealerPostCode = DisplayPostalcode;
				}
	
				if (!string.IsNullOrEmpty(DisplayPhoneNo))
				{
					ELUserInfo.DealerDisplayPhoneNo = DisplayPhoneNo;
				}
	
				if (!string.IsNullOrEmpty(DisplayEmail))
				{
					ELUserInfo.DealerDisplayEmail = DisplayEmail;
				}
	
				if (!string.IsNullOrEmpty(LeadsNotificationBy))
				{
					ELUserInfo.DealerSalesLeadType = LeadsNotificationBy;
				}
	
				if (!string.IsNullOrEmpty(DisplayCountryCode))
				{
					ELUserInfo.DealerLocCountryCode = DisplayCountryCode;
				}
	
				if (!string.IsNullOrEmpty(D_StateCode))
				{
					ELUserInfo.DealerLocStateProvince = D_StateCode;
				}
	
				if (!string.IsNullOrEmpty(DisplayDistrict))
				{
					ELUserInfo.DealerLocRegion = DisplayDistrict;
				}
	
				if (!string.IsNullOrEmpty(LeadsEmail))
				{
					if (LeadsEmail == ",") LeadsEmail = "";
					ELUserInfo.EnquiryFromEmailAddress = LeadsEmail;
					ELUserInfo.EnquiryFromEmailAddress = ELUserInfo.EnquiryFromEmailAddress.TrimEnd(',');
				}
		
				repo.Save(ELUserInfo);
			}
				
		}
      	catch (Exception ex)
      	{
        	strErrMessage = "Account activation failed! Error : " + ex.ToString();
        	log.Error(strErrMessage);
      	}
      	return strErrMessage;
    }

	public string StateTranslation(int BillingRegionID){
		string State = "";
		try
		{
	 		switch (BillingRegionID)
            {
                case 2353: State = "ACT"; break;
                case 23155: State = "NSW"; break;
                case 23745: State = "NT"; break;
                case 27085: State = "QLD"; break;
                case 31398: State = "SA"; break;
                case 32840: State = "TAS"; break;
                case 35121: State = "VIC"; break;
                case 36233: State = "WA"; break;
                default: State = ""; break;
            }
		}
		catch(Exception ex)
		{
			log.Error("StateTranslation failed! Error :" + ex.ToString());
		}
		return State;
    }


	//-------------------------------------------------------------------------------------------------
	public bool IsRetailUser()
    {
		bool IsRetailUser = false;
        try
        {
        	if (HttpContext.Current.Session["easylist-username"] == null) return false;

			var UserID = HttpContext.Current.Session["easylist-username"].ToString();
			if (string.IsNullOrEmpty(UserID))
            {
            	return false;
			}

   			//-----------------------------------------
			// Cache in session to reduce db hit
			//-----------------------------------------
			bool DBCheck = true;
			if (HttpContext.Current.Session["easylist-IsRetailUser"] != null)
			{
				string SSIsRetailUser = HttpContext.Current.Session["easylist-IsRetailUser"].ToString();
				if (SSIsRetailUser != "")
				{	
					if (SSIsRetailUser == "true")
						return true;
					else
						return false;

					DBCheck = false;

	 				log.Debug("User ID " + UserID +". Read IsRetailUser check from session");
				}
			}
			//-----------------------------------------
            
			if (DBCheck)
			{
				Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);
				if (userInfo == null)
				{
					HttpContext.Current.Session["easylist-IsRetailUser"] = "false";
					return false;
				}
				
				if (userInfo.UserType == "Private")
				{
					HttpContext.Current.Session["easylist-IsRetailUser"] = "true";
					return true;
				}else
				{
					HttpContext.Current.Session["easylist-IsRetailUser"] = "false";
					return false;
				}

				/*if (userInfo.IsMemberOf("RetailUser"))
				{
					HttpContext.Current.Session["easylist-IsRetailUser"] = "true";
					return true;
				}else
				{
					HttpContext.Current.Session["easylist-IsRetailUser"] = "false";
					return false;
				}*/
            }
		}
        catch (Exception ex)
        {
			log.Error("IsRetailUser function failed! Error:" + ex.ToString());
        }
        return IsRetailUser;
	}

     public bool IsAuthorized(string GroupNameCSVList)
     {
        bool IsAuthorized = false;
        try
        {
        	if (string.IsNullOrEmpty(GroupNameCSVList)) return false;

			if (HttpContext.Current.Session["easylist-username"] == null) return false;

			var UserID = HttpContext.Current.Session["easylist-username"].ToString();
            if (string.IsNullOrEmpty(UserID))
            {
                return false;
            }

            List<string> GroupNameList = new List<string>(GroupNameCSVList.Split(','));

			bool DBCheck = true;

			//--------------------------------------------------------------------
			// User group list cache to reduce DB hit
			//--------------------------------------------------------------------
   			// Save user group list in session if not exists
			bool SaveUsergroup = false;
			if (HttpContext.Current.Session["easylist-usergrouplist"] == null)
			{
				SaveUsergroup = true;
			}
			else
			{
				if (HttpContext.Current.Session["easylist-usergrouplist"].ToString() == "")
				{
					SaveUsergroup = true;
				}
			}
			if (SaveUsergroup)
			{
				try
				{
					Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(UserID);
					if (StaffInfo != null)
					{
						UserGroupList SessionUgl = new UserGroupList();
			
						var userGroupmemberships = StaffInfo.GroupMemberships ;
					 
						SessionUgl.UserName = UserID;
			
						foreach(string GroupName in userGroupmemberships.Split(','))
						{	
					  		SessionUgl.Group.Add(GroupName.Trim());
					 	}
			
						var SessionUglJSON = EasyList.Common.Helpers.Utils.ObjectToJSON(SessionUgl);
					  	HttpContext.Current.Session["easylist-usergrouplist"] = SessionUglJSON;
					}
				 }catch (Exception ex)
				 {
					   log.Error("Store user group list in session failed! Error :" + ex);
				 }
			}
	
   			// Read from session if exists
			if (HttpContext.Current.Session["easylist-usergrouplist"] != null)
			{
				try
				{	
				  	string SessionUGL = HttpContext.Current.Session["easylist-usergrouplist"].ToString();
				  	if (SessionUGL != "")
				  	{
				   		var storedUGL = EasyList.Common.Helpers.Utils.JSONToObject<UserGroupList>(SessionUGL);
				   
				   		if (storedUGL.UserName.ToUpper() == UserID.ToUpper())
				   		{
							log.Debug("User ID " + UserID +". Read IsAuthorized check from session");
							foreach (var groupName in GroupNameList)
							{
					 			if (storedUGL.Group.Exists(g => g.ToUpper() == groupName.ToUpper().Trim()))
					 			{
									DBCheck = false;
					  				return true;
					 			}
							}
					   }else
					   {
							// Next hit will load again
	   						HttpContext.Current.Session["easylist-usergrouplist"] = "";
					   }
				  	}
				 }
				 catch(Exception ex)
				 {
				  	log.Error("IsAuthorized read cached session failed! Error :" + ex);
				 }
			}
			//--------------------------------------------------------------------

			if (DBCheck)
			{
            	Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);
            	if (userInfo == null)
            	{
               		return false;
            	}

             	foreach (var groupName in GroupNameList)
             	{
                	if (userInfo.IsMemberOf(groupName.Trim()))
                	{
                        return true;
                	}
              	}
			 }
            }
            catch (Exception ex)
            {
                log.Error("IsAuthorized function failed! Error:" + ex.ToString());
            }
            return IsAuthorized;
        }

	/*
     public bool IsAuthorized(string GroupNameCSVList)
     {
            bool IsAuthorized = false;
            try
            {
        if (string.IsNullOrEmpty(GroupNameCSVList)) return false;

        if (HttpContext.Current.Session["easylist-username"] == null) return false;

                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                if (string.IsNullOrEmpty(UserID))
                {
                    return false;
                }
                Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);
                if (userInfo == null)
                {
                    return false;
                }
                List<string> GroupNameList = new List<string>(GroupNameCSVList.Split(','));

                foreach (var groupName in GroupNameList)
                {
                    if (userInfo.IsMemberOf(groupName.Trim()))
                    {
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("IsAuthorized function failed! Error:" + ex.ToString());
            }
            return IsAuthorized;
        }
		*/

        public XPathNodeIterator GetUserMenuList()
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            try
            {
				if (HttpContext.Current.Session["easylist-username"] == null) {
					  return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("No login ID exists!");
				}

                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                var UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
                Uniquemail.SingleSignOn.User StaffInfo = SSOHelper.GetUser(UserID);

                if (StaffInfo != null)
                {
                    // Check if the staff is belongs to the same dealer
	 				//var SavedUserCode = StaffInfo.GetUserSetting("UserCode");
                    var SavedUserCode = StaffInfo.UserCode;
  					//if (SavedUserCode == UserCode)
	   				// {
                        if (!string.IsNullOrEmpty(StaffInfo.GroupMemberships))
                        {
                            Object[] StaffGroup = EasyList.Common.Helpers.Utils.StringDelimitedToObjectArray(StaffInfo.GroupMemberships, ',');
                            List<string> StaffGroupList = StaffGroup.Select(i => i.ToString().Trim()).ToList();
                            
                            MenuAccessList mAccList = new MenuAccessList();
                            mAccList.AccesssNewListing = false;
                            mAccList.AccessViewListing = false;
                            mAccList.AccessViewAccounting = false;
                            mAccList.AccessViewStaff = false;
                            mAccList.AccessPerformanceReport = StaffInfo.UserType == "Business";
							mAccList.AccessViewDealer = false;

                            foreach (var sg in StaffGroupList)
                            {
                                switch (sg)
                                {
									case "RetailUser":
										mAccList.AccesssNewListingRetail = true;
										//mAccList.AccessViewAccounting = true;
										mAccList.AccessViewAccountingRetail = true;
										mAccList.AccessViewListing = true;
										mAccList.AccessViewLead = true;
										// Retail user currently do not have email and sms lead notification settings
										mAccList.AccessViewLeadSettings = true;
										break;

                                    case "Manager":
                                        mAccList.AccesssNewListing = true;
                                        mAccList.AccessViewListing = true;
                                        mAccList.AccessViewAccounting = true;
                                        mAccList.AccessViewStaff = true;
										mAccList.AccessViewLead = true;
										mAccList.AccessViewLeadSettings = true;
                                        break;

                                    case "Editor":
                                        mAccList.AccesssNewListing = true;
                                        mAccList.AccessViewListing = true;
                                        break;

                                    case "Sales":
                                        mAccList.AccessViewListing = true;
										mAccList.AccessViewLead = true;
                                        break;

                                    case "Account":
                                        mAccList.AccessViewAccounting = true;
						
                                        break;

									case "EasySales Admin":
										mAccList.AccessViewStaff = true;   
                                        mAccList.AccessViewDealer = true;
										mAccList.AccessViewLead = true;
                                        break;

									case "ESSalesRep":
                                        mAccList.AccessViewDealer = true;
										mAccList.AccessViewLead = true;
                                        break;

									case "ESSupport":
                                        mAccList.AccessViewDealer = true;
										break;

                                    default:
                                        break;
                                }
                            }

                            var mAccListXML = mAccList.ToXml();

                            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(mAccListXML);
                        }
	 				//}
                }
            }
            catch (Exception ex)
            {
                log.Error("GetUserMenuList failed. Error " + ex.ToString());
                nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("GetUserMenuList failed. Error " + ex.ToString());
            }
            return nodeIterator;
        }
    
    //-------------------------------------------------------------------------------
      #region Helpers

    // Converts the embedded XML response into an XML node set
    public XPathNodeIterator ParseReponse(string data) 
    {
      try
      {
        if(string.IsNullOrEmpty(data)) 
        {
          data="&lt;Empty /&gt;";
        }   
        return GetIterator(data.Trim());
      }
      catch(Exception ex)
      {
        return GetIterator("&lt;Error&gt;"+ ex.ToString() +"&lt;/Error&gt;");
      }
    }
    
    // Gets an interator instance from an XML string
    public XPathNodeIterator GetIterator(string xml) 
    {
      if (!xml.StartsWith("<"))
      {
        var index = xml.IndexOf("<");
        xml = xml.Substring(index);
      }
      XmlDocument doc = new XmlDocument { XmlResolver = null };
      doc.LoadXml(xml);
      XPathNavigator nav = doc.CreateNavigator();
      return nav.Select("/");
    }


      public void RedirectTo(string url)
      {
  		HttpContext.Current.Response.Redirect(url);
  		//HttpContext.Current.Response.Status = "301 Moved Permanently";
  		//HttpContext.Current.Response.AddHeader("Location", url);
      }

    #endregion
    //-------------------------------------------------------------------------------

	public string GetValueByCommaPos(string CSVString, int Pos)
	{
		string result = "";
		try
		{
			Pos = Pos - 1;
			string[] CSVArray = CSVString.Split(',');
			if (Pos < CSVArray.Length)
			{
				result = CSVArray.GetValue(Pos).ToString();
			}
		}
		catch (Exception ex)
		{
			log.Error("GetValueByCommaPos " + ex.ToString());
		}
		return result;
	}

	public XPathNodeIterator ErrorNodeIterator(string ErrMsg)
        {
            log.Error(ErrMsg);
            return EasyList.Common.Helpers.Utils.XMLGetErrorIterator(ErrMsg);
        }

    public class MenuAccessList
        {
			public bool AccesssNewListingRetail { get; set; }
            public bool AccesssNewListing { get; set; }
            public bool AccessViewListing { get; set; }
            public bool AccessViewAccounting { get; set; }
			public bool AccessViewAccountingRetail { get; set; }
            public bool AccessViewStaff { get; set; }
			public bool AccessViewDealer { get; set; }
			public bool AccessViewLead { get; set; }
			public bool AccessViewLeadSettings { get; set; }
      public bool AccessPerformanceReport {get; set; }
        }


		public class ActivationInfo
        {
			public string UserLoginID { get; set; }
            public string UserFirstName { get; set; }
			public string UserLastName { get; set; }
			public string UserContactMobile { get; set; }
			public string UserActivationState { get; set; }
        }

	public class CustUserInfo
	{
		public string UserID { get; set; }
		public string UserName { get; set; }
	}

		private string getLocInfo(string LocInfo, out string outLocRegion, out string outLocState, out int outLocPostcodeNo)
        {
            outLocRegion = "";
            outLocState = "";
            outLocPostcodeNo = 0;

			LocInfo = LocInfo.Replace("&nbsp;", " ").Replace("&#160;", " ").Replace("&#xA0;", " ");

			var ErrMsg = "Location entered can’t be found. Please ensure you’ve entered a valid Australian location (e.g. Melbourne, VIC 3000)";
            
			try
            {
                int LocPostcodeNo = 0;
				log.Info("Validating " + LocInfo);

				if (LocInfo.IndexOf(',') == -1) return ErrMsg;
				if (LocInfo.IndexOf(' ') == -1) return ErrMsg;
				if (LocInfo.Length < 5) return ErrMsg;
				if ((LocInfo.Length - LocInfo.LastIndexOf(' ')) < 0) return ErrMsg;

                var LocRegion = LocInfo.Substring(0, LocInfo.LastIndexOf(',')).Trim();

				//var LocState = LocInfo.Substring(LocInfo.LastIndexOf(',') + 1, (LocInfo.Length - LocInfo.LastIndexOf(' ') - 1)).Trim();
                var LocState = LocInfo.Substring(LocInfo.LastIndexOf(',') + 1).Trim();
                LocState = LocState.Remove(LocState.LastIndexOf(' ')).Trim();

				var LocPostcode = LocInfo.Substring(LocInfo.LastIndexOf(' ') + 1);

                if (LocRegion == "" || LocState == "" || LocPostcode == "")
                {
					log.Info("Loc Region " + LocRegion + ",Loc State " + LocState + ",Loc Postcode " + LocPostcode );

                    return ErrMsg;
                }
                else if (!int.TryParse(LocPostcode, out LocPostcodeNo))
                {
                    return "Invalid location postcode";
                }
                else
                {
                    IRepository repo = RepositorySetup.Setup();
                    var PostalCodeInfo = repo.Single<PostalCodes>(p => 
						p.PostalCode == LocPostcodeNo &&
                        p.StateProvinceCode == LocState &&
                        p.Region.ToUpper() == LocRegion.ToUpper());

                    if (PostalCodeInfo == null)
                    {
						ErrMsg += ".Location detected is Region =" + LocRegion + ", State=" + LocState + ", Postcode=" + LocPostcode;
                        return ErrMsg;
                    }

                    outLocRegion = LocRegion;
                    outLocState = LocState;
                    outLocPostcodeNo = LocPostcodeNo;
					ErrMsg = "";
                }
            }
            catch (Exception ex)
            {
                log.Error("Failed to getLocInfo. Error : " + ex.ToString());
				return ErrMsg;
            }
            return ""; // No error
        }

		//-----------------------------------------------------------
		// Build parent-child
		//-----------------------------------------------------------

		public string CustomerChildList(string UserCode)
        {
			var UserCodeList = UserCode;
		  	
			try
		   	{
 				//var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				if (!String.IsNullOrEmpty(UserCode))
		  		{
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

		public string GetCustomerChildDropdown()
        {
			var CustomerChildDropdown = "";
			try
			{
				IRepository repo = RepositorySetup.Setup();

				if (HttpContext.Current.Session["easylist-usercodelist"] == null) return "";
				
				var UserCodeList =  HttpContext.Current.Session["easylist-usercodelist"].ToString();
				var UserCodeArray = UserCodeList.Split(',');
				foreach(var usercode in UserCodeArray)
				{
					var UserInfo = repo.Single<Users>(u => u.UserCode == usercode);
					
					if (CustomerChildDropdown != "") CustomerChildDropdown += "|";
					CustomerChildDropdown += usercode + ";" + UserInfo.DealerName + " ("+ UserInfo.UserName + ")";
				}
			}
			catch (Exception ex)
			{
				log.Error("Failed! Error : " + ex);
			}
			return CustomerChildDropdown;
		}

		public bool HasChildList()
		{
			bool HasChildList = false;
	
			if (HttpContext.Current.Session == null || HttpContext.Current.Session["easylist-usercodelist"] == null)
			{
				return false;
			}
			else
			{
				string UserCodeChildList = HttpContext.Current.Session["easylist-usercodelist"].ToString(); 
				
				if (UserCodeChildList.IndexOf(',') > 0)
				{
					HasChildList = true;
				}
			}
			return HasChildList;
		}

		public class UserGroupList
        {
            public string UserName { get; set; }
            public List<string> Group { get; set; }

            public UserGroupList()
            {
                Group = new List<string>();
            }
        }
]]>

  </msxml:script>

</xsl:stylesheet>