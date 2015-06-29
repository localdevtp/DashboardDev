<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:ActScripts="urn:ActScripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <!-- C# helper scripts -->

  <msxml:script language="C#" implements-prefix="ActScripts">
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
    <msxml:assembly name="EasySales.Accounts"/>
    <msxml:assembly name="EasyList.Dashboard.Helpers"/>
    <msxml:assembly name="Componax.ExtensionMethods"/>
    <msxml:assembly name="System.Core"/>
    <msxml:assembly name="System.Xml.Linq"/>
    <msxml:assembly name="System.Data"/>
    <msxml:assembly name="System.Data.Linq"/>
    <msxml:assembly name="EasySales.EwayAPI"/>

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
    <msxml:using namespace="EasyList.Data.BL"/>
    <msxml:using namespace="EasyList.Common.Helpers"/>
    <msxml:using namespace="EasyList.Common.Helpers.Web"/>
    <msxml:using namespace="EasyList.Common.Helpers.Web.REST"/>
    <msxml:using namespace="EasyList.Data.DAL.Repository.Entity.Helpers"/>
    <msxml:using namespace="NLog" />
    <msxml:using namespace="Uniquemail.SingleSignOn" />
    <msxml:using namespace="EasySales.Accounts"/>
    <msxml:using namespace="EasySales.EwayAPI" />
    <msxml:using namespace="EasyList.Dashboard.Helpers" />
    <msxml:using namespace="Componax.ExtensionMethods" />
    <msxml:using namespace="EasySales.EwayAPI.SecurePayment.ResponsivePage" />
    <msxml:using namespace="EasySales.EwayAPI.SecurePayment" />
    
    <![CDATA[
    
	      static Logger log = LogManager.GetCurrentClassLogger();		
	      string SiteName = "dashboard.easylist.com.au";			

        public void CreateCustomerCreditCard()
        {
            DashBoardPaymentProvider dashBoardPaymentProvider = new DashBoardPaymentProvider();
            
            EasySales.Accounts.Account accInfo = GetCustomerAccount();
            if (accInfo != null) 
            {
                var createCreditCardRequest = CreateCustomerMessage(accInfo);
                createCreditCardRequest.Method = Method.CreateTokenCustomer;
            
                createCreditCardRequest.RedirectUrl = "http://localhost/account/payment-result.aspx?Id=" + accInfo.ID;
                createCreditCardRequest.CancelUrl = "http://localhost/account/payment-cancel.aspx";
            
                var accessCodeAuthorizationResponse = dashBoardPaymentProvider.CreateCreditCardPaymentMethod(createCreditCardRequest);
            
                if (accessCodeAuthorizationResponse.PaymentStatus == ServerResponseState.Success && 
                !string.IsNullOrEmpty(accessCodeAuthorizationResponse.SharedPaymentUrl))
                {
                  System.Web.HttpContext.Current.Response.Redirect(accessCodeAuthorizationResponse.SharedPaymentUrl);
                }
            }
        }
        
        public XPathNodeIterator GetCustomerCreditCard()
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            DashBoardPaymentProvider dashBoardPaymentProvider = new DashBoardPaymentProvider();
            EasySales.Accounts.Account accInfo = GetCustomerAccount();
            
            if (accInfo != null && accInfo.CustomerTokenId != null)
              nodeIterator = dashBoardPaymentProvider.GetCustomerCreditCard(accInfo.CustomerTokenId);
            return nodeIterator;
        }
        
        private EasySales.Accounts.Account GetCustomerAccount()
        {
          var UserID = HttpContext.Current.Session["easylist-username"].ToString();
          EasySales.Accounts.Account accInfo = null; 

          if (!string.IsNullOrEmpty(UserID))
          {
            accInfo = AccountHelper.GetAccount(UserID);
          }
          return accInfo ?? null;
        }
        
        private SendPaymentReponsiveMessage CreateCustomerMessage(EasySales.Accounts.Account account, string countryCode = "AU")
        {
          SendPaymentReponsiveMessage basicMessage = new SendPaymentReponsiveMessage();
          basicMessage.Customer.CompanyName = account.CompanyName;
          basicMessage.Customer.Email = account.PrimaryEmail;
          basicMessage.Customer.FirstName = account.FirstName;
          basicMessage.Customer.LastName = account.LastName;
          basicMessage.Customer.JobDescription = string.Empty;
          basicMessage.Customer.Mobile = account.ContactMobile;
          basicMessage.Customer.Phone = account.ContactPhone;
          basicMessage.Customer.Street1 = account.Address1;
          basicMessage.Customer.Street2 = account.Address2;
          basicMessage.Customer.City = account.CityTown;
          basicMessage.Customer.State = account.StateProvinceName;
          basicMessage.Customer.PostalCode = account.PostalCode;
          basicMessage.Customer.Title = "Mr.";
          basicMessage.Customer.Country = countryCode;
          return basicMessage;
        }

        public XPathNodeIterator GetInvoiceList()
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            try
            {
                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                if (string.IsNullOrEmpty(UserID))
                {
                    return ErrorNodeIterator("Failed to load invoice! No User ID exists!") ;
                }

                long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
                if (MainEmpID == 0)
                {
                    return ErrorNodeIterator( "Failed to load invoice! Master account not exists for your login id " + UserID + "!");
                }

                Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(MainEmpID);
                if (userInfo == null)
                {
                    return ErrorNodeIterator("Failed to load invoice! Master account info not exists for id " + MainEmpID + "!");
                }

                if (string.IsNullOrEmpty(userInfo.LoginName))
                {
                    return ErrorNodeIterator("Failed to load invoice! Master account login name not found for id " + MainEmpID + "!");
                }

                Account accInfo = AccountHelper.GetAccount(userInfo.LoginName);

                if (accInfo == null)
                {
                    return ErrorNodeIterator("Failed to load invoice! No master account exists for login id " + UserID + "!");
                }

			    List<ELInvoice> InvoiceList = (from i in accInfo.Invoices 
                                               orderby i.DueDate descending, i.ID descending
                                               select new ELInvoice { 
                                                   IsPaid = i.IsPaid, 
                                                   InvoiceNumber = i.InvoiceNumber,
                                                   DueDate = i.DueDate,
                                                   Total = i.TotalAmount,
                                                   StatusDescription = i.StatusDescription,
													InvoicePDFPath = i.InvoicePDFPath 
                                               }).ToList();

				var InvoiceListXML = InvoiceList.ToXml();

                nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(InvoiceListXML);
            }
            catch (Exception ex)
            {
                return ErrorNodeIterator("GetInvoice failed! Error:" + ex.ToString());
            }
            return nodeIterator;
        }

        public XPathNodeIterator GetPaymentList()
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            try
            {
                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                if (string.IsNullOrEmpty(UserID))
                {
                    return ErrorNodeIterator("Failed to load payment! No User ID exists!");
                }

                long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
                if (MainEmpID == 0)
                {
                    return ErrorNodeIterator("Failed to load payment! Master account not exists for your login id " + UserID + "!");
                }
                Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(MainEmpID);
                if (userInfo == null)
                {
                    return ErrorNodeIterator("Failed to load payment! Master account info not exists for id " + MainEmpID + "!");
                }
                if (string.IsNullOrEmpty(userInfo.LoginName))
                {
                    return ErrorNodeIterator("Failed to load payment! Master account login name not found for id " + MainEmpID + "!");
                }
                Account accInfo = AccountHelper.GetAccount(userInfo.LoginName);

                if (accInfo == null)
                {
                    return ErrorNodeIterator("Failed to load payment! No master account exists for login id " + UserID + "!");
                }

                List<ELPayment> InvoiceList = (from p in accInfo.Payments
                                               orderby p.PaymentDate descending, p.ID descending
                                               select new ELPayment
                                               {
                                                   PaymentDate = p.PaymentDate,
                                                   PaymentAmount = p.PaymentAmount,
                                                   PaymentMethod = p.PaymentMethod,
                                                   StatusDescription = p.StatusDescription
                                               }).ToList();

                var InvoiceListXML = InvoiceList.ToXml();

                nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(InvoiceListXML);
            }
            catch (Exception ex)
            {
                return ErrorNodeIterator("GetPaymentList failed! Error:" + ex.ToString());
            }
            return nodeIterator;
        }

        public XPathNodeIterator GetInvoice(string InvNo)
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            try
            {
                long invoiceNumber = 0;
				if (!long.TryParse(InvNo, out invoiceNumber))
				{
					return ErrorNodeIterator("Invalid invoice number " + InvNo + "!") ;
				}

                // Get current login ID
                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                if (string.IsNullOrEmpty(UserID))
                {
                    return ErrorNodeIterator("User ID not exists!") ;
                }

                // Find master employee ID
                long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
                if (MainEmpID == 0)
                {
                    return ErrorNodeIterator( "Master account for login id " + UserID + " not found in login list!");
                }

                // Get master account info
                Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(MainEmpID);
                if (userInfo == null)
                {
                    return ErrorNodeIterator("User account for master login id " + MainEmpID + " not found in login list!");
                }
                if (string.IsNullOrEmpty(userInfo.LoginName))
                {
                    return ErrorNodeIterator("No login name found for login id " + MainEmpID + "!");
                }
                Account accInfo = AccountHelper.GetAccount(userInfo.LoginName);

                Invoice InvoiceData = AccountHelper.GetInvoice(invoiceNumber);
                Account ToAccount = AccountHelper.GetAccount(InvoiceData.AccountID);

                // Check if the logged on user can view the invoice
				if (userInfo.LoginName != ToAccount.MemberID)
                {
                    return ErrorNodeIterator("No authorize access to invoice number " + invoiceNumber);
				}

                ELInvoice InvView = new ELInvoice();

                InvView.InvoiceNumber = invoiceNumber.ToString();
                
                InvView.AccDisplayName = accInfo.DisplayName;
                InvView.AccDisplayAddressHtml = accInfo.DisplayAddressHtml; ;

                InvView.IsCreditNote = InvoiceData.IsCreditNote;
                InvView.IssueDate = InvoiceData.IssueDate;
                InvView.DueDate = InvoiceData.DueDate;
                InvView.IsCreditNote = InvoiceData.IsCreditNote;

				InvView.IsOverDue = false;
                if (InvoiceData.IsPaid == false && InvoiceData.DueDate < DateTime.Now)
                {
                    InvView.IsOverDue = true;
                    InvView.StatusDescription = InvoiceData.StatusDescription;
                }

				InvView.Total = InvoiceData.TotalAmount;
				//InvView.SubTotal = InvoiceData.SubTotal;
                InvView.Tax = InvoiceData.TaxAmount;
                InvView.Discount = InvoiceData.Discount;
                InvView.OverdueAmount = InvoiceData.OverdueAmount;
                InvView.TotalDue = InvoiceData.TotalAmount;

				/*
                foreach (var bi in InvoiceData.InvoiceBillableItems)
                {

					InvView.BillableItems.Add(
                        new ELInvoiceItems { Description = bi.Description, Price  = bi.Price , BillingCycle = bi.BillableItem.BillingFrequencyDescription}
                        );
                }
				*/
                nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(InvView.ToXml());
            }
            catch (Exception ex)
            {
                return ErrorNodeIterator("GetInvoice failed! Error:" + ex.ToString());
            }
            return nodeIterator;
        }

		public string UpdateMasterAccountInfo(bool IsRetailUser = false)
        {
            string ErrMsg = "";
            try
            {
                log.Info("Updating Master Account info...");

                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                if (string.IsNullOrEmpty(UserID)) return "User ID not exists!";

                Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(UserID);

                // Check if EmployeeOf is null, then check if have binding to account
                if ((userInfo != null) && (userInfo.EmployeeOf == null || userInfo.EmployeeOf == 0) && (!string.IsNullOrEmpty(userInfo.LoginName)))
				{
                    var FirstName = HTTPFormHelpers.GetString("FirstName");
                    var LastName = HTTPFormHelpers.GetString("LastName");
                    var Email = HTTPFormHelpers.GetString("Email");
                    var ContactPhone = HTTPFormHelpers.GetString("ContactPhone");
                    var ContactFax = HTTPFormHelpers.GetString("ContactFax");
                    var ContactMobile = HTTPFormHelpers.GetString("ContactMobile");

					var CompanyName = "";
					var PrimaryEmail = "";
					var SecondaryEmail = "";
					if (!IsRetailUser)
					{
						CompanyName = HTTPFormHelpers.GetString("CompanyName");
						PrimaryEmail = HTTPFormHelpers.GetString("EmailInvoicesTo");
						SecondaryEmail = HTTPFormHelpers.GetString("EmailCCInvoicesTo");
					}else
					{
						CompanyName = FirstName;
						PrimaryEmail = Email;
						SecondaryEmail = Email;
					}
                    var AddressLine1 = HTTPFormHelpers.GetString("AddressLine1");
                    var AddressLine2 = HTTPFormHelpers.GetString("AddressLine2");

                    var CountryCode = HTTPFormHelpers.GetString("address-country-code");
                    var RegionID = HTTPFormHelpers.GetIntNotNull("address-region-id");
                    var RegionName = HTTPFormHelpers.GetString("address-region-name");
                    var Postalcode = HTTPFormHelpers.GetString("address-postalcode");
                    var District = HTTPFormHelpers.GetString("address-district");

                    Account accInfo = AccountHelper.GetAccount(userInfo.LoginName);
	
					if (accInfo != null)
					{
						accInfo.FirstName = FirstName;
						accInfo.LastName = LastName;
						accInfo.ContactPhone = ContactPhone;
						accInfo.ContactFax = ContactFax;
						accInfo.ContactMobile = ContactMobile;
	
						accInfo.Address1 = AddressLine1;
						accInfo.Address2 = AddressLine2;
	
						accInfo.CompanyName = CompanyName;
						accInfo.PrimaryEmail = PrimaryEmail;
						accInfo.SecondaryEmail = SecondaryEmail;
	
						accInfo.Country = CountryCode;
						accInfo.StateProvince = RegionName;
						accInfo.PostalCode = Postalcode;
						accInfo.CityTown = District;
	
						accInfo.Save();
	
						log.Info("Updated master account for user " + UserID);
					}
                }
            }
            catch (Exception ex)
            {
                ErrMsg = "UpdateMasterAccountInfo failed!" + ex.ToString();
                log.Error(ErrMsg);
            }
            return ErrMsg;
        }

        public bool IsAccountExits()
        {
            bool IsAccountExits = false;
            try
            {
                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                if (string.IsNullOrEmpty(UserID)) return false;

                long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
                if (MainEmpID != 0)
                {
                    Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(MainEmpID);
                    if (userInfo != null)
                    {
                        // Check if EmployeeOf is null, then check if have binding to account
                        if ((userInfo.EmployeeOf == null) && (!string.IsNullOrEmpty(userInfo.LoginName)))
                        {
                            Account accInfo = AccountHelper.GetAccount(userInfo.LoginName);

                            if (accInfo != null)
                            {
                                return true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("IsAccountExits failed! Error:" + ex.ToString());
                IsAccountExits = false;
            }
            return IsAccountExits;
        }

		//================================================================================================
		// Dealers
		//================================================================================================

		public XPathNodeIterator GetDealerAccountInfo(string LoginID = "", bool IsProfileMtn = false)
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
			string UserID = "";
            try
            {
		  		// User maintain own user account
				if (IsProfileMtn) {
 					UserID = HttpContext.Current.Session["easylist-username"].ToString();
					if (string.IsNullOrEmpty(UserID)) return ErrorNodeIterator("User ID not exists!");


					// Find root employee account info
					long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
					if (MainEmpID != 0)
					{
						Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(MainEmpID);
						 if (userInfo != null)
						 {
							  // Check if EmployeeOf is null, then check if have binding to account
							  if ((userInfo.EmployeeOf == null  || userInfo.EmployeeOf == 0) && (!string.IsNullOrEmpty(userInfo.LoginName)))
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

				Account accInfo = AccountHelper.GetAccount(LoginID);
	
				if (accInfo != null)
				{
					ELAccInfo NewAccInfo = new ELAccInfo();
					NewAccInfo.CompanyName = accInfo.CompanyName;
					NewAccInfo.ContactMobile = accInfo.ContactMobile;
					NewAccInfo.ContactPhone = accInfo.ContactPhone;
					NewAccInfo.DisplayAddressHtml = accInfo.DisplayAddressHtml;
					NewAccInfo.LoginName = accInfo.MemberID;
					NewAccInfo.PrimaryEmail = accInfo.PrimaryEmail;
					NewAccInfo.SecondaryEmail = accInfo.SecondaryEmail;
					NewAccInfo.CurrentOutstandingBalance = accInfo.CurrentOutstandingBalance;

					NewAccInfo.Company_TAC_Type = accInfo.Company_TAC_Type;
					NewAccInfo.Company_TAC_No = accInfo.Company_TAC_No;
					NewAccInfo.Company_Dealer_License = accInfo.Company_Dealer_License;
			
					NewAccInfo.Display_CompanyName = accInfo.Display_CompanyName;
					NewAccInfo.Display_ContactMobile = accInfo.Display_ContactMobile;
					NewAccInfo.Display_ContactPhone = accInfo.Display_ContactPhone;
					NewAccInfo.Display_PrimaryEmail = accInfo.Display_PrimaryEmail;
					NewAccInfo.Display_MapCode = accInfo.Display_MapCode;
					NewAccInfo.Display_Address1 = accInfo.Display_Address1;
					NewAccInfo.Display_Address2 = accInfo.Display_Address2;
					NewAccInfo.Display_CityTown = accInfo.Display_CityTown;
					NewAccInfo.Display_StateProvince = accInfo.Display_StateProvince;
					NewAccInfo.Display_Country = accInfo.Display_Country;
					NewAccInfo.Display_PostalCode = accInfo.Display_PostalCode;

					NewAccInfo.BillingContactName = accInfo.BillingContactName;
					NewAccInfo.Address1 = accInfo.Address1;
					NewAccInfo.Address2 = accInfo.Address2;
					NewAccInfo.CityTown = accInfo.CityTown;
					NewAccInfo.StateProvince = accInfo.StateProvince;
					NewAccInfo.Country = accInfo.Country;
					NewAccInfo.PostalCode = accInfo.PostalCode;
					NewAccInfo.ContactPhone = accInfo.ContactPhone;

					//----------------------------------------------------------------------------
					// Special handling for data migrated from TP
					//----------------------------------------------------------------------------
					if (!string.IsNullOrEmpty(accInfo.SalesLead_Email))
					{
						accInfo.SalesLead_Email = accInfo.SalesLead_Email.Replace(';',',').Replace(" ","");
					}

					NewAccInfo.SalesLead_Type = accInfo.SalesLead_Type;
					NewAccInfo.SalesLead_Email = accInfo.SalesLead_Email;
					NewAccInfo.SalesLead_Phone = accInfo.SalesLead_Phone;

					NewAccInfo.PaymentPreference = accInfo.PaymentPreference;
					NewAccInfo.PaymentBonus1 = accInfo.PaymentBonus1;
	  		  NewAccInfo.PaymentBonus2 = accInfo.PaymentBonus2;
		
  					// Credit card info
					CreditCardInfo ccInfo = accInfo.PrimaryCreditCard();

                	if (ccInfo != null){
						string CardNumberMasked = ccInfo.CardNumber.Substring(0, 4) + "********" + ccInfo.CardNumber.Substring(12, 4);
						ccInfo.CardNumber = CardNumberMasked;
						
						NewAccInfo.CreditCardType = ccInfo.CardType;
						NewAccInfo.CreditCardNo = CardNumberMasked;
					}else
					{
						NewAccInfo.CreditCardType = "";
						NewAccInfo.CreditCardNo = "";
					}
					log.Info("NewAccInfo.CreditCardNo => " + NewAccInfo.CreditCardNo );

					var accInfoXML = NewAccInfo.ToXml();
					nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(accInfoXML);
				}
            }
            catch (Exception ex)
            {
                return ErrorNodeIterator("GetAccountInfo failed for ID " + UserID + "! Error:" + ex.ToString());
            }
            return nodeIterator;
        }

		    public XPathNodeIterator GetAccountInfo()
        {
            var UserID = HttpContext.Current.Session["easylist-username"].ToString();
            var dashBoardPaymentServiceProvider = new DashBoardPaymentServiceProvider();
            return dashBoardPaymentServiceProvider.GetAccountInfo(UserID);
        }

        public XPathNodeIterator GetCreditCard()
        {
            XPathNodeIterator nodeIterator = null;
            nodeIterator = EasyList.Common.Helpers.Utils.XMLGetErrorIterator("");
            try
            {

                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                if (string.IsNullOrEmpty(UserID)) return ErrorNodeIterator("User ID not exists!");

                long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
                if (MainEmpID == 0)
                {
                    return ErrorNodeIterator("Master account not exists for login id " + UserID + "!");
                }

                Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(MainEmpID);
                if (userInfo == null)
                {
                    return ErrorNodeIterator("User account for master login id " + MainEmpID + " not found!");
                }

                if (string.IsNullOrEmpty(userInfo.LoginName))
                {
                    return ErrorNodeIterator("No login name found for login id " + MainEmpID + "!");
                }
                
                Account accInfo = AccountHelper.GetAccount(userInfo.LoginName);

                if (accInfo == null) return ErrorNodeIterator("Master account for login id " + UserID + " not exists!");
                CreditCardInfo ccInfo = accInfo.PrimaryCreditCard();

                if (ccInfo == null) return ErrorNodeIterator("No Payment method maintained for account " + UserID + "!");

				        string CardNumberMasked = ccInfo.CardNumber.Substring(0, 4) + "********" + ccInfo.CardNumber.Substring(12, 4);
                ccInfo.CardNumber = CardNumberMasked;

/*
				log.Info("Card Type => " + ccInfo.CardType);
                log.Info("Card No => " + ccInfo.CardNumber);
                log.Info("Card Expiry Month => " + ccInfo.ExpiryMonth);
                log.Info("Card Expiry Year => " + ccInfo.ExpiryYear);
                log.Info("Card Sec Number => " + ccInfo.SecurityNumber);
                log.Info("Card Issuing Bank => " + ccInfo.IssuingBank);
                log.Info("Card Payment method desc => " + ccInfo.PaymentMethodDescription);
*/

                var ccInfoXML = ccInfo.ToXml();

                nodeIterator = EasyList.Common.Helpers.Utils.XMLGetNodeIterator(ccInfoXML);
            }
            catch (Exception ex)
            {
                return ErrorNodeIterator("GetCreditCard failed! Error:" + ex.ToString());
            }
            
            return nodeIterator; 
        }

 		public string SaveCreditCard()
        {
            string ErrMsg = "";
            try
            {
                log.Info("Saving credit card ");

                var ccType = HTTPFormHelpers.GetString("ccType");
                var ccNo = HTTPFormHelpers.GetString("ccNo");
                var ccName = HTTPFormHelpers.GetString("ccName");
                var ccMonth = HTTPFormHelpers.GetString("ccMonth");
                var ccYear = HTTPFormHelpers.GetString("ccYear");
                var ccCvv2 = HTTPFormHelpers.GetString("ccCvv2");

                log.Info("====> " + ccType);
                //--------------------------------------------------------------------------------
                // Validation
                //--------------------------------------------------------------------------------
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
                //--------------------------------------------------------------------------------

                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                if (string.IsNullOrEmpty(UserID)) return "User ID not exists!";

                long MainEmpID = SSOHelper.FindRootEmployeeID(UserID);
                if (MainEmpID == 0)
                {
                    return "Master account for login id " + UserID + " not found in login list!";
                }
                Uniquemail.SingleSignOn.User userInfo = SSOHelper.GetUser(MainEmpID);
                if (userInfo == null)
                {
                    return "User account for master login id " + MainEmpID + " not found in login list!";
                }
                if (string.IsNullOrEmpty(userInfo.LoginName))
                {
                    return "No login name found for login id " + MainEmpID + "!";
                }
                Account accInfo = AccountHelper.GetAccount(userInfo.LoginName);
                
                // Remove if exists
                if (accInfo.PrimaryCreditCard() != null)
                {
                     accInfo.SetPrimaryCreditCard();
                     accInfo.Save();
                }

                CreditCardInfo newCCInfo = new CreditCardInfo();
                newCCInfo.CardType = ccType;
                newCCInfo.CardNumber = ccNo;
                newCCInfo.CardHolderName = ccName;
                newCCInfo.ExpiryMonth = int.Parse(ccMonth);
                newCCInfo.ExpiryYear = int.Parse(ccYear);
                newCCInfo.SecurityNumber = ccCvv2;

                accInfo.SetPrimaryCreditCard();
                accInfo.Save();
            }
            catch (Exception ex)
            {
                ErrMsg = "SaveCreditCard failed!" + ex.ToString();
                log.Error(ErrMsg);
            }
            return ErrMsg;
        }

 		    public string DeleteCreditCard()
        {
            var UserID = HttpContext.Current.Session["easylist-username"].ToString();
            var dashBoardPaymentServiceProvider = new DashBoardPaymentServiceProvider();
            return dashBoardPaymentServiceProvider.DeleteCreditCard(UserID);
        }

        public static string ProcesPayment()
        {
            var UserID = HttpContext.Current.Session["easylist-username"].ToString();
            var dashBoardPaymentServiceProvider = new DashBoardPaymentServiceProvider();
            return dashBoardPaymentServiceProvider.ProcesPayment(UserID);
        }
        
        public string UpdateCustomerCreditCard()
        {
            string ErrMsg = "";
            try
            {
                log.Info("Saving credit card ");
                
                var UserID = HttpContext.Current.Session["easylist-username"].ToString();
                
                DashBoardPaymentProvider dashBoardPaymentProvider = new DashBoardPaymentProvider();
                var accessCodeAuthorizationResponse = dashBoardPaymentProvider.UpdateCreditCardPaymentMethod(UserID, 
                "http://localhost/account/payment-method", "http://localhost/account/payment-method");
                
                if (accessCodeAuthorizationResponse.PaymentStatus == ServerResponseState.Success && 
                !string.IsNullOrEmpty(accessCodeAuthorizationResponse.SharedPaymentUrl))
                {
                  System.Web.HttpContext.Current.Response.Redirect(accessCodeAuthorizationResponse.SharedPaymentUrl);
                }
            }
            catch (Exception ex)
            {
                ErrMsg  = ex.Message;
            }
            
            return ErrMsg;
          }
          
          
  		  #region Helpers

 		    public XPathNodeIterator ErrorNodeIterator(string ErrMsg)
        {
            log.Error(ErrMsg);
            return EasyList.Common.Helpers.Utils.XMLGetErrorIterator(ErrMsg);
        }
		
		  public string FormatPrice(string price, string prefix = "")
      {
			if(string.IsNullOrEmpty(price)) return "$0.00";
			
			var p = decimal.Parse(price);

			if(p == 0) return "$0.00";
			return string.Format("{0}{1}",
			  prefix,
			  p.ToString("C"));
		}

		#endregion
		//-------------------------------------------------------------------------------

		//-------------------------------------------------------------------------------
  		#region HelperClass
		public class ELAccInfo
		{	
			public string LoginName { get; set; }
			public string CompanyName { get; set; }
			public string ContactPhone { get; set; }
			public string DisplayAddressHtml { get; set; }
			public string PrimaryEmail { get; set; }
			public string SecondaryEmail { get; set; }
			public decimal CurrentOutstandingBalance { get; set; }

			public string Company_TAC_Type { get; set; }
			public string Company_TAC_No { get; set; }
			public string Company_Dealer_License { get; set; }

			public string Display_CompanyName { get; set; }
			public string Display_ContactMobile { get; set; }
			public string Display_ContactPhone { get; set; }
			public string Display_PrimaryEmail { get; set; }
			public string Display_MapCode { get; set; }
			public string Display_Address1 { get; set; }
			public string Display_Address2 { get; set; }
			public string Display_CityTown { get; set; }
			public string Display_StateProvince { get; set; }
			public string Display_Country { get; set; }
			public string Display_PostalCode { get; set; }

			public string BillingContactName { get; set; }
			public string Address1 { get; set; }
			public string Address2 { get; set; }
			public string CityTown { get; set; }
			public string StateProvince { get; set; }
			public string Country { get; set; }
			public string PostalCode { get; set; }
			public string ContactMobile { get; set; }

			public string SalesLead_Type { get; set; }
			public string SalesLead_Email { get; set; }
			public string SalesLead_Phone { get; set; }		

			public string CreditCardType { get; set; }
			public string CreditCardNo { get; set; }

			public string PaymentPreference { get; set; }
			public string PaymentBonus1 { get; set; }
			public string PaymentBonus2 { get; set; }
      
      public long? CustomerTokenId { get; set; }

		}

		public class ELInvoice
        {
            public ELInvoice()
            {
                BillableItems = new List<ELInvoiceItems>();
            }

            public string InvoiceNumber { get; set; }

            public string AccDisplayName { get; set; }
            public string AccDisplayAddressHtml { get; set; }

            public bool IsCreditNote { get; set; }
			public bool IsPaid { get; set; }

 			public bool IsOverDue { get; set; }
            public string StatusDescription { get; set; }


            public DateTime IssueDate { get; set; }
            public DateTime DueDate { get; set; }

            public decimal Total { get; set; }
            public decimal SubTotal { get; set; }
            public decimal Tax { get; set; }
            public decimal Discount { get; set; }
            public decimal OverdueAmount { get; set; }
            public decimal TotalDue { get; set; }
			public string InvoicePDFPath { get; set; }

            public List<ELInvoiceItems> BillableItems { get; set; }
        }

        public class ELInvoiceItems
        {
            public string Description { get; set; }
            public string BillingCycle { get; set; }
            public decimal Price { get; set; }
        }

 		public class ELPayment
        {
            public DateTime PaymentDate { get; set; }
            public decimal PaymentAmount { get; set; }
            public PaymentMethod PaymentMethod { get; set; }
            public string StatusDescription { get; set; }
        }

		
		#endregion
		//-------------------------------------------------------------------------------

]]>

  </msxml:script>

</xsl:stylesheet>