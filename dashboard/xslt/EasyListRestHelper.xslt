<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:RESTscripts="urn:RESTscripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<!-- C# helper scripts -->
		
<msxml:script language="C#" implements-prefix="RESTscripts">	
<msxml:assembly name="NLog" />
<msxml:assembly name="System.Xml.Linq"/>
<msxml:assembly name="EasyList.Common.Helpers"/>
<msxml:assembly name="EasyList.Data.DAL.Repository"/>	
<msxml:assembly name="EasyList.Data.DAL.Repository.Entity"/>
<msxml:assembly name="EasyList.Data.BL"/>	
<msxml:assembly name="System.Web"/>
<msxml:assembly name="System.Data.Linq"/>
<msxml:assembly name="System.Net"/>
<msxml:assembly name="System.Core"/>
<msxml:assembly name="System.ServiceModel"/>
<msxml:assembly name="System.ServiceModel.Web"/>
<msxml:assembly name="System.Configuration"/>
<msxml:assembly name="Uniquemail.SingleSignOn"/>
<msxml:assembly name="Uniquemail.Database"/>
<msxml:assembly name="EasyList.Dashboard.Helpers"/>
<msxml:assembly name="Componax.ExtensionMethods"/>
<msxml:assembly name="EasySales.Accounts"/>
<msxml:assembly name="EasySales.EwayAPI"/>
<msxml:assembly name="EasyList.Queue.Repo"/>
<msxml:assembly name="EasyList.Queue.Repo.Driver"/>
<msxml:assembly name="EasyList.Queue.Repo.Entity"/>
<msxml:assembly name="EasyList.Queue.Helpers"/>
<msxml:assembly name="EasyList.DataFeeds.BL" />
	
<msxml:using namespace="System.Collections.Generic"/>
<msxml:using namespace="System.Net"/>
<msxml:using namespace="System.Linq"/>
<msxml:using namespace="System.Web"/>
<msxml:using namespace="System.Data.Linq"/>
<msxml:using namespace="System.Web.Caching"/>
<msxml:using namespace="System.ServiceModel"/>
<msxml:using namespace="System.ServiceModel.Web"/>
<msxml:using namespace="System.Xml.XPath"/>
<msxml:using namespace="System.Configuration"/>
<msxml:using namespace="System.IO"/>

<msxml:using namespace="EasyList.Data.BL"/>
<msxml:using namespace="EasyList.Common.Helpers"/>
<msxml:using namespace="EasyList.Common.Helpers.Web"/>
<msxml:using namespace="EasyList.Common.Helpers.Web.REST"/>
<msxml:using namespace="EasyList.Data.DAL.Repository"/>
<msxml:using namespace="EasyList.Data.DAL.Repository.Entity"/>
<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.OTP"/>
<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.Queue"/>
<msxml:using namespace="EasyList.Data.DAL.Repository.Entity.Helpers"/>

<msxml:using namespace="EasySales.Accounts"/>
<msxml:using namespace="EasySales.EwayAPI" />
<msxml:using namespace="NLog" />  
<msxml:using namespace="Uniquemail.SingleSignOn" />
<msxml:using namespace="EasyList.Dashboard.Helpers" />
<msxml:using namespace="Componax.ExtensionMethods" />
<msxml:using namespace="Uniquemail.Database" />
<msxml:using namespace="EasyList.Queue.Repo.Entity"/>
<msxml:using namespace="EasyList.Queue.Repo"/>
<msxml:using namespace="EasyList.Queue.Helpers"/>

<msxml:using namespace="EasyList.DataFeeds.BL" />	
	
<![CDATA[
		string AppID = "MyEasyListAppID";
		string AppSecretID = "MyEasyListSecretKey";
		
  		//string URL = "http://localhost:34/";
 		//string URL = "http://rest.mongodbv1.dev.easylist.com.au/";
  		string URL = "http://general.api.easylist.com.au/";

 		//string Listing_URL = "http://localhost:34/";
  		//string Listing_URL = "http://rest.live.mongodbv1.dev.easylist.com.au/";
 		//string Listing_URL = "http://rest.mongodbv1.dev.easylist.com.au/";
   		string Listing_URL = "http://general.api.easylist.com.au/";

		string Protocol = "http";
		string Host = "messaging.api.easylist.com.au";
		string Secret = "EB78CAA0-474D-499E-9FD1-B3FA85534180";

		static Logger log = LogManager.GetCurrentClassLogger();
        RESTStatus rs = new RESTStatus();
		string DealerCacheURL = @"http://api.mongodbv1.dev.easylist.com.au/apiv2/easylist.aspx?action=refresh_dealer&amp;dealer=";

  		//------------------------------------------------------------------------------------------------------
  		//	Account entity
		//------------------------------------------------------------------------------------------------------
  
		public XPathNodeIterator ResendOTP()
		{
			XPathNodeIterator nodeIterator = null;
			try
			{
				string SendOTPType = "";
				// Get OTPType
				if (HttpContext.Current.Session != null && HttpContext.Current.Session["OTPType"] != null )
				{
					SendOTPType = HttpContext.Current.Session["OTPType"].ToString();
				}
	
				if (string.IsNullOrEmpty(SendOTPType))
				{
					log.Info("Send OTP failed! OTP Type is empty!");
					return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Send OTP Failed. OTP Type is empty!");
				}

				if (HttpContext.Current.Session != null && HttpContext.Current.Session["OTPVerifyByMobile"] != null && HttpContext.Current.Session["OTPVerifyByMobile"].ToString() != "")
				{
					if (HttpContext.Current.Session["OTPVerifyByMobile"].ToString() == "true")
					{
						string NewMobileNo = "";
						if (HttpContext.Current.Session != null && HttpContext.Current.Session["NewMobileNo"] != null )
						{
							NewMobileNo = HttpContext.Current.Session["NewMobileNo"].ToString();
						}
 
						if (string.IsNullOrEmpty(NewMobileNo))
						{
							log.Info("Send OTP failed! New mobile no is empty!");
							return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Send OTP Failed. New mobile no is empty!");
						}

						string CustomTemplate = "";
						if (HttpContext.Current.Session != null && HttpContext.Current.Session["CustomTemplate"] != null )
						{
							CustomTemplate = HttpContext.Current.Session["CustomTemplate"].ToString();
						}

						EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
					
						rc.URL = string.Format("{0}Account/MobileSendOTP?MobileNo={1}&ResendOTPType={2}&CustomTemplateName={3}", 
							URL, NewMobileNo, SendOTPType, CustomTemplate) ;
		
						rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
						rc.RequestType = "application/xml";
						rc.ResponseType = "application/xml";
			
						rs = rc.SendRequest();
		
						log.Info("ResendOTP => " + rc.URL);
			
						if (rs.State == RESTState.Success)
						{
							nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
						}
						else
						{
							log.Debug("OTP Resend Failed! Error:" + rs.Message);
							nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
							//return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Resend OTP Failed. Error :" + rs.Result);
						}
					}
				}
				else
				{
					// Get UserID
					string UserID  = "";
					if (HttpContext.Current.Session != null && HttpContext.Current.Session["LoginUserID"] != null )
					{
						UserID = HttpContext.Current.Session["LoginUserID"].ToString();
					}
	
					if (string.IsNullOrEmpty(UserID))
					{
						log.Info("Send OTP failed! User ID is empty!");
						return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Send OTP Failed. No User ID exist!");
					}
	
					EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
					
					rc.URL = string.Format("{0}Account/SendOTP?UserID={1}&ResendOTPType={2}", 
						URL, UserID, SendOTPType) ;
	
					rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
					rc.RequestType = "application/xml";
					rc.ResponseType = "application/xml";
		
					rs = rc.SendRequest();
	
					log.Info("ResendOTP => " + rc.URL);
		
					if (rs.State == RESTState.Success)
					{
						//log.Debug("OTP Resend Success! " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserCode").Value);
						nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
					}
					else
					{
						log.Debug("OTP Resend Failed! Error:" + rs.Message);
						nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
						//return EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Resend OTP Failed. Error :" + rs.Result);
					}
				}
			}
			catch (Exception ex)
			{
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Resend OTP Failed. Error:" + ex.ToString());
				log.Error("Resend OTP Failed. Error:" + ex.ToString());
			}

			return nodeIterator;

		}

		public XPathNodeIterator LogonV2(string userName, string LoginType, string PublicFlag, 
			string OTP, string Password, string SecAnswer, string MobileNo, string Email,
			string CurrentViewState, string ActivationKey, string ConfirmPassword, string NewSecPhrase)
		{
			XPathNodeIterator nodeIterator = null;
			try
			{	
 				// TODO: Super cookies
				AccountInfo acInfo = new AccountInfo();
 				
				// Validation
				if (string.IsNullOrEmpty(userName) && string.IsNullOrEmpty(ActivationKey))
				{
					acInfo.HasError = true;
					acInfo.ErrorMessage = "";
					return EasyList.Common.Helpers.Utils.XMLGetNodeIterator( Utils.ObjectToXML(acInfo));
				}

 				//log.Info("UserName:" + userName +", Password: "+ Password);
				
				SessionInfo si = null;
				LogonViewStateInfo lvs = new LogonViewStateInfo();
				
 				//log.Info("LoginType = > " + LoginType);

				bool ToActivateAccount = false;
				bool ToActivateAccountEmail = false;
				bool ToVerifyOTP = false;
				bool ToVerifyPassword = false;
				bool ToLogin = false;
                switch (LoginType)
                {
  					// Redirect from Email Link
					case "Submit_Activation":
						ToActivateAccount = true;

						break;

 					// Redirect from Email link, click on Submit
					case "Submit_EmailActivation":
						ToActivateAccountEmail = true;
						
						lvs.Password = Password;
						lvs.ConfirmPassword = ConfirmPassword;
						lvs.NewSecPhrase = NewSecPhrase;

						break;

                    case "Submit_OTP":
						ToVerifyOTP = true;
                        break;

					case "Submit_Password":
						ToVerifyPassword = true;

						si = SecurityController.SessionInfo;
						if (si == null)
						{
							log.Debug("Creating new Session...");
							SecurityController.Initialise_Session();
						}
						si = SecurityController.SessionInfo;
						lvs.SessionID = si.SessionID.ToString();
						
						log.Debug("Session ID " + si.SessionID);
						log.Info("Session ID " + si.SessionID);
			
                        break;
					
                    default:
						ToLogin = true;
					   //ToVerifyOTP = true;
					   //ToVerifyPassword = true;
                        break;
                }

				SecurityController.WebSiteDomain = "easylist.com.au";
				SecurityController.IPAddress =  "60.53.223.242"; //SecurityController.GetIPAddress();

				log.Debug("Username:" + userName + ";Password:"+ Password +";IP:" + SecurityController.IPAddress);
				 
				bool AccessFromPublic = false;
				if (PublicFlag == "on") AccessFromPublic = true;

				// Temporary set to True to enforce OTP
			 	//AccessFromPublic = true ;
				
				if (!string.IsNullOrEmpty(userName)) userName = userName.Trim();
				if (!string.IsNullOrEmpty(Password)) Password = Password.Trim();
				if (!string.IsNullOrEmpty(OTP)) OTP = OTP.Trim();
				
				lvs.UserID = userName;
 				lvs.Password = Password; 
				lvs.OTP = OTP;
				lvs.SecAnswer = SecAnswer;
				lvs.MobileNo = MobileNo;
				lvs.Email = Email;
				lvs.SiteName = SecurityController.WebSiteDomain;
				lvs.IPAddress = "60.53.223.242";//SecurityController.IPAddress;
				lvs.UserAgent = SecurityController.UserAgent;
				lvs.RequestUrl = HttpContext.Current.Request.Url.ToString();
				lvs.AccessFromPublic = AccessFromPublic;
				lvs.ToActivateAccount = ToActivateAccount;
				lvs.ToActivateAccountEmail = ToActivateAccountEmail;
				lvs.ToVerifyOTP = ToVerifyOTP;
				lvs.ToVerifyPassword = ToVerifyPassword;
				lvs.ActivationKey = ActivationKey;
				lvs.CurrentLoginTemplate = LoginType;

				string ViewState = Utils.ObjectToJSON(lvs);
				string ViewStateEnc = ViewState.Encrypt("EasylistAwesome", "Easylist");
					 
				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
				
				rc.URL = URL + "Account/LogonV2?ViewState=" + ViewStateEnc ;
				log.Info(" URL => " + rc.URL);
				rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
				rc.RequestType = "application/xml";
				rc.ResponseType = "application/xml";
	
				rs = rc.SendRequest();
	
				string OTPType = "Login";
				if (lvs.CurrentLoginTemplate == "Submit_EmailActivation")
				{
					 OTPType = "ActivateAccount";
				}
				

				string NextLoginTemplate = "";
				if (rs.State == RESTState.Success)
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
					if (LoginType == "Submit_Password")
					{
						var UserCode = nodeIterator.Current.SelectSingleNode("/AccountInfo/UserCode").Value;
   						//var UserCodeChildList = CustomerChildList(UserCode);
   						var UserCodeChildList = GetActivatedUserList(Email);
						HttpContext.Current.Session["easylist-usercodelist"] = UserCodeChildList; 

						HttpContext.Current.Response.SetCookie(new HttpCookie("ELIMG", nodeIterator.Current.SelectSingleNode("/AccountInfo/ImageLimit").Value));
	
  						log.Debug("Username : " + userName + " login Success! User code : " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserCode").Value);
					}

					NextLoginTemplate = nodeIterator.Current.SelectSingleNode("/AccountInfo/NextLoginTemplate").Value;
					if ((NextLoginTemplate == "NonAct_Verify"))
					{
						userName = nodeIterator.Current.SelectSingleNode("/AccountInfo/UserID").Value;
						OTPType = "ActivateAccount";
					}
					
					//log.Debug("UserSignature! " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserSignature").Value);
  					//log.Debug("UserSignature! " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserSignatureDateTime").Value);
				}
				else
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
					log.Debug("Login Failed! Error : " + rs.Message + ".IP : " + SecurityController.IPAddress);
				}
				
				log.Debug("Username:" + userName + "; CurrentLoginTemplate => " + LoginType + ";NextLoginTemplate => " + NextLoginTemplate);

				/*
				log.Info("Password => "+ Password);
				log.Info("CurrentLoginTemplate => " + LoginType);
				log.Info("NextLoginTemplate => " + NextLoginTemplate);
				log.Info("LogonV2 LoginUserID => " + userName);
				log.Info("LogonV2 OTPType => " + OTPType);
				*/

				//-----------------------------------------------------------------
   				// Store in session for OTP Resend
				HttpContext.Current.Session["LoginUserID"] = userName; 
				HttpContext.Current.Session["OTPType"] = OTPType; 
				//-----------------------------------------------------------------

			}catch (Exception ex)
			{
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Error " + ex.ToString());
				log.Error("Login failed! Error:" + ex.ToString());
			}

			return nodeIterator;
		}

		 public class LogonViewStateInfo
		{
			public string UserID { get; set; }
			public string Password { get; set; }
        	public string ConfirmPassword { get; set; }
        	public string NewSecPhrase { get; set; }

			public string OTP { get; set; }
			public string SecAnswer { get; set; }
			public string MobileNo { get; set; }
			public string Email { get; set; }
	
			public string SiteName { get; set; }
			public string IPAddress { get; set; }
			public string UserAgent { get; set; }
			public string RequestUrl { get; set; }
			public string SessionID { get; set; }
	
			public bool ToActivateAccount { get; set; }
			public bool ToActivateAccountEmail {get; set; }
			public bool ToVerifyOTP { get; set; }
			public bool ToVerifyPassword { get; set; }

			public string ActivationKey { get; set; }
			public bool AccessFromPublic { get; set; }
			public string CurrentLoginTemplate { get; set; }
   
		}

		//------------------------------------------------------------------------------------------------------
    
		//------------------------------------------------------------------------------------------------------
  		//	User maintenance
		//------------------------------------------------------------------------------------------------------

		public XPathNodeIterator GetUserProfile()
        {
			XPathNodeIterator nodeIterator = null;
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
			try
			{
				var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
				var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();	

				log.Debug("Get User Profile : " + UserID);

				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString(), UserID, UserCode, UserSign, UserSignDT);
				rc.URL = URL + "Account/" + UserID;
				rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
				rc.RequestType = "application/xml";
				rc.ResponseType = "application/xml";
	
				rs = rc.SendRequest();
				
				if (rs.State == RESTState.Success)
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
  					//log.Debug("Get Listing Success " + nodeIterator.Current.SelectSingleNode("/ListingsRestInfo/Code").Value);
				}
				else
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Error " + rs.Message);
					log.Debug("Listing. Error:" + rs.Message);
				}
			}			
			catch (Exception ex)
			{
				log.Error("Read reading user profile! Error:" + ex.ToString());
			}
			return nodeIterator;
		}

        /// <summary>
        /// Updates a profile
        /// </summary>
        public string UpdateUserProfile()
        {
			string strErrMessage = "";
			try
			{
				var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
				var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();
				
				log.Info("Updating user profile " + UserID);

				//============================================================================================================
 				// Listing Info
				//============================================================================================================
 				// REMARKS: Body content have to be JSON instead of XML, XML have issue posting ampersand in field value
				
			    List<NameValuePair> nvList = new List<NameValuePair>();
                NameValuePair nvitem = new NameValuePair();

				log.Info("FirstName :" + HTTPFormHelpers.GetString("FirstName"));

	
				//--------------------------------------------------------------------------
  				// General attributes
				//--------------------------------------------------------------------------
				nvList.Add(new NameValuePair { Name = "CompanyName", Value = HTTPFormHelpers.GetString("CompanyName") });
				nvList.Add(new NameValuePair { Name = "FirstName", Value = HTTPFormHelpers.GetString("FirstName") });
				nvList.Add(new NameValuePair { Name = "LastName", Value = HTTPFormHelpers.GetString("LastName") });
				
				// Convert from Object to JSON
                string JSONProfile = EasyList.Common.Helpers.Utils.ObjectToJSON(nvList);
            
				byte[] dataByte = Encoding.ASCII.GetBytes(JSONProfile);

				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString(),UserID, UserCode, UserSign, UserSignDT);
            	rc.URL = URL + "Account/" + UserID;
            	rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
            	rc.RequestType = "application/json";  rc.ResponseType = "application/xml";
				rc.DataByte = dataByte;
            	rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					log.Info("User Profile " + UserID + " save successfully!");
				}
				else
				{
					throw new Exception(rs.Message);
				}

			}
			catch (Exception ex)
			{
				strErrMessage = ex.ToString();
				log.Error("Update user profile failed! Error:" + ex.ToString());
			}
			finally
			{
				
			}
			return strErrMessage;
        }

		//------------------------------------------------------------------------------------------------------
  		//	Temporary Listing entity
		//------------------------------------------------------------------------------------------------------
        public bool TempListingExists()
		{
			bool TempListingExists = false;
			try
			{
				var UserCode =  "Guest";
				if (HttpContext.Current.Session["easylist-usercode"] != null && !string.IsNullOrEmpty(HttpContext.Current.Session["easylist-usercode"].ToString()))
				{
					UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
				}

				var UserTempKey = HttpContext.Current.Request.Cookies["ELID"].Value;
				
				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
	 			rc.URL = URL + "ListingTemp/Exists/" + UserCode + "/" + UserTempKey;
            	rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
            	rc.RequestType = "application/json";  rc.ResponseType = "application/json";

            	rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					if (rs.Result == "true")
					{
						TempListingExists = true;
					}
				}
				else
				{
					throw new Exception(rs.Message);
				}
			}
			catch (Exception ex)
			{
				log.Error("TempListingExists failed! Error:" + ex.ToString());
			}
			return TempListingExists;
		}

        /// <summary>
        /// New Temporary Listing Copying from an existing Listing
        /// </summary>
		public XPathNodeIterator NewListingCopyFrom(bool IsRetailUser, string listingCode)
        {	
            XPathNodeIterator nodeIterator = null;
      		nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            try
            { 
                var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
				var UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
				var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();
                
                //step 1: retrieve the original listing to be copied
                EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString(), UserID, UserCode, UserSign, UserSignDT);
	 			rc.URL = Listing_URL + "Listing/" + listingCode;
				rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
				rc.RequestType = "application/xml";
				rc.ResponseType = "application/xml";
					
				rs = rc.SendRequest();
					
				if (rs.State == RESTState.Success)
				{	
                    //step 2: copy the original listing to a new listing 
                    string UserTempKey = Guid.NewGuid().ToString();
                                        
	 			    Dictionary<string, object> listing = new Dictionary<string, object>();
                   
                    ListingsRestInfo listingsRestInfo = Utils.XMLToObject<ListingsRestInfo>(rs.Result);
                                      
				    var SellingType = "1"; // Private (Default)
				    if (!IsRetailUser)
				    {
  					    SellingType = "2";	// Business
				    }
				    listing.Add("SellingType", SellingType);
				    listing.Add("CatID", listingsRestInfo.CatID);
				    listing.Add("UserCode", listingsRestInfo.UserCode);
				    listing.Add("Code", UserTempKey);
            	    listing.Add("SrcName", "EasyListDashBoard");
            	    listing.Add("Title", listingsRestInfo.Title);
				    listing.Add("SumDesc", listingsRestInfo.SumDesc);
				
				    listing.Add("Price", listingsRestInfo.Price);
				    listing.Add("WasPrice", listingsRestInfo.WasPrice);
				    listing.Add("PriceType", listingsRestInfo.PriceType);
   
                    if (listingsRestInfo.ListingsPricingInfo != null)
                    {
                        string priceInfoXML = Utils.ObjectToXML(listingsRestInfo.ListingsPricingInfo);
                        listing.Add("PriceInfoXML", priceInfoXML);
                    }
                    
				    listing.Add("PriceQualifier", listingsRestInfo.PriceQualifier);
				    listing.Add("Desc", listingsRestInfo.Desc);
				    listing.Add("DescWSYIWYG", listingsRestInfo.DescWSYIWYG);
				    listing.Add("StkNo", listingsRestInfo.StkNo);
					listing.Add("ContactDisplayLevelSetting", (int)listingsRestInfo.ContactDisplayLevelSetting);
					listing.Add("ContactDisplaySellerEmail", listingsRestInfo.ContactDisplaySellerEmail);
					listing.Add("ContactDisplaySellerPhone", listingsRestInfo.ContactDisplaySellerPhone);
					listing.Add("ContactDisplaySellerName", listingsRestInfo.ContactDisplaySellerName);
					listing.Add("FeedOutDestList", listingsRestInfo.FeedOutDestList);	
					listing.Add("CatalogID", listingsRestInfo.CatalogID);	
					listing.Add("CatalogHotlistID", listingsRestInfo.CatalogHotlistID);	
				    listing.Add("ListingStatusID", (int)ListingStatus.Draft);
					listing.Add("Condition", listingsRestInfo.Condition);
					listing.Add("ConditionDesc", listingsRestInfo.ConditionDesc);
				    listing.Add("DateCreated", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow).ToString() + ")/");
				    listing.Add("DateEdited", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow).ToString() + ")/");
                    listing.Add("IsHidden", false);
				    listing.Add("LocRegion", listingsRestInfo.LocRegion);
				    listing.Add("LocStateProvince", listingsRestInfo.LocStateProvince);
				    listing.Add("LocPostalCode", listingsRestInfo.LocPostalCode);
				    listing.Add("LocCountryCode", "AU");
                    listing.Add("VehicleListing", listingsRestInfo.VehicleListing);
                    listing.Add("XmlDataType", listingsRestInfo.XmlDataType);
					listing.Add("XmlData", listingsRestInfo.XmlData);				    
                    listing.Add("VideosXml", listingsRestInfo.VideosXml);
                                    
				    //step 3: post the newly created listing object back to server
            	    string JSONlisting = Utils.ObjectToJSON(listing);
            	    byte[] dataByte = Encoding.ASCII.GetBytes(JSONlisting);

				    rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.POST.ToString());
				    rc.URL = Listing_URL + "ListingTemp/";
				    rc.RequestMethod = EasyListRestClient.HttpMethod.POST;
				    rc.RequestType = "application/json"; rc.ResponseType = "application/json";
				    rc.DataByte = dataByte;
				
				    rs = rc.SendRequest();
                    if (rs.State == RESTState.Success)
				    {
					    var newListingCode = rs.Result;
  					  
					    //step 4: download all the images from the original listing object, then re-post all the images for the new listing object
                        if (listingsRestInfo.ListingsImageInfo != null && listingsRestInfo.ListingsImageInfo.Count > 0)
                        { 
                             string imageUploadFolder = ConfigurationManager.AppSettings["ImageUploadFolder"].ToString();
                        
                             if (!Directory.Exists(imageUploadFolder))
                             {
                                Directory.CreateDirectory(imageUploadFolder);
                             }
                                                
                             foreach (ImageEditInfo imageEditInfo in listingsRestInfo.ListingsImageInfo)
                             {
                                //download the file first then re-upload it using the API
                                Uri uri = new Uri(imageEditInfo.ImageUrl);
                                string fileName = Path.GetFileName(uri.LocalPath);
                                Guid imgFileGUID = Guid.NewGuid();
                                string tempImageFileName = string.Format("{0}-{1}-{2}", newListingCode, imgFileGUID.ToString(), fileName);
                                string tempImagePath = Path.Combine(imageUploadFolder, tempImageFileName);
                     
                                try
                                {
                                    using (WebClient client = new WebClient())
                                    {
                                        client.DownloadFile(imageEditInfo.ImageUrl, tempImagePath);
                                    }
                                    
                                    //upload it back to server
                                    rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.POST.ToString());
                                    rc.URL = Listing_URL + "ListingTemp/Image/" + UserCode + "/" + UserTempKey;
                                    rc.RequestMethod = EasyListRestClient.HttpMethod.POST;
                                    rc.RequestType = "multipart/form-data;";
                                    rc.ResponseType = "application/json";
                                    rc.DataByte = Parser.FileToMultipartParser(tempImagePath);
                                    rs = new RESTStatus();
                                    rs = rc.SendRequest();
                                }
                                catch(Exception ex)
                                {
                                    //
                                }
                                finally
                                {
                                    File.Delete(tempImagePath);
                                }
                            }
                        }
                               
                        //step 5: update the ELID cookie with the new tempkey
				        HttpCookie MyCookie = new HttpCookie("ELID");
				        DateTime now = DateTime.Now;
				        MyCookie.Value = UserTempKey;
				        MyCookie.Expires = now.AddHours(48);
				        HttpContext.Current.Response.Cookies.Add(MyCookie);
                        //have to set request.cookie too so that NewListingTempLoad can pick up the latest cookie value
                        HttpContext.Current.Request.Cookies["ELID"].Value = UserTempKey;
                        
                        //step 6: Once the new listing object is fully created (as draft), then call the NewListingTempLoad to load it as an usual draft record
                        nodeIterator = NewListingTempLoad();
				    }
				    else
				    {
					    nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Unable to copy from the original listing object. Error: " + rs.Message);
                        log.Error("NewListingCopyFrom(): Unable to copy from the original listing object. Error:" + rs.Message);
				    }
				}
				else
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("The listing cannot be retrieved. Error: " + rs.Message);
					log.Error("NewListingCopyFrom(): The original listing cannot be retrieved. Error: " + rs.Message);
				}
            }
            catch(Exception ex)
            {
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Error!");
				log.Error("NewListingCopyFrom(): Exception:" + ex.ToString());
            }
            
            return nodeIterator;
        }

		/// <summary>
        /// New Temporary Listing Load, create new guid for public user if not exists
        /// </summary>
		public XPathNodeIterator NewListingTempLoad()
        {	
 			XPathNodeIterator nodeIterator = null;
      		nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
      		string strErrMessage = "";
			try
			{
 				//------------------------------------------------------------------------
				// Cookies for User Code
				var UserCode =  "Guest";
				if (HttpContext.Current.Session["easylist-usercode"] != null && !string.IsNullOrEmpty(HttpContext.Current.Session["easylist-usercode"].ToString()))
				{
					UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
				}else
				{
					HttpContext.Current.Response.SetCookie(new HttpCookie("ELIMG", "9"));
				}
				HttpCookie UserCodeCookie = new HttpCookie("ELUS");
				UserCodeCookie.Value = UserCode;
				UserCodeCookie.Expires = DateTime.Now.AddHours(48);
					
				HttpContext.Current.Response.Cookies.Add(UserCodeCookie);

				//------------------------------------------------------------------------
 				
 				// Check if has cookies for GUID (Identify public user)
				bool cookieExists = HttpContext.Current.Request.Cookies["ELID"] != null;

				if (HttpContext.Current.Request.Cookies["ELID"] != null) {
	 				if (HttpContext.Current.Request.Cookies["ELID"].Value == "")
					{
						cookieExists = false;
					}
				}

				string UserTempKey = ""; 
 				
				if (!cookieExists)
				{
					UserTempKey = Guid.NewGuid().ToString();
					log.Info("New cookies " + UserTempKey);
					HttpCookie MyCookie = new HttpCookie("ELID");
					DateTime now = DateTime.Now;
					
					MyCookie.Value = UserTempKey;
					MyCookie.Expires = now.AddHours(48);
					
					HttpContext.Current.Response.Cookies.Add(MyCookie);

					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator("");
				}
				else
				{	
  					// Read from existing cookies 
					UserTempKey = HttpContext.Current.Request.Cookies["ELID"].Value;
					log.Info("Read from existing cookies " + UserTempKey);
  					// Read existing temporary listing info

  					//nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(StaffInfoXML);

					log.Debug("Get Listing for guest user : " + UserTempKey);
	
					EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
	 				rc.URL = Listing_URL + "ListingTemp/" + UserCode + "/" + UserTempKey;
					rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
					rc.RequestType = "application/xml";
					rc.ResponseType = "application/xml";
					
					log.Info(rc.URL);
					rs = rc.SendRequest();
					
					if (rs.State == RESTState.Success)
					{
						nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
						log.Debug("Get temporay Listing Success " + nodeIterator.Current.SelectSingleNode("/ListingsRestInfo/Code").Value);
					}
					else
					{
						nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Error " + rs.Message);
						log.Debug("Listing. Error:" + rs.Message);
					}
				}
			
				// Set session user-sign and user-code
				HttpContext.Current.Session["easylist-userTempKey"] = UserTempKey;

			}
			catch (Exception ex)
      		{
        		strErrMessage = ex.ToString();
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Error!");
				log.Error("New Listing load failed! Error:" + ex.ToString());
      		}
      		return nodeIterator;
    	}

		/// <summary>
        /// Create new temporary listing
        /// </summary>
        public string NewListingTempSave(bool IsRetailUser, ListingStatus lstStatus)
        {	
			string strErrMessage = "";
			try
			{
				IRepository repo = RepositorySetup.Setup();

				log.Info("XXXXXX IsRetailUser : " + IsRetailUser);

				var listingCategory = HTTPFormHelpers.GetString("listing-UIEditorLink");
				log.Info("Category " + listingCategory);
	
				string HttpRequestParam = HTTPRequest.GetHTTPRequestParams(HttpContext.Current.Request);
				log.Info("Param List - " + HttpRequestParam);
 				
				string UserTempKey = "";
				var UserCode = "Guest";

				/*if (!IsRetailUser)
				{
					UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				}*/
				
				if (IsRetailUser)
				{
					UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
					if (string.IsNullOrEmpty(UserCode)) UserCode = "Guest";
				}
				else
				{
					UserCode = HTTPFormHelpers.GetString("listing-usercode");
					if (string.IsNullOrEmpty(UserCode))
					{
						UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
					}
				}

				UserTempKey = HttpContext.Current.Session["easylist-userTempKey"].ToString();

				log.Info("UserTempKey => " + UserTempKey);

				//--------------------------------------------------------------------------
  				// Server side validation
				//--------------------------------------------------------------------------
				if (String.IsNullOrEmpty(UserTempKey))
				{
	 				return "No temporary session exists for the your account!";
				}

				//---------------------------------------------
 				// Pricing
				//---------------------------------------------
				Decimal Price = 0;
				Decimal WasPrice = 0;
				Decimal PriceDriveAway = 0;
				Decimal PriceSale = 0;
				Decimal PriceUnqualified = 0;
				
				string PriceType = "";
				string PriceInfoXML = "";

				var LstCatID = HTTPFormHelpers.GetIntNotNull("listing-category-id");
					
				var HasPrice = HTTPFormHelpers.GetBool("listing-has-price");

				PriceType = HTTPFormHelpers.GetString("listing-price-qualifier");

				if (IsRetailUser || !(LstCatID == 60 || LstCatID == 67 || LstCatID == 80 || LstCatID == 600 || LstCatID == 601))
				{
					if (IsRetailUser || (!IsRetailUser && HasPrice))
					{
						if (!Decimal.TryParse(HTTPFormHelpers.GetString("listing-price"), out Price))
						{
							return "Invalid Current Price value " + HTTPFormHelpers.GetString("listing-price");
						}
   						// Required field for retail user
						if (Price == 0)
						{
							return "Please enter Price value";
						}
					}
					
					string WasPriceText = HTTPFormHelpers.GetString("listing-was-price");
					log.Info("Original price a:" + WasPriceText + ".");
					
					if (!String.IsNullOrEmpty(WasPriceText))
					{
						log.Info("Original price b:" + WasPriceText + ".");
						if (!Decimal.TryParse(WasPriceText, out WasPrice))
						{
							return "Invalid Original Price value " + WasPriceText;
						}
					}
				}
				else
				{
					// Price list for Commercial customer
					PriceDriveAway = HTTPFormHelpers.GetPriceNotNull("listing-driveaway-price");
					PriceSale = HTTPFormHelpers.GetPriceNotNull("listing-sale-price");
					PriceUnqualified = HTTPFormHelpers.GetPriceNotNull("listing-unqualified-price");
					
					if (HasPrice && PriceDriveAway == 0 && PriceSale ==0 && PriceUnqualified == 0)
					{
						return "Please enter price value for Drive away price, Sale price or Unqualified price";
					}

  					//-------------------------------------------------------------------------------------------
  					// Choose which price info to set
					//-------------------------------------------------------------------------------------------
					if (PriceDriveAway != 0)
					{
						Price = PriceDriveAway;
						PriceType = PricingType.DriveAway.ToString();
					} 
					else if (PriceSale != 0)
					{
						Price = PriceSale;
   						//PriceType = PricingType.Sale.ToString();
					} 
					else if (PriceUnqualified != 0)
					{
						Price = PriceUnqualified;
   						//PriceType = PricingType.Unqualified.ToString();
					}

					//-------------------------------------------------------------------------------------------
  					// Store price info as XML
					//-------------------------------------------------------------------------------------------
					var PriceXML = new List<PricingInfo>(); 
					PriceXML.Add(new PricingInfo { PriceType = PricingType.DriveAway, Amount = PriceDriveAway });
					PriceXML.Add(new PricingInfo { PriceType = PricingType.Sale, Amount = PriceSale });
					PriceXML.Add(new PricingInfo { PriceType = PricingType.Unqualified, Amount = PriceUnqualified });
					
					PriceInfoXML = Utils.ObjectToXML(PriceXML);
				}

				
				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-title")))
				{
					return "Please enter valid Title!";
				}

				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-summary")))
				{
					return "Please enter valid Summary Description!";
				}

				if (HTTPFormHelpers.GetIntNotNull("listing-category-id") == 0)
				{
					return "Please select category for your item!";
				}

 				log.Info("Listing-desc => " + HTTPFormHelpers.GetString("listing-description"));
				log.Info("Listing-desc-textonly => " + HTTPFormHelpers.GetString("listing-description-textonly"));
				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-description")))
				{
					return "Please enter valid Full Description!";
				}
                
                if (listingCategory == "AutomotiveListing" || listingCategory == "MotorcycleListing")
				{
                    if (!String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-odometer-value")))
                    {
					    int Odometer = HTTPFormHelpers.GetIntNotNull("listing-odometer-value");			   
					
				        if (Odometer != 0)
				        {
					        if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-odometer-unit")))
                            {
						        return "Please select Odometer Unit!";
					        }
				        }
			        }
                }


				if (listingCategory == "AutomotiveListing" || listingCategory == "MotorcycleListing")
				{         
					var VhcReg = HTTPFormHelpers.GetBool("listing-vehicle-registered");
					if (VhcReg)
					{
						if (string.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-vehicle-rego")) && string.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-vehicle-VIN")))
						{			
							return "Rego and Vin# is required!";
						}
					}
					else
					{
						if (HTTPFormHelpers.GetString("listing-vehicle-VinEngine") == "VIN")
						{
							if (string.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-vehicle-VinEngine-VIN")))
							{
								return "Vin# is required!";
							}
						}
						else
						{
							if (string.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-vehicle-VinEngine-Engine")))
							{
								return "Engine# is required!";
							}
						}

					}	

				}

				// Check NVIC for Car
				if (HTTPFormHelpers.GetIntNotNull("listing-category-id") == 60)
				{
					if (string.IsNullOrEmpty(HTTPFormHelpers.GetString("vehicle-nvic")))
					{
						return "Please choose car spec!";
					}
				}
 				// Check NVIC for Motorbikes
				if (HTTPFormHelpers.GetIntNotNull("listing-category-id") == 67)
				{
					if (string.IsNullOrEmpty(HTTPFormHelpers.GetString("vehicle-Motor-NVIC")))
					{
						return "Please choose motorbikes spec!";
					}
				}


				string LocRegion = "";
                string LocState = "";
				int LocPostcodeNo = 0;

                var ErrMessage = getLocInfo(HTTPFormHelpers.GetString("listing-location"), out LocRegion, out LocState, out LocPostcodeNo);
				if (ErrMessage != "")
					return ErrMessage;
								
				log.Info("Creating new listing...");

				//============================================================================================================
 				// Listing Info
				//============================================================================================================
	 			Dictionary<string, object> listing = new Dictionary<string, object>();

				var SellingType = "1"; // Private (Default)
				if (!IsRetailUser)
				{
  					SellingType = "2";	// Business
				}
				listing.Add("SellingType", SellingType);

				listing.Add("CatID", HTTPFormHelpers.GetIntNotNull("listing-category-id"));
 				// Server will process LstType, CatPath by passing CatID only
		
				listing.Add("UserCode", UserCode);
				listing.Add("Code", UserTempKey);
 				// Server to process UserID

            	listing.Add("SrcName", "EasyListDashBoard");
            	listing.Add("Title", HTTPFormHelpers.GetString("listing-title"));
				
				listing.Add("SumDesc", HTTPFormHelpers.GetString("listing-summary"));
				
				listing.Add("Price", Price);
				listing.Add("WasPrice", WasPrice);

 				// Price info for commercial customer
				listing.Add("PriceType", PriceType);
				listing.Add("PriceInfoXML", PriceInfoXML);
				
				listing.Add("PriceQualifier", HTTPFormHelpers.GetString("listing-price-qualifier"));
				
				listing.Add("Desc", HTTPFormHelpers.GetString("listing-description-textonly"));
				listing.Add("DescWSYIWYG", HTTPFormHelpers.GetString("listing-description"));

				listing.Add("StkNo", HTTPFormHelpers.GetString("listing-stock-number"));

				//-------------------------------------------------------------------------		
 				// Listin Contact Level setting
				var IsAccountLevel = HTTPFormHelpers.GetBool("listing-contact-setting");
				if (IsAccountLevel)
				{
					listing.Add("ContactDisplayLevelSetting", (int)ContactDisplayLevel.AccountLevel);
					listing.Add("ContactDisplaySellerEmail", "");
					listing.Add("ContactDisplaySellerPhone", "");
					listing.Add("ContactDisplaySellerName", "");
				}
				else
				{
					listing.Add("ContactDisplayLevelSetting", (int)ContactDisplayLevel.ListingLevel);
					listing.Add("ContactDisplaySellerEmail", HTTPFormHelpers.GetString("listing-contact-email"));
					listing.Add("ContactDisplaySellerPhone", HTTPFormHelpers.GetString("listing-contact-phone"));
					listing.Add("ContactDisplaySellerName", HTTPFormHelpers.GetString("listing-contact-name"));
				}

				//-------------------------------------------------------------------------		

 				//-------------------------------------------------------------------------		
 				// Listing Catalog and Feeout Default

				if (IsRetailUser)
				{
					listing.Add("FeedOutDestList", DataFeedOutDestination.TradingPost.ToString());	
				}
				else
				{
					var LstCatalog = HTTPFormHelpers.GetString("listing-catalog");
					listing.Add("CatalogID", LstCatalog);	
					
					// Set Hotlist ID based on Catalog ID
					if (!String.IsNullOrEmpty(LstCatalog))
					{
						var catalogInfo = repo.Single<ListingCatalog>(c => c.HotlistUUID == LstCatalog);
						if (catalogInfo != null)
						{
							listing.Add("CatalogHotlistID", catalogInfo.HotlistID);	
							
							var FeedOutDestList = repo.All<FeedOutDistSettings>(f => 
									f.UserCode == UserCode && 
									f.CatalogHotlistID == catalogInfo.HotlistID && 
									(f.FeedOutDistDefaultSetting == DataFeedOutListingDefault.Auto.ToString() ||
									f.InternalUse == true)
								).Select(f => f.DeliveryDesc).Distinct();

							if (FeedOutDestList.ToList().Count() > 0)
							{
								listing.Add("FeedOutDestList", string.Join(",", FeedOutDestList));	
							}
							else
							{
								listing.Add("FeedOutDestList", "");	
							}
						}
					}
				}
				//-------------------------------------------------------------------------		


				listing.Add("ListingStatusID", (int)lstStatus);
				
				/*string ConditionSource = HTTPFormHelpers.GetString("listing-condition");
				if (ConditionSource.IndexOf('|') > 0)
				{
					var ConditionArray = ConditionSource.Split('|');
					listing.Add("Condition", ConditionArray[0]);
					listing.Add("ConditionDesc", ConditionArray[1]);
				}
				else
				{
					listing.Add("Condition", ConditionSource);
				}*/

				string Condition = HTTPFormHelpers.GetString("listing-condition");
				listing.Add("Condition", Condition);
				if (Condition == "New")
				{
					listing.Add("ConditionDesc", "");
				}else
				{
					listing.Add("ConditionDesc", HTTPFormHelpers.GetString("listing-condition-desc"));
				}

				listing.Add("DateCreated", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow).ToString() + ")/");
 				
				//listing.Add("PubDate", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow).ToString() + ")/");
				listing.Add("DateEdited", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow).ToString() + ")/");

                // Listing is inactive when creation
 				//listing.Add("UnpubDate", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow.AddYears(1)).ToString() + ")/");
 				listing.Add("IsHidden", false);

				listing.Add("LocRegion", LocRegion);
				listing.Add("LocStateProvince", LocState);
				listing.Add("LocPostalCode", LocPostcodeNo);
				listing.Add("LocCountryCode", "AU");

 				// If it is vehicle (Car/Motorcycle)
				//--------------------------------------------------------------------------
 				// Vehicles
				//--------------------------------------------------------------------------

				//====================================================================
				// Additional Info
				//====================================================================
				Dictionary<string, object> v = new Dictionary<string, object>();

				if (listingCategory == "AutomotiveListing" || listingCategory == "MotorcycleListing")
				{
                    if (HTTPFormHelpers.GetIntNotNull("listing-odometer-value") != 0)
					{
						v.Add("Odometer", HTTPFormHelpers.GetIntNotNull("listing-odometer-value"));
					}
					v.Add("OdometerUOM", HTTPFormHelpers.GetString("listing-odometer-unit"));
                
					var VhcReg = HTTPFormHelpers.GetBool("listing-vehicle-registered");
					if (VhcReg)
					{
						v.Add("VehicleRegistered", true);
						v.Add("RegNo", HTTPFormHelpers.GetString("listing-vehicle-rego"));

						if (!string.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-vehicle-VIN")))
						{
							v.Add("EngVinType", "VIN");
							v.Add("VinNumber", HTTPFormHelpers.GetString("listing-vehicle-VIN"));
						}else
						{
							v.Add("EngVinType", "");
							v.Add("VinNumber", "");
						}
						
   						//v.Add("RegExpMth", HTTPFormHelpers.GetString("listing-vehicle-expiry-month"));
   						//v.Add("RegExpYear", HTTPFormHelpers.GetString("listing-vehicle-expiry-year"));

						v.Add("RegExpMth", HTTPFormHelpers.GetString("listing-vehicle-expiry-month") == "" ? "0" :HTTPFormHelpers.GetString("listing-vehicle-expiry-month"));
						v.Add("RegExpYear", HTTPFormHelpers.GetString("listing-vehicle-expiry-year") == "" ? "0" :HTTPFormHelpers.GetString("listing-vehicle-expiry-year"));

						v.Add("RoadworthyCertificate", HTTPFormHelpers.GetBool("listing-vehicle-cert"));
					}
					else
					{
						v.Add("VehicleRegistered", false);
						v.Add("EngVinType", HTTPFormHelpers.GetString("listing-vehicle-VinEngine"));
						if (HTTPFormHelpers.GetString("listing-vehicle-VinEngine") == "VIN")
						{
							//v.Add("VinNumber", HTTPFormHelpers.GetString("listing-vehicle-VinEngine-No"));
							v.Add("VinNumber", HTTPFormHelpers.GetString("listing-vehicle-VinEngine-VIN"));
						}
						else
						{
							//v.Add("EngNo", HTTPFormHelpers.GetString("listing-vehicle-VinEngine-No"));
							v.Add("EngNo", HTTPFormHelpers.GetString("listing-vehicle-VinEngine-Engine"));
						}
					}	
				}

				if (listingCategory == "AutomotiveListing")
				{
  					// Truck and Bus
					log.Info("listing-custom-make-sel => " + HTTPFormHelpers.GetString("listing-custom-make-sel"));
					var CatID = HTTPFormHelpers.GetIntNotNull("listing-category-id");
					if (CatID == 80 || CatID == 600 || CatID == 601 )
					{
						v.Add("Make", HTTPFormHelpers.GetString("listing-custom-make"));
						v.Add("Model", HTTPFormHelpers.GetString("listing-custom-model"));
						v.Add("Year", HTTPFormHelpers.GetIntNotNull("listing-custom-year"));
					}
					else
					{
						v.Add("Make", HTTPFormHelpers.GetString("listing-make"));
						v.Add("Model", HTTPFormHelpers.GetString("listing-model"));
						v.Add("Year", HTTPFormHelpers.GetString("listing-year"));
						
						v.Add("BodyStyle", GetBodyStyle(HTTPFormHelpers.GetString("listing-body-style")));
						v.Add("BodyDesc", HTTPFormHelpers.GetString("listing-body-style"));

						v.Add("TrmType", GetTransType(HTTPFormHelpers.GetString("listing-transmission")));
						v.Add("TrmDesc", HTTPFormHelpers.GetString("listing-transmission"));

						v.Add("Variant", HTTPFormHelpers.GetString("listing-variant"));
						v.Add("Series", HTTPFormHelpers.GetString("listing-series"));

						v.Add("NVIC", HTTPFormHelpers.GetString("vehicle-nvic"));
						v.Add("Doors", HTTPFormHelpers.GetIntNotNull("vehicle-doors"));
						v.Add("Seats", HTTPFormHelpers.GetIntNotNull("vehicle-seats"));
						
						v.Add("DriveType", HTTPFormHelpers.GetString("vehicle-drive-type"));
						v.Add("DriveTypeDesc", HTTPFormHelpers.GetString("vehicle-drive-type"));

						v.Add("EngType", HTTPFormHelpers.GetString("vehicle-engine-type"));
						v.Add("EngDesc", HTTPFormHelpers.GetString("vehicle-engine-cc"));
						v.Add("EngSizeDesc", HTTPFormHelpers.GetString("vehicle-engine-size"));

						v.Add("EngCylinders", HTTPFormHelpers.GetString("vehicle-engine-cylinders"));

						v.Add("FuelType", HTTPFormHelpers.GetString("vehicle-fuel-type"));
						v.Add("FuelTypeDesc", HTTPFormHelpers.GetString("vehicle-fuel-type"));
					}

					//*************************************************************************
					// Fields yet to map	
					//*************************************************************************
					//vehicle-price-1=34000 , 
					//vehicle-price-2=28200 ,
					//vehicle-vin=ZFA31200012345678 , 
					//vehicle-transmission-info=5 SP AUTOMATED MANUA , 
					//vehicle-fuel-highway=0 , 
					//vehicle-fuel-city=6.5 , 
					//vehicle-valve-gear=DUAL OVERHEAD CAM , 
					//*************************************************************************
	
					//----------------------
					// Automotive Features
					//----------------------
					if (listingCategory != "GM")
					{
						List<AutomotiveFeatureInfo> AutoFeatures = new List<AutomotiveFeatureInfo>();
						
						string StdFeatureField = "stdFeature";
						string OptFeatureField = "optFeature";
						char Delimiter = ',';
						if (HTTPFormHelpers.GetString("reset-car-attr") == "false")
						{
							StdFeatureField = "listing-standard-features";
							OptFeatureField = "listing-optional-features";
							Delimiter = '|';
						}

						// Standard Features
						string ListStdFeatures = HTTPFormHelpers.GetString(StdFeatureField);
						if(!String.IsNullOrEmpty(ListStdFeatures))
						{
							var StdFeaturesArray = Utils.StringDelimitedToObjectArray(ListStdFeatures, Delimiter);
							foreach (var sf in StdFeaturesArray)
							{
								AutoFeatures.Add(new AutomotiveFeatureInfo { FeatureType = "standard", Feature = sf.ToString() });
							}
						}
						// Optional Features
						string ListOptFeatures = HTTPFormHelpers.GetString(OptFeatureField);
						if(!String.IsNullOrEmpty(ListOptFeatures))
						{
							var OptFeaturesArray = Utils.StringDelimitedToObjectArray(ListOptFeatures, Delimiter);
							foreach (var sf in OptFeaturesArray)
							{
								AutoFeatures.Add(new AutomotiveFeatureInfo { FeatureType = "optional", Feature = sf.ToString() });
							}
						}
		
						if (AutoFeatures.Count > 0)
						{
							var AutoFeaturesXML = Utils.ObjectToXML(AutoFeatures).Remove(0,1);
							v.Add("VehicleFeaturesXML", AutoFeaturesXML);
						}
		
						listing.Add("VehicleListing", v);
					}
				}
				else if (listingCategory == "MotorcycleListing")
				{
					v.Add("Make", HTTPFormHelpers.GetString("listing-Motor-make"));
					v.Add("Model", HTTPFormHelpers.GetString("listing-Motor-model"));
					v.Add("Variant", HTTPFormHelpers.GetString("listing-motor-variant"));
					v.Add("Year", HTTPFormHelpers.GetString("listing-Motor-year"));
					v.Add("Series", HTTPFormHelpers.GetString("listing-motor-series"));
					
 					// Get info from Variant (MatchingMotors)
					/*try
					{
						var MotorVariantInfo = EasyList.Common.Helpers.Utils.JSONToObject<MatchingMotors>(HTTPFormHelpers.GetString("listing-motor-Series"));
						
						if (MotorVariantInfo != null)
						{
							v.Add("BodyDesc", string.IsNullOrEmpty(MotorVariantInfo.Styles) ? "" : MotorVariantInfo.Styles);
							v.Add("TrmType", GetTransType(MotorVariantInfo.Transmission));
							v.Add("TrmDesc", string.IsNullOrEmpty(MotorVariantInfo.Transmission) ? "" : MotorVariantInfo.Transmission);
							v.Add("GlassesCode", string.IsNullOrEmpty(MotorVariantInfo.GlassCode) ? "" : MotorVariantInfo.GlassCode);
							v.Add("NVIC", string.IsNullOrEmpty(MotorVariantInfo.NVIC) ? "" : MotorVariantInfo.NVIC);
							v.Add("Series", string.IsNullOrEmpty(MotorVariantInfo.Series) ? "" : MotorVariantInfo.Series);
							v.Add("EngCylinders", string.IsNullOrEmpty(MotorVariantInfo.Cylinder) ? "" : MotorVariantInfo.Cylinder);
							v.Add("EngDesc", string.IsNullOrEmpty(MotorVariantInfo.Engine) ? "" : MotorVariantInfo.Engine);					  	
							v.Add("EngSizeDesc", string.IsNullOrEmpty(MotorVariantInfo.EngineCC) ? "" : MotorVariantInfo.EngineCC);					  	
						}
					}
					catch(Exception ex)
					{
						log.Error("Failed getting motor info. Error : " + ex);
					}*/
			
					/*
					v.Add("BodyStyle", HTTPFormHelpers.GetString("vehicle-Motor-Styles"));
					v.Add("NVIC", HTTPFormHelpers.GetString("vehicle-Motor-NVIC"));
					v.Add("TrmDesc", HTTPFormHelpers.GetString("vehicle-Motor-Transmission"));
					v.Add("EngType", HTTPFormHelpers.GetString("vehicle-Motor-Engine"));
					v.Add("EngDesc", HTTPFormHelpers.GetString("vehicle-Motor-EngineCC"));
					v.Add("EngCylinders", HTTPFormHelpers.GetString("vehicle-Motor-Cylinder"));
					*/
										
					v.Add("BodyStyle", HTTPFormHelpers.GetString("vehicle-Motor-BodyDesc"));
					v.Add("BodyDesc", HTTPFormHelpers.GetString("vehicle-Motor-BodyStyles"));
					v.Add("TrmType", HTTPFormHelpers.GetString("vehicle-Motor-Transmission-type"));
					v.Add("TrmDesc", HTTPFormHelpers.GetString("vehicle-Motor-Transmission-desc"));
					v.Add("NVIC", HTTPFormHelpers.GetString("vehicle-Motor-NVIC"));
					v.Add("GlassesCode", HTTPFormHelpers.GetString("vehicle-Motor-GlassCode"));
					
					v.Add("EngCylinders", HTTPFormHelpers.GetString("vehicle-Motor-Cylinder"));
					v.Add("EngDesc", HTTPFormHelpers.GetString("vehicle-Motor-Engine"));					  	
					v.Add("EngSizeDesc", HTTPFormHelpers.GetString("vehicle-Motor-EngineCC"));					
					
					//----------------------
					// Automotive Features
					//----------------------
					
					List<AutomotiveFeatureInfo> AutoFeatures = new List<AutomotiveFeatureInfo>();
						
					string StdFeatureField = "stdFeature-motor";
					
					char Delimiter = ',';
					if (HTTPFormHelpers.GetString("reset-car-attr") == "false")
					{
						StdFeatureField = "listing-motor-standard-features";
						Delimiter = '|';
					}

					// Standard Features
					string ListStdFeatures = HTTPFormHelpers.GetString(StdFeatureField);
					if(!String.IsNullOrEmpty(ListStdFeatures))
					{
						var StdFeaturesArray = Utils.StringDelimitedToObjectArray(ListStdFeatures, Delimiter);
						foreach (var sf in StdFeaturesArray)
						{
							AutoFeatures.Add(new AutomotiveFeatureInfo { FeatureType = "standard", Feature = sf.ToString() });
						}
					}
					
					if (AutoFeatures.Count > 0)
					{
						var AutoFeaturesXML = Utils.ObjectToXML(AutoFeatures).Remove(0,1);
						v.Add("VehicleFeaturesXML", AutoFeaturesXML);
					}
			

					listing.Add("VehicleListing", v);
				}
				else if (listingCategory == "GM")
				{
					int CatID = HTTPFormHelpers.GetIntNotNull("listing-category-id");
					
					if (CatID != 0)
					{
						Categories catInfo = EasyList.Dashboard.Helpers.Category.GetCatInfo(CatID);
	  					log.Info("CatID ==> " + CatID);
						List<AttributeInfo> CustomAttr = new List<AttributeInfo>(); 
						if ((catInfo != null) && !string.IsNullOrEmpty(catInfo.catAttrUIXML))
						{
							var catAttrUIXML = Utils.XMLToObject<List<CustomWebControls>>(catInfo.catAttrUIXML);
	
							foreach (var CatAttr in catAttrUIXML)
							{
								CatAttr.XMLAttributeName = CatAttr.XMLAttributeName.Replace(" ", "");
								var XMLAttrVal = HTTPFormHelpers.GetString(CatAttr.XMLAttributeName);
									
								switch (CatAttr.WebControlType.ToString())
								{
									case "Textarea":
									case "TextBox":
									case "DropDown":
										log.Info("XMLAttributeName : " + CatAttr.XMLAttributeName + " ; XMLAttrVal : " + XMLAttrVal );
										if (!string.IsNullOrEmpty(XMLAttrVal)) CustomAttr.Add(new AttributeInfo { Name = CatAttr.XMLAttributeName, Value = XMLAttrVal });
										break;

									case "Checkbox":	
									case "Radio":
										string[] AttrValList = XMLAttrVal.Split(',');
										CustomAttr.Add(new AttributeInfo { Name = CatAttr.XMLAttributeName, Value = XMLAttrVal });
	 
										break;
	
									default:
										if (!string.IsNullOrEmpty(XMLAttrVal)) CustomAttr.Add(new AttributeInfo { Name = CatAttr.XMLAttributeName, Value = XMLAttrVal });
										break;
								}
							}
							if (CustomAttr.Count > 0)
							{
								listing.Add("XmlDataType", "CustomAttributes");
								listing.Add("XmlData", Utils.ObjectToXML(CustomAttr));
								log.Info("Utils.ObjectToXML(CustomAttr) : " + Utils.ObjectToXML(CustomAttr));
							}					
						}
					}
				}


 				//====================================================================
				// Videos - Youtube
				//====================================================================
				//----------------------
				string ListOfYoutubeCode = HTTPFormHelpers.GetString("video-order");
				log.Info("Video " + ListOfYoutubeCode);
				if(!String.IsNullOrEmpty(ListOfYoutubeCode))
				{
					List<VideoInfo> VideoInfoList = new List<VideoInfo>();
					VideoInfo vInfo = new VideoInfo();
					var YoutubeCodeArray = Utils.StringDelimitedToObjectArray(ListOfYoutubeCode, ',');
					foreach (var ytCode in YoutubeCodeArray)
					{
						vInfo = new VideoInfo();

						if (ytCode.ToString().IndexOf("mediaID")!=-1)
						{
							vInfo.VideoSource = "DMI";		
						}else
						{
							vInfo.VideoSource = "YouTube";		
						}
						vInfo.Title = ytCode.ToString();
						vInfo.Description = ytCode.ToString();
						vInfo.SyncSource = ytCode.ToString();
						
						vInfo.VideoData = ytCode.ToString();

						VideoInfoList.Add(vInfo);
					}

					if (VideoInfoList.Count > 0)
					{
						var VideoInfoListXML = Utils.ObjectToXML(VideoInfoList).Remove(0,1);
						listing.Add("VideosXml", VideoInfoListXML);
					}
				}else
				{	
					listing.Add("VideosXml", "");
				}

				// Convert from Object to JSON
            	string JSONlisting = Utils.ObjectToJSON(listing);

				log.Info("New temp listing object " + JSONlisting);

            	byte[] dataByte = Encoding.ASCII.GetBytes(JSONlisting);

				// Post to Server
				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.POST.ToString());
				rc.URL = Listing_URL + "ListingTemp/";
				rc.RequestMethod = EasyListRestClient.HttpMethod.POST;
				rc.RequestType = "application/json"; rc.ResponseType = "application/json";
				rc.DataByte = dataByte;
				
				rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					log.Info("New temporary Listing save successfully! New Listing Code " + rs.Result);
					var NewListingCode = rs.Result;
  					//return "SUCCESS:" + rs.Result;

					//============================================================================================================
					// Image Ordering
					//============================================================================================================
	 				string ImageCodeOrdered = HTTPFormHelpers.GetString("photo-order");
					log.Info("ImageCodeOrdered => " + ImageCodeOrdered);
	 				if (!string.IsNullOrEmpty(ImageCodeOrdered))
					{
						log.Info("Updating image order for listing " + UserTempKey + "/" + ImageCodeOrdered);
						
						rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString());
						
   						//rc.URL = Listing_URL + "ListingTemp/Image/" + UserCode + "/"+ UserTempKey + "/" + ImageCodeOrdered;
						rc.URL = Listing_URL + "ListingTemp/Image/" + UserCode + "/"+ UserTempKey ;
	
						rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
						rc.RequestType = "application/json";  rc.ResponseType = "application/json";

						string ImageCodeOrderedJSON = EasyList.Common.Helpers.Utils.ObjectToJSON(ImageCodeOrdered);
						byte[] dataByte2 = Encoding.ASCII.GetBytes(ImageCodeOrderedJSON);

						rc.DataByte = dataByte2; // PUT Method must have some bytes array
						
						rs = new RESTStatus();
						rs = rc.SendRequest();
		
						if (rs.State == RESTState.Success)
						{
							log.Info("Update Image Order Success! Image ordered list : "+ ImageCodeOrdered);
							//return "SUCCESS:" + rs.Result;
						}
						else
						{
							log.Info("Update Image Order Failed! Error - " + rs.Message);
							throw new Exception(rs.Message);
						}

	 				}
	 				else
					{
   						//return "SUCCESS:" + rs.Result;
	  				}
					return "SUCCESS:" + NewListingCode;
				}
				else
				{
					log.Info("New temporary saving failed!! Error - " + rs.Message);
					throw new Exception(rs.Message);
				}

				
			}
			catch (Exception ex)
			{
				strErrMessage = ex.ToString();
				log.Error("New temporary Listing saving failed! Error:" + ex.ToString());
			}
  			return strErrMessage;
		}

  		//Checking valid listingCode for Monthly Promotion Campaign (OCT => Sports and Leisure)
        public bool ValidListingCode(long LstCatID)
        {
            bool valid = false;
			
   			//Put all Sports & Leisure LstCatID in array (from Feed>Inbound template in TP Acc)
            long [] sports_Leisure = {571,638,639,640,641,643,644,645,646,647,649,650,651,652,653,654,655,656,657,658,659,667,668,670,671,672,673,675,676,677,
                                      678,553,554,555,556,557,625,626,627,559,560,561,562,563,564,565,566,567,568,569,570,661,662,663,664,665,629,630,631,632};

            int exist = Array.IndexOf(sports_Leisure, LstCatID);
            if (exist > -1)
                valid = true;

            return valid;
        }


  		// Payment and publish page
		public string NewListingPayment()
		{
			string strErrMessage = "";
			try
			{
				IRepository repo = RepositorySetup.Setup();
 				var IPAddress = SecurityController.GetIPAddress();

				if (HttpContext.Current.Session["easylist-userTempKey"] == null)
				{
					return "No temporary ID present!";
				}

				if (HttpContext.Current.Session["easylist-usercode"] == null)
				{
					return "User code not exists!";
				}

				// Read from existing cookies 	
				var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
				var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();
				var UserTempKey = HttpContext.Current.Session["easylist-userTempKey"].ToString();

				//------------------------------------------------------------
 				// Compute Package Price again
				//------------------------------------------------------------

				double TotalAmt = 0;
	 			// Get Package selection
				string Package = HTTPFormHelpers.GetString("package");
				double PackageAmt = 0;
				ListingPackage lstPackage = new ListingPackage();
				if (Package == "noticed")
				{
					lstPackage = ListingPackage.Priority;
					PackageAmt = 20;
				}else
				{
					lstPackage = ListingPackage.Standard;
					PackageAmt = 0;
				}

 				// Check again listing price from server
				double ListingAmt = 0;

			 	EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
			  	rc.URL = Listing_URL + "ListingTemp/" + UserCode + "/" + UserTempKey;
			 	rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
			 	rc.RequestType = "application/xml";
			 	rc.ResponseType = "application/xml";
			 
			 	log.Info(rc.URL);
			 	rs = rc.SendRequest();
			 
				string ListingTitle = "";
				
				long LstCatID;
				string LstCatName = "";
				string LstState = "";
					
			 	if (rs.State == RESTState.Success)
				{
					var nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
			  		ListingAmt = Double.Parse(nodeIterator.Current.SelectSingleNode("/ListingsRestInfo/ListingPostAmount").Value) ;
			 		ListingTitle = nodeIterator.Current.SelectSingleNode("/ListingsRestInfo/Title").Value;

					LstCatID = long.Parse(nodeIterator.Current.SelectSingleNode("/ListingsRestInfo/CatID").Value);
					LstState = nodeIterator.Current.SelectSingleNode("/ListingsRestInfo/LocStateProvince").Value;
				}
			 	else
			 	{
					log.Debug("Get temporary Listing failed! Error:" + rs.Message);
			  		return "Failed to read temporary listing!";
			 	}
				
 				// Get Category Name, to record in invoice
				var CatInfo = repo.Single<Categories>(c => c.ID == LstCatID);
				if (CatInfo != null) 
				{
					LstCatName = CatInfo.Name;
				}
		 			
				string NewListingCode = "";
				bool Paid = false;
				if (HttpContext.Current.Session["PaymentPaidListingCode"] != null)
				{
					if (!String.IsNullOrEmpty(HttpContext.Current.Session["PaymentPaidListingCode"].ToString()))
					{
						NewListingCode = HttpContext.Current.Session["PaymentPaidListingCode"].ToString();
						Paid = true;
						log.Info("Payment success but publish listing failed. Retried publish with listing code " + NewListingCode + " for temp key " + UserTempKey);
					}
				}
				
				if (!Paid)
				{
					NewListingCode = Utils.GenerateListingCode(repo);
					log.Info("Generate new listing code " + NewListingCode + " for temp key " + UserTempKey);
				}
 
 				// Process Payment
				TotalAmt = PackageAmt + ListingAmt;

 				log.Info("Amount to pay " + TotalAmt);

 				//-----------------------------------------------------------------
				string Coupon = HTTPFormHelpers.GetString("coupon");
				
				bool ValidCoupon = false;
				if (!String.IsNullOrEmpty(Coupon))
				{	
					//if(Coupon.ToLower() == "freeads102013")
					//if(Coupon.ToLower() == "sasha11")
					//if(Coupon.ToLower() == "liz12")
					//if(Coupon.ToLower() == "freead01")
					//if(Coupon.ToLower() == "compad")
  				    //if(Coupon.ToLower() == "coupon03")
					//if(Coupon.ToLower() == "gratis04")
  					//if(Coupon.ToLower() == "cortesia05")
					//if(Coupon.ToLower() == "percuma07")
					//if(Coupon.ToLower() == "gratuit08")
   					//if(Coupon.ToLower() == "franko09")
					//if(Coupon.ToLower() == "vapaa10")
  					//if(Coupon.ToLower() == "wolny11")
  					//if(Coupon.ToLower() == "tasuta12")
					if(Coupon.ToLower() == "mirima13")
					{
						ValidCoupon = true;
  						log.Info("User entered coupon code 'mirima13' for listing " + NewListingCode + ". No payment needed!");
					}
/*
					else if (Coupon.ToLower() == "tpslfs10" && ValidListingCode(LstCatID)) //for Monthly Sales Campaign only
					{
						ValidCoupon = true;
						log.Info("User entered coupon code 'tpslfs10' for listing Sports and Leisure category " + NewListingCode + ". No payment needed!");
					}
*/
					else
					{
						return "Invalid coupon code!";
					}
				}
				//-----------------------------------------------------------------
				
				long accountID  = 0;
				string PaymentID  = "";
				string BookingID  = "";

				if (HttpContext.Current.Session["PaymentPaidPaymentID"] != null)
				{
					if (!String.IsNullOrEmpty(HttpContext.Current.Session["PaymentPaidPaymentID"].ToString()))
					{
						PaymentID = HttpContext.Current.Session["PaymentPaidPaymentID"].ToString();
					}
				}

				if (HttpContext.Current.Session["PaymentPaidBookingID"] != null)
				{
					if (!String.IsNullOrEmpty(HttpContext.Current.Session["PaymentPaidBookingID"].ToString()))
					{
						BookingID = HttpContext.Current.Session["PaymentPaidBookingID"].ToString();
					}
				}


				var accInfo = AccountHelper.GetAccount(UserID);
				if (accInfo == null)
				{
					return "No account found for your login ID";
				}
				else
				{
					accountID = accInfo.ID;
				}

				var UserInfo = repo.Single<Users>(u => u.UserCode == UserCode);
				var FirstName = UserInfo.DealerName;
				
				if (TotalAmt != 0 && !ValidCoupon)
				{
					  //------------------------------------------------------------
					  // Validate credit card
					  //------------------------------------------------------------
					  
					  string ccType = HTTPFormHelpers.GetString("ccType");
					  string ccNo = HTTPFormHelpers.GetString("ccNo");
					  string ccName = HTTPFormHelpers.GetString("ccName");
					  string ccMonth = HTTPFormHelpers.GetString("ccMonth");
					  string ccYear = HTTPFormHelpers.GetString("ccYear");
					  string ccCvv2 = HTTPFormHelpers.GetString("ccCvv2");
					
					  if (string.IsNullOrEmpty(ccType)) return "Please choose Credit Card Type!";
					  if (string.IsNullOrEmpty(ccNo)) return "Please enter Credit Card No!";
					  if (string.IsNullOrEmpty(ccName)) return "Please enter Card Holder Name!";
					  if (string.IsNullOrEmpty(ccMonth)) return "Please choose expiry month!";	
					  if (string.IsNullOrEmpty(ccYear)) return "Please  choose expiry year!";
					  if (string.IsNullOrEmpty(ccCvv2)) return "Please enter CVV2 No!";
				  
					  int ccMonthValid = 0; int ccYearValid = 0;
					  if (!int.TryParse(ccMonth, out ccMonthValid))
					  {
					   return "Invalid Card Expiry Month!";
					  }
				   
					  if (!int.TryParse(ccYear, out ccYearValid))
					  {
					   return "Invalid Card Expiry Year!";
					  }
					
					  // Remove pre auth for private user, if entered invalid credit card it will get when process payment
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
				 
					  //------------------------------------------------------------
					  // Process Payment
					  //------------------------------------------------------------
					  if (!Paid)
					  {
				  
					   // Info for payment
					   log.Info("PROCESSSING PAYMENT FOR AccountID=" + accountID  + ",Total Amount=" + TotalAmt + ",Cat ID=" + LstCatID.ToString() + ", Cat Name=" + LstCatName + ", State=" + LstState + ",IP=" + IPAddress.ToString());
				  
					   var ccInfo = new EasySales.Accounts.CreditCardInfo();
					   ccInfo.CardNumber= ccNo;
					   ccInfo.CardHolderName = ccName;
					   ccInfo.ExpiryMonth = ccMonthValid;
					   ccInfo.ExpiryYear = ccYearValid;
					   ccInfo.SecurityNumber = ccCvv2;
				  
					   var response = PrivateUserHelper.ProcessPrivateAd(accountID, NewListingCode, LstCatID.ToString(), LstCatName, LstState, (decimal)TotalAmt, ccInfo, IPAddress.ToString());
					   if (response.HadErrors)
					   {
							return "Payment failed! Error : " + response.Message;
					   }
					   else
					   {
							HttpContext.Current.Session["PaymentPaidListingCode"] = NewListingCode; 
							HttpContext.Current.Session["PaymentPaidPaymentID"] = response.PaymentID; 
							HttpContext.Current.Session["PaymentPaidBookingID"] = response.BookingID; 

							PaymentID = response.PaymentID.ToString(); 
							BookingID = response.BookingID.ToString();  

							//-----------------------------------------------------------------------
							// Send Email if payment success
							//-----------------------------------------------------------------------
							
							
							if (UserInfo != null && !string.IsNullOrEmpty(UserInfo.Email))	
							{
								/*
								sendEmailRequest.NameValues.Add("FirstName", FirstName);
								sendEmailRequest.NameValues.Add("adtitle", ListingTitle);
								sendEmailRequest.NameValues.Add("adamount", String.Format("${0:0.00}", TotalAmt) );
								sendEmailRequest.Priority = MessagingPriority.Normal;
								sendEmailRequest.TemplateName = "TradingpostPrivateSellerPaymentNotification";
								*/

								SendEmailRequest sendEmailRequest = new SendEmailRequest();
		
								var UWTitle = @"<br/><div style=""font-weight: bold; font-size: 18px;"">Tradingpost Unique Websites</div>";
								var PaymentInfo = String.Format("Your payment in the amount of {0} will appear on your statement as {1}", String.Format("${0:0.00}", TotalAmt), UWTitle) ;

								sendEmailRequest.NameValues.Add("FirstName", FirstName);
								sendEmailRequest.NameValues.Add("adtitle", ListingTitle);
								sendEmailRequest.NameValues.Add("paymentinfo",PaymentInfo);
								sendEmailRequest.Priority = MessagingPriority.Normal;
								sendEmailRequest.TemplateName = "TradingpostPrivateSellerAdPlacement";

								sendEmailRequest.To = UserInfo.Email;
								sendEmailRequest.UserRef = "NewListingPayment";

								SendEmailResponse EmailResponse = EasyList.Queue.Helpers.HttpInvocation.PostRequest<SendEmailResponse>(
										string.Format("{0}://{1}/MessagingImpl.svc/SendEmail", Protocol, Host),
										Secret, /* ********** A valid key with valid ACL ********** */
										sendEmailRequest);
								
								if (EmailResponse.ResponseCode != ResponseCodeType.OK)
								{
									log.Error("Failed to send Email! Server responsed error.");
								}
							}
							else
							{
									log.Error("Failed to send Email! No user info found for user code : "+ UserCode);
							}
					   	}	
					  }
					  else
					  {
					   	// Payment was success previously, no need process payment again
					   	log.Info("Payment success but publish listing failed. Retried with listing code " + NewListingCode + " for temp key " + UserTempKey);
					  }
				 }else
				 {
					
					  SendEmailRequest sendEmailRequest = new SendEmailRequest();
					  
					  var PaymentInfo = "" ;
					
					  sendEmailRequest.NameValues.Add("FirstName", FirstName);
					  sendEmailRequest.NameValues.Add("adtitle", ListingTitle);
					  sendEmailRequest.NameValues.Add("paymentinfo",PaymentInfo);
					  sendEmailRequest.Priority = MessagingPriority.Normal;
					  sendEmailRequest.TemplateName = "TradingpostPrivateSellerAdPlacement";
					
					  sendEmailRequest.To = UserInfo.Email;
					  sendEmailRequest.UserRef = "NewListingPayment";
					
					  SendEmailResponse EmailResponse = EasyList.Queue.Helpers.HttpInvocation.PostRequest<SendEmailResponse>(
						string.Format("{0}://{1}/MessagingImpl.svc/SendEmail", Protocol, Host),
						Secret, /* ********** A valid key with valid ACL ********** */
						sendEmailRequest);
					  
					  if (EmailResponse.ResponseCode != ResponseCodeType.OK)
					  {
					   log.Error("Failed to send Email! Server responsed error.");
					  }
				}

 				//------------------------------------------------------------
 				// Publish listing
				//------------------------------------------------------------
 				
 				//return "TEST: Listing Code !" + NewListingCode;

				log.Info("Publish new listing, new listing code " + NewListingCode + "...");
 				
				// Post to Server
				rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString());
  				
				//rc.URL = Listing_URL + string.Format("ListingTemp/Publish/{0}/{1}?LstStatus={2}&NewListingCode={3}&lstPackage={4}&TotalAmt={5}&PackageAmt={6}"
 				//	, UserTempKey, UserCode, (int)ListingStatus.InStock, NewListingCode, (int)lstPackage, ListingAmt, PackageAmt);

				rc.URL = string.Format("{0}ListingTemp/Publish/{1}/{2}?LstStatus={3}&NewListingCode={4}&lstPackage={5}&TotalAmt={6}&PackageAmt={7}&PaymentID={8}&BookingID={9}&AccountID={10}&SubLstStatus={11}&UserIPAddress={12}&ValidCoupon={13}&CouponCode={14}"
 					,Listing_URL, UserTempKey, UserCode, (int)ListingStatus.Draft, NewListingCode, (int)lstPackage, ListingAmt, PackageAmt, PaymentID, BookingID, accountID, (int)ListingStatus.Draft_NeedsSafetyScan, IPAddress.ToString(), ValidCoupon.ToString(), Coupon);	
	
				rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
				rc.RequestType = "application/json"; rc.ResponseType = "application/json";
				rc.DataByte = Encoding.ASCII.GetBytes("Publish"); // PUT Method must have some bytes array

				log.Info("Publish " + rc.URL);

				rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					log.Info("Publish listing=> result " + rs.Result);

					HttpContext.Current.Session["PaymentPaidListingCode"] = ""; 
					HttpContext.Current.Session["PaymentPaidPaymentID"] = ""; 
					HttpContext.Current.Session["PaymentPaidBookingID"] = ""; 

					var listingCode = rs.Result;

					return "SUCCESS:" + listingCode;

					//------------------------------------------------------------
					// Update Listing
					//------------------------------------------------------------
					// ? Indicator for priority listing to use in search result
					// ? Amount paid for priority
					// ? Total amount paid ( Listing amount + priority )
	
	 				/*
					List<NameValuePair> nvList = new List<NameValuePair>();
					nvList.Add(new NameValuePair { Name = "LstPackage", Value = (int)lstPackage });
					nvList.Add(new NameValuePair { Name = "LstPackageAmount", Value = PackageAmt});
					nvList.Add(new NameValuePair { Name = "LstAmount", Value = ListingAmt});

					// Convert from Object to JSON
					string JSONlisting = EasyList.Common.Helpers.Utils.ObjectToJSON(nvList);
				
					byte[] dataByte = Encoding.ASCII.GetBytes(JSONlisting);
	
					rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString(),UserID, UserCode, UserSign, UserSignDT);
					rc.URL = Listing_URL + "Listing/" + listingCode;
					rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
					rc.RequestType = "application/json";  rc.ResponseType = "application/xml";
					rc.DataByte = dataByte;
					rs = rc.SendRequest();
	
					if (rs.State == RESTState.Success)
					{
						//--------------------------------------------------
						// LOGGING if ESSUPPORT Roles user edit the record
						//--------------------------------------------------
						if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
						{
							var SupportUserID =  HttpContext.Current.Session["easylist-SupportUsername"].ToString();
							if (!string.IsNullOrEmpty(SupportUserID))
							{
								Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(SupportUserID);
								if (userInfo != null)
								{
									if (userInfo.IsMemberOf("EasySales Admin") || userInfo.IsMemberOf("ESSupport")){
										Logging.AuditLog(SupportUserID, SecurityController.IPAddress,
											LogEvent.Create, "Listings", "User : " + SupportUserID + " create new listing " + listingCode, listingCode, UserCode);
									}
								}
							}
						}
						//--------------------------------------------------

						return "SUCCESS:" + listingCode;
					}
					else
					{
						throw new Exception(rs.Message);
	 				}*/

				}else
				{
   					log.Info("New temporary publis failed!! Error - " + rs.Message);
					throw new Exception(rs.Message);
	 			}
  
			}
			catch (Exception ex)
			{
				strErrMessage = ex.ToString();
				log.Error("New list payment failed! Error:" + ex.ToString());
			}
  			return strErrMessage;
		}

  		/// <summary>
        /// Create new temporary listing
        /// </summary>
        public string NewListingTempDraft(bool IsRetailUser)
        {	
			string strErrMessage = "";
			try
			{
				string UserID =  HttpContext.Current.Session["easylist-username"].ToString();

				if (HttpContext.Current.Session["easylist-userTempKey"] == null)
				{
					return "No temporary ID present!";
				}
				if (HttpContext.Current.Session["easylist-usercode"] == null)
				{
					return "User code not exists!";
				}

				log.Info("Publish new listing. IsRetailUser : " + IsRetailUser);
 				
				// Save draft listing
				var ErrMessage = NewListingTempSave(IsRetailUser, ListingStatus.Draft);
				if (!(ErrMessage.Substring(0,7) == "SUCCESS"))
				{
					return ErrMessage;
				}

 				// For Businesss user, save as draft will redirect to listing page, set listing as draft. Business user can have multiple draft listing
	 			// For retail user, save as draft will save at new listing page only. Only one draft can be save
				if (!IsRetailUser)
				{
					string UserTempKey = HttpContext.Current.Session["easylist-userTempKey"].ToString();

					string UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
					if (!IsRetailUser)
					{
						UserCode = HTTPFormHelpers.GetString("listing-usercode");
						if (string.IsNullOrEmpty(UserCode))
						{
							UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
						}
					}
	
					// Post to Server
					EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString());
					rc.URL = Listing_URL + string.Format("ListingTemp/Publish/{0}/{1}?LstStatus={2}",UserTempKey, UserCode, (int)ListingStatus.Draft);
					rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
					rc.RequestType = "application/json"; rc.ResponseType = "application/json";
					rc.DataByte = Encoding.ASCII.GetBytes("Publish"); // PUT Method must have some bytes array
							
					rs = rc.SendRequest();
	
					if (rs.State == RESTState.Success)
					{
						log.Info("Publish listing=> resutl " + rs.Result);
						// Set cookies ELID to empty, page load of listing creation will assign new temp id	
						// Don't reset ELID, possible if another dealer account access same browser having temp listing
						//HttpContext.Current.Response.Cookies["ELID"].Value = "";

						//--------------------------------------------------
						// LOGGING if ESSUPPORT Roles user edit the record
						//--------------------------------------------------
						if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
						{
							var SupportUserID =  HttpContext.Current.Session["easylist-SupportUsername"].ToString();
	
							if (!string.IsNullOrEmpty(SupportUserID))
							{
								Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(SupportUserID);
								if (userInfo != null)
								{
									if (userInfo.IsMemberOf("EasySales Admin") || userInfo.IsMemberOf("ESSupport")){
										Logging.AuditLog(SupportUserID, SecurityController.IPAddress,
											LogEvent.Create, "Listings", "User : " + SupportUserID + " create new listing " + rs.Result, rs.Result, UserCode);
									}
								}
							}
						}
						//--------------------------------------------------
	
						return "SUCCESS:" + rs.Result;
					}else
					{
						log.Info("New temporary save failed!! Error - " + rs.Message);
						throw new Exception(rs.Message);
					}
 				}else
				{
					return "SUCCESS:" + rs.Result;
				}
			}
			catch (Exception ex)
			{
				strErrMessage = ex.ToString();
				log.Error("New temporary Listing save as draft failed! Error:" + ex.ToString());
			}
  			return strErrMessage;
		}

		/// <summary>
        /// Create new temporary listing
        /// </summary>
        public string NewListingTempPublish(bool IsRetailUser)
        {	
			string strErrMessage = "";
			try
			{
				if (HttpContext.Current.Session["easylist-userTempKey"] == null)
				{
					return "No temporary ID present!";
				}
				if (HttpContext.Current.Session["easylist-usercode"] == null)
				{
					return "User code not exists!";
				}

				string UserTempKey = HttpContext.Current.Session["easylist-userTempKey"].ToString();

				log.Info("Publishing new listing : " + UserTempKey + ". User IsRetailUser : " + IsRetailUser);

 				// Save draft listing
				var ErrMessage = NewListingTempSave(IsRetailUser, ListingStatus.Draft);
				if (!(ErrMessage.Substring(0,7) == "SUCCESS"))
				{
					return ErrMessage;
				}
				
				string UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
				if (!IsRetailUser)
				{
					UserCode = HTTPFormHelpers.GetString("listing-usercode");
					if (string.IsNullOrEmpty(UserCode))
					{
						UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
					}
				}

				string UserID =  HttpContext.Current.Session["easylist-username"].ToString();

				// Post to Server
				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString());
 				rc.URL = Listing_URL + string.Format("ListingTemp/Publish/{0}/{1}?LstStatus={2}",UserTempKey,UserCode, (int)ListingStatus.InStock);
				rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
				rc.RequestType = "application/json"; rc.ResponseType = "application/json";
				rc.DataByte = Encoding.ASCII.GetBytes("Publish"); // PUT Method must have some bytes array
						
				rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					log.Info("Publish listing=> resutl " + rs.Result);
					// Set cookies ELID to empty, page load of listing creation will assign new temp id	
					// Don't reset ELID, possible if another dealer account access same browser having temp listing
					//HttpContext.Current.Response.Cookies["ELID"].Value = "";

					//--------------------------------------------------
					// LOGGING if ESSUPPORT Roles user edit the record
					//--------------------------------------------------
					if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
					{
						var SupportUserID =  HttpContext.Current.Session["easylist-SupportUsername"].ToString();

						if (!string.IsNullOrEmpty(SupportUserID))
						{
							Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(SupportUserID);
							if (userInfo != null)
							{
								if (userInfo.IsMemberOf("EasySales Admin") || userInfo.IsMemberOf("ESSupport")){
									Logging.AuditLog(SupportUserID, SecurityController.IPAddress,
										LogEvent.Create, "Listings", "User : " + SupportUserID + " create new listing " + rs.Result, rs.Result, UserCode);
								}
							}
						}
					}
					//--------------------------------------------------

					return "SUCCESS:" + rs.Result;
				}else
				{
   					log.Info("New temporary publis failed!! Error - " + rs.Message);
					throw new Exception(rs.Message);
	 			}	
			}
			catch (Exception ex)
			{
				strErrMessage = ex.ToString();
				log.Error("New temporary Listing publish failed! Error:" + ex.ToString());
			}
  			return strErrMessage;
		}

		public XPathNodeIterator GetCatInfo(string CatPath)
        {
			XPathNodeIterator nodeIterator = null;
			try
			{
 				//log.Info("CatPath : " + CatPath);

				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
				rc.URL = URL + "Category/CatInfo?CatPath=" + CatPath;
				rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
				rc.RequestType = "application/xml";
				rc.ResponseType = "application/xml";

				rs = rc.SendRequest();
				
				if (rs.State == RESTState.Success)
				{
  					//log.Info(rs.Result);
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
				}
				else
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Error " + rs.Message);
					log.Debug("Listing. Error:" + rs.Message);
				}
			}
			catch (Exception ex)
			{
				log.Error("GetCatInfo failed! Error:" + ex.ToString());
			}
			return nodeIterator;
        }

		public XPathNodeIterator GetUserCatalog(string UserCode)
        {
			XPathNodeIterator nodeIterator = null;
			nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
			try
			{
				var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
 				//var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();

				var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();	

				log.Debug("Get User Catalog : " + UserCode);

				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString(), UserID, UserCode, UserSign, UserSignDT);
				rc.URL = URL + "Catalog/" + UserCode;
				rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
				rc.RequestType = "application/xml";
				rc.ResponseType = "application/xml";
	
				rs = rc.SendRequest();
				
				if (rs.State == RESTState.Success)
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
  					//log.Debug("Get Listing Success " + nodeIterator.Current.SelectSingleNode("/ListingsRestInfo/Code").Value);
				}
				else
				{
  					//nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Error " + rs.Message);
					log.Debug("Listing. Error:" + rs.Message);
  					// Just return empty list
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
				}
			}			
			catch (Exception ex)
			{
				log.Error("Read reading user profile! Error:" + ex.ToString());
			}
			return nodeIterator;
		}

		//------------------------------------------------------------------------------------------------------
  		//	Listing entity
		//------------------------------------------------------------------------------------------------------
        /// <summary>
        /// Gets the edit data for a listing
        /// </summary>
		public XPathNodeIterator GetListingEditData(string listingCode, string UserID, string UserCode, string UserSign, string UserSignDT, bool IsRetailUser = true)
        {
			XPathNodeIterator nodeIterator = null;
			try
			{
				log.Debug("Get Listing for Edit : " + listingCode);
	
				//**************************** 
				// ***** PROBLEM SAVE EasyListEditItem.xslt when using Session. Why....
				//UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				// var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				// var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();	
				//**************************** 
				
 				// Ads draft listing for retail user should not able to view and delete!
				Guid LstCodeGuid = new Guid();
				if (Guid.TryParse(listingCode, out LstCodeGuid))
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Unauthorized access!");
					return nodeIterator;
				}

 				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 				// Impersonate as Suppport User
				/*if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
				{
					if (!string.IsNullOrEmpty(HttpContext.Current.Session["easylist-SupportUsername"].ToString()))
						UserID = HttpContext.Current.Session["easylist-SupportUsername"].ToString();
				}*/
				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString(), UserID, UserCode, UserSign, UserSignDT);
				rc.URL = Listing_URL + "Listing/" + listingCode;
				rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
				rc.RequestType = "application/xml";
				rc.ResponseType = "application/xml";
				
				log.Info(rc.URL);
				rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
					log.Debug("Get Listing Success " + nodeIterator.Current.SelectSingleNode("/ListingsRestInfo/Code").Value);
				}
				else
				{

					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Error " + rs.Message);
					log.Debug("Listing. Error:" + rs.Message);
				}
			}
			catch (Exception ex)
			{
				log.Error("Read listing edit failed! Error:" + ex.ToString());
			}
			return nodeIterator;
        }

 		public string CustomListingHTML(long CatID, string listingCode)
        {
            string CustomListingHTML = "";
            try
            {
				string UserCode = ""; 
				if (HttpContext.Current.Session["easylist-usercode"] != null)
				{
					UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
				}

 				//log.Info("=>" + CustomXMLAttr);
                EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
                rc.URL = URL + "Category/CatUI?CatID=" + CatID + "&Mode=EDIT&ListingCode=" + listingCode + "&UserCode=" + UserCode;
				log.Info("rc.URL=>" + rc.URL);
                rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
                rc.RequestType = "application/xml";
                rc.ResponseType = "application/xml";

                rs = rc.SendRequest();

                if (rs.State == RESTState.Success)
                {
					CustomListingHTML = rs.Result;
                    log.Info("HTML " + rs.Result);
                }
                else
                {
                    log.Info("Failed! Error " + rs.Message);
                }
            }
            catch (Exception ex)
            {
                log.Error("CustomListingHTML failed! Error : " + ex.ToString());
            }
            return CustomListingHTML;
        }

		public string CustomListingHTMLNew(string CatPath)
        {
            string CustomListingHTML = "";
            try
            {
 				//log.Info("=>" + CustomXMLAttr);
                EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
                rc.URL = URL + "Category/CatUI?CatPath=" + CatPath + "&Mode=NEW";
				log.Info("rc.URL=>" + rc.URL);
                rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
                rc.RequestType = "application/xml";
                rc.ResponseType = "application/xml";

                rs = rc.SendRequest();

                if (rs.State == RESTState.Success)
                {
					CustomListingHTML = rs.Result;
                    log.Info("HTML " + rs.Result);
                }
                else
                {
                    log.Info("Failed! Error " + rs.Message);
                }
            }
            catch (Exception ex)
            {
                log.Error("CustomListingHTMLNew failed! Error : " + ex.ToString());
            }
            return CustomListingHTML;
        }

      

        /// <summary>
        /// Updates a listing
        /// </summary>
        public string NewListing()
        {	
			string strErrMessage = "";
			try
			{
				var listingCategory = HTTPFormHelpers.GetString("listing-UIEditorLink");
				log.Info("Category " + listingCategory);
	
				//throw new Exception("Test error handling -" + listingCategory);

				string HttpRequestParam = HTTPRequest.GetHTTPRequestParams(HttpContext.Current.Request);
				log.Info("Param List - " + HttpRequestParam);
 			
				var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
				var UserCode = HttpContext.Current.Session["easylist-usercode"].ToString();
				var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();

				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 				// Impersonate as Suppport User
				/*if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
				{
					if (!string.IsNullOrEmpty(HttpContext.Current.Session["easylist-SupportUsername"].ToString()))
					{
						UserID = HttpContext.Current.Session["easylist-SupportUsername"].ToString();
					}
				}*/
				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

				//--------------------------------------------------------------------------
  				// Server side validation
				//--------------------------------------------------------------------------
				if (String.IsNullOrEmpty(UserID)||String.IsNullOrEmpty(UserCode)||String.IsNullOrEmpty(UserSign)||String.IsNullOrEmpty(UserSignDT))
				{
	 				return "Invalid Dealer ID/User session! Please try to login again!";
				}
				Decimal Price = 0;
           		if (!Decimal.TryParse(HTTPFormHelpers.GetString("listing-price"), out Price))
				{
					return "Invalid Price value " + HTTPFormHelpers.GetString("listing-price");
				}

				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-title")))
				{
					return "Please enter valid Title!";
				}

				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-summary")))
				{
					return "Please enter valid Summary Description!";
				}
 				log.Info("Listing-desc => " + HTTPFormHelpers.GetString("listing-description"));
				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-description")))
				{
					return "Please enter valid Full Description!";
				}

				if (HTTPFormHelpers.GetIntNotNull("listing-category-id") == 0)
				{
					return "Please select category for your item!";
				}
				
				log.Info("Creating new listing...");

				//============================================================================================================
 				// Listing Info
				//============================================================================================================
	 			Dictionary<string, object> listing = new Dictionary<string, object>();

				listing.Add("CatID", HTTPFormHelpers.GetIntNotNull("listing-category-id"));
 				// Server will process LstType, CatPath by passing CatID only
		
				listing.Add("UserCode", UserCode);
 				// Server to process UserID

            	listing.Add("SrcName", "EasyListDashBoard");
            	listing.Add("Title", HTTPFormHelpers.GetString("listing-title"));
				
				listing.Add("SumDesc", HTTPFormHelpers.GetString("listing-summary"));
				
				listing.Add("Price", Price);
				
				listing.Add("PriceQualifier", HTTPFormHelpers.GetString("listing-price-attribute"));
				listing.Add("Desc", HTTPFormHelpers.GetString("listing-description"));
				
				/*string ConditionSource = HTTPFormHelpers.GetString("listing-condition");
				if (ConditionSource.IndexOf('|') > 0)
				{
					var ConditionArray = ConditionSource.Split('|');
					listing.Add("Condition", ConditionArray[0]);
					listing.Add("ConditionDesc", ConditionArray[1]);
				}
				else
				{
					listing.Add("Condition", ConditionSource);
				}*/

				string Condition = HTTPFormHelpers.GetString("listing-condition");
				listing.Add("Condition", Condition);
				if (Condition == "New")
				{
					listing.Add("ConditionDesc", "");
				}else
				{
					listing.Add("ConditionDesc", HTTPFormHelpers.GetString("listing-condition-desc"));
				}

				listing.Add("DateCreated", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow).ToString() + ")/");
				listing.Add("PubDate", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow).ToString() + ")/");
				listing.Add("DateEdited", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow).ToString() + ")/");

                // Listing is either active/inactive, temporary add 10 years
				listing.Add("UnpubDate", "/Date(" + Utils.ToUnixTimespanMiliSeconds(DateTime.UtcNow.AddYears(1)).ToString() + ")/");
				listing.Add("IsHidden", false);

				var SellingType = "1"; // Private (Default)
				if (!IsRetailUser())
				{
  					SellingType = "2";	// Business
				}
				listing.Add("SellingType", SellingType);

 				// If it is vehicle (Car/Motorcycle)
				//--------------------------------------------------------------------------
 				// Vehicles
				//--------------------------------------------------------------------------
				if (listingCategory == "AutomotiveListing")
				{
					Dictionary<string, object> v = new Dictionary<string, object>();
					v.Add("Make", HTTPFormHelpers.GetString("listing-make"));
					v.Add("Model", HTTPFormHelpers.GetString("listing-model"));
					v.Add("Year", HTTPFormHelpers.GetString("listing-year"));
					v.Add("BodyStyle", HTTPFormHelpers.GetString("listing-body-style"));
					v.Add("TrmType", HTTPFormHelpers.GetString("vehicle-transmission-type"));
					v.Add("TrmDesc", HTTPFormHelpers.GetString("listing-transmission"));
					v.Add("Variant", HTTPFormHelpers.GetString("listing-variant"));
					v.Add("NVIC", HTTPFormHelpers.GetString("vehicle-nvic"));
					v.Add("Doors", HTTPFormHelpers.GetIntNotNull("vehicle-doors"));
					v.Add("Seats", HTTPFormHelpers.GetIntNotNull("vehicle-seats"));
					v.Add("DriveType", HTTPFormHelpers.GetString("vehicle-drive-type"));
					v.Add("EngType", HTTPFormHelpers.GetString("vehicle-engine-type"));
					v.Add("EngDesc", HTTPFormHelpers.GetString("vehicle-engine-cc"));
					v.Add("EngSizeDesc", HTTPFormHelpers.GetString("vehicle-engine-size"));
					v.Add("EngCylinders", HTTPFormHelpers.GetString("vehicle-engine-cylinders"));
					v.Add("FuelType", HTTPFormHelpers.GetString("vehicle-fuel-type"));
					v.Add("FuelTypeDesc", HTTPFormHelpers.GetString("vehicle-fuel-type"));
		
					//*************************************************************************
					// Fields yet to map	
					//*************************************************************************
					//vehicle-price-1=34000 , 
					//vehicle-price-2=28200 ,
					//vehicle-vin=ZFA31200012345678 , 
					//vehicle-transmission-info=5 SP AUTOMATED MANUA , 
					//vehicle-fuel-highway=0 , 
					//vehicle-fuel-city=6.5 , 
					//vehicle-valve-gear=DUAL OVERHEAD CAM , 
					//*************************************************************************
	
					 //----------------------
					// Automotive Features
					//----------------------
					if (listingCategory != "GM")
					{
						List<AutomotiveFeatureInfo> AutoFeatures = new List<AutomotiveFeatureInfo>();
						
						// Standard Features
						string ListStdFeatures = HTTPFormHelpers.GetString("stdFeature");
						if(!String.IsNullOrEmpty(ListStdFeatures))
						{
							var StdFeaturesArray = Utils.StringDelimitedToObjectArray(ListStdFeatures, ',');
							foreach (var sf in StdFeaturesArray)
							{
								AutoFeatures.Add(new AutomotiveFeatureInfo { FeatureType = "standard", Feature = sf.ToString() });
							}
						}
						// Optional Features
						string ListOptFeatures = HTTPFormHelpers.GetString("optFeature");
						if(!String.IsNullOrEmpty(ListOptFeatures))
						{
							var OptFeaturesArray = Utils.StringDelimitedToObjectArray(ListOptFeatures, ',');
							foreach (var sf in OptFeaturesArray)
							{
								AutoFeatures.Add(new AutomotiveFeatureInfo { FeatureType = "optional", Feature = sf.ToString() });
							}
						}
		
						if (AutoFeatures.Count > 0)
						{
							var AutoFeaturesXML = Utils.ObjectToXML(AutoFeatures).Remove(0,1);
							v.Add("VehicleFeaturesXML", AutoFeaturesXML);
						}
		
						listing.Add("VehicleListing", v);
					}
				}
				else if (listingCategory == "MotorcycleListing")
				{
					Dictionary<string, object> v = new Dictionary<string, object>();
					v.Add("Make", HTTPFormHelpers.GetString("listing-Motor-make"));
					v.Add("Model", HTTPFormHelpers.GetString("listing-Motor-model"));
					v.Add("Variant", HTTPFormHelpers.GetString("listing-motor-variant"));
					v.Add("Year", HTTPFormHelpers.GetString("listing-Motor-year"));

					v.Add("BodyStyle", HTTPFormHelpers.GetString("vehicle-Motor-Styles"));
					v.Add("NVIC", HTTPFormHelpers.GetString("vehicle-Motor-NVIC"));
					v.Add("TrmDesc", HTTPFormHelpers.GetString("vehicle-Motor-Transmission"));
					v.Add("EngType", HTTPFormHelpers.GetString("vehicle-Motor-Engine"));
					v.Add("EngDesc", HTTPFormHelpers.GetString("vehicle-Motor-EngineCC"));
					v.Add("EngCylinders", HTTPFormHelpers.GetString("vehicle-Motor-Cylinder"));

					listing.Add("VehicleListing", v);
				}
				else if (listingCategory == "GM")
				{
					int CatID = HTTPFormHelpers.GetIntNotNull("listing-category-id");
					
					if (CatID != 0)
					{
						Categories catInfo = EasyList.Dashboard.Helpers.Category.GetCatInfo(CatID);
	  					log.Info("CatID ==> " + CatID);
						List<AttributeInfo> CustomAttr = new List<AttributeInfo>(); 
						if ((catInfo != null) && !string.IsNullOrEmpty(catInfo.catAttrUIXML))
						{
							var catAttrUIXML = Utils.XMLToObject<List<CustomWebControls>>(catInfo.catAttrUIXML);
	
							foreach (var CatAttr in catAttrUIXML)
							{
								var XMLAttrVal = HTTPFormHelpers.GetString(CatAttr.XMLAttributeName);
						
								switch (CatAttr.WebControlType.ToString())
								{
									case "Textarea":
									case "TextBox":
									case "DropDown":
										
										if (!string.IsNullOrEmpty(XMLAttrVal)) CustomAttr.Add(new AttributeInfo { Name = CatAttr.XMLAttributeName, Value = XMLAttrVal });
										break;
									case "Checkbox":	
									case "Radio":
										string[] AttrValList = XMLAttrVal.Split(',');
										CustomAttr.Add(new AttributeInfo { Name = CatAttr.XMLAttributeName, Value = XMLAttrVal });
	 
										break;
	
									default:
										break;
								}
							}
							if (CustomAttr.Count > 0)
							{
								listing.Add("XmlDataType", "CustomAttributes");
								listing.Add("XmlData", Utils.ObjectToXML(CustomAttr));
							}					
						}
					}
				}

				// Convert from Object to JSON
            	string JSONlisting = Utils.ObjectToJSON(listing);
            	byte[] dataByte = Encoding.ASCII.GetBytes(JSONlisting);

				// Post to Server
				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.POST.ToString(),UserID, UserCode, UserSign, UserSignDT);
				rc.URL = Listing_URL + "Listing/";
				rc.RequestMethod = EasyListRestClient.HttpMethod.POST;
				rc.RequestType = "application/json"; rc.ResponseType = "application/json";
				rc.DataByte = dataByte;
				
				rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					
					log.Info("New Listing save successfully! New Listing Code " + rs.Result);

					//--------------------------------------------------
					// LOGGING if ESSUPPORT Roles user edit the record
					//--------------------------------------------------
					if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
					{
						var SupportUserID =  HttpContext.Current.Session["easylist-SupportUsername"].ToString();
				
						if (!string.IsNullOrEmpty(SupportUserID))
						{
							Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(SupportUserID);
							if (userInfo != null)
							{
								if (userInfo.IsMemberOf("EasySales Admin") || userInfo.IsMemberOf("ESSupport")){
									Logging.AuditLog(SupportUserID, SecurityController.IPAddress,
										LogEvent.Create, "Listings", "User : " + SupportUserID + " create new listing " + rs.Result, rs.Result, UserCode);
								}
							}
						}
					}
					//--------------------------------------------------

					return "SUCCESS:" + rs.Result;
				}
				else
				{
					log.Info("New Listing saving failed!! Error - " + rs.Message);
					throw new Exception(rs.Message);
				}
			}
			catch (Exception ex)
			{
				strErrMessage = ex.ToString();
				log.Error("New Listing saving failed! Error:" + ex.ToString());
			}
  			return strErrMessage;
		}
		
		/// <summary>
        /// Updates a listing
        /// </summary>
        public string UpdateListingStatus(string ListingStatusAction)
        {
			string strErrMessage = "";
			try
			{
				var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
				var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();	
				var listingCode = HTTPFormHelpers.GetString("listing-code");

				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 				// Impersonate as Suppport User
				/*if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
				{
					if (!string.IsNullOrEmpty(HttpContext.Current.Session["easylist-SupportUsername"].ToString()))
					{
						UserID = HttpContext.Current.Session["easylist-SupportUsername"].ToString();
					}
				}*/
				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				
				//--------------------------------------------------------------------------
  				// Server side validation
				//--------------------------------------------------------------------------
				if (String.IsNullOrEmpty(UserID)||String.IsNullOrEmpty(UserCode)||String.IsNullOrEmpty(UserSign)||String.IsNullOrEmpty(UserSignDT))
				{
	 				return "Invalid Dealer ID/User session! Please try to login again!";
				}

				if (String.IsNullOrEmpty(listingCode))
				{
					return "Invalid Listing Code!";
				}

				List<NameValuePair> nvList = new List<NameValuePair>();
                NameValuePair nvitem = new NameValuePair();

				//--------------------------------------------------------------------------
  				// General attributes
				//--------------------------------------------------------------------------
				if (ListingStatusAction == "Cancel-Ad")
				{
					log.Info("User code : " + UserCode + " mark listing " + listingCode + " as cancel.");
					nvList.Add(new NameValuePair { Name = "ListingStatusID", Value = (int)ListingStatus.Cancelled  });
					nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now });
					nvList.Add(new NameValuePair { Name = "DateEdited", Value = DateTime.Now });
				}
				else if (ListingStatusAction == "Extend-Ad")
				{	
					log.Info("User code : " + UserCode + " mark listing " + listingCode + " as ex-tends.");
					nvList.Add(new NameValuePair { Name = "ListingStatusID", Value = (int)ListingStatus.InStock });
					nvList.Add(new NameValuePair { Name = "PubDate", Value = DateTime.Now });
					nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now.AddYears(1)  });
					nvList.Add(new NameValuePair { Name = "DateEdited", Value = DateTime.Now });
				}
				else if (ListingStatusAction == "Sold")
				{	
					log.Info("User code : " + UserCode + " mark listing " + listingCode + " as sold.");
					nvList.Add(new NameValuePair { Name = "ListingStatusID", Value = (int)ListingStatus.Sold });
					nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now });
					nvList.Add(new NameValuePair { Name = "DateEdited", Value = DateTime.Now });
				}
                else if (ListingStatusAction == "Relist-Ad")
                {
                    log.Info("User code : " + UserCode + " mark listing " + listingCode + " as relist.");
					nvList.Add(new NameValuePair { Name = "ListingStatusID", Value = (int)ListingStatus.InStock });
					nvList.Add(new NameValuePair { Name = "PubDate", Value = DateTime.Now });
					nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now.AddYears(1) });
					nvList.Add(new NameValuePair { Name = "DateEdited", Value = DateTime.Now });
                }
				else if (ListingStatusAction == "Withdrawn")
				{	
					log.Info("User code : " + UserCode + " mark listing " + listingCode + " as withdrawn.");
					nvList.Add(new NameValuePair { Name = "ListingStatusID", Value = (int)ListingStatus.Withdrawn });
					nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now });
					nvList.Add(new NameValuePair { Name = "DateEdited", Value = DateTime.Now });
				}
                
				// Convert from Object to JSON
                string JSONlisting = EasyList.Common.Helpers.Utils.ObjectToJSON(nvList);
            
				byte[] dataByte = Encoding.ASCII.GetBytes(JSONlisting);

				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString(),UserID, UserCode, UserSign, UserSignDT);
            	rc.URL = Listing_URL + "Listing/" + listingCode;
            	rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
            	rc.RequestType = "application/json";  rc.ResponseType = "application/xml";
				rc.DataByte = dataByte;
            	rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					log.Info("Listing " + listingCode + " updated successfully!");

					//--------------------------------------------------
					// LOGGING if ESSUPPORT Roles user edit the record
					//--------------------------------------------------
					if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
					{
						var SupportUserID =  HttpContext.Current.Session["easylist-SupportUsername"].ToString();
					
						if (!string.IsNullOrEmpty(SupportUserID))
						{
							Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(SupportUserID);
							if (userInfo != null)
							{
								if (userInfo.IsMemberOf("EasySales Admin") || userInfo.IsMemberOf("ESSupport")){
									Logging.AuditLog(SupportUserID, SecurityController.IPAddress,
										LogEvent.Update, "Listings", "User : " + SupportUserID + " update listing " + listingCode + " change status to " + ListingStatusAction, listingCode, UserCode);
								}
							}
						}
					}
					//--------------------------------------------------
				}
				else
				{
					throw new Exception(rs.Message);
				}
			}
			catch (Exception ex)
			{
				strErrMessage = ex.ToString();
				log.Error("Update Listing status failed! Error:" + ex.ToString());
			}
			finally
			{
				
			}
			return strErrMessage;
        }

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
				
				Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);
				if (userInfo == null)
				{
					return false;
				}
				
				if (userInfo.IsMemberOf("RetailUser"))
				{
					return true;
				}
				
			}
			catch (Exception ex)
			{
				log.Error("IsRetailUser function failed! Error:" + ex.ToString());
			}
			return IsRetailUser;
		}
     
        /// <summary>
        /// Updates a listing
        /// </summary>
        public string UpdateListing(string ListingStatusAction)
        {
			string strErrMessage = "";
			try
			{
				IRepository repo = RepositorySetup.Setup();

				var UserID =  HttpContext.Current.Session["easylist-username"].ToString();
				var UserCode =  HttpContext.Current.Session["easylist-usercode"].ToString();
				var UserSign = HttpContext.Current.Session["easylist-userSignature"].ToString();
				var UserSignDT = HttpContext.Current.Session["easylist-userSignatureDT"].ToString();	
				var listingCode = HTTPFormHelpers.GetString("listing-code");

				var listingUserCode = HTTPFormHelpers.GetString("listing-usercode");

				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 				// Impersonate as Suppport User
				/*if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
				{
					if (!string.IsNullOrEmpty(HttpContext.Current.Session["easylist-SupportUsername"].ToString()))
					{	
						UserID = HttpContext.Current.Session["easylist-SupportUsername"].ToString();
					}
				}*/
				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

				var listingType = HTTPFormHelpers.GetString("listing-type");
				var listingCatID = HTTPFormHelpers.GetIntNotNull("listing-category-id");

				bool RetailUser = IsRetailUser();

				//--------------------------------------------------------------------
				// Business user user code selectiion
				//--------------------------------------------------------------------
				if (!RetailUser)
				{
					if (!String.IsNullOrEmpty(listingUserCode)){
						UserCode = listingUserCode;
					}

					var HasException = HTTPFormHelpers.GetString("listing-has-exception");

					if (listingType == "Car" || listingType == "Motorcycle")
					{
						if (!String.IsNullOrEmpty(HasException) && HasException == "true")
						{
							return "Please use the 'Fix Listing Specs' button to fix warning and exception.";
						}
					}
				}

				// Read the existing listing
				//--------------------------------------------------------------------------
  				// Server side validation
				//--------------------------------------------------------------------------

				if (String.IsNullOrEmpty(UserID)||String.IsNullOrEmpty(UserCode)||String.IsNullOrEmpty(UserSign)||String.IsNullOrEmpty(UserSignDT))
				{
	 				return "Invalid Dealer ID/User session! Please try to login again!";
				}

				if (String.IsNullOrEmpty(listingCode))
				{
					return "Invalid Listing Code!";
				}
	
				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-title")))
				{
					return "Please enter valid Title!";
				}

				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-summary")))
				{
					return "Please enter valid Summary Description!";
				}

				if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-description")))
				{
					return "Please enter valid Full Description!";
				}

				var RegExpMonth = HTTPFormHelpers.GetString("listing-vehicle-expiry-month");
				if (!String.IsNullOrEmpty(RegExpMonth))
				{
					int RegExpMonthNo = 0;
					if (!int.TryParse(RegExpMonth, out RegExpMonthNo)){
						return "Please enter valid expiry month!";
					}
				}

				var RegExpYear = HTTPFormHelpers.GetString("listing-vehicle-expiry-year");
				
				if (!String.IsNullOrEmpty(RegExpYear))
				{
					int RegExpYearNo = 0;
					if (!int.TryParse(RegExpYear, out RegExpYearNo)){
						return "Please enter valid expiry year!";
					}
				}

 				//-----------------------------------------------------------------------------
 				// Price Validation
				//-----------------------------------------------------------------------------
				//decimal Price = HTTPFormHelpers.GetPriceNotNull("listing-price");
 				//if (Price == 0){ return "Please enter valid Price!";}
				decimal Price = 0;

				Decimal PriceDriveAway = 0;
				Decimal PriceSale = 0;
				Decimal PriceUnqualified = 0;
				
				string PriceType = "";
				string PriceInfoXML = "";

				var HasPrice = HTTPFormHelpers.GetBool("listing-has-price");

				PriceType = HTTPFormHelpers.GetString("listing-price-qualifier");

				if (RetailUser || !(listingCatID == 60 || listingCatID == 67 || listingCatID == 80 || listingCatID == 600 || listingCatID == 601))
				{
					if (RetailUser || (!RetailUser && HasPrice))
					{
						if (!Decimal.TryParse(HTTPFormHelpers.GetString("listing-price"), out Price))
						{
							return "Invalid Current Price value " + HTTPFormHelpers.GetString("listing-price");
						}

   						// Required field for retail user
						if (Price == 0)
						{
							return "Please enter Price value";
						}
					}
				}
				else
 				//if ((!RetailUser) && (listingCatID == 60 || listingCatID == 67 || listingCatID == 80 || listingCatID == 600 || listingCatID == 601))
				{
					// Price list for Commercial customer
					PriceDriveAway = HTTPFormHelpers.GetPriceNotNull("listing-driveaway-price");
					PriceSale = HTTPFormHelpers.GetPriceNotNull("listing-sale-price");
					PriceUnqualified = HTTPFormHelpers.GetPriceNotNull("listing-unqualified-price");

					var PriceDriveAwayLx = HTTPFormHelpers.GetBool("lock-driveaway-price");
					var PriceSaleLx = HTTPFormHelpers.GetBool("lock-sale-price");
					var PriceUnqualifiedLx = HTTPFormHelpers.GetBool("lock-unqualified-price");
					
					if (HasPrice && PriceDriveAway == 0 && PriceSale == 0 && PriceUnqualified == 0)
					{
						return "Please enter price value for Drive away price, Sale price or Unqualified price";
					}

  					//-------------------------------------------------------------------------------------------
  					// Choose which price info to set
					//-------------------------------------------------------------------------------------------
					if (PriceDriveAway != 0)
					{
						Price = PriceDriveAway;
						PriceType = PricingType.DriveAway.ToString();
					} 
					else if (PriceSale != 0)
					{
						Price = PriceSale;
   						//PriceType = PricingType.Sale.ToString();
					} 
					else if (PriceUnqualified != 0)
					{
						Price = PriceUnqualified;
   						//PriceType = PricingType.Unqualified.ToString();
					}

					//-------------------------------------------------------------------------------------------
  					// Store price info as XML
					//-------------------------------------------------------------------------------------------
					var PriceXML = new List<PricingInfo>(); 
					PriceXML.Add(new PricingInfo { PriceType = PricingType.DriveAway, Amount = PriceDriveAway, Lock = PriceDriveAwayLx });
					PriceXML.Add(new PricingInfo { PriceType = PricingType.Sale, Amount = PriceSale, Lock = PriceSaleLx });
					PriceXML.Add(new PricingInfo { PriceType = PricingType.Unqualified, Amount = PriceUnqualified, Lock = PriceUnqualifiedLx });
					
					PriceInfoXML = Utils.ObjectToXML(PriceXML);

				}
				
				var exListing = repo.Single<Listings>(l => l.Code == listingCode);

				//--------------------------------------------------------------------
				// Price control for retail user
				//--------------------------------------------------------------------
				if (RetailUser)
				{

					// Version 1 :-
  					//-----------------------
					//If priority package, can only edit above and below RM500
					//If standard package, can only edit below RM500
					//Apply to New & Old TP ads
					
					// Version 2 :-
					//-----------------------
					//No matter which package user choose, if do not need to pay for the listing, cannot change price above $500, apply to New & Old TP ads
					//if (exListing.LstPackage == null || (exListing.LstPackage == 1 && exListing.LstAmount == 0))

					// Version 3 (20130912):-
					//-----------------------
					//No matter which package user choose, if do not need to pay for the listing, cannot increase price, apply to ad created in EL Dashboard only (New TP)
					//if ((exListing.SrcName == "EasyListDashBoard") && (exListing.LstAmount == null || exListing.LstAmount == 0))
					
					// Version 4 (20131219) :-
					//-----------------------
					//No matter which package user choose, and whether user pay for listing or not, cannot increase price, apply to ad created in EL Dashboard only (New TP)
  					
					// Version 5 (20130210) :-
					//-----------------------
					if (exListing.SrcName == "EasyListDashBoard")
					{	
	  					/*if (Price > (decimal)exListing.Price)
						{
							return "Not allow to increase the price";
	  					}*/

						var ValidCoupon = "";
						var CouponCode = "";
						var AttributeInfo = new List<AttributeInfo>();
						if (!string.IsNullOrEmpty(exListing.AttributesXml))
						{
							AttributeInfo = Utils.XMLToObject<List<AttributeInfo>>(exListing.AttributesXml);
							
							ValidCoupon = AttributeInfo.Where(e => e.Name == "ValidCoupon").FirstOrDefault() == null?
									"":
									AttributeInfo.Where(e => e.Name == "ValidCoupon").FirstOrDefault().Value.ToString()
									;
							if (ValidCoupon == null) ValidCoupon = "";

							CouponCode = AttributeInfo.Where(e => e.Name == "CouponCode").FirstOrDefault() == null?
									"":
									AttributeInfo.Where(e => e.Name == "CouponCode").FirstOrDefault().Value.ToString()
									;
							if (CouponCode == null) CouponCode = "";
						}

						if ((exListing.LstAmount > 0) || (ValidCoupon == "true" && !string.IsNullOrEmpty(CouponCode)))
						{
							// Allow to decrease and increase price
						}
						else
						{
							if (Price < 0 || Price >= 500)
							{
								return "You can only change price in between 0 to 500.";
							}
						}
					}
				}
				//--------------------------------------------------------------------
				

				//--------------------------------------------------------------------
				// Feed in exception validation for commercial customer only
				//-------------------------------------------------------------------- 
				var FeedInExceptionList = new List<DataFeedException>();

				if (!RetailUser)
				{
					if (!string.IsNullOrEmpty(exListing.FeedInExceptionXML))
                	{	
						FeedInExceptionList = Utils.XMLToObject<List<DataFeedException>>(exListing.FeedInExceptionXML);
 						var FeedInFuelTypeExp = FeedInExceptionList.Where(e => e.ExCol == "FuelType").FirstOrDefault();

   						// If there is an exception for FuelType, user must choose a fuel type
						if (FeedInFuelTypeExp != null)
						{
							if (string.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-fuel-type-description")))
							{
								return "Please choose fuel type!";
							}
						}
					}
				}

 				//if (Price == 0){ return "Please enter valid Price!";}
				
				if (!String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-was-price"))){
					decimal WasPrice = HTTPFormHelpers.GetPriceNotNull("listing-was-price");
  					//if (WasPrice == 0){ return "Please enter valid Was Price!";}
				}

				if (!String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-doors"))){
					int Doors = HTTPFormHelpers.GetIntNotNull("listing-doors");
  					//if (Doors == 0){ return "Please enter valid Doors!";}
				}
				if (!String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-seats"))){
					int Seats = HTTPFormHelpers.GetIntNotNull("listing-seats");
  					//if (Seats == 0){ return "Please enter valid Seats!";}
				}
				if (!String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-odometer-value"))){
					int Odometer = HTTPFormHelpers.GetIntNotNull("listing-odometer-value");

				    //if (Odometer == 0){ return "Please enter valid Odometer!";}
				    //log.Info( "O" + HTTPFormHelpers.GetString("listing-odometer-unit"));
					
					if (Odometer != 0)
					{
						if (String.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-odometer-unit"))){
							return "Please select Odometer Unit!";
						}
					}
				}

				string LocRegion = "";
                string LocState = "";
				int LocPostcodeNo = 0;

                var ErrMessage = getLocInfo(HTTPFormHelpers.GetString("listing-location"), out LocRegion, out LocState, out LocPostcodeNo);
				if (ErrMessage != "")
					return ErrMessage;

				//--------------------------------------------------------------------------

				log.Info("Updating Listing Code data " + listingCode);
				//============================================================================================================
 				// Listing Info
				//============================================================================================================
 				// REMARKS: Body content have to be JSON instead of XML, XML have issue posting ampersand in field value
				
			    List<NameValuePair> nvList = new List<NameValuePair>();
                NameValuePair nvitem = new NameValuePair();

				//--------------------------------------------------------------------------
  				// General attributes
				//--------------------------------------------------------------------------
				nvList.Add(new NameValuePair { Name = "USERIPADDRESS", Value = SecurityController.GetIPAddress() });

				//--------------------------------------------------------------------------
  				// General attributes
				//--------------------------------------------------------------------------
				var LstCatalog = HTTPFormHelpers.GetString("listing-catalog");
				nvList.Add(new NameValuePair { Name = "CatalogID", Value = LstCatalog });
			
				// Set Hotlist ID based on Catalog ID
				if (!String.IsNullOrEmpty(LstCatalog))
				{
                    var lcInfo = repo.Single<ListingCatalog>(c => c.HotlistUUID == LstCatalog);
                    if (lcInfo != null)
                    {
						nvList.Add(new NameValuePair { Name = "CatalogHotlistID", Value = lcInfo.HotlistID });
                    }
                }
				else
				{
					nvList.Add(new NameValuePair { Name = "CatalogHotlistID", Value = "" });
				}

				if (!RetailUser)
				{
					if (!String.IsNullOrEmpty(listingUserCode)){
						nvList.Add(new NameValuePair { Name = "UserCode", Value = listingUserCode });
					}
				}

				nvList.Add(new NameValuePair { Name = "Title", Value = HTTPFormHelpers.GetString("listing-title") });
				nvList.Add(new NameValuePair { Name = "SumDesc", Value = HTTPFormHelpers.GetString("listing-summary") });
				
				nvList.Add(new NameValuePair { Name = "Desc", Value = HTTPFormHelpers.GetString("listing-description-textonly") });
				nvList.Add(new NameValuePair { Name = "DescWSYIWYG", Value = HTTPFormHelpers.GetString("listing-description") });

				nvList.Add(new NameValuePair { Name = "Price", Value = Price });
				nvList.Add(new NameValuePair { Name = "WasPrice", Value = HTTPFormHelpers.GetPriceNotNull("listing-was-price") });

				nvList.Add(new NameValuePair { Name = "PriceType", Value = PriceType });
				nvList.Add(new NameValuePair { Name = "PriceInfoXML", Value = PriceInfoXML });

				nvList.Add(new NameValuePair { Name = "PriceQualifier", Value = HTTPFormHelpers.GetString("listing-price-qualifier") });
				
				nvList.Add(new NameValuePair { Name = "Condition", Value = HTTPFormHelpers.GetString("listing-condition") });
				if (HTTPFormHelpers.GetString("listing-condition") == "New")
				{
					nvList.Add(new NameValuePair { Name = "ConditionDesc", Value = "" });
				}else
				{
					nvList.Add(new NameValuePair { Name = "ConditionDesc", Value = HTTPFormHelpers.GetString("listing-condition-desc") });
				}

				if (!string.IsNullOrEmpty(ListingStatusAction))
				{
					if (ListingStatusAction == "Extend-Ad")
					{
						nvList.Add(new NameValuePair { Name = "ListingStatusID", Value = (int)ListingStatus.InStock  });
   						
	  					// Update expiry date
   						//nvList.Add(new NameValuePair { Name = "IsHidden", Value = false });
  						nvList.Add(new NameValuePair { Name = "PubDate", Value = DateTime.Now });
   						nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now.AddYears(1) });
					}
					else if (ListingStatusAction == "Publish-Ad")
					{	
						nvList.Add(new NameValuePair { Name = "ListingStatusID", Value = (int)ListingStatus.InStock });
						
						// Update expiry date
   						//nvList.Add(new NameValuePair { Name = "IsHidden", Value = false });
						nvList.Add(new NameValuePair { Name = "PubDate", Value = DateTime.Now });
						nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now.AddYears(1) });
					}
				}


				/*
 				// Temporary hide and not changing IsHidden field first

  				// Unique website show/hidden flag
 				//nvList.Add(new NameValuePair { Name = "IsHidden", Value = !HTTPFormHelpers.GetBool("listing-publish") });
				
				if (HTTPFormHelpers.GetBool("listing-publish"))
				{
					nvList.Add(new NameValuePair { Name = "PubDate", Value = DateTime.Now });
					nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now.AddYears(1) });
				}else
				{
					nvList.Add(new NameValuePair { Name = "UnpubDate", Value = DateTime.Now });
				}*/

 				var SellingType = "1"; // Private (Default)
				if (!RetailUser)
				{
  					SellingType = "2";	// Business
				}
				nvList.Add(new NameValuePair { Name = "SellingType", Value = SellingType });

				nvList.Add(new NameValuePair { Name = "StkNo", Value = HTTPFormHelpers.GetString("listing-stock-number") });

 				// Location
				nvList.Add(new NameValuePair { Name = "LocRegion", Value = LocRegion });
				nvList.Add(new NameValuePair { Name = "LocStateProvince", Value = LocState });
				nvList.Add(new NameValuePair { Name = "LocPostalCode", Value = LocPostcodeNo});
				nvList.Add(new NameValuePair { Name = "LocCountryCode", Value = "AU"});
				
				nvList.Add(new NameValuePair { Name = "DateEdited", Value = DateTime.UtcNow });



 				//-------------------------------------------------------------------------		
 				// Listing Catalog and Feeout Default

				if (RetailUser)
				{
					nvList.Add(new NameValuePair { Name = "FeedOutDestList", Value = DataFeedOutDestination.TradingPost.ToString() });
				}
				else
				{
					var FeedOutList = HTTPFormHelpers.GetString("listing-publish-dest");

					//============================================
					// Append Internal feedout listing if exists
					//============================================
					
					if (!String.IsNullOrEmpty(LstCatalog))
					{
						var catalogInfo = repo.Single<ListingCatalog>(c => c.HotlistUUID == LstCatalog);
						if (catalogInfo != null)
						{
							var FeedOutDestList = repo.All<FeedOutDistSettings>(f => 
									f.UserCode == UserCode && 
									f.CatalogHotlistID == catalogInfo.HotlistID && 
									f.InternalUse == true
								).Select(f => f.DeliveryDesc).Distinct();

							if (FeedOutDestList.ToList().Count() > 0)
							{
								var InternalFeedOutList = string.Join(",", FeedOutDestList);
								
								if (!string.IsNullOrEmpty(FeedOutList)) FeedOutList += ",";
								FeedOutList += InternalFeedOutList;
							}
						}
					}
					//============================================

					nvList.Add(new NameValuePair { Name = "FeedOutDestList", Value = FeedOutList});
				}
				//-------------------------------------------------------------------------		

				// Fields lock
				nvList.Add(new NameValuePair { Name = "LxTitle", Value = HTTPFormHelpers.GetBool("lock-title") });
				nvList.Add(new NameValuePair { Name = "LxSumDesc", Value = HTTPFormHelpers.GetBool("lock-summary-description") });
				nvList.Add(new NameValuePair { Name = "LxDesc", Value = HTTPFormHelpers.GetBool("lock-description") });
				nvList.Add(new NameValuePair { Name = "LxPrice", Value = HTTPFormHelpers.GetBool("lock-price") });
				nvList.Add(new NameValuePair { Name = "LxWasPrice", Value = HTTPFormHelpers.GetBool("lock-was-price") });
				nvList.Add(new NameValuePair { Name = "LxPriceQualifier", Value = HTTPFormHelpers.GetBool("lock-price-qualifier") });				
				nvList.Add(new NameValuePair { Name = "LxCondition", Value = HTTPFormHelpers.GetBool("lock-condition") });
				nvList.Add(new NameValuePair { Name = "LxStkNo", Value = HTTPFormHelpers.GetString("lock-stock-number") });

				nvList.Add(new NameValuePair { Name = "LxImages", Value = HTTPFormHelpers.GetString("lock-photo") });
				nvList.Add(new NameValuePair { Name = "LxVideos", Value = HTTPFormHelpers.GetString("lock-video") });
							

				//-------------------------------------------------------------------------		
 				// Listin Contact Level setting
				//-------------------------------------------------------------------------		
				var IsAccountLevel = HTTPFormHelpers.GetBool("listing-contact-setting");
				if (IsAccountLevel)
				{
					nvList.Add(new NameValuePair { Name = "ContactDisplayLevelSetting", Value = (int)ContactDisplayLevel.AccountLevel });
					nvList.Add(new NameValuePair { Name = "ContactDisplaySellerEmail", Value = "" });
					nvList.Add(new NameValuePair { Name = "ContactDisplaySellerPhone", Value = "" });
					nvList.Add(new NameValuePair { Name = "ContactDisplaySellerName", Value = "" });
					
				}
				else
				{
					nvList.Add(new NameValuePair { Name = "ContactDisplayLevelSetting", Value = (int)ContactDisplayLevel.ListingLevel });
					nvList.Add(new NameValuePair { Name = "ContactDisplaySellerEmail", Value = HTTPFormHelpers.GetString("listing-contact-email") });
					nvList.Add(new NameValuePair { Name = "ContactDisplaySellerPhone", Value = HTTPFormHelpers.GetString("listing-contact-phone") });
					nvList.Add(new NameValuePair { Name = "ContactDisplaySellerName", Value = HTTPFormHelpers.GetString("listing-contact-name") });
					
				}

				//-------------------------------------------------------------------------		


				//--------------------------------------------------------------------------
 				// Vehicles
				//--------------------------------------------------------------------------
 				log.Info("listingType=>" + listingType);

				if (listingType == "Car" || listingType == "Motorcycle")
				{
					// !!!! TODO Update only if has exception !!!!
					if (FeedInExceptionList.Count > 0)
					{
						nvList.Add(new NameValuePair { Name = "VehicleListing.Make", Value = HTTPFormHelpers.GetString("listing-make") });
						nvList.Add(new NameValuePair { Name = "VehicleListing.Model", Value = HTTPFormHelpers.GetString("listing-model") });
						nvList.Add(new NameValuePair { Name = "VehicleListing.Year", Value = HTTPFormHelpers.GetIntNotNull("listing-year") });
						nvList.Add(new NameValuePair { Name = "VehicleListing.Series", Value = HTTPFormHelpers.GetString("listing-series") });			
						nvList.Add(new NameValuePair { Name = "VehicleListing.Variant", Value = HTTPFormHelpers.GetString("listing-variant") });		

						nvList.Add(new NameValuePair { Name = "VehicleListing.LxMake", Value = true });
						nvList.Add(new NameValuePair { Name = "VehicleListing.LxModel", Value = true });
						nvList.Add(new NameValuePair { Name = "VehicleListing.LxYear", Value = true });
						nvList.Add(new NameValuePair { Name = "VehicleListing.LxSeries", Value = true });			
						nvList.Add(new NameValuePair { Name = "VehicleListing.LxVariant", Value = true });		
 					}
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.Doors", Value = HTTPFormHelpers.GetIntNotNull("listing-doors") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.Seats", Value = HTTPFormHelpers.GetIntNotNull("listing-seats") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.DriveTypeDesc", Value = HTTPFormHelpers.GetString("listing-drive-type") });
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.BodyStyle", Value = HTTPFormHelpers.GetString("listing-body-style") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.BodyDesc", Value = HTTPFormHelpers.GetString("listing-body-style-description") });
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.ExteriorColour", Value = HTTPFormHelpers.GetString("listing-exterior-colour") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.InteriorColour", Value = HTTPFormHelpers.GetString("listing-interior-colour") });
					if (HTTPFormHelpers.GetIntNotNull("listing-odometer-value") != 0)
					{
						nvList.Add(new NameValuePair { Name = "VehicleListing.Odometer", Value = HTTPFormHelpers.GetIntNotNull("listing-odometer-value")});
					}
					nvList.Add(new NameValuePair { Name = "VehicleListing.OdometerUOM", Value = HTTPFormHelpers.GetString("listing-odometer-unit") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.RegNo", Value = HTTPFormHelpers.GetString("listing-registration-number") });
  					
					//nvList.Add(new NameValuePair { Name = "VehicleListing.VinNumber", Value = HTTPFormHelpers.GetString("listing-vinnumber") });
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.RegType", Value = HTTPFormHelpers.GetString("listing-registration-type") });
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.TrmType", Value = HTTPFormHelpers.GetString("listing-transmission-type") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.TrmDesc", Value = HTTPFormHelpers.GetString("listing-transmission-description") });
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.EngCylinders", Value = HTTPFormHelpers.GetString("listing-engine-cylinders") });

					if (listingType == "Car")
					{
						nvList.Add(new NameValuePair { Name = "VehicleListing.EngType", Value = HTTPFormHelpers.GetString("listing-engine-type-description") });					
						nvList.Add(new NameValuePair { Name = "VehicleListing.EngSizeDesc", Value = HTTPFormHelpers.GetString("listing-engine-size-description") });

						nvList.Add(new NameValuePair { Name = "VehicleListing.LxEngType", Value = HTTPFormHelpers.GetBool("lock-engine-type-description") });
						nvList.Add(new NameValuePair { Name = "VehicleListing.LxEngSizeDesc", Value = HTTPFormHelpers.GetBool("lock-engine-size-description") });
					}
					else if (listingType == "Motorcycle")
					{
						nvList.Add(new NameValuePair { Name = "VehicleListing.EngDesc", Value = HTTPFormHelpers.GetString("listing-engine-description") });
						nvList.Add(new NameValuePair { Name = "VehicleListing.EngSizeDesc", Value = HTTPFormHelpers.GetString("listing-engine-size-description") });					

						nvList.Add(new NameValuePair { Name = "VehicleListing.LxEngDesc", Value = HTTPFormHelpers.GetBool("lock-engine-description") });
						nvList.Add(new NameValuePair { Name = "VehicleListing.LxEngSizeDesc", Value = HTTPFormHelpers.GetBool("lock-engine-size-description") });
					}

					nvList.Add(new NameValuePair { Name = "VehicleListing.FuelTypeDesc", Value = HTTPFormHelpers.GetString("listing-fuel-type-description") });
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.TrmGearCnt", Value = HTTPFormHelpers.GetString("listing-gears") });

					if (!string.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-nvic")))
					{
						nvList.Add(new NameValuePair { Name = "VehicleListing.NVIC", Value = HTTPFormHelpers.GetString("listing-nvic") });
					}
					
					// Fields lock
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxVehicleFeatures", Value = HTTPFormHelpers.GetString("lock-features") });

					nvList.Add(new NameValuePair { Name = "VehicleListing.LxBodyStyle", Value = HTTPFormHelpers.GetBool("lock-body-style") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxDoors", Value = HTTPFormHelpers.GetBool("lock-doors") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxSeats", Value = HTTPFormHelpers.GetBool("lock-seats") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxBodyDesc", Value = HTTPFormHelpers.GetBool("lock-body-style-description") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxExteriorColour", Value = HTTPFormHelpers.GetBool("lock-exterior-colour") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxInteriorColour", Value = HTTPFormHelpers.GetBool("lock-interior-colour") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxOdometer", Value = HTTPFormHelpers.GetBool("lock-odometer") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxRegNo", Value = HTTPFormHelpers.GetBool("lock-registration") });
					
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxDriveType", Value = HTTPFormHelpers.GetBool("lock-drive-type") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxDriveTypeDesc", Value = HTTPFormHelpers.GetBool("lock-drive-type") });
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxTrmDesc", Value = HTTPFormHelpers.GetBool("lock-transmission-description") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxEngCylinders", Value = HTTPFormHelpers.GetBool("lock-engine-cylinders") });

					nvList.Add(new NameValuePair { Name = "VehicleListing.LxFuelType", Value = HTTPFormHelpers.GetBool("lock-fuel-type-description") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxFuelTypeDesc", Value = HTTPFormHelpers.GetBool("lock-fuel-type-description") });
					
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxTrmType", Value = HTTPFormHelpers.GetBool("lock-transmission-type") });
					nvList.Add(new NameValuePair { Name = "VehicleListing.LxTrmGearsDesc", Value = HTTPFormHelpers.GetBool("lock-gears") });
						
					//====================================================================
					// Additional Info
					//====================================================================
						
	 				var VhcReg = HTTPFormHelpers.GetBool("listing-vehicle-registered");
					if (VhcReg)
					{
						nvList.Add(new NameValuePair { Name = "VehicleListing.VehicleRegistered", Value = true });
						nvList.Add(new NameValuePair { Name = "VehicleListing.RegNo", Value = HTTPFormHelpers.GetString("listing-vehicle-rego") });
	
						if (!string.IsNullOrEmpty(HTTPFormHelpers.GetString("listing-vehicle-VIN")))
						{
							nvList.Add(new NameValuePair { Name = "VehicleListing.EngVinType", Value = "VIN" });
							nvList.Add(new NameValuePair { Name = "VehicleListing.VinNumber", Value = HTTPFormHelpers.GetString("listing-vehicle-VIN") });
						}
						else
						{
							nvList.Add(new NameValuePair { Name = "VehicleListing.EngVinType", Value = "" });
							nvList.Add(new NameValuePair { Name = "VehicleListing.VinNumber", Value = "" });
						}

  						nvList.Add(new NameValuePair { Name = "VehicleListing.RegExpMth", Value = HTTPFormHelpers.GetString("listing-vehicle-expiry-month") == "" ? "0" :HTTPFormHelpers.GetString("listing-vehicle-expiry-month") });
  						nvList.Add(new NameValuePair { Name = "VehicleListing.RegExpYear", Value = HTTPFormHelpers.GetString("listing-vehicle-expiry-year") == "" ? "0" :HTTPFormHelpers.GetString("listing-vehicle-expiry-year")});
						
						nvList.Add(new NameValuePair { Name = "VehicleListing.RoadworthyCertificate", Value = HTTPFormHelpers.GetBool("listing-vehicle-cert") });
				
						nvList.Add(new NameValuePair { Name = "VehicleListing.LxVinNumber", Value = HTTPFormHelpers.GetBool("lock-VIN") });
					}
					else
					{
						nvList.Add(new NameValuePair { Name = "VehicleListing.VehicleRegistered", Value = false });
						nvList.Add(new NameValuePair { Name = "VehicleListing.EngVinType", Value = HTTPFormHelpers.GetString("listing-vehicle-VinEngine") });

						if (HTTPFormHelpers.GetString("listing-vehicle-VinEngine") == "VIN")
						{
							// nvList.Add(new NameValuePair { Name = "VehicleListing.VinNumber", Value = HTTPFormHelpers.GetString("listing-vehicle-VinEngine-No") });
							nvList.Add(new NameValuePair { Name = "VehicleListing.VinNumber", Value = HTTPFormHelpers.GetString("listing-vehicle-VinEngine-VIN") });
						}
						else
						{
							// nvList.Add(new NameValuePair { Name = "VehicleListing.EngNo", Value = HTTPFormHelpers.GetString("listing-vehicle-VinEngine-No") });
							nvList.Add(new NameValuePair { Name = "VehicleListing.EngNo", Value = HTTPFormHelpers.GetString("listing-vehicle-VinEngine-Engine") });
						}

						nvList.Add(new NameValuePair { Name = "VehicleListing.LxVinNumber", Value = HTTPFormHelpers.GetBool("lock-vinnumber") });
	 				}
	
					//----------------------
					// Automotive Features
					//----------------------

					List<AutomotiveFeatureInfo> AutoFeatures = new List<AutomotiveFeatureInfo>();
					
					if (listingType == "Car")
					{
						// Standard Features
						string ListStdFeatures = HTTPFormHelpers.GetString("listing-standard-features");
						if(!String.IsNullOrEmpty(ListStdFeatures))
						{
							var StdFeaturesArray = Utils.StringDelimitedToObjectArray(ListStdFeatures, '|');
							foreach (var sf in StdFeaturesArray)
							{
								AutoFeatures.Add(new AutomotiveFeatureInfo { FeatureType = "standard", Feature = sf.ToString() });
							}
						}
						// Optional Features
						string ListOptFeatures = HTTPFormHelpers.GetString("listing-optional-features");
						if(!String.IsNullOrEmpty(ListOptFeatures))
						{
							var OptFeaturesArray = Utils.StringDelimitedToObjectArray(ListOptFeatures, '|');
							foreach (var sf in OptFeaturesArray)
							{
								AutoFeatures.Add(new AutomotiveFeatureInfo { FeatureType = "optional", Feature = sf.ToString() });
							}
						}
		
						if (AutoFeatures.Count > 0)
						{
							var AutoFeaturesXML = Utils.ObjectToXML(AutoFeatures).Remove(0,1);
							nvList.Add(new NameValuePair { Name = "VehicleListing.VehicleFeaturesXML", Value = AutoFeaturesXML });
						}
					}
					else
					{
						string StdFeatureField = "listing-motor-standard-features";
						char Delimiter = '|';
							
						// Standard Features
						string ListStdFeatures = HTTPFormHelpers.GetString(StdFeatureField);
						if(!String.IsNullOrEmpty(ListStdFeatures))
						{
							var StdFeaturesArray = Utils.StringDelimitedToObjectArray(ListStdFeatures, Delimiter);
							foreach (var sf in StdFeaturesArray)
							{
								AutoFeatures.Add(new AutomotiveFeatureInfo { FeatureType = "standard", Feature = sf.ToString() });
							}
						}
						
						if (AutoFeatures.Count > 0)
						{
							var AutoFeaturesXML = Utils.ObjectToXML(AutoFeatures).Remove(0,1);
							nvList.Add(new NameValuePair { Name = "VehicleListing.VehicleFeaturesXML", Value = AutoFeaturesXML });
						}
					}
				}
				else
				{
  					log.Info("=>listingCatID : " + listingCatID);
					if (listingCatID != 0)
					{
						Categories catInfo = EasyList.Dashboard.Helpers.Category.GetCatInfo(listingCatID);
	  
						List<AttributeInfo> CustomAttr = new List<AttributeInfo>(); 
						if ((catInfo != null) && (!string.IsNullOrEmpty(catInfo.catAttrUIXML)))
						{
							var catAttrUIXML = Utils.XMLToObject<List<CustomWebControls>>(catInfo.catAttrUIXML);
	
							foreach (var CatAttr in catAttrUIXML)
							{
								if (CatAttr.CanEdit)
								{
									var XMLAttrVal = HTTPFormHelpers.GetString(CatAttr.XMLAttributeName);
							
									switch (CatAttr.WebControlType.ToString())
									{
										case "Textarea":
										case "TextBox":
										case "DropDown":
											
											if (!string.IsNullOrEmpty(XMLAttrVal)) CustomAttr.Add(new AttributeInfo { Name = CatAttr.XMLAttributeName, Value = XMLAttrVal });
											break;
										case "Checkbox":	
										case "Radio":
											if (!string.IsNullOrEmpty(XMLAttrVal)) {
												string[] AttrValList = XMLAttrVal.Split(',');
												CustomAttr.Add(new AttributeInfo { Name = CatAttr.XMLAttributeName, Value = XMLAttrVal });
		 									}
											break;
		
										default:
											break;
									}
								}
							}
							if (CustomAttr.Count > 0)
							{
								nvList.Add(new NameValuePair { Name = "XmlData", Value = Utils.ObjectToXML(CustomAttr) });
							}					
						}
					}
				}

  		        //----------------------
  				// Videos - Youtube
				//----------------------
				string ListOfYoutubeCode = HTTPFormHelpers.GetString("video-order");
				log.Info("Video " + ListOfYoutubeCode);
				if(!String.IsNullOrEmpty(ListOfYoutubeCode))
				{
					List<VideoInfo> VideoInfoList = new List<VideoInfo>();
					VideoInfo vInfo = new VideoInfo();
					var YoutubeCodeArray = Utils.StringDelimitedToObjectArray(ListOfYoutubeCode, ',');
					foreach (var ytCode in YoutubeCodeArray)
					{

						vInfo = new VideoInfo();

						if (ytCode.ToString().IndexOf("mediaID")!=-1)
						{
							vInfo.VideoSource = "DMI";		
						}else
						{
							vInfo.VideoSource = "YouTube";		
						}

						
						vInfo.Title = ytCode.ToString();
						vInfo.Description = ytCode.ToString();
						vInfo.SyncSource = ytCode.ToString();
						
						vInfo.VideoData = ytCode.ToString();

						VideoInfoList.Add(vInfo);
					}

					if (VideoInfoList.Count > 0)
					{
						var VideoInfoListXML = Utils.ObjectToXML(VideoInfoList).Remove(0,1);
						nvList.Add(new NameValuePair { Name = "VideosXml", Value = VideoInfoListXML });
					}
				}else
				{
					nvList.Add(new NameValuePair { Name = "VideosXml", Value = "" });
				}


				// Convert from Object to JSON
                string JSONlisting = EasyList.Common.Helpers.Utils.ObjectToJSON(nvList);
            
				byte[] dataByte = Encoding.ASCII.GetBytes(JSONlisting);

				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString(),UserID, UserCode, UserSign, UserSignDT);
            	rc.URL = Listing_URL + "Listing/" + listingCode;
            	rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
            	rc.RequestType = "application/json";  rc.ResponseType = "application/xml";
				rc.DataByte = dataByte;
            	rs = rc.SendRequest();

				if (rs.State == RESTState.Success)
				{
					log.Info("Listing " + listingCode + " save successfully!");
				}
				else
				{
					throw new Exception(rs.Message);
				}

				//============================================================================================================
 				// Image Deletion
				//============================================================================================================
				string ImageCodeDeleteList = HTTPFormHelpers.GetString("delete-photos");

				if (!string.IsNullOrEmpty(ImageCodeDeleteList))
				{
	 				log.Info("Deleting image " + URL + "Listing/ImageToDelete/" + listingCode + "/" + ImageCodeDeleteList);
					
					rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString(),UserID, UserCode, UserSign, UserSignDT);
					
   					//rc.URL = Listing_URL + "Listing/Image/" + listingCode + "/" + ImageCodeDeleteList;
					rc.URL = Listing_URL + "Listing/ImageToDelete/" + listingCode;

					rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
					rc.RequestType = "application/json";  rc.ResponseType = "application/json";
					
					string ImageCodeDeleteListJSON = EasyList.Common.Helpers.Utils.ObjectToJSON(ImageCodeDeleteList);
					byte[] dataByte2 = Encoding.ASCII.GetBytes(ImageCodeDeleteListJSON);

					rc.DataByte = dataByte2; // PUT Method must have some bytes array

					rs = new RESTStatus();
					rs = rc.SendRequest();
	
					if (rs.State == RESTState.Success)
					{
						log.Info("Image deletion Success! Image delete list : "+ ImageCodeDeleteList);
						log.Info("Image deletion message : " + rs.Message);
					}
					else
					{
						// Might have some image delete success.
						log.Info("Image deletion Failed! Error - " + rs.Message);
						throw new Exception(rs.Message);
					}
				}

				//============================================================================================================
 				// Image Order
				//============================================================================================================
				string ImageCodeOrdered = HTTPFormHelpers.GetString("photo-order");
	
				if (!string.IsNullOrEmpty(ImageCodeOrdered))
				{
	 				log.Info("Updating image order " + URL + "Listing/Image/" + listingCode + "/" + ImageCodeOrdered);
					
					rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.PUT.ToString(),UserID, UserCode, UserSign, UserSignDT);
					
   					//rc.URL = Listing_URL + "Listing/Image/" + listingCode + "/" + ImageCodeOrdered;
					rc.URL = Listing_URL + "Listing/Image/" + listingCode ;
					
					rc.RequestMethod = EasyListRestClient.HttpMethod.PUT;
					rc.RequestType = "application/json";  rc.ResponseType = "application/json";

					string ImageCodeOrderedJSON = EasyList.Common.Helpers.Utils.ObjectToJSON(ImageCodeOrdered);
					byte[] dataByte2 = Encoding.ASCII.GetBytes(ImageCodeOrderedJSON);

	  				//rc.DataByte = Encoding.ASCII.GetBytes("ImageOrder"); // PUT Method must have some bytes array
					rc.DataByte = dataByte2; // PUT Method must have some bytes array
					
					rs = new RESTStatus();
					rs = rc.SendRequest();
	
					if (rs.State == RESTState.Success)
					{
						log.Info("Update Image Order Success! Image ordered list : "+ ImageCodeOrdered);
					}
					else
					{
						log.Info("Update Image Order Failed! Error - " + rs.Message);
						throw new Exception(rs.Message + " " + rc.URL);
					}
				}

 				// Read the updated listing
  				//nodeIterator = GetListingEditData(listingCode);
				//log.Info("Call Update cache! User " + UserCode);
				//ListingsBiz.ProcessUserUpdatesByUserCode(DealerCacheURL, UserCode, 0);
				
				//--------------------------------------------------
 				// LOGGING if ESSUPPORT Roles user edit the record
				//--------------------------------------------------
				if (HttpContext.Current.Session["easylist-SupportUsername"] != null)
				{
					var SupportUserID =  HttpContext.Current.Session["easylist-SupportUsername"].ToString();

					if (!string.IsNullOrEmpty(SupportUserID))
					{
						Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(SupportUserID);
						if (userInfo != null)
						{
							if (userInfo.IsMemberOf("EasySales Admin") || userInfo.IsMemberOf("ESSupport")){
								Logging.AuditLog(SupportUserID, SecurityController.IPAddress,
									LogEvent.Update, "Listings", "User : " + SupportUserID + " update listing " + listingCode, listingCode, UserCode);
							}
						}
					}
				}
				//--------------------------------------------------


			}
			catch (Exception ex)
			{
	  			strErrMessage = ex.ToString();
  				//strErrMessage = "Please ensure all data entered correctly!";
				log.Error("Update Listing failed! Error:" + ex.ToString());
			}
			finally
			{
				
			}
			return strErrMessage;
        }

		//------------------------------------------------------------------------------------------------------
		
	 	private string getLocInfo(string LocInfo, out string outLocRegion, out string outLocState, out int outLocPostcodeNo)
        {
            outLocRegion = "";
            outLocState = "";
            outLocPostcodeNo = 0;

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

                }
            }
            catch (Exception ex)
            {
                log.Error("Failed to getLocInfo. Error : " + ex.ToString());
				return ErrMsg;
            }
            return ""; // No error
        }


	  public string GetVehicleSearchUrl(string dealerID, int page, int pageSize, string LstType, 
		string category, string keywords, string searchInDesc, string condition, string searchType,
		string make, string model, string variant, string minPrice, string maxPrice,
        string stockNumber, string sortOrder, string ActiveOnly)
	  {
		 log.Info(string.Format("{0}Listing/SearchAllV2?DealerIDs={1}&PageNo={2}&PageSize={3}&ListingType={4}&Category={5}&Keywords={6}&SearchInDesc={7}&ConditionTypes={8}&SearchType={9}&Make={10}&Model={11}&Variant={12}&PriceMin={13}&PriceMax={14}&StockNumber={15}&SortOrder={16}&ActiveOnly={17}",
           	Listing_URL, dealerID, page, pageSize, LstType, category, keywords, searchInDesc, condition, searchType,
			make, model, variant, minPrice, maxPrice, stockNumber, sortOrder, ActiveOnly));
 		 return string.Format("{0}Listing/SearchAllV2?DealerIDs={1}&PageNo={2}&PageSize={3}&ListingType={4}&Category={5}&Keywords={6}&SearchInDesc={7}&ConditionTypes={8}&SearchType={9}&Make={10}&Model={11}&Variant={12}&PriceMin={13}&PriceMax={14}&StockNumber={15}&SortOrder={16}&ActiveOnly={17}",
           	Listing_URL, dealerID, page, pageSize, LstType, category, keywords, searchInDesc, condition, searchType,
			make, model, variant, minPrice, maxPrice, stockNumber, sortOrder, ActiveOnly);
	  }

 	  public string GetListingStatUrl(string dealerID)
	  {
		 log.Info(string.Format("{0}Listing/ListingstatV3?DealerIDs={1}", Listing_URL, dealerID));
 		 return string.Format("{0}Listing/ListingstatV3?DealerIDs={1}", Listing_URL, dealerID);
	  }

	
	public string GetListingSearchUrl(string dealerID, int page, int pageSize, string LstType, 
		string category, string keywords, string searchInDesc, string condition, string searchType,
		string make, string model, string variant, string minPrice, string maxPrice,
        string stockNumber, string sortOrder, string Status, string ActiveOnly, bool IsRetailUser2 = true, string HasException = "", string ExceptionType = "0", string MissingImage="", string PendingModeration = "", string MissingVideo="", string NoPrice="" )
	  {
			string ExcludeStatus = "";
   			if (IsRetailUser())
			{
				if (PendingModeration == "true")
				{
					Status = "PendingModeration";
				}
				else
				{
 					ExcludeStatus = "PendingModeration";
				}
			}	

			string URL = string.Format("{0}Listing/SearchAllV2?DealerIDs={1}&PageNo={2}&PageSize={3}&ListingType={4}&Category={5}&Keywords={6}&SearchInDesc={7}&ConditionTypes={8}&SearchType={9}&Make={10}&Model={11}&Variant={12}&PriceMin={13}&PriceMax={14}&StockNumber={15}&SortOrder={16}&Status={17}&ActiveOnly={18}&ExcludeStatus={19}&HasException={20}&ExceptionType={21}&MissingImage={22}&MissingVideo={23}&NoPrice={24}",
           		Listing_URL, dealerID, page, pageSize, LstType, category, keywords, searchInDesc, condition, searchType,
				make, model, variant, minPrice, maxPrice, stockNumber, sortOrder, Status, ActiveOnly, ExcludeStatus, HasException, ExceptionType, MissingImage, MissingVideo, NoPrice);

		 	log.Info(URL);

 		 return URL;
	  }
	  
	  public string GetListingSearchUrl(string dealerID, int page, int pageSize, string LstType, 
		string category, string keywords, string searchInDesc, string condition, string searchType,
		string make, string model, string variant, string minPrice, string maxPrice,
        string stockNumber, string sortOrder, string Status, string ActiveOnly, bool IsRetailUser2 = true, string HasException = "", string ExceptionType = "0", string MissingImage="")
	  {
			string ExcludeStatus = "";
   			if (IsRetailUser()) ExcludeStatus = "Draft";

			string URL = string.Format("{0}Listing/SearchAllV2?DealerIDs={1}&PageNo={2}&PageSize={3}&ListingType={4}&Category={5}&Keywords={6}&SearchInDesc={7}&ConditionTypes={8}&SearchType={9}&Make={10}&Model={11}&Variant={12}&PriceMin={13}&PriceMax={14}&StockNumber={15}&SortOrder={16}&Status={17}&ActiveOnly={18}&ExcludeStatus={19}&HasException={20}&ExceptionType={21}&MissingImage={22}",
           		Listing_URL, dealerID, page, pageSize, LstType, category, keywords, searchInDesc, condition, searchType,
				make, model, variant, minPrice, maxPrice, stockNumber, sortOrder, Status, ActiveOnly, ExcludeStatus, HasException, ExceptionType, MissingImage);

		 	log.Info(URL);

 		 return URL;
	  }

	  public string GetListingSearchUrl(string dealerID, int page, int pageSize, string LstType, 
		string category, string keywords, string searchInDesc, string condition, string searchType,
		string make, string model, string variant, string minPrice, string maxPrice,
        string stockNumber, string sortOrder, string Status, string ActiveOnly, bool IsRetailUser2 = true )
	  {
		
		string ExcludeStatus = "";
		if (IsRetailUser()) ExcludeStatus = "Draft";

		string URL = string.Format("{0}Listing/SearchAllV2?DealerIDs={1}&PageNo={2}&PageSize={3}&ListingType={4}&Category={5}&Keywords={6}&SearchInDesc={7}&ConditionTypes={8}&SearchType={9}&Make={10}&Model={11}&Variant={12}&PriceMin={13}&PriceMax={14}&StockNumber={15}&SortOrder={16}&Status={17}&ActiveOnly={18}&ExcludeStatus={19}",
           	Listing_URL, dealerID, page, pageSize, LstType, category, keywords, searchInDesc, condition, searchType,
			make, model, variant, minPrice, maxPrice, stockNumber, sortOrder, Status, ActiveOnly, ExcludeStatus);

		 log.Info(URL);

 		 return URL;
	  }

	public string GetSearchPageUrl(string ListingType, string StockNumber, string pageNum, string minPrice,
		string maxPrice, string condition, string keywords, string sort, string Makes, string Models, string category, string Status, string HasException, string ExceptionType, string MissingImage, string PendingModeration, string MissingVideo, string NoPrice, string DealerID)
	{
	  var URL = string.Format("/listings?ListingType={0}&DealerIDs={18}&q={1}&StockNumber={2}&condition={3}" + 
			"&price-min={4}&price-max={5}&Makes={6}&Models={7}&page={8}&sort={9}&cat={10}&Status={11}&HasException={12}&ExceptionTypeDesc={13}&MissingImage={14}&PendingModeration={15}&MissingVideo={16}&NoPrice={17}",
			ListingType, keywords, StockNumber, condition, 
				minPrice, maxPrice, Makes, Models, pageNum, sort, category, Status, HasException, ExceptionType, MissingImage, PendingModeration, MissingVideo, NoPrice, DealerID);
		return URL;
	}

	public string GetSearchPageUrl(string ListingType, string StockNumber, string pageNum, string minPrice,
		string maxPrice, string condition, string keywords, string sort, string Makes, string Models, string category, string Status, string HasException, string ExceptionType, string MissingImage, string PendingModeration, string MissingVideo, string NoPrice)
	{
	  var URL = string.Format("/listings?ListingType={0}&q={1}&StockNumber={2}&condition={3}" + 
			"&price-min={4}&price-max={5}&Makes={6}&Models={7}&page={8}&sort={9}&cat={10}&Status={11}&HasException={12}&ExceptionTypeDesc={13}&MissingImage={14}&PendingModeration={15}&MissingVideo={16}&NoPrice={17}",
			ListingType, keywords, StockNumber, condition, 
				minPrice, maxPrice, Makes, Models, pageNum, sort, category, Status, HasException, ExceptionType, MissingImage, PendingModeration, MissingVideo, NoPrice);
		return URL;
	}

	public string GetSearchPageUrl(string ListingType, string StockNumber, string pageNum, string minPrice,
		string maxPrice, string condition, string keywords, string sort, string Makes, string Models, string category, string Status, string HasException, string ExceptionType, string MissingImage)
	{
	  var URL = string.Format("/listings?ListingType={0}&q={1}&StockNumber={2}&condition={3}" + 
			"&price-min={4}&price-max={5}&Makes={6}&Models={7}&page={8}&sort={9}&cat={10}&Status={11}&HasException={12}&ExceptionTypeDesc={13}&MissingImage={14}",
			ListingType, keywords, StockNumber, condition, 
				minPrice, maxPrice, Makes, Models, pageNum, sort, category, Status, HasException, ExceptionType, MissingImage);
		return URL;
	}
	
	public string GetSearchPageUrl(string ListingType, string StockNumber, string pageNum, string minPrice,
		string maxPrice, string condition, string keywords, string sort, string Makes, string Models, string category, string Status)
	{
	  var URL = string.Format("/listings?ListingType={0}&q={1}&StockNumber={2}&condition={3}" + 
			"&price-min={4}&price-max={5}&Makes={6}&Models={7}&page={8}&sort={9}&cat={10}&Status={11}",
			ListingType, keywords, StockNumber, condition, 
				minPrice, maxPrice, Makes, Models, pageNum, sort, category, Status);

	   //return string.Format("/listings?price-min={0}&price-max={1}&condition={2}&q={3}&sort={4}&page={5}&cat={6}",
	   //	minPrice, maxPrice, condition, keywords, sort, pageNum, category);

		return URL;
	}

	 public string GetDealerInfo(string dealerID)
	 {
		return string.Format(Listing_URL + "Listing/DealerInfo?dealerIDs={0}", dealerID);
	 }

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
				if (index > 0) xml = xml.Substring(index);
				//log.Info("====>" + xml);
 				//xml = xml.Substring(0);
		   }
		   XmlDocument doc = new XmlDocument { XmlResolver = null };
  		   doc.LoadXml(xml);
		   XPathNavigator nav = doc.CreateNavigator();
		   return nav.Select("/");
		}



      public void RedirectTo(string url)
      {
  		HttpContext.Current.Response.Redirect(url);
      }

		public class AccountInfo
		{
			public string UserID { get; set; }
			public string UserCode { get; set; }
			public string DisplayName { get; set; }
			public string SecPhrase { get; set; }
			public string SecQuestion { get; set; }
			public string UserSignature { get; set; }
			public string UserSignatureDateTime { get; set; }
			public string UserActivationState { get; set; }
			public string NextLoginTemplate { get; set; }
			public string LogonViewState { get; set; }
			public string OTPReferenceCode { get; set; }
			public string MobileNoMasked { get; set; }
			public string OTPResendTime { get; set; }
			public string OTPValid { get; set; }
	
			public string AccountActivationLink { get; set; }
			public bool ValidActivationLink { get; set; }
			
			public bool HasError { get; set; }
			public string ErrorMessage { get; set; }
	
			public string ImageLimit { get; set; }
			public string VideoLimit { get; set; }
		}

		/*
  		// Obsolete
		public XPathNodeIterator LogonUser(string userName, string password)
		{
			XPathNodeIterator nodeIterator = null;
			try
			{
				SecurityController.WebSiteDomain = "easylist.com.au";
				SecurityController.IPAddress = SecurityController.GetIPAddress();
				
				SessionInfo si = SecurityController.SessionInfo;
				if (si == null)
				{
					log.Info("Creating new Session...");
					SecurityController.Initialise_Session();
				}
				si = SecurityController.SessionInfo;
				log.Info("Session ID " + si.SessionID);
 
				log.Debug("Logon Username : " + userName);
	 
				EasyListRestClient rc = new EasyListRestClient(AppID, AppSecretID, EasyListRestClient.HttpMethod.GET.ToString());
				
				rc.URL = URL + "Account/Logon?id=" + userName + "&password=" + password +
					"&siteName=" + SecurityController.WebSiteDomain + 
					"&ipAddress=" + SecurityController.IPAddress + 
					"&userAgent=" + SecurityController.UserAgent +
					"&url=" + HttpContext.Current.Request.Url.ToString() + 
					"&sessionID=" + si.SessionID;
	
				rc.RequestMethod = EasyListRestClient.HttpMethod.GET;
				rc.RequestType = "application/xml";
				rc.ResponseType = "application/xml";
	
				rs = rc.SendRequest();
	
				
				if (rs.State == RESTState.Success)
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(rs.Result);
					log.Debug("Login Success! " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserCode").Value);
					log.Debug("UserSignature! " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserSignature").Value);
					log.Debug("UserSignature! " + nodeIterator.Current.SelectSingleNode("/AccountInfo/UserSignatureDateTime").Value);
				}
				else
				{
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Error " + rs.Message);
					log.Debug("Login Failed! Error:" + rs.Message);
				}
			}catch (Exception ex)
			{
				nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("Failed. Error " + ex.ToString());
				log.Error("Login failed! Error:" + ex.ToString());
			}

			return nodeIterator;
  		}*/

		public string GetUserList()
        {
			var UserList = "";
			try
			{
				IRepository repo = RepositorySetup.Setup();

				var UserCodeList =  HttpContext.Current.Session["easylist-usercodelist"].ToString();
	
				var UCList = UserCodeList.Split(',');
				
				foreach (var usercode in UCList)
				{
					var UserInfo = repo.Single<Users>(u => u.UserCode == usercode);
			
					if (UserInfo != null)
					{
						if (UserList != "") UserList += "|";
						UserList += usercode + ";" + UserInfo.DealerName;
					}
				}
		   }
		   catch (Exception ex)
		   {
				log.Error("Failed! Error : " + ex);
		   }
		   return UserList;
		}

		public class LstCatalog
		{
			public string ID { get;set;}
			public string Name { get;set; }
			public string Selected { get;set; }
			public string FeedDestinationList { get;set; }
		}

		public string GetUserCatalogList(string SelectedUserCode, string SelectedCatalog, bool OnlineOnly = true)
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
				HTMLControl += "<select class='drop-down required' id='listing-usercode' name='listing-usercode'>";
			
				foreach (var usercode in UCList)
				{
					var UserInfo = repo.Single<Users>(u => u.UserCode == usercode);
			
					if (UserInfo != null)
					{
   						var LCAllList = repo.All<ListingCatalog>(lc => lc.UserCode == usercode);
						if (OnlineOnly)
						{
		  					LCAllList = repo.All<ListingCatalog>(lc => lc.UserCode == usercode && (lc.OnlineFlag != null && lc.OnlineFlag == true));
						}
						
   						//-------------------------------------------------------------------------------
						//  Feed out Distribution list
						var CatalogDateFeedOutList = repo.All<FeedOutDistSettings>(lc => lc.UserCode == usercode && lc.InternalUse == false);
						//-------------------------------------------------------------------------------
							
						var LCList = new List<LstCatalog>();
						if (LCAllList.Count() > 0)
						{
							foreach (var c in LCAllList)
							{
  								var FeedOutList = CatalogDateFeedOutList.Where(d => d.CatalogHotlistID == c.HotlistID).Select(d => d.DeliveryDesc).Distinct();
								var FeedOutCSVList = string.Join(",", FeedOutList);

								var CatalogSelected = "0";
								if (SelectedCatalog == c.HotlistUUID) CatalogSelected = "1";
								c.DisplayName = c.DisplayName.Replace("\"", "").Replace("\'", "");
	
								var DisplayName = c.DisplayName + " (" + c.HotlistID + ")";
								if (!OnlineOnly)
								{
									if (c.OnlineFlag == true)
										DisplayName += "-On";
									else
										DisplayName += "-Off";
								}
									
								LCList.Add(new LstCatalog{
										ID = c.HotlistUUID, 
										Name = DisplayName, 
										Selected = CatalogSelected,
										FeedDestinationList = FeedOutCSVList
										}
								);
							}
						}

						var LCListJSON = EasyList.Common.Helpers.Utils.ObjectToJSON(LCList);

						var SelectedValue = "";
						if (usercode == SelectedUserCode)
						{
							 SelectedValue = "selected='selected'";
						}
						UserInfo.DealerName = UserInfo.DealerName.Replace("\"", "").Replace("\'", "");
						HTMLControl += "<option value='" + usercode + "' data-catalog = '" + LCListJSON + "' " + SelectedValue + ">" + UserInfo.DealerName + " (" + UserInfo.UserName + ")</option>";
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

  		//-----------------------------------------------------------
		// Get Activated UserCodeList
		//-----------------------------------------------------------
		
		public string GetActivatedUserList(string email)
		{
			string userCodeList = string.Empty;
			
			List<Uniquemail.SingleSignOn.User> users = SSOHelper.FindUserListByEmail(email);
			Uniquemail.SingleSignOn.User user = new Uniquemail.SingleSignOn.User();
			List<string> userCode = new List<string>();
			
			if (users != null && users.Count > 0)
			{
				users = (from u in users
						 where u.IsDisabled = true && u.UserActivationState == "Activated" //IsDisabled = 0 (true)
						 select u).ToList();
	
				if (users != null && users.Count > 1)
				{
					for (int i = 0; i < users.Count; i++)
					{
						if (userCodeList != "") userCodeList += ",";
						userCodeList += users[i].UserCode;
					}
				}
				else if (users.Count > 0)
				{
					user = users.FirstOrDefault();
					userCodeList = user.UserCode;
				}
			}
			
			return userCodeList;
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

		public string GetTransType(string TransDesc)
        {
            string TransType = "";
			try
			{
				if (TransDesc.ToUpper().IndexOf("AUTO") > 0)
				{
					TransType = "Automatic";
				}
				else
				{
					TransType = "Manual";
				}
			}
			catch (Exception ex)
			{
				log.Error("GetTransType Failed! Error : " + ex);
			}
            return TransType;
        }

        public string GetBodyStyle(string BodyDesc)
        {
            string BodyStyle = "";
			try
			{
				if (BodyDesc.ToUpper().IndexOf("4x4") > 0)
				{
					BodyStyle = "4x4";
				}
				else if (BodyDesc.ToUpper().IndexOf("CONVERTIBLE") > 0)
				{
					BodyStyle = "Convertible";
				}
				else if (BodyDesc.ToUpper().IndexOf("COUPE") > 0)
				{
					BodyStyle = "Coupe";
				}
				else if (BodyDesc.ToUpper().IndexOf("HATCHBACK") > 0)
				{
					BodyStyle = "Hatchback";
				}
				else if (BodyDesc.ToUpper().IndexOf("PEOPLE MOVER") > 0)
				{
					BodyStyle = "People Mover";
				}
				else if (BodyDesc.ToUpper().IndexOf("ROADSTER") > 0)
				{
					BodyStyle = "Roadster";
				}
				else if (BodyDesc.ToUpper().IndexOf("SUV") > 0)
				{
					BodyStyle = "SUV";
				}
				else if (BodyDesc.ToUpper().IndexOf("SEDAN") > 0)
				{
					BodyStyle = "Sedan";
				}
				else if (BodyDesc.ToUpper().IndexOf("SPORTS") > 0)
				{
					BodyStyle = "Sports";
				}
				else if (BodyDesc.ToUpper().IndexOf("TRUCK") > 0)
				{
					BodyStyle = "Truck/Bus";
				}
				else if (BodyDesc.ToUpper().IndexOf("BUS") > 0)
				{
					BodyStyle = "Truck/Bus";
				}
				else if (BodyDesc.ToUpper().IndexOf("UTE") > 0)
				{
					BodyStyle = "Ute";
				}
				else if (BodyDesc.ToUpper().IndexOf("VAN") > 0)
				{
					BodyStyle = "Van";
				}
				else if (BodyDesc.ToUpper().IndexOf("WAGON") > 0)
				{
					BodyStyle = "Wagon";
				}
			}
			catch (Exception ex)
			{
				log.Error("GetBodyStyle Failed! Error : " + ex);
			}
            return BodyStyle;
        }


        public string GetUserNewsLetterSubscriptionFlag()
		{
			string result = "No";
			try
			{
				var userId = HttpContext.Current.Session["easylist-username"].ToString();
				Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(userId);
				
				if (userInfo != null)
				{
					if (string.IsNullOrEmpty(userInfo.EmailOnNewsAndOffer))
					{
						result = "Yes";
					}
					else
					{
						result = userInfo.EmailOnNewsAndOffer;
					}
					
				}
			}
			catch(Exception ex)
			{
				//
			}

			return result.ToLower();
		}
		
		public string SaveUserNewsLetterSubscriptionFlag()
		{
			try
			{
				var userId = HttpContext.Current.Session["easylist-username"].ToString();
				Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(userId);
				
				string dbValue = "";
				if (userInfo != null)
				{
					if (!string.IsNullOrEmpty(userInfo.EmailOnNewsAndOffer))
					{
						dbValue = userInfo.EmailOnNewsAndOffer;
					}
				}
				
				string newValue = "No";
 				if (HttpContext.Current.Request["UserNewsLetterSubscriptionFlag"] != null)
 				{
 					newValue = "Yes";
 				}
				
				if (newValue.ToLower() != dbValue.ToLower())
				{
					userInfo.EmailOnNewsAndOffer = newValue;
					userInfo.EmailFormat = "emailHTMLFormat";
  					SSOHelper.UpdateUser(userInfo);
				}
			}
			catch(Exception ex)
			{
				//
			}

			return "";
		}

  	//--------------------------------------------------------------------------------------
  	// LM 20140429 : FREEM-137 - Basic Upload
  	public string GetUserCatalogListWithFeedInTemplateList(string SelectedUserCode, string SelectedCatalog)
	{
   		var HTMLControl = "";
   		try
   		{
			IRepository repo = RepositorySetup.Setup();

   			// Based on current user code
   			//var UserCodeList =  HttpContext.Current.Session["easylist-usercodelist"].ToString();
			var usercode =  HttpContext.Current.Session["easylist-usercode"].ToString();
 
			HTMLControl = "<div class='control-group' style='display:none'>";
			HTMLControl += "<label class='control-label'>Customer account</label>";
			HTMLControl += "<div class='controls'>";
			HTMLControl += "<select class='drop-down required' id='listing-usercode' name='listing-usercode'>";
		   
			
			 var UserInfo = repo.Single<Users>(u => u.UserCode == usercode);
		   
			 if (UserInfo != null)
			 {
			   // Moon 20140429: Get only parent user
			   //if (string.IsNullOrEmpty(UserInfo.ParentUserID))
			   //{
			  var LCAllList = repo.All<ListingCatalog>(lc => lc.UserCode == usercode && (lc.OnlineFlag != null && lc.OnlineFlag == true));
			 
			  var LCList = new List<LstCatalogFeedInTemplate>();
			  if (LCAllList.Count() > 0)
			  {
			   foreach (var c in LCAllList)
			   {
				var CatalogSelected = "0";
				if (SelectedCatalog == c.HotlistID) CatalogSelected = "1";
		 
				c.DisplayName = c.DisplayName.Replace("\"", "").Replace("\'", "");
				var DisplayName = c.DisplayName + " (" + c.HotlistID + ")";
		 
				var fiFileFormat = "";
				var fiType = "";
				if (!string.IsNullOrEmpty(c.FeedInTemplateSetting))
				{
				 var frTemplateInfo = repo.Single<FeedInTemplate>(f => f.TemplateName == c.FeedInTemplateSetting);
				 if (frTemplateInfo != null)
				 {
				  fiFileFormat = frTemplateInfo.SrcDataFormat.ToString() ;
				  fiType = frTemplateInfo.FeedInType.ToString() ;
				 }
				}
			  
				LCList.Add(new LstCatalogFeedInTemplate
				 {
				  ID = c.HotlistID, 
				  Name = DisplayName,
				  Selected = CatalogSelected,
				  FeedInTemplate = c.FeedInTemplateSetting,
				  FeedInFileFormat = fiFileFormat,
				  FeedInType = fiType
				 }
				);
			   }
			  }
			 
			  var LCListJSON = EasyList.Common.Helpers.Utils.ObjectToJSON(LCList);
			
			  var SelectedValue = "";
			  if (usercode == SelectedUserCode)
			  {
			   SelectedValue = "selected='selected'";
			  }
			  UserInfo.DealerName = UserInfo.DealerName.Replace("\"", "").Replace("\'", "");
			  HTMLControl += "<option value='" + usercode + "' data-catalog = '" + LCListJSON + "' " + SelectedValue + ">" + UserInfo.DealerName + " (" + UserInfo.UserName + ")</option>";
			   //}
	 			
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



	public string GetUserCatalogListWithFeedInTemplateListParentChild(string SelectedUserCode, string SelectedCatalog, bool OnlineOnly = true)
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
				HTMLControl += "<select class='drop-down required' id='listing-usercode' name='listing-usercode'>";
			
				foreach (var usercode in UCList)
				{
					var UserInfo = repo.Single<Users>(u => u.UserCode == usercode);
			
					if (UserInfo != null)
					{
   						var LCAllList = repo.All<ListingCatalog>(lc => lc.UserCode == usercode);
						if (OnlineOnly)
						{
		  					LCAllList = repo.All<ListingCatalog>(lc => lc.UserCode == usercode && (lc.OnlineFlag != null && lc.OnlineFlag == true));
						}
						
   						//-------------------------------------------------------------------------------
						//  Feed out Distribution list
						var CatalogDateFeedOutList = repo.All<FeedOutDistSettings>(lc => lc.UserCode == usercode && lc.InternalUse == false);
						//-------------------------------------------------------------------------------
							
						var LCList = new List<LstCatalogFeedInTemplate>();
						if (LCAllList.Count() > 0)
						{
							foreach (var c in LCAllList)
							{
								/***************************************
  								var FeedOutList = CatalogDateFeedOutList.Where(d => d.CatalogHotlistID == c.HotlistID).Select(d => d.DeliveryDesc).Distinct();
								var FeedOutCSVList = string.Join(",", FeedOutList);

								var CatalogSelected = "0";
								if (SelectedCatalog == c.HotlistUUID) CatalogSelected = "1";
								c.DisplayName = c.DisplayName.Replace("\"", "").Replace("\'", "");
	
  								//var DisplayName = c.DisplayName + " (" + c.HotlistID + ")";
								var DisplayName = c.HotlistID;
								if (!OnlineOnly)
								{
									if (c.OnlineFlag == true)
										DisplayName += "-On";
									else
										DisplayName += "-Off";
								}
									
								LCList.Add(new LstCatalog{
										ID = c.HotlistUUID, 
										Name = DisplayName, 
										Selected = CatalogSelected,
										FeedDestinationList = FeedOutCSVList
										}
								);

								***************************************/

								var CatalogSelected = "0";
								if (SelectedCatalog == c.HotlistID) CatalogSelected = "1";
		 
								c.DisplayName = c.DisplayName.Replace("\"", "").Replace("\'", "");
  								//var DisplayName = c.DisplayName + " (" + c.HotlistID + ")";
		 						var DisplayName = c.HotlistID;
								var fiFileFormat = "";
								var fiType = "";
								if (!string.IsNullOrEmpty(c.FeedInTemplateSetting))
								{
									 var frTemplateInfo = repo.Single<FeedInTemplate>(f => f.TemplateName == c.FeedInTemplateSetting);
									 if (frTemplateInfo != null)
									 {
									  fiFileFormat = frTemplateInfo.SrcDataFormat.ToString() ;
									  fiType = frTemplateInfo.FeedInType.ToString() ;
									 }
								}
			  
								LCList.Add(new LstCatalogFeedInTemplate
								 {
									  ID = c.HotlistID, 
									  Name = DisplayName,
									  Selected = CatalogSelected,
									  FeedInTemplate = string.IsNullOrEmpty(c.FeedInTemplateSetting) ? "" : c.FeedInTemplateSetting,
									  FeedInFileFormat = fiFileFormat,
									  FeedInType = fiType
								 }
								);
		
							}
						}

						var LCListJSON = EasyList.Common.Helpers.Utils.ObjectToJSON(LCList);

						var SelectedValue = "";
						if (usercode == SelectedUserCode)
						{
							 SelectedValue = "selected='selected'";
						}
						UserInfo.DealerName = UserInfo.DealerName.Replace("\"", "").Replace("\'", "");
						HTMLControl += "<option value='" + usercode + "' data-catalog = '" + LCListJSON + "' " + SelectedValue + ">" + UserInfo.DealerName + " (" + UserInfo.UserName + ")</option>";
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

	public string GetFormValue(string name)
        {
			HttpRequest Request =HttpContext.Current.Request;
            string result = "";
            if (!string.IsNullOrWhiteSpace(Request[name])) 
            { 
                result = Request[name].ToString();
            }
            return result;        
        }

	public class LstCatalogFeedInTemplate
	{
		public string ID { get;set;}
	   	public string Name { get;set; }
		public string Selected { get;set; }
	   	public string FeedInTemplate { get;set; }
		public string FeedInFileFormat { get;set; }
		public string FeedInType { get;set; }
	}
	//--------------------------------------------------------------------------------------

 	public class MatchingMotors
    {
        public string Styles { get; set; }

        public string Transmission { get; set; }

        public string GlassCode { get; set; }

        public string NVIC { get; set; }

        public string Variant { get; set; }

        public string Series { get; set; }

        public string Cylinder { get; set; }

        public string Engine { get; set; }

        public string EngineCC { get; set; }

    }

 //---------------Render Dynamically for FeedDestinationList ------------------------------
    public string GetUserCatalogListFeedDestination(string SelectedUserCode, string SelectedCatalog, bool OnlineOnly = true)
    {
        var XMLControl = "";
        try
        {
            IRepository repo = RepositorySetup.Setup();

            var UserCodeList = HttpContext.Current.Session["easylist-usercodelist"].ToString();

            var UCList = UserCodeList.Split(',');
            XMLControl = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
            XMLControl += "<AdsDistributionDestination>";
            
            foreach (var usercode in UCList)
            {
                var UserInfo = repo.Single<Users>(u => u.UserCode == usercode);

                if (UserInfo != null)
                {
                    var LCAllList = repo.All<ListingCatalog>(lc => lc.UserCode == usercode);
                    if (OnlineOnly)
                    {
                        LCAllList = repo.All<ListingCatalog>(lc => lc.UserCode == usercode && (lc.OnlineFlag != null && lc.OnlineFlag == true));
                    }

                    //-------------------------------------------------------------------------------
                    //  Feed out Distribution list
                    var CatalogDateFeedOutList = repo.All<FeedOutDistSettings>(lc => lc.UserCode == usercode && lc.InternalUse == false);
                    //-------------------------------------------------------------------------------

                    if (LCAllList.Count() > 0)
                    {
                        foreach (var c in LCAllList)
                        {
                            var FeedOutList = CatalogDateFeedOutList.Where(d => d.CatalogHotlistID == c.HotlistID).Select(d => d.DeliveryDesc).Distinct();
                            var FeedOutCSVList = string.Join(",", FeedOutList);
                            var FeedOutDestName = "";
                            var feedDestList = "";

                            string[] splitString = FeedOutCSVList.Split(',');

                            for (int i = 0; i < splitString.Length; i++)
                            {
                                //FeedOutDestName += string.Concat(string.Concat("<FeedDestinationName>", splitString[i]), "</FeedDestinationName>");
                                XMLControl += "<Catalog><ID>" + c.HotlistUUID + "</ID>" + string.Concat(string.Concat("<FeedDestinationName>", splitString[i]), "</FeedDestinationName>") +"</Catalog>";
                            }
                            //feedDestList += "<FeedDestinationList>" + FeedOutDestName + "</FeedDestinationList>";     
                        }
                    }
                }
            }  
        }
        catch (Exception ex)
        {
            log.Error("Failed! Error : " + ex);
        }
        finally
        {
            XMLControl += "</AdsDistributionDestination>";
        }

        return XMLControl;
    }

	public string SplitAtCapitalLetter(string str)
	{
		var checkCapital = new Regex(@"
                (?<=[A-Z])(?=[A-Z][a-z]) |
                 (?<=[^A-Z])(?=[A-Z]) |
                 (?<=[A-Za-z])(?=[^A-Za-z])", RegexOptions.IgnorePatternWhitespace);

		return checkCapital.Replace(str, " ");
 
	}
//---------------Render Dynamically for FeedDestinationList ------------------------------

]]>
	
</msxml:script>

</xsl:stylesheet>